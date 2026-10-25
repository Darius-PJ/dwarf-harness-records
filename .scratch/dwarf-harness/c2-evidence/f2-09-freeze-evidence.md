# F2-09 freeze evidence: ticket 09 S2 at 93b76a4

Collected on 2026-10-16. The test runs are the coder's final runs on the committed tree (D121), verified by hash: all 11 changed files' SHA-256 values match commit 93b76a4 (`feat(ledger): draft F2-09 policy activation records for the owner's freeze`, on `main` d4453c0). The fuzzing, module checks and full check are the project manager's, on a detached worktree of that commit; go1.27.2, Git 2.55.0.windows.3, Defender real-time protection on.

| Step | Result |
|---|---|
| V2 `go test -count=1 -v ./contract/ledger ./internal/core/ledgerstore` (coder, final) | exit 0; `contract/ledger` PASS in 8.861 s, `internal/core/ledgerstore` PASS in 46.209 s; every fuzz target's seed corpus passed |
| V3 `-fuzz -fuzztime 120s` (PM) | `FuzzDecodeF2_09`: 2,660,267 executions; `FuzzDecodeF2_08`: 4,678,101; both PASS; no file left under `testdata` |
| V6 | `contract/ledger` imports the standard library only; its tests import no `contract/law` |
| V7 | `go mod tidy -diff`: none; `go mod verify`: all modules verified |
| V8 `go test ./contract/ledger -run '^(TestGoldenF0\|TestGoldenF2_0[5-8])$' -update` (coder, final) | exit 0 and no file changed: every earlier golden regenerates byte for byte, matching D111's, D115's, D118's, D119's and D123's digests |
| The new golden | `contract/ledger/testdata/f2/09/log/00000000000000000001.jsonl`: 22 commits, 34 records, SHA-256 f1a0c473ee410c189c743547f37c86ebd638ce9c92c68cd44d1b2816f9f3ad88 (from the committed blob) |
| V9 | the new golden is `i/lf w/lf`, with no CR byte |
| V12 | `GOOS=linux` and `GOOS=darwin` `go vet ./contract/ledger`: exit 0 |
| gofmt, staticcheck, line endings | clean |
| V4 `go run ./tools/check` (PM) | `check PASSED: all 9 steps passed`, 1,653 s; it runs again on the freeze-record commit |

Rule breaks (the coder's report): 49 decoder-rule mutations, each failing a named test and restored with its file's SHA-256 asserted; two controls that bypassed the unchanged `PromotionAccepted` and `PromotionNoChange` decoder checks left every new test green, as required.
