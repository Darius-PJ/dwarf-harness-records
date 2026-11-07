# Ticket 15 diagnostic: the paid record the service refused, and the loopback turn latency

DiagT15Paid (coder-claude), 2026-10-31. Worktree `C:\Users\darius.jones\worktrees\dwarf-harness\15-diag`, detached at 3a66a3c (asserted first). Evidence: `C:\Users\darius.jones\worktrees\dwarf-harness\t15-diag-evidence\` (`<ev>` below). Diagnosis only: no product change remains. `git status --porcelain` is empty and `git diff --quiet 3a66a3c` passes.

## 1. Root cause

One ledger store has two independent writers: the agents `Service` and the `workspace.Service` that the turn loop writes through (`EnableTurnLoop(ctx, ws, …)`). `Service.mu` serializes only agents producers. An agents producer refreshes its projection, preflights its group against that projection, then calls `store.Submit`, which appends at whatever the tail is by then. A workspace commit can land between the refresh and the Submit: the loop's own turn-end `Writer.CommitObserved` (`loop_manifest.go:272`) or `MergeBack` (`:278`) runs outside `Service.mu` and appends under the workspace's own lock (`workspace/write.go:688` → `workspace/service.go:308`). The agents reducer then judges the agents group at its real position, after the foreign commit. Two kinds of group carry a fact that the foreign commit makes false:

- **Paid admission and dispatch intent** (F3-13, tickets 13/14) carry a clock sample: `AdmissionUTCNS` (`paid_admit.go:151,178`) or `ObservedUTCNS` (`paid_dispatch.go:246,162`). Replay raises the review floor to every earlier record's event time (`replay.go:483-485`). The store stamps the foreign commit when it appends it (`ledgerstore/store.go:675-684`), which is later than the producer's sample. The reducer's `observed < s.p.reviewFloor` check (`paid_attempt.go:139-140`) then returns `ErrDenied`. This gives the measurement's error, `invalid paid transition: agents: denied`.
- **Loop groups** (F3-15, ticket 15 S3) carry a predicted receipt `EffectSequence = s.p.through+1+len(effects)` (`loop_journal.go:21,109`). Any foreign commit shifts the group, and `decodeLoopGroup` refuses it as `loop effect or sequence` (`loop_replay.go:81-82`).

Either refusal happens inside the producer's own post-Submit `refreshLocked` (`paid_live.go:262`, `loop_journal.go:139` → `replay.go:271-276`). It sets `poisoned`, so every later call returns `service requires reopening`. The bad group is already durable, so a fresh `Open` of that ledger fails at the same sequence. Under D152 this is an integrity defect: a producer commits a record that its own reducer refuses.

The producer's own check passed because it ran against the projection through `s.p.through`, which was the tail at its last refresh, not the tail at append time. The guards and the preflight are `paid_admit.go:180`, `paid_dispatch.go:252` and `paid_live.go:241` for paid, and `loop_journal.go:121` for the loop. No timeout, cancellation or stale cache is involved. `DispatchTimeout` and `ResponseHeaderTimeout` did not fire: every refused group in the logs is the producer's first and only attempt. Families that re-read their committed range or refresh across a gap tolerate the interleave: scoped/private (`scoped_execute.go:346-364`), and paid results (no clock, no predicted position). That is why most interleavings in the logs were harmless.

Load explains why 12 agents fail almost certainly. The agents producers' critical sections are long (full-log scans, §6) and `Service.mu` is busy nearly all the time, so the first B-turn finish of a run (a `CommitObserved`) lands inside some producer's refresh→Submit window. In r1, r6 and r17 the refused group came right after a turn-end `scratch_changed`. r2 survived two earlier ones first.

## 2. Reproduction

Driver: the original's SHA-256 was asserted as 79761165…b524753 and it was copied to `<ev>\driver-original.go.txt`. The diagnostic copy (`<ev>\driver-diag-copy.go.txt`, b2ba175b…5718f2; diff `<ev>\driver-diag-edits.diff`) adds named edits D1-D3: `-t15-measure=cells -t15-cells=AxDxN` and `-t15-keep=<dir>`, which copies each cell's colony after the service and store close. The copy was removed from the worktree afterwards.

| cell (agents×dormant×active) | runs | poisoned | refused group(s) |
|---|---|---|---|
| 12×20×1 | 4 (PM run, r1, r2, r17) | 4 | PM: paid at 4111 (no colony kept); r1: `tool.result` 4099-4101 (receipt effect 4098, actual 4100); r2: `tool.result` 4205-4207; r17 (profiled): `loop.end` 4415-4418 |
| 12×0×1 | 1 (r6) | 1 | `tool.result` 2251-2253 |
| 4×0×1 | 3 (r7, r8, r9) | 1 | r8: `loop.end` 916-919 |
| 3×0×1 | 7 (r10-r16) | 0 | none, but 3 of 7 stranded a turn (§7) |
| 2×0×1 | 3 (r3, r4, r5) | 0 | none |

**Smallest failing cell observed: 4×0×1 (1 of 3).** Dormant contexts are not needed (12×0×1 fails). Every refusal follows a `workspace.scratch_changed` + `ledger.body_pin` commit from another turn's finish (`<ev>\scan-violations.log`). The measurement runs reproduced only the loop form. The paid form needs the foreign commit to land after the sample, which the PM's run hit once.

**Deterministic reproduction:** `<ev>\zz_t15_diag_interleave_test.go` (4b1a0996…bda0d1). It uses a real store, a real loopback TLS turn and the real `workspace.Service` on the same store. A one-shot `deps.beforeSubmit` barrier (it runs under `Service.mu`, after the refresh and preflight, before `store.Submit`) makes the workspace producer commit (`ws.Scratch`, one `workspace.scratch_created`), after spinning one clock tick past the producer's sample. The test asserts the correct contract: the service is not poisoned and a fresh `Open` accepts the history.

- On 3a66a3c (`<ev>\det1-interleave.log`): `control` passes. Every armed row fails as the measurement did: `loop-bind` with `inconsistent record at sequence 126: loop effect or sequence`, `paid-admit` with `… sequence 129: invalid paid transition: agents: denied`, `paid-dispatch` with `… sequence 132: invalid paid transition: agents: denied`.
- On S3's tree 3c10c90 (export via `git archive`, `<ev>\s3tree-det-interleave.log`): identical results.

## 3. The refused commit

The PM's run kept no colony, so its sequence-4111 group cannot be decoded. Its error text identifies it as a paid group refused with `ErrDenied`. Only the admission and the dispatch intent carry the sampled time that a foreign commit invalidates (§4). The deterministic run `<ev>\X1-det3-interleave.log` decodes both forms. It contains no credential values; the ledger holds none.

- **paid-dispatch row, refused group 132-134** (`ledger.command`, `runtime.paid_dispatch_intent`, `runtime.paid_receipt`): `paid.dispatch`, actor core, command 01a190e8-00d7-705e-a581-feb9d2cf009a, attempt 01a190e8-00d7-705c-95d2-913783749728, expected_version 1 → version 2 (`sent`), authority_version 8, `observed_utc_ns` 1793432486156044200.
  - It depends on the admission 128-130 (`paid.admit`, `reserved`, version 1). That admission has `admission_utc_ns` 1793432486129161500, period 2026-10-31, quote `maximum_micros` 200096, scopes colony, agent …00a1, credential …0401 and grant …0999b3, provider anthropic, model claude-haiku-4-5-20251001, route version 3.
  - Foreign commit: 131 `workspace.scratch_created`, event time 1793432486599793400, which is 443.7 ms after the intent's sample.
- **paid-admit row, refused group 129-131**: `paid.admit` reserved, attempt 01a190e8-00e0-705c-bffe-f1bf609fbe85, version 1, `admission_utc_ns` 1793432486135693500, quote 200096 micros over the same four scopes. Foreign commit 128 `workspace.scratch_created` at 1793432486578600100.
- **Measurement r1 (loop form), refused group 4099-4101**: `tool.result`, command …1460fb37, turn …6c3c569a, ctx …dbd44, tool …e78fbf13 (`file_edit_v1`), started_sequence 4008, effect_receipt_sequence 4078 (`local.end`), outcome ok. Receipt `effect_sequence` 4098, actual 4100. Foreign commit 4097-4098: `workspace.scratch_changed` + `ledger.body_pin` for ctx …dbd98 (another agent's B-turn finish), at 1793429386168116300.

## 4. The check

- **Paid:** `paid_attempt.go:139-140`, `observed < s.p.reviewFloor`, reached through `planPaid` → `planPaidAttempt` → `paidCurrent`. For an intent it is `paid_attempt.go:209` with `v.ObservedUTCNS`; for an admission it is `:175` with `p.AdmissionUTCNS`. The projection fact compared is `s.p.reviewFloor`, which equals the foreign commit's event time (`replay.go:483-485`). Instrumented experiment X1 printed it, at both the live refresh and the fresh `Open`:
  `paid_attempt.go:139 floor attempt=01a190e8-00d7-… through=131 observed=1793432486156044200 reviewFloor=1793432486599793400 verified=1793432484169849999 expires=1794037284169849999`
  The profile window holds, so only the floor term is false. No other `ErrDenied` site in `paidAuthority`, `paidCurrent` or `planPaidAttempt` printed.
- **Loop:** `loop_replay.go:81-82`, `receipt.EffectSequence != first+len(d)-2`.

## 5. Producer paths

- **Dispatch:** `loop_runtime.go:401` (quantum → `r.model`) → `loop_continuation.go:117` `DispatchPaidStreaming` → `paid_dispatch.go:142-143` (lock, `paidUsableLocked` → refresh `paid_live.go:136`) → `:153` `dispatchGuardsLocked` → `:246` `samplePaidLocked` (`paid_live.go:118-127`, checked against the stale floor) → `:252` `paidCurrent` passes → `:162` intent `ObservedUTCNS: sample` → `:166` `submitPaidLocked` → `paid_live.go:241` preflight `planPaid` on the unrefreshed projection passes → `:249` `store.Submit` lands after the foreign commit → `:262` `refreshLocked` → `replay.go:271-272` replays the foreign commit (floor raised), then `replay.go:391-398` refuses → `replay.go:276` and `paid_live.go:270-271` set `poisoned`.
- **Admission:** `loop_continuation.go:107` `AdmitPaid` → `paid_admit.go:106` `lookupPaid` (refresh `paid_live.go:168`) → `:122` `admissionGuardsLocked` → `:151` sample, `:178` `AdmissionUTCNS`, `:180` `paidCurrent` passes → `:131` `submitPaidLocked` → as above.
- **Loop:** `tool_execute.go:309` (`tool.result`), `:138` (`tool.begin`), `loop_manifest.go:346` (`loop.end`), `loop_start.go:219` (`loop.bind`) → `loop_journal.go:61` refresh → `:109` `loopDrafts(…, s.p.through+1, …)` (`:21` predicted `EffectSequence`) → `:121` preflight → `:126` Submit → `:139` refresh → `loop_replay.go:81-82`.
- **Interleaver:** `loop_manifest.go:272` `writer.CommitObserved` (and `:278` `MergeBack`), outside `Service.mu` → `workspace/write.go:557` → `:688` `appendLocked` → `workspace/service.go:308` `store.Append`. The workspace expects other appenders: `write.go:544` says "Other producers may append before our commit."

The same latent hazard exists in the review producer: `review_execute.go:104,139-140` and `review_plan.go:142` compare a sample with `s.p.reviewFloor`. The loop does not drive it, and it was not tested.

## 6. Latency (profiled run r17, pristine product, 12×20×1)

The profile flags were `-cpuprofile -mutexprofile -blockprofile` (fractions 1 by default). Files: `<ev>\prof-cpu.out`, `prof-mutex.out`, `prof-block.out` and the binary `agents.test.exe`. Reads: `pprof-cpu-top-cum.log`, `pprof-cpu-peek-scan.log`, `pprof-cpu-peek-callers.log`, `pprof-mutex-top-cum.log`, `pprof-block-top-cum.log`, `pprof-cpu-syscalls.log`.

The run reproduced the measurement: setup 59.9 s to sequence 2503, A turns 79.5–128.4 s command-to-final, first POST 13.9–50.6 s, tool round trips 37.6–60.6 s, B turns 162–199 s. It then poisoned at 4415.

- **CPU against wall:** 1079.89 s of CPU in 370.67 s of wall, which is 2.91 of 8 logical CPUs. The machine is not saturated. The work is serialized by `Service.mu` and duplicated by full-log decoding.
- **Whole-history scans, 69% of CPU:** `agents.(*Service).scan` accounts for 748.75 s cumulative and `scanReader` for 780.84 s. Inside them, `ledger.decodeEnvelope` takes 597 s and SHA-256 about 88 s. `ledger.OpenReader` begins at the segment start, and `Reader.next` decodes and hashes every earlier commit before skipping it (`reader.go:275,294-295`). Every scan therefore costs the whole history (2.5k-4.4k records here), whatever its cursor. Callers of `scan`:
  - `loopSession.Since`, 354 s (47%): the driver's per-wake observer, one page per agent per wake, as a terminal view does (`loop_session.go:272`);
  - `findCommand`, 252.7 s (34%): global command lookups from sequence 0 whenever a pre-minted command ID is ≤ `maxCommand`, which is the normal case with 12 concurrent producers. Its callers are `lookupScoped` 90 s, `lookupPaid` 73 s, `acceptCommitLocked`'s reused-ID check 29 s (`replay.go:347-354`), `commitLoop` 19 s (`loop_journal.go:67-68`), `loopNative`, `lookupOperation`, `perform` and `loopEffectReceipt`;
  - `refreshLocked`, 73 s (10%; callers `submitPaidLocked` 40 s, `commitLoop` 19 s, `perform` 12 s);
  - `scopeHistory` 21 s, `paidObjectSelected` 17 s, `readPaidObject` 16 s.
- **Lock waits:** the block profile shows 6001 s of 9778 s blocked in `sync.(*Mutex).Lock` (`Service.mu`). The waiters are the session's `Do` (2829 s, of which `initialIDs`/`bound` 1410 s), observer pumps (3045 s) and quanta (1940 s). The mutex profile shows 5352 s of contention. It is released from `executeScopedResult` (1946 s), `commitLoop` (1370 s), `AdmitPaid` (541 s), `recordPaidEvidence` (479 s), `readPaidObject` (448 s) and `dispatchPaid` (377 s): the critical sections that run full scans under the lock. Averaged over the run, about 16 goroutines were waiting for `Service.mu` at any moment.
- **Other costs:** GC is about 7% (`gcBgMarkWorker` 70 s, `mallocgc` 85 s; decode allocations). Syscalls are 6% (log file reads 25 s, opens 21 s, git exec pipes 14 s). fsync is not visible as a dominant cost; the block profile does not cover blocking syscalls. Repeated authority checks do not show above the 5.4 s node cut.
- **Scaling:** at 2×0×1 (r3) the same scripts take 2.4–7.7 s, and the first POST grows from 0.5 s to 2.1 s as the history grows from 193 to about 900 records. Per-operation cost grows with history size, and `Service.mu` multiplies it by the number of concurrent turns.

Latency remedies (not implemented; no frozen record or golden changes): reuse `ledger.OpenReaderWithCheckpoint` (today used only by scoped acknowledgements) or keep an in-memory tail cursor so that `refreshLocked`, `Since` and tail scans read only new commits; keep an incarnation command-ID index so that old-ID checks (`findCommand` from 0, `replay.go:347-354`, `loop_journal.go:67-68`) stop rescanning; and move cold scans out of `Service.mu`. A benchmark-style measurement row (per-operation scans against history size) would prove each.

## 7. Second finding: a busy workspace capture at turn end strands the turn (3×0×1: r10, r14, r16)

In 3 of 7 runs of 3×0×1 the driver never returned. r10 was killed at 1500 s; r14 and r16 ended on a `-timeout` goroutine dump. The dump shows the scheduler idle at `loop_runtime.go:347`, no quantum goroutine, and one script waiting for a `turn_result`. The ledger (`r10-colony`, `r14-colony`, `r16-colony`) shows agent 0's B turn: final model call settled at seq 683-685, then no `scratch_changed` and no `loop.end`. The other two B turns committed their observations (686, 688).

Instrumented experiment X2 printed the ending: `loop_runtime.go:358 turn=01a190f5-b5bf-… state=recovery_pending err=workspace: busy: capture_budget`. Three B turns finish together, and each `CommitObserved` reserves `MaxBytes` (1 MiB) from the fixture's `BytesInFlight` (2 MiB) (`workspace/write.go:622`, `reserve.go:87-88`). The third gets `BusyError{capture_budget}`.

`finish()` turns any error into `recovery_pending` (`loop_manifest.go:213-222`, error from `:272`). The scheduler then deletes the turn (`loop_runtime.go:358-361`) with no durable ending: no `loop.end`, no native turn end, the binding left for `Open`'s `PendingLoops`. This contradicts `doc.go:882-884` ("Busy from a local or paid entrance parks the turn as waiting_resource"). The driver hangs because it waits only for a `turn_result`. S4 did not touch this path (S4's `loop_manifest.go` diff is a `finalText` signature change).

## 8. Fix options (none implemented)

1. **Conditional append, then re-plan (recommended).**
   - *Change:* add a no-write refusal to `ledgerstore`, `Submit` only if `Durable()` equals the caller's expected tail. `commitLoop`, `submitPaidLocked` (and the review producer) pass `s.p.through`. On refusal they refresh and redo their guards from the top: paid resamples the clock, the loop re-predicts its effect sequence. Retries are bounded, then `BusyError`, so the loop parks as waiting_resource.
   - *Risk:* no F3-13/F3-15 encoding, reducer rule or golden changes. The internal store API gains one method, and it must keep "a refusal writes nothing and uses no sequence" (`ledgerstore/commands.go:152-154`). A retry happens before any send, because the intent is not yet committed, so it cannot re-dispatch. AdmitPaid's input object is content-addressed and harmless to republish. Retry bounds must be tested.
   - *Proof:* promote `zz_t15_diag_interleave_test.go` (rows `loop.bind`, `tool.begin`, `tool.result`, `loop.end`, `paid.admit`, `paid.dispatch`, with the real workspace producer through `deps.beforeSubmit`). It is red on 3a66a3c (det1) and must go green: not poisoned, fresh `Open` accepts, turn finished. Add one row where the tail moves on every attempt: bounded retries, busy, nothing committed. Then rerun the criterion-8 matrix.
2. **Exclusive store turn from refresh through Submit.**
   - *Change:* `ledgerstore` exposes a writer-turn reservation. Agents producers that predict a position or sample the floor refresh, sample, plan and submit while holding it, and workspace appends wait.
   - *Risk:* frozen contracts are untouched. Lock order is agents `mu` → store turn, while workspace takes its own `mu` → store turn. No code may call into the workspace or reopen while holding the turn, so the loop, Close and Recover need an audit. Workspace commits wait out agents planning, which currently includes full scans (§6). That worsens latency until those are fixed.
   - *Proof:* the same regression rows, with the barrier launching the workspace commit asynchronously. Assert that it lands after the agents group, that nothing is poisoned and that `Open` accepts.
3. **Stopgap: serialize only the loop's own workspace writes with agents commits.**
   - *Change:* take `Service.mu` around `CommitObserved`/`MergeBack` (`loop_manifest.go:272,278`) and the file-tool writer commits.
   - *Risk:* it covers only the measured interleaver. Host-side workspace commits (`Register`, `Scratch`, `promotion.request` at `loop_session.go:132`, the terminal) can still interleave, so the defect remains. It holds `Service.mu` across Git work (hundreds of ms).
   - *Proof:* the regression rows still fail when the foreign commit comes from the host. Use it only to unblock a measurement.

For §7 (separate slice): treat a workspace `BusyError` at `finish` as waiting_resource and retry the finish on a workspace release (today nothing wakes the loop for workspace releases), instead of `recovery_pending`. Proof: two writers finishing together under `BytesInFlight == MaxBytes`. On 3a66a3c one turn is stranded without `loop.end`; after the fix both finish. The driver should also treat a `recovery_pending` status as an ending.

## 9. Was S4 involved?

No. S4's product changes are read-only paths: `FinalText`, `CredentialScopeStatus`, and the `readPaid`/`finalText` origin and ctx plumbing (`git diff 3c10c90 3a66a3c` on `loop_continuation.go` and `loop_manifest.go`). The deterministic reproduction fails identically on S3's tree (3c10c90). The predicted loop `EffectSequence` and the concurrent turn-end workspace commits are S3 (8c2a065). The paid floor check and the preflight-then-Submit pattern date from tickets 13/14. S3's loop made workspace commits routine beside them.

## 10. Experiments and hashes

- **X1** (`paid_attempt.go`): SHA-256 before 7aea51e7…51edce (git blob 70d088fc… = 3a66a3c). The edit added `fmt.Fprintf(os.Stderr, "T15DIAG …")` at each `ErrDenied` site, labelled with 3a66a3c line numbers (`<ev>\X1-instrumentation.diff`), instrumented hash 293c9357…40af54e. Runs: X1-det, X1-det2, X1-det3, r2-r14. Restored from `<ev>\X1-original-paid_attempt.go.txt`; after: 7aea51e7…51edce.
- **X2** (`loop_runtime.go`): before 6a72ac2e…1d1484 (blob c283c19a… = 3a66a3c). The edit printed the completion error on a terminal state (`<ev>\X2-instrumentation.diff`), hash efc5966a…a5e50f0. Runs: r15, r16. Restored from `<ev>\X2-original-loop_runtime.go.txt`; after: 6a72ac2e…1d1484.
- After everything: `git status --porcelain` is empty, `git diff --quiet 3a66a3c` passes, and HEAD is 3a66a3c.
- `<ev>\hashes.txt` records 61 evidence hashes. `<ev>\commands.jsonl` holds every Go command with exit and log. The throwaway scripts were `run.sh` (f5b3b75b…, the Go-command wrapper), `decode.py` (1428cfa9…, commit printer) and `scan_violations.py` (ea63c114…, which rechecks predicted loop effect sequences and paid samples against the replay floor per commit). Their output is in `<ev>\scan-violations.log`, and the scripts were deleted afterwards.
- Leftover temp colonies from my killed runs were copied as `r10/r14/r16-colony` and then removed. `%TEMP%\TestTicket15Measure1189236660` (01:42, before this session) is not mine and was left.
