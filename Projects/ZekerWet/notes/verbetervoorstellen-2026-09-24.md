---
type: research
date: 2026-09-24
status: actief
tags: [strategie, groei, product, risico]
project: ZekerWet
---

Verbetervoorstellen voor [[ZekerWet]], op 24 september 2026 op verzoek van [[Ali Can]] opgehaald met drie agents. Die bekeken het vanuit groei, product en risico, alleen lezend. Elk voorstel draagt zijn bron: vault, generiek playbook of eigen redenering.

## Groei: van 1 naar 5 betalende klanten in 30 dagen

Gerangschikt op impact gedeeld door moeite.

1. **[[Yvonne Heiligers]] behouden vóór de incasso van 4 oktober** (1 uur). Haar teller op 0 zetten, eerst zelf een review draaien, de inbox nakijken, en dan één mail volgens regel 16 en 21. Pas na een positief antwoord vragen of ze een collega-begeleider kent. Zonder haar begint het doel bij 0. Bron: [[klant-yvonne-heiligers]].
2. **Het Murmurly-patroon als outreach** (8 uur). Controleer 30 sites van coaches, begeleidingspraktijken en vroege AI-startups op één gebrek dat iedereen kan zien: een formulier of chat verzamelt gegevens, maar er staat geen privacyverklaring online. Per treffer een persoonlijke tip met artikel 13 AVG. Verwacht 1 tot 2 klanten op 30 berichten (eigen redenering, geen benchmark). Risico: kan lezen als ambulancejagen, en ongevraagde mail aan eenmanszaken valt onder de Telecommunicatiewet (eerst toetsen), dus daar LinkedIn of bellen. Nooit ongevraagd hun documenten door de review halen. Bron: [[sid-murmurly-benaderingsstrategie-2026-09-24]].
3. **Overstappers van een stoppende concurrent** (4 uur). Het venster loopt tot 31 oktober: bestaande documenten meenemen en met V2 laten nakijken. Maak daar het thema van week 40 van. Het feit is nog niet op de site van de concurrent zelf geverifieerd, en de validatieregel B4_NAMED_COMPETITOR blokkeert de naam. Bron: masterplan A5, [[execution-plan-14-dagen-2026-09-17]].
4. **Het testdocument als openbaar bewijs** (3 uur). Publiceer de fictieve privacyverklaring met de uitslag van V2 als kennisbankpagina en als post: drie gebreken gevonden, geen verzonnen claims. Plus het aanbod "stuur je privacyverklaring, je krijgt dezelfde review". Dat is bewijs in plaats van een belofte tegen bezwaar 1 (betrouwbaarheid), en het is ook materiaal voor voorstel 2, 3 en 5. Bron: [[testdocument-privacyverklaring-begeleiding-2026-09-24]], icp.md.
5. **[[VPKL]] als eigen klant, niet als doorverwijzer** (4 uur, inclusief het gesprek). Op 2 oktober geen aanbod doen, wel de testreview laten zien als antwoord op de vraag waar ze klanten nu heen sturen. Eigen gebruik mag, een vergoeding voor doorverwijzen niet (RB art. 15). Bron: [[kanaal-boekhouders]], [[gesprek-vpkl-patrick]].

Eerlijke optelsom van de agent: 2 tot 4 extra klanten in 30 dagen is haalbaar, 5 is de bovenkant. [[Murmurly]] levert binnen 30 dagen geen omzet op, want de gratis maand loopt eerst af.

## Product en conversie

Gerangschikt op impact gedeeld door moeite. De belangrijkste claims heb ik zelf nagekeken met grep en met `curl` op de live site.

1. **Beloftes op de homepage eerlijk maken en de verzonnen testimonials weghalen** (1 tot 2 uur). **Nagekeken, klopt.** Op zekerwet.nl staat nu "Geen creditcard nodig" (`Hero.tsx:54`, `FinalCTA.tsx:34`), maar de trial-checkout vraagt wel een betaalmethode (`stripe.service.ts:284-295`, geen `payment_method_collection`). Er staat "Eerste Document Gratis" (`HowItWorks.tsx:76`), terwijl er geen gratis document bestaat. En er staan **drie testimonials met naam en vijf sterren (Thomas V., Sanne M., Jeroen K.)** bij één betalende klant. Op een site die compliance verkoopt is dat misleiding in de zin van de ACM. Ook "Binnen seconden" (`Features.tsx:13`) klopt niet: een review duurt 10 tot 20 seconden.
2. **Voorbeeldrapport van V2 op de homepage en als lege staat van de reviewpagina** (3 uur). Het sterkste onderscheid, bevindingen met wetsartikel, is nu nergens te zien. Zonder abonnement is de limiet 0 (`ai-review.service.ts:296-300`).
3. **Onboarding direct na betaling** (3 uur). Een checklist van drie stappen in plaats van de successbanner (`dashboard/page.tsx:152-168`), met de eerste review als stap. Een klant die de review nooit gebruikt, zegt op.
4. **Mails op basis van gebruik en een welkomstmail die echt verstuurd wordt** (5 uur). **Nagekeken:** `WelcomeEmail.tsx` wordt nergens aangeroepen. Wie zich aanmeldt en niet afrekent, hoort nooit meer iets. Drie triggers via een dagelijkse cron: dag 1 zonder checkout, dag 3 van de trial zonder document, en 10 dagen voor het einde van de periode met de review nog ongebruikt.
5. **Eén gratis review na aanmelding, zonder abonnement** (5 uur). De sterkste "aha" vóór betaling. Aanmelden blijft verplicht vanwege kosten en misbruik.
6. **Losse documentaankoop zichtbaar maken** (6 uur). **Gedeeltelijk weerlegd:** de agent zei dat `/api/stripe/checkout-document` nergens wordt aangeroepen, maar `useDocumentCheckout` wordt gebruikt in `dashboard/new/page.tsx` en `BuyDocumentCard.tsx`. Of de publieke pagina's `documenten/[slug]` een koopknop tonen, moet nog worden nagekeken. Eerst testen in Stripe testmodus, want het is een betaalflow.

## Risico's en eigen compliance

1. **De opruimtaak voor bewaarde documenten draait nooit** (15 minuten). **Nagekeken, klopt.** `src/middleware.ts` zet `/api/admin/review-input-cleanup` niet in `isPublicRoute`, terwijl `ai-health` er wel in staat. Live geeft de cleanup-route 404 met `X-Clerk-Auth-Reason: protect-rewrite`. Clerk houdt de cron dus tegen voordat de route zelf draait. De privacyverklaring belooft maximaal 30 dagen. De oudste `ReviewInput` is van 24 september, dus de eerste overschrijding zou op 24 oktober vallen. Er is nog niets te laat, maar dit moet vóór die datum dicht.
2. **Subverwerkerslijst klopt niet met de code** (1 uur). **Nagekeken:** `privacy/page.tsx:145` noemt "Google AI / Vertex", maar de code gebruikt de Gemini Developer API (VS, geen EU-regio). `:139` zegt "Supabase Frankfurt", terwijl de lokale host `eu-west-1` (Ierland) is; of productie dezelfde host heeft is een vermoeden. [[Upstash]] Redis ontbreekt in de lijst, terwijl daar 7 dagen analyses met citaten staan (`cache.ts:50`).
3. **Preview en development draaien op productiegeheimen** (2 uur). Live Stripe-sleutel, productiedatabase en Clerk-sleutel staan ook op `preview` en `development`, als type `encrypted` met `readable-secret`. Een previewbranch raakt echte klanten.
4. **Crons falen stil** (1 uur). Het resultaat van de cleanup leest niemand. Het vermoeden dat ook de kostendigest faalt door `CRON_SECRET` tegenover `AI_HEALTH_CRON_SECRET` is **onwaarschijnlijk**: de digest komt al sinds half september dagelijks binnen.
5. **Back-upbelofte niet onderbouwd** (vermoeden, 1,5 uur). De privacyverklaring belooft back-ups van maximaal 30 dagen, maar er is geen runbook en geen restoretest. Het Supabase-plan nakijken.
6. **"PII wordt gescrubd" in [[Sentry]] niet geïmplementeerd** (vermoeden, 1 uur). Er is geen `beforeSend` in `sentry.server.config.ts`.

Wat goed is: geen geheimen in git, de Stripe- en Clerk-webhooks controleren hun handtekening, de rate limit sluit af bij uitval van Redis, crons vergelijken het token in constante tijd, en het verwijderen van een gebruiker cascadeert naar alle gekoppelde rijen.

## Eindlijst, alle drie samen (eigen redenering)

Eerst wat klein is en een belofte breekt, dan wat klanten oplevert.

| # | Wat | Moeite | Waarom nu |
|---|---|---|---|
| 1 | Cleanup-cron publiek maken en één keer draaien | 15 min | Belofte van 30 dagen over gezondheidsgegevens; deadline 24 oktober |
| 2 | Homepage eerlijk: testimonials weg, "geen creditcard" en "eerste document gratis" corrigeren | 1 tot 2 uur | Misleidend op een compliance-site; VPKL kijkt vóór 2 oktober |
| 3 | Subverwerkerslijst en "Vertex" corrigeren | 1 uur | Eigen AVG-verklaring moet kloppen |
| 4 | Yvonne behouden | 1 uur | Incasso 4 oktober |
| 5 | Welkomstmail aanzetten en mails op basis van gebruik | 5 uur | Aanmelders horen nu nooit meer iets |
| 6 | Voorbeeldrapport op de homepage en het testdocument als openbaar bewijs | 3 tot 6 uur | Het sterkste punt is nu onzichtbaar |
| 7 | Productiegeheimen alleen op production | 2 uur | Voorkomt dat een branch echte klanten raakt |
| 8 | Eén gratis review na aanmelding | 5 uur | Product ervaren vóór betaling |
| 9 | Murmurly-patroon als outreach | 8 uur | 1 tot 2 klanten per 30 berichten |

Uitvoering van punt 1 tot en met 3 staat in [[reparaties-verbetervoorstellen-2026-09-24]].

## Tweede ronde

Meetplan: [[meetplan-funnel-2026-09-24]]. Juridische kwaliteit van de sjablonen: [[sjabloon-audit-2026-09-24]]; vier van de zes zijn ernstig.
