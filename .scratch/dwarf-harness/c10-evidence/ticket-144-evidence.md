# Ticket 144 evidence

The [design brief](ticket-144-design-brief.md), the [ruling](ticket-144-design-ruling.md) and its [clarification 1](ticket-144-clarification-1.md) govern the ticket. The [D0 record](ticket-144-d0-record.md) is the project manager's cause table and both full-load replicas, and the [series rows](ticket-144-series.jsonl) are criterion 5's raw rows. Ticket 144's Answer says what was built. No decision entry, `CURRENT-RULES.md` line or contract-register change is added (D161): the ruling's compatibility rows are test-only or unchanged, and its amendment 3, which supersedes ticket 45's ruling §8.1 (note 26) for the one companion fixture, changes no standing rule; it is recorded in the ruling, the Answer and here. Paths that begin `local://` name the build session's own files, which stay outside both repositories. Sources: `local://t144-ruling.md:41-48,52`; `local://t144-clarification-1.md:12`; `docs/CURRENT-RULES.md:26-29`.

## Method and provenance

Claim date: 2026-11-07. Close date: 2026-11-08. The chronology is from `local://t144-docs-notes.md` and `local://ci-docs-notes.md`, the coder reports and the fresh reviews named below; this record makes no per-slice pace analysis (D162). The [inventory](ticket-144-evidence-inventory.json) (SHA-256 501f515925d293cb78562dc0f9aa323a16f8032f41d358ecac6bde8d24996f7a) identifies raw logs, receipts, records and probe output by path and SHA-256; none is copied here (D160). Under the owner's workflow test the PM also wrote a blind ruling on the brief for comparison, kept outside both repositories; RulingT144's ruling was the one in force. Sources: `local://t144-docs-notes.md:3,9,19`.

Owner inputs, none quoted: the three failing jobs' logs, downloaded on 2026-11-07, which satisfied the brief's only owner question (OG-LOG); the approval to publish the ticket and to make ticket 46 wait for it (D167); and his standing instruction of 2026-11-07 that Codex roles continue until that budget is used up, under which the coders kept handoff notes. No owner gate was reached. Sources: `local://ci-docs-notes.md:1566-1568,1576`; `local://t144-docs-notes.md:3`; `local://t144-brief.md:204-206`.

## Design, ruling and clarification

DesignT144 (GPT-6.1 Sol) wrote the brief (SHA-256 `6e5153d890e1bfe436eb07a73c37b482b3729f2fd9ee2b70a44efea21bd556f6`): P1 a labelled diagnostic stage D0; P2 exact race-step replicas, at most three; P3 a plain companion payload while the executor and supervisors stay race-built; P4 both peer payloads alive until both have probed; P5 phase-specific native proof; P6 three slices; P7 twenty serial fresh-ref runs before landing, holding `main`; no owner gate. RulingT144 (fresh Fable) approved with seven amendments and no owner gate (SHA-256 `febf331221d63b572b19bcbf6c6794bebf9f56f44d2e48d823d049683e5cad0a`): P2, P4, P6 and P7 approved; P1, P3 and P5 amended. Amendment 1 bounds D0 to the cause table, ticket 45's limit-contrast outcome and one base replica, with one contrast only on a reproduced exit 66, and gates no coding; 2 fixes the companion's `go` discovery and version check; 3 is the supersession above; 4 extends P5 to `liveHeldDescendant` and `testOuterJob`'s cleanup, the reader audit and the crash matrix's zero-active branch; 5 adds RB5; 6 fixes the series rules (F's declaration and the `main` hold, counted rows, no rerun, a new F and a new series after any code change); 7 lets S1 and S2 run at once and stops any slice at the §3.2 checkpoint on a suspected product defect. Sources: `local://t144-docs-notes.md:8,10-18`; `local://t144-ruling.md:3-56,106`.

Compatibility, as ruled: the plain companion payload in race-built top-level processes (test fixture; supersedes ticket 45's §8.1 for this fixture only); `TestWinexecSupervisor`'s fourth argument (a test-internal protocol, both ends in S1); `work/peer-probed` and `work/peer-release` (private run-local test control files, not a product protocol); `ObservedPhase` and `PIDListKnown` in the supervisor frame (test-internal JSON, additive); `liveHeldDescendant` and `testOuterJob`'s teardown no longer asserting the exited root's rundown state (test-only, proofs preserved); production files, frozen contracts, `go.mod`/`go.sum`, `tools/check` and `.github` unchanged. Source: `local://t144-ruling.md:41-48`.

Clarification 1 (ClarifyT144a, fresh Fable; SHA-256 `cd194afa3f38dc7c28bc196c692e0cdce771ba041fb1cace65d0dac191ee4804`): proceed on F unchanged. Diagnosis after a failed F replica has three exits: a product defect goes to the §3.2 checkpoint; a mechanism caused or exposed by S1–S3, or one a hosted run has shown, goes to a fix slice and a new F; a pre-existing timing loss seen only under local full load, with clean hosted history and correct product closure, goes forward unchanged. The F replica took the third. A hosted `TestNativeUserCPULimit` failure of any signature would end the series and return as a short test-only ruling request, the payload's `cpu` mode being the one lever. It set the Answer's product reading, deferred the Go comment, kept the third replica unspent and directed the D0 record's F-section amendments. Sources: `local://t144-clarification-1.md:12,23-30`; `local://t144-docs-notes.md:89-95`.

## D0: the cause table and both replicas

The D0 record was written at 15:02 EST, filled with the base replica (SHA-256 `581545ebb90f680d47cd2f8d6cbd180bbd090b58e90d7a4bd00baaa62d23fa68`, the version S1's review read), given its F section (`57a16c2a2ed4589344d6656e36c0bb926eaa3a9459d5ca5fcab964c552a1cf12`) and amended per clarification 1 (`38cfae7017da0d0ce310e97b66fe1b43310f7a31af1242eef782c9cfd2129d58`). The retained copy is the final file. The hosted logs are the owner's download, kept privately at the path the record names. Sources: `local://t144-docs-notes.md:30-35,55,87,95`.

| Row | Run / job / commit | Test | Log (SHA-256), lines | Receipt | Verdict |
|---|---|---|---|---|---|
| 0.1 | 40773519796 attempt 1 / 123116768186 / da18709 | `TestNativeUserCPULimit`, `executor_windows_test.go:152` | `2_Check _ windows-amd64.txt` (`65508ecd0ef0dfa32d5efdbdf01c455010444e8282b2db3abc2199ab28e76082`), 514–515 | exit 66, empty stdout, `ThreadSanitizer failed to allocate 0x000000800000 (8388608) bytes at 0x028000000000 (error code: 487)`, user CPU 0, peak 152,027,136 B, one process; RootExited, TreeExited, ResourcesReusable true | race runtime startup failure in the sandboxed race-built payload, toolchain class, outside the product; finer trigger not established |
| 0.2 | 41133154184 / 124329032725 / c2d42e4 | `TestSeparateRunsCannotReadPeerInput`, `matrix_security_windows_test.go:98` | `1_Check _ windows-amd64.txt` (`6f07aa9981d4891872759f9f56f1c0674c458bbad5776f64fca57ca2ee2fb9ce`), 514–515 | the same error, exit 66, user CPU 0, peak 152,027,136 B, one process; no peer probe ran | as 0.1; the test's separate ordering defect (error 3) is real but not this failure, and S2 fixes it |
| 0.3 | 42338417245 / 128300501016 / a38ecb7 | `TestNativeProcessLimitAndHostJobNesting`, `matrix_supervisor_windows_test.go:517` | `3_Check _ windows-amd64.txt` (`9574f00995f2531ac50ed0bf2f42135c10637d2fb4fd19f830ad1a84659c69df`), 520–521 | final frame `Phase:done`, exit 0, RootExited, TreeExited, ResourcesReusable true, two processes, the intended quota denial; `incomplete native Job PID list: {Assigned:1 Count:0 …}` beside a stale `Active:1` and an unconfirmed fence | no product defect: the test observer treated a PID census during Job rundown as authoritative |

Limit contrast: no new run. Ticket 45's ruling §8.2 probes of 2026-10-17 already found no ThreadSanitizer error without the Job memory limit (peak 234.7 MB) and a pass with the grandchild as a direct child under the 2 GiB limit (peak 177 MB), and 487 is an address error, not a commit refusal (1455 or 8). One sample of each; passes alone cannot rule out a rare failure. Job probe (PM, 40 trials, `cmd.exe /c exit 0` in a fresh Job, raw `job-probe.jsonl`): in one trial the Job read Active 1 with Assigned 0, Count 0 and an empty list 2.74 ms after the wait returned; in 39 the first read listed another process of the Job; every trial read 0/0/0 within about 25–30 ms with the exited handle still open. It did not reproduce the hosted `Assigned:1 Count:0` pair and used no AppContainer and no race build. Sources: D0 record "Limit contrast" and "The rundown window"; `local://t144-docs-notes.md:6-7,32`.

Base replica, on c89447f with the machine held, the check's race step with `-v` (2026-11-07 15:25:35–15:51:45 EST, 1,570.1 s, exit 1; `replica-base/race.log`, `replica-base/record.json`): no exit 66 and no ThreadSanitizer line, so no contrast ran (amendment 1). winexec failed in 135.5 s: `TestNativeUserCPULimit` timed out when setup 13.1 s and execution 6.9 s reached the 20 s `Wall`, with user CPU 2.09 s and `cpu-ready` printed; `TestRequiredEnforcementUnavailable` failed when the supervisor's 15 s handshake guard expired after 17.4 s. Both are fixture budgets under a load heavier than the hosted step's, so the §3.2 checkpoint was not reached. `internal/core/providers` failed `TestPaidHTTP1OneShot/anthropic/partial_header` (`transport_test.go:192`); every other package passed. Sources: D0 record "Base full-load replica"; `local://t144-docs-notes.md:52,55-59`.

F replica, on b9efa89 with the machine held (17:18:22–17:46:42 EST, 1,700.3 s, exit 1; `replica-F/race.log`, `replica-F/record.json`): no exit 66, no ThreadSanitizer line, one companion build. winexec failed in 177.1 s on `TestNativeUserCPULimit` alone: `TimedOut`, exit 1, setup 8.8 s and execution 11.2 s reaching the 20 s `Wall`, Job user 4.48 s against 2 s, `cpu-ready` printed, TreeExited and ResourcesReusable true. The handshake failure did not recur, and `providers` passed (39.7 s). In the 30 local passing runs on record the per-Job quota killed the payload only at 2.09–6.69 s of user time; Microsoft documents the limit as a periodic check whose interval is not stated; the replica accrued about 0.40 CPU-s per wall-second (base 0.30). Not established: whether the kill's latency is bounded in CPU time or in wall time. Hosted overshoot: unmeasured, since the race step runs without `-v`. Nit, no action in 144: F's receipt shows `ResumedUTC` 1.2 ms before `CreatedUTC` (base: 29 ms after), two clock sources, carried to the next winexec ticket's notes. F was not declared until clarification 1. Sources: D0 record "F full-load replica"; `local://t144-docs-notes.md:85,87`; `local://t144-clarification-1.md:12,26`.

## Slices, commits and people

| Slice | As built | As landed | Coder | Review |
|---|---|---|---|---|
| S1 — plain companion payload under the race detector (P3, amendments 2 and 3) | c23eb8f924a21cc4f1874a66cf82e89e034b0af5 on `build/144-winexec-race`, diff from `main` c89447f: 6 test files, 3 of them new, +145/−15 | cherry-picked onto cc63d0b as bd51edaa7a7e4c0ed2204a45471a4531716ba89f (byte-identical patch), then rebased as 3826a0e3f441d56efc6dbaac2659242383268862 on 3c893da (identical patch) | CoderT144S1, GPT-6 Astra | ReviewT144S1, fresh Fable: approve, no blocking; two minors, three nits |
| S2 — peer rendezvous (P4) | cc63d0b4aac8ae2b2418c9357603a6c78fcd5c14 on `build/144-s2` at c89447f: 2 test files, +127/−21 | rebased as 3c893da79f8205d9e7c2948ec8896b673026df5f on 0e58a9b (identical patch) | CoderT144S2, GPT-6 Astra | ReviewT144S2, fresh Fable: approve, no blocking; two minors, one nit |
| S3 — native proof only at stable phases (P5, amendments 4 and 5) | 396e1b347a1dd9359b4cb0a50438882780ff3d53 on `build/144-s3` at 3826a0e: 3 test files, +141/−25; never pushed | rebased onto `main` 8d42db1 as F, b9efa894f0a7b3040d7a0363dfa29f21533331dc (identical patch, no winexec blob change, so the review carries to it) | CoderT144S3, GPT-6 Astra | ReviewT144S3, fresh Fable: approve, no blocking; two minors, two nits |

`build/144-land` (0e58a9b + 3c893da + 3826a0e, 8 files, +272/−36) carried S1 and S2 to `main`. The PM checked S1's commit against its coder's final hashes (6 files) and S3's with `verify_hashes` (3 matched); S2's final hashes matched its worktree at delivery (2 files). Reviewed diffs: S1 `850a6bc64202589517128afa519c3b713464321517449762a80fce955c7b7dad`, S2 `cf1f0623dc02c70d19ecb6030f1f75887011e00e02f671ba23302d3cdf9e091e`, S3 `681e47c96a18b97c2c9b31d5df34a487249096aa405966cdd23f15458d07838b`. Reports (the coders' `yield.json`, verbatim): S1 `31cc00aee8c02260d96c31c7d906d42293ec1747e8603ad07b742d2854c40630`, S2 `454c28f9e3ae3e2809c6a95752a72008e061a6c3a5947a5d0260272b606e3d6b`, S3 `585f84c223da639bda2a82adfbad3048c346b81127064de1e76552260f266e5e`. Reviews: S1 `5e68bca43a37fd36fd59f533df21fb50fa6f5750622124b5b28afbf0ebab0301`, S2 `fe778d6641f3cf44045b74ef3d97a1324a81e835e86115a9152159fa41ac80b5`, S3 `f4711d9eac5e09d4fb0ac960950c9cf68ab8b8d9c8d544445f863e58b9ab49a9`. Final close review: approved by a fresh Fable advisor with no blocking findings: every commit, run, hash, test name, rule break, criterion mapping and figure matched the notes, D0 record, ruling, clarification, reports and reviews, and the Answer's code claims matched F's tree in the 144-s3 worktree. Sources: `local://t144-docs-notes.md:38-39,43,45,47,54,61,63,65-75,83`; `local://t144-s3-review-request.md:3,19`.

## Runs and rule breaks

All final runs exited 0; every listed constant is unchanged, no test was deleted or renamed, and gofmt, five-target vet and staticcheck, `go mod tidy -diff` and the import audits were clean for each slice. These are run durations, not measurements.

S1: focused 48.0 s, plain package 62.8 s, race 80.3 s with one companion build (8.47 s, under the first requester `TestPermittedInputAndBoundedOutput`, `09-race.log:117`), race ×20 476.5 s with one build (5.53 s). The smoke showed a race-built top-level process (one build, owned directory removed) and supervisor (no build, borrowed image present at exit), and a staged plain `CGO_ENABLED=0` payload equal to the selected image (`11-smoke-result.json`). The smoke's first analysis script failed on omitted `BuildSetting` values, a script bug; it was fixed and re-ran on the retained output without a native rerun (recorded under the report's `deviations`); the throwaway scripts were removed with their hashes kept. RB1, the race-built self image as payload in a disposable copy: no ThreadSanitizer recurrence, the CPU and nesting rows passed, recorded as non-recurrence (`12-rb1.log`, `rb1-record.json`); `TestSeparateRunsCannotReadPeerInput` failed in that run with ReadCodes [2 5] (`12-rb1.log:16`), S2's ordering defect, absent from S1's worktree; restored green (`13-rb1-restored.log`). The disposable fixture carried an atomic build counter, so its original and restored SHA-256 `79ff6bbe70676bfc4299c21ccdd3f73680625fde297b87ac5209746c5a9966e5` (mutant `b10786beea6dc3734cf4474d683d40733d264e992f9cf09fe409ad5f58f932c1`) differ from the shipped `payload_fixture_windows_test.go` (`f27cb78d1094b6d6a81f3ac69f1cc035d67564750e4cf109ca233c7fc1e64d20`), whose hashes the smoke verified separately (ReviewT144S1, nit). Sources: `local://t144-s1-report.json:419-462,603-626`; `local://t144-s1-review.md:12,18`; `local://t144-docs-notes.md:44,46-50`.

S2: plain 82.2 s, race 96.1 s, race ×20 173.5 s (the coder's command durations; `go test` reported 72 s, 69 s and 146 s), focused pass 4.75 s with the release and marker order logged. RB2, the old `payloadPeer` alone: red, exit 1, at `matrix_security_windows_test.go:173`, "peer A completed before peer 0 probe marker" (`rb2-red.log`); green after restoration (`rb2-green.log`); `matrix_payload_windows_test.go` `b937a343adc8cb89f4bae1161032e57c8ce1c396f7e799bfb582ba095b06d2b0` before and after (`rb2-restoration.json`). Old-code skew demonstration, through `-overlay` with the worktree unchanged: A released, joined and its targets confirmed absent, then B released; A's four probes returned 5, 5, 5, 5 and B's 3, 3, 3, 3 (`old-code-skew.log`, `skew-result.json`); its four throwaway sources were deleted, their SHA-256s kept in the coder's report. Sources: `local://t144-s2-report.json:372-470`; `local://t144-s2-review.md:11,24-26`.

S3: focused 24.8 s, plain 70.3 s, race 85.2 s with one companion build (6.9 s), race ×20 of the eight-test pattern including `TestWallDeadlineStopsWholeTree` 440.9 s with one build (5.9 s), 20 of 20 each, no race test above 60 s. RB3, unconditional frame queries: red, `TestSupervisorObservationProofBoundaries/root_exited` at `matrix_supervisor_windows_test.go:223` (`QueryInformationJobObject` code 0x6, invalid handle). RB4, the mandatory `suspended_created` query suppressed: red at `:247` (`<nil>`). Both green after restoration; `matrix_supervisor_windows_test.go` `68304d1317db0384db1057df1d0bc1eea7b36e36dae9da4d5704558f6353b6b4` original and restored, mutants `87db8ca6c8790f12f161a9a6434ad0aec3cc4f30c4bd39b46124fac3e442da90` (RB3) and `360c608dd8809ecc39e29bf1d20d6cbbbc9b364d5fe29ce481e91e1e237a8eba` (RB4). RB5, a product mutant terminating the Job before `observe("root_exited")`: red, `TestWallDeadlineStopsWholeTree` at `limits_windows_test.go:101` ("held descendant missing from Job PID list: {Assigned:0 Count:0 …}") and `TestCancelWaitsForEveryDescendant` at `executor_windows_test.go:358`; green after restoration; `executor_windows.go` `90028d21f0dc06b648e329948416d2549f09eb2597d72d466b42277980d10576` original and restored, mutant `33efa69ba0bf399e38ee63497d359685847fb8e77ba98645b0cb7ff1252bdbea`; the commit touches no production file. The reader audit (`pid-readers.md`, amendment 4(c)) lists all seven `testJobPIDs` references, `testRunDescendants`' stable `root_exited` census and `liveHeldDescendant`; all three direct PID-list queries are in test files, and `testJobPIDs` is byte-identical. Sources: `local://t144-s3-report.json:151-232`; `local://t144-s3-review.md:9-15,30`.

## Hosted runs

No hosted run was rerun (D153): a red or superseded run was followed by a fresh run on a new SHA.

| Run | Commit (ref) | Result | Disposition |
|---|---|---|---|
| 42409795650 | cc63d0b, S2 (`build/144-s2`) | Windows (20:11:04–20:46:10 UTC) and Linux succeeded, so the winexec race step passed with S2; macOS job 128515276984 failed its tests step in `internal/core/providers` `TestPaidHTTP1OneShot/anthropic/partial_header`; `Check result` failure | another package: not rerun; cc63d0b did not land, and S2 landed inside a later fresh run |
| 42410591342 | c23eb8f, S1 alone (`build/144-winexec-race`) | success on all three (Windows 20:20:45–20:58:35 UTC; `Check result` 20:58:41) | not a landing SHA; the first hosted race step with the companion, so the runner's `go` matched `runtime.Version()` |
| 42412922895 | bd51eda, S1 on S2 (`build/144-s1s2`) | success on all three (20:49:52–21:25:42 UTC), `Check result` success | superseded when ticket 143's S1 moved `main`; evidence only, its watcher stopped |
| 42414491760 (check 51) | 3826a0e (`build/144-land`) | success on all three (Linux 21:09:35–21:20:27, macOS to 21:29:47, Windows to 21:46:24 UTC; `Check result` 21:46:29 UTC) | landing run: `main` 0e58a9b → 3826a0e, reflog 2026-11-07 16:49:02 −0500 |
| 42419899796 (run #54) | F b9efa89 (`build/144-s3`), pushed 22:17:05Z | success on all three (Linux 22:17:33–22:27:55, macOS to 22:43:25, Windows to 22:54:50 UTC; `Check result` 22:54:57 UTC) | series row 1 once F was declared |

Sources: `local://t144-docs-notes.md:53-54,60,63,73,83,88`; `local://ci-docs-notes.md:1577-1581`.

The providers failure, outside ticket 144: `TestPaidHTTP1OneShot/anthropic/partial_header` failed on hosted macOS in run 42409795650 (no message in the annotations; the job log needs a sign-in) and in the base replica at `transport_test.go:192`, "faulted attempt unexpectedly succeeded (possible replay)", after the fault hit the reused warm connection; it passed in the F replica. The transport sends one POST with a non-rewindable body and no idempotency header, so it should never be retried [INFERENCE from net/http's rules, not verified on go1.27.3]; the PM classed it money-relevant until explained and offered the owner a separate C3 ticket. Sources: `local://ci-docs-notes.md:1580-1584`; D0 record "Base full-load replica".

## The series

F was declared at 2026-11-07T22:59:33Z, after ReviewT144S3's approval, the failed F replica and clarification 1, with `origin/main` at 8d42db1, F's parent; the hold on `main` started then. Row 1 is the S3 branch's own push (run 42419899796); row NN ≥ 2 is a push of F to `build/144-race-proof-NN`. The PM's series runner, outside both repositories, pushed each ref only after the previous run's conclusion was recorded, polled the public jobs API every 180 s, stopped on a winexec failure or a `main` movement, and wrote one row per started run (ref, run, attempt, head and `main` SHAs, each job's conclusion, counted or not with the reason); its classifier was tried first on the completed run 42414491760 in a throwaway folder. A counted row needs a push event, head SHA F, attempt 1, the classifier's `code=true`, and all three matrix jobs and `Check result` successful (amendment 6(ii)). Passing runs print no `t.Logf` line, since the race step runs without `-v`, so neither the CPU row's hosted overshoot nor the `outer Job rundown handle snapshot` line ReviewT144S3 asked to harvest is visible in them. Hold end: `main` 8d42db1 → b9efa89 at 2026-11-08 10:19:58 EST (reflog). Sources: `local://t144-docs-notes.md:86,96-98`; `local://t144-ruling.md:55`; `local://t144-clarification-1.md:17`; `local://t144-s3-review.md:20-26`.

| Row | Ref | Run | Conclusion | Counted |
|---|---|---|---|---|
| 1 | `build/144-s3` | 42419899796 | success | yes |
| 2 | `build/144-race-proof-02` | 42423183952 | success | yes |
| 3 | `build/144-race-proof-03` | 42426302187 | success | yes |
| 4 | `build/144-race-proof-04` | 42429241258 | success | yes |
| 5 | `build/144-race-proof-05` | 42431813533 | success | yes |
| 6 | `build/144-race-proof-06` | 42434736268 | success | yes |
| 7 | `build/144-race-proof-07` | 42437562308 | success | yes |
| 8 | `build/144-race-proof-08` | 42440401209 | success | yes |
| 9 | `build/144-race-proof-09` | 42443401515 | success | yes |
| 10 | `build/144-race-proof-10` | 42446290175 | success | yes |
| 11 | `build/144-race-proof-11` | 42448717271 | success | yes |
| 12 | `build/144-race-proof-12` | 42451341097 | success | yes |
| 13 | `build/144-race-proof-13` | 42454142166 | success | yes |
| 14 | `build/144-race-proof-14` | 42456982977 | success | yes |
| 15 | `build/144-race-proof-15` | 42459751751 | success | yes |
| 16 | `build/144-race-proof-16` | 42462309289 | failure | no: a Linux race-step failure in another package, `internal/core/providers` `TestPaidHTTP1OneShot/openai/partial_header` |
| 17 | `build/144-race-proof-17` | 42464470666 | failure | no: Windows setup failed at step 7, the race-compiler download, and a Linux package reached the 30-minute limit in the tests step |
| 18 | `build/144-race-proof-18` | 42467323507 | failure | no: Windows setup failed at step 7, the race-compiler download |
| 19 | `build/144-race-proof-19` | 42468842405 | failure | no: Windows setup failed at step 7, the race-compiler download |
| 20 | `build/144-race-proof-20` | 42470416723 | failure | no: Windows setup failed at step 7, the race-compiler download |
| 21 | `build/144-race-proof-21` | 42472663606 | failure | no: Windows setup failed at step 7, the race-compiler download |
| 22 | `build/144-race-proof-22` | 42474254307 | failure | no: Windows setup failed at step 7, the race-compiler download |
| 23 | `build/144-race-proof-23` | 42475907225 | success | yes |
| 24 | `build/144-race-proof-24` | 42478930439 | failure | no: a Linux tests-step failure in another package, `internal/core/providers` `TestPaidHTTP1OneShot/openai/partial_header` |
| 25 | `build/144-race-proof-25` | 42481778344 | success | yes |
| 26 | `build/144-race-proof-26` | 42484956002 | success | yes |
| 27 | `build/144-race-proof-27` | 42487893598 | success | yes |
| 28 | `build/144-race-proof-28` | 42490965545 | success | yes |

## PM decisions

1. S1's question 1: the D0 record's path with the base replica pending; the coder reported its own durations and did not wait, and the PM added the replica before S1's review (amendment 1). Source: `local://t144-docs-notes.md:36`.
2. RB1's peer failure: RB1 recorded as non-recurrence and the peer failure as a separate observation of S2's defect, with no S2 edit in S1's worktree; the ordering window opened under the heavier race-built payload. Source: `:44`.
3. Both replicas ran with the machine held, the other coders' test runs paused. Sources: `:52,85`.
4. S2's red run: cc63d0b did not land; S1 was cherry-picked onto S2 as bd51eda and pushed for a fresh run, not a rerun. Sources: `:53-54`.
5. Landing order: ticket 143 landed first; S1 and S2 were then rebased and landed in one step, and S3 was built on the rebased tip, because every `main` movement costs one more hosted run. Sources: `:62-63`.
6. Ticket 16's S3 lands after the series, since holding the series for it would only delay the series' end. Source: `:84`.
7. After the failed F replica: F was not declared and the series not started; a fresh Fable clarification was requested, and `main` was not held meanwhile. Source: `:87`.
8. After clarification 1: F declared and `main` held; ticket 16's S3 candidate 9ecac86 waits for the series; the ref-to-row mapping above; a watcher stopped to keep the unauthenticated API within 60 requests an hour. Sources: `:96-97`.

## Carried review notes

None was folded: the close changes no Go file, and any Go edit would have made a new F and a new series (clarification 1, item 5). S1: a vestigial `output=""` in the lookup errors; a context created twice; the version check compares the whole `CombinedOutput`; RB1's disposable hashes (above); a slow focused `TestDescendantsCannotBreakAway` under shared load, sizing no guard. S2: `os.IsNotExist` beside `errors.Is`; a timer allocated per admission iteration; A's unchanged 10 s release guard now spans B's resume, probe and marker, so if it ever fires on a hosted run it is reported with timing, never lengthened. S3: the ID-list struct is redeclared beside `testJobPIDs`'s; a third Job member now surfaces as `ERROR_MORE_DATA`; `ObservedPhase` has no asserting consumer yet. Deferred Go comment for the next ticket that edits a winexec production file (clarification 1): "UserCPU is enforced by Windows' periodic per-Job user-time check, so termination follows the limit by up to one check interval of accrual; Wall is the hard bound." Sources: `local://t144-s1-review.md:15-19`; `local://t144-s2-review.md:12-14`; `local://t144-s3-review.md:16-18`; `local://t144-clarification-1.md:23`.

## Raw evidence references

The [inventory](ticket-144-evidence-inventory.json) is the path and SHA-256 authority for every raw file. Roots, under `C:/Users/darius.jones/worktrees/dwarf-harness/`: `t144-design-evidence` (the Job probe), `t144-d0-evidence` (the D0 record and both replicas' `race.log` and `record.json`), `t144-s1-evidence`, `t144-s2-evidence`, `t144-s3-evidence` (logs, rule-break records, audits and each coder's `yield.json`) and `t144-series` (`series.jsonl`). The three hosted job logs are named with their hashes in the D0 record. Files cited above:

| Path | SHA-256 |
|---|---|
| t144-design-evidence/job-probe.jsonl | dfebf5e3e9f164caef2cefb510595dc190d7bf3d52edd776ed9bdf09aaa8d97f |
| t144-d0-evidence/d0-cause-table.md | 38cfae7017da0d0ce310e97b66fe1b43310f7a31af1242eef782c9cfd2129d58 |
| t144-d0-evidence/replica-base/race.log | 985a210b190a2487c8b357eb41f4a8264b5eeea26ecdc3be7db2af745072a5bc |
| t144-d0-evidence/replica-base/record.json | b4b43ba4f198872712c3913ef9dedcdb594e11541511496bbeae5cd6b4236c95 |
| t144-d0-evidence/replica-F/race.log | 1c52e129de5aaf06522f8e6165b290d8a95f69609009a156af346c123cef2562 |
| t144-d0-evidence/replica-F/record.json | 8ee4933f9057e8d883e1381b084319ee107bb8cb6de4b2e8556f6c473581966b |
| t144-s1-evidence/09-race.log | 9d3108f04dfd5c8d297b6c3fc9b9862f541764cc7e7a368981e590233421b293 |
| t144-s1-evidence/10-x20.log | 55358cfaddd5b9b7504965e6a38faf95e90ebfd2298c0e1f815b306a67872c21 |
| t144-s1-evidence/11-smoke-result.json | 97a0f69bd2d9a425836d169ab272a79cb8ad239bdac60ee881e91e22479e87dd |
| t144-s1-evidence/12-rb1.log | b756780e89986d0c54357d9fdc12c9a4fe0c852f03d737e96d7d4f9003e376af |
| t144-s1-evidence/rb1-record.json | eedb27fdeb1aa521d614454b2b5d48742932e2ae51b78eb5465d8bea2165ee15 |
| t144-s1-evidence/13-rb1-restored.log | bf0e2ab34528d5f21a9b2713c2f1480f1a626fa88fb7458bb80375287f1da7c4 |
| t144-s1-evidence/yield.json | 31cc00aee8c02260d96c31c7d906d42293ec1747e8603ad07b742d2854c40630 |
| t144-s2-evidence/rb2-red.log | c864d607ab025493e46a5c2879fccd6b9641ee1a2bf413a6502629eafce8d415 |
| t144-s2-evidence/rb2-green.log | 46262d0e32b8abd9888322125bb66337ec8961b8c384747dd7f79f2406c0d182 |
| t144-s2-evidence/rb2-restoration.json | 7bd2a031bf06b2de68a2d0b8c2b0fe1ce51ebc922f637e692d9965a88a7a42f8 |
| t144-s2-evidence/old-code-skew.log | 7cdc68e22f92c4c1f1129503f3eaa4f94648b6299ec4a6f374caada3d7ca1442 |
| t144-s2-evidence/skew-result.json | 8047785a8e10b294b1bcf52676bf59dc8addb598a788870661e0920def2f8e7a |
| t144-s2-evidence/yield.json | 454c28f9e3ae3e2809c6a95752a72008e061a6c3a5947a5d0260272b606e3d6b |
| t144-s3-evidence/RB3-red.log | 18b61618c4b5bfdfe55ca75972dda4e37c62353c1ff2906deb808244fbae76d2 |
| t144-s3-evidence/RB3-green.log | d6674c59894f9f2c08badc45ba5eb6814d66ce25c8f9e2d97c3a7714f3111f61 |
| t144-s3-evidence/RB4-red.log | e46151156f386724bec396556d558d131534efee5d0c0d16fba05009e502aba6 |
| t144-s3-evidence/RB4-green.log | c86611db5319d3c35d4fa84b448bae5dec383e8c087fe5964dc293c416947ff8 |
| t144-s3-evidence/RB5-red.log | cf63faa06736661c84ff1fbd5a4e6f7711f5155e8d2f34271d7654292f7f8171 |
| t144-s3-evidence/RB5-green.log | 17bbacfdeb5c4d4e26ae25a41f1046e10fb5cdbd2dfb9c8b14a281389168fe31 |
| t144-s3-evidence/pid-readers.md | 05712f7db4c98a45c4f1dcbec936a868a7c6b8a18bb12305387c382b58c5e984 |
| t144-s3-evidence/yield.json | 585f84c223da639bda2a82adfbad3048c346b81127064de1e76552260f266e5e |
| t144-series/series.jsonl | 5e2b7769cbd45bdc2edb6714e63c9d0a95e6aae6f843c9432af92f0e19b10498 |
