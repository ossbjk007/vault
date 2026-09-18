---
type: plan
date: 2026-09-17
status: actief
tags: [execution, distributie, attributie, validatie, meetplan]
project: ZekerWet
---

Veertiendaags uitvoeringsplan voor [[ZekerWet]]. Dag 1 is donderdag 17 september 2026, dag 14 is woensdag 30 september 2026. Volgt op [[pricing-besliskader-2026-09-16]] en gebruikt dat als primaire basis.

Dit is een plan, geen uitvoering. Er is niets gewijzigd: geen code, geen pricing, geen posts, geen Buffer, geen outreach, geen credentials, geen Vercel-plan.

Labels door het hele document: **BEWEZEN**, **WAARSCHIJNLIJK**, **HYPOTHESE**, **DATA GAP**.

---

## 1. Executive summary

**De stelling van dit plan in één zin.** Acht mensen zagen in dertig dagen de prijspagina en zesentwintig LinkedIn-bezoekers kwamen binnen in de drie dagen dat de cadans voor het eerst echt liep (**BEWEZEN** dat ze kwamen, **WAARSCHIJNLIJK** dat de posts de oorzaak zijn); zolang die verhouding zo staat, is niet de prijs maar het aantal mensen dat hem ziet de variabele die 15.000 euro per maand in de weg staat. Dat laatste is een **HYPOTHESE** op basis van volumes, geen gemeten bottleneck: sectie 12 laat zien dat elke trechterstap onder de homepage eencijferig is.

De komende veertien dagen gaan daarom over drie dingen en niet over pricing: **meer relevante bezoekers**, **kunnen zien waar ze vandaan komen**, en **met echte mensen praten** in plaats van nog een onderzoek doen.

Wat dit plan bewust níet is: een groeisprint waarin elke dag iets gepubliceerd wordt. De onderdelen van het marketingsysteem bestaan en zijn in de repo nagekeken (validatiepoort, contentstore, pre-flight, scheduler, reconciler, Buffer; **BEWEZEN**). Dat het end-to-end betrouwbaar publiceert is **WAARSCHIJNLIJK**, niet bewezen: de audit vond eerder dat monitoring naar de planning keek en niet naar werkelijke publicatie, en de LinkedIn-post van 17 september 07:45 is de eerste controle onder de reconciler (sectie 19, punt 3). Dit plan hangt er vier dingen aan en verandert de rest niet.

**De vier toevoegingen.** Eén: een minimale attributielaag, want zonder die laag is alles wat hierna gebeurt niet toe te schrijven. Twee: het enige kanaal met een aantoonbare bezoekerspiek, LinkedIn (bewijs van activiteit, niet van kanaalkwaliteit), van twee posts per week naar een serieuze inzet met een landingspagina die je kunt terugzien. Drie: vijftien vragen aan echte mensen, vijf aan [[Yvonne Heiligers]] en tien aan drie kantoren. Vier: de SEO-indexering die op 28 september zijn eerste meetmoment heeft, binnen dit venster.

**Wat het je kost.** Ongeveer negen tot tien uur founder-tijd over veertien dagen, geconcentreerd in vijf blokken. Zeven van de veertien dagen kosten je nul minuten. Monitoring is twee keer dertig minuten.

**Waar het op uitkomt.** Op dag 14 kun je vier vragen beantwoorden die je vandaag niet kunt beantwoorden: brengt LinkedIn bezoekers die iets doen, herkennen boekhouders het probleem, waarom kocht de enige klant wat ze kocht, en landt de kennisbank in Google. De beslisboom in sectie 14 vertaalt elk antwoord naar de volgende fase.

**Wat er nadrukkelijk niet gebeurt**: pricing. Sectie 16 bevat tien pricingonderwerpen: zeven geparkeerd met per stuk de trigger die ze weer opent, en drie die open staan als juistheidsvraag, los van pricing.

---

## 2. Top 5 priorities

### P1. Attributie werkend krijgen

**Waarom nu.** Elk ander doel in dit plan is onmeetbaar zonder deze laag. Als LinkedIn in deze veertien dagen veertig bezoekers levert en er komt één klant bij, kun je die twee vandaag niet aan elkaar knopen.

**Hypothese die het test.** Geen. Dit is infrastructuur, geen experiment. Dat onderscheid is belangrijk: dit mag niet met "maar levert het klanten op" worden afgerekend.

**Metric.** Percentage nieuwe accounts dat een herkomst draagt. Baseline 0 procent (**BEWEZEN**: geen attributiekolommen op `User`, geen `track()` in de codebase).

**Positief signaal.** Elk nieuw account na de ingreep draagt een bron. **Negatief signaal.** Accounts komen binnen zonder bron, wat betekent dat de vastlegging op de verkeerde plek zit.

**Voorbehoud.** De ingreep is nog niet uitvoerbaar: eerst fase A uit sectie 8 (privacy- en cookiecheck), pas daarna fase B (bouwen). Landt fase B niet binnen dit venster, dan is de operationele terugvaloptie het unieke landingspad per post, dat op Hobby wél leesbaar is, en blijft "accounts met herkomst" op dag 14 een **DATA GAP**.

**Wat we hier niet uit mogen concluderen.** Niets over kanaalkwaliteit. Met drie aanmeldingen per maand duurt het maanden voordat attributie iets zegt over welk kanaal beter is.

### P2. Distributie op het enige kanaal met aantoonbare beweging

**Waarom nu.** LinkedIn stond van 10 tot en met 13 september op nul en leverde daarna 12, 11 en 3 bezoekers. Zesentwintig in drie dagen tegen een baseline van ongeveer één LinkedIn-bezoeker per maand vóór 14 september. **BEWEZEN** dat het verkeer er was; **WAARSCHIJNLIJK** dat de posts het veroorzaakten, want zonder UTM-dimensies is de post niet aanwijsbaar. De 30-daagse referrer-telling geeft 24, de som van de dagcijfers 26; het verschil zit vermoedelijk in ontdubbeling per periode en is niet nagekeken (**DATA GAP**).

**Hypothese.** Een consistente LinkedIn-cadans levert herhaalbaar verkeer, en niet eenmalig. **HYPOTHESE**

**Metric.** LinkedIn-bezoekers per veertien dagen, en het aandeel daarvan dat verder komt dan de landingspagina.

**Positief signaal.** Veertig of meer LinkedIn-bezoekers over veertien dagen, verspreid over meerdere posts in plaats van één piek. **Negatief signaal.** Onder de vijftien, of alles uit één post. Die veertig is uitsluitend een operationele signaleringsdrempel: 40+ bezoekers is voldoende activiteit om het kanaal verder te analyseren, maar bewijst geen kanaalkwaliteit, koopintentie of schaalbaarheid.

**Wat we hier niet uit mogen concluderen.** Dat LinkedIn schaalt. Vier posts is vier posts. En bezoekers zijn geen koopintentie: de prijspagina had er acht in een maand.

### P3. Klantvraag valideren bij echte mensen

**Waarom nu.** Vijftien vragen leveren waarschijnlijk meer op dan een vierde onderzoek. Er is één betalende klant die nooit is uitgevraagd, en nul kantoorgesprekken terwijl er dertig kantoren in kaart staan.

**Hypothese.** Twee. Dat [[Yvonne Heiligers]] Business koos om een reden die iets zegt over de tierstructuur (**HYPOTHESE**), en dat boekhouders regelmatig juridische vragen krijgen die buiten hun dienstverlening vallen (**HYPOTHESE**, nul gesprekken).

**Metric.** Vijf beantwoorde vragen van Yvonne, drie gevoerde kantoorgesprekken.

**Positief signaal.** Drie kantoren die uit zichzelf voorbeelden noemen van zulke vragen. **Negatief signaal.** Drie kantoren die zeggen dat ze dit soort vragen nauwelijks krijgen; dan is de hypothese gefalsifieerd en dat is óók winst.

**Wat we hier niet uit mogen concluderen.** Drie gesprekken zijn drie meningen. Ze bepalen de richting van het volgende onderzoek, niet het aanbod.

### P4. De kennisbank laten landen in Google

**Waarom nu.** Het dekkingsrapport van Search Console valt op 28 september, dag 12, binnen dit venster. Kennisbankartikelen trokken al circa 23 bezoekers in dertig dagen terwijl er nauwelijks iets geïndexeerd is. Dit is het enige kanaal dat zichzelf opbouwt.

**Hypothese.** De artikelen gaan indexeren nu de sitemap is ingediend en indexering is aangevraagd. **WAARSCHIJNLIJK**: `wat-is-een-nda` stond binnen een uur geïndexeerd.

**Metric.** Aantal geïndexeerde kennisbankartikelen, en vertoningen en klikken in Search Console.

**Positief signaal.** Vijf of meer van de zeven artikelen geïndexeerd op 28 september, met vertoningen. **Negatief signaal.** Nog steeds "gevonden, momenteel niet geïndexeerd" op de meeste.

**Wat we hier niet uit mogen concluderen.** Dat SEO werkt of niet werkt. Veertien dagen is voor zoekverkeer niets; dit is een tussenstand.

### P5. De trechter onder het verkeer zichtbaar maken

**Waarom nu.** We weten dat 62 mensen de homepage zagen en 3 op aanmelden kwamen. Wat daartussen gebeurt, is onzichtbaar.

**Hypothese.** De grootste weglek zit tussen landingspagina en aanmelden, niet bij de prijs. **HYPOTHESE**

**Metric.** De paden uit sectie 12, handmatig uitgelezen vóór de retentie van één maand verloopt.

**Positief signaal.** Een duidelijke knik op één stap. **Negatief signaal.** Aantallen zo klein dat er geen knik in te zien is, wat het waarschijnlijkste is.

**Wat we hier niet uit mogen concluderen.** Percentages. Bij acht bezoekers op de prijspagina is elk percentage een verhaal dat je erin leest.

---

## 3. Dag-tot-dag plan

Legenda voor tijd: dit is jouw tijd, niet die van mij. Zeven dagen kosten je nul minuten.

### Week 1

**Dag 1, donderdag 17 september. Het zwaarste blok van de veertien dagen.**

| | |
|---|---|
| **Doel** | Week 39 staat, Yvonne is benaderd, de open repo-fixes zijn weg |
| **Acties** | 1. Gmail-inbox checken op openstaande mail van [[Yvonne Heiligers]] (vaultregel 17). 2. De vijf vragen sturen. 3. Week 39 draften. 4. Artikelconcept `modelovereenkomst-zzp-2026` juridisch beoordelen. 5. `wet-dba-zzp.tsx` en `claims.json` corrigeren |
| **Wie** | 1 en 2 IK, 3 SAMEN, 4 IK, 5 CLAUDE na jouw akkoord |
| **Tijd voor jou** | 2 uur 45, waarvan 15 minuten voor Yvonne (som van de checklist in sectie 19) |
| **Output** | Mail verstuurd, week 39 in de contentstore, artikel goedgekeurd |
| **Metric** | Week 39 door de validatiepoort, nul blokkades |
| **Succescriterium** | Vóór het einde van de dag staat week 39 klaar voor de goedkeuringsronde van zondag |
| **Afhankelijkheden** | De LinkedIn-post van week 38 gaat vanochtend 07:45 automatisch via Buffer; alleen controleren of hij live staat (sectie 19, punt 3) |

**Dag 2, vrijdag 18 september.**

| | |
|---|---|
| **Doel** | Week 38 netjes afsluiten |
| **Acties** | X-post `2026-09-18-x-opdracht-vervanging` handmatig plaatsen en bevestigen in de CLI. Facebook en Instagram gaan om 09:00 automatisch |
| **Wie** | IK |
| **Tijd voor jou** | 10 minuten |
| **Output** | X-post live, status PUBLISHED |
| **Metric** | Nul overgeslagen slots in week 38 |
| **Succescriterium** | `mkt:confirm` gedraaid met de live link |
| **Afhankelijkheden** | Geen |

**Dag 3, zaterdag 19 september.** Nul minuten. Geen acties.

**Dag 4, zondag 20 september.**

| | |
|---|---|
| **Doel** | Week 39 goedgekeurd, eerste kantoorbenadering voorbereid |
| **Acties** | 1. Goedkeuringsronde week 39, regel voor regel. 2. Drie kantoren kiezen uit [[kanaal-boekhouders]] en beslissen wie je als eerste belt |
| **Wie** | 1 IK, 2 SAMEN |
| **Tijd voor jou** | 45 minuten |
| **Output** | Week 39 APPROVED, drie namen met telefoonnummer en beldag |
| **Metric** | Aantal goedgekeurde items |
| **Succescriterium** | Week 39 volledig goedgekeurd en drie namen vastgelegd |
| **Afhankelijkheden** | Dag 1 |

**Dag 5, maandag 21 september.**

| | |
|---|---|
| **Doel** | Eerste diagnosegesprek aangevraagd |
| **Acties** | Het kantoor in Rosmalen benaderen voor een half uur. Geen aanbod, geen demo |
| **Wie** | IK |
| **Tijd voor jou** | 15 minuten |
| **Output** | Afspraak of een nee |
| **Metric** | Gesprek ingepland ja of nee |
| **Succescriterium** | Een datum, of een duidelijk nee zodat je door kunt naar het tweede kantoor |
| **Afhankelijkheden** | Dag 4 |

**Dag 6, dinsdag 22 september.**

| | |
|---|---|
| **Doel** | Week 39 loopt, tweede kantoor benaderd |
| **Acties** | LinkedIn week 39 gaat 07:45 automatisch. Tweede kantoor bellen |
| **Wie** | IK |
| **Tijd voor jou** | 15 minuten |
| **Output** | Tweede afspraak of nee |
| **Metric** | Benaderde kantoren |
| **Succescriterium** | Twee kantoren benaderd |
| **Afhankelijkheden** | Geen |

**Dag 7, woensdag 23 september. Eerste weekreview.**

| | |
|---|---|
| **Doel** | Tussenstand, en analytics veiligstellen vóór de retentie verloopt |
| **Acties** | 1. X-post week 39 plaatsen en bevestigen. 2. Weekreview volgens het format uit sectie 17. 3. Ik lees de analytics uit en zet de cijfers in het scoreboard |
| **Wie** | 1 IK, 2 SAMEN, 3 CLAUDE |
| **Tijd voor jou** | 30 minuten plus 10 voor de X-post |
| **Output** | Ingevuld scoreboard, tien beantwoorde reviewvragen |
| **Metric** | Alle scoreboardregels gevuld |
| **Succescriterium** | Je hebt op woensdag, na twee posts, een eerste indicatie of LinkedIn herhaalt of eenmalig was |
| **Afhankelijkheden** | Dag 1 tot en met 6 |

### Week 2

**Dag 8, donderdag 24 september.**

| | |
|---|---|
| **Doel** | Week 40 gedraft, eerste gesprek gevoerd |
| **Acties** | 1. Week 40 draften, met het Rocket Lawyer-venster als thema. 2. Eerste diagnosegesprek als het is ingepland. 3. Derde kantoor benaderen |
| **Wie** | 1 SAMEN, 2 en 3 IK |
| **Tijd voor jou** | 2 uur, waarvan 45 minuten gesprek |
| **Output** | Week 40 gedraft, gespreksnotities volgens sectie 6 |
| **Metric** | Gesprekken gevoerd, vragen beantwoord |
| **Succescriterium** | Week 40 staat, en minimaal vijf van de tien vragen beantwoord in gesprek 1 |
| **Afhankelijkheden** | Dag 5 |

**Dag 9, vrijdag 25 september.**

| | |
|---|---|
| **Doel** | Week 39 afronden |
| **Acties** | X-post plaatsen en bevestigen. Facebook en Instagram gaan automatisch |
| **Wie** | IK |
| **Tijd voor jou** | 10 minuten |
| **Output** | Week 39 compleet |
| **Metric** | Nul overgeslagen slots |
| **Succescriterium** | Alles bevestigd |
| **Afhankelijkheden** | Geen |

**Dag 10, zaterdag 26 september.** Nul minuten.

**Dag 11, zondag 27 september.**

| | |
|---|---|
| **Doel** | Week 40 goedgekeurd |
| **Acties** | Goedkeuringsronde week 40 |
| **Wie** | IK |
| **Tijd voor jou** | 45 minuten |
| **Output** | Week 40 APPROVED |
| **Metric** | Goedgekeurde items |
| **Succescriterium** | Week 40 volledig goedgekeurd |
| **Afhankelijkheden** | Dag 8 |

**Dag 12, maandag 28 september. Het meetmoment.**

| | |
|---|---|
| **Doel** | Weten of de kennisbank indexeert |
| **Acties** | 1. Search Console dekkingsrapport lezen. 2. Tweede en derde gesprek voeren als ze staan |
| **Wie** | 1 SAMEN, 2 IK |
| **Tijd voor jou** | 20 minuten plus gesprekken |
| **Output** | Indexeringsstand van 7 kennisbankartikelen en 248 pagina's, plus zoekwoorden met vertoningen |
| **Metric** | Geïndexeerde pagina's, vertoningen, klikken |
| **Succescriterium** | Je weet welke artikelen wél en niet zijn opgepakt |
| **Afhankelijkheden** | Geen |

**Dag 13, dinsdag 29 september.**

| | |
|---|---|
| **Doel** | Week 40 loopt, laatste gesprek |
| **Acties** | LinkedIn gaat automatisch. Derde gesprek als het nog openstaat |
| **Wie** | IK |
| **Tijd voor jou** | 0 tot 45 minuten |
| **Output** | Drie gesprekken afgerond |
| **Metric** | Gevoerde gesprekken |
| **Succescriterium** | Drie gesprekken |
| **Afhankelijkheden** | Dag 5, 6, 8 |

**Dag 14, woensdag 30 september. Eindreview en besluit.**

| | |
|---|---|
| **Doel** | De beslisboom doorlopen en de volgende fase kiezen |
| **Acties** | 1. X-post plaatsen. 2. Volledige weekreview. 3. Scoreboard afsluiten. 4. Beslisboom uit sectie 14 doorlopen |
| **Wie** | SAMEN |
| **Tijd voor jou** | 45 minuten |
| **Output** | Eindstand op alle scoreboardregels, en één besluit over de volgende fase |
| **Metric** | Alle regels gevuld |
| **Succescriterium** | Je kunt de vier vragen uit de executive summary beantwoorden |
| **Afhankelijkheden** | Alles |

**Totale founder-tijd: circa 9 tot 10 uur over 14 dagen**, afhankelijk van hoeveel gesprekken doorgaan. Zeven dagen kosten niets.

---

## 4. Mijn founder-tasks

Dit moet jij doen, niemand anders kan het.

| # | Actie | Dag | Tijd |
|---|---|---|---|
| 1 | Gmail-inbox checken op mail van Yvonne, dan de vijf vragen sturen | 1 | 15 min |
| 2 | Artikelconcept juridisch beoordelen, de vijf oordeelspunten | 1 | 45 min |
| 3 | Week 39 draften en goedkeuren | 1 en 4 | 2u 10 |
| 4 | Drie kantoren kiezen en benaderen | 4, 5, 6, 8 | 45 min |
| 5 | Drie diagnosegesprekken voeren | 8, 12, 13 | 2u 15 |
| 6 | Week 40 draften en goedkeuren | 8 en 11 | 1u 45 |
| 7 | Search Console dekkingsrapport lezen | 12 | 20 min |
| 8 | Vier X-posts handmatig plaatsen en bevestigen | 2, 7, 9, 14 | 40 min |
| 9 | Twee weekreviews | 7 en 14 | 1u 15 |

Wat ik doe zonder dat je erbij hoeft te zijn: contentdrafts voorbereiden, de analytics uitlezen en in het scoreboard zetten voordat de retentie van één maand verloopt, gespreksnotities structureren naar de vault, fase A uit sectie 8 voorbereiden en pas daarna de attributiespec uitwerken, en de beslisboom klaarzetten voor dag 14.

---

## 5. Yvonne validation script

### De benadering

Kort, geen onderwerp dat naar verkoop ruikt, geen bijlage, geen aanbod. Ze heeft op 4 september tien dagen op antwoord gewacht, dus begin met erkenning en niet met een vraag.

Onderwerp: **Even kort iets vragen over je account**

> Hoi Yvonne,
>
> Je bent op dit moment een van de eerste gebruikers van ZekerWet, en dat betekent dat jouw ervaring zwaarder weegt dan wat dan ook.
>
> Ik zou je vijf korte vragen willen stellen. Geen verkoopgesprek en geen prijsdiscussie: ik wil gewoon begrijpen wat je er wel en niet aan hebt.
>
> 1. Je hebt op 4 september meteen voor Business gekozen. Wat gaf toen de doorslag?
> 2. Wat had je in gedachten dat je ermee zou gaan doen?
> 3. Je hebt algemene voorwaarden opgesteld. Stonden er nog andere dingen op je lijstje?
> 4. Als er sinds begin september iets juridisch geregeld moest worden, hoe heb je dat toen aangepakt?
> 5. Wat zou er anders moeten zijn om ZekerWet nuttiger voor je te maken?
>
> Twee regels per vraag is meer dan genoeg. Als je liever tien minuten belt, dan kom ik graag langs je agenda.
>
> Met vriendelijke groet,
> ZekerWet

**Regel 17 uit de vault geldt hier**: check eerst of er nog een onbeantwoorde mail van haar in de Gmail-box ligt. Een vragenmail bovenop een openstaande supportvraag is erger dan geen mail.

### Wat elk antwoord betekent

| Vraag | Antwoord dat er toe doet | Wat het zou kunnen betekenen (n=1: richting, geen bewijs) |
|---|---|---|
| 1 | "Ik dacht dat de algemene voorwaarden alleen in Business zaten" | De Business-val wordt aannemelijker. De zes onjuiste claims worden dan urgent |
| 1 | "Ik wilde zeker weten dat het goed was" | Prijs is voor haar een kwaliteitssignaal, en een lage prijs werkt tegen je |
| 2 | Een lijst van meer dan één document | Er was meer behoefte dan gebruik; het probleem is activatie |
| 3 | "Nee, alleen dat ene" | Het probleem is frequentie en geen prijs. Losse verkoop past beter bij deze klantsoort |
| 4 | Een naam van een jurist, boekhouder of een andere tool | Dat is je echte concurrent, uit de mond van de enige klant die je hebt |
| 4 | "Niets, dat kwam niet voor" | Lage frequentie bevestigd |
| 5 | Wat dan ook concreets | De eerste echte productinput die er is |

Wat je noteert: de woordelijke zinnen, niet je samenvatting. Die gaan naar `Projects/ZekerWet/research/voc/`.

---

## 6. Accountant validation plan

### Uitgangspunt

**De hypothese.** Boekhouders en administratiekantoren krijgen regelmatig juridische of documentvragen van klanten die niet volledig binnen hun dienstverlening vallen, en [[ZekerWet]] zou een manier kunnen zijn om die klant toch iets bruikbaars mee te geven zonder dat het kantoor juridisch advies geeft. **HYPOTHESE**, nul gesprekken gevoerd.

**Hoe je begint en hoe niet.** Niet met "wij hebben een partnerprogramma". Niet met een demo. Niet met een aanbod. De openingszin is: *"Ik bouw iets voor ondernemers en ik wil je hersens een half uur lenen over hoe dat bij jullie loopt."*

**Geen referral fee ter sprake brengen.** RB artikel 15 verbiedt vergoedingen in enige vorm voor het bezorgen van opdrachten, inclusief kortingen en betalingen in natura boven symbolische waarde. Zolang dat niet juridisch is nagekeken voor een concrete constructie, komt er geen vergoeding op tafel. Een kantoorlicentie bespreken mag wel, want dat is een aankoop en geen vergoeding.

### De drie gesprekken

| | Gesprek 1 | Gesprek 2 | Gesprek 3 |
|---|---|---|---|
| **Kantoor** | Rosmalen, het warme contact | Oss, koud | Den Bosch of Uden, koud |
| **Dag** | 8 | 12 | 13 |
| **Doel** | Het probleem in hun woorden horen | Toetsen of gesprek 1 toeval was | Toetsen of kantoorgrootte iets uitmaakt |
| **Wat we willen weten** | Frequentie, type vraag, wat ze nu doen | Of hetzelfde patroon terugkomt | Of een groter kantoor het anders ziet |
| **Wat je noteert** | Woordelijke zinnen, aantallen per maand, waar ze naartoe verwijzen | Idem plus verschillen met gesprek 1 | Idem plus of ze al software doorgeven |

### De tien vragen

De eerste zes gaan over hun werk, pas daarna komt [[ZekerWet]] in beeld.

1. Welke juridische vragen krijgen jullie van klanten? Noem de laatste drie.
2. Hoe vaak per maand ongeveer?
3. Wat doen jullie er nu mee?
4. Waar verwijzen jullie naartoe, en wat gebeurt er daarna met die klant?
5. Wat kost zo'n vraag jullie aan tijd, ook als er niets voor gefactureerd wordt?
6. Wanneer zeggen jullie nee, en waarom precies?
7. Gebruiken jullie al software die je aan klanten doorgeeft? Welke, en hoe bevalt dat?
8. Zouden jullie zelf een licentie willen waarmee je documenten voor klanten kunt maken, of gaat dat te ver richting juridisch werk?
9. Bij welke vereniging zijn jullie aangesloten, en wat mag daar rond vergoedingen van derden?
10. Wat zou een samenwerking voor jullie onacceptabel maken?

### Sterke en zwakke signalen

| Sterk signaal | Zwak signaal, hypothese verzwakt |
|---|---|
| Ze noemen bij vraag 1 uit zichzelf drie concrete gevallen | Ze moeten lang nadenken of noemen iets van jaren geleden |
| Bij vraag 2 komt er een getal boven de twee per maand, of bij vraag 5 één vraag die hen veel tijd of een klant kost | "Zelden", "af en toe", geen getal |
| Bij vraag 4 raken ze de klant kwijt aan de partij waarnaar ze verwijzen | Ze hebben een vaste jurist waar het prima loopt |
| Bij vraag 5 noemen ze onbetaalde tijd | Ze factureren het gewoon |
| Bij vraag 7 geven ze al software door en dat bevalt | Ze geven principieel niets door |
| Bij vraag 8 vragen ze uit zichzelf wat het kost | Ze vinden het te veel richting juridisch advies |
| Ze vragen aan het eind of ze het mogen zien | Ze bedanken vriendelijk en er komt geen vervolgvraag |

**Het enige echte koopsignaal in een diagnosegesprek is dat ze zelf naar de prijs vragen.** Alles daarvoor is beleefdheid.

### Interne pilot-gate: van fase 1 naar fase 2

Dit is een interne pilot-gate, geen wetenschappelijk gevalideerde drempel: vier eigen afspraken om niet op gevoel een pilot te starten, want fase 2 kost echte tijd. De kwalitatieve sterkte van het probleem en de bereidheid tot een vervolgstap wegen zwaarder dan frequentie alleen. Een kantoor met één zeer kostbare juridische vraag per maand kan relevanter zijn dan een kantoor met meerdere lichte vragen; criterium 2 lees je daarom samen met vraag 5 (wat het ze kost) en met criterium 4.

1. **Minimaal twee van de drie kantoren noemen bij vraag 1 uit zichzelf concrete gevallen**, zonder dat jij een voorbeeld hebt gegeven.
2. **Minimaal twee van de drie noemen bij vraag 2 een frequentie van twee keer per maand of meer.**
3. **Minimaal één kantoor antwoordt op vraag 8 dat ze zo'n licentie zouden overwegen**, en licht toe waarom.
4. **Minimaal één kantoor is bereid drie eigen klanten aan te dragen** voor een pilot van zestig dagen.

Als er drie van de vier gelden, voer je een vierde gesprek voordat je iets beslist. Als er twee of minder gelden, is de hypothese verzwakt en gaat de tijd naar distributie. Uitzondering op de telling: één kantoor dat het probleem scherp beschrijft, er zelf tijd aan kwijt is en uit zichzelf naar een vervolgstap vraagt, weegt zwaarder dan drie kantoren die alleen een frequentie noemen.

### Fase 2 als de pilot-gate gehaald wordt

Eenvoudig houden. Drie tot vijf klanten van één kantoor, zestig dagen, een eigen landingspagina per kantoor zodat je het kunt terugzien, geen partnerstructuur, geen vergoeding, en op papier de grens: [[ZekerWet]] levert documenten en reviewoutput, geen juridisch advies, en het kantoor adviseert niet over de inhoud.

### Fase 3, wat je dan meet

Outreach, gesprekken, getoonde interesse, pilot gestart, aangemaakte accounts, gegenereerde documenten, betalende klanten, en retentie na 30, 60 en 90 dagen. Per kantoor, in één tabel in de vault. Geen dashboard bouwen.

---

## 7. Distribution plan

### Wat het bewijs zegt

| Kanaal | Bezoekers 17 aug tot 16 sep | Oordeel |
|---|---|---|
| LinkedIn, web plus Android | 24 | **Enig kanaal met aantoonbare beweging** |
| Facebook, web plus mobiel | 12 | Levert, maar vlak |
| Google | 6 | Beperkt, en indexering loopt nog |
| Instagram | 1 | Vrijwel niets |
| Direct of geen referrer | 70 | Grootste blok, niet toewijsbaar |

**BEWEZEN** dat 70 direct-bezoekers het grootste blok zijn. Dat is geen succes maar een meetprobleem: het bevat **WAARSCHIJNLIJK** jouw eigen bezoeken (niet uitgesloten in de meting), en sectie 8 en 9 lossen dat maar deels op; eigen verkeer uitsluiten staat apart in sectie 12.

### Het ritme voor veertien dagen

Niet meer posten dan nu. De cadans staat; of hij betrouwbaar publiceert blijkt per post uit de reconciler, en wat eraan ontbreekt is dat je kunt zien wat hij doet.

| Kanaal | Frequentie | Dagen in dit venster |
|---|---|---|
| LinkedIn | 2 per week, dinsdag en donderdag 07:45 | 17, 22, 24, 29 september |
| Facebook en Instagram | 1 per week, vrijdag 09:00 | 18, 25 september |
| X | 2 per week, woensdag en vrijdag, handmatig | 18, 23, 25, 30 september |
| Kennisbank | 1 artikel per week | week 39 en week 40 |

**Instagram blijft draaien maar krijgt geen extra aandacht.** Eén bezoeker in dertig dagen rechtvaardigt geen extra werk, en de carousel wordt toch al voor Facebook gemaakt.

### Per post

| Post | Kanaal | Type | Doel | CTA | Landingspagina | Tracking | Metric |
|---|---|---|---|---|---|---|---|
| Di 22 sep | LinkedIn | Wet DBA, legal-pain | Herkenning bij ZZP'ers | Lees waar het misgaat | `/kennisbank/wet-dba-zzp` | Eigen pad plus UTM | Bezoekers op dat pad |
| Do 24 sep | LinkedIn | AI-review, document-education | Laten zien wat het doet | Controleer je eigen contract | `/dashboard/review` via `/documenten/opdracht` | Eigen pad plus UTM | Bezoekers en aanmeldingen |
| Vr 25 sep | Facebook en Instagram | Carousel | Bereik | Bekijk het document | `/documenten/opdracht` | Eigen pad plus UTM | Bezoekers op dat pad |
| Di 29 sep | LinkedIn | **Rocket Lawyer-venster** | Overstappers vangen vóór 31 oktober | Zorg dat je je documenten nog hebt | Nieuw kennisbankartikel | Eigen pad, uniek | Bezoekers op dat ene pad |
| Wo en vr | X | Kort, losse post | Aanwezigheid | Wisselend | Documentpagina | Handmatig bevestigen | Bevestigde posts |
| Week 39 en 40 | Kennisbank | 1 artikel per week | Zoekintentie | Naar de documentpagina | Eigen artikel | Search Console | Vertoningen en klikken |

**Het Rocket Lawyer-venster.** Rocket Lawyer Nederland stopt op 31 oktober 2026 en klanten verliezen daar hun documenten. **BEWEZEN** via twee onafhankelijke bronpassages, al is de mededeling niet woordelijk op hun site geopend (**DATA GAP**). Dat is een venster van zes weken met een concrete aanleiding en een duidelijke doelgroep. Eén kennisbankartikel plus één LinkedIn-post in week 40, niet meer. Geen naam van de concurrent in de post: `B4_NAMED_COMPETITOR` blokkeert dat en terecht.

### Geen vanity metrics

Wat níet als KPI telt: vertoningen, likes, volgers, bereik. Wat wel telt: bezoekers op de landingspagina van die post, en of ze verder komen dan die pagina.

---

## 8. Attribution plan

### Het probleem in één alinea

> [!danger] Op Vercel Hobby is campagne-attributie in de analytics onmogelijk
> Custom events geven `402 Payment Required`: custom events vragen Pro of Enterprise. UTM-dimensies geven `402`: die vragen Enterprise of de Web Analytics Plus add-on. Analytics bewaart één maand, runtime-logs één uur. Gecontroleerd op 16 september 2026 tegen de live API. Elke UTM die het marketingsysteem zorgvuldig op elke post zet, is in Vercel onleesbaar. Hobby blijft, dus **attributie moet in Supabase landen en niet in Vercel.**

### Wat we NU kunnen meten, zonder één regel code

| Vraag | Antwoord vandaag |
|---|---|
| Waar kwam deze bezoeker vandaan? | Ja, op kanaalniveau via `referrerHostname` |
| Welke campagne of post bracht hem? | **Nee.** Wel een omweg: geef elke post een **uniek landingspad**, want `requestPath` werkt wel op Hobby. Eén post, één pagina, dan is het pad de campagne |
| Heeft hij een account gemaakt? | Ja, `User.createdAt` in Supabase |
| Heeft hij een document gemaakt? | Ja, `Document.createdAt` |
| Heeft hij checkout gestart? | **Nee** |
| Heeft hij betaald? | Ja, via Stripe en `stripeSubscriptionId` |
| Welk abonnement? | Ja, `stripePriceId` |
| Wanneer? | Ja, voor alles behalve checkout |
| Is hij actief gebleven? | Deels, via de laatste `Document` of `AiUsageLog`. Niet als hij alleen inlogt |

**Wat er ontbreekt is precies de brug**: welke bezoeker werd welke klant.

### Wat met een kleine technische aanpassing zou kunnen (kandidaatoplossing, nog niet getoetst)

De hele brug, met één patroon dat binnen de bestaande stack past en geen extra dienst nodig heeft. Dit is een kandidaat, geen besluit: fase A hieronder bepaalt of en in welke vorm het mag.

1. **Landing.** Bij binnenkomst worden `utm_source`, `utm_medium`, `utm_campaign`, `utm_content`, het landingspad en de referrer in een first-party cookie gezet, alleen als die cookie nog niet bestaat. Zo blijft de eerste bron staan, ook als iemand later direct terugkomt.
2. **Signup.** Op het moment dat het `User`-record wordt aangemaakt of gerepareerd in `checkSubscription`, wordt die cookie uitgelezen en weggeschreven naar vijf kolommen. Eén keer, nooit overschreven.
3. **Checkout.** `/api/stripe/checkout` is al een serverroute; daar wordt `checkout_started_at` gestempeld.
4. **Betaling.** De bestaande Stripe-webhook stempelt `paid_at`.

Geen `track()`, geen extra SaaS, geen analytics-stack. Maar dat dit een functionele first-party cookie zonder profilering is die zonder meer mag, is een **HYPOTHESE**, geen vaststelling. Of hij als noodzakelijk of functioneel geldt, of hij analytische verwerking is waarvoor toestemming nodig is, en of hij verenigbaar is met de huidige claim "cookieloze analytics" op de privacy- en cookiepagina, is niet getoetst (**DATA GAP**). Daarom in twee fasen, en fase B start niet vóór fase A is afgerond.

**Fase A, eerst controleren.** Geen code.

1. De huidige privacyverklaring: wat er staat over cookies, analytics en herkomstgegevens.
2. De cookieverklaring: welke categorieën ze noemt en wat ze uitsluit.
3. De huidige analyticsclaim ("cookieloze analytics") en of die na de ingreep nog waar is.
4. Noodzakelijke of functionele versus analytische verwerking: onder welke categorie een herkomstcookie valt die aan een account wordt gekoppeld.
5. Eventuele consentvereisten die daaruit volgen, en wat dat betekent voor een site die nu geen toestemmingsmechanisme heeft.
6. Welke UTM-data daadwerkelijk nodig is: mogelijk volstaan `first_source` en `first_content` en vervalt de rest.

Dit plan bevat niet genoeg informatie om dit juridisch of privacytechnisch te bepalen: **DATA GAP**. De uitkomst van fase A is een korte notitie met per punt het antwoord en de bron, en pas daarna een besluit.

**Fase B, daarna pas technische implementatie.** De vier stappen hierboven, in de vorm die fase A toelaat. Wijst fase A uit dat de cookie niet zonder toestemming kan, dan is de terugvaloptie het unieke landingspad per post (werkt op Hobby, geen cookie), eventueel met een serverzijdige vastlegging van referrer en landingspad op het moment van aanmelden; ook die variant gaat eerst langs fase A.

### Wat we pas later nodig hebben

Sessie-attributie, multi-touch, cohortretentie, een dashboard. Niets daarvan binnen deze veertien dagen, en waarschijnlijk pas boven de vijftig klanten.

---

## 9. Minimale technische meetlaag

Alleen velden die iets beantwoorden dat je anders niet kunt weten. Alles wat af te leiden is met een query krijgt géén kolom. Dat scheelt de helft van de voorgestelde lijst.

### Wel opnemen

| Veld | Waarom | Bron | Waar | Wanneer vullen | Nu nodig? |
|---|---|---|---|---|---|
| `first_source` | Welk kanaal levert klanten | UTM of referrer | `User` | Bij aanmaken, één keer | **Ja** |
| `first_medium` | Onderscheid organisch, social, mail | UTM | `User` | Idem | **Ja** |
| `first_campaign` | Welke campagne | UTM | `User` | Idem | **Ja** |
| `first_content` | **Welke post.** Dit is het veld dat Vercel niet kan geven | UTM | `User` | Idem | **Ja** |
| `landing_page` | Waar hij binnenkwam | Request | `User` | Idem | **Ja** |
| `checkout_started_at` | De enige onmeetbare trechterstap | Serverroute | `User` | Bij checkout-aanroep | **Ja** |
| `paid_at` | Exacte conversiedatum, los van periode-einde | Stripe-webhook | `User` | Bij `checkout.session.completed` | **Ja** |
| `last_active_at` | Retentie zonder documentactie | Sessie | `User` | Bij `/api/subscription` | Nee, later |

### Bewust níet opnemen

| Veld uit het voorstel | Waarom niet |
|---|---|
| `signup_at` | Bestaat al als `User.createdAt` |
| `email_verified_at` | Zit in Clerk, daar ophalen als je het nodig hebt |
| `plan` en `billing_period` | Af te leiden uit `stripePriceId` en `YEARLY_PRICE_IDS` |
| `documents_created`, `document_types` | Een `COUNT` en een `GROUP BY` op `Document`. Een kolom zou kunnen ontsporen |
| `first_document_at` | `MIN(createdAt)` op `Document` |
| `first_ai_review_at`, `ai_reviews` | `AiUsageLog` heeft dit al per rij |
| `cancellation_at` | Stripe weet dit |
| `churn_reason` | **Zet de opzegvragenlijst aan in de Stripe Billing Portal.** Nul code, Stripe verzamelt de reden zelf |

**Netto: vijf kolommen, twee stempels, één Stripe-instelling.** Dat is de hele meetlaag, en hij wordt pas gebouwd nadat fase A uit sectie 8 is afgerond.

### Rapportage

Geen dashboard. Eén opgeslagen SQL-query in de Supabase-editor die de tabel uit sectie 13 vult. Je draait hem bij de weekreview.

---

## 10. UTM convention

### De regels

- Alles kleine letters, woorden gescheiden door een streepje, geen spaties, geen hoofdletters.
- `utm_source` is het platform. `utm_medium` is de soort. `utm_campaign` is het thema en loopt over meerdere posts. `utm_content` is **uniek per post** en gelijk aan de content-id uit de contentstore.
- `utm_content` is de sleutel: hij is al gelijk aan de bestandsnaam van het contentobject, dus de koppeling tussen post en bezoeker is gratis zodra het veld wordt opgeslagen.
- De validatiepoort dwingt dit al af via `U1_NO_TAGGED_URL`, `U2_UTM_MISMATCH`, `U3_UTM_INVALID` en `U4_UTM_ON_ARTICLE`. Er hoeft niets aan de conventie te veranderen; ze moet alleen leesbaar worden.

### Waarden

| Veld | Toegestaan |
|---|---|
| `utm_source` | `linkedin`, `facebook`, `instagram`, `x`, `google`, `partner`, `email` |
| `utm_medium` | `social-organic`, `organic`, `referral`, `email`, `print` |
| `utm_campaign` | Thema, bijvoorbeeld `wetdba-handhaving-2026` |
| `utm_content` | De content-id, bijvoorbeeld `2026-09-22-linkedin-wetdba-gezag` |

### Tien voorbeelden

```
1.  LinkedIn di 22 sep
    /kennisbank/wet-dba-zzp?utm_source=linkedin&utm_medium=social-organic
    &utm_campaign=wetdba-handhaving-2026&utm_content=2026-09-22-linkedin-wetdba

2.  LinkedIn do 24 sep
    /documenten/opdracht?utm_source=linkedin&utm_medium=social-organic
    &utm_campaign=ai-review&utm_content=2026-09-24-linkedin-ai-review

3.  Facebook carousel vr 25 sep
    /documenten/opdracht?utm_source=facebook&utm_medium=social-organic
    &utm_campaign=wetdba-handhaving-2026&utm_content=2026-09-25-facebook-carousel

4.  Instagram carousel vr 25 sep
    /documenten/opdracht?utm_source=instagram&utm_medium=social-organic
    &utm_campaign=wetdba-handhaving-2026&utm_content=2026-09-25-instagram-carousel

5.  X wo 23 sep
    /documenten/opdracht?utm_source=x&utm_medium=social-organic
    &utm_campaign=wetdba-handhaving-2026&utm_content=2026-09-23-x-gezag

6.  Rocket Lawyer-venster, LinkedIn di 29 sep
    /kennisbank/documenten-overzetten?utm_source=linkedin&utm_medium=social-organic
    &utm_campaign=overstap-2026&utm_content=2026-09-29-linkedin-overstap

7.  Google, organisch, geen UTM
    /kennisbank/aanzegbrief-voorbeeld

8.  Kantoor Rosmalen
    /?utm_source=partner&utm_medium=referral
    &utm_campaign=kantoren-2026&utm_content=kantoor-rosmalen-01

9.  Kantoor Oss
    /?utm_source=partner&utm_medium=referral
    &utm_campaign=kantoren-2026&utm_content=kantoor-oss-02

10. Mail aan Yvonne, indien ooit een link nodig
    /dashboard?utm_source=email&utm_medium=email
    &utm_campaign=klantvalidatie&utm_content=yvonne-vijf-vragen
```

**Regel voor kantoren.** Elk kantoor krijgt een eigen `utm_content` met een volgnummer. Dat is de enige manier om per kantoor te kunnen meten, en het werkt pas zodra `first_content` wordt opgeslagen.

**Regel 7 is bewust zonder UTM.** `U4_UTM_ON_ARTICLE` blokkeert UTM op een organische zoekbestemming, en dat is juist: je wilt geen UTM in de zoekindex.

---

## 11. Content quality gate

**Deze bestaat al en heeft 24 regels.** Voordat er iets gebouwd wordt: dit is wat `marketing/validate/rules.ts` vandaag al afdwingt.

| Gevraagde controle | Bestaande regel | Ernst |
|---|---|---|
| Geen ONTBREEKT | `S1_PLACEHOLDER` | blokkeert |
| Geen "niet ingevuld" | `S1_PLACEHOLDER` | blokkeert |
| Geen TODO | `S1_PLACEHOLDER` (ook TBD, FIXME, PLACEHOLDER) | blokkeert |
| Geen lorem ipsum | `S1_PLACEHOLDER` | blokkeert |
| Geen `[NAAM]` of `[LINK]` | `S2_TEMPLATE_SYNTAX` | blokkeert |
| Geen `{{variable}}` | `S2_TEMPLATE_SYNTAX` (ook `${}` en `<VAR>`) | blokkeert |
| Correcte URL | `U1_NO_TAGGED_URL` | blokkeert |
| Correcte UTM | `U2`, `U3`, `U4` | blokkeert |
| Geen duplicaat | `D1` tot en met `D6` | blokkeert of signaleert |
| Juiste platformformattering | `S5_TOO_SHORT`, `S6_TOO_LONG`, `S8_ASSET_COUNT`, `B1_EMOJI` | blokkeert of signaleert |
| Geen onbewezen productclaim | `claims.json` plus `B4_NAMED_COMPETITOR` en `B5_MISSING_DISCLAIMER` | blokkeert of signaleert |
| Geen testpost | `S3_TEST_MARKER` | blokkeert |
| Geen lege body | `S4_EMPTY_BODY` | blokkeert |
| Geen interne gegevens | `S7_INTERNAL_LEAKAGE`, Stripe-sleutels en object-id's | blokkeert |

### De twee echte gaten

1. **"CTA aanwezig" wordt niet als zodanig gecontroleerd.** `U1_NO_TAGGED_URL` eist een getagde URL, wat in de praktijk bijna altijd de CTA is, maar een post met alleen een kale link en geen aansporing komt erdoor.
2. **De letterlijke woorden `null` en `undefined` in de tekst worden niet gevangen.** Ze staan niet in `HARD_TOKENS` en niet in `LEAKAGE`.

Beide zijn klein. **Niet nu bouwen**: ze horen op de lijst voor ná dag 14, en alleen als er ooit een post op stukloopt.

### Waar het historische probleem werkelijk zat

De audit liet zien dat monitoring naar de planning en het logboek keek en niet naar werkelijke publicatie. Dat is opgelost door de reconciler, die verifieert tegen een echte URL. Wat blijft: **X is handmatig en telt pas als jij bevestigt.** Dat is geen gat in de poort maar een gat in de gewoonte, en het staat daarom vier keer als taak in het dagplan.

---

## 12. Conversion funnel

| Stap | Metric | Wat we nu weten | Wat ontbreekt | Gewenste meting | Mogelijke bottleneck |
|---|---|---|---|---|---|
| **Impression** | Vertoningen per post | Niets | Alles | LinkedIn-statistieken, handmatig | Bereik |
| **Click** | Bezoekers per post | Alleen per kanaal: LinkedIn 24, Facebook 12 | Per post | Uniek landingspad, later `first_content` | Hook |
| **Landing page** | Bezoekers per pad | `/` 62, `/documenten` 12, `/documenten/opdracht` 8, kennisbank circa 23 | Bouncegedrag | `requestPath`, maandelijks uitlezen | Pagina overtuigt niet |
| **Sign-up** | Aanmeldpogingen | `/sign-up` 3 bezoekers | Hoeveel slaagden | `User.createdAt` naast pageviews | **HYPOTHESE**, n=1 |
| **Email verification** | Geverifieerd | `/sign-up/verify-email-address` 3 bezoekers, 7 pageviews | Slagingspercentage | Clerk | Code komt niet aan, dat is bij Yvonne gebeurd |
| **Dashboard** | Eerste bezoek | `/dashboard` 15 bezoekers, grotendeels eigen gebruik | Onderscheid eigen en echt | Eigen account uitsluiten | Leegte bij binnenkomst |
| **First document** | Eerste generatie | 1 klant, 1 document | Tijd tot eerste document | `MIN(Document.createdAt)` per user | **HYPOTHESE**, n=1 |
| **Checkout** | Checkout gestart | **Niets** | Alles | `checkout_started_at` | Onbekend |
| **Paid** | Betalende klanten | 1 | Conversie vanaf welke stap | Stripe naast attributie | Onbekend |
| **Repeat usage** | Tweede document | 0 van 1 | Alles | `COUNT(Document)` per user | **Bekend probleem**: Yvonne kwam niet terug |
| **Renewal** | Tweede maand betaald | Eerste verlenging valt 4 oktober | Alles | Stripe | Onbekend |

> [!warning] Waar hier geen conclusies uit getrokken mogen worden
> Elke stap onder de homepage heeft eencijferige aantallen. Acht bezoekers op de prijspagina, drie op aanmelden, één klant. Een percentage berekenen over die getallen geeft een cijfer dat overtuigend oogt en niets betekent. De twee stappen die als "waarschijnlijk hier" staan gemarkeerd zijn een vermoeden op basis van één klant, geen meting. Behandel deze tabel tot dag 14 als een lijst van wat we willen weten, niet als een diagnose.

---

## 13. 14-daags scoreboard

Baselines zijn gemeten over 17 augustus tot en met 16 september. Targets zijn geen voorspellingen en geen benchmarks: het is het niveau waarboven iets een signaal is in plaats van ruis.

| Categorie | Metric | Baseline (30d) | Target (14d) | Wat we ermee leren |
|---|---|---|---|---|
| **Traffic** | Bezoekers totaal | circa 100 tot 120 | 80+ | Of de cadans verkeer vasthoudt |
| | LinkedIn-bezoekers | 24 (dagcijfers tellen op tot 26, zie P2) | 40+ | Of de piek van 14 tot 16 sep herhaalbaar is; signaleringsdrempel, geen kanaaloordeel |
| | Kennisbank-bezoekers | circa 23 | 30+ | Of SEO begint te dragen |
| | Bezoekers op `/pricing` | 8 | 15+ | Of prijs überhaupt gezien wordt |
| **Acquisition** | Aanmeldingen | 3 | 5+ | Of verkeer in accounts omzet |
| | Geverifieerde accounts | onbekend | alle nieuwe | Of de Clerk-verificatie blijft haperen |
| | Accounts met herkomst | 0% | 100% van nieuwe, alleen als fase B uit sectie 8 landt | Of de attributielaag werkt |
| **Activation** | Eerste document | 1 klant ooit | 2+ nieuwe | Of nieuwe accounts iets doen |
| | Tijd tot eerste document | 5 uur (n=1) | meten | Waar onboarding hapert |
| **Revenue** | Checkout gestart | onmeetbaar | meetbaar maken | De ontbrekende trechterstap |
| | Betalende klanten | 1 | 1+ | Elke tweede klant verdubbelt de dataset |
| | MRR netto | 41,31 | 41,31+ | Verlenging van 4 oktober valt buiten dit venster |
| **Product** | Documenten per gebruiker | 1,0 (n=1) | meten | Of volumegrendels ooit zin hebben |
| | AI-reviews door klanten | 0 | 1+ | Of de onderscheidende functie gebruikt wordt |
| **Retention** | Terugkerende gebruikers | 1 van 1 | meten | Of mensen een tweede keer komen |
| **Distribution** | LinkedIn-posts geplaatst | 2 per week | 4 | Of de cadans blijft draaien |
| | Kantoorgesprekken | 0 | **3** | De hele kanaalhypothese |
| | Kantoorpilots | 0 | 0 of 1 | Alleen als de interne pilot-gate uit sectie 6 gehaald wordt |
| | Yvonne-antwoorden | 0 | 5 | De enige echte klantdata die bestaat |

**Over de targets.** "40+ LinkedIn-bezoekers" is uitsluitend een operationele signaleringsdrempel, geen voorspelling en geen bewijs dat LinkedIn een goed kanaal is: 40+ bezoekers is voldoende activiteit om het kanaal verder te analyseren, maar bewijst geen kanaalkwaliteit, koopintentie of schaalbaarheid. De drempel ligt boven de 26 van één losse piek. "3 kantoorgesprekken" is het enige getal in deze tabel dat volledig binnen je eigen invloed ligt, en daarmee het enige waarop je jezelf eerlijk kunt afrekenen.

---

## 14. Decision tree

Op dag 14 doorloop je deze boom. Geen automatische pricingconclusie, in geen enkele tak.

**Traffic stijgt, aanmeldingen niet.**
→ Het probleem zit dan waarschijnlijk tussen landingspagina en aanmelden. Volgende fase: de landingspagina en de aanmeldstap onderzoeken, niet de prijs.

**Aanmeldingen stijgen, documentgebruik niet.**
→ Activatieprobleem. Volgende fase: de eerste vijf minuten na aanmelden bekijken. Dit is precies wat bij [[Yvonne Heiligers]] misging.

**Documentgebruik goed, betaling niet.**
→ Dan pas wordt het aanbod interessant. Volgende fase: onderzoeken waar de betaalstap afketst. **Nog steeds geen prijswijziging**: eerst weten of het de prijs is, het moment, of het vertrouwen.

**Er komt een tweede betalende klant.**
→ Direct dezelfde vijf vragen als aan Yvonne, plus retentie volgen. Twee klanten is nog geen dataset, maar het is een verdubbeling.

**Kantoren tonen interesse, interne pilot-gate uit sectie 6 gehaald.**
→ Fase 2: één pilot ontwerpen met één kantoor. Geen partnerstructuur, geen vergoeding.

**Kantoren herkennen het probleem niet.**
→ Hypothese herzien en opschrijven waarom. De tijd gaat naar LinkedIn en kennisbank. Dit is een goede uitkomst: hij kost twee weken en bespaart maanden.

**Attributie werkt nog niet op dag 14.**
→ Dat wordt de enige prioriteit voor de volgende periode. Zonder die laag is elke volgende veertien dagen opnieuw ongemeten.

**Er is nauwelijks gepubliceerd.**
→ Het probleem is distributiecapaciteit en niet distributiestrategie. Volgende fase: uitzoeken wat het publiceren blokkeerde, want het systeem is er.

**Search Console laat op 28 september nog steeds niets zien.**
→ Technische indexeringscontrole vóór er meer artikelen worden geschreven. Eén artikel per week schrijven dat niet geïndexeerd wordt, is de duurste bezigheid in dit plan.

---

## 15. What not to do

De komende veertien dagen gebeurt geen van deze dingen. Elk punt volgt uit het besliskader.

1. **Geen pricingwijziging.** Vier criteria uit het besliskader staan open, geen daarvan is gehaald.
2. **Geen nieuwe pricingarchitectuur bouwen.** Zeven scenario's, nul data om ze mee te wegen.
3. **Geen creditsysteem.** Aantrekkelijk model, maar de spreiding in documentgebruik is onbekend bij één klant.
4. **Geen seat-model.** Nul signalen dat iemand meerdere gebruikers wil.
5. **Geen white label.** Nul kantoorgesprekken gevoerd.
6. **Geen redesign.** Er is geen enkel bewijs dat vormgeving het knelpunt is.
7. **Geen nieuw concurrentieonderzoek.** 38 partijen onderzocht. Genoeg.
8. **Geen referral fee of provisie noemen.** RB artikel 15, en juridische toetsing ontbreekt nog.
9. **Geen herbouw van de marketingautomatisering.** De poort heeft 24 regels, nagekeken in `rules.ts`.
10. **Geen nieuwe analytics-SaaS.** Vijf kolommen in Supabase doen naar verwachting wat nodig is, na fase A uit sectie 8.
11. **Geen massale outreach.** Drie gesprekken, en pas daarna meer.
12. **Geen ongevalideerde claims.** `claims.json` blijft leidend, ook in gesprekken met kantoren.
13. **Geen conclusies over prijselasticiteit.** Acht bezoekers op de prijspagina.
14. **Geen vanity metrics als bewijs.** Vertoningen, likes en volgers tellen niet mee in het scoreboard.
15. **Geen extra kanaal openen.** Geen TikTok, geen advertenties, geen nieuwsbrief. LinkedIn is het enige kanaal met een aantoonbare bezoekerspiek.

---

## 16. Pricing parking lot

Tien onderwerpen: zeven geparkeerd met een trigger die ze weer opent, drie open als juistheidsvraag.

| Onderwerp | Status | Waarom niet nu | Welke data ontbreekt | Trigger |
|---|---|---|---|---|
| **Nieuwe prijsstructuur** | Geparkeerd | Zeven scenario's, geen weegmiddel | Conversie, churn, elasticiteit | Alle vier criteria uit het besliskader |
| **Annual billing** | **Half open** | Presentatie mag wel, prijs niet | Aandeel dat jaar kiest | 30 verkopen, of direct de toggle omzetten als presentatietest |
| **Losse documentprijzen** | Geparkeerd | Nul verkopen | Welk type, welke prijs | 20 aankopen |
| **Levenslange toegang repareren** | Geparkeerd | Je repareert iets dat niemand gebruikt | Herhaalgeneraties | Eerste losse verkoop |
| **Credits** | Geparkeerd | Spreiding onbekend | Documenten per gebruiker per maand | 20 klanten, 3 maanden |
| **Tiers en de zes onjuiste claims** | **Open, los van pricing** | Dit is geen prijsvraag maar een juistheidsvraag | Geen | Nu al te beslissen |
| **Kantoorlicentie** | Geparkeerd | Nul gesprekken | Of kantoren het willen | Vraag 8 uit drie gesprekken |
| **BTW en B2B-presentatie** | Geparkeerd | Zit vast aan de 55 particuliere documenten, plus drie open juridische vragen | Juridische toetsing | Antwoord op de drie vragen uit het besliskader |
| **Enterprise** | **Open, los van pricing** | Drie van zes verkoopargumenten bestaan niet, bij nul klanten | Geen | Nu al te beslissen |
| **AI-limieten** | **Open, los van pricing** | Beschermen minder dan een cent | Geen | Nu al te beslissen |

**Let op het verschil.** Drie regels staan op "open, los van pricing": de onjuiste claims, Enterprise en de AI-limieten. Dat zijn geen prijsbeslissingen maar correcties op dingen die aantoonbaar niet kloppen. Ze staan hier zodat ze niet per ongeluk mee geparkeerd worden.

**En de regel die eronder ligt**: we veranderen de prijs niet omdat concurrenten duurder zijn. De markt loopt van 24,75 per jaar bij ZZP Nederland tot 948 bij Lawsy. Uit die spreiding volgt geen prijs.

---

## 17. Weekly review template

Maximaal dertig minuten. Dag 7 en dag 14. Ik vul vooraf het scoreboard, jij beantwoordt de tien vragen.

```
WEEKREVIEW ZEKERWET — week [nr], [datum]
Tijd: max 30 minuten

SCOREBOARD (door Claude vooraf ingevuld)
[tabel uit sectie 13]

1. WAT GEBEURDE ER?
   Drie regels. Alleen feiten.

2. WELKE DATA HEBBEN WE?
   Wat is er bij gekomen sinds vorige week. Wat is er nog steeds niet.

3. WAT WERKTE?
   Alleen als er een cijfer bij staat.

4. WAT WERKTE NIET?
   Idem.

5. WELKE HYPOTHESE KREEG STEUN?
   Benoem de hypothese en het bewijs.

6. WELKE HYPOTHESE WERD ZWAKKER?
   Idem. Dit veld leeg laten is een waarschuwing.

7. WAT STOPPEN WE VOLGENDE WEEK?
   Minimaal één ding.

8. WAT STARTEN WE VOLGENDE WEEK?
   Maximaal twee dingen.

9. WELKE TECHNISCHE MEETPROBLEMEN MOETEN OPGELOST?
   Concreet, met bestandsnaam waar mogelijk.

10. IS ER REDEN OM PRICING OPNIEUW TE BEKIJKEN?
    Standaardantwoord is NEE.
    JA mag alleen als een trigger uit sectie 16 is geraakt.
    Noem dan welke.
```

**Vraag 6 is de belangrijkste.** Een review waarin nooit een hypothese zwakker wordt, meet niets.

---

## 18. Prioriteitsmatrix

| Actie | Impact | Inspanning | Prioriteit | Eigenaar | Dag |
|---|---|---|---|---|---|
| Vijf vragen naar Yvonne | HIGH | LOW | **HIGH** | IK | 1 |
| Week 39 draften en goedkeuren | HIGH | MEDIUM | **HIGH** | SAMEN | 1 en 4 |
| Drie kantoren benaderen | HIGH | LOW | **HIGH** | IK | 4 tot 8 |
| Drie diagnosegesprekken | HIGH | MEDIUM | **HIGH** | IK | 8, 12, 13 |
| Fase A privacycheck, daarna attributiespec (sectie 8) | HIGH | LOW | **HIGH** | CLAUDE | 2 tot 6 |
| Analytics uitlezen vóór retentie verloopt | HIGH | LOW | **HIGH** | CLAUDE | 7 en 14 |
| Search Console dekkingsrapport | MEDIUM | LOW | **HIGH** | SAMEN | 12 |
| Artikelconcept beoordelen en plaatsen | MEDIUM | MEDIUM | MEDIUM | IK | 1 |
| `wet-dba-zzp.tsx` en `claims.json` corrigeren | MEDIUM | LOW | MEDIUM | CLAUDE | 1 |
| Week 40 draften en goedkeuren | MEDIUM | MEDIUM | MEDIUM | SAMEN | 8 en 11 |
| Rocket Lawyer-artikel schrijven | MEDIUM | MEDIUM | MEDIUM | SAMEN | 8 |
| Vier X-posts plaatsen en bevestigen | LOW | LOW | MEDIUM | IK | 2, 7, 9, 14 |
| Twee weekreviews | MEDIUM | LOW | MEDIUM | SAMEN | 7 en 14 |
| Unieke landingspaden per post | MEDIUM | LOW | MEDIUM | SAMEN | vanaf 6 |
| Gmail-box opschonen | LOW | LOW | LOW | IK | wanneer het uitkomt |
| Sid van [[Murmurly]] afhandelen of archiveren | LOW | LOW | LOW | IK | wanneer het uitkomt |
| CTA-check en null-check aan de poort | LOW | LOW | LOW | CLAUDE | na dag 14 |

---

## 19. Exacte checklist voor dag 1

Donderdag 17 september. Afvinken in deze volgorde.

```
[ ]  1. Gmail openen. Zoek op afzender Yvonne Heiligers.
        Ligt er nog een onbeantwoorde mail? Eerst die beantwoorden.
        (Vaultregel 17: eerst de inbox, dan de klantmail.)

[ ]  2. De vijf vragen sturen. Tekst staat in sectie 5.
        Niets toevoegen, niets aanbieden.                       15 min

[ ]  3. Controleren of de LinkedIn-post van vanochtend 07:45
        (2026-09-17-linkedin-ai-review-opdracht) live staat.
        Zo niet: kijken of Buffer hem heeft verzonden.           5 min

[ ]  4. Artikelconcept modelovereenkomst-zzp-2026 openen.
        De vijf oordeelspunten onderaan beantwoorden.
        Dit is juridisch oordeel, dat kan ik niet voor je doen.  45 min

[ ]  5. Akkoord geven op de twee repo-correcties:
        wet-dba-zzp.tsx titel naar 2026 plus modelovereenkomst-
        alinea, en claims.json wet-dba naar 1 januari 2025.
        Ik voer ze uit zodra je ja zegt.                          5 min

[ ]  6. Week 39 draften. Ik lever de concepten, jij leest mee
        en stuurt bij op toon en inhoud.                      1u 15

[ ]  7. Week 39 door de validatiepoort halen.
        Nul blokkades voordat je stopt.                          10 min

[ ]  8. Dit plan doorlezen en zeggen welke van de drie
        "open, los van pricing" punten uit sectie 16 je
        wilt aanpakken: de zes claims, Enterprise, de AI-limieten.
        Geen uitvoering vandaag, alleen je keuze.                10 min
```

**Totaal: ongeveer 2 uur 45.** Alles daarna in de veertien dagen is lichter.

---

## 20. Wat ik op dag 1 als eerste moet doen

> [!check] De eerste drie handelingen, in deze volgorde, samen 20 minuten
> **Eén.** Gmail openen en zoeken op Yvonne Heiligers. Ligt er nog iets open, dan beantwoord je dat eerst. Ligt er niets open, door naar twee.
>
> **Twee.** De mail met de vijf vragen versturen. De tekst staat kant-en-klaar in sectie 5 van dit document. Niets toevoegen, geen aanbod, geen korting, geen excuses. Dit is de enige echte klantdata die bestaat en hij ligt sinds 4 september op je te wachten.
>
> **Drie.** Kijken of de LinkedIn-post van 07:45 live staat.

Waarom precies dit als eerste, en niet het artikel of week 39: die twee kun je vanmiddag nog doen. De mail aan Yvonne kan pas iets opleveren als hij weg is, en elk uur dat hij blijft liggen is een uur dat je niet aan het leren bent. Het is vijftien minuten werk en waarschijnlijk een van de acties met de hoogste leerwaarde per minuut, omdat zij momenteel de enige betalende klant is.

Daarna pak je punt 4 van de checklist op.

---

## Wat dit plan bewust niet oplost

**DATA GAP**, zodat het niet als vergeten wordt gelezen:

- De vaste kosten van Supabase, Resend en Sentry zijn nog steeds onbekend. Winst is dus nog steeds niet te berekenen.
- De CPU-tijd per PDF-generatie is niet gemeten, en of Vercel Observability dat op Hobby toont is niet geverifieerd.
- De drie juridische vragen rond BTW en consumentenuitsluiting staan open.
- Of een first-party attributiecookie zonder toestemming mag en verenigbaar is met de huidige claim "cookieloze analytics" op de privacy- en cookiepagina: fase A uit sectie 8, nog niet gestart. Tot die tijd is de attributielaag een kandidaat, geen plan.
- Het verschil tussen 24 LinkedIn-bezoekers in de 30-daagse referrer-telling en 26 in de som van de dagcijfers (14 tot 16 september) is niet verklaard.
- Of het marketingsysteem end-to-end betrouwbaar publiceert: de post van 17 september 07:45 is de eerste controle onder de reconciler.
- De sluitingsmededeling van Rocket Lawyer Nederland is via zoekresultaten bevestigd maar niet woordelijk op hun eigen site geopend.

Gerelateerd: [[ZekerWet]], [[pricing-besliskader-2026-09-16]], [[pricing-marktonderzoek-2026-09-16]], [[masterplan-commercieel-2026-09-16]], [[kanaal-boekhouders]], [[klant-yvonne-heiligers]], [[seo-indexering-2026-09-14]], [[ZekerWet-concurrenten]]
