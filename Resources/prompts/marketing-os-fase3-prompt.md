---
type: prompt
date: 2026-09-09
status: actief
tags: [marketing, prompt, architectuur]
project: ZekerWet
---

Zesde vervolgprompt voor de projectterminal van [[ZekerWet]]. Volgt op [[marketing-os-week1-fixes-prompt]].

Keurt de week van 15 september volledig goed en geeft groen licht voor fase 3. Bevat één correctie op het architectuurvoorstel: de conclusie dat menselijke goedkeuring de enige verdediging is tegen redeneerfouten spreekt sectie 5 van dat voorstel tegen, en die sectie stuurt fase 4 en 5 aan.

```
Both fixes read and approved. The X sentence is verbatim, the Instagram caption is clean, and I checked the character counts myself — both X items sit well under 280.

Your rewritten opener stays. "Kost niets om vast te leggen" is more concrete than "de goedkoopste bepaling" and it is a better sentence. You flagged it instead of slipping it past, which is the whole point.

ALL SIX APPROVED. Schedule the four Buffer items. Hand me the two X texts and the bio URL for week 38.

═══════════════════════════════
1. ONE THING YOU DID NOT FOLLOW THROUGH ON
═══════════════════════════════

Your answer on the inverted logic is the sharpest thinking in this project so far, and I want to make sure it survives contact with the code rather than staying a good paragraph in a terminal.

You concluded: human approval is the only defence against reasoning errors, and always will be. Therefore legal-tier approval should stay permanently manual rather than being automated away as the claims library fills.

Section 5 of your own architecture says the opposite. On the legal tier it reads: "You approve once, then it is allowlisted and reusable," with the rationale "cost falls to near zero over time as the claim library fills."

Those cannot both be the design, and Phases 4 and 5 get built on section 5. If it stays as written, the system will eventually automate away exactly the step you just argued is the only thing standing between me and a published inversion.

Update the blueprint. Make the distinction explicit: allowlisting covers whether a statute may be cited, never whether the reasoning around it is sound. A previously approved statute reduces the fact-checking burden and does not reduce the approval requirement. Legal tier stays manual, permanently, by design rather than by omission.

While you are in there, record the limit itself in the blueprint rather than only in the exceptions file — a known boundary of the gate belongs next to the description of what the gate does, so the next person reading it does not assume more coverage than exists.

I agree with your refusal to bolt on a "mis je" tripwire, and for your reason. A rule that covers one phrasing of one error while implying the class is handled is worse than no rule.

═══════════════════════════════
2. INSTAGRAM ATTRIBUTION — ACCEPTED AS PROPOSED
═══════════════════════════════

Per-week granularity, and buildUrl throwing in both directions so per-post data cannot be faked. Agreed.

Agreed on staying there for now, and for your reason: at four reactions across five posts, per-post Instagram attribution would be measuring noise precisely. The zekerwet.nl/ig landing page is the right answer when a bio link actually delivers sessions. Note it in the blueprint as the named next step with that trigger, so it is a decision waiting on evidence rather than a thing we forgot.

Bio changes in the weekly approval run, printed only when they differ, unconfirmed means unconfirmed: accepted as designed.

═══════════════════════════════
3. PHASE 3
═══════════════════════════════

Start it. D2_VERBATIM_CROSSPOST as a hard block.

Acceptance test unchanged: the regression suite catches all seven historical defects from the backfilled corpus, each firing a named rule. Show me that output before you tell me it works.

Add the two defects you found in your own rules to that suite as permanent fixtures — the bare-number price form and the case-insensitive statute match. Both were found by testing rather than in production, and both would have shipped silently. They belong in the suite for the same reason the seven historical ones do.
```
