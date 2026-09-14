. "$PSScriptRoot\secrets.local.ps1"
$env:HOME = $env:USERPROFILE

$LI = "6a8a06f1ccaf649a67f8d130"
$tmpDir = "$env:TEMP\buffer-week3"
New-Item -ItemType Directory -Force $tmpDir | Out-Null

# Maandag 24 aug 07:45 — LinkedIn
$text1 = "9 van de 10 concurrentiebedingen in tijdelijke contracten zijn nietig.`n`nDat is geen mening. Dat staat in de WAB.`n`nSinds de Wet Arbeidsmarkt in Balans (WAB, 2020) geldt een hard verbod: een concurrentiebeding in een tijdelijk contract is alleen rechtsgeldig als de werkgever een zwaarwegend bedrijfsbelang schriftelijk motiveert in het contract zelf. Niet in een bijlage. Niet achteraf. In het contract.`n`nWat fout gaat in de praktijk:`n1. Het beding staat er wel, de motivering niet.`n2. De motivering is generiek in plaats van functie-specifiek.`n3. Het beding wordt klakkeloos gekopieerd uit een oud contract uit 2018.`n`nGevolg: de rechter vernietigt het beding. De werknemer mag direct bij de concurrent aan de slag.`n`nBron: Burgerlijk Wetboek boek 7, art. 653 BW.`n`nStart gratis op zekerwet.nl`n`nLaat juridisch belangrijke documenten altijd nakijken door een jurist voor ondertekening.`n`n#ZZP #HR #ondernemen #Arbeidsrecht"
[ordered]@{ channelId=$LI; schedulingType="exact"; scheduledAt="2026-08-24T07:45:00+02:00"; text=$text1 } | ConvertTo-Json | Set-Content "$tmpDir\post1.json" -Encoding UTF8

# Woensdag 26 aug 07:30 — LinkedIn
$text3 = "Een vaststellingsovereenkomst opstellen kost gemiddeld 3 tot 6 uur advocaattijd. Dat is een rekening van 900 tot 1.800 euro, voor één document.`n`nZekerWet doet het anders.`n`nDe VSO-template is getoetst aan BW boek 7, artikel 900 en de vereisten van de WAB. Je vult de gegevens in, het systeem genereert een juridisch correcte overeenkomst, klaar voor jurist-review.`n`nVoor wie:`n— HR-managers die een uitdiensttreding netjes willen afronden`n— MKB-ondernemers die een geschil willen oplossen zonder rechter`n— Bedrijven die de bedenktijd van 14 dagen correct willen borgen (conform Art. 7:670b BW)`n`nWat de VSO dekt: einddatum, transitievergoeding, WW-behoud en finaal kwijtingsbeding.`n`nConcept klaar in 2 minuten. Laat altijd nakijken door een jurist voor ondertekening.`n`nGenereer jouw VSO op zekerwet.nl/documenten/vaststellingsovereenkomst`n`n#MKB #Juridisch #Contracten #Ondernemen #Compliance"
[ordered]@{ channelId=$LI; schedulingType="exact"; scheduledAt="2026-08-26T07:30:00+02:00"; text=$text3 } | ConvertTo-Json | Set-Content "$tmpDir\post3.json" -Encoding UTF8

# Donderdag 27 aug 07:45 — LinkedIn
$text4 = "Een manager stuurde zijn medewerker een e-mail: 'Je functioneert niet goed. Dit kan zo niet doorgaan.'`n`nDrie maanden later lag er een ontslagaanvraag. Het UWV wees die af.`n`nReden: er was nooit een verbeterplan opgesteld.`n`nJe kunt een medewerker niet ontslaan wegens disfunctioneren zonder dossier. Dat dossier begint met een verbeterplan (PIP).`n`nWat moet er minimaal in staan?`n1. Concrete beschrijving tekortkomingen met voorbeelden en data`n2. Meetbare doelen voor de verbeterperiode (SMART)`n3. Duur van het traject (doorgaans 6 tot 12 weken)`n4. Welke begeleiding je als werkgever biedt`n5. Consequenties als doelen niet worden gehaald`n`nZonder deze elementen is ontslag wegens disfunctioneren vrijwel niet houdbaar bij UWV of kantonrechter. Bron: BW 7:611 en Wet Poortwachter.`n`nGenereer jouw verbeterplan op zekerwet.nl/documenten/verbeterplan`n`nLaat juridisch belangrijke documenten altijd nakijken door een jurist voor ondertekening.`n`n#MKB #Ondernemen #Juridisch #Contracten #ZZP"
[ordered]@{ channelId=$LI; schedulingType="exact"; scheduledAt="2026-08-27T07:45:00+02:00"; text=$text4 } | ConvertTo-Json | Set-Content "$tmpDir\post4.json" -Encoding UTF8

Write-Host "Maandag 24 aug — LinkedIn..."
buffer posts create --input "$tmpDir\post1.json" --output json

Write-Host "Woensdag 26 aug — LinkedIn..."
buffer posts create --input "$tmpDir\post3.json" --output json

Write-Host "Donderdag 27 aug — LinkedIn..."
buffer posts create --input "$tmpDir\post4.json" --output json

Remove-Item $tmpDir -Recurse -Force
Write-Host "`nKlaar. Drie LinkedIn-posts ingepland."
