# F3-139 freeze evidence — Ticket139 S1

Freeze D154, 2026-10-28. Contract-code subject: `86f952cfcae37bde06767c6c4eaa615a503dd96d`; actual base: `82d8d48856c7191019625c9f6e896d10b9b8498c`. The final public freeze-record SHA is a distinct subject in the D153 hosted section below, not a self-reference to this private record. The amended ruling governs (the amended design ruling, retained with the whole-ticket packet and archived at ticket close); D125 requires joint review of the completed contract, fixtures, evidence and proposed record, not design approval alone.

## Scope and subjects

S1 adds four version-1 codecs/catalogue entries, schema 5 and the generated chapter-139 log/object/body fixtures under `contract/ledger`. The authorized compatibility-test cutovers delete only the obsolete internal catalogue-length assertion in `paid_compatibility_test.go` and replace `catalogue_test.go`'s stale private-map equality with public `Defined().Contains` version-admission checks, preserving the existing wire-type/version, invalid-input and fixture-rejection coverage (PM answers 1–2 in the retained ticket notes). No count is repinned. Probe-only agents test/helper changes must be removed/restored before final hashes. The final changed-path/hash inventory is in V6; it must match the committed subject.

The retained evidence root is `C:/Users/darius.jones/worktrees/dwarf-harness/t139-s1-evidence`; complete command records are commands.json/final-commands.txt, final coder report is yield.json, and PM commit/fixture/earlier-golden/fuzz proofs are retained in the secondary PM packet. The command records identify actual invocations, environment, exit, duration and retained output. The assigned production environment is Go 1.27.3, `GOTOOLCHAIN=local`, empty `GOFLAGS`, explicit `CGO_ENABLED=0`, host windows/amd64. D152 applies focused local evidence: no S1 local race/×20 because this is codec-only, no five-target static work without build-constraint changes, no duplicate local full gate or unrequested measurement. The PM owns the affected 120-second fuzz campaign. Actual observations belong in the result cells, not inferred from these requirements.

## D152 focused evidence

| Step and required coverage | Observed result and retained evidence |
|---|---|
| V1 — coder's final `gofmt -l` on owned Go files, host `go vet` and host staticcheck for `./contract/ledger`; tested-tree/final-blob agreement | PASS: final owned-only `gofmt -l` on9 Go files had empty output (14-format_check.log); `go vet ./contract/ledger` exit0,0.624s (15-vet.log); `go tool staticcheck ./contract/ledger` exit0,2.291s (16-staticcheck.log). Final tested-tree hashes match all13 committed blobs; see committed changed-path inventory and commit proof. |
| V2 — focused new codec/canonicalization/boundary tests and fuzz seeds; one plain verbose `./contract/ledger` package run; actual `./internal/core/ledgerstore` consumer run | PASS: focused `go test -count=1 -v -timeout=19m ./contract/ledger -run ^(TestRegistration.*\|TestGoldenF3_139\|FuzzDecodeF3_139)$` exit0,2.579s Go/3.709s wall (04-focused.log), including92 fuzz seeds; final plain verbose package exit0,9.325s Go/13.633s wall (12-package.log); real ledgerstore consumer exit0,33.500s Go/35.914s wall (13-consumer.log). The first package failure was the obsolete private-map assertion, corrected as recorded; not an intentional mutation proof. All original logs are retained. |
| V3 — PM `go test ./contract/ledger -run '^$' -fuzz '^FuzzDecodeF3_139$' -fuzztime=120s` on the finalized code subject; executions, interesting inputs and corpus disposition | PASS on code SHA `86f952cfcae37bde06767c6c4eaa615a503dd96d`: `go test -count=1 -timeout=19m ./contract/ledger -run ^$ -fuzz ^FuzzDecodeF3_139$ -fuzztime=120s -parallel=1`, exit0;1,449,126 executions,21 new interesting inputs,total113;122.741s Go/131.144s process wall. No failing input or permanent target corpus directory; normal interesting inputs remain in Go fuzz cache.13 source hashes unchanged. Exact argv/env/result and raw output: pm-fuzz-result.json, pm-FuzzDecodeF3_139.log. |
| V6 — actual dependency/import audit and every changed path/final file hash against S1's actual base; standard-library-only additions; count-assertion deletion listed among removed assertions | PASS: production/test imports are standard-library only; nonstandard production closure is contract/ledger itself (18-imports.log,19-test_imports.log,20-dependencies.log). Exact13 changed paths/hashes below. The paid catalogue cardinality pin was deleted, not repinned; catalogue private-map equality became public version-admission checks, with old admission/error/fixture cases retained. Initial go-list runner-template quoting failure17-imports.log was corrected only in the disposable runner; final18–20 passed. |
| V7 — `go mod tidy -diff`, `go mod verify`, and comparison showing whether `go.mod`/`go.sum` changed | PASS: `go mod tidy -diff` exit0 with empty output (21-tidy.log); `go mod verify` exit0, all modules verified (22-verify.log); go.mod/go.sum unchanged from captured baseline (23-hashes.log). No dependency added. |
| V8 — new `TestGoldenF3_139 -update`, then all `TestGolden` regeneration; generated/committed-byte equality and unchanged earlier fixtures against their authoritative freeze digests | PASS: `TestGoldenF3_139 -update` exit0 (03-generate.log), then all `TestGolden -update` exit0 (05-goldens.log); all42 earlier fixture bytes unchanged (06-old_proof.log). New four fixtures equal committed blobs. PM comparison confirms all13 earlier log digests against D111/D115/D118/D119/D123/D124/D130/D139/D140/D144/D149; see comparison table and retained authoritative-golden proof. |
| V9 — SHA-256 and byte-level CR/LF inspection of every new generated log/object/body fixture; distinguish LF-terminated content from intentional no-terminator files | PASS: every new generated file was inspected as bytes and hash-bound to the code subject; no CR in any of the four. Log63,815bytes, instructions6bytes and body41bytes end LF; the0byte empty object intentionally has no terminator. Per-file digests/terminators are in the generated inventory; coder23-hashes.log and PM fixture inventory retained. |

Coder report fullGate.reason uses stale local-gate wording: no local full gate ran or will be duplicated; D153 hosted Check result is the integration gate. No local V4, race result, full-check substitute or Markdown-only amend is supplied. D153's exact-final-public-SHA hosted gate is separate below. No irrelevant permission/credential/money/sandbox mutation campaign is required for this codec-only slice; the specific earlier-family semantic negative control is required.

## Committed changed-path hashes

All13 files below match final tested-tree bytes and committed blobs at `86f952cfcae37bde06767c6c4eaa615a503dd96d`; the actual parent is `82d8d48856c7191019625c9f6e896d10b9b8498c`. No permanent Core path changed.

| Path | SHA-256 |
|---|---|
| `contract/ledger/catalogue.go` | `c858bb6ae564f60501091d48070a0a9f8e51be544a20ca756148dca656f029c0` |
| `contract/ledger/catalogue_test.go` | `8c042f0265260fed837ca1ab532113ddda4eab033c36ec0d995286ac555d939f` |
| `contract/ledger/doc.go` | `153bfbe24ba06252606ede402c7de74b7d9f9ceadcd48ed5ecd50ba315caa457` |
| `contract/ledger/paid_compatibility_test.go` | `3e236cb3bbd2006ffae0582215c476c26e8ac492e354fd85e3f87daba812e8f7` |
| `contract/ledger/registration.go` | `02345d1412c33261df9ad5f22e037fd58ae5dda67df2d02ba9e340519a237715` |
| `contract/ledger/registration_fuzz_test.go` | `56693358dc9bad9cd1990bba6d75dcb2ac9b91acf7c7d4fd8e2343414ba6d10f` |
| `contract/ledger/registration_golden_test.go` | `f4d9b5778d2936b4ccada58e549a746dd25f6a27289624c0cd4c898f5fca8c37` |
| `contract/ledger/registration_submission.go` | `219fe33b301ac334014429c4949ce29d2fb309718e16721a9cd7b5edf702d3f3` |
| `contract/ledger/registration_test.go` | `42185f48ec0e51721742527706a138ed5144bed8f20f2c1572835d2c66f5a48b` |
| `contract/ledger/testdata/f3/139/bodies/e94d3c7b4a8a8627e15a761daba3f8077fb32efb96e4260a09563d9c357158b5` | `e94d3c7b4a8a8627e15a761daba3f8077fb32efb96e4260a09563d9c357158b5` |
| `contract/ledger/testdata/f3/139/log/00000000000000000001.jsonl` | `db1476e07b355d909dfb07cce79f142387469618709bc52a3f496395b94c5134` |
| `contract/ledger/testdata/f3/139/objects/a9d748d84941c6117611a40dd7163c239e08fa6dd823f538ba68b3513605720b` | `a9d748d84941c6117611a40dd7163c239e08fa6dd823f538ba68b3513605720b` |
| `contract/ledger/testdata/f3/139/objects/e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855` | `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855` |

## Earlier golden comparison

All42 earlier fixtures remained byte-identical after all-golden regeneration and in the committed subject. The13 log digests were separately compared with their authoritative freeze entries, not with the superseded F3-13 digest from D148.

| Earlier log | Freeze | SHA-256 |
|---|---|---|
| `contract/ledger/testdata/f0/catalogue/log/00000000000000000001.jsonl` | D111 | `319c805312afd1abf824d306bcd799dd42bd3ae04fdf33fb74bc3f742ac8c898` |
| `contract/ledger/testdata/f0/log/00000000000000000001.jsonl` | D111 | `c72c4a739965586d984b524dbc6ee67a5b9d866756639fbb03b04e90f441f2e5` |
| `contract/ledger/testdata/f0/log/00000000000000000005.jsonl` | D111 | `3ee9f566e69e9cccb89ed435afee322950d3084a69ed0301684c15be70f8e65b` |
| `contract/ledger/testdata/f2/05/log/00000000000000000001.jsonl` | D115 | `843663a168e472adf4656fdba4ffa6db770e588feec0020bb10e20bf14def437` |
| `contract/ledger/testdata/f2/06/log/00000000000000000001.jsonl` | D118 | `014cc612076390934fa8a668117c353c5cca2630a3b3fd90364a29542b96f40d` |
| `contract/ledger/testdata/f2/07/log/00000000000000000001.jsonl` | D119 | `96de91f92432040683157279432512810c2dd27d36012695be46dd1eccac88c5` |
| `contract/ledger/testdata/f2/08/log/00000000000000000001.jsonl` | D123 | `985e073a342d9f991fdd2afd407dc495c3542020c98e35d3079018e29db14b8c` |
| `contract/ledger/testdata/f2/09/log/00000000000000000001.jsonl` | D124 | `f1a0c473ee410c189c743547f37c86ebd638ce9c92c68cd44d1b2816f9f3ad88` |
| `contract/ledger/testdata/f3/10/log/00000000000000000001.jsonl` | D139 | `9622b72877ed546a18fcbfd28a19807e0bab237909e23ffe76e7c3da1c260ecd` |
| `contract/ledger/testdata/f3/11/log/00000000000000000001.jsonl` | D140 | `145bb11c2b1c58e9e8530a98e6972b35329e4adb9dfb945a9f15381ae221bba6` |
| `contract/ledger/testdata/f3/12/log/00000000000000000001.jsonl` | D144 | `6586720b28a19f997dd0890a6dbc71d27ffdf395fd000e68b6aedbbbe0ce79f8` |
| `contract/ledger/testdata/f3/13/log/00000000000000000001.jsonl` | D149 | `50b41cf739cbef89bec234cf64873e80af85188b256c66d6cb1e86ebea3555ff` |
| `contract/ledger/testdata/u3/61/log/00000000000000000001.jsonl` | D130 | `6c7169aa9cfe77bb8976348f515ef85ec8da82b277520f82fd2bf169e6c45e0f` |


## Generated fixture inventory

`contract/ledger/testdata/f3/139/log/00000000000000000001.jsonl`: 19 commits/65 records; observed committed SHA-256 `db1476e07b355d909dfb07cce79f142387469618709bc52a3f496395b94c5134`. The generator, not hand-edited JSONL, defines the fixture and its positional IDs/times/hash chain (`contract/ledger/registration_golden_test.go:18-188,191-238`).

Five prerequisite commits/23 records register two agents/general contexts, create a work context and a real unassigned owner task with its body, then issue a real F3-11 owner root grant. The grant uses the exact opaque address `paid-route/` plus `id(0x450)` before resource `id(0x400)` is registered; no paid route/provider record is needed. Fourteen new-family commits/42 records cover resource/domain creation and audience revisions, resource→task, resource→context, domain→task and domain→context declarations, mixed consumers, current-source repins, empty withdrawals and later widening. The ruled first effect/receipt is 25/26 and final effect/receipt 64/65; the inventory supplies actual generated positions for every wire type, not positions guessed independently of the generator.

| Type, version 1 | Observed sequences | Covered shapes |
|---|---|---|
| `runtime.resource_registered` | 25, 43, 61 | create and two audience revisions; UUID distinct from exact paid-route opaque address |
| `runtime.work_domain_registered` | 28, 46 | create and audience revision |
| `runtime.declaration_changed` | 31, 34, 37, 40, 49, 52, 55, 58, 64 | both source kinds × both task/context consumer kinds, mixed consumers, source repins and empty withdrawals |
| `runtime.registration_receipt` | 26, 29, 32, 35, 38, 41, 44, 47, 50, 53, 56, 59, 62, 65 | all14 applied schema-5 operations; effect sequence immediately precedes its receipt |

| Generated fixture | Bytes | SHA-256 | Terminator |
|---|---:|---|---|
| `contract/ledger/testdata/f3/139/bodies/e94d3c7b4a8a8627e15a761daba3f8077fb32efb96e4260a09563d9c357158b5` | 41 | `e94d3c7b4a8a8627e15a761daba3f8077fb32efb96e4260a09563d9c357158b5` | LF; no CR |
| `contract/ledger/testdata/f3/139/log/00000000000000000001.jsonl` | 63815 | `db1476e07b355d909dfb07cce79f142387469618709bc52a3f496395b94c5134` | LF; no CR |
| `contract/ledger/testdata/f3/139/objects/a9d748d84941c6117611a40dd7163c239e08fa6dd823f538ba68b3513605720b` | 6 | `a9d748d84941c6117611a40dd7163c239e08fa6dd823f538ba68b3513605720b` | LF; no CR |
| `contract/ledger/testdata/f3/139/objects/e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855` | 0 | `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855` | intentionally empty; no terminator; no CR |

The new log contains55 distinct UUID tokens; none occurs in the13 earlier golden logs. The only shared64-hex tokens are the all-zero predecessor sentinel, the instructions-object digest `a9d748d84941c6117611a40dd7163c239e08fa6dd823f538ba68b3513605720b`, and the empty-object digest `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`. This is token overlap, not a claim that content-addressed objects acquire new identity in each chapter.


V8 must compare all earlier fixture bytes, not just the new chapter, with the authoritative records: D111 (three F0 logs), D115, D118, D119, D123, D124, D130, D139, D140, D144 and F3-13 as corrected by D149. D149's authoritative F3-13 log digest is `50b41cf739cbef89bec234cf64873e80af85188b256c66d6cb1e86ebea3555ff`, not D148's superseded `cd406c4f…8eca` (`docs/DECISIONS.md:2989-2998`). V9 records real terminators; the generator's CR check is not itself an observed all-file byte audit.

## Actual Core prerequisite probe and exact restoration

The retained probe source/invocations/output must demonstrate real `ledgerstore.Open` and `agents.Open`, using the generated fixture's actual objects/body. Positive: successful Open, zero reconciliation issues, durable sequence 65 before/after, unchanged ledger bytes and reconstructed earlier task/grant. `Reconciliation.Completed` may contain legitimate materialization repair. This pre-producer probe does not claim validation of F3-139's later reducer.

Negative: on a separate copied log, change the earlier owner task-create group to name a missing task dependency, consistently rebuilding submission, digest and chain; actual Core Open must reject that semantic prerequisite defect. Do not corrupt the retained golden or rely on a digest/reader failure. Record the actual error/sequence and preserve the control's source and output.

Restoration: record the baseline/final SHA-256 of any temporary chapter-139 helper support in `internal/core/agents/scoped_golden_test.go`, require byte-identical restoration, remove the throwaway agents probe test, and hash the final code only afterwards. Retain proof/source/output privately outside the worktree; no permanent plumbing test or Core scaffold is introduced (S1 assignment and amended ruling in the retained ticket packet).

Observed `go test -count=1 -v -timeout=19m ./internal/core/agents -run ^TestRegistrationFreezeSetupProbe$` exit0,2.971s Go/10.926s wall (08-probe.log). Positive: Store/Core Open succeeded,0issues,10 legitimate completed materialization repairs, durable65→65, unchanged ledger SHA256 `db1476e07b355d909dfb07cce79f142387469618709bc52a3f496395b94c5134`; waiting/unassigned task at19/version1 with checked description digest and nonrevoked matching root grant/authority1 reconstructed.

Negative on separately copied/canonically rebuilt log SHA256 `5234ed31b1cc83b33b6dc7aa5fb2df64dc2e21c97600549bb95a45e866061f91`: ledgerstore Open succeeded; Core returned nil service with `agents: inconsistent record at sequence 17: invalid scoped transition: agents: task dependency` (`ErrInconsistent`); durable65→65 and rejected-open bytes unchanged. The control rebuilt submission/digest/chain consistently; it is not a digest-parser failure.

Exact helper restoration before final hashes: `internal/core/agents/scoped_golden_test.go` SHA256 before/after `1c954596b2e148581ae2fa738966273667b337b00c501711467b5f4d5d906e1e`, byte-identical; own probe test absent. Retained source registration_freeze_setup_probe_test.go, scoped_golden_test.go.baseline, 09-restoration.log,23-hashes.log and final yield.json show controls/removal. Disposable runner archived as run.py.source; PM fuzz runner likewise retained as source outside the product. This proves earlier-family prerequisites only, not the unimplemented registration reducer.

## Joint completed-contract review

GPT-6 Astra, acting as a temporary stand-in for Claude Fable 5.1, approves Ticket139 S1 at 86f952cfcae37bde06767c6c4eaa615a503dd96d, parent 82d8d48856c7191019625c9f6e896d10b9b8498c, jointly with its completed F3-139 specification, generated fixtures, observed evidence and proposed 14-edit D125 freeze record. No blocking findings remain. This is technical approval for PM freeze recording, not a claim that the freeze has landed or D153 integration gates have passed. Fable remains the main advisor; its whole-ticket double-check after reset is pending.

This must be the actual fresh GPT-6 Astra review as temporary stand-in for Claude Fable 5.1 under the temporary-review authorization, covering exact S1, generated fixtures, evidence and proposed freeze record under D152. The design-only ruling is not its substitute (amended ruling, retained ticket packet). Fable remains the main advisor; retain the whole-ticket packet for its double-check after reset. Nothing here asserts that the later Fable verification has already occurred.

## D153 hosted integration — final public freeze-record subject

The final public freeze-record subject below includes all approved Go status-comment edits. It is distinct from contract-code `86f952cfcae37bde06767c6c4eaa615a503dd96d`, whose tests, fixtures and joint review are recorded above. Any later source fix or rebase needs its own exact-SHA hosted evidence; no local V4, earlier-SHA success or Markdown-only amendment substitutes for this gate.

```json
{
  "finalPublicSHA": "34090c3b634b9854904671c336db91c350e6328c",
  "runURL": "https://github.com/Darius-PJ/dwarf-harness/actions/runs/40794776982",
  "runID": 40794776982,
  "runNumber": 8,
  "runAttempt": 1,
  "conclusion": "success",
  "classification": "Full matrix observed: all three Check platform/race jobs ran successfully; not Markdown exemption.",
  "source": "https://api.github.com/repos/Darius-PJ/dwarf-harness/actions/runs/40794776982",
  "jobsSource": "https://api.github.com/repos/Darius-PJ/dwarf-harness/actions/runs/40794776982/attempts/1/jobs?per_page=100",
  "changes": {
    "jobName": "changes",
    "conclusion": "success",
    "url": "https://github.com/Darius-PJ/dwarf-harness/actions/runs/40794776982/job/123188465421",
    "classification": "Full matrix observed; all three platform Check jobs ran successfully, not Markdown exemption."
  },
  "windows": {
    "jobName": "Check / windows-amd64",
    "conclusion": "success",
    "url": "https://github.com/Darius-PJ/dwarf-harness/actions/runs/40794776982/job/123188509937",
    "apiJobSeconds": 1916.0
  },
  "linux": {
    "jobName": "Check / linux-amd64",
    "conclusion": "success",
    "url": "https://github.com/Darius-PJ/dwarf-harness/actions/runs/40794776982/job/123188509951",
    "apiJobSeconds": 829.0
  },
  "macOS": {
    "jobName": "Check / macos-arm64",
    "conclusion": "success",
    "url": "https://github.com/Darius-PJ/dwarf-harness/actions/runs/40794776982/job/123188509930",
    "apiJobSeconds": 1171.0
  },
  "checkResult": {
    "jobName": "Check result",
    "conclusion": "success",
    "url": "https://github.com/Darius-PJ/dwarf-harness/actions/runs/40794776982/job/123199713185"
  }
}
```

Observed run update: `2026-10-29T01:05:11Z`. Secondary retained the exact-attempt run/jobs/annotations in `t139-s1-ci-result.json` and all final fifteen file hashes, approved-projection equality, four comment-only Go paths and zero-issue Markdown/LF proof in `t139-s1-public-proof.json`; its integration packet binds those to the joint review. Guarded publication accepted both outgoing commits and remote `build/139-registration` matched the final SHA.

After the quiet campaign execution ended, the primary matched all fifteen final file hashes to both disk and the committed blobs and independently read the hosted success on the exact final SHA. Main fast-forwarded from `82d8d48856c7191019625c9f6e896d10b9b8498c` to `34090c3b634b9854904671c336db91c350e6328c` at `2026-10-28 21:22:18 -0400`; the guarded push completed at `21:22:59.987738 -0400`, and the remote matched. No fix or rebase occurred. Publication of this private record is separate under D145; the external primary promotion receipt retains its actual commit/remote proof rather than a self-referential hash. S2 requires the primary's explicit source/compute allocation; hosted success alone did not activate it.
