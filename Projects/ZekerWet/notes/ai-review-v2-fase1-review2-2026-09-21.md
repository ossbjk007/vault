---
type: review
date: 2026-09-21
status: afgerond
tags: [ai-review, kwaliteit, codereview, productie]
project: ZekerWet
---

Tweede read-only codereview van fase 1 van AI Review V2 voor [[ZekerWet]], na de fixes in [[ai-review-v2-fase1-fixes-2026-09-21]]. Op verzoek van [[Ali Can]]. Niets gewijzigd, niets gecommit.

## Verdict: READY FOR COMMIT

De twee blockers uit [[ai-review-v2-fase1-codereview-2026-09-21]] staan in de code en zijn live bewezen; de twee HIGH-punten hebben regressietests. Wat overblijft zijn productievoorwaarden (kostenmeter, privacyverklaring, migratie), geen commit-blokkades.

## Gecontroleerd in de code

- **Gemini.** `thinkingConfig: { thinkingLevel: 'low' }` in `buildGenerationConfig()` (`gemini.ts:206`), `responseSchema` (`:205`), `required` met `documentLijktOnvolledig` en `documenttypeKlopt` (`:119`), keten met `modelIndex++` bij 503/429/404 (`:354-358`), `AiTimeoutError` bij abort of verlopen deadline (`:335`, `:351`), `AiOutputError` alleen na parse-falen (`:395`), `finishReason` gelogd bij afwijking (`:222-224`). Service: `AbortController` met timer van 50 s en dezelfde deadline (`ai-review.service.ts:416-423`), refund in de catch. Half resultaat onmogelijk: `parseModelOutput` geeft `null` of een door zod goedgekeurd object, en alleen dat object bereikt cache, guard en database. Abort-detectie klopt op de echte SDK-tekst ("Request aborted when fetching").
- **Budget.** 50 s totaal, 40 s per poging, fallback alleen als er nog 13,5 s over is. Gemeten 503-latentie 13 tot 25 s, dus de fallback past. Een primair model dat 40 s hangt in plaats van snel 503 geeft, blokkeert de fallback: MEDIUM.
- **Mismatch.** `documenttypeKlopt` verplicht in zod en schema; prompt laat checklist leeg bij mismatch; `applyGuards` voegt de code-bevinding toe en zet afwezig naar onduidelijk (`evidence-guard.ts`); UI-regel "Lijkt een ander documenttype". Regressietest intakeformulier/personeelslening: vijf tests.
- **Keyword-guard.** `stem` kort dubbele slotmedeklinker in; gelijke-lengte-woorden tellen mee; `compoundPresent` splitst alleen op "s"/"en" met beide helften ≥ 5 tekens en beide in de tekst. Tegenvoorbeelden getest: boetebeding, rentepercentage, aflossingsschema blijven afwezig. Overmatching-risico: alleen richting "onduidelijk", nooit richting "afwezig".
- **Core safety** ongewijzigd sinds review 1: 200k-grens, geen slice, completeness, evidence, `canApplyFinding` op actuele passage, geen score, V1-conversie, `ReviewInput` met verloopcheck en cascade, cache van modeluitvoer met guards opnieuw.

## Kostenmeter

Bug bevestigd, bestaand sinds commit `e7f6419`. Eenheid: 1 micro = €0,000001 (`MICROS_PER_CENT = 10_000`, digest deelt door 1.000.000). Een prijs van €0,28 per miljoen tokens is dan 280.000 micros per miljoen, niet 280. Vier constanten fout: `INPUT_PRICE_PER_M_MICROS` 280 → 280.000, `OUTPUT_PRICE_PER_M_MICROS` 2.340 → 2.340.000, `FLASH_INPUT_PRICE_PER_M_MICROS` 940 → 940.000, `FLASH_OUTPUT_PRICE_PER_M_MICROS` 7.500 → 7.500.000. Productiebewijs: `AiUsageLog` 2.727 tokens → 3 micros, werkelijk circa 1.400 micros. Dagcap €5 = 5.000.000 micros trip pas na ruim een miljoen reviews: praktisch uit. Gevolgen van de fix: spend-cap werkt (circa 100 tot 250 Flash-reviews per dag op de standaardcap), digest toont echte euro's, `COST_PER_REQ_WARNING_MICROS` (100.000) kan bij een maximaal document met volle uitvoer afgaan → mee verhogen naar 250.000. Geen gevolg voor tokenbudgetten, quota-reservering of refund (allemaal tokengebaseerd). Historische rijen blijven duizendmaal te laag; optionele backfill ×1000. Tests: er bestaat geen `cost-meter.test.ts`; toevoegen met `priceForMicros(1_000_000, 0, 'gemini-3.5-flash-lite') === 280_000` en het Flash-equivalent.

## Gemini live

Vijf pogingen met het 42k-document op het alias `gemini-flash-latest`: nul geslaagd (drie in de eerste run, één in elk van de twee ketenruns), allemaal 503 na 13 tot 25 s. `gemini-3.7-flash`: nul van drie. `gemini-2.5-flash`: 404. `gemini-3.5-flash`: drie van drie geslaagd (6,6 s direct; 21,8 s en 13,9 s via de keten inclusief de 503 van het alias). Fallback werkte twee van twee keer. Advies op basis van deze cijfers: `AI_REVIEW_MODEL=gemini-3.5-flash` als primair in de Vercel-omgeving tot het alias stabiel is; scheelt 13 tot 25 s per review. De smoke-test is representatief voor de mechaniek (schema, cap, keten, guards), niet voor juridische kwaliteit: één synthetisch document, één type, geen live mismatch- of fragmenttest.

## Model-recall

Het weggelaten artikel "Toepasselijk recht en bevoegde rechter" stond in nul van vier runs in de checklist; in vier runs is nul keer "afwezig" uitgesproken. De checklist is in fase 1 dus vooral een aanwezig/onduidelijk-lijst. Geen blocker (de guard voorkomt onwaarheden), wel bewust fase 2: codechecklists per type met synoniemen.

## Productievoorwaarden vóór livegang

1. Kostenmeter ×1000 (besluit Ali, één regel per constante plus test).
2. Privacyverklaring sectie 2.3: "tijdelijk voor verwerking" wordt "30 dagen bewaard voor reproduceerbaarheid en kwaliteitscontrole, daarna automatisch verwijderd". Legal prerequisite.
3. Migratie `20260921120000_review_v2_evidence_and_input` op productie vóór de deploy, via `DIRECT_URL` met `prisma migrate deploy`; alle zes eerdere migraties staan in `_prisma_migrations`, `Review` heeft de nieuwe kolommen nog niet. De Vercel-build draait alleen `prisma generate`. Volgorde is veilig: de migratie is additief en de oude code raakt de nieuwe kolommen niet.
4. `AI_REVIEW_MODEL=gemini-3.5-flash` in Vercel zetten (aanbevolen) en `AI_HEALTH_CRON_SECRET` blijft de auth van de nieuwe cron.

## Git

Twintig gewijzigde en vijf nieuwe paden van fase 1, allemaal onder `src/`, `prisma/`, `vercel.json` en `.gitignore`. De reconciler wijzigt ondertussen 55 bestanden onder `marketing/` (stand veranderde tijdens deze sessie). Geen overlap, maar `git add -A` zou ze meenemen: committen per pad.

Gerelateerd: [[ai-review-v2-fase1-2026-09-21]], [[ai-review-audit-2026-09-21]].
