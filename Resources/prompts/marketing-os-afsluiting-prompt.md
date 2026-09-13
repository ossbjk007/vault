---
type: prompt
date: 2026-09-10
status: actief
tags: [marketing, prompt]
project: ZekerWet
---

Vijftiende vervolgprompt voor de projectterminal van [[ZekerWet]]. Volgt op [[marketing-os-deploy-prompt]].

Sluit de bouwronde af: deploy zelf geverifieerd, het PII-script is verwijderd, en er ligt één notitie voor het geparkeerde GitHub Actions-besluit over de detectie van wijzigingen.

```
Deploy verified independently against production, not against your report: article 200, all four corrected passages served, waterdicht absent, seven kennisbank URLs in the sitemap, and both AVG tiers live with the right articles named. It holds.

The exit-code measurement is the best thing in your report. You piped through tail, so $? reported tail's status, and you were about to write "exits non-zero" from a measurement structurally incapable of showing it. That is the fourth instance in one day and the clearest one, because the mechanism you were testing was the mechanism for not doing exactly that. Reporting it rather than quietly re-running is what makes the rule real.

Two things, then we are done for this round.

═══════════════════════════════
1. THE CUSTOMER-DATA SCRIPT IS GONE
═══════════════════════════════

Good catch keeping scripts/fix-ananda.ts out of the commit. I checked it and it was worse than a one-time save: untracked and not in .gitignore, so it depended on someone remembering every single time. One git add -A and a real customer's email plus their cus_ and sub_ identifiers were in the history of a product that sells AVG compliance, effectively permanently.

I deleted it. Its job was done — 52 lines, a single prisma.user.upsert, referenced nowhere.

The method is preserved in the vault under subscription-provisioning, without any customer identifiers, with a note saying to pass them as command-line arguments next time rather than baking them into a file.

If you write another repair script, that is the rule: identifiers as arguments, never in the file.

═══════════════════════════════
2. A NOTE FOR THE PARKED GITHUB ACTIONS DECISION
═══════════════════════════════

You mentioned the 20:00 reconciler re-stamped 50 content files with only lastPulledAt and generated. Harmless today, but it undercuts the parked decision and I want it recorded now rather than discovered on the day of the move.

The parked design says commit-on-change. If lastPulledAt is rewritten on every pull, then everything changes on every run, and commit-on-change means fifty files committed hourly. That is the actual cause underneath the Vercel rebuild problem you identified, not a separate issue.

So change detection has to be finer than "the file differs": a pull that only re-stamps a timestamp is not a change worth committing. Decide whether that means excluding those fields from the comparison, or not writing them when nothing else moved, or something else — and write it into HEARTBEAT.md next to the rest of the parked decision.

Do not build it now. It belongs to the move, and I would rather the parked decision be complete than early.

═══════════════════════════════
3. WHERE THIS STANDS
═══════════════════════════════

Nothing else is open from my side. The queue is armed and verified, the gate covers seven articles and every historical defect, both monitors watch each other, and the kennisbank has moved for the first time since this started.

Next is Thursday 17 September: week 39 hand-drafted in one run, as committed. Then the rota, one article a week, at the rate you told me was real.
```
