---
type: implementatie
date: 2026-09-21
status: wacht op tweede review
tags: [ai-review, kwaliteit, gemini, productie]
project: ZekerWet
---

Oplossing van de twee blockers en twee HIGH-punten uit [[ai-review-v2-fase1-codereview-2026-09-21]] voor de AI Review V2 van [[ZekerWet]], op verzoek van [[Ali Can]]. Niets gecommit, niets gepusht, geen migratie op productie. Alles staat in de werkboom van de ZekerWet-repo.

## Wat de live smoke-run blootlegde

De eerste echte aanroep van de nieuwe combinatie gaf drie feiten die offline niet te zien waren.

1. **`gemini-flash-latest` wijst naar `gemini-3.8-flash` en denkt.** Met een cap van 50 uitvoertokens verbruikte het model 47 tot 79 denktokens en gaf een leeg antwoord met `finishReason MAX_TOKENS`. `thinkingBudget: 0` werd genegeerd; `thinkingLevel: 'low'` werd geaccepteerd en het antwoord kwam. De reviewpass stuurt nu `thinkingConfig: { thinkingLevel: 'low' }` mee (`REVIEW_THINKING_LEVEL`, via een cast omdat SDK 0.24 het veld niet typeert; de SDK geeft `generationConfig` ongewijzigd door aan de REST-body).
2. **Het Flash-alias geeft 503 "high demand" op grote verzoeken.** Drie van drie pogingen met het document van 42.000 tekens op `gemini-flash-latest`, drie van drie op `gemini-3.7-flash`, één van drie op een piepklein verzoek. `gemini-2.5-flash` is met pensioen (404). `gemini-3.5-flash` beantwoordde hetzelfde document in 6,6 seconden met geldige JSON. Oplossing: een modelketen. `REVIEW_MODEL` (alias) blijft primair; bij 503, 429 of 404 schakelt `analyzeLegalDocument` na 1,5 seconde naar `REVIEW_FALLBACK_MODELS` (standaard `gemini-3.5-flash`, per omgeving te zetten met `AI_REVIEW_FALLBACK_MODELS`), en als de hele keten faalt nog één keer terug naar het primaire model. Alles binnen het tijdbudget van 50 seconden; Flash-Lite zit bewust niet in de keten, zodat besluit 3 (Flash voor de juridische kern) staat. `AI_REVIEW_MODEL` overschrijft het alias zonder deploy.
3. **De keyword-guard miste twee samenstellingen.** Het model claimde "Betalingsvoorwaarden" en "Klachtenregeling" afwezig op een document met "Artikel 4 – Prijzen en betaling" en "Artikel 13 – Klachten". `contradictsAbsence` splitst nu Nederlandse samenstellingen op een voegmorfeem ("s", "en") en telt de bepaling als aanwezig als beide delen in de tekst staan ("betaling" + "voorwaard", "klacht" + "regel"); zonder voeg ("boetebeding", "hoofdsom") wordt niet gesplitst, dus een echt ontbrekende bepaling blijft afwezig. In de laatste run staan beide items op "onduidelijk" met de noot dat de termen in het document voorkomen.

## Laatste smoke-run (eindstand van de code)

`gemini-flash-latest` gaf 503, keten schakelde naar `gemini-3.5-flash`, `modelVersion` `gemini-3.5-flash`, 42.096 tekens, 13,9 seconden, 2 pogingen, `finishReason STOP`, 12.032 prompttokens, 1.473 uitvoertokens (cap 16.384, `thoughtsTokenCount` niet gerapporteerd bij `thinkingLevel low`), zod geslaagd, `completeness complete`, 3 bevindingen met 3 geverifieerde passages, 1 vervangende clausule door de guard goedgekeurd, checklist 2 aanwezig en 2 onduidelijk, nul afwezig. `AiUsageLog` en `Review` op productie ongewijzigd (21 en 17 rijen, laatste 14 september): de smoke roept `analyzeLegalDocument` rechtstreeks aan, buiten service, database en quota. De run is herhaalbaar met `GEMINI_SMOKE=1 npx vitest run src/lib/review/gemini-live.smoke.test.ts`; rapporten landen in `.smoke/` (gitignored).

## De vier punten

- **Blocker 2, `documentLijktOnvolledig` verplicht:** in `required` van het responseSchema én `z.boolean().nullable()` zonder `.optional()`. Nieuwe tests wijzen output zonder het veld af en accepteren een expliciete `null` als `unknown`.
- **HIGH 1, documenttype-mismatch:** nieuw verplicht modelveld `documenttypeKlopt` plus `waargenomenDocumenttype`. De prompt vraagt geen aparte bevinding meer en laat de checklist leeg bij mismatch. De code voegt zelf één bevinding toe (aandachtspunt, hoog: "Het document lijkt een ander type dan gekozen", met het gekozen en het waargenomen type), zet elke "afwezig" naar "onduidelijk" met uitleg, en een modelbevinding over het type wordt niet meer gedegradeerd naar "passage niet teruggevonden". Regressietest met een synthetisch intakeformulier als "personeelslening": nul afwezig, mismatch gemeld, geverifieerde "aanwezig" blijft staan.
- **HIGH 2, stemming:** `stem('datalekken')` geeft nu `datalek` (dubbele slotmedeklinker ingekort na suffix-strip), gelijke-lengte-woorden tellen allebei als specifiek. Regressietest: document met "datalek" tegen "Meldplicht datalekken" geeft contradictie en dus "onduidelijk".

## Resterende risico's

- **Kostenmeter telt duizend keer te laag (bestaand, buiten deze opdracht).** `INPUT_PRICE_PER_M_MICROS = 280` staat voor "€0,28 per miljoen tokens", maar 280 micros is €0,00028. In `AiUsageLog` kost een review van 2.727 tokens 3 micros (€0,000003) in plaats van circa €0,001. De globale spend-cap (`AI_DAILY_CAP_EUR_CENTS`) grijpt daardoor praktisch nooit in, ook niet na V2. Fix: constanten ×1000 (`280_000`, `2_340_000`, en de Flash-waarden). Niet gedaan omdat het quota-gedrag verandert; besluit van [[Ali Can]].
- Het alias `gemini-flash-latest` is op dit moment structureel overbelast voor grote verzoeken; in productie zal bijna elke review via de fallback lopen en 10 tot 15 seconden extra kosten door de 503. Overweeg `AI_REVIEW_MODEL=gemini-3.5-flash` als primair tot het alias stabiel is.
- Model-recall is niet de guard: het weggelaten artikel "Toepasselijk recht" kwam in drie runs nooit in de checklist. Dat is fase 2 (codechecklists per type).
- De privacyverklaring (sectie 2.3) noemt de bewaartermijn van 30 dagen nog niet; migratie moet op productie worden toegepast vóór de deploy.

Gerelateerd: [[ai-review-v2-fase1-2026-09-21]], [[ai-review-audit-2026-09-21]].
