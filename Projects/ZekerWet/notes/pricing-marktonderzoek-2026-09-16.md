---
type: onderzoek
date: 2026-09-16
status: ter besluitvorming
tags: [pricing, concurrentie, unit-economics, marktonderzoek, verificatie]
project: ZekerWet
---

Verificatie- en verbredingsronde op [[masterplan-commercieel-2026-09-16]]. Onderzoeksdatum 16 september 2026. Niets gewijzigd: geen code, geen prijzen, geen pricingpagina, geen features, geen Buffer, geen outreach, geen database, geen Vercel-plan.

Twee vaste uitgangspunten van [[Ali Can]] zijn in dit document verwerkt: Vercel blijft voorlopig op Hobby, en het doel is 15.000 euro per maand **exclusief BTW**.

Labels: **FEIT** (gemeten in code of geciteerd uit een primaire bron), **AFLEIDING** (rekenwerk of gevolgtrekking uit feiten), **HYPOTHESE** (nog niet gevalideerd).

---

## 1. Executive summary

### 1.1 Drie conclusies uit het vorige masterplan die niet overeind blijven

Dit stond er vanochtend, en het klopte niet breed genoeg. Er waren toen drie concurrenten onderzocht; nu 38.

| Eerdere conclusie | Status | Wat er werkelijk is |
|---|---|---|
| "[[ZekerWet]] is twee tot vier keer goedkoper dan de Nederlandse markt" | **Onjuist** | Dat gold tegenover Legalflow, Lawsy en Ligo, de drie duurste aanbieders. De markt loopt van 24,75 per **jaar** tot 948 per jaar. [[ZekerWet]] zit in het midden |
| "[[ZekerWet]] is het goedkoopste onbeperkte aanbod in de Nederlandse markt" | **Onjuist** | DAS verkoopt onbeperkt uit 150+ documenten voor 299 per jaar, De ContractenFabriek voor 199 per jaar, en ZZP Nederland geeft leden een generator met 230+ documenten vanaf 24,75 per jaar |
| "Niemand biedt boekhouders een partnerprogramma voor doorlopende juridische documenten" | **Deels onjuist** | VraagHugo verkoopt Hugo Pro voor 249 per jaar met als expliciete propositie "Maak ook voor je klanten documenten". Dat is precies een adviseurslaag |

De onderliggende bevindingen over de code zijn wél opnieuw bevestigd en op één punt zwaarder geworden: er bestaat geen `Team`-, `Organization`- of `Seat`-model in het datamodel, dus multi-user is niet half af maar architectonisch afwezig. **FEIT**

### 1.2 De zes bevindingen van deze ronde

**1. De BTW-keuze is de grootste onbenutte hefboom, en hij zit vast aan de consumentendocumenten.** [[ZekerWet]] toont prijzen inclusief BTW. Elke serieuze Nederlandse B2B-concurrent (Legalflow, Lawsy, ContractenFabriek, deLex, Flexmodellen) toont exclusief. Voor een BTW-plichtige ondernemer is dat verschil economisch onzichtbaar, want hij trekt de BTW af. Voor [[ZekerWet]] is het 21 procent netto-omzet. Maar exclusief tonen mag alleen als je je uitsluitend op zakelijke klanten richt en consumenten effectief uitsluit, bijvoorbeeld door een KVK- of BTW-nummer te eisen bij de checkout. Met 55 particuliere documenten en een gastcheckout zonder KVK-veld kan dat nu niet. **De vraag "houden we de 55 consumentendocumenten" en de vraag "inclusief of exclusief BTW" zijn dus één vraag, en hij is 17,4 procent van de netto-omzet waard.** **FEIT** en **AFLEIDING**

**2. De goedkoopste concurrent is geen bedrijf maar een vereniging.** ZZP Nederland geeft leden vanaf 24,75 euro per jaar toegang tot een juridische documentengenerator met naar eigen zeggen 230+ documenten, plus gratis modelovereenkomsten en incasso. Dat is per jaar wat Essential per maand kost. Of de kwaliteit vergelijkbaar is, is niet geverifieerd, maar in het hoofd van een ZZP'er die beide ziet, is dit het prijsanker. **FEIT**

**3. De markt beprijst niet het product maar de koper.** Flexmodellen vraagt notarissen 4.995 euro per jaar voor 274 modellen en advocatenkantoren 3.745 voor 61 modellen. VraagHugo vraagt een ondernemer 149 en een adviseur die voor klanten werkt 249. deLex vraagt 195 voor de eerste gebruiker en 45 voor elke volgende. Hetzelfde soort catalogus, tot twintig keer verschil, bepaald door wie er koopt. Dat is het sterkste argument voor een kantoorlaag, en het sterkste argument tegen prijsverhoging op de ZZP-laag. **FEIT** en **AFLEIDING**

**4. [[ZekerWet]] heeft de bouwstenen voor een creditmodel al liggen en gebruikt ze niet.** `DOCUMENT_PRICING` classificeert alle 233 documenten al in vier complexiteitsklassen: 89 basis, 84 standaard, 53 professioneel, 7 specialist. VraagHugo draait precies dat model met credits van 4 tot 50 per document. De classificatie die daarvoor nodig is, bestaat in de repo en wordt nu alleen voor losse verkoop gebruikt. **FEIT**

**5. Het gratis alternatief is sterker dan gedacht en kost 0 tot 23 euro.** Judex geeft 70+ juridische templates gratis weg als leadgeneratie. KVK geeft bewust geen modellen omdat het als overheid niet met commerciële partijen mag concurreren, en verwijst naar derden die het wel gratis doen. En een ZZP'er kan een NDA laten schrijven door Gemini gratis, of door ChatGPT Plus voor 23 euro per maand, wat meer is dan Essential. **FEIT**

**6. De capaciteitsgrens van Vercel Hobby ligt lager dan de omzetgrens.** Hobby geeft 4 CPU-uur Active CPU per maand. Als een PDF-generatie drie seconden actieve CPU kost, past dat 4.800 keer. Bij 600 Essential-klanten die elk acht documenten per maand maken, zit je er precies aan. De CPU-tijd per generatie is niet gemeten, dus dit getal is een rekenvoorbeeld en geen meting, maar het laat zien dat Hobby eerder een capaciteitsplafond wordt dan een kostenpost. **AFLEIDING**

---

## 2. ZekerWet pricing audit, claim voor claim

Elke belofte van de pricingpagina naast wat de code, Stripe en het datamodel werkelijk doen. Bron voor alle regels: `src/config/pricing.ts`, `src/config/ai.ts`, `src/lib/access.ts`, `src/lib/subscription.ts`, `src/services/stripe.service.ts`, `prisma/schema.prisma`, gelezen op 16 september 2026.

### 2.1 Essential, 24,99 per maand

| Claim op de pagina | Code | Stripe/database | Wat de gebruiker krijgt | Oordeel |
|---|---|---|---|---|
| "Onbeperkt NDA & Basis Privacy" | `access.ts:32` geeft alle 233 | `stripePriceId` bepaalt alleen plan-label | Alle 233 documenten | **Mismatch, te bescheiden** |
| "Standaard juridische kluis" | `Document`-model, geen planonderscheid | Geen limiet | Onbeperkte opslag | Match |
| "Dashboard monitoring" | Dashboard bestaat | n.v.t. | Ja | Match |
| "Download in PDF-formaat" | `pdf-service.ts` | n.v.t. | Ja, alleen PDF, geen Word | Match |
| "1 AI Document Review per maand" | `AI_LIMITS` = 1, `AI_TOKEN_BUDGETS` = 30.000 | `aiUsageCount`, `aiTokensUsed` op `User` | 1 review | Match |
| "E-mail support" | n.v.t. | n.v.t. | Onmeetbaar | Niet te toetsen |

### 2.2 Business, 49,99 per maand

| Claim op de pagina | Code | Stripe/database | Wat de gebruiker krijgt | Oordeel |
|---|---|---|---|---|
| "Alles in Essential" | Ja | Ja | Ja | Match |
| "Volledige RI&E Engine" | `rie` is een gewoon documenttype in `DOCUMENT_TYPES` | Geen gating | **Ook Essential krijgt dit** | **Mismatch** |
| "DPA & Verwerkersovereenkomsten" | `dpa` is een gewoon documenttype | Geen gating | **Ook Essential krijgt dit** | **Mismatch** |
| "Algemene Voorwaarden (B2B/B2C)" | `terms` is een gewoon documenttype | Geen gating | **Ook Essential krijgt dit** | **Mismatch** |
| "10 AI Document Reviews per maand" | `AI_LIMITS` = 10, budget 200.000 | Ja | 10 reviews | Match |
| "Quarterly Compliance Check" | Niet gevonden in de code | Geen implementatie | **Niets** | **Mismatch** |

### 2.3 Enterprise, 199,99 per maand

| Claim op de pagina | Code | Stripe/database | Wat de gebruiker krijgt | Oordeel |
|---|---|---|---|---|
| "Alles in Business" | Ja | Ja | Ja | Match |
| "NIS2 & NEN 7510 Modules" | `nis2` is een gewoon documenttype. NEN 7510 komt in `DOCUMENT_TYPES` niet voor | Geen gating | **Essential krijgt nis2, NEN 7510 bestaat niet** | **Mismatch** |
| "Onbeperkte AI Document Review" | `AI_LIMITS` = 999.999, budget 5.000.000 tokens | Ja | Feitelijk onbeperkt, begrensd door tokens | Match |
| "Multi-user Management" | Geen `Team`, `Organization` of `Seat` in `schema.prisma`. Zes modellen totaal: User, Document, Review, DocumentPurchase, AiUsageLog, ProcessedWebhookEvent | Geen implementatie | **Niets** | **Mismatch** |
| "Priority Legal Support" | n.v.t. | n.v.t. | Onbekend | **Niet waar te maken zonder jurist** |
| "Dedicated Success Manager" | n.v.t. | n.v.t. | Onbekend | **Niet waar te maken** |

### 2.4 Het antwoord op de gestelde vraag

**Welke features verschillen technisch werkelijk tussen Essential, Business en Enterprise?** Precies twee, en ze zijn twee kanten van dezelfde munt:

1. `AI_LIMITS`: 1 / 10 / 999.999 verzoeken per periode
2. `AI_TOKEN_BUDGETS`: 30.000 / 200.000 / 5.000.000 tokens per periode

Verder niets. Geen documenttoegang, geen gebruikers, geen opslag, geen functies, geen support-SLA in code. **FEIT**

### 2.5 De rest van de commerciële stack

| Onderdeel | Bevinding |
|---|---|
| **Losse verkoop** | 4 klassen: basis 14,99 (89 docs), standaard 24,99 (84), professioneel 49,99 (53), specialist 129,99 (7). Alle 233 zijn geklasseerd, geen enkele mist een prijs |
| **Lifetime access** | `DocumentPurchase` heeft geen verbruiksteller en geen vervaldatum. `getPurchasedDocumentTypes` geeft `distinct` documenttypes met status `completed`. Eén betaling geeft permanente, ongelimiteerde generatie van dat type |
| **Checkout** | `payment_method_types: ['card', 'ideal']`, geen `automatic_tax`, geen `tax_behavior`, geen `tax_rates`, geen `allow_promotion_codes`. Gasten kunnen afrekenen zonder account |
| **Trial** | 14 dagen, alleen Essential (`isTrialEligible`), maximaal 3 documenten via `TRIAL_DOC_LIMIT`, atomisch afgedwongen met een WHERE-guard in `document.service.ts:80`, eenmalig per gebruiker via `hasUsedTrial`. Betaalmiddel vooraf vereist, want het is een gewone Stripe-checkoutsessie |
| **Coupons** | Niet aanwezig. Geen `coupon`, `promotion_code` of `discount` in de hele `src`-boom |
| **Grandfathering** | Niet aanwezig. Geen legacy-prijsveld, geen ingangsdatum per gebruiker. Een prijswijziging raakt bestaande abonnees volgens Stripe-gedrag en niet volgens eigen logica |
| **Admin-bypass** | `ADMIN_EMAILS` of `role = 'admin'` geeft `plan: 'enterprise'` zonder Stripe. Bewust, maar het betekent dat elk adminaccount onbeperkt AI heeft |
| **Jaarbetaling** | Bestaat voor alle drie de plannen, 20 procent korting, maar de pricingpagina start op maandelijks (`useState(false)`) |
| **Documentlimiet voor betalende klanten** | Bestaat niet. Alleen de proefperiode kent een limiet |
| **Word-export** | Niet gevonden. Alleen PDF. DAS en VraagHugo leveren beide PDF én Word |

---

## 3. Complete marktkaart

Vijftien categorieën waarin een Nederlandse ondernemer aan een juridisch document komt. Dit is de vraag die telt, en niet "wie lijkt op [[ZekerWet]]".

| # | Categorie | Wat het is | Prijsbereik | Relevantie |
|---|---|---|---|---|
| A | AI legal-document SaaS NL | Wizard genereert document | 29 tot 95 p/m | Direct |
| B | NL documentplatforms zonder AI | Sjablonen met invulvragen | 149 tot 499 p/j | Direct |
| C | Internationale legal-document SaaS | Templates, vaak Engelstalig recht | 0 tot 320 p/m | Indirect |
| D | Legal-tech en contract review | AI-review, workflows, CLM | 49 tot 600+ p/m | Deels |
| E | Advocaten en juristen | Maatwerk per uur of vast | 80 tot 500 p/u | Substituut |
| F | Accountants en boekhouders | Doorverwijzen of zelf leveren | wisselend | Kanaal |
| G | Brancheorganisaties | Documenten als lidmaatschapsvoordeel | 24,75 tot 160 p/j | **Direct en onderschat** |
| H | Gratis en zelf doen | Templates, overheid, AI-chatbots | 0 tot 23 p/m | **Direct en onderschat** |
| I | Document marketplaces | Losse verkoop per stuk | 9 tot 129 per stuk | Direct |
| J | Rechtsbijstand | Verzekering, werkt ná het conflict | 20 tot 35 p/m | Prijsanker |
| K | HR- en payrollplatforms | Arbeidscontracten als bijproduct | 3 tot 15 per werknemer p/m | Direct op arbeidsrecht |
| L | Compliance SaaS | AVG, NIS2, RI&E | 10 tot 50 p/m | Direct op AVG-documenten |
| M | Enterprise CLM | Contract lifecycle management | 600+ p/m | Prijsarchitectuur |
| N | NL niche-aanbieders | Vakgericht, vaak abonnement per jaar | 195 tot 4.995 p/j | Segmentatieles |
| O | Nieuwe AI legal startups | Sinds 2024 en 2025 | wisselend | Direct |

---

## 4. Longlist, 38 partijen

Per partij het type en waarom hij in beeld is. Prijzen staan in sectie 6.

### Nederlandse documentplatforms en AI-tools

| # | Partij | Type | Waarom relevant |
|---|---|---|---|
| 1 | Ligo | A | Pakt de ondernemer op dag één met BV-oprichting |
| 2 | Legalflow (Legalloyd) | A | Advocatenkantoor achter het product, volumegrendel |
| 3 | Lawsy | A/O | Meest identieke positionering, verkoopt juristencontrole los |
| 4 | Rocket Lawyer NL | A | Stopt 31 oktober 2026, klanten zoeken een nieuw huis |
| 5 | VraagHugo | A/I | Creditmodel plus expliciete adviseurslaag |
| 6 | DAS Documentenshop | B/J | Merknaam, 150+ documenten, 299 per jaar onbeperkt |
| 7 | De ContractenFabriek | B | 199 per jaar onbeperkt, goedkoper dan [[ZekerWet]] |
| 8 | MKB Juristen | E/B | 281 documenten, verkocht als mensenwerk |
| 9 | JuriDox (ICTRecht) | B | Generator van een gerenommeerd IT-rechtkantoor |
| 10 | ICTRecht | E | Autoriteit in IT- en privacyrecht |
| 11 | JuriBlox | D/N | Documentautomatisering met partnerprogramma |
| 12 | deLex ICT Modelcontracten | N | Per-seat prijsmodel, 195 plus 45 per extra gebruiker |
| 13 | Lexlumen / Flexmodellen | N | Vakpakketten van 395 tot 4.995 per jaar |
| 14 | Wolters Kluwer | N | Uitgever, modellenbibliotheek voor professionals |
| 15 | Judex | H/I | 70+ templates gratis, leadgeneratiemodel |
| 16 | Doe Het Zelf Notaris | B | Notariële documenten zelf regelen |
| 17 | Blended.Law | E | Marktplaats van juristen, notarissen en advocaten tegen vaste prijs |
| 18 | Juridische Supermarkt | E | Vaste prijzen voor juridisch werk |
| 19 | Firm24 | F/B | 1800+ aangesloten kantoren, het kanaalmodel |
| 20 | e-Legal | E | Advocaat tegen vaste prijs |
| 21 | ikwordzzper.nl | H | Gratis ZZP-contracten |
| 22 | voorbeeldalgemenevoorwaarden.nl | H | Gratis AV-generator |
| 23 | zzpmodelovereenkomsten.nl | H | Gratis modelovereenkomsten met ondertekening |

### Brancheorganisaties en verzekeraars

| # | Partij | Type | Waarom relevant |
|---|---|---|---|
| 24 | ZZP Nederland | G | 230+ documenten in de generator vanaf 24,75 per jaar |
| 25 | DAS (rechtsbijstand) | J | Vanaf circa 22 per maand voor ZZP |
| 26 | ARAG | J | Concurrent van DAS |
| 27 | Achmea / Interpolis / Centraal Beheer | J | Grootste distributie via banken en verzekeraars |
| 28 | Het Juridisch Loket | H | Gratis juridische hulp, overheid |
| 29 | KVK / Ondernemersplein | H | Geeft bewust geen modellen, verwijst door |

### Compliance, HR en internationaal

| # | Partij | Type | Waarom relevant |
|---|---|---|---|
| 30 | Privacy Zeker | L | Vanaf 29 per maand voor alleen AVG |
| 31 | ComplianceHive | L | 10 tot 50 per maand, geprijsd per systeem en niet per gebruiker |
| 32 | Blueline Privacy | L | 14,95 per maand all-in |
| 33 | Steunpunt RI&E (rie.nl) | L/H | Gratis RI&E-instrument |
| 34 | Nmbrs, AFAS, Loket.nl, Employes | K | Arbeidscontracten zitten in het payrollpakket, 3 tot 15 per werknemer |
| 35 | Genie AI | C/O | Gratis laag met 500+ templates, export vergrendeld |
| 36 | LegalZoom / LawDepot | C | Internationale schaalmodellen |
| 37 | Juro / Contractbook / Ironclad | D/M | CLM-prijsarchitectuur voor de bovenkant |
| 38 | ChatGPT, Claude, Gemini | H | Het echte gratis alternatief |

---

## 5. Shortlist, 18 partijen

De partijen die commercieel iets veranderen aan een beslissing van [[ZekerWet]].

| Partij | Waarom deze op de shortlist staat |
|---|---|
| **ZZP Nederland** | Zet het prijsanker voor de hele ZZP-doelgroep op 24,75 per **jaar**. Dit is de zwaarste concurrent en hij stond in geen enkele eerdere analyse |
| **DAS Documentenshop** | Merknaam, 150+ documenten, 299 per jaar onbeperkt. Bewijst dat vertrouwen een hogere prijs draagt dan catalogusomvang |
| **De ContractenFabriek** | 199 per jaar onbeperkt, dus goedkoper dan Essential. Weerlegt "wij zijn de goedkoopste" |
| **VraagHugo** | Enige NL-speler met én een creditmodel én een expliciete adviseurslaag. Het dichtstbijzijnde model bij wat [[ZekerWet]] zou kunnen bouwen |
| **Lawsy** | Meest identieke positionering, en monetiseert het checkout-bezwaar met juristencontrole vanaf 99 |
| **Legalflow** | Volumegrendel in plaats van cataloguslimiet. Beste packaging-les in de markt |
| **Ligo** | Jaarrelatie in plaats van maandabonnement, eerste document gratis, advocatenclaim |
| **Rocket Lawyer NL** | Verdwijnt 31 oktober 2026. Tijdvenster, geen concurrent |
| **Flexmodellen** | Bewijst dat dezelfde catalogus aan een professional twintig keer meer waard is |
| **deLex ICT Modelcontracten** | Enig NL-voorbeeld van expliciete per-seat prijsstelling in dit segment |
| **Firm24** | Bezet het boekhouderskanaal en levert de structuur die daar werkt |
| **JuriBlox** | Documentautomatisering met partnerprogramma, mogelijke partner of concurrent in het kanaal |
| **MKB Juristen** | Zelfde catalogusgetal, tegenovergestelde positionering |
| **Judex** | Gratis, 70+ templates, leadgeneratie. Directe concurrent van de 55 particuliere documenten |
| **Privacy Zeker / ComplianceHive / Blueline** | Vragen 15 tot 29 per maand voor alleen AVG, waar [[ZekerWet]] 24,99 vraagt voor alles |
| **Nmbrs / AFAS / Loket.nl** | Arbeidscontracten zitten al in het payrollpakket van elke MKB'er met personeel |
| **DAS / ARAG rechtsbijstand** | Prijsanker 20 tot 35 per maand voor "juridisch geregeld" |
| **ChatGPT / Claude / Gemini** | Gratis tot 23 per maand. Het alternatief waar niemand over praat |

---

## 6. Gedetailleerde prijsvergelijking

Alles gecontroleerd op 16 september 2026 op de eigen site van de aanbieder, tenzij anders vermeld. "NPG" is niet publiek gevonden.

### 6.1 Abonnementen

| Partij | Plan | Per maand | Per jaar | BTW | Documenten | Gebruikers | Limiet | Zekerheid |
|---|---|---|---|---|---|---|---|---|
| **ZekerWet** | Essential | 24,99 | 239,88 | incl | 233 | 1 | 1 AI-review | Hoog, code |
| **ZekerWet** | Business | 49,99 | 479,88 | incl | 233 | 1 | 10 AI-reviews | Hoog, code |
| **ZekerWet** | Enterprise | 199,99 | 1.919,88 | incl | 233 | 1 | onbeperkt AI | Hoog, code |
| ZZP Nederland | Basis | n.v.t. | 24,75 | NPG | 230+ via generator | 1 | onbeperkt | Middel, BTW onduidelijk |
| ZZP Nederland | Plus | n.v.t. | 75 | NPG | idem | 1 | onbeperkt | Middel |
| ZZP Nederland | Premium | n.v.t. | 160 | NPG | idem plus juridisch advies | 1 | onbeperkt | Middel |
| VraagHugo | Jaarabonnement | n.v.t. | 149 | NPG | 60+ | 1 | 250 credits | Hoog |
| VraagHugo | Pro | n.v.t. | 249 | NPG | 60+ | 1 | 500 credits, ook voor klanten | Hoog |
| De ContractenFabriek | Maand | 29 | n.v.t. | excl | pakketafhankelijk | 1 | onbeperkt | Hoog |
| De ContractenFabriek | Jaar | n.v.t. | 199 | excl | pakketafhankelijk | 1 | onbeperkt | Hoog |
| deLex ICT Modelcontracten | Jaar | n.v.t. | 195 + 45 p/extra gebruiker | NPG | ICT-modellen | 1+ | NPG | Middel, via directory |
| DAS Documentenshop | Jaar | n.v.t. | 299 | NPG | 150+ | NPG | onbeperkt | Hoog |
| Legalflow | Start | 29 | 299 | excl | 100+ | 1 | 1 contract p/m | Hoog |
| Legalflow | Pro | 49 | 499 | excl | 100+ | 1 | onbeperkt | Hoog |
| Ligo | 3 maanden | n.v.t. | 180 per 3 mnd | NPG | 100+ NL en EN | NPG | onbeperkt | Hoog |
| Ligo | 12 maanden | n.v.t. | 499 | NPG | 100+ NL en EN | NPG | onbeperkt | Hoog |
| Lawsy | Starter | 29 | 2 mnd gratis | excl | "alle 5" | 1 | 5 documenten p/m | Hoog |
| Lawsy | Business | 79 | 2 mnd gratis | excl | "alle 5" | 5 | onbeperkt | Hoog |
| Flexmodellen | Turbo Liquidatie | n.v.t. | 395 tot 495 | excl | 6 | 1 | onbeperkt downloaden | Hoog |
| Flexmodellen | Kantoor advocatuur | n.v.t. | 3.745 | excl | 61 | tot 3 | onbeperkt | Hoog |
| Flexmodellen | Notariaat compleet | n.v.t. | 4.995 | excl | 274 | tot 3 | onbeperkt | Hoog |
| Genie AI | Free | 0 | n.v.t. | excl (USD) | 500+ | 1 | export vergrendeld | Hoog |
| Genie AI | Pro | 75 USD (59 bij jaar) | 708 USD | excl | 500+ | 1 | circa 5 docs p/m aan tokens | Hoog |
| Genie AI | Business | 320 USD (259 bij jaar) | 3.108 USD | excl | 500+ | 5 | gedeelde tokenpool | Hoog |
| Privacy Zeker | AVG | vanaf 29 | NPG | NPG | alleen AVG | NPG | NPG | Middel, secundair |
| ComplianceHive | Worker Bee | 10 | NPG | NPG | alleen compliance | onbeperkt | 10 systemen | Middel, secundair |
| Blueline Privacy | All-in | 14,95 | NPG | NPG | alleen AVG | NPG | NPG | Middel, secundair |
| DAS rechtsbijstand ZZP | Verzekering | vanaf circa 22 | NPG | n.v.t. | geen documenten | 1 | dekking, geen documenten | Middel, secundair |

### 6.2 Losse documenten

| Partij | Prijs | BTW | Wat je krijgt | Herhaald genereren |
|---|---|---|---|---|
| **ZekerWet** | 14,99 / 24,99 / 49,99 / 129,99 | incl | PDF | **onbeperkt en levenslang** |
| VraagHugo | 9 tot 99 | NPG | Word en PDF, update-notificaties | NPG |
| Lawsy | 49 | excl | PDF, 30 dagen aanpassen | binnen 30 dagen |
| Legalflow | vanaf circa 129 | excl | contract | 14 of 90 dagen |
| JuriDox / ICTRecht | 45 (AV en privacyverklaring) | excl | document | NPG |
| MKB Juristen | vanaf 99 | NPG | maatwerk door jurist | n.v.t. |
| Ligo | eerste gratis, daarna plan | NPG | document plus e-signing | onbeperkt binnen plan |
| Judex | 0 | n.v.t. | template per mail, leadgeneratie | onbeperkt |
| Rocket Lawyer NL | 19,90 | incl | document | tot 31 oktober 2026 |

### 6.3 Mensenwerk en gratis

| Alternatief | Prijs | Bron |
|---|---|---|
| Jurist per uur | 80 tot 150 | marktoverzichten 2026 |
| Advocaat per uur | 150 tot 500 | marktoverzichten 2026 |
| Algemene voorwaarden laten opstellen, vaste prijs | 499 tot 1.500 excl | aanbieders met vaste tarieven |
| NDA via AI-platform met juristencheck | vanaf 99 | Lawsy |
| Het Juridisch Loket | 0 | overheid |
| KVK | geeft geen modellen | KVK, "kan als overheid niet concurreren met commerciële aanbieders" |
| Belastingdienst modelovereenkomsten | 0 | geldig tot en met 31 december 2029 |
| Steunpunt RI&E | 0 | rie.nl |
| Gemini gratis | 0 | Google |
| Google AI Plus | 4,99 tot 7,99 p/m | Google NL |
| Claude Pro | 15 bij jaar, 18 per maand | Anthropic NL |
| ChatGPT Plus | 23 p/m | OpenAI NL |

---

## 7. Product- en waardevergelijking

Prijsverschil is geen waardeverschil. Waar [[ZekerWet]] werkelijk staat:

| As | ZekerWet | Sterkste in de markt | Oordeel |
|---|---|---|---|
| **Catalogusomvang** | 233 | MKB Juristen 281, Genie AI 500+, DAS 150+, Ligo 100+, Lawsy 5 tot 20 | Bovengemiddeld, maar Lawsy vraagt met vijf documenten vier keer zoveel. Omvang verkoopt niet |
| **AI-review inbegrepen** | Ja, 1 tot onbeperkt | Genie AI (tokens), Lawsy (los, 99), Ligo (juridische scans) | **Echt onderscheidend in de prijsklasse.** Niemand in het NL-segment onder 50 euro geeft review in het abonnement |
| **Juridische autoriteit** | Geen jurist, `claims.json` verbiedt garanties | Ligo "opgesteld door advocaten", Legalflow advocatenkantoor, Lawsy 50+ juristen, DAS merknaam, ICTRecht vakautoriteit | **Zwakste as.** Dit is het bezwaar uit `icp.md` en structureel, niet op te lossen met copy |
| **Bestandsformaten** | Alleen PDF | DAS en VraagHugo: Word én PDF | **Achterstand.** Een klant die iets wil aanpassen kan dat niet |
| **Digitale handtekening** | Niet gevonden | Ligo eIDAS Advanced onbeperkt, ZZP Nederland, Rocket Lawyer | **Gat.** Een contract dat je niet kunt tekenen is half werk |
| **Documentupdates bij wetswijziging** | Niet gevonden als functie | VraagHugo "altijd up-to-date" met notificaties, DAS "voldoet aan actuele wetgeving" | **Gat, en het is er een met terugkerende waarde** |
| **Meerdere gebruikers** | Bestaat niet in het datamodel | Lawsy 5, Genie AI 5, deLex 45 per extra gebruiker, Flexmodellen 3 | **Gat.** Blokkeert het hele MKB-segment |
| **Kluis en terugvindbaarheid** | Ja | VraagHugo dashboard, Ligo | Match |
| **Prijs** | 20,65 netto p/m | ZZP Nederland 2,06 netto p/m | Laag in de markt, niet het laagst |
| **Distributie** | 70 bezoekers p/m, 3 geïndexeerde pagina's | ZZP Nederland ledenbestand, DAS merknaam, Firm24 1800 kantoren | **Verreweg de zwakste as, en de enige die er nu toe doet** |

**De kernconclusie van deze sectie.** [[ZekerWet]] heeft één as waarop het echt wint (AI-review in het abonnement bij een lage prijs) en drie gaten die concurrenten wél dichten (Word-export, ondertekening, meerdere gebruikers). De as waarop het verliest is niet prijs maar vertrouwen en bereik. Prijsverhoging zonder één van die gaten te dichten is daarom een verkoopprobleem en geen omzetoplossing. **AFLEIDING**

---

## 8. Gratis alternatieven

Dit is de categorie die het vorige onderzoek helemaal oversloeg, en hij is groot.

| Alternatief | Kost | Wat het wegneemt van [[ZekerWet]] |
|---|---|---|
| **Judex** | 0 | 70+ templates over huur, consument, familie, ontslag, letsel. Dekt een groot deel van de 55 particuliere documenten |
| **Gemini gratis, ChatGPT gratis, Claude gratis** | 0 | De hele lage kant. Een ZZP'er die een NDA wil, vraagt het gewoon |
| **ikwordzzper.nl, voorbeeldalgemenevoorwaarden.nl, zzpmodelovereenkomsten.nl** | 0 | Algemene voorwaarden, modelovereenkomsten, ondertekening |
| **Belastingdienst** | 0 | Modelovereenkomsten, geldig tot en met 31 december 2029. Precies het onderwerp van de lopende campagne |
| **Steunpunt RI&E** | 0 | De RI&E die Business als betaalde feature noemt |
| **Het Juridisch Loket** | 0 | Eerstelijns juridische vragen |
| **ZZP Nederland Basis** | 24,75 per jaar | 230+ documenten in een generator plus gratis incasso |

**Wat dit betekent voor de prijszetting.** De onderkant van deze markt is nul en er is geen enkel teken dat dat verandert. Een strategie die wint op prijs verliest daarom altijd, want gratis is goedkoper. Wat gratis niet kan: weten welk document je nodig hebt, het invullen met jouw situatie, het bewaren en terugvinden, en vertellen wat er mis is met een document dat je al hebt. Dat laatste is de AI-review, en dat is wat gratis alternatieven structureel niet bieden. **AFLEIDING**

---

## 9. Professionele en juridische alternatieven

| Route | Prijs | Wanneer een ondernemer die kiest |
|---|---|---|
| Jurist per uur | 80 tot 150 | Als het ergens over gaat en de uitkomst betwist kan worden |
| Advocaat per uur | 150 tot 500 | Bij conflict of bij een transactie |
| Vaste prijs AV laten opstellen | 499 tot 1.500 excl | Als hij het één keer goed wil hebben |
| MKB Juristen maatwerk | vanaf 99 | Tussenvorm: vaste prijs, mensenwerk |
| Lawsy juristencheck | 99, of 199 met gesprek | Als hij het zelf heeft gemaakt en bevestiging wil |
| Blended.Law | vaste prijs per klus | Marktplaats tussen tool en kantoor |
| Rechtsbijstandverzekering | 20 tot 35 p/m | Vooraf, tegen conflicten, niet tegen documenten |

De prijs van 99 euro voor een juristencheck is het scharnierpunt van deze hele markt. Het is het bedrag waarvoor het grootste bezwaar tegen elk AI-document wordt weggenomen, en het is een bedrag dat een ondernemer één keer per jaar makkelijk uitgeeft. Lawsy heeft daar een dienst van gemaakt. **FEIT** en **AFLEIDING**

---

## 10. Revenue leakage audit

Alleen aantoonbare lekken, met bewijs uit de code. Geen aanname dat iets duurder moet.

| # | Lek | Bewijs | Omvang | Zekerheid |
|---|---|---|---|---|
| 1 | **BTW in plaats van erop** | Geen `automatic_tax`, geen `tax_behavior` in `stripe.service.ts` | **17,4 procent van alle omzet** | FEIT |
| 2 | **Levenslange documenttoegang** | `DocumentPurchase` heeft geen teller en geen vervaldatum | Onbekend, nu nul verkopen | FEIT |
| 3 | **Tiers differentiëren alleen op AI** | `access.ts:32`, `AI_LIMITS` | Business en Enterprise hebben geen verdedigbare meerprijs | FEIT |
| 4 | **Geen seats** | Geen `Team` in `schema.prisma` | Elk MKB met meer dan één gebruiker betaalt één keer | FEIT |
| 5 | **Geen documentlimiet voor betalende klanten** | Alleen `TRIAL_DOC_LIMIT` | Geen upgradepad op volume | FEIT |
| 6 | **Geen kortingscodes** | Geen `allow_promotion_codes` | Geen verrekening los naar abonnement, geen partnerkorting, geen actie mogelijk | FEIT |
| 7 | **Geen upsell van los naar abonnement** | Enige upgrade-prompt zit op de trial-limiet | Elke losse koper is een doodlopende weg | FEIT |
| 8 | **Jaarbetaling niet als standaard** | `useState(false)` op de pricingpagina | Mist de cashflow en retentie die Ligo en Legalflow wél pakken | FEIT |
| 9 | **Geen review-upsell** | Geen losse review-aankoop in de code | Lawsy vraagt 99 voor wat hier niet te koop is | FEIT |
| 10 | **Geen Word-export** | Alleen `pdf-service.ts` | Concurrenten leveren beide. Niet direct omzet, wel een koopreden | FEIT |
| 11 | **Geen updatedienst** | Geen versiebeheer per documenttype gevonden | VraagHugo en DAS verkopen actualiteit als doorlopende waarde | FEIT |
| 12 | **Admin-bypass geeft enterprise** | `subscription.ts`, `isAdmin` geeft `plan: 'enterprise'` | Geen lek vandaag, wel een risico bij meer adminaccounts | FEIT |

### 10.1 Het grootste lek, uitgerekend

Lek 1 is de enige waar een exact bedrag op staat en hij is groot genoeg om alle andere te overstemmen.

Bij 15.000 euro netto doel: als de prijzen exclusief BTW zouden worden getoond en de klant hetzelfde headline-bedrag betaalt, levert 24,99 per klant 24,99 netto op in plaats van 20,65. Dat is 21 procent meer netto-omzet bij een identiek ogende prijs, en voor een BTW-plichtige klant is het verschil nul, want hij trekt de BTW af.

**Maar dit mag niet zomaar.** Prijzen exclusief BTW tonen is alleen toegestaan als een onderneming zich uitsluitend op zakelijke klanten richt, en dan moet er expliciet "exclusief 21% btw" bij staan. Verkoop je ook aan consumenten, dan moeten de prijzen inclusief. Dat kan worden opgelost door bij de checkout verplicht een bedrijfsnaam en KVK- of BTW-nummer te vragen, waardoor consumenten effectief worden uitgesloten. **FEIT**

Dat maakt het een gekoppelde beslissing en geen losse knop: exclusief BTW gaan betekent afscheid nemen van de particuliere koper, en dus van de 55 particuliere documenten als verkoopbaar product.

---

## 11. Unit economics, herberekend

### 11.1 Kostensoorten

| Soort | Post | Bedrag | Zekerheid |
|---|---|---|---|
| **Vast** | Vercel Hobby | 0 | FEIT |
| **Vast** | Clerk Hobby | 0 | FEIT |
| **Vast** | Database en Redis | **onbekend** | Moet uit de Vercel-omgevingsvariabelen |
| **Vast** | Resend e-mail | **onbekend** | Moet uit het Resend-dashboard |
| **Vast** | Sentry | **onbekend** | Moet uit het Sentry-dashboard |
| **Marginaal per AI-review** | Gemini flash-lite | **0,0058 worst case** | FEIT, uit `cost-meter.ts` en de prijslijst van Google |
| **Marginaal per document** | Vercel Active CPU | **niet gemeten** | Zie 11.3 |
| **Marginaal per klant** | Stripe kaart | 1,5% + 0,25 | FEIT |
| **Marginaal per klant** | Stripe iDEAL | 0,29 vast | FEIT |
| **Marginaal per klant** | Opslag documenten | verwaarloosbaar, Json in Postgres | AFLEIDING |

### 11.2 De AI-kosten, opnieuw bevestigd

Invoer maximaal 15.000 tekens, circa 3.750 tokens, à 0,28 euro per miljoen is 0,00105. Uitvoer maximaal 2.048 tokens à 2,34 euro per miljoen is 0,00479. Samen 0,0058 euro per review. De prijzen in `cost-meter.ts` komen overeen met de actuele Google-prijslijst voor gemini-3.5-flash-lite (0,30 en 2,50 dollar per miljoen) en zijn bewust naar boven afgerond.

Daar komt een besparing bovenop die in het vorige document ontbrak: `AiUsageLog` heeft een `cachedHit`-veld en een `inputHash` over promptversie plus type plus gesaneerde tekst. Een identieke review kost dus nul. **FEIT**

### 11.3 De marginale kosten per document, en waarom Hobby het plafond is

Documentgeneratie raakt geen enkele externe dienst. De kosten zijn CPU-tijd op Vercel. Die is niet gemeten.

Wat wel vaststaat is de Hobby-toewijzing: 4 CPU-uur Active CPU, 360 GB-uur geheugen, 1 miljoen function invocations en 100 GB Fast Data Transfer per maand. 4 CPU-uur is 14.400 CPU-seconden.

| Actieve CPU per PDF | Documenten per maand binnen Hobby |
|---|---|
| 1 seconde | 14.400 |
| 3 seconden | 4.800 |
| 5 seconden | 2.880 |
| 10 seconden | 1.440 |

Bij 600 Essential-klanten die elk acht documenten per maand maken, zijn dat 4.800 generaties. Dat is precies de orde van grootte waarin Hobby knelt. **Dit is een rekenvoorbeeld en geen meting**: de werkelijke CPU-tijd per generatie moet uit Vercel Observability komen. Maar het laat zien dat het Hobby-besluit geen kostenvraag is maar een capaciteitsvraag, en dat de grens ergens ligt tussen de duizend en vijftienduizend documenten per maand. **AFLEIDING**

### 11.4 Contributiemarge per plan

Per maand, in euro, bij kaartbetaling. BTW eruit gedeeld door 1,21. Stripe gerekend over het brutobedrag.

| | Essential | Business | Enterprise | Doc Basis | Doc Specialist |
|---|---|---|---|---|---|
| Bruto | 24,99 | 49,99 | 199,99 | 14,99 | 129,99 |
| BTW af | −4,34 | −8,68 | −34,71 | −2,60 | −22,56 |
| **Netto** | **20,65** | **41,31** | **165,28** | **12,39** | **107,43** |
| Stripe | −0,62 | −1,00 | −3,25 | −0,47 | −2,20 |
| AI worst case | −0,01 | −0,06 | −11,70 | 0 | 0 |
| **Contributiemarge** | **20,02** | **40,25** | **150,33** | **11,92** | **105,23** |
| **Marge %** | **97%** | **97%** | **91%** | **96%** | **98%** |

### 11.5 Jaar tegenover maand, uitgerekend

Dit stond in geen enkel eerder document en het is een echte beslissing.

Essential maandelijks: 12 × 20,02 = 240,24 per jaar, mits de klant twaalf maanden blijft.
Essential jaarlijks: bruto 239,88, netto 198,25, Stripe éénmalig 3,85, AI verwaarloosbaar, dus **194,33 per jaar**.

De jaarklant levert 45,91 minder op, maar betaalt vooruit en kan twaalf maanden niet opzeggen. Het omslagpunt: jaarbetaling is voordeliger voor [[ZekerWet]] zodra de gemiddelde klantlevensduur onder **9,7 maanden** ligt.

Bij één klant is de levensduur onbekend. Maar in een markt met maandopzegging en een onbekend merk is negen maanden geen hoge lat. **AFLEIDING**

Bijkomend: maandbetaling kost twaalf keer Stripe-transactiekosten (7,44 per jaar) tegen één keer bij jaarbetaling (3,85). Dat is 3,59 per klant per jaar dat nu weglekt aan betaalkosten alleen.

### 11.6 Kosten of waarde?

De contributiemarge ligt tussen 91 en 98 procent. De marginale kosten per extra klant zijn een paar cent. Er bestaat geen prijs waaronder [[ZekerWet]] verlies maakt zolang hij boven ongeveer 50 cent per maand ligt.

**Dat betekent dat kosten geen enkele informatie geven over wat de prijs moet zijn.** De prijs moet volledig uit klantwaarde en marktpositie komen. Kostengebaseerd denken leidt hier tot precies de fout die nu in de markt zichtbaar is: 233 documenten voor 20,65 netto, terwijl Lawsy er vijf verkoopt voor 79. **AFLEIDING**

---

## 12. 15.000 euro exclusief BTW, teruggerekend

Doel: 15.000 euro netto-omzet per maand.

### 12.1 Aantal klanten per prijspunt

Twee kolommen, omdat [[ZekerWet]] nu inclusief BTW prijst en de markt exclusief. Dit is geen aanbeveling en geen rangorde.

| Prijspunt | Netto p/m als prijs **incl** BTW is (nu) | Klanten nodig | Netto p/m als prijs **excl** BTW is | Klanten nodig |
|---|---|---|---|---|
| 19,99 | 16,52 | **908** | 19,99 | **751** |
| 24,99 | 20,65 | **727** | 24,99 | **601** |
| 29,99 | 24,79 | **606** | 29,99 | **501** |
| 34,99 | 28,92 | **519** | 34,99 | **429** |
| 39,99 | 33,05 | **454** | 39,99 | **376** |
| 49,99 | 41,31 | **364** | 49,99 | **301** |
| 59,99 | 49,58 | **303** | 59,99 | **251** |
| 79,99 | 66,11 | **227** | 79,99 | **188** |
| 99,99 | 82,64 | **182** | 99,99 | **151** |
| 149,99 | 123,96 | **121** | 149,99 | **101** |
| 199,99 | 165,28 | **91** | 199,99 | **76** |

De hele rechterkolom is 17,4 procent minder klanten voor exact hetzelfde headline-bedrag. Dat is sectie 10.1 in tabelvorm.

### 12.2 Gemengde scenario's

| Mix | Samenstelling | ARPU netto | Klanten nodig |
|---|---|---|---|
| Essential-zwaar | 90% Essential, 10% Business | 22,72 | **661** |
| Huidige verdeling doorgetrokken | 70% Essential, 30% Business | 26,85 | **559** |
| Evenwichtig | 50% Essential, 50% Business | 30,98 | **485** |
| Business-zwaar | 30% Essential, 70% Business | 35,11 | **428** |
| Met Enterprise-component | 60% Essential, 35% Business, 5% Enterprise | 35,15 | **427** |
| Abonnement plus losse verkoop | 400 Business-klanten (16.524 netto) | n.v.t. | **doel gehaald zonder losse verkoop** |
| Losse verkoop als aanvulling | 300 Business (12.393) plus 211 losse documenten à 12,39 | n.v.t. | **300 abonnees plus 211 losse verkopen elke maand opnieuw** |

Dat laatste scenario is het belangrijkste om te begrijpen. Losse verkoop is eenmalig: die 211 verkopen moeten elke maand opnieuw. Bij een abonnement komt de omzet vanzelf terug. Losse verkoop is daarom een instapkanaal en geen omzetpijler, en dat is meteen het argument om hem zo te prijzen dat hij naar het abonnement leidt. **AFLEIDING**

### 12.3 Hoe afhankelijk het doel is van churn

Om een klantenbestand op peil te houden bij maandelijkse churn `c` heb je elke maand `N × c` nieuwe klanten nodig, alleen om stil te staan.

| ARPU netto | Klanten voor 15.000 | Nieuw p/m bij 2% churn | bij 5% | bij 8% |
|---|---|---|---|---|
| 20,65 (Essential incl BTW) | 727 | 15 | 36 | 58 |
| 26,85 (mix 70/30) | 559 | 11 | 28 | 45 |
| 41,31 (Business incl BTW) | 364 | 7 | 18 | 29 |
| 49,99 (Business excl BTW) | 301 | 6 | 15 | 24 |
| 82,64 (99,99 incl BTW) | 182 | 4 | 9 | 15 |

**Dit is het sterkste argument voor hogere ARPU dat er is, en het gaat niet over marge.** Bij 20,65 en 5 procent churn moet er elke maand 36 keer een nieuwe klant binnenkomen om op nul uit te komen. Bij 82,64 zijn dat er negen. Met 70 bezoekers per maand is het verschil tussen negen en zesendertig het verschil tussen mogelijk en onmogelijk. **AFLEIDING**

Churn is onbekend bij één klant. De getallen hierboven zijn een gevoeligheidsanalyse en geen voorspelling.

### 12.4 Wat 15.000 netto per maand niet is

Het is geen winst: daar moeten de vaste kosten nog vanaf, waarvan er drie onbekend zijn. Het is geen cashflow: bij jaarbetaling komt het geld vooruit en bij maandbetaling gespreid. En het is geen contributiemarge: die ligt bij deze omzet rond de 96 procent, dus ongeveer 14.400 euro per maand vóór vaste kosten. Zolang de vaste kosten onbekend zijn, is winst niet te berekenen. **AFLEIDING**

---

## 13. Willingness to pay

Wat er over de verschillende segmenten te zeggen valt, met het label erbij. Er is geen enkele klantinterview gedaan, dus vrijwel alles hier is hypothese.

| Segment | Aanleiding | Alternatieve kosten | Waarschijnlijke WTP | Label |
|---|---|---|---|---|
| **Particulier, eenmalig** | Bezwaar WOZ, huuropzegging, klacht | Judex gratis, gratis AI | 0 tot 25 eenmalig | **Marktdata**: Judex geeft het gratis, VraagHugo vraagt vanaf 9 |
| **ZZP'er, één document** | Eerste opdrachtgever wil een contract | 499+ bij een jurist, gratis bij AI | 15 tot 50 eenmalig | **Marktdata**: Lawsy 49, VraagHugo 9 tot 99, ICTRecht 45 |
| **ZZP'er, doorlopend** | Meerdere opdrachtgevers, AV, privacy | ZZP Nederland 24,75 p/j | 2 tot 25 per maand | **Marktdata en hypothese**: het bereik is enorm omdat ZZP Nederland de bodem legt |
| **Kleine werkgever** | Arbeidscontract, ontslag, verbeterplan | Advocaat 150 tot 500 p/u, payroll heeft contracten al | 25 tot 100 per maand | **Hypothese**: het risico is echt (een fout ontslag kost duizenden), maar payroll dekt het basiscontract al |
| **MKB met compliance-last** | AVG, NIS2, RI&E, meerdere gebruikers | Privacy Zeker 29 p/m voor alleen AVG | 50 tot 150 per maand | **Marktdata**: de AVG-only-spelers zitten al op 15 tot 29 |
| **Boekhoudkantoor, eigen praktijk** | Eigen opdrachtbevestigingen, AV, verwerkersovereenkomsten | Flexmodellen 3.745 p/j voor advocaten | 150 tot 500 per jaar | **Marktdata**: VraagHugo Pro 249, deLex 195+45 |
| **Boekhoudkantoor, voor klanten** | Klanten bedienen zonder door te verwijzen | Firm24-model | onbekend | **Hypothese**: nul gesprekken gevoerd |

**Waar de hoogste betalingsbereidheid waarschijnlijk zit.** Niet bij de ZZP'er, want daar ligt de bodem op gratis en de vereniging op 24,75 per jaar. Wel bij de werkgever (het risico is in euro's uit te drukken) en bij het kantoor (het is een bedrijfsmiddel en geen kostenpost). Flexmodellen is daarvan het harde bewijs: dezelfde soort catalogus, twintig keer de prijs, alleen omdat de koper een professional is. **AFLEIDING**, en het is de belangrijkste hypothese om te toetsen.

---

## 14. Strategie voor losse documentverkoop

### 14.1 Wat de markt doet

| Model | Wie | Prijs | Wat de klant krijgt |
|---|---|---|---|
| Eenmalig document | Lawsy | 49 excl | Eén document, 30 dagen aanpassen |
| Eenmalig, gestaffeld | VraagHugo | 9 tot 99 | Word en PDF, update-notificaties |
| Eenmalig, vakspecifiek | ICTRecht / JuriDox | 45 excl | Document van een vakautoriteit |
| Gratis als lead | Judex | 0 | Template per mail, daarna consultgesprek |
| Eerste gratis | Ligo, Lawsy | 0 | Eén document om je binnen te halen |
| **Levenslang per type** | **ZekerWet** | **14,99 incl** | **Onbeperkt genereren, voor altijd** |

[[ZekerWet]] is de enige in deze lijst met levenslange toegang per documenttype. **FEIT**

### 14.2 Zes modellen, gewogen

| Model | Wat het is | Voor | Tegen | Bouwlast |
|---|---|---|---|---|
| **A. Eenmalig** | Eén betaling, één document | Wat de klant verwacht, sluit aan bij Lawsy | Klant die een typefout maakt betaalt opnieuw en wordt boos | Laag |
| **B. Eenmalig plus x regeneraties** | Bijvoorbeeld drie keer | Vangt de typefout af | Willekeurig getal, moeilijk uit te leggen | Laag |
| **C. Update-venster** | 30 of 90 dagen onbeperkt | Legalflow doet dit, vriendelijk en uitlegbaar | Vereist een vervaldatum op `DocumentPurchase` | Laag |
| **D. Document plus juristencheck** | Upsell van 99 | Monetiseert het grootste bezwaar, zoals Lawsy | **Vereist een jurist. Die is er niet** | Hoog, niet technisch |
| **E. Eenmalig met verrekening naar abonnement** | Eerste aankoop binnen 30 dagen aftrekken | Maakt van elke losse koper een abonnementskandidaat | Vereist `allow_promotion_codes`, dat staat uit | Laag |
| **F. Credits** | Zoals VraagHugo: 4 tot 50 credits per document | **De classificatie ligt er al**: 89 basis, 84 standaard, 53 professioneel, 7 specialist | Credits zijn een extra concept om uit te leggen | Middel |

### 14.3 Wat ontbreekt voordat hier een besluit over kan

Er is nul losse verkoop geweest. Er is dus geen enkel signaal over welk documenttype los verkocht wordt, tegen welke prijs iemand afhaakt, of een losse koper ooit terugkomt. **Elke keuze hier is nu een gok.** Wat het goedkoopst te leren is: model C of E aanzetten en drie maanden meten, want beide zijn klein in bouwlast en geen van beide maakt het aanbod slechter voor de klant.

---

## 15. Abonnementsstrategie

De zeven vragen die de structuur bepalen, met wat het onderzoek erover zegt.

| Vraag | Wat de markt doet | Wat dat betekent |
|---|---|---|
| **Waarop grendelen?** | Legalflow op volume, Lawsy op volume, Genie AI op AI-tokens en gebruikers, Flexmodellen op vakgebied, deLex op gebruikers. **Niemand grendelt op catalogus** | De huidige AI-grendel is niet gek, maar 1 review per maand is te krap om waarde te tonen |
| **Hoeveel tiers?** | Drie is standaard, Lawsy en Legalflow doen er twee plus gratis | Drie is prima. Enterprise zonder multi-user is de zwakke schakel |
| **Gratis of trial?** | Ligo, Lawsy, Genie AI en Judex geven allemaal iets echt gratis weg. Genie AI geeft de hele catalogus en vergrendelt de export | Een creditcardmuur bij 70 bezoekers per maand is de duurste keuze in de markt |
| **Maand of jaar?** | Ligo alleen jaar en kwartaal, ContractenFabriek, DAS, deLex, Flexmodellen, VraagHugo en ZZP Nederland alleen jaar | **De meerderheid van de Nederlandse markt verkoopt per jaar.** [[ZekerWet]] toont maand als standaard |
| **Per gebruiker?** | deLex 45 per extra gebruiker, Lawsy 5 inbegrepen, Genie AI 5 | Geen `Team` in het datamodel, dus deze as is dicht |
| **Inclusief of exclusief BTW?** | Legalflow, Lawsy, ContractenFabriek, Flexmodellen: allemaal exclusief | [[ZekerWet]] is inclusief en dat kost 17,4 procent |
| **Wat rechtvaardigt een hogere tier?** | Genie AI: meer AI en meer gebruikers. Lawsy: gebruikers. Legalflow: volume en bewerktermijn | Kunstmatige features om een tier te vullen komen in de markt niet voor. De claims in `PLAN_TIERS` zijn de uitzondering |

---

## 16. Accountantskanaal

### 16.1 Wat deze ronde toevoegt

Er bestaat al een adviseurslaag in de Nederlandse markt en die is niet van Firm24. **VraagHugo Hugo Pro kost 249 euro per jaar en de propositie luidt letterlijk "Maak ook voor je klanten documenten", tegenover 149 euro voor de gewone jaarlijkse gebruiker.** Dat is een prijsverschil van 100 euro per jaar voor het recht om voor klanten te werken, plus dubbel zoveel credits. **FEIT**

Dat is commercieel belangrijk om drie redenen. Het bewijst dat de behoefte bestaat. Het geeft een prijsanker voor een kantoorlaag. En het is een licentie en geen provisie, waardoor het hele beroepsrechtelijke probleem uit sectie 17 er niet op van toepassing is.

deLex doet hetzelfde in een andere vorm: 195 voor de eerste gebruiker en 45 voor elke volgende. Flexmodellen vraagt kantoren 3.745 tot 4.995 per jaar. Firm24 geeft de adviseur een gratis account en verdient aan de dienst eronder.

**Vier verschillende Nederlandse partijen bedienen dus al professionals met een eigen prijs, en geen van hen doet dat met een verwijsvergoeding.** **AFLEIDING**

### 16.2 Acquisitiekanalen

| Kanaal | Wanneer het past | Doel | Frictie | Wat je niet doet |
|---|---|---|---|---|
| Persoonlijke introductie | Je kent iemand | Leren | Laagst | Een aanbod doen in het eerste contact |
| Telefoon | Klein kantoor, eigenaar neemt op | Afspraak | Middel | Bellen in de aangiftepiek, maart tot mei |
| E-mail | Als opvolging | Iets achterlaten | Laag warm, hoog koud | Massamail |
| LinkedIn-post | Doorlopend | Gezien worden vóór je belt | Nihil | Verkoopposts |
| LinkedIn DM | Na echte interactie | Gesprek openen | Middel | Koude DM met pitch |
| Fysieke afspraak | Na een goed telefoongesprek | Vertrouwen en leren | Hoog in tijd | Rijden voor een kennismaking |
| Brancheorganisaties (NOAB, RB, NBA, SRA) | Na drie bevestigende gesprekken | Schaal | Hoog, lange doorlooptijd | Hier beginnen |
| Webinars | Na een werkend verhaal | Meerdere kantoren tegelijk | Middel | Organiseren zonder publiek |
| Accountantssoftware-ecosystemen (Nmbrs, AFAS, e-Boekhouden, Informer) | Veel later | Distributie via een platform | Zeer hoog | Nu benaderen |
| Referrals | Vanaf circa tien klanten | Goedkoopste groei | Laag | Vragen bij nul resultaat |
| Events | Toevallig | Ontmoetingen | Middel | Erop rekenen als kanaal |

### 16.3 Toon

Wat werkt: je-vorm, onder de 120 woorden, één concrete vraag, founder-led als [[Ali Can]] en niet als merk, probleemgericht.

Wat niet werkt en waarom: "AI vervangt juristen" (zet de beroepsgroep tegen je op en is feitelijk onjuist), garanties over rechtsgeldigheid (`claims.json` verbiedt ze en het kantoor voelt aansprakelijkheid), commissietaal (roept precies het beroepsrechtelijke bezwaar op uit sectie 17), en woorden als platform, oplossing, partnership en synergie.

De structuur ligt vast en er wordt niet van afgeweken: kennismaking, diagnosegesprek, probleem valideren, workflow begrijpen, pilot, meten, en pas daarna partnership.

---

## 17. Partner-economics en beroepsregels

Alle bronnen gecontroleerd op 16 september 2026. De formuleringen zijn bewust voorzichtig: waar een bron niet duidelijk is, staat dat er.

| Groep | Bron en datum | Wat de bron zegt | Conclusie |
|---|---|---|---|
| **RB** | Reglement Beroepsuitoefening art. 15, versie 001 gedateerd 01-01-2015, gepubliceerd op rb.nl | "Het is een lid niet toegestaan vergoedingen in enige vorm te geven of te ontvangen voor het bezorgen van opdrachten, tenzij het een vergoeding betreft voor het overnemen of overdragen van een praktijk." Toelichting: ook "giften, invitaties, kortingen, betalingen in natura" boven symbolische waarde tellen mee | **Niet toegestaan volgens de bron**, voor zowel provisie als een gratis account dat aan doorverwijzen hangt. Let op: de gepubliceerde versie is uit 2015 en er kan een nieuwere zijn |
| **NOB** | Reglement Beroepsuitoefening, laatst gewijzigd 12 mei 2025, toelichting art. 1, 4 en 9 gewijzigd 30 maart 2026 | Commissies "toegestaan mits de vrijheid en onafhankelijkheid gewaarborgd zijn, het belang van de cliënt voorop staat en de belastingadviseur transparant is over samenwerkingen". Met een expliciet voorbeeld over software die kantoren aan cliënten ter beschikking stellen, waarbij het kantoor een jaarlijkse vergoeding kan ontvangen | **Lijkt toegestaan volgens de bron, onder voorwaarden** |
| **NBA** | VGBA, art. 10a, 11, 11a en 21 | Geen apart provisieartikel. Wel: niet ongepast laten beïnvloeden (art. 11), geen geschenk aannemen waarvan je weet dat het tot onethisch gedrag aanzet (art. 11a), en een bedreigingenmodel (art. 21) | **Bron is niet duidelijk over provisie.** Geen verbod gevonden, wel een toets per geval |
| **NOAB** | Niet als primaire bron gelezen | Secundaire bronnen noemen vergelijkbare onafhankelijkheidseisen | **Onbekend. Moet per kantoor gevraagd worden** |
| **Geen aansluiting** | n.v.t. | Geen beroepsregel | Vrij, maar dan valt het vertrouwensargument weg |

**Juridisch advies nodig** voordat er een partneraanbod met een geldstroom wordt gedaan aan een RB- of NBA-aangesloten kantoor. Dit onderzoek stelt vast wat de reglementen zeggen; of een concrete constructie standhoudt is een vraag voor iemand met de bevoegdheid daarover te oordelen.

### 17.1 De structuren opnieuw gewogen, met wat deze ronde toevoegt

| Structuur | Beroepsrechtelijk | Marktbewijs | Oordeel |
|---|---|---|---|
| **Kantoorlicentie met recht om voor klanten te werken** | Schoon: het kantoor koopt software | **VraagHugo Hugo Pro, 249 p/j** | Sterkste kandidaat. Geen geldstroom naar het kantoor, dus geen provisievraag |
| **Per extra gebruiker** | Schoon | **deLex, 195 + 45** | Vereist een `Team`-model dat er niet is |
| **Opslag op eigen factuur** | Schoon: eigen werk, eigen factuur | **Firm24, 1800+ kantoren** | Robuust, maar vereist dat het kantoor factureert |
| **Gratis account voor eigen praktijkgebruik** | Schoon mits niet aan doorverwijzen gekoppeld | Firm24 geeft de adviseur een gratis account | Veilig als het geen beloning is |
| **Klantkorting zonder tegenprestatie** | Schoon, het voordeel gaat naar de cliënt | Gangbaar | Veilig, maar geeft het kantoor geen reden |
| **Referral fee of revenue share** | RB niet toegestaan, NOB onder voorwaarden, NBA onduidelijk | Weinig zichtbaar in deze markt | Alleen na bevestiging per kantoor en juridisch advies |
| **White label** | Schoon, het wordt hun dienst | Firm24, JuriBlox | Te vroeg, bestaat niet in de code |

**De verschuiving ten opzichte van vanochtend.** Het gesprek ging over hoe je een kantoor beloont voor doorverwijzen. Het marktbewijs zegt dat de werkende vorm helemaal geen beloning is: het kantoor koopt een licentie die duurder is dan de gewone, omdat hij er meer mee mag. Dan is er geen vergoeding, geen provisie en geen beroepsrechtelijk probleem. **AFLEIDING**

---

## 18. Pricingarchitecturen

Zeven scenario's. Geen rangorde, geen score, geen winnaar.

### Scenario A. Eén eenvoudig abonnement

Eén prijs, alles inbegrepen, maand of jaar.

**Doelgroep** ZZP en klein MKB. **Voorbeeld** 29,99 per maand of 299 per jaar.
**Voor** Maximaal simpel, hoogste conversie per bezoeker, niets uit te leggen, geen tierverwarring, geen Business-val.
**Tegen** Geen upsell, ARPU zit vast, geen route naar MKB of kantoor.
**Omzet** Voorspelbaar, plafond gelijk aan prijs maal klanten. **Conversie** Waarschijnlijk hoogste van alle scenario's. **Complexiteit** Laagst: twee tiers weg. **Psychologie** Eén prijs leest als eerlijk. **Lek** Geen tierverwarring, maar alles wat boven de prijs betaalbaar was, blijft liggen. **Operationeel** Simpelst.

### Scenario B. Abonnement plus credits

Basisabonnement met een creditpot, documenten kosten credits naar complexiteit.

**Doelgroep** Alle segmenten. **Voorbeeld** 19,99 p/m met 100 credits; basis 4, standaard 8, professioneel 20, specialist 50 credits; bijkopen zoals VraagHugo.
**Voor** De classificatie ligt er al in `DOCUMENT_PRICING`. Zware gebruikers betalen meer zonder dat lichte gebruikers worden weggejaagd. Marktbewijs bij VraagHugo.
**Tegen** Credits zijn een extra concept; een klant die halverwege leegloopt is een boze klant.
**Omzet** Schaalt met gebruik. **Conversie** Lager bij de instap door uitleglast. **Complexiteit** Middel: creditsaldo, verbruik, bijkoop. **Psychologie** Credits maken waarde zichtbaar maar voelen als een meter die loopt. **Lek** Klein. **Operationeel** Middel, credits moeten kloppen.

### Scenario C. Abonnement plus losse documenten

Huidige structuur, maar de losse verkoop wordt gerepareerd en gaat naar het abonnement leiden.

**Doelgroep** Losse koper als instap, abonnee als bestemming. **Voorbeeld** losse documenten 19,99 tot 149,99 met verrekening bij upgrade binnen 30 dagen.
**Voor** Kleinste verandering, dicht het grootste aantoonbare lek, gebruikt SEO-verkeer per document.
**Tegen** Lost de tierverwarring niet op.
**Omzet** Extra eenmalige omzet plus meer instroom. **Conversie** Hoger op documentpagina's. **Complexiteit** Laag, mits `allow_promotion_codes` aan kan. **Lek** Dicht lek 2 en 7. **Operationeel** Laag.

### Scenario D. Freelancer, Business, Professional, Enterprise

Vier tiers waarvan de bovenste twee echt bestaan.

**Doelgroep** ZZP, MKB, kantoor, organisatie. **Voorbeeld** 24,99 / 49,99 / 149,99 / op aanvraag, met Professional als kantoorlaag.
**Voor** Volgt de betalingsbereidheid uit sectie 13, en er is marktbewijs voor de kantoorlaag.
**Tegen** Vereist een `Team`-model dat niet bestaat. Vier tiers is meer uitleg.
**Omzet** Hoogste plafond. **Conversie** Onveranderd onderin. **Complexiteit** Hoogst: seats bouwen. **Psychologie** Vier tiers werkt alleen als elke tier echt iets toevoegt. **Lek** Dicht lek 3 en 4. **Operationeel** Hoog.

### Scenario E. Basisabonnement met add-ons

Eén basis, daarnaast losse modules: AI-reviewpakket, compliancepakket, juristencheck, extra gebruikers.

**Doelgroep** Iedereen betaalt de basis, zwaardere klanten kopen bij. **Voorbeeld** 29,99 basis, AI-pakket 9,99, juristencheck 99 per stuk.
**Voor** Geen kunstmatige tiers, elke add-on is echte waarde, en de juristencheck volgt het bewezen Lawsy-model.
**Tegen** De juristencheck vereist een jurist. Zonder die persoon is dit scenario half.
**Omzet** ARPU groeit met de behoefte. **Conversie** Instap blijft laag en dus makkelijk. **Complexiteit** Middel technisch, hoog operationeel. **Lek** Dicht lek 9. **Operationeel** Hoog zodra er mensenwerk in zit.

### Scenario F. Gratis, betaald, zakelijk

Een echte gratis laag, zoals Genie AI: hele catalogus zichtbaar, export vergrendeld.

**Doelgroep** Gratis is SEO en acquisitie, betaald is ZZP, zakelijk is MKB. **Voorbeeld** gratis met watermerk of zonder download, 29,99 betaald, 79,99 zakelijk.
**Voor** Lost het distributieprobleem aan de voorkant op, en dat is het echte knelpunt. Marktbewijs bij Genie AI, Ligo, Lawsy en Judex. Maakt van 233 documentpagina's echte landingspagina's.
**Tegen** Kannibaliseert de losse verkoop van 14,99 volledig. Gratis gebruikers kosten CPU, en dat raakt de Hobby-grens uit 11.3.
**Omzet** Lager per gebruiker, hoger totaal als de trechter vult. **Conversie** Sterkste effect bovenin. **Complexiteit** Middel: een gratis niveau in `access.ts` en een vergrendelde export. **Psychologie** Sterkst: de klant ziet het resultaat vóór hij betaalt, wat precies het vertrouwensbezwaar aanpakt. **Lek** Vervangt losse verkoop door een trechter. **Operationeel** Middel.

### Scenario G. Hybride

Gratis laag plus één eenvoudig abonnement plus een kantoorlicentie plus losse documenten voor wie niet wil abonneren.

**Voor** Bedient alle segmenten uit sectie 13 zonder kunstmatige features.
**Tegen** Het meeste om te bouwen en uit te leggen, en er zijn nu geen klanten om het op te testen.
**Complexiteit** Hoog. **Lek** Dicht de meeste. **Operationeel** Hoog.

### 18.1 Wat er ontbreekt om tussen deze zeven te kiezen

Dit is de belangrijkste alinea van dit document. Zeven scenario's en geen enkele manier om ze op data te wegen, want:

1. **Er is geen conversiecijfer.** 70 bezoekers, 1 klant. Onbruikbaar.
2. **Er is geen churncijfer.** Eén klant, twaalf dagen.
3. **Er is geen prijselasticiteit.** Nooit een andere prijs getoond.
4. **Er is geen losse verkoop geweest.** Nul.
5. **Er is nul kantoorgesprek gevoerd.**
6. **De CPU-kosten per document zijn niet gemeten**, terwijl scenario F daarop stukloopt als ze hoog zijn.
7. **Het is onbekend waarom [[Yvonne Heiligers]] Business koos** in plaats van Essential, terwijl dat de enige echte prijsobservatie is die er bestaat.

Punt 7 is met één vraag op te lossen en hij is de goedkoopste data die er te halen valt.

---

## 19. Implementatiecomplexiteit per scenario

Wat er technisch minimaal nodig zou zijn, ná een besluit. Niets hiervan gebeurt nu.

| Scenario | Wat er moet | Raakt | Omvang |
|---|---|---|---|
| A. Eén abonnement | `PLAN_TIERS` terug naar één, prijs-ID's opruimen, bestaande klanten migreren | pricing.ts, pricingpagina, Stripe | **Klein** |
| B. Credits | Creditsaldo op `User`, verbruik per generatie, bijkoopflow, saldo-UI | schema, access.ts, document.service, Stripe | **Groot** |
| C. Losse verkoop repareren | Vervaldatum of teller op `DocumentPurchase`, `allow_promotion_codes` aan, verrekening | schema, access.ts, stripe.service | **Klein tot middel** |
| D. Vier tiers met seats | `Team`-model, uitnodigingen, rollen, per-seat facturering | schema, auth, access.ts, Stripe | **Zeer groot** |
| E. Add-ons | Losse Stripe-producten, entitlements per add-on, juristenproces | schema, access.ts, Stripe, operatie | **Middel technisch, groot operationeel** |
| F. Gratis laag | Gratis niveau in `access.ts`, exportvergrendeling, misbruikbescherming | access.ts, pdf-service, rate limiting | **Middel** |
| G. Hybride | Alles van C, F en de kantoorlicentie | overal | **Zeer groot** |

Twee dingen zijn voor bijna elk scenario nodig en staan nu uit: `allow_promotion_codes` in de checkoutsessie, en attributiekolommen op `User`.

---

## 20. Ontbrekende informatie

| Wat | Waarom het uitmaakt | Hoe het te krijgen is |
|---|---|---|
| Conversie bezoeker naar klant | Bepaalt of prijs of bereik het probleem is | Vercel Analytics naast Stripe, vanaf circa 500 bezoekers p/m |
| Churn | Bepaalt de hele tabel in 12.3 | Meetbaar vanaf circa 20 klanten en drie maanden |
| CPU-tijd per PDF | Bepaalt of scenario F kan | Vercel Observability, per-function CPU |
| Kosten database, Redis, Resend, Sentry | Blokkeert elke winstberekening | Dashboards nakijken |
| Waarom Yvonne Business koos | Enige echte prijsobservatie | Eén vraag per mail |
| BTW-status bij Ligo, ZZP Nederland, DAS, VraagHugo | Vertekent de vergelijkingstabel | Checkout doorlopen tot het betaalscherm |
| Kwaliteit van de ZZP Nederland-generator | Bepaalt of 24,75 p/j een echte of schijnbare concurrent is | Lid worden voor 24,75 en zelf een document maken |
| Nieuwere versie RB-reglement | Bepaalt of art. 15 nog zo luidt | RB bellen of vragen aan een RB-lid |
| NOAB-gedragsregels | Geldt voor het merendeel van de 30 kantoren | NOAB-voorwaarden opvragen |
| Losse verkoop: welk type, welke prijs | Alle zes modellen in sectie 14 | Drie maanden meten na een kleine wijziging |
| Willingness to pay per segment | De hele sectie 13 is hypothese | Klantgesprekken en prijstests |

---

## 21. Verificatierapport

### 21.1 Wat ik niet heb kunnen verifiëren

- **BTW-status** bij Ligo, ZZP Nederland, DAS Documentenshop, VraagHugo en deLex. Geen van die sites vermeldt het op de prijspagina.
- **Rocket Lawyer NL-prijzen**: het FAQ-accordeon opende niet in het browserpaneel. De prijs van circa 39,90 per maand en 19,90 per document komt uit zoekresultaten die naar hun site verwijzen, niet uit de pagina zelf. **De sluitingsdatum van 31 oktober 2026 is wel via twee onafhankelijke zoekpassages bevestigd, maar ik heb de mededeling niet woordelijk op hun site kunnen openen.**
- **deLex ICT Modelcontracten**: prijs komt uit de Justitia-directory, niet van deLex zelf. Hun abonnementspagina laadde de tarieven niet.
- **LawDepot**: pricingpagina gaf geen inhoud terug.
- **JuriBlox-tarieven**: pagina gaf 404. Partnerprogramma wordt genoemd maar zonder prijs.
- **Lawsy-catalogus**: de prijspagina zegt "alle 5" documenttypes, de bedrijvenpagina "meer dan 20". Tegenstrijdig, niet op te lossen zonder account.
- **ZZP Nederland-generator**: "230+ documenten" is hun eigen claim. Kwaliteit, diepgang en of het echt een generator is met vragenlijst, is niet gezien. Dit is een claim van de aanbieder en geen waarneming.
- **RB-reglement**: de versie op rb.nl draagt datum 1 januari 2015. Of dat de geldende versie is, is niet vast te stellen zonder navraag.
- **Vaste kosten** van database, Redis, Resend en Sentry.
- **CPU-tijd per documentgeneratie.**

### 21.2 Feit, afleiding en hypothese, voor de belangrijkste conclusies

| Conclusie | Label |
|---|---|
| Alle abonnees krijgen alle 233 documenten, ongeacht plan | **FEIT**, `access.ts:32` |
| Alleen AI-limieten verschillen tussen de tiers | **FEIT**, `ai.ts` |
| Er is geen Team-, Organization- of Seat-model | **FEIT**, `schema.prisma` |
| Een losse aankoop geeft levenslange onbeperkte generatie | **FEIT**, `DocumentPurchase` plus `access.ts` |
| Een AI-review kost hoogstens 0,0058 euro | **FEIT**, `cost-meter.ts` plus Google-prijslijst |
| Contributiemarge 91 tot 98 procent | **AFLEIDING** uit geverifieerde prijzen en tarieven |
| Prijzen exclusief BTW tonen levert 21 procent meer netto op | **AFLEIDING**, rekenkundig zeker |
| Exclusief BTW mag alleen bij uitsluitend zakelijke klanten | **FEIT**, meerdere bronnen over de prijsaanduidingsregels |
| ZZP Nederland is met 24,75 p/j het prijsanker voor ZZP | **FEIT** over de prijs, **HYPOTHESE** over de vergelijkbaarheid |
| Kantoren betalen meer voor dezelfde catalogus | **FEIT** bij Flexmodellen, deLex en VraagHugo |
| Boekhouders hebben behoefte aan juridische documenten voor klanten | **HYPOTHESE**, nul gesprekken |
| Hogere ARPU is nodig omdat de churn-treadmill anders te zwaar wordt | **AFLEIDING**, afhankelijk van onbekende churn |
| Vertrouwen en niet prijs is de zwakste as | **AFLEIDING** uit `icp.md` plus de positionering van vijf concurrenten |
| Hobby knelt eerder op CPU dan op kosten | **AFLEIDING**, met een ongemeten variabele |

---

## 22. Beslisdocument

### A. Wat weten we nu zeker

Alle abonnees krijgen alle 233 documenten. Alleen AI-limieten verschillen tussen tiers. Er zijn geen seats, geen kortingscodes, geen grandfathering en geen documentlimiet voor betalende klanten. Een losse aankoop van 14,99 geeft levenslange onbeperkte generatie. Prijzen zijn inclusief BTW terwijl de markt exclusief prijst. Een AI-review kost hoogstens 0,0058 euro en de contributiemarge is 91 tot 98 procent. Rocket Lawyer Nederland stopt op 31 oktober 2026. De Nederlandse markt voor onbeperkte juridische documenten loopt van 24,75 per jaar tot 948 per jaar.

### B. Wat denken we waarschijnlijk

Dat de hoogste betalingsbereidheid bij werkgevers en kantoren zit en niet bij ZZP'ers. Dat vertrouwen en niet prijs de bindende beperking is. Dat jaarbetaling voordeliger is dan maandbetaling zolang de gemiddelde klantlevensduur onder 9,7 maanden ligt. Dat een gratis laag het distributieprobleem meer helpt dan welke prijswijziging ook. Dat een kantoorlicentie beroepsrechtelijk schoner is dan elke vorm van vergoeding.

### C. Wat weten we nog niet

Conversie, churn, prijselasticiteit, CPU-kosten per document, drie van de vijf vaste kostenposten, de werkelijke kwaliteit van het goedkoopste alternatief, wat boekhouders werkelijk nodig hebben, en waarom de enige klant die er is voor Business koos.

### D. Aantoonbare pricing leaks

De twaalf uit sectie 10, waarvan drie met de grootste omvang: BTW inclusief in plaats van exclusief (17,4 procent van alle omzet), levenslange documenttoegang, en tiers die alleen op AI differentiëren.

### E. Pricingclaims die niet kloppen met de code

Zes: "Volledige RI&E Engine", "DPA & Verwerkersovereenkomsten" en "Algemene Voorwaarden (B2B/B2C)" staan onder Business maar zitten in Essential. "Quarterly Compliance Check" en "Multi-user Management" bestaan niet in de code. "NIS2 & NEN 7510 Modules" klopt half: `nis2` bestaat maar zit ook in Essential, en NEN 7510 komt in de catalogus niet voor. Daarnaast zijn "Priority Legal Support" en "Dedicated Success Manager" niet waar te maken zonder personeel.

### F. Concurrenten die serieus meetellen

De achttien uit sectie 5. De vier die het meest veranderen aan een beslissing: ZZP Nederland (het prijsanker), VraagHugo (het model dat het dichtst ligt bij wat [[ZekerWet]] zou kunnen worden), DAS (vertrouwen draagt een hogere prijs dan catalogusomvang), en de gratis AI-chatbots (de bodem van de markt).

### G. Pricingstructuren die in deze markt daadwerkelijk voorkomen

Volumegrendel per maand (Legalflow, Lawsy). Credits naar documentcomplexiteit (VraagHugo). Per gebruiker (deLex, Lawsy, Genie AI). Vakpakket per jaar (Flexmodellen). Jaarabonnement zonder maandoptie (Ligo, DAS, ContractenFabriek, ZZP Nederland). Gratis met vergrendelde export (Genie AI). Eerste document gratis (Ligo, Lawsy). Adviseurslicentie (VraagHugo Pro). Opslag op eigen factuur (Firm24). Lidmaatschapsvoordeel (ZZP Nederland). Losse verkoop met update-venster (Legalflow, Lawsy). Wat niet voorkomt: differentiëren op catalogus, en kunstmatige features om een tier te vullen.

### H. Wat er bij echte klanten en kantoren opgehaald moet worden

Bij [[Yvonne Heiligers]]: waarom Business en niet Essential, wat ze verwachtte te krijgen, en waarom ze niet is teruggekomen. Bij drie boekhoudkantoren: de elf vragen uit [[masterplan-commercieel-2026-09-16]], met als toevoeging of zij zelf een licentie zouden kopen om voor klanten te werken en wat dat mag kosten. Bij bezoekers: waar ze vandaan komen.

### I. Beslissingen die nu genomen kunnen worden

Deze drie hebben genoeg onderbouwing en hangen niet af van ontbrekende data:

1. **De zes onjuiste claims in `PLAN_TIERS` corrigeren.** Er is geen scenario denkbaar waarin het goed is dat de pagina belooft wat de code niet doet.
2. **De AI-limieten verhogen.** Ze beschermen een kostenpost van minder dan een cent en ze rantsoeneren de enige functie die [[ZekerWet]] onderscheidt.
3. **Jaarbetaling zichtbaarder maken.** De meerderheid van de Nederlandse markt verkoopt per jaar en de pricingpagina start op maandelijks.

### J. Beslissingen die moeten wachten

Het prijsniveau (wacht op conversie en elasticiteit). De keuze tussen de zeven scenario's (wacht op de zeven ontbrekende gegevens uit 18.1). De BTW-omslag (wacht op het besluit over de 55 particuliere documenten, want het is één beslissing). Het losse-verkoopmodel (wacht op één verkoop). Het partneraanbod (wacht op gesprek drie). Enterprise (wacht op een `Team`-model of gaat uit de verkoop).

### K. Experimenten die later geschikt zijn

Alle vier vereisen meer verkeer dan er nu is, en staan hier zodat ze klaarliggen.

| Experiment | Wat het meet | Voorwaarde |
|---|---|---|
| Prijspagina A/B op 24,99 tegenover 39,99 | Elasticiteit | Circa 500 bezoekers p/m |
| Proefperiode met en zonder betaalmiddel | Conversiekosten van de creditcardmuur | Circa 200 bezoekers p/m |
| Jaar als standaard op de toggle | Verschuiving naar jaarbetaling | Direct meetbaar bij elke verkoop |
| Eén documentpagina gratis maken | Of een gratis laag de trechter vult | Indexering eerst, meetmoment 28 september |

### L. Minimale technische implementatie ná een besluit

Ongeacht welk scenario wint, dit is het kleinste gemene veelvoud: teksten in `PLAN_TIERS` kloppend maken, getallen in `AI_LIMITS` en `AI_TOKEN_BUDGETS` verhogen, `allow_promotion_codes` aanzetten in de checkoutsessie, en de vier attributiekolommen op `User`. Dat is alles. Alle andere bouwlast hangt aan een scenario dat nog niet gekozen is.

---

## Bronnen

Alle geraadpleegd op 16 september 2026.

Ligo: ligo.nl/prijzen, ligo.nl/contracten. Legalflow: legalloyd.com/pakket. Lawsy: lawsy.nl/prijzen, lawsy.nl/voor-bedrijven, lawsy.nl/kosten-vergelijkingen. Rocket Lawyer NL: rocketlawyer.com/nl/nl, /hulp. VraagHugo: vraaghugo.nl, vraaghugo.nl/prijzen. DAS Documentenshop: shop.das.nl. De ContractenFabriek: contractenfabriek.nl/startende-ondernemer-zzp-er. ZZP Nederland: zzp-nederland.nl/aansluiten en de pagina over juridische documenten. Judex: judex.nl/documenten. Flexmodellen: flexmodellen.nl. JuriBlox: juriblox.nl. Justitia-overzicht van modelcontractleveranciers: justitia.nl/juridische-modellen. MKB Juristen: mkbjuristen.nl/contracten. Firm24: firm24.com/professional. Genie AI: genieai.co/pricing. VGBA: nba.nl/wet--en-regelgeving/hra/598/599. NOB: nob.net, Reglement Beroepsuitoefening, versie 12 mei 2025. RB: rb.nl, Reglement Beroepsuitoefening, versie 001 van 01-01-2015. Gemini-prijzen: ai.google.dev/gemini-api/docs/pricing. Vercel Hobby: vercel.com/docs/plans/hobby. Stripe NL-tarieven: stripe.com/resources/more/what-are-transaction-costs-for-dutch-businesses. Prijsaanduidingsregels: ACM, WebwinkelKeur, ICTRecht en Thuiswinkel over inclusief en exclusief BTW tonen.

Gerelateerd: [[ZekerWet]], [[masterplan-commercieel-2026-09-16]], [[ZekerWet-concurrenten]], [[kanaal-boekhouders]], [[klant-yvonne-heiligers]], [[icp]], [[offer]], [[business]], [[strategy]]
