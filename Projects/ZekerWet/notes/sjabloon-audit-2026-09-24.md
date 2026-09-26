---
type: audit
date: 2026-09-24
status: deels opgelost
tags: [sjablonen, juridisch, kwaliteit, audit]
project: ZekerWet
---

Juridische toets van zes sjablonen van [[ZekerWet]] met het grootste risico, op 24 september 2026 door een agent op verzoek van [[Ali Can]]. Alle sjablonen staan in `src/lib/pdf-service.ts` (hieronder ps), de vragen in `src/lib/questions.ts`. De vetgedrukte claims heb ik zelf in de code nagekeken. Hoort bij [[verbetervoorstellen-2026-09-24]].

> [!important] Dit raakt een klant nu al
> [[Yvonne Heiligers]] genereerde op 4 september algemene voorwaarden van het type gemengd B2B/B2C ([[klant-yvonne-heiligers]]). Bij `av_type === 'mixed'` zet de code zowel `isB2C` als `isB2B` op waar (**nagekeken: ps:811-812**), zodat ook consumenten handelsrente en minimaal 40 euro incassokosten krijgen. Dat mag tegenover consumenten niet (6:96 BW). Een document wordt bij openen opnieuw uit het sjabloon gebouwd, dus een reparatie komt ook in haar download terecht. Dat past goed in de terugwinmail.

## Oordeel per sjabloon

| Sjabloon | Oordeel | Belangrijkste gebrek |
|---|---|---|
| Algemene voorwaarden generiek (`terms`, ps:808-931) | ernstig | bij gemengd krijgen consumenten B2B-rente en -incassokosten (**nagekeken**); forumkeuze "bij uitsluiting" (**nagekeken ps:919**), zwarte lijst 6:236 sub n; exoneratie zonder uitzondering voor opzet en bewuste roekeloosheid; verzuim zonder veertiendagenbrief |
| AV B2C dienstverlening (ps:11557) en webwinkel (ps:8219) | ernstig | verwijst naar het vervallen **7:46d BW (nagekeken ps:11603)** in plaats van 6:230o; forum rechtbank Amsterdam (**nagekeken ps:11616**); prijswijzigingsbeding (6:236 sub i); 100 procent vooruitbetaling (maximaal 50 procent, 7:26 lid 2); retourtermijn vrij invulbaar onder de 14 dagen; **ODR-platform, afgeschaft per 20 juli 2025 (nagekeken ps:8258)** |
| Overeenkomst van opdracht (`opdracht`, ps:1117) | kleine gebreken | de zin "geen schijnzelfstandigheid beoogd" wekt schijnzekerheid (na HR Deliveroo is de feitelijke uitvoering bepalend); placeholders `[startdatum]` en `[einddatum]` kunnen blijven staan |
| Arbeidsovereenkomst bepaalde tijd (ps:6830) | ernstig | proeftijd kiesbaar zonder koppeling aan de looptijd, dus een te lange proeftijd is volledig nietig (7:652); **geen tussentijds opzegbeding (nagekeken)**, zodat niemand vóór de einddatum kan opzeggen (7:667 lid 3); vakantiebijslag verwijst naar 7:634 in plaats van art. 15 WML; ketenregeling per 2026 nog toetsen (twijfel) |
| Verwerkersovereenkomst (`dpa`, ps:164-267) | ernstig | **geen teruggave- of verwijderplicht na afloop en geen duur (nagekeken)**, beide verplicht onder art. 28 lid 3 AVG; geen DPIA-bijstand; geen doorleggen van verplichtingen bij subverwerkers (28 lid 4); audit alleen bij vermoeden (twijfel) |
| Privacyverklaring (`privacy`, ps:674-807) | kleine gebreken, dicht tegen ernstig | één grondslag voor alle doelen (hetzelfde gebrek als in het testdocument); geen intrekrecht van toestemming; geen ontvangers; overal 10 jaar bewaren; BSN verkeerd ingedeeld |

Daarnaast bij `employment` ps:1059: het concurrentiebeding heeft een standaardmotivering, en die houdt bij 7:653 lid 2 meestal geen stand.

## Top 5 reparaties

1. Verwerkersovereenkomst: einde en teruggave, duur, DPIA-bijstand, 28 lid 4.
2. Arbeidsovereenkomst bepaalde tijd: proeftijd afleiden uit de looptijd (zoals `employment` ps:948-950 al doet) en een tussentijds opzegbeding.
3. B2C-voorwaarden: forumkeuze schrappen, en bij gemengd geen B2B-rente en -incassokosten voor consumenten.
4. Webwinkel: minimaal 14 dagen afdwingen, het prijswijzigingsbeding repareren, maximaal 50 procent vooruitbetaling.
5. Exoneraties: uitzondering voor opzet en bewuste roekeloosheid; 7:46d en ODR verwijderen.

Twijfelpunten van de agent (lidnummers, de ketenregeling per 2026, de exacte letter in 6:236/237 voor de opzegtermijn) eerst toetsen aan wetten.overheid.nl, vóór er iets aan wordt veranderd.

De top 5 is op 24 september 2026 gerepareerd; wat veranderde en wat bewust bleef staan, staat in [[sjabloonreparaties-2026-09-24]].
