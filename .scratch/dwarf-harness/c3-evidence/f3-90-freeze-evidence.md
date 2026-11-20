# F3-90 freeze evidence — Ticket 90 S1

Freeze D174, 2026-11-20. Contract-code subject: `b367492b2f7cf3579ce3616c31b63b4c120c694f`. The final public freeze-record SHA is a separate subject in the D153 hosted result below, not a self-reference to this private file. The ticket-90 ruling's P1, compatibility rows and amendments 1, 2, 3, 5, 8, 11 and 12 govern. D125 requires one fresh joint review of this completed contract, its fixtures, evidence and proposed record; design approval is not that review.

## Scope and fixture identity

D174 covers the two version-1 F3-90 types added to `ledger-format` version 1, their codecs, value shapes, decoder and group rules, the schema-8 canonical submission, the closed state, actor, operation and refusal-stage sets, the open-token writer values, the 65,536-byte cap, the eligibility reading and the schema 1–8 command lookup. The specification is the F3-90 section of `contract/ledger/doc.go`; the public catalogue is in `docs/CONTRACTS.md`. The owner's Service methods, the session interface, scheduler policy, private object schemas, a later Core-originated hold and later families are excluded. No hold, fence, first-action entrance, recovery or money claim follows from this codec freeze.

Golden `contract/ledger/testdata/f3/90/log/00000000000000000001.jsonl`: **44 commits, 139 records**, SHA-256 **`87b37b38a47f9dc964e1c60f66991711268c919d02325319192e32cc1b9cea92`**, with seven generated hash-named object/body fixtures beside it. `Defined()` rises from **61 to 63**: the two F3-90 entries join the 61 of D169 (`contract/ledger/catalogue.go:76-138`), and `TestNewCatalogue` asserts the exact set.

| Group (sequences) | Coverage |
|---|---|
| Earlier-family prefix (1–69) | the first 21 commits of F3-16's chapter: F3-10, F3-11 and F3-13 setup |
| `eligibility.hold` (70–72) | from `eligible`: new operation, `ordinary_work_ineligible`, `explicit_hold`, version 1 |
| `eligibility.release` (73–75) | `eligible`, `none`, version 2 |
| `eligibility.require_first` (76–78) | from `eligible`: new operation, `first_action_required`, `first_action`; initial and permitted turn equal, in a work context with a task binding; version 3 |
| `eligibility.first_refused` (79–81) | actor `core`: refusal `turn_admission`, `unavailable` of the declared turn; state, reason and identities unchanged; version 4 |
| `eligibility.first_next` (82–84) | permitted turn advanced to the turn admitted next, refusal cleared, initial declaration kept; version 5 |
| The declared first turn (85–121) | the 12 later commits of F3-16's chapter, shifted by 15: F3-11 admission of the permitted turn (85–87) and a further F3-11 group (88–90), F3-15 binding (91–93), six F3-16 owner groups (94–111), F3-11 cancelled ending (112–114), F3-15 `loop.end` (115–118), F3-16 close (119–121) |
| `eligibility.first_next` (122–124) | after that turn's native, F3-15 and F3-16 endings: a fresh turn; version 6 |
| `eligibility.hold` (125–127) | from `first_action_required`: operation and declaration kept as history, `ordinary_work_ineligible`, `explicit_hold`; version 7 |
| `eligibility.release` (128–130) | `eligible`, declaration kept as history; version 8 |
| `eligibility.hold` (131–133) | from `eligible`: new operation, declaration cleared; version 9 |
| `eligibility.require_first` (134–136) | from the ordinary hold: hold operation kept, new action and declaration; version 10 |
| `eligibility.release` (137–139) | `eligible`; version 11 |

These positions are read from the committed golden and its generator, `contract/ledger/eligibility_golden_test.go:37-149`. `TestGoldenF3_90` requires three holds, three releases, two first-action requirements, two advances and one refusal (`eligibility_golden_test.go:461`). `TestEligibilityGoldenBindingsAndRestart` refuses every F3-90 group with its records reordered or its origin, turn, actor, effect, command, version, held operation or expected operation corrupted, and a second reader rebuilds the final snapshot, version 11, without changing the log (`eligibility_golden_test.go:468-540`). The golden exercises both types, all five operations and both require-first edges, not every writer token or refusal code; the codec rows of `contract/ledger/eligibility_test.go` cover an unknown state's refusal and an unfamiliar reason that stays held.

## D152 focused evidence

The coder's final runs used `GOTOOLCHAIN=local`, empty `GOFLAGS` and `CGO_ENABLED=0`. The retained command journal gives each invocation, exit and log path.

| Step and coverage | Observed result |
|---|---|
| V1 — the coder's final formatting, vet and staticcheck; committed-blob agreement | `gofmt -l` on the eight changed Go files, `go vet ./contract/ledger` and staticcheck on `./contract/ledger` exited 0 with empty logs. The PM matched all 16 committed blobs of b367492, eight Go files and eight fixtures, to the coder's final hashes with `git cat-file`. |
| V2 — the coder's focused and plain contract runs; real consumer | The focused selection of the F3-90, eligibility, golden, `Defined` and catalogue tests exited 0; the first development run, before the golden existed, exited 1 only because the fixture directory was missing. The plain verbose `./contract/ledger` run passed in 9.531 s; `TestGoldenF3_90` reports the golden's commits, records and all five operation shapes, and the F3 and F-U3-61 golden tests log their digests, equal to the table below. `./internal/core/ledgerstore` passed in 26.692 s. Codec only: no race run or mutation campaign is claimed, and the ruling requires none for S1. |
| V3 — the PM's 120-second `FuzzDecodeF3_90` campaign on the code subject, and corpus disposition | two campaigns of `go test ./contract/ledger -run '^$' -fuzz '^FuzzDecodeF3_90$' -fuzztime=120s -parallel=1` with `GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0` in S1's clean worktree at b367492: the first exited 0 (`ok` 121.2 s) after 842,203 executions with 23 new interesting inputs (corpus 102 to 125) and no crasher; the second, on the warmed cache, exited 0 (`ok` 121.5 s) after 963,914 executions with 7 more (125 to 132) and no crasher. Both progressed in bursts between the single worker's minimization pauses; the new inputs stay in the local fuzz cache, not in the repository |
| V6 — dependencies, imports and changed paths | No production or test import was added or removed against the saved base import lists. The 16 changed paths, eight Go files and eight generated fixtures, are all under `contract/ledger`; no Core path changed. |
| V7 — module audit | `go mod tidy -diff` exited 0 with an empty log, and `go mod verify` reported all modules verified; `go.mod` and `go.sum` are not among the changed paths. |
| V8 — regeneration and earlier-byte comparison | The coder's two `TestGoldenF3_90 -update` runs wrote only `testdata/f3/90`; the second, under PM answer 1, changed only the log (below). The coder's inventories before, after the second generation and final hold 100 earlier fixture files, all unchanged; they omit `u3/61`'s log, whose digest the package run logs unchanged. `go test -count=1 ./contract/ledger -run '^TestGolden' -update` on b367492 in the PM's `gate` worktree: exit 0, and `git status --porcelain -- contract/ledger/testdata` empty afterwards. All 109 testdata files were hashed: the 8 new F3-90 files equal the coder's map, and the 101 earlier files, `u3/61/log/00000000000000000001.jsonl` included, equal 00187fa's blobs, so every earlier log digest in this record's table holds |
| V9 — new-fixture hashes and line endings | Eight new fixtures, seven hash-named object/body files and the log; the coder's audit found no CR byte, and `TestGoldenF3_90` fails on one (`eligibility_golden_test.go:435-436`). `git ls-files --eol contract/ledger/testdata/f3/90`: `i/lf w/lf` for three files (the log, the body `91bcc3db…` and object `a9d748d8…`) and `i/none w/none` (no line terminator) for five (the four private objects under `objects/agents/…` and the empty object `e3b0c442…`); no CR byte in any of the eight files |

No local full gate or local V4 is supplied. The final public SHA's hosted Check is the integration gate under D153; the code-subject checks do not substitute for it.

## Earlier golden comparison

The following seventeen log digests remain unchanged. F3-13 uses D149's corrected chapter-13 digest; chapter 14 is F3-13's second golden under D163, unchanged by D164; F3-15's golden is unchanged by D166.

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
| `f3/16/log/00000000000000000001.jsonl` | D169 | `fea39fda76e2946cfa67a466127014249006684e2a1c0258a7685a948d91ecf9` |

## Second generation before freeze (PM answer 1)

The first generation's Core `Open` already reached all 139 records with 0 issues, but the three declarations that are never admitted, the refused initial turn and the two later declared turns, carried input digests over descriptive text instead of the canonical schema-1 owner-request preimage the F3-90 section specifies; the admitted turn's digest was right. PM answer 1 allowed one more `-update`, limited to `^TestGoldenF3_90$`, because the fixture was not yet frozen and must carry the specified digest. It required both fixture hash maps, the exception listed in the coder's deviations, the earlier comparison and the Core `Open` proof re-run on the regenerated golden, and no third generation without asking. The second generation changed only the log, from `b3e58b02548730ff76aeef58bc1ba937d18487cdfb69ce49c10e7c137e0c4c87` to `87b37b38a47f9dc964e1c60f66991711268c919d02325319192e32cc1b9cea92`; the seven object/body fixtures kept their names and bytes. The final proof, hashes and inventories use the second generation, and there was no third. Separately, a development-only guard row at 65,536 and 65,537 bytes in `TestEligibilityNumbersTokensAndBounds`, which asserted values unreachable through the public payloads, was removed before commit; no earlier test or row was removed or renamed.

## Actual Core Open proof over the whole chapter

The coder's evidence-only overlay test `TestT90EarlierGroupsOpen`, run in `./internal/core/agents` through `go test -overlay` with no file on disk changed, extends the existing real fixture loader with chapter 90's colony identity and opens the complete golden with real Core `agents.Open` twice, without filtering or resequencing: exit 0, durable and projection sequence 139 on both passes, 0 issues and unchanged log bytes. It reports each of the chapter's 33 earlier-family groups, from F3-10's at 1–6 to F3-16's close at 119–121, with 0 issues, the 12 commits after the first F3-90 records included. Core consumes no F3-90 record yet and passes over them, so this validates every earlier-family group in the chapter, not an F3-90 consumer, hold, fence or recovery. The same run's `TestContinuationFrozenReplay` replays the frozen chapters 10, 11, 12, 13, 14, 139, 15 and 16. This closes ticket 16's gap, whose proof opened only the prefix before the new family. The overlay test, its map and the coder's scripts were deleted after the first run and, at the PM's request, restored byte for byte against `cleanup.json`'s SHA-256s; the re-run from the restored files, `core-open-restored.log`, again reached durable and projection sequence 139 on both passes with 0 issues and listed the same 33 earlier-family groups, so the proof is re-runnable from retained sources.

## Joint completed-contract review

The fresh joint advisor review of code subject b367492b2f7cf3579ce3616c31b63b4c120c694f, its eight generated fixtures, the coder's and the PM's evidence and this freeze record together found no blocking finding and approved the freeze, with the two record changes it required (amendment 3's `loop.bind` identity rule stated whole in the F3-90 section, the decision entry and `CONTRACTS.md`, and the restored, re-run Core `Open` proof stated here) applied as worded in the retained verdict.

The review covers code subject `b367492b2f7cf3579ce3616c31b63b4c120c694f`, its generated fixtures, this evidence and the proposed record together. Its retained verdict is referenced below.

## D153 hosted integration — final public freeze-record subject

check 112 (run 44713385628, attempt 1, https://github.com/Darius-PJ/dwarf-harness/actions/runs/44713385628) on the record commit 4cf6ecd1827221a1bea006a5f5e251381cfe4ee1, push event: `Check result` success; the full matrix ran because the record changes Go comments: `changes` success; `Check / macos-arm64` success; `Check / windows-amd64` success; `Check / linux-amd64` success; `Check result` success (each platform job's race step included). `main` 00187fa then moved to 4cf6ecd (reflog 2026-11-20 05:39:50 -0500, pushed 05:39:52)

## Retained raw evidence (D160)

References below bind raw artifacts by path and SHA-256; logs, receipts and verdicts are not copied into this record. The coder's files are under `C:/Users/darius.jones/worktrees/dwarf-harness/t90-s1-evidence/`.

| Artifact | Path and SHA-256 |
|---|---|
| Final coder report | `yield.json`, SHA-256 4da8f5cf31b9cf8a8f73cd951c90f072a7ad73875ab1bb79166bf0a06a922179 |
| Command journal, including the development run before the fixture existed | `commands.jsonl`, SHA-256 522e07caa9373426efa46d7abd95f5f4b786cf2d298ddd8b154c5bbc85bbcce9 |
| Final tested-tree code and fixture hashes | `final-hashes.json`, SHA-256 24e36aa0f4fc9297cf15de2857223d19525e14ce53a60969ecef8a491a7238ae |
| Earlier-fixture inventories before, after the second generation and final | `earlier-before.json` 73f5b2584f5664143175f6c3baed7efedfec7595db50f840974f617ed99ea22f; `earlier-regenerated.json` 73f5b2584f5664143175f6c3baed7efedfec7595db50f840974f617ed99ea22f; `earlier-final.json` 73f5b2584f5664143175f6c3baed7efedfec7595db50f840974f617ed99ea22f |
| New-fixture hashes of both generations and final | `new-fixture-first.json` 3e6bb8e01f82f6c17fc6487696aa8a4f886a07ff2a48d23e6441ad0716b93485; `new-fixture-second.json` ec3dd5669b968575bd39ae0f111ff619c851da8f09777bffbba1809134ef5b9e; `new-fixture-final.json` ec3dd5669b968575bd39ae0f111ff619c851da8f09777bffbba1809134ef5b9e |
| Generation and development logs, first generation included | `development.log` ea1b329a186c739ff9bdff684459e773cf5bf27f81d619b1f8f5a733a602c031; `golden-update.log` 29c641f76f219aecb67a22a079a92a692720ac3b94fe78e54ebd72fc88b56f59; `development-generated.log` 992407d1eec6ea1c0e0bebcbe8e8c9c1f912917f16bee8ed1d1d8eb254048f8f; `core-open-development.log` c9d638d8b2c4011c7f28e5934bfc676cfd455e07e4cca3efe05df5345cfdbeda; `golden-update-second.log` 8c6563e9da45087def84ce3a7b3620e57b81642e7f3e355144adb7de295d7f7f; `regenerated-audit.log` 3f91fd69a0c7dad96e1b75492cd75e0b303133a87c8af14e985b1049358e6eb6 |
| The coder's final formatting, vet, staticcheck, focused, package, audit, module, status, import and timing logs | `gofmt.log` e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855; `vet.log` e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855; `staticcheck-build.log` e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855; `staticcheck.log` e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855; `focused.log` 0ef8483187ecd994edfef424835ad23e33fbc4349293e9040919ae82f17d5ebc; `package.log` 79d84120d07ab41438942c5e5134b7abe704fde7c53f5d084b80e891f909804c; `final-audit.log` 5a168d1c552c8c61bc4a2f43a5876063ed224dd99e8e707b713e40608cd016d6; `tidy.log` e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855; `modules.log` b4537ed75f533f993f371954de47e42a793b8e5b0587577de7e27fb3e50696bd; `status.log` 4084fb26857e80a49964b50b9e84b53f442b6713e9b75bdd6b6d7cfa9ffd6aaa; `imports.log` 42bfd6715e853cdb39344bf43c5a1dc998e155ed04c394e8834410c75450d1d8; `testimports.log` 8a195f882c5eec9cad4598822be1a806107f7ffea50207be145ec0c5bb0bd7a6; `nonstandard-imports.log` e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855; `import-audit.log` d38f874a4a6df3a7ed30d772e9910fbf9ed6ead839dc6918e4d4300c2ef35540; `import-audit.json` 7b8ee83fb93a566830c1624f3fc5ece1f3b94a80f46741f84788af5df4f66e3c; `base-imports.txt` 42bfd6715e853cdb39344bf43c5a1dc998e155ed04c394e8834410c75450d1d8; `base-testimports.txt` 8a195f882c5eec9cad4598822be1a806107f7ffea50207be145ec0c5bb0bd7a6; `timing.log` 102ed112d3ce7ec517517c52b1a8069ad3ff6a8e5012bf32a5a985366758c135; `timing.json` eeec8fec8facee61a56fd482ed80bd5916b211c056bda4bd2e09565db5cb52fe |
| Core Open proof output | `core-open.log`, SHA-256 1bebc232464ed66516e0436bb8432b531bd093c1dc7ffacb4bdc17c7d6221758; re-run from the restored sources: `core-open-restored.log`, SHA-256 4e5fbcd410b34e417f6bc47af245254d0c2267f402d6300c8f9c6201c97b5acf |
| Restored overlay sources, map and scripts (hashes as bound by `cleanup.json`) | `cleanup.json`, SHA-256 de78a802600149bc6a6f163d347c821782de213af98fe789339850add5fdf482, which binds `core_open_test.go` `598afa9adbfa71933492cf1797428a7316b95f92f618824f9c4e746b94424f61`, `scoped_golden_overlay_test.go` `7336e2e843f9af18d38a5b63d7f4654c3b91e28127dd17a884a298a493fc70f5`, `core-open-overlay.json` `932b6808b24a62ab1e70b2a08a6bc8860b97419c8b1b9270f9908243e05e531a` and four scripts |
| PM committed-blob, regeneration and line-ending proof | `C:/Users/darius.jones/worktrees/dwarf-harness/t90-pm-evidence/s1-committed-blobs.json` 37d23477a6b9d54b254a16e05f229c8c75d3031dcd4320b0c52aea1b111c7648; `C:/Users/darius.jones/worktrees/dwarf-harness/t90-pm-evidence/f3-90-evidence.log` eaba52bf3b511322dbcbcd6a5024bdb146fb9696f2d6f972a1d56f58d0cff83f |
| PM fuzz command, result, output and corpus disposition | `C:/Users/darius.jones/worktrees/dwarf-harness/t90-pm-evidence/s1-fuzz-FuzzDecodeF3_90.log` 5689b9579bb82fa10a006836af4b03762714bb09a32807621f579b28171c3d99; `C:/Users/darius.jones/worktrees/dwarf-harness/t90-pm-evidence/s1-fuzz-FuzzDecodeF3_90-second.log` 0458647f5e5e8fe9e6f9949c46abb590f70c75661d2dde7331e9c93ea8187ec5 |
| Fresh joint advisor verdict and exact reviewed subjects | `local://t90-s1-review.md` f65c0d19e4ec2157fd9d452bd032648f1d4df22e886274c79ff5e70b9085a522 |
| Exact-final-public-SHA hosted Check receipt and jobs | `C:/Users/darius.jones/worktrees/dwarf-harness/t90-pm-evidence/check-44713385628-run.json` dbb3936b223d41668a184c118a2b1bc3538c01d578551948e2fa70de34cec3a3; `C:/Users/darius.jones/worktrees/dwarf-harness/t90-pm-evidence/check-44713385628-jobs.json` dd96c77bab872971fe46ec42b5a99e5e92581301935390f00feae0ab44e18baf |
