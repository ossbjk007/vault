---
type: note
date: 2026-09-06
status: afgerond
tags: [zekerwet, documentgeneratie, pdf, docx, kwaliteit]
project: ZekerWet
---

De documentmotor van [[ZekerWet]] is herbouwd. Aanleiding: een testdocument (een ontbindingsbrief) zag eruit als software-output en niet als een brief die een ondernemer durft te versturen. Bovenaan stond "ZekerWet.", in de voettekst "Genereerd op 06-09-2026 | Juridisch concept — raadpleeg een advocaat bij twijfel", plus een referentienummer `ONTBINDING-4436` dat een database-id leek. Pagina 2 was voor tachtig procent leeg.

> [!info] Kernprincipe
> ZekerWet maakt het document van de klant, geen document van ZekerWet. Alles wat de klant over de software vertelt, hoort in de app en niet in het bestand dat naar een werknemer, advocaat of leverancier gaat.

## Wat er mis was

Presentatie en inhoud zaten in één bestand van 17.627 regels: `src/lib/pdf-service.ts`, één `if/else`-keten over 236 sjablonen die rechtstreeks op coördinaten tekende. Elke pagina-einde was een handmatige gok (`if (y + 40 > 270) doc.addPage()`), 469 van die gokken stonden in het bestand. Daardoor sprong de tekst naar een nieuwe pagina voordat de vorige vol was. Marges verschilden per sjabloon (14, 20 en 25 millimeter), en de nieuwere sjablonen tekenden blauwe balken en gekleurde kaders die de website-stijl in een juridisch document trokken.

## Wat er nu staat

Een documentmotor in `src/lib/document/`: de sjablonen beschrijven nog steeds wát er staat, een recorder vertaalt dat naar semantische blokken (kop, alinea, partijenlijst, tabelrij, ondertekenblok) en een layout-engine meet de tekst en bepaalt de pagina-indeling. Eén ontwerpsysteem bedient daardoor de hele bibliotheek zonder 233 losse implementaties. De juridische teksten zijn niet herschreven.

Serif-zetwerk (Times, kernfont van PDF dus overal identiek), A4 met 25 millimeter marge, 10,5 punt met 1,42 regelafstand. Brieven krijgen een briefhoofd met haarlijn en ondertekenen zoals een brief hoort: "Hoogachtend," met ondertekenruimte en de naam eronder. Contracten krijgen een gecentreerde titel, genummerde artikelen en een ondertekenblok in twee kolommen met plaats-, datum- en handtekeningregels. Verklaringen en beleidsstukken krijgen hun eigen indeling. Voettekst met paginanummer verschijnt alleen bij meerdere pagina's.

Nieuw is ook de Word-export: dezelfde blokken worden naar Office Open XML geschreven, dus de klant kan het document doorsturen naar een jurist die er nog in wil werken. Getest door de bestanden in Word te openen en naar PDF te exporteren.

## Bewijs

`scripts/document-qa.ts` genereert alle 233 sjablonen in drie varianten (normaal, extreem lange bedrijfsnamen, alleen verplichte velden) en meldt hoe vol elke pagina staat en of er nog productnaam, generatiedatum of AI-disclaimer in de tekst zit. Uitkomst: 233 documenten, nul lekken, geen enkel sjabloon dat crasht of leeg blijft. `scripts/document-render.mjs` zet PDF's om naar afbeeldingen zodat de pagina's ook echt bekeken worden.

Gerelateerd: [[product-audit-2026-09-03]], [[copilot-handover-2026-08-31]].

## Tweede ronde, 7 september 2026

Kwaliteitsronde over de echte PDF's in plaats van over de code. Wat eruit kwam:

De regels waren te lang. Times 10,5 punt over 160 millimeter gaf 105 tekens per regel, ruim boven de 60 tot 90 die comfortabel leest. Nu 11,5 punt over 150 millimeter met marges van 30 millimeter: ongeveer 90 tekens. Alle koppen mee opgeschaald.

Zeven tekens braken de opmaak zichtbaar. De PDF-kernfonts kennen alleen WinAnsi; een teken daarbuiten zoals ⚠, ≠, ≥, → of de omgekeerde aanhalingstekens die de sjablonen gebruikten (`„…‟`) leverde niet alleen een verkeerd glyph op, maar liet jsPDF terugvallen op een pad dat de hele regel uit elkaar spatieerde. 27 sjablonen deden dit. Er staat nu een vertaaltabel plus een vangnet dat elk onbekend teken weggooit, en een controle over alle 233 sjablonen die nul onvertaalbare tekens meldt.

Balken met één regel tekst bleken kopjes, geen kaders. Sjablonen als het personeelshandboek en het datalekprotocol tekenden hun secties als gekleurde balk; die werden als notitie gerenderd. Het aantal notities zakte van 274 naar 108, de rest zijn nu koppen. Titelbalken werden documenttitel plus ondertitel.

Het referentienummer in de voettekst is weg. `2026-0412` kwam wel degelijk van de klant (het veld "Referentienummer of kenmerk"), maar de brief zet het al in de Betreft-regel, en in een ander sjabloon betekent hetzelfde veld iets anders. De voettekst van een brief draagt nu alleen een paginanummer; "Brief Ontbinding Overeenkomst" is de catalogusnaam van ZekerWet en hoort niet onderaan de brief van de klant.

Vier kaders bleken instructies aan de afzender in plaats van inhoud voor de ontvanger, waaronder "(aanpassen)" op de factuur en "Bewaar een ondertekend exemplaar in het personeelsdossier" in een brief aan de werknemer. Die zijn eruit. De rest van de LET OP-kaders bevat wettelijke feiten voor beide partijen en blijft staan.

> [!warning] Inhoudelijke bug gevonden en gerepareerd
> Bedragen werden gelezen met `parseFloat(x.replace(',', '.'))`. Een salaris van 4.750 werd daardoor 4,75 euro en op de factuur werd 3.520,00 een btw-regel van 0,74. Twee plekken, nu via één parser die Nederlandse notatie begrijpt. Dit is inhoud, geen opmaak, dus expliciet vermeld.

Twee tekstfouten in sjablonen niet aangeraakt, wel gemeld: de ingebrekestelling schrijft "Tevens maakt u aanspraak op wettelijke handelsrente" waar de afzender die aanspraak maakt, en het ondernemingsplan bevat placeholders tussen blokhaken.

Bewijs: 932 documenten (233 sjablonen maal vier datasets, waaronder bedrijfsnamen van 150 tekens en niet-afbreekbare e-mailadressen) zonder tekst buiten de tekstkolom en zonder applicatietekst. 119 tests groen.

## Derde ronde, 7 september 2026 — release-gate

Laatste controleronde voor commit. Zeven defecten dicht.

Geldbedragen bleken op zes plekken verkeerd te worden ingelezen, niet twee. Naast het salaris en de factuur ook de term sheet (een pre-money waardering van 1.500.000 werd 1,5, dus post-money en verwatering klopten niet) en de alimentatie-indexering (1.250 werd 1,25). Alles loopt nu via één parser die de laatste scheidingsteken als decimaalteken leest, waarmee zowel 4.750, 4.750,00, 99,95 als 99.95 goed gaan. Weergave hoort erbij: `toFixed(2)` gaf "EUR 380.00", dat is nu "EUR 380,00" en bedragen boven de duizend krijgen een punt.

De ingebrekestelling schreef "Tevens maakt u aanspraak op wettelijke handelsrente". De hele brief is geschreven vanuit "wij" naar "u", en onder art. 6:119/6:119a BW is de schuldeiser degene die rente vordert. Twee woorden gewijzigd naar "maken wij", verder niets.

Twaalf zinnen bleken instructies aan de afzender in plaats van inhoud voor de lezer, waaronder een expliciete "Disclaimer: dit rapport is gebaseerd op de door u ingevoerde gegevens en vervangt geen juridisch advies" in de schijnzelfstandigheidstoets. Die zat er nog omdat mijn eerste zoekactie alleen op "raadpleeg een advocaat" zocht. Drie sjablonen hadden een placeholder die het sjabloon zelf niet kon invullen, zoals "dividend ad [bedrag] per aandeel" in een aandeelhoudersbesluit; dat zijn nu invulregels. Het ondernemingsplan en de DPIA zeggen nu zelf dat passages tussen blokhaken door de eigenaar worden aangevuld.

De opnamestaat had geen handtekeningruimte: het sjabloon tekende korte lijnen die de recorder negeerde, en de kopregel "Handtekeningen:" stond boven de kolommen in plaats van erin. Ondertekenblokken worden nu ook herkend aan een kop erboven. Labels die sjablonen vet zetten werden platgeslagen; die vetheid wordt nu overgenomen voor labelvormige tekst, wat 204 plekken hiërarchie teruggeeft.

Controle draait nu ook op de gerenderde bestanden zelf: `scripts/document-leakscan.mjs` leest de tekst terug uit alle 233 PDF's en 7 Word-bestanden en zoekt daar naar productnaam, generatiedatum, disclaimers en interne verwijzingen. Nul treffers. Daarnaast 932 documenten (233 maal vier datasets) zonder tekst buiten de tekstkolom, 123 tests groen, productiebuild groen, en de Copilot haalt nog steeds schone tekst uit de nieuwe PDF's (3.275 tekens uit de NDA, met artikelen en partijen intact).

## Vierde ronde, 7 september 2026 — visuele poort over alle 233

De vorige ronde had ongeveer 35 van de 233 sjablonen met het oog bekeken. Dat is te weinig om te zeggen dat alles klopt, dus er staat nu een structurele inspectie: `scripts/document-inspect.ts` loopt de opgemaakte pagina's van elk sjabloon na op de dingen die een lezer opmerkt — een kop onderaan een pagina, een handtekening alleen op een vel, een pagina die op eenderde stopt, een titel die twee keer staat. Daarmee kon het kijkwerk gericht worden op de documenten die het nodig hadden.

Wat eruit kwam en gerepareerd is:

Koppen bleven onderaan pagina's staan. De oorzaak zat dieper dan het lijkt: een label-alinea heeft zelf ook "hou bij elkaar", en als die alinea besloot naar de volgende pagina te gaan, liet hij de kop achter. De layout-engine verplaatst nu de hele keten mee (maximaal drie blokken, nooit meer dan een derde pagina). Nul koppen onderaan een pagina, over alle vier de datasets.

De titel stond twee keer in vijf besluiten. De ontdubbeling keek alleen naar het eerste blok, terwijl die sjablonen eerst bedrijf en datum zetten en pas daarna hun titel.

Ondertekenruimte ontbrak in 32 sjablonen. De sjablonen schreven vier verschillende vormen: bijschrift onder de naam, bijschrift boven de naam, een raster van partijen onder één kopregel, en losse veldlabels. De herkenning kende er twee. Nu alle vier, plus een kort naschrift na het ondertekenblok. Van 163 naar 195 sjablonen met een echt ondertekenblok; de drie die overblijven zijn beleidsstukken waar "vaststelling" een registratie is en geen handtekeningveld.

`parseAmount` faalde nog op één van de door de gate genoemde vormen: `1,500,000` werd 1,5. Meerdere komma's zijn duizendtallen, één komma is het decimaalteken.

De huisregels drukten het nummer van elke regel twee keer af, en de regeltekst herhaalde de kop omdat een regex een leidend nummer verwachtte dat er niet stond.

Bewijs: 932 documenten zonder tekst buiten de kolom, 233 gerenderde PDF's en 7 Word-bestanden zonder applicatietekst, 136 tests, build groen, en zeven Word-bestanden opnieuw door Word gehaald.

## Slotcontrole, 7 september 2026

Drie punten nagelopen. Twee bleken echte defecten.

De drie beleidsstukken waarvan ik dacht dat "Vastgesteld en ontvangen" een registratie was, tekenden in het sjabloon wel degelijk handtekeningstrepen. De recorder negeerde die omdat ze korter zijn dan 90 millimeter, dus alleen de namen bleven over. Herkenning uitgebreid met twee vormen (kopregel met een tussenregel erboven, en een kop gevolgd door een rij losse namen) plus de woorden "vastgesteld en". Nu 199 van de 233 sjablonen met een echt ondertekenblok en nul sjablonen die over ondertekenen spreken zonder er ruimte voor te hebben.

De Word-export zet handgeplaatste rijen als tabellen van één rij. In Word is de regelafstand daardoor iets ruimer dan in de PDF, maar gelijkmatig en goed leesbaar. Niet veranderd: het is Word-eigen gedrag en geen kwaliteitsprobleem voor de klant.

Het NIS2-rapport heette in de catalogus "NIS2 Compliance Strategy & Gap Analysis" en die Engelse naam stond in de documenttitel, de voettekst, de bestandsnaam en de metadata van een Nederlandse klant. Nu "NIS2-compliancerapport en gap-analyse". Alleen de catalogusnaam gewijzigd, geen id en geen juridische inhoud. Meteen ook `org_name` toegevoegd aan de eigenaarsvelden, zodat privacyverklaringen en rapporten de klant als auteur krijgen in plaats van de documenttitel.
