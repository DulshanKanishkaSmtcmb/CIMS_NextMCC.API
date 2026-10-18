namespace CIMSNextMCC.Infrastructure.LegacyBridge;

/// <summary>
/// "LegacyBridge" configuration. Every value must match the legacy app (Web.config appSettings SharedKeyRingPath and
/// App_Start/Startup.Auth.cs), otherwise the legacy app silently ignores the cookie and redirects to its login page.
/// </summary>
public sealed class LegacyBridgeOptions
{
    public const string SectionName = "LegacyBridge";

    /// <summary>Folder of the Data Protection key ring shared with the legacy app. Both app identities need read/write.</summary>
    public string SharedKeyRingPath { get; set; } = @"C:\ProgramData\CIMS\keys";

    /// <summary>The legacy OWIN application cookie name (Katana default for the "ApplicationCookie" type).</summary>
    public string CookieName { get; set; } = ".AspNet.ApplicationCookie";

    /// <summary>Data Protection application name; isolates this key ring's purpose tree.</summary>
    public string ApplicationName { get; set; } = "CIMS_NextMCC";

    /// <summary>Ticket lifetime; the legacy SignInUser issues one day.</summary>
    public int ExpiryHours { get; set; } = 24;
}

public static class LegacyBridgeDefaults
{
    /// <summary>ASP.NET Core authentication scheme for the bridge cookie. Never the default scheme.</summary>
    public const string Scheme = "LegacyCookie";

    /// <summary>
    /// Data Protection purposes of the cookie ticket: what the ASP.NET Core cookie handler uses for a scheme
    /// (CookieAuthenticationMiddleware, scheme name, "v2"). The legacy Startup.Auth.cs creates its protector with
    /// exactly these strings.
    /// </summary>
    public static readonly string[] ProtectorPurposes =
    [
        "Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationMiddleware",
        Scheme,
        "v2"
    ];
}
