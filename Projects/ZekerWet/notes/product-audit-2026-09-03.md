---
type: notes
date: 2026-09-03
status: actief
tags: [audit, copilot, ux, security]
project: ZekerWet
---

Eindaudit van de Juridische Copilot van [[ZekerWet]] voor lancering. Doel was niet herbouwen maar vinden wat echt ontbreekt. Zie ook [[copilot-handover-2026-08-31]] en [[subscription-provisioning]].

> [!check] Uitkomst
> De implementatie bleek sterker dan verwacht. Vier kleine verbeteringen doorgevoerd, verder niets aangeraakt.

## Wat al goed was

De uploadzone heeft slepen en neerzetten, toetsenbordbediening met Enter en spatie, een `aria-label`, een bezig-staat, een verwijderknop en een eigen foutmelding. Het rapport sorteert bevindingen op ernst, houdt de originele index vast zodat toepassen niet kan verschuiven, en toont tellingen, ontbrekende clausules, oorspronkelijk tegenover voorgesteld, badges voor nieuw en aangepast, en een delta ten opzichte van de vorige review. De pagina heeft een lege staat, een analysestaat, een tekenteller die van grijs naar amber naar rood loopt, een aparte melding bij overschrijding van de limiet, en een foutmelding die bij een budgetfout een upgradelink toont in plaats van een technische tekst.

Microcopy is volledig Nederlands en zakelijk. Geen enkele treffer op marketingtaal als deep scan, rocket of supercharged. De enige animaties zijn functionele spinners plus één laadbalk. Geen gradients, geen sci-fi.

## Wat ik heb gewijzigd

`src/components/review/ComplianceReport.tsx`. De score stond als kaal groot getal met de enige nuance onderaan de pagina. Er staat nu direct onder het cijfer één regel context: op basis van de uitgevoerde controles, geen oordeel over de rechtsgeldigheid. Verder een echte lege staat bij nul bevindingen, waar eerst een leeg kader verscheen, en het aantal bevindingen in de kop.

`src/app/dashboard/review/page.tsx`. Opnieuw controleren zat alleen in het documentpaneel. Op mobiel moest iemand die net een suggestie had toegepast in het bevindingenpaneel eerst van paneel wisselen. De balk die toch al verschijnt na toepassen biedt die actie nu ook, via dezelfde bewaakte handler. Daarmee sluit de lus van controleren, verbeteren en opnieuw controleren zonder navigatie. Ook `aria-pressed` op de paneelwissel.

`src/components/review/UploadDropzone.tsx` toont nu bestandstype en grootte, niet alleen de naam.

## Wat ik bewust niet heb aangeraakt

Stripe, Clerk, de entitlement-berekening, de Gemini-architectuur, het datamodel, de webhook-handler en alle kostenbescherming. Geen daarvan had een aantoonbaar defect.

## Beveiliging, live geverifieerd

Het document van de ene gebruiker opvragen vanuit de sessie van een andere gebruiker geeft 404, ook vanuit een adminaccount. De cron-route `admin/ai-health` geeft 401 zonder token en 401 met een fout token, en gebruikt een constant-time vergelijking. Beschermde routes zonder sessie geven 404 in plaats van te lekken dat ze bestaan.

Eén methodische les: mijn eerste ronde probes gaf 404 op alles omdat de browser op een ander domein stond. Relatieve fetches raakten dus de verkeerde host. Opnieuw gedaan op zekerwet.nl, en pas toen waren de uitkomsten geldig.
