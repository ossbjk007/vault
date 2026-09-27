---
type: plan
date: 2026-09-26
status: actief
tags: [marketing, social, video, meta-ads]
project: ZekerWet
---

Herziening van de social-aanpak van [[ZekerWet]], gestart op 26 september 2026 op verzoek van [[Ali Can]]. Bouw gaat via de werker in de ZekerWet-repo; dit is het besluitdocument. Vervangt op termijn het weekritme in [[cadence]].

## Waar we staan (gemeten)

60 gepubliceerde posts sinds 16 april, 1.892 vertoningen in totaal, gemiddeld 35 en mediaan 23, samen 1 comment en 0 volgers. Facebook gemiddeld 6,4 vertoningen, 10 van 14 posts op 3 of minder. Beste post: LinkedIn-tekst over de vergrijpboete Wet DBA, 315 vertoningen. Ongeveer 46 van 56 echte posts zijn juridische educatie, de rest productpitch; nul klantverhalen, polls, humor of achter de schermen. Bron: `marketing/content/*.json`, doorgerekend.

Oorzaken, met bewijs in de repo:
1. Volume: Instagram en Facebook krijgen één carousel per week ([[cadence]]); feitelijk 2,4 posts per week over alle kanalen, met een gat van 74 dagen in de zomer.
2. Geen video: `FORMATS` kent geen reel (`marketing/schema.ts:12`), Buffer krijgt alleen images als `type: 'post'` (`buffer-client.ts:158,181`).
3. Vormgeving: Pillow, Arial op zwart, tweederde van het vlak leeg, geen beeld of product (`render-deck.py:20-29`).
4. Handwerk per post: copy 63 van 63 door een mens, renderen en hosten op imgbb met de hand, wachtrij max 8 (`schedule.ts:40`).
5. Geen betaalde motor: geen Meta Pixel, en de cookieverklaring belooft er ook geen (`src/app/cookies/page.tsx:100`).

## Referentie: Mirazon

[[Mirazon]] (vriend van Ali, webdesign Niederrhein) heeft de visuele lat: donker verloop, label bovenaan ("Fallstudie"), echte schermbeelden in een device-mockup, logo-merk rechtsonder, vastgezette intropost, cases in plaats van uitleg. Hun groeimodel is geen voorbeeld: 13,9K volgers op 4 posts, en de post van 17 september heeft 5 likes en 2 reacties. Die volgers komen niet uit de content (eigen redenering op basis van die meting).

## Richting

> [!note] Bronnen
> Reels 1,36× het bereik van carrousels, carrousels 6,90% tegen 3,31% engagement; LinkedIn-documentposts 21,77% tegen video 7,35% (Buffer, State of Social Media Engagement 2026, nagekeken). Instagram beveelt sinds 30 april 2026 geen herposters meer aan, watermerken tellen niet als bewerking (TechCrunch, nagekeken). Sends per reach is het zwaarste signaal voor niet-volgers (Mosseri via secundaire bron). Weekmix hieronder is eigen redenering.

- Reels voor ontdekking, carrousels voor bewaren en doorsturen, Stories voor DM's.
- Contentsoorten naast educatie: "Mag dit?", rechtspraak als verhaal, mythe, contract voor en na, POV-sketch ondernemer tegen klant, productdemo, achter de schermen, poll.
- Doelmix per week: 5 Reels, 2 carrousels, 5 tot 7 Stories op Instagram; dezelfde Reels op Facebook en TikTok; 3 documentposts op LinkedIn.
- Betaald: één winnende Reel per week, 5 euro per dag, doel profielbezoek; stoppen na 15 euro zonder profielbezoek onder 0,30 euro.
- Tools: Remotion (gratis tot 3 medewerkers, `LICENSE.md` regel 21) met de officiële `remotion-dev/skills`; eigen Meta-app met Standard Access voor publiceren en insights; officiële Meta Ads MCP op `mcp.facebook.com/ads` pas als er ads draaien. Niet: pipeboard (token via derde partij), HyperFrames op Windows (v0.8, open renderbugs).

> [!warning] Besluiten van Ali (26 september 2026)
> 1. Geen founder-content. Merk blijft brand-only volgens [[brand-voice]]; later eventueel opnieuw opperen als idee, niet uit eigen beweging doordrukken.
> 2. Meta Pixel: nog niet. Kost niets aan licentie, maar vraagt aanpassing van cookieverklaring, privacyverklaring en consentbanner, en levert bij circa 70 bezoekers per maand geen bruikbare doelgroep op. Terugkomen als er ads op aanmeldingen gaan sturen of het bezoek structureel boven de 1.000 per maand komt.
> 3. LinkedIn via de bedrijfspagina, niet via het persoonlijke profiel. Documentposts (PDF-carrousels) als hoofdformat daar. Delen vanaf Ali's eigen profiel alleen af en toe en met de hand: circa 99% van zijn 1.000 connecties is geen doelgroep en ergert zich aan bedrijfsreclame. De Buffer-kanaal-ID `6a8a06f1...` is de bedrijfspagina (type page, gecontroleerd), dus alle LinkedIn-cijfers in het logboek, ook de 315 van de Wet DBA-post, zijn paginacijfers.
> 4. TikTok komt erbij als vierde kanaal, met dezelfde Reels zonder watermerk.

## Status

26 september 2026: onderzoek klaar (drie agents, claims nagekeken), werkprompt fase A naar de werker gestuurd. Besluiten dezelfde avond genomen (zie hierboven) en als aanvulling naar de werker. Volgende stap: voorbeeldrenders van carrousels en drie Reels beoordelen, niets live zonder akkoord. Ali maakt een TikTok-bedrijfsaccount aan. Skills staan sinds 26 september in de repo: 12 Remotion-skills en `frontend-design`. Meta Ads MCP bewust uitgesteld; herinnering op 12 oktober 2026 in de dagnotitie.

Stap 1 klaar op 26 september 2026 (commits `dfb43c8`, `fc63c4b`): carrouselrenderer in Remotion onder `marketing/video/`, vervangt `render-deck.py`. Geist, woordmerk met emerald punt, vier sjablonen (hook met pill, groot getal, voor-en-na, productshot in telefoonframe), JPEG plus PDF voor LinkedIn. 245 marketingtests groen. Nagekeken: renders bestaan en zijn gitignored, niets gepusht. Eén productclaim fout ("vraagt naar de motivering", terwijl het document een vaste motivering invult, `pdf-service.ts:6842`), terug naar de werker. Volgende stap: Reels-pijplijn. Fix in `2939f6f`. Het voorbeelddeck concurrentiebeding gaat niet live zolang het document een vaste standaardmotivering invult: [[sjabloon-audit-2026-09-24]] stelde al vast dat die bij 7:653 lid 2 meestal geen stand houdt, en een post met "laat de motivering niet leeg" naast dat product spreekt zichzelf tegen. Eerst de tweede sjabloonronde (motivering als vraag), dan pas dit deck.
