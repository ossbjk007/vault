---
type: prompt
date: 2026-09-10
status: actief
tags: [marketing, prompt, kennisbank, juridisch]
project: ZekerWet
---

Dertiende vervolgprompt voor de projectterminal van [[ZekerWet]]. Volgt op [[marketing-os-artikel-correcties-prompt]].

Eén correctie op zijn eigen AVG-correctie: het verwerkingsregister zit terecht in de 2-procentcategorie, maar de privacyverklaring valt onder art. 13 en 14 en dus onder lid 5, de categorie van 4 procent. Daarna groen licht voor de deploy.

```
Good work, and the two substantive errors you found in the inherited articles justify the whole exercise — a gate that reports 0 of 7 on your existing content is doing its job. Following a C8 soft flag about an unregistered "4%" and discovering the claim was in the wrong tier entirely is exactly the behaviour I want: the flag asked a small question and you followed it to the real answer.

The loon question is settled the right way. Reading BWBR0005290 verbatim, finding that lid 6 delegates the definition to an AMvB, being unable to open the Besluit, and then writing the statute's own words plus an explicit warning rather than guessing — that is the correct outcome, and recording it in claims.json as approved-hedged with the split stated means the next person knows exactly how far the verification went.

The three corrections read well. The vervaltermijn passage in particular now says the thing that matters: roughly two months after the contract ends, not three.

But you inverted one of your own fixes.

═══════════════════════════════
1. THE PRIVACYVERKLARING IS IN THE 4% TIER, NOT THE 2% TIER
═══════════════════════════════

You corrected avg-compliance-ondernemers by moving "het ontbreken van een verwerkingsregister of privacyverklaring" into the 2% category. Half of that is right and half is now wrong in the other direction.

  · Verwerkingsregister — art. 30 AVG, which sits inside "de artikelen 25 tot en met 39"
    named in art. 83 lid 4. So 10 million or 2%. Your correction holds.

  · Privacyverklaring — the instrument for meeting art. 13 and art. 14, both of which sit
    inside "de artikelen 12 tot en met 22" named in art. 83 lid 5 sub b, the rights of the
    data subject. So 20 million or 4%.

They are in different tiers, and you have put them in the same sentence under the lower one. On an article about AVG fines, on a product that sells compliance, halving a penalty category is the same class of error you just fixed, pointing the other way.

Fix it so the two examples sit under their own tiers. And go back and check the same thing in verwerkingsregister-avg — if that article names a privacyverklaring anywhere near a fine figure, it has the same problem.

Verify it against the text on EUR-Lex the way you did the first time rather than from what I have written here, and record which lid each example belongs to in claims.json so this cannot drift again.

═══════════════════════════════
2. THE INHERITED ARTICLES — LEAVE THEM
═══════════════════════════════

Your point stands: 345 words does not compete for Dutch legal search intent, and passing the gate is not the same as ranking. But do not spend the weekly slot rewriting them.

At one article a week, a new article aimed at a query with a document page behind it beats a rewrite of an old one aimed at a query that may have no buying intent at all. You said it yourself about "wat is een NDA" — it attracts students.

So: the shortlist first, in the order you gave it. Modelovereenkomst zzp 2026 next, then vaststellingsovereenkomst bedenktijd, then verbeterplan disfunctioneren voorbeeld.

Revisit an inherited article only when it targets a query that both has a document page behind it and has the kind of intent you argued for in the shortlist. Record that as the rule rather than as a nice-to-have, so it does not become a standing backlog item that quietly competes with new work.

═══════════════════════════════
3. NOTED
═══════════════════════════════

The stale-bundle incident is worth what you called it. A checker judging a build older than the rules it claims to enforce is the monitor-that-dies-quietly in a new costume, and rebuilding before every judgement is the right fix rather than remembering to rebuild.

Being wrong about the 100% naheffing in the safe direction — assuming your own marketing was puffery when it was a real statutory ceiling in art. 67f AWR — is worth noticing too. The bias runs one way: you under-claim on our own product and over-claim on penalties. Both are errors.

The art. 6:236 version note in claims.json is the right way to leave a claim you could not fully verify.

═══════════════════════════════
4. THEN DEPLOY
═══════════════════════════════

Fix the tier, re-run the gate over all seven, show me the corrected passage, and deploy on my word.

After that: Thursday 17 September, hand-draft week 39 in one run, as committed.
```
