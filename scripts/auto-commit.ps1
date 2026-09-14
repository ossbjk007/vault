# Nachtelijke auto-commit van de vault.
# Instellen via Windows Taakplanner (zie instructies onderaan dit bestand).
# Draait stil, zonder foutmelding als er geen wijzigingen zijn.

$vault = Split-Path -Parent $PSScriptRoot
Set-Location $vault

$status = git status --porcelain
if (-not $status) { exit 0 }

git add Context Daily Projects Intelligence Resources scripts CLAUDE.md .gitignore
$date = Get-Date -Format "yyyy-MM-dd HH:mm"
git commit -m "auto-commit $date"

git push origin main --quiet 2>$null

<#
INSTELLEN ALS GEPLANDE TAAK (eenmalig uitvoeren in PowerShell als administrator):

$action = New-ScheduledTaskAction -Execute "powershell.exe" `
    -Argument "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"C:\Users\acerd\OneDrive\Documenten\vault\scripts\auto-commit.ps1`""
$trigger = New-ScheduledTaskTrigger -Daily -At "02:00"
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -DontStopOnIdleEnd
Register-ScheduledTask -TaskName "VaultAutoCommit" -Action $action -Trigger $trigger -Settings $settings -Force

Na het instellen draait de commit elke nacht om 02:00 automatisch.
#>
