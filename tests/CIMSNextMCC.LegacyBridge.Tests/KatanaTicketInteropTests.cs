using System.Security.Claims;
using CIMSNextMCC.Infrastructure.LegacyBridge;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using Microsoft.Owin.Security.Interop;
using OwinProperties = Microsoft.Owin.Security.AuthenticationProperties;
using OwinTicket = Microsoft.Owin.Security.AuthenticationTicket;

namespace CIMSNextMCC.LegacyBridge.Tests;

/// <summary>
/// Runs the legacy app's ticket format (Microsoft.Owin.Security.Interop, configured exactly like the legacy
/// App_Start/Startup.Auth.cs) in-process against the API's configured LegacyCookie scheme, over one key ring folder.
/// Covers the ticket serialization both ways; the cross-runtime key ring (DataProtection 2.3 on .NET Framework vs
/// 10.0) is covered by the end-to-end proof, deploy/spike/cookie-bridge-proof.ps1.
/// </summary>
public sealed class KatanaTicketInteropTests : IDisposable
{
    private readonly DirectoryInfo _keyRing = Directory.CreateTempSubdirectory("cims-keyring-");

    public void Dispose() => _keyRing.Delete(recursive: true);

    /// <summary>The API side: the TicketDataFormat of the LegacyCookie scheme as AddLegacyCookie configures it.</summary>
    private ISecureDataFormat<AuthenticationTicket> ApiFormat()
    {
        var configuration = new ConfigurationBuilder()
            .AddInMemoryCollection(new Dictionary<string, string?> { ["LegacyBridge:SharedKeyRingPath"] = _keyRing.FullName })
            .Build();

        var services = new ServiceCollection();
        services.AddLogging();
        services.AddAuthentication().AddLegacyCookie(configuration);

        return services.BuildServiceProvider()
            .GetRequiredService<IOptionsMonitor<CookieAuthenticationOptions>>()
            .Get(LegacyBridgeDefaults.Scheme)
            .TicketDataFormat;
    }

    /// <summary>The legacy side, as in Startup.Auth.cs (a separate provider instance over the same folder).</summary>
    private AspNetTicketDataFormat LegacyFormat(string applicationName = "CIMS_NextMCC", string scheme = "LegacyCookie") =>
        new(new DataProtectorShim(
            DataProtectionProvider.Create(_keyRing, builder => builder.SetApplicationName(applicationName))
                .CreateProtector(
                    "Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationMiddleware",
                    scheme,
                    "v2")));

    private static DateTimeOffset Seconds(DateTimeOffset value) =>
        value.AddTicks(-(value.Ticks % TimeSpan.TicksPerSecond)); // tickets store dates in "r" format

    [Fact]
    public void A_ticket_issued_by_the_API_is_read_by_the_legacy_app_with_the_same_claims_in_order()
    {
        var identity = LegacyClaims.CreateIdentity(LegacyClaimsTests.SampleUser);
        var issued = DateTimeOffset.UtcNow;
        var properties = new AuthenticationProperties { IssuedUtc = issued, ExpiresUtc = issued.AddHours(24) };

        var cookieValue = ApiFormat().Protect(
            new AuthenticationTicket(new ClaimsPrincipal(identity), properties, LegacyBridgeDefaults.Scheme));
        var legacyTicket = LegacyFormat().Unprotect(cookieValue);

        Assert.NotNull(legacyTicket);
        Assert.Equal("ApplicationCookie", legacyTicket.Identity.AuthenticationType);
        Assert.True(legacyTicket.Identity.IsAuthenticated);
        Assert.Equal("jdoe", legacyTicket.Identity.Name);
        Assert.Equal(
            identity.Claims.Select(c => (c.Type, c.Value)),
            legacyTicket.Identity.Claims.Select(c => (c.Type, c.Value)));
        Assert.Equal(Seconds(issued), legacyTicket.Properties.IssuedUtc);
        Assert.Equal(Seconds(issued.AddHours(24)), legacyTicket.Properties.ExpiresUtc);
        Assert.False(legacyTicket.Properties.IsPersistent);

        // And the legacy controllers' positional decoding works on what the legacy app reads.
        Assert.Equal("1202xQaHZ", LegacyClaimCodec.ReverseMiddle(legacyTicket.Identity.Claims.ElementAt(1).Value));
        Assert.Equal("Employee", LegacyClaimCodec.ReConvertAsc(legacyTicket.Identity.Claims.ElementAt(2).Value));
    }

    [Fact]
    public void A_ticket_issued_by_the_legacy_login_is_read_by_the_API()
    {
        // What SignInUser hands to the Katana cookie middleware.
        var claims = new List<Claim>
        {
            new(ClaimTypes.Name, "jdoe"),
            new(ClaimTypes.Sid, LegacyClaimCodec.ReverseMiddle("1202xQaHZ")),
            new(ClaimTypes.GroupSid, LegacyClaimCodec.ConvertAsc("CFS")),
            new(ClaimTypes.Surname, "\u0090Òæ")
        };
        var issued = DateTimeOffset.UtcNow;
        var legacyTicket = new OwinTicket(
            new ClaimsIdentity(claims, "ApplicationCookie"),
            new OwinProperties { IssuedUtc = issued, ExpiresUtc = issued.AddDays(1) });

        var apiTicket = ApiFormat().Unprotect(LegacyFormat().Protect(legacyTicket));

        Assert.NotNull(apiTicket);
        var identity = Assert.Single(apiTicket.Principal.Identities);
        Assert.Equal("ApplicationCookie", identity.AuthenticationType);
        Assert.Equal(claims.Select(c => (c.Type, c.Value)), identity.Claims.Select(c => (c.Type, c.Value)));
        Assert.Equal(Seconds(issued.AddDays(1)), apiTicket.Properties.ExpiresUtc);
    }

    [Theory]
    [InlineData("CIMS_NextMCC", "Identity.Application")] // scheme name in the purposes differs
    [InlineData("SomeOtherApp", "LegacyCookie")]         // application name differs
    public void The_legacy_app_ignores_a_ticket_when_the_purposes_do_not_match(string applicationName, string scheme)
    {
        var identity = LegacyClaims.CreateIdentity(LegacyClaimsTests.SampleUser);
        var cookieValue = ApiFormat().Protect(
            new AuthenticationTicket(new ClaimsPrincipal(identity), new AuthenticationProperties(), LegacyBridgeDefaults.Scheme));

        Assert.Null(LegacyFormat(applicationName, scheme).Unprotect(cookieValue));
    }
}
