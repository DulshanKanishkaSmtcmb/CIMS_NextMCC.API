using CIMSNextMCC.Domain.Entities.MasterData;

namespace CIMSNextMCC.Application.Interfaces.Repositories.MasterData;

/// <summary>
/// Data access for the Ports master page (legacy File/Ports). Writes call the same stored procedures with the same
/// parameters as legacy SaveApi/SavePortData and run in the request's unit-of-work transaction.
/// </summary>
public interface IPortRepository
{
    /// <summary>dbo.Ports ordered by PortCode, optionally only one CountryCode (legacy DataApi/getPortList).</summary>
    Task<IReadOnlyList<PortMaster>> GetAllAsync(string? countryCode, CancellationToken cancellationToken = default);

    /// <summary>The row whose PortCode equals <paramref name="portCode"/> (column collation), or null (legacy DataApi/getPortData).</summary>
    Task<PortMaster?> FindAsync(string portCode, CancellationToken cancellationToken = default);

    /// <summary>Rows whose PortName starts with (or equals) <paramref name="name"/>, ordered by PortName (legacy DataApi/findPortName).</summary>
    Task<IReadOnlyList<PortNameHit>> SearchByNameAsync(string name, bool startsWith, CancellationToken cancellationToken = default);

    /// <summary>SP PortsAdd @PortCode, @PortName, @CountryCode, @IsDivertable, @CreateBy.</summary>
    Task AddAsync(string portCode, string portName, string countryCode, bool isDivertable, string createBy, CancellationToken cancellationToken = default);

    /// <summary>SP PortsEdit @PortCode, @PortName, @CountryCode, @IsDivertable, @UpdateBy.</summary>
    Task UpdateAsync(string portCode, string portName, string countryCode, bool isDivertable, string updateBy, CancellationToken cancellationToken = default);
}
