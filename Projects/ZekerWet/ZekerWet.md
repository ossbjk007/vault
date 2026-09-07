---
type: project
date: 2026-08-06
status: actief, klanten werven
tags: [project, saas, juridisch, ai]
project: ZekerWet
---

Online AI-automatiseringsplatform voor juridische documenten voor ondernemers. 230+ documenten en brieven, ingebouwde AI-vraagbaak. Drie abonnementen: Essential 25 euro, Business 50 euro, Enterprise 200 euro per maand.

Status 2 september 2026: platform draait live op zekerwet.nl en de betaalde klantflow is end-to-end bewezen met een echte niet-admin gebruiker, zie [[subscription-provisioning]]. De drie proeven van 11 augustus zijn opgezegd en gerefund. Naast klantenwerving loopt de bouw van de Juridische Copilot, de compliance-workspace waarin een document wordt gereviewd, findings naar de juiste passage wijzen en suggesties toepasbaar en terug te draaien zijn.

Copilot: af en doorgetest, zie [[copilot-handover-2026-08-31]] en de eindaudit in [[product-audit-2026-09-03]]. Mobiel gemeten op 320, 375, 390 en 430 pixels zonder overflow.

Documentmotor: herbouwd en gecommit op 7 september 2026 (`fe29de4`), zie [[documentmotor-2026-09-06]]. De gegenereerde PDF's droegen productnaam, generatiedatum en een AI-disclaimer; die staan nu in de app. Presentatie is losgetrokken van de juridische inhoud, brieven en contracten hebben elk hun eigen opmaak en er is een Word-export bij gekomen. Alle 233 sjablonen gecontroleerd.

Volgende stap groei: betalende klanten erbij via organisch bereik op Instagram, Facebook, Twitter en LinkedIn.

Abonnement-provisioning: [[subscription-provisioning]] legt uit waarom een betaald abonnement soms niet in de app landt.

Open klantissue: [[klant-murmurly]]. Twee afschrijvingen zijn gerefund, de derde incasso stond vanmiddag nog op `pending`. De onderliggende oorzaak is nu wel aangetoond: de webhooks van 11 augustus zijn nooit afgeleverd, zie [[subscription-provisioning]].

Concurrenten: [[ZekerWet-concurrenten]] (Ligo, Rocket Lawyer, Legalflow).

Klantzinnen: [[pain-points]] (interview) en `research/voc/` (na setup).
Advertentie-tests: [[tests]].
