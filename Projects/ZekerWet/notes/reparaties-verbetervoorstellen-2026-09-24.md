---
type: log
date: 2026-09-24
status: afgerond
tags: [compliance, homepage, privacy, cron]
project: ZekerWet
---

Uitvoering van de eerste drie punten uit [[verbetervoorstellen-2026-09-24]] voor [[ZekerWet]], op verzoek van [[Ali Can]] op 24 september 2026. Punt 1 is live. Punt 2 en 3 staan in de werkmap van de repo en wachten op zijn akkoord, want hij wil de teksten zien vóór de commit.

## 1. Opruimtaak voor reviewteksten (live)

Commit `8ee52ed`, zes paden, gepusht. `/api/admin/review-input-cleanup` staat nu naast `ai-health` in `isPublicRoute` in `src/middleware.ts`. Live nagemeten: zonder token geeft de route 401 met de eigen foutmelding in plaats van de 404 van Clerk (`protect-rewrite` is weg uit `X-Clerk-Auth-Reason`). Eén handmatige run met het cron-geheim gaf `{"ok":true,"deleted":0}`. Dat klopt: productie heeft 3 bewaarde teksten, 0 over datum, en de eerste verloopt op 24 oktober om 09:18.

Nieuw in de dagelijkse kostendigest van 09:00: de laatste run met tijdstip, het aantal verwijderde rijen, en het aantal `ReviewInput`-rijen dat over datum is, rechtstreeks uit de database geteld. Die laatste telling hangt niet af van de cron en ook niet van [[Upstash]], dus een stille cron valt altijd op. Is de laatste run ouder dan 26 uur, ontbreekt hij, of staat er iets over datum, dan kleurt de regel rood en staat "opruimen reviewteksten faalt" in de onderwerpregel. De run wordt 30 dagen in Redis bewaard onder `cron:review-input-cleanup:last`.

Poort: `tsc` schoon, lint schoon op de gewijzigde bestanden, `next build` exit 0, 306 tests groen (was 302), 1 overgeslagen. Vier nieuwe tests in `src/lib/review/retention.test.ts`.

## 2. Homepage eerlijk (wacht op akkoord)

`Testimonials.tsx` met Thomas V., Sanne M. en Jeroen K. is van de homepage gehaald en het bestand is verwijderd; niets anders gebruikte het. Dat herziet het besluit van 16 september om de verzonnen reviews te laten staan tot er echte quotes zijn.

De nieuwe teksten volgen de echte checkout: Essential heeft een proefperiode van 14 dagen, eenmalig per account, en Stripe vraagt daarbij een kaart of iDEAL (`stripe.service.ts:271-297`). Opzeggen loopt via het klantportaal van Stripe, dus opzeggen binnen de proef kost niets.

| Plek | Was | Wordt |
|---|---|---|
| `Hero.tsx:54` | Geen creditcard nodig. Direct aan de slag. | Essential 14 dagen gratis. Je geeft een betaalmethode op; zeg je binnen 14 dagen op, dan betaal je niets. |
| `FinalCTA.tsx:34` | Geen creditcard nodig. Opzegbaar per maand. | Essential 14 dagen gratis, met betaalmethode. Daarna opzegbaar per maand. |
| `HowItWorks.tsx:76` | Begin Nu — Eerste Document Gratis | Probeer Essential 14 Dagen Gratis |
| `Features.tsx:13` | Binnen seconden. | Binnen een halve minuut. |

## 3. Privacyverklaring (wacht op akkoord)

Nagemeten, niet aangenomen:

- **Supabase:** het account heeft één project, `Zekerwet`, regio `eu-west-1`, dus Ierland en niet Frankfurt. Dat is ook het productieproject: daar staan de 3 `ReviewInput`-rijen van de productiereviews van vandaag.
- **Gemini:** volgens de aanvullende voorwaarden van de Gemini API (nagelezen op ai.google.dev) gebruikt Google bij de betaalde dienst prompts en antwoorden niet om producten te verbeteren, verwerkt het ze onder het verwerkersaddendum, en logt het ze een beperkte periode alleen tegen misbruik en voor wettelijke plichten. Opslag kan plaatsvinden "in een land waarin Google of zijn medewerkers faciliteiten onderhouden", dus breder dan alleen de VS. Doorgiftegrond: de verwerkersvoorwaarden van Google (business.safety.google/processorterms, artikel 7.4) melden dat Google gecertificeerd is onder het EU-VS Data Privacy Framework.
- **Upstash:** regio niet vast te stellen. De URL in de lokale `.env` (`prepared-muskox-96567`) bestaat niet meer (DNS geeft niets terug), dus productie gebruikt een andere database, en `UPSTASH_REDIS_REST_URL` staat in Vercel als `sensitive` en is niet uit te lezen. In de tekst staat `[REGIO INVULLEN]`. [[Ali Can]] leest de regio af in console.upstash.com. Bewaartermijnen komen uit de code: cache 7 dagen (`cache.ts`), idempotency 24 uur (`idempotency.ts:12`).

> [!warning] Niet meegenomen
> "Sentry, EU regio, PII wordt gescrubd" (`privacy/page.tsx:152`) klopt waarschijnlijk niet, want er is geen `beforeSend`. Dat was punt 6 van de risico's en viel buiten deze opdracht. `LEGAL_LAST_UPDATED` is gedeeld met de voorwaarden en het cookiebeleid en is dus niet opgehoogd.

## Tweede ronde, na akkoord

[[Ali Can]] gaf akkoord met vier aanvullingen. De testimonials blijven weg (zijn besluit van 24 september, dat het besluit van 16 september herziet).

- **Homepage:** commit `0a32318` plus `95ff5c9`. Bij het stagen ging het mis: `0a32318` bevatte alleen de verwijdering van `Testimonials.tsx`, terwijl `page.tsx` het bestand nog importeerde. De build van `34bfde1` faalt daardoor. `95ff5c9` voegt de rest toe. Productie bleef intussen op `8ee52ed` staan, dus de site is niet kapot geweest. Les: na `git commit` altijd `git show --stat` nakijken vóór de push.
- **"Waterdicht":** stond niet meer in `Features.tsx` en `FAQ.tsx` (al weg sinds `c527f05`). Wel nog in de omschrijvingen van de NDA en de VSO in `src/lib/questions.ts`. Daar staat nu "Juridisch onderbouwde", commit `2c9123d`.
- **Sentry:** `beforeSend` in `sentry.server.config.ts` haalt `request.data` en `extra` weg, commit `34bfde1`. De DSN in de live bundle wijst naar `ingest.de.sentry.io` (EU). De server-DSN staat als `sensitive` in Vercel en is niet uit te lezen. Client- en edge-config hebben nog geen `beforeSend`.
- **Privacydatum:** de privacyverklaring krijgt een eigen `PRIVACY_LAST_UPDATED` (24 september 2026). Voorwaarden, cookiebeleid en disclaimer blijven op 16 september. Nog niet gecommit, wacht op de Upstash-regio.

Poort over alles samen: `tsc` schoon, lint schoon, `next build` exit 0, 306 tests groen.

- **Upstash:** na inloggen door [[Ali Can]] afgelezen in de console. Actief is één database, `zekerwet-redis` (`powerful-lacewing-193671`), Free Tier, AWS Ierland `eu-west-1`, zonder leesregio's. De oude `zekerwet-prod` (`prepared-muskox`, de host in de lokale `.env`) staat op inactief. Privacy gecommit als `0ea74e0`: Gemini, Supabase Ierland, Upstash Ierland met 7 dagen en 24 uur, en een eigen datum van 24 september 2026.

> [!warning] Nieuwe vondst
> In de console staat "Encryption at rest" onder het betaalde Prod Pack. Het gratis niveau waarop `zekerwet-redis` draait heeft dat dus waarschijnlijk niet, terwijl `privacy/page.tsx` in sectie 9 "at rest (AES-256)" belooft. Nog niet nagekeken bij Upstash en niet gewijzigd.

Ook nog open: de lokale `.env` wijst naar de inactieve Upstash-database, en client- en edge-config van Sentry hebben geen `beforeSend`.

## Live nagemeten

Homepage (`95ff5c9`): 0 keer Thomas V., Sanne M., Jeroen K., "Geen creditcard", "Eerste Document Gratis", "Binnen seconden" en "waterdicht"; de drie nieuwe teksten staan erop. Privacypagina (`0ea74e0`): 0 keer Vertex, Frankfurt en de placeholder; Gemini API, `eu-west-1 (Ierland)`, Data Privacy Framework, 7 dagen, 24 uur en "24 september 2026" staan erop. De voorwaarden tonen nog 16 september, zoals bedoeld. Deploy `34bfde1` staat op ERROR (de stagingmisser), `95ff5c9` en `0ea74e0` zijn READY.

## Versleuteling in hoofdstuk 9

Besluit van [[Ali Can]]: geen betaalde upgrade van [[Upstash]], de tekst gaat naar wat vaststaat. "Versleuteling in transit (TLS 1.3) en at rest (AES-256)" wordt: AES-256 at rest alleen voor de database bij Supabase, en voor de Upstash-cache versleuteld transport plus automatische verwijdering na 7 dagen en 24 uur. Nagemeten: supabase.com/security zegt "All customer data is encrypted at rest with AES-256 and in transit via TLS", en `openssl s_client` geeft TLSv1.3 voor zekerwet.nl, de Supabase-pooler en de Upstash-host. Of Upstash Free Tier at rest versleutelt staat niet vast, dus de tekst zegt er niets over. Commit `08e647d`, poort groen (306 tests, build 0), live nagemeten: de oude zin staat er niet meer, de twee nieuwe regels wel.

## Afgesloten, besluiten van [[Ali Can]] (24 september 2026)

- Kostendigest van 25 september 09:00 kijkt hij zelf na.
- Sentry in browser en edge krijgt geen `beforeSend`: documentteksten lopen alleen via de server, en die filtert nu. Bewust laten staan.
- De lokale `.env` blijft naar de inactieve Upstash-database wijzen. Lokaal zonder werkende cache is prima; nooit naar de productie-Upstash laten wijzen.

Hiermee is deze reeks af. Volgend werk: sjablonen en een meetplan, pas op zijn opdracht.
