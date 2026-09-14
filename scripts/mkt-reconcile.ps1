# Marketing reconciler — hourly.
#
# Replaces accountability-check.ps1, which grepped logboek.md for today's date
# and so confirmed a prediction written weeks earlier. On 7 September it stayed
# silent while the word ONTBREEKT went out on LinkedIn, because the "success"
# line had already been typed on 22 August.
#
# This asks Buffer what actually happened. PUBLISHED requires a live URL.
#
# Registered as ZekerWet_Reconcile. Runs hourly; it is cheap (one API call) and
# only writes when something changed.

# node writes UTF-8; without this PowerShell captures it as ANSI and the log
# fills with mojibake.
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

. "$PSScriptRoot\secrets.local.ps1"

$repo = "C:\Users\acerd\OneDrive\Bureaublad\Project Compliance & automatic document generator\zekerwet"
Set-Location $repo

$log = "$repo\marketing\logs\reconcile.log"
New-Item -ItemType Directory -Force (Split-Path $log) | Out-Null

$stamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$output = & npm run --silent mkt:reconcile 2>&1 | Out-String
$code = $LASTEXITCODE

Add-Content -Path $log -Value "===== $stamp (exit $code) =====" -Encoding UTF8
Add-Content -Path $log -Value $output -Encoding UTF8

# Exit code 1 means the reconciler raised a failure alert; it has already sent
# the Telegram message itself, so do not double-notify. Anything else non-zero
# means the reconciler could not run at all, which nothing else would report.
if ($code -ne 0 -and $code -ne 1) {
    & "$PSScriptRoot\notify.ps1" `
        -Titel "ZekerWet - reconciler kon niet draaien" `
        -Bericht "Exit $code. Zie $log"
}

exit $code
