---
type: note
date: 2026-08-31
status: open
tags: [klant, incasso, escalatie]
project: ZekerWet
---

Klantescalatie rond [[Ananda-Visser]] (`ananda.dm` op Instagram) en haar collega Sid van [[Murmurly]], beide op het domein `murmurly.io`. Zij dreigt op vrijdag 28 augustus 2026 om 09:49 met "stappen ondernemen" omdat er twee keer 24,99 euro is afgeschreven terwijl het product volgens haar niets deed.

## Wat er feitelijk in Stripe staat

Drie proefabonnementen op Essential (24,99 euro), alle drie aangemaakt op woensdag 12 augustus 2026 binnen veertien minuten van elkaar, op drie klantrecords:

| Klant | Stripe-klant | Betaalmethode |
|---|---|---|
| `anandadm93@gmail.com` | `cus_V3SCPuRHu8wtTi` | Apple Pay, Mastercard debit ...8137 |
| `ananda@murmurly.io` | `cus_V3SK8m4dYQAhil` | Apple Pay, Mastercard debit ...8137 |
| `sid@murmurly.io` | `cus_V3SPh9Oxw0qYnI` | SEPA-incasso, Rabobank ...2925 |

De trial liep af op dinsdag 25 augustus 2026 en het systeem incasseerde diezelfde avond automatisch. Twee kaartbetalingen slaagden om 22:26 en 22:34: `ch_3U8Qv9E2xhFVUSlh0Gvgovlk` en `ch_3U8R2tE2xhFVUSlh1zuA2ZoG`, samen 49,98 euro. Dat zijn precies de twee afschrijvingen waar zij over schrijft. Het is dezelfde fysieke pas onder twee accounts, vandaar dat het voor haar als een dubbele afschrijving voelde.

> [!check] Beide bedragen zijn al terug
> Op zaterdag 29 augustus 2026 rond 23:20 zijn beide charges volledig gerefund (`re_3U8Qv9E2xhFVUSlh0P51FXl4` en `re_3U8R2tE2xhFVUSlh1OSmnvqf`, status `succeeded`, reden `requested_by_customer`) en zijn alle drie de abonnementen op `canceled` gezet. Een kaartrefund is bij de bank pas na vijf tot tien werkdagen zichtbaar, dus zij ziet het geld op het moment van schrijven waarschijnlijk nog niet staan.

> [!danger] Er komt nog een derde afschrijving
> De SEPA-incasso van Sid, `py_3U8R6UE2xhFVUSlh0dXLAXzM`, staat nog op `pending` met incassodatum 31 augustus 2026. Die 24,99 euro landt dus vandaag alsnog op de rekening van hetzelfde bedrijf, ondanks de opzegging. Zodra de charge settelt moet hij direct terug, anders begint de discussie opnieuw. De taak `ZekerWet_SidPayment` bewaakt dit elke zes uur via `scripts/check-sid-payment.ps1` en meldt via Telegram.

## De onderliggende bug

Haar klacht gaat verder dan het geld. Volgens haar bleef de subscription in het systeem op `none` staan en konden er tijdens de trial geen gratis documenten worden aangemaakt, terwijl Stripe wél een geldige trial en een geldige betaalmethode had. Dat wijst op een provisioning-gat tussen Stripe en de app: de betaling of trial komt niet terug in het account. Er is geen bewijs in de vault dat dit gat gedicht is. De fix van 31 augustus in [[2026-08-31]] ging over PDF-extractie in de Copilot, niet over abonnementstatus.

Dat drie klantrecords voor twee mensen op één pas zijn ontstaan is een tweede signaal: iemand probeerde het opnieuw en opnieuw omdat het niet werkte, en elke poging maakte een nieuw betalend abonnement aan.

Gerelateerd: [[ZekerWet]].
