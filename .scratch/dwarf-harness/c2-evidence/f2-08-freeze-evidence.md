# F2-08 freeze evidence: ticket 08 S2 at c44484d

Collected on 2026-10-13. The test runs are the coder's final runs on the committed tree (D121), verified by hash: all 11 changed files' SHA-256 values match commit `c44484d401b89e20c970252654bdf28d570f8404` (`feat(ledger): draft F2-08 finalization, acceptance and no-change records for the owner's freeze`, on `main` b03de1d). The fuzzing, module checks and full check are the project manager's, on a detached worktree of that commit; go1.27.2, Git 2.55.0.windows.3, Defender real-time protection on. On 2026-10-15 S2 was rebased onto `main` db85ebb as c9bb2c2; `git diff c44484d c9bb2c2 -- contract/ledger` is empty, and the full check runs again on the freeze-record commit.

| Step | Result |
|---|---|
| V2 `go test -count=1 -v ./contract/ledger ./internal/core/ledgerstore` (coder, final) | exit 0; `contract/ledger` PASS in 22.847 s, `internal/core/ledgerstore` PASS in 252.840 s; every fuzz target's seed corpus passed |
| V3 `-fuzz -fuzztime 120s` (PM) | `FuzzDecodeF2_08`: 3,576,403 executions; `FuzzDecodeF2_06`: 3,836,058; both PASS; no file left under `testdata` |
| V6 | `contract/ledger` imports the standard library only |
| V7 | `go mod tidy -diff`: none; `go mod verify`: all modules verified |
| V8 `go test ./contract/ledger -run '^(TestGoldenF0\|TestGoldenF2_05\|TestGoldenF2_06\|TestGoldenF2_07)$' -update` (coder, final) | exit 0 and no file changed: every existing golden regenerates byte for byte. SHA-256: F0 `00000000000000000001.jsonl` c72c4a73…f2e5, `00000000000000000005.jsonl` 3ee9f566…e65b and `catalogue/…0001.jsonl` 319c8053…c898 (D111); F2-05 843663a1…f437 (D115); F2-06 014cc612…f40d (D118); F2-07 96de91f9…88c5 (D119) |
| The new golden | `contract/ledger/testdata/f2/08/log/00000000000000000001.jsonl`: 22 commits, 39 records, SHA-256 985e073a342d9f991fdd2afd407dc495c3542020c98e35d3079018e29db14b8c |
| V9 | the new golden is `i/lf w/lf`, with no CR byte |
| V12 | `GOOS=linux` and `GOOS=darwin` `go vet ./contract/ledger`: exit 0 |
| gofmt, staticcheck, line endings | clean |
| V4 `go run ./tools/check` (PM) | `check PASSED: all 9 steps passed`, 993 s |

Rule breaks (the coder's report): sixteen decoder and encoder breaks, a–p, each failed the named tests and was restored; break l, `PromotionFailed`'s decoder rejecting `cancelled` or `interrupted` with an optional ID, failed only the existing `TestF2_06PayloadsRoundTrip` rows, as required, while every F2-08 test stayed green.
