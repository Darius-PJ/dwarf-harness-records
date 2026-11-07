# Ticket 142 step-2 profile: `main` 89223cc, cell 12×20×1 (PM summary)

**Run.** `quiet_run.py` label `t142-profile-12x20x1-02` in the detached worktree `142-measure` at 89223cc, with ticket 15's S6 driver (`zz_t15_measure_test.go`, SHA-256 75f68019…) copied in untracked, `-t15-measure=cells -t15-cells=12x20x1`, `-cpuprofile`, `-mutexprofile` and `-blockprofile` at `go test`'s default rates. It started 2026-11-06 19:41:15 EST and finished 20:40:12 (3,537 s; the test itself 3,446 s).

**Status: attribution only.** The PM raised the admission limit to 1.0 core because unrelated load held the 0.25 limit. The run was admitted at 0.66 unrelated cores, and its closing sample read 2.88 cores, partly the designer's activity, which started during the run. Its times are not evidence of anything, and it is not an acceptance instance.

**Outcome.** The runner recorded `failed` (exit 1) because the driver's end-of-cell status listed six turns still unended (three `model_running`, two `waiting_resource`, one `ready`). They are not script samples: all 60 script samples finished with `natural_stop`. The integrity row is clean: not poisoned, close ok, fresh `Open` ok, 0 pending loops. Money: 4,570,252 micros held (attempts that ended `unknown`, kept by design) and 12,600 settled; no administrative model call and no stray request. Setup took 96.8 s to sequence 2,503 (ticket 15's S6 run: 64.7 s). [INFERENCE: profiling overhead and machine load slowed the cell, and the saturation step's held turns had not ended at the cell's end check; the S6 run of this cell listed none.]

**Latency, for context only** (profiled and loaded; ticket 15's S6 run of the same cell in brackets): command→first POST p50/p95 97/154 s (82/164); command→durable final 276/534 s (231/448); tool round trip 84/135 s (67/110).

## CPU (12,395.6 s of CPU in 3,446 s of wall: 3.6 of 8 logical CPUs; r17 2.91)

Cumulative nodes overlap; never add them.

- **Whole-history scans:** `scanReader` 10,226 s cumulative, **82.5% of CPU** (r17: 69%). Inside: `ledger.decodeEnvelope` 7,692 s (62%), SHA-256 about 1,045 s (8.4%); JSON decoding dominates the decode.
- **Who calls `Service.scan`** (10,110 s):

| caller | CPU s | share of `scan` | r17 share of all CPU |
|---|---|---|---|
| `loopSession.Since` (the observer's one page per agent per wake) | 6,645 | 65.7% (**53.6% of all CPU**) | 47% |
| `findCommand` | 1,960 | 19.4% (15.8% of all CPU) | 34% |
| `refreshLocked` | 442 | 4.4% | 10% |
| `scopeHistory` | 316 | 3.1% | |
| `loadPaid` | 172 | 1.7% | |
| `loopRuntime.finalText` | 157 | 1.6% | |
| `loopRuntime.renderTranscript` | 142 | 1.4% | |
| `paidObjectSelected` | 110 | 1.1% | |
| `readPaidObject` (two sites) | 98 | 1.0% | |
| `planLoop` | 66 | 0.7% | |
| `loopRuntime.manifest`, `sourceRecords` | 38, 37 | 0.4% each | |

- **`scanReader` outside `scan`:** `Open`'s replay (`openService`) **699 s, 5.6% of all CPU, for the one fresh `Open` at the cell's end**; `readCommittedRange` 126 s.
- **`findCommand`'s callers** (1,960 s): `acceptCommitLocked` 573 s (29%, mostly inside `Open`'s replay: the reused-command-ID check), `lookupScoped` 493 s (25%), `lookupPaid` 477 s (24%), `loopNative` 151 s, `commitLoop` 140 s, `loopEffectReceipt` 58 s, the loop's `start` 27 s, `coreTool` 17 s, `lookupOperation` 13 s, `perform` 12 s.
- **`acceptCommitLocked`** (925 s): called from `Open`'s replay 699 s (76%), `refreshLocked` 122 s and `executeScopedResult` 105 s; inside it `findCommand` 573 s, `planLoop` 188 s, `planScoped` 110 s, `planPaid` 50 s.
- **Other:** GC about 6.9% (`gcBgMarkWorker` 852 s), `mallocgc` 10.6% cumulative, `runtime.lock` 5.1%.

## Locks

- **Block profile:** 62,877 s blocked in all; `sync.(*Mutex).Lock` 32,939 s (52%), about 9.6 goroutines waiting at any moment on average (r17: about 16). The observer's `Since` spent 17,223 s blocked and `Service.enter` 11,673 s; `selectgo` 24,778 s is ordinary channel waiting.
- **Mutex profile** (30,839 s of contention, charged to the holder's unlock): `loopRuntime.quantum` 70.5% (`model` 38%, `tool` 24%), `executeScopedResult` 30.7%, the Session's `Do`/`start` 28%, `commitLoop` 23.5%, `render` 18.5% (`ReadPrivate` 16.6%), `readPaidObject` 11.7%, `AdmitPaid` 10.5%, `recordPaidEvidence` 10.5% (overlapping).

## Against r17 (3a66a3c, before ticket 15's S5–S7)

`Since`'s share rose and `findCommand`'s fell. [INFERENCE: r17 poisoned at sequence 4,415 after 370 s and never reached this run's longer history or its fresh `Open`; this run's 57 minutes weight the per-wake `Since` pages, and its `Open` adds the quadratic reuse check.] `refreshLocked` stays small (3.6% of CPU) despite S6's `SubmitAt` re-plans.

## Not shown

Per-call cost by operation (no call labels in this run), any time split, or whether a fix works.

## Files (`C:\Users\darius.jones\worktrees\dwarf-harness\t142-profile-evidence\`)

| file | SHA-256 |
|---|---|
| `t142-profile-12x20x1-02.json` | `1e9e065c88ab30452af63141e6fc23ee63f171afc0d8d4eddf747e9b3a21d54f` |
| `t142-profile-12x20x1-02.stdout.log` | `5a51a6503e84f221a7344e74408573bacb66d67a260445468ca15a07d9fd6728` |
| `p1-12x20x1.jsonl` | `b10dcba4f0d3e49b884ca5e6e70c28ae28597fa65aeace8fa7d8227732446e16` |
| `prof-cpu.out` | `794c68fc56787346f7b5ade10009b22ac1b5e94f3700ec8af306c450b7e8634f` |
| `prof-mutex.out` | `1403525e78b4fb969d6bb2697a4c6380f97376283c5a5ea91e891e68776d6049` |
| `prof-block.out` | `60c00e8861379fda6b7afededf8e5c140b9e3aad78eb70320d2d79b83f7ab95a` |
| `agents.test.exe` | `b81147b853aab020b88a4c06e7906a34cf4cd1ca678cc813cb82a0d43b56ddd2` |
| `pprof-cpu-top-cum.log` | `959e221c00715003ee96172ab59317019097df5de7b0535a7830fd95d6af528c` |
| `pprof-cpu-top-flat.log` | `9e8d8f0a50c3eac977394436d0ba698c9b6ebf3952fc0380b4b6225086af67f4` |
| `pprof-cpu-peek-scan.log` | `c526965537667bc932bd70938447f45eb136597965fef7387d9151bd65a649f9` |
| `pprof-cpu-peek-callers.log` | `b92bd107f1565495e2cad4847e2436cf7f21ce13c4456287b6668fa5e67ec47e` |
| `pprof-mutex-top-cum.log` | `e5a0937c2e505fd85a747109673090aca5ed3e732aca9781ce77cf4bbb18d269` |
| `pprof-block-top-cum.log` | `9b26d79335510b1cd9a598222d10aed98111733a0300c5d5b365148785e82f04` |

The kept colony is `p1-colony\`. The pprof views ran with `GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go tool pprof <view> agents.test.exe <profile>`.
