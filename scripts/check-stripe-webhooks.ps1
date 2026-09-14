# Bewaakt of Stripe-webhooks daadwerkelijk bij ZekerWet aankomen.
#
# Waarom: op 11 en 22 augustus 2026 zijn negen events nooit afgeleverd. Daardoor
# stond een betaald abonnement wel in Stripe maar nooit in de app, en dat bleef
# negentien dagen onopgemerkt tot een klant boos werd. Een event dat na een
# kwartier nog op pending_webhooks > 0 staat is bezorgd noch verwerkt.
#
# Draait elk kwartier als taak ZekerWet_WebhookWatch. Raakt de productie-app
# niet aan: alleen leesverkeer naar de Stripe API.
#
# Schakelaars voor verificatie zonder te alarmeren:
#   -DryRun            toon wat er gemeld zou worden, stuur niets, schrijf geen state
#   -LookbackHours N   kijk verder terug dan het standaardvenster

param(
    [switch]$DryRun,
    [int]$LookbackHours = 24
)

$ErrorActionPreference = "Stop"

. "$PSScriptRoot\secrets.local.ps1"

# Voorkeur voor een restricted key met alleen leesrecht op Events. Staat die niet
# in secrets.local.ps1, dan valt hij terug op de gewone sleutel.
$key = if ($STRIPE_MONITOR_KEY) { $STRIPE_MONITOR_KEY } else { $STRIPE_KEY }

$STATE       = "$PSScriptRoot\.webhook-alerts"
$MIN_AGE_SEC = 900      # 15 minuten: jong genoeg om snel te zijn, oud genoeg om
                        # een normale bezorging niet als storing te zien
$STATE_TTL   = 30       # dagen; Stripe bewaart events zelf ook 30 dagen

# Exact de acht types waarop het productie-endpoint geabonneerd is. Andere types
# worden door Stripe niet aan ons aangeboden en zeggen dus niets over bezorging.
$WATCHED = @(
    'checkout.session.completed',
    'invoice.payment_succeeded',
    'invoice.payment_failed',
    'customer.subscription.updated',
    'customer.subscription.deleted',
    'customer.subscription.trial_will_end',
    'charge.refunded',
    'customer.deleted'
)

function Send-Telegram($text) {
    try {
        Invoke-RestMethod -Uri "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" -Method Post -Body @{
            chat_id = $TELEGRAM_CHATID; text = $text; parse_mode = "HTML"
        } | Out-Null
    } catch {}
}

# Al gemelde events onthouden, zodat één storing niet elk kwartier opnieuw piept.
$alerted = @{}
if (Test-Path $STATE) {
    foreach ($line in Get-Content $STATE) {
        $parts = $line -split '\|'
        if ($parts.Count -eq 2) { $alerted[$parts[0]] = [long]$parts[1] }
    }
}

try {
    $now   = [long][double]::Parse((Get-Date -UFormat %s))
    $since = $now - ($LookbackHours * 3600)

    $headers = @{ Authorization = "Bearer $key" }
    $events  = @()
    $uri     = "https://api.stripe.com/v1/events?limit=100&created[gte]=$since"

    while ($uri) {
        $page = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get
        $events += $page.data
        if ($page.has_more -and $page.data.Count -gt 0) {
            $last = $page.data[$page.data.Count - 1].id
            $uri  = "https://api.stripe.com/v1/events?limit=100&created[gte]=$since&starting_after=$last"
        } else {
            $uri = $null
        }
    }

    $stuck = $events | Where-Object {
        $WATCHED -contains $_.type -and
        $_.pending_webhooks -gt 0 -and
        ($now - $_.created) -gt $MIN_AGE_SEC
    }

    $new = $stuck | Where-Object { -not $alerted.ContainsKey($_.id) }

    if ($DryRun) {
        Write-Output "DRY RUN: $($events.Count) events bekeken over $LookbackHours uur"
        Write-Output "  onbezorgd en ouder dan 15 min : $(@($stuck).Count)"
        Write-Output "  daarvan nog niet gemeld       : $(@($new).Count)"
        foreach ($e in $stuck) {
            $age = [math]::Round(($now - $e.created) / 60)
            $seen = if ($alerted.ContainsKey($e.id)) { "al gemeld" } else { "NIEUW" }
            Write-Output ("    {0} | {1} | {2} min oud | {3}" -f $e.id, $e.type, $age, $seen)
        }
        exit 0
    }

    if (@($new).Count -gt 0) {
        $lines = ($new | Select-Object -First 5 | ForEach-Object {
            $age = [math]::Round(($now - $_.created) / 60)
            "- <code>$($_.type)</code> ($age min, $($_.id))"
        }) -join "`n"
        $extra = if (@($new).Count -gt 5) { "`n... en $((@($new).Count) - 5) meer" } else { "" }

        Send-Telegram ("‼️ <b>Stripe-webhooks komen niet aan bij ZekerWet</b>`n`n" +
            "$(@($new).Count) event(s) staan na 15 minuten nog op onbezorgd. Een betaald abonnement kan nu wel in Stripe staan en niet in de app.`n`n" +
            "$lines$extra`n`n" +
            "Check: <code>https://zekerwet.nl/api/stripe/webhook</code> moet direct 400 geven zonder redirect, en het endpoint moet op de apex staan.")

        foreach ($e in $new) { $alerted[$e.id] = $now }
    }

    # State wegschrijven en oude regels opruimen.
    $cutoff = $now - ($STATE_TTL * 86400)
    $out = foreach ($k in $alerted.Keys) { if ($alerted[$k] -ge $cutoff) { "$k|$($alerted[$k])" } }
    Set-Content -Path $STATE -Value $out -Encoding UTF8
}
catch {
    # Netwerk- of API-fout: stil overslaan. Een bewaker mag nooit zelf alarm slaan
    # over zichzelf, en de volgende run over een kwartier probeert het opnieuw.
    exit 0
}
