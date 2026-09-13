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

## De echte end-to-end test, 2 september 2026

Uitgevoerd met een gewone niet-admin gebruiker (`role: user`, plan werd `Essential` en niet `enterprise`, dus de admin-bypass speelde aantoonbaar niet mee). Kosten: nul euro, want de proefperiode van veertien dagen maakt een factuur van nul en het abonnement is daarna opgezegd per 16 september.

| Schakel | Bewijs |
|---|---|
| Checkout | `cs_live_a1nlefcm…` complete en paid, totaal 0 |
| Subscription | `sub_1UBLbdE2xhFVUSlhMGE9pMsR`, trialing t/m 16-09-2026 |
| Webhook | `checkout.session.completed` afgeleverd, `pending_webhooks=0` |
| Idempotency | markering in `ProcessedWebhookEvent`, verwerkt om 21:22:09.457 |
| Database | customer, subscription, `price_essential` en periode-einde alle vier correct weggeschreven |
| Entitlement | dashboard, instellingen en account tonen Essential met verlenging 16 september |
| Product | document `cmtklwo58000004l5p3rmx227` gegenereerd en opgeslagen, 413 tekens |
| Opzeggen | klantportaal werkt, `customer.subscription.updated` afgeleverd, toegang blijft tot 16 september |

## Tweede bug, gevonden tijdens die test

Het starten van een proefperiode maakt ook een betaalde factuur van nul euro, dus `invoice.payment_succeeded` vuurde 207 milliseconden na `checkout.session.completed`. Die handler zette `stripeTrialEnd` hard op `null` en wiste zo de proefeinddatum die checkout net had geschreven. Gevolg: `isTrial` werd `false` en `createDocument` sloeg de proeflimiet van drie documenten volledig over. Bewijs uit de test: `trialDocCount` bleef op 0 terwijl er wel een document was gemaakt.

Gefixt in `4fc4baa` door Stripe te spiegelen in plaats van te blanken. `handleSubscriptionUpdated` deed dat al goed, de factuur-handler was de uitzondering. Na de opzegging herstelde de databaserij zichzelf via die update-handler: `stripeTrialEnd` staat nu op 16-09-2026.

## Derde bug, gevonden bij code-inspectie

De idempotency-markering werd weggeschreven vóór de handler draaide. Faalde de handler, dan bleef de markering staan, kreeg de herhaalpoging van Stripe een 200 en werd het event nooit verwerkt. Een betaald abonnement kon zo in Stripe staan en nooit in de app landen. Gefixt in `2947e20` door de markering terug te rollen zodra de handler faalt. Die fix is geverifieerd met typecheck en tests, niet met een echte mislukte webhook.


## Bewaking, sinds 2 september 2026

`scripts/check-stripe-webhooks.ps1` draait elk kwartier als taak `ZekerWet_WebhookWatch`. Hij leest de Stripe-events, filtert op exact de acht types waarop het productie-endpoint geabonneerd is, en meldt via Telegram elk event dat na vijftien minuten nog op `pending_webhooks > 0` staat. Gemelde event-ids worden onthouden in `.webhook-alerts`, dat in `.gitignore` staat, zodat één storing niet elk kwartier opnieuw piept. Bij een netwerk- of API-fout stopt hij stil, want een bewaker mag nooit zelf vals alarm slaan.

De sleutel komt uit `secrets.local.ps1`. Staat daar een `$STRIPE_MONITOR_KEY`, dan gebruikt hij die; anders valt hij terug op de gewone sleutel. Zet daar een restricted key met alleen leesrecht op Events neer zodra je die aanmaakt in het Stripe-dashboard.

Geverifieerd op echte data: over de laatste 24 uur nul treffers uit 16 events, dus geen vals alarm. Over dertig dagen exact de negen events van 11 en 22 augustus, dus de storing van augustus was binnen een kwartier gemeld in plaats van na negentien dagen.

## Handmatig herstel als een webhook niet is afgeleverd

Als een betaling wel bij Stripe binnenkomt maar het abonnement niet in de app landt, is het herstel een `prisma.user.upsert` op de gebruikersrij met de vier Stripe-velden overgenomen uit het webhook-logboek in het Stripe-dashboard. Dat is precies wat er in september 2026 eenmalig voor een klant is gedaan.

> [!warning] Schrijf zo'n herstelscript nooit met klantgegevens erin naar de repo.
> Het script dat hiervoor bestond had een e-mailadres en de `cus_` en `sub_` identifiers hardcoded en stond untracked in de projectmap, buiten `.gitignore`. Eén `git add -A` en het had permanent in de geschiedenis gestaan van een product dat AVG-compliance verkoopt. Op 10 september 2026 verwijderd. Doe het voortaan met de identifiers als argumenten op de commandoregel, of rechtstreeks in een databaseclient.
