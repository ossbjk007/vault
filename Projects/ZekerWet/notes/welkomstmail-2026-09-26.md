---
type: log
date: 2026-09-26
status: live
tags: [mail, activatie, funnel]
project: ZekerWet
---

Welkomstmail van [[ZekerWet]] aangezet als opvolgmail, punt 4 uit [[verbetervoorstellen-2026-09-24]], op verzoek van [[Ali Can]] op 26 september 2026. Gebouwd in de werkmap, niet gecommit, migratie niet toegepast: Ali ziet eerst de tekst en de migratie.

Niet bij aanmelding, want na een gast-checkout gaat de klant naar `/sign-up` en heeft hij de mail SubscriptionActivated al; een welkomstmail met "start je proefperiode" zou die tegenspreken.

## Hoe het werkt

`src/lib/welcome.ts`, aangeroepen vanuit de dagelijkse digest-cron (07:00 UTC, 09:00 Nederlandse tijd, zelfde cron-geheim), vóór de digest zelf. Eén keer naar elke `User` die 24 tot 48 uur geleden is aangemaakt, `role` user heeft, geen `stripeCustomerId`, `hasUsedTrial` false, geen `DocumentPurchase`, en bij `customers.list` op e-mailadres geen Stripe-klant is. Een Stripe-klant zonder koppeling (zoals [[Murmurly]] in augustus) wordt overgeslagen en apart geteld in de digest. Stripe-fout: overslaan, niet mailen. Mislukte mail: geteld, de claim wordt vrijgegeven, de cron gaat door. Nooit twee keer: `welcomeEmailSentAt` wordt geclaimd vóór het versturen.

Digest: nieuw blok Welkomstmails met verstuurd, mislukt, overgeslagen wegens Stripe-klant zonder koppeling en wegens Stripe niet bereikbaar.

Migratie `20260926090000_user_welcome_email_sent`: één kolom `welcomeEmailSentAt`, nullable, alleen toevoegend.

Poort in de werkmap: `tsc` schoon, lint schoon, `next build` exit 0, 359 tests groen (was 346; 11 in `welcome.test.ts`, 2 in `AiCostDigest.test.tsx`).

Bekend randgeval: het venster is precies 24 uur en de cron draait eens per 24 uur. Verschuift Vercel het starttijdstip een paar minuten, dan kan een account op de rand net buiten twee opeenvolgende runs vallen en geen mail krijgen. Nooit een dubbele mail; hooguit een gemiste.

Volgende stap: akkoord van [[Ali Can]] op tekst en migratie, dan migratie op productie, commit per pad, push en deploy nakijken.

## Akkoord en livegang, 26 september 2026

[[Ali Can]] keurde tekst en migratie goed, met één aanpassing: het venster werd 24 tot 72 uur in plaats van 24 tot 48, zodat niemand meer tussen twee cronruns door valt; `welcomeEmailSentAt` voorkomt een tweede mail. Daarmee is het randgeval hierboven opgelost. Test aangepast (50 uur wel, 72 uur niet), 359 tests groen.

Migratie toegepast met `prisma migrate deploy` om 14:34 UTC; kolom nagekeken: nullable, 0 gevuld, 5 gebruikers. Daarna gecommit en gepusht: `feat(db)` (schema en migratie), `feat(welcome)` (verzendlogica, digest en tests) en `5e91293` (mailtekst). Niets uit `marketing/` meegenomen. Deploy `dpl_HLuG6M1gJk9e5gCrUPKagur5v3GN` READY, aliassen `zekerwet.nl` en `www.zekerwet.nl` wijzen erheen, nul runtime-errors in het uur erna. De eerste echte run is de digest van 27 september 09:00.
