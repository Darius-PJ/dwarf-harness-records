# OG-F8: freeze request for F2-08, ticket 08's part of F2

**Prepared:** 2026-10-13, against commit c44484d on branch `build/08-f2`, which was `main` at b03de1d plus S2; on 2026-10-15 S2 was rebased onto `main` db85ebb as c9bb2c2, with `contract/ledger` unchanged. For C2 and ticket 08. **Answer:** 2026-10-15, "Freeze as presented". [D123](../../../docs/DECISIONS.md#d123-f2-08-finalization-acceptance-and-no-change-records-frozen) records the freeze; S2's `contract/ledger` reached `main` unchanged in bf8b198. The rest of this packet stays as sent.

You froze C2's F2 records in parts, each part before the code that writes it (D113). Ticket 08 finishes a promotion: Core moves `main` to an admitted request's clean (conflict-free) integration result, or ends the request without moving it. It has drafted its records, F2-08, in `contract/ledger` (S2). This packet asks you to freeze them. Your answer is also your sign-off for S2 reaching `main` (D41), with its decision entry and register change; S3, Core's code that writes these records, waits for it.

## What is frozen

The build advisor's proposal, as ruled: "Freeze F2-08 by addition to ledger-format v1: three v1 types, the optional predecessor_witness_seq on four records, and the outcomes cancelled and interrupted; asked after S2 is built, evidenced and reviewed, before S3 writes a record; the answer is D41's sign-off for S2, whose decision entry and CONTRACTS register change land with it."

The envelope, F0, F2-05, F2-06, F2-07 and the format version do not change; `Defined()` then lists sixteen type versions. Core's workspace service writes all of these records, from ticket 08's S3 on.

| Record | What it says | When Core writes it |
|---|---|---|
| `workspace.finalization_intended` (new) | Core is about to move `main`: the request, its clean generation, `main` as it stands (commit and tree), the commit and tree `main` will become, and the rules Core follows, `finalization-rules/1`. | Before its one guarded update of `main` |
| `workspace.promotion_accepted` (new) | The update is durable. It repeats the intent's request, generation, old and new commit and tree, and lists every path that changed, never file content. It becomes the workspace's *witness*: the accepted `main` the next promotion starts from. | After the update is made durable and `main` re-read, or when a restart finds `main` at the intended commit |
| `workspace.promotion_no_change` (new) | The request's result has the same file tree as `main`: nothing to move, so the request ends successfully with no intent and no update. | When the leading request's tree equals `main`'s |
| optional `predecessor_witness_seq`, on the three new records and `workspace.generation_derived` | Names the workspace's latest acceptance, whose commit and tree the record starts from. | Present exactly once the workspace has an acceptance; on a generation, only when it is built over `main` |
| `promotion_failed` outcome `cancelled` | You, or the agent in the request's own context, withdrew the request before its intent. | On cancellation |
| `promotion_failed` outcome `interrupted` | Core ended the request: its update was refused with `main` unmoved, or a restart found it unfinished. | At that refusal, or in the restart's bookkeeping phase |

Like every `promotion_failed`, both new outcomes fail the request's later checkpoints in its line (`dependency_failed`). The rules frozen with them bind only records with a new type, key or outcome, so every log without F2-08 records stays valid. Among them: one unresolved intent per workspace, resolved by exactly one acceptance or one `interrupted` ending; and a scratch's *represented tree*, the tree of its latest request accepted or found unchanged, else its starting tree, from which a new line of requests in that scratch starts.

## What freezing means for you

- These shapes and rules then change only by addition: new optional keys, types or type versions, and new `promotion_failed` outcomes. A breaking change needs your decision entry (D40).
- S2 reaches `main` with the freeze record, and Core's service (S3) is then built to write these records. Logs written without F2-08 records stay valid.
- Nothing here promotes anything: C2 still admits no request, and the product answers `no_validator` (D52).

## Consequences you may want to change

Yours at this freeze; name any by number:

1. **The three names** above, which the build advisor recommends, with success recorded as its own types rather than as a `promotion_failed` outcome, because every `promotion_failed` outcome fails the line.
2. **What the intent binds:** request, generation, old and new commit and tree, and `finalization-rules/1` only. Validation evidence and the policy, check, environment and law revisions join later by addition, when F4, ticket 09 and U1.L freeze them; nothing holds a place for them now.
3. **The witness.** The first acceptance takes `main` as Core observed it. After that, if `main` is moved outside the harness, that workspace's promotions stop, rather than restarting from the new `main`, until a later part defines how to reanchor.
4. **Restart.** A restart with unfinished requests ends them all `interrupted`, after the host's bookkeeping phase; agents resubmit with new IDs. An unfinished intent is settled by what `main` shows: `interrupted` at the old commit, accepted at the intended one, blocked otherwise.
5. **Cancellation after the intent is too late.**
6. **Changed paths on the acceptance only,** full, never truncated: a change set whose acceptance would exceed the size limits (1 MiB per record, 16 MiB per commit) is refused before the intent.
7. **`finalization-rules/1`:** finalization needs Git's `files` ref backend, and after each update flushes the repository's object and ref directories to disk, at a cost ticket 08 measures on this machine. These rules are Core policy named in the record, so they can later change through a new value.
8. **Accepted work still closes as `abandoned`.** The scratch is represented by its accepted work, but a `promoted` closure reason is a later part's.
9. **The golden** named below, which pins an example of each new record, key and outcome.

Not yours here, as the ruling frames it: no new dependency (D29); no change to D52, since nothing admits, validates or moves `main` through the product; no change to the full check (D42); no design question (D117); and ticket 08's build entry at its close, which records a Git durability fact and amends B25.

## Evidence

| Item | Result |
|---|---|
| S2 commit | c44484d, `feat(ledger): draft F2-08 finalization, acceptance and no-change records for the owner's freeze` |
| Golden `contract/ledger/testdata/f2/08/log/00000000000000000001.jsonl` | twenty-two commits, thirty-nine records; SHA-256 985e073a342d9f991fdd2afd407dc495c3542020c98e35d3079018e29db14b8c |
| Package tests (V2) | PASS: `contract/ledger` in 22.8 s and `internal/core/ledgerstore` in 252.8 s; every seed corpus passed |
| Fuzzing `FuzzDecodeF2_08` and `FuzzDecodeF2_06`, 120 s each (V3) | PASS: 3,576,403 and 3,836,058 executions; no new corpus file |
| F0, F2-05, F2-06 and F2-07 goldens unchanged (V8) | PASS: each regenerates byte for byte, matching the digests of D111, D115, D118 and D119 |
| Full check (V4) | PASS: all nine steps in 993 s on c44484d; it runs again on the record commit |
| Build advisor's review of S2 | Approved by the build advisor on c44484d, whose contract/ledger is unchanged by the rebase onto main db85ebb: additions only, every earlier golden byte-identical, each decoder rule tested and broken once, the F2-08 section and its record rules as ruled, nothing under internal/; two register wording fixes carried to the freeze record. |

## Your choices

- **Freeze as presented** (recommended): freeze F2-08 at c44484d with points 1–9 as they stand. Your decision entry and the register change are recorded, S2 reaches `main`, and S3 may start.
- **Freeze with changes:** name them by point number. A follow-up commit on `build/08-f2` makes them, its evidence is collected, and the freeze is recorded at that commit. S2 stays off `main` until then.
- **Not yet:** nothing is frozen. S2 stays off `main` and S3 waits. You may say what is missing.

**The question:** do you freeze F2-08, the three `workspace.*` finalization record types, the optional witness key on four records, the outcomes `cancelled` and `interrupted`, and their rules, at version 1 by addition to `ledger-format`?

With your answer, one documents commit records it: the decision entry and a cross-reference under D113; the `ledger-format` row and an F2-08 table in `docs/CONTRACTS.md`; the "frozen" wording in `contract/ledger`'s comments; notes in the three promotion rows of Undercurrent §15.1; and this packet's answer line.

## Supporting material

- `contract/ledger/doc.go`, section `# F2-08 record types`: every key, decoder rule and record rule.
- The golden named above, at c44484d.
- The design brief and the build advisor's ruling, held by the project manager until the ticket closes, when they land as `.scratch/dwarf-harness/c2-evidence/ticket-08-design-brief.md` and `ticket-08-design-ruling.md`.
- The evidence: `.scratch/dwarf-harness/c2-evidence/f2-08-freeze-evidence.md`.
