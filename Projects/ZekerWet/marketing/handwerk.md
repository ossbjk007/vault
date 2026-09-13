---
type: notes
date: 2026-09-10
status: actief
tags: [marketing, handwerk, ritme]
project: ZekerWet
---

Wat er aan de marketing van [[ZekerWet]] handwerk blijft, en hoe je het doet. Alles wat hier niet in staat, doet het systeem zelf. Zie [[cadence]] voor het weekritme en [[logboek]] voor wat er daadwerkelijk is gepubliceerd.

Elk moment hieronder heeft een geplande taak die je een Telegram-bericht stuurt. Je hoeft dus niets te onthouden, alleen te reageren.

## X-post plaatsen

X hangt niet aan Buffer. Het gratis plan staat drie kanalen toe en die zijn bezet door LinkedIn, Instagram en Facebook. Upgraden is bij het huidige bereik niet te verdedigen, dus dit blijft handwerk.

Je krijgt op het moment zelf de volledige tekst in Telegram, inclusief de link met UTM-tags erin. Kopiëren, plakken op x.com, plaatsen. Daarna bevestigen in de projectterminal, anders telt het als overgeslagen slot en zegt het weekrapport dat terecht.

> [!warning] Pas de tekst niet aan bij het plakken.
> Die tekst is door de validatiepoort gekomen. Een zin die je ter plekke mooier maakt is niet gecontroleerd op prijsclaims, wetsverwijzingen of dode links, en dat is precies hoe de post van 28 mei drieënhalve maand met een onjuiste prijsclaim online stond.

## Weekbatch goedkeuren

Zondagavond, ongeveer tien minuten. In de ZekerWet-repo:

```
npm run mkt:approve
```

Je krijgt de batch van de komende week, de X-teksten om te plakken, en een biolink alleen als die is veranderd. Standaard-tier met een schone poort keurt zichzelf goed; alles wat een prijs, een pakketrecht of een juridische redenering bevat komt bij jou.

Niets goedkeuren is een geldige uitkomst. Dan gaat die week leeg de deur uit en staat dat zo in het rapport, als lege week en niet als lichte week. Stilte telt nooit als ja.

## Kennisbankartikel nakijken

Ongeveer twintig tot dertig minuten per artikel, en dit is het enige stuk dat niemand van je kan overnemen. De poort controleert of een wetsartikel op de toegestane lijst staat, of een route bestaat en of er geen prijs is verzonnen. Hij kan geen enkele inhoudelijke juridische bewering toetsen, want hij weet niet wat art. 7:668 BW zegt, alleen dat het bestaat.

Lees dus specifiek op juridische inhoud: kloppen de termijnen, de bedragen, de vervaltermijnen en de uitzonderingen. Niet op stijl, dat is al gecontroleerd.

Tempo is één artikel per week. Dat is het eerlijke getal, geen streefgetal. Twee per week betekent of sneller schrijven dan het recht toelaat, of sneller nakijken dan verantwoord is op een product dat juridische correctheid verkoopt.

Volgorde ligt vast: modelovereenkomst zzp 2026, dan vaststellingsovereenkomst bedenktijd, dan verbeterplan disfunctioneren voorbeeld. Gekozen op zoekintentie met een documentpagina erachter, niet op wat leuk is om te schrijven.

## Als er een alarm binnenkomt

`ZekerWet Reconciler is down` betekent dat de reconciler drie uur niet heeft gedraaid. Meestal omdat je laptop uit stond. Zet hem aan, dan haalt hij zichzelf in. Blijft het komen terwijl je machine aanstaat, dan is er echt iets stuk.

Een blokkademelding uit de pre-flight betekent dat er iets in de queue staat dat niet meer klopt, meestal omdat een productfeit is veranderd sinds het geschreven werd. Die post gaat niet uit. Dat is de bedoeling, niet een storing.

## Wat je nooit hoeft te doen

Het logboek bijwerken. Dat wordt gegenereerd uit wat [[Buffer]] daadwerkelijk heeft bevestigd, en wat je er zelf in typt is bij de volgende run weg. Eigen aantekeningen horen in het `notes`-veld op het contentobject.

De biolink veranderen. Die staat permanent op `zekerwet.nl/ig` en wordt vanaf de laptop omgeleid.
