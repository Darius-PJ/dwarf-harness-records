# Ticket 14 evidence

The [initial brief](ticket-14-design-brief.md) and [ruling](ticket-14-design-ruling.md) govern the shared-path OpenAI implementation; the [S4 brief](ticket-14-s4-design-brief.md) and [ruling](ticket-14-s4-design-ruling.md) govern the owner-authorized usage-parser extension. The [facts digest](ticket-14-openai-facts.md) preserves the dated sources and their unverified items, including the then-undocumented TTL usage split. Ticket 14's Answer and the agents/providers/ledger package documentation state what was built. No build-record entry is added: D163 and D164 already record the additive producer choices. Sources: `local://t14-docs-notes.md:3-6,16,20-22`; `local://t14-openai-facts.md:269-281`; D163 and D164 in `docs/DECISIONS.md`; `docs/CURRENT-RULES.md:26-30`.

## Method and provenance

Claim date: 2026-10-30. Close date: 2026-10-30. Chronology is from `local://t14-docs-notes.md:3-23`, the coder reports and fresh reviews below; this record adds no execution claim or per-slice pace analysis (D162). The [inventory](ticket-14-evidence-inventory.json), SHA-256 `aea33372c20c9713fb6392c93f901ae2a3e8690bd15de15f7e462cf09a2a0909`, identifies raw source, report, command, break, fuzz, profile and sanitized-drill artifacts by path and SHA-256. They remain outside both repositories; neither logs, receipts nor profiles are copied into this record (D160).

The PM supplied the original/rebased commit map in direct answer 1 on 2026-10-30. The final exact-SHA check and actual merge are recorded below, not inferred from local passes. The available notes end at the S4 review's text fixes and check 25; final values are filled from their named receipts before publication. Sources: `local://t14-docs-notes.md:7,10,12,14,16-17,22-23`; `local://t14-close-drafter-assignment.md:5,19,24`.

## Order on main and people

DesignT14 (GPT-6.1 Sol) supplied the brief from ReaderT14OpenAI's GPT-6 Luna facts digest. Fresh Fable advisor RuleT14 approved with seven amendments. The owner's response authorized finite drill ceilings, one attempt at the amended full maximum and the kept read-only pre-flight GET. S1–S3 provided the initial local proof; the second live attempt then led to the owner-authorized S4 under a fresh Fable ruling with five amendments. Sources: `local://t14-docs-notes.md:4-6,17-22`.

| Slice | Original / reviewed commits | Commits in the final integration line | Coder / review |
|---|---|---|---|
| S1 — record-free adapter, accounting, isolation and physical-send proofs | 304b6f0 before its first rebase; reviewed as 6e689bb | fda20d6 | CoderT14S1, GPT-6 Astra; ReviewT14S1, fresh Fable: approve with notes |
| S1 follow-up — function routing, nested tool usage and common request limit | e32e638 | 4d70acf | CoderT14S1, revived; approved with S2 by ReviewT14S2 |
| S2 — shared Core integration and chapter-14 golden | b967263 (golden/ledger text), 077ad26 (producer) | c23cfd5 (golden), afcae02 (producer) | CoderT14S2, GPT-6 Astra; ReviewT14S2, fresh Fable: approve with notes |
| S3 — both-adapter crash/recovery, explicit-new-attempt proof, smoke and operating reference | dffa8a5 | 52453e5 | CoderT14S3; ReviewT14S3, fresh Fable: approve slice, driver and profile |
| S4 — usage schema v2 beside unchanged v1 | 1e7d2be | 1e7d2be | CoderT14S4; approved by a fresh Fable advisor; its text corrections are f9fa809 and 5037284, and D164 took its four precision edits |

The PM's additive register sentence is d9f84df; S3 review-limit sentences are 947de7e and d9e50a6; S4's ledger/register sentences are 5e744f6, the combined check-24 tip; the S4 review's text corrections are f9fa809 (agents doc.go) and 5037284 (ledger doc.go), check 25's tip. S2's intermediate rebased producer a953a9a was refused by the outgoing scan and replaced by afcae02 after a synthetic test declaration was renamed; it was not published and no override was used. D163's record is 88dd0b4, with its producer SHA corrected in the next records commit; D164's record is 7694012. Sources: PM direct answer 1 (2026-10-30); `local://t14-docs-notes.md:16-17,22`; D163 and D164 in `docs/DECISIONS.md`.

| Integration evidence | Outcome |
|---|---|
| S1-only check 18, run 41081773914, on 6e689bb | Succeeded, but ticket 89 advanced main first; this was not a merge of the later rebased line |
| Earlier combined check 23 | Cancelled by the S1–S4 push, not treated as the final gate |
| Final combined exact-SHA hosted check — check 25, run 41112339962, on 5037284 | check 25 (run 41112339962) succeeded on 5037284 |
| Combined check 24, run 41110580006, on 5e744f6 | Superseded and cancelled by the push of the two S4-review text corrections (f9fa809, 5037284); not the final gate |
| Actual main integration | `main` ce4a67a..5037284 |
| Final review, including the PM's unreviewed documentation sentences | approved by a fresh Fable advisor after two factual corrections |

Sources: `local://t14-docs-notes.md:12,16-17,22-23`; the final check/merge/review receipts identified in the inventory.

## Runs and consumer proofs

S1 and its follow-up passed focused provider tests, a plain verbose providers run, formatting, host vet and staticcheck; S1 also exercised unchanged paid consumers. S2 passed focused agents/ledger tests, plain verbose runs of both, whole agents race and twentyfold affected-row race. S3 passed focused and plain verbose agents/providers runs plus formatting, host vet and staticcheck; no product shared-state change required a new local race run. S4 passed focused providers/agents/ledger tests, complete plain providers/agents runs, formatting, host vet/staticcheck and golden stability. No new dependency was added. Sources: `local://t14-s1-report.md:32-82,241-242`; `local://t14-s1-followup-report.md:24-70`; `local://t14-s2-report.md:78-94,343`; `local://t14-s3-report.md:27-69,167-181`; `local://t14-s4-report.md:17-30,110,128-133`.

| Proof | Named tests / exercised boundary |
|---|---|
| Bound origin, credential and private outputs | `TestOpenAIPaidBoundResults`, `TestOpenAIPaidRefusalBeforeSend`, `TestOpenAIPaidCredentialPinning`, `TestOpenAIPaidNewCaptureSecretSurfaces`; provider compiler/isolation tests |
| Exact inclusive money and historical tariff | `TestOpenAIBoundAndSettlement` in providers and agents, `TestOpenAIUsageUnknownAndNull`, `TestOpenAIHistoricalBandValidation`, `TestOpenAIPaidHistoricalEvidence` |
| Honest terminal/unknown evidence | `TestOpenAIResponsesEvidence`, `TestOpenAIStreamFramingIdentityAndFinality`, `TestOpenAIStreamTierToolAndContentPolicies`, response classification/protocol tests, `TestOpenAIPaidEvidenceStates` |
| One physical send and recovery | `TestPaidHTTP1OneShot`, `TestTransportUsesOnlySealedHeaderSetAndBody`, `TestTransportALPNHeadersAndStatusesNeverRepeat`, `TestTransportRedirectDestinationReceivesNothing`, `TestPaidIntentBeforeBytes`, `TestPaidInjectedCrashRecovery`, `TestPaidCloseDrainsAndReconcileHolds`, `TestPaidExplicitNewAttemptAfterUnknown` |
| Shared book, scopes and original periods | `TestPaidMixedProviderScopes`, its race runs, `TestPaidGroupRulesAndFrozenReplay`, `TestGoldenOpenAIStatic` |
| Versioned usage interpretation | `TestOpenAIProfileUsageVersions`, `TestOpenAIUsageV2Split`, `TestOpenAIUsageV2UnknownTrees`, `TestOpenAILiveUsageSchema`, `TestOpenAIUsageSplitScalarZeroIntentionalVersionDifference`, `TestOpenAIUsageV2SettlementAndReplay` |

Sources: `local://t14-s1-report.md:84-102`; `local://t14-s2-report.md:95-106`; `local://t14-s3-report.md:70-75`; `local://t14-s4-report.md:31-40`.

S3 ran 35 Anthropic and 33 applicable OpenAI crash windows. Only the two Anthropic dated-no-charge rows are inapplicable to OpenAI, which has no no-charge rule. The common assertions count physical POSTs, refuse recovered send/observation capabilities and preserve holds/late settlement. The OpenAI final-stream publication window covers the post-terminal body-close boundary because neither body close has a separate durable effect. Sources: `local://t14-s3-review.md:7-12`.

S3's throwaway typed-Core smoke exercised both real adapters over verified local TLS/SSE, the documented preparation/admission/dispatch/record/read sequence, digest-checked bound artifacts and plain reopen with equal money/frontier and no extra requests. Local OpenAI settled 10 micros and Anthropic 11; these are controlled fixture outcomes, not live-provider settlements. The driver source was archived externally and removed before final checks. Sources: `local://t14-s3-report.md:109-137,187-190`; `local://t14-s3-review.md:13-14`.

## Rule breaks and fuzz

| Slice | Deliberate break / named red result / restoration |
|---|---|
| S1 D | Omitted long/write maxima, wrong rounding/subtraction and repeated reasoning/cache charges: `TestOpenAIBoundAndSettlement` and `TestOpenAIResponsesEvidence` failed; each restored green |
| S1 F | Null cached/write counters as zero, tier gate removed, or accumulated diagnostic snapshots: usage/evidence/tier tests failed; each restored green |
| S1 G | Rewind/idempotency replay, redirect pairs or HTTP/2: warm-connection one-shot and transport tests failed; each restored green |
| Follow-up | Nonzero nested tool usage accepted: `TestOpenAIStreamTierToolAndContentPolicies/usage_tool_{\"x\":1}` failed; exact restoration passed |
| S2 A/B/C | Wrong selected-context disclosure, mutable credential reread, valid-JSON sealed-body tamper: bound-result, credential-pinning and intent-valid-body tests failed; restored hashes matched final files |
| S2 D/E/F/H | Wrong band, omitted grant ceiling, null live/late counters, or current-period correction: money/mixed-scope/historical-evidence tests failed; exact restoration passed |
| S3 C/G | Removed admission-integrity checks or returned a recovered observation/send capability: eight envelope rows and six crash rows failed respectively; exact restored `paid_dispatch.go` passed |
| S4 (a)–(d) | Accept 12h writes; omit split sum check; apply v2 tolerance under v1; infer aggregate writes: named split/live-schema/v1-pinning rows failed; each hash-identical restoration passed |

Sources: `local://t14-s1-report.md:107-220`; `local://t14-s1-followup-report.md:75-89`; `local://t14-s2-report.md:107-171`; `local://t14-s3-report.md:76-108`; `local://t14-s4-report.md:42-87`.

Evidence qualifications are preserved rather than rewritten as stronger proof. S1's tier/snapshot breaks preceded the final formatting and partial-output/reasoning fix; the review checked the mutated gates remained unchanged, while other break hashes matched final files. S2's first invalid-JSON tamper survived because the independent secret scanner refused first; the corrected valid-JSON tamper failed and restored green. S3's credential mutants still refused under an independent credential-authority barrier; the changed integrity gate is exposed by body/header/model/destination rows, not falsely claimed as the sole credential barrier. Sources: `local://t14-s1-review.md:21`; `local://t14-s2-review.md:15`; `local://t14-s3-review.md:9-10`.

| Campaign | Retained outcome |
|---|---|
| S1, 120 seconds each at parallelism 1 on 6e689bb | `FuzzOpenAIRequest`, `FuzzOpenAIResponsesSSE`, `FuzzProviderProfile`, `FuzzPaidMoney`, `FuzzProviderSSE`: all passed, no new retained corpus |
| Follow-up, 120 seconds each on e32e638 | `FuzzOpenAIResponsesSSE`, `FuzzOpenAIRequest`: both passed, no new retained corpus |
| S2, 120 seconds at parallelism 1 on 077ad26 | `FuzzPaidGroupReplay`: passed, 264,791 executions and four coverage-interesting inputs, no failure or corpus file written |
| S3 | No fuzz implementation changed; seed coverage remained in the focused/plain runs |
| S4, 120 seconds each at parallelism 1 on 5e744f6 | `FuzzOpenAIResponsesSSE` and `FuzzProviderProfile`: both passed, nothing written to the corpus; dual-version SSE and v2-profile seeds also passed in the coder's runs |

S1's profile campaign performed only 1,728 executions in its 120 seconds, a coverage limitation noted by the reviewer, not a failed campaign. No codec changed, so S2 did not require a timed `FuzzDecodeF3_13` campaign. Sources: `local://t14-docs-notes.md:8,11,15,23`; `local://t14-s1-review.md:22`; `local://t14-s2-review.md:16`; `local://t14-s4-report.md:89-102,132`; PM direct answer 1 (coverage-interesting inputs were not retained corpus or failures).

## PM answers and carried review notes

- The PM carried S1's approved signature choices into S2: `Maximum` selects the disjoint class universe without a new public argument, but Core reconstructs quotes from the admission profile; late/replay derivation independently checks served tier. The follow-up removed the redundant OpenAI-only request cap in favor of the shared provider limit, leaving Core's smaller admission cap authoritative. Sources: `local://t14-docs-notes.md:7,9-10`; `local://t14-s1-review.md:8,12,26-28`.
- S2 could transiently mutate the paid-read/budget files for A/E/H breaks only with hash/red/exact-restore/green evidence. After repeated original-period fixture failures the PM required instrumentation of the refusing checks before another fix; it exposed the existing Anthropic zero-block defect, so only that fixture was changed here. The PM also authorized the chapter-14 colony selection in the scoped replay test. Sources: `local://t14-docs-notes.md:11,14,16`; `local://t14-s2-review.md:7,15`.
- S1's nonlocal function mapping, nested zero-tool-usage tolerance and dead check were corrected by the follow-up. The failed-terminal/no-error classification remains `protocol_error`; the invalid-Anthropic-profile sentinel precedence and the multi-cause snapshot test are nonblocking notes, not changed contracts. Sources: `local://t14-docs-notes.md:9-10`; `local://t14-s1-review.md:16-20`.
- S2's conservative late incomplete-reason check and the Anthropic-named underlying OpenAI input type remain nonblocking notes. The optional direct Anthropic observation-byte assertion was not added; omitted optional members, unchanged earlier goldens and actual chapter-13 replay are the retained compatibility evidence. Sources: `local://t14-s2-review.md:11-14`.
- The PM added S3's limit sentences rather than widening implementation: no-release-path holds, their fence consequences and the Anthropic zero-block defect are documented. S3's print-only driver suggestion was optional: existing output omits fence/class/violation fields, so attempt 1/2's classifications and violation reason come from the PM's recorded observation, not an invented printed field. Sources: `local://t14-docs-notes.md:17,19`; `local://t14-s3-review.md:15,20,26,29`.
- S4's monotonic fuzz oracle excludes the deliberate scalar-zero split exception: v1 prices that formerly unknown zero, while v2 treats a known split of scalar shape as a profile violation and holds. A named vector and seed preserve that version difference; this does not migrate v1. Sources: `local://t14-docs-notes.md:22`; `local://t14-s4-report.md:39,111-113`; `local://t14-s4-ruling.md:9,14,19`.
- S4 review and carried notes: approved by a fresh Fable advisor; its text corrections are f9fa809 and 5037284, and D164 took its four precision edits. Final review dispositions, including the PM's sentences: approved by a fresh Fable advisor after two factual corrections.

## Owner answers and three live attempts

D150 placed the OpenAI drill in ticket 14 and kept credential provisioning private. On 2026-10-30 the owner selected four USD 1.00 lifetime ceilings (colony, agent, OpenAI credential scope, root model-call grant), no warning threshold, and one `gpt-6-luna` attempt after S1–S3 local proof, the additive producer record and pre-flight checks. He kept the read-only model GET. The ruled request has 4,096 output tokens; its full rectangle is 922,000 × 1/4 + 4,096 × 3/4 = 233,572 micros. A different maximum would require a fresh go. Sources: D150 in `docs/DECISIONS.md`; `local://t14-docs-notes.md:5-6`; `local://t14-ruling.md:105-106`. No credential locator or value is reproduced here.

The first two sanitized logs report pre-flight HTTP 200 with the pinned model and no shutdown date, the same four ceilings/full quote, one recorded intent at sequence 45 and result at 47, request-ID presence only, and unchanged money/frontier after plain reopen. Their product-file equality assertions covered 848 files. Those observations show a host invocation and its recorded evidence, not an invoice or measured server-side POST count. Each separately authorized attempt used a fresh retained throwaway colony; the colonies and their private observations remain outside the records and are named here only as retained, never by path. Sources: `C:/Users/darius.jones/dwarf-tmp/t14-drill/live-attempt1.log:2-7`; `C:/Users/darius.jones/dwarf-tmp/t14-drill/live-attempt2.log:2-7`; `local://t14-s3-review.md:26`.

| Attempt / token | Sanitized observed outcome | What it proves / subsequent owner choice |
|---|---|---|
| 1, v1 | Pre-flight GET 200; Responses HTTP 200, followed by an in-stream `insufficient_quota` / `credit_balance_exhausted` refusal for lack of API credits. Core class `exhausted`, result `unknown`, full hold 233,572 micros, settled 0; counters absent, two retained artifacts | Live authorization/transport reached the provider and quota refusal stayed held; no live settlement. The owner added API credits and authorized exactly one further attempt, same request/maximum/ceilings, fresh colony |
| 2, v1 | Provider completed: served `gpt-6-luna`, tier `default`, input 9, output 5, cached/write 0, one text block. Core result `unknown`, hold 233,572, settled 0, profile violation, two retained artifacts; class `protocol_error` for the profile-violation hold | The real nested `cache_write_tokens_details` zero split was undocumented in the digest and refused under v1; fail-closed without guessing a price. The owner chose a ruled fourth parser slice, then exactly one more attempt with unchanged request/maximum/ceilings and another fresh colony |
| 3, v2 | with usage schema v2 the same request completed (served `gpt-6-luna`, tier `default`, 9 input and 5 output tokens) and settled at 4 micros, releasing the 233,572-micro hold; a plain reopen left money and the frontier unchanged. This is the first live OpenAI settlement through Core; attempt 2's retained throwaway colony keeps its profile-violation fence until acknowledged | The third sanitized receipt is ``C:\Users\darius.jones\dwarf-tmp\t14-drill\live-attempt3.log``; its complete outcome and any subsequent owner disposition are retained without implying another authorization |

Sources: `local://t14-docs-notes.md:17-22`; `local://t14-s4-ruling.md:99`; `C:/Users/darius.jones/dwarf-tmp/t14-drill/live-attempt1.log:2-7`; `C:/Users/darius.jones/dwarf-tmp/t14-drill/live-attempt2.log:2-7`; third-attempt receipt and chronology listed in the final inventory. No automatic retry occurred; the second and third authorizations were separate owner choices. A passing drill-driver test alone does not mean Core settled: attempts 1 and 2 passed its evidence-preservation checks while retaining their holds.

Attempts 1 and 2 share profile digest `25a2f7699f2717d636604b1b29020dcff48412ac5c565ae91808799bd6bfa21f`, request digest `ff50c3f5d56b243113574cfbfec54bf44b49864f3abfbc1d522c4d575cd666a4` and tariff digest `dfd4466f0eb470071bf5fbba195db8171ff23949a34f1e5f09ae63efeb5fffe3`. S4's v2 profile file SHA-256 is `2dc94f26321cc75b4c958090c50867a6ef3a04cc69b40499b814f063ac8d466b`; its profile digest is `95195c144ecfbe009a7a7fc85b9c7101c0b5ebcd02e1035bb5326df681caa30d`, expiry 2026-11-01T18:43:46.7762489Z and unchanged maximum 233,572 micros. Third-attempt use and result are established only by its receipt, not inferred from this prepared profile. Sources: both first-two logs at line 4; `local://t14-s4-report.md:105-110`.

## Producer compatibility and operating limits

D163 records the OpenAI provider/header/class/tier/schema values and chapter-14 golden; D164 adds v2 without changing earlier schema, codec, closed-set, digest-order or golden bytes. Chapter 14's log SHA-256 is `74d43897fb8d8c7275599270fc874a1ca7f8911ba35ea197b4d8c11b8a7dedaa`; chapter 13 remains `50b41cf739cbef89bec234cf64873e80af85188b256c66d6cb1e86ebea3555ff`. S4's v2 Core fixture settles four micros and reopens unchanged, while v1 keeps its original hold on the live-shaped split. No new golden is needed or added for v2. Sources: D163 and D164 in `docs/DECISIONS.md`; `local://t14-s4-report.md:33-40,131`; `local://t14-s4-ruling.md:14,24,29`.

The operating references are `internal/core/agents/doc.go`, `internal/core/providers/doc.go` and `contract/ledger/doc.go`, not a duplicated build decision. Both schemas retain the 272,001–278,528 inclusive-input unknown interval (`tariff_ambiguous`, full hold, no fence, no release path). Unknown event/item/part types, missing served tier, served-model mismatch and missing/null/inconsistent/overflowing counters can also leave holds without a public late-evidence release path. Profile violations fence intersecting attempt scopes; missing tier, model mismatch, missing, null or overflowing required counters and the ambiguous interval do not fence. A profile-violation hold carries `protocol_error`. The existing billable non-refusal Anthropic zero-output-block `ErrInvalid` defect leaves its full hold; public ticket 141 is the bounded nil-list settlement fix, not a frozen-reader relaxation. The `protocol_error` class on profile-violation holds stays a documented limit, not a ticket: classes are observations only (ruling P6), a reversible PM choice. Sources: `local://t14-ruling.md:107`; `local://t14-s2-review.md:7-10`; `local://t14-s3-review.md:20,29`; `local://t14-s4-ruling.md:99`.

This is the callable static paid baseline, not a running turn/tool loop, R0/R1 integration, provider invoice cap, performance measurement or delivery approval. Hosted three-system results are integration evidence only; C3's own exit and testing-only/C4 restrictions still apply. Step status is only in the paired roadmap Status line/board and contract status only in its register table. Sources: `local://t14-brief.md:6,245`; `local://t14-docs-notes.md:3`; `docs/CURRENT-RULES.md:26-27,56`.

## Raw evidence references

The inventory is the path/SHA-256 authority for every raw artifact cited above; its own digest is recorded under Method and provenance. Resolve relative filenames below under these private roots. Retain the cited files outside both repositories; do not copy command output, receipts, profiles or source bodies into this record. The inventory includes the local briefs/rulings, reports/reviews, chronology and final check/merge receipts as well as the raw runs. Throwaway colony directories, their private observations and private credential-bearing configuration are not inventory payloads.

| Root / retained files | Location or reference |
|---|---|
| S1 — command manifest, focused/plain/static checks, break D/F/G red/green logs and five fuzz logs | `C:/Users/darius.jones/worktrees/dwarf-harness/t14-s1-evidence` |
| S1 follow-up — regression/focused/plain/static checks, nested-tool break pair and two fuzz logs | `C:/Users/darius.jones/worktrees/dwarf-harness/t14-s1-evidence/followup` |
| S2 — report/commands, diagnosis and restore hashes, breaks A–F/H, focused/plain/race/race20, golden stability and replay-fuzz logs | `C:/Users/darius.jones/worktrees/dwarf-harness/t14-s2-evidence` |
| S3 — report/commands, breaks C/G and restoration, final focused/plain checks, archived drill source, local smoke output and initial profile/proof | `C:/Users/darius.jones/worktrees/dwarf-harness/t14-s3-evidence` |
| S4 — report/commands, breaks (a)–(d), final focused/plain/static/golden checks, profile proof, v2 profile and timed-fuzz receipts | `C:/Users/darius.jones/worktrees/dwarf-harness/t14-s4-evidence` |
| Live attempt 1 sanitized output | `C:/Users/darius.jones/dwarf-tmp/t14-drill/live-attempt1.log` |
| Live attempt 2 sanitized output | `C:/Users/darius.jones/dwarf-tmp/t14-drill/live-attempt2.log` |
| Live attempt 3 sanitized output | ``C:\Users\darius.jones\dwarf-tmp\t14-drill\live-attempt3.log`` |

The first-five source roots and artifact kinds come from `local://t14-s1-report.md:2-3`, `local://t14-s1-followup-report.md:24-70`, `local://t14-s2-report.md:2-3`, `local://t14-s3-report.md:2-3,109-112` and `local://t14-s4-report.md:2-3,103-109`; live paths from `local://t14-close-drafter-assignment.md:19`. The inventory also includes the S4 campaign logs from `local://t14-docs-notes.md:23` and final check/merge/review references with their observed results. Organization and request-ID values, credential locators/values and the throwaway colonies are excluded from published records (initial ruling amendment 7).
