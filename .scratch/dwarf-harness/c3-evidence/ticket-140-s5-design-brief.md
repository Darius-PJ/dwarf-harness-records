# Ticket140 S5 — exact authoritative acknowledgement without prefix re-decoding

## 0. Status, authority and perimeter

**Ready for a fresh technical ruling; not an implementation authorization.** Source subject: canonical MAIN `8a17ec1ed2617ca2a4e5203479f75f363b359970`, including 139 S1/S2; never the secondary139 mutant tree. D155 grants ONE fifth-and-final slice only. It does not approve this mechanism, a Reader change, a freeze, numerical acceptance or ticket close. Sources: `docs/DECISIONS.md:3090-3102`; `PM/t140-s4-review-binding.json:1-18`.

Citation roots: repository-relative paths mean canonical MAIN. `PM/` means `C:/Users/darius.jones/.omp/agent/sessions/-Documents-PROJECTS-dwarf-harness/2026-10-24T15-58-31-752Z_01a16ea2-9748-77b3-ac90-a8beabd7bc22/local/`. Private citations are team-only; do not copy their contents into public comments/docs. This brief is the only artifact this designer writes.

`ticket140` abbreviates `.scratch/dwarf-harness/issues/140-bound-the-private-state-services-replay-and-lookup-cost.md`; its canonical tracker conventions were read first (`docs/agents/issue-tracker.md:1-24`). Design derivations use P numbers; existing requirements retain their cited authority.

**Recommendation:** an opt-in, byte-revalidated, opaque **single-position Reader checkpoint**, held as ONE entry in the existing LRU. Re-read and SHA-256 the earlier containing-segment bytes; if identical to bytes previously fully verified by that Reader, restore their verified chain position and decode only the suffix. Any missing/invalid/changed proof uses the ordinary Reader. This explicitly expands `contract/ledger` Reader/scanner implementation and adds an existing-contract capability; it is NOT a demonstrated Core-only solution, retained reader, segment-offset catalogue, replay snapshot or new authority. P1–P8 below are recommendations, not decisions. Sources: `docs/DECISIONS.md:3095-3099`; `contract/ledger/reader.go:55-95,170-205`; `contract/ledger/scan.go:151-176,302-359`.

The seven bounds, original traffic, error/authority/recovery fences, 256-entry/8-MiB charged-metadata cap and all owner gates remain. No sixth slice, dependency/toolchain/provider/money/machine/workflow change, `.github/` edit, disk-layout/record/schema/golden change, `Digest` unmarshaler change, general command index or extra startup optimization is proposed. Sources: `docs/DECISIONS.md:122-132,3032-3044,3095-3102`; `PM/t140-s4-amendment-ruling.json:49-56,118-127`.

## 1. Source-backed current behavior and feasibility

1. `Submit` returns a durable range, not decoded effects. It checks dedup under the writer turn and advances `chain`/`Durable` only after write/flush. The concrete agents `privateStore` exposes no byte position, read attestation or resumable reader. Sources: `internal/core/ledgerstore/commands.go:43-51,134-217`; `internal/core/ledgerstore/store.go:692-723`; `internal/core/agents/service.go:18-25`.
2. Only `!committed.Duplicate && committed.First == s.p.through+1` takes scoped direct acknowledgement. It reads the actual exact complete interval, closes the reader, then calls `acceptCommitLocked(...,&input)`. All other cases refresh and search the receipt's exact interval. Caller cancellation after Submit no longer owns completion. Sources: `internal/core/agents/scoped_execute.go:326-396`; `internal/core/agents/replay.go:277-297`.
3. `OpenReader` lists segments, freshly verifies the preceding segment's last record, and starts the containing segment at byte zero. `Reader.next` skips commits at/below After only AFTER `scanner.scan` has framed, hashed, JSON-decoded and verified them. Changing After/Through or filtering returned records cannot remove that work. Sources: `contract/ledger/reader.go:55-95,170-205`; `contract/ledger/scan.go:105-176`.
4. There is a second production caller: live review's direct installation also calls `readCommittedRange`. It must stay on its current ordinary-reader/preflighted-plan path, without a newly retained witness/authority plan or checkpoint optimization. Sources: `internal/core/agents/review_execute.go:117-145`; actual gopls references in `PM/t140-s5-lsp-production-references.md`, section `agents.readCommittedRange`.
5. The current-subject diagnostic supports this one target: 46.63 s / 62.28% of 74.87 sampled CPU in acknowledgement reading. Cumulative stacks overlap; CPU is not exact elapsed cost or proof of success. The three-per-driver S4 cohort passes both startup bounds and fails all five incremental bounds, without an extension. Those are retained failures, not candidate S5 samples. Sources: `docs/DECISIONS.md:3100-3102`; `PM/t140-s4-postdiagnostic-scope-ruling.json:6-28`; `PM/t140-s4-campaign-summary.json:1-106`.
6. **Core-only feasibility conclusion:** no safe existing-interface seek is present. Core could invent a second parser or trust draft/store metadata, but neither is authorized or preserves this proof. The smallest recommended honest expansion is the existing Reader/scanner plus agents; ledgerstore, appender and their interfaces stay unchanged. This is a source-backed design argument, not an executed feasibility experiment. Sources: `internal/core/agents/service.go:18-25`; `contract/ledger/reader.go:43-95`; `PM/t140-s4-postdiagnostic-scope-ruling.json:34-49`.

## 2. Numbered design choices and recommendation

Every unsettled choice in this brief is part of the following numbered proposals; detailed layouts/algorithms are their specified implementation, not further coder choices.

| Choice | Options considered | Recommendation and reason |
|---|---|---|
| **P1 — mechanism** | Trust a remembered chain/offset; retain a Reader; re-decode the prefix; prove the raw prefix unchanged, then reuse its previously verified chain. | Last option. An offset/hash-chain endpoint alone misses newly damaged earlier bytes; a persistent buffered Reader may serve stale bytes. Raw-prefix SHA-256 equality plus a freshly checked preceding-segment anchor permits the existing verifier to start at the exact suffix without JSON-decoding that prefix again. SHA-256 is the existing standard-library primitive, not new cryptography. Sources: `contract/ledger/reader.go:98-143`; `contract/ledger/scan.go:151-176,302-359`; `docs/DECISIONS.md:3095-3098`. |
| **P2 — public seam** | Add fields to frozen `ReadOptions`/`Commit`; add store receipts/offset methods; replace `OpenReader`; add one opt-in opener and an opaque checkpoint accessor on the existing Reader. | Last option, exactly as §3. Preserve the existing structs and all existing opener behavior. Adding exported struct fields can break unkeyed callers; a store attestation expands a second module without need. This is a proposed additive **ledger-reader** extension, NOT previously approved scope. Sources: `contract/ledger/reader.go:23-51`; `internal/core/agents/service.go:18-25`; `docs/CONTRACTS.md:11-18,26`; `docs/DECISIONS.md:3096-3098`. |
| **P3 — retention** | New Service cursor field outside accounting; per-commit offsets; a separate cache; one fixed-key entry in the existing LRU. | One entry in the existing LRU, exact-after qualified and invalidated on every accepted advance. Charge its fixed opaque value as well as existing entry overhead. No startup inventory, persistent hash state or independent allowance. Sources: `internal/core/agents/history_index.go:135-164,190-235,279-312,315-392`; `PM/t140-ruling.md:70-89,241-255`; `docs/DECISIONS.md:3098`. |
| **P4 — integration** | Enable checkpoints for every scan/review; introduce a second acknowledgement reducer; make only the scoped own-commit caller opt in and share the current reader-drain/range checks. | Last option. Keep review opt-out, all historical scans ordinary, and `acceptCommitLocked` unchanged. Publish the new hint only after that existing acceptor succeeds. Sources: `internal/core/agents/replay.go:241-297,303-459`; `internal/core/agents/scoped_execute.go:339-375`; `internal/core/agents/review_execute.go:117-145`. |
| **P5 — proof representation** | Timestamp/size/SameFile-only shortcut; caller-encoded tokens; fixed opaque arrays with self-checksum plus fresh byte equality. | Last option, exact process-memory layout below. Timestamp/size are not byte identity; opaque fields prevent ordinary callers constructing chain assertions. The self-checksum detects accidental damage, not hostile same-process forgery. Sources: `PM/t140-ruling.md:93-106`; `contract/ledger/commit.go:10-25`; `contract/ledger/segment.go:43-70`. |
| **P6 — errors/resources** | Ignore close errors as current low-level implementation does; globally change old Reader behavior; track and return actual close failures only for the new opt-in opener. | Opt-in truthful close handling, sharing existing parsers and closures. A close failure forbids checkpoint issuance and successful scoped acknowledgement. Legacy `OpenReader` callers retain current error behavior; no global compatibility change is smuggled in. Sources: `contract/ledger/reader.go:154-164,214-222`; `contract/ledger/scan.go:83-105,129-143`; `internal/core/agents/replay.go:241-259,277-297`; `docs/DECISIONS.md:3095-3097`. |
| **P7 — regression/proof surface** | Timing assertions/hit counts; a new fixture framework; real-log Reader equivalence and public scoped acknowledgement at new uncertain edges. | Last option, §7. Keep only regressions that distinguish a plausible stale-byte, anchor, range, error, publication or charge bug. New checkpoint fuzzing is justified because existing replay fuzzers cannot exercise a warm checkpoint. Sources: ticket140 `:34-43`; `PM/t140-s4-amendment-ruling.json:102-116`; `contract/ledger/fuzz_test.go:64-123`; `internal/core/agents/scoped_receipt_test.go:268-481`. |
| **P8 — compatibility/freeze disposition** | Infer approval from D155; declare any contract-file edit breaking; propose a nonbreaking opt-in addition with explicit C1 freeze-before-C3-consumption and owner gates. | Last option. The advisor must classify the Reader proof/opt-in errors, and PM must establish a source-compliant freeze-first route within the ONE allowed slice before assigning consumer code (B4). A post-hoc combined freeze is not assumed sufficient. Breaking classification or a required owner-rule exception goes separately to the owner; never reinterpret D155. Sources: `docs/DECISIONS.md:207-220,2134-2143,3095-3102`; `docs/CONTRACTS.md:11-18,26`; `docs/ROADMAPS.md:230-233`. |

## 3. Exact interfaces and algorithm

### 3.1 P2/P5: proposed exported surface — none exists today

Add to `contract/ledger/reader.go`:

```go
type ReadCheckpoint struct {
    version      uint64
    directory    [32]byte
    colony       [16]byte
    segmentFirst uint64
    offset       int64
    baseSeq      uint64
    baseHash     [32]byte
    baseTime     int64
    afterSeq     uint64
    afterHash    [32]byte
    afterTime    int64
    prefix       [32]byte
    checksum     [32]byte
}
func OpenReaderWithCheckpoint(logDir string, opts ReadOptions, checkpoint *ReadCheckpoint) (*Reader, error)
func (r *Reader) Checkpoint() *ReadCheckpoint
```

This is an opaque **read-resumption proof**, not a replay-state snapshot or persistent format. No marshal/unmarshal method, exported field, caller-supplied chain, persistent bytes, public configuration or generation identifier. `Checkpoint` returns a fresh value copy (or nil); no mutable Reader-owned state is exposed. `OpenReaderWithCheckpoint(...,nil)` performs an ordinary cold scan while collecting the next proof. Zero/invalid/stale/mismatched proof means ordinary scan, never absence or refusal. The new opener uses the same `ReadOptions`, `Next`, `Cursor`, consumption, AllTypes, numeric-bound and torn-tail rules; only numeric, advancing reads are eligible to issue/use a checkpoint. ToEnd/equal-bound reads remain ordinary and issue none. Sources for this proposed extension: P2/P5; `contract/ledger/reader.go:13-51,145-222`; `contract/ledger/doc.go:130-154`.

Exact unexported fields are listed above, in order; `version` is 1. No slices, strings, interfaces, files or pointers inside the value. This is 232 field bytes; charge **256 bytes** per retained value, conservatively including alignment. `directory` hashes the path bytes after successful `filepath.Abs` then `filepath.Clean`, without alias resolution/case folding. If absolute-path derivation is unavailable, discard the optional proof and disable capture, retaining ordinary reading and opt-in checked Close; acceleration adds no separate refusal. `prefix` hashes exact framed bytes `[0,offset)` of `SegmentName(segmentFirst)`, INCLUDING hash, TAB and LF. Hash fields are raw 32-byte forms of existing chain hashes. The self-checksum is SHA-256 of all preceding fields using fixed-width little-endian integers/arrays in listed order; never serialized to disk. Sources: P5; `contract/ledger/commit.go:10-25`; `contract/ledger/envelope.go:86-92`; `internal/core/agents/history_index.go:166-187`; `PM/t140-ruling.md:93-106`.

**Opaque provenance is essential:** hashing a caller's chosen prefix is NOT permission to assert its ending chain. Only this Reader constructs the private-field value after actual verification and successful closure; the fresh prefix digest merely proves those same verified bytes remain. Agents stores/copies that typed value, never a JSON DTO, raw bytes, reflected reconstruction or caller-constructed Chain. A zero value is only a miss. Do not add an exported constructor, unmarshaler or generic “trust this offset” seam. Detectable damage falls back before restored fields are used. These are P2/P5 provenance conditions, not a seal against unsafe same-process memory writes. Sources: `contract/ledger/scan.go:151-176,302-359`; `PM/t140-ruling.md:93-106`; `docs/DECISIONS.md:3095-3098`.

Only an opt-in Reader that has processed its numeric Through completely, observed terminal EOF, and completed **successful Close** can issue a checkpoint. Require `Cursor()==Through==scanner.v.done.Seq`, no partial commit, valid final chain, and recorded logical segment offset/hash. An error, early Close or failed closure issues nil. No token is minted from `EncodeCommit`, Submit, drafts, a receipt, file size/mtime or a caller's claim. Sources: P1/P5/P6; `contract/ledger/reader.go:170-222`; `contract/ledger/scan.go:151-176`; `internal/core/agents/replay.go:277-297`.

### 3.2 P1/P5/P6: opener and scanner algorithm

Factor the current opener into one private `openReader` implementation. `OpenReader` selects legacy mode; `OpenReaderWithCheckpoint` selects checkpoint capture and checked-close mode. Preserve existing colony/options validation, `listSegments`, containing-segment selection, fresh preceding-segment `lastRecord` verification and next-segment-name check BEFORE using any hint. Factor `lastRecord` only to share its exact last-line parser while the opt-in mode also joins its actual file-close error. Sources: `contract/ledger/reader.go:55-143`; `contract/ledger/segment.go:43-70`; P1/P2/P6.

Checkpoint eligibility requires: valid version/self-checksum/shape; exact directory and colony; `afterSeq==opts.After`; currently selected containing segment has exactly `segmentFirst`; `baseSeq==segmentFirst-1`; the freshly decoded preceding-segment Chain (Genesis for the first segment) equals all three saved base fields; positive offset and a valid complete after-chain at/after that segment's first sequence. Do not impose a new segment-size cap: segment target is writer policy, not a format limit. A boundary, rotation, changed anchor or other proof mismatch takes the ordinary start, including all ordinary corruption checks. Sources: P1/P5; `contract/ledger/reader.go:66-83,98-143`; `contract/ledger/commit.go:20-25`; `internal/core/ledgerstore/store.go:698-723`.

For an eligible hint:

1. Open the current containing segment read-only. Through a bounded **64-KiB scratch buffer**, stream exactly `[0,offset)` into a fresh standard-library SHA-256. Retain no prefix bytes. A short EOF or unequal digest invalidates the hint: close successfully, then restart the **ordinary** Reader on current files. Do not turn changed bytes directly into “corrupt”: the ordinary parser supplies the actual error or valid changed result. A genuine non-EOF I/O error or failed Close is returned, not hidden by retry/fallback.
2. Only on exact byte equality, seek that **same open file** to `offset`; propagate a seek failure. Reset its line reader there, with `lr.off=end=offset` (absolute physical offsets), and initialize the unchanged verifier with `done=cur=savedAfterChain`, empty open-commit state, and `cur Commit{}`. Bypass the segment-zero opening assertion only for this proven initial position; ordinary later segment opening is unchanged.
3. Continue the same freshly recomputed prefix hash as the scanner processes new lines. Use the existing `frameLine`, `decodeEnvelope`, `lineError` and `verifier.accept`, with existing `keep`/version checks and record-byte copies. No second envelope/group parser and no custom chain verifier.

Sources: P1/P5/P6; `contract/ledger/scan.go:105-193,287-359,373-415`; `contract/ledger/reader.go:170-205`; `contract/ledger/envelope.go:230-330`.

Capture hash input at the **logical line-consumption** point: feed each returned full framed line before its buffer is reused, including unreturned records and skipped prefix commits. Never hash via an unconstrained TeeReader around bufio: read-ahead can include bytes beyond Through. Reset the running hash and remember the prior verified Chain when a segment is opened. A checkpoint's offset is `scanner.end` after a whole commit, not `File.Seek`'s buffered physical position. Sources: P1/P5; `contract/ledger/scan.go:114-176,181-193,373-415`.

**Actual cost change:** after a warm proof passes, the raw prefix loop never calls the envelope decoder. The first decoded line is at the saved complete-commit end; the existing verifier checks the actual newly acknowledged commit against the saved, byte-revalidated chain. Cold/evicted/stale/rotated cases still decode their prefix once to establish another proof. Repeated prefix **I/O and hashing remain**; there is no O(1), scan-free or numerical-success claim. Sources: P1; `contract/ledger/reader.go:170-205`; `PM/t140-s4-postdiagnostic-scope-ruling.json:21-28`.

### 3.3 P4: exact agents cutover

Private interfaces in `replay.go`:

```go
func scanReader(ctx context.Context, r *ledger.Reader, visit func(ledger.Commit) error) (err error)
func (s *Service) readCommittedRange(ctx context.Context, first, last uint64, checkpoint *ledger.ReadCheckpoint) (ledger.Commit, *ledger.ReadCheckpoint, error)
```

`scanReader` is the existing `scan` drain loop extracted without semantic changes: check ctx between Next calls, retain visitor/read errors, and **join Close before returning**. `scan` still opens ordinary `ledger.OpenReader` and delegates; all its callers keep their current behavior. `readCommittedRange` keeps its first/last guards and exact-one-complete-commit visitor unchanged; nil checkpoint selects the ordinary opener, nonnil (including a zero value) selects the new opener. Return no commit/proof on any error. Obtain `r.Checkpoint()` only AFTER the shared drain/Close returns successfully and the exact range was found. Sources: P4/P6; `internal/core/agents/replay.go:241-297`.

At `scoped_execute.go:339-345` only, keep the existing nonduplicate/contiguous predicate. Get an exact-frontier LRU checkpoint value (zero on miss), pass its address to the new private read signature, then call the **unchanged** `acceptCommitLocked(...,&input)`. Only if acceptance succeeds, retain the returned checkpoint at the newly published `s.p.through`. A nil proof merely leaves the next call cold. Do not publish it from `readCommittedRange` or before acceptance. The duplicate/gap/prior-installation branch stays byte-for-byte equivalent. Sources: P4; `internal/core/agents/scoped_execute.go:339-375`; `internal/core/agents/replay.go:303-459`.

At `review_execute.go:123`, pass nil and discard the returned checkpoint. Preserve the preflighted plan, witness behavior, actual envelope-time floor, existing invalidation/source warming and all direct installation ordering. Update the four direct `readCommittedRange` calls in `TestScopedAcknowledgementRange` to the new signature; these ordinary-range probes pass nil. No retained alias/wrapper of the old signature. Sources: P4; `internal/core/agents/review_execute.go:117-145`; `internal/core/agents/scoped_receipt_test.go:451-481`; actual references in `PM/t140-s5-lsp-production-references.md`.

## 4. Ownership, lifetime, locking and resource bounds

**P3: one additional fixed key, not another cache.** Add `historyAckRead` to the existing history kinds and use only `{kind:historyAckRead}`. Extend `historyEntry` with an optional `*ledger.ReadCheckpoint`, copied on insertion and return; it is nonnil only for this kind, with empty `data`, `found=true`, `from=exact accepted frontier`, other range/ID/task scalars zero. Reject malformed wrappers as misses. Its own token checksum protects every opaque proof field; the existing entry checksum protects wrapper metadata. Source conventions: `internal/core/agents/history_index.go:135-187,239-312`; P3/P5.

Add private `ackCheckpoint(after uint64) *ledger.ReadCheckpoint` and `putAckCheckpoint(after uint64, checkpoint *ledger.ReadCheckpoint)` helpers. A get requires valid cache coverage, `h.through==after==entry.from`, the fixed key, valid wrapper and copied-value isolation. Put is conditional on the same exact coverage, never a late immutable-fill exception. `advance` removes that fixed key on **every accepted advance**, before publishing new coverage; this covers both refresh and direct review. Scoped acceptance then puts its freshly read proof at the new frontier. No per-sequence key or list of checkpoints. Sources: P3/P4; `internal/core/agents/history_index.go:239-312,315-392`; `internal/core/agents/replay.go:450-459`; `internal/core/agents/review_execute.go:129-136`.

Use one private retained-charge helper consistently in `put`, replacement, eviction and `removeLocked`: existing `len(data)+128`, plus **256** when a checkpoint is present. The shared totals remain **256 entries / 8 MiB**. Fixed pointer/header overhead remains separately entry-bounded; this is not an RSS guarantee. Oversize, disabled, corrupt, evicted or discarded entries produce ordinary reads, not lost state. Existing cache entries gain no extra byte allowance. Sources: P3; `internal/core/agents/history_index.go:135-164,212-235,279-312`; `PM/t140-ruling.md:70-89,241-255`; `docs/DECISIONS.md:3098`.

The scoped caller already holds `Service.mu` throughout Submit, exact read and acceptance. Copy the hint under `history.mu`, release it before directory/file I/O, and insert only after acceptance under the existing outer-before-inner order. No new mutex/goroutine/channel, lock-order inversion or unlocked mutable proof fill. The scanner/Reader remains non-concurrent and operation-local. No descriptor, bufio buffer, hash.Hash, retained commit, private/body bytes, reservation or reusable authority lives in the LRU. Sources: P3/P4; `internal/core/agents/scoped_execute.go:299-375`; `internal/core/agents/history_index.go:190-235`; `PM/t140-ruling.md:140-152`.

Each acknowledgement opens and closes its files before installation; hash scratch is at most 64 KiB, and existing record/commit buffers retain the existing 1-/16-MiB format caps. There is no newly retained file to pin Windows directories through shutdown. Service's active-operation drain and `history.close` already dispose of this one entry; Open starts with a fresh empty cache and no transferred proof. Store.Close/Recover, writer turn, lock ownership and in-flight accounting are unchanged. Sources: P3/P6; `contract/ledger/envelope.go:24-28`; `contract/ledger/scan.go:57-105`; `internal/core/agents/service.go:146-205`; `internal/core/ledgerstore/store.go:246-300,849-875`.

## 5. Authoritative provenance, error and ordering proof

| Condition | Required derivation / behavior |
|---|---|
| **Proven prefix, not asserted offset** | A token originates only in a completed, closed, verified Reader. A valid token alone is insufficient: directory/colony/After/segment/base must match, and this call must hash the exact old bytes successfully. Restore only its complete after-chain. Hence changed earlier malformed/framing/hash/format/chain bytes trigger ordinary decoding and the real error. Sources: P1/P5; `contract/ledger/scan.go:151-176,302-359`; `contract/ledger/reader.go:66-83,98-143`. |
| **Actual acknowledged bytes** | All new records are read from the current opened segment and go through the unchanged framing/envelope/verifier/version checks. Preserve gapless sequence, previous hash, colony, commit ID/index/count, record/commit caps, held-clock/time rules and numeric Through. No prepared draft, raw receipt or warm source entry stands in for them. Sources: P1/P4; `contract/ledger/scan.go:151-176,302-359`; `contract/ledger/reader.go:170-205`. |
| **Exact complete interval** | Keep `first>0`, `last>=first`, exactly one returned complete commit with equal First/Last; partial boundaries retain ErrCursor, missing/truncated history its real error, spanning commits agents.ErrInconsistent. Do not return filtered F3 subsequences. Sources: P4; `internal/core/agents/replay.go:277-297`; `internal/core/agents/scoped_receipt_test.go:451-481`. |
| **Command/family/input binding** | `acceptCommitLocked` still decodes the whole family, requires an actual scoped match with the expected CommandID, and calls `matchScopedReceipt` before planning/installing. Keep duplicate occurrence checking at/below maxCommand, all five-family decoding and schema-5 guards. Never infer global absence from this one occurrence or from UUID issuance order. Sources: `internal/core/agents/replay.go:303-339,472-480`; `internal/core/agents/history_index.go:588-647`; `PM/t140-ruling.md:127-138`. |
| **No effects before proof** | Read+exact range+successful closure precede acceptance. Existing planning stages private/scoped/review/paid/registration and shared envelope effects before any install; then existing publication order advances maxima, scratches, reviewFloor, associations/cache/source metadata and finally through. The checkpoint is stored only afterwards. A failed read, close, family binding or reducer check returns no successful receipt and takes the existing poison/error path; durable Submit itself is not rolled back. Sources: P4/P6; `internal/core/agents/replay.go:303-459`; `internal/core/agents/scoped_execute.go:353-375`. |
| **Errors stay truthful** | Preserve CorruptError/UnsupportedFormatError locations and UnsupportedVersionError fields, actual I/O/seek/context errors and joined close errors. Unconsumed payload versions are not newly checked; prefix commits skipped at/below After retain existing version semantics. A damaged acceleration proof is discarded, not itself a reason to poison valid durable state. Real authority errors never become a miss/success. Sources: P1/P5/P6; `contract/ledger/reader.go:145-205`; `contract/ledger/scan.go:287-297`; `PM/t140-ruling.md:93-106`. |
| **Duplicates/intervening work** | The outer eligibility condition is unchanged. Duplicate winners/gaps/prior installation retain refresh and exact-interval search, immutable matched receipts, changed-input conflicts and second-tail/occurrence checks. A checkpoint neither makes a grant nor proves an ID globally absent. Sources: `internal/core/agents/scoped_execute.go:339-369`; `internal/core/agents/scoped_receipt_test.go:18-241,268-350`; `internal/core/agents/history_index.go:588-647`. |
| **Authority/completion** | Preserve every preparation/final reducer/current-authority/CAS/preSubmit/reservation phase, background completion after durable Submit, consume/release holds once, private projection/materialization/disclosure fences, fresh actual object/Markdown health and Close draining. No changes to registrations' evidence-not-permission meaning. Sources: `internal/core/agents/scoped_execute.go:245-415`; `internal/core/agents/service.go:189-205`; `PM/t140-ruling.md:184-205,227-230`; `docs/CONTRACTS.md:153-155`. |

**P6 exact closure implementation:** make scanner closure retain its first actual file-close error, including automatic closure at EOF/read failure/segment transition. Opt-in mode stops on a transition-close failure and `Reader.Close` returns any retained error even after terminal EOF; repeated Close must not erase it. Join read and closure errors at the agents drain. Legacy opener keeps its current sticky Next/EOF/os.ErrClosed and Close-return behavior. Apply the same opt-in checked-close rule to the preceding-segment last-line helper and any discarded candidate file before fallback. Do not join EOF into a successful final result or allow an `errors.Is(err,io.EOF)` branch to swallow a close failure. Sources: `contract/ledger/reader.go:154-164,214-222`; `contract/ledger/scan.go:83-105,129-143`; `internal/core/agents/replay.go:241-259`; P6.

The proof assumes the same append-only live-writer protocol as the current Reader. It does not make arbitrary hostile simultaneous file rewrites atomic, attest memory against same-process adversaries, or add OS isolation. Prefix and suffix use the same open file; the old Reader likewise does not take a read snapshot/lock. No new authority policy is inferred from hashing. Sources: `contract/ledger/doc.go:130-154`; `docs/DESIGN-CORE-AND-LAUNCHERS.md:150,849-859`; `PM/t140-ruling.md:93-106`.

## 6. Owned paths, callers, contracts and gates

### 6.1 Exact proposed owned paths

| Path | Change / limit |
|---|---|
| `contract/ledger/reader.go` | P2/P5 opaque type/opener/accessor, shared opener and last-line parser, opt-in proof validation and P6 closure reporting. Existing exported signatures/ReadOptions/Commit stay intact. |
| `contract/ledger/scan.go` | P1 logical-line prefix hashing and proven initial offset; P6 retained actual close error. Existing envelope parser/verifier/tail logic stays the sole implementation. |
| `contract/ledger/doc.go` | Describe only the additive opt-in Reader contract, byte-revalidation, process-only lifetime, errors and remaining prefix hashing. No format/catalogue/record edits. |
| `contract/ledger/reader_test.go`, `contract/ledger/fuzz_test.go` | Only P7 uncertain Reader/checkpoint/error regressions and one reachable checkpoint fuzz target; reuse existing golden-copy/EncodeCommit helpers without editing fixtures. |
| `internal/core/agents/replay.go` | P4 shared drain and new exact-read signature. No family/reducer/receipt semantics changed; `acceptCommitLocked` remains unchanged. |
| `internal/core/agents/history_index.go` | P3 fixed-key kind, copied opaque value, shared charging/advance invalidation. Correct the now-obsolete “only encoded metadata” comment to name this one copied opaque proof; no JSON round-trip or second metadata schema. Preserve schema-5 command-cache guards. |
| `internal/core/agents/scoped_execute.go` | P4 opt-in at the existing contiguous own-commit branch and postaccept checkpoint publication only. |
| `internal/core/agents/review_execute.go` | Signature-only migration: nil checkpoint, discarded proof; no new review optimization or validation change. |
| `internal/core/agents/scoped_receipt_test.go`, `internal/core/agents/history_index_test.go` | P7 warmed real-store acknowledgement and discard/replacement/coverage/resource-bound outcomes; range-call signature migration. No deletion or weakening of existing rows. |
| `internal/core/agents/doc.go` | Correct existing cost paragraph `:320-340`: warm path hashes rather than decodes prefix; cold/rotated/evicted cases still decode, and cold historical costs remain. No unmeasured capacity/constant-time promise. |
| `docs/CONTRACTS.md` | Drafter/PM: record the approved additive C1 ledger-reader capability once built/evidenced/reviewed under D125, BEFORE another roadmap consumes it; retain version1/format/appender/record freezes. Freeze sequencing within D155 is the explicit unresolved B4 gate, not coder discretion. |

The path list implements only P1–P8 and the exact D155 objective; sources are the implementations cited in §§1–5, ticket140 `:26-43`, and `docs/DECISIONS.md:3095-3102`. Private decision/evidence followthrough remains the PM/drafter's existing responsibility, not coder ownership of `DECISIONS.md`. No repository edit is authorized by this artifact.

### 6.2 Actual callers and clean migration

The PM supplied actual existing-gopls references for all ten requested symbols (not guessed grep callsites): OpenReader 24; Next 25; Close 27; scan 32; refreshLocked 27; readCommittedRange 7; acceptCommitLocked 3; Submit 69; Store.Close 110; Recover 6, including declarations/tests. Complete outputs are in `PM/t140-s5-lsp-reference-digest.json`; production digest is `PM/t140-s5-lsp-production-references.md`. Counts are reported tool results, not a claim of reflection/whole-program/interface completeness.

- Migrate **both** production exact-read callers: scoped opt-in, review opt-out; migrate all four direct range-test calls. No old-signature alias.
- `scan`'s production consumers remain ordinary: integrity, paid read/state/settlement, registration query, refresh/findCommand, review sources/state, scoped budget history/state. Their drain implementation is shared, not forked.
- Existing `OpenReader`/Next/Close production consumers remain on legacy behavior: agents replay; ledgerstore `bodies.go:460`, `collect.go:268`, `commands.go:311`, `store.go:497`; workspace `activation_replay.go:316`, `service.go:185`; graph `service.go:418`. No callsite migration in those modules and no broad opt-in.
- Submit production users remain agents commands/paid_live/registration_commands/review_execute/scoped_execute. Concrete Store, Receipt, `privateStore`, restricted appender and all caller contracts remain unchanged. Do not add an interface method or make test stores implement one.

Sources: actual LSP digest above; `internal/core/agents/service.go:18-25`; `internal/core/agents/review_execute.go:117-145`; `internal/core/ledgerstore/commands.go:43-51,160-217`.

Supplemental actual gopls evidence (`PM/t140-s5-lsp-reference-supplement.json:1-146`): `lastRecord` only declaration + opener; `newScanner` declaration + Reader construction + Check; `scanner.close` declaration + Reader.Next/Close + Check + scanner.next/segment transition; `lineReader.reset` declaration + scanner.open; Reader type references are declaration/construction/methods. Preserve `newScanner` and `lineReader.reset` signatures: initialize optional capture/checked-close fields privately and set the proven absolute offset after reset. Keep Check noncapturing/legacy-close. Adapt every internal closure site for opt-in error capture; no second scanner or obsolete signature remains.

### 6.3 Explicit expansion / approval classification

| Surface | Classification and unwaived gate |
|---|---|
| Reader/scanner implementation and opt-in checkpoint | **Expansion beyond S4**, explicitly proposed here. Fresh advisor ruling must authorize P1/P2/P5/P6 and these paths before coding; D155 alone does not. |
| New `ReadCheckpoint`, `OpenReaderWithCheckpoint`, `Reader.Checkpoint` and opt-in Close-error behavior | Proposed **additive existing ledger-reader capability**, not an existing API/new contract boundary. Requires compatibility ruling and completed C1 D125 freeze/evidence BEFORE C3 consumes it. Existing old-opener behavior/structs remain. Neither classification nor sequencing is already cleared; see B2/B4. |
| C1 ownership → C3 consumption / slice count | **B4 unresolved gate.** Build only against the specifically frozen capability. No invented upfront freeze, post-hoc consumer authorization, hidden S5a/S5b/extra slice or inferred count exception. If a compliant freeze-first route cannot fit the one authorized final slice, PM must seek a separate owner decision, not send this straight to a combined coder assignment. |
| Any weakening of old Reader validation/errors, public/frozen break, format/cap/golden change | **OG-FROZEN, owner gate.** Not recommended or authorized. If the advisor classifies the proposed addition itself as breaking, ask the owner before code; list all affected registered consumers (Core C2/C3, U1.L/U1.E/field capabilities, C4–C9, R1, U3), plus actual current callers above. |
| ledgerstore/appender / record families / paid/credential/permission policy | No implementation/interface expansion; intentionally unchanged. Any newly discovered need is a blocker returned to PM/advisor, not an automatically owned path. |
| Dependency/toolchain/D52/keys/money/accounts/machine/art/`.github/` | Existing owner-reserved gates unchanged and outside this proposal. D155 cannot clear them. |

Sources: `PM/t140-s4-amendment-ruling.json:49-56`; `docs/DECISIONS.md:207-220,2134-2143,3038-3044,3067-3069,3095-3102`; `docs/CONTRACTS.md:11-18,26-27`; `docs/ROADMAPS.md:227-233`. No compatibility or owner gate may be inferred cleared from count permission, a future passing check or this recommendation.

## 7. Observable regressions, decisive proof breaks and reachability

### 7.1 P7: genuinely uncertain new boundaries

Reuse existing real-log/golden-copy and service fixtures, not a new fixture framework. Fixture-owning cases use `t.Parallel()` where isolated; no wall-time assertions, source-text checks or hit-count-only tests. Preserve four-family coverage PLUS integrated registration-family coverage, denial/money/recovery/fence rows. Sources: `ticket140:34-43`; `PM/t140-ruling.md:334-350`; `internal/core/agents/scoped_receipt_test.go:268-481`; `internal/core/agents/registration_replay_test.go:122-153`.

| Observable case / proposed test | Construction and consumer-visible oracle |
|---|---|
| **`TestReaderCheckpointContinuation`**, `reader_test.go` | Copy a small real log with multi-record commits. Obtain the checkpoint by reading through a complete numeric boundary and closing successfully; append a complete commit with `EncodeCommit`. Compare the new opener's suffix with independently opened ordinary Reader: complete commits/record bytes, cursor and errors. Include AllTypes/consumed-version distinctions and inside-commit lower/upper boundaries; not one row per private field. Sources: P1/P2/P5/P7; `contract/ledger/reader_test.go:34-201`; `contract/ledger/commit.go:34-74`. |
| **`TestReaderCheckpointChangedPrefix`**, `reader_test.go` | Warm a genuine checkpoint, then corrupt an EARLIER nonterminal prefix line, leaving the final prefix line and appended suffix untouched. Require ordinary-reader corruption class/location, not a suffix/cached success. Also mutate a correctly framed prefix to an unsupported format using existing raw-line helpers, proving fallback retains UnsupportedFormatError rather than inventing a hash-only error. Reading changes no bytes. Sources: P1/P5/P7; `contract/ledger/scan.go:151-176,287-297`; `contract/ledger/reader_test.go:203-224`. |
| **`TestReaderCheckpointAnchorAndFallback`**, `reader_test.go` | Warm inside segment2; change the correctly framed LAST record of segment1, keeping segment2's prefix byte-identical. Both readers must reject segment2's broken link. Separately rotate and prove the ordinary valid result. Wrong root/colony/After, zero/field-damaged proof and truncated-prefix cases reproduce ordinary results/errors. Damage an after-hash field without recomputing its checksum while source stays valid: lose acceleration, not introduce ErrCorrupt. Sources: P1/P2/P5/P7; `contract/ledger/reader.go:66-83,98-143`; `contract/ledger/segment.go:43-70`. |
| **`TestReaderCheckpointErrors`**, `reader_test.go` | Malformed/framing/unsupported-consumed-version suffix and premature numeric end retain ordinary typed errors/offsets. For a real close failure, read a complete numeric commit, deliberately close `r.s.f` directly in-package before terminal Next/Close, then observe `errors.Is(r.Close(),os.ErrClosed)` and nil Checkpoint. This uses actual file Close, not a fake echo. Early Close/failed read cannot issue a token. Closing the actual file before a required read supplies a real read error. Preserve sticky Next errors and retained Close failure. Sources: P6/P7; `contract/ledger/reader.go:145-222`; `contract/ledger/scan.go:83-105`. |
| **`TestScopedAcknowledgementPrefixChanged`**, `scoped_receipt_test.go` | Complete an actual scoped private write first to warm the real checkpoint; capture a baseline projection. On the NEXT write use existing `afterScopedSubmit`, close the store as the rewritten-commit regression does, and damage an early nonterminal saved-prefix line, not the new commit. Require zero successful receipt, actual ledger corruption, unchanged preaccept projection/frontier/charge after holds release, and no successful source proof from the rejected new group. Already returned Submit durability is not rolled back. Sources: P1/P4/P7; `internal/core/agents/scoped_receipt_test.go:353-448`. |
| **Existing rewritten/range/interleaving rows, warm** | Exercise `corrupt/command/submission/transition` after genuine successful acknowledgement, not solely hand-filled cache data. Preserve exact durable-receipt equality, reopen/retry, one charge, changed-input conflict, duplicate and intervening-scratch effects; exact-one-range and partial-boundary errors remain. Sources: P4/P7; `internal/core/agents/scoped_receipt_test.go:268-481`. |
| **`TestHistoryIndexAcknowledgementFallback`**, `history_index_test.go` | After genuine warming, discard/evict/disable the existing LRU or detectably damage its wrapper; the next public request and reopen/retry give the same exact durable receipt, one transition/charge and no extra hold. Use existing pressure mechanisms; auxiliary accounting may verify 256/8-MiB, never as the only oracle. Foreign and direct-review advances cannot retimestamp an older exact-after proof; observe resulting state/errors. Sources: P3/P4/P7; `internal/core/agents/history_index_test.go:367-504,596-667`; `internal/core/agents/history_index.go:279-392`. |
| **Existing lifecycle/permission/registration rows** | Retain current-authority/changed-input/foreign-principal receipts, cancellation/completion failure, projection-before-ack, same-scope wait, Close drain, schema5 independent-grant and historical-receipt behavior. No duplicated broad matrix. Sources: `internal/core/agents/scoped_receipt_test.go:18-241`; `internal/core/agents/scoped_private_service_test.go:93-158,311-495`; `internal/core/agents/recovery_test.go:166-340`; `internal/core/agents/registration_service_test.go:331-469,629-655`. |

### 7.2 Minimal decisive proof-break plan

Later isolated mutations only, never during design: cover new corruption/recovery/no-effect conditions, not performance or each field independently. Retain hashes, exact minimal diff, named observable red, byte-identical restore and green. Reuse settled S4 binding/reducer coverage; no old mutation campaign to recertify 8a17. Sources: `docs/DECISIONS.md:3032-3034,3101`; `PM/t140-s4-amendment-ruling.json:112-116`; `PM/t140-s4-review-subject.json:266-374`.

1. **Prefix identity:** omit only the raw-prefix digest equality decision. `TestScopedAcknowledgementPrefixChanged` must turn red by acknowledging/installing a suffix despite earlier corruption. Keeping the old prefix's last line unchanged prevents the suffix verifier masking this bug.
2. **Fresh predecessor:** omit only saved-base versus freshly decoded predecessor Chain equality. `TestReaderCheckpointAnchorAndFallback` must turn red by returning the suffix that ordinary reading rejects; the current prefix stays byte-identical.
3. **Damaged opaque proof:** bypass only checkpoint self-checksum validation. The valid-source/damaged-after-hash case must turn red by reporting spurious authoritative corruption instead of falling back successfully. No recomputed “valid” forged token.
4. **Closure barrier:** omit only the opt-in retained Close error return. `TestReaderCheckpointErrors` must turn red because the real Close failure is no longer reported. Its separate nil-checkpoint assertion may remain protected by retained error state; report that masking honestly. The application proof remains that exact-read return, including Close, precedes acceptance. Do not create a mock-echo test or another mutation campaign merely to force every barrier red.

Existing warmed tests retain independent range/command/family/digest/reducer/one-charge oracles. Premature proof publication and LRU invalidation can be defense-in-depth: token After versus the service's old frontier may mask a premature put. Report such survivors and masking barriers; no internal-only assertion or combined feature-building mutant to force red. Any newly relied-on condition lacking decisive observable coverage is a review question, not a passing proof claim. Sources: P4/P7; `internal/core/agents/replay.go:303-459`; `internal/core/agents/scoped_execute.go:339-375`; `PM/t140-s4-amendment-ruling.json:112-116`.

### 7.3 Reachable fuzz paths, not package membership

Add **`FuzzReaderCheckpoint`** in `contract/ledger/fuzz_test.go` for uncertain skip/restore equivalence: one small prepared multi-commit/multisegment fixture per worker, genuine minted checkpoint, then bounded prefix/suffix mutations/cuts or accidental token damage. Compare complete suffix/cursor or typed error class/location with ordinary reading. Seed commit/line/segment boundaries, changed predecessor, correctly hashed malformed envelope and consumed-version boundary. No per-input Git/store construction or timing assertions. Sources: P7; `contract/ledger/fuzz_test.go:15-123`; `contract/ledger/reader_test.go:34-224`.

| Target | Actual reach and limitation |
|---|---|
| New `FuzzReaderCheckpoint` | Direct warm prefix identity, anchor/eligibility, chain restoration, fallback and opt-in closure. Existing group fuzzers cannot substitute for it. |
| `FuzzCheckTruncation`, `FuzzCheckTornTail`, `FuzzCheckCorruption` | Check/ordinary Reader reach changed scan/open/close/lineReader helpers. Protect legacy/tail behavior, not warm checkpoints. Sources: `contract/ledger/fuzz_test.go:64-228`; supplemental actual LSP references. |
| `FuzzScopedGroupReplay` | Accepted inputs use actual Submit → Open → refresh/scan/shared drain and source-warming/history charging. Mutation preflight alone does not execute live acknowledgement. Source: `internal/core/agents/scoped_replay_test.go:540-651`. |
| `FuzzReviewGroupReplay`, `FuzzPaidGroupReplay` | Accepted-input store/Open reaches changed drain/scanner/container, not the warm scoped path. Sources: `internal/core/agents/review_fuzz_test.go:85-130`; `internal/core/agents/paid_fuzz_test.go:89-125`. |
| `FuzzRegistrationGroupReplay` | Integrated139 accepted-input store/Open and exact receipt queries reach scan/drain. Assess due to that path, not package membership. Source: `internal/core/agents/registration_fuzz_test.go:100-160`. |
| `FuzzPrivateGroupReplay` | Its in-memory decodeGroup/planGroup/install does NOT execute Reader, drain, history put/advance or live acknowledgement. Exclude unless final changes actually reach its exercised code. Source: `internal/core/agents/replay_fuzz_test.go:14-127`. |

PM selects/records final serial **120-second** campaigns against the actual final diff and these paths: every new target and target whose fuzzed code actually changed, preserving failing inputs/executions/results/limits. No unrelated codec/provider campaigns or default local full tools/check. Sources: `PM/t140-ruling.md:334-350`; `PM/t140-s4-amendment-ruling.json:113-116`; `docs/DECISIONS.md:3032,3059-3066`.

## 8. D152 focused evidence and unchanged final numerical protocol

### 8.1 Later focused evidence — no designer command execution

Coder/PM execute serially only after fresh ruling, applicable owner/freeze gates and machine release. Approved go1.27.3; `GOTOOLCHAIN=local`, empty `GOFLAGS`, ordinary `CGO_ENABLED=0`. LRU charging/value/invalidation changes shared state, so **agents** meets D152's local race condition. Reader/scanner remains non-concurrent with no shared globals: no separate local ledger race/×20 unless final implementation actually changes shared state there. No proposed build-constrained edits, hence no local five-target static loop. Sources: `docs/DECISIONS.md:3032,3038-3044,3059-3066`; `PM/t140-ruling.md:334-350`; `contract/ledger/reader.go:46-47`; `internal/core/agents/history_index.go:190-200`.

Future commands from the assigned coder worktree's module root, not this read-only canonical checkout:

```text
go test -count=1 -timeout 19m -v ./contract/ledger -run '^(TestReader.*|TestReadingHasNoEffects|TestGolden.*)$'
go test -count=1 -timeout 19m -v ./internal/core/agents -run '^(TestScopedAcknowledgement.*|TestScopedReceiptsAndLostAck|TestHistoryIndexAcknowledgementFallback)$'
go test -count=1 -timeout 19m -v ./contract/ledger
go test -count=1 -timeout 19m -v ./internal/core/agents
go vet ./contract/ledger ./internal/core/agents
go tool staticcheck ./contract/ledger ./internal/core/agents
go list -f '{{join .Imports "\n"}}' ./contract/ledger ./internal/core/agents
go list -f '{{join .TestImports "\n"}}' ./contract/ledger ./internal/core/agents
go list -deps -f '{{if not .Standard}}{{.ImportPath}}{{end}}' ./contract/ledger
go mod tidy -diff
go mod verify
```

Host `gofmt` only changed Go files; `gofmt -l` that exact list. Retain final changed-file SHA-256s, command/exit/raw output, verbose timings and real failure/correction. Contract stays standard-library-only; agents adds no new nonstandard import. No golden regeneration: existing goldens unchanged plus retained fixture digest evidence for the additive-reader freeze. Unchanged ledgerstore/workspace/graph consumers receive exact-SHA hosted coverage, not additional routine local package runs. Sources: `docs/DECISIONS.md:122-132,258-295,3032,3059-3066`; `docs/CONTRACTS.md:5-18`; `PM/t140-ruling.md:334-350`.

For agents local race, existing `CGO_ENABLED=1`, `CC=C:/Users/darius.jones/AppData/Local/Programs/llvm-mingw-20260922-ucrt-x86_64/bin/x86_64-w64-mingw32-clang.exe`; other work stays CGO0:

```text
go test -race -count=1 -timeout 29m -v ./internal/core/agents
go test -race -count=20 -timeout 45m -v ./internal/core/agents -run '^(TestScopedAcknowledgementInterleaving|TestHistoryIndexLookupRace|TestPrivateCurrentHeadProjectionFence|TestPrivateCloseDrainsOperations|TestScopedProjectionBeforeAckAndIndependentPreparation)$'
```

Launcher deadlines: 1200s focused/plain, 1800s whole-package race, 2800s ×20. No timeout changes to conceal cost. The ×20 list contains only affected cache/ack/fence/drain concurrency rows; add only a genuinely new concurrency contract, not isolated corruption rows by default. PM owns timed fuzz. Sources: `PM/t140-ruling.md:334-350`; `PM/t140-s4-amendment-ruling.json:113-116`; `internal/core/agents/history_index_test.go:596-667`; `internal/core/agents/recovery_test.go:297-340`; `internal/core/agents/scoped_private_service_test.go:93-158,311-495`.

### 8.2 Real program smoke, no extra diagnostic

The PM's **first complete unchanged T11 final-candidate program run** also supplies the public/program smoke after the final product edit: real store/agents operations and all original correctness assertions, exact new SHA/source/product hashes, command, exit and actual phase/request/receipt/frontier output retained. If eligible it is instance1 of the SAME final cohort, not an extra shortened/modified run; if invalid retain/label/replace under existing rules. A build or parser test is not this smoke. No preimplementation profile/smoke/load gate, extra diagnostic or CPU-share SLA. Sources: `PM/t140-ruling.md:354-397,444-449`; `PM/t140-endpoint-addendum.md:21-37`; `PM/t140-s4-amendment-ruling.json:119-127`; `docs/DECISIONS.md:3100-3102`.

The programs remain:

```text
go run ./_t140_t11_measure -out <fresh-absolute-output-and-colony-directory>
go run ./_t140_t12_measure -profiles <fresh-absolute-profile-directory>
```

PM-owned untracked saved-source packages under the actual candidate module root; `GOTOOLCHAIN=local`, `GOFLAGS=`, `CGO_ENABLED=0`, `GOOS=windows`, `GOARCH=amd64`. All **six original saved source hashes** remain, including T12's approved label-only version. Subject is the actual final combined SHA, never a temporary mutant/earlier S4 SHA/pure140 label for a combined build. A later product edit needs changed-subject smoke/cohort proof, retaining earlier evidence. Sources: `PM/t140-ruling.md:354-405`; `PM/t140-s4-amendment-ruling.json:119-126`; `PM/t140-s4-campaign-summary.json:107-148`.

### 8.3 Unchanged seven-bound final protocol

- **Controls:** eligible `93e8f0afe125b1ea8e87f4b8336664dd390c5b3a` controls remain reusable with unchanged documented machine/toolchain/environment/driver/method. Time passing/integrated139 alone does not require repeats; material method/environment change requires an explicitly comparable replacement, retaining old evidence. Source: `PM/t140-s4-amendment-ruling.json:119`.
- **New cohort:** three independent complete eligible instances **per driver** on actual new SHA. No mixing earlier failed S3/S4/diagnostic runs; retain all. Sources: `PM/t140-s4-amendment-ruling.json:120-127`; `docs/DECISIONS.md:3100-3102`.
- **T11 traffic/endpoints:** populations12→20, held turns1→3, synchronized burst16, every original phase/assertion and complete ten-operation cycles. B = commits immediately before smoke_log profile; run profile/cleanup, complete original cycles while commits < B×10, then long_log immediately. No fixed 87/874/cycle count/forced outcomes/special range/dropped operation/shortened history. Retain B/cycles/burst outcomes and actual commit/record frontiers. Source: `PM/t140-endpoint-addendum.md:21-37`.
- **Two startup bounds:** independently T11/T12, `R_i=actual long Open records / actual short Open records`; `median(OpenLong_i/R_i) <= median(OpenShort_i)`. Use agents.Open, report store.Open separately; post-profile records stay separate. Sources: `PM/t140-ruling.md:375-420`; `PM/t140-s4-amendment-ruling.json:122`.
- **Five operation bounds:** turn.start, local.admit, local.begin, task.create, task.cancel each: `median(long) <= 2*median(short)+25ms`. Cancel uses paired **profile_cleanup** rows after each profile. New subject's own short medians and single profiled-operation samples across independent runs; not aggregate p50/p95, failed-subject bounds or base times. Sources: `PM/t140-ruling.md:375-397`; `PM/t140-s4-amendment-ruling.json:122`.
- **T12:** unchanged S5 factor2/populations12,20/four CPU profiles; report actual H/N/G, terminal grants/scopes, review/request/approve/failure and first/repeated old lookups at both lengths. No factor10 requirement/new latency SLA. Reenactment probes are not production-cache measurements; “cold” means first query after reopen, not OS-cache/LRU-miss proof. Source: `PM/t140-ruling.md:399-420`.
- **Eligibility:** fresh output/colonies, serial local runs/no competing Go/check/test/fuzz/measurement; five-second pre/post unrelated CPU ≤0.25core each. Postpone ineligible starts, retain and replace interrupted/overlapped/post-ineligible attempts. Slowness alone is not exclusion. Sources: `PM/t140-ruling.md:422-441`; `PM/t140-s4-amendment-ruling.json:123`.
- **Exactly 3 or 5:** after3, paired differences straddle zero **and** median lies within10% of bound → exactly2 more COMPLETE runs of that driver, once, decide on all5. Differences `long/R-short`, `long-(2*short+25ms)`. Sampling trigger, never slack. Clear failure/still failing after5 fails; missing/refused/inconsistent samples fail, never zero. Sources: `PM/t140-ruling.md:422-442`; `PM/t140-endpoint-addendum.md:29-37`.
- **Report/stop:** raw commands/environments/statuses, all attempts/hashes/finalSHA/profiles/frontiers; agents.Open/store.Open separately, time/record, normalized growth/two-point exponents. Preserve **admission and storage only**/bookkeeping labels; no capacity/provider/executor/delivery/power-loss/SLA claim. All semantic, ordinary-history-scan and inherited S5 check-order gates remain. Failure retains evidence/stops; **no sixth slice**, cache/snapshot enlargement, workload/bound change or extra diagnostic implied. Sources: `PM/t140-ruling.md:416-449`; `PM/t140-s4-amendment-ruling.json:125-127`; `docs/DECISIONS.md:3098-3102`.

### 8.4 Completion/publication

Fresh independent code/evidence review and exact-final-SHA D153 Windows/Linux/macOS full matrix, race and `Check result` precede ff-only main/publication. Fix/rebase requires its own run/evidence. No routine local full tools/check, including this final slice. P8/B4 requires a ruled, source-compliant **C1 freeze-before-C3-consumption** route; joint approval of a completed capability cannot retroactively authorize earlier consumer development. A breaking classification or required owner-rule exception waits for the owner. Fable whole-ticket verification/close remain separate; tests/one good timing do not close140. Sources: `docs/DECISIONS.md:2134-2143,3032-3044,3057-3077,3101-3102`; `docs/CONTRACTS.md:11-18`; `docs/ROADMAPS.md:227-233`.

After actual smoke/cohort proof, preserve source/output/hashes and remove only PM-owned throwaway driver packages before final hosted verification; finish accurate cost/freeze/evidence docs under the existing public/private split. This designer performs no repository cleanup/deletion. Sources: `PM/t140-ruling.md:444-449`; `docs/DECISIONS.md:3102`.

## 9. Rejected alternatives and specific blocking questions

### 9.1 Rejected alternatives

1. **After/Through/filter-only:** scanner still decodes prefix commits before applying After; no objective achieved. Source: `contract/ledger/reader.go:170-205`.
2. **Prepared drafts/Submit range as effects:** no actual-byte/complete-group/binding/error proof; explicitly prohibited. Sources: `internal/core/agents/replay.go:277-339`; `docs/DECISIONS.md:3095`.
3. **Chain+offset/size/mtime/writer-attested bytes alone:** hides earlier prefix corruption. A final hash does not revalidate newly changed earlier bytes. No store attestation exists; inventing one also expands store/recovery/receipt/Close scope. Sources: `contract/ledger/reader.go:66-95`; `internal/core/agents/service.go:18-25`; `internal/core/ledgerstore/store.go:246-300`; P1/P2/P5.
4. **Persistent buffered Reader:** lifetime/resource/stale-read risks; numeric Through/errors are final, not an existing Extend interface. S4 excluded it. Sources: `contract/ledger/reader.go:145-164,214-222`; `PM/t140-s4-amendment-ruling.json:49-56`; P1/P2.
5. **Core alternate parser/backward LF/JSON search:** duplicates format/commit/time/corruption machinery and does not prove the skipped prefix. Reuse the existing scanner. Sources: `contract/ledger/envelope.go:230-330`; `contract/ledger/scan.go:105-176,302-359`; P1/P2.
6. **JSON/DTO checkpoint/raw arbitrary chain+digest struct:** loses opaque private fields/provenance or lets a claimed digest masquerade as Reader-minted state. Fixed typed copied value/exact shared charge instead. Sources: `PM/t140-ruling.md:70-106`; P3/P5; §3.1.
7. **Per-commit offset/digest catalogue/larger cache/snapshot/lifetime inventory/general command/authority/startup optimization:** outside the single measured objective/D155. ONE discardable entry is not an inventory; miss goes ordinary. Sources: `docs/DECISIONS.md:3095-3102`; `PM/t140-s4-postdiagnostic-scope-ruling.json:34-49`; P1/P3.

### 9.2 Specific blocking questions for fresh ruling

**B1 — perimeter:** approve/reject P1–P7's exact Reader/scanner expansion and one charged opaque position, including fresh entire-prefix hash and preceding-segment Chain equality before restoration. Excluded from S4; D155/this brief do not authorize code. No ledgerstore expansion is required.

**B2 — compatibility:** is the opt-in surface, unchanged old opener and truthful opt-in Close reporting an additive existing ledger-reader capability under D40/D125? If frozen “verifying every record it reads” prohibits byte-identical previously verified prefix reuse even through a new opt-in interface, or opt-in errors are breaking, this is **OG-FROZEN**: separate owner approval identifying consumers BEFORE code. Do not silently weaken old Reader behavior. Nonbreaking classification alone does not clear B4.

**B3 — proof sufficiency:** rule on opaque Reader-minted provenance, actual Close/error behavior and decisive red/restore cases in §7. This is a concrete source-level proof, not executed feasibility/runtime evidence. Any rejection must identify the failed premise, not tell a coder to invent another interface/parser.

**B4 — C1 freeze/consumption sequencing within the one slice:** the register makes C1 the Reader owner; another roadmap builds only after its specifically needed capability is frozen, and D125 freezes a completed/evidenced/reviewed contract slice, not an unimplemented promise (`docs/CONTRACTS.md:11-18,26`; `docs/ROADMAPS.md:230-233`; `docs/DECISIONS.md:2134-2143`). PM/advisor must establish the permitted freeze-first route BEFORE assigning C3 consumption. This brief does not infer that one post-hoc joint freeze clears that rule, nor that C1 expansion buys another slice. If no compliant route fits D155's single final slice, return that exact blocker to the owner for a separate decision; do not name the work S5a/S5b or code around it.

These are approval/proof questions, not a placeholder algorithm. Exact interfaces, bounded representation, lifetime, fallback and migration are specified. No inaccessible source/CLI fact blocks submission; runtime correctness and all seven figures remain unproven until implementation/evidence. Sources: `docs/DECISIONS.md:207-220,2134-2143,3095-3102`; `contract/ledger/doc.go:130-154`; `PM/t140-s4-postdiagnostic-scope-ruling.json:34-49`.

**Designer actions:** canonical source/assigned-record/PM-gopls reads only; wrote this parent-local brief and bounded coordination requests. No repository edit, command/test/build/lint/format/profile/native diagnostic, Git operation or subagent. Settled 8a17 checks were not rerun or re-audited.
