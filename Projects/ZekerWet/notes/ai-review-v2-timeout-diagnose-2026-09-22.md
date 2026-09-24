---
type: diagnose
date: 2026-09-22
status: wacht op besluit
tags: [ai-review, gemini, timeout, productie]
project: ZekerWet
---

Read-only diagnose van de timeout die de productie-smoke van AI Review V2 blokkeerde ([[ai-review-v2-fase1-review2-2026-09-21]]). Niets gewijzigd, niets gedeployd, geen nieuwe productie-review gedraaid. Bewijs uit de Vercel-runtimelogs van deployment `dpl_9pKSZEcAoGkjbDHKn9eaoD5Bo8Ws`, de vier lokale smoke-rapporten in `.smoke/` en de code in de werkboom.

## Wat er feitelijk gebeurde

`POST /api/ai/review` kwam binnen om 13:38:46. Onze eigen logregel `AI analysis timed out` volgde om 13:39:29,707, de foutrespons om 13:39:29,795: **43,7 seconden na binnenkomst**. Model `gemini-3.5-flash`, `attempts: 1`, HTTP 504 met code `AI_TIMEOUT`.

De per-poging-timeout is 40 seconden (`GEMINI_ATTEMPT_TIMEOUT_MS`), doorgegeven aan de SDK als `timeout` én bewaakt door onze `AbortController` op 50 seconden. De SDK brak dus af op 40 seconden. Het verschil van 3,7 seconden is het werk vóór de modelcall: Clerk-auth plus `currentUser`, de spend-cap-lookup in Redis, de rate limit, de idempotency-reservering, het parsen van een body van 42 KB, de `user.upsert` in Postgres en de cachelookup. Die 3,7 seconden vallen **buiten** het interne budget van 50 seconden, want de deadline wordt pas gezet ná de quotareservering.

Conclusie in één zin: het model heeft binnen 40 seconden niets teruggestuurd; alles vóór en na de modelcall werkte.

## Tijdlijn

| Fase | Duur | Bron |
|---|---|---|
| Request binnen op de functie | t=0 (13:38:46) | Vercel-log |
| Auth, spend-cap, rate limit, idempotency, body-parse, user-upsert, cachelookup, quotareservering | circa 3,7 s | afgeleid: 43,7 s totaal min 40 s attempt |
| Gemini-call gestart, deadline 50 s gezet | t≈3,7 s | `ai-review.service.ts` |
| SDK breekt af op de per-poging-timeout | t≈43,7 s | `AI analysis timed out`, 13:39:29,707 |
| `AiTimeoutError` → 504, refundpad | t≈43,8 s | `AI_TIMEOUT`, 13:39:29,795 |
| Parse, zod, guards, DB-write, response | niet bereikt | geen rij in `Review`, `ReviewInput`, `AiUsageLog` |

## Productie versus lokaal

Identiek: modelnaam `gemini-3.5-flash`, `thinkingLevel: 'low'`, `maxOutputTokens` 16.384, `temperature` 0,1, `responseMimeType` JSON, `responseSchema`, systeeminstructie, SDK `@google/generative-ai` 0.24.1, per-poging-timeout 40 s, documentlengte (42.096 tekens lokaal, 42.135 in productie). Vercel heeft geen `AI_REVIEW_MODEL`, `AI_REVIEW_FALLBACK_MODELS` of `AI_PRICE_*` gezet, dus de code-defaults golden.

Verschillend: uitvoeringsomgeving (laptop in Nederland versus Vercel-functie in `iad1`), moment (lokaal 21 september rond 12:38 tot 12:50 UTC, productie 22 september 13:38 UTC), documenttype in de systeeminstructie (`terms` versus `samenwerking`) en het feit dat de lokale runs `analyzeLegalDocument` rechtstreeks aanriepen zonder Clerk, Redis en Prisma ervoor.

Lokale metingen met dezelfde fixture: 6.616 ms op `gemini-3.5-flash` in één poging; 21.791 ms en 13.902 ms met een 503 van het alias en daarna `gemini-3.5-flash`; 3.475 ms op Flash-Lite. Prompttokens telkens 12.032, uitvoertokens 842 tot 1.473, `finishReason` altijd `STOP`. In productie zijn die velden er niet, want er kwam geen respons.

## Timeout-architectuur, met de echte constanten

`GEMINI_TIMEOUT_MS` 50.000 (deadline plus abort), `GEMINI_ATTEMPT_TIMEOUT_MS` 40.000, `GEMINI_RETRY_MIN_REMAINING_MS` 12.000, `GEMINI_TRANSIENT_BACKOFF_MS` 1.500, `GEMINI_MAX_ATTEMPTS` 3, route `maxDuration` 60.

Een modelwissel gebeurt alleen bij een transiente fout of een 404 én als `deadline - now >= 13.500 ms`. Een abort komt in `analyzeLegalDocument` vóór die tak en gooit direct `AiTimeoutError`. Twee redenen dus waarom een timeout nooit tot een fallback leidt: de code classificeert hem niet als transient, en na 40 seconden resteren er 10 seconden, minder dan de vereiste 13,5.

| Scenario | Fallback? | Waarom |
|---|---|---|
| Primair antwoordt < 40 s | niet nodig | succes |
| Primair 503 op t | ja als t ≤ 36,5 s | fallback krijgt min(40, 50 − t − 1,5) s |
| Primair 429 op t | ja, zelfde grens | zelfde tak |
| Primair 404 op t | ja, zelfde grens | `isModelGoneError` |
| Primair timeout op 40 s | **nee** | abort-tak; en 10 s < 13,5 s |
| Hypothetisch: timeout op 25 s | ja, mits als transient behandeld | fallback krijgt 23,5 s, totaal maximaal 50 s |
| Hypothetisch: timeout op 30 s | ja, mits als transient behandeld | fallback krijgt 18,5 s |
| Hypothetisch: timeout op 36,6 s | nee | 13,4 s < 13,5 s |

Boven op het interne budget komt circa 4 seconden voorwerk en het nawerk binnen dezelfde functie (tokenverrekening, `AiUsageLog`, cache, guards, `Review` plus `ReviewInput`). Bij een antwoord op 49 seconden blijft er van `maxDuration` 60 nog circa 7 seconden over voor dat nawerk. Dat de functie 44 seconden mocht draaien is bewezen; dat 60 seconden is toegestaan niet.

## Kosten

De SDK-documentatie is expliciet: `AbortSignal` is client-side, annuleert de operatie bij Google niet en het verbruik kan gewoon in rekening worden gebracht. Wij loggen bij een timeout niets, dus als Google de generatie heeft afgemaakt is dat verbruik bij ons onzichtbaar. **Of er tokens zijn verwerkt en gefactureerd is met de huidige logging niet vast te stellen.** Een fallback ná een timeout zou betekenen dat één klantreview twee volledige generaties kan kosten, waarvan de eerste onzichtbaar blijft. Dat is nu onmogelijk, maar het is precies het risico van optie B.

## Wat bewezen is en wat niet

Bewezen: de call ging naar `gemini-3.5-flash`, één poging, geen antwoord binnen 40 seconden, 504, geen halve opslag, geen `AiUsageLog`, geen fallback, geen tweede request. Lokaal deed hetzelfde model hetzelfde werk in 6,6 seconden.

Niet bewezen: of het model traag was of helemaal niets stuurde, hoeveel thinking-tokens er zijn gebruikt, of Google de generatie heeft afgerond en gefactureerd, of dit een eenmalige uitschieter is, en of het verschil aan de regio `iad1` of aan het moment ligt. Eén productie-observatie tegenover drie lokale is te weinig voor een conclusie.

Plausibel maar onbewezen: capaciteitsdruk bij Google (op 21 september gaven het alias en `gemini-3.7-flash` 503 op vijf respectievelijk drie grote requests) en een thinking-uitloop bij 12.000 invoertokens. Onwaarschijnlijk: de 39 tekens verschil in documentlengte, het andere type-label, of netwerklatentie vanuit `iad1` als verklaring voor tientallen seconden.

## Opties, zonder keuze

**A. Timeout verhogen.** Per poging naar bijvoorbeeld 55 s en de deadline mee, met `maxDuration` naar 300 (Fluid Compute). Werkt als het model traag maar niet dood is; kost de klant tot een minuut wachten, en bij een echt hangende call groeit de rekening. Geen kwaliteitsrisico, geen dubbele kosten.

**B. Primaire timeout verkorten en bij timeout wél omschakelen.** Bijvoorbeeld 25 s primair, dan fallback met 23,5 s. Vangt precies dit geval; risico is dubbele kosten (de eerste generatie loopt bij Google door) en een tweede model dat óók traag is, waarna de klant na 50 s alsnog een fout ziet. Kwaliteit blijft gelijk, beide modellen zijn Flash.

**C. Timeout verhogen en fallback alleen bij HTTP-fouten laten (huidig gedrag plus meer tijd).** Eenvoudigst, geen dubbele kosten, maar een trage primaire blijft een fout voor de klant, alleen later.

**D. Ander primair model.** Bijvoorbeeld Flash-Lite primair (lokaal 3,5 s) of een andere Flash-versie. Sneller en goedkoper, maar Flash-Lite leverde in de lokale meting één bevinding tegen twee of drie bij Flash, dus dit raakt de juridische kern en gaat in tegen besluit 3.

**E. Uitvoer of thinking beperken.** `maxOutputTokens` omlaag of `thinkingLevel` uit. Verkort de generatietijd, maar de eerdere probe liet zien dat `thinkingBudget: 0` door dit model werd genegeerd en dat een te krappe cap een leeg antwoord met `MAX_TOKENS` oplevert. Direct kwaliteitsrisico.

**F. Combinatie.** Bijvoorbeeld C plus een zichtbare voortgangsmelding in de UI, of B met een harde regel dat na een timeout niet op hetzelfde model wordt teruggevallen. Meer bewegende delen, meer testwerk.

Eerste ontbrekende meting vóór welke keuze dan ook: een tweede productie-run. Die scheidt "uitschieter" van "structureel" en kost één review.

Gerelateerd: [[ai-review-v2-fase1-2026-09-21]], [[ai-review-v2-fase1-fixes-2026-09-21]].

## Tweede productie-run, 22 september 13:54

Zelfde document (42.135 tekens), zelfde type, zelfde knop, geen wijziging aan code of omgeving. Uitkomst: **geen timeout maar drie keer 503 "high demand" achter elkaar**, in 11,5 seconden.

- 13:54:36,2 poging 1 `gemini-3.5-flash` → 503, keten schakelt naar `gemini-flash-latest`
- 13:54:38,9 poging 2 `gemini-flash-latest` → 503, keten schakelt terug naar `gemini-3.5-flash`
- 13:54:41,2 poging 3 `gemini-3.5-flash` → 503, keten op, `AI-analyse is mislukt.`
- HTTP 500, de klant ziet "Interne serverfout"

De keten werkte dus mechanisch precies zoals ontworpen (twee modelwissels, backoff van 1,5 seconde, drie pogingen binnen het budget), maar elk model in de keten was overbelast. Opnieuw nul rijen in `Review`, `ReviewInput` en `AiUsageLog`; de documenttekst bleef in het scherm staan.

Twee productiefouten met twee verschillende oorzaken aan dezelfde kant: run 1 geen antwoord binnen 40 seconden, run 2 driemaal capaciteitsweigering. Gisteren beantwoordde `gemini-3.5-flash` hetzelfde werk nog drie van drie keer; vandaag weigert hij. De beschikbaarheid van de Flash-familie is dus geen constante, en dat is wat de release blokkeert, niet een fout in onze pijplijn.

Twee dingen die deze run blootlegt en die los staan van capaciteit:

1. **De foutmelding is verkeerd getypeerd.** Als de hele keten faalt gooit `analyzeLegalDocument` een kale `Error('AI-analyse is mislukt.')`. Dat is geen `AppError`, dus `handleApiError` maskeert de tekst in productie en de klant leest "Interne serverfout" in plaats van een uitlegbare melding. Een 503 van de leverancier is geen interne serverfout.
2. **Admin-tellers lopen op zonder refund.** Het account dat de runs deed ging van `aiUsageCount` 12 naar 13 en van 53.616 naar 80.534 tokens (26.918 gereserveerd, precies `tekens/4 + 16.384`), terwijl er geen enkele modelrespons was. Voor onbeperkte accounts wordt niet terugbetaald, bestaand gedrag uit V1, maar het maakt admin-tellers onbruikbaar als maatstaf.


## Beide nevenbevindingen teruggevonden in de code (22 september, tweede sessie)

Read-only gecontroleerd in de werkboom op `20f6891`, repo `OneDrive/Bureaublad/Project Compliance & automatic document generator/zekerwet`. Beide punten zijn geen vermoeden meer, de regels staan er.

**De kale fout staat op `src/lib/gemini.ts:394`.** Daar eindigt `analyzeLegalDocument` met `throw new Error('AI-analyse is mislukt.')` terwijl de regel eronder wél een getypeerde `AiOutputError` gooit. `handleApiError` in `src/lib/api-response.ts:30` typeert alleen op `AppError` en `ZodError`, dus alles wat geen van beide is valt door naar een generieke 500. `AiOutputError` en `AiTimeoutError` staan al netjes als `AppError` in `src/lib/gemini.ts:53` en `:62`, dus een derde klasse ernaast (leveranciersweigering, HTTP 503, eigen code) is drie regels werk. Dit raakt alleen een uitgeputte 503-keten, niet de timeout: die gooit al `AiTimeoutError` op `:351`.

**De refund ontbreekt niet, hij staat onder een voorwaarde die de reservering niet heeft.** In `src/services/ai-review.service.ts` reserveert stap 6 beide tellers op álle paden: `aiUsageCount` via `updateMany` met guard als er een limiet is (`:368`) en via een kale `update` als het account onbeperkt is (`:379`), en `aiTokensUsed` op dezelfde manier op `:386` en `:407`. De refund in het catch-blok op `:499` doet dat niet: het teruggeven van `aiUsageCount` hangt aan `requestLimit < AI_UNLIMITED` en het teruggeven van `aiTokensUsed` aan `Number.isFinite(tokenBudget)`. Een onbeperkt account wordt dus wel afgeschreven en nooit teruggeboekt. Dat verklaart precies wat we zagen: 12 naar 13 reviews en 26.918 tokens erbij zonder één modelrespons. Dezelfde asymmetrie zit in de deelrefund op `:394`.

Dat is dus niet "bestaand V1-gedrag voor onbeperkte accounts", het is een verschil tussen twee takken die gelijk horen te lopen. Voor een betalend account met een eindige limiet werkt de refund wel, dus de klantimpact is nul en de admin-impact is dat de tellers als meetinstrument onbruikbaar zijn.

**Geen bestaande probe-route.** `/api/admin/ai-health` (`src/app/api/admin/ai-health/route.ts`) is de dagelijkse kostendigest via Vercel Cron, niet iets dat een model aanroept. Wel levert hij het patroon voor een tijdelijke probe vanuit `iad1`: Bearer-token tegen `AI_HEALTH_CRON_SECRET`, vergeleken met `constantTimeEqual` op `:26`.

Gerelateerd: [[ai-review-v2-fase1-2026-09-21]], [[ai-review-v2-fase1-fixes-2026-09-21]].

## Providerprobe lokaal, 22 september 14:29 tot 14:32 (derde sessie)

Vier rauwe calls vanaf de laptop in Nederland, exact dezelfde payload als productie (42.135 tekens, type samenwerking, `thinkingLevel` low, 16.384 uitvoertokens, `responseSchema` aan), geen retries en geen keten. Uitkomst: **nul van vier geslaagd**. Twee keer een client-timeout op 40 seconden (`gemini-3.5-flash`), twee keer 503 "high demand" (`gemini-3.5-flash` na 7,8 s en `gemini-flash-latest` na 2,2 s). Rapport in `.smoke/provider-probe-1790087539985.json`.

Daarmee vervalt de regiohypothese: het is geen verschil tussen `iad1` en Nederland, geen routing en geen projectinstelling. Een tijdelijke probe-route vanuit `iad1` hoeft dus niet gebouwd te worden; hij zou hetzelfde meten.

Een kleine controlemeting met een minimale prompt (vijf woorden, 50 uitvoertokens) op dezelfde modellen gaf twee van vier keer succes, en dan nog traag: 33,6 s en 9,8 s, tegen 1 tot 3 s eerder deze week. Het is dus niet zo dat grote requests worden geweigerd en kleine niet; de hele Flash-familie reageert op dit moment traag en wisselvallig.

## Twee nevenbevindingen gefixt in de werkboom (niet gedeployd)

`src/lib/gemini.ts`: nieuwe `AiProviderUnavailableError extends AppError`, HTTP 503, code `AI_PROVIDER_UNAVAILABLE`, gebruikt op de plek waar eerder een kale `Error` stond. De timeout blijft `AiTimeoutError`. `src/services/ai-review.service.ts`: beide refunds (het catch-blok en de deelrefund bij een vol tokenbudget) zijn nu onvoorwaardelijk, net als de reserveringen. Nieuw testbestand `src/services/ai-review.service.test.ts` met vijf tests en een gemockte Prisma: beide tellers staan na een mislukte run weer op nul, voor een onbeperkt account én voor een plan met limiet, bij zowel een 503-keten als een timeout, en de reservering vóór de modelcall wordt zichtbaar gemaakt. 245 tests groen, `tsc`, lint en build schoon.

Nog niet aangeraakt en bewust gemeld: de tokenverrekening ná een geslaagde review (`ai-review.service.ts:433`) hangt óók aan `Number.isFinite(tokenBudget)`. Voor een onbeperkt account blijft daardoor de schatting staan in plaats van het werkelijke verbruik. Zelfde vorm als de refundfout, buiten de opdracht gelaten.

Rechtzetten van de database is nog niet gedaan. Stand nu: `acerdogan@outlook.com` (admin) `aiUsageCount` 13 en `aiTokensUsed` 80.534, waarvan twee reviews en 53.836 tokens van de twee mislukte productieruns van vandaag. Voor de werking maakt het niets uit (onbeperkt account, `aiUsageResetAt` leeg), alleen de tellers zijn als meetinstrument vervuild. Klantaccounts zijn niet geraakt.

## Tier, voorwaarden en de privacyverklaring (22 september, vierde sessie)

Aanleiding: de zin op `src/app/privacy/page.tsx:145` over "Google AI / Vertex" met "Gebruikt in no-training-mode". De vraag was of die waar is op het gratis tier.

**Welke API.** De code gebruikt de Gemini Developer API, niet Vertex AI: SDK `@google/generative-ai` met basis-URL `https://generativelanguage.googleapis.com` (`node_modules/@google/generative-ai/dist/index.js:307`), en de foutmeldingen in de Vercel-logs noemen diezelfde host. "Google AI / Vertex" in de privacyverklaring is dus onnauwkeurig; Vertex wordt nergens aangeroepen.

**Wat Google's voorwaarden zeggen** (https://ai.google.dev/gemini-api/terms, ingangsdatum 23 maart 2026). Onbetaald: "gebruikt Google de content die u indient bij de Services en eventuele gegenereerde reacties om Google-producten en -services en technologieën voor machine learning te leveren, te verbeteren en te ontwikkelen", met "Menselijke reviewers kunnen uw API-input en -output lezen, annoteren en verwerken" en "Dien geen gevoelige, vertrouwelijke of persoonlijke gegevens in bij de Onbetaalde Services." Maar daarna staat de uitzondering die alles kantelt: "If you are located in the European Economic Area, Switzerland, or the United Kingdom, the terms under 'How Google uses Your Data' in 'Paid Services' apply to all Services, including Google AI Studio and unpaid quota in the Gemini API, even though they are offered free of charge." En die betaalde bepaling luidt: "Google doesn't use your prompts (including associated system instructions, cached content, and files such as images, videos, or documents) or responses to improve our products, and will process your prompts and responses in accordance with the Data Processing Addendum for Products Where Google is a Data Processor."

**Oordeel over regel 145.** De no-training-belofte is waar zolang [[ZekerWet]] in de EER is gevestigd, ook op onbetaald quotum. Geen tweede release-blocker dus. Wel twee correcties nodig in de tekst: "Vertex" schrappen (wij gebruiken die dienst niet) en de grond noemen (de EER-uitzondering plus het verwerkersaddendum), zodat de belofte navolgbaar is in plaats van een kale bewering.

**Wat wél een probleem is, uit dezelfde voorwaarden:** "You may use only Paid Services when making API Clients available to users in the European Economic Area, Switzerland, or the United Kingdom." Een productiedienst voor Nederlandse klanten op onbetaald quotum is in strijd met die gebruiksbeperking, los van datagebruik. Dat is een tweede, onafhankelijke reden om billing aan te zetten.

**Tier niet read-only vast te stellen.** De API geeft geen tierveld: `serviceTier` staat op `standard`, maar de referentie (https://ai.google.dev/api/generate-content) definieert `unspecified` als "Default service tier, which is standard", dus dat zegt niets. Een 429 met `FreeTier` in de quotanaam zou bewijs zijn, maar we kregen alleen 503's. Alleen [[Ali Can]] kan het zien in AI Studio onder Billing of API keys, kolom Billing Tier.

## Derde asymmetrie en herstelscript (zelfde sessie)

`ai-review.service.ts` verrekent de tokens na een geslaagde review nu ook onvoorwaardelijk, zodat een onbeperkt account niet op de schatting blijft staan. Twee extra tests dekken dat af (onbeperkt en Business). Klanttekst bij een leveranciersweigering is variant 2 geworden, met de term die de UI zelf gebruikt ("AI-reviews", niet "reviewtegoed").

Herstelscript `scripts/fix-ai-counters.mjs`: geen identifiers in het bestand, account en doelwaarden als argumenten, dry-run standaard, weigert te schrijven bij meer dan één treffer, maskeert het adres in de uitvoer. Dry-run bevestigt één rij: `aiUsageCount` 13 naar 11, `aiTokensUsed` 80.534 naar 26.698. Nog niet toegepast.

## Kostenplafonds vóór billing (22 september, vijfde sessie)

Tellers van het adminaccount rechtgezet met `--apply`: `aiUsageCount` 13 naar 11, `aiTokensUsed` 80.534 naar 26.698, één rij geraakt, in de database bevestigd (`updatedAt` 15:08). Klantaccounts ongemoeid; [[Yvonne Heiligers]] staat onveranderd op 10 en 33.726.

Kosten per review op Flash, met de gecorrigeerde prijsconstanten (€0,94 per miljoen invoertokens, €7,50 per miljoen uitvoertokens): een typische review van 42.000 tekens kost **2,2 eurocent**, een maximale review van 200.000 tekens met volle uitvoer **17 eurocent**. Dat tweede getal is het plafond per call.

Maximale blootstelling per plan per maand, met het tokenbudget als bindende grens: Essential 1 review, hooguit **€0,17**. Business 10 reviews, hooguit **€1,70**, tegenover 49,99 omzet, dus 3,4 procent van de prijs in het slechtste geval. Enterprise loopt tegen het tokenbudget van 5.000.000 aan: 75 volle reviews, hooguit **€12,76**.

De huidige dagcap van 500 eurocent laat 29 maximale of 221 typische reviews per dag toe. Met één betalende klant die tien reviews per maand mag, is dat tien keer het maximaal denkbare maandverbruik van het hele klantenbestand, per dag. Voorstel: **dagcap 50 eurocent, maandcap 1.500 eurocent laten staan**. Bij 50 cent per dag passen nog altijd 2 maximale of 22 typische reviews, ruim boven wat één Business-klant in een hele maand mag, en de rem grijpt dus alleen in bij een lek of een aanval.

Wat er gebeurt als de cap geraakt wordt: `assertGlobalSpendUnderCap` gooit een `ServiceUnavailableError` (HTTP 503, code `GLOBAL_AI_LIMIT_REACHED`) met de tekst "AI is tijdelijk uitgeschakeld vanwege bescherming. Probeer het later opnieuw." Dat is een getypeerde `AppError`, dus de klant ziet die zin, geen harde fout. De UI toont hem als gewone foutmelding, want de upgrade-tekst verschijnt alleen bij "limiet" of "budget" in de melding. Opvallend: de cap wordt gecontroleerd vóór quota en cache, dus ook een cache-hit die niets kost wordt geweigerd zodra de cap vol is.

Wie kan er zonder abonnement reviewen? Niemand, behalve admins. `requestLimit` wordt 0 zodra `stripePriceId` geen geldig plan is, en de pre-flight gooit dan meteen `AI_LIMIT_REACHED` ("Upgrade je abonnement voor meer scans"), vóór enige Gemini-call. Een proefabonnement telt wel mee: `stripe/sync` accepteert ook status `trialing` en zet dan het echte plan, dus een trialgebruiker krijgt de limieten van dat plan. Maximale kosten van een gratis gebruiker zijn dus nul; het is de plangrens die dat tegenhoudt, niet de rate limit. Die rate limit (5 reviews per minuut per gebruiker, fail-closed) is de tweede rem, en de dagcap de derde.

## Prijscontrole en dagcap (22 september, zesde sessie)

De prijsconstanten klopten niet. Gecontroleerd op https://ai.google.dev/gemini-api/docs/pricing op 22 september 2026, betaald tier per miljoen tokens: **Gemini 3.5 Flash $1,50 invoer en $9,00 uitvoer**, Flash-Lite $0,30 en $2,50. In de code stond voor Flash €0,94 en €7,50, dus de invoer werd 37 procent en de uitvoer 17 procent te laag geprijsd. Elke plafondberekening stond daarmee te laag.

Belangrijk detail uit dezelfde tabel: de uitvoerprijs is inclusief denktokens. Onze prijsberekening gebruikt `candidatesTokenCount`, en `thoughtsTokenCount` rapporteert Google bij `thinkingLevel low` niet apart; als denktokens buiten dat getal vallen, tellen we ze niet mee. Niet aangeraakt, wel gemeld.

Nieuwe constanten: Flash 1.500.000 en 9.000.000 micros, Flash-Lite 300.000 en 2.500.000. Eén dollar wordt als één euro geteld: de euro is meer waard, dus dat is de veilige kant en het scheelt een koersfeed.

Herberekening met de juiste prijzen: typische review van 42.000 tekens **3,2 eurocent** (was 2,2), maximale review **22 eurocent** (was 17). Per plan per maand: Essential hooguit €0,22, Business hooguit €2,22 (4,4 procent van 49,99), Enterprise hooguit €16,68 tegen het tokenbudget aan. De dagcap van 50 eurocent laat nu 2 maximale of 15 typische reviews per dag toe, nog steeds ruim boven wat één Business-klant in een hele maand mag. Het voorstel blijft dus staan.

Doorgevoerd in de werkboom: dagcap-default van 500 naar 50 eurocent (maandcap blijft 1.500), prijsconstanten gecorrigeerd, en de spend-cap verhuisd van de route naar de service, ná de cachelookup. Een herhaalde review die uit de cache komt kost niets en wordt nu niet meer geweigerd bij een volle cap; een nieuwe review wordt nog steeds geweigerd vóór enige modelcall. Drie tests dekken dat af, plus negen in `cost-meter.test.ts`. 250 tests groen, `tsc`, lint en build schoon.

Let op bij het toepassen: **Vercel heeft `AI_DAILY_CAP_EUR_CENTS` als eigen omgevingsvariabele** (productie en preview). Die gaat vóór de code-default, dus de 50 cent gaat pas in als [[Ali Can]] die variabele in Vercel aanpast; een deploy alleen is niet genoeg.

## Denktokens en omgevingsvariabelen (22 september, zevende sessie)

**Denktokens gemeten, niet aangenomen.** In de vier lokale reviewruns van 21 september is `totalTokenCount` exact gelijk aan `promptTokenCount` plus `candidatesTokenCount`: 12.032 + 842 = 12.874, 12.032 + 1.188 = 13.220, 12.032 + 1.323 = 13.355, 12.032 + 1.473 = 13.505. Gat nul, `thoughtsTokenCount` niet gerapporteerd. In die runs zijn we dus niets misgelopen.

Maar bij de kale probes van vandaag lag het anders: prompt 7, `thoughtsTokenCount` 47, totaal 54, en `candidatesTokenCount` ontbrak volledig. Denktokens tellen dus wél mee in het totaal en niet in candidates, en Google prijst uitvoer inclusief denktokens. Prijzen op candidates alleen kan daardoor nul opleveren voor een call die wel degelijk kost.

Opgelost met `billedOutputTokens()` in `cost-meter.ts`: de uitvoer wordt `max(candidates, totaal − prompt, 0)`. Dat is gelijk aan candidates in alle vier gemeten reviews, vangt de denktokens waar ze buiten candidates vallen, en blijft veilig als `totalTokenCount` ontbreekt. `AiUsageLog` blijft de rauwe API-getallen bewaren; alleen de prijsberekening gebruikt de gecorrigeerde uitvoer. Drie tests leggen dit vast op de echte meetwaarden. 253 tests groen.

**AI-variabelen in Vercel** (productie en preview, waarden niet leesbaar want type `sensitive`): `AI_DAILY_CAP_EUR_CENTS`, `AI_MONTHLY_CAP_EUR_CENTS`, `AI_HEALTH_CRON_SECRET`. Daarnaast `GOOGLE_AI_API_KEY` (type `encrypted`, ook development). Niet aanwezig: `AI_REVIEW_MODEL`, `AI_REVIEW_FALLBACK_MODELS`, `AI_STRUCTURE_MODEL`, alle `AI_PRICE_*` en `AI_HEALTH_DIGEST_TO`; daarvoor gelden dus de code-defaults. Of de twee capwaarden afwijken van de nieuwe defaults is niet te zien: Vercel geeft de waarde van een `sensitive` variabele aan niemand terug, ook niet in het dashboard. Ze kunnen alleen worden overschreven.

## Twee correcties op de caps (22 september, achtste sessie)

[[Ali Can]] vond twee fouten, allebei terecht en allebei in de code nagekeken.

**De maandcap was geen 1.500 maar 15.000 eurocent.** `cost-meter.ts:128` had als default `'15000'`, dus 150 euro per maand. Ik noemde hem twee keer "1.500" en dat klopte niet. Met een dagcap van 50 cent is het maximum 31 keer 0,50 is 15,50 euro per maand, dus een maandcap van 150 euro kan per definitie nooit worden bereikt: een dood getal, geen tweede slot.

Nieuwe verhouding, beide caps op hetzelfde verhaal: **dagcap 50 eurocent is één slechte dag, maandcap 500 eurocent is tien slechte dagen.** De maandcap grijpt nu in op een lek dat onder de dagcap blijft maar dag na dag doorloopt, en 31 dagen op dagcapniveau zou er ruim overheen gaan. Verwacht legitiem verbruik is circa 32 cent per maand voor één Business-klant, dus vijftien keer marge. Bij groei schuift de verhouding 1 op 10 mee.

**De kostenmail rekende met de oude cap.** `ai-health/route.ts:120` las zelf `AI_DAILY_CAP_EUR_CENTS ?? '500'`, terwijl `cost-meter.ts` op `'50'` stond. Bij een volle cap zou de dagelijkse mail 10 procent benutting melden. De digest gebruikt nu `dailyCapMicros()` uit `cost-meter.ts`, dezelfde functie als de circuit breaker, dus de mail kan niet meer tegen een andere cap rekenen dan degene die verzoeken weigert.

**Grep over het hele project naar eigen defaults voor `AI_DAILY_CAP_EUR_CENTS`, `AI_MONTHLY_CAP_EUR_CENTS` en `AI_PRICE_*`:** buiten `cost-meter.ts` staat er nu geen enkele meer. Gevonden en opgeruimd: de ene in `ai-health/route.ts`. Verder alleen verwijzingen zonder eigen waarde: `src/emails/AiCostDigest.tsx:139` noemt de variabelenaam in de mailtekst, en `cost-meter.test.ts` zet ze in tests. 254 tests groen, `tsc`, lint en build schoon.

## Wanneer de caps gaan knellen (bijgewerkt 23 september met gemeten kosten)

De cijfers van de negende sessie waren schattingen op een volle uitvoer van 16.384 tokens. Sinds 23 september zijn er zes geslaagde calls gemeten en die liggen er ver onder, omdat het model in de praktijk ruim drieduizend uitvoertokens gebruikt in plaats van zestienduizend. Beide kolommen staan hieronder naast elkaar. **De caps blijven op het ergste geval gebaseerd**, want een review die wél de volle uitvoer opmaakt is mogelijk en een plafond hoort tegen het mogelijke te beschermen, niet tegen het gemiddelde.

| Per review | Gemeten (23 september) | Ergste geval (volle uitvoer) |
|---|---|---|
| Document van 42.000 tekens | 4,1 tot 4,9 cent (n=4) | circa 4,9 cent |
| Document van 200.000 tekens, de invoergrens | 10,8 tot 10,9 cent (n=2) | 22,25 cent |

Wat een klant volgens zijn plan in een maand mag opmaken, beide kolommen met maximale documenten:

| Plan | Reviews | Gemeten | Ergste geval |
|---|---|---|---|
| Essential | 1 | 11 cent | 22 cent |
| Business | 10 | 1,09 euro | 2,23 euro |
| Enterprise | 75, dan is het tokenbudget op | 8,17 euro | 16,68 euro |

Met de vaste caps uit de negende sessie (dagcap 50 cent, maandcap 5 euro) knelt het ergste geval vanaf:

- **3 Business-klanten** die hun tegoed volledig met maximale documenten benutten: samen 6,68 euro, dus boven de maandcap. Bij twee klanten zit je met 4,45 euro net eronder. Gemeten zou dit pas bij de vijfde klant knellen (5,45 euro), maar daar sturen we niet op.
- **1 Enterprise-klant**: 16,68 euro recht tegenover 5 euro cap, afgekapt op ongeveer een derde van zijn tegoed. Gemeten 8,17 euro, nog altijd ruim boven de cap.
- **23 Essential-klanten**: 5,12 euro. Tot en met 22 past het. Gemeten zou dat 45 klanten zijn.
- **3 maximale documenten op één dag**, door wie dan ook: 66,8 cent boven de dagcap van 50 cent. Twee stuks (44,5 cent) past net, maar laat die dag 5,5 cent over voor alle andere klanten samen, want de dagcap geldt voor iedereen bij elkaar. Gemeten passen er vier op een dag (43,5 cent).
- Bij **normaal gebruik** (documenten van circa 42.000 tekens) ligt de grens veel verder: ongeveer 15 Business-klanten die hun tien reviews opmaken passen binnen 5 euro per maand.

Kort gezegd: de huidige caps zijn goed voor één of twee betalende klanten. Bij de derde Business-klant, of bij de eerste Enterprise-klant, gaat de beveiliging betalende klanten weigeren. De gemeten cijfers geven daar circa twee keer zoveel ruimte, maar verschuiven het moment niet principieel.

De caps die nu in de werkboom staan (dagcap 334, maandcap 445 eurocent, berekend in de tiende sessie voor één Business-klant) zijn ongewijzigd gelaten.

## Caps voor het huidige bestand, en de cap-alert (22 september, tiende sessie)

**Formule één keer met de hand.** Klantenbestand nu: één Business-abonnement (loopt tot 4 oktober), verder geen betalende plannen. Recht is dus 2,23 euro per maand. Maandcap wordt 2 × 2,23 = 4,45 euro, dagcap wordt de grootste van drie termen: één klantmaand met de helft erbij (2,23 × 1,5 = 3,34), een kwart van de maandcap (1,11) en de vloer van 1 euro, dus 3,34 euro. Afgerond naar boven in eurocenten: **dagcap 334, maandcap 445**. Daarmee kan die ene Business-klant zijn hele maandtegoed op één dag opmaken (2,23 euro) zonder geweigerd te worden, en blijft de maandcap er met 4,45 euro ruim boven.

**Cap-alert gebouwd.** `src/lib/cap-alert.ts` plus `src/emails/AiCapAlert.tsx`: bij de eerste geweigerde review van een kalenderdag gaat één mail naar hetzelfde adres als de kostendigest. Ontdubbeling met `set` en `nx` op `ai:capalert:<datum>` met een TTL tot middernacht, dus hooguit één mail per dag, ongeacht welke cap dichtsloeg. De mail noemt welke cap het was, **welk bedrag die cap op dat moment was** (in euro's én in eurocenten, met de naam van de omgevingsvariabele erbij, zodat je ziet tegen welke grens hij sloot nadat je hem in Vercel hebt bijgesteld), het verbruik met percentage, het aantal betaalde reviews die dag en de drie grootste verbruikers. Fire-and-forget vanuit `assertGlobalSpendUnderCap`, dus de 503 aan de klant wacht er niet op en een mislukte mail verandert een nette weigering niet in een fout. Vijf tests, waaronder dat drie weigeringen op één dag samen één mail geven en dat er zonder Redis niets wordt verstuurd. 259 tests groen.



## Hermeting na Tier 1, 22 september 23:32 tot 23:34 (elfde sessie)

Vier rauwe calls, exact dezelfde opzet als de probe van 14:29: fixture van 42.135 tekens, type samenwerking, drie keer `gemini-3.5-flash` met 30 seconden ertussen en één keer `gemini-flash-latest`, geen retries, geen keten. Rapport in `.smoke/provider-probe-1790112855830.json`.

**Nul van vier geslaagd, met een compleet nieuwe fout: HTTP 402 Payment Required, "Your prepayment credits are depleted."**

| # | Model | Start | Duur | HTTP | Code | finishReason | Prompt | Uitvoer |
|---|---|---|---|---|---|---|---|---|
| 1 | gemini-3.5-flash | 23:32:44 | 214 ms | 402 | Payment Required | geen | geen | geen |
| 2 | gemini-3.5-flash | 23:33:14 | 207 ms | 402 | Payment Required | geen | geen | geen |
| 3 | gemini-3.5-flash | 23:33:44 | 737 ms | 402 | Payment Required | geen | geen | geen |
| 4 | gemini-flash-latest | 23:34:15 | 193 ms | 402 | Payment Required | geen | geen | geen |

Naast de meting van 14:29, dezelfde payload, dezelfde laptop:

| # | Model | 14:29 uitkomst | 23:32 uitkomst |
|---|---|---|---|
| 1 | gemini-3.5-flash | client-timeout op 40 s | 402 in 214 ms |
| 2 | gemini-3.5-flash | client-timeout op 40 s | 402 in 207 ms |
| 3 | gemini-3.5-flash | 503 high demand na 7,8 s | 402 in 737 ms |
| 4 | gemini-flash-latest | 503 high demand na 2,2 s | 402 in 193 ms |

**Wat dit bewijst.** De tierwissel is aangekomen: het foutbeeld is veranderd van "traag en overbelast" naar "je mag niet, want er is geen saldo". Google weigert nu vóór enige generatie, in tweetiende seconde, deterministisch op alle vier de calls. Daarmee is de oorspronkelijke hypothese uit [[google-cloud-billing-zekerwet-2026-09-22]] niet bevestigd en niet weerlegd: we hebben nog geen enkele geslaagde call op betaald tier gezien, dus of de 503's echt door het gratis tier kwamen blijft onbewezen.

**Wat dit níet is.** Dit is geen capaciteitsprobleem bij Google en geen fout in onze pijplijn. Het is de factureringsstand van het project. Het tegoed van €257,47 dat in [[google-cloud-billing-zekerwet-2026-09-22]] staat is blijkbaar geen bruikbaar saldo voor de Gemini-API: de API kijkt naar prepayment-krediet en ziet nul. Te controleren door [[Ali Can]] in `console.cloud.google.com` onder Billing: is het factureringsaccount van het type prepaid, hangt er een geldige betaalmethode aan, en geldt het proeftegoed wel voor deze API. De route uit die notitie blijft: `aistudio.google.com/apikey`, kolom Billing tier.

**Gevolg voor productie, nu.** Op `20f6891` (wat live staat) valt een 402 niet onder `isTransientApiError` en niet onder `isModelGoneError`, dus de keten stopt na één poging en loopt in de kale `throw new Error('AI-analyse is mislukt.')` op `gemini.ts:394`. Elke review op productie faalt dus binnen een seconde met HTTP 500 en de klant leest "Interne serverfout". Met de werkboomversie wordt dat een getypeerde 503 met een leesbare zin, maar die zin luidt "onze AI-leverancier weigert tijdelijk nieuwe aanvragen", en dat is bij een leeg saldo misleidend. Geen van beide is een blokkade voor de release; het is wel een reden om de release niet vrij te geven zolang er geen enkele geslaagde call op betaald tier is.

**Oordeel.** De release blijft BLOCKED, maar om een andere reden dan vanmiddag: niet omdat Google ons weigert wegens drukte, maar omdat er geen werkend betaalkanaal is. Dat is een instelling, geen bouwwerk. Zolang die 402 er staat heeft het geen zin om tijdsbudgetten, `maxDuration` of Fluid Compute aan te passen: er is nog nooit een call op betaald tier gemeten, dus elk getal zou op de metingen van het gratis tier gebaseerd zijn.


## Hermeting na de prepaid wallet, 23 september 00:24 tot 00:26 (twaalfde sessie)

[[Ali Can]] heeft de prepaid wallet in AI Studio ingericht en met €5 gevuld, auto-reload aan. Dat was de oorzaak van de 402: de Gemini-API betaalt uit die wallet en niet uit Cloud Billing, en het Cloud-proeftegoed geldt er niet voor. Het project hangt daarbij aan een nieuw factureringsaccount `01D8AF-E5B96A-37A00E`; de API-sleutel is niet veranderd. Zie [[google-cloud-billing-zekerwet-2026-09-22]].

Zelfde probe, derde keer: fixture van 42.135 tekens, type samenwerking, drie keer `gemini-3.5-flash` met 30 seconden ertussen, daarna `gemini-flash-latest`, geen retries en geen keten. Rapport in `.smoke/provider-probe-1790115992931.json`.

**Vier van vier geslaagd.**

| # | Model | Start | Duur | HTTP | finishReason | Prompt | Uitvoer | Denk | Totaal | Modelversie |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | gemini-3.5-flash | 00:24:14 | 14.921 ms | 200 | STOP | 12.037 | 1.452 | 1.984 | 15.473 | gemini-3.5-flash |
| 2 | gemini-3.5-flash | 00:24:59 | 11.941 ms | 200 | STOP | 12.037 | 1.457 | 1.088 | 14.582 | gemini-3.5-flash |
| 3 | gemini-3.5-flash | 00:25:41 | 12.313 ms | 200 | STOP | 12.037 | 1.328 | 1.430 | 14.795 | gemini-3.5-flash |
| 4 | gemini-flash-latest | 00:26:24 | 8.744 ms | 200 | STOP | 12.037 | 2.610 | geen | 14.647 | **gemini-3.8-flash** |

Latency over alle vier: p50 12.127 ms, max 14.921 ms, min 8.744 ms. Alleen de drie op `gemini-3.5-flash`: p50 12.313 ms, max 14.921 ms.

De drie meetpunten naast elkaar, zelfde payload, zelfde laptop:

| # | 14:29 (gratis tier) | 23:32 (tier 1, lege wallet) | 00:24 (wallet gevuld) |
|---|---|---|---|
| 1 | timeout op 40 s | 402 in 214 ms | **200 in 14,9 s** |
| 2 | timeout op 40 s | 402 in 207 ms | **200 in 11,9 s** |
| 3 | 503 high demand na 7,8 s | 402 in 737 ms | **200 in 12,3 s** |
| 4 | 503 high demand na 2,2 s | 402 in 193 ms | **200 in 8,7 s** |

**De hypothese is bevestigd.** Nul van vier op gratis tier, vier van vier met een gevulde wallet, zelfde code en zelfde payload. De 503's en de timeouts van 22 september kwamen van de tierstand, niet van onze pijplijn en niet van capaciteitsdruk bij Google. Kanttekening: n is vier en de metingen liggen binnen één uur, dus dit zegt niets over beschikbaarheid over langere tijd.

**Twee dingen die deze meting nieuw blootlegt.**

Denktokens zitten er nu wél in en ze zijn groot: 1.088 tot 1.984 per call, en ze vallen **buiten** `candidatesTokenCount`. In de runs van 21 september was het gat tussen totaal en prompt plus candidates nog nul; nu is het dat niet meer. `billedOutputTokens()` uit de zevende sessie vangt dit precies op: bij call 1 rekent hij 3.436 uitvoertokens in plaats van 1.452. Zonder die correctie zou [[ZekerWet]] ruim de helft van de uitvoerkosten niet zien. De fix is daarmee niet langer theoretisch maar op echte meetwaarden bewezen.

Daardoor klopt het kostenmodel niet meer. Een typische review van 42.000 tekens kost gemeten **4,1 tot 4,9 eurocent**, niet de 3,15 cent uit de negende sessie, want die rekende met candidates alleen. Dat is circa veertig procent hoger. Voor de caps verandert er niets wezenlijks: één Business-klant met tien reviews komt op circa 44 cent per maand tegen een dagcap van 334 en een maandcap van 445 eurocent. De getallen in "Wanneer de caps gaan knellen" zijn wel veertig procent optimistisch en moeten bij de eerstvolgende capherziening opnieuw door de formule.

`gemini-flash-latest` wijst inmiddels naar **gemini-3.8-flash**, niet meer naar 3.7. Het alias is dus opnieuw verschoven. Hij was ook de snelste van de vier (8,7 s) maar gaf de meeste uitvoertokens (2.610) en rapporteerde geen denktokens apart.

## Voorstel tijdsbudget, op deze getallen (niet toegepast)

Gemeten maximum is 14,9 seconden tegen een per-poging-budget van 40 seconden: bijna drie keer marge. Het voorstel met het minste bouwwerk is daarom **niets veranderen aan `maxDuration` en Fluid Compute niet aanzetten**. Reken het ergste geval na met de huidige constanten: voorwerk 3,7 s, poging 1 tot 40 s, backoff 1,5 s, poging 2 tot wat er van de deadline van 50 s over is, nawerk circa 2 s. Dat past binnen `maxDuration` 60 en ruim binnen de 90 seconden die [[Ali Can]] als grens stelde. Kosten per review blijven met 4,9 eurocent ruim onder de tien cent.

Eén verfijning is wel te verdedigen en kost één constante: **`GEMINI_ATTEMPT_TIMEOUT_MS` van 40.000 naar 30.000**. Nu kan een timeout per definitie nooit een fallback starten, want na 40 seconden resteren er 10 en de keten eist er 13,5. Bij 30 seconden resteren er 20 en schakelt hij wel om, binnen dezelfde deadline van 50 seconden en zonder aan `maxDuration` te komen. Dertig seconden is nog altijd twee keer het gemeten maximum. Het risico is een trage maar gezonde call die op 31 seconden wordt afgekapt; bij p50 12,1 s en max 14,9 s is dat onwaarschijnlijk, maar met n is vier niet uitgesloten.


## 402 krijgt een eigen fouttype en een alertmail (23 september, dertiende sessie)

Gebouwd in de werkboom op verzoek van [[Ali Can]], niets gecommit. Aanleiding: de wallet kan opnieuw leeglopen, en dan mag een 402 niet stil in een generieke 500 verdwijnen.

`AiWalletEmptyError` in `src/lib/gemini.ts`, HTTP 503, code `AI_WALLET_EMPTY`, met precies de zin die de klant hoort te lezen: "De AI-review is tijdelijk niet beschikbaar. Je tegoed wordt niet aangesproken." Bewust een aparte klasse naast `AiProviderUnavailableError`. Een 503 is Google die het druk heeft en gaat vanzelf over; een lege wallet gaat alleen over als iemand hem vult. Nieuwe classifier `isWalletEmptyError` (`[402 `, `prepayment credits`, `payment required`) wordt vóór de transiënte en de gone-tak gecontroleerd en gooit meteen, dus geen retry, geen fallback-keten en geen backoff. Dat is geen zuinigheid maar logica: elk model in de keten rekent af uit dezelfde wallet en antwoordt dus hetzelfde.

`src/lib/wallet-alert.ts` plus `src/emails/AiWalletAlert.tsx`, gebouwd naar hetzelfde patroon als de cap-alert: één mail per kalenderdag, geclaimd met `set nx` op `ai:walletalert:<datum>` met een TTL tot middernacht, fire-and-forget, gaat naar `AI_HEALTH_DIGEST_TO` met `EMAIL_SUPPORT` als terugval. Onderwerp "[ZekerWet] Gemini-wallet leeg". In de mail staat de directe link naar de wallet van het factureringsaccount dat de sleutel betaalt (`aistudio.google.com/billing?billing=01D8AF-E5B96A-37A00E&project=gen-lang-client-0268320963`) en de regel "Inloggen als ossbjk". Die link en dat account staan hard in de code, niet in een omgevingsvariabele: dit is de ene mail die verstuurd wordt wanneer niemand meer kan reviewen, dus hij mag niet afhangen van een variabele die zelf kan ontbreken. Het zijn configuratiegegevens, geen geheimen.

De alert vuurt vanuit het catch-blok van `reviewDocument`, ná de refund. Die volgorde is bewust: de tellers van de klant wegen zwaarder dan de mail, en `notifyWalletEmpty` gooit nooit.

Twaalf tests erbij, nu 271 groen en 2 overgeslagen. Zes in `wallet-alert.test.ts` (één mail per dag ongeacht het aantal weigeringen, eigen Redis-sleutel naast die van de cap-alert, TTL tot middernacht, onderwerp, de link plus het inlogaccount in de mailtekst, en zwijgen zonder Redis in plaats van mailen bij elke weigering). Zes in `ai-review.service.test.ts`: eigen 503 met de juiste klanttekst en uitdrukkelijk zónder het woord "leverancier", precies één modelcall dus geen keten, refund van beide tellers op een onbeperkt account én op een plan met limiet, wel een alert bij 402 en géén alert bij een 503. `tsc` schoon, lint zonder nieuwe meldingen, `next build` exit 0.


## Probe op de invoergrens, 23 september 00:49 (veertiende sessie)

[[Ali Can]] wees erop dat de meting van 00:24 op 42.000 tekens niets zegt over een document van 200.000, en dat is terecht: `MAX_REVIEW_CHARS` staat op 200.000 en dat is de grens die het tijdsbudget moet halen. Nieuwe fixture van 199.998 tekens, opgebouwd uit dezelfde generator als de 42k-fixture met bijlagen erachter, dus zelfde register en zelfde zinsvormen, geen klantmateriaal. Twee calls op `gemini-3.5-flash`, 30 seconden ertussen, geen retries en geen keten. De client-timeout stond in deze probe op 120 seconden in plaats van 40, anders zou de meting onze eigen afkapgrens meten in plaats van de werkelijke duur. Rapport in `.smoke/provider-probe-200k-1790117428055.json`.

| # | Start | Duur | HTTP | finishReason | Prompt | Candidates | Denk | Totaal | Gefactureerde uitvoer | Kosten |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 00:49:29 | 14.848 ms | 200 | STOP | 53.499 | 1.938 | 1.170 | 56.607 | 3.108 | 10,82 cent |
| 2 | 00:50:14 | 13.600 ms | 200 | STOP | 53.499 | 1.620 | 1.568 | 56.687 | 3.188 | 10,89 cent |

Twee van twee geslaagd, max 14.848 ms. Volgens de beslisregel van [[Ali Can]] (max onder 20 seconden) mag `GEMINI_ATTEMPT_TIMEOUT_MS` naar 30 seconden.

**Wat opvalt.** Een document van bijna vijf keer zoveel tekens kost nauwelijks meer tijd: 13,6 tot 14,8 seconden tegen 11,9 tot 14,9 seconden bij 42.000 tekens. De invoertokens gaan van 12.037 naar 53.499, maar de uitvoer blijft in dezelfde orde (3.108 en 3.188 gefactureerde tokens tegen 2.545 tot 3.436), en het is de uitvoer die de tijd bepaalt. Dat is het tegenovergestelde van wat het oorspronkelijke plafond van 15.000 tekens veronderstelde.

**Kosten.** 10,82 en 10,89 eurocent per review op de invoergrens, berekend met `priceForMicros` uit de cost-meter zelf, dus dezelfde functie die productie gebruikt. Dat is **de helft van de 22,25 cent** die in de negende sessie als maximum stond. De reden: die schatting ging uit van een volle uitvoer van 16.384 tokens, en het model gebruikt er in de praktijk ruim drieduizend. Dat blijft een schatting van het ergste geval, maar de gemeten werkelijkheid ligt er ver onder.

**Voorstel, nu op beide documentmaten gemeten.** `GEMINI_ATTEMPT_TIMEOUT_MS` van 40.000 naar 30.000. Het gemeten maximum over zes geslaagde calls op twee documentmaten is 14,9 seconden, dus 30 seconden is tweemaal de langste waarneming. De winst is dat een timeout dan wél een modelwissel kan starten: na 30 seconden resteren er 20 van de deadline van 50, en de keten eist er 13,5. `maxDuration` blijft 60 en Fluid Compute blijft uit. Nog steeds niet toegepast, conform opdracht.


## Timeout van 40 naar 30 seconden, en een timeout mag nu van model wisselen (23 september, vijftiende sessie)

Akkoord van [[Ali Can]] op het voorstel uit de veertiende sessie. Doorgevoerd in de werkboom, niets gecommit.

`GEMINI_ATTEMPT_TIMEOUT_MS` staat op 30.000. `maxDuration` blijft 60 en Fluid Compute blijft uit.

Maar de constante alleen doet niets, en dat is de belangrijkste vondst van deze stap. Een afgebroken poging kwam in `gemini.ts` terecht in één tak die `AiTimeoutError` gooide, ongeacht hoeveel budget er nog over was. Verlagen naar 30 seconden zou dus nog steeds nooit een modelwissel opleveren; het zou alleen eerder opgeven. De tak is daarom gesplitst:

- **De signal van de aanroeper is afgegaan** (de `AbortController` van 50 seconden in `ai-review.service.ts`): het hele budget is op, er valt op geen enkel model nog iets te proberen. Blijft `AiTimeoutError`, HTTP 504.
- **De poging zelf liep in zijn eigen timeout** (de SDK-timeout van 30 seconden): dat zegt alleen dat dít model traag was. Telt nu mee als reden om te wisselen, naast 503, 429 en 404, mits er nog `GEMINI_RETRY_MIN_REMAINING_MS + GEMINI_TRANSIENT_BACKOFF_MS` (13,5 seconden) over is. Is dat er niet, dan blijft het voor de klant gewoon een timeout: `AiTimeoutError`, geen generieke fout.

De prijs hiervan staat al beschreven onder optie B: Google kan de afgebroken generatie afmaken en factureren zonder dat wij het zien, dus één review kan in het ergste geval twee generaties kosten. Met een gemeten maximum van 14,9 seconden tegen een grens van 30 is dat pad zeldzaam.

Vier tests erbij in `review-v2.test.ts`, samen 64 in dat bestand: dat 30 seconden binnen het budget van 50 wél ruimte laat voor een tweede model en 40 seconden niet (de rekensom staat nu in een test, niet in een comment), dat de keten na een timeout naar het volgende model gaat, dat een te klein restbudget nog steeds een `AiTimeoutError` oplevert, en dat een afgegane signal de run beëindigt. Volledige suite 275 groen en 3 overgeslagen, `tsc` schoon.
