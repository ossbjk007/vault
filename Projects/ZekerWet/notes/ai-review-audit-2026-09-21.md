---
type: audit
date: 2026-09-21
status: wacht op besluit
tags: [ai-review, kwaliteit, architectuur, productie]
project: ZekerWet
---

Read-only audit van de AI Document Review van [[ZekerWet]], aangevraagd door [[Ali Can]] na de bevindingen bij [[Yvonne Heiligers]] ([[klant-yvonne-heiligers]]). Niets gewijzigd, niets gecommit. Repo: `Bureaublad/Project Compliance & automatic document generator/zekerwet`, HEAD `1915b06`. Regelnummers verwijzen naar die stand.

## 1. Oordeel in vijf zinnen

De pijplijn is technisch netjes gebouwd rond kosten, misbruik en beveiliging (idempotency, rate limits, tokenbudget, cache, injectie-afweer, owner-scoping) en daar is niets mis mee. De juridische kern is één prompt van 35 regels naar `gemini-flash-lite-latest`, zonder rubric, zonder outputvalidatie, zonder bewijsketen en zonder besef of het document compleet is. De limiet van 15.000 tekens is geen modelgrens maar een keuze uit `src/config/ai.ts:33` ("covers the 99th-percentile legal doc"); het model dat de alias nu oplevert accepteert ruim honderd keer zoveel. De klant knipt daardoor zelf, het model beoordeelt elk stuk als geheel, en de UI zet de gevolgen in een rode box "Ontbrekende clausules" naast een groen schild "Laag risico". Dat is geen promptprobleem maar een architectuurprobleem: er ontbreekt een laag tussen model-output en klant die controleert of een claim door de aangeleverde tekst gedragen wordt.

## 2. Hoe de flow nu loopt

| Stap | Waar | Wat er gebeurt |
|---|---|---|
| 1 | `src/components/review/UploadDropzone.tsx`, `src/app/api/ai/extract/route.ts`, `src/lib/extract-text.ts` | PDF/DOCX/TXT tot 4 MB, tekst geëxtraheerd, **stil afgekapt op 15.000 tekens** (`extract-text.ts:70-72`), `truncated`-vlag terug naar client |
| 2 | `src/app/dashboard/review/page.tsx:401-434` | Textarea, teller "x / 15.000 tekens", knop uitgeschakeld boven de limiet met de tekst "Kort de tekst in om verder te gaan" (regel 432). Documenttype: `<select>` met 233+ opties, **standaard `nda`** (regel 58) |
| 3 | `src/validators/review.schema.ts:9` | Zod weigert > 15.000 tekens server-side |
| 4 | `src/app/api/ai/review/route.ts` | Clerk-auth, Idempotency-Key verplicht, globale spend-cap, 5 reviews/min per gebruiker |
| 5 | `src/services/ai-review.service.ts:117-208` | Cache-lookup op sha256(promptversie, type, tekst); daarna quotum (`AI_LIMITS`) en tokenbudget atomair gereserveerd |
| 6 | `src/lib/gemini.ts:54-143` | Sanitize (codeblokken, role-tags, "ignore"-regels), prompt, `gemini-flash-lite-latest`, temp 0,1, **max 2048 uitvoertokens**, `responseMimeType: application/json` maar **geen `responseSchema`**, `JSON.parse` zonder verdere validatie, resultaat getypt als `unknown` |
| 7 | `ai-review.service.ts:210-217` | `Promise.race` met 25 s timeout; de Gemini-call wordt niet afgebroken, alleen genegeerd |
| 8 | `ai-review.service.ts:230-247` | Tokens verrekend, `AiUsageLog` geschreven, Redis-cache 7 dagen, abuse-signalen (waaronder "output > 90 % van de cap") |
| 9 | `page.tsx:195-202` | Client cast `data as AnalysisResult`, toont rapport, en POST naar `/api/reviews` |
| 10 | `src/app/api/reviews/route.ts:52-63`, `src/validators/review-save.schema.ts` | Review opgeslagen: titel, type, score, findings, missingArticles. **Geen invoertekst, geen hash, geen promptversie, geen model, geen tokens** |
| 11 | `src/components/review/ComplianceReport.tsx` | Score groot, `>= 7` is "Laag risico" met groen schild (regel 49-53, 226-230); `missingArticles` in rode box met kruisjes (regel 251-267); "Pas suggestie toe" vervangt de excerpt-passage door `suggestion` (page.tsx:270-278) |

Wat goed is en blijft: auth en owner-scoping op alle routes, idempotency met refund bij falen, atomaire quotumreservering, cost meter met dagcap, injectie-afweer met delimiters, `passage-match.ts` (conservatief, getest, 10 tests), en de disclaimer onder het rapport.

## 3. Quality gap analysis

> [!danger] G1. Fragment wordt als volledig document beoordeeld
> **Huidig gedrag.** Boven 15.000 tekens blokkeert de UI en zegt "Kort de tekst in". De klant plakt dus deel 1, dan deel 2. Elk deel gaat als zelfstandig document naar het model met de opdracht "analyseer het volgende document van het type X" en "missingArticles: artikelen die essentieel zijn voor dit type document maar ontbreken".
> **Probleem.** Bewijs in de `Review`-tabel van 14 september: review 15:26 meldt "Aansprakelijkheid" ontbrekend, review 15:30 (vervolg van dezelfde AV) keurt "Artikel 15 – Aansprakelijkheid" goed. 15:26 keurt het herroepingsrecht goed, 15:30 meldt het ontbrekend. Privacyverklaring: 15:31 mist "Rechten van betrokkenen" en "Datalekken", 15:37 en 15:43 vinden artikel 18 en 19. Drie reviews zeggen letterlijk "het document breekt abrupt af" en krijgen toch een 8.
> **Oorzaak.** `MAX_REVIEW_CHARS = 15_000` (`config/ai.ts:33`) is een productkeuze, geen modelgrens. De prompt (`gemini.ts:87-123`) heeft geen begrip "fragment". Er is geen server-side stap die de claims "ontbreekt" toetst aan de vraag of het hele document gezien is.
> **Risico voor klant.** Ze past een document aan op basis van een gebrek dat niet bestaat, of negeert een echt gebrek omdat het rapport tegenstrijdig is. Voor een premium juridische review is dit verlies van vertrouwen bij de eerste echte klant.
> **Gewenst gedrag.** Regel A tot en met D: het hele document in één analyse; als dat niet kan, geen definitieve "ontbreekt"-claims en een zichtbare melding.
> **Technische oplossing.** Limiet naar circa 200.000 tekens per enkele call (sectie 4.1), een `coverage`-object in het resultaat, en een server-side poort die `missingArticles` leegmaakt en `completeness: 'partial'` zet zodra `coverage < 1`.
> **Test die dit bewijst.** Fixture "AV, 42.000 tekens" volledig ingevoerd: verwachte `missingArticles` bevat niet "aansprakelijkheid" (artikel 15 aanwezig). Dezelfde fixture in twee helften door de V1-code: minstens één contradictie. Poort-unit-test zonder Gemini: `coverage 0.6` in, `missingArticles []` uit en `completeness 'partial'`.

**G2. "Ontbreekt" heeft geen grond.** `missingArticles` is vrije tekst uit het model, zonder checklist per documenttype, zonder verwijzing naar een wetsartikel en zonder onderscheid tussen "wettelijk verplicht" en "gebruikelijk". Bij een intakeformulier onder type `personeelslening` produceerde het model een lijst "hoofdsom, rentepercentage, aflossingsschema" als ontbrekend (review 15:46). Oorzaak: prompt regel 106 vraagt om "essentieel voor dit type document" en laat het model zelf bepalen wat dat is; de code kent geen verplichte bepalingen per type. Risico: schijnzekerheid en fictieve gebreken (regel E en I). Gewenst: elke "ontbreekt"-claim draagt een `basis` (wetsartikel of "gebruikelijk in de praktijk") en een `zekerheid`. Oplossing: per documenttype een compacte checklist in code (`src/config/review-checklists.ts`, te beginnen met de tien types die klanten echt aanleveren: AV B2C, AV B2B, privacyverklaring, verwerkersovereenkomst, verwerkingsregister, NDA, opdrachtovereenkomst, arbeidsovereenkomst, huurcontract bedrijfsruimte, SLA), en het model laten beantwoorden "aanwezig / afwezig / niet vast te stellen" per checklistitem, met excerpt bij "aanwezig". Test: fixture-AV met artikel "Toepasselijk recht" verwijderd geeft precies dat item als afwezig en niets anders.

**G3. Een technische limiet wordt als juridisch gebrek gepresenteerd.** Drie plekken. `page.tsx:432` zegt "Kort de tekst in", wat de klant uitnodigt tot precies het knippen dat G1 veroorzaakt. `extract-text.ts:72` kapt stil af en de `truncatedNote` verdwijnt bij de eerste toetsaanslag in de textarea (`page.tsx:404`). Bij plakken is er nooit een signaal. Gewenst (regel C en D): een afgekapt of gesplitst document geeft een rapport met status "gedeeltelijk beoordeeld" en zonder ontbrekende-clausules-blok. Test: component-test op `ComplianceReport` met `completeness: 'partial'` toont geen rode box en wel een banner.

**G4. De score is cosmetisch.** Prompt regel 99: "een getal tussen 1 en 10 voor de algehele kwaliteit/compliance", geen criteria. Elf reviews van Yvonne: acht keer een 8, drie keer een 7, één keer een 3 (type-mismatch). `ComplianceReport.tsx:50` maakt van `>= 7` "Laag risico" met groen schild, ook bij "breekt abrupt af". Risico: regel G. Gewenst: de score is een deterministische functie van de bevindingen, in code berekend, of hij verdwijnt. Oplossing: server berekent `score` uit (aantal danger × gewicht, aantal warning × gewicht, checklist-dekking), en bij `completeness !== 'complete'` toont de UI geen score maar "Gedeeltelijk beoordeeld". Test: unit-test van `computeScore` op vaste inputs; snapshot dat dezelfde findings altijd dezelfde score geven.

**G5. Documenttype: standaard `nda`, geen detectie.** `page.tsx:58` zet `docType` op `'nda'`. Zeven van Yvonne's elf reviews staan op `nda` terwijl ze AV, privacyverklaringen en intakeformulieren invoerde; ze heeft de select nooit aangeraakt. De mismatch werd door het model in twee van de negen foute gevallen gemeld. Het type zit in de cachesleutel (`cache.ts:14-18`), in `AiUsageLog.documentType` en in `Review.documentType`, dus de fout wordt overal vastgelegd. Gewenst (regel H): detectie vóór de review, expliciete melding bij mismatch, keuze bij de klant. Oplossing: goedkope classificatie-call (flash-lite, alleen eerste 4.000 tekens, output `{ detectedType, confidence, top3 }`) vóór de review; UI toont "Dit lijkt een privacyverklaring, u koos NDA. Reviewen als privacyverklaring?" Standaardwaarde van de select wordt "Automatisch herkennen". Test: fixture-privacyverklaring met gekozen type `nda` geeft `typeMismatch: true` en `detectedType: 'privacy'`.

**G6. De uitvoercap begrenst de grondigheid en straft die.** `GEMINI_MAX_OUTPUT_TOKENS = 2048` (`config/ai.ts:36`). Een bevinding met excerpt en suggestie kost 150 tot 250 tokens, dus na acht tot twaalf bevindingen wordt de JSON afgekapt, faalt `JSON.parse` (`gemini.ts:129`) en ziet de klant "AI-analyse is mislukt". Daarnaast meldt `ai-review.service.ts:37-43` output boven 90 % van de cap als misbruiksignaal aan Sentry. De twee tot vier bevindingen per review bij Yvonne zijn dus deels ontwerp. Gewenst: zoveel bevindingen als het document rechtvaardigt (regel F, in beide richtingen). Oplossing: uitvoercap naar 16.000 tokens voor de reviewpass, structured output met `responseSchema`, saturatie-signaal alleen loggen op de classificatiepass. Test: fixture met twintig bewust ingebouwde gebreken levert minstens vijftien bevindingen zonder parse-fout.

**G7. Geen server-side outputvalidatie, geen bewijsverificatie.** `gemini.ts:129` parst en geeft `unknown` terug; het gaat ongevalideerd de cache in (`ai-review.service.ts:246`) en naar de client, die het cast (`page.tsx:195`). De enige zod-validatie (`review-save.schema.ts`) draait pas als de client het opslaat. Excerpts worden nergens server-side tegen de invoer gecontroleerd; de UI toont dan "Passage niet in tekst" maar de bevinding blijft met status staan. Oplossing: zod-schema op de modeluitvoer in `gemini.ts`, en per bevinding `findPassage(text, excerpt)` server-side; niet-vindbare excerpt degradeert de bevinding naar `zekerheid: 'laag'` en verwijdert de suggestie-knop. Test: gefakete modeluitvoer met een verzonnen excerpt komt terug als `evidence.verified === false`.

**G8. "Pas suggestie toe" kan een clausule vervangen door een adviestekst.** De prompt (regel 104) definieert `suggestion` als "een verbeterde versie van de tekst", maar het model gebruikt het veld ook voor advies: review 15:37 heeft excerpt "Grondslag Toestemming. Werkwijze ..." met suggestion "Zorg ervoor dat de bewijsbaarheid van de verkregen toestemming goed gearchiveerd blijft." `canApply` (`ComplianceReport.tsx:83`) is dan waar, en `handleApply` (`page.tsx:270-278`) splitst die adviesregel in het document op de plek van de clausule. Risico: de klant vernielt met één klik haar eigen tekst. Oplossing: twee velden, `advies` (vrije tekst) en `vervangendeTekst` (alleen letterlijke contracttekst), en "Pas toe" alleen bij het tweede. Test: schema-test dat `vervangendeTekst` niet begint met "Zorg", "Overweeg", "Controleer" (heuristiek) plus een handmatige gouden set.

**G9. Geen bewijsketen in de opslag.** `Review` bewaart geen invoertekst, geen hash, geen promptversie, geen model-id, geen tokens en geen koppeling naar `AiUsageLog`. De reviews van Yvonne zijn niet reproduceerbaar en de vraag "wat zag het model precies" is onbeantwoordbaar. Oplossing: sectie 5.10. Test: na een review bestaat een `ReviewInput`-rij met `sha256` gelijk aan `AiUsageLog.inputHash`.

**G10. Prompt kent geen statustaxonomie.** Alleen `ok / warning / danger`. Geen "niet vast te stellen", geen onderscheid vastgesteld probleem versus aandachtspunt (regel J). Gevolg: een aanname wordt even hard gepresenteerd als een feit. Oplossing: nieuw outputschema, sectie 5.10.

**G11. Timeout, runtime en budget zijn op 15.000 tekens gedimensioneerd.** `GEMINI_TIMEOUT_MS = 25_000` met `Promise.race` zonder abort; er staat geen `maxDuration` op de route (Vercel Hobby zonder Fluid Compute stopt op 10 s, met Fluid op 300 s; welke van de twee actief is moet Ali in het dashboard nakijken). `AI_TOKEN_BUDGETS` Business = 200.000 tokens per maand; een AV van 60.000 tekens kost circa 15.000 invoertokens plus uitvoer, dus zes volledige reviews per maand vóór het budget dicht zit. `estimatedTokens = chars/4 + 2048` (`ai-review.service.ts:119`) klopt dan ook niet meer voor een meerpassenpijplijn. Oplossing: `maxDuration = 60`, AbortController naar Gemini, budget herijken op basis van de nieuwe kosten per review (sectie 6).

**G12. Geen tests op de reviewpijplijn.** Vijftien testbestanden in de repo; alleen `passage-match.test.ts` raakt de review. Geen test op `gemini.ts`, `ai-review.service.ts`, `extract-text.ts`, de routes of `ComplianceReport`. Geen fixtures met juridische documenten; `e2e/` bevat alleen checkout. Zonder gouden set is elke promptwijziging een gok.

**G13. Kleinere punten.** Taalslips van flash-lite ("prüfen", "Hetdocument" in twee bevindingen). `@google/generative-ai` 0.24 is door Google vervangen door `@google/genai`; werkt nog, maar `responseSchema` en nieuwere modellen komen daar eerst. Cache-TTL 7 dagen op `PROMPT_VERSION = 'v1'`: bij V2 verplicht bumpen. Supabase meldt RLS uit op `Review`; de app praat via Prisma en er staat geen supabase-js in `src/`, dus geen directe blootstelling, wel aanzetten.

## 4. Antwoorden op de zes onderzoeksvragen

**4.1 Past het volledige document in één call?** Ja, ruim. `gemini-flash-lite-latest` wijst nu naar Gemini 2.5 Flash-Lite met een contextvenster van ruim een miljoen invoertokens en tot 65.000 uitvoertokens (modelspecificatie van Google; controleer het exacte aliasdoel in AI Studio). 15.000 tekens is circa 4.000 tokens. Een AV van 60.000 tekens is circa 15.000 tokens; een dik contract van 300 pagina's circa 150.000 tokens. Alles past. De echte grenzen zijn kosten (invoer €0,28 per miljoen tokens, `cost-meter.ts:23`), latentie en de Vercel-functieduur. Voorstel: één enkele call tot 200.000 tekens (circa 50.000 tokens, circa 1,5 cent invoer), daarboven sectie-bewuste verwerking. Dat dekt alles wat Yvonne aanleverde met factor vijf marge.

**4.2 Beste architectuur.** Volledige-documentanalyse als hoofdpad, met een aparte structuurpass vooraf en een aparte consistentiepass achteraf. Chunking alleen als fallback boven 200.000 tekens, en dan sectie-bewust (knippen op artikelgrenzen uit de structuurpass, nooit op tekenaantal) met map/reduce waarbij uitsluitend de reduce-stap "ontbreekt" mag zeggen. Reden: één model dat het hele document ziet is goedkoper en betrouwbaarder dan zeven chunks die gefuseerd moeten worden; chunking is een oplossing voor een probleem dat de huidige modelgeneratie niet meer heeft, behalve bij extreem lange input.

**4.3 Hoe voorkomen dat chunk 1 iets ontbrekend noemt dat in chunk 7 staat.** Drie sloten. Eén: het chunk-schema heeft geen veld `missingArticles`; een chunk mag alleen `aanwezig`-claims met excerpt doen. Twee: de reduce-stap krijgt de sectie-index van het hele document plus alle `aanwezig`-claims, en pas daar wordt per checklistitem "afwezig" geconcludeerd. Drie: de server-side poort weigert elke "afwezig"-claim zolang `coverage < 1` of een chunk is mislukt. Slot drie is een gewone TypeScript-functie zonder model en is dus deterministisch testbaar.

**4.4 Whole-document-conclusies alleen na volledige analyse.** Het resultaat krijgt `completeness: 'complete' | 'partial' | 'unknown'` met `coverage` (geanalyseerde tekens / totaal tekens, aantal secties gezien / gevonden). Score, `missingArticles` en het risicolabel zijn alleen toegestaan bij `complete`; bij `partial` toont de UI een banner en alleen tekstgebonden bevindingen. Bron van `partial`: extract-truncatie, mislukte chunk, timeout in een pass, of een structuurpass die een document detecteert dat midden in een zin eindigt zonder slotformule.

**4.5 Citations en bewijs opslaan.** Per bevinding een `evidence`-object: `{ excerpt, start, end, verified }` waarbij `start/end` server-side door `findPassage` op de opgeslagen invoertekst zijn bepaald en `verified` alleen waar is bij een unieke treffer. Per "afwezig"-claim: `{ checklistItem, basis, zoekstrategie: 'model' | 'keyword', secties gecontroleerd }`. Per review: `inputSha256`, `inputChars`, `promptVersion`, `model`, `usage` en een `ReviewInput`-rij met de volledige geanalyseerde tekst (versleuteld of met korte bewaartermijn; dit is klantdata onder de AVG, dus opt-in of 30 dagen). Zonder de invoertekst is een bevinding achteraf niet herleidbaar.

**4.6 Kwaliteit automatisch testen.** Drie lagen. Laag 1, deterministisch en zonder Gemini: unit-tests op de poorten (completeness, evidence-verificatie, score-berekening, schema-validatie, mismatch-logica) met gefakete modeluitvoer. Laag 2, gouden set: twintig fixtures uit de eigen 233 sjablonen gerenderd met voorbeeldantwoorden (die zijn er al via `pdf-service.ts`), plus mutaties: artikel X verwijderd (verwacht: precies X afwezig), document in twee helften (verwacht: nul contradicties, `partial`), verkeerd type gekozen (verwacht: mismatch), document zonder gebreken (verwacht: nul danger, regel F). Draait nachtelijks tegen echte Gemini met een precisie- en recall-meting per fixture, gelogd in `AiUsageLog` onder een test-user. Laag 3, regressie op productie: elke review slaat `promptVersion` op; bij een prompt-bump draai je de gouden set vóór de deploy. Yvonne's echte documenten horen niet in de fixtures zonder haar toestemming.

## 5. AI Review V2, production-grade architectuur

> [!info] Kern
> Vier passes in plaats van één prompt, met tussen elke pass een deterministische poort in TypeScript. Het model mag observeren, de code beslist wat de klant te zien krijgt.

**5.1 Input pipeline.** Upload of plak tot 200.000 tekens (`MAX_REVIEW_CHARS` omhoog, zod mee). Extractie geeft `fullLength`, `truncated`, `pages`; truncatie boven 200.000 is een harde fout met uitleg, geen stille afkap. Normalisatie behoudt regeleinden zodat artikelkoppen herkenbaar blijven. Sanitize blijft, maar de `slice` verdwijnt uit `sanitizeDocumentText`.

**5.2 Structuurpass (flash-lite, goedkoop).** Input: eerste 6.000 tekens plus een lijst van alle regels die op een kop lijken (regex op "Artikel", cijfers, hoofdletters). Output: `{ detectedType, confidence, alternatives[3], sections: [{ heading, startOffset }], endsAbruptly: boolean, language }`. `startOffset` wordt server-side geverifieerd met `findPassage`; niet-vindbare koppen vervallen.

**5.3 Completeness detection.** Deterministisch: `coverage = analysedChars / fullLength`; `endsAbruptly` uit 5.2; laatste sectie zonder slotzin of handtekeningblok bij contracten. Resultaat `completeness`. Bij `partial` slaat de pijplijn 5.7 en 5.9 over en markeert dat.

**5.4 Type detection en mismatch.** `detectedType` versus gekozen type. Bij verschil met `confidence >= 0.7`: UI-vraag vóór de dure pass, standaard het gedetecteerde type. Select-standaardwaarde "Automatisch herkennen". Type-mismatch komt ook in het rapport als eerste regel, in de taxonomie "vastgesteld".

**5.5 Full-document review pass (flash, niet lite, voor de juridische kern).** Input: hele tekst, checklist van het type, sectie-index. Output via `responseSchema`: per checklistitem `{ item, status: 'aanwezig' | 'afwezig' | 'onduidelijk', excerpt?, basis }`; per bevinding `{ sectie, taxonomie: 'vastgesteld' | 'aandachtspunt' | 'niet_vast_te_stellen' | 'positief', ernst, uitleg, wetsbasis, excerpt, advies?, vervangendeTekst? }`. Geen minimum, geen maximum; uitvoercap 16.000 tokens. Temperatuur 0,1 blijft.

**5.6 Chunking, alleen boven 200.000 tekens.** Knip op sectiegrenzen uit 5.2, overlap één sectie. Chunk-schema zonder "afwezig". Reduce-pass krijgt alle `aanwezig`-claims plus de sectie-index en beslist per checklistitem. Onder 200.000 tekens bestaat deze stap niet.

**5.7 Consistency pass (flash-lite).** Input: de bevindingen van 5.5 zonder documenttekst. Taak: dubbelingen samenvoegen, tegenstrijdigheden markeren (zelfde sectie "aanwezig" en "afwezig"), en elk "afwezig" laten verwijzen naar de checklist. Deterministische nabewerking: een item dat in 5.5 een geverifieerde excerpt heeft kan nooit "afwezig" zijn.

**5.8 Unsupported-claim guard (code, geen model).** Per bevinding: `findPassage` op de invoer; geen unieke treffer betekent `evidence.verified = false`, taxonomie gedegradeerd naar "niet_vast_te_stellen", geen "Pas toe"-knop. Per "afwezig": alleen toegestaan bij `completeness === 'complete'` en bij een keyword-controle (checklist-synoniemen) die ook niets vindt; anders "onduidelijk". Bij meer dan 30 % niet-geverifieerde excerpts wordt de hele review als `lowConfidence` gemarkeerd en gelogd.

**5.9 Scoring.** In code: `score = 10 - Σ(vastgesteld × 2) - Σ(aandachtspunt × 0,5) - Σ(afwezig verplicht × 1,5)`, ondergrens 1, afgerond. Alleen bij `complete`. Naast de score altijd de telling per taxonomie. Risicolabel "Laag risico" alleen bij score ≥ 8 én nul "vastgesteld" én nul "afwezig verplicht". Overweging voor [[Ali Can]]: de score helemaal schrappen en alleen de telling tonen; dat is eerlijker en makkelijker uit te leggen.

**5.10 Output schema (opgeslagen en naar client).**
```
{
  version: 'v2',
  completeness: 'complete' | 'partial',
  coverage: { analysedChars, fullLength, sectionsSeen, sectionsFound },
  documentType: { chosen, detected, confidence, mismatch: boolean },
  checklist: [{ item, status, basis, evidence? }],
  findings: [{ id, sectie, taxonomie, ernst, uitleg, wetsbasis, evidence: { excerpt, start, end, verified }, advies?, vervangendeTekst? }],
  score?: number,            // alleen bij complete
  counts: { vastgesteld, aandachtspunt, nietVastTeStellen, positief },
  meta: { model, promptVersion, inputSha256, inputChars, usage }
}
```
`Review` krijgt de kolommen `version`, `completeness`, `inputSha256`, `inputChars`, `promptVersion`, `model`, `promptTokens`, `completionTokens`, `aiUsageLogId`, en de JSON-velden `checklist`, `coverage`, `documentTypeInfo`. Nieuwe tabel `ReviewInput { reviewId, text, createdAt, expiresAt }`. `findings` en `missingArticles` blijven bestaan voor oude rijen; V1-rijen krijgen `version: 'v1'` in een migratie.

**5.11 Frontend.** Rapport opent met de status: "Volledig beoordeeld (42.000 tekens, 18 secties)" of een amberkleurige banner "Gedeeltelijk beoordeeld: 15.000 van 42.000 tekens. Ontbrekende bepalingen zijn daarom niet vastgesteld." Daaronder de type-melding bij mismatch. Dan vier groepen in vaste volgorde: Vastgesteld, Aandachtspunt, Niet vast te stellen, Positief. "Ontbrekende clausules" wordt "Checklist voor [type]" met drie kolommen aanwezig/afwezig/onduidelijk, elk aanwezig-item klikbaar naar de passage. Score en schild alleen bij `complete`. "Pas toe" alleen bij `vervangendeTekst` én `verified`. Het huidige lege-rapport-scherm ("Geen bevindingen") blijft, met de bestaande tekst.

**5.12 Error states.** Boven 200.000 tekens: "Dit document is te lang voor één review; neem contact op" (geen knip-instructie). Extractie leeg: bestaande melding. Structuurpass mislukt: review gaat door met `detectedType` leeg en `completeness: 'unknown'`. Reviewpass timeout: refund plus melding, geen gedeeltelijk resultaat opslaan. Parse- of schemafout: één automatische retry met dezelfde input, daarna fout; nooit een half-gevalideerd object naar de client. `AbortController` op elke Gemini-call; `maxDuration = 60` op de route.

**5.13 Tests.** Unit: `completeness.ts`, `evidence-guard.ts`, `score.ts`, `checklist-merge.ts`, zod-schema's, prompt-builders (snapshot). Contract: gefakete Gemini-responses (goed, afgekapt, verzonnen excerpt, mismatch) door `reviewDocument` heen. Component: `ComplianceReport` in de vier statussen. Gouden set (sectie 4.6) als `npm run test:review-eval`, niet in CI maar handmatig vóór elke prompt-bump. E2E: één Playwright-flow upload, mismatch-vraag, rapport, opslaan, heropenen.

## 6. Kosten en budget (eigen redenering, prijzen uit `cost-meter.ts`)

Een AV van 60.000 tekens: structuurpass circa 2.000 tokens, reviewpass circa 15.000 in en 4.000 uit, consistentiepass circa 3.000. Op flash-lite-prijzen circa 1,5 cent; als de reviewpass op flash (niet lite) draait circa 3 tot 4 cent. Tien reviews per maand op Business kost dan hooguit 40 cent tegen 49,99 omzet. Het huidige tokenbudget van 200.000 per maand is voor V2 te krap (zes grote documenten) en het `estimatedTokens`-model moet per pass. Advies: budget op 1.000.000 tokens Business, 150.000 Essential, en de dagcap in `cost-meter.ts` ongewijzigd laten als noodrem.

## 7. Implementatievolgorde

1. **Stop het bloeden (één dag).** `MAX_REVIEW_CHARS` naar 200.000, zod en extract mee, `GEMINI_MAX_OUTPUT_TOKENS` naar 16.000, `maxDuration = 60`, prompt-zin "als het document zichtbaar onvolledig is, geef geen missingArticles", `PROMPT_VERSION` naar `v1.1`, "Kort de tekst in" verwijderen. Dit lost G1 voor 95 % van de documenten op zonder architectuurwerk.
2. **Poorten en bewijs (drie dagen).** Zod op modeluitvoer, server-side `findPassage`, `completeness`, `evidence.verified`, `advies` versus `vervangendeTekst`, `Review`-kolommen en `ReviewInput`, migratie.
3. **Type-detectie en checklists (drie dagen).** Structuurpass, mismatch-dialoog, tien checklists.
4. **Nieuw rapport (twee dagen).** Taxonomie, statusbanner, checklistweergave, score in code.
5. **Gouden set en eval (twee dagen).** Fixtures, mutaties, `test:review-eval`.
6. **Consistentiepass en chunking-fallback (later).** Pas nodig als er documenten boven 200.000 tekens binnenkomen.

Beslissingen die bij [[Ali Can]] liggen vóór stap 2: score houden of schrappen (5.9), invoertekst bewaren en hoe lang (4.5), reviewpass op flash of flash-lite (6), en of stap 1 los eerst naar productie mag als noodfix.

Gerelateerd: [[klant-yvonne-heiligers]], [[pricing-besliskader-2026-09-16]] (de AI-limieten als packaging), [[masterplan-commercieel-2026-09-16]].
