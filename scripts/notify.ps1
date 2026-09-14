# Stuur een Windows-notificatie + Telegram-bericht
param([string]$Titel, [string]$Bericht)

. "$PSScriptRoot\secrets.local.ps1"

# Windows balloon
Add-Type -AssemblyName System.Windows.Forms
$icon = [System.Windows.Forms.NotifyIcon]::new()
$icon.Icon = [System.Drawing.SystemIcons]::Information
$icon.Visible = $true
$icon.ShowBalloonTip(15000, $Titel, $Bericht, [System.Windows.Forms.ToolTipIcon]::Info)
Start-Sleep -Seconds 3
$icon.Dispose()

# Telegram
try {
    $tekst = "<b>$Titel</b>`n$Bericht"
    Invoke-RestMethod -Uri "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" -Method Post -Body @{
        chat_id    = $TELEGRAM_CHATID
        text       = $tekst
        parse_mode = "HTML"
    } | Out-Null
} catch {
    # Een alarmkanaal dat stil faalt is geen alarmkanaal. Zichtbaar maken en vastleggen,
    # zodat een kapotte melding niet lijkt op een rustige dag.
    $fout = "$(Get-Date -Format o)`t$Titel`t$($_.Exception.Message)"
    Write-Error "notify.ps1: Telegram niet afgeleverd - $($_.Exception.Message)"
    try { Add-Content -Path "$PSScriptRoot\.notify-failures.log" -Value $fout -Encoding UTF8 } catch { }
    exit 1
}
