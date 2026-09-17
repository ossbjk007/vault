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
| `STRIPE_SECRET_KEY` | afrekenen | Stripe-account van de band, nog niet gezet |
| `RESEND_API_KEY` | contactformulier verstuurt echt | staat erin. De eerste sleutel is ingetrokken omdat niemand hem had; de tweede heeft Ali zelf geplakt, want het harnas blokkeert het uitlezen van sleutels |
| `CONTACT_FROM` | afzender | staat op `Back Ignition <noreply@send.backignition.com>`, domein geverifieerd |
| `CONTACT_TO` | ontvanger | staat op `backignition.site@outlook.com,aceberghem@gmail.com`, dus berichten komen bij de bandmailbox en bij Ali binnen. Vervangen door het adres van de band zodra [[Léon van Cappellen]] dat geeft |
| `CONTACT_TO_BOOKING`, `CONTACT_TO_BAND`, `CONTACT_TO_ORDERS` | optioneel, per onderwerp splitsen | Léon |

Zonder deze sleutels geven `/api/checkout` en `/api/contact` netjes 503 en liegt de site niet. Dat is bewust.

## 3. Webshop echt laten verkopen

Nodig van Léon: artikelen met prijzen, maten, voorraad en of ze buiten Nederland verzenden. Daarna `src/data/products.json` vullen (prijzen in centen) en `STRIPE_SECRET_KEY` zetten.

Nog te bouwen zodra er Stripe-toegang is: de webhook die de betaling bevestigt, voorraad afboekt en een bestelbevestiging stuurt. Tot die er is klopt de zin op `/thanks` niet, die belooft een bevestigingsmail. Die zin weghalen of de webhook bouwen, niet laten staan.

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
