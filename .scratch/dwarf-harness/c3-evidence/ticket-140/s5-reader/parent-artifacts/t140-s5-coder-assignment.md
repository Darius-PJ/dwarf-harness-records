# Ticket140 — ONE fifth-and-final assignment, Reader milestone ONLY now

## Authority and current source

The owner actually selected the assistant option **Allow two milestones in S5**. D156 is recorded and privately published at `b63d618c76b864ec08855bd78eadcf3e27cf7588`; D155's one final slice remains in force. This is ONE bounded assignment with TWO explicitly authorized completion/integration milestones, not S5a/S5b or a sixth slice.

- Worktree: `C:/Users/darius.jones/worktrees/dwarf-harness/140-final-ack`
- Branch: `build/140-final-ack`
- Actual integrated/published base: `84d0ced9446168777c7b7bfa3382974977bf27ed`. This includes completed139 and all140S4 safety/codec work. Do not rebase or mutate main.
- Canonical MAIN/private authority: `C:/Users/darius.jones/Documents/PROJECTS/dwarf-harness`.
- Parent local root: `C:/Users/darius.jones/.omp/agent/sessions/-Documents-PROJECTS-dwarf-harness/2026-10-24T15-58-31-752Z_01a16ea2-9748-77b3-ac90-a8beabd7bc22/local/`.
- The source-only design subject8a17 is historical; the base84d0 adds only139's two tests and approved closing docs, not a different Reader mechanism.

**Hard barrier:** complete ONLY the C1 Reader capability now. No C3/Core consumer implementation, consumer tests using the new API, cache work, or changed existing consumers until PM explicitly reports the completed C1 code/evidence/record independently reviewed, D125-frozen, its own exact-SHA full three-OS/race/Check result successful, and that public freeze SHA integrated/published on main with the private binding. Then the SAME assignment may continue from that integrated freeze. D156 is not an upfront freeze or code approval.

## Required reading and precedence

Read applicable project/role instructions, the existing parent `coder-context.md`, matching staged-build/slice-recipes/surgical-patch/safe-refactor skills, and these complete parent-local authorities:

1. `t140-s5-design-brief.md` — ALL312 lines, original SHA256 `93bf8a13f847d03626672caae2a77f35e97ddfcc968b63568dd4ea12bc81cc55`.
2. `t140-s5-design-ruling.json` — complete actual fresh ruling SHA256 `ef2dfa6612bf2114dcb3229d474d841389df749d868fdb1dfb9bfb36ca702611`.
3. `t140-s5-design-ruling-binding.json`, `t140-s5-ruled-assignment-authority.json`, `t140-d156-publication.json` and actual private D156 at `docs/DECISIONS.md:3104-3116`.
4. Existing Reader/scanner/tests/fuzzer sections in the assigned worktree; parent `t140-s5-lsp-reference-digest.json`, `t140-s5-lsp-production-references.md`, `t140-s5-lsp-reference-supplement.json` and `t140-s5-lsp-readoptions-references.json` identify current consumers and signatures.

The ruling wins over the brief on technical corrections. Its recorded B4/OG-SEQUENCE approvalReceived=false was TRUE AT ISSUANCE; the actual later D156 answer supplies exactly that prerequisite. It does not change any technical condition. P7's pre-freeze prefix-identity mutation oracle is **TestReaderCheckpointChangedPrefix**, not the as-yet-forbidden C3 consumer test. No confirmation review or new diagnostic is requested.

Use LSP for code intelligence/references before modifying existing exported symbols. At first use add this worktree to the existing gopls workspace with `workspace/didChangeWorkspaceFolders`, routing through MAIN `contract/ledger/reader.go`, added URI `file:///C:/Users/darius.jones/worktrees/dwarf-harness/140-final-ack`, name `140-final-ack`; re-send only after a revival or actual missing metadata. Existing `task.enableLsp` and installed server setup are already successful; do not reinstall/repeat setup. Child tools must actually include lsp. No shell-based code-intelligence substitute.

## Owned paths — ONLY these five

- `contract/ledger/reader.go`
- `contract/ledger/scan.go`
- `contract/ledger/doc.go`
- `contract/ledger/reader_test.go`
- `contract/ledger/fuzz_test.go`

Every path must resolve under the assigned worktree; default tool cwd may still be MAIN. No Core/ledgerstore/other-consumer change, no `docs/CONTRACTS.md` or decision/evidence edit, no fixture/catalogue/schema/format/golden change, no dependency/toolchain/workflow/config/machine change. PM owns the public register and private freeze record. Existing legacy callers and exported structs/signatures remain intact, including `ReadOptions`, `Commit`, `OpenReader`, `Check` and existing scanner construction/reset signatures. New factual API/package documentation need not duplicate a proposed/frozen status already controlled by the register; do not add a new status convention.

## Implement the ruled Reader design, not a substitute

- Add exactly the opaque fixed-width private-field `ReadCheckpoint`, opt-in `OpenReaderWithCheckpoint(logDir string, opts ReadOptions, checkpoint *ReadCheckpoint) (*Reader, error)` and `(*Reader).Checkpoint() *ReadCheckpoint` in the brief. Preserve the exact13-field order/types/version1/checksum representation. No exported constructor, serialization, imported raw token or caller-asserted Chain. Token contains no retained strings/slices/interfaces/pointers/resources; checksum is accidental-damage detection, not a hostile same-process seal.
- Existing option validation, segment listing/selection, freshly parsed preceding last record and segment-name continuity occur before any checkpoint restoration. Match version/checksum/shape, Abs+Clean directory identity without alias/case folding, colony, numeric advancing bounds/exact After, segment and all base-chain fields.
- On the SAME candidate descriptor that will read the suffix, freshly hash every framed byte `[0,offset)`, including hash text/TAB/LF, using bounded64KiB scratch. Only after equality seek to the exact logical offset and restore the complete after-chain with no open commit. Retain the freshly checked predecessor as this segment's BASE, not the restored after-chain.
- Missing/zero/damaged/mismatched/stale/rotated/short/byte-changed hints fall back to ordinary scanning in **checked-close mode**. Actual non-EOF I/O, seek and actual descriptor-close failures are errors, not cache misses. Failure to derive optional path identity merely disables checkpoint capture/use, not ordinary reading or checked Close.
- Reuse the existing frame/decode/verifier/version/keep paths; no second parser. Hash subsequent complete framed lines on LOGICAL consumption before buffer reuse, never bufio read-ahead beyond Through. Preserve absolute offsets and reset the per-segment prefix state correctly.
- Mint only after a fully processed numeric Through at a complete commit, terminal EOF, successful actual Close, matching cursor/through/done sequence and valid final chain/offset. ToEnd, equal bounds, early Close, read/close errors or partial commits produce no checkpoint. Return fresh value copies.
- Truthful actual-close failure reporting applies ONLY to the new opt-in opener: preserve first failure across automatic EOF/error closure, explicit/repeated Close, predecessor helper, transitions and discarded candidates; stop a transition after close failure; join read/close failures; do not swallow a close failure because errors.Is(io.EOF) is true. Legacy OpenReader/Check/Next/Close/error behavior remains unchanged.
- This still performs prefix I/O+SHA256 and inherits append-only live-writer assumptions. No O(1), scan-free, snapshot/hostile-rewrite atomicity, RAM-security or numerical-success claim.

## Behavioral evidence source to write now, not run mid-flight

Permanent tests earn their place on uncertain boundaries/invariants, not plumbing/defaults. Follow the existing Reader/fuzz conventions.

- Real minted warm continuation versus an independently opened ordinary Reader: exact complete records/commit boundaries, cursor and typed error/location outcomes. Cover consumed versions versus AllTypes, range/inside-commit boundaries, repeated warm continuation, rotation/truncation, wrong root/colony/After and zero/damaged proof fallback.
- Earlier NONTERMINAL prefix corruption with the last prefix line/suffix unchanged must expose the ordinary corruption/unsupported-format outcome. This is the pre-freeze prefix mutation oracle.
- A correctly framed changed predecessor last record, with its sequence PRESERVED, must expose the broken segment link even if current-segment prefix bytes are identical. Do not let the existing segment-name check mask the specific base-equality predicate.
- Use a REAL OS descriptor-close failure to prove retained actual Close errors/repeated Close/no minted checkpoint, plus early-close/read-error behavior. No mocked echo seam or fuzzer-only claim of actual close-failure coverage.
- Retain no-write/no-truncate and legacy Reader/Check behavior.
- Add `FuzzReaderCheckpoint` with genuine minted warm proof, bounded byte/cut/context/token damage and ordinary-reader equivalence. Existing `FuzzCheckTruncation`, `FuzzCheckTornTail` and `FuzzCheckCorruption` are the other three changed-code targets. No fake warm coverage from seeds rejected before warm opening. No package-membership-only fuzz claims.

Give PM FOUR exact minimal single-predicate mutation proposals and named Reader-level semantic oracles, to run only after the final source is frozen:

1. Omit fresh prefix-digest equality → earlier-prefix-corruption regression must fail.
2. Omit fresh-base equality → predecessor-anchor regression must fail, without a sequence/name masking failure.
3. Omit token self-checksum validation → damaged afterHash on VALID source must fail fallback equivalence.
4. Omit retained opt-in Close-error return → real descriptor-close regression must fail.

Do not run/apply mutants, add internal-only tests or compound mutations to manufacture a red. Report any genuine masking/uncertainty; compiler errors/timeouts/unrelated failures/survivors are not red proof.

## Execution and handback contract

This phase is SOURCE-ONLY. Skip all build/lint/tests/fuzz/formatters/checks during implementation, including gofmt/vet/static/go commands; no Git writes or commit/push. Existing LSP diagnostics are permitted while no QUIET hold exists. Parent runs ONE settled-source focused/plain/format/static/import/module lane and the serial120-second campaigns afterward, never a local full `tools/check`, extra ledger race or five-target static sweep absent an actual triggering change. No preimplementation benchmark/diagnostic/control or Core consumer smoke.

When edits are complete, stop writing and return a complete report (also save under parent local as `t140-s5-c1-coder-report.md`): owned paths and their exact bytes/SHA256, meaningful regression names, the new/legacy fuzz reachability, exact future focused commands, FOUR minimal mutation patches/oracles, local factoring notes and any real blocker. State no native run occurred and no command/source writer remains. Do not claim evidence from LSP as executed Go proof. Parent will format/verify/commit and obtain completed-code+freeze-record review; C3 remains forbidden until explicit release. Do not spawn subagents.
