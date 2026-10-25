# Ticket 07 evidence

Each slice's evidence as reviewed, oldest first; the brief, ruling and Git probes sit beside this file. Paths that begin `local://` name the build session's own files, which stay outside the repository. The two Git probe copies beside this file were normalized from CRLF to LF line endings (B1); their text is otherwise unchanged.

## Ticket 07 S1 evidence, on 1b96ee7

Collected on 2026-10-13 by the PM's `pm-evidence.sh` on a detached worktree of `1b96ee790679d2674235b4bba21f3a8e2ff6f40d` (branch `build/07-temp-scratch`: ff113dc, ticket 59's tracker commit, then S1, on `main` ead167e); go1.27.2, Git 2.55.0.windows.3, Defender real-time protection on. Raw outputs: `local://t07-s1-ev/`. No other test ran meanwhile.

| Step | Result |
|---|---|
| V1 `go test -count=1 -timeout=19m -v ./internal/core/workspace` | exit 0, 172 s (package 166.201 s); 474 tests and subtests run, 471 passed, 3 skipped (`TestHelperScratchCrash`, `TestCaptureWorkload`, `TestRemoveDoesNotFollowSymlink`), none failed. Every new test passed: `TestTrustedPathUnionEligibility`, `TestMaterializeTwoTreeCheckout`, `TestMaterializeRefusesObstruction`, `TestMaterializeVerifiesBeforeRef`, `TestIndexInstallOwnedLock`, `TestMaterializeRetryPreservesThirdValue`, `TestMaterializeLockedModifiedFile`, `TestMaterializeLockedDeletedFile`, `TestMaterializePinnedCRLF`, `TestSoleWriterWaitsForLeasesAndExcludesCapture`, `TestObservationReservationTakesNoSlot`, `TestSubordinateTokenBoundToGuard`, `TestSoleWriterWaitsForExclusiveOwners`, `TestCreateWorktreeAtExplicitCommit`, `TestObservationCommitDeterministic`, `TestScratchCommitRefCompareAndSwap`. |
| V5 `-race -count=20 -timeout=45m -run 'Concurrent\|InFlight\|Replay\|Busy\|Poison\|OnePerPair\|SoleWriter\|ObservationReservation\|SubordinateToken'` | exit 0, 393 s; 0 FAIL, 0 data races; 20 passes each for 22 tests (the four new pool and writer tests and ticket 06's concurrency set) |
| V3 | not run: S1 adds no fuzz target and changes no fuzzed code (`gitparse.go` unchanged) |
| V6 | `contract/ledger`, `contract/ledger/appender`, `internal/core/ledgerstore` only |
| V7 | `go mod tidy -diff`: none; `go mod verify`: all modules verified |
| V10 | Defender real-time protection `True` |
| V12 | `GOOS=linux` and `GOOS=darwin` `go vet`: exit 0 |
| gofmt, staticcheck, line endings | clean; every file of the package, `docs` and `.scratch` is `i/lf w/lf` |
| V4 `go run ./tools/check` | all nine steps passed, 761 s; the package took 229.757 s in the tests step and 288.285 s in the race step (B25's baseline: 215 s and 274 s) |

The coder's own serial runs: V1 263.578 s, whole-package race 287.830 s (no data race); its rule breaks a–j each failed the named test and the restored code passed (`local://t07-s1-coder-report.md`).

Rule breaks, each restored and re-run green:

| Rule | Change | Failing tests |
|---|---|---|
| a | Replaced supplied base with main's tip. | TestCreateWorktreeAtExplicitCommit |
| b | Removed active-lease count from sole-writer grant condition. | TestSoleWriterWaitsForLeasesAndExcludesCapture |
| c | Removed live-exclusive ownership check and child invalidation on guard release. | TestSubordinateTokenBoundToGuard |
| d | Discarded TrustedNames before capture. | TestTrustedPathUnionEligibility |
| e | Derived observation dates from a freshly generated wall-clock UUID instead of the observation ID. | TestObservationCommitDeterministic |
| f | Created retention refs using update-ref without expected-old CAS. | TestScratchCommitRefCompareAndSwap/sha1; TestScratchCommitRefCompareAndSwap/sha256 |
| g | Treated Git-listed ignored entries as represented actual paths, bypassing obstruction refusal. | TestMaterializeRefusesObstruction/ignored_addition |
| h | Published the branch CAS before target reobservation. | TestMaterializeVerifiesBeforeRef |
| i | Opened index.lock with O_TRUNC instead of O_EXCL, installing through a foreign lock. | TestIndexInstallOwnedLock/foreign |
| j | Replaced two-tree read-tree -m -u with read-tree --reset -u. | TestMaterializeRetryPreservesThirdValue |

## F2-07 freeze evidence: ticket 07 S2 at ae1c995

Collected on 2026-10-13 by the project manager on a detached worktree of `ae1c9956dc5e74409dca9f010e4e4e2f92db91d5` (`feat(ledger): draft F2-07 scratch observation and merge-back records for the owner's freeze`, on `main` 1b96ee7); go1.27.2, Git 2.55.0.windows.3, Defender real-time protection on.

| Step | Result |
|---|---|
| V2 `go test -count=1 -v ./contract/ledger` | exit 0; 3,278 tests and subtests run, 3,278 passed, none skipped or failed. New: `TestGoldenF2_07`, `TestF2_07PayloadsRoundTrip`, `TestF2_07PayloadsRefuse`, `TestScratchCreatedParent`, `TestPromotionAdmittedProvenance`, `FuzzDecodeF2_07`'s seeds. `./internal/core/ledgerstore`: ok. |
| V3 `-fuzz -fuzztime 120s` | `FuzzDecodeF2_07`: 2,169,330 executions; `FuzzDecodeF2_05`: 5,917,960; `FuzzDecodeF2_06`: 4,434,180; all PASS; no file left under `testdata` |
| V6 | `contract/ledger` imports the standard library only |
| V7 | `go mod tidy -diff`: none; `go mod verify`: all modules verified |
| V8 `go test ./contract/ledger -run '^TestGolden' -update` | exit 0, and `git status -- contract/ledger/testdata` is unchanged: every existing golden regenerates byte for byte. SHA-256: F2-05 843663a168e472adf4656fdba4ffa6db770e588feec0020bb10e20bf14def437 (D115); F2-06 014cc612076390934fa8a668117c353c5cca2630a3b3fd90364a29542b96f40d (D118); F0 `00000000000000000001.jsonl` c72c4a739965586d984b524dbc6ee67a5b9d866756639fbb03b04e90f441f2e5 and `00000000000000000005.jsonl` 3ee9f566e69e9cccb89ed435afee322950d3084a69ed0301684c15be70f8e65b (D111) |
| The new golden | `contract/ledger/testdata/f2/07/log/00000000000000000001.jsonl`: 22 commits, 41 records, 37,093 bytes, SHA-256 96de91f92432040683157279432512810c2dd27d36012695be46dd1eccac88c5 |
| V9 | the new golden is `i/lf w/lf` (B1) |
| V12 | `GOOS=linux` and `GOOS=darwin` `go vet ./contract/ledger`: exit 0 |
| gofmt, staticcheck, line endings | clean |
| V4 `go run ./tools/check` | `check PASSED: all 9 steps passed`, 1,505 s |

Rule breaks (the coder's report): 67 mutations of the decoder and encoder rules, including breaks a–n of the assignment, each failed a named test and the restored code passed; one accessor-only mutation was masked by `PromotionAdmitted.check`, which still refuses the duplicate, and was replaced by an encoder-side break. Every owned file's SHA-256 was verified restored after the runs.

## Ticket 07 S3a evidence, on b03de1d

Collected on 2026-10-13 by the PM's `pm-evidence.sh` on a detached worktree of `b03de1d0b59db65875147575c7ab4f9a0e920596` (branch `build/07-temp-scratch`: dd2e5f3, D120, documents only, then S3a, on `main` 702ca66); go1.27.2, Git 2.55.0.windows.3, Defender real-time protection on. Raw outputs: `local://t07-s3a-ev/`. CoderT07S3b and CoderT08S2 wrote code but ran no test meanwhile.

| Step | Result |
|---|---|
| V1 `go test -count=1 -timeout=19m -v ./internal/core/workspace` | exit 0, 218 s (package 211.482 s); 543 tests and subtests run, 540 passed, 3 skipped (`TestHelperScratchCrash`, `TestCaptureWorkload`, `TestRemoveDoesNotFollowSymlink`), none failed. Every new test passed: `TestTipRepairAtOpenAndBeforeUse`, `TestScratchCommitAndMergeRefsRetained`, `TestOpenFailsClosedOnF2_07RuleBreak`, `TestFrozenWorkspaceGoldensReplay`, `TestTemporaryClosureRepresentation`, `TestWriterCloseAndServiceClose`, `TestWriterObservationWaitsAndThaws`, `TestSecondWriterForksLatestCommittedTask`, `TestWriterBindingAndContextExclusion`, `TestTemporaryCoexistsWithDedicated`, `TestInterruptedWriterResumesTemporary`, `TestObservedCommitIgnoresMutableIndex`, `TestPrivateObservationEligibility`, `TestScratchPathsetBoundIsExplicit`. Slowest: `TestCapacityScalesWithPairs` 20.95 s, `TestOpenFailsClosedOnF2_07RuleBreak` 16.98 s, `TestScratchPathsetBoundIsExplicit` 16.90 s, `TestWindowBoundsGenerations` 16.09 s. |
| V5 `-race -count=20 -timeout=45m -run 'Writer\|ProtectedWindow\|TemporaryClosure\|SoleWriter\|ObservationReservation\|SubordinateToken\|Concurrent\|Busy\|Poison\|OnePerPair'` | exit 0, 636 s; 0 FAIL, 0 data races; 20 passes each for 26 tests |
| V3 | not run: no fuzz target added or fuzzed code changed |
| V6 | `contract/ledger`, `contract/ledger/appender`, `internal/core/ledgerstore` only |
| V7 | `go mod tidy -diff`: none; `go mod verify`: all modules verified |
| V10 | Defender real-time protection `True` |
| V12 | `GOOS=linux` and `GOOS=darwin` `go vet`: exit 0 |
| gofmt, staticcheck, line endings | clean |
| V4 `go run ./tools/check` | all nine steps passed, 891 s; the package took 295.308 s in the tests step and 363.009 s in the race step (after S1: 229.757 s and 288.285 s; Go's default per package: 600 s) |

The coder's own serial runs: V1 362.659 s, race 378.976 s (under other load); breaks a–e, n's parent half, p and q each failed the named test, and the restored code passed (`local://t07-s3a-coder-report.md`).

Rule breaks, each restored and re-run green:

| Rule | Change | Failing tests |
|---|---|---|
| a | Disabled foreign-context temporary routing. | TestSecondWriterForksLatestCommittedTask: second writer did not fork the acknowledged task |
| b | Forced every creation base to main. | TestSecondWriterForksLatestCommittedTask: temporary fork differs from parent's acknowledged tip |
| c | Disabled AgentID/TaskAgentID equality check. | TestWriterBindingAndContextExclusion: another agent routed |
| d | Substituted the private HEAD/branch tree for the captured disk tree. | TestObservedCommitIgnoresMutableIndex: observed content remained the old HEAD content |
| e | Projected the new branch tip before appending its observation. | TestObservedCommitIgnoresMutableIndex: private branch moved before acknowledgment |
| n (parent half) | Made the open-child guard report no child. | TestTemporaryCoexistsWithDedicated: parent closed with child |
| p | Accepted a fitting payload without checking its encoded envelope. | TestScratchPathsetBoundIsExplicit: preflight measured only payload bytes |
| q | Removed resumed-temporary context binding. | TestInterruptedWriterResumesTemporary: resumed another context's work |

## Ticket 07 S3b evidence, on db85ebb

Collected on 2026-10-13. The test runs are the coder's final runs on the committed tree (D121), verified by hash: all 19 changed files' SHA-256 values match `db85ebb72af9d7265555495105bc98716ba69c8f` (`feat(workspace): merge back temporary scratches, retry, notices and admission provenance (ticket 07 S3b)`, above c41452f, D122, and 4d9fc6a, D121, on `main` b03de1d). The module checks, the full check and the workload run are the project manager's, on a detached worktree of that commit, with nothing else running; go1.27.2, Git 2.55.0.windows.3, Defender real-time protection on.

| Step | Result |
|---|---|
| V1 `go test -count=1 -timeout=19m -v ./internal/core/workspace` (coder, final) | exit 0, package 492.846 s |
| Race, whole package, `-race -count=1 -timeout=29m -v` (coder, final) | exit 0, package 529.775 s; slowest `TestOpenFailsClosedOnF2_07MergeBackRuleBreak` 86.95 s, `TestOpenFailsClosedOnF2_07RuleBreak` 45.97 s, `TestCapacityScalesWithPairs` 44.82 s |
| V5 `-race -count=20 -timeout=45m -run 'Writer\|MergeBackWaits\|ProtectedWindow\|TemporaryClosure\|SoleWriter\|ObservationReservation\|SubordinateToken\|Concurrent\|Busy\|Poison\|OnePerPair'` (coder, final) | exit 0, 1,211.287 s |
| V3 | not run: no fuzz target added or fuzzed code changed |
| V6 | `contract/ledger`, `contract/ledger/appender`, `internal/core/ledgerstore` only |
| V7 | `go mod tidy -diff`: none; `go mod verify`: all modules verified |
| V10 | Defender real-time protection `True` |
| V12 | `GOOS=linux` and `GOOS=darwin` `go vet`: exit 0 |
| gofmt, staticcheck, line endings | clean |
| V4 `go run ./tools/check` (with D122's 20-minute limit) | `check PASSED: all 9 steps passed`, 1,164 s; the package took 362.002 s in the tests step and 460.203 s in the race step |
| V11 `TestCaptureWorkload`, alone | exit 0, 1,263.812 s; 29 rows (`local://t07-s3b-ev/t07-workload.jsonl`); the `lease` phase measured **107.3 ms** per lease on the 10,000-file scratch |

An earlier final sequence on the previous tree failed V5: one per-row clone reported Git's `fatal: hardlink different from source`, and a pattern the PM had widened hit the 45-minute limit. The fix (`--no-hardlinks` at all five per-row clone sites) and the advisor's narrower pattern are in db85ebb, and the final runs above followed it.

Rule breaks, each restored and re-run green:

| Rule | Change | Failing tests |
|---|---|---|
| f | Use parent's initial anchor instead of source fork as merge base. | advanced_fork: expected conflict, received merged |
| g | Choose fast-forward by tree equality. | same_tree_parent: invalid target/source commit relationship |
| h | Remove dirty-parent refusal. | dirty_parent: unobserved work accepted |
| i | Release sole writer before preparation acknowledgement. | want busy scratch_busy, got <nil> |
| j | Materialize before prepared append. | files/index/branch moved before preparation acknowledgement |
| k | Append applied before materialization verification. | verification: failure lost prepared plan |
| l | Remove notice context binding. | foreign binding accepted |
| m | Use scratch creation instead of parent admission as provenance boundary. | admission window/provenance incorrect |
| n-second-half | Refuse abandonment of temporaries, including conflicted sources. | conflicted: unexpected invalid argument |
| o | Retry pending merge-back during Open. | Open executed pending merge |
| r | Complete missing applied-source closure during Open. | Open completed missing closure |
| pin_rollback | Delete overwritten pin entries during undo. | refused prepared append destroyed prior pin ownership or order |

## Fix-up at 9954aec (2026-10-15)

The five findings of the S3b review. The test runs are the coder's final runs on the committed tree (D121), verified by hash: all six changed files' SHA-256 values match 9954aec. The project manager's checks and the harness ran on 3eeba8c, the same tree committed with a wrong message and corrected to 9954aec; go1.27.2, Git 2.55.0.windows.3, Defender real-time protection on.

| Step | Result |
|---|---|
| V1 `go test -count=1 -timeout=19m -v ./internal/core/workspace` (coder) | exit 0; package 517.040 s |
| Whole-package race `-race -count=1 -timeout=29m -v` (coder, alone) | exit 0; package 629.342 s; the 15 slowest below |
| V5 `-race -count=20 -timeout=45m -run 'Writer\|MergeBackWaits\|ProtectedWindow\|TemporaryClosure\|SoleWriter\|ObservationReservation\|SubordinateToken\|Concurrent\|Busy\|Poison\|OnePerPair'` (coder) | exit 0; 1,516.6 s |
| V3 | none: no fuzz target's code changed |
| V6 non-standard imports | `contract/ledger`, `contract/ledger/appender`, `internal/core/ledgerstore` only |
| V7 | `go mod tidy -diff`: none; `go mod verify`: all modules verified |
| V10 | Git 2.55.0.windows.3; Defender real-time protection `True` |
| V12 | `GOOS=linux` and `GOOS=darwin` `go vet ./internal/core/workspace`: exit 0 |
| gofmt, staticcheck, line endings | clean; every file `i/lf w/lf` |
| V4 `go run ./tools/check` with `DWARF_CC` | `check PASSED: all 9 steps passed`, 1,216 s; the package took 442.372 s in the tests step and 423.892 s in the race step |
| V11 `TestCaptureWorkload` | exit 0, 779 s, run alone; 29 lines (`ticket-07-capture-workload.jsonl`). The `lease` line reads 0 ms: its 32 leases finished within one step of this machine's monotonic clock, about 0.5 ms (A.10), so each took under about 16 µs. At db85ebb the same phase read 107.3 ms per lease. |

The race run alone took 629.3 s against S3b's 529.8 s. Per-test comparison of the two logs put the growth across unrelated ticket 06 tests (`TestCapacityScalesWithPairs` 44.8 → 54.7 s, `TestNewRootAfterFailure` 22.4 → 28.6 s), while the plain run's top-level sum stayed 1,302 → 1,304 s. The new `TestMergeBackWaitsForPendingChild` costs about 10 s, and `TestMergeBackWaitsForTaskTurn` fell 24.5 s. The project manager read the growth as machine load [INFERENCE]; the in-check figures are the record.

Rule breaks, each restored and re-run green:

| Rule | Change | Failing tests |
|---|---|---|
| a | Removed Lease's repair-health check; restored green. | `TestTipRepairAtOpenAndBeforeUse/other_lease` |
| b | Retained the failure flag after successful repair; restored green. | `TestTipRepairAtOpenAndBeforeUse/other_lease` |
| c | Moved lockInputs before mergeParent; failed by bounded deadline without hanging; restored green. | `TestMergeBackWaitsForTaskTurn/inputs_update` |
| d | Removed pending-child waiting; failed on repeated acquisition; restored green. | `TestMergeBackWaitsForPendingChild` |
| e | Removed unresolved-parent admission rejection; restored green. | `TestOpenFailsClosedOnF2_07MergeBackRuleBreak/pending_admission` |

The 15 slowest top-level tests and subtests in the coder's race run:

| Test | Seconds |
|---|---|
| `TestOpenFailsClosedOnF2_07MergeBackRuleBreak` | 107.31 |
| `TestOpenFailsClosedOnF2_07RuleBreak` | 54.94 |
| `TestCapacityScalesWithPairs` | 54.74 |
| `TestMergeBackDurableNoticeAndProvenance` | 48.53 |
| `TestWindowBoundsGenerations` | 42.24 |
| `TestMergeBackConflictsRemainWork/content` | 37.58 |
| `TestMergeBackPreparedRecovery/foreign_lock` | 37.34 |
| `TestMergeBackFastForwardAndExplicitBase/multiple_observations` | 37.07 |
| `TestMergeBackPreparedRecovery/third_tip` | 36.34 |
| `TestMergeBackPreparedRecovery/third_value` | 36.30 |
| `TestScratchCommitAndMergeRefsRetained` | 35.50 |
| `TestScratchPathsetBoundIsExplicit` | 35.46 |
| `TestMergeBackFastForwardAndExplicitBase/same_tree_parent` | 35.08 |
| `TestScratchCommitAndMergeRefsRetained/merge_provenance_true` | 35.05 |
| `TestMergeBackPreparedRecovery/verification` | 34.84 |

Package test time inside the full check (tests step / race step): B25 215 / 274 s; S1 229.8 / 288.3 s; S3a 295.3 / 363.0 s; S3b 362.0 / 460.2 s; fix-up 442.4 / 423.9 s. D122's limit is 20 minutes per step, reported above 15.
