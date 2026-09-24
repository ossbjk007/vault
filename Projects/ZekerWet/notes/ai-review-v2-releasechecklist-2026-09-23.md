---
type: checklist
date: 2026-09-23
status: actief
tags: [ai-review, release, vercel, deploy]
project: ZekerWet
---

Releasechecklist voor AI Review V2 fase 1 plus alles wat er tussen 22 en 23 september 2026 bovenop is gebouwd. Achtergrond, metingen en afwegingen staan in [[ai-review-v2-timeout-diagnose-2026-09-22]] en [[google-cloud-billing-zekerwet-2026-09-22]]. HEAD staat op `20f6891`, dat is al gedeployd; alles hieronder staat ongecommit in de werkboom.

> [!warning] Eén ding vóór alles
> De twee productie-reviews van 22 september faalden. De wallet is daarna gevuld en zes lokale calls slaagden, maar **op productie is sinds `20f6891` nog geen enkele geslaagde review gedraaid**. Stap 7 is daarom geen formaliteit maar de eigenlijke test.

## 1. Omgevingsvariabelen in Vercel, project `zekerwet`

Settings, Environment Variables. Alle drie op **Production en Preview**. Ze gaan vóór de code-defaults, dus zonder deze stap verandert een deploy er niets aan.

| Variabele | Waarde | Waarom |
|---|---|---|
| `AI_DAILY_CAP_EUR_CENTS` | `334` | Eén Business-klant mag zijn hele maandtegoed (2,23 euro) op één dag opmaken zonder geweigerd te worden. Stond op een oude waarde die niet leesbaar is, want het type is `sensitive` |
| `AI_MONTHLY_CAP_EUR_CENTS` | `445` | Twee keer het maandrecht van het huidige bestand. De code-default is inmiddels ook 445, maar de variabele in Vercel wint, dus hij moet expliciet goed staan |
| `AI_HEALTH_DIGEST_TO` | het eigen adres van [[Ali Can]] | Kostendigest én de twee alerts (cap en wallet) gaan hierheen in plaats van naar `support@zekerwet.nl`, waar ze nu de supportinbox vervuilen |

Niet aanpassen: `GOOGLE_AI_API_KEY` en `AI_HEALTH_CRON_SECRET` staan er al en blijven zoals ze zijn. `AI_REVIEW_MODEL`, `AI_REVIEW_FALLBACK_MODELS`, `AI_STRUCTURE_MODEL` en alle `AI_PRICE_*` staan er bewust niet: daarvoor gelden de code-defaults, en die zijn sinds 22 september gecorrigeerd.

## 2. Wat er gecommit wordt, per pad

Nooit `git add -A`. Buiten de release blijven: `marketing/` (55 bestanden van de reconciler, eigen ritme), `.smoke/` (proberapporten met documentteksten), `.env` (untracked en genegeerd) en de twee tijdelijke probes.

**Gewijzigd, negen paden:**

```
git add .env.example         src/config/ai.ts         src/lib/gemini.ts         src/lib/cost-meter.ts         src/lib/cost-meter.test.ts         src/lib/review/review-v2.test.ts         src/services/ai-review.service.ts         src/app/api/ai/review/route.ts         src/app/api/admin/ai-health/route.ts
```

**Nieuw, zes paden:**

```
git add src/lib/cap-alert.ts         src/lib/cap-alert.test.ts         src/lib/wallet-alert.ts         src/lib/wallet-alert.test.ts         src/emails/AiCapAlert.tsx         src/emails/AiWalletAlert.tsx         src/services/ai-review.service.test.ts         scripts/fix-ai-counters.mjs
```

**Uitdrukkelijk NIET committen:** `src/lib/review/provider-probe.temp.test.ts` en `src/lib/review/provider-probe-200k.temp.test.ts`. Die verwijzen naar fixturebestanden in tijdelijke mappen en draaien echte betaalde calls; ze horen niet in de repo. Weggooien na de release, of laten staan als untracked.

Controle vóór de commit: `git status --short` mag buiten `marketing/` niets anders tonen dan de paden hierboven plus de twee probes.

## 3. Migratie

Geen. De migratie `20260921120000` is op 22 september al toegepast op productie; er zijn sindsdien geen schemawijzigingen bij gekomen.

## 4. Push

`git push origin main`. Dat start de productiedeploy vanzelf, dus stap 1 moet af zijn: anders draait de nieuwe code één deploy lang met de oude capwaarden.

## 5. Deploy nakijken

In Vercel: status READY, geen buildfouten. Daarna `https://zekerwet.nl/` en `https://www.zekerwet.nl/` op 200 respectievelijk 308, en de runtimelogs op nul errors.

## 6. Redeploy na de variabelen

Zijn de variabelen uit stap 1 ná de push gezet, dan is één extra deploy nodig: een draaiende deploy leest ze niet opnieuw.

## 7. Productie-smoke, de eigenlijke test

Eén echte review via de Copilot op een synthetisch document, geen klantmateriaal. Daarna controleren:

- De review komt terug, met bevindingen en zonder foutmelding
- `AiUsageLog`: één rij, `model` is `gemini-3.5-flash`, tokens en `costEurMicros` gevuld, kosten in de buurt van 4 cent bij 42.000 tekens
- `Review`: `version` is `v2`, `ReviewInput` bestaat met een `expiresAt` over 30 dagen
- De tellers van het account kloppen: precies één review erbij, geen dubbele afschrijving

Faalt hij, dan zegt het foutbeeld wat er aan de hand is: `AI_WALLET_EMPTY` is de wallet (mail volgt automatisch), `AI_PROVIDER_UNAVAILABLE` is Google die het druk heeft, `AI_TIMEOUT` is een traag model dat ook op het tweede model niet op tijd antwoordde.

## 8. Daarna, los van de release

- Budgetalert in `console.cloud.google.com` op het factureringsaccount, zodat een lek zichtbaar is buiten onze eigen caps om ([[google-cloud-billing-zekerwet-2026-09-22]])
- "Vertex" uit `src/app/privacy/page.tsx:145`, wij gebruiken de Gemini Developer API
- De twee tijdelijke probes weggooien


## Uitvoering, 23 september 01:00 tot 01:15

**Stap 0, verificatie.** Geen Vercel-CLI in de repo en geen `.vercel`-koppeling, dus via de Vercel-API gelezen. Alle vijf de variabelen bestaan: `AI_DAILY_CAP_EUR_CENTS` (sensitive) en `AI_MONTHLY_CAP_EUR_CENTS` (sensitive) op Production en Preview, beide vannacht bijgewerkt; `AI_HEALTH_DIGEST_TO` (encrypted) op Production en Preview, vannacht aangemaakt; `GOOGLE_AI_API_KEY` en `AI_HEALTH_CRON_SECRET` ongewijzigd. Geen typefouten en geen bijna-gelijke varianten in de dertig variabelen, niets verborgen. De wáárden van de twee caps zijn niet te lezen, want `sensitive`; alleen het tijdstip van wijzigen bevestigt dat er iets is gezet.

**De kostenmail toont alleen de dagcap.** `ai-health/route.ts:124` haalt uitsluitend `dailyCapMicros()` op, en `AiCostDigest.tsx:76` toont één regel "Daglimiet (€X,XX)". De maandcap komt in die mail niet voor en is dus pas te bevestigen op de dag dat hij sluit; dan noemt de cap-alert het bedrag én de variabelenaam.

**Stap 2 en 4.** Commit `1ffce19`, zeventien paden per pad gestaged, nul bestanden uit `marketing/`, `.smoke/` of `.env`. De twee tijdelijke probes zijn bewust untracked gebleven. Gepusht naar `origin/main`.

Vóór de commit is het commentaar bij de caps in `.env.example` herschreven op verzoek van [[Ali Can]]: de verhouding 1 op 10 klopte niet meer met productie, dus er staat nu de formule (maandcap is twee keer wat alle betalende klanten samen per maand mogen verbruiken in het ergste geval; dagcap is de grootste van anderhalf keer één klantmaand, een kwart van de maandcap, of 100 cent), plus dat productie op 334/445 staat en dat de waarden in het bestand alleen een vangnet zijn als de variabele ontbreekt. Bij de fallbackregel staat nu dat sinds 23 september ook een eigen timeout van een poging een modelwissel start.

**Stap 5, eerst nog niet klaar.** Deploy `dpl_Ct6k72YiDk5C7sU6nvQxFiaWP5qt` staat na een kwartier nog op BUILDING en heeft nul aliassen. `zekerwet.nl` en `www.zekerwet.nl` wijzen nog naar `dpl_9pKSZEcAoGkjbDHKn9eaoD5Bo8Ws`, de deploy van `20f6891`. **De nieuwe code draait dus nog niet op productie.** De site zelf is gezond (apex 200, www 308, `/pricing` en `/kennisbank` 200) en er staan nul runtime-errors in de laatste twee uur, maar dat is de oude deploy.


## Deploy live en kostenmail getriggerd, 23 september 01:16

Deploy `dpl_Ct6k72YiDk5C7sU6nvQxFiaWP5qt` is READY na 3m20s en draagt nu `zekerwet.nl`, `www.zekerwet.nl` en de twee projectaliassen; de deploy van `20f6891` is daarmee vervangen. Commit `1ffce19` draait dus op productie.

Kostenmail met de hand getriggerd op `GET /api/admin/ai-health` met het Bearer-token uit de lokale `.env`: **HTTP 200 in 2,6 seconden**, respons `ok: true, sent: true` over het venster van 21 september 23:16 tot 22 september 23:16, met nul kosten, nul betaalbare requests en nul cachehits. Dat klopt: er is sinds de mislukte runs van 22 september geen enkele geslaagde review op productie geweest.

Runtimelogs van deze deploy sinds hij live is: **nul errors, nul warnings**, 21 requests allemaal met status 200.

Wat er in de mail moet staan is de dagcap: **"Daglimiet (€3,34)"**. Komt daar een ander bedrag, dan staat `AI_DAILY_CAP_EUR_CENTS` in Vercel op iets anders dan 334; de waarde is `sensitive` en dus niet te lezen, deze mail is de enige manier om hem te bevestigen. De maandcap staat niet in deze mail.
