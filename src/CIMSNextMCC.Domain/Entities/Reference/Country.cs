namespace CIMSNextMCC.Domain.Entities.Reference;

/// <summary>dbo.Country; only the columns the migrated pages use so far.</summary>
public class Country
{
    public string CountryCode { get; set; } = string.Empty;
    public string CountryName { get; set; } = string.Empty;
}
