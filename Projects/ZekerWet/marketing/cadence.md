---
type: notes
date: 2026-09-09
status: actief
tags: [cadans, planning, ZekerWet]
project: ZekerWet
---

Weekritme voor de marketing van [[ZekerWet]]. Vervangt [[schema]], dat een 6-slots week beschreef die
in de hele vault-periode geen enkele keer is gehaald, plus een zondagsscript dat nooit heeft bestaan.

## Wat er per week uitgaat

| Dag | Kanaal | Vorm | Pijler | Hoe |
|---|---|---|---|---|
| Dinsdag 07:45 | LinkedIn | Educational | legal-pain | Automatisch na validatie |
| Woensdag | X | Losse post of korte thread | wisselend | Handmatig, bevestigd in de CLI |
| Donderdag 07:45 | LinkedIn | Product of AI Document Review | ai-review | Goedkeuring vereist |
| Vrijdag 09:00 | Instagram + Facebook | Carousel | document-education | Automatisch na validatie |
| Vrijdag | X | Losse post | wisselend | Handmatig, bevestigd in de CLI |
| Doorlopend | Kennisbank | 1 tot 2 artikelen | SEO | Goedkeuring vereist, altijd |

Vijf social-items plus één tot twee artikelen. De kennisbank is de zwaarste post van de week: 233
documentpagina's staan al in de sitemap tegenover zes artikelen, en zoekintentie heeft geen publiek
nodig. Zie de argumentatie in de architectuurnotitie bij [[ZekerWet]].

## X is handmatig, maar niet vrijblijvend

X hangt niet aan Buffer. Het gratis plan staat drie kanalen toe en die zijn bezet door LinkedIn,
Instagram en Facebook. Upgraden is bij het huidige bereik niet te verdedigen.

Maar handmatig betekent niet buiten het systeem. Een X-post is een gewoon contentobject: dezelfde
velden, dezelfde validatiepoort, dezelfde UTM-regels, dezelfde duplicaatdetectie. Alleen de laatste
stap verschilt. De wekelijkse goedkeuringsronde print de X-posts kant-en-klaar om te plakken, in
dezelfde run waarin de rest wordt goedgekeurd. Eén ritueel, geen losse taak die je vergeet.

Publicatie wordt pas vastgelegd als je het in de CLI bevestigt. Nooit door een regel die vooraf is
geschreven. Een onbevestigd X-item is niet gepubliceerd en telt in het weekrapport als overgeslagen
slot. Als na een maand blijkt dat de plak-stap structureel niet gebeurt, zegt het rapport dat met
zoveel woorden en gaat het kanaal eruit.

## Overgeslagen slots blijven leeg

Als de validatiepoort iets blokkeert, schuift er niets naar voren. Een post die voor donderdag is
geschreven publiceert niet op dinsdag. Een gat is zichtbaar en kost één post; vooruitschuiven
verbergt de storing achter een volle kalender en dat is precies de fout die het oude logboek maakte.
Overgeslagen slots zijn een eigen getal in het weekrapport.

## Wat het kost aan tijd

Zondag de weekbatch goedkeuren, ongeveer tien minuten. Reageren op een blokkade-melding, zelden.
Maandelijks het rapport lezen, een half uur. Dat is het bedienen van het systeem.

Het laten groeien van het bedrijf is iets anders en kost zestig tot negentig minuten per week:
reageren waar de doelgroep al zit, kennisbankconcepten juridisch nakijken, praten met wie er
antwoordt. Dat is niet te automatiseren en op dit moment meer waard dan al het andere bij elkaar.
Het oude budget van drie tot vier uur per week is geschrapt omdat het nooit gehaald is.

## Posting-tijden

LinkedIn dinsdag en donderdag 07:45. Instagram en Facebook vrijdag 09:00. X doordeweeks tussen 08:30
en 09:30 of tussen 17:00 en 18:00.

## Regels per kanaal

LinkedIn is geen X en Instagram is geen Facebook. Fan-out uit één onderwerp levert
platform-specifieke varianten op, geen kopieën. De 8 september-carousel ging woordelijk identiek naar
Facebook en Instagram, inclusief LinkedIn-lange alinea's; de duplicaatregel geldt daarom ook
tussen kanalen onderling en niet alleen binnen één kanaal.
