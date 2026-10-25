# F-U3-61 freeze evidence: ticket 61 S2 at 1a74bfc

Collected on 2026-10-17 for D130, the project manager's freeze of F-U3-61 under D125. The test runs are the coder's final runs on the committed tree (D121), verified by hash: all eight changed files' SHA-256 values match commit 1a74bfc (`feat(ledger): draft F-U3-61 graph records for the project manager's freeze`, on `main` 3d442f4). The fuzzing is the project manager's, on that commit, and so is the check, on the freeze-record commit; go1.27.2, Git 2.55.0.windows.3. What was built and checked follows the build advisor's design ruling for ticket 61 and its notes for S2; the ruling lands in this directory with the ticket's close.

| Step | Result |
|---|---|
| V1 `gofmt -l contract/ledger`, `go tool staticcheck ./contract/ledger`, `go vet ./contract/ledger` (coder, final) | gofmt lists no file; staticcheck and vet exit 0 |
| V2 `go test -count=1 -v ./contract/ledger ./internal/core/ledgerstore`, then `go test -race -count=1 -v ./contract/ledger` (coder, final) | PASS: `contract/ledger` in 8.5 s and `internal/core/ledgerstore` in 24.7 s, and `contract/ledger` in 35.8 s under the race detector; every seed corpus passed |
| V3 `-fuzz -fuzztime 120s` on `FuzzDecodeU3_61` (PM) | PASS: 4,336,133 executions of `FuzzDecodeU3_61` in 120 s; no new corpus file |
| V6 (coder, final) | `contract/ledger` imports the standard library only; its tests import no `contract/law` |
| V7 (coder, final) | `go mod tidy -diff`: none; `go mod verify`: all modules verified |
| V8 `go test ./contract/ledger -run '^TestGolden(F0\|F2_05\|F2_06\|F2_07\|F2_08\|F2_09)$' -update` (coder, final) | PASS: each earlier golden regenerates byte for byte, matching the digests of D111, D115, D118, D119, D123 and D124 |
| The new golden | `contract/ledger/testdata/u3/61/log/00000000000000000001.jsonl`: 41 commits, 62 records, SHA-256 6c7169aa9cfe77bb8976348f515ef85ec8da82b277520f82fd2bf169e6c45e0f (the committed blob) |
| Empty digests, as the tests print them | `EmptyGraphDigest` 50615e395eebec3556dbfd7bb8684d2c65e3aee8810b9d17cbfb157c30471f91; `EmptyChunksDigest` e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 |
| Fixture identities | the golden's `fid` suffixes, in hexadecimal ranges: 06–0f, 17–20, 24–30, 3e, 3f, 4e–50, 5e–60, 66–6f, 75–80, 90, a0, b0, ba–c0, c2–c4, c6–d0, da and db, 89 in all, each one no earlier fixture uses |
| V9 | the new golden is `i/lf w/lf`, with no CR byte |
| V12 (coder, final) | `GOOS=linux` and `GOOS=darwin` `go vet ./contract/ledger`: exit 0 |
| V4 `go run ./tools/check -race=false` (PM, D129) | `check PASSED: 8 of 9 steps passed, race skipped (D129)` in 752.5 s, on this commit before this result was written in, a Markdown-only change (D128) |

Rule breaks (the coder's report): 97 mutation expectations met. Each isolated break of a decoder rule failed `TestU3_61PayloadsRefuse`, `TestEdgeID` or `TestGoldenU3_61`, and each mutated file was restored with its SHA-256 asserted. Two breaks first survived, of the edge-type token check and of the rule that a zero `base_version` in `graph.version_committed` needs `EmptyGraphDigest`; rows added to `TestU3_61PayloadsRefuse` killed both. Controls on the unchanged `activation.go` and `finalization.go` decoders failed no new test, as required.
