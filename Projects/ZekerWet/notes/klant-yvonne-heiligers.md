---
type: note
date: 2026-09-14
status: wacht op antwoord
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
> Wat de database wel laat zien: om 17:39 diezelfde dag, drieënhalf uur na haar mail, heeft ze ingelogd en het AV-document gegenereerd. Ze is er dus zelf doorheen gekomen. Waarom de code-mail eerst niet aankwam is niet vanaf de laptop te controleren: de lokale `.env` draagt een `sk_test_`-key van Clerk, de productiekey staat alleen in Vercel. Nakijken in het Clerk-dashboard (productie-instantie, Users, haar record, sessies en e-mailafleveringen).

> [!warning] Eén document in tien dagen op een abonnement van 50 euro
> Ze heeft betaald voor onbeperkt genereren plus AI-review en gebruikt alleen de AV-generator één keer. Dat is churn-risico bij de incasso van 4 oktober. Een persoonlijk mailtje met wat ze nog meer kan (AVG-verwerkersovereenkomst, privacyverklaring, review van bestaande contracten) kost vijf minuten.

Let op bij het lezen van de database: `Document.content` bevat alleen de formulierantwoorden, niet de gerenderde tekst. Het document wordt bij openen opnieuw uit het sjabloon opgebouwd. Wil je zien wat zij te zien kreeg, open dan het document als admin in de app.

Activatiemail geschreven op 14 september: [[mail-yvonne-heiligers-activatie]]. Niet los versturen: het antwoord op haar supportmail staat in [[mail-yvonne-heiligers-support-antwoord]], met de activatie-inhoud als tweede deel.

Gerelateerd: [[subscription-provisioning]] (hier werkte de provisioning wél, `stripePriceId` staat op `price_business`), [[klant-murmurly]].
