---
type: notitie
date: 2026-09-27
status: actief
tags: [meta, instagram, facebook, advertenties]
project: ZekerWet
---

Stand van het Meta-bedrijfsportfolio van [[ZekerWet]], nagelopen door Claude in het browserpaneel op 27 september 2026 (alleen gekeken, niets gewijzigd). Portfolio-ID `1586011019756048`. [[Ali Can]] heeft drie portfolio's onder zijn persoonlijke Meta-account; alleen "ZekerWet" is bekeken.

| Onderdeel | Stand |
|---|---|
| Bedrijfsportfolio ZekerWet | bestaat |
| Facebook-pagina ZekerWet | eigendom van het portfolio, 2 volgers |
| Advertentieaccount ZekerWet_Ads | eigendom van het portfolio, nooit een campagne gedraaid |
| Beheerders | alleen Ali (volledige toegang), geen reserve |
| Instagram-profielen | geen enkel profiel toegevoegd |
| Domeinen | geen domein toegevoegd |

Accountverificatie: Meta blokkeerde alle instellingen met "Verificatie nodig". Ali heeft op 27 september geverifieerd, daarna was de blokkade weg.

> [!warning] Waarom Instagram en Facebook niet samen kwamen
> Het Instagram-profiel hangt niet aan de pagina (de pagina toont "Instagram koppelen") en niet aan het portfolio. Dat de openstaande verificatie het koppelen blokkeerde, is een vermoeden, niet vastgesteld.

Koppelpoging via het browserpaneel (27 september): "Instagram koppelen" op de pagina doet niets, en de route Instellingen, Instagram-profielen, Toevoegen komt tot "Aanmelden als zekerwet" (de browser is al ingelogd op Instagram als `zekerwet`) maar eindigt op een lege terugkeerpagina. Het portfolio bleef leeg. De flow verwacht een pop-upvenster dat het paneel niet teruggeeft; koppelen daarom vanuit de Instagram-app op de telefoon.

Blokkadecheck (27 september, avond), omdat [[Ali Can]] overal foutmeldingen kreeg en een blokkade vermoedde. Die blokkade is er niet:
- Business Support Home, Accounts: persoonlijk Facebook-account en alle drie portfolio's (ZekerWet, Hoross, hoross_nl) "Geen problemen met adverteren"; geen accountproblemen in de laatste 30 dagen.
- Instagram `zekerwet`, Accountstatus: alle drie onderdelen (verwijderde content, bereik, functies) groen afgevinkt.
- Instagram `zekerwet` is al een professioneel account en zit in hetzelfde Accountcentrum als Ali's Facebook, met de ZekerWet-pagina onder "Pagina's die je beheert".
- Geen van de twee andere portfolio's heeft een Instagram-profiel, dus zekerwet zit niet elders vast.
- Eén afgeronde supportcase: "Bedrijfsmiddel of gegevensbron koppelen", 9 mei 2026.

Volgorde van herstel:
1. Instagram aan de pagina koppelen via "Instagram koppelen" in Business Suite. Het profiel moet een professioneel account zijn (zakelijk of creator).
2. Instagram-profiel toevoegen aan het portfolio: Instellingen, Instagram-profielen, Toevoegen.
3. Domein `zekerwet.nl` toevoegen onder Domeinen en verifiëren. Kan met een TXT-record bij TransIP (SPF-record `v=spf1 include:spf.improvmx.com ~all` laten staan) of met een meta-tag via `verification.other` in `src/app/layout.tsx`, zoals bij Search Console in [[seo-indexering-2026-09-14]].
4. Tweede beheerder toevoegen als reserve, zodat een blokkade op Ali's account niet het hele portfolio vastzet.

Hoort bij het socialspoor in [[groeiplan-social-2026-09-26]]; fase B (Meta-app) hangt van deze stand af.
