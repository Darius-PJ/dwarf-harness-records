# Ticket140 S5 — C1 Reader source handback

## Status and authority

C1 source implementation is complete and frozen for PM formatting, execution, review and integration. This is the first milestone within the ONE bounded fifth-and-final assignment, not another slice. No C3 consumer implementation or new-API consumer tests were written. C3 remains hard-blocked until the PM records the independently completed/evidenced/reviewed D125 C1 freeze, its own exact-SHA successful full Windows/Linux/macOS/race/Check result, public main integration/publication and private binding.

- Worktree: `C:/Users/darius.jones/worktrees/dwarf-harness/140-final-ack`
- Branch: `build/140-final-ack`
- Assigned integrated base: `84d0ced9446168777c7b7bfa3382974977bf27ed`
- Actual D156 publication: `b63d618c76b864ec08855bd78eadcf3e27cf7588`
- Complete original312-line brief read: `t140-s5-design-brief.md`, bound SHA256 `93bf8a13f847d03626672caae2a77f35e97ddfcc968b63568dd4ea12bc81cc55`.
- Complete actual445-line ruling read: `t140-s5-design-ruling.json`, bound SHA256 `ef2dfa6612bf2114dcb3229d474d841389df749d868fdb1dfb9bfb36ca702611`, plus binding, ruled authority, publication receipt and actual D156 lines3104–3116.
- The original ruling's B4/OG-SEQUENCE false state was at issuance. Actual later D156 supplies precisely the sequencing prerequisite, not code approval or a completed freeze. P7 uses the Reader-level prefix oracle below before C3 exists.

**No executed Go proof is claimed.** No native command, build, formatter, lint, test, timed fuzz, mutant, Git command or Git write was run by this coder. Existing gopls was used as authorized. No command or source writer remains running. After the source-freeze message, only this report was written.

## Changed paths and exact pre-format identity

Only the following five worktree files changed. No fixture, format, catalogue, schema, module, toolchain, workflow, ledgerstore, other consumer, public register or private authority file was edited. No existing test or row was deleted or renamed.

The PM captured these actual byte counts/SHA256s in-process, without native commands or modification, after source freeze. Canonical receipt:

`C:/Users/darius.jones/.omp/agent/sessions/-Documents-PROJECTS-dwarf-harness/2026-10-24T15-58-31-752Z_01a16ea2-9748-77b3-ac90-a8beabd7bc22/local/t140-s5-c1-preformat-manifest.json`

Receipt time: `2026-10-29T16:22:28.610012-04:00`. These identify the frozen **pre-format** bytes, not a future commit or post-format manifest. Every file has zero CR bytes.

| Path | Bytes | SHA256 |
|---|---:|---|
| `contract/ledger/reader.go` | 13250 | `7dbfaf4675dca0f762e5fc351cbe5f5d410128e76c913c9795630bbd43f38104` |
| `contract/ledger/scan.go` | 13675 | `94652a4384242aba11592beb8667cf65a90865ac3fdbfad60297bedb9732e1cb` |
| `contract/ledger/doc.go` | 171531 | `b078d7f534f5ebfd7fcb1c08d518a8c3e355abb8709e649ae9aef2c9993c29eb` |
| `contract/ledger/reader_test.go` | 23797 | `710772f66538aac26444f1ae4661d6df1f683f5a23d1a68336a7551bdad1e28d` |
| `contract/ledger/fuzz_test.go` | 20854 | `7b5c0fac7138c779ac41e5f42a9deb5ef9274bd7c462b28ee45df545734f9488` |

### Implementation/factoring

- `reader.go`: exact13-field private fixed-width `ReadCheckpoint`, in the ruled order, version1; a SHA256 self-checksum over the preceding200 bytes using explicit fixed-width little-endian integers/arrays. No token-held strings, slices, interfaces, pointers or resources, constructor, serialization or raw-token import.
- Adds precisely `OpenReaderWithCheckpoint(logDir string, opts ReadOptions, checkpoint *ReadCheckpoint) (*Reader, error)` and `(*Reader).Checkpoint() *ReadCheckpoint`.
- A shared private `openReader` retains existing option validation, segment listing/selection, predecessor last-record parsing and segment-name checks before checkpoint matching. Optional identity is SHA256 of successful `Abs` then `Clean`, without alias or case folding. Identity failure disables capture/use only; checked closure remains enabled.
- `ReadCheckpoint.matches` checks version, checksum, shape, numeric advancing bounds, exact After, directory, colony, selected segment, all fresh base-chain fields and valid complete after-chain shape. Missing/damaged/mismatched hints select ordinary checked-close reading.
- `scanner.restore` opens the selected candidate through the existing opening checks, hashes exactly `[0,offset)` using `io.LimitReader` and a64KiB scratch buffer, checks complete length and digest equality, then seeks/resets that SAME descriptor at the absolute logical offset. It restores only the complete after-chain with an empty open commit; the segment base remains the freshly checked predecessor. A short or changed candidate closes successfully before a fresh ordinary opener re-lists/rechecks. Actual read, seek or candidate-close errors propagate.
- `scan.go`: optional running prefix hash is fed complete framed lines at logical consumption, before buffer reuse, not at bufio read-ahead. Each segment resets prefix state and captures the prior verified chain as its base. Existing frame/decode/lineError/verifier/keep/version/torn-tail paths remain the only parser/verifier.
- `scanner.close` now returns and retains the first actual failure only when opt-in checked-close mode is enabled. All automatic-error/EOF, transition, explicit/repeated-close and discarded-candidate sites consume it. A transition stops before opening another segment after close failure. `lastRecord` shares its unchanged parser and conditionally joins actual descriptor-close errors. `readCloseError` replaces bare EOF with the close error rather than producing an EOF-containing success trap, and preserves/joins real read errors without repeatedly joining the same retained failure.
- `Checkpoint` constructs a new value only for opt-in eligible reads after terminal EOF and successful actual closure, matching cursor/Through/done sequence, a valid final/base chain, no open commit and a positive exact logical end. Early Close, ToEnd, equal bounds, read/close errors and partial commits cannot mint one.
- Existing `ReadOptions`, `Commit`, `OpenReader`, `Check`, `Next`, `Cursor`, `Close`, `newScanner` construction and `lineReader.reset` public/required signatures remain. No legacy caller opts in. Legacy scanner closure still returns nil, so old Reader/Check error behavior is retained by the shared implementation.
- `doc.go`: additive factual API/lifetime/fallback/close documentation only. No new freeze/status convention, private authority quotation, performance result, O(1), scan-free, snapshot, hostile-rewrite atomicity or same-process security claim. Prefix I/O and SHA256 remain.

## Named behavioral proof source — written, NOT executed

`assertCheckpointRead` independently opens the ordinary reader and opt-in reader, compares exact complete commits and record bytes, cursor, typed corruption/format/version fields and locations or cursor/invalid classes, and snapshots files before/after. It does not compare error wording. `readWithCheckpoint` joins actual Close before retrieving the proof and treats only bare EOF as normal termination. Setup uses genuine Reader-minted checkpoints, existing golden-copy/buildLog/EncodeCommit/rehash helpers and real files.

| Test | Consumer-visible oracle encoded in source |
|---|---|
| `TestReaderCheckpointContinuation` | Genuine sequential checkpoints at1/3/4/6, then two appended multi-record warm continuations in segment2 against ordinary reading. Current consumed-version checks, AllTypes/unconsumed versions, skipped-prefix versions, skipped commits/cursor, inside-commit lower/upper bounds, equal/reversed bounds and ToEnd. A70KiB-prefix row crosses line/hash scratch buffering. Returned checkpoint copies cannot alias mutable storage; the unaffected copy continues correctly. |
| `TestReaderCheckpointChangedPrefix/framing` | Corrupt seq1 while final prefix line3 and suffix4 remain untouched. The warmed reader must match ordinary corruption at segment1 offset0, not return the suffix. |
| `TestReaderCheckpointChangedPrefix/unsupported_format` | Correctly rehash an earlier nonterminal prefix line with format2; retain the final prefix/suffix. Must return the same located UnsupportedFormatError rather than hash-only refusal or cached success. |
| `TestReaderCheckpointAnchorAndFallback/changed_predecessor` | Mint through6 in segment2, append7–8, then correctly rehash predecessor segment1's LAST record4 by changing its payload WITHOUT changing seq4. Segment2 prefix remains identical. The ordinary and checkpoint readers must reject the link at segment2 offset0. The segment-name continuity check does not mask base equality. |
| `TestReaderCheckpointAnchorAndFallback/damaged_afterHash` | Valid source and a genuinely minted token whose afterHash is damaged WITHOUT recomputing checksum. Must fall back to the successful ordinary result rather than invent authoritative suffix corruption. |
| Remaining `TestReaderCheckpointAnchorAndFallback` rows | Rotation, short saved prefix, missing final segment, wrong root/colony/After, nil and zero hints reproduce exact ordinary outcomes; valid fallbacks can mint a replacement. |
| `TestReaderCheckpointErrors` suffix rows | Bad framing, correctly hashed malformed envelope, unsupported format, unsupported consumed version, short numeric end and incomplete commit preserve ordinary commits/cursor/typed errors/absolute locations and issue no proof. |
| `TestReaderCheckpointErrors/numeric_EOF_close_failure` | Read a complete numeric commit, deliberately close the actual `r.s.f` OS descriptor before terminal Next. Next must not report EOF success, Close and repeated Close must expose the retained actual os.ErrClosed failure, terminal errors stay sticky, no proof may be minted. |
| Other `TestReaderCheckpointErrors` closure rows | Early Close, explicit actual close failure, actual required-read plus actual close failure, corruption plus close failure, and unchanged legacy EOF/Close behavior under the same descriptor fault. The real read row asserts an actual `*os.PathError` with operation `read`; the corruption row retains ErrCorrupt while exposing actual Close failure. No mocked file/echo hook supplies these failures. |
| `TestReadingHasNoEffects` | Existing legacy Check/Reader torn-tail assertions retained. Adds opt-in ToEnd equivalence/no-checkpoint and retains whole-directory no-write/no-truncate verification. |

Independent fixture-owning new rows use `t.Parallel`; rows sharing the same read-only continuation fixture remain within that fixture. Existing tests were not removed, renamed or weakened.

### Four EXACT minimal proof-break proposals

These are **unapplied/unrun proposals**, not observed reds. Apply each separately to a disposable frozen-source subject, retain its exact diff and source hashes, run the named oracle, restore byte-identically and retain the green. Compiler errors, timeouts, unrelated failures and survivors do not count. The snippets identify function-scoped unique sites; no line-number dependence on subsequent gofmt.

#### M1 — omit fresh prefix digest equality

File: `contract/ledger/scan.go`, `(*scanner).restore`.

```diff
- if n != p.offset || prefix != p.prefix {
+ if n != p.offset {
```

Oracle: `TestReaderCheckpointChangedPrefix/framing` (the unsupported-format row is a second semantic observation, not another mutant).

Future focused command:

```text
GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -timeout 19m -v ./contract/ledger -run '^TestReaderCheckpointChangedPrefix$/^framing$'
```

Expected red [INFERENCE]: the same-length corrupt prefix passes the mutated restoration and suffix4 succeeds, while the independent ordinary Reader reports corruption at seq1. Final prefix line3 remains intact, so suffix verification does not mask omission. The local `prefix` variable remains used by `Sum`; this patch does not deliberately create a compile failure.

#### M2 — omit fresh predecessor/base equality

File: `contract/ledger/reader.go`, `(*ReadCheckpoint).matches`.

```diff
- if p.baseChain() != base {
+ if false {
```

Oracle: `TestReaderCheckpointAnchorAndFallback/changed_predecessor`.

```text
GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -timeout 19m -v ./contract/ledger -run '^TestReaderCheckpointAnchorAndFallback$/^changed_predecessor$'
```

Expected red [INFERENCE]: saved after6 and unchanged segment2 prefix permit suffix7–8, while ordinary reading rejects segment2's first link. The modified predecessor retains seq4, its format/framing/colony/commit boundary remain valid, and the segment name still starts at5; segment-name validation cannot mask the removed equality.

#### M3 — omit token self-checksum validation

File: `contract/ledger/reader.go`, `(*ReadCheckpoint).matches`.

```diff
- if p == nil || p.version != 1 || p.checksum != p.sum() {
+ if p == nil || p.version != 1 {
```

Oracle: `TestReaderCheckpointAnchorAndFallback/damaged_afterHash`.

```text
GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -timeout 19m -v ./contract/ledger -run '^TestReaderCheckpointAnchorAndFallback$/^damaged_afterHash$'
```

Expected red [INFERENCE]: unchanged valid bytes and a valid-shaped but accidentally damaged ending hash enter restoration, causing spurious suffix corruption rather than the ordinary successful7–8 result. No checksum is recomputed or fabricated token provenance asserted.

#### M4 — omit retained opt-in Close-error return

File: `contract/ledger/reader.go`, `(*Reader).Close`, ONLY the return within `if r.s.checkedClose`.

```diff
  if r.s.checkedClose {
      r.err = readCloseError(r.err, closeErr)
-     return closeErr
+     return nil
  }
```

Oracle: `TestReaderCheckpointErrors/numeric_EOF_close_failure`.

```text
GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -timeout 19m -v ./contract/ledger -run '^TestReaderCheckpointErrors$/^numeric_EOF_close_failure$'
```

Expected red [INFERENCE]: explicit/repeated Close loses the actual descriptor-close failure. Honest masking limit: Next still retains its failure and `Checkpoint` still rejects `s.closeErr`; this mutant is not expected to make the nil-checkpoint assertion fail or establish a C3 acknowledgement failure. It independently breaks the promised Close return. No compound mutation/internal-only oracle is proposed.

## Fuzz reachability and limits

- **New `FuzzReaderCheckpoint`:** one small multi-commit/two-segment encoded fixture per worker, reusable directories, genuine completed checkpoints through3 and6 before mutation. Modes0/1 have unchanged warm continuations, so the seed corpus does not depend solely on hints rejected before restoration. Bounded modes cover a single framed-byte flip, cuts, correctly hashed malformed/unsupported envelopes, changed predecessor with preserved sequence, accidental token damage without recalculating checksum, changed root/colony/After/Through/consumption, and nil/zero hints. Seeds include line/TAB/LF, commit and segment boundaries, neighboring cuts, predecessor, afterHash and consumed-version cases. Every execution compares against an independently opened ordinary Reader via the semantic/no-effects oracle. No per-input Git/store construction or timing assertion.
- **`FuzzCheckTruncation`:** Check plus ordinary Reader reaches the changed scanner/open/close/line-reader machinery in legacy mode, not the warm checkpoint seam.
- **`FuzzCheckTornTail`:** Check reaches changed shared scanner/open/close paths and retained torn-tail handling, not warm restoration.
- **`FuzzCheckCorruption`:** Check reaches the changed legacy scanner paths with corruption, not warm restoration.
- The new fuzzer reaches normal opt-in checked closure; byte/token mutations alone do **not** prove an actual descriptor-close failure. That proof belongs to the real-descriptor regression above.
- No C3 fuzzer claim is made. Core source is unchanged; its later campaigns remain behind the integrated-freeze barrier. No package-membership-only campaign or `FuzzPrivateGroupReplay` claim.

## Tool activity actually observed

- Registered this worktree once with existing gopls via `workspace/didChangeWorkspaceFolders`, routed through MAIN Reader as assigned: returned null.
- Actual pre-edit worktree references: OpenReader25, Reader7, Next26, Close28, lastRecord2, scanner.close6. Read the supplied reference digest/supplement/options evidence; no consumer signature migration was required.
- Used gopls import quick-fixes for standard-library `encoding/binary`, `encoding/hex`, `errors`, `hash` and test `bytes`. No formatter or organize-imports command was run.
- One attempted helper definition query used the wrong source line and returned `Symbol sampleDraft not found on line331`; no edit relied on it. Existing helper/source conventions and subsequent diagnostics supplied the necessary source information.
- Explicit gopls diagnostics returned `OK` for all five changed files. Initial edit diagnostics identified the missing `bytes` import; its listed quick-fix was applied before the final test diagnostics returned OK.
- LSP is source/tool feedback, **not** an executed Go build, test, staticcheck, format or fuzz result.
- Native commands/exits/output: **none**. Timings, tests, mutation reds/restores/greens, campaign executions and hosted results: **not run / not claimed**.
- Hash capture was supplied by the PM's actual read-only in-process receipt cited above, not inferred from edit tags.

## Exact future PM verification lane — not run here

Run serially from the assigned worktree root, with pinned Go1.27.3, `GOTOOLCHAIN=local`, empty `GOFLAGS`, `CGO_ENABLED=0`, host target. Save exact command/exit/raw output and post-format/final committed file identities. Do not use the pre-format hashes as the future formatted identity.

Formatting the exact changed files, then listing that same set:

```text
"C:/Program Files/Go/bin/gofmt.exe" -w contract/ledger/reader.go contract/ledger/scan.go contract/ledger/doc.go contract/ledger/reader_test.go contract/ledger/fuzz_test.go
"C:/Program Files/Go/bin/gofmt.exe" -l contract/ledger/reader.go contract/ledger/scan.go contract/ledger/doc.go contract/ledger/reader_test.go contract/ledger/fuzz_test.go
```

Focused/plain and host static/import/module lane:

```text
GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -timeout 19m -v ./contract/ledger -run '^(TestReader.*|TestReadingHasNoEffects|TestGolden.*)$'
GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -timeout 19m -v ./contract/ledger
GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go vet ./contract/ledger
GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go tool staticcheck ./contract/ledger
GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go list -f '{{join .Imports "\n"}}' ./contract/ledger
GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go list -f '{{join .TestImports "\n"}}' ./contract/ledger
GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go list -deps -f '{{if not .Standard}}{{.ImportPath}}{{end}}' ./contract/ledger
GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go mod tidy -diff
GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go mod verify
```

PM-owned serial120-second campaigns on the settled source, using the existing campaign evidence procedure:

```text
GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -timeout 19m ./contract/ledger -run '^$' -fuzz '^FuzzReaderCheckpoint$' -fuzztime=120s
GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -timeout 19m ./contract/ledger -run '^$' -fuzz '^FuzzCheckTruncation$' -fuzztime=120s
GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -timeout 19m ./contract/ledger -run '^$' -fuzz '^FuzzCheckTornTail$' -fuzztime=120s
GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -timeout 19m ./contract/ledger -run '^$' -fuzz '^FuzzCheckCorruption$' -fuzztime=120s
```

The four isolated mutation commands are specified above. Retain failures, execution counts and exact restore/source identity. Preserve frozen fixture byte identities without regeneration. No local `tools/check`, extra ledger race/×20 or five-target static sweep is requested: no locking/goroutine/channel/shared-global or build-constraint change was made. The actual C1 public freeze SHA still needs the full hosted three-OS/race/Check result; local evidence cannot replace it.

## Open questions, blockers and handoff boundary

No unresolved implementation decision or inaccessible source prerequisite remains. R1 (obtaining exact hashes without native commands) is answered by the PM manifest. No runner request is outstanding.

Unexecuted PM proof/review/freeze/integration gates are pending, not passing results. No goldens were touched, but their retained digest evidence remains PM work. Actual close-error coverage for predecessor/discarded-candidate/transition sites is source factoring plus the later general evidence lane; the explicit actual OS-failure regressions exercise Reader automatic/explicit/error closure, not manufactured faults at every private site. No performance/numerical acceptance or Ticket140 closure is claimed.

Source remains frozen. PM owns formatting, all actual Go/mutation/fuzz checks, public register/private freeze records, commits/hosted verification/integration and the explicit C3 release.
