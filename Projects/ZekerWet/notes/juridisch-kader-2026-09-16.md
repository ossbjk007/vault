---
type: note
date: 2026-09-16
status: actief
tags: [juridisch, compliance, ZekerWet]
project: ZekerWet
---

Vraag van [[Ali Can]] op 16 september 2026: mag [[ZekerWet]] zonder rechtendiploma. Bron: generieke kennis van het Nederlandse recht, geen advocaat geraadpleegd, geen vault-bron.

> [!info] Kern
> Juridisch advies en het opstellen of verkopen van contracten is in Nederland een vrij beroep. Er is geen diploma, vergunning of registratie voor nodig. [[Rocket Lawyer]], [[Legalflow]] en [[Lawsy]] werken op hetzelfde principe. Alleen drie dingen zijn wettelijk voorbehouden en daar zit ZekerWet niet: procederen namens een klant bij rechtbank of hof (procesmonopolie advocaat, Advocatenwet), notariële akten zoals statuten, hypotheekakten en leveringsakten (Wet op het notarisambt) en exploten (deurwaarder).

Wat wel telt, in volgorde van echt risico:

1. **Titels.** "Advocaat" en "mr." zijn beschermd, misbruik is strafbaar (art. 435 Sr). "Jurist" is niet beschermd maar wel misleidend als er geen jurist achter zit. Nooit in copy suggereren dat een advocaat of jurist documenten heeft nagekeken, tenzij dat zo is. Valt onder het bestaande claims-regime in `marketing/data/claims.json`.
2. **Misleiding en oneerlijke handelspraktijken** (art. 6:193a e.v. en 6:194 BW). Beloftes als "juridisch waterdicht" of "goedgekeurd door specialisten" zijn het echte gevaar, niet het ontbreken van een diploma.
3. **Aansprakelijkheid** bij een fout in een document (art. 6:74 en 6:162 BW). Bij ondernemers is uitsluiting in algemene voorwaarden goed mogelijk. Bij consumenten beperkt de grijze en zwarte lijst (art. 6:236 en 6:237 BW) wat je mag uitsluiten, en [[masterplan-commercieel-2026-09-16]] telde 55 van de 233 templates die aan een particulier verkopen. Beroepsaansprakelijkheidsverzekering is een keuze, geen plicht.
4. **AI Act, artikel 50.** Transparantieplicht voor AI-systemen die met mensen communiceren geldt sinds 2 augustus 2026. De AI-vraagbaak en AI-review moeten duidelijk maken dat de gebruiker met AI te maken heeft. Juridische documentgeneratie voor ondernemers is geen hoogrisicocategorie uit bijlage III.
5. **AVG.** ZekerWet verkoopt AVG-documenten, dus de eigen huishouding moet kloppen: privacyverklaring, verwerkersovereenkomst met Google voor de Gemini API, wat er gebeurt met klantdata die in documenten en de vraagbaak belandt.
6. **Wwft, marginaal.** Wie bedrijfsmatig juridisch advies of bijstand geeft bij het oprichten of overdragen van vennootschappen of bij vastgoedtransacties kan onder de Wwft vallen (art. 1a lid 4 Wwft). Kant-en-klare templates verkopen zonder individuele begeleiding valt daar naar alle waarschijnlijkheid buiten. Wordt pas relevant als ZekerWet persoonlijke begeleiding bij BV-oprichting of aandelenoverdracht gaat aanbieden.

Conclusie: de activiteit is legaal. Het risico zit in wat er beloofd wordt en in wat er gebeurt als een document fout blijkt, niet in de vergunning. Punt 1, 2 en 4 zijn met copy en één zin in de interface af te dekken. Punt 3 en 5 vragen een controle van de algemene voorwaarden en de privacyverklaring in de repo.

> [!done] Uitgevoerd op 16 september 2026, commit `a45140d` in de repo
> AV artikel 4, 6 en 11 aangevuld (inclusief BTW, geen individuele juristencontrole, AI-review benoemd, foute invoer uitgesloten). Disclaimer 1a en 1b toegevoegd. AI-review rapport zegt nu letterlijk dat het door AI is gemaakt. Stripe Checkout toont AV-acceptatie en verzoek om directe levering onder de betaalknop, zonder checkbox. Registratiepagina toont AV en privacybeleid. "Opgesteld door Nederlandse juristen" (documentpagina's, metadata) en "Gebouwd door juristen & engineers" (TrustBar) vervangen door "naar Nederlands recht". "500+ ondernemers" en "100+ actieve ondernemers" op vier plekken vervangen door 233 documenttypen en echte eigenschappen. Gecommit, niet gepusht.

> [!warning] Bewust geaccepteerd risico
> De drie verzonnen reviews in `src/components/sections/Testimonials.tsx` (Thomas V., Sanne M., Jeroen K.) blijven staan op besluit van [[Ali Can]] op 16 september 2026, vanwege conversie. Verzonnen consumentenreviews staan op de zwarte lijst van art. 6:193g BW en zijn door de ACM beboetbaar. Trigger om terug te komen: zodra er twee echte quotes zijn (eerste kandidaat [[Yvonne Heiligers]]) de verzonnen quotes vervangen. Niet gedaan en optioneel: "juridisch waterdicht" in `Features.tsx` en `FAQ.tsx` verzachten naar "juridisch onderbouwd".
