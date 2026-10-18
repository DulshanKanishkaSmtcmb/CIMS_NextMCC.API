namespace CIMSNextMCC.Domain.Entities.Arrivals;

/// <summary>A supplier with pending arrivals that are not on an import container (legacy dtDtl1).</summary>
public class PendingArrivalSupplier
{
    public string ShipperCode { get; set; } = string.Empty;
    public string? ShipperName { get; set; }
}
