# Ticket 06 evidence

The project manager collected each slice's evidence on the exact commit that reached `main`, before the build advisor's one review of the slice (D46; D116 item 6). Every run was on the owner's machine, the one Core Appendix A.11 describes: Windows 10.0.19045, go1.27.2, Git 2.55.0.windows.3, Windows Defender real-time protection on. Core Appendix A.12 holds the workload measurements; [`ticket-06-capture-workload.jsonl`](ticket-06-capture-workload.jsonl) holds its raw lines.

## S1 at e207472 (2026-10-12)

Collected on 2026-10-12 on a detached worktree of `e20747244be0e6a7fb06bd709037f7979f283363` (branch `build/06-checkpoints`: 8ab2ccf, 6e537b9, 026d483 and e207472 on `main` 408944d); go1.27.2, Git 2.55.0.windows.3, Defender real-time protection on. S2's evidence and full check ran on the same machine during part of this run; no quiet window is needed since D116.

| Step | Result |
|---|---|
| V1 `go test -count=1 -v ./internal/core/workspace` | exit 0, 295 s; 326 tests and subtests run, 323 passed, 3 skipped (`TestHelperScratchCrash`, a child process of `TestOpenReconciles`; `TestCaptureWorkload`, opt-in; `TestRemoveDoesNotFollowSymlink`, Linux and macOS), none failed. Every S1 test passed: `TestCapacityProfileRefusals`, `TestCheckpointSlotsPerPair`, `TestSlotReturnedUnlessKept`, `TestAdmissionBusyIsAtomic`, `TestConcurrentAdmissionReservations`, `TestParseGitVersion`, `TestParseMergeTree`, `TestMergeTreesUsesDeltaBase`, `TestMergeTreesConflictByExitStatus`, `TestIntegrationEnvironment`, `TestDerivedTreeCaseCollision`, `TestIntegrationCommit`, `TestIntegrationLineEndingNeutral`, `TestConflictReport`, `TestGenerationRefsCompareAndSwap`, `TestCaptureInvalidModeKeepsToken`, `TestInputsDigestCoversEveryInput`, `TestCaptureInputsKeepHistoricalGitFloor`. |
| V3 `-fuzz -fuzztime 120s` | `FuzzParseMergeTree`: 4,915,194 executions, PASS; `FuzzParseGitVersion`: 4,123,060 executions, PASS; no file left under `testdata` |
| V5 `-race -count=20 -run 'Slot\|Pool\|Busy\|Waits\|Released\|ConcurrentAdmission'` | exit 0, 250 s, 0 FAIL; 20 PASS each for 13 tests: TestAdmissionBusyIsAtomic, TestCheckpointSlotsPerPair, TestCloseScratchBusy, TestConcurrentAdmissionReservations, TestExclusiveIsImmediateBusy, TestObserveReturnsPoolButKeepsExclusion, TestPoolIsAtomic, TestRequestPromotionBusyBeforeUnavailable, TestReservationReleasedOnEveryPath, TestScratchWaitsOnlyForItsPair, TestServiceCloseWaitsForWriters, TestSlotReturnedUnlessKept, TestWriterWaitsForCapture |
| V6 non-standard imports | `contract/ledger`, `contract/ledger/appender`, `internal/core/ledgerstore` only |
| V7 | `go mod tidy` + `git diff --exit-code -- go.mod go.sum`: no change; `go mod verify`: all modules verified |
| V10 | `git version 2.55.0.windows.3`; Defender real-time protection `True` |
| V12 | `GOOS=linux` and `GOOS=darwin` `go vet ./internal/core/workspace`: exit 0 |
| gofmt, staticcheck | nothing listed; exit 0 |
| Line endings | every file of `internal/core/workspace`, `.omp/agents` and `docs/DECISIONS.md` is `i/lf w/lf` |
| V4 `go run ./tools/check` with `DWARF_CC` | `check PASSED: all 9 steps passed`, 712 s |

**Rule breaks while S1 was built,** from the coder's report; each was made, observed failing the named test and restored: a K check skipped → TestCheckpointSlotsPerPair; b partial acquisition → TestAdmissionBusyIsAtomic; c release after keepSlot frees the slot → TestSlotReturnedUnlessKept; d floor left at 2.42 → TestParseGitVersion; e exit 0 with paths accepted → TestParseMergeTree/{40,64}/clean_with_paths; f anchor as merge base → TestMergeTreesUsesDeltaBase; g conflict by marker text → TestMergeTreesConflictByExitStatus; h repository environment → TestIntegrationEnvironment (evil, union, binary, pinned_local, pinned_global); i case check skipped → TestDerivedTreeCaseCollision; j wall-clock dates → TestIntegrationCommit; k report rows unsorted → TestConflictReport; l mode check after beginCapture → TestCaptureInvalidModeKeepsToken.

## S2 at bde7c68, and the F2-06 freeze record at c2c09de (2026-10-12)

- S2's evidence is the OG-F6 packet's evidence file, [`f2-06-freeze-evidence.md`](f2-06-freeze-evidence.md), collected at 188f5c5. S2 was rebased onto `main` as bde7c68 with its `contract/ledger` byte-identical (`git diff --exit-code 188f5c5 bde7c68 -- contract/ledger`).
- The freeze record c2c09de changed only comment lines in `contract/ledger` (38 of them; no other line) and documents. All nine steps of `go run ./tools/check` passed on c2c09de, in 1,251 s, while S3's coder ran tests on the same machine.

## S3 at 924b717 and its test-only commit fcf23e4 (2026-10-13)

S3 is 924b717. fcf23e4 runs the package's independent tests in parallel and changes no non-test file: `git diff --stat 924b717 fcf23e4 -- ':!*_test.go'` is empty. The runs below are on fcf23e4. The review's fix-up 02edd7b followed, and `main` moved to it; its own runs are in the next section.

| Step | Result |
|---|---|
| V1 `go test -count=1 -timeout=19m -v ./internal/core/workspace` | exit 0, 165 s (package 159.479 s); 446 tests and subtests run, 443 passed, 3 skipped (`TestHelperScratchCrash`, a child process of other tests; `TestCaptureWorkload`, opt-in; `TestRemoveDoesNotFollowSymlink`, Linux and macOS), none failed. Every test S3 added passed; `TestCaptureRefusesSocket`, split from a table by fcf23e4, builds on Linux and macOS only. |
| Shuffled order, `-shuffle=on`, plain | exit 0, 184 s. Without `-v`, `go test` does not print a passing package's seed; the coder's shuffled run with `-v`, on the same tree, passed with seed 1791866360896437400. |
| Race, `-race -count=3 -timeout=45m`, the whole package | exit 0, 577 s; no data race reported |
| V5 `-race -count=20 -timeout=45m -run 'Concurrent\|InFlight\|Replay\|Busy\|Poison\|OnePerPair'` | exit 0, 363 s, 0 FAIL; 20 passes each for 17 tests |
| V6 non-standard imports | `contract/ledger`, `contract/ledger/appender`, `internal/core/ledgerstore` only |
| V7 | `go mod tidy -diff`: no difference; `go mod verify`: all modules verified |
| V10 | Git 2.55.0.windows.3; Defender real-time protection `True` |
| V12 | `GOOS=linux` and `GOOS=darwin` `go vet ./internal/core/workspace ./contract/ledger`: exit 0 |
| gofmt, staticcheck | nothing listed; exit 0 |
| Line endings | every file of `internal/core/workspace` is `i/lf w/lf` |
| V4 `go run ./tools/check` with `DWARF_CC` | `check PASSED: all 9 steps passed`, 712 s. The package took 215.952 s in the tests step and 269.962 s in the race step. |
| V11 `TestCaptureWorkload` | exit 0, 385 s, run alone; 18 lines, nine phases at each of 1,000 and 10,000 files; Core Appendix A.12 and [`ticket-06-capture-workload.jsonl`](ticket-06-capture-workload.jsonl) |

**The tests' cost.** Each run is the whole package, alone on the machine, with Go's default parallelism. Inside the full check, the package ran beside the other packages.

| Measured by | At | Plain (s) | Race (s) |
|---|---|---|---|
| Coder, serially | 924b717 | 532.062 | 580.956 |
| Coder, serially | fcf23e4 | 253.046 | 280.094 |
| Project manager, V1 | fcf23e4 | 159.479 | — |
| Full check (tests and race steps) | e207472, S1 | 259.871 | 317.590 |
| Full check (tests and race steps) | fcf23e4 | 215.952 | 269.962 |
| Coder, serially | 02edd7b | 245.490 | 285.617 |
| Full check (tests and race steps) | 02edd7b | 215.429 | 273.622 |

fcf23e4 makes 139 top-level tests and 48 subtest call sites parallel. Twelve tests or rows stay sequential, each for a reason the advisor's ruling names: they set the environment or the working directory, hold real-time bounds, spawn or are the crash helper, measure, or share one fixture across rows. The reader's survey found no package-level variable assigned by a test and no helper with shared state.

**Rule breaks while S3 was built.** Each change was made, observed failing the named tests and restored, and the restored code passed. The letters are the assignment's.

| Rule | Change | Failing tests |
|---|---|---|
| a | Removed beginRequest's under-exclusion head recheck. | `TestConcurrentRequestsOnePair/head_rechecked_under_exclusion` |
| b | Moved keepSlot before append acknowledgement. | `TestAdmissionFailureRollsBack` |
| c | Removed Open's retained-ref deletion guard. | `TestOpenSweepsUnownedRefs/recorded_and_failed_release` |
| d | Omitted the last successor from an ending cascade. | `TestLocalParentFailureEndsSuffix` |
| e | Added a report unpin to the terminal ending commit. | `TestConflictIsVisibleWork` |
| f | Omitted closure's report unpins. | `TestConflictIsVisibleWork` |
| g | Applied K during replay. | `TestOpenRebuildsAdmissionState` |
| h | Kept a slot on the product's no_validator path. | `TestRequestPromotionUnavailableInC2` |
| i | Performed a real seal on an admitted same-ID replay. | `TestSameIDReplayDoesNotRecapture` |
| j | Included foreign survivors in the failure cascade. | `TestForeignRemovalRebuildsSurvivors` |
| k | Forced derivation on a second integration with existing current generations. | `TestIncrementalCandidatesOverForeignPredecessor` |
| l | Based a restarted root on the failed head's sealed tree. | `TestNewRootAfterFailure` |
| m | Integrated the entire train instead of GenerationWindow. | `TestWindowBoundsGenerations` |

## The review's fix-up at 02edd7b (2026-10-13)

The build advisor's one review of S3, fcf23e4 and these documents approved them with changes. It found two minor faults. Replay and integration scanned every request ever recorded. An ending commit was built and appended under two acquisitions of the service lock, so a successor admitted between them made one `integrate` call fail with `ErrInvalid`. 02edd7b fixes both, with the review's three nits, in `internal/core/workspace` only; `workload_test.go` is unchanged, so A.12's harness run at fcf23e4 stands. The runs below are on 02edd7b, the commit `main` moved to.

| Step | Result |
|---|---|
| V1 `go test -count=1 -timeout=19m -v ./internal/core/workspace` | exit 0, 163 s (package 159.374 s); 448 tests and subtests run, 445 passed, 3 skipped (as at fcf23e4), none failed; `TestConcurrentSuccessorJoinsFailureEnding` and the replay row `manifest_unpin_without_ending` are new and passed |
| V5 `-race -count=20 -timeout=45m -run 'Concurrent\|InFlight\|Replay\|Busy\|Poison\|OnePerPair'` | exit 0, 390 s, 0 FAIL; 20 passes each for 18 tests |
| V6, V7, V10, V12 | as at fcf23e4: the same three non-standard imports; no `go.mod` or `go.sum` difference and all modules verified; Git 2.55.0.windows.3 and Defender on; `go vet` for Linux and macOS exit 0 |
| gofmt, staticcheck, line endings | nothing listed; every file `i/lf w/lf` |
| V4 `go run ./tools/check` with `DWARF_CC` | `check PASSED: all 9 steps passed`, 802 s. The package took 215.429 s in the tests step and 273.622 s in the race step. |
| Race, `-race -count=1 -v`, the whole package, by the coder, serially and alone | exit 0, 285.617 s; the slowest tests `TestCapacityScalesWithPairs` 43.02 s, `TestWindowBoundsGenerations` 33.36 s, `TestOpenFailsClosedOnF2_06RuleBreak` 29.2 s, `TestOpenRebuildsAdmissionState` 21.4 s, `TestSpeculativeConflictWaits` 21.38 s |

**Rule breaks while the fix-up was built.** Each change was made, observed failing the named test and restored, and the restored code passed. In C2 a live child always has a live parent, so breaking rule (b) alone is masked by rule (a); break r removes the parent's capture from the computed retention set instead, as the project manager approved.

| Rule | Change | Failing tests |
|---|---|---|
| n | Temporarily omitted nextScratch.live-- at an ending. | `TestLocalParentFailureEndsSuffix` |
| o | Temporarily omitted usedLineages journal undo. Extended the existing rollback test to retry uncommitted identities after a definite append failure. | `TestAdmissionFailureRollsBack` |
| p | Temporarily removed the live manifest-pin lookup refusal. | `TestOpenFailsClosedOnF2_06RuleBreak/manifest_unpin_without_ending` |
| q | Temporarily restored separate critical sections for ending drafts and append, with beforeAppend between them. | `TestConcurrentSuccessorJoinsFailureEnding` |
| r | Temporarily deleted a live child's parent capture from the computed retention set. PM-approved mutation: C2's whole-suffix rule keeps that parent live, so merely omitting rule (b)'s insertion is masked by rule (a). | `TestOpenRebuildsAdmissionState` |
