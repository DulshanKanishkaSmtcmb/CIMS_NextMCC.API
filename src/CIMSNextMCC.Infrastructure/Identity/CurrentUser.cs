using System.Security.Claims;
using CIMSNextMCC.Application.Interfaces.Common;
using Microsoft.AspNetCore.Http;

namespace CIMSNextMCC.Infrastructure.Identity;

/// <summary>
/// Built from token claims by name, never by position (the legacy cookie's ElementAt(n) pattern is gone).
/// Claim names: username, sub, category, level. Tenant comes from <see cref="ITenantContext"/>.
///
/// TODO(docs/09 section 4.2 item 4): AllowedDCs, AllowedShippers and MenuKeys must come from a cached lookup in the
/// tenant's Main database (CloudMenuAllocation, PwInfoDC, PwInfoShippers, keyed by username). Until that lands they
/// are empty, so [RequireMenu] denies everything; keep Authorization:LogOnly = true until the lookup exists.
/// </summary>
public sealed class CurrentUser(IHttpContextAccessor httpContextAccessor, ITenantContext tenantContext) : ICurrentUser
{
    private ClaimsPrincipal? Principal => httpContextAccessor.HttpContext?.User;

    public bool IsAuthenticated => Principal?.Identity?.IsAuthenticated == true;

    public string UserKey =>
        Principal?.FindFirstValue("sub") ?? Principal?.FindFirstValue(ClaimTypes.NameIdentifier) ?? string.Empty;

    public string UserName =>
        Principal?.FindFirstValue("username") ?? Principal?.Identity?.Name ?? Principal?.FindFirstValue(ClaimTypes.Name) ?? string.Empty;

    public string? UserCategory => Principal?.FindFirstValue("category");

    public string? UserLevel => Principal?.FindFirstValue("level");

    public string Tenant => tenantContext.Key;

    public IReadOnlyList<string> AllowedDCs => [];

    public IReadOnlyList<string> AllowedShippers => [];

    public IReadOnlyList<string> MenuKeys => [];
}
