---
type: plan
date: 2026-09-24
status: live
tags: [meten, funnel, conversie, avg]
project: ZekerWet
---

Meetplan voor [[ZekerWet]]: waar komen betalende klanten vandaan en waar haken ze af? Opgesteld op 24 september 2026 door een agent, op verzoek van [[Ali Can]]. De kernclaims heb ik zelf met grep nagekeken. Hoort bij [[verbetervoorstellen-2026-09-24]].

## Wat er nu is (nagekeken)

Alleen anoniem bezoek, via Vercel Web Analytics (`package.json:47`, `layout.tsx:7`). Er zijn geen custom events. De UTM-links die het marketingsysteem bouwt (`marketing/utm.ts`) worden **nergens opgeslagen**: `prisma/schema.prisma`, `stripe.service.ts` en `middleware.ts` bevatten nul keer "utm". Na het eerste bezoek is de herkomst dus kwijt. De privacy- en cookieverklaring beloven "cookieloos", en daarom is er nu terecht geen banner.

## Funnel

| Stap | Nu meetbaar | Bron |
|---|---|---|
| Bezoek | ja, anoniem | Vercel-dashboard |
| Aanmelding | ja | `User.createdAt` |
| Checkout gestart | nee (alleen Stripe-dashboard) | |
| Trial | deels | `hasUsedTrial`, zonder datum |
| Betaald | deels | huidige staat op `User`; historie alleen in Stripe |
| Eerste document | ja | `MIN(Document.createdAt)` |
| Eerste review | ja | `MIN(Review.createdAt)` |
| Herkomst per klant | nee | nergens |

## Bouwplan, circa 6,5 uur, zonder nieuwe tool

1. **UTM vastleggen bij de eerste landing** (1 uur). `middleware.ts` zet een first-party cookie `zw_src` (bron, medium, campagne, content, landingspad, datum; 30 dagen; zonder ID of IP). Er is geen banner nodig als hij onder de uitzondering van art. 11.7a lid 3 sub b Tw valt, maar de cookieverklaring moet hem wel noemen. Generiek playbook: vóór livegang juridisch toetsen.
2. **Herkomst op `User` opslaan** (2 uur). Nieuwe kolommen `utmSource`, `utmMedium`, `utmCampaign`, `utmContent`, `landingPath` en `firstSeenAt`, eenmalig gevuld bij de eerste ingelogde request. Grondslag gerechtvaardigd belang; een zin in de privacyverklaring; na 24 maanden leegmaken.
3. **Funnelmomenten vastleggen** (2 uur). `checkoutStartedAt`, `trialStartedAt` en `firstPaidAt` op `User`, plus bron en campagne in de metadata van de Stripe-checkout.
4. **Wekelijkse funnelregel in de bestaande dagelijkse digest** (1,5 uur). Op maandag per bron: aanmeldingen, checkout, trial, betaald, eerste document en eerste review. Alleen aantallen, geen e-mailadressen.

## Eerste drie cijfers na één week

1. Aanmeldingen per bron, inclusief "zonder bron".
2. Van aanmelding naar checkout gestart, in procenten.
3. Eerste document binnen 24 uur na aanmelding, in procenten. Dit is de vroegste voorspeller van betalen, en je kunt hem nu al zonder bouwen uit de database halen.

## Uitvoering, 24 september 2026 (nog niet live)

Stap 1 tot en met 4 zijn gebouwd in de werkmap van de repo, niet gecommit en niet toegepast op productie. [[Ali Can]] wil eerst de migratie en de nieuwe cookie- en privacyteksten zien.

- Stap 1: `src/lib/attribution-cookie.ts` en `middleware.ts`. Cookie `zw_src`, alleen gezet bij binnenkomst met UTM-parameters en alleen als hij er nog niet is (first touch), 30 dagen, httpOnly, zonder ID of IP.
- Stap 2: negen kolommen op `User` (`utmSource`, `utmMedium`, `utmCampaign`, `utmContent`, `landingPath`, `firstSeenAt`, `checkoutStartedAt`, `trialStartedAt`, `firstPaidAt`) plus een index op `createdAt`. Migratie `20260924200000_user_attribution_funnel`, alleen toevoegend. Vastgelegd bij de eerste aanroep van `/api/subscription` na inloggen; daarna wordt de cookie gewist. Bron wissen na 24 maanden zit in de dagelijkse opruimtaak.
- Stap 3: `checkoutStartedAt` bij het starten van een checkout (ingelogd) of uit Stripe (gast), `trialStartedAt` bij een checkout met proefperiode, `firstPaidAt` bij de eerste factuur boven 0 euro of een betaalde losse aankoop. Bron en campagne gaan als `utm_source` en `utm_campaign` mee in de Stripe-metadata.
- Stap 4: op maandag in de kostendigest het cohort van de afgelopen 7 dagen per bron: aanmeldingen, checkout, trial, betaald, eerste document, eerste review. Alleen aantallen.

> [!warning] Juridisch punt bij stap 1
> Art. 11.7a lid 3 onder b Tw heeft twee takken. "Strikt noodzakelijk voor de gevraagde dienst" past niet op een herkomstcookie. Wel mogelijk is de tweede tak: informatie over de effectiviteit van de dienst, mits met "geen of geringe gevolgen" voor de privacy. Of dat nog zo is nu de herkomst aan een account wordt gekoppeld, is een afweging die [[Ali Can]] maakt vóór de livegang.

De lokale `.env` wijst naar de productiedatabase, dus er is geen enkel Prisma-migratiecommando gedraaid.

Poort op de werkmap: `tsc` schoon, lint schoon op de gewijzigde bestanden, `next build` exit 0, 343 tests groen (was 325; 18 nieuw in `attribution.test.ts` en `attribution-cookie.test.ts`). Stap 1 lokaal nagemeten op de gebouwde app (`next start`, alleen pagina's zonder database): met UTM komt er een `zw_src`-cookie van 30 dagen (HttpOnly, Secure, SameSite=lax), zonder UTM, met een bestaande cookie of op een API-route niet. De eerste meting liet een dubbel gecodeerde waarde zien; gerepareerd en opnieuw gemeten.

Volgorde bij livegang: eerst de migratie op productie, dan pas de code pushen. Andersom vraagt de nieuwe code naar kolommen die nog niet bestaan.

## Afweging cookie zonder toestemming (24 september 2026, advies, geen juridisch advies)

Keuze voorgelegd aan [[Ali Can]]: (a) zoals gebouwd zonder toestemming, (b) geen koppeling aan het account, alleen totalen, (c) toestemmingsbanner. Advies: **a**, om deze redenen (eigen redenering):
- De cookie zelf is first-party, zonder ID of IP, 30 dagen, wordt niet gedeeld en wordt alleen gezet bij binnenkomst via een eigen campagnelink. Daarmee valt hij binnen de gedachte achter de uitzondering voor analytisch gebruik met geringe gevolgen.
- De koppeling aan het account is een gewone AVG-verwerking op grond van gerechtvaardigd belang. De uitkomst wordt alleen in totalen per kanaal gebruikt, niet voor profilering, advertenties of persoonlijke benadering. Dat staat zo in de privacyverklaring.
- Optie b neemt precies weg waar het meetplan om draait: welk kanaal betalende klanten oplevert. Optie c schaadt de conversie en is strenger dan nodig.
- Restrisico: een strenge lezing van de toezichthouder kan de koppeling aan een account al te veel vinden voor "geringe gevolgen". Voor een product dat compliance verkoopt, is het goed te weten dat dit een verdedigbare keuze is en geen zekerheid. Herzien als de AP hier nieuwe richtsnoeren over geeft, of bij groei.

Bijvangst: de lokale `.env` van de repo wijst naar de **productiedatabase**. Een lokaal `prisma migrate dev` of een testscript raakt dan echte klantdata. Zet dit op de lijst voor een aparte lokale database of een Supabase-branch.

## Besluit en livegang, 24 september 2026

> [!important] Keuze a
> [[Ali Can]] koos op 24 september 2026 voor optie a: de herkomstcookie `zw_src` zonder toestemming, op grond van art. 11.7a lid 3 onder b Telecommunicatiewet (tweede tak: effectiviteit van de dienst, geen of geringe gevolgen voor de privacy). Afgewezen: b (alleen totalen, geen koppeling aan het account) en c (toestemmingsbanner). Migratie en teksten goedgekeurd.

Migratie `20260924200000_user_attribution_funnel` toegepast met `prisma migrate deploy` via `DIRECT_URL`, 19:54:38 UTC. Nagekeken in productie: negen kolommen, alle nullable, index `User_createdAt_idx` aanwezig, 5 bestaande gebruikers onaangeraakt. Daarna pas gecommit en gepusht: `702254c` (schema en migratie), `a150322` (cookie en eerste bezoek), `e4b28cf` (funnelmomenten en Stripe-metadata), `243f91e` (maandagregel in de digest), `3f42dd6` (cookie- en privacytekst), `6834b56` (test die de digest rendert bij een lege week). Poort: `tsc` schoon, lint schoon, 346 tests groen.

Live nagemeten: deploy `dpl_5sGbSobJegxWTPwpWTzbWF69WAF4` (commit `6834b56`) READY, aliassen `zekerwet.nl` en `www.zekerwet.nl` wijzen erheen, nul runtime-errors in het uur erna. `https://zekerwet.nl/?utm_source=test&utm_campaign=livetest` zet `zw_src` met bron `test` en campagne `livetest`, 30 dagen, Secure, HttpOnly, SameSite=lax; zonder UTM of met een bestaande cookie komt er geen. Cookiebeleid toont artikel 2.3 herkomstcookie, de grondslag 11.7a lid 3 onder b en de datum 24 september 2026, en niet meer "uitsluitend essentiële cookies"; de privacyverklaring toont de klantreis, het meetdoel, de 24 maanden en `zw_src`. De maandagregel rendert zonder fout bij een lege week (test in `6834b56`); de eerste echte maandagdigest is die van 28 september.

Onderweg: de wachtlus voor de live test werd door Claude Code gestopt wegens geheugentekort op de machine; hij had de cookietest al gedaan, de tekstcontrole is daarna los herhaald.
