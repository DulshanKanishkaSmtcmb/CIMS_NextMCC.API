<#
.SYNOPSIS
  Spike helper for cookie-bridge-proof.ps1: protects an OWIN ticket exactly as the legacy app does, with the legacy
  site's own bin assemblies (Katana 4.2.2, Microsoft.Owin.Security.Interop, DataProtection 2.3) on .NET Framework.

.DESCRIPTION
  Must run in Windows PowerShell 5.1 (.NET Framework). Builds the identity the way AccountController.SignInUser does
  (Name, ReverseMiddle(UserId), ConvertAsc(UserCategory), UserLevel; type "ApplicationCookie"; IssuedUtc + 1 day)
  and the ticket format the way App_Start/Startup.Auth.cs does, then writes the cookie value to stdout.
  The user values come from environment variables (CB_USERNAME, CB_USERID, CB_CATEGORY, CB_LEVEL) so they never
  appear on a command line. Nothing is written to the database or to the legacy app.
#>
param(
    [Parameter(Mandatory)] [string] $BinPath,
    [Parameter(Mandatory)] [string] $KeyRingPath
)
$ErrorActionPreference = 'Stop'
if ($PSVersionTable.PSEdition -ne 'Desktop') { throw 'Run with Windows PowerShell 5.1 (.NET Framework).' }

# The legacy app gets these through Web.config binding redirects; here a resolver loads any version from bin.
Add-Type -TypeDefinition @'
using System;
using System.IO;
using System.Reflection;
public static class BinResolver
{
    public static void Register(string bin)
    {
        AppDomain.CurrentDomain.AssemblyResolve += (sender, args) =>
        {
            var path = Path.Combine(bin, new AssemblyName(args.Name).Name + ".dll");
            return File.Exists(path) ? Assembly.LoadFrom(path) : null;
        };
    }
}
'@
[BinResolver]::Register($BinPath)

# The runtime facade (the reference-assembly one makes Add-Type look for mscorlib in the Facades folder).
$netstandard = Join-Path ([Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory()) 'netstandard.dll'
$refs = @('Microsoft.Owin.dll', 'Microsoft.Owin.Security.dll', 'Microsoft.Owin.Security.Interop.dll',
          'Microsoft.AspNetCore.DataProtection.dll', 'Microsoft.AspNetCore.DataProtection.Abstractions.dll',
          'Microsoft.AspNetCore.DataProtection.Extensions.dll') | ForEach-Object { Join-Path $BinPath $_ }
Add-Type -ReferencedAssemblies ($refs + $netstandard) -TypeDefinition @'
using System;
using System.Collections.Generic;
using System.IO;
using System.Security.Claims;
using System.Text;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.Owin.Security;
using Microsoft.Owin.Security.Interop;

public static class LegacyTicketMinter
{
    // clsDBUtility.ReverseMiddle (non-empty input).
    static string ReverseMiddle(string s)
    {
        var sb = new StringBuilder(s.Substring(0, 1));
        for (var i = s.Length - 2; i >= 1; i--) sb.Append(s[i]);
        if (s.Length > 1) sb.Append(s[s.Length - 1]);
        return sb.ToString();
    }

    // clsDBUtility.ConvertAsc for ASCII input (Encoding.Default = ANSI code page).
    static string ConvertAsc(string s)
    {
        var sb = new StringBuilder();
        foreach (var c in s)
        {
            var b = Encoding.Default.GetBytes(c.ToString());
            b[0] = Convert.ToByte(b[0] * 2);
            sb.Append(Encoding.Default.GetString(b));
        }
        return sb.ToString();
    }

    public static string Mint(string keyRingPath, string userName, string userId, string category, string level)
    {
        // As App_Start/Startup.Auth.cs CreateSharedTicketFormat.
        var provider = DataProtectionProvider.Create(new DirectoryInfo(keyRingPath), b => b.SetApplicationName("CIMS_NextMCC"));
        var format = new AspNetTicketDataFormat(new DataProtectorShim(provider.CreateProtector(
            "Microsoft.AspNetCore.Authentication.Cookies.CookieAuthenticationMiddleware", "LegacyCookie", "v2")));

        // As AccountController.Login + SignInUser.
        var claims = new List<Claim>
        {
            new Claim(ClaimTypes.Name, userName),
            new Claim(ClaimTypes.Sid, ReverseMiddle(userId)),
            new Claim(ClaimTypes.GroupSid, ConvertAsc(category)),
            new Claim(ClaimTypes.Surname, level)
        };
        var props = new AuthenticationProperties { IssuedUtc = DateTime.UtcNow, ExpiresUtc = DateTime.UtcNow.AddDays(1) };
        return format.Protect(new AuthenticationTicket(new ClaimsIdentity(claims, "ApplicationCookie"), props));
    }
}
'@
[LegacyTicketMinter]::Mint($KeyRingPath, $env:CB_USERNAME, $env:CB_USERID, $env:CB_CATEGORY, $env:CB_LEVEL)
