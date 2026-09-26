---
type: notes
date: 2026-09-24
status: gecommit, deploy loopt
tags: [ai-review, guards, kwaliteit]
project: ZekerWet
---

Twee guard-fouten en één UX-punt, gevonden via de productie-smoke van [[Ali Can]] op review `cmufbknsh000104l3unz4pale` met het testdocument uit [[testdocument-privacyverklaring-begeleiding-2026-09-24]]. Het model vond alle drie de ingebouwde gebreken en verzon niets; de guards zetten er twee van terug. Alles staat in de werkboom, niets gecommit. Release-achtergrond in [[ai-review-v2-releasechecklist-2026-09-23]].

## Wat de controle van de opgeslagen review opleverde

`version` v2, model `gemini-3.5-flash`, promptversie v2, 2.468 prompt- en 2.447 uitvoertokens, kosten 25.725 micros oftewel **2,57 eurocent**. Het gat tussen totaal en prompt plus uitvoer is nul, dus deze call had geen denktokens buiten `candidates`. `ReviewInput.sha256` is gelijk aan `Review.inputSha256` én aan de sha256 die ik zelf over de opgeslagen tekst berekende; `expiresAt` staat op 30 dagen. De tellers van het adminaccount gingen van 11 naar 12 reviews en van 26.698 naar 31.613 tokens, precies het werkelijke verbruik van 4.915 na een reservering van 17.667. Daarmee is de onvoorwaardelijke verrekening uit de twaalfde sessie op productie bewezen.

## Oorzaak a: een citaat met een ellips is niet terug te vinden

Beslissend bewijs uit dezelfde rij: **elk** citaat met `(...)` kwam terug als `verified: false` zonder offsets, **elk** aaneengesloten citaat als `verified: true` mét offsets. Dat trof f1 (grondslag, ernst hoog) en de checklistitems identiteit, doelen en rechten.

`findPassage` heeft nu een derde tier. Een citaat met een weglatingsteken (`(...)`, `(…)`, `[...]`, kale `...` of `…`) wordt daarop gesplitst; elk deel moet apart worden teruggevonden, in de volgorde waarin het model ze schreef, elk ná het vorige en binnen 1.200 genormaliseerde tekens ervan. Die afstandsgrens houdt het eerlijk: twee fragmenten uit tegenovergestelde hoeken van een contract zijn geen passage, hoe waar elk van beide ook is.

Belangrijk gevolg dat apart is dichtgezet: het teruggegeven bereik loopt van het eerste tot het laatste deel en **bevat dus tekst die het model niet citeerde**. Een vervangende clausule daar doorheen schrijven zou die tussenliggende tekst stil overschrijven. `Evidence` heeft daarom een vlag `partial`, en de guard weigert `vervangendeTekst` op zo'n bereik: goed genoeg om aan te wijzen, nooit goed genoeg om te herschrijven.

De systeeminstructie vraagt nu om één aaneengesloten passage en verbiedt weglatingstekens uitdrukkelijk, met de reden erbij.

## Oorzaak b: een afwezigheidsbevinding heeft geen passage

f3 "Bewaartermijnen ontbreken" had helemaal geen `evidence`, kreeg tóch de melding dat een passage niet was teruggevonden, en eindigde op `niet_vast_te_stellen`. Het checklistitem over hetzelfde wetsartikel stond ondertussen gewoon op `afwezig`. Twee regels voor dezelfde soort uitspraak, in één rapport.

De guard herkent een afwezigheidsclaim nu aan zijn eigen tekst en beoordeelt hem op de vraag die ertoe doet. Vastgesteld als het document heel is gelezen (`completeness === 'complete'`) én de eigen woorden van de bepaling nergens anders opduiken; een citaat dat niet is teruggevonden blokkeert nog steeds. Lukt dat niet, dan gaan bevinding en item samen naar niet_vast_te_stellen en onduidelijk.

## De derde fout: twee stemmen over één onderwerp

Dit stond niet in de opdracht en kwam uit de controle. f2 zei "Recht om een klacht in te dienen ontbreekt", vastgesteld en geverifieerd. Checklistitem 7 over hetzelfde artikel zei `onduidelijk`. De klant leest in het ene blok een hard oordeel en in het andere twijfel, over dezelfde bepaling.

Regel 7 in de guard: een bevinding en een checklistitem met hetzelfde wetsartikel spreken met één stem. Het wetsartikel is de sleutel (`Artikel 13 lid 2 sub d AVG` stond letterlijk bij allebei). De bevinding beslist, want die is door de afwezigheidstoets gegaan. Bij een documenttype-mismatch blijft regel 5 voorgaan.

**De oorzaak van die twijfel was niet wat we dachten.** In het document komt "klacht" nul keer voor en "autoriteit" nul keer; "toezichthouder" één keer. Het veto kwam van **"persoonsgegevens"**, het langste woord uit het itemlabel, dat vijf keer in een privacyverklaring staat. Zo kan in dit documenttype per definitie nooit iets afwezig zijn. `keywordsOf` negeert daarom woorden die ambient zijn voor het hele documenttype, met een korte lijst per type als fase-1-versie van de synoniemenlijsten die voor fase 2 stonden gepland.

## Tegentest

Verplicht gesteld door [[Ali Can]] en de belangrijkste van de twee. Een variant van het testdocument waarin in sectie 8 wél staat "U heeft het recht een klacht in te dienen bij de Autoriteit Persoonsgegevens", met dezelfde modeluitvoer die beweert dat het ontbreekt. Uitkomst: f2 gaat naar `niet_vast_te_stellen` en het checklistitem naar `onduidelijk`, terwijl f1 en f3 vastgesteld blijven. Een verkeerde beschuldiging over een correct document is erger dan de te voorzichtige weergave die dit vervangt, en die uitkomst ligt nu in een test vast.

## Regressietest

`src/lib/review/guard-regression.test.ts`, met de modeluitvoer van deze review als fixture (de guard-downgrades teruggedraaid, zodat de test de guards meet en niets anders) plus de geanalyseerde tekst. Tien tests, allemaal groen: drie vastgesteld en nul niet_vast_te_stellen, het elliptische citaat van f1 geverifieerd en als `partial` gemarkeerd, f3 vastgesteld zonder enig citaat, identiteit, doelen en rechten aanwezig, klachtrecht afwezig met gelijk wetsartikel op bevinding en item, bewaartermijn afwezig, en `lowConfidence` uit. Plus de drie tegentests.

## Doorzoekbare keuzelijst

`src/components/review/DocumentTypePicker.tsx` vervangt de native keuzelijst met circa 230 opties op `/dashboard/review`. Zoekveld dat tijdens het typen filtert (accentloos, dus "prive" vindt "privé", en eerst de labels die met de zoekterm beginnen), de tien meest gebruikte types bovenaan onder een kopje, daaronder de rest alfabetisch op label. Leesbare kleuren in plaats van grijs op zwart, sluit op Escape of een klik erbuiten. Bewust een eenvoudige listbox en geen combobox-afhankelijkheid. Automatisch herkennen blijft fase 2.

Vier tests bewaken de tien ids, want een hernoemde id zou geruisloos uit de lijst vallen.

## Poort

`tsc` schoon, lint zonder nieuwe meldingen, `next build` exit 0, **289 tests groen** en 3 overgeslagen (was 275).


## Gecommit en gepusht

Commit `1fe21c6`, dertien paden per pad gestaged. Gecontroleerd vóór de commit: nul bestanden uit `marketing/`, `.smoke/`, `.env` of de probes. De twee tijdelijke probes zijn op verzoek van [[Ali Can]] niet weggegooid maar verplaatst naar `.probes/`, dat nu in `.gitignore` staat met de reden erbij; hij heeft ze op 26 september nodig voor de kwaliteitstest van `gemini-3.8-flash`.

Deploy `dpl_CypFKhu1codeJrQkXRFZ3Tya35Lz` bouwt. Zoals bij de vorige twee deploys loopt de Vercel-API achter: de deploy-url antwoordt al, maar `zekerwet.nl` en `www.zekerwet.nl` hangen op dit moment nog aan `dpl_Ct6k72Yi` (commit `1ffce19`). Nul runtime-errors in de laatste drie kwartier.


## Live hertest na `1fe21c6`, en twee vondsten daaruit

[[Ali Can]] draaide twee reviews op de nieuwe code. Beide rijen nagelopen, beide kloppen.

`cmufe5zop000104k06bfls9qm`, het originele testdocument: **3 vastgesteld, 0 niet_vast_te_stellen**, `lowConfidence` uit, checklist consistent. Kwam uit de cache: nul tokens, nul kosten, `cachedHit` true in `AiUsageLog`. `cmufe7b9s000104kx1ffoghwx`, de variant mét klachtrecht en een verse modelcall: **2 vastgesteld** zonder klachtrechtclaim, 2.574 prompt- en 2.074 uitvoertokens, 6.612 totaal, 4,02 eurocent.

Die laatste rij levert en passant het bewijs voor `billedOutputTokens()`: het gat tussen totaal en prompt plus candidates is **1.964 denktokens**. Zonder die correctie was de review op 2.074 uitvoertokens geprijsd in plaats van 4.038, dus bijna de helft te laag.

Tellers: van 12 naar 13 reviews en van 31.613 naar 38.225 tokens, precies het verbruik van de verse call. De gecachte review kostte dus geen quotum, wat klopt met de opzet maar wel betekent dat `aiUsageCount` telt wat het model heeft gedaan en niet wat de klant heeft opgevraagd.

### meta.cached loog bij het heropenen

De vlag stond goed waar hij werd geschreven en ging verloren waar hij werd gelezen: `toReviewResult` in `record.ts` zette `cached: false` hard, want de tabel `Review` heeft er geen kolom voor. Hij komt nu uit de `AiUsageLog`-rij waarmee de review is weggeschreven, opgehaald in de route. Geen migratie nodig.

Ernaast stond `unverifiedRatio: 0`, net zo hard gezet. Een review vol onvindbare passages zag er na heropenen dus vlekkeloos uit. Die wordt nu herberekend uit de opgeslagen bevindingen, met dezelfde formule als de guard.

### De cache overleefde de prompt

De systeeminstructie veranderde op 24 september (geen ellipsen) terwijl `PROMPT_VERSION` op `v2` bleef staan, dus antwoorden van de oude instructie werden onder de nieuwe geserveerd. Dat is precies wat er bij `cmufe5zop` gebeurde.

`PROMPT_VERSION` staat nu op `v2.1`, maar de echte fix zit in de sleutel: die draagt een vingerafdruk van de systeeminstructie zelf, dus een promptwijziging maakt voortaan zijn eigen cache ongeldig zonder dat iemand iets hoeft te onthouden.

**Bewijs dat oude entries onbereikbaar zijn.** De opgeslagen `inputHash` van review `cmufbknsh` (`28e8a6df643c14dd05854361…`) reproduceert exact uit de oude formule `v2:privacy:<tekst>`, wat bevestigt dat ik de sleutel goed lees. Dezelfde tekst geeft met de nieuwe formule `fac5ab2fdd59fc9d…`, een andere sleutel. Daarbovenop weigert `isCachedOutput` elke payload waarvan `promptVersion` niet meer klopt. Twee onafhankelijke sloten.

### Poort en commit

`tsc` schoon, lint zonder nieuwe meldingen, `next build` exit 0, **302 tests groen** (was 289), 1 overgeslagen. Dertien nieuwe tests in `cache.test.ts` en `record.test.ts`. Commit `19aa9b2`, acht paden, gepusht.
