# Ticket139 S2 — Specification/correctness

**Verdict: approved.** GPT-6 Astra, temporary stand-in for advisor Claude Fable 5.1, reviewed `67d9636d6c70ba8cab2810bcec81c31a6c5df914` against `34090c3b634b9854904671c336db91c350e6328c`. Fable double-checks the whole ticket after reset.

**Findings: none.** No missing S2 implementation, unauthorized scope or incorrect behavior was identified against Ticket139, the amended ruling and frozen F3-139/D154.

Source review covers owner/current-origin precedence, global retry before CAS/source/population checks, immutable normalized-request binding, kind-scoped identities, exact immutable/unique addresses, declaration audience/source/consumer semantics, copied historical/pinned queries, actual receipts, cancellation, poisoning and Close. The shared validator/planner/install path is coherent; registration positives remain uncached. Grant independence and ledger-only reconstruction are preserved.

Key implementation evidence: `registration_commands.go:199–288`, `registration_replay.go:77–119`, `registration_state.go:34–181`, `registration_query.go:33–191`, and the registration arm in `replay.go:263–393` (all under `internal/core/agents/`).

**Original-binding mutant:** the raw failure reports `agents: command binding or digest mismatch`, not nil. [INFERENCE from source] Removing the original-request comparisons permits the self-consistent mutation through preflight; the later committed-receipt comparison rejects it. This is a postcommit fence, not preflight masking. `registration_replay_test.go:226–249` requires both preflight inconsistency and unchanged durability, checks the attack’s independent validity, and proves command reuse afterward. The failed log prints no durable counts; none are claimed.

Retained evidence includes passing focused regressions/seeds, whole-package plain/race, affected concurrency ×20, three independent restored-green mutants, and four completed 120-second fuzz campaigns. All 77 campaign-bound hashes remained unchanged.

**Remaining gates:** exact-SHA hosted `Check result` (run40810219344 was in progress per PM), primary-only integration/any retarget evidence, S3 real-process/torn-tail/cross-family acceptance and actual Service smoke, and Fable’s whole-ticket review. S3 evidence is not missing S2 product code.

**Owner gates:** none triggered; existing reserved gates remain. **Routine confirmation needed:** no. This verdict covers only this axis and immutable subject—not whole-ticket or main readiness.
