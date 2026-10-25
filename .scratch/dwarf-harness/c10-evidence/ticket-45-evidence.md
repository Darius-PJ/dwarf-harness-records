# Ticket 45 evidence

Each slice's evidence as reviewed, oldest first, beside the [design brief](ticket-45-design-brief.md), the [ruling](ticket-45-design-ruling.md) and the checkpoint probes ([first](ticket-45-checkpoint-probes.md), [second](ticket-45-checkpoint-probes-2.md)). Paths that begin `local://` name the build session's own files, which stay outside the repository. Log and JSON names refer to the coders' evidence folders `t45-s1-evidence` and `t45-s2-evidence`, which also stay outside it.

## Machine state

“Windows Defender real-time protection on; the owner's process exclusions cover Git for Windows' three git.exe files only; no scratch/runs folder exclusion is selected.”

The three excluded paths, as `(Get-MpPreference).ExclusionProcess` read them back in the elevated session that set them (`C:\Users\darius.jones\dwarf-tmp\elev4.log`, 2026-10-16T23:29:48-04:00), with an empty exclusion-path list:

- `C:\Program Files\Git\bin\git.exe`
- `C:\Program Files\Git\cmd\git.exe`
- `C:\Program Files\Git\mingw64\bin\git.exe`

The executed payload is the Go test binary, not Git. Windows 10 Pro 19045; go1.27.2. Every figure below is build-test evidence, not capacity (D78). The race build proves the host executor; the plain run proves the payload rows (the ruling, §8.4).

## Ticket 45 S1 evidence, on 1ed46a5 (2026-10-17)

The test runs are the coder's final runs on the committed tree (D121), verified by hash: all 19 changed files match 1ed46a5. They ran alone on the machine. S1 reached `main` as 0bbd9ee, 1ed46a5 rebased onto 774cccd, with all 19 hashes unchanged.

| Step | Result |
|---|---|
| V1 `gofmt -l`, `go vet`, `go tool staticcheck` on `internal/core/winexec` and `internal/core/durable` (coder, final) | clean |
| V2 `go test -count=1 -v` (coder, final) | winexec ok, 8.034 s; durable ok, 0.531 s |
| V2 race (coder, final) | winexec ok, 12.694 s; durable ok, 1.539 s; longest new test 7.78 s |
| V6 non-standard imports (project manager, 0bbd9ee) | `internal/core/durable`, `golang.org/x/sys/windows` |
| V7 | `go mod tidy -diff`: none |
| V12 | `go vet` for linux/amd64, linux/arm64, darwin/amd64 and darwin/arm64: exit 0 |
| gofmt, staticcheck, line endings (project manager, 0bbd9ee) | clean |
| V4 check without its race step (project manager, 0bbd9ee; D129) | `check PASSED: 8 of 9 steps passed, race skipped (D129)` in 1,070.5 s. The tests step took 1,055.7 s, while `internal/core/workspace` took 265.3 s, winexec 7.8 s, `tools/check` 17.6 s and durable 0.5 s; the rest was Go's test cache, which D131 removed |

Qualification, from the coder's report (ruling §3, §6 and §7):

| Item | Result |
|---|---|
| Profile | regular AppContainer, zero capabilities; no runtime fallback. LPAC rejected: `WSAStartup` failed with 10107, and Go's file I/O with 10093 (§7) |
| Job route | `JOB_LIST`; the suspended process's Job controls and membership read back before resume |
| Console mode | `DETACHED_PROCESS` |
| Token readback | `TokenIsAppContainer` = 1, zero capabilities, the exact fresh AppContainer SID |
| Labels | label-only Low/NW lowering and its readback passed, the DACLs preserved |
| Profile folder | native path, volume/file identity and the fresh SID's write grant bound before launch; cleanup exercised |
| Job-zero | after a normal exit and after CPU-quota termination. Final race quota exit 0xC0000044, mapped to 1816; the Job's user time 62,968,750 ≥ the configured 20,000,000 (100-ns units) |
| Observer handle | after termination the observer saw 0 active processes; after a natural exit, 1 while its handle was open; both 0 once it closed. The product assumes neither |
| Network | the host's own connection with a nonce succeeded; the listener the sandbox dialled accepted no connection and no bytes; the child's error, 10060, is retained |

The checkpoint's logs (`qualification-test-20261017-033608.log`, `-034847.log` and `-041212.log`) and the probe logs are in `t45-s1-evidence`; the probe files beside this one state their results. The race probes of §8 are in `s1-race-observations.json`, `s1-race-20261017-045328.log` and `s1-race-20261017-045528.log`. The teardown after the crashed race run, of seven test profiles and eight temporary roots, is in `crashed-fixture-inventory.json` and `crashed-fixture-teardown.json`.

S1's tests under the race detector, from the coder's final run:

| Test | What it observes | Race s |
|---|---|---:|
| `TestPermittedInputAndBoundedOutput` | authorized exchange, immutable input and output, work and profile writes, accounting and fresh reuse | 4.05 |
| `TestAppContainerJobAndSuspendOrder` | actual token, Job limits and membership verified while suspended | 2.90 |
| `TestProfileGrantBoundary` | Core-only canary denied; fresh-SID and ALL APPLICATION PACKAGES canaries readable | 2.79 |
| `TestNetworkDenied` | host positive control; no connection and no bytes from the sandbox | 3.69 |
| `TestNativeUserCPULimit` | native quota exit, aggregate user accounting and Job-zero before the wall | 7.78 |
| `TestJobZeroWithObserverHandle` | independent Job observation on the terminate and natural paths | 1.42, 2.35 |
| `TestCancelWaitsForEveryDescendant` | a live native Job PID remains after root exit and stdio EOF; cancellation closes the tree before reuse | 2.84 |
| `TestExitCodeDoesNotProveClosure` | a signalled process may legitimately return 259 | 1.22 |
| `TestConcurrentRunIsBusy` | no queued admission; Close prevents resume and closes the active tree | 1.87 |
| `TestOutputBudgetIsSharedAndBounded` | combined stdout and stderr cap, exact boundary, unpublishable overflow | 1.48, 1.45 |
| `TestWallDeadlineStopsWholeTree` | a held native descendant and pending stdin stop together | 4.03 |
| `TestRejectedAdmissionCreatesNothing` | invalid Windows names and an oversized command rejected before effects | 0.02 |
| `TestExpiredAndCanceledAdmissionHasNoEffects` | expired or cancelled admission creates no run resources | 0.05 |
| `TestUnconfirmedFenceNeverReused` | a real sharing failure leaves uncertainty unchanged across Run, Close and Open | 0.17 |
| `TestClosedCleanupRequiresExplicitReopen` | a failed closed cleanup blocks reuse until explicit recovery | 7.66 |
| `TestRootOwnershipAndLock` | exclusive root lock; unrelated contents not adopted | 0.03 |
| `TestOwnedProfileCleanupDoesNotFollowJunctions` | real work and profile junctions: external bytes and security preserved | 1.83 |
| `TestFenceRejectsAmbiguousClosure` | strict rejection of malformed or foreign proof | 0.00 |
| `TestRootMarkerBindsNativeOwner` | foreign owner and trailing data rejected | 0.00 |
| `TestInputChargeIsExactUTF8Budget` | exact byte-budget boundary | 0.00 |
| `TestLimitsNeverDefaultToUnlimited` | absent or unrepresentable finite controls rejected | 0.00 |

Rule breaks, each restored with every owned file's SHA-256 and file set asserted:

| Rule | Change | Failing tests and log |
|---|---|---|
| One shared output budget | independent per-stream budgets | `TestOutputBudgetIsSharedAndBounded/overflow`; `s1-test-20261017-044810.log` |
| Unconfirmed fencing never permits reopen | removed the closed-state recovery requirement | `TestUnconfirmedFenceNeverReused`; `s1-test-20261017-044854.log` |
| Root exit and EOF are not tree closure | accepted root exit instead of native Job-zero | `TestCancelWaitsForEveryDescendant` (revised native fixture); `s1-test-20261017-052232.log` |

Review: The build advisor approved S1 at 1ed46a5 on 2026-10-17 with one major finding, the relabel of an already-exited run as timed out, canceled or shut down when the wall, the caller's deadline or Close arrives during its drain or cleanup, carried to S2 with its regression test, two minor findings and two nits. The fresh reviewer first assigned was stopped by Anthropic's cyber-content filter after 6 s. The verdict is `local://t45-s1-verdict.md`.

## Ticket 45 S2 evidence, on 1066c86 (2026-10-18)

The test runs are the coder's final runs on the committed tree (D121), verified by hash: all 20 changed files match 1066c86 (`final-hashes.json`). S2 reached `main` as 1066c86, with 19356a8 above it, which routes `security_windows_test.go`'s three Job queries through the pinned `queryJob` (the review's minor finding). `command-history.json` records all 58 checks, including the earlier failures and the deliberate mutations.

| Step | Result |
|---|---|
| V1 `gofmt -l`, `go vet`, `go tool staticcheck` on `internal/core/winexec` (coder, final) | clean (`s2-format-20261018-181426.log`, `s2-vet-20261018-181435.log`, `s2-staticcheck-20261018-181444.log`) |
| V2 `go test -count=1 -v -timeout=120s` (coder, final) | exit 0 (`s2-test-20261018-181454.log`) |
| V2 race (coder, final) | exit 0 (`s2-race-20261018-181521.log`); longest test `TestDefenderResourceEvidence`, 14.28 s; every test under 60 s (`final-race-times.json`, `final-slowest15.json`) |
| V6 imports | `go list -deps` (`s2-imports-20261018-181610.log`) |
| V7 | `go mod tidy -diff`: none (`s2-tidy-20261018-181617.log`) |
| V12 | `go vet` for linux/amd64, linux/arm64, darwin/amd64 and darwin/arm64: exit 0 |
| Evidence case alone | `TestDefenderResourceEvidence`: plain 11.69 s, race 12.05 s (`s2-test-20261018-181802.log`, `s2-race-20261018-181829.log`) |
| Fuzzing (project manager, D116 item 6) | `FuzzFenceDecode` ran 4,129,250 executions in 120 s on 19356a8 without a failure |
| V4 full check with its race step (project manager, D129) | passed on 19356a8, the commit `main` moved to by fast-forward (`check PASSED: all 9 steps passed in 749.2s`) |

S2's tests under the race detector, from the coder's report:

| Test | What it observes | Race s |
|---|---|---:|
| `TestNaturalExitKeepsStopGrace` | a later wall, cancel or Close cannot replace a natural exit's stop grace | 2.03, 1.68, 1.67 |
| `TestRejectedAdmissionCreatesNothing` | duplicate and case-colliding paths rejected without admission effects | 0.00 |
| `TestNativeMemoryLimit` | commits and verifies 1 MiB; a finite 512 MiB allocation is denied with native 1455 under a 256 MiB Job quota | 2.05 |
| `TestSeparateRunsCannotReadPeerInput` | separate real SIDs use their own nonce but cannot read or write a disclosed peer's input or work | 2.05 |
| `TestOnlyExplicitStandardHandlesInherited` | a host snapshot of the suspended child finds exactly the three explicit standard handles; no inheritable Core canary or parent pipe end | 1.87 |
| `TestProtectedTargetsDenied` | real Git, ledger, body, metadata, credential, sealed, peer and LocalAppData targets inaccessible and unchanged; the owner pipe receives nothing | 2.55 |
| `TestDescendantsCannotBreakAway` | real root, child and grandchild membership and ancestry; descendants keep the restrictions and cannot break away or reach the outside process | 2.71 |
| `TestLinksAndInputAliasesCannotExpandRoots` | real junctions and hard links cannot widen input, work or profile access; external bytes, identity, DACL and label survive cleanup | 2.11 |
| `TestProfileOwnershipIsNotAdopted` | collision, foreign-owner and replaced-folder cases preserve objects not positively owned | 0.19, 0.05, 3.60 |
| `TestNativeProcessLimitAndHostJobNesting` | the per-run process limit denies an extra spawn while the enclosing Job has spare capacity | 3.61 |
| `TestRequiredEnforcementUnavailable` | an actual outer-Job incompatibility refuses `CreateProcess` with native 1816; no breakaway fallback, resume or output | 3.19 |
| `TestSupervisorLossFenceMatrix` | supervisor loss at all eight boundaries: unconfirmed and orphaned states quarantine; proved closed states permit cleanup and fresh requests only | 0.24–4.16 |
| `TestAmbiguousStopAndClosedFenceWriteFailure` | a retained native Job keeps all three acknowledged actors live after supervisor loss, and later external termination cannot replace durable proof; a sharing-blocked closed-fence rename stays quarantined | 1.98, 2.10 |
| `TestCorruptWrittenFenceCannotAuthorizeCleanup` | fifteen corruptions of real written closed fences cannot authorize cleanup | 0.02–0.05 each |
| `TestClosedCleanupDoesNotFollowReparseOrReuseEarly` | a real sharing-blocked cleanup prevents reuse; explicit reopen removes owned state without following a junction and creates a fresh identity | 9.55 |
| `TestDefenderResourceEvidence` | complete ordinary, cancel and timeout observations without measurement gaps | 14.28 (full suite) |
| `FuzzFenceDecode` | all fifteen seeds pass in the tests; timed fuzzing above | — |

Rule breaks, each restored exactly:

| Rule | Change | Failing tests and logs |
|---|---|---|
| Natural exit retains its stop grace | removed the `stopAt` guard | `TestNaturalExitKeepsStopGrace/cancel`, `/close`, `/wall`; `s2-test-20261018-161535.log`; restoration `natural-stop-guard-restoration.log` |
| Only explicit standard handles are inherited | removed `HANDLE_LIST`; the inheritable Core canary was detected | `TestOnlyExplicitStandardHandlesInherited`; `s2-test-20261018-163628.log`; restoration `broad-handle-inheritance-restoration.log` |
| The process is born in the retained Job | removed `JOB_LIST`; suspended-process membership failed | `TestDescendantsCannotBreakAway`; `s2-test-20261018-170932.log`; restoration `missing-job-list-restoration.log` |
| Native buffers crossing `uintptr` wrappers remain pinned | removed only `setJob`'s pin; the compiler's diagnostics reverted to "p does not escape" | none: compiler evidence, not a runtime failure, as approved; `s2-escape-20261018-175644.log`, `native-pointer-evidence.json`; restoration `missing-native-pin-restoration.log` |

Seven rule breaks in all, S1's three and S2's four.

**The readback refusal.** Once, the resource case's Job controls were refused before resume ("Job controls mismatch"). The diagnostic retry matched exactly: flags 0x220C, active 2, user time 100,000,000, memory 2 GiB. `setJob` and `queryJob` passed stack-resident native structures as `uintptr` through x/sys wrappers ("p does not escape", `s2-escape-20261018-175316.log:789,911`), and so did the out-pointers of `createProfile` and `profileFolder`. They are now pinned with `runtime.Pinner` and moved to the heap, as `-gcflags=-m` shows (`native-pointer-evidence.json`). The refusal is recorded as fixed by the pinning, but it was not conclusively attributed to it. The review found the pins in `createProfile` and `profileFolder` unnecessary, since `LazyProc.Call` carries `//go:uintptrescapes`, but harmless.

**Test profiles.** Fixture teardown removed 45 test-owned AppContainer profiles, by the exact monikers and paths it had logged, after positive native closure and bound-folder identity checks (`removed-test-profiles.json`). No broad profile cleanup and no cleanup of older `TEMP` entries was done. This is evidence of the tests' cleanup, not a product capability: the product deletes only its own bound profile, after proof.

### Resource evidence (brief §6.4; D78)

`TestDefenderResourceEvidence`, the final focused pair run alone, plain and under the race detector; complete records in `resource-evidence.json`.

- **Assumption.** The machine state above. One copied test executable and one held `cmd.exe` descendant per run, a finite exchange and one private scratch file, with no provider or model work. Whole-suite samples are not substituted for these isolated measurements.
- **Calculation.** At most three host pumps, holding at most 98,304 bytes of buffers. The Go allocation deltas cover the whole test supervisor, observers included, and are not attributable slot overhead. Native process memory samples are not summed.
- **Measurement**, in milliseconds:

  | Case | Setup, plain | Setup, race | Execution, plain | Execution, race | Stop, plain | Stop, race |
  |---|---:|---:|---:|---:|---:|---:|
  | ordinary | 804.6 | 928.4 | 48.4 | 51.2 | 14.1 | 15.3 |
  | cancel | 731.8 | 953.9 | 20.7 | 30.5 | 22.2 | 23.5 |
  | timeout | 736.1 | 940.7 | 9,272.8 | 9,059.4 | 21.9 | 24.2 |

  Setup is dominated by profile creation and by staging the executable (the S2 review). The logical files at proved tree exit were these: input of 6,312,980 bytes plain and 8,867,860 bytes under race, the copied test executable; one 256-byte work file; and 0 bytes of ordinary files in the native profile. All six records include separately scoped Core, root and descendant memory samples, Go heap and allocation observations, native Job counters, the bounded exchange, phase timestamps and logical file sizes, with no measurement gaps.
- **Limitations.** Native Job peak counters are not RAM or committed-memory measurements, and logical file bytes are not physical disk allocation.
- **Plan.** No capacity, C4 or A2 qualification is claimed. Declared-workload throughput, admission economics, other C4 environments and qualification are ticket 46's.

Review: The build advisor approved S2 at 1066c86 on 2026-10-18 with no product findings, one minor finding on a test observer's unpinned Job queries and three nits: the S1 stop-grace defect is fixed with its three-row regression, every §6.2 row observes real native state (handle snapshots, Job PID lists, real Git and ledger targets, supervisor kills, retained-Job ambiguity, sharing-blocked renames, fifteen corrupt fences), and the enforcement-readback refusal is fixed by pinning the buffers that cross x/sys uintptr wrappers. The minor finding is fixed in 19356a8. The nit on the Defender sentence is applied in this file's Machine state; the other two nits need no change. The verdict is `local://t45-s2-verdict.md`, and B30 records the ticket.
