---
type: prompt
date: 2026-09-10
status: actief
tags: [marketing, prompt, architectuur]
project: ZekerWet
---

Achtste vervolgprompt voor de projectterminal van [[ZekerWet]]. Volgt op [[marketing-os-fase5-prompt]].

Geeft groen licht voor fase 4 en voegt drie dingen toe: een hartslagbewaking voor de reconciler die zelf op een laptop draait die aantoonbaar wel eens uit staat, twee notificatietaken die volgens het eigen afdankplan al weg hadden moeten zijn, en de `/ig`-redirect die de biolink permanent oplost.

```
Phase 5 accepted. I verified it in the vault myself rather than taking the summary: logbook generated with the warning header, the item count and a link to the frozen file; four files in Intelligence/archive/; ZekerWet_AvondCheck gone along with the two dead X tasks; ZekerWet_Reconcile registered and due at 12:00.

The status change walking DRAFT → SCHEDULED → SENT_TO_BUFFER → PUBLISHED, reaching the last state only because a live URL came back, is the thing this whole project was for.

═══════════════════════════════
1. A PATTERN I WANT YOU TO ACT ON
═══════════════════════════════

You have now reported four platform limits that were not real:

  · X counts every URL at full length          → it is 23 via t.co
  · metrics before ~10 August are permanently gone → per-post returns everything back to 16 April
  · Buffer's free tier exposes no click metric  → Facebook returns clicks
  · Instagram saves/follows unavailable         → they come back

You caught all four yourself, which is the right outcome. But each one shaped a decision before it was tested. The 31-day wall in particular was used as the argument for urgency in the blueprint and in my own reordering — I made a sequencing call partly on a limit that did not exist. It happened to be the right call for other reasons, which is luck, not method.

So: a platform limit is a claim like any other. It needs a test before it goes in a report, for the same reason a price claim does. Designing around a wall that is not there costs more than discovering it late.

Concretely, before Phase 4: go through the blueprint and the validator README and find every sentence that asserts what a platform cannot do. Test each one against the actual API. Correct what is wrong and mark what you verified. I would rather spend twenty minutes on that now than build another phase on a constraint that dissolves when someone pokes it.

═══════════════════════════════
2. THE RECONCILER HAS NO HEARTBEAT
═══════════════════════════════

This is the gap I want closed before Phase 4, and it is the same failure in new clothes.

The reconciler is now the only thing standing between me and a repeat of ONTBREEKT. It runs hourly as a Windows scheduled task on my laptop. Your own audit recorded that ZekerWet_WeekPlanning missed 6 September because the machine was off. So the single verification layer lives on hardware that demonstrably goes dark, and nothing anywhere reports "the reconciler has not run since Thursday."

A monitor that dies quietly is exactly what accountability-check.ps1 was. It failed by validating a plan; this would fail by validating nothing at all and looking identical from the outside.

2.1 — Build a dead-man's switch. Record last successful run. Something must notice when that timestamp goes stale and tell me. Design where that check lives, because it obviously cannot be the same scheduled task on the same machine.

2.2 — Then answer the harder question honestly. Does the verification layer belong on my laptop at all? vercel.json already declares a cron, so the infrastructure exists — but marketing/ is deliberately excluded from the app build and you argued the deployed application should be byte-identical whether marketing/ exists or not. Those two things are in tension and I would rather you name the tension than quietly pick a side.

Give me the options with their real costs. If the answer is that it stays local and the heartbeat is the mitigation, say that and explain why. I am not asking you to move it — I am asking you to decide it on purpose.

═══════════════════════════════
3. TWO TASKS THAT SHOULD ALREADY BE GONE
═══════════════════════════════

ZekerWet_Ochtend and ZekerWet_WeekPlanning are both still registered and Ready.

Your own "what to abandon" list says to delete the five notification-only scheduled tasks, on the grounds that they are reminders to do work the system now does. Three are gone. These two survive, and they will keep firing toasts telling me to open a terminal and write content that the pipeline is about to produce.

Remove them, or tell me why one of them should be repointed rather than retired. Leave ZekerWet_GeminiModelWatch and ZekerWet_WebhookWatch alone — they have nothing to do with marketing.

═══════════════════════════════
4. THE /ig REDIRECT — DO IT NOW, NOT AT THE TRIGGER
═══════════════════════════════

I set the tagged bio link. It renders as the raw 136-character URL on both desktop and the mobile app, campaign name and all. On a legal-services profile that reads as a tracking experiment rather than a company, which works against the credibility argument the whole strategy rests on.

The fix is cheaper than the landing page you parked behind a traffic trigger. One entry in the redirects block that already carries /prijzen and /documenten/vaststellingsovereenkomst:

  { source: '/ig',
    destination: '/documenten/opdracht?utm_source=instagram&utm_medium=bio&utm_campaign=wetdba-handhaving-2026&utm_content=2026-w38-bio',
    permanent: false }

permanent: false deliberately, so the destination can change later without browsers having cached the old one. Confirm that is the right choice for a link that will be repointed.

This also fixes a design problem in your weekly approval flow. You put "set the bio URL" in the weekly manual block alongside the X copy-paste. But Instagram disables link editing on desktop — the Website field is literally disabled: true in the DOM, and the app says links can only be edited on mobile. So that step can only ever happen on a phone, on a different device from where the rest of the week is approved. That is exactly the kind of step this project keeps proving I will not do.

With /ig the bio link becomes permanent. Repointing a campaign becomes a code change from the laptop inside the weekly run. Update the flow so the manual block prints the bio URL only once — for the switch to zekerwet.nl/ig — and never again after that.

Ship it with the next deploy so it is live before Friday's carousel.

═══════════════════════════════
5. THEN PHASE 4
═══════════════════════════════

Topic bank from the 233-document catalogue, slot emitter, claims library, repurpose fan-out — with fan-out producing genuine per-platform variants. D2 is a hard block, so a lazy fan-out fails loudly instead of shipping twins, which is the point.

Do sections 1 through 4 first and report. Then Phase 4.
```
