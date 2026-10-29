# Ticket140 S5 — C1 ledger-reader checkpoint freeze evidence

Private destination: `.scratch/dwarf-harness/c3-evidence/ticket-140-s5-reader-freeze-evidence.md`.

Record scope: «EVIDENCE-SCOPE»

Unfilled slots are not executed evidence or approval. This body is supplied locally for the PM's later factual fills and joint completed-code/record review; it does not itself freeze anything or release Core. Contract version/status remains solely in `docs/CONTRACTS.md`; roadmap step status remains solely in the status board and owning roadmap's Status line. This evidence does not add either status source.

## 1. Authority, immutable inputs and scope

| Input | Actual retained authority | Private immutable copy / binding |
|---|---|---|
| Original brief | PM/t140-s5-design-brief.md:1-312; SHA256 `93bf8a13f847d03626672caae2a77f35e97ddfcc968b63568dd4ea12bc81cc55` | «BRIEF-COPY» |
| Actual fresh ruling | PM/t140-s5-design-ruling.json:1-445; SHA256 `ef2dfa6612bf2114dcb3229d474d841389df749d868fdb1dfb9bfb36ca702611` | «RULING-COPY» |
| Ruling provenance | PM/t140-s5-design-ruling-binding.json:1-37: actual original assistant JSON substring, message `1d7d1fb9`, openai-codex/gpt-6-astra, MAX, no fallback; supplied SHA binding, not a drafter hashing run | «RULING-BINDING-COPY» |
| Question and actual selection | PM/t140-s5-owner-sequence-question.json:1-18 and PM/t140-s5-owner-sequence-selection.json:1-22; original question precedes actual adopted selection. Preserve separately and verbatim, not a reconstructed approval summary | «QUESTION-COPY»; «SELECTION-COPY» |
| Count and sequencing decisions | docs/DECISIONS.md:3090-3116: D155 authorizes one fifth-and-final assignment; D156 permits two completed checked-main milestones, not an API/safety/count/traffic waiver | «D155-D156-COPY» |
| Actual private D156 publication | PM/t140-d156-publication.json:62-68; private commit and remote `b63d618c76b864ec08855bd78eadcf3e27cf7588` | «D156-PUBLICATION-COPY» |
| Ruled assignment authority | PM/t140-s5-ruled-assignment-authority.json:3-21,38-51,105-107,190-193: bound brief/ruling, adopted D156, hard release barrier, interfaces/proof and unchanged numerical subject | «ASSIGNMENT-AUTHORITY-COPY» |
| Completed-capability decision | D«D-NEXT», actual freeze date «DATE», assistant-originated under D125/D156; see docs/DECISIONS.md:2134-2147 for delegation and established pointers | «COMPLETED-DECISION-COPY» |

Citation roots: repository-relative paths mean canonical MAIN; PM/ is `C:/Users/darius.jones/.omp/agent/sessions/-Documents-PROJECTS-dwarf-harness/2026-10-24T15-58-31-752Z_01a16ea2-9748-77b3-ac90-a8beabd7bc22/local/`. These private roots and provenance do not belong in public records.

The ruling overrides the brief's P7 sequencing: the first prefix-identity red must use `TestReaderCheckpointChangedPrefix`, not a Core consumer test that cannot yet exist. The ruling's original B4 rejection and approvalReceived=false describe its issuance; actual subsequent D156 supplies exactly the policy exception, without rewriting the ruling or granting implementation proof. [Sources: PM/t140-s5-design-ruling.json:20-36,125-136,195-208; docs/DECISIONS.md:3104-3116.]

Freeze scope is only the additive opaque `ReadCheckpoint`, `OpenReaderWithCheckpoint` and `Reader.Checkpoint` capability on existing ledger-reader version 1. Legacy verification/consumption/AllTypes behavior and consumers remain; no family, format, schema, Defined count, fixtures/goldens, Digest unmarshaler, appender, Receipt, privateStore, Core implementation or roadmap status is changed by this record. The detailed contract belongs in completed package documentation «PACKAGE-DOC-CITATION» and the register, not a second contract table here. Prior full verification plus fresh full framed-prefix-byte equality and predecessor equality preserve verification; prefix I/O/hashing remain. [Sources: docs/CONTRACTS.md:11-27; contract/ledger/doc.go:132-154; PM/t140-s5-design-ruling.json:39-60,98-123,166-194,289-346.]

## 2. Completed source identity and five-file manifest

Actual integrated/public base supplied for this assignment: `84d0ced9446168777c7b7bfa3382974977bf27ed`. The older `8a17ec1ed2617ca2a4e5203479f75f363b359970` is the design/failed-S4 subject, not this completed implementation. Source subject below is filled from the PM's settled-tree capture, never actively changing coder files. [Source: PM/t140-s5-coder-assignment.md:5-17.]

| Identity | Actual fill |
|---|---|
| Completed C1 implementation commit | «C1-IMPLEMENTATION-SHA» |
| Actual parent/base and exact source capture | «IMPLEMENTATION-IDENTITY-RECEIPT» |
| Evidence runner/toolchain/env and settled-source release | «EXECUTION-ENVIRONMENT» |
| Complete changed-path inventory and proof existing consumers/module/fixture paths were not changed | «C1-PERIMETER-RECEIPT» |
| Exact completed package-doc source citation | «PACKAGE-DOC-CITATION» |

| Coder-owned source file | SHA256 of exact implementation blob |
|---|---|
| contract/ledger/reader.go | «READER-SHA256» |
| contract/ledger/scan.go | «SCAN-SHA256» |
| contract/ledger/doc.go | «DOC-SHA256» |
| contract/ledger/reader_test.go | «READER-TEST-SHA256» |
| contract/ledger/fuzz_test.go | «FUZZ-TEST-SHA256» |

«MANIFEST-RECEIPT»

No native command ran during this drafting/source-only phase. Subsequent PM-run results below must retain exact command, directory, environment, start/end, elapsed duration, exit, source manifest and raw stdout/stderr, including failed/interrupted/corrected attempts. Empty output is recorded as an observed empty output with the raw receipt, never assumed. A source correction invalidates source-dependent evidence until bound/re-exercised as required; no older failed subject or LSP diagnostic supplies executed Go proof. [Sources: PM/t140-s5-coder-assignment.md:70-74; PM/t140-s5-design-ruling.json:277-288.]

## 3. Reader observable proof, before any Core consumer

| Required observable contract | Actual named test/subcase, result and source-bound raw evidence |
|---|---|
| Genuine minted, successfully closed checkpoint; independently opened ordinary Reader yields identical whole commits/record bytes, cursor and typed errors/locations; repeated warm continuation | «PROOF-CONTINUATION» |
| This open's consumed-version/AllTypes behavior, numeric boundaries and inside-commit lower/upper rejection; ToEnd/equal bounds cannot mint | «PROOF-OPTIONS-BOUNDARIES» |
| Earlier nonterminal prefix corruption with final prefix line and suffix unchanged; ordinary corruption class/location and properly framed unsupported-format fallback, no writing/truncating during reading | «PROOF-CHANGED-PREFIX» |
| Fresh predecessor last-record change with sequence preserved and current-segment prefix unchanged; broken link detected without segment-name check masking base equality | «PROOF-PREDECESSOR» |
| Rotation, truncation/short prefix, wrong directory/colony/After, zero/damaged proof and valid-source damaged afterHash fall back to ordinary outcomes | «PROOF-FALLBACK» |
| Actual OS descriptor-close failure, retained error after EOF and repeated Close, nil checkpoint; early Close and genuine read failure cannot mint; truthful non-EOF I/O/seek/read errors | «PROOF-CLOSURE» |
| Legacy OpenReader/Check behavior, read-only/no-effects guarantee and ordinary torn-tail behavior retained | «PROOF-LEGACY-NO-EFFECTS» |

Sources defining these observable obligations: PM/t140-s5-design-brief.md:183-206; PM/t140-s5-design-ruling.json:98-136,347-373. Proposed names are obligations, not claims that implementation/tests already exist; record the actual settled names and locations in each fill. No wall-time/source-text/hit-count/mock-echo result substitutes for a semantic oracle.

## 4. Exactly four minimal C1 proof breaks

All four are future PM-run isolated single-predicate mutations on the completed C1 source. Each fill must give: actual source SHA and file; exact minimal diff and diff digest; original/mutant/restored file SHA256; named exact command/test/subcase; red exit and distinguishing observable assertion; raw red output; byte-identical restore evidence; SAME command green exit/raw output; actual times/environment; and any initial survival/masking or correction. Compile errors, timeouts, unrelated failures and survivors are not semantic reds. Keep failing attempts, not just successful corrections. [Sources: PM/t140-s5-design-brief.md:198-206; PM/t140-s5-design-ruling.json:125-136,367-373; docs/DECISIONS.md:3032.]

| Break | Predicate removed only | Required Reader oracle | Actual evidence |
|---|---|---|---|
| Prefix identity | Fresh prefix-digest equality decision | TestReaderCheckpointChangedPrefix: earlier nonterminal corruption/unsupported format must not become accepted suffix success; preserve final prefix line/suffix | «BREAK-PREFIX» |
| Fresh predecessor | Saved-base versus freshly decoded predecessor chain equality | TestReaderCheckpointAnchorAndFallback: sequence-preserving predecessor change must expose broken link despite identical current prefix | «BREAK-PREDECESSOR» |
| Accidental token damage | Checkpoint self-checksum validation | Valid-source damaged afterHash fallback case must not become spurious authoritative corruption | «BREAK-TOKEN» |
| Actual closure | Retained opt-in Close-error return | TestReaderCheckpointErrors: actual descriptor Close failure must remain observable on Close/repeated Close | «BREAK-CLOSE» |

For the close break, a separate nil-checkpoint assertion can remain protected by retained error state; describe that masking truthfully rather than making a compound mutant. There is no pre-freeze public-Service regression and no added mutant campaign for the later unchanged Reader proof. [Source: PM/t140-s5-design-ruling.json:125-136.]

## 5. Reachable serial 120-second fuzz campaigns

Each actual campaign fill supplies target/source/manifest, full command and 120-second budget, env/time, actual elapsed duration and execution count as emitted, seed/input reach evidence, exit/raw output and retained failure/corpus references. A limit is not an invented measured duration or count. PM runs serially after source settles; failures are retained and corrected under exact source binding. [Sources: PM/t140-s5-design-brief.md:209-223; PM/t140-s5-design-ruling.json:374-407.]

| Target | Changed-code reach and limit | Actual campaign |
|---|---|---|
| FuzzReaderCheckpoint | Genuine Reader-minted warm checkpoint; full-prefix identity, fresh anchor/eligibility, restored chain, bounded byte/cut/context/token changes and ordinary-reader equivalence. Checked-close execution is reachable but byte mutations do not prove actual Close failure | «FUZZ-CHECKPOINT» |
| FuzzCheckTruncation | Changed scanner/open/close/line-reader code in legacy Check and ordinary Reader; not warm checkpoint coverage | «FUZZ-TRUNCATION» |
| FuzzCheckTornTail | Changed scanner/open/close/line-reader code in legacy Check/torn-tail path; not warm checkpoint coverage | «FUZZ-TORN-TAIL» |
| FuzzCheckCorruption | Changed scanner/open/close/line-reader code in legacy Check/corruption path; not warm checkpoint coverage | «FUZZ-CORRUPTION» |

Actual descriptor-close failure proof belongs to section 3's real-file regression and section 4, not to a byte/token fuzzer. Agents Scoped/Review/Paid/Registration fuzzing is later C3 evidence for actual changed scan/drain/publication paths, not proof for this freeze. FuzzPrivateGroupReplay's inspected in-memory path does not reach these changes; exclude unless the actual final diff changes code it exercises. No package-membership-only or unrelated campaigns. [Source: PM/t140-s5-design-ruling.json:374-407.]

## 6. Frozen fixture identity and unchanged format

| Evidence | Actual result / raw manifest |
|---|---|
| Complete existing contract/ledger/testdata path-to-blob-SHA256 map at base and implementation, equality comparison and source identities | «FIXTURE-IDENTITY» |
| Existing frozen-format/catalogue/Defined/schema identities unchanged; no fixture addition/edit or golden regeneration | «FORMAT-PERIMETER» |
| Existing fixture line-ending identity/no newly introduced CR, scoped to the actual compared bytes | «FIXTURE-LINE-ENDINGS» |

Do not invoke golden update as a freeze recipe for this additive Reader capability. Preserve every existing fixture including the D149-corrected F3-13 and D154 F3-139 identities; use actual retained manifests rather than transcribing a new selected golden digest. [Sources: PM/t140-s5-design-brief.md:137-153,247; PM/t140-s5-design-ruling.json:220-230,289-346; assignment t140-s5-c1-freeze-drafter-assignment.md.]

## 7. D152 focused host lane and raw outputs

Every row must identify the exact completed source, actual command/env/start/end/duration/exit/raw path+digest and substantive observed output. The strings below specify future obligations, not executed commands. Ordinary lane is approved toolchain go1.27.3, GOTOOLCHAIN=local, empty GOFLAGS and CGO_ENABLED=0; record actual GOOS/GOARCH and tool versions. Host-only format/static; no five-target static loop absent an actual build-constrained change. Reader/scanner remains non-concurrent: no extra local race/×20 absent a real shared-state trigger. Full hosted race remains required. [Sources: docs/DECISIONS.md:3032-3044,3057-3069; PM/t140-s5-design-brief.md:226-249; PM/t140-s5-design-ruling.json:407.]

Future focused/import commands, retained here literally rather than with Markdown table escapes; none was run by this drafter:

```text
go test -count=1 -timeout 19m -v ./contract/ledger -run '^(TestReader.*|TestReadingHasNoEffects|TestGolden.*)$'
go list -f '{{join .Imports "\n"}}' ./contract/ledger
go list -f '{{join .TestImports "\n"}}' ./contract/ledger
go list -deps -f '{{if not .Standard}}{{.ImportPath}}{{end}}' ./contract/ledger
```

| Required lane | Actual receipt |
|---|---|
| Focused Reader/no-effects/existing-golden tests, exact command above | «HOST-FOCUSED» |
| One plain verbose package run: go test -count=1 -timeout 19m -v ./contract/ledger | «HOST-PLAIN» |
| Host gofmt on exact five changed Go files and gofmt -l of that same set | «HOST-FORMAT» |
| Host go vet ./contract/ledger and go tool staticcheck ./contract/ledger | «HOST-STATIC» |
| Actual direct/test/dependency imports (go list) show contract stays standard-library-only | «HOST-IMPORTS» |
| go mod tidy -diff; go mod verify; actual module-file unchanged proof | «HOST-MODULE» |
| Raw command index, failed/corrected attempts, timing records and all output hashes | «RAW-OUTPUT-INDEX» |

No routine local full tools/check, preimplementation measurement/control/diagnostic, unrelated consumer package run or shortened Core smoke is introduced here. The exact public C1 SHA receives its own full hosted integration proof next. Settled S4 checks/reviews/fuzz/publication are not reopened. [Sources: PM/t140-s5-design-ruling.json:283-288,421-429; docs/DECISIONS.md:3109-3116.]

## 8. Fresh completed-code + EXACT freeze-record joint review

| Review binding | Actual evidence |
|---|---|
| Independent reviewer, provider/model/effort/no-fallback or actual fallback provenance, request/artifact immutable path+digest | «JOINT-REVIEW-RECEIPT» |
| Exact completed implementation SHA/five-file manifest and evidence-body digest presented | «REVIEW-SUBJECT» |
| Exact R1–R4/fill-map version/digest and filled reviewable public/private record text, including factual integration slots explicitly deferred | «REVIEWED-RECORD» |
| Verbatim actual review line | «JOINT-REVIEW» |
| Blocking findings and bounded fixes/re-review if any; actual record changes adopted; no routine note-confirmation gate | «REVIEW-DISPOSITION» |

The original Astra design ruling is not this review. Require joint approval of completed code, observable evidence, compatibility and this exact freeze record. Preserve the review-submitted and final filled record bytes and digest bridge. Later factual SHA/run/publication fills cannot silently alter reviewed contract or evidence premises; any material fix/rebase gets its own affected proof/review and exact-SHA hosted result. No new ordinary owner design question is needed for this ruled nonbreaking freeze. [Sources: docs/DECISIONS.md:2139-2141,3034,3059-3060,3109-3116; PM/t140-s5-design-ruling.json:232-241,277-288.]

## 9. Actual public freeze SHA, hosted gate, main and private binding

The public register replacement contains no self-referential commit hash. Only this private evidence is later bound to the resulting public freeze subject. That subject includes the public register record and completed package code/docs before its own hosted run; final Core CI cannot retrospectively satisfy this gate. [Sources: PM/t140-s5-design-ruling.json:206-208,232-250; docs/DECISIONS.md:3109-3111.]

| Identity / integration proof | Actual evidence |
|---|---|
| Exact final public C1_FREEZE_SHA and parent | «C1-FREEZE-SHA»; «PUBLIC-FREEZE-IDENTITY» |
| Five-file implementation-to-freeze hash bridge, exact public register delta and any explicitly identified comment-only record delta | «CODE-HASH-BRIDGE» |
| Fresh exact-final-SHA review binding to the joint approved code/record and any affected review correction | «EXACT-SHA-REVIEW-BINDING» |
| Own hosted workflow URL/ID/attempt, head SHA, classifier/full-matrix selection, exact jobs/raw results and race evidence for Windows/Linux/macOS | «HOSTED-FULL-MATRIX» |
| Actual aggregate Check result on that SAME SHA, with completion time and raw receipt | «C1-HOSTED-RESULT» |
| Actual guarded work-branch publication, approved checked-SHA fast-forward and public main/remote SHA receipt | «C1-MAIN-PUBLICATION» |
| Final private D/evidence paths and digests bound to public SHA, review and hosted receipts | «PRIVATE-BINDING» |
| Actual private records commit/remote receipt, external to its own commit bytes if needed to avoid self-reference | «PRIVATE-PUBLICATION-RECEIPT» |
| PM's explicit C1-to-C3 release record after all preceding evidence exists | «CORE-RELEASE-RECEIPT» |

A successful document-exempt aggregate without the full three-OS/race matrix is not this milestone. Failed/cancelled/missing prerequisite jobs cannot fill success. A fix or rebase changes the SHA: retain old outputs and obtain that new subject's own affected review/evidence and hosted success. Only after the integrated freeze and private binding are recorded may ANY new-API consumer implementation/tests begin in the same assignment. [Sources: docs/DECISIONS.md:3057-3069,3109-3116; PM/t140-s5-design-ruling.json:243-288.]

## 10. Remaining final assignment gates, not C1 claims

Core later consumes only this integrated frozen capability. Its cache remains one copied fixed-key checkpoint inside the existing single 256-entry/8-MiB charged-metadata limit (not an RSS bound), with ruled exact-after charging/invalidation, scoped-only opt-in and review opt-out. Actual warmed Service refusal/no-effects/charge and consumer race/fuzz evidence come then. Unchanged C1 local/mutant/fixture/fuzz evidence is reused by exact source binding, not recertified routinely. [Sources: PM/t140-s5-design-ruling.json:62-96,253-288.]

Final combined SHA needs independent final Standards and Specification/code-evidence review, its separate full hosted three-OS/race/Check result, and the original three-or-five-instance protocol on actual new combined code. Two startup bounds remain independently T11/T12 median(OpenLong_i / actual Open-record ratio_i) <= median(OpenShort_i); five operation bounds remain turn.start/local.admit/local.begin/task.create/task.cancel median(long) <= 2*median(short)+25ms, cancellation from paired profile_cleanup. Exactly three eligible complete instances per driver; extend ONCE to exactly five only if paired differences straddle zero AND the median is within 10% of its bound, without adding slack. Retain original six driver hashes/traffic, T11 populations12→20/held turns1→3/burst16/complete ten-operation cycles to actual B×10, T12 factor2/populations/four profiles, serial fresh colonies and five-second pre/post unrelated CPU <=0.25 core. Retain invalid/interrupted/failed attempts; slowness is not exclusion. First unchanged complete eligible T11 final run also supplies real program smoke; no extra diagnostic/control run is implied. Reuse eligible 93e8f0afe125b1ea8e87f4b8336664dd390c5b3a controls under unchanged method/environment. [Sources: PM/t140-s5-design-brief.md:259-286; PM/t140-s5-design-ruling.json:265-288,408-420.]

Historical S4 failures and the CPU diagnostic remain distinct nonacceptance authorities. This C1 record establishes no new numerical pass, Ticket140 closure, provider/executor/capacity/delivery/power-loss/SLA claim or permission for a sixth slice. Failure retains evidence and stops; there is no automatic larger cache/snapshot/threshold/traffic change. Whole-ticket Fable verification and ticket-close review remain separate. [Sources: docs/DECISIONS.md:3095-3116; PM/t140-s5-design-ruling.json:408-444.]

## 11. Future-fill contract

All future-value slots are filled only from actual immutable source/command/review/publication receipts. The complete field-by-field map, copy destinations and fill timing are in the companion local `t140-s5-c1-freeze-outstanding.md`; the applied evidence must contain none of the placeholder tokens. Multi-value receipt fills include exact paths, SHA256s and source citations, not unsourced PASS prose. Preserve UTF-8/LF. The drafter did not compute any new hash, run a command, inspect changing source as evidence, write repository/private records or allocate a D/B number.

### Drafter choices and unresolved facts

- **P1:** keep original brief/ruling/question/selection/provenance/D155–D156/publication as separate byte-retained authorities, not merged rewritten approvals. Sources: docs/DECISIONS.md:3113-3116; PM/t140-s5-design-ruling-binding.json:1-37.
- **P2:** Reader-only pre-freeze semantic proof, exactly four isolated reds/restores/same-command greens and four actual-reach fuzz campaigns. Sources: PM/t140-s5-design-ruling.json:125-136,347-407.
- **P3:** review and hash-bind the completed capability plus exact freeze text; defer actual public SHA/hosted/main/private facts, not capability completion. Sources: docs/DECISIONS.md:2139-2141,3109-3111; PM/t140-s5-design-ruling.json:232-288.
- **P4:** final combined numerical and closure gates remain future, never imported from S4 or C1 evidence. Sources: docs/DECISIONS.md:3098-3116; PM/t140-s5-design-ruling.json:408-444.
- **Unresolved facts:** all implementation/proof/run/review/final-SHA/publication/number/date fills. They await the authorized PM evidence and application phases; no missing design choice is asserted.
