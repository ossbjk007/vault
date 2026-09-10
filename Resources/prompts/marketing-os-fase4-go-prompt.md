---
type: prompt
date: 2026-09-10
status: actief
tags: [marketing, prompt, architectuur]
project: ZekerWet
---

Negende vervolgprompt voor de projectterminal van [[ZekerWet]]. Volgt op [[marketing-os-fase4-prompt]].

Beantwoordt zijn twee vragen: GitHub Actions wordt geparkeerd achter een benoemde trigger, healthchecks wordt vandaag gezet. Daarna groen licht voor fase 4.

```
Sections 1 through 4 accepted. PLATFORM-LIMITS.md with a provenance level per row is a better answer than I asked for — API, OBSERVED, DOC and REPORTED means the next person can tell a tested constraint from a repeated one, and npm run mkt:limits makes it re-checkable rather than a snapshot that rots. Flagging that post character limits are DOC and not obtainable, instead of quietly presenting them as verified, is the right instinct.

Two answers, then Phase 4.

═══════════════════════════════
1. GITHUB ACTIONS — PARKED, WITH A NAMED TRIGGER
═══════════════════════════════

Do Phase 4 first. But I want to be honest about why, because my original argument for urgency has the same defect I just made you fix.

I pushed the reordering partly on "Buffer only keeps 31 days, so a laptop that is off loses data." That turned out to be false, and it was your own correction that killed it. Per-post metrics come back to 16 April. So a laptop that stays off for a week now means verification arrives late, not that anything is lost. That materially lowers the cost of staying local, and I am not going to keep leaning on an argument after its factual basis was withdrawn.

What remains is real but smaller: a failed publish on 15 September goes unnoticed until the machine wakes. At current reach that is a week of a dead slot, not a disaster. The dead-man's switch covers exactly that, and it is already built.

So: local now, GitHub Actions later, Vercel rejected. Your reasoning on Vercel is right and I want it kept — the heartbeat is written on the laptop, so the data has to leave the machine either way, and moving the reconciler would turn a git-diffable file store into a database migration. That is a rewrite wearing a phase's clothes.

Record GitHub Actions as the named next step with an explicit trigger rather than "later": the first time the dead-man's switch actually fires, or the first week a scheduled post is not verified within 24 hours. Whichever comes first.

1.1 — One thing the parked decision is missing, and I want it written down now while you still have the reasoning loaded. On Actions the reconciler would be writing to a content store that lives in the repo, so it has to commit back. That is a bot writing to main on a schedule, and it interacts with the vault auto-commit and with your own working tree. Decide the shape now — dedicated branch, commit-on-change only, what happens on a conflict — and put it in HEARTBEAT.md. A parked decision that omits its hardest part is not parked, it is postponed.

═══════════════════════════════
2. HEALTHCHECKS — I AM DOING IT TODAY
═══════════════════════════════

Agreed, and you are right that it is the only thing between the reconciler stopping and me finding out. I will create the check and put HEARTBEAT_PING_URL in secrets.local.ps1 today.

Two things from your side:

2.1 — Tell me exactly what the check should be named and what period and grace you want, so the dashboard matches the design rather than me guessing. You said 1h period and 2h grace; confirm that is still right given stale-at-3h and critical-at-12h, because those three numbers should agree with each other and right now I cannot tell whether they do.

2.2 — Make it visible that the ping is unset. Right now pingExternal() is a silent no-op while HEARTBEAT_PING_URL is empty, which means the dead-man's switch is built, believed to be working, and is not. That is the same shape as the accountability check reporting success. Have the reconciler say plainly in its run output when the external ping is not configured, so it cannot sit silently disabled.

═══════════════════════════════
3. YOUR HOOKS ARE BROKEN
═══════════════════════════════

Unrelated to marketing, but it showed up in your own output twice and you did not mention it.

Two UserPromptSubmit hooks are failing on paths that lost their separators: .claudehookssync-status.ps1 and .claudehooksfocus-drift.ps1, which should be .claude\hooks\sync-status.ps1 and .claude\hooks\focus-drift.ps1. Either the backslashes were eaten when the setting was written, or the scripts were never created.

Do not go hunting for it: I already searched. Every hit for sync-status and focus-drift is in conversation transcripts — file-history, paste-cache and session jsonl files — and not one is in a settings.json. The config is no longer on disk, so your session is almost certainly running the old hooks from memory. Restart that terminal once this work is done and the errors should disappear on their own. If they come back after a restart, then it lives somewhere neither of us has looked and it is worth ten minutes. Not before.

═══════════════════════════════
4. SOMETHING FELL OFF THE PLAN AND I WANT IT BACK BEFORE THE DRAFTING ENGINE
═══════════════════════════════

I went looking for what is still missing rather than trusting the phase numbers, and found a hole. I own it — I approved the Phase 4/7 re-cut without checking what it displaced.

The blueprint's original Phase 4 was the publisher: approval CLI, scheduler with cap management, publisher, and the T−24h pre-flight. When you re-cut Phase 4 into the deterministic drafting engine and moved LLM generation to Phase 7, that publisher work was never re-homed. It is in no phase now.

What I actually found:

  grep -rl "preflight|mkt:approve|capManagement|T-24" marketing/  → nothing
  package.json marketing scripts: check, scan, typecheck, test, backfill,
    demo-lock, draft-week, accept, reconcile, adopt, limits
    → no approve, no publish, no schedule, no preflight
  marketing/adopt-week38.ts, your own header:
    "One-off. Phase 4's scheduler creates objects up front and this goes away."

Three consequences, in order of how soon they bite:

4.1 — There is no T−24h pre-flight, and four posts are armed.

This is the mechanism the whole project exists for. Your own audit: a gate that only runs at authoring time would not have saved me, because at authoring time I knowingly wrote a placeholder and meant to come back. The gate has to run again before the queue fires.

Week 38's four items are sitting in Buffer until 15 to 18 September with nothing re-checking them. The factsHash quarantine you designed cannot fire, because nothing recomputes it. If a price or an entitlement changes this week, those posts go out against stale facts and the system will not notice — which is the original incident with better tooling around it.

Build the pre-flight first, and run it against the four queued items so I can see it pass or fail on real armed content.

4.2 — There is no approval CLI, and I am expecting one on Sunday.

I have been told the weekly ritual is ten minutes: approve the batch, collect the X texts, collect any bio change. None of that exists as code. Sunday is week 39.

4.3 — There is no scheduler, so week 39 would need another one-off.

adopt-week38.ts admits in its own comment that it is throwaway and that the scheduler replaces it. Another hand-written scheduling script is precisely the pattern this project was built to remove. It should not happen twice.

═══════════════════════════════
5. SO: PUBLISHER FIRST, DRAFTING ENGINE SECOND
═══════════════════════════════

Same reasoning as putting the reconciler ahead of the drafting engine, and for the same kind of reason: one of these has a date attached and the other does not.

Build the publisher track now — pre-flight, approval CLI, scheduler with Buffer cap management, publisher. Delete adopt-week38.ts and the stopgap checker in the same commit, so no second path to Buffer survives, as originally specified.

Then the drafting engine: topic bank from the 233-document catalogue, slot emitter, claims-library expansion, repurpose fan-out. If that lands after Sunday, week 39 gets hand-drafted the way week 38 was. That worked, and it is a far smaller cost than shipping into an unguarded queue.

Three things I want held to when the drafting engine does arrive:

  · The topic bank is derived, not written. Every topic traces to a slug that
    exists in DOCUMENT_TYPES, so a topic can never point at a dead route.
  · Fan-out variants differ in substance, not wording. Week 38 is the standard:
    second-person versus opdrachtgever-risk, not synonyms swapped. If the engine
    can only manage the synonym version, say so rather than shipping something
    that technically clears 0.85.
  · Generated drafts get no privileges. DRAFT, same gate, same risk tiers.
    Anything reasoning from a statute is legal tier and reaches me, permanently.

Start with 4.1. Show me the pre-flight running against the four armed posts before anything else.

If you think I have this sequencing wrong, say so now rather than after.
