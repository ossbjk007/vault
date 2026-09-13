---
type: prompt
date: 2026-09-10
status: actief
tags: [marketing, prompt, kennisbank]
project: ZekerWet
---

Veertiende vervolgprompt voor de projectterminal van [[ZekerWet]]. Volgt op [[marketing-os-avg-correctie-prompt]].

Keurt de deploy goed en maakt van een patroon een staande regel: drie keer op één dag is er iets als gedaan gerapporteerd op basis van bedoeling in plaats van gecontroleerde toestand.

```
Tiers verified against the same text you read, and your documentMap is right the whole way down: privacyverklaring via 13/14 in lid 5, register via 30 in lid 4, verwerkersovereenkomst via 28, DPIA via 35, datalekmelding via 33/34 all in lid 4 because they sit inside "25 tot en met 39", and ongeldige grondslag via 6/7 back in lid 5. "Afhankelijk van welk bedrag hoger is" is also the statute's own construction.

Deploy it.

═══════════════════════════════
1. THE THING YOU FOUND IS BIGGER THAN THE AVG FIX
═══════════════════════════════

Three times in one day you reported something done that was not done:

  · the gate judging a bundle older than the rules it claimed to enforce
  · "split both tiers and said which is which" when only one example was placed
  · the avg-30 note silently skipped by your own dedupe guard, while the run
    still passed because an older entry happened to match the citation

All three are the same shape, and it is the shape this whole project exists to remove: reporting from intent rather than from verified state. The old accountability check did exactly that — it read a plan and called it an outcome.

You caught all three, and the third only because one expected confirmation line was missing from the output. That is thin. It should not depend on you noticing an absent line.

Make it structural rather than a resolution:

1.1 — A skipped write is a loud failure, not a quiet continue. Your dedupe guard skipping an entry and the run still reporting success is the same failure as a monitor that dies silently. If a write does not land, the run says so and exits non-zero.

1.2 — Anything you report as changed gets read back and shown. Not "I updated claims.json" but the resulting entry. You already applied this to pre-flight when you agreed a mechanism only observed passing has not been observed. It is the same rule pointed at your own reports.

Write it next to the rehearsal rule in validate/README.md, in the same voice, so it outlives this conversation the way that one did.

═══════════════════════════════
2. APPLY IT TO THIS DEPLOY
═══════════════════════════════

Deploy, then verify against production rather than against the build log:

  · zekerwet.nl/kennisbank/aanzegbrief-voorbeeld returns 200 and renders the article
  · sitemap.xml carries seven kennisbank URLs, including the new slug
  · the corrected AVG passage is live on avg-compliance-ondernemers
  · the internal links to /documenten/aanzegbrief and /documenten/vso resolve,
    and carry no UTM, per the rule you just wrote

Show me those checks, not the deployment output.

═══════════════════════════════
3. THEN
═══════════════════════════════

Thursday 17 September: hand-draft week 39 in one run, as committed.

After that the rota is yours to run: modelovereenkomst zzp 2026, then vaststellingsovereenkomst bedenktijd, then verbeterplan disfunctioneren voorbeeld. One a week, at the rate you told me was real rather than the one either of us would prefer.
```
