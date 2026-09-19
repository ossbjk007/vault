---
type: reference
date: 2026-09-18
status: actief
tags: [backignition, webshop, artikelen, marge]
project: BackIgnition
---

De zes artikelen die de band op 18 september 2026 aan [[Ali Can]] doorgaf voor de webshop van [[Back Ignition]]. Verkoopprijzen en omschrijvingen staan in de repo in `src/data/products.json` (centen); dit is de enige plek met de inkoopprijzen, want die horen niet op de site.

| Artikel | id | Inkoop | Verkoop | Marge per stuk |
|---|---|---|---|---|
| Limited Edition Deluxe Demo Box | `deluxe-demo-box` | € 15,71 | € 25,00 | € 9,29 |
| Limited Edition Demo CD | `demo-cd` | € 1,53 | € 9,50 | € 7,97 |
| Limited Edition Demo USB flash drive | `demo-usb` | € 5,39 | € 11,50 | € 6,11 |
| Patch | `patch` | € 1,20 | € 3,50 | € 2,30 |
| Patch Deluxe | `patch-deluxe` | € 3,48 | € 6,50 | € 3,02 |
| Cap | `cap` | € 10,55 | € 17,50 | € 6,95 |

Verzendkosten Nederland € 8,50, doorberekend aan de koper en op wens van de klant als aparte regel in de mand (subtotaal, verzending, totaal). Voor andere landen is geen tarief gegeven, dus Stripe Checkout laat alleen een Nederlands verzendadres toe. Geen gratis-verzenddrempel: de oude drempel van € 50 uit het prototype is eruit, omdat de band die nooit heeft afgesproken en hij bij een Deluxe Box plus Cap € 8,50 van de marge zou kosten.

> [!warning] Nog te bevestigen bij de band
> Voorraad per artikel. Alles staat nu op 10 als tijdelijk getal; de shop toont "Only N left" onder de 5 en "Sold out" bij 0, en het afrekenen weigert boven de voorraad. De voorraad wordt niet automatisch afgeboekt (staat in een bestand, niet in een database), dus bij een uitverkocht limited-edition-artikel moet het getal met de hand op 0. Foto's staan er sinds 18 september allemaal in: box 9, cd 6, usb 6, patch 6, patch deluxe 9, cap 5, in `src/assets/shop/` als JPEG 1200x1600, paden in `products.json` onder `images` (de eerste is de hoofdfoto, de rest kleine keuzeknoppen onder de grote foto). Naar Stripe gaan de eerste acht per artikel.

Stripe-kant: elke bestelling gaat als losse regels met naam, omschrijving, foto-url en `sku` in de metadata naar Checkout, de verzendregel heet "Shipping (Netherlands)". Getest op 18 september met een echte live-sessie (patch plus twee cd's, € 31,00 inclusief verzending), niet betaald. Categorieën in de shopfilter: cap onder Clothing, patches onder Accessories, cd, usb en box onder Music.
