---
type: prompt
date: 2026-09-09
status: actief
tags: [marketing, prompt, architectuur]
project: ZekerWet
---

Tweede vervolgprompt voor de projectterminal van [[ZekerWet]], na afronding van fase 0. Volgt op [[marketing-os-vervolgprompt]].

Beslissingen die hierin verwerkt zijn: prijzen blijven staan en de site wordt gecorrigeerd naar inclusief BTW, X blijft handmatig maar gaat wel door de gate, en de fase 4 en 7 splitsing van Claude is geaccepteerd.

```
Phase 0 accepted. Answers below, then go for Phase 1.

═══════════════════════════════
1. BTW — DECIDED
═══════════════════════════════

Prices stay where they are. The site is what is wrong, not Stripe.

I verified your finding independently before deciding: no automatic_tax, no tax_behavior and no tax rates anywhere in src/, unit_amount set directly at stripe.service.ts:255 for subscriptions and :379 for documents, while pricing/page.tsx:302 and :320 advertise a 21% surcharge. Your analysis holds, and it applies to all three subscription tiers, not only single documents.

I am not raising prices. €14,99 and €24,99 stay as they are and become inclusive of BTW. I accept the lower net figure. Two reasons: I am not putting a 21% increase in front of a customer base this small, and the amounts charged are already what every customer has agreed to.

What follows from that:

1.1 — Marketing house style: CONFIRMED as you proposed. Bare charged amount, no qualifier. Build the validator rule to read the config so that if automatic_tax is ever enabled the rule inverts by itself. No marketing copy needs to change.

1.2 — The site copy is wrong and stays wrong until fixed, but it is not marketing scope. Do NOT fix it in this build. Instead give me a precise change list I can ship as its own small PR: every file and line that claims 21% comes on top, including pricing/page.tsx:302, pricing/page.tsx:320, BuyDocumentCard.tsx:33 and the misleading comment at documents.ts:310. Recommend the exact wording. Since my buyers are mostly ondernemers who reclaim BTW, I want the qualifier stated explicitly on the site rather than left bare — "incl. 21% BTW" — so a business buyer reads the number correctly.

1.3 — One thing to check and report, changing nothing. ZekerWet is BTW-registered under NL005206648B68. If a customer receives a Stripe receipt or invoice that does not state the BTW component correctly, that is a compliance defect on a compliance product, and it is worse than the pricing page. Look at what Stripe actually sends and tell me what you find. Report only. No code, no Stripe dashboard changes.

═══════════════════════════════
2. X — DECIDED
═══════════════════════════════

X stays in the plan and stays manual. I am not upgrading Buffer for a fourth channel at 36 people of reach.

But manual cannot mean what it meant before. Manual is what produced zero posts in five months and a logbook line claiming an X thread was posted when the source content was the word ONTBREEKT.

So X becomes a first-class content object like every other platform: platform "x", same schema, same validation gate, same UTM rules, same duplicate detection. The only difference is the last step. Design it so that:

- The weekly approval CLI prints the approved X posts ready to copy and paste, in the same run where I approve everything else. One ritual, not a separate task I will forget.
- Publication is recorded when I confirm it in the CLI, never by a line written in advance. An unconfirmed X item is not PUBLISHED — give it an honest state and let the weekly report count it as a skipped slot.
- The two scheduled tasks pointing at the nonexistent week-content.md go away in Phase 1.

Be honest in your design notes about the odds. If after a month the copy-paste step is not happening, I want the report to say so plainly so I can drop the channel without ceremony rather than keep a dead lane in the calendar.

═══════════════════════════════
3. YOUR COUNTER-ARGUMENTS — ACCEPTED
═══════════════════════════════

3.1 — Phase 4 as a deterministic drafting engine, LLM generation at Phase 7. Your cut is better than mine. The bottleneck was never prose speed and you are right that autonomous Dutch legal copy before the claims library has substance gives the gate nothing to check against.

One condition. "Repurpose fan-out" must not become verbatim cross-posting. Your own audit lists that as a defect: schema.md requires a rewrite per platform, and the 8 September Instagram caption was the Facebook text character for character, LinkedIn-length paragraphs included. Fan-out produces platform-specific variants, and the near-duplicate rule applies across platforms as well as within them. If you want an exemption for a specific pair of channels, state it explicitly with the reason rather than letting it happen by omission.

3.2 — Blocked slots stay empty. Agreed, and for the reason you gave. Make skipped slots a first-class number in the weekly report.

3.3 — Kennisbank at Phase 6 with the MDX extraction. Agreed. The two-files-nothing-keeps-in-sync problem you found is exactly the drift I expected. Hard rule confirmed: every article links to a real /documenten/<slug> page.

3.4 — Vault disposition table. Agreed as written. One check: the vault auto-commit only stages Context, Daily, Projects, Intelligence and Resources. Make sure everything you archive or create lands inside one of those five, or it silently never reaches git. Archived project material goes to Intelligence/archive/.

═══════════════════════════════
4. ON YOUR OWN CHECKER BUG
═══════════════════════════════

Good catch, and the right way round: the acceptance test caught it rather than production. Keep the bare-number case as a permanent fixture in the Phase 3 regression suite, not just in the stopgap. The real defect took exactly that form and a suite that only tests the € prefix would have shipped the same hole twice.

═══════════════════════════════
5. GO FOR PHASE 1
═══════════════════════════════

Start Phase 1. Facts layer, config imports, KENNISBANK_SLUGS extracted to src/config/kennisbank.ts, claims.json, the claim checker, and the retroactive run over all 51 historical posts. I want to see what else that run turns up — that output is the point of the phase.

Report back before Phase 2. Do not start the content store until I have seen the retroactive results and the initial claims allowlist.

I am handling on my side, do not wait on me for Phase 1: the four post deletions on LinkedIn and Instagram, and rotating both the Buffer and the imgbb key. I will tell you when the new Buffer key is in secrets.local.ps1 so nothing in Phase 5 is built against the old one.

Still off limits in this build: Stripe, Clerk, document generation, the Copilot, prisma/schema.prisma, the site copy from 1.2, Phase 6 attribution, and any scheduled task other than the two dead X tasks.
```
