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

## Search Console-meldingen van 16 september 2026, gelezen op 17 september

Twee mails van Search Console (16 september, 22:29 en 22:35) met dezelfde inhoud: "Dubbele pagina zonder door de gebruiker geselecteerde canonieke versie". De derde mail is de standaard welkomstmail over het verkeersrapport, geen actie.

Stand van het dekkingsrapport (laatste update 14 september): 10 geïndexeerd, 238 niet geïndexeerd, waarvan 231 "Gevonden, momenteel niet geïndexeerd" (de documentpagina's uit de sitemap, wachtrij), 6 "Gecrawld, momenteel niet geïndexeerd" en 1 met het canoniek-probleem. Die ene is de homepage zelf, `https://zekerwet.nl/`.

Oorzaak, via URL-inspectie en de repo bevestigd. Google heeft `https://www.zekerwet.nl/` als canonieke versie gekozen omdat de redirect van www naar apex in `next.config.mjs` regel 45 op `permanent: false` staat, dus een 307. Een tijdelijke redirect betekent voor Google: het origineel blijft de echte URL. Daarbovenop heeft de homepage geen `<link rel="canonical">`: `src/app/layout.tsx` heeft geen `metadataBase` en `src/app/page.tsx` geen `metadata`-export. Subpagina's als `/about` hebben wel een canonical, maar relatief (`href="/about"`), omdat `metadataBase` ontbreekt. Kennisbank- en documentpagina's hebben er geen. De Vercel-aliassen (`zekerwet-ossbjk007s-projects.vercel.app`) zijn geen boosdoener: die sturen `X-Robots-Tag: noindex`.

Gevolg zolang dit blijft staan: de homepage komt niet in de index, en elke pagina die Google via www binnenkrijgt kan hetzelfde lot krijgen.

Fix, drie regels in de [[ZekerWet]]-repo:
1. `next.config.mjs` regel 45: `permanent: false` naar `permanent: true` (308).
2. `src/app/layout.tsx` in `metadata`: `metadataBase: new URL('https://zekerwet.nl')`, zodat alle canonicals absoluut worden.
3. `src/app/page.tsx`: `export const metadata: Metadata = { alternates: { canonical: '/' } }`.
Daarna in Search Console bij dat probleem op "Oplossing valideren" klikken en de homepage opnieuw laten inspecteren.

Het comment bij regel 45 zegt "deliberately not cached while we stabilise"; die reden (Clerk-sessie over host-hop) is niet afhankelijk van 307 versus 308, de redirect zelf blijft gelijk.

## Uitgevoerd op 17 september 2026, middag

Commit `9ceec09` in de [[ZekerWet]]-repo, alle drie de regels, typecheck schoon, Vercel-deploy `dpl_2gTerU69QiiRentAGYPwtqqf9qgL` READY. Tegen productie gecontroleerd: `www.zekerwet.nl/` en `www.zekerwet.nl/privacy` geven nu 308 naar apex, de homepage rendert `<link rel="canonical" href="https://zekerwet.nl">`, `/about` is van relatief naar `https://zekerwet.nl/about` gegaan, de Search Console-verificatietag staat er nog.

In Search Console: "Oplossing valideren" gestart op 17-09-2026 voor het canoniek-probleem. Live-test van de homepage: "URL is beschikbaar voor Google". Indexering opnieuw aangevraagd, homepage staat in de prioriteitscrawlwachtrij. Het dekkingsrapport loopt achter (laatste update 14 september); of de homepage echt in de index komt blijkt bij de controle van 28 september.

Tweede commit dezelfde middag, `972cb84`: canonical op `/documenten`, `/documenten/[slug]`, `/kennisbank`, `/kennisbank/[slug]` en `/pricing`. `/pricing` had tot dan helemaal geen eigen metadata (client component, erfde titel en beschrijving van de homepage); nu een `pricing/layout.tsx` met eigen titel, beschrijving en canonical. Sitemap: `lastModified` verwijderd, stond op `new Date()` per request zodat elke URL bij elke crawl gewijzigd leek. Tegen productie bevestigd op negen routes, sitemap 248 URL's zonder `lastmod`.

Wat er nu nog open staat aan SEO-hygiëne, eigen redenering, niet uit de vault:
- Geen Open Graph-afbeelding op geen enkele pagina, dus een gedeelde link op LinkedIn of X heeft geen beeld. Eén `opengraph-image.png` in `src/app/` is genoeg voor de hele site.
- Geen structured data. Voor de kennisbank is `Article`-JSON-LD met `datePublished` het meest waard, maar `ArticleMeta` heeft geen datum. Eerst een `published`-veld per artikel, dan het schema.
- `documenten/[slug]` heeft twee keer `generateMetadata` (layout én page) die hetzelfde berekenen; de page wint. Harmless, wel dubbel onderhoud.
- Kennisbankartikelen hebben geen zichtbare publicatie- of bijwerkdatum op de pagina. Voor juridische content weegt dat mee bij Google en bij lezers.

## 18 september 2026: de vier open punten gebouwd, lokaal gecommit, niet gepusht

Commit `1f23b5f` op lokale `main`, boven twee ongepushte commits van [[Ali Can]] uit een andere terminal (`f21966d` week 39, `c183278` modelovereenkomst-artikel). Bewust niet gepusht: een push zou die twee meenemen en deployen. Alleen eigen bestanden gestaged, index vooraf gecontroleerd.

1. `src/app/opengraph-image.tsx`: site-brede og:image via `ImageResponse`, tekst is de bestaande meta-description.
2. `src/content/kennisbank/published.ts`: publicatiedatum per artikel, uit de eerste git-commit van het bestand. Los bestand, geen veld in `ArticleMeta`, zodat de artikelbestanden ongemoeid blijven. `published.test.ts` bewaakt dat elke slug een datum heeft en geen datum in de toekomst ligt.
3. `kennisbank/[slug]/page.tsx`: JSON-LD `Article` met `datePublished`, plus zichtbare datum naast de leestijd. Geen `dateModified`, want er is geen betrouwbare wijzigingsdatum per artikel.
4. `documenten/[slug]/layout.tsx` verwijderd; de 404-titel staat nu in de page.

Controle: tests 22/22, lint schoon. `tsc` geeft drie fouten uit `.next/types/` die nog naar de verwijderde layout wijzen; dat is een build-artefact dat Vercel opnieuw genereert. Geen lokale `next build` gedraaid om de dev-server in de andere terminal niet te raken. Na de push controleren: `og:image` in de HTML van de homepage, JSON-LD op een artikel, `/documenten/onbekend` geeft de 404-titel.
