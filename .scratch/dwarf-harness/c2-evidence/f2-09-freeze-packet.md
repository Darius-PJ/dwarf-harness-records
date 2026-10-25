# OG-F9: freeze request for F2-09, ticket 09's part of F2

**Prepared:** 2026-10-16, against commit 93b76a4 on branch `build/09-f2`, which is `main` at d4453c0 plus S2. For C2 and ticket 09. **Answer:** 2026-10-16, "Freeze as presented". [D124](../../../docs/DECISIONS.md#d124-f2-09-policy-activation-records-frozen) records the freeze; S2's `contract/ledger` reached `main` unchanged in 336ff23. The rest of this packet stays as sent.

You froze C2's F2 records in parts, each part before the code that writes it (D113). Ticket 09 lets you activate a new field law, validation policy and per-workspace check and environment policies, immediately or not before a time you choose; Core then switches the whole colony once, after promotions it has already begun to finalize are settled. It has drafted its records, F2-09, in `contract/ledger` (S2). This packet asks you to freeze them. Your answer is also your sign-off for S2 reaching `main` (D41), with its decision entry and register change; S3a, Core's code that writes these records, waits for it.

## What is frozen

The build advisor's proposal, as ruled: "Freeze F2-09 (four types, the optional activation_record_hash on finalization_intended, open outcome token, conditional observed_utc_ns, signed UTC ns, owner_approval_id, derived affected_workspace_ids, the golden) by addition to ledger-format v1 under D40/D113; the answer is D41's sign-off for S2 reaching main with its decision entry and CONTRACTS.md register change."

The envelope, F0, F2-05 to F2-08 and the format version do not change; `Defined()` then lists twenty type versions. Core's workspace service writes all of these records, from ticket 09's S3a on; requests and endings are recorded as yours, holds and the switch as Core's.

| Record | What it says | When Core writes it |
|---|---|---|
| `workspace.policy_activation_requested` (new) | Your exact approval: a new request ID, your approval's ID, the law and validation policy digests, every workspace's check and environment policy digests, the workspaces affected, the active manifest it expects (none before the first activation), and when it may take effect: immediately, or not before a stated time. A permanent pin on the approved bytes follows it in the same commit. | When Core admits your request, alone or just after the ending of the request it replaces |
| `workspace.policy_activation_hold_changed` (new) | The pending request's hold: `due` (its time has come on a trusted clock), `clock_untrusted` (Core cannot trust the clock, so it waits), or `none` (trust came back before the time), with the observed time when the clock is trusted. | Only when the hold changes |
| `workspace.policy_activation_ended` (new) | The request ends without taking effect, `cancelled` or `replaced` by a new request in the same commit, naming the revision of the request it ends. | When you cancel or replace the pending request |
| `workspace.policy_activated` (new) | The colony's one switch to the approved manifest: its epoch, the approved digests and policy map, your approval, the request it applies, the manifest it replaces, and the scheduled and actual times. Its position in the log and its hash are its identity. | When the request is due and no affected workspace has a promotion intent still unresolved |
| optional `activation_record_hash`, on `workspace.finalization_intended` | Names the active manifest a promotion intent was made under. | On each new intent once a first activation exists |

The rules frozen with them bind only F2-09 records and the new key, so every log without them stays valid, and an intent without the key keeps its F2-08 bytes. Among them: one pending request per colony, whose revision is the position of its latest record; and a durable clock floor, the latest trusted time recorded, below which no recorded time may go.

## What freezing means for you

- These shapes and rules then change only by addition: new optional keys, types or type versions, and new `ended` outcomes. A breaking change needs your decision entry (D40).
- S2 reaches `main` with the freeze record, and S3a is then built to write these records.
- Nothing activates or promotes through the product: C2 still answers `no_validator` (D52), and package tests alone reach the writing code until C3 and C4.

## Consequences you may want to change

Yours at this freeze; name any by number:

1. **The four names** above, which the build advisor recommends.
2. **Your approval.** Each request carries `owner_approval_id`, a new ID never reused, and is that approval: it ends only by cancellation or replacement, each checked against its current revision. Approving the same bytes again is a new request. C3's revocation, when F3 defines it, joins later as a new `ended` outcome.
3. **Retention.** The approved law, validation policy and every check and environment policy are kept for the life of the log, never unpinned, even after cancellation or replacement. Check and environment bytes get identity, not meaning: Core checks their digests only.
4. **One pending request per colony,** naming the active manifest it expects. A stale expectation is refused when you ask, and nothing is recorded.
5. **The affected workspaces are derived:** every workspace in the old or new map when the law or validation policy changes, otherwise exactly those whose entry is added, removed or changed; at the first activation, those listed.
6. **Time.** Times are signed 64-bit UTC nanoseconds, any value allowed, their order checked by Core. A hold records the observed time only when the clock is trusted; `clock_untrusted` records none rather than a made-up time.
7. **Holds are durable and the request's own.** `due` is final until the request ends or applies; an untrusted clock holds the request rather than bypassing its schedule.
8. **One switch,** colony-wide, at an actual trusted time, never backdated to the scheduled one, and only once no affected workspace has an unresolved promotion intent; its position and hash come from the log, not from its contents.
9. **The intent key.** After the first activation, every new promotion intent names the active manifest, and a workspace without an entry in it cannot start one. Before that, intents stay as F2-08 froze them.
10. **The open `outcome` token.** Version 1 writes `cancelled` and `replaced`; a reader takes any other well-formed token as an ending it does not know: the request is over and not applied.
11. **Replay never executes:** rebuilding state from the log reads no clock, starts no timer and appends nothing.
12. **The golden** named below, which pins an example of each new record and of the intent key.

Not yours here, as the ruling frames it: no new dependency (D29); no change to D52, since nothing admits, validates, activates or moves `main` through the product; no change to the full check (D42); no design question (D117); and ticket 09's build entry at its close.

## Evidence

| Item | Result |
|---|---|
| S2 commit | 93b76a4, `feat(ledger): draft F2-09 policy activation records for the owner's freeze` |
| Golden `contract/ledger/testdata/f2/09/log/00000000000000000001.jsonl` | twenty-two commits, thirty-four records; SHA-256 f1a0c473ee410c189c743547f37c86ebd638ce9c92c68cd44d1b2816f9f3ad88 |
| Package tests (V2) | PASS: `contract/ledger` in 8.9 s and `internal/core/ledgerstore` in 46.2 s; every seed corpus passed |
| Fuzzing `FuzzDecodeF2_09` and `FuzzDecodeF2_08`, 120 s each (V3) | PASS: 2,660,267 and 4,678,101 executions; no new corpus file |
| F0 and F2-05 to F2-08 goldens unchanged (V8) | PASS: each regenerates byte for byte, matching the digests of D111, D115, D118, D119 and D123 |
| Full check (V4) | PASS: all nine steps in 1,653 s on 93b76a4; it runs again on the record commit |
| Build advisor's review of S2 | Approved by the build advisor on 93b76a4: additions only, every earlier golden byte-identical, each decoder rule tested and broken once, the F2-09 section and its record rules as ruled, nothing under internal/; two register and Undercurrent wording additions carried to the freeze record. |

## Your choices

- **Freeze as presented** (recommended): freeze F2-09 at 93b76a4 with points 1–12 as they stand. Your decision entry and the register change are recorded, S2 reaches `main`, and S3a no longer waits for the freeze.
- **Freeze with changes:** name them by point number. A follow-up commit on `build/09-f2` makes them, its evidence is collected, and the freeze is recorded at that commit. S2 stays off `main` until then.
- **Not yet:** nothing is frozen. S2 stays off `main` and S3a waits. You may say what is missing.

**The question:** do you freeze F2-09, the four policy activation record types and the optional `activation_record_hash` on `workspace.finalization_intended`, with their rules, at version 1 by addition to `ledger-format`?

With your answer, one documents commit records it: the decision entry and a cross-reference under D113; the `ledger-format` row and an F2-09 table in `docs/CONTRACTS.md`; the "frozen" wording in `contract/ledger`'s comments; a pointer in Undercurrent's `PolicyActivationManifest` sketch and notes in its §15.1 "Promotion attempted" and law-activation rows; and this packet's answer line.

## Supporting material

- `contract/ledger/doc.go`, section `# F2-09 record types`: every key, decoder rule and record rule.
- The golden named above, at 93b76a4.
- The design brief and the build advisor's ruling, held by the project manager until the ticket closes, when they land as `.scratch/dwarf-harness/c2-evidence/ticket-09-design-brief.md` and `ticket-09-design-ruling.md`.
- The evidence: `.scratch/dwarf-harness/c2-evidence/f2-09-freeze-evidence.md`.
