---
type: project
date: 2026-09-16
status: actief
tags: [project, backignition, klantwerk, website]
project: BackIgnition
---

[[Back Ignition]] is de instrumentale metalband van [[Wouter Merks]] uit Nederland. [[Ali Can]] bouwde op 8 september 2026 een prototype van een nieuwe site als vervanging van backignition.com. [[Léon van Cappellen]] is het aanspreekpunt en stuurde op 16 september de puntenlijst; de band vindt het prototype mooi en wil de site via Ali laten draaien. Dit is klantwerk, volledig los van [[ZekerWet]].

> [!info] Waar alles staat
> Code: `C:\Users\acerd\dev\back-ignition\` (git, remote `github.com/BackIgnition412/back-ignition`, privé; Ali pusht als collaborator `ossbjk007`, commits op naam van `backignition.site@outlook.com`). `index.html` is byte-voor-byte de live site, `build.js` haalt crest en og-afbeelding van backignition.com en bouwt naar `public/`.
> Live: https://back-ignition-back-ignition.vercel.app (Vercel-project `back-ignition` in het eigen team `Back Ignition`, account `backignition.site@outlook.com`, gekoppeld aan de GitHub-repo; elke push naar `main` deployt). Het oude `back-ignition-prototype` in het ZekerWet-team draait nog en moet weg.
> Analyse en screenshots: `docs/` in de repo. Het herbouwplan staat in `docs/herbouwplan.html`.

## Afspraak

Ali bouwt en host gratis voor de band, geen factuur. [[ZekerWet]] wordt nergens genoemd, niet op de site en niet in de stukken. De repo gaat naar een apart GitHub-account, los van `ossbjk007`. Hosting blijft Vercel met hun eigen domein eraan gekoppeld, zoals bij [[ZekerWet]].

## Waarom een eigen GitHub-account

Eén GitHub-identiteit kan maar aan één Vercel-account tegelijk hangen. Op 16 september bleek dat hard: om 15:01 werd het bandproject in het nieuwe Vercel-account aan `ossbjk007` gekoppeld, om 15:07 en 15:09 kwamen twee productie-deploys van [[ZekerWet]] terug als BLOCKED (Vercel verwees zelf naar de pagina over projectsamenwerking), en om 16:19 draaide ZekerWet pas weer na herstel van de GitHub-koppeling. Eindplaatje dat dit voorkomt: Vercel `ossbjk@gmail.com` hangt aan GitHub `ossbjk007`, Vercel `backignition.site@outlook.com` hangt aan GitHub `BackIgnition412`. Nooit één GitHub-account aan twee Vercel-accounts.

Pushen vanaf de laptop gaat via een collaborator-invite van `ossbjk007` op de bandrepo. Dat is schrijfrecht op één repo en iets anders dan de Vercel-koppeling, dus het botst niet. Commits in die repo krijgen `backignition.site@outlook.com` als auteur, omdat Vercel op Hobby een deploy kan blokkeren als de commit-auteur niet bij het account hoort. Testen met één push, niet aannemen.

## Status

Openstaande punten staan in [[openstaand]]. Die lijst is leidend bij elke sessie over dit project.

Site herbouwd volgens [[wensen-leon-2026-09-16]] en live op https://back-ignition-back-ignition.vercel.app. Vijf pagina's met hun eigen teksten, inlogknop weg, shop- en contactmachinerie werkend maar nog niet aangesloten. Domein gekoppeld op 17 september, Stripe-sleutel van de band staat sinds die avond in Vercel (`STRIPE_SECRET_KEY`, beperkt tot Checkout Sessions). Wacht nog op drie dingen van [[Léon van Cappellen]]: artikelen voor de shop, een mailadres voor het formulier, en bedrijfsgegevens voor de juridische pagina's.


Prototype live, klant akkoord. Bron stond tot 16 september alleen in een tijdelijke Claude-map en in de Vercel-deploy; nu veiliggesteld in de repo hierboven.

## Volgende stap

1. Oude project `back-ignition-prototype` in het team van [[ZekerWet]] verwijderen. Let op: dat breekt de link `back-ignition-prototype.vercel.app`, dus eerst nagaan of [[Wouter Merks]] die ergens gedeeld heeft.
2. Eigen GitHub-account voor [[Back Ignition]] aanmaken en de repo daarheen verhuizen, zodat ook de code niet meer op `ossbjk007` staat. Tot die tijd: nooit GitHub `ossbjk007` aan dit Vercel-account koppelen (regel 20 in CLAUDE.md).
3. Wensenlijst van Wouter ophalen en hier onder `## Wensen` zetten, elk punt met wat het is en of het voor of na de domeinkoppeling moet.
4. Domein backignition.com koppelen in het nieuwe Vercel-project: DNS-toegang bij Wouter opvragen, record naar Vercel, daarna in `index.html` de canonical en de og-url van `back-ignition-prototype.vercel.app` naar `backignition.com` zetten.
5. Tweefactor aanzetten op het Vercel-account van Back Ignition.

## Wensen

Binnen op 16 september, zie [[wensen-leon-2026-09-16]]. Plan van aanpak in [[plan-herbouw]], nog niet akkoord en nog niets gebouwd.

## Log

- 2026-09-17 avond: Stripe aangesloten. Beperkte sleutel `back.ignition_webshop` (alleen Checkout Sessions schrijven) uit het account van de band `acct_1TQRMoPkTNAquQrF`, door [[Ali Can]] zelf in Vercel gezet. `POST /api/checkout` geeft nu 400 op een lege mand in plaats van 503. Echte sessie nog niet getest, want `products.json` is leeg. Later die avond de webhook gebouwd en live gezet (`api/webhook.js`, commit `feb5230`): bestelmelding naar de band, bevestiging naar de koper. Volgende stap: webhook-secret in Vercel, dan artikelen en één echte testbestelling bij de band op 18 september (zie [[openstaand]] punt 3).

- 2026-09-17: domein gekoppeld. backignition.com en www draaien op Vercel met een geldig certificaat, http stuurt door naar https, canonical en sitemap staan op het echte domein. Het contactformulier is ook vanaf het domein getest en kwam aan. Eén build faalde onderweg omdat `build.js` het logo ophaalde bij backignition.com, precies het domein dat wij overnamen; beelden staan nu in `src/assets` en de site bleef ondertussen draaien op de vorige deploy.

- 2026-09-16 nacht: herbouw af en gedeployd. Teksten komen uit de live instellingen van backignition.com, niet uit de hardgecodeerde HTML; die twee liepen uiteen en verklaren het verschil tussen twee en drie open plekken. De API zegt drie (drummer, bassist, lead guitar), dus daarmee gebouwd. Getest: shop toont maten met uitverkochte varianten doorgestreept, mand blijft staan als afrekenen mislukt, contactformulier meldt eerlijk dat het niet gelukt is in plaats van "Message sent" te tonen. Beide serverfuncties draaien op Vercel en geven 503 tot de sleutels erin staan. Canonical staat tijdelijk op de vercel.app-url tot het domein gekoppeld is.

- 2026-09-16 avond: scheiding afgerond en getest. GitHub `BackIgnition412` gekoppeld aan Vercel `backignition.site@outlook.com`, Vercel-app op dat GitHub-account geinstalleerd, project omgehangen naar `BackIgnition412/back-ignition`. Testpush (commit `4a97897`, auteur `backignition.site@outlook.com`) gaf een READY-deploy, dus de Hobby-regel over commit-auteurs blokkeert niets. Oude repo `ossbjk007/back-ignition` gearchiveerd. zekerwet.nl en de bandsite geven allebei 200, ZekerWet-project onaangeroerd.

- 2026-09-16: rapport `Back Ignition - plan van aanpak.docx` opgeleverd (6 pagina's, 1667 woorden), zelfde opmaak als de site-analyse. Bron in de repo onder `docs/plan-van-aanpak.html`, kopie op het bureaublad.

- 2026-09-08: prototype gebouwd en gedeployd, analyse van de oude site in `docs/analyse/`.
- 2026-09-16: eigen Vercel-account `backignition.site@outlook.com` met team Back Ignition, GitHub gekoppeld als `ossbjk007`, project `back-ignition` aangemaakt vanuit de repo en gedeployd. Deployment protection uit, site publiek op https://back-ignition-back-ignition.vercel.app, html identiek aan het prototype. De Vercel GitHub-app op `ossbjk007` staat op "alle repo's" en blijft zo, want beperken zou de koppeling van ZekerWet breken.
- 2026-09-16, avond: de GitHub-koppeling van `ossbjk007` aan dit account bleek de productie-deploys van [[ZekerWet]] te blokkeren (een GitHub-account past maar op één Vercel-account). Herstel: GitHub loskoppelen van dit account, opnieuw koppelen aan het ZekerWet-account. Dit repo commit voortaan als `backignition.site@outlook.com` zodat Vercel de auteur aan dit account kan matchen; lokaal ingesteld met `git config`.
- 2026-09-16: klant akkoord, bron uit tijdelijke map naar `dev/back-ignition`, eerste commit, gepusht naar GitHub `ossbjk007/back-ignition` (privé). Besluit: eigen Vercel-account voor Back Ignition, ZekerWet blijft op Hobby.
