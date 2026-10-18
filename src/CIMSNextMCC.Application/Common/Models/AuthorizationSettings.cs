namespace CIMSNextMCC.Application.Common.Models;

/// <summary>Bound from the "Authorization" section.</summary>
public class AuthorizationSettings
{
    /// <summary>
    /// When true, a [RequireMenu] denial is logged and the call is allowed. Used for the first rollout
    /// so workflows that call an endpoint outside its menu page are found before they break
    /// (docs/09 section 4.2 item 5). Set to false to enforce.
    /// </summary>
    public bool LogOnly { get; set; } = true;
}
