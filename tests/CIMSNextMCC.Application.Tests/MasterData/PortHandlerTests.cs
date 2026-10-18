using CIMSNextMCC.Application.Common.Exceptions;
using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.MasterData.Ports;
using CIMSNextMCC.Domain.Entities.MasterData;
using CIMSNextMCC.Domain.Entities.Security;
using FluentValidation;

namespace CIMSNextMCC.Application.Tests.MasterData;

public class PortHandlerTests
{
    private static PortMaster Row(string code, string name, string country = "IND", bool divertable = false) =>
        new() { PortCode = code, PortName = name, CountryCode = country, IsDivertable = divertable };

    private static SavePortDataHandler SaveHandler(FakePortRepository repository, params LegacyUser[] users) =>
        new(repository, AuditUser.Resolver(users), new SavePortDataValidator());

    [Fact]
    public async Task List_maps_every_column_and_treats_an_empty_country_as_no_filter()
    {
        var repository = new FakePortRepository { Rows = [Row("AEJEA", "JEBEL ALI", "AE", true)] };
        var handler = new GetPortListHandler(repository, new GetPortListValidator());

        var result = await handler.HandleAsync(new GetPortListQuery(""));

        Assert.Null(repository.LastCountryFilter);
        Assert.Equal(new PortDto("AEJEA", "JEBEL ALI", "AE", null, "", null, "", "", true), result.Data!.Single());
    }

    [Fact]
    public async Task List_passes_a_country_filter_through()
    {
        var repository = new FakePortRepository();

        await new GetPortListHandler(repository, new GetPortListValidator()).HandleAsync(new GetPortListQuery("CHN"));

        Assert.Equal("CHN", repository.LastCountryFilter);
    }

    [Fact]
    public async Task Data_returns_the_row_or_the_not_found_code()
    {
        var handler = new GetPortDataHandler(new FakePortRepository { Rows = [Row("DEL", "DELHI")] }, new GetPortDataValidator());

        var found = await handler.HandleAsync(new GetPortDataQuery("del"));
        var missing = await handler.HandleAsync(new GetPortDataQuery("ZZT1"));

        Assert.Equal("DELHI", found.Data!.PortName);
        Assert.Equal("PORT_NOT_FOUND", missing.MessageCode);
    }

    [Fact]
    public async Task Search_passes_the_typed_text_and_mode_and_maps_the_hits()
    {
        var repository = new FakePortRepository { Hits = [new PortNameHit { PortCode = "DEL", PortName = "DELHI", CountryCode = "IND" }] };

        var result = await new FindPortNameHandler(repository, new FindPortNameValidator()).HandleAsync(new FindPortNameQuery("D", StartsWith: false));

        Assert.Equal(("D", false), repository.LastSearch);
        Assert.Equal([new PortNameHitDto("DEL", "DELHI", "IND")], result.Data);
    }

    [Fact]
    public async Task New_calls_PortsAdd_with_the_PwInfo_UserId_as_CreateBy()
    {
        var repository = new FakePortRepository();

        var result = await SaveHandler(repository).HandleAsync(new SavePortDataCommand(SaveMode.New, "ZZT1", "ZZ PORT", "IND", true));

        Assert.Equal(new SavePortResultDto("ZZT1", "Data Saved Successfully"), result.Data);
        Assert.Equal(["PortsAdd(ZZT1,ZZ PORT,IND,True,U-0001)"], repository.Calls);
    }

    [Fact]
    public async Task Change_calls_PortsEdit_with_the_PwInfo_UserId_as_UpdateBy()
    {
        var repository = new FakePortRepository { Rows = [Row("ZZT1", "ZZ PORT")] };

        await SaveHandler(repository).HandleAsync(new SavePortDataCommand(SaveMode.Change, "ZZT1", "ZZ PORT 2", "CHN", false));

        Assert.Equal(["PortsEdit(ZZT1,ZZ PORT 2,CHN,False,U-0001)"], repository.Calls);
    }

    [Fact]
    public async Task A_port_can_be_saved_without_a_country_like_on_the_legacy_page()
    {
        var repository = new FakePortRepository();

        var result = await SaveHandler(repository).HandleAsync(new SavePortDataCommand(SaveMode.New, "ZZT2", "NO COUNTRY", "", false));

        Assert.True(result.IsSuccess);
        Assert.Equal(["PortsAdd(ZZT2,NO COUNTRY,,False,U-0001)"], repository.Calls);
    }

    [Fact]
    public async Task New_with_an_existing_code_is_a_409_and_Change_of_an_unknown_code_a_404()
    {
        var repository = new FakePortRepository { Rows = [Row("DEL", "DELHI")] };
        var handler = SaveHandler(repository);

        var exists = await Assert.ThrowsAsync<AppException>(() => handler.HandleAsync(new SavePortDataCommand(SaveMode.New, "DEL", "x", "IND", false)));
        var unknown = await Assert.ThrowsAsync<NotFoundException>(() => handler.HandleAsync(new SavePortDataCommand(SaveMode.Change, "ZZT1", "x", "IND", false)));

        Assert.Equal((409, "PORT_CODE_EXISTS"), (exists.StatusCode, exists.MessageCode));
        Assert.Equal("PORT_CODE_NOT_FOUND", unknown.MessageCode);
        Assert.Empty(repository.Calls);
    }

    [Fact]
    public async Task Validation_reports_the_name_before_the_code_with_the_legacy_texts()
    {
        var ex = await Assert.ThrowsAsync<ValidationException>(() =>
            SaveHandler(new FakePortRepository()).HandleAsync(new SavePortDataCommand(SaveMode.New, "", "", "IND", false)));

        Assert.Equal(["Enter Port Name", "Enter Port Code"], ex.Errors.Select(e => e.ErrorMessage));
    }

    [Theory]
    [InlineData("12345678901", "N", "IND")]
    [InlineData("ZZT1", "N", "12345678901")]
    public async Task Validation_rejects_values_longer_than_the_columns(string code, string name, string country)
    {
        await Assert.ThrowsAsync<ValidationException>(() =>
            SaveHandler(new FakePortRepository()).HandleAsync(new SavePortDataCommand(SaveMode.New, code, name, country, false)));
    }

    [Fact]
    public async Task An_unknown_PwInfo_user_is_refused_before_anything_is_written()
    {
        var repository = new FakePortRepository();
        var handler = new SavePortDataHandler(
            repository,
            new CIMSNextMCC.Application.Common.Security.LegacyAuditUserResolver(
                new FakeLegacyUserRepositoryNone(), new CIMSNextMCC.Application.Tests.Arrivals.FakeCurrentUser("floor1")),
            new SavePortDataValidator());

        await Assert.ThrowsAsync<ForbiddenException>(() => handler.HandleAsync(new SavePortDataCommand(SaveMode.New, "ZZT1", "x", "IND", false)));

        Assert.Empty(repository.Calls);
    }
}
