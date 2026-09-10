# GEARCHIVEERD op 10 september 2026. Vervangen door de reconciler.
#
# Dit script greppte logboek.md op de datum van vandaag. Omdat de logboekregel
# werd geschreven op het moment van INPLANNEN, bevestigde het een voorspelling
# uit het verleden in plaats van een uitkomst.
#
# Op 7 september stond de regel "LinkedIn: educational post | ingepland via
# Buffer" al sinds 22 augustus in het logboek. Het script zag de datum, zweeg,
# en het woord ONTBREEKT stond die ochtend live op LinkedIn. Op 9 september
# gebeurde hetzelfde nog een keer.
#
# De vervanger vraagt Buffer wat er werkelijk is gebeurd en eist een live URL
# voordat iets PUBLISHED heet: zekerwet/marketing/reconcile.ts, aangestuurd door
# scripts/mkt-reconcile.ps1 en de taak ZekerWet_Reconcile (elk uur).
#
# Bewaard als bewijs, niet als code. Niet opnieuw in gebruik nemen.

# Accountability check: vergelijkt wat gepland was met wat gedaan is
# Draait elke avond om 21:00

$vault = "C:\Users\acerd\OneDrive\Documenten\vault"
$logboek = "$vault\Projects\ZekerWet\marketing\logboek.md"
$vandaag = Get-Date -Format "yyyy-MM-dd"
$dag = (Get-Date).DayOfWeek

# Lees logboek
$log = Get-Content $logboek -Raw -Encoding UTF8

# Check of vandaag iets gepost had moeten worden
$moestPosten = switch ($dag) {
    "Monday"    { "LinkedIn educational post" }
    "Tuesday"   { "Instagram + Facebook carousel" }
    "Wednesday" { "LinkedIn product-spotlight + X-thread" }
    "Thursday"  { "LinkedIn educational #2" }
    "Friday"    { "Instagram + Facebook carousel + X-tweet" }
    default     { $null }
}

if (-not $moestPosten) { exit 0 }

# Check of het gelogd is
if ($log -match $vandaag) {
    # Vandaag staat in het logboek — goed
    $check = $log | Select-String $vandaag | Select-Object -First 1
    if ($check -match "OVERGESLAGEN") {
        & "$vault\scripts\notify.ps1" -Titel "ZekerWet accountability" -Bericht "Vandaag overgeslagen: $moestPosten. Wil je inhalen of bewust skippen?"
    }
} else {
    # Vandaag staat NIET in het logboek
    & "$vault\scripts\notify.ps1" -Titel "ZekerWet — niet gelogd" -Bericht "Je hebt vandaag niets gelogd. Was er iets te posten? Voeg een regel toe aan het logboek."
}
