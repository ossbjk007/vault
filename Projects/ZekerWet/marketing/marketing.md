---
type: project
date: 2026-09-09
status: actief
tags: [marketing, ZekerWet, content]
project: ZekerWet
---

Marketingindex voor [[ZekerWet]].

Sinds 9 september 2026 loopt contentproductie niet meer via losse scripts en handmatige Buffer-acties,
maar via het marketing-systeem in de ZekerWet-repo onder `marketing/`. Dat systeem importeert prijzen,
abonnementsinhoud en de documentcatalogus rechtstreeks uit `src/config/`, zodat marketing geen
productfeiten meer kan verzinnen. De grens is eenrichting: `marketing/` leest uit `src/`, nooit andersom.

Buffer-kanalen (kanaal-ID's, gebruikt door het systeem):
- LinkedIn: `6a8a06f1ccaf649a67f8d130`
- Instagram: `6a8a05baccaf649a67f8ca2e`
- Facebook: `6a8a080accaf649a67f8d4e0`
- Organisatie: `6a8a04711cc81b93d118921a`

X hangt niet aan Buffer. Het gratis plan staat drie kanalen toe en die zijn bezet. X loopt als
handmatig kanaal mee in dezelfde validatiepoort, zie [[cadence]].

## Bestanden in deze map

- [[cadence]]: weekritme, kanalen, hoeveel tijd het kost. Vervangt het oude schema.
- [[brand-voice]]: merkregels, do's en don'ts, zinsritme. Blijft leidend voor mensen.
- [[copy-library]]: taglines, value props, CTA's, hashtags, prijzen.
- [[kwaliteits-check]]: redactionele uitgangspunten. De afdwingbare regels staan in code, in
  `marketing/validate/`, niet in dit bestand.
- [[content-templates]]: strategische analyse van augustus. Inhoudelijk nog geldig.
- [[week3-content]]: historisch, de week die wel gedraaid heeft (24-28 augustus).
- `logboek.md`: wordt gegenereerd uit de Buffer-API. Niet met de hand bijwerken.
- [[logboek-handmatig-tot-2026-09-09]]: het oude handmatige logboek, bevroren. Drie van de zes
  regels waren onjuist.

## Gearchiveerd

Naar `Intelligence/archive/`: het oude schema, de thema-tracker met de 4-weekse rotatie die drie
weken uit de pas liep, en het week4-X-bestand dat de `ONTBREEKT`-placeholder bevatte die op 7 en
9 september live ging.

## Waar het nu staat

Fase 0 en 1 zijn af: de foute prijsclaim van 10 september is gecorrigeerd, de duplicaten van
11 september zijn geannuleerd en gearchiveerd, en de feitenlaag plus claimcontrole draaien.
Volgende stap: de contentopslag (fase 2), daarna de validatiepoort (fase 3). Zie [[ZekerWet]].
