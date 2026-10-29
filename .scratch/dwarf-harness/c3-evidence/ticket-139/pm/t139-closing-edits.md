# Ticket139 — closing edits for joint review

Draft only: B34 is allocated to Ticket139, not approved or applied. R1–R7 are proposed public closing edits; R8 is a private-records append for primary only. Application requires joint primary approval and both fresh independent reviews. No fresh S3 review approval, S3 hosted success, final-public-SHA success, integration or ticket closure is asserted by this packet. D153 still requires the guarded exact final public SHA's successful hosted `Check result`, including the required three-OS/race proof for the code, before main advances. Later whole-ticket Fable verification remains separate and is not credited here.

## Visibility and path index

| Visibility | Edits | Repository-relative path | Find source |
|---|---|---|---|
| Public | R1–R3 | `.scratch/dwarf-harness/issues/139-register-shared-resources-and-work-domains-through-core.md` | `139-acceptance` code tree, lines 3, 35–40, 60 |
| Public | R4 | `docs/ROADMAP-CORE.md` | `139-acceptance` code tree, line 516 |
| Public | R5–R6 | `docs/ROADMAPS.md` | `139-acceptance` code tree, lines 171, 189 |
| Public | R7 | `docs/ROADMAP-UNDERCURRENT.md` | `139-acceptance` code tree, line 309 |
| Private records only | R8 | `docs/DECISIONS.md` | Canonical private main, line 3102 |
| Private supporting copies, integration-PM-owned; no creation/edit in this packet | None | `.scratch/dwarf-harness/c3-evidence/ticket-139-design-brief.md`, `ticket-139-design-ruling.md`, `ticket-139-acceptance-evidence.md` in that same folder | Canonical evidence-copy index supplied separately by parent |

Apply the seven public edits together in the single D116 closing-documents commit, only after approval. Private R8 and supporting copies belong to the separate D145 records integration; never include them in a public commit. R4/R5 and R6/R7 deliberately use identical status text apart from wrappers. Every Find below was copied from the assigned current source by a raw ranged read. Mechanical uniqueness/application and final links/LF checks belong to the PM; no repository or runtime action was performed by the drafter.

There are no unknown-value placeholders in the replacements. The proposed B34 date is 2026-10-29; primary must reanchor that date to the actual local application date if later, and reanchor R8's Find and retained first line together if the private tail advances. B34 is the only allocated number; B35 and D156 are not reserved.

## Public edits

#### R1 — .scratch/dwarf-harness/issues/139-register-shared-resources-and-work-domains-through-core.md
Resolve only Ticket139's status field when the closing packet is approved for application.
Find:
````
Status: ready-for-agent
````
Replace:
````
Status: resolved
````

#### R2 — .scratch/dwarf-harness/issues/139-register-shared-resources-and-work-domains-through-core.md
Check the six existing acceptance criteria without changing their wording.
Find:
````
- [ ] The owner registers and revises shared resources and work domains through producer-owned typed Core transitions that bind actor, operation and target, check the expected version and current authority, and commit one replay-complete group ending in its receipt before acknowledging; an agent cannot register, revise or widen a registration.
- [ ] A registered shared resource is one that F3-11's grants can name, by resource kind and key. Each registration's identity is opaque and non-secret, never a URL, account name or credential.
- [ ] A registration, and any declaration linking one to a task or context, is scoped and versioned: a revision supersedes the earlier version without rewriting history, and replay at any cursor sees the version then current. A registration or declaration is evidence for the graph, never a permission.
- [ ] The family is specified with its real payloads, permitted caller, consumers, privacy and replay-essential fields and a golden sample, and is frozen by addition to the ledger format before its producer writes it; F3-10's and F3-11's records, rules and goldens are unchanged.
- [ ] At restart the service rebuilds every registration from the ledger alone and appends nothing; a crash before or after the commit leaves only committed registrations, and a same-command retry returns the original receipt.
- [ ] Ticket 61 can build its resource and work-domain nodes from the frozen records without stand-in data: the golden holds every registration and declaration shape a node or declared edge needs.
````
Replace:
````
- [x] The owner registers and revises shared resources and work domains through producer-owned typed Core transitions that bind actor, operation and target, check the expected version and current authority, and commit one replay-complete group ending in its receipt before acknowledging; an agent cannot register, revise or widen a registration.
- [x] A registered shared resource is one that F3-11's grants can name, by resource kind and key. Each registration's identity is opaque and non-secret, never a URL, account name or credential.
- [x] A registration, and any declaration linking one to a task or context, is scoped and versioned: a revision supersedes the earlier version without rewriting history, and replay at any cursor sees the version then current. A registration or declaration is evidence for the graph, never a permission.
- [x] The family is specified with its real payloads, permitted caller, consumers, privacy and replay-essential fields and a golden sample, and is frozen by addition to the ledger format before its producer writes it; F3-10's and F3-11's records, rules and goldens are unchanged.
- [x] At restart the service rebuilds every registration from the ledger alone and appends nothing; a crash before or after the commit leaves only committed registrations, and a same-command retry returns the original receipt.
- [x] Ticket 61 can build its resource and work-domain nodes from the frozen records without stand-in data: the golden holds every registration and declaration shape a node or declared edge needs.
````

#### R3 — .scratch/dwarf-harness/issues/139-register-shared-resources-and-work-domains-through-core.md
Append the actual claim date and concise producer/recovery resolution under Comments, preserving the publication comment.
Find:
````
2026-10-24 — Published at the owner's word, which made the family ticket its own ticket, 139, and with his approval of the breakdown ([D142](../../../docs/DECISIONS.md#d142-tickets-139-and-140-published-with-three-blocker-changes)). This adopts the ticket for local publication only; it does not grant any separate implementation, contract-freeze, release or study approval.
````
Replace:
````
2026-10-24 — Published at the owner's word, which made the family ticket its own ticket, 139, and with his approval of the breakdown ([D142](../../../docs/DECISIONS.md#d142-tickets-139-and-140-published-with-three-blocker-changes)). This adopts the ticket for local publication only; it does not grant any separate implementation, contract-freeze, release or study approval.

2026-10-28 — Claimed for the ruled three-slice Core registration build under D117/D125/D152.

2026-10-29 — Resolution: the three-slice build supplies owner-only CAS registration/declaration transitions, exact opaque F3-11 resource addresses, scoped versioned evidence, historical/pinned queries and original command receipts (B34). The complete additive F3-139 family was frozen before its producer (D154); see the [ledger catalogue](../../../docs/CONTRACTS.md) and [Core package documentation](../../../internal/core/agents/doc.go). Real process-interruption and injected torn-tail recovery prove ledger-only reconstruction without Core replay appends and retries without duplicate effects; they do not establish power-loss durability. Registrations remain evidence, not permission. Ticket61 receives real record shapes, not implemented graph nodes/edges; later action facts, provider execution and views are outside this ticket. D52's testing-only boundary, C4 admission and separate whole-ticket Fable verification remain unchanged.
````

#### R4 — docs/ROADMAP-CORE.md
Add Ticket139/B34 to C3 progress while preserving its existing completions and every remaining exit fence.
Find:
````
**Status.** In progress (2026-10-27: tickets 10, 11 and 12 are resolved, B31–B33; each code slice passes CI on Windows, Linux and macOS before `main` moves (D153), and C3 still needs all three green at its exit; public run 2 on d8336c8 passed ticket 13's code on all three, while that ticket's close awaits verification; C3's other tickets remain open).
````
Replace:
````
**Status.** In progress (2026-10-29: tickets 10, 11 and 12 are resolved, B31–B33; ticket 139's registration producer is complete, B34; each code slice passes CI on Windows, Linux and macOS before `main` moves (D153), and C3 still needs all three green at its exit; public run 2 on d8336c8 passed ticket 13's code on all three, while that ticket's close awaits Fable verification; C3's other tickets remain open).
````

#### R5 — docs/ROADMAPS.md
Mirror R4's C3 status exactly in its existing board row without changing dependencies.
Find:
````
| C3 | Agent runtime | C2; remote with CI (D42, D145, D153), green on Windows (D133) | In progress (2026-10-27: tickets 10, 11 and 12 are resolved, B31–B33; each code slice passes CI on Windows, Linux and macOS before `main` moves (D153), and C3 still needs all three green at its exit; public run 2 on d8336c8 passed ticket 13's code on all three, while that ticket's close awaits verification; C3's other tickets remain open) |
````
Replace:
````
| C3 | Agent runtime | C2; remote with CI (D42, D145, D153), green on Windows (D133) | In progress (2026-10-29: tickets 10, 11 and 12 are resolved, B31–B33; ticket 139's registration producer is complete, B34; each code slice passes CI on Windows, Linux and macOS before `main` moves (D153), and C3 still needs all three green at its exit; public run 2 on d8336c8 passed ticket 13's code on all three, while that ticket's close awaits Fable verification; C3's other tickets remain open) |
````

#### R6 — docs/ROADMAPS.md
Mirror R7's partial U3 status, removing only the now-supplied Ticket139 producer prerequisite.
Find:
````
| U3 | Coupling graph service | Foundation: C2 and frozen `ledger-appender` (C1, D50); accepted-promotion integration: C4 (D52) | In progress (foundation partial: ticket 61 S1–S5 landed, F-U3-61 frozen D130; 61's remaining criteria and ticket 62 wait for producer freezes: tickets 15, 17, 139; promotion integration: C4) |
````
Replace:
````
| U3 | Coupling graph service | Foundation: C2 and frozen `ledger-appender` (C1, D50); accepted-promotion integration: C4 (D52) | In progress (foundation partial: ticket 61 S1–S5 landed, F-U3-61 frozen D130; ticket 139 supplies the registration producer for F3-139 (D154); 61's remaining criteria and ticket 62 still wait for producer freezes: tickets 15, 17; promotion integration: C4) |
````

#### R7 — docs/ROADMAP-UNDERCURRENT.md
Record registration-producer availability only; preserve partial foundation, remaining producer freezes and C4 integration.
Find:
````
**Status.** In progress (foundation partial: ticket 61 S1–S5 landed, F-U3-61 frozen D130; 61's remaining criteria and ticket 62 wait for producer freezes: tickets 15, 17, 139; promotion integration: C4).
````
Replace:
````
**Status.** In progress (foundation partial: ticket 61 S1–S5 landed, F-U3-61 frozen D130; ticket 139 supplies the registration producer for F3-139 (D154); 61's remaining criteria and ticket 62 still wait for producer freezes: tickets 15, 17; promotion integration: C4).
````

## Private edit — primary application only

#### R8 — docs/DECISIONS.md
Append only the allocated short B34 record after the current private tail; do not alter D155's body.
Find:
````
- **Changes:** this entry. No implementation, interface, schema, fixture, dependency, toolchain, workflow, public ticket-close status, B allocation or numerical acceptance is changed by recording it.
````
Replace:
````
- **Changes:** this entry. No implementation, interface, schema, fixture, dependency, toolchain, workflow, public ticket-close status, B allocation or numerical acceptance is changed by recording it.

### B34. C3: shared-resource and work-domain registrations (ticket 139)

- **Date:** 2026-10-29. **Decided by:** assistant, within D117/D125/D152. Three slices follow the amended [ruling](../.scratch/dwarf-harness/c3-evidence/ticket-139-design-ruling.md) on the [brief](../.scratch/dwarf-harness/c3-evidence/ticket-139-design-brief.md); D154 froze the complete additive F3-139 family before its producer. No new owner policy, dependency or breaking change was needed.
- **Decision:** Core owns owner-only CAS registration and scoped versioned declarations, ledger-only reconstruction and original matching-retry receipts. Registration is evidence, not permission: existing grants remain authoritative. The [package documentation](../internal/core/agents/doc.go) specifies the built boundary; the ruling retains alternatives and reasons.
- **Evidence and limits:** the [acceptance evidence](../.scratch/dwarf-harness/c3-evidence/ticket-139-acceptance-evidence.md) maps the six criteria to observed source/local/review/hosted receipts. Process interruption and injected torn tails are not power-loss qualification. D153 gates exact-final-SHA integration; later whole-ticket Fable verification remains separate. Graphs, action facts, providers, views and D52/C4 real-work admission remain outside this build.
- **Changes:** Ticket139's close and the paired C3/U3 progress lines, with private supporting records. C3 and U3 remain In progress.
````

## Intentionally unchanged gates and files

- Ticket139's `Blocked by: 11` remains the historical dependency; Ticket11 is already resolved. No new dependency on D155 and no Ticket139 blocker added to Ticket15.
- C3 and U3 remain In progress in their sole canonical status locations. Tickets13/14/15/140 are not resolved by these edits; Ticket13's Fable close verification and C3's three-OS-before-main and all-three-at-exit requirements remain.
- U3's foundation stays partial, F-U3-61 remains under D130, and producer freezes15/17 plus promotion integration C4 remain. No change to Ticket61 or Ticket15, graph implementation/authorization, action facts, provider functionality or view readiness.
- No contract-register, package-documentation, implementation, fixture, dependency, workflow, public new-document or changelog edit is proposed. The family register/package documentation already cover F3-139; no version/status is duplicated into a new contract table.
- B34 adds no owner quotation and changes no prior entry's body. The three canonical private supporting copies and their evidence-source index are integration-PM-owned; this packet neither creates nor invents their contents.

## Drafter report — choices and sources

Source shorthand: `local/` refers to the assignment's secondary-session local directory; public paths below refer to the assigned `139-acceptance` tree; `private-main:` identifies the canonical main checkout. All supporting citations in this report stay private with the packet.

- **P1 — exactly four public files, seven public edits and one private append.** Preserve ticket criterion wording and existing publication comment; append only the two requested dated comments. Sources: `local/t139-closing-draft-assignment.md:10–17,25–26`; ticket source `:3,35–40,58–60`; `local/t139-b34-closing-authority.txt:5,9–11`.
- **P2 — paired status cells are byte-identical apart from wrappers.** Add only139/B34 and the supplied registration producer; keep C3/U3 partial and all named fences. Sources: `docs/ROADMAP-CORE.md:516`; `docs/ROADMAPS.md:171,189`; `docs/ROADMAP-UNDERCURRENT.md:307–309`; `local/t139-closing-draft-assignment.md:12–14`; `local/t139-b34-closing-authority.txt:9`.
- **P3 — concise B34 records the ruled build, not an invented approval.** Assistant originator, three slices, D154-before-producer, owner-only CAS, opaque separate identity/address, scoped/versioned evidence, ledger-only recovery and original retry receipts. Sources: `local/t139-ruling.md:13–23,71–82,218–247,344–406`; `internal/core/agents/doc.go:615–658`; `local/t139-acceptance-matrix.md:9–14`; `private-main:docs/DECISIONS.md:2758–2760,3102` for form/anchor; `local/t139-closing-draft-assignment.md:17` for archive/link names.
- **P4 — make no S3 hosted or fresh-review success claim.** Local completed proof and immutable S3 code do not satisfy joint approval or exact-final-SHA publication. Sources: `local/t139-acceptance-matrix.md:3,22–25`; `local/t139-b34-closing-authority.txt:7,11`; `local/t139-closing-draft-assignment.md:20–23`; actual author report `remaining-20261029T173807547Z-9144/author-final-report.json:10,168–243,374–387`. The resolution distinguishes Core no-append replay from Store torn-tail repair and does not claim power-loss durability.
- **P5 — private evidence path convention and final copy index stay with primary.** Use only the three assigned names under existing `c3-evidence/`, point from B34 to `../internal/core/agents/doc.go`, and leave canonical copies/index untouched. Sources: `local/t139-closing-draft-assignment.md:17,26`; `local/t139-b34-closing-authority.txt:11`.

**Unsettled / not credited:** parent-supplied canonical evidence-copy index and final contents; fresh independent reviews; joint primary approval; exact-final-public-SHA hosted result and integration receipts. These are application/integration gates, not missing Find anchors or unimplemented local acceptance. No assigned source has proved unreachable. No additional number, owner choice, runtime action or repository edit is requested by this draft.
