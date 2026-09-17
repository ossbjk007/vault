---
type: strategie
date: 2026-09-16
status: ter besluitvorming
tags: [pricing, strategie, unit-economics, kanaal, concurrentie]
project: ZekerWet
---

Commercieel masterplan voor [[ZekerWet]]. Onderzoeksdatum 16 september 2026. Alle externe bronnen op die datum gecontroleerd, alle repo-bevindingen gelezen in de werkkopie van die dag. Dit document beslist niets en wijzigt niets: het legt vast wat waar is, wat de opties zijn en wat er eerst gevalideerd moet worden.

> [!danger] Drie conclusies hieronder zijn achterhaald
> Op 16 september is een bredere verificatieronde gedaan over 38 concurrenten in plaats van drie, vastgelegd in [[pricing-marktonderzoek-2026-09-16]]. Daaruit blijkt dat bevinding 3 ("twee tot vier keer goedkoper dan de markt"), de zin "het goedkoopste onbeperkte aanbod in de Nederlandse markt" in sectie D1, en bevinding 8 ("niemand biedt boekhouders een partnerprogramma") niet kloppen. De markt loopt van 24,75 per jaar bij ZZP Nederland tot 948 per jaar bij Lawsy; DAS vraagt 299 per jaar voor onbeperkt uit 150+ documenten en De ContractenFabriek 199; en VraagHugo verkoopt met Hugo Pro al een adviseurslaag voor 249 per jaar. Lees de prijs- en kanaalsecties van dit document naast dat onderzoek. Alle bevindingen over de code zijn wel opnieuw bevestigd.

Bronlabels door het hele document: **[REPO]** gemeten in de code, **[VAULT]** uit bestaande notities, **[BRON]** externe bron met datum, **[HYPOTHESE]** nog niet gevalideerd, **[REDENERING]** mijn eigen afleiding.

---

## A. Executive summary

Tien bevindingen. De eerste vier zijn de belangrijkste.

**1. De prijsladder van [[ZekerWet]] bestaat niet in de code.** `src/lib/access.ts:32` geeft iedere geldige abonnee toegang tot alle 233 documenten, ongeacht plan. De commentaarregel zegt het zelf: "subscribers get unlimited access to all docs". Het enige verschil dat werkelijk wordt afgedwongen tussen Essential, Business en Enterprise is het aantal AI-reviews en het tokenbudget. Alles wat de prijspagina als planverschil verkoopt (RI&E Engine, DPA, Algemene Voorwaarden, NIS2, multi-user) is tekst zonder technische grens. **[REPO]**

**2. De enige echte grendel kost bijna niets.** Een AI-review kost in het slechtste geval ongeveer zes tiende eurocent. De hele prijsladder rust dus op het kunstmatig schaars maken van iets dat gratis is. Essential mag één review per maand; die grendel beschermt tegen een kostenpost van minder dan een cent, en kost vrijwel zeker meer aan gederfde gewenning dan hij oplevert. **[REPO]**

**3. [[ZekerWet]] is twee tot vier keer goedkoper dan de Nederlandse markt voor hetzelfde.** Onbeperkt documenten kost bij Legalflow 49 euro per maand exclusief BTW, bij Lawsy 79 euro exclusief BTW, en bij [[ZekerWet]] 24,99 inclusief BTW, dus 20,65 exclusief. Met 233 templates tegenover ruim 100 bij Legalflow en vijf bij Lawsy. Dat is geen scherpe prijs maar een signaal. **[BRON]**

**4. Marge is het probleem niet.** De contributiemarge ligt op elk plan boven de 90 procent. Geen enkel plan kan verliesgevend worden, ook niet bij een extreme gebruiker. De rem op groei is acquisitie, niet economie. Elke discussie over prijs moet daarom gaan over positionering en segmentatie, niet over kostendekking. **[REPO]**

**5. Rocket Lawyer Nederland stopt op 31 oktober 2026.** Klanten verliezen daarbij de documenten die ze op dat platform hebben gemaakt. Dat is over zes weken, in dezelfde taal, dezelfde markt en dezelfde doelgroep. **[BRON]**

**6. Losse documenten kannibaliseren het abonnement.** Een aankoop van 14,99 geeft permanente, ongelimiteerde toegang tot dat documenttype, voor altijd, zonder verbruik. Wie één opdrachtovereenkomst nodig heeft, heeft nooit een abonnement nodig. Concurrenten vragen 29 tot 59 euro per los document en Legalflow beperkt zijn goedkoopste abonnement tot één contract per maand. **[REPO]** en **[BRON]**

**7. Het boekhouderskanaal is bewezen, deels bezet, en juridisch gevoeliger dan we vanochtend aannamen.** Firm24 heeft ruim 1800 aangesloten advieskantoren en gebruikt een structuur waarin de adviseur zijn eigen fee bovenop de factuur zet. Maar het Reglement Beroepsuitoefening van het Register Belastingadviseurs verbiedt in artikel 15 iedere vergoeding voor het bezorgen van opdrachten, uitdrukkelijk inclusief kortingen en betalingen in natura boven symbolische waarde. Dat raakt de hypothese van vanochtend rechtstreeks. **[BRON]**

**8. Niemand in Nederland biedt boekhouders een partnerprogramma voor doorlopende juridische documenten.** Firm24 dekt oprichting en notarieel werk. Voor het contractwerk dat daarna komt heb ik geen kanaalaanbod gevonden. Dat is de open baan. **[BRON]**

**9. Een kwart van de catalogus verkoopt aan een particulier, niet aan een ondernemer.** 55 van de 233 templates zijn echtscheidingsconvenant, levenstestament, bezwaar WOZ, huurcontract woonruimte, klacht bij een webshop en dergelijke. Die zitten nu in een zakelijk abonnement van 24,99 per maand, waar ze nooit als abonnement gekocht worden. **[REPO]**

**10. De proefperiode is de zwaarste in de markt bij het zwakste merk.** [[ZekerWet]] vraagt een betaalmiddel voor veertien dagen en drie documenten. Lawsy geeft het eerste document gratis zonder creditcard, Ligo geeft het eerste document gratis. Met drie pagina's in Google en zeventig bezoekers per maand is een betaalmuur vooraf de duurste keuze die er is. **[REPO]**, **[BRON]** en **[VAULT]**

**Correctie op de vault.** `Intelligence/competitors/ZekerWet-concurrenten.md` zegt dat [[ZekerWet]] "als enige een AI document review aanbiedt" en noemt Ligo's documentprijs van 59 euro. Beide kloppen niet meer. Lawsy verkoopt juristencontrole als losse dienst vanaf 99 euro, MKB Juristen heeft een eigen ContractCheck, en Ligo toont op de prijspagina van 16 september 2026 geen losse documentprijs meer maar alleen plannen. De oude notitie stuurt op een voorsprong die er niet meer is.

---

## B. Current state

### B1. Wat een klant vandaag daadwerkelijk krijgt

**Documentgeneratie is geen AI.** Dit is de belangrijkste correctie op het eigen verhaal. `Context/business.md` noemt [[ZekerWet]] een "online AI-automatiseringsplatform voor juridische documenten". In de code is generatie deterministisch: een vragenlijst in `src/lib/questions.ts` voedt een sjabloon in `src/lib/pdf-service.ts` en levert een PDF. Er komt geen model aan te pas. Er zijn precies twee AI-routes in de hele applicatie: `/api/ai/extract` (tekst uit een geuploade PDF of DOCX halen, raakt Gemini niet) en `/api/ai/review` (het geuploade document laten beoordelen). **[REPO]**

Dat is geen gebrek, het is een sterkte die verkeerd wordt verkocht. Een deterministisch sjabloon is voorspelbaar, toetsbaar en herhaalbaar; een gegenereerd contract is dat niet. Maar het betekent wel dat "AI-automatiseringsplatform" de lading niet dekt, en dat de echte AI-functie ondergesneeuwd is onder een claim die iets anders belooft.

| Onderdeel | Wat het werkelijk is | Waar |
|---|---|---|
| 233 documenttypes | Deterministische sjablonen met vragenlijst | `DOCUMENT_TYPES`, `questions.ts`, `pdf-service.ts` |
| AI Document Review | Gemini flash-lite, JSON met score 1 tot 10, bevindingen, ontbrekende artikelen | `src/lib/gemini.ts` |
| Passage-matching | Exacte of witruimte-ongevoelige match, nooit fuzzy | `src/lib/passage-match.ts` |
| Upload-extractie | pdfjs en mammoth, geen model | `/api/ai/extract` |
| Juridische kluis | Documenten blijven in het account staan | Prisma-datamodel |
| Multi-user management | Niet gevonden in de code | geen implementatie |
| RI&E, NIS2, DPA | Gewone documenttypes, voor iedere abonnee bereikbaar | `access.ts:32` |

De AI-review is inhoudelijk het sterkste en meest onderscheidende deel van het product. Hij is gehard tegen prompt-injectie, heeft een tokenbudget per gebruiker, een globale dag- en maandrem op uitgaven, een idempotency-sleutel en rate limiting. De passage-matching weigert liever te matchen dan over de verkeerde zin heen te schrijven. Dat is degelijker gebouwd dan de propositie suggereert. **[REPO]** en **[VAULT]**

### B2. Marketingclaims tegenover functionaliteit

`marketing/data/claims.json` is streng en dat werkt. "230+ templates" wordt bij elke validatierun machinaal geteld tegen `DOCUMENT_TYPES.length === 233`. "Waterdicht", "gegarandeerd rechtsgeldig", "vervangt een advocaat" en "juridisch advies" staan op de verbodslijst. **[REPO]**

Vier claims verdienen toch aandacht:

| Claim | Status | Oordeel |
|---|---|---|
| "AI-automatiseringsplatform" (`business.md`) | Interne positionering | Te sterk. Generatie is sjabloonwerk, AI zit alleen in de review |
| "Ingebouwde AI-vraagbaak" (`business.md`) | Interne positionering | Niet gevonden in de code. De Copilot is de reviewwerkruimte, geen vraagbaak |
| "Juridisch waterdicht" in de meta-description van de homepage | Live | Staat op de verbodslijst van `claims.json`. [[Ali Can]] laat dit bewust staan, vastgelegd 14 september |
| "Getoetst aan Nederlands recht, klaar voor jurist-review" | Goedgekeurd | Correct gehedged, de gekoppelde formulering is verplicht |

De eerste twee staan in de vault, niet op de site. Ze sturen wel elke tekst die vanuit de vault wordt geschreven, dus ze horen gecorrigeerd te worden.

### B3. Prijzen en pakketten zoals ze nu zijn

Alle bedragen zijn wat de klant betaalt. Stripe kent geen `automatic_tax`, geen `tax_behavior` en geen `tax_rates`, dus het bedrag is het eindbedrag en de 21 procent BTW komt eruit, niet erbovenop. Bewuste beslissing uit het BTW-spoor van 9 september. **[REPO]** en **[VAULT]**

| Plan | Per maand | Per jaar | Netto per maand | AI-reviews | Tokenbudget | Documenten |
|---|---|---|---|---|---|---|
| Essential | 24,99 | 19,99 (239,88) | 20,65 | 1 | 30.000 | alle 233 |
| Business | 49,99 | 39,99 (479,88) | 41,31 | 10 | 200.000 | alle 233 |
| Enterprise | 199,99 | 159,99 (1.919,88) | 165,28 | onbeperkt | 5.000.000 | alle 233 |

Losse documenten, eveneens inclusief BTW: Basis 14,99 (89 documenten), Standaard 24,99 (84), Professioneel 49,99 (53), Specialist 129,99 (7). **[REPO]**

Proefperiode: veertien dagen, alleen op Essential, maximaal drie documenten, eenmalig per gebruiker via `hasUsedTrial`, met betaalmiddel vooraf omdat het via een gewone Stripe-checkoutsessie loopt. Betaalmethoden kaart en iDEAL. Geen `allow_promotion_codes`, dus kortingscodes zijn technisch nu niet mogelijk. Gasten kunnen afrekenen zonder account. **[REPO]**

### B4. Waar het geld vandaan komt vandaag

Eén betalende klant: [[Yvonne Heiligers]], Business, 49,99 per maand sinds 4 september 2026. Zij heeft in twaalf dagen één document gegenereerd en nul AI-reviews gedraaid. **[VAULT]**

Dat laatste is commercieel het meest verontrustende feit in dit document. Zij betaalt 25 euro per maand boven Essential, en het enige dat Business technisch toevoegt zijn negen extra AI-reviews die zij niet gebruikt. Ontdekt ze dat, dan downgradet ze. Ontdekt ze het niet maar gebruikt ze ook niets, dan zegt ze op. In beide gevallen is de oorzaak dezelfde: er is geen reden aanwezig om terug te komen. **[REDENERING]**

---

## C. Market and competitor research

Alle prijzen gecontroleerd op 16 september 2026. Waar een prijs niet publiek stond, staat dat erbij.

### C1. Direct vergelijkbaar: onbeperkt documenten via abonnement

| Aanbieder | Instap | Onbeperkt | BTW | Templates | Gratis | Bijzonder |
|---|---|---|---|---|---|---|
| **[[ZekerWet]]** | 24,99 p/m | 24,99 p/m | inclusief | 233 | 14 dagen, 3 docs, betaalmiddel vereist | AI-review inbegrepen |
| **Legalflow** (Legalloyd) | 29 p/m of 299 p/j, 1 contract per maand | 49 p/m of 499 p/j | exclusief | 100+ | nee | Advocatenkantoor erachter, uurwerk apart |
| **Lawsy** | 29 p/m, 5 docs per maand | 79 p/m | exclusief | 5 op de prijspagina, 20+ op de bedrijvenpagina | 1 document gratis, geen creditcard | Juristencontrole 99 los, 199 met gesprek |
| **Ligo** | 180 per 3 maanden | 499 per 12 maanden | niet vermeld | 100+ (NL en EN apart geteld) | eerste document gratis | eIDAS Advanced e-signing onbeperkt, BV-oprichting, belastingtips |
| **Rocket Lawyer NL** | circa 39,90 p/m | idem | inclusief | honderden | 7 dagen | **stopt 31 oktober 2026** |

Omgerekend naar inclusief BTW is onbeperkt bij Legalflow 59,29 en bij Lawsy 95,59. [[ZekerWet]] zit op 24,99. **[BRON]**

Bij Ligo staat niet vermeld of de bedragen inclusief BTW zijn. Niet aannemen: openlaten tot iemand het checkout-scherm heeft gezien.

### C2. Wat de concurrentie leert over packaging

**Legalflow knijpt op volume, niet op catalogus.** Het goedkope plan geeft toegang tot alle 100+ contracten maar staat één contract per maand toe, en bewerken mag veertien dagen tegenover negentig dagen op Pro. Dat is een eerlijke, uitlegbare grendel die niets kost om te handhaven en die precies het gedrag beprijst dat waarde vertegenwoordigt: hoe vaker je hem nodig hebt, hoe meer hij waard is. **[BRON]**

**Lawsy monetiseert het bezwaar in plaats van het weg te praten.** Hun juristencontrole kost 99 euro per keer, of 199 met een half uur advies, uitdrukkelijk los van elk abonnement. Precies het bezwaar dat in `Context/icp.md` als checkout-blokkade nummer één staat, "is het wel net zo goed als een echte jurist", is bij hen een omzetregel van 99 euro. Ze werken met 50+ geverifieerde juristen en beloven binnen 24 uur terug. **[BRON]**

Dit is de scherpste les uit het hele onderzoek. [[ZekerWet]] behandelt dat bezwaar nu als iets dat met copy moet worden opgelost. Een concurrent verkoopt het.

**Lawsy bewijst ook dat catalogusbreedte niet de winnende as is.** Vijf documenttypes op de prijspagina, 20+ op de bedrijvenpagina, en 79 euro per maand. Terwijl [[ZekerWet]] met 233 templates 24,99 vraagt. Templatetelling is blijkbaar geen prijsargument in deze markt. Dat betekent niet dat de catalogus waardeloos is; het betekent dat hij niet als getal verkoopt maar als dekking van een specifieke situatie. **[BRON]** en **[REDENERING]**

**Ligo verkoopt geen documenten maar een jaarrelatie.** Geen maandprijs, alleen 499 voor twaalf maanden of 180 voor drie. Daarmee kopen ze retentie vooraf in plaats van hem te moeten verdienen, en het eerste document is gratis om binnen te komen. Hun taalgebruik is bovendien veel steviger dan wat `claims.json` [[ZekerWet]] toestaat: "Opgesteld door advocaten. Zo ben jij verzekerd dat alles juridisch correct is" en "kwaliteit gegarandeerd". Dat is een asymmetrie die geen prijsprobleem is maar een geloofwaardigheidsprobleem: zij mogen dat zeggen omdat er advocaten achter zitten. **[BRON]**

**Rocket Lawyer Nederland verdwijnt per 31 oktober 2026** en de documenten die klanten daar hebben gemaakt zijn daarna niet meer beschikbaar. **[BRON]**

### C3. Naastgelegen aanbod dat de prijsperceptie zet

- **MKB Juristen**: 281 documenten, maar uitdrukkelijk "geen standaard generator". Maatwerk door juristen, offerte per situatie, plus een eigen ContractCheck voor documenten die je al hebt. Zij claimen ongeveer hetzelfde catalogusgetal als [[ZekerWet]] en verkopen het als mensenwerk. **[BRON]**
- **Rechtsbijstandverzekering**: DAS begint voor ZZP rond 22 euro per maand, marktbreed 20 tot 35 euro met modules. Dit is het echte prijsanker in het hoofd van een ZZP'er voor "juridisch geregeld voor een maandbedrag", en het ligt op precies hetzelfde niveau als Essential. Het verschil is dat een verzekering pas werkt als er een conflict is en [[ZekerWet]] werkt voordat het conflict er is. Dat onderscheid wordt nu nergens gemaakt. **[BRON]** en **[REDENERING]**
- **Uurtarieven**: jurist 80 tot 140 per uur, advocaat 175 tot 500 per uur, maatwerkcontract 300 tot 1.500. Dat zijn de bedragen waartegen de besparing wordt afgezet. **[BRON]**

### C4. Het boekhouderskanaal in de markt

**Firm24 Professional en Premium** is het enige volwassen kanaalprogramma dat ik heb gevonden. Ruim 1800 aangesloten advieskantoren, meer dan 7.000 BV-oprichtingen en omzettingen per jaar, 80.668 ondernemers. De adviseur krijgt een gratis account en een eigen omgeving, bepaalt zijn eigen tarief, en de klant ziet alleen zijn eigen kantoor. Twee geldstromen: de adviseur factureert zelf, of hij zet zijn fee bovenop de Firm24-factuur en Firm24 keert die na betaling uit. **[BRON]**

Twee dingen daaraan zijn direct bruikbaar. De structuur die in dit kanaal werkt is een opslag op de eigen factuur voor eigen werk, niet een provisie voor doorverwijzen; dat is geen toeval, zie sectie J. En Firm24 doet oprichting en notarieel werk, niet het doorlopende contractwerk daarna. **[REDENERING]**

**Let op bij de eigen lijst.** OAMKB staat met naamsvermelding als referentie op de Firm24 Professional-pagina, en oamkb Oss aan de Kanaalstraat 12B staat in [[kanaal-boekhouders]]. Dat kantoor kent een partnerprogramma dus al van binnenuit. Dat maakt ze een betere gesprekspartner en een kritischere. **[BRON]**

**Informer** hanteert in ditzelfde kanaal een model dat het overwegen waard is: doet de ondernemer zijn boekhouding zelf, dan betaalt hij het normale tarief en de accountant niets; doet de accountant het volledig, dan betaalt de ondernemer niets en de accountant 7 euro per maand per administratie. Een prijs per klantdossier in plaats van per gebruiker. **[BRON]**

**Ik heb geen Nederlandse aanbieder gevonden die boekhouders een partnerprogramma biedt voor doorlopende juridische documenten.** Een afwezigheid is geen bewijs, maar dit is wel de bruikbaarste afwezigheid in dit onderzoek. **[BRON]** en **[REDENERING]**

---

## D. Pricing analysis

### D1. Waar [[ZekerWet]] staat, netto naast netto

Alles exclusief BTW, zodat de vergelijking eerlijk is.

| Aanbod | Netto per maand | Wat je ervoor krijgt |
|---|---|---|
| ZekerWet Essential | 20,65 | Onbeperkt, 233 templates, 1 AI-review |
| ZekerWet Business | 41,31 | Identiek, 10 AI-reviews |
| Legalflow Start | 29,00 (24,92 bij jaar) | 1 contract per maand, 100+ templates |
| Legalflow Pro | 49,00 (41,58 bij jaar) | Onbeperkt, 100+ templates |
| Lawsy Starter | 29,00 | 5 documenten per maand |
| Lawsy Business | 79,00 | Onbeperkt, 5 gebruikers |
| Ligo jaarplan | 41,58 | Onbeperkt plus e-signing, BTW-status onbekend |
| ZekerWet Enterprise | 165,28 | Identiek aan Essential plus onbeperkte reviews |

**Essential is het goedkoopste onbeperkte aanbod in de Nederlandse markt en tegelijk het breedste.** Dat is geen positie waar je in wilt staan, want de klant leest het andersom: als 233 juridische documenten 20 euro kosten en 100 documenten bij een advocatenkantoor 49 euro, dan zal die van 20 euro wel minder waard zijn. Bij een product waarvan het bezwaar nummer één betrouwbaarheid is, werkt een lage prijs tegen je. **[REDENERING]**

**Enterprise is niet verdedigbaar zoals het nu staat.** 199,99 tegenover 24,99, voor exact dezelfde documenttoegang, met als enige technische verschil een tokenbudget dat in geld ongeveer vijf euro per maand waard is. De genoemde onderscheiders (NIS2- en NEN 7510-modules, multi-user management, priority legal support, dedicated success manager) zijn geen van alle in de code afgedwongen en de laatste twee zijn mensenwerk dat er niet is. Dit plan verkoopt iets dat niet bestaat. **[REPO]**

### D2. De Business-val

Dit is de scherpste structurele fout en hij heeft al een slachtoffer.

Een klant kiest Business voor 49,99 omdat de pagina "Volledige RI&E Engine", "DPA & Verwerkersovereenkomsten" en "Algemene Voorwaarden (B2B/B2C)" onder Business zet. Alle drie zitten in Essential. De klant betaalt dus het dubbele voor negen extra AI-reviews. [[Yvonne Heiligers]] heeft dat gedaan en er nul van gebruikt. **[REPO]** en **[VAULT]**

Twee uitwegen, en ze sluiten elkaar uit. Of de planverschillen worden echt gemaakt, zodat de pagina klopt. Of de tekst wordt eerlijk gemaakt en het verschil wordt ergens anders gelegd. Wat niet kan is het laten staan: de dag dat een klant dit ontdekt is het geen packaging-fout meer maar een terugbetalingsgesprek.

### D3. De losse verkoop lekt

`getPurchasedDocumentTypes` geeft alle documenttypes terug waarvoor een voltooide aankoop bestaat, en `hasAccessTo` checkt lidmaatschap van die lijst. Er is geen verbruik, geen teller, geen vervaldatum. Eén betaling van 14,99 geeft dus permanente, ongelimiteerde generatie van dat documenttype. **[REPO]**

Voor 89 van de 233 documenten is dat 14,99. Een ondernemer die elk kwartaal een nieuwe opdrachtovereenkomst maakt betaalt eenmalig 14,99 en nooit meer iets. De abonnementsprijs van 24,99 per maand is daarmee voor het grootste deel van de catalogus een slechtere deal dan de losse aankoop, tenzij je meer dan twee verschillende documenttypes per jaar nodig hebt.

Ter vergelijking: bij Lawsy kost één document 49 exclusief BTW en dat is één document, niet een documenttype voor het leven. Bij Legalflow kost het goedkoopste abonnement 29 per maand voor één contract per maand. **[BRON]**

### D4. Prijspsychologie

Wat de markt doet en [[ZekerWet]] niet:

- **Anker op het alternatief.** Lawsy zet "tot 80% goedkoper" en "in plaats van honderden euro's advocaatkosten" direct naast de prijs. [[ZekerWet]] noemt de prijs zonder anker. **[BRON]**
- **Jaar als standaard.** Ligo verkoopt alleen per jaar of per kwartaal. Legalflow zet 14 procent korting op jaarbetaling, Lawsy twee maanden gratis. [[ZekerWet]] geeft 20 procent op jaar (19,99 tegenover 24,99) maar presenteert maand als de norm. **[BRON]** en **[REPO]**
- **Gratis als instap, niet als proef.** Lawsy en Ligo geven een echt document weg. [[ZekerWet]] geeft veertien dagen mits je een betaalmiddel afgeeft. **[BRON]** en **[REPO]**

---

## E. Unit economics

### E1. Wat AI werkelijk kost

Gemeten uit de configuratie, niet geschat.

`gemini-flash-lite-latest` resolveert naar gemini-3.5-flash-lite en kost 0,30 dollar per miljoen invoertokens en 2,50 dollar per miljoen uitvoertokens. Dat is op 16 september 2026 geverifieerd tegen de prijslijst van Google en komt overeen met wat `src/lib/cost-meter.ts` hanteert: 0,28 euro en 2,34 euro per miljoen, bewust naar boven afgerond. **[REPO]** en **[BRON]**

Harde grenzen per review: invoer maximaal 15.000 tekens, ongeveer 3.750 tokens. Uitvoer maximaal 2.048 tokens. **[REPO]**

Kosten van één review in het absolute slechtste geval:

- invoer 3.750 × 0,28 / 1.000.000 = 0,00105 euro
- uitvoer 2.048 × 2,34 / 1.000.000 = 0,00479 euro
- **totaal 0,0058 euro, dus ruim een halve eurocent**

| Plan | Reviews | Tokenbudget | AI-kosten per maand, worst case |
|---|---|---|---|
| Essential | 1 | 30.000 | 0,006 |
| Business | 10 | 200.000 | 0,058 |
| Enterprise | onbeperkt | 5.000.000 | tussen 5,00 en 11,70 |

De bandbreedte bij Enterprise ontstaat doordat 5 miljoen tokens theoretisch allemaal uitvoer kunnen zijn (11,70 euro), terwijl een echte review ongeveer 3.750 invoer en 2.048 uitvoer is, wat neerkomt op ongeveer 862 reviews voor 5,00 euro. Beide getallen zijn verwaarloosbaar tegenover 165,28 netto omzet. **[REPO]** en **[REDENERING]**

Boven op de individuele budgetten zit een platformrem: standaard 5 euro per dag en 150 euro per maand, instelbaar via `AI_DAILY_CAP_EUR_CENTS` en `AI_MONTHLY_CAP_EUR_CENTS`. Een bug kan dus maximaal 150 euro per maand kosten. **[REPO]**

> [!check] De conclusie die alles verandert
> Er bestaat geen abonnement dat verliesgevend kan worden door AI-gebruik. Zelfs een gebruiker die elke dag het maximum aan reviews draait op Enterprise kost minder dan twaalf euro per maand tegenover 165 euro netto omzet. De AI-limieten in `src/config/ai.ts` beschermen dus geen marge. Ze zijn een packaging-keuze die als kostenbescherming is vermomd, en dat is een dure vergissing: de enige functie die [[ZekerWet]] écht onderscheidt is ook de functie die het strengst gerantsoeneerd wordt.

### E2. Betaalkosten

Stripe Nederland, gecontroleerd 16 september 2026: Europese kaarten 1,5 procent plus 0,25 euro, iDEAL 0,29 euro vast, SEPA-incasso 0,35 euro met een maximum van 5 euro. Geen vaste maandkosten. **[BRON]**

### E3. Contributiemarge per plan

Per maand, in euro. BTW eruit gedeeld door 1,21. Stripe gerekend over het brutobedrag, want daarover rekent Stripe.

| | Essential | Business | Enterprise | Document Basis |
|---|---|---|---|---|
| Bruto | 24,99 | 49,99 | 199,99 | 14,99 |
| BTW af (21%) | −4,34 | −8,68 | −34,71 | −2,60 |
| **Netto omzet** | **20,65** | **41,31** | **165,28** | **12,39** |
| Stripe kaart | −0,62 | −1,00 | −3,25 | −0,47 |
| AI worst case | −0,01 | −0,06 | −11,70 | 0,00 |
| **Contributiemarge** | **20,02** | **40,25** | **150,33** | **11,92** |
| **Marge %** | **97%** | **97%** | **91%** | **96%** |

Bij iDEAL in plaats van kaart is de marge nog iets hoger, want 0,29 vast in plaats van 0,62. **[REPO]**, **[BRON]** en **[REDENERING]**

### E4. Vaste kosten en wat we niet weten

| Post | Status | Hoe te meten |
|---|---|---|
| Vercel | Hobby, 0 euro | Zie de waarschuwing hieronder |
| Clerk | Hobby, 0 euro, logbewaring 1 dag | Clerk-dashboard, prijsstaffel bij groei |
| Gemini | Pay as you go, verwaarloosbaar | Google AI Studio, maandfactuur |
| Database en Redis | **onbekend** | Provider en plan nakijken in de Vercel-omgevingsvariabelen |
| Resend (e-mail) | **onbekend** | Resend-dashboard, gratis staffel en tarief daarboven |
| Sentry | **onbekend** | Sentry-dashboard |
| CAC | **onbekend en niet te schatten** | Eerst één kanaal met attributie draaien, zie sectie K |
| Retentie en churn | **onbekend, n=1** | Meetbaar vanaf ongeveer 20 klanten en drie maanden |
| Conversie bezoeker naar klant | **onbekend** | Vercel Analytics naast Stripe, vanaf ongeveer 500 bezoekers per maand |

> [!danger] Vercel Hobby staat commercieel gebruik niet toe
> De Vercel-documentatie bij het Hobby-plan zegt letterlijk: "As stated in the fair use guidelines, the Hobby plan restricts users to non-commercial, personal use only." Gecontroleerd op 16 september 2026. [[ZekerWet]] draait een betalend product met een betalende klant op dat plan. Dat is geen kostenpost maar een continuïteitsrisico: een gepauzeerd account betekent een offline product en een klant die haar abonnement niet kan gebruiken. Pro kost 20 dollar per maand. Dat bedrag is één procent van het doel van 15.000 en het staat nu tussen [[ZekerWet]] en een platformschending.

Vier van de negen kostenposten zijn onbekend. Dat is acceptabel omdat ze allemaal klein zijn ten opzichte van 97 procent marge, maar het betekent wel dat elke uitspraak over winst voorlopig een uitspraak over contributiemarge is en niet over nettowinst.

---

## F. Pricing scenarios

Vijf scenario's. Geen winnaar aangewezen; wel per scenario wat het doet en wat het kost. Geen enkele conversiecijfer in deze sectie is verzonnen: waar een effect onbekend is, staat de richting en niet een getal.

### Scenario A. Huidige structuur eerlijk maken

De drie plannen blijven, maar de featurelijst wordt in lijn gebracht met wat de code doet en de AI-limieten gaan omhoog omdat ze niets kosten.

- Essential 24,99: alle 233 documenten, 5 AI-reviews
- Business 49,99: alle documenten, 25 reviews, plus iets dat echt bestaat
- Enterprise: schrappen of pas terugbrengen als multi-user gebouwd is

**Doel per tier**: Essential is het product, Business is er voor wie meer reviewt.
**Voordeel**: goedkoopst te bouwen, heft de Business-val op, verwijdert een claim die niet waargemaakt wordt.
**Risico**: het onderliggende probleem blijft. Er is dan één product met twee prijzen en geen reden om de hoge te kiezen.
**Kannibalisatie**: onveranderd, de losse verkoop blijft lekken.
**Conversie**: waarschijnlijk licht positief, want de pagina wordt eerlijker en simpeler.
**ARPU**: omlaag, want Business heeft geen argument meer.
**Retentie**: omhoog, want geen ontdekkingsmoment meer.
**AI-kosten**: van bijna nul naar iets minder bijna nul.
**Complexiteit**: laag. Tekst in `PLAN_TIERS` en getallen in `AI_LIMITS`.

### Scenario B. Volume als grendel, naar het Legalflow-model

De as wordt het aantal documenten per maand, niet welke documenten.

- Gratis: 1 document, geen betaalmiddel, permanent
- Solo: 1 document per maand
- Business: onbeperkt, meer reviews
- Losse aankoop: één generatie in plaats van levenslange toegang

**Doel per tier**: gratis is acquisitie, Solo vangt de incidentele ZZP'er, Business vangt wie het echt gebruikt.
**Voordeel**: de grendel is uitlegbaar en sluit aan bij ervaren waarde. Het is bewezen in deze markt.
**Risico**: een documentlimiet voelt krenterig bij een product waarvan de marginale kosten nul zijn, en een klant die halverwege de maand vastloopt is een boze klant.
**Kannibalisatie**: sterk verminderd, mits de losse aankoop van levenslang naar eenmalig gaat.
**Conversie**: waarschijnlijk duidelijk positief aan de voorkant, want de betaalmuur bij de proef verdwijnt.
**ARPU**: omhoog, want wie meer gebruikt betaalt meer.
**Retentie**: onzeker. Limieten geven zowel upgrades als opzeggingen.
**AI-kosten**: verwaarloosbaar.
**Complexiteit**: middel. Er moet een maandelijkse teller per gebruiker komen en de aankooplogica in `access.ts` moet om.

### Scenario C. Free naar Essential naar Business naar Enterprise

Een echte gratis laag onderaan, en de tiers gaan differentiëren op documentcategorie in plaats van op AI.

- Gratis: de basisbrieven (89 stuks), onbeperkt, met watermerk of zonder kluis
- Essential: alles behalve arbeidsrecht en vennootschapsrecht
- Business: alles, inclusief personeel en aandeelhouders
- Enterprise: alles plus meerdere gebruikers, als dat gebouwd is

**Doel per tier**: gratis is SEO-brandstof, Essential is ZZP, Business is werkgever, Enterprise is organisatie.
**Voordeel**: de tiers gaan eindelijk over risico. Een ontslagbrief fout doen kost duizenden euro's, een aanmaning fout doen kost niets. Dat rechtvaardigt een prijsverschil op een manier die AI-reviews nooit kunnen.
**Risico**: je geeft 89 documenten weg, waaronder vrijwel alle particuliere documenten. En het is de grootste bouwklus.
**Kannibalisatie**: de gratis laag eet de Basis-losverkoop van 14,99 volledig op. Dat is bewust: die verkoopt nu toch bijna niets en kost wel een betaalmuur op je beste SEO-pagina's.
**Conversie**: sterk positief bovenin de trechter, en het lost het indexeringsprobleem uit [[seo-indexering-2026-09-14]] deels op, want gratis pagina's met echte output zijn beter linkbaar.
**ARPU**: omhoog bij wie betaalt, omlaag gemiddeld over alle gebruikers.
**Retentie**: omhoog, want de gratis laag houdt mensen in het product.
**AI-kosten**: iets hoger door meer gebruikers, blijft verwaarloosbaar.
**Complexiteit**: hoog. Er moet een categorie per document komen en `access.ts` moet per plan gaan beslissen.

### Scenario D. Credits naast abonnement

Een abonnement voor de basis, credits voor het zware werk (juristencontrole, specialistische documenten).

**Doel per tier**: het abonnement is de relatie, credits vangen piekbehoefte en hoge betalingsbereidheid.
**Voordeel**: dit is het enige scenario waarin het checkout-bezwaar zelf omzet wordt, zoals Lawsy doet met 99 euro per juristencontrole.
**Risico**: en dit is het zwaarste risico in dit document: dit vereist een jurist. [[ZekerWet]] heeft er geen. Lawsy heeft er 50+. Zonder jurist is dit scenario niet uitvoerbaar, en met een jurist verandert het kostenmodel van 97 procent marge naar een marge die afhangt van een uurtarief.
**Kannibalisatie**: laag, credits liggen naast het abonnement.
**Conversie**: positief op de checkout, want er is eindelijk een antwoord op het bezwaar dat niet uit copy bestaat.
**ARPU**: sterk omhoog bij wie het afneemt.
**AI-kosten**: verwaarloosbaar, de kosten zitten in mensen.
**Complexiteit**: hoog, en grotendeels niet technisch.

### Scenario E. Partnerlaag naast de consumentenprijzen

De drie bestaande plannen blijven staan voor directe klanten. Daarnaast komt er een kantoorlaag.

- Kantoorlicentie: een vast bedrag per maand voor het kantoor zelf, met een eigen omgeving
- Per klantdossier: een bedrag per maand per klant die het kantoor aansluit, naar het Informer-model
- Doorverkoop: het kantoor zet zijn eigen fee bovenop, naar het Firm24-model

**Doel per tier**: dit is geen tier maar een tweede kanaal met een eigen prijs.
**Voordeel**: het is het enige scenario dat het bereikprobleem aanpakt in plaats van het marge-probleem dat er niet is. Eén kantoor is tientallen ondernemers.
**Risico**: het beroepsrecht, zie sectie J. En een kantoor dat afhaakt neemt in één klap zijn hele klantenbestand mee.
**Kannibalisatie**: reëel. Een ondernemer die via zijn boekhouder instroomt tegen kantoorkorting was misschien ook direct binnengekomen tegen vol tarief. Bij 70 bezoekers per maand is dat nu een theoretisch risico.
**Conversie**: onbekend en niet te schatten. Nul gesprekken gevoerd.
**ARPU**: per eindklant lager, per kantoor veel hoger.
**Complexiteit**: hoog als het white label wordt, laag als het begint als een gewone link met korting.

### F1. Hoe deze scenario's zich verhouden

Ze sluiten elkaar grotendeels niet uit. A is een opruiming die onder elk ander scenario toch moet gebeuren. B en C zijn alternatieve antwoorden op dezelfde vraag (waar leg je de grendel) en kunnen niet allebei. D en E zijn uitbreidingen die bovenop A plus B of A plus C komen.

De volgorde die daaruit volgt, en dit is een aanbeveling en geen besluit: A is geen keuze maar onderhoud, want de huidige pagina belooft iets dat de code niet doet. Daarna is de echte strategische keuze B tegenover C, en die keuze hangt aan de vraag uit sectie G. D vereist een jurist en hoort daarom pas op de rol als er omzet is om er een te betalen. E is het enige spoor dat aan het werkelijke knelpunt raakt en is daarom het meest urgent om te valideren, ook al is het het minst zeker. **[REDENERING]**

---

## F2. Terugrekenen vanaf 15.000 euro per maand

Dit is geen voorspelling en geen belofte. Het is rekenwerk in één richting: als de gemiddelde omzet per klant X is, dan zijn er Y klanten nodig. Niets hier zegt iets over hoe waarschijnlijk dat is.

### Eerst: bruto of netto

`Context/strategy.md` noemt 15.000 tot 20.000 euro maandelijkse omzet met deadline augustus 2027. Er staat niet bij of dat inclusief of exclusief BTW is. Dat scheelt 17,4 procent en dus honderd klanten of meer. Beide kolommen staan hieronder; **[[Ali Can]] moet zeggen welke geldt.**

### Bij de huidige prijzen

| Mix | Aantal voor 15.000 bruto | Aantal voor 15.000 netto (excl. BTW) |
|---|---|---|
| Alleen Essential (24,99) | 601 | 727 |
| Alleen Business (49,99) | 301 | 364 |
| Alleen Enterprise (199,99) | 76 | 91 |
| 70% Essential, 30% Business (ARPU 32,49) | 462 | 559 |
| 50/50 Essential en Business (ARPU 37,49) | 401 | 485 |

### Vier klantmixen, uitgeschreven

Elke mix is een manier om bij 15.000 bruto uit te komen. Ze verschillen in wat je ervoor moet kunnen.

**Mix 1, volume op de laagste prijs.** 600 Essential-klanten. Dat is elke maand ongeveer 25 nieuwe betalende klanten erbij, twee jaar lang, bij nul churn. Vandaag: 1 klant, 70 bezoekers per maand, 3 geïndexeerde pagina's. Dit vraagt een verkeersgroei van ruim twee ordes van grootte.

**Mix 2, minder klanten tegen een hogere prijs.** 300 Business-klanten, of ongeveer 200 klanten als de prijs naar het marktniveau van Legalflow gaat (49 exclusief BTW, dus 59,29 inclusief). Dan zijn er 253 klanten nodig voor 15.000 bruto. Hetzelfde doel bij minder dan de helft van het aantal klanten uit mix 1.

**Mix 3, gemengd met losse verkoop.** 250 Business-klanten is 12.498 per maand. De resterende 2.502 uit losse documenten is bij een gemiddelde van 24,99 ongeveer 100 losse verkopen per maand. Losse verkoop is echter eenmalig: die 100 moeten elke maand opnieuw. Dat maakt dit de minst stabiele mix en meteen het argument waarom losse verkoop een instapkanaal hoort te zijn en geen omzetpijler.

**Mix 4, via kantoren.** Stel een kantoor levert tien betalende eindklanten op Business. Dan is één kantoor 500 euro bruto per maand en zijn er 30 kantoren nodig. Dat is exact de lijst die nu in [[kanaal-boekhouders]] staat. Levert een kantoor er twintig, dan zijn het er vijftien. Levert een kantoor er drie, dan zijn er honderd kantoren nodig en is de regio te klein.

**Wat deze tabel werkelijk laat zien.** Het getal dat er het meest toe doet is niet het aantal klanten maar de opbrengst per kantoor. Bij tien eindklanten per kantoor is het doel haalbaar binnen de dertig kantoren die al in kaart zijn. Bij drie is het dat niet, en dan moet er een ander kanaal bij. Dat ene getal is op dit moment volstrekt onbekend en het is precies wat de pilot uit sectie L moet meten. Alles in mix 4 staat of valt daarmee.

### Wat dit rekenwerk niet zegt

Het zegt niets over churn, want die is onbekend bij één klant. Het zegt niets over hoe lang het duurt, want daarvoor is een conversiecijfer nodig dat er niet is. En het zegt niets over of 15.000 het juiste doel is. Wat het wel laat zien: bij de huidige prijs van 24,99 zijn er zes- tot zevenhonderd klanten nodig, en bij marktconforme prijzen de helft. Dat is het sterkste argument in dit hele document voor het serieus nemen van de pricingvraag, los van de kanaalvraag. **[REDENERING]**

---

## G. Document sales tegenover subscriptions

### G1. De vraag onder de vraag

De catalogus bedient twee markten die nu één prijslijst delen.

**178 documenten zijn zakelijk**: arbeidscontracten, algemene voorwaarden, verwerkersovereenkomsten, aandeelhoudersbesluiten, opdrachtovereenkomsten, huurcontracten bedrijfsruimte. Een ondernemer heeft die herhaaldelijk nodig. Abonnement past.

**55 documenten zijn particulier of werknemerskant**: echtscheidingsconvenant, ouderschapsplan, levenstestament, euthanasieverklaring, bezwaar WOZ, huurcontract woonruimte, klacht over een webshop, vergoeding voor een vertraagde vlucht, aansprakelijkstelling na een aanrijding. Die heeft iemand één keer in zijn leven nodig. Een abonnement past daar niet en zal daar ook nooit op passen. **[REPO]**

Die 55 zitten nu achter een zakelijke prijspagina die 24,99 per maand vraagt. Dat is niet alleen een gemiste verkoop; het is ook waarom die pagina's geen zoekverkeer trekken dat converteert. Iemand die zoekt op "bezwaar WOZ voorbeeldbrief" is geen MKB-lead.

### G2. Drie manieren om daarmee om te gaan

| Route | Wat het betekent | Voor | Tegen |
|---|---|---|---|
| **Splitsen** | De 55 particuliere documenten krijgen een eigen ingang, alleen losse verkoop, eigen SEO | Zuivere positionering per markt, twee verschillende koopmomenten goed bediend | Twee proposities onderhouden met één persoon |
| **Weglaten** | De 55 uit de catalogus halen | Scherpste B2B-verhaal, kleinste onderhoudslast | Je gooit 24 procent van je SEO-oppervlak weg terwijl je maar drie pagina's geïndexeerd hebt |
| **Laten staan, anders beprijzen** | Blijven waar ze zijn, maar losse verkoop wordt de primaire route en het abonnement wordt niet aangeprezen op die pagina's | Geen bouwwerk, wel een schoner koopmoment | Het positioneringsprobleem blijft half staan |

Mijn oordeel: weglaten is de slechtste van de drie. Met drie geïndexeerde pagina's is zoekoppervlak het schaarste bezit dat er is, en juist particuliere documenten hebben hoog zoekvolume en lage concurrentie. **[REDENERING]**

### G3. De lek in de losse verkoop dichten

Ongeacht welke route: eenmalig betalen voor levenslange onbeperkte generatie van een documenttype is geen prijsmodel maar een weglek. Drie mogelijke correcties, oplopend in hardheid:

1. **Eén generatie per aankoop.** Wat de klant verwacht als hij "koop dit document" leest. Sluit aan bij Lawsy, waar 49 euro één document is.
2. **Een venster.** Aankoop geeft 30 of 90 dagen onbeperkt bewerken van dat type, zoals Legalflow 14 en 90 dagen hanteert. Vriendelijker, want herstel van een typefout blijft gratis.
3. **Laten zoals het is en de prijs erop aanpassen.** Als levenslange toegang het aanbod is, dan is 14,99 te laag; dan hoort daar eerder 39 tot 49 bij, in lijn met Lawsy en Ligo.

Optie 2 is de beste balans tussen eerlijkheid en klantvriendelijkheid, maar dit is een besluit voor [[Ali Can]] en niet voor mij. **[REDENERING]**

### G4. De ontbrekende brug

Er is nu geen route van losse koper naar abonnee. Wie 14,99 betaalt voor een aanmaning krijgt daarna nergens het aanbod om dat bedrag te verrekenen met een abonnement. De enige upgrade-prompts in de app zitten op de proefperiode-limiet. **[REPO]**

De standaardoplossing is verrekening: de eerste losse aankoop wordt binnen 30 dagen in mindering gebracht op het eerste abonnementsbedrag. Dat kost technisch een kortingscode, en die kan nu niet, want `allow_promotion_codes` staat niet aan in de checkoutsessie.

---

## H. Accountant- en boekhouderskanaal

Deze sectie bouwt voort op [[kanaal-boekhouders]] en corrigeert dat document op één belangrijk punt.

### H1. Waarom dit kanaal

70 bezoekers per maand en één klant. Eén kantoor heeft tientallen tot honderden ondernemers als klant. Dit is het enige kanaal in beeld waar één gesprek meer bereik oplevert dan een maand posten. **[VAULT]** en **[REDENERING]**

### H2. Wat er is veranderd sinds vanochtend

**De hypothese van vanochtend is juridisch fragiel.** In [[kanaal-boekhouders]] staat als voorstel: gratis Business-account voor het kantoor, korting voor hun klanten, geen commissie. De redenering was dat commissie riskant is en een gratis account niet. Het onderzoek laat zien dat dat andersom kan liggen. Artikel 15 van het Reglement Beroepsuitoefening van het Register Belastingadviseurs luidt: "Het is een lid niet toegestaan vergoedingen in enige vorm te geven of te ontvangen voor het bezorgen van opdrachten, tenzij het een vergoeding betreft voor het overnemen of overdragen van een praktijk of een gedeelte daarvan." De toelichting maakt het scherper: "Onder vergoedingen worden niet alleen betalingen in geld verstaan, maar ook bijvoorbeeld giften, invitaties, kortingen, betalingen in natura, enz. van meer dan symbolische waarde." Een gratis Business-account is 600 euro per jaar aan waarde. Dat is geen symbolisch relatiegeschenk. Als het wordt gegeven omdat het kantoor klanten aanbrengt, valt het onder dezelfde bepaling als een provisie.

De uitweg is geen truc maar een echt onderscheid: de vergoeding mag niet hangen aan het aanbrengen van opdrachten. Een kantoor dat [[ZekerWet]] gebruikt vóór zijn eigen praktijk en daarvoor betaalt of gratis test, doet een normale softwareaankoop. Een kantoor dat een gratis account krijgt als beloning voor doorverwijzingen, doet iets anders. Het verschil zit in de koppeling, niet in het bedrag. **[REDENERING]**

Volledige uitwerking van het beroepsrechtelijke beeld staat in sectie J.

### H3. Wat een kantoor eraan heeft

Drie dingen, in deze volgorde. Dit is nog steeds hypothese en sectie I is er om het te toetsen.

1. **Niet hoeven zeggen "daar kan ik je niet mee helpen."** Een boekhouder krijgt in 2026 vragen over schijnzelfstandigheid en modelovereenkomsten en mag daar geen juridisch advies over geven. Nu verwijst hij naar een jurist en is hij dat stuk van de klant kwijt. **[HYPOTHESE]**
2. **Geen aansprakelijkheid erbij.** Verwijzen naar een tool is iets anders dan zelf een contract beoordelen. Dit moet expliciet in het aanbod staan, anders is het het eerste bezwaar. **[HYPOTHESE]**
3. **Iets om weg te geven.** Een kantoor dat zijn klanten een werkende oplossing aanreikt ziet er beter uit zonder een uur te werken. **[HYPOTHESE]**

### H4. De markt in de regio

Dertig kantoren in Oss, Rosmalen, Den Bosch, Uden en Veghel, met adres, in [[kanaal-boekhouders]]. Steekproef via Google Maps, geen KVK-telling; de werkelijke aantallen liggen hoger en Nijmegen, Wijchen, Grave, Cuijk, Heesch en Schaijk zijn nog niet gedaan. Het aantal kantoren is de beperking niet. **[VAULT]**

### H5. Het warme contact

[[Ali Can]] kent de eigenaren van een boekhoudkantoor in Rosmalen persoonlijk uit een dienstverband dat is geëindigd na langdurige ziekte, met een vertrekregeling. De relatie is nog benaderbaar.

Strategisch oordeel, en verder gaat dit document daar niet op in: dit contact is geschikt voor een laagdrempelig diagnosegesprek en niet voor een salespitch. Twee redenen. Een aanbod als eerste contact zet [[Ali Can]] in de vragende positie, wat een nee waarschijnlijker maakt. En het verspilt wat dit contact werkelijk waard is, namelijk dat hij een jaar van binnenuit heeft gezien hoe zo'n kantoor werkt en toegang heeft tot mensen die hem vakinhoudelijk serieus nemen. Dit is het enige adres waar hypothese H3 kan worden getoetst zonder eerst vertrouwen te moeten kopen. **[REDENERING]**

---

## I. Outreach strategy

### I1. Kanalen, en wanneer elk ervan logisch is

Geen rangorde. Per kanaal de omstandigheid waarin het past.

| Kanaal | Wanneer het past | Doel | Frictie | Boodschap | Vervolgstap | Wat je niet doet |
|---|---|---|---|---|---|---|
| **Persoonlijke introductie** | Je kent iemand, of iemand kent iemand | Leren, niet verkopen | Laagst | "Ik bouw iets, ik wil je hersens een half uur lenen" | Diagnosegesprek inplannen | Een aanbod doen in het eerste contact |
| **Telefoon** | Kantoor onder tien man, eigenaar neemt zelf op | Afspraak maken, niet pitchen | Middel | Twee zinnen, één vraag, ophangen | Mail met bevestiging | Bellen tussen 1 maart en 1 mei, aangiftepiek |
| **E-mail** | Na een gesprek, of als telefoon niet lukt | Iets tastbaars achterlaten | Laag als opvolging, hoog als koud | Eén concrete vraag, geen bijlage | Antwoord of belafspraak | Een massamail sturen |
| **LinkedIn-post** | Doorlopend, kost niets extra | Gezien worden vóór je belt | Nihil | Wat je die week hebt geleerd over de Wet DBA | Geen directe, dit is grond leggen | Verkoopposts |
| **LinkedIn DM** | Alleen na een echte interactie | Gesprek openen | Middel | Reactie op iets dat zij deden | Belafspraak | Koude DM met pitch |
| **Fysieke afspraak** | Na een goed telefoongesprek, kantoor binnen 30 km | Vertrouwen bouwen, echt leren | Hoog in tijd | Laptop mee, hun eigen situatie doorlopen | Pilot voorstellen | Rijden voor een eerste kennismaking |
| **Brancheverenigingen** (NOAB, RB, NBA, SRA) | Als drie gesprekken hetzelfde patroon geven | Schaal na validatie | Hoog, lange doorlooptijd | Niet nu | Later | Hier beginnen |
| **Lokale netwerkevents** | Als er toevallig iets is | Toevallige ontmoetingen | Middel | Geen script | Opvolgen binnen 48 uur | Erop rekenen als kanaal |
| **Bestaande contacten** (Hoross, familie, oud-collega's) | Nu | In kaart brengen wie wie kent | Nihil | Vraag om een introductie, niet om een verkoop | Introductie | Vergeten dat dit bestaat |
| **Referrals van klanten** | Vanaf ongeveer tien klanten | Goedkoopste groei | Laag | Vragen op het moment dat iets is gelukt | Introductie | Vragen bij nul resultaat |

Eén kanaal ontbreekt bewust: betaald adverteren. Zonder gevalideerde boodschap is dat geld weggooien, en de boodschap is niet gevalideerd.

### I2. Tonaliteit

De basis, voor elk contact in dit kanaal:

- **Informeel maar zakelijk.** Je-vorm, geen u-vorm tenzij zij beginnen. Een boekhouder in Oss is geen advocaat in Amsterdam.
- **Kort.** Een eerste mail is onder de 120 woorden. Een boekhouder leest zijn mail tussen twee klanten door.
- **Adviserend, niet verkopend.** Je stelt een vraag waarop het antwoord interessant is ook als er nooit een deal komt.
- **Founder-led.** Ali schrijft als Ali, niet als [[ZekerWet]]. Een merknaam als afzender naar een klein kantoor leest als marketing. Dit is dezelfde les als bij Higherlevel, waar het account "ZekerWet" heet en dat opvalt.
- **Probleemgericht, niet productgericht.** Het eerste gesprek gaat over wat zij doen, niet over wat het doet.
- **Zakelijk juridisch, niet juridisch zwaar.** Zij kennen het vak. Wetsartikelen citeren tegen een fiscalist leest als college geven.

**Woorden die werken**: schijnzelfstandigheid, modelovereenkomst, doorverwijzen, aansprakelijkheid, je klanten, wat doen jullie nu, hoe vaak.

**Woorden die niet werken**: oplossing, platform, revolutionair, AI-powered, partnership, synergie, disruptie, juridisch waterdicht (verboden in `claims.json`), juridisch advies (verboden, en tegenover een fiscalist ook feitelijk onjuist).

### I3. Per situatie

**Warm contact** (Rosmalen). Geen aanbod, geen demo, geen deck. Eén vraag: wat doen jullie nu als een klant vraagt of zijn ZZP-constructie nog mag. Half uur. De verleiding is om het gesprek te laten kantelen naar een pitch zodra het goed loopt. Niet doen: het tweede gesprek is daarvoor.

**Lauw contact** (iemand die Ali kent via via, of een kantoor dat op LinkedIn heeft gereageerd). Introductie vragen aan de gemeenschappelijke bekende in plaats van zelf benaderen. Daarna hetzelfde als warm.

**Koud contact** (de andere 29 kantoren). Niet benaderen voordat drie diagnosegesprekken zijn gevoerd. Dat is de harde regel uit sectie L: zonder gevalideerde boodschap is koude outreach dertig keer dezelfde fout.

**Eerste gesprek**. Doel is leren. Succescriterium is niet interesse maar of je vijf van de elf vragen uit sectie I4 beantwoord hebt gekregen.

**Follow-up**. Binnen 24 uur, met een samenvatting van wat zij zeiden en niet van wat jij aanbiedt. Dat is meteen een bewijs dat je geluisterd hebt.

**Demo**. Alleen op hun eigen materiaal. Een demo op een voorbeeldcontract bewijst niets; een review op een contract dat zij zelf hebben zien misgaan bewijst alles of niets, en beide zijn bruikbaar.

**Pilot**. Drie tot vijf klanten van één kantoor, dertig tot zestig dagen, met een afgesproken meetmoment vooraf. Niet meer kantoren tegelijk.

**Partnership**. Pas als een pilot iets heeft opgeleverd dat beide kanten kunnen benoemen.

### I4. Discovery-framework

Het bezwaar van de fiscalist uit `Context/icp.md`, dat een AI-tool "geen juridisch kader voor schijnzelfstandigheid" kent, is één waarneming van één persoon op één forum. Het is een hypothese, geen marktfeit. Dit framework is er om hem te toetsen en niet om hem bevestigd te krijgen.

Elf vragen, in deze volgorde, omdat de eerste zes over hun werk gaan en pas daarna over [[ZekerWet]]:

1. Welke juridische vragen krijgen jullie van klanten? Noem de laatste drie.
2. Hoe vaak per maand ongeveer?
3. Wat doen jullie er nu mee?
4. Waar verwijzen jullie naartoe, en wat gebeurt er daarna met die klant?
5. Wat kost zo'n vraag jullie aan tijd, ook als er niets voor gefactureerd wordt?
6. Wanneer zeggen jullie nee, en waarom precies?
7. Wat zou er mis moeten gaan voordat jullie er spijt van krijgen dat je iets hebt aangeraden?
8. Gebruiken jullie al software die je aan klanten doorgeeft? Welke, en hoe bevalt dat?
9. Hoe kijken jullie tegen AI aan voor dit soort werk?
10. Zijn jullie aangesloten bij NOAB, RB, NBA of SRA, en wat mag daar wel en niet rond vergoedingen?
11. Wat zou een samenwerking voor jullie onacceptabel maken?

Vraag 10 is de vraag die dit onderzoek heeft toegevoegd en die het meest oplevert, want zonder het antwoord kan geen partneraanbod worden gedaan.

Wat je meet per gesprek: het aantal vragen dat beantwoord is, het aantal keer dat zij zelf een woord gebruiken dat ook in de klantzinnen uit [[modelovereenkomst-2026]] staat, en of zij uit zichzelf vragen wat het kost. Dat laatste is het enige echte koopsignaal in een diagnosegesprek.

---

## J. Partner model

### J1. Het beroepsrechtelijke beeld

Dit is de sectie waar het meeste in zat dat we niet wisten. Alle bronnen gecontroleerd op 16 september 2026.

| Beroepsgroep | Regel | Wat het zegt | Gevolg voor het partneraanbod |
|---|---|---|---|
| **RB** (Register Belastingadviseurs) | Reglement Beroepsuitoefening, art. 15, versie 001 gedateerd 01-01-2015 zoals gepubliceerd op rb.nl | Geen vergoedingen in enige vorm voor het bezorgen van opdrachten, behalve bij overname van een praktijk. Kortingen en betalingen in natura boven symbolische waarde tellen mee | **Provisie en gratis account als beloning: beide problematisch** |
| **NOB** (Nederlandse Orde van Belastingadviseurs) | Reglement Beroepsuitoefening, laatst gewijzigd 12 mei 2025, toelichting bij art. 1, 4 en 9 gewijzigd 30 maart 2026 | Commissies zijn toegestaan mits vrijheid en onafhankelijkheid gewaarborgd, het belang van de cliënt voorop staat en het lid transparant is over samenwerkingen. Bevat een expliciet voorbeeld over softwareoplossingen | **Toegestaan onder voorwaarden** |
| **NBA** (RA en AA accountants) | VGBA, art. 11 objectiviteit, art. 21 bedreigingen, art. 10a en 11a geschenken | Geen apart artikel over provisie. Wel: niet ongepast laten beïnvloeden, en geen geschenk aannemen waarvan je weet dat het bedoeld is om tot onethisch gedrag aan te zetten. Werkt via het bedreigingenmodel | **Geen verbod, wel een toets per geval** |
| **NOAB** | Eigen voorwaarden en tuchtrechtspraak | Niet als primaire bron gelezen. Secundaire bronnen wijzen op vergelijkbare onafhankelijkheidseisen | **Onbekend, moet per kantoor gevraagd** |
| **Geen aansluiting** | Geen | Geen beroepsregel van toepassing | **Vrij, maar het vertrouwensargument valt weg** |

Het NOB-voorbeeld is het meest bruikbare stuk tekst dat ik heb gevonden, omdat het precies over deze situatie gaat: advieskantoren die software van derden inkopen en aan cliënten ter beschikking stellen, waarbij het kantoor een jaarlijkse vergoeding kan ontvangen. Die vergoeding "zou onder omstandigheden kunnen worden beschouwd als een commissie, die is toegestaan mits de vrijheid en onafhankelijkheid gewaarborgd blijven, het belang van de cliënt voorop staat en niet in strijd wordt gehandeld met de overige beroeps- en gedragsregels van de NOB." **[BRON]**

Twee waarschuwingen bij deze tabel. De RB-versie op rb.nl draagt datum 1 januari 2015; er kan een nieuwere versie zijn die niet op die plek staat. En het merendeel van de dertig kantoren op de lijst is administratiekantoor en geen RB-, NOB- of NBA-lid, waardoor geen van deze reglementen op hen van toepassing is. Dat maakt vraag 10 uit het discovery-framework geen formaliteit maar de bepalende vraag voor het aanbod. **[BRON]** en **[REDENERING]**

### J2. De structuren, gewogen

| Structuur | Hoe het werkt | Beroepsrechtelijk | Bouwlast | Oordeel |
|---|---|---|---|---|
| **Opslag op eigen factuur** | Kantoor factureert zijn klant voor zijn eigen werk, [[ZekerWet]] factureert het abonnement | Schoonst: geen betaling van een derde voor doorverwijzen | Laag | Het Firm24-model. Meest robuust |
| **Klantkorting zonder tegenprestatie** | Klanten van het kantoor krijgen korting, kantoor krijgt niets | Schoon: het voordeel gaat naar de cliënt | Laag, mits kortingscodes aan | Veilig, maar geeft het kantoor geen reden |
| **Gratis account voor eigen praktijkgebruik** | Kantoor gebruikt het zelf, los van doorverwijzen | Schoon mits niet gekoppeld aan aanbrengen | Nihil | Veilig als het geen beloning is. Nu een grijs gebied |
| **Referral fee of revenue share** | Vergoeding per aangebrachte klant | RB verboden, NOB onder voorwaarden, NBA per geval | Middel | Alleen na expliciete bevestiging per kantoor |
| **Affiliate** | Hetzelfde met een ander woord | Idem | Laag | Verandert niets aan de beoordeling |
| **White label** | Eigen huisstijl, klant ziet het kantoor | Schoon, het is dan hun dienst | Hoog, bestaat niet in de code | Te vroeg |
| **Kantoorlicentie** | Vast bedrag per maand voor het kantoor, eigen omgeving | Schoon, gewone softwareaankoop | Middel tot hoog | Interessant na validatie |
| **Prijs per klantdossier** | Bedrag per maand per aangesloten klant | Schoon, gewone softwareaankoop | Hoog | Het Informer-model. Het meest schaalbare, en het verst weg |
| **Bulk accounts** | Kantoor koopt tien accounts met staffelkorting | Schoon | Laag | Onderschat. Dichtstbijzijnde bruikbare vorm |

### J3. Wat hieruit volgt

De hypothese uit [[kanaal-boekhouders]] (gratis account, klantkorting, geen commissie) is niet verkeerd, maar de onderbouwing klopte niet. Commissie werd gemeden omdat het riskant leek en het gratis account werd veilig geacht; het onderzoek laat zien dat beide onder dezelfde bepaling kunnen vallen zodra ze aan doorverwijzen worden gekoppeld, en dat bij NOB-leden juist de commissie expliciet is toegestaan.

De structuur die het minst afhangt van welke vereniging een kantoor toevallig heeft, is de opslag op de eigen factuur, omdat het kantoor dan zijn eigen werk factureert en geen vergoeding van een derde ontvangt. Dat is ook precies wat Firm24 bij 1800 kantoren doet.

Maar dit is een aanbeveling vooraf en geen besluit. Het aanbod hoort pas vast te staan na de eerste drie gesprekken, en vraag 10 uit het discovery-framework bepaalt per kantoor wat mogelijk is. **[REDENERING]**

---

## K. Measurement

### K1. Wat de huidige hypothese mist

Het voorstel van vanochtend was: unieke link per kantoor, UTM-source, herkenbare UTM-content, accounts, betaalde conversies, 60 dagen attributie. Dat is een goed begin en het is niet genoeg, om drie redenen.

**De link meet het verkeerde eindpunt.** Als een kantoor het echt goed doet, noemt het [[ZekerWet]] in een gesprek en typt de klant de naam in Google. Die klant komt zonder UTM binnen en telt als organisch. Hoe beter het kantoor werkt, hoe meer je ondertelt. Daarom is een link nooit voldoende: er moet ook een vraag "hoe ben je bij ons gekomen" in de onboarding staan, zoals die ook aan [[Yvonne Heiligers]] is gesteld. **[REDENERING]**

**De trechter begint eerder dan de link.** Outreach en gesprek gebeuren voordat er iets te klikken valt. Zonder die stappen te tellen weet je bij een teleurstellend resultaat niet of het kanaal niet werkt of dat er te weinig gesprekken waren.

**Er is nog geen attributie in de app.** In `Projects/ZekerWet/ZekerWet.md` staat "attributie in de app met de vier `User`-kolommen" als open punt. Zonder dat kan een betalende klant niet aan een kantoor gekoppeld worden. Dit is de enige technische voorwaarde die het kanaal daadwerkelijk blokkeert. **[VAULT]**

### K2. Het meetmodel

Elf stappen, per kantoor. Alles wat vóór de link gebeurt is handwerk in één bestand; alles daarna komt uit de app.

| Stap | Meting | Waar | Vanity? |
|---|---|---|---|
| Prospect | Kantoor op de lijst | Vault-bestand | nee |
| Contacted | Datum en kanaal van eerste contact | Vault-bestand | nee |
| Replied | Reactie ja of nee, en hoe lang erover | Vault-bestand | nee |
| Discovery | Gesprek gevoerd, hoeveel van de elf vragen beantwoord | Vault-bestand | nee |
| Pilot | Aantal klanten dat het kantoor aandraagt | Vault-bestand | nee |
| Link clicks | Kliks op de kantoorlink | UTM plus analytics | **ja, alleen als tussenstap** |
| Accounts | Aangemaakte accounts toe te schrijven aan het kantoor | App, attributiekolommen | nee |
| Documentgebruik | Aantal gebruikers dat minstens één document genereert | App | nee, dit is de belangrijkste |
| Betaald | Aantal dat een abonnement of document koopt | Stripe plus attributie | nee |
| Omzet | Euro per kantoor per maand | Stripe | nee |
| Retentie | Nog actief na 30, 60, 90 dagen | Stripe plus app | nee |

### K3. Welke KPI's er werkelijk toe doen

Bij één klant en nul gesprekken zijn de meeste ratio's betekenisloos. Vier getallen zijn dat niet:

1. **Gesprekken gevoerd.** Het enige getal dat [[Ali Can]] volledig zelf in de hand heeft. Bij nul gesprekken is elke andere meting ruis.
2. **Documentgebruik per aangemaakt account.** Dit is de echte activatie en het voorspelt alles wat erna komt. [[Yvonne Heiligers]] genereerde één document en kwam niet terug; dat was elf dagen voordat iemand het merkte. Dit getal had dat op dag drie laten zien.
3. **Betalende klanten per kantoor na 60 dagen.** De enige uitkomst die telt voor het kanaalbesluit.
4. **Behouden na 90 dagen.** Bepaalt of dit een kanaal is of een eenmalige golf.

**Vanity metrics die vermeden moeten worden**: link clicks als einddoel, aantal kantoren benaderd, LinkedIn-vertoningen, aantal aangemaakte accounts zonder gebruik, aantal documenten in de catalogus.

### K4. Wat er gebouwd moet worden, en niet nu

Alleen de attributiekolommen op `User` blokkeren echt. De rest (kantoorlinks, dashboards, rapportage) kan de eerste maanden met een lijst in de vault en de Stripe-interface. Bouwen komt na sectie M en niet ervoor.

---

## L. 30-day experiment

Dertig dagen vanaf 17 september 2026. Doel is niet omzet maar één antwoord: klopt hypothese H3, en zo ja in welke woorden.

**Harde regel voor de hele maand: geen massale outreach en geen koude mail voordat drie diagnosegesprekken zijn gevoerd.** Dertig kantoren benaderen met een ongevalideerde boodschap is dertig keer dezelfde fout maken, en je verbrandt de enige regio waar je fysiek langs kunt gaan.

### Week 1, 17 tot 23 september. Fundament en het eerste gesprek

| | |
|---|---|
| **Ali doet** | Rosmalen benaderen voor een diagnosegesprek van een half uur. In kaart brengen wie hij verder kent via Hoross, familie en oud-collega's. Beslissen over scenario A en over de losse-verkooplek |
| **Claude doet** | Gesprekslijst met de elf vragen klaarzetten, kantorenlijst aanvullen met Nijmegen en Wijchen, prospectbestand met de elf funnelstappen aanmaken |
| **Prospects** | 1 (warm) |
| **Kanaal** | Persoonlijke introductie |
| **Contactmomenten** | 1 |
| **Boodschap** | "Ik bouw iets, ik wil je hersens een half uur lenen" |
| **Assets nodig** | De elf vragen. Verder niets. Geen deck, geen demo |
| **Data** | Antwoorden op de elf vragen, woordelijk |
| **Evalueren** | Zondag 23 september |
| **Stoppen als** | Niets. Eén gesprek is nooit genoeg om iets te stoppen |

### Week 2, 24 tot 30 september. Twee gesprekken erbij

| | |
|---|---|
| **Ali doet** | Twee kantoren bellen uit de lijst, bij voorkeur één in Oss en één in Den Bosch. Doel van het telefoontje is een afspraak, niet een pitch. De Search Console-dekking van 28 september lezen |
| **Claude doet** | Belscript op basis van gesprek 1, woordelijke klantzinnen uit gesprek 1 naar `research/voc/`, hypothese H3 bijstellen |
| **Prospects** | 2 tot 4 koud |
| **Kanaal** | Telefoon, met mail als opvolging |
| **Contactmomenten** | 4 tot 6 |
| **Boodschap** | Wat uit gesprek 1 kwam, in hun woorden |
| **Assets nodig** | Belscript, opvolgmail onder 120 woorden |
| **Data** | Opgenomen of niet, afspraak of niet, en de reden bij een nee |
| **Evalueren** | Zondag 30 september |
| **Stoppen als** | Tien belpogingen geen enkel gesprek opleveren. Dan is het kanaal niet dood maar de aanpak wel |

### Week 3, 1 tot 7 oktober. Aanbod vormgeven en het Rocket Lawyer-venster

| | |
|---|---|
| **Ali doet** | Diagnosegesprekken 2 en 3 voeren. Op basis van vraag 10 beslissen welke aanbodstructuur überhaupt mag |
| **Claude doet** | Aanbod uitwerken in de structuur die uit vraag 10 volgt. Losstaand: een kennisbankartikel en een LinkedIn-reeks voor ondernemers die vóór 31 oktober van Rocket Lawyer Nederland af moeten. Dat is een aparte acquisitiekans en die loopt niet via boekhouders |
| **Prospects** | 2 tot 3 |
| **Kanaal** | Fysieke afspraak of videogesprek |
| **Contactmomenten** | 3 tot 5 |
| **Boodschap** | Hun eigen woorden uit gesprek 1 en 2 |
| **Assets nodig** | Eén pagina met het aanbod. Nog steeds geen deck |
| **Data** | Wat zij van het aanbod vinden, welk onderdeel het eerste bezwaar oproept |
| **Evalueren** | Zondag 7 oktober |
| **Stoppen als** | Alle drie de gesprekken zeggen dat ze deze vragen nooit krijgen. Dan is H3 gefalsifieerd en gaat de tijd naar de kennisbank |

### Week 4, 8 tot 16 oktober. Eén pilot, of stoppen

| | |
|---|---|
| **Ali doet** | Eén kantoor kiezen voor een pilot met drie tot vijf klanten, of besluiten dat het kanaal het niet wordt |
| **Claude doet** | Pilotafspraken vastleggen, attributie inrichten voor zover mogelijk zonder codewijziging, meetmoment vastzetten op 60 dagen |
| **Prospects** | 1 |
| **Kanaal** | Bestaand contact |
| **Contactmomenten** | 2 tot 3 |
| **Boodschap** | Concreet: drie klanten, zestig dagen, dit meten we |
| **Assets nodig** | Pilotafspraak op één pagina, kantoorlink |
| **Data** | Alle elf funnelstappen ingevuld voor minstens drie kantoren |
| **Evalueren** | Donderdag 16 oktober, harde beslissing |
| **Pivoten als** | Drie gesprekken zeggen wel dat ze de vragen krijgen maar geen van drieën wil doorverwijzen. Dan is het probleem echt en het kanaal verkeerd, en gaat de aandacht naar direct bereik |

**Wat er de hele maand doorloopt**: de wekelijkse contentcadans, het kennisbankartikel per week, en de supportinbox. Die worden hier niet door geraakt.

---

## M. Implementation roadmap

Volgorde, met de voorwaarde die elk blok vrijgeeft. Niets hiervan gebeurt voordat [[Ali Can]] de bijbehorende beslissing heeft genomen.

### Blok 0. Wat sowieso moet, ongeacht welk scenario

| Wat | Waarom | Omvang |
|---|---|---|
| Vercel naar Pro | Hobby staat commercieel gebruik niet toe, en er is een betalende klant | 20 dollar per maand, één klik |
| `PLAN_TIERS`-teksten kloppend maken | De pagina belooft planverschillen die `access.ts` niet kent | Klein, tekst |
| `business.md` corrigeren | "AI-automatiseringsplatform" en "AI-vraagbaak" dekken de lading niet | Klein, vault |
| Attributiekolommen op `User` | Enige technische blokkade voor kanaalmeting | Middel |

### Blok 1. Na het pricingbesluit (scenario A, B of C)

AI-limieten omhoog, `allow_promotion_codes` aan zodat kortingen en verrekening kunnen, en de losse-verkooplek dichten volgens de gekozen optie uit G3. Enterprise herzien of tijdelijk uit de verkoop.

### Blok 2. Na drie diagnosegesprekken

Kantoorlinks met UTM, prospectbestand, en het partneraanbod in de vorm die uit vraag 10 volgt. Eerder heeft geen van deze dingen een vorm.

### Blok 3. Na een geslaagde pilot

Bulk accounts of kantoorlicentie, afhankelijk van wat het kantoor zelf vroeg. White label en prijs per klantdossier blijven op de plank tot er meer dan één kantoor is.

### Blok 4. Marketingautomatisering, uitdrukkelijk niet nu

Uit de eerdere assessment: er was geen echte automatisering, alleen reminders en losse scripts; `ONTBREEKT` heeft tot gepubliceerde placeholderposts geleid; monitoring controleerde planning en logboek maar niet de werkelijke publicatie; er stonden testposts en een dubbele carousel live; er waren geen UTM-tags over 51 posts; er was een lange publicatiestilte en meerdere geplande weken zijn niet uitgevoerd. Dat is sinds 9 september grotendeels hersteld met de validatiepoort, de contentstore, de reconciler en de pre-flight.

Wat de nieuwe commerciële strategie daadwerkelijk van dat systeem nodig heeft, en alleen dat:

| Onderdeel | Nodig voor | Status |
|---|---|---|
| **UTM** | Kantoorlinks, en überhaupt weten waar een klant vandaan komt | Bestaat, wordt op elke post toegepast |
| **Attributie in de app** | Klant koppelen aan kantoor | **Ontbreekt. Blokkeert het kanaal** |
| **CRM** | Elf funnelstappen over dertig kantoren bijhouden | Bestaat niet. Een vault-bestand is voorlopig genoeg |
| **Content** | Grond leggen voor de gesprekken, en het Rocket Lawyer-venster | Draait |
| **Approval** | Elke claim over prijs of product door de poort | Draait |
| **Analytics** | Bezoeker naar klant kunnen volgen | Half. Vercel Analytics plus Stripe, niet gekoppeld |
| **Reporting** | Weten of een kanaal werkt | Ontbreekt, maar niet nodig onder de tien klanten |

De conclusie voor dit blok: er hoeft voor de commerciële strategie precies één ding aan het marketingsysteem te gebeuren, en dat is attributie. De rest is af genoeg.

---

## Openstaande beslissingen voor [[Ali Can]]

Zeven, in volgorde van urgentie. Geen daarvan neem ik.

1. **Vercel naar Pro, ja of nee.** Dit is de enige waar een verkeerde uitkomst het product offline kan halen.
2. **Scenario A uitvoeren, ja of nee.** De prijspagina belooft nu planverschillen die de code niet kent. Zolang dat zo blijft, is elke klant die Business koopt een potentieel terugbetalingsgesprek.
3. **B of C**, oftewel: waar komt de grendel te liggen, op volume of op documentcategorie.
4. **De losse-verkooplek**: eenmalig, venster, of prijs omhoog.
5. **De 55 particuliere documenten**: splitsen, weglaten of anders beprijzen.
6. **Het Rocket Lawyer-venster**: wel of niet zes weken aandacht geven aan ondernemers die vóór 31 oktober moeten overstappen.
7. **Het partneraanbod**: vaststellen ná gesprek 3 en niet ervoor.

## Bronnen

Alle URL's geraadpleegd op 16 september 2026.

- Ligo prijzen: https://www.ligo.nl/prijzen en https://www.ligo.nl/contracten
- Legalflow abonnementen: https://www.legalloyd.com/pakket
- Lawsy prijzen en bedrijvenpagina: https://lawsy.nl/prijzen en https://lawsy.nl/voor-bedrijven
- Lawsy kostenvergelijking: https://lawsy.nl/kosten-vergelijkingen
- Rocket Lawyer Nederland: https://www.rocketlawyer.com/nl/nl en https://www.rocketlawyer.com/nl/nl/hulp
- MKB Juristen: https://mkbjuristen.nl/contracten/
- Firm24 Professional: https://www.firm24.com/professional/
- VGBA (NBA): https://www.nba.nl/wet--en-regelgeving/hra/598/599/
- NOB Reglement Beroepsuitoefening: https://www.nob.net/wp-content/uploads/2026/04/Reglement-Beroepsuitoefening-Code-of-Conduct.pdf
- RB Reglement Beroepsuitoefening: https://rb.nl/wp-content/uploads/Reglement_Beroepsuitoefening_Register_Belastingadviseurs_-_Word_lid.pdf
- Gemini API-prijzen: https://ai.google.dev/gemini-api/docs/pricing
- Vercel Hobby-plan: https://vercel.com/docs/plans/hobby
- Stripe-tarieven Nederland: https://stripe.com/resources/more/what-are-transaction-costs-for-dutch-businesses
- DAS en ZZP-rechtsbijstand: https://www.zzp-nederland.nl/kennisbank/rechtsbijstand-zzp-vergelijken

Gerelateerd: [[ZekerWet]], [[kanaal-boekhouders]], [[ZekerWet-concurrenten]], [[klant-yvonne-heiligers]], [[seo-indexering-2026-09-14]], [[modelovereenkomst-2026]], [[icp]], [[offer]], [[business]], [[strategy]]
