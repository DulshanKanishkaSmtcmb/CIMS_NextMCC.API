using CIMSNextMCC.Domain.Entities.MasterData;

namespace CIMSNextMCC.Application.Interfaces.Repositories.MasterData;

/// <summary>
/// Data access for the Rate Card page (legacy File/RateCardEntry, DataApi/getRateInformation4Add): the same five queries
/// with the same projections and order, parameterless. The page has no write.
/// </summary>
public interface IRateCardRepository
{
    /// <summary><c>select t1.ContainerType from ContainerType t1 Order By t1.ContainerType</c>.</summary>
    Task<IReadOnlyList<string>> GetContainerTypesAsync(CancellationToken cancellationToken = default);

    /// <summary><c>select t1.PortCode, t1.PortName from Ports t1 order by t1.PortCode</c>.</summary>
    Task<IReadOnlyList<RatePort>> GetPortsAsync(CancellationToken cancellationToken = default);

    /// <summary>dbo.RateClearHaulageExport <c>Order By t1.CntrType</c>.</summary>
    Task<IReadOnlyList<ClearanceRate>> GetClearanceRatesAsync(CancellationToken cancellationToken = default);

    /// <summary>dbo.RateFreightExport inner join dbo.Ports <c>Order By t1.PortCode, t1.CntrType</c>.</summary>
    Task<IReadOnlyList<FreightRate>> GetFreightRatesAsync(CancellationToken cancellationToken = default);

    /// <summary>dbo.RateCFSExport left join dbo.PMMaster <c>Order By t1.ChgCode</c>.</summary>
    Task<IReadOnlyList<CfsRate>> GetCfsRatesAsync(CancellationToken cancellationToken = default);
}
