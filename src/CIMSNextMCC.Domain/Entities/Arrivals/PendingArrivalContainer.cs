namespace CIMSNextMCC.Domain.Entities.Arrivals;

/// <summary>
/// An import vessel/container key with pending arrivals (legacy dtDtl2). Includes the (null, 0, 0) key of cargo that is
/// not on an import container, exactly like the legacy query.
/// </summary>
public class PendingArrivalContainer
{
    public DateTime? InboundEtd { get; set; }
    public decimal InboundVesselOrderNo { get; set; }
    public decimal InboundContainerOrderNo { get; set; }
    public string VesselName { get; set; } = string.Empty;

    /// <summary>ContainerDataImport.NextContainerNo (legacy column alias "LoadRerence").</summary>
    public string LoadReference { get; set; } = string.Empty;

    public string ContainerNo { get; set; } = string.Empty;
    public string ContainerType { get; set; } = string.Empty;
}
