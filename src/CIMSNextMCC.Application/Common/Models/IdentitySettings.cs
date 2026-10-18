namespace CIMSNextMCC.Application.Common.Models;

/// <summary>Bound from the "Identity" section: the CIMS Identity Server this API trusts.</summary>
public class IdentitySettings
{
    public string Authority { get; set; } = string.Empty;
    public string Audience { get; set; } = "cims-nextmcc-api";
    public string RequiredScope { get; set; } = "cims.nextmcc";
    public bool RequireHttpsMetadata { get; set; } = true;
}
