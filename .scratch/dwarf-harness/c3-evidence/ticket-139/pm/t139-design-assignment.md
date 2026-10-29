# Ticket 139 design assignment

## Goal and output

Draft the implementation design brief for Ticket139, **Register shared resources and work domains through Core**, to `local://t139-brief.md`. Write an outline early, then fill it by surgical edits. Owner summary first; repository-relative citations throughout. This is design only: no repository edit, Git access, build, tests, formatter or measurement. A fresh temporary Astra advisor will rule on it; the ruling governs. Readers are available for bounded supplements through the PM, not a general source map.

Base checked by PM: `93e8f0afe125b1ea8e87f4b8336664dd390c5b3a` on main. Read code from main checkout `C:/Users/darius.jones/Documents/PROJECTS/dwarf-harness`. Eventual isolated worktree is `C:/Users/darius.jones/worktrees/dwarf-harness/139-registration`, branch `build/139-registration`; not created yet while primary coordinates local work. Do not inspect Git/worktree state. Runtime remains testing-only under D52. Ticket11 is resolved; F3-10, F3-11, F3-12 and F3-13 are frozen. No provider work is in scope.

## Required scope (all must be designed)

- Owner-only typed Core transitions for registration/revision of shared resources and work domains. Bind authenticated/derived actor, operation, target and complete normalized request; expected-version CAS; durable atomic complete group ending in receipt before acknowledgement. Agent cannot register/revise/widen even through a forged group or alternate bound-agent call.
- Registered resource is addressable by existing F3-11 Resource kind/key, with opaque non-secret identity, never URL/account/credential. Preserve historical valid F3-11 grants; registration is evidence, not a new permission or prerequisite added to historical operations. Settle exactly which grant-addressable resource kinds are registrations and how stable identity relates to typed resource reference without weakening opaque identity.
- Scoped versioned registration and scoped versioned declarations linking resources or work domains to tasks or contexts. Preserve superseded history and reconstruction at every cursor. Settle identifier reuse, version increments/overflow, existing-target checks, binding/assignment semantics and whether explicit retirement/deactivation is necessary for the actual ticket. Avoid inventing lifecycle functions the sources do not require.
- Complete additive producer family: exact types/version, nested values, field ordering, decoder rules/unknown-field behavior, open vs closed tokens, schema-N canonical request bytes/digest, group shapes/actors/bindings, caller/consumers/privacy/replay facts and golden with every shape a Ticket61 consumer requires. Contract frozen under D125 before producer emission. Old types, encodings, rules, goldens and schema1–4 unchanged.
- Ledger-only restart with no append or automatic execution. Same-command same-submission retry returns original actual receipt; changed submission refuses before CAS/state changes. Global command-ID mismatch across families, committed-vs-uncommitted crash boundaries, poison/unknown submission result and exactly-once acknowledgement behavior must fit existing service/store patterns.
- Query/projection boundary needed to prove current and historical registration/declaration evidence through actual Core, without a view, raw unfiltered agent ledger access or second authority store. Registration grants no access.
- Exact permanent regression tests justified by plausible authority/privacy/CAS/identity/history/recovery bugs; real store and service, no mock echo or source assertions. Reuse golden/recovery helpers and test fixture conventions.

Non-goals: graph nodes/edges, resource-use/action facts (Ticket15), provider functionality, terminal/C7/GUI, new modules/dependencies, breaking frozen contracts, authority expansion, generic registries/frameworks, new cache/snapshot/database. Owner-reserved decisions must be listed as conditional gates, never silently decided.

## Design shape

Provide numbered P-choices for unresolved technical choices, options/recommendation/reason and precise sources; distinguish settled requirements from proposals. Cover API, records, reducer/preflight/replay, current/historical lookup, privacy and allowed disclosure, failure/retry/close, payload/live-state bounds (limits vs frozen structure), realistic storage/replay cost argument without invented timing SLA or benchmark work. Choose two to four real implementation slices. Prefer a contract-first slice then Core producer/replay, with a final evidence/regression slice only if it owns genuine independent changes; do not pad or split for ceremony. Contract slice/freeze must precede any producer. Slice table gives exact owned paths/interfaces/dependencies, changed packages, D152 concurrency/five-target/rule-break conditions, fuzz targets and acceptance-to-proof map. Freeze record and public final SHA use D153 hosted CI, not old local full-gate/amend recipes.

## Shared Ticket140 boundary (mandatory)

Primary PM owns Ticket140 active in a separate branch and final main integration/decision numbering. Secondary PM cannot move or push main. Ticket140 is changing replay.go, scoped_state historical lookups, integrity, source/witness lookups and whole-commit publication. Its ruled design uses ONE bounded concrete historical metadata cache (256 entries/8MiB), targeted invalidation, no second reducer or generic seal architecture. Both refreshLocked and direct review publication need coherence. NO competing cache or changes to140branch. Prefer new family-owned files plus minimal explicit service/projection/dispatch hook edits, named in a collision matrix for primary integration. Do not prescribe wholesale rewrites of shared helpers. T139's new command groups must work with global command lookup, not evade it. Contract/ledger path is not T140-owned.

Primary ruling context if needed: `C:/Users/darius.jones/.omp/agent/sessions/-Documents-PROJECTS-dwarf-harness/2026-10-24T15-58-31-752Z_01a16ea2-9748-77b3-ac90-a8beabd7bc22/local/t140-ruling.md`, sections1–3 and slice ownership. Read only targeted portions; do not adopt its measurement requirements for139.

## Source list, read ranges/sections only

Private records are TEAM-READABLE in main under D145; unpublished, never copied to public commits. The injected 'not accessible' memory means not publicly accessible.

1. `.scratch/dwarf-harness/issues/139-register-shared-resources-and-work-domains-through-core.md` (all criteria); `docs/agents/issue-tracker.md`, `docs/agents/domain.md`; `GLOSSARY.md`; `docs/ROADMAPS.md` working rules223–236 and C3/U3 board.
2. `docs/ROADMAP-CORE.md` working principles1–20, C3 418–517. `docs/DESIGN-CORE-AND-LAUNCHERS.md` §§13.1 (849–864),13.5 (916–931),13.10(1012–1019).
3. `docs/DESIGN-UNDERCURRENT.md` §§8.2–8.3 (171–194); `docs/ROADMAP-UNDERCURRENT.md` U3 262–310, Q1 and non-code nodes. Ticket61 `.scratch/dwarf-harness/issues/61-turn-bounded-artifact-and-usage-evidence-into-atomic-causal-graphs.md`, resource/declaration criterion only. No graph build.
4. `docs/CONTRACTS.md` register, producer freeze rules, F3-10/F3-11 catalogues108–130; later families to preserve shared task/turn support.
5. `docs/DECISIONS.md` ONLY named entry ranges, locate headers if shifted: B32(2658–2707), D142(2709–2728), D125(2134–2148), D139(2543–2567), D140(2624–2656), D152/D153(3024–end), B3(672–680), D29/D40/D41/D117 and amendments as necessary. Never read whole log.
6. `contract/ledger/doc.go` F3-10 (1557–1717), F3-11(1718–2063), F3-12 shared task reading, F3-13 shared unit/child reading. Existing codec/golden conventions in scoped_values.go, scoped_submission.go, scoped_authority.go and scoped_golden_test.go; grep actual filenames if needed rather than guessing unknown ones. Preserve earlier goldens.
7. Code extension points mapped by PM: `internal/core/agents/service.go` projection/newProjection/Service/Open; `replay.go` readCommits, refreshLocked, planGroup, findCommand; `scoped_commands.go` owner vs Agent entrances/executeScoped; `scoped_execute.go`, `scoped_submit.go`, `scoped_replay.go`, `scoped_state.go`; later-family precedent `review_*.go` or `paid_replay.go` only when directly needed. New family should follow one existing convention, not invent a parallel one.
8. Private precedent `.scratch/dwarf-harness/c3-evidence/ticket-11-design-ruling.md` selected source/registration assignment and receipt/replay choices; ticket12 later-family separation if needed. Need no verbatim source map.

## Standing constraints to carry

Go1.27.3, GOTOOLCHAIN=local, GOFLAGS empty, explicit CGO_ENABLED=0 for Core/contract. No new nonstandard imports; agents already legitimately imports Core credentials/providers fromT13, unlike olderT10 narrow digest. Standard lib only in contract. D152 focused tests + one verbose changed-package run, host gofmt/vet/staticcheck; whole-package race and affected×20 race only for shared-state/concurrency changes; five-target static only build-constraint changes. Rule breaks only authority/disclosure/credentials/crash/sandbox/money, red then byte-identical restore green. PM timed fuzz120s per new/changed fuzzed target; no routine local full check. No overlapping local runs; primary PM assigns slots, measurement holds may prohibit all edits/diagnostics. D153 final-SHA hosted full matrix +Check result; public/private records splitD145. Fresh coders/reviewers; stand-in Astra while Fable held, whole-ticket Fable verification retained.

## Yield

`{status, briefPath, choices, slices, proposedTypes, sharedFileCollisions, conditionalOwnerGates, unresolvedQuestions, notesForRuling}`. Finish the complete brief, not a summary-only yield. Do not freeze or claim implementation/evidence.
