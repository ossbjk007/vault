# T-24h pre-flight — daily.
#
# Re-runs the full validation gate against everything queued to fire in the next
# 24 hours, and disarms anything that no longer passes.
#
# This is the check that would have caught ONTBREEKT. The gate at authoring time
# could not: the placeholder was written deliberately, meaning to come back. What
# failed was the eighteen days in between, when nothing looked at it again.
#
# It also catches the case nothing else can: the copy is untouched and was
# correct on approval day, and a price or an entitlement moved underneath it.
#
# Registered as ZekerWet_Preflight. Runs at 18:00, so a block on tomorrow's
# 07:45 slot leaves an evening to fix it.

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

. "$PSScriptRoot\secrets.local.ps1"

$repo = "C:\Users\acerd\OneDrive\Bureaublad\Project Compliance & automatic document generator\zekerwet"
Set-Location $repo

$log = "$repo\marketing\logs\preflight.log"
New-Item -ItemType Directory -Force (Split-Path $log) | Out-Null

$stamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$output = & npm run --silent mkt:preflight 2>&1 | Out-String
$code = $LASTEXITCODE

Add-Content -Path $log -Value "===== $stamp (exit $code) =====" -Encoding UTF8
Add-Content -Path $log -Value $output -Encoding UTF8

# Exit 1 means something was blocked; pre-flight has already sent its own
# Telegram alert naming the item, so do not double-notify. Anything else
# non-zero means pre-flight could not run, which nothing else would report --
# and a pre-flight that silently fails to run is the failure it exists to prevent.
if ($code -ne 0 -and $code -ne 1) {
    & "$PSScriptRoot\notify.ps1" `
        -Titel "ZekerWet - pre-flight kon niet draaien" `
        -Bericht "Exit $code. Er staat content ingepland die vanavond NIET is gecontroleerd. Zie $log"
}

exit $code
