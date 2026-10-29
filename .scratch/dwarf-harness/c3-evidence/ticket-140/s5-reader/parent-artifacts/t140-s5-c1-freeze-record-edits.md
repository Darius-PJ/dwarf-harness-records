# Ticket140 S5 — completed C1 Reader freeze: unapplied edit draft

This is a future-completion draft, not an applied record, approval, freeze or permission for C3. PM alone fills and applies it after the completed implementation, evidence and these exact edits receive joint independent approval. Original brief 93bf8a13f847d03626672caae2a77f35e97ddfcc968b63568dd4ea12bc81cc55 plus actual ruling ef2dfa6612bf2114dcb3229d474d841389df749d868fdb1dfb9bfb36ca702611 govern; the ruling's P7 correction prevails. Actual adopted D156, privately published at b63d618c76b864ec08855bd78eadcf3e27cf7588, supplies only the two-milestone sequencing exception. [Sources: docs/DECISIONS.md:2134-2141,3090-3116; PM/t140-s5-design-ruling.json:125-136,206-288; PM/t140-d156-publication.json:62-68.]

Citation roots: repository paths are canonical MAIN C:/Users/darius.jones/Documents/PROJECTS/dwarf-harness. PM/ is the parent local root named in the assignment. These roots and all private citations are private drafting material, never public replacement content. Finds R1 and R2 were copied from canonical raw reads; no changing implementation was inspected. R3's explicitly deferred tail anchor must be copied afresh by PM at application, not inferred from this draft.

## Application boundary

R1 is the ONLY public edit. R2–R4 belong only to the private records repository. Do not allocate a B entry, future D number or freeze date now. Do not edit package source/docs, any ticket/roadmap/status board, family catalogue, B2 table, fixture, format or schema. Package implementation/documentation is the coder's separate five-file delivery. The public replacement deliberately has no public commit-hash fill and no private path, owner quotation or machine detail. [Sources: PM/t140-s5-c1-freeze-drafter-assignment.md:24-27,31-39; docs/CONTRACTS.md:3,11-27; PM/t140-s5-coder-assignment.md:29-37; PM/t140-s5-design-ruling.json:206-250,289-346.]

#### R1 — docs/CONTRACTS.md
Extend only the existing ledger-reader definition/status cell by the completed additive capability; preserve owner, all consumers, version 1 and existing Frozen boundary.
Find:
````
| `ledger-reader` | Colony-sequence reads, declared type-family consumption, skip/stop behavior and replay after restart (D35); missing fields remain absent, never guessed defaults. `ReadOptions.AllTypes` also returns the records of unconsumed types for their envelope fields, such as `body_refs`, without checking their versions; their payloads are not the consumer's to decode. `ParseSegmentName` reads a segment's first sequence from its file name | C1 | Core C2/C3; U1.L/U1.E and each field capability; C4–C9; R1; U3 only for its frozen families | 1 | Frozen |
````
Replace:
````
| `ledger-reader` | Colony-sequence reads, declared type-family consumption, skip/stop behavior and replay after restart (D35); missing fields remain absent, never guessed defaults. `ReadOptions.AllTypes` also returns the records of unconsumed types for their envelope fields, such as `body_refs`, without checking their versions; their payloads are not the consumer's to decode. `ParseSegmentName` reads a segment's first sequence from its file name. Optional process-local checkpoint reads (`ReadCheckpoint`, `OpenReaderWithCheckpoint`, `Reader.Checkpoint`) reuse completed prefix verification only after fresh equality of every framed prefix byte and the predecessor chain; the suffix uses the existing parser/verifier. Invalid or stale hints fall back to ordinary scanning with opt-in actual-close error reporting. Issuance requires complete numeric processing, terminal EOF and successful closure; there is no persistent encoding or retained resource. Existing `OpenReader`, `Check`, `ReadOptions`, `Commit` and consumer behavior remain unchanged; see the [package documentation](../contract/ledger/doc.go) for the complete eligibility, fallback and closure contract | C1 | Core C2/C3; U1.L/U1.E and each field capability; C4–C9; R1; U3 only for its frozen families | 1 | Frozen; additive checkpoint capability (D«D-NEXT») |
````

#### R2 — docs/DECISIONS.md
Add exactly one D125 See-also pointer, without changing any earlier decision body.
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
Append the assistant-originated completed-capability freeze decision at the actual private log tail, filled only by PM after joint approval and bound to actual integration evidence.
Find:
````
«LOG-LAST-LINE»
````
Replace:
````
«LOG-LAST-LINE»

### D«D-NEXT». Additive ledger-reader checkpoint capability frozen

- **Date:** «DATE». **Decided by:** assistant. Under D125 and D156, the project manager freezes the completed C1 Reader increment within Ticket140's one fifth-and-final assignment, without a new owner question or packet. The original brief (SHA256 93bf8a13f847d03626672caae2a77f35e97ddfcc968b63568dd4ea12bc81cc55) and actual fresh Astra ruling (SHA256 ef2dfa6612bf2114dcb3229d474d841389df749d868fdb1dfb9bfb36ca702611), including its P7 correction, govern. D156's adopted sequencing choice was privately published at b63d618c76b864ec08855bd78eadcf3e27cf7588; it was not technical approval or an upfront freeze. **Joint completed-code/evidence/exact-record review:** «JOINT-REVIEW»
- **Decision:** freeze the nonbreaking optional addition to existing `ledger-reader` version 1: `type ReadCheckpoint struct`, `func OpenReaderWithCheckpoint(logDir string, opts ReadOptions, checkpoint *ReadCheckpoint) (*Reader, error)` and `func (r *Reader) Checkpoint() *ReadCheckpoint`. C1 owns it; registered consumers remain those in `CONTRACTS.md`. The fixed-width private-field token has exactly the ruled thirteen fields, no pointer-bearing or retained-resource payload, and is returned as a fresh value copy. It is process-only, with no persistent format, constructor, marshaler, unmarshaler or raw-token import. Its checksum detects accidental damage, not hostile same-process forgery.
  - The Reading guarantee remains whole commits and verification of every read record, consumed or not: hash, chain, sequence, commit framing, colony and time. Previously completed Reader verification plus this call's fresh equality of every framed byte in the containing-segment prefix and all fields of the freshly read predecessor chain establish the same prefix invariants. Revalidate context, numeric advancing bounds/exact After, segment selection/continuity, version/checksum/shape and base chain before restoration; hash the full prefix with bounded 64-KiB scratch on the same descriptor used for suffix reading. Restore only the complete after-chain at the absolute logical offset; the suffix retains the original parser/verifier and this open's consumption/version behavior.
  - Only a fully processed numeric Through, terminal EOF, matching cursor/verifier sequence, complete final chain and successful actual Close can issue a checkpoint. ToEnd/equal bounds, early Close, partial commits and read/close failures issue none. Missing, damaged, mismatched, rotated, short or byte-changed proofs use ordinary scanning while retaining opt-in checked-close mode. Failure to derive optional Abs-then-Clean path identity disables proof capture/use, not ordinary reading. Genuine non-EOF I/O, seek and close failures remain errors.
  - Retain the first actual opt-in close failure across automatic EOF/error closure, transition, explicit and repeated Close, predecessor-helper and discarded-candidate closure; stop before opening a next segment after transition-close failure. Normal EOF cannot erase a close failure, and failed closure forbids issuance. Legacy `OpenReader` and `Check`, `ReadOptions`, `Commit`, signatures and existing consumers retain their behavior. See the completed package documentation at «PACKAGE-DOC-CITATION» for the detailed mechanics.
- **Not changed or established:** ledger-format, record families/catalogue/Defined count, schema, fixtures or goldens; appender/ledgerstore, Submit/Receipt, Digest unmarshaling or privateStore; existing consumers or Core/Undercurrent step status. Prefix I/O and SHA-256 remain. The proof inherits the existing append-only writer protocol, not a filesystem snapshot, hostile-rewrite atomicity, OS isolation or power-loss guarantee. There is no C3 integration, scan-free/O(1), capacity/provider/executor/SLA or new numerical acceptance claim.
- **Evidence:** implementation «C1-IMPLEMENTATION-SHA» and exact five-file manifest; [Reader evidence](../.scratch/dwarf-harness/c3-evidence/ticket-140-s5-reader-freeze-evidence.md) records actual observable proofs, four minimal Reader-level reds/exact restores/same-command greens, four reachable 120-second fuzz campaigns and counts, unchanged fixture identity, host focused/plain/format/static/import/module evidence and raw outputs. The pre-freeze prefix oracle is `TestReaderCheckpointChangedPrefix`, never the yet-unauthorized Core Service test. Joint-review artifact/provenance: «JOINT-REVIEW-RECEIPT». Final public freeze subject: «C1-FREEZE-SHA»; code-hash/record-delta bridge: «CODE-HASH-BRIDGE». Own exact-SHA full hosted Windows/Linux/macOS, race and `Check result`: «C1-HOSTED-RESULT». Actual guarded fast-forward/main publication: «C1-MAIN-PUBLICATION». Private binding and publication: «PRIVATE-BINDING». Historical S4 failed cohorts and diagnostic are retained separately and are not this increment's executed or numerical proof.
- **Consequences:** additive-only under D40; breaking changes still require the owner. D125 joint approval supplies this increment's D41 sign-off, not permission to skip D153 integration. No C3 implementation or new-API consumer tests until PM records the completed freeze, its own exact-SHA full hosted success and main publication with private binding. Only then may the same D156-authorized assignment continue with the ruled Core consumer; keep this C1 evidence by exact source identity without repeating unchanged campaigns. Final combined review, a separate exact-final-SHA hosted result, all seven unchanged original bounds/traffic/eligibility rules and separate whole-ticket Fable verification remain. The later cache is one entry within the existing single 256-entry/8-MiB charged-metadata cap, not a new allowance or RAM bound. No sixth slice or upfront/retrospective freeze.
- **Changes:** one existing `CONTRACTS.md` register row; this entry; one D125 See-also pointer; the private Reader evidence file. Package code/documentation is the separately reviewed C1 implementation, not an additional edit in this record. No B allocation, ticket-close or roadmap-status change.
````

#### R4 — .scratch/dwarf-harness/c3-evidence/ticket-140-s5-reader-freeze-evidence.md
Create the private completed-capability evidence record using the exact separately delivered evidence body after actual fills; do not create it from this unfilled draft.
Find:
````
````
Replace:
````
«EVIDENCE-BODY»
````

## Fill table and sequencing

| Token | Exact source / fill point |
|---|---|
| «D-NEXT» | PM allocates the actual unused digits only at freeze application. D157 is not reserved; B35 is not allocated here. Use the same digits in R1–R3 and the evidence. |
| «DATE» | Actual freeze date on the owner's local calendar, not the drafting or authority-publication date. |
| «LOG-LAST-LINE» | PM raw-copies the current private DECISIONS.md last nonempty line at application and asserts a unique exact match. Draft-time tail was docs/DECISIONS.md:3116; Ticket139/B34 or later entries may advance it. Do not change an existing entry body or use a stale tail. |
| «JOINT-REVIEW» | Verbatim actual fresh independent completed-code + filled evidence + exact R1–R4 review line, with reviewer/model provenance retained privately; not the design ruling. Fill at M2 only. |
| «JOINT-REVIEW-RECEIPT» | Immutable review artifact path, digest and exact source/record identities approved; advisor record corrections incorporated before freeze. |
| «C1-IMPLEMENTATION-SHA» | Actual settled C1 implementation commit after PM's source proof lane. |
| «PACKAGE-DOC-CITATION» | Exact completed C1 SHA and actual contract/ledger/doc.go line range, supplied after implementation settles; do not infer from moving source. |
| «C1-FREEZE-SHA» | Actual final public SHA containing completed code/package docs plus R1, identified after reviewed record application. Only private text uses this fill. |
| «CODE-HASH-BRIDGE» | Actual implementation-to-public-freeze five-file SHA-256 equality and precise public-record delta; identify any comment-only code delta explicitly and its reviewed evidence implications. |
| «C1-HOSTED-RESULT» | Actual C1_FREEZE_SHA run URL/ID/attempt, full (not Markdown-exempt) Win/Linux/macOS jobs, race and successful Check result with raw retained records; fill at M3. |
| «C1-MAIN-PUBLICATION» | Actual checked-SHA guarded fast-forward/public main and remote publication receipt; fill at M3, never predict. |
| «PRIVATE-BINDING» | Actual private record/public-subject/check/review binding and guarded publication receipt. It must not require its own commit hash inside its own bytes: use an external immutable publication receipt or actual later binding record. |
| «EVIDENCE-BODY» | Exact UTF-8/LF contents of t140-s5-c1-freeze-evidence-draft.md, all its actual evidence fills completed by PM. No summary, second fence or unresolved placeholder in the applied file. |

PM prepares M2 evidence and review first, then includes R1 in the final public freeze SHA without that SHA appearing in R1. After that exact public SHA passes its own full hosted gate and is published, PM completes private integration/binding facts and records the hard C3 release. Review approval must explicitly distinguish the reviewed contract/record text from subsequently filled factual run/publication fields; a changed reviewed premise returns to the D152 blocking-review rule, not an invented routine confirmation gate. Preserve the approved record and final filled copy separately. [Sources: PM/t140-s5-design-ruling.json:232-288; docs/DECISIONS.md:3032-3044,3057-3069,3109-3116.]

## Drafter report

- **P1 — preserve one boundary.** Existing ledger-reader row only, existing version/consumers and guarantee retained; no new family/status source. Sources: docs/CONTRACTS.md:3,11-27; contract/ledger/doc.go:132-154; PM/t140-s5-design-ruling.json:166-194.
- **P2 — describe proof rather than promise a speed result.** Opaque copied process-only token, prior verification + full fresh framed-prefix equality + predecessor, ordinary fallback and opt-in actual-close behavior; no self-hash in public text. Sources: PM/t140-s5-design-brief.md:41-95; PM/t140-s5-design-ruling.json:39-60,98-136,206-208.
- **P3 — record completion, not advance permission.** Future assistant-originated D125/D156 decision and one pointer; actual number/date/evidence intentionally unfilled. Sources: docs/DECISIONS.md:2134-2147,3079-3088,3104-3116; PM/t140-d156-publication.json:62-68.
- **P4 — no borrowed proof.** Reader-only prefix mutation before freeze; future own exact-SHA hosted/main/private bridge; final Core and numerical gates stay distinct. Sources: PM/t140-s5-design-ruling.json:125-136,220-288,347-420.
- **Unsettled facts:** actual implementation bytes/commit and package-doc range; all executed proof outputs/counts; completed-code/record review; actual D/date/tail; public freeze SHA and hosted/main/private receipts. These are future PM fills, not design questions or missing authority. Companion evidence and outstanding-map drafts specify each source. No repository/private-record edit, native execution or subagent was used.
