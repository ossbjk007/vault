---
type: prompt
date: 2026-09-10
status: actief
tags: [marketing, prompt, architectuur]
project: ZekerWet
---

Tiende vervolgprompt voor de projectterminal van [[ZekerWet]]. Volgt op [[marketing-os-fase4-go-prompt]].

Keurt de pre-flight goed en zet 4.2 en 4.3 door. Corrigeert de weeknummering, want de eerste echte goedkeuringsronde is zondag 20 september en niet 13 september. Voegt twee gaten toe: de pre-flight zelf heeft geen dodemansknop, en de scheduler mag niets kunnen scherpstellen dat vuurt voordat de pre-flight nog een keer draait.

```
Pre-flight accepted. --simulate-facts-change is the best thing in this report and I want to say why, because it is a habit worth keeping: showing me six green rows proves nothing except that nothing was wrong today. Rehearsing tomorrow's price change against the real armed content is the only thing that demonstrates the block path exists. Do that by default from now on — a safety mechanism that has only ever been observed passing has not been observed.

Your call that a facts change forces a re-check rather than a blanket block is right, and for exactly the reason you gave. A gate that disarms the whole queue every time a config value moves is a gate I would switch off within a month.

The disarm ordering is right too. Buffer first, then local: a disarmed post with a stale object is recoverable, the reverse is the incident itself.

═══════════════════════════════
1. YOUR DATE IS OFF BY A WEEK
═══════════════════════════════

You wrote "Sunday is week 39." It is not, and this matters because a slipped week is how this project failed twice before.

  Sun 13 Sept  ISO week 37   ← this Sunday
  Mon 14 Sept  ISO week 38   ← already drafted, approved, armed
  Sun 20 Sept  ISO week 38   ← the first real approval run, for week 39
  Tue 22 Sept  ISO week 39   ← first post of that week

So the approval CLI has ten days, not three. That is good news, and it is also the trap: a deadline that turns out to be further away is the one that quietly slides.

Which brings up the thing that actually has a date on it, and it is not the CLI.

Week 39 content does not exist. The drafting engine is behind the publisher in the order I set. So one of two things has to happen before 20 September, and I want it decided now rather than discovered on the Sunday:

  · the drafting engine lands in time and produces week 39, or
  · you hand-draft week 39 the way you did week 38

Decision date: Thursday 17 September. If the engine is not clearly going to be ready and tested by then, hand-draft week 39 that day and stop working on the engine until it is out of the way. An approval CLI that opens on Sunday with nothing in it is a worse outcome than a hand-drafted week, and "we were nearly there" is not a week of content.

═══════════════════════════════
2. THE PRE-FLIGHT HAS NO DEAD-MAN'S SWITCH
═══════════════════════════════

We just spent a session establishing that a monitor which dies quietly is the failure mode, and then built a second monitor with the same property.

The healthcheck is named zekerwet-marketing-reconciler and watches one task. ZekerWet_Preflight runs daily at 18:00 on the same laptop. If the machine is off at 18:00, no pre-flight runs, the 07:45 post fires unchecked the next morning, and nothing anywhere notices — because the reconciler pinged fine at 17:00 and will ping fine at 19:00.

That is worse than the reconciler going dark, because the pre-flight is the only thing standing between armed content and a stale-facts publication.

Fix it, and I would rather it be tied to the content than to a second timer. The reconciler already knows nextDueAt and nextDueId. It should be able to say: the next armed post fires at time T, and the last successful pre-flight was before T minus a day, therefore something is armed that nobody has re-checked. That is a statement about risk rather than about a schedule, and it stays true even if the timers are reorganised later.

A second healthchecks check is the cruder alternative. Tell me which you would build and why. What I will not accept is an unwatched watcher.

═══════════════════════════════
3. THE SCHEDULER MUST NOT BE ABLE TO ARM PAST THE GATE
═══════════════════════════════

For 4.3, a constraint I want in the design rather than discovered later.

The pre-flight exists because content can sit parked between approval and publication. But if the scheduler can arm something that fires before the next pre-flight run, that item goes out having been checked exactly once — at authoring time — which is the state we started from.

So: the scheduler may not arm anything due before the next scheduled pre-flight unless it runs one first and it passes. Not a warning, a refusal. Rush-scheduling is precisely when a mistake gets through, so it is the last place to make an exception.

═══════════════════════════════
4. THEN 4.2 AND 4.3
═══════════════════════════════

Approval CLI and scheduler with Buffer cap management, then the publisher. adopt-week38.ts and the stopgap checker deleted in the same commit, so no second path to Buffer survives.

Three things on the approval flow:

4.1 — Silence is never consent. Your own blueprint had this and I want it kept literally: anything not answered stays unapproved and does not publish. An empty slot is a visible, countable failure. A post that published because nobody said no is the logbook's sin in a new place.

4.2 — The manual block prints everything I have to do by hand, in one place, in one run: the X texts to paste, and any bio change. Nothing that requires me to be somewhere else gets mentioned anywhere else.

4.3 — Tell me what happens when I approve nothing at all, because that week will come. I want the report to say plainly that a week went out empty and why, rather than a quiet gap that looks like a light week.

═══════════════════════════════
5. NOTED, NO ACTION NEEDED
═══════════════════════════════

The 12h critical threshold being wording rather than an alarm: good that it is written down that way. Three numbers where only two fire is exactly what gets misread six months later.

The Vercel Ignored Build Step is a real catch. Hourly bot commits triggering hourly production rebuilds of a change that cannot affect the site would have been an unpleasant surprise on the day of the move, and render-log.ts writing into a vault that CI does not check out is the second one. That parked decision is now actually parked rather than postponed.
```
