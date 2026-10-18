using System.Globalization;
using CIMSNextMCC.Application.Common.Exceptions;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using CIMSNextMCC.Application.MasterData.PalletRack;
using CIMSNextMCC.Domain.Entities.MasterData;
using FluentValidation;

namespace CIMSNextMCC.Application.Tests.MasterData;

/// <summary>Records every write in order, so tests can assert the legacy SP names and parameters.</summary>
internal sealed class FakePalletRackRepository : IPalletRackRepository
{
    public List<string> Calls { get; } = [];
    public List<PalletRack> Racks { get; init; } = [];
    public List<PalletRackPosition> Positions { get; init; } = [];
    public int PositionReads { get; private set; }

    public Task<IReadOnlyList<PalletRack>> GetAllAsync(CancellationToken cancellationToken = default) =>
        Task.FromResult<IReadOnlyList<PalletRack>>(Racks);

    public Task<PalletRack?> FindAsync(string rackNo, CancellationToken cancellationToken = default) =>
        Task.FromResult(Racks.FirstOrDefault(r => string.Equals(r.RackNo, rackNo, StringComparison.OrdinalIgnoreCase)));

    public Task<IReadOnlyList<PalletRackPosition>> GetPositionsAsync(string rackNo, CancellationToken cancellationToken = default)
    {
        PositionReads++;
        return Task.FromResult<IReadOnlyList<PalletRackPosition>>(
            Positions.Where(p => string.Equals(p.RackNo, rackNo, StringComparison.OrdinalIgnoreCase)).ToList());
    }

    public Task AddRackAsync(string rackNo, decimal nofRows, decimal nofLayers, decimal nofPositions, CancellationToken cancellationToken = default)
    {
        Calls.Add(string.Create(CultureInfo.InvariantCulture, $"PalletRacksAdd({rackNo},{nofRows},{nofLayers},{nofPositions})"));
        return Task.CompletedTask;
    }

    public Task AddPositionAsync(string rackNo, string positionNo, CancellationToken cancellationToken = default)
    {
        Calls.Add($"PalletRacksUtilizationAdd({rackNo},{positionNo})");
        return Task.CompletedTask;
    }
}

public class PalletRackHandlerTests
{
    private static PalletRack Rack(string rackNo = "A35") => new() { RackNo = rackNo, NofRows = 39, NofLayers = 8, NofPositions = 303 };

    private static PalletRackPosition Position(string positionNo, string rackNo = "A35") =>
        new() { RackNo = rackNo, PositionNo = positionNo, GrnNo = "'", PalletNo = "" };

    private static CreatePalletRackHandler CreateHandler(FakePalletRackRepository repository) =>
        new(repository, new CreatePalletRackValidator());

    private static CreatePalletRackCommand Command(
        string rackNo = "B1",
        decimal rows = 2,
        decimal layers = 2,
        decimal total = 3,
        params string[] positions) =>
        new(rackNo, rows, layers, total, positions.Length > 0 ? positions : ["B1-01-01", "B1-01-02", "B1-02-01"]);

    [Fact]
    public async Task List_returns_every_rack_column_in_repository_order()
    {
        var repository = new FakePalletRackRepository { Racks = [Rack("A35"), Rack("B1")] };

        var result = await new GetPalletRackListHandler(repository).HandleAsync(new GetPalletRackListQuery());

        Assert.Equal([new PalletRackDto("A35", 39, 8, 303), new PalletRackDto("B1", 39, 8, 303)], result.Data);
    }

    [Fact]
    public async Task Data_returns_the_rack_and_its_positions()
    {
        var repository = new FakePalletRackRepository
        {
            Racks = [Rack()],
            Positions = [Position("A35-01-01"), Position("A35-01-02"), Position("B1-01-01", "B1")],
        };

        var result = await new GetPalletRackDataHandler(repository).HandleAsync(new GetPalletRackDataQuery("a35", true));

        Assert.Equal(new PalletRackDto("A35", 39, 8, 303), result.Data!.Rack);
        Assert.Equal([new PalletPositionDto("A35", "A35-01-01", "'", ""), new PalletPositionDto("A35", "A35-01-02", "'", "")], result.Data.Positions);
    }

    [Fact]
    public async Task Data_without_positions_does_not_read_them()
    {
        var repository = new FakePalletRackRepository { Racks = [Rack()], Positions = [Position("A35-01-01")] };

        var result = await new GetPalletRackDataHandler(repository).HandleAsync(new GetPalletRackDataQuery("A35", false));

        Assert.NotNull(result.Data!.Rack);
        Assert.Empty(result.Data.Positions);
        Assert.Equal(0, repository.PositionReads);
    }

    [Fact]
    public async Task Data_for_an_unknown_rack_is_not_an_error_the_rack_is_null()
    {
        var result = await new GetPalletRackDataHandler(new FakePalletRackRepository { Racks = [Rack()] })
            .HandleAsync(new GetPalletRackDataQuery("ZZZ", true));

        Assert.True(result.IsSuccess);
        Assert.Null(result.Data!.Rack);
        Assert.Empty(result.Data.Positions);
    }

    [Fact]
    public async Task Create_calls_PalletRacksAdd_once_then_PalletRacksUtilizationAdd_per_position_in_order()
    {
        var repository = new FakePalletRackRepository { Racks = [Rack()] };

        var result = await CreateHandler(repository).HandleAsync(Command());

        Assert.Equal(
            [
                "PalletRacksAdd(B1,2,2,3)",
                "PalletRacksUtilizationAdd(B1,B1-01-01)",
                "PalletRacksUtilizationAdd(B1,B1-01-02)",
                "PalletRacksUtilizationAdd(B1,B1-02-01)",
            ],
            repository.Calls);
        Assert.Equal(new CreatePalletRackResultDto("B1", 3, "Data Saved Successfully"), result.Data);
    }

    [Theory]
    [InlineData("A35")]
    [InlineData("a35")]
    public async Task Create_for_a_rack_that_exists_is_a_409_and_writes_nothing(string rackNo)
    {
        var repository = new FakePalletRackRepository { Racks = [Rack()] };

        var ex = await Assert.ThrowsAsync<AppException>(() => CreateHandler(repository).HandleAsync(Command(rackNo: rackNo)));

        Assert.Equal((409, "PALLET_RACK_EXISTS"), (ex.StatusCode, ex.MessageCode));
        Assert.Empty(repository.Calls);
    }

    [Fact]
    public async Task Create_reports_the_legacy_texts_in_the_legacy_order()
    {
        var ex = await Assert.ThrowsAsync<ValidationException>(() =>
            CreateHandler(new FakePalletRackRepository()).HandleAsync(new CreatePalletRackCommand("", 0, 13, 0, [])));

        Assert.Equal(
            [
                "Enter Rack No",
                "Enter Nof of Rows in side Rack",
                "Nof of Layers must be less than 12",
                "Nothing to save any Pallet Positions",
            ],
            ex.Errors.Select(e => e.ErrorMessage));
    }

    [Theory]
    [InlineData(100, 8)]
    [InlineData(-1, 8)]
    public async Task Create_refuses_too_many_or_negative_rows(decimal rows, decimal layers)
    {
        var ex = await Assert.ThrowsAsync<ValidationException>(() =>
            CreateHandler(new FakePalletRackRepository()).HandleAsync(Command(rows: rows, layers: layers)));

        Assert.Equal(["Nof of Rows must be less than 99"], ex.Errors.Select(e => e.ErrorMessage));
    }

    [Theory]
    [InlineData(99, 12)]
    [InlineData(1, 0)]
    public async Task Create_accepts_the_limits_the_legacy_check_let_through(decimal rows, decimal layers)
    {
        var result = await CreateHandler(new FakePalletRackRepository()).HandleAsync(Command(rows: rows, layers: layers));

        Assert.True(result.IsSuccess);
    }

    [Fact]
    public async Task Create_refuses_values_longer_than_the_columns_instead_of_cutting_them()
    {
        var longRack = await Assert.ThrowsAsync<ValidationException>(() =>
            CreateHandler(new FakePalletRackRepository()).HandleAsync(Command(rackNo: "ABCDEFGHIJK", positions: "A-01")));
        var longPosition = await Assert.ThrowsAsync<ValidationException>(() =>
            CreateHandler(new FakePalletRackRepository()).HandleAsync(Command(rackNo: "ABCDE", positions: "ABCDE-01-01")));

        Assert.Equal(["Rack No can not be longer than 10 characters"], longRack.Errors.Select(e => e.ErrorMessage));
        Assert.Equal(["Position No can not be longer than 10 characters"], longPosition.Errors.Select(e => e.ErrorMessage));
    }
}
