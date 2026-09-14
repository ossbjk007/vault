# Bewaakt de supportinbox van ZekerWet (support@ en info@zekerwet.nl in de Gmail-box)
# en meldt nieuwe en onbeantwoorde klantmails via Telegram. De logica staat in
# check-support-inbox.py; dit bestand geeft alleen de secrets door en registreert
# de geplande taak.
#
# Draait elk kwartier als taak ZekerWet_SupportInbox. Alleen leesverkeer naar Gmail.
#
# Vereist in secrets.local.ps1:
#   $GMAIL_USER         = "zekerwet@gmail.com"
#   $GMAIL_APP_PASSWORD = "<16 tekens app-wachtwoord, myaccount.google.com/apppasswords>"
#
# Schakelaars:
#   -DryRun     toon wat er gemeld zou worden, stuur niets, schrijf geen state
#   -Register   maak of ververs de geplande taak (elk kwartier, ook op accu)

param(
    [switch]$DryRun,
    [switch]$Register
)

$ErrorActionPreference = "Stop"

if ($Register) {
    $action   = New-ScheduledTaskAction -Execute "powershell.exe" `
        -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$PSCommandPath`""
    $trigger  = New-ScheduledTaskTrigger -Once -At (Get-Date).Date `
        -RepetitionInterval (New-TimeSpan -Minutes 15)
    # Een laptop staat vaker op accu dan aan de lader. Een bewaking die dan
    # stopt, is geen bewaking. Op 14 september 2026 bleek WebhookWatch om die
    # reden sinds de avond ervoor niet gedraaid te hebben.
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries `
        -DontStopIfGoingOnBatteries -StartWhenAvailable -MultipleInstances IgnoreNew `
        -ExecutionTimeLimit (New-TimeSpan -Minutes 5)
    Register-ScheduledTask -TaskName "ZekerWet_SupportInbox" -Action $action `
        -Trigger $trigger -Settings $settings -Force | Out-Null
    Write-Host "ZekerWet_SupportInbox geregistreerd: elk kwartier, ook op accu."
    exit 0
}

. "$PSScriptRoot\secrets.local.ps1"

$env:TELEGRAM_TOKEN     = $TELEGRAM_TOKEN
$env:TELEGRAM_CHATID    = $TELEGRAM_CHATID
$env:GMAIL_USER         = $GMAIL_USER
$env:GMAIL_APP_PASSWORD = $GMAIL_APP_PASSWORD

$args = @("$PSScriptRoot\check-support-inbox.py")
if ($DryRun) { $args += "--dry-run" }

& python @args
exit $LASTEXITCODE
