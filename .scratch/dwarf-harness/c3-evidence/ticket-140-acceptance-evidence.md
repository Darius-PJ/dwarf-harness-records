# Ticket 140 acceptance evidence

Close date: 2026-10-29. Final code: `453ec63abfc3eb8b15a2322ef09d279dcce22d1e`; measurement control: `93e8f0afe125b1ea8e87f4b8336664dd390c5b3a`. All seven original numerical bounds pass with three eligible instances per driver and no noise extension. This is observed numerical acceptance, not a substitute for the final reviews or exact-SHA hosted gate recorded below. Sources: PM-local `t140-s6-campaign-summary.json:2-4,114-245`.

Source criteria: `.scratch/dwarf-harness/issues/140-bound-the-private-state-services-replay-and-lookup-cost.md:34-37`. PM-local means the issuing PM session's retained `local/` folder. Native evidence means `C:/Users/darius.jones/worktrees/dwarf-harness/`; paths below are relative to that root unless stated otherwise. Immutable sources remain private under D145; their original wording is not rewritten to match later outcomes.

## Acceptance matrix

| Criterion | Observed evidence and limits |
|---|---|
| 1. Ruled design before code. | S1–S3 build the original bounded lookup/current-head and fused-inspection design; S4 follows its amendment. D155/D156 permit S5's ordered milestones, with D157's completed Reader freeze before Core consumption. D158/D159 authorize and rule S6 before its Open-only change. The original S5 sequencing rejection remains verbatim; D156/D157 resolve it, not a rewritten verdict. |
| 2. Ledger-derived, discardable acceleration; no committed-state loss, append or dispatch. | S1 lost/damaged/stale proofs; S2 eviction/disable/corruption and invalidation; S3 inert rebuild and damaged materialization hints; S4 exact coverage/range fallbacks; S5 Reader prefix/predecessor/close and Core fallback/charge rows. S6's Open-provenance test establishes a real seed, then rejects changed prefix bytes without accepted-state changes or a successful source proof. One shared 256-entry/8 MiB charged-metadata cap remains, not an RSS or authority allowance. |
| 3. Same grants/refusals/transitions/reads/recovery, frozen replays and crash rows; no record/rule/golden change. | Passing legacy-family/crash suites and genuine semantic mutants are retained across S1–S5; S4 also covers the inherited registration family. S6's full plain run has 1,379 PASS/0 FAIL/0 SKIP; its wrong-session mutant makes Open accept an invalid real group, then exact restore/same-selector green. D159 expressly permits truthful reporting of actual initial-replay descriptor-close errors from Open/OpenPaid; no equivalence under ignored OS faults is claimed. |
| 4. Original traffic/log regimes and all seven bounds, admission and storage only. | Unchanged T11 and T12-S5 programs, three eligible final instances each/all six exit 0, all seven rows below pass without extension. T11 retains its full ten-operation loop to the actual tenfold-commit endpoint; T12 its factor-2 workload/four profiles. Loaded-invalid and postponed attempts remain excluded and retained. Final reviews/hosted gates below are separate. |

Sources: PM-local `t140-s1-verdict.md:6-18`, `t140-s2-verdict.md:5-20`, `t140-s3-verdict.md:12-29`, `t140-s4-review-binding.json:1-40`, `t140-s4-final-evidence-receipt.json:107-178`, `t140-s5-core-local-complete.json:1-29,856-932`, `t140-s6-campaign-summary.json:114-245`; `docs/DECISIONS.md:3091-3118,3126-3164`.

## Six-slice source and proof map

| Slice / exact code identity | Built boundary and actual retained proof |
|---|---|
| S1 `da18709ec0ad8d223cea50c28eb643469005f640` | Complete-prefix context/identity hints. Plain/race/affected ×20, three semantic reds/restores/greens and three 120-second replay campaigns pass. Fresh Astra approval and Check 5/run 40773519796's authorized same-SHA retry clear integration; original Windows failure stays unclassified. PM-local `t140-s1-verdict.md:6-23`, `t140-s1-final-evidence-receipt.json:1-7`, `t140-s1-failure-disposition.md:1-7`; native `t140-s1-evidence/`; `t140-s1-main-publication.json`. |
| S2 `d9debacbffd1b96d593b6b4b5ed6268688f3af34` | Single metadata LRU, exact command intervals/source witnesses and both invalidation paths. Plain/race/×20, three semantic reds/restores/greens and three timed campaigns pass; Check 6/run 40781270966 full three-OS/race/aggregate passes. Revocation mutant proves the wrong refusal class, not unauthorized execution. `t140-s2-verdict.md:5-24`, `t140-s2-final-evidence-receipt.json:1-13`; native `t140-s2-evidence/`; `t140-s2-main-publication.json`. |
| S3 `82d8d48856c7191019625c9f6e896d10b9b8498c` | Fresh integrity/current-head selection and fused historical inspection. Final plain/race/×20 and four semantic reds/restores/greens pass; comparison-only/unused-buffer corrections are distinguished from mutation source hashes. Three selected timed campaigns and Check 7/run 40789560953 full matrix pass. No private-file timed-fuzz coverage is claimed. `t140-s3-verdict.md:12-29`, `t140-s3-final-evidence-receipt.json:1-15`; native `t140-s3-evidence/`; `t140-s3-main-publication.json`. |
| S4 `8a17ec1ed2617ca2a4e5203479f75f363b359970` | Membership/source warming and scoped acknowledgement; private BodyRefs codec repair, not a frozen Digest change. Nine blobs match reviewed/tested bytes; 15 semantic reds/restores/greens, plain/race/×20, dual Astra approvals, four timed campaigns and full Check 10/run 40820895667 pass; guarded main publication observed. `t140-s4-review-binding.json:1-40`, `t140-s4-final-evidence-receipt.json:107-178`, `t140-s4-hosted-success.json:1-24`, `t140-s4-main-publication.json:1-52`; native `t140-s4-evidence/`. |
| S5 Reader `81ae94d3e92b5fd5574f46046c42fc9c5e30ce6d`, frozen/public `bf71ba15cfc24095e36cf7230115694e665275ad`; Core `2bce72e610ec9380c08314645f0ecea7e3a44ea8` | Two ordered milestones, one counted slice. C1's prefix/actual-close proof, four semantic reds/restores/greens, four timed campaigns and 46 unchanged frozen fixtures precede D157; own full Check 12/run 40959042523 passes before main integration. Core then passes its complete 13-blob binding, plain/race (1,377 PASS each), affected ×20 (400 PASS) and four timed campaigns. `docs/DECISIONS.md:3105-3118,3126-3137`; [Reader evidence](ticket-140-s5-reader-freeze-evidence.md); `t140-s5-core-local-complete.json:1-29,856-932`; native `t140-s5-core-evidence/`. No separate Core hosted integration is inferred. |
| S6 `453ec63abfc3eb8b15a2322ef09d279dcce22d1e` | Open-only replay capture/success-only seed. Focused: 12 top-level tests/60 PASS/0 FAIL/0 SKIP, both prefix-change provenances. Wrong-session semantic red/exact restore/same-selector green. Plain: 184 top-level tests + 5 fuzz seeds, 1,379 PASS/0 FAIL/0 SKIP, 84.151 package seconds; format/static/import proof retained. Scoped replay fuzz: 120-second budget, 20,044 executions, 4 new interesting/231 total, 123.958 package seconds, unchanged source. First complete original T11 run is smoke and eligible instance 01. `t140-s6-campaign-summary.json:119-243`; native `t140-s6-core-evidence/`. No new local race/×20 or other timed target required by the ruling; hosted race still required. |

Preserve stage-specific receipts: S5's local-complete receipt predates its measured smoke/cohort, whose outcome is supplied separately. S1's successful retry does not explain its first failure; the absent original full log is not a new close gate (`t140-s1-failure-disposition.md:1-7`).

## Final diagnosis and safety boundary

The D158 diagnostic on `2bce72e` found 120 of task.create's 125 sampled CPU milliseconds in acknowledgement reading: it was the first scoped command after legacy Open, which captured no checkpoint. Instrumented/above-threshold diagnostic times are not acceptance data. D159 permits only initial replay through frozen `OpenReaderWithCheckpoint(..., nil)`, unchanged drain/reducer, and success-only publication at saved `openedThrough`. Ordinary refresh/historical scans remain legacy; accepted advances invalidate and Close clears/disables. Fresh prefix/predecessor validation and safe fallback remain. Sources: PM-local `t140-s6-diagnostic.json:2-24`; `docs/DECISIONS.md:3155-3164`.

## Original-program measurement and eligibility

Final native analysis: `t140-measure-evidence/s6-campaign/analysis.json`, SHA-256 `130de47e6b228499b9b451e69f4c1a9f07862399ce5434bae557c7502c6259fd`. Analyzer SHA-256 `2a3e593c68210641a71f0b3069a2a48f6a74ca7e69dd4b31add49d64ac2d7216`; runner `22bb829e416d8357e102bd7aa08782ab95aa32262e48ceec6fa88324e9b9ab99`. The folder retains exact copies, receipts/JSONL/stderr, raw frontiers/outcomes, cold lookups, memory and original T12 profiles. Source: PM-local `t140-s6-campaign-summary.json:5-31,213-219`.

Saved T11 driver is `t11-s4-evidence/driver/`; T12 is `t12-s5-evidence/driver/`, the already label-corrected S5 program. Main-source hashes respectively `e708da67da558f868ab36476369e0053d50207060b93ec5bb0b48ec26aef5044` and `b93e548b9de584496a7a7863b3c374846aadc1a9239834913ed647e06fb55136`; all six original main/memory source bindings are retained in PM-local `t140-docs-notes.md:16` and the campaign receipts.

One eligible control per driver is reused on `93e8f0a`. Final candidates use the same pinned Go/environment, fresh directories and serial/no-overlap reservation. Five-second pre/post unrelated CPU must each be ≤0.25 core; invalid postflight replaces the whole instance, never timing alone. T11 retains populations 12→20, held turns 1→3, burst 16 and its ten-operation growth loop; T12 retains factor 2/four profiles. No cache flush, traffic reduction or fixed 87/874 filter. Sources: [original ruling](ticket-140-design-ruling.md):352-450; [endpoint addendum](ticket-140-endpoint-addendum.md):7-43.

Startup: median(long Open / actual long-to-short record ratio R) ≤ median(short Open). Each incremental bound: median(long call) ≤ 2 × median(short call) + 25 ms; task.cancel uses paired profile_cleanup. Use this subject's own short samples. The one allowed extension to five requires paired differences straddling zero and a median within 10% of the bound; neither driver triggers. Sources: original ruling :374-450; native final analysis :2254-2396,8201-8228.

| Original bound | Observed median ms | Bound ms | Result |
|---|---:|---:|---|
| T11 OpenLong/R | 65.6851263 | 162.2953 | PASS |
| T11 turn.start | 25.5929 | 50.3922 | PASS |
| T11 local.admit | 20.4824 | 49.1784 | PASS |
| T11 local.begin (dispatch admission) | 23.0753 | 46.6670 | PASS |
| T11 task.create | 26.8336 | 52.8796 | PASS |
| T11 paired task.cancel | 22.2303 | 47.6304 | PASS |
| T12 OpenLong/R | 1352.7530430 | 2392.3620 | PASS |

Sources: PM-local `t140-s6-campaign-summary.json:120-219`; native analysis :2256-2396,8203-8228 retains unrounded samples/spreads and all 21 negative paired differences. Descriptive growth/exponents are not an asymptotic proof.

| Final eligible instance | Service Open short→long ms | Actual R | T11 pre-profile commits→grown commits / cycles |
|---|---:|---:|---|
| a-t11-01 | 162.2953→635.0989 | 10.259515571 | 87→874 / 78 |
| a-t11-02 | 256.1807→727.5131 | 10.311258278 | 91→918 / 82 |
| b-t11-01 | 140.4549→675.3179 | 10.281138790 | 85→852 / 76 |
| a-t12-01 | 2052.026→2567.527 | 2.065902579 | Original factor-2 workload |
| a-t12-02 | 2392.362→2794.656 | 2.065902579 | Original factor-2 workload |
| b-t12-01 | 2730.484→3177.670 | 2.065902579 | Original factor-2 workload |

Receipt prefix: `candidate-s6-quiet-20261029-` in the final campaign folder. Sources: native analysis :535-631,1061-1156,1574-1669,3847-3855,5289-5296,6727-6734; PM-local summary :32-113 supplies receipt paths/hashes and CPU windows. All six eligible runs exit 0.

| S6 retained ineligible attempt | Observed reason and disposition |
|---|---|
| a-t11-03 | Driver completed/exit 0, but post-window 0.295539336 core exceeds 0.25. Retain raw result/receipt; exclude whole instance and replace with b-t11-01. |
| a-t12-03 | Pre-window 0.317319873 core exceeds 0.25; driver never ran. Retain postponed receipt and replace with b-t12-01. |

Source: PM-local `t140-s6-campaign-summary.json:54-62,84-92,114-118`. Ineligible attempts are not numerical failures or eligible successes; none is silently dropped. Measurement output stays **admission and storage only**.

## Earlier failures and corrections retained separately

- Keep the completed failed cohorts separate: S3 `82d8d48` passes zero of seven; S4 `8a17ec1` only both startup bounds; S5 Core `2bce72e` six, with task.create 101.9633 ms > 70.1972 ms. No noise extension changed them. D155/D156 and D158 supply explicit new-slice authority, not sampling until a failed subject passes. Sources: native `t140-measure-evidence/s3-campaign-analysis.json:2290-2426,8248-8276`; PM-local `t140-s4-campaign-summary.json:1-106`; `docs/DECISIONS.md:3149`.
- Retain the withdrawn sampler-only attempts, loaded-invalid control/S3 samples, actual diagnostic profiles and correction logs. S2's invalid negative, S3's copied-projection/unused-buffer changes and S4's private import-catalogue/BodyRefs correction are not product permission relaxations or measurement causality. Sources: PM-local `t140-docs-notes.md:33-48,69-88`; `t140-s2-verdict.md:14-20`; `t140-s3-verdict.md:18-21`; `t140-s4-final-evidence-receipt.json:83-103,174-178`.

## Immutable authority copies

These eight byte copies, not paraphrases, sit beside this evidence file. Later rulings/decisions govern conflicts; preserve each original verdict, including S5's initial sequencing rejection, without rewriting its body.

| Retained file | SHA-256 |
|---|---|
| [Original brief](ticket-140-design-brief.md) | `443f7e2db2d335974722486e077a997749e259fbe5a854406dd08ed5a1674527` |
| [Original ruling](ticket-140-design-ruling.md) | `0e81a8a6140b7a24bba768d0abcd34e19d42ccb8d12ac1d043a15b79d4712a32` |
| [Endpoint addendum](ticket-140-endpoint-addendum.md) | `20d5f250152e1c321f56e7b6585745e2b0f0acc75aad16e211415d31cc62ea6c` |
| [S4 amendment](ticket-140-s4-amendment-ruling.json) | `91b579d66c352eeb98b7b4ff7e2597b58c36568e70f4487abaaf8dd21b2782b7` |
| [S5 brief](ticket-140-s5-design-brief.md) | `93bf8a13f847d03626672caae2a77f35e97ddfcc968b63568dd4ea12bc81cc55` |
| [S5 ruling](ticket-140-s5-design-ruling.json) | `ef2dfa6612bf2114dcb3229d474d841389df749d868fdb1dfb9bfb36ca702611` |
| [S6 brief](ticket-140-s6-design-brief.md) | `2888377df3f439d55e1a8cdf5d893d3e38a1fd29de4ab6cda47acf054e26e090` |
| [S6 ruling](ticket-140-s6-design-ruling.json) | `08b099c6eaf1b868616afc6deea2f08e7433df0f99061c0856932fccbb72e1d8` |

Sources: PM-supplied original four-source manifest; `docs/DECISIONS.md:3113,3128,3155`. PM checks destination bytes/SHA-256 at application; no drafter copy/hash operation is claimed.

## Final review, hosted and publication facts

- Standards review: ReviewT140FinalStandards (fresh Fable advisor, claude-fable-5-1) on exact `453ec63abfc3eb8b15a2322ef09d279dcce22d1e`, scope `bf71ba1..453ec63` under `internal/core/agents/`: **approve-with-notes, no blocking findings**. Notes only: duplicated joined close-error text under an actual close failure, one test message's wording, and a stale acknowledgement entry left as a safe miss until the next advance. Verdict retained PM-local as `t140-final-review-standards.json`.
- Specification review: ReviewT140FinalSpec (fresh Fable advisor, claude-fable-5-1) on the same SHA, scope and evidence: **approve-with-notes, no blocking findings**; all four criteria met, the fifth-slice Core conditions and the sixth-slice ruling (D159) met, and the seven bounds recomputed from the raw cohort. Notes only: the duplicated `ReadOptions` literal, the same duplicated close-error text, the `open` row's stated limit, and the short-history task.create median falling from 22.60 to 13.94 ms (the protocol's own-short-samples rule, not a relaxation). Verdict retained PM-local as `t140-final-review-specification.json`.
- Hosted check: [run 13](https://github.com/Darius-PJ/dwarf-harness/actions/runs/40982860606) (40982860606), attempt 1, on exact `453ec63abfc3eb8b15a2322ef09d279dcce22d1e`: `changes` success; the Windows (amd64), Linux (amd64) and macOS (arm64) full-check jobs, race included, all success; aggregate `Check result` success (run updated 2026-10-30T01:22:12Z). Source: GitHub Actions API; job logs need a login and were not read.
- Code publication: `main` fast-forwarded `bf71ba1` → `453ec63` at 2026-10-29 21:24:16 -0400 (reflog); guarded push (2 commits, scan clean) completed 21:24:19 EDT with exit 0; `ls-remote` shows `refs/heads/main` at `453ec63abfc3eb8b15a2322ef09d279dcce22d1e`. Check 12 on the earlier Reader freeze does not supply this final combined gate. Main push itself starts no new CI (D153).

Public close is one D116 documents commit; B35/evidence/source copies land separately under D145. The documents SHA needs its own D153 result and PM links/LF check. Record documents/private publication externally in the handoff, never a record's own commit hash inside itself.

## Limits

Admission and storage only, including T12 review bookkeeping: no capacity, production throughput, accepted delivery, provider execution, SLA, power-loss, filesystem snapshot or hostile-rewrite atomicity claim. Process-crash/torn-tail proof is not power-loss proof. Charged metadata is not RSS; cold/history work and prefix I/O/hashing remain, and eviction, an accepted frontier advance or segment rotation can make the first scoped acknowledgement after Open cold again. D52/C4/C10 and Ticket13 verification stay independent. Sources: original ruling :28-42,442-456; `docs/DECISIONS.md:3132-3137,3157-3163`; final analysis :8232-8234. Step and contract status remain only in their canonical board/status lines and register.
