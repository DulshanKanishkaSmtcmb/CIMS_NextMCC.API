using System.Globalization;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using CIMSNextMCC.Domain.Entities.MasterData;

namespace CIMSNextMCC.Application.Tests.MasterData;

/// <summary>Records every write in order, so tests can assert the legacy SP name and parameters.</summary>
internal sealed class FakePackingMaterialRepository : IPackingMaterialRepository
{
    public List<string> Calls { get; } = [];
    public List<PackingMaterial> Rows { get; init; } = [];
    public List<PackingMaterialCategory> Categories { get; init; } =
        [new() { PmCategory = "Carton" }, new() { PmCategory = "Hanger" }];

    public Task<IReadOnlyList<PackingMaterial>> GetAllAsync(CancellationToken cancellationToken = default) =>
        Task.FromResult<IReadOnlyList<PackingMaterial>>(Rows);

    public Task<PackingMaterial?> FindAsync(string pmCode, CancellationToken cancellationToken = default) =>
        Task.FromResult(Rows.FirstOrDefault(r => string.Equals(r.PmCode, pmCode, StringComparison.OrdinalIgnoreCase)));

    public Task<IReadOnlyList<PackingMaterialCategory>> GetCategoriesAsync(CancellationToken cancellationToken = default) =>
        Task.FromResult<IReadOnlyList<PackingMaterialCategory>>(Categories);

    public Task AddAsync(PackingMaterialValues values, CancellationToken cancellationToken = default)
    {
        Calls.Add("PMMasterAdd" + Format(values));
        return Task.CompletedTask;
    }

    public Task UpdateAsync(PackingMaterialValues values, CancellationToken cancellationToken = default)
    {
        Calls.Add("PMMasterEdit" + Format(values));
        return Task.CompletedTask;
    }

    private static string Format(PackingMaterialValues v) =>
        string.Create(
            CultureInfo.InvariantCulture,
            $"({v.PmCode},{v.PmDescription},{v.PmCategory},{v.ReorderLevel},{v.PmWeight},{v.Cbm},{v.GetJokersCount},{v.GetPartsCount},{v.IsActive})");
}

internal sealed class FakeContractChainCodeRepository : IContractChainCodeRepository
{
    public List<string> Calls { get; } = [];
    public List<ContractChainCode> Rows { get; init; } = [];
    public List<ChainRange> Ranges { get; init; } = [new() { Category = "Womens" }, new() { Category = "Childrens" }];

    public Task<IReadOnlyList<ContractChainCode>> GetAllAsync(CancellationToken cancellationToken = default) =>
        Task.FromResult<IReadOnlyList<ContractChainCode>>(Rows);

    public Task<IReadOnlyList<ChainRange>> GetRangesAsync(CancellationToken cancellationToken = default) =>
        Task.FromResult<IReadOnlyList<ChainRange>>(Ranges);

    public Task AddAsync(string chainCode, string chainName, string tpPartnerName, string range, string rangeBoxEan, CancellationToken cancellationToken = default)
    {
        Calls.Add($"InsertContractsChainCodes({chainCode},{chainName},{tpPartnerName},{range},{rangeBoxEan})");
        return Task.CompletedTask;
    }
}
