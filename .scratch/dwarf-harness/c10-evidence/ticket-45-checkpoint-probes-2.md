# Ticket 45 S1: native probes after §6 (2026-10-17, round 3)

These are the facts from CoderT45S1. The logs are under `C:/Users/darius.jones/worktrees/dwarf-harness/t45-s1-evidence/`: `qualification-test-20261017-034847.log` and `probe-{m,n,o,m-observer}.log`. Each throwaway change was restored with its SHA-256 asserted.

## The rerun with §6 applied
Under LPAC with `JOB_LIST` and `DETACHED_PROCESS`, using §6's environment block, these pass:
- all three suspended launches;
- classes 29, 30 and 31;
- Job membership and the limit readback;
- the traverse privilege;
- resume.

Then:
- **The positive payload:** `os.ReadFile("nonce")` fails with WSANOTINITIALISED ("Either the application has not called WSAStartup, or WSAStartup failed"). This probably also explains the earlier `TEMP` read-back failure in probe (k).
- **Quota:** the payload reached CPU-ready, the root exited with 0xC0000044 (`STATUS_QUOTA_EXCEEDED`), and Job-zero was confirmed. The assertion expected 1816, `ERROR_NOT_ENOUGH_QUOTA`, which is what the `JOBOBJECT_END_OF_JOB_TIME_INFORMATION` page documents for action 0.

## Round 3: one factor changed at a time
| Probe | Result |
|---|---|
| (n) LPAC: the payload calls `WSAStartup(0x202)` itself | returns 10107, `WSASYSCALLFAILURE` |
| (o) LPAC: the nonce read through raw `CreateFile`, `ReadFile` and `CloseHandle` | succeeds, with exactly `file-nonce`: the file ACL is fine |
| (m) the regular AppContainer, same block | `os.ReadFile("nonce")` succeeds, and the `TEMP` and `DWARF_WORK` round trips (create, write, close, reopen, read, close) succeed, every error nil |
| (m) network, regular AppContainer | a dial to the test host's listener on `127.0.0.1:54581` times out ("connected party did not properly respond") instead of the asserted `WSAEACCES`; the payload's test took 1.03 s |
| (m-observer) regular AppContainer | with an open handle to an exited descendant, `ActiveProcesses` stays at 1; it reaches 0 once that handle is closed |

**Reading [PM inference, not traced in the Go source]:** Go's `internal/poll` calls `WSAStartup` in its `init` on Windows, and after a failure refuses `FD.Init`. Under LPAC with zero capabilities, Winsock startup fails, so `os` file I/O fails for any Go payload, and probably for other runtimes that start Winsock, such as Node's libuv. The Winsock-catalog cause itself is not proven.

## Questions for a revised ruling (§7)
1. **The profile.** Does P14's approved switch to the regular AppContainer apply? A Go payload cannot do file I/O under LPAC here. Or should it be LPAC plus a named capability, which departs from zero capabilities? And what replaces the two-canary LPAC test (§6.2) under the regular profile?
2. **Network denial.** The loopback connect is dropped, not refused. What is the observable? For example:
   - a host-side listener that accepts nothing within a bound;
   - a positive control, the host's own connect to the same listener;
   - a test-chosen dial timeout, with no duration assert.
3. **The quota exit code.** May the test accept 0xC0000044 by asserting `windows.RtlNtStatusToDosError(NTStatus(exit)) == ERROR_NOT_ENOUGH_QUOTA`, which ties the observed NTSTATUS to the documented Win32 code?
4. **The observer handle.** An outside handle to an exited descendant holds Job-zero open (F6 confirmed). The product holds none, but a third party such as Defender might. Is there any change to the Job-zero or quarantine rule, beyond the existing wait bounded by `StopGrace` and quarantine?
