# F3-15 freeze evidence — Ticket 15 S2

Freeze D165, 2026-10-30. Contract-code subject: `001384d9f1fe8fca8a0399c6d4353dba710d7e2b`. The final public freeze-record SHA is a separate subject in the D153 hosted result below, not a self-reference to this private file. The ticket-15 ruling, P1, compatibility table and amendments 2, 3, 5 and 7 govern. D125 requires one fresh joint review of this completed contract, its fixtures, evidence and proposed record; design approval is not that review.

## Scope and fixture identity

D165 covers the six version-1 F3-15 types added to `ledger-format` version 1, their codecs/value shapes/decoder and group rules, schema-6 canonical submission and the 65,536-byte complete-payload/submission cap. The specification is `contract/ledger/doc.go:2821-3064`; the public catalogue is in `docs/CONTRACTS.md`, and D165 records the shared-head/child readings and producer rules without changing an earlier entry.

The transcript manifest chunk schema, final-message manifest, request/result/replay object encodings, `TurnPolicy`/defaults, session interface, terminal settings file, later families, C7's `launcher-protocol` and R1's `context-module` are excluded. No operational loop, provider replay acceptance, ticket-16 crash/race proof, capacity bound or isolation claim follows from this codec freeze.

Golden `contract/ledger/testdata/f3/15/log/00000000000000000001.jsonl`: **36 commits, 115 records**, SHA-256 **`d3cdec92ba04b16f704a738613b302c7321b5a38ef1429f252bfe6770479ca84`**. It has 18 generated hash-named object/body fixtures beside it; all 19 new fixtures have no CR. `Defined()` rises from **53 to 59**. The full 93-file fixture digest inventory and final 29-file code/fixture inventory are referenced below, not copied.

| Shape/type | Observed sequence(s) and coverage |
|---|---|
| `loop.bind` / `runtime.turn_bound` | effect 77, receipt 78; selects input/policy/render after native admission 71 |
| `tool.begin` / `runtime.tool_started` | effects 89 and 95, receipts 90 and 96; authorized passive `turn.inspect` with leaf grant, then `invalid_argument` with no target/grant/native effect |
| `tool.result` / `runtime.tool_result` | effects 92 (`ok`) and 98 (`invalid_argument`), receipts 93 and 99; each binds its exact start |
| `loop.end` | native ending 110 precedes the four-record group 112–115: command, `private.turn_revision` 113, `runtime.turn_result` 114, receipt 115; one transcript append, `finished`/`natural_stop`, two model calls and two tool dispatches |

These positions are read from the committed golden (`contract/ledger/testdata/f3/15/log/00000000000000000001.jsonl:77-78,89-99,110-115`); its generator is `contract/ledger/loop_golden_test.go:145-231`. The golden exercises all six types and all four ordered group shapes, not every possible writer token or runtime effect.

## D152 focused evidence

The coder's final runs used `GOTOOLCHAIN=local`, empty `GOFLAGS`, explicit `CGO_ENABLED=0`. The retained command journal supplies exact invocations, exits, durations and log paths.

| Step and coverage | Observed result |
|---|---|
| V1 — coder's final formatting, host vet/staticcheck and tested-tree/committed-blob agreement | `gofmt -l contract/ledger`, `go vet ./contract/ledger` and staticcheck exited 0 with empty output. The PM matched all 29 final file hashes to committed blobs at the code subject. |
| V2 — focused codecs/canonicalization/boundaries/groups; one plain verbose contract run; real consumers | Focused `TestF3_15`, `TestGolden`, `TestLoop`, `TestDefined` and `TestCatalogue` selection exited 0. The plain verbose `./contract/ledger` run passed, including all 118 fuzz seeds: 11.362 s Go package / 12.51294369995594 s wall. `./internal/core/ledgerstore` passed in 29.508 s Go; `./internal/core/agents` passed in 108.822 s Go. Codec-only: no race run or intentional mutation campaign is claimed. |
| V3 — PM 120-second `FuzzDecodeF3_15` campaign, exact code subject and corpus disposition | PM, `go test ./contract/ledger -run '^$' -fuzz '^FuzzDecodeF3_15$' -fuzztime 120s -parallel=1` on `001384d` (`GOTOOLCHAIN=local`, empty `GOFLAGS`, `CGO_ENABLED=0`): exit 0, `ok` in 123.026 s, 203,308 executions, 23 new interesting inputs (141 in the fuzz cache), nothing written to the corpus (worktree clean afterwards). |
| V6 — dependencies/imports and final changed-path inventory | Dependency closure contains only `github.com/Darius-PJ/dwarf-harness/contract/ledger` outside the standard library. The final inventory covers ten Go files and nineteen generated fixtures, all under `contract/ledger`; no permanent Core path changed. |
| V7 — module audit | `go mod tidy -diff` exited 0 with empty output. PM, on `001384d`: `go mod verify` printed `all modules verified` (exit 0), and `git diff aa81bb2 001384d -- go.mod go.sum` is empty. |
| V8 — new and all-golden regeneration; earlier-byte/digest comparison | `TestGoldenF3_15 -update` and all `TestGolden -update` passed; the coder's fixture status listed only the new `f3/15` directory. Earlier goldens are byte-identical; all fifteen earlier log digests are listed below. The corrected chapter audit is authoritative for 36 commits/115 records; the first audit selected the chapter-13 counts and is superseded. |
| V9 — new generated-file hashes and byte-level CR/terminator inspection | Nineteen generated fixtures, eighteen hash-named object/body files plus the log; zero CR bytes. Their SHA-256 values are in the retained 93-file fixture inventory. From `git ls-files --eol` on `001384d`: 3 files `i/lf w/lf` (`f3/15/bodies/91bcc3dba39a97a337829a4150a…`, `f3/15/log/00000000000000000001.jsonl`, `f3/15/objects/a9d748d84941c6117611a40dd7…`) and 16 `i/none w/none` (compact JSON without a final newline); no CR byte in any (PM byte audit). |

No duplicate local full gate or local V4 is supplied. The final public SHA's hosted Check is the integration gate under D153; the code-subject checks do not substitute for it.

## Earlier golden comparison

The following log digests remain unchanged. F3-13 uses D149's corrected chapter-13 digest, not D148's superseded first log; chapter 14 is F3-13's second golden under D163, unchanged by D164.

| Earlier log under `contract/ledger/testdata/` | Freeze | SHA-256 |
|---|---|---|
| `f0/catalogue/log/00000000000000000001.jsonl` | D111 | `319c805312afd1abf824d306bcd799dd42bd3ae04fdf33fb74bc3f742ac8c898` |
| `f0/log/00000000000000000001.jsonl` | D111 | `c72c4a739965586d984b524dbc6ee67a5b9d866756639fbb03b04e90f441f2e5` |
| `f0/log/00000000000000000005.jsonl` | D111 | `3ee9f566e69e9cccb89ed435afee322950d3084a69ed0301684c15be70f8e65b` |
| `f2/05/log/00000000000000000001.jsonl` | D115 | `843663a168e472adf4656fdba4ffa6db770e588feec0020bb10e20bf14def437` |
| `f2/06/log/00000000000000000001.jsonl` | D118 | `014cc612076390934fa8a668117c353c5cca2630a3b3fd90364a29542b96f40d` |
| `f2/07/log/00000000000000000001.jsonl` | D119 | `96de91f92432040683157279432512810c2dd27d36012695be46dd1eccac88c5` |
| `f2/08/log/00000000000000000001.jsonl` | D123 | `985e073a342d9f991fdd2afd407dc495c3542020c98e35d3079018e29db14b8c` |
| `f2/09/log/00000000000000000001.jsonl` | D124 | `f1a0c473ee410c189c743547f37c86ebd638ce9c92c68cd44d1b2816f9f3ad88` |
| `u3/61/log/00000000000000000001.jsonl` | D130 | `6c7169aa9cfe77bb8976348f515ef85ec8da82b277520f82fd2bf169e6c45e0f` |
| `f3/10/log/00000000000000000001.jsonl` | D139 | `9622b72877ed546a18fcbfd28a19807e0bab237909e23ffe76e7c3da1c260ecd` |
| `f3/11/log/00000000000000000001.jsonl` | D140 | `145bb11c2b1c58e9e8530a98e6972b35329e4adb9dfb945a9f15381ae221bba6` |
| `f3/12/log/00000000000000000001.jsonl` | D144 | `6586720b28a19f997dd0890a6dbc71d27ffdf395fd000e68b6aedbbbe0ce79f8` |
| `f3/13/log/00000000000000000001.jsonl` | D148/D149 | `50b41cf739cbef89bec234cf64873e80af85188b256c66d6cb1e86ebea3555ff` |
| `f3/139/log/00000000000000000001.jsonl` | D154 | `db1476e07b355d909dfb07cce79f142387469618709bc52a3f496395b94c5134` |
| `f3/14/log/00000000000000000001.jsonl` | D163/D164 | `74d43897fb8d8c7275599270fc874a1ca7f8911ba35ea197b4d8c11b8a7dedaa` |

## Actual Core Open probe

The throwaway `TestTicket15ContractOpenProbe` used real Core `Open` on chapters 10–15 and 139. Every chapter opened with no error, no issue and unchanged durable sequence: 10→34, 11→130, 12→90, 13→150, 14→201, 15→115, 139→65. Chapter 15's `synthetic_source` credential fixture with a `synthetic-only:` locator was accepted without fallback or Core-rule changes. The chapter's copied F3-13 setup differs from chapter 13 in two synthetic substitutions only, both inside `testdata/f3/15`: the credential source (`synthetic_source` with a `synthetic-only:` locator, as the PM allowed) and grant `019a1300-…-0413`'s operations (`turn.inspect`, `turn.start`), so that the passive `grant_id` at sequence 89 names a grant that authorizes `turn.inspect`; no earlier golden byte changed. The generator corrected prerequisite event timing and the native turn-ending receipt after two initial probe failures; the retained command journal keeps those failures and the final successful run.

The probe source is retained privately and its temporary test was removed before final product hashes. This validates earlier-family prerequisites, not F3-15's later runtime reducer, recovery execution or provider acceptance.

## Joint completed-contract review

Fresh joint review (Fable 5.1) of 001384d9f1fe8fca8a0399c6d4353dba710d7e2b, its f3/15 fixtures, the S2 evidence (focused/V1/consumer runs, 120 s FuzzDecodeF3_15 203,308 execs, real Core Open probe 10–15/139 with no error, no issue, unchanged durable sequence) and this record: approve — the six codecs, schema 6 and runtime.loop_receipt match P1 and amendments 2, 3 and 5, every earlier byte and golden is unchanged, Defined() 53→59; the record approved with one required D165 Readings clause (tool_started child/no-accounting-release) and two optional wording notes.

The review covers code subject `001384d9f1fe8fca8a0399c6d4353dba710d7e2b`, its generated fixtures, observed evidence and this exact proposed freeze record together. Its actual retained verdict is referenced below.

## D153 hosted integration — final public freeze-record subject

Check 32, run 41136623988 attempt 1 (https://github.com/Darius-PJ/dwarf-harness/actions/runs/41136623988), on `3809b41117a39facf6c2c6788734f3a676be8dc0`, which carries this record's public commit `c2d42e481a3ba77cf8ae123905bdb54cb3954a3f` (on S2 rebased as `a192ff3`) with S1 above it: `changes`, linux-amd64, macos-arm64 and windows-amd64 (full check, race included) and `Check result` all success; `main` fast-forwarded bbacb86..3809b41. Check 30 (run 41133154184) on `c2d42e4` itself failed only in the Windows race step, `internal/core/winexec` `TestSeparateRunsCannotReadPeerInput` (the intermittent failure ticket 45's proposed follow-up 7 names; this slice changes no winexec code), and was not counted.

This result identifies the exact final public record SHA, run URL/ID/attempt, conclusion and actual platform/race jobs or exemption classification. Any later source fix or rebase needs its own exact-SHA result.

## Retained raw evidence (D160)

References below bind raw artifacts by path and SHA-256; logs, receipts, profiles and verdict contents are not copied into this record.

| Artifact | Path and SHA-256 |
|---|---|
| Final coder report | `local://t15-s2-report.md` (PM session), SHA-256 `653446968c5fea676baf82c65383fcc78aa011bd64c865262df17850c8600eee` |
| Exact command journal, including initial/final probe attempts | `C:/Users/darius.jones/worktrees/dwarf-harness/t15-s2-evidence/commands.jsonl`, SHA-256 `2eba021289df886638246b705a8224db69ec82d2ac6d841e54e945f84e664b9c` |
| Final tested-tree code/fixture hashes | `C:/Users/darius.jones/worktrees/dwarf-harness/t15-s2-evidence/final-hashes.json`, SHA-256 `19d2d6ff1c6303ce6a28bf95732423611352c138d61e140e43bbb2d755a3bdf1` |
| All 93 fixture-file digests | `C:/Users/darius.jones/worktrees/dwarf-harness/t15-s2-evidence/golden-hashes.json`, SHA-256 `68b4c33a7170df917827a485f40c8e8db8c4f7afc2f1f531084dac8ed969270f` |
| Corrected chapter counts, shapes, timings and CR audit | `C:/Users/darius.jones/worktrees/dwarf-harness/t15-s2-evidence/final-audit-chapter.log`, SHA-256 `72215e3d4f5d03c8f8143577dbce304bd2d3f5e41ee17964895d878b0a484565` |
| Coder's final formatting/static/focused/plain/consumer/dependency/tidy/golden/status logs | `final-gofmt.log` `e3b0c44298fc1c14…`; `final-vet.log` `e3b0c44298fc1c14…`; `final-staticcheck.log` `e3b0c44298fc1c14…`; `final-focused.log` `0d7dce7b9a6e2190…`; `final-v1.log` `0201c2f70730a322…`; `final-agents.log` `d5776ef1b96d95e3…`; `final-ledgerstore.log` `ea1bf8f97a6a1746…`; `final-deps.log` `3fed9c60a19efaba…`; `final-tidy.log` `e3b0c44298fc1c14…`; `final-v8.log` `0008acf64e416ad2…`; `final-fixture-status.log` `a369e8e375e64cd1…`; `final-status.log` `6d3a9a47555b1ff8…` (all under the raw root; full SHA-256 values in the PM notes) |
| PM committed-blob, authoritative earlier-golden and per-file terminator proof | `golden-hashes.json` and `audit.json` under the raw root (`22e4c370e7eaf4ab…`); the PM's `git cat-file` comparison of all 29 committed blobs, the 18 hash-named fixtures and the earlier golden logs at `001384d` and its rebase `a192ff3`, recorded in `local://t15-docs-notes.md` |
| Throwaway actual-Core probe source | `C:/Users/darius.jones/worktrees/dwarf-harness/t15-s2-evidence/zz_t15_s2_probe_test.go`, SHA-256 `11cf1d8e968e696428fa92328d44fd388d3408c6caed41720e84a63631cbd115` |
| Final actual-Core probe output | `C:/Users/darius.jones/worktrees/dwarf-harness/t15-s2-evidence/final-open-probe.log`, SHA-256 `46d1bda3953a36517d3776bc23d0ecc765aa6d5dcbd11e211f9973134b7434f0` |
| PM fuzz command/result/output and corpus disposition | `C:/Users/darius.jones/worktrees/dwarf-harness/t15-s2-evidence/fuzz-FuzzDecodeF3_15.log`, SHA-256 `1a72d4ca44fbd7db33317fef368457050f231ee07f6eaf6c117fbd3a8c5ebd51` |
| Fresh joint advisor verdict and exact reviewed subjects | `local://t15-s2-review.md` (PM session), SHA-256 `98b9bb3b4e64ebe7d79381968a70c5cd77e223855edf32e802c3db475a799931` |
| Exact-final-public-SHA hosted Check receipt/jobs | `local://t15-s2-hosted-check.json` (PM session; runs 30 and 32 with jobs from GitHub's API), SHA-256 `b073a1088e1bc397530ac8b24757ed8058a7f298c00dcad773c1212c48d92bf0` |
