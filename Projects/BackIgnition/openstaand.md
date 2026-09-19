---
type: checklist
date: 2026-09-16
status: actief
tags: [backignition, website, openstaand]
project: BackIgnition
---

Wat er nog moet gebeuren voordat de site van [[Back Ignition]] echt werkend online staat. [[Ali Can]] wil hier actief aan herinnerd worden; loop deze lijst na aan het begin van elke sessie over dit project. Achtergrond in [[plan-herbouw]] en [[wensen-leon-2026-09-16]].

## 1. Domein gekoppeld op 17 september

Gedaan in het Versio-paneel van [[Wouter Merks]]: A-record van het hoofddomein van `83.86.15.124` naar `216.198.79.1`, `www` van A naar CNAME `8d94d0a5fef40756.vercel-dns-017.com`, plus de Resend-records op `send` en een `_dmarc` op `p=none`. Mail, SPF, autodiscover en het Sectigo-validatierecord zijn niet aangeraakt.

Let op voor later: bewerken van een bestaand record slaat in dat paneel niets op, verwijderen en opnieuw toevoegen werkt wel.

Nog twee kleine dingen:
- Hun SPF is `v=spf1 include:spf.versio.nl mx a ~all`. Het `a`-mechanisme wijst nu naar het IP van Vercel, dus in theorie mag dat adres namens hun domein mailen. Vercel verstuurt daar geen mail vandaan, dus het risico is klein, maar netter is `a` eruit halen.
- Resend is geverifieerd op 17 september; `CONTACT_FROM` staat nu op `Back Ignition <noreply@send.backignition.com>` en een testbericht vanaf dat adres is afgeleverd.
- De oude site draait nog op `83.86.15.124`, alleen niet meer via het domein. Uitzetten pas in overleg, en bedenk dat daarmee ook hun oude beheerpaneel weg is.

## 2. Environment variables in Vercel

Staan erin: `SITE_URL`, `RESEND_API_KEY`, `CONTACT_FROM`, `CONTACT_TO`. Het contactformulier is op 16 september end-to-end getest en het bericht staat als Delivered in het Resend-logboek. Nog nodig, in het project `back-ignition` van het account `backignition.site@outlook.com`:

| Variabele | Waarvoor | Van wie |
|---|---|---|
| `STRIPE_SECRET_KEY` | afrekenen | staat erin sinds 17 september: beperkte sleutel `back.ignition_webshop` uit het account van de band (`acct_1TQRMoPkTNAquQrF`), alleen Checkout Sessions schrijven. `/api/checkout` geeft nu 400 op een lege mand in plaats van 503 |
| `RESEND_API_KEY` | contactformulier verstuurt echt | staat erin. De eerste sleutel is ingetrokken omdat niemand hem had; de tweede heeft Ali zelf geplakt, want het harnas blokkeert het uitlezen van sleutels |
| `CONTACT_FROM` | afzender | staat op `Back Ignition <noreply@send.backignition.com>`, domein geverifieerd |
| `CONTACT_TO` | ontvanger | staat op `backignition.site@outlook.com,aceberghem@gmail.com`. Moet naar `wouter.merks@hotmail.com` (doorgegeven 18 september door Ali, alles moet daarheen); Vercel-formulier weigerde geautomatiseerd, dus met de hand |
| `CONTACT_TO_BOOKING`, `CONTACT_TO_BAND`, `CONTACT_TO_ORDERS` | optioneel, per onderwerp splitsen | Léon |

Zonder deze sleutels gaven `/api/checkout` en `/api/contact` netjes 503 en liegt de site niet. Dat is bewust.

## 3. Webshop echt laten verkopen

**Toegang geregeld op 17 september:** ingelogd via het account van [[Wouter Merks]], geen teamuitnodiging nodig gebleken. Stap 2 hieronder is klaar. Nog gezien in hun account: een actieve webhook `https://backignition.com/api/webhook` (4 events, van de oude site) en een ongebruikte beperkte sleutel van 28 april; beide opruimen bij stap 3.

**Oorspronkelijke aanpak.** Dat is een ander account dan dat van [[ZekerWet]]: hun oude site draagt een publieke sleutel die begint met `pk_live_51TQRMo`, dus het account-ID begint met `acct_1TQRMo`. Dat van ZekerWet is `acct_1TAetaE2xhFVUSlh`. Voor het koppelen geldt: als het account-ID niet met `acct_1TQRMo` begint, is het het verkeerde account en koppelen we niets.

Route: [[Léon van Cappellen]] of [[Wouter Merks]] nodigt Ali uit via Instellingen → Team, met zijn eigen mailadres. Dan komt er een accountwisselaar in hetzelfde dashboard en hoeft niemand wachtwoorden te delen; zij kunnen de toegang ook weer intrekken. Uitloggen bij het eigen ZekerWet-account is dan niet nodig, en dat is maar goed ook: Stripe's uitlogknop reageert niet op geautomatiseerde klikken.

Daarna, in deze volgorde:

1. Controleren of het account live kan ontvangen: bankrekening gekoppeld, verificatie rond.
2. ~~Een **beperkte** API-sleutel maken die alleen afrekensessies mag aanmaken.~~ Klaar 17 september, `back.ignition_webshop`. Stripe eiste daarbij een verificatielink naar de mailbox van Wouter, geopend in dezelfde browser als het dashboard; dat lukt alleen met de hand in Chrome, niet via het browserpaneel.
3. ~~De webhook opnieuw bouwen~~ Gebouwd en live op 17 september, commit `feb5230`, `api/webhook.js`. Hij vertrouwt het event niet maar haalt de sessie zelf op bij Stripe, mailt de bestelling naar `CONTACT_TO_ORDERS` (anders `CONTACT_TO`) en de bevestiging naar de koper, idempotent per sessie. Bewijs: `POST /api/webhook` met een verzonnen sessie-id geeft `session lookup 404`, dus de beperkte sleutel mag sessies lezen. Endpoint in Stripe nagekeken en `STRIPE_WEBHOOK_SECRET` in Vercel gezet op 17 september; handtekeningcontrole bewezen actief (ongetekend → 400) na commit `6d56ac3`, die de body-parser van Vercel uitzet.
4. ~~Eerst in testmodus een bestelling er helemaal doorheen, dan pas live.~~ Live testbestelling op 18 september 12:05 door [[Léon van Cappellen]]: € 12,00, webhook geleverd met 200 en beide mails verstuurd. Nog terug te storten.
5. `CONTACT_TO_ORDERS` in Vercel op het adres van [[Wouter Merks]] zetten; nu gaan bestelmails alleen naar de outlook-bandmailbox en naar Ali. Facturen maakt Stripe sinds commit `a935ac4` zelf aan.

~~Los daarvan nodig van Léon: artikelen met prijzen, maten, voorraad en verzendgebied.~~ Artikelen en verzendkosten binnen op 18 september en live, zie [[shop-artikelen]]. Foto's staan er sinds 18 september allemaal in. Nog nodig: de echte voorraad per artikel (staat nu op 10).

Voorraad afboeken kan pas als er een echte opslag is; de artikelen staan nu in een bestand in de repo. Bij kleine oplages vinyl is dat het eerste wat misgaat, dus dat is een bewuste keuze om later te maken.

## 4. Juridische pagina's

`/terms` en `/privacy` bestaan nog niet en staan niet in de footer. Nodig: handelsnaam, adres, KVK en btw-nummer. Inhoud: algemene voorwaarden met retour- en verzendbeleid, herroepingsrecht van veertien dagen en het modelformulier voor ontbinding, plus een privacyverklaring. Eerst als concept naar Léon, hij toetst.

Vóór er iets getoond wordt: controleren of de algemene voorwaarden van [[ZekerWet]] consumentenkoop op afstand dekken. Zo niet, dan is het maatwerk en geen standaarduitdraai. [[ZekerWet]] wordt nergens genoemd richting de klant.

## 5. Openstaande vragen aan Léon

Staan allemaal in het rapport `Back Ignition - oplevering.docx` van 17 september (bureaublad en `docs/` in de repo), inclusief de complete lijst bedrijfsgegevens voor de voorwaarden en de privacyverklaring.

- De contactonderwerpen zijn uitgebreid van vier naar zes, doordat "Join the Band" is gesplitst in drummer, bassist en lead guitar. Bevestigen of terugdraaien.
- Wie beheert de huidige site technisch, en wanneer mag die uit?
- Bandfoto's in hoge resolutie, als die er zijn.

## Afgehandeld

- Vijf pagina's met hun eigen teksten, inlogknop weg, geen extra functies. Gecontroleerd tegen zijn zeven punten op 16 september.
- Hero-afbeelding: onderzocht en bewust niet teruggezet. Dat bestand is geen foto maar hetzelfde logo op zwart, dat al als watermerk in het eerste scherm staat. Het wordt nu gebruikt als deelplaatje.
