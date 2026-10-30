# Ticket 13 evidence

Each slice's evidence as reviewed, in merge order, beside the verbatim [brief](ticket-13-design-brief.md) and controlling [ruling](ticket-13-design-ruling.md). The provider-facts digest and designer's fetch remain at their [retained paths with SHA-256](#retained-source-and-raw-evidence-references), not copied into records. Neither design source links `ticket-13-anthropic-facts.md` or `ticket-13-designer-fetch.md`; their original local-source citations stay unchanged. [B36](../../../docs/DECISIONS.md#b36-c3-sealed-static-anthropic-paid-attempts-ticket-13) records the decisions; [D147](../../../docs/DECISIONS.md#d147-toolchain-go1273), [D148](../../../docs/DECISIONS.md#d148-f3-13-paid-attempt-and-accounting-records-frozen), [D149](../../../docs/DECISIONS.md#d149-the-f3-13-golden-corrected-so-that-core-replays-it), [D150](../../../docs/DECISIONS.md#d150-the-authorized-live-drill-moves-to-ticket-14-against-openai) and [D151](../../../docs/DECISIONS.md#d151-toolscheck-enforces-the-xsys-importer-allowlist) retain their separate decision authority. Detailed S2/S2b evidence remains only in the [freeze evidence](f3-13-freeze-evidence.md).

## Method and provenance

The dated event source is `local://t13-docs-notes.md:1-254`; individual verdicts are named below. Times and results are those recorded there, not new runs by this document's drafter. All slice final hashes were checked by the PM against their committed blobs; rebases preserved the owned bytes. The initial S1 evidence used go1.27.2; after D147 local evidence used go1.27.3 windows/amd64. Static checks cover windows/amd64, linux/amd64, linux/arm64, darwin/amd64 and darwin/arm64 (D137). D129 permits slice checks without race and requires the ticket's final full check with race. No Go command was run to draft this close. Sources: notes `:59-75,86-100,110-115,151-155,160-164,168-184,187-199,219-238`; D147 `docs/DECISIONS.md:2953-2967`.

The brief's citations `api/messages/create.md:3310-3360,4320-4340` are wider than the actual designer fetch: **3315–3345 and 4318–4338**, fetched at 2026-10-25 18:04:38 EDT. Its transcript proves the fetch happened; finding 9's premise that the designer lacked web access was wrong. The second fetched passage is the stream-event object list, not independent proof of the Opus/Sonnet prior-tool restriction; that restriction remains the ruling's conservative refusal. The archived brief is unchanged and this close note supplies the exact ranges (S1 review answer 5). Sources: notes `:70,75`; `local://t13-s1-review-verdict.md:48-54`; `local://t13-designer-fetch.md:3-8` (path/SHA-256 below).

## Order on main and people

| Slice | Public commits | Reached main | Coder / elapsed | Review |
|---|---|---|---|---|
| Toolchain and S1 | a2cf109, 525fc98, 64c4afb, 5cabee1, ffcca82 | 2026-10-25 21:33 | CoderT13S1, GPT-6 Astra xhigh; initial 33 min, fix-up 45m19s; PM made the toolchain/pin edits | Fresh Fable: AdvisorT13S1, AdvisorT13S1b, AdvisorT13S1c; final conditional approvals discharged by the gate |
| S2 / freeze | 687ab01, 34330e1 | 2026-10-25 22:09 | CoderT13S2, GPT-6 Astra, 51.1 min including about 11 min waiting | Fresh Fable AdvisorT13S2 approved code, record and evidence together; records a92407b |
| S2b | cd3221f | 2026-10-26 10:27 | CoderT13S2b, GPT-6 Astra, 10.4 min | Fresh Fable AdvisorT13S2b approved with record-only corrections; records 3a09f1c |
| S3a | 0cbf902 | 2026-10-26 11:31 | CoderT13S3a, GPT-6 Astra; 777.6 min elapsed across the overnight stop, including the prior evening's 44 min, not 777.6 min of active work | Fresh Fable AdvisorT13S3a approved with carried findings |
| S3b | 3eb18a1, 51cd724 | 2026-10-26 13:38 | CoderT13S3b, GPT-6 Astra; initial 79.0 min, fix-up 21m21s | Fresh Fable AdvisorT13S3b rejected test coverage, then authorized approval on a narrower PM second read and the required reruns |
| S3c | 33bd402, 8995503 | 2026-10-26 15:58 | CoderT13S3c, GPT-6 Astra; initial 72.8 min, total 134.7 min after rework | Fresh Fable AdvisorT13S3c rejected two narrow majors, then authorized approval on the specified PM read and evidence |
| S4 | acc2b06 | 2026-10-27 04:28 | CoderT13S4, GPT-6 Astra; initial 578.9 min, 613.4 min including evidence erratum | StandInT13S4 and StandInT13S4Confirm, fresh GPT-6 Astra; reporting changes applied |
| S4b | d8336c8 | 2026-10-27 04:28 | CoderT13S4b, GPT-6 Astra; 7.5 min | Included in S4's gate and both stand-in reviews |

DesignerT13 (GPT-6.1 Sol) wrote the brief; AdvisorT13Ruling (fresh Fable 5.1) ruled approve-with-changes in 19.4 min. Every review through S3c used a fresh Fable advisor, not a stand-in. S4/S4b's reviewers were the owner-ordered GPT-6 Astra stand-ins. Their approvals close ticket 13 under D160. Fable's whole-ticket audit on 2026-10-30 (AuditT13Fable, anthropic/claude-fable-5-1 at xhigh, a fresh advisor after the reset) found nothing blocking under D152 and confirmed every stand-in verdict and the design ruling; its verdict is `C:\Users\darius.jones\.omp\agent\sessions\-Documents-PROJECTS-dwarf-harness\2026-10-24T15-58-31-752Z_01a16ea2-9748-77b3-ac90-a8beabd7bc22\local\t13-fable-audit.md` (SHA-256 393c86d11544ac9ca7b6a7f40b0a1c14f073bb2584cdb3c78691cbf049862743). It recorded two readings and one limit. A host `CorrectPaidSettlement` whose trusted evidence lowers an overrun within the quote clears that attempt's fence without `AcknowledgePaidOverrun` (`paid_attempt.go:302`, `paid_budget.go:138-143`): a host-only, evidence-driven resolution path, not a bypass. P12's "one replacement" is a chain in which each correction names the latest result sequence and evidence digest for the same provider message (`paid_attempt.go:279-282`), each applying exactly one delta. OG-MODEL-FACTS stays unverified: no real Anthropic profile may be enabled until the exact integer token limits are source-verified. The earlier verdicts' before-close Fable condition is superseded, not represented as an audit already performed. Sources: notes `:14-16,32-47,59-75,78-100,107-115,123-135,150-164,168-199,219-238`; `docs/DECISIONS.md:3181-3184`.

## S1 and the toolchain (2026-10-25)

Record-free `providers` and `credentials`: 21 new files, 30 test functions and three seeded fuzz targets. The initial 00c97ad was rebased to 525fc98; the test-only cf29756 became 64c4afb. a2cf109 moved the installed toolchain pin; 5cabee1 corrected Core's current CI records; ffcca82 fixed two missed native-test pins. D147's records commit is c551c3b. Sources: notes `:59-69,78-100,103-107,120-124`; D147 `docs/DECISIONS.md:2953-2967`.

| Run / gate | Observed result |
|---|---|
| Coder final V1 / race, initial S1 | Command elapsed 4.716 s / 32.022 s; providers package 2.986 s / 12.326 s, credentials 0.741 s / 1.640 s; providers' warm-connection rows passed ×20 under race |
| PM first gate, 00c97ad | `check FAILED: 2 of 9 steps failed in 534.9s`: govulncheck on all five targets found GO-2026-6809 in go1.27.2 Certificate.Verify; partial_body's server counts were observed before the server had consumed the partial request |
| Test fix-up | Controlled real-TLS probe reproduced early-close counts 1/1 and terminal-state-first counts 2/1; all five fault rows and status/redirect/certificate rows now wait for terminal connection state before Close/counts. The raw early-close mutant itself passed once because the defect is scheduling-sensitive; the controlled probe, not that mutant, proves the mechanism |
| Load proof | First whole-repository run failed only graph tooling because the runner passed forward-slash tool paths; second run with canonical paths passed everywhere (providers 6.8 s). Providers ×20 race passed; formatting and five-target vet/staticcheck clean |
| Full check, 64c4afb after go1.27.3 | `check FAILED: 2 of 9 steps failed in 2105.1s`; govulncheck and every other step passed; only tests/race failed, on go-analyzer's native request still naming go1.27.2 and graph's wrong-version row naming the now-current go1.27.3. Descendant proof requalified the new tuple; art regeneration was clean |
| ffcca82 fixes | Native request now go1.27.3; wrong-version row go1.26.0, below the module minimum; affected package runs passed plain and race |
| Final PM slice gate, ffcca82 | `check PASSED: 8 of 9 steps passed, race skipped (D129) in 521.4s`; tests 457.0 s; agents 238.1 s, ledgerstore 331.8 s, workspace 447.1 s, graph 184.1 s, go-analyzer 6.7 s, providers 8.8 s, credentials 1.6 s; no cached package |

PM fuzz on 00c97ad, each 120 s and exit 0: `FuzzProviderProfile` 617,974 executions / 170 new interesting; `FuzzProviderSSE` 24,298 / 12; `FuzzPaidMoney` 3,150,525 / 12. V6/V7/V10, formatting, staticcheck and LF were clean as recorded, apart from the named vulnerability gate failure. The synthetic native targets and the PM probe were read back absent; enumeration found none. Sources: notes `:59-75,79-100,103-107,120-124`; `local://t13-s1-coder-report.json` timing and commands; raw logs in the S1 folders below.

### S1 breaks and PM answers

All 31 production-rule mutations failed their named assertion, were restored byte-identically and passed green. The separate early-close scheduling probe is not counted among those 31.

| Breaks | Observable regression |
|---|---|
| A1/A2, B | `TestRectangularBoundAndOneFinalRounding`: independent maxima, higher input rate, one final rounding |
| C1/C2/C3 | `TestRequestFramingBindsEveryField`: framing and field identity |
| D | `TestRectangularBoundAndOneFinalRounding/input_class_overlap` |
| E1/E2/E3 | `TestProfileRefusesStaleIncompleteAndAmbiguousFacts`: after expiry, equality at expiry, missing no-charge source |
| F | `TestSSEFramingAndCumulativeReplacement` |
| G1/G2 | `TestUsageExclusiveCacheAndReasoning`: no aggregate-write duplication or reasoning/output duplication |
| H | `TestSSERejectsIncompleteAndInvalidTransitions/eof_is_not_stop` |
| I1/I2 | `TestPaidHTTP1OneShot/zero_write`: replayable/zero-length-body paths |
| J1 / J-empty / J2, each for standard and X headers | Valued forbidden header caught on wire; empty-slice key caught by sealed-header-set proof; rewindable body plus header caught by warm read-EOF |
| K | `TestTransportALPNHeadersAndStatusesNeverRepeat`: HTTP/2 path |
| L1/L2 | `TestTransportRedirectDestinationReceivesNothing`: follow alone for 301/302/303, follow plus GetBody for 307/308 |
| M-odd/nul/surrogate/oversize | `TestNativeBlobRefusesMalformedAndOversize` |
| N | `TestEnvironmentBindsOnceAndReleasesOwnedMemory` |
| O | `TestCompilerRejectsUnsupportedStaticFeatures/prior_tools_claude-opus-5-5` |

The PM's assistant-originated answers, all confirmed in S1's review:
1. `no_charge_rules` follows `tool_choices` before tariff, required sorted/non-null, `[]` for Haiku.
2. The typed compiler is S1's pure provider work; the agent preparation entrance belongs to S3b.
3. **Changes ruling finding 4:** with positive length and GetBody nil, Go does not consult idempotency headers for replay. Use J1/J-empty/J2 above; count exactly one faulted request for read-EOF, zero additional requests after it, and zero after the warm exchange for zero-write.
4. **Changes ruling finding 4:** removing CheckRedirect alone cannot follow a positive-body 307/308. L1/L2 use the observables above.
5. **Corrects ruling finding 9's premise:** the designer fetched the sources; archive the exact result and state the actual ranges, without claiming it proves the conservative prior-tool restriction.

The re-reviews upheld the deterministic terminal-state wait, D147 and the package reruns. The optional fail-fast diagnostic for the three native toolchain-pin fixtures was not scheduled; the next toolchain move should consult D147's explicit list, rather than add speculative checks here. Sources: notes `:49-58,70-76,79-100,103-107`; `local://t13-s1-review-verdict.md:19-54,83`; `local://t13-s1b-review-verdict.md:8-51`; `local://t13-s1c-review-verdict.md:1-36`; the S1 coder report's breaks.

## S2 and S2b (2026-10-25–26)

The [freeze evidence](f3-13-freeze-evidence.md), including its D149 correction section, is the detailed record and is not copied here. CoderT13S2 built 687ab01; AdvisorT13S2 approved the eight types, schema-4 submissions, digest agreement and evidence with the freeze. Its code precheck passed without race in 606.7 s; the public record 34330e1 passed in 549.6 s. S2b cd3221f, built by CoderT13S2b and reviewed by AdvisorT13S2b, corrected only the generator/setup order and regenerated log; its check passed without race in 556.2 s. D148's record is a92407b; D149's is 3a09f1c. The original and replacement golden digests and the seq-27-to-seq-150 before/after probe are in that existing evidence. Sources: notes `:107-140,147-157`; D148/D149 `docs/DECISIONS.md:2969-2999`.

The PM's assistant-originated S2 readings and answers, confirmed by its joint review:
1. Kind and non-secret locator replace opaque source IDs; source kind is open, locator visible ASCII without spaces.
2. Keep the brief's CostBound/priced-component order; the descriptor uses requested_tier and nested UUIDv7 credential scope/version. Costs are plain int64 JSON integers; unpriceable overflow holds. Raw data belongs in observation, not paid_result.
3. Field grammars remain decoder rules; installation/collection limits are producer rules. The 264-reference vector is a conservative 256-block-plus-eight-chunk envelope, not a frozen count cap.
4. Required Anthropic source topics are installation semantics, not generic ledger-decoder semantics.
5. Synthetic golden environment binding is a known source kind; unfamiliar kinds are exercised by codec/fuzz input. Reusing earlier setup identities under a different colony is sound.
6. Keep comment corrections R10/R11 and add the sibling-operation-arguments sentence; no public V4 placeholder, and base ffcca82. Optional enumeration of error_class writer values was not added to the frozen codec text.
7. **Changes the brief's artifact rule:** input_object equals the descriptor's body identity, hence the exact sealed body, not a paid_input wrapper. The golden's output/observation objects are synthetic shapes and never parsed by Core.
8. Accept the golden's noncompiler key order without regeneration; compare bytes/hashes, never recompile it.

The owner's separate-fix choice is quoted in D149. The S2b review's record corrections were applied there; its inventory-script nit required no code change because the PM verified the blob hashes. The S2b loader and permanent Core replay guard were carried into S3a. Sources: notes `:94-100,109-115,132-139,147-157`; `local://t13-s2-verdict.md:8-64`; `local://t13-s2b-verdict.md:19-63`.

## S3a (2026-10-26)

0cbf902 adds complete replay of all eight types into the existing book, fences, paid-child endings, watermark novelty checks, views and reconciliation. Four goldens, chapters 10–13, open through the real service; frozen-13 reaches 150 and is artifact-independent. Coder plain/race package times: agents 70.7 s / 476.3 s; the original eviction row was 108.50 s under race. The PM's exact-commit gate passed V6 (agents adds providers), V7, formatting, staticcheck and LF; contract unchanged; `check PASSED: 8 of 9 steps passed, race skipped (D129) in 538.7s` (agents 257.9 s, ledgerstore 332.8 s), no cached package. AdvisorT13S3a approved once the remaining gate items landed. Sources: notes `:158-165`; `local://t13-s3a-verdict.md:4-75`.

| PM fuzz, 120 s each | Executions | New interesting |
|---|---:|---:|
| FuzzPaidGroupReplay | 71,852 | 144 |
| FuzzScopedGroupReplay | 24,388 | 10 |
| FuzzPrivateGroupReplay | 559,876 | 1 |
| FuzzReviewGroupReplay | 22,035 | 22 |
| FuzzProviderProfile | 521,441 | 70 |
| FuzzPaidMoney | 3,179,325 | 0 |

All exited 0 with no corpus left (notes `:163`). Breaks M/L/K/G/W/R each failed red and passed after byte-identical restoration: M ignoring the paid family failed frozen-13; L ignoring paid children failed parent endings; K adding rather than subtracting predecessor cost failed original-period replacement; G clearing fences on configuration failed the unlimited/fence row; W omitting historical credential novelty failed post-revocation reuse; R reading observation bytes during replay failed artifact-independent frozen-13. Raw break inventory: `t13-s3a-evidence/breaks.json`; review confirmation: `local://t13-s3a-verdict.md:59-65`.

PM answers:
1. Split provider installation validation from historical semantic validation/arithmetic; existing live exports keep their validation. Historical entries omit installation-only source/size/lifetime rules, not money rules.
2. Source identity means scope→provider permanence and version→(scope, kind, locator) immutability plus the watermark; locator reuse is not prohibited.
3. The frozen setup blocker waits for the owner; S2b/D149 resolves it before the final replay run.
4. **Clarifies the S2 review's unfamiliar-token note:** an unfamiliar source kind forbids live credential use, but never changes historical cost or refuses Open. Only money-deciding unknown tokens can withhold financial effects.

All four were confirmed by the review. Its three minors and five nits are dispositioned below, not lost as implied acceptance. Sources: notes `:145,148-149,158,162`; `local://t13-s3a-verdict.md:57-66`.

## S3b (2026-10-26)

3eb18a1 supplies controls, credential sources, shared clock, spend delegation, preparation, raw-body input publication, atomic admission and reserved-to-released_unsent reconciliation. Coder agents plain/race: 168.7 s / 941.2 s; eviction row 283.8 s under race. The first PM gate passed V6 (agents adds credentials), V7, formatting, staticcheck and LF, with contract/providers unchanged and no native test credential remaining; `check PASSED: 8 of 9 steps passed, race skipped (D129) in 662.5s`, no cached package. Sources: notes `:167-172`.

PM changed-code fuzz: `FuzzPaidGroupReplay`, 120 s, 125,762 executions, 60 new interesting, exit 0 and no corpus left. Source: notes `:171`.

AdvisorT13S3b rejected one test-only major: mismatch-only rows never reached model-call authorization. 51cd724 adds six prepare-time rows, the positive model-only row included; a route-binding mutant at both authority sites makes the wrong-route row fail, then both production files were restored to 3eb18a1 hashes. The first nil-resources mutant failed closed and killed only the positive row; that unsuccessful mutant is retained in the logs, not claimed as the proof. The fixture hot limit is eight (eviction row 1.99 s plain / 13.13 s race); the native test follows windows.NewLazySystemDLL. Coder agents plain/race reruns: 71.2 s / 416.1 s, nothing over 60 s. The PM made the authorized second read of the rows, break and restored hashes. The four-test-file successor check passed without race in 535.8 s (agents 264.5 s), no cached package, no native test targets. Sources: notes `:173-180,183-184`; `local://t13-s3b-verdict.md:8-41,53`.

| Break | Named observable |
|---|---|
| A, skip enabled-spend ancestry | TestPaidAuthorityAndAttenuation/disabled-spend-ancestor |
| B, synthesize current authorization / ignore absent pinned secret | TestPaidCredentialPinning |
| D, subtract output from input bound | TestPaidSealAndQuote/input_plus_requested_output_above_context |
| E, skip profile sources | TestPaidProfileAndFeatureRefusal/incomplete-source |
| F, omit shared grant ancestors | TestPaidAtomicScopes |
| U, make sent reservation releasable | TestPaidUnsentRelease |
| Fix-up route-binding break at both checks | TestPaidAuthorityAndAttenuation/prepare-time wrong-route row |

Each accepted break was red then restored green, with byte-identical production restoration (`t13-s3b-evidence/yield.json`, breaks; notes `:169,174-179`).

PM answers, assistant-originated and confirmed within the review/rework scope:
1. **Clarifies ruling limit 2:** at least one bind per credential scope per Core start is the owner's burden; rotations are unlimited, constrained by identity/novelty rules, not a per-start count cap.
2. The authority break must touch both duplicated checks, not one masked site; include a positive model-only preparation/admission row.
3. Do not broaden the bypass when turn-only is already denied by the operation check.
4. Replace the fail-closed nil-resources mutant with grant-owned resources at both sites, so failure proves requested-route binding.
5. Match the test baseline's configurable hot limit to OpenPaid when reducing the eviction row; preserve the failed V1 and restart final runs.

The review also accepted integrity-only verification of the exact-origin caller's own input under turn.inspect, returning no bytes; S3c extends that split to output/observation. Sources: notes `:168,174-180`; `local://t13-s3b-verdict.md:45-53`.

## S3c (2026-10-26)

33bd402 supplies durable one-use intent, real HTTP/1.1 TLS/SSE, capture and private objects, factual observation, corrections, overrun acknowledgement, sent-to-unknown recovery and object reads. Coder's initial command elapsed plain/race was 96.4 s / 544.0 s across both packages; the review's agents-only figures are 89.7 s / 509.6 s, providers race 14.1 s. These are different measures, not conflicting passes. Sources: notes `:187-190`; `local://t13-s3c-verdict.md:71`.

The exact-commit PM gate passed V6/V7, formatting, staticcheck and LF, with contract and credentials unchanged; each 120 s fuzz campaign exited 0 and left no corpus: paid replay 59,527 / 21 new, SSE 107,666 / 15, money 1,572,160 / 0. `check PASSED: 8 of 9 steps passed, race skipped (D129) in 1502.6s`, no native targets. This check overlapped the coder's rework race run: workspace 1,278 s, ledgerstore 1,036 s and agents 715 s all slowed; it is not the clean successor timing. Sources: notes `:188-192`.

AdvisorT13S3c rejected two majors. 8995503 changes Secret to an RWMutex, read-locking each cleared owned borrow and write-locking release; `TestPaidNetworkUnknownAndSlotDrain/concurrent-exchanges` was red on 33bd402 (one POST, timeout/unknown) and green after (two settlements, exactly two POSTs on the same credential). `TestSecretConcurrentBorrowersAndRelease` covers the source boundary. `TestPaidPreparedLifetime` and `TestPaidIntegrityOnlyInspection` were restored byte-identically from 51cd724, with no changed expected error. The observation-size minor was also fixed, with an oversize-stop-details row degrading to fixed unknown and preserving the hold. Coder agents reruns 218.9 s plain / 774.3 s race were under the overlapping PM load. Sources: notes `:190-194`; review `:8-30`.

The PM made the narrower read the reviewer authorized: lock ownership, concurrent row, credential test and restored-test byte identity. The separate successor gate on 8995503 passed LF, scope and `check PASSED: 8 of 9 steps passed, race skipped (D129) in 778.5s`, no cached package (agents 396.9 s), no native targets. No fuzz rerun was required because the rework changed only live capture/read/settlement bounds and credential locking, not the fuzzed replay/provider paths; this is the review's conditional rerun rule, not a missing campaign. Sources: notes `:194-199`; `local://t13-s3c-verdict.md:72`.

| Break | Named observable, red then green with equal restored hashes |
|---|---|
| H, intent ordering | TestPaidIntentBeforeBytes/durable-before-tls-and-duplicate-never-resends |
| I, forbidden idempotency header | TestPaidHTTP1OneShot/200; this is wire-header proof, not a GetBody retry proof |
| J, exclusive-cache accounting | TestAnthropicStreamAndUsage/complete-artifacts |
| O, documented refusal classifier | TestAnthropicRefusalBilling/null-free |
| K, correction arithmetic | TestPaidSettlementAndCorrection/live/one-delta-original-period |
| B, mutable-source dispatch | TestPaidCredentialPinning/dispatch/pinned-before-source-change |
| S, recovery releases sent money | TestPaidCloseDrainsAndReconcileHolds |

Source: `t13-s3c-evidence/breaks.json`; `local://t13-s3c-verdict.md:70`; notes `:187,190`.

### Four S3c PM answers

These are assistant-originated decisions, not new owner decisions; the S3c review confirmed all four.
1. **Completes the brief's seam shape:** accept roots and a raw TCP wrapper only; provider code still owns dial, handshake and verification. Access is through private serviceDeps, not PaidOptions or a public dial callback.
2. Admit two additive provider facts: preserve the count of begun content blocks across errors/refusal and normalize trusted sealed usage after buffers drain. Also fix S3b's omission: scan literal/decoded escaped secret input before compile, hashing or publication; dispatch rechecks it before intent.
3. **Completes the artifact consumer entrance:** add bounded ReadPaidObject for only the attempt's referenced objects; exact origin, owned copy, identical denials, authority rechecked after I/O, no clock/charge/record; Agent bytes need private.read, owner stays passive.
4. **Settles the private-read target:** current private.read must cover continuation, handoff, memory and transcript on the originating context; a slot-limited grant is denied. Status remains under exact-origin turn.inspect.

Sources: notes `:181-182,186`; `local://t13-s3c-verdict.md:63-69,86`; carried close notes `local://t13-notes-for-s3.md:95-98`.

## Carried review items and dispositions

The source is the named review plus `local://t13-notes-for-s3.md`, items 1–80; numeric ranges below refer to item numbers, not line numbers.

| Origin / carried items | Closure or deliberately retained boundary |
|---|---|
| Ruling findings 1, 5, 6 | Ledger-only Open, single clock/floor, separate novelty watermarks and pinned retired digests implemented in S3a/S3b; artifact-present/absent and cold-site measurements in S4 |
| Ruling finding 2 and nits 11/12/14 | D148 and existing freeze evidence record additive turn-child/unit interpretation, submissions/digests/maxima and period semantics; no repeated freeze |
| Ruling findings 3/4/7/8/9/10 and nit 13 | Profile no-charge facts; corrected warm retry/redirect tests; record-free S1 and S3b unsent release; session-persisted native test; actual designer-fetch provenance; unbound-credential reconciliation; owner-CAS/expiry semantics |
| S1 minor digest escaping / api_version nit | S2 uses json.Marshal-compatible profile/tariff bytes and always writes api_version; agreement/escaping tests and frozen source quotes pin it |
| S1 Haiku no-charge nit | Deliberately retained fail-closed installation limit, listed below |
| S1 dead check / unobservable drain test | Deleted in S3a / S3b respectively; no replacement weightless test |
| S1 third-importer obligation | S4b implements D151's allowlist; B36 references that decision rather than indefinitely leaving B18 to review |
| S1/S2 notes 1–29 | Historical exact pricing, hold classification, zero-rule membership, current profile at admit/intent, borrowed-secret lifetime, response metadata boundary, timeout policy, native source locator, sealed-body publication, exact schema-4 arguments and bound observation normalization implemented across S3a–S3c; the golden bodies are compared, never recompiled |
| Toolchain review | Current CI records fixed in 5cabee1; D133 amendment and analyzer tuple in D147; missed native pins fixed in ffcca82; optional future fail-fast diagnostic not scheduled |
| S2 input-object minor / argument-set nit | D148 corrected to raw body and documents rejection of sibling operations' argument keys; optional writer-class enumeration not added |
| S2 golden-body order / category grammar | No regeneration for body order; retain grammar-bound no-charge category, otherwise unknown hold |
| S2b notes 30–34 | Shared loader handles chapter 13 and nested context-owned objects; permanent four-golden Open regression; paid groups actually consumed and command IDs still retained by S3a |
| S3a notes 35–42 / nit item 52 | Refresh before planning, current-route denial order, shared clock/floor, colony-first/attenuated spend, irreversible credential novelty, PaidReceipt reuse and locator reconciliation in S3b; integrity-only inspection explicitly accepted; above-watermark status shortcut, original AdmissionPeriod assertions and owner ErrUnavailable corrected |
| S3a finding 2 / notes 43–47, 53 | S3c keeps prior evidence digests hot, covers undeclared-rule refusal vs unfamiliar-declared-rule hold, preserves source/message/output monotonicity and exact previous result identity; no live-authority recheck on factual post-intent results |
| S3a finding 3 / notes 48–51 | Bound Agent budget history remains a labelled cold site; S4 measures it, other cold sites and Open's artifact independence; no ordinary-path performance claim conceals it |
| S3b major and native/eviction nits | 51cd724 supplies actual prepare-time authority proof, the route-binding break, standard DLL loader and the configurable eight-entry eviction fixture |
| S3b findings 2/3 and nit 4; notes 54–58, 63 | S3c refuses well-formed Sonnet/Opus prior-tool history, builds matched BoundCall from recorded admission and releases the fresh handle, checks ErrClosed before authority, borrows around dispatch, drains physical buffers without releasing unknown money, uses private root seam and keeps factual endings independent of current authority |
| S3c majors 1/2 and minor 3 | 8995503 concurrent borrows plus red/green exchange proof; deleted S3b tests restored byte-identically; 1 MiB observation limit and oversize unknown fallback |
| Notes 59–61, 64–69 | S4 owns solo/full-check eviction timing, ×20 race rows, expanded cold-site counts, remaining GetBody/redirect mutants, two publication/crash windows, physical-capacity statement and artifact-present/absent Open measurement |
| S3c minor 4 / notes 70–75 | S4's disposition is recorded in the following section |
| Close notes 62, 76–79 | All seven ruling limits with corrected binding wording, extra hold/revocation/refusal/size limits and private-read/artifact boundary are recorded below; four PM answers above |

Sources: notes `local://t13-docs-notes.md:70-76,99-107,132-139,153-164,172-180,187-199`; verdicts `local://t13-s1-review-verdict.md:19-54,83`, `local://t13-s2-verdict.md:8-64`, `local://t13-s3a-verdict.md:6-66`, `local://t13-s3b-verdict.md:7-69`, `local://t13-s3c-verdict.md:7-87`; `local://t13-notes-for-s3.md:5-98`.

### S4 closure of carried findings

- Items 48–51, 59–61 and 64–69: the labelled run 04 measures cold public triggers, artifact-independent Open and separate paid cohorts; the warm transport mutants fail red and restore green. The 35-window crash matrix covers publication failure, published-but-uncommitted evidence, original-period money and zero recovered sends. Race ×20 passed in 365.0 s; the eviction row is 5.89 s isolated and 17.74 s in the corrected repository-load replica.
- Items 70–75: deterministic `recovery_reconciled` error object with the unchanged `unreachable` class; secret scanning uses `bytes.Contains`; one transport constructor; Close-drain assertion precedes draining the result; observation comparison uses an independent literal; host factual-read reservation limits are documented. Lifetime, integrity-only reads, concurrent borrowing and oversize-observation regressions remain.
- Item 80: the driver uses package-private `publishObject` for a late-evidence object before public correction, explicitly the one additional seam beyond clock and TLS roots; no public publisher was added.
- Stand-in reporting corrections: use the retained measurement erratum for structural reservation arithmetic and proxy boundaries; N-permit detects a forbidden fresh `ObservedPaidCall`, not a reconstructed send capability. Calls-only and openedThrough-only remain defence-in-depth survivors; the separate recovery row sees zero requests. D151 admits the three ordinary importers' own test variants, plus agents tests only.

Sources: `local://t13-docs-notes.md:212-239`; `local://t13-s4-verdict.md:8-95`; `local://t13-s4-confirm-verdict.md:63-105`; `t13-s4-evidence/measurement-erratum.md:7-85` (retained path/SHA-256 below).

## S4 evidence

S4 acc2b06 and S4b d8336c8 were merged on 2026-10-27 after StandInT13S4's conditional approval and StandInT13S4Confirm's final approval with the record-only qualification applied. No product-code blocker remained. Retained evidence separates these observations:

| Observation on d8336c8 | Result and boundary |
|---|---|
| First full check | Failed in 1,687.1 s only in unchanged winexec's peer-input row: path-not-found (3), not disclosure and not proven denial; peer cleanup ordering is an unconfirmed inference. |
| Uncached full-check rerun | All nine steps passed in 1,600.0 s; agents race 1,011.6 s, workspace 1,036.4 s, ledgerstore 919.3 s; all below D127's 1,500 s report and the 1,800 s step limit. Scope, unchanged contract, V6/V7, formatting, staticcheck, LF and five-target importer evidence passed; synthetic native credentials absent. |
| First verbose race replica | Eviction row 12.99 s, agents 982.4 s; failed native-analyzer setup because the script omitted `.exe`. Not equivalent full-check load. |
| Corrected verbose race replica | Native analyzer workloads executed and passed; eviction row 17.74 s, agents 1,008.3 s. Exit 1 only in unchanged winexec CPU-test child startup: exit 66, an 8 MiB TSAN allocation failure with ERROR_INVALID_ADDRESS; the precise allocation-failure cause is unconfirmed. This timing evidence is not the passing gate and proves no CPU-quota enforcement. |

Carry both winexec observations into the separate follow-up without weakening an assertion, skip, retry policy or product limit. The failed gate and both diagnostic replicas remain evidence rather than being relabelled passes. Sources: notes `:227-239`; `local://t13-s4-confirm-verdict.md:16-106`.

Coder final runs: agents plain/race 81.4/453.5 s, providers 2.1/11.7 s, credentials 0.8/1.9 s; ×20 race campaign 365.0 s; isolated eviction row 5.89 s. S4/S4b changed no fuzzed path, so the actual changed-target list was empty and no extra fuzz campaign was run. S4b's nine import-boundary rows and three red/restored-green mutations passed, with real-module checks on all five targets. Sources: notes `:219-225`; stand-in verdict `:57-87`.

## S4 labelled measurement

Corrected run 04 took 12,169.7 s with all 78 product hashes unchanged before/after. Run 03 (16,781.2 s) remains superseded because it mislabelled rollover/missing-account cold preconditions and capacity text; use run 04 with its explicit erratum, not silently corrected raw output. History before the paid cohorts was 1,290 / 2,616 / 12,934 records (1× / 2.028× / 10.026×); Open occurred later at actual frontiers 2,229 / 3,427 / 13,745.

| Open frontier | agents Open, artifacts present / absent (s) | Paid artifact reads / financial state |
|---:|---:|---|
| 2,229 | 56.329 / 56.367 | zero / identical |
| 3,427 | 123.441 / 122.793 | zero / identical |
| 13,745 | 1,794.073 / 1,560.737 | zero / identical |

These are bookkeeping observations on one run, not causal speed comparisons, SLA, measured capacity or C3-exit qualification. The source summary retains operation quantiles, money/exposure, logical footprint, allocations, cold-trigger counts and CPU-profile interpretation by stage. Cold counts mean public triggers with stated preconditions, not internal scan counts; overlapping new-period/Agent triggers are not added. Zero single-call timings are sub-tick observations; revoked-preparation batches separately report 1,000-call means (20.4–30.5 µs/call).

The erratum is controlling for derived labels: structural request bound 3,148,066 bytes reserves 70.0446 MiB per maximum preparation. Three active exchanges with sixteen preparations total need 1,408.7135 MiB; with sixteen additional unadmitted preparations, 1,618.8473 MiB. Neither fits the configured 1 GiB. The run exercised separate cohorts, not those combinations: three maximum exchanges (derived paid reservations 498.1338 MiB), then sixteen small admissions with zero dispatches (161.0577 MiB). These are accounting reservations, not RSS.

Witness-to-headers/response proxies exclude the preceding `PaidAttemptStatus` observer call and commit-to-witness gap; overall dispatch includes them. The settlement proxy includes settlement plus final status lookup after capture/instrumentation, not exact stream-finish timing. Source summary, erratum, raw output, driver, profiles and manifests are retained by path/SHA-256 below. Sources: notes `:219-230`; `measurement-summary.json:33-108,3671-3800,4171-4183`; `measurement-erratum.md:7-85`.

The driver ran after the final product edit, saved its source/output outside the repository and was deleted before final runs. It uses the clock/TLS-root seams plus the explicitly authorized `publishObject` exception for late evidence. No live drill occurred. The stage-level source summary and profile links retain the detailed measurements without copying raw logs, receipts or profiles into records. Sources: notes `:212-222`; stand-in verdict `:57-78`; `local://t13-s4-coder-report.json:2593-2606,3622-3626`.

## S4b the importer rule

d8336c8 adds only D151's x/sys importer allowlist to tools/check: exact packages internal/core/durable, internal/core/winexec and internal/core/credentials and their own test variants, plus internal/core/agents tests only. It discharges B18 item 7, whose trigger had already arrived. The full check and both stand-in reviews above include the rule; D151 and B18's pointer already landed in records 66d9bc8 and are not appended again. Sources: `docs/DECISIONS.md:1240-1243`; notes `:224-239`; stand-in verdict `:33-37,81-87`.

## Acceptance coverage

The six original criteria are ticket 13 `:35-40`; the ruling's map is `ticket-13-design-ruling.md:41-48`. Earlier acceptance-function locations below were checked on main 8995503; S4 adds agents' `TestPaidInjectedCrashRecovery` at `internal/core/agents/paid_crash_test.go:110` (35 windows). Its final gate and stand-in review are recorded above, not proposed test names.

| Criterion | Existing acceptance tests and boundaries |
|---|---|
| 1: authority/credentials/features/freshness; exact money; unlimited still bounded | agents TestPaidAuthorityAndAttenuation (including the fixed prepare-time rows), TestPaidCredentialPinning, TestNativeCredentialSource, TestPaidProfileAndFeatureRefusal, TestPaidPeriodsWarningsAndOverrun; providers TestMoneyGrammarAndCheckedBoundary |
| 2: exact seal/hash/one-rounding quote; no mutable key or secret publication | agents TestPaidSealAndQuote, TestPaidCredentialPinning, TestPaidIntentBeforeBytes, TestPaidLiteralCredentialInputRefused, TestPaidCaptureRejectsCredentialEcho; providers TestRequestFramingBindsEveryField, TestQuoteFramingUsesHexTariffAndDisjointSortedComponents, TestTransportUsesOnlySealedHeaderSetAndBody |
| 3: independent maxima/exclusive classes/no double count/overflow | agents TestPaidSealAndQuote's three literal vectors; providers TestRectangularBoundAndOneFinalRounding, TestQuoteFramingUsesHexTariffAndDisjointSortedComponents, TestUsageExclusiveCacheAndReasoning, TestCompilerCanonicalBodyAndCacheHierarchy |
| 4: atomic scope/ancestor holds; warnings and rollups | agents TestPaidAtomicScopes, TestPaidAuthorityAndAttenuation, TestPaidPeriodsWarningsAndOverrun, TestPaidSettlementAndCorrection; S4's race and crash proof above |
| 5: intent before bytes, one physical POST, no retry/redirect/H2, honest recovery | agents TestPaidIntentBeforeBytes, TestPaidHTTP1OneShot, TestPaidUnsentRelease, TestPaidNetworkUnknownAndSlotDrain, TestPaidCloseDrainsAndReconcileHolds; providers TestPaidHTTP1OneShot, TestTransportALPNHeadersAndStatusesNeverRepeat, TestTransportRedirectDestinationReceivesNothing, TestTransportUsesOnlySealedHeaderSetAndBody, TestTransportRejectsUntrustedCertificate; S4 crash/publication rows above |
| 6: final cumulative usage/duplicates/original tariff-period/overruns/no-charge/artifacts | agents TestAnthropicStreamAndUsage, TestAnthropicRefusalBilling, TestPaidSettlementAndCorrection, TestPaidPeriodsWarningsAndOverrun, TestPaidOverrunAcknowledgement, TestPaidNoChargeRuleSet, TestPaidParentEndingAndDisclosure; providers TestSSEFramingAndCumulativeReplacement, TestUsageNullOmissionAndFinalCounter, TestRefusalPreservesStartedBlockEvidence, TestNormalizeSealedCacheEvidence; S4 crash/publication rows above |

Function-location sources on 8995503: `internal/core/agents/paid_admit_test.go:17,153,216,244`; `paid_credentials_test.go:19`; `paid_controls_test.go:14,90,157`; `paid_native_windows_test.go:33`; `paid_native_other_test.go:13`; `paid_live_test.go:144`; `paid_exchange_test.go:107,198,318`; `paid_transport_test.go:55`; `paid_lifecycle_test.go:19`; `paid_money_test.go:23,132`; `paid_ack_test.go:14,95`; `paid_status_test.go:15,65`; `paid_capture_test.go:102,146`; `paid_prepared_lifecycle_test.go:11,118`; `paid_replay_test.go:29` (all under internal/core/agents). Providers sources: `internal/core/providers/envelope_test.go:14,70,140,203,279`; `profile_money_test.go:46,108,160,183`; `anthropic_stream_test.go:44,77,127,158`; `transport_test.go:106,216,238,286,329`; `sealed_evidence_test.go:17,35,72`; `ledger_profile_test.go:19,116`. Contract names were also checked: `contract/ledger/paid_test.go:95,139`, `paid_validation_test.go:49,78`, `paid_compatibility_test.go:14,110`, `paid_fixtures_test.go:119`, `paid_golden_test.go:403`, `paid_fuzz_test.go:13`. The contract assertions themselves remain in the freeze evidence, not duplicated here.

## Limits and consumer boundary

The ruling's seven explicit close limits, with limit 2 clarified by the PM's S3b answer:
1. An unknown hold after provider error, timeout or disconnect has no discretionary release path in ticket 13: no owner-entered amount or general provider-status lookup. It remains exposed until admissible later evidence supports a settlement.
2. At least one BindCredential per credential scope per Core start is the owner's burden; rotations are unlimited. Restart never silently rebinds mutable bytes to an old version.
3. The first colony spend configuration fixes its period kind in this version, even if disabled.
4. A route is unusable from expires_utc_ns, normally seven days after verification unless the owner chooses otherwise at installation.
5. A stale keep-alive transport failure yields an unknown hold, without redial/retry.
6. The default 120 s dispatch deadline and 30 s header timeout are drill defaults, not verified production settings.
7. Haiku 4.5 refusals do not settle zero, and structured prior-tool history on Opus/Sonnet refuses before admission/send.

Additional carried limits:
- A Haiku 4.5 profile declaring a no-charge rule is refused at installation until the parser changes. Its refusals hold even midstream with complete usage; any refusal that began a content block never settles zero.
- Recovered/reconciled intents end unknown with error_class unreachable because the version-1 classification set is closed; S4's deterministic recovery_reconciled error object distinguishes recovery from an observed dial failure.
- Observation objects are limited to 1 MiB. Oversize capture normally degrades to the bounded fixed unknown observation; if no observation can be published (including a size/publication failure), DispatchPaid returns its intent receipt without an observation and the host reconciles sent to unknown. No missing object releases money.
- Credential revocation is durable before it waits for in-flight borrowers to drain, bounded by DispatchTimeout; owned copies are cleared, but Go/net/http strings and OS memory provide no secure-erasure guarantee.
- Agent ReadPaidObject requires current private.read over all four context slots on the originating context. Exact-origin status and integrity-only inspection stay under turn.inspect; status is not byte disclosure.
- Input objects are exact sealed bodies. Output/observation encodings are unfrozen and documented in agents/doc.go; compared with brief §7.4 the observation adds content_blocks, content_error, profile_violation and error_class. Records bind digest and size, not those encodings. Host factual evidence reads follow the documented owner-read pattern without a physical byte reservation; Agent reads are reserved.
- Historical paid lookups, credential novelty below the watermark, historical/task/bound-agent budget folds, command lookup, inherited contextTask and historical object selection remain the labelled cold sites, not an index implementation. Duplicate evidence's three-record receipt scan is bounded; hot later results no longer fold history just for prior-evidence identity.
- No OpenAI adapter, turn/tool loop, scheduler, task-fact listing, concurrent restart qualification, A2, invoice-wide cap, real promotion or real-work readiness is supplied by this ticket.

Sources: ruling `:13-27,31-37,48`; `local://t13-notes-for-s3.md`, items 48–79 (`:63-98`); notes `:168,181-199`; `local://t13-s3c-verdict.md:27-59,63-87`. The S4-specific closures above are grounded by its filled evidence/review, not presumed from the assignment.

## Owner process decisions and live drill

Only this private evidence and DECISIONS.md quote the owner.

| Event | Exact words / action |
|---|---|
| Go-ahead, 2026-10-25 chat | "Read the handoff and start ticket 13" |
| 2026-10-26 09:58:29, question tool | "Run to 0.95, then stop" |
| 2026-10-26 13:41:23, chat | "Pause proceedings after S3c if fully verified and completed, there is a necessary restart pending" |
| 2026-10-26 16:38:09, question tool, budget | "In this case let's move over to OpenAi options, change anthropic Sonnet-5-5 roles to GPT-6-Luna and Anthropic Opus-5-5 roles to GPT-6.1-Sol. Utilize the stand-in reviewer as we did last time and have Fable double check the full tickets on Thursday" |
| 2026-10-26 16:38:09, question tool, drill | "Authorized for an OpenAI drill in S4, use the environment variable 'Codex_API'" |
| 2026-10-26 16:43:50, question tool, drill placement | "Ticket 14's drill" |
| 2026-10-26 16:43:50, question tool, PM role | "The PM stays on Opus 5.5, I'll watch the Anthropic usage for your session" |

The verified S3c merge preceded the requested pause. At resumption the Anthropic weekly window had reached 0.95; no new agent was spawned until the owner's continuation answer. Reader moved to GPT-6 Luna xhigh, drafter to GPT-6.1 Sol xhigh and artgen to GPT-6.1 Sol max. The temporary advisor-astra used GPT-6 Astra max; Fable remains the main advisor. Under D160 the ticket closed on stand-in approvals; Fable's whole-ticket audit on 2026-10-30 found nothing blocking. Runner/docwriter roles did not move and were not spawned for that continuation. The PM retained Opus. Sources: notes `:10,146,185,196-204`; `docs/DECISIONS.md:3181-3184`.

D150 modifies the proposed optional Anthropic Haiku drill into an OpenAI drill in ticket 14. **Local TLS/SSE and injected-crash evidence only; no live Anthropic call authorized/run. No live profile was verified.** OG-D52/OG-BREAK/OG-DEP remained untriggered (D149 changed a fixture, not a type or rule); OG-LIVE/OG-MODEL-FACTS/OG-SPEND were not run for ticket 13. There was no synthetic 1 USD proposal silently converted into owner-selected spend. The owner authorized the 2026-10-27 push under the then-current D146 process; D153 later replaced once-per-ticket push approval with protected per-slice CI. Sources: ruling `:31-37`; notes `:201-206,218-238,239-254`; D149 `docs/DECISIONS.md:2991-2999`.

## CI and the close

Public run 2 (40473788920) on d8336c8 passed on Windows, Linux and macOS on 2026-10-27 and covers ticket 13 as well as ticket 12. It preceded D153; the CI cutover's own code run 3 and Markdown run 4 subsequently passed on its branch. C3's status and final three-system exit gate are stated only in the paired roadmap Status line and board. Ticket 13 closed on stand-in approvals under D160, independently of Fable's whole-ticket audit, which followed on 2026-10-30 and found nothing blocking. Sources: notes `:237-238,254`; `docs/DECISIONS.md:3181-3184`; assignment's run-2 PM note.

This close is Markdown-only and split into public/records commits (D145); D128 requires the link/LF document check, not another full code check or freeze ceremony. CONTRACTS.md needs no row change. Ticket 14 is the only issue whose Blocked by line names 13; its comment records that its only blocker is resolved and places the OpenAI drill there without the variable name. Ticket 12 gains the later three-OS CI comment. Ticket 10 remains untouched while the owner's run-1 logs are awaited. Sources: issue 14 `:3,8`; assignment's other-ticket requirements; brief `:483`; D150 `docs/DECISIONS.md:3012`.

## Retained source and raw evidence references

Raw logs stay out of both repositories. The coder root is `C:/Users/darius.jones/worktrees/dwarf-harness/`, with `t13-s1-evidence/` (including `fixup/` and `toolfix/`), `t13-s2-evidence/`, `t13-s2b-evidence/`, `t13-s3a-evidence/`, `t13-s3b-evidence/` (including `fixup/`), `t13-s3c-evidence/` (including `fixup/`) and `t13-s4-evidence/`. They hold commands, V1/race and slowest-test logs, breaks, restoration/final hashes and the throwaway driver/probe source as named by their slice. S2b's probe source/results that were already archived remain in the freeze evidence. Source: notes `:48,66,84,94,107,129,140,150,157,165,179-180,194,197,205`.

The PM session's local files, outside the repository:
- S1: `local://t13-s1-evidence.txt`, `t13-s1-ev/`; toolchain/full-check `t13-s1b-evidence.txt`, `t13-s1b-ev/`; final merge check `t13-s1c-evidence.txt`, `t13-s1c-ev/`.
- S2: `local://t13-s2-evidence.txt`, `t13-s2-ev/`; record check `t13-s2r-ev/v4.txt`; S2b `t13-s2b-ev/` (full detail remains in freeze evidence).
- S3a: `local://t13-s3a-evidence.txt`, `t13-s3a-ev/`.
- S3b: `local://t13-s3b-evidence.txt`, `t13-s3b-ev/`; successor `t13-s3bfx-ev/v4.txt`.
- S3c: `local://t13-s3c-evidence.txt`, `t13-s3c-ev/`; successor `t13-s3cfx-ev/v4.txt`.
- S4/S4b: raw paths, commands, measurement, crash and final check/fuzz observations are indexed with the other retained files below; their results are summarized above.

Sources: notes `:67,84,115,120-129,138,152-155,161-163,170-171,179,183,188,192,194-199,205-206`. The local chronology and verdict files are retained session artifacts, not public authority or a promise that a local:// URI resolves from another session.

### Path and SHA-256 index

Retained roots (outside both repositories): `P = C:/Users/darius.jones/.omp/agent/sessions/-Documents-PROJECTS-dwarf-harness/2026-10-24T15-58-31-752Z_01a16ea2-9748-77b3-ac90-a8beabd7bc22/local`; `W = C:/Users/darius.jones/worktrees/dwarf-harness`. A table path beginning `P/` or `W/` expands that exact root.

The immutable inventory is `P/t13-evidence-inventory.json`, SHA-256 `a1cac29752822e8f0e5d3f31b811efe4226d3c2181a37f3566ed07448165eb33` (107,469 bytes). Its `files` array resolves the local-source references above to absolute paths and byte hashes; its `roots` array covers twelve PM evidence folders and eight coder evidence folders, including S4b, with every raw file's relative path, size and SHA-256. All legacy raw-log, break, restoration, receipt, driver and profile references above resolve through this index; no raw file or inventory is copied into records. The root `manifestSha256` hashes sorted `relative path<TAB>bytes<TAB>sha256<LF>` rows; it is a manifest digest, not a file digest. Sources: inventory `method`, `files`, `roots`, `missing` (empty); PM hash receipt, 2026-10-30.

Direct source and final-slice references:

| Retained path | SHA-256 of file bytes |
|---|---|
| `P/t13-anthropic-facts.md` | `0ac6fe91b882fba48c17c63287afa71387bbee530075ebf228665fcb1d927c28` |
| `P/t13-designer-fetch.md` | `1aff7673065a99e6d81a2fcb23ba2daf5a45bfb6eae7c5ce7b0536d3da6b9255` |
| `P/t13-docs-notes.md` | `07b9d0ea150c0facfc62d3aac7bad0f71c313a8dc1c9cc2d661c6ce1a2913d7b` |
| `P/t13-s4-coder-report.json` | `c494d6251f6a246f024e0dbe998e54230e40efc760ccad79d66bec44251b1110` |
| `P/t13-s4b-coder-report.json` | `f835f8b16f44f57302b69eeec3544fbf8460193c2a83a3b442e51314e78a7b8f` |
| `P/t13-s4-verdict.md` | `ba62443dd245acda30d2f8f9ae1b3fd6a0890e4b1361d5a41a857056259e77e9` |
| `P/t13-s4-confirm-verdict.md` | `b8460f674116b24b9517ae83995d05cba97f7c55febb8ae4f1675b488152b3b9` |
| `P/t13-s4-ev/v4-run1-failed.txt` | `6db61d88e7db38586433d27dde88f3bebed96aad256f467665e60053566aeb86` |
| `P/t13-s4-ev/v4.txt` | `7f930633701f52bc385f8bd4afeb39c0cbb29433068de0726199b49e2686b481` |
| `P/t13-s4-ev/race-v-failed-env.txt` | `81576b27e1f717f916e4cd9390992dfe4fc02884defa4c52dbefa817f3ffad15` |
| `P/t13-s4-ev/race-v.txt` | `4be97cd09a6b76277768528ab16516d6e71399625e48862772a9d93d7ece2391` |
| `W/t13-s4-evidence/measurement-summary.json` | `1553b228b914c8434bb75ef8fae09832ef679b2c3d302f60cb79f04468f7b1b2` |
| `W/t13-s4-evidence/measurement-erratum.md` | `cec4c91eb94ff9ea491c57303ae48dc94afafc50c633c5373b6378984156e579` |
| `W/t13-s4-evidence/measurement-04-driver.go` | `06d375e590d88ba5bc88d14456537f2cee993beadaeace1ab0054697e8cfdcef` |
| `W/t13-s4-evidence/measurement-04-raw.log` | `f6b1fb90dccdcefde18e890db0bbc1e178d06626d3bed9e9434dd62ba1bcae39` |
| `W/t13-s4-evidence/measurement-04-process.json` | `c1878e21008fc4244523ce3f0a875a332b0bb71ae25f782aaff002745c511eed` |
| `W/t13-s4-evidence/superseded-measurement-03.json` | `532923f66c8fcf45ebd859fc060ed35b1188738d48d3d83a3e892f79588e4a1d` |
| `W/t13-s4-evidence/corrected-profile-summary.json` | `8337ff378efcd17b5b7ea2862202caca9d0c84d26f63c1f7f1a5c4af31e9932c` |
| `W/t13-s4-evidence/corrected-baseline-workload.cpu` | `6a2a8fc3293fe29da650eb568754264c90fc04914199b00957cf8b9661009e48` |
| `W/t13-s4-evidence/corrected-baseline-20contexts-open-true.cpu` | `05aaa7d6e2018f12093e9d11422d394494b6acb0e4b4b81eb01ab4da86c563d2` |
| `W/t13-s4-evidence/corrected-baseline-20contexts-open-false.cpu` | `1fa684e1184667df175c5b8031ce4eddda84095e7790d010332ad5cc9822e96b` |
| `W/t13-s4-evidence/corrected-approximately-2x-workload.cpu` | `43a181adff6de26280c82aec481f1bbb54387162cfcf665002ae9291019443fe` |
| `W/t13-s4-evidence/corrected-approximately-2x-20contexts-open-true.cpu` | `ae813fadbb6ad016c4582c8fb7509f18d58340b18c82532076c3e6b47964cae4` |
| `W/t13-s4-evidence/corrected-approximately-2x-20contexts-open-false.cpu` | `f84abc5fc2e3a79816a81e6b2708409a5bc88738cc2955b287214edc998e072c` |
| `W/t13-s4-evidence/corrected-approximately-10x-workload.cpu` | `8021611353ae685d012db6417942898aa42a3ce276a343863d5e4c26fa2193df` |
| `W/t13-s4-evidence/corrected-approximately-10x-20contexts-open-true.cpu` | `792dccdbb9f7ee4f3e24480d19d795b5d5491e1344dcdaf01efb94c8b6ac6eec` |
| `W/t13-s4-evidence/corrected-approximately-10x-20contexts-open-false.cpu` | `8c9c8d19be276f080fa60445f5c11f7475de5ab34c66482fd7b23a60bd348ef8` |

The chronology continues through the close, so its publication digest above supersedes the inventory's earlier snapshot of that one file. The inventory and all other linked evidence remain unchanged; the PM fills the chronology digest immediately before the records commit. Only the brief and ruling are copied byte for byte (E01/E02); the evidence here records summaries, corrections and references, never copies raw logs, receipts or profiles (D160).
