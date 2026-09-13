---
type: prompt
date: 2026-09-10
status: actief
tags: [marketing, prompt, kennisbank, juridisch]
project: ZekerWet
---

Twaalfde vervolgprompt voor de projectterminal van [[ZekerWet]]. Volgt op [[marketing-os-kennisbank-prompt]].

Bevat de juridische controle op het eerste kennisbankartikel over de aanzegbrief: vier claims kloppen, drie moeten scherper. De vervaltermijn was inderdaad de zwakste, precies zoals hij zelf aangaf.

```
Article reviewed against the statute. Four of your six flagged claims hold. Three things need changing, and your instinct about which one was weakest was right.

Your §4 answer is the most useful thing you have given me in this project. One article a week, three to four hours of your time, twenty to thirty minutes of mine on legal substance, and the honest statement that the gate cannot check a single substantive legal assertion in this article — not one. That is the number I will plan against. Fifty-two a year against a catalogue of 233 documents is still the highest-leverage thing available, and a rate I can actually sustain beats a rate I would quietly abandon in three weeks.

═══════════════════════════════
1. WHAT HOLDS
═══════════════════════════════

  · six months or longer — art. 7:668 lid 2 sub b
  · the calendar-date exception — art. 7:668 lid 2 sub a
  · at the latest one month before the end date — lid 1
  · one month's pay, pro rata when late — lid 3
  · the vergoeding not depending on damage — correct
  · your two hedges, on the pre-agreed aanzegging and on the uitzendbeding

The hedges stay hedged. Do not tighten them into assertions.

═══════════════════════════════
2. THREE CORRECTIONS
═══════════════════════════════

2.1 — The vervaltermijn. You were right to flag this one first.

Art. 7:686a lid 4 sub e BW: the bevoegdheid lapses three months after the day on which the obligation under art. 7:668 lid 1 arose. That obligation arises one month before the end date, not on the end date.

The article currently says "binnen drie maanden na het ontstaan", which every reader will take to mean the end date. That is a month's difference, and it runs against the employer who relies on it. Say explicitly what the clock starts from.

2.2 — "Vier dingen. Meer hoeft niet, en minder is niet genoeg."

Art. 7:668 lid 1 requires two: whether you are continuing, and on what terms if you are. Naming the end date and dating the letter are evidentially sensible and not statutory.

Presenting practice as law is the same error class as the pricing claim, on a product that sells legal correctness. Split them: two legal requirements, then two things you want for proof, labelled as such. The advice does not get weaker — it gets honest about which half a court cares about.

2.3 — The doorwerken answer is materially incomplete.

Art. 7:668 lid 4 sub b: the contract continues for the same duration, capped at one year, on the previous terms. The article says "loopt het contract stilzwijgend door onder dezelfde voorwaarden" and stops there.

Someone reading that has no idea whether they are now stuck for four months or forever, and it is exactly the question that determines what they do next. Add the duration and the one-year cap.

═══════════════════════════════
3. ONE THING FOR YOU TO CHECK RATHER THAN ME TO ASSERT
═══════════════════════════════

Lid 3 speaks of "het loon voor een maand". The article says "één bruto maandsalaris".

My understanding is that this is read more narrowly than a gross monthly salary including vakantietoeslag and other emoluments, but I am not confident enough to make you change it on my say-so. Look it up properly. If it is narrower, the article overstates what an employer owes, which is the safer direction to be wrong in but still wrong. If you cannot settle it, say so and hedge the wording rather than guessing.

Report which of these three sources you actually used, so the claim ends up in claims.json with a provenance rather than as received wisdom.

═══════════════════════════════
4. ACCEPTED WITHOUT CHANGE
═══════════════════════════════

4.1 — The .tsx-per-file deviation instead of MDX. Your reasoning is right and I would rather you had told me than done MDX because you said you would. Three new packages and a bundler change to a live legal SaaS, to store seven documents, is a bad trade. Every goal I named is met. No MDX.

4.2 — The two validator changes. CTA_ARTICLE_FEEDS_NOTHING is stricter where it matters rather than looser, and blocking UTM on internal links is a real catch — stamping utm_source=kennisbank on an on-site link would have relabelled Google traffic as our own campaign traffic and quietly corrupted the only attribution we have. That is the sort of thing that would have gone unnoticed for months.

4.3 — Reporting the unreachable kennisbank branch and the stripped href tags rather than fixing them quietly. Both were fixed in the right place.

═══════════════════════════════
5. THE OLD ARTICLES — YES, FIX THEM
═══════════════════════════════

You found that every existing article's CTA uses "Juridisch waterdicht", which brand-voice.md forbids and claims.json bans, and points at /#pricing rather than a document page.

Fix both across all six. The phrase is an absolute claim on a compliance product, which is the category of wording we spent this whole project removing, and it has been live the entire time. The CTA should point at the document page the article is actually about, following the same rule you just wrote for the new one.

Then run the gate over all seven articles, not just the new one, and show me what it says. I would rather find out now that the existing kennisbank does not pass its own standard.

═══════════════════════════════
6. THEN
═══════════════════════════════

Make the three corrections, settle the loon question, show me the changed passages, and I will approve the deploy.

After that: Thursday 17 September, hand-draft week 39 in one run, as committed.
```
