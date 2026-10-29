# Review request: tickets 139 and 140, and the dependency audit

You are the build advisor (Fable), fresh for this review. The repository is read-only: `C:\Users\darius.jones\Documents\PROJECTS\dwarf-harness`, at `main` d12f605. You have no write tool, so answer in your yield.

## The state
- **The owner's words** (chat, 2026-10-24 11:35), answering the overnight log's questions 5 and 6, in which the PM recommended both tickets (`C:\Users\darius.jones\Documents\PROJECTS\DwarfHarness\Overnight-log-2026-10-23.md:28-37`): "5. The family ticket should be its own ticket: 139, 6. Publish this as ticket 140, then audit and update ticket dependancies and order". Also: "3. The next ticket shall be Ticket 12 then 13".
- **The owner has not seen the summary yet.** The PM asks him after your review, so `«OWNER-APPROVAL»` stays unfilled. If you approve, the summary goes to him as reviewed. If he changes anything, it comes back to you for a short re-check.
- **The edits:** `local://t139-t140-publication-edits.md`, E1–E15, by DrafterT139T140 under `local://t139-t140-publication-assignment.md`.
  - The owner summary and the audit table are at its top.
  - The drafter's choices are P1–P17 in its report. The yield of draft 1 is in `local://t139-t140-drafter-yield-1.md`.
  - The PM's revision asks, which added E13–E15, are in `local://t139-t140-docs-notes.md` (12:37 entry).
- **The expected result:** `local://t139-t140-review-diff.md` shows the new files whole and the changed files as unified diffs.
- **The PM's dry run on d12f605:**
  - every find matches once and the output is LF only;
  - every link and anchor resolves;
  - ticket numbers run from 1 to 140 without a gap, each title matches its file and slug, and Status and Type values are valid;
  - blockers are ascending and zero-padded, `## Comments` is last, and the blocker graph is acyclic by closure;
  - afterwards the frontier is 12, 13, 139 and 140, plus the deferred 47 and 49.
- **The commit is Markdown-only,** so D128's document check applies.
- **A procedure change, the PM's under D121:** the `dwarfharness-ticket-publication` skill no longer requires a blocker to be numbered lower than its ticket; the graph must stay acyclic instead. That rule lived only in the skill, and `docs/agents/issue-tracker.md:23-24` requires only that listed tickets be resolved. The PM named the change to the owner.

## Inputs
- The seed, with facts and sources: `C:\Users\darius.jones\.omp\agent\sessions\-Documents-PROJECTS-dwarf-harness\2026-10-08T23-08-56-101Z_01a11dc6-e3a5-73a6-be48-e2faffbaa318\local\t139-t140-seed.md`. That same `local\` folder holds:
  - `t11-close-review-verdict.md`: rulings at lines 41 and 45;
  - `t11-s4-verdict.md`: ruling 4 at line 35;
  - `t59-docs-notes.md`: ticket 59's gate ruling, summarized at line 22.
- The procedure: `skill://dwarfharness-ticket-publication`, for the ticket format, the decomposition rules and touching existing tickets.
- `docs/DECISIONS.md`: B3 (669–676), D125 (by heading), D130 (2275), D140 (2608) and B32 (2637–2685).
- `docs/DESIGN-UNDERCURRENT.md:174-192` (§§8.2–8.3); `docs/ROADMAP-UNDERCURRENT.md`, U1's Status (217) and U3 (262–309); `contract/ledger/doc.go:1337-1362` (F-U3-61).

## Please check
1. **Tickets 139 and 140:** the skill's format, and criteria that are true to the sources without settling what a design should choose. Above all:
   - 139's first criterion: the owner registers, and an agent cannot. Weigh it against the close ruling's "resources are what F3-11 grants name and work domains are owner-registered … names Core as the registrar" and the roadmap's "external resources require host registration".
   - 139's third criterion and P12: that 139 also produces the scoped declarations linking a registration to a task or context [INFERENCE].
   - 140's first criterion, which fixes the order of the fixes from ruling 4.
   - 140's fourth criterion and P11: opening the service growing "no faster than the ledger's length" as the closing bar [INFERENCE].
   - The coverage numbers (P13).
2. **The audit:**
   - each disposition, above all 15 (+140), 61 (+139) and 59 (−61, the PM's call);
   - the cross-links on 16 and 62;
   - any open ticket the search missed.
3. **D142:** the originator `adopted`, the owner's words verbatim, the three blocker changes, item 4's sentence on higher-numbered blockers, and the Limits.
4. **The status texts:**
   - U3's Status line and board row, changed together;
   - U1's Status line alone, with its board row a bare "In progress";
   - `CONTRACTS.md`'s F3-11 pointer.

   No status value changes.
5. **The acyclicity claim,** by your own closure over the changed `Blocked by` lines.
6. **Your verdict:** approve applying the edits once the owner approves the summary, or list what must change.

For commands or broad searches, return `needs-evidence` with numbered requests; a reader and runners are standing by.

## Yield
`{ "verdict", "findings": [{"severity", "location", "problem", "change"}], "rulings": [{"item", "ruling"}], "summaryForOwner": "<any correction to the owner summary, or 'as drafted'>", "requests": [] }`
