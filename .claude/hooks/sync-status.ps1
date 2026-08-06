# Cross-chat-sync: injecteert Projects/_status.md als het recenter is dan 60 minuten.
# Zo weet een nieuwe chat wat een parallelle chat zojuist heeft veranderd.

$vault = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$statusFile = Join-Path $vault "Projects\_status.md"

if (-not (Test-Path $statusFile)) { exit 0 }

$age = (Get-Date) - (Get-Item $statusFile).LastWriteTime
if ($age.TotalMinutes -gt 60) { exit 0 }

$content = Get-Content $statusFile -Raw -Encoding UTF8
Write-Output "`n[STATUS-BOARD bijgewerkt $([int]$age.TotalMinutes) min geleden]`n$content"
