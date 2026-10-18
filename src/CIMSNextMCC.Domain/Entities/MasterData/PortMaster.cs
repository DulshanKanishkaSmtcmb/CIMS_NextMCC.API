namespace CIMSNextMCC.Domain.Entities.MasterData;

/// <summary>A full dbo.Ports row (legacy <c>select t1.*</c>).</summary>
public class PortMaster
{
    public string PortCode { get; set; } = string.Empty;
    public string PortName { get; set; } = string.Empty;
    public string CountryCode { get; set; } = string.Empty;
    public DateTime? DateCreate { get; set; }
    public string CreateBy { get; set; } = string.Empty;
    public DateTime? DateUpdate { get; set; }
    public string UpdateBy { get; set; } = string.Empty;
    public string SeaOrAirPort { get; set; } = string.Empty;
    public bool IsDivertable { get; set; }
}

/// <summary>The three columns legacy DataApi/findPortName returns for the "pre-entered" box.</summary>
public class PortNameHit
{
    public string PortCode { get; set; } = string.Empty;
    public string PortName { get; set; } = string.Empty;
    public string CountryCode { get; set; } = string.Empty;
}
