# Tickets 139 and 140 and the dependency audit: edit file

Every find is copied from `main` d12f605 in the main checkout. Ticket paths in the audit are under `.scratch/dwarf-harness/issues/`.

## Owner summary

New tickets (C3 tasks, ready for an agent, published 2026-10-24):
- **139: Register shared resources and work domains through Core.** Blocked by 11 (resolved). Core records the resources your grants name and your work domains, the family B32 gave to C3, so ticket 61's graph can show them and link them to the work that uses them. Only you register or revise them, as with your root grants; an agent cannot. The ticket also records your declared assignments of a resource or domain to a task or context, which Undercurrent §8.2 lists beside host-observed use as a source of 61's usage links. A registration grants no access.
- **140: Bound the private-state service's replay and lookup cost.** Blocked by 11 (resolved). Removes the whole-history scans ticket 11's S4 measured (opening the service: 1.4 s, then 76 s for ten times the history; each operation 4.5 to 9.4 times slower), with a rebuildable index or a narrower turn-start check, as its ruled design chooses, before ticket 15 puts turn start and local work into use.

Existing tickets that change:
- **15**: blockers 14 become 14, 140. Ticket 11's review asked for the cost fix before 15.
- **61**: blockers 07, 09, 11, 15, 17 become 07, 09, 11, 15, 17, 139. Its resource and work-domain nodes and usage wait for 139's records.
- **59**: blockers 04, 07, 08, 09, 17, 61 become 04, 07, 08, 09, 17. It listed 61 only for the graph records, frozen since D130; keeping 61 would make it wait for 139. It still waits for 17.
- **16**: a cross-link comment only. Its restart proof exercises what 140 speeds up; 140 already reaches it through 15.
- **62**: a cross-link comment only. Its co-access hints count use of registered resources; 139 already reaches it through 61.
- **11**: a cross-link comment only. Its comments sent both items to you; it now names 139 and 140.
- Knock-on: the tickets after 15 (16, 17, 59 and on) now also wait for 140, and those after 61 (62 and on) for 139.
- Checked and unchanged: 12, 13, 30, 55, 73, 74, 83, 84, 89, 91, 97, 100 and 113 (reasons in the audit).

Order: 12, then 13, as you said; the tracker's frontier already picks them first. 140 lands before 15 by its blocker.

Other documents:
- `docs/DECISIONS.md`: a new entry, D142 (your words, both tickets, the three blocker changes), and a one-line pointer under B32.
- U3's status text, on the status board and in the Undercurrent roadmap: "wait for producer freezes: tickets 15, 17, 139" (11 dropped as resolved). U3 stays In progress.
- U1's Status line in the Undercurrent roadmap: U1.E is blocked, through ticket 59, only on ticket 17's producer freeze; the other four are frozen. U1 stays In progress.

Publishing freezes nothing, approves nothing and changes no step's status.

## Audit

### Open tickets the search found

| Ticket | `path:line` | What it says | Disposition | Reason |
|---|---|---|---|---|
| 12 | `12-accept-only-exact-subject-review-and-failure-results.md:8,51` | Blocked by 11; its 2026-10-24 comment: 11 is resolved, subject kinds come by addition | No change | Its criteria (lines 29–31) bind review and failure results to F3-11's tasks; they consume no registration and do not depend on the service's cost. It stays first in the owner's order. |
| 13 | `13-dispatch-and-settle-a-sealed-static-anthropic-text-attempt-through-core.md:8,31,62` | Blocked by 11; no general turn/tool loop (line 31); its comment: a turn admission executes nothing and has no production caller | No change | Its criteria (lines 35–40) are the paid path. It makes no turn start or local work a production path (that is ticket 15, `DECISIONS.md:2663`) and consumes no registration. |
| 15 | `15-run-bounded-context-bound-model-and-tool-turns.md:8,32,36` | Blocked by 14; every tool/model operation receives current authority/admission (line 32); latency measured under the declared workload (line 36) | New blocker 140 | Confirmed. AdvisorT11S4's ruling 4 (`t11-s4-verdict.md:35`) and B32's Limits (`DECISIONS.md:2664`): the fix lands "before ticket 15 makes StartTurn, AdmitLocal and BeginLocal production paths". Line 32 makes every turn start and local admission a production call, and line 36's latency would carry the scans [INFERENCE]. |
| 16 | `16-prove-concurrent-private-runtime-restart-and-child-shutdown.md:8,32,33` | Blocked by 12, 15; declared runtime resource profiles (line 32); restart reconstructs waits (line 33) | Cross-link comment (140) | Its restart proof opens the service, and its runtime profiles include turn start and admission, which 140 bounds. No criterion needs 140's result directly, and 140 already reaches it through 15. |
| 59 | `59-replay-record-only-facts-into-exact-source-lifecycles.md:8,28-32,53` | Blocked by 04, 07, 08, 09, 17, 61; its 2026-10-13 comment (line 53) lists 61 only for the graph-delta family, one of the five producer freezes its gate ruling requires | Blocker removed: 61 (`Blocked by: 04, 07, 08, 09, 17`) | The PM's ruling on this audit's open question. That family is F-U3-61, frozen by D130 (`DECISIONS.md:2275`), and later node and edge kinds join it by addition (`contract/ledger/doc.go:1354-1357`). Keeping 61 would make 59 wait for 61's remaining criteria and, through them, for 139. It still waits for 17, the validation-evidence freeze, and through 17 for 140. No criterion (lines 28–32) consumes a registration or the service's cost. |
| 61 | `61-turn-bounded-artifact-and-usage-evidence-into-atomic-causal-graphs.md:8,29,31,93` | Blocked by 07, 09, 11, 15, 17; registered resources and owner work domains as nodes (line 29); registered resource-to-consumer usage (line 31); its comment: these wait for the family | New blocker 139 | Confirmed. Lines 29 and 31 cannot be met without 139's records: B32 item 4 (`DECISIONS.md:2657`) and the comment at line 93 say so. |
| 62 | `62-expose-bounded-authorized-co-access-encounters-without-propagation.md:8,22,28` | Blocked by 61; host-observed same-task-context use forms encounter hints (line 28); frozen host-use, task-provenance and grant fields (line 22) | Cross-link comment (139) | Undercurrent §8.2 admits co-access only from "host-observed use of two registered resources by one task context" (`DESIGN-UNDERCURRENT.md:178,182`), so line 28 builds on 139. 139 already reaches it through 61, as 11 and 15, whose fields line 22 names, do without being listed. |
| 73 | `73-transform-typed-resource-observations-without-owning-money-or-sources.md:8,32` | Blocked by 04, 41, 62; transforms consume U3-registered nodes and usage links | No change | It reads U3's nodes and links (tickets 61 and 62), not C3's records; 139 reaches it through 62 and 61. |
| 74 | `74-maintain-scoped-resource-and-availability-fields-through-real-ledger-changes.md:8,28,29` | Blocked by 60, 73; the authorized resource-to-consumer topology; resource removal | No change | Its topology is U3's; 139 reaches it through 73. |
| 83 | `83-exchange-bounded-authorized-projections-between-independent-sovereign-cores.md:22,31` | Bilateral domain grants; pressure crosses only for an explicitly shared resource | No change | Sharing between sovereign Cores is a federation grant (its gate, line 22), not a C3 registration [INFERENCE]; no criterion reads 139's records. |
| 84 | `84-run-the-frozen-blinded-baseline-and-determine-study-feasibility.md:29` | Interference components from shared resources; domain strata | No change | Study clusters come from actual colony facts, and its domain strata are preregistered study strata (`spec.md:533`), not owner work domains. |
| 89 | `89-report-waiting-ready-waiting-blocked-and-active-task-facts.md:8,29,31` | Blocked by 12; task facts across restart (line 29); bounded, paginated results without rescanning history (line 31) | No change | Its own line 31 already requires a bounded query that does not rescan history, so it needs no result of 140; 140's index serves the existing operations [INFERENCE]. |
| 91 | `91-record-service-loss-and-restoration-for-every-agent.md:34` | Private state failing its restart integrity check counts as service loss | No change | It consumes that check's failures, which 140's third criterion keeps unchanged. |
| 97, 100 | `97-run-pinned-grill-with-docs-as-a-first-action-with-durable-human-question-waits.md:12,28`; `100-align-every-new-orchestrator-and-griot-before-ordinary-work.md:28` | The work or values domain of a pinned alignment run | No change | This is a new leader's alignment domain (`spec.md:411`), not an owner-registered work domain [INFERENCE]. |
| 30 | `30-start-or-attach-to-one-authenticated-detached-colony-host.md:8,29` | Blocked by 16; the host's booting, recovering and ready states | No change | Host start opens the service, but no criterion bounds its time; 140 reaches it through 16 and 15. |
| 55, 113 | `55-inspect-authorized-operations-and-mutate-a-task-through-the-real-core.md:29`; `113-open-rpg-agent-and-corps-party-sheets-with-real-scoped-statistics.md:34` | Grant/approval and budget-book resource views; drill-down to resource panels | No change | These are F3-11's budget-book resources, not registrations. No C7 or GUI-F ticket shows registered resources or work domains, so the producer-first rule needs no new edge. |

### Dependency check after the change

Edge changes, written blocker → blocked ticket:
- added: 11 → 139 and 11 → 140 (the new tickets);
- added: 140 → 15 (`Blocked by: 14, 140`);
- added: 139 → 61 (`Blocked by: 07, 09, 11, 15, 17, 139`);
- removed: 61 → 59 (`Blocked by: 04, 07, 08, 09, 17`).

The graph from the assignment then reads: 11 blocks 12, 13, 61, 139 and 140; 14 and 140 block 15; 15 blocks 16 and 61; 17 blocks 18, 19, 20, 59 and 61; 139 blocks 61; 61 blocks 62; 62 blocks 63 and 73.

Ancestor closure over every `Blocked by` line touched:
- 11: 01, 02, 03, 05, 06, 07, 08, 09, 10.
- 139 and 140: 11 and its ancestors.
- 15: 13, 14, 140, and 11 with its ancestors.
- 61: 04, 12, 13, 14, 15, 16, 17, 139, 140, and 11 with its ancestors.
- 59: 04, 12, 13, 14, 15, 16, 17, 140, and 11 with its ancestors; no longer 61 or 139.

The d12f605 graph is acyclic (the PM's script). Removing an edge cannot close a cycle, so any new cycle must use an added edge u → v and needs v among u's ancestors. 139 and 140 are not ancestors of 11, 15 is not an ancestor of 140, and 61 is not an ancestor of 139. No ticket is its own ancestor. Two blockers are numbered higher than the tickets they block (140 on 15, 139 on 61); the tracker requires only that every listed ticket be resolved (`docs/agents/issue-tracker.md:23`), and the skill now permits it.

Open and unblocked after the change: 12, 13, 47 and 49 (deferred, D138), 139 and 140. Claimed: 137.

## Edits

#### E1 — .scratch/dwarf-harness/issues/139-register-shared-resources-and-work-domains-through-core.md
Creates ticket 139.

Find:
````
````

Replace:
````
# 139: Register shared resources and work domains through Core

Status: ready-for-agent
Type: task
Published: 2026-10-24
Spec: [DwarfHarness system specification](../spec.md)
Roadmap capability: C3 registered shared resources and owner-registered work domains (B32)
Blocked by: 11

## What to build

Let the owner register the colony's shared resources and work domains in Core, so that the coupling graph can show them as nodes and link them to the work that uses them. [B32](../../../docs/DECISIONS.md#b32-c3-scoped-grants-and-atomic-task-ownership-ticket-11), item 4, assigned this family to C3: registered shared resources are the resources F3-11's grants name, and work domains are the owner's, registered like his root grants and capacity limits, with Core as the registrar. Ticket [61](61-turn-bounded-artifact-and-usage-evidence-into-atomic-causal-graphs.md)'s resource and work-domain nodes and its positive resource-to-consumer usage wait for these records. Undercurrent §§8.2–8.3 set their rules: a resource identity is an opaque host registration, never a secret-bearing URL or account name, and a declaration is scoped and versioned, never a permission.

## Start and authority gates

Publication and triage do not grant D52 approval, freeze a contract, advance roadmap status, or establish runtime, isolation, accessibility, capacity or usefulness evidence. Use the current roadmap gates and producer-owned specifications through the parent specification’s canonical reading map.

Respect the current status of all six contracts. Their owners may draft and build their own boundary as the roadmap permits; consumers and later producer families wait for the specifically required owner freezes. C1 completes with its F0 freeze request, not an assumed approval. No placeholder records, permissive substitutes, second authority stores or new contract boundaries are authorized.

Harness workloads remain testing-only until every C4 end-to-end, adversarial and declared-workload gate passes. Later containment, per-kind release and study approvals remain independent gates.

- Consumes the frozen F3-10 and F3-11 families ([D139](../../../docs/DECISIONS.md#d139-f3-10-private-state-records-frozen), [D140](../../../docs/DECISIONS.md#d140-f3-11-scoped-authority-task-and-non-paid-work-records-frozen)) and changes them only by addition (D40).
- A ruled design settles the family's records, commands and slices before code (D117). Once the build advisor approves the contract slice with its freeze record, the project manager freezes the family under [D125](../../../docs/DECISIONS.md#d125-completed-contract-slices-are-frozen-without-the-owners-approval); only a breaking change to a frozen contract (D40), a D52 approval, a new dependency (D29) or another change that touches an owner decision (D41) waits for the owner.
- D112 approved the D52 boundary before C3 implementation; registrations serve test agents only, and nothing here admits colony work (D52).
- The ticket's code reaches the three-OS CI (D133) with its one push after its close (D141); no provider credentials are needed.

## Scope boundaries

- C3's producer and records only. Graph nodes, edges and usage are ticket 61's, and host-bound actual use comes from ticket [15](15-run-bounded-context-bound-model-and-tool-turns.md)'s action facts.
- A registration is not a grant: F3-11's grants still decide every access.
- No terminal, C7 or GUI view; a view of registrations needs its own ticket after this producer.

## Acceptance criteria

- [ ] The owner registers and revises shared resources and work domains through producer-owned typed Core transitions that bind actor, operation and target, check the expected version and current authority, and commit one replay-complete group ending in its receipt before acknowledging; an agent cannot register, revise or widen a registration.
- [ ] A registered shared resource is one that F3-11's grants can name, by resource kind and key. Each registration's identity is opaque and non-secret, never a URL, account name or credential.
- [ ] A registration, and any declaration linking one to a task or context, is scoped and versioned: a revision supersedes the earlier version without rewriting history, and replay at any cursor sees the version then current. A registration or declaration is evidence for the graph, never a permission.
- [ ] The family is specified with its real payloads, permitted caller, consumers, privacy and replay-essential fields and a golden sample, and is frozen by addition to the ledger format before its producer writes it; F3-10's and F3-11's records, rules and goldens are unchanged.
- [ ] At restart the service rebuilds every registration from the ledger alone and appends nothing; a crash before or after the commit leaves only committed registrations, and a same-command retry returns the original receipt.
- [ ] Ticket 61 can build its resource and work-domain nodes from the frozen records without stand-in data: the golden holds every registration and declaration shape a node or declared edge needs.

## Verification boundary

Exercise the actual consumer-visible boundary and effects named above. Preserve deterministic regressions for plausible permission, amount, ordering, identity, recovery and evidence failures. Mocks, source-text assertions, historical design experiments and passing builds do not establish runtime, native-platform, isolation or empirical acceptance.

## Specification coverage

- User stories: 27, 86.
- Implementation decisions: 1, 2, 3, 4, 11, 38.
- Testing decisions: 1, 2, 4, 17, 20.

Canonical sections (resolved through the parent specification’s reading map):
- Core roadmap C3
- Undercurrent design §§8.2–8.3
- Undercurrent roadmap U3 node definitions, Q1 and non-code nodes
- Decision log B32/D40/D125/D140

## Comments

2026-10-24 — Published at the owner's word, "5. The family ticket should be its own ticket: 139", and his approval of the breakdown: "«OWNER-APPROVAL»" ([D142](../../../docs/DECISIONS.md#d142-tickets-139-and-140-published-with-three-blocker-changes)). This adopts the ticket for local publication only; it does not grant any separate implementation, contract-freeze, release or study approval.
````

#### E2 — .scratch/dwarf-harness/issues/140-bound-the-private-state-services-replay-and-lookup-cost.md
Creates ticket 140.

Find:
````
````

Replace:
````
# 140: Bound the private-state service's replay and lookup cost

Status: ready-for-agent
Type: task
Published: 2026-10-24
Spec: [DwarfHarness system specification](../spec.md)
Roadmap capability: C3 private-state service replay and lookup cost (B3, B32)
Blocked by: 11

## What to build

Keep Core's private-state service quick to open and to use as its history grows. Ticket 11's labelled profile ([evidence](../c3-evidence/ticket-11-evidence.md#the-p16-smoke-and-the-s3b-7-profile)) found that opening the service took 1.42 s at 87 commits and 75.8 s at 874, while the ledger store's own opening took 19 ms and 166 ms, and that a turn start, a local admission, a local dispatch, a task creation and a task cancel each took 4.5 to 9.4 times as long for ten times the history. The cost is whole-ledger scans: a task lookup that misses on a work context no task has bound, a task derived twice per phase, and the integrity scans at every turn start. [B31](../../../docs/DECISIONS.md#b31-c3-the-private-state-service-ticket-10)'s Limits record the same service's earlier scans, a private write's two whole-ledger scans and Open's two per clean scope, with a candidate fix; the design says whether the fix covers them. [B32](../../../docs/DECISIONS.md#b32-c3-scoped-grants-and-atomic-task-ownership-ticket-11)'s Limits record these figures as [B3](../../../docs/DECISIONS.md#b3-one-authoritative-durable-ledger-and-bounded-platform-storage)'s measured trigger for a rebuildable index or snapshot. Remove the scans before ticket [15](15-run-bounded-context-bound-model-and-tool-turns.md) makes turn start and local work production paths, without changing anything the service does.

## Start and authority gates

Publication and triage do not grant D52 approval, freeze a contract, advance roadmap status, or establish runtime, isolation, accessibility, capacity or usefulness evidence. Use the current roadmap gates and producer-owned specifications through the parent specification’s canonical reading map.

Respect the current status of all six contracts. Their owners may draft and build their own boundary as the roadmap permits; consumers and later producer families wait for the specifically required owner freezes. C1 completes with its F0 freeze request, not an assumed approval. No placeholder records, permissive substitutes, second authority stores or new contract boundaries are authorized.

Harness workloads remain testing-only until every C4 end-to-end, adversarial and declared-workload gate passes. Later containment, per-kind release and study approvals remain independent gates.

- Builds on the private-state service as ticket [11](11-enforce-scoped-grants-and-atomic-task-ownership.md) left it. Until ticket 15 gives turn start and local work a production caller, the cost is latent.
- Adds no record type, because B3's indexes and snapshots are rebuildable and discardable, never ledger authority, and changes no frozen record, rule or golden ([D139](../../../docs/DECISIONS.md#d139-f3-10-private-state-records-frozen), [D140](../../../docs/DECISIONS.md#d140-f3-11-scoped-authority-task-and-non-paid-work-records-frozen)). A new dependency would wait for the owner (D29).
- A ruled design chooses the fix before code (D117), and ticket 11's measurement driver, rerun, is its evidence.
- The ticket's code reaches the three-OS CI (D133) with its one push after its close (D141); no provider credentials are needed.

## Scope boundaries

- A cost fix inside the service: no new behaviour, command, record or contract.
- The rerun is labelled admission and storage only, as ticket 11's was. C3's runtime capacity evidence stays with ticket [16](16-prove-concurrent-private-runtime-restart-and-child-shutdown.md), and C4's workload gate with ticket [23](23-measure-every-change-delivery-under-steady-and-burst-load.md).

## Acceptance criteria

- [ ] A ruled design chooses the fix before code, from the candidates ticket 11's S4 review gave: a bounded index from work context to task and the turn-start integrity check narrowed to the current heads behind the projection fence; B3's fused startup pass or a snapshot only if those fail.
- [ ] Every index or snapshot the fix adds is rebuilt from the ledger alone and is discardable: deleting it, or finding it stale or corrupt, loses no committed state, appends nothing and dispatches nothing.
- [ ] Behaviour is unchanged: grants, busy and denied answers, task transitions, reads and restart recovery give the same results, both frozen goldens replay through the service, and ticket 11's injected crash rows pass unchanged; no record type, frozen rule or golden changes.
- [ ] Ticket 11's measurement driver, rerun unchanged on the same traffic at the same two log lengths, shows opening the service growing no faster than the ledger's length, as the store's own opening does, and turn start, local admission, local dispatch, task creation and task cancel each within the bound the design states. The output keeps its label, admission and storage only, and claims no capacity.

## Verification boundary

Exercise the actual consumer-visible boundary and effects named above. Preserve deterministic regressions for plausible permission, amount, ordering, identity, recovery and evidence failures. Mocks, source-text assertions, historical design experiments and passing builds do not establish runtime, native-platform, isolation or empirical acceptance.

## Specification coverage

- User stories: 26.
- Implementation decisions: 1, 2, 4, 10.
- Testing decisions: 1, 2, 4, 17, 18, 20.

Canonical sections (resolved through the parent specification’s reading map):
- Core roadmap C3
- Decision log B3/B32/D139/D140

## Comments

2026-10-24 — Published at the owner's word, "6. Publish this as ticket 140, then audit and update ticket dependancies and order", and his approval of the breakdown: "«OWNER-APPROVAL»" ([D142](../../../docs/DECISIONS.md#d142-tickets-139-and-140-published-with-three-blocker-changes)). This adopts the ticket for local publication only; it does not grant any separate implementation, contract-freeze, release or study approval.
````

#### E3 — .scratch/dwarf-harness/issues/15-run-bounded-context-bound-model-and-tool-turns.md
Adds ticket 140 to ticket 15's blockers.

Find:
````
Blocked by: 14
````

Replace:
````
Blocked by: 14, 140
````

#### E4 — .scratch/dwarf-harness/issues/15-run-bounded-context-bound-model-and-tool-turns.md
Appends ticket 15's D142 rework comment.

Find:
````
Criteria now cover the small stable tool surface, model-only argument normalization and the single continuation owner. Number and blockers are unchanged; this grants no separate implementation, contract-freeze or release approval.
````

Replace:
````
Criteria now cover the small stable tool surface, model-only argument normalization and the single continuation owner. Number and blockers are unchanged; this grants no separate implementation, contract-freeze or release approval.

2026-10-24 — [D142](../../../docs/DECISIONS.md#d142-tickets-139-and-140-published-with-three-blocker-changes) rework: the blockers were 14 and are now 14, 140. Ticket [140](140-bound-the-private-state-services-replay-and-lookup-cost.md) bounds the cost of opening the private-state service and of its turn start, local admission and local dispatch, which this ticket makes production paths; ticket 11's S4 review asked for that fix to land first ([B32](../../../docs/DECISIONS.md#b32-c3-scoped-grants-and-atomic-task-ownership-ticket-11), Limits). The number and criteria are unchanged; this grants no separate implementation, contract-freeze or release approval.
````

#### E5 — .scratch/dwarf-harness/issues/61-turn-bounded-artifact-and-usage-evidence-into-atomic-causal-graphs.md
Adds ticket 139 to ticket 61's blockers.

Find:
````
Blocked by: 07, 09, 11, 15, 17
````

Replace:
````
Blocked by: 07, 09, 11, 15, 17, 139
````

#### E6 — .scratch/dwarf-harness/issues/61-turn-bounded-artifact-and-usage-evidence-into-atomic-causal-graphs.md
Appends ticket 61's D142 rework comment.

Find:
````
Ticket 11, one of this ticket's blockers, is resolved; tickets 15 and 17 still block it.
````

Replace:
````
Ticket 11, one of this ticket's blockers, is resolved; tickets 15 and 17 still block it.

2026-10-24 — [D142](../../../docs/DECISIONS.md#d142-tickets-139-and-140-published-with-three-blocker-changes) rework: the blockers were 07, 09, 11, 15, 17 and are now 07, 09, 11, 15, 17, 139. Ticket [139](139-register-shared-resources-and-work-domains-through-core.md) produces the registered shared resources and owner-registered work domains that this ticket's resource and work-domain nodes (its first criterion) and its positive resource→consumer usage (its third, with ticket 15's action facts) wait for, as the comment above records. The number and criteria are unchanged; this grants no separate implementation, contract-freeze or release approval.
````

#### E7 — .scratch/dwarf-harness/issues/16-prove-concurrent-private-runtime-restart-and-child-shutdown.md
Appends a cross-link comment for ticket 140.

Find:
````
and is blocked by this ticket under [D102](../../../docs/DECISIONS.md#d102-officer-service-loss-moved-work-pre-router-onset-and-ticket-landing). These extensions add no blocker or criterion to this ticket.
````

Replace:
````
and is blocked by this ticket under [D102](../../../docs/DECISIONS.md#d102-officer-service-loss-moved-work-pre-router-onset-and-ticket-landing). These extensions add no blocker or criterion to this ticket.

2026-10-24 — Consolidation cross-link: Ticket [140](140-bound-the-private-state-services-replay-and-lookup-cost.md) bounds the cost of opening the private-state service after a restart and of its turn start and local admission, which this ticket's restart proof and declared runtime resource profiles exercise. It reaches this ticket through ticket [15](15-run-bounded-context-bound-model-and-tool-turns.md), which it now blocks ([D142](../../../docs/DECISIONS.md#d142-tickets-139-and-140-published-with-three-blocker-changes)). These extensions add no blocker or criterion to this ticket.
````

#### E8 — .scratch/dwarf-harness/issues/62-expose-bounded-authorized-co-access-encounters-without-propagation.md
Appends a cross-link comment for ticket 139.

Find:
````
2026-10-06 — The owner selected “Approve and publish 86 tickets” in the breakdown review. This adopts the decomposition for local publication only; it does not grant any separate implementation, contract-freeze, release or study approval.
````

Replace:
````
2026-10-06 — The owner selected “Approve and publish 86 tickets” in the breakdown review. This adopts the decomposition for local publication only; it does not grant any separate implementation, contract-freeze, release or study approval.

2026-10-24 — Consolidation cross-link: Ticket [139](139-register-shared-resources-and-work-domains-through-core.md) produces registered shared resources, and Undercurrent §8.2 admits co-access from host-observed use of two registered resources by one task context. It reaches this ticket through ticket [61](61-turn-bounded-artifact-and-usage-evidence-into-atomic-causal-graphs.md), which it now blocks ([D142](../../../docs/DECISIONS.md#d142-tickets-139-and-140-published-with-three-blocker-changes)). These extensions add no blocker or criterion to this ticket.
````

#### E9 — docs/DECISIONS.md
Adds a See also line under B32 and appends D142 after it, the log's last entry.

Find:
````
    - under `.scratch/dwarf-harness/c3-evidence/`, the design brief `ticket-11-design-brief.md`, the ruling `ticket-11-design-ruling.md` and the evidence `ticket-11-evidence.md`, beside D140's `f3-11-freeze-evidence.md`.
````

Replace:
````
    - under `.scratch/dwarf-harness/c3-evidence/`, the design brief `ticket-11-design-brief.md`, the ruling `ticket-11-design-ruling.md` and the evidence `ticket-11-evidence.md`, beside D140's `f3-11-freeze-evidence.md`.
- **See also:** D142 publishes ticket 139 for item 4's family and ticket 140 for the cost under Limits.

### D142. Tickets 139 and 140 published, with three blocker changes

- **Date:** 2026-10-24. **Decided by:** adopted. In the overnight log's questions 5 and 6, the project manager recommended publishing a producer ticket for resource and work-domain registration (B32 item 4) and a ticket for the private-state service's measured replay cost (B32's Limits). The owner answered in chat, naming both numbers, and asked for the tickets' dependencies and order to be audited; he then approved the project manager's summary of the two tickets and the audit's changes.
- **Owner's words (chat):**
  - answering questions 5, 6 and 3, at 11:35: "5. The family ticket should be its own ticket: 139, 6. Publish this as ticket 140, then audit and update ticket dependancies and order" and "3. The next ticket shall be Ticket 12 then 13"
  - on the summary: "«OWNER-APPROVAL»"
- **Decision:**
  1. **Ticket 139,** "Register shared resources and work domains through Core" (C3, blocked by 11), produces the family B32 item 4 assigned to C3, with the scoped declarations that assign a registered resource or work domain to a task or context (Undercurrent §8.2's declared relationships), which no entry had assigned to a producer. Ticket 61's resource and work-domain nodes (its first criterion) and positive resource→consumer usage (its third) wait for it, so ticket 61's blockers become 07, 09, 11, 15, 17, 139.
  2. **Ticket 140,** "Bound the private-state service's replay and lookup cost" (C3, blocked by 11), takes the cost that ticket 11's S4 review sent to a new ticket, with S4's profile as B3's measured trigger. The review asked for the fix before ticket 15 makes turn start and local work production paths, so ticket 15's blockers become 14, 140.
  3. **Order.** Ticket 12, then 13, as the owner answered; the tracker's frontier, the lowest-numbered open and unblocked ticket, already selects them first. Ticket 140 lands before 15 through 15's blocker. U3's Status line and board row now name the producer freezes that ticket 61's remaining criteria and ticket 62 wait for as tickets 15, 17 and 139; ticket 11 is resolved and F3-11 frozen (D140).
  4. **The audit** of the open tickets that name ticket 10 or 11, the registration family or the service's replay, lookup or startup cost changes one more blocker, item 5's. Tickets 16 and 62 gain cross-link comments: 140 reaches 16 through 15, and 139 reaches 62 through 61. Ticket 11, whose comments sent both items to the owner, gains a cross-link naming the two tickets. Two blockers are now numbered higher than the tickets they block, 140 on 15 and 139 on 61; the tracker requires only that every listed ticket be resolved (`docs/agents/issue-tracker.md`), and the graph stays acyclic.
  5. **Ticket 59 no longer waits for ticket 61,** so its blockers become 04, 07, 08, 09, 17. Its comment of 2026-10-13 listed 61 only for the graph-delta family, one of the five producer freezes its gate ruling requires; that family is F-U3-61, frozen by D130, and later node and edge kinds join it by addition. Keeping 61 would make 59 wait for 61's remaining criteria and, through them, for 139. It still waits for 17, the validation-evidence freeze. U1's Status line now says that U1.E is blocked, through ticket 59, on ticket 17's freeze alone.
- **Limits:** Publication grants no implementation, contract-freeze, release or study approval and changes no step's status. Ticket 139's family is frozen under D125 once built, unless it reaches an owner gate (D29, D40, D52). Every ticket that waits for 15 now also waits for 140, among them 16, 17 and 59, and every ticket that waits for 61 also waits for 139, among them 62.
- **Changes:** this entry and a See also line under B32; tickets 139 and 140; the blockers and rework comments of tickets 15, 59 and 61; cross-link comments on tickets 11, 16 and 62; in `ROADMAP-UNDERCURRENT.md`, U1's and U3's Status lines, and U3's row on the status board of `ROADMAPS.md`.
````

#### E10 — docs/ROADMAPS.md
Updates U3's board row: the producer freezes that 61's remaining criteria and ticket 62 wait for.

Find:
````
61's remaining criteria and ticket 62 wait for producer freezes: tickets 11, 15, 17; promotion integration: C4)
````

Replace:
````
61's remaining criteria and ticket 62 wait for producer freezes: tickets 15, 17, 139; promotion integration: C4)
````

#### E11 — docs/ROADMAP-UNDERCURRENT.md
Updates U3's Status line in the same way as E10.

Find:
````
61's remaining criteria and ticket 62 wait for producer freezes: tickets 11, 15, 17; promotion integration: C4)
````

Replace:
````
61's remaining criteria and ticket 62 wait for producer freezes: tickets 15, 17, 139; promotion integration: C4)
````

#### E13 — .scratch/dwarf-harness/issues/59-replay-record-only-facts-into-exact-source-lifecycles.md
Removes ticket 61 from ticket 59's blockers.

Find:
````
Blocked by: 04, 07, 08, 09, 17, 61
````

Replace:
````
Blocked by: 04, 07, 08, 09, 17
````

#### E14 — .scratch/dwarf-harness/issues/59-replay-record-only-facts-into-exact-source-lifecycles.md
Appends ticket 59's D142 rework comment.

Find:
````
The gate analysis and its ruling are kept by the project manager and land with this ticket's documents when it closes.
````

Replace:
````
The gate analysis and its ruling are kept by the project manager and land with this ticket's documents when it closes.

2026-10-24 — [D142](../../../docs/DECISIONS.md#d142-tickets-139-and-140-published-with-three-blocker-changes) rework: the blockers were 04, 07, 08, 09, 17, 61 and are now 04, 07, 08, 09, 17. The comment above lists ticket 61 only for the graph-delta family, one of the five producer freezes the gate ruling requires. That family is F-U3-61, frozen by [D130](../../../docs/DECISIONS.md#d130-f-u3-61-graph-analysis-records-frozen), and later node and edge kinds join it by addition. Keeping 61 would make this ticket wait for 61's remaining criteria and, through them, for ticket [139](139-register-shared-resources-and-work-domains-through-core.md). It still waits for ticket 17, the validation-evidence freeze. The number and criteria are unchanged; this grants no separate implementation, contract-freeze or release approval.
````

#### E15 — docs/ROADMAP-UNDERCURRENT.md
Refreshes U1's Status line: U1.E now waits, through ticket 59, on ticket 17's freeze alone.

Find:
````
2026-10-13: U1.E is blocked on producer freezes, tickets 07, 08, 09, 17 and 61, through ticket 59)
````

Replace:
````
2026-10-24: U1.E is blocked, through ticket 59, on one producer freeze, ticket 17's; the other four are frozen: D124 activation, D130 graph, D119 scratch and D123 promotion)
````

#### E16 — .scratch/dwarf-harness/issues/11-enforce-scoped-grants-and-atomic-task-ownership.md
Appends a cross-link comment naming tickets 139 and 140.

Find:
````
`TestF3_11Compatibility` and `FuzzDecodeF3_11` hold its records.
````

Replace:
````
`TestF3_11Compatibility` and `FuzzDecodeF3_11` hold its records.

2026-10-24 — Consolidation cross-link: Ticket [139](139-register-shared-resources-and-work-domains-through-core.md) produces the resource and work-domain registration family that [B32](../../../docs/DECISIONS.md#b32-c3-scoped-grants-and-atomic-task-ownership-ticket-11) item 4 assigned to C3, and ticket [140](140-bound-the-private-state-services-replay-and-lookup-cost.md) takes the cost S4's profile measured; both were published under [D142](../../../docs/DECISIONS.md#d142-tickets-139-and-140-published-with-three-blocker-changes). These extensions add no blocker or criterion to this ticket.
````

## Report

### Choices

- **P1. Titles, slugs and capability lines.** The titles are imperative, like 10's and 11's. "Private-state service" is the service's name in B31's heading (`DECISIONS.md:2546`) and ticket 11's Answer (line 50). The slugs follow the skill's rule (the apostrophe in "service's" is dropped): `139-register-shared-resources-and-work-domains-through-core.md` and `140-bound-the-private-state-services-replay-and-lookup-cost.md`. The capability lines follow the "C3 <capability> (<decisions>)" form of tickets 13 and 89.
- **P2. Each new ticket is blocked by 11 only.** 139: grants name the resources and work domains mirror the owner's root grants (AdvisorT11Close, `t11-close-review-verdict.md:41`), so it must fit F3-11; it needs neither 12–15 nor 15's terminal, because ticket 11 was verified through the service's own boundary (its Answer, line 50). 140: it changes ticket 11's service (`t11-s4-verdict.md:35`). No source requires 12 or 13 first; the frontier already orders them first (P7).
- **P3. 15 gains 140, confirmed.** Ruling 4 (`t11-s4-verdict.md:35`), AdvisorT11Close's second ruling (`t11-close-review-verdict.md:45`) and B32's Limits (`DECISIONS.md:2664`): the fix lands "before ticket 15 makes StartTurn, AdmitLocal and BeginLocal production paths". Criterion lines 32 and 36 are cited in the audit; line 36's dependence is [INFERENCE].
- **P4. 61 gains 139, confirmed.** B32 item 4 (`DECISIONS.md:2657`) and ticket 61's comment (line 93): criteria 1 and 3 (lines 29, 31) wait for the family.
- **P5. 16 and 62 get cross-links, not blockers.** Each builds on the new ticket, which already reaches it through its existing blocker (15 and 61). This follows 62's own precedent: its gate names 11's and 15's fields (line 22), yet only 61 is listed. For 62 the dependence rests on Undercurrent §8.2's co-access wording (`DESIGN-UNDERCURRENT.md:178,182`). "Registered" there could mean any registered node, since §8.3 also registers modules (`:190`) [INFERENCE]. A cross-link is right under either reading.
- **P6. 89 stays unchanged, and 59 drops 61.** 89's line 31 already requires its own bounded query that does not rescan history, so it needs nothing from 140. For 59 the PM settled my open question: 61 leaves its blockers, with the reasons in the audit row (E13, E14). U1's Status line (`ROADMAP-UNDERCURRENT.md:217`) is refreshed to match (E15), as when ff113dc first set that text. The board row (`ROADMAPS.md:187`) says only "In progress", so it does not change.
- **P7. Order.** The frontier rule, "the lowest-numbered open, unblocked, unclaimed ticket" (`docs/agents/issue-tracker.md:24`), already gives 12, then 13, so the order is recorded only in D142 item 3. 140 before 15 is carried by 15's `Blocked by`. No roadmap keeps a per-ticket order (C3's section, `ROADMAP-CORE.md:418-516`, names none).
- **P8. U3's text drops 11 and adds 139, identically in both places** (`ROADMAPS.md:189`, `ROADMAP-UNDERCURRENT.md:309`). 11 is resolved and F3-11 frozen (D140, `DECISIONS.md:2608`). B32's close review fixed the same staleness in 61's comment by naming 15 and 17 (`DECISIONS.md:2670`). The status value stays "In progress". C3's row and Status line (`ROADMAPS.md:171`, `ROADMAP-CORE.md:516`) stay as they are: "C3's other tickets remain open" covers 139 and 140.
- **P9. `CONTRACTS.md` changes in one place.** The register points to producing tickets only in the F3-11 catalogue's "later F3 families (tickets 12–16)" (`CONTRACTS.md:117`). 139's family is a later C3 family (B32 item 4), so 139 joins that pointer. C3's row (`CONTRACTS.md:39`) cites B32, not a ticket, and is left as it is. 140 produces no family.
- **P10. B32 gains a one-line See also,** the pointer the role allows for an earlier entry (form: D125's See also lines, `DECISIONS.md:2134-2136`). It links B32's open referrals (`:2664`, `:2667`) to their tickets.
- **P11. 140's closing criterion.** Opening must grow "no faster than the ledger's length, as the store's own opening does", and each operation must stay "within the bound the design states". The ruling sets no number. It contrasts the store's linear opening (19 to 166 ms) with the superlinear one (`t11-s4-verdict.md:35`; evidence `ticket-11-evidence.md:241`), and it leaves the fix's design choice to the design and the review. The linear bar is my [INFERENCE] from that contrast.
- **P12. 139's declaration criterion.** "Any declaration linking one to a task or context" follows §8.2's declared relationships, "explicit resource assignments and owner-registered work domains … scoped and versioned; not an implicit permission" (`DESIGN-UNDERCURRENT.md:176`). It also follows 61's line 31, "host-bound actual use or scoped declarations". That 139 rather than another ticket produces those declarations is my [INFERENCE] from B32 item 4, which makes 61's positive usage wait for this family. Other facts in the body: the opaque, non-secret resource identity (`DESIGN-UNDERCURRENT.md:190`; D140's 1–256-byte external keys, `DECISIONS.md:2615`); "external resources require host registration" (`ROADMAP-UNDERCURRENT.md:300`); and Core as the registrar (`t11-close-review-verdict.md:41`).
- **P13. Coverage numbers** (`.scratch/dwarf-harness/spec.md`). They keep the tracker's baseline of implementation decisions 1, 2 and 4 and testing decisions 1, 2 and 20, each served by the gates or the verification boundary. 3 is added only where a family is frozen.
  - 139: user stories 27 (`:81`; not a permission, no authority expansion) and 86 (`:203`; typed nodes). Implementation decisions 1 (`:379`), 2 (`:381`), 3 (`:383`; the family freeze), 4 (`:385`), 11 (`:413`; only the owner registers, never a permission) and 38 (`:497`; registered-resource and work-domain nodes). Testing decisions 1 (`:585`), 2 (`:587`), 4 (`:591`; restart, crash and same-ID receipt), 17 (`:625`; the producer-family freeze audit) and 20 (`:635`).
  - 140: user story 26 (`:79`; restart recovery unchanged). Implementation decisions 1, 2, 4 (the labelled rerun) and 10 (`:403`; rebuilding appends and dispatches nothing). Testing decisions 1, 2, 4 (hot-index eviction, rebuild without a caller-specific path), 17 ("actual ledger/replay costs"), 18 (`:629`; latency and memory measured, not capacity) and 20.
- **P14. Gate bullets from the current rules.** D125's PM freeze and its Limits (`DECISIONS.md:2131-2132`); D117's ruled design (`:1937-1943`); D112's D52 approval "before C2 or C3 implementation" (`:1546`); D133's CI and D141's one push per ticket; D29, D40 and D41 for the owner's remaining gates. They are written as requirements, not status statements (D116 item 4). Ticket 140's bullet says that the fix adds no record type, because B3's indexes and snapshots are rebuildable and discardable, never ledger authority (`DECISIONS.md:672`), and that only a new dependency would wait for the owner (D29). An additive family would be the PM's freeze under D125, not the owner's.
- **P15. The cross-link label.** I kept the skill's "Consolidation cross-link:" wording, as the instruction "in the skill's form" asks.
- **P16. Where the approval placeholder goes.** It is used in D142 and in both new tickets' provenance comments, because the skill requires each ticket's comment to quote the owner's breakdown approval.
- **P17. D142's title** is "Tickets 139 and 140 published, with three blocker changes": two added and one removed. Its anchor, `d142-tickets-139-and-140-published-with-three-blocker-changes`, is used in all seven ticket links to it (E1, E2, E4, E6, E7, E8 and E14).

### Placeholders

| Placeholder | Where | How and when it is filled |
|---|---|---|
| OWNER-APPROVAL | E1 and E2 (Comments), E9 (D142's Owner's words) | Filled by the PM after the owner answers the owner summary: his words verbatim, typos kept. The placeholder already sits inside quotation marks, so the PM adds none. |

### Not settled

Nothing. The PM settled both earlier items: 59's blockers (E13, E14) and U1's Status line (E15).

### PM revisions after AdvisorT139T140 (2026-10-24)

The review approved E1–E15 with five minor findings and two nits (`local://t139-t140-review-verdict.md`). The PM applied them in this file, and draft 2 is kept as `local://t139-t140-publication-edits-draft2.md`:
1. The summary's 139 bullet says that only the owner registers and that the ticket records his declared assignments.
2. D142 item 1 names the scoped declarations.
3. Ticket 140's first criterion lists the candidates without ranking the index ahead of the narrowed check.
4. Ticket 140's body adds B31's earlier scans.
5. E12 is dropped. Both catalogue pointers in `CONTRACTS.md` (lines 108 and 117) stay unchanged, the review's second option. They are freeze-time scope sentences, and C3's row already carries the family.
6. The summary's 140 bullet no longer presumes the fix (nit).
7. E16 adds the optional cross-link on ticket 11 (nit). D142's item 4 and Changes name it.
