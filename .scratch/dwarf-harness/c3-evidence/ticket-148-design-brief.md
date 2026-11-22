# Ticket 148 design brief: recovery refusing a reused root process ID

Drafted 2026-11-21 by DesignT148 (drafter role, Claude Opus), standing in for the designer, whose provider budget is used up. A stand-in advisor rules on it (D117, D177; `docs/CURRENT-RULES.md:33`). Code base: `main` cee4a8a. Every `gitprocess_windows*.go` line below is in `internal/core/gitprocess/`. No repository file was changed.

Sources: the ticket (`.scratch/dwarf-harness/issues/148-stop-git-process-recovery-refusing-a-reused-process-id.md`, criteria :42-49); ClarifyT147a (`local://t147-s1-clarification.md`: cause :4, ruling item 2 :5, `notesForClose` :18-27); the publication verdict (`local://t148-docs-notes.md:13-15`); RulingT16S3R (`local://t16-s3r-ruling.md`: P3 :18, amendment 6 :70, amendment 10 :74, amendment 14 :78); `docs/CONTRACTS.md:210`; `docs/CURRENT-RULES.md`; Microsoft Learn, "NtQuerySystemInformation function (winternl.h)" (MS-NTQSI below).

## 0. Summary

- The defect is one branch: `waitRootGone` treats every `OpenProcess` error other than "no such process" as "not proven gone" (`gitprocess_windows.go:170-172`). A reused process ID held by a process that denies the caller therefore refuses a root that has already gone. The retirement hint is not read on this path, so hint-1 and hint-0 frames fail the same way.
- Recommended: option (a). Keep the opened-handle proof as it is. Only when the open fails, read one system process list (`NtQuerySystemInformation(SystemProcessInformation)`, already in `golang.org/x/sys` v0.48.0). The root counts as gone only if no entry has both the recorded PID and the recorded creation time.
- Deterministic regression rows need no new seam. A test-created, suspended process with a deny-all DACL holds the recorded PID, and the planted frame records a creation time 100 ns earlier than the holder's. One existing seam, `queryFault`, injects a failure of the list query.
- `UnconfirmedError.Error()` appends `: <cause>` when `Err` is set. No code or golden in the repository parses or holds the text.
- One slice in `internal/core/gitprocess`, seven rule breaks, no owner gate.

## 1. The defect, from the code

### 1.1 From a recorded frame to `root_unconfirmed` (hint 1 and hint 0 alike)

1. `workspace` opens the Owner and reconciles it before admitting any Git (`internal/core/workspace/service.go:187`, `:199-201`). `Owner.Reconcile` holds `o.mu` and runs `reconcileReservations` first (`owner.go:152-164`). It then runs standalone v1 fences through `o.reconcile`, which reaches the same `reconcileCandidate` (`owner.go:166-178`; `gitprocess_windows.go:253-255`).
2. `reconcileReservations` walks containers in UUID order and slots in stored order (`gitprocess_windows.go:1062-1077`). A recorded root is a nonzero frame, so `zero` is false (`:1078-1082`). A crashed root has no closed `.json`, so `readErr` is `os.ErrNotExist` (`:1083-1094`). Next comes `o.reconcileCandidate(ctx, f, false)` (`:1095`). **The footer hint `batch.data.Retired[i]` is not passed.** It is read only after success, to decide reporting (`:1106`), and rewritten only after success (`:1107-1115`).
3. `reconcileCandidate` takes these steps:
   - context check (`:260-262`);
   - `State` is `running`, not `closed` (`:263`);
   - session equal (`:264-267`);
   - `openJob(f.JobName)` fails with `ERROR_FILE_NOT_FOUND`, because the Job died with its last handle (`:268`, `:300`);
   - `reservedZero` is false (`:301-304`);
   - `State == "running"`, so `waitRootGone(ctx, f, o.options.StopGrace)` runs (`:305-306`);
   - any error becomes `fail("root_unconfirmed", err)` (`:307`), that is `&UnconfirmedError{RunID, "root_unconfirmed", err}` (`:259`; `types.go:97-99`).
4. `waitRootGone` (`gitprocess_windows.go:165-185`) does the following:
   - `OpenProcess(SYNCHRONIZE|PROCESS_QUERY_LIMITED_INFORMATION, f.RootPID)` (`:166`);
   - `ERROR_INVALID_PARAMETER` (no process has the ID) counts as gone (`:167-169`);
   - **any other error is returned as is (`:170-172`): this is the defect**;
   - otherwise `GetProcessTimes` (`:174-177`); a different creation time counts as gone (`:178-180`); the same process is polled until signalled, and `pollUntil` returns `ErrUnconfirmed` when the grace (default 5 s, `types.go:47-49`) expires (`:181-184`, `:186-207`).
5. On failure the frame is skipped: no hint is written and `processed` does not grow (`gitprocess_windows.go:1096-1098`). The container survives, because it is removed only when all 32 succeed (`:1122-1128`), and the joined error is returned (`:1130`). `workspace.Open` fails (`service.go:199-201`). Its deferred `Close` finds unreconciled reservations, retains the Owner and keeps the root lock in that process (`owner.go:199-203`; `doc.go:25-28`). `Run` refuses with `ErrUnconfirmed` while the container is loaded (`owner.go:122-126`).
6. The message is `git process closure unconfirmed: root_unconfirmed`. `Error()` formats only `ErrUnconfirmed` and `Reason` (`types.go:28`), even though `Unwrap` carries `Err` (`:29`). That is why the ticket-147 log could not show the errno (`t147-s1-clarification.md:4`, item 5).

**Hint 1 compared with hint 0.** The control flow is the same up to the refusal. A hint is set only after the live closure proof:
- an unproved closure retains the Owner and writes no hint (`gitprocess_windows.go:677-688`);
- the closed observation precedes `completeSlot`, which writes the byte (`:717-719`, `:976-977`, `:947-965`);
- reconcile writes it only after a frame succeeds (`:1107-1115`).

So a hint-1 frame's root had exited before the kill (ClarifyT147a cause (2)). A hint-0 frame means one of two things. Either the root was live at the kill, killed by `KILL_ON_JOB_CLOSE` when the crashed Core's Job handle closed (`doc.go:3`, `:39-41`), or a cached hint was lost (`doc.go:55-57`). In both cases its PID can be reused like any other. Standalone v1 running fences take the same path.

**A Windows restart.** Jobs do not survive it, so the name is absent. The new boot deals process IDs afresh. If the recorded session ID matches (`:264-267`), the root check runs against whatever now holds the PID. A low recorded PID may then belong to a long-lived system process the user cannot open, so the refusal persists for that boot [INFERENCE, as the ticket states at :23]. If the session ID differs, `session_mismatch` refuses by design (`doc.go:34-37`). That rule is unchanged and outside this ticket.

### 1.2 What the fix must keep

- Criterion 2 (ticket :43) requires `live-root` (`gitprocess_windows_test.go:769-791`, assertions `:812-832`) and `live-retired` (`:1711-1731`, assertions `:1790-1800`) to stay unweakened. Both plant a suspended root of our own, which the reconciling process can open.
- `live-retired` is RulingT16S3R's break "trust footer 1 to skip native proof -> planted live-root frame with hint 1 stays unconfirmed" (`t16-s3r-ruling.md:74`).
- The recovery table says "footer 1 frames are re-proved identically" (`:70`). P3 says "footer bytes are hints, not proof" (`:18`).

## 2. Options (the ticket ranks none; recommendation in 2.5)

The four failure modes are the same for each option: access denied, a process exiting mid-query, PID reuse within the query, and a Windows restart.

### 2.1 (a) Learn the holder's creation time without opening it

**Mechanism.** The opened-handle path stays exactly as it is (`:166-184`). When `OpenProcess` fails with anything except `ERROR_INVALID_PARAMETER`, take one system process list with `NtQuerySystemInformation(SystemProcessInformation)`. MS-NTQSI says it returns "one for each process running in the system". The verdict:
- **listed** if any entry has `UniqueProcessID == RootPID` and `CreateTime == RootCreated`: return the open error, which refuses as today;
- **gone** otherwise: return nil.

If the list cannot be taken, return `errors.Join(openErr, listErr)`, which also refuses.

**What it proves.** No live process has the recorded identity at the moment of the list. Process exit is irreversible, and a (PID, creation time) identity does not recur within a boot. So absence at one instant proves the root gone from then on. This is the same premise the code already uses for "different creation time means gone" (`:178-180`) and "no such PID means gone" (`:167-169`). MS-NTQSI itself names `CreateTime` as the field that detects `UniqueProcessId` reuse: `SequenceNumber` is "used to detect UniqueProcessId reuse (instead of process CreateTime)".

**Failure modes.**
- **Access denied.** The query checks no access on individual processes [INFERENCE]. `x/sys/windows/svc.IsWindowsService` (`svc/security.go:81-98`) calls it with no privilege setup. Low-integrity or AppContainer callers may be refused [INFERENCE]. A refused query refuses the root, which is no worse than today.
- **Exit mid-query.** An entry copied before its process exits is still listed. If it is our root, recovery refuses, which is the safe direction. If it is a foreign process, its creation time differs anyway.
- **PID reuse within the query.** Between the failed open and the list, the denying holder may exit and its PID be dealt again. Any new holder has another creation time, and our root's identity cannot reappear. If a non-atomic walk listed both an old and a new holder of one PID, the rule "any matching entry means listed" refuses [INFERENCE: the kernel frees a PID only when the old process object is deleted].
- **Windows restart.** Every post-boot process has a creation time later than any pre-boot record, so the root is gone as long as the session check passes.
- **Clock set back.** A false "listed" would need the same PID at the same 100 ns instant, which refuses: safe and negligible. A false "gone" for our own root cannot come from clock changes, because the creation time is fixed when the process is created [INFERENCE].
- **Layout risk.** `CreateTime` lies inside `BYTE Reserved1[48]` in Microsoft's published layout. "The other members of the structure are reserved", and the function "may be altered or unavailable in future versions of Windows" (MS-NTQSI). `x/sys` names the field (`types_windows.go:3219-3254`, `CreateTime` at :3226). If the field were misread, a foreign holder would still come out "gone", which is correct. An unopenable root of our own could wrongly come out "gone". Two mitigations apply:
  - P-a2: a self-check on every list. The current process's entry must exist and its `CreateTime` must equal `GetProcessTimes(CurrentProcess())`; otherwise recovery refuses. This turns a layout change into a refusal.
  - Row `own-denied` (§3): it compares the list with `GetProcessTimes` for a real process on every hosted Windows image.

**A live root of our own.** If it can be opened, it is waited for and then refused, unchanged: `live-root` and `live-retired` never reach the fallback. If it cannot be opened (an account or elevation change between the crashed Core and its successor [INFERENCE]), it is listed and refused immediately with its open error, exactly as today.
- Sub-choice P-a1, recommended: one list, no waiting.
- Alternative: poll the list within `StopGrace` through `pollUntil`, at a cost of up to about 5 s of back-to-back lists in that rare path.

**Dependency.** None new. `windows.NtQuerySystemInformation` (`zsyscall_windows.go:3778`), `SYSTEM_PROCESS_INFORMATION`, `SystemProcessInformation` (`types_windows.go:3263`) and `STATUS_INFO_LENGTH_MISMATCH` (used at `svc/security.go:87`) are in `golang.org/x/sys` v0.48.0 (`go.mod:13`). `gitprocess` is an admitted x/sys importer (`docs/CURRENT-RULES.md:49`; `tools/check/boundary.go:80`; D29, D168).

**Criteria fit.** Criteria 1-3 are met for every hint and for standalone fences. The hint rule in `doc.go:68-70` stays. Production cost: nothing on the normal path. On the failure path, one list per failing frame, at most 32 per container.

### 2.2 (b) A retired (hint-1) frame needs no process-ID proof

**Mechanism.** On the `name_absent` branch, a frame with `Retired[i] == 1` skips `waitRootGone`. A retained Job is still verified, terminated and proved zero.

**Amendment.** In `doc.go:68-70`, "a valid running frame takes the running/root-identity proof even when its retirement hint is one. Hints suppress duplicate reports, not native proof." would become roughly: "a valid running frame with hint zero takes the root-identity proof; a hint of one, written only after that root's live closure proof, stands in for it when the Job name is absent." The residual at `:71-73` would narrow to hint-0 frames. It would also supersede RulingT16S3R amendment 6, "footer 1 frames are re-proved identically" (`:70`), and amendment 10's break (`:74`).

**What it proves.** Nothing native at recovery. It trusts a cached, unflushed byte (`doc.go:55-57`) whose only guarantee is the write order in `:717-719` and `:976-977`.

**Risks.**
- The byte becomes authority. A torn or stray write, or a future change that writes it early, admits Git beside a live root. Today the native re-proof catches such a defect. T16 has a break for the early write, "write the hint before proof -> ProvenClosureCrash" (`:74`), but none for a corrupted byte.
- It turns `live-retired` red by construction: that row is the T16 break itself. Criterion 2 (:43) and criterion 4 (:45, "no existing rule-break row is deleted or weakened") forbid that.
- It leaves hint-0 frames and standalone fences refused. That covers a root live at a kill and every post-restart reuse of a low PID, so criterion 1 (:42) fails for them. This is the publication verdict's remark (`t148-docs-notes.md:15`).

**Failure modes.** Access denied, exit mid-query and PID reuse are moot for hint 1 and unchanged for hint 0. On a restart, the hint-0 refusal persists for the boot.

**A live root of our own.** Hint 0 is unchanged. Hint 1 (a state that cannot arise, as planted by `live-retired`) would be treated as gone. No dependency.

### 2.3 (c) Access denied means "not ours"

**Mechanism.** `ERROR_ACCESS_DENIED` from `OpenProcess` counts as gone. The reasoning is that the package's roots are created by the reconciling account under its default DACL.

**What it proves.** Nothing about the holder. It is an assumption about who can open our roots.

**Failure modes.**
- **Access denied.** Our own live root wrongly counts as gone whenever it denies the successor. That happens when the account or elevation differs between the crashed Core and the new one [INFERENCE: an elevated token's default DACL grants Administrators, which the filtered token has only as deny-only]. Git is then admitted beside a live Git, which is the hazard the root check exists to prevent.
- **Exit mid-query and PID reuse.** These are handled for denying holders only. Other errors (quota, invalid handle) still refuse.
- **Restart.** Handled if the holder denies.

**A live root of our own.** If it can be opened, it is waited for as today. If it cannot, it is unsafely treated as gone. No dependency. Row `own-denied` fails this option (break B2).

### 2.4 (d) Boot-time bound

**Mechanism.** A record whose `RootCreated` precedes the current boot counts as gone. Boot time comes from `SystemTimeOfDayInformation` or from now minus `GetTickCount64`.

**Assessment.** It covers only the restart case, not the same-boot reuse that was observed (`t147-s1-clarification.md:4`, item 7), so criterion 1 fails. Clock adjustments blur the bound. It adds nothing once (a) holds. It would need no new dependency.

**Also rejected, in one line each:**
- Opening with `PROCESS_QUERY_LIMITED_INFORMATION` alone narrows the exposure only for holders that deny `SYNCHRONIZE`; the deny-all row stays red.
- Toolhelp `PROCESSENTRY32` has no creation time.
- `SystemBasicProcessInformation`'s `SequenceNumber` is available only from Windows 11 26100.4770 (MS-NTQSI) and would change the frame format.
- WMI `Win32_Process` means COM machinery for one field.

### 2.5 Recommendation

Choose (a) with P-a1 (one list, no waiting) and P-a2 (the self-check):
- it is the only option that meets criteria 1-3 for hint-1 frames, hint-0 frames, standalone fences and restarts;
- it keeps RulingT16S3R's hint rule and both live rows untouched;
- it leans on the reserved field only after the documented handle path has already failed, and P-a2 turns any misread of that field into a refusal.

Implementation notes for the coder:
- `waitRootGone` becomes an Owner method so that it can read `o.queryFault` and `o.options.StopGrace`.
- The list helper allocates a `[]uint64` buffer of the returned length plus a margin. It retries `STATUS_INFO_LENGTH_MISMATCH` a fixed small number of times (exhaustion refuses). It walks `NextEntryOffset` with `unsafe.Add`, bounds-checks each entry against the buffer, and compares `entry.UniqueProcessID == uintptr(pid)` and `uint64(entry.CreateTime) == created`.
- A `GetProcessTimes` failure after a successful open (`:174-177`) still refuses unchanged. A handle granted `PROCESS_QUERY_LIMITED_INFORMATION` should not fail there [INFERENCE].

`doc.go` changes for (a):
- `:35-37` gains one sentence: "gone" is "no such PID", a different creation time on the opened process, or, when the open fails, no entry with both the recorded PID and creation time in one system process list; a listed identity that cannot be opened refuses.
- In `:71-73`, the clause "widening the ACCESS_DENIED unconfirmed exposure to at most 32 roots per live container" becomes the remaining residual: an unopenable root of the package's own, or a failed or self-inconsistent list, refuses. The list's creation-time member is reserved in Microsoft's published layout and is checked against the current process's own entry.
- `:68-70` is unchanged.

## 3. Regression rows, made deterministic

**Seam.** No new seam is needed for the fixture. The package already denies a native object with `windows.SecurityDescriptorFromString("D:P(D;;GA;;;WD)")` plus `SetSecurityInfo(…, SE_KERNEL_OBJECT, DACL_SECURITY_INFORMATION, …)` and a control open that must fail with `ERROR_ACCESS_DENIED` (`gitprocess_windows_test.go:737-759`, `:1691-1709`). The rows apply the same steps to a process handle. Frames are planted as `live-retired` plants them: `fixtureSlots` (`fence_windows_test.go:234-247`), `encodeSlots` and `writeMarkerBytes` (`gitprocess_windows_test.go:1744-1751`). The single injected fault reuses the existing `queryFault` seam (`gitprocess_windows.go:26`, nil in production, `:24`; used today at `:283-287` and by the `query` rows at test `:764`, `:1765-1767`). It is consulted once, immediately before the list query.

**Holder.** The holder is created as in `live-retired` (`:1711-1730`): `createJob` under an unrecorded name, then `newPipes` and `createSuspended`. The process stays suspended, so it cannot exit, and the test holds `pi.Process`, so its PID cannot be reused during the row. That removes any dependence on timing. The test owns the process object and holds the full-access handle `CreateProcess` returned, so it can write the DACL without admin rights. An elevated token's `SeDebugPrivilege` is present but not enabled [INFERENCE]. The Job deny rows already pass on the hosted Windows runner with the same technique. If the control open succeeds anywhere, the row fails at "deny DACL control failed": it never passes vacuously and is never skipped.

**Reuse without recycling.** The package defines a root as the pair (PID, creation time) (`doc.go:35-37`, `:51`; `gitprocess_windows.go:178-180`). A frame recording the holder's PID with `RootCreated = created - 1`, 100 ns earlier, is byte for byte the state the kernel leaves after recycling: the recorded root predates the current holder. `-1` is the nearest distinct identity, so a comparison that loses precision also turns red.

New test `TestGitProcessRootReuse` in `gitprocess_windows_test.go`, `t.Parallel`, `StopGrace` 20 ms as in the sibling rows:

| Row | Frame | Before the fix | After the fix: assertion |
|---|---|---|---|
| `foreign-denied-retired` (criterion 3) | holder PID, `created-1`, hint 1 | `root_unconfirmed`, cause `ERROR_ACCESS_DENIED` | `err == nil`; `Reservations == 0`; `Pending` and `Closed` empty (hint 1 is not reported, `:1106`); container gone; holder still live (`WaitForSingleObject(pi.Process, 0) == WAIT_TIMEOUT`); a fresh `Run` is admitted |
| `foreign-denied-live` (hint 0, criterion 1) | as above, hint 0 | same red | `err == nil`; `Closed` holds exactly one row with that `RunID` and `Proof == "name_absent"`; `Reservations == 0`; holder live |
| `own-denied` (safety) | holder PID, exact `created`, hint 0 | refuses today; only the message assertion is red until §4 lands | refuses: `errors.As` gives `Reason == "root_unconfirmed"` and `errors.Is(err, ERROR_ACCESS_DENIED)`; `err.Error()` contains `"root_unconfirmed: " + ERROR_ACCESS_DENIED.Error()`; container bytes unchanged; `Run` refuses with `ErrUnconfirmed`. Then the row restores the holder's captured original DACL, terminates its Job and calls `assertExited`; a new `Reconcile` returns one `name_absent` row. This removes the cause, so it is not a retry (criterion 7) |
| `snapshot-fault` | as `foreign-denied-retired`; `queryFault` returns `ERROR_INVALID_HANDLE` | refuses (open error) | refuses: `root_unconfirmed`, `errors.Is` for both `ERROR_INVALID_HANDLE` and `ERROR_ACCESS_DENIED`; bytes unchanged; then `queryFault = nil` and `Reconcile` succeeds |

New portable test `TestGitProcessUnconfirmedMessage` in `fence_test.go`, which runs on all three systems:
- `(&UnconfirmedError{Reason: "cleanup_failed"}).Error()` equals `git process closure unconfirmed: cleanup_failed`;
- with `Err: errors.New("cause")` it equals `…: cleanup_failed: cause`.

The red of the two `foreign-denied` rows is the defect. Their fatal message prints `unconfirmed.Reason` and `unconfirmed.Err` through `errors.As`, so the red names its cause even on the unchanged `Error()`.

A Windows restart cannot be staged in a test. It reduces to the same state, a recorded PID held by a later-created process, so the `foreign-denied` rows cover it [INFERENCE].

## 4. `UnconfirmedError.Error()`

**Change.** If `e.Err == nil`, keep `fmt.Sprintf("%s: %s", ErrUnconfirmed, e.Reason)`. Otherwise use `fmt.Sprintf("%s: %s: %v", ErrUnconfirmed, e.Reason, e.Err)`. `Unwrap` (`types.go:29`) and the `Reason` strings are unchanged. Joined causes print on several lines.

**Consumers of the text** (repository search for `closure unconfirmed`, `UnconfirmedError`, `gitprocess.ErrUnconfirmed`, `.Error()` and `.Detail` in `internal`, `cmd` and `contract`):

| Consumer | Use | Effect |
|---|---|---|
| `internal/core/workspace/git.go:135-137` | `GitError.Stderr` falls back to `err.Error()` when Git wrote no stderr; printed by `errors.go:55-56` | Run-time unconfirmed errors now show their cause; `errors.go:46`: "Error text is not an API" |
| `internal/core/workspace/finalize.go:313-316`, `:334`; `mergeback.go:1006` | `UnavailableError.Detail` from an effect error's text | same; in-memory error values, not records |
| `cmd/dwarf-harness/main.go:71`, `:208-236` | prints fixed text only; `describe` never prints a wrapped error's text | none; `integrated_restart_test.go:86-94` keeps asserting fixed text and no error value |
| `internal/core/gitprocess/gitprocess_windows_test.go:439-440` | asserts the `Reason` field, not text | none |
| test logs (`%v` in fatal messages) | diagnostics | gain the cause, which is the point |

**Goldens and frozen records: none hold it.** The search found the text only in `types.go:14` and `:28`. `process_unconfirmed` in `contract/ledger` (`service_loss.go:74`, `:115`; `testdata/f3/91/log/…`; `docs/CONTRACTS.md:240`) is a separate cause code, and no raw error enters a cause. Fence and frame JSON hold no error text (`fence.go:24-36`).

## 5. Rule breaks (D152; `docs/CURRENT-RULES.md:17`)

Each break must be red at its named assertion, then green after a byte-identical restore. Record the original, mutant and restored SHA-256, the diff, the firing assertion and the logs. An undetected mutant is reported as ineffective (RulingT16S3R practice, `:74`). RulingT16S3R's breaks stay; no row is deleted or weakened.

| # | Mutant | Row: assertion that must go red |
|---|---|---|
| B1 | own live root treated as gone: return nil after a successful open without the wait (`:181-184`) | `FenceErrors/live-root`: `:813` "accepted without exact proof"; `SlotErrors/native/live-retired`: `:1791` |
| B2 | open failure taken as proof: `ERROR_ACCESS_DENIED` means gone (option c) | `RootReuse/own-denied`: first-`Reconcile` refusal assertion |
| B3 | reused ID still refused: fallback removed (today's `return err` at `:170-172`) | `RootReuse/foreign-denied-retired` and `/foreign-denied-live`: `err == nil`; red shows `root_unconfirmed` with cause `ERROR_ACCESS_DENIED` (also the criterion-3 before-fix red) |
| B4 | the hint-0 path: fallback, or proof skip, only when `Retired[i] == 1` (option b shape) | `RootReuse/foreign-denied-live`: `err == nil` and the one `name_absent` row; for the proof-skip form, also `live-retired` at `:1791` |
| B5 | a failed list taken as absence | `RootReuse/snapshot-fault`: refusal assertion |
| B6 | creation time compared on a wrong or truncated field (for example `UserTime`, or milliseconds) | `RootReuse/own-denied` refusal (false gone), or `foreign-denied-*` (false listed) |
| B7 | message without its cause (restore `types.go:28`) | `RootReuse/own-denied`: the `err.Error()` contains assertion; `TestGitProcessUnconfirmedMessage` cause row |

The P-a2 self-check has no row: no deterministic row can make it fire on a correct Windows. It is review-verified, and its mutant is reported as ineffective if run.

## 6. Slice

**One slice, S1**, on `main` cee4a8a (or later), in a worktree.
- **Owned:** `internal/core/gitprocess/gitprocess_windows.go` (`waitRootGone` as an Owner method, the list helper), `types.go` (`Error()` only), `doc.go` (§2.5 sentences only), `gitprocess_windows_test.go` (`TestGitProcessRootReuse`), `fence_test.go` (`TestGitProcessUnconfirmedMessage`).
- **Not owned:** `fence.go`, `slots.go` and every format; `owner.go`; `workspace`; `agents`; `cmd`; `tools/check`; `.github`; `go.mod`/`go.sum`.

**Acceptance** maps to criteria 1-8 (ticket :42-49):
- the four new rows and the message row are green;
- the `foreign-denied` rows were red before the fix (B3 evidence);
- `live-root` and `live-retired` are byte-unchanged and green;
- B1-B7 are each red at the named assertion and green after restore;
- no format, golden or frozen record changes;
- no retry, skip or limit change;
- the exact-SHA hosted check is green on Windows, Linux and macOS in the tests and race steps (D133, D153; `docs/CURRENT-RULES.md:18`, `:22`).

**Commands** (`GOTOOLCHAIN=local GOFLAGS=` on every line):
1. `CGO_ENABLED=0 go test -count=1 -v -run '^TestGitProcess(RootReuse|FenceErrors|SlotErrors|UnconfirmedMessage)$' ./internal/core/gitprocess` (focused; also each break's red and green)
2. `CGO_ENABLED=0 go test -count=1 -v -timeout 30m ./internal/core/gitprocess` (whole package; 32.3 s at T16 S3 fix 3, `local://t16-docs-notes.md:778`)
3. `CGO_ENABLED=1 CC=<pinned llvm-mingw clang> go test -race -count=1 -timeout 30m ./internal/core/gitprocess` (38.9 s, same source)
4. `CGO_ENABLED=1 CC=<pinned llvm-mingw clang> go test -race -count=20 -timeout 30m -run '^TestGitProcess(RootReuse|FenceErrors|SlotErrors)$' ./internal/core/gitprocess`. The change touches no shared state, so D152 (`docs/CURRENT-RULES.md:16`) does not require this run; it is evidence for criterion 3's "deterministic".
5. `gofmt -l` on changed files; host `go vet` and `staticcheck`; `go mod tidy -diff`; `CGO_ENABLED=0 go test -count=1 -run '^TestImportBoundary$' ./tools/check`. Build constraints are unchanged, so no five-target run (`:15`). No fuzz target changes; the `FuzzGitProcessFence` and `FuzzGitProcessSlots` seeds run in command 2 (`:17`).
6. PM: push the build branch; exact-SHA Check result; no rerun of a red run (D153).

**Expected cost** [INFERENCE]: about 60-100 product lines and 180-220 test lines; local runs plus seven breaks take about 15-25 min; one hosted check. If a hosted red is a `foreign-denied` or `own-denied` control failure (the denial not holding on the runner), the slice returns to the advisor, never to a skip.

## 7. Owner gates

**None.**
- Contract: fence and root-identity files are outside the F3-16 freeze (`docs/CONTRACTS.md:210`), and no format changes at all.
- Dependency: none new (`go.mod:13`; `docs/CURRENT-RULES.md:39`, `:49`).
- `.github` and `tools/check`: untouched.
- Owner decision: none. Option (a) keeps RulingT16S3R's hint rule, which listed no owner gates (`t16-s3r-ruling.md:111`).
- If the ruling chose (b), it would amend an advisor ruling, not an owner decision [INFERENCE], but it would break criteria 1, 2 and 4.

## 8. Drafter's report

- **P1. Defect location: `gitprocess_windows.go:170-172`.** The hint is not read before the refusal (`:1095` compared with `:1106-1115`). Sources: §1.1 citations; ClarifyT147a cause (3) and (5).
- **P2. Recommend (a), open first, list as fallback.** Sources: the ticket (:21-23); MS-NTQSI (process list, `CreateTime` as the reuse discriminator, the reserved-member warning); `x/sys` v0.48.0 `types_windows.go:3219-3263`, `zsyscall_windows.go:3778`, `svc/security.go:81-98`.
- **P3. (b) conflicts with criteria 2 and 4 by construction.** `live-retired` is RulingT16S3R's break against it. Sources: `t16-s3r-ruling.md:70`, `:74`; ticket :43, :45.
- **P4. P-a1: no waiting for an unopenable listed root.** It keeps today's immediate refusal for that case; polling is offered as the alternative.
- **P5. P-a2: self-check against the current process's own entry.** It converts the reserved-field risk into a refusal. There is no row for it (§5).
- **P6. Fixture: a suspended, DACL-denied holder with `RootCreated = created - 1`.** No new seam; `queryFault` for the list fault. Sources: test `:737-759`, `:1691-1731`, `:764`.
- **P7. A hint-0 row (`foreign-denied-live`) even though (a) treats hints alike.** It is what turns a hint-keyed implementation red. Source: `t148-docs-notes.md:15`.
- **P8. The message row is put in `fence_test.go`, an existing portable file,** rather than a new `types_test.go`.

**Not settled:**
1. Whether an exited process with open handles still appears in `SystemProcessInformation`. Either answer is safe; the `own-denied` second phase restores the DACL so that it does not depend on it.
2. Whether low-integrity callers are refused the list.
3. The original ticket-147 errno stays [INFERENCE]. The regression row reproduces the mechanism, not that run (`notesForClose` :20).
4. D145: row names, `doc.go` text and commit messages must carry no PID, path or machine detail.
