---
type: prompt
date: 2026-09-09
status: actief
tags: [marketing, prompt, content]
project: ZekerWet
---

Vierde vervolgprompt voor de projectterminal van [[ZekerWet]], na fase 2. Volgt op [[marketing-os-fase2-prompt]].

Verschuift de volgorde: eerst content voor de week van 15 september, want de queue is na 10 september leeg, daarna pas het factuurvoorstel. Beslissingen: BTW-PR gaat live, Claude schrijft de concepten en [[Ali Can]] keurt goed.

```
Phase 2 accepted. The conflict guard and the transition property test are exactly what I asked for, and the backfill story is the right instinct: you hit PUBLISHED 0 / FAILED 48, and instead of relaxing the guard you went and got the real URLs. That is the whole point of the project working on its first real test.

I checked the two statistic rewrites myself in brand-voice.md. Art. 7:610 BW with the three cumulative criteria is correct and the binding rule underneath it is well put. Approved as written. Also noted that you corrected your own nine-line BTW list up to twelve rather than shipping the number you had already reported — do that every time.

But I am changing the order of what comes next, and I want to be plain about why.

═══════════════════════════════
0. THE PROBLEM WITH WHERE WE ARE
═══════════════════════════════

Three phases are built. After tomorrow's 07:45 post, my queue is empty. The first gated week is 15 September and not one word of it exists.

That is the failure we are supposedly fixing, reappearing in a better-engineered form. A system that cannot publish something broken is worth nothing if it is publishing nothing at all. So content jumps ahead of the invoice proposal.

═══════════════════════════════
1. FIRST — THE WEEK OF 15 SEPTEMBER
═══════════════════════════════

Draft the full week per cadence.md. Wet DBA / ZZP is the theme; it is the one that never ran and it is the strongest hook I have.

Tuesday 15 Sept 07:45   LinkedIn    educational      legal-pain
Wednesday 16 Sept       X           post or thread   manual
Thursday 17 Sept 07:45  LinkedIn    product          ai-review
Friday 18 Sept 09:00    Instagram + Facebook  carousel  document-education
Friday 18 Sept          X           post             manual

Rules for this batch:

- Every item goes through mkt:check before you show it to me. If something cannot pass, tell me why rather than softening the content until it does.
- Show me the complete text of each item. Not a summary, not a description of the angle. I am approving copy, so I need to read copy.
- No two items may be verbatim variants of each other. The Instagram and Facebook captions are the one place that rule has always broken; write them as separate texts even though the carousel is shared.
- Every CTA points at a route that exists. You have the catalogue and you now have the redirect list, so there is no excuse for a second /prijzen.
- Do not schedule anything. Draft, check, show me. I approve item by item, then you schedule.

1.1 — UTM starts here, not in Phase 6.

Five months of publishing produced zero attributable data. I am not adding two more weeks to that. The UTM builder is pure string work with no app dependency, so build it now and tag all five items.

The app side — the cookie, the Clerk metadata, the four User columns — stays in Phase 6 as planned. But Vercel Analytics already records landing parameters, so tagged links start earning data the moment they go out. Week one should be the first attributable week in the company's history.

1.2 — The carousel is the thing most likely to bite.

generate-carousels.py has week 3 copy hardcoded. Before you promise me a Friday carousel, tell me what it actually takes to produce one for this week. If it is a small change, do it and say so. If it turns into rewriting the renderer, say that instead and propose something for Friday that needs no new assets — I would rather have four good items and an honest gap than a Thursday-night scramble to render slides.

1.3 — Kennisbank.

Do not write an article yet; the pipeline is Phase 6 and I do not want a two-file hand edit becoming a habit. Instead give me a shortlist of the first four articles, chosen from the 233-document catalogue by search intent rather than by what is interesting to write. For each: the target query, the document page it links to, and why that query has buying intent. That shortlist is worth more right now than one article.

═══════════════════════════════
2. COMMITS AND THE BTW PR — SHIP IT
═══════════════════════════════

Split into the three commits you proposed: the BTW PR (12 files plus next.config.mjs), the Phase 1 kennisbank extraction, and marketing/.

Deploy the BTW PR to production. It is copy and two redirects, it is revertable, and every day it sits there is another day my own site contradicts the receipt my customers actually get. Confirm the two redirects resolve on the live domain after the deploy — /prijzen and /documenten/vaststellingsovereenkomst should both land on a real page, not a 404 and not a redirect loop.

═══════════════════════════════
3. THEN — THE INVOICE FINDINGS, SCOPE CHANGED
═══════════════════════════════

I am not writing a full proposal for this and I am not going to an accountant right now. At my current customer count the exposure is small and I would rather spend the week on getting content out. That is a decision, not an oversight, so record it as one.

Split the three findings:

3.1 — Findings 1 and 2 (no BTW line on subscription invoices, no Stripe invoice at all on document purchases) get parked. Do not build anything. Write them into the vault as a known accepted risk: what the defect is, who it affects, what it would take to fix, and the trigger that should make me revisit it. Name that trigger concretely — a customer asking for a factuur, a B2B customer wanting to reclaim BTW, or the first BTW return where I need outgoing invoice records. I want a written record I can hand to an accountant later without reconstructing anything.

3.2 — Finding 3 gets fixed now, because it is not an accounting question. My own PurchaseConfirmation email says "De volledige factuur vind je in je dashboard onder 'Facturen'" and that section does not exist. That is a broken promise in an email I send to paying customers and it is the one of the three that will actually generate a support message.

Fix it the cheap way: change the email copy to describe what the customer actually has, rather than building a Facturen page. The email already calls itself a bewijs van aankoop, so make the sentence match. Show me the replacement wording before you ship it, and put it in the same PR as the BTW copy change from section 2.

Do not build a Facturen dashboard section. If that ever becomes worth doing, it comes out of 3.1's trigger, not out of this.

═══════════════════════════════
4. AFTER THAT — PHASE 3
═══════════════════════════════

Then the gate, with D2_VERBATIM_CROSSPOST shipping as a block, as you argued. Acceptance test unchanged: the regression suite catches all seven historical defects from the backfilled corpus, each firing a named rule, and I want to see that output.

Credentials are done, so Phase 5 is no longer blocked on me. Both the Buffer and the imgbb key have been rotated and live only in scripts/secrets.local.ps1, which is gitignored. Every older Buffer key has been revoked; one key remains, named ZekerWet Marketing, valid until 8 December 2026. Both were verified working. scripts/post-carousel.py no longer carries either key in source — it reads BUFFER_API_KEY and IMGBB_API_KEY from the environment. Treat these as final and build against them.
```
