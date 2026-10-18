using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using CIMSNextMCC.Application.Interfaces.Repositories.Security;
using CIMSNextMCC.Domain.Entities.MasterData;
using CIMSNextMCC.Domain.Entities.Security;
using CIMSNextMCC.Application.Common.Security;
using CIMSNextMCC.Application.Tests.Arrivals;

namespace CIMSNextMCC.Application.Tests.MasterData;

/// <summary>Records every write in order, so tests can assert the legacy SP name and parameters.</summary>
internal sealed class FakeCountryRepository : ICountryRepository
{
    public List<string> Calls { get; } = [];
    public List<CountryMaster> Rows { get; init; } = [];
    public (string Name, bool StartsWith)? LastSearch { get; private set; }
    public List<CountryNameHit> Hits { get; init; } = [];

    public Task<IReadOnlyList<CountryMaster>> GetAllAsync(CancellationToken cancellationToken = default) =>
        Task.FromResult<IReadOnlyList<CountryMaster>>(Rows);

    public Task<CountryMaster?> FindAsync(string countryCode, CancellationToken cancellationToken = default) =>
        Task.FromResult(Rows.FirstOrDefault(r => string.Equals(r.CountryCode, countryCode, StringComparison.OrdinalIgnoreCase)));

    public Task<IReadOnlyList<CountryNameHit>> SearchByNameAsync(string name, bool startsWith, CancellationToken cancellationToken = default)
    {
        LastSearch = (name, startsWith);
        return Task.FromResult<IReadOnlyList<CountryNameHit>>(Hits);
    }

    public Task AddAsync(string countryCode, string countryName, string cargoMovement, string enterBy, CancellationToken cancellationToken = default)
    {
        Calls.Add($"CountryAdd({countryCode},{countryName},{cargoMovement},{enterBy})");
        return Task.CompletedTask;
    }

    public Task UpdateAsync(string countryCode, string countryName, string cargoMovement, string updateBy, CancellationToken cancellationToken = default)
    {
        Calls.Add($"CountryEdit({countryCode},{countryName},{cargoMovement},{updateBy})");
        return Task.CompletedTask;
    }
}

internal sealed class FakePortRepository : IPortRepository
{
    public List<string> Calls { get; } = [];
    public List<PortMaster> Rows { get; init; } = [];
    public string? LastCountryFilter { get; private set; }
    public (string Name, bool StartsWith)? LastSearch { get; private set; }
    public List<PortNameHit> Hits { get; init; } = [];

    public Task<IReadOnlyList<PortMaster>> GetAllAsync(string? countryCode, CancellationToken cancellationToken = default)
    {
        LastCountryFilter = countryCode;
        return Task.FromResult<IReadOnlyList<PortMaster>>(Rows);
    }

    public Task<PortMaster?> FindAsync(string portCode, CancellationToken cancellationToken = default) =>
        Task.FromResult(Rows.FirstOrDefault(r => string.Equals(r.PortCode, portCode, StringComparison.OrdinalIgnoreCase)));

    public Task<IReadOnlyList<PortNameHit>> SearchByNameAsync(string name, bool startsWith, CancellationToken cancellationToken = default)
    {
        LastSearch = (name, startsWith);
        return Task.FromResult<IReadOnlyList<PortNameHit>>(Hits);
    }

    public Task AddAsync(string portCode, string portName, string countryCode, bool isDivertable, string createBy, CancellationToken cancellationToken = default)
    {
        Calls.Add($"PortsAdd({portCode},{portName},{countryCode},{isDivertable},{createBy})");
        return Task.CompletedTask;
    }

    public Task UpdateAsync(string portCode, string portName, string countryCode, bool isDivertable, string updateBy, CancellationToken cancellationToken = default)
    {
        Calls.Add($"PortsEdit({portCode},{portName},{countryCode},{isDivertable},{updateBy})");
        return Task.CompletedTask;
    }
}

internal sealed class FakeDcRepository : IDcRepository
{
    public List<string> Calls { get; } = [];
    public List<DcMaster> Rows { get; init; } = [];

    public Task<IReadOnlyList<DcMaster>> GetAllAsync(CancellationToken cancellationToken = default) =>
        Task.FromResult<IReadOnlyList<DcMaster>>(Rows);

    public Task<DcMaster?> FindAsync(string whDes, CancellationToken cancellationToken = default) =>
        Task.FromResult(Rows.FirstOrDefault(r => string.Equals(r.WhDes, whDes, StringComparison.OrdinalIgnoreCase)));

    public Task AddAsync(string whCode, string whDes, string countryCode, CancellationToken cancellationToken = default)
    {
        Calls.Add($"DestWarehouseAdd([{whCode}],{whDes},{countryCode})");
        return Task.CompletedTask;
    }

    public Task UpdateAsync(string whCode, string whDes, string countryCode, CancellationToken cancellationToken = default)
    {
        Calls.Add($"DestWarehouseEdit([{whCode}],{whDes},{countryCode})");
        return Task.CompletedTask;
    }
}

internal static class AuditUser
{
    public static LegacyAuditUserResolver Resolver(params LegacyUser[] users) =>
        new(
            new FakeLegacyUserRepository(users.Length > 0 ? users : [new LegacyUser { UserName = "floor1", UserId = "U-0001" }]),
            new FakeCurrentUser("floor1"));
}
