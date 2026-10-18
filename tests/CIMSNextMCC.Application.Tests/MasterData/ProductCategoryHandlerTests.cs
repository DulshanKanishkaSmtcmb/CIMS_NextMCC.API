using CIMSNextMCC.Application.Common.Exceptions;
using CIMSNextMCC.Application.MasterData.ProductCategory;
using CIMSNextMCC.Domain.Entities.MasterData;
using FluentValidation;

namespace CIMSNextMCC.Application.Tests.MasterData;

public class ProductCategoryHandlerTests
{
    private static ContractChainCode Row(string code, string name = "Womenswear", string tp = "NEXT", string range = "Womens", string ean = "WWR") =>
        new() { ChainCode = code, ChainName = name, TpPartnerName = tp, Range = range, RangeBoxEan = ean };

    private static SaveChainCodeHandler SaveHandler(FakeContractChainCodeRepository repository) =>
        new(repository, new SaveChainCodeValidator());

    private static SaveChainCodeCommand Command(
        string code = "Z",
        string name = "Zed wear",
        string range = "Womens",
        string tp = "NEXT",
        string ean = "ZZR") =>
        new(code, name, range, tp, ean);

    [Fact]
    public async Task List_returns_every_column_in_the_table_order()
    {
        var repository = new FakeContractChainCodeRepository { Rows = [Row("A"), Row("C", "Childrensware", "NEXT", "Childrens", "CWR")] };

        var result = await new GetChainCodesHandler(repository).HandleAsync(new GetChainCodesQuery());

        Assert.Equal(
            [
                new ChainCodeDto("A", "Womenswear", "NEXT", "Womens", "WWR"),
                new ChainCodeDto("C", "Childrensware", "NEXT", "Childrens", "CWR"),
            ],
            result.Data);
    }

    [Fact]
    public async Task Ranges_are_returned_in_table_order()
    {
        var result = await new GetChainRangesHandler(new FakeContractChainCodeRepository()).HandleAsync(new GetChainRangesQuery());

        Assert.Equal([new ChainRangeDto("Womens"), new ChainRangeDto("Childrens")], result.Data);
    }

    [Fact]
    public async Task Save_calls_InsertContractsChainCodes_with_the_five_values()
    {
        var repository = new FakeContractChainCodeRepository { Rows = [Row("A")] };

        var result = await SaveHandler(repository).HandleAsync(Command());

        Assert.Equal(new SaveChainCodeResultDto("Z", "Data Saved Successfully"), result.Data);
        Assert.Equal(["InsertContractsChainCodes(Z,Zed wear,NEXT,Womens,ZZR)"], repository.Calls);
    }

    [Theory]
    [InlineData("A")]
    [InlineData("a")]
    public async Task A_duplicate_chain_code_is_a_409_whatever_its_case(string code)
    {
        var repository = new FakeContractChainCodeRepository { Rows = [Row("A")] };

        var ex = await Assert.ThrowsAsync<AppException>(() => SaveHandler(repository).HandleAsync(Command(code: code)));

        Assert.Equal((409, "CHAIN_CODE_EXISTS"), (ex.StatusCode, ex.MessageCode));
        Assert.Empty(repository.Calls);
    }

    [Fact]
    public async Task Validation_reports_the_legacy_texts_in_the_legacy_order()
    {
        var ex = await Assert.ThrowsAsync<ValidationException>(() =>
            SaveHandler(new FakeContractChainCodeRepository()).HandleAsync(Command(code: "", name: "", range: "", tp: "", ean: "")));

        Assert.Equal(
            [
                "Can not be empty Chain Code",
                "Can not be empty Chain Name",
                "Can not be empty Range",
                "Can not be empty TP Partner Name",
                "Can not be empty Range Box EAN",
            ],
            ex.Errors.Select(e => e.ErrorMessage));
    }

    [Fact]
    public async Task A_chain_code_must_be_exactly_one_character()
    {
        var ex = await Assert.ThrowsAsync<ValidationException>(() =>
            SaveHandler(new FakeContractChainCodeRepository()).HandleAsync(Command(code: "AB")));

        Assert.Equal(["Chain Code must be exactly 1 character long"], ex.Errors.Select(e => e.ErrorMessage));
    }

    [Theory]
    [InlineData("name", 51)]
    [InlineData("tp", 21)]
    [InlineData("range", 21)]
    [InlineData("ean", 11)]
    public async Task Values_longer_than_the_procedure_parameters_are_refused(string field, int length)
    {
        var text = new string('x', length);
        var command = field switch
        {
            "name" => Command(name: text),
            "tp" => Command(tp: text),
            "range" => Command(range: text),
            _ => Command(ean: text),
        };

        await Assert.ThrowsAsync<ValidationException>(() => SaveHandler(new FakeContractChainCodeRepository()).HandleAsync(command));
    }

    [Fact]
    public async Task A_range_that_is_not_in_the_category_table_is_refused_before_anything_is_written()
    {
        var repository = new FakeContractChainCodeRepository();

        var ex = await Assert.ThrowsAsync<ValidationException>(() => SaveHandler(repository).HandleAsync(Command(range: "Mens")));

        Assert.Equal(["Select a valid Range"], ex.Errors.Select(e => e.ErrorMessage));
        Assert.Empty(repository.Calls);
    }
}
