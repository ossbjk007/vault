---
type: notes
date: 2026-09-09
status: geaccepteerd-risico
tags: [facturatie, btw, compliance, risico, ZekerWet]
project: ZekerWet
---

Twee facturatiedefecten in [[ZekerWet]] zijn op 9 september 2026 bewust geparkeerd. Dit is een
besluit, geen omissie. Deze notitie is zo geschreven dat ze zonder reconstructie aan een accountant
kan worden overhandigd.

> [!warning] Wat hier staat is een technische bevinding, geen fiscaal advies.
> De vaststelling dat Stripe geen BTW-regel meestuurt is met zekerheid uit de code af te leiden.
> Of dat een probleem is, en hoe groot, is een vraag voor een accountant.

## Bevinding 1: abonnementsfacturen vermelden geen BTW-component

Bij `mode: 'subscription'` maakt Stripe zelf facturen aan. Omdat er nergens in `src/` een
belastinginstelling staat, bevat die factuur alleen het bedrag.

Vastgesteld in de code op 9 september 2026: geen `automatic_tax`, geen `tax_behavior`, geen
`tax_rates`. Het bedrag komt uit `unit_amount` in `src/services/stripe.service.ts` regel 255 voor
abonnementen en regel 379 voor losse documenten. Het bedrag dat de klant betaalt is dus precies het
bedrag dat op de site staat.

Gevolg: een abonnee ontvangt van Stripe een factuur van bijvoorbeeld 24,99 euro zonder vermelding van
het BTW-bedrag en zonder het tarief. ZekerWet handelt onder BTW-nummer NL005206648B68, en een factuur
die het BTW-bedrag en het tarief niet noemt is geen volledige Nederlandse BTW-factuur.

Wie het raakt: elke abonnee. Op dit moment zijn dat er nul tot enkele.

Wat een oplossing kost: Stripe Tax inschakelen en de prijzen als BTW-inclusief markeren
(`tax_behavior: 'inclusive'`), zodat Stripe het BTW-bedrag berekent en op de factuur zet zonder dat
het totaalbedrag verandert. Dat is een instelling plus een aanpassing in de checkout-aanmaak. Het
raakt betaalstromen, dus het hoort een eigen wijziging te zijn met een test op een echte transactie.

## Bevinding 2: bij losse documenten wordt helemaal geen factuur aangemaakt

De checkout voor een los document draait in `mode: 'payment'` zonder
`invoice_creation: { enabled: true }`. Stripe maakt in dat geval geen factuur. Het enige wat de klant
krijgt is de bevestigingsmail van ZekerWet zelf.

Die mail is inhoudelijk correct: hij rekent 14,99 euro terug naar 12,39 euro netto plus 2,60 euro
BTW, vermeldt ordernummer en datum, en noemt zichzelf een bewijs van aankoop. Het is alleen geen
factuur uit de boekhouding.

Wie het raakt: elke koper van een los document.

Wat een oplossing kost: `invoice_creation` aanzetten op de payment-sessie. Kleiner dan bevinding 1,
maar het hoort in dezelfde wijziging omdat de BTW-behandeling dezelfde is.

## Wat wel is opgelost op 9 september

De bevestigingsmail beloofde: "De volledige factuur vind je in je dashboard onder Facturen." Die
sectie bestaat niet. Het dashboard heeft `documents`, `new`, `review` en `settings`. Dat was de enige
van de drie bevindingen die zeker tot een supportbericht zou leiden, en het was geen fiscale vraag.
De zin beschrijft nu wat de klant daadwerkelijk heeft. Er is bewust geen Facturen-pagina gebouwd.

## Waarom geparkeerd

Bij het huidige klantaantal is de blootstelling klein, en de week is meer waard aan het uitkrijgen
van content dan aan een boekhoudkundige verbouwing. Bewust genomen op 9 september 2026.

## Wanneer dit weer op tafel komt

Elk van deze drie is genoeg om het besluit te herzien:

1. Een klant vraagt om een factuur. Dan is het niet langer theoretisch.
2. Een zakelijke klant wil de BTW terugvorderen. Zonder BTW-vermelding op de factuur kan dat niet, en
   dat is een reden om niet te kopen.
3. De eerste BTW-aangifte waarvoor uitgaande facturen nodig zijn. Dan moeten de records er zijn over
   de hele periode, niet vanaf het moment dat het wordt opgelost.

Komt een van die drie voorbij, dan gaat deze notitie mee naar de accountant en wordt de fix ingepland
voordat het aantal klanten groeit.

Zie ook [[subscription-provisioning]] en [[klant-murmurly]].
