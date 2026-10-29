I drafted the publication of tickets 139 and 140 and the dependency audit in `local://t139-t140-publication-edits.md`. All 12 finds are copied from d12f605, but none has been run through your script yet. Before the edits are applied, the owner summary (20 lines) needs his approval, which fills `OWNER-APPROVAL`.

```json
{
  "status": "done",
  "record": "local://t139-t140-publication-edits.md",
  "edits": ["E1", "E2", "E3", "E4", "E5", "E6", "E7", "E8", "E9", "E10", "E11", "E12"],
  "placeholders": ["OWNER-APPROVAL (E1 and E2, the provenance comments; E9, D142's Owner's words): the owner's answer to the owner summary, verbatim with typos kept, filled by the PM after he answers. The quotation marks are already in place."],
  "audit": [
    {"ticket": "12", "disposition": "no change", "reason": "Criteria 29–31 bind review and failure results to F3-11 tasks; they need neither 139 nor 140, and 12 stays first in the owner's order."},
    {"ticket": "13", "disposition": "no change", "reason": "The paid path (lines 35–40) with no general turn loop (line 31). The production callers come with ticket 15 (DECISIONS.md:2663), and 13 consumes no registration."},
    {"ticket": "15", "disposition": "new blocker 140 (Blocked by: 14, 140)", "reason": "Confirmed. Ruling 4 (t11-s4-verdict.md:35) and B32's Limits (DECISIONS.md:2664) put the fix before 15 makes StartTurn, AdmitLocal and BeginLocal production paths. Line 32 makes every admission a production call; that line 36's latency measurement would carry the scans is an inference."},
    {"ticket": "16", "disposition": "cross-link comment (140)", "reason": "Its restart proof and runtime resource profiles (lines 32–33) exercise what 140 bounds, but no criterion needs 140 directly. 140 already reaches it through 15."},
    {"ticket": "59", "disposition": "no change", "reason": "Synthetic replay of frozen families (lines 28–32); no criterion consumes a registration or the service's cost. It now waits for 139 through 61."},
    {"ticket": "61", "disposition": "new blocker 139 (Blocked by: 07, 09, 11, 15, 17, 139)", "reason": "Confirmed. Criteria at lines 29 and 31 need 139's records (B32 item 4, DECISIONS.md:2657; ticket comment at line 93)."},
    {"ticket": "62", "disposition": "cross-link comment (139)", "reason": "Undercurrent §8.2 admits co-access only from use of two registered resources (DESIGN-UNDERCURRENT.md:178,182), so line 28 builds on 139. 139 already reaches it through 61, which matches how 62 lists only 61 although its gate (line 22) names fields from 11 and 15."},
    {"ticket": "73", "disposition": "no change", "reason": "It consumes U3's nodes and links (line 32), not C3's records; 139 reaches it through 62 and 61."},
    {"ticket": "74", "disposition": "no change", "reason": "Its resource-to-consumer topology (lines 28–29) is U3's; 139 reaches it through 73."},
    {"ticket": "83", "disposition": "no change", "reason": "A resource shared between independent Cores is a bilateral federation grant (line 22), not a C3 registration (inference)."},
    {"ticket": "84", "disposition": "no change", "reason": "Its domain strata are preregistered study strata (spec.md:533), not owner work domains."},
    {"ticket": "89", "disposition": "no change", "reason": "Its own line 31 already requires a bounded query that does not rescan history, so it needs nothing from 140 (inference)."},
    {"ticket": "91", "disposition": "no change", "reason": "It consumes failures of the restart integrity check (line 34), which 140's third criterion keeps unchanged."},
    {"ticket": "97, 100", "disposition": "no change", "reason": "'Work or values domain' there is a new leader's alignment domain (spec.md:411), not an owner-registered work domain (inference)."},
    {"ticket": "30", "disposition": "no change", "reason": "Host start opens the service, but no criterion (line 29) bounds its time; 140 reaches it through 16 and 15."},
    {"ticket": "55, 113", "disposition": "no change", "reason": "Their 'resource' views are F3-11 budget-book resources. No C7 or GUI-F ticket shows registered resources or work domains, so the producer-first rule needs no new blocker."}
  ],
  "choices": [
    "P1 Titles: '139: Register shared resources and work domains through Core' and '140: Bound the private-state service's replay and lookup cost' (the service's name from B31, DECISIONS.md:2546). Slugs follow the skill.",
    "P2 Both new tickets are blocked by 11 only. 139 must fit F3-11's grants (t11-close-review-verdict.md:41); 140 changes ticket 11's service (t11-s4-verdict.md:35). No source requires 12 or 13 first.",
    "P3/P4 The proposed blocker changes on 15 and 61 are confirmed, with sources as in the audit.",
    "P5 Tickets 16 and 62 get cross-links rather than blockers: each already waits for the new ticket through its existing blocker, as 62 already does for 11 and 15. 'Registered' in §8.2 could mean any registered node, since §8.3 also registers modules (DESIGN-UNDERCURRENT.md:190); the cross-link fits either reading.",
    "P6 Tickets 59 and 89 are unchanged.",
    "P7 The order 12 then 13 is recorded only in D142: the frontier rule (issue-tracker.md:24) already picks them first. '140 before 15' is carried by 15's Blocked by line.",
    "P8 U3's text drops ticket 11 (resolved; D140) and adds 139, identically in ROADMAPS.md:189 and ROADMAP-UNDERCURRENT.md:309. This follows the close review's fix to 61's comment (DECISIONS.md:2670). The U3 status value and C3's text are unchanged.",
    "P9 CONTRACTS.md changes only in the F3-11 catalogue's 'later F3 families (tickets 12–16)' (CONTRACTS.md:117), the one place the register points to producing tickets; it becomes '(tickets 12–16 and 139)'. C3's row cites B32, not a ticket, so it stays.",
    "P10 B32 gains a one-line See also pointing to D142, in the form of D125's lines (DECISIONS.md:2134-2136).",
    "P11 140's closing bar is my inference: opening the service must grow no faster than the ledger's length, and each operation must stay within a bound the design states. Ruling 4 contrasts the store's linear opening with the superlinear one (ticket-11-evidence.md:241) but sets no number.",
    "P12 I inferred that 139 also produces the scoped declarations that link a registration to a task or context: §8.2's declared relationships (DESIGN-UNDERCURRENT.md:176), 61's line 31 and B32 item 4.",
    "P13 Coverage, with spec.md lines in the report: 139 — user stories 27, 86; implementation 1, 2, 3, 4, 11, 38; testing 1, 2, 4, 17, 20. 140 — user story 26; implementation 1, 2, 4, 10; testing 1, 2, 4, 17, 18, 20.",
    "P14 Gate bullets follow the current rules (D125, D117, D112, D133, D141, D29/D40/D41) and are phrased as requirements, not status statements (D116 item 4).",
    "P15 The cross-links keep the skill's 'Consolidation cross-link:' wording.",
    "P16 OWNER-APPROVAL also appears in both new tickets' provenance comments, because the skill requires each to quote the owner's breakdown approval."
  ],
  "openQuestions": [
    "Should ticket 59 keep waiting for 61's resolution? Its blocker on 61 was for the graph family, which D130 has frozen, and through 61 it now also waits for 139 and 140. D142's Limits records this; I made no change.",
    "Should U1's Status line (ROADMAP-UNDERCURRENT.md:217) be refreshed? It is stale: it lists producer freezes 'tickets 07, 08, 09, 17 and 61', but 07–09 are resolved and 61's family is frozen. It is outside this assignment's U3-only scope, so I left it."
  ]
}
```