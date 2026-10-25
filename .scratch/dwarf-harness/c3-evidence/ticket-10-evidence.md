# Ticket 10 evidence

Each slice's evidence as reviewed, in the order the slices reached `main`, beside the [design brief](ticket-10-design-brief.md), the build advisor's [ruling](ticket-10-design-ruling.md), which wins where they differ, and the [F3-10 freeze evidence](f3-10-freeze-evidence.md). [B31](../../../docs/DECISIONS.md#b31-c3-the-private-state-service-ticket-10) records the build. Paths that begin `local://` name the build session's own files, which stay outside the repository. Log and JSON names refer to the coders' evidence folders `t10-s1-evidence`, `t10-s2-evidence`, `t10-s3a-evidence`, `t10-cifix-evidence` and `t10-s3b-evidence`, which also stay outside it; [Where the logs are](#where-the-logs-are) names each kind.

## Machine and method

Every local run was on the project's Windows machine, with go1.27.2 windows/amd64 and Git 2.55.0.windows.3, and with Defender real-time protection on (V10) in every evidence run of the project manager. The coders' final runs are on the committed trees, verified by SHA-256 (D121), and ran serially. The project manager's evidence and checks ran on the exact commits. "The check" is `go run ./tools/check`: without its race step (`-race=false`, D129) on each slice, and in full, uncached and with its race step, on S3b, its fix and 32f3af8. While ticket 61 S6's measurement campaigns had the machine, S3b's runs waited for "machine free", and its fix-up ran between the two campaigns.

## Order on `main`

| Slice | Commits on `main` | Reached `main` | Review |
|---|---|---|---|
| S2, the F3-10 contract | 24d38d0; the freeze record d2e3cd2 (D139) | 2026-10-21 | approve-with-changes |
| S1, the record-free storage mechanics | 45ddafe; its fix 1053df9 | 2026-10-21 | reject; the fix approved |
| S3a, the private-state service | d1946f5; its fix 71a9042 | 2026-10-21 | reject; the fix approved |
| The CI fix | 73462eb | 2026-10-21 | approve |
| S3b, the fault, native and fuzz rows | a6428d7; its fix d99cb60 | 2026-10-22 | approve-with-changes; the fix approved |
| The verification fix-up | 32f3af8 | 2026-10-22 | see its section below |

S2 reached `main` first, unrebased on 976e19b, so that the freeze names the commit that landed; the project manager changed the order under D121. S1 (2401b53) and its fix (478cd0b) were then rebased onto d2e3cd2 as 45ddafe and 1053df9, with the `internal/core/agents` tree byte-identical and every hash matching.

## S1, the record-free storage mechanics (2026-10-21)

Paths, object storage, Markdown materialization and the schema-1 canonical submission, with their tests: 7 files, +1,165, committed as 2401b53, all 7 hashes matching. S1 writes no record and exports no service.

| Step | Result |
|---|---|
| V1 `go test -count=1 -v ./internal/core/agents` (coder) | pass, 0.89 s; slowest test 0.05 s |
| Race (coder) | pass, 2.05 s; slowest test 0.06 s |
| gofmt; `go vet` and staticcheck for all five targets (coder) | clean |
| V5 | none: S1 has no concurrency test |
| V6 non-standard imports (project manager, 2401b53) | `contract/ledger`, `internal/core/durable` |
| V7 | `go mod tidy -diff` clean; all modules verified |
| gofmt, staticcheck, line endings (project manager) | clean |
| Fuzzing | none: S1 adds no fuzz target |
| V4 check without its race step (project manager, 2401b53) | `check PASSED: 8 of 9 steps passed, race skipped (D129) in 429.5s` (tests 383.7 s; `internal/core/agents` 5.7 s) |

Rule breaks, each run once and reverted:

| Break | Failing test | What it showed |
|---|---|---|
| A | `TestPrivateScopeRejectsLinkedAncestors` | all seven ancestor rows failed |
| B | `TestPrivateObjectRefusesCorruption/digest` | corrupt existing bytes were overwritten |
| C | `TestCanonicalSubmissionVectors` | all three vectors failed after the `schema` and `actor` keys were swapped |
| D | `TestBasenameCaseCollision` | a case-sensitive comparison |
| E | `TestBasenameRules` | `Con`, `nUl`, `COM1` and the other reserved names were accepted |
| F | `TestPrivatePublicationRemovesOnlyOwnTemp` | a `.private-*` file leaked |
| G | `TestMarkdownMaterializationAndClassification` | stale was classified as foreign, in all four Markdown slots |
| H | `TestEmptyMarkdownIsCurrent` | empty was classified as missing |

**The fix,** 478cd0b (3 files, +220/−34, all 3 hashes matching), answers the review's major finding with the owner's optimization. Each service instance tracks, under a lock, the owned directories whose flush succeeded, marked child before parent and only after success. Existing directories are flushed once, a replaced directory is flushed again, and the entry checks run on every call. New regressions: `TestPrivatePublicationRetriesAncestorDurability`, `TestPrivateDirectoryDurabilityInstance`, `TestPrivateDirectoryDurabilityRechecksReplacement` and `TestPrivateDirectoryDurabilitySharedPublishers`.

| Step | Result |
|---|---|
| V1 (coder) | pass, 0.84 s |
| Race (coder) | pass, 1.98 s; longest test 0.06 s |
| V5 `TestPrivateDirectoryDurabilitySharedPublishers`, `-race -count=20` (coder) | pass, 2.19 s |
| Breaks I, a persistent ancestor-flush fault bypassed on retry, and J, the mark moved before the flush | each failed `TestPrivatePublicationRetriesAncestorDurability` |
| V6, V7, gofmt, staticcheck, line endings (project manager, 1053df9) | as on 2401b53; clean |
| V4 (project manager, 1053df9) | `check PASSED: 8 of 9 steps passed, race skipped (D129) in 614.7s` (tests 568.9 s; `internal/core/agents` 4.1 s) |

Review: the stand-in rejected S1 at 2401b53 with one major finding: "Directory durability is remembered only within one call. If an ancestor SyncDir fails after creation, the directories remain. A subsequent publication finds them existing, skips every ancestor flush, and can succeed after flushing only the object directory." A second stand-in approved the fix with no findings: "The temporary GPT-6 Astra reviewer approves S1 at 1053df9 under D116 item 5: instance-local, mutex-protected successful-flush caching and identity rechecks resolve the durability finding, supported by regression, race and five-target static evidence; fast-forward remains conditional on the PM’s evidence and exact-commit go run ./tools/check -race=false passing." The verdicts are `local://t10-s1-s2-verdict.md` and `local://t10-s1-rereview-verdict.md`.

## S2, the F3-10 contract (2026-10-21)

The four F3-10 codecs in `contract/ledger/private.go`, the catalogue at 28 type versions, the F3-10 section of the package documentation, and payload, golden, compatibility and fuzz tests: 9 files, +1,299/−3, committed as 24d38d0, all 9 hashes matching. The [freeze evidence](f3-10-freeze-evidence.md) gives V2, V3, V8 and V4 with their commands, and D139 records the freeze.

| Step | Result |
|---|---|
| V1 `contract/ledger` (coder) | pass, 7.3 s |
| Race (coder) | pass, 33.3 s |
| `internal/core/ledgerstore` (coder; project manager on 24d38d0) | pass, 25.6 s; pass, 29.0 s |
| gofmt; `go vet` and staticcheck for all five targets (coder) | clean, once staticcheck's ST1005 was fixed before the final runs |
| V6 (project manager) | no non-standard import |
| V7, gofmt, staticcheck, line endings (project manager) | clean |
| Fuzzing (project manager, 24d38d0) | `FuzzDecodeF3_10` ran 1,637,734 executions in 120 s without a failure and left no corpus file |
| V8 (project manager, 24d38d0) | the regeneration left `contract/ledger/testdata` unchanged; the new golden's SHA-256 is 9622b72877ed546a18fcbfd28a19807e0bab237909e23ffe76e7c3da1c260ecd, and every earlier golden's matches its freeze entry |
| V4 (project manager, 931e6e2, the record commit before its Markdown-only amendment d2e3cd2) | `check PASSED: 8 of 9 steps passed, race skipped (D129) in 552.3s` (tests 477.2 s) |

Rule breaks, each run once and reverted:

| Break | Failing test | What it showed |
|---|---|---|
| A | `TestF3_10Payloads` | a nested duplicate key was accepted |
| B | `TestF3_10PayloadsNestedMembers` | `bytes: null` was accepted |
| C | `TestF3_10PayloadsValues` | an unknown scope was accepted by both codecs |
| D | `TestF3_10PayloadsValues` | the unknown open token `future_kind` was refused |
| E | `TestF3_10Payloads` | a 16,385-byte payload was accepted by all four decoders |
| F | `TestNewCatalogue` | `runtime.command_receipt` was omitted |
| G | `TestF3_10Payloads/registered` | the encoder's keys were reordered |

Review, as D139 records it: "On 2026-10-21 the temporary GPT-6 Astra reviewer returned approve-with-changes for S2 at 24d38d0 together with its F3-10 freeze record and evidence, requiring the receipt-target clarification and fixture-inventory instruction correction, both applied before the D125 freeze, with the record-commit check still required before landing." The verdict is `local://t10-s1-s2-verdict.md`.

## S3a, the private-state service (2026-10-21)

`types.go`, `service.go`, `commands.go`, `replay.go`, `integrity.go`, `read.go` and five test files: 11 files, +2,969, committed as d1946f5, all 18 hashes matching. The production imports are the ruling's dependency set, `contract/ledger`, `contract/ledger/appender`, `internal/core/durable` and `internal/core/ledgerstore` (the project manager's answer during the build). The tests add `internal/core/workspace` for the scratch rows and `os/exec` for their fixture's Git setup.

| Step | Result |
|---|---|
| V1 (coder) | pass, 14.8 s; slowest `TestPrivateScratchBindingsAreDistinct` 9.9 s and `TestPrivateScratchRefreshAcrossOtherCommits` 8.6 s |
| Race (coder) | pass, 21.8 s |
| V5 `-race -count=20` on `TestPrivateExpectedRevisionCAS`, `TestPrivateReceiptReplayAndMismatch` and `TestPrivateIndependentScopesProgress` (coder) | pass, 44.8 s |
| `go vet` and staticcheck for all five targets (coder) | clean |
| V6, V7, gofmt, staticcheck, line endings (project manager, d1946f5) | the four imports above; clean |
| Fuzzing | none: S3a adds no fuzz target; S3b fuzzes the replay code |
| V4, first run (project manager, d1946f5) | `check FAILED: 1 of 9 steps failed in 671.2s`, only on winexec's load-sensitive rows `TestRequiredEnforcementUnavailable` ("supervisor handshake guard expired") and `TestMappedInputCleanup/held-through-grace` (context deadline exceeded), which S3a does not touch. The whole run was slow: `internal/core/ledgerstore` took 407.4 s against 240.8 s on 1053df9. The machine sampled idle afterwards |
| V4, re-run | `check PASSED: 8 of 9 steps passed, race skipped (D129) in 617.5s` (tests 582.3 s; `internal/core/workspace` 576.3 s, `internal/core/agents` 86.3 s) |

Test cost: `internal/core/agents` takes 14.8 s alone but 86.3 s inside the check's parallel load, and 176.4 s in the slow first run. Its tests flush files and directories durably on every store, so they compete for the disk with `ledgerstore` and `workspace`; the check's wall time is still set by `workspace`.

Rule breaks, each run once and restored:

| Break | Failing test | What it showed |
|---|---|---|
| A | `TestPrivateMaterializationFailureAndCancellation` | a false acknowledgement |
| B | `TestPrivateExpectedRevisionCAS` | both competing writes succeeded |
| C | `TestPrivateReceiptReplayAndMismatch` | the revision check refused an existing receipt before replay |
| D | `TestPrivateRebuildIsInert` | Open appended |
| E | `TestPrivateContextsDoNotFollowSelection` | context B read context A's memory |
| F | `TestPrivateReceiptBindingAndPublicPrivacy` | a receipt was returned through another binding |
| G | `TestPrivateIntegrityBlocksAndReports` | a foreign materialization was silently completed |
| H | `TestPrivateExpectedRevisionCAS` | a refused command ID could not be reused |
| I | `TestPrivateRebuildIsInert` | a stray `state.json` affected Open |

**The fix,** 71a9042 (10 files, +139/−70, all 10 hashes matching), answers the review's three findings. F2 owner closures without an envelope context are honored: `TestPrivateScratchClosureActorBinding` appends that variant through the real store, since `workspace.CloseScratch` always supplies the context. `MaterializationError` keeps its cause. `Receipt` and `Limits.MaxConcurrentWrites` replace `CommandResult` and `MaxPendingWrites`, without aliases.

| Step | Result |
|---|---|
| V1, race and V5 (coder) | pass, 6.5 s, 10.0 s and 21.3 s |
| Break J, envelope equality required on every closure again | failed the owner row of `TestPrivateScratchClosureActorBinding` |
| Break K, the cause dropped | failed the original error's classification in `TestPrivateMaterializationFailureAndCancellation` |
| V6, V7, gofmt, staticcheck, line endings (project manager, 71a9042) | the four imports; clean |
| V4 (project manager, 71a9042) | `check PASSED: 8 of 9 steps passed, race skipped (D129) in 476.0s` (tests 423.9 s; `internal/core/agents` 97.4 s) |

Review: "The temporary GPT-6 Astra stand-in reviewer rejects S3a at d1946f5 for fast-forward under D116 item 5 until the F2 compatibility defect and minor findings are corrected and the corrected commit passes the PM’s check; Fable double-checks and verifies this review after its reset." Re-review, with no findings: "The temporary GPT-6 Astra stand-in reviewer approves S3a at 71a9042 for fast-forward under D116 item 5, all three findings resolved, subject to the PM’s evidence validation and passing exact-commit check with -race=false; Fable double-checks and verifies this review after its reset." The verdicts are `local://t10-s3a-verdict.md` and `local://t10-s3a-rereview-verdict.md`.

## The CI fix (2026-10-21)

CI runs 5 and 6 failed on Windows only, in the tests and race steps, on `TestPrivateScopePaths`: `paths_test.go:63: Rel: can't make C:\Users\runneradmin\AppData\Local\Temp\TestPrivateScopePaths…\001 relative to D:\a\dwarf-harness\dwarf-harness\internal\core\agents`. S1's test built a relative colony root with `filepath.Rel` from the working directory to `t.TempDir()`, and the runner's checkout is on `D:` while its TEMP is on `C:`. It is a test-fixture defect, not a product or setup failure, and no other test uses working-directory-relative temporary paths.

73462eb (`paths_test.go`, its hash matching) keeps every other assertion in the parallel `TestPrivateScopePaths` and moves the relative-root check into the sequential `TestPrivateScopeRelativeRoot`, which changes directory with `t.Chdir` into the temporary folder's parent.

| Step | Result |
|---|---|
| Reproduction, rule break L (coder) | with TEMP on a `subst` drive `X:`, the restored test failed with CI's message: `Rel: can't make X:\tmp\TestPrivateScopePaths…\001 relative to …\internal\core\agents` |
| After the fix (coder) | the package passed in 7.2 s with the normal TEMP and in 7.0 s with TEMP on `X:`, and in 10.9 s under race, no race test above 60 s; the `subst` mapping was removed |
| `go vet` and staticcheck for all five targets (coder) | clean |
| V6, V7, gofmt, staticcheck, line endings (project manager, 73462eb) | the ruling's dependency set; clean |
| V4 (project manager, 73462eb) | `check PASSED: 8 of 9 steps passed, race skipped (D129) in 459.8s` (tests 405.9 s; `internal/core/agents` 99.1 s) |

Review, with no findings: "Temporary GPT-6 Astra stand-in reviewer approves ticket 10's coverage-preserving CI fix and fast-forward to 73462eb under D116 item 5, subject to the PM's evidence checks and passing go run ./tools/check -race=false on that exact commit; Fable will double-check and verify this review after its reset." The verdict is `local://t10-cifix-review-verdict.md`.

## S3b, the fault, native and fuzz rows (2026-10-21 and 2026-10-22)

5 files, +815, committed by the project manager as a6428d7, all 5 hashes matching. No production logic changed.

| Test or file | What it adds | It fails on |
|---|---|---|
| `TestPrivateInterruptedRecovery` (`crash_test.go`) | four subprocess rows, each child positively waited for: before the commit, an injected torn commit, after the commit before materialization, and after materialization before the acknowledgement | selecting uncommitted objects, keeping torn effects, losing committed receipts, a duplicate replay effect, a missing stale completion or a recovery append |
| `TestPrivateWindowsSharingRecovery` (`recovery_windows_test.go`) | the native held-Markdown replacement failure | acknowledging a blocked replacement, losing the committed stale state or its cause, leaking temporary files, or appending during the later completion |
| `TestPrivateWindowsLockedSegment` (`recovery_windows_test.go`) | the native `LockFileEx` append failure | reusing a poisoned service or store incarnation, or recovering an uncommitted effect |
| `TestPrivateStorageDirectoryFailures` (`storage_failures_test.go`) | injected directory-sync failures at publication and materialization | swallowing the failure, caching a failed flush, consuming a refused command ID, or losing committed receipt or stale state |
| `TestPrivateCorruptPublicationIsUncommitted` (`storage_failures_test.go`) | corrupt addressed objects and temporary-file cleanup | accepting or overwriting corrupt objects, leaking this call's temporary file, removing another call's, or selecting uncommitted objects |
| `FuzzPrivateGroupReplay` (`replay_fuzz_test.go`), 20 seeds | the production validation and replay of record groups | accepting invalid actors, bindings, operation IDs, receipt digests or targets, predecessors, group shapes, duplicate keys or revision transitions |
| `doc.go` | the package documentation | — |

| Step | Result |
|---|---|
| gofmt; `go vet` and staticcheck for all five targets; `go mod tidy -diff` (coder) | clean |
| Imports (coder) | production: the ruling's dependency set; the tests add `internal/core/workspace`, `os/exec`, `syscall` and `unsafe` |
| V1 (coder) | pass, 8.6 s; slowest `TestPrivateScratchBindingsAreDistinct` 4.09 s |
| Race (coder) | pass, 12.3 s |
| V5 `-race -count=20` on `TestPrivateInterruptedRecovery`, `TestPrivateWindowsSharingRecovery`, `TestPrivateWindowsLockedSegment`, `TestPrivateExpectedRevisionCAS`, `TestPrivateReceiptReplayAndMismatch` and `TestPrivateIndependentScopesProgress` (coder) | pass, 52.3 s |
| The ruling's 60 s bound per test under race (P12) | met: the report's `over60Seconds` is empty |
| Fuzzing (project manager, a6428d7) | `FuzzPrivateGroupReplay` ran 120 s: 96,336 executions, 16 new interesting inputs (36 in total), exit 0, testdata unchanged |
| V6, V7, gofmt, staticcheck, line endings (project manager, a6428d7) | the ruling's dependency set; clean |
| V4 full check, uncached, with its race step (project manager, a6428d7; D129) | `check PASSED: all 9 steps passed in 1007.5s` (tests 394.7 s, race 563.5 s; `internal/core/agents` 105.5 s and 179.1 s) |

Rule breaks, each applied once and restored to its recorded hashes, with `break-<X>-red.log` and `break-<X>-green.log`:

| Break | Failing test | What it showed |
|---|---|---|
| A | `TestPrivateInterruptedRecovery/before_commit` | an uncommitted object caused a stale completion |
| B | `TestPrivateInterruptedRecovery/after_commit` | replay produced revision 3 instead of the immutable revision 2 |
| C | `TestPrivateRebuildIsInert` | the rebuild appended |
| D | `TestPrivateWindowsSharingRecovery` | a blocked replacement returned success |
| E | `TestPrivateWindowsLockedSegment` | the service reused an uncertain store incarnation |
| F | `TestPrivateIntegrityBlocksAndReports/foreign` | foreign bytes were overwritten instead of reported |
| G | `TestPrivateCorruptPublicationIsUncommitted` | a failed publication leaked its temporary file |
| H | `FuzzPrivateGroupReplay` seeds #2 and #3 | an invalid revision actor was accepted |

**The fix,** d99cb60, puts `t.Parallel()` first in `TestPrivateInterruptedRecovery` and in each boundary subtest: 2 lines in `crash_test.go`. All 3 hashes match: `crash_test.go` and the restored `integrity.go` and `commands.go`.

| Step | Result |
|---|---|
| gofmt; `go vet` and staticcheck for all five targets (coder) | clean |
| V1, race and V5 (coder) | pass, 10.2 s, 15.6 s and 42.6 s |
| Breaks A and B, applied again | red, then restored to the baseline hashes and green |
| V6, V7, gofmt, staticcheck, line endings (project manager, d99cb60) | the ruling's dependency set; clean |
| Fuzzing | none: no fuzz target or fuzzed code changed |
| V4 full check, uncached, with its race step (project manager, d99cb60) | `check PASSED: all 9 steps passed in 1039.4s` (tests 400.8 s, race 571.9 s; `internal/core/agents` 86.2 s and 182.0 s); `main` moved from 73462eb to d99cb60 by fast-forward |

Review: "At the owner's instruction, the temporary GPT-6 Astra stand-in reviewer approves S3b at a6428d7 with the parallel-row correction required before fast-forward under D116 item 5 and subject to the PM's full check on the exact corrected commit; Fable double-checks and verifies this review after its reset." Re-review, with no findings: "At the owner's instruction, the temporary GPT-6 Astra stand-in reviewer approves S3b at d99cb60 under D116 item 5: the parallel-row finding is resolved, fixtures and child environments are isolated, positive waits remain, and the child helper stays nonparallel; fast-forward awaits the PM's passing full uncached check with race on that exact commit, and Fable double-checks and verifies after its reset." The verdicts are `local://t10-s3b-verdict.md` and `local://t10-s3b-rereview-verdict.md`.

### What the rows prove

- The crash rows end a child process at each boundary, and the parent waits for it positively before reopening. They are process-death evidence, not power-loss proof.
- The torn tail is injected: the child cuts its last commit, syncs the segment and exits (`crash_test.go:40`), and only the torn row's reopen must report truncated bytes (`crash_test.go:73`).
- The directory-sync failures are injected at the real filesystem boundary: "They prove refusal and retry semantics, not native media or power-loss behavior" (`storage_failures_test.go:15-16`).
- The native Windows rows, from the coder's `v1.log`: replacing a held `Memory.md` failed with Win32 error 5 ("native held-target replacement error=5", "Access is denied"). After the handle's release, Open completed the committed stale revision without an append ("committed stale revision completed without append after handle release"). A `LockFileEx` lock on the ledger segment made the append fail with `ERROR_LOCK_VIOLATION` (33) and poisoned both the service and the store, with no committed effect after reopen ("uncertain append poisoned service and store, no committed effect after reopen").

### P14: the storage-only measurement (D78)

The driver `measurement-main.go` and `measurement-memory_windows.go`, the raw output `measurement.log` and the summary `measurement-summary.json` are in `t10-s3b-evidence`. The summary's own label: "P14 storage-only fixture; not product capacity or an SLA". This is Windows storage-only evidence, not product capacity.

- **Assumption.** One campaign run of nine profiles, each in its own process: 12 and 20 contexts, 1 and 3 callers, at normal payloads of 8, 8, 64 and 1 KiB and at worst-case payloads of four 1-MiB slots at the 4-MiB operation cap, plus a synchronized 16-write burst over 20 contexts and 16 callers. One checkpoint per context per profile (the project manager's answer during S3b). No model, provider or Git work.
- **Checks.** Exact bytes in every changed slot, transcript occurrence counts, receipts equal before and after a clean reopen of the store and the service, and an unchanged durable sequence during reads and replays.
- **Measurement.**

  | Item | Result |
  |---|---|
  | Writes | 144 submitted and applied; 0 refused; 0 busy; 288 replays checked |
  | Throughput, normal payloads | 15.0–25.8 operations per second |
  | Throughput, worst-case payloads | 7.5–12.4 operations per second |
  | Burst | 16 writes in 0.608 s, 26.3 operations per second; latency p50 and p95 0.593 s, max 0.608 s |
  | Recovery at reopen | 0.19–0.94 s |
  | Old-receipt lookups | three positive samples, 1.0, 10.2 and 10.0 ms. Six one-shot samples recorded zero elapsed time; they do not establish zero latency, and no repeat campaign was run |
  | Peak working set | 14,434,304–211,165,184 bytes |
  | Peak commit | 54,018,048–247,984,128 bytes |
  | Ledger bytes | 75,057–124,256 |
  | Private bytes | 1,191,976–125,829,160 |

  Memory includes the callers' inputs and the readback and verification allocations, not just the service.
- **Cost model, not measurement** (the summary's `modelNotMeasurement`, verbatim):
  - "Private write: publish immutable objects, one three-record Submit group, complete Markdown, update availability, acknowledge. Registration and creation use six/four records."
  - "Old receipt and historical-state lookups scan committed history. Open verifies history and selected objects. Latency grows with history; this small calibration is not a scalability bound."
  - "Object file flushes, durable rename/directory flushes, shared ledger submission and Markdown flushes compete for storage. Scope-local preparation can overlap, but ledger transitions serialize; throughput does not multiply with caller count."
  - "The default 16 preparations at the 4-MiB operation cap bound copied supplied bytes by 64 MiB, excluding caller-owned inputs, projection metadata, filesystem/decoder buffers and runtime overhead. That is a model bound, not a measured maximum service footprint."
  - Not in the summary; added at the close from the build advisor's verification and the coder's check of the code: a successful `WritePrivate` scans the ledger from the start twice (`inspectLive`, then `completeScope`, each through `historyDigests`), and Open scans it twice per clean scope (`scopeHistory`, then `completeScope`; `integrity.go:136`, `:153`, `:180`), not only for old-receipt lookups. The projection already holds what these scans recompute; a later entry can keep each slot's committed digest history at install instead.
- **Limits** (the summary, verbatim): "Native execution was Windows only. Five-target static checks are not Linux/macOS runtime evidence. No model, provider or Git workload; no agent-capacity claim."

## The verification fix-up, 32f3af8

The build advisor's verification ([below](#the-reviews)) asked for one test and three small changes, made in 32f3af8 before this close:

- `TestPrivateFrozenGoldenReplay`, which replays F3-10's frozen golden, `contract/ledger/testdata/f3/10/log/00000000000000000001.jsonl`, through the service's own group decoding, planning and installation, so that a drift between the golden's test-side submission encoder and the service's `encodeSubmission` fails a test instead of making Open refuse the golden (the minor finding). The verification asked it to assert the final projection; the golden's records give agent revision 3, general context revision 2, work context revision 6 and three transcript occurrences (the coder's check);
- `doc.go` names the per-write and per-scope history scans in its cost wording;
- `paths.go`'s `os.SameFile(info, info)` gains the comment that it loads the Windows file ID lazily, so a replaced directory cannot later compare equal;
- the two non-blocking selects in `TestPrivateIndependentScopesProgress` that could not fail are removed.

The coder's final runs, on the tree the commit holds (four SHA-256 values checked before and after its rebase onto ticket 61's S6): V1 passed in 11.0 s and the package under race in 14.9 s; vet and staticcheck were clean for the five targets, and `go mod tidy -diff` was clean. Production imports are unchanged, and the tests add only the standard library's `io`. Break M removed `canonicalChange.SHA256`'s `omitzero` tag once: `TestPrivateFrozenGoldenReplay` failed at sequence 23 on the canonical submission digest, and passed again once the tag was restored. Open's two scans per scope are the coder's reading of `integrity.go:136`, `:153` and `:180`, against the verification's "once per scope".

As the ticket's last code commit, 32f3af8 carries its full check, uncached and with its race step (D129): `check PASSED: all 9 steps passed in 1129.5s` (tests 452.5 s, race 623.2 s). That was its second run. The first, `check FAILED: 1 of 9 steps failed in 1178.6s`, failed only the race step, on `internal/core/winexec`'s `TestMappedInputCleanup/held-through-grace` (`recovery_windows_test.go:254`, "mapped-image cleanup bound", with setup at 7.48 s and the stop at 1.28 s against the row's own 1 s `StopGrace`, and cleanup-pending joined with `context deadline exceeded`, without the `ERROR_ACCESS_DENIED` the row expects, so the grace had expired before the unlink's first attempt). winexec is unchanged since d99cb60, whose full check passed. Ticket 45's follow-up review of 2026-10-19 had already ruled the remedy: raise that row's grace to about 2 s if it ever fails under load. Ticket 45's follow-up 4 takes the row. The project manager's evidence on 32f3af8 itself was clean. The package's production imports outside the standard library are `contract/ledger`, `contract/ledger/appender`, `internal/core/durable` and `internal/core/ledgerstore`, as before (V6). `go mod tidy -diff` and `go mod verify` passed (V7), gofmt and staticcheck were clean, the files are LF, and Defender's real-time protection was on (V10). No fuzz target or fuzzed code changed, so nothing was fuzzed. On 2026-10-22 a fresh build advisor (Fable) reviewed 32f3af8 under D116 item 5 together with this close and approved it with no findings: `TestPrivateFrozenGoldenReplay` replays all ten golden commits through the service's `decodeGroup`, `planGroup` and `install` and fails on break M at the canonical submission digest, `doc.go`'s cost wording matches the write path and `inspectOpen`, and `TestPrivateIndependentScopesProgress` keeps every assertion that can fail; the verdict is `local://t10-close-review-verdict.md`. On 2026-10-22 a second fresh build advisor (Fable) confirmed the fast-forward after the first full check on 32f3af8 failed only winexec's `TestMappedInputCleanup/held-through-grace` in its race step and the uncached rerun with race passed all nine steps: the row ended `Closed` and cleanup-pending with its 1 s test `StopGrace` spent before the unlink could report `ERROR_ACCESS_DENIED`, the remedy ticket 45's 2026-10-19 review had already ruled, 32f3af8 touches only `internal/core/agents`, and the project manager's rule for a flake in an untouched package was followed; the confirmation is `local://t10-close-confirm-verdict.md`.

## CI runs 1–8

Each run is the full check on the native jobs (D133). Times are each job's whole check.

| Run | Link | Commit | Windows | Linux | macOS |
|---|---|---|---|---|---|
| 1 | [39366517220](https://github.com/Darius-PJ/dwarf-harness/actions/runs/39366517220) | c6bfc5e | red, 663.6 s: tests and race | red, 615.0 s: staticcheck | red, 207.4 s: staticcheck, tests and race |
| 2 | [39428689904](https://github.com/Darius-PJ/dwarf-harness/actions/runs/39428689904) | 6c59119, `fix/ci-portability` | red, 1,805.8 s: `TestCaptureUnreadable` in tests and race | green, 665.1 s | green, 361.1 s |
| 3 | [39516176219](https://github.com/Darius-PJ/dwarf-harness/actions/runs/39516176219) | 3da420b, `fix/ci-portability` | green, 2,297.2 s | green, 778.3 s | green, 342.4 s |
| 4 | [39636254076](https://github.com/Darius-PJ/dwarf-harness/actions/runs/39636254076) | 976e19b | green, 2,409.0 s | green, 778.3 s | green, 339.0 s |
| 5 | [39660603353](https://github.com/Darius-PJ/dwarf-harness/actions/runs/39660603353) | 1053df9 | red, 1,865.1 s: `TestPrivateScopePaths` in tests and race | green, 502.6 s | green, 357.5 s |
| 6 | [39673391461](https://github.com/Darius-PJ/dwarf-harness/actions/runs/39673391461) | 71a9042 | red, 2,434.8 s: `TestPrivateScopePaths` in tests and race | green, 686.8 s | green, 394.6 s |
| 7 | [39702175106](https://github.com/Darius-PJ/dwarf-harness/actions/runs/39702175106) | 73462eb | green, 2,371.8 s | green, 503.3 s | green, 352.9 s |
| 8 | [39787668459](https://github.com/Darius-PJ/dwarf-harness/actions/runs/39787668459) | d99cb60 | green, 2,207.1 s | green, 711.6 s | green, 362.3 s |

- Runs 1–3 are ticket 138's, recorded in this ticket's comments; run 2 started at 2026-10-20 13:14 UTC and run 3 at 23:37 UTC. Runs 4–8 ran on `main` after each push.
- Images: Windows `windows-2022` 20261012.333.1 with Git 2.56.0.windows.2 in every run; macOS `macos-15-arm64` 20260907.0337.1 with Git 2.55.0 in every run; Linux `ubuntu-24.04` 20261018.339.1 in runs 1, 2 and 6, 20261012.334.1 in runs 3, 4, 5 and 7, and 20261021.345.10 in run 8, each with Git 2.55.0.
- In runs 7 and 8 `internal/core/agents` passed on the Windows runner in 32.1 s and 27.2 s, then 35.4 s and 35.5 s, in the tests and race steps, and `internal/core/workspace` took 731.3 s and 856.1 s, then 693.7 s and 765.9 s.
- Every job of runs 7 and 8 passed all nine steps, with no `--- FAIL`, data race, panic or `##[warning]` line.

## Limits

- A foreign materialization or a missing or corrupt object stays blocked: ticket 10 has no repair path, and ticket 16 or a later entry supplies the authorized repair (the ruling's owner gates).
- A successful private write scans the ledger from the start twice, and Open scans it twice per clean scope, so their cost grows with the ledger; a later entry can keep each slot's committed digest history at install instead.
- A crash between a temporary file's write and its rename leaves an orphaned `.private-*` file in the owning directory, which nothing in ticket 10 sweeps; a publication removes only its own temporary file.
- The crash rows are process-death evidence, not power-loss proof, and the torn tail and the directory faults are injected; the P14 figures are Windows storage-only evidence, not product capacity.

## Where the logs are

The raw logs stay outside the repository, as in C2's and C10's evidence.

- **The coders' runs:** each coder's evidence folder, beside the worktrees, holds its command record with every command, environment, exit code and time (`commands.json` or `commands.jsonl`), the V1, race and V5 logs, and the red and green logs of every rule break: `t10-s1-evidence` for S1 and its fix-up, `t10-s2-evidence`, `t10-s3a-evidence` for S3a and its fix-up (`fixup-*.json`), `t10-cifix-evidence`, and `t10-s3b-evidence` for S3b, with P14's driver, raw output and summary, its fix-up under `fixup`, and the verification fix-up's runs and break M as `fixup2-*`. The coders' reports are `local://t10-s1-coder-report.md`, `local://t10-s1-fixup-coder-report.json`, `local://t10-s2-coder-report.md`, `local://t10-s3a-coder-report.md`, `local://t10-s3a-fixup-coder-report.json`, `local://t10-cifix-coder-report.json`, `local://t10-s3b-coder-report.json`, `local://t10-s3b-fixup-coder-report.json` and `local://t10-fixup-coder-report.json`; the verification fix-up's diff is `local://t10-fixup-diff.md`.
- **The project manager's evidence and checks:** `local://t10-s1-ev/`, `local://t10-s1fx-ev/`, `local://t10-s2-ev/`, `local://t10-s3a-ev/`, `local://t10-s3afx-ev/`, `local://t10-cifix-ev/`, `local://t10-s3b-ev/`, `local://t10-s3bfx-ev/`, `local://t10-fixup-ev/` and `local://t10-fixup-ev2/`, with the summaries `local://t10-s1-evidence.md`, `local://t10-s3a-evidence.md`, `local://t10-cifix-evidence.txt`, `local://t10-s3b-evidence.txt`, `local://t10-s3bfx-evidence.txt`, `local://t10-fixup-evidence.txt` and `local://t10-fixup-evidence2.txt`.
- **The reviews:** the verdict files named under each slice, and the build advisor's verification, `local://fable-verify-a-verdict.md`.
- **The CI runs:** the owner's downloads in his `DwarfHarness` folder: run 1's three job logs at its top level, and runs 2–8 in `Check 2` to `Check 8`, each with the run's URL file.

## The reviews

Every review in this ticket after the ruling was done by a temporary GPT-6 Astra reviewer, `openai-codex/gpt-6-astra` at thinking `max`, standing in for the build advisor while Fable was paused, at the owner's word. B31 quotes his words.

| Review | Reviewer | Commit | Verdict | The owner's order |
|---|---|---|---|---|
| S1, S2 and the F3-10 record | ReviewT10Astra | 2401b53; 24d38d0 | S1 reject (one major); S2 approve-with-changes (one minor, one nit; both applied) | 2026-10-21 14:30 |
| S1's fix | ReReviewT10S1Astra | 1053df9 | approve, no findings | 2026-10-21 14:30 |
| S3a | ReviewT10S3aAstra | d1946f5 | reject (one major, two minor) | 2026-10-21 16:25 |
| S3a's fix | ReReviewT10S3aAstra | 71a9042 | approve, no findings | 2026-10-21 16:25 |
| The CI fix | ReviewT10CIFixAstra | 73462eb | approve, no findings | 2026-10-21 18:08 |
| S3b | ReviewT10S3bAstra | a6428d7 | approve-with-changes (one minor) | 2026-10-21 23:02 |
| S3b's fix | ReReviewT10S3bAstra | d99cb60 | approve, no findings | 2026-10-21 23:02 |

**The build advisor's verification.** On 2026-10-22, at the owner's "The time has come, send the reviews to the Advisor", a fresh build advisor, Fable (`claude-fable-5-1` at xhigh), verified every review above and D139 from part A of `local://fable-verification-request.md`, with `main` at d99cb60, and returned confirmed-with-changes (`local://fable-verify-a-verdict.md`). It confirmed each verdict: S1's major finding was correct and its fix matches the owner's words; S2's two record changes are applied in D139; S3a's major finding was correct against frozen F2's owner-closure rule and is fixed; the CI fix preserves coverage; and both S3b verdicts stand. It confirmed D139 as an assistant freeze under D125 that names its reviewer truthfully, and found no owner gate triggered. Its findings:

| Severity | Location | Finding | Answered by |
|---|---|---|---|
| minor | `internal/core/agents`, against the F3-10 golden | the frozen golden is never replayed through the producer's own rule set; a drift between the test-side encoder (`contract/ledger/private_golden_test.go:49-120`) and the service's `encodeSubmission` would make Open refuse it with no test failing | 32f3af8's `TestPrivateFrozenGoldenReplay` |
| nit | `internal/core/agents/doc.go:69-71` | the cost wording names only old lookups, while every `WritePrivate` scans the whole ledger twice and, in the verdict's words, Open "scans once per scope"; the coder's check of the code found Open scans each clean scope twice (`integrity.go:136`, `:153`, `:180`) | 32f3af8's wording; the cost model above; [Limits](#limits) |
| nit | `internal/core/agents/paths.go:154-157` | `os.SameFile(info, info)` reads as a tautology, but it loads the lazily read Windows file ID so that a replaced directory cannot later compare equal; the comment does not say so | 32f3af8's comment |
| nit | `internal/core/agents/private_test.go:290-299` | two non-blocking selects run straight after the goroutines start and cannot fail on the bugs they name | 32f3af8 removes them |

Its amendments to the close notes are applied here and in B31: the 60 s line is the ruling's P12 bound, and S3b met it; a foreign materialization or a missing or corrupt object stays blocked with no repair path in ticket 10; the cost model names the per-write and per-scope scans; and a crash between a temporary file's write and its rename leaves an orphaned `.private-*` file that nothing in ticket 10 sweeps. It confirmed S3a's notes for S3b as built, with the coder's two corrections: the `LockFileEx` row locks just before `Submit`, since an earlier lock blocked a history read rather than the append, and the held-Markdown replacement fails with native error 5 or 32. It also observed, without a finding, that Open refuses a receipt with `request_id` set or an outcome other than `applied`; a later producer version that writes either needs its own decision.
