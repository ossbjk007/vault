---
type: project
date: 2026-09-13
status: geparkeerd
tags: [project, hermes, agent, ZekerWet]
project: Hermes
---

[[Hermes]] is de open-source agent van Nous Research die [[Ali Can]] inricht als operator naast [[ZekerWet]]. Hij draait lokaal in de Hermes-desktop-app, leest en schrijft in deze vault, en moet op termijn via Telegram en cron vaste taken overnemen. SOUL.md staat sinds 13 september 2026 goed, zie [[hermes-interview-antwoorden]].

## Rol

Hermes is de schrijver en onderzoeker die concepten in de vault zet. Hij raakt de ZekerWet-repo niet aan, publiceert niets en stuurt niets. Drie vaste taken, in deze volgorde inrichten:

1. Donderdag: kennisbankconcept als markdown in `Projects/ZekerWet/marketing/concepten/`, volgorde bronnen, structuur, tekst, met elke onverifieerbare bewering gemarkeerd. Ali kijkt juridisch na, daarna gaat het via de gewone route de repo in.
2. Zaterdag: vijf social-teksten voor de week erna als concept in dezelfde map, platform-specifiek, met bron en CTA, zodat de zondagse `npm run mkt:approve` uit [[cadence]] gevuld kan worden.
3. Ochtend: één Telegram-bericht met de open taken uit de nieuwste `Daily/`-notitie.

Niet doen: het vijf-operator-team uit de cursusvideo, Reddit, RSS-feeds, watch-skill. Eén merk en een goedkeuringsritueel van tien minuten per week rechtvaardigen geen vijf agents.

## Diagnose 13 september 2026

Sessie-export `C:\Users\acerd\session-export-all\vandaag-chat.md\20260910_220210_40c3b0-hermes-doctor.md` gelezen, 444 berichten.

> [!warning] Oorzaak van het "steeds stoppen": het model
> Hermes draait op `upstage/solar-pro4:free` via Nous Portal. Dat model schrijft 27 keer een tool-aanroep als tekst in plaats van hem uit te voeren (`read_file(...)`, `web_extract(...)`, `hermes sessions export ...` als codeblok), geeft lege antwoorden, lekt Koreaanse en Chinese tekens in Nederlandse zinnen en produceerde één keer een onzinblok ("Immune Respons"). Daardoor eindigt de beurt zonder resultaat en lijkt het alsof hij stopt. De SOUL.md-patches werkten wél, want daar voerde het model de tools echt uit.

Gevolg: Hermes meldde "video-analyse opgeslagen in `Projects/ZekerWet/notes/video-hermes-team-374Pb-wibj8.md`", maar dat bestand bestaat niet. Precies de regel uit SOUL.md over gedaan versus gemeten.

Beveiliging: een GitHub fine-grained PAT met volledige repo-toegang is in de chat geplakt en staat nu vier keer in de export op schijf. Beslissing 14 september 2026: [[Ali Can]] laat het token bewust staan, niet intrekken en niet opnieuw ter sprake brengen. Secrets gaan voortaan alleen via `.env`, nooit via de chat. Het Claude Pro OAuth-token staat als Windows-omgevingsvariabele; het verloopt elke paar uur en Anthropic staat gebruik van abonnementstokens buiten de eigen producten voor zover bekend niet toe. Niet op bouwen.

## Beslissing 13 september 2026: geparkeerd

Alles wat Hermes nu zou doen gebeurt al: concepten en vault via Claude in wmux, valideren en publiceren via de marketingmotor, herinneringen via de bestaande Telegram-taken uit [[handwerk]]. Het unieke van Hermes, doorwerken zonder dat iemand aan staat, is pas waard als er een bewezen ritme is om los te laten. Drie dagen inrichten leverden nul klantgerichte output op, tegen [[focus]] en tegen de eigen SOUL.md-regel over techniek voor klanten.

Terugkomen als één van deze twee waar is:
1. Vier weken op rij zondagbatch en weekartikel gehaald, en het draften mag uit handen.
2. Eerste betalende klanten, en tijd wordt schaarser dan geld.

Dan: OpenRouter betaald met de nieuwste Claude Sonnet als standaard (geen gratis model, die loggen prompts en voeren tools niet betrouwbaar uit), GitHub-token vernieuwen, testtaak kennisbankconcept, daarna Telegram en cron. SOUL.md staat klaar.

Reddit, 14 september 2026: het API-verzoek onder de Responsible Builder Policy is afgewezen. Niet opnieuw aanvragen en niet met een onjuiste niet-commerciële verklaring. Reddit stond al bij "niet doen" hierboven; wat er te halen valt is handmatig antwoorden op vragen van ZZP'ers, en daar is geen API voor nodig.
