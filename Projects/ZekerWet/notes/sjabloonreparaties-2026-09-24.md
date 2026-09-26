---
type: log
date: 2026-09-24
status: actief
tags: [sjablonen, juridisch, kwaliteit, reparatie]
project: ZekerWet
---

Uitvoering van de top 5 uit [[sjabloon-audit-2026-09-24]] voor [[ZekerWet]], op verzoek van [[Ali Can]] op 24 september 2026. Elk aangehaald artikel is vóór de wijziging nagelezen: het BW en de WML op wetten.overheid.nl, de AVG en de ODR-verordening op EUR-Lex (die staan niet op wetten.overheid.nl).

Commits `f89193f` (verwerkersovereenkomst), `1211cfd` (arbeidsovereenkomst bepaalde tijd), `ac48a85` (voorwaarden) en `342a8b7` (tests), gepusht. Poort: `tsc` schoon, lint zonder nieuwe meldingen, `next build` exit 0, 325 tests groen (was 306). De 19 nieuwe tests bouwen de echte PDF en lezen de tekst terug met `pdf-parse`. Tegen de oude sjablonen falen er 18 van de 19; de enige die slaagt is "30 dagen retour blijft 30", wat de oude code ook goed deed.

## Per sjabloon

**Verwerkersovereenkomst (`dpa`).** Nieuw: artikel over duur, einde en teruggave of verwijdering naar keuze van de verantwoordelijke (art. 28 lid 3 sub g), bijlage A.6 met onderwerp en duur, een artikel bijstand bij art. 32 tot en met 36 (beveiliging, meldingen, DPIA, voorafgaande raadpleging; sub f), verwerking op grond van een wettelijke plicht met voorafgaande kennisgeving (sub a), en een onmiddellijke melding bij een instructie die de AVG schendt (slotalinea lid 3). Sub-verwerkers: bij beide keuzes worden de verplichtingen schriftelijk doorgelegd en blijft de verwerker volledig aansprakelijk (lid 4). De latere artikelen schuiven een nummer op.
Bewust niet aangepast: de keuze "audit alleen bij gegrond vermoeden". Lid 3 sub h eist dat de verwerker audits mogelijk maakt; of een beperking tot een vermoeden daarmee botst is een interpretatievraag, niet vastgesteld. Ook niet: het forum Amsterdam (tussen bedrijven toegestaan) en de TOM-omschrijvingen.

**Arbeidsovereenkomst bepaalde tijd (`arbeidscontract_bepaald`).** De proeftijd volgt nu uit start- en einddatum: geen bij zes maanden of korter (7:652 lid 6 sub a), één maand onder twee jaar (lid 4 sub a), twee maanden vanaf twee jaar (lid 4 sub b). Een te lange keuze wordt verlaagd, want een te lange proeftijd is geheel nietig (lid 8). Zonder geldige datums geen proeftijd. De foute lidverwijzingen (lid 3, 4, 5) zijn in document en vragenlijst verbeterd. Nieuw artikel tussentijdse opzegging (7:667 lid 3) met de termijnen van 7:672 en voor de werkgever 7:669 en 7:671a. Vakantiebijslag verwijst naar art. 15 WML in plaats van 7:634.
Bewust niet aangepast: de ketenregeling (klopt met 7:668a zoals het vandaag luidt; wijziging aangekondigd per 1 januari 2028), de aanzegvergoeding "maximaal één maandsalaris" en de kop "Aanzegging BW Art. 7:668 lid 3" (lid 3 niet nagelezen, dus niet aangeraakt).

**Algemene voorwaarden (`terms`).** Bij gemengd krijgt nu elke regel zijn doelgroep: handelsrente (6:119a) en minimaal 40 euro (6:96 lid 4) alleen voor ondernemers; consumenten wettelijke rente (6:119) en incassokosten pas na een kosteloze aanmaning met veertien dagen (6:96 lid 6). Forumkeuze geldt alleen voor ondernemers; consumenten houden de wettelijk bevoegde rechter (6:236 sub n). Exoneratie wijkt voor opzet en bewuste roekeloosheid. De uitzondering voor digitale inhoud verwijst nu naar 6:230p sub g in plaats van sub n (bij het nalezen gevonden).
Bewust niet aangepast: "van rechtswege in verzuim zonder ingebrekestelling" en de aansprakelijkheidsbeperking tot het factuurbedrag tegenover consumenten (grijze lijst 6:237 sub f, een vermoeden en geen verbod).

**Webwinkel (`algemene_voorwaarden_webwinkel`).** Retourtermijn nooit korter dan 14 dagen, ook als er minder is ingevuld; het formulier zegt nu "wettelijk minimaal 14". Prijsverhoging binnen drie maanden geeft de consument het recht te ontbinden (6:236 sub i). Vooruitbetaling hooguit de helft, tenzij de consument zelf meer kiest (7:26 lid 2). ODR-zin en ODR-procedure weg (Verordening 2024/3228, ingetrokken per 20 juli 2025).
Bewust niet aangepast: modelformulier voor herroeping en retourkosten ontbreken nog; niet gevraagd.

**AV dienstverlening B2C en B2B.** B2C: 7:46d (vervallen per 13 juni 2014) vervangen door 6:230o lid 1 sub a, bij de uitzondering aangevuld met 6:230p sub d; forum rechtbank Amsterdam weg. Beide: exoneratie wijkt voor opzet en bewuste roekeloosheid.
Bewust niet aangepast: aansprakelijkheidsbeperking tegenover consumenten (zie terms), het forum Amsterdam in B2B, en drie andere sjablonen met "rechtbank Amsterdam" buiten deze opdracht.

> [!important] Gevolg voor een klant
> [[Yvonne Heiligers]] genereerde op 4 september gemengde algemene voorwaarden. Een document wordt bij openen opnieuw uit het sjabloon gebouwd, dus haar download bevat vanaf deze deploy de gescheiden regels voor consumenten en ondernemers.

Niet in deze opdracht: de privacyverklaring als sjabloon, de overeenkomst van opdracht en het concurrentiebeding in `employment` uit de audit.

Live nagemeten: deploy `dpl_2Xwh9XorqiXiFYQ7nhQP9cWWo7pZ` (commit `342a8b7`) staat op READY. De sjablonen draaien in de browser, dus via het ingelogde dashboard de geladen chunks opgehaald: in `8474-6e421388219912ba.js` staan de nieuwe clausules (duur en teruggave, 6:230p sub g, "Klant die een consument is", de helft van de koopprijs, opzet of bewuste roekeloosheid), en 0 keer 6:230p sub n, de ODR-commissie, BW 7:46d en "B2B: Over het openstaande".

Volgende stap: akkoord van [[Ali Can]] op dit rapport, dan opdracht 2, het meetplan uit [[meetplan-funnel-2026-09-24]].
