---
type: context
date: 2026-08-06
status: actief
tags: [systeem, overzicht, geheugenkaart]
---

## Wat er nu in de vault staat

De vault bevat je volledige bedrijfsprofiel: wie [[Ali Can]] is, wat [[ZekerWet]] verkoopt, hoe het merk klinkt, wie de klant is en wat die tegenhoudt, wat het aanbod kost en belooft, en waar [[Ligo]], [[Rocket Lawyer]] en [[Legalflow]] beter zijn dan jij. Je 12-maandens-doel staat in [[strategy]], je weekprioriteiten in [[focus]], je concurrentie-analyse in [[ZekerWet-concurrenten]]. De test-log in [[tests]] en de klantzinnen in [[pain-points]] zijn klaar om gevuld te worden zodra de eerste data binnenkomt. Acceptatietest: 5/5 geslaagd.

## Wat elke automatisering doet

- **Status-board** (`scripts/refresh-status-board.py`): leest alle projecten en schrijft één overzichtstabel naar `Projects/_status.md`. Draai hem als je wilt zien wat er loopt.
- **Cross-chat-sync** (hook): als een parallel gesprek het status-board heeft ververst, zie je dat automatisch terug in je volgende bericht.
- **Focus-drift-detectie** (hook): vergelijkt je focus.md met wat je gisteren hebt gedaan. Loopt het uiteen, dan krijg je één zin als signaal: "Focus zegt X, je activiteit zegt Y. Wat geldt?"
- **Ochtend-briefing** (`Resources/prompts/morning-briefing.md`): kopieer de prompt elke ochtend naar Claude. Je krijgt deadlines, open taken, projectstatus en één opvallend punt uit de vault. Niet meer, niet minder.
- **Auto-commit en push**: elke nacht om 02:00 commit en pusht de vault automatisch naar `github.com/ossbjk007/vault` (privé). Beschermt tegen verlies bij een kapotte of gestolen laptop.

## De drie zinnen die je tegen mij kunt zeggen

- "Wat staat er vandaag op de planning?" (haalt de ochtend-briefing op)
- "Zet deze test erin: [beschrijving, spend, resultaat, beslissing]" (schrijft één regel in `Projects/ZekerWet/notes/tests.md`)
- "Deze klantuitspraak wil ik vasthouden: [quote]" (landt woordelijk in `Projects/ZekerWet/research/voc/`)
