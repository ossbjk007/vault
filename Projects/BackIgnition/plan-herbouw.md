---
type: plan
date: 2026-09-16
status: concept
tags: [backignition, website, webshop]
project: BackIgnition
---

Plan van aanpak voor de site van [[Back Ignition]], na de puntenlijst in [[wensen-leon-2026-09-16]]. Niets hiervan is gebouwd. Eerst akkoord van [[Léon van Cappellen]] op de open punten onderaan.

## Wat we maken

Het ontwerp van het prototype, gevuld met de teksten van de huidige site, verdeeld over vijf pagina's: home, about, jobs, shop, contact. Geen muziekspeler, geen shows-agenda, geen mailinglijst, geen perskit. Dat stond wel in het prototype en gaat er allemaal uit, want punt 2 is duidelijk.

De teksten haal ik letterlijk van backignition.com: The Sound, het stuk over [[Wouter Merks]], Join Us, de contactintro. Geen woord eraan veranderd, tenzij Léon dat vraagt.

## De architectuur, en waarom

De huidige site is een Express-app met een eigen beheerpaneel, een productdatabase en een Stripe-koppeling. Hij draait op `83.86.15.124`, een dynamisch Ziggo-kabeladres. Dat is een thuisverbinding, geen hostingpartij. Dat verklaart ook de trage laadtijden uit de analyse, en het betekent dat de site offline gaat als daar de stekker uit gaat of het IP-adres verandert.

Wat ik ervoor in de plaats zet: een statische site op Vercel met twee kleine serverfuncties, één voor het afrekenen via Stripe en één voor het contactformulier. Geen database, geen server die draait en stuk kan, geen beheerpaneel om in te breken. Dat past bij punt 7: eenvoud, en het is meteen de reden dat "Inloggen" uit het menu kan.

> [!warning] Dit is de enige echte functieverandering
> Nu kunnen ze zelf teksten en producten aanpassen in het beheerpaneel. In mijn opzet komen producten in het Stripe-dashboard te staan (daar horen prijzen en voorraad thuis, en ze hebben dat account al) en tekstwijzigingen lopen via mij. Dat is minder zelfbediening. Wil Léon dat wel houden, dan is een lichtgewicht beheerpaneel een aparte, grotere post. Dit expliciet voorleggen.

## Webshop, het echte werk

Punt 1 zegt dat de webshop moet werken. Op de huidige site werkt hij niet: één uitverkocht artikel van 666 euro, en de winkelmand wordt geleegd vóór de betaling. Dat is ook het zwaarste deel van de bouw:

- Producten met varianten, dus maten voor kleding, en uitverkochte maten zichtbaar doorgestreept.
- Verzendkosten in beeld vóór het afrekenen, tarief voor Nederland en voor de EU.
- De mand blijft staan tot Stripe bevestigt dat er betaald is.
- Bestelbevestiging per mail met ordernummer, en een bedanktpagina.
- Voorraad die afboekt bij verkoop, zodat een kleine oplage vinyl niet dubbel verkocht wordt.

De opzet hangt op één vraag: wat wordt er verkocht en hoeveel artikelen worden het? Vijf artikelen is een ander bouwwerk dan vijftig.

## Juridisch

Verkopen aan consumenten in de EU kan niet zonder. Wat er moet komen:

1. **Algemene voorwaarden** met een retour- en verzendbeleid en het herroepingsrecht van veertien dagen, plus het modelformulier voor ontbinding. Ontbreekt dat herroepingsrecht, dan loopt de bedenktijd geen veertien dagen maar een jaar door.
2. **Privacyverklaring**, omdat er persoonsgegevens en bestellingen verwerkt worden.
3. **Bedrijfsgegevens** in de footer: handelsnaam, adres, KVK-nummer, btw-nummer en een contactadres.
4. Cookieverklaring alleen als er straks statistieken of iets van een tracker op komt. Zonder dat is het niet nodig, en ik zou het zo houden.

[[ZekerWet]] heeft een privacyverklaring en algemene voorwaarden in de catalogus. Vóór ik die aan Léon toon, controleer ik of de algemene voorwaarden de consumentenkoop op afstand echt dekken, dus herroepingsrecht, modelformulier, verzending en retour. Dekt het dat niet, dan is het een aangepast document en geen standaarduitdraai. Niets tonen voordat dit is nagekeken.

## Hosting en kosten

Besluit van 16 september, na afweging: [[Ali Can]] doet bouw en hosting gratis voor de band. Geen factuur, dus geen omzet en niets aan te geven. Zodra er ooit wel geld voor gevraagd wordt, hoort dat in de administratie.

De site blijft op Vercel, in het eigen account van [[Back Ignition]], met hun eigen domein `backignition.com` eraan gekoppeld. Precies zoals [[ZekerWet]] het doet. Cloudflare Pages is overwogen omdat het Hobby-plan van Vercel formeel niet-commercieel is en een merch-shop dat wel is, maar die route gaat niet door: het lost geen probleem op dat we nu hebben en het kost een extra omgeving om te beheren.

De repo gaat naar een apart GitHub-account, los van `ossbjk007`, zodat klantwerk en [[ZekerWet]] elkaar nergens raken.

De domeinnaam blijft op naam van de band, dat is hun eigendom.

## Volgorde van bouwen

1. Antwoorden op de open punten hieronder, plus toegang tot Stripe en DNS.
2. Statische opzet met de vijf pagina's en de bestaande teksten, "Inloggen" eruit. Zonder shop.
3. Contactformulier dat werkt en aankomt, met het onderwerp dat bepaalt waar het heen gaat.
4. Shop: producten, maten, verzendkosten, afrekenen, bevestigingsmail.
5. Juridische pagina's erop, eerst als concept ter toetsing naar Léon.
6. Domein koppelen, canonical en og-url naar backignition.com, oude site pas uit de lucht als de nieuwe staat.
7. Fatsoenswerk dat bij het bouwen hoort en niets extra kost: favicon, deelplaatje, sitemap, verkleinde afbeeldingen, kleur uit het logo (#58B5E0 in plaats van #00ADFE), toegankelijk menu.

## Open punten voor Léon

1. **Twee of drie open plekken?** De huidige site zegt "a drummer and lead guitarist", de analyse en zijn mail spreken over drie, inclusief bassist. De jobs-pagina hangt hierop.
2. **Wat komt er in de shop?** Artikelen, maten, prijzen, oplage, en verzenden ze alleen in Nederland of ook daarbuiten?
3. **Van wie is het Stripe-account** en kan Ali erbij, of komt er een nieuw account op naam van de band?
4. **Wie beheert de huidige site technisch** en krijgen we de broncode? Niet nodig om te bouwen, wel om de oude site netjes uit te zetten en te weten wat er nog meer aan hangt.
5. **Bedrijfsgegevens:** handelsnaam, adres, KVK, btw-nummer. Nodig voor de voorwaarden en voor Stripe.
6. **Waar moeten berichten van het contactformulier heen**, en mag dat één adres zijn of gesplitst naar onderwerp?
7. **Wie beheert de domeinnaam** backignition.com en kunnen we daar DNS-records zetten?
8. **Bandfoto's in hoge resolutie.** Het ontwerp staat overeind zonder, maar wordt er beter van.
