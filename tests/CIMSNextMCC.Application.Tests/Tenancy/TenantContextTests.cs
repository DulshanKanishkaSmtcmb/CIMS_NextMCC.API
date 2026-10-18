using System.Security.Claims;
using CIMSNextMCC.Application.Common.Exceptions;
using CIMSNextMCC.Infrastructure.Tenancy;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Options;

namespace CIMSNextMCC.Application.Tests.Tenancy;

public class TenantContextTests
{
    private static TenantContext CreateContext(string? tenantClaim, string[] tenantsClaims, string? tenantHeader)
    {
        var claims = new List<Claim> { new("username", "tester") };
        if (tenantClaim is not null)
        {
            claims.Add(new Claim("tenant", tenantClaim));
        }

        claims.AddRange(tenantsClaims.Select(t => new Claim("tenants", t)));

        var httpContext = new DefaultHttpContext
        {
            User = new ClaimsPrincipal(new ClaimsIdentity(claims, "test", "username", null))
        };
        if (tenantHeader is not null)
        {
            httpContext.Request.Headers["X-Tenant"] = tenantHeader;
        }

        var options = Options.Create(new TenantOptions
        {
            Tenants = [new TenantConfig { Key = "NextMCC" }, new TenantConfig { Key = "NextCFS" }]
        });

        return new TenantContext(new HttpContextAccessor { HttpContext = httpContext }, options);
    }

    [Fact]
    public void Rejects_an_X_Tenant_header_that_is_not_in_the_tenants_claim()
    {
        var context = CreateContext("NextMCC", ["NextMCC"], tenantHeader: "NextCFS");

        var exception = Assert.Throws<ForbiddenException>(() => context.Key);

        Assert.Equal(403, exception.StatusCode);
        Assert.Equal("TENANT_NOT_ALLOWED", exception.MessageCode);
    }

    [Fact]
    public void Honours_an_X_Tenant_header_that_is_in_the_tenants_claim()
    {
        var context = CreateContext("NextMCC", ["NextMCC", "NextCFS"], tenantHeader: "nextcfs");

        Assert.Equal("NextCFS", context.Key);
    }

    [Fact]
    public void Accepts_a_delimited_tenants_claim()
    {
        var context = CreateContext("NextMCC", ["NextMCC,NextCFS"], tenantHeader: "NextCFS");

        Assert.Equal("NextCFS", context.Key);
    }

    [Fact]
    public void Uses_the_tenant_claim_when_there_is_no_header()
    {
        var context = CreateContext("NextCFS", ["NextMCC", "NextCFS"], tenantHeader: null);

        Assert.Equal("NextCFS", context.Key);
    }

    [Fact]
    public void Rejects_a_token_without_a_tenant_claim_and_without_a_header()
    {
        var context = CreateContext(null, [], tenantHeader: null);

        var exception = Assert.Throws<ForbiddenException>(() => context.Key);

        Assert.Equal("TENANT_MISSING", exception.MessageCode);
    }

    [Fact]
    public void Rejects_a_tenant_that_is_not_configured()
    {
        var context = CreateContext("Unknown", [], tenantHeader: null);

        var exception = Assert.Throws<ForbiddenException>(() => context.Key);

        Assert.Equal("TENANT_UNKNOWN", exception.MessageCode);
    }
}
