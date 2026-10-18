using CIMSNextMCC.Application.Common.Exceptions;
using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.MasterData.DC;
using CIMSNextMCC.Domain.Entities.MasterData;
using FluentValidation;

namespace CIMSNextMCC.Application.Tests.MasterData;

public class DcHandlerTests
{
    private static DcMaster Row(string name, string country = "US") => new() { WhCode = "3905", WhDes = name, CountryCode = country, LoadingOrder = 3, StockUpdate = true, BrandText = null };

    private static SaveDcDataHandler SaveHandler(FakeDcRepository repository) => new(repository, new SaveDcDataValidator());

    [Fact]
    public async Task List_maps_every_column_in_repository_order()
    {
        var repository = new FakeDcRepository { Rows = [Row("Kohls Online"), Row("Zalora Online", "MYS")] };

        var result = await new GetDcListHandler(repository).HandleAsync(new GetDcListQuery());

        Assert.Equal(["Kohls Online", "Zalora Online"], result.Data!.Select(d => d.WhDes));
        var first = result.Data![0];
        Assert.Equal(("3905", "US", 3m, true, null), (first.WhCode, first.CountryCode, first.LoadingOrder, first.StockUpdate, first.BrandText));
    }

    [Fact]
    public async Task Data_returns_the_row_or_the_not_found_code()
    {
        var handler = new GetDcDataHandler(new FakeDcRepository { Rows = [Row("Re-Export", "Dubai")] }, new GetDcDataValidator());

        var found = await handler.HandleAsync(new GetDcDataQuery("Re-Export"));
        var missing = await handler.HandleAsync(new GetDcDataQuery("Nowhere DC"));

        Assert.Equal("Dubai", found.Data!.CountryCode);
        Assert.Equal("DC_NOT_FOUND", missing.MessageCode);
    }

    [Fact]
    public async Task New_calls_DestWarehouseAdd_with_the_legacy_single_space_WhCode()
    {
        var repository = new FakeDcRepository();

        var result = await SaveHandler(repository).HandleAsync(new SaveDcDataCommand(SaveMode.New, "ZZT1 DC", "IND"));

        Assert.Equal(new SaveDcResultDto("ZZT1 DC", "Data Saved Successfully"), result.Data);
        Assert.Equal(["DestWarehouseAdd([ ],ZZT1 DC,IND)"], repository.Calls);
    }

    [Fact]
    public async Task Change_calls_DestWarehouseEdit()
    {
        var repository = new FakeDcRepository { Rows = [Row("ZZT1 DC", "IND")] };

        await SaveHandler(repository).HandleAsync(new SaveDcDataCommand(SaveMode.Change, "ZZT1 DC", "UK"));

        Assert.Equal(["DestWarehouseEdit([ ],ZZT1 DC,UK)"], repository.Calls);
    }

    [Fact]
    public async Task A_DC_can_be_saved_without_a_country_like_on_the_legacy_page()
    {
        var repository = new FakeDcRepository();

        var result = await SaveHandler(repository).HandleAsync(new SaveDcDataCommand(SaveMode.New, "ZZT2 DC", ""));

        Assert.True(result.IsSuccess);
    }

    [Fact]
    public async Task New_with_an_existing_name_is_a_409_and_Change_of_an_unknown_name_a_404()
    {
        var repository = new FakeDcRepository { Rows = [Row("Kohls Online")] };
        var handler = SaveHandler(repository);

        var exists = await Assert.ThrowsAsync<AppException>(() => handler.HandleAsync(new SaveDcDataCommand(SaveMode.New, "Kohls Online", "US")));
        var unknown = await Assert.ThrowsAsync<NotFoundException>(() => handler.HandleAsync(new SaveDcDataCommand(SaveMode.Change, "Nowhere", "US")));

        Assert.Equal((409, "DC_EXISTS"), (exists.StatusCode, exists.MessageCode));
        Assert.Equal("DC_NOT_FOUND", unknown.MessageCode);
        Assert.Empty(repository.Calls);
    }

    [Fact]
    public async Task Validation_requires_the_name_with_the_legacy_text()
    {
        var ex = await Assert.ThrowsAsync<ValidationException>(() =>
            SaveHandler(new FakeDcRepository()).HandleAsync(new SaveDcDataCommand(SaveMode.New, "", "US")));

        Assert.Equal(["Enter DC Name"], ex.Errors.Select(e => e.ErrorMessage));
    }

    [Theory]
    [InlineData(51, 2)]
    [InlineData(5, 11)]
    public async Task Validation_rejects_values_longer_than_the_columns(int nameLength, int countryLength)
    {
        await Assert.ThrowsAsync<ValidationException>(() =>
            SaveHandler(new FakeDcRepository()).HandleAsync(new SaveDcDataCommand(SaveMode.New, new string('N', nameLength), new string('C', countryLength))));
    }
}
