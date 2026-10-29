Report files could not be saved: this role exposes read-only tools. Complete contents follow for PM persistence in the supplied secondary directory.

### `t139-s2-spec-review.md`

```markdown
# Ticket139 S2 — Specification/correctness

**Verdict: approved.** GPT-6 Astra, temporary stand-in for advisor Claude Fable 5.1, reviewed `67d9636d6c70ba8cab2810bcec81c31a6c5df914` against `34090c3b634b9854904671c336db91c350e6328c`. Fable double-checks the whole ticket after reset.

**Findings: none.** No missing S2 implementation, unauthorized scope or incorrect behavior was identified against Ticket139, the amended ruling and frozen F3-139/D154.

Source review covers owner/current-origin precedence, global retry before CAS/source/population checks, immutable normalized-request binding, kind-scoped identities, exact immutable/unique addresses, declaration audience/source/consumer semantics, copied historical/pinned queries, actual receipts, cancellation, poisoning and Close. The shared validator/planner/install path is coherent; registration positives remain uncached. Grant independence and ledger-only reconstruction are preserved.

Key implementation evidence: `registration_commands.go:199–288`, `registration_replay.go:77–119`, `registration_state.go:34–181`, `registration_query.go:33–191`, and the registration arm in `replay.go:263–393` (all under `internal/core/agents/`).

**Original-binding mutant:** the raw failure reports `agents: command binding or digest mismatch`, not nil. [INFERENCE from source] Removing the original-request comparisons permits the self-consistent mutation through preflight; the later committed-receipt comparison rejects it. This is a postcommit fence, not preflight masking. `registration_replay_test.go:226–249` requires both preflight inconsistency and unchanged durability, checks the attack’s independent validity, and proves command reuse afterward. The failed log prints no durable counts; none are claimed.

Retained evidence includes passing focused regressions/seeds, whole-package plain/race, affected concurrency ×20, three independent restored-green mutants, and four completed 120-second fuzz campaigns. All 77 campaign-bound hashes remained unchanged.

**Remaining gates:** exact-SHA hosted `Check result` (run40810219344 was in progress per PM), primary-only integration/any retarget evidence, S3 real-process/torn-tail/cross-family acceptance and actual Service smoke, and Fable’s whole-ticket review. S3 evidence is not missing S2 product code.

**Owner gates:** none triggered; existing reserved gates remain. **Routine confirmation needed:** no. This verdict covers only this axis and immutable subject—not whole-ticket or main readiness.
```

### `t139-s2-spec-review.json`

{
  "status": "review-complete",
  "axis": "specification/correctness",
  "subjectSHA": "67d9636d6c70ba8cab2810bcec81c31a6c5df914",
  "baseSHA": "34090c3b634b9854904671c336db91c350e6328c",
  "verdict": "approved",
  "findings": [],
  "reviewLine": "GPT-6 Astra, temporary stand-in for advisor Claude Fable 5.1, approves Ticket139 S2 on the specification/correctness axis only. Fable double-checks the whole ticket after reset.",
  "evidenceReviewed": [
    {
      "kind": "requirements",
      "sources": [
        ".scratch/dwarf-harness/issues/139-register-shared-resources-and-work-domains-through-core.md",
        "C:/Users/darius.jones/.omp/agent/sessions/-documents-PROJECTS-dwarf-harness/2026-10-28T22-09-34-833Z_01a1848f-bc71-7725-b904-bf2e53c88c21/local/t139-design-assignment.md:9-19",
        "C:/Users/darius.jones/.omp/agent/sessions/-documents-PROJECTS-dwarf-harness/2026-10-28T22-09-34-833Z_01a1848f-bc71-7725-b904-bf2e53c88c21/local/t139-ruling.md",
        "C:/Users/darius.jones/.omp/agent/sessions/-documents-PROJECTS-dwarf-harness/2026-10-28T22-09-34-833Z_01a1848f-bc71-7725-b904-bf2e53c88c21/local/t139-s2-assignment.md",
        "contract/ledger/doc.go:2560-2764",
        "contract/ledger/doc.go:F3-10/F3-11 identity, replay and external-resource rules",
        "docs/CONTRACTS.md:F3-10/F3-11/F3-139",
        "docs/DECISIONS.md:B32/D142/D125/D152/D153/D154",
        "docs/DESIGN-CORE-AND-LAUNCHERS.md:13.1/13.5/13.10",
        "docs/DESIGN-UNDERCURRENT.md:8.2-8.3",
        "docs/ROADMAP-CORE.md:principles/C3",
        "docs/ROADMAPS.md",
        "AGENTS.md",
        "docs/agents/issue-tracker.md",
        "docs/agents/domain.md"
      ]
    },
    {
      "kind": "immutable-source",
      "worktree": "C:/Users/darius.jones/worktrees/dwarf-harness/139-registration",
      "coverage": "Eight registration implementation/test files and targeted integrating sections in all nineteen other changed files; existing origin, query, normalization and historical-task helpers.",
      "bindingProof": "C:/Users/darius.jones/.omp/agent/sessions/-documents-PROJECTS-dwarf-harness/2026-10-28T22-09-34-833Z_01a1848f-bc71-7725-b904-bf2e53c88c21/local/t139-s2-commit-proof.json",
      "delegatedGuardDiff": "C:/Users/darius.jones/.omp/agent/sessions/-documents-PROJECTS-dwarf-harness/2026-10-28T22-09-34-833Z_01a1848f-bc71-7725-b904-bf2e53c88c21/local/t139-s2-history-guard.diff"
    },
    {
      "kind": "retained-local-proof",
      "root": "C:/Users/darius.jones/worktrees/dwarf-harness/t139-s2-evidence/run-20261029T023939070Z-19044",
      "files": [
        "summary.json",
        "03-focused-and-seeds.stdout.log",
        "05-agents-plain.stdout.log",
        "08-agents-race.stdout.log",
        "09-affected-race-x20.stdout.log",
        "rule-breaks.json",
        "04a-owner-entrance-red.stdout.log",
        "04b-original-binding.patch",
        "04b-original-binding.mutant.go",
        "04b-original-binding-red.json",
        "04b-original-binding-red.stdout.log",
        "04b-original-binding-restored-green.stdout.log",
        "04c-postcommit-cancellation.patch",
        "04c-postcommit-cancellation-red.stdout.log",
        "accepted-registration-seeds.json",
        "baseline-comparison.json"
      ],
      "assessment": "Behavioral regressions cover authority, identities, CAS, limits, declarations, copied history, frozen prefixes, grant independence, retry, cancellation, poisoning and Close. Accepted resource/domain/declaration fuzz seeds reach real-store Submit, Core Open, typed snapshots and durable receipt assertions."
    },
    {
      "kind": "original-binding-mutant",
      "observedFailure": "self-consistent mutation escaped original request: agents: command binding or digest mismatch",
      "assessment": "[INFERENCE from source] The mismatch is reached after Submit and committed readback, not from an independent preflight guard masking the mutation. The permanent assertion requires ErrInconsistent and unchanged durability; its restored-green execution also validates the altered group independently and proves rejected input consumes no command/entity identity.",
      "durableCountsObserved": false
    },
    {
      "kind": "immutable-PM-fuzz",
      "path": "C:/Users/darius.jones/.omp/agent/sessions/-documents-PROJECTS-dwarf-harness/2026-10-28T22-09-34-833Z_01a1848f-bc71-7725-b904-bf2e53c88c21/local/t139-s2-fuzz-result.json",
      "result": "Four serial 120-second campaigns, parallel=1; all exit 0, no timeout or failure-corpus lines.",
      "executions": {
        "Registration": 7156,
        "Scoped": 17030,
        "Review": 28640,
        "Paid": 43599
      },
      "boundHashCount": 77,
      "hashesUnchanged": true
    }
  ],
  "remainingExternalGates": [
    "D153 successful hosted Check result on the exact final SHA; Check9/run40810219344 attempt1 was in progress in the latest PM report.",
    "Primary-only integration and any Ticket140 retarget; approval does not transfer automatically to changed source.",
    "S3 real-process interrupted/torn-tail recovery, cross-family acceptance, actual public-Service smoke and ticket-close evidence.",
    "Fable whole-ticket double-check after reset."
  ],
  "ownerGates": {
    "triggered": [],
    "preserved": [
      "D52 promotion/admission beyond testing-only scope",
      "Breaking frozen-contract changes",
      "New dependencies or other owner-reserved decisions",
      "Live credentials, provider invocation or spending"
    ]
  },
  "confirmationNeeded": false,
  "reviewerExecution": "Read-only inspection; no builds, tests, formatters, fuzz runs, measurements, source edits, Git writes or subagents.",
  "artifactDelivery": {
    "written": false,
    "reason": "Reviewer tools are read-only; complete report contents returned for PM persistence.",
    "markdownPath": "C:/Users/darius.jones/.omp/agent/sessions/-documents-PROJECTS-dwarf-harness/2026-10-28T22-09-34-833Z_01a1848f-bc71-7725-b904-bf2e53c88c21/local/t139-s2-spec-review.md",
    "jsonPath": "C:/Users/darius.jones/.omp/agent/sessions/-documents-PROJECTS-dwarf-harness/2026-10-28T22-09-34-833Z_01a1848f-bc71-7725-b904-bf2e53c88c21/local/t139-s2-spec-review.json"
  }
}