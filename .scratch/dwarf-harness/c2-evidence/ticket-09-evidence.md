# Ticket 09 evidence

Each slice's evidence as reviewed, oldest first. S2's freeze evidence is [f2-09-freeze-evidence.md](f2-09-freeze-evidence.md), beside this file with the brief, the ruling and the test-cost diagnosis and ruling. Paths that begin `local://` name the build session's own files, which stay outside the repository.

## Ticket 09 S1 evidence, on d85ed78 (2026-10-16)

The test runs are the coder's final runs on the committed tree (D121), verified by hash: all four new files match d85ed78. 787758b beneath it is documents only (D126). The project manager's checks ran on a detached worktree of d85ed78; go1.27.2, Git 2.55.0.windows.3, Defender real-time protection on.

| Step | Result |
|---|---|
| gofmt, vet, staticcheck on `./internal/core/workspace` and `./contract/law` (coder) | clean |
| V1 `go test -count=1 -timeout=19m -v ./internal/core/workspace` (coder) | exit 0; package 788.0 s |
| Whole-package race `-race -count=1 -timeout=29m -v` (coder, alone) | exit 0; package 853.9 s |
| V5 | none: S1 has no concurrency test (note 5) |
| V3 | none: no fuzz target |
| V6 non-standard imports | `contract/law` (new; allowed by D45's `internal/core/...` row), `contract/ledger`, `contract/ledger/appender`, `internal/core/durable`, `internal/core/ledgerstore` |
| V7 | `go mod tidy -diff`: none; `go mod verify`: all modules verified |
| V10 | Git 2.55.0.windows.3; Defender real-time protection `True` |
| V12 | `GOOS=linux` and `GOOS=darwin` `go vet ./internal/core/workspace`: exit 0 |
| line endings | every file `i/lf w/lf` |
| V4 `go run ./tools/check` with `DWARF_CC` | `check PASSED: all 9 steps passed`, 1,753 s; the package took 557.156 s in the tests step and 673.671 s in the race step |

Rule breaks (note 3), each restored and re-run green:

| Rule | Change | Failing tests |
|---|---|---|
| Reject overflow at both int64 endpoints. | Returned unchecked UnixNano for out-of-range samples. | `TestActivationTimeRange`, `TestActivationTimestampBoundaries/below_minimum`, `TestActivationTimestampBoundaries/above_maximum`, `TestActivationTimestampBoundaries/earlier_second`, `TestActivationTimestampBoundaries/later_second`, `TestActivationTimestampBoundaries/early_year`, `TestActivationTimestampBoundaries/late_year` |
| Reject -00:00. | Disabled the unknown-offset suffix check. | `TestActivationTimestampBoundaries/unknown_offset` |
| Reject missing and local zones. | Added fallback parsing in time.Local. | `TestActivationTimestampBoundaries/missing_zone`, `TestActivationTimestampBoundaries/local_zone` |
| Reject leap seconds. | Clamped :60 to :59 before parsing. | `TestActivationTimestampBoundaries/leap_second` |
| Reject sub-nanosecond precision. | Allowed ten fractional digits. | `TestActivationTimestampBoundaries/subnanosecond`, `TestActivationTimestampBoundaries/extra_zero_precision` |
| Bound offsets to ±23:59. | Allowed arbitrary two-digit offset hours and minutes. | `TestActivationTimestampBoundaries/offset_hour`, `TestActivationTimestampBoundaries/negative_offset_hour`, `TestActivationTimestampBoundaries/offset_minute` |
| Normalize equivalent offsets. | Reinterpreted parsed wall-clock fields as UTC. | `TestActivationTimestampBoundaries/positive_offset`, `TestActivationTimestampBoundaries/negative_offset`, `TestActivationTimestampBoundaries/largest_positive_offset`, `TestActivationTimestampBoundaries/largest_negative_offset` |
| Require ascending workspace UUID order. | Rejected only equal adjacent IDs. | `TestActivationTargetValidation/unsorted` |
| Require distinct workspace IDs. | Rejected only descending adjacent IDs. | `TestActivationTargetValidation/duplicate` |
| Verify artifact bytes against their key. | Returned success on a local artifact digest mismatch. | `TestActivationArtifactSet/mismatched_bytes` |
| Include removed workspaces in affected scope. | Removed prior-only entries from scope derivation. | `TestActivationAffectedWorkspaces/removed`, `TestActivationAffectedWorkspaces/all_removed`, `TestActivationAffectedWorkspaces/removed_and_added`, `TestActivationAffectedWorkspaces/policy_changed_union` |
| Keep checks-only changes local. | Treated local policy-list differences as global changes. | `TestActivationAffectedWorkspaces/checks_only`, `TestActivationAffectedWorkspaces/environment_only` |

## Ticket 09 S3a evidence, on a76866d (2026-10-16)

The test runs are the coder's final runs on the committed tree (D121), verified by hash: all 12 changed files match a76866d. The project manager's module checks ran in the gate worktree on f8e2dbc, the stack S3a reached `main` in; go1.27.2, Git 2.55.0.windows.3, Defender real-time protection on, before the machine changes of 2026-10-16.

| Step | Result |
|---|---|
| V1 `go test -count=1 -timeout=19m -v ./internal/core/workspace` (coder) | exit 0; package 774.786 s |
| Whole-package race `-race -count=1 -timeout=29m -v` (coder, alone) | exit 0; package 892.256 s |
| V5 `-race -count=20 -timeout=45m -run '^TestActivation(IntentAdmissionLinearization\|SharedCutoverWaitsForAllIntents\|SingleDueWakeup\|ReplacementCancellationCAS\|SameIDAndOnePending)$'` (coder) | exit 0; 445.814 s |
| V6 non-standard imports | `contract/law`, `contract/ledger`, `contract/ledger/appender`, `internal/core/durable`, `internal/core/ledgerstore` |
| V7, V12, gofmt, staticcheck, line endings | clean |
| `go run ./tools/check -race=false` on f8e2dbc (D129) | `check PASSED: 8 of 9 steps passed, race skipped (D129)`, 907 s; the package took 620.158 s in the tests step |

Rule breaks (notesForS3a 10), each restored; the `promote.go` break restored with its SHA-256 asserted:

| Rule | Change | Failing tests |
|---|---|---|
| Guard under s.mu | Moved guard outside lock; restored. | `TestActivationIntentAdmissionLinearization/intent_first` |
| Encode after guard | Encoded intent before guard; restored. | `TestActivationIntentBindsActualManifest` |
| Live effective timestamp | Used not_before as effective time; restored. | `TestActivationClockHoldAndRecovery/advance`; `TestActivationClockHoldAndRecovery/guard` |
| Recorded observation floor | Removed replayed hold floor update; restored. | `TestActivationReplayIsInertAndOverdue/none` |
| No timer from regressed sample | Removed trusted-clock timer checks; restored. Initial mutation timed out at fake-time saturation. PM-authorized repeat with bounded probe directly failed: regressed clock armed a polling timer. | `TestActivationSingleDueWakeup` |
| Drain affected intents | Removed live unresolved-intent check; restored. | `TestActivationSharedCutoverWaitsForAllIntents/resume_first`; `TestActivationSharedCutoverWaitsForAllIntents/reconcile_first` |
| Preserve foreign fences | Cleared intents and recoveryPending on activation ending; restored. | `TestActivationCancellationPreservesForeignFences` |
| Atomic replacement | Split ending from request/pin commit; restored. | `TestActivationReplacementCancellationCAS` |
| Repeat CAS under lock | Removed post-publication admission recheck; restored. | `TestActivationReplacementCancellationCAS` |
| Envelope hash authority | Computed request hash from draft payload; restored. | `TestActivationOwnerAndExactRetention` |
| Inert Open | Sampled clock during Open; restored. | `TestActivationReplayIsInertAndOverdue` |
| Future ended outcome replay | Rejected unknown ended outcome during Open; restored. | `TestActivationRecordRules/unknown_ending`; `TestActivationRecordRules/unknown_ending_with_replacement` |
| Reject stale expected hash | Allowed known stale hash through admission; restored. | `TestActivationSameIDAndOnePending` |
| Holdless recovery fence | Disabled activation recovery fence; restored. | `TestActivationReplayIsInertAndOverdue/pending` |
| Unconditional no_validator | Returned no_evidence after activation; restored and asserted original promote.go SHA-256. | `TestRequestPromotionUnavailableInC2` |

## Test-cost optimization evidence (OPT-1 36d0c51, OPT-2 8fb6ef1; 2026-10-16/17)

All runs alone on the machine, serially, by the slice coders. Machine state for every figure below: PcaSvc repaired (its hung process ended), Windows Defender excluding git.exe (the owner's choices). The final runs ran on the combined tree 8fb6ef1; all six changed files' SHA-256 values match it.

### The whole package, plain (`go test -count=1 -timeout=29m -v ./internal/core/workspace`)

| Stage | Package s | Sum of top-level s | Source |
|---|---:|---:|---|
| Before the machine fixes (S3a's final run, a76866d's tree) | 774.8 | 1,998 | `local://t09-s3a-ev/coder-final-v1.log` |
| After the machine fixes, unchanged tests (f8e2dbc) | 482.264 | 1,248.88 | `local://opt-ev/opt1-baseline.log` |
| O1 | 479.318 | 1,206.76 | `local://opt-ev/opt1-o1.log` |
| O1 + O2 (OPT-1, 36d0c51) | 440.317 | 1,099.47 | `local://opt-ev/opt1-o1o2.log` |
| O1–O4 (OPT-1 + OPT-2, 8fb6ef1) | 361.337 | 884.29 | `local://opt-ev/opt2-v1.log` |

### Race (`-race -count=1 -timeout=45m -v`)

| Stage | Package s | Sum of top-level s |
|---|---:|---:|
| Before the machine fixes (S3a) | 892.3 | 2,217 |
| O1–O4 (8fb6ef1) | 411.486 | 1,123.37 |

V5 on 8fb6ef1: `-race -count=20 -timeout=45m -run '^(TestFinalizationCrashMatrix|TestWindowsOwnedGitCrashBeforeRecovery)$'`, exit 0, 448.1 s.

### Focused, plain, alone (OPT-2's before and after, both after the machine fixes)

| Test | Before s | After s |
|---|---:|---:|
| `TestFinalizationCrashMatrix` | 48.204 | 21.956 |
| `TestWindowsOwnedGitCrashBeforeRecovery` | 7.036 | 7.063 |
| `TestOpenFailsClosedOnF2_07MergeBackRuleBreak` | 24.920 | 17.345 |
| `TestOpenFailsClosedOnF2_07RuleBreak` | 15.346 | 9.996 |

### Tests over 60 s

Plain: none. Race: `TestOpenFailsClosedOnF2_07MergeBackRuleBreak` 63.61 s.

### Rule breaks

OPT-1: six, each killed (`local://opt1-coder-report.md`). OPT-2: seven; six killed, and one survived on both the baseline and the optimized trees: deleting `scratch_merge_back` from `workspaceConsumption`. Open reads with `AllTypes: true`, so version-1 records still apply; only a newer version's refusal is lost, which no test covers (a gap that predates this work). The "re-read main" break is killed by `cas` only, on both trees; the `intent` and `torn_intent` rows hold no durable intent. Every product file a break edited was restored with its SHA-256 asserted.

### Defender and PcaSvc (2026-10-16, the owner's choices)

- **PcaSvc:** the Program Compatibility Assistant service used one full thread at idle. Its restart hung in Stop Pending, and its own process (hosting only PcaSvc) was ended through a second elevated step; it runs normally since.
- **Defender A/B,** on the gate worktree at f8e2dbc with the subset `TestFinalizationCrashMatrix`, `TestOpenFailsClosedOnF2_07MergeBackRuleBreak` and `TestOpenFailsClosedOnF2_08RuleBreak`, plain, `-parallel=4`:

  | Runs | Package seconds | MsMpEng, % of one thread |
  |---|---|---|
  | git.exe excluded | 43.2, 55.3, 53.2; recheck 43.7 | 36–56 |
  | not excluded | 50.1, 63.1, 66.8 | 94–105 |

  The median was 53.2 s against 63.1 s, so the excluded runs were 19% faster, and faster at every matched position. The excluded runs came first, so run order was not controlled.
- **Exclusions:** an exclusion of the tests' temporary folder gained 0.5% in the diagnosis and was removed. The git.exe process exclusions (Git for Windows' `cmd`, `bin` and `mingw64\bin` copies) stay.

## Ticket 09 S3b evidence, on 245a032 (2026-10-17)

The test runs are the coder's final runs on the committed tree (D121), verified by hash: every changed file matches 245a032. 50026d5 beneath it changes only `tools/check` (step durations). The project manager's checks and the full check ran in the gate worktree on 245a032, with Go's test cache cleared first (the ticket's last code slice, D129). Machine state: PcaSvc repaired and git.exe excluded from Defender (the owner's choices of 2026-10-16).

| Step | Result |
|---|---|
| V1 `go test -count=1 -timeout=29m -v ./internal/core/workspace` (coder) | exit 0; package 373.281 s |
| Whole-package race `-race -count=1 -timeout=45m -v` (coder, alone) | exit 0; package 422.7 s |
| V5 `-race -count=20 -timeout=45m -run '^(TestFinalizationCrashMatrix\|TestWindowsOwnedGitCrashBeforeRecovery\|TestActivationCrashMatrix\|TestActivationAppendFailureAndHashHydration)$'` (coder) | exit 0; 473.959 s |
| Tests over 60 s under race | `TestOpenFailsClosedOnF2_07MergeBackRuleBreak` 63.75 s (the known one; no new test over 60 s) |
| V3 | none: no new parser or fuzz target |
| V6 non-standard imports | `contract/law`, `contract/ledger`, `contract/ledger/appender`, `internal/core/durable`, `internal/core/ledgerstore` |
| V7 | `go mod tidy -diff`: none; `go mod verify`: all modules verified |
| V10 | Git 2.55.0.windows.3; Defender real-time protection `True` |
| V12 | `GOOS=linux` and `GOOS=darwin` `go vet ./internal/core/workspace`: exit 0 |
| gofmt, staticcheck, line endings | clean; every file `i/lf w/lf` |
| V4 `go run ./tools/check` with `DWARF_CC`, test cache cleared (D129) | `check PASSED: all 9 steps passed in 1087.5s`; the tests step took 497.4 s and the race step 573.6 s; the package took 314.752 s in the tests step and 407.150 s in the race step; `tools/artgen` took 415.251 s under race, the race step's longest package |

Shared-store break, by construction (the test-cost ruling's O3): `activation_recovery_test.go:146` builds each row through `activationGoldenPrefix`, `:159` reopens its private store, and `activation_replay_test.go:53` allocates the private colony.

Rule breaks (notesForS3b 8), each restored with its file's SHA-256 asserted:

| Rule | Change | Failing tests |
|---|---|---|
| Hydrate actual committed sequence | Substituted predicted First; restored SHA-256 verified. | `TestActivationAppendFailureAndHashHydration/foreign_append` |
| Hydration failure poisons rather than undoes | Undid projection and cleared poison; restored SHA-256 verified. | `TestActivationHydrationFailurePoisonsUntilReplay` |
| Definite refusal undoes projection | Skipped undo for ErrRefused; restored SHA-256 verified. | `TestActivationAppendFailureAndHashHydration/refused_requested`; `TestActivationAppendFailureAndHashHydration/refused_replaced`; `TestActivationAppendFailureAndHashHydration/refused_hold`; `TestActivationAppendFailureAndHashHydration/refused_cancelled`; `TestActivationAppendFailureAndHashHydration/refused_activated` |
| Native uncertainty cannot expose a half-applied slot | Retained projection without poisoning; restored SHA-256 verified. | `TestWindowsActivationSharing` |
| Every consumed type declares supported versions | Deleted body_unpin consumption; its v2 Open incorrectly succeeded; restored SHA-256 verified. | `TestOpenRefusesNewerConsumedVersions/ledger.body_unpin` |
| Torn activation remains pending | Interpreted replayed due as applied; restored SHA-256 verified. | `TestActivationCrashMatrix/torn_activated` |
| Effective time contributes to replay floor | Ignored effective time during replay; restored SHA-256 verified. | `TestActivationClockRollback/due_true` |
| Regressed resume cannot manufacture due | Converted untrusted observation into due; restored SHA-256 verified. | `TestActivationClockRollback/due_false` |
| Regressed due holds do not poll | Armed a long polling timer under due; restored SHA-256 verified. | `TestActivationClockRollback/due_true` |
| Crash rows own private stores | Excluded by construction, as authorized: activation_recovery_test.go:146 creates each row through activationGoldenPrefix; :159 reopens its private store. activation_replay_test.go:53 allocates the private colony. | none |

The ten slowest tests in the coder's race run:

| Test | Seconds |
|---|---|
| `TestOpenFailsClosedOnF2_07MergeBackRuleBreak` | 63.75 |
| `TestOpenFailsClosedOnF2_08RuleBreak` | 35.67 |
| `TestOpenFailsClosedOnF2_07RuleBreak` | 31.04 |
| `TestCapacityScalesWithPairs` | 26.45 |
| `TestMergeBackDurableNoticeAndProvenance` | 25.37 |
| `TestFinalizationPathsetCapBeforeIntent` | 22.41 |
| `TestWindowBoundsGenerations` | 22.29 |
| `TestActivationIntentBindsActualManifest` | 20.70 |
| `TestScratchPathsetBoundIsExplicit` | 19.78 |
| `TestScratchNoticesScopedAndReplayable` | 18.69 |
