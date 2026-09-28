---
type: plan
date: 2026-09-26
status: actief
tags: [marketing, social, video, meta-ads]
project: ZekerWet
---

Herziening van de social-aanpak van [[ZekerWet]], gestart op 26 september 2026 op verzoek van [[Ali Can]]. Bouw gaat via de werker in de ZekerWet-repo; dit is het besluitdocument. Vervangt op termijn het weekritme in [[cadence]].

> [!todo] Hervatten (stand 27 september 2026, 21:00)
> Fase A is af: renderer, Reels met stem, poort, generator en het handmatige postpakket staan in de ZekerWet-repo, lokaal gecommit tot `776a20d` (niet gepusht, alleen `marketing/`). De site is live schoon volgens regel 27 (`da25f99`).
> 1. Werker: week 41 inspreken met de stemmix (ma, wo, vr Thomas v3; di, do Marco), stottercontrole, `mkt:pack` opnieuw. Door de wmux-crash van 27 september 19:10 afgebroken (alleen maandag gerenderd, D2-uitzondering en corpusvelden groen maar niet gecommit); de nieuwe werkersessie `vault-5c` heeft het afgemaakt (`3f17ecf` tot `388958f`, lokaal, 15 commits voor op origin, niet gepusht). Door mij nagekeken: 357 plus 18 tests groen, vijf `reel.mp4` in `marketing/out/week-41/`, geen losse `caption-facebook-reel.txt` meer. 0 tekens betaald, alles uit de cache; teller W39 op 9.012. Luisterpunten: maandag 24,8 s ("één", 120 ms) en woensdag 17,9 s ("zes", 81 ms, mogelijk alleen alignment). Nog untracked: `marketing/video/scripts/_chk.ts`.
> 2. [[Ali Can]]: de vijf Reels met stem bekijken, daarna "akkoord week 41". Pas dan draait de werker stage, approve en schedule.
> 3. Ali vóór 5 oktober: TikTok-bedrijfsaccount, bio-links uit `marketing/out/week-41/CHECKLIST.md`. Posten van 5 tot 9 oktober volgens die checklist, postlinks terug naar de werker voor `mkt:confirm`.
> 4. Optioneel, wacht op Ali's go: kennisbankartikel bedenktijd vso (vóór 9 oktober, de vrijdag-Reel verwijst ernaar), tweede sjabloonronde ([[sjabloon-audit-2026-09-24]]), Instagram-profiel met vastgezette intro, week 42, Stories-sjabloon, de lokale commits pushen.
> Werker aansturen gaat via SendMessage naar de werkersessie; alles met push of deploy via één regel die Ali zelf typt.

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

27 september 2026: drie voorbeeld-Reels gerenderd op 26 september 21:43 (mag-dit concurrentiebeding, rechtspraak Deliveroo `ECLI:NL:HR:2023:443`, productdemo opdrachtovereenkomst), nog niet gecommit; werker staat sindsdien stil. Haak bestond al als verplicht veld op frame 0 (mijn contactsheets misten dat frame); aangescherpt naar maximaal 8 woorden en 60 tekens. Mag-dit-voorbeeld gaat over de aanzegplicht in plaats van het concurrentiebeding. Werker stond niet stil. Volgende stap: stap 2 committen, dan de poort (stap 3).

Stap 2 klaar op 27 september 2026 (`f72e155`): Reels-pijplijn met drie sjablonen (mag-dit, rechtspraak, demo), haak verplicht op frame 0 (max 8 woorden, 60 tekens), ondertitels met woord-highlight, safe zone voor Instagram, Facebook en TikTok in één render, TTS achter een interface zonder leverancier. 258 plus 27 tests groen. Regel 27 doorgevoerd in decks en Reels. Voorbeelden: aanzegplicht (39 s), Deliveroo (39 s), demo opdracht (23 s). Stap 3 (poort, meting, draftgenerator) lokaal, niet pushen; de sitefix loopt via [[claimfix-prompt-2026-09-27]].

Stap 3 klaar op 27 september 2026 (`7003f40`, `61bf31b`, `42fa2be`, lokaal): conceptgenerator (`npm run mkt:draft`) maakt uit één onderwerp uit claims.json een Reel, een carrousel en varianten voor Instagram, Facebook, TikTok en de LinkedIn-bedrijfspagina; alles door de poort, nooit ingepland. Proefweek 41 staat klaar: aanzegplicht, Deliveroo, Wet DBA-vergrijpboete, verwerkingsregister, vso-bedenktijd (5 Reels, 2 carrousels, 3 LinkedIn-documenten). Fase B-voorstel in de repo (`marketing/FASE-B-voorstel.md`): eigen Meta-app met Standard Access, TikTok en LinkedIn voorlopig handmatig, 27 tot 39 uur bouwen. Advies: niet wachten op fase B maar week 41 handmatig posten via Business Suite en TikTok Studio, zodat er deze week al data is; werker maakt het postpakket.

Besluit 27 september 2026: Reels krijgen een AI-stem via ElevenLabs (Starter, $6 per maand), altijd met AI-label bij het uploaden. Reden: kijktijd, en onlabeled realistische AI-audio botst met Meta-regels en met het merk. Geen stemklonen, geen stem die een bestaand persoon nabootst. Geen Gemini: de werker schrijft de teksten. Week 41 heeft één vaste bio-link naar `/documenten` met een eigen meetcode per kanaal.

Stem, 27 september 2026: na vier proefrondes gekozen voor Thomas op ElevenLabs v3 met de tag upbeat (tempo 1,1) als hoofdstem, afwisselend met Marco (v2, ads en social media). Lessen: cijfers altijd voluit uitschrijven voor de stem (anders stottert hij), de hele Reel in één keer laten inspreken, en een vertellersstem op normaal tempo klinkt als een luisterboek. De stem per post staat in het contentobject, zodat kijktijd per stem te vergelijken is. Kosten tot nu toe 6.777 tekens van de 30.000 per maand.
