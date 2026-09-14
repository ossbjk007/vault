# Bewaakt waar het alias `gemini-flash-lite-latest` naartoe wijst (het model dat de
# ZekerWet Copilot gebruikt). Stuurt een Telegram-melding zodra het alias doorschuift
# naar een nieuwe modelversie, met nadruk of het DUURDER wordt. Draait dagelijks.
#
# Waarom: de globale AI-kostencap in src/lib/cost-meter.ts is geprijsd op een vaste
# modelversie. Als Google `-latest` doorschuift naar een nieuwer (meestal duurder)
# flash-lite-model, moeten INPUT/OUTPUT_PRICE_PER_M_MICROS omhoog anders telt de cap
# de echte uitgaven te laag.

$ErrorActionPreference = "Stop"

. "$PSScriptRoot\secrets.local.ps1"

$PROJECT_DIR     = "C:\Users\acerd\OneDrive\Bureaublad\Project Compliance & automatic document generator\zekerwet"
$STATE           = "$PSScriptRoot\.gemini-model-version"
$BASELINE        = "gemini-3.5-flash-lite"

# Bekende output-prijs (EUR per 1M tokens) per flash-lite-versie. Spiegelt de waarden
# uit cost-meter.ts. Onbekende (toekomstige) versies -> handmatig checken.
$PRICES = @{
    "gemini-2.5-flash-lite" = 0.40
    "gemini-3.1-flash-lite" = 1.50
    "gemini-3.5-flash-lite" = 2.50
}

function Send-Telegram($text) {
    try {
        Invoke-RestMethod -Uri "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" -Method Post -Body @{
            chat_id = $TELEGRAM_CHATID; text = $text; parse_mode = "HTML"
        } | Out-Null
    } catch {}
}

# API-key uit de project-env lezen (niet dupliceren in dit script).
$key = $null
foreach ($f in @(".env.local", ".env", ".env.production")) {
    $p = Join-Path $PROJECT_DIR $f
    if (Test-Path $p) {
        $m = Select-String -Path $p -Pattern 'GOOGLE_AI_API_KEY\s*=\s*(.+)' | Select-Object -First 1
        if ($m) { $key = $m.Matches[0].Groups[1].Value.Trim().Trim('"').Trim("'"); break }
    }
}
if (-not $key) { exit 0 }

try {
    $body = @{
        contents         = @(@{ parts = @(@{ text = "hi" }) })
        generationConfig = @{ maxOutputTokens = 1 }
    } | ConvertTo-Json -Depth 6

    $resp = Invoke-RestMethod -Method Post -ContentType "application/json" -Body $body `
        -Uri "https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-lite-latest:generateContent?key=$key"

    $version = $resp.modelVersion
    if (-not $version) { exit 0 }

    # Vorige bekende versie (eerste run: baseline, stil vastleggen).
    $last = if (Test-Path $STATE) { (Get-Content $STATE -Raw).Trim() } else { $BASELINE }

    if ($version -ne $last) {
        $oldP = $PRICES[$last]
        $newP = $PRICES[$version]

        if ($null -eq $newP) {
            $verdict = "❓ <b>Onbekende prijs</b> — check ai.google.dev/gemini-api/docs/pricing en werk <code>cost-meter.ts</code> bij."
        }
        elseif ($null -ne $oldP -and $newP -gt $oldP) {
            $pct = [math]::Round((($newP - $oldP) / $oldP) * 100)
            $verdict = "⚠️ <b>DUURDER</b>: output €$oldP → €$newP per 1M (+$pct%). Werk <code>cost-meter.ts</code> bij, anders telt de kostencap te laag."
        }
        else {
            $verdict = "✅ Niet duurder (output €$newP per 1M). Werk <code>cost-meter.ts</code> alsnog bij voor de juiste waarde."
        }

        Send-Telegram "🤖 <b>ZekerWet Copilot-model verschoven</b>`n`n<code>gemini-flash-lite-latest</code> wijst nu naar <b>$version</b> (was $last).`n`n$verdict"
        Set-Content -Path $STATE -Value $version
    }

    # Eerste run zonder statebestand: baseline vastleggen zodat we alleen op ECHTE
    # veranderingen alarmeren.
    if (-not (Test-Path $STATE)) { Set-Content -Path $STATE -Value $version }
}
catch {
    # Netwerk/API-fout: stil overslaan, volgende run probeert opnieuw.
}
