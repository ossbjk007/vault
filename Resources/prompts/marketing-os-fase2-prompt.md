---
type: prompt
date: 2026-09-09
status: actief
tags: [marketing, prompt, architectuur]
project: ZekerWet
---

Derde vervolgprompt voor de projectterminal van [[ZekerWet]], na fase 1. Volgt op [[marketing-os-fase1-prompt]].

Beslissingen die hierin verwerkt zijn: de post van 28 mei blijft staan als vastgelegde uitzondering, de twee statistieken worden herschreven naar wat de wet wel zegt, en de factuurbevindingen worden een apart spoor tussen fase 2 en fase 3.

```
Phase 1 accepted. 22 of 51 would have been blocked settles the argument about whether the gate is worth building — that is 43% of everything ever published. Decisions below, then go for Phase 2.

═══════════════════════════════
1. THE TWO STATISTICS — REWRITE BOTH
═══════════════════════════════

No source hunt. Rewrite both into claims that follow from statute, for the reason you identified yourself: attributing an empirical claim to a law that does not make it is the error class, and a sourced statistic would still be weaker than a legal fact I can point at.

1.1 — "9 van de 10 concurrentiebedingen zijn nietig." Rebuild it from BW 7:653: the written-agreement requirement, the majority-age requirement, and the duty to state a zwaarwegend bedrijfsbelang in writing for a fixed-term contract. That is checkable, it is stronger, and it survives the validator. Draft the replacement and show it to me before it goes anywhere.

1.2 — The worked example in brand-voice.md. Replace it with a claim built the same way. This one matters more than the post: it is the model every other post imitates, so an unsourced figure sitting there propagates. Whatever you put in its place has to pass the gate itself.

1.3 — Make it a standing rule in claims.json: an empirical statistic needs a named, linkable source, and a statute-derived formulation is always preferred over a number. Register the rule, not just the two fixes.

1.4 — The 24 August post stays live. See section 2 for how to record it.

═══════════════════════════════
2. THE 28 MAY POST — STAYS LIVE
═══════════════════════════════

I am leaving it up. Two reactions in three and a half months means there is nothing to protect and nothing to gain by pulling it, and I would rather spend the attention forward.

But it must not sit in the system looking like something you missed. Record both the 28 May post and the 24 August one as an explicit accepted exception on the content object: the rules that fired, the date I decided, and the reason. The weekly report should be able to show me "known-bad, live, accepted" as a distinct category from "clean" and from "blocked". If I ever change my mind the record is already there.

The rules stay hard for anything new. An accepted exception is a decision about a published artefact, never a validator bypass.

2.1 — Fix the dead link at the source instead of the post.

/prijzen has never existed; the route is /pricing. next.config already has a redirects() block at line 39, so one entry there repairs that CTA in every historical post at once, including the ones I cannot edit and the ones already sitting in someone's feed. It also stops the 404 costing me anything in search.

Add it to the same PR as the BTW copy change in section 3. Check whether any other historical CTA points at a route that does not exist and fold those redirects in too — you have the corpus, so answer it from data rather than guessing.

═══════════════════════════════
3. THE BTW COPY CHANGE — APPROVED AS LISTED
═══════════════════════════════

All nine lines as you specified them, plus the redirect from 2.1. One PR, separate from marketing, nothing else in it.

Good catch that PurchaseConfirmation.tsx was already correct. That is worth stating plainly in the PR description: the receipt has been right the whole time and the site has been disagreeing with it, which is the direction that makes this a copy fix rather than a pricing fix.

═══════════════════════════════
4. THE INVOICE FINDINGS — SEPARATE TRACK, AFTER PHASE 2
═══════════════════════════════

You are right that this is worse than the pricing page. A paying customer who cannot obtain a compliant invoice by any route is a real problem, and it is a bad one to have on a product that sells compliance.

Sequencing: finish Phase 2 first, since it is small and self-contained. Then stop and give me a scoped proposal for the invoice work before Phase 3. Proposal only at that point, no code — I want to see the shape before you build it, same as with the architecture.

When you write that proposal, cover all three findings together: the missing BTW line on subscription invoices, the absent invoice on document purchases, and the email that points at a Facturen section the dashboard does not have. And be explicit about which parts are a legal question I should take to an accountant rather than a technical question you can settle.

Do not start any of this now.

═══════════════════════════════
5. PHASE 1 ITEMS CONFIRMED
═══════════════════════════════

5.1 — The lnkd.in finding is the most architecturally useful thing in your report. Link rules run before sending; the reconciler never re-validates sent LinkedIn text against URL rules. Make that a named test fixture rather than a comment, so nobody reintroduces it later by tightening the reconciler.

5.2 — Verbatim cross-posting as a flag: accepted, no exemption. But 18 of 51 means this was the practice, not a slip, and a flag nobody acts on is decoration. Tell me at which point it becomes a hard block for new content. My instinct is that it should be hard from the first gated week, since fan-out in Phase 4 is supposed to produce variants anyway. Argue it if you disagree.

5.3 — The sixth kennisbank article and the sitemap fix: approved, including the production change. That is exactly the kind of thing I want flagged rather than slipped in, and the six drift-guard tests are the right response.

5.4 — Vault dispositions and the boundary work: accepted as shipped.

═══════════════════════════════
6. GO FOR PHASE 2
═══════════════════════════════

Zod schema, the transition function with the legal-transition table, the file store, the index builder, the lockfile. Backfill all 51 posts as content objects.

Two things I want to see rather than be told about:

- The lockfile and the conflict-file scan refusing to run against a simulated OneDrive conflict file. You promised demonstrated, not described.
- The property test proving every illegal transition throws.

Then stop. Do not start Phase 3. Next thing after Phase 2 is the invoice proposal from section 4.

The Buffer key is not rotated yet. Reads during the backfill are fine with the current one, but nothing may hardcode it, and no part of Phase 5 gets built against it. I will tell you when the new key is in secrets.local.ps1.
```
