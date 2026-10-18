using CIMSNextMCC.Domain.Entities.MasterData;

namespace CIMSNextMCC.Application.Interfaces.Repositories.MasterData;

/// <summary>
/// Read access to the Shipper tables of the sibling AirFreight and SeaFreight systems, which the Supplier page uses to
/// pick and show the "Shipper Code [AFOS]" and "[SFOS]" (legacy DataApi/getAirShipperList, getAirShipperData,
/// getSeaShipperList, getSeaShipperData). The databases are the tenant's <c>Air</c> and <c>Sea</c> connection strings; when one
/// is not configured or not reachable an <c>AppException</c> 503 is raised (legacy swallowed the error and returned an
/// empty table).
/// </summary>
public interface IFreightShipperRepository
{
    Task<IReadOnlyList<FreightShipper>> GetAirShippersAsync(CancellationToken cancellationToken = default);

    Task<FreightShipperName?> FindAirShipperAsync(string shCode, CancellationToken cancellationToken = default);

    Task<IReadOnlyList<FreightShipper>> GetSeaShippersAsync(CancellationToken cancellationToken = default);

    Task<FreightShipperName?> FindSeaShipperAsync(string shCode, CancellationToken cancellationToken = default);
}
