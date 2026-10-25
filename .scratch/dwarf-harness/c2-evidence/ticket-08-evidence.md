# Ticket 08 evidence

Each slice's evidence as reviewed, oldest first; the brief, ruling and Git probes sit beside this file. Paths that begin `local://` name the build session's own files, which stay outside the repository. The Git probe copy beside this file was normalized from CRLF to LF line endings (B1); its text is otherwise unchanged, with the long-path probe appended as Follow-up 3.

## Ticket 08 S2 (the F2-08 draft), on c44484d

The evidence the owner's freeze relied on is committed beside this file as [f2-08-freeze-evidence.md](f2-08-freeze-evidence.md). The draft's breaks, from the coder's report:

Rule breaks, each restored and re-run green:

| Rule | Change | Failing tests |
|---|---|---|
| a | Removed intent target-tree inequality. | TestF2_08PayloadsRefuse/intent/same_tree; restored run passed. |
| b | Removed acceptance nonempty-path requirement. | Accepted missing/null/empty changed_paths and nil/empty Encode cases; restored run passed. |
| c | Bypassed path validation at PromotionAccepted.check's F2-08 call site. | Accepted '..' path Encode cases, alongside other invalid paths; restored run passed. scratch_change.go untouched. |
| d | Sorted a copy before the F2-08 path check. | Accepted out-of-order paths, including ["b","a"] and ["é","z"], incorrectly encoded; restored run passed. |
| e | Allowed explicitly present zero in optionalNat. | F2-08 witness=0 and all GenerationDerived witness=0 cases; restored run passed. |
| f | Removed witness/train-predecessor exclusion. | TestGenerationDerivedWitness clean/local/conflict cases; restored run passed. |
| g | Removed finalization-rules validation. | Malformed and overlong intent rules cases; restored run passed. |
| h | Removed uniform Git-ID width checks. | Mixed-length cases for all three record types; restored run passed. |
| i | Dropped PromotionNoChange from Defined. | TestNewCatalogue; restored run passed. |
| j | Changed one F2-08 golden hash byte. | TestGoldenF2_08; restored run passed. |
| k | Changed PromotionAdmitted's encoded inputs revision digit. | TestGoldenF2_06; restored run passed. |
| l | Made DecodePromotionFailed reject cancelled/interrupted with an optional ID. | Existing TestF2_06PayloadsRoundTrip/future_outcome failed, as required. TestF2_08PayloadsRoundTrip, TestF2_08PayloadsRefuse, TestGoldenF2_08 and TestGenerationDerivedWitness all stayed green. Restored combined run passed. |
| m | Removed intent commit and acceptance commit/tree inequalities. | Corresponding same_commit/same_tree refusal cases; restored run passed. |
| n | Removed negative-witness encoder guards from all four records. | F2-08 witness=-1 cases and GenerationDerived negative-witness encoding; restored run passed. |
| o | Removed required UUIDv7 checks from F2-08 payload validation. | Non-v7 Encode refusal cases for all three types; restored run passed. |
| p | Removed Git-ID grammar checks while retaining width equality. | Invalid commit/tree grammar cases across all three types; restored run passed. |


## Ticket 08 S1 evidence, on d4453c0 (2026-10-16)

The test runs are the coder's final runs on the committed tree (D121), verified by hash: all eight changed files match d4453c0. The project manager's checks ran on a detached worktree of d4453c0; go1.27.2, Git 2.55.0.windows.3, Defender real-time protection on.

| Step | Result |
|---|---|
| V1 `go test -count=1 -timeout=19m -v ./internal/core/workspace` (coder) | exit 0; package 598.041 s |
| Whole-package race `-race -count=1 -timeout=29m -v` (coder, alone) | exit 0; package 626.912 s |
| V5 `-race -count=20 -timeout=45m -run 'TrainMutationLock\|GuardedMainUpdate\|CanonicalDurability'` (coder) | exit 0; 426.745 s |
| V3 | none: S1 adds no parser or fuzz target |
| V6 non-standard imports | `contract/ledger`, `contract/ledger/appender`, `internal/core/durable` (new; ruling P14), `internal/core/ledgerstore` |
| V7 | `go mod tidy -diff`: none; `go mod verify`: all modules verified |
| V10 | Git 2.55.0.windows.3; Defender real-time protection `True` |
| V12 | `GOOS=linux` and `GOOS=darwin` `go vet ./internal/core/workspace`: exit 0 |
| gofmt, staticcheck, line endings | clean; every file `i/lf w/lf` |
| V4 `go run ./tools/check` with `DWARF_CC` | `check PASSED: all 9 steps passed`, 1,528 s; the package took 458.804 s in the tests step and 569.302 s in the race step |
| Note 9: the canonical `update-ref` argv and the flush cost | `C:\Users\darius.jones\worktrees\dwarf-harness\t08-s1-evidence\canonical-argv-and-flush.log` (copy in `local://t08-s1-ev/coder-canonical-argv-and-flush.log`); one `hardenCanonicalStorage` call took 196, 188, 190, 213 ms in four runs |

Rule breaks (note 10), each restored and re-run green:

| Rule | Change | Failing tests |
|---|---|---|
| A stale old value must not be accepted. | Removed the expected-old CAS argument through a temporary Go overlay. | `TestGuardedMainUpdate/sha1/packed` |
| Exit zero is not completed durability. | Replaced hardenCanonicalStorage with immediate success through an overlay. | `TestCanonicalDurabilityFailuresHoldEffect/obstructed-pack` |
| Never remove a foreign main.lock. | Inserted main.lock removal before CAS through an overlay. | `TestCanonicalUpdateRefLockAndCheckout/foreign-lock` |
| Do not update checked-out main. | Bypassed the checked-out-main guard through an overlay. | `TestCanonicalUpdateRefLockAndCheckout/checked-out` |
| Never retry update-ref after an ambiguous exit. | Added a second CAS after the cancelled command through an overlay. | `TestGuardedMainUpdateAmbiguousExit` |
| Integration and finalization share one train lock. | Removed integration's shared-lock acquisition through an overlay. | `TestTrainMutationLockShared` |
| Symbolic main must refuse. | Bypassed symbolic-main rejection through an overlay. | `TestGuardedMainUpdate/sha1/symbolic` |
| A link cannot stand in for a directory being flushed. | Changed Lstat to Stat through an overlay. | `TestWindowsFinalizationSharingAndLongPaths/junction` |

The long-path half of note 8's Windows test was dropped: Git refuses any `GIT_DIR` over 220 characters (`local://t08-s1-longpath-probe.md`); the remaining test is `TestWindowsFinalizationSharing`. The break for links ran before that rename, under the old name.

## Ticket 08 S3a evidence, on 09b4593 (2026-10-16)

The test runs are the coder's final runs on the committed tree (D121), verified by hash: all 14 changed files match 09b4593. The project manager's checks ran on a detached worktree of 09b4593; go1.27.2, Git 2.55.0.windows.3, Defender real-time protection on.

| Step | Result |
|---|---|
| V1 `go test -count=1 -timeout=19m -v ./internal/core/workspace` (coder) | exit 0; package 596.803 s |
| Whole-package race `-race -count=1 -timeout=29m -v` (coder, alone) | exit 0; package 677.729 s |
| V5 `-race -count=20 -timeout=45m -run 'TrainMutationLock\|FinalizationOrderAndWitness\|FinalizationStoreFailure\|NoChangeUsesDurablePredecessor\|RepresentedTreePreservesPrivateWork\|WriterRepair'` (coder) | exit 0; 746.502 s |
| Tests over 60 s under race | `TestOpenFailsClosedOnF2_07MergeBackRuleBreak` 103.6 s (53 rows); `TestOpenFailsClosedOnF2_08RuleBreak` 69.2 s (90 rows) |
| V3 | none: no new parser or fuzz target |
| V6 non-standard imports | `contract/ledger`, `contract/ledger/appender`, `internal/core/durable`, `internal/core/ledgerstore` |
| V7 | `go mod tidy -diff`: none; `go mod verify`: all modules verified |
| V10 | Git 2.55.0.windows.3; Defender real-time protection `True` |
| V12 | `GOOS=linux` and `GOOS=darwin` `go vet ./internal/core/workspace`: exit 0 |
| gofmt, staticcheck, line endings | clean; every file `i/lf w/lf` |
| V4 `go run ./tools/check` with `DWARF_CC` | `check PASSED: all 9 steps passed`, 1,602 s; the package took 494.271 s in the tests step and 608.441 s in the race step |

Rule breaks (the coder's `breaks.json`, copy in `local://t08-s3a-ev/coder-breaks.json`): 14, each failing a named test and restored; one mutated `promote.go`, outside the slice, restored with its SHA-256 asserted.

| Rule | Change | Failing tests |
|---|---|---|
| CAS follows intent acknowledgement | Moved guardedMainUpdate before the intent append. | TestFinalizationStoreFailure/workspace.finalization_intended |
| Acceptance follows storage hardening | Moved terminal append before hardenCanonicalStorage. | TestFinalizationOrderAndWitness/accepted, TestFinalizationOrderAndWitness/durability |
| K-slot release follows terminal acknowledgement | Moved freeSlot before appendLocked. | TestFinalizationStoreFailure/workspace.promotion_accepted |
| One CAS per intent | Issued guardedMainUpdate a second time after the first moved result. | TestFinalizationOrderAndWitness/accepted, TestFinalizationOrderAndWitness/durability |
| Failure record kind determines classification | Used the unknown promotion_failed outcome token as RequestState.State. | TestReplayUnknownPromotionFailure |
| Prior acceptance requires its witness key | Skipped witness validation for generation records with a zero witness sequence. | TestOpenFailsClosedOnF2_08RuleBreak/13_missing_witness, TestOpenFailsClosedOnF2_08RuleBreak/26_missing_witness, TestOpenFailsClosedOnF2_08RuleBreak/32_missing_witness |
| Foreign main cannot replace an accepted predecessor | Matched witnesses by sequence alone, ignoring accepted commit and tree. | TestAcceptedPredecessorKeepsSpeculativeGeneration |
| No-change compares trees | Compared derived and predecessor commit IDs instead of trees. | TestNoChangeUsesDurablePredecessor |
| Representation uses the sealed capture tree | Stored the generation derived tree as representedTree. | TestRepresentedTreePreservesPrivateWork/accepted, TestRepresentedTreePreservesPrivateWork/no_change |
| Representation survives a later failed head | Retained the represented capture only while the latest head was not failed. | TestSuccessfulCaptureRetention |
| Pathset cap is checked before intent | Moved acceptance size preflight after the intent append. | TestFinalizationPathsetCapBeforeIntent |
| Refused CAS resolves interrupted with its suffix | Routed a refused result to unresolved finalization_pending. | TestFinalizationOrderAndWitness/refused |
| A no-change parent's unaccepted commit is not a finalization predecessor | Allowed no-change speculative predecessors and tree-only predecessor equivalence through candidate, Git parent, and record binding checks. | TestNoChangeUsesDurablePredecessor |
| Product RequestPromotion remains unavailable after mechanical acceptance | Temporarily replaced the refusal with admission when an accepted witness existed; restored the exact SHA-256 afterwards. | TestRequestPromotionUnavailableInC2 |

## Ticket 08 S3b evidence, on 7a4c9a4 (2026-10-16)

S3b was committed as d8fa46f on 09b4593 and rebased onto F2-09's freeze record and D125 (73769d1) as 7a4c9a4, with `internal/` unchanged. The test runs are the coder's final runs (D121), verified by hash: all 17 changed files match both commits. The project manager's checks and the harness ran on a detached worktree of 7a4c9a4; go1.27.2, Git 2.55.0.windows.3, Defender real-time protection on.

| Step | Result |
|---|---|
| V1 `go test -count=1 -timeout=19m -v ./internal/core/workspace` (coder) | exit 0; package 730.0 s |
| Whole-package race `-race -count=1 -timeout=29m -v` (coder, alone) | exit 0; package 770.6 s |
| V5 `-race -count=20 -timeout=45m -run 'TrainMutationLock\|FinalizationOrderAndWitness\|FinalizationStoreFailure\|NoChangeUsesDurablePredecessor\|RepresentedTreePreservesPrivateWork\|WriterRepair\|Cancellation\|RecoveryInterrupts\|UnfencedWriter\|LostAcknowledgment'` (coder) | exit 0; 1,521.8 s |
| Tests over 60 s under race | `TestOpenFailsClosedOnF2_07MergeBackRuleBreak` 95.5 s (53 rows); `TestFinalizationCrashMatrix` 88.1 s (11 rows) |
| V3 | none: no new parser or fuzz target |
| V6 non-standard imports | `contract/ledger`, `contract/ledger/appender`, `internal/core/durable`, `internal/core/ledgerstore` |
| V7 | `go mod tidy -diff`: none; `go mod verify`: all modules verified |
| V10 | Git 2.55.0.windows.3; Defender real-time protection `True` |
| V12 | `GOOS=linux` and `GOOS=darwin` `go vet ./internal/core/workspace`: exit 0 |
| gofmt, staticcheck, line endings | clean; every file `i/lf w/lf` |
| V4 `go run ./tools/check` with `DWARF_CC` | `check PASSED: all 9 steps passed`, 1,601 s; the package took 507.693 s in the tests step and 621.305 s in the race step |
| V11 `TestCaptureWorkload` | exit 0, 1,178 s, run alone; 45 lines (`ticket-08-capture-workload.jsonl`) |

Rule breaks, each restored with its file's SHA-256 asserted and re-run green:

| Rule | Change | Failing tests |
|---|---|---|
| Intent cutoff | Return cancelled instead of too_late for an intact intent. | `TestCancellationAuthorityAndCutoff/intent_cutoff` |
| Core has no cancellation authority | Coerce core to owner at API entry. | `TestCancellationAuthorityAndCutoff/owner` |
| Supervisor has no cancellation authority | Coerce supervisor to owner at API entry. | `TestCancellationAuthorityAndCutoff/owner` |
| ID knowledge is insufficient | Bypass submitting-context identity validation. | `TestCancellationAuthorityAndCutoff/owner` |
| Foreign survivors remain live | End all train requests rather than only the local suffix. | `TestCancellationFailsLocalSuffixNotForeign` |
| Suffix checkpoint order | Reverse local suffix ending order. | `TestCancellationFailsLocalSuffixNotForeign` |
| Report retention | Unpin the conflict report during an ending. | `TestCancellationRetainsConflictReport` |
| Positive writer proof required | Accept absent or mismatched proof from store ownership. | `TestUnfencedWriterBlocksRecovery/old` |
| Core death does not prove Git completion | Ignore missing completed Wait results for owned Git processes. | `TestWindowsOwnedGitCrashBeforeRecovery`, `TestUnfencedWriterRequiresEveryWait` |
| Timeout is not proof | Treat context cancellation as writer quiescence. | `TestUnfencedWriterBlocksRecovery/old` |
| Queued recovery needs no writer proof | Require proof before interrupting pre-intent requests. | `TestRecoveryInterruptsQueuedWithoutRestart` |
| No second canonical CAS | Issue another guarded main update during target recovery. | `TestUnfencedWriterBlocksRecovery/target` |
| Harden before acceptance | Skip canonical-storage hardening during recovered acceptance. | `TestUnfencedWriterBlocksRecovery/durability` |
| Recovery admission gate | Remove the admission recovery-pending refusal. | `TestRecoveryInterruptsQueuedWithoutRestart` |
| Recovery integration gate | Remove the integration recovery-pending refusal. | `TestRecoveryInterruptsQueuedWithoutRestart` |
| Recovery finalization/no-change gate | Remove the shared finalization-candidate recovery gate. | `TestRecoveryInterruptsQueuedWithoutRestart` |
| Repeat recovery is a no-op | Re-emit an ending on a completed phase. | `TestRecoveryInterruptsQueuedWithoutRestart` |
| Blocked intent retains its slot | Release the intent's slot without positive proof. | `TestUnfencedWriterBlocksRecovery/old` |
| Recovered paths use recorded trees | Compute paths from live main instead of the recorded predecessor. | `TestUnfencedWriterBlocksRecovery/target` |
| In-flight is not unknown | Return ErrUnknownRequest instead of BusyError{request_in_flight}. | `TestCancellationAuthorityAndCutoff/request_in_flight` |

The 15 slowest top-level tests in the coder's race run:

| Test | Seconds |
|---|---|
| `TestOpenFailsClosedOnF2_07MergeBackRuleBreak` | 95.49 |
| `TestFinalizationCrashMatrix` | 88.09 |
| `TestOpenFailsClosedOnF2_08RuleBreak` | 59.40 |
| `TestOpenFailsClosedOnF2_07RuleBreak` | 46.88 |
| `TestCapacityScalesWithPairs` | 42.96 |
| `TestMergeBackDurableNoticeAndProvenance` | 40.33 |
| `TestWindowBoundsGenerations` | 35.44 |
| `TestScratchPathsetBoundIsExplicit` | 33.53 |
| `TestFinalizationPathsetCapBeforeIntent` | 32.37 |
| `TestScratchCommitAndMergeRefsRetained` | 32.34 |
| `TestScratchNoticesScopedAndReplayable` | 29.78 |
| `TestOpenFailsClosedOnF2_06RuleBreak` | 29.01 |
| `TestSuccessfulCaptureRetention` | 27.47 |
| `TestCancellationFailsLocalSuffixNotForeign` | 25.97 |
| `TestAcceptedPredecessorKeepsSpeculativeGeneration` | 25.08 |

Package test time inside the full check (tests step / race step): ticket 07's close 442.4 / 423.9 s; S1 458.8 / 569.3 s; S3a 494.3 / 608.4 s; S3b 507.7 / 621.3 s. D122's limit is 20 minutes per step, reported above 15. The first full check on 73769d1 failed its race step on `TestScratchWaitsOnlyForItsPair`, whose 10 s deadline expired while the coder's focused tests overlapped the check; S3b raised that bound to 2 minutes.
