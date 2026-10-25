# F2-06 freeze evidence (ticket 06, S2)

Collected by the project manager on 2026-10-12 with a script (`t06-s2-evidence.sh`, then `t06-s2-evidence-2.sh` for the final commit) on a detached worktree of the exact commit, Windows 10, Git 2.55.0.windows.3, go1.27.2, Defender real-time protection on.

**Commit:** `188f5c577636f3ad4d362e39397b4ae8dea2ee04`, `feat(ledger): draft F2-06 promotion records for the owner's freeze` on `build/06-f2`, parent `main` 408944d. It replaced 0fa0f43 before any review: the first full check, at 0fa0f43, failed only its staticcheck step (`contract\ledger\promotion.go:133:10: error strings should not be capitalized (ST1005)`), and 188f5c5 rewords that one string (`git diff --stat 0fa0f43 188f5c5`: `contract/ledger/promotion.go | 2 +-`).

| Step | Command | Result |
|---|---|---|
| V2 | `go test -count=1 -v ./contract/ledger ./internal/core/ledgerstore` | exit 0, 43 s; 1,351 tests and subtests run, 1,347 passed, 4 skipped (`TestHelperChildWriter`, `TestHelperChildSubmitter`, `TestHelperWorkloadChild`: child processes of other tests; `TestWorkload`: opt-in), none failed. `TestNewCatalogue`, `TestGoldenF2_06`, `TestGoldenDecodes`, `TestF2_06PayloadsRoundTrip` and `TestF2_06PayloadsRefuse` passed. |
| V3 | `go test ./contract/ledger -run '^$' -fuzz '^FuzzDecodeF2_06$' -fuzztime 120s`, at 0fa0f43 | exit 0, PASS; 1,882,465 executions, no failure, no file left under `testdata`. Not repeated at 188f5c5, which differs only in that error string. |
| V6 | `go list -deps` non-standard packages of `./contract/ledger` | only `github.com/Darius-PJ/dwarf-harness/contract/ledger` |
| V7 | `go mod tidy`, `git diff --exit-code -- go.mod go.sum`, `go mod verify` | no change; all modules verified |
| V8 | `go test ./contract/ledger -run '^TestGolden' -update`, then `git status -- contract/ledger/testdata` | exit 0; no file changed |
| V8 digests (SHA-256) | F0 `f0/log/…01.jsonl`, `f0/log/…05.jsonl`, `f0/catalogue/log/…01.jsonl`; F2-05 `f2/05/log/…01.jsonl` | `c72c4a73…f2e5`, `3ee9f566…e65b`, `319c8053…c898`: equal to D111's (`docs/DECISIONS.md:1521`); `843663a1…f437`: equal to D115's (`:1681`) |
| F2-06 golden | `contract/ledger/testdata/f2/06/log/00000000000000000001.jsonl` | twelve commits, twenty-five records; SHA-256 `014cc612076390934fa8a668117c353c5cca2630a3b3fd90364a29542b96f40d` |
| V9 | `git ls-files --eol -- contract/ledger/testdata/f2/06` | `i/lf w/lf attr/text=auto eol=lf` |
| V12 | `GOOS=linux` and `GOOS=darwin` `go vet ./contract/ledger` | exit 0 both |
| gofmt, staticcheck | `gofmt -l contract/ledger`; `go tool staticcheck ./contract/ledger` | nothing listed; exit 0 |
| V4 | `go run ./tools/check` with `DWARF_CC`, at 188f5c5 | `check PASSED: all 9 steps passed` (toolchain, gofmt, vet, staticcheck, govulncheck, import boundary, tests, race, cross builds), 936 s |

Rule breaks made by the coder (each made, observed failing, restored; `local://t06-s2-coder-report.md`): a `checkpoint` 2 without a parent → `TestF2_06PayloadsRefuse/root/checkpoint_without_parent`; b `restart_from` with a parent → `…/successor/restart_with_parent`; c a conflict without `report_pin_id` → `…/conflict/conflict_without_report_pin`; d a clean generation with `conflict_sha256` → `…/clean/clean_with_conflict_digest`; e a predecessor request without its generation → `…/clean/predecessor_request_alone`; f a refused unknown failure outcome → `TestF2_06PayloadsRoundTrip/future_outcome`; g an empty optional key encoded → `TestF2_06PayloadsRoundTrip/conflict`; h a type dropped from `Defined()` → `TestNewCatalogue`; i one golden byte changed → `TestGoldenF2_06`; j an F2-05 encoder changed (temporarily, restored byte for byte, `git diff --exit-code` exit 0) → `TestGoldenF2_05`.

`go doc -all ./contract/ledger` at 0fa0f43: 1,073 lines, kept in the evidence directory (`t06-s2-ev/go-doc-all.txt`).
