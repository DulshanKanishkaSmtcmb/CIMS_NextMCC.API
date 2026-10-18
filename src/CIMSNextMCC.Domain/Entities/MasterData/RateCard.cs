namespace CIMSNextMCC.Domain.Entities.MasterData;

/// <summary>A dbo.Ports row as the Rate Card page reads it (legacy getRateInformation4Add: PortCode, PortName).</summary>
public class RatePort
{
    public string PortCode { get; set; } = string.Empty;
    public string PortName { get; set; } = string.Empty;
}

/// <summary>A dbo.RateClearHaulageExport row (Export Clearance Charges): the rate of one container type.</summary>
public class ClearanceRate
{
    public string CntrType { get; set; } = string.Empty;
    public decimal RateInUsd { get; set; }
}

/// <summary>A dbo.RateFreightExport row joined to dbo.Ports (Export Freight Charges): the rate of one port and container type.</summary>
public class FreightRate
{
    public string PortCode { get; set; } = string.Empty;
    public string PortName { get; set; } = string.Empty;
    public string CntrType { get; set; } = string.Empty;
    public decimal RateInUsd { get; set; }
}

/// <summary>
/// A dbo.RateCFSExport row (CFS Charges) with the description of its material from dbo.PMMaster (empty when there is
/// none): legacy <c>select t1.*, isnull(t2.PMDescription,'') PMDescription</c>. The table has no key.
/// </summary>
public class CfsRate
{
    public string ChgCode { get; set; } = string.Empty;
    public string ChgDescription { get; set; } = string.Empty;
    public string UnitType { get; set; } = string.Empty;
    public decimal Range1 { get; set; }
    public decimal Range2 { get; set; }
    public string? UnitCalType { get; set; }
    public decimal RateInUsd { get; set; }
    public bool IsActive { get; set; }
    public string FileCaption { get; set; } = string.Empty;
    public string MaterialCode { get; set; } = string.Empty;
    public decimal RateInUsdCost { get; set; }
    public string RateUpdateBy { get; set; } = string.Empty;
    public DateTime? RateUpdateDate { get; set; }
    public string PmDescription { get; set; } = string.Empty;
}
