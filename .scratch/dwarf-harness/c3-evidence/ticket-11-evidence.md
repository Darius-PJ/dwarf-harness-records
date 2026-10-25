# Ticket 11 evidence

Each slice's evidence as reviewed, in the order the slices reached `main`, beside the [design brief](ticket-11-design-brief.md), the build advisor's [ruling](ticket-11-design-ruling.md), which wins where they differ, and the [F3-11 freeze evidence](f3-11-freeze-evidence.md), which holds S2's package evidence and is not repeated here. [B32](../../../docs/DECISIONS.md#b32-c3-scoped-grants-and-atomic-task-ownership-ticket-11) records the build. Paths that begin `local://` name the build session's own files, which stay outside the repository. Log names refer to the coder's evidence folders `t11-s1-evidence`, `t11-s2-evidence`, `t11-s3a-evidence`, `t11-s3b-evidence` and `t11-s4-evidence`, beside the worktrees, which also stay outside it; [Where the logs are](#where-the-logs-are) names each kind.

## Machine and method

Every local run was on the project's Windows machine, with go1.27.2 windows/amd64 and Git 2.55.0.windows.3, and Defender real-time protection was on (V10) in every evidence run of the project manager. One coder, CoderT11S1, built every slice and was revived for each. Its final runs are on the committed trees, verified by SHA-256 (D121), and ran serially. The project manager's evidence, fuzzing and checks ran on the exact commits. The five static targets are windows/amd64, linux/amd64, linux/arm64, darwin/amd64 and darwin/arm64 (D28, D137). "The check" is `go run ./tools/check`: without its race step (`-race=false`, D129) on S1, S2, S2's record commit, S3a and S3b, and in full, uncached and with its race step, on S4, the last code slice. On S1, S3a, S3b and S4, V6 named the same non-standard production imports of `internal/core/agents`, the ruling's dependency set: `contract/ledger`, `contract/ledger/appender`, `internal/core/durable` and `internal/core/ledgerstore`.

## Order on `main`

| Slice | Commits on `main` | Reached `main` | Review |
|---|---|---|---|
| S1, the record-free rules | 93cd19f | 2026-10-23 13:55 | approve, five minors and a nit |
| S2, the F3-11 contract | 9a21fef; the freeze record 6d3eecc (D140) | 2026-10-23 15:35 | approve with the record, S2's D41 sign-off; two minors and three nits |
| S3a, the reducer, entrance, grants, capacity, tasks and receipts | a5e18f1 | 2026-10-23 20:23 | approve, three minors and four nits |
| S3b, admission, dispatch, endings and scoped access | c2c1996 | 2026-10-23 23:40 | approve, one minor and four nits |
| S4, the crash matrix and final documentation | ca4e141 | 2026-10-24 01:56 | approve, two nits, no change required |

S2's record commit 28f59c1 was amended, Markdown-only, as 6d3eecc to fill in its check result (D128). 6d3eecc was pushed on the owner's "Push now", and CI run 13 covers it. D141's 02f4881, Markdown-only, then reached `main` beneath S3a, which was committed as e7582c3 on 6d3eecc and rebased onto it as a5e18f1, with the tree identical and all 42 hashes matching both commits. Under D141 nothing after 6d3eecc was pushed before this close.

## S1, the record-free rules (2026-10-23)

Grant and resource containment, the resource path grammar, task-transition validation, scope sets and checked capacity arithmetic, and schema 2's canonical submission helpers, all unexported, with three new `Limits` fields, `MaxLiveTasks`, `MaxLiveGrants` and `MaxPendingLocalWork`, at the brief's defaults 4,096, 8,192 and 4,096: 12 files in `internal/core/agents`, +1,760/−2, committed as 93cd19f on 1e6c3dd, all 12 hashes matching. S1 writes no record and exports nothing else.

| Step | Result |
|---|---|
| V1 `go test -count=1 -v ./internal/core/agents` (coder) | pass, 14.2 s; slowest `TestPrivateScratchBindingsAreDistinct` 7.88 s |
| Race (coder) | pass, 20.4 s |
| gofmt; `go vet` and staticcheck for all five targets (coder) | clean; imports unchanged |
| V6, V7, V10, gofmt, staticcheck, line endings (project manager, 93cd19f) | the four imports; clean |
| Fuzzing | none: S1 adds no fuzz target |
| V4 check without its race step (project manager, 93cd19f) | `check PASSED: 8 of 9 steps passed, race skipped (D129) in 460.1s` (tests 402.3 s; `internal/core/agents` 104.3 s) |

Rule breaks, each run once and restored:

| Break | Failing test | What it showed |
|---|---|---|
| A | `TestScopedResourceContainment/workspace_string_prefix` | string-prefix containment |
| B | `TestScopedPathGrammar/git_component` | `.GIT` accepted |
| C | `TestScopedGrantAttenuation/same_depth` | a child kept its parent's depth |
| D | `TestScopedGrantChain/split_grants_no_union` | two grants combined into one authority |
| E | `TestScopedBudgetScopeSet` | a repeated ancestor |
| F | `TestScopedCheckedBudget/negative_release` | a refused release changed a hold |
| G | `TestScopedTaskRefusals/stale_generation` | the generation check omitted |
| H | `TestScopedCanonicalSubmission/task_complete` | the expectation keys reordered |
| I | `TestScopedGrantChain/future_lifetime` | an unknown lifetime treated as current |

The project manager's answers during S1, all three confirmed by the review:

1. S1 adds only those three `Limits` fields; the ruling's other ceilings arrive with the guards before `Submit` that read them.
2. Schema 2's encoder uses an unexported argument struct per operation, in the brief's order, with the envelope kept apart, so that S2's review could reorder arguments without touching it.
3. The 1,024-byte path bound is fixed grammar, an unexported constant, not a `Limits` field. S2 freezes the same grammar, so one implementation remains.

Review: AdvisorT11S1 approved S1 at 93cd19f: "S1 implements notesForS1 2-9 faithfully as record-free unexported helpers with behaviour vectors and real breaks; approved for fast-forward with five minors (Limits zero semantics, nil list -> null, zero digest accepted, grant_id optional for core work ops, busy/invalid not asserted) carried to S3a and the path-grammar cutover to S2." Its nit asked for an explicit ASCII fold for `.git` when the grammar moved into `contract/ledger`. The verdict is `local://t11-s1-verdict.md`.

## S2, the F3-11 contract (2026-10-23)

Ten codecs in new `scoped_*.go` files, the catalogue at 38 type versions, the F3-11 section of the package documentation, `ledger.ValidResourcePath` as the one path grammar, which `internal/core/agents` now calls, a golden of 39 commits and 130 records with its three objects and three bodies, and `FuzzDecodeF3_11`: 23 files, +3,104/−55, committed as 9a21fef on 93cd19f, all 23 hashes and all 17 golden hashes matching. The [freeze evidence](f3-11-freeze-evidence.md) gives the coder's runs, V3 and V6–V9, the check on the record commit and rule breaks A–J, and D140 records the freeze. Beyond it:

| Step | Result |
|---|---|
| `internal/core/ledgerstore` (project manager, 9a21fef) | pass, 34.6 s |
| V4 check without its race step (project manager, 9a21fef) | `check PASSED: 8 of 9 steps passed, race skipped (D129) in 502.8s` (tests 397.8 s; `contract/ledger` 68.3 s, `internal/core/agents` 100.1 s) |

The record commit 28f59c1's check took 833.3 s, its tests step 755.4 s against 397.8 s on 9a21fef. The slowdown was in packages neither S2 nor the record touched: `internal/core/workspace` went from 388 to 748 s, `internal/core/ledgerstore` from 246 to 355 s and `internal/core/graphfoundation` from 97 to 170 s, while `internal/core/agents` changed little. [INFERENCE] The cause is machine-side load.

The project manager's answers during S2, all six confirmed by the review, answer 5 with one correction:

1. `SubjectRef.kind` is an open token in the codec, as the ruling's P7 makes it; the S1 review's note listing "subject kind artifact" among the closed sets mistook the service's refusal for a decoder rule. The decoder checks `artifact`'s members exactly and preserves an unknown kind's members as written.
2. The `task_complete` bridge vector gets the digest SHA-256("artifact") instead of zeros, with its pinned digest recomputed; `owner_revoke` stays byte-identical.
3. The golden's F2 registration uses the real capture document and the three-record owner group that a reader mapped (`local://t11-reader-capture.md`).
4. Each group shape the package documentation tables appears in the golden at least once, with no extra agent revoke: `[C, grant_revoked, R]` is one record sequence for both actors.
5. The fixture objects and bodies beside the log are allowed, written by the same `-update` run, with no CR byte. The review's correction: the capture body, like the empty object, has no line terminator.
6. The coder's correction to the golden's order: the unnamed `task.create` root may precede task B, and task B's own `task.assign`, `task.reassign` and `task.cancel` root follows B's creation, since a grant names only registered identities.

Review, as D140 records it: "On 2026-10-23 the build advisor (Fable) approved ticket 11's S2 at 9a21fef together with this record and its evidence, with no blocker or major finding; its minors (the B2 C3 row's stale later-family list and two decoder rules added to doc.go) and nits (the V9 wording for the two terminator-less fixtures, the maxima clause, and an unfamiliar-kind encoder canonicalization carried to ticket 12) were applied to the record before the freeze or carried as stated." It found the empty object `e3b0c442…` valid: it is F3-10's initial empty handoff and memory. The verdict is `local://t11-s2-verdict.md`.

## S3a, the reducer, entrance, grants, capacity, tasks and receipts (2026-10-23)

The reducer for all ten F3-11 types, with family dispatch before the shared private head, the bound `Agent` entrance, grants, capacity, tasks and receipts, with both frozen goldens replayed through Open: 42 files in `internal/core/agents`, +6,364/−600. Production imports add only the standard library's `cmp`, `io`, `maps`, `math` and `unicode/utf8`.

| Step | Result |
|---|---|
| V1 (coder) | pass, 33.9 s |
| Race (coder) | pass, 183.2 s; `TestScopedTaskTransitionsAndProjection` took 69.78 s, "one integrated row with 42 committed groups, 9 rejected mutations, 25 TaskStatus/ListTasks calls and real-store restart" |
| V5 `-race -count=20` on `TestScopedTaskClaimAndReassignCAS`, `TestScopedGrantAttenuationAndCurrentChain` and `TestScopedReceiptsAndLostAck` (coder) | pass, 154.8 s |
| `go vet`, staticcheck and build for all five targets; `go mod tidy -diff` (coder) | clean |
| `FuzzScopedGroupReplay`, 9 seeds (coder) | pass, plain and under race |
| V6, V7, V10, gofmt, staticcheck, line endings (project manager, a5e18f1) | the four imports; clean |
| Fuzzing (project manager, a5e18f1) | `FuzzScopedGroupReplay` ran 120 s: 161 executions, 16 new interesting inputs, no failure; each execution built the golden fixture in a real store and opened the service. `FuzzPrivateGroupReplay`, fuzzed because S3a refactors `planGroup`, ran 120 s: 179,791 executions, 4 new interesting inputs, no failure |
| V4 check without its race step (project manager, a5e18f1) | `check PASSED: 8 of 9 steps passed, race skipped (D129) in 663.4s` (tests 579.4 s; `internal/core/agents` 217.9 s, against 104.3 s at S1) |

Rule breaks, each applied once and restored to the recorded hashes:

| Break | Failing test | What it showed |
|---|---|---|
| A | `TestScopedIdentityAndDefaultDeny` | exact task equality removed |
| B | `TestScopedGrantAttenuationAndCurrentChain/attenuation-shared-ceilings` | charging only the leaf left parent usage at 2 instead of 4 |
| C | `TestScopedTaskClaimAndReassignCAS` | without the fresh-context checks an old context was reused |
| D | `TestScopedTaskTransitionsAndProjection` | ignoring unfinished dependencies produced ready |
| E | `TestScopedReceiptsAndLostAck` | skipping the cold prior-command lookup broke restart and concurrent retries |
| F | `TestScopedFrozenGoldenReplay/11` | skipping scoped history failed Open at sequence 59, while F3-10's golden still passed |
| G | `TestScopedBudgetDurabilityAndRelease` | resetting usage at configuration erased consumption and holds |
| H | `TestScopedGroupRules/usage-scope-set` | without scope-set equality an invalid preflight was accepted |
| I | `FuzzScopedGroupReplay` seeds #1 and #2 | without byte-charge equality invalid groups were accepted |

The project manager's answers during S3a. The review confirmed all twelve, answer 7 with a precision.

1. `Limits.MaxAgentTurnSlots`, default 3, comes in S3a, because `ConfigureCapacity` is the guard that reads it. One active turn per context stays an invariant, not a `Limits` value. The review added that it must refuse values ≤ 0 (its minor 2).
2. Readiness: ready or blocked follows the assignee's current `task.start` chain, the assigned context's current `turn.start` chain and enrolment; free slots alone decide `ready_queued`. Each operation uses one complete chain, never a union, and each blocked state keeps its own reason.
3. Test imports are the standard library plus the package's test imports at 6d3eecc.
4. **Changed reviewed behaviour, as answer 9 corrected it.** An agent's task subject (`wait_artifact`, `submission` or `failure_evidence`) is authorized exactly when the bound origin could read the artifact now under `ReadArtifact`'s rule, in addition to the task chain that authorizes the mutation. Authority comes first, with a denial that does not reveal existence, then the `body_refs` check; both are checked again at commit and at Open.
5. The 1 MiB `maxObjectBytes` refusal at replay stays: a storage-support constant of this build, applied to both families, distinct from the configurable `Limits` that history may exceed.
6. `Agent.GrantStatus` and `Agent.CapacityStatus` disclose only the agent's own leaf grant; another agent's grant and an unknown ID get the same `ErrDenied`. A chain that is not current reports band `denied`, distinct from `busy`.
7. `CreateTask` bounds and hashes the description, looks up a prior command with no capacity check, and only for a new request applies the `Limits` ceilings, the preparation slot and the retained copy, re-hashed before publication. The review's precision: the description is a borrowed `[]byte`, cloned at the reservation and refused if it changed, not streamed.
8. No audience rule for mutations: assign, reassign, complete and cancel each need their own operation grant, and an actor outside the audience sees only its own receipt.
9. Corrects answer 4: an exact current owner-rooted `artifact.read` chain and the task description's route, the audience with a current `task.inspect`, are alternative whole predicates, and either suffices.
10. `Agent.Snapshot`, `Agent.ScratchBinding` and both `TurnStatus` methods stay wholly in S3b, so S3a exports no method whose behaviour S3b completes.
11. `TaskView` discloses the stored subject references as task facts, without bytes, under a current `task.inspect` and the audience; a disclosed reference grants no read.
12. Audience registration is a producer guard only. Open adds no check, which would tighten a frozen record rule (D40), and a recorded unregistered ID is inert.

Review: "On 2026-10-23 the build advisor (Fable) approved ticket 11's S3a at a5e18f1 with its evidence for fast-forward under D116 item 5 (check without race passed, D129; not pushed, D141): the reducer for all ten F3-11 types with family dispatch before the shared private head, the bound entrance, grants, capacity, tasks and receipts are complete with real breaks and both goldens replaying through Open; three minors (the fuzz target's per-input real-store rebuild, MaxAgentTurnSlots accepting 0, an agent create echoing an existing task's version) and four nits are carried to S3b/S4, and the 69.78 s lifecycle row stands as a B26 reporting line." Its nits: the golden rows should assert materializations through Open; `doc.go` should explain the owner's start against readiness and that "own" usage is per session; and authorizing from a work context bound to no task scans the whole ledger, which goes to S4's profile. The verdict is `local://t11-s3a-verdict.md`.

## S3b, admission, dispatch, endings and scoped access (2026-10-23)

The agent's `StartTurn` and local-work admission, the host-only dispatch, endings and reconciliation, the agent's private writes and verified private and artifact reads, and the owner's turn cancel, turn status and passive artifact read, all through one preflight path. Its first edit restructured `FuzzScopedGroupReplay` as S3a's review asked, with one long-lived service and baseline per process. 31 files in `internal/core/agents`, +3,163/−363, committed as c2c1996 on a5e18f1. Ticket 10's `commands.go` (answer 7's duplicate wait), `integrity.go` (a private object's allocation bounded to its recorded size plus one byte), `read.go` and `submission.go` (shared internals) also changed.

30 of the coder's final hashes match the committed blobs. The 31st file, `scoped_service_test.go`, which holds S3a's minor-3 row, was missing from the report's `changed` list and `finalHashes`. Its committed blob equals the hash in the coder's `break-baseline.json` (5bbeed65…), and its modification time, 20:34, precedes the final V1 (22:35), race and V5 runs, so those runs covered it. This is a reporting gap with no code change, as the review recorded.

| Step | Result |
|---|---|
| V1 (coder) | pass, 74.8 s |
| Race (coder) | pass, 296.4 s; `TestScopedTaskTransitionsAndProjection` took 97.62 s, against 69.78 s at S3a, kept unsplit with its counts: 2 agents, 3 more work contexts, 5 tasks, 8 grants, 14 accepted transitions and one real close and reopen |
| V5 `-race -count=20` on `TestScopedTaskClaimAndReassignCAS`, `TestScopedStartTurnAdmission`, `TestScopedDispatchRevocationRace`, `TestScopedOwnerAndAgentPrivateCAS` and `TestScopedProjectionBeforeAckAndIndependentPreparation` (coder) | pass, 704.7 s |
| gofmt; `go vet` and staticcheck for all five targets; `go mod tidy -diff` (coder) | clean |
| `FuzzScopedGroupReplay`, 9 seeds (coder) | pass |
| V6, V7, V10, gofmt, staticcheck, line endings (project manager, c2c1996) | the four imports; clean |
| Fuzzing (project manager, c2c1996) | `FuzzScopedGroupReplay`, restructured, ran 120 s: 6,242 executions, 39 new interesting inputs, no failure. `FuzzPrivateGroupReplay`, fuzzed because `encodePrivateWrite` changed, ran 120 s: 160,572 executions, 2 new interesting inputs, no failure |
| V4 check without its race step (project manager, c2c1996) | `check PASSED: 8 of 9 steps passed, race skipped (D129) in 1057.5s` (tests 889.2 s; `internal/core/agents` 397.7 s, 1.8 times S3a's) |

The package went from 33.9 s to 74.8 s plain and from 183.2 s to 296.4 s under race. The review judged the growth test-side, from more parallel real-store tests, and left it to S4's profile.

Rule breaks, each red, then restored and green, with `break-<x>-red.log`, `break-<x>-restore.log` and `break-<x>-green.log`:

| Break | Failing test | The mutation |
|---|---|---|
| A | `TestScopedStartTurnAdmission` | configured turn ceilings ignored, the one-active-turn check kept |
| B | `TestScopedStartTurnAdmission` | a `StartTurn` denial reported as busy |
| C | `TestScopedBudgetDurabilityAndRelease/producer-admission-dispatch-and-proven-release` | an `unknown` local ending released its holds |
| D | `TestScopedDispatchRevocationRace` | current dispatch authority skipped in receipt disclosure and preflight |
| E | `TestScopedReadRevocationAndArtifacts/pinned_retry_units_physical_buffer_and_revocation` | the last authorization refresh skipped before a retry's bytes were disclosed |
| F | `TestScopedReadRevocationAndArtifacts/artifacts/exact_size_and_real_body_allocation` | the caller's `MaxBytes` reserved instead of `ReadBody`'s real maximum allocation |
| G | `TestScopedOwnerAndAgentPrivateCAS` | an owner-actor receipt written for an agent's private write |
| H | `TestScopedNoExternalAuthorityFromLocalGrant` | external work converted to `file.read` on the workspace grant |
| I | `TestScopedRebuildAndInterruptedAdmissions` | every durable hold released at Open |
| J | `TestScopedProjectionBeforeAckAndIndependentPreparation/independent_preparation_and_complete_projection` | `Service.mu` held across a blocked private publication; the test timed out at 30 s |
| K | `FuzzScopedGroupReplay` seeds #1 and #2 | usage byte counts accepted that disagree with the private submission |

The project manager's answers during S3b. The review confirmed all nine, answers 1 and 3 with precisions, and judged answers 4 and 7 within the frozen text.

1. A read retry does the lookup, then checks current authority, so a revoked retry is denied, never busy, then takes the original's transient preparation, with no unit, `max_operation_bytes` or `Limits` check. It re-reads, verifies and rechecks authority before returning the bytes. The review's precision: the lookup already carries the authority check.
2. The host's request shapes bind through `WorkID`, with no repeated identity fields. `LocalDispatch` has no `Target`: frozen `local.begin` carries `work_id` and `arguments_sha256`, and Core rechecks the admitted target.
3. The owner's passive `ReadArtifact` is bounded only by the process slot and the body store's allocation, with no enrolment, budget scopes, unit, command or group. The review's precision: `Limits.MaxScopedBytes`, 4 MiB, still bounds it.
4. **Changed reviewed behaviour.** An agent's `turn.cancel` may use a separate current grant of its own, whose grantee is the turn's origin and whose chain covers `turn.cancel` on the turn's context. This relaxes, for agent `turn.cancel` only, S3a's reviewed check that every control's grant equals the admission's. The shared reducer checks it in preflight and at Open; release stays in the admission's scopes. The review: the frozen text fixes the origin, the turn and the child endings and names no particular grant.
5. `Agent.Snapshot` needs a `context.inspect` grant over the scope's complete slot set, and `Agent.ScratchBinding` needs `file.read` on the bound context's workspace root; anything less is `ErrDenied`.
6. At the `Agent` entrance, a context snapshot shows one fixed reason without hashes when an agent-scope issue fences the context, and every integrity refusal is `ErrIntegrity` without hashes. Owner views are unchanged.
7. **Changed reviewed behaviour.** A retry that matches a private write waits on the same-scope gate, rechecks authority and returns the receipt, with no unit or reservation, so a duplicate of an in-flight write returns only after its materializations. This changes ticket 10's owner `WritePrivate`, which returned a matched receipt at once. The review: brief line 194 justifies it, and no ticket 10 test pinned the old behaviour.
8. A reader mapped `ReadBody`'s missing, corrupt and collected outcomes (`local://t11-reader-bodies.md`); the rows keep the three errors distinct across a real reopen.
9. The owner's `CancelTurn` refuses a nonzero `GrantID` with `ErrInvalid` before any lookup, as every shared owner request does. The review's minor extends the convention to the owner's `TurnStatus`.

Review: "On 2026-10-23 the build advisor (Fable) approved ticket 11's S3b at c2c1996 with its evidence for fast-forward of main under D116 item 5 (check without race passed, D129; not pushed, D141): the Agent entrance for turns, local admission, private writes and verified private and artifact reads, the owner's cancel, status and passive artifact read, the host-only dispatch, endings and reconciliation, and the shared-head CAS all run through one preflightScoped path with real breaks A–K, all nine PM answers confirmed (answer 7 correcting ticket 10's duplicate return), the fuzz restructure at 6,242 executions, and the package's growth judged test-side with StartTurn's integrity scans referred to S4's profile; one minor (owner TurnStatus accepts a GrantID) and four nits are carried to S4." Its nits: an artifact whose size differs from its reference is reported as a corrupt store rather than a wrong reference; a grant's `max_operation_bytes` gives denied for admissions and writes but busy for reads; `StartTurn`'s integrity check scans the whole ledger twice and reads every historical Markdown object; and the coder report's omitted file. The verdict is `local://t11-s3b-verdict.md`.

## S4, the crash matrix and final documentation (2026-10-23 and 2026-10-24)

The seven-row injected crash matrix, the owner's `TurnStatus` refusing a supplied grant (S3b's carried minor), the unexported test seam `serviceDeps.afterScopedSubmit`, nil in production, and the final package documentation: 6 files in `internal/core/agents`, +429/−4 (`doc.go`, `scoped_admissions.go`, `scoped_admissions_test.go`, the new 398-line `scoped_crash_test.go`, `scoped_execute.go` and `service.go`), committed by the project manager as ca4e141 on c2c1996, all 6 hashes matching. The non-test changes are 4 files, +25/−4. There is no new behaviour, no optimization and no change outside the package; `contract/ledger`, every golden and every frozen rule are untouched. The coder's report names every committed file with its hash, so S3b's reporting gap did not recur. S4 started on 2026-10-23 at 23:41, was parked from 23:50 to 00:09 at the owner's word, and was complete at 01:10.

`TestScopedInjectedCrashRecovery` (`scoped_crash_test.go`) runs seven parallel rows. Each is a child of the current test executable, run with `-test.run=^TestScopedCrashChild$` and positively waited through `CombinedOutput`, driven by the `serviceDeps` hooks and a gob signal carrying the boundary, the pre-transition durable frontier and the committed receipt, over a copied closed real store. The rows are labelled injected, not power-loss or isolation proof.

| Row | What it proves |
|---|---|
| `before_commit` and `torn_admission` | no effect and no consumed command ID: a durable command scan, `ErrUnavailable`, and a retry with a different digest under the same command ID admitting exactly once |
| `admission_lost_ack` | one hold, and replay through `AdmitLocal` and `StartTurn` |
| `dispatch_no_ending` | dispatched and not ended, with the hold retained; `ReconcileAdmissions` records `unknown` and keeps the hold; the replay is idempotent |
| `private_before_materialization` | the selected revision readable, the stale Markdown completed at Open with `report.Completed` naming the two slots, and the same receipt on replay |
| `ending_lost_ack` | one release, and the same receipt on replay |
| `revoke_before_projection` | `GrantStatus` revoked and not current, and a prior read's retry and its receipt denied, with nothing appended |

Every row checks the exact durable frontier, that Open appended nothing, that `report.Issues` is empty, the pending work, and the colony book's held and used exposure. `TestScopedOwnerGrantSelectionShape/turn_status` proves the owner's `TurnStatus` refuses a supplied grant with `ErrInvalid` before any lookup. Ticket 10's native failure rows are unchanged.

| Step | Result |
|---|---|
| V1 (coder) | pass, 36.7 s |
| Race (coder) | pass, 170.1 s; no test over the 60 s reporting line: the slowest, `TestScopedTaskTransitionsAndProjection`, took 58.89 s (5.82 s plain), each crash row 12–15 s, and the whole crash test 1.48 s plain |
| V5 `-race -count=20` on `TestScopedTaskClaimAndReassignCAS`, `TestScopedStartTurnAdmission`, `TestScopedDispatchRevocationRace`, `TestScopedOwnerAndAgentPrivateCAS` and `TestScopedProjectionBeforeAckAndIndependentPreparation` (coder) | pass, 365.8 s |
| `go vet` and staticcheck for all five targets; `go mod tidy -diff`; imports (coder) | clean; imports unchanged from S3b except the test-only `encoding/gob` |
| `FuzzScopedGroupReplay`, 9 seeds, and `FuzzPrivateGroupReplay`, 20 seeds, in V1 and race (coder) | pass |
| V6, V7, V10, gofmt, staticcheck, line endings (project manager, ca4e141) | the four imports; clean |
| Fuzzing | none beyond the seed corpora: S4 touches none of `planGroup`, `planPrivateRevisions`, `encodePrivateWrite` or `scopedDrafts` |
| V4 full check, uncached, with its race step (project manager, ca4e141; D129) | `check PASSED: all 9 steps passed in 1294.8s` (tests 454.1 s, race 779.4 s; 0 cached packages; `internal/core/agents` 192.4 s and 532.9 s), within D127's 25-minute line |

The check runs without `-v`, so per-test times under its parallel load are not recorded. S3b's 74.8, 296.4 and 704.7 s were taken under outside load [INFERENCE, as S3b's review request stated]. The review keeps S3b's judgement that the growth was test-side, and the profile below shows the production-side share as per-operation scans linear in the log's length.

Rule breaks, each failing its named test once and restored by hash, with `break-<X>-red.log`, `break-<X>-restored.log` and `break-<X>-green.log`; the 70-file baseline `break-baseline-all.json` includes `internal/core/ledgerstore/store.go`:

| Break | Failing test | What it showed |
|---|---|---|
| A | `TestScopedInjectedCrashRecovery/torn_admission` | a mutation of `ledgerstore.Open`'s recovery counting the discarded trailing record as durable, applied outside `internal/core/agents` and reverted by hash: the row failed at its durable-frontier guard (77, wanted 76), before `agents.Open` |
| B | `TestScopedInjectedCrashRecovery/admission_lost_ack` | two local holds |
| C | `TestScopedInjectedCrashRecovery/dispatch_no_ending` | `unknown` treated as releasing |
| D | `TestScopedInjectedCrashRecovery/private_before_materialization` | Open reported completion without materializing: ten stale completions, wanted two |
| E | `TestScopedInjectedCrashRecovery/ending_lost_ack` | a second release rejected as an underflow |
| F | `TestScopedInjectedCrashRecovery/revoke_before_projection` | the projection omitted a durable revoke |
| G | `TestScopedInjectedCrashRecovery/before_commit` | the scoped `Submit` moved ahead of the pre-submit hook and preflight: the durable command scan found the ID consumed |
| H | `TestScopedOwnerGrantSelectionShape/turn_status` | an absent work returned `ErrUnavailable` instead of `ErrInvalid` |

A and G are layer-accurate equivalents. `agents.Open` bounds its replay by `store.Durable()` and the reader's `Through`, so no mutation inside the package can apply a torn commit, and a command ID is consumed only by a durable record. One misspelled Python path (exit 127) ran after break D's hash check had passed; no Go command ran in it, and D's restored test passed (`command-error.log`).

The final `doc.go` states the owner's `TurnStatus` refusal; the `max_operation_bytes` classification, denied for admissions and writes and busy for reads, where retries skip the new-work ceiling but not the physical reservation; the artifact read's full-buffer headroom in every scope, including each grant's own `Limits.BufferBytes`; that `ErrBodyCorrupt` also names a reference inconsistent with the verified body, the documentation option the S3b review offered, instead of a new error class; the owner's `ReadArtifact` bound, `MaxScopedBytes`, 4 MiB by default; that `unknown` may end undispatched local work without release; and that `BeginLocal`, `EndLocal` and `EndTurn` have no production caller until ticket 15. S3a's carried sentences, on readiness as the assignee's own start authority and on session-exact own usage, were already present from S3b.

### The P16 smoke and the S3b-7 profile

A throwaway driver through the public interface, in `_t11_s4_measure/` (`main.go` e708da67…, `memory_other.go` 8ebe6624…, `memory_windows.go` 20437b85…), never committed. The coder ran it (`measurement.log`, 568.9 s), and the project manager reran it on ca4e141 in `gate` (`smoke-pm/measurement-pm.log`, 562.3 s), then deleted it, because `tools/check` passes every top-level directory to gofmt. The driver labels its output `admission_and_storage_only`: it claims no execution, accepted delivery, model or tool throughput, C3 or C4 capacity, or power-loss isolation. CPU, disk IOPS and latency, physical I/O against the OS cache, child-process memory and production isolation are unmeasured.

- **The smoke.** Populations of 12, then 20 contexts under finite limits, with grants carrying the 64 MiB+1 artifact buffer (67,108,865 bytes), and artifact reads applied; 1, then 3 simultaneous turns held. The synchronized 16-command burst (4 claims, 3 private writes, 3 private reads, 3 artifact reads and 3 local admissions) gave 10 applied, 3 busy, 3 stale and 0 denied in the coder's run, and 11, 2, 3 and 0 in the project manager's; busy was `colony_capacity`, and stale the three losing claims. One shared-parent contention gave 1 applied and 1 busy (`grant_capacity`). A revoke before dispatch was denied, a stale reassignment refused by assignment mismatch, and a lost-acknowledgement retry replayed with no second hold. Reopen found 5 pending work items and reconciliation ended them; one dispatched work stays `unknown` with `LocalSlots` 1 and 128 bytes held, the path ticket 15 resolves.
- **Latency,** p50 of applied admissions and of transitions: 273 ms and 1.17 s in the burst; 1.14 s and 299 ms over the growth phase's 156 and 624 samples.
- **Recovery** on the smoke log, at 274 records: the store's Open 19 ms and `agents.Open` 1.44 s. Cold receipt lookup: 12 ms, 0 ms on the smoke log (a hot-index hit or timer resolution) and 91 ms on the long log, with the OS cache not flushed.
- **Storage:** a 304 KB ledger at 87 commits and 3.2 MB at 874; bodies 1,286 bytes; private bytes 107, then 1,348.
- **Memory:** a working set of about 51 MB, peak 53 MB, heap in use 4.5 MB, and 116 GB allocated in total over the long phase (119 GB in the project manager's run).
- **The profile,** at two log lengths: 87 commits and 289 records, then the same ten-operation traffic grown 78 cycles to 874 commits and 2,965 records (293 and 3,003 records in the project manager's run):

  | Measure | 87 commits | 874 commits |
  |---|---|---|
  | The store's own Open | 19 ms | 166 ms |
  | `agents.Open` | 1.42 s (project manager 1.41 s) | 75.8 s (project manager 76.7 s) |
  | `StartTurn` | 250 ms | 2.36 s |
  | `AdmitLocal` | 188 ms | 1.72 s |
  | `BeginLocal` | 156 ms | 1.28 s |
  | `task.create` | 87 ms | 625 ms |
  | `task.cancel` | 37 ms | 166 ms |

  For ten times the commits, the store's Open is linear, while `agents.Open` grows superlinearly, from about 16 ms to 87 ms per replayed commit, and each producer operation above takes 4.5 to 9.4 times as long.

The review's ruling (its answer 4): no correctness defect, and nothing for S4 to fix. The cost is the per-position cold scans that the brief's cost model declares and the S3a and S3b reviews located: `contextTask`'s whole-ledger scan on a miss from a work context no task has bound, `deriveTask` twice per phase, and `StartTurn`'s integrity scans. The review sends it to a new ticket, which the project manager asks the owner to publish, and B32 records these figures as B3's measured trigger. The fix needs its own design choice (a bounded context→task index; `StartTurn`'s integrity check narrowed to the current heads behind the projection fence; only if those fail, B3's fused startup pass or a snapshot), a review, and the same driver rerun as its evidence. It should land before ticket 15 makes `StartTurn`, `AdmitLocal` and `BeginLocal` production paths; until a production caller exists, the cost is latent. It is not a later slice of ticket 11, since S4 was the last code slice and the close is Markdown-only (D128, D129).

The project manager's answers during S4. The review confirmed all three, answer 3 with precisions.

1. The reader's setup map (`local://t11-s4-reader-setup.md`) holds facts only and informed only the uncommitted driver; the reader's one disclosed Go command, `go env GOROOT`, was read-only. The review: nothing in ca4e141 depends on the map.
2. `serviceDeps.afterScopedSubmit`, nil in production, is called under `Service.mu` between `Submit` and `refreshLocked`, for the crash row that revokes before the projection: a test seam under P17, not behaviour. The review: it is the only point where a scoped crash before the projection can be injected, since `afterScopedCommit` fires after the refresh and the unlock, and production pays one nil test.
3. Breaks A and G use layer-accurate mutations, each applied once and reverted by hash. The review's precisions: A's mutation lies outside the owned paths, but a rule break is not a commit, and `store.go` is in the hash baseline; the row stopped at its first assertion, the frontier guard, so its later assertions stand as the agents-level contract. G reproduces the real bug class, a commit before validation.

Review: "On 2026-10-24 the build advisor (Fable) approved ticket 11's S4 at ca4e141 with its evidence for fast-forward of main under D116 item 5 (the full check, uncached and with race, passed, D129; not pushed, D141): the seven-row injected crash matrix as positively waited children of the test executable over copied real stores, the owner TurnStatus grant refusal, the afterScopedSubmit test seam and the final doc.go, with real breaks A–H (A and G layer-accurate), all three PM answers confirmed, and the labelled smoke and profile showing no correctness defect but a ledger-linear per-operation cost and a superlinear Open (1.4 s to 76 s for ten times the commits) that this review sends to a new ticket as B3's measured trigger, recorded in B32; two nits, no change required." Its nits: the rows' gob input is written inside the copied colony root, which works only while neither Open inspects the root for unknown entries; and the `turn_status` row's durable guard around a pure query cannot fail. The verdict is `local://t11-s4-verdict.md`.

## CI runs 9–13

Each run is the full check on the native jobs (D133). Times are each job's whole check.

| Run | Link | Commit | Windows | Linux | macOS |
|---|---|---|---|---|---|
| 9 | [39877133318](https://github.com/Darius-PJ/dwarf-harness/actions/runs/39877133318) | 60a975a: ticket 61's S6 (7b1c63a), ticket 10's a400d15 and close | green, 2,390.2 s | green, 902.3 s | green, 395.3 s |
| 10 | [39886730409](https://github.com/Darius-PJ/dwarf-harness/actions/runs/39886730409) | 9ab6a6c: ticket 45's follow-up 4 | green, 2,081.2 s | green, 872.6 s | green, 376.6 s |
| 11 | [39973430326](https://github.com/Darius-PJ/dwarf-harness/actions/runs/39973430326) | ec1434f: ticket 45's follow-up 5 | green, 2,362.3 s | green, 879.7 s | green, 397.9 s |
| 12 | [39984600549](https://github.com/Darius-PJ/dwarf-harness/actions/runs/39984600549) | 1e6c3dd: ticket 45's follow-up 6 | green, 2,412.8 s | green, 875.5 s | green, 384.7 s |
| 13 | [40013125505](https://github.com/Darius-PJ/dwarf-harness/actions/runs/40013125505) | 6d3eecc: ticket 11's S1, S2 and D140 | green, 1,660.2 s | green, 854.2 s | green, 389.1 s |

- Every job of runs 9–13 passed all nine steps, and each run started within a minute of its push. For runs 11–13, each `URL.txt` link matches its jobs' checked-out commit.
- Ticket 10's close recorded runs 1–8, all before a400d15 was pushed. Run 9 is a400d15's first CI run, and it passed on all three systems; `internal/core/agents` took 41.5 s and 33.9 s on the Windows runner in the tests and race steps. Run 9 was also S6's first native Linux and macOS run: `internal/undercurrent/graph`'s race run grew from run 8's 53.8 s to 187.5 s on Linux, 48.0 to 116.0 s on macOS and 103.5 to 215.3 s on Windows.
- Run 13 is the first native Linux and macOS run of ticket 11's code, S1 and S2. Its Windows job ran on a new image and finished in 1,660.2 s against about 2,400 s in runs 11 and 12, mostly in `internal/core/workspace`; the logs do not show why.
- Images: Windows `windows-2022` 20261012.333.1 in runs 9–12 and 20261021.343.1 in run 13, with Git 2.56.0.windows.2; Linux `ubuntu-24.04` 20261012.334.1 and macOS `macos-15-arm64` 20260907.0337.1 in every run, with Git 2.55.0.
- S3a, S3b and S4 have not run in CI. Under D141, ticket 11's one push follows this close, and the next CI run starts with it; no result is claimed for it here.

## Limits

- Local work that was dispatched and then left `unknown` has no resolution path in ticket 11: its holds stay charged and visible in `CapacityStatus`, and ticket 15's executor supplies the proven ending (the ruling's owner gates, item 1 under "Missed by the brief").
- Agents cannot create their own work contexts, because F3-10 freezes creation as an owner action. A claim therefore needs a work context the owner created and no task has bound, until a later producer adds agent-originated creation by a new type (the same, item 2).
- `BeginLocal`, `EndLocal` and `EndTurn` have no production caller until ticket 15; the tests prove state and checks, never an effect (P11).
- S4's labelled profile measured the cost of the ledger scans the S3a and S3b reviews located. For ten times the commits, 87 to 874, Open went from 1.42 s to 75.8 s, against the store's own 19 ms and 166 ms, and each producer operation took 4.5 to 9.4 times as long, `StartTurn` 250 ms to 2.36 s. The review found no correctness defect. It sends the cost to a new ticket, which the project manager asks the owner to publish, with these figures as B3's measured trigger, before ticket 15 makes `StartTurn`, `AdmitLocal` and `BeginLocal` production paths ([S4's profile](#the-p16-smoke-and-the-s3b-7-profile)).
- The rows ran on one Windows machine. Five-target static checks are not native execution, and CI run 13 is native Linux and macOS evidence for S1 and S2 only.
- The crash rows are injected boundaries in child processes over copied real stores, not power-loss or isolation proof, and the smoke and profile are labelled admission-and-storage-only measurements, not capacity.

## Where the logs are

The raw logs stay outside the repository, as in ticket 10's evidence.

- **The coder's runs:** each evidence folder beside the worktrees holds the command record, with every command, environment, exit code and time, the V1, race and V5 logs, and the red and green logs of every rule break: `t11-s1-evidence`, `t11-s2-evidence`, `t11-s3a-evidence`, `t11-s3b-evidence`, the last with `break-baseline.json`, and `t11-s4-evidence`, with `break-baseline-all.json`, the driver's `measurement.log` and the project manager's rerun `smoke-pm/measurement-pm.log`. The coder's reports are `local://t11-s1-coder-report.json`, `local://t11-s2-coder-report.json`, `local://t11-s3a-coder-report.json`, `local://t11-s3b-coder-report.json` and `local://t11-s4-coder-report.json`, and the diffs `local://t11-s1-diff.md`, `local://t11-s2-diff.md`, `local://t11-s3a-diff.md`, `local://t11-s3b-diff.md` and `local://t11-s4-diff.md`.
- **The project manager's evidence, fuzzing and checks:** `local://t11-s1-ev/`, `local://t11-s2-ev/`, `local://t11-s3a-ev/`, `local://t11-s3b-ev/` and `local://t11-s4-ev/`, with the summaries `local://t11-s1-evidence.txt`, `local://t11-s2-evidence.txt`, `local://t11-s3a-evidence.txt`, `local://t11-s3b-evidence.txt` and `local://t11-s4-evidence.txt`, and the freeze record's dry run `local://t11-f3-record-check.txt`. The build notes, `local://t11-docs-notes.md`, hold every check result, every fuzz run and every answer to the coder.
- **The readers' maps:** `local://t11-reader-callers.md`, `local://t11-reader-capture.md`, `local://t11-reader-f310-objects.md`, `local://t11-reader-group-prefixes.md`, `local://t11-reader-bodies.md` and `local://t11-s4-reader-setup.md`.
- **The reviews:** the ruling's yield `local://t11-ruling-yield.json` and the verdict files named under each slice.
- **The CI runs:** the owner's downloads in his `DwarfHarness` folder, `Check 9` to `Check 13`, each with the run's `URL.txt`.

## The reviews

Every review in ticket 11 was a fresh build advisor, Fable (`claude-fable-5-1`), spawned for that review alone; no stand-in ran.

| Review | Advisor | Commit | Verdict | Ran |
|---|---|---|---|---|
| The design ruling | AdvisorT11Ruling | the brief, at 1e6c3dd | approve-with-changes: 7 choices accepted and 10 modified; 3 major, 8 minor and 2 nit findings | 18m7s |
| S1 | AdvisorT11S1 | 93cd19f | approve: 5 minor, 1 nit | 12m45s |
| S2 and the F3-11 record | AdvisorT11S2 | 9a21fef | approve, S2's D41 sign-off: 2 minor, 3 nits | 16m43s |
| S3a | AdvisorT11S3a | a5e18f1 | approve: 3 minor, 4 nits | 17m36s |
| S3b | AdvisorT11S3b | c2c1996 | approve: 1 minor, 4 nits | 16m32s |
| S4 | AdvisorT11S4 | ca4e141 | approve: 2 nits, no change required | 11m34s |
