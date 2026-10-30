# Ticket140 §5 addendum — unchanged-workload endpoints

**APPROVE: reproducibility correction only.** A temporary GPT-6 Astra reviewer, standing in for Fable under D152, reviewed this amendment. Fable double-checks the whole ticket after its reset.

## Basis

The original driver synchronizes 16 requests, permits busy/stale refusals and requires exactly one winning claim (`driver/main.go:373-455`). It captures the short baseline before profiling, then grows through complete cycles until commits reach at least baseline × 10 (`main.go:569-579,619-651`).

Directly read retained events confirm:

| Run | Short commits/records | Growth cycles | Long commits/records | Burst applied/busy/stale |
|---|---:|---:|---:|---:|
| Retained coder | 87/289 | 78 | 874/2965 | 10/3/3 |
| Retained PM | 88/293 | 79 | 885/3003 | 11/2/3 |
| Current base, loaded-invalid | 86/287 | 77 | 863/2929 | 10/3/3 |

Sources: `t11-s4-evidence/measurement.log:39-89,877-880`; `t11-s4-evidence/smoke-pm/measurement-pm.log:39-89,886-889`; `t140-measure-evidence/base-precision1-t11-01.jsonl:40-88,864-869`.

Against the coder run, the current base has one fewer applied local admission, one additional applied private write and one fewer cleanup local end: net −1 commit/−2 records before profiling. The original growth loop consequently executes 77 rather than 78 cycles. These are permitted outcome differences, not changed requested traffic. The literal 87/874 came from the retained coder run; no separate ruling-run artifact is required.

## Exact replacement endpoint rule

Replace §5’s literal 87/874 endpoint paragraph, and supersede the matching brief sentence, with:

> For criterion 4, “same two log lengths” means the original unchanged Ticket11 program’s smoke_log and approximately tenfold-commit long_log regimes, not fixed admitted-outcome counts. Require all three saved driver files byte-identical; preserve populations 12→20, held turns 1→3, the synchronized 16-request burst, every original phase and correctness assertion, and the ten-operation growth cycle. Let B be the committed count captured immediately before the smoke_log profile. Execute that profile and its cleanup, then the original loop: while current commits < B × 10, execute one complete growth_same_traffic cycle. Take the long_log profile immediately after that loop terminates. Retain actual short/long commit and record frontiers, Open frontiers, B, cycle count, and burst applied/busy/stale counts by operation. Use R = actual long Open records / actual short Open records; keep post-profile records separate. Do not edit the driver or traffic, force burst outcomes, impose an 86–88 special-case range or fixed cycle count, filter for 87/874, or manually shorten history. Preserve complete independent eligible-run sampling.

## Unchanged gates and limits

All other ruling requirements remain unchanged, including:

- Exact base `93e8f0a`, identical environment, fresh directories, one quiet complete base control per driver and three independent complete final runs.
- Open: `median(OpenLong/R) <= median(OpenShort)`, including supplementary T12 Open.
- Each ruled operation: `median(long) <= 2*median(short) + 25 ms`; task cancellation uses the paired `profile_cleanup` rows. No aggregate-phase substitutes.
- Five-second pre/post observations, unrelated CPU ≤0.25 core in both, and no overlapping local test/fuzz/check/measurement job. Ineligible starts are postponed; interrupted/overlapped or post-ineligible runs remain loaded-invalid and are replaced.
- Fixed noise resolution: paired differences must straddle zero **and** the median lie within 10% of its bound to trigger exactly two additional complete runs, once per driver, deciding on all five. Differences remain `long/R-short` and `long-(2*short+25ms)`. No bound relaxation.
- Unchanged T12 S5 factor2 supplement, semantic/refusal and ordinary-history-scan gates, evidence retention, bookkeeping and **admission and storage only** labels; no capacity claim.

`base-precision1-t11-01` remains **loaded-invalid**: its post-observation exceeds 0.25 core. Its events establish endpoint/workload provenance only; its timings cannot satisfy performance acceptance or the required quiet base control.

No owner gate is triggered: this corrects an advisor-imposed literal endpoint interpretation without changing an owner decision, frozen contract, implementation scope or numeric performance bound. Record originator `assistant`; retain private evidence under D145.

No implementation, performance acceptance or ticket-close approval is granted. No additional run, test or confirmation review is requested.
