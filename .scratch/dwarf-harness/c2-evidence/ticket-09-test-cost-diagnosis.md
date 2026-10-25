# Workspace test-cost diagnosis

## Scope and evidence

Diagnosis only at detached commit `f8e2dbc`. All repository edits were temporary instrumentation or experiments in the disposable probe worktree; no permanent optimization is applied. Raw commands, timing output, counters and scripts live in `C:/Users/darius.jones/worktrees/dwarf-harness/test-cost-evidence/`. Tests ran serially after the PM's “go”, with exclusive access to the machine for these measurements. Normal background services remained active.

## Measurement method and limitations

Subprocess, flush, Open/replay and fixture counters are nested, **not additive**. A/B and 4/8/16 runs use identical instrumentation. Absolute timings differ from the supplied uninstrumented 774.8 s plain/892.3 s race baseline; instrumentation overhead was not separately measured.

Temporary in-process counters cover `gitRunner.runOutput`, the shared test `gitCommand`, held `update-ref` processes, crash-child Start/Wait, `durable.SyncDir`/`Rename`, store Create/Open/rebuild, real segment/body file Sync, workspace Open/read-and-apply replay, and named fixture/history helpers. Git counters include child CPU time; process Start is measured separately. Crash helpers dump before their readiness handshake so a subsequent kill does not erase their counters. Successful parent exit dumps its counters. Startup failure and an in-flight Git command at an intentional kill cannot supply completed child CPU time. Store replay is nested within Open; rename includes SyncDir; Git-product process totals duplicate the Git subcommand totals and must not be added.

Standalone fixtures run three times with real Git/stores. Function timers exclude cleanup; subtest elapsed includes it. Copy experiments use private copies of ordinary immutable Git repos, not linked-worktree or store snapshots. Real Register remains active.

A/B changes TMP/TEMP, including Go executable placement, not Defender policy. Four observations cannot isolate every scanner effect. The serial parallelism sweep is not a controlled thermal experiment; normal background demand varies.

## Source observations before timing

- `helpers_test.go`: new Git fixtures run init/config/add/commit/checkout/version; services add store/Open/Inspect/Register. `serviceFromHistory` already shares history via `clone --no-hardlinks`, but rebuilds services.
- `inputs.go:inspect`: eight config queries, repository/worktree checks and two `git var` calls expose real host settings; do not delete globally.
- `ledgerstore/bodies.go:createBodies`: 256 fan-out directories per store. Metadata work is separate from flush timers.
- `replay_test.go:snapshotReplayPrefixes` already shares history bodies and copies closed prefixes.
- F2-07 repeatedly opens prefixes and appends invalid records. F2-08 already uses exact producer/replay apply plus representative real Open tests.
- Crash matrix: eleven sequential kill/Wait boundaries; current rules exempt crash children from mandatory parallelism.
- Pathset-cap test already uses plumbing for 6,000 paths, then real materialization/removal before intent.
- Capacity test's four slots × four pairs, across two workspaces, check distinct scope/boundary obligations.

## Defender temporary-root comparison

Fixed Git-heavy subset: `TestFinalizationCrashMatrix`, `TestOpenFailsClosedOnF2_07MergeBackRuleBreak`, `TestOpenFailsClosedOnF2_08RuleBreak`, plain `-parallel=4`. Four consecutive runs, roughly 2 minutes 20 seconds each; all passed. A = existing excluded `C:/Users/darius.jones/dwarf-tmp`; B = original/default `C:/Users/darius.jones/AppData/Local/Temp`. TMP and TEMP were both set; original environment is recorded.

| Order | Package seconds | Go-command wall seconds | Mean CPU % | Mean processor performance % |
|---|---:|---:|---:|---:|
| A1 | 138.808 | 139.691 | 61.19 | 119.48 |
| B1 | 137.750 | 139.910 | 53.81 | 123.82 |
| A2 | 139.137 | 140.377 | 60.98 | 119.34 |
| B2 | 138.790 | 140.844 | 54.21 | 123.53 |
| Median A | **138.973** | **140.034** | | |
| Median B | **138.270** | **140.377** | | |

No meaningful package-speed improvement from the excluded root: A was 0.703 s (0.51%) slower; command wall was 0.343 s (0.24%) faster. Even the sign depends on whether build/startup overhead is included. Identical Git counts (2,719 product + 37 helper per run) confirm identical measured work. Store Open fell from about 2.86 s aggregate at B to 0.86 s at A, but that is a small component. This experiment does **not** justify broader Defender exclusions, nor does it prove Defender has zero influence on executable/process costs.

Evidence: `defender-{A1,B1,A2,B2}.meta.json`, matching `.jsonl`, `.cpu.jsonl`, PID counter JSON and before/after process snapshots. Each sampler collected 27 samples. No other test/check was scheduled; normal desktop services remained active.

## Operation and fixture attribution

The default-equivalent `-parallel=8` run is the attribution reference. These are **summed call elapsed seconds**, not additive wall-time buckets; parallel calls overlap and enclosing operations contain lower-level calls.

| Operation | Calls | Aggregate seconds |
|---|---:|---:|
| Product Git | 34,127 | 3,851.262 |
| Test-helper Git | 3,621 | 600.219 |
| Held helper `update-ref` processes | 2 | 2.933 |
| Crash-child lifetimes | 17 | 63.230 |
| Process Start (product Git, held Git, crash children; contained above) | 34,147 | 525.774 |
| Durable SyncDir | 5,171 | 18.525 |
| Durable Rename (includes its SyncDir) | 1,899 | 18.989 |
| Real store segment Sync | 2,584 | 17.892 |
| Real store body Sync | 2,232 | 15.868 |
| Store Create | 391 | 440.707 |
| Store Open | 258 | 13.192 |
| Store projection rebuild (inside Open) | 258 | 0.809 |
| Workspace Open | 922 | 283.905 |
| Read/apply workspace replay (inside Open) | 922 | 12.982 |

Product Git accounts for 90.4% of ordinary Git launches and 86.5% of their aggregate elapsed time. Product/helper Git combined accumulate 759.688 s of child user+kernel CPU versus 4,451.480 s elapsed; the remaining elapsed is **not** all process-creation time. Start itself totals 525.774 s for the instrumented subset. Scheduling, executable/security processing, filesystem work and waits contribute to end-to-end latency. Do not claim that replacing `exec.Start` alone would remove the whole gap.

The biggest product subcommands are rev-parse (7,911 / 871.918 s), config (5,904 / 623.176 s), cat-file (3,556 / 384.620 s), worktree (2,120 / 299.316 s), ls-files (2,664 / 284.123 s), update-ref (2,173 / 280.791 s), ls-tree (1,510 / 176.604 s), read-tree (1,268 / 168.463 s), var (1,476 / 155.524 s), and version (1,394 / 128.917 s). Full subcommand counts, including every helper category, are in `summary.json` and the raw PID files.

Flushes are not the large cost: SyncDir + segment Sync + body Sync sum to 52.286 s at eight-way concurrency, compared with 4,451.480 s in Git. Store Open's actual projection rebuild is under one aggregate second. Conversely, 391 store creations construct approximately 100,096 fan-out directories; Create grows from 71.233 aggregate seconds at four-way concurrency to 440.707 at eight, while package time improves only modestly. That points to concurrent metadata/security/scheduling work, not slow ledger parsing.

The supplied sum of top-level test durations is useful for locating expensive tests, **not** a reliable parallelism/utilization denominator: parent timings omit paused parallel-child work. The four-way run has 1,274.05 top-level seconds yet 2,826.54 Git call-seconds. All shares below keep that distinction.

### Isolated top tests

Each ran alone, plain, `-parallel=4`; all passed. Cells `N/s` mean call count / aggregate seconds. Gp/Gh = product/helper Git; D = durable SyncDir; SO/SR = store Open/rebuild; WO/WR = workspace Open/read-apply replay; C = crash-child lifetime. PID logs retain every subcommand and file-Sync/rename counter.

| Log | Test suffix | Package s | Gp | Gh | D | SO | SR | WO | WR | C |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| top-1 | OpenFailsClosedOnF2_07MergeBackRuleBreak | 48.829 | 702/40.831 | 5/0.374 | 166/0.288 | 67/2.172 | 67/0.182 | 107/16.920 | 107/2.101 | 0/0 |
| top-2 | FinalizationCrashMatrix | 93.320 | 1754/81.260 | 27/3.217 | 255/0.127 | 22/0.520 | 22/0.054 | 33/11.875 | 33/0.030 | 11/55.085 |
| top-3 | OpenFailsClosedOnF2_08RuleBreak | 18.256 | 263/11.989 | 5/0.290 | 75/0.046 | 11/0.174 | 11/0.014 | 14/1.131 | 14/0.106 | 0/0 |
| top-4 | OpenFailsClosedOnF2_07RuleBreak | 33.901 | 422/23.238 | 7/0.618 | 98/2.749 | 39/3.629 | 39/0.071 | 71/13.200 | 71/0.916 | 0/0 |
| top-5 | FinalizationPathsetCapBeforeIntent | 16.143 | 75/9.752 | 11/1.320 | 7/0.009 | 0/0 | 0/0 | 1/0.069 | 1/0.001 | 0/0 |
| top-6 | CapacityScalesWithPairs | 21.541 | 325/17.070 | 10/0.736 | 24/0.014 | 0/0 | 0/0 | 1/0.055 | 1/0 | 0/0 |
| top-7 | MergeBackDurableNoticeAndProvenance | 17.103 | 307/14.154 | 5/0.325 | 13/0.009 | 0/0 | 0/0 | 2/0.752 | 2/0.003 | 0/0 |

The sequential crash matrix spends 84.477 Git call-seconds in a 90.81-second test body: about **93%** there is directly timed Git execution, including work inside killed children. The child lifetime is not extra to that Git time. F2-08's history alone takes 11.237 s; its replay checks are not the dominant part. F2-07's many genuine Opens contribute measurable Git/reconciliation and copied-prefix filesystem work, despite fast actual ledger projection.

### Standalone fixtures and estimated package share

Three isolated repetitions per constructor; table uses median subtest elapsed seconds, including cleanup. The last two rows are diagnostic experiments, not applied optimizations. Existing common-fixture counts/times come from the full p8 run and include nested construction; do not sum every row.

| Fixture | Alone plain s | Alone race s | p8 calls / aggregate body s |
|---|---:|---:|---:|
| newGitFixture | 0.42 | 0.40 | 324 / 344.050 |
| newServiceFixture | 1.91 | 1.98 | 156 / 873.111 |
| serviceFromHistory | 1.82 | 1.82 | 125 / 657.112 |
| newCaptureFixture | 1.66 | 1.65 | 70 / 304.599 |
| newActivationFixture | 0.22 | 0.23 | 14 / 14.863 |
| newFinalizationHistory | 1.15 | 1.17 | 10 / 31.474 |
| newMaterializeHistory | 1.52 | 1.58 | 10 / 42.068 |
| buildPromotionHistory | 10.01 | 10.32 | 1 / 30.790 |
| finalizationReplayHistory | 11.12 | 11.47 | 1 / 30.394 |
| copied Git seed, ordinary Inspect/Register | 1.55 | 1.67 | experiment only |
| copied Git seed + cached immutable Proposal, real Register recheck | 0.99 | 1.04 | experiment only |

The four disjoint primary constructors (newService, serviceFromHistory, newCapture, newActivation) accumulate **1,849.685 s** at p8. Dividing by eight slots gives 231.2 s; dividing by the observed 5.26 average concurrent Git waits gives 351.7 s. Thus **roughly 27–42% of package wall time is fixture-associated work** under those throughput assumptions—not an exact critical-path partition, and not all removable. Nested Git/history/Open times must not be added. Copying a fully built store still creates its hundreds of directories and risks embedded path/identity coupling; the measured experiment copies only the immutable Git seed and retains real store creation.

Separate `fixture-scope-*` runs attribute operations to each constructor (three repetitions, plain). All have **zero store Opens/rebuilds and zero crash children**; stores are freshly created. Counts/times include one initial Git seed for the serviceFromHistory group. `N/s` notation remains aggregate, not per repetition; raw PID/summary metrics give every Git subcommand and file Sync.

| Fixture | Product Git | Helper Git | SyncDir | Store Create | Workspace Open | Read/apply |
|---|---:|---:|---:|---:|---:|---:|
| newGitFixture | 3/0.118 | 15/0.964 | 0/0 | 0/0 | 0/0 | 0/0 |
| newServiceFixture | 93/4.230 | 15/0.971 | 18/0.015 | 3/0.238 | 3/0.148 | 3/0.001 |
| serviceFromHistory | 94/4.131 | 11/1.134 | 18/0.016 | 3/0.237 | 3/0.152 | 3/0.001 |
| newCaptureFixture | 72/3.394 | 18/1.101 | 0/0 | 0/0 | 0/0 | 0/0 |
| newActivationFixture | 3/0.136 | 0/0 | 15/0.025 | 3/0.234 | 3/0.212 | 3/0.044 |
| newFinalizationHistory | 3/0.124 | 57/2.990 | 0/0 | 0/0 | 0/0 | 0/0 |
| newMaterializeHistory | 3/0.128 | 81/4.150 | 0/0 | 0/0 | 0/0 | 0/0 |
| buildPromotionHistory | 564/26.909 | 57/2.993 | 45/0.025 | 3/0.246 | 3/0.141 | 3/<0.001 |
| finalizationReplayHistory | 693/31.701 | 15/0.960 | 123/0.041 | 3/0.242 | 3/0.133 | 3/0.001 |

## Whole-package parallelism and machine limits

All three complete original-package runs passed; the added diagnostic fixture test was skipped. Default temp root, same instrumentation and counters, serial order 4 → 8 → 16. No race detector in these runs.

| `-parallel` | Package s | Command s | CPU samples | Mean CPU % | Median CPU % | Median processor performance % | Mean disk transfer ms | Mean disk queue |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| 4 | 899.762 | 901.680 | 179 | 90.68 | 97.90 | 107.00 | 0.171 | 0.045 |
| 8 | **846.339** | **848.024** | 167 | 92.12 | 100.00 | 106.70 | 0.200 | 0.078 |
| 16 | 887.158 | 888.732 | 173 | 93.84 | 100.00 | 106.57 | 0.184 | 0.069 |

Eight beats four by 53.423 s (5.9%); sixteen loses 40.819 s to eight (4.8%). No evidence supports changing the default. The ordinary Git counts are identical in all three runs. Their aggregate elapsed grows 2,826.54 → 4,451.48 → 7,110.54 s; Store Create grows 71.23 → 440.71 → 1,792.64 s. More queued work inflates individual waits without producing more throughput.

**Bound:** CPU/OS process-and-filesystem lifecycle throughput under contention, not durable disk flush latency or Go replay computation. Small subprocesses plus filesystem metadata/security work dominate; the extra slots stop helping. The clock-performance medians are almost identical across runs. These observations do not prove thermal throttling as the cause of the owner's earlier twofold variation: no temperature/power-limit trace was collected.

Six p4 process samples found MsMpEng at **236–262% of one logical CPU**, test process 40–66%, and svchost PID 9544 at 93–96%. The service lookup identifies **PcaSvc**. These are process CPU percentages, not total-host percentages or recoverable wall savings. Logs: `full-p4.process-cpu-complete.jsonl`, `service-host.json`. An initial sampler failed on disappearing instances (exit 1); its replacement retains invalid status/path entries and distinct instance keys. Earlier incomplete captures are not used.

With tests stopped, a later six-sample idle window found PcaSvc still at **99.7–100.2% of one logical CPU**, while MsMpEng was below 2% in five samples and 2.16% in the sixth. Thus PcaSvc's one-core demand persists independently of the test run; Defender's large sampled demand is load-associated. This still does not establish either service's recoverable wall-time cost. Evidence: `idle.process-cpu-complete.jsonl`; no service/power/security settings changed.

## Ranked causes

These ranks describe overlapping causes, not percentages that can be summed into a partition.

1. **Git/process/metadata throughput:** 37,748 launches, 4,451.48 aggregate elapsed s, 759.69 child CPU s; 44.6 launches/s while host CPU is saturated. The isolated serial crash test's 93% Git-elapsed share directly demonstrates the bottleneck.
2. **Repeated fixtures:** 1,849.69 aggregate construction seconds; estimated **27–42% wall-equivalent share**, nested within Git/filesystem work. Private seed copies and avoiding duplicate fixture inspection are the largest safe candidates.
3. **Serial crash barrier:** 90.24 s in full p8, **10.7% of package elapsed**; other sequential tests total only about 18 s in the supplied baseline. Child/Git time is nested, not extra.
4. **Store metadata contention:** 440.71 aggregate Create seconds at p8, roughly 55–84 wall-equivalent seconds using the stated divisors; 1,792.64 at p16. Repeated 256-directory fan-outs matter; copied stores are not a proven cure.
5. **Flush/replay is secondary:** 52.29 aggregate Sync seconds, 0.81 store rebuild and 12.98 workspace read/apply. Keep real durability and replay coverage; no evidence supports fake flushes or fewer fault boundaries.

## Options for advisor ruling

Savings are **estimated whole-package seconds**, not measured optimized-suite results. Ranges express uncertainty, not confidence intervals. Race estimates use paired fixture/crash experiments and the supplied 892.3-second baseline; the parallelism sweep was plain only. Options overlap and are **not additive**. All require advisor review; “owner” denotes an additional policy/product-seam decision.

| ID | Change and recommendation | Plain / race saving s | Risk and bugs still caught | Owner? |
|---|---|---|---|---|
| O1 | **Copy immutable Git seeds into private repos**, keyed by object format/history. Replace repeated init/commit or clone/checkout; retain real stores. No hardlinks, shared mutable checkout, linked-worktree or pre-registered-store snapshots. | **50 / 50** (30–75 / 25–80) | Low–medium: config/path leakage. Keep explicit setup/Inspect, SHA-1/SHA-256 and real Register/Open tests; capture, isolation, durable-record and replay bugs remain caught. | No; test-only |
| O2 | **Reuse seed Proposal and service Git runner in fixture setup**, rebinding CommonDir. Real Register still reinspects live settings; exclude host-setting/Inspect tests. No product cache/seam. | **85 / 95** (55–115 / 60–125), incremental to O1 | Medium: stale settings or shared mutable host-file bytes. Preserve stale-proposal rejection, normalization/marker, capture and replay assertions; copy mutable proposal data. | No; test-only |
| O3 | **Parallelize crash rows without dropping boundaries**; measured experiment below. | **45 / 45** (25–55 / 25–60) | Medium: child pressure/global state. Preserve all eleven actual Kill/positive Wait cases, torn-tail truncation, exact tip, terminal outcomes, suffix recovery and idempotence. | No; test-only; current rules permit, but do not require, serial crash tests |
| O4 | **Reuse F2-08's producer/replay-apply pattern for F2-07**, retaining every unique mutation and real Open representatives for each distinct record/routing/body/sequence obligation. | **20 / 25** (10–30 / 10–40) | Medium: inadequate Open representatives. Retain exact validation and rollback checks for every row; end-to-end tests still catch missing record consumption, body/sequence errors and fail-closed Open. No product seam. | No; test-only |
| O5 | **Keep `-parallel=8`; reject a gate-flag change on this evidence.** Four and sixteen were slower. | **0 / 0 credited**; observed plain alternatives lose 53.4 / 40.8 s; race sweep not measured | More concurrency raises per-operation waits; less leaves throughput unused. Coverage unchanged, but CI/laptop scheduling can differ. | Yes for changing `tools/check`/D42 |
| O6 | **Do not broaden Defender exclusions from this result.** Existing excluded-temp A/B yielded no material improvement. Executable/cache exclusions were not tested. | **0 / 0 credited**; broader exclusion benefit unknown, race A/B not measured | Security exposure and host-specific behavior; tests retain all assertions, but policy changes are not a test optimization. High MsMpEng CPU alone cannot predict wall-time savings. | Yes; security policy |
| O7 | **Do not trim rows without proven duplicate obligations.** Capacity fill steps, record branches and crash boundaries are distinct. | **0 / 0** | Trimming can lose scope/transition regressions. Keep all unique mutations and exact capacities; no deletion is justified here. | No for proven test-only deduplication |
| O8 | **Do not introduce `-short` as a claimed full-suite optimization.** Workspace currently has no `testing.Short()` checks. Explicit targeted tests can shorten local feedback without redefining the gate. | **0 / 0** for equivalent complete coverage | A tier moves/skips coverage rather than making it cheaper. Full plain/race must still catch real crash, filesystem, capacity and recovery bugs. | Yes for changed gate/D42 or coverage policy |

**Estimate basis:** O1 removes up to roughly 1,870 helper launches (324 fresh fixtures, 125 history clones); O2 roughly 3,934 calls (14 × 281 services), before specialized exclusions/copy overhead. The real prototype's newService medians are **1.91 → 1.55 → 0.99 s plain**, **1.98 → 1.67 → 1.04 s race**; all rows pass. O4 leaves expensive parent-history construction intact, hence its smaller estimate.

Batch/plumbing work must remove redundant setup, not Git semantics under test. Several history/pathset candidates already use plumbing or shared prefixes; evaluate the test-only options before new product caches/seams.

### Crash scheduling experiment

Only parent/row `t.Parallel()` scheduling changed; private stores, immutable shared Git seed and every assertion remain. All eleven boundaries pass both plain and race, with identical **1,754 product + 27 helper Git calls and eleven crash children** in each run. `-parallel=4`:

| Mode | Serial package s | Parallel package s | Observed saving s |
|---|---:|---:|---:|
| Plain (`top-2` → `crash-parallel`) | 93.320 | 41.695 | **51.625** |
| Race (`crash-baseline-race` → `crash-parallel-race`) | 97.864 | 45.699 | **52.165** |

Command-wall savings are 48.040/43.664 s because compilation overhead differs. Parallel parent-test time alone is only 0.43 s: use package elapsed, not that misleading parent value. O3's 45/45 estimate discounts isolated gains for whole-suite contention; the optimized whole package has not been run. Raw Git waits increase with concurrency, but overlap shortens elapsed time.

## Commands and log index

`R = C:/Users/darius.jones/worktrees/dwarf-harness/probe-tests`; `E = C:/Users/darius.jones/worktrees/dwarf-harness/test-cost-evidence`. All commands ran with cwd R. Reproduction driver commands:

```text
python E/measure.py smoke
python E/measure.py defender --index N       # N = 0,1,2,3, in order
python E/measure.py full --parallel N        # N = 4,8,16, in order
python E/measure.py top --index N            # N = 0..6
python E/measure.py fixtures
python E/measure.py fixtures-race
python E/measure.py fixtures-isolated
python E/measure.py crash-baseline-race      # serial source
python E/measure.py crash-parallel           # experimental source
python E/measure.py crash-parallel-race
```

Driver invokes `go test [-race] -json -count=1 -timeout=30m [phase flags] ./internal/core/workspace`. Every command/environment/exit code is in `<label>.meta.json`; output in `<label>.jsonl`; PID counters in `<label>.<pid>.json`; five-second samples in `<label>.cpu.jsonl`. Explicit environment: `GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0`; race uses `CGO_ENABLED=1 CC=C:/Users/darius.jones/AppData/Local/Programs/llvm-mingw-20260922-ucrt-x86_64/bin/x86_64-w64-mingw32-clang.exe`. TMP/TEMP and probe flags are recorded per run.

`summary.json`, generated by `python E/summarize.py`, retains full subcommand, fixture, child/parent and CPU breakdowns; `python E/tables.py` derives compact tables. `sample.ps1` records the two required CPU counters plus disk latency/queue; `process-cpu.ps1`/`process-summary.py` provide the separate process windows. `probe-sources.tar` preserves baseline instrumentation; `experiment-sources.tar` additionally contains cached-Proposal fixtures and parallel crash rows. No dependency was added and no full `tools/check` was run.

**Results:** all **29 Go commands exited 0**, no overlapping Go runs, 4,024.62 s combined command runtime. Required CPU samplers exited 0. Final `python E/quality.py` ran `gofmt -l` on the four modified package directories and `go tool staticcheck ./internal/core/workspace ./internal/core/ledgerstore ./internal/core/durable ./internal/core/testcostprobe`, with `GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0`: both exit **0**, no output (`quality.json` records exact absolute arguments). Source archives, summarization and table commands also exited 0.

## Cleanup and open questions

No permanent repository, dependency, power or security change. Evidence/scripts/source archives remain under E. Main confirmed removal of `probe-tests` and all temporary probe edits, a clean worktree list and clean main checkout. No unresolved diagnosis question; optimization choices await advisor ruling.
