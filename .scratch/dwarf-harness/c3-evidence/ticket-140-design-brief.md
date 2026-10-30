# Ticket 140 implementation design brief

## Owner-facing summary and gate verdict

**Proposed; not ruled.** Buildable after a fresh advisor ruling, with no presently triggered owner gate. This is a cost-only change inside `internal/core/agents`; it changes no service API, command, record, golden, dependency, wallet, provider behavior or permission decision. Use the existing projection and scope gates, add a bounded ledger-derived lookup accelerator, and remove repeated history traversal from the measured current-state paths. A fused historical-object/materialization inspection is justified by already-measured startup growth, not a speculative snapshot. No persistent index or operational snapshot is proposed. Sources: `.scratch/dwarf-harness/issues/140-bound-the-private-state-services-replay-and-lookup-cost.md:10-44`; `docs/DESIGN-CORE-AND-LAUNCHERS.md:849-863,916-930`.

**Three complete slices:** (S1) context binding and fresh-ID watermarks; (S2) one bounded historical/witness cache; (S3) current-head private integrity/selection, fused startup inspection and accurate cost documentation. The PM owns unchanged-driver measurements, fuzz campaigns, integration and private evidence. Each slice gets a fresh coder/review and its exact final SHA's successful hosted `Check result` before ff-only integration. Sources: `docs/DECISIONS.md:3032-3044,3057-3066`; `docs/ROADMAPS.md:227-235`.

**No release claim.** All workloads remain admission and storage only, testing-only. Ticket 16 owns runtime capacity and C4 owns delivery. Ticket 13's existing code remains supported, but its held whole-ticket verification/close is not reopened here. Sources: `.scratch/dwarf-harness/issues/140-bound-the-private-state-services-replay-and-lookup-cost.md:25-35`; `docs/DECISIONS.md:351-360`; `docs/ROADMAPS.md:171-172`.

## Source authority and observed bottlenecks

Frozen contracts and public specifications constrain the implementation; the ticket specifies the cost fix, and this brief's numbered choices require advisor approval. Private decision/evidence citations below are team-only references, never material to copy into public package documentation or commits. Sources: `docs/CONTRACTS.md:3-18,108-151`; `docs/DECISIONS.md:675-677`; `docs/ROADMAPS.md:230-233`.

Observed, not newly reproduced here:

| Evidence | Observation | Design consequence |
|---|---|---|
| Ticket 11 | 87→874 commits; `agents.Open` 1.42→75.8 s while store Open 19→166 ms; start/admit/begin/create/cancel 4.5–9.4× slower. Review identified unbound-context misses, repeated task derivation and turn integrity history scans. | First optimize context lookup/current heads, retaining every final authority check. `.scratch/dwarf-harness/c3-evidence/ticket-11-evidence.md:220-243`. |
| Ticket 10 | Every successful private write scans twice; Open twice per clean scope. | Current materialization fast paths plus one fused startup traversal; do not retain lifetime digest lists. `docs/DECISIONS.md:2600-2613`; `internal/core/agents/integrity.go:69-103,120-194`. |
| Ticket 12 after S5 | Quiet PM Open 14.7→50.7 s at 1,047→2,163 records (exponent 1.70); 10× coder run still exponent 1.88. About 45% CPU per-scope validation, 23–29% scoped replay, 9–11% witness batch. Artifact check-order regression already fixed. | Include F3-12 terminal task transitions, cold requests/receipts and witnesses; preserve S5, do not redo it. `.scratch/dwarf-harness/issues/140-bound-the-private-state-services-replay-and-lookup-cost.md:57-62`; `docs/DECISIONS.md:2796-2810`. |

Code-confirmed additional mechanisms: fresh task/work misses traverse from zero (`internal/core/agents/scoped_state.go:103-185`); assignment reuse scans from zero (`internal/core/agents/scoped_state.go:195-213`); current private read selection/replay traverses history (`internal/core/agents/read.go:119-181`, `internal/core/agents/scoped_private.go:77-136`); every review witness batch starts at its segment boundary (`internal/core/agents/review_sources.go:11-90`). Their contribution to final timing remains an **inference**, not another measured profile.

## Proposed choices for advisor ruling

All choices are recommendations awaiting the advisor; the detailed implementation below follows them.

| Choice | Options considered | Recommendation and reason |
|---|---|---|
| **P1 — context/fresh identities** | Repeated scans; lifetime task/assignment maps; one validity-qualified task hint per existing registered context plus typed maxima. | Choose the last. Exact unbound-context answers and fresh-ID absence avoid ordinary scans without dropping old-assignment refusal. Separate bytewise maxima for task/work/grant/assignment follow existing command/request watermarks; at/below a maximum still looks up history. Unknown/discarded hints are not known-unbound. No UUID-time rule. Sources: `internal/core/agents/scoped_state.go:68-213,275-305`; `internal/core/agents/replay.go:279-289`; `internal/core/agents/scoped_tasks.go:124-170`. |
| **P2 — historical accelerator** | Lifetime maps/digest lists; persistent index/snapshot; separate per-family caches; one bounded typed memory cache. | Choose one cache shared by task/grant/work/request/command/source/assignment lookup. **256 entries, 8 MiB retained encoded metadata**, LRU eviction, oversize entries uncached. These are acceleration budgets, not admission/population limits. Reuse the existing bounded-hot/authoritative-cold pattern, not ledgerstore internals. Sources: `docs/DESIGN-CORE-AND-LAUNCHERS.md:855-859`; `docs/DECISIONS.md:675-677`; `internal/core/ledgerstore/commands.go:18-21,50-103,130-145`; `internal/core/agents/scoped_plan.go:92-160`. |
| **P3 — validity/concurrency** | Cache misses imply absence; reset all entries each commit; prefix-qualified immutable answers with exact invalidation. | Choose prefix qualification/invalidation. Verify entry integrity/key/prefix; stale/corrupt/evicted entries take the ledger fallback. A single cache mutex supports existing unlocked lookups; never hold it across I/O or acquire Service.mu while holding it. Cache answers never confer permission. Sources: `internal/core/agents/replay.go:240-375,386-411`; `internal/core/agents/review_execute.go:180-220`; `internal/core/agents/service.go:113-128`. |
| **P4 — startup inspection** | Current heads only; old per-scope scans; one global post-replay history pass; snapshot. | Choose one history pass fused across scopes, then current-head completion. Current-head-only Open would lose historical reporting/transcript fences. Exactly two global traversals total (reducer, historical inspection), not one physical pass. Already-measured Open growth justifies this; no snapshot. Sources: `internal/core/agents/integrity.go:120-168`; `.scratch/dwarf-harness/c3-evidence/ticket-11-evidence.md:243`; `docs/DECISIONS.md:2796-2810`. |
| **P5 — live integrity** | Cache a healthy bit; inspect current heads/actual Markdown, history only for unmatched regular digests; scan all history each time. | Choose fresh current-head/file observations behind existing scope gates. Remember one last successfully materialized committed digest per Markdown slot; unmatched regular bytes still need ledger same-slot membership before calling them foreign. Never skip object hashing/link refusal. Sources: `internal/core/agents/integrity.go:16-49,170-253`; `internal/core/agents/materialization.go:62-114`; `internal/core/agents/scoped_execute.go:239-276`; `.scratch/dwarf-harness/c3-evidence/ticket-11-evidence.md:243`. |
| **P6 — selection/witnesses** | Retain current-read scans; retain all revisions; current non-transcript head selection plus the shared source cache. | Choose exact current-head selection in both read preparation and replay validation; historical/transcript selection retains exact-occurrence scans. Resolve cached witnesses first, then one existing segment-aligned batch for missing witnesses. No private/body bytes cached. Sources: `internal/core/agents/read.go:119-181`; `internal/core/agents/scoped_private.go:77-136`; `internal/core/agents/review_sources.go:11-90`; `.scratch/dwarf-harness/c3-evidence/ticket-12-design-ruling.md:25,54`. |
| **P7 — repeated planning** | Remove repeated derivation; retain a permission/plan across unlock; keep phases and reduce lookup cost. | Keep every preparation, final reducer, authority and CAS check. Indexing makes duplication inexpensive without stale authorization or bypassing beforeSubmit validation. Sources: `internal/core/agents/scoped_submit.go:267-275`; `internal/core/agents/scoped_tasks.go:75-89`; `internal/core/agents/scoped_execute.go:275-319`; `.scratch/dwarf-harness/c3-evidence/ticket-11-design-brief.md:91-93`. |
| **P8 — acceptance/noise** | Invent an SLA; infer asymptotic proof from two points; unchanged-driver finite preregistered bounds. | Choose linear history-normalized startup and each named operation's long median ≤ **2×short median +25 ms**, three independent complete runs, fixed five-run resolution for borderline noise. Engineering fixture thresholds only; no permanent timing assertions/capacity claim. Sources: `.scratch/dwarf-harness/issues/140-bound-the-private-state-services-replay-and-lookup-cost.md:34-41`; `.scratch/dwarf-harness/c3-evidence/ticket-11-evidence.md:220-243`; `.scratch/dwarf-harness/c3-evidence/ticket-12-evidence.md:318-380`; `docs/ROADMAPS.md:234-235`. |
| **P9 — slices/proof** | Monolith; five historical-style slices; three complete product slices. | Choose context/watermarks → unified cache/witnesses → private/fused startup and documentation. Existing four-family/crash proof remains; add only correctness-sensitive boundary regressions. PM, not coder, measures/fuzzes. Sources: `docs/DECISIONS.md:3032-3044`; `.scratch/dwarf-harness/issues/140-bound-the-private-state-services-replay-and-lookup-cost.md:34-41`; `docs/CONTRACTS.md:108-151`. |

**Owner gates, not P-decisions:** OG-BREAK (frozen rule/schema/golden), OG-DEP (new module), OG-D52 (testing/promotion boundary), and keys/money/accounts/machine/toolchain/workflow changes still need the owner. None is triggered by this proposal. A failed experiment returns to the advisor, not permission to cross these gates. Sources: `docs/DECISIONS.md:122-132,207-221,351-360,3036-3040,3067-3069`.

## Data, locking, invalidation and boundedness

### P1: context association and watermarks

Keep `projection.contexts`' owner map and all its callers unchanged. Add one fixed-size `everTask` hint to the **existing context-scope scopeState**: known flag, task UUID and integrity seal; empty/discarded hint is **unknown**, not unbound. Accepted F3-10 creation installs known-unbound; accepted F3-11 assignment installs known-task. Copy it when revisions advance, never clear the association on reassign/cancel/complete/fail. Existing transition validation still refuses reuse. Agent scopes have no association. This is one fixed-size hint per existing context, not a second lifetime task map. Sources: P1/P3; `internal/core/agents/service.go:46-75`; `internal/core/agents/replay.go:175-232`; `internal/core/agents/scoped_tasks.go:161-170`; ticket corruption/discard criterion `.scratch/dwarf-harness/issues/140-bound-the-private-state-services-replay-and-lookup-cost.md:35`.

`contextTask` keeps its general-context answer. At the current represented prefix, a valid known-unbound hint answers unbound; known-task loads the **latest task**, not its old assignment, so activeWorkTask denies the old assignee/generation. Missing/invalid hint runs the original authoritative context scan and restores the hint only for that captured current prefix. `assignmentUnused` retains independent context/assignment-ID booleans. F3-12 terminalization never erases association. Historical prefixes not represented by the projection retain the original scan, never a future hint. Sources: `internal/core/agents/scoped_state.go:195-213,275-305`; `internal/core/agents/scoped_work.go:189-207`; `internal/core/agents/review_plan.go:196-232`; `docs/CONTRACTS.md:132-138`.

Add one validity-qualified block for `maxTask`, `maxWork`, `maxGrant`, `maxAssignment` alongside existing maxima. Advance by bytewise maximum only after complete committed-group acceptance: task creation, work admission, grant issue, assignment introduction. Repeated assignment snapshots may widen the same maximum harmlessly, never introduce another identity. Above a **valid** namespace maximum proves unused; at/below it uses cache then authoritative scan. Missing/invalid block disables this shortcut until replay/one authoritative prefix scan reconstructs it; zeroed storage is not an absence proof. No clock restriction, cross-namespace uniqueness or refusal of fresh out-of-order IDs. Rebuild maxima/associations from zero with replay. Sources: P1/P3; `internal/core/agents/replay.go:279-289,342-372`; `internal/core/agents/review_plan.go:196-200`; `internal/core/agents/scoped_authority.go:194-213`; `docs/DECISIONS.md:677`.

### P2/P3: one typed historical cache

New `internal/core/agents/history_index.go`, no new package. Concrete key `{kind, UUID-or-sequence}`, closed kinds command/task/work/grant/review-request/assignment-exists/source-record. One `container/list`+map LRU, shared 256-entry/8-MiB ceilings. Negative answers count; charge retained encoded bytes and fixed key/stamp/seal bytes, bound entry count independently; oversize entries retain nothing. Live projections are separate and never evicted to fit. No private/object/body/credential bytes, source handles, permissions, plans or reservations. Sources: P2; `internal/core/ledgerstore/commands.go:50-103`; `internal/core/agents/service.go:18-24`; `docs/DESIGN-CORE-AND-LAUNCHERS.md:855-859`.

Private encoded values carry kind/key, `validFrom`, relevant effect sequence and completeness stamp, sealed with standard-library SHA-256 over **metadata and value**. Bind the cache/hints to their owning Service by private object identity, not a clock/random/generated ID; Open still samples no clock. This is memory representation only, no persisted/frozen format. Decode fresh values, verify seal/shape/key/binding/range; on failure discard and use the original ledger path. Do not JSON-marshal existing unexported state fields (that would lose them): use per-kind private wire structs with exported members mirroring **every** existing answer field. Command entries encode complete original group-record JSON plus commit bounds and reconstruct commandMatch through existing family decoders; source entries encode exact Record.JSON/hash/bounds. Task entries include record/sequence/descriptionSequence; work/grant/review entries include every current state member, optional result and replacement edge. Assignment answers include found and first-introduction commit. No alternative public encoding is created. Sources: P3; `contract/ledger/envelope.go:81-86`; `internal/core/agents/replay.go:377-411`; `internal/core/agents/scoped_state.go:11-32`; `internal/core/agents/review_state.go:12-54`; `docs/DECISIONS.md:127,675-677`.

Use this same sealed-metadata convention for P1's context hint/maxima and P5's remembered slot digest: seal owning agent/context/slot or namespace, known/valid flag, value and **last relevant accepted commit** stamp. Check before using proof; invalid/missing means authoritative fallback, not healthy/unbound/unused. One global whole-commit coverage cursor advances after all relevant updates, while unchanged per-context hints retain their stamps/seals; never rewrite every context per commit (that would restore scope×history work). A hint serves only the current fully processed projection prefix, with its last-relevant stamp ≤ that prefix. Plain replay constructs hints even with LRU disabled. Keep small hint encoder/checker with Service in S1, consolidate into history_index.go in S2: one convention, no second cache. Sources: P1/P3/P5; ticket `.scratch/dwarf-harness/issues/140-bound-the-private-state-services-replay-and-lookup-cost.md:34-36`; `docs/DECISIONS.md:675-677`.

Cache has a whole-commit `validatedThrough`. Mutable answers may serve only `validFrom ≤ requestedThrough ≤ validatedThrough`, after invalidating/updating every intervening effect that could change the answer. `validFrom` is the prefix where a cold answer was established, or accepted effect's commit end for an installed state. Earlier historical queries fall back. Immutable command/source answers require their entire commit inside the requested interval/prefix. `findCommand` preserves `(after, through]` and duplicate detection; only answer from cache when the searched interval is wholly validated. Unvalidated tails and partially-read intervals retain the original reader and do not establish absence proofs. Sources: P3; `internal/core/agents/replay.go:262-289,386-411`; `internal/core/agents/review_execute.go:185-211`.

**Unlocked cold-fill rule:** a mutable/negative result scanned at captured prefix T may enter the cache only if validatedThrough is still exactly T when acquiring cache mutex for insertion. Otherwise return it only through the existing caller/tail-recheck protocol and do not cache it; never overwrite a newer invalidation with a late old scan. Immutable positive source/command metadata may be inserted after advancement only when its complete commit was in the validated prefix and its key/range remains valid. No cache lock across the scan. Sources: P3; `internal/core/agents/review_execute.go:185-211`; `internal/core/agents/replay.go:240-262,386-411`.

Before publishing a complete accepted commit's new projection/cache cursors:

| Effect | Cache invalidation/update |
|---|---|
| Every F0 command, including non-service-family command | Invalidate its negative; install original immutable command/group match after acceptance, including family-absent answers/digest semantics. |
| Grant issue/revoke | Replace/invalidate that ID, including pruned/revoked grant state. |
| Task create/direct mutation | Keep latest complete snapshot and original description sequence even if live pruning drops it; invalidate cached requests bound to that task (may become stale). |
| Review request/replacement/result | Invalidate/update request ID, replaced ID and task-bound cached requests as applicable. Preserve original result on a resolved old request followed by replacement. Approve/fail use existing `taskAfterReview` for cached tasks; reject does not terminalize. |
| Work admission/dispatch/end | Replace/invalidate that work, including released state removed from live projection. |
| Assignment introduction | Invalidate assignment-ID negatives; install known-task hint on the existing context; repeated snapshots introduce no identity. |
| Source | Retain copied immutable requested/source metadata only from accepted complete commits/validated reads, never tentative drafts. |

Sources: `internal/core/agents/replay.go:262-411`; `internal/core/agents/scoped_plan.go:68-160`; `internal/core/agents/review_state.go:12-54`; `internal/core/agents/review_plan.go:196-232`; `internal/core/agents/scoped_state.go:68-185`; `docs/CONTRACTS.md:140-151`.

Keep live-map precedence in loadTask/loadWork/loadGrant **when requestedThrough is the current projection prefix**; deliberately older prefixes take their original authoritative prefix scans, never future live values. Cache cold answers without promoting terminal history into live state. loadReview preserves replacement/stale logic. Cold command/request/status/retries share this cache, no second receipt cache. F3-13 paid attempt/credential caches and money logic remain unchanged; its shared lookup calls can benefit. Sources: `internal/core/agents/scoped_state.go:68-185`; `internal/core/agents/review_state.go:12-54`; `internal/core/agents/paid_state.go:114-149`; `docs/CONTRACTS.md:140-151`.

**Locking:** retain Service.mu and scope-gate order. New cache mutex protects bytes/LRU/cursor only; lock order `Service.mu → cache mutex`, never reverse. Release it before I/O. Existing unlocked lookups copy answers under cache mutex and retain their tail scan/caller recheck when rejoining Service.mu. A prefix older than an entry's validity falls back rather than silently refreshing it. A source cannot exceed the caller's through. Close still fences/drains active calls before clearing cache; each Open creates a new incarnation. No new goroutine/channel/waiter. Shared-state additions trigger D152 local race evidence. Sources: `internal/core/agents/service.go:113-128,177-208`; `internal/core/agents/review_execute.go:180-220`; `internal/core/agents/scoped_execute.go:239-276`; `docs/DECISIONS.md:3032`.

**Space:** ≤8 MiB retained encoded cache bytes plus bounded decoding/transient values and ≤256 nodes. Associations/materialization hints are O(existing contexts/scopes), maxima O(1). Required live grants/tasks/holds, identity maps and reconciliation output are not cache-budgeted; lifetime disk retention is unchanged. Cold fallback can remain O(H); no constant-total-memory/all-workload-constant-latency claim. Sources: `docs/DECISIONS.md:675-677`; `docs/DESIGN-CORE-AND-LAUNCHERS.md:855-859`; `internal/core/agents/scoped_plan.go:92-160`.

## Replay, corruption safety and startup history validation

### P5/P6: current-state paths

Retain one **last successfully materialized committed digest** per Markdown slot as a P3-qualified hint in scopeState, copied with revisions like materials. It is only same-slot historical-membership proof: still hash/read every actual selected object and freshly observe actual Markdown. Current digest → current; missing → stale; matching valid remembered digest → stale; wrong-kind/link/unreadable → existing refusal; unmatched regular digest or invalid hint → streaming same-scope/same-slot ledger-membership check before declaring foreign. Do not allocate lifetime digest arrays. A hint never clears an issue or blesses other-slot/context bytes. Update it only after successful durable materialization under the existing projection fence. Sources: P5; `internal/core/agents/integrity.go:16-49,176-253`; `internal/core/agents/materialization.go:62-114`; `internal/core/agents/replay.go:175-216`.

Turn start already holds agent then context scope gates across inspection/final admission; retain both gates and final private-state checks. `inspectLive` inspects all current selected heads of its scope; agent-wide issues still fence contexts. Never cache “healthy”: deletion/tampering after success must fail the next new operation. Matched historical receipts retain existing authority/dedup/wait ordering, with no new integrity/capacity requirement. Sources: `internal/core/agents/scoped_execute.go:91-111,239-276,295-319`; `internal/core/agents/scoped_access.go:322-328`; `internal/core/agents/commands.go:165-184,244-267`; `internal/core/agents/doc.go:73-86`.

For `selectPrivateRead`, capture immutable current revision/heads at the caller's captured prefix. Requested revision equals current, slot not transcript, and captured prefix equals the represented projection prefix → derive existing privateSelection directly (exact digest/bytes/revision/sequence, absent after clear, unchanged MaxBytes errors). Apply the same exact comparison in `validatePrivateSelection`; hash alone is insufficient. Old prefix/revision, transcript/cursor and pagination retain current `scopeHistory` selection. Equal-hash transcript chunks stay separate occurrences. No future state may answer an older prefix. Sources: P6; `internal/core/agents/read.go:107-181`; `internal/core/agents/scoped_private.go:77-136`; `internal/core/agents/doc.go:43-49`.

`sourceRecords` keeps positive-sequence/through checks and deduplication. Resolve usable immutable source-cache hits; one existing segment-aligned batch covers **remaining** sequences, then combine only requested results. Preserve unavailable/type/digest/size checks, no per-witness reread or body I/O. Cache only complete validated-prefix results. Replay may seed accepted sources; a later-prefix live cache entry cannot supply a future witness to an earlier reducer prefix. Sources: P6; `internal/core/agents/review_sources.go:11-90`; `internal/core/agents/review_authority.go:85-113`; `.scratch/dwarf-harness/c3-evidence/ticket-12-design-ruling.md:25,54`.

### P4: fused startup inspection

After ordinary full-group replay to captured store.Durable, replace Open's per-scope history/digest scans as follows:

1. Sort scopes as today; obtain owning paths/current heads. Observe each current Markdown slot once, keeping kind/digest/error and one `seenCommittedSameSlot` boolean. Missing is stale; wrong-kind/unreadable retains refusal. Regular non-head bytes are initially **unclassified**, not immediately foreign. One observation per fixed slot, no lifetime history.
2. One global `s.scan(ctx, 0, p.through, ...)`: decode complete families, obtain both private forms through `scopedRevisions`, visit changes in ledger/change order. Every non-clear occurrence uses existing owning-path `readObject`/`objectIssue`; no superseded-object skip or occurrence deduplication. Match observed Markdown digest against that exact scope+slot's committed changes.
3. Buffer issues by scope in original occurrence order; flush in old sorted-scope order. Current-head failures and **any transcript occurrence** fence. Superseded non-transcript failures are reported but do not alone fence healthy latest heads. Preserve exact owner binding/revision/digests/reasons.
4. Scopes without fencing issues get existing current-head verification/completion using those observations/membership, **without another history scan**. Reobserve before completion; if regular bytes changed, classify the new observation (fallback to ledger membership if unmatched), never overwrite using stale proof. Preserve beforeMaterialize/beforeProjection, Completed/Issues order, errors, availability and remembered committed digest.
5. Preserve pending work/paid/credential reports and return/error categories. Open reads no clock/secret/provider-object bytes; appends, charges, releases and dispatches nothing.

Sources for steps 1–5: P4; `internal/core/agents/integrity.go:120-168,176-253`; `internal/core/agents/scoped_plan.go:173-185`; `internal/core/agents/service.go:155-175`; `internal/core/agents/doc.go:25-34`; `docs/CONTRACTS.md:108-151`.

Fused inspection is **not a second task/paid reducer or replay shortcut**. F3-10/F3-11 keep their common head, F3-12 its shared task transitions, F3-13 its child endings/units. Keep envelope/group/actor/binding/CAS/predecessor/usage checks, consumed-version refusal, unknown-family handling, store half-tail recovery and poison behavior. No rejected group advances maxima/cache completeness/p.through; no successful partial Service after error/cancellation. Sources: `docs/CONTRACTS.md:108-151`; `internal/core/agents/replay.go:262-375`; `internal/core/agents/scoped_replay.go:30-68`; `docs/DESIGN-CORE-AND-LAUNCHERS.md:851-859`.

**Safety proof:** induction on complete accepted commits. Prior state/cache is ledger-derived; unchanged reducer judges next group at first−1; only prefix-valid answers substitute data reads, never permission. Acceptance installs same effects and invalidation, then publishes cursors. Old/equal-ID misses still consult history, so eviction cannot erase duplicates/revocations/assignments. Review results use existing taskAfterReview. Live integrity reads real files; global inspection checks every historical occurrence with unchanged current/transcript fences. Cache discard changes cost alone; no on-disk index exists, and invalid-cache recovery appends/dispatches nothing. Sources: P1–P6; `docs/DECISIONS.md:675-677`; `internal/core/agents/replay.go:262-375`; `internal/core/agents/integrity.go:144-166`; `internal/core/agents/review_plan.go:196-232`.

**Cost model, not measurement:** context association O(1)+task load; above-max new identity O(1); repeated cache lookup O(value bytes); current non-transcript selection O(fixed slots); normal live integrity O(current object/Markdown bytes). Startup removes scope×history: reducer plus one occurrence pass/completion, approximately O(H+historical private bytes+scopes), **plus existing live-grant/chain/planning work and cold misses**. Review grant enumeration remains O(G); evicted witnesses/historical reads may scan segments/history. No universal linear theorem for growing live grants/adversarial churn: unchanged-driver scaling is an empirical gate. Sources: `internal/core/agents/scoped_tasks.go:37-55`; `internal/core/agents/scoped_plan.go:94-160`; `internal/core/agents/review_sources.go:11-90`; `.scratch/dwarf-harness/c3-evidence/ticket-12-design-ruling.md:25,54`; `docs/DECISIONS.md:677`.

## Implementation slices and owned paths

These are future implementation ownership, not permission for this designer to edit the repository. S1→S2→S3 is sequential where paths overlap; each tip is complete behavior, no exported stub. Each slice has a fresh coder/reviewer. Sources: P9; `docs/DECISIONS.md:3033-3044`.

### S1 — context association and fresh-ID absence

Product files: `internal/core/agents/{service.go,replay.go,scoped_state.go,scoped_plan.go}`. Implement P1 and its P3 validity-qualified hints/maxima, including both contextTask and assignmentUnused, above-watermark fast paths, and accepted-group installation. At/below-watermark IDs still take original scans until S2; no temporary second cache. Keep repeated planning/final checks. Sources: P1/P3/P7 and their cited implementation.

New regression file `internal/core/agents/history_index_test.go`, reusing existing real-store fixtures:
- `TestHistoryIndexContextBinding`: never-bound work context behaves unchanged; reassign then terminalize a task, and prove old contexts cannot start/mutate/rebind before and after reopen, including when the context hint is deleted/corrupt. Check current assignment, denial, ledger frontier and occupied exposure.
- `TestHistoryIndexIdentityReuse`: fresh out-of-order IDs at/below maxima remain usable; truly reused task/work/grant/assignment IDs still refuse, including terminal history and discarded/corrupt maxima. Command/request namespaces remain separate. Check no refused command/effect/charge was committed.
- `TestHistoryIndexFamilyTransitions`: task completed/failed by F3-12 cannot become active/unbound again through the new association path; preserve latest version, original description source and old-assignment refusal.

Sources: `internal/core/agents/scoped_state.go:68-213,275-305`; `internal/core/agents/scoped_work.go:189-207`; `internal/core/agents/review_plan.go:196-232`; `.scratch/dwarf-harness/c3-evidence/ticket-11-design-ruling.md:39-45`; `docs/CONTRACTS.md:117-138`.

### S2 — unified bounded history and witness cache

Product files: new `internal/core/agents/history_index.go`, and existing `{service.go,replay.go,scoped_state.go,scoped_plan.go,review_state.go,review_plan.go,review_sources.go}` in the same directory. Implement P2/P3 and source portion of P6; all command/task/work/grant/request/assignment/source callers use this one implementation through existing helpers. F3-13 producer/accounting/credential/paid-cache files are not owned. Sources: P2/P3/P6 and their cited implementation.

Extend only `history_index_test.go` unless an existing named behavior test needs a narrowly targeted missing row:
- Extend S1 cases to force eviction before reuse/old-context access and repeat with caching disabled.
- `TestHistoryIndexPrefixAndDiscard`: warm an entry at a future prefix; earlier-prefix replay must not use it. Warm correct metadata, then inject stale/key/binding/damaged-seal entries, clear/evict/disable cache, and repeat command/request/task/source queries and reopen. Assert immutable receipts, exact versions/bytes, denied/unavailable answers and unchanged durable effects/book, not hit counters.
- `TestHistoryIndexReviewHistory`: cache pending/rejected/resolved requests and tasks; replacement and direct task mutation invalidate appropriately. Resolved old request keeps original result after replacement; approve/fail remain terminal after eviction/reopen; reject stays nonterminal. Exact source sequence/type/hash/size mistakes must not pass a warmed witness.
- `TestHistoryIndexLookupRace`: use deterministic existing hooks/channels to race unlocked duplicate lookup against winning commit/revocation/replacement. Original tail scan/current authority still governs: one effect/charge, no stale disclosure or deadlock.

Sources: `internal/core/agents/review_state.go:12-54`; `internal/core/agents/review_execute.go:180-220`; `internal/core/agents/review_sources.go:11-90`; `.scratch/dwarf-harness/c3-evidence/ticket-12-design-ruling.md:37-40`; `docs/DECISIONS.md:3032-3034`. Direct cache manipulation is only fault setup; observable contract assertions earn the tests.

### S3 — private current heads and fused startup

Product files: `internal/core/agents/{integrity.go,materialization.go,service.go,replay.go,read.go,scoped_private.go,doc.go}`. Implement P4/P5/current-selection P6; preserve current scope gates and completion hooks. Update only now-obsolete package cost paragraphs, including private scans, review cold/witness cost and paid Limits' inherited contextTask sentence. No new disk file/API/command/snapshot. Sources: P4–P6; `internal/core/agents/doc.go:25-34,73-92,309-334,584-593`.

Regression files: existing `recovery_test.go`, `private_test.go`, `scoped_private_service_test.go`, `scoped_read_service_test.go`, and `history_index_test.go` for cross-prefix selection. No new fixture framework.
- `TestPrivateIntegrityAfterWarmCheck` in `recovery_test.go`: warm successful live inspection, then corrupt/remove current object/Markdown; next new operation still refuses/fences. Wrong-kind/link traversal remains refused; remembered digest cannot hide tampering.
- `TestPrivateFusedHistoryInspection` there: superseded non-transcript corruption/missing is reported without fencing healthy latest heads; any missing old transcript fences; report binds exact scope/slot/revision/digests in deterministic sorted-scope/occurrence order. Both revision families, other-slot/scope equal digests and agent-wide fences are exercised. Stale/absent Markdown completes without append; foreign remains blocked.
- `TestPrivateCurrentHeadSelection` in `scoped_read_service_test.go`: current exact head/clear/MaxBytes boundary, old revision, transcript duplicate-hash occurrences/cursor/pages give identical bytes and ledger-selected metadata through read and replay with empty/warm cache. No future head at an older prefix.
- `TestPrivateCurrentHeadProjectionFence` in `scoped_private_service_test.go`: pause existing beforeProjection hook, overlap duplicate/new start, inject completion failure/cancellation; acknowledgement, same-scope waiting, one receipt/charge and Close draining stay unchanged.

Sources: `internal/core/agents/recovery_test.go:70-165,166-245,297-344,379-410`; `internal/core/agents/private_test.go:267-276`; `internal/core/agents/scoped_private_service_test.go:113-119,208-212`; `internal/core/agents/read.go:119-181`; `internal/core/agents/scoped_private.go:77-136`; `docs/CONTRACTS.md:108-151`.

Keep these **existing** four-family tests (no new golden/regeneration): TestPrivateFrozenGoldenReplay (`internal/core/agents/replay_test.go:29`), TestScopedFrozenGoldenReplay (`internal/core/agents/scoped_golden_test.go:198`), TestReviewFrozenGoldenReplay (`internal/core/agents/review_replay_test.go:110`), TestPaidGroupRulesAndFrozenReplay (`internal/core/agents/paid_replay_test.go:29`). F3-13 uses D149's corrected golden. Existing injected suites stay unchanged: TestPrivateInterruptedRecovery (`internal/core/agents/crash_test.go:41`), TestScopedInjectedCrashRecovery (`internal/core/agents/scoped_crash_test.go:39`), TestReviewInjectedCrashRecovery (`internal/core/agents/review_crash_test.go:37`), TestPaidInjectedCrashRecovery (`internal/core/agents/paid_crash_test.go:110`). They exercise shared-path regression support, **not ticket13 whole-ticket verification/close**. Sources: those tests; `docs/CONTRACTS.md:108-151`; `docs/DECISIONS.md:2990-2996`; `docs/ROADMAPS.md:171`.

The PM measures the final tree and owns fuzzing/evidence/integration; close drafter owns ticket/B/evidence/status edits. Public doc.go states implemented costs and remaining cold paths, without private links/quotes/personal paths or machine details. Sources: `docs/ROADMAPS.md:236`; `docs/DECISIONS.md:3032-3044,3057-3069`; `.scratch/dwarf-harness/c3-evidence/ticket-11-evidence.md:220-243`.

## Evidence recipe and deterministic acceptance bounds

### Coder evidence, serially

Use **go1.27.3**, `GOTOOLCHAIN=local`, `GOFLAGS=`, ordinary `CGO_ENABLED=0`, no module change. PM controls local machine reservations; no overlapping local tests/fuzz/measurements. Each coder formats only its changed Go files, records `gofmt -l` output for those files, then from module root:

```text
go test -count=1 -timeout 30m -v ./internal/core/agents -run '^TestHistoryIndex'
go test -count=1 -timeout 30m -v ./internal/core/agents
go vet ./internal/core/agents
go tool staticcheck ./internal/core/agents
```

The first command is S1/S2's focused set. S3 substitutes this exact focused regex:

```text
go test -count=1 -timeout 30m -v ./internal/core/agents -run '^(TestPrivateIntegrityAfterWarmCheck|TestPrivateFusedHistoryInspection|TestPrivateCurrentHeadSelection|TestPrivateCurrentHeadProjectionFence|TestPrivateFrozenGoldenReplay|TestScopedFrozenGoldenReplay|TestReviewFrozenGoldenReplay|TestPaidGroupRulesAndFrozenReplay|TestPrivateInterruptedRecovery|TestScopedInjectedCrashRecovery|TestReviewInjectedCrashRecovery|TestPaidInjectedCrashRecovery)$'
```

All three slices change shared projection/cache state, so each additionally runs whole-package race and ×20 **affected concurrency rows**, with the already-pinned local race compiler; `CGO_ENABLED=1` only for race:

```text
go test -race -count=1 -timeout 30m -v ./internal/core/agents
```

S1 affected ×20 rows:
```text
go test -race -count=20 -timeout 30m -v ./internal/core/agents -run '^(TestScopedTaskClaimAndReassignCAS|TestScopedDispatchRevocationRace)$'
```
S2:
```text
go test -race -count=20 -timeout 30m -v ./internal/core/agents -run '^TestHistoryIndexLookupRace$'
```
S3:
```text
go test -race -count=20 -timeout 30m -v ./internal/core/agents -run '^TestPrivateCurrentHeadProjectionFence$'
```

Use host vet/staticcheck (no owned build-constrained files), per-test verbose logs and final file hashes. Rule breaks only for authority/disclosure/crash-sensitive cases (money only if a genuinely affected shared path): a real missing old-context/invalidation/fence check must make its named test red, byte-identical restore green. No timing/source-text assertions or artificial performance mutation. Coders run **no local full tools/check, timed fuzz, or measurement driver**. Sources: `docs/DECISIONS.md:2951-2960,3032-3034,3059-3066`; `.scratch/dwarf-harness/c3-evidence/ticket-11-design-ruling.md:41`; `.scratch/dwarf-harness/c3-evidence/ticket-11-evidence.md:216`; P9.

PM runs 120-second campaigns only on actually affected reachable fuzz paths, selecting from FuzzPrivateGroupReplay (`internal/core/agents/replay_fuzz_test.go:14`), FuzzScopedGroupReplay (`internal/core/agents/scoped_replay_test.go:540`), FuzzReviewGroupReplay (`internal/core/agents/review_fuzz_test.go:13`), FuzzPaidGroupReplay (`internal/core/agents/paid_fuzz_test.go:13`). Inspect reachability through changed shared helpers: do not automatically add unrelated codec/provider fuzzers. For each selected exact TARGET:

```text
go test -count=1 -timeout 30m ./internal/core/agents -run '^$' -fuzz '^TARGET$' -fuzztime=120s -parallel=1
```

Replace TARGET with the selected existing symbol, preserve failing inputs, record actual target/elapsed/executions/result. Sources: named fuzz targets; `docs/DECISIONS.md:3032`; P9.

### PM unchanged-driver recipe

Saved T11 driver is byte-for-byte unchanged (all three source hashes retained). Its provenance is `.scratch/dwarf-harness/c3-evidence/ticket-11-evidence.md:220-243`. Copy the package into PM-owned untracked `_t140_t11_measure/` **under module root**, so internal imports work. Only flag is -out, a new absolute output/colony directory:

```text
go run ./_t140_t11_measure -out <new-absolute-evidence-directory>
```

The unchanged program supplies populations12→20, held turns1→3, burst16, same ten-operation growth cycle, smoke_log profile, growth to original long history, long_log profile. Original profile lengths **87/874 commits**; records can differ per run (coder289/2965, PM293/3003). Record actual frontiers; never edit traffic to force a record count. If the unchanged program does not reproduce original commit endpoints, retain it and ask advisor/PM to resolve reproducibility before acceptance; do not silently choose shorter history. Its profiled requests are **single samples**, not p50 estimates; summary p50/p95 refer to different aggregate phases. Sources: P8; `.scratch/dwarf-harness/c3-evidence/ticket-11-evidence.md:220-243`.

Saved **T12 S5** package goes unchanged in PM-owned `_t140_t12_measure/` under module root. Default factor2, populations12,20, four CPU profiles:

```text
go run ./_t140_t12_measure -profiles <new-absolute-profile-directory>
```

Keep S5's saved label-only edit and its hashes, not S4's older bytes; no workload change or label cleanup. Built-in from-zero/segment-aligned probes reimplement **old** readers, not production cache, and must be labelled accordingly. Report actual H/N/G/terminal-grants and scope counts at both lengths. No mandatory review factor10 rerun: that was historical supplementary evidence, not T140's primary workload. A further long run needs a named advisor measurement question and PM/owner machine window. Sources: `.scratch/dwarf-harness/c3-evidence/ticket-12-evidence.md:318-393`; `.scratch/dwarf-harness/issues/140-bound-the-private-state-services-replay-and-lookup-cost.md:57-62`.

Same toolchain/environment for base and candidate. Base is supplied `93e8f0afe125b1ea8e87f4b8336664dd390c5b3a`, not pre-ticket13 historical binary. PM captures one quiet complete baseline per driver; old measurements are provenance, not substituted controls. Final candidate: **three independent complete runs of each**, new colonies/directories, serially, all samples retained. Record 5-second process CPU-delta observations immediately before/after. P8's fixed quiet criterion: no other local test/fuzz/check/driver overlap, and summed unrelated-process utilization ≤0.25 CPU core in both observations. If above before, postpone; if overlap/interruption or post-observation above, retain/label run loaded-invalid before assessing acceptance and replace. Never invalidate merely because timing is slow. Do not flush filesystem cache/change machine settings or alter profiler behavior. Sources: P8; `.scratch/dwarf-harness/c3-evidence/ticket-11-evidence.md:222-229`; `.scratch/dwarf-harness/c3-evidence/ticket-12-evidence.md:325-331,369-380`; `docs/ROADMAPS.md:234-235`.

### P8: preregistered finite acceptance

For run i, actual Open frontiers contain Hs_i/Hl_i records; `R_i=Hl_i/Hs_i`. T11 reads `agents_ms` from event=open at smoke_log/long_log, and milliseconds from each corresponding request event. Task cancel is the **profile_cleanup cancellation immediately after each profile**, not a nonexistent task.cancel row in the profile phase. Preserve extra post-profile records separately; never redefine startup's denominator.

| Item | Exact final-run bound |
|---|---|
| T11 Open, primary | `median_i(OpenLong_i/R_i) ≤ median_i(OpenShort_i)`. Store Open is reported separately, not an acceptance denominator. |
| turn.start | `median(long) ≤ 2×median(short)+25 ms`. |
| local.admit | Same formula, its own request rows. |
| local.begin | Same formula, its own request rows. |
| task.create | Same formula, its own request rows. |
| task.cancel | Same formula, paired profile_cleanup rows. |
| T12 supplementary Open | Same history-normalized startup bound at baseline/grown, H/N/G/scopes reported. Failure escalates, not waived because supplementary. |
| T12 review/cold paths | Report approve/failure/request and first old command/request lookups, witnesses/profiles at both lengths and base-vs-final. Coverage, not invented API latency SLA. Added ordinary-path history scans or revived S5 bottleneck block even if a median passes. |

Operation tolerance is **P8's proposed fixture engineering choice**: near-flat cost versus the old4.5–9.4×, with 25-ms finite short-sample/serialized-storage jitter allowance, not a historical measured bound or capacity/SLA. Startup gets no exponent tolerance: report raw times, normalized costs and `log(OpenLong/OpenShort)/log(R)`.

**Fixed noise resolution:** after3 runs, if paired differences straddle zero **and** median is within10% of its bound, run exactly2 more complete instances of that driver; decide on all5 medians, unchanged bounds. Startup difference is long/R−short; operation difference long−(2×short+25ms). Clearly above, or still above after5, fails. Preserve spread and admit3/5 samples establish no tail/confidence/SLA claim. Missing/unexpectedly refused/semantically inconsistent samples fail, never count as zero; never substitute aggregate-phase rows. Sources: P8; `.scratch/dwarf-harness/c3-evidence/ticket-11-evidence.md:225-243`; `.scratch/dwarf-harness/c3-evidence/ticket-12-evidence.md:369-380`.

Retain raw stdout/stderr, source/product hashes, exact commands/environment/final SHA, all profiles, statuses, histories/bytes/scopes, heap/process/allocation figures and unmeasured quantities. Label both reports **admission and storage only**, preserving T12's bookkeeping label. No provider credentials/calls/executor, runtime capacity, power-loss or delivery claim. After saving copies/hashes, PM removes only owned throwaway source packages before hosted checks. Sources: `.scratch/dwarf-harness/c3-evidence/ticket-11-evidence.md:220-243,271-278`; `.scratch/dwarf-harness/c3-evidence/ticket-12-evidence.md:318-380`; `docs/DECISIONS.md:3032`.

**Merge:** each final slice SHA needs fresh D152 blocking-standard review and successful hosted **Check result**, full Windows/Linux/macOS matrix including race, before ff-only main. Fix/rebase needs its own exact-SHA result; pending/failing/cancelled/missing aggregate never counts. No additional routine local full check. Sources: `docs/DECISIONS.md:3034,3057-3066`; `docs/ROADMAPS.md:229`.

## Imports, non-goals and stop gates

**Imports:** no new nonstandard import/module. Current production already includes contract/ledger, contract/ledger/appender, Core credentials/durable/ledgerstore/providers; tests additionally workspace and native-credential-only x/sys/windows. That is current tree, not ticket10's obsolete narrow list. New cost code needs standard library (container/list, bytes/context/encoding/json/crypto/sha256/sync/uuid as needed) plus existing ledger/store types, no paid/OS/import-boundary exception. Honor `tools/check/boundary.go:46-54,73-84,120-130`; D29/B3 stay scoped (`docs/DECISIONS.md:122-132,675-676`).

**Disk/layout:** existing log/body/private-object/Markdown layout unchanged. No persistent cache/index/state.json authority/journal/snapshot/task directory/migration/repair command/new record/frozen rule/golden/module/paid/provider behavior. No scheduler/executor/retry/validation/promotion/GUI work. Do not drop old objects/records/receipts/pending work/paid holds or live state to meet space/timing budgets. Sources: `.scratch/dwarf-harness/issues/140-bound-the-private-state-services-replay-and-lookup-cost.md:22-37`; `docs/DESIGN-CORE-AND-LAUNCHERS.md:855-863,916-930`; `docs/CONTRACTS.md:108-151`.

**Stop/escalate, never weaken acceptance:**
- Prefix/invalidation cannot preserve reducer outcomes, an issue/fence is lost, a family golden/crash changes, or authority/privacy/money/recovery regresses: bring exact failing case to reviewer/PM. Never suppress issue, skip phase/check or accept incomplete history.
- Minimal mechanism misses bounds: PM retains logs/profiles, seeks a **bounded advisor amendment naming remaining measured path and owned files/slices**. First improve existing index/pass; snapshot/broader grant index needs fresh ruled design/corruption proof. No arbitrary cache enlargement, reduced traffic/length, reclassified sample, waived supplementary failure or relaxed tolerance.
- Frozen/API behavior, dependency/toolchain/workflow/machine/key/money/account/promotion-boundary action: named owner gate, not advisor substitute.
- Same failure persists after two actual fix attempts: report reproduction/attempts/evidence to PM; do not broaden ownership or alter check timeouts.

Sources: `docs/DECISIONS.md:677,3032-3040,3059-3069`; `docs/ROADMAPS.md:230-235`; `.scratch/dwarf-harness/issues/140-bound-the-private-state-services-replay-and-lookup-cost.md:34-41`; P4/P8.

**Fresh-advisor questions:** rule P1–P9, particularly bounded cache/prefix design P2/P3, two-pass inspection P4 and finite bounds/noise P8. No owner-only question currently triggers. This is design/evidence instruction, not a claim that code/measurements ran.
