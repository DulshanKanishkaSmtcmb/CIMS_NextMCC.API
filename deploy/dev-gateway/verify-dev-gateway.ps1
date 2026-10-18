<#
.SYNOPSIS
  Proves the local gateway (start-dev-gateway.ps1 must be running): routing, pilot cookie, assets, API auth, one login
  across the new API and the legacy pages, sign-out, legacy pass-through. Every request goes to http://localhost:8080.

.DESCRIPTION
  a. /Data/ConfirmArrival: legacy without the pilot cookie, the SPA index.html with cims_pilot=1; /pilot/on and
     /pilot/off set and clear the cookie; deep links to SPA paths answer index.html.
  b. /assets/* from nginx with the one-year immutable cache; a missing asset is a 404, never index.html.
  c. /api/v1/reference/field-captions: 401 without a token, 200 with a DevJwt token.
  d. POST /api/v1/legacy-session with the token sets .AspNet.ApplicationCookie for localhost (no Domain, Path=/,
     HttpOnly, SameSite=Lax, not Secure); /Home/Index with it is 200 from the legacy app.
  e. legacy Web API through the gateway with that cookie: getCloudMenuItems (uid from the page) and getQCPendingCount
     (reads the cookie's claims) return data.
  f. DELETE /api/v1/legacy-session clears the cookie; /Home/Index redirects to /Account/Login on 8080 again.
  g. /Sounds/, /Content/, /Scripts/ and a Crystal handler path pass through to the legacy app.
  Reads only (the save endpoint is not called). Tokens, cookie values and UserIds are never printed. The DevJwt token
  is removed again at the end.

  h. -Browser: the same story in installed Chrome with Playwright (FE repo apps/web/e2e/dev-gateway.spec.ts), saving
     screenshots to deploy\dev-gateway\screenshots.

.EXAMPLE
  powershell -NoProfile -ExecutionPolicy Bypass -File deploy\dev-gateway\verify-dev-gateway.ps1 -UserName Madhuka
.EXAMPLE
  powershell -NoProfile -ExecutionPolicy Bypass -File deploy\dev-gateway\verify-dev-gateway.ps1 -Browser
#>
[CmdletBinding()]
param(
    # A PwInfo user of the Test database.
    [string] $UserName = 'Madhuka',
    # Also run the Playwright browser proof (needs Google Chrome installed; Playwright's own Chromium is not used).
    [switch] $Browser,
    [string] $BrowserChannel = 'chrome'
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'devgw.common.ps1')

$gw = $DevGw.Gateway
$gwUri = [Uri] $gw
$cookieName = '.AspNet.ApplicationCookie'
$results = New-Object System.Collections.Generic.List[object]

function Check([string] $id, [string] $name, [bool] $ok, [string] $detail = '') {
    $results.Add([pscustomobject]@{ Id = $id; Check = $name; Passed = $ok; Detail = $detail })
    $mark = if ($ok) { 'PASS' } else { 'FAIL' }
    $color = if ($ok) { 'Green' } else { 'Red' }
    Write-Host ("  [{0}] {1} {2}{3}" -f $mark, $id, $name, $(if ($detail) { " -- $detail" } else { '' })) -ForegroundColor $color
}

Add-Type -AssemblyName System.Net.Http
$jar = New-Object System.Net.CookieContainer
$handler = New-Object System.Net.Http.HttpClientHandler
$handler.CookieContainer = $jar; $handler.UseCookies = $true; $handler.AllowAutoRedirect = $false
$http = New-Object System.Net.Http.HttpClient $handler
$http.Timeout = [TimeSpan]::FromMinutes(5)

function Send([string] $method, [string] $path, [string] $bearer) {
    $request = New-Object System.Net.Http.HttpRequestMessage -ArgumentList ([System.Net.Http.HttpMethod]::new($method)), ($gw + $path)
    if ($bearer) { $request.Headers.Authorization = New-Object System.Net.Http.Headers.AuthenticationHeaderValue 'Bearer', $bearer }
    $response = $http.SendAsync($request).GetAwaiter().GetResult()
    $bytes = $response.Content.ReadAsByteArrayAsync().GetAwaiter().GetResult()
    $values = $null
    $header = {
        param($name)
        $v = $null
        if ($response.Headers.TryGetValues($name, [ref] $v)) { return (@($v) -join ', ') }
        if ($response.Content.Headers.TryGetValues($name, [ref] $v)) { return (@($v) -join ', ') }
        return ''
    }
    $setCookie = @(); if ($response.Headers.TryGetValues('Set-Cookie', [ref] $values)) { $setCookie = @($values) }
    [pscustomobject]@{
        Status       = [int] $response.StatusCode
        Body         = [Text.Encoding]::UTF8.GetString($bytes)
        Length       = $bytes.Length
        Location     = $(if ($response.Headers.Location) { $response.Headers.Location.OriginalString } else { '' })
        ServedBy     = (& $header 'X-Served-By')
        CacheControl = (& $header 'Cache-Control')
        Expires      = (& $header 'Expires')
        ContentType  = (& $header 'Content-Type')
        SetCookie    = $setCookie
    }
}

function Set-PilotCookie([bool] $on) {
    foreach ($c in @($jar.GetCookies($gwUri)) | Where-Object { $_.Name -eq 'cims_pilot' }) { $c.Expired = $true }
    if ($on) { $jar.Add($gwUri, (New-Object System.Net.Cookie 'cims_pilot', '1', '/', 'localhost')) }
}
function Get-LegacyCookie { @($jar.GetCookies($gwUri)) | Where-Object { $_.Name -eq $cookieName } | Select-Object -First 1 }
function Test-LoginRedirect($r) {
    # Katana's redirect is absolute and built from the Host header: it must stay on the gateway's origin.
    $r.Status -eq 302 -and ($r.Location -like "$gw/Account/Login*" -or $r.Location -like '/Account/Login*')
}
function Test-SpaIndex($r) { $r.Status -eq 200 -and $r.Body -match '<div id="root">' -and $r.Body -match '/assets/' }
function Get-PageUid([string] $html) {
    $m = [regex]::Match($html, 'id="txtMyUid"\s+value=(?:"([^"]*)"|''([^'']*)''|([^\s>]*))')
    [System.Net.WebUtility]::HtmlDecode($m.Groups[1].Value + $m.Groups[2].Value + $m.Groups[3].Value)
}

$tokenIds = @()
try {
    Write-Host "== Gateway $gw (user $UserName)"
    $down = @(Get-DevGwStatus | Where-Object { -not $_.Up })
    if ($down) { throw "Not running: $(($down | ForEach-Object Component) -join ', '). Start it with start-dev-gateway.ps1." }

    # ---------- a. routing table and pilot cookie ----------
    Write-Host '== a. Routing table and pilot cookie'
    Set-PilotCookie $false
    $r = Send 'GET' '/Data/ConfirmArrival'
    Check 'a1' 'GET /Data/ConfirmArrival without cims_pilot -> legacy (login redirect on 8080)' ((Test-LoginRedirect $r) -and $r.ServedBy -eq 'legacy') "HTTP $($r.Status) -> $($r.Location), served by $($r.ServedBy)"
    Set-PilotCookie $true
    $r = Send 'GET' '/Data/ConfirmArrival'
    Check 'a2' 'GET /Data/ConfirmArrival with cims_pilot=1 -> SPA index.html, not cached' ((Test-SpaIndex $r) -and $r.ServedBy -eq 'spa' -and $r.CacheControl -match 'no-cache') "HTTP $($r.Status), served by $($r.ServedBy), Cache-Control '$($r.CacheControl)'"
    $r = Send 'GET' '/Data/ConfirmArrival?reload=1'
    Check 'a3' 'deep link with a query string (reload/bookmark) -> SPA index.html' (Test-SpaIndex $r) "HTTP $($r.Status)"
    Set-PilotCookie $false
    $r = Send 'GET' '/Account/Login?ReturnUrl=%2FHome%2FIndex'
    Check 'a4' 'GET /Account/Login?ReturnUrl=... -> SPA index.html for everyone' ((Test-SpaIndex $r) -and $r.ServedBy -eq 'spa') "HTTP $($r.Status), served by $($r.ServedBy)"
    $r = Send 'GET' '/login'
    Check 'a5' 'GET /login -> SPA index.html' (Test-SpaIndex $r) "HTTP $($r.Status)"
    $r = Send 'GET' '/pilot/on'
    $pilot = @($jar.GetCookies($gwUri)) | Where-Object { $_.Name -eq 'cims_pilot' -and $_.Value -eq '1' }
    Check 'a6' 'GET /pilot/on sets cims_pilot=1 (Path=/) and redirects' ($r.Status -eq 302 -and $pilot -and (($r.SetCookie -join ';') -match 'Path=/')) "HTTP $($r.Status) -> $($r.Location)"
    $r = Send 'GET' '/pilot/off'
    $pilot = @($jar.GetCookies($gwUri)) | Where-Object { $_.Name -eq 'cims_pilot' }
    Check 'a7' 'GET /pilot/off clears cims_pilot' ($r.Status -eq 302 -and -not $pilot) "HTTP $($r.Status)"

    # ---------- b. assets ----------
    Write-Host '== b. SPA assets'
    Set-PilotCookie $true
    $index = Send 'GET' '/Data/ConfirmArrival'
    $asset = [regex]::Match($index.Body, '/assets/[^"''\s>]+\.js').Value
    $r = Send 'GET' $asset
    Check 'b1' "GET $asset -> 200 JavaScript, one-year immutable cache" ($r.Status -eq 200 -and $r.ContentType -match 'javascript' -and $r.CacheControl -match 'max-age=31536000' -and $r.CacheControl -match 'immutable' -and $r.Expires -and $r.ServedBy -eq 'spa') "Cache-Control '$($r.CacheControl)', Expires '$($r.Expires)', $($r.Length) bytes"
    $css = [regex]::Match($index.Body, '/assets/[^"''\s>]+\.css').Value
    if ($css) { $r = Send 'GET' $css; Check 'b2' "GET $css -> 200 text/css" ($r.Status -eq 200 -and $r.ContentType -match 'text/css') "HTTP $($r.Status)" }
    $r = Send 'GET' '/assets/does-not-exist-0000.js'
    Check 'b3' 'GET a missing /assets/ file -> 404, not index.html' ($r.Status -eq 404 -and $r.Body -notmatch '<div id="root">') "HTTP $($r.Status)"
    Set-PilotCookie $false

    # ---------- c. API auth through the gateway ----------
    Write-Host '== c. API through the gateway'
    $r = Send 'GET' '/api/v1/reference/field-captions'
    Check 'c1' 'GET /api/v1/reference/field-captions without a token -> 401' ($r.Status -eq 401 -and $r.ServedBy -eq 'api') "HTTP $($r.Status), served by $($r.ServedBy)"
    $jwt = New-DevGwToken $UserName '30m'; $tokenIds += $jwt.Id; $token = $jwt.Token
    $r = Send 'GET' '/api/v1/reference/field-captions' $token
    Check 'c2' 'GET /api/v1/reference/field-captions with a DevJwt token -> 200' ($r.Status -eq 200 -and $r.ContentType -match 'json') "HTTP $($r.Status), $($r.Length) bytes"
    $r = Send 'GET' '/api/v1/arrivals/confirm/dcs' $token
    Check 'c3' 'GET /api/v1/arrivals/confirm/dcs (the pilot page''s lookup) -> 200' ($r.Status -eq 200) "HTTP $($r.Status), $($r.Length) bytes"

    # ---------- d. cookie bridge through the gateway ----------
    Write-Host '== d. One login: legacy cookie from the API, accepted by the legacy app'
    $r = Send 'POST' '/api/v1/legacy-session' $token
    $sc = ($r.SetCookie | Where-Object { $_ -like "$cookieName=*" }) -join ';'
    $cookie = Get-LegacyCookie
    Check 'd1' 'POST /api/v1/legacy-session -> 204 and the legacy cookie is in the jar for localhost:8080' ($r.Status -eq 204 -and $cookie -and $cookie.Domain -eq 'localhost') "HTTP $($r.Status), cookie domain '$($cookie.Domain)' path '$($cookie.Path)'"
    Check 'd2' 'cookie attributes: no Domain, Path=/, HttpOnly, SameSite=Lax, not Secure' ($sc -match '(?i)path=/' -and $sc -notmatch '(?i)domain=' -and $sc -match '(?i)httponly' -and $sc -match '(?i)samesite=lax' -and $sc -notmatch '(?i);\s*secure') ($sc -replace '=[^;]{20,}', '=<redacted>')
    $r = Send 'GET' '/Home/Index'
    $uid = Get-PageUid $r.Body
    Check 'd3' 'GET /Home/Index with that cookie -> 200 from legacy, no login redirect' ($r.Status -eq 200 -and $r.ServedBy -eq 'legacy' -and $uid) "HTTP $($r.Status), served by $($r.ServedBy), #txtMyUid <redacted:$($uid.Length) chars>"
    $r = Send 'GET' '/Data/ConfirmArrival'
    Check 'd4' 'GET /Data/ConfirmArrival (no pilot cookie) with the cookie -> legacy page 200' ($r.Status -eq 200 -and $r.ServedBy -eq 'legacy' -and $r.Body -match 'ConfirmArrival') "HTTP $($r.Status), served by $($r.ServedBy)"

    # ---------- e. legacy Web API through the gateway ----------
    Write-Host '== e. Legacy Web API through the gateway'
    $r = Send 'GET' ('/api/DataApi/getCloudMenuItems?uid=' + [Uri]::EscapeDataString($uid))
    $rows = $null; try { $rows = @(($r.Body | ConvertFrom-Json).dtMain).Count } catch { }
    Check 'e1' 'GET /api/DataApi/getCloudMenuItems?uid=<page uid> -> legacy, CloudMenu rows' ($r.Status -eq 200 -and $r.ServedBy -eq 'legacy' -and $rows -gt 0) "HTTP $($r.Status), $rows rows"
    $r = Send 'GET' ('/api/DataApi/getQCPendingCount?strRtnPara=devgw&uid=' + [Uri]::EscapeDataString($uid))
    $count = $null; try { $count = [int] (($r.Body | ConvertFrom-Json).dtMain[0].QCCount) } catch { }
    Check 'e2' 'GET /api/DataApi/getQCPendingCount (reads the cookie''s claims) -> a count' ($r.Status -eq 200 -and $null -ne $count) "HTTP $($r.Status), count $count"

    # ---------- f. sign-out ----------
    Write-Host '== f. Sign-out'
    $r = Send 'DELETE' '/api/v1/legacy-session'
    Check 'f1' 'DELETE /api/v1/legacy-session -> 204, cookie expired and gone from the jar' ($r.Status -eq 204 -and (($r.SetCookie -join ';') -match 'expires=Thu, 01 Jan 1970') -and -not (Get-LegacyCookie)) "HTTP $($r.Status)"
    $r = Send 'GET' '/Home/Index'
    Check 'f2' 'GET /Home/Index afterwards -> login redirect on 8080 again' (Test-LoginRedirect $r) "HTTP $($r.Status) -> $($r.Location)"

    # ---------- g. legacy pass-through ----------
    Write-Host '== g. Legacy pass-through'
    $r = Send 'GET' '/Sounds/bell_ring.mp3'
    Check 'g1' 'GET /Sounds/bell_ring.mp3 -> legacy, audio' ($r.Status -eq 200 -and $r.ServedBy -eq 'legacy' -and $r.ContentType -match 'audio' -and $r.Length -gt 1000) "HTTP $($r.Status), $($r.ContentType), $($r.Length) bytes"
    $r = Send 'GET' '/Content/Site.css'
    Check 'g2' 'GET /Content/Site.css -> legacy static file' ($r.Status -eq 200 -and $r.ServedBy -eq 'legacy' -and $r.ContentType -match 'text/css') "HTTP $($r.Status)"
    $r = Send 'GET' '/favicon.ico'
    Check 'g3' 'GET /favicon.ico -> legacy' ($r.Status -eq 200 -and $r.ServedBy -eq 'legacy') "HTTP $($r.Status)"
    # Crystal's image handler (Web.config handlers): without an image id it answers 404 itself; the gateway must
    # return exactly what IIS Express returns directly.
    $r = Send 'GET' '/CrystalImageHandler.aspx'
    $direct = Test-Url "http://localhost:$($DevGw.LegacyPort)/CrystalImageHandler.aspx"
    Check 'g4' 'GET /CrystalImageHandler.aspx -> legacy, same answer as IIS Express directly' ($r.ServedBy -eq 'legacy' -and $r.Status -eq $direct) "HTTP $($r.Status) via gateway, $direct direct"

    # ---------- h. browser ----------
    if ($Browser) {
        Write-Host "== h. Browser proof (Playwright, channel $BrowserChannel)"
        $web = Join-Path $DevGw.FeRepo 'apps\web'
        $shots = Join-Path $PSScriptRoot 'screenshots'
        $log = Join-Path $DevGw.LogDir 'playwright.log'
        # The token reaches the child through its environment only.
        $env:E2E_GATEWAY_URL = $gw; $env:E2E_DEV_TOKEN = $token; $env:E2E_SCREENSHOT_DIR = $shots; $env:E2E_BROWSER_CHANNEL = $BrowserChannel
        try {
            $p = Start-Process (Get-Command npx.cmd).Source -ArgumentList @('playwright', 'test', 'e2e/dev-gateway.spec.ts', '--reporter=list') `
                -WorkingDirectory $web -NoNewWindow -Wait -PassThru -RedirectStandardOutput $log -RedirectStandardError "$log.err"
        }
        finally { Remove-Item Env:E2E_GATEWAY_URL, Env:E2E_DEV_TOKEN, Env:E2E_SCREENSHOT_DIR, Env:E2E_BROWSER_CHANNEL -ErrorAction SilentlyContinue }
        $summary = (Get-Content -LiteralPath $log | Where-Object { $_ -match '\b(passed|failed|skipped)\b' } | Select-Object -Last 1)
        Check 'h1' 'Playwright apps/web/e2e/dev-gateway.spec.ts through the gateway (a-g in a real browser)' ($p.ExitCode -eq 0 -and $summary -match 'passed' -and $summary -notmatch 'skipped|failed') "$($summary.Trim()); log $log; screenshots $shots"
    }
}
catch {
    Check 'x' 'aborted' $false ($_.Exception.Message)
}
finally {
    Remove-DevGwToken $tokenIds
    $http.Dispose()
}

$failed = @($results | Where-Object { -not $_.Passed }).Count
Write-Host ("== Result: {0} checks, {1} failed" -f $results.Count, $failed) -ForegroundColor $(if ($failed) { 'Red' } else { 'Green' })
if ($failed -gt 0) { exit 1 }
