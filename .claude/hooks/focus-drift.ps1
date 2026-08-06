# Focus-drift-detectie: vergelijkt Context/focus.md met de laatste Daily-log.
# Als de activiteit afwijkt van de focus, output dan een waarschuwingszin.

$vault = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$focusFile = Join-Path $vault "Context\focus.md"
$dailyDir = Join-Path $vault "Daily"

if (-not (Test-Path $focusFile)) { exit 0 }

$focusContent = Get-Content $focusFile -Raw -Encoding UTF8

# Haal "Deze week:" sectie op uit focus.md
$focusMatch = [regex]::Match($focusContent, "Deze week:\s*\n([\s\S]*?)(\n\nDeze week uitdrukkelijk NIET|$)")
if (-not $focusMatch.Success) { exit 0 }
$focusItems = $focusMatch.Groups[1].Value.Trim()

# Zoek het meest recente daily-bestand (niet vandaag, want dat is leeg)
$dailyFiles = Get-ChildItem $dailyDir -Filter "*.md" | Where-Object { $_.Name -ne "CLAUDE.md" } | Sort-Object Name -Descending
if ($dailyFiles.Count -lt 2) { exit 0 }

$lastDaily = Get-Content $dailyFiles[1].FullName -Raw -Encoding UTF8

# Haal Log-sectie op
$logMatch = [regex]::Match($lastDaily, "## Log\s*\n([\s\S]*?)(\n## |$)")
if (-not $logMatch.Success) { exit 0 }
$logContent = $logMatch.Groups[1].Value.Trim()

if (-not $logContent -or $logContent.Length -lt 10) { exit 0 }

# Simpele check: als de log geen van de focus-woorden bevat, waarschuw
$focusWords = ($focusItems -split "\n" | ForEach-Object { $_ -replace "^\d+\.\s*", "" -replace "\[\[|\]\]", "" }).Where({ $_.Length -gt 3 })
$overlap = $focusWords | Where-Object { $logContent -match [regex]::Escape($_) }

if ($overlap.Count -eq 0) {
    $focusSummary = ($focusWords | Select-Object -First 2) -join " en "
    Write-Output "`n[FOCUS-DRIFT] Focus zegt $focusSummary, je activiteit van gisteren zegt iets anders. Wat geldt?"
}
