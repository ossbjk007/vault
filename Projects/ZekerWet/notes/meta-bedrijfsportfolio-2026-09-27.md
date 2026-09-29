---
type: notitie
date: 2026-09-27
status: actief
tags: [meta, instagram, facebook, advertenties]
project: ZekerWet
---

Stand van het Meta-bedrijfsportfolio van [[ZekerWet]], nagelopen door Claude in het browserpaneel op 27 september 2026 (alleen gekeken, niets gewijzigd). Portfolio-ID `1586011019756048`. [[Ali Can]] heeft drie portfolio's onder zijn persoonlijke Meta-account; alleen "ZekerWet" is bekeken.

| Onderdeel | Stand |
|---|---|
| Bedrijfsportfolio ZekerWet | bestaat |
| Facebook-pagina ZekerWet | eigendom van het portfolio, 2 volgers |
| Advertentieaccount ZekerWet_Ads | eigendom van het portfolio, nooit een campagne gedraaid |
| Beheerders | alleen Ali (volledige toegang), geen reserve |
| Instagram-profielen | geen enkel profiel toegevoegd |
| Domeinen | geen domein toegevoegd |

Accountverificatie: Meta blokkeerde alle instellingen met "Verificatie nodig". Ali heeft op 27 september geverifieerd, daarna was de blokkade weg.

> [!warning] Waarom Instagram en Facebook niet samen kwamen
> Het Instagram-profiel hangt niet aan de pagina (de pagina toont "Instagram koppelen") en niet aan het portfolio. Dat de openstaande verificatie het koppelen blokkeerde, is een vermoeden, niet vastgesteld.

Koppelpoging via het browserpaneel (27 september): "Instagram koppelen" op de pagina doet niets, en de route Instellingen, Instagram-profielen, Toevoegen komt tot "Aanmelden als zekerwet" (de browser is al ingelogd op Instagram als `zekerwet`) maar eindigt op een lege terugkeerpagina. Het portfolio bleef leeg. De flow verwacht een pop-upvenster dat het paneel niet teruggeeft; koppelen daarom vanuit de Instagram-app op de telefoon.

Blokkadecheck (27 september, avond), omdat [[Ali Can]] overal foutmeldingen kreeg en een blokkade vermoedde. Die blokkade is er niet:
- Business Support Home, Accounts: persoonlijk Facebook-account en alle drie portfolio's (ZekerWet, Hoross, hoross_nl) "Geen problemen met adverteren"; geen accountproblemen in de laatste 30 dagen.
- Instagram `zekerwet`, Accountstatus: alle drie onderdelen (verwijderde content, bereik, functies) groen afgevinkt.
- Instagram `zekerwet` is al een professioneel account en zit in hetzelfde Accountcentrum als Ali's Facebook, met de ZekerWet-pagina onder "Pagina's die je beheert".
- Geen van de twee andere portfolio's heeft een Instagram-profiel, dus zekerwet zit niet elders vast.
- Eén afgeronde supportcase: "Bedrijfsmiddel of gegevensbron koppelen", 9 mei 2026.

Volgorde van herstel:
1. Instagram aan de pagina koppelen via "Instagram koppelen" in Business Suite. Het profiel moet een professioneel account zijn (zakelijk of creator).
2. Instagram-profiel toevoegen aan het portfolio: Instellingen, Instagram-profielen, Toevoegen.
3. Domein `zekerwet.nl` toevoegen onder Domeinen en verifiëren. Kan met een TXT-record bij TransIP (SPF-record `v=spf1 include:spf.improvmx.com ~all` laten staan) of met een meta-tag via `verification.other` in `src/app/layout.tsx`, zoals bij Search Console in [[seo-indexering-2026-09-14]].
4. Tweede beheerder toevoegen als reserve, zodat een blokkade op Ali's account niet het hele portfolio vastzet.

Koppelpoging 28 september 2026, Instagram-app op de telefoon: de app vraagt de koppeling met de Facebook-pagina te bevestigen en geeft daarna "Er is iets fout gegaan. Er is een probleem bij ons opgetreden, probeer het later opnieuw." Volgende poging via de Facebook-kant in een gewone browser op de laptop, niet in het wmux-paneel.

Stand na de Facebook-kant (28 september, Chrome, `facebook.com/settings/?tab=linked_instagram` als de pagina): `@zekerwet` staat onder "Connected Instagram" met "Account loskoppelen", dus de koppeling bestaat, maar als beperkte koppeling ("slechts enkele functies"). "Koppeling controleren" vraagt het Instagram-wachtwoord en mislukt na inloggen. Volgende stap: profiel aan het portfolio toevoegen in Business Suite, en apart nagaan of `@zekerwet` een eigen wachtwoord heeft (een account dat via Facebook is aangemaakt heeft dat soms niet).

Portfolio-poging 28 september, middag: in gewone Chrome belandde het Instagram-venster op de profielpagina in plaats van de toestemming. In incognito kwam de juiste OAuth-stap wel ("Meld je aan bij Meta Business Suite met je Instagram-account", "Aanmelden als zekerwet"), maar daarna toont "Add an Instagram profile" alleen een leeg vraagteken, en de lijst blijft "Geen Instagram-accounts toegevoegd". Onderweg de derde accountverificatie van die dag, afgesloten met "Informatie verzonden, je verificatiestatus wordt binnenkort bijgewerkt". Vermoeden, niet vastgesteld: zolang die verificatie loopt, weigert Meta het toevoegen zonder foutmelding. [[Ali Can]] is hier volgens eigen zeggen al vijf maanden mee bezig en krijgt geen reactie van Meta. Besluit: stoppen met pogingen tot de verificatie is verwerkt, supportbericht klaargezet.

> [!important] Oorzaak volgens Meta AI (28 september 2026, nog niet zelf nagekeken)
> `@zekerwet` (Instagram-ID `17841426701771610`) is eigendom van een ander portfolio, "zekerwet" in kleine letters (ID eindigt op 917), waar Ali geen beheerder van is. Dat blokkeert het toevoegen aan ZekerWet `1586011019756048`; de lopende verificatie blokkeert het volgens Meta AI niet. Dit portfolio stond niet tussen de drie die Ali op 27 september onder zijn Facebook-account zag, en verklaart waarom de koppeling al maanden faalt. Vermoeden, niet vastgesteld: het portfolio is aangemaakt vanuit Instagram zelf (inloggen bij Business Suite met het Instagram-account) of vanuit een Facebook-account op `zekerwet@gmail.com`. Route: in dat portfolio komen, eerst kijken wat erin zit, dan `@zekerwet` eruit halen en aan ZekerWet toevoegen.

Nagelopen door Claude in het wmux-paneel, 28 september: onder Ali's Facebook-account toont `business.facebook.com/select/` alleen Hoross, ZekerWet en hoross_nl. Inloggen in Business Suite via Instagram (`loginpage/?login_options[0]=FB&login_options[1]=IG`, "Doorgaan met Instagram") lukt en toont de posts van `@zekerwet`, maar instellingen geven "Sorry, something went wrong" en `/select/` zegt "Your account, zekerwet, does not have access to any Facebook Pages or Instagram profiles that can be managed". Via de Instagram-login is het portfolio van 917 dus ook niet te bereiken. Resterende sporen: welk Facebook-account beheerder is (mogelijk een account op `zekerwet@gmail.com`), te vinden via Meta-mails in beide Gmail-boxen, of via accountherstel bij Meta.

Verder nagelopen door [[Ali Can]], 28 september: in `zekerwet@gmail.com` alleen een Bedrijfsmanager-mail van 16 april (bevestiging e-mailadres voor portfolio "ZekerWet" met hoofdletter, dus het eigen portfolio) en één niet-relevante mail. `facebook.com/login/identify` vindt op geen van zijn drie Gmail-adressen een Facebook-account. De eigenaar van portfolio 917 is dus niet gevonden, en de bewering van Meta AI is niet bevestigd; een AI-antwoord van Meta kan ook fout zijn. Besluit: voor vandaag gestopt, verder via menselijke support van Meta.

Supportassistent in Business Support Home (28 september, door Claude via het wmux-paneel verstuurd namens Ali), met een eigendomscontrole: `@zekerwet` (`17841426701771610`) is eigendom van portfolio "zekerwet" met ID `3085491984976917`; Ali's beheerstatus daar "Geen toegang". In de chatgeschiedenis staan eerdere chats over dezelfde koppeling in april en mei 2026. Voorgestelde oplossing van Meta: in de Instagram-app Instellingen en privacy, Accounttype en tools, Overschakelen naar persoonlijk account (verbreekt de koppeling met het onbekende portfolio), daarna terug naar professioneel, dan meteen op de computer toevoegen aan ZekerWet `1586011019756048`. Kosten volgens algemene kennis: statistieken van oude posts vervallen, de koppeling met de pagina moet opnieuw.

Uitgevoerd door [[Ali Can]] op 28 september rond 14:40: persoonlijk, 2 minuten wachten, terug naar professioneel (Bedrijf), geen pagina gekoppeld in de app, dan in incognito Toevoegen. Resultaat: hetzelfde lege vraagteken. Omschakelen verbreekt het eigendom door portfolio `3085491984976917` dus niet. Geen aanwijzing voor een blokkade: Business Support Home meldt op 27 en 28 september geen account- of bedrijfsmiddelproblemen. Vervolgvraag aan de supportassistent (opnieuw eigendom controleren, escaleren naar een medewerker of een supportcase) kon Claude niet zelf versturen; Ali plakt hem in de chat "Koppeling Instagram-pr…".

Antwoord supportassistent na de reset: "Eigendom niet gewijzigd", eigenaar nog steeds `3085491984976917`. Kan niet doorverbinden. Route volgens Meta: een "Business Manager Admin Dispute" of "Inaccessible Business Manager"-aanvraag, met legitimatie en een KVK-uittreksel. De vrijgave via de pagina is niet van toepassing, want pagina `997876830085618` is al van het eigen portfolio. Volgens openbare bronnen (Google-overzicht, niet geverifieerd) wil Meta bij zo'n dispute ook een ondertekende verklaring op briefpapier en de asset-ID's, en loopt het via een live chat met een medewerker in Business Support Home.

Twee opties voorgelegd aan [[Ali Can]]: (A) de dispute voeren, met onzekere uitkomst en een looptijd van weken; (B) opnieuw beginnen: `@zekerwet` hernoemen en een nieuw Instagram-account direct vanuit het ZekerWet-portfolio aanmaken. Voor B kost het huidige account weinig: 10 volgers en 13 posts met gemiddeld 35 vertoningen. Of de naam `zekerwet` na hernoemen meteen vrijkomt, is niet vastgesteld.

Besluit [[Ali Can]] (28 september): optie B. Hij maakt een nieuw account `zekerwet.nl` aan op `info@zekerwet.nl`, na uitloggen bij het oude `@zekerwet`, en voegt het niet toe aan het Accountcentrum. Het oude account blijft bestaan en wordt niet hernoemd. Na het toevoegen aan portfolio `1586011019756048` volgen: sitelinks (`src/config/company.ts:28`, `src/app/contact/page.tsx:186`), de checklist van week 41 en een verwijzing in de bio van het oude account.

Hoort bij het socialspoor in [[groeiplan-social-2026-09-26]]; fase B (Meta-app) hangt van deze stand af.
