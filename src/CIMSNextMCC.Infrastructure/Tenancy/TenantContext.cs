using CIMSNextMCC.Application.Common.Exceptions;
using CIMSNextMCC.Application.Interfaces.Common;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Options;

namespace CIMSNextMCC.Infrastructure.Tenancy;

/// <summary>
/// Resolves the tenant once per request (scoped), lazily on first use:
///   1. The "tenant" claim of the token is the default.
///   2. An X-Tenant header selects another tenant, but only if that value appears in the token's "tenants"
///      claim; otherwise the request is rejected with 403 (docs/09 section 4.2 item 6).
///   3. The resolved tenant must exist in configuration, otherwise 403.
/// </summary>
public sealed class TenantContext : ITenantContext
{
    public const string TenantClaim = "tenant";
    public const string TenantsClaim = "tenants";
    public const string TenantHeader = "X-Tenant";

    private static readonly char[] ClaimSeparators = [',', ';', ' '];

    private readonly IHttpContextAccessor _httpContextAccessor;
    private readonly TenantOptions _options;
    private readonly Lazy<string> _key;

    public TenantContext(IHttpContextAccessor httpContextAccessor, IOptions<TenantOptions> options)
    {
        _httpContextAccessor = httpContextAccessor;
        _options = options.Value;
        _key = new Lazy<string>(Resolve);
    }

    public string Key => _key.Value;

    public IReadOnlyList<string> AllowedTenants
    {
        get
        {
            var user = _httpContextAccessor.HttpContext?.User;
            if (user is null)
            {
                return [];
            }

            // A JWT array claim arrives as several "tenants" claims; a plain string may be delimited.
            return user.FindAll(TenantsClaim)
                .SelectMany(c => c.Value.Split(ClaimSeparators, StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries))
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .ToList();
        }
    }

    private string Resolve()
    {
        var httpContext = _httpContextAccessor.HttpContext
            ?? throw new ForbiddenException("TENANT_NOT_RESOLVED");

        var requested = httpContext.Request.Headers[TenantHeader].FirstOrDefault()?.Trim();
        string key;

        if (!string.IsNullOrEmpty(requested))
        {
            if (!AllowedTenants.Contains(requested, StringComparer.OrdinalIgnoreCase))
            {
                throw new ForbiddenException("TENANT_NOT_ALLOWED");
            }

            key = requested;
        }
        else
        {
            key = httpContext.User.FindFirst(TenantClaim)?.Value?.Trim() ?? string.Empty;
            if (key.Length == 0)
            {
                throw new ForbiddenException("TENANT_MISSING");
            }
        }

        var configured = _options.Find(key) ?? throw new ForbiddenException("TENANT_UNKNOWN");
        return configured.Key;
    }
}
