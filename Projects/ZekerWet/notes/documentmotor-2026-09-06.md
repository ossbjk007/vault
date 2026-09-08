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

## Regressie na de drie fixes, 8 september 2026

De drie punten uit de acceptatietest zijn toegepast en nagemeten in de draaiende app, niet alleen in de tests.

Documenttitel uit de catalogus. `useDocumentDownload` haalt de naam nu uit `DOCUMENT_TEMPLATES` op basis van `doc.type`, met de opgeslagen titel als terugval. De catalogus wordt pas bij het downloaden ingeladen, dus de bundel groeit met een paar kilobytes. Bewijs: dezelfde arbeidsovereenkomst direct na genereren en later uit de kluis levert een identieke `document.xml`, dezelfde bestandsnaam en dezelfde metadata, en in de PDF verschilt alleen het aanmaaktijdstip.

Knoppenrij op de telefoon. Eén klassewijziging, `flex-wrap` met `sm:flex-nowrap`. Op 320, 375, 390 en 430 pixels staan alle drie de knoppen volledig in beeld, met de Word-knop op 135 pixels. Vanaf de `sm`-breedte is de opmaak aantoonbaar ongewijzigd: met de oude klassen teruggezet in de browser is de overloop op 640 pixels exact gelijk.

Namen die met "De" beginnen. De rolherkenning matcht nu op een lijst van echte rolwoorden in plaats van op een kaal lidwoord. "De Vries Techniek B.V." staat als naam boven de rol "Werkgever", zowel in de spec als in de gerenderde PDF en het Word-bestand.

### Twee defecten die deze ronde bovenkwamen

De Word-export kent de briefvorm niet. `docx.ts` heeft geen tak voor `style === 'letter'`, dus 66 van de 233 sjablonen krijgen in Word een contractblok met "Datum: ____" en "Handtekening", terwijl de PDF eindigt met witruimte boven de afzendernaam zoals een brief hoort te eindigen. De tekstvergelijking tussen beide formaten laat het direct zien: "Datum:" en "Handtekening" komen alleen in het Word-bestand voor.

Dertien sjablonen noemen zichzelf twee keer. `withTitle` ontdubbelt alleen koppen langer dan acht tekens, dus "FACTUUR" onder de titel "Factuursjabloon" glipt erdoor. Op een echte factuur van een klant staat daardoor het woord sjabloon. Hetzelfde patroon bij onder meer de borgstelling, de managementovereenkomst, het nulurencontract en de franchiseovereenkomst.

Beide zaten er al voor deze ronde in en zijn niet aangeraakt, want de opdracht was drie fixes en een regressie. Ze liggen ter beoordeling bij [[Ali Can]].

## Exportkwaliteitspoort, 8 september 2026

De twee klantzichtbare defecten van deze ochtend zijn dicht, plus twee die tijdens de controle bovenkwamen.

De Word-export kende de briefvorm niet. `docx.ts` had geen tak voor `style === 'letter'`, dus 66 sjablonen kregen in Word een contractblok met "Datum: ____" en "Handtekening". Er staat nu dezelfde tak als in de PDF-motor: afsluitzin, ondertekenruimte, naam vet, rol eronder. Beslist op het semantische model, niet op sjabloon-id's, dus een brief blijft een brief in beide formaten. Bewezen door het Word-bestand in Word zelf te openen, naar PDF te exporteren en de pagina's naast elkaar te leggen: identiek.

Dertien sjablonen noemden zichzelf twee keer. `withTitle` keek alleen naar koppen en naar regelblokken van precies één regel, en ontdubbelde alleen boven de acht tekens. Nu herkent het een getekende titelbanner (eerste regel vet, wat eronder staat platter) en verwijdert alleen die regel, zodat het factuurnummer en de factuurdatum blijven staan. De ondergrens is vijf tekens voor een banner en negen voor een gewone kop, zodat "Verhuurder" in de verhuurdersverklaring gewoon een kopje blijft.

De catalogusnaam "Factuursjabloon" is "Factuur" geworden. Het woord sjabloon hoort niet op de factuur van een klant. Alleen de titel gewijzigd, niet het id en niet de inhoud.

Twee vondsten uit de poort zelf. De Word-export zette altijd een voettekst, terwijl de PDF er op een document van één pagina bewust geen zet: een factuur kreeg dus "Factuur | Pagina 1 van 1" in Word en niets in de PDF. De app-route geeft nu `withFooter` door op basis van de PDF-paginatelling. En de dashboardpagina schoof op een telefoon horizontaal weg: `main` is een flex-kind zonder `min-w-0` en wilde daardoor niet onder zijn eigen min-content krimpen. Eén klasse erbij, en de overloop is op 320, 375, 390 en 430 pixels nul.

Bewijs: 149 tests, build groen, 932 documenten zonder tekst buiten de kolom, en een scan die de tekst terugleest uit 233 PDF's en 18 Word-bestanden en zoekt op productnaam, sjabloon, template, concept, veldnamen en database-id's. Vijf treffers, alle vijf echte juridische taal: "Notarieel Concept" bij de statuten en het testament, en "concept-content" in de influencerovereenkomst. Bedragen opnieuw door alle negen notaties gehaald, van `4750` tot `1,500,000`, allemaal goed, en de factuur handmatig nagerekend: 4.750,00 plus 21 procent is 997,50, totaal 5.747,50.

### Factuuropmaak, 8 september 2026

Laatste punt van de poort: op de factuur stond het bedrag onder de omschrijving in plaats van in de kolom Bedrag, en de totaalregels braken over twee regels.

Twee oorzaken, allebei in de factuursjabloon zelf en niet in de motor. De omschrijving werd getekend met `addWrappedText` (dat legt een alinea vast) terwijl het bedrag met een geplaatste `doc.text` kwam, dus de recorder kon ze nooit tot één rij koppelen. En de regel werd getekend binnen de nawerking van de grijze kopbalk, waardoor hij het kleine vette kopletterbeeld erfde. Nu staan omschrijving en bedrag als twee geplaatste teksten op dezelfde regel, veertien millimeter onder de kopbalk. De layout breekt de omschrijving netjes af binnen de kolom Omschrijving en het bedrag blijft onder Bedrag staan, ook bij een omschrijving van negen regels.

De totaallabels stonden dertig millimeter voor de bedragkolom. Die afstand wordt omgerekend naar de documentmaat en de tekst wordt in de bodygrootte gezet, dus er bleef tweeëntwintig millimeter over voor "Subtotaal excl. BTW:". Nu vijfentachtig millimeter voor de bedragkolom, wat op tweeënveertig uitkomt. Alle drie de totaalregels passen op één regel, met het eindtotaal vet.

De wijziging zit volledig binnen de tak `templateId === 'factuur'`, dus geen ander sjabloon kan geraakt zijn. Nagemeten: 932 documenten, 233 PDF's en 18 Word-bestanden zonder applicatietekst, dezelfde paginatelling voor alle vijftien gecontroleerde documenten als voor de wijziging, 149 tests, build groen. Het Word-bestand is in Word geopend: één pagina, achtenzeventig woorden, dezelfde uitlijning als de PDF.

De echte factuur uit de app: 4.750,00 plus 21 procent is 997,50, totaal 5.747,50, met De Vries Techniek B.V. als afzender en Bouwgroep Terwijde B.V. als klant.
