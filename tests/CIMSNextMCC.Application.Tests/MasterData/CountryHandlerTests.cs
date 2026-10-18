using CIMSNextMCC.Application.Common.Exceptions;
using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.MasterData.Country;
using CIMSNextMCC.Domain.Entities.MasterData;
using CIMSNextMCC.Domain.Entities.Security;
using FluentValidation;

namespace CIMSNextMCC.Application.Tests.MasterData;

public class CountryHandlerTests
{
    private static CountryMaster Row(string code, string name, string cargo = "Both") =>
        new() { CountryCode = code, CountryName = name, CargoMovement = cargo, EnterBy = "e", UpdateBy = "" };

    private static SaveCountryDataHandler SaveHandler(FakeCountryRepository repository, params LegacyUser[] users) =>
        new(repository, AuditUser.Resolver(users), new SaveCountryDataValidator());

    [Fact]
    public async Task List_maps_every_column_in_repository_order()
    {
        var created = new DateTime(2026, 8, 21, 9, 38, 42);
        var repository = new FakeCountryRepository
        {
            Rows =
            [
                new CountryMaster { CountryCode = "AE", CountryName = "UAE", CargoMovement = "Both", DateEnter = created, EnterBy = "x", UpdateBy = "", ContractBlock = true },
                Row("IND", "INDIA"),
            ],
        };

        var result = await new GetCountryListHandler(repository).HandleAsync(new GetCountryListQuery());

        Assert.True(result.IsSuccess);
        Assert.Equal(["AE", "IND"], result.Data!.Select(d => d.CountryCode));
        Assert.Equal(new CountryDto("AE", "UAE", "Both", created, "x", null, "", true), result.Data![0]);
    }

    [Fact]
    public async Task Data_returns_the_row_or_the_not_found_code()
    {
        var handler = new GetCountryDataHandler(new FakeCountryRepository { Rows = [Row("IND", "INDIA")] }, new GetCountryDataValidator());

        var found = await handler.HandleAsync(new GetCountryDataQuery("ind"));
        var missing = await handler.HandleAsync(new GetCountryDataQuery("ZZZ"));

        Assert.True(found.IsSuccess);
        Assert.Equal("INDIA", found.Data!.CountryName);
        Assert.False(missing.IsSuccess);
        Assert.Equal("COUNTRY_NOT_FOUND", missing.MessageCode);
    }

    [Fact]
    public async Task Data_rejects_a_code_longer_than_the_column()
    {
        var handler = new GetCountryDataHandler(new FakeCountryRepository(), new GetCountryDataValidator());

        await Assert.ThrowsAsync<ValidationException>(() => handler.HandleAsync(new GetCountryDataQuery(new string('A', 11))));
    }

    [Fact]
    public async Task Search_passes_the_typed_text_and_mode_and_maps_the_hits()
    {
        var repository = new FakeCountryRepository { Hits = [new CountryNameHit { CountryCode = "IND", CountryName = "INDIA", CargoMovement = "Both" }] };
        var handler = new FindCountryNameHandler(repository, new FindCountryNameValidator());

        var result = await handler.HandleAsync(new FindCountryNameQuery("In", StartsWith: true));

        Assert.Equal(("In", true), repository.LastSearch);
        Assert.Equal([new CountryNameHitDto("IND", "INDIA", "Both")], result.Data);
    }

    [Fact]
    public async Task New_calls_CountryAdd_with_the_PwInfo_UserId_as_EnterBy()
    {
        var repository = new FakeCountryRepository();

        var result = await SaveHandler(repository, new LegacyUser { UserName = "floor1", UserId = "`djdXYZ" })
            .HandleAsync(new SaveCountryDataCommand(SaveMode.New, "ZZT1", "ZZ TEST", "Imports"));

        Assert.Equal(new SaveCountryResultDto("ZZT1", "Data Saved Successfully"), result.Data);
        Assert.Equal(["CountryAdd(ZZT1,ZZ TEST,Imports,`djdXYZ)"], repository.Calls);
    }

    [Fact]
    public async Task Change_calls_CountryEdit_with_the_PwInfo_UserId_as_UpdateBy()
    {
        var repository = new FakeCountryRepository { Rows = [Row("ZZT1", "ZZ TEST")] };

        var result = await SaveHandler(repository).HandleAsync(new SaveCountryDataCommand(SaveMode.Change, "ZZT1", "ZZ TEST 2", "Export"));

        Assert.True(result.IsSuccess);
        Assert.Equal(["CountryEdit(ZZT1,ZZ TEST 2,Export,U-0001)"], repository.Calls);
    }

    [Fact]
    public async Task New_with_an_existing_code_is_a_409_and_writes_nothing()
    {
        var repository = new FakeCountryRepository { Rows = [Row("IND", "INDIA")] };

        var ex = await Assert.ThrowsAsync<AppException>(() =>
            SaveHandler(repository).HandleAsync(new SaveCountryDataCommand(SaveMode.New, "ind", "India again", "Both")));

        Assert.Equal(409, ex.StatusCode);
        Assert.Equal("COUNTRY_CODE_EXISTS", ex.MessageCode);
        Assert.Empty(repository.Calls);
    }

    [Fact]
    public async Task Change_of_an_unknown_code_is_a_404_and_writes_nothing()
    {
        var repository = new FakeCountryRepository();

        var ex = await Assert.ThrowsAsync<NotFoundException>(() =>
            SaveHandler(repository).HandleAsync(new SaveCountryDataCommand(SaveMode.Change, "ZZT1", "x", "Both")));

        Assert.Equal("COUNTRY_CODE_NOT_FOUND", ex.MessageCode);
        Assert.Empty(repository.Calls);
    }

    [Fact]
    public async Task Validation_reports_the_name_before_the_code_with_the_legacy_texts()
    {
        var ex = await Assert.ThrowsAsync<ValidationException>(() =>
            SaveHandler(new FakeCountryRepository()).HandleAsync(new SaveCountryDataCommand(SaveMode.New, "", "", "Both")));

        Assert.Equal(["Enter Country Name", "Enter Country Code"], ex.Errors.Select(e => e.ErrorMessage));
    }

    [Theory]
    [InlineData("ZZT1", "N", "Nowhere")]
    [InlineData("12345678901", "N", "Both")]
    public async Task Validation_rejects_an_unknown_cargo_movement_and_a_too_long_code(string code, string name, string cargo)
    {
        await Assert.ThrowsAsync<ValidationException>(() =>
            SaveHandler(new FakeCountryRepository()).HandleAsync(new SaveCountryDataCommand(SaveMode.New, code, name, cargo)));
    }

    [Fact]
    public async Task Validation_rejects_a_name_longer_than_50()
    {
        await Assert.ThrowsAsync<ValidationException>(() =>
            SaveHandler(new FakeCountryRepository()).HandleAsync(new SaveCountryDataCommand(SaveMode.New, "ZZT1", new string('N', 51), "Both")));
    }

    [Fact]
    public async Task An_unknown_PwInfo_user_is_refused_before_anything_is_written()
    {
        var repository = new FakeCountryRepository();
        var handler = new SaveCountryDataHandler(
            repository,
            new CIMSNextMCC.Application.Common.Security.LegacyAuditUserResolver(
                new FakeLegacyUserRepositoryNone(), new CIMSNextMCC.Application.Tests.Arrivals.FakeCurrentUser("floor1")),
            new SaveCountryDataValidator());

        var ex = await Assert.ThrowsAsync<ForbiddenException>(() =>
            handler.HandleAsync(new SaveCountryDataCommand(SaveMode.New, "ZZT1", "ZZ TEST", "Both")));

        Assert.Equal("LEGACY_USER_NOT_FOUND", ex.MessageCode);
        Assert.Empty(repository.Calls);
    }
}

internal sealed class FakeLegacyUserRepositoryNone : CIMSNextMCC.Application.Interfaces.Repositories.Security.ILegacyUserRepository
{
    public Task<IReadOnlyList<LegacyUser>> FindByUserNameAsync(string userName, CancellationToken cancellationToken = default) =>
        Task.FromResult<IReadOnlyList<LegacyUser>>([]);
}
