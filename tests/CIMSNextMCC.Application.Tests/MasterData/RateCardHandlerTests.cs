using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using CIMSNextMCC.Application.MasterData.RateCard;
using CIMSNextMCC.Domain.Entities.MasterData;

namespace CIMSNextMCC.Application.Tests.MasterData;

internal sealed class FakeRateCardRepository : IRateCardRepository
{
    public List<string> ContainerTypes { get; init; } = ["20GP", "Air", "LCL", "40HQ"];
    public List<RatePort> Ports { get; init; } = [new() { PortCode = "BOM", PortName = "Mumbai" }, new() { PortCode = "WSP", PortName = "Westport" }];
    public List<ClearanceRate> Clearance { get; init; } = [new() { CntrType = "20GP", RateInUsd = 700m }, new() { CntrType = "40HQ", RateInUsd = 800m }];
    public List<FreightRate> Freight { get; init; } =
    [
        new() { PortCode = "WSP", PortName = "Westport", CntrType = "20GP", RateInUsd = 250m },
        new() { PortCode = "WSP", PortName = "Westport", CntrType = "40HQ", RateInUsd = 450m },
    ];
    public List<CfsRate> Cfs { get; init; } = [];

    public Task<IReadOnlyList<string>> GetContainerTypesAsync(CancellationToken cancellationToken = default) =>
        Task.FromResult<IReadOnlyList<string>>(ContainerTypes);

    public Task<IReadOnlyList<RatePort>> GetPortsAsync(CancellationToken cancellationToken = default) =>
        Task.FromResult<IReadOnlyList<RatePort>>(Ports);

    public Task<IReadOnlyList<ClearanceRate>> GetClearanceRatesAsync(CancellationToken cancellationToken = default) =>
        Task.FromResult<IReadOnlyList<ClearanceRate>>(Clearance);

    public Task<IReadOnlyList<FreightRate>> GetFreightRatesAsync(CancellationToken cancellationToken = default) =>
        Task.FromResult<IReadOnlyList<FreightRate>>(Freight);

    public Task<IReadOnlyList<CfsRate>> GetCfsRatesAsync(CancellationToken cancellationToken = default) =>
        Task.FromResult<IReadOnlyList<CfsRate>>(Cfs);
}

public class RateCardHandlerTests
{
    private static Task<CIMSNextMCC.Application.Common.Models.Result<RateCardDto>> Run(FakeRateCardRepository repository) =>
        new GetRateCardHandler(repository).HandleAsync(new GetRateCardQuery());

    [Fact]
    public async Task Clearance_has_one_row_per_container_type_with_zero_when_no_rate_is_stored()
    {
        var result = await Run(new FakeRateCardRepository());

        Assert.Equal(
            [
                new ClearanceRateDto("20GP", 700m),
                new ClearanceRateDto("Air", 0m),
                new ClearanceRateDto("LCL", 0m),
                new ClearanceRateDto("40HQ", 800m),
            ],
            result.Data!.Clearance);
    }

    [Fact]
    public async Task Freight_is_every_port_crossed_with_every_container_type_in_port_then_type_order()
    {
        var result = await Run(new FakeRateCardRepository());

        var freight = result.Data!.Freight;
        Assert.Equal(8, freight.Count);
        Assert.Equal(
            ["BOM/20GP", "BOM/Air", "BOM/LCL", "BOM/40HQ", "WSP/20GP", "WSP/Air", "WSP/LCL", "WSP/40HQ"],
            freight.Select(f => $"{f.PortCode}/{f.CntrType}"));
        Assert.Equal([0m, 0m, 0m, 0m, 250m, 0m, 0m, 450m], freight.Select(f => f.RateInUsd));
        Assert.All(freight.Where(f => f.PortCode == "WSP"), f => Assert.Equal("Westport", f.PortName));
    }

    [Fact]
    public async Task A_stored_rate_matches_its_container_type_whatever_the_case_or_trailing_blanks()
    {
        var repository = new FakeRateCardRepository
        {
            ContainerTypes = ["20GP"],
            Clearance = [new() { CntrType = "20gp  ", RateInUsd = 710m }],
            Ports = [new() { PortCode = "WSP", PortName = "Westport" }],
            Freight = [new() { PortCode = "wsp", PortName = "Westport", CntrType = "20Gp", RateInUsd = 260m }],
        };

        var result = await Run(repository);

        Assert.Equal(710m, result.Data!.Clearance.Single().RateInUsd);
        Assert.Equal(260m, result.Data.Freight.Single().RateInUsd);
    }

    [Fact]
    public async Task When_a_rate_is_stored_twice_the_first_one_wins()
    {
        var repository = new FakeRateCardRepository
        {
            ContainerTypes = ["20GP"],
            Clearance = [new() { CntrType = "20GP", RateInUsd = 1m }, new() { CntrType = "20GP", RateInUsd = 2m }],
        };

        var result = await Run(repository);

        Assert.Equal(1m, result.Data!.Clearance.Single().RateInUsd);
    }

    [Fact]
    public async Task Cfs_charges_are_returned_as_stored_with_the_material_description()
    {
        var repository = new FakeRateCardRepository
        {
            Cfs =
            [
                new()
                {
                    ChgCode = "P0003", ChgDescription = "Pick & Pack", UnitType = "PCS", Range1 = 1m, Range2 = 2m,
                    UnitCalType = null, RateInUsd = 0.47m, IsActive = true, FileCaption = "Material Handling",
                    MaterialCode = "P0001", RateInUsdCost = 3m, RateUpdateBy = "x", PmDescription = "Poly bag",
                },
            ],
        };

        var result = await Run(repository);

        var row = Assert.Single(result.Data!.Cfs);
        Assert.Equal(
            new CfsRateDto("P0003", "Pick & Pack", "PCS", 1m, 2m, null, 0.47m, true, "Material Handling", "P0001", 3m, "x", null, "Poly bag"),
            row);
    }

    [Fact]
    public async Task With_no_container_types_and_no_ports_all_tables_are_empty()
    {
        var result = await Run(new FakeRateCardRepository { ContainerTypes = [], Ports = [] });

        Assert.Empty(result.Data!.Clearance);
        Assert.Empty(result.Data.Freight);
        Assert.Empty(result.Data.Cfs);
    }
}
