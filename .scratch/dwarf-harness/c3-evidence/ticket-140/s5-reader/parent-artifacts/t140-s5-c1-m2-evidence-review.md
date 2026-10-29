# Ticket140 S5 — C1 Reader evidence for joint review

Private destination: `.scratch/dwarf-harness/c3-evidence/ticket-140-s5-reader-freeze-evidence.md`. This local review copy records completed M1 facts, including all four completed fuzz campaigns. It is not a freeze, review verdict, integration or C3 release. Contract version/status remains in `docs/CONTRACTS.md` only.

Citation roots: **PM/** = `C:/Users/darius.jones/.omp/agent/sessions/-Documents-PROJECTS-dwarf-harness/2026-10-24T15-58-31-752Z_01a16ea2-9748-77b3-ac90-a8beabd7bc22/local/`; **EV/** = `C:/Users/darius.jones/worktrees/dwarf-harness/t140-s5-reader-evidence/`; **CODE/** = `C:/Users/darius.jones/worktrees/dwarf-harness/140-final-ack/`; bare repository paths = canonical MAIN. These are private citations. Source SHA **C1** = `81ae94d3e92b5fd5574f46046c42fc9c5e30ce6d`; base = `84d0ced9446168777c7b7bfa3382974977bf27ed`.

## Authority and original-byte retention

The original brief and fresh ruling remain governing inputs; the ruling's P7 correction requires Reader-level changed-prefix proof before Core exists. D125 delegates the completed additive freeze; adopted D156 permits Reader's own checked-main milestone before Core within D155's single final assignment. The ruling's original policy rejection describes its issuance; D156 supplies the subsequent sequencing exception, not implementation approval. [Sources: PM/t140-s5-c1-freeze-drafter-assignment.md:5-20,31-39; PM/t140-s5-design-ruling.json:125-136,195-208,220-288; docs/DECISIONS.md:2134-2147,3090-3116.]

Nine immutable authority copies exist under `.scratch/dwarf-harness/c3-evidence/`, with exact source paths, byte counts and verbatim flags in PM/t140-s5-c1-authority-retention.json:1-68. Publication of their new C1 binding remains future.

| Private basename | Retained SHA256 |
|---|---|
| ticket-140-s5-design-brief.md | 93bf8a13f847d03626672caae2a77f35e97ddfcc968b63568dd4ea12bc81cc55 |
| ticket-140-s5-design-ruling.json | ef2dfa6612bf2114dcb3229d474d841389df749d868fdb1dfb9bfb36ca702611 |
| ticket-140-s5-design-ruling-binding.json | d568b4d2f515e1f469b434f6230cc2b3119cee6d05bdc649513fcf60e8c59c32 |
| ticket-140-s5-owner-sequence-question.json | 74e0ccb899e7f775d075f1cfbef4ded361dba86982895c1d27e6c7134ec71d26 |
| ticket-140-s5-owner-sequence-selection.json | 97dc5472c0f2a707a1202f1510ef2d8eed8c88775c4b27a571b1d9b662f09092 |
| ticket-140-d156-publication.json | db1693516a9b38c98cc10ac155872a075e3741aaef859da7c9f1d2e9ff143a7b |
| ticket-140-s5-ruled-assignment-authority.json | 7cf9e033d06b7dbee1394f3496f58fa528bf1887448c82d61de19becfbc45d18 |
| ticket-140-d155-publication.json | 2e66d64607f9f6291df26901e54c4fbbe81121dc275901b93c2cc124d5544460 |
| ticket-140-s5-d155-d156.md | 1f2d04dfd0146bbd1f206c1d5b120f3e534c837a191c72cce35057c14145c5da |

The D155/D156 excerpt is bound to private publication `b63d618c76b864ec08855bd78eadcf3e27cf7588`, docs/DECISIONS.md:3090-3116. The ruling's exact original LF/UTF-8 bytes (36,618 bytes, ef2dfa…2611) were restored from actual assistant JSON substring, source message `1d7d1fb9`; no JSON reserialization, wording, semantic ruling or policy change occurred. The former CRLF storage capture remains separately as PM/t140-s5-design-ruling-storage-crlf.json, SHA256 `13c54640efb95aa90c40f2834fb50a105b51af22761e031a1a9917a3ca25399d`. [Sources: PM/t140-s5-c1-authority-retention.json:61-82; PM/t140-s5-ruling-storage-correction.json:1-13.]

## Completed implementation identity

All five committed implementation blobs MATCH the final formatted/restored source; missing/mismatched/uncovered lists are empty. Exactly these five files changed; no consumer, module or fixture path changed and no untracked path was reported. [Sources: PM/t140-s5-c1-implementation-proof.json:2-25; PM/t140-s5-c1-mutants-pm-acceptance.json:8-26.]

| C1 blob | SHA256 |
|---|---|
| contract/ledger/reader.go | 75cb8a6e2bf9e7468787f7fd2708b2174aadfa741179a5ec97123f5eb959cc75 |
| contract/ledger/scan.go | 94652a4384242aba11592beb8667cf65a90865ac3fdbfad60297bedb9732e1cb |
| contract/ledger/doc.go | b078d7f534f5ebfd7fcb1c08d518a8c3e355abb8709e649ae9aef2c9993c29eb |
| contract/ledger/reader_test.go | 710772f66538aac26444f1ae4661d6df1f683f5a23d1a68336a7551bdad1e28d |
| contract/ledger/fuzz_test.go | 7b5c0fac7138c779ac41e5f42a9deb5ef9274bd7c462b28ee45df545734f9488 |

Detailed package contract: `81ae94d3e92b5fd5574f46046c42fc9c5e30ce6d:contract/ledger/doc.go:156-176`; existing reading guarantees remain at lines132-154. The addition is only opaque process-local `ReadCheckpoint`, `OpenReaderWithCheckpoint` and `Reader.Checkpoint`. It reuses completed verification only after fresh full framed-prefix-byte and predecessor equality; suffix parsing/verifying remains ordinary. Nil/damaged/stale/mismatched hints fall back, still with checked actual closure. Issuance requires advancing numeric completion, terminal EOF and successful closure. No persistent token format/resource, legacy ReadOptions/Commit/API/consumer change, new family/schema/format/Defined count, or fixture regeneration is introduced. Prefix I/O/hashing remain; this is not snapshot/hostile-rewrite/power-loss qualification. [Sources: C1:contract/ledger/doc.go:132-176; PM/t140-s5-c1-implementation-proof.json:2-25; PM/t140-s5-c1-mutants-pm-acceptance.json:17-26.]

## Reader observable proof

Focused command: `go test -count=1 -timeout=19m -v ./contract/ledger -run '^(TestReader.*|TestReadingHasNoEffects|TestGolden.*)$'`. Actual focused result: 21 top-level tests / 60 PASS rows, 0 FAIL, 0 SKIP; package 1.184s. Raw output: EV/format-focus-20261029T203515535Z-17748/03-reader-golden-focus.stdout.log (and paired stderr/metadata). [Sources: PM/t140-s5-c1-focus-complete.json:153-173; that raw log.]

| Observable behavior | Actual test and source |
|---|---|
| Minted/closed checkpoint, repeated warm continuation, whole Commit/record bytes and cursor equivalence; typed error/location equivalence; unchanged directory snapshot | TestReaderCheckpointContinuation and assertCheckpointRead, C1:contract/ledger/reader_test.go:264-415 |
| consumed version, AllTypes/unconsumed version, skipped prefix version, nothing consumed; lower/upper inside-commit, reversed/equal bounds, ToEnd; multi-buffer prefix | TestReaderCheckpointContinuation subcases in the same source/output |
| Earlier nonterminal framing corruption or properly framed unsupported format, last prefix line/suffix retained; ordinary error class/location and no read effects | TestReaderCheckpointChangedPrefix, C1:contract/ledger/reader_test.go:417-452 |
| Fresh sequence-preserving predecessor change with identical containing prefix; ordinary broken-link location | TestReaderCheckpointAnchorAndFallback/changed_predecessor, C1:contract/ledger/reader_test.go:454-521 |
| rotation, truncated prefix, missing segment, wrong root/colony/After, zero/nil and damaged afterHash; valid-source ordinary equivalence | Remaining TestReaderCheckpointAnchorAndFallback subcases, same source/output |
| Framing/envelope/format/version/short numeric/partial commit errors; early Close; real descriptor failures at EOF/explicit/read/corrupt closure; repeated Close retains failure and nil proof; legacy closure behavior | TestReaderCheckpointErrors, C1:contract/ledger/reader_test.go:523-645; raw focused output |
| Legacy reads/whole commits/consumption and no-effects regression, unchanged frozen golden tests | TestReader*, TestReadingHasNoEffects and TestGolden* in focused raw output; complete package run below |

## Four accepted minimal semantic breaks

PM accepted all four after reading all eight actual metadata/raw outputs and reconstructing each one-predicate mutation. Eight Go calls, no retries, extra mutants, survivors, compile/unrelated failures, timeouts or skips. Every red exited1; exact restored SAME-command green exited0; all five source hashes restored. No permanent source/test change. [Sources: PM/t140-s5-c1-mutation-report.json:1-60; PM/t140-s5-c1-mutants-pm-acceptance.json:1-149.]

Every command below has prefix `go test -count=1 -timeout=19m -v ./contract/ledger -run`; its quoted final argument is identical in red and green. Each EV run directory retains `commands.json`, `<stage>.json`, `<stage>.stdout.log`, `<stage>.stderr.log`, `source-before.json`, `source-after.json`, `plan.json` and `summary.json`. Full start/end UTC/environment and original/mutant/restored hashes are retained in the mutation report, not reconstructed here.

| Break and exact selector | Minimal change / actual distinguishing failure | Red → restored green; elapsed seconds |
|---|---|---|
| M1 `'^TestReaderCheckpointChangedPrefix$/^framing$'` | scan.go:234 drops only `prefix != p.prefix`; mutated Reader returns commit4/cursor4, ordinary none/cursor3 (reader_test.go:436) | EV/m1-prefix-red-20261029T204230087Z-6716 → EV/m1-prefix-green-20261029T204251440Z-12972; 4.6430463999999994 → 1.9988203999999998 |
| M2 `'^TestReaderCheckpointAnchorAndFallback$/^changed_predecessor$'` | reader.go:105 replaces base-chain inequality with false; mutated Reader returns commit7–8/cursor8, ordinary none/cursor6 (reader_test.go:509). Sequence/name check does not mask it | EV/m2-base-red-20261029T204317567Z-10112 → EV/m2-base-green-20261029T204334779Z-16160; 4.1589041 → 2.1016576 |
| M3 `'^TestReaderCheckpointAnchorAndFallback$/^damaged_afterHash$'` | reader.go:95 drops only self-checksum equality; valid source gives mutated none/cursor6 vs ordinary commit7–8/cursor8 (reader_test.go:509). Assertion stops before error-class printing: NO claim of an unprinted ErrCorrupt | EV/m3-token-red-20261029T204348840Z-13328 → EV/m3-token-green-20261029T204405890Z-4908; 4.2991784 → 2.0381256999999997 |
| M4 `'^TestReaderCheckpointErrors$/^numeric_EOF_close_failure$'` | reader.go:329 checkedClose return only becomes nil; raw `reader_test.go:621: actual close failure not retained: <nil>`. Retained state still protects no issuance: this is Close-return proof, NOT checkpoint-mint or Core failure | EV/m4-close-red-20261029T204439527Z-14476 → EV/m4-close-green-20261029T204458609Z-16388; 3.8730651 → 1.9221818 |

Exact diff SHA256s (M1→M4): `fe2b89092dd50b4a086c805bb84d1f164af31427e628b1ccd267f5a2dcaec736`; `517fad52eaaabad5a3e072d3a14e97b568bf1db14f71abff0824293182366c67`; `f86f696ad2308806b975c62d4161ca2f0d80deb0ca651888b6c9e93ce15b95b6`; `3eb9002730754796d8648e869da79e979b0af082540b9391cd99937c9a71ad4d`. Actual raw stdout and command-metadata SHA256 pairs for every red/green are in PM/t140-s5-c1-mutants-pm-acceptance.json:28-140; original/mutant/restored source hashes, exact diff bytes, full argv/time/env and masking limits are in PM/t140-s5-c1-mutation-report.json:63-280. These retained receipts are part of this evidence, not omitted proof or new digest claims. M4's return-line reconstruction was context-narrowed to checkedClose, without source change or proof rerun. [Source: PM/t140-s5-c1-mutants-pm-acceptance.json:7,28-149.]

## Four completed serial fuzz campaigns

Actual bg87 completed exit0, reported launcher wall506.72s. All four children exited0, no timeout/error, reaped and streams complete; before/after source manifests match all five C1 hashes. PM full local Go is released, as are author/secondary lanes; this is NOT C3 release. The initial bg86 wrong-path launcher failed BEFORE any Go, so no campaign repeated. The implementation proof's older NOTYETRUN field is superseded by this actual completion receipt. [Sources: PM/t140-s5-c1-fuzz-complete.json:1-218; EV/pm-fuzz-20261029T210629728Z-6172/summary.json:1-68; parent's completion message.]

Every command was `go test -count=1 -timeout=19m ./contract/ledger -run '^$' -fuzz '^TARGET$' -fuzztime=120s -parallel=1`, with TARGET replaced literally by the table's named target. Cwd/executable/env are the host lane below. Budget120s is not measured package/native duration. Raw root **F** = EV/pm-fuzz-20261029T210629728Z-6172. Exact argv/start/end/env/exit is in F/commands.json:1 and each `fuzz-TARGET.json`; stdout/stderr are `fuzz-TARGET.stdout.log`/`.stderr.log`; source-before/after, summary and original plan are retained. Original plan SHA256: `3002c4d52ad40b19f78545b025bc26df20b5f2345a31205234303a7cf216f7f5`.

| Target / reach | Executions; new interesting; baseline completed | Package seconds; native seconds | Actual UTC start → finish on 2026-10-29 |
|---|---|---|---|
| FuzzReaderCheckpoint: genuine minted warm proof; byte/cut/context/token mutations and ordinary Reader equivalence | 27147; 43; 101/101 | 121.333; 128.700061 | 21:06:29.8865580 → 21:08:38.5943279 |
| FuzzCheckTruncation: changed legacy scanner/open/close/line-reader, not warm proof | 14993; 11; 508/508 | 122.239; 130.2477546 | 21:08:38.6615531 → 21:10:48.9141846 |
| FuzzCheckTornTail: changed legacy torn-tail/scanner path, not warm proof | 285; 1; 51/51 | 122.720; 123.8294797 | 21:10:48.9141846 → 21:12:52.7497804 |
| FuzzCheckCorruption: changed legacy corruption/scanner path, not warm proof | 14993; 8; 71/71 | 121.927; 123.2017089 | 21:12:52.7578948 → 21:14:55.9636117 |

All four raw stdout logs end PASS. TornTail's actual285 executions/one new interesting input and long zero-rate intervals are retained, not hidden or replaced by the budget. Stdout SHA256s in target order: `fa13d6bbc13a40f42b3242d004cb859e69303231ee4fa7c1a8b082e89c4b0546`; `6821249c1955016ec926644f848ba5441762057600eaa34bc803f475bdecfa2e`; `a1ca64921017883694642e80d855c815f37ee6b76e9a9b1394053a65e0f999d9`; `4a7524ae57dfcbe1ed5fcc61bd5844362bf9abb54d994d62248285767a01f398`. All four stderr SHA256s are the empty-byte digest `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`. [Sources: PM/t140-s5-c1-fuzz-complete.json:28-218; F/fuzz-FuzzReaderCheckpoint.stdout.log:1-45; F/fuzz-FuzzCheckTruncation.stdout.log:1-44; F/fuzz-FuzzCheckTornTail.stdout.log:1-45; F/fuzz-FuzzCheckCorruption.stdout.log:1-45.]

Real descriptor-close failure remains separate regression/mutation proof; byte fuzzing does not inject that fault. Legacy three campaigns do not establish warm-checkpoint coverage. No fifth/repeated campaign, unrelated agents fuzzing or new numerical acceptance is claimed. [Sources: C1:contract/ledger/fuzz_test.go:233-359; PM/t140-s5-c1-fuzz-complete.json:214-218; PM/t140-s5-design-ruling.json:374-407.]

## Frozen fixture identity

All46 tracked `contract/ledger/testdata` fixtures match base bytes/SHA256: 748,606 total bytes, 0 CR bytes. The complete per-path base object/baseSHA256/currentSHA256/byte/CR/equality manifest is retained as PM/t140-s5-c1-frozen-fixture-proof.json (summary at lines1-10). Fixture paths were not changed by implementation or Reader-only mutants; no golden regeneration. This includes the D149-corrected F3-13 and F3-139 fixtures, not selected digests standing in for the full manifest. No format/family/schema/catalogue/Defined-count change is within the five-path perimeter. [Sources: that manifest; PM/t140-s5-c1-mutants-pm-acceptance.json:17-26.]

## Executed host lane and raw receipts

Actual toolchain `go version go1.27.3 windows/amd64`; all commands ran in CODE with `GOTOOLCHAIN=local`, empty `GOFLAGS`, `GOROOT=C:/Program Files/Go`, `GOOS=windows`, `GOARCH=amd64`, `CGO_ENABLED=0`. Go/gofmt executables were `C:/Program Files/Go/bin/go.exe` and `gofmt.exe`. Native metadata records every child reaped/streams complete, timeout/error/exit and source-before/after identities. The first format write changed only reader.go formatting; post-format hashes are the C1 manifest above. [Sources: PM/t140-s5-c1-focus-complete.json:17-59,63-163; PM/t140-s5-c1-plain-static-stop.json:1-179; EV/imports-module-remaining-20261029T205724896Z-15852/commands.json:1; summary.json:15-68.]

Raw-directory aliases (all under EV):

- **A** = `format-focus-20261029T203515535Z-17748`
- **B** = `plain-static-20261029T205354553Z-1196`
- **C** = `imports-module-remaining-20261029T205724896Z-15852`

For each row, exact argv/start/end/elapsed/exit/env/raw paths are retained in its directory's `commands.json` and `<name>.json`; original stdout/stderr are `<name>.stdout.log`/`<name>.stderr.log`, not rewritten summaries. Each directory also retains plan, summary and before/after source manifests. Times below are UTC on 2026-10-29; seconds are recorded elapsed, not package time. No raw digest is invented where these receipts supply none.

| Directory/name | Actual command | Start → finish UTC; elapsed seconds; exit |
|---|---|---|
| A/01-gofmt-write | `gofmt -w contract/ledger/reader.go contract/ledger/scan.go contract/ledger/doc.go contract/ledger/reader_test.go contract/ledger/fuzz_test.go` | 20:35:15.7036246 → 20:35:15.8179930; 0.11089829999999999; 0 |
| A/02-gofmt-list | `gofmt -l` on that identical five-file list | 20:35:15.8605914 → 20:35:15.9043867; 0.042466199999999996; 0 |
| A/03-reader-golden-focus | focused command above | 20:35:15.9189127 → 20:35:20.1189564; 4.200818; 0 |
| B/04-go-version | `go version` | 20:53:54.6928249 → 20:53:54.7873292; 0.08528419999999999; 0 |
| B/05-ledger-plain | `go test -count=1 -timeout=19m -v ./contract/ledger` | 20:53:54.8189016 → 20:54:02.9494512; 8.1275619; 0 |
| B/06-host-vet | `go vet ./contract/ledger` | 20:54:02.9601786 → 20:54:03.4183577; 0.4597695; 0 |
| B/07-host-staticcheck | `go tool staticcheck ./contract/ledger` | 20:54:03.4339944 → 20:54:06.0495226; 2.6125873; 0 |
| B/08-production-imports | failed template: argument contained an actual LF, not literal backslash-n; exact argv retained in metadata | 20:54:06.0556417 → 20:54:06.0936000; 0.037878999999999996; 1 |
| C/08-production-imports | `go list -f '{{join .Imports "\n"}}' ./contract/ledger` | 20:57:25.0570031 → 20:57:25.1927335; 0.1312691; 0 |
| C/09-test-imports | `go list -f '{{join .TestImports "\n"}}' ./contract/ledger` | 20:57:25.2301671 → 20:57:25.3192790; 0.0875835; 0 |
| C/10-nonstandard-dependencies | `go list -deps -f '{{if not .Standard}}{{.ImportPath}}{{end}}' ./contract/ledger` | 20:57:25.3192790 → 20:57:25.4418537; 0.11359119999999999; 0 |
| C/11-module-tidy-diff | `go mod tidy -diff` | 20:57:25.4433596 → 20:57:25.5644526; 0.11683149999999999; 0 |
| C/12-module-verify | `go mod verify` | 20:57:25.5752928 → 20:57:26.3602050; 0.77569029999999994; 0 |

Observed: gofmt listing, vet, staticcheck and tidy-diff stdout are empty. Direct/test imports contain only standard-library paths (including `uuid`); nonstandard dependency output is only the ledger package itself. Module verify prints `all modules verified`; no module path changed. The ONE plain package run yielded 84 top-level tests + 15 top-level fuzz seed runs, 9382 total PASS rows, 0 FAIL/0 SKIP; final `ok github.com/Darius-PJ/dwarf-harness/contract/ledger 7.301s`. Those seed runs are distinct from the four timed campaigns. [Sources: A/02-gofmt-list.stdout.log:1; B/05-ledger-plain.stdout.log final3 lines; B/06-host-vet.stdout.log:1; B/07-host-staticcheck.stdout.log:1; C/08-production-imports.stdout.log:1-22; C/09-test-imports.stdout.log:1-22; C/10-nonstandard-dependencies.stdout.log:1; C/11-module-tidy-diff.stdout.log:1; C/12-module-verify.stdout.log:1; PM/t140-s5-c1-plain-static-stop.json:10-25; PM/t140-s5-c1-mutants-pm-acceptance.json:17-26.]

The failed capture prints `template: main:1: unterminated quoted string` in B/08-production-imports.stderr.log:1; it is retained as a launcher/template error, not a product failure or semantic red. Only corrected08 and previously unrun09–12 were authorized/run afterward. Version/plain/vet/static/focus/mutants were NOT repeated. No local full check, extra local race/×20, five-target static loop, consumer smoke or new diagnostic/control gate was introduced. [Sources: PM/t140-s5-c1-plain-static-stop.json:23-30,179; C/commands.json:1; PM/t140-s5-design-ruling.json:283-288,407,421-429.]

## Explicitly deferred M2 review facts

The following are actual future factual captures, not approved outcomes. Independent completed-code + filled-M1-evidence + exact-R1–R4 review must precede freeze application. Preserve review-submitted and final filled copies separately; no routine note-confirmation gate is added.

| Actual future value | Fill |
|---|---|
| Saved independent request/verdict and reviewer/model/effort/fallback provenance, paths and actual digests | «JOINT-REVIEW-RECEIPT» |
| Exact C1/five-file/evidence identities submitted | «REVIEW-SUBJECT» |
| Exact reviewed R1–R4/fill-map bytes and digests; subsequent integration fields explicitly deferred | «REVIEWED-RECORD» |
| Verbatim actual independent joint review line | «JOINT-REVIEW» |
| Actual findings/corrections/disposition, affected proof/review if required | «REVIEW-DISPOSITION» |

## Explicitly deferred M3 integration facts

No public freeze SHA, hosted success, publication or Core release is asserted. Public R1 contains no self-hash. The actual public C1 subject must include completed code/package docs plus R1 BEFORE its own full hosted matrix; a later Core run or Markdown-exempt aggregate cannot substitute. Later factual fields must not silently change reviewed contract/proof premises; material changes follow existing D152/D153 affected-proof/review rules. [Sources: PM/t140-s5-design-ruling.json:232-288; docs/DECISIONS.md:3109-3116.]

| Actual future value | Fill |
|---|---|
| Actual unused decision digits; actual freeze local-calendar date | D«D-NEXT»; «DATE» |
| Applied new private decision identity/digest | «COMPLETED-DECISION-COPY» |
| Public freeze SHA and actual parent/subject identity | «C1-FREEZE-SHA»; «PUBLIC-FREEZE-IDENTITY» |
| C1→public-freeze five-blob equality and precise public-record delta | «CODE-HASH-BRIDGE» |
| Actual exact-SHA review binding | «EXACT-SHA-REVIEW-BINDING» |
| Own exact-SHA full Windows/Linux/macOS/race run URL/ID/attempt/head/classifier/raw jobs | «HOSTED-FULL-MATRIX» |
| SAME-SHA successful Check result, completion and raw receipt | «C1-HOSTED-RESULT» |
| Guarded checked-SHA fast-forward/public-main/remote receipt | «C1-MAIN-PUBLICATION» |
| Actual private D/evidence/review/check/public-subject binding and digests | «PRIVATE-BINDING» |
| Private records commit/remote receipt external to its own bytes | «PRIVATE-PUBLICATION-RECEIPT» |
| PM's later actual release after integrated freeze and own hosted/main/private proof | «CORE-RELEASE-RECEIPT» |

D157 and B35 remain unallocated. Before any new-API Core implementation/tests, the independent freeze and its own full exact-SHA hosted success/main/private binding must actually exist. Core and the original seven numerical bounds remain later requirements under the unchanged brief/ruling; no new numerical pass, step-status change, C3 implementation, Ticket140 closure or sixth slice is claimed here. Historical S4 failures/diagnostic remain separate nonacceptance evidence. [Sources: PM/t140-s5-c1-freeze-drafter-assignment.md:7,31-39; PM/t140-s5-design-ruling.json:253-288,408-444.]

## Drafter choices and unresolved facts

- **P1 — actual identities:** committed five-blob match plus observed Reader semantics, not a source-only design forecast. Sources: PM/t140-s5-c1-implementation-proof.json:2-25; C1:contract/ledger/reader_test.go:264-645.
- **P2 — honest proof limits:** retain all eight mutant raw receipts and exact restore/green identities; M3 records/cursor only, M4 Close-return only; keep bad import-template stop and do not repeat successful checks. Sources: PM/t140-s5-c1-mutants-pm-acceptance.json:1-149; PM/t140-s5-c1-plain-static-stop.json:23-30,179.
- **P3 — original authority bytes:** nine copied authorities and separately retained historical CRLF capture; restoration is storage correction, not revised ruling/policy. Sources: PM/t140-s5-c1-authority-retention.json:1-82; PM/t140-s5-ruling-storage-correction.json:1-13.
- **P4 — no borrowed completion:** all four actual campaign results now come from the retained bg87 completion; independent verdict and integration facts remain future. Sources: PM/t140-s5-c1-fuzz-complete.json:1-218; PM/t140-s5-c1-freeze-drafter-assignment.md:31-39.
- **Unresolved:** M2 verdict/provenance/reviewed identities/disposition; D/date/apply-time tail; actual public freeze/hash bridge/own hosted/main/private binding/publication and subsequent PM release. No M1 fuzz-result fill remains. This drafter performed no native command or repository/private-record write.
