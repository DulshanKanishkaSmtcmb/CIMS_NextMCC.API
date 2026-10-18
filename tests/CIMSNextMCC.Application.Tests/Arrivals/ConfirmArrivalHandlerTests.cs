using CIMSNextMCC.Application.Arrivals.ConfirmArrival;
using CIMSNextMCC.Application.Common.Exceptions;
using CIMSNextMCC.Domain.Entities.Security;
using FluentValidation;

namespace CIMSNextMCC.Application.Tests.Arrivals;

public class ConfirmArrivalHandlerTests
{
    private static readonly DateTime Arrival = new(2026, 10, 18, 14, 30, 0, DateTimeKind.Unspecified);
    private static readonly DateTime Etd = new(2026, 10, 17);

    private static (ConfirmArrivalHandler Handler, FakeConfirmArrivalRepository Repository, FakeLegacyUserRepository Users) Create(
        FakeConfirmArrivalRepository? repository = null,
        params LegacyUser[] users)
    {
        repository ??= new FakeConfirmArrivalRepository();
        var legacyUsers = new FakeLegacyUserRepository(
            users.Length > 0 ? users : [new LegacyUser { UserName = "floor1", UserId = "U-0001" }]);
        var handler = new ConfirmArrivalHandler(repository, legacyUsers, new FakeCurrentUser("floor1"), new ConfirmArrivalValidator());
        return (handler, repository, legacyUsers);
    }

    private static ConfirmArrivalContainer Container(decimal vesselOrderNo = 1, decimal containerOrderNo = 2) =>
        new(Etd, vesselOrderNo, "MSC ANNA", containerOrderNo, "LR-77", "MSCU1234567", "40HC");

    [Fact]
    public async Task Confirms_each_selected_contract_in_grid_order_with_the_legacy_values()
    {
        var (handler, repository, users) = Create();

        var result = await handler.HandleAsync(new ConfirmArrivalCommand(Arrival, ["R0002", "R0001"], Container: null));

        Assert.True(result.IsSuccess);
        Assert.Equal(new ConfirmArrivalResultDto(2, false, false, "Data Saved Successfully"), result.Data);
        Assert.Equal(
            [
                "CargoReceivedConfirmArrival(R0002,Update,2026-10-18T14:30,[])",
                "CargoReceivedConfirmArrival(R0001,Update,2026-10-18T14:30,[])",
            ],
            repository.Calls);
        Assert.Equal(0, users.Lookups);
    }

    [Fact]
    public async Task Updates_vessel_then_container_then_contracts_like_the_legacy_save()
    {
        var (handler, repository, _) = Create();

        var result = await handler.HandleAsync(new ConfirmArrivalCommand(Arrival, ["R0001"], Container()));

        Assert.Equal(new ConfirmArrivalResultDto(1, true, true, "Data Saved Successfully"), result.Data);
        Assert.Equal(
            [
                "VesselRegistryImportConfirmArrival(2026-10-17,1,MSC ANNA)",
                "ContainerDataImportEdit(2026-10-17,1,2,MSCU1234567,40HC,U-0001,LR-77)",
                "CargoReceivedConfirmArrival(R0001,Update,2026-10-18T14:30,[])",
            ],
            repository.Calls);
    }

    [Fact]
    public async Task Load_reference_goes_to_NextContainerNo_and_UpdateBy_is_the_PwInfo_UserId()
    {
        var (handler, repository, _) = Create(null, new LegacyUser { UserName = "floor1", UserId = "`djdXYZ" });

        await handler.HandleAsync(new ConfirmArrivalCommand(Arrival, ["R0001"], Container()));

        Assert.Equal("LR-77", repository.LastContainerUpdate!.NextContainerNo);
        Assert.Equal("`djdXYZ", repository.LastContainerUpdate.UpdateBy);
    }

    [Fact]
    public async Task Skips_vessel_and_container_when_their_order_numbers_are_zero()
    {
        var (handler, repository, users) = Create();

        var result = await handler.HandleAsync(new ConfirmArrivalCommand(Arrival, ["R0001"], Container(0, 0)));

        Assert.Equal(new ConfirmArrivalResultDto(1, false, false, "Data Saved Successfully"), result.Data);
        Assert.Equal(["CargoReceivedConfirmArrival(R0001,Update,2026-10-18T14:30,[])"], repository.Calls);
        Assert.Equal(0, users.Lookups);
    }

    [Fact]
    public async Task Updates_only_the_vessel_when_the_container_order_is_zero()
    {
        var (handler, repository, _) = Create();

        await handler.HandleAsync(new ConfirmArrivalCommand(Arrival, ["R0001"], Container(vesselOrderNo: 3, containerOrderNo: 0)));

        Assert.Equal(2, repository.Calls.Count);
        Assert.StartsWith("VesselRegistryImportConfirmArrival(2026-10-17,3,", repository.Calls[0]);
    }

    [Fact]
    public async Task Keeps_duplicate_rows_like_the_legacy_page()
    {
        var (handler, repository, _) = Create();

        var result = await handler.HandleAsync(new ConfirmArrivalCommand(Arrival, ["R0001", "R0001"], null));

        Assert.Equal(2, result.Data!.ContractsConfirmed);
        Assert.Equal(2, repository.Calls.Count);
    }

    [Fact]
    public async Task Refuses_to_write_when_the_caller_has_no_unique_PwInfo_row()
    {
        var (handler, repository, _) = Create(null, new LegacyUser { UserName = "someone-else", UserId = "X" });

        var ex = await Assert.ThrowsAsync<ForbiddenException>(() =>
            handler.HandleAsync(new ConfirmArrivalCommand(Arrival, ["R0001"], Container(vesselOrderNo: 0))));

        Assert.Equal(ConfirmArrivalHandler.LegacyUserNotFound, ex.MessageCode);
        Assert.Empty(repository.Calls);
    }

    [Fact]
    public async Task A_failing_procedure_propagates_so_the_transaction_rolls_back()
    {
        var (handler, _, _) = Create(new FakeConfirmArrivalRepository { FailOnRcvNo = "R0002" });

        await Assert.ThrowsAsync<InvalidOperationException>(() =>
            handler.HandleAsync(new ConfirmArrivalCommand(Arrival, ["R0001", "R0002"], null)));
    }

    [Fact]
    public async Task Missing_arrival_date_uses_the_legacy_message()
    {
        var (handler, repository, _) = Create();

        var ex = await Assert.ThrowsAsync<ValidationException>(() =>
            handler.HandleAsync(new ConfirmArrivalCommand(default, ["R0001"], null)));

        Assert.Contains(ex.Errors, e => e.ErrorMessage == "Enter Confirm Arrival Date");
        Assert.Empty(repository.Calls);
    }

    [Fact]
    public async Task Empty_selection_uses_the_legacy_server_message()
    {
        var (handler, _, _) = Create();

        var ex = await Assert.ThrowsAsync<ValidationException>(() =>
            handler.HandleAsync(new ConfirmArrivalCommand(Arrival, [], null)));

        Assert.Contains(ex.Errors, e => e.ErrorMessage == "Contract Data not found.[Empty List]");
    }

    [Fact]
    public async Task Rejects_a_utc_arrival_date_because_the_column_holds_local_time()
    {
        var (handler, _, _) = Create();

        await Assert.ThrowsAsync<ValidationException>(() =>
            handler.HandleAsync(new ConfirmArrivalCommand(new DateTime(2026, 10, 18, 9, 0, 0, DateTimeKind.Utc), ["R0001"], null)));
    }

    [Theory]
    [InlineData("12345678901", "MSCU1234567")] // RcvNo longer than nvarchar(10)
    [InlineData("R0001", "MSCU1234567-EXTRA-LONG")] // ContainerNo longer than nvarchar(20)
    public async Task Rejects_values_longer_than_the_procedure_parameters(string rcvNo, string containerNo)
    {
        var (handler, repository, _) = Create();
        var container = Container() with { ContainerNo = containerNo };

        await Assert.ThrowsAsync<ValidationException>(() =>
            handler.HandleAsync(new ConfirmArrivalCommand(Arrival, [rcvNo], container)));
        Assert.Empty(repository.Calls);
    }
}
