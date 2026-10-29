# Ticket140 S5 — exact unapplied C1 record for joint review

R1 below is byte-for-byte the latest parent public replacement, including unchanged `ReadOptions`/`Commit` and its sole future D-digits fill. R2–R4 retain the existing pointer/assistant-originated decision/private-evidence mechanics. Completed M1 facts bind to implementation `81ae94d3e92b5fd5574f46046c42fc9c5e30ce6d`, base `84d0ced9446168777c7b7bfa3382974977bf27ed`, including all four actual bg87 fuzz completions. Only M2 verdict/provenance and M3 integration/application facts remain deferred. No edit is applied; no freeze, status change, B record, D/date allocation or C3 release is claimed. [Sources: PM/t140-s5-c1-freeze-record-edits.md:15-94; PM/t140-s5-c1-implementation-proof.json:2-44; PM/t140-s5-c1-fuzz-complete.json:1-218.]

Citation roots are the same as companion `t140-s5-c1-m2-evidence-review.md`. R1 is the only public edit; R2–R4 are private. R3 uses the literal currently observed tail, not a future placeholder Find; parent must refresh that anchor at apply. All other future fields occur only in replacement values. D157 and B35 remain unallocated.

#### R1 — docs/CONTRACTS.md
Extend only the existing reader register row; preserve the latest parent replacement exactly.
Find:
````
| `ledger-reader` | Colony-sequence reads, declared type-family consumption, skip/stop behavior and replay after restart (D35); missing fields remain absent, never guessed defaults. `ReadOptions.AllTypes` also returns the records of unconsumed types for their envelope fields, such as `body_refs`, without checking their versions; their payloads are not the consumer's to decode. `ParseSegmentName` reads a segment's first sequence from its file name | C1 | Core C2/C3; U1.L/U1.E and each field capability; C4–C9; R1; U3 only for its frozen families | 1 | Frozen |
````
Replace:
````
| `ledger-reader` | Colony-sequence reads, declared type-family consumption, skip/stop behavior and replay after restart (D35); missing fields remain absent, never guessed defaults. `ReadOptions.AllTypes` also returns the records of unconsumed types for their envelope fields, such as `body_refs`, without checking their versions; their payloads are not the consumer's to decode. `ParseSegmentName` reads a segment's first sequence from its file name. Optional process-local checkpoint reads (`ReadCheckpoint`, `OpenReaderWithCheckpoint`, `Reader.Checkpoint`) reuse completed prefix verification only after fresh equality of every framed prefix byte and the predecessor chain; the suffix uses the existing parser/verifier. Invalid or stale hints fall back to ordinary scanning with opt-in actual-close error reporting. Issuance requires complete numeric processing, terminal EOF and successful closure; there is no persistent encoding or retained resource. Existing `OpenReader`, `Check`, `ReadOptions`, `Commit` and consumer behavior remain unchanged; see the [package documentation](../contract/ledger/doc.go) for the complete eligibility, fallback and closure contract | C1 | Core C2/C3; U1.L/U1.E and each field capability; C4–C9; R1; U3 only for its frozen families | 1 | Frozen; additive checkpoint capability (D«D-NEXT») |
````

#### R2 — docs/DECISIONS.md
Add the established one-line D125 See-also pointer without rewriting an earlier entry.
Find:
````
- **See also:** D154 records the project manager's freeze of F3-139, ticket 139's external-resource registration, work-domain registration, declaration and receipt family, under this entry.
````
Replace:
````
- **See also:** D154 records the project manager's freeze of F3-139, ticket 139's external-resource registration, work-domain registration, declaration and receipt family, under this entry.
- **See also:** D«D-NEXT» records the completed additive ledger-reader checkpoint capability under this entry and D156's Ticket140-only sequencing exception.
````

#### R3 — docs/DECISIONS.md
Append the assistant-originated completed-capability decision at the provisional literal private tail; apply only after the actual joint approval and factual fills.
Find:
````
- **Changes:** Ticket139's close and the paired C3/U3 progress lines, with private supporting records. C3 and U3 remain In progress.
````
Replace:
````
- **Changes:** Ticket139's close and the paired C3/U3 progress lines, with private supporting records. C3 and U3 remain In progress.

### D«D-NEXT». Additive ledger-reader checkpoint capability frozen

- **Date:** «DATE». **Decided by:** assistant. Under D125 and D156, the project manager freezes the completed C1 Reader increment within Ticket140's one fifth-and-final assignment, without a new owner question or packet. The original brief (SHA256 93bf8a13f847d03626672caae2a77f35e97ddfcc968b63568dd4ea12bc81cc55) and actual fresh Astra ruling (SHA256 ef2dfa6612bf2114dcb3229d474d841389df749d868fdb1dfb9bfb36ca702611), including its P7 correction, govern. D156's adopted sequencing choice was privately published at b63d618c76b864ec08855bd78eadcf3e27cf7588; it was not technical approval or an upfront freeze. **Joint completed-code/evidence/exact-record review:** «JOINT-REVIEW»
- **Decision:** freeze the nonbreaking optional addition to existing `ledger-reader` version 1: `type ReadCheckpoint struct`, `func OpenReaderWithCheckpoint(logDir string, opts ReadOptions, checkpoint *ReadCheckpoint) (*Reader, error)` and `func (r *Reader) Checkpoint() *ReadCheckpoint`. C1 owns it; registered consumers remain those in `CONTRACTS.md`. The fixed-width private-field token has exactly the ruled thirteen fields, no pointer-bearing or retained-resource payload, and is returned as a fresh value copy. It is process-only, with no persistent format, constructor, marshaler, unmarshaler or raw-token import. Its checksum detects accidental damage, not hostile same-process forgery.
  - The Reading guarantee remains whole commits and verification of every read record, consumed or not: hash, chain, sequence, commit framing, colony and time. Previously completed Reader verification plus this call's fresh equality of every framed byte in the containing-segment prefix and all fields of the freshly read predecessor chain establish the same prefix invariants. Revalidate context, numeric advancing bounds/exact After, segment selection/continuity, version/checksum/shape and base chain before restoration; hash the full prefix with bounded 64-KiB scratch on the same descriptor used for suffix reading. Restore only the complete after-chain at the absolute logical offset; the suffix retains the original parser/verifier and this open's consumption/version behavior.
  - Only a fully processed numeric Through, terminal EOF, matching cursor/verifier sequence, complete final chain and successful actual Close can issue a checkpoint. ToEnd/equal bounds, early Close, partial commits and read/close failures issue none. Missing, damaged, mismatched, rotated, short or byte-changed proofs use ordinary scanning while retaining opt-in checked-close mode. Failure to derive optional Abs-then-Clean path identity disables proof capture/use, not ordinary reading. Genuine non-EOF I/O, seek and close failures remain errors.
  - Retain the first actual opt-in close failure across automatic EOF/error closure, transition, explicit and repeated Close, predecessor-helper and discarded-candidate closure; stop before opening a next segment after transition-close failure. Normal EOF cannot erase a close failure, and failed closure forbids issuance. Legacy `OpenReader` and `Check`, `ReadOptions`, `Commit`, signatures and existing consumers retain their behavior. See the completed package documentation at `81ae94d3e92b5fd5574f46046c42fc9c5e30ce6d:contract/ledger/doc.go:156-176` for the detailed mechanics.
- **Not changed or established:** ledger-format, record families/catalogue/Defined count, schema, fixtures or goldens; appender/ledgerstore, Submit/Receipt, Digest unmarshaling or privateStore; existing consumers or Core/Undercurrent step status. Prefix I/O and SHA-256 remain. The proof inherits the existing append-only writer protocol, not a filesystem snapshot, hostile-rewrite atomicity, OS isolation or power-loss guarantee. There is no C3 integration, scan-free/O(1), capacity/provider/executor/SLA or new numerical acceptance claim.
- **Evidence:** implementation `81ae94d3e92b5fd5574f46046c42fc9c5e30ce6d` on `84d0ced9446168777c7b7bfa3382974977bf27ed`; all five committed source hashes match. The [Reader evidence](../.scratch/dwarf-harness/c3-evidence/ticket-140-s5-reader-freeze-evidence.md) binds actual continuation/options/prefix/predecessor/fallback and real-file-close observable proof; four PM-accepted one-predicate semantic reds, exact restores and same-command greens. Four serial120s-budget/parallel1 campaigns passed: ReaderCheckpoint27147, Truncation14993, TornTail285 (one new interesting input), Corruption14993; actual package/native durations and raw outputs are retained separately from the budget. The first wrong-path launcher failed before any Go; no campaign repeated. The pre-freeze prefix oracle is `TestReaderCheckpointChangedPrefix`, never a yet-unauthorized Core Service test. Focused run: 21 top-level/60 PASS rows. The single plain run: 84 top-level tests + 15 top-level fuzz seed runs, 9382 PASS rows, 0 FAIL/0 SKIP, package 7.301s. Host format/vet/staticcheck and remaining imports/module commands passed; the initial bad import-template capture stop is retained, with only its five remaining calls run afterward and no successful proof repeated. All46 frozen fixtures match base bytes, 748606 bytes/0 CR; no golden regeneration. Separate original authorities and the honest former CRLF ruling capture remain retained; restoring the actual original assistant LF substring changed no ruling or policy. Joint-review artifact/provenance: «JOINT-REVIEW-RECEIPT». Final public freeze subject: «C1-FREEZE-SHA»; code-hash/record-delta bridge: «CODE-HASH-BRIDGE». Own exact-SHA full hosted Windows/Linux/macOS, race and `Check result`: «C1-HOSTED-RESULT». Actual guarded fast-forward/main publication: «C1-MAIN-PUBLICATION». Private binding and publication: «PRIVATE-BINDING». Historical S4 failed cohorts and diagnostic remain separate nonacceptance evidence.
- **Consequences:** additive-only under D40; breaking changes still require the owner. D125 joint approval supplies this increment's D41 sign-off, not permission to skip D153 integration. No C3 implementation or new-API consumer tests until PM records the completed freeze, its own exact-SHA full hosted success and main publication with private binding. Only then may the same D156-authorized assignment continue with the ruled Core consumer; keep this C1 evidence by exact source identity without repeating unchanged campaigns. Final combined review, a separate exact-final-SHA hosted result, all seven unchanged original bounds/traffic/eligibility rules and separate whole-ticket Fable verification remain. The later cache is one entry within the existing single 256-entry/8-MiB charged-metadata cap, not a new allowance or RAM bound. No sixth slice or upfront/retrospective freeze.
- **Changes:** one existing `CONTRACTS.md` register row; this entry; one D125 See-also pointer; the private Reader evidence file. Package code/documentation is the separately reviewed C1 implementation, not an additional edit in this record. No B allocation, ticket-close or roadmap-status change.
````

#### R4 — .scratch/dwarf-harness/c3-evidence/ticket-140-s5-reader-freeze-evidence.md
Create the private evidence from the exact companion body after the specified actual future fills.
Find:
````
````
Replace:
````
«EVIDENCE-BODY»
````

## Remaining-fill map

Only values below remain future facts; completed implementation/package-doc/authority/host/fixture/mutant fills are no longer placeholders. No new confirmation gate is introduced.

| Field | Actual source and timing |
|---|---|
| Four fuzz fills | Completed from PM/t140-s5-c1-fuzz-complete.json:1-218 and actual native raw outputs; no future fuzz token remains. All four children exit0, no timeout, reaped/streams complete, exact five source hashes unchanged. PM full local Go released; no further native work or C3 release. |
| «JOINT-REVIEW», «JOINT-REVIEW-RECEIPT» | Actual M2 verbatim independent joint completed-code/filled-evidence/exact-R1–R4 review line, saved verdict/request/provenance paths and actual captured digests. Not the Astra design ruling. |
| «REVIEW-SUBJECT», «REVIEWED-RECORD», «REVIEW-DISPOSITION» | Companion M2 code/five-blob/evidence/record identities, reviewed bytes/digests and findings/corrections disposition; later actual integration facts explicitly deferred in the submitted review. Preserve approved and final filled copies separately. |
| «D-NEXT», «DATE» | PM's actual unused D digits and owner's local-calendar freeze date at application after approval. D157/B35 are unallocated; no B entry. Use identical actual digits throughout. |
| R3 literal Find/tail | Observed canonical docs/DECISIONS.md:3123, raw-copied above. Parent refreshes Find and the first retained Replace line to actual last nonempty line at apply; no earlier entry body change. |
| «C1-FREEZE-SHA», «PUBLIC-FREEZE-IDENTITY», «CODE-HASH-BRIDGE», «EXACT-SHA-REVIEW-BINDING» | Actual public commit/parent containing code/package docs + R1, five-blob equality/public-register delta and actual review binding. No self-hash in R1; any material code/premise change invokes existing affected-proof/review rules, not routine recertification. |
| «HOSTED-FULL-MATRIX», «C1-HOSTED-RESULT» | Actual SAME-C1_FREEZE_SHA own full Windows/Linux/macOS/race jobs and Check result; URL/run/attempt/head/classifier/completion/raw evidence. Never a document-exempt aggregate or later Core CI. |
| «C1-MAIN-PUBLICATION», «PRIVATE-BINDING», «PRIVATE-PUBLICATION-RECEIPT», «COMPLETED-DECISION-COPY» | Actual guarded checked-SHA fast-forward/main/remote and private D/evidence/review/check/public-subject binding/digests/publication. External immutable receipt avoids writing a private commit's own hash inside its bytes. |
| «CORE-RELEASE-RECEIPT» | Companion field for PM's later actual release only after integrated freeze, own hosted/main/private facts; no release asserted here. |
| «EVIDENCE-BODY» | Exact UTF-8/LF companion `t140-s5-c1-m2-evidence-review.md` after its actual future fills, as R4's single replacement. No unresolved token in applied records. |

Evidence already retained locally/natively remains at its cited original paths; parent preserves original source/host/mutant/fuzz/review/integration bytes and records actual copy identities under existing `.scratch/dwarf-harness/c3-evidence/`. The nine authority copy paths/hashes are completed facts in the companion, not new future-copy requests. Actual private publication binding remains future. No new evidence scheme or invented digest is introduced.

## Drafter choices and unresolved facts

- **P1 — exact public cutover:** unchanged latest R1; canonical Find from docs/CONTRACTS.md:26. Existing version/consumers/ReadOptions/Commit stay intact; public text contains no owner quote, private source or machine detail. Source: PM/t140-s5-c1-freeze-record-edits.md:15-25.
- **P2 — facts, not forecasts:** fill C1/five blobs/package-doc/host/mutant/fixture/authority/four actual fuzz receipts, retaining import-stop/M3/M4/TornTail limits. Sources: PM/t140-s5-c1-implementation-proof.json:2-44; PM/t140-s5-c1-mutants-pm-acceptance.json:1-149; PM/t140-s5-c1-fuzz-complete.json:1-218; companion citations.
- **P3 — preserve delegated mechanics:** one D125 pointer and assistant-originated append, current literal tail, no D/date/B allocation. Sources: docs/DECISIONS.md:2134-2147,3104-3123; parent record draft R2–R4.
- **P4 — separate approval and factual integration:** M2 code/evidence/contract prose reviewed jointly; M3 actual SHA/hosted/main/private fills do not claim an existing freeze or release. No routine confirmation pass; changed reviewed premises follow D152/D153. Sources: PM/t140-s5-c1-freeze-drafter-assignment.md:31-39; PM/t140-s5-design-ruling.json:232-288.
- **Unresolved:** actual independent joint verdict/provenance/record identities/disposition; D/date/apply-time tail; final public freeze SHA/hash bridge/own full hosted result/main/private publication and subsequent PM release. No M1 fuzz-result fill remains. Core implementation and the original seven numerical bounds remain later work, not C1 claims. No native command or repository/private-record write was performed by this drafter.
