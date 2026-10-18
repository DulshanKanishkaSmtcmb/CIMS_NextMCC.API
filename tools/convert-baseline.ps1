<#
.SYNOPSIS
  Converts an SSMS "Generate Scripts" dump (UTF-16 LE) of the legacy CFSInventory database into the DbUp baseline
  src/CIMSNextMCC.Database/Scripts/0001_Baseline_CFSInventory.sql (UTF-8, no BOM, LF line endings).

.DESCRIPTION
  Removes only what DbUp must not run (it already runs inside the target database):
    * the CREATE DATABASE / ALTER DATABASE / full-text block before the first object,
    * every USE [...] statement and the trailing "USE [master] / ALTER DATABASE ... READ_WRITE" block,
    * the scratch backup table(s) given in -ExcludeTable (its comment, SET preamble, CREATE TABLE and GO).
  Everything else is copied unchanged. GO separators are kept. The script fails loudly if an excluded table is
  still mentioned anywhere afterwards (a default, index or extended property that belongs only to it).

.EXAMPLE
  ./tools/convert-baseline.ps1 -Source "C:\Users\me\Downloads\MCC DB Script.sql"
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)] [string] $Source,
    [string] $Output,
    [string[]] $ExcludeTable = @('CargoReceived_Bkp_20261015')
)

$ErrorActionPreference = 'Stop'
if (-not $Output) {
    $Output = Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) '..\src\CIMSNextMCC.Database\Scripts\0001_Baseline_CFSInventory.sql'
}

$text = [System.IO.File]::ReadAllText((Resolve-Path $Source), [System.Text.Encoding]::Unicode)   # honours the UTF-16 BOM
$lines = [System.Collections.Generic.List[string]]::new()
$lines.AddRange([string[]]($text -split "\r?\n"))
if ($lines.Count -gt 0 -and $lines[$lines.Count - 1] -eq '') { $lines.RemoveAt($lines.Count - 1) }

$scriptDate = ($lines | Where-Object { $_ -match 'Script Date:\s*(.+?)\s*\*+/' } | Select-Object -First 1) -replace '.*Script Date:\s*(.+?)\s*\*+/.*', '$1'
$dbName = ($lines | Where-Object { $_ -match '^CREATE DATABASE \[(.+)\]' } | Select-Object -First 1) -replace '^CREATE DATABASE \[(.+)\].*', '$1'
if (-not $scriptDate -or -not $dbName) { throw 'Could not find the CREATE DATABASE line or a Script Date comment; is this an SSMS script dump?' }

# 1. Header: everything up to and including "USE [<database>]" + its GO.
$useIdx = -1
for ($i = 0; $i -lt $lines.Count; $i++) { if ($lines[$i] -match '^USE \[(?!master\])') { $useIdx = $i; break } }
if ($useIdx -lt 0 -or $lines[$useIdx + 1] -ne 'GO') { throw 'Could not find "USE [<database>]" followed by GO.' }
$body = [System.Collections.Generic.List[string]]::new($lines.GetRange($useIdx + 2, $lines.Count - $useIdx - 2))

# 2. Trailer: "USE [master]" ... end of file (must contain nothing but the database-level ALTER).
$tail = $body.FindLastIndex({ param($l) $l -eq 'USE [master]' })
if ($tail -lt 0) { throw 'Expected a trailing "USE [master]" block.' }
$tailText = ($body.GetRange($tail, $body.Count - $tail) | Where-Object { $_ -and $_ -ne 'GO' -and $_ -ne 'USE [master]' }) -join "`n"
if ($tailText -notmatch '^ALTER DATABASE \[.+\] SET\s+READ_WRITE\s*$') { throw "Unexpected content in the trailing block: $tailText" }
$body.RemoveRange($tail, $body.Count - $tail)

# 3. Excluded tables.
foreach ($table in $ExcludeTable) {
    $prefix = "/****** Object:  Table [dbo].[$table]"
    $start = $body.FindIndex({ param($l) $l.StartsWith($prefix, [StringComparison]::Ordinal) })
    if ($start -lt 0) { throw "Table $table not found in the source." }
    $end = $start
    while ($body[$end] -ne 'GO' -or $body[$end - 1] -notmatch '^\) ON \[PRIMARY\]') { $end++ }   # GO after the CREATE TABLE's closing line
    $body.RemoveRange($start, $end - $start + 1)
}

# 4. Safety checks.
$joined = $body -join "`n"
foreach ($table in $ExcludeTable) { if ($joined -match [regex]::Escape($table)) { throw "$table is still referenced after removal; handle the remaining statements by hand." } }
if ($joined -match '(?m)^USE \[' -or $joined -match '(?m)^CREATE DATABASE') { throw 'USE / CREATE DATABASE statements remain.' }

$header = @(
    '/*',
    "    CIMSNextMCC baseline: schema of the legacy CFSInventory database (tables, indexes, constraints, stored procedures).",
    "    Source: SSMS Generate Scripts dump of [$dbName], Script Date $scriptDate.",
    "    Produced by tools/convert-baseline.ps1 (database-level statements, USE and excluded backup tables removed).",
    "    Scratch backup table(s) excluded: $($ExcludeTable.Count) (see -ExcludeTable in the converter).",
    '    DO NOT EDIT: it is recorded as applied on existing databases (baseline-mark). Add 0002_... scripts instead.',
    '*/'
)
$out = ($header + $body) -join "`n"
[System.IO.File]::WriteAllText($Output, $out + "`n", [System.Text.UTF8Encoding]::new($false))
"Wrote $([System.IO.Path]::GetFullPath($Output)) ($($body.Count) body lines; script date $scriptDate; source database $dbName)"
