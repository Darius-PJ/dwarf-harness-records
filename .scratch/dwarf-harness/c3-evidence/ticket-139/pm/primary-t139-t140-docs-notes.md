# Tickets 139 and 140 notes: publication and the dependency audit (C3)

- 2026-10-24 12:20 — **Owner's words** (chat, 11:35, answering the overnight log's questions 5 and 6): "5. The family ticket should be its own ticket: 139, 6. Publish this as ticket 140, then audit and update ticket dependancies and order". At about 12:12, to PM-Beta's footing report, which said the PM would show him both tickets and every blocker change before writing them: "PM-Alpha is closed you are approved to proceed".
  - **Procedure change (D121, PM-Beta):** `dwarfharness-ticket-publication` no longer requires every blocker to be lower-numbered than its ticket. The graph must stay acyclic, checked by ancestor closure. The old rule lived only in that skill, and no repository rule or tool enforces blocker order. It is named in the footing report.
  - **Drafter assignment:** `local://t139-t140-publication-assignment.md` → `local://t139-t140-publication-edits.md`, finds from `main` d12f605.
  - **Next:** the PM checks the draft and shows the owner its summary (question tool). A fresh Fable advisor then reviews the edit file with his answer. The PM applies it by script, runs the document check (D128), commits, and fast-forwards `main`. The push rides with ticket 12's (D141).
- 2026-10-24 12:37 — **Draft 1** (DrafterT139T140, 16m31s): `local://t139-t140-publication-edits.md`, E1–E12, with the yield saved as `local://t139-t140-drafter-yield-1.md`.
  - **The PM's dry run on d12f605:** every find matches once, the output is LF only, and every link and anchor resolves (`mirror_check`).
  - **Findings:** 139 and 140 are each blocked by 11; 15 gains 140 and 61 gains 139, both confirmed; 16 and 62 get cross-links; U3's text drops 11 and adds 139; `CONTRACTS.md`'s F3-11 pointer gains 139.
  - **Revision asked:**
    1. Ticket 59 drops 61, on the drafter's open question. Its 2026-10-13 comment lists 61 only for the graph-delta family, frozen as F-U3-61 by D130. Its gate ruling (`ALPHA\local\t59-docs-notes.md:22`) names five freezes, with 17 the longest pole. Keeping 61 would make 59 wait for 61's remaining criteria and for 139.
    2. U1's Status line is refreshed: U1.E is blocked only on 17's freeze, since D119, D123, D124 and D130 have landed. The board row is a bare "In progress", as ff113dc set it.
    3. Ticket 140's gate bullet is corrected under D125 and B3.
    4. D142 says that two blockers are now higher-numbered and that the graph stays acyclic.
    5. D142's heading is retitled to fit.
  - The title keeps "private-state service": tickets 10 and 11's Answers and B31 use it, although `CONTRACTS.md` says "agent service".
- 2026-10-24 12:43 — **Draft 2** (DrafterT139T140, revived): E1–E15. E13 and E14 drop ticket 61 from ticket 59's blockers and add its rework comment; E15 is U1's Status line. Ticket 140's gate bullet is corrected, D142 has item 5 and the higher-numbered-blocker sentence, and its heading is "D142. Tickets 139 and 140 published, with three blocker changes". The yield is in `local://t139-t140-drafter-yield-2.json`.
  - **The PM's checks on the expected tree (d12f605 plus E1–E15):**
    - every find matches once, the output is LF only, and every link and anchor resolves;
    - tickets 1–140 are contiguous; titles, numbers and slugs match; Status and Type values are valid; blockers are ascending and zero-padded; `## Comments` is last; the graph is acyclic by closure;
    - the frontier is 12, 13, 139 and 140, plus the deferred 47 and 49;
    - 59's ancestors include 140 (through 17) but neither 61 nor 139.
  - **Review:** AdvisorT139T140 (fresh Fable) on `local://t139-t140-review-request.md`, with the expected changes in `local://t139-t140-review-diff.md`. The owner's question follows the verdict.
- 2026-10-24 12:57 — **Review:** AdvisorT139T140 (fresh Fable, 11m45s, $6.67) approved, with five minor findings and two nits. The verdict is in `local://t139-t140-review-verdict.md`.
  - **The PM applied them in the edit file,** keeping draft 2 as `local://t139-t140-publication-edits-draft2.md`:
    - the summary's 139 bullet now says that only the owner registers and that the ticket records declarations;
    - D142 item 1 names the scoped declarations;
    - ticket 140's first criterion lists the S4 review's candidates without ranking them, and its body adds B31's earlier scans;
    - E12 is dropped: both `CONTRACTS.md` pointers stay, the review's second option, because they are freeze-time scope sentences;
    - the summary's 140 bullet no longer presumes the fix;
    - E16 adds a cross-link on ticket 11.
- 2026-10-24 13:30 — **Owner (question tool), on the summary:** "Approve and publish". This is the breakdown approval the publication skill requires and fills «OWNER-APPROVAL».
- 2026-10-24 13:31 — **Landed:**
  - E1–E11 and E13–E16 were applied in the worktree `docs-139-140` and committed as ce07208, `docs(tracker): publish tickets 139 and 140 and audit their dependencies (D142)`: 11 Markdown files, +149/−6.
  - The document check on the real tree (D128) passed: every link and anchor resolves, and the files are LF only.
  - `main` was fast-forwarded d12f605 → ce07208. The worktree and the branch `docs/139-140-publish` were removed, along with the merged branches `build/11-s4` and `docs/11-close`.
  - Not pushed: the commit rides with ticket 12's push (D141).
