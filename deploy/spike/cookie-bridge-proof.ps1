<#
.SYNOPSIS
  Cookie-bridge spike proof (docs/09 section 4.3; write-up in the legacy repo, docs/11-cookie-bridge-spike.md).

.DESCRIPTION
  Starts the new API (dotnet run, http://localhost:5212) and the legacy app (IIS Express, http://localhost:55143)
  over one shared Data Protection key ring, then proves:
    0. the legacy app boots with Katana 4.2.2 + Microsoft.Owin.Security.Interop, still protects its pages and its
       login form still runs (a deliberately wrong password is rejected, no cookie issued);
    1. POST /api/v1/legacy-session with a dev JWT returns 204 + the legacy cookie (and 401 / 403 when it must);
    2. the legacy app accepts that cookie: [Authorize] pages answer 200, the Navbar shows the PwInfo UserId decoded
       from claim 1, /Data/ContainersAllocation shows the UserCategory decoded from claim 2, and the legacy Web API
       getQCPendingCount (reads ElementAt(1) and ElementAt(2)) returns the same count as the database;
    3. DELETE /api/v1/legacy-session expires the cookie and the legacy pages redirect to the login page again;
    4. a ticket minted with the legacy app's own bin assemblies on .NET Framework (exactly like SignInUser, no
       legacy route involved) is read by the API: the legacy-to-API direction across runtimes.
  One cookie jar is shared by both ports, as a browser shares cookies across ports of one host name.

  Read-only against the database (PwInfo and one count query). Cookie values, tokens and UserIds are never
  printed. Requires: the API's user-secrets (Tenants:0:ConnectionStrings:Main) and `dotnet user-jwts` DevJwt
  scheme configured as in docs/11, and a built copy of the legacy site (see -LegacySitePath).

.EXAMPLE
  powershell -NoProfile -ExecutionPolicy Bypass -File deploy\spike\cookie-bridge-proof.ps1 -UserName Dulshan -SecondUserName Next.VAS1
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)] [string] $UserName,
    [string] $SecondUserName,
    # A built copy of the legacy web project (MSBuild Release into the copy's own bin), NOT the working copy.
    [string] $LegacySitePath = 'C:\cbx\CIMS_NextMCC',
    [int] $LegacyPort = 55143,
    [int] $ApiPort = 5212,
    [string] $KeyRingPath = 'C:\ProgramData\CIMS\keys',
    [string] $IisExpress = 'C:\Program Files\IIS Express\iisexpress.exe',
    # Redacted transcript; defaults to the run's log folder under %TEMP%.
    [string] $TranscriptPath,
    [switch] $KeepRunning
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$apiProject = Join-Path $repoRoot 'src\CIMSNextMCC.API'
$api = "http://localhost:$ApiPort"
$legacy = "http://localhost:$LegacyPort"
$cookieName = '.AspNet.ApplicationCookie'
$results = New-Object System.Collections.Generic.List[object]
$logDir = Join-Path ([IO.Path]::GetTempPath()) ("cookie-bridge-proof-" + [Guid]::NewGuid().ToString('N').Substring(0, 8))
New-Item -ItemType Directory $logDir | Out-Null
if (-not $TranscriptPath) { $TranscriptPath = Join-Path $logDir 'transcript.txt' }
Set-Content -LiteralPath $TranscriptPath -Value ("# Cookie-bridge proof, {0:u}, user {1}" -f (Get-Date).ToUniversalTime(), $UserName) -Encoding UTF8

function Say([string] $text) { Write-Host $text; Add-Content -LiteralPath $TranscriptPath -Value $text -Encoding UTF8 }

function Check([string] $name, [bool] $ok, [string] $detail = '') {
    $results.Add([pscustomobject]@{ Step = $name; Passed = $ok; Detail = $detail })
    $mark = if ($ok) { 'PASS' } else { 'FAIL' }
    Say ("  [{0}] {1}{2}" -f $mark, $name, $(if ($detail) { " -- $detail" } else { '' }))
}

function Redact([string] $text) {
    if ($null -eq $text) { return $text }
    $text = [regex]::Replace($text, '(\.AspNet\.ApplicationCookie=)([^;\s]+)', { param($m) $m.Groups[1].Value + "<redacted:$($m.Groups[2].Value.Length) chars>" })
    $text = [regex]::Replace($text, '(Bearer\s+)[A-Za-z0-9\-_\.]+', '$1<redacted>')
    return $text
}

# ---------- database (read-only), connection string from the legacy site's own ConnectionStrings.config ----------
function Invoke-Sql([string] $sql, [hashtable] $parameters = @{}) {
    [xml] $cfg = Get-Content -LiteralPath (Join-Path $LegacySitePath 'ConnectionStrings.config') -Raw
    $cs = ($cfg.connectionStrings.add | Where-Object { $_.name -eq 'myDBConnection' }).connectionString
    $con = New-Object System.Data.SqlClient.SqlConnection $cs
    try {
        $con.Open()
        $cmd = $con.CreateCommand(); $cmd.CommandText = $sql
        foreach ($k in $parameters.Keys) { [void] $cmd.Parameters.AddWithValue($k, $parameters[$k]) }
        $table = New-Object System.Data.DataTable
        $table.Load($cmd.ExecuteReader())
        return , $table
    }
    finally { $con.Dispose() }
}

# ---------- HTTP: one cookie jar for both ports, no automatic redirects ----------
Add-Type -AssemblyName System.Net.Http
$jar = New-Object System.Net.CookieContainer
$handler = New-Object System.Net.Http.HttpClientHandler
$handler.CookieContainer = $jar; $handler.UseCookies = $true; $handler.AllowAutoRedirect = $false
$http = New-Object System.Net.Http.HttpClient $handler
$http.Timeout = [TimeSpan]::FromMinutes(5)

function Send([string] $method, [string] $url, [string] $bearer, [System.Net.Http.HttpContent] $content) {
    $request = New-Object System.Net.Http.HttpRequestMessage -ArgumentList ([System.Net.Http.HttpMethod]::new($method)), $url
    if ($bearer) { $request.Headers.Authorization = New-Object System.Net.Http.Headers.AuthenticationHeaderValue 'Bearer', $bearer }
    if ($content) { $request.Content = $content }
    $response = $http.SendAsync($request).GetAwaiter().GetResult()
    $body = $response.Content.ReadAsStringAsync().GetAwaiter().GetResult()
    $setCookie = @()
    $values = $null
    if ($response.Headers.TryGetValues('Set-Cookie', [ref] $values)) { $setCookie = @($values) }
    $location = if ($response.Headers.Location) { $response.Headers.Location.ToString() } else { '' }
    [pscustomobject]@{ Status = [int] $response.StatusCode; Body = $body; SetCookie = $setCookie; Location = $location }
}

function Get-PageUid([string] $html) {
    # Navbar.cshtml: <input ... id="txtMyUid" value=@ViewBag.myId />  (unquoted attribute, HTML-encoded by Razor)
    $m = [regex]::Match($html, 'id="txtMyUid"\s+value=(?:"([^"]*)"|''([^'']*)''|([^\s>]*))')
    $raw = ($m.Groups[1].Value + $m.Groups[2].Value + $m.Groups[3].Value)
    return [System.Net.WebUtility]::HtmlDecode($raw)
}

# Shape of a value without its content (letters and digits masked), for failure messages.
function Shape([string] $text) { if ($null -eq $text) { return '<null>' }; return ($text -replace '[A-Za-z0-9]', 'x') }

function Get-JarCookie { $jar.GetCookies([Uri] $legacy) | Where-Object { $_.Name -eq $cookieName } | Select-Object -First 1 }

function Wait-Http([string] $url, [int] $seconds) {
    $deadline = (Get-Date).AddSeconds($seconds)
    while ((Get-Date) -lt $deadline) {
        try { $r = Send 'GET' $url; if ($r.Status -lt 500) { return $r } } catch { }
        Start-Sleep -Seconds 1
    }
    throw "Timed out waiting for $url"
}

# ---------- dev tokens via dotnet user-jwts (removed again at the end) ----------
$jwtIds = New-Object System.Collections.Generic.List[string]
function New-DevToken([string] $user) {
    # `dotnet user-jwts create` rewrites appsettings.Development.json every time (line endings); put it back.
    $devSettings = Join-Path $apiProject 'appsettings.Development.json'
    $before = [IO.File]::ReadAllBytes($devSettings)
    $json = & dotnet user-jwts create --project $apiProject --scheme DevJwt --name $user --audience cims-nextmcc-api `
        --scope cims.nextmcc --claim "username=$user" --claim tenant=NextMCC --valid-for 30m -o json | Out-String
    [IO.File]::WriteAllBytes($devSettings, $before)
    $jwt = $json | ConvertFrom-Json
    if (-not $jwt.Token) { throw "dotnet user-jwts create returned no token for $user." }
    $jwtIds.Add($jwt.Id)
    return $jwt.Token
}

function Stop-Port([int] $port) {
    Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty OwningProcess -Unique |
        ForEach-Object { Stop-Process -Id $_ -Force -ErrorAction SilentlyContinue }
}

$apiProcess = $null; $iisProcess = $null
try {
    # ---------- start both apps over the same key ring ----------
    Say "== Setup"
    foreach ($p in $ApiPort, $LegacyPort) {
        if (Get-NetTCPConnection -LocalPort $p -State Listen -ErrorAction SilentlyContinue) { throw "Port $p is already in use." }
    }
    [xml] $webConfig = Get-Content -LiteralPath (Join-Path $LegacySitePath 'Web.config') -Raw
    $legacyKeyRing = ($webConfig.configuration.appSettings.add | Where-Object { $_.key -eq 'SharedKeyRingPath' }).value
    Say "  key ring: API=$KeyRingPath legacy Web.config=$legacyKeyRing"
    if ($legacyKeyRing -ne $KeyRingPath) { throw 'The legacy Web.config SharedKeyRingPath differs from -KeyRingPath.' }

    $env:LegacyBridge__SharedKeyRingPath = $KeyRingPath
    $apiProcess = Start-Process dotnet -ArgumentList @('run', '--project', "`"$apiProject`"", '--launch-profile', 'http') `
        -PassThru -WindowStyle Hidden -RedirectStandardOutput (Join-Path $logDir 'api.out.log') -RedirectStandardError (Join-Path $logDir 'api.err.log')
    [void] (Wait-Http "$api/health/live" 120)
    Say "  API up at $api (dotnet run, Development)"

    $iisProcess = Start-Process $IisExpress -ArgumentList @("/path:`"$LegacySitePath`"", "/port:$LegacyPort", '/clr:v4.0', '/systray:false') `
        -PassThru -WindowStyle Hidden -RedirectStandardOutput (Join-Path $logDir 'iisexpress.out.log') -RedirectStandardError (Join-Path $logDir 'iisexpress.err.log')
    $loginPage = Wait-Http "$legacy/Account/Login" 300
    Say "  legacy app up at $legacy (IIS Express, $LegacySitePath)"

    $pw = Invoke-Sql 'SELECT UserId, UserCategory FROM dbo.PwInfo WHERE UserName = @u' @{ '@u' = $UserName }
    if ($pw.Rows.Count -ne 1) { throw "Expected exactly one PwInfo row for $UserName." }
    $dbUserId = [string] $pw.Rows[0].UserId; $dbCategory = [string] $pw.Rows[0].UserCategory
    Say ("  PwInfo {0}: UserId <redacted:{1} chars>, UserCategory {2}" -f $UserName, $dbUserId.Length, $dbCategory)

    # ---------- 0. legacy app still enforces auth and its login form still runs ----------
    Say "== 0. Legacy app unchanged"
    Check 'GET /Account/Login renders' ($loginPage.Status -eq 200 -and $loginPage.Body -match '__RequestVerificationToken') "HTTP $($loginPage.Status)"
    $r = Send 'GET' "$legacy/Home/Index"
    Check 'GET /Home/Index without cookie redirects to login' ($r.Status -eq 302 -and $r.Location -match '/Account/Login') "HTTP $($r.Status) -> $($r.Location)"
    $token = [regex]::Match($loginPage.Body, 'name="__RequestVerificationToken" type="hidden" value="([^"]+)"').Groups[1].Value
    $form = New-Object 'System.Collections.Generic.Dictionary[string,string]'
    $form['__RequestVerificationToken'] = $token; $form['UserName'] = $UserName; $form['Password'] = 'wrong-' + [Guid]::NewGuid().ToString('N')
    $r = Send 'POST' "$legacy/Account/Login" $null (New-Object System.Net.Http.FormUrlEncodedContent $form)
    Check 'POST /Account/Login with a wrong password is rejected, no cookie' ($r.Status -eq 200 -and $r.Body -match 'Invalid username or password' -and -not (Get-JarCookie)) "HTTP $($r.Status)"

    # ---------- 1. API issues the legacy cookie ----------
    Say "== 1. API issues the cookie"
    $r = Send 'POST' "$api/api/v1/legacy-session"
    Check 'POST legacy-session without a token' ($r.Status -eq 401) "HTTP $($r.Status)"
    $r = Send 'POST' "$api/api/v1/legacy-session" (New-DevToken ('no-such-user-' + [Guid]::NewGuid().ToString('N').Substring(0, 8)))
    Check 'POST legacy-session for a user not in PwInfo' ($r.Status -eq 403 -and $r.Body -match 'LEGACY_USER_NOT_FOUND') "HTTP $($r.Status) $($r.Body -replace '"traceId":"[^"]*",?', '')"
    $bearer = New-DevToken $UserName
    $r = Send 'POST' "$api/api/v1/legacy-session" $bearer
    Say ("  Set-Cookie: " + (Redact ($r.SetCookie -join ' | ')))
    $cookie = Get-JarCookie
    Check 'POST legacy-session with a dev JWT returns 204 + the legacy cookie' ($r.Status -eq 204 -and $null -ne $cookie) "HTTP $($r.Status)"
    Check 'cookie attributes: path=/, HttpOnly, SameSite=Lax, session cookie' (($r.SetCookie -join ';') -match 'path=/' -and ($r.SetCookie -join ';') -match 'httponly' -and ($r.SetCookie -join ';') -match 'samesite=lax' -and ($r.SetCookie -join ';') -notmatch 'expires=') ''
    $r = Send 'GET' "$api/api/v1/legacy-session/inspect"
    $view = $r.Body | ConvertFrom-Json
    Say ("  inspect: authenticationType={0}, claims={1}" -f $view.authenticationType, (($view.claims | ForEach-Object { "$($_.index):" + ($_.type -replace '^.*/', '') }) -join ', '))
    Say ("  inspect: issuedUtc={0} expiresUtc={1}" -f $view.issuedUtc, $view.expiresUtc)
    Check 'inspect (API reads its own cookie): claims Name, Sid, GroupSid, Surname in order' ((($view.claims | ForEach-Object { $_.type -replace '^.*/', '' }) -join ',') -eq 'name,sid,groupsid,surname') ''
    Check 'inspect: decoded UserId and UserCategory equal PwInfo' ($view.userId -eq $dbUserId -and $view.userCategory -eq $dbCategory -and $view.userName -eq $UserName) "category $($view.userCategory)"
    $lifetime = ([DateTimeOffset] $view.expiresUtc) - ([DateTimeOffset] $view.issuedUtc)
    Check 'ticket lifetime is one day (SignInUser)' ($lifetime.TotalHours -eq 24) "$($lifetime.TotalHours) h"

    # ---------- 2. legacy app accepts the API-issued cookie ----------
    Say "== 2. Legacy app accepts the API-issued cookie"
    $r = Send 'GET' "$legacy/Home/Index"
    $pageUid = Get-PageUid $r.Body
    Check 'GET /Home/Index with the cookie: 200, no redirect' ($r.Status -eq 200 -and -not $r.Location) "HTTP $($r.Status)"
    Check 'Navbar #txtMyUid (ReverseMiddle of claim 1) equals PwInfo.UserId' ($pageUid -eq $dbUserId) "page value <redacted:$($pageUid.Length) chars>$(if ($pageUid -ne $dbUserId) { ' shape ' + (Shape $pageUid) + ' vs ' + (Shape $dbUserId) })"
    $menuCount = ([regex]::Matches($r.Body, '<li[^>]*class="[^"]*dropdown')).Count
    Say "  Navbar rendered from CloudMenuAllocation for that UserId ($menuCount dropdown menus)"
    $r = Send 'GET' "$legacy/Data/ContainersAllocation"
    $pageCat = [regex]::Match($r.Body, 'id="myCat" value="([^"]*)"').Groups[1].Value
    Check 'GET /Data/ContainersAllocation: #myCat (ReConvertAsc of claim 2) equals PwInfo.UserCategory' ($r.Status -eq 200 -and $pageCat -eq $dbCategory) "HTTP $($r.Status), myCat=$pageCat"
    $r = Send 'GET' ("$legacy/api/DataApi/getQCPendingCount?strRtnPara=proof&uid=" + [Uri]::EscapeDataString($pageUid))
    $apiCount = $null; try { $apiCount = [int] (($r.Body | ConvertFrom-Json).dtMain[0].QCCount) } catch { }
    $dbCount = [int] (Invoke-Sql "SELECT COUNT(t1.RcvNo) QCCount FROM CargoReceived t1 WHERE t1.QCResult = '' AND t1.RemoveStatus = '' AND t1.QCType = 'Next' AND t1.UnloadStatus = 'Update'").Rows[0].QCCount
    Check 'GET /api/DataApi/getQCPendingCount (reads ElementAt(1)/(2)) returns the database count' ($r.Status -eq 200 -and $apiCount -eq $dbCount) "HTTP $($r.Status), count $apiCount, database $dbCount (category ${dbCategory}, unfiltered branch)"

    if ($SecondUserName) {
        $pw2 = Invoke-Sql 'SELECT UserId, UserCategory FROM dbo.PwInfo WHERE UserName = @u' @{ '@u' = $SecondUserName }
        $r = Send 'POST' "$api/api/v1/legacy-session" (New-DevToken $SecondUserName)
        $r2 = Send 'GET' "$legacy/Data/ContainersAllocation"
        $cat2 = [regex]::Match($r2.Body, 'id="myCat" value="([^"]*)"').Groups[1].Value
        $uid2 = Get-PageUid $r2.Body
        Check "second user $SecondUserName replaces the cookie; legacy sees its UserId and category" ($r.Status -eq 204 -and $r2.Status -eq 200 -and $cat2 -eq [string] $pw2.Rows[0].UserCategory -and $uid2 -eq [string] $pw2.Rows[0].UserId) "myCat=$cat2"
        $r = Send 'POST' "$api/api/v1/legacy-session" $bearer   # back to the first user
    }

    # ---------- 3. DELETE clears the cookie ----------
    Say "== 3. DELETE clears the cookie"
    $r = Send 'DELETE' "$api/api/v1/legacy-session"
    Say ("  Set-Cookie: " + (Redact ($r.SetCookie -join ' | ')))
    Check 'DELETE legacy-session: 204 + expired cookie, gone from the jar' ($r.Status -eq 204 -and ($r.SetCookie -join ';') -match 'expires=Thu, 01 Jan 1970' -and -not (Get-JarCookie)) "HTTP $($r.Status)"
    $r = Send 'GET' "$legacy/Home/Index"
    Check 'GET /Home/Index after DELETE redirects to login again' ($r.Status -eq 302 -and $r.Location -match '/Account/Login') "HTTP $($r.Status) -> $($r.Location)"

    # ---------- 4. legacy-format ticket from the legacy bin assemblies (.NET Framework) read by the API ----------
    Say "== 4. Ticket minted with the legacy app's own assemblies (.NET Framework) is read by the API"
    $mint = Join-Path $PSScriptRoot 'mint-legacy-ticket.ps1'
    # Values go through the environment, never the command line.
    $env:CB_USERNAME = $UserName; $env:CB_USERID = $dbUserId; $env:CB_CATEGORY = $dbCategory
    $env:CB_LEVEL = [string] (Invoke-Sql 'SELECT UserLevel FROM dbo.PwInfo WHERE UserName = @u' @{ '@u' = $UserName }).Rows[0].UserLevel
    try { $minted = & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $mint -BinPath (Join-Path $LegacySitePath 'bin') -KeyRingPath $KeyRingPath }
    finally { Remove-Item Env:CB_USERNAME, Env:CB_USERID, Env:CB_CATEGORY, Env:CB_LEVEL -ErrorAction SilentlyContinue }
    $minted = [string] ($minted | Select-Object -Last 1)
    Check 'legacy Katana Interop (net48, DataProtection 2.3) produced a ticket' ([bool] $minted -and $minted.Length -gt 100) "<redacted:$($minted.Length) chars>"
    # Into the jar (HttpClientHandler with UseCookies ignores a hand-written Cookie header), as a browser would hold it.
    $jar.Add([Uri] $legacy, (New-Object System.Net.Cookie $cookieName, $minted, '/', 'localhost'))
    $r = Send 'GET' "$api/api/v1/legacy-session/inspect"
    $view = $null; try { $view = $r.Body | ConvertFrom-Json } catch { }
    Check 'API (net10, DataProtection 10) reads it: same claims, order and decoded values' ($r.Status -eq 200 -and (($view.claims | ForEach-Object { $_.type -replace '^.*/', '' }) -join ',') -eq 'name,sid,groupsid,surname' -and $view.userId -eq $dbUserId -and $view.userCategory -eq $dbCategory) "HTTP $($r.Status)"
    $r = Send 'GET' "$legacy/Home/Index"
    Check 'the legacy app reads the same ticket (/Home/Index 200)' ($r.Status -eq 200) "HTTP $($r.Status)"
}
catch {
    Say ("  [FAIL] aborted: " + (Redact $_.Exception.Message))
    $results.Add([pscustomobject]@{ Step = 'aborted'; Passed = $false; Detail = $_.Exception.Message })
}
finally {
    # Removing a scheme's last token also deletes that scheme from appsettings.Development.json; keep the file as it was.
    $devSettings = Join-Path $apiProject 'appsettings.Development.json'
    $settingsBefore = [IO.File]::ReadAllBytes($devSettings)
    foreach ($id in $jwtIds) { & dotnet user-jwts remove $id --project $apiProject | Out-Null }
    [IO.File]::WriteAllBytes($devSettings, $settingsBefore)
    if (-not $KeepRunning) {
        if ($iisProcess) { Stop-Process -Id $iisProcess.Id -Force -ErrorAction SilentlyContinue }
        Stop-Port $LegacyPort
        if ($apiProcess) { Stop-Process -Id $apiProcess.Id -Force -ErrorAction SilentlyContinue }
        Stop-Port $ApiPort
        Say "== Stopped IIS Express and the API (logs: $logDir)"
    }
    $failed = @($results | Where-Object { -not $_.Passed }).Count
    Say ("== Result: {0} checks, {1} failed" -f $results.Count, $failed)
    $http.Dispose()
}
if ($failed -gt 0) { exit 1 }
