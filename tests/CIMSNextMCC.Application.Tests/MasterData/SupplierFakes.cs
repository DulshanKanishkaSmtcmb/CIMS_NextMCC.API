using CIMSNextMCC.Application.Common.Exceptions;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using CIMSNextMCC.Domain.Entities.MasterData;

namespace CIMSNextMCC.Application.Tests.MasterData;

internal sealed class FakeSupplierRepository : ISupplierRepository
{
    public List<SupplierMaster> Rows { get; set; } = [];

    public List<SupplierNameHit> Hits { get; set; } = [];

    /// <summary>The codes the "last code" lookup sees (legacy: select top 1 ... order by ShipperCode desc).</summary>
    public List<string> Codes { get; set; } = [];

    public (string Name, bool StartsWith)? LastSearch { get; private set; }

    public List<string> Calls { get; } = [];

    public List<SupplierWrite> Writes { get; } = [];

    public Task<IReadOnlyList<SupplierMaster>> GetAllAsync(CancellationToken cancellationToken = default) =>
        Task.FromResult<IReadOnlyList<SupplierMaster>>(Rows);

    public Task<SupplierMaster?> FindAsync(string shipperCode, CancellationToken cancellationToken = default) =>
        Task.FromResult(Rows.FirstOrDefault(r => string.Equals(r.ShipperCode, shipperCode, StringComparison.OrdinalIgnoreCase)));

    public Task<IReadOnlyList<SupplierNameHit>> SearchByNameAsync(string name, bool startsWith, CancellationToken cancellationToken = default)
    {
        LastSearch = (name, startsWith);
        return Task.FromResult<IReadOnlyList<SupplierNameHit>>(Hits);
    }

    public Task<string?> GetLastCodeAsync(string prefix, CancellationToken cancellationToken = default)
    {
        Calls.Add($"GetLastCode({prefix})");
        return Task.FromResult(Codes
            .Where(c => c.Length > 0 && string.Equals(c[..1], prefix, StringComparison.OrdinalIgnoreCase))
            .OrderByDescending(c => c, StringComparer.Ordinal)
            .FirstOrDefault());
    }

    public Task AddAsync(SupplierWrite supplier, string createBy, CancellationToken cancellationToken = default)
    {
        Calls.Add($"ShipperAdd({supplier.ShipperCode},{supplier.ShipperName},{createBy})");
        Writes.Add(supplier);
        return Task.CompletedTask;
    }

    public Task UpdateAsync(SupplierWrite supplier, string updateBy, CancellationToken cancellationToken = default)
    {
        Calls.Add($"ShipperEdit({supplier.ShipperCode},{supplier.ShipperName},{updateBy})");
        Writes.Add(supplier);
        return Task.CompletedTask;
    }
}

internal sealed class FakeFreightShipperRepository : IFreightShipperRepository
{
    public List<FreightShipper> Air { get; set; } = [];

    public List<FreightShipper> Sea { get; set; } = [];

    public bool Unavailable { get; set; }

    public List<string> Calls { get; } = [];

    private void Check()
    {
        if (Unavailable)
        {
            throw new AppException("AIR_DATABASE_UNAVAILABLE", 503);
        }
    }

    public Task<IReadOnlyList<FreightShipper>> GetAirShippersAsync(CancellationToken cancellationToken = default)
    {
        Check();
        return Task.FromResult<IReadOnlyList<FreightShipper>>(Air);
    }

    public Task<FreightShipperName?> FindAirShipperAsync(string shCode, CancellationToken cancellationToken = default)
    {
        Check();
        Calls.Add($"air:{shCode}");
        var row = Air.FirstOrDefault(r => r.ShCode == shCode);
        return Task.FromResult(row is null ? null : new FreightShipperName { ShCode = row.ShCode, ShName = row.ShName });
    }

    public Task<IReadOnlyList<FreightShipper>> GetSeaShippersAsync(CancellationToken cancellationToken = default)
    {
        Check();
        return Task.FromResult<IReadOnlyList<FreightShipper>>(Sea);
    }

    public Task<FreightShipperName?> FindSeaShipperAsync(string shCode, CancellationToken cancellationToken = default)
    {
        Check();
        Calls.Add($"sea:{shCode}");
        var row = Sea.FirstOrDefault(r => r.ShCode == shCode);
        return Task.FromResult(row is null ? null : new FreightShipperName { ShCode = row.ShCode, ShName = row.ShName });
    }
}

internal sealed class FakePmSupplierRepository : IPmSupplierRepository
{
    public List<PmSupplierMaster> Rows { get; set; } = [];

    public List<string> Codes { get; set; } = [];

    public List<string> Calls { get; } = [];

    public List<PmSupplierWrite> Writes { get; } = [];

    public Task<IReadOnlyList<PmSupplierMaster>> GetAllAsync(CancellationToken cancellationToken = default) =>
        Task.FromResult<IReadOnlyList<PmSupplierMaster>>(Rows);

    public Task<PmSupplierMaster?> FindAsync(string code, CancellationToken cancellationToken = default) =>
        Task.FromResult(Rows.FirstOrDefault(r => string.Equals(r.PmSupplierCode, code, StringComparison.OrdinalIgnoreCase)));

    public Task<string?> GetLastCodeAsync(string prefix, CancellationToken cancellationToken = default)
    {
        Calls.Add($"GetLastCode({prefix})");
        return Task.FromResult(Codes
            .Where(c => c.Length > 0 && string.Equals(c[..1], prefix, StringComparison.OrdinalIgnoreCase))
            .OrderByDescending(c => c, StringComparer.Ordinal)
            .FirstOrDefault());
    }

    public Task AddAsync(PmSupplierWrite supplier, CancellationToken cancellationToken = default)
    {
        Calls.Add($"PMSupplierAdd({supplier.PmSupplierCode},{supplier.PmSupplierName})");
        Writes.Add(supplier);
        return Task.CompletedTask;
    }

    public Task UpdateAsync(PmSupplierWrite supplier, CancellationToken cancellationToken = default)
    {
        Calls.Add($"PMSupplierEdit({supplier.PmSupplierCode},{supplier.PmSupplierName})");
        Writes.Add(supplier);
        return Task.CompletedTask;
    }
}
