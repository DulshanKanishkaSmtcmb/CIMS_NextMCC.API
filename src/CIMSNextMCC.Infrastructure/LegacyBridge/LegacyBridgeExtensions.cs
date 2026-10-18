using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace CIMSNextMCC.Infrastructure.LegacyBridge;

public static class LegacyBridgeExtensions
{
    /// <summary>
    /// Adds the "LegacyCookie" scheme: an ASP.NET Core cookie whose ticket the legacy Katana app can read
    /// (Microsoft.Owin.Security.Interop on the legacy side, see docs/11-cookie-bridge-spike.md in the legacy repo).
    /// The shared key ring is used by this scheme only; the API's own Data Protection stays untouched.
    /// </summary>
    public static AuthenticationBuilder AddLegacyCookie(this AuthenticationBuilder builder, IConfiguration configuration)
    {
        var section = configuration.GetSection(LegacyBridgeOptions.SectionName);
        var settings = section.Get<LegacyBridgeOptions>() ?? new LegacyBridgeOptions();
        builder.Services.Configure<LegacyBridgeOptions>(section);

        var dataProtection = DataProtectionProvider.Create(
            new DirectoryInfo(settings.SharedKeyRingPath),
            dataProtectionBuilder => dataProtectionBuilder.SetApplicationName(settings.ApplicationName));

        return builder.AddCookie(LegacyBridgeDefaults.Scheme, options =>
        {
            options.Cookie.Name = settings.CookieName;
            options.Cookie.Path = "/";
            options.Cookie.HttpOnly = true;
            options.Cookie.SameSite = SameSiteMode.Lax;
            // Same as Katana's default. Behind the TLS-terminating gateway this needs forwarded headers (or Always).
            options.Cookie.SecurePolicy = CookieSecurePolicy.SameAsRequest;
            options.ExpireTimeSpan = TimeSpan.FromHours(settings.ExpiryHours);
            // The legacy app slides the ticket; the API only issues it and must not re-issue it on reads.
            options.SlidingExpiration = false;
            options.TicketDataFormat = new TicketDataFormat(
                dataProtection.CreateProtector(LegacyBridgeDefaults.ProtectorPurposes));

            // An API never redirects to a login page.
            options.Events.OnRedirectToLogin = context =>
            {
                context.Response.StatusCode = StatusCodes.Status401Unauthorized;
                return Task.CompletedTask;
            };
            options.Events.OnRedirectToAccessDenied = context =>
            {
                context.Response.StatusCode = StatusCodes.Status403Forbidden;
                return Task.CompletedTask;
            };
        });
    }
}
