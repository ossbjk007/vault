# Personal OS — Ali Can

## Session Startup

Bij het eerste antwoord van elke sessie lees je stil `Daily/` (nieuwste bestand), `Context/me.md` en `Context/focus.md`. Als het gesprek over marketing gaat, lees ook `Projects/ZekerWet/marketing/cadence.md` en de laatste 10 regels van `Projects/ZekerWet/marketing/logboek.md` (dat logboek wordt gegenereerd, nooit met de hand bijwerken). Nooit aankondigen dat je laadt. Lezen, opnemen, antwoorden.

## Knowledge Routing

| Soort informatie | Bestand |
|---|---|
| Identiteit, werkstijl, overtuigingen | `Context/me.md` |
| Merken, omzet, kanalen, bottleneck | `Context/business.md` |
| Prijs, marge, AOV, CAC, belofte | `Context/offer.md` |
| ICP, situatie, bezwaren | `Context/icp.md` |
| Woordelijke klantzinnen (interview) | `Context/pain-points.md` |
| Toon, merkpersoonlijkheid | `Context/brand.md` |
| Merkregels, do's en don'ts, zinsritme | `Projects/ZekerWet/marketing/brand-voice.md` |
| Taglines, value props, CTA's, hashtags | `Projects/ZekerWet/marketing/copy-library.md` |
| Weekritme, kanalen, tijdsbudget | `Projects/ZekerWet/marketing/cadence.md` |
| Productfeiten: prijzen, abonnementen, catalogus | ZekerWet-repo `src/config/` via `marketing/facts.ts`. Nooit overtypen in de vault. |
| Goedgekeurde juridische claims en statistieken | ZekerWet-repo `marketing/data/claims.json` |
| Contentlogboek (gegenereerd, niet handmatig) | `Projects/ZekerWet/marketing/logboek.md` |
| Dagelijkse contentprompts | `Resources/prompts/marketing-dag.md` |
| 12-maanden doel | `Context/strategy.md` |
| Huidige weekprioriteiten | `Context/focus.md` |
| Dagelijkse log, taken, inbox | `Daily/YYYY-MM-DD.md` |
| Projectstatus en volgende stap | `Projects/{naam}/{naam}.md` |
| Klantwerk Back Ignition (site, domein, Vercel) | `Projects/BackIgnition/BackIgnition.md`, code in `C:\Users\acerd\dev\back-ignition\` |
| Nieuwe klantzinnen na setup | `Projects/{merk}/research/voc/` |
| Concurrentie-analyse | `Intelligence/competitors/{merk}-concurrenten.md` |
| Advertentie-tests | `Projects/{merk}/notes/tests.md` |
| Kennis die projecten overleeft | `Intelligence/` |
| Herbruikbaar materiaal | `Resources/` |

## Document Voice

Vault-notities klinken als een collega, niet als een AI. Concrete namen, concrete bedragen, concrete gevolgen. Slecht: "De campagne loopt goed." Goed: "Hook 4 draait op 2,1 ROAS bij 400 euro spend. Hook 2 na 80 euro zonder aankoop uitgezet. Volgende test: hook 4 met UGC-opening."

## Obsidian-syntax

`[[wikilinks]]` voor elke entiteit (mensen, merken, producten, projecten, notities), verweven in zinnen en niet als bullet-lijst aan het eind. Callouts `> [!type]` voor structuur, maximaal drie per document. Nooit markdown-links naar interne notities.

## Frontmatter

Elke notitie krijgt `type`, `date`, `status` en minimaal twee `tags`. Bij projectgebonden notities ook `project`.

## Regels

1. Bij het eerste antwoord van een sessie: lees `Daily/` (nieuwste), `Context/me.md`, `Context/focus.md`.
2. Als er echt werk gebeurt, niet bij smalltalk: schrijf een sessie-log naar `Daily/YYYY-MM-DD.md`.
3. Elke entiteit krijgt een `[[wikilink]]`. Zonder uitzondering.
4. Elke notitie staat op zichzelf en is combineerbaar. Een legosteen, geen hoofdstuk.
5. Correcties van mij worden permanente regels in dit bestand. Niet vragen, gewoon opschrijven.
6. Gebruik `grep` om veel bestanden te scannen. Lees geen hele bestanden als je alleen zoekt.
7. Nooit toestemming vragen om op te slaan. In het juiste bestand opslaan, dan melden wat waar staat.
8. Vóór je laatste antwoord: alles wat waardevol is, staat in de vault.
9. Nooit bestanden of mappen in de vault-root. Elk bestand woont in een bestaande map.
10. Nooit gedachtestreepjes.
11. Taken zijn checkboxes in de `Daily/`-notitie van vandaag onder `## Taken`. Formaat: `- [ ] Beschrijving 📅 YYYY-MM-DD`. Klaar is `- [x]`.
12. **Fase-updates.** Als je aan een project werkt, schrijf je na elke afgeronde deelstap automatisch een update naar `Projects/{naam}/{naam}.md` (status plus volgende stap) en één regel naar `Daily/YYYY-MM-DD.md`. Een deelstap is: research klaar, eerste versie klaar, advertentie live, test geëvalueerd. Niet pas aan het einde van het gesprek. Niet vragen, gewoon doen en in één zin melden.
13. **Neutraal check-gedrag.** Als ik vraag "klopt dit", "is dit af", "check dit": geef een oordeel, geen geruststelling. "Goed gedaan" is een geldige uitkomst. Verzin geen verbeteringen om grondig te lijken. Elk verbeterpunt heeft drie velden: WAT (bestand plus regel), WAAROM (welk risico of welke kosten echt), HOE (fix in één regel). Ontbreekt er één, laat het punt weg. Een bug beweer je alleen met bewijs uit grep, read of een run. Sluit vondsten af met "verder om toe te passen, of laten staan" en wacht. Ga niet zelf editen.
14. **Bron-labels.** Bij strategische, marketing- of business-uitspraken markeer je de herkomst: uit de vault, generiek playbook, of eigen redenering. Verkoop generieke kennis nooit als vault-advies.
15. Afgeronde projecten verhuizen naar `Intelligence/archive/`.
16. **Klantmails vanuit het systeem, niet vanuit ik.** Mails aan klanten van ZekerWet schrijf je vanuit wat het account of het systeem heeft gezien ("in je account is op 4 september X opgesteld"), niet vanuit "ik zag dat". Geen praatjes als "zonde van je geld". Feit, wetsartikel, wat beschikbaar is. Ondertekend met ZekerWet.
17. **Eerst de inbox, dan de klantmail.** Vóór het opstellen van een mail aan een klant: vraag of controleer of er al mail van die klant ligt in de Gmail-box (`support@` en `info@zekerwet.nl` komen daar via ImprovMX binnen). Een activatiemail bovenop een onbeantwoorde supportvraag is erger dan geen mail.
18. **Herstelscripts dragen geen identifiers.** Een eenmalig script dat productiedata repareert krijgt klantgegevens, Stripe-ID's en andere identifiers als command-line-argumenten, nooit in het bestand zelf. Een untracked bestand met een echt mailadres en een `cus_`/`sub_` erin hangt aan iemand die het elke keer moet onthouden, en één `git add -A` zet het permanent in de geschiedenis van een product dat AVG-compliance verkoopt.
19. **Klantwerk blijft gescheiden.** [[Back Ignition]] en ander klantwerk krijgen een eigen map onder `Projects/`, een eigen repo onder `C:\Users\acerd\dev\` en een eigen Vercel-project. Nooit in de ZekerWet-repo, nooit in `Projects/ZekerWet/`, nooit in een tijdelijke map. Bron van een site staat in een git-repo vóór hij deployt. Geen enkele gedeelde schakel tussen klantwerk en ZekerWet: geen gedeeld Vercel-team, geen gedeelde login-koppeling, geen gedeeld GitHub-account, geen gedeeld mailadres. Als een stap zo'n schakel zou maken, stop en meld het in plaats van doorgaan.
20. **Eén GitHub-account, één Vercel-account.** GitHub `ossbjk007` is de login-koppeling van het ZekerWet-Vercel-account (`ossbjk@gmail.com`) en blijft dat. Een GitHub-account kan maar aan één Vercel-account gekoppeld zijn; koppel je hem aan een klantaccount, dan verliest ZekerWet hem en blokkeert Vercel elke productie-deploy (gebeurd op 16 september 2026). Klantaccounts krijgen géén GitHub-koppeling: hun repo's deployen doordat de commit-e-mail gelijk is aan het mailadres van dat Vercel-account (`git config user.email` per repo).
21. **Klantmails krijgen context en warmte.** Een mail aan een klant opent met waarom je iets vraagt en wat ZekerWet ermee doet, in de we-vorm namens ZekerWet, en sluit af met een dankwoord. Geen kale vragenlijst. De versie die [[Ali Can]] op 17 september 2026 aan [[Yvonne Heiligers]] stuurde ([[mail-yvonne-heiligers-vijf-vragen]]) is de maat: eerst waarom, dan de vragen, dan "je hoeft er geen uitgebreid verhaal van te maken", dan bedankt. Regel 16 blijft gelden: feiten uit het account, geen praatjes over geld.

## Anti-patterns

- Geen `# titel` die de bestandsnaam herhaalt.
- Geen wees-notities. Elke notitie wordt vanuit minimaal één bestaande notitie gelinkt.
- Geen vault-updates bij smalltalk.
- Niet alle projectinfo in één `README.md` proppen.
- Namen van mensen, merken en projecten nooit als platte tekst.
