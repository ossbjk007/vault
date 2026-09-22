---
type: review
date: 2026-09-21
status: afgerond
tags: [ai-review, kwaliteit, codereview, productie]
project: ZekerWet
---

Read-only codereview van fase 1 van AI Review V2 ([[ai-review-v2-fase1-2026-09-21]]) voor [[ZekerWet]], op verzoek van [[Ali Can]]. Niets gewijzigd, niets gecommit, geen migratie uitgevoerd. Regelnummers naar de ongecommitte werkboom.

## Verdict: BLOCKED

Twee blockers, allebei in de koppeling met Gemini, allebei klein om op te lossen maar niet te bewijzen zonder één echte call.

1. **Geen enkele live call gedaan met de nieuwe combinatie** (`gemini-flash-latest`, `responseSchema` met enum en nullable, `maxOutputTokens` 16.384). De repo-geschiedenis documenteert precies het risico: commit `277052a` stapte van Flash naar Flash-Lite omdat "thinking"-tokens van Flash meetellen in `maxOutputTokens` en de JSON afkapten. Bij een document van 50.000 tokens kan het denkbudget een groot deel van de 16k opeten; dan faalt `JSON.parse`, de retry faalt op dezelfde manier, en elke lange review eindigt in `AI_OUTPUT_INVALID`. Veilig (refund, geen half resultaat) maar de kernfunctie werkt dan niet. `GenerationConfig` in SDK 0.24 kent geen `thinkingConfig` (grep leeg), dus een `thinkingBudget` moet via een cast naar de REST-config. Actie: één smoke-run met een AV van 40.000+ tekens, `modelVersion` en `candidatesTokenCount` in `AiUsageLog` nakijken, en óf `thinkingBudget` begrenzen óf de uitvoercap naar 32k.
2. **`documentLijktOnvolledig` staat niet in `required`** (`src/lib/gemini.ts:111`, alleen `bevindingen` en `checklist`). Laat het model het veld weg, dan wordt `modelSaysIncomplete` null en `assessCompleteness` geeft `unknown` (`completeness.ts`), waarna de guard élke "afwezig" naar "onduidelijk" zet en de UI een amberkleurige banner toont op een compleet document. Veilig, maar de checklist zegt dan nooit meer "afwezig" en het product oogt kapot. Actie: veld in `required` opnemen (blijft nullable).

## HIGH, vóór productie

- **Type-mismatch is in fase 1 half geregeld.** De prompt vraagt bij een ander documenttype een bevinding `vastgesteld` met sectie "Documenttype" (`gemini.ts:125`), maar de guard eist voor `vastgesteld` een geverifieerde passage en degradeert die bevinding zonder excerpt naar `niet_vast_te_stellen` met de noot "passage niet teruggevonden". Tegelijk blijft de checklist gebonden aan het gekozen type ("uitsluitend bepalingen voor het type X"), dus het intakeformulier-als-personeelslening van [[Yvonne Heiligers]] krijgt op een compleet document nog steeds "hoofdsom, rente, aflossing: afwezig". Actie in fase 2 (typedetectie), of nu één promptregel: bij mismatch checklist leeg laten en de mismatch-bevinding met de titelregel als excerpt.
- **Stemming in `keyword-check.ts` mist enkelvoud na dubbele medeklinker.** `stem('datalekken')` geeft `datalekk`; een document dat alleen "datalek" schrijft geeft geen contradictie, dus een foutieve "afwezig" voor "Meldplicht datalekken" passeert op een compleet document. Actie: na suffix-strip een dubbele slotmedeklinker inkorten, plus test.

## MEDIUM

- `isReplacementText` weigert clausules die beginnen met "U", "Dit artikel", "Mogelijke", "De tekst" (adviesheuristiek). Veilige richting (niet toepasbaar, wel getoond), maar AV in u-vorm krijgen zelden een "Pas toe".
- `handleReopen` vervangt de textarea stil door `inputText`; ongeopgeslagen wijzigingen van de klant zijn weg. Zonder `inputText` (verlopen) blijft de oude tekst staan en werkt "Ga naar passage" op een ander document als de passage toevallig voorkomt.
- Commentaar in `ai-review.service.ts` (`persistReview`) claimt een keten `inputSha256 ↔ ReviewInput.sha256 ↔ AiUsageLog.inputHash`; de eerste twee zijn gelijk (sha256 van de tekst), de derde is sha256 van `v2:type:tekst`. De koppeling loopt via `aiUsageLogId`, niet via de hash.
- Mislukte modelcalls (timeout, tweede ongeldige poging) worden niet in `AiUsageLog` of de spend-teller geboekt; met de retry kan dat twee onbetaald-geregistreerde calls per verzoek zijn. Bestaand gedrag, nu verdubbeld.
- `GET /api/reviews` selecteert `findings` van 50 rijen om v1-tellingen te maken.
- `modelVersion` wordt uit de ruwe SDK-respons gecast; het SDK-type kent het veld niet. Werkt vermoedelijk (de SDK geeft de JSON door), niet bewezen; bij ontbreken slaat `model` de alias op.

## LOW

- `endsAbruptly`: `CLOSING_LINE` matcht "datum", "plaats", "namens" overal in de regel, `TERMINAL` accepteert ":" en ";". Heuristiek mist dan; modeloordeel en `fullLength` vangen het op.
- `findPassage` eist een unieke treffer; een excerpt dat twee keer voorkomt (korte kop) wordt "niet geverifieerd".
- `reviewSchema.type` heeft geen maximumlengte (bestaand).
- Vercel `maxDuration = 60` is op Hobby toegestaan (maximum 60 zonder Fluid); mijn eerdere opmerking dat dit Fluid of Pro vereist was te streng.
- Tests: geen test op `extract-text` boven de grens, op `record.ts`, op de cron, op de cache-hit-tak en op de quota-takken (die laatste waren er ook vóór V2 niet).

## Wat PASS is, met bewijs

Zie de tabel in het antwoord van 21 september; samengevat: geen stille truncatie (`sanitizeDocumentText` zonder slice, `extract-text.ts` gooit `DOCUMENT_TOO_LONG`, zod `max(200_000)`), `responseSchema` plus zod met retry binnen deadline en `AiOutputError`, abort via SDK-signal (`buildFetchOptions` in de SDK koppelt het signaal aan `fetch`), `verified` alleen bij `findPassage`-treffer, "afwezig" alleen bij `complete` én zonder contradictie, "Pas toe" uitsluitend via `canApplyFinding` op een guard-goedgekeurde `vervangendeTekst` met actuele passage, geen score in V2-shape/UI/export (repo-grep), `ReviewInput` owner-scoped met verloopcheck en cascade, cache bewaart modeluitvoer en guards draaien opnieuw, quota/idempotency/refund/spend cap ongewijzigd behalve de bewuste budgetverhoging, migratie-SQL identiek aan `prisma migrate diff` en productie heeft alle zes eerdere migraties in `_prisma_migrations`, dus `migrate deploy` past alleen de nieuwe toe.

Gerelateerd: [[ai-review-audit-2026-09-21]], [[klant-yvonne-heiligers]].
