---
type: notes
date: 2026-08-31
status: actief
tags: [copilot, handover, debug]
project: ZekerWet
---

Overdrachtsrapport voor de volgende sessie aan de Juridische Copilot van [[ZekerWet]]. Beschrijft wat er op 31 augustus 2026 is opgelost, wat live is geverifieerd en wat nog open staat. Zie ook [[2026-08-31]] en [[klant-murmurly]].

> [!info] Kern
> `/api/ai/extract` had sinds de lancering nooit gewerkt op productie. Oorzaak was file-tracing, niet het parsen zelf. Opgelost in `5be8f69` en `8d71603`, live geverifieerd.

## Wat kapot was

De Copilot-route die een document uit Mijn Documenten inleest, viel om op stap extractie. Lokaal werkte dezelfde keten wel, wat het beeld gaf van een omgevingsprobleem zonder duidelijke oorzaak.

De generieke foutmelding `EXTRACTION_FAILED` in `src/lib/extract-text.ts` ving elke parserfout af zonder hem te loggen, waardoor de echte oorzaak nooit zichtbaar werd. Pas na het toevoegen van echte serverlogging kwam de fout boven water: `ReferenceError: DOMMatrix is not defined`.

`@napi-rs/canvas` is een harde dependency van `pdf-parse` (versie 0.1.80), maar `pdfjs-dist` laadt hem via een require binnen een try-catch. De file-tracing van Next ziet zo'n dynamische require niet, dus de gedeployde serverless functie kreeg geen kopie mee. Zonder canvas kan pdfjs `DOMMatrix`, `ImageData` en `Path2D` niet polyfillen en klapt `getText`. Lokaal stond het pakket gewoon in `node_modules`, en daarom slaagde elke lokale test.

In zeven dagen productie was er geen enkele geslaagde extract-call. Dat betekent dat ook de gewone upload van de Copilot nooit live heeft gewerkt, niet alleen de route vanuit Mijn Documenten.

## Wat is gewijzigd

`5be8f69` in `next.config.mjs` en `src/lib/extract-text.ts`:
- `serverExternalPackages: ['pdf-parse', 'pdfjs-dist']` zodat Next ze niet meer in de functie bundelt maar als echte node_modules-require laat staan
- de onderliggende parserfout wordt nu server-side gelogd met `logger.child('EXTRACT_TEXT')`, inclusief kind, bytes en mimeType. De melding richting de client blijft ongewijzigd generiek

`8d71603` in `next.config.mjs`:
- `outputFileTracingIncludes` voor `/api/ai/extract` met `@napi-rs/canvas*/**`, `pdfjs-dist/legacy/build/pdf.worker.mjs` en `pdfjs-dist/standard_fonts/**`

`b6ac78b` in `src/app/dashboard/review/page.tsx`:
- de `select` voor documenttype krijgt `min-w-0 max-w-full truncate` en de flexrij mag krimpen, zodat de werkruimte op een telefoon niet meer horizontaal wegschuift

Niets gewijzigd aan Clerk, Stripe, abonnementen, documentgeneratie, de geharde AI-review-route, rate limiting, tokenbudgetten of de spend caps.

## Wat live is geverifieerd

Alles hieronder is uitgevoerd op zekerwet.nl in productie, niet lokaal.

| Onderdeel | Bewijs |
|---|---|
| Document laden vanuit Mijn Documenten | 3.086 tekens schone tekst |
| Compliance-review | 6 van 10, twee bevindingen |
| Automatisch opslaan in reviewhistorie | zichtbaar als `6/10 NDA 31 aug 2026` |
| Suggestie toepassen | 3.086 naar 3.083 tekens, knop wordt Ongedaan maken |
| Ongedaan maken | exact terug naar 3.086 tekens |
| Opnieuw controleren met delta | 2 opgelost, 0 nog open, 2 nieuw; 7 bevindingen zijn 2 kritiek plus 5 in orde, dus de telling klopt |
| Upload extern Word-bestand | 12,8 kB docx, status 200, 209 tekens via mammoth |
| Upload externe PDF | 160 kB Word-PDF van 3 pagina's, status 200, 7.044 tekens via pdfjs |
| Mobiel, viewport 386 breed | 0 px horizontale overflow, leeg en met volledig rapport |
| Mobiele panelen | wissel tussen Document en Bevindingen verbergt en toont correct |
| Ownership | onbekend document-id geeft 404, niet 200 of 500 |
| Auth, rate limiting, spend cap | ongewijzigd, zie hieronder |

Bij de mobiele test kwam één echte bug boven water. Op 386 px schoof de pagina 226 px horizontaal weg omdat de `select` voor documenttype geen breedtebeperking had en zich op zijn breedste optie instelde. Opgelost in `b6ac78b` met `min-w-0 max-w-full truncate`, daarna gemeten op 0 px.

## Matching van bevinding naar passage

Sinds `9c99ad2` gaat dit via `src/lib/passage-match.ts`. Een excerpt wordt opgelost naar een exact tekenbereik in de originele tekst, in twee trappen. Eerst een exacte substring-match, ongewijzigd gedrag. Lukt dat niet, dan een witruimte-ongevoelige match: elke witruimtereeks klapt samen tot één spatie, en een indexkaart mapt het resultaat terug naar echte offsets, zodat het teruggegeven bereik nog steeds exact is.

De tweede trap eist een unieke treffer en minimaal tien genormaliseerde tekens. Is de passage dubbelzinnig of te kort, dan komt er `null` terug en toont de UI gewoon Passage niet in tekst. Er zit geen fuzzy matching, geen similarity-score en geen gedeeltelijke match in, dus toepassen kan nooit over de verkeerde passage heen schrijven. Undo blijft een volledige snapshot-herstelling.

Tien unit tests op echte pdf-parse-output dekken exact, herwikkeld, tab en harde spatie, dubbelzinnig, te kort, afwezig en lege invoer, plus een apply-undo-rondgang. Hele suite: 71 van 71.

Effect gemeten op productie met een geuploade NDA van 2.362 tekens en 32 regelafbrekingen: 4 van 4 bevindingen vindbaar, nul keer de fallback. Voor de wijziging was dat 1 van 2.

## Wat bewust niet perfect is

De locate-functie matcht exact: `text.includes(excerpt)` in `page.tsx:93`, `indexOf` in `page.tsx:255` en `271`. Zodra het model een passage parafraseert of de witruimte anders valt, verschijnt de fallback Passage niet in tekst en blijft Kopieer over. Dat is een veiligheidskeuze uit de oorspronkelijke opdracht, geen defect. Gemeten trefkans op 31 augustus: 1 van 2 in de eerste review, 2 van 2 in de tweede. Een mogelijke verbetering is matchen op genormaliseerde witruimte, wat exact blijft maar robuuster is tegen regelafbrekingen uit PDF-extractie. Nog niet doorgevoerd.

De compliance-score wisselde van 6 op 10 naar 4 op 10 nadat één suggestie was toegepast. Het model is niet deterministisch, dus een score is een indicatie en geen meetwaarde.

## Security en kosten

De drie commits van vandaag raken samen drie bestanden: `next.config.mjs`, `src/lib/extract-text.ts` en `src/app/dashboard/review/page.tsx`. Niets in Clerk, Stripe, abonnementen, documentgeneratie, rate limiting, tokenbudgetten, idempotency of de cost caps. Geverifieerd met `git diff --name-only 37ae055..HEAD`.

De bewaking staat er nog: `auth()` plus `UnauthorizedError` en `checkRateLimit` in `api/ai/extract/route.ts`, en `readKey`, `reserveOrReturn`, `assertGlobalSpendUnderCap` en `checkRateLimit` in `api/ai/review/route.ts`. Suggestie toepassen en undo zijn volledig client-side en veroorzaken geen extra Gemini-call.

## Losstaand, niet Copilot

Vault-automatisering: alle geheimen staan nu in `scripts/secrets.local.ps1`, dat in `.gitignore` staat. De live Stripe-key was nog niet in de git-historie beland, dus roteren is niet nodig. De taak `ZekerWet_AvondCheck` faalde dagenlang met resultaat 1 omdat de scripts UTF-8 zonder BOM waren en PowerShell 5.1 het gedachtestreepje las als een afsluitend aanhalingsteken. Alle scripts hebben nu een BOM en de taak geeft weer resultaat 0.
