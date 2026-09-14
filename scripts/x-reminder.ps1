# Stuurt de kant-en-klare X-tekst naar Telegram op het moment dat hij geplaatst moet worden.
# X hangt niet aan Buffer (gratis plan staat drie kanalen toe, die zijn bezet), dus dit blijft
# handwerk. Dit script haalt het zoekwerk weg, niet de handeling.
param(
    [Parameter(Mandatory=$true)][string]$Draft,
    [Parameter(Mandatory=$true)][string]$Dag,      # bv. "woensdag 16 september"
    [Parameter(Mandatory=$true)][string]$Tijd,     # bv. "08:45"
    [string]$Id = ""                                # content-id voor de bevestiging
)

$vault = "C:\Users\acerd\OneDrive\Documenten\vault"
$repo  = "C:\Users\acerd\OneDrive\Bureaublad\Project Compliance & automatic document generator\zekerwet"
$pad   = Join-Path $repo $Draft

if (-not (Test-Path $pad)) {
    & "$vault\scripts\notify.ps1" -Titel "X-post: tekst niet gevonden" -Bericht "Verwacht bestand: $Draft`nZoek de tekst in de projectterminal."
    exit 1
}

$tekst = (Get-Content $pad -Raw -Encoding UTF8).Trim()

# Telegram gebruikt parse_mode HTML, dus & < > moeten geescaped. De & staat in elke UTM-link.
function Esc([string]$s) { $s -replace '&','&amp;' -replace '<','&lt;' -replace '>','&gt;' }

if (-not $Id) { $Id = [System.IO.Path]::GetFileNameWithoutExtension($pad) }

$bericht = @"
$(Esc "$Dag, $Tijd - plaatsen op x.com")

Kopieer het blok hieronder en plak het ongewijzigd. Deze tekst is door de
validatiepoort gekomen; een zin die je hier aanpast is niet meer gecontroleerd.

<pre>$(Esc $tekst)</pre>

Daarna in de ZekerWet-repo bevestigen, anders telt het als overgeslagen slot:
<code>npm run mkt:confirm -- --id $(Esc $Id)</code>
"@

& "$vault\scripts\notify.ps1" -Titel "X-post $Dag" -Bericht $bericht
