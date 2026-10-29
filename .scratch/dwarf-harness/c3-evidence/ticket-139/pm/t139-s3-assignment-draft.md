# Ticket139 S3 — PM review draft only

This is document preparation, not S3 activation, implementation approval, execution permission or a result. The replacement below is a proposed **session-local** assignment, not a repository edit. No closing records or cleanup plan are proposed. Source: `local/t139-s3-draft-request.md:3-11,42-43`.

#### A1 — local/t139-s3-assignment.md
Creates the bounded future fresh-coder assignment; PM must settle activation metadata before issuing it.
Find:
````
````
Replace:
````markdown
# Ticket139 S3 — interrupted recovery and cross-family acceptance

## 1. Activation and working location

**DO NOT START from this draft.** Only a separate PM activation message authorizes source work. Activation requires primary's actual approved/checked S2 integration acknowledgment and exact base, no active source hold, and a fresh coder. A source grant is not a compute grant. This assignment makes no claim about S2's future final SHA, review verdict, final test names or evidence allocation. Source: `local/t139-s3-draft-request.md:9-11`.

PM-supplied activation data:
- Exact approved integrated S2/base SHA: `«S3_BASE_SHA»`.
- Primary's S2 approval/check/integration acknowledgment and source-hold release: «S2_INTEGRATION_ACK».
- Fresh S2 review notes for S3, carried verbatim without promoting them over the ruling: «S2_REVIEW_NOTES».
- Assigned absolute worktree: `«S3_WORKTREE»`; branch: `«S3_BRANCH»`; worktree URI: `«S3_WORKTREE_URI»`; LSP folder name: `«S3_WORKTREE_NAME»`.
- Private evidence directory outside the worktree: `«S3_EVIDENCE_DIR»`.
- Fresh S3 coder identity: «S3_CODER».

Your tools start in the main checkout; a relative edit would edit main. Use absolute paths in the assigned worktree only. No subagents, Git writes, commits, main/private-record operations or pushes. Primary retains main, shared records, record numbering and local compute. Do not re-audit the supplied S1/S2 integration proof or rerun baseline checks. Sources: `local/coder-context.md:5-11`; `local/t139-s2-assignment.md:4-6`; `local/t139-ruling.md:475-476`; `local/t139-s3-draft-request.md:9-14`.

## 2. Sources, precedence and settled contract

Artifact paths beginning `local/` in this assignment resolve under:
`C:/Users/darius.jones/.omp/agent/sessions/-Documents-PROJECTS-dwarf-harness/2026-10-28T22-09-34-833Z_01a1848f-bc71-7725-b904-bf2e53c88c21`.
Repository-relative sources resolve in the main checkout at `C:/Users/darius.jones/Documents/PROJECTS/dwarf-harness`, unless activation supplies the immutable S3 base in your worktree. Read `local/coder-context.md`, current `skill://dwarfharness-staged-build`, `skill://dwarfharness-slice-recipes` and `skill://dwarfharness-last-code-slice`. D152/D153 override historical last-slice local full-check and once-per-ticket push instructions; this assignment's stricter source/compute gates override coder-context's generic idle-machine permissions. Sources: `local/t139-s3-draft-request.md:7-11,33-43`; `local/coder-context.md:3,52-58`.

Authoritative design: `local/t139-ruling.md` and `local/t139-ruling.json`. Read the entire amended ruling, especially §§4,6–8. Frozen encodings and consumed old-family record rules come from `contract/ledger/doc.go`; the earlier `local/t139-brief.md` is historical where amended. `local/t139-s2-assignment.md` records settled S2 scope, not evidence that S2 landed. Primary's current coordination mailbox is `C:/Users/darius.jones/Documents/PROJECTS/DwarfHarness/t139-secondary-coordination.md`. Review notes cannot override the ruling or frozen contract. Sources: `local/t139-s3-draft-request.md:7-11`; `local/t139-s2-assignment.md:8-15`; `local/coder-context.md:41-45`.

Private records/evidence are team-readable in main under D145, not public repository content; read only named sections needed for the assigned path, never the whole decision log. Never copy owner quotations, private evidence or local user/machine details into public files or commit messages. Source: `local/t139-s2-assignment.md:8-11`; `local/t139-ruling.md:548`.

The supplied D154/S1 base is `34090c3b634b9854904671c336db91c350e6328c`, with its hosted Check8 and primary integration/publication already supplied. **It is not the future S3 base.** D154 freezes four version-1 registration/declaration/receipt types and canonical schema 5, not an operational graph or provider. Sources: `local/t139-s3-draft-request.md:9`; `contract/ledger/doc.go:184-186,2560-2564`.

Consume these settled rules without redesign:
- Exactly three owner CAS setters: `SetResourceRegistration`, `SetWorkDomainRegistration`, `SetDeclaration`, each returning `(RegistrationReceipt, error)`. No Agent methods or register/revise wrappers.
- The registration UUID is separate from its exact immutable unique F3-11 external `ledger.Resource` address; preserve opaque keys including `paid-route/<UUID>`, with no normalization, resolver, provider or credential prerequisite. Trusted-host inputs are nonsecret identities, not URLs, account data or credentials; add no secret-detection/URL parser.
- Entity UUIDs are kind-scoped; command IDs are global across families. Expected zero creates version one; positive CAS advances contiguously. Declarations pin the source version current at commit and replace the complete consumer set; empty consumers withdraw edges, not identity.
- Tasks use stable IDs, including unassigned, reassigned and terminal tasks; contexts use exact registered bindings and never assignment-following aliases. Audience containment and pinned historical scope remain binding. Registration/declaration is evidence, never authority or an existing-grant prerequisite.
- Only `MaxRegistrations` and `MaxDeclarations` are producer population settings. Matching retry and replay ignore lowered admission limits. No capacity/heap claim.
- Owner queries are typed/isolated/current/historical/exact-version/original-receipt metadata. Zero is genesis; ToEnd captures one boundary; numeric cursors are complete committed boundaries, never future/mid-commit. Historical answers cannot borrow future versions or today's state.
Sources: `local/t139-s2-assignment.md:34-49`; `local/t139-ruling.md:90-247`; `contract/ledger/doc.go:2560-2746`.

## 3. Owned scope and product-defect escalation

Own:
- `internal/core/agents/registration_crash_test.go`;
- `internal/core/agents/registration_recovery_test.go`;
- narrowly necessary extensions to S2 registration tests and the registration subsection of `internal/core/agents/doc.go`, each listed with its behavioral reason.
Reuse actual existing repository crash/fixture conventions at the approved base; this assignment does not guess helper filenames, completed S2 tests or implementations. Sources: `local/t139-ruling.md:392-416,422-429`; `local/t139-s3-draft-request.md:14-21`.

This is not blanket ownership of S2's product/shared files. A real product defect uncovered by the cases below must be reported with the exact public failure, affected paths, available raw evidence and smallest proposed fix. Obtain bounded PM authorization before changing product/shared ownership; do not suppress it, special-case the fixture or edit frozen contracts/goldens. Finish independently reachable owned work while the affected decision waits. Execution needed to obtain new failure evidence still requires a PM compute grant. Sources: `local/t139-s3-draft-request.md:14,34-40`; `local/t139-s2-assignment.md:69`.

No edits to `scoped_state.go` authority, scoped/review planning or task lifecycle; no store/appender/reader contract changes, `history_index.go`/materialization/read-cache work, cache/epoch/index framework, dependency/module changes, build constraints, `tools/check`, `.github/`, old-family errors or goldens. Primary owns Ticket140/common-history integration. No graph/action/view/provider/credential/money feature, model/network action, real-colony work, owner-policy decision or D52 promotion/readiness claim. Sources: `local/t139-ruling.md:452-476,535-548`; `local/t139-s3-draft-request.md:40-43`.

## 4. Four real interrupted-recovery boundaries

Use real subprocesses, actual stores/files and existing `beforeSubmit` / `afterScopedSubmit` plus the single ruled private `afterRegistrationCommit func(RegistrationReceipt) error` seam. The latter runs after installation and unlock, before return, within active-operation Close protection. No new hook framework, public fault option, fake store or in-memory recovery substitute. Sources: `local/t139-ruling.md:218-243,392-407`; `local/coder-context.md:37-39`; `local/t139-s3-draft-request.md:16-21`.

Cover **all four** boundaries with deterministic markers/control, not sleeps:

| Boundary | Required observable recovery |
|---|---|
| Before commit | The interrupted request contributes no committed effect or successful receipt; previously committed state/history survives. A later submission of the same original request may perform its first complete commit. |
| Torn final group | Deliberately inject an incomplete final group using established fixture/crash patterns; no partial registration state or receipt is installed. Previously complete groups survive; subsequent matching-request processing has only complete committed effects. |
| Durable complete group before installation | Terminate after the actual complete committed group exists but before Service installation. Reopen reconstructs that group's committed state and original actual receipt; matching retry returns that receipt without another effect. |
| Installed group before acknowledgment | Terminate in the post-install/pre-return seam. Reopen retains the committed state and actual original receipt; matching retry returns that receipt without rollback or another effect. |

The absent-result expectations in the first two rows are [INFERENCE] from complete-group-only recovery, not a claim that an uncommitted operation has a receipt. Sources: `local/t139-ruling.md:222-235,400-407`; `local/t139-s3-draft-request.md:16-21`.

For every child: retain launch argv/environment, requested boundary, reached marker, actual output, exit/death reason and positive wait/reap result. Wait/reap before reopening the store, including error paths; a launched child or returned error is not proof of reaching the boundary. Sequential crash children are a legitimate exception to independent-test parallelism. Sources: `local/coder-context.md:35-39`; `local/t139-s3-draft-request.md:21,40`.

Separate **Store.Open tail repair** from **agents.Open reconstruction**. Store.Open may trim an uncommitted torn tail; record that stage honestly rather than demanding unchanged torn bytes. Then prove Service replay is ledger-only: it reconstructs complete committed state and receipts without appending reconciliation/registration effects or initiating an automatic action. Compare retained complete history and the post-store-repair ledger around Service replay; do not mistake store repair for a service append. These are deliberate process-death/torn-byte tests, not power-loss, hardware durability or exactly-once delivery qualification. Sources: `local/t139-s3-draft-request.md:21`; `local/t139-ruling.md:231-235,400-407`.

## 5. Real cross-family acceptance, without duplicated S2 proof

Use real existing families/fixtures and observable owner queries/receipts:
1. Stable task identity through reassignment and terminal state, including **F3-12 review-derived terminal task history**. A missing live-map entry is not historical absence; use existing `loadTask`. Exact context consumers remain the originally declared bindings and never follow reassignment.
2. Existing **F3-13** opaque `paid-route/<UUID>` addresses beside registration, with no provider setup, credentials or provider invocation. Registration does not change the independent existing grant's permission.
3. Reused command IDs across registration and real other families: incompatible reuse refuses with the established mismatch behavior; matching registration retry returns the **original actual receipt**, including after intervening activity/reopen.
4. Unrelated family activity preserves current registration state, exact source pins and historical answers at their original complete cursors.
Sources: `local/t139-s3-draft-request.md:23-28`; `local/t139-ruling.md:409-414,454-461,480-486`; `local/t139-s2-assignment.md:49-59`.

Reuse existing old-family regressions; no new compatibility/catalogue-count test or stand-in family. S2 already owes live CAS/concurrent retry/Close, original-request-bound preflight, complete new-golden replay and cursor correctness. Inspect the actual approved S2 tests to extend only a real missing S3 boundary/invariant; do not defer S2's obligations again or repeat them gratuitously. Keep permanent regressions only where a plausible consumer-visible bug would fail them. No source/wiring/default/wording assertions, mock echoes, bare-not-throw checks, arbitrary benchmark or assertion-count evidence. Preserve existing approved rows; report every removed/renamed test or assertion and why. Sources: `local/t139-ruling.md:382-390,414,489-498`; `local/t139-s2-assignment.md:51-61`; `local/t139-s3-draft-request.md:28,31,38-40`.

## 6. Actual public-API CLI smoke

After the final product edit, run a throwaway **CLI program**, for example `_t139_smoke/main.go` inside your assigned worktree, importing real internal packages from inside their permitted tree. Go package patterns omit the leading-underscore directory. Use real temporary colony/store state and the actual public owner Service APIs, not a permanent test as a substitute and not a private/in-package seam. The exact driver is your job against the actual approved S2 APIs; no fake scaffold or invented future API is supplied. Source: `local/t139-s3-draft-request.md:30-31`.

The CLI must exercise resources **and** work domains; task **and** context declarations; revisions and withdrawal; current, historical and pinned-version metadata; close/reopen; and same-command original-receipt retry with complete committed state/no duplicate effect. Use opaque nonsecret identities and no provider/model/network action. This is a correctness smoke, not a benchmark, capacity figure, SLA or new measurement campaign. Source: `local/t139-s3-draft-request.md:31`.

Run only under the separately granted final sequence. Retain exact source, source hash, argv, environment, exit and raw output privately outside the worktree. Remove only your own temporary driver before final checks/hashes and record its removal. A later product edit invalidates that path proof: rerun the real smoke and refresh affected evidence after renewed PM coordination. Do not delete unrelated temporary material or pre-draft ticket-close/cleanup records. Sources: `local/t139-s3-draft-request.md:31,40-43`.

## 7. Source phase, CODE_READY and separately granted serial evidence

First source step after activation: read `skill://omp-subagent-lsp-worktrees`, then send `workspace/didChangeWorkspaceFolders` through main's `internal/core/agents/service.go`, adding the assigned URI/name above. Use the existing enabled Go LSP; repeat notification after revival if necessary, not speculative setup/install/reload. Before any approved exported/shared-symbol change, obtain LSP references and inspect callers; use diagnostics on changed files. Sources: `local/t139-s2-assignment.md:13-15`; `local/coder-context.md:55-58`; `local/t139-s3-draft-request.md:34`.

**Source/read/edit/LSP only until CODE_READY.** No builds, tests, formatter, lint, fuzz, smoke or measurement mid-flight or before the explicit final grant. At CODE_READY send exact final changed paths, actual new/affected test names, proposed serial argv/environment/timeouts, the real CLI path, race applicability with reasons, actual seed/fuzz targets and risk-selected mutation plans. PM must forward primary's explicit compute grant and approved sequence before execution. Silence, an idle machine, a prior S2 slot or generic coder-context permission is not a grant. Sources: `local/t139-s3-draft-request.md:11,34-38`; `local/t139-s2-assignment.md:64-67`.

Use Go **1.27.3**, `GOTOOLCHAIN=local`, empty `GOFLAGS` and explicit `CGO_ENABLED=0` on ordinary Go work. Standard library first; no new module/dependency or toolchain installation. Reuse the actual approved base's production/test imports and D45's enforced boundary; the PM supplies S2's final import audit at activation, not a recalled closed allowance. Do not import the graph/provider toolchain or rerun unrelated native setup. Sources: `local/coder-context.md:8-20,28-29`; `skill://dwarfharness-slice-recipes` §1; `local/t139-s3-draft-request.md:34-36`.

Propose the following focused evidence, substituting **actual implemented** names in CODE_READY, not guessed names now:
- Risk-selected named red/restored-green runs as §8 requires, with every temporary change byte-identically restored before the smoke and final evidence.
- Actual-Service CLI smoke as §6 requires, after final product edit/restoration and before final checks/hashes.
- **One** focused new-regression/ordinary-seed run (`go test -count=1 -v -timeout=19m ./internal/core/agents -run '«S3_FOCUSED_SELECTION»'`).
- **One** plain verbose changed-package run (`go test -count=1 -v -timeout=19m ./internal/core/agents`). Ordinary fuzz seeds belong in package proof; not a timed campaign.
- Owned-only formatting/final `gofmt -l`, host `go vet ./internal/core/agents` and pinned host staticcheck (`go tool staticcheck ./internal/core/agents`, or the existing host binary). Host-build the pinned staticcheck only if needed and only under the grant.
- Relevant import/module audit: `go list -f '{{join .Imports "\n"}}' ./internal/core/agents`, the corresponding `.TestImports`, `go mod tidy -diff`, and `go mod verify`; retain output showing no dependency/module change. Final SHA-256 for every changed file after all restores, driver removal and formatting.
Sources: `local/t139-s3-draft-request.md:31,34-40`; `local/coder-context.md:14-20,31-39,52-53`; `skill://dwarfharness-slice-recipes` §1.

All local commands run **serially** in the allocated slot; release it only after your local jobs finish. Keep the 19m plain/focused, 29m whole-package race and 45m affected ×20 command timeouts, with matching runner timeouts 1200/1800/2800 seconds. Do not add test deadlines, sleeps, duration assertions, `-short` skips or caching to make evidence pass. Share actual real fixtures; parallelize independent fixture-owning tests/rows only where process-state/crash-child constraints allow it. Sources: `local/coder-context.md:31-39,52-53`; `local/t139-ruling.md:525-530`.

### Conditional race; never a duplicate last-slice gate

For tests-only S3, do **not** automatically repeat S2's shared-state whole-package race/affected ×20 proof. Report local race not run and why, not zero seconds or an alleged substitute result. If PM authorizes a product fix changing shared state/locking/concurrency, propose D152's exact two-command recipe:
1. `go test -race -count=1 -v -timeout=29m ./internal/core/agents`;
2. `go test -race -count=20 -v -timeout=45m ./internal/core/agents -run '«S3_CONCURRENT_SELECTION»'`.
Both retain `GOTOOLCHAIN=local GOFLAGS=` and explicitly set `CGO_ENABLED=1` plus `CC=C:/Users/darius.jones/AppData/Local/Programs/llvm-mingw-20260922-ucrt-x86_64/bin/x86_64-w64-mingw32-clang.exe`. No installation. No indiscriminate ×20 selection, five-target static work without actual platform/build-constraint changes, unchanged-package reruns, extra timing campaign or local `tools/check`/full gate. Sources: `local/t139-s3-draft-request.md:34-36`; `local/coder-context.md:14,17,32,52-53`; `local/t139-ruling.md:525-530`.

### Fuzz and hosted proof are PM-owned

List actual changed fuzzed paths and applicable targets; run ordinary seeds, not timed fuzz. `FuzzRegistrationGroupReplay` is the ruled S2 target; Scoped/Review/Paid campaigns belong to actual shared-dispatch changes, not an automatic replay of all prior campaigns for tests-only S3. `FuzzPrivateGroupReplay` stays ordinary seeds unless its actual decoder/planner path changes. PM selects applicable **120-second** campaigns in a separate explicit slot after immutable commit/hash binding. Sources: `local/t139-ruling.md:511-517`; `local/t139-s2-assignment.md:59,65-67`; `local/t139-s3-draft-request.md:36`.

The final public S3 SHA needs its **own** hosted full Windows/Linux/macOS check including race and successful aggregate `Check result` before primary integration. Any rebase/fix/new SHA needs its own run; an earlier SHA's green is insufficient. Fresh review proceeds through PM; Fable remains main advisor, and temporary fresh Astra reviews are retained for its later whole-ticket double-check. Do not claim Fable approval or any unobserved CI/review result. Sources: `local/t139-ruling.md:530-533`; `local/t139-s3-draft-request.md:36,43`.

## 8. Risk-selected rule-break proof

Propose actual plans **after source is ready**; PM approves the exact temporary edits and compute sequence. Select only authority/permission/crash-correctness risks actually touched, using the ruling's relevant cases: granting authority or requiring registration for an existing external grant; bypassing committed installation/readback or duplicate resolution; accepting an incomplete group or appending effects on Service replay. Do not manufacture breaks for naming/defaults/method consolidation, or automatically repeat unchanged S2 barriers. Sources: `local/t139-ruling.md:500-509`; `local/t139-s3-draft-request.md:38`.

For each selected plausible bug, retain original source hash, exact temporary diff/source hash, named consumer-visible regression and expected failure, actual red output, byte-identical restore/hash equality and restored-green output. Run the specific regression, not another whole-package run per mutant. Permanent regression assertions must defend an observable invariant or real error, not an internal field or wiring check. Sources: `local/t139-s3-draft-request.md:38-40`; `local/coder-context.md:33,47-50`.

Independent stacked guards may mask a one-change mutant. Report the survivor and masking guard honestly; it is **not** a red. An internal-only assertion cannot rescue it. Do not build a multi-change automatic-execution feature to force failure. If a newly discovered error has a plausible boundary/invariant regression, retain its reproduction; no wording/wiring/default test padding. Sources: `local/t139-s3-draft-request.md:38`; `skill://dwarfharness-last-code-slice` §Rule breaks that stacked barriers mask.

## 9. Final coder handoff — exact observed JSON, not closing records

Return complete JSON with:
- `base`, assigned worktree/branch, `changed: [{path, reason}]`, exact product-fix authorizations if any, and `finalHashes` covering all changed files;
- `commands`: exact cwd/argv/environment/timeouts, exits, durations and private raw evidence paths for every actually executed command; explicitly identify required-but-unrun work and why;
- `tests`: actual focused/seed/package names, covered consumer contracts and slowest plain tests; race/×20 names and slowest rows only if actually run, otherwise explicit not-run reasons;
- `crashCases`: each of the four boundaries, actual child launch/boundary marker/output/exit/wait result, store-tail repair versus Service-replay observations, complete-state/original-receipt/retry proof, and process-death/non-power-loss limitations;
- `smoke`: actual public-API CLI source/hash, argv/env/exit/output, exercised state transitions and original-receipt/no-duplicate proof, driver removal proof and whether a later product edit required renewed proof;
- `breaks`: approved plan, exact temporary edits/hashes, actual named red and restored green, byte-identical restoration, or survivor/masking-guard/non-counted result;
- `seeds` and proposed applicable PM `fuzzTargets`, with no claim to unrun campaigns;
- `deletedOrRenamed` and removed/rewritten assertions with reasons, old-golden/dependency/module status supported by the relevant evidence, `openQuestions` and scope limits.
Sources: `local/t139-s3-draft-request.md:40`; `local/t139-s2-assignment.md:67`; `skill://dwarfharness-slice-recipes` §1 (Yield).

This handoff is not ticket closure, a freeze packet, a cleanup plan, D52 approval or whole-ticket approval. PM owns fresh review, final-SHA hosted success, primary integration coordination and subsequent closing documents/records **after actual smoke proof**. No pre-drafted B/D entry, ticket-close edit, owner answer, status change or cleanup record is authorized here. Source: `local/t139-s3-draft-request.md:42-43`.
````

## Activation fill table — PM use only

Fill only the value sites inside A1 from fresh observed sources. Labels below are descriptive names, deliberately not substitution tokens. Do not globally replace text describing a placeholder. No execution allocation is filled in advance.

| Value | Filled by / when / source |
|---|---|
| S3 base SHA | PM before activation, from primary's exact approved/checked integrated S2 base; never substitute the known S1 SHA. |
| S2 integration acknowledgment | PM before activation, primary's actual approval/check/integration reference and explicit source-hold release. |
| S2 review notes | PM before activation, final fresh S2 review notes verbatim; if none, state that from the actual review, not from this draft. |
| Worktree / branch / URI / folder name | PM before activation, actual isolated worktree allocation rooted at the exact base; these are not assumed to remain S2's allocation. |
| Evidence directory | PM before activation, allocated private directory outside the worktree. |
| S3 coder | PM before activation, fresh role-routed coder, not the S1/S2 author. |
| Focused regression/seed selection | Future coder at CODE_READY, actual anchored selection from implemented regressions and ordinary seeds; PM approves before execution. |
| Concurrent test selection | Future coder at CODE_READY only if PM authorizes a qualifying product concurrency/shared-state fix; otherwise remove the conditional command from the issued sequence and record race not run. |
| Actual mutation plans and other final commands | Future coder at CODE_READY after implementation, reviewed by PM before a separate explicit compute grant; no fabricated names or slot in this draft. |

Sources: `local/t139-s3-draft-request.md:9-11,34-40`; `skill://dwarfharness-slice-recipes` §1 (Fresh coder for every slice).

## Drafter choices and unresolved matters

- **P1 — Activation stays conditional.** S1 is supplied history, not the S3 base. Future S2 SHA/notes, worktree allocation and fresh coder are value-site metadata; no S3 source or compute grant is implied. Sources: `local/t139-s3-draft-request.md:9-11`; `local/t139-s2-assignment.md:4-6`.
- **P2 — Keep every real crash boundary and separate repair from replay.** Uncommitted operations have no invented receipt; complete groups recover their original actual receipt. Precommit/torn-row absence expectations are marked [INFERENCE]. Sources: `local/t139-ruling.md:218-243,392-407`; `local/t139-s3-draft-request.md:16-21`.
- **P3 — Preserve actual cross-family semantics without duplicating S2.** Real F3-12 terminal tasks, F3-13 opaque addresses, global command collisions and historical isolation; existing old-family regression reuse. Sources: `local/t139-ruling.md:382-414,454-461`; `local/t139-s3-draft-request.md:23-28`.
- **P4 — Public CLI is mandatory smoke, not a test-only substitute or measurement.** Real Service/store, no private seam/provider, retained source/output and only own-driver removal before final hashes. Source: `local/t139-s3-draft-request.md:30-31`.
- **P5 — D152/D153 govern final proof.** CODE_READY and explicit serial grant; focused plus one plain package run; conditional exact two-command race; risk-selected observable red/restored-green or honest masked survivor; PM-owned applicable fuzz and final-SHA hosted check. Sources: `local/t139-ruling.md:500-533`; `local/t139-s3-draft-request.md:33-40`.
- **P6 — No closure/cleanup pre-draft.** Narrow package registration documentation is S3 scope; ticket/public status/private close records remain PM work after real proof. Sources: `local/t139-ruling.md:394-397,416`; `local/t139-s3-draft-request.md:14,42-43`.

**Questions:** No unresolved design question. Before activation PM must supply the fill-table facts and inspect any fresh S2 notes for a real scope conflict; actual test selections/rule-break plans and compute grant wait for CODE_READY. This draft asserts no implementation, test, smoke, review or hosted result beyond the supplied S1 history. Source: `local/t139-s3-draft-request.md:9-11,34-43`.
