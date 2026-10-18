using CIMSNextMCC.Application.Common.Exceptions;
using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.MasterData.PMMaster;
using CIMSNextMCC.Domain.Entities.MasterData;
using FluentValidation;

namespace CIMSNextMCC.Application.Tests.MasterData;

public class PmMasterHandlerTests
{
    private static PackingMaterial Row(string code, string description, string category = "Carton") =>
        new() { PmCode = code, PmDescription = description, PmCategory = category };

    private static SavePmDataHandler SaveHandler(FakePackingMaterialRepository repository) =>
        new(repository, new SavePmDataValidator());

    private static SavePmDataCommand Command(
        SaveMode mode = SaveMode.New,
        string code = "ZZT1",
        string description = "ZZ PM",
        string category = "Carton",
        int reorder = 10,
        decimal weight = 5,
        decimal cbm = 2,
        bool jokers = false,
        bool parts = false,
        bool active = true) =>
        new(mode, code, description, category, reorder, weight, cbm, jokers, parts, active);

    [Fact]
    public async Task List_maps_every_column()
    {
        var repository = new FakePackingMaterialRepository
        {
            Rows =
            [
                new PackingMaterial
                {
                    PmCode = "CT1", PmDescription = "60X30X40", PmCategory = "Carton", PmIssueType = "", QtyInHand = 128,
                    QtyReOrderLevel = 0, PmWgt = 1200, PmCbm = 0.072m, GetJokerCount = false, GetPartCount = true,
                    GetCtnCount = false, StockCbm = 0, IsActive = true,
                },
            ],
        };

        var result = await new GetPmListHandler(repository).HandleAsync(new GetPmListQuery());

        Assert.Equal(
            new PmMasterDto("CT1", "60X30X40", "Carton", "", 128, 0, 1200, 0.072m, false, true, false, 0, true),
            result.Data!.Single());
    }

    [Fact]
    public async Task Data_returns_the_row_or_the_not_found_code()
    {
        var handler = new GetPmDataHandler(new FakePackingMaterialRepository { Rows = [Row("CT1", "60X30X40")] }, new GetPmDataValidator());

        var found = await handler.HandleAsync(new GetPmDataQuery("ct1"));
        var missing = await handler.HandleAsync(new GetPmDataQuery("ZZT1"));

        Assert.Equal("60X30X40", found.Data!.PmDescription);
        Assert.Equal("PM_NOT_FOUND", missing.MessageCode);
    }

    [Fact]
    public async Task Data_rejects_a_code_longer_than_the_procedure_parameter()
    {
        var handler = new GetPmDataHandler(new FakePackingMaterialRepository(), new GetPmDataValidator());

        await Assert.ThrowsAsync<ValidationException>(() => handler.HandleAsync(new GetPmDataQuery("12345678901")));
    }

    [Fact]
    public async Task Categories_are_returned_in_table_order()
    {
        var result = await new GetPmCategoriesHandler(new FakePackingMaterialRepository()).HandleAsync(new GetPmCategoriesQuery());

        Assert.Equal([new PmCategoryDto("Carton"), new PmCategoryDto("Hanger")], result.Data);
    }

    [Fact]
    public async Task New_calls_PMMasterAdd_with_the_nine_page_values()
    {
        var repository = new FakePackingMaterialRepository();

        var result = await SaveHandler(repository).HandleAsync(Command(weight: 12.5m, cbm: 0.25m, parts: true));

        Assert.Equal(new SavePmMasterResultDto("ZZT1", "Data Saved Successfully"), result.Data);
        Assert.Equal(["PMMasterAdd(ZZT1,ZZ PM,Carton,10,12.5,0.25,False,True,True)"], repository.Calls);
    }

    [Fact]
    public async Task Change_calls_PMMasterEdit()
    {
        var repository = new FakePackingMaterialRepository { Rows = [Row("ZZT1", "ZZ PM")] };

        await SaveHandler(repository).HandleAsync(Command(SaveMode.Change, description: "ZZ PM 2", category: "Hanger", active: false));

        Assert.Equal(["PMMasterEdit(ZZT1,ZZ PM 2,Hanger,10,5,2,False,False,False)"], repository.Calls);
    }

    [Fact]
    public async Task New_with_an_existing_code_is_a_409_and_Change_of_an_unknown_code_a_404()
    {
        var repository = new FakePackingMaterialRepository { Rows = [Row("CT1", "60X30X40")] };
        var handler = SaveHandler(repository);

        var exists = await Assert.ThrowsAsync<AppException>(() => handler.HandleAsync(Command(code: "ct1")));
        var unknown = await Assert.ThrowsAsync<NotFoundException>(() => handler.HandleAsync(Command(SaveMode.Change, code: "ZZT1")));

        Assert.Equal((409, "PM_CODE_EXISTS"), (exists.StatusCode, exists.MessageCode));
        Assert.Equal("PM_CODE_NOT_FOUND", unknown.MessageCode);
        Assert.Empty(repository.Calls);
    }

    [Fact]
    public async Task Validation_reports_the_description_before_the_code_and_then_the_numbers_with_the_legacy_texts()
    {
        var ex = await Assert.ThrowsAsync<ValidationException>(() =>
            SaveHandler(new FakePackingMaterialRepository()).HandleAsync(Command(code: "", description: "", reorder: -1, weight: -1, cbm: -1)));

        Assert.Equal(
            [
                "Enter Description",
                "Enter PM Code",
                "Reorder Level must be positive number",
                "PM Weight must be positive number",
                "CBM must be positive number",
            ],
            ex.Errors.Select(e => e.ErrorMessage));
    }

    [Fact]
    public async Task A_missing_code_is_only_an_error_for_New()
    {
        var repository = new FakePackingMaterialRepository();

        // Change takes the code from the route, so an empty code falls through to the existence check (404).
        await Assert.ThrowsAsync<NotFoundException>(() => SaveHandler(repository).HandleAsync(Command(SaveMode.Change, code: "")));
    }

    [Fact]
    public async Task Both_counts_together_refuse_the_save_where_legacy_only_showed_a_toast()
    {
        var repository = new FakePackingMaterialRepository();

        var ex = await Assert.ThrowsAsync<ValidationException>(() => SaveHandler(repository).HandleAsync(Command(jokers: true, parts: true)));

        Assert.Equal(["can not be select Get Jokers Count and Get Parts Count both check box"], ex.Errors.Select(e => e.ErrorMessage));
        Assert.Empty(repository.Calls);
    }

    [Theory]
    [InlineData("12345678901", "d", "Carton")]
    [InlineData("ZZT1", "012345678901234567890123456789012345678901234567890", "Carton")]
    [InlineData("ZZT1", "d", "01234567890")]
    public async Task Validation_rejects_values_longer_than_the_columns(string code, string description, string category)
    {
        await Assert.ThrowsAsync<ValidationException>(() =>
            SaveHandler(new FakePackingMaterialRepository()).HandleAsync(Command(code: code, description: description, category: category)));
    }

    [Fact]
    public async Task A_weight_with_more_than_two_decimals_is_refused()
    {
        await Assert.ThrowsAsync<ValidationException>(() =>
            SaveHandler(new FakePackingMaterialRepository()).HandleAsync(Command(weight: 1.234m)));
    }

    [Fact]
    public async Task A_category_that_is_not_in_PMCategories_is_refused_before_anything_is_written()
    {
        var repository = new FakePackingMaterialRepository();

        var ex = await Assert.ThrowsAsync<ValidationException>(() => SaveHandler(repository).HandleAsync(Command(category: "Bogus")));

        Assert.Equal(["Select a valid PM Category"], ex.Errors.Select(e => e.ErrorMessage));
        Assert.Empty(repository.Calls);
    }
}
