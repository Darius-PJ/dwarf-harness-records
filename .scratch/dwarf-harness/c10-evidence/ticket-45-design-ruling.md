# Ruling: ticket 45 implementation design (§1–§9 of `local://t45-brief.md`)

**Advisor:** build advisor (Claude Fable 5.1), under D117. **Base:** `main` at ee798a5, read-only.
**Ruled on:** `local://t45-brief.md` §1–§9 (DesignT45), with `local://t45-api-digest.md`, `local://t45-api-digest-2.md`, the gate ruling (§0 of this file's predecessor, carried below as §0), and the repository conventions the brief cites (`internal/core/workspace/recovery_test.go:455-509`; `internal/core/ledgerstore/peakmem_windows_test.go:14-47`; `tools/check/boundary.go:49-53`; `internal/core/durable/durable.go:1-3`), which I read myself.

**Verdict: approve**, with P7 and P14 amended as ruled in §1 and the findings in §4. The ruling wins over the brief where they differ; the brief is not re-edited. **Owner gates: none.** No freeze, no contract, no module, no cgo. The design goes to the build. **Budget:** S1 now, with the checkpoint in §3; S2 and the close wait for the Oct 22 reset.

## Owner summary

- The design builds exactly the owner-selected Windows mechanism: a fresh per-run AppContainer SID plus a non-breakaway Job, suspended launch, explicit handle allowlist, restrictions before resume, network denied, positive tree exit before reuse (`docs/ROADMAP-CORE.md:950`; `docs/DESIGN-CORE-AND-LAUNCHERS.md:987`). It is one Core-internal package, `internal/core/winexec`, with a synchronous `Run` and one slot per root; no ledger family, contract, helper service or new module (brief §2, §7).
- The brief's stricter variant, LPAC (opt-out of ALL APPLICATION PACKAGES, zero capabilities), is approved as the **first profile to qualify**, not as a condition of the ticket. The qualification happens once, in S1, and is recorded; if a headless Go payload cannot start under LPAC on this machine, S1 ships the regular AppContainer profile and the same protected-target denials must pass. One profile ships; no runtime mode switch (P14, amended).
- Quarantine survives a Core crash through a small private fence file under the run root, written before any native effect and replaced by a closed proof only after the Job is positively empty; reopen after a crash refuses reuse of anything unproven and never reruns a request (P10).
- Tests run real processes on the real machine: the test binary itself is the sandboxed payload, Git and the C1 ledger store are the real denial targets, and crashes are real supervisor kills, as C2's crash matrix does. No mocks (§6).
- Two code slices, S1 (the module and its core proofs) and S2 (the adversarial matrix, crash matrix, measurements, fuzz), then one documents close (P13). Each new test under 60 s under race (B28 item 8).
- Defender stays on; the `git.exe` exclusion is disclosed verbatim in the evidence; no figure is capacity (§6.4).
- Owner questions: none. D29 only if an API turns out to need a module outside `x/sys`; the design expects none.

## 1. Rulings on P6–P14

| Choice | Ruling |
|---|---|
| **P6** one module, synchronous `Run`, one slot per root | **Approved.** The caller supplies its own goroutine; the module owns every native handle (§3.1). `Executor` opaque per platform file, `executor_other.go` refusing with `ErrUnsupported` is the real behavior on other systems, not a stub (tickets 47/49 own those). |
| **P7** atomic Job assignment through `PROC_THREAD_ATTRIBUTE_JOB_LIST`, never breakaway | **Approved, amended.** JOB_LIST first. If, on this machine, JOB_LIST cannot be combined with `SECURITY_CAPABILITIES` (digest §2.2's gap), the recorded alternative is `CREATE_SUSPENDED` → `AssignProcessToJobObject` → `IsProcessInJob` nonzero → resume. The brief's "supervisor-death gap" (§3.3) is a leaked *suspended* process, which never executes an instruction and which the unconfirmed fence already quarantines; it is not an escape. Both routes must prove membership before `ResumeThread`; both refuse rather than run outside the Job; neither sets a breakaway flag. The choice is made once in S1 and recorded in `doc.go`. |
| **P8** private writable `work/`, bounded stdio only, no artifact export, no disk quota claimed | **Approved.** The honest statement that scratch and profile storage are measured, not quota-enforced, is required wording in `doc.go` and the receipt's documentation (B11 `docs/DECISIONS.md:737` names no disk quota). |
| **P9** complete caller-supplied finite profile, exact native semantics | **Approved.** The limit table (§4.3) maps each declared bound to one Win32 control and one refusal; user CPU is user CPU, Job commit is commit, no field defaults to unlimited. |
| **P10** strict private durable fence, no optimistic recovery, no clear/retry API | **Approved.** The ordering (§5: fence before profile, profile binding before child, closed proof only after Job-zero, marker removed last) is correct and the strict decoder is justified by what a false closed proof would release. The 4-KiB cap and format are module-private; no register row. |
| **P11** one final receipt after real tree proof; bounded cancellable pipes | **Approved.** Root signal + exit code capture + close owned root references + `ActiveProcesses == 0` on the retained Job is accepted as the positive proof, bounded by `StopGrace`; kill success, PID absence, pipe EOF and exit-code tokens are not. S1 must run the probe in §5 note 4 on handle retention. |
| **P12** real low-cost native proof, no fake upstream data | **Approved**, with one test dropped (§4 F5). The representative denial targets (owner pipe, credential/peer/sealed-result nonce files) are reachability fixtures, as the gate ruling permitted; the real Git repository and the real `ledgerstore` colony are required. |
| **P13** S1 complete module, S2 adversarial proof and cost, one close | **Approved**, with the budget schedule in §3. |
| **P14** LPAC, zero capabilities, empirical qualification, no fallback | **Approved as the first profile to qualify, amended on the fallback.** The ticket and the owner's decisions select "AppContainer"; LPAC is the designer's stricter reading, and its ability to run a headless Go console binary with zero capabilities on 19045 is unverified (digest §3 Q2, §4a). A dead end here would block the ticket on a choice no document requires. Rule: S1 qualifies LPAC first; if the positive control fails **at process start or loader stage** (not at a protected target), S1 switches once to the regular AppContainer profile (ALL APPLICATION PACKAGES retained), records the result and the reason, and every protected-target, network, descendant and closure test still must pass under it. Exactly one profile ships; `Request` has no profile field; no runtime fallback; a protected target reachable under either profile fails the ticket. The honest host-state precondition (§4.2) stands under both. |

## 2. The tests

The matrix (§6.2) covers all five criteria with observations a consumer sees: real bytes, real denials, real tree exit, real reopen results. Rulings:

1. **Payload = the test binary re-executed** (§6.1), the C2 crash-helper convention (`recovery_test.go:464-466`). Approved. The `testing` framework's own stdout lines are payload output and count against `OutputBytes`; tests budget for them (§5 note 7).
2. **Crash matrix** (§6.3): eight death points, each a real supervisor kill with its own root, profile and processes, parallel subtests as in B28 item 7. Approved. The ambiguity row's deliberate Job-handle duplication and the two sharing-violation rows are real faults, not injected returns.
3. **Fence decoder fuzz** (`FuzzFenceDecode`): approved; a false closed proof would release quarantined resources, so the decoder earns a permanent target. 120 s once on the final code (D116 item 6).
4. **Resource evidence case** (§6.4): approved as evidence, not as a threshold test; the Defender sentence is stated verbatim.
5. **Dropped:** the regular-AppContainer control launch inside `TestLPACDoesNotUseBroadPackageGrant` (§4 F5). The token class-46 readback and a canary granted to `S-1-15-2-1` only, denied to the executor, suffice; under a regular-AppContainer profile this test is replaced by its negative statement in `doc.go` (any object granting ALL APPLICATION PACKAGES is reachable; protected Core objects must not).
6. **Cost rule:** every top-level test and subtest under 60 s in the uncached race log; heavy drills split per resource (§6.3 "Hard cost condition"). Approved.

## 3. Slicing and the budget

- **S1 now.** Its first deliverable is the qualification block (§9, "Qualification order within S1"): four startup attributes, token readback (classes 29/30/31/46), label-only lowering, profile-folder binding, JOB_LIST-or-assign, Job-zero after normal and quota termination, network denial. **Checkpoint:** the coder reports those outcomes to the PM as soon as `TestPermittedInputAndBoundedOutput` and `TestAppContainerJobAndSuspendOrder` pass (or one fails at a native boundary), before writing the rest of the module. A failure returns here for a revised ruling at the cost of the probe only; a pass continues S1 without a further question.
- **S2 and the close after the Oct 22 reset.** S2 is where defects found by the adversarial matrix are fixed at the native layer, i.e. the iterative spend. If S1's review lands before the reset, hold S2's dispatch rather than start it on the remaining budget.
- The PM's merge checks are unchanged: `go run ./tools/check -race=false` for S1, the full check for S2 (D129); the close is the one documents commit of the gate ruling §5.

## 4. Findings on the brief

| # | Severity | Location | Problem | Change |
|---|---|---|---|---|
| F1 | major | §4.2 (`:302-306`), P14 (`:618-636`) | "No regular-AppContainer fallback" makes the ticket depend on an unverified property of LPAC that no document requires. | Ruled P14: once-only qualification in S1, one shipped profile, same denial matrix under either. |
| F2 | minor | §3.3 (`:238`), P7 (`:583-586`) | Refuses the documented suspended-then-assign route for a leak that is not an escape. | Ruled P7: JOB_LIST first, assign-then-`IsProcessInJob` as the recorded alternative; membership proved before resume on both. |
| F3 | minor | §4.3 (`:314`) | `CREATE_NO_WINDOW` still allocates a hidden console; console-host creation under an AppContainer token is unverified and unnecessary for a pipe-only child. | S1 qualifies `DETACHED_PROCESS` first (no console at all); if the Go runtime needs a console, `CREATE_NO_WINDOW`; record which. |
| F4 | minor | §4.2 (`:308`) | Per-run traversal ACEs on `Root`/`runs/` and their removal at cleanup mutate shared ancestors on every run. | If the AppContainer token holds `SeChangeNotifyPrivilege` (bypass traverse), grant nothing on ancestors; probe in S1; mutate ancestors only if traversal is actually denied. |
| F5 | minor | §6.2 `TestLPACDoesNotUseBroadPackageGrant` | A test-local regular-AppContainer launcher duplicates the product's native launch path or needs a production seam the brief itself forbids. | Drop the control launch; keep class-46 readback plus the `S-1-15-2-1`-only canary denial. |
| F6 | minor | §4.4 (`:345`), §6.2 | `ActiveProcesses` decrement while an outside handle to an exited descendant is open is unverified; a false quarantine is safe but would be a product defect. | S1 probe (§5 note 4); the product holds no descendant handles; tests close observer handles before asserting Job-zero. |
| F7 | nit | §6.1 | Each run copies the test binary into `input/`; Defender scans each new image. | Measure staging cost separately in §6.4's evidence; it is part of the setup figure, not sandbox execution. |
| F8 | nit | §3.1 `Receipt` | `State`, `ResourcesReusable` and `OutputState` overlap. | None; the orthogonal flags are documented and each is proved separately. |

## 5. Notes for S1

1. Order of work: the qualification block of §9 first, as runnable tests, then the module. Report the checkpoint (§3) before continuing.
2. Attribute constants and classes from the digests: `0x00020009`, `0x0002000D`, `0x0002000F`, opt-out value `DWORD 1` (4 bytes); token classes 29/30/31/46 by `uint32`; `JobObjectEndOfJobTimeInformation` = 6 with action 0; `IsProcessInJob` from `kernel32.dll`; `CreateAppContainerProfile`/`DeleteAppContainerProfile`/`GetAppContainerFolderPath` from `userenv.dll` via `windows.NewLazySystemDLL`; `Find` before use, never `Addr`'s panic. Keep every attribute buffer, SID and handle array alive through `CreateProcess` **and** `Delete()` of the attribute list.
3. Two launch probes, each decided once and recorded in `doc.go`: JOB_LIST versus assign-then-verify (P7); `DETACHED_PROCESS` versus `CREATE_NO_WINDOW` (F3).
4. Job-zero probe: after a normal exit with the root handle closed, confirm `ActiveProcesses` reaches 0 within `StopGrace`; then repeat while the test holds an open handle to an exited descendant, and record whether the count stays above zero. The product must never hold descendant handles; tests close observer handles before the Job-zero assertion.
5. Profile qualification (P14): LPAC with zero capabilities first. If the payload fails at start or loader stage, switch once to the regular AppContainer profile, record the native error and the switch, and run the whole denial matrix under it. A protected target reachable under the shipped profile is a failed criterion, not a baseline.
6. `durable.go:2-3`: replace "It is the only package that imports golang.org/x/sys" with the narrow-adapter statement; no behavior change.
7. Output budget in tests: the `testing` framework's own stdout (`PASS`, `ok`, `t.Log`) is payload output; size `OutputBytes` for it, and keep the exactly-at-budget row exact.
8. Race-instrumented payload: choose `JobCommitBytes` so the race runtime reaches readiness; the memory-limit row tightens only its own bound (§6.2's note).
9. Ancestors: probe bypass-traverse before writing any ACE on `Root`/`runs/` (F4).
10. Staging cost: time the copy of the executable into `input/` separately (F7).
11. No `Request` field, environment variable or build tag selects a profile, console mode or Job route; the qualified choice is the only path, and the tests exercise that path.

**Requests:** none.


## 6. Revised ruling at the S1 checkpoint (2026-10-17)

**Ruled on:** `local://t45-checkpoint-probes.md`. The probe facts are accepted: no AppContainer launch without `LOCALAPPDATA` (probes d–h), LPAC itself is not the blocker (b, c, f, k), class 46 is unqueryable on 19045 (i), `DETACHED_PROCESS` and `JOB_LIST` work (k), `SeChangeNotifyPrivilege` is held so F4 resolves to "no ancestor ACE". **Verdict: continue S1 under LPAC + `JOB_LIST` + `DETACHED_PROCESS`; no P14 switch; no second checkpoint.** Three rulings, chosen for the least new native code.

**6.1 The child's environment: the real `LOCALAPPDATA`, probe (k)'s block.** The block is `SystemRoot`, `WINDIR`, `LOCALAPPDATA=<the host's real LocalAppData>`, `TEMP`, `TMP`; nothing else (`APPDATA`, `USERPROFILE`, `PATH`, `HOME` absent). Windows rewrites `LOCALAPPDATA` to the owned profile folder `…\Packages\dwarf-harness-<run>\AC` and `TEMP`/`TMP` to its `Temp`; that folder is the one the design already creates, binds by volume/file identity, lowers to Low, empties no-follow and deletes (§4.1, §5). Option 2 (a mirror under `work/`) would add a second profile-shaped tree with its own label and ACL and still leave the real profile folder to delete: rejected. `work/` stays as built; the child reaches it through one fixed variable, `DWARF_WORK=<absolute work path>`, added to the block; `cwd` stays `input/`. `doc.go` and the evidence state verbatim: the child's environment reveals the host's LocalAppData path, hence the user name; it is required by AppContainer launch and is not a grant beyond the owned profile folder.

*What S1 proves about `TEMP`:* the payload reads `TEMP`, creates a file there, writes a nonce, closes, reopens, reads back equal bytes, closes; it reports the path and every native error code; the host asserts the reported path lies under the fence's bound `profile_path` and that the nonce read back. Removal is **not** asserted by the payload: emptying the folder is the host's cleanup, already in the design. Probe (k)'s read-back failure and sharing violation are not accepted as facts until the errors are kept; a write-then-read without an intervening close, or a scanner's transient handle, are the plausible causes. Add one row to `TestProtectedTargetsDenied`: a nonce file directly under the host's real `<LocalAppData>` is denied, so the visible path is not a grant.

**6.2 The LPAC proof: behavioral, class 46 dropped.** The pre-resume runtime check is classes 29 (nonzero), 30 (zero capabilities) and 31 (the fresh SID) plus `IsProcessInJob` and the limit readback; LPAC is attribute-applied (`Update` and `CreateProcess` succeeded with the opt-out), not token-read per run, and `doc.go` says so. The S1 test proves the effect once with two canaries: a file granted to Core and `S-1-15-2-1` (ALL APPLICATION PACKAGES) only is denied to the child; the same file with an added grant to the fresh package SID is readable. Class 39 (`WIN://NOALLAPPPKG`) is not required: it needs a new claim-attribute mirror and rests on no primary source here. `TestLPACDoesNotUseBroadPackageGrant` becomes exactly this two-canary test.

**6.3 Continuing S1.** Confirmed: LPAC, `JOB_LIST`, `DETACHED_PROCESS`, no ancestor ACEs, no P14 switch, all recorded in `doc.go`. The remaining items, Job-zero after quota termination, Job-zero with an observer handle open, network denial and the denial matrix, are proven inside S1 with no further checkpoint; the standing rule applies only if one fails at a native boundary (report the native error, stop). One small addition, for a Defender-on machine: cleanup's unlink retries `ERROR_SHARING_VIOLATION` only, bounded within `StopGrace` (short polls), then stays cleanup-pending as designed; nothing else retries.

**Requests:** none.

**Notes for S1 from this revision** (they extend §5's list):

12. Environment block exactly as probe (k) plus DWARF_WORK; document Windows' rewrite of LOCALAPPDATA/TEMP/TMP into the profile folder and that the user name is visible.
13. TEMP proof: write, close, reopen, read back, close; keep every native error code; no removal assertion in the payload; host asserts the reported path is under profile_path.
14. Add the <LocalAppData>-root nonce row to TestProtectedTargetsDenied.
15. Drop class 46 everywhere; pre-resume check is 29/30/31 + IsProcessInJob + limits; LPAC proved once by the two-canary test.
16. Record in doc.go: LPAC, JOB_LIST, DETACHED_PROCESS, no ancestor ACEs (SeChangeNotifyPrivilege held), LPAC attribute-applied not token-read.
17. Cleanup: bounded retry on ERROR_SHARING_VIOLATION only, within StopGrace; everything else stays cleanup-pending as designed.
18. Finish the remaining checkpoint items inside S1; stop and report only on a failure at a native boundary.


## 7. Revised ruling after the LPAC Winsock failure (2026-10-17)

**Ruled on:** `local://t45-checkpoint-probes-2.md`. Facts accepted: under LPAC with zero capabilities `WSAStartup` fails (10107), so any Go payload's `os` file I/O fails while raw `CreateFile`/`ReadFile` works (probes n, o); the regular AppContainer passes every file, `TEMP` and `DWARF_WORK` round trip (m); loopback connects are dropped, not refused (m); the Job time limit ends the root with `0xC0000044` and Job-zero follows; an outside handle to an exited descendant holds `ActiveProcesses` at 1 until closed (m-observer). **Verdict: P14's approved switch applies. S1 ships the regular AppContainer profile. No owner gate: that is the mechanism the roadmap names (`docs/ROADMAP-CORE.md:950`).**

**7.1 The profile: regular AppContainer, zero capabilities.** Remove the opt-out attribute (three attributes: security capabilities, handle list, Job list); everything else stands (fresh per-run SID, `JOB_LIST`, `DETACHED_PROCESS`, §6's environment block, classes 29/30/31 and `IsProcessInJob` before resume). LPAC plus a named capability (`registryRead` or similar) is not selected: unverified, more native code, and a narrower ambient surface is not an acceptance criterion. `doc.go` records why LPAC was rejected on 19045 (probes n, o, m) and states the shipped boundary verbatim: *the token holds ALL APPLICATION PACKAGES (`S-1-15-2-1`); any object that grants it is reachable; Core's protected objects must never grant it.* The two-canary LPAC test becomes `TestProfileGrantBoundary` with three canaries in one run: granted to Core only → denied; plus the fresh package SID → readable; plus `S-1-15-2-1` → readable (the documented limitation, pinned so a silent change in either direction is seen). The protected-target matrix is unchanged and still decides AC2.

**7.2 Network denial: the listener sees nothing.** The observable is host-side: a listener the test owns accepts no connection and receives no bytes while the child dials it; the positive control is the host's own dial to the same listener, which connects and delivers a nonce; the child's dial uses a short test-chosen timeout (about 2 s) and reports its error, whose kind (timeout or `WSAEACCES`) is recorded, not asserted; no duration is asserted. Class 30 (no capabilities) remains the token-side check. This is the denial AC2 names; a drop is a denial.

**7.3 The quota exit: accept the NTSTATUS through its Win32 mapping, and prove the limit from accounting.** The test accepts `exit == 0xC0000044` (`STATUS_QUOTA_EXCEEDED`) or `exit == 1816`, by asserting `windows.NTStatus(exit).Errno() == windows.ERROR_NOT_ENOUGH_QUOTA || exit == 1816`. The primary evidence that the Job's limit, not the wall guard, ended the tree is the Job's basic accounting after exit, `TotalUserTime >= PerJobUserTimeLimit`, and completion before the wall guard. The product does not classify the exit: `Outcome: Exited`, the raw code with `ExitCodeKnown`, `ErrProcessExit`; no new outcome.

**7.4 The observer handle: no change to the proof.** A third-party handle to an exited descendant delays Job-zero; the `StopGrace`-bounded wait absorbs a transient hold, and a persistent one quarantines, which is the safe side (no running code, but no proof either). `doc.go` and the evidence state this limitation and that `StopGrace` should be sized for scanners (tests use about 5 s); the product holds no descendant handles; the observer test closes its handle and observes 0. Listing PIDs and probing each exit code would be new native code and PID-reuse-prone; rejected.

**Requests:** none.

**Notes for S1 from this revision** (they extend §5's and §6's lists):

19. Remove PROC_THREAD_ATTRIBUTE_ALL_APPLICATION_PACKAGES_POLICY; NewProcThreadAttributeList(3); delete all LPAC-only code and the class-46 remnants.
20. doc.go: regular AppContainer shipped; LPAC rejected on 19045 because Winsock startup fails without capabilities and Go's os I/O depends on it (probes n, o, m); boundary sentence on S-1-15-2-1 verbatim.
21. Replace the LPAC canary test with TestProfileGrantBoundary (three canaries, one run).
22. TestNetworkDenied: host listener accepts nothing and receives no bytes; host positive-control dial delivers a nonce; child dial timeout ~2 s with the error recorded only.
23. TestNativeUserCPULimit: assert NTStatus(exit).Errno()==ERROR_NOT_ENOUGH_QUOTA || exit==1816, plus Job TotalUserTime >= limit and completion before the wall guard.
24. Keep StopGrace ~5 s in tests; document the third-party-handle limitation; observer test closes its handle and sees ActiveProcesses reach 0.
25. Continue S1 to completion; report only a failure at a native boundary.


## 8. Race-instrumented payloads (2026-10-17)

**Ruled on:** the PM's report of `TestWallDeadlineStopsWholeTree` under race: the race-instrumented Go grandchild died at ThreadSanitizer start (`failed to allocate 0x800000 at 0x028000000000, error 487`) before `held-ready`; the receipt was correct (Closed, tree-zero, reusable); peak 235 MB under a 2 GiB limit; every other race row passed; the plain suite passes. **Verdict: not (a); (b) first, bounded; then the smallest fix the probe selects; (c) only as that fix.**

**8.1 (a) is rejected.** A `go build` inside the test run is a new convention: a toolchain and `CC` dependency inside `go test`, a cold compile per package run under Defender, and a payload that is not the artifact the check built. It is admissible only if 8.2 and 8.3 both fail, and then as a separate question.

**8.2 (b) first: two throwaway probes under race, one factor each, no product change.** (1) The same row with `JOB_OBJECT_LIMIT_JOB_MEMORY` not set; (2) the same row with the grandchild launched as a direct child. Keep the exact error and the Job accounting from each. The 487 (`ERROR_INVALID_ADDRESS`) is a fixed-address reservation collision, not a commit refusal (1455/8), so expect (1) to pass only if TSan's startup commit is what the Job limit refused and the code is misreported; expect (2) to pass if the collision is specific to a process spawned by an already-instrumented child. Cap: one coder session; report the two outcomes with the fix applied.

**8.3 The fix by outcome, least code first.**
- *Limit-related:* a race-only test constant (`//go:build race` file, e.g. `raceJobCommitBytes`) raises `JobCommitBytes` for rows that spawn a Go grandchild; `doc.go` unchanged; the evidence notes that the race runtime's commit is test overhead, not a product figure.
- *Not limit-related (collision or flake):* (c), confined to the rows that need only a **held** descendant (wall deadline, cancel-waits, exit-code-is-not-closure): the payload spawns a System32 non-Go grandchild, `cmd.exe /c "set /p x="`, whose stdin pipe's **write end it also inherits**, so it blocks until the Job ends regardless of the root's exit; the test observes it through Job accounting and the process-ID list. Use the same shape in the plain run, so no row's tree differs by build. Rows that need Go behavior in the grandchild (breakaway attempts, protected-target attempts, process-limit spawn) keep the Go grandchild; they pass under race today, and if one later fails the same way, it comes back here with the probe facts.

**8.4 What the race build is for.** `-race` instruments the host executor; the payload is instrumented only because it is the same binary. The payload rows are proved by the plain run, which the full check also runs (D127, D129). The evidence states this once.

**Requests:** none.

**Notes for S1 from this revision:**

26. Do not add a go build step to the tests (option a).
27. Two throwaway probes under race, one factor each, errors and Job accounting kept: (1) the row without JOB_OBJECT_LIMIT_JOB_MEMORY; (2) the grandchild as a direct child. One session; report both outcomes with the fix applied.
28. If limit-related: a //go:build race test constant raising JobCommitBytes for Go-grandchild rows; evidence notes the race runtime's commit as test overhead.
29. If not limit-related: for held-tree rows only (wall deadline, cancel-waits, exit-code-not-closure), spawn cmd.exe /c "set /p x=" as the grandchild with its own stdin write end inherited so it blocks until the Job ends; observe via Job accounting and the PID list; same shape in the plain run; Go grandchildren stay in behavior rows.
30. The receipt in the failing row was correct; only the test's fixture failed. Note in the evidence that -race proves the host executor and the plain run proves the payload rows.

---

# §0 (carried): Ruling on the gate analysis

The gate ruling of this file's first version stands unchanged: reading B controls (ticket 45 after C2; C3 integration and A2 qualification later); P1 reversed, P2–P4 upheld (P2 narrowed), P5 reversed; no owner question; tracker and close documents as its §5; «B-NEXT» with the reconciliation, the "Amended by" line under B28 item 9, and the one-sentence clarification of `docs/ROADMAP-CORE.md:930` and `:979` at the close. The PM keeps that text beneath this ruling in `local://t45-ruling.md`.

---

# Ruling: ticket 45 gate analysis (C10: run and positively close a restricted Windows process tree)

**Advisor:** build advisor (Claude Fable 5.1), under D117 (`docs/DECISIONS.md:1931-1935`). **Base:** `main` at ee798a5, read-only.
**Ruled on:** `local://t45-brief.md` §0 (DesignT45), with `local://t45-gate-supplement.md`, `local://t45-design-assignment.md`, the precedent `local://t59-ruling.md`, and the cited sources, which I read myself.

**Verdict on the brief: reject §0's verdict; adopt §0's trace.** **Gate verdict: buildable now**, all five criteria, with the deferrals in §3. P1 is reversed (reading B controls); P2, P3 and P4 are upheld, P2 narrowed; P5 falls with P1. No owner question is asked; no design approval exists yet (D117): the brief returns to the designer to complete §1 onward. Nothing here marks C10 Done, claims A2, or freezes anything.

## Owner summary

- Ticket 45 may start now. Its own gate is "after C2" (`issues/45-…:8,24`), as the capability graph, the board and the Core design say (`docs/ROADMAPS.md:83,180`; `docs/DESIGN-CORE-AND-LAUNCHERS.md:704`); C2 is Done (B28 item 9, `docs/DECISIONS.md:2248`).
- "C10 waits for C3" (`docs/ROADMAP-CORE.md:930,979`; B28 item 9) is the step's integration and A2-qualification wait, already carried by ticket 46 (`Blocked by: 18, 19, 45`, `issues/46-…:8`) and by C10's exit criterion (`docs/ROADMAP-CORE.md:960`). It is not a start gate for the standalone executor, and no document makes it one.
- Nothing ticket 45 consumes is unfrozen: C1's F0 and F2 families are frozen (`docs/CONTRACTS.md:25-27`). Everything else the gate names (OS adapter, request type, output channel, executor receipt, closure signal) is C10's own in-layer Go code, which is not a contract (D40 `docs/DECISIONS.md:206`; D45 `:276`; `docs/CONTRACTS.md:111,125`), exactly as C2's workspace service is for C3. No ticket produces a "C3 child/execution interface" because none is a contract; a gate cannot wait for a freeze that the rules forbid creating (`issues/45-…:18`).
- C3's lifetime seam (handles, quotas, grants, execution-failure signal) integrates at tickets 16 and 91; ticket 45 neither calls nor fakes it. Its caller is the ticket's own "real test processes".
- Ticket 45 writes no ledger record: Core's host is the sole writer (D26; `docs/ROADMAP-CORE.md:941`). Durable executor facts reach the ledger through C4's F4 (ticket 46) or C3's F3 (ticket 91) when those producers specify them.
- Defender stays on; the `git.exe` process exclusion touches no criterion; the evidence discloses it; no figure is capacity (B28 item 5 and Limits).
- `golang.org/x/sys` is already recorded for Core OS adapters (B11, `docs/DECISIONS.md:734`); a new `internal/core/...` package may import it (`tools/check/boundary.go:49-53`). No new module, no cgo (D28).
- The reconciliation is the build's, not the owner's: this ruling records it; ticket 45's B entry («B-NEXT») and an "Amended by" line under B28 land at the close (D116 item 3), with a one-sentence clarification of `ROADMAP-CORE.md:930` and `:979`. D27, D87 and D112 are untouched. The owner reads this ruling as he chooses (D117) and may reorder the schedule.

## 1. P1: the conflict, traced

**1.1 The texts.**

| For "start after C2" | For "wait for C3" |
|---|---|
| Ticket 45, owner-adopted decomposition (`issues/45-…:48`): `Blocked by: 07, 09` (`:8`); "Can begin with real test processes after C2; claims neither C3 integration nor A2 until later qualification" (`:24`); capability "independently usable Windows containment executor" (`:7`) | `docs/ROADMAP-CORE.md:930`: "C2 … and C3's Core-owned child/execution interface; implementation can begin only with owner-frozen relevant C1/B11 contracts" |
| `docs/ROADMAPS.md:83` `C2 --> C10`; board `:180` "C10 … C2 … Waiting" | `docs/ROADMAP-CORE.md:979`: "C10 … C2/C3 and OS/helper interfaces" |
| `docs/DESIGN-CORE-AND-LAUNCHERS.md:704`: "C10 … is a separate core track after C2"; "These phase groupings add no dependencies beyond `ROADMAPS.md`'s capability graph" | B28 item 9 (`docs/DECISIONS.md:2248`): "… and C10 for C3" |
| Tickets 45, 47, 49 and C3's first ticket 10 share `Blocked by: 07, 09` (`issues/10-…:8`; `issues/47-…:8`; `issues/49-…:8`); qualification tickets 46/48/50/51 wait on C4's adapters | D112 (`docs/DECISIONS.md:1545`): "C10, U3 and U4 keep their waits" (neutral: it changes no wait) |

**1.2 Reading A fails on its own terms; reading B satisfies every passage.**

(a) *The "owner-frozen relevant C1/B11 contracts" set.* C1's contracts that 45 touches are frozen: `ledger-format` F0 and F2-05…F2-09, `ledger-reader`, `ledger-appender` (`docs/CONTRACTS.md:25-27`). B11 is a B entry that records modules, boundaries and proposals; it names no contract and freezes none (`docs/DECISIONS.md:733-739`). The register holds six contracts and admits no seventh (`docs/CONTRACTS.md:7,111`; D40 `docs/DECISIONS.md:206`); the ticket forbids "new contract boundaries" (`issues/45-…:18`). So the remainder of the set is empty, and an empty remainder is satisfied, not broken. Reading A instead requires the PM to "allocate/specify" a producer for a contract that no document plans (brief §0.5) — that is inventing a contract, which the same rules forbid. The brief's own §0.3 table finds exactly this: "No freeze; no register home." Ticket 59 is the opposite case: it *consumed* unfrozen ledger families with named producers (`local://t59-ruling.md` §3.1). Ticket 45 consumes none.

(b) *"C3's Core-owned child/execution interface."* C3's deliverable is host-side lifetime — "Core-owned handles and strict quotas … Positive descendant quiescence is required before reuse … OS-specific proof remains C10" (`docs/ROADMAP-CORE.md:433`; Core §3.3 `docs/DESIGN-CORE-AND-LAUNCHERS.md:167`). That is a Core-internal seam between two Core steps, like C2's service API that C3 consumes without a freeze (`docs/CONTRACTS.md:125`). Which side starts first is a sequencing question that the owner-adopted ticket answers in its own words (`issues/45-…:24`), and the ticket pair 45→46 encodes the roadmap's "C2/C3" row: 45 after C2, 46 after C4's adapters (18, 19 ← 17 ← 16). Nothing in 45's five criteria calls a turn loop, a grant or a command receipt.

(c) *B28 item 9.* An assistant entry (`docs/DECISIONS.md:2208`), in a passage listing what C2's section defers to other steps. Its Changes line touched "the C2 and U3 rows" of the board (`:2260`) and left C10's row at "C2" in the same commit (`docs/ROADMAPS.md:180`); it carries no "Amended by" under D27, D87 or any C10 text. It restates `ROADMAP-CORE.md:930/979` and inherits their ambiguity; read in context it names the step's wait, beside "Linux and macOS runs wait for C3's CI". It cannot be the later, controlling statement over a board row it chose not to change.

(d) *D112.* "C10 … keep their waits" changes no wait. Reading B changes none either: the board row stays "C2" and the step's C3 wait stays for integration and qualification.

(e) *D41 and rule 5.* "Never write a stub or a fake of what the step waits for" (`docs/DECISIONS.md:213`; `docs/ROADMAPS.md:231`). Ticket 45 waits for nothing it would fake: the tests launch real test processes, which the ticket itself names as its start condition; the C3 seam is absent, not imitated. The test caller stands where C3's runtime will later stand, which is what "independently usable" means.

**Ruling: reading B.** Ticket 45 builds the Windows executor now, against real test processes; C3 integration (tickets 16, 91), C4 receipts and A2 qualification (ticket 46) come later. The brief's "Why choose A now?" rests on treating "no frozen interface exists" as "an unfrozen consumed interface exists"; the two are different, and only the second blocks.

**1.3 Whose reconciliation, and where.** The assistant's. Neither conflicting text is owner wording: `ROADMAP-CORE.md` C10's "Waits for" sentence came from the assistant's B11/B15/D96 consolidation, D27's and D87's content (mechanisms, the macOS slot) is untouched, and D112's approved text is C2's lines 278–417 (`docs/DECISIONS.md:1540`), not C10's. The record is:

1. this ruling, which under D117 ends the gate question for the build;
2. at ticket 45's close (D116 item 3, `docs/DECISIONS.md:1915`): one item in «B-NEXT» — "Ticket 45 began after C2 under its gate (`:24`); `ROADMAP-CORE.md` C10's C3 wait is the step's integration and qualification wait (tickets 16, 46, 91), and C10's in-layer interfaces are not contracts (D40, D45; the ruling, P1–P2)"; an "Amended by «B-NEXT»" line under B28 naming item 9's "C10 for C3"; in `docs/ROADMAP-CORE.md:930`, replace the sentence so that it states C2 as the executor's start gate and C3 as the integration/qualification wait, and that implementation builds only against frozen C1 contracts within B11's adapter boundary; the same clarification in the C10 row at `:979`.

`ROADMAPS.md` rule 6 does not force a B entry (no [PROPOSAL] mark), but D116 item 3 supplies one anyway. **Owner question: none.** No owner decision is amended; if the owner prefers the stricter sequencing, that is his scheduling, as ticket 59's ruling noted (`local://t59-ruling.md` §3.3).

## 2. Rulings on P2–P5

| Choice | Ruling |
|---|---|
| **P2** | **(c) upheld, narrowed to three classes.** (i) *In-layer Go API* — adapter, request type, output channel, receipt struct, closure/quarantine signal: C10 owns it, documents it in the package, and C3/C4 consume it as Core-internal code, as with C2's service (`docs/CONTRACTS.md:125`); no register row, no freeze, no D125 act. (ii) *Ledger record of executor facts:* none in ticket 45. No criterion needs one — AC5's "record" is evidence, AC4's "cannot publish" is a state the executor exposes to a later publisher, which is C4's (`docs/ROADMAP-CORE.md:955`). The first producer that needs a durable executor fact specifies it under `docs/CONTRACTS.md:34`: C4's attempt/evidence family at ticket 46 (`docs/CONTRACTS.md:40`; `issues/46-…:27`) or C3's execution-failure/service-loss family at ticket 91 (`docs/ROADMAP-CORE.md:427`); D125 freezes it with that slice. The brief's "possible additive `ledger-format` family" is not 45's; mint no F-number. (iii) *Durable per-run quarantine fence* (AC4 across supervisor loss): executor-private state under the run root, through `internal/core/durable`, a fence like C2's worktree registration — not a ledger, not a second authority store (`issues/45-…:18`); the full brief specifies it. |
| **P3** | **(c) upheld.** Real-time protection is on; the exclusion covers three `git.exe` files only (B28 item 5, `docs/DECISIONS.md:2236`). The test process is not Git, so AC5's start/stop/resource figures are "under Defender". AC2's Git denial is an access-control result, not a timing. Each measurement states the machine state verbatim and is build evidence, not capacity (B28 Limits, `:2257`; Core §3.5's no-exclusion rule). No machine change is requested. |
| **P4** | **(c) upheld.** D45's table and `tools/check/boundary.go:49-53` admit `golang.org/x/...` throughout `internal/core/...`; B11 limits `x/sys` to "Core OS adapters including B3's" (`docs/DECISIONS.md:734`), and a Windows containment adapter is one. `internal/core/durable/durable.go:2-3` ("the only package that imports golang.org/x/sys") becomes false; the first slice corrects that sentence. Not in `contract/...`. An API absent from `x/sys/windows` is reached by `windows.NewLazySystemDLL` procedure calls: still no cgo (D28, `docs/DECISIONS.md:110`), still no module (D29). The full brief names each Win32 API and its route. |
| **P5** | **(c) reversed as a consequence of P1.** The objection to option (b) was an unrecorded gate; §1.3 records it. The full brief designs the whole executor against all five criteria. Nothing primitive-only, no empty package, no raw probe counted as a criterion. |

## 3. Buildability by criterion

| Criterion | In ticket 45 now | Deferred, to |
|---|---|---|
| AC1 (`issues/45-…:28`) | Per-run AppContainer profile/SID and non-breakaway Job both active; authorized run-specific input from a test run root; bounded output channel to the Core-side caller | Input from C3 grants/body reads (tickets 11, 15); C4 subjects (17); R5 snapshots (52) |
| AC2 (`:29`) | Suspended launch, explicit inherited-handle allowlist, restrictions before resume, network denied; denial of every listed target | Nothing |
| AC3 (`:30`) | Real descendants, escape attempts, path/link/handle expansion refused | Nothing |
| AC4 (`:31`) | Cancellation, timeout and supervisor loss → positive tree exit before slot/root reuse; ambiguous stop → durable quarantine, no reuse, no automatic restart, result marked unpublishable | Publication itself (C4, BD2 `docs/ROADMAP-CORE.md:955`); service-loss recording (C3, ticket 91) |
| AC5 (`:32`) | Finite wall/CPU/memory/process/input/output profile (B11 `docs/DECISIONS.md:737`), fail-closed when unenforceable; start/stop/resource behavior recorded under Defender; no mechanism reported as the boundary | Capacity and the V6 matrix (ticket 46); any A2 label (`docs/ROADMAP-CORE.md:932`) |

Linux and macOS (tickets 47, 49), C3's CI, and the A2 claim are out of 45, as the brief's §0.4 last paragraph says; that paragraph stands.

## 4. What the full brief must add

Besides the assignment's list (owner summary, owned paths, behavior per criterion, real-machine tests, records, verification and slicing, choices):

1. **§0.1 and §0.4:** replace the verdict paragraph and the "Present disposition" column with a pointer to this ruling; the rest of §0 stands as the trace.
2. **The caller.** A Core-internal Go API that C3's runtime will later call; in 45 the tests call it. State the request (roots, authorized input files, handle allowlist, limit profile, deadline) and the result/receipt struct as package types, with no register row (P2 i).
3. **Protected targets in the tests.** Real where the producer exists: a Git repository built by real Git (as C2's fixtures), a real `internal/core/ledgerstore` colony and bodies. Representative where it does not: owner IPC (a test-created named pipe), credentials, private peers, sealed results — named as denial targets, with the sentence that their shape is irrelevant to the executor and only their reachability is tested. This is what separates them from ticket 59's "permissive substitute" (`local://t59-ruling.md` §1.4): nothing here feeds the executor's output.
4. **Host job and handles** (supplement §2, open item 4): how the per-run non-breakaway Job relates to the host job of Core §3.3 (`docs/DESIGN-CORE-AND-LAUNCHERS.md:167`) and which side retains handles (`docs/ROADMAP-CORE.md:433` vs `docs/DESIGN-CORE-AND-LAUNCHERS.md:987`); a numbered P-choice with its trace.
5. **AC4 across supervisor loss:** the durable quarantine fence (P2 iii), what a restarted host does with it, and the proof that no reuse or restart happens; crash-helper rows as in C2's crash matrix (B27 item 7, B28 item 7).
6. **Fail-closed table:** each limit, the Win32 control that enforces it, and the refusal when the control cannot be applied (profile creation, Job limit, capability SID).
7. **Tests:** per criterion, the plausible bug each fails on; no mocks; each under 60 s under race (B28 item 8); evidence states the Defender state (P3).
8. **Boundaries:** against ticket 46 (V6 matrix, C4 adapters, receipts), 47/49, C3 (grants, lifetime, service loss), R5 (B11 `docs/DECISIONS.md:737`).
9. **Measurements:** per-run start/stop/CPU/RAM/disk under Defender as evidence, not thresholds (D78 labelling as in B28's Evidence).
10. **Choices:** P1–P5 are settled by this ruling; new choices start at P6.

## 5. Tracker and documents (PM applies)

- **Now:** nothing. `Blocked by: 07, 09` stands and is satisfied; `Status: ready-for-agent` stays until the claim, which lands with the close (`docs/agents/issue-tracker.md:33`).
- **At the close, one documents commit (D116 items 3–5):** «B-NEXT» and the "Amended by" line under B28 (§1.3); `docs/ROADMAP-CORE.md:930` and `:979` clarified; C10's Status line (`docs/ROADMAP-CORE.md:961`) and board row (`docs/ROADMAPS.md:180`), same commit (D116 item 4): "In progress (ticket 45, Windows executor, <date>; C3 integration and A2 qualification wait for C3 and ticket 46; Linux and macOS executors are tickets 47 and 49)"; the board's "Waits for" column stays "C2"; a dated comment on ticket 45 pointing to this ruling. The brief and this ruling stay in `local://` until then.
- **Owner questions:** none now. Later, at their gates only: D29 if an API needs a module outside `x/sys` (P4); D52/D40 only if ticket 46's receipts change a frozen contract.

## 6. Findings on the brief

| # | Severity | Location | Problem | Change |
|---|---|---|---|---|
| F1 | major | `local://t45-brief.md` §0.1, §0.2 P1, §0.6 P1 | Selects reading A although §0.3 and §0.5 show the gate names no contract and no producer; conflates "no frozen interface exists" with "an unfrozen consumed interface exists". | Reversed (§1). Replace §0.1's verdict with a pointer to this ruling; continue to §1 onward. |
| F2 | major | §0.4 table | Every criterion marked "blocked by the same start gate"; a consequence of F1. | Replace the disposition column with §3. |
| F3 | minor | §0.3 receipt row; §0.5 third row; §0.6 P2 | Treats an additive `ledger-format` family as a possible home for 45's facts; no criterion needs a ledger record and C10 does not append. | Ruled P2; drop from 45's scope. |
| F4 | minor | §0.2 P1 "Reading A" | Treats B28 item 9 as the latest controlling statement; it left C10's board row at "C2" in the same commit. | §1.2(c); no edit beyond F1. |
| F5 | nit | §0.5 "Freeze authority" | Correctly withdraws the earlier "any C10 API can be D125-frozen" idea; keep that correction. | None. |

**Requests:** none.
