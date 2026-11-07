# F3-16 freeze evidence — Ticket 16 S1

Freeze D169, 2026-11-07. Contract-code subject: `57a1930efc52b0ca9e33d0a9a9c1357c0a2a168f`. The final public freeze-record SHA is a separate subject in the D153 hosted result below, not a self-reference to this private file. The ticket-16 ruling's P1, compatibility rows and amendments 1–7, 18 and 20 govern. D125 requires one fresh joint review of this completed contract, its fixtures, evidence and proposed record; design approval is not that review.

## Scope and fixture identity

D169 covers the two version-1 F3-16 types added to `ledger-format` version 1, their codecs, value shapes, decoder and group rules, the schema-7 canonical submission, the 65,536-byte cap, the guarded-turn reading and the schema 1–7 command lookup. The specification is the F3-16 section of `contract/ledger/doc.go`; the public catalogue is in `docs/CONTRACTS.md`. The continuation owner's API, the session interface, runtime policy, the pending ceiling, scheduler settings, the private `owner_input` schema 2, the `gitprocess` fence and root identity files and later families are excluded. No owner, recovery, concurrency or child-shutdown claim follows from this codec freeze.

Golden `contract/ledger/testdata/f3/16/log/00000000000000000001.jsonl`: **33 commits, 106 records**, SHA-256 **`fea39fda76e2946cfa67a466127014249006684e2a1c0258a7685a948d91ecf9`**, with seven generated hash-named object/body fixtures beside it. `Defined()` rises from **59 to 61**. `TestNewCatalogue`'s `want` map stays the one exact catalogue assertion; the obsolete `53+6` total in `TestDefinedF3_15` was removed and its six membership checks kept.

| Group (sequences) | Coverage |
|---|---|
| Earlier-family prefix (1–78) | 24 commits, ending with the F3-15 binding at 77 and its receipt at 78 |
| `owner.initialize` (79–81) | `ready`, version 1, generation 1 |
| `owner.advance` (82–84) | new operation: `model_pending`, generation 2, one `paid_attempt` pending with its `command_id` |
| `owner.advance` (85–87) | park in the same operation: `waiting_resource`, resume `model_pending`, wait `paid_prepare` |
| `owner.stop` (88–90) | actor `owner`: `stopping`, `cancelled`, `cancel_command_id`, generation 3; re-presenting the earlier wait transition after the stop is refused and the prefix stays byte-identical |
| `owner.advance` (91–93) | `finishing` under the same stop operation |
| `owner.reconcile` (94–96) | `reconciling`, generation 4, the never-committed child dropped from pending |
| F3-11 `turn.cancel` (97–99) | native ending `cancelled` at 98, under the recorded `cancel_command_id` |
| F3-15 `loop.end` (100–103) | transcript revision 101, turn result `cancelled` 102, receipt 103 |
| `owner.close` (104–106) | `terminal`, `native_ending_sequence` 98, no pending |

These positions are read from the committed golden; its generator is `contract/ledger/continuation_golden_test.go:73-124`. The golden exercises both types, all five operations and the wait, stop, recovery and terminal snapshots, not every writer token, pending kind or notice cursor; the codec rows of `contract/ledger/continuation_test.go` cover those.

## D152 focused evidence

The coder's final runs used `GOTOOLCHAIN=local`, empty `GOFLAGS` and `CGO_ENABLED=0`. The retained command journal gives each invocation, exit and log path.

| Step and coverage | Observed result |
|---|---|
| V1 — the coder's final formatting, vet and staticcheck; committed-blob agreement | `gofmt -l` on the nine changed Go files, `go vet ./contract/ledger` and staticcheck on `./contract/ledger` exited 0 with empty logs. The PM matched all 17 committed blobs at the code subject, nine Go files and eight fixtures, to the coder's final hashes with `git cat-file`; a first `git show` check printed nothing for four long fixture paths and is superseded. |
| V2 — the coder's focused and plain contract runs; real consumer | The `TestContinuation` and `TestGoldenF3_16` selection exited 0; the first focused run, before the golden existed, exited 1 on the golden-group test only. The plain verbose `./contract/ledger` run passed in 15.374 s; `TestGoldenF3_16` reports the golden's commits, records and all five operation shapes, and `TestGoldenU3_61` its unchanged digest. `./internal/core/ledgerstore` passed in 68.459 s. Codec only: no race run or mutation campaign is claimed, and the ruling requires none for S1. |
| V3 — the PM's 120-second `FuzzDecodeF3_16` campaign on the code subject, and corpus disposition | two campaigns of `go test ./contract/ledger -run '^$' -fuzz '^FuzzDecodeF3_16$' -fuzztime=120s -parallel=1` with `GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0`, each in a clean worktree. The first, on 5febae1 at 16:02 EST: exit 0 after 137 s (`ok` 123.8 s), 136,736 executions, 5 new interesting inputs (76 in the cached corpus), no crasher. Its executions stopped growing after 15 s while the single worker minimized new inputs. The second, on 8d42db1 at 16:42 EST, started from that cache: exit 0 after 155 s (`ok` 128.3 s), 207,106 executions, 16 new interesting inputs (92 in the cache), no crasher. Neither wrote to `testdata` |
| V6 — dependencies, imports and changed paths | No production or test import was added against the saved base import lists. The 17 changed paths, nine Go files and eight generated fixtures, are all under `contract/ledger`; no Core path changed. |
| V7 — module audit | `go mod tidy -diff` exited 0 with an empty log. `go mod verify` on 5febae1: all modules verified, exit 0; `go.mod` and `go.sum` unchanged from c89447f (empty diff) |
| V8 — regeneration and earlier-byte comparison | The coder's single `TestGoldenF3_16 -update` wrote only `testdata/f3/16`. The coder's before/after inventories hold 92 earlier fixture files, all unchanged; they omit `u3/61`'s log. `go test -count=1 ./contract/ledger -run '^TestGolden' -update` on 5febae1: exit 0, and `git status --porcelain -- contract/ledger/testdata` empty afterwards. All 101 testdata files equal the committed blobs; the 93 earlier files, `u3/61/log/00000000000000000001.jsonl` included, equal c89447f's blobs, so every earlier log digest in this record's table holds |
| V9 — new-fixture hashes and line endings | Eight new fixtures, seven hash-named object/body files and the log; the coder's audit found no CR byte. `git ls-files --eol contract/ledger/testdata/f3/16`: `i/lf w/lf` for the body, the log and object `a9d748d8…`; `i/none w/none` (no line terminator) for the four private objects under `objects/agents/…` and the empty object `e3b0c442…`; no CR byte in any of the eight files |

No local full gate or local V4 is supplied. The final public SHA's hosted Check is the integration gate under D153; the code-subject checks do not substitute for it.

## Earlier golden comparison

The following sixteen log digests remain unchanged. F3-13 uses D149's corrected chapter-13 digest; chapter 14 is F3-13's second golden under D163, unchanged by D164; F3-15's golden is unchanged by D166.

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
| `f3/15/log/00000000000000000001.jsonl` | D165/D166 | `d3cdec92ba04b16f704a738613b302c7321b5a38ef1429f252bfe6770479ca84` |

## Actual Core Open prefix proof

The coder's retained overlay test `TestT16ContinuationEarlierPrefix`, added to `./internal/core/agents` through `go test -overlay` with no product or test file changed, opened the golden's earlier-family prefix with real Core `Open`: exit 0, 24 commits opened, durable sequence 78, 0 issues and 1 pending loop, the F3-15 turn the continuation records reference. The prefix's SHA-256 is `f2ce57e0b023508de5a0ea883232782fcf0ca9c877cca61c3fc60c2622838797`. Core consumes no F3-16 record yet, so this validates the earlier-family setup only, not an F3-16 consumer, recovery or provider acceptance. It replaces the throwaway in-tree probe of earlier freezes.

## Joint completed-contract review

Fresh joint Fable review (ReviewT16S1) of code subject 5febae1939796e8f103e4292763e3c93df5ec8f0, its eight generated fixtures, the coder's and PM's evidence and this record together: approve with no blocking finding; the two F3-16 types, schema-7 submission and three-record group, closed operation/actor/schema sets, open-token writer values, conditional members, byte-wise sort and duplicate refusal, 65,536-byte input/output caps and the five-operation golden match P1 and amendments 1–7, 18 and 20; Defined is 61; all 93 earlier fixtures are byte-identical; the 24-commit prefix opened through real Core Open; and R1–R14 are true and public-safe, R8 and R9 accepted as record edits.

The review covers code subject `57a1930efc52b0ca9e33d0a9a9c1357c0a2a168f`, its generated fixtures, this evidence and the proposed record together. Its retained verdict is referenced below.

## D153 hosted integration — final public freeze-record subject

check 52 (run 42416675882, attempt 1, https://github.com/Darius-PJ/dwarf-harness/actions/runs/42416675882) on the record commit 8d42db1e71e9c9ffabfa1ca02c8b24da1454ea28, push event: `Check result` success; the full matrix ran because the record changes Go comments: `changes`, `Check / linux-amd64`, `Check / macos-arm64` and `Check / windows-amd64` (its race step included) all succeeded. `main` ba3f8cd → 8d42db1 on 2026-11-07 at 17:15:15 EST

## Retained raw evidence (D160)

References below bind raw artifacts by path and SHA-256; logs, receipts and verdicts are not copied into this record. The coder's files are under `C:/Users/darius.jones/worktrees/dwarf-harness/t16-s1-evidence/`.

| Artifact | Path and SHA-256 |
|---|---|
| Final coder report | `yield.json`, SHA-256 05fe522204dbf6b09873502f5d8a4d15caefedb530dc85748609f2f787f695b0 |
| Command journal, including the two first-attempt failures | `commands.jsonl`, SHA-256 21fb916080c9fb624fb3693ab5618904d491281bb81107199ea5731e0b9ff094 |
| Final tested-tree code and fixture hashes | `final-hashes.json`, SHA-256 5940a630272a7e8020c5c6f45c780f8ca329421944d60c3a2c32ec7d4d5be482 |
| Earlier-fixture inventories before and after | `earlier-before.json`, SHA-256 fcf8e849fb65b6a879c6540b106d2f4495c5c0137b540ad16e0b7af51d3fc80e; `earlier-after.json`, SHA-256 fcf8e849fb65b6a879c6540b106d2f4495c5c0137b540ad16e0b7af51d3fc80e |
| New-fixture hashes | `new-fixture-hashes.json`, SHA-256 0ddea6c3a6c9359a59beb74798401248ca596695ec774eb497497e474a01389a |
| The coder's final formatting, vet, staticcheck, focused, package, consumer, goldens, tidy, status, import and audit logs | `final-gofmt.log` `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`; `final-vet.log` `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`; `final-staticcheck.log` `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`; `final-focused.log` `17b889d41149e00c08db366d1f412b792c975dd97f269d2fb738a7fbcf631da8`; `final-package.log` `a0355fc1099cbdb0e5e9b3dbe9e2c6e7d47eabe25302fc3f89f4156743de6c79`; `final-consumer.log` `449276608309f2d916d76ee884d5be38cdec3d48e35c28da3716fb8320ce5d85`; `final-goldens.log` `8fb40a805088a593b2bb16eaf617d07fe66183724beccda6266b1851be7eadfc`; `final-tidy.log` `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`; `final-status.log` `8973ce28919a99c979b907062f767bfc1ae45fc71833f28f1934354ec2898dd0`; `final-imports-fixed.log` `42bfd6715e853cdb39344bf43c5a1dc998e155ed04c394e8834410c75450d1d8`; `final-testimports.log` `8a195f882c5eec9cad4598822be1a806107f7ffea50207be145ec0c5bb0bd7a6`; `final-import-audit.log` `025702c57958053a23f94f3551435f27b24196d5afe9a3438e4c999ec94308ae`; `final-audit.log` `9c2f2f84aca54e9af54bb9d83839cfe807d12f415cc346510f0c98bc3dabd374` |
| Core Open overlay source | `continuation_prefix_overlay_test.go`, SHA-256 `b30c273242d417549d9ab992cec63a939ac5f379a9d0c2479400fa144f34e36d` |
| Core Open overlay map | `prefix-overlay.json`, SHA-256 `5e046eb4f90cf3bd4c89d3e4168ef0d676df55ed3715aaa9dd963af08c798abc` |
| Core Open prefix-proof output | `prefix-proof.log`, SHA-256 945469da862733ed91070d7f1f4b260f1da5a16a2c19dcdf89e4afa7189b8fc3 |
| PM committed-blob, module, regeneration and line-ending proof | `C:/Users/darius.jones/worktrees/dwarf-harness/t16-pm-evidence/f3-16-evidence.log` `cdf6871be7dfded95014d14def99876d902a43cac9b86a7ad215bb12e9d50f44` (V3, V8, V9 and the ledgerstore consumer) and `C:/Users/darius.jones/worktrees/dwarf-harness/t16-pm-evidence/v7.log` `cd701aae8d9569657a8f91faa2abe91f461e7504703583b5484ef076a30f224f` (V7); the committed-blob check (`git cat-file` against the coder's final and fixture hashes, all equal) is in the PM's ticket notes |
| PM fuzz command, result, output and corpus disposition | `C:/Users/darius.jones/worktrees/dwarf-harness/t16-pm-evidence/f3-16-evidence.log` `cdf6871be7dfded95014d14def99876d902a43cac9b86a7ad215bb12e9d50f44` (first campaign) and `C:/Users/darius.jones/worktrees/dwarf-harness/t16-pm-evidence/f3-16-fuzz-2.log` `eb1acb8d26e8cfbc0e0a4b6d7661cd61c173e19cbda8ddf3e43a9c1891c858f1` (second) |
| Fresh joint advisor verdict and exact reviewed subjects | `local://t16-s1-review.md` `a41232bd051b10c849c790023931a179560ba7821b0a0da6dc8f4baf6b7b02fe` |
| Exact-final-public-SHA hosted Check receipt and jobs | `C:/Users/darius.jones/worktrees/dwarf-harness/t16-pm-evidence/check-42416675882-run.json` `e3e83f9f84a6709e7389e151c5c0a395372470d475af9283a10187a1ec0418b6` and `C:/Users/darius.jones/worktrees/dwarf-harness/t16-pm-evidence/check-42416675882-jobs.json` `394543ebaa4052e4da0665799e87ef5028772ea0513b21f06545d54beee12b16` |
