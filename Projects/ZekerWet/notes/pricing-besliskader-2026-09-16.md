---
type: besliskader
date: 2026-09-16
status: ter besluitvorming
tags: [pricing, meetplan, experimenten, datagap]
project: ZekerWet
---

Besliskader voor de pricingkeuze van [[ZekerWet]]. Volgt op [[masterplan-commercieel-2026-09-16]] en [[pricing-marktonderzoek-2026-09-16]]. Niets gewijzigd: geen code, geen prijzen, geen pricingpagina, geen Stripe, geen database, geen outreach, geen Buffer.

De vraag is niet meer "wat doet de markt". Die is beantwoord. De vraag is: **welke informatie missen we nog om met redelijke zekerheid een pricingstructuur te kiezen, en hoe komen we daar het goedkoopst aan?**

Labels: **BEWEZEN** (code, eigen klantdata of primaire marktbron), **WAARSCHIJNLIJK** (sterke aanwijzing, niet bewezen vóór [[ZekerWet]]), **HYPOTHESE** (moet getest).

---

## 0. Wat deze ronde aan nieuwe feiten opleverde

Voor het eerst is de eigen analytics uitgelezen in plaats van erover gepraat. Drie dingen kwamen eruit die het hele meetplan veranderen.

> [!danger] Op Vercel Hobby is de helft van het meetplan technisch geblokkeerd
> Custom events geven `402 Payment Required`: "Accessing Analytics custom events requires an Enterprise or Pro plan." UTM-dimensies geven `402`: "UTM dimensions require an Enterprise plan or the Web Analytics Plus add-on." Analytics bewaart op Hobby één maand data en runtime-logs één uur. Gecontroleerd op 16 september 2026 tegen de live API. **Elke UTM-tag die het marketingsysteem sinds 9 september zorgvuldig op elke post zet, is in Vercel Analytics op dit moment onleesbaar.** Dat is geen argument om nu naar Pro te gaan, dat besluit staat vast. Het betekent wel dat attributie in de eigen database moet landen en niet uit Vercel te halen is, en dat maakt de vier attributiekolommen op `User` van een wens tot de enige werkende route.

**Wat wél werkt op Hobby**: pad, referrer, land, apparaat, browser en route. Dat is genoeg voor een grove trechter, niet voor campagne-attributie.

**Er staat geen enkele `track()`-aanroep in de codebase.** `<Analytics />` hangt in `layout.tsx` en verzamelt pageviews, meer niet. Er is geen event bij checkout starten, plan kiezen, jaar of maand kiezen, of abonnement afronden. **BEWEZEN**

---

## 1. De zeven scenario's, herbeoordeeld

Geen rangorde, geen score, geen winnaar. Per scenario staat wat het beweert en wat het zou kosten om erachter te komen of dat klopt.

### Scenario A. Eén eenvoudig abonnement

| | |
|---|---|
| **Hypothese** | Tierverwarring kost meer conversie dan een tweede tier aan ARPU oplevert |
| **Wie betaalt** | ZZP'er en klein MKB, één prijs voor iedereen |
| **Welk probleem** | De zes onjuiste claims in `PLAN_TIERS` en de Business-val verdwijnen in één klap |
| **Waar komt omzet vandaan** | Niet uit ARPU maar uit conversie: minder keuzes, minder afhaken |
| **Conversierisico** | Laag. Eén prijs is de simpelste pagina die er is |
| **Churnrisico** | Laag, maar geen upgradepad betekent ook geen ARPU-groei per klant |
| **Data nodig** | Of bezoekers werkelijk afhaken op de tierkeuze |
| **Goedkoop te krijgen** | Pad-analytics laat nu al zien hoeveel mensen `/pricing` bezoeken en niet verder komen. Bij 8 bezoekers per maand is dat richtingsgevoel, geen bewijs |
| **Technisch** | Klein: `PLAN_TIERS` terug naar één, prijs-ID's opruimen |
| **Commercieel** | Groot: je geeft de mogelijkheid van een hoger segment op |

### Scenario B. Abonnement plus credits

| | |
|---|---|
| **Hypothese** | Gebruikers verschillen genoeg in volume dat credits meer opleveren dan ze aan conversie kosten |
| **Wie betaalt** | De zware gebruiker betaalt meer, de lichte minder |
| **Welk probleem** | Geen enkele grendel die met waarde meebeweegt |
| **Waar komt omzet vandaan** | Bijkopen door zware gebruikers, zoals VraagHugo's staffels van 99 tot 999 |
| **Conversierisico** | Middel tot hoog. Credits zijn een extra concept bovenop een product dat al uitleg vraagt |
| **Churnrisico** | Reëel: wie halverwege de maand leegloopt voelt zich geknepen |
| **Data nodig** | De spreiding in documenten per gebruiker per maand. Zonder die verdeling is elke creditprijs een gok |
| **Goedkoop te krijgen** | Tellen in de `Document`-tabel per gebruiker per maand. Kost één query, maar er is nu één klant met één document |
| **Technisch** | Groot: creditsaldo, verbruik per generatie, bijkoopflow |
| **Commercieel** | Middel: de prijscommunicatie wordt ingewikkelder |

### Scenario C. Abonnement plus losse documenten, gerepareerd

| | |
|---|---|
| **Hypothese** | Losse verkoop is een instapkanaal dat nu lekt en niet naar het abonnement leidt |
| **Wie betaalt** | De incidentele koper, die daarna abonnee kan worden |
| **Welk probleem** | Levenslange toegang per documenttype voor 14,99, en geen upsell |
| **Waar komt omzet vandaan** | Herhaalaankopen plus doorstroom naar abonnement |
| **Conversierisico** | Laag, en op documentpagina's waarschijnlijk positief |
| **Churnrisico** | Geen |
| **Data nodig** | Of er überhaupt iemand een los document koopt, en welk type |
| **Goedkoop te krijgen** | Dit is de goedkoopste meting van alle zeven: het vereist alleen tijd. `DocumentPurchase` telt mee zodra er één verkoop is |
| **Technisch** | Klein tot middel: vervaldatum of teller, plus `allow_promotion_codes` |
| **Commercieel** | Klein |

### Scenario D. Vier tiers met seats

| | |
|---|---|
| **Hypothese** | MKB met meerdere gebruikers wil en kan meer betalen |
| **Wie betaalt** | Werkgever en kantoor |
| **Welk probleem** | Enterprise belooft multi-user dat niet bestaat; MKB-segment is onbereikbaar |
| **Waar komt omzet vandaan** | Per seat, zoals deLex met 45 per extra gebruiker |
| **Conversierisico** | Onveranderd onderin, onbekend bovenin |
| **Churnrisico** | Lager bij teams: meer gebruikers is hogere overstapdrempel |
| **Data nodig** | Of er vraag is naar meerdere gebruikers. Nul signalen tot nu toe |
| **Goedkoop te krijgen** | Vragen in de gesprekken uit sectie 10. Niet meetbaar zonder klanten |
| **Technisch** | Zeer groot: `Team`-model, uitnodigingen, rollen, per-seat facturering |
| **Commercieel** | Groot: een ander verkoopgesprek dan het huidige |

### Scenario E. Basis plus add-ons

| | |
|---|---|
| **Hypothese** | Het vertrouwensbezwaar is een betaalbare dienst en geen copyprobleem |
| **Wie betaalt** | Wie zekerheid wil, incidenteel |
| **Welk probleem** | Checkout-bezwaar 1 uit `icp.md` heeft nu geen antwoord dat geld oplevert |
| **Waar komt omzet vandaan** | Juristencheck, zoals Lawsy met 99 en 199 |
| **Conversierisico** | Laag: de basisprijs blijft laag |
| **Churnrisico** | Laag |
| **Data nodig** | Of iemand 99 euro betaalt voor een check, en of er een jurist te vinden is die dat voor minder levert |
| **Goedkoop te krijgen** | Eén gesprek met één jurist over tarief en doorlooptijd. Dat kan nu al |
| **Technisch** | Middel |
| **Commercieel** | Groot en niet technisch: **zonder jurist bestaat dit scenario niet** |

### Scenario F. Gratis laag

| | |
|---|---|
| **Hypothese** | Het knelpunt is distributie en vertrouwen, niet prijs. Een gratis laag lost beide deels op |
| **Wie betaalt** | Niemand in de gratis laag; die is er om de trechter te vullen |
| **Welk probleem** | 8 bezoekers per maand op `/pricing` en een betaalmuur vóór de eerste waarde |
| **Waar komt omzet vandaan** | Volume, niet prijs |
| **Conversierisico** | Grootste opwaartse effect van alle zeven, en tegelijk het risico dat niemand ooit upgradet |
| **Churnrisico** | Niet van toepassing op de gratis laag |
| **Data nodig** | De CPU-kosten per generatie, want gratis gebruikers verbruiken de Hobby-CPU. En of een gratis gebruiker ooit betaalt |
| **Goedkoop te krijgen** | CPU meten kan nu, mits de Vercel-observability op Hobby dat toont. Dat is niet geverifieerd |
| **Technisch** | Middel: gratis niveau in `access.ts`, vergrendelde export, misbruikbescherming |
| **Commercieel** | Middel |

### Scenario G. Hybride

| | |
|---|---|
| **Hypothese** | Alle segmenten zijn tegelijk te bedienen |
| **Wie betaalt** | Iedereen, anders |
| **Welk probleem** | Alle bovenstaande tegelijk |
| **Waar komt omzet vandaan** | Overal een beetje |
| **Conversierisico** | Hoog door complexiteit |
| **Churnrisico** | Onbekend |
| **Data nodig** | Alles uit A tot en met F |
| **Goedkoop te krijgen** | Niet. Dit is het duurste scenario om te valideren |
| **Technisch** | Zeer groot |
| **Commercieel** | Zeer groot: met één persoon is dit niet te onderhouden |

### 1.1 Het patroon in deze tabel

Drie scenario's (A, C, E-deels) zijn goedkoop te onderzoeken omdat ze weinig data vragen. Drie (B, D, G) vragen data die alleen ontstaat als er al klanten zijn, wat een kip-en-eiprobleem is. En één (F) vraagt één meting die vandaag gedaan kan worden.

Dat is geen aanbeveling, maar het is wel de volgorde waarin de onzekerheid het snelst afneemt. **AFLEIDING**

---

## 2. Bewezen, waarschijnlijk, hypothese

| Conclusie | Label | Waarop gebaseerd |
|---|---|---|
| Alle abonnees krijgen alle 233 documenten | **BEWEZEN** | `access.ts:32` |
| Alleen AI-limieten verschillen tussen tiers | **BEWEZEN** | `ai.ts`, `access.ts` |
| Geen Team-, Organization- of Seat-model | **BEWEZEN** | `schema.prisma`, zes modellen |
| Losse aankoop geeft levenslange onbeperkte generatie | **BEWEZEN** | `DocumentPurchase`, geen teller of vervaldatum |
| Een AI-review kost hoogstens 0,0058 euro | **BEWEZEN** | `cost-meter.ts` plus Google-prijslijst |
| Contributiemarge 91 tot 98 procent | **BEWEZEN** | rekenkundig uit geverifieerde tarieven |
| Zes claims in `PLAN_TIERS` kloppen niet met de code | **BEWEZEN** | claim voor claim in [[pricing-marktonderzoek-2026-09-16]] |
| Er staat geen `track()` in de codebase | **BEWEZEN** | grep over `src` |
| Custom events en UTM-dimensies zijn geblokkeerd op Hobby | **BEWEZEN** | 402-antwoorden van de Vercel-API, 16 september |
| `/pricing` trok 8 bezoekers in 30 dagen | **BEWEZEN** | Vercel Analytics |
| Er waren 3 bezoekers op `/sign-up` in 30 dagen | **BEWEZEN** | Vercel Analytics |
| De Nederlandse markt loopt van 24,75 tot 948 per jaar | **BEWEZEN** | prijspagina's van de aanbieders |
| Prijzen exclusief BTW mogen alleen bij uitsluitend zakelijke klanten | **BEWEZEN** | prijsaanduidingsregels, meerdere bronnen |
| Kantoren betalen meer voor dezelfde soort catalogus | **BEWEZEN in de markt**, **HYPOTHESE voor [[ZekerWet]]** | Flexmodellen, deLex, VraagHugo |
| Vertrouwen en niet prijs is de bindende beperking | **WAARSCHIJNLIJK** | `icp.md` plus de positionering van vijf concurrenten. Nul eigen klantdata |
| Jaarbetaling is voordeliger onder 9,7 maanden levensduur | **WAARSCHIJNLIJK** | rekenkundig zeker, maar de levensduur is onbekend |
| De hoogste betalingsbereidheid zit bij werkgevers en kantoren | **WAARSCHIJNLIJK** | marktbewijs, geen eigen bewijs |
| Een gratis laag vult de trechter | **WAARSCHIJNLIJK** | Genie AI, Ligo, Lawsy, Judex doen het allemaal |
| Boekhouders hebben behoefte aan juridische documenten voor klanten | **HYPOTHESE** | nul gesprekken |
| Een documentlimiet zou meer opleveren dan kosten | **HYPOTHESE** | nul eigen volumedata |
| Een hogere prijs verlaagt de conversie niet substantieel | **HYPOTHESE** | nooit een andere prijs getoond |
| Losse kopers worden abonnee | **HYPOTHESE** | nul losse verkopen |
| Credits werken voor deze doelgroep | **HYPOTHESE** | werkt bij VraagHugo, zegt niets over [[ZekerWet]] |

**De regel die hierbij hoort en die in de vorige twee documenten niet expliciet stond**: dat een concurrent iets doet, is bewijs dat het voor hén werkt. Het is geen bewijs dat het hier werkt. Elke regel in de kolom "BEWEZEN in de markt" moet apart voor [[ZekerWet]] worden getoetst voordat er iets op gebouwd wordt.

---

## 3. Wat de eigen data wél zegt

Uitgelezen op 16 september 2026 uit Vercel Web Analytics over 17 augustus tot en met 16 september. Alles hieronder is gemeten, niet geschat.

### 3.1 De trechter, voor zover meetbaar

| Stap | Bezoekers | Pageviews | Wat het betekent |
|---|---|---|---|
| Homepage `/` | 62 | 81 | De voordeur |
| `/documenten` | 12 | 18 | Catalogus bekeken |
| `/documenten/opdracht` | 8 | 9 | Best bezochte documentpagina |
| `/pricing` | 8 | 17 | **8 mensen in 30 dagen** |
| `/sign-up` | 3 | 5 | **3 aanmeldpogingen in 30 dagen** |
| `/sign-up/verify-email-address` | 3 | 7 | Alle drie kwamen bij verificatie |
| `/sign-in` | 20 | 36 | Grotendeels [[Ali Can]] zelf |
| `/dashboard` | 15 | 44 | Grotendeels eigen gebruik |
| `/dashboard/review` | 11 | 31 | Op één na drukste dashboardpagina |
| `/dashboard/new` | 7 | 15 | Documentgeneratie |
| Kennisbank, 7 artikelen samen | circa 23 | 26 | Aanzegbrief 6, AV 4, NDA 4, AVG 3, RI&E 2, verwerkingsregister 2, wet-dba 2 |

### 3.2 Waar het verkeer vandaan komt

| Bron | Bezoekers |
|---|---|
| Direct of geen referrer | 70 |
| LinkedIn (web plus Android-app) | **24** |
| Facebook (web plus mobiel) | 12 |
| Google | 6 |
| Vercel | 4 |
| Bing | 3 |
| checkout.stripe.com | 2 |
| Instagram | 1 |

**De grootste correctie op de vault.** `Context/business.md` zegt op basis van de meting van 14 september: 1 bezoeker via LinkedIn. Het zijn er nu 24. Per dag:

| Datum | LinkedIn-bezoekers |
|---|---|
| 10 t/m 13 september | 0 |
| 14 september | 12 |
| 15 september | 11 |
| 16 september | 3 |

Zesentwintig LinkedIn-bezoekers in drie dagen, na dertien dagen met nul. Dat is de week waarin de gecontroleerde cadans van week 38 live ging. **BEWEZEN** dat het verkeer er is; **WAARSCHIJNLIJK** dat de LinkedIn-posts het veroorzaken, want zonder UTM-dimensies is niet te zien welke post het was, en dat is precies de blokkade uit sectie 0.

### 3.3 Wat dit betekent en wat nadrukkelijk niet

**Wat het wel betekent.** Er bestaat een kanaal dat binnen twee dagen meer bezoekers levert dan de hele maand ervoor. Bij een baseline van één LinkedIn-bezoeker per maand is 26 in drie dagen geen ruis.

**Wat het niet betekent.** Niet dat LinkedIn schaalt; drie dagen is drie dagen. Niet dat die bezoekers koopintentie hadden: `/pricing` had er in dezelfde maand acht. En niet dat het pricingprobleem daarmee is opgelost.

**De observatie die het meest zegt over de pricingvraag.** Acht mensen bekeken de prijspagina in dertig dagen. Drie kwamen bij aanmelden. Wat de prijs op die pagina ook is, het raakt acht mensen per maand. **Dat is het sterkste bewijs in dit hele document dat de pricingvraag nu niet de bindende beperking is.** **AFLEIDING**

### 3.4 De enige klant

Uit [[klant-yvonne-heiligers]], eerder uit de productiedatabase gelezen: betaald 4 september 12:30, Business 49,99, één document gegenereerd om 17:39 (algemene voorwaarden), `aiUsageCount` 0, `aiTokensUsed` 0, nul losse aankopen, nul reviews. Laatste login 14 september 16:29 vanuit Delft.

Wat daaruit te leren valt: zij koos het duurste plan dat ze waarschijnlijk nodig had, gebruikte de functie waarvoor dat plan duurder is nul keer, en kwam wel terug maar genereerde niets meer. **Eén klant is geen dataset, maar dit is wel de enige echte prijsobservatie die bestaat** en hij is nog niet uitgevraagd.

### 3.5 Wat niet meetbaar is en waarom

| Wat | Waarom niet |
|---|---|
| Checkout gestart | Geen `track()`, en custom events zijn geblokkeerd op Hobby |
| Welk plan gekozen | Idem. Alleen achteraf in Stripe, zonder sessiekoppeling |
| Jaar of maand gekozen | Idem |
| Welke post welke bezoeker bracht | UTM-dimensies geblokkeerd op Hobby |
| Bezoeker die klant werd | Geen attributiekolommen op `User` |
| Churn | Eén klant, twaalf dagen |
| Documenten per gebruiker per maand | Eén klant, één document |
| CPU per generatie | Niet gemeten, en de beschikbaarheid op Hobby is niet geverifieerd |
| Verkeer ouder dan 30 dagen | Hobby bewaart één maand |

---

## 4. Vijf vragen aan [[Yvonne Heiligers]]

Geen verkoopvraag, geen suggestie, geen prijsvraag. Vraag 4 is de belangrijkste, want die legt bloot wat het echte alternatief is zonder naar concurrenten te vragen.

1. Je hebt op 4 september meteen voor Business gekozen. Wat gaf toen de doorslag?
2. Wat had je in gedachten dat je ermee zou gaan doen?
3. Je hebt algemene voorwaarden opgesteld. Stonden er nog andere dingen op je lijstje?
4. Als er sinds begin september iets juridisch geregeld moest worden, hoe heb je dat toen aangepakt?
5. Wat zou er anders moeten zijn om ZekerWet nuttiger voor je te maken?

**Waarom precies deze vijf.** Vraag 1 test de Business-val rechtstreeks: als ze niet weet waarom Business duurder is, is dat het antwoord. Vraag 2 legt de verwachting bloot tegenover wat ze kreeg. Vraag 3 zoekt onbenutte behoefte. Vraag 4 achterhaalt het werkelijke alternatief zonder het te noemen. Vraag 5 is open en staat expres achteraan, zodat hij niet gekleurd wordt door de eerdere vragen.

**Wat er níet in staat en waarom.** Geen "zou je X betalen" (dat meet niets, mensen zijn slecht in hypothetische prijzen). Geen "was het te duur" (suggestief, en het lokt een ja uit). Geen "waarom gebruik je het niet meer" (verwijtend, en het sluit het gesprek). Geen aanbod, geen korting, geen verlenging.

---

## 5. Experimentframework in vijf fasen

Elk experiment met wat het meet, wat het nodig heeft, en met een expliciete regel over wat er níet uit geconcludeerd mag worden.

### Fase 1. Meten wat er nu gebeurt

Doel is instrumentatie, niet leren. Niets hiervan is een test.

| # | Wat | Hypothese | Metric | Sample | Looptijd | Wat een uitkomst betekent | Wat het niet betekent |
|---|---|---|---|---|---|---|---|
| 1.1 | Attributie op `User` vastleggen bij aanmelding | De UTM-parameters komen wel binnen, ze worden alleen niet bewaard | Percentage nieuwe accounts met een herkomst | Elke aanmelding | Doorlopend | Je weet welk kanaal klanten levert | Niet welk kanaal bezoekers levert; dat blijft onmeetbaar op Hobby |
| 1.2 | "Hoe ben je bij ons gekomen" in de onboarding | Mensen die de naam intypen zijn nu onzichtbaar | Ingevulde antwoorden | Elke aanmelding | Doorlopend | Vangt wat UTM mist | Antwoorden zijn zelfgerapporteerd en onbetrouwbaar in detail |
| 1.3 | Maandelijkse handmatige uitlezing van pad- en referrerdata | Hobby bewaart één maand | Vaste set paden per maand | n.v.t. | Elke maand vóór de 1e | Je houdt een reeks op, ondanks de retentielimiet | Geen cohortanalyse mogelijk |
| 1.4 | Documenten en reviews per gebruiker per maand tellen | De spreiding bepaalt of volumegrendels zin hebben | Mediaan en spreiding | 20+ klanten | 3 maanden | De grendel voor scenario B of F | Bij minder dan 20 klanten zegt de spreiding niets |
| 1.5 | Opzeggingen bijhouden | Churn bepaalt alles in het omzetmodel | Opzeggingen per maand gedeeld door actieve klanten | 20+ klanten | 3 maanden | De belangrijkste variabele in sectie 7 | Onder 20 klanten is één opzegging 5 procent churn en dat is toeval |
| 1.6 | CPU per PDF-generatie meten | Bepaalt of scenario F kan | Actieve CPU-seconden per generatie | 50 generaties | n.v.t. | De capaciteitsgrens van Hobby | Zegt niets over kosten zolang Hobby gratis is |

**Fase 1 is af als**: elke nieuwe klant een herkomst draagt, en er drie maanden aaneengesloten cijfers liggen.

### Fase 2. Presentatie, niet prijs

Geen prijswijziging. Alleen hoe hij getoond wordt.

| # | Wat | Hypothese | Metric | Sample | Looptijd | Betekenis | Niet concluderen |
|---|---|---|---|---|---|---|---|
| 2.1 | Jaar als standaard op de toggle | De meeste Nederlandse aanbieders verkopen per jaar; maand als standaard verlaagt de jaarkeuze | Aandeel jaarabonnementen | 30 verkopen | tot 30 verkopen | Of jaarbetaling een presentatiekwestie is | Niet dat jaarbetaling beter is; dat hangt aan de levensduur van 9,7 maanden |
| 2.2 | Anker naast de prijs zetten | Concurrenten ankeren allemaal op advocaatkosten | Doorklik van `/pricing` naar checkout | 400 bezoekers op `/pricing` | bij 8 per maand: **onhaalbaar** | Zie hieronder | |
| 2.3 | Proefperiode zonder betaalmiddel | Een betaalmuur bij een onbekend merk kost meer dan hij aan misbruik voorkomt | Aanmeldingen per bezoeker | 200 bezoekers | bij huidig verkeer: 2 maanden | Of de creditcardmuur de rem is | Niet of die proefgebruikers ook betalen; dat duurt 14 dagen langer |

### Fase 3. Prijsniveau

**Dit kan op dit moment niet en dat moet hard worden opgeschreven.**

Een A/B-test op de prijspagina met een uitgangsconversie van 30 procent doorklik en een gewenst detecteerbaar verschil van 30 procent relatief, vraagt ongeveer 415 bezoekers per variant, dus circa 830 op `/pricing`. Bij 8 bezoekers per maand is dat **ruim 100 maanden**.

Een test op abonnementsconversie met een uitgangswaarde van 2 procent en een detecteerbaar verschil van 50 procent relatief vraagt ongeveer 3.100 bezoekers per variant, dus circa 6.300 in totaal.

**Voorwaarde om fase 3 überhaupt te openen: minimaal 400 bezoekers per maand op `/pricing`.** Dat is vijftig keer het huidige aantal. **AFLEIDING**, met standaard steekproefrekenwerk.

### Fase 4. Losse documenten

| # | Wat | Hypothese | Metric | Sample | Looptijd | Betekenis | Niet concluderen |
|---|---|---|---|---|---|---|---|
| 4.1 | Afwachten en tellen | Er is nul losse verkoop geweest; misschien wil niemand het | Aantal `DocumentPurchase`-rijen met status completed | 1 | 3 maanden | De eerste verkoop vertelt welk type en welke prijs | Eén verkoop is geen patroon |
| 4.2 | Levenslang vervangen door een venster | Klanten verwachten één document, geen levenslange licentie | Herhaalaankopen per klant | 20 aankopen | onbepaald | Of het lek echt geld kostte | Niet vóór er aankopen zijn: nu repareer je iets dat niemand gebruikt |
| 4.3 | Verrekening naar abonnement | Een losse koper is een abonnementskandidaat | Aandeel losse kopers dat binnen 30 dagen abonneert | 20 aankopen | onbepaald | De brug uit sectie G van het masterplan | Niets bij minder dan 20 |

**Het eerlijke antwoord voor fase 4**: met nul verkopen is elke reparatie een gok. De goedkoopste actie is wachten op de eerste verkoop en die persoon bellen.

### Fase 5. Kantoren

Geen A/B-test maar gesprekken. Uitwerking in sectie 10. Dit is de enige fase die vandaag kan beginnen en waar het huidige verkeer niet in de weg zit.

---

## 6. Wat 70 tot 120 bezoekers wel en niet kan dragen

| Niveau | Wat het is | Wat ervoor nodig is | Wat [[ZekerWet]] nu heeft |
|---|---|---|---|
| **Richtingsgevoel** | Een aanwijzing die een vraag oproept, nooit een besluit | 5 tot 30 waarnemingen, of één goed gesprek | Ja: 8 bezoekers op `/pricing`, 26 LinkedIn-bezoekers in drie dagen, één klant |
| **Betekenisvol bewijs** | Een grove verhouding waar je een keuze op durft te baseren | 100 tot 400 waarnemingen per stap | Nee, op geen enkele stap onder de homepage |
| **Statistisch sterker bewijs** | Een A/B-verschil dat geen toeval is | 800 tot 6.300 per variant, afhankelijk van de uitgangswaarde | Nee, en op dit tempo jarenlang niet |

**Wat er nu met richtingsgevoel mag**: kleine, omkeerbare dingen doen die duidelijk fout zijn, en gesprekken voeren. **Wat er niet mag**: een pricingarchitectuur bouwen. De acht bezoekers op `/pricing` kunnen elk verhaal dragen dat je erin wil lezen.

---

## 7. Omzetmodel

### 7.1 De formule

Bij evenwicht geldt dat het klantenbestand gelijk is aan de maandelijkse aanwas gedeeld door de churn:

**MRR = (V × s × a × c × ARPU) ÷ r**

| Variabele | Wat het is | Huidige waarde |
|---|---|---|
| **V** | Bezoekers per maand | circa 100 tot 120 (gemeten, inclusief eigen verkeer) |
| **s** | Bezoeker wordt account | 3 op `/sign-up` in 30 dagen, dus grofweg 3 procent. **Vervuild door eigen verkeer** |
| **a** | Account genereert eerste document | onbekend |
| **c** | Genereert en gaat betalen | onbekend |
| **ARPU** | Netto-omzet per klant per maand | 41,31 op één klant. Betekenisloos |
| **r** | Maandelijkse churn | onbekend |

### 7.2 Welke variabele het meest doet

MRR is recht evenredig met V, s, a, c en ARPU, en omgekeerd evenredig met r. Een verdubbeling van welke dan ook verdubbelt het resultaat; een halvering van de churn ook.

Dat lijkt symmetrisch maar is het niet, want de variabelen verschillen enorm in hoeveel ruimte ze hebben:

| Variabele | Realistische bandbreedte | Hefboom |
|---|---|---|
| V | 100 naar 2.000 is haalbaar met indexering en cadans | **20x** |
| s | 3 naar 8 procent | 2,7x |
| a | onbekend, maar een gratis laag raakt deze direct | onbekend |
| c | 1 naar 3 procent | 3x |
| ARPU | 20,65 naar 82,64 (24,99 naar 99,99) | 4x |
| r | 10 naar 3 procent | 3,3x |

**V heeft veruit de grootste bandbreedte, en het is ook de enige variabele waarvan we zeker weten dat hij nu extreem laag staat.** Dat is het kwantitatieve equivalent van wat sectie 3.3 al liet zien. **AFLEIDING**

### 7.3 Wat er nodig is voor 15.000 netto

Bij ARPU 41,31 netto en 5 procent churn: 363 klanten, en 18 nieuwe per maand om op peil te blijven.

| Als s × a × c is | Dan is er per maand nodig |
|---|---|
| 1 procent | 1.815 bezoekers |
| 2 procent | 908 bezoekers |
| 3 procent | 605 bezoekers |
| 5 procent | 363 bezoekers |

Bij circa 110 bezoekers per maand moet het verkeer dus **vijf tot zeventien keer omhoog**, of de conversie moet buitengewoon zijn. Dit is geen voorspelling maar de rekensom achter het doel.

---

## 8. 15.000 euro exclusief BTW, de economische structuur

| Structuur | Klanten | ARPU netto | Churn | Nieuw per maand om stil te staan |
|---|---|---|---|---|
| Alles Essential (24,99 incl) | 727 | 20,65 | 5% | 36 |
| Mix 70/30 Essential en Business | 559 | 26,85 | 5% | 28 |
| Alles Business (49,99 incl) | 364 | 41,31 | 5% | 18 |
| Alles Business, exclusief BTW geprijsd | 301 | 49,99 | 5% | 15 |
| Hogere tier (99,99 incl) | 182 | 82,64 | 5% | 9 |
| Kantoorkanaal: 30 kantoren à 10 eindklanten op Business | 300 | 41,31 | 5% | 15, maar via 30 relaties |
| Alles Business, lage churn | 364 | 41,31 | 2% | 7 |

Geen rangorde. Wat de tabel laat zien: het doel is bereikbaar via veel goedkope klanten, weinig dure klanten, of dertig kantoorrelaties. De drie vragen daarachter zijn verschillend en vragen verschillende bewijzen.

---

## 9. Meetplan losse documenten

| Vraag | Hoe te meten | Wanneer betekenisvol |
|---|---|---|
| **Welke documenten zijn geschikt** | De best bezochte documentpagina's. Nu: `/documenten/opdracht` 8 bezoekers, `/documenten/aanzegbrief` 4 | 20+ bezoekers per pagina per maand |
| **Welke prijs** | Niet testbaar bij dit verkeer. Marktbereik is 9 tot 99 | 400 bezoekers per documentpagina |
| **Levenslang tegenover eenmalig** | Herhaalgeneraties per gekocht type tellen | 20 aankopen |
| **Upsell naar abonnement** | Aandeel losse kopers dat binnen 30 dagen abonneert | 20 aankopen |
| **Kannibalisatie** | Verhouding losse aankopen tot nieuwe abonnementen, per maand | 3 maanden met beide |

**De eerlijke stand**: alle vijf de rijen staan op nul waarnemingen. Het enige wat nu kan is wachten, tellen, en de eerste koper bellen.

---

## 10. Validatiereeks kantoren

Volgorde ligt vast en er wordt niet van afgeweken: drie diagnosegesprekken, behoefte vaststellen, bereidheid om software voor klanten te gebruiken, pas dan prijs bespreken, dan pilot, dan meten.

**Geen verwijsvergoeding aanbieden voordat het beroepsrecht juridisch voldoende is geverifieerd.** RB artikel 15 verbiedt vergoedingen in enige vorm voor het bezorgen van opdrachten, inclusief kortingen en betalingen in natura boven symbolische waarde. NOB staat commissies toe onder voorwaarden. NBA heeft geen apart artikel. Voor een concrete constructie is een jurist nodig. Wat wel kan zonder dat risico: een kantoorlicentie verkopen, zoals VraagHugo Pro voor 249 per jaar met "ook voor je klanten". Dan is er geen vergoeding en dus geen provisievraag.

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

Vraag 8 is nieuw en volgt rechtstreeks uit het marktonderzoek: hij toetst of de VraagHugo Pro-propositie hier ook opgaat. Vraag 9 bepaalt wat er überhaupt aangeboden mag worden.

**Wat je per gesprek meet**: hoeveel van de tien beantwoord zijn, hoe vaak zij uit zichzelf een woord gebruiken dat ook in de klantzinnen van [[modelovereenkomst-2026]] staat, en of zij uit zichzelf naar de prijs vragen. Dat laatste is het enige echte koopsignaal in een diagnosegesprek.

---

## 11. De BTW-beslissing, feitelijk

### 11.1 Wat vaststaat

- Stripe kent geen `automatic_tax`, `tax_behavior` of `tax_rates`. Het getoonde bedrag is het eindbedrag en de 21 procent BTW komt eruit. **BEWEZEN in de code.**
- Prijzen aan consumenten moeten inclusief BTW worden getoond. **BEWEZEN**, meerdere bronnen over de prijsaanduidingsregels.
- Exclusief BTW tonen mag alleen als een onderneming zich uitsluitend op zakelijke klanten richt, en dan moet er expliciet bij staan dat het exclusief 21 procent BTW is. **BEWEZEN**
- Bij een gemengde klantenkring moeten prijzen inclusief worden getoond. Consumenten uitsluiten kan bijvoorbeeld door bij het afrekenen verplicht een bedrijfsnaam en KVK- of BTW-nummer te vragen. **BEWEZEN**
- De checkout vraagt nu geen KVK- of BTW-nummer en gasten kunnen afrekenen zonder account. **BEWEZEN in de code.**
- 55 van de 233 documenten richten zich op een particulier of een werknemer. **BEWEZEN**

### 11.2 Wat er feitelijk beslist moet worden

Het is één beslissing met twee helften, en ze kunnen niet los van elkaar.

| Route | Wat je doet | Gevolg voor omzet | Gevolg voor catalogus |
|---|---|---|---|
| **Zuiver B2B** | KVK- of BTW-nummer verplicht bij checkout, prijzen exclusief tonen | +21 procent netto per zakelijke klant | De 55 particuliere documenten zijn niet meer verkoopbaar aan hun doelgroep |
| **Gemengd blijven** | Alles inclusief BTW tonen, zoals nu | Ongewijzigd | Hele catalogus blijft verkoopbaar |
| **Gesplitst** | Zakelijke ingang exclusief, particuliere ingang inclusief | +21 procent op het zakelijke deel | Twee ingangen onderhouden met één persoon |

### 11.3 Wat hier onbekend is en wie het moet zeggen

**Een juridisch specialist is nodig** voor drie punten waar ik geen sluitend antwoord op heb gevonden:

1. Of een verplicht KVK-nummer bij checkout juridisch voldoende is om als "uitsluitend zakelijk" te gelden, of dat er meer voor nodig is.
2. Of de 55 particuliere documenten op een zakelijke site alsnog een consumentenrelatie kunnen doen ontstaan, ongeacht wat de checkout vraagt.
3. Of bestaande klanten bij een omslag onder de oude prijsstelling vallen, en hoe dat contractueel loopt zonder grandfathering in de code.

Tot die drie beantwoord zijn, is dit **geen beslissing die op basis van dit onderzoek genomen kan worden.**

---

## 12. Enterprise

### 12.1 De situatie

199,99 per maand, en het verschil met Essential van 24,99 bestaat in de code uit een hoger AI-tokenbudget ter waarde van hoogstens 11,70 euro per maand. De vier andere verkoopargumenten op de pagina zijn: NIS2- en NEN 7510-modules (nis2 is een gewoon document dat ook Essential krijgt, NEN 7510 bestaat niet in de catalogus), multi-user management (geen `Team`-model in het datamodel), priority legal support en dedicated success manager (geen personeel). **BEWEZEN**

### 12.2 Vier opties, met gevolgen

| Optie | Wat het inhoudt | Voor | Tegen |
|---|---|---|---|
| **Laten staan** | Niets doen | Kost niets, en het plan verkoopt toch niet | Een klant die het koopt, koopt iets dat niet bestaat. Dat is een terugbetalingsgesprek en een reputatierisico bij een product dat compliance verkoopt |
| **Claims eerlijk maken** | Alleen benoemen wat er is: onbeperkte AI-review | Eerlijk, klein, direct te doen | Dan is 199,99 voor onbeperkte AI moeilijk te verdedigen als Business er tien geeft voor 49,99 |
| **Uit de verkoop halen** | Weghalen van de pagina, bestaande klanten behouden | Geen enkel risico, en de pagina wordt eerlijker | Je verliest een anker. Drie prijzen laten de middelste redelijk lijken, en dat effect is reëel |
| **Vervangen door "op aanvraag"** | Geen prijs, alleen contact | Houdt het anker, belooft niets, en elk gesprek is discovery | Vraagt beschikbaarheid om te reageren |

### 12.3 Oordeel

Publiekelijk een plan van 199,99 per maand aanbieden waarvan drie van de zes verkoopargumenten aantoonbaar niet bestaan, is het enige punt in deze hele analyse waar het risico groter is dan het gemiste omzetpotentieel. Er zijn nul Enterprise-klanten, dus de kosten van ingrijpen zijn nul en de kosten van niet-ingrijpen zijn een klant die het koopt. **AFLEIDING**, en de keuze tussen de vier opties blijft aan [[Ali Can]].

---

## 13. Data gap table

| Data | Hebben we? | Betrouwbaarheid | Waarom nodig | Hoe verzamelen | Wanneer voldoende |
|---|---|---|---|---|---|
| **Traffic** | Ja | Hoog voor pad en referrer, één maand retentie | Variabele V, grootste hefboom | Vercel Analytics, maandelijks uitlezen | Doorlopend, elke maand vastleggen |
| **Signup conversion** | Deels, 3 op `/sign-up` in 30 dagen | Laag, vervuild door eigen verkeer | Variabele s | Attributiekolommen plus eigen IP of account uitsluiten | 100 aanmeldingen |
| **Paid conversion** | Nee | n.v.t. | Variabele c | Stripe naast attributie | 50 aanmeldingen met uitkomst |
| **Plan selection** | Nee | n.v.t. | Of de tierkeuze werkt | Stripe `stripePriceId` per klant tellen | 30 verkopen |
| **Annual of monthly** | Nee | n.v.t. | Retentie en cashflow | `YEARLY_PRICE_IDS` tellen in Stripe | 30 verkopen |
| **Churn** | Nee | n.v.t. | Variabele r, grootste onzekerheid in het model | Stripe-opzeggingen per maand | 20 klanten en 3 maanden |
| **Document usage** | Eén document, één klant | Zeer laag | Grendel voor scenario B en F | `Document`-tabel per gebruiker per maand | 20 klanten en 3 maanden |
| **AI usage** | Nul reviews bij de enige klant | Zeer laag | Of de AI-limieten ergens op slaan | `AiUsageLog` per gebruiker | 20 klanten |
| **One-time purchases** | Nul | n.v.t. | Hele sectie 9 | `DocumentPurchase` tellen | 20 aankopen |
| **ARPU** | 41,31 op n=1 | Zeer laag | Alle omzetscenario's | Stripe, gemiddelde netto per klant | 30 klanten |
| **Acquisition source** | Deels, referrer wel, campagne niet | Middel voor kanaal, nul voor campagne | Weten waar je op moet inzetten | Attributiekolommen plus onboardingvraag | 50 klanten |
| **Accountant interest** | Nee | n.v.t. | Hele kanaalvraag | Drie diagnosegesprekken | 3 gesprekken |
| **Willingness to pay** | Nee | n.v.t. | Prijsniveau | Gesprekken, later prijstests | 10 gesprekken, of 400 bezoekers op `/pricing` |
| **CPU per document** | Nee | n.v.t. | Of scenario F kan, en waar Hobby knelt | Vercel Observability, beschikbaarheid op Hobby onbekend | 50 generaties |
| **Infrastructure cost** | Deels, Vercel en Clerk nul | Laag | Winst is nu niet te berekenen | Dashboards van database, Redis, Resend en Sentry nakijken | Eenmalig |

---

## 14. Beslisboom

Niet één eindantwoord, maar wat welke waarneming zou moeten openen.

**Na de vijf vragen aan [[Yvonne Heiligers]]:**
- Zegt ze dat ze Business koos omdat ze dacht dat AV en verwerkersovereenkomsten daar alleen in zaten → de Business-val is bevestigd → scenario A wordt urgent en de claims moeten sowieso weg.
- Zegt ze dat ze het duurste plan koos om zeker te zijn van kwaliteit → prijs is voor haar een kwaliteitssignaal → scenario D en een hogere tier worden interessanter, en de lage prijs wordt een verdacht signaal.
- Zegt ze dat ze niet meer terugkwam omdat ze niets meer nodig had → het probleem is frequentie, niet prijs → scenario C (losse verkoop) past beter bij deze klantsoort dan een abonnement.

**Na drie kantoorgesprekken:**
- Alle drie krijgen deze vragen regelmatig en zouden een licentie overwegen → scenario D of de kantoorlicentie uit scenario G openen, en vraag 9 bepaalt de vorm.
- Alle drie krijgen de vragen maar willen niet doorverwijzen wegens aansprakelijkheid → het kanaal is dood in deze vorm, en de aandacht gaat naar direct bereik.
- Alle drie krijgen de vragen nauwelijks → hypothese H3 is gefalsifieerd, tijd naar kennisbank en LinkedIn.

**Na drie maanden meten:**
- Verkeer boven 400 per maand en `/pricing` boven 100 → fase 2 kan echt starten.
- `/pricing` blijft onder 30 per maand → pricing is niet het knelpunt, alles gaat naar distributie.
- Churn boven 8 procent → het probleem is retentie en geen prijs; geen enkele pricingwijziging redt dat.
- Churn onder 3 procent bij 20 klanten → er is iets dat werkt; uitzoeken wat, en daarop prijzen.

**Na de eerste losse verkopen:**
- Kopers abonneren binnen 30 dagen → losse verkoop is een trechter, scenario C wordt de hoofdroute.
- Kopers komen nooit terug → losse verkoop is een apart product en moet apart geprijsd, dichter bij de 49 van Lawsy.

**Na de CPU-meting:**
- Onder 2 seconden per generatie → scenario F (gratis laag) is haalbaar op Hobby.
- Boven 5 seconden → een gratis laag loopt binnen enkele duizenden generaties tegen de Hobby-grens, en dan verandert het scenario van commercieel naar infrastructureel.

---

## 15. Eindresultaat

### A. Wat nu veilig aangepast kan worden

Drie dingen die aantoonbaar fout zijn, klein, omkeerbaar en niet afhankelijk van ontbrekende data. Dit is geen implementatievoorstel; het is de lijst waaruit [[Ali Can]] mag kiezen wanneer hij wil.

1. **De zes onjuiste claims in `PLAN_TIERS`.** RI&E, DPA en Algemene Voorwaarden staan onder Business maar zitten in Essential. Quarterly Compliance Check en Multi-user Management bestaan niet. NEN 7510 staat niet in de catalogus. Er is geen scenario waarin het goed is dat de pagina belooft wat de code niet doet.
2. **De AI-limieten.** Ze beschermen een kostenpost van 0,0058 euro per review en rantsoeneren de enige functie die [[ZekerWet]] onderscheidt. Eén review per maand is te weinig om gewenning te laten ontstaan.
3. **Enterprise.** Vier opties in sectie 12, waarvan drie beter zijn dan de huidige situatie.

### B. Wat voorlopig moet blijven staan

Het prijsniveau, de keuze tussen de zeven scenario's, de BTW-omslag (wacht op de drie juridische vragen uit 11.3), het losse-verkoopmodel (nul verkopen), de tierstructuur zelf, en het partneraanbod (wacht op gesprek drie). In alle zes gevallen is de reden dezelfde: er is geen data en concurrentprijzen zijn geen vervanging daarvoor.

### C. Wat gemeten moet worden

De vier uit fase 1 die zonder verkeer al zin hebben: herkomst per nieuw account, de onboardingvraag "hoe ben je bij ons gekomen", maandelijkse handmatige uitlezing van pad- en referrerdata vóór de retentie van één maand verloopt, en de CPU-tijd per generatie. Daarna, zodra er klanten zijn: documenten per gebruiker, AI-gebruik, plankeuze, jaar tegenover maand, en churn.

### D. Wat aan echte klanten gevraagd moet worden

De vijf vragen aan [[Yvonne Heiligers]] uit sectie 4 en de tien kantoorvragen uit sectie 10. Dat zijn vijftien vragen die samen meer opleveren dan welke analyse dan ook die ik hierna nog kan maken.

### E. Pricingtests die later kunnen

Fase 2 bij 200+ bezoekers per maand. Fase 3 bij 400+ bezoekers per maand op `/pricing` alleen. Fase 4 bij 20 losse aankopen. Fase 5 kan vandaag beginnen, want die vraagt geen verkeer.

### F. Wanneer er genoeg data is om pricing echt te veranderen

Vier criteria, alle vier nodig, geen enkele nu gehaald:

1. **400 bezoekers per maand op `/pricing`**, vijftig keer het huidige aantal.
2. **20 betalende klanten met drie maanden historie**, zodat churn en plankeuze betekenis krijgen.
3. **Drie kantoorgesprekken gevoerd**, zodat de kanaalvraag beantwoord is voordat de prijs wordt vastgezet.
4. **Attributie werkend**, zodat bekend is welk kanaal de klanten levert.

Tot die vier staan, is elke prijswijziging een keuze op gevoel. Dat mag, maar dan als ondernemersbesluit en niet als uitkomst van onderzoek.

### G. Wat absoluut niet gedaan moet worden

- **Een pricingarchitectuur bouwen op alleen concurrentprijzen.** Dat een concurrent iets doet, bewijst dat het voor hem werkt, niet dat het hier werkt.
- **Prijzen verhogen omdat de markt hoger zit.** De markt zit ook lager: ZZP Nederland vraagt 24,75 per jaar. Zonder eigen conversiedata is een prijsverhoging een gok waarbij de verliezende uitkomst onzichtbaar blijft, want een bezoeker die afhaakt laat geen spoor na.
- **Iets concluderen uit acht bezoekers op de prijspagina.** Die acht kunnen elk verhaal dragen dat je erin wil lezen.
- **Seats, credits of white label bouwen voordat iemand erom heeft gevraagd.** Alle drie zijn groot en geen van drieën heeft één signaal.
- **De 55 particuliere documenten schrappen voordat de BTW-vraag juridisch is beantwoord.** Het is één beslissing en de volgorde is andersom.
- **Een verwijsvergoeding aanbieden voordat vraag 9 is gesteld en een jurist ernaar heeft gekeken.**
- **De prijs veranderen als reactie op deze drie onderzoeksdocumenten.** Ze zijn geschreven om te weten wat we niet weten, en dat is de uitkomst.

---

## De kern, in één alinea

Er zijn nu drie onderzoeken gedaan naar pricing. Het beste dat ze hebben opgeleverd is niet een prijs maar een meting: acht mensen bekeken de prijspagina in dertig dagen, en zesentwintig LinkedIn-bezoekers kwamen binnen in de drie dagen dat de contentcadans voor het eerst echt liep. Zolang die verhouding zo staat, is de prijs op die pagina niet de variabele die 15.000 euro per maand in de weg staat. Het aantal mensen dat hem ziet, is dat wel.

Gerelateerd: [[ZekerWet]], [[masterplan-commercieel-2026-09-16]], [[pricing-marktonderzoek-2026-09-16]], [[ZekerWet-concurrenten]], [[kanaal-boekhouders]], [[klant-yvonne-heiligers]], [[seo-indexering-2026-09-14]], [[icp]], [[business]], [[strategy]]
