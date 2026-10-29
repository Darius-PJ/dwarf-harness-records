# Ticket139 — shared-resource and work-domain registration through Core

## Owner summary

Build an additive **F3-139**, with four version-1 record types and a separate schema-5 canonical submission. The trusted owner/host `Service` registers/revises external shared resources and work domains and replaces scoped declarations; there is no corresponding `Agent` capability. A shared resource's UUIDv7 is also the opaque key of its existing F3-11 `external` Resource. Registration never creates a grant or becomes a prerequisite of an older operation. Three dependent slices: contract and freeze; Core reducer/producer/queries; genuine recovery/adversarial regression work. **These are recommendations for the advisor, not decisions already made.** [`.scratch/dwarf-harness/issues/139-register-shared-resources-and-work-domains-through-core.md:22-40`; `docs/DECISIONS.md:2715-2724`; `contract/ledger/doc.go:1784-1828`]

Scope is explicit agent-ID audience, not permission. Declarations name a pinned registration version and a complete replaceable set of task/context consumers; an empty set withdraws current links without a new retirement API. Historical snapshots remain available through owner-only typed queries. Payloads contain identities, versions and scope only: no display text, URL, account name, credential, private bytes or provider configuration. These choices are detailed as P2–P6 below, including their alternatives. [`docs/DESIGN-UNDERCURRENT.md:171-194`; `contract/ledger/doc.go:1878-1900`; `docs/DECISIONS.md:2715-2716`]

Design against supplied main `93e8f0afe125b1ea8e87f4b8336664dd390c5b3a`; assigned worktree/branch are `C:/Users/darius.jones/worktrees/dwarf-harness/139-registration` / `build/139-registration`, with creation coordinated by the primary. This artifact is design only: no repository edits, commands, freeze, implementation or observed evidence. All workloads remain testing-only. No graph, resource-use facts, provider work, view, new dependency or competing Ticket140 cache is authorized. [assignment and parent coordination message; `.scratch/dwarf-harness/issues/139-register-shared-resources-and-work-domains-through-core.md:14-31`; `docs/ROADMAP-CORE.md:13-17`]

## 1. Source-grounded scope and acceptance map

The ticket's six criteria, rather than completion of C3/U3, are the acceptance boundary. B32 assigned this producer to C3; D142 explicitly added the declarations that assign a resource/domain to a task/context. The family unblocks those producer inputs only, not Ticket61's graph or Ticket15's actual-use evidence. [`docs/DECISIONS.md:2678,2715-2718`; `docs/ROADMAP-UNDERCURRENT.md:270-310`; `.scratch/dwarf-harness/issues/61-turn-bounded-artifact-and-usage-evidence-into-atomic-causal-graphs.md:29-34`]

Citation notation: `ticket139:<lines>` means `.scratch/dwarf-harness/issues/139-register-shared-resources-and-work-domains-through-core.md:<lines>`. “Ticket140 ruling” means the exact primary-session `local/t140-ruling.md` path supplied in `local://t139-design-assignment.md`; relevant cited lines are 28–42 (boundary), 70–153 (single cache/publication/global lookup) and 258–332 (owned slices). Assignment/parent-message citations concern only the explicit task/coordination constraints, not an invented repository requirement.

| Ticket139 criterion | Specified deliverable | Permanent proof (§8) |
|---|---|---|
| 1: owner transitions, binding, CAS, durable receipt; no agent expansion | §3 owner-only entrances; §4 schema-5 binding; §5 common preflight/replay and commit protocol | AuthorityAndIdentity, VersionCAS, GroupRules, CommitRetryAndClose |
| 2: existing F3-11 address; opaque non-secret identity | P2; exact `external` kind and UUID key; no frozen Resource change | AuthorityAndIdentity, GrantsRemainIndependent; contract payload vectors |
| 3: scoped/versioned evidence and every cursor | P3–P5; complete snapshots, pinned subjects, replacement sets; §6 historical queries | DeclarationHistory, VersionCAS; frozen golden through actual Open |
| 4: specified/frozen additive family; earlier families unchanged | §4 exact four payloads, caller/consumer/privacy and fixture; S1 freeze before S2 | Payloads, Compatibility, GoldenF3_139, FrozenReplay |
| 5: inert ledger restart, committed-only recovery, actual retry receipt | §5; no starts, pending registration or recovery append | InjectedCrashRecovery, CommitRetryAndClose, FrozenReplay |
| 6: real resource/domain and every declaration shape for Ticket61 | §4.5 golden's four source/consumer combinations plus revisions/withdrawal | GoldenF3_139, DeclarationHistory, FrozenReplay |

All proof names in this table are prefixed `TestRegistration` except contract tests identified in §8. They describe requested implementation evidence, not results. Permission/CAS/identity/history/recovery tests use a real `ledgerstore.Store` and `agents.Service`, following the ticket's verification boundary and existing fixtures. [ticket139:35-44; `internal/core/agents/scoped_service_test.go:13-78`; `internal/core/agents/scoped_golden_test.go:20-78`]

Earlier consumers remain intact, including F3-12's review-result task transitions and F3-13's paid children/book charges. T139 does not add a task transition, private head, work child or book charge; it uses existing current task lookup rather than reconstructing tasks from F3-11 alone. [`contract/ledger/doc.go:2073-2080,2275-2293`; `internal/core/agents/scoped_state.go:105-139`]

## 2. Numbered technical proposals and conditional owner gates

Every new technical selection in §§3–8 belongs to the following numbered proposal; the sources establish the obligation, while the recommendation settles its encoding/mechanism. No proposal changes an owner-reserved policy.

| Choice | Options considered | Recommendation and reason | Direct sources |
|---|---|---|---|
| **P1 — family and submission** | Extend schema 2's closed operations/receipt; generic registry; new producer-owned family | Four concrete F3-139 v1 types; schema **5**, separate submission/receipt; add `Defined()` entries. This follows the later-family separation without changing schema 1–4 or prior group rules. | `contract/ledger/doc.go:2010-2048,2231-2250,2515-2554`; `contract/ledger/catalogue.go:37-66`; `docs/DECISIONS.md:2134-2142` |
| **P2 — which resources and identity** | Re-register all five Resource kinds; external resources with arbitrary locator-like keys; external resources keyed by their opaque registration UUID | Register **external only**. `resource_id` UUIDv7 has exact address `Resource{Kind:"external", ResourceKey:resource_id.String()}`; no alias, URL, account or secret-derived key. Context/task/workspace/artifact already have identity producers and are private scopes, consumers or artifact nodes, not new external-resource registrations. Existing arbitrary valid external keys and all other Resource kinds remain valid grants; no migration or registration prerequisite. | `contract/ledger/doc.go:1784-1828`; `contract/ledger/scoped_values.go:203-304`; `docs/DESIGN-UNDERCURRENT.md:171-194`; `docs/ROADMAP-UNDERCURRENT.md:298-300`; ticket139:12,29-31,35-40 |
| **P3 — evidence scope** | New colony/role/scope hierarchy; reuse grant scopes as permissions; explicit audience agent-ID set | Required nonempty sorted distinct `audience` of registered agent IDs, reusing task-audience vocabulary. It is the owner's intended evidence scope, never an authorization grant. A declaration's audience is a subset of its pinned registration's audience and of each task consumer's audience; each context consumer's owner is in it. Owner may revise scope, including widening. No role-based or automatic future-agent membership. | `contract/ledger/doc.go:1878-1900`; `docs/DECISIONS.md:2666-2678,2715-2716`; `docs/DESIGN-UNDERCURRENT.md:173-176` |
| **P4 — versions and declarations** | Mutable records; one row per implicit edge; complete versioned replacement sets | Full snapshots; new entity expectation 0/version 1, revisions +1 with checked MaxInt64 bounds. `RegistrationRef{kind,id,version}` pins the exact current source version at declaration commit. Immutable declaration source kind/ID; explicit new source version, scope and whole consumer set on revision. Sorted unique consumers; `[]` withdraws the declaration's links. No history rewriting or inferred observed use. | ticket139:35-38; `docs/DECISIONS.md:2715-2716`; `contract/ledger/doc.go:1744-1755,1878-1900`; `docs/DESIGN-UNDERCURRENT.md:171-176` |
| **P5 — target and lifecycle meaning** | Pin every declaration to task assignment/generation; let task declarations migrate to contexts; identity-level task/context links | Task consumer names task ID, not assignment: it is a declaration about that task specification, survives reassignment, and never follows the assignee into a new context. Context consumer names exact registered Binding and never follows task reassignment. Existing unassigned and terminal tasks may be declared; this is evidence, not admission/use. No registration retirement/delete/deactivation API is required; declaration replacement/empty set covers withdrawal. | `docs/DESIGN-UNDERCURRENT.md:173-176`; `docs/DECISIONS.md:2670,2683-2686,2715-2716`; `contract/ledger/doc.go:1880-1900`; ticket139:37 |
| **P6 — entrances and disclosure** | New authentication/transport; generic actor-selectable mutation; agent-readable registry plus new grants; trusted owner-only typed API | Extend `Service` with concrete owner methods and typed owner current/historical/status queries. Host authenticates before obtaining/calling Service; `BindAgent` remains only a trusted-host binding. No Agent registration/query methods, new grant operations or raw ledger stream. No free-form labels/descriptions/locators are needed for stable nodes, avoiding an otherwise unnecessary secret-bearing surface. | `internal/core/agents/service.go:119-124`; `internal/core/agents/scoped_commands.go:52-74`; `contract/ledger/doc.go:1723-1732`; `docs/CONTRACTS.md:34-39`; ticket139:29-40 |
| **P7 — atomicity and retry** | New persistence/ack state; receipt from predicted sequence; reuse existing store/service protocol | One `Submit`: F0 command, one effect, registration receipt. Global command lookup before CAS/producer limits; match exact actor/origin/operation/digest/family; read actual committed receipt, refresh whole projection before ack. Use existing enter/active/Close and uncertain/poison handling, no durable acknowledgement marker. | `internal/core/ledgerstore/commands.go:42-51,130-161`; `contract/ledger/appender/appender.go:7-25`; `internal/core/agents/scoped_submit.go:96-146`; `internal/core/agents/scoped_execute.go:314-374` |
| **P8 — dispatch and replay integration** | Side registry missed by global lookup; generic family router rewrite; extend existing concrete family tuple | Add fifth `*registrationGroup` return to `decodeFamily`; mechanically migrate all callers, preserving their previous behavior and explicit rejection of foreign-family preflight. Add registration arm to refresh/global command match. Latest-state maps only, one registration reducer used by preflight and replay. No cache, second reducer or authoritative side store. | `internal/core/agents/scoped_replay.go:41-69`; `internal/core/agents/replay.go:264-374,377-412`; `docs/DESIGN-CORE-AND-LAUNCHERS.md:851-863`; Ticket140 ruling §§1–3 |
| **P9 — limits and cost** | Freeze list/population limits; unlimited producer admission; calibrated producer guards separate from structure | Frozen 64 KiB complete payload/submission cap and structural rules; positive configurable `Limits` guards: total registrations 256, declarations 1024, audience 64, consumers/declaration 64. Defaults are calibration, not historical validity or a capacity claim. Keep only latest snapshots in maps, not every receipt/revision. No benchmark or timing SLA. | `contract/ledger/doc.go:1740-1755`; `docs/DECISIONS.md:2633-2639,3032-3033`; `docs/ROADMAP-CORE.md:17`; `docs/DESIGN-CORE-AND-LAUNCHERS.md:851-859` |
| **P10 — historical boundary** | Re-open a second full Service/projection per query; return current map for old cursor; raw ledger export; bounded typed selection | Owner queries select one full latest snapshot at requested complete commit cursor from the validated ledger; current maps only for exact current prefix. `ToEnd` is resolved to current **store durable**, never passed as live Reader ToEnd. Numeric mid-commit/future cursors refuse. Historical reference lookup returns exact version snapshot, no bodies/private bytes. | `contract/ledger/reader.go:14-17,26-38,146-153,193-195`; `internal/core/agents/scoped_query.go:11-36`; `internal/core/agents/scoped_state.go:64-139`; ticket139:37-40 |
| **P11 — slices and collisions** | Two overloaded slices; four ceremonial slices; independent cache work competing with T140 | Exactly three dependent slices (§7), last owning real recovery/concurrency/frozen replay changes. Family-owned files plus listed shared hooks/tuple-only migrations. T140 owns historical acceleration, integrity and direct review publication; primary PM integrates and assigns command slots. | `docs/DECISIONS.md:3032-3035,3044,3059-3065`; assignment Shared Ticket140 boundary; Ticket140 ruling §4 |
| **P12 — evidence** | Blanket local full gate/race; source/mock assertions; permanent load for every routine field | Keep only behavior/privacy/CAS/identity/history/crash regressions (§8), focused package evidence and conditional D152 race/static/rule-break work; PM 120s fuzz campaigns; D125 contract freeze then producer; D153 hosted exact-final-SHA gate. | ticket139:44; `docs/DECISIONS.md:2134-2142,3032-3035,3059-3065`; `docs/ROADMAPS.md:227-236` |

### Conditional owner gates

**None is triggered by these recommendations.** If implementation/ruling requires a breaking change to any frozen family/schema/reader/appender (OG-BREAK), a dependency or toolchain change (OG-DEP/OG-TOOLCHAIN), real colony work/D52 expansion (OG-D52), an owner-policy/workflow change (OG-POLICY), or his credentials, money, account or machine (OG-OWNER), stop that affected work and ask the owner through the primary PM. Do not silently substitute a permissive path. A nonbreaking completed F3-139 freeze belongs to the PM under D125, not to an owner question. No `.github/` edit is proposed. [`docs/DECISIONS.md:122-131,207-221,2134-2142,3036-3044,3064-3070`; ticket139:23-29]

## 3. Typed Core API and observable behavior

### 3.1 Owner mutations (P2–P7)

Add these concrete values in `internal/core/agents/registration_types.go`; UUID is stdlib `uuid.UUID`, `ledger` is the existing contract package. The public request types contain no actor, operation string, grant, credential, path or session selector. `origin Binding` is the administrator's originating already-registered context; Core derives its sole execution session exactly as existing owner task/grant methods do. These APIs are trusted-host APIs, not authentication of agent-supplied text. [`internal/core/agents/scoped_commands.go:52-85,128-135`; `internal/core/agents/scoped_state.go:52-61`; `internal/core/agents/scoped_execute.go:122-152`]

```go
type ResourceRegistration struct {
    CommandID, ResourceID uuid.UUID
    ExpectedVersion uint64
    Audience []uuid.UUID
}
type WorkDomainRegistration struct {
    CommandID, WorkDomainID uuid.UUID
    ExpectedVersion uint64
    Audience []uuid.UUID
}
type DeclarationChange struct {
    CommandID, DeclarationID uuid.UUID
    ExpectedVersion uint64
    Subject ledger.RegistrationRef
    Audience []uuid.UUID
    Consumers []ledger.DeclarationConsumer
}
func (*Service) RegisterResource(context.Context, Binding, ResourceRegistration) (RegistrationReceipt, error)
func (*Service) ReviseResource(context.Context, Binding, ResourceRegistration) (RegistrationReceipt, error)
func (*Service) RegisterWorkDomain(context.Context, Binding, WorkDomainRegistration) (RegistrationReceipt, error)
func (*Service) ReviseWorkDomain(context.Context, Binding, WorkDomainRegistration) (RegistrationReceipt, error)
func (*Service) SetDeclaration(context.Context, Binding, DeclarationChange) (RegistrationReceipt, error)
```

Register methods require expectation 0; revise methods require 1..MaxInt64-1. `SetDeclaration` creates at 0 or revises at a positive expectation. Each method supplies its closed operation itself (§4.3). At the trusted host, allocate fresh UUIDv7 identities as existing callers do; no identity is inferred from a human name, external address, secret or digest. Normalize by copying and sorting audience IDs and consumer values; **reject**, rather than silently coalesce, duplicates. Nil `Consumers` normalizes to `[]`; nil/empty Audience refuses. No case-folding, UUID spelling coercion, key alias or external resolver. All exact request content enters schema 5. [P2–P4; `contract/ledger/scoped_values.go:203-304`; `internal/core/agents/scoped_commands.go:149-166`; `contract/ledger/doc.go:1744-1755`]

Before copying/sorting, apply the existing `boundedArrays`-style allocation fence: total Audience plus Consumers element count cannot exceed the frozen payload-byte cap (65,536); validate closed kind/UUID/scalar shapes before encoding. This is a finite preallocation fence, not a new decoder count limit. After normalization the whole encoded submission must fit the cap; new producer-count guards still run only after command lookup so lowering a Limit does not defeat a valid retry. [P9; `internal/core/agents/scoped_commands.go:156-166`; `contract/ledger/doc.go:1744-1755`]

Only a caller whose actor is derived as `owner` may enter the new execution helper. It refuses agent/core actors before any target-state disclosure, and never promotes `scopedCaller.actor` from request fields. No methods are added on `Agent`; the existing agent generic command route still rejects these operation/request combinations. A forged owner group from any lower-level submission hook must also match the original owner request exactly and pass the same reducer before Submit; an encoded group with agent/core actors must fail at Open. Permission to use a resource, to delegate a grant, to administer a task or to act as an Orchestrator never implies registration authority. [P6–P8; ticket139:35; `internal/core/agents/scoped_commands.go:128-135,340-344`; `internal/core/agents/scoped_submit.go:406-418`; `contract/ledger/doc.go:1723-1732,1971-1986`]

### 3.2 Identity, scope, references and revisions (P2–P5)

- Resource `R` is addressable **only** as F3-11 `external/R.String()`. Its `resource_id` and Resource are immutable; revisions replace its Audience. Domain `D` is an opaque UUID identity with versioned Audience, not an added F3-11 Resource kind and not a capability. A resource/domain record is a real registered node input even without any declaration; no stand-in label is required. [P2–P3; `docs/DESIGN-UNDERCURRENT.md:189-194`; `contract/ledger/doc.go:1784-1828`; ticket139:36,40]
- New entity IDs are unused across the three **new family entity kinds**; a resource ID cannot later become a domain/declaration ID. An ID can only revise the same entity, never reset to version 1 or replace a different source. Existing families retain their own identity namespaces and reuse rules; do not add global cross-entity checks to old operations. Same-version retries are commands, not new entity versions. [P4; ticket139:35-39; existing identity precedents `contract/ledger/doc.go:1585-1604,1878-1900`; `internal/core/agents/replay.go:153-179`]
- `version = expected_version + 1`; `expected_version` is 0..MaxInt64-1, version 1..MaxInt64. All increments and uint64-to-int64 conversions are checked. Expectation mismatch returns the existing `*RevisionError`, with no append/ID consumption. Creating under an ID already of another family entity kind returns `ErrInvalid`; creating under an existing same-kind ID is a revision mismatch. An identical new command with the correct next expectation is a real new version even if its snapshot is unchanged; no content coalescing is invented. [P4; `internal/core/agents/types.go:166-171`; `contract/ledger/doc.go:1744-1755`; `internal/core/ledgerstore/commands.go:130-148`]
- Every Audience ID must already be a registered agent at commit. An agent's sole session/context is checked using existing origin binding, not private-materialization health. Audience is an evidence-scope assertion only; it grants no read, write, network, model or administrative access. A registration revision cannot change a previously accepted grant's meaning. [P3/P6; `contract/ledger/doc.go:1769-1777,1878-1884`; `internal/core/agents/scoped_state.go:58-61,236-278`; ticket139:30,37]
- Declaration `Subject.kind/id` is immutable. Its supplied Subject.version must equal that resource/domain's **current** version at the final commit prefix, and the source must exist. The declaration pins that exact snapshot; later source revisions never silently reinterpret, widen, retarget or rewrite the declaration. A declaration may advance its source version explicitly by its own next version. Its Audience must be a subset of the pinned source Audience. [P3–P4; ticket139:37; `docs/DESIGN-UNDERCURRENT.md:173-176`; `docs/DECISIONS.md:2715-2716`]
- `Consumers` is a complete set, not a patch: a revision supersedes the previous set. Every task consumer must exist (including an unassigned or terminal task); declaration Audience must be a subset of that task's immutable Audience. Task consumers do not carry a task version, assignment ID/generation or assignee. Every context consumer must be an existing `(agent, context)` Binding and its agent must belong to declaration Audience. The same declaration may include both kinds. No fake task, new context, grant or assignment is created. [P3–P5; `contract/ledger/doc.go:1769-1778,1880-1900`; `docs/DECISIONS.md:2715-2716`]
- An old task link stays a task link across reassignment; it does not become an edge to the replacement context. An old context link stays that exact context. Terminal task state is separate from the owner's recorded declaration; neither is host-observed resource use. A later registration-scope change does not delete a declaration pinned to an earlier scope/version. The current declaration query returns that explicit historical reference, never substitutes the latest source version; a consumer must retain the reference to interpret its evidence scope. To withdraw links, set `Consumers:[]` at the next declaration version. This leaves an auditable empty current declaration. No retirement, deletion, deactivation, implicit expiration or additional lifecycle function is proposed. [P4–P5; `docs/DESIGN-UNDERCURRENT.md:171-176`; ticket139:37,40; `contract/ledger/doc.go:1884-1900`]

### 3.3 Receipts and queries (P6–P7/P10)

```go
type RegistrationReceipt struct {
    ledger.RuntimeRegistrationReceipt // deep-owned copy
    EffectSequence, Sequence uint64   // actual effect and receipt envelopes
}
type RegistrationLookup struct {
    ID uuid.UUID
    ThroughSequence uint64 // 0=genesis; ledger.ToEnd=current durable prefix
}
type RegistrationVersionLookup struct {
    Ref ledger.RegistrationRef
    ThroughSequence uint64
}
type RegistrationCommandLookup struct {
    CommandID uuid.UUID
    SubmissionSHA256 ledger.Digest
}
type ResourceRegistrationView struct {
    Record ledger.RuntimeResourceRegistered
    Origin ledger.Origin
    EffectSequence, ReceiptSequence, ThroughSequence uint64
}
type WorkDomainRegistrationView struct {
    Record ledger.RuntimeWorkDomainRegistered
    Origin ledger.Origin
    EffectSequence, ReceiptSequence, ThroughSequence uint64
}
type DeclarationView struct {
    Record ledger.RuntimeDeclarationChanged
    Origin ledger.Origin
    EffectSequence, ReceiptSequence, ThroughSequence uint64
}
type RegistrationEvidence struct { // exactly one nonnil, selected by Ref.kind
    Resource *ResourceRegistrationView
    WorkDomain *WorkDomainRegistrationView
}
func (*Service) ResourceStatus(context.Context, RegistrationLookup) (ResourceRegistrationView, error)
func (*Service) WorkDomainStatus(context.Context, RegistrationLookup) (WorkDomainRegistrationView, error)
func (*Service) DeclarationStatus(context.Context, RegistrationLookup) (DeclarationView, error)
func (*Service) RegistrationVersion(context.Context, RegistrationVersionLookup) (RegistrationEvidence, error)
func (*Service) RegistrationCommandStatus(context.Context, RegistrationCommandLookup) (RegistrationReceipt, error)
```

No list/search/view/agent equivalent is necessary to prove the criterion. Owner callers already know the IDs they registered; Ticket61 consumes frozen records through its own declared reader, not these APIs or an agent raw stream. `RegistrationVersion` resolves a declaration's pinned source even after a source revision. All returned data are copied, with no alias into live/cache-owned slices. Query metadata is passive: no usage charge, append, clock, dispatch, private-object read or external request. [P6/P10; ticket139:29-31,40; `contract/ledger/doc.go:1723-1732,1936-1946`; `internal/core/agents/scoped_query.go:11-48`; `docs/CONTRACTS.md:34-39`]

Invalid UUID/version/cursor input returns `ErrInvalid` or the reader's `ledger.ErrCursor` as specified in §6; an absent typed entity/version/receipt returns `ErrUnavailable`. Wrong receipt digest or a command of another family returns `ErrCommandMismatch`; do not synthesize a registration receipt from another family's F0 command. Queries after Close/poison retain `ErrClosed`/`ErrPoisoned`. [P7/P10; `internal/core/agents/types.go:11-20`; `internal/core/agents/scoped_receipt_query.go:20-86`; `internal/core/agents/scoped_submit.go:135-146`; `contract/ledger/reader.go:146-153`]

New-command refusal mapping: malformed shapes/duplicates/immutable-source retarget/invalid scope containment → `ErrInvalid`; unregistered Audience agent or context binding → `ErrNotBound`; missing resource/domain/task → `ErrUnavailable`; entity or referenced-current-source version mismatch → `*RevisionError` (wrap with source context where appropriate); producer list cap/allocation fence/encoded-size excess → `ErrTooLarge`; new-ID population ceiling → `*BusyError{Reason:"registrations"}` or `"declarations"`. Agent/core attempts → `ErrDenied`. Ledger decoders independently retain their `ledger.ErrInvalid` contract for malformed/over-cap bytes. Existing usable/ctx/store errors retain their original identities. Apply command match/mismatch **before** new-command state/producer guards. [P3–P4/P6–P10; `internal/core/agents/types.go:11-20,166-182`; `internal/core/agents/scoped_submit.go:135-176`; `contract/ledger/doc.go:1740-1755`]

## 4. Additive ledger family and canonical submissions

### 4.1 Catalogue, nested values and codec rules (P1–P4/P9)

Add **F3-139**, not a new contract boundary or format version. All four types below are version 1; `Defined()` grows from 49 to **53**. Each has a matching `Encode() (json.RawMessage,error)` and `DecodeRuntime…(json.RawMessage)` API. Put new codec/value code in `contract/ledger/registration.go` and canonical submission code in `registration_submission.go`, with this specification appended to `doc.go`. Use existing strict members/recursive duplicate detection, UUID, payload and scope helpers; do not duplicate a JSON parser or Resource implementation. [`contract/ledger/catalogue.go:37-119`; `contract/ledger/scoped_values.go:203-304,334-355`; `docs/CONTRACTS.md:7-18,34-39`]

`MaxRegistrationPayloadBytes = 65536`: check the entire input **before parsing**, including whitespace and ignored extensions; enforce the same cap on compact output and schema-5 submission. Valid UTF-8, one complete JSON object, required known fields, no null on any known field, recursive duplicate-key rejection even inside ignored fields, canonical lowercase UUIDv7 and nonzero lowercase SHA-256 digests, plain unsigned JSON decimal integers 0..MaxInt64 (no sign, fractions, exponent or numeric strings) follow the frozen common codec convention. Unknown optional fields are ignored at every level; encoders emit known fields only. A known field belonging to another kind/operation is forbidden even if null, not an extension. Errors wrap `ledger.ErrInvalid`. [P1/P9; `contract/ledger/doc.go:1740-1755,2084-2098,2299-2307`; `contract/ledger/scoped_values.go:334-350`]

The following nested shapes and **key orders** are frozen:

| Go value | Exact JSON keys/order | Structural rule |
|---|---|---|
| `RegistrationRef` | `kind,id,version` | Closed kind `resource` or `work_domain`; UUIDv7 ID; positive version through MaxInt64 |
| `RegistrationTarget` | `kind,id` | Closed kind `resource`, `work_domain` or `declaration`; UUIDv7 ID |
| `DeclarationConsumer` task | `kind,task_id` | Closed kind `task`; required UUIDv7 task ID; `binding` forbidden |
| `DeclarationConsumer` context | `kind,binding` | Closed kind `context`; existing `ledger.Binding` keys `agent_id,context_id`; `task_id` forbidden |
| Audience | array of UUIDv7 strings | Required, nonempty, strictly UUID-byte ascending/distinct |
| Consumers | array of DeclarationConsumer | Required, possibly `[]`, strictly ascending/distinct by known-field compact encoded UTF-8 bytes |
| Resource | existing `ledger.Resource` | Exactly `kind:"external",resource_key:<canonical resource_id UUID>`; other kinds/known members forbidden |
| Origin | existing `ledger.Origin` | `agent_id,session_id,context_id`; all UUIDv7 |

Codec-level equality also checks resource_key == resource_id.String(), version == expected+1, expectations below MaxInt64, schema-5 actor/operation/target/argument consistency and receipt/submission digest. Audience existence, reference existence/current version, subset relations, ID reuse and whole-group authority/CAS are service rules, not codec rules. Count/population ceilings are **not** decoder limits. Resource identity is canonical UUID, never a URL/account/credential, but no codec claims to detect arbitrary secrets in an old F3-11 key or grant. [P2–P4/P9; `contract/ledger/doc.go:1744-1755,1765-1781,1784-1809`; `docs/DECISIONS.md:2631-2639`; `docs/DESIGN-UNDERCURRENT.md:189-194`]

Closed tokens: nested `kind`s above, submission actor `owner`, schema 5, and five operations (§4.3). Receipt `outcome` is an **open** token using existing `^[a-z][a-z0-9_]*$`, at most 64 ASCII bytes; v1 writers use only `applied`. Codec preserves any other well-formed outcome, but the Core v1 reducer refuses to apply an unfamiliar receipt outcome (`ErrInconsistent` at Open), never treats it as success. No other open token is needed. This separates decoding forward compatibility from service authority. [P1/P7; `contract/ledger/doc.go:1575-1580,1839-1847,1949-1955`; `internal/core/agents/replay.go:95-98`]

### 4.2 Exact record payloads and catalogue facts (P1–P4)

Every payload field below is required and its table order is encoder order:

| Type constant / wire name / Go payload | Exact ordered payload |
|---|---|
| `TypeRuntimeResourceRegistered` / `runtime.resource_registered` / `RuntimeResourceRegistered` | `resource_id,expected_version,version,resource,audience` |
| `TypeRuntimeWorkDomainRegistered` / `runtime.work_domain_registered` / `RuntimeWorkDomainRegistered` | `work_domain_id,expected_version,version,audience` |
| `TypeRuntimeDeclarationChanged` / `runtime.declaration_changed` / `RuntimeDeclarationChanged` | `declaration_id,expected_version,version,subject,audience,consumers` |
| `TypeRuntimeRegistrationReceipt` / `runtime.registration_receipt` / `RuntimeRegistrationReceipt` | `command_id,submission_sha256,submission,outcome,version` |

Go fields follow their names (`ResourceID`, `ExpectedVersion`, etc.); versions/expectations use int64 in ledger values, UUID fields use uuid.UUID, digest uses ledger.Digest, audience/consumers use slices and never JSON null. `Resource` is ledger.Resource; `Subject` is RegistrationRef. Receipt embeds `RegistrationSubmission`, outcome string, resulting version int64; its codec requires version to equal its argument expected_version+1 with checked arithmetic. Both registration record names represent the **complete selected version**, including every revision, not merely a one-time notification. There are no optional payload fields in v1, and no self-sequence or derived latest-version field. [P1–P4; ticket139:35-40; `contract/ledger/doc.go:1849-1877,1949-1957`; `contract/ledger/scoped_submission.go:265-279`]

For **each** of these four catalogue rows in `CONTRACTS.md`: payload owner **C3**; producer **Core agents Service** on the corresponding owner transition; permitted appender caller **internal/core/agents only, through ledgerstore.Submit**, enforced by review; consumers **Core replay, owner-authorized current/historical/status queries, and Ticket61's later frozen-record consumer**; privacy **access-filtered registration/declaration/command identity, scope and version metadata, no private bytes/secret/URL/account/capability handle**. Replay-essential fields are **all known payload fields plus required group envelope and actual effect/receipt sequences**. Receipt additionally requires re-encoding its embedded canonical submission and checking its SHA-256 against F0. Fixture is `testdata/f3/139/`, §4.5. Record availability alone does not claim an operational producer or graph. [P1/P6; `docs/CONTRACTS.md:34-39,108-130`; `docs/DESIGN-CORE-AND-LAUNCHERS.md:861-863`; ticket139:38-40]

### 4.3 Schema-5 canonical request bytes (P1/P4/P7)

`RegistrationSubmission` has fields in exact order:

```text
schema (5), actor ("owner"), origin, operation, target, arguments
```

Use concrete argument values, not `map`, pointer, raw caller JSON or interface-selected alternate actor:

| Closed operation | RegistrationTarget | Concrete arguments and exact key order |
|---|---|---|
| `resource.register` | `resource, resource_id` | `ResourceRegistrationArguments`: `resource_id,expected_version,audience`; expected 0 |
| `resource.revise` | same | same argument type/order; expected 1..MaxInt64-1 |
| `work_domain.register` | `work_domain, work_domain_id` | `WorkDomainRegistrationArguments`: `work_domain_id,expected_version,audience`; expected 0 |
| `work_domain.revise` | same | same argument type/order; expected 1..MaxInt64-1 |
| `declaration.set` | `declaration, declaration_id` | `DeclarationArguments`: `declaration_id,expected_version,subject,audience,consumers`; expected 0..MaxInt64-1 |

`target.id` equals the argument entity ID; codec checks this redundancy. Resource arguments need no caller Resource: the record's exact F3-11 external target is a fixed derivation of the supplied UUID, and is checked against it. All supplied bindings, target IDs, expectations, audience IDs, source kind/ID/version and consumer identities are included. Command ID, result version, ledger time/sequence/commit/hash metadata, ephemeral handles, views and derived session selection are excluded; the derived **actual** session itself is included in Origin. Nothing reads a wall clock for this request form. [P1–P4/P7; canonical precedents `contract/ledger/doc.go:1690-1705,2010-2048,2231-2250,2515-2554`; `internal/core/agents/scoped_commands.go:128-166`]

`RegistrationSubmission.Encode`, `DecodeRegistrationSubmission` and the receipt use the standard `encoding/json` compact known-field ordering/escaping already used in the existing family codecs (including `\u003c`, `\u003e`, `\u0026`, U+2028/U+2029). Sort copied inputs once; ledger decode demands canonical set order. `submission_sha256 = SHA256(exact Encode bytes)`. Receipt decoder recomputes the digest after decoding/re-encoding, as existing embedded-submission receipts do; optional unknown fields do not alter the known meaning/preimage. Schemas 1–4 remain byte-identical. [P1/P7; `contract/ledger/scoped_submission.go:123-138,265-279`; `contract/ledger/doc.go:1950-1952,2170-2173,2381-2385,2551-2554`]

### 4.4 Group shapes and envelope (P6–P8)

Exactly one complete group per transition, one commit, **three** records in this exact order:

```text
resource.register / resource.revise:
  ledger.command, runtime.resource_registered, runtime.registration_receipt
work_domain.register / work_domain.revise:
  ledger.command, runtime.work_domain_registered, runtime.registration_receipt
declaration.set (create / revise / empty withdrawal):
  ledger.command, runtime.declaration_changed, runtime.registration_receipt
```

All three have actor **owner**, the same required originating `agent_id`, `execution_session_id`, `context_id`, and `operation_id = command_id`. Origin must be a registered agent/context and that agent's sole session. `turn_id`, `measurement_path` and `body_refs` are absent everywhere. No F3-10/11/12/13 effect, usage, pin/unpin, task mutation or registration start/end may be embedded. No private/body content is created or read. The receipt is last, its command ID/digest match F0, submission operation/target/arguments reconstruct the exact effect, resulting version agrees, and outcome is applied. Duplicate/reordered/extra/missing/mixed records or wrong actors/bindings refuse before Submit and at Open. [P6–P8; `contract/ledger/doc.go:1960-1986,2184-2200`; `internal/core/agents/scoped_replay.go:41-86`; ticket139:35,38-39]

### 4.5 Exact golden layout and coverage (P1/P4/P12)

New fixture root:

```text
contract/ledger/testdata/f3/139/
  log/00000000000000000001.jsonl
  objects/<sha256>   # "# Ada\\n" and empty initialization bytes
  bodies/<sha256>    # one actual task-description byte string
```

Use a fixed colony `019a1390-0000-7000-8000-000000000001`, deterministic UUIDv7 IDs/times, actual content/submission hashes and existing `buildLog`/`EncodeCommit`/`-update` patterns. Hash-named files contain LF/no CR; no secrets, URL/account placeholders or zero digests. The exact prerequisite history is two real F3-10 agent registrations (A/Ga and B/Gb), one A work-context creation W, and one owner F3-11 task T with Audience [A,B] initially unassigned. Reuse the frozen schema-1/2 group encodings, not new types standing in for them. Prerequisites are 6+6+4+4 = **20 records / four commits**; include the real task-description body pin. [P1/P12; `contract/ledger/scoped_golden_test.go:17-77,355-398`; `internal/core/agents/scoped_golden_test.go:20-195`; `contract/ledger/doc.go:1665-1687,1963-1985`]

For a decision-free deterministic generator, let `id(n)` be UUID `019a1390-0000-7000-8000-` plus twelve lowercase hex digits of n. Allocate A/sessionA/Ga = id(0x100/0x101/0x102), W=id(0x103), B/sessionB/Gb=id(0x200/0x201/0x202), T=id(0x300), R=id(0x400), D=id(0x401), RT/RC/DT/DC=id(0x500..0x503). Prerequisite directories are `Ada-a1` and `Ada-a2`; both instructions contain exact bytes `# Ada\n`, initialized memory/handoff are empty. Task description bytes are `Registered resource declaration fixture.\n`; acceptance_sha256 is the SHA-256 of `registration fixture acceptance\n`; dependencies=[], Audience=[A,B], no assignment, state waiting. Every group i (1..18) has command id(0x1000+i), commit id(0x2000+i), event_time_ns=1791000700000000000+i*1000000000. All new-family groups and the task creation originate in A/sessionA/Ga. This fixes fixture IDs/bytes only, not a product allocation policy. [P1/P12; deterministic fixture precedent `contract/ledger/scoped_golden_test.go:17-77,355-398`]

Then append these **14** F3-139 groups, each three records:

1. resource R register v1 Audience [A,B];
2. work domain D register v1 Audience [A,B];
3. resource-task declaration RT v1 (R/1 → T), Audience [A,B];
4. resource-context RC v1 (R/1 → W), Audience [A];
5. domain-task DT v1 (D/1 → T), Audience [A,B];
6. domain-context DC v1 (D/1 → Gb), Audience [B];
7. R revise v2 Audience [A] (old declarations still pin R/1);
8. D revise v2 Audience [B] (old declarations still pin D/1);
9. RT v2 pin R/2, Audience [A], Consumers [W,T] in canonical encoded order (context before task);
10. RC v2 pin R/2, Audience [A], Consumers [];
11. DT v2 pin D/2, Audience [B], Consumers [];
12. DC v2 pin D/2, Audience [B], Consumers [Gb];
13. R revise v3 Audience [A,B], explicitly demonstrating owner scope widening;
14. RT v3 pin R/3, Audience [A,B], Consumers [T].

The golden is therefore **18 commits / 62 records**, with all four source/consumer combinations, initial and revised registrations/domains/declarations, mixed consumer set, scope narrowing/widening and empty withdrawal. First F3-139 effect is seq 22, receipt 23; each following group's effect/receipt advances by 3; final effect/receipt seqs 61/62. The catalogue's per-type golden sequence lists are generated from this fixture, not guessed independently. Existing earlier golden directories and hashes remain unchanged. [P1/P4/P12; ticket139:38,40; `docs/DECISIONS.md:2631-2639`; `contract/ledger/scoped_golden_test.go:355-416`]

`TestGoldenF3_139 -update` alone creates **all** new log/object/body files; regular execution byte-compares them and verifies no extra fixture file, LF and correct content-addressed filenames. It exercises Reader consumption of the four new types and verifies the consumer-observable snapshots at the listed version boundaries; it does not build graph nodes/edges. The service frozen-replay test then imports this exact byte history through real Store/Open and exercises the owner queries at complete prefixes (§8), as existing family tests do. [P12; `contract/ledger/scoped_golden_test.go:355-416`; `internal/core/agents/scoped_golden_test.go:20-195,198-250`]

## 5. Reducer, preflight, replay, durability and retry

### 5.1 Concrete extension points (P7–P8)

Implement `registrationGroup`, `decodeRegistrationGroup`, `registrationPlan`, `planRegistration`, `installRegistration` in family-owned `registration_replay.go` / `registration_state.go`. Extend the existing `projection` with `resources`, `workDomains`, `declarations` maps, keyed by UUID and holding one complete latest snapshot plus originating Origin and actual effect/receipt sequences. Initialize in `newProjection`; retain no receipt/digest/history map. These are disposable **current projections of the ledger**, not permissions, a cache or a second authority store. [P8–P9; `internal/core/agents/service.go:71-117`; `internal/core/agents/scoped_state.go:20-44`; `docs/DESIGN-CORE-AND-LAUNCHERS.md:851-863`]

`decodeFamily` returns `(private, scoped, review, paid, registration, err)` in that order. Extend its existing detection/mixed-family refusal once; do not bolt an independently submitted family onto a filtered subsequence. Existing callers interested in another family discard the fifth value, but their preflights explicitly reject a nonnil registration group. Refresh and `findCommand` take the new group. `commandMatch` adds `registration *registrationGroup`; all F0 command occurrences still participate in the existing global watermark and interval-aware lookup. Complete registration decoding validates §4.4 plus canonical command/receipt/effect agreement, not current state. [P8; `internal/core/agents/scoped_replay.go:41-86`; `internal/core/agents/replay.go:264-295,377-412`; `internal/core/agents/scoped_submit.go:406-418`; `internal/core/agents/review_execute.go:311-337`]

`planRegistration` validates, without modifying any live slice/map:

1. Derived owner actor and registered Origin/sole session; exactly the intended operation, entity kind and ID.
2. Entity ID's same/new kind, expected version and checked increment; immutable resource address or declaration source identity.
3. Every Audience agent exists.
4. For declarations: exact current source kind/ID/version, Audience subset of that source snapshot, each existing task/context consumer and §3.2 containment. Load tasks through existing `loadTask`, preserving F3-12 support and T140's implementation if integrated; use the existing binding maps for contexts. Never call `registeredResource` to turn registration into permission or an old-operation prerequisite.
5. Exact complete resulting snapshot and receipt version, operation and outcome.

The producer runs its configurable admission guards **after dedup**, then the exact decoder/reducer preflight on the actual draft group immediately before Submit. Hook-mutated drafts must reconstruct the **same** original canonical request, not merely a different internally consistent request with a newly matching hash. Only the install step publishes one changed snapshot after the complete durable group. A rejected plan leaves all current snapshots, book state and sequence unchanged. [P3–P8; `internal/core/agents/scoped_state.go:58-61,105-139,236-278`; `internal/core/agents/scoped_submit.go:149-176,406-418`; `internal/core/agents/review_execute.go:311-337`; ticket139:35-39]

### 5.2 Live owner-command sequence (P6–P8)

Follow the existing scoped service protocol, without private preparation or a second persistence mechanism:

1. `enter`, defer `active.Done`; derive actual origin/session using existing binding logic; reject agent/core caller; normalize/copy the typed input, encode/decode schema 5 into a producer-owned value and hash it. Invalid structural input writes nothing.
2. Under `Service.mu`, check usable/refresh to store.Durable and current owner Origin. For an ID at/below the global maxCommand, capture the validated prefix and run `findCommand(0,T)` without `mu`, following existing lookup/Close behavior. Reacquire `mu`, recheck usable/binding/refresh, and scan the new tail if no prior match was found. Above-watermark absence is only an already-validated-prefix fact, never an excuse to skip the tail recheck.
3. If found, match **family + owner actor + complete Origin + operation + digest** and return the original receipt copy; do not run current entity CAS, current source version, population/list limits or graph/target reassignment checks. Same principal changed semantics returns ErrCommandMismatch **before** CAS/state changes. Wrong current Origin returns ErrNotBound/ErrDenied without returning another origin's receipt. An owner status query may inspect any known command by ID+digest, while mutation retry must match its original Origin.
4. If new, check producer list/population bounds and final reducer state/CAS, construct the three drafts, apply existing `beforeSubmit` test hook if present, re-run original-input comparison and the common decoder/reducer. `mu` remains held from final state check through Submit; no unbounded preparation, new goroutine, reservation or process gate is needed for bounded metadata-only owner administration.
5. Submit once. Map store ErrCommandMismatch to agents.ErrCommandMismatch; propagate refused/cancel/closed errors. ErrUncertain or ErrPoisoned poisons this Service, acknowledges nothing and permits no later mutation/query until reopen.
6. On committed or Duplicate result, **ignore caller cancellation for completion**, call existing `refreshLocked(context.Background(), max(p.through, committed.Last))`, then interval lookup/readback of the actual command group. Match the actual receipt and use its envelope sequences; do not return the proposed group's predicted receipt or prefix cursor.
7. Copy receipt; unlock. The existing `afterScopedSubmit` hook can mark the durable-before-projection boundary. Add only `afterRegistrationCommit func(RegistrationReceipt) error` to `serviceDeps` for deterministic post-install/lost-ack/Close proof; like the review hook it can cause caller error **after commit**, without rolling back the effect. No hook is a public API or durable fact.

No acknowledgement occurs before both durability and projection installation. There is one durable effect/receipt, not a promise that a transport can deliver a reply exactly once: repeated successful retries intentionally return that **same** receipt. No durable ack flag, retry worker, queue, clock, automatic execution or registration-recovery command is introduced. [P7; `internal/core/agents/scoped_submit.go:96-146`; `internal/core/agents/scoped_execute.go:314-374`; `internal/core/agents/review_execute.go:100-170,174-214`; `internal/core/ledgerstore/commands.go:130-161`; `contract/ledger/appender/appender.go:7-25`]

### 5.3 Open, crash boundaries, failures and Close (P7–P8/P12)

Add the four v1 types to `privateConsumption`. `refreshLocked` decodes, plans and installs the new group before publishing c.Last, with the existing duplicate-command test across every family. Group errors produce ErrInconsistent/poison just like other invalid committed groups; cancellation does not become a fabricated corruption. Open reconstructs all three maps from committed ledger facts alone. It reads no external resource, provider source, URL, credential, body or private content for this family; T139 adds no append or execution. Existing unrelated Open integrity/materialization work is preserved, not removed. [P8; `internal/core/agents/service.go:143-183,291-304`; `internal/core/agents/replay.go:264-374`; `contract/ledger/doc.go:1681-1687`; ticket139:39]

| Boundary/result | Required observable registration state |
|---|---|
| Invalid, stale, too large, wrong authority or cancellation before Submit starts | No new group, no command ID consumed, no map/permission change |
| Crash before any write | Old committed state only; retry may commit once |
| Torn trailing three-record group | Store recovery removes the uncommitted tail; no partial registration/declaration/receipt; same-ID retry may commit once |
| Complete valid commit survives process death, even if original flush/ack was uncertain | Store recovery selects complete commit; Open installs it; retry/status returns original actual receipt without append |
| Durable Submit, crash before projection or before reply | Open installs exactly that committed snapshot and receipt; no recovery append |
| Commit/readback/projection completion error | Do not claim success or undo durable state; poison incarnation; reconcile only by Store recovery/Open and exact receipt query |
| Caller context cancels once write started | Finish commit/projection/readback using noncancelled completion context; if successful return receipt; no abandonment or second effect |
| Close begins while accepted operation is in flight | Existing closed fence rejects later entrances; Close drains active operation through completion, does not close caller-owned Store |

The uncertain distinction is the **appender's**: nothing written on refused/closed/poisoned, maybe-surviving on uncertain. T139 does not add a ledger `unknown` registration state/outcome, treat a torn group as committed, or infer a missing ack is a missing effect. Crash tests are positively waited child-process/injected-tail evidence, not power-loss proof. [P7/P12; `contract/ledger/appender/appender.go:7-25`; `internal/core/ledgerstore/commands.go:130-161`; `internal/core/agents/service.go:184-218`; `internal/core/agents/crash_test.go:38-163`]

## 6. Current/historical queries, privacy and cost

### 6.1 Query mechanics and allowed disclosure (P6/P10)

Use the existing passive `scopedQuery` entrance/active-operation fence and copy under a stable validated prefix. Resolve `ledger.ToEnd` to the **current writer durable mark** once per query; it is only a public API sentinel, never passed to the live Reader. Numeric cursor 0 is genesis, a positive numeric cursor must be a complete commit end and <= captured durable. Mid-commit or future numeric cursor returns `ledger.ErrCursor`; do not round it forward/backward or expose a partial state. Validate the cursor even when a live-map miss would otherwise answer absent. [P10; `internal/core/agents/scoped_query.go:11-36`; `contract/ledger/reader.go:14-17,26-38,146-153,193-195`]

At the exact current prefix, return a copied current snapshot. Otherwise scan the validated prefix through that cursor and select the **last matching full effect plus its same-group receipt**; never answer an old cursor from a later live map. `RegistrationVersion` selects the exact kind/ID/version committed at or before the cursor; a later version does not substitute. The same family decoder ensures same-group sequences; only the stored full snapshot is selected, not a second independent task/authority reducer. Unrecognized consumed version, malformed/hash-corrupt authoritative history, forged group or incomplete cursor fails rather than becoming absence. Owner receipts remain immutable even after later source/entity revisions or a lower configured limit. [P4/P7/P10; `internal/core/agents/scoped_state.go:64-139`; `internal/core/agents/replay.go:242-262,377-412`; `internal/core/agents/scoped_receipt_query.go:20-86`; `contract/ledger/reader.go:146-153`]

The returned `Origin` is the **origin of that version's effect**, not the query caller. `ThroughSequence` is the resolved complete query prefix; `EffectSequence`/`ReceiptSequence` are the actual selected group's envelopes. There is no field that calls a declaration permission or observed use. An empty current consumer set yields a real DeclarationView with Consumers [], not ErrUnavailable. Prior declaration versions remain accessible by querying their commit cursors; source snapshots remain accessible by RegistrationVersion. [P4/P7/P10; ticket139:35-40; `contract/ledger/doc.go:1950-1957`; `docs/DESIGN-UNDERCURRENT.md:171-176`]

All new APIs are **owner-only** trusted-host surfaces. No agent metadata disclosure is added; `Agent` calls through alternate scoped routes refuse before revealing existence/version/Audience/receipt. Other families' status APIs keep their own behavior; T139 does not weaken an agent's receipt lookup to expose owner registrations. Existing task/private/grant disclosure always uses its current authority, independent of a registration or declaration's Audience. Trusted future Ticket61 consumption may read the specified records but must not treat an Audience list or a declaration as authority; graph filtering, view encodings and actual-use association remain that ticket's/later producers' work. [P3/P6; `contract/ledger/doc.go:1723-1732,1936-1946`; `internal/core/agents/scoped_receipt_query.go:64-85`; ticket139:29-31,35-40]

No **new-family payload** contains human labels, locator text, account IDs, credential bytes/digests/sizes or private descriptions. Prerequisite golden fixtures still carry the real existing F3-10 initialization bytes/directory labels and F3-11 task-description body test bytes; those are not registration payloads. The new family references no body, adds no pin and makes no retention promise for other families. No log-scrubbing regex is claimed as a secret detector: the new typed request shapes simply have no secret/locator text slot. Legacy F3-11 grant resource strings remain untouched. [P2/P6; `docs/DESIGN-UNDERCURRENT.md:189-194`; `contract/ledger/doc.go:1723-1732,1784-1810,1980-1986`; ticket139:36-38]

### 6.2 Bounds and realistic cost model (P9)

Add positive producer-only fields to existing `Limits`/DefaultLimits/validate:

| Field | Default | Guard |
|---|---:|---|
| `MaxRegistrations` | 256 | Combined current resources + work domains; checked for new ID only |
| `MaxDeclarations` | 1024 | Current declaration IDs, including empty snapshots; checked for new ID only |
| `MaxRegistrationAudience` | 64 | Every new resource/domain/declaration request Audience |
| `MaxDeclarationConsumers` | 64 | New/revised declaration complete consumer set |

Frozen constraints remain payload cap, valid closed shapes, nonempty sorted Audience, sorted distinct Consumers, canonical IDs/digests, checked increments and group rules. Open/replay accepts larger historical counts within the frozen payload cap, even after an operator lowers Limits; matched retries precede those guards. A revision can replace or withdraw an existing declaration while at a population cap. Do not evict current definitions or reject valid historical records to satisfy a newer producer ceiling. Limits additions may require setting fields in existing explicit Limits test literals; only callsite/default fixture updates are authorized, not weakened prior tests. [P9; `internal/core/agents/types.go:22-69`; `internal/core/agents/scoped_submit.go:149-176`; `contract/ledger/doc.go:1744-1755`; `docs/DECISIONS.md:2637-2639`]

**[INFERENCE — cost model, not measurement]:** owner setup and explicit scope/assignment edits drive writes, not turns, polling, views or model calls. One change emits three small records; audience/consumer UUID lists dominate size. An initial default-limit setup of 256 registrations plus 1024 declarations would emit 1280 administration groups / 3840 records, excluding identity/task prerequisites. No observed steady arrival rate or latency/throughput target is supplied, so none is invented; writes serialize at the existing durable appender. At defaults there are at most 256 registration snapshots and 1024 declaration snapshots, at most 81,920 retained Audience UUID occurrences and 65,536 retained consumer endpoints. This is plausibly a few MiB of identity/scalar fields plus Go slice/map/value overhead, **not** a measured RSS promise. The family retains neither prior versions nor canonical receipt copies in memory. Increasing configured live population or replaying a historically larger population increases real memory; no constant-space claim. Every revision permanently adds ledger bytes; history/disk grows without bound. [P9; `docs/DESIGN-CORE-AND-LAUNCHERS.md:851-859`; `docs/DECISIONS.md:672-678`; `docs/ROADMAP-CORE.md:17`]

Replaying N accepted family groups uses O(N) family reduction plus existing reference/command lookup costs; current source/CAS lookups are map lookups, audience checks linear in the encoded set, sorting a new set O(k log k). Historical/status queries and old command misses can scan ledger history through existing helpers; the service lock serializes final publication and can be held for those existing cold lookups. This is deliberate for low-rate owner administration, not universal constant-time lookup or runtime-capacity proof. Declaration references to historical/terminal tasks use the existing helper, with its authoritative scan/cache behavior, not a T139 reimplementation. The prior replay regression belongs to140; don't introduce a new per-prefix registration cache, benchmark framework or timing SLA here. [P8–P10; `internal/core/agents/scoped_state.go:64-139`; `internal/core/agents/replay.go:242-262,386-412`; `docs/DECISIONS.md:2687-2690,3032-3033`; Ticket140 ruling §§1–3]

Runtime proof at this ticket's implementation gate is finite actual-service smoke: register resource/domain, create/revise/withdraw all four source/consumer combinations, query old/current snapshots, reopen the same real store and retry. Retain resulting records/receipts/query outputs and log bytes, not invented throughput/latency or new measurement campaign. This is administration/storage/replay proof only; no provider, graph, production throughput, power-loss or accepted-delivery claim follows. [P9/P12; ticket139:35-44; `docs/ROADMAP-CORE.md:17`; `docs/DECISIONS.md:3032-3033`]

## 7. Implementation slices and Ticket140 collision matrix

### 7.1 Exact three slices (P11–P12)

All work is on the isolated139 worktree/branch assigned by PM; read main sources only during this design. Parent reports worktree creation coordinated with the primary, no139 compute slot yet. **T139 has no dependency on T140.** The implementation works against this supplied base with authoritative existing lookup helpers; if140 integrates first, adapt the same hooks to its accepted code. Primary chooses integration order at a coordinated slice boundary; no140 branch edits or move/push of main by the secondary PM. Fresh coder and fresh reviewer per slice. [assignment; parent coordination message; `docs/DECISIONS.md:3044,3059-3065`]

| Slice | Exact owned changes / interfaces | Dependency and evidence |
|---|---|---|
| **S1 — complete contract and freeze** | New `contract/ledger/registration.go`, `registration_submission.go`, `registration_test.go`, `registration_fuzz_test.go`, `registration_golden_test.go`; new `contract/ledger/testdata/f3/139/**`; append family spec to `contract/ledger/doc.go`; add catalogue entries/comment in `contract/ledger/catalogue.go`. Contracts **only**: no producer or Core scaffold. Exact §4 and golden. PM/drafter owns freeze documentation separately below. Changed package: `contract/ledger`. | Ruled design first. Payload/compatibility/golden tests, decoder fuzz seeds and PM120s, V8/V9/golden LF and actual ledgerstore consumer run; D125 fresh review of completed slice **with** freeze record. D153 exact final public freeze SHA hosted success before producer. No local race condition from these codec-only changes. |
| **S2 — real Core reducer, producer and queries** | New `internal/core/agents/registration_types.go`, `registration_commands.go`, `registration_replay.go`, `registration_state.go`, `registration_query.go`, `registration_service_test.go`, `registration_replay_test.go`; `service.go` only projection initialization, consumed types, afterRegistrationCommit hook; `types.go` only four Limits/default/validation fields; `scoped_replay.go` fifth family dispatch; `replay.go` registration refresh/global-command arm. Tuple-only callers listed in §7.2; no provider semantics. Own AuthorityAndIdentity, VersionCAS, DeclarationHistory, GrantsRemainIndependent, GroupRules and FuzzRegistrationGroupReplay. Document actual API/replay/privacy in agents `doc.go`. Changed package: `internal/core/agents`. | **S1 freeze landed before any producer emission/code**. Focused behavior + one package verbose run; shared projection/lock publication means whole-package race and affected×20 race. PM120s new replay fuzz plus existing common-dispatch targets (§8.3). No five-target static without build-constraint changes. |
| **S3 — recovery, concurrent retry and frozen-record interoperability** | New `internal/core/agents/registration_crash_test.go`, `registration_recovery_test.go`; extend new S2 test files only for named concurrent/lost-ack/Close regressions, not duplicated happy paths; update `scoped_golden_test.go` only to recognize fixture chapter139 colony; add TestRegistrationFrozenReplay in `registration_recovery_test.go`. Correct genuine S2 bugs only within the same product ownership, if evidence exposes them; never tests-only disguising an unimplemented behavior. Complete actual-service smoke and update agents `doc.go` with proven limits, no capacity claim. | S2 real producer first. Own actual child/torn-tail recovery, inert Open, cross-family cold-ID/duplicate history, CommitRetryAndClose, FrozenReplay. This slice has genuine recovery/concurrency test implementation, not a bookkeeping/evidence-only slice. D152 tests/static; if no product shared-state change, no duplicate whole-package/×20 race beyond focused new concurrency rows; if shared-state product fix, both conditional race runs apply. Final public code/document SHA's own hosted result required. |

S3's test-only concurrent rows still run once with the race detector as focused correctness proof; this does not silently reinstate a routine second whole-package race. S2 carries the required whole-package and affected×20 proof of the changed shared state; rerun if a subsequent fix changes that state. S1's consumer package run is required contract interoperability evidence, not an instruction to run the whole repository. [P11–P12; `docs/DECISIONS.md:3032-3035`; `docs/DECISIONS.md:2134-2142`; `docs/ROADMAPS.md:227-236`; `internal/core/agents/crash_test.go:38-163`; `internal/core/agents/scoped_golden_test.go:20-195`]

**Document ownership:** the primary PM/drafter, not coder/designer, applies `docs/CONTRACTS.md` register/C3 row/new F3-139 catalogue; the F3 list in `docs/DESIGN-CORE-AND-LAUNCHERS.md:861`; and freeze-status-only comments in the new contract files/catalogue/doc.go. Shared `docs/DECISIONS.md` D/B numbers are allocated only at record application. Private brief/ruling/freeze/evidence files under `.scratch/dwarf-harness/c3-evidence/` and decisions stay private/team-readable under D145, never public commits. Ticket close updates its issue criteria/Answer/status/comment, C3/U3 status prose/board only as actually warranted, and Ticket61's producer-freeze comment; it does not mark C3/U3/Ticket61 Done. No139 author changes Ticket13 verification, Ticket140 records or finalmain integration. [assignment; `docs/DECISIONS.md:2134-2142,2715-2724,3032-3044,3059-3070`; `docs/ROADMAPS.md:171,189,236`; `docs/CONTRACTS.md:34-39`; D145 split carried by assignment/staged-build guidance]

### 7.2 Exact shared-file / hook collision matrix (P8/P11)

**Send this matrix to the primary before code assignment.** It is the requested collision list, not permission to overwrite140 work. Minimal hooks must be reapplied to the primary's chosen integration order; no speculative merge resolution or cache refactor. [parent coordination message; assignment Shared Ticket140 boundary]

| Path | T139 edit | T140 relationship / integration rule |
|---|---|---|
| `internal/core/agents/service.go` | Three current-family maps/newProjection initialization; consumed v1 types; one private test hook | **Direct collision:**140 adds concrete history cache/coverage and context/materialization hints. Keep all140 fields/initialization/lifetime behavior; T139 adds only its own fields. No second cache. |
| `internal/core/agents/replay.go` | Fifth family decode arm; registration plan/install before c.Last; `commandMatch.registration`; `findCommand` decode of new group | **Direct collision:**140 owns whole-commit publication and global command-search cache. Every139 F0 command must take the same global occurrence invalidation path before covered cursor publishes. Preserve complete `(after,through]` duplicate detection and negative-tail rules. Do not seed cache from observing a receipt. No139-specific command lookup bypass. |
| `internal/core/agents/scoped_replay.go` | Add registration detection/mixed-family rejection and fifth tuple return | Shared dispatch seam, not a rewrite of validators. All existing shapes stay unchanged; any140 edit is retained. |
| `internal/core/agents/integrity.go` | **Only** discard added fifth return at existing decodeFamily callsite if that call remains | **Direct collision:**140 owns fused historical inspection/materialization. Do not edit/re-audit its logic, hints, filesystem checks or cost design. If140 removes that call, this139 mechanical edit disappears. |
| `internal/core/agents/review_execute.go` | **Only** fifth-return declaration/assignment and foreign-family check in preflight | **Direct collision:**140 owns direct review publication coherence. Preserve it unchanged;139 submissions deliberately use refreshLocked, not a new direct-install optimization. Do not reread review witnesses for139. |
| `internal/core/agents/review_state.go` | **Only** discard added fifth decodeFamily result | **Direct collision:**140 owns historical review lookup/cache. No semantic change; retain140's cache/lookup behavior. |
| `internal/core/agents/scoped_state.go`, `scoped_plan.go`, `review_plan.go`, `review_sources.go`, `history_index.go` | **No139 edit.** Call existing loadTask/binding helpers as consumers. | **T140-owned.** No new registration cache entries, reverse-dependency map, generic cache/seal, source-witness or integrity rewrite. Registration state cannot mutate task/grant/work/review answers. |
| `internal/core/agents/materialization.go`, `read.go`, `scoped_private.go` | **No139 edit** | **T140-owned.** Registration never changes private object/materialization behavior. |
| `internal/core/agents/types.go` | Four producer Limits fields/defaults/validation only | Shared public service configuration, not140 historical cache knobs. Keep explicit existing test-literal fields valid. |
| `internal/core/agents/doc.go` | New family/API/privacy/replay/cost subsection only | Append/merge own subsection without changing140's measured-cost text or claims. |
| `internal/core/agents/scoped_submit.go` | Only fifth tuple preflight result and explicit rejection of registration group | No change to scoped authority, Submit/usage/group shapes or receipts. |
| `internal/core/agents/paid_live.go`, `paid_read.go`, `paid_settlement.go`, `paid_state.go` | Only fifth return discard; in paid preflight explicitly reject registration group | **No paid/provider behavior.** These are required mechanical internal signature migrations, not ownership of paid accounting/credentials. No profile, network, charging or callback changes. |
| `internal/core/agents/paid_fixture_test.go`, `paid_fuzz_test.go`, `review_fuzz_test.go`, `review_replay_test.go` | Only fifth return discard in existing test helper callsites | Preserve every existing test/row/assertion; no140 measurement fixture edits. |
| `internal/core/agents/scoped_golden_test.go` | Add chapter139's fixed colony ID only | Existing fixtures/helpers preserved byte-for-byte otherwise; used by new tests, no old golden regeneration changes. |
| `contract/ledger/*` listed S1; `testdata/f3/139/**` | Additive own family | **Not140-owned**; no shared-cache dependency, no old fixture edits. |
| Shared public docs/private decisions/evidence | Draft requested contents only; primary applies/assigns numbers | Primary owns140/13/finalmain and sharedrecords. Public/private split; no secondary push/main move. |

At the supplied base the tuple callsites are the ones found at `integrity.go:72`, `paid_fixture_test.go:186,279`, `paid_fuzz_test.go:79`, `paid_live.go:211,218`, `paid_read.go:45`, `paid_settlement.go:276`, `paid_state.go:181,221`, `replay.go:268,403`, `review_execute.go:323`, `review_fuzz_test.go:80`, `review_replay_test.go:67`, `review_state.go:21`, `scoped_submit.go:407`. This is the entire **mechanical migration** scope, not license for unrelated changes. If integration exposes another caller, ask PM for that bounded callsite addition; keep the same concrete tuple convention. [P8/P11; direct known-symbol `decodeFamily` callers at these paths/lines; `internal/core/agents/scoped_replay.go:41-69`]

**Coherence in either order:** without140, retain existing authoritative scans and whole-commit refresh. With140,139's current maps are logical state, not cache entries; new registration/declaration effects do not change task/work/grant/review/source answers, but every F0 command still invalidates the global command key. All old direct review commits must preserve139's existing maps while publishing140 coverage, exactly as they preserve unrelated current projections now. No139 historical-query acceleration is added. Cache capacity remains the primary's **one** concrete256-entry/8MiB cache; no admission depends on cache presence, hit or eviction. [P8/P11; `internal/core/agents/replay.go:264-374,377-412`; `internal/core/agents/review_execute.go:117-145`; Ticket140 ruling:28-42,70-153,241-255]

Primary integration must also preserve the **new registrationGroup inside a global command-match answer**. If140's concrete command-cache representation does not round-trip the fifth group, leave registration command-match answers uncached and return the completed authoritative scan result intact; never serve a cached `found:true` answer that has dropped its registration group. Any needed cache-codec admission guard is a **primary-owned bounded integration hook** in `history_index.go`, not139 authority to refactor that file, add registration-specific cache entries or change the single-cache bounds. All command occurrences still undergo140's global-key invalidation and interval/uniqueness rules. This fallback works without a139→140 dependency. [P8/P11; `internal/core/agents/replay.go:377-412`; Ticket140 ruling:70-89,109-153; parent shared-file coordination]

## 8. Regression tests, focused evidence and release gates

### 8.1 Permanent tests and plausible bugs (P12)

Use `newServiceFixture`, `registerPrivate`, `scopedWorkContext`, `scopedCreate`, grant/capacity helpers and `reopenScoped` rather than a second fixture framework. `scopedGoldenFixture` imports exact stored bytes, not producer-regenerated history; extend only its chapter→colony selection. Ordinary independent tests/fixture-owning rows call t.Parallel; child-process environment is scoped to exec.Cmd, children are positively waited, no sleeps/durations or process-global state races. Reuse `beforeSubmit`, `afterScopedSubmit` and the one new post-registration hook. A hook or fake clock is deterministic coordination, **not** a fake store/service. No mocks that echo requests, source-text assertions, model/provider calls, graph assertions or incidental default/wording tests. [P12; ticket139:44; `internal/core/agents/scoped_service_test.go:13-78`; `internal/core/agents/scoped_golden_test.go:20-195`; `internal/core/agents/crash_test.go:38-163`; `internal/core/agents/recovery_test.go:297-345`; `docs/DECISIONS.md:3032-3035`]

| Permanent test (owner slice) | Observable assertion / plausible regression it catches |
|---|---|
| `TestRegistrationPayloads` (contract S1) | All four payloads + schema5 round-trip canonical semantic values/key ordering; nested duplicate/known-null/wrong-kind/unknown-kind/unsorted/duplicate sets/non-UUID keys/wrong address/version overflow refuse. Unknown optional nested values ignored, duplicate in them refuses; open outcome survives codec. Exact cap and over-cap handling, including ignored bytes; producer-max audience64/consumers64 effect **and receipt** fit 64KiB. Catches malformed/incomplete/ambiguous consumer evidence, opaque-identity and cap bypass. |
| `TestRegistrationCompatibility` (contract S1) | Feed every earlier frozen golden through existing reader consumption and assert original stored bytes/hashes unchanged via golden machinery; schemas1–4 existing canonical fixtures unchanged; Defined includes new family. Catches breaking stored-byte/decoder changes, not a hand-maintained type-count-only assertion. |
| `TestGoldenF3_139` (contract S1) | Exact §4.5 file bytes/content addresses and actual Reader-consumable complete history, all four source/consumer semantic shapes and expected snapshots/receipt meanings. No fixture-only nonempty check. |
| `TestRegistrationAuthorityAndIdentity` (S2) | Public owner register/revise produces external UUID-key Resource; alternate bound Agent route and forced agent/core execution helper cannot create/revise/widen; wrong Origin/session/group actor fails without target metadata or durable change. No Agent status route exposes owner receipt. Cross-kind entity reuse and resource alias/retarget attempts refuse; arbitrary URL/account-shaped resource targets cannot be represented/accepted by the new decoder. |
| `TestRegistrationVersionCAS` (S2) | Two independent owner calls with same expectation race under channels; exactly one next version/group is committed, loser ErrRevision; compare returned receipt/current view/reopen. New-ID reuse, version restart and MaxInt64 overflow cannot mutate. Apply to resource, domain and declaration kernels without duplicating same-path parameter rows. |
| `TestRegistrationDeclarationHistory` (S2) | Real resource/domain, task/context prerequisites; all four combinations, mixed/empty replacement, scope narrowing/widening, latest/exact pinned source version, missing references and disjoint scope refuse. Query every **complete commit** boundary plus mid-commit/future refusal; old/current versions never mix. Reassign a real task and prove task link stays T and explicit context link stays old context; no link to replacement context appears. Existing unassigned and terminal tasks remain legitimate identity-level consumers. |
| `TestRegistrationGrantsRemainIndependent` (S2) | Real owner/Agent grant issue/delegation using valid external legacy key and UUID key works **before any registration** with the same observable grant/receipt/authority semantics after registration/revision. Registration does not issue/widen/revoke grants, charge local units or make denied private/task access succeed; prove with public status/denied commands and unchanged capacity exposure. Catches adding registration as a historical prerequisite or treating Audience/declaration as permit. No paid operation/fixture is needed. |
| `TestRegistrationGroupRules` (S2; strengthened S3 only for new recovery cases) | Service beforeSubmit mutations with valid recomputed F0/receipt digests: mismatched original request, binding/session/actor, reused/missing ID, different source/version, extra/missing/reordered/mixed family, wrong receipt result/outcome all refuse with no append or changed snapshots. The same forged complete bytes over a copied real store fail Open rather than becoming state. Use real prefix/independent reopened baseline; no shallow map-copy assertion. |
| `TestRegistrationCommitRetryAndClose` (S3) | Same-command concurrent identical calls and post-commit lost-ack retry/status return the **same actual** receipt including sequences, one three-record append only. Changed submission returns ErrCommandMismatch before stale CAS or lowered limits. New owner origin / old foreign-family command never matches. Repeated receipt query is inert; mutated returned slices do not change later query/retry. Cancellation/Close at precommit/durable-before-install/post-install hooks preserves §5 table and drains safely. A deterministic readback failure after durable Submit poisons the Service and returns no success; restore the copied real test log's exact valid committed bytes, reopen, and recover the original receipt without reapplying. This uses the real Store/log and existing boundary hook, not a fake Submit result. |
| `TestRegistrationInjectedCrashRecovery` + child helper `TestRegistrationCrashChild` (S3) | One closed real prerequisite store copied per boundary; child dies before commit, with a torn final group, durable-before-projection, and post-install-before-ack. Store recovery and real Open select only complete committed snapshot/receipt; unchanged ledger bytes after Open, same-ID retry commits only if previously uncommitted, exactly one final effect. Include a declaration-revision/withdrawal crash, not just new resource registration. |
| `TestRegistrationFrozenReplay` (S3) | Copy exact f3/139 golden; real Store/Open/query every complete prefix, with lower producer caps and inert byte/durable comparison. Old declaration pins old source after source revision; latest source and explicit empty declaration are correct; status/retry use recorded actual sequences. Run existing `TestPaidGroupRulesAndFrozenReplay` unchanged to retain F3-10/11/12/13 shared private/task/work/book reconstruction. |

`TestRegistrationGroupRules` edits semantic test data with a receipt/digest helper analogous to `scopedRewriteReceipt`, so authority/CAS/containment mutations do not merely fail a stale SHA. Assert consumer state, refusal class and unchanged durable prefix—not hook invocation counts or internal map/layout details. No permanent performance test is added. The two fuzz targets below test uncertain decoder/group boundaries, not mere implementation wiring. [P12; `internal/core/agents/scoped_replay_test.go:28-68,540-632`; `internal/core/agents/paid_replay_test.go:28-135`; ticket139:44]

### 8.2 D152 deliberate breaks (P12)

Only authority/disclosure and crash-recovery breaks are relevant;139 changes no credential, sandbox or money semantics. PM approves exact temporary edits, records baseline SHA-256, requires each named test red, byte-identical restore, then green. No weakened test, changed fixture/expected wording, blanket mutation campaign or shared140 rewrite. New list/cap/encoding vectors run normally; they are not extra mandatory rule breaks. [`docs/DECISIONS.md:3032-3035`; ticket139:44]

| Temporary defect | Required red test |
|---|---|
| Let agent/core caller take the owner registration path, or trust forged envelope actor instead of derived principal | AuthorityAndIdentity |
| Skip comparison to original normalized request / accept changed scope or consumer via mutated group | GroupRules |
| Treat declaration Audience as permit, or require registration to issue/delegate an otherwise valid legacy external grant | GrantsRemainIndependent |
| Return a proposed/predicted receipt, treat command ID mismatch as fresh after stale CAS, or install/ack before real durable readback | CommitRetryAndClose |
| Replay a registration effect without its complete receipt group, or append/reapply registration on Open | GroupRules and/or InjectedCrashRecovery/FrozenReplay, according to exact mutation |

Choose one concrete defect per row that is a real code change on this implementation; if a row cannot reach the claimed behavior because another independent guard correctly stops it, document the guard and choose the layer-accurate mutation. Do not mutate the unrelated140 cache or old ledger recovery merely to manufacture a red; use the new family boundary and existing crash helper's actual store/tail behavior. [P12; `docs/DECISIONS.md:3032-3035`; `internal/core/agents/crash_test.go:38-163`; `internal/core/agents/scoped_replay_test.go:28-68`]

### 8.3 Fuzz and commands — instructions, not executed evidence (P12)

New `FuzzDecodeF3_139` in contract `registration_fuzz_test.go`: tagged selection of four decoders and schema5, seeds for all golden shapes, exact payload boundary/overflow, recursive duplicates, forbidden known fields, unknown optional fields/open outcome, versions and array order. New `FuzzRegistrationGroupReplay` in agents `registration_replay_test.go`: reusable real prerequisite service, bounded mutations of actor/binding/source/receipt/ordering/versions, same decoder/reducer preflight as live/Open, no append or state leak on rejected candidate; accepted candidate must reconstruct the fixed original meaning and succeed through real-store Open on a copied prefix. Follow long-lived-fixture/preflight conventions; cap fuzz input at payload bound and do not create a new store for every rejected input. [P12; `contract/ledger/scoped_fuzz_test.go:12-15`; `contract/ledger/review_fuzz_test.go:12-15`; `internal/core/agents/scoped_replay_test.go:540-632`]

Because S2 changes common `decodeFamily`, PM also runs **FuzzScopedGroupReplay**, **FuzzReviewGroupReplay**, **FuzzPaidGroupReplay** for120s each (their fuzzed preflights reach that function). `decodeGroup` itself is unchanged, so **FuzzPrivateGroupReplay** needs its seed corpus via package test, not a new timed campaign unless actual edited code reaches it. No old decoder helper should change; if one does under a ruled fix, PM adds the exact corresponding existing decoder target. [P8/P12; `internal/core/agents/scoped_replay_test.go:540-632`; `internal/core/agents/review_fuzz_test.go:13-15,80-83`; `internal/core/agents/paid_fuzz_test.go:13-16,79-83`; `internal/core/agents/replay_fuzz_test.go:13-17`; assignment PM120s rule]

All commands below are **for coder/PM execution later**, serially in an allocated local slot, from the139 worktree. Designer ran none. Toolchain go1.27.3, `GOTOOLCHAIN=local`, empty `GOFLAGS`, explicit `CGO_ENABLED=0` for ordinary contract/Core work; standard-library additions only. Existing agents credentials/providers imports are legitimate and unchanged, not authority for adding new modules. No dependency/toolchain/build-constraint/workflow edit is proposed. [assignment; `go.mod:5-9`; `docs/DECISIONS.md:122-131,3032-3044`; `tools/check/main.go:244-250`]

**Each changed package, once plain verbose after final edits**, plus focused rows while implementing:

```sh
GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -timeout 19m -v ./contract/ledger -run '^(TestRegistration|TestGoldenF3_139)'
GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -timeout 19m -v ./contract/ledger
GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -timeout 19m -v ./internal/core/agents -run '^TestRegistration'
GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -timeout 19m -v ./internal/core/agents
GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go vet ./contract/ledger ./internal/core/agents
GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go tool staticcheck ./contract/ledger ./internal/core/agents
```

Run only the package(s) changed by that slice; S1 does not run agents tests against an absent producer. S3's focused compatibility command is `GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -timeout 19m -v ./internal/core/agents -run '^(TestRegistration.*|TestPaidGroupRulesAndFrozenReplay)$'`. Run host `gofmt -l` over **the explicit changed Go file list from §7**, format only owned files, and require empty output; no broad unrelated formatting. Inspect imports with `go list -f '{{join .Imports "\n"}}' <changed package>` and `go list -f '{{join .TestImports "\n"}}' <changed package>`, in the same explicit environment; contract transitive check is `go list -deps -f '{{if not .Standard}}{{.ImportPath}}{{end}}' ./contract/ledger`, allowing only root-module contract packages and no new module. [P12; `docs/DECISIONS.md:3032-3035`; `docs/ROADMAPS.md:227-236`; assignment import/toolchain constraints]

**S2 shared-state race condition applies:** use the already-installed local race compiler through the PM's standing coder-context environment, `CGO_ENABLED=1`, with `GOTOOLCHAIN=local GOFLAGS=`:

```sh
go test -count=1 -race -timeout 29m -v ./internal/core/agents
go test -count=20 -race -timeout 45m -v ./internal/core/agents -run '^TestRegistration(VersionCAS|CommitRetryAndClose)$'
```

In S2 only VersionCAS exists; its exact affected×20 pattern is `^TestRegistrationVersionCAS$`. S3 adds focused race on `^TestRegistrationCommitRetryAndClose$` once; if S3 fixes shared-state product code, use the full two-command recipe with both affected names. Do not assume a stock CGO=0 environment can run race, install a new toolchain, or add race to a codec-only slice. Five-target static is **not required** unless a ruled implementation actually changes build constraints; if triggered, host-built staticcheck/vet run for windows/amd64, linux/amd64, linux/arm64, darwin/amd64, darwin/arm64. No such file is owned here. [P12; `docs/DECISIONS.md:3032`; assignment standing constraints; `tools/check/boundary.go:26-31`; `tools/check/main.go:9-11,430-449`]

**S1 PM contract proof**, after coder hashes match final committed blobs: regenerate with `GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -timeout 19m ./contract/ledger -run '^TestGolden' -update`; require every fixture unchanged after regeneration; compute SHA-256 for **all** fixture files and compare every earlier one with the supplied exact-base committed fixture and its current freeze/amendment reference, record new139 inventory/digests and LF/no-CR. Do not select an obsolete pre-amendment F3-13 golden as the compatibility baseline. Consumer run: `GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -timeout 19m -v ./internal/core/ledgerstore`. PM supplies actual exact-SHA/log/digest evidence; designer does not invent new golden hashes. D145 keeps operational evidence/private records out of public commits. [P12; supplied exact base; `docs/DECISIONS.md:2546-2561,2631-2639,2994-2996`; `contract/ledger/scoped_golden_test.go:355-398`; assignment contract-evidence guidance]

**PM timed fuzz**,120s **per named target**, one invocation at a time:

```sh
GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -timeout 19m ./contract/ledger -run '^$' -fuzz '^FuzzDecodeF3_139$' -fuzztime 120s
GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -timeout 19m ./internal/core/agents -run '^$' -fuzz '^FuzzRegistrationGroupReplay$' -fuzztime 120s
```

Repeat the second command separately for each of the three existing changed common-dispatch targets named above. Coders run seed corpora only. Retain logs, exits, actual durations/slow rows and restored file hashes; do not report unrun race as zero. No local test/fuzz overlap with140 or any diagnostic/measurement job; primary grants each slot. Existing unrelated winexec CPU-limit CI failure belongs to the primary's triage, not139 scope or a reason to weaken these criteria. [P12; parent coordination message; assignment standing constraints; `docs/DECISIONS.md:3032-3035`]

### 8.4 Freeze, hosted integration and close (P11–P12)

1. Fresh advisor rules this full brief before code. S1 implements only this additive contract and its complete golden.
2. Fresh advisor reviews completed S1 **with** proposed freeze record and observed focused/golden/fuzz/consumer evidence. PM records F3-139 freeze under D125; public contract/register/comment edits and private decision/evidence records are separated under D145. No guessed D/B number or owner quote enters public code.
3. Finalize/rebase each public branch SHA; guard/push and obtain D153 hosted `changes`, all required Windows/Linux/macOS matrix jobs and **Check result success on that exact final SHA**. A fix/rebase/public freeze-comment `.go` edit creates a new SHA requiring its own full matrix. No old local full-check/amend shortcut or evidence from a previous SHA counts.
4. Primary alone integrates/pushes checked main in its chosen139/140 order. Freeze must be landed before S2 producer code/emission; no consumer builds against the proposed family beforehand. No dependency on140 is added.
5. PM's smoke exercises §6.2 actual Service path and records real receipt/query/reopen outputs. Use a throwaway program or equivalent retained runner source **outside** tracked repo files; no measurement SLA or new module. New permanent tests are only §8.1's plausible regressions.
6. After proof, remove owned throwaway scripts, retain required evidence in private records, finish API/package documentation and ticket/contract/roadmap close edits, and disclose intentionally unchanged later-ticket scope. Final public document SHA also requires its own hosted aggregate (Markdown-only may skip matrix after classification) and PM links/LF check. Private records push is separate and supplies no public CI proof. Fresh stand-in approval does not erase the whole-ticket Fable verification retained by the assignment.

These are gates to observe later, not claims any check, freeze, implementation or close has happened. [P11–P12; `docs/DECISIONS.md:2134-2142,3032-3044,3059-3070`; `docs/ROADMAPS.md:227-236`; assignment D145/fresh-agent/stand-in constraints]

## 9. Ruling checklist and unresolved questions

The advisor must rule P1–P12, especially: **P2 external-only/UUID-key registration**, **P3 Audience evidence scope**, **P4 pinned source versions plus replaceable consumer sets**, **P5 task identity rather than assignment and no retirement API**, and **P8 concrete fifth-family tuple migration**. They are explicit choices, not implied owner decisions. If any is modified, amend its exact API/payload/golden/reducer/query/test/collision consequences in this single brief before coder assignment; do not leave conflicting alternatives to the coder. [P1–P12; ticket139:23,35-40; `docs/DECISIONS.md:1945-1953,2134-2142`]

All six criteria have a §1 deliverable/proof mapping; all types/order/canonical bytes/shapes/caller/consumer/privacy/replay facts and every node/declaration fixture shape are specified; identity/CAS/history/recovery/limits/failure/Close/disclosure behavior is stated; exactly three slices and shared-file hooks are listed; D125/D145/D152/D153 and conditional owner gates are carried. This asserts **design coverage**, not applied code/evidence. No broad reader map, general registry, graph, provider/view work, competing cache or benchmark requirement is proposed.

**Unresolved source questions: none. Conditional owner gates: listed §2, none triggered.** Primary still chooses integration order, compute slots and record numbers; those are coordination/record-application choices, not missing technical design. Ruling may approve/modify/reject proposals; only its approved result authorizes subsequent code.
