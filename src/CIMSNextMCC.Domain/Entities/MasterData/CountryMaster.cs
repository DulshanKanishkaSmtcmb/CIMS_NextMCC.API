namespace CIMSNextMCC.Domain.Entities.MasterData;

/// <summary>A full dbo.Country row (legacy <c>select t1.*</c>), as the Country master page and its listing dialog show it.</summary>
public class CountryMaster
{
    public string CountryCode { get; set; } = string.Empty;
    public string CountryName { get; set; } = string.Empty;
    public string CargoMovement { get; set; } = string.Empty;
    public DateTime? DateEnter { get; set; }
    public string EnterBy { get; set; } = string.Empty;
    public DateTime? DateUpdate { get; set; }
    public string UpdateBy { get; set; } = string.Empty;
    public bool ContractBlock { get; set; }
}

/// <summary>The three columns legacy DataApi/findCountryName returns for the "pre-entered" box.</summary>
public class CountryNameHit
{
    public string CountryCode { get; set; } = string.Empty;
    public string CountryName { get; set; } = string.Empty;
    public string CargoMovement { get; set; } = string.Empty;
}
