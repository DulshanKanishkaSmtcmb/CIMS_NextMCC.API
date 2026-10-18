<#
.SYNOPSIS
  Stops the local gateway started by start-dev-gateway.ps1: nginx (graceful quit), IIS Express on :55243 and the API on
  :5212. Safe to run when nothing is running. Leaves C:\devgw (builds, logs) in place.

.EXAMPLE
  powershell -NoProfile -ExecutionPolicy Bypass -File deploy\dev-gateway\stop-dev-gateway.ps1
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'devgw.common.ps1')

function Stop-Tree([int] $id) {
    # taskkill /T also ends children (the API's dotnet host, IIS Express worker threads are in-process anyway).
    if (Get-Process -Id $id -ErrorAction SilentlyContinue) { & taskkill /PID $id /T /F 2>&1 | Out-Null }
}

$state = Read-DevGwState

# nginx: graceful quit through its pid file, then any leftover process started with our prefix.
if (Get-DevGwNginxProcesses) {
    $quit = Invoke-Nginx @('-s', 'quit')
    $deadline = (Get-Date).AddSeconds(10)
    while ((Get-DevGwNginxProcesses) -and (Get-Date) -lt $deadline) { Start-Sleep -Milliseconds 300 }
    Get-DevGwNginxProcesses | ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }
    Write-Host "nginx stopped$(if ($quit.ExitCode -ne 0) { ' (forced)' })"
}
else { Write-Host 'nginx was not running' }

# IIS Express and the API: the recorded pid, then whatever still listens on the port, but only if it is the expected
# program (never another session's process on a different port, never an unrelated program on ours).
$iis = Get-DevGwIisProcess
$targets = @(
    @{ Name = 'IIS Express'; Port = $DevGw.LegacyPort; Pid = $(if ($iis) { $iis.ProcessId } else { $state.legacyPid }); Process = 'iisexpress' },
    @{ Name = 'API';         Port = $DevGw.ApiPort;    Pid = $state.apiPid;    Process = 'dotnet' }
)
foreach ($t in $targets) {
    $stopped = $false
    if ($t.Pid) {
        $p = Get-Process -Id $t.Pid -ErrorAction SilentlyContinue
        if ($p -and $p.ProcessName -eq $t.Process) { Stop-Tree $t.Pid; $stopped = $true }
    }
    # IIS Express listens through HTTP.sys (owner: System, pid 4): only the process lookup above applies to it.
    $listener = if ($t.Port -eq $DevGw.LegacyPort) { $null } else { Get-ListenerPid $t.Port }
    if ($listener) {
        $p = Get-Process -Id $listener -ErrorAction SilentlyContinue
        if ($p -and $p.ProcessName -in @($t.Process, 'CIMSNextMCC.API')) { Stop-Tree $listener; $stopped = $true }
        else { Write-Warning "$($t.Name): port $($t.Port) is held by $($p.ProcessName) (pid $listener), not stopped." }
    }
    Write-Host "$($t.Name) $(if ($stopped) { 'stopped' } else { 'was not running' })"
}

if (Test-Path -LiteralPath $DevGw.StateFile) { Remove-Item -LiteralPath $DevGw.StateFile }
Start-Sleep -Milliseconds 500
$left = @(Get-DevGwStatus | Where-Object { $_.Pid })
if ($left) { $left | Format-Table Component, Pid, Url -AutoSize | Out-String | Write-Host; Write-Warning 'Something is still listening.'; exit 1 }
Write-Host 'All stopped. Builds and logs stay in C:\devgw.'
