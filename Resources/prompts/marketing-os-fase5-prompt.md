---
type: prompt
date: 2026-09-10
status: actief
tags: [marketing, prompt, architectuur]
project: ZekerWet
---

Zevende vervolgprompt voor de projectterminal van [[ZekerWet]]. Volgt op [[marketing-os-fase3-prompt]].

Draait de fasevolgorde om: eerst fase 5, de reconciler, omdat er vier posts staan ingepland voor 15 tot 18 september zonder dat iets controleert of ze live gaan, en Buffer cijfers maar 31 dagen bewaart. Fase 4 schuift één ronde op.

```
Phase 3 accepted. 9/9 with named rules, and the "also blocked by" lines are the part that matters — most defects trip three or four independent rules, so the gate does not depend on one lucky regex. The blueprint correction landed properly: legal tier permanently manual, allowlisting scoped to citation rather than reasoning, and the limit written next to the gate spec and in the validator README rather than only in the exceptions file.

I verified this morning's post myself through the Buffer API: status sent, sentAt 05:45:03Z, live at linkedin.com/feed/update/urn:li:share:7503689980549201920, and the corrected pricing sentence is in the text as sent. The Phase 0 fix held all the way to publication.

Push c071b72. Unpushed work sitting on a laptop inside a OneDrive folder is the same class of risk we spent two days removing, and you are right that it changes nothing in production.

═══════════════════════════════
1. PHASE 5 GOES BEFORE PHASE 4
═══════════════════════════════

I am reordering, and I want you to argue with me if the reasoning is wrong rather than just complying.

Four posts are scheduled for 15 to 18 September and nothing in the system verifies that any of them actually goes live. That is precisely the ONTBREEKT lesson: scheduled is not published, and the old accountability check failed because it read a plan instead of an outcome. We have rebuilt everything upstream of publication and nothing downstream of it.

Second reason, and it has a deadline attached. Buffer's free plan serves 31 days of insights. You said yourself the reconciler is not a convenience but the only way I will ever have performance history. If it is not harvesting by mid-October, week 38 is permanently unmeasurable — and week 38 is the first properly built week in this company's history. Losing its numbers would be a bad joke.

Against that, Phase 4 buys drafting efficiency. Week 38 was drafted in a single run and it worked. I can do week 39 the same way. Efficiency can wait a round; verification cannot, because its window closes on its own.

So: build Phase 5 now, finished and live before 15 September, so week 38 is the first week that verifies and measures itself. Phase 4 moves one round back.

═══════════════════════════════
2. WHAT PHASE 5 HAS TO DO
═══════════════════════════════

Per the blueprint: hourly status verification, nightly metrics harvest, logbook generation into the vault, Telegram alerting reusing notify.ps1, and retiring accountability-check.ps1 along with the ZekerWet_AvondCheck task.

Four things I want held to, beyond the spec:

2.1 — PUBLISHED requires a live URL, always. status === "sent" plus a non-null externalLink plus sentAt. Nothing else counts. You already proved in Phase 2 that list_posts does not return externalLink and get_post does; make sure the reconciler reads from the source that actually carries the field rather than inferring success from the cheaper call.

2.2 — Failure has to be loud on the first occurrence. An item stuck in SENT_TO_BUFFER more than six hours past dueAt becomes FAILED and alerts me. Do not let a retry loop quietly swallow it. Test it with a fixture where Buffer says sent but externalLink is null — that item must never reach PUBLISHED.

2.3 — The generated logbook replaces the hand-typed one and says so in its own header. The frozen file stays where it is. My commentary lives in a notes field on the object that the generator preserves. If there is anything the generator cannot round-trip, tell me now rather than after it has silently dropped something I wrote.

2.4 — Retire accountability-check.ps1 in the same commit that the reconciler goes live, not before and not after. I do not want a window where the old check is gone and the new one is not running, and I do not want both running and disagreeing.

═══════════════════════════════
3. THE METRICS CLOCK
═══════════════════════════════

Start harvesting immediately once it works, not on 15 September. There are 48 sent posts in the corpus and the ones from mid-August onward still have insights inside the 31-day window. Whatever is still reachable today is reachable for the last time. Pull it, store it, and tell me plainly how much history you managed to recover and how much was already gone.

Store harvested metrics locally in a form that survives Buffer's window. The point is that the 31-day limit stops mattering from today onward.

═══════════════════════════════
4. AFTER PHASE 5
═══════════════════════════════

Then Phase 4, the deterministic drafting engine, with the fan-out producing genuine per-platform variants rather than cross-posts — D2 is a hard block now, so a verbatim fan-out means the engine failed and it should fail loudly.

Do not start Phase 4 in this run. Finish Phase 5, show me the verification working against a real scheduled item, and stop.
```
