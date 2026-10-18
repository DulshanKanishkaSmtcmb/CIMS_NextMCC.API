# Shared settings and helpers for start-dev-gateway.ps1, stop-dev-gateway.ps1, verify-dev-gateway.ps1 and
# new-dev-token.ps1. Dot-sourced; defines no side effects beyond variables and functions.
# Ports are fixed because nginx.dev.conf names them.

$DevGw = [ordered]@{
    RepoRoot        = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
    ConfPath        = (Join-Path $PSScriptRoot 'nginx.dev.conf')
    ScratchRoot     = 'C:\devgw'
    GatewayPort     = 8080
    LegacyPort      = 55243
    ApiPort         = 5212
    SpaPort         = 5031
    KeyRingPath     = 'C:\ProgramData\CIMS\keys'
    IisExpress      = 'C:\Program Files\IIS Express\iisexpress.exe'
    MSBuild         = 'C:\Program Files (x86)\MSBuild\14.0\Bin\MSBuild.exe'
    # Claude's workspace copy of the legacy app. The user's own copy (DotNet2015\NextMCCNew) must never be built or run.
    LegacyWorkspace = 'C:\Non Windows Files\Work\New Projects\Legacy\CIMS_NextMCC-work'
    ForbiddenLegacy = 'C:\Non Windows Files\Work\DotNet2015\NextMCCNew'
}
$DevGw.FeRepo       = [IO.Path]::GetFullPath((Join-Path $DevGw.RepoRoot '..\..\Frontends\CIMS_NextMCC.FE'))
$DevGw.ApiProject   = Join-Path $DevGw.RepoRoot 'src\CIMSNextMCC.API'
$DevGw.NginxPrefix  = Join-Path $DevGw.ScratchRoot 'nginx'
$DevGw.NginxPrefixArg = ($DevGw.NginxPrefix -replace '\\', '/') + '/'
$DevGw.LegacySite   = Join-Path $DevGw.ScratchRoot 'legacy\CIMS_NextMCC'
$DevGw.ApiArtifacts = Join-Path $DevGw.ScratchRoot 'api'
$DevGw.ApiDll       = Join-Path $DevGw.ApiArtifacts 'bin\CIMSNextMCC.API\debug\CIMSNextMCC.API.dll'
$DevGw.LogDir       = Join-Path $DevGw.ScratchRoot 'logs'
$DevGw.StateFile    = Join-Path $DevGw.ScratchRoot 'state.json'
$DevGw.Gateway      = "http://localhost:$($DevGw.GatewayPort)"

function Find-Nginx {
    # 1. deploy/dev-gateway/tools/nginx-*/nginx.exe (manual zip, git-ignored)  2. winget package nginxinc.nginx  3. PATH
    $local = Get-ChildItem (Join-Path $PSScriptRoot 'tools') -Filter nginx.exe -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($local) { return $local.FullName }
    $winget = Get-ChildItem (Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages') -Directory -Filter 'nginxinc.nginx*' -ErrorAction SilentlyContinue |
        ForEach-Object { Get-ChildItem $_.FullName -Filter nginx.exe -Recurse -ErrorAction SilentlyContinue } |
        Sort-Object { $_.VersionInfo.FileVersion }, FullName -Descending | Select-Object -First 1
    if ($winget) { return $winget.FullName }
    $cmd = Get-Command nginx -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    throw 'nginx not found. Install it: winget install --id nginxinc.nginx --exact --scope user'
}

# nginx for Windows splits its command line on spaces and ignores quotes, so the configuration is copied into the
# prefix (no spaces) and both are passed as plain, forward-slash paths.
function Get-NginxBaseArgs { @('-p', $DevGw.NginxPrefixArg, '-c', 'conf/nginx.conf') }

function Copy-NginxConf {
    $target = Join-Path $DevGw.NginxPrefix 'conf\nginx.conf'
    New-Item -ItemType Directory -Force -Path (Split-Path $target) | Out-Null
    Copy-Item -LiteralPath $DevGw.ConfPath -Destination $target -Force
}

function Invoke-Nginx([string[]] $arguments) {
    # nginx writes -t / -s results to stderr; capture both without PowerShell turning them into errors.
    $exe = Find-Nginx
    $psi = New-Object System.Diagnostics.ProcessStartInfo $exe
    $psi.Arguments = ((@(Get-NginxBaseArgs) + $arguments) -join ' ')
    $psi.WorkingDirectory = $DevGw.NginxPrefix
    $psi.UseShellExecute = $false; $psi.RedirectStandardError = $true; $psi.RedirectStandardOutput = $true; $psi.CreateNoWindow = $true
    $p = [System.Diagnostics.Process]::Start($psi)
    $out = $p.StandardOutput.ReadToEnd() + $p.StandardError.ReadToEnd()
    $p.WaitForExit()
    [pscustomobject]@{ ExitCode = $p.ExitCode; Output = $out.Trim() }
}

function Get-ListenerPid([int] $port) {
    Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty OwningProcess -Unique | Select-Object -First 1
}

function Get-DevGwNginxProcesses {
    # Only the nginx processes started with our prefix (another nginx on this machine is left alone).
    Get-CimInstance Win32_Process -Filter "Name = 'nginx.exe'" -ErrorAction SilentlyContinue |
        Where-Object { $_.CommandLine -and $_.CommandLine -like "*$($DevGw.NginxPrefixArg)*" }
}

function Get-DevGwIisProcess {
    # IIS Express listens through HTTP.sys, so the port's owner is System (pid 4); find it by its /path instead.
    Get-CimInstance Win32_Process -Filter "Name = 'iisexpress.exe'" -ErrorAction SilentlyContinue |
        Where-Object { $_.CommandLine -and $_.CommandLine -like "*$($DevGw.LegacySite)*" } | Select-Object -First 1
}

function Get-ComponentPid([int] $port) {
    if ($port -eq $DevGw.LegacyPort) { $iis = Get-DevGwIisProcess; if ($iis) { return $iis.ProcessId }; return $null }
    return Get-ListenerPid $port
}

function Read-DevGwState {
    if (Test-Path -LiteralPath $DevGw.StateFile) { return Get-Content -LiteralPath $DevGw.StateFile -Raw | ConvertFrom-Json }
    return $null
}

function Test-Url([string] $url, [int] $timeoutSec = 5) {
    # Status code without following redirects; 0 when nothing answers.
    try {
        $request = [System.Net.HttpWebRequest]::Create($url)
        $request.AllowAutoRedirect = $false; $request.Timeout = $timeoutSec * 1000
        $response = $request.GetResponse(); $code = [int] $response.StatusCode; $response.Close(); return $code
    }
    catch [System.Net.WebException] {
        if ($_.Exception.Response) { $code = [int] $_.Exception.Response.StatusCode; $_.Exception.Response.Close(); return $code }
        return 0
    }
}

function Get-DevGwStatus {
    $rows = @(
        @{ Name = 'legacy (IIS Express)'; Url = "http://localhost:$($DevGw.LegacyPort)/Account/Login"; Port = $DevGw.LegacyPort },
        @{ Name = 'api (Kestrel)';        Url = "http://localhost:$($DevGw.ApiPort)/health/live";      Port = $DevGw.ApiPort },
        @{ Name = 'spa (nginx :5031)';    Url = "http://127.0.0.1:$($DevGw.SpaPort)/index.html";      Port = $DevGw.SpaPort },
        @{ Name = 'gateway (nginx)';      Url = "$($DevGw.Gateway)/nextmcc-api/health";              Port = $DevGw.GatewayPort }
    )
    foreach ($r in $rows) {
        $code = Test-Url $r.Url
        [pscustomobject]@{ Component = $r.Name; Url = $r.Url; Http = $code; Up = ($code -ge 200 -and $code -lt 400); Pid = (Get-ComponentPid $r.Port) }
    }
}

function Wait-Url([string] $url, [int] $seconds) {
    $deadline = (Get-Date).AddSeconds($seconds)
    while ((Get-Date) -lt $deadline) {
        $code = Test-Url $url 10
        if ($code -ge 200 -and $code -lt 500) { return $code }
        Start-Sleep -Seconds 1
    }
    throw "Timed out after $seconds s waiting for $url"
}

# ---- dev tokens (dotnet user-jwts, DevJwt scheme) -------------------------------------------------------------------
# `dotnet user-jwts create/remove` rewrites appsettings.Development.json (and removing the last token drops the DevJwt
# section); the file is put back byte for byte around every call. The running gateway API reads its own copy under
# C:\devgw\api, so it is not affected either way.
function New-DevGwToken([string] $user, [string] $validFor = '2h') {
    $devSettings = Join-Path $DevGw.ApiProject 'appsettings.Development.json'
    $before = [IO.File]::ReadAllBytes($devSettings)
    try {
        $json = & dotnet user-jwts create --project $DevGw.ApiProject --scheme DevJwt --name $user --audience cims-nextmcc-api `
            --scope cims.nextmcc --claim "username=$user" --claim tenant=NextMCC --valid-for $validFor -o json | Out-String
    }
    finally { [IO.File]::WriteAllBytes($devSettings, $before) }
    $jwt = $json | ConvertFrom-Json
    if (-not $jwt.Token) { throw "dotnet user-jwts create returned no token for $user." }
    return $jwt
}

function Remove-DevGwToken([string[]] $ids) {
    if (-not $ids) { return }
    $devSettings = Join-Path $DevGw.ApiProject 'appsettings.Development.json'
    $before = [IO.File]::ReadAllBytes($devSettings)
    try { foreach ($id in $ids) { & dotnet user-jwts remove $id --project $DevGw.ApiProject | Out-Null } }
    finally { [IO.File]::WriteAllBytes($devSettings, $before) }
}
