using CIMSNextMCC.Application.Common.Exceptions;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using CIMSNextMCC.Application.MasterData.OkToLoadReason;
using CIMSNextMCC.Domain.Entities.MasterData;
using FluentValidation;

namespace CIMSNextMCC.Application.Tests.MasterData;

/// <summary>Records every write in order, so tests can assert the legacy statements and parameters.</summary>
internal sealed class FakeOkToLoadReasonRepository : IOkToLoadReasonRepository
{
    public List<string> Calls { get; } = [];
    public List<OkToLoadReasonRow> Rows { get; init; } = [];
    public List<string> Allocated { get; init; } = [];
    public string? LastAllocationDc { get; private set; }

    public Task<IReadOnlyList<OkToLoadReasonRow>> GetAsync(string? dc, CancellationToken cancellationToken = default) =>
        Task.FromResult<IReadOnlyList<OkToLoadReasonRow>>(
            Rows.Where(r => string.IsNullOrEmpty(dc) || string.Equals(r.Dc, dc, StringComparison.OrdinalIgnoreCase)).ToList());

    public Task<IReadOnlyList<string>> GetAllocatedReasonsAsync(string dc, CancellationToken cancellationToken = default)
    {
        LastAllocationDc = dc;
        return Task.FromResult<IReadOnlyList<string>>(Allocated);
    }

    public Task DeleteByDcAsync(string dc, CancellationToken cancellationToken = default)
    {
        Calls.Add($"DELETE({dc})");
        return Task.CompletedTask;
    }

    public Task AddAsync(string reason, decimal reasonOrder, string dtlReson, string warehouse, CancellationToken cancellationToken = default)
    {
        Calls.Add($"OkToLoadReasonAdd({reason},{reasonOrder},{dtlReson},{warehouse})");
        return Task.CompletedTask;
    }
}

public class OkToLoadReasonHandlerTests
{
    private static OkToLoadReasonRow Row(string reason, string detail = "", string dc = "Zalora Online") =>
        new() { Reason = reason, DtlReson = detail, Dc = dc };

    private static ReplaceOkToLoadReasonsHandler SaveHandler(FakeOkToLoadReasonRepository repository, params string[] dcs) =>
        new(
            repository,
            new FakeDcRepository { Rows = (dcs.Length > 0 ? dcs : ["Zalora Online"]).Select(d => new DcMaster { WhDes = d }).ToList() },
            new ReplaceOkToLoadReasonsValidator());

    private static GetOkToLoadReasonsHandler GetHandler(FakeOkToLoadReasonRepository repository) =>
        new(repository, new GetOkToLoadReasonsValidator());

    [Fact]
    public async Task Get_returns_the_reasons_of_the_dc_in_repository_order()
    {
        var repository = new FakeOkToLoadReasonRepository
        {
            Rows = [Row("A", "a"), Row("B", "b"), Row("X", "x", "Kohls Retail")],
        };

        var result = await GetHandler(repository).HandleAsync(new GetOkToLoadReasonsQuery("Zalora Online", false));

        Assert.Equal(
            [new OkToLoadReasonDto("A", "a", "Zalora Online", false), new OkToLoadReasonDto("B", "b", "Zalora Online", false)],
            result.Data);
        Assert.Null(repository.LastAllocationDc);
    }

    [Fact]
    public async Task Get_without_a_dc_returns_the_reasons_of_every_dc()
    {
        var repository = new FakeOkToLoadReasonRepository { Rows = [Row("A"), Row("X", "", "Kohls Retail")] };

        var result = await GetHandler(repository).HandleAsync(new GetOkToLoadReasonsQuery(null, false));

        Assert.Equal(["A", "X"], result.Data!.Select(r => r.Reason));
    }

    [Fact]
    public async Task Get_marks_only_the_first_reason_that_contracts_carry_ignoring_case_and_trailing_blanks()
    {
        var repository = new FakeOkToLoadReasonRepository
        {
            Rows = [Row("data issue"), Row("Data Issue"), Row("EAN missing")],
            Allocated = ["DATA ISSUE ", "unknown"],
        };

        var result = await GetHandler(repository).HandleAsync(new GetOkToLoadReasonsQuery("Zalora Online", true));

        Assert.Equal([true, false, false], result.Data!.Select(r => r.IsAllocated));
        Assert.Equal("Zalora Online", repository.LastAllocationDc);
    }

    [Fact]
    public async Task Get_with_an_empty_dc_asks_the_allocation_of_the_empty_warehouse_like_legacy()
    {
        var repository = new FakeOkToLoadReasonRepository { Rows = [Row("A")], Allocated = ["A"] };

        var result = await GetHandler(repository).HandleAsync(new GetOkToLoadReasonsQuery("", true));

        Assert.Equal("", repository.LastAllocationDc);
        Assert.True(result.Data![0].IsAllocated);
    }

    [Fact]
    public async Task Get_refuses_a_dc_longer_than_the_column()
    {
        await Assert.ThrowsAsync<ValidationException>(() =>
            GetHandler(new FakeOkToLoadReasonRepository()).HandleAsync(new GetOkToLoadReasonsQuery(new string('x', 51), false)));
    }

    [Fact]
    public async Task Save_deletes_the_dc_rows_and_adds_every_line_with_its_position_as_the_order()
    {
        var repository = new FakeOkToLoadReasonRepository { Rows = [Row("OLD", "o")] };

        var result = await SaveHandler(repository).HandleAsync(
            new ReplaceOkToLoadReasonsCommand("Zalora Online", [new("B", "bb"), new("A", null), new("C", "c")]));

        Assert.Equal(
            [
                "DELETE(Zalora Online)",
                "OkToLoadReasonAdd(B,1,bb,Zalora Online)",
                "OkToLoadReasonAdd(A,2,,Zalora Online)",
                "OkToLoadReasonAdd(C,3,c,Zalora Online)",
            ],
            repository.Calls);
        Assert.Equal(new ReplaceOkToLoadReasonsResultDto("Zalora Online", 3, "Data Saved Successfully"), result.Data);
    }

    [Fact]
    public async Task Save_checks_the_dc_before_the_list_like_the_page_and_refuses_an_empty_list_like_the_action()
    {
        var noDc = await Assert.ThrowsAsync<ValidationException>(() =>
            SaveHandler(new FakeOkToLoadReasonRepository()).HandleAsync(new ReplaceOkToLoadReasonsCommand("", [])));
        var empty = await Assert.ThrowsAsync<ValidationException>(() =>
            SaveHandler(new FakeOkToLoadReasonRepository()).HandleAsync(new ReplaceOkToLoadReasonsCommand("Zalora Online", [])));

        Assert.Equal("DC not selected", noDc.Errors.First().ErrorMessage);
        Assert.Equal(["Contract Data not found.[Empty List]"], empty.Errors.Select(e => e.ErrorMessage));
    }

    [Theory]
    [InlineData("")]
    [InlineData("   ")]
    public async Task Save_refuses_a_blank_reason(string reason)
    {
        var repository = new FakeOkToLoadReasonRepository();

        var ex = await Assert.ThrowsAsync<ValidationException>(() =>
            SaveHandler(repository).HandleAsync(new ReplaceOkToLoadReasonsCommand("Zalora Online", [new("A", "a"), new(reason, "b")])));

        Assert.Equal(["Enter Reason"], ex.Errors.Select(e => e.ErrorMessage));
        Assert.Empty(repository.Calls);
    }

    [Theory]
    [InlineData(51, 10)]
    [InlineData(10, 1001)]
    public async Task Save_refuses_values_longer_than_the_procedure_parameters(int reasonLength, int detailLength)
    {
        var ex = await Assert.ThrowsAsync<ValidationException>(() =>
            SaveHandler(new FakeOkToLoadReasonRepository()).HandleAsync(
                new ReplaceOkToLoadReasonsCommand("Zalora Online", [new(new string('r', reasonLength), new string('d', detailLength))])));

        Assert.Single(ex.Errors);
    }

    [Fact]
    public async Task Save_for_a_dc_that_does_not_exist_is_a_404_and_writes_nothing()
    {
        var repository = new FakeOkToLoadReasonRepository();

        var ex = await Assert.ThrowsAsync<NotFoundException>(() =>
            SaveHandler(repository).HandleAsync(new ReplaceOkToLoadReasonsCommand("Nowhere", [new("A", "a")])));

        Assert.Equal("DC_NOT_FOUND", ex.MessageCode);
        Assert.Empty(repository.Calls);
    }

    [Fact]
    public async Task Save_may_not_leave_out_a_reason_that_contracts_carry()
    {
        var repository = new FakeOkToLoadReasonRepository
        {
            Rows = [Row("data issue"), Row("EAN missing")],
            Allocated = ["Data Issue"],
        };

        var ex = await Assert.ThrowsAsync<AppException>(() =>
            SaveHandler(repository).HandleAsync(new ReplaceOkToLoadReasonsCommand("Zalora Online", [new("EAN missing", "")])));

        Assert.Equal((409, "REASON_ALLOCATED"), (ex.StatusCode, ex.MessageCode));
        Assert.Empty(repository.Calls);
    }

    [Fact]
    public async Task Save_may_keep_reorder_and_extend_the_reasons_that_contracts_carry()
    {
        var repository = new FakeOkToLoadReasonRepository
        {
            Rows = [Row("data issue"), Row("EAN missing")],
            Allocated = ["DATA ISSUE", "EAN missing"],
        };

        await SaveHandler(repository).HandleAsync(
            new ReplaceOkToLoadReasonsCommand("Zalora Online", [new("EAN missing", ""), new("data issue", "x"), new("new one", "")]));

        Assert.Equal(4, repository.Calls.Count);
    }

    [Fact]
    public async Task Save_may_remove_a_reason_nobody_carries()
    {
        var repository = new FakeOkToLoadReasonRepository { Rows = [Row("a"), Row("b")], Allocated = ["a"] };

        await SaveHandler(repository).HandleAsync(new ReplaceOkToLoadReasonsCommand("Zalora Online", [new("a", "")]));

        Assert.Equal(["DELETE(Zalora Online)", "OkToLoadReasonAdd(a,1,,Zalora Online)"], repository.Calls);
    }
}
