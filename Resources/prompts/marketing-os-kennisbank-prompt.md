---
type: prompt
date: 2026-09-10
status: actief
tags: [marketing, prompt, seo, kennisbank]
project: ZekerWet
---

Elfde vervolgprompt voor de projectterminal van [[ZekerWet]]. Volgt op [[marketing-os-publisher-prompt]].

Draait de volgorde nog een keer om: de kennisbank-pipeline plus het eerste artikel gaan vóór de draftmotor. Reden is het patroon dat na tien bouwrondes zichtbaar werd: elke ronde won de infrastructuur en het kanaal dat volgens de audit de grootste hefboom is, staat nog steeds op zes artikelen.

```
Publisher track accepted. The 2x2 covering reconciler-alive against pre-flight-alive is the right way to show a monitoring gap is actually closed rather than merely watched, and the empty-week message is what I asked for, printed where I will see it. Pinning the calendar in schedule.test.ts so dates are asserted rather than assumed is the right generalisation of the platform-limit rule.

I am changing what comes next, and this one is strategic rather than technical.

═══════════════════════════════
1. A PATTERN, AFTER TEN ROUNDS
═══════════════════════════════

The first strategic finding in your own audit was this: building the system is right, but it is not a growth plan. It removes a failure mode and it removes my operating time. It does not create demand.

Since then we have built, in order: containment, a facts layer, a content store, a gate, a reconciler, a heartbeat, a pre-flight, an approval CLI, a scheduler and a publisher. Every one of those was justified, and I approved every one.

In the same period the kennisbank went from five articles to six, and that sixth was a slug you found missing from a sitemap rather than something anyone wrote. The shortlist of four articles you produced on my instruction has not been touched.

I decided on day one that search intent is the highest-leverage channel I have, because it needs no audience and it compounds. Ten rounds later it is the only thing that has not moved. Every round the infrastructure won, and every round the reason was good.

So the drafting engine waits. It makes producing social content cheaper, and social content reaches thirty-six people. That is optimising the wrong end.

═══════════════════════════════
2. THIS ROUND: THE KENNISBANK PIPELINE AND THE FIRST ARTICLE
═══════════════════════════════

2.1 — Build the pipeline you designed. Articles out of the 612-line inline JSX file and into MDX, slugs derived from the directory rather than hand-maintained in sitemap.ts, both consumers importing one source. The drift guard you already wrote stays and should now be enforcing something structural rather than watching two hand-kept lists agree.

2.2 — Then write the first article, and actually write it. Not a scaffold, not an outline with headings and a note saying the body follows. A finished article I could publish today.

Take the first one from your own shortlist: target query "aanzegbrief voorbeeld", linking to /documenten/aanzegbrief. You argued it converts because nobody searches that phrase out of curiosity — they have a contract ending inside thirty days and a statutory deadline. That reasoning still holds.

2.3 — It goes through the same gate as everything else. Same content object, same claims allowlist, same UTM rules, same risk tiering. An article reasoning from BW 7:668 is legal tier, which means it reaches me. If the gate has rules that only make sense for a social post and get in the way of long-form, tell me which and propose the fix rather than working around them.

2.4 — Show me the article in full before it goes anywhere near production, the same way you showed me week 38. I am approving copy, so I need to read copy.

═══════════════════════════════
3. WHAT THIS DOES TO THE CALENDAR
═══════════════════════════════

Thursday 17 September stops being a decision and becomes a plan: hand-draft week 39 that day, the way week 38 was drafted, in one run. The drafting engine is not going to be ready and I would rather commit to that now than spend Thursday finding out.

That removes the uncertainty from the deadline instead of managing it, and it costs one drafting run of work that is already proven.

The drafting engine comes after the kennisbank work. It is a real improvement and I still want it — it is just not what is standing between ZekerWet and its next customer.

═══════════════════════════════
4. ONE THING TO BE HONEST WITH ME ABOUT
═══════════════════════════════

Writing four good kennisbank articles is a different kind of work from building a validator, and it is the kind where "done" is a judgement rather than a passing test.

So tell me plainly, before you start: what does a finished article look like to you, roughly how long, and what in it is going to need my legal eye rather than your gate. If the honest answer is that every article needs me to read it carefully before it ships, say so now, because that changes what a realistic publishing rate looks like and I would rather plan against the true number than the hoped-for one.

Then write the first one.
```
