# F2-07 freeze evidence: ticket 07 S2 at ae1c995

Collected on 2026-10-13 by the project manager on a detached worktree of `ae1c9956dc5e74409dca9f010e4e4e2f92db91d5` (`feat(ledger): draft F2-07 scratch observation and merge-back records for the owner's freeze`, on `main` 1b96ee7); go1.27.2, Git 2.55.0.windows.3, Defender real-time protection on.

| Step | Result |
|---|---|
| V2 `go test -count=1 -v ./contract/ledger` | exit 0; 3,278 tests and subtests run, 3,278 passed, none skipped or failed. New: `TestGoldenF2_07`, `TestF2_07PayloadsRoundTrip`, `TestF2_07PayloadsRefuse`, `TestScratchCreatedParent`, `TestPromotionAdmittedProvenance`, `FuzzDecodeF2_07`'s seeds. `./internal/core/ledgerstore`: ok. |
| V3 `-fuzz -fuzztime 120s` | `FuzzDecodeF2_07`: 2,169,330 executions; `FuzzDecodeF2_05`: 5,917,960; `FuzzDecodeF2_06`: 4,434,180; all PASS; no file left under `testdata` |
| V6 | `contract/ledger` imports the standard library only |
| V7 | `go mod tidy -diff`: none; `go mod verify`: all modules verified |
| V8 `go test ./contract/ledger -run '^TestGolden' -update` | exit 0, and `git status -- contract/ledger/testdata` is unchanged: every existing golden regenerates byte for byte. SHA-256: F2-05 843663a168e472adf4656fdba4ffa6db770e588feec0020bb10e20bf14def437 (D115); F2-06 014cc612076390934fa8a668117c353c5cca2630a3b3fd90364a29542b96f40d (D118); F0 `00000000000000000001.jsonl` c72c4a739965586d984b524dbc6ee67a5b9d866756639fbb03b04e90f441f2e5 and `00000000000000000005.jsonl` 3ee9f566e69e9cccb89ed435afee322950d3084a69ed0301684c15be70f8e65b (D111) |
| The new golden | `contract/ledger/testdata/f2/07/log/00000000000000000001.jsonl`: 22 commits, 41 records, 37,093 bytes, SHA-256 96de91f92432040683157279432512810c2dd27d36012695be46dd1eccac88c5 |
| V9 | the new golden is `i/lf w/lf` (B1) |
| V12 | `GOOS=linux` and `GOOS=darwin` `go vet ./contract/ledger`: exit 0 |
| gofmt, staticcheck, line endings | clean |
| V4 `go run ./tools/check` | `check PASSED: all 9 steps passed`, 1,505 s |

Rule breaks (the coder's report): 67 mutations of the decoder and encoder rules, including breaks a–n of the assignment, each failed a named test and the restored code passed; one accessor-only mutation was masked by `PromotionAdmitted.check`, which still refuses the duplicate, and was replaced by an encoder-side break. Every owned file's SHA-256 was verified restored after the runs.
