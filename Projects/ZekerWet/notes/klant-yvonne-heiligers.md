---
type: note
date: 2026-09-14
status: wacht op antwoord
updated: 2026-09-21
tags: [klant, business, support, escalatie]
project: ZekerWet
---

[[Yvonne Heiligers]] (`info@yvonneheiligers.nl`, KVK 42145532) is de eerste betalende Business-klant van [[ZekerWet]]. Geen proefperiode: ze heeft op vrijdag 4 september 2026 om 12:30 direct 49,99 euro per maand afgerekend (factuur `0EZO8KOK-0008`, betaald). Abonnement `sub_1UBuOWE2xhFVUSlhL05TyR4w` op klant `cus_VCJ0VuLi71BuVX` staat op `active`, geen opzegging ingepland, volgende incasso 4 oktober 2026.

## Wat ze in de app heeft gedaan (stand 14 september 2026)

Account aangemaakt om 12:30, direct na de betaling. Om 17:39 diezelfde middag (15:39 UTC in de database) één document gegenereerd: **Algemene Voorwaarden (B2B/B2C/SaaS)**, sjabloon `terms`, status `completed`. Haar invoer: gemengd B2B/B2C, levering van zowel producten als diensten, betaaltermijn 30 dagen, aansprakelijkheid beperkt tot factuurbedrag, opzegtermijn 1 maand, standaard IE-clausule, overmacht opgenomen, geen eigendomsvoorbehoud, geschillen bij de consumentenrechter.

Verder niets. Nul AI-reviews (`aiUsageCount` 0, `aiTokensUsed` 0), nul losse aankopen, nul reviews via de Copilot. Laatste activiteit op haar record: 4 september 13:56 (Stripe-webhook). Sinds 4 september is ze niet meer teruggekomen voor iets dat in de database landt.

> [!danger] Supportmail van 4 september tien dagen onbeantwoord
> Op 4 september om 14:01 mailde ze naar `support@zekerwet.nl` (via ImprovMX in de Gmail-box): "Account werkt niet". Bij inloggen kreeg ze afwisselend "account niet geregistreerd" en een scherm voor een verificatiecode waarvan de mail nooit aankwam. Niemand heeft geantwoord. Gevonden op 14 september toen Ali de activatiemail wilde sturen. Dit staat los van [[subscription-provisioning]]: haar abonnement is wél correct geland (`price_business`, 12:30). Het probleem zit bij de Clerk-login, niet bij Stripe.
>
> Wat de database wel laat zien: om 17:39 diezelfde dag, drieënhalf uur na haar mail, heeft ze ingelogd en het AV-document gegenereerd. Ze is er dus zelf doorheen gekomen. Waarom de code-mail eerst niet aankwam is niet vanaf de laptop te controleren: de lokale `.env` draagt een `sk_test_`-key van Clerk, de productiekey staat alleen in Vercel. Nagekeken in het Clerk-productiedashboard op 15 september 00:20, via het wmux-browserpaneel:
>
> - Ze is actief. Laatste login **14 september 15:25**, Windows, Edge, sessie actief. Profiel bijgewerkt rond 15:00. Ze heeft een wachtwoord ingesteld.
> - De login van 14 september ging: wachtwoord (eerste factor), daarna `sign_in.email_address.verification.code_sent`, code ingevuld, geslaagd. Dat is **Device Trust** (Configure, Attack protection): elk nieuw apparaat vraagt bij een wachtwoordlogin een e-mailcode. Dat is het "verificatiecode-scherm" uit haar mail. Op 14 september kwam de code aan, op 4 september niet.
> - E-mail-DNS van Clerk (`clkmail`, `clk._domainkey`, `clk2._domainkey`) staat 3/3 geverifieerd, dus de codes gaan met DKIM vanaf zekerwet.nl. Geen configuratiefout.
> - Waarom de code op 4 september niet aankwam is niet meer te zien: Clerk Hobby bewaart logs één dag. Meest waarschijnlijk spam of vertraging bij haar provider.
> - Clerk biedt op de domeinpagina "Secondary email: add a second email provider to increase deliverability". Resend daar koppelen is de enige structurele verbetering die overblijft.

> [!warning] Eén document in tien dagen op een abonnement van 50 euro
> Ze heeft betaald voor onbeperkt genereren plus AI-review en gebruikt alleen de AV-generator één keer. Dat is churn-risico bij de incasso van 4 oktober. Een persoonlijk mailtje met wat ze nog meer kan (AVG-verwerkersovereenkomst, privacyverklaring, review van bestaande contracten) kost vijf minuten.

Let op bij het lezen van de database: `Document.content` bevat alleen de formulierantwoorden, niet de gerenderde tekst. Het document wordt bij openen opnieuw uit het sjabloon opgebouwd. Wil je zien wat zij te zien kreeg, open dan het document als admin in de app.

Activatiemail geschreven op 14 september: [[mail-yvonne-heiligers-activatie]]. Niet los versturen: het antwoord op haar supportmail staat in [[mail-yvonne-heiligers-support-antwoord]], met de activatie-inhoud als tweede deel.

Vijf validatievragen verstuurd op 17 september 2026 om 15:47: [[mail-yvonne-heiligers-vijf-vragen]]. Antwoord open.

Gerelateerd: [[subscription-provisioning]] (hier werkte de provisioning wél, `stripePriceId` staat op `price_business`), [[klant-murmurly]].

## Clerk-dashboard nagekeken, 15 september 2026

Ingelogd op dashboard.clerk.com met `ossbjk@gmail.com`, productie-instantie van zekerwet.nl.

Nieuw feit: ze is op 14 september om 16:29 opnieuw ingelogd, vanaf Windows/Edge in Delft, en de sessie staat op actief. "Profile updated" rond middernacht. De activatiemail van [[Ali Can]] ging diezelfde middag uit; of haar login vóór of na de mail was is niet vast te stellen. Hoe dan ook: tien dagen stil, en de dag van de mail is ze terug.

Wat het inlogprobleem van 4 september verklaart: de regel **Device Trust** staat aan (Configure, Protect, Rules). Die behandelt elk nieuw apparaat bij een wachtwoord-login als onvertrouwd en stuurt een e-mailcode. Dat is het "scherm voor een verificatiecode" uit haar mail. Gisteren liep precies die keten door in de logs: `sign_in.created`, wachtwoord goed, `sign_in.email_address.verification.code_sent`, code geverifieerd, `sign_in.completed`. Geen MFA ingeschakeld; het is device-verificatie.

Waarom de code-mail op 4 september niet aankwam is niet meer te zien: het Hobby-plan bewaart logs één dag. Wat wel te zien is: de mailconfiguratie van Clerk is in orde. `clkmail.zekerwet.nl` CNAME naar Clerk, SPF op dat subdomein, twee DKIM-records, alle drie "Verified", DMARC op `p=quarantine` met rapporten naar `zekerwet@gmail.com`. De code-mail van gisteren kwam aan, want ze is erdoor. Meest waarschijnlijk op 4 september: spam of vertraging aan haar kant, niet aan de onze. Bewijs daarvoor is er niet; de DMARC-rapporten van 4 september in `zekerwet@gmail.com` zouden een quarantaine laten zien als die er was.

"Account niet geregistreerd" bij inloggen is te verklaren door de regel **User enumeration protection** (ook aan): die geeft bewust een vage melding zodat een aanvaller niet kan testen welke adressen bestaan. Voor een echte klant die net heeft betaald leest dat als "je account bestaat niet".

Geen bug gevonden, geen wijziging gedaan. Device Trust uitzetten zou de drempel weghalen maar ook de bescherming tegen credential stuffing; dat is een keuze, geen fix.

## Stand 21 september 2026, live uit Supabase

De sectie "stand 14 september" hierboven is een momentopname van vóór haar sessie die middag en klopt niet meer op het punt AI-gebruik. Wat de database op 21 september laat zien (tijden omgerekend naar Nederlandse tijd):

- 14 september 15:26 tot 15:50: **elf AI-reviews achter elkaar**, tien live en één cache-hit, 33.726 tokens. Ze plakte haar eigen bestaande documenten uit haar begeleidingspraktijk in de Copilot (intakeformulier volwassenen, intakeformulier kind/jongere, privacyverklaring, algemene voorwaarden met annuleringsregeling), zeven keer onder het type NDA, één keer als personeelslening, twee keer als verwerkersovereenkomst. Scores 7 en 8; de personeelslening-run gaf een 3 met "documenttype mismatch", want het was een intakeformulier.
- 14 september 16:27: tweede document gegenereerd, **Verwerkingsregister (AVG art. 30)**, status completed.
- Daarna niets meer. Laatste record 14 september 16:27. `aiUsageCount` staat op **10 van 10**: haar Business-quotum voor deze periode is vol tot de reset op 4 oktober 10:30 (gelijk met de incasso).

Wat dat zegt: ze is niet weggebleven uit desinteresse, ze heeft in één uur de hele AI-review leeggetrokken en daarna een week niets. Twee mogelijke redenen, allebei niet bewezen: het quotum blokkeerde haar, of ze had gewoon klaar wat ze wilde nakijken. Het antwoord op de vijf vragen van 17 september ([[mail-yvonne-heiligers-vijf-vragen]]) is nog niet binnen. Het admin-digest van 16 tot 19 september ("0 requests") klopt met de database: haar reviews vielen op de 14e.

De review-inhoud zelf is bruikbaar als klantcontext: zij werkt met gezondheidsgegevens van cliënten en kinderen, bewaartermijn één jaar na laatste contact, testimonials op basis van toestemming. Dat is het profiel van een coach of begeleider, niet van een SaaS-bedrijf, terwijl haar AV-sjabloon van 4 september "B2B/B2C/SaaS" was.

## Kwaliteit van haar elf reviews, nagekeken 21 september 2026

De inhoud van de bevindingen klopt juridisch waar het te controleren is: artikel 9 AVG voor gezondheidsgegevens, artikel 13 informatieplicht, 72 uur meldtermijn datalek (artikel 33), zeven jaar fiscale bewaarplicht, de WGBO-opmerking dat toestemming niet de enige grondslag hoort te zijn bij een behandelovereenkomst. Geen onzin gevonden. Wel twee structurele gebreken, allebei met bewijs uit de `Review`-tabel:

1. **De limiet van 15.000 tekens (`src/config/ai.ts:33`) dwong haar om documenten in stukken te knippen, en de reviewer beoordeelt elk stuk alsof het het hele document is.** Drie reviews melden "het document breekt abrupt af". De helften spreken elkaar tegen: review 15:26 zegt dat "Aansprakelijkheid" en "Toepasselijk recht" ontbreken, review 15:30 (het vervolg van dezelfde AV) vindt "Artikel 15 – Aansprakelijkheid" en keurt het goed; 15:26 keurt "Artikel 9 – Herroepingsrecht" goed, 15:30 meldt het herroepingsrecht als ontbrekend. Bij de privacyverklaring hetzelfde: 15:31 mist "Rechten van betrokkenen" en "Datalekken", 15:37 en 15:43 vinden artikel 18 en 19 en keuren ze goed. Wat zij als klant zag: een lijst ontbrekende artikelen die in haar eigen document staan.
2. **Te weinig bevindingen en een score die niets zegt.** Twee tot vier bevindingen per review, het merendeel "ok". Elke fragmentreview kreeg een 8, ook die met "breekt abrupt af". De prompt in `src/lib/gemini.ts` vraagt niet om een minimum, niet om de belangrijkste risico's eerst, en zegt niet dat de invoer een fragment kan zijn. Model is `gemini-flash-lite-latest` met 2048 uitvoertokens.

Kleiner: "prüfen" (Duits) en "Hetdocument" in de tekst van twee bevindingen. Het documenttype negeerde ze grotendeels (zeven keer NDA voor AV en privacyverklaring); de reviewer paste zich stil aan en flagde de mismatch alleen bij het intakeformulier. De twee gegenereerde documenten (AV en Verwerkingsregister) zijn niet beoordeeld: `Document.content` bevat alleen formulierantwoorden, de tekst komt uit het sjabloon.
