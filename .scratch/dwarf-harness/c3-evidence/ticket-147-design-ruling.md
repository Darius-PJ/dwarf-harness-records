```json
{
  "verdict": "ruled",
  "plan": [
    {
      "slice": "147-S1: held exchanges and the serial phase (test files only)",
      "options": ["T5", "T2"],
      "ownedPaths": [
        "internal/core/agents/loop_fixture_test.go (one new helper only)",
        "internal/core/agents/loop_concurrent_private_test.go",
        "internal/core/agents/loop_independent_test.go",
        "internal/core/agents/loop_integrated_merge_test.go (:34-35)",
        "internal/core/agents/loop_passive_test.go (:191-192)",
        "internal/core/agents/loop_resource_test.go (:16)",
        "internal/core/agents/loop_integrated_recovery_test.go (:123-124, :239-240)",
        "internal/core/agents/owner_recovery_test.go (:257-330)",
        "internal/core/agents/owner_recovery_races_test.go (the six subtests that call continuationKilled)",
        "internal/core/agents/owner_capture_recovery_test.go (:140-150)",
        "internal/core/agents/owner_local_recovery_test.go (:42-51)",
        "internal/core/agents/owner_stop_test.go (:15)",
        "internal/core/agents/owner_wait_test.go (:265)",
        "for a row the audit marks yes: one helper call in that row's test file, listed in the evidence"
      ],
      "change": "(1) T5. Add (*turnFixture).raiseDispatchBound in loop_fixture_test.go. Called before enable, under f.service.mu, it sets f.service.paid.limits.DispatchTimeout to 30 minutes and replaces f.service.paid.transport with one built by providers.NewTransportWithRoots from the same limits and the fixture's own deps.paidTestRoots and deps.paidWrapConn (as paid_live.go:66-69 builds it), closing the old transport's idle connections. Both bounds must rise: the exchange context (paid_dispatch.go:136) and the client timeout fixed when the transport is built (providers/transport.go:87). Passing the limits down the fixture chain instead is equally acceptable. Call it in testConcurrentMemoryCAS before loop_concurrent_private_test.go:211 and in testIndependentContinuations before its enable, and in those two rows set the three contexts' TimeoutMS (600000 at loop_fixture_test.go:94) to the same 30 minutes. Script, holds, release order and every assertion stay. Only the text at loop_concurrent_private_test.go:260 changes, to print the third turn's outcome and reason, the conflict count, the winner and both POST counts. (2) Audit the 19 handler sites on main that park on a test channel (`case <-r.Context().Done():` at eligibility_terminal_test.go:42; loop_concurrent_private_test.go:139,159; loop_final_test.go:53,59; loop_independent_test.go:192; loop_integrated_merge_test.go:72; loop_integrated_terminal_test.go:40; loop_live_attach_test.go:43,51,57; loop_live_exclusion_test.go:55; loop_live_test.go:57,68; loop_merge_outcomes_test.go:174; loop_scheduler_test.go:119; paid_lifecycle_test.go:32; paid_mixed_test.go:158; paid_openai_test.go:429). A row whose release waits for another turn, command or reopen to finish gets the helper. paid_lifecycle_test.go keeps its own 10-second bound (:61). (3) T2. Make `t.Parallel()` the first statement of the seven sequential top-level tests: TestTurnLoopConcurrentPrivateRuntime (loop_concurrent_private_test.go:342), TestTurnLoopTemporaryMergeBack (loop_integrated_merge_test.go:34), TestTurnLoopPassiveResults (loop_passive_test.go:191), TestTurnLoopWaitingHolds (loop_resource_test.go:16), TestTurnLoopCrashRecovery (owner_recovery_test.go:257), TestTurnLoopCancelResultRace (owner_stop_test.go:15), TestTurnLoopPersistedWaits (owner_wait_test.go:265). Give `t.Parallel()` to every subtest that calls continuationKilled (owner_recovery_test.go:269; owner_recovery_races_test.go:23,56,86,119,151,208; owner_capture_recovery_test.go:150; owner_local_recovery_test.go:51) and to the two crash rows registered at loop_integrated_merge_test.go:35 and loop_passive_test.go:192 (bodies at loop_integrated_recovery_test.go:123 and :239). eligibility_restart_test.go:80-98 already runs its crash rows this way. Leave sequential: the process-state tests (paid_credentials_test.go:19, paid_openai_test.go:613, paid_native_windows_test.go:33, paths_test.go:82, the t.Setenv rows at paid_capture_test.go:37) and TestRegistrationInjectedCrashRecovery, whose comment states that its children run serially (registration_crash_test.go:35-38).",
      "expectedSaving": {
        "basis": "race-summary.json: the seven tests run one after another from 02:35:16 to 02:44:58, 582 s of the 1,557-s race run. TestTurnLoopCrashRecovery alone is 94.1 s of single-row time. The diagnosis counts about 2,100 idle slot-seconds there. On 4-slot runners (3 on macOS) the wide groups are already dense, so the hosted gain is mostly the crash rows [INFERENCE].",
        "local": "race 200-240 s, plain 55-70 s",
        "windowsPlain": "90-130 s",
        "windowsRace": "150-250 s",
        "macosRace": "80-130 s",
        "linuxRace": "50-80 s"
      },
      "guarantees": [
        "No product file changes. The 120-second default (paid_types.go:33) and the rows that prove the dispatch bound (paid_lifecycle_test.go:60-61) are untouched.",
        "Kill boundaries stay positive: the child announces its boundary and blocks, and the parent kills and waits before it opens any colony file (owner_recovery_test.go:43-45, :92-99).",
        "Each child's temporary directories stay inside its parent's container (owner_recovery_test.go:53, :88-91), and Open is still checked inert after the kill (:122-123).",
        "Each child's environment stays on its exec.Cmd. No t.Setenv, sleep, duration assertion, row cap or retry is added.",
        "No assertion, row, boundary or subtest is removed or reworded, except the diagnostic text at loop_concurrent_private_test.go:260."
      ],
      "acceptance": [
        "Cause shown: with the helper's bound set to 2 s in a throwaway overlay, both providers' CAS rows fail at loop_concurrent_private_test.go:259-260 and the new text names the third turn as not finished; with the slice as written they pass. The overlay's hash and both outputs go in the evidence.",
        "`-race -count=20` of both CAS rows, `-race -count=5` of both independent_continuations rows and `-race -count=20` of TestTurnLoopCrashRecovery, all green.",
        "The audit table: each of the 19 sites, yes or no, with the line that releases the hold.",
        "One plain verbose run and one race run of the whole package, green; gofmt, vet and staticcheck clean.",
        "Diff review: besides the helper and its calls, the diff adds `t.Parallel()` lines and changes one message; no other test text changes.",
        "Local before and after (see measurement) on 51b9d58 and on the slice SHA. TestTurnLoopCrashRecovery start to end at most 45 s under race.",
        "Hosted three-OS check green on the exact SHA (D153). If the Windows race step still passes 1,500 s, the PM names it in the evidence (D127); D176 already answers it."
      ],
      "breaks": [
        "Crash recovery (edited rows): every mutant that ticket 15's and ticket 16's evidence binds to a row calling continuationKilled, each run once red against the parallel rows and restored. At least: recovery that refunds or re-sends after `paid_sent` (owner_recovery_test.go:266, red at :312), and a reconciliation that repeats work on a same-ID retry (red at :316).",
        "CAS row (edited): the mutants ticket 16's evidence binds to it. At least: a private write that accepts a stale expected revision (red at loop_concurrent_private_test.go:249, :260 or :300), and a runtime that repairs a conflict with an undeclared POST (red at :196 or :260)."
      ],
      "fuzz": [],
      "commands": [
        "GOTOOLCHAIN=local CGO_ENABLED=0 go test -count=1 -v -timeout 30m ./internal/core/agents",
        "GOTOOLCHAIN=local CGO_ENABLED=1 CC=<pinned llvm-mingw clang> go test -race -count=1 -timeout 30m ./internal/core/agents",
        "GOTOOLCHAIN=local CGO_ENABLED=1 CC=<pinned clang> go test -race -count=20 -timeout 60m -run '^TestTurnLoopConcurrentPrivateRuntime$/^(anthropic|openai)$/^shared_memory_cas$' ./internal/core/agents",
        "GOTOOLCHAIN=local CGO_ENABLED=1 CC=<pinned clang> go test -race -count=5 -timeout 60m -run '^TestTurnLoopConcurrentPrivateRuntime$/^(anthropic|openai)$/^independent_continuations$' ./internal/core/agents",
        "GOTOOLCHAIN=local CGO_ENABLED=1 CC=<pinned clang> go test -race -count=20 -timeout 60m -run '^TestTurnLoopCrashRecovery$' ./internal/core/agents",
        "gofmt -l internal/core/agents; go vet ./internal/core/agents; staticcheck ./internal/core/agents"
      ]
    },
    {
      "slice": "147-S2: fixtures built once per process and copied (test files only)",
      "options": ["T1"],
      "ownedPaths": [
        "internal/core/agents/fixture_seed_test.go (new: seed root, lazy builders, copy helper)",
        "internal/core/agents/scoped_golden_test.go (scopedGoldenFixture, :23-197)",
        "internal/core/agents/paid_replay_test.go (openPaidFixture, :18-27)",
        "internal/core/agents/paid_fixture_test.go (newPaidFixture and newPaidFixturePeriod, :42-119)",
        "internal/core/agents/paid_live_test.go (TestMain :21-33; newLivePaidFixturePeriod :43-55)"
      ],
      "change": "(1) Seed root: created lazily (sync.Once) with os.MkdirTemp under os.TempDir(), prefix dwarf-agents-seeds-. TestMain (paid_live_test.go:21-33) removes it after m.Run. (2) Golden seed, one per chapter, built on first use by today's real sequence: the hand-made directories and colony.json, the real ledgerstore.Open (scoped_golden_test.go:80), the real PublishBody (:125) and the real publishObject (:177). Use one directoryDurability for the whole build in place of the fresh one per record (:165). Close the store. The seed holds no segment. scopedGoldenFixture then makes a private os.CopyFS copy into testRoot(t), cuts the log prefix from the frozen file exactly as :186-191 does, runs the real ledgerstore.Open (:192) and parses the commits from the frozen log as today. (3) Paid seed, one per period string (utc_day, utc_month, and lifetime once 91-S2 lands), built on first use by today's newPaidFixturePeriod body (paid_fixture_test.go:49-118) on a golden-13 copy. Close the Service and the store and set them nil, as loop_fuzz_test.go:44-53 does. Capture the fixture's values as encoded payloads and scalars, the way paid_crash_test.go:125 already does (origin, route, credential, template, grant, inspect, turn, next). newPaidFixturePeriod then makes a private copy, runs the real ledgerstore.Open and the real Open, and decodes the values afresh per fixture (as paid_crash_test.go:409-430 does). newLivePaidFixturePeriod copies the paid seed and calls openPaidService directly. It no longer opens and closes a plain Service first (paid_live_test.go:45-49); everything from :55 on is unchanged. (4) The seed builders take their destination directory. They use the first caller's t only to fail, never its TempDir or Cleanup for anything the seed keeps. A failed or abandoned build marks the seed failed, so every later user fails with the first cause. (5) Nothing that records a per-test value is seeded. The live and turn fixtures keep their real commands after the copy: the route profile carries the test server's authority (paid_live_test.go:77-94; loop_fixture_test.go:38-46), and a reopened Service holds no secret (paid_live_test.go:71-76; paid_dispatch.go:123-127).",
      "expectedSaving": {
        "basis": "pprof-top-cum.txt: newPaidFixturePeriod 292 s and scopedGoldenFixture 256 s (they overlap through openPaidFixture, 156 s) of 3,052 plain thread-seconds. race-pprof-top-cum.txt: 381 s and 343 s of 7,774. What stays per live or turn fixture is small today (newLivePaidFixturePeriod's own part 32 s, newTurnFixture's 24 s, plain). The fixture is the flush-densest code in the package: each golden revision object is published through a fresh directoryDurability (scoped_golden_test.go:165), so every publication flushes its whole directory chain (paths.go:137-158). Ticket 16 measured a durable write cycle at 29.6 ms on the hosted Windows temp volume against 3.2 ms locally, so I weight Windows well above the local share [INFERENCE; calibrated by owner gate 2's first logs].",
        "local": "plain 40-50 s, race 80-100 s",
        "windowsPlain": "250-400 s",
        "windowsRace": "280-450 s",
        "macosRace": "60-100 s",
        "linuxRace": "40-65 s"
      },
      "guarantees": [
        "Stores stay real: every seed is produced by the same real ledgerstore.Open, PublishBody, publishObject, Open and commands that build the fixture today. No mock, fake flush or snapshot of an open store.",
        "Frozen bytes: each fixture's log is still cut per call from contract/ledger/testdata/f3/<chapter>/log (scoped_golden_test.go:186-191). A seed never holds a segment, and nothing under contract/ledger/testdata changes.",
        "Every fixture is a private byte copy, as paid_crash_test.go:146 and loop_fuzz_test.go:55 already copy closed colonies. No hard link; no Service, store, transport or file shared between tests.",
        "Every fixture still passes a real ledgerstore.Open and a real Open or openPaidService replay of its own copy. Open stays inert (rows: paid_replay_test.go:29-46, `Open appended or rewrote the frozen ledger`; scoped_golden_test.go:213-231, `frozen Open`).",
        "A seed built by a crash child lives under the child's temporary directory, which its parent places inside its own container (owner_recovery_test.go:53; eligibility_restart_test.go:98, :325), so a killed child leaves nothing. Children that receive a prepared root (paid_crash_test.go:409-420) build none."
      ],
      "acceptance": [
        "Tree equivalence, once, as a throwaway comparison kept in the evidence: for every chapter in use on main (10, 11, 12, 13, 14, 15, 16, 90, 139) and prefixes 0, 2 and -1, the old builder's directory and the seeded builder's hold the same files with the same bytes (lock files and bodies/.tmp aside).",
        "Self-checks in the code: the Service that built the paid seed and a fresh Open of the closed seed have the same projection (sameProjectionState); TestMain re-hashes each built seed after m.Run and fails the run if a seed changed.",
        "No edit outside the owned paths and no assertion change anywhere. A test that fails is reported, not edited.",
        "After a full package run and after the fuzz runs, the temp directory holds no dwarf-agents-seeds-* directory. The evidence lists the eight Test*CrashChild entry points and where each one's seeds, if any, live.",
        "One plain verbose run and one race run of the whole package, green; gofmt, vet and staticcheck clean.",
        "Local before and after on the 147-S1 SHA and the slice SHA. In the plain profile, newPaidFixturePeriod's and scopedGoldenFixture's shares of total samples are at most half of their shares on the 147-S1 tree.",
        "Hosted three-OS check green on the exact SHA. The owner's logs of this run are requested (owner gate 2) to calibrate the hosted estimate."
      ],
      "breaks": [
        "Helper mutants, each once: the copy drops one object file (a frozen replay row reports an integrity issue, e.g. scoped_golden_test.go:231); the prefix is cut one commit short (rows that compare Durable or the segment bytes go red, e.g. paid_replay_test.go:45).",
        "Frozen families whose fixtures now come from seeds (F3-10/11, F3-12, F3-13/14, F3-15, F3-16, F3-90, F3-139): one decoder or replay-rule mutant each from the family's freeze evidence, its named golden or replay test red.",
        "Money (tickets 13 and 14): one wrong-charge, one wrong-hold and one settlement mutant from their evidence, red on rows built by newLivePaidFixture.",
        "Recovery: one mutant from the paid crash rows (paid_crash_test.go:110-148) and one from TestTurnLoopCrashRecovery.",
        "The PM takes the exact mutants and named tests from each family's evidence file; each is run once, shown red, restored byte-identical and shown green."
      ],
      "fuzz": [
        "FuzzPaidGroupReplay, FuzzLoopGroupReplay, FuzzEligibilityGroupReplay and FuzzLoopTranscript, 120 s each, one after another. Their setups now run through the seeds, including inside fuzz worker processes."
      ],
      "commands": [
        "GOTOOLCHAIN=local CGO_ENABLED=0 go test -count=1 -v -timeout 30m ./internal/core/agents",
        "GOTOOLCHAIN=local CGO_ENABLED=1 CC=<pinned clang> go test -race -count=1 -timeout 30m ./internal/core/agents",
        "GOTOOLCHAIN=local CGO_ENABLED=0 go test -run '^$' -fuzz '^FuzzPaidGroupReplay$' -fuzztime 120s ./internal/core/agents (and the same for the other three targets)",
        "gofmt -l internal/core/agents; go vet ./internal/core/agents; staticcheck ./internal/core/agents"
      ]
    },
    {
      "slice": "147-S3: a released work stays answerable without a cold read (product; replaces P1)",
      "options": ["P1 (narrowed)"],
      "ownedPaths": [
        "internal/core/agents/replay.go (the install closure of stageCommitLocked only, :650-720)",
        "internal/core/agents/doc.go (comments only: the history index's remaining cold paths)",
        "internal/core/agents/history_index_test.go (one new row beside testColdWorkHistory, :1864)"
      ],
      "change": "Entry check first, no new run: the PM runs `go tool pprof -peek` on the existing race-cpu.pprof for (*Service).loadWork (214.59 s cumulative; its fold closure 341.89 s). The slice is coded only if the lookups after a release carry at least half of loadWork's time: planLoop (loop_replay.go:152, :193), planContinuation (owner_replay.go:180), the paid parent lookup (paid_attempt.go:117) and planWork (scoped_work.go). Otherwise the peek comes back here. The change: in stageCommitLocked's install closure, after `s.publishCommitLocked(c, g, scoped)` (replay.go:712, which runs advance and then warmSources, :856-859), when the commit's scoped plan carries a work whose released is true, call `s.history.putWork(id, c.Last, *scopedNext.work, true)`. Nothing else changes: not loadWork (scoped_state.go:188-260), put's rules (history_index.go:364-388), advance's invalidation (:486-489), pruning (scoped_plan.go:143-146), the limits (history_index.go:146-150) or the Reader. Why it is safe: pruneScoped deletes a released work in the commit that ends it (scoped_plan.go:143-146), and advance removes its index entry in the same commit (history_index.go:486-489). A released work accepts no further transition (scoped_work.go:101-103), so its final state is as fixed as a source record, which warmSources already publishes (history_index.go:868). Today the first lookup after every release, live and again on every replay, folds the ledger from sequence 0 (scoped_state.go:201). The value published is the one installScoped just installed (scoped_plan.go:92-94), with the same receipt form the fold builds (scoped_plan.go:49; scoped_submit.go:129-137). This adds one fill by an accepted effect beside the note at history_index.go:424-426: it copies the reducer's result, it is not a second reduction; say so in the comment.",
      "expectedSaving": {
        "basis": "race-pprof-top-cum.txt: loadWork's cold folds are 341.89 s of 7,774 race thread-seconds, of (*Service).scan's 859.64 s. That most of them follow a release is [INFERENCE] from the code path; the entry check confirms or stops the slice. The gain is processor time, so it shows mostly under race.",
        "local": "race 50-80 s, plain 5-10 s",
        "windowsPlain": "10-25 s",
        "windowsRace": "40-70 s",
        "macosRace": "50-80 s",
        "linuxRace": "35-55 s"
      },
      "guarantees": [
        "Authority: on any miss, damage, eviction or disabled index the lookup still folds the ledger (scoped_state.go:198-246). The entry is a discardable hint inside the existing 256-entry, 8 MiB class (history_index.go:146-150), stored only through putWork and put's existing rule that an entry's coverage equals the index's (:384-388).",
        "Integrity checks: the Reader, its checkpoints and every verification step are untouched (contract/ledger/reader.go:128-136; scan.go:224-249). D157's frozen capability is not edited.",
        "Frozen bytes: no encoder, decoder, record type or golden changes.",
        "Open: still inert, still a full replay and inspection (service.go:204-232; integrity.go:124-236), and the projection after Open is identical.",
        "Crash recovery: recovery reads the same work state (admission, ended, outcome, version, receipt) as today.",
        "Ticket 142's directory and tail rules: advance (history_index.go:427-501), the command directory, the checkpoint tokens (:407-421) and the tail readers are not edited.",
        "Rows that prove it: the new row; testColdWorkHistory unchanged (history_index_test.go:1864-1900: it still suspends once the cache is damaged, :1881-1893, and recovery does not repeat the release); the frozen replays (scoped_golden_test.go:213-231; paid_replay_test.go:29-46); TestTurnLoopCrashRecovery; the ledger tail rows in ledger_tail_test.go."
      ],
      "acceptance": [
        "New row: for a released turn, a released local work and every released work in the chapter-11 and chapter-16 frozen replays, the entry present right after acceptance equals, field for field, the cold fold taken after damageHistoryCache (history_index_test.go:321) at the same sequence, live and after a reopen. The next record of that turn is accepted with no range read from sequence 0 (deps.beforeRangeRead, as history_index_test.go:1242 uses it).",
        "One plain verbose run and one race run of the whole package, green; `-race -count=20` of the new row and of testColdWorkHistory's parent; gofmt, vet, staticcheck clean.",
        "Race CPU profile after: loadWork's fold closure at most a third of its share of total samples on the 147-S2 tree.",
        "The coder cites the decode rule that binds a work admission's envelope identity to its submission origin, since the fold reads the envelope (scoped_state.go:201-241) and the reducer reads the submission (scoped_work.go:83).",
        "doc.go's history-index text names the fill and its fallback. Hosted three-OS check green on the exact SHA."
      ],
      "breaks": [
        "The fill publishes a state that is not the fold's (ended false, the earlier version, or the admission's receipt): the new row red.",
        "The fill is placed before advance, or dropped: the new row's no-cold-read assertion red.",
        "loadWork's fold ignores runtime.work_ended (scoped_state.go:221): testColdWorkHistory and the new row red.",
        "advance keeps a work entry across runtime.work_ended (history_index.go:486-489 removed): ticket 142's invalidation row (the PM names it from that ticket's evidence) and the new row red.",
        "Recovery: the mutants tickets 15 and 16 bind to rows that replay an ended turn's later records (native_ended_before_loop_end, owner_recovery_test.go:265), once each."
      ],
      "fuzz": [
        "FuzzScopedGroupReplay (scoped_replay_test.go:540), FuzzLoopGroupReplay (loop_fuzz_test.go:74) and FuzzContinuationGroupReplay (owner_fuzz_test.go:14), 120 s each on the final SHA."
      ],
      "commands": [
        "go tool pprof -peek 'agents\\.\\(\\*Service\\)\\.loadWork$' <evidence>/agents-race.test.exe <evidence>/race-cpu.pprof",
        "GOTOOLCHAIN=local CGO_ENABLED=0 go test -count=1 -v -timeout 30m ./internal/core/agents",
        "GOTOOLCHAIN=local CGO_ENABLED=1 CC=<pinned clang> go test -race -count=1 -timeout 30m ./internal/core/agents",
        "GOTOOLCHAIN=local CGO_ENABLED=0 go test -run '^$' -fuzz '^FuzzScopedGroupReplay$' -fuzztime 120s ./internal/core/agents (and the same for the other two targets)"
      ]
    },
    {
      "slice": "91-S2 rebased onto 147 (ticket 91's branch; carries T3; its run is the measuring run)",
      "options": ["T3"],
      "ownedPaths": [
        "internal/core/agents/service_fuzz_test.go (exists only on 91-S2's branch)",
        "conflict resolution only: internal/core/agents/scoped_golden_test.go (chapter 91's colony case, :44-46 at 8c2c1e2) and internal/core/agents/replay.go (keep both sides)"
      ],
      "change": "T3 cannot be a 147 slice: FuzzServiceGroupReplay is not on main. Conditions on the rebase, reviewed with 91-S2 under ticket 91. (1) Rebase onto main after 147-S3; 91-S2's fixtures then go through the seeded helpers with no further edit. (2) FuzzServiceGroupReplay builds each prefix once, lazily, inside the fuzz function's parallel phase instead of serially in setup. Today :57-73 builds 19 golden fixtures and one paid fixture before any seed runs: 84.5 s of the target's 144.7 s under race locally. Directories and closers are owned by f or the seed root, never by the first seed's t; the number of shapes comes from the parsed commits, so the seed list does not need the prefixes. (3) Add the same seeds mode-major (outer loop over the 12 modes, inner over shapes) instead of :81-85's order, so parallel seeds spread across prefix Services instead of queueing on one Service's mutex (:166). (4) Keep every seed and mode, the locked rejected-path check (:166-185) and the accepted path's copy, real store, real Submit and real Open (:189-209). (5) Audit service_nevercounts_test.go:183 as 147-S1 audits the other held handlers. A simpler route to the same target is fine if seeds and parity are kept.",
      "expectedSaving": {
        "basis": "race-summary.json: FuzzServiceGroupReplay runs from 02:58:46 to 03:01:10, 144.7 s, of which 84.49 s is its own serial setup. A rejected seed returns at service_fuzz_test.go:177-185 before the copy at :191, so the cost is the setup and the queueing, not a colony copy per seed.",
        "local": "race 80-100 s, plain 5-10 s",
        "windowsPlain": "10-20 s",
        "windowsRace": "90-130 s",
        "macosRace": "80-130 s",
        "linuxRace": "50-80 s"
      },
      "guarantees": [
        "The seed set is unchanged (12 modes for every shape, plus the corpus); only their order of addition changes.",
        "Rejected groups are still checked against an independently opened baseline under the prefix Service's mutex; accepted groups are still replayed inertly through a real store and a real Open.",
        "Nothing in 91-S2's product code is ruled here."
      ],
      "acceptance": [
        "FuzzServiceGroupReplay start to end at most 60 s in the local race run (144.7 s at 8c2c1e2).",
        "FuzzServiceGroupReplay for 120 s on the rebased SHA; seed count as before.",
        "Final-tree local runs and profiles (see measurement) before the push; local targets met.",
        "Hosted three-OS check green on the exact SHA, first attempt: this is criterion 1's measuring run."
      ],
      "breaks": [
        "Ticket 91's own rule breaks for the fuzzed service family, as its ruling lists them, rerun against the reordered target where they name FuzzServiceGroupReplay."
      ],
      "fuzz": ["FuzzServiceGroupReplay, 120 s"],
      "commands": [
        "GOTOOLCHAIN=local CGO_ENABLED=0 go test -run '^$' -fuzz '^FuzzServiceGroupReplay$' -fuzztime 120s ./internal/core/agents",
        "the two measurement runs in measurement, on the rebased SHA"
      ]
    },
    {
      "slice": "147-S4 (held: needs owner gate 1; used at once if he allows it now, otherwise only after a miss of criterion 1)",
      "options": ["T4"],
      "ownedPaths": ["internal/core/agents/paid_live_test.go (TestMain only, :21-33)"],
      "change": "In TestMain, before m.Run: call flag.Parse; if test.parallel was not given explicitly (flag.Visit) and runtime.GOOS is windows and GOMAXPROCS is below 8, flag.Set test.parallel to 8. Nothing else. tools/check, the workflow and D127's limits are not touched; an explicit -parallel still wins; macOS and Linux are unchanged because their race steps are processor-bound.",
      "expectedSaving": {
        "basis": "The Windows tests step is about ten times Linux's and the Windows race step only 1.3 to 1.5 times its own tests step (diagnosis, section 1): on that runner the tests wait on durable writes while four processors are partly idle. [INFERENCE: no run has measured a higher parallelism there; the 2026-10-16 study measured only the laptop.]",
        "local": "none (8 logical CPUs already)",
        "windowsPlain": "25-40% of what remains",
        "windowsRace": "25-40% of what remains",
        "macosRace": "0",
        "linuxRace": "0"
      },
      "guarantees": [
        "No test is skipped, moved or flagged; the same tests run in the same hosted check.",
        "147-S1's raised bound already covers the rows whose held exchanges are load-sensitive."
      ],
      "acceptance": [
        "One local whole-package race run with `-cpu 4 -parallel 8` (the hosted shape), green, and both CAS rows 20 of 20 under the same flags.",
        "Hosted three-OS check green; Windows figures read from the owner's log.",
        "A decision entry records the owner's answer, with CURRENT-RULES in the same commit (D161)."
      ],
      "breaks": [],
      "fuzz": [],
      "commands": [
        "GOTOOLCHAIN=local CGO_ENABLED=1 CC=<pinned clang> go test -race -count=1 -cpu 4 -parallel 8 -timeout 30m ./internal/core/agents"
      ]
    }
  ],
  "targets": {
    "criterion1": "Binding, the owner's figure, not tightened: on the measuring run (91-S2 rebased onto 147), the race step of internal/core/agents on hosted windows-amd64 takes at most 1,200 s.",
    "hosted": {
      "windowsTests": "at most 1,100 s (1,409.188 s on run 44874224657)",
      "macosRace": "at most 1,200 s (1,209.366 s, then 1,512.960 s with the failing row, on the last two runs)",
      "linuxRace": "at most 800 s (934.233 s)"
    },
    "localFinalTree": "91-S2 rebased onto 147, package alone, quiet machine: plain at most 375 s (472 s at 8c2c1e2), race at most 1,150 s (1,557 s).",
    "localPerSlice": "Against a new baseline on 51b9d58: after 147-S1, race at least 10% lower; after 147-S2, race at least 15% and plain at least 15% lower in total; after 147-S3, the profile target in that slice.",
    "focused": "TestTurnLoopCrashRecovery at most 45 s start to end under race locally (94.1 s); FuzzServiceGroupReplay at most 60 s (144.7 s); both CAS rows green 20 of 20 under race.",
    "reportingLine": "Every subtest above 60 s under race locally is named with its reason. It is a report, not a cap.",
    "criterion1Reachable": "Not assured by the ruled cuts. No run has measured today's figure, since both timed out. From runs #100 to #109 the race step is 1.45 to 1.60 times the tests step, which puts it near 2,050 to 2,250 s at 8c2c1e2. The ruled cuts sum to 560 to 900 s on that step (147-S1 150-250, 147-S2 280-450, 147-S3 40-70, 91-S2's fuzz target 90-130). That gives roughly 1,150 to 1,700 s with the centre near 1,400 to 1,450 s: inside D127's limit and under its 25-minute line, probably not under 1,200 s. The hosted weighting of 147-S2 is the largest unknown. What would reach 1,200 s with room is owner gate 1 (147-S4); with it I expect 800 to 1,100 s [INFERENCE, unmeasured]. The diagnosis's own P1 could not be ruled into a bounded slice (see rejected)."
  },
  "floor": "The ticket returns to the advisor, with the figures and for hosted cases the logs, before any further slice when: (1) a local per-slice target is missed; (2) the final tree's local race run is above 1,150 s or its plain run above 375 s (do not spend the measuring run first); (3) the measuring run's Windows race figure is above 1,200 s and owner gate 1 has not allowed 147-S4, or 147-S4 has run and the figure is still above 1,200 s; (4) another hosted target is missed by more than 10%; (5) the package times out or one of its tests fails on any hosted run of these slices (no rerun, D153); (6) the CAS row fails anywhere after 147-S1; (7) 147-S3's entry check fails. A return carries one labelled diagnostic: the final tree's plain and race CPU profiles and, for a Windows miss, counts of durable flushes and Git children by test family. Two further slices are available that way (D152 item 2, D160 item 1). A third, or any change to these bounds, traffic or eligibility, is the owner's.",
  "criterion3": "Cause [INFERENCE, demonstrated in 147-S1]: the row holds the third context's exchange open (loop_concurrent_private_test.go:135-142) until both contenders have finished all eight POSTs (:241-257). The paid runtime ends any exchange after DispatchTimeout, 120 s by default (paid_types.go:33; paid_dispatch.go:136; providers/transport.go:87). On a runner where the contenders need more than about two minutes the third turn cannot end `finished`, and :259-260 fails with the message seen at 170.24 s. Its sibling independent_continuations has the same shape: it holds three exchanges and releases them one at a time, each after the previous turn has finished and been read (loop_independent_test.go:190-194, :264-266). Fix, test-only: both rows open with the dispatch bound and their contexts' TimeoutMS raised to 30 minutes, the package's own limit, through one fixture helper. The product default and the rows that prove the bound (paid_lifecycle_test.go:60-61) are untouched, and ticket 146's question about the dispatch clock stays with ticket 146. Unchanged: the script, both holds, their release order and every assertion: three held turn slots (:237-240); each contender's exact calls, tools and POSTs (:249); no effect on the stale refusal (:253); no undeclared repair POST (:196); third turn finished with one call, one conflict, one winner, eight POSTs (:258-260); the merged text (:262-265); two applied revisions, each charged once (:266-301); the same-ID retry before and after reopen (:304-339). Only the text at :260 changes, to name the third turn's outcome and reason and the counts. Proof: (1) with the helper set to 2 s in a throwaway overlay the row fails at :259-260 naming the third turn; restored, it passes; (2) both providers' rows 20 of 20 under race locally; (3) the row passes every hosted race step from 147-S1 to the measuring run on all three systems. A failure is never rerun; it returns here with the new message. The mutants ticket 16's evidence binds to the row are rerun red (147-S1's breaks).",
  "order91": "'Land after this ticket' means after ticket 147's four criteria are met: not merely after its code is on main, and not after its close documents. Sequence: 147-S1, 147-S2 and 147-S3 land on main, each on its own green exact-SHA run (D153). 91-S2 is then rebased onto that main with the plan's conditions and reviewed under ticket 91. Its branch run is criterion 1's measuring run. That run must be green: the figure is the `ok` line of internal/core/agents in the windows-amd64 race step of attempt 1. A time-out, a failing test in the package or a rerun gives no figure, and main cannot move to a red SHA anyway. 91-S2 moves main only when that run is green and the Windows race figure is at most 1,200 s. On a miss it stays on its branch, and the ticket takes 147-S4 if owner gate 1 allows it, or returns to the advisor. Reading: the PM asks the owner once for that run's three job logs and reads the package lines. If the whole race step of the Windows job, taken from the run's job data, is itself at most 1,200 s, criterion 1 is already met and the log only supplies the exact figure [INFERENCE that the job data is readable without sign-in]. Ticket 91's later slices may be coded meanwhile but land only after 91-S2 has landed. Ticket 147's Markdown-only close may follow. If 91-S2 cannot be made green for a reason of its own, ticket 147 stays open on criterion 1 only; nothing else in it waits.",
  "measurement": "Local, by the PM (the coder runs only the focused checks): quiet machine with the quiet-run admission record (D160 item 8), the package alone, default -parallel: `go test -count=1 -json -timeout 30m ./internal/core/agents` and the same with -race, each summarised with C:/Users/darius.jones/dwarf-tmp/gotest_json_summary.py. From 147-S1 on, both runs also write a CPU profile (the diagnosis's profiled and unprofiled race runs both took 1,556 s). Trees: a new baseline on main 51b9d58 (the diagnosis measured 8c2c1e2, which includes 91-S2), each 147 slice SHA, then 91-S2 rebased (before = the diagnosis's 472 s and 1,557 s). One run per figure; a figure within 5% of a target is run once more and the slower counts. Report per tree: package wall for both runs; seconds with one top-level test running; the ten slowest subtests; every subtest over 60 s under race; start to end of TestTurnLoopCrashRecovery and of each fuzz target; and from the profiles the shares of readRange, scan, loadWork's fold, the fixture builders, FlushFileBuffers and the Git children. Use Elapsed and the profiles as cost, not start-to-end spans: plain-summary.json records 0 s for the subtests of TestReviewGuardBindsOwnerAndAgentButAllowsEscapes (lines 10204-10210, started 02:30:38, reported 02:33:32) and 0.01 s for TestReviewSlotTransitionsRefuseIllegalEdges (:10197-10203). These tests touch no file (review_slots_test.go:12-131), so the diagnosis's review-family figures and its leaf-second sums include queueing, and no option acts on them. Hosted: the `ok` or `FAIL` lines for internal/core/agents in the tests and race steps of the three jobs, from the owner's saved logs, each checked for run, attempt 1, job and SHA; requested twice (owner gate 2). Traffic: the hosted check as tools/check runs it (tools/check/main.go:130; race.go:28; -count=1, -timeout 30m, no test selection). Eligible: the first attempt on the exact SHA with the package reported ok; a FAIL or a time-out gives no figure; a rerun never counts. Local figures stay in the private evidence (D145).",
  "ownerGates": [
    {
      "gate": "1. Running this package's tests eight at a time on Windows (option T4, slice 147-S4)",
      "whyReserved": "It changes how the hosted check runs this package without changing tools/check (D42), and it overlaps the waits on slow disk writes rather than removing them, which D171 chose not to do by reconfiguring the runner. The 2026-10-16 ruling left -parallel to the owner.",
      "question": "After the ruled cuts I expect the agents package's race step on the hosted Windows runner, with ticket 91's S2 tests, to land near 1,400 to 1,450 s (range about 1,150 to 1,700 s). That is under D127's 30-minute limit but probably over ticket 147's 20 minutes. One more lever is yours to allow or refuse: let this package run eight tests at a time on Windows when no -parallel flag is given, set inside the package's own TestMain. tools/check, the workflow and D127's limits stay as they are, and no test is skipped. On that runner the tests mostly wait for slow disk writes while its four processors are partly idle, so I expect a further 25 to 40% off both Windows steps; this is unmeasured. It does not make the product's writes cheaper, and it loads timing-sensitive tests more. Choose one: (a) allow it now, in the first slice; (b) allow it only as a fallback if the measuring run misses 1,200 s; (c) refuse it. After (c), a miss needs either a product ticket (keeping ledger readers or decoded history in memory, which changes the limits D157 and D158 set and needs its own design) or a change to criterion 1's figure.",
      "advice": "(b): it keeps the reductions in real work first and avoids a wait if they fall short."
    },
    {
      "gate": "2. Job logs from your GitHub account",
      "whyReserved": "The hosted per-package times are only in the job logs, which need your sign-in.",
      "question": "Please save the three job logs (Windows, macOS, Linux) of two runs when the PM names them: the run on which ticket 147's second slice lands, and the run of ticket 91's S2 rebased onto ticket 147. The second decides criterion 1.",
      "advice": "No decision needed; two downloads."
    }
  ],
  "notesForCoders": [
    "Branch each 147 slice from main; 91-S2's code is not there. One slice, one branch, one coder; slices land in order.",
    "Line numbers in this ruling are the gate tree's (8c2c1e2). 91-S2 edited replay.go, history_index.go, history_prepare.go, service.go, loop_runtime.go and scoped_golden_test.go, so locate by symbol on main.",
    "147-S1 and 147-S2 touch no product file. 147-S3 touches replay.go's install closure and doc.go comments only. Nothing under contract/**, tools/check, .github or go.mod; no new dependency (D29); LF (B1).",
    "No assertion changes. A test outside the owned paths that fails is a finding to report, not a file to edit.",
    "What must not grow: mocks, fake flushes, snapshots of open stores, shared Services, stores, transports or provider servers, sleeps, duration assertions, retries, row or seed trimming, -short or testing.Short, build tags, skips, a package split, flag.Set of test.parallel outside 147-S4.",
    "Seeds: lazy, per process, closed before the first copy, read only through the copy helper, values decoded afresh per fixture. paid_crash_test.go:117-148 and :409-430 are the in-package pattern; lift it from per test to per process.",
    "A seed build that fails must fail every later user: sync.Once counts a Goexit as done, so record the failure explicitly.",
    "Crash children keep their environment on the exec.Cmd. A child may build its own seeds only under the temporary directory its parent set.",
    "The dispatch bound may only rise, and only in the audited rows. After reopenIntegratedFixture (loop_independent_test.go:21-52) the Service is back on the defaults; reapply the helper if a hold follows.",
    "Process-state tests stay sequential: paid_credentials_test.go:19, paid_openai_test.go:613, paid_native_windows_test.go:33, paths_test.go:82, paid_capture_test.go:37.",
    "147-S3: the fill goes after publishCommitLocked, only for released work, only through putWork. If the new row shows any field differing from the cold fold, stop and report; do not adjust the fold or the row.",
    "Local figures, paths and anything about the owner's machine stay out of tracked files and commit messages (D145). Conventional Commits, scope agents.",
    "A yes to owner gate 1 needs a decision entry and its CURRENT-RULES line in the same commit (D161). Nothing else in this ruling changes a standing rule."
  ],
  "rejected": [
    {
      "option": "P1 as listed (kept tail position, reused decoded records, narrower cold ranges)",
      "why": "A reader that stays open past its Through is not in the frozen ledger-reader capability (contract/ledger/reader.go:124-136; errors are final, :257), and it would drop the fresh prefix hash D157 requires on every checkpointed open (reader.go:129-133; scan.go:224-249). That is a change to a frozen contract's rule: owner gate. Reusing decoded records across reads is a second retained copy of history outside the single 256-entry, 8 MiB class (history_index.go:146-150), which D158 held fixed: owner gate. Narrower ranges for cold folds need new directory coverage with its absence rules, a design of ticket 142's size. 147-S3 takes the one part that is small and provably the same value."
    },
    {
      "option": "P2 (directory durability checked once per incarnation)",
      "why": "It is already so for flushes: checkDirectories reuses this instance's successful flushes (paths.go:143-145). Its per-call Lstat of every component is the guard that refuses a replaced or non-real directory (paths.go:100-127). Trusting a previous incarnation's flush, or skipping the per-call check, changes the crash guarantee and the foreign-entry guard: owner gate. Much of the measured cost is the fixture's own doing (a fresh directoryDurability per golden record, scoped_golden_test.go:165), which 147-S2 removes."
    },
    {
      "option": "P3 (fewer flushes per operation)",
      "why": "Every flush on the path is one the durability contract names: the temporary file before its rename (storage.go:86-88), the write-through rename and directory flush (durable/durable_windows.go:83-98; storage.go:65, :71), the commit before it is acknowledged (ledgerstore/store.go:763-771). The diagnosis names no redundant one. Removing any is a change to a crash guarantee (B3, D34): owner gate. If the floor trips on Windows, the flush count by family is the diagnostic for a proposal."
    },
    {
      "option": "T4 as a unilateral change",
      "why": "Owner gate 1. It is pre-ruled as 147-S4 so that a yes needs no further ruling."
    },
    {
      "option": "T3 inside a 147 branch",
      "why": "FuzzServiceGroupReplay exists only on 91-S2's branch. It rides 91-S2's rebase instead."
    },
    {
      "option": "Deeper seeds (live, OpenAI and turn fixtures; registered workspaces; Git host repositories)",
      "why": "Those states record per-test values: the test server's authority in the route profile (paid_live_test.go:77-94; loop_fixture_test.go:38-46), a secret that a reopened Service does not hold (paid_live_test.go:71-76; paid_dispatch.go:123-127), and absolute repository paths. Seeding them would add commands to each ledger and change sequences that rows read. What they still cost per fixture is small (32 s and 24 s of plain thread time against 292 s)."
    },
    {
      "option": "A hand-made empty colony in place of ledgerstore.Create in newServiceFixture (service_test.go:33-37)",
      "why": "Create's 256 fan-out directories (ledgerstore/bodies.go:86-124) do cost Mkdir and RemoveAll time locally, but a colony without them is the store's repair path (bodies.go:308-316), not the layout the product creates. Changing Create itself is another package's design and is not ruled here."
    },
    {
      "option": "Cheaper durability in fixtures (fake files, flushes skipped, core.fsync off in host repositories)",
      "why": "It would hide the cost D171 says to keep visible and would weaken what the crash rows exercise."
    },
    {
      "option": "Sharing an opened Service, store, workspace or provider server between tests; fusing Open's inspection into its replay",
      "why": "The first removes the isolation the rows depend on. The second removes or reorders an integrity check that Open performs on every historical object (integrity.go:124-236)."
    },
    {
      "option": "Parallelising the process-state tests or TestRegistrationInjectedCrashRecovery",
      "why": "The former use t.Setenv, t.Chdir or a session-wide native resource. The latter states serial children as its property (registration_crash_test.go:35-38) and is not part of the measured serial phase."
    },
    {
      "option": "Row or seed trimming, -short, skips, build tags, a package split, a higher limit, moving the temp directory or changing the runner image",
      "why": "Criterion 4, D127 and D171."
    }
  ]
}
```
