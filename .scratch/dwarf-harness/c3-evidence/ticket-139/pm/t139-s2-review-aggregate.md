# Ticket139 S2 independent two-axis review

Subject67d9636d6c70ba8cab2810bcec81c31a6c5df914; fixed base34090c3b634b9854904671c336db91c350e6328c. Actual Astra/max/no-fallback routing is retained separately. Reports below are preserved verbatim; neither axis masks or reranks the other.

## Standards

# Ticket139 S2 — Standards/maintainability

**Verdict: approved.**

Subject: `67d9636d6c70ba8cab2810bcec81c31a6c5df914`  
Base: `34090c3b634b9854904671c336db91c350e6328c`

**Review line:** Temporary GPT-6 Astra stand-in reviewer performed this independent standards review. Fable remains the advisor and double-checks the whole ticket after reset.

## Hard breaches

None found against AGENTS.md, current coder-context B26/B28/D152/D153, roadmap principles, domain/tracker conventions, or the ruled family structure. No blocking test-contract issue found.

## Judgement calls

No actionable findings across all twelve smell heuristics. Explicit family switches and mechanical fifth-result migrations follow existing conventions and ruling §7; replacing them with a registry would add unjustified machinery.

The shared planner, isolated query values, existing locking conventions, and bounded cache exclusion remain understandable without new abstractions.

## Tests and evidence

Reviewed all eight registration files, targeted sections across the other nineteen changed paths, the exact history-index guard diff, and immutable commit/hash proof.

Permanent tests exercise real-store authority, CAS, identity, history, retry, corruption and cancellation contracts—not wiring or wording.

The original-binding mutant returned **ErrCommandMismatch**, not nil. **[INFERENCE from source trace]** it reached postcommit receipt matching, not an independent preflight rejection (`registration_commands.go:264–279`). The restored assertion requires both ErrInconsistent and unchanged durability (`registration_replay_test.go:227–228`), genuinely defending no-append. The red log prints no durable count.

Reviewed all three independent mutation patches, red assertions, identical-restoration proofs and green logs; focused/seeds, whole-package plain/race, five-row race×20, static/import/module evidence, and unchanged frozen fixtures. Accepted fuzz seeds reach real Submit→Open→typed snapshot/receipt assertions.

All four immutable 120-second PM fuzz campaigns passed; source/module/frozen hashes remained bound.

## Remaining gates

- D153 hosted Check9/run **40810219344**, attempt 1: in progress per PM, not yet successful.
- Primary-owned integration/new-SHA evidence; approval does not transfer automatically.
- S3 process/torn-tail/cross-family/Service-smoke evidence and ticket-close review remain separate.
- Fable’s whole-ticket double-check after reset.

**Owner gates:** none newly triggered; D52 testing-only restrictions remain.  
**Confirmation needed:** no routine confirmation pass. No spec-axis verdict or whole-ticket/main readiness is implied.

## Spec

# Ticket139 S2 — Specification/correctness

**Verdict: approved.** GPT-6 Astra, temporary stand-in for advisor Claude Fable 5.1, reviewed `67d9636d6c70ba8cab2810bcec81c31a6c5df914` against `34090c3b634b9854904671c336db91c350e6328c`. Fable double-checks the whole ticket after reset.

**Findings: none.** No missing S2 implementation, unauthorized scope or incorrect behavior was identified against Ticket139, the amended ruling and frozen F3-139/D154.

Source review covers owner/current-origin precedence, global retry before CAS/source/population checks, immutable normalized-request binding, kind-scoped identities, exact immutable/unique addresses, declaration audience/source/consumer semantics, copied historical/pinned queries, actual receipts, cancellation, poisoning and Close. The shared validator/planner/install path is coherent; registration positives remain uncached. Grant independence and ledger-only reconstruction are preserved.

Key implementation evidence: `registration_commands.go:199–288`, `registration_replay.go:77–119`, `registration_state.go:34–181`, `registration_query.go:33–191`, and the registration arm in `replay.go:263–393` (all under `internal/core/agents/`).

**Original-binding mutant:** the raw failure reports `agents: command binding or digest mismatch`, not nil. [INFERENCE from source] Removing the original-request comparisons permits the self-consistent mutation through preflight; the later committed-receipt comparison rejects it. This is a postcommit fence, not preflight masking. `registration_replay_test.go:226–249` requires both preflight inconsistency and unchanged durability, checks the attack’s independent validity, and proves command reuse afterward. The failed log prints no durable counts; none are claimed.

Retained evidence includes passing focused regressions/seeds, whole-package plain/race, affected concurrency ×20, three independent restored-green mutants, and four completed 120-second fuzz campaigns. All 77 campaign-bound hashes remained unchanged.

**Remaining gates:** exact-SHA hosted `Check result` (run40810219344 was in progress per PM), primary-only integration/any retarget evidence, S3 real-process/torn-tail/cross-family acceptance and actual Service smoke, and Fable’s whole-ticket review. S3 evidence is not missing S2 product code.

**Owner gates:** none triggered; existing reserved gates remain. **Routine confirmation needed:** no. This verdict covers only this axis and immutable subject—not whole-ticket or main readiness.

Standards:0 findings, worst:none. Spec:0 findings, worst:none. Both axes approved this immutable subject; exact-SHA hosted success/primary integration, S3 and later Fable verification remain explicit external gates.
