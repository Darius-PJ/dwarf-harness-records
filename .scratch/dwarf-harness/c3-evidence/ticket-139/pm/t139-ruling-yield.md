```markdown
# Ticket 139 — complete design ruling

## Verdict

**APPROVE the design as amended below.** These amendments replace conflicting parts of `t139-brief.md`; they are settled decisions, not requests for another design pass.

**Review line:** This fresh review was performed by **GPT-6 Astra, temporary stand-in for the DwarfHarness advisor, Claude Fable 5.1**, under the owner’s temporary-review authorization. The amended Ticket139 design is approved under D152. **Fable remains the main advisor and double-checks the whole ticket after its reset.** This is not implementation approval, a contract freeze, runtime evidence, or D52 promotion approval.

Reviewed inputs include the complete request, assignment, brief, documentation notes and coordination record; the cited governing decisions and specifications; frozen F3-10–F3-13 records; and the relevant codecs, producers, replay, command lookup, cursor handling and golden-consumer code. No repository edits or commands were performed.

### Owner summary

Build an additive, owner-only registration family in Core. Registrations and declarations are versioned evidence, never permission.

The important correction is **not** to equate a registration UUID with its grant address. A registered external resource has:
- an opaque UUID registration identity; and
- one immutable, exact F3-11 external resource address.

Consequently, the existing frozen address `paid-route/<route UUIDv7>` works without aliases, provider functionality, credentials, route configuration or an earlier registration requirement on grants.

Use three CAS mutation methods, three latest-state maps, two producer population limits, one additional private acknowledgement-boundary hook, and exactly three slices. Historical reads use the ledger; Ticket139 introduces no history cache.

Before the S1 freeze review, run the new golden through **actual Core `Open`** to validate its earlier-family prerequisites. Codec and ledger-reader success alone are insufficient.

## 1. Governing interpretation

### External-only registrations are sufficient

Approve **external-only for this new registration family**, not a new restriction on F3-11.

Reasons:
- F3-11’s resource union also names contexts, tasks, workspace regions and artifacts. Those already have their own identities, producers and authority semantics.
- Undercurrent §8.3 and its non-code implementation row distinguish opaque host-registered external resources from artifact/document nodes.
- B32 and D142 assign this missing registration/declaration evidence to Core; they do not require re-registering every existing F3-11 resource variant.
- Ticket139 supplies resource/work-domain evidence. It does not turn contexts or agents into resource nodes, replace artifact identity, or manufacture a second authority registry.

Therefore:
- Existing `context`, `task`, `workspace` and `artifact` grants remain valid and unchanged.
- Existing external grants remain valid whether or not any Ticket139 registration exists.
- No grant containment, operation vocabulary, authority version or authorization decision changes.
- A work domain does not become a new F3-11 resource kind.

### Bare-UUID-only keys are rejected

F3-13 freezes the external grant address `paid-route/<route UUIDv7>` at `contract/ledger/doc.go:2485`; the actual paid golden and producer use it. Replacing that address with a bare registration UUID would disconnect registration evidence from the grant’s actual resource.

The approved representation is:

- `ResourceID`: stable UUIDv7 registration identity.
- `Resource`: the existing `ledger.Resource`, restricted here to `Kind == "external"`.
- `Resource.ResourceKey`: the exact opaque, nonsecret F3-11 key, subject to its existing 1–256-byte UTF-8/no-control rules.

The resource field is now **non-redundant**. It must be supplied, hashed and persisted; it is not derived from `ResourceID`.

Additional invariants:
1. A resource registration’s grant address is immutable.
2. An external address belongs to at most one resource registration in the colony.
3. Compare addresses exactly. No trimming, case folding, Unicode normalization, prefix interpretation, URL parsing, secret hashing, aliases or implicit fallback.
4. A bare UUID key remains valid when explicitly supplied. It need not equal `ResourceID`.
5. `paid-route/<UUID>` is ordinary opaque identity metadata here. Do not look up the route or require credentials, configuration, spend terms or provider availability.
6. Other existing opaque external keys are supported; this is not a special whitelist containing only UUIDs and paid routes.

**Nonsecret boundary:** the trusted owner/host supplies an opaque identity, never a URL, account identifier or credential. There are no locator, provider-configuration or credential inputs and no resolver. The frozen byte grammar cannot prove that arbitrary host-supplied text is nonsecret; do not claim a secret detector or invent an unreliable one. The API documentation must state this semantic precondition explicitly, as with F3-11’s opaque external keys.

This one-to-one identity/address binding is not a generic alias subsystem.

## 2. Decisions P1–P12

| Choice | Ruling | Binding decision |
|---|---|---|
| **P1 — additive family** | Approve with amendment | Add F3-139, four version-1 record types and schema 5. `Defined()` gains four entries, 49→53. Use the three operations and canonical form below. F3-10–F3-13 and schemas 1–4 remain unchanged. |
| **P2 — resource identity** | Replace | External-only is sufficient, but bare-UUID-only is not. Persist the explicit immutable F3-11 external address described above. Enforce address uniqueness within resource registrations. |
| **P3 — audience** | Approve, clarify | Every registration/declaration has a nonempty sorted distinct audience of registered agent IDs. It is evidence scope, not access authority. Declaration audience must be contained in its pinned source audience and every named task’s audience; each named context’s agent must belong to the declaration audience. No role membership, future-agent inference or automatic expansion. |
| **P4 — versions and replacement** | Approve with amendment | Expected zero creates version 1; a successful revision advances exactly one. Declarations pin the source version current when committed and replace their complete consumer set. Empty consumers withdraw the declaration’s edges. Remove family-wide cross-kind UUID exclusion: identities are namespaced by kind. |
| **P5 — consumers and lifecycle** | Approve | Task consumers bind stable task ID, not assignment/generation; context consumers bind the exact registered binding. No reassignment-following context alias. Unassigned and terminal tasks may be evidence consumers. No deletion, retirement or lifecycle API is needed here. |
| **P6 — owner API** | Simplify | Use three owner-only CAS setters, not separate register/revise wrappers. No `Agent` equivalents. Bind actor and current registered origin internally; caller-supplied `Binding` is not authentication. Queries are owner-only typed metadata reads. |
| **P7 — commit and retry** | Approve | One `Submit`, exactly command/effect/receipt. Global command lookup precedes CAS, source-currentness and producer population checks. Match family, actor, origin, operation and canonical digest. Read actual committed sequences, install through the committed prefix before acknowledgement, preserve Close and poisoning behavior. |
| **P8 — replay integration** | Approve | Add the concrete fifth `decodeFamily` result and migrate every caller. Add three latest-state maps and one family arm to existing replay/command lookup. Use the same group validator and transition planner for preflight and replay. No generic registry, independent authority store, receipt index or history cache. |
| **P9 — limits** | Simplify | Keep the frozen 64 KiB payload/submission rules. Add only `MaxRegistrations = 256` and `MaxDeclarations = 1024` as configurable producer defaults. Remove `MaxRegistrationAudience` and `MaxDeclarationConsumers`; the encoded cap already bounds these arrays. Population limits do not constrain replay. |
| **P10 — queries** | Approve with amendment | Preserve typed current, historical, exact-source-version and command-receipt queries. Make `ResourceStatus` addressable by the exact `ledger.Resource` grant address. Historical selection scans validated complete commits at the requested cursor; no second reducer or cache. |
| **P11 — slices** | Replace with exact plan below | Exactly three slices: contract and freeze prerequisites; complete producer/query/replay; real interrupted recovery and cross-family acceptance. S2 already contains the live retry/Close and real new-golden replay regressions. |
| **P12 — evidence** | Approve with amendment | Apply D152 focused evidence and risk-based breaks, D125 completed-contract freeze, and D153 exact-final-SHA hosted integration separately. Add the S1 real-Core prerequisite probe. No routine design confirmation pass and no duplicate local full gate. |

### Audience consequences

A later registration revision does not rewrite or silently retarget an existing declaration. Its pinned source version and declared audience remain historical facts.

If the owner wants current declared edges narrowed or withdrawn, he revises those declarations explicitly. Narrowing a registration alone is not revocation of a grant or automatic withdrawal of earlier declarations. Future graph projection still requires its own authorization filtering; audience membership is not permission to disclose metadata or content.

## 3. Exact API and frozen surface

### Owner mutation API

Retain the brief’s request types, amended as follows:

- `ResourceRegistration`: `CommandID`, `ResourceID`, `ExpectedVersion`, **`Resource ledger.Resource`**, `Audience`.
- `WorkDomainRegistration`: `CommandID`, `WorkDomainID`, `ExpectedVersion`, `Audience`.
- `DeclarationChange`: `CommandID`, `DeclarationID`, `ExpectedVersion`, `Subject ledger.RegistrationRef`, `Audience`, `Consumers`.

The only mutation methods are:

- `Service.SetResourceRegistration(ctx, origin Binding, request ResourceRegistration)`
- `Service.SetWorkDomainRegistration(ctx, origin Binding, request WorkDomainRegistration)`
- `Service.SetDeclaration(ctx, origin Binding, request DeclarationChange)`

Each returns `(RegistrationReceipt, error)`.

Expected zero means create; positive expected means revise the existing identity. There are no `RegisterResource`, `ReviseResource`, `RegisterWorkDomain` or `ReviseWorkDomain` compatibility wrappers: none exists yet, so perform a clean design cutover.

Preserve the existing service convention of copying request arrays before normalization. Sort without deduplicating; duplicates are invalid. Normalize nil consumers to an explicit empty array. Bound array allocation before copying/sorting using the existing payload-derived element-count guard, then check the actual encoded submission, effect and receipt sizes.

### Record catalogue

All four types are version 1, owner-envelope records, produced only by Core’s typed registration path through `ledgerstore.Submit`.

| Type | Known payload fields, in canonical order |
|---|---|
| `runtime.resource_registered` | `resource_id, expected_version, version, resource, audience` |
| `runtime.work_domain_registered` | `work_domain_id, expected_version, version, audience` |
| `runtime.declaration_changed` | `declaration_id, expected_version, version, subject, audience, consumers` |
| `runtime.registration_receipt` | `command_id, submission_sha256, submission, outcome, version` |

The receipt’s `version` is the resulting target version.

Shared shapes:
- `RegistrationRef`: `kind, id, version`; kind is `resource` or `work_domain`; version is positive.
- Task consumer: `kind: "task", task_id`.
- Context consumer: `kind: "context", binding: {agent_id, context_id}`.
- Audiences are sorted distinct UUIDv7 agent IDs and nonempty.
- Consumers are sorted/distinct by their compact known-field JSON bytes and may be empty.
- UUIDs are canonical lowercase UUIDv7.
- Versions use the existing plain-integer range through `MaxInt64`; reject overflow before addition.
- Expected zero/result one and expected positive/result expected+1 are the only transitions.
- Receipt outcome remains an open token with the brief’s token grammar; v1 produces `applied`. A decoder preserves an unfamiliar token, but Core does not apply it.

Retain the brief’s complete UTF-8 JSON-object rules, required/non-null fields, recursive duplicate-member rejection, unknown optional-member handling, conditional known-field exclusions, lower-case nonzero digests, and size checks on received bytes as well as encoded payloads.

Consumers are Core replay and owner metadata queries, followed by Ticket61’s independently authorized graph reader. All identity, version, audience, source, consumer, canonical-submission and receipt-binding fields are replay-essential. No labels, arbitrary descriptions, bodies, private content, provider settings, credentials, access locators or measurements are added.

### Schema 5

Use precisely three operations:

| Operation | Concrete arguments in canonical order |
|---|---|
| `resource.set` | `resource_id, expected_version, resource, audience` |
| `work_domain.set` | `work_domain_id, expected_version, audience` |
| `declaration.set` | `declaration_id, expected_version, subject, audience, consumers` |

Canonical root order:

`schema, actor, origin, operation, arguments`

- `schema = 5`; `actor = "owner"`.
- Origin uses the existing agent/session/context shape and must match the registered sole session and context.
- **Remove `RegistrationTarget`.** Kind and target identity are already unambiguously bound by the operation and its concrete arguments. Schema 4 already demonstrates this convention.
- Arguments are approved concrete types, not arbitrary JSON.
- Hash SHA-256 over the compact known-field producer encoding using the existing `encoding/json` convention.
- Command ID, timestamps and committed sequences remain outside that preimage.
- The external resource address is inside the resource operation’s preimage.
- No omitted-resource fallback or derivation is permitted.

### Group and state rules

Each new transition is exactly:

`F0 command → one matching F3-139 effect → F3-139 receipt`

All three envelopes have the same owner actor, registered origin and command operation ID. No turn, measurement path or body references. No mixed-family group.

The effect must be exactly reconstructible from the canonical submission and pre-transition state. Validate:
- owner/origin;
- target version and identity;
- immutable resource address and unique address ownership;
- registered audiences;
- current source reference at declaration commit;
- exact consumer existence and scope constraints;
- result version and receipt binding.

Preflight also compares against the **original normalized request**, not merely a mutated group whose attacker-controlled fields and digest are internally consistent.

Use `(kind, UUID)` identity namespaces. The same UUID may identify a resource, work domain and declaration without conflating them. Command IDs remain globally unique across every family.

### Errors and queries

Keep the brief’s existing error vocabulary:
- malformed shape, immutable-address change, address collision or invalid scope relationship: `ErrInvalid`;
- version disagreement: `RevisionError`;
- absent registration/domain/task/declaration: `ErrUnavailable`;
- unregistered agent/context/origin: `ErrNotBound`;
- wrong permitted caller or mismatched command principal/origin: `ErrDenied`;
- wrong command family, operation or digest: `ErrCommandMismatch`;
- encoded-size overflow: `ErrTooLarge`;
- new population exceeding its configured limit: `BusyError`.

Invalid committed group/state is replay inconsistency, not a successful absence result. Preserve existing `ErrClosed`, poisoning and cancellation semantics. Do not change historical APIs’ established error mapping merely to resemble the new API.

Retain the brief’s receipt and view types, including actual effect/receipt sequences and the queried through-sequence. Amend resource lookup to:

`ResourceRegistrationLookup { Resource ledger.Resource; ThroughSequence uint64 }`

`Service.ResourceStatus` takes that lookup and returns the resource registration view, including its UUID. `WorkDomainStatus` and `DeclarationStatus` retain UUID lookup. `RegistrationVersion` resolves the exact pinned resource/domain reference. `RegistrationCommandStatus` resolves the original receipt.

All are owner-only and return isolated typed values. No listing/search/raw-ledger endpoint is needed.

Cursor semantics:
- zero is genesis;
- `ledger.ToEnd` resolves once to the captured current durable boundary;
- a numeric cursor must be a complete commit boundary at or before that boundary;
- reject future and mid-commit cursors as cursor errors;
- select only snapshots at or before the cursor;
- exact-version lookup cannot borrow a version created later.

The current reader treats some future-through cases as corruption, so precheck future cursors in this API rather than changing the frozen reader.

Current maps are projections of an already validated prefix. Historical selection scans complete commits within that prefix; it does not replay against today’s state or introduce a parallel state machine.

## 4. Commit, replay and memory requirements

Use the existing `enter`/active-operation/Close fence and lock discipline.

1. Normalize and encode the typed request.
2. Check owner entry and current registered origin.
3. Resolve a prior global command, including the existing unlocked-prefix lookup/relock/tail-refresh discipline.
4. Return a matching original receipt before checking today’s CAS, source version or population limits.
5. For a new command, validate current state and population limits under the lock.
6. Preflight the exact outgoing group against both the original request and replay planner.
7. Submit one group.
8. Complete refresh and actual receipt readback through the returned committed boundary before acknowledgement, using post-commit completion semantics that cancellation cannot undo.
9. Poison on uncertain write or failure to establish the committed result; do not return a predicted success receipt.
10. A lost acknowledgement does not roll back a completed group. Retry returns the original receipt.

No claim of exactly-once delivery or a durable acknowledgement marker is authorized.

Add only:
- latest resource-registration map;
- latest work-domain-registration map;
- latest declaration map;
- `commandMatch.registration`;
- the fifth decoder result and existing refresh/lookup arms;
- one private `afterRegistrationCommit func(RegistrationReceipt) error` hook, after installation and unlock but before returning, while the active operation still protects Close.

Reuse `beforeSubmit`, `afterScopedSubmit`, `beforeLookup` and the Close fence. No hook framework or new public option.

Check address uniqueness by the bounded latest resource state; no separate reverse index is required. Historical versions and receipts stay in the ledger, not additional maps.

`MaxRegistrations` counts resources plus work domains; `MaxDeclarations` counts declaration identities, including withdrawn declarations. Revisions do not consume another identity slot. Lowered limits never prevent replay or a matching retry. These are defaults and admission settings, not frozen historical validity.

Removing the two fan-out knobs means the brief’s small-memory estimate must not survive unchanged. At default population limits, the sum of per-record 64 KiB ceilings is 80 MiB of encoded latest snapshots, not a measured Go heap bound. Make no capacity claim; there is no new benchmark requirement.

## 5. Golden and mandatory pre-freeze probe

### Exact golden amendment

Keep the brief’s deterministic UUID namespace, real object/body fixtures, two registered agents, general contexts, work context, unassigned task, four declarations, 14 registration/declaration groups, audience revisions, mixed consumers and withdrawals.

Change resource R’s persisted address to:

`{kind: "external", resource_key: "paid-route/" + id(0x450)}`

R retains registration identity `id(0x400)`. No route configuration or paid-provider record is added.

After the original four prerequisite commits, add **one real F3-11 owner root-grant group**:
- grant ID `id(0x600)`;
- registered origin A/general;
- grantee and sole recipient A/general;
- operation `model.call`;
- exact external address above;
- external data class;
- zero nonnegative capacity fields, delegation depth zero;
- lifetime `until_revoked`;
- no parent or task binding;
- authority version 0→1.

This is permission metadata only; nothing invokes it. Its placement before registration proves that this family is not a prerequisite for an existing grant.

Result:
- **5 prerequisite commits / 23 records**;
- **14 F3-139 commits / 42 records**;
- **19 commits / 65 records total**;
- first F3-139 effect/receipt: **25/26**;
- final effect/receipt: **64/65**.

The 14 new-family effects remain:
1. R v1, audience A/B.
2. D v1, audience A/B.
3. Resource→task declaration.
4. Resource→context declaration.
5. Domain→task declaration.
6. Domain→context declaration.
7. R v2, narrowed to A.
8. D v2, narrowed to B.
9. Resource declaration replaced with mixed context/task consumers, pinned to R v2.
10. Resource-context declaration withdrawn.
11. Domain-task declaration withdrawn.
12. Domain-context declaration revised and pinned to D v2.
13. R v3, widened to A/B.
14. Resource-task declaration revised and pinned to R v3.

Use the new `*.set` operations and schema-5 form throughout. Generate positional IDs, times and hashes from the amended sequence. Do not hand-edit generated JSONL or invent the new digest.

Codec/service vectors additionally cover an explicitly supplied bare-UUID external key and an ordinary opaque non-UUID external key. They need not pad the golden with duplicate shapes.

### S1 actual Core probe — before joint freeze review

Generate the whole fixture with `TestGoldenF3_139 -update`. Then run a throwaway test/probe using:
- real fixture objects and task body;
- real `ledgerstore.Open`;
- actual Core `agents.Open`;
- the existing frozen-golden loading conventions.

The pre-producer Core may leave F3-139 unconsumed. That is acceptable for this probe. It must still validate the earlier-family setup.

Record:
- successful Open;
- zero reconciliation issues;
- durable sequence **65 before and after**;
- unchanged ledger bytes;
- successful earlier-family task/grant reconstruction.

Do not require `Reconciliation.Completed` to be empty: legitimate earlier-family materialization repair is not a ledger append.

Include one throwaway negative control on a separate rebuilt log: make the earlier owner task-create group refer to a missing task dependency, with its submission, digest and chain rebuilt consistently. Actual Core Open must reject that invalid prerequisite. Do not alter the retained golden or bypass the old reducer.

Temporary helper support for chapter 139 is allowed for this probe and removed/restored before the slice is finalized. Retain probe source, invocation and output privately. It is not a permanent plumbing test and is not a claim that the new family has been replay-validated.

This expressly overrides the brief’s blanket statement that S1 runs no agents-side probe. D149 demonstrates why deferring this check until the producer is too late.

Once S2 implements the family, permanent behavioral golden replay must validate the new groups, every complete prefix and historical lookups, including replay under lower producer limits.

### Freeze bundle

S1’s joint review receives:
- finished contract code and documentation;
- generated golden and every object/body fixture;
- observed hashes and LF/CR evidence;
- old frozen goldens unchanged, including D149’s corrected F3-13;
- focused codec/consumer evidence and the applicable fuzz campaign;
- the actual Core prerequisite-probe evidence;
- a fully populated proposed freeze record.

No guessed hash, numbering placeholder, producer scaffold or presumed owner approval.

## 6. Exact three-slice plan

### S1 — Additive contract and completed freeze bundle

**Owned code**
- `contract/ledger/registration.go`
- `contract/ledger/registration_submission.go`
- `contract/ledger/registration_test.go`
- `contract/ledger/registration_fuzz_test.go`
- `contract/ledger/registration_golden_test.go`
- additive entries in `contract/ledger/catalogue.go`
- F3-139 section in `contract/ledger/doc.go`
- generated `contract/ledger/testdata/f3/139/**`

**Deliverable**
Four codecs, schema-5 encoding, catalogue, complete 19/65 golden, compatibility evidence and actual Core prerequisite probe. No durable producer implementation or producer scaffold.

The PM owns shared record application: `CONTRACTS.md`, Core §13.1, numbered freeze comments and private freeze/evidence records. The primary allocates actual D/B numbers.

**Exit**
Joint completed-contract review, then PM freeze under D125. The frozen contract must land before S2 producer work/emission. Final public SHA passes D153 before main moves.

### S2 — Complete owner producer, queries and replay

**New owned files under `internal/core/agents/`**
- `registration_types.go`
- `registration_commands.go`
- `registration_replay.go`
- `registration_state.go`
- `registration_query.go`
- `registration_service_test.go`
- `registration_replay_test.go`

**Shared changes**
Only the hooks and mechanical migrations listed in §7, plus the registration package-documentation subsection and permanent chapter-139 support in `scoped_golden_test.go`.

**Deliverable**
All three mutation methods and all ruled queries; CAS, immutable grant-address binding, scopes, pinned declarations, atomic publication, global deduplication, replay and cursor behavior.

This slice already includes:
- live concurrent CAS and same-command retry;
- original-request preflight rejection;
- lost-acknowledgement and Close-fence behavior;
- real new-golden replay and historical-prefix behavior;
- existing grant independence and no-provider registration of the frozen paid-route address.

Do not defer basic correctness of a newly introduced publication protocol to S3.

### S3 — Interrupted recovery and cross-family acceptance

**Owned files**
- `internal/core/agents/registration_crash_test.go`
- `internal/core/agents/registration_recovery_test.go`
- narrowly necessary extensions to the S2 registration tests and registration documentation.

**Deliverable**
Real subprocess/store recovery at:
1. before commit;
2. torn final group;
3. durable complete group before installation;
4. installed group before acknowledgement.

Positively wait for children. Verify complete committed state only, unchanged ledger on service replay, actual original receipt recovery and no duplicate effect on retry. Label process-death evidence honestly; do not claim power-loss qualification.

Exercise cross-family history using real existing fixtures:
- terminal/reassigned task identity, including F3-12 review-derived task state;
- registration beside existing F3-13 opaque route addresses without provider work;
- globally reused command IDs across families;
- unrelated family activity preserving registration state and historical answers.

Reuse existing old-family replay regressions; do not duplicate them under a new compatibility-test name.

After actual Service smoke evidence, finish the ticket/package/public documentation and private close record. Ticket61 graph production, Ticket15 actual-use facts, UI, provider work and workload promotion remain intentionally unchanged.

## 7. Minimum shared-file hooks and Ticket140 coordination

### Structural hooks

| File | Allowed change |
|---|---|
| `internal/core/agents/service.go` | Three maps and initialization, family consumption, one post-install hook. |
| `internal/core/agents/types.go` | Two population limits, defaults and validation. |
| `internal/core/agents/scoped_replay.go` | Fifth concrete family result and mixed-family rejection. |
| `internal/core/agents/replay.go` | Registration refresh/install arm and `commandMatch`/global lookup result. |
| `internal/core/agents/doc.go` | Owner/evidence/nonsecret/query/recovery documentation. |
| `internal/core/agents/scoped_golden_test.go` | Chapter-139 fixture identity support for permanent S2 behavioral replay. |

### Mechanical decoder callers

Migrate every existing caller in:
- `integrity.go`
- `paid_fixture_test.go`
- `paid_fuzz_test.go`
- `paid_live.go`
- `paid_read.go`
- `paid_settlement.go`
- `paid_state.go`
- `replay.go`
- `review_execute.go`
- `review_fuzz_test.go`
- `review_replay_test.go`
- `review_state.go`
- `scoped_submit.go`

Where a caller proves that a group belongs to one family, include the new registration result in its foreign-family rejection. Where it merely selects one family, add the ignored result without changing semantics.

In particular, preserve the original-request checks in scoped, review and paid preflight. Do not accidentally broaden them while changing tuple arity.

### Explicit non-changes

Do not change:
- `scoped_state.go` resource authorization or its external-resource behavior;
- scoped/review planners or task lifecycle;
- provider, credentials, money, store/appender or reader contracts;
- `tools/check`, dependency files or build constraints;
- old-family errors or goldens.

Use existing `loadTask`, including review-derived terminal state. A missing live-map entry is not historical absence.

### Ticket140

Primary retains ownership of its common history index and direct review-publication changes.

Ticket139:
- creates no cache, cache options, epoch or invalidation framework;
- does not edit `history_index.go`, materialization/read sources or scoped/review planning to optimize registration history;
- remains buildable without Ticket140.

At integration, the primary preserves whole-commit command-key invalidation before cache coverage advances. If its cached positive `commandMatch` representation cannot retain the fifth family, **leave registration positives uncached** and use authoritative lookup; do not represent them as negative or as another family. Existing same-command collision detection must still examine all F0 commands.

Coordinate collisions in `service.go`, `replay.go`, `integrity.go`, `review_execute.go` and `review_state.go` at the slice boundary. A rebase creates a new final SHA for D153.

The primary owns main, shared records, numbering and local compute. No Ticket139 execution slot is assumed. The reported Ticket140 hosted winexec failure is accepted as reported; this ruling authorizes no reproduction, suppression or unrelated fix.

## 8. Acceptance coverage and evidence

| Ticket criterion | Required observable proof |
|---|---|
| Owner-only typed transitions, current authority/CAS, receipt before acknowledgement | Agent/forged-origin rejection; concurrent CAS has one winner; immutable address; preflight bound to original request; committed projection and actual receipt before return; Close fence. |
| Opaque resource named by F3-11 kind/key | Exact persisted/queryable external address, including `paid-route/<UUID>`; key cannot be retargeted or registered twice; pre-existing grants remain unchanged; no provider/credential prerequisites or effects. |
| Scoped, versioned registrations/declarations at every cursor | All four source/consumer combinations; source pins; audience containment; replacement/withdrawal; old/current/source-version queries; complete-boundary cursor enforcement; no permission or charge changes. |
| Fully specified additive frozen family before production | Four catalogue entries, canonical schema, privacy/replay fields, generated golden, actual Core prerequisite probe, unchanged earlier frozen records and completed D125 bundle. |
| Ledger-only restart, committed state and original retry receipt | Full/prefix replay, low-limit replay, real interrupted/torn recovery, durable readback, same-command retry without another effect, no service replay append. |
| Ticket61 can consume real nodes/declared links | Golden and Service queries expose stable resource/domain identities, exact grant address, scoped source versions and all declaration shapes without stand-ins. No graph implementation is implied. |

### Permanent tests

Keep tests only for plausible observable failures:
- codec/canonicalization boundaries, wrong-kind fields, malformed/duplicate/null input, overflow and full receipt-size boundaries;
- identity/address immutability and collision;
- authority, CAS, scoped declarations and historical selection;
- original-request binding and cross-family command mismatch;
- retry/acknowledgement/Close and real crash recovery.

A golden’s exact bytes are a frozen contract, not incidental wiring. A separate “compatibility” test that only repeats catalogue counts or existing golden checks is unnecessary; use existing tests and hash evidence.

### Rule-break evidence

Use targeted red → identical restoration → green only for relevant D152 risks:
1. permit a non-owner/forged origin;
2. remove the original-request binding check while keeping a self-consistent mutated digest;
3. make registration/audience grant authority or become a prerequisite for an existing external grant;
4. acknowledge without committed installation/readback, or bypass duplicate resolution;
5. admit an incomplete group or append registration effects during replay.

Each selected mutation must actually reach the observable bug its regression claims to catch. A dormant mutation masked by an independent guard is not evidence. No new artificial “break” is required for naming, method consolidation, defaults or other nonblocking details.

### Fuzzing

- S1: new `FuzzDecodeF3_139`, including canonical submission handling.
- S2: new `FuzzRegistrationGroupReplay`.
- Because shared family dispatch changes: PM campaigns for `FuzzScopedGroupReplay`, `FuzzReviewGroupReplay` and `FuzzPaidGroupReplay`.
- `FuzzPrivateGroupReplay` runs its normal seeds; its private decoder/planner path is unchanged. A change to that actual fuzzed path would add its campaign.
- Coders run seeds; the PM runs each applicable campaign for **120 seconds** in an explicitly allocated local slot.
- Reuse a prepared real fixture for preflight; create/reopen real stores for accepted candidates rather than for every rejected byte string.

### D125, D152 and D153 are separate

**D125 — freeze authority**
The PM freezes the completed additive contract after joint review of implementation, specification, golden, evidence and proposed record. This design approval does not freeze it. No owner gate is triggered merely by adding this family.

**D152 — review and local evidence**
Focused reproductions and plain verbose changed-package evidence. Local race plus affected `×20` tests when shared state/locking/concurrency changes: S2 qualifies. A tests-only S3 is not an excuse for another indiscriminate full race suite. Host formatting/vet/staticcheck; five-target static work only if build constraints change. No duplicate local `tools/check` gate and no speculative measurement campaign.

Use go1.27.3, `GOTOOLCHAIN=local`, empty `GOFLAGS`, normal cgo-free production checks and the approved race-toolchain exception. Keep the existing 19m/29m/45m runner timeouts; do not alter tests’ deadlines to make evidence pass.

**D153 — integration**
Each final public branch SHA must have successful hosted classification, every required Windows/Linux/macOS job, including race where required, and aggregate **Check result success** before primary moves main. A rebase, fix or Go freeze-comment edit needs evidence for its new SHA. Markdown-only classification follows the established lighter route. An earlier SHA’s success is not the final SHA’s success.

D42’s check command remains unchanged.

### Owner gates

None is triggered by this approved design.

Stop for the owner if implementation would require:
- a breaking frozen-contract change — D40;
- a new dependency — D29;
- a change reserved to the owner — D41;
- promotion/admission beyond the already approved testing-only C3 boundary — D52;
- live credentials, provider invocation or spending.

Supporting an opaque paid-route address triggers none of those by itself.

Private decisions/evidence remain team-readable in main under D145 and are never included in the public repository. Primary assigns record numbers; approved technical decisions use originator `assistant`.

## 9. Findings and critical notes for S1

### Findings settled by this ruling

1. **Major — `local://t139-brief.md:37`, resource identity/API/canonical sections.** Bare-UUID equality cannot represent the actual frozen paid-route grant address. Resolved by the explicit immutable F3-11 external address, exact-key lookup, amended canonical arguments and golden.
2. **Major — `local://t139-brief.md:446`, S1 evidence sequencing.** Deferring all actual Core probing permits invalid earlier-family prerequisites to be frozen, as D149 already demonstrated. Resolved by the mandatory pre-freeze actual-Core probe and its retained evidence.
3. **Minor — API/identity/limits design.** Duplicate create/revise methods, redundant target representation, cross-kind ID exclusion and four new knobs are unnecessary. Resolved by three setters/operations, arguments-bound targets, kind-scoped IDs and two population limits. These are not separate confirmation gates.

### NotesForS1

- Implement this ruling, not conflicting examples from the brief.
- `Resource` is explicit and immutable; never derive its key from the registration UUID.
- Preserve the full existing opaque external-key contract, including paid-route addresses, without invoking their producers.
- Three operations; no `RegistrationTarget`; two producer population limits.
- Golden is **19 commits / 65 records**, with the earlier root grant and paid-route-shaped address.
- The actual Core prerequisite probe occurs **before** the joint freeze review.
- Obtain all new fixture hashes from the generator; preserve old frozen bytes and D149’s corrected F3-13.
- Catalogue and comments must distinguish specification, later producer implementation and actual freeze status honestly.
- No new dependency, provider path, graph work, cache or main/shared-record ownership is transferred.
- No technical source question remains open. Compute scheduling, final hashes, CI runs and the completed S1 freeze review are future execution gates, not missing design evidence.

**Requests: none. The amended design is settled; no routine confirmation pass is requested.**
```

```json
{
  "verdict": "approve",
  "reviewLine": "GPT-6 Astra, temporary stand-in for the DwarfHarness advisor Claude Fable 5.1, performed this fresh review and approves Ticket139's complete design as amended in this ruling under D152. Fable remains the main advisor and double-checks the whole ticket after its reset. This is not implementation approval, a contract freeze, runtime evidence or D52 promotion approval.",
  "choices": {
    "P1": {
      "ruling": "approve-with-amendment",
      "decision": "Add four F3-139 v1 types and schema 5; Defined grows from 49 to 53. Use resource.set, work_domain.set and declaration.set. Leave F3-10 through F3-13 and schemas 1 through 4 unchanged."
    },
    "P2": {
      "ruling": "replace",
      "decision": "External-only registrations are sufficient. ResourceID is an opaque UUIDv7, separate from an explicitly supplied immutable ledger.Resource external address. Preserve existing opaque external-key grammar, including paid-route/<UUID>. Enforce unique address ownership; no normalization, aliases, route lookup, provider functionality or historic registration prerequisite."
    },
    "P3": {
      "ruling": "approve-with-clarification",
      "decision": "Nonempty registered-agent audiences are evidence scope, never authority. Declaration audience is contained in its pinned source and each task audience; each context consumer's agent belongs to the declaration audience. No implicit expansion or disclosure permission."
    },
    "P4": {
      "ruling": "approve-with-amendment",
      "decision": "Expected-zero creation and contiguous CAS revisions; declarations pin the source version current at commit and replace their full consumer set. Empty consumers withdraw edges. IDs are namespaced by kind, not globally exclusive across new kinds."
    },
    "P5": {
      "ruling": "approve",
      "decision": "Task consumers use stable task IDs; context consumers use exact registered bindings. Unassigned and terminal tasks are legitimate evidence consumers. No assignment-following aliases, retirement or deletion API."
    },
    "P6": {
      "ruling": "simplify",
      "decision": "Owner-only SetResourceRegistration, SetWorkDomainRegistration and SetDeclaration. No separate register/revise wrappers or Agent methods. Canonical targets are bound once in concrete arguments; remove RegistrationTarget."
    },
    "P7": {
      "ruling": "approve",
      "decision": "One command/effect/receipt Submit; global deduplication before CAS and population guards; original-request preflight binding; actual committed sequence readback and projection installation before acknowledgement; preserve Close, cancellation and poisoning semantics."
    },
    "P8": {
      "ruling": "approve",
      "decision": "Concrete fifth decodeFamily result, three latest-state maps, commandMatch.registration and existing refresh/lookup integration. Shared preflight/replay planner. No independent authority store, history cache, receipt index or generic router."
    },
    "P9": {
      "ruling": "simplify",
      "decision": "Frozen 64 KiB payload/submission rules plus only MaxRegistrations=256 and MaxDeclarations=1024 producer defaults. Remove audience/consumer count knobs; preserve bounded allocation and actual encoded-size checks. Replay and matching retries ignore producer population limits."
    },
    "P10": {
      "ruling": "approve-with-amendment",
      "decision": "Owner-only typed current/history/version/receipt queries. ResourceStatus uses exact ledger.Resource plus ThroughSequence. Zero is genesis, ToEnd captures the durable boundary, and future or mid-commit cursors fail. Historical snapshots come from complete validated commits, without a second reducer or cache."
    },
    "P11": {
      "ruling": "replace",
      "decision": "Exactly three slices: contract and freeze prerequisites; complete producer/query/replay with live publication regressions; real interrupted recovery and cross-family acceptance."
    },
    "P12": {
      "ruling": "approve-with-amendment",
      "decision": "Separate D125 freeze, D152 focused evidence/review and D153 final-SHA hosted integration. Require actual Core prerequisite-golden probing before freeze. No duplicate local full gate or routine design confirmation pass."
    }
  },
  "findings": [
    {
      "id": "F1",
      "severity": "major",
      "location": "local://t139-brief.md:37",
      "problem": "Bare registration UUID keys exclude the frozen paid-route/<route UUIDv7> grant address.",
      "requiredChange": "Persist and canonically bind an explicit immutable F3-11 external Resource, enforce address uniqueness, query by exact address and amend the golden.",
      "status": "resolved-by-binding-ruling"
    },
    {
      "id": "F2",
      "severity": "major",
      "location": "local://t139-brief.md:446",
      "problem": "S1's blanket exclusion of actual Core probing can freeze invalid earlier-family prerequisites.",
      "requiredChange": "Before joint freeze review, run a throwaway real ledgerstore/Core Open probe of the generated golden and a rebuilt invalid-prerequisite control; retain source and outputs privately.",
      "status": "resolved-by-binding-ruling"
    },
    {
      "id": "F3",
      "severity": "minor",
      "location": "local://t139-brief.md, P4/P6/P9 and API sections",
      "problem": "Create/revise wrappers, redundant target representation, cross-kind UUID exclusion and four additional limits add unnecessary surface.",
      "requiredChange": "Use three CAS setters and operations, argument-bound targets, kind-scoped IDs and two producer population limits.",
      "status": "resolved-by-binding-ruling"
    }
  ],
  "ownerGates": {
    "triggered": [],
    "conditional": [
      "D40: breaking a frozen contract",
      "D29: adding a dependency",
      "D41: changing an owner-reserved decision",
      "D52: promotion or workload admission beyond the testing-only C3 boundary",
      "Live credentials, provider invocation or spending"
    ],
    "notOwnerGates": [
      "The completed additive F3-139 freeze under D125",
      "Producer population-limit defaults",
      "Supporting an existing opaque paid-route grant address without provider functionality"
    ]
  },
  "slices": [
    {
      "id": "S1",
      "name": "Additive contract and completed freeze bundle",
      "ownedPaths": [
        "contract/ledger/registration.go",
        "contract/ledger/registration_submission.go",
        "contract/ledger/registration_test.go",
        "contract/ledger/registration_fuzz_test.go",
        "contract/ledger/registration_golden_test.go",
        "contract/ledger/catalogue.go",
        "contract/ledger/doc.go",
        "contract/ledger/testdata/f3/139/**"
      ],
      "deliverable": "Four types, schema 5, complete 19-commit/65-record golden, earlier-golden compatibility evidence and mandatory actual Core prerequisite probe. No producer scaffold.",
      "exit": "Joint completed-contract and freeze-record review; PM D125 freeze; frozen contract landed before S2; D153 success for final public SHA."
    },
    {
      "id": "S2",
      "name": "Complete owner producer, queries and replay",
      "ownedPaths": [
        "internal/core/agents/registration_types.go",
        "internal/core/agents/registration_commands.go",
        "internal/core/agents/registration_replay.go",
        "internal/core/agents/registration_state.go",
        "internal/core/agents/registration_query.go",
        "internal/core/agents/registration_service_test.go",
        "internal/core/agents/registration_replay_test.go"
      ],
      "deliverable": "All ruled mutations, queries, scope/CAS/address invariants, global deduplication and replay; live retry/lost-ack/Close regressions; real new-golden prefix replay; grant independence.",
      "sharedChanges": "Only the enumerated sharedFileHooks and mechanical decoder migrations."
    },
    {
      "id": "S3",
      "name": "Interrupted recovery and cross-family acceptance",
      "ownedPaths": [
        "internal/core/agents/registration_crash_test.go",
        "internal/core/agents/registration_recovery_test.go",
        "Narrow extensions to S2 registration tests and registration documentation"
      ],
      "deliverable": "Real positively waited process-death/torn-tail recovery, original receipt retry and cross-family historical behavior; actual Service smoke; ticket and documentation close evidence.",
      "boundaries": "No power-loss claim, provider work, graph implementation, competing cache or promotion."
    }
  ],
  "sharedFileHooks": {
    "structural": [
      {
        "path": "internal/core/agents/service.go",
        "change": "Three latest-state maps and initialization, family consumption, one afterRegistrationCommit hook."
      },
      {
        "path": "internal/core/agents/types.go",
        "change": "MaxRegistrations and MaxDeclarations defaults and validation only."
      },
      {
        "path": "internal/core/agents/scoped_replay.go",
        "change": "Fifth concrete family result and mixed-family rejection."
      },
      {
        "path": "internal/core/agents/replay.go",
        "change": "Registration refresh/install arm and commandMatch/global lookup integration."
      },
      {
        "path": "internal/core/agents/doc.go",
        "change": "Registration owner/evidence/nonsecret/query/recovery contract."
      },
      {
        "path": "internal/core/agents/scoped_golden_test.go",
        "change": "Permanent chapter-139 fixture support in S2."
      }
    ],
    "mechanicalDecodeFamilyCallers": [
      "internal/core/agents/integrity.go",
      "internal/core/agents/paid_fixture_test.go",
      "internal/core/agents/paid_fuzz_test.go",
      "internal/core/agents/paid_live.go",
      "internal/core/agents/paid_read.go",
      "internal/core/agents/paid_settlement.go",
      "internal/core/agents/paid_state.go",
      "internal/core/agents/replay.go",
      "internal/core/agents/review_execute.go",
      "internal/core/agents/review_fuzz_test.go",
      "internal/core/agents/review_replay_test.go",
      "internal/core/agents/review_state.go",
      "internal/core/agents/scoped_submit.go"
    ],
    "ticket140": "Primary owns shared history/cache integration. Ticket139 adds no cache or dependency on Ticket140. Preserve whole-commit F0 command-key invalidation; if a cached commandMatch cannot retain registration, leave that positive uncached and use authoritative lookup.",
    "coordination": "Primary alone owns main integration, shared records, numbering and local compute slots."
  },
  "notesForS1": [
    "This ruling supersedes conflicting brief text; no routine confirmation pass.",
    "ResourceID and explicit immutable external grant address are separate identities.",
    "Support existing opaque keys, including paid-route/<UUID>, without provider or credential prerequisites.",
    "Use resource.set, work_domain.set and declaration.set; remove RegistrationTarget.",
    "Add only two producer population limits; retain actual encoded-size checks.",
    "Golden has 19 commits and 65 records, an earlier root grant, first new effect/receipt 25/26 and final effect/receipt 64/65.",
    "Run actual Core Open prerequisite probing before the joint freeze review; new-family records may remain unconsumed for that probe.",
    "Record zero reconciliation issues, unchanged durable sequence and ledger bytes; legitimate Completed materialization entries are allowed.",
    "Retain a separate invalid-prerequisite negative control, rebuilt consistently, that actual Core Open rejects.",
    "Generate all hashes; preserve every earlier frozen golden, including D149's corrected F3-13.",
    "Private decisions/evidence remain private under D145; primary allocates record numbers; technical decisions use originator assistant.",
    "No unresolved technical source question remains."
  ],
  "evidenceRequirements": {
    "designReviewPerformed": "Read-only source and artifact review; no edits or commands performed.",
    "D125": "Completed contract, generated fixtures, observed hashes, actual Core prerequisite probe, applicable focused/fuzz evidence and proposed freeze record reviewed together before PM freeze and producer implementation.",
    "D152": "Focused behavioral evidence and plain verbose changed-package tests; race and affected x20 tests for shared-state/concurrency changes; risk-specific reachable rule breaks; no duplicate local full gate or speculative measurement.",
    "D153": "Successful hosted classification, all required OS jobs and aggregate Check result on each exact final public SHA before primary moves main.",
    "golden": {
      "commits": 19,
      "records": 65,
      "firstEffectSequence": 25,
      "firstReceiptSequence": 26,
      "lastEffectSequence": 64,
      "lastReceiptSequence": 65,
      "newDigest": "Must be observed from the generator; not assigned by this ruling."
    },
    "pmFuzzCampaigns120Seconds": [
      "FuzzDecodeF3_139",
      "FuzzRegistrationGroupReplay",
      "FuzzScopedGroupReplay",
      "FuzzReviewGroupReplay",
      "FuzzPaidGroupReplay"
    ],
    "privateFuzz": "Normal FuzzPrivateGroupReplay seeds only unless its actual unchanged decoder/planner path is modified.",
    "runtimeAcceptance": [
      "Owner/origin rejection, concurrent CAS and immutable exact grant address",
      "All four declaration combinations, source pins, replacement, withdrawal and historical cursors",
      "Global same-command matching before CAS and producer limits",
      "Original-request preflight binding and committed receipt/projection before acknowledgement",
      "Close, lost acknowledgement, real torn/interrupted recovery and ledger-only restart",
      "Existing grants and old-family behavior unchanged, with no provider or money effects"
    ],
    "verificationClaims": "All implementation, fuzz, smoke, freeze and CI requirements above are future gates, not checks claimed to have run."
  },
  "requests": []
}
```