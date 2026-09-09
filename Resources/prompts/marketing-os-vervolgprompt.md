---
type: prompt
date: 2026-09-09
status: actief
tags: [marketing, prompt, architectuur]
project: ZekerWet
---

Vervolgprompt voor de terminal waar [[Ali Can]] aan [[ZekerWet]] werkt, als antwoord op het architectuurvoorstel `ZekerWet Marketing OS` (artifact 9fbc1fe2) en de audit `The ONTBREEKT Report` (artifact a749fedd). Context en achtergrond staan in [[marketing]] en [[theme-tracker]].

Beslissingen die hierin verwerkt zijn: prijszin herschrijven in plaats van annuleren, SEO erbij zonder social af te schalen, en fase 0 tot en met 3 bouwen terwijl er handmatig doorgepost wordt.

```
Decisions on your architecture proposal (artifact 9fbc1fe2). Answers first, then what you left out, then the build scope.

═══════════════════════════════
1. DECISIONS
═══════════════════════════════

1.1 — The 10 September post: EDIT, do not cancel.

Rewrite the pricing sentence to "Vanaf EUR 14,99 per document, of een abonnement vanaf EUR 24,99 per maand." Push that edit through the Buffer API today. Everything else in the post stays exactly as written. Do this before you write a single line of architecture code. It fires at 07:45 tomorrow.

While you are in there, settle the BTW question and give me your recommendation: DOC_TIER_PRICES is commented "excl. 21% BTW" and every post so far has quoted EUR 14,99 bare. If that is wrong it is wrong on every published post, and it needs a validator rule, not a one-off patch. Tell me which house style you recommend and why.

1.2 — The 11 September duplicate: CANCEL.

Both ids, via the Buffer API. Record it as CANCELLED with reason "duplicate". Do not delete the historical record.

1.3 — Location: ACCEPTED.

zekerwet/marketing/ as a sibling workspace in the product repo, one-way boundary, enforced by ESLint no-restricted-imports, excluded from the app tsconfig path, no route and no API surface. Your reasoning holds: my own requirement was validating claims against product config, and a JSON snapshot is a copy that goes stale.

One thing to verify before you commit to this: you flagged OneDrive sync races as a real risk. Confirm whether the ZekerWet repo actually sits inside a OneDrive-synced path. If it does, I want to see the lockfile and the pre-run conflict-file check working before Phase 2 ships, not described.

1.4 — Approval interface: CLI FIRST.

npm run mkt:approve. No Telegram bot in this build. Reuse notify.ps1 for one-way alerts only.

1.5 — Strategy: SEO YES. Social volume UNCHANGED.

I accept the kennisbank/SEO argument in full. 233 document pages in the sitemap against 5 articles, with search intent that needs no audience, is the right read and it is the highest-leverage thing I am not doing.

I do not accept demoting social to 3 posts a week. Social stays at the current cadence. I want both.

Now be direct with me about the consequence instead of quietly agreeing. At 5 social posts a week plus 1 to 2 articles, hand-written content is not survivable. That volume is exactly what produced a 74-day blackout and a 63-minute panic session. So this decision changes the phase order, not just the calendar.

My assumption is that Phase 7 (generation) stops being optional and moves much earlier, possibly directly after the gate. Tell me whether you agree. If you think there is a better answer than "generate earlier", argue it. What I do not want is a calendar designed at a volume I have never once hit, with the generation that makes it possible parked in month 2 as optional.

1.6 — Build scope: PHASES 0 THROUGH 3, and publishing does not freeze.

Build containment, facts layer, content store and the gate as one unit. Stop there and show me the regression suite catching all seven historical defects before going further.

But I am not going dark for six days while you build. The queue empties on 11 September, and silence is what got us here in the first place. So Phase 0 gets one addition: a minimal hand-run pre-publication check. Placeholder tokens, minimum length, valid CTA URL, and price and entitlement claims checked against PLAN_TIERS. Fifty lines. No schema, no store, no scheduler. I write next week's posts by hand, run that check, and schedule them myself.

Treat it explicitly as a stopgap with a delete date: it gets removed in Phase 4 together with schedule-week3.ps1 and post-carousel.py, so no second path to Buffer survives. Say that out loud in the code and in your summary.

═══════════════════════════════
2. WHAT YOUR PROPOSAL LEAVES OUT
═══════════════════════════════

2.1 — There is no kennisbank pipeline anywhere in your phase plan.

SEO is now the strategic priority and not one of your eight phases builds it. Articles do not go through Buffer; they are pages in the Next.js app. Your content object has platform: "kennisbank" and the validator has a 900-character floor, but there is no path from draft to published article: no slug registration, no sitemap update, no internal-linking rule from articles to the document pages they should feed.

Design that pipeline and place it in the phase order. It must share the same content object, the same validation gate and the same UTM rules. A separate, unvalidated authoring path for articles would recreate the exact failure we are removing.

2.2 — Vault files that are now false sources of truth.

theme-tracker.md still states the cycle started 10 August and computes the current week from that date. schema.md still describes the 6-slot week. If the 4-week rotation is retired, those documents cannot stay in the vault reading as current guidance.

Tell me exactly which vault files to rewrite, archive or delete, and what replaces them. Do not leave contradicting documents in place. That is the same class of error as the logbook recording intentions as outcomes.

2.3 — Secrets.

post-carousel.py holds the Buffer API key and the imgbb key as hardcoded fallback defaults, inside a OneDrive-synced folder. Your backlog has this as a "medium, weeks 2 to 4" item. Move it into Phase 0. And tell me which keys need rotating rather than merely relocating, given where that file has been sitting.

2.4 — What the queue does when the gate blocks something.

You designed the block alert. You did not say what happens to the slot. If pre-flight blocks Thursday's post, does the slot stay empty or does the scheduler pull the next approved item forward? Decide it explicitly. My preference is empty over wrong, but I want it stated in the design rather than left to whatever the code happens to do.

═══════════════════════════════
3. BUILD ORDER AND LIMITS
═══════════════════════════════

Build Phase 0 first and completely: the 10 September edit, the 11 September cancellation, the secrets rotation, and the stopgap checker. Then report back before starting Phase 1.

Then Phases 1 through 3. The acceptance test is your own: the regression suite must flag both ONTBREEKT posts, both Instagram test posts, both duplicate carousels and the 10 September pricing claim from the backfilled corpus, each firing a named rule. I want to see that output before you tell me it works.

The four already-published items I delete myself on LinkedIn and Instagram. Give me the four URLs in one list.

In this build, do NOT:
- touch Stripe, Clerk, document generation, the Copilot, or prisma/schema.prisma
- start Phase 6 attribution or the four User columns
- build the Telegram approval bot
- delete anything from the historical record
- change any scheduled task before Phase 4
- publish anything through new code

If any of the six decisions above is wrong on technical grounds, say so before you build rather than after.
```
