---
type: implementatie
date: 2026-09-21
status: wacht op review
tags: [ai-review, kwaliteit, architectuur, productie]
project: ZekerWet
---

Fase 1 van AI Review V2 voor [[ZekerWet]], gebouwd op 21 september 2026 na de audit in [[ai-review-audit-2026-09-21]] en de vier besluiten van [[Ali Can]]: score weg, invoertekst 30 dagen bewaren, reviewpass op Flash, geen losse noodfix. Kernregel in code: het model observeert, deterministische code beslist wat de klant ziet. Niets gecommit, niets gepusht; de werkboom van de ZekerWet-repo staat klaar voor review.

## Besluiten technisch vastgelegd

| Besluit | Waar |
|---|---|
| Geen score, geen risicoschild; aantallen per categorie | `src/types/review.ts` (geen `score`-veld), `ComplianceReport.tsx`, `ReviewHistory.tsx`, `review-pdf.ts`; test 10 leest deze bestanden en faalt bij elke score-rendering |
| Invoertekst bewaren, 30 dagen | `ReviewInput`-tabel, `REVIEW_INPUT_RETENTION_DAYS` in `src/config/ai.ts`, cron `/api/admin/review-input-cleanup` (03:30 UTC, `vercel.json`), eigenaar-scoping en verloopcheck bij lezen in `api/reviews/[id]` |
| Flash voor de juridische pass | `REVIEW_MODEL = 'gemini-flash-latest'`, `STRUCTURE_MODEL = 'gemini-flash-lite-latest'` (fase 2), prijstiers in `cost-meter.ts` |
| Geen noodfix | Alles in één samenhangende wijziging |

## Architectuur na fase 1

1. **Input.** Tot 200.000 tekens (`MAX_REVIEW_CHARS`). Extractie kapt nooit af: boven de grens een `ValidationError` met uitleg (`extract-text.ts`). De textarea zegt niet meer "kort de tekst in" maar dat een langer document niet in één review past. De client stuurt `fullLength` mee zodat de server weet of hij het hele document zag.
2. **Modelcall** (`src/lib/gemini.ts`). Systeeminstructie met taxonomie, checklistregels en de scheiding advies/vervangendeTekst; document als apart user-bericht met delimiters. `responseSchema` op Gemini plus zod (`review-model-output.schema.ts`) aan onze kant. Ongeldige uitvoer: één retry als het tijdbudget het toelaat, anders `AiOutputError` (502). Nooit een half object. `AbortController` en deadline: 50 s totaal, 40 s per poging, `maxDuration = 60` op de route.
3. **Completeness** (`lib/review/completeness.ts`). `complete | partial | unknown` uit drie onafhankelijke bronnen: `fullLength` versus geanalyseerde tekens, een conservatieve tekstheuristiek (`endsAbruptly`: kop als laatste regel, of lange laatste regel zonder leesteken) en het oordeel van het model. Geen modeloordeel betekent `unknown`.
4. **Evidence guard** (`lib/review/evidence-guard.ts`). Elke excerpt door `findPassage`; niet gevonden is `verified: false`. `vastgesteld` zonder geverifieerde passage wordt `niet_vast_te_stellen`. `vervangendeTekst` overleeft alleen bij geverifieerde passage, bij taxonomie vastgesteld of aandachtspunt, als hij afwijkt van de passage en als hij leest als clausule (`replacement-text.ts`, lijst van adviesopeningen zoals "zorg", "overweeg", "controleer", tweede persoon, vraagteken). Anders verhuist hij naar `advies`. Checklist: `aanwezig` eist geverifieerde excerpt; `afwezig` eist `completeness === 'complete'` én dat het meest specifieke woord van het item niet in de tekst voorkomt (`keyword-check.ts`, `contradictsAbsence`). Aantallen worden in code geteld.
5. **Opslag.** De server slaat de review zelf op (`persistReview` in `ai-review.service.ts`): `Review` met `version 'v2'`, `completeness`, `counts`, `checklist`, `coverage`, `documentTypeInfo`, `inputSha256`, `inputChars`, `promptVersion`, `model`, tokens, `aiUsageLogId`, `lowConfidence`, plus `ReviewInput { text, sha256, expiresAt }`. Bestaande rijen krijgen expliciet `version 'v1'` (migratie `20260921120000_review_v2_evidence_and_input`, SQL identiek aan `prisma migrate diff`). `score` is nullable geworden; oude data blijft staan.
6. **Cache.** Redis bewaart nu de gevalideerde modeluitvoer, niet het eindresultaat, zodat de guards altijd op de actuele tekst en regels draaien. `PROMPT_VERSION = 'v2'` maakt alle v1-cache ongeldig.
7. **Lezen.** `GET /api/reviews/[id]` geeft `{ result, inputText }`; v1-rijen gaan door `lib/review/legacy.ts` (danger en warning worden aandachtspunt, ok wordt positief, `missingArticles` worden `onduidelijk`, completeness `unknown`, banner "Eerdere reviewversie"). `inputText` alleen binnen de bewaartermijn, zodat het werkblad passages weer kan vinden.
8. **UI.** Statusbanner (groen volledig, amber gedeeltelijk of onbekend), documenttype, aantallen, vier groepen in vaste volgorde, per bevinding passage met verificatiestatus, toelichting, en alleen bij een door de guard goedgekeurde `vervangendeTekst` de knop "Pas toe" (`canApplyFinding`). Checklist met aanwezig/afwezig/onduidelijk en basis wettelijk/gebruikelijk. Geschiedenis toont status en aantallen in plaats van een cijfer.

## AVG-toets op ReviewInput

Wat er verandert: tot nu toe bewaarde [[ZekerWet]] alleen de analyse, niet de tekst (comment in het oude `Review`-model). Nu 30 dagen de volledige tekst. Die tekst is vaak vertrouwelijk materiaal van derden en kan bijzondere persoonsgegevens bevatten; de intakeformulieren van [[Yvonne Heiligers]] bevatten gezondheidsgegevens.

Wat technisch is vastgelegd: doelbinding (reproduceerbaarheid en kwaliteitscontrole, in de schema-comment), opslagbeperking (`expiresAt`, dagelijkse cron), toegangsbeperking (alleen de eigenaar via owner-scoped route, verloopcheck bij lezen), cascade bij verwijdering van review of gebruiker, geen gebruik voor training. De Redis-cache bewaarde ook vóór V2 al zeven dagen modeluitvoer met tekstfragmenten; dat is ongewijzigd.

Wat bij [[Ali Can]] ligt: de privacyverklaring (`src/app/privacy/page.tsx`, sectie 2.3) zegt "tijdelijk voor verwerking"; 30 dagen bewaren hoort daar expliciet in, met het doel en de termijn. Voor klanten die gezondheidsgegevens laten reviewen is een verwerkersovereenkomst met ZekerWet de logische vervolgstap. Beide zijn tekst- en juridische wijzigingen, buiten deze implementatie gehouden.

## Tests

Nieuw: `src/lib/review/review-v2.test.ts`, 41 tests, deterministisch, zonder Gemini, met een gegenereerde AV van 42.000+ tekens (`lib/review/fixtures.ts`). De tien gevraagde tests zijn er allemaal: bestaand artikel 15 nooit "afwezig", document in twee fragmenten zonder definitieve claims, partial zonder afwezig-claims, verzonnen excerpt `verified: false`, advies nooit toepasbaar, geldige clausule wel, schemafout veilig met retry en `AiOutputError`, twintig bevindingen ruim onder de uitvoercap, nul bevindingen als geldige uitkomst, en geen `score` in respons, legacy-conversie, UI of export.

Resultaat: `tsc` schoon, 212 van 212 tests groen (was 171), `next lint` zonder meldingen op de gewijzigde mappen, `next build` zie hieronder.

## Openstaande risico's

- De migratie moet op productie worden toegepast vóór of bij de deploy (`prisma migrate deploy` of `db push` via `DIRECT_URL`); zonder de nieuwe kolommen faalt elke review-opslag stil (best-effort) en blijft de klant zonder geschiedenis.
- `gemini-flash-latest` als alias: het concrete model en de prijs zijn niet vanaf de laptop te controleren. De Flash-prijzen in `cost-meter.ts` zijn bewust te hoog gezet (≈ $1,00 / $8,00 per miljoen tokens) en per omgeving te overschrijven met `AI_PRICE_FLASH_INPUT_MICROS` en `AI_PRICE_FLASH_OUTPUT_MICROS`. Eerste echte review: `modelVersion` en tokens in `AiUsageLog` nakijken.
- Vercel: `maxDuration = 60` vereist Fluid Compute of Pro; op Hobby zonder Fluid is 10 s de grens en dan faalt elke lange review. Nakijken in het dashboard vóór de deploy.
- De heuristiek `endsAbruptly` is bewust conservatief; een fragment dat op een korte regel eindigt wordt alleen door het modeloordeel of `fullLength` gevangen. Fase 2 voegt de structuurpass toe.
- Tokenbudgetten zijn verhoogd (Essential 150.000, Business 1.000.000) omdat één volledig document nu 15.000 tot 50.000 tokens kost. Dit is een bewuste wijziging van quota-logica, geen bijeffect.
- Documenttype staat nog standaard op `nda` in de select; dat is fase 2 ("Automatisch herkennen").

## Wat fase 2 nodig heeft

Structuurpass op `STRUCTURE_MODEL` met `detectedType`, `confidence`, sectie-index en `endsAbruptly`; `documentType.mismatch` wordt dan gevuld (het veld en de UI-regel bestaan al). Checklists per type in `src/config/review-checklists.ts` voor de tien types uit de audit, met `basis` en `wetsartikel`; de guard vergelijkt dan de modelchecklist met de codechecklist in plaats van de modelchecklist te vertrouwen. `keyword-check.ts` krijgt synoniemen per item. Select-standaard "Automatisch herkennen" en de mismatch-dialoog vóór de dure pass.

Gerelateerd: [[ai-review-audit-2026-09-21]], [[klant-yvonne-heiligers]].
