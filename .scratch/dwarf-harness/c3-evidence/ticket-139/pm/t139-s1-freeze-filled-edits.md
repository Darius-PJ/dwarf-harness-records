# Ticket139 — proposed D125 freeze-record edits

Proposed record: code, local, fuzz, fixture and Core-probe facts below are observed; fresh joint review APPROVED the completed contract and all14 edits with no blocking findings. The subsequent hosted gate is pending. No number, freeze, integration or ticket close is asserted. Primary coordinates numbering/application. All public finds are copied from the 139-registration worktree; private finds are copied from main. Reanchor changed source before applying.

## Edit index

| Visibility | Edits | Repository-relative path |
|---|---|---|
| Private records only | R1–R2 | `docs/DECISIONS.md` |
| Public | R3–R7 | `docs/CONTRACTS.md` |
| Public | R8 | `docs/DESIGN-CORE-AND-LAUNCHERS.md` |
| Public, comment only | R9 | `contract/ledger/registration.go` |
| Public, comment only | R10 | `contract/ledger/catalogue.go` |
| Public, comment only | R11–R12 | `contract/ledger/doc.go` |
| Public, comment only | R13 | `contract/ledger/registration_submission.go` |
| Private records only | R14 | `.scratch/dwarf-harness/c3-evidence/f3-139-freeze-evidence.md` |

Apply R1 before R2. Their anchors are distinct: the current tail versus D125's final See also line. For R1, the tail fill must equal its Find byte for byte, preserving the historical line; if main's tail advances, reanchor R1's Find and fill together at the new tail. Never publish the private paths with the project branch. No ticket, roadmap-status, owner-packet or B-entry edit is included.

## Public edits

#### R3 — docs/CONTRACTS.md
Add F3-139 to the ledger-format definition without changing earlier families.
Find:
````
F3-13, ticket 13's part of F3, adds eight version-1 `runtime.` types below by addition (D148); it changes no earlier type, F0 or the format version.
````
Replace:
````
F3-13, ticket 13's part of F3, adds eight version-1 `runtime.` types below by addition (D148); it changes no earlier type, F0 or the format version. F3-139, ticket 139's part of F3, adds four version-1 `runtime.` types below by addition (D«D-NEXT»): resource registration, work-domain registration, declaration change and registration receipt; its schema-5 canonical submission has three CAS operations, and it changes no earlier type, rule, golden, schema 1–4, F0 or the format version.
````

#### R4 — docs/CONTRACTS.md
Add C3's F3-139 payload ownership to the ledger-format register.
Find:
````
C3 (F3-10, F3-11, F3-12 and F3-13 payload specifications)
````
Replace:
````
C3 (F3-10, F3-11, F3-12, F3-13 and F3-139 payload specifications)
````

#### R5 — docs/CONTRACTS.md
Append F3-139 to the existing ledger-format status cell.
Find:
````
F3-12 (D144); F3-13 (D148) |
````
Replace:
````
F3-12 (D144); F3-13 (D148); F3-139 (D«D-NEXT») |
````

#### R6 — docs/CONTRACTS.md
Move only the registration/declaration family out of C3's later-family list.
Find:
````
| C3 | F3-10's private-state identity, revision and receipt records (D139), F3-11's grant, task, capacity, work, usage, scoped private-revision and receipt records (D140), F3-12's review and failure request, result and receipt records (D144) and F3-13's paid route, credential, spend, attempt, dispatch-intent, result, overrun-acknowledgement and receipt records (D148) are frozen (catalogues below); later turn and context state beyond admission; generic first-action/continuation/ordinary-work eligibility guards; per-agent service-loss and outage state with cause, onset and restoration (Core §13.11); registered shared resources and owner-registered work domains (B32) | Bound to actor/context/operation and current authority; actual ready/blocked/active task facts, not animation; later C8 alignment integrates these guards without a backward whole-C8/GUI dependency. Service loss comes from actual refusals and execution failures, never a probe or model call, and does not make base C3 wait for R1 or C8 |
````
Replace:
````
| C3 | F3-10's private-state identity, revision and receipt records (D139), F3-11's grant, task, capacity, work, usage, scoped private-revision and receipt records (D140), F3-12's review and failure request, result and receipt records (D144), F3-13's paid route, credential, spend, attempt, dispatch-intent, result, overrun-acknowledgement and receipt records (D148) and F3-139's external-resource registration, work-domain registration, scoped declaration and receipt records (B32, D«D-NEXT») are frozen (catalogues below); later turn and context state beyond admission; generic first-action/continuation/ordinary-work eligibility guards; per-agent service-loss and outage state with cause, onset and restoration (Core §13.11) | Bound to actor/context/operation and current authority; actual ready/blocked/active task facts, not animation; later C8 alignment integrates these guards without a backward whole-C8/GUI dependency. Service loss comes from actual refusals and execution failures, never a probe or model call, and does not make base C3 wait for R1 or C8 |
````

#### R7 — docs/CONTRACTS.md
Append the four-type F3-139 catalogue and its observed generated-fixture inventory after the F3-13 table.
Find:
````
| seqs 45, 48, 51, 54, 57, 60, 63, 66, 75, 78, 81, 84, 87, 90, 93, 96, 99, 102, 105, 108, 111, 114, 117, 120, 123, 126, 129, 132, 135, 138, 141, 144, 147, 150 |
````
Replace:
````
| seqs 45, 48, 51, 54, 57, 60, 63, 66, 75, 78, 81, 84, 87, 90, 93, 96, 99, 102, 105, 108, 111, 114, 117, 120, 123, 126, 129, 132, 135, 138, 141, 144, 147, 150 |

**F3-139 catalogue (C3, D«D-NEXT»).** Ticket 139 adds the following four version-1 types to `ledger-format` version 1 in C3's `runtime.` namespace. C3 owns the payload specifications. The designated producer is Core's agent service, and its only permitted appender caller is `internal/core/agents`, through `ledgerstore.Submit` (enforced by review). Contract availability is not an operational producer or graph projection: ticket 139's S2 implements the producer after this freeze; Ticket61's later reader still needs independent authorization. Core owner metadata queries and replay consume all four types.

The F3-139 section of the `contract/ledger` package documentation specifies the payloads, strict codecs, nested values, record/group rules and schema-5 canonical submission. Its three CAS operations are `resource.set`, `work_domain.set` and `declaration.set`, with the target bound by the operation and concrete arguments, not a redundant target field. Each transition is exactly one owner-origin `[ledger.command, matching effect, runtime.registration_receipt]` commit. The complete payload/submission cap is 65,536 bytes, including ignored input extensions.

A resource registration has a UUID identity separate from its explicit, immutable, exact F3-11 external address. The owner/host supplies nonsecret opaque identity, not a URL, account identifier or credential; the byte grammar is not a secret detector. Existing opaque keys, including `paid-route/<UUID>`, need no provider configuration, credential or earlier registration for a grant. Addresses are unique among resource registrations; resource, work-domain and declaration UUIDs occupy separate kind namespaces. Audiences and pinned source versions scope evidence, never permission; declarations replace their complete task/context consumer set, with an empty set withdrawing its edges. All known fields, required envelope bindings, canonical submission and actual effect/receipt sequences are replay-essential. The implementation/APIs, the two producer population limits/defaults and later families, graph/action facts, views and provider work are outside this freeze; earlier schemas, types, rules and goldens are unchanged.

The golden is `contract/ledger/testdata/f3/139/log/00000000000000000001.jsonl` (19 commits, 65 records; SHA-256 `db1476e07b355d909dfb07cce79f142387469618709bc52a3f496395b94c5134`), with generated object/body fixtures beside it. Its earlier-family setup includes a real root grant before any registration. The observed inventory below supplies exact type sequences, shapes and fixture digests.

| Type, version 1 | Payload owner | Producer | Permitted appender caller | Consumers | Privacy class | Replay-essential fields | Golden sample |
|---|---|---|---|---|---|---|---|
| `runtime.resource_registered` | C3 | Core's agent service, on owner CAS of a resource registration | `internal/core/agents` only, through `ledgerstore.Submit` (review) | Core owner metadata queries/replay; Ticket61's later independently authorized reader | access-filtered opaque registration identity, exact nonsecret external address, version and audience metadata; no private content | required identity/group envelope; all known payload fields; actual effect sequence | resource creation and audience revisions; observed inventory below |
| `runtime.work_domain_registered` | C3 | as above, on owner CAS of a work-domain registration | as above | as above | access-filtered opaque identity, version and audience metadata; no private content | required identity/group envelope; all known payload fields; actual effect sequence | domain creation and audience revision; observed inventory below |
| `runtime.declaration_changed` | C3 | as above, on owner CAS replacing a declaration's complete consumer set | as above | as above | access-filtered declaration identity, version, pinned source, audience and task/context consumer metadata; no private content | required identity/group envelope; all known payload fields; actual effect sequence | both source kinds × both consumer kinds, mixed consumers, source repins and empty withdrawals; observed inventory below |
| `runtime.registration_receipt` | C3 | as above, last in each registration/declaration group | as above | as above; original-command receipt lookup | access-filtered command, canonical submission, digest, outcome and resulting-version metadata; no private content | required identity/group envelope; all known payload fields; re-encoded submission/digest binding; actual receipt sequence | every schema-5 operation and group; observed inventory below |

| Type, version 1 | Observed sequences | Covered shapes |
|---|---|---|
| `runtime.resource_registered` | 25, 43, 61 | create and two audience revisions; UUID distinct from exact paid-route opaque address |
| `runtime.work_domain_registered` | 28, 46 | create and audience revision |
| `runtime.declaration_changed` | 31, 34, 37, 40, 49, 52, 55, 58, 64 | both source kinds × both task/context consumer kinds, mixed consumers, source repins and empty withdrawals |
| `runtime.registration_receipt` | 26, 29, 32, 35, 38, 41, 44, 47, 50, 53, 56, 59, 62, 65 | all14 applied schema-5 operations; effect sequence immediately precedes its receipt |

| Generated fixture | Bytes | SHA-256 | Terminator |
|---|---:|---|---|
| `contract/ledger/testdata/f3/139/bodies/e94d3c7b4a8a8627e15a761daba3f8077fb32efb96e4260a09563d9c357158b5` | 41 | `e94d3c7b4a8a8627e15a761daba3f8077fb32efb96e4260a09563d9c357158b5` | LF; no CR |
| `contract/ledger/testdata/f3/139/log/00000000000000000001.jsonl` | 63815 | `db1476e07b355d909dfb07cce79f142387469618709bc52a3f496395b94c5134` | LF; no CR |
| `contract/ledger/testdata/f3/139/objects/a9d748d84941c6117611a40dd7163c239e08fa6dd823f538ba68b3513605720b` | 6 | `a9d748d84941c6117611a40dd7163c239e08fa6dd823f538ba68b3513605720b` | LF; no CR |
| `contract/ledger/testdata/f3/139/objects/e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855` | 0 | `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855` | intentionally empty; no terminator; no CR |

The new log contains55 distinct UUID tokens; none occurs in the13 earlier golden logs. The only shared64-hex tokens are the all-zero predecessor sentinel, the instructions-object digest `a9d748d84941c6117611a40dd7163c239e08fa6dd823f538ba68b3513605720b`, and the empty-object digest `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`. This is token overlap, not a claim that content-addressed objects acquire new identity in each chapter.

````

#### R8 — docs/DESIGN-CORE-AND-LAUNCHERS.md
Extend only Core §13.1's F3 family list.
Find:
````
then F3-13's eight version-1 paid route, credential, spend, attempt, dispatch-intent, result, overrun-acknowledgement and receipt types (D148); later F3 families freeze before their own producers;
````
Replace:
````
then F3-13's eight version-1 paid route, credential, spend, attempt, dispatch-intent, result, overrun-acknowledgement and receipt types (D148), then F3-139's four version-1 types, `runtime.resource_registered`, `runtime.work_domain_registered`, `runtime.declaration_changed` and `runtime.registration_receipt` (D«D-NEXT»), whose scoped registration/declaration evidence changes no grant authority; later F3 families freeze before their own producers;
````

#### R9 — contract/ledger/registration.go
Change only the new record-family status comment.
Find:
````
// F3-139's version-1 records are proposed for freeze (D125).
````
Replace:
````
// F3-139's version-1 records are frozen (D«D-NEXT»).
````

#### R10 — contract/ledger/catalogue.go
Change only the new family's catalogue status comment; retain all fifty-three entries.
Find:
````
// proposed for freeze (D125): TypeRuntimeResourceRegistered,
````
Replace:
````
// frozen (D«D-NEXT»): TypeRuntimeResourceRegistered,
````

#### R11 — contract/ledger/doc.go
Change only the F3-139 Catalogue overview line; retain its complete fifty-three-type overview.
Find:
````
// F3-139 is ticket 139's part of F3, proposed for freeze (D125),
````
Replace:
````
// F3-139 is ticket 139's part of F3, frozen (D«D-NEXT»),
````

#### R12 — contract/ledger/doc.go
Change only the F3-139 specification's status comment.
Find:
````
// proposed for freeze (D125). This addition does not change format version 1,
````
Replace:
````
// frozen (D«D-NEXT»). This addition does not change format version 1,
````

#### R13 — contract/ledger/registration_submission.go
Change only the schema-5 submission status comment.
Find:
````
// RegistrationSubmission is schema 5's canonical owner request, proposed for
// freeze (D125). Arguments is the matching concrete value, never arbitrary JSON.
````
Replace:
````
// RegistrationSubmission is schema 5's canonical owner request, frozen
// (D«D-NEXT»). Arguments is the matching concrete value, never arbitrary JSON.
````

## Private edits

#### R1 — docs/DECISIONS.md
Append the short assistant-origin D125 freeze entry after the current tail, preserving that line verbatim.
Find:
````
- **Changes:** this entry and four one-line amendments; AGENTS.md's Check/Commits lines; private evidence; the five managed process skills. The workflow branch updates README, Core §8.2 and tickets139/140. Prepared Markdown followthrough 93e8f0a updates README/dispatch wording, code-slice wording, ROADMAPS integration rule 3 and the paired C3 Status/board without closing ticket13; it follows workflow promotion and requires its own exact-SHA aggregate and document check.
````
Replace:
````
- **Changes:** this entry and four one-line amendments; AGENTS.md's Check/Commits lines; private evidence; the five managed process skills. The workflow branch updates README, Core §8.2 and tickets139/140. Prepared Markdown followthrough 93e8f0a updates README/dispatch wording, code-slice wording, ROADMAPS integration rule 3 and the paired C3 Status/board without closing ticket13; it follows workflow promotion and requires its own exact-SHA aggregate and document check.

### D«D-NEXT». F3-139 registration and declaration records frozen

- **Date:** «DATE». **Decided by:** assistant. Under D125, the project manager freezes the completed contract without an owner question or packet. The amended Ticket139 ruling governs (the amended design ruling, retained with the whole-ticket packet and to be archived as `.scratch/dwarf-harness/c3-evidence/ticket-139-design-ruling.md` at close); design approval is not completed-contract approval. **Joint S1/specification/fixtures/evidence/record review, by GPT-6 Astra as temporary stand-in for Fable:** GPT-6 Astra, acting as a temporary stand-in for Claude Fable 5.1, approves Ticket139 S1 at 86f952cfcae37bde06767c6c4eaa615a503dd96d, parent 82d8d48856c7191019625c9f6e896d10b9b8498c, jointly with its completed F3-139 specification, generated fixtures, observed evidence and proposed 14-edit D125 freeze record. No blocking findings remain. This is technical approval for PM freeze recording, not a claim that the freeze has landed or D153 integration gates have passed. Fable remains the main advisor; its whole-ticket double-check after reset is pending.
- **Decision:** add four version-1 types to `ledger-format` version 1: `runtime.resource_registered`, `runtime.work_domain_registered`, `runtime.declaration_changed` and `runtime.registration_receipt`. Freeze their documented strict codecs, shapes, ordered sets, versions and 65,536-byte complete payload/submission cap (`contract/ledger/doc.go:2560-2745`). C3 owns payloads; only Core's agent service through `ledgerstore.Submit` produces them. Consumers are Core owner metadata queries/replay and Ticket61's later independently authorized reader; all known fields and required envelope/submission/receipt bindings are replay-essential.
  - Freeze schema 5's three CAS operations, `resource.set`, `work_domain.set` and `declaration.set`, canonical root `schema, actor, origin, operation, arguments`, documented compact known-field SHA-256 encoding, and exactly `[F0 command, matching effect, registration receipt]` with common owner/origin/command bindings. Operation/concrete arguments bind the target without a redundant target field.
  - The registration UUID and explicit opaque F3-11 external address are separate. Exact immutable/unique address ownership is service enforcement, not codec history lookup. No URL/account/credential semantic inputs, resolver or derived-key fallback; the grammar is not a secret detector. Identities are kind-namespaced. Registered audiences scope evidence, never permission; declarations pin the source version current at commit, obey source/task/context audience constraints and completely replace consumers, including withdrawal. Source revisions do not retarget declarations; existing grants remain independent.
- **Not frozen:** implementation/APIs; `MaxRegistrations`/`MaxDeclarations` and their 256/1024 defaults; later families, graph/action facts, views, provider work, `launcher-protocol` and `context-module`. Population limits do not constrain replay or matching retries. Earlier schemas 1–4, types, rules and goldens are unchanged.
- **Evidence:** code `86f952cfcae37bde06767c6c4eaa615a503dd96d`, base `82d8d48856c7191019625c9f6e896d10b9b8498c`; the [evidence file](../.scratch/dwarf-harness/c3-evidence/f3-139-freeze-evidence.md) separately records the final public freeze-record SHA/hosted gate. The generated 19-commit/65-record golden, SHA-256 `db1476e07b355d909dfb07cce79f142387469618709bc52a3f496395b94c5134`, places a real F3-11 root grant before registration and covers all registration/declaration shapes, revisions, mixed consumers, source repins and withdrawals. That file gives observed sequences/all fixture hashes, D152 focused checks/PM fuzz, unchanged earlier fixtures including D149, and actual Core positive/negative prerequisite-probe/restoration evidence; the probe does not validate the later registration reducer.
- **Consequences:** additive-only under D40; breaking changes still need the owner. This D125 freeze is S1's D41 sign-off, not D52 readiness or operational producer/graph/provider proof. D153 gates exact-final-public-SHA integration. Retain whole-ticket Fable verification after the temporary stand-in review.
- **Changes:** `CONTRACTS.md` definition/ownership/status, C3 B2 row and catalogue; Core §13.1; five comment-only status edits across `registration.go`, `registration_submission.go`, `catalogue.go` and `doc.go`; this entry, D125's pointer and the evidence file. No ticket-close or roadmap-status change.
````

#### R2 — docs/DECISIONS.md
Add one pointer after D125's final existing See also line without rewriting its body.
Find:
````
- **See also:** D148 records the project manager's freeze of F3-13, ticket 13's paid route, credential, spend, attempt and settlement record family, under this entry.
````
Replace:
````
- **See also:** D148 records the project manager's freeze of F3-13, ticket 13's paid route, credential, spend, attempt and settlement record family, under this entry.
- **See also:** D«D-NEXT» records the project manager's freeze of F3-139, ticket 139's external-resource registration, work-domain registration, declaration and receipt family, under this entry.
````

#### R14 — .scratch/dwarf-harness/c3-evidence/f3-139-freeze-evidence.md
Create the private completed-contract evidence record, with observations filled only from retained execution/review evidence.
Find:
````
````
Replace:
````
# F3-139 freeze evidence — Ticket139 S1

Freeze D«D-NEXT», «DATE». Contract-code subject: `86f952cfcae37bde06767c6c4eaa615a503dd96d`; actual base: `82d8d48856c7191019625c9f6e896d10b9b8498c`. The final public freeze-record SHA is a distinct subject in the D153 hosted section below, not a self-reference to this private record. The amended ruling governs (the amended design ruling, retained with the whole-ticket packet and archived at ticket close); D125 requires joint review of the completed contract, fixtures, evidence and proposed record, not design approval alone.

## Scope and subjects

S1 adds four version-1 codecs/catalogue entries, schema 5 and the generated chapter-139 log/object/body fixtures under `contract/ledger`. The authorized compatibility-test cutovers delete only the obsolete internal catalogue-length assertion in `paid_compatibility_test.go` and replace `catalogue_test.go`'s stale private-map equality with public `Defined().Contains` version-admission checks, preserving the existing wire-type/version, invalid-input and fixture-rejection coverage (PM answers 1–2 in the retained ticket notes). No count is repinned. Probe-only agents test/helper changes must be removed/restored before final hashes. The final changed-path/hash inventory is in V6; it must match the committed subject.

The retained evidence root is `C:/Users/darius.jones/worktrees/dwarf-harness/t139-s1-evidence`; complete command records are commands.json/final-commands.txt, final coder report is yield.json, and PM commit/fixture/earlier-golden/fuzz proofs are retained in the secondary PM packet. The command records identify actual invocations, environment, exit, duration and retained output. The assigned production environment is Go 1.27.3, `GOTOOLCHAIN=local`, empty `GOFLAGS`, explicit `CGO_ENABLED=0`, host windows/amd64. D152 applies focused local evidence: no S1 local race/×20 because this is codec-only, no five-target static work without build-constraint changes, no duplicate local full gate or unrequested measurement. The PM owns the affected 120-second fuzz campaign. Actual observations belong in the result cells, not inferred from these requirements.

## D152 focused evidence

| Step and required coverage | Observed result and retained evidence |
|---|---|
| V1 — coder's final `gofmt -l` on owned Go files, host `go vet` and host staticcheck for `./contract/ledger`; tested-tree/final-blob agreement | PASS: final owned-only `gofmt -l` on9 Go files had empty output (14-format_check.log); `go vet ./contract/ledger` exit0,0.624s (15-vet.log); `go tool staticcheck ./contract/ledger` exit0,2.291s (16-staticcheck.log). Final tested-tree hashes match all13 committed blobs; see committed changed-path inventory and commit proof. |
| V2 — focused new codec/canonicalization/boundary tests and fuzz seeds; one plain verbose `./contract/ledger` package run; actual `./internal/core/ledgerstore` consumer run | PASS: focused `go test -count=1 -v -timeout=19m ./contract/ledger -run ^(TestRegistration.*\|TestGoldenF3_139\|FuzzDecodeF3_139)$` exit0,2.579s Go/3.709s wall (04-focused.log), including92 fuzz seeds; final plain verbose package exit0,9.325s Go/13.633s wall (12-package.log); real ledgerstore consumer exit0,33.500s Go/35.914s wall (13-consumer.log). The first package failure was the obsolete private-map assertion, corrected as recorded; not an intentional mutation proof. All original logs are retained. |
| V3 — PM `go test ./contract/ledger -run '^$' -fuzz '^FuzzDecodeF3_139$' -fuzztime=120s` on the finalized code subject; executions, interesting inputs and corpus disposition | PASS on code SHA `86f952cfcae37bde06767c6c4eaa615a503dd96d`: `go test -count=1 -timeout=19m ./contract/ledger -run ^$ -fuzz ^FuzzDecodeF3_139$ -fuzztime=120s -parallel=1`, exit0;1,449,126 executions,21 new interesting inputs,total113;122.741s Go/131.144s process wall. No failing input or permanent target corpus directory; normal interesting inputs remain in Go fuzz cache.13 source hashes unchanged. Exact argv/env/result and raw output: pm-fuzz-result.json, pm-FuzzDecodeF3_139.log. |
| V6 — actual dependency/import audit and every changed path/final file hash against S1's actual base; standard-library-only additions; count-assertion deletion listed among removed assertions | PASS: production/test imports are standard-library only; nonstandard production closure is contract/ledger itself (18-imports.log,19-test_imports.log,20-dependencies.log). Exact13 changed paths/hashes below. The paid catalogue cardinality pin was deleted, not repinned; catalogue private-map equality became public version-admission checks, with old admission/error/fixture cases retained. Initial go-list runner-template quoting failure17-imports.log was corrected only in the disposable runner; final18–20 passed. |
| V7 — `go mod tidy -diff`, `go mod verify`, and comparison showing whether `go.mod`/`go.sum` changed | PASS: `go mod tidy -diff` exit0 with empty output (21-tidy.log); `go mod verify` exit0, all modules verified (22-verify.log); go.mod/go.sum unchanged from captured baseline (23-hashes.log). No dependency added. |
| V8 — new `TestGoldenF3_139 -update`, then all `TestGolden` regeneration; generated/committed-byte equality and unchanged earlier fixtures against their authoritative freeze digests | PASS: `TestGoldenF3_139 -update` exit0 (03-generate.log), then all `TestGolden -update` exit0 (05-goldens.log); all42 earlier fixture bytes unchanged (06-old_proof.log). New four fixtures equal committed blobs. PM comparison confirms all13 earlier log digests against D111/D115/D118/D119/D123/D124/D130/D139/D140/D144/D149; see comparison table and retained authoritative-golden proof. |
| V9 — SHA-256 and byte-level CR/LF inspection of every new generated log/object/body fixture; distinguish LF-terminated content from intentional no-terminator files | PASS: every new generated file was inspected as bytes and hash-bound to the code subject; no CR in any of the four. Log63,815bytes, instructions6bytes and body41bytes end LF; the0byte empty object intentionally has no terminator. Per-file digests/terminators are in the generated inventory; coder23-hashes.log and PM fixture inventory retained. |

Coder report fullGate.reason uses stale local-gate wording: no local full gate ran or will be duplicated; D153 hosted Check result is the integration gate. No local V4, race result, full-check substitute or Markdown-only amend is supplied. D153's exact-final-public-SHA hosted gate is separate below. No irrelevant permission/credential/money/sandbox mutation campaign is required for this codec-only slice; the specific earlier-family semantic negative control is required.

## Committed changed-path hashes

All13 files below match final tested-tree bytes and committed blobs at `86f952cfcae37bde06767c6c4eaa615a503dd96d`; the actual parent is `82d8d48856c7191019625c9f6e896d10b9b8498c`. No permanent Core path changed.

| Path | SHA-256 |
|---|---|
| `contract/ledger/catalogue.go` | `c858bb6ae564f60501091d48070a0a9f8e51be544a20ca756148dca656f029c0` |
| `contract/ledger/catalogue_test.go` | `8c042f0265260fed837ca1ab532113ddda4eab033c36ec0d995286ac555d939f` |
| `contract/ledger/doc.go` | `153bfbe24ba06252606ede402c7de74b7d9f9ceadcd48ed5ecd50ba315caa457` |
| `contract/ledger/paid_compatibility_test.go` | `3e236cb3bbd2006ffae0582215c476c26e8ac492e354fd85e3f87daba812e8f7` |
| `contract/ledger/registration.go` | `02345d1412c33261df9ad5f22e037fd58ae5dda67df2d02ba9e340519a237715` |
| `contract/ledger/registration_fuzz_test.go` | `56693358dc9bad9cd1990bba6d75dcb2ac9b91acf7c7d4fd8e2343414ba6d10f` |
| `contract/ledger/registration_golden_test.go` | `f4d9b5778d2936b4ccada58e549a746dd25f6a27289624c0cd4c898f5fca8c37` |
| `contract/ledger/registration_submission.go` | `219fe33b301ac334014429c4949ce29d2fb309718e16721a9cd7b5edf702d3f3` |
| `contract/ledger/registration_test.go` | `42185f48ec0e51721742527706a138ed5144bed8f20f2c1572835d2c66f5a48b` |
| `contract/ledger/testdata/f3/139/bodies/e94d3c7b4a8a8627e15a761daba3f8077fb32efb96e4260a09563d9c357158b5` | `e94d3c7b4a8a8627e15a761daba3f8077fb32efb96e4260a09563d9c357158b5` |
| `contract/ledger/testdata/f3/139/log/00000000000000000001.jsonl` | `db1476e07b355d909dfb07cce79f142387469618709bc52a3f496395b94c5134` |
| `contract/ledger/testdata/f3/139/objects/a9d748d84941c6117611a40dd7163c239e08fa6dd823f538ba68b3513605720b` | `a9d748d84941c6117611a40dd7163c239e08fa6dd823f538ba68b3513605720b` |
| `contract/ledger/testdata/f3/139/objects/e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855` | `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855` |

## Earlier golden comparison

All42 earlier fixtures remained byte-identical after all-golden regeneration and in the committed subject. The13 log digests were separately compared with their authoritative freeze entries, not with the superseded F3-13 digest from D148.

| Earlier log | Freeze | SHA-256 |
|---|---|---|
| `contract/ledger/testdata/f0/catalogue/log/00000000000000000001.jsonl` | D111 | `319c805312afd1abf824d306bcd799dd42bd3ae04fdf33fb74bc3f742ac8c898` |
| `contract/ledger/testdata/f0/log/00000000000000000001.jsonl` | D111 | `c72c4a739965586d984b524dbc6ee67a5b9d866756639fbb03b04e90f441f2e5` |
| `contract/ledger/testdata/f0/log/00000000000000000005.jsonl` | D111 | `3ee9f566e69e9cccb89ed435afee322950d3084a69ed0301684c15be70f8e65b` |
| `contract/ledger/testdata/f2/05/log/00000000000000000001.jsonl` | D115 | `843663a168e472adf4656fdba4ffa6db770e588feec0020bb10e20bf14def437` |
| `contract/ledger/testdata/f2/06/log/00000000000000000001.jsonl` | D118 | `014cc612076390934fa8a668117c353c5cca2630a3b3fd90364a29542b96f40d` |
| `contract/ledger/testdata/f2/07/log/00000000000000000001.jsonl` | D119 | `96de91f92432040683157279432512810c2dd27d36012695be46dd1eccac88c5` |
| `contract/ledger/testdata/f2/08/log/00000000000000000001.jsonl` | D123 | `985e073a342d9f991fdd2afd407dc495c3542020c98e35d3079018e29db14b8c` |
| `contract/ledger/testdata/f2/09/log/00000000000000000001.jsonl` | D124 | `f1a0c473ee410c189c743547f37c86ebd638ce9c92c68cd44d1b2816f9f3ad88` |
| `contract/ledger/testdata/f3/10/log/00000000000000000001.jsonl` | D139 | `9622b72877ed546a18fcbfd28a19807e0bab237909e23ffe76e7c3da1c260ecd` |
| `contract/ledger/testdata/f3/11/log/00000000000000000001.jsonl` | D140 | `145bb11c2b1c58e9e8530a98e6972b35329e4adb9dfb945a9f15381ae221bba6` |
| `contract/ledger/testdata/f3/12/log/00000000000000000001.jsonl` | D144 | `6586720b28a19f997dd0890a6dbc71d27ffdf395fd000e68b6aedbbbe0ce79f8` |
| `contract/ledger/testdata/f3/13/log/00000000000000000001.jsonl` | D149 | `50b41cf739cbef89bec234cf64873e80af85188b256c66d6cb1e86ebea3555ff` |
| `contract/ledger/testdata/u3/61/log/00000000000000000001.jsonl` | D130 | `6c7169aa9cfe77bb8976348f515ef85ec8da82b277520f82fd2bf169e6c45e0f` |


## Generated fixture inventory

`contract/ledger/testdata/f3/139/log/00000000000000000001.jsonl`: 19 commits/65 records; observed committed SHA-256 `db1476e07b355d909dfb07cce79f142387469618709bc52a3f496395b94c5134`. The generator, not hand-edited JSONL, defines the fixture and its positional IDs/times/hash chain (`contract/ledger/registration_golden_test.go:18-188,191-238`).

Five prerequisite commits/23 records register two agents/general contexts, create a work context and a real unassigned owner task with its body, then issue a real F3-11 owner root grant. The grant uses the exact opaque address `paid-route/` plus `id(0x450)` before resource `id(0x400)` is registered; no paid route/provider record is needed. Fourteen new-family commits/42 records cover resource/domain creation and audience revisions, resource→task, resource→context, domain→task and domain→context declarations, mixed consumers, current-source repins, empty withdrawals and later widening. The ruled first effect/receipt is 25/26 and final effect/receipt 64/65; the inventory supplies actual generated positions for every wire type, not positions guessed independently of the generator.

| Type, version 1 | Observed sequences | Covered shapes |
|---|---|---|
| `runtime.resource_registered` | 25, 43, 61 | create and two audience revisions; UUID distinct from exact paid-route opaque address |
| `runtime.work_domain_registered` | 28, 46 | create and audience revision |
| `runtime.declaration_changed` | 31, 34, 37, 40, 49, 52, 55, 58, 64 | both source kinds × both task/context consumer kinds, mixed consumers, source repins and empty withdrawals |
| `runtime.registration_receipt` | 26, 29, 32, 35, 38, 41, 44, 47, 50, 53, 56, 59, 62, 65 | all14 applied schema-5 operations; effect sequence immediately precedes its receipt |

| Generated fixture | Bytes | SHA-256 | Terminator |
|---|---:|---|---|
| `contract/ledger/testdata/f3/139/bodies/e94d3c7b4a8a8627e15a761daba3f8077fb32efb96e4260a09563d9c357158b5` | 41 | `e94d3c7b4a8a8627e15a761daba3f8077fb32efb96e4260a09563d9c357158b5` | LF; no CR |
| `contract/ledger/testdata/f3/139/log/00000000000000000001.jsonl` | 63815 | `db1476e07b355d909dfb07cce79f142387469618709bc52a3f496395b94c5134` | LF; no CR |
| `contract/ledger/testdata/f3/139/objects/a9d748d84941c6117611a40dd7163c239e08fa6dd823f538ba68b3513605720b` | 6 | `a9d748d84941c6117611a40dd7163c239e08fa6dd823f538ba68b3513605720b` | LF; no CR |
| `contract/ledger/testdata/f3/139/objects/e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855` | 0 | `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855` | intentionally empty; no terminator; no CR |

The new log contains55 distinct UUID tokens; none occurs in the13 earlier golden logs. The only shared64-hex tokens are the all-zero predecessor sentinel, the instructions-object digest `a9d748d84941c6117611a40dd7163c239e08fa6dd823f538ba68b3513605720b`, and the empty-object digest `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`. This is token overlap, not a claim that content-addressed objects acquire new identity in each chapter.


V8 must compare all earlier fixture bytes, not just the new chapter, with the authoritative records: D111 (three F0 logs), D115, D118, D119, D123, D124, D130, D139, D140, D144 and F3-13 as corrected by D149. D149's authoritative F3-13 log digest is `50b41cf739cbef89bec234cf64873e80af85188b256c66d6cb1e86ebea3555ff`, not D148's superseded `cd406c4f…8eca` (`docs/DECISIONS.md:2989-2998`). V9 records real terminators; the generator's CR check is not itself an observed all-file byte audit.

## Actual Core prerequisite probe and exact restoration

The retained probe source/invocations/output must demonstrate real `ledgerstore.Open` and `agents.Open`, using the generated fixture's actual objects/body. Positive: successful Open, zero reconciliation issues, durable sequence 65 before/after, unchanged ledger bytes and reconstructed earlier task/grant. `Reconciliation.Completed` may contain legitimate materialization repair. This pre-producer probe does not claim validation of F3-139's later reducer.

Negative: on a separate copied log, change the earlier owner task-create group to name a missing task dependency, consistently rebuilding submission, digest and chain; actual Core Open must reject that semantic prerequisite defect. Do not corrupt the retained golden or rely on a digest/reader failure. Record the actual error/sequence and preserve the control's source and output.

Restoration: record the baseline/final SHA-256 of any temporary chapter-139 helper support in `internal/core/agents/scoped_golden_test.go`, require byte-identical restoration, remove the throwaway agents probe test, and hash the final code only afterwards. Retain proof/source/output privately outside the worktree; no permanent plumbing test or Core scaffold is introduced (S1 assignment and amended ruling in the retained ticket packet).

Observed `go test -count=1 -v -timeout=19m ./internal/core/agents -run ^TestRegistrationFreezeSetupProbe$` exit0,2.971s Go/10.926s wall (08-probe.log). Positive: Store/Core Open succeeded,0issues,10 legitimate completed materialization repairs, durable65→65, unchanged ledger SHA256 `db1476e07b355d909dfb07cce79f142387469618709bc52a3f496395b94c5134`; waiting/unassigned task at19/version1 with checked description digest and nonrevoked matching root grant/authority1 reconstructed.

Negative on separately copied/canonically rebuilt log SHA256 `5234ed31b1cc83b33b6dc7aa5fb2df64dc2e21c97600549bb95a45e866061f91`: ledgerstore Open succeeded; Core returned nil service with `agents: inconsistent record at sequence 17: invalid scoped transition: agents: task dependency` (`ErrInconsistent`); durable65→65 and rejected-open bytes unchanged. The control rebuilt submission/digest/chain consistently; it is not a digest-parser failure.

Exact helper restoration before final hashes: `internal/core/agents/scoped_golden_test.go` SHA256 before/after `1c954596b2e148581ae2fa738966273667b337b00c501711467b5f4d5d906e1e`, byte-identical; own probe test absent. Retained source registration_freeze_setup_probe_test.go, scoped_golden_test.go.baseline, 09-restoration.log,23-hashes.log and final yield.json show controls/removal. Disposable runner archived as run.py.source; PM fuzz runner likewise retained as source outside the product. This proves earlier-family prerequisites only, not the unimplemented registration reducer.

## Joint completed-contract review

GPT-6 Astra, acting as a temporary stand-in for Claude Fable 5.1, approves Ticket139 S1 at 86f952cfcae37bde06767c6c4eaa615a503dd96d, parent 82d8d48856c7191019625c9f6e896d10b9b8498c, jointly with its completed F3-139 specification, generated fixtures, observed evidence and proposed 14-edit D125 freeze record. No blocking findings remain. This is technical approval for PM freeze recording, not a claim that the freeze has landed or D153 integration gates have passed. Fable remains the main advisor; its whole-ticket double-check after reset is pending.

This must be the actual fresh GPT-6 Astra review as temporary stand-in for Claude Fable 5.1 under the temporary-review authorization, covering exact S1, generated fixtures, evidence and proposed freeze record under D152. The design-only ruling is not its substitute (amended ruling, retained ticket packet). Fable remains the main advisor; retain the whole-ticket packet for its double-check after reset. Nothing here asserts that the later Fable verification has already occurred.

## D153 hosted integration — final public freeze-record subject

The primary fills the following fields from the run on the exact final public SHA, after all Go freeze-comment edits. Any rebase/fix changes that SHA and requires its own hosted evidence. Keep this subject separate from contract-code `86f952cfcae37bde06767c6c4eaa615a503dd96d`; no historical local V4, previous-SHA success or Markdown-only amendment substitutes for it (D153 and amended ruling).

PENDING — no final public freeze-record SHA exists yet. Primary coordinates application/numbering; that finalized SHA must receive its own successful full three-OS/race matrix and aggregate Check result before integration. No hosted approval is claimed.

Required field names inside that value: `finalPublicSHA`, `runURL`, `runID`, `changes` (classification, conclusion and job URL), `windows` (job name, conclusion and URL), `linux` (same), `macOS` (same), and `checkResult` (aggregate conclusion and URL). Go comment changes require the full three-runner matrix, including race; this is not the Markdown-only exemption. The primary advances main only after the exact-SHA review and hosted conditions are met; private records publish separately under D145.
````

## Remaining gate metadata

Primary must coordinate the next decision number and actual freeze date; only those two insertion fields remain. Fresh joint technical approval is inserted verbatim. The subsequent final-public-SHA hosted gate is honestly pending. No public/private repository file has been changed by preparing this record.
