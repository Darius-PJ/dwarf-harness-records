# F3-150 freeze evidence — Ticket 150 S1

Freeze D187, 2026-11-27. Contract-code subject: `0f57e6825937d38b6767508d1514edce5d9c7672`. The final public freeze-record SHA is a separate subject in the D153 hosted result below, not a self-reference to this private file. The ticket-150 ruling's P3 and amendments 1, 2, 3, 6, 7, 12 and 13 govern: amendment 1 is the binding statement of the family, and amendment 13 holds schema 12 whatever the freeze order. D125 requires one fresh joint review of this completed contract, its fixtures, evidence and proposed record; design approval is not that review.

## Scope and fixture identity

D187 covers the two version-1 F3-150 types added to `ledger-format` version 1, their codecs and presence rules, the group `[ledger.command, runtime.setup_applied, ledger.body_pin?, runtime.setup_receipt]`, the schema-12 canonical submission with its six closed operations, argument orders, target kinds and actor `owner`, the submission and body-set digests, the receipt's open outcome and revision, the 65,536-byte cap and the state rules, as the F3-150 section of `contract/ledger/doc.go` states them (`doc.go:3778-3900`); the public catalogue is in `docs/CONTRACTS.md`. `internal/core/setup` and its API, the review-file format, the terminal commands, the host-settings document's members (amendment 6: no ticket-17 member) and later families are outside it.

Golden `contract/ledger/testdata/f3/150/log/00000000000000000001.jsonl`: **12 commits, 42 records**, SHA-256 **`5ca25d888af6cb1f283be2af0f362e424b255cf3ae5e021af53c227ea815edda`**, with eight generated fixtures beside it: five hash-named bodies, two hash-named objects (the shared `a9d748d8…` and the empty `e3b0c442…`) and `body-set-preimage.txt`, whose SHA-256 is the golden's `body_set_sha256` `bd0137dd…`. The setup records use the fresh prefix `019a1500-`; the native groups reuse F3-11's workspace ID `019a1100-0000-7000-8000-000000000400`, its capture-inputs body `3b916c58…` and synthetic `common_dir`, and the `0199c000-` agent, session and context identities of F3-11's chapter. `Defined()` rises from **68 to 70** against base 97c8b50: the two F3-150 entries join the 68 of D175 (`contract/ledger/catalogue.go:79-154`), and `TestNewCatalogue` asserts the exact set (`catalogue_test.go:7-126`).

| Group (sequences) | Coverage |
|---|---|
| `colony.create` (1–3) | the log's first commit: colony target, expected revision 0, no arguments; receipt revision 1 |
| Native F2-05 registration (4–6) | `workspace.registered`, `workspace.capture_inputs_pinned` and `ledger.body_pin`: F3-11's workspace, synthetic `common_dir` `C:/fixture/scoped-repo/.git`, body `3b916c58…` |
| `workspace.register` (7–9) | expected revision 0, the native capture-inputs digest `3b916c58…`; receipt revision 1 |
| Native F2-05 input update (10–12) | `workspace.capture_inputs_pinned`, `ledger.body_pin` and `ledger.body_unpin`, body `627b5e65…` |
| `workspace.inputs` (13–15) | expected revision 1, digest `627b5e65…`; receipt revision 2 |
| Native F3-10 agent registration (16–21) | `ledger.command`, `runtime.agent_registered`, `runtime.context_created`, two `private.revision` and `runtime.command_receipt` |
| `context.set`, General context (22–24) | context target with `agent_id`, expected revision 0, no task binding; receipt revision 1 |
| Native F3-10 work-context creation (25–28) | `ledger.command`, `runtime.context_created`, `private.revision` and `runtime.command_receipt` |
| `context.set`, work context (29–31) | with a task binding, expected revision 0; receipt revision 1 |
| `context.set`, work context again (32–34) | changed title and output ceiling, expected revision 1; receipt revision 2 |
| `startup.set` (35–38) | four-record group: the 3-byte settings body `ca3d163b…` in `body_refs` on the applied record and the pin; receipt revision 1 |
| `checks.publish` (39–42) | four-record group: bodies `018b3a03…` and `9398596b…`, `body_count` 2, `body_set_sha256` `bd0137dd…`; receipt revision 1 |

These positions are read from the committed golden and its generator, `contract/ledger/setup_test.go:83-145`. `TestGoldenF3_150` checks every fixture's bytes, content address and absence of CR (`setup_test.go:166-174`), 12 commits through record 42 (`:176-179`), and all six operations, both group shapes, the three digests' agreement, revision progression, the exact startup body and the body-set preimage (`:180-285`). `TestSetupSubmissionRefusals` refuses a `context.set` missing one `turn_policy` member, a context target without `agent_id` and an argument of another operation (`:17-34`). Under D181 there is no fuzz target, rule-break proof or rejection table (S1 note 10).

Two facts about the golden, noted by the review: the setup pin's `pin_id` is fixed only by F0's rule, and the golden writes the command ID (seqs 37 and 41); and the three `context.set` groups (seqs 23, 30 and 33) carry `turn_policy` values outside today's agents template bounds (`max_discovery_entries` 32 against a 10-entry catalogue; `max_search_matches` 128 above `max_search_entries` 64). The codec accepts shape only; a real `context.set` preflight would refuse these values, so the golden is codec proof, not a producer-written history.

## D152 focused evidence

The coder's final runs used `GOTOOLCHAIN=local`, empty `GOFLAGS` and `CGO_ENABLED=0`. The command journal in the coder's report gives each invocation, exit and log path, and `final-checks.json` the executables, argv, environment and wall times.

| Step and coverage | Observed result |
|---|---|
| V1 — the coder's final formatting, vet and staticcheck; committed-blob agreement | `gofmt -l contract/ledger`, `go vet ./contract/ledger` and staticcheck, built into the evidence folder and deleted after use, on `./contract/ledger` exited 0 with empty logs. The PM matched all 15 `finalHashes`, six Go files and nine fixtures, and the nine golden hashes to the committed blobs of 0f57e68. |
| V2 — the coder's plain contract and store runs; real consumer | The plain verbose `./contract/ledger` run passed in 7.265 s: `TestGoldenF3_150` logs 12 commits, 42 records, eight setup groups and `Defined` 70 (`ledger-test.txt:3602`), and `TestSetupSubmissionRefusals` and `TestNewCatalogue` pass. `./internal/core/ledgerstore` passed in 21.319 s with its existing opt-in skips unchanged. Codec only: no race run is claimed. The real Core `Open` proof is below. |
| V6 — dependencies, imports and changed paths | No production or test import was added or removed: the base and final import lists compare equal. `./contract/ledger` depends on the standard library only. One import-list invocation exited 1 on the coder's runner quoting and was rerun correctly; no package check depended on it. The 15 changed paths, six Go files and nine generated fixtures, are all under `contract/ledger`; no Core path changed, and the probe was an overlay that wrote nothing into the worktree. |
| V7 — module files | No module audit was assigned or run for S1; `go.mod` and `go.sum` are not among the changed paths, and no dependency was added (V6). |
| V8 — regeneration and earlier-byte comparison | The coder generated the golden once, `go test -count=1 -v -timeout=19m ./contract/ledger -run '^TestGoldenF3_150$' -update` (exit 0), which logged the nine new files' digests, equal to the final hashes (`golden-update.txt:4-13`); only that test writes `testdata/f3/150`, and the later package run read the same bytes. On `0f57e68`, `go test -count=1 ./contract/ledger -run '^TestGolden' -update` exited 0 and `git status --porcelain -- contract/ledger/testdata` was empty; the nineteen earlier log blobs equal this table's digests, and the diff against `main` adds only the nine `f3/150` files (`f3-150-v8-v9.log`, `f3-150-earlier-digests.txt`) |
| V9 — new-fixture hashes and line endings | Nine new fixtures: the log, the body-set preimage, five bodies and two objects, each equal to the coder's final hash, the bodies and objects named by their SHA-256; `TestGoldenF3_150` fails on any CR byte or wrong address (`setup_test.go:166-172`). `git ls-files --eol contract/ledger/testdata/f3/150` shows six files `i/lf w/lf` and three `i/none w/none` (two compact bodies and the empty object); a CR scan of all testdata found none (`f3-150-v8-v9.log`) |

No local full gate or local V4 is supplied, and no fuzz campaign is run under D181. The final public SHA's hosted Check is the integration gate under D153; the code-subject checks do not substitute for it.

## Earlier golden comparison

The following nineteen log digests remain unchanged. F3-13 uses D149's corrected chapter-13 digest; chapter 14 is F3-13's second golden under D163, unchanged by D164; F3-15's golden is unchanged by D166, and F3-91's by D183, which changed no frozen byte. The coder's package run logs ten of them (`ledger-test.txt:2857-4008`: F-U3-61 and the F3 chapters 10 to 90); F0's three, F2's five and F3-91's pass their golden tests in the same run without logging a digest, and On `0f57e68`, `go test -count=1 ./contract/ledger -run '^TestGolden' -update` exited 0 and `git status --porcelain -- contract/ledger/testdata` was empty; the nineteen earlier log blobs equal this table's digests, and the diff against `main` adds only the nine `f3/150` files (`f3-150-v8-v9.log`, `f3-150-earlier-digests.txt`) compares every earlier blob with this table.

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
| `f3/90/log/00000000000000000001.jsonl` | D174 | `87b37b38a47f9dc964e1c60f66991711268c919d02325319192e32cc1b9cea92` |
| `f3/91/log/00000000000000000001.jsonl` | D175/D183 | `c63ca61744f447746a6540893f1458e83fcacc8ff996f37d741601b3b96750e5` |

## Before freeze: the project manager's decisions

Four decisions settled points the ruling left to the project manager:

1. **Schema 12 by the per-ticket reservation.** Tickets 17, 30 and 150 hold schemas 10, 11 and 12, which may land in any order; amendment 13 keeps 12 whatever the order, and the codec assumes no relation to the largest schema present (`doc.go:3782-3783`).
2. **The catalogue test's additive update.** `TestNewCatalogue` pins the exact `Defined()` list, 68 at base. S1 added its two entries by addition with nothing else changed (`catalogue_test.go:111-112`), and the later of the parallel contract slices to land rebases the list.
3. **The synthetic `C:/fixture/scoped-repo/.git`,** reused from the existing `scopedInputs()[4]` for F2-05's absolute `common_dir`. Synthetic portable paths are allowed; no real or private machine path is in the code or fixtures.
4. **The overlay Core probe.** A `go test -overlay` test added virtually under `internal/core/agents`, with no worktree change; its source and map were deleted after use, as S1 note 9 requires of the throwaway probe.

## Actual Core Open proof over the whole golden

The coder's evidence-only overlay test `TestT150CoreGoldenProbe`, run in `./internal/core/agents` through `go test -overlay` with no file in the worktree changed, opened the golden as written, all 12 commits including the eight F3-150 groups, with the real Core of S1's tree (base 97c8b50; S1 changed no Core path). Nothing was removed or re-chained. `ledgerstore.Open` reported 12 groups through record 42 with no truncated bytes; the probe then published the five exact fixture bodies through ledgerstore. `agents.Open` accepted every group with no private integrity issue, and `workspace.Open` accepted every group with no missing capture input. Its one pending item is F3-11's workspace as `workspace_unverified`, because the synthetic `common_dir` does not exist on disk; that is the intended state, not a refused group or missing input, and no fixture depends on the path existing. The log's SHA-256 stayed `5ca25d88…` through `Open`. A first run, which copied the bodies into place instead of publishing them, left the input-update body `627b5e65…` unavailable to workspace (`inputs_unavailable`); the corrected run changed only the probe's hydration, with no product or fixture change. The probe source and overlay map were deleted after use; both output logs are retained.

## Joint completed-contract review

Approve: reading the ruling (P3, amendments 1-3, 6, 7, 12, 13, notesForS1), the assignment, the six changed Go files, the 42-record golden with its eight side fixtures, the coder's and PM's logs and all 17 record edits at 0f57e68, I found the two types, the schema-12 submission, the six operations, the group, the digests, the codec rules and doc.go's state rules as amendment 1 fixes them, earlier bytes unchanged with Defined() 68 to 70, the real Core Open proof covering the unfiltered golden, and the freeze record accurate and public-safe; no blocking finding, no command run, nothing edited.

The review covers code subject `0f57e6825937d38b6767508d1514edce5d9c7672`, its generated fixtures, this evidence and the proposed record together. Its retained verdict is referenced below.

## D153 hosted integration — final public freeze-record subject

run 148 (46050994002, https://github.com/Darius-PJ/dwarf-harness/actions/runs/46050994002) on `f517b6c2edfafe17b0d404e4df429ca13d3a4aab`, attempt 1: changes success, Check / windows-amd64 success, Check / macos-arm64 success, Check / linux-amd64 success, Check result success

## Retained raw evidence (D160)

References below bind raw artifacts by path and SHA-256; logs, receipts and verdicts are not copied into this record. The coder's files are under `C:/Users/darius.jones/worktrees/dwarf-harness/t150-s1-evidence/`. Its probe source, overlay map, final-check runner source and temporary staticcheck build were deleted after use (`cleanup.txt`), and their outputs are retained.

| Artifact | Path and SHA-256 |
|---|---|
| Final coder report, with the command journal and the final tested-tree hashes | `yield.json`, SHA-256 5dfecec6618537b65da2a258e343bff1418dfa0d6f06022f44e0fa9d578f9191 |
| Golden generation, final runs, run manifest, final hashes and cleanup | `golden-update.txt` 36f4665d34b88827314e9c8b16d0813252c315921efbd523713d642173c8d34c; `ledger-test.txt` e4499d981c56d543fc1a257feb866ec72c2ce0268c5b1b79c67b9f43c0096f29; `ledgerstore-test.txt` 7f108e63f190aec64b490c7f1bc762e04ed142233149c772d5a8534f8ddaafd2; `gofmt.txt` e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855; `vet.txt` e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855; `staticcheck-build.txt` e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855; `staticcheck.txt` e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855; `final-checks.json` e6b82342e9d155c6a250fc587c7e22f434a8f616fe14d8a8939170b3b90a3795; `final-sha256.txt` 49311f3c4556051c16543113bb0d3881fc4b432bf1c291f96b867c6011e76dc5; `cleanup.txt` 43106fb7d1c0839c0d9de3aad27b88cca884f3927cd907a75d235c8cb45430a6 |
| Base and final import lists and the dependency list | `base-imports.txt` 42bfd6715e853cdb39344bf43c5a1dc998e155ed04c394e8834410c75450d1d8; `base-test-imports.txt` 8a195f882c5eec9cad4598822be1a806107f7ffea50207be145ec0c5bb0bd7a6; `imports.txt` 3f92a16ec774c633deb6bcb2cda39e602f8ecad1c09dadacc1608326be75c640; `imports-final.txt` 42bfd6715e853cdb39344bf43c5a1dc998e155ed04c394e8834410c75450d1d8; `test-imports-final.txt` 8a195f882c5eec9cad4598822be1a806107f7ffea50207be145ec0c5bb0bd7a6; `deps.txt` 3fed9c60a19efaba835fb8ec05d7731ca7d6c696023c05c67b2f9cf8c48797a4 |
| Core Open proof output, first and corrected | `core-probe.txt` bbbe4d7ac2eda17fa7ecbb6d68dd4d1841d1af14549f00e23745f8bd4f2a4c45; `core-probe-published-bodies.txt` d6103d6c35c805dfab9fab4b1e1827230f46ac2205ca97938af52fbf4a64d835 |
| PM committed-blob, regeneration and line-ending proof | `f3-150-committed-blobs.txt` e454a7252d2b20710e2fa5c81794fb5e83ece827576e28a127424d4e16850026; `f3-150-v8-v9.log` 070658da2342fa88792c5399d2f5f01fe63e9fa4a8433fb7412eafc28ba7c9fb; `f3-150-earlier-digests.txt` 9cfd41778cdb358b8aa1e3dc1be8dd11c05d211d4e453e685036e12646ba3cf6 |
| Fresh joint advisor verdict and exact reviewed subjects | `t150-s1-review.md` (PM session records) fe58834860cbf1a9fdfa8b11b36a5117645e11cf537285d10fac4ef671728407 |
| Exact-final-public-SHA hosted Check receipt and jobs | `check-46050994002-run.json` 70b79e1871021495b7ab145656a105032172f12bc00855ac21d6055afa8f43d0; `check-46050994002-jobs.json` e490b0e42d2b0ef94729974caa46d3c65be275120cc5bab5b581aabf78b5191d |
