# Personal OS — Ali Can

## Session Startup

Bij het eerste antwoord van elke sessie lees je stil `Daily/` (nieuwste bestand), `Context/me.md` en `Context/focus.md`. Nooit aankondigen dat je laadt. Lezen, opnemen, antwoorden.

## Knowledge Routing

| Soort informatie | Bestand |
|---|---|
| Identiteit, werkstijl, overtuigingen | `Context/me.md` |
| Merken, omzet, kanalen, bottleneck | `Context/business.md` |
| Prijs, marge, AOV, CAC, belofte | `Context/offer.md` |
| ICP, situatie, bezwaren | `Context/icp.md` |
| Woordelijke klantzinnen (interview) | `Context/pain-points.md` |
| Toon, merkpersoonlijkheid | `Context/brand.md` |
| 12-maanden doel | `Context/strategy.md` |
| Huidige weekprioriteiten | `Context/focus.md` |
| Dagelijkse log, taken, inbox | `Daily/YYYY-MM-DD.md` |
| Projectstatus en volgende stap | `Projects/{naam}/{naam}.md` |
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

## Anti-patterns

- Geen `# titel` die de bestandsnaam herhaalt.
- Geen wees-notities. Elke notitie wordt vanuit minimaal één bestaande notitie gelinkt.
- Geen vault-updates bij smalltalk.
- Niet alle projectinfo in één `README.md` proppen.
- Namen van mensen, merken en projecten nooit als platte tekst.
