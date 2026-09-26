---
type: infrastructuur
date: 2026-09-23
status: actief
tags: [google-cloud, billing, ai-review, accounts, gemini, runbook]
project: ZekerWet
---

Hoe de Gemini-API van [[ZekerWet]] wordt betaald, wie wat mag, en wat je doet als hij weigert. Opgezet in de nacht van 22 op 23 september 2026 na acht uur zoeken ([[ai-review-v2-timeout-diagnose-2026-09-22]]). Lees dit eerst voordat je in een Google-console gaat klikken.

> [!important] De kern in drie zinnen
> Google heeft **twee losse betaalsystemen**: Cloud Billing (in `console.cloud.google.com`) en de **prepaid wallet van de Gemini-API** (in `aistudio.google.com/billing`). De Gemini-API betaalt **alleen uit die wallet**. Het proeftegoed in Cloud Billing geldt uitdrukkelijk niet voor de Gemini-API ("$300 welcome credit … excludes Gemini API", melding van AI Studio op 23 september 2026).

## Wat waar staat

| Onderdeel | Waarde | Eigenaar of beheerder |
|---|---|---|
| Project met de API-sleutel | `gen-lang-client-0268320963`, naam `Default Gemini Project`, aangemaakt 14 maart 2026 | eigenaar `ossbjk@gmail.com` |
| API-sleutel | eindigt op `PKOg`, staat in Vercel als `GOOGLE_AI_API_KEY` (productie, preview, development) | aangemaakt door `ossbjk` in AI Studio |
| Factureringsaccount Gemini (actief) | `01D8AF-E5B96A-37A00E`, naam `ZekerWet Gemini (prepaid)` (hernoemd 24 september), met prepaid wallet. Ontstaan op 23 september rond 00:15 tijdens "Set up prepay"; `Default Gemini Project` is daar sindsdien aan gekoppeld | aangemaakt door `ossbjk`, betaalgegevens toen opnieuw ingevoerd |
| Oud factureringsaccount | `0171DE-46342A-EA9C74`, naam `ZekerWet oud (proeftegoed)` (hernoemd 24 september), type Direct. Draagt het Cloud-proeftegoed, betaalt Gemini niet meer. Sinds 23 september 0 projecten in AI Studio (gecontroleerd) | administrator `zekerwet@gmail.com` en `ossbjk@gmail.com` |
| Gemini-tier | Paid 1, tiercap $250. Naar Tier 2 na $100 verbruik plus 3 dagen na de eerste betaling | |
| Prepaid wallet | op `01D8AF-E5B96A-37A00E`: €5,00 gestort op 22 september (Pacific-tijd), auto-reload aan. Tegoed is niet terugbetaalbaar en vervalt een jaar na aankoop | `ossbjk` |
| Cloud-proeftegoed | €257, geldig tot 22 december 2026, **niet** bruikbaar voor Gemini | |
| Leeg project | `My First Project`, `project-16702456-09d0-4011-842`, door Google ongevraagd aangemaakt | eigenaar `zekerwet`, in organisatie `zekerwet-org`. **Op 24 september 13:13 afgesloten**, definitief weg na 30 dagen; tot dan te herstellen via de pagina met projecten in afwachting van verwijdering |
| Organisatie | `zekerwet-org`, ID `14632152013`, een "standalone organization" die Google automatisch aanmaakt bij de aanmelding voor de gratis proefperiode (naam = gebruikersnaam plus `-org`). Ontstaan op 22 september toen `zekerwet` de proefperiode startte. Kost niets, hoeft niet weg; het Gemini-project van `ossbjk` zit er niet in | eigenaar `zekerwet@gmail.com` |

**Rollen.** `ossbjk` had eerst alleen **Billing Account User**: genoeg om een project aan het factureringsaccount te koppelen, niet genoeg om een prepaid wallet op te zetten (AI Studio zei "Contact your billing account administrator"). Op 23 september heeft [[Ali Can]] `ossbjk` ook **Billing Account Administrator** gemaakt. Daarmee kan `ossbjk` alles zelf: wallet bijvullen, betaalmethode wijzigen, rollen beheren.

**Wat er van de oorspronkelijke opzet over is.** Tot 23 september betaalde het bedrijfsaccount `zekerwet` via `0171DE-46342A-EA9C74`, en `ossbjk` mocht daar alleen aan koppelen. Die opzet is voor Gemini niet meer van kracht: het project hangt nu aan `01D8AF-E5B96A-37A00E`, aangemaakt door `ossbjk`, en `zekerwet` heeft daar vermoedelijk geen rol op. De rollen op het oude account doen voor Gemini niets meer. Wil je de oude verhouding terug (het bedrijf beheert de betaling), zet dan `zekerwet@gmail.com` als Billing Account Administrator op `01D8AF-E5B96A-37A00E`.

## Welk account voor welke handeling

- **AI Studio** (wallet, saldo, tier, sleutels): altijd als **`ossbjk`**. Het account `zekerwet` komt AI Studio niet in: Google stuurt het door naar de pagina over regio, leeftijd en accountverificatie, waarschijnlijk omdat de leeftijd op dat account niet is geverifieerd.
- **Cloud Console** (factureringsaccount, rollen, budgetalerts, projecten verwijderen): `zekerwet` of `ossbjk`, allebei administrator.
- Chrome kiest bij Google-diensten graag het eerste ingelogde account. Gebruik een incognitovenster (Ctrl+Shift+N) en log alleen in met het account dat je nodig hebt.

Directe link naar het juiste scherm, ingelogd als `ossbjk`:
`aistudio.google.com/billing?billing=01D8AF-E5B96A-37A00E&project=gen-lang-client-0268320963`

## Foutbeelden en wat ze betekenen

| Wat de API geeft | Betekenis | Actie |
|---|---|---|
| HTTP 402 "Your prepayment credits are depleted" | Wallet leeg of nooit ingericht | Wallet bijvullen via de link hierboven. Soms zit er vertraging op; na een uur opnieuw proberen |
| HTTP 503 "high demand", of een timeout op 40 s | Capaciteit bij Google. Op 22 september gebeurde dit zolang het project op het gratis tier stond | Tier controleren; op betaald tier opnieuw meten |
| HTTP 429 | Rate limit van het tier | Tier en Rate Limit in AI Studio bekijken |

Een lege wallet betekent dat productie direct plat ligt: elke review faalt binnen een seconde. Sinds 2026 geeft Google hiervoor 402, eerder was het 429.

## Geschiedenis van 22 op 23 september

1. Overdag: productie-reviews faalden met timeouts en 503. Oorzaak bleek: project op het gratis tier. Daarmee waren we ook in strijd met Google's voorwaarde dat een dienst voor klanten in de EER alleen betaald quotum mag gebruiken.
2. Avond: factureringsaccount van `zekerwet` gekoppeld via de rol Billing Account User van `ossbjk`. Tier ging naar Paid 1.
3. 23:32: de hermeting gaf vier keer 402. Cloud Billing bleek volledig in orde (Direct, beide projecten gekoppeld, tegoed onaangeroerd). De oorzaak was de ontbrekende prepaid wallet.
4. 00:10: AI Studio toonde "No prepayment method set up". `ossbjk` mocht dit niet instellen, `zekerwet` kwam AI Studio niet in.
5. `ossbjk` Billing Account Administrator gemaakt, "Set up prepay" doorlopen, melding "Setup complete, Gemini API Paid Tier activated". Die flow vroeg de betaalgegevens opnieuw en maakte daarbij een **tweede factureringsaccount** `01D8AF-E5B96A-37A00E` aan, met een eigen welkomsttegoed van $300 (niet voor Gemini). Het project hangt nu aan dat nieuwe account. Beide accounts heetten `My Billing Account`; sinds 24 september hebben ze eigen namen.

Bron voor de losse wallet: een Google-medewerker op het forum, "Google Cloud Billing payments and the AIS prepaid wallet are separate systems that require separate purchases" (`discuss.ai.google.dev`, draad 180770). Zie ook de API-update over 402 in draad 183654.

## Nog te doen

- Controleren op wiens naam en adres het nieuwe account staat, voor de facturen in de boekhouding, en eventueel `zekerwet@gmail.com` er als administrator bij zetten.

- Budgetalert in `console.cloud.google.com` onder Billing, Budgets & alerts, scope op `gen-lang-client-0268320963`. De caps in de code zijn een tweede slot, geen vervanging.
- Een aparte, heldere foutafhandeling en alert voor 402 in de code, zodat een lege wallet niet als "Interne serverfout" bij de klant aankomt ([[ai-review-v2-timeout-diagnose-2026-09-22]]).
