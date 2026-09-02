---
type: notes
date: 2026-08-31
status: actief
tags: [stripe, webhooks, provisioning, root-cause]
project: ZekerWet
---

Waarom een betaald abonnement bij [[ZekerWet]] soms niet in de app landt. Onderzocht op 31 augustus 2026 naar aanleiding van [[klant-murmurly]].

> [!warning] Kern
> Een abonnement komt de app uitsluitend binnen via de Stripe-webhook. Faalt die bezorging, dan blijft het account op plan `none` staan, ook al is er gewoon betaald.

## Bewezen oorzaak van de Murmurly-klacht

De drie proefabonnementen van 11 augustus 2026 zijn aangemaakt via een gast-checkout: de `success_url` wijst naar `/sign-up`, er staat geen `userId` in de sessiemetadata en `client_reference_id` is leeg. De app moet dan een gebruikersrij aanmaken op e-mailadres zodra de webhook binnenkomt.

Die webhook is nooit aangekomen. In Stripe staan de drie `checkout.session.completed`-events en de drie bijbehorende `invoice.payment_succeeded`-events tot vandaag op `pending_webhooks=1`, wat betekent dat er nooit een 2xx is teruggekomen. Zonder dat event schrijft de app geen `stripeSubscriptionId`, `stripePriceId` of `stripeCurrentPeriodEnd`, en dan geeft `checkSubscription` in `src/lib/subscription.ts` netjes `isValid=false` met plan `none`. De database bevestigde het: drie gebruikers in totaal, nul met een abonnement.

## Wanneer het omsloeg

| Datum | Geabonneerde events | Afgeleverd |
|---|---|---|
| 11 augustus | 6 | 0 |
| 22 augustus | 3 | 0 |
| 25 augustus | 5 | 5 |
| 29 augustus | 5 | 5 |

De omslag ligt tussen 22 augustus 19:37 en 25 augustus 19:25 UTC. In dat venster is er niet gedeployed: de vorige productiedeploy was van mei, de volgende van 27 augustus. De verandering zat dus in de infrastructuur, niet in de code. De meest waarschijnlijke kandidaat is de canonieke host: het webhook-adres is de apex `zekerwet.nl`, en `www` stuurt nu een 307 naar de apex. Stripe volgt geen redirects, dus zolang de apex zelf doorstuurde faalde elke bezorging. Dat is niet hard te bewijzen omdat de oude domeininstelling van Vercel niet terug te halen is.

## Wat er nu goed staat

De apex antwoordt direct met 400 en `Missing Stripe-Signature header`, dus de route is bereikbaar, publiek in de middleware en verifieert zelf. Sinds 23 augustus bestaat er een zelfherstel-endpoint `/api/stripe/sync` met een banner op het dashboard. Op 11 augustus bestond dat nog niet, en dat is waarom er toen geen enkele uitweg was.

## De fix van 31 augustus

`2412a5f`. De zelfherstel-route keek alleen naar `emailAddresses[0]` van het Clerk-account. Omdat een gast-checkout onder elk adres afgerekend kan zijn, vond hij dan geen klant en bleef de gebruiker vastzitten. Nu zoekt hij over alle geverifieerde adressen van het account, maximaal drie, met de bestaande rate limit erop. Onbevestigde adressen tellen niet mee, anders zou iemand met een niet-bewezen adres het abonnement van een ander kunnen claimen.

## Wat nog niet bewezen is

De schrijfweg van `checkout.session.completed` naar de databaserij is in productie nog nooit geslaagd, simpelweg omdat de enige drie echte pogingen door de bezorgfout nooit zijn aangekomen. Bezorging werkt aantoonbaar wel weer, want de events van 25 en 29 augustus zijn met 2xx verwerkt, maar dat waren andere eventtypes. Eén gecontroleerde echte aankoop met daarna een refund is de enige manier om die laatste schakel te bewijzen.

Gerelateerd: [[klant-murmurly]], [[copilot-handover-2026-08-31]], [[2026-08-31]].
