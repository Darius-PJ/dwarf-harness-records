# Ticket 45 S1 checkpoint: native probe results (2026-10-17)

**Setup.**
- **Machine:** Windows 10 Pro 19045, x64. Coder CoderT45S1, worktree `45-s1` at ee798a5.
- **Logs:** under `C:/Users/darius.jones/worktrees/dwarf-harness/t45-s1-evidence/`: `qualification-test-20261017-033608.log` and `probe-*.log`. Every throwaway change was restored, with its SHA-256 asserted.
- **Flags in every launch:** `0x0008040c`: `CREATE_SUSPENDED`, `EXTENDED_STARTUPINFO_PRESENT`, `CREATE_UNICODE_ENVIRONMENT` and `DETACHED_PROCESS`.
- **LPAC:** `SECURITY_CAPABILITIES` with zero capabilities, plus the ALL APPLICATION PACKAGES opt-out policy and `JOB_LIST`.

## The checkpoint run
The environment block was `SystemRoot`, `WINDIR`, `TEMP` and `TMP`. All three launches failed in `CreateProcess` with Win32 203, `ERROR_ENVVAR_NOT_FOUND`, although all four attribute updates and the Job controls had succeeded.

Already passed:
- profile-folder binding: canonical path, a fresh-SID write ACE, file identity;
- label-only lowering, with the Low/NW label read back on the work and profile folders.

## Round 1: one factor changed at a time
| Probe | Result |
|---|---|
| (a) `CREATE_UNICODE_ENVIRONMENT` | it was already set |
| (b) LPAC, inherited environment | launches |
| (c) LPAC, original block plus `LOCALAPPDATA`, `APPDATA` and `USERPROFILE` | launches |
| (d) regular AppContainer, original block | 203 |
| (e) LPAC without `JOB_LIST`, original block | 203 |

In (b) and (c):
- `JOB_LIST` membership and the limit readback pass.
- Token classes 29, 30 and 31 read back, with lengths 4, 8 and 48.
- Class 46's size query fails with "The parameter is incorrect", length 0.

## Round 2
| Probe | Result |
|---|---|
| (f) original block plus `LOCALAPPDATA` only | launches |
| (g) plus `APPDATA` only | 203 |
| (h) plus `USERPROFILE` only | 203 |
| (i) class 46 queried directly with a 4-byte buffer | Win32 87, length 0, buffer unchanged: **class 46 cannot be queried on this build** |
| (k) LPAC with `JOB_LIST`, class 46 skipped, resumed, `LOCALAPPDATA` set to the real one | see below |
| (l) as (k), but `LOCALAPPDATA` set to the run's private work folder | launches; see below |

In (k):
- Windows rewrites the child's `LOCALAPPDATA` to `<real LocalAppData>\Packages\<profile>\AC`, and `TEMP` and `TMP` to that folder's `Temp`. `APPDATA` and `USERPROFILE` are absent.
- `Temp` exists, and creating a temporary file succeeds. But the payload's write and read-back check returned false, and its final removal hit a sharing violation. The individual errors were not kept, and it is not yet proven whether this is the payload's own fault.
- Classes 29, 30 and 31 and the Job readbacks pass. `SeChangeNotifyPrivilege` is enabled, and no ancestor ACE was needed (F4).
- The root exits normally, and the Job reaches zero processes.

In (l): Windows rewrites `LOCALAPPDATA` to `<work>\Packages\<profile>\AC`, and `TEMP` and `TMP` to its `Temp`. That folder does not exist, so creating a temporary file fails with `PATH_NOT_FOUND`.

**Not reached yet:**
- Job-zero after quota termination;
- Job-zero with an observer handle open;
- network denial;
- the denial matrix.

## Questions for a revised ruling
1. **The child's environment.** No AppContainer launches here without `LOCALAPPDATA`. Which value should it get?
   - The real LocalAppData, so that the child's `TEMP` lands in the AppContainer profile folder, which the design already binds and deletes.
   - The run's private folder, in which case the executor must itself create `<work>\Packages\<profile>\AC\Temp` with the right label and ACL.
   - Something else.

   Say what S1 must prove about `TEMP` (write, read and remove), and what the evidence states about the host path the child can see.
2. **The LPAC readback.** Class 46 cannot be queried on this build. What replaces it?
   - A behavioral proof: an object granted only to ALL APPLICATION PACKAGES (S-1-15-2-1) is denied to the shipped child.
   - A readback of `TokenSecurityAttributes` (class 39). LPAC tokens are said to carry `WIN://NOALLAPPPKG`, which no primary source here verifies.
   - Both.
3. **Continuing S1.** Confirm that S1 continues under LPAC with `JOB_LIST` and `DETACHED_PROCESS`, without the P14 switch. Confirm too that the remaining checkpoint items are proven in S1 without another checkpoint.
