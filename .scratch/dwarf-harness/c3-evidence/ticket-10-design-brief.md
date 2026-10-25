# Ticket 10 — persist and recover independent private contexts

Design proposal for advisor ruling, not an adopted decision. Base supplied by the PM: `main` c6bfc5e. No repository write, Git inspection, command, build or test is part of this assignment. The eventual ruling wins over this brief; the frozen F3-10 contract wins over either on its encodings. Sources below are repository-relative citations; coder filesystem paths must instead be absolute beneath the PM-assigned worktree.

## Owner summary

Ticket 10 supplies Core-owned private storage and operational receipts, not a model loop: one execution session per agent; distinct context memory/handoff/transcript/continuation; immutable revisions, CAS transitions, honest restart and same-ID replay. **P2 proposes real, incarnation-bound in-process owner capabilities for this ticket; agent grants remain ticket 11's and agent ingress denies by default.** The advisor must rule this staging explicitly. A selected view never retargets another operation; ledger authority never moves to Markdown/cache. Sources: T10:10–12,29–33; SPEC:73,79,393–395; RC:421,450; CORE:447–486,918.

**Buildability:** CI is met on the assignment's supplied evidence (third three-OS run passed), C2 is Done, and D112 explicitly approves the D52 boundary before C2 **or C3**. No fresh design/routine-freeze question (D117,D125). Before producer implementation, F3-10 must be built/evidenced, advisor-approved with its freeze record, and PM-frozen. Sources: DEC:1543–1549,1939–1942,2128–2129; RC:460–462; assignment “The situation”.

**Not built:** grants/task ownership (11), review/failure callbacks (12), paid provider attempts/accounting (13–14), model/tool turns and scheduling (15), or the whole concurrent-runtime/child-shutdown/capacity proof (16). Relationship/board creation and messaging remain C6's; router state and the R1 context-module interface remain their producers'. No live provider, validator, role hierarchy or seventh contract is introduced. Sources: T11–T16:10–12; RC:427,434–448; CORE:918–930,934–939; CON:25–31,40–44.

**Consequences:** private history grows with retained operational history; there is no automatic cross-context inheritance, automatic recovery execution, silent repair of a mismatched private file, or OS-isolation claim. Missing/corrupt committed private state is reported and blocks use. Sources: DEC:D21,D25,D36,D38,B3,B7; CORE:479–485,918,1024–1026.

## §0 — Buildability and reserved gates

### Source key and precedence

`T10` = `.scratch/dwarf-harness/issues/10-persist-and-recover-independent-private-contexts.md`; `SPEC` = `.scratch/dwarf-harness/spec.md`; `RC` = `docs/ROADMAP-CORE.md`; `CORE` = `docs/DESIGN-CORE-AND-LAUNCHERS.md`; `DEC` = `docs/DECISIONS.md`; `CON` = `docs/CONTRACTS.md`; `LD` = `contract/ledger/doc.go`. `T11`–`T16` mean the exact sibling filenames below. A decision ID includes its amendments. P-numbers are proposed source-gap settlements, subject to the advisor; no source-reserved owner choice is silently decided.

| Key | Filename under `.scratch/dwarf-harness/issues/` (scope citation `:10–12`) |
|---|---|
| T11 | `11-enforce-scoped-grants-and-atomic-task-ownership.md` |
| T12 | `12-accept-only-exact-subject-review-and-failure-results.md` |
| T13 | `13-dispatch-and-settle-a-sealed-static-anthropic-text-attempt-through-core.md` |
| T14 | `14-add-openai-responses-to-the-same-safe-static-paid-attempt-path.md` |
| T15 | `15-run-bounded-context-bound-model-and-tool-turns.md` |
| T16 | `16-prove-concurrent-private-runtime-restart-and-child-shutdown.md` |

### Gate disposition

| Gate | Ticket-10 disposition and exact stop |
|---|---|
| C2 and CI start prerequisites | Met as supplied; don't rerun reported CI or override it with older Waiting prose. D133 clears start with Windows green and requires all-three-green for whole C3 exit; ticket 10 is not C3 completion. Sources: RC:460–462,502–516; DEC:D133; assignment “The situation”. |
| D52 integrated promotion boundary | Met by D112 before C2 **or C3**; no new question here. Testing-only/no-validator boundary stays unchanged. **Conditional owner gate OG-D52:** stop before changing its approved, unmarked boundary text or admitting real colony work. Sources: DEC:D52,D112,D41,D125; RC:13,306–313. |
| D40/F3-10 | Mandatory delegated contract stop. PM freezes the built/evidenced additive slice after advisor approval **with** the record; no packet/question. No producer implementation before freeze; F0/F2/U3 stay compatible. Sources: DEC:D35,D40,D125; CON:13–19,34–40; assignment “Settled”. |
| Breaking frozen shape / owner decision | Conditional **owner gate OG-BREAK** before adopting such a change; enumerate affected consumers. This design recommends additions only and no change to an owner decision. D125 does not delegate breaking changes. Sources: DEC:208–216,2130–2132; CON:15–17. |
| New dependency | Conditional **owner gate OG-DEP** if the implementation cannot stay within existing dependencies; name the dependency, licence, scope and removal path before adding it. Recommendation: no new module or external library. Sources: DEC:D29,D41,D45,B3,D125; RC:15. |
| Live provider credentials | Owner keys only for a live test; none is attempted or needed here. Not a ticket-10 blocker and no credential storage. Sources: T10:24; RC:431,462; SPEC:403. |
| Push / CI budget change | Pushing remains owner-controlled; a stopped included-minutes budget is missing evidence, not a waiver. Neither is needed to design/build the local ticket slices. Sources: DEC:D31,D46,D125,D133 items 3–4. |

F3-10's naming and ticket-by-ticket staging are settled by the assignment, not an unresolved F2-era owner choice. D117 removes owner design approval; D125 supersedes earlier precedent freeze questions. Record D-NEXT/B-NEXT only when appended (currently D138/B31); update C3's Status and `ROADMAPS.md` board together, and register new families in `CONTRACTS.md`. Sources: DEC:D116 items 3–4,D117,D125; assignment “Settled”.

## §1 — Scope, owned paths and existing seams

### Placement and owned paths (P1, P13)

Create the **runtime module** at `internal/core/runtime`, package `runtime`, using the existing root module. It owns typed private-state transitions, replay and authorized snapshots together. It is neither a new public contract package nor a second ledger/appender. Use the existing real `ledgerstore.Store`, restricted appender contract and narrow durable adapter; do not change their interfaces or copy their implementation. Sources: DEC:D45,D50,B3,B7; SPEC:391–395; assignment “Code to follow, not to change”.

| Owned path (relative beneath the assigned worktree) | Complete responsibility |
|---|---|
| `internal/core/runtime/doc.go` | The implemented interface, current authority boundary, private layout, replay/poison rules and later-ticket limits |
| `internal/core/runtime/service.go`, `replay.go`, `errors.go` | Open/Close, one private-state sequencer lock, whole-commit replay, journalled in-memory projections, lifecycle drain and typed refusals |
| `internal/core/runtime/identity.go`, `context.go` | Durable one-session-per-agent identities and typed context creation/lookup; no turn allocation or task assignment |
| `internal/core/runtime/private.go`, `objects.go`, `projection.go` | Bounded private-object preparation/publication, revision-CAS transitions, managed Markdown and rebuildable state cache |
| `internal/core/runtime/commands.go` | Versioned canonical request digest, use of existing Submit/dedup lookup, immutable receipt construction/retrieval and current-authority checks |
| `internal/core/runtime/scratch.go` | Authorized read-only projection of frozen F2 scratch-created/closed bindings; no workspace method, allocator or independent scratch persistence |
| Beside those files: `*_test.go`, `helpers_test.go`, `recovery_test.go`, `fuzz_test.go` and only actually needed OS-suffixed fault tests | §6's consumer-visible regressions, real-store/private-files fixture and deterministic hooks |
| `contract/ledger/private.go`, `private_test.go`, `private_fuzz_test.go` | F3-10 payload types/strict bounded codecs and their behavioral/decoder tests |
| `contract/ledger/doc.go`, `catalogue.go`, `catalogue_test.go`, `golden_test.go` | Additive F3-10 catalogue, rules, declared consumption and golden compatibility only |
| `contract/ledger/testdata/f3/10/log/00000000000000000001.jsonl` | New F3-10 golden beside existing F2 golden directories |

Non-test file splitting within the new runtime package is not frozen; responsibilities and complete behavior are. Do not create empty files. Production imports: standard library plus existing `contract/ledger`, `contract/ledger/appender`, `internal/core/ledgerstore` and `internal/core/durable` where used. Only scratch integration tests import `internal/core/workspace`; production reads its frozen records, because workspace has no inert lookup and `Scratch` creates on first use. Contract remains standard-library-only; x/sys stays inside durable. Sources: DEC:D29,D45,D50,B3; CON:7; `internal/core/workspace/scratch.go:51–53`; P1,P10.

**Not owned:** implementation changes under `internal/core/ledgerstore`, `internal/core/workspace`, `internal/core/durable`, or `contract/ledger/appender`; existing record payload encodings; `tools/check`, provider/router/Undercurrent/launcher packages, `cmd`, `go.mod` and `go.sum`. An unforeseen need outside the table stops for PM assignment rather than a second convention. Sources: assignment “Code to follow, not to change” and “Not in scope”; DEC:D29,D41,D45.

The drafter/PM, not the coder or this designer, owns contract-register/freeze and close documents: `docs/CONTRACTS.md`; one D-NEXT freeze entry and one B-NEXT close entry in `docs/DECISIONS.md`; C3's `docs/ROADMAP-CORE.md` Status and the `docs/ROADMAPS.md` board together; ticket 10's status/criteria/comments; and `.scratch/dwarf-harness/c3-evidence/` copies of the brief, ruling, freeze evidence and final acceptance evidence. Do not mark C3 Done at ticket 10. Sources: DEC:D116 items 1,3–4,D125; RC:498–514; assignment “Settled”.

## §2 — Ownership, private layout and authority

### Authority and storage invariants settled by the sources

1. The private address is `(colony, agent_id, context_id)`, not a name, current GUI selection or pooled session transcript. An execution-session audit trail is inspection/recovery data only; no operation loads it as another context's prompt. Agent-wide instructions/general lessons remain deliberately shared starting points, never an aggregation of private context memory. Sources: DEC:D21,D25; CORE:447–485; RC:478–485.
2. Core owns the context directory, immutable `core/objects/<sha256>` and the memory/handoff materializations. `core/state.json` is discardable. `router/` holds only the actual router producer's context state/provider artifacts; create no `undercurrent/`, router files, task database or other producer directory before its producer exists. Sources: RC:421; CORE:918; CON:34–40.
3. Context-private bytes never enter public `bodies/`, ledger payloads, body references, error text, active-context labels or another agent's snapshot. The ledger carries hashes and replay-essential binding facts. Same-user filesystem access is not claimed as an OS sandbox. Sources: CORE:149–157,479–485,522; DEC:D33,D38,B3,B7.
4. Immutable objects survive later revisions; an unreferenced prepared object is not committed. No automatic private-object deletion/compaction policy. Operational receipts/history are not D90's finite cosmetic retries. Sources: DEC:D35,D36,D38; CORE:849–859; RC:450.
5. A context owns a scratch **per workspace**, not a directory shared by all contexts in a session. Existing workspace records own scratch creation, closure, temporary work and merge-back. Ticket 10 must consume that binding, not duplicate its authority in JSON or create a second scratch manager. Sources: CORE:454–457; RC:300–302,478–485; CON:F2-05/F2-07 catalogue.

### Exact private layout (P3, P5, P6)

```text
<colony>/
  agents/<registered-agent-basename>/
    Agent.md                          # agent-wide instructions, managed materialization
    Memory.md                         # deliberately retained general lessons, managed
    core/objects/<sha256>              # immutable agent-wide revisions
    core/state.json                   # optional, rebuildable agent projection
    contexts/<canonical-context-uuid>/
      Memory.md                       # this context only, managed
      Handoff.md                      # this context only, managed
      core/objects/<sha256>            # exact immutable context objects/chunks
      core/state.json                 # optional, rebuildable context projection
    audit/                            # optional audit view; authority stays in colony ledger
  scratch/<workspace-owned-short-id>/  # existing workspace module's authority, not copied here
```

The registration binds a previously unregistered safe basename beneath `agents/`, its agent UUID, its one execution-session UUID and its general-work context UUID. It is the storage/identity primitive for test agents, **not** a birth/clone/role/ordinary-work-eligibility approval or an agent activation command. No path is inferred by scanning names on restart; no ID/session is regenerated on Open. General and task-shaped work contexts use the same independent storage; no task record is fabricated for a work context. Relationship/board kinds wait for C6. Sources: RC:425–427,478–485; CORE:447–457; DEC:D21,D37,D38; P3.

Basename: 1–128 ASCII bytes matching `[A-Za-z0-9][A-Za-z0-9_-]*`; no dot/separator/drive or reserved Windows device basename (`CON`, `PRN`, `AUX`, `NUL`, `COM1`–`COM9`, `LPT1`–`LPT9`, case-insensitive). The trusted Core caller supplies D38's `<name>-<short id>` spelling and freshly Core-generated UUIDv7 IDs. Compare registered basenames case-insensitively on every host; a registered directory never moves/rebinds. Check each owned ancestor as a real directory and every object/materialization as a regular file; refuse symlinks/junctions/reparse/special entries. Never create unused producer directories or import pre-existing unregistered Markdown as state. This is fail-closed path handling, not same-user containment/race proof. Sources: DEC:D37,D38,B3; CORE:149–157,521; P3,P5.

Objects are addressed **within their owning scope**, never a colony-wide dedup store: an agent-wide object is resolved only below that agent's `core/objects`, a context object only below its own. Same bytes in two contexts may hash alike but do not grant an alias/read path between them. The hash is SHA-256 of the exact bytes, lowercase hex in the filename, with no newline/Markdown normalization. Context memory/handoff are initialized as empty real documents; transcript and continuation are absent until supplied, not synthetic empty provider records. Sources: DEC:D33,D35,D38; CORE:479–485,918; P5,P6.

Memory and handoff replace their exact prior content. Transcript changes append one immutable non-empty chunk; ledger revision order and its predecessor bind the chain. Continuation is an exact context-owned opaque object, replaced or explicitly cleared, never inferred from session focus. Ticket 10 neither interprets provider continuation IDs/reasoning blocks nor defines a finished-message/tool schema, compacts history, renders prompts or touches router-owned artifacts. Authorized reads return exact bytes and explicit absent continuation; no fallback to another context is permitted. Sources: CORE:479–485,918; RC:443; T13–T15:10–12; P6.

`core/state.json` schema 1 is a serialization of that scope's **projection only**: `schema`, `agent_id`, `session_id`, optional `context_id`, `revision`, `through_sequence` and `heads` (the currently present slot names with hash/byte-count and transcript-head reference). IDs/digests use the contract spellings; counters are plain unsigned decimals. The cache contains no private content, grant, receipt authority or independent command-ID index. On Open discard/overwrite it from authoritative replay; do not even decode it as an input authority. Its loss/corruption changes neither committed state nor receipts. Atomic cache-save failure is reported separately and does not roll back a committed operation or justify dispatch. Sources: T10:33; CORE:918; DEC:B3; P5,P9.

## §3 — Typed Core transitions and command semantics

### Public typed interface (P1–P4, P7–P10)

The interface is an in-process Core interface, not C7's launcher protocol or a model-facing argument parser. `Open` takes the real store, colony root and explicit finite `Limits`; `Close` drains admitted local operations but never closes the shared store. Store/log root identity must match the supplied colony. No wall-clock read occurs in replay; IDs/times/sequences follow existing ledger primitives. Sources: CORE:257–300,849–864; DEC:D37,D45,D50; P1.

```go
Open(ctx context.Context, store *ledgerstore.Store, colonyDir string, limits Limits) (*Service, *OwnerControl, Reconciliation, error)
(*Service).Close() error
(*OwnerControl).Bind(agentID, sessionID, contextID uuid.UUID) (*ContextAccess, error)
(*Service).RegisterAgent(ctx context.Context, AgentRegistration) (CommandResult, error)
(*Service).CreateContext(ctx context.Context, ContextCreation) (CommandResult, error)
(*Service).WritePrivate(ctx context.Context, PrivateWrite) (CommandResult, error)
(*Service).Snapshot(ctx context.Context, ReadBinding) (Snapshot, error)
(*Service).ReadPrivate(ctx context.Context, PrivateRead) (PrivatePage, error)
(*Service).CommandStatus(ctx context.Context, CommandLookup) (CommandResult, error)
(*Service).ReconcileInterrupted(ctx context.Context, owner *OwnerControl) (Reconciliation, error)
(*Service).ScratchBinding(ctx context.Context, ScratchLookup) (ScratchBinding, error)
```

These are the complete operations, not a universal `Do(map[string]any)` or user-supplied record writer:

| Typed value | Fields and meaning |
|---|---|
| `OwnerControl` / `ContextAccess` | Opaque, process-local, unexported-field capability objects minted only by Open/the live owner control. They carry private service-incarnation identity, owner principal kind and, for context access, fixed agent/session/context IDs. Commands/reads require the matching live capability, not an `Actor` field. The registered session must be that agent's one session. |
| `AgentRegistration` | Live `OwnerControl`, `CommandID`, proposed `AgentID`, `SessionID`, general-work `ContextID`; `Directory` safe basename; exact `AgentMarkdown` bytes; `ExpectedVersion=0`. Register identities once, initialize agent instructions/general memory and the general context's memory/handoff, and return committed revisions. Duplicate identity/directory bindings refuse; no turn/role/grant/activation is created. |
| `ContextCreation` | Live `OwnerControl`, `CommandID`, registered agent/session and new context ID, `ExpectedVersion=0`, `Kind=work`. General context is created only with agent registration; a work context does not assign a task. |
| `PrivateWrite` | Live `ContextAccess`, `CommandID`, `Scope=agent|context`, `ExpectedVersion`, and non-empty canonical `Changes` set. Agent scope permits `instructions`/`memory`; context scope permits `memory`/`handoff`/`transcript`/`continuation`. A change is exact copied bytes for `replace` or `append`, or explicit continuation `clear`; no caller path is a target. |
| `ReadBinding` / `Snapshot` | Live `ContextAccess` and scope; immutable snapshot of ownership, revision, slot-head identities/availability, current blocked/pending reasons and actual ledger high-water. No private bytes from another scope, synthetic task/turn/grant data or session transcript is returned. |
| `PrivateRead` / `PrivatePage` | Live `ContextAccess`, scope, slot, exact requested revision and transcript chunk cursor if applicable; explicit `MaxBytes` not above the limit. Return exact bytes/absence and revision, or bounded transcript chunks in original order plus next cursor. Never silently substitute a newer revision, truncate a chunk or fall back to a previous context. |
| `CommandLookup` / `CommandResult` | Live `ContextAccess` plus `CommandID` and canonical request digest; return immutable `Receipt` and separately its current pending/terminal `Result`, if any. Receipt binds command ID, derived owner principal and fixed context/session/agent, normalized digest, operation, target, original admission outcome, request/operation ID and actual receipt sequence. Registration/context-creation receipts additionally permit a current owner root to retrieve them with explicit original target IDs/digest; root pointers themselves never persist. |
| `ScratchLookup` / `ScratchBinding` | Live `ContextAccess`, workspace ID and optional expected scratch ID. Read the frozen F2 projection for the context/workspace's open dedicated scratch and report present/absent/closed or identity mismatch, never create it. Temporary scratch identities are separately identifiable, never substituted as that dedicated pair binding. No arbitrary path or write authority is returned. |
| `Reconciliation` | Scoped integrity reports, pending write IDs, and recorded interrupted endings; no writable references to internal maps/private state. |

Cache diagnostics are separate from committed receipt identity. Snapshot/result values and returned bytes are immutable copies; after admission no caller mutation can change the copied request. Targets bind at entry, never ambient view focus. Sources: T10:29–33; SPEC:393–395; CORE:447–485; RC:450; P2–P10.

### Current authority without a grant substitute (P2)

There is **no existing authenticator to reuse**: workspace's Actor/WriteBinding values are explicitly caller-stated, and the source map found no reserved bootstrap owner-only storage policy (`internal/core/workspace/request.go:14–24,38–44`; `write.go:42–46`; `doc.go:642–647`; DEC:2262). P2 therefore proposes the narrow real authority mechanism below, rather than pretending `ledger.Actor` is identity proof:

- `Open`, called by the trusted host holding the real colony store/writer lock, returns one opaque `OwnerControl`. Only that constructor mints the root; it is retained by the host, never serialized, written to the ledger/private files, accepted from a caller string or given to an agent. Zero/foreign controls cannot authorize anything.
- The live root's `Bind` checks registered ownership and mints an immutable `ContextAccess` for one exact agent/session/context. There is no public constructor or mutable ID/Actor field on that capability. A command's actor is derived as owner from its matching live capability, never supplied by model text.
- Validate pointer/service-incarnation identity, live state and fixed target **before** any ID existence, digest, hash, count, private error or receipt detail is disclosed, and again before a final revision commits. Close invalidates all controls/access handles, including old ones presented after reopening. A new Open produces a new root; the stable owner principal spelling and command digest do not include the ephemeral handle, so authorized replay still works across restart.
- Owner inspection is explicitly owner-scoped storage inspection, not agent impersonation or a source of model evidence. This capability proves current in-process authority; it is **not** OS-user/network authentication or C10 containment. C7 supplies its own transport authentication later.

This restricted storage capability is complete in ticket 10, with no `Authorizer` callback, permissive grant, model/tool admission, inherited agent permission or paid allowance. Agent-originated reads/writes remain default-deny until ticket 11 supplies its actual current grant machinery through this module's existing bound transition seam. P2 is a staging choice for the advisor to rule explicitly, not a claim that the sources already chose it. Sources: T10:31–32; T11:10–12; RC:125; CORE:257–300,930; DEC:B7; CON:28,39.

Every read/status method revalidates its live capability **after** filesystem/ledger IO and immediately before returning bytes/metadata; a Close or binding/lifetime change during the read cannot disclose through an old handle. This is the current owner capability check, not simulated task-grant revocation. Exactly one runtime Service may own a store in an incarnation, as workspace's host-owned-store pattern requires; Close drains it before another Open over that store. Sources: T10:31–32; SPEC:603–605; `internal/core/workspace/service.go:49–59`; P1,P2.

### Canonical request and receipt rules (P7, P8)

Canonical submission is compact JSON from fixed structs with keys exactly `schema` (1), `actor` ("owner"), `agent_id`, `session_id`, `context_id`, `operation`, `target`, `expected_version`, `arguments`. `target` always has keys `scope`, `slots`, exactly as the receipt table; registration uses agent/empty slots, context creation context/empty slots, private.write the addressed scope/manifest slots. Registration `arguments` keys: `directory`, `agent_sha256`, `agent_bytes`; creation: `kind`; private.write: `changes` with tabled entry order but without the derived transcript predecessor. Hash every exact supplied byte via its digest/size, include all supplied UUIDs/expectations and canonical sorted slots, never a path/view spelling. Command ID, ephemeral capability, ledger metadata and derived predecessor are excluded. SHA-256 of these canonical bytes is submission_sha256. No model-input coercion or provider schema is added. Sources: LD:201–217; RC:450; DEC:B21; P8.

There is **no public ledgerstore lookup** besides Submit (`internal/core/ledgerstore/commands.go:128–160`). After validating capability under the short lock, capture a durable high-water and stream complete F0/F3-10 commits through the existing Reader **outside** that lock, retaining only the requested ID's same-group receipt and later result. Revalidate capability and scan any newly committed tail for that ID before CAS/admission, so a raced completion remains a replay, not stale refusal. Ownership/heads/bounded pending work remain projections; no permanent receipt map or second on-disk index. Same ID/digest returns original receipt plus current result before CAS/integrity/capacity checks; different digest refuses. A foreign producer's bare F0 tombstone fabricates no runtime receipt. Submit remains the global immutable-ID backstop. Sources: LD:130–154,201–217; `internal/core/ledgerstore/commands.go:128–159,251–340`; DEC:B3,B21; `internal/core/workspace/activation.go:125–137`; P7,P8.

To avoid scanning all history for every fresh command without a second receipt index, replay maintains one aggregate `max_seen_command_uuid` over **all committed F0 command IDs**. A candidate UUID lexicographically greater than that maximum is provably absent from that complete prefix; this is a set-key bound, never a clock/order/authority inference. IDs at/below the maximum always use authoritative Reader lookup. Recheck the tail/maximum under admission serialization. Open detects reused F3 command IDs with the same prefix lookup when needed, rather than retaining every old ID; current-group and pending-operation duplicates are immediate refusals. Keep actual colony sequence as the sole replay order. Sources: DEC:D37,B3,B21; LD:201–217; P8.

### Private-write transition ordering (P4, P5, P7)

1. **Authorize, identify and normalize.** Validate capability/shape/byte lengths first. Caller buffers must not be mutated until the call returns. Check the command ID through the authoritative reader path; for a retained ID hash bounded input without allocating a retained content copy, compare the complete normalized digest and return its receipt/result before capacity/CAS. For a new ID reserve one finite preparing slot, then copy and hash its bounded bytes outside the short lock. No live materialization changes yet.
2. **Admit, one replay-complete group.** Under the lock recheck capability, binding, duplicate identity and expected revision. Pass an encoded F0 `ledger.command` draft separately to `store.Submit(ctx, commandDraft, effectDrafts)`, with effectDrafts exactly started+accepted receipt. Submit writes the F0 prefix; ordinary Append must never receive it. Apply/journal the acknowledged whole group and hydrate actual receipt sequence before exposing accepted/pending. A duplicate that raced preparation releases the extra unadmitted reservation and returns original state. No private revision is committed at admission.
3. **Publish bytes outside the lock.** For each non-clear change, create a bounded exclusive temporary regular file inside the owning private object directory, write/hash/flush/close it, publish to its digest name with the existing durable atomic-rename/directory-sync pattern, and verify any existing same-name object by exact size/hash. Never overwrite a bad object or publish a revision referencing a temp file. Success leaves immutable private bytes only; they are still not selected authority.
4. **Complete, one replay-complete group.** Re-enter the lock and recheck exact admitted binding, current authority and expected revision; another context or a concurrent same-scope winner cannot be silently rebased. Re-verify the proposed published objects. Success appends `private.revision` and `runtime.private_write_ended(outcome=applied)` together, with revision expected+1. A lost CAS appends only `runtime.private_write_ended(outcome=refused,reason=stale_revision)`; failed byte publication appends only a failed ending with no revision. No caller constructs either group independently.
5. **Materialize, project, acknowledge.** The committed head is first marked materializing; outside the global transition lock atomically publish selected Markdown from its immutable objects, using file Sync plus durable.Rename/SyncDir. A per-scope filesystem mutex orders object publication, completion and materialization, while unrelated scopes progress; acquire that mutex before the short global lock, never wait for it while holding global. New same-scope effects/reads cannot bypass materializing; stale expected revisions still refuse. Re-enter the short lock to publish ready authorized projection/cursor, then attempt optional cache save outside it. Only then return successful application. Materialization/required-projection failure preserves committed receipt/result, returns a blocked/not-acknowledged typed error and fences the scope, never rolls back or retries the ledger. Cache-save failure is only a cache diagnostic.

Initialization (`RegisterAgent`/`CreateContext`) publishes its initial objects first, then submits one atomic group containing identity/context creation, the initial private revision(s), and its applied receipt. It has no split write operation or unmatched start. Initialization refuses existing conflicting private materializations rather than importing them as new history. Creation and private-write groups each satisfy §5's bounded shapes. Sources for all ordering: T10:30–33; SPEC:393–395,591–597; DEC:D37,D38,B7; CORE:849–864,918; P4,P5,P7.

Store failure uses the existing meanings: definite refusal leaves no new committed group; uncertain append/flush never acknowledges, fences this module incarnation and requires reopening/recovery before later mutations. Journal preflight cannot leak draft state after definite refusal, and actual returned `Committed.First/Last`, not predicted sequences, hydrate projections/receipts. All expensive byte publication stays outside the short transition; there is no alternate appender, caller restart callback, timer or goroutine per dormant context. Sources: `contract/ledger/appender/appender.go:1–36,47–57`; DEC:B3,B7; SPEC:393–395; P1,P8,P9.

Live ingestion uses one `through_sequence` cursor for **all** consumed commits, including interleaved workspace commits: refresh the existing Reader through the captured durable high-water before queries/preflight. Journal preflight remains hidden under the lock; after Store acknowledgement, undo its provisional projection and ingest actual complete commits through returned Last (including intervening F2 records), then materialize/publish. Do not advance a guessed cursor past unseen external commits or apply the own group twice. An actual-record hydration failure after durable append poisons this incarnation without undoing committed bytes. Current/live memory is ownership, heads and bounded pending work; old receipts/history are streamed, not retained forever. Sources: `internal/core/workspace/service.go:185–239,288–401`; DEC:B3,B7; P1,P8–P10.

Private publication reuses the **pattern**, not the public body store: ensure new directory entries are durably synchronized child-before-parent; create a regular temp in the owning object directory; write bounded bytes, Sync, Close; publish with durable.Rename and verify existing content before reuse. Hold the scope filesystem mutex so a check-then-rename cannot overwrite an independently published object. Markdown/cache files use their own same-directory temporary file, Sync/Close, durable.Rename; include directory creation flushes. No call to workspace's rebuildable `writePinnedFile` suffices for durable objects, and durable.Rename alone does not flush file data. Preserve unreferenced published objects; remove only this call's temporary file on failure, joining errors. Sources: `internal/core/durable/durable.go:5–24`; `internal/core/ledgerstore/bodies.go:217–245,304–339`; `internal/core/workspace/inputs.go:357–390`; P5.

`Limits` fields are `MaxObjectBytes int64`, `MaxOperationBytes int64`, `MaxPendingWrites int`, `MaxReadBytes int64`, `MaxReadChunks int`, with §5's proposed defaults 1 MiB/4 MiB/16/4 MiB/64. Initialization uses the same preparing capacity as other private publication. Historical objects remain verified/read under the absolute supported object limit rather than being declared corrupt because a new deployment lowered its write profile. F3-10's separate 16-KiB payload decoder/encoder cap is a family format rule frozen with this slice; it does not change F0's caps. Sources: CORE:849–859,918; LD:81–86; P11.

Errors wrap stable sentinels as existing Core does; prose is not API: `ErrInvalid` (shape/path/unsupported slot), `ErrNotBound` (invalid/foreign/closed capability or target), `ErrRevision` with expected/current (stale), `ErrCommandMismatch`, `ErrIntegrity` with scope/slot/revision and content-free reason, `ErrRecoveryPending`, `ErrTooLarge`, `ErrUnavailable`, and wrapped appender poison/uncertain/closed errors. BusyError's bounded reason is `private_capacity` or `materializing`; no permission refusal is disguised as busy. Inconsistent committed records wrap a typed inconsistency with sequence; consumed-version errors retain the existing ledger unsupported-version type. New operations refuse while closing. Close invalidates access, prevents new work, waits for publishers/readers/materializers with colony handles, then returns without closing store. Caller context bounds admission/read waits; after durable admission, a write owns its copied bytes and completes or records a terminal result independently of a disconnected caller. Sources: `internal/core/workspace/service.go:49–59,288–320`; `contract/ledger/appender/appender.go:7–24`; SPEC:393–395; P1,P2,P7.

Transcript occurrence identity is its private-revision sequence/revision, **not** only its content hash. Two identical appended chunks are two ordered occurrences and must both be returned. `PrivateRead` pins a scope revision, streams ledger-selected occurrences through it, and uses the last returned occurrence sequence as cursor (0 starts). Return whole chunks only; if the next single chunk cannot fit requested MaxBytes, return ErrTooLarge rather than an empty advancing page. No length-only/deduplicated transcript or hash-pointer loop is permitted. Sources: CORE:479–485,918; DEC:D35,D37; P6,P11.

## §4 — Recovery and isolation

### Open/replay is reconstruction, not execution (P9)

All runtime Reader paths (Open, incremental refresh, receipt/prefix/history lookup) declare their actual consumed versions and set `AllTypes:true`; preserve complete commit envelopes for shape/identity checks, while skipping unrelated payloads. Never reconstruct a group from only the visible F3 records and thereby hide an extra foreign record. Sources: LD:130–154; `internal/core/workspace/service.go:185–239`; P8–P11.

`Open` verifies the real colony/store root and streams complete committed groups with declared F3-10/F0 plus F2 ScratchCreated/ScratchClosed v1 consumption. Unrelated families are skipped by the existing Reader. Apply whole groups through the same journalled reducer/preflight; unsupported consumed versions, ownership contradiction, duplicate receipt/result, illegal F3 group, stale predecessor or orphan ending fail closed. F2 records remain their producer's authoritative facts, not a second scratch lifecycle. Replay reads no clock, calls no provider/tool/Git/scratch creator, allocates no session, dispatches no work and appends nothing. Sources: T10:33; DEC:D35,D37,B3,B7; LD:130–154,327–365; SPEC:591–597; P9,P10.

After replay, inspect **ledger-selected** immutable objects and managed materializations. Verify scope/root containment, regular-file kind, byte count and exact SHA-256; verify transcript predecessor links/order. Missing/corrupt referenced historical objects block history reads that need them; missing/corrupt current objects or current `Agent.md`/`Memory.md`/`Handoff.md` block the affected scope and report precise identifiers/slot/revision, without including private content. Agent-wide failure fences all that agent's context use; a context-local failure does not import another context or corrupt its siblings. `core/state.json` is discarded/rebuilt, not compared as authority. Sources: T10:30,33; CORE:918,1024–1026; DEC:D38; P5,P9.

No mismatch is silently repaired by trusting a materialization, advancing a head, dropping a record or copying from a neighboring context. A valid immutable head with missing/wrong Markdown is still a reported blocked materialization, including the legitimate commit-before-materialize crash gap. Ticket 10 does **not** add an automatic repair command or repair policy. The report preserves the committed hash so an explicit future authorized repair can choose the exact ledger bytes rather than guess; do not make that future capability a stub in this ticket. Sources: T10:30; CORE:918; DEC:D38,D41; P5,P9.

### Interrupted operations and honest results (P7, P9)

Only unmatched starts **loaded from the previous incarnation at Open** become `pending_recovery`; currently executing writes remain ordinary pending operations and cannot be interrupted by this method. New mutations in a recovered scope refuse until explicit `ReconcileInterrupted(owner)` closes those starts, in start-sequence order, as interrupted/restart. Repeated reconciliation checks ended identity and appends nothing twice. Never publish proposed bytes, resume work or infer success. A current root is required; invocation over a still-live prior module is forbidden by the one-module/Close-drain precondition. Failures retain pending/poison state. Sources: T10:31–33; DEC:D37; `internal/core/workspace/doc.go:626–633`; SPEC:393–395,591–593; P7,P9.

A surviving complete success group yields its actual committed revision/result even after lost ack; current private availability remains a separate blocked/ready fact. Same-ID replay never writes again. Admission alone replays original accepted receipt plus interrupted result after reconciliation. Explicit retry of an ended operation uses a fresh command ID/expected revision. No private result proves external provider/tool/promotion success. Sources: T10:31; DEC:D37,B7; RC:450; P7,P8.

Private-object publication without the revision group creates only an unreferenced immutable object; it cannot become selected state on restart. A torn trailing commit is handled by the existing store's frozen recovery rules and contributes no partial private revision/result/receipt. An uncertain append never licenses a second attempt before recovery determines the committed bytes. Sources: T10:30–33; CORE:849–859,918; `contract/ledger/appender/appender.go:7–24`; P5,P9.

### Isolation and later handoffs (P2, P6, P10)

One agent/session may address several context handles concurrently; each operation carries its immutable context/target regardless of later view selection. Only the specifically addressed context's memory, handoff, transcript chunks and continuation can be read/changed. No automatic general-memory aggregation, provider-response-ID reuse, approval/route/cache transfer, prompt pooling or implicit outbound destination change exists. Dormant contexts have no dedicated goroutine, connection or model call. Authorized deliberate transfer is not implemented as a hidden copy during switching. Sources: T10:29; DEC:D21,D25; CORE:447–485; P2,P6.

The scratch binding view ingests frozen `workspace.scratch_created`/`scratch_closed`, retaining IDs, workspace, context, parent-temporary marker and current closure facts. It returns only a registered context's exact dedicated binding; unknown/closed/foreign expected IDs refuse or report their explicit availability, never allocate. `Scratch` is **not** a lookup: tests alone call the real workspace.Scratch to obtain two distinct pairs, then verify runtime's inert view before/after restart and after closure. The view is an authorized projection of F2, not new authority or a filesystem write grant. Sources: `internal/core/workspace/scratch.go:51–53`; LD:327–365; CON:F2-05/F2-07; P10. Tickets 11–16 reuse these private transitions/receipts; none gets a direct private writer or separate restart hook (T10:32; T11–T16:10–12).

**Integrity and service loss:** expose the failed-integrity evidence and blocked state, not a fabricated service-restoration success. CORE §13.11 identifies failed private restart integrity as an execution-failure cause with immediate onset; ticket 10's storage report is that actual input, not generic interrupted-turn evidence. Do not freeze outage/notices/restoration families or implement C8 officer consequences here: this ticket neither has a completed provider call nor claims whole C3 service-loss acceptance. Sources: CORE:1024–1038; RC:426,505–507; T10:10–12,29–33; P9.

## §5 — F3-10 contract proposal

### F3-10 catalogue and ownership (P11)

Add six version-1 types to `contract/ledger`; `Defined()` becomes 30 type versions (the existing 24 plus six). Reserve `runtime.` for C3 runtime families and `private.` for Core private revisions. This freezes neither all F3 nor a launcher/context-module interface. Encode/Decode follow the existing standard-library payload convention: compact JSON in tabled key order, errors wrapping `ledger.ErrInvalid`, bounded complete object input, required keys, no duplicate key at any depth, no null known key, canonical UUIDv7/digests and plain unsigned-decimal counters. Unknown optional keys are ignored, including inside change/target objects; forbidden conditional keys remain absent, never null/defaulted. Sources: LD:181–199,255–269; CON:7–19,34–40; DEC:D35,D40,D125; P11.

| Type, v1 | Owner / producer / permitted caller | Consumers and privacy | Replay-essential facts |
|---|---|---|---|
| `runtime.agent_registered` | C3 / Core runtime / `internal/core/runtime` only, enforced by review | Runtime ownership/replay; later authorized C3/C7 identity views. IDs and relative basename, no private content | Mandatory identity envelope; directory/general-context identity |
| `runtime.context_created` | Same | Runtime ownership and later task/runtime bindings. Kind/IDs, not a task or communication grant | Mandatory identity envelope; context kind |
| `runtime.private_write_started` | Same | Runtime pending/recovery. Hashes/sizes/slots are private metadata, not public broadcast | Scope, expected revision and complete proposed change manifest |
| `private.revision` | Same | Runtime heads/history; later context producers/authorized inspection. Bytes remain in private objects | Scope, predecessor/current revision, exact selected object/chunk/clear facts |
| `runtime.private_write_ended` | Same | Runtime result/recovery and original bound owner context. No external-success claim | Matching operation, outcome/reason and applied revision if any |
| `runtime.command_receipt` | Same | Runtime dedup/authorized views. Principal/binding/target/outcome identities, no private bytes | Command/digest, operation/target, expectation, admission outcome/request ID; actual envelope sequence |

All six require envelope `agent_id`, `execution_session_id`, `context_id`, `operation_id` (UUIDv7), `measurement_path="runtime.private"` and type version 1. Context is explicit, including the general context for registration/agent-wide writes. `turn_id`/`body_refs` are absent. Owner-origin identity/start/receipt records and F0 command have `actor=owner`; observed revision/ending records have `actor=core`. No private byte/secret enters either envelope or payload. Unsupported consumed versions stop replay. Sources: `contract/ledger/envelope.go:31–66`; LD:181–217; DEC:D35,D37,D38; CORE:918; P11.

Runtime checks service record rules before Submit/Append **and** during Open. Payload codecs, Check, Reader and EncodeCommit do not enforce cross-record/filesystem rules; no ledgerstore/appender change is needed. Sources: LD:255–269; `internal/core/workspace/doc.go:661–680`; `service.go:388–401`; P1,P11.

### Finite bounds and values (P11)

Provisional runtime limits: object/chunk ≤1 MiB; bytes/operation ≤4 MiB; ≤4 changed slots (≤2 agent-wide); ≤16 admitted/preparing private operations per colony incarnation; page ≤4 MiB and ≤64 whole transcript chunks. Limits supplies positive values no larger than these defaults; invalid/missing profile is unavailable. Counters support MaxInt64; deployment limits may refuse smaller. **Family codec payload cap is 16 KiB**, frozen with F3-10; frozen F0 line/commit caps stay 1/16 MiB. None is measured capacity. Sources: CORE:849–859; `contract/ledger/envelope.go:25–28`; DEC:B3; RC:17; P11.

After authority and old-ID/digest resolution, reserve a preparing slot before retaining/copying any new input; bounded hashing of an old retry requires no retained content copy. Initialize/create use the same preparation bound. This is local private-publisher capacity, not a durable grant/BudgetBook or paid allowance. Release unadmitted reservations on refusal/cancellation; retain admitted write slots until ending commits, including replay-pending ones. New over-cap work returns BusyError private_capacity before bytes/records; duplicate retrieval remains available. No queued retry. Sources: DEC:B3,B7; T10:32; T11:10–12; P4,P11.

Operations: `agent.register`, `context.create`, `private.write`. Scopes: `agent`, `context`. Context kinds: `general`, `work`. Revisions: plain unsigned decimals 0..MaxInt64; initial expectation 0/current 1; later current=expected+1, never wrap. Sorted sets compare UTF-8 bytes strictly, excluding duplicates. Reason tokens match `[a-z][a-z0-9_]{0,63}`. Sources: DEC:D35,D37; LD:183–194; P3,P4,P11.

Every `changes` element has this encoder order:

| Key | Type/presence | Rule |
|---|---|---|
| `slot` | required string | Agent `instructions`/`memory`; context `continuation`/`handoff`/`memory`/`transcript`; array strictly slot-sorted |
| `mode` | required string | `replace` for instructions/memory/handoff; `append` for transcript; `replace`/`clear` for continuation |
| `sha256` | digest; required except clear | Exact bytes' nonzero lowercase SHA-256; SHA-256(empty) valid for Markdown, never all-zero sentinel |
| `bytes` | integer; required except clear | 0..MaxInt64 and producer cap; transcript/continuation replacement >0; Markdown may be empty |
| `previous_sha256` | optional digest | Only transcript append after an earlier chunk; equals exact previous head. Absent for first chunk/non-transcript |

Clear has no hash/count/predecessor. Initialization has complete sorted agent `{instructions,memory}` or context `{handoff,memory}` replacement sets; no fake transcript/continuation. Starts carry the derived transcript predecessor at checked expected revision; completion exactly matches its typed manifest. Sources: CORE:479–485,918; T10:30,32; P4,P6,P11.

### Payload fields, in encoder order

All keys required unless explicitly optional; common identity envelope fields are not duplicated.

**`runtime.agent_registered` / `RuntimeAgentRegistered`:**

| Key | Type | Rule |
|---|---|---|
| `directory` | string | §2 safe basename, globally unique registered directory |
| `general_context_id` | UUIDv7 | Equals envelope context; general context created in same group |

New agent/session IDs; session becomes this agent's immutable sole session. No role/membership/task/grant/credential/turn placeholder. Sources: DEC:D21,D37,D38; RC:425,478–485; P3,P11.

**`runtime.context_created` / `RuntimeContextCreated`:**

| Key | Type | Rule |
|---|---|---|
| `kind` | enum | `general` exactly once at registration; `work` under existing matching agent/session |

The `(agent_id,context_id)` address is new, and a context UUID is never registered to a second agent in this colony: Core-generated UUIDs identify one context, matching existing F2's colony-wide context/workspace keys. Reject cross-agent ID reuse rather than aliasing its scratch. Creation includes its initial revision. Sources: DEC:D21,D37; CORE:447–457; LD:341–345; P3,P10,P11.

**`runtime.private_write_started` / `PrivateWriteStarted`:**

| Key | Type | Rule |
|---|---|---|
| `scope` | enum | agent/context |
| `expected_version` | integer | 1..MaxInt64-1; equals then-current scope revision |
| `changes` | non-empty array | Complete sorted bounded manifest above |

Operation ID equals group's F0 command ID, never previously started/ended. This is admission/pending only. Owner principal/canonical digest are in the same F0/receipt group. Sources: T10:31–32; DEC:D37; LD:201–217; P4,P7,P11.

**`private.revision` / `PrivateRevision`:**

| Key | Type | Rule |
|---|---|---|
| `scope` | enum | agent/context |
| `expected_version` | integer | 0 at initialization; otherwise matching start/current expectation |
| `revision` | integer | Exactly expected+1, 1..MaxInt64 |
| `changes` | non-empty array | Selected manifest; each object durably published in owning private directory first |

At most one revision/scope/group; registration's two scopes are distinct. Normal write revision exactly matches its start and is adjacent to its applied ending. Hash equality grants no cross-context alias; private hashes are not body refs. Sources: T10:30,32; RC:421; CORE:918; P4–P7,P11.

**`runtime.private_write_ended` / `PrivateWriteEnded`:**

| Key | Type/presence | Rule |
|---|---|---|
| `scope` | required enum | Matching start's scope |
| `outcome` | required enum | Closed `applied`, `refused`, `failed`, `interrupted` |
| `reason` | optional token | Absent applied, required otherwise. Defined: refused `stale_revision`/`authority_lost`/`integrity_blocked`; failed `publication_failed`; interrupted `restart`. Unknown well-formed reason retained within its non-success outcome |
| `revision` | optional integer | Required exactly applied, equals adjacent PrivateRevision; absent otherwise |

Exactly one ending/prior start, same operation/agent/session/context/scope. Non-applied changes no head. Interrupted records missing completion, not reversal/retry. Sources: T10:31; DEC:D37; SPEC:393–395,591–597; P7,P9,P11.

**`runtime.command_receipt` / `RuntimeCommandReceipt`:**

| Key | Type | Rule |
|---|---|---|
| `command_id` | UUIDv7 | Equals operation ID and group's single F0 command ID |
| `submission_sha256` | digest | Equals F0 canonical request digest |
| `operation` | enum | Three operations above |
| `target` | object | Keys `scope`, `slots`; scope agent/context; required strictly sorted distinct slot array, empty for identity/context creation, exact manifest slots for private.write |
| `expected_version` | integer | 0 registration/creation; matching positive start expectation for write |
| `outcome` | enum | `applied` registration/creation; `accepted` private.write |
| `request_id` | UUIDv7 | Agent ID registration, context ID creation, operation ID private.write |

Principal is derived owner actor plus identity envelope, never arbitrary text. Return sequence from actual receipt envelope, not a self-sequence field. Receipt is last/immutable in its F0 group; endings never rewrite it. Sources: RC:450; LD:201–217; DEC:B21; P7,P8,P11.

### Allowed group shapes and refusals

| Transition | Ordered records, one commit |
|---|---|
| RegisterAgent | F0 command, agent_registered, context_created(general), private.revision(agent,1), private.revision(context,1), command_receipt(applied) |
| CreateContext | F0 command, context_created(work), private.revision(context,1), command_receipt(applied) |
| Admit write | F0 command, private_write_started, command_receipt(accepted) |
| Apply write | private.revision, private_write_ended(applied) |
| Refuse/fail/interrupt write | One private_write_ended of that outcome |

All bind the same operation/addressed identities; registration alone has two scopes. Reject extra/missing/reordered records, wrong operation/session/context/actor/path/body refs/turn, receipt without matching F0 ID/digest, manifest/scope/expectation mismatch, duplicate ID, illegal initialization, stale predecessor, orphan/duplicate ending, overflow or applied without exact revision. Before admission, invalid/unauthorized/stale writes consume no ID. After admission, lost CAS/authority produces only its refused ending. Sources: T10:30–33; LD:201–217,255–269; `internal/core/workspace/doc.go:661–680`; P4,P7,P11.

### Golden and compatibility plan

Add `TestGoldenF3_10`, `TestF3_10Compatibility`, existing golden-decode/truncation coverage and `FuzzDecodeF3_10` (all six decoders, byte-tag dispatch). Seed valid payloads plus duplicate/nested/null/overflow/boundary inputs. Generate only by existing `-update`; fixed UUIDv7/time and real encoded hashes; preserve every older fixture byte. New golden `contract/ledger/testdata/f3/10/log/00000000000000000001.jsonl`: 20 commits / 52 records.

| Group | Sequences | Scenario |
|---|---|---|
| 1 | 1–6 | Agent/session/general-context registration; initialize both scopes |
| 2 | 7–10 | Independent work context |
| 3–4 | 11–13;14–16 | Two admitted general-context writes at revision 1 |
| 5–6 | 17–18;19 | First applies revision 2; second refused stale |
| 7–10 | 20–22;23–24;25–27;28–29 | Two work-context transcript appends, absent then present predecessor |
| 11–14 | 30–32;33–34;35–37;38–39 | Replace then clear continuation |
| 15–16 | 40–42;43–44 | Agent-wide general-memory CAS |
| 17–18 | 45–47;48 | Admission then interrupted restart ending |
| 19–20 | 49–51;52 | Admission then publication_failed without revision |

The fixture covers all types, actors, scopes, modes and outcomes; initialized Markdown covers both memory/handoff slots. Same-ID replay adds no golden record and is tested through runtime/store. Golden private hashes are identities, not body refs or real-filesystem effect proof. Tests pin regeneration/type versions, conditional keys/bounds, unknown optional compatibility and previous digests. Changed existing truncation corpus gets fuzz evidence only when its fuzzed code/corpus changes. Sources: DEC:D40,D116 item 6; LD:181–199; CON:7–19,34; P11,P12.

Freeze evidence names fields/rules, committed golden SHA-256, older byte identity, codecs/fuzz, import/module/LF checks and exact-commit check. Drafter uses the catalogue columns with concrete sequences; PM records D125's freeze, no owner answer/packet. No F0/F2/U3/interface/format-cap change. Sources: DEC:D40,D116,D125; CON:13–19,34; assignment “Settled”.

**Extension discipline, not later-ticket design:** these are only ticket-10 operations/slots and their real producer. Later task/grant/provider/turn producers may add their own fields/types/versions and explicitly conditional compound-group rules through their own additive freeze; do not pre-populate them here. Preserve all schema-1 canonical request bytes and old receipt/record decoding forever; a new producer/schema/target cannot reuse an old command ID with another normalized meaning. Future authorized agent principals replace none of P2's existing owner binding. C6's eventual message/checkpoint atomic group must extend the real producer rule, not write private files independently. Sources: DEC:D35,D40,B2,B7; LD:201–217; CORE:512,934; T11–T16:10–12.

## §6 — Tests, rule breaks and verification

### Behavioral acceptance matrix (P12)

Tests cross the actual runtime typed interface/authorized snapshots with real store/private files; real workspace only for scratch effects. No mock store, permissive authorizer, fake effect receipt, model or network supplies acceptance. Independent tests/fixture-owning rows start t.Parallel unless a documented process-global exception; no sleeps/duration assertions/unbounded inputs. **Assignment-specific bound: each race test ≤60 s**; report timing rather than adding per-test deadlines. Sources: RC:15; SPEC:585–587,591–593,603–605; DEC:B28 item 8,D131; assignment “Building”.

| Test / evidence case | Observable failure it must catch |
|---|---|
| `TestPrivateContextsDoNotFollowSelection` | Distinct contexts of one session carry different memory/handoff/transcript/continuation. A→B→A reads never import B; an admitted A operation stays A-bound. Another agent/session handle cannot address A; cross-agent reuse of a registered context UUID refuses, never aliases its private directory/scratch. Sources: T10:29; DEC:D21,D25,D37; CORE:447–485; P3,P10. |
| `TestPrivateExpectedRevisionCAS` | Two admitted writes at one scope revision produce one applied result and one stale refused ending, with no overwrite; an initially stale request writes no receipt/ID. Retrying an ended refusal uses new ID/fresh expectation; a pre-admission refusal can reuse an unconsumed ID. Cover agent-wide memory separately. Sources: T10:30,32; DEC:D22; CORE:148; P4,P7. |
| `TestPrivatePublishBeforeCommit` | Publication failure may preserve accepted receipt/start but never creates revision/applied result; its ending is failed. At hooks no committed revision names absent/wrong bytes; unreferenced prepared objects never become authority. Sources: T10:30–32; CORE:918; SPEC:591–597; P5,P7. |
| `TestPrivateReceiptReplayAndMismatch` | Lost ack/restart and same ID/digest return original receipt/actual sequence without revision; a changed target/expectation/content refuses. Exercise an old receipt behind later committed groups, not only hot pending state. Existing C1 cold-ID/eviction regressions still run in compatibility/full check. Sources: T10:31; RC:450; LD:201–217; P8. |
| `TestPrivateReplayRequiresCurrentAuthority` | Guessed ID/digest, zero/foreign/old incarnation or wrong context handle discloses no receipt/private target. Check before lookup and again after a long read/restart; no fake revocation grant is introduced. Sources: T10:31–32; SPEC:603–605; DEC:B7; CORE:942; P2. |
| `TestPrivateRebuildIsInert` | Deleting/corrupting state.json loses no heads/receipts; replay changes no private head or work artifact and starts no operation/session/turn. Rewriting only the optional cache is allowed. Sources: T10:33; SPEC:393–395,591–593; DEC:B3; P9. |
| `TestPrivateIntegrityBlocksAndReports` | Missing immutable object, altered immutable object, missing or altered committed Markdown materialization and wrong context/session binding each produce scoped, inspectable integrity failure, never success, fallback to another context or silent repair. A malformed/unsupported authoritative record fails closed, not a cache miss. Sources: T10:30; CORE:918,1024–1026; LD:130–154. |
| `TestPrivateInterruptedRecovery` | Real subprocess exits before commit and after complete commit/before projection/ack. The first operation has no committed success; the second replays its actual committed result. A torn commit is not applied. No accepted command or intent is presented as proof of external success. Sources: T10:31–33; DEC:D37; SPEC:591–597. |
| `TestPrivateScratchBindingsAreDistinct` | Two contexts of one session obtain different existing Core workspace scratches; reopen preserves pair identity; unrelated/closed/other-context scratches cannot be used as a context binding. Context creation/replay itself does not create a worktree. Sources: T10:29; CORE:454–457; RC:478–485; existing F2-05 scratch rules. |
| `TestF3_10PayloadsAndRecordRules` | Reject malformed required fields, duplicate keys, null known keys, invalid IDs/digests, overflow/bounds, wrong envelope actor/identity/context, stale predecessor and illegal commit shapes. Unknown optional keys retain the frozen additive compatibility behavior, not a new strict-unknown-key convention. Sources: DEC:D35,D40; LD:181–199; CON:13–19. |
| `TestGoldenF3_10`, compatibility and fuzz seeds | Decode the whole additive golden, preserve every earlier golden byte, round-trip each type version and preserve absent optional fields as absent. New decoder fuzz targets exercise bounded parsers and commit invariants without dispatch. Sources: DEC:D40,D116 item 6; LD:181–194; CON:7–8. |
| `TestPrivateTranscriptRepeatedChunkAndPaging` | Append identical bytes twice, then a distinct chunk; bounded pages reproduce exact occurrence order without collapse, loop, skipped last chunk or false empty advance. A later revision cannot leak into a pinned earlier read. Sources: CORE:479–485,918; DEC:D37; P6,P11. |
| `TestPrivateIndependentScopesProgress` | Hold A's real object/materialization phase at a channel hook; B commits/reads its own state without waiting on A's filesystem mutex. A reader cannot see an acknowledged mixed multi-slot revision. Sources: T10:29,32; SPEC:393–395; P4,P5. |
| `TestPrivateScratchRefreshAcrossOtherCommits` | An actual workspace creation/closure interleaved between two runtime commits is visible on the next authorized query without creating a replacement or skipping an unseen commit. Sources: LD:130–154,341–365; DEC:D50; P10. |
| `TestPrivateOpaqueHandlesAndPublicPrivacy` | Zero/foreign/closed-incarnation capability, or A handle with B receipt ID, reveals no private existence/receipt/hash. Public ledger and body-store consumers never receive known private content bytes; owner storage bytes stay private. Sources: T10:29,31–32; CORE:157,942; P2,P5. |

The §5 contract tables refine these cases; avoid a Cartesian product. Share one closed real-store prefix/matrix, copy isolated roots/row, reopen only when recovery is the subject. Hooks/channels schedule actual effects; subprocesses prove actual interruption. Each deliberate break must fail its named test, and restored bytes must pass. Sources: SPEC:587,591–593; DEC:B28 item 8,D131; `.scratch/dwarf-harness/c2-evidence/ticket-09-design-ruling.md:26`; P12.

### Bounded faults and deliberate breaks (P12)

Crash subprocesses reuse the current test executable and real store, exit at a named deterministic hook, and are positively waited before reopening; no sleep/OS-PID inference. Keep one row per distinct boundary/outcome: before admission commit; after admitted start; after object publication/before revision; torn revision group; complete revision before materialization (blocked integrity, not guessed repair); all materializations before ready projection/ack (committed result reconstructs); lost admission acknowledgement; lost success acknowledgement. Injected storage failures are labelled injected, not native power-loss evidence. One Windows sharing-handle test exercises actual failed Markdown replacement after a committed revision; do not emulate reliable ACL denial on privileged CI. No provider/tool success is fabricated. Sources: T10:30–33; SPEC:587,591–593; DEC:B28 item 8; P5,P7,P9,P12.

For a real Windows store-write failure, use a Windows-only test-held `LockFileEx` byte-range lock on the active segment's next-write range through a separate native handle, then attempt the actual runtime command/store append. Require an observed real write error/ErrUncertain, no acknowledgment and poisoned runtime/store before calling that row evidence; setup failure is missing evidence, not a skip/injected success. Release the range/handle before store Recover/Open. Use the existing narrow native-call pattern in test code only, no production adapter/dependency. Separately, a complete-commit/lost-ack crash row proves that crash Open can retain a valid commit, whereas in-process Store.Recover truncates to acknowledged end. Sources: `internal/core/durable/durable_windows.go:16–34`; `internal/core/ledgerstore/store.go:148–165,777–785`; `contract/ledger/appender/appender.go:7–24`; P12. This is a proposed deterministic fault method, not a claim it has already run.

| Break once in throwaway mutation | Named regression that must fail |
|---|---|
| A. Key private head/continuation by session alone | TestPrivateContextsDoNotFollowSelection |
| B. Remove admission/final CAS or silently rebase | TestPrivateExpectedRevisionCAS |
| C. Append revision before its object name exists | TestPrivatePublishBeforeCommit |
| D. Treat mutable Markdown/cache as authoritative | TestPrivateIntegrityBlocksAndReports / TestPrivateRebuildIsInert |
| E. Omit target/expected/content from digest or ignore mismatch | TestPrivateReceiptReplayAndMismatch |
| F. Accept zero/foreign/old control or disclose before validation | TestPrivateOpaqueHandlesAndPublicPrivacy |
| G. Turn unmatched start into applied or resume its write | TestPrivateInterruptedRecovery |
| H. Advance cursor over an unseen workspace commit | TestPrivateScratchRefreshAcrossOtherCommits |
| I. Hold global lock across A's blocked filesystem work | TestPrivateIndependentScopesProgress |
| J. Deduplicate transcript by hash / split or skip paging chunk | TestPrivateTranscriptRepeatedChunkAndPaging |
| K. Drop service actor/shape/predecessor/end checks | TestF3_10PayloadsAndRecordRules |
| L. Relax duplicate-key/null/bound/conditional decoder rule | TestF3_10PayloadsAndRecordRules / TestF3_10Compatibility |
| M. Return applied before all required materializations/projections | TestPrivateIndependentScopesProgress plus lost-ack/crash rows |

Each mutation must be restored and owned bytes checked before final evidence; a test that survives its claimed break is not proof. No permanent source-text/mocking assertions or alternate API are added to make mutation scripts easy. Sources: SPEC:587; DEC:D116; P12.

### Verification commands and responsibility (P13)

Designer runs none. Coder runs the following serially from the **absolute PM-assigned worktree**, on final unchanged bytes; PM hashes/commits and gathers exact-commit evidence before one advisor review. Toolchain: Go 1.27.2, `GOTOOLCHAIN=local`, empty `GOFLAGS`, `CGO_ENABLED=0`; race alone sets `CGO_ENABLED=1` and pinned Windows clang `C:/Users/darius.jones/AppData/Local/Programs/llvm-mingw-20260922-ucrt-x86_64/bin/x86_64-w64-mingw32-clang.exe` via CC. Native Linux/macOS race use the CI-provisioned native compiler. Sources: DEC:D28,D106,D116,D129,D131,D133; assignment “Building”.

| Evidence | Exact command / obligation |
|---|---|
| Format/vet/static | `gofmt -l internal/core/runtime contract/ledger`; `go vet ./internal/core/runtime ./contract/ledger`; `go tool staticcheck ./internal/core/runtime ./contract/ledger` |
| Producer V1 | `go test -count=1 -timeout=30m -v ./internal/core/runtime` |
| Producer race | `go test -race -count=1 -timeout=30m -v ./internal/core/runtime` with race env above |
| V5 concurrency only | `go test -race -count=20 -timeout=45m -run '^(TestPrivateExpectedRevisionCAS|TestPrivateReceiptReplayAndMismatch|TestPrivateIndependentScopesProgress)$' ./internal/core/runtime` |
| Contract/store compatibility | `go test -count=1 -v ./contract/ledger ./internal/core/ledgerstore`; do not rewrite pre-existing tests/goldens |
| PM fuzz | `go test ./contract/ledger -run '^$' -fuzz '^FuzzDecodeF3_10$' -fuzztime=120s`; any actually changed existing fuzz target likewise, no unchanged-target repeat |
| Golden regeneration | `go test ./contract/ledger -run '^TestGolden' -update`; PM verifies no byte change to committed older/new golden on regeneration, records new committed SHA-256 and LF |
| Import audit | `go list -f '{{join .Imports "\n"}}' ./internal/core/runtime`; same `.TestImports` and `.XTestImports`; `go list -deps -f '{{if not .Standard}}{{.ImportPath}}{{end}}' ./contract/ledger` |
| Modules | Coder `go mod tidy -diff`; PM `go mod verify`, unchanged module files |
| PM intermediate slices | `go run ./tools/check -race=false` on each exact non-Markdown merge commit |
| PM last code slice | `go run ./tools/check` with race; all five build/static-analysis targets as settled by D137; native three-OS CI under D133 required for C3 exit, never inferred from cross-builds |
| Markdown-only close | Relative-link resolution and LF, no full-check repetition (D128) |

No tests/evidence overlap. Report uncached package plain/race elapsed, ten slowest race tests, test/row counts and every >60-s test; **this assignment additionally requires each test ≤60 s under race**. B28's historical workspace baseline is 315 s plain /407 s race on 245a032, not a runtime-package prediction. D127's full-check package timeout/report line remain 30/25 minutes; don't restore the obsolete 15-minute line or change tools/check, skip accepted rows, split packages or export test-only hooks. Sources: DEC:B28 item 8,D127,D129,D131; assignment “Building”.

### Feasibility and smoke evidence, not whole-runtime capacity (P14)

**Assumptions:** private checkpoints follow actual local work, not a polling/model turn; use D22's 12/20 context calibration populations with one/three simultaneous **storage callers**, plus a synchronized 16-write private-publication burst. These are storage-only profiles, not measured C3 agent capacity. Normal illustrative input is memory 8 KiB, handoff 8 KiB, transcript 64 KiB and continuation 1 KiB per checkpoint; worst-case input is the configured 4-MiB operation cap. Values are P14's labelled fixture choices, not owner requirements. Sources: CORE:918; RC:17,489–500; DEC:D22,B3; P11,P14.

**Cost model:** steady successful write uses three admitted records plus two completion records in two bounded ledger flush groups; private bytes are hashed/copied/published once per new object and Markdown replacements add their own bounded writes/flushes. At 16 preparations, retained supplied bytes ≤64 MiB, plus bounded streaming/read buffers and live per-context metadata; no child/model/provider/Git process is added. Disk grows with immutable revisions and permanent history. Receipt/history lookup streams ordered records in bounded memory; without a measured index trigger, old lookup latency grows with history. There is no constant-space/constant-latency/SLA claim. Sources: §5 group shapes; DEC:D36,B3,B21; CORE:849–859; P8,P14.

**PM throwaway smoke on final code:** drive the actual public runtime/store through registration, 12 then 20 contexts, distinct payload readback, concurrent storage writes, receipt replay, clean reopen and explicit interrupted reconciliation. Record profile, submitted/applied/refused/busy counts separately, applied operations/s, latency distribution, ledger/private bytes, elapsed/recovery/old-lookup time and observed heap/process memory; say when CPU/process memory were not measured. Verify exact bytes/receipts, not bare no-panic. Save source/output as evidence, then remove owned throwaway source. No model/provider/whole-runtime capacity claim; integrated grants/turns/child shutdown remain 11–16. Sources: RC:17,489–514; SPEC:385,587; DEC:B3,D116; P14.

## §7 — D116 slices and stop points

### Implementation order (P13)

| Slice | Complete deliverable and stop |
|---|---|
| S1 — record-free private mechanics | Bounded immutable-object hashing/publication, safe context-relative paths, canonical typed-request encoding and materialization helpers with real-filesystem edge tests. No exported unfinished module, record writer, loop or generic entity framework. May follow the advisor's design ruling; routine review and exact-commit check without race. Sources: DEC:D45,D116,D117,D129; RC:15; precedent ticket-05-design-ruling.md:38–43. |
| S2 — F3-10 | All §5 types/codecs/catalogue/rules, complete golden, compatibility and fuzz seeds. Additions only. PM collects contract evidence, drafter supplies the freeze record/register changes, advisor reviews code/evidence/record together, then PM freezes under D125 and lands the recorded slice. **Stop before any producer writes F3-10.** Sources: DEC:D40,D116 items 3,6,D125; CON:34–40; assignment “Settled”. |
| S3a — complete typed private-state path | After frozen S2 and S1: actual module Open/Close, agent/session/context ownership, current authority, private CAS operation admission/completion, receipt replay, private publication/materialization, journalled projections, inert replay and explicit interrupted-operation reconciliation. Include one end-to-end restart/lost-ack proof, not exported scaffolding awaiting the next slice. Routine advisor review after evidence; exact-commit check without race. Sources: T10:29–33; DEC:B7,D116,D129. |
| S3b — fault/isolation proof and final code documentation | Full bounded §6 corruption/interruption/uncertain-append/CAS/dedup/scratch-binding matrix; changed-code fuzzing; final interface documentation. No new behavior or frozen shape by stealth. This is the last code slice: full exact-commit check **with** race, final package/rule-break evidence and advisor review. Sources: DEC:D116 item 6,D129,D131; SPEC:591–597. |
| Close — one documents commit | Drafter copies the brief/ruling, records final acceptance and limits, one short B-NEXT and ticket resolution; C3 Status/board change together if needed, never C3 Done. Existing freeze documents stay with S2 rather than waiting here. Markdown-only close uses link/LF validation, no repeat full check. Sources: DEC:D116 items 3–4,D128; RC:498–514. |

Only S1 and contract drafting are independent; the producer waits for the frozen contract. Any breaking frozen shape, dependency or owner-decision change returns to §0's owner gate. A repeated failure remaining after two attempted fixes stops the coder for PM/advisor diagnosis, not scope reduction, retries or fake fallbacks. No coder runs the full check; no command overlaps another test/evidence run. Sources: DEC:D41,D116,D125; assignment “Building”; staged-build procedure.

## §8 — Numbered design choices

Every recommendation remains proposed until the advisor rules. None reserves a new owner decision unless §0 explicitly names that gate.

| ID | Options considered | Recommendation and source-grounded reason |
|---|---|---|
| P1 — module placement | Extend workspace with unrelated private history; new public contract/database; Core runtime module using existing store | `internal/core/runtime` owns the complete typed private-state/replay seam; workspace retains Git. This is D45's runtime responsibility and B7's existing Core transition mechanism, not a seventh contract or universal entity framework. Sources: DEC:D45,D50,B3,B7; SPEC:393–395. |
| P2 — pre-ticket-11 authority | Caller-stated actor; full ticket-11 grants early; external authentication service; opaque local owner capability | Recommend Open-minted, incarnation-bound owner root and immutable context-access handles, with exact pre-disclosure/pre-commit validation; no caller-supplied Actor grants authority. This meets the local owner storage path without inventing agent grants or C7 transport. Sources do **not** settle a bootstrap policy, so the advisor must rule this staging explicitly; no source reserves it as an owner decision. Sources: T10:31–32; T11:10–12; RC:125; CORE:257–300,930; `workspace/request.go:14–24`; DEC:B7,2262. |
| P3 — identities/directories | Names as authority; per-context sessions; mutable/scanned paths; stable registered IDs/paths | One persisted session/agent, full UUID context names, safe case-insensitively unique basename, colony-unique context registration matching F2 keys. Never regenerate on Open or infer authority from names. Sources: DEC:D21,D37,D38; CORE:447–455; RC:478–485; LD:341–345. |
| P4 — CAS granularity | Last-writer-wins; one global colony revision; per-file revisions only; atomic private-scope revision | One revision for an agent-wide private checkpoint, another for each context. A bounded change set can update memory, handoff, transcript and continuation atomically while unrelated contexts remain independent. Expected revision is checked at both operation admission and completion. Sources: T10:30,32; DEC:D22,B7; CORE:148,918. |
| P5 — object/materialization commit ordering | Mutable files as authority; put private content in public body store; publish immutable private objects before commit, then managed materializations/projections | Hash/flush/publish objects in their owning private tree, commit selected hashes, then materialize and publish projections before acknowledgement. Crash gaps or wrong materializations block/report; neither a cache nor a guessed file becomes authority. Sources: T10:30,32–33; DEC:D38; CORE:918; RC:421. |
| P6 — transcript/continuation representation | Define provider/model/tool schemas early; one pooled session transcript; context-owned exact opaque chunks/continuation objects | Storage binds exact bytes and transcript append order, without claiming provider semantics or creating provider calls. Later actual producers own canonical record/artifact semantics; no router directory is fabricated. Sources: T13–T15:10–12; CORE:479–485,918; RC:443. |
| P7 — operation/receipt semantics | Receipt as effect success; no interrupted preparation fact; immutable admission plus private-write start/end | Record admission before interrupted byte publication; revision/result commit together; unmatched start closes interrupted in explicit recovery, never re-executes. Receipt and result remain separate. Sources: T10:31–32; DEC:D37; RC:450; SPEC:393–395,591–593. |
| P8 — dedup/normalization | Unbounded ID map/new index; content-only hash; nonexistent store lookup; Reader plus Submit | Full typed digest, pre-CAS authorized Reader lookup and tail recheck; a maximum-seen UUID aggregate proves only fresh-key absence, never authority/order. Submit remains global immutable-ID backstop. No ledgerstore change; old lookups stay bounded-memory and measured. Sources: LD:130–154,201–217; `internal/core/ledgerstore/commands.go:128–160`; DEC:D37,B3,B21; RC:450. |
| P9 — replay and recovery phases | Open reruns work; cache becomes authority; inert replay plus explicit typed bookkeeping | Open replays complete committed groups, verifies private state and reports pending interrupted operations without dispatch. Live reconciliation appends only interrupted endings; no model/tool/Git retry, materialization guessing or automatic resubmission. Sources: T10:30–33; DEC:D37,B7; CORE:918; SPEC:591–597. |
| P10 — scratch ownership | Add a workspace lookup; copy paths/new allocator; consume frozen F2 bindings | Read ScratchCreated/Closed through the existing Reader as an authorized runtime projection; no workspace code/interface change. Context UUID registration is colony-unique to match F2 pair keys. Real workspace calls appear only in scratch-effect tests, never Open/lookup. Sources: CORE:454–457; LD:341–365; `internal/core/workspace/scratch.go:51–53`; CON:F2-05/F2-07. |
| P11 — F3-10 form and bounds | Generic JSON state blobs; premature grants/turn/budget families; six typed producer-ready additions with finite per-operation limits | Freeze only actual agent/context ownership, private-write start/revision/end and immutable command receipt records. No future-family placeholders. Caps in §5 are explicit calibration inputs, not measured workload claims. This is a delegated additive freeze, not an owner question; a breaking shape is OG-BREAK. Sources: DEC:B2,D40,D125; CON:34–40; CORE:849–864. |
| P12 — proof strategy | Mocks/source assertions; unrelated Cartesian matrices; bounded real-store/filesystem effects and rule breaks | §6 tests observable identity/authority/revision/publication/crash contracts, deterministic concurrency and new-decoder fuzzing. Actual provider/turn/child proof stays in its tickets. Sources: SPEC:585–587,591–593,603–605,635; T10:35–37; DEC:B28 item 8,D131. |
| P13 — slices/documents | Write producer before freeze; docs every slice; record-free → frozen contract → whole path → fault proof → one close | §7 preserves D116's complete slices and evidence-first single review, with D117/D125/D128/D129/D131 amendments. No new dependency or check change is necessary. Sources: DEC:D116,D117,D125,D128,D129,D131; assignment “Settled”. |
| P14 — feasibility profile | Claim whole-runtime capacity; defer every storage cost; finite storage-only smoke/model | Label 12/20-context, 1/3 storage-caller and 16-write burst fixture assumptions, expose buffering/history-scan/disk costs, and measure actual storage path once on final code. No invented SLA or claim from busy counts. Sources: RC:17,489–514; CORE:918; DEC:D22,B3,D116. |
