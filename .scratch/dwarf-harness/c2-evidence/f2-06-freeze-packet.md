# OG-F6: freeze request for F2-06, ticket 06's part of F2

**Prepared:** 2026-10-12, against commit 188f5c5 on branch `build/06-f2`, which is `main` at 408944d plus S2. For C2 and ticket 06. **Answer:** 2026-10-12, "Freeze as presented". [D118](../../../docs/DECISIONS.md#d118-f2-06-promotion-admission-generation-and-failure-records-frozen) records the freeze; S2 reached `main` as bde7c68. The rest of this packet stays as sent.

You froze C2's F2 records in parts, each part before the code that writes it (D113). Ticket 06 has drafted its part, F2-06, in `contract/ledger` (S2). This packet asks you to freeze it. S2 reaches `main` only with your answer (D41), and S3, Core's code that writes these records, waits for it.

## What is frozen

Three record types, each at version 1, added to `ledger-format` version 1 (D40, D111, D113). The record envelope, F0, F2-05 and the format version do not change. `Defined()` then lists eleven type versions.

| Record | What it says | Who writes it |
|---|---|---|
| `workspace.promotion_admitted` | A checkpoint was admitted for promotion: its request ID, scratch, context, lineage and checkpoint number; its local parent, or the failed head it restarts from; the trees it is judged against; and its sealed tree with the file manifest, which stays pinned while the request is unfinished. | Core's workspace service, in the name of the agent or owner who asked |
| `workspace.generation_derived` | Core merged an admitted request over the request ahead of it in the workspace's queue, or over `main`. The result is a merged commit and tree (`clean`) or a conflict report naming the conflicting paths (`conflict`). When the request ahead changes, a newer generation supersedes this one. | Core's workspace service, as Core |
| `workspace.promotion_failed` | A request ended without promotion: `conflict` (its merge conflicts and nothing unfinished is ahead of it) or `dependency_failed` (an earlier checkpoint of its lineage failed). The lineage's later checkpoints end in the same commit. | Core's workspace service, as Core |

And one rule: a scratch cannot be closed while it has an unfinished request, one admitted and not yet ended.

The full rules, key by key, are in the `# F2-06 record types` section of `contract/ledger/doc.go`.

## What freezing means for you

- These shapes and rules then change only by addition: new optional keys, a new type or type version, or a later F2 part. A new `promotion_failed` outcome needs no new version. A breaking change needs your decision entry (D40).
- S2 reaches `main` with the freeze record, and Core's service (S3) is then built to write these records.
- Logs written under F2-05 alone stay valid: the closure rule binds only scratches that have F2-06 records.
- Nothing writes these records in use yet: C2's product admits no request, and `RequestPromotion` admits checkpoints only from C4 on.
- Not frozen, because they are Core policy: the provisional limits of four unfinished checkpoints per context and workspace and a window of four generations, and the merge rules that the value `integration-rules/1` names (changing them means a new value, not a new type version).

## Points you may want to change

1. **The three names.** The build advisor recommends them (ruling, P14). Successful endings get their own types in ticket 08; D35's example name `workspace.promotion_accepted` fits this family.
2. **Conflict reports kept pinned** (ruling, finding 1). A conflict report is pinned in its generation's commit and released when a newer generation supersedes it or when the scratch is closed, never when the request ends. A terminal conflict's report therefore survives your explicit collection until the agent's scratch is closed: the report is the failure the agent must see (D63). The cost is disk space until closure.
3. **The closure rule, stated as an F2-06 rule** (ruling, P17). "While a request is live, its scratch has no `workspace.scratch_closed`", and the closure's commit releases the scratch's remaining report pins. It is written in F2-06, with one pointer sentence under F2-05, so F2-05's frozen text does not change and every log without F2-06 records stays valid. A scratch's requests must end before it closes; cancelling one is ticket 08's (D57).
4. **`promotion_failed`'s open outcome.** As with F2-05's `reason`, `outcome` is an open token: version 1 defines `conflict` and `dependency_failed`, and later parts add outcomes without a new version. A reader treats an outcome it does not know as a failure it does not know, never as invalid, and Core writes only outcomes its own version defines. `generation_derived`'s outcome is closed: `clean` or `conflict`.

Also fixed by the freeze, with no change expected: manifests pinned while their request is unfinished, and commits that fix no position for a record, so C3 can put its command record first.

## Evidence

| Item | Result |
|---|---|
| S2 commit | 188f5c5, `feat(ledger): draft F2-06 promotion records for the owner's freeze` |
| Golden `contract/ledger/testdata/f2/06/log/00000000000000000001.jsonl` | twelve commits, twenty-five records; SHA-256 014cc612076390934fa8a668117c353c5cca2630a3b3fd90364a29542b96f40d |
| Full check (V4) | all nine steps passed at 188f5c5, including race and cross builds |
| Package tests (V2) | 1,351 tests and subtests run, 1,347 passed, 4 skipped (helper processes and an opt-in workload), none failed |
| Fuzzing `FuzzDecodeF2_06`, 120 s (V3) | 1,882,465 executions in 120 s, no failure (at 0fa0f43; 188f5c5 differs only in one error message) |
| F0 and F2-05 goldens unchanged (V8) | unchanged; their SHA-256 digests equal D111's and D115's |
| Build advisor's review of S2 | Approved (188f5c5, 2026-10-12): the build advisor reviewed the code, its evidence and this packet with the freeze record together; no finding on the code or the golden; one minor addition to the decision record (a cross-reference line under D113). The review's text lands with the ticket's documents at its close. |
| Record cost (D78), a calculation | about five records per checkpoint, plus a pin and a release per conflict report (design brief §2.17) |

## Your choices

- **Freeze as presented** (recommended): freeze F2-06 at 188f5c5, with the four points as they stand. Your decision entry and the register change are recorded, S2 reaches `main`, and S3 may start.
- **Freeze with changes:** name them, by point number. A follow-up commit on `build/06-f2` makes them, its evidence is collected, and the freeze is recorded at that commit. S2 stays off `main` until then.
- **Not yet:** nothing is frozen. S2 stays off `main` and S3 waits. You may say what is missing.

**The question:** do you freeze F2-06, the three `workspace.*` promotion record types and the closure rule, at version 1 by addition to `ledger-format`?

With your answer, one documents commit records it: the decision entry; the `ledger-format` row and an F2-06 table in `docs/CONTRACTS.md`; the "frozen" wording in `contract/ledger`'s comments; notes naming these types in the "Promotion attempted" and "Promotion refused" rows of Undercurrent §15.1; and this packet's answer line.

## Supporting material

- `contract/ledger/doc.go`, section `# F2-06 record types`: every key, decoder rule and record rule.
- The golden named above, at 188f5c5.
- The design brief and the build advisor's ruling, held by the project manager until the ticket closes, when they land as `.scratch/dwarf-harness/c2-evidence/ticket-06-design-brief.md` and `ticket-06-design-ruling.md`.
- The evidence: `.scratch/dwarf-harness/c2-evidence/f2-06-freeze-evidence.md`.
