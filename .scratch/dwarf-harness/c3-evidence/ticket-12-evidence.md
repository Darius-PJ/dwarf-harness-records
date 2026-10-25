# Ticket 12 evidence

Each slice's evidence as reviewed, in the order the slices reached `main`, beside the [design brief](ticket-12-design-brief.md), the build advisor's [ruling](ticket-12-design-ruling.md), which wins where they differ, and the [F3-12 freeze evidence](f3-12-freeze-evidence.md), which holds S2's package evidence and is not repeated here. [B33](../../../docs/DECISIONS.md#b33-c3-exact-subject-review-and-failure-results-ticket-12) records the build. Paths that begin `local://` name the build session's own files, which stay outside the repository. Log names refer to the coders' evidence folders `t12-s1-evidence`, `t12-s2-evidence`, `t12-s3a-evidence`, `t12-s3b-evidence`, `t12-s4-evidence` and `t12-s5-evidence`, beside the worktrees, which also stay outside it; [Where the logs are](#where-the-logs-are) names each kind.

## Machine and method

Every local run was on the project's Windows machine, with go1.27.2 windows/amd64 and Git 2.55.0.windows.3, and Defender real-time protection was on (V10) in every evidence run of the project manager. Each slice had a fresh coder ([The coders](#the-coders)), whose final runs are on the committed tree, verified by SHA-256 (D121). The project manager's evidence, fuzzing and checks ran on the exact commits. The five static targets are windows/amd64, linux/amd64, linux/arm64, darwin/amd64 and darwin/arm64 (D28, D137).

"The check" is `go run ./tools/check`. It ran without its race step (`-race=false`, D129) on S1, S2, S2's record commit, S3a and S3b, each with 0 cached packages. It ran in full, uncached and with its race step, on S4 as an evidence check and on S5, the last code slice. On S1, S3a, S3b and S5, V6 named the same non-standard production imports of `internal/core/agents`, the ruling's dependency set: `contract/ledger`, `contract/ledger/appender`, `internal/core/durable` and `internal/core/ledgerstore`.

S4's coder runs were under outside load. The owner then gave the project manager a quiet machine: "Quiet now", at 20:29:28, and "The device is yours until the timing runs are complete", at 21:08:31.

## Order on `main`

| Slice | Commits on `main` | Reached `main` | Review |
|---|---|---|---|
| S1, the record-free rules | 69a26c2 | 2026-10-24 14:08 | approve, one minor and one nit |
| S2, the F3-12 contract | 6a34116; D143's e045717; the freeze record e126a7e (D144) | 2026-10-24 15:16 | approve with the record and D143, S2's D41 sign-off; one minor and two nits |
| S3a, the reducer, request slots, direct guard and passive views | 7a91eaf | 2026-10-24 16:10 | approve, one minor and three nits |
| S3b, the producers | 20d076e | 2026-10-24 17:53 | approve, one minor and two nits |
| S4, the crash rows, the measurement and the final documentation | ee450cf | 2026-10-24 20:30 | approve; one ticket-level major finding, routed to S5, and three nits |
| S5, the artifact-read check order | e2008b6 | 2026-10-24 23:16 | approve: one nit, no change required; reviewed with the close |

The slicing is the ruling's S1 to S4, with S5, which the S4 review added by its ruling on S4's measured regression, an assistant decision under D117 and D116 ([B33](../../../docs/DECISIONS.md#b33-c3-exact-subject-review-and-failure-results-ticket-12), item 4). S1 to S5 each reached `main` by fast-forward after its gate's check passed (D116 item 5). S2, D143's e045717 and the record commit df72ff6 reached `main` together from 69a26c2; df72ff6 was amended Markdown-only as e126a7e to fill in its check result (D128). Under D141 nothing after d12f605, ticket 11's close, was pushed before this close.

## The coders

At 14:12 the owner asked for a fresh coder for every slice, and for Codex coders to run until Codex reached 98 % of its window and then pause. At 17:03, after that pause, he asked for a fresh Claude coder, and at 17:18 for the next stand-in Claude coder at effort xhigh. Ticket 12's comments quote his words.

| Slice | Coder | Model | Started | Ran |
|---|---|---|---|---|
| S1 | CoderT12S1 | Codex (gpt-6-astra), effort xhigh, with the LSP | 13:32 | 14m28s, 68 turns |
| S2 | CoderT12S1, revived, then stopped under the fresh-coder rule | the same | 14:09 | stopped at 14:13 |
| S2 | CoderT12S2, fresh, from CoderT12S1's partial start | Codex (gpt-6-astra), effort xhigh, with the LSP | 14:15 | 18m12s |
| S3a | CoderT12S3a | Codex (gpt-6-astra) | 15:17 | 32m41s |
| S3b | CoderT12S3b, paused when Codex reached 98 % at 16:28:45 | Codex (gpt-6-astra) | 16:11 | 19m15s |
| S3b | CoderT12S3bOpus, which finished it | Claude Opus 5.5, effort high, without the LSP: the default task agent, told to follow the coder role | 17:03 | 34m26s |
| S4 | CoderT12S4 | role `coder-claude`: Claude Opus 5.5 at effort xhigh, with the LSP | 17:53 | 1h43m |
| S5 | CoderT12S5 | role `coder-claude`: Claude Opus 5.5 at effort xhigh, with the LSP | 20:31 | 2h6m |

## S1, the record-free rules (2026-10-24)

The request slot's state machine, the binding comparison, the guard on direct complete and fail, the reviewed-failure fact in the task kernel, the clock's sample, floor and deadline rule and the request-ID watermark, all on unexported values with pure tests: 8 files in `internal/core/agents` (6 new, with `tasks.go` and `tasks_test.go`), +640/−1, committed as 69a26c2 on ce07208, all 8 hashes matching. Its only exports are the three ruled sentinels, `ErrReviewRequired`, `ErrReviewClock` and `ErrReviewExpired`. Its one edit to existing production code, in `tasks.go`, is neutral for every existing caller, because no existing path sets the reviewed-failure fact.

| Step | Result |
|---|---|
| V1 `go test -count=1 -v ./internal/core/agents` (coder) | pass, 19.0 s |
| Race (coder) | pass, 140.2 s; no test over 60 s |
| `go vet` and staticcheck for all five targets (coder) | clean; imports unchanged |
| V6, V7, V10, gofmt, staticcheck, line endings (project manager, 69a26c2) | the four imports; clean |
| Fuzzing (project manager, 69a26c2) | `FuzzScopedGroupReplay` ran 120 s: 25,063 executions, 56 new interesting inputs, no failure. It was fuzzed because S1 edits `transitionTask`, which the target reaches, although the edit is neutral for replayed input |
| V4 check without its race step (project manager, 69a26c2) | `check PASSED: 8 of 9 steps passed, race skipped (D129) in 465.9s` (tests 398.9 s; `internal/core/agents` 186.0 s) |

Rule breaks, each failing its named tests once and restored byte for byte:

| Break | Failing test | The mutation |
|---|---|---|
| A | `TestReviewGuardBindsOwnerAndAgentButAllowsEscapes/agent/rejected/complete` | a rejected request no longer guards |
| B | `TestReviewGuardBindsOwnerAndAgentButAllowsEscapes/agent/superseded/complete` and `…/agent/stale/complete` | every nonempty slot guards, superseded and stale ones included |
| C | `TestReviewGuardBindsOwnerAndAgentButAllowsEscapes`'s owner and agent `pending/cancel` and `pending/reassign` rows | the complete-or-fail filter removed, guarding cancel and reassign |
| D | `TestScopedTaskReviewedFailureRequiresAuthority/direct_non_assignee_still_refused` | every non-assignee fail allowed without the reviewed-failure fact |
| E | `TestReviewBindingRejectsSingleMemberSubstitution/evidence_order` | evidence compared by digest only, ignoring the order of equal-hash occurrences |
| F | `TestReviewClockSeparatesDeadlineAndRegression/request_at_deadline_refuses` and `…/result_at_deadline_is_timely` | the request's and the result's equality at the deadline reversed |
| G | `TestReviewClockSeparatesDeadlineAndRegression/regression_precedes_expiry`, `…/request_below_floor` and `…/result_below_floor` | the floor check removed, accepting a rollback |
| H | `TestReviewRequestWatermarkDoesNotTreatEqualityAsNew/equal_requires_history` | a request ID equal to the watermark treated as new |

The project manager's reading during S1, confirmed by the review: note 1's "no exported API" means no exported entrance or type, so the three ruled sentinels, which the tests compare with `errors.Is`, may be exported (P9, P10).

Review: AdvisorT12S1 approved S1 at 69a26c2: "S1's record-free rules implement notes 2–7 exactly with real breaks and no exported surface beyond the three ruled sentinels; approve the fast-forward, carrying reviewUnixNano's deletion to S3b."
- Its minor: `reviewUnixNano`, a second clock rule with no ruled caller, goes with its test and the `math` import, because P10's plain `UnixNano` default with `reviewObservation` is the whole rule. S3b deleted them.
- Its nit: `guardReviewTask`'s terminal-state clause never decides, so it and its three rows go. S3a dropped them.

The verdict is `local://t12-s1-verdict.md`.

## S2, the F3-12 contract, D143 and the freeze (2026-10-24)

S2 is 20 files in `contract/ledger`, +1,901/−16: 13 code and test files and 7 new fixtures under `testdata/f3/12/`. It was committed as 6a34116 on 69a26c2, with all 20 hashes and all 24 golden hashes matching. It holds:
- three version-1 codecs, `runtime.review_requested`, `runtime.review_result` and `runtime.review_receipt`, with the catalogue at forty-one types;
- schema 3's canonical submission;
- `PrivateRevisionRef` and the `private_revision` kind;
- the `SubjectRef.MarshalJSON` correction;
- the F3-12 section of the package documentation, with the F3-11-only reading;
- a golden of 25 commits and 90 records;
- `FuzzDecodeF3_12`.

The [freeze evidence](f3-12-freeze-evidence.md) gives the coder's runs, V3, V6–V9, the record-commit check and rule breaks A–J, and D144 records the freeze. Beyond it:

- CoderT12S1, revived for S2 at 14:09, was stopped at 14:13 under the owner's fresh-coder rule. Its four partial files, `scoped_values.go`, `review_values.go`, `review_compatibility_test.go` and a `review_test.go` sketch that did not compile, were copied with their logs to `t12-s2-evidence/partial-CoderT12S1/` and given to CoderT12S2 as its draft.
- At the coder's request a reader, ReaderT12Golden, mapped the golden's prerequisites. The coder finished without the map, and the project manager cancelled the reader.

| Step | Result |
|---|---|
| V4 check without its race step (project manager, 6a34116) | `check PASSED: 8 of 9 steps passed, race skipped (D129) in 510.7s` (tests 395.3 s; `contract/ledger` 70.6 s, `internal/core/agents` 162.6 s, `internal/core/ledgerstore` 276.4 s) |

The project manager's answers during S2, all three confirmed by the review:

1. The binding's member is `required_evidence`: non-empty and strictly ascending by each `SubjectRef`'s compact encoding, refused when unsorted or duplicated, and never sorted or deduplicated by the codec. The S1 review's "order is semantic" reads as "comparison is ordered". `MaxReviewEvidence` is the service's producer guard (P14), and the decoder has no count ceiling.
2. Failure wire names: the request and its arguments keep `failure_cause` and `failing_evidence`, and the result and `failure.resolve`'s arguments use `cause` and `failing_evidence` (finding 3).
3. The failure cause is an open token the requester supplies, so `semantic_failure`, the golden's value, is not frozen as a writer value; the record names it only in parentheses. This answered the record drafter's question.

D143: at the owner's word at 14:37, e045717 removed the workflow's `push` trigger. It was placed on 6a34116, so the record commit's check covered it, and S2's review approved it with S2 and the record.

Review, as D144 records it: "On 2026-10-24 the build advisor (Fable) approved ticket 12's S2 at 6a34116 together with this record, its evidence and the D143 commit e045717, with no blocker or major finding; its minor (the package documentation's Catalogue section, stale since D140, now naming F3-11 and F3-12 and forty-one types) and nit (the Date line's F3-11 clause qualified by the two `SubjectRef` additions) were applied to the record commit before the freeze." Its second nit, that every golden binding has a one-element `required_evidence`, asked for no change, since the tests show the ascending rule. The verdict is `local://t12-s2-verdict.md`.

The freeze: the record commit df72ff6, `docs(ledger): record the F3-12 freeze (D144)`, on e045717, passed the check without its race step in 657.6 s (tests 580.3 s). A Markdown-only amendment filled in that result as e126a7e (D128). The project manager froze F3-12 under D125 as D144, and `main` moved from 69a26c2 to e126a7e at 15:16.

## S3a, the reducer, request slots, direct guard and passive views (2026-10-24)

S3a is 28 files in `internal/core/agents`, +2,026/−169, committed as 7a91eaf on e126a7e, with all 28 hashes matching. It exports no mutation, and its production and test imports equal `main`'s. It holds:
- the reducer for all three F3-12 types through Open and the golden;
- the request slots and their lifecycle;
- the `maxRequest` watermark and the cold lookups at or below it;
- book usage, the task loaders and history, and consumption versions;
- `ReviewStatus` and `ReviewCommandStatus` on `Service` and `Agent`, with a fourth sentinel, `ErrReviewStale`;
- the guard on direct complete and fail, live and at replay (finding 5).

S1's binding tests moved onto the ledger types, and the guard's terminal-state rows went with the S1 nit.

At the coder's request a reader, ReaderT12S3a, mapped the agents test helpers and the F3-12 golden member by member, with the expected task states, request statuses and usage per scope (`local://t12-reader-s3a.md`). The S3a assignment had said that hand-made groups are encoded with `ledger.EncodeCommit`; the reader's correction of that became answer 4.

| Step | Result |
|---|---|
| V1 (coder) | pass, 50.5 s |
| Race (coder) | pass, 293.2 s; no test over 60 s |
| New tests (coder) | `TestReviewFrozenGoldenReplay` (3 rows), `TestReviewGroupRules` (64), `TestReviewDirectGuard` (12), `TestReviewLedgerRecovery` (4), `TestReviewStatusViews` (4) and `FuzzReviewGroupReplay` (7 seeds) |
| `contract/ledger` as a consumer (coder) | pass |
| V6, V7, V10, gofmt, staticcheck, line endings (project manager, 7a91eaf) | the four imports; clean |
| Fuzzing (project manager, 7a91eaf) | 120 s each, no failure, `testdata` clean: `FuzzReviewGroupReplay` 1,366 executions, 27 new interesting inputs; `FuzzScopedGroupReplay` 19,558, 43 new; `FuzzPrivateGroupReplay` 622,455, 1 new |
| V4 check without its race step (project manager, 7a91eaf) | `check PASSED: 8 of 9 steps passed, race skipped (D129) in 508.3s` (tests 446.2 s; `internal/core/agents` 213.1 s) |

`FuzzReviewGroupReplay` ran about 11 executions a second. The review found that it follows the brief's §6.2: about 28 % of its inputs were valid, and each valid input pays a real-store copy and two Opens. S3b narrowed the valid branches.

Rule breaks, each red, restored by hash and green, with their hashes and logs in `breaks.json`:

| Break | Failing test | The mutation |
|---|---|---|
| D | `TestReviewDirectGuard` | the guard returns nil |
| E | `TestReviewLedgerRecovery/rejected` | a reject installs an approve |
| J | `TestReviewGroupRules/wrong-task-unpin` | the unpin's identity check disabled |
| K | `TestReviewGroupRules/newer-request-type-1` | the type removed from the consumption map and the envelope's version check bypassed |
| A′ | `TestReviewGroupRules/different-(subject-source\|private-revision)-same-hash`, both rows | the subject compared by hash |
| G′ | `TestReviewGroupRules/historical-id-reused-(below\|at)-watermark`, both rows | the watermark's history scan skipped |
| H′ | `TestReviewGroupRules/result-current-chains/pending-replaced` | a historical request adopted as pending |

The project manager's answers during S3a, all four confirmed by the review:

1. The split of the brief's §6 between S3a and S3b, from the ruling's Slicing. S3a takes `TestReviewFrozenGoldenReplay`, `TestReviewGroupRules`, `TestReviewDirectGuard`, the replay half of `TestReviewLedgerRecovery`, `TestReviewStatusViews` and `FuzzReviewGroupReplay`, with breaks D, E, J and K and the replay forms A′, G′ and H′. S3b keeps the producer tests and breaks A, B, C, F, G, H and I.
2. **Changed a reviewed rule.** A group whose receipt outcome is unknown is refused at preflight and at Open as inconsistent. The reasons:
   - the frozen record rule says the outcome agrees with the effect;
   - F3-11's replay refuses a mismatched outcome;
   - every F3-12 group shape carries an effect;
   - "never implies applied state" binds readers of receipts.

   The S2 review's note 16 had asked that such groups replay as unapplied. Its author, AdvisorT12S2, was revived, confirmed this answer and withdrew the note (`local://t12-s2-note16-answer.md`).
3. **Changed the ruling's text.** The ruling's literal witness cursor, `After: source_sequence-1, Through: source_sequence`, fails on the frozen reader, which refuses a cursor inside a commit, and no exported API maps a sequence to its commit. The cursor is segment-aligned instead:
   - the log's segment names are parsed with `ledger.ParseSegmentName`;
   - `After` is the first sequence of the segment holding the smallest witness, minus 1, a commit boundary because a segment never ends inside a commit;
   - `Through` is the prefix;
   - the scan stops at the largest witness.

   It keeps P13's seek and finding 2's O(N·segment). The coder moved `sourceRecord` to the same cursor, which finding 2 allows, so S4 reports both figures. The review checked the cursor's correctness, error handling and cost, and asked that S4 label its measurement with the witness span.
4. Hand-made groups in tests are drafts written through the store's `Append` or `Submit`, or copies of golden bytes, with observations and deadlines taken from envelope times read back from the log, never from wall time.

Review: "S3a 7a91eaf approved: the F3-12 reducer, request slots, maxRequest watermark, segment-aligned witnesses, the direct guard live and at replay, and the passive views are implemented and proved through all three goldens, 64 group-rule rows and seven real breaks, with one minor (loadTask's cold scan now decodes whole families) and three test nits carried to S3b."
- Its minor: `loadTask`'s cold scan ran `decodeFamily` on every commit, a cost and not a correctness defect. S3b restored the per-record scan before S4 measured.
- Its three test nits, closed in S3b:
  - assert the refusal class on the direct private-failure row, which S3b's answer 1 settled as `ErrDenied`;
  - assert agent-scope usage in the golden test;
  - name the guard subtests `pending/` and `rejected/`.

The verdict is `local://t12-s3a-verdict.md`.

## S3b, the producers (2026-10-24)

S3b is 22 files in `internal/core/agents`, +1,899/−117, committed as 20d076e on 7a91eaf, with all 22 hashes matching. It holds:
- the four producers, `RequestReview`, `RequestFailure`, `ResolveReview` and `ResolveFailure`, on `Service` for the owner and on `Agent`;
- the clock seam `serviceDeps.reviewClock`, defaulting to `time.Now().UTC().UnixNano()`;
- unlocked witness preparation;
- the request-ID check against `maxRequest`;
- one `Submit`.

It also deleted `reviewUnixNano` (S1's minor) and closed the S3a review's minor and nits. Production imports gain the standard library's `time`, for the default clock (P10); test imports are unchanged.

CoderT12S3b built the entrances. When Codex reached 98 % at 16:28:45, it was told to finish its current edit, run no more tests and report. It paused at 16:30 (`local://t12-s3b-pause-report.md`) with:
- the four owner and four agent entrances working through the real store;
- all eight named acceptance tests passing together (`producer-matrix.log`);
- breaks A, B, C, F, G and H each red, restored by hash and green.

The guard order, the placement of the recovery rows, break I and the final runs were left. Its 22 partial files were copied with their manifest to `t12-s3b-evidence/partial-CoderT12S3b/`, all 22 hashes equal to the report's. CoderT12S3bOpus finished the slice:

- **The guard order,** in two passes. Pass 1, under the lock: the caller's chain, the lookup, then the reducer's head, then time, the bounds and the reservation. Pass 2: witnesses read unlocked, then the guards again with the second clock sample, then the whole reducer and one `Submit`. Seven `TestReviewDeadlineAndClock/precedence/*` rows pin the order, and five of them fail on the paused coder's order (`precedence-old.log`).
- **Recovery:** a new row, `TestReviewLedgerRecovery/historical-requests-after-reopen`. After a real reopen the named reviewer gets `ErrReviewStale`, and a decision holder who is not the named reviewer gets the same `ErrDenied` for replaced, terminal and unused request IDs. A disclosure break of the row was red, then restored.

| Step | Result |
|---|---|
| V1 (coder) | pass, 51.4 s, 114 top-level tests |
| Race (coder) | pass, 317.6 s |
| V5 `-race -count=20` on `TestReviewResultRaces` and `TestReviewDuplicateAndReplacement` (coder) | pass, 223.9 s |
| `contract/ledger` as a consumer (coder) | pass, 9.2 s |
| `go vet` and staticcheck for all five targets; `go mod tidy -diff` (coder) | clean |
| V6, V7, V10, gofmt, staticcheck, line endings (project manager, 20d076e) | the four imports; clean |
| Fuzzing (project manager, 20d076e) | 120 s each, no failure, `testdata` clean: `FuzzReviewGroupReplay`, with its valid branches narrowed, 15,566 executions, 67 new interesting inputs; `FuzzScopedGroupReplay`, which reaches `loadTask`, 20,125, 14 new. `FuzzPrivateGroupReplay` was not rerun: S3b touches neither `planGroup` nor the private revisions |
| V4 check without its race step (project manager, 20d076e) | `check PASSED: 8 of 9 steps passed, race skipped (D129) in 520.5s` (tests 455.5 s; `internal/core/agents` 232.9 s) |

Rule breaks. The paused coder broke A, B, C, F, G and H. CoderT12S3bOpus broke B, C, F, G and H again in the moved code and added I, each red, restored by hash and green:

| Break | Failing test | The mutation |
|---|---|---|
| A | `TestReviewExactBindingAndTransitions/exact-binding` | not broken again: `matchReviewBinding` is unchanged and still called from the head, so the paused coder's red and restore stand |
| B | `TestReviewAuthorityAndDisclosure/exact-reviewer-origin-and-principal` | the caller's refresh and the guards compared only the reviewer's agent ID |
| C | `TestReviewAuthorityAndDisclosure/requester-ancestor` | the head ignored the requester's chain error on the result path |
| F | `TestReviewDeadlineAndClock` | pass 2 reused pass 1's sample: every final-guard expiry, rollback, error and zero row failed |
| G | `TestReviewDuplicateAndReplacement/replacement-fences-history-and-id-reuse` | a historical request ID at or below `maxRequest` treated as new |
| H | `TestReviewResultRaces/callback-versus-replacement` | a replaced request reloaded as a pending slot |
| I | `TestReviewProseCannotDecideTask` | `loadTask` trusted the assignee context's `core/state.json` when it named the task completed; Open refused the log as inconsistent at sequence 58 |

The reruns overwrote the paused coder's `break-` and `restored-` logs for B, C, F, G and H. Its runs survive as rows in `commands.jsonl`, and its `restored-*.json` hashes are untouched.

The project manager's answers during S3b, all three confirmed by the review, each changing reviewed text:

1. **Changed the S3a review's nit.** A direct F3-11 fail carrying `private_revision` evidence is refused by ticket 11's subject rule, which denies every non-artifact task subject before the kernel, for the owner and the agent alike. The row therefore asserts `ErrDenied` and not `ErrReviewRequired`, instead of the `ErrInvalid` the nit asked for: changing the class would change what a ticket 11 caller observes.
2. **Corrected finding 7's premise.** The service ignores a stray `core/state.json` (B31), so that file alone produces no mismatch. The row forges `core/state.json` and `Memory.md` together. It asserts `ErrIntegrity` for that context, with the foreign Markdown reported, the task, request and dependent readiness unchanged, and the typed approve from the reviewer's unaffected context.
3. **Changed the brief's order within step 4.** The project manager accepted the coder's two-pass design without a reply. A subject reached through a task description needs its source witness, which is read after the reservation, so both participants' subject and evidence rights are checked in pass 2, before the second clock judgment.
   - A caller without subject rights who is also late gets `ErrReviewExpired`, not `ErrDenied`. That discloses nothing, since the deadline is in its own binding.
   - A retry checks the caller's read rights before returning its receipt, with per-reference source reads under the lock, as ticket 11's `artifact.read` check does.
   - The review stated the precedence exactly: caller chain → match → head → time → bounds and reservation → witnesses → read rights and sources → time → kernel → one `Submit`. `planReview` follows the same order, so replay and live agree.

Review: "S3b 20d076e approved: the four review and failure producers, the two-pass guard order with its pinned precedence, the clock seam with both samples and the incarnation floor, unlocked witnesses, the request-ID CAS and one Submit are built on S3a's single reducer and proved by eight live tests, six re-broken rules and break I, with one minor (ReviewReceipt.ThroughSequence means two things) and two nits carried to S4."
- Its minor: `ReviewReceipt.ThroughSequence` meant the receipt's own sequence on the producer and retry paths, but the prefix in `ReviewCommandStatus`, and the review recommended deleting it.
- Its two nits:
  - `assertInert` should also check the direct guard and the unchanged book;
  - either every successfully read clock sample is recorded, or `doc.go` states the rule as built.

All three went to S4, which deleted the field, made every successfully read sample raise the floor and extended `assertInert`. The verdict is `local://t12-s3b-verdict.md`.

## S4, the crash rows, the measurement and the final documentation (2026-10-24)

S4 is 6 files in `internal/core/agents`, +560/−10, committed as ee450cf on 20d076e, with all 6 hashes matching: `doc.go`, `review_execute.go`, `review_query.go`, the new `review_crash_test.go`, `review_live_clock_test.go` and `review_prose_test.go`. Its production changes are the carried items:
- **`ReviewReceipt.ThroughSequence` is deleted.** It was an exported field with no caller before ticket 15, and `Sequence` and `EffectSequence` locate the receipt. The producer, a retry and the passive query now return the same value. `ReviewView.ThroughSequence` keeps the package-wide meaning, the read prefix.
- **Every successfully read clock sample raises this incarnation's floor** before the head runs, so a call that a later guard refuses still raises it. The new row `TestReviewDeadlineAndClock/refused-call-sample-raises-incarnation-floor` is red without it (`break-floor.log`).
- **`TestReviewProseCannotDecideTask`'s `assertInert`** also asserts that a direct complete refuses `ErrReviewRequired` with the frontier unchanged, and that the colony book is unchanged.

`doc.go` gains a section, "Review and failure decisions". It states:
- the request slot and the guard, with the owner's escapes;
- both participants' authority;
- the two-pass precedence, the uniform denial, the clock rule and the retry rule;
- commit and recovery;
- the shared task reading;
- the ruling's five limits;
- the cost as built and measured.

S5 rewrote its cost paragraph.

CoderT12S4, a fresh coder on the `coder-claude` role, started at 17:53 on 20d076e and ran for 1h43m. Its transcript shows `anthropic/claude-opus-5-5` at effort xhigh, as the owner asked at 17:18.

`TestReviewInjectedCrashRecovery` (`review_crash_test.go`) runs four parallel rows over `os.CopyFS` copies of one closed real store. Each is a child of the test binary, run with `-test.run=^TestReviewCrashChild$` and positively waited through `CombinedOutput`. Each reopens a real store with a review clock that fails the test if it is read, and asserts:
- the frontier against the durable log, the consumed ID and the unpins read through `ledger.OpenReader`;
- the receipt's presence or absence;
- the task, the request and the colony book, with nothing held;
- an empty report;
- a segment byte-identical after Open.

The test labels the rows injected faults, not power-loss or isolation proof.

| Row | Where the child stops | What it proves |
|---|---|---|
| `before_submit` | pass 2's lookup, after pass 1's reservation, before `Submit` | no consumed command ID and no held reservation; the pending guard kept; a different valid intent under the same ID then becomes exactly one decision |
| `torn_result` | after the approve's commit, with the commit's final record cut in half in the segment | the store and the service apply no part of the torn group, and the ID stays unconsumed; a different valid intent under it becomes exactly one decision |
| `approval_before_projection` | after `Submit`, before the projection and the acknowledgement | one transition, one unpin and one charge; the retry, reading no clock, equals the committed receipt and applies nothing again |
| `rejection_lost_ack` | after the commit, with the receipt formed but not acknowledged | the reject's guard kept; the passive query and the retry equal the original receipt, with no second charge, transition or unpin |

| Step | Result |
|---|---|
| gofmt; `go vet` and staticcheck for all five targets; `go mod tidy -diff`; imports (coder) | clean; the test imports add no package |
| V1 (coder, under load) | pass, 119.1 s, 116 top-level tests |
| Race (coder, under load) | pass, 604.4 s, no data race. `TestScopedTaskTransitionsAndProjection`, a ticket 11 test with no subtests that S4 did not touch, took 75.1 s, against 58.89 s at ticket 11's S4. `TestReviewProseCannotDecideTask` took 46.7 s, against 23 s at S3b, with five more owner transitions and book reads in `assertInert` |
| V5 `-race -count=20` on `TestReviewResultRaces` and `TestReviewDuplicateAndReplacement` (coder, under load) | pass, 428.4 s |
| Fuzzing | none: S4 changes no fuzzed code, and `FuzzReviewGroupReplay` calls no producer and no `ReviewCommandStatus`. The seed corpora passed in V1 and race |
| V4 full check, uncached, with its race step (project manager, ee450cf; an evidence check, D129) | `check PASSED: all 9 steps passed in 1397.5s` (tests 440.1 s, race 889.6 s; 0 cached packages; `internal/core/agents` 230.4 s and 775.0 s), within D127's 25-minute line |

The coder's runs were loaded:
- SlayTheSpire2 ran at about 0.67 of a core, and V1, race and V5 each took about twice as long as at S3b.
- The review judged the load, not S4, the cause, since the times doubled across tests S4 never touched.

The project manager's gate:
- It followed a quiet sample at 19:38, whose busiest process used 0.08 of a core.
- The check ran from 19:38:51 to 20:02:12, before the owner's quiet window began at 20:29:28, so the load during it is not known beyond that sample.
- The check runs without `-v` and records no per-test race times; S5's race run gives them.

Rule breaks, each red, restored by hash and green:

| Break | Failing test | The mutation |
|---|---|---|
| A | `TestReviewInjectedCrashRecovery/torn_result` | a transient edit outside the owned paths, as ticket 11's S4 break A was, because `agents.Open` replays only through the store's durable frontier: the store's Open counted the torn record as durable ("partial or duplicated recovered group: 67 want 66"); `internal/core/ledgerstore/store.go` restored by hash |
| B | all four rows | a historical command ID treated as new without a history scan: the lost-acknowledgement retries read the clock and were refused `ErrReviewStale` instead of returning the original receipt; the reducer still blocked a second effect, which the rows also assert |
| C | all four rows, and `TestReviewLedgerRecovery/pending` | Open deleted pending requests after replay |
| D | all four rows | Open read the review clock |
| E | `TestReviewInjectedCrashRecovery/before_submit`, the other rows also red | pass 1 committed the group before pass 2, so the command was consumed before the injected crash ("70 want 66") |

The project manager's answer during S4, which the review confirmed (its answer 5): the driver's trial had found a material regression, and he answered that S4 fixes nothing. The driver instead:
- measures a baseline of about 1,050 records, grown to about twice that, labelled as not reaching 10×;
- records H, N and G at each length, with the grants on terminal tasks;
- records the profile shares of the cold path for Open and for one decision, the exponent, and the projection, labelled;
- stays under about 45 minutes;
- leaves `doc.go` stating the cost as built.

The review added two precisions. The 2× length is a deviation from the brief's plan of about 10×, to be recorded here, not a change of plan. And S5, the separate decision, supersedes `doc.go`'s "no fix is implied here".

Review: AdvisorT12S4 approved S4 at ee450cf: "S4 ee450cf approved: ThroughSequence deleted, every read clock sample raises the incarnation floor, assertInert covers the guard and the book, four positively waited child-process crash rows over private real stores with breaks A–E red then restored, and a labelled 2× measurement that found Open O(N·G·H) through ticket 11's artifactAuthority (119.8 s → 800.5 s for 2.07× history, 65–77 % of CPU), which this review routes to a ticket-12 fix slice S5 — a check-order correction, no index — before the close."
- **Its major finding is about the ticket, not S4's code.** `artifactAuthority` iterated every grant the participant held and, for each task resource, authorized `task.inspect` and loaded the task before it could know which task the artifact belonged to. For an evicted terminal task, each load is a cold whole-history scan. This contradicts finding 2, and the review ruled S5.
- **Its first two nits fold into S5's rewrite of the cost paragraph:**
  - the paragraph named unexported identifiers;
  - its retry sentence understated the retry's cost.
- **Its third nit needed no code change:** the log's classes name no replacing request. The project manager confirmed from the driver that `request()` sets `ReplacesRequestID` (`main.go:335-337`), so replacements are in the traffic, classed under `review.request` and `failure.request`.

The verdict is `local://t12-s4-verdict.md`.

### S4's labelled measurement

A throwaway driver through the public interface, never committed, with a byte-identical copy in `t12-s4-evidence/driver/`:
- `_t12_s4_measure/main.go`, SHA-256 3d125c25c2f20fe8658bf7b6417fa3aca634ae84e60a3bc8b3ab3a388ed9fd47;
- `memory_windows.go`, 8482128fd478e9fec4615891520e3214aad5bc6bc24c6a82d5d97499b6aa6d50;
- `memory_other.go`, 510e7fa1005148730aaf4b1bad5141914262b14827ce1aae9e11137aafd52d04.

It also reimplements `sourceRecord`'s from-0 and segment-aligned scans over the public ledger reader. Its defaults are populations 12 and 20 and factor 2. With `-profiles <dir>` it writes four CPU profiles and computes the read-rights share itself with `go tool pprof -traces`. The coder ran it under load (`measurement.log`, 2,101.6 s). The project manager reran it on ee450cf in the owner's quiet window (`smoke-pm/measurement-pm.log`, 842.1 s, 20:30:17–20:44:28), with the busiest process at 0.08 and 0.07 of a core before and after.

Its first lines label it:
- a bookkeeping measurement only: no duration assertion, SLA, capacity, population cap or C4 claim; no executor, model, tool or provider work; and no injected crash or power loss;
- the 10× history not reached: the project manager set about 2× for a run under 45 minutes, so the 10× figures are projections, not measurements.

The figures below are the quiet rerun's unless marked as the coder's.

- **Setup:** one capacity for the colony: 3 turn slots, 8 local slots, a 134,217,728-byte buffer, 5,000 local units and 4,194,304-byte operations. Every request carries one deadline.
- **Populations:** 12, then 20 work contexts, each with one more context for the reviewer. Each context has one task, which is created, given three grants, started and submitted.
- **Traffic:** review and failure requests, among them replacements that name the current request; approves, rejects and failure decisions; decisions by a non-reviewer; and two races.
  - At 12 contexts: 125 calls (127 in the coder's run): 116 applied, 2 busy (4), 4 stale and 3 denied. The stale calls are 3 superseded late callbacks and 1 race loser; the denied ones are the non-reviewer's.
  - At 20 contexts: 229 calls: 194 applied, 22 busy, 7 stale and 6 denied, the same in both runs.
  - The synchronized bursts: at 12, the requests gave 12 applied and the decisions 8 applied and 2 busy; at 20, the requests 8 applied and 12 busy, and the decisions 8 and 10. Busy calls were retried one at a time and are not counted as throughput.
- **The races,** in both populations and both runs:
  - two identical results: both callers applied with the same receipt, 4 records and 1 unit, and the task completed once, at version 4;
  - a result against a reassignment: the reassignment won and the result was stale, with 3 records and no unit, the task waiting at version 4 on the fresh context, and the review stale.
- **The growth phase:** 11 cycles over 33 new contexts, to 2,163 records against a target of 2,094, in 361.3 s. Its 319 calls were all applied: 33 tasks with three grants each, started, submitted and sent for review, then 22 approves and 11 rejects, and 11 failure requests and decisions.
- **The profiler** was on for `agents.Open` and for the probe decision at each length. Neither was measured without it.

| Measure | 1,047 records | 2,163 records |
|---|---|---|
| Commits; F3-12 groups N (requests, results); reviewer grants G (on terminal tasks) | 314; 80 (41, 39); 32 (30) | 651; 172 (87, 85); 67 (65) |
| Ledger bytes | 1,402,745 | 2,925,733 |
| The store's Open | 75 ms (coder 97 ms) | 134 ms (coder 348 ms) |
| `agents.Open` | 43.9 s (coder 119.8 s) | 330.6 s (coder 800.5 s) |
| Its CPU share in the read-rights path | 55.8 % (coder 64.6 %) | 73.1 % (coder 74.9 %) |
| One approve decision | 1.16 s (coder 1.91 s) | 6.0 s (coder 16.06 s) |
| Its CPU share in the read-rights path | 64.5 % (coder 76.4 %) | 75.2 % (coder 76.6 %) |
| A review request; a failure request; a failure decision | 1.39 s; 1.30 s; 1.50 s | 7.79 s; 10.22 s; 3.59 s |
| Cold receipt lookup, twice | 29 and 30 ms | 72 and 62 ms |
| Old request-ID lookup, twice | 78 and 74 ms | 171 and 172 ms |
| `sourceRecord` from 0, at the early, middle and late witness | 32.6, 30.3 and 30.3 ms | 61.6, 61.1 and 61.3 ms |
| `sourceRecord` segment-aligned, same witnesses | 0.0, 10.3 and 26.0 ms | 0.0, 30.6 and 61.0 ms |
| Peak working set | 81 MB (coder 148 MB) | 215 MB (coder 424 MB) |

- **Growth.** For 2.07 times the records, the N·G·H model predicts 9.30 times.
  - `agents.Open` grew 7.53 times, exponent 2.78 (the coder's 6.68 times, exponent 2.62).
  - One decision grew 5.16 times, exponent 2.26 (8.39 times, 2.93).
  - Projected at 10× the baseline history, not measured: `agents.Open` about 26,649 s, 7.4 h (the coder's 13.8 h), and one decision about 212.5 s (1,635 s).
  - Over the growth phase, decisions averaged 1.55 s at about 1,177 records and 4.98 s at about 2,112.
- **`sourceRecord`.** Both logs are one segment, so the aligned form saves only the reading past the witness. In the coder's run, from 0 took 64–146 ms against 2.4–146.5 ms aligned.
- **The cause:** every new decision and every replayed F3-12 group checks both participants' read rights through ticket 11's `artifactAuthority`. That function loaded the task of every task grant the participant held, a cold whole-history scan for each evicted terminal task, before it compared the artifact's task. A decision was O(G·H) and Open O(N·G·H).
- **The process:** 842.1 s elapsed, 961.2 s of CPU and 219 GB allocated in total (the coder's run 2,096 s, 2,333 s and 231 GB).
- **Unmeasured:**
  - disk IOPS, flush latency and physical I/O, with the OS cache not flushed;
  - Linux and macOS;
  - a quiet machine, which the driver does not control;
  - concurrency beyond the two bursts and two races, or more than one service per colony;
  - crashes, power loss and isolation;
  - executor, model, tool, provider and C4 work;
  - garbage-collection pauses and per-goroutine CPU;
  - the profiler's child processes;
  - the 10× history;
  - Open and the decision without the profiler;
  - capacity or throughput.

The deviation from the brief's plan: the brief asks for about 10 times the baseline history, and S4 reached 2.07 times, by the project manager's answer. S5 reached it: its coder's run measured 10.04× ([S5](#s5-the-artifact-read-check-order-2026-10-24)).

## S5, the artifact-read check order (2026-10-24)

The S4 review's major finding sent the measured regression here, and its ruling is S5's design under D117, with no designer brief:
- in ticket 11's artifact-read authority check, resolve the artifact's source record once per call, from the witness batch when there is one and otherwise by one source read;
- compare the task that source names with each task grant before loading any task, and load only the matching task;
- keep every other check and its order;
- add no cache, index, snapshot or retained state;
- change no accept or deny outcome.

The ruling expected a decision to cost O(G + witness batch) and Open O(N·(G + segment)), P13's bound. A cost break is untestable without a duration assertion, so the ruling asked for S4's driver rerun on the exact commit, at the same lengths and with the same labels, as the proof.

CoderT12S5 (role `coder-claude`, Claude Opus 5.5 at effort xhigh, with the LSP) started at 20:31 on ee450cf and ran for 2h6m. It only read and edited until the project manager's quiet rerun of S4's driver ended, at 21:09.

S5 is 2 files in `internal/core/agents`, +50/−39, committed as e2008b6 on ee450cf. Both hashes match the committed blobs:
- **`scoped_authority.go`,** SHA-256 15c242be2e9fdf8758be24456f1d8e1fff0c95e4b2d1db084853554116add508. `artifactAuthority` resolves the artifact's source at most once per call, lazily, at the first task resource whose `task.inspect` the caller holds: from the witness batch when there is one, and otherwise by one `sourceRecord`. It compares the task that source names with each task resource before `loadTask`, so only the matching task loads. The artifact-class early return, the `task.inspect` authorization, the audience, the description's SHA-256 and size and its equality, and the selected-grant branch keep their order. The only state is two locals. The function comment gained three lines.
- **`doc.go`,** SHA-256 2c76c9014892f9f2eef2f21084bb820717729c042d66f1fafeb534b241d4b4c8. Only its cost paragraph changed (lines 311–337).

Production and test imports are byte-identical to S4's, and `go mod tidy -diff` is empty. S5 reached `main` by fast-forward at 23:16:07.

The two data differences, as the coder states them:
1. A source that cannot be read or decoded now returns its error before any task is loaded: at the first task resource whose `task.inspect` the caller holds, `artifactAuthority` resolves the source (witness batch, else one `sourceRecord`) and returns a read or decode error there. Before S5 that error surfaced only after a task had loaded and matched the audience, SHA-256 and size. A caller with no matching task got `ErrDenied`, or authorization from an artifact-class grant visited later in map order. With no witness batch, a failed source read moves the same way. The artifact-class branch is unchanged and reads no source.
2. A failed history scan for a task that cannot match no longer surfaces. A task resource whose task differs from the source's is skipped without `loadTask`, as is every resource when the source is absent or not a `task_changed` record. So a corrupt or unreadable scan for that task, an evicted terminal one for example, no longer returns its error. Before S5 every authorized task resource loaded its task first.

The review accepted both as the ruling's "corrupt or unreadable data", and with them a failed source read on the path without a witness batch.

The retry's cost as built:
- A retry matched in pass 1 has no witness batch and reads each reference's source from its segment start.
- A retry of a committed approve or fail loads the now-terminal task by a whole-history scan, batch or no batch.

| Step | Result |
|---|---|
| gofmt; `go vet` and staticcheck for all five targets (coder) | gofmt empty; vet and staticcheck clean (ten logs) |
| V1 (coder, quiet) | pass, 58.8 s (`ok` 57.584 s) |
| Race (coder, quiet) | pass, 343.7 s (`ok` 331.970 s), no data race and no test over 60 s. The race times the S4 review asked for: `TestScopedTaskTransitionsAndProjection` 41.33 s (75.1 s at S4 under load; 58.89 s at ticket 11's S4); `TestReviewProseCannotDecideTask` 26.11 s (46.7 s at S4; 23 s at S3b); `TestReviewInjectedCrashRecovery` 5.33 s, its rows 9.38–10.56 s |
| V5 `-race -count=20` on `TestReviewResultRaces` and `TestReviewDuplicateAndReplacement` (coder, quiet) | pass, 237.1 s |
| V6, V7, V10, gofmt, staticcheck, line endings (project manager, e2008b6) | the four imports; `go mod tidy -diff` empty and `go mod verify` clean; Defender on; clean |
| Fuzzing (project manager, e2008b6) | 120 s each, no failure, `testdata` clean: `FuzzReviewGroupReplay` 13,544 executions, 29 new interesting inputs; `FuzzScopedGroupReplay` 16,700, 14 new |
| V4 full check, uncached, with its race step (project manager, e2008b6; the ticket's full check, D129) | `check PASSED: all 9 steps passed in 1681.3s` (tests 519.4 s, race 1057.0 s; `internal/core/agents` 292.8 s and 901.0 s), within D127's 25-minute line |

The coder's machine was quiet: the busiest process used 0.03 of a core before the 2× run and 0.04 before the 10× run.

Rule break, red, restored by hash and green:

| Break | Failing test | The mutation |
|---|---|---|
| S5-taskid | `TestScopedTaskTransitionsAndProjection` | the three-line TaskID comparison removed (`scoped_authority.go` 15c242be… → 655bb48c…). A `task.inspect` grant on task 410 authorized reading hidden task 405's description, which has the same bytes (`scoped_task_projection_test.go:203`). The whole package went red with exactly that one failure, and the file was restored to 15c242be…, green |

No test was added: the ruling allowed an existing test's red, and a cost break has no duration assertion.

Review: AdvisorT12S5 reviewed S5 and the close documents in one review (D116 item 6, as the S4 review allowed): "S5 e2008b6 approved: artifactAuthority resolves the artifact's source once, at the first task resource the caller may inspect, compares its TaskID before loadTask and loads only that task, with every other check in its order and no state; dropping the comparison turned ticket 11's TestScopedTaskTransitionsAndProjection red; the quiet driver put the read-rights path at 0.000 of every profile, one approve at 85 → 160 ms for 2.07× history and 94 → 671 ms for a measured 10.04× (exponent 0.85), and agents.Open at 13.2 → 47.8 s and 15.6 → 1,191.1 s (exponents 1.78 and 1.88, 9–11 % of it the review path's witness batch and the rest ticket 10's and 11's scans), inside the ruling's O(N·(G + segment)); doc.go's cost paragraph names no unexported identifier and states the retry's cost as built; one nit, no change required."

Its one nit, with no change required: `doc.go`'s retry sentence places the terminal-task load inside its exception for a retry matched before the witness batch is read. That load in fact applies to every retry of a committed approve or fail. The sentence is ambiguous, not false, and a `.go` edit would need a new commit and a new full check (D129). The verdict is `local://t12-s5-close-verdict.md`.

### S5's measurement

**The driver edit changed two rules.** The project manager's answer 1 to the coder's question 1 made the `ten_times_history_not_reached` label print only when the factor is below 10, in neutral words, because the old text asserted S4's cubic cause:
- `main.go` went from 3d125c25… to b93e548b9de584496a7a7863b3c374846aadc1a9239834913ed647e06fb55136 (`driver-edit.sha256`); `memory_windows.go` and `memory_other.go` are unchanged.
- Both of the coder's runs used the edited driver, and the 2× log's line 2 is the new wording. The project manager's rerun used it too: `main.go` b93e548b…, with the other two files unchanged.
- For that label, the answer set aside the S4 ruling's "driver unchanged apart from the commit it runs".
- The same answer let the 10× run go at a projected 55–68 minutes (`ten-times-projection.txt`), against the assignment's "under about 45 minutes", under the owner's "The device is yours until the timing runs are complete" (21:08). The run took 3,927.3 s.

The review confirmed the answer.

The coder ran the driver at 2× and at 10× on its worktree, whose hashes equal e2008b6's blobs. The project manager reran it at 2× on e2008b6 from 23:12:05 to 23:15:32 (exit 0, 206 s). Before his run the busiest process, apart from the sampler, used 0.02 of a core; no sample was taken after it.

All four 2× runs below reached the same history. Commits went from 314 to 651, H from 1,047 to 2,163, N from 80 (41 requests, 39 results) to 172 (87, 85), G from 32 (30 on terminal tasks) to 67 (65), and ledger bytes from 1,402,745 to 2,925,733. Each cell gives the baseline → the grown length.

| Measure | Project manager's S5 rerun (e2008b6) | Coder's S5 run (e2008b6) | Project manager's quiet run (ee450cf) | Coder's loaded run (ee450cf) |
|---|---|---|---|---|
| The store's Open | 81.7 → 118.4 ms | 66.7 → 120.3 ms | 75.2 → 134.0 ms | 96.7 → 348.0 ms |
| `agents.Open` | 14.7 → 50.7 s, exponent 1.70 | 13.2 → 47.8 s, 1.78 | 43.9 → 330.6 s, 2.78 | 119.8 → 800.5 s, 2.62 |
| Its CPU share in the read-rights path | 0.000 → 0.000 | 0.000 → 0.000 | 55.8 → 73.1 % | 64.6 → 74.9 % |
| One approve decision | 84 → 140 ms, exponent 0.71 | 85 → 160 ms, 0.86 | 1.16 → 6.0 s, 2.26 | 1.91 → 16.06 s, 2.93 |
| Its CPU share in the read-rights path | 0.000 → 0.000 | 0.000 → 0.000 | 64.5 → 75.2 % | 76.4 → 76.6 % |
| Cold receipt lookup, twice | 42 and 31 → 77 and 70 ms | 42 and 41 → 77 and 82 ms | 29 and 30 → 72 and 62 ms | 89 and 76 → 130 and 141 ms |
| Old request-ID lookup, twice | 97 and 82 → 196 and 185 ms | 91 and 91 → 204 and 196 ms | 78 and 74 → 171 and 172 ms | 224 and 271 → 367 and 349 ms |
| `sourceRecord` from 0, at the early, middle and late witness | 34.5, 33.0, 30.6 → 77.5, 97.3, 85.8 ms | 32.4, 30.4, 30.5 → 68.7, 67.0, 68.4 ms | 32.6, 30.3, 30.3 → 61.6, 61.1, 61.3 ms | 77, 72, 64 → 120, 113, 146 ms |
| `sourceRecord` segment-aligned, same witnesses | 0.0, 12.9, 25.2 → 0.0, 42.6, 86.3 ms | 0.0, 15.6, 28.4 → 2.0, 34.5, 64.7 ms | 0.0, 10.3, 26.0 → 0.0, 30.6, 61.0 ms | 3.5, 32.6, 48.7 → 2.4, 56.9, 146.5 ms |
| Peak working set | 100 MB | 100 MB | 215 MB | 424 MB |
| The run's elapsed time | 204.1 s | 191.4 s | 842.1 s | 2,096 s |

The project manager's S5 rerun:
- Counts at 12 contexts: 128 calls, 116 applied, 5 busy, 4 stale and 3 denied. At 20 contexts: 229 calls, 194 applied, 22 busy, 7 stale and 6 denied.
- Growth: 319 calls, all applied, in 84.8 s. Growth decisions averaged 82 ms over the first ten and 140 ms over the last ten.

The coder's S5 run at 2×:
- Counts at 12 contexts: 124 calls, 116 applied, 1 busy, 4 stale and 3 denied. At 20 contexts: the same as the project manager's.
- Growth decisions averaged 87 and 135 ms.

The races ended as at S4 in every run: the two identical results both applied with the same receipt, 4 records and 1 unit; the result against a reassignment was stale, with the reassignment applied, 3 records and no unit.

The coder's run at 10× measured history that S4 could only project, on the tree whose hashes equal e2008b6's blobs:
- **History:** 3,174 commits, H 10,515, N 868 (435 requests, 433 results), G 328 (326 on terminal tasks), and 14,337,611 ledger bytes.
- **The store's Open:** 75.1 → 602.5 ms.
- **`agents.Open`:** 15,612 → 1,191,102 ms, 76.3 times, exponent 1.88; the N·G·H model predicts 1,116.9 times.
- **One approve:** 94.2 → 671.4 ms, exponent 0.85.
- **Read-rights shares:** 0.000 in all four profiles, of 18.03 s, 0.10 s, 1,307.97 s and 0.72 s.
- **Lookups:** cold receipt 409 and 368 ms; old request 1,006 ms.
- **`sourceRecord` at the grown length:** from 0, 342.5, 322.7 and 313.5 ms over 3,174 commits; aligned, 1.0, 153.0 and 312.1 ms over 8, 1,590 and 3,167 commits.
- **Growth:** 2,842 calls, all applied, over 98 cycles and 294 contexts in 2,631 s. Growth decisions averaged 102 ms over the first ten and 620 ms over the last ten.
- **Counts at 12 contexts:** 128 calls, 116 applied, 5 busy, 4 stale and 3 denied; at 20 contexts, the same 229.
- **The run:** 3,927.3 s, 4,652 s of CPU, and a peak working set of 831 MB.

The labels:
- The 2× logs' lines 1–2, as printed, read: "bookkeeping_measurement_only: no duration assertion, SLA, capacity, population cap or C4 claim; no executor, model, tool or provider work; injected crashes and power loss are not exercised here" and "ten_times_history_not_reached: the brief's plan asks about 10x the baseline history; this run used factor 2, so the 10x figures below are projections, not measurements".
- The 10× log printed line 1 only.
- Some of the 10× log's lines are false for that run, and were left because the edit permission covered the label alone:
  - its line 154, "unmeasured the 10x history: only projected from the two measured lengths";
  - the "(projected, not measured)" labels on its lines 88–89;
  - the same strings in its `summary_json`.

  Its measured figures are lines 57, 60 and 68 and the `measured_ms` of lines 88–89.

The profile reading, from `pprof-shares.txt`, is an analysis of the kept profiles, not a measurement:
- **Open grown at 2×:** `inspectOpen` and `scopeHistory` 45.5 %; `refreshLocked` 33.5 %, of it `planScoped` 22.7 % and `planReview` 9.1 % (`reviewWitnesses` 8.4 %); `sourceRecords` 11.6 %; `loadTask` 4.1 %.
- **At 10×:** 45.2 %; 40.8 % (29.2 %; 11.1 %, of it 11.0 %); 15.2 %; 5.4 %.
- **One approve at 10×:** `reviewWitnesses` 43 %, and `artifactAuthority` 10 ms of 720 ms.

The ruling's bound holds. What remains is ticket 10's and 11's per-scope history validation and scoped replay, which ticket 140 inherits, with the review path's witness batch.

There was no 10× rerun by the project manager. The coder's run is on the tree whose hashes equal e2008b6's blobs, the convention D129 states for coders' runs (D121), and it claims no bound. A rerun would have held the owner's quiet machine for another hour, and the project manager's 2× rerun on the exact commit is the gate's figure.

Unmeasured, as the driver prints it ([S4's list](#s4s-labelled-measurement)), except that the 10× run measured the 10× history: the 10× log's line 154 says otherwise.

## CI

CI is paused ([D143](../../../docs/DECISIONS.md#d143-ci-paused-a-push-starts-no-run)). The owner wrote at 14:37: "Github Action budget has been reached, adjust the repo so that no CI tests run for the time being. A final decision/resolution will be forthcoming". D143's e045717 removed the workflow's `push` trigger, so a push to `main` starts no run, and a run starts only when the owner starts one by hand.

- No hosted run covers any of ticket 12's commits: S1, S2 with D143 and D144's record, S3a, S3b, S4, S5 or this close. The brief's §6.4 says that "a missing run is missing evidence", and that is what this is: ticket 12's code has had no CI run on Windows, Linux or macOS. Its portability rests on each check's `go vet`, staticcheck and cross-builds for the five targets.
- Run 14 started with ticket 11's push of d12f605 at 11:40 on 2026-10-24, before D143. Its logs have not reached the project manager, and no result is claimed for it.
- Ticket 12's one push, after this close (D141), starts no run (D143).
- The latest CI result recorded is run 13, on 6d3eecc, which passed all nine steps on Windows, Linux and macOS ([ticket 11's evidence](ticket-11-evidence.md#ci-runs-913)).

## Limits

- The ruling's five limits, recorded at its request (its owner gates, "Missed by the brief"):
  - after a reject, F3-11's frozen task table has no way from submitted back to active, so the ways on are a replacement and then an approve or fail, a cancel or a reassignment; revise and resubmit needs a later type version;
  - a pending failure request on an active task goes stale when the assignee submits or waits, because the task's version moves, and the requester requests again;
  - a requester must hold the decision authority it delegates (P6), so an assignee without `task.complete` cannot request its own review; the completing authority or the owner does;
  - the guard binds the owner, whose escapes are P9's: replace the request naming himself as reviewer and resolve it, cancel, or reassign;
  - a backwards system clock refuses new review decisions until it passes the floor (P10).
- [S4's labelled measurement](#s4s-labelled-measurement) reached 2.07 times the baseline history, not the brief's 10 times, and its 10× figures are projections. Before S5, on a quiet machine and under the CPU profiler:
  - `agents.Open` took 43.9 s at 1,047 records and 330.6 s at 2,163, against the store's 75 ms and 134 ms;
  - one decision took 1.16 s and 6.0 s;
  - the read-rights path took 56–75 % of the profiled CPU.

  After S5, quiet and under the profiler, the driver rerun on e2008b6 put the read-rights path at 0.000 of every profile: at 2× (the project manager's rerun) `agents.Open` took 14.7 s at 1,047 records and 50.7 s at 2,163 (exponent 1.70; the coder's run 13.2 s → 47.8 s, 1.78) and one approve 84 ms → 140 ms (the coder's 85 → 160 ms); the coder's run on the tree whose hashes equal e2008b6's blobs reached a measured 10.04× (H 10,515, N 868, G 328): `agents.Open` 15.6 s → 1,191.1 s (exponent 1.88) and one approve 94 → 671 ms (0.85). What remains of Open's growth is ticket 10's and 11's per-scope history validation (about 45 % of its CPU) and scoped replay (23–29 %), with the review path's witness batch at 9–11 %, the ruling's O(N·(G + segment)) in a one-segment log; the driver's 10× label was changed by the project manager's answer, hashes recorded, and the 10× log's unmeasured-10× line is false for that run ([S5](#s5-the-artifact-read-check-order-2026-10-24)).
- What ticket 140 still inherits (P13, as the S4 review restated it):
  - the F3-12 groups in its index, since task state needs both families;
  - the cold request and receipt lookups as index sites;
  - the witness batch, which in a one-segment log reads up to each witness's position.

  `sourceRecord`'s from-0 scan is no longer among them, because S3a moved it to the segment-aligned cursor.
- The rows ran on one Windows machine, and no hosted CI run covers ticket 12 ([CI](#ci)).
- As the brief's §6.4 bounds it, this evidence is semantic task and review bookkeeping, injected crashes, metadata-only references and Windows measurements, with no runtime executor, C4, power-loss, A2 or whole-C3 claim.

## Where the logs are

The raw logs stay outside the repository, as in ticket 11's evidence.

- **The coders' runs.** Each evidence folder beside the worktrees holds the command record, `commands.jsonl`, the final runs' logs and the red and green logs of every rule break:
  - `t12-s1-evidence`;
  - `t12-s2-evidence`, with CoderT12S1's partial start in `partial-CoderT12S1`;
  - `t12-s3a-evidence`, with `breaks.json`;
  - `t12-s3b-evidence`, with CoderT12S3b's partial state in `partial-CoderT12S3b`, `producer-matrix.log` and `precedence-old.log`.

  The coders' reports are `local://t12-s1-coder-report.json`, `local://t12-s2-coder-report.json`, `local://t12-s3a-coder-report.json` and `local://t12-s3b-coder-report.json`, with S3b's pause report `local://t12-s3b-pause-report.md`. The diffs are `local://t12-s1-diff.md`, `local://t12-s2-diff.md`, `local://t12-s3a-diff.md` and `local://t12-s3b-diff.md`.
- **The project manager's evidence, fuzzing and checks:**
  - `local://t12-s1-ev/`, `local://t12-s2-ev/` (with the record commit's check in `v4-record.txt`), `local://t12-s3a-ev/` and `local://t12-s3b-ev/`;
  - the summaries `local://t12-s1-evidence.txt`, `local://t12-s2-evidence.txt`, `local://t12-s3a-evidence.txt` and `local://t12-s3b-evidence.txt`;
  - the build notes, `local://t12-docs-notes.md`, which hold every check result, every fuzz run and every answer to the coders.
- **S4:**
  - the coder's `t12-s4-evidence`, with `measurement.log` and its profiles, `machine-load-before-measurement.txt`, the driver's development runs `driver-trial.log` and `driver-profile12.log` with its profile, `break-floor.log`, and the hashes of the deleted throwaway scripts in `deleted-scripts.sha256`;
  - the driver's copy in `t12-s4-evidence/driver/`;
  - the project manager's quiet rerun in `t12-s4-evidence/smoke-pm/`: `measurement-pm.log`, its profiles and the machine-load samples;
  - the coder's report `local://t12-s4-coder-report.json` and the diff `local://t12-s4-diff.md`;
  - the project manager's full check in `local://t12-s4-ev/v4.txt`.
- **S5:**
  - the coder's report `local://t12-s5-coder-report.json` and the diff `local://t12-s5-diff.md`;
  - the coder's evidence folder `t12-s5-evidence\`, outside the repository, with:
    - `commands.jsonl` and the final runs' logs;
    - `break-taskid.log`, `restored-taskid.log` and `break-taskid.sha256`;
    - the driver's raw output, `measurement.log` and `measurement-10x.log`, with `profiles\` and `profiles-10x\`;
    - `ten-times-projection.txt` and `pprof-shares.txt`;
    - the machine-load samples;
    - the edited driver in `driver\`, with `driver-edit.sha256`;
    - `deleted-scripts.sha256`;
  - the project manager's gate summary `local://t12-s5-evidence.txt`, his full check in `local://t12-s5-ev/v4.txt` and his rerun in `t12-s5-evidence\smoke-pm\`.
- **The readers' maps:**
  - `local://t12-reader-code.md`, for the design;
  - `local://t12-reader-golden.md`, cancelled during S2 and reused in S3a;
  - `local://t12-reader-s3a.md`.
- **The design and the reviews:**
  - the designer's yield `local://t12-designer-yield.md`;
  - the ruling's yield `local://t12-ruling-yield.json`;
  - the verdict files named under each slice;
  - AdvisorT12S2's answer on note 16, `local://t12-s2-note16-answer.md`;
  - the freeze record as applied, `local://t12-f3-12-record-final.md`.
- **CI:** no run covers ticket 12 (D143), and run 14's logs have not reached the project manager.

## The reviews

Every review in ticket 12 was a fresh build advisor, Fable (`claude-fable-5-1`), spawned for that review alone; no stand-in reviewer ran. AdvisorT12S2 was revived once, during S3a, to rule on its own note 16, which it withdrew. The S5 review and the close review were one review (D116 item 6), as the S4 review allowed.

| Review | Advisor | Commit | Verdict | Ran |
|---|---|---|---|---|
| The design ruling | AdvisorT12Ruling | the brief, at d12f605 | approve-with-changes: 9 choices accepted and 6 modified; 2 major, 6 minor and 2 nit findings | 22.2 min |
| S1 | AdvisorT12S1 | 69a26c2 | approve: 1 minor, 1 nit | 7.7 min |
| S2, the F3-12 record and D143 | AdvisorT12S2 | 6a34116 and e045717 | approve, S2's D41 sign-off: 1 minor, 2 nits | 13.5 min |
| S3a | AdvisorT12S3a | 7a91eaf | approve: 1 minor, 3 nits | 17.6 min |
| S3b | AdvisorT12S3b | 20d076e | approve: 1 minor, 2 nits | 14.4 min |
| S4 | AdvisorT12S4 | ee450cf | approve: 1 major, ticket-level and routed to S5, and 3 nits | 11.8 min |
| S5 and the close | AdvisorT12S5 | e2008b6; the close commit | approve: one nit on S5, no change required; the close documents with this review's changes applied | 11.8 min |
