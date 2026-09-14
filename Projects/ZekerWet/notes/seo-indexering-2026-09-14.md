---
type: note
date: 2026-09-14
status: actief
tags: [seo, indexering, traffic, ZekerWet]
project: ZekerWet
---

Op 14 september 2026 gemeten hoeveel van [[ZekerWet]] Google kent en hoeveel bezoek de site echt heeft. Aanleiding: de kennisbank is volgens de audit de grootste hefboom, maar nergens in de vault stond een bezoekcijfer.

## Google kent drie pagina's

`site:zekerwet.nl` geeft drie resultaten: de homepage, `/privacy` en `/about`. `site:zekerwet.nl/documenten` en `site:zekerwet.nl/kennisbank` geven nul. De 233 documentpagina's en de 8 kennisbankartikelen die in de sitemap staan bestaan voor Google niet. Alle SEO-inzet tot nu toe, inclusief het aanzegbrief-artikel van 10 september, is dus nog onzichtbaar.

Nagelopen wat het niet is:
- `robots.txt` staat goed: `Allow: /`, alleen `/api/`, `/dashboard/`, `/sign-in` en `/sign-up` dicht, sitemap-regel aanwezig.
- `sitemap.xml` geeft 200 en bevat 234 documenten-URL's en 8 kennisbank-URL's.
- Geen `noindex` op artikelen of documentpagina's, tekst is server-side gerenderd (het artikel over de Wet DBA staat woordelijk in de HTML).
- `www.zekerwet.nl` redirect met 307 naar `zekerwet.nl`, dus geen dubbele host.
- `/documenten` linkt server-side naar alle 233 pagina's, `/kennisbank` naar alle 7 artikelen. De homepage linkt naar `/documenten` en `/kennisbank`. Crawlpad bestaat.

Wat het wel is: de site is nooit bij Google aangemeld. Geen `google-site-verification` meta-tag in de HTML, geen TXT-record in DNS (alleen SPF voor ImprovMX, nameservers bij TransIP), en Search Console onder `ossbjk@gmail.com` heeft nul properties. Google heeft de site dus alleen via toevallige links gevonden en is niet verder gekomen dan de voettekst. Eigen redenering: zonder aanmelding kan het maanden duren voor Google 240 pagina's van een onbekend domein crawlt, met aanmelding plus sitemap meestal dagen tot weken.

## Bezoek, laatste 31 dagen (Vercel Web Analytics, hobby-plan, 15 augustus tot 14 september 2026)

| Week van | Bezoekers | Paginaweergaven |
|---|---|---|
| 10 augustus | 8 | 100 |
| 17 augustus | 5 | 9 |
| 24 augustus | 23 | 74 |
| 31 augustus | 15 | 104 |
| 7 september | 16 | 34 |
| 14 september (maandag) | 4 | 18 |

Herkomst over de hele periode: 49 bezoekers zonder verwijzer (direct, of [[Ali Can]] zelf), 12 van Facebook, 4 van vercel.com (eigen previews), 3 van Google, 3 van Bing, 2 van Stripe checkout, 1 van Instagram, 1 van LinkedIn, 1 van ChatGPT.

Meest bezochte paden: `/` 32 bezoekers, `/sign-in` 20, `/dashboard` 16. De dashboardpaden zijn grotendeels eigen gebruik. Eerste publieke documentpagina is `/documenten/opdracht` met 6 bezoekers, gevolgd door `/documenten/aanzegbrief` met 4. Het aanzegbrief-artikel: 2 bezoekers in vier dagen.

> [!warning] Drie bezoekers uit Google in een maand
> De hele organische zoekstrategie draait op dit moment op drie mensen. Niet omdat de artikelen slecht zijn, maar omdat Google ze niet kent. Dit is de goedkoopste fix in het hele marketingspoor en hij is nooit gedaan.

## Gedaan op 14 september 2026, avond

- Property `https://zekerwet.nl` (URL-voorvoegsel) staat in Search Console onder `ossbjk@gmail.com`, verificatie via HTML-tag in `src/app/layout.tsx` (commit `ca0bead`). Google meldde "Eigendom automatisch geverifieerd" nog voor er op Verifiëren was geklikt.
- `sitemap.xml` ingediend: status Succesvol, 248 ontdekte pagina's.
- Indexering aangevraagd via URL-inspectie voor de kennisbankartikelen. Status vóór de aanvraag: aanzegbrief, wet-dba en rie-arbo "Gevonden, momenteel niet geïndexeerd" (Google kende de URL uit de sitemap maar had hem nooit gecrawld), algemene-voorwaarden en avg-compliance "URL is onbekend bij Google". Alle vijf staan nu in de prioriteitscrawlwachtrij. Daarna ook verwerkingsregister-avg, wat-is-een-nda, `/kennisbank`, `/documenten` en `/documenten/opdracht` aangevraagd. Bij de tweede controle stond `wat-is-een-nda` al op "Pagina is geïndexeerd", binnen een uur na de aanvraag. Dat is het bewijs dat er niets mis was met de pagina's, alleen met de aanmelding.

Elf URL's in de wachtrij op 14 september: acht kennisbank-URL's, `/documenten`, `/documenten/opdracht`. Eén al geïndexeerd.
- Dagquotum voor handmatige aanvragen is ongeveer tien URL's. De 233 documentpagina's komen via de sitemap, niet met de hand.

## Wat er nog moet gebeuren

1. ~~Search Console-property aanmaken~~ Gedaan. Op search.google.com/search-console, ingelogd met `ossbjk@gmail.com`. Dat is op 14 september 2026 gecontroleerd het account waar de Gemini API-key van de app in staat (AI Studio, project `gen-lang-client-0268320963`, key eindigend op PKOg, gelijk aan `GOOGLE_AI_API_KEY` in de repo-`.env`) en het account van de Vercel-team `ossbjk007s-projects`. Alle Google-zaken van ZekerWet op één account; `zekerwet@gmail.com` is alleen de mailbox. Kies "URL-voorvoegsel", vul `https://zekerwet.nl` in. Verificatie via "HTML-tag": kopieer de `content`-waarde van de meta-tag.
2. ~~Tag in de repo zetten~~ Gedaan, commit `ca0bead`. In `src/app/layout.tsx` in het `metadata`-object: `verification: { google: '<waarde>' }`. Next.js zet dan zelf de meta-tag in de head. Eén regel, commit, deploy. Alternatief zonder deploy: TXT-record `google-site-verification=<waarde>` bij TransIP, duurt tot een uur.
3. ~~Sitemap indienen~~ Gedaan, 248 pagina's. In Search Console onder Sitemaps: `https://zekerwet.nl/sitemap.xml`.
4. ~~Indexering aanvragen~~ Gedaan voor de kennisbank. voor de acht kennisbank-URL's via URL-inspectie, één voor één. Dat is de snelste weg voor de pagina's met zoekintentie.
5. **Bing Webmaster Tools** hetzelfde, kan importeren uit Search Console. Bing gaf deze maand evenveel bezoekers als Google.
6. Over twee weken terugkomen: aantal geïndexeerde pagina's in het dekkingsrapport en de eerste zoekwoorden met vertoningen. Dat cijfer hoort dan in [[business]] bij Traffic.

Eigen redenering over wat dit oplevert: niet direct klanten. Wel de voorwaarde waaronder de kennisbank en de 233 documentpagina's überhaupt iets kunnen opleveren. Zonder dit is [[modelovereenkomst-zzp-2026]] een artikel voor twee lezers.
