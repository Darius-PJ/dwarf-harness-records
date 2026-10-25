# OG-F7: freeze request for F2-07, ticket 07's part of F2

**Prepared:** 2026-10-13, against commit ae1c995 on branch `build/07-f2`, which is `main` at 1b96ee7 plus S2. For C2 and ticket 07. **Answer:** 2026-10-13, "Freeze as presented". [D119](../../../docs/DECISIONS.md#d119-f2-07-scratch-observation-and-merge-back-records-frozen) records the freeze; S2 reached `main` as ae1c995. The rest of this packet stays as sent.

You froze C2's F2 records in parts, each part before the code that writes it (D113). Ticket 07 lets another context of the same agent write to a task through a temporary scratch and merges that work back (D23). It has drafted its records, F2-07, in `contract/ledger` (S2). This packet asks you to freeze them. Your answer is also your sign-off for S2 reaching `main` (D41), with its decision entry and register change; S3, Core's code that writes these records, waits for it.

## What is frozen

Two record types, each at version 1, three additions to frozen types, and their rules, all added to `ledger-format` version 1 (D40, D113). The envelope, F0, F2-05, F2-06 and the format version do not change; `Defined()` then lists thirteen type versions. Core's workspace service writes all of them, from S3 on.

| Record | What it says | When Core writes it |
|---|---|---|
| `workspace.scratch_changed` (new) | Core committed what it observed in a scratch: the previous and new commit and tree, the paths written since then, and all paths changed since the scratch began, never a delta; the raw file manifest is pinned. Its context is the author: a separate `authoring_context_id` was dropped as always equal. | When a writing turn's work is committed |
| `workspace.scratch_merge_back` (new) | A temporary's work merged into its task's scratch: first the plan, `prepared`, before any file is touched; then `write_failed` (left for a retry), `fast_forward` (the task had not moved) or `merged` (merged from the fork point), both listing the task's full changed set; or at once `conflict`, with a pinned report naming the paths. It names both scratches and contexts, the fork, both tips and the paths the temporary wrote; it is never a promotion. | When a temporary's turn ends, in the task's context |
| `scratch_created` + optional `parent_scratch_id` | The scratch is a temporary of that task scratch, forked from the task's latest recorded tip. | At another context's first write to the task |
| `promotion_admitted` + optional `scratch_observation_id` and `merge_back_ids` | Binds an admitted checkpoint to the scratch's latest observation and, in log order, to the merge-backs applied to it since its delta base's admission (since its creation for a root) (the window rule, checked from records alone). | At admission, from C4 on |
| `scratch_closed` reason `temporary_merged_back` | A temporary closed after its work was merged. | At its author's or your closure |

Rules frozen with them, each binding only records with a new key, type or reason:

- **Abandoning a temporary,** for instance after a conflict, is allowed when no prepared merge-back of it is unresolved (Core also checks its files equal its last observed commit). A task scratch cannot close while a temporary of it is open or a merge-back into it is unresolved.
- **`changed_paths` on a merge-back** is present exactly for the two applied outcomes and may be an empty list: the one optional key allowed to be present and empty.
- **Pins:** the latest observation manifest per scratch; a prepared merge-back's manifest and inputs until applied; a conflict report until the task scratch closes. A closure releases the scratch's remaining pins.
- **Path sets** are always full, never truncated or split, bounded only by the 1 MiB record and 16 MiB commit limits; Core refuses an observation that would exceed them (`pathset_cap`).

## What freezing means for you

- These shapes and rules then change only by addition: new optional keys, types or type versions, new closure reasons or merge-back `failure` tokens. The merge-back `outcome` list is closed: a new outcome needs a new type version. A breaking change needs your decision entry (D40).
- S2 reaches `main` with the freeze record, and Core's service (S3) is then built to write these records. Logs written without F2-07 records stay valid.
- Nothing here promotes anything: C2 still admits no request (D52).

## Consequences you may want to change

Yours at this freeze; name any by number:

1. **The names and shapes** above, which the build advisor recommends.
2. **A temporary beside its author's own scratch.** A context may hold its own task's scratch and a temporary on another task at once; F2-05's one-scratch-per-context rule covers dedicated scratches only. Its author may resume an interrupted temporary; resuming writes no record.
3. **Private merge is not representation.** Merged work is still unpromoted in the task scratch, which cannot close over it until ticket 08 accepts it. Only the merged temporary counts as represented, and closes as `temporary_merged_back`.
4. **One Core commit per observation,** even when nothing changed.
5. **Explicit retry; you repair interference.** A merge-back whose write failed stays open until someone retries it; nothing retries on its own, even after a restart. If something else changed the task's branch or files meanwhile, Core stops (`merge_back_interference`), leaves everything as it is, and the repair is yours.
6. **Abandoning keeps the temporary's commits** on its branch, which Core moved with each observation.
7. **Ignored files in the way are refused.** Where an ignored file blocks a path a merge-back would write, Core refuses (`obstructed_path`, naming the path) instead of letting Git overwrite it silently.
8. **The full-pathset bound:** a change set too large for one record is refused, not recorded in part; about 8,000 paths of 60 bytes fit when both lists of an observation hold them all [INFERENCE: arithmetic, not measured].
9. **Two proposed events adopted:** *Scratch changed paths* and *Temporary scratch merged back* (`ROADMAP-CORE.md` C2) become these records; *Scratch base advanced* stays proposed.

Not yours here, as the ruling frames it: the switch of `BeginWrite` to a typed writer, which ticket 07's build entry records as amending B24 items 1 and 5; the edit of `ROADMAP-CORE.md`'s proposal note at the ticket's close; Core's service policies; and no new dependency (D29), no change to D52 (nothing admits, validates or moves `main`) and no design question (D117).

## Evidence

| Item | Result |
|---|---|
| S2 commit | ae1c995, `feat(ledger): draft F2-07 scratch observation and merge-back records for the owner's freeze` |
| Golden `contract/ledger/testdata/f2/07/log/00000000000000000001.jsonl` | twenty-two commits, forty-one records; SHA-256 96de91f92432040683157279432512810c2dd27d36012695be46dd1eccac88c5 |
| Full check (V4) | all nine steps passed |
| Package tests (V2) | 3,278 tests, none failed |
| Fuzzing `FuzzDecodeF2_07`, `FuzzDecodeF2_05`, `FuzzDecodeF2_06`, 120 s each (V3) | three decoders, 2 minutes each, 12.5 million inputs, no failure |
| F0, F2-05 and F2-06 goldens unchanged (V8) | regenerated byte for byte |
| Build advisor's review of S2 | Approved by the build advisor on ae1c995: additions only, every earlier golden byte-identical, each decoder rule tested and broken once, the F2-07 section and its record rules as ruled, nothing under internal/; two wording nits carried to S3. |

## Your choices

- **Freeze as presented** (recommended): freeze F2-07 at ae1c995 with points 1–9 as they stand. Your decision entry and the register change are recorded, S2 reaches `main`, and S3 may start.
- **Freeze with changes:** name them by point number. A follow-up commit on `build/07-f2` makes them, its evidence is collected, and the freeze is recorded at that commit. S2 stays off `main` until then.
- **Not yet:** nothing is frozen. S2 stays off `main` and S3 waits. You may say what is missing.

**The question:** do you freeze F2-07, the two `workspace.*` scratch record types, the three additions to frozen types and their rules, at version 1 by addition to `ledger-format`?

With your answer, one documents commit records it: the decision entry and a cross-reference under D113; the `ledger-format` row and an F2-07 table in `docs/CONTRACTS.md`; the "frozen" wording in `contract/ledger`'s comments; notes in the four scratch rows of Undercurrent §15.1; and this packet's answer line.

## Supporting material

- `contract/ledger/doc.go`, section `# F2-07 record types`: every key, decoder rule and record rule.
- The golden named above, at ae1c995.
- The design brief and the build advisor's ruling, held by the project manager until the ticket closes, when they land as `.scratch/dwarf-harness/c2-evidence/ticket-07-design-brief.md` and `ticket-07-design-ruling.md`.
- The evidence: ``.scratch/dwarf-harness/c2-evidence/f2-07-freeze-evidence.md``.
