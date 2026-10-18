namespace CIMSNextMCC.Application.Interfaces.Common;

/// <summary>The tenant for the current request. Resolved lazily; throws ForbiddenException if it cannot be resolved.</summary>
public interface ITenantContext
{
    /// <summary>Tenant key, e.g. "NextMCC" or "NextCFS".</summary>
    string Key { get; }

    /// <summary>Tenants the token allows this user to switch to (the "tenants" claim).</summary>
    IReadOnlyList<string> AllowedTenants { get; }
}
