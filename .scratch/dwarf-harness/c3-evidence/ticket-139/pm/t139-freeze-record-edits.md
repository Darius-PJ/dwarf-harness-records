# Ticket139 — proposed D125 freeze-record edits

Draft only: these replacements describe the record to apply after the completed S1 bundle and joint review. No approval, run, hash, number, freeze, integration or ticket close is asserted by this draft. The primary PM fills observed facts and coordinates numbering/application. All public finds are copied from the 139-registration worktree; private finds are copied from main. Reanchor changed source before applying.

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

The golden is `contract/ledger/testdata/f3/139/log/00000000000000000001.jsonl` (19 commits, 65 records; SHA-256 `«GOLDEN-SHA»`), with generated object/body fixtures beside it. Its earlier-family setup includes a real root grant before any registration. The observed inventory below supplies exact type sequences, shapes and fixture digests.

| Type, version 1 | Payload owner | Producer | Permitted appender caller | Consumers | Privacy class | Replay-essential fields | Golden sample |
|---|---|---|---|---|---|---|---|
| `runtime.resource_registered` | C3 | Core's agent service, on owner CAS of a resource registration | `internal/core/agents` only, through `ledgerstore.Submit` (review) | Core owner metadata queries/replay; Ticket61's later independently authorized reader | access-filtered opaque registration identity, exact nonsecret external address, version and audience metadata; no private content | required identity/group envelope; all known payload fields; actual effect sequence | resource creation and audience revisions; observed inventory below |
| `runtime.work_domain_registered` | C3 | as above, on owner CAS of a work-domain registration | as above | as above | access-filtered opaque identity, version and audience metadata; no private content | required identity/group envelope; all known payload fields; actual effect sequence | domain creation and audience revision; observed inventory below |
| `runtime.declaration_changed` | C3 | as above, on owner CAS replacing a declaration's complete consumer set | as above | as above | access-filtered declaration identity, version, pinned source, audience and task/context consumer metadata; no private content | required identity/group envelope; all known payload fields; actual effect sequence | both source kinds × both consumer kinds, mixed consumers, source repins and empty withdrawals; observed inventory below |
| `runtime.registration_receipt` | C3 | as above, last in each registration/declaration group | as above | as above; original-command receipt lookup | access-filtered command, canonical submission, digest, outcome and resulting-version metadata; no private content | required identity/group envelope; all known payload fields; re-encoded submission/digest binding; actual receipt sequence | every schema-5 operation and group; observed inventory below |

«FIXTURE-INVENTORY»
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
«LOG-LAST-LINE»

### D«D-NEXT». F3-139 registration and declaration records frozen

- **Date:** «DATE». **Decided by:** assistant. Under D125, the project manager freezes the completed contract without an owner question or packet. The amended Ticket139 ruling governs (`local://t139-ruling.md:25-182,251-342,520-548`); design approval is not completed-contract approval. **Joint S1/specification/fixtures/evidence/record review, by GPT-6 Astra as temporary stand-in for Fable:** «REVIEW»
- **Decision:** add four version-1 types to `ledger-format` version 1: `runtime.resource_registered`, `runtime.work_domain_registered`, `runtime.declaration_changed` and `runtime.registration_receipt`. Freeze their documented strict codecs, shapes, ordered sets, versions and 65,536-byte complete payload/submission cap (`contract/ledger/doc.go:2560-2745`). C3 owns payloads; only Core's agent service through `ledgerstore.Submit` produces them. Consumers are Core owner metadata queries/replay and Ticket61's later independently authorized reader; all known fields and required envelope/submission/receipt bindings are replay-essential.
  - Freeze schema 5's three CAS operations, `resource.set`, `work_domain.set` and `declaration.set`, canonical root `schema, actor, origin, operation, arguments`, documented compact known-field SHA-256 encoding, and exactly `[F0 command, matching effect, registration receipt]` with common owner/origin/command bindings. Operation/concrete arguments bind the target without a redundant target field.
  - The registration UUID and explicit opaque F3-11 external address are separate. Exact immutable/unique address ownership is service enforcement, not codec history lookup. No URL/account/credential semantic inputs, resolver or derived-key fallback; the grammar is not a secret detector. Identities are kind-namespaced. Registered audiences scope evidence, never permission; declarations pin the source version current at commit, obey source/task/context audience constraints and completely replace consumers, including withdrawal. Source revisions do not retarget declarations; existing grants remain independent.
- **Not frozen:** implementation/APIs; `MaxRegistrations`/`MaxDeclarations` and their 256/1024 defaults; later families, graph/action facts, views, provider work, `launcher-protocol` and `context-module`. Population limits do not constrain replay or matching retries. Earlier schemas 1–4, types, rules and goldens are unchanged.
- **Evidence:** code `«S1-SHA»`, base `«S1-BASE»`; the [evidence file](../.scratch/dwarf-harness/c3-evidence/f3-139-freeze-evidence.md) separately records the final public freeze-record SHA/hosted gate. The generated 19-commit/65-record golden, SHA-256 `«GOLDEN-SHA»`, places a real F3-11 root grant before registration and covers all registration/declaration shapes, revisions, mixed consumers, source repins and withdrawals. That file gives observed sequences/all fixture hashes, D152 focused checks/PM fuzz, unchanged earlier fixtures including D149, and actual Core positive/negative prerequisite-probe/restoration evidence; the probe does not validate the later registration reducer.
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

Freeze D«D-NEXT», «DATE». Contract-code subject: `«S1-SHA»`; actual base: `«S1-BASE»`. The final public freeze-record SHA is a distinct subject in the D153 hosted section below, not a self-reference to this private record. The amended ruling governs (`local://t139-ruling.md:25-182,251-342,478-548`); D125 requires joint review of the completed contract, fixtures, evidence and proposed record, not design approval alone.

## Scope and subjects

S1 adds four version-1 codecs/catalogue entries, schema 5 and the generated chapter-139 log/object/body fixtures under `contract/ledger`. The authorized compatibility-test cutovers delete only the obsolete internal catalogue-length assertion in `paid_compatibility_test.go` and replace `catalogue_test.go`'s stale private-map equality with public `Defined().Contains` version-admission checks, preserving the existing wire-type/version, invalid-input and fixture-rejection coverage (PM answers 1–2 in the retained ticket notes). No count is repinned. Probe-only agents test/helper changes must be removed/restored before final hashes. The final changed-path/hash inventory is in V6; it must match the committed subject.

The command records identify actual invocations, environment, exit, duration and retained output. The assigned production environment is Go 1.27.3, `GOTOOLCHAIN=local`, empty `GOFLAGS`, explicit `CGO_ENABLED=0`, host windows/amd64. D152 applies focused local evidence: no S1 local race/×20 because this is codec-only, no five-target static work without build-constraint changes, no duplicate local full gate or unrequested measurement. The PM owns the affected 120-second fuzz campaign. Actual observations belong in the result cells, not inferred from these requirements.

## D152 focused evidence

| Step and required coverage | Observed result and retained evidence |
|---|---|
| V1 — coder's final `gofmt -l` on owned Go files, host `go vet` and host staticcheck for `./contract/ledger`; tested-tree/final-blob agreement | «V1» |
| V2 — focused new codec/canonicalization/boundary tests and fuzz seeds; one plain verbose `./contract/ledger` package run; actual `./internal/core/ledgerstore` consumer run | «V2» |
| V3 — PM `go test ./contract/ledger -run '^$' -fuzz '^FuzzDecodeF3_139$' -fuzztime=120s` on the finalized code subject; executions, interesting inputs and corpus disposition | «V3» |
| V6 — actual dependency/import audit and every changed path/final file hash against S1's actual base; standard-library-only additions; count-assertion deletion listed among removed assertions | «V6» |
| V7 — `go mod tidy -diff`, `go mod verify`, and comparison showing whether `go.mod`/`go.sum` changed | «V7» |
| V8 — new `TestGoldenF3_139 -update`, then all `TestGolden` regeneration; generated/committed-byte equality and unchanged earlier fixtures against their authoritative freeze digests | «V8» |
| V9 — SHA-256 and byte-level CR/LF inspection of every new generated log/object/body fixture; distinguish LF-terminated content from intentional no-terminator files | «V9» |

No local V4, race result, full-check substitute or Markdown-only amend is supplied. D153's exact-final-public-SHA hosted gate is separate below. No irrelevant permission/credential/money/sandbox mutation campaign is required for this codec-only slice; the specific earlier-family semantic negative control is required.

## Generated fixture inventory

`contract/ledger/testdata/f3/139/log/00000000000000000001.jsonl`: 19 commits/65 records; observed committed SHA-256 `«GOLDEN-SHA»`. The generator, not hand-edited JSONL, defines the fixture and its positional IDs/times/hash chain (`contract/ledger/registration_golden_test.go:18-188,191-238`).

Five prerequisite commits/23 records register two agents/general contexts, create a work context and a real unassigned owner task with its body, then issue a real F3-11 owner root grant. The grant uses the exact opaque address `paid-route/` plus `id(0x450)` before resource `id(0x400)` is registered; no paid route/provider record is needed. Fourteen new-family commits/42 records cover resource/domain creation and audience revisions, resource→task, resource→context, domain→task and domain→context declarations, mixed consumers, current-source repins, empty withdrawals and later widening. The ruled first effect/receipt is 25/26 and final effect/receipt 64/65; the inventory supplies actual generated positions for every wire type, not positions guessed independently of the generator.

«FIXTURE-INVENTORY»

V8 must compare all earlier fixture bytes, not just the new chapter, with the authoritative records: D111 (three F0 logs), D115, D118, D119, D123, D124, D130, D139, D140, D144 and F3-13 as corrected by D149. D149's authoritative F3-13 log digest is `50b41cf739cbef89bec234cf64873e80af85188b256c66d6cb1e86ebea3555ff`, not D148's superseded `cd406c4f…8eca` (`docs/DECISIONS.md:2989-2998`). V9 records real terminators; the generator's CR check is not itself an observed all-file byte audit.

## Actual Core prerequisite probe and exact restoration

The retained probe source/invocations/output must demonstrate real `ledgerstore.Open` and `agents.Open`, using the generated fixture's actual objects/body. Positive: successful Open, zero reconciliation issues, durable sequence 65 before/after, unchanged ledger bytes and reconstructed earlier task/grant. `Reconciliation.Completed` may contain legitimate materialization repair. This pre-producer probe does not claim validation of F3-139's later reducer.

Negative: on a separate copied log, change the earlier owner task-create group to name a missing task dependency, consistently rebuilding submission, digest and chain; actual Core Open must reject that semantic prerequisite defect. Do not corrupt the retained golden or rely on a digest/reader failure. Record the actual error/sequence and preserve the control's source and output.

Restoration: record the baseline/final SHA-256 of any temporary chapter-139 helper support in `internal/core/agents/scoped_golden_test.go`, require byte-identical restoration, remove the throwaway agents probe test, and hash the final code only afterwards. Retain proof/source/output privately outside the worktree; no permanent plumbing test or Core scaffold is introduced (`local://t139-s1-assignment.md:66-80`; `local://t139-ruling.md:304-342`).

«CORE-PROBE»

## Joint completed-contract review

«REVIEW»

This must be the actual fresh GPT-6 Astra review as temporary stand-in for Claude Fable 5.1 under the temporary-review authorization, covering exact S1, generated fixtures, evidence and proposed freeze record under D152. The design-only ruling is not its substitute (`local://t139-ruling.md:3-9,520-548`). Fable remains the main advisor; retain the whole-ticket packet for its double-check after reset. Nothing here asserts that the later Fable verification has already occurred.

## D153 hosted integration — final public freeze-record subject

The primary fills the following fields from the run on the exact final public SHA, after all Go freeze-comment edits. Any rebase/fix changes that SHA and requires its own hosted evidence. Keep this subject separate from contract-code `«S1-SHA»`; no historical local V4, previous-SHA success or Markdown-only amendment substitutes for it (`docs/DECISIONS.md:3048-3065`; `local://t139-ruling.md:520-533`).

«HOSTED»

Required field names inside that value: `finalPublicSHA`, `runURL`, `runID`, `changes` (classification, conclusion and job URL), `windows` (job name, conclusion and URL), `linux` (same), `macOS` (same), and `checkResult` (aggregate conclusion and URL). Go comment changes require the full three-runner matrix, including race; this is not the Markdown-only exemption. The primary advances main only after the exact-SHA review and hosted conditions are met; private records publish separately under D145.
````

## Fill table

| Field | Fill source and timing |
|---|---|
| `«D-NEXT»` | Primary's coordinated decision number, digits only; allocate at application, not in this draft. |
| `«DATE»` | Primary's actual freeze date on the owner's local calendar. |
| `«S1-SHA»` | Exact finalized contract-code commit; match final file hashes after removing/restoring probe helpers. Not the later public freeze-record SHA. |
| `«S1-BASE»` | Actual base of that finalized S1 commit; initial assigned base is `93e8f0afe125b1ea8e87f4b8336664dd390c5b3a`, not proof of the eventual base. |
| `«LOG-LAST-LINE»` | Main's last nonempty decision-log line immediately before R1; read anew if the primary appended another record. |
| `«GOLDEN-SHA»` | Observed SHA-256 of the committed generated chapter-139 JSONL, never a manually calculated guess. |
| `«FIXTURE-INVENTORY»` | Public-safe observed inventory: each of the four wire types' sequences and covered shapes, all generated log/object/body paths and SHA-256 values, and actual fixture identity/digest overlaps. Fill from the finalized generator output and committed blobs before joint review. |
| `«V1»` | Coder's final focused formatting/host-vet/staticcheck evidence, with subject/tree match, commands, environment, exits and logs. |
| `«V2»` | Coder's final focused codec/seed checks, one plain verbose changed-package run and real ledgerstore consumer run, with subject/tree match, commands, environment, exits and logs. |
| `«V3»` | PM's actual 120-second affected decoder-fuzz campaign on finalized S1: command/environment, exit, duration, executions, interesting inputs, corpus disposition and retained log. |
| `«V6»` | Observed dependency audit and exact changed-path inventory against the actual S1 base, including the authorized paid count-assertion deletion. |
| `«V7»` | Actual tidy-diff, module verification and unchanged module-file evidence. |
| `«V8»` | Actual golden regeneration, committed-byte comparison and every earlier freeze-digest comparison, using D149's corrected F3-13 digest. |
| `«V9»` | Observed new-fixture CR/LF results per file, including intentional no-terminator files. |
| `«CORE-PROBE»` | Private retained source/invocations/output for actual Core positive and rebuilt-log negative controls; durable/byte/reconstruction results, observed rejection and exact helper restoration/removal hashes. Fill before joint review. |
| `«REVIEW»` | Verbatim completed-contract joint-review line from the actual fresh GPT-6 Astra stand-in verdict, identifying S1, evidence and proposed record; authorization and retained whole-ticket Fable verification remain explicit. Never substitute the design-only approval. |
| `«HOSTED»` | Primary's structured D153 evidence for the exact final public freeze-record SHA: SHA, run URL/ID, classification, three matrix jobs and aggregate Check result. Fill after that SHA exists and before main advances; never substitute S1's run or a local full gate. |

All placeholders above are actual insertion values. Multiline evidence/inventory/review fills may contain Markdown. V-row fills must fit a table cell (escape pipes; no literal newlines). The public inventory must contain no private paths, owner quotations or workstation/program details. Before the joint review, fill the generated-fixture, local-evidence and Core-probe fields; the review verdict and subsequent exact-final-SHA hosted evidence are filled at their respective gates. No field implies that an unperformed step passed.

## Choices and sources

- **P1 — Delegated freeze, not design approval or ticket close.** R1/R2 name assistant origin, actual stand-in review and retained Fable verification; no owner packet, B entry or status-board edit. Sources: `docs/DECISIONS.md:2134-2146,3024-3046`; `local://t139-ruling.md:3-9,520-548`; `skill://dwarfharness-stand-in-reviewer` (“Records name the reviewer truthfully”).
- **P2 — Ruling wins on the binding surface.** Keep explicit exact external address separate from UUID, three schema-5 operations/no target wrapper, kind namespaces, scoped/pinned full declarations and only two non-frozen population settings. Sources: `local://t139-ruling.md:25-182,218-249`; worktree `contract/ledger/doc.go:2560-2745`; worktree `registration_submission.go:10-12` under `contract/ledger`.
- **P3 — Minimal public register/catalogue update.** R3–R7 separately update definition, ownership, status and the C3 row, then append the real four-wire-type table. R8 changes only the §13.1 F3 clause. Preserve every unrelated later-family item and the F3-13 paragraph's scoped “not frozen here” statement; that earlier freeze still does not freeze this family. Sources: worktree `docs/CONTRACTS.md:25,39,140-151`; worktree `docs/DESIGN-CORE-AND-LAUNCHERS.md:861`; `local://t139-ruling.md:112-182,331-364`.
- **P4 — Five status-comment replacements, no code/test/encoding edits.** R9–R13 cover the split submission comment as well as registration, catalogue and both doc.go comments. The existing overview already names all families and fifty-three v1 types, so no count rewrite or paid-count repin is needed. Sources: worktree `contract/ledger/registration.go:12-17`, `registration_submission.go:10-12`, `catalogue.go:59-67`, `doc.go:158-186,2560-2564`; `local://t139-docs-notes.md:72-74`.
- **P5 — Generator-backed inventory, not invented evidence.** Keep the ruled 19/65 shape and earlier real grant; observed type positions/hash/identity inventory stays a fill field until generation. Require actual Core positive and consistently rebuilt semantic negative controls, plus exact helper restoration. Sources: `local://t139-ruling.md:251-342`; worktree `contract/ledger/registration_golden_test.go:18-188,191-292`; `local://t139-s1-assignment.md:58-80`; private `docs/DECISIONS.md:2989-2998`; private `.scratch/dwarf-harness/c3-evidence/f3-13-freeze-evidence.md:22-34`.
- **P6 — Current evidence policy supersedes historical freeze mechanics.** V1/V2/V3/V6–V9 are focused evidence slots; no S1 local race/full gate/measurement or historical V4 amend. The structured hosted fill identifies the exact final public record SHA and every required job separately from S1 code. Sources: `docs/DECISIONS.md:3024-3065`; `local://t139-ruling.md:478-548`; `local://t139-s1-assignment.md:66-80`. D148's entry and private evidence supply record form, not current execution instructions (`docs/DECISIONS.md:2967-2987`; `.scratch/dwarf-harness/c3-evidence/f3-13-freeze-evidence.md:1-20`).
- **P7 — Preserve historical bodies and split publication.** R1's exact main-tail Find is restored verbatim through its fill; R2 uses D125's different final pointer anchor. R14 is an empty-Find private new file. Public replacements contain no private path/owner quotation; no D/B number, code hash, test success, review approval or hosted result is fabricated. Sources: `docs/DECISIONS.md:2146,3076`; `local://t139-ruling.md:548`; `local://t139-freeze-drafter-assignment.md` (“Output edit-file format” and “Exact required changes”).

## Unresolved observations

The S1 commit/base, generated fixtures and hashes, final local evidence, actual Core controls/restoration, completed-contract review, freeze date/number and final-public-SHA hosted result are not yet observed. They remain explicit fill fields, not design questions. No repository change or command is part of this drafting slice.
