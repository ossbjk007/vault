---
type: log
date: 2026-09-24
status: actief
tags: [sessie, rapport, overdracht]
project: ZekerWet
---

Overdrachtsrapport van de codeersessie van 24 september 2026 voor [[ZekerWet]], op verzoek van [[Ali Can]], om aan een andere terminal te geven. Repo: `C:\Users\acerd\OneDrive\Bureaublad\Project Compliance & automatic document generator\zekerwet`, branch `main`, GitHub `ossbjk007/Zekerwet`, Vercel-project `zekerwet` (team `team_G20dd7miojnUtfUBWhVViWGN`). Details per onderdeel in [[reparaties-verbetervoorstellen-2026-09-24]], [[sjabloonreparaties-2026-09-24]] en [[meetplan-funnel-2026-09-24]].

## Stand in één oogopslag

| Onderdeel | Stand |
|---|---|
| Opruimtaak reviewteksten | live, `8ee52ed` |
| Homepage eerlijk | live, `0a32318` + `95ff5c9` |
| "Waterdicht" weg | live, `2c9123d` |
| Sentry-scrub server | live, `34bfde1` |
| Privacyverklaring subverwerkers en datum | live, `0ea74e0` |
| Privacy hoofdstuk 9 versleuteling | live, `08e647d` |
| Sjabloonreparaties top 5 | live, `f89193f`, `1211cfd`, `ac48a85`, `342a8b7` |
| Meetplan stap 1 t/m 4 | gebouwd in werkmap, NIET gecommit, NIET live, wacht op akkoord |

Laatste commit op `main` en live: `342a8b7`. Tests: 343 groen in de werkmap (325 op `main`).

## 1. Opruimtaak reviewteksten (`8ee52ed`)

`/api/admin/review-input-cleanup` stond niet in `isPublicRoute` (`src/middleware.ts`), dus Clerk gaf de Vercel-cron een 404. Nu publiek; de route beveiligt zichzelf met `AI_HEALTH_CRON_SECRET`. Eén handmatige run gaf `{"deleted":0}`: 3 teksten in productie, 0 over datum, eerste verval 24 oktober 09:18. De dagelijkse kostendigest toont nu de laatste run, verwijderde rijen en het aantal rijen over datum (rechtstreeks uit de database); faalt dat, dan staat "opruimen reviewteksten faalt" in de onderwerpregel. Laatste run staat in Redis onder `cron:review-input-cleanup:last`.

## 2. Homepage eerlijk (`0a32318`, `95ff5c9`)

Drie verzonnen testimonials (Thomas V., Sanne M., Jeroen K.) weg, `Testimonials.tsx` verwijderd (besluit Ali 24-09, herziet dat van 16-09). "Geen creditcard nodig" en "Eerste Document Gratis" vervangen door de echte belofte: Essential 14 dagen gratis, met betaalmethode, gratis opzeggen binnen 14 dagen. "Binnen seconden" werd "binnen een halve minuut". Fout onderweg: `0a32318` bevatte alleen de verwijdering, de build van `34bfde1` faalde; `95ff5c9` herstelde dat, productie is niet stuk geweest. Sindsdien na elke commit `git show --stat` vóór de push.

## 3. Kleine reparaties (`2c9123d`, `34bfde1`)

"Juridisch waterdicht" (verboden in `marketing/data/claims.json`) stond niet meer in Features/FAQ maar wel in de NDA- en VSO-omschrijving in `src/lib/questions.ts`; nu "onderbouwd". Sentry: `beforeSend` in `sentry.server.config.ts` wist `request.data` en `extra`; DSN op `ingest.de` (EU). Client en edge bewust zonder scrub (besluit Ali: documentteksten gaan alleen via de server).

## 4. Privacyverklaring (`0ea74e0`, `08e647d`)

"Google AI / Vertex" wordt de betaalde Gemini Developer API (geen training, verwerking buiten de EER mogelijk, grondslag SCC en EU-VS Data Privacy Framework). Supabase is `eu-west-1` Ierland (niet Frankfurt; één project `huqhtsrevwlkrvaldkja`). Upstash toegevoegd: `zekerwet-redis`, Ierland `eu-west-1`, cache 7 dagen, idempotency 24 uur. Eigen datum `PRIVACY_LAST_UPDATED` (24-09). Hoofdstuk 9: AES-256 at rest alleen voor Supabase; voor Upstash alleen TLS 1.3 en automatische verwijdering (Free Tier heeft geen vastgestelde encryption at rest; geen betaalde upgrade, besluit Ali).

## 5. Sjabloonreparaties (`f89193f`, `1211cfd`, `ac48a85`, `342a8b7`)

Alle artikelen eerst nagelezen op wetten.overheid.nl (BW, WML) en EUR-Lex (AVG, Verordening 2024/3228).
- Verwerkersovereenkomst: duur, einde en teruggave of verwijdering, bijstand art. 32 t/m 36 (DPIA, voorafgaande raadpleging), melding bij onrechtmatige instructie, subverwerkers met doorgelegde plichten en volle aansprakelijkheid (art. 28 lid 3 en 4 AVG).
- Arbeidsovereenkomst bepaalde tijd: proeftijd afgeleid uit de looptijd (7:652 lid 4 en 6), te lange keuze wordt verlaagd; tussentijds opzegbeding (7:667 lid 3); vakantiebijslag naar art. 15 WML.
- Algemene voorwaarden: bij `mixed` handelsrente en 40 euro alleen voor ondernemers, consumenten de veertiendagenbrief (6:96 lid 6); forumkeuze alleen voor ondernemers (6:236 sub n); 6:230p sub g in plaats van sub n.
- Webwinkel: retour minimaal 14 dagen, prijswijziging met ontbindingsrecht (6:236 sub i), vooruitbetaling max 50% (7:26 lid 2), ODR weg.
- Exoneraties in terms, AV B2C en AV B2B: niet bij opzet of bewuste roekeloosheid; 7:46d vervangen door 6:230o.
- 19 tests bouwen de echte PDF en lezen de tekst terug met `pdf-parse`; tegen de oude sjablonen falen er 18. Live bevestigd in chunk `8474-6e421388219912ba.js`.
- Bewust niet aangepast: audit alleen bij vermoeden (DPA), ketenregeling (klopt tot 2028), aanzegvergoeding, aansprakelijkheidsbeperking tegenover consumenten (grijze lijst), drie andere sjablonen met rechtbank Amsterdam.
- [[Yvonne Heiligers]] heeft gemengde AV; haar download bevat nu de gescheiden regels.

## 6. Meetplan (werkmap, niet live)

Gewijzigde en nieuwe bestanden, ongecommit: `prisma/schema.prisma`, `prisma/migrations/20260924200000_user_attribution_funnel/migration.sql`, `src/lib/attribution-cookie.ts`, `src/lib/attribution.ts`, beide `.test.ts`, `src/middleware.ts`, `src/app/api/subscription/route.ts`, `src/app/api/stripe/checkout/route.ts`, `src/app/api/stripe/checkout-document/route.ts`, `src/services/stripe.service.ts`, `src/app/api/admin/ai-health/route.ts`, `src/app/api/admin/review-input-cleanup/route.ts`, `src/emails/AiCostDigest.tsx`, `src/app/privacy/page.tsx`, `src/app/cookies/page.tsx`, `src/config/company.ts`.

- Stap 1: cookie `zw_src` alleen bij binnenkomst met UTM, first touch, 30 dagen, HttpOnly, geen ID of IP. Lokaal nagemeten op de gebouwde app.
- Stap 2: negen kolommen op `User` plus index op `createdAt` (migratie alleen toevoegend). Vastgelegd bij de eerste `/api/subscription` na inloggen, daarna cookie gewist. Bron gewist na 24 maanden in de dagelijkse opruimtaak.
- Stap 3: `checkoutStartedAt`, `trialStartedAt`, `firstPaidAt` (eerste factuur boven 0 euro of betaalde losse aankoop), elk één keer; `utm_source` en `utm_campaign` in de Stripe-metadata.
- Stap 4: op maandag in de kostendigest het cohort van 7 dagen per bron.
- Nieuwe teksten in cookiebeleid (artikel 2.3 herkomstcookie, eigen datum `COOKIES_LAST_UPDATED`) en privacyverklaring (2.3, 3, 4).

> [!warning] Open beslissingen voor Ali
> 1. Juridische keuze art. 11.7a lid 3 onder b Tw: de tekst steunt op de tweede tak ("effectiviteit", "geen of geringe gevolgen"). Opties: (a) zoals gebouwd zonder toestemming, (b) geen koppeling aan het account, alleen totalen, (c) toestemmingsbanner.
> 2. Akkoord op migratie en teksten.

Volgorde na akkoord: eerst de migratie op productie (lokale `.env` wijst naar productie, dus bewust nog niets gedraaid), kolommen controleren, dan pas commit en push, deploy en live nakijken.

## Open punten

- [ ] Meetplan: akkoord en keuze a, b of c, dan migratie, dan code 📅 2026-09-25
- [ ] Kostendigest 25 september 09:00 nakijken (Ali doet zelf) 📅 2026-09-25
- Lokale `.env` blijft naar de inactieve Upstash wijzen (besluit Ali).
- Buiten scope gebleven: privacyverklaring als sjabloon, overeenkomst van opdracht, concurrentiebeding `employment`.
