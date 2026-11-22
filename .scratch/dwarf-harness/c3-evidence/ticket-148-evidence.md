# Ticket 148 evidence

The [design brief](ticket-148-design-brief.md) is retained verbatim; the [stand-in ruling](ticket-148-design-ruling.md) governs its amendments. Ticket 148's Answer and `internal/core/gitprocess/doc.go` say what was built: after an open failure other than "no such process", one accepted system process list decides whether a recorded Git root is gone, and every misread refuses. No contract, format or record changed, so no contract-register change or decision entry is required (D161). Every review and ruling of this ticket was a temporary Claude Opus 5.5 stand-in for the held advisor (D177); Fable audits the whole ticket after its reset (D160). `S1/` and `CI/` below are the folders named under Raw evidence references. Sources: `local://t148-ruling.md:5-8,64,77-80`; `local://t148-docs-notes.md:29-32`.

## Design and ruling

DesignT148 wrote the brief (13m43s; SHA-256 182c8fa5141e0faae8243b359919395d76facd69c9effccfa194dd83d33a2e14) in the drafter role on Claude Opus 5.5, because the designer role's Codex budget was used up. It recommended option (a): when the open fails, a process list from `NtQuerySystemInformation`, already in `golang.org/x/sys` v0.48.0, with a self-check guarding the reserved creation-time field; four new rows using a suspended, access-denying holder and no new seam; seven breaks; `: <cause>` appended to `UnconfirmedError`'s message; one slice; no owner gate.

RuleT148, a temporary Claude Opus 5.5 stand-in for the held advisor (10m28s, $2.71; SHA-256 895f967c0452313bec1c9d1d782a658059e853b4c2a6ea01fffcae7b65819b48), ruled option (a) with three amendments and no owner gate, originator assistant: a bad walk refuses and never ends the list quietly; a new `list-guards` row gives the self-check and the walk bound real breaks (B8, B9); and the hosted denial precondition is a stop condition with a test-only token remedy ruled in advance. Only four outcomes count as gone, and a list is accepted only with success within a fixed retry count, a complete walk, the bounds held and the self-check passed; no Reason value or exported identifier is added. It rejected (b), a set hint as proof, which misses hint-0 roots and standalone fences and turns `live-retired` red; (c), any other open error as gone, which could run Git beside a live root of the package's own (caught by B2); and (d), restart-only, which misses reuse within one boot. One slice, B1–B9, and a twentyfold race run of `TestGitProcessRootReuse`. Sources: `local://t148-docs-notes.md:23-32`; `local://t148-ruling.md:5-8,19,28-46,51,56-58`.

## Slice, fix and integration

| Change / coder | Commit / base | Stand-in review | Exact-SHA hosted check / merge |
|---|---|---|---|
| S1 — the fallback in `waitRootGone`, `systemProcesses` and the pure `scanProcesses`, `UnconfirmedError.Error()`, the ruled `doc.go` sentences, `TestGitProcessRootReuse` (five rows) and `TestGitProcessUnconfirmedMessage`; CoderT148S1, `coder-claude`, Claude Opus 5.5, 36m6s | 56134c2 on cee4a8a, rebased onto `main` 9f703de as f16ddd496038bf5fe40044ffebd30634e5f88ce2 (`range-diff` `=`; blobs equal `finalHashes`); 5 files; pushed 2026-11-21 18:52:35 EST | StandInT148S1 (8m7s, $2.84): approve, no blocking, effective only on a green check 129 | Check 129 (run 44963925728): failure on Windows, success on Linux and macOS |
| Fix 1 — test only: the `undebugged(fn)` helper inside `TestGitProcessRootReuse`; CoderT148S1 revived, 40m26s | 59e75882bf86642e9a4670654ad896501f57a942 on f16ddd4; 1 file; production files unchanged; pushed 21:12:40 EST | StandInT148Fix1 (3m43s, $1.14): approve, no blocking; the short review the ruling required | Check 130 (run 44975034985): success on all three systems, attempt 1 (Windows job 02:13:15→02:55:15Z, Linux to 02:28:40Z, macOS to 02:40:43Z on 2026-11-22 UTC); `main` 9f703de → 59e7588 (fast-forward: f16ddd4, 59e7588), pushed, `ls-remote` equal |

PM checks: after S1, the status listed exactly the five owned paths, their hashes equalled the coder's `finalHashes`, and no file had CR; after fix 1, the status listed one path, the test file equalled `finalHashes` and the production files were unchanged from f16ddd4. Final SHA-256: `gitprocess_windows.go` `330ccdce40b725f8515eb5cd1879901e290cf2294307d36abe0cf9bf7d911273`, `types.go` `2368080bbdbb568c31b4f4dde3c2fbe1fa795b055cb0af313aae45e65b14b1da`, `doc.go` `a454d825103bc8d6dd7a19d6dfb777decaf663f050276700424892947f028ddb`, `fence_test.go` `924d4b45e2109976b5ad91715b7e0f1f63c0df2a7f46669d5bacca596d547d76`, `gitprocess_windows_test.go` `539b97008055862dfe56f0ace1e4756138f7bc32804d2495392bf7330129039c` after S1 and `bafa9a4b8c6ce3146f85e1c03275dcf026ad1fccf6e1d16784321095c1dc3e03` after fix 1. Sources: `local://t148-docs-notes.md:33,36-44,60-71`; `S1/yield.json:64-70`; `S1/fix-1/yield.json:2,50-54`.

**Check 129.** `TestGitProcessRootReuse` failed in both the tests step and the race step (steps of 1,611.1 s and 1,596.6 s; the package failed in 50.4 s and 72.0 s); every row (`own-denied`, `foreign-denied-live`, `foreign-denied-retired`, `snapshot-fault`, `list-guards`) stopped at `gitprocess_windows_test.go:2104`: `deny DACL control failed: <nil>; SeDebugPrivilege enabled: true` (`CI/2_Check _ windows-amd64.txt:487-499`). That is the ruling's first stop condition, ruled in advance; the run was not rerun (D153), and the PM sent the remedy to the revived coder. Sources: `local://t148-docs-notes.md:50-59`; `local://t148-ruling.md:57`.

**Fix 1.** On an OS-thread-locked goroutine, `undebugged(fn)` duplicates the process token (`DuplicateTokenEx`, impersonation level), removes SeDebugPrivilege with `SE_PRIVILEGE_REMOVED`, sets it as the thread token, runs `fn` and calls `RevertToSelf` on every path before unlocking; a failed revert leaves the goroutine locked, so the runtime discards the thread, and no `t` method runs inside. It wraps the control open, every Reconcile (the first in four rows, and the second in `own-denied` and `snapshot-fault`) and one extra privilege read for the diagnostic, unconditionally on every image. The bypass could not be demonstrated locally (the DEMO overlay passed); check 130 is its first proof. Sources: `S1/fix-1/yield.json:3,5,7-12,40-47`; `local://t148-fix-1-review.md:15-24`.

## Proof runs and rule breaks

All final runs exited 0. S1: focused 6.8 s; plain package 18.5 s (one designed skip, `TestGitProcessUnsupported`); race 45.5 s; `TestGitProcessRootReuse` race ×20 23.0 s, 20 of 20 (100 row passes); gofmt, vet, staticcheck, `go mod tidy -diff` and `TestImportBoundary` (50.8 s) passed; production imports unchanged, test imports exactly `+unsafe`. Fix 1: focused 3.5 s; plain package 13.2 s; race 30.4 s; race ×20 6.9 s, 20 of 20; imports unchanged. These are run durations, not a measurement. Sources: `S1/yield.json:9-23`; `S1/fix-1/yield.json:13-24`.

| Break | Change | Red (`gitprocess_windows_test.go`, S1 line / fix 1 line) |
|---|---|---|
| B1 | equal creation time accepted without waiting | `FenceErrors/live-root` :815; `SlotErrors/native/live-retired` :1793 (both runs) |
| B2 | any other open error is gone, no list | `own-denied` first refusal :2216 / :2267; also `snapshot-fault` :2234 / :2285 |
| B3 | fallback removed (the pre-fix `return err`) | `foreign-denied-retired`, `foreign-denied-live` `err == nil` :2204 / :2255, `root_unconfirmed` with Access is denied; also `snapshot-fault` :2234 / :2285 |
| B4a | fallback only for hint 1 | `foreign-denied-live` :2204 / :2255 |
| B4b | proof skipped for hint 1 | `foreign-denied-live` :2204 / :2255; `SlotErrors/native/live-retired` :1793; also `snapshot-fault` :2234 / :2285 |
| B5 | failed list read as absence | `snapshot-fault` :2234 / :2285 |
| B6a | match on UserTime | `own-denied` :2216 / :2267 (false gone); `list-guards` controls :2147 / :2190 |
| B6b | creation time truncated to milliseconds | foreign rows :2204 / :2255 (false listed); `snapshot-fault` :2241 / :2292 |
| B6c | process ID alone | as B6b |
| B7 | message without its cause | `own-denied` :2219 / :2270; `fence_test.go:97` |
| B8 | self-check removed | `list-guards/self-absent`, `/self-time-mismatched` :2147 / :2190 |
| B9 | bound violations end the walk | `list-guards/cut` :2147 / :2190 (false absent); also `/short-link` |

Each break ran separately; every restoration's SHA-256 equalled the original (`gitprocess_windows.go` 330ccdce…, `types.go` 2368080b… for B7), and each restored row passed. The mutant hashes and diffs are in the yields and `breaks/<id>/`. Red before the fix (criterion 3): B3, and a TODAY overlay (B3 plus the pre-fix `Error()`), whose message was only `git process closure unconfirmed: root_unconfirmed` while `errors.As` showed the same reason and cause. Sources: `S1/yield.json:36-49`; `S1/fix-1/yield.json:26-38`; `local://t148-s1-review.md:35`; `local://t148-fix-1-review.md:24`.

## Deviations

Accepted by StandInT148S1, and recorded as its close notes ask:
- `list-guards` has seven cases, not the three ruled refusals: the two controls, `self-absent`, `self-time-mismatched` and `cut`, plus `short-link` (the ruled link bound) and `past-buffer`, which covers a scan guard the coder added: a returned length past the buffer refuses. It can only refuse and keeps every read inside the buffer.
- `own-denied`'s first refusal expects exactly one Pending run, not none: hint-0 frames are pending by design (`fence.go:374-376`). Pending is empty after every successful Reconcile.
- Answer 2's grace split: the first race ×20 was red in 2 of 20 (`foreign-denied-retired`, `foreign-denied-live`) at `assertFreshSlotRun` (`closure_unconfirmed`, `TotalProcesses 2`) under the rows' 20-ms grace, while recovery was green. Every Reconcile keeps 20 ms and the Owner's default grace is restored only before the fresh-Run check; the rerun was 20 of 20, after the whole final sequence restarted.
- Test-only `+unsafe` (answer 1), used only in `list-guards`' synthesized buffer; the diagnostic decodes the token's privileges by hand from a byte slice, without `unsafe`.
- B6b's overlay blind spot: when the holder's creation time is an exact millisecond (about 1 run in 10,000), `created-1` falls in the previous millisecond and the overlay stays green. It is a limit of the overlay, not of the product; B6a and B6c fail every run.
- Smaller: the race ×20 ran with `-v`; the fresh Run is also checked in `foreign-denied-live` and the holder-live check also runs in `snapshot-fault`; fix 1's only call beyond the ruling's list is the privilege read for the diagnostic.

Sources: `S1/yield.json:51-62`; `S1/fix-1/yield.json:44-48`; `local://t148-s1-review.md:12,21-22`.

## PM decisions

1. **Answer 1:** test-only `+unsafe` approved for `list-guards`' synthesized `SYSTEM_PROCESS_INFORMATION` buffer: standard library, already a production import and allowed by the import boundary; kept inside the one buffer helper and reported in the audit.
2. **Answer 2:** the grace split above, test only; criterion 7 concerns product grace and limits. The review found its "sibling pattern" citation loose (FenceErrors runs no fresh Run, and SlotCrash's fresh Run uses a reopened Owner at the default grace), though the conclusion holds.
3. **Publication fix:** StandInT148Pub (5m28s, $1.54) blocked publication on one fact, `TestGitProcessSlotErrors/live-retired` for `TestGitProcessSlotErrors/native/live-retired`. The PM applied the one-token fix and the review's wording for criteria 1, 5 and 7 and design question 2 without re-review. The review kept the no-retry criterion and no link on ticket 91, and noted that a fix built only on hints would leave hint-0 roots unmet; the ruling's `foreign-denied-live` row answers that.

Sources: `local://t148-docs-notes.md:13-16,34-35`; `local://t148-s1-review.md:12`.

## Reviews

- **StandInT148S1** (approve, no blocking; checked gone outcomes, list acceptance, termination, fail-safety, locking, row assertions and every break's red line). Minors: B6b's blind spot is acceptable; `own-denied` could also assert that the list errors are absent; P-a1's "without waiting" has no timing assertion. Nits: `scanProcesses` does not require 8-byte-aligned links, which matters only for garbled data under checkptr; `doc.go` keeps two short lines so the unchanged sentences stay byte for byte. The commit message was confirmed by the PM.
- **StandInT148Fix1** (approve, no blocking; scope, thread locking, token calls, revert on every path, call sites). Minors: an `fn` that stopped its goroutine would return nil, unreachable today; `token.Close()` before `RevertToSelf` is harmless; a panic in `fn` crashes the binary without leaking the token; x/sys drops `ERROR_NOT_ALL_ASSIGNED`, but a failed removal would show in the control assertion. Nit: the privilege lookup now fails the row before the control open.

Sources: `local://t148-s1-review.md:3-13,24-39`; `local://t148-fix-1-review.md:3-25`; `local://t148-docs-notes.md:49`.

## Close notes

- **Correction to the brief.** The brief said the Job deny rows already pass on the hosted runner with the same technique. Those passes are no evidence that a process denial holds there, because SeDebugPrivilege bypasses DACLs only on process and thread objects. Check 129 showed the privilege enabled in the hosted test token; check 130 (run 44975034985), with fix 1, is the first hosted proof that the process denial holds. Sources: `local://t148-brief.md:147`; `local://t148-ruling.md:5,82`; `local://t148-s1-review.md:17`.
- **Dependency record.** No record needs a change: the `golang.org/x/sys` record (`docs/DESIGN-CORE-AND-LAUNCHERS.md:637`) lists only `internal/core/durable`'s calls, and `docs/CURRENT-RULES.md:49` admits `gitprocess` and its tests as x/sys importers by package; the new symbols are no dependency change and no owner gate (D29). Row `:615` still says x/sys is "imported only by `internal/core/durable` (B3)", stale since earlier tickets admitted more importers (D151, D168); a later docs fix, not this close. Sources: `local://t148-s1-review.md:18`; `local://t148-ruling.md:79`; `docs/DESIGN-CORE-AND-LAUNCHERS.md:615`.
- **Assistant decision (D117, D161; originator assistant).** The root "gone" proof gains the process-list fallback with its self-check. This refines how RulingT16S3R amendment 6 proves a root gone by process ID and creation time; the hint rule (`doc.go`, "Hints suppress duplicate reports, not native proof") is untouched, and ticket 16's widened access-denied residual (32 roots per live container) is replaced in `doc.go` by the narrower residual. Ticket 16's residual is not a decision entry, so none is written. Reliance on a reserved member is accepted: `CreateTime` sits in Microsoft's reserved region, and the self-check turns any layout change back into a refusal, never an unsafe admission. Sources: `local://t148-ruling.md:80-81`; `local://t148-s1-review.md:19`; `internal/core/gitprocess/doc.go:74-80`.
- **Ticket 147.** A `root_unconfirmed` message in a kill-and-reopen row now names its cause, which replaces ClarifyT147a's triage by reading footer bytes. The new row reproduces the mechanism, not that run: 147's original errno stays [INFERENCE], and nothing here shows that earlier runs were free of the defect. Sources: `local://t148-ruling.md:83`; `local://t148-s1-review.md:20`.

## Fable's audit (D160)

The ruling and the S1 review ask Fable's audit to examine three points: the self-check, the walk bound, and the first hosted run of the denial precondition (check 129's failure and check 130's pass). Sources: `local://t148-ruling.md:78`; `local://t148-s1-review.md:16`.

## Close

Final close review: StandInT148Close, a temporary Claude Opus 5.5 stand-in for the held advisor (D177), blocked on three corrections and gave exact replacement text for each (criterion 3's timing claim, criterion 7's grace wording and one evidence-record line); the PM applied them as given, with one of its wording notes on check 129's step times,, without re-review as the review allowed, and no other finding blocks the close.. Public ticket and paired-roadmap edits and these private records land separately (D145); C3 status stays only in its paired roadmap Status line and board row, and the contract register and decision log are unchanged (D161).

## Raw evidence references

The [inventory](ticket-148-evidence-inventory.json) is copied verbatim from `local://t148-evidence-inventory.json` (SHA-256 490a4b146b3e7dbd57512f892d550f909045c30001f89d4a5bed958ae482fe7b); raw files remain outside both repositories, and none is copied here. `S1/` expands exactly to `C:/Users/darius.jones/worktrees/dwarf-harness/t148-evidence` and `CI/` to `C:/Users/darius.jones/Documents/PROJECTS/DwarfHarness/CI Logs/Run 44963925728`. The breaks' other logs are in the inventory.

| Path | SHA-256 |
|---|---|
| S1/yield.json | 9dc9fd3f84d90bef94e8b4e3e410d1c5813ad3b6c55194cea0da86a4b587058a |
| S1/final-1-static.log | af82f10ba274e7106501d22287300e983bb16cf749d90f7630ee51bbbec686ec |
| S1/final-2-focused.log | a261710c9e1b492a95e76b768c7f9e1c33ac5fc391bf4118758c1b24632879be |
| S1/final-3-package.log | badb0cdb3d346aa0573f6aaf760e8d44b54cdbb1e2c635e993f41dc49caddad7 |
| S1/final-3-race.log | aa7d533579b6a7c8cd5fac410a0db7ac5984d81dcd1a5201efb55d3a05778d55 |
| S1/final-4-race20.log | ba559c04ec55b96e3b6d0146c840814bf2613c8ff2b35ac0bdb82ff4866327d9 |
| S1/race20-red-before-grace-fix.log | 48fa2ab2da9a128a79a46f7a618c229387b8fa330aa0a224de4773f85288479e |
| S1/breaks/B3/red.log | 11184367d7d0029b8fd6089075f2c5b30c4697d40fdeaa03697771972f561ed7 |
| S1/breaks/TODAY/red.log | 39453fa2a8c118f318601716088dd5f03cfe6683aba6a3eae7f17d63baa683ce |
| S1/fix-1/yield.json | 252d8bc871219b12dfa1f3f540aa0a0c720189c33000765f74eb263cab01f464 |
| S1/fix-1/2-focused.log | becde8b0a871673676f0e28482f53478c56b3991c4679a39fecb46450c866972 |
| S1/fix-1/3-package.log | d3525bff0f0e9d10461d6c3b70562a1ae1d0503106d93a4009d22617c881797b |
| S1/fix-1/3-race.log | c292a26a0cd40ed28845250ff2b7b4a019b719e8dddbc6d9f0c5ca2888a38256 |
| S1/fix-1/4-race20.log | 7f1ce5047d6d9884f2e88a6d9f78110b1341bdb40c729681e0160d360de10939 |
| S1/fix-1/breaks/B3/red.log | 78e5d62ddafd3f13e09a9a9a02b181d488e48fb8eb44538dbf16ae8c1e619284 |
| S1/fix-1/breaks/DEMO/red.log | 4c500298cd2ca95585c14c7f0295948ce0fcf8ce7f3a622d76fff9e50dfbc6ef |
| CI/2_Check _ windows-amd64.txt | cac00cfa5cc6979a1b7f6e4773b3c2f472de0dc59d30b0d1c0010b8c5891020e |
| local://t148-s1-review.md | ce6195a75bd123a4697524cde3f5ffddcc376fe285b04135ebcb30262c02fd60 |
| local://t148-fix-1-review.md | 67f4ba9264bedfe83227b6c3e76e457fe100d165805f2f80c52e495cad981b64 |
| local://t148-s1.diff | 68cfa8a1e2c53d986a347babc76a4e03c42d39dc53d50687b5b7a8f387c5b63c |
| local://t148-fix-1.diff | c5b363b3fb8b592e5de8e008b985fa5cab901277cd3acddec0c697a1696d2918 |
