---
type: prompt
date: 2026-09-09
status: actief
tags: [marketing, prompt, content]
project: ZekerWet
---

Vijfde vervolgprompt voor de projectterminal van [[ZekerWet]]. Volgt op [[marketing-os-week1-prompt]].

Keurt vier van de zes items voor de week van 15 september goed, en laat twee dingen repareren: een omgekeerde juridische redenering in de X-post van 18 september, en een onklikbare Instagram-CTA waarvan de UTM de verkeerde route beschrijft.

```
Reviewed all six. The writing is good — they sound like the brand, the statute is right, and the 17 September post is exactly as careful as it needed to be after the pricing incident. I verified "AI Document Review zit in elk abonnement" against pricing.ts myself: 1, 10 and unlimited across the three tiers. The claim holds.

I also checked the new email wording against the template. Ordernummer, aankoopdatum and the BTW breakdown are all genuinely there, so the sentence is true and it stands. On the judgment call: your reasoning was sound and you flagged it, which is why it stands. But next time two of my instructions conflict, ask me — do not pick one. It took ten seconds to check and it could as easily have been wrong.

APPROVED as written, no changes:
  2026-09-15  linkedin  wetdba-drie-criteria
  2026-09-16  x         wetdba-gezag
  2026-09-17  linkedin  ai-review-opdracht
  2026-09-18  facebook  wetdba-carousel

Two items need fixing before I approve them.

═══════════════════════════════
1. THE 18 SEPT X POST HAS THE LAW BACKWARDS
═══════════════════════════════

2026-09-18-x-opdracht-vervanging.txt, second sentence:

  "Staat er niet in dat je je mag laten vervangen? Dan mis je het eerste criterium van art. 7:610 BW."

The three criteria are conditions FOR an employment relationship. If free replacement is absent, persoonlijke arbeid is satisfied, which points toward a dienstverband. The post says the reader "misses" the criterion, which reads as though they are better off. It is inverted.

Replace that sentence with:

  "Dan wijst het eerste criterium van art. 7:610 BW juist richting een dienstverband."

Re-run the gate on it after the edit.

Then answer this honestly rather than inventing a rule to look thorough: is there any class of check that could have caught this? The statute was on the allowlist, the citation was correct, and the sentence was grammatical — the error was in the direction of the reasoning. If that is not mechanically checkable, say so plainly and note it as a known limit of the gate. I would rather have an honest boundary than a rule that pretends to cover something it cannot.

═══════════════════════════════
2. THE INSTAGRAM CTA IS DEAD TEXT, AND ITS UTM DESCRIBES THE WRONG ROUTE
═══════════════════════════════

2026-09-18-instagram-wetdba-carousel.txt ends with "Link in bio, of: https://…" carrying a 180-character tagged URL.

Instagram does not make caption links clickable. So that string is unclickable, it reads as spam, and the traffic that does arrive comes through the bio — while the tag says utm_source=instagram&utm_medium=social-carousel. Analytics would attribute bio traffic to a route it did not take. That is the exact measurement error we are in the middle of fixing.

Fix the post: drop the URL from the caption, put the tagged link in the bio, and tag it utm_medium=bio.

But this is not only a copy fix, and I want the architecture handled rather than patched.

2.1 — The validator requires a CTA link in the body. On Instagram that rule can only ever be satisfied by a dead URL. Add a destination type for link-in-bio so an Instagram post can pass the gate with its CTA living in the bio instead of the caption, without weakening the rule for platforms where links do work.

2.2 — Be honest about the attribution limit this creates. The bio is one slot shared by every Instagram post, so utm_content cannot identify a single post the way it does on LinkedIn. Tell me what the realistic granularity is — per campaign, per week, or something else — and what it would take to get finer than that. Do not quietly emit a per-post utm_content that the bio cannot actually carry.

2.3 — The bio link is now a thing that has to be kept in sync with what is published. Say who changes it and when. If it becomes another manual step I will forget, it belongs in the weekly approval run alongside the X copy-paste, not in a note somewhere.

═══════════════════════════════
3. THEN SCHEDULE, THEN PHASE 3
═══════════════════════════════

Show me the two fixed items. Once I approve them, schedule the four Buffer items and hand me the two X texts for Wednesday and Friday.

Then Phase 3, with D2_VERBATIM_CROSSPOST as a hard block. Acceptance test unchanged: the regression suite catches all seven historical defects from the backfilled corpus, each firing a named rule, and I want to see that output before you tell me it works.
```
