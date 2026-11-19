# Ticket 145 evidence

The [brief](ticket-145-design-brief.md), [fresh ruling](ticket-145-design-ruling.md) and [clarification 1](ticket-145-clarification-1.md) are retained verbatim. RulingT145 approved the original design with eight amendments; fresh Fable advisor ClarifyT145a then ruled `change`, adding binding amendments 9–12, no owner gate. S1's raw cuts and counts-first oracle stand; S2 adds detection of an unpooled warm exchange before dispatch. The remedy needed no product, money, record or contract change; the toolchain pin (D172) was approved separately, and the interruption and rebase are recorded below. Sources: `local://t145-ruling.md:8-55,98`; `local://t145-clarification-1.md:3-22`; `local://t145-docs-notes.md:119-154,192-203`.

## Reproduction and cause

The PM's base probe used e3fc732 code through a test-file overlay changing only two failure messages. It exposed the early-400 close window, not a replay: `partial_header` forwarded 8 bytes, then TLS Close sent `close_notify` before raw socket close; the server answered the truncated request line with HTTP/1.1 400 before the client's own close completed. The client either returned the response with nil error or lost its body mid-drain. The observed nil-error signature was dials=1, requests=1, complete=1, writes=3, faultWrites=1, status=400; only the warm exchange entered the handler. Core records an early answer without final billing evidence as `unknown`, retaining the full hold. The original hosted failure messages remain unobserved; supplied logs must now be compared against three signatures, including the warm-condition failure found below. `partial_body`'s default-answer window was unobserved in the local probe but subsequently observed in the hosted before-diagnostic; source identifies its default 200 [INFERENCE], because that status was not visible. Sources: `local://t145-brief.md:24-48`; ruling amendment 6 as changed by clarification 1 `answerWording`; raw probe logs and diagnostics below.

| Base probe | Leaf runs | Failures | Signature |
|---|---:|---:|---|
| `partial_header`, plain ×3000 | 6,000 | 130 | 32 nil-error 400; 98 response-drain failures |
| `partial_header`, race ×1000 | 2,000 | 2 | both response-drain failures |
| all five modes, plain ×1000 | 10,000 (2,000 `partial_header`) | 45 | `partial_header` only: 3 nil-error 400; 42 response-drain failures |

Thus `partial_header` had 177 failures in 10,000 leaf runs (35 nil-error 400, 142 drain failures), with no observed second dial or request. The other four modes had zero failures in 2,000 leaves each. Raw sources: `t145-pm-evidence/02-plain-x3000.log`, `03-race-x1000.log` and `04-plain-allmodes-x1000.log`, with SHA-256 in the closing table; `local://t145-docs-notes.md` (12:14:35 and 12:16:36 entries).

## S1 and review — superseded candidate

| Slice / coder | Reviewed commit / base | Fresh review |
|---|---|---|
| S1 — raw FIN cuts at all five fault closes; `exerciseOneShotFault`, `checkOneShot` and `errOneShotCounts`; `TestPaidHTTP1OneShotCloseWindow`, `TestPaidHTTP1OneShotCounts`; two sentences in `doc.go`'s transport paragraph. CoderT145S1, GPT-6 Astra | ec48c182b45c07422407f5cb91f780ca1d27bd67 / c1d06b399f13bbb54626d10a5a90403cd89d1396; only `internal/core/providers/transport_test.go` and `internal/core/providers/doc.go` | ReviewT145S1 (fresh Fable): approved, no blocking findings |

The deterministic old-close run exited 1: both `raw` leaves failed after counts 1/1/1, reused=true, writes=3, faultWrites=1, nil Do error and HTTP/1.1 400, with drainFailed=true; both `graceful_control` leaves passed. The raw-cut run exited 0: all four passed; `raw` kept 1/1/1 but returned a read-side `use of closed network connection` error and no response. The graceful control kept nil-error 400 and 1/1/1; its drain result varied and is recorded, not asserted. Sources: `local://t145-s1-review.md:12-18`; `t145-s1-evidence/deterministic-red.log` and `deterministic-green.log` (SHA-256 below).

S1's focused, plain, package race and twentyfold race runs all exited 0; `x20-leaves.csv` records 20 PASS on all 20 leaves (the original ten, four window leaves and six count-control leaves). The unchanged agents and ledger consumer runs passed, and F3-13/F3-14 fixture digests equal the base, without `-update`. gofmt, host vet/staticcheck, module tidy and import audit were clean; no package import was added and no test was deleted or renamed. S1 hashes: `transport_test.go` `7d0a39d9d33b21842ea033dc75b31254f2b9b390e25814e7a566d893db8105c6`; `doc.go` `5d1e0aad8362672c362bfed184195fdb158f0b722d0bcac124bf21a986d67a31`. The PM checked ec48c18's blobs against those hashes; the read-only reviewer relied on that check. This approval stands for S1 as superseded evidence, not F. Source: `t145-s1-evidence/yield.json` (commands, imports, goldens, finalHashes; SHA-256 below); `local://t145-s1-review.md:17-25`; clarification 1 `records[0]`.

Nonblocking review notes: `doc.go`'s “neither a replay nor no charge” is a clear but double-negative sentence, left for the next touch; the warm gate's additional requests==1 is harmless tightening; the scalar attempt-error string includes the loopback URL but no header/body/bearer; the new tests' high-count exposure is the hosted matrix, since the fixed-source stress intentionally targets the original test only; and `extra_dial` reads the transport's private TLS config in-package. None required a code change. Source: `local://t145-s1-review.md:5-10`.

## Twelve rule breaks

Each mutant was applied alone, ran red with exit 1 (not a compile failure), was restored byte-identically and then ran green with exit 0. For the five test-file mutants below, original=restored SHA-256 is `7d0a39d9d33b21842ea033dc75b31254f2b9b390e25814e7a566d893db8105c6`; for the seven `transport.go` mutants it is `9836e66493d6d9ee89960927f20b7ae013a4e2e31506a06103a2c7724b5736fc`. The latter edits were transient; no product change was committed. Source: `t145-s1-evidence/yield.json`, `breaks` (the inventory retains every `break-<ID>-red.log` and `break-<ID>-green.log` by path and hash).

| ID | Mutant / file | Mutant SHA-256 | Red proof |
|---|---|---|---|
| close | restore five TLS-side closes / `transport_test.go` | `703a32629d08c8c6421142844d6d588035f41cd14a73b9325217f6f3284161a4` | `CloseWindow/{anthropic,openai}/raw`: nil-error 400 after 1/1/1; graceful controls stay green |
| getbody | functional `GetBody` / `transport.go` | `7ee50f43e766aaad9b2ab23835c30f42f7d878f9853e3aaa9885fc126e8ce316` | original `zero_write` leaves reject 2/2/2 through `errOneShotCounts`; status 200 and nil error cannot hide it; sealed-body guard also fails |
| getbody-idempotency | `GetBody` + `Idempotency-Key` / `transport.go` | `0739749768de63194f92acbdea5723ade5ff454bcd8d27615610fa27066662b9` | original `read_eof` leaves reject 2/3/3 through the count stage, idempotency=true |
| getbody-x-idempotency | `GetBody` + `X-Idempotency-Key` / `transport.go` | `2ccbe71fe7e0344eba077bf05c34de10706ad310216e9adfdc15321527efe3fd` | same 2/3/3 count-stage failure |
| header-idempotency | `Idempotency-Key` alone / `transport.go` | `4b17d3f2d82878c0d740a862ba09c699f9169ae29d2a545d6375cb1ed8e50ef8` | `TestTransportUsesOnlySealedHeaderSetAndBody`: unsealed key |
| header-idempotency-empty | that key with empty slice / `transport.go` | `6c819e29c3b995e0aa908e3c22a19493e671c0852bcd6f47cde2a0fde833da54` | same sealed-header rejection |
| header-x-idempotency | `X-Idempotency-Key` alone / `transport.go` | `5781d2abb321838a4d9c2397eee4940ef8fe3021f4c89a93f88eddaa5e75216a` | same sealed-header rejection |
| header-x-idempotency-empty | that key with empty slice / `transport.go` | `009baa0e103874445175c16b9cb8258de1a65c18801dd4962065a80fbb5a8caf` | same sealed-header rejection |
| validator-whole | remove count stage / `transport_test.go` | `33f08a42c20f3d677ea6838d3dbab9695eac7983c6bff8162e8b59019b5e728b` | `Counts/.../{extra_dial,extra_complete}`: count stage did not reject, nil |
| validator-dial | remove dial comparison / `transport_test.go` | `98461f48faefba85ab38b0aca6db4e51e0834a5572a1a6e76bdd617fb8c075df` | `Counts/.../extra_dial`: count stage did not reject, nil |
| validator-server | remove request/completion comparisons / `transport_test.go` | `209347a469c7bf5e80a5c3402d3f5ac5c6197bee9058232f430b5e90592d93df` | `Counts/.../extra_complete`: count stage did not reject, nil |
| validator-order | judge outcome before counts / `transport_test.go` | `d58f7f174e4c3314ec7d8703462d85240ebeea397266924b56ae137f8695c97c` | `Counts/.../counts_before_outcome`, actual 1/2/2 and nil-error 400: non-sentinel “faulted attempt returned a nil error after valid counts” |

`CloseWindow` and `Counts` above abbreviate `TestPaidHTTP1OneShotCloseWindow` and `TestPaidHTTP1OneShotCounts`; every named control ran for both providers. Money-break signatures and the validator-order non-sentinel were checked by the reviewer (`local://t145-s1-review.md:14-15`); the special validator-order log is cited below.

## S1 fixed-source stress — retained evidence

The PM ran amendment 8's three fixed counts on ec48c18 after deterministic green; all exited 0 with zero failures, 18,000 leaf passes total. The worktree was clean before and after. No base probe was rerun.

| Fixed-source run | Leaf passes | Failures | Base comparison |
|---|---:|---:|---|
| plain `partial_header` ×3000 | 6,000 | 0 | 130 / 6,000 |
| race `partial_header` ×1000 | 2,000 | 0 | 2 / 2,000 |
| plain all modes ×1000 | 10,000 | 0 | 45 / 10,000, all `partial_header` |

Sources: `local://t145-docs-notes.md` (13:21:13 entry); `t145-s1-evidence/pm-stress/commands.jsonl` and the three stress logs, SHA-256 below. Deterministic proof and this stress are primary evidence; the hosted matrices supply criterion 5's final subject and platform coverage, not a statistical guarantee.

## Hosted before-diagnostic

Run 42507895728 on `build/145-diag-before-1`, 7cb1d3d6078e0e227c62edb16c5f52c4499f7651: red on all three native systems. Each step ran 1,000 sequential outer iterations. The signed-out summaries showed:

| System | Step | Failed iterations | Nil-error counter (`nil400`) | Drain | `warm` |
|---|---|---:|---:|---:|---:|
| Linux | tests (`race0`) | 81 | 81 | 4 | 0 |
| Linux | race (`race1`) | 97 | 96 | 2 | 0 |
| macOS | tests (`race0`) | 62 | 59 | 2 | 1 |
| macOS | race (`race1`) | 53 | 52 | 0 | 1 |
| Windows | tests (`race0`) | 18 | 4 | 14 | 0 |
| Windows | race (`race1`) | 18 | 8 | 9 | 1 |

The columns count different things: an iteration can have multiple failed leaves, so message counters need not sum to failed iterations. `nil400` names the nil-error site's counter, not a visible 400 on `partial_body`. There were 25 `partial_body` nil-error leaves in 12,000, with one dial and two handler entries; status was not visible and default 200 is source-derived [INFERENCE]. The nil-error site's dialsmax was 1 everywhere, requestsmax 2 only where `partial_body` failed. Those maxima do not cover the three `warm` events, whose leaf names and counts were not visible. Run 42507895728 failed on all three systems; the table gives its signed-out summaries. Sources: `local://t145-docs-notes.md:119-129`; `t145-pm-evidence/hosted/diag-before-42507895728-{annotations,jobs,run}.json` (individual hashes below).

## Clarification 1 and warm-decline evidence

ClarifyT145a (fresh Fable) ruled `change` on 2026-11-08, amendments 9–12, no owner gate; its verbatim record's SHA-256 is `31317aa09aab6929c2c79a1f01beddb99b916f8314b893c09121dc02273e4fe7`. Declined warm pooling is inside criteria 1–3 and required S2 before F. Detection only is approved: no bounded re-warm, which criterion 2's unqualified “no retry” excludes; the proposed WroteRequest response gate is a no-op because the header flush precedes writeBody and WroteRequest fires before the body's final Flush.

The pinned go1.27.3 readLoop decides reuse before handing EOF back to the drain (`net/http/transport.go:2616-2627`); writeLoop publishes its result only after Flush (`:2850-2858`); `wroteRequest` waits at most 50 ms, then declines reuse (`:2868-2904`). `PutIdleConn` runs inside tryPutIdle before the EOF handoff and before Body.Close returns (`net/http/httptrace/trace.go:92-98`). Other Reused=false causes are excluded in this fixture: idle timeout is 90 s, its pool limit is MaxActivePaid, and the server closes nothing before server.Close. After-2 now supplies one hosted event labelled as the decline; identity of the three base warm events still rests on exclusion [INFERENCE]. Sources: `local://t145-clarification-1.md:4,18,29-30`; `local://t145-s2-review.md` (notesForClose); notes `:170-185`.

The PM's labelled overlay changes only pinned `net/http/transport.go`'s `wroteRequest` to return false, never committed. S1's ten original rows then failed as `one-shot counts changed`, dials=2 requests=2 complete=2, writes=2 faultWrites=0 reused=false: a first and only, unfaulted send on a new connection, not a replay. Its nil-error response was 200 except `read_eof`'s EOF. The separate 200-POST probe read `PutIdleConn` at drain return: plain exit 0, 200/200 pooled and 199 reused; overlay exit 0, 0/200 pooled, hook not called 200 times, none reused. Raw sources are the five `t145-pm-evidence/warm/` files in the closing table. Pinned original `C:/Program Files/Go/src/net/http/transport.go` SHA-256: `c9146e77adc22d4b74ba77384ec7be7fc27c3af21ff20485f642b4d611b381a4`; recorded toolchain: `go version go1.27.3 windows/amd64`. Sources: notes `:130-136`; S2 yield `overlay`; clarification 1 `records[1]`.

## S2 — warm-pool precondition

| Slice / coder | Commit / base | Review |
|---|---|---|
| S2 — `httptrace.PutIdleConn` on warm and `extra_complete` exchanges; fail before arming or faulted dispatch if not pooled; only `internal/core/providers/transport_test.go`. CoderT145S1 revived (GPT-6 Astra) | 2ca8675f611b0300099dc2249e54fa18fe42a177 / ec48c182b45c07422407f5cb91f780ca1d27bd67 | ReviewT145S2 (fresh Fable): approved 2026-11-18, no blocking findings |

The warm trace records successful pooling in an atomic.Bool; after each warm drain the precondition fails with “warm connection not pooled” and dials/requests/complete. The faulted Do keeps its GotConn-only trace. No new test, retry, skip, loop, sleep or timeout; `checkOneShot`, the twenty leaves, interposer, drain helper, imports and `doc.go` are unchanged. Source: clarification 1 `change`; `local://t145-s2-assignment.md` (The change).

S2 assignment `local://t145-s2-assignment.md` SHA-256 `f35a74929c2b5600c54ee9ce0c758e43db9a57b72a2e6dde83dfd78185936fb8`; reviewed diff `local://t145-s2.diff` SHA-256 `a7460816d4bcd67ecdcc4aad800e8c367629a3e2c3701e55459af00144e3e542`; coder report `t145-s2-evidence/yield.json` SHA-256 `2ef678ce221bc646ed77d307e0232ecd75f1a6b0e8eddae472570af617fcba72`. Final `transport_test.go` SHA-256 is `21f617ba75998508cf014ec5fa6020f856a7d6d97e4deb46e7abbe3108c1c30c`. Static, focused, plain, race and ×20 runs exited 0; `t145-s2-evidence/x20-leaves.csv` SHA-256 `0e2f9530a45afc2f65a3ad822c61bebcf9561bcd483f2c4188b08a2e0e94bbef` records 20 PASS for each of twenty leaves. The report and review record empty DATA RACE/FAIL/panic scans, unchanged imports, status limited to the one owned path, no testdata touched and no deleted/renamed test. The reviewer relied on the PM's blob-equality check. Nonblocking notes: duplicated Fatalf is spec-dictated to preserve helper attribution; a real decline on `extra_complete`'s second exchange can print 1/2/2, whereas the always-decline overlay stops every leaf at the first exchange, 1/1/1. Sources: S2 yield; `local://t145-s2-review.md`; notes `:182-185`.

The S2 assignment numbers three evidence steps (clarification 1 groups the overlay pair as break 1 and real replay as break 2):

| Assignment step | Boundary proved | Observed results, log paths and SHA-256 |
|---|---|---|
| 1 — ec48c18 forced-decline red | corrected baseline, no fault hit | Exit 1, all 20 leaves fail: fourteen OneShot/CloseWindow leaves at `one-shot counts changed`, 2/2/2 faultWrites=0 reused=false; four `extra_complete`/`counts_before_outcome` leaves at “extra exchange did not complete on the warm connection”; two `extra_dial` leaves at the exact-control check, dials=3. `t145-s2-evidence/overlay-before-red.log`, SHA-256 `7c70e4aa0e208c7996567bcc7d0b2a60294719843dabfe4d8fa7c8db37c42717`. |
| 2 — S2 forced-decline fix | setup detected before dispatch | Exit 1 as intended, all 20 leaves “warm connection not pooled”, 1/1/1; no count-stage/nil-error-outcome/old warm-condition message and no PASS leaf. `t145-s2-evidence/overlay-after.log`, SHA-256 `4fc546408acd73852f0e0fe1e342f5b93d2e6ae2496444de44bd5e956933ce8d`. |
| 3 — real GetBody replay, no overlay | count stage still catches a second send | Both `zero_write` leaves red, exit 1, 2/2/2 writes=3 faultWrites=1 reused=true, status 200; restored green exit 0, two PASS. `t145-s2-evidence/getbody-red.log`, SHA-256 `feceba4ebf4f7830c7b3499a71435ffce04c2444d66f33a28576a27389bdaa50`; `t145-s2-evidence/getbody-green.log`, SHA-256 `df32e91c3368214442e112c2f4bf4259b5a6ab11a4e320e8a453ba51a6e4ae20`. |

The PM accepted the corrected 14/4/2 baseline expectation before S2 continued; that red was not rerun. Every leaf reaching the count stage still produced the money-shaped sentinel, while S1's six Counts controls stopped earlier on excess activity. The fix's deliberately failing overlay run proves the change of failure kind, not an ordinary passing “green”. GetBody product-source hashes: original=restored `9836e66493d6d9ee89960927f20b7ae013a4e2e31506a06103a2c7724b5736fc`; mutant `7ee50f43e766aaad9b2ab23835c30f42f7d878f9853e3aaa9885fc126e8ce316`. Overlay JSON hash `2da2120017b72e03eeb776ab67d554d4ba8e61b61f2bf608c4de997158aba68f`, mutated net/http source `03a7314a73ee60976d84ffded0f2c178a34088d01fa33196216f2db77abdde9d`; pinned original/toolchain are recorded above. Sources: S2 yield `breaks`, `overlay`, `deviations`; notes `:155-157`; S2 review.

### PM stress on S2

All three PM stress runs on 2ca8675 exited 0, with 18,000 leaf passes, zero failures, no “warm connection not pooled”, no DATA RACE or panic. The worktree was clean before and after; there was no amendment-10 setup failure and no rerun.

| Run | Leaf passes | Exit | Path / SHA-256 |
|---|---:|---:|---|
| plain `partial_header` ×3000 | 6,000 | 0 | `t145-s2-evidence/pm-stress/01-plain-partial-header-x3000.log` — `be1208264cf3789b6d5f17ec1cdceaccd5c0e28648ef5bb899ab170315a02315` |
| race `partial_header` ×1000 | 2,000 | 0 | `t145-s2-evidence/pm-stress/02-race-partial-header-x1000.log` — `68c2028d52c6e3fff3092c78af1ac63222e51c79d9e55dfbd148efa2cbc15665` |
| plain all modes ×1000 | 10,000 | 0 | `t145-s2-evidence/pm-stress/03-plain-all-modes-x1000.log` — `572515ff8c6f99309325f62311e44f1b1ee2e1329905ea4ea0e03d418378fbcf` |

Reproducibility references: `t145-s2-evidence/pm-stress/stress.sh` SHA-256 `88506a87f3456c5e2a99bccb7d8a89143c9b5389b71c443ebf047bc230c2015b`; `t145-s2-evidence/pm-stress/commands.jsonl` SHA-256 `d27b02772f1b90d534901ecf9031f773b934fbb800f20899625e2fcf6f029e25`. Sources: notes `:176-180`; S2 review's stress check. These amendment-8 counts on S2, not S1's older stress, cover the final code.

## After-diagnostics and superseded S1 runs

| Role | Ref / head / run | Result / disposition |
|---|---|---|
| S1 push | `build/145-oneshot` / ec48c182b45c07422407f5cb91f780ca1d27bd67 / 42509221277 | green on all three systems, push attempt 1; superseded, not counted, ec48c18 is not F |
| S1 after | `build/145-diag-after-1` / d3c6075fe96a217a11d9a8b1ec97ea52fa1e9a14 / 42509380879 | passed all three native systems, 6,000 iterations with no failure and no `partial_body` failure in 12,000 leaves; superseded diagnostic, never counted |
| S2 after | `build/145-diag-after-2` / c3ec74e56482279df75231d45fc26a5280b3666e / 42515734768 | green under amendment 9: Linux and Windows succeeded; macOS tests passed and race failed only on one `notpooled` summary; one labelled setup failure total, no other kind or data race |

After-2 is the diagnostic for the original S2 candidate, never repeated on the same SHA. Its stress files equal 7cb1d3d's except exactly three added `t145Messages` rows (`warm connection not pooled`→`notpooled`, `one-shot counts changed`→`oneshotcounts`, `faulted attempt returned a nil error`→`nilerr`); race/norace files are byte-identical. The prepared source and three-added-line diff are retained as `t145-pm-evidence/diag-after-2/zz_t145_hosted_stress_test.go` and `stress-file.diff`, SHA-256 below. Sources: notes `:138-154`; clarification 1 amendment 9.

Amendment 9's green rule is not ordinary all-jobs success: msgs must be empty or only `notpooled`, at most 12 such lines across the six OS/steps, with no datarace or other kind. After-2 showed one such iteration and no other failure, in macOS's race step; its visible summary was `TestT145HostedStress/race1_failed_1_of_1000_nil400_0_drain_0_unexplained_1_dialsmax_0_requestsmax_0_exit_1_result_true_leaves__msgs_notpooled-1`. Its tests step passed; Linux and Windows succeeded. The after-branch `unexplained_1` is meaningless under amendment 9; `msgs_notpooled-1` supplies the count. This is the first hosted event labelled as the decline; the three base warm events remain by exclusion [INFERENCE]. It is a recorded amendment-10 setup failure, not repeated or counted. Both after-diagnostics had no nil-error `partial_body` failure in their 12,000 leaves each (after-2's message kinds hold no `nilerr`; its one notpooled iteration's leaf is not visible). Raw run/jobs/annotation records are listed below. Sources: notes `:170-174`; S2 review `notesForClose`.

## Final-SHA series

F was declared as 2ca8675f611b0300099dc2249e54fa18fe42a177 at 2026-11-18T21:19:11-05:00, after S2 approval and after-2's amendment-9 green. Its run 1 (#97) passed; run 2 (#99) failed only govulncheck on all three native systems, while tests and race passed. GO-2026-6859 (CVE-2026-97054), published 2026-11-11T02:51Z after #97 and #98, affects `net/http@go1.27.3` and is fixed in go1.27.4; the PM's local reproduction exited 3 with that one finding. Under amendment 3 (iii), #99 neither counted nor ended the series. F could not pass with that pin, so the PM decided under D160 that amendment 4's hold yielded to the owner-approved toolchain commit (D172), `main` c1d06b3 → 01ea48a10f69ccdf9d3d2cfbe7f4f4fd35648b6f, reviewed and green in check 102. The `proof-2-44443383210-*` records are the old series' run 2 on `build/145-proof-1`; the `fprime-proof-2-*` records are ref `build/145-proof-2`. Sources: notes `:186-203`.

Under amendment 3 (v), the two 145 commits were rebased patch-identically onto 01ea48a: S1 0dad527 and S2 326f5e8, F' = 326f5e82976a52e3119c7a3a3d2200f21d13929c. The PM's stable patch-ID prefixes e00869df… and 314544dd… equal ec48c18's and 2ca8675's respectively. ReviewT145Fprime (fresh Fable) approved with no blocking findings, relying on that patch identity and confirming both fixes in F'; no new owner gate arose. The new series starts from zero: run 1 #104 (44471427573) on `build/145-oneshot`, run 2 #103 (44471392438) on fresh `build/145-proof-2`, pushed back to back and run concurrently under amendment 3 (iv). Both are push attempt 1, head F', classifier code=true, all native jobs and Check result successful. #97 and #99 remain evidence of the old F, with no credit in the new series.

The slice evidence, the PM's stress and the overlay red/green were produced under go1.27.3, and the counted series under go1.27.4. This is sound because net/http's client path is unchanged between the tags: net/http's only product change is `server.go`'s MaxBytesReader limit path, the GO-2026-6859 fix, which neither fixture nor product enters. `transport.go`, `request.go`, `transfer.go`, `client.go`, `crypto/tls/conn.go`, `bufio` and `internal/poll` are unchanged, so the diagnosis, fix's cause chain and overlay evidence apply unchanged. The overlay's pinned transport.go hash also names go1.27.4's file [INFERENCE from the published diff, not re-hashed]. Transport citations keep their lines; server.go citations in the historical brief/ruling are go1.27.3's and shift +4 in go1.27.4 (default 200 at :1722-1724; 400 block :2080-2125). The overlay remains diagnostic evidence, not a product dependency. Sources: notes `:192-203`; `local://t145-fprime-review.md` (notes 1–7 and notesForClose); the hosted records and govulncheck log listed below.

A providers failure, including “warm connection not pooled”, ends the counted series. For that setup message, amendment 11 returns diagnosis to this ruling: record the ended row, then start two fresh proof refs on the same F, no code change and no new F. A second series ended by the same message is a new finding and goes to the owner with the re-warm question; never fill a close over that escalation.

| Series / ordinal | Ref | Head SHA | Run / attempt | Windows tests / race / job; duration | Linux tests / race / job; duration | macOS tests / race / job; duration | Check result | Counted / disposition |
|---|---|---|---|---|---|---|---|---|
| old F / 1 | `build/145-oneshot` | 2ca8675f611b0300099dc2249e54fa18fe42a177 | #97, 42515714320 / 1 | success / success / success; 38m08s | success / success / success; 19m26s | success / success / success; 23m20s | success | no credit in F' series: qualified for old F, superseded by rebase |
| old F / 2 started | `build/145-proof-1` | 2ca8675f611b0300099dc2249e54fa18fe42a177 | #99, 44443383210 / 1 | success / success / failure; 35m10s | success / success / failure; 19m23s | success / success / failure; 23m59s | failure | no: govulncheck only, outside scope; neither counted nor ended old series, then superseded |
| F' / 1 | `build/145-oneshot` | 326f5e82976a52e3119c7a3a3d2200f21d13929c | #104, 44471427573 / 1 | success / success / success; 44m04s | success / success / success; 14m01s | success / success / success; 24m42s | success | yes, counted run 1 |
| F' / 2 | `build/145-proof-2` | 326f5e82976a52e3119c7a3a3d2200f21d13929c | #103, 44471392438 / 1 | success / success / success; 43m02s | success / success / success; 16m19s | success / success / success; 26m54s | success | yes, counted run 2 |

Durations are native-job elapsed wall time, from the retained jobs records; every row is a push event. The two counted F' matrices meet criterion 5 on free standard public runners, not a guarantee. `main` 01ea48a → 326f5e82976a52e3119c7a3a3d2200f21d13929c, reflog 2026-11-19T02:11:56-05:00, pushed at 02:11:59; the F' hold ended then. Ticket 16's S3 is stacked on F' and lands after it. C3's latest CI is check 104 (run 44471427573) on 326f5e8, tests and race successful on Windows, Linux and macOS.

## PM decisions and close

1. **Design route:** providers/possible money required a designer and fresh Fable ruling. The PM omitted a reader because the probe had already reproduced and located the failure; one coupled, test-only slice was permitted. No numerical cost bound applies, so no acceptance-driver profile or measurement campaign was required. Sources: `local://t145-design-assignment.md:13-25`; ruling P6.
2. **Fix the fixture, not product behavior:** the ruling confirmed no product or money defect; raw FIN rather than RST, counts first everywhere, and `partial_body`'s byte placement retained. No handler change or broadened expected outcome suppresses the window. Sources: `local://t145-docs-notes.md` (12:22:01–12:52:56 entries); ruling P1–P4 and P6.
3. **Make the diagnostic summary visible:** the workflow emits at most ten annotations per job and prioritizes failure lines, which could hide a late aggregate. The PM therefore ran the iterations in a child test binary and surfaced one parent summary-subtest failure carrying failed iterations, nil400, drain, unexplained, dial/request maxima, child exit and failing-leaf/message counts. `tools/check` still runs race after tests fail, allowing race0 and race1 summaries. This throwaway presentation detail preserves the ruling's 1,000 sequential iterations and changes no workflow. Source: `local://t145-docs-notes.md` (13:02:08 entry). Its local presentation smoke found 48 failed iterations, nil400=8, drain=42, dialsmax=requestsmax=1; those are diagnostic-smoke counts, not the 177-failure base probe or acceptance evidence (`t145-pm-evidence/07-diag-before-local-2.log`, SHA-256 below).
4. **Final subject and ordering:** F was declared as 2ca8675 after S2's review, stress and after-2. Run #99's govulncheck failure neither counted nor ended the old series, but the vulnerable toolchain made landing impossible. Under D160 the hold yielded to the owner-approved go1.27.4 commit (D172); amendment 3 (v) then required the patch-identical F', fresh approval and new series from zero. ReviewT145Fprime approved F' with no blocking findings; #104 and #103 passed. The renewed hold applied from F' through its fast-forward at 2026-11-19T02:11:56-05:00, and ended then; ticket 16's stacked S3 follows. Sources: notes `:192-203`; `local://t145-fprime-review.md`; original amendments 3–4.
5. **Evidence boundary:** compare any supplied original hosted logs with all three signatures; append after-2's run ID to the pending log ask. No new product behavior or owner-reserved gate arose. The optional re-warm follow-up question is not a gate of 145; its wording and disposition follow. Sources: clarification 1 `answerWording`, `records[3-4]`, `ownerGates`.

### Optional re-warm follow-up

The PM may ask in the next batch; this does not authorize a retry in ticket 145:

> Ticket 145 criterion 2 says the fix adds no retry. net/http sometimes drops a warm connection instead of pooling it under load (its own tests widen an internal 50 ms wait to avoid this flake); the one-shot test needs a pooled connection and now fails early with the labelled message "warm connection not pooled" when it is not, at about five per hundred thousand warm exchanges on hosted runners, roughly 0.7% of checks. May a follow-up ticket let the test fixture re-establish its warm connection, at most three times, before the faulted attempt (a retry of the test's own setup, never of a paid send or of the faulted attempt)? Yes opens a ticket; no keeps the labelled failure, which a fresh ref replaces.

Asked and answer, or not asked: asked 2026-11-18 by chat as an optional follow-up (a bounded re-warm before the faulted attempt); no answer by the close, so no ticket is opened; not a gate. The rate/per-check extrapolation is [INFERENCE]; the source is clarification 1 `records[3]`. A second counted series ending on the same setup label makes this an owner escalation under amendment 11, not optional.

Final close review: approved by a fresh Fable advisor with no blocking findings: every commit, run, hash, count, criterion mapping and rule break checked against the notes, yields, hosted records, ruling and clarification; public text carries no private path, owner quote or private-record link; the PM then applied its three wording notes. RecheckT145Close (fresh advisor on Claude Fable 5.2) approved revision 4 with no blocking findings: every changed run, SHA, ref, attempt, per-system conclusion, duration, series ordinal, approval and merge time was checked against the notes, the F' approval, the hosted records and ruling amendments 3 and 4, and the public text carries no private path, owner quote or private-record link. Public ticket/paired-roadmap changes and private brief/ruling/evidence/inventory land in separate commits (D145). No decision entry, rules-digest line, build-record entry or contract-register edit is added (D161); C3's status stays in its paired roadmap line and board row. The close is Markdown-only and is not the final-series subject.

## Raw evidence references

The [inventory](ticket-145-evidence-inventory.json), copied byte for byte from `local://t145-evidence-inventory.json` (SHA-256 `15a48eca3feb572ac203d4c504688efcba3f3d5fad3bbbbaf764ef2c5677f8cc`), is the path/bytes/SHA-256 authority. Raw evidence remains outside both repositories. Roots under `C:/Users/darius.jones/worktrees/dwarf-harness/` are `t145-pm-evidence`, `t145-s1-evidence` and `t145-s2-evidence`. Remaining checks, fixture-digest pairs, import audits and mutation logs are retained by reference; no raw log is copied here. S1 report: `t145-s1-evidence/yield.json`; S1 reviewed diff `local://t145-s1.diff` SHA-256 `cbb186aa765d2ca1e0fa418e9093ceb8b60958a4ed47ed4d94bc094993237be0`. S2 report/diff provenance, breaks and stress above cite their real retained paths and hashes; the inventory also covers them.

| Path | SHA-256 |
|---|---|
| t145-pm-evidence/02-plain-x3000.log | f781414fe61ed732ff9dd3701ee03e5c7cfa2d30fc8681d582503c402728485b |
| t145-pm-evidence/03-race-x1000.log | edd1556ade1307dc979dc0b848cefdf3a24eae6bf816a083605b916df08c226c |
| t145-pm-evidence/04-plain-allmodes-x1000.log | 9bb6bb6221dbbd7d137a01fdc3e64016456b30f99d579eb163d185bacec8274f |
| t145-pm-evidence/07-diag-before-local-2.log | 0120e09e4829fca0114ffdec3a179d53817f5a1e03c8f356f527ea4766278006 |
| t145-s1-evidence/yield.json | e42cd624a54275f61c943a1a49aeff9ebe85b1ba44e16348c8cb19ec68cd7569 |
| t145-s1-evidence/deterministic-red.log | 5ff09534040ffbdcb08caf614528b416099f60e4600d74c54fc9a3468f034538 |
| t145-s1-evidence/deterministic-green.log | f0fcdda2b4107a4d889301f7eeb8ae3184e2ec0fdf72884936a2a1aab92eaae9 |
| t145-s1-evidence/break-validator-order-red.log | 2c225e24ab800b289ff595f54c2dc4b0eb52d9fc63b839416ec391d068866a8e |
| t145-s1-evidence/x20-leaves.csv | 01d433cab00fcda027b29a2f3357ed2dfa9aa52966eb61280c0366ed50eb37ea |
| t145-s1-evidence/pm-stress/commands.jsonl | 514dccc918b85fbb09aff016b70c0d23973c2a48d363dfae417d66e35beeb68d |
| t145-s1-evidence/pm-stress/01-plain-partial-header-x3000.log | 4210c4c8903dc5441b0fa42cb34bb56ebf874d46a8b990b72926da35adaecb99 |
| t145-s1-evidence/pm-stress/02-race-partial-header-x1000.log | 1c310c8f7f200acb943c827c84e9b61c5ab9be336503e30dddc2100c2007f060 |
| t145-s1-evidence/pm-stress/03-plain-all-modes-x1000.log | b9cf5d5572ad183d0408a8dc86da4668122f36d89f709fe9eaf45b565da01756 |
| t145-pm-evidence/warm/overlay.json | 2da2120017b72e03eeb776ab67d554d4ba8e61b61f2bf608c4de997158aba68f |
| t145-pm-evidence/warm/transport.go | 03a7314a73ee60976d84ffded0f2c178a34088d01fa33196216f2db77abdde9d |
| t145-pm-evidence/warm/s1-decline-reuse.log | 7272a600180b35401197a64329a4a5e14984a2b59b125447db4352ce551510e6 |
| t145-pm-evidence/warm/probe/main.go | 900fbc799b17aca77547f66ab2e2ddd9e69d26c7d52e77b36eea45173db219a0 |
| t145-pm-evidence/warm/probe/results.txt | e7636d0d6c34698fca4634b0f62baeeb3f6df408ab343ebce1be312cda90b5f3 |
| t145-pm-evidence/hosted/diag-before-42507895728-annotations.json | abb73a8e3d2fbe60110e8948090211c1fe0cf60b276f59591eda8f5e4ae89d90 |
| t145-pm-evidence/hosted/diag-before-42507895728-jobs.json | ecc295d846e2d5c27c83d96f428e42befe2c1c26d3b49ff84b144869ffe00552 |
| t145-pm-evidence/hosted/diag-before-42507895728-run.json | 245c7b7827804c1dda3ab660170cdfba5c1157860a0c4b660f5c80b117b86563 |
| t145-pm-evidence/hosted/s1-push-42509221277-row.json | 913ad4a32933c245f4e16127e9974aa69b0c920c2ea23a01d8415262c2ed953a |
| t145-pm-evidence/hosted/diag-after-42509380879-annotations.json | 44136fa355b3678a1146ad16f7e8649e94fb4fc21fe77e8310c060f61caaff8a |
| t145-pm-evidence/hosted/diag-after-42509380879-jobs.json | 351c53f1c81e667282c1f27c31f4b364a68293ffcadcf839aa1b4d6da63bac9b |
| t145-pm-evidence/hosted/diag-after-42509380879-run.json | 061a7cf3445f7fa8c07aeacc082fa8bd7e6079083f9ecd8406d6726b5e78812d |
| t145-pm-evidence/diag-after-2/zz_t145_hosted_stress_test.go | 10e53632a9fc8d15d1c775b7b84623606e37353efb2a9eca8854d0453468bbed |
| t145-pm-evidence/diag-after-2/stress-file.diff | 5176d62be01e1563d3fbffe12cfa00bb1359a47c12372e5116d4ca8bfcc96d85 |
| t145-pm-evidence/hosted/diag-after-2-42515734768-run.json | 236d50793a6d6636e729e2ebe263c82d0179fb5382385dcb2f8628da4e4081b4 |
| t145-pm-evidence/hosted/diag-after-2-42515734768-jobs.json | 8cc980556ebd4522c9f81e47886d2d92ae9ed91f1445a8a9c3e253a5934d6ba3 |
| t145-pm-evidence/hosted/diag-after-2-42515734768-annotations.json | 290cd1ffb8e95e99429ddca0ccccefb17ab666bdc1aa6bf4ec158def33139b7c |
| t145-pm-evidence/hosted/s2-push-42515714320-run.json | 43fc2bb78fde265075e7862e4ae2e177ee2d09772bb2b30210bdb0b99dbe462b |
| t145-pm-evidence/hosted/s2-push-42515714320-jobs.json | 7436dfbe79d2f86a8a3db823f1adf6aa498aa54c6f191d16bd265737fad98d60 |
| t145-pm-evidence/hosted/s2-push-42515714320-annotations.json | 44136fa355b3678a1146ad16f7e8649e94fb4fc21fe77e8310c060f61caaff8a |
| t145-pm-evidence/hosted/fprime-oneshot-44471427573-run.json | 90d40578552be18929240523d274964484084a486e5276412f97fe76600e394c |
| t145-pm-evidence/hosted/fprime-oneshot-44471427573-jobs.json | 61eaed634181f2d2bd916b52c160cf012cc25e40f6dacb6f9c40c6cbb8288513 |
| t145-pm-evidence/hosted/fprime-proof-2-44471392438-run.json | 473e05a761dd649e6fb50a76d538a5376c8abaaf63881c607a9f9361dcdfc136 |
| t145-pm-evidence/hosted/fprime-proof-2-44471392438-jobs.json | 313f2c593ff501562a72a4fe7a6f3db2769d90ff81eaf99e221d8b920799f622 |
| t145-pm-evidence/hosted/proof-2-44443383210-run.json | eb5d72ab8f45d863df2de2a4f744406234d9eb01529701b300313e073a9a8ebd |
| t145-pm-evidence/hosted/proof-2-44443383210-jobs.json | 70c0e5a4714c2d2b7b827414ab8b7e77ce0fbbf26658d386f0cd65b6bc1852db |
| t145-pm-evidence/hosted/proof-2-44443383210-annotations.json | 2b7db735143729f44bef4a8acc9f206c7ca5a1796c4906ae2021eeb533cdd2a3 |
| t145-pm-evidence/govulncheck-2ca8675.log | d834ae7c2ac901ce2af8efaa10aabdb96d7d6d1a9cfa844b0a3d4d707f1c5c64 |
