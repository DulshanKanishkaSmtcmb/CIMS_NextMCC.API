<#
.SYNOPSIS
  Mints a DevJwt bearer token (dotnet user-jwts) for a PwInfo user, for the dev-token sign-in on
  http://localhost:8080/Account/Login. The token goes to the clipboard (or -OutFile), never to the console.

.DESCRIPTION
  Claims as the API expects them: username=<PwInfo UserName>, tenant=NextMCC, audience cims-nextmcc-api, scope
  cims.nextmcc. appsettings.Development.json is restored byte for byte afterwards (dotnet user-jwts rewrites it).
  Remove a token early with:  dotnet user-jwts remove <id> --project src/CIMSNextMCC.API

.EXAMPLE
  powershell -NoProfile -ExecutionPolicy Bypass -File deploy\dev-gateway\new-dev-token.ps1 -UserName Madhuka
.EXAMPLE
  powershell -NoProfile -ExecutionPolicy Bypass -File deploy\dev-gateway\new-dev-token.ps1 -UserName Madhuka -OutFile $env:TEMP\devgw.token
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)] [string] $UserName,
    [string] $ValidFor = '8h',
    # Write the token to this file instead of the clipboard (for scripts such as the Playwright run).
    [string] $OutFile
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'devgw.common.ps1')

$jwt = New-DevGwToken $UserName $ValidFor
if ($OutFile) {
    [IO.File]::WriteAllText($OutFile, $jwt.Token)
    Write-Host "Token for $UserName written to $OutFile"
}
else {
    Set-Clipboard -Value $jwt.Token
    Write-Host "Token for $UserName copied to the clipboard. Paste it under 'Use dev token' at $($DevGw.Gateway)/Account/Login"
}
Write-Host "Valid for $ValidFor; id $($jwt.Id) (dotnet user-jwts remove $($jwt.Id) --project src/CIMSNextMCC.API)"
