# Ticket 147 diagnosis: where `internal/core/agents`' test time goes

PM's diagnosis for ticket 147 ("Cut the agents package's test time", D176). The measured tree is **8c2c1e22ec76ea942650edeeeb763ff929e2a3c6**: `main` d16c779 plus ticket 91 S2 (88f4bb6) and its fix 1, whose tests count toward criterion 1. Evidence: `C:\Users\darius.jones\worktrees\dwarf-harness\t147-pm-evidence\diag-8c2c1e2\`, with the analyzer `C:\Users\darius.jones\dwarf-tmp\gotest_json_summary.py`. Hosted figures come from the owner's saved job logs (`DwarfHarness\CI Logs\Run <id>\`). Local figures come from the owner's laptop and stay private (D145).

## 1. Hosted package times for `internal/core/agents` (seconds; "FAIL" = the 30-minute time-out)

| Run | Commit | Windows plain | Windows race | macOS plain | macOS race | Linux plain | Linux race |
|---|---|---|---|---|---|---|---|
| #100 44454956300 | 751a6ab | 918.217 | ok 1378.182 | 271.213 | FAIL 975.596 | 61.855 | ok 496.627 |
| #101 44455964939 | f6930eb | 939.116 | ok 1385.769 | 265.434 | FAIL 959.027 | 104.216 | ok 526.123 |
| #105 44471432711 | 608e230 | 1019.773 | ok 1478.731 | 272.453 | ok 992.778 | 60.790 | ok 505.538 |
| #109 44595543703 | a4ee351 | 1041.015 | ok 1660.945 | 307.170 | ok 1370.335 | 73.629 | ok 736.746 |
| #121 44866294125 | 88f4bb6 (91 S2) | 1312.323 | FAIL 1800.653 | 324.379 | ok 1209.366 | 84.350 | ok 920.693 |
| #122 44874224657 | 8c2c1e2 (91 S2 fix 1) | 1409.188 | FAIL 1800.383 | 328.350 | FAIL 1512.960 | 131.133 | ok 934.233 |

- **Windows' plain step is about 10× Linux's** (918–1,409 s against 61–131 s), and its race step only 1.3–1.5× its own plain step. **Linux's race step is 7–9× its plain step.** So the Windows cost is operating-system work: file opens, reads, flushes, directory operations and child processes (section 3). Linux's and macOS's race cost is the race detector's CPU overhead on Go code.
- **Windows' plain step is near the 25-minute line too:** 1,409.188 s on #122. D127's 30-minute limit applies to the tests step as well.
- **Growth from #100 to #122,** about two days of tickets (16 S4, 90 S2–S4, 91 S1–S2): Windows plain +53%; Linux race +88%; macOS race +58%.

## 2. Local structure (8 logical CPUs; plain 472 s wall, race 1,557 s wall)

| | plain | race |
|---|---|---|
| package wall | 472 s | 1,557 s |
| leaf-test active time, summed | 3,378 s | 10,548 s |
| effective parallelism | 7.16 | 6.78 |

- **Three phases in race:**
  1. 0–594 s: the **31 sequential top-level tests**, each running its own parallel subtests. The big ones are `TestTurnLoopConcurrentPrivateRuntime` 124 s, `TestTurnLoopTemporaryMergeBack` 138 s, `TestTurnLoopPassiveResults` 146 s, `TestTurnLoopCrashRecovery` 94 s (mean 1.18 tests running), `TestTurnLoopCancelResultRace` 28 s and `TestTurnLoopPersistedWaits` 46 s. About 2,100 slot-seconds of the 8 slots sit idle in this phase.
  2. 594–1,331 s: the **256 parallel top-level tests**, near full occupancy.
  3. 1,331–1,555 s: the **fuzz targets' seed corpora, after everything else**. `FuzzServiceGroupReplay` (ticket 91 S2) takes 145 s of that, with 228 seeds that each copy a colony, open a real store and replay; `FuzzLoopTranscript` 32 s; `FuzzEligibilityGroupReplay` 18 s.
- **Ticket 91 S2's share:** about 16% of the race leaf time. `FuzzServiceGroupReplay` alone is 1,001 leaf-seconds under race against 131 plain (7.6×); `TestServiceCrashConvergence`, `TestServiceReplay`, `TestServiceRaces` and `TestServiceOnset` add about 630.
- **Largest race families** (race leaf-seconds, then plain, then the ratio):
  - `TestTurnLoopPassiveResults` 721 / 288 (2.5×);
  - `TestTurnLoopTemporaryMergeBack` 643 / 183 (3.5×);
  - `TestTurnLoopConcurrentPrivateRuntime` 570 / 50 (11.3×);
  - the review family: `TestReviewGuardBindsOwnerAndAgentButAllowsEscapes` 482 / 175, `TestReviewSlotTransitionsRefuseIllegalEdges` 354 / 175, `TestReviewBindingPreservesSubjectOccurrences` 352 / 157, `TestReviewGroupRules` 213 / 67;
  - `TestTurnLoopPersistedWaits` 309 / 132.

## 3. Where the time goes on Windows: the plain run's CPU profile

The Go profiler on Windows also counts threads waiting inside system calls. Total samples were 3,052 s over 471 s (648%). **82.5% sits in system calls** (`syscall.SyscallN` → `runtime.cgocall`); about 18% is Go code.

| Cumulative | Path |
|---|---|
| 602 s | `(*Service).readRange`: reopens the ledger through `ledger.OpenReaderWithCheckpoint` (358 s) for each read, then `scanReader` (243 s). Callers: `acknowledgeLocked` 181, `scan` 171, `readCommittedRange` 149, `openService` 83, `refreshLocked` 64, `Since` 10 |
| 455 s | file opens (`syscall.createFile`), mostly through the reader reopens above (`scanner.restore`/`open` 346 s) |
| 624 s / 327 s | Git children (ticket 16's `gitprocess`): threads reading child pipes, and `Owner.run` waiting on the child |
| 175 s | `directoryDurability.checkDirectories`, re-run on object operations: from `ensureObjects` 101, `materialize` 37, `readObject` 24, `classifyMaterialization` 13. Inside it: `durable.SyncDir` 82, `Lstat` 53, `Mkdir` 19, `SameFile` 18 |
| 167 s | `FlushFileBuffers` (file flushes) |
| 142 s | `durable.SyncDir`: `checkDirectories` 82, `durable.Rename` 38, ledgerstore 16 |
| 156 s | `os.Mkdir` |
| 142 s | `testing` cleanup (`os.RemoveAll` of `t.TempDir`s) |
| 324 / 292 / 289 / 256 / 166 / 156 s | fixtures: `newLivePaidFixturePeriod`, `newPaidFixturePeriod`, `openService`, `scopedGoldenFixture`, `newTurnFixture`, `openPaidFixture` |

Files: `pprof-top-flat.txt`, `pprof-top-cum.txt`, `plain-cpu.pprof` with `agents.test.exe`.

## 4. Where the time goes under race: the race run's CPU profile

A second race run, profiled, passed in 1,556 s (`race2.json`, `race-cpu.pprof` with `agents-race.test.exe`). Total samples were 7,774 s over 1,552 s (501%).

**The split:**
- **33%** is the race detector's own runtime (`runtime._ExternalCode`), plus about 8% in instrumentation (`racecall`, `racecalladdr`, `raceread`, `checkptr*`);
- **33%** is system calls (`runtime.cgocall`);
- the rest is Go code, led by JSON decoding: `encoding/json/v2.Unmarshal` 736 s cumulative (9.5%).

**The ledger re-read and re-decode path dominates project code:**

| Cumulative | Path |
|---|---|
| 1,500 s (19.3%) | `(*Service).readRange` → `scanReader` 1,148 + `OpenReaderWithCheckpoint` 352. Callers: `(*Service).scan` 860, `openService` 408, `acknowledgeLocked` 293, `readCommittedRange` 159, `refreshLocked` 73, `Since` 30 |
| 860 s (11.1%) | `(*Service).scan`, the cold history reads (ticket 142's `readHistory`). Callers: `loadWork` 342, `sourceRecords` 250 (ticket 91 S2's native-source validation), `inspectOpen` 117, `paidHistoryTotal` 38, `scopeHistory` 28, `loadGrant` 20, and smaller ones |
| 813 s / 404 s | `ledger.decodeEnvelope` / `decodePayload` |
| 691 s / 529 s | `openService` / `Open` (full replay per open) |
| 518 / 512 / 465 s | `acceptCommitLocked`, `prepareHistoryLocked`, `stageCommitLocked` |
| 592 s / 304 s | Git children: pipe reads, `Owner.run` |
| 458 / 381 / 343 / 238 s | fixtures: `newLivePaidFixturePeriod`, `newPaidFixturePeriod`, `scopedGoldenFixture`, `newTurnFixture` |
| 235 s | `FlushFileBuffers` |

**Reading:**
- **The same cost on every system:** reopening the ledger and re-reading and re-decoding records on every acknowledgement, refresh, committed-range read and cold history read costs file opens and reads on Windows, and decode CPU that race instruments 3–8× elsewhere. Every OS pays it.
- **Option P1 widens:** it covers the cold history reads too (`readHistory` → `scan`), for example by reusing decoded records across reads, keeping readers open, or narrowing ranges.

Files: `race-pprof-top-flat.txt`, `race-pprof-top-cum.txt`.

## 5. The macOS failure (criterion 3)

`TestTurnLoopConcurrentPrivateRuntime/openai/shared_memory_cas` failed on run 44874224657's macOS race step after 170.24 s with "wrong applied/stale/POST counts". Locally, race ×5 of `TestTurnLoopConcurrentPrivateRuntime` on 8c2c1e2 passed every time (the row 51–67 s; `t91-pm-evidence\s2-macos\`).
- **The script:** it holds the third context's exchange open until both contenders finish their CAS sequences.
- **Likely cause [INFERENCE]:** on a slow runner the held exchange passes the 120-s dispatch bound (`DispatchTimeout`), which changes the counts. Ticket 16's matrix recorded held private-CAS exchanges failing exactly this way (`unresolved_result`), and ticket 146 item 2 asks whether the dispatch clock should run while an exchange only waits.
- **The family is the most race-sensitive** (11.3× plain).

## 6. Candidate options (for the ruling; the PM ranks none)

**Product changes.** D171: a cost that a hosted runner exposes is fixed in the product.
- **P1, ledger reads without reopening and re-decoding:** `acknowledgeLocked`, `refreshLocked` and `readCommittedRange` read only the new tail from a kept position, and the cold history reads (`readHistory` → `scan`) reuse decoded records or narrower ranges, rather than reopening the ledger from a checkpoint each time. It acts on the 602 s plain above, and on the 1,500 s plus 860 s under race. It must keep the integrity checks and frozen bytes, and ticket 142's directory and tail rules.
- **P2, directory durability verified once per incarnation:** a verified directory isn't re-synced and re-stat'd on every object operation. It acts on the 175 s. The crash guarantee must hold: a directory is verified before first use and again after any failure.
- **P3, fewer flushes per operation** where the durability contract allows, as ticket 16 redesigned its Git owner (D171).

**Test changes.**
- **T1, per-process fixture seeds:** build heavy fixtures once (paid and turn fixtures, golden prefixes), then copy them per test. The stores stay real.
- **T2, parallelise the sequential loop tests** where their seams allow, or give their subtests full parallelism: the 594-s serial phase.
- **T3, `FuzzServiceGroupReplay`'s per-seed cost:** share baselines and avoid a colony copy per seed in seed mode, with seeds kept and parity kept.
- **T4, package-level test parallelism:** the tests mostly wait in system calls, and `-test.parallel` defaults to the runner's 4 vCPUs (3 on macOS arm64). For example, a `TestMain` default when the flag isn't given.
- **T5, the CAS row:** stop the held exchange depending on a wall-clock bound across other turns' full completion, without weakening what the row proves.

**Ruled out** (D127, D171, ticket 147 criterion 4): raising a limit, reconfiguring a runner, skipping a test, `-short`, or moving a test out of the hosted check.

## 7. Measurement for the slice
- **Before and after**, on the exact tree: local plain and race `-json` with the analyzer, plus the plain CPU profile shares.
- **Hosted:** per-package times from the job logs (the owner's download).
- **Criterion 1:** read on ticket 91 S2 rebased onto 147's result.
