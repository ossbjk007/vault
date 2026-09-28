---
type: prompt
date: 2026-09-27
status: klaar-om-te-plakken
tags: [prompt, claims, werker]
project: ZekerWet
---

Werkerprompt voor de claimfix op de site van [[ZekerWet]], naar aanleiding van vault-regel 27 (besluit van [[Ali Can]] op 27 september 2026). Hoort bij [[groeiplan-social-2026-09-26]]. Plakken in de werker-terminal; alles onder de streep.

---

Nieuwe opdracht van Ali: haal de garantieclaims en de jurist-review-zinnen uit de verkoop- en marketingteksten en zet dit live. Rond eerst stap 2 af en commit hem; dit komt als aparte commit(s) erna, stap 3 pas daarna. Meng dit niet met ongecommit werk.

WAAROM
Klanten komen naar ZekerWet om geen jurist of advocaat nodig te hebben; dat is het verkoopargument. "Klaar voor jurist-review" en "laat nakijken door een jurist" laten het platform incompetent lijken. "Juridisch correct", "juridisch sluitend" en "AVG-proof" zijn garanties die we niet kunnen waarmaken. De bescherming zit al in de footer (Footer.tsx:118), de terms (art. 11) en /disclaimer; die blijven ONGEWIJZIGD. Nieuwe toon: zelfverzekerd en feitelijk. Basisformulering: "opgesteld volgens de Nederlandse wet".

A. SITE (src/)
1. documenten/[slug]/page.tsx:
   - :119 wordt "…op basis van jouw specifieke situatie en opgesteld volgens de Nederlandse wet, zodat je direct een professioneel document in handen hebt."
   - :131 "Klaar binnen 3 minuten": getal uit de description van dat document ("Klaar in N minuten"), anders "Klaar in enkele minuten".
   - :148 badge "AVG-proof & juridisch correct": vervangen door iets feitelijks dat de badge ernaast ("Opgesteld naar Nederlands recht") niet herhaalt. Voorstel: "Zonder afspraak of wachttijd".
2. about/page.tsx:110-115: het "95%" en de "resterende 10% … aan een jurist" gaan eruit. Voorstel: "Het resultaat: documenten opgesteld volgens de Nederlandse wet, zonder afspraak bij een advocaat en voor een fractie van de prijs." Niet beweren dat we een advocaat vervangen.
3. questions.ts descriptions :1027, :2009, :7961, :7997: alleen "Juridisch correcte" of "Juridisch sluitende" weglaten, verder niets.
4. kennisbank/[slug]/page.tsx:122 en de artikelen in src/content/kennisbank/ (aanzegbrief-voorbeeld, algemene-voorwaarden-opstellen, avg-compliance-ondernemers, modelovereenkomst-zzp-2026, rie-arbo-compliance, verwerkingsregister-avg, wat-is-een-nda, wet-dba-zzp):
   - "Getoetst aan Nederlands recht, klaar voor jurist-review" wordt "Opgesteld volgens de Nederlandse wet".
   - "Laat juridisch belangrijke documenten altijd nakijken door een jurist voor ondertekening." gaat eruit. De zin "Dit artikel …" blijft en moet zelf "geen juridisch advies" of "algemene informatie" bevatten.
NIET aanraken: Footer, terms, disclaimer, pdf-service.ts, ComplianceReport.tsx:352, review-pdf.ts:151. Die laatste twee zijn uitvoer van de AI Review en blijven als bescherming.

A2. VERKOOPTEKST DIE BLIJFT VERKOPEN (besluit Ali 27-09)
9. documenten/page.tsx:81 "Professionele documenten opgesteld door juridische experts." gaat eruit (er werkt geen jurist aan de sjablonen). Nieuw: "Op maat voor jouw situatie, opgesteld volgens de Nederlandse wet en in enkele minuten klaar." De zin erna ("Koop los of genereer onbeperkt met een abonnement.") blijft.
10. documenten/page.tsx:86-88 kostenanker "Gemiddelde advocaatkosten: €150–350 per uur. ZekerWet: vanaf …": een gemiddelde als bandbreedte zonder bron leest amateuristisch. Vervang door één onderbouwd getal met bronvermelding in klein grijs: "Een advocaat rekent gemiddeld €241 per uur. Bij ZekerWet heb je een document vanaf {formatPrice(DOC_TIER_PRICES.basis)}." met daaronder in text-xs muted "Gemiddeld uurtarief zzp-advocaat, excl. btw. Bron: Knab Zzp Uurtarievenboekje 2026." Stijl rustiger dan nu: niet in primary-kleur, gewone muted tekst, zodat het niet als kortingsactie oogt.
11. documenten/[slug]/page.tsx:164-166 "Bij een advocaat: €350+ voor een vergelijkbaar document. Dat is een besparing van meer dan 90%.": "€350+" en "90%" hebben geen bron. Vervang door: "Een advocaat rekent gemiddeld €241 per uur (excl. btw). Bij ZekerWet betaal je {formatPrice(price)} eenmalig en heb je het document in enkele minuten." met dezelfde bronregel. Geen percentage. Het kader mag blijven, maar rustiger (geen primary-accent op het advocaatbedrag).
12. claims.json: voeg statistic toe, id advocaat-uurtarief-2026, waarde 241, eenheid euro per uur excl. btw, bron https://bieb.knab.nl/wat-verdient-een-advocaat-zzp-bekijk-uurtarief-en-winst (Knab Zzp Uurtarievenboekje 2026, onderzoek onder 20.000 zzp'ers), status approved. Marketing mag dit getal alleen met die bron gebruiken.

B. MARKETING (marketing/)
5. claims.json:
   - productClaim :350 wordt "opgesteld volgens de Nederlandse wet".
   - bannedPhrases erbij: "juridisch correct" (stam), "juridisch sluitend", "AVG-proof", "jurist-review" en "nakijken door een jurist".
   - Reden bij "vervangt een advocaat" (:372) wordt: overclaim, geen juridisch advies. De ban blijft.
6. validate/rules.ts:251 en draft-week.ts:24: de jurist-disclaimer is niet langer verplicht. Historische content/*.json en corpus/ niet herschrijven. Gepubliceerde items mogen niet van status veranderen.
7. reels/*.json CTA's en productshot-body's in decks/*.json naar de nieuwe formulering. capture.ts:46/65 blijft; nieuwe bans erbij.
8. Test: scan src/app, src/components, src/content en de questions.ts-descriptions op alle bannedPhrases. Uitgezonderd: pdf-service, ComplianceReport, review-pdf, terms, disclaimer, Footer en tests.

OPLEVEREN
- Productsuite, marketingsuite, typecheck en `npm run build` groen.
- Controleer dat marketing/video/ niet in de root-build of -lint meegaat.
- Push naar main en wacht tot de Vercel-productiedeploy op Ready staat.
- curl tegen productie: /documenten/opdracht, /about, /kennisbank/aanzegbrief-voorbeeld en /kennisbank/wet-dba-zzp. Oude zinnen weg, nieuwe erin, footer en /disclaimer ongewijzigd.
- Rapport naar sessie vault-e8: hashes, deploy-ID, curl-uitslag en testaantallen.
- Faalt de build of de deploy: niet forceren, rapporteren.

Nagelopen (adviessessie, 27-09): vindplaatsen uit grep -rni op "juridisch correct|AVG-proof|juridisch sluitend|jurist-review|nakijken door een jurist" over src en marketing; bescherming in Footer.tsx:118, terms/page.tsx:78 en :211-234, /disclaimer; poortregel rules.ts:251; draftconstante draft-week.ts:24. Bron uurtarief nagekeken op bieb.knab.nl ("€ 241 per uur (excl. btw)", 20.000 zzp'ers). Niet nagelopen: homepage buiten deze stammen, transactiemails, OG-afbeeldingen. Andere vindplaatsen melden, niet zelf breder gaan.

---

AANVULLING 27-09 14:05 (restanten na productiecontrole, adviessessie)
Productie is gemeten na deploy van 551b385: de hoofdfix staat live. Drie restanten, zelfde regel 27, als één kleine commit plus push en dezelfde curl-controle:
13. src/app/documenten/page.tsx:24, meta description (Google-snippet): "— opgesteld door juridische experts conform BW en AVG." wordt "— op maat, opgesteld volgens de Nederlandse wet en in enkele minuten klaar."
14. src/app/about/page.tsx:102-110:
    - "doorgaans tussen de €500 en €2.000 voor — terwijl 90% van die documenten boilerplate is die elke jurist uit een template haalt." wordt "al snel meerdere uren voor, tegen gemiddeld €241 per uur bij een advocaat (excl. btw, Knab 2026). Terwijl het grootste deel van die documenten standaardwerk is."
    - "ZekerWet automatiseert die 90%." wordt "ZekerWet automatiseert dat standaardwerk."
    - "in drie minuten" wordt "in enkele minuten".
15. src/app/about/page.tsx:166 "Voor 95% van de standaard compliance-vragen" wordt "Voor de meeste standaard compliance-vragen". De rest van die sectie (160-170, "Wat we niet zijn") blijft ongewijzigd; dat is bescherming.
Controle: curl /documenten en /about, zoek op "juridische experts", "95%", "90%", "€500", "2.000"; allemaal 0. Rapport naar vault-e8.

