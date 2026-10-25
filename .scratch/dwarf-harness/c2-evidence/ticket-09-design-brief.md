# Ticket 09 — exact one-off policy activation

Design proposal for advisor ruling; no design choice is adopted by this brief. Repository base: db85ebb. Ticket 08's ruling and frozen F2-08 take precedence over its brief. Repository remains read-only for this assignment.

## 0. Owner summary
Ticket 09 adds exact, owner-authorized policy controls to the existing workspace
module: one immediate/not-before request, retained bytes, revision-checked
replacement/cancellation, durable holds, and one atomic colony-wide cutover.
Old finalization intents finish under their original binding; any unresolved
affected intent prevents the switch. An uncertain clock cannot release a hold.
Replay reconstructs controls; live recovery may finish control bookkeeping,
never restart promotion, validation, capture or model execution.
The product still returns `no_validator`; there is no validator, permissive
substitute, C4 attempt schema, C3 authentication/IPC or U1.E engine here.
F2-09 is needed: five new version-1 control types and one optional intent key.
**OG-F9 (D40/D41):** after contract evidence/review, before producer code writes
F2-09; the freeze answer also signs off its contract slice and decision record.
No design-approval question (D117). No new D52 or D29 approval is anticipated:
the approved boundary and dependencies stay unchanged. A proposed change to
either returns to the corresponding owner gate before implementation.
Sources: T09:10–12,28–30; CORE:868–872; DEC:343–345,1532–1542,1643–1657,
1907–1913,1920–1926; LAW:235–248. Choices P1–P18 are proposals, not decisions.


## 1. Sources and owned paths
### Source abbreviations and precedence

Repository paths below are relative citations; **every coder filesystem path
must be absolute beneath its PM-assigned worktree**, not this base checkout.
`T09` = `.scratch/dwarf-harness/issues/09-control-exact-one-off-policy-activation.md`;
`SPEC` = `.scratch/dwarf-harness/spec.md`; `CORE` =
`docs/DESIGN-CORE-AND-LAUNCHERS.md`; `RC` = `docs/ROADMAP-CORE.md`;
`DEC` = `docs/DECISIONS.md`; `LD` = `contract/ledger/doc.go`;
`LAW` = `contract/law/doc.go`; `UC` = `docs/DESIGN-UNDERCURRENT.md`;
`CON` = `docs/CONTRACTS.md`; `WD` = `internal/core/workspace/doc.go`.
Bare Go filenames mean `internal/core/workspace/`.
`R8` = `local://t08-ruling.md`; `F8` =
`local://t09-f2-08-frozen.md`; `BUD` =
`local://t07-s3b-budget-recommendation.md`; `ENV` =
`local://t09-constraints.md`. R8 wins over ticket 08's brief; the owner-frozen
F8/D123 wins on its records. These local artifacts must accompany the coder's
assignment and eventually the close evidence, not be treated as repository code.

### Owned implementation paths (P1,P13,P15,P17)

| Path | Responsibility |
|---|---|
| `internal/core/workspace/activation.go` | Typed owner controls, exact identity/target validation, immutable target retention, status and active-manifest views |
| `internal/core/workspace/activation_control.go` | Eligibility, clock/timer coordination, own holds, cutover and explicit live-recovery phase |
| `internal/core/workspace/activation_replay.go` | Journalled control rules, commit-shape validation, actual-record metadata hydration |
| `internal/core/workspace/service.go` | Projection initialization/consumption, append/replay dispatch and lifecycle drain; reuse its existing mutex/journal, not another store |
| `internal/core/workspace/errors.go` | Activation mismatch/unknown-ID sentinels; reuse existing ErrRevision/ErrInvalid/ErrNotBound and BusyError/UnavailableError forms |
| `internal/core/workspace/finalize.go` | Ticket 08's not-yet-built intent path: last-moment policy guard and optional activation-record binding |
| `internal/core/workspace/recovery.go` | Ticket 08's landed bookkeeping-phase completion: wake pending control coordination after the recovery flag clears |
| `internal/core/workspace/doc.go` | Producer interface, replay/clock semantics, retention and C3/C4 boundaries |
| `internal/core/workspace/activation_windows_test.go` | One native Windows real-store sharing/uncertain-append row, reusing ticket 08's helper |
| `internal/core/workspace/activation_test.go`, `activation_replay_test.go`, `activation_recovery_test.go` | Behavioral, replay, concurrency and crash rows in §4 |
| Existing `internal/core/workspace/helpers_test.go`, `finalization_service_test.go`, `finalize_test.go`, `service_test.go` | Extend the real-store/Git fixtures and existing finalization regressions only where needed; use ticket 08's landed files without duplicating fixtures |
| `contract/ledger/activation.go`, `activation_test.go`, `doc.go`, `catalogue.go`, `catalogue_test.go`, `golden_test.go` | F2-09 typed codecs, catalogue and compatibility tests |
| `contract/ledger/finalization.go`, `finalization_test.go`, `finalization_fuzz_test.go` | One optional key on the existing FinalizationIntended codec and its compatibility/fuzz cases |
| `contract/ledger/testdata/f2/09/log/00000000000000000001.jsonl` | The new immutable golden in A.8 |

No changes to request/capture/lineage/reservation contracts, `contract/law`,
ledgerstore's interfaces, validation/engine packages or `tools/check`. If the
code digest names a different existing codec file, use the declaring file rather
than moving it. Contract changes are confined to S2. The drafter, not the coder
or designer, owns the decision/register/freeze packet and one close-documents
commit (§5, §7). Sources: service.go:55–95,239–320; train.go:15–52;
WD:450–518,540–579; LD:247–265,368–386; F8:25–36,98–108;
CON:7–17,38; DEC:1907–1913.


## 2. Exact behavior and interfaces

### 2.1 Retention and owner authority
**Exact bytes, not settings files (P2).** An activation target contains the
field-law SHA-256, validation-policy SHA-256 and a strictly UUID-byte-sorted,
distinct list of `(workspace_id, check_policy_hash, environment_policy_hash)`.
The request supplies the exact artifact bytes corresponding to that digest set;
verify every SHA-256, load law and validation bytes through the frozen
`contract/law` loaders with `StandardV1()`, and publish them unchanged through
the existing body store **before** the request/pin commit. There is no
normalization, Git blob header, reread of a later file, alternate settings store
or ability to substitute equal typed values with different bytes.
Check/environment bodies are opaque immutable artifacts here: retaining and
hashing them supplies exact identity, **not** a check definition, valid gate or
runner. C4 specifies and validates their meaning; ticket 09 defines no F4 payload,
fake check loader or executable format. C4 remains unavailable regardless of
which bytes the owner approves. This identity-only treatment resolves the
otherwise unsupplied local-artifact schemas without preempting C4.
Sources: CORE:846,868; LAW:223–248,265–269; UC:454–466;
DEC:1553–1557,1574–1586; RC:289,610–615; R8:16; CON:38.

**Retained versions (P2).** Each accepted request's pin retains the exact union
of its artifact bodies permanently; replacement, rejection, cancellation,
withdrawal and later activation do not unpin approved versions. Repeated
digests share body bytes, not approval identity. This deliberately follows
“retain owner-approved versions”, not the live-request manifest-unpin rule for
promotion captures. Read historical state from records without opening those
bodies. At use, read the pending target again and verify all digests and the two
law-format loaders; missing/corrupt/unsupported bytes make it unavailable, keep
the pending slot and its hold, and do not become a success or a stale rejection.
Use the existing body/store limits and encoded-record/commit preflight; no new
unbounded batch, truncation or chunked activation protocol.
Sources: T09:12,28; CORE:868,870; LAW:223–248; CON:30,38;
WD:101–104,586–588; LD:293–308.

**Owner authority, not authentication (P3).** `ActivationRequest.Actor` must be
`ledger.ActorOwner`; the real caller authenticates that assertion in C3, as
`UpdateInputs` already requires. The owner request itself is the durable exact
approval: a new `OwnerApprovalID` binds this immutable target, scope, expected
manifest and schedule, and is never reused by another request. Its record's
owner actor is the approval evidence; no invented signed token or grants table.
Agents/core may inspect only through their later authorized host projection;
neither can request/replace/cancel/withdraw approval by knowing an ID.
Sources: DEC:463–481; CORE:298,868–870; LAW:242–248; WD:549–552.

The narrow `withdrawActivationApproval` transition invalidates a **pending**
request's exact approval, with owner actor, request ID/hash and approval ID.
It is internal in C2, exercised against the real ledger; C3 later calls it for
an actual authorized withdrawal. It does not revoke the active policy, create
a generic authority service, erase approval history or cancel promotion.
Next live eligibility processing records `rejected/authority_stale`; no
silent rebinding. Reauthorizing the same bytes uses a new request and approval
ID, after that rejection or by explicit CAS replacement. This is the concrete
implementation of the sources' otherwise unspecified authorization invalidation
and owner-reauthorization case, not a permissive callback returning “authorized”.
Sources: CORE:868–872; SPEC:609; DEC:466–467; T09:28.


### 2.2 Request identity, replacement, cancellation and time
**Interface (P1,P5).** Add these typed methods on the existing `Service`:

```go
RequestActivation(ctx context.Context, r ActivationRequest) (ActivationState, error)
ReplaceActivation(ctx context.Context, r ActivationReplacement) (ActivationState, error)
CancelActivation(ctx context.Context, c ActivationCancellation) (ActivationControlResult, error)
ActivationStatus(ctx context.Context, actor ledger.Actor, requestID uuid.UUID) (ActivationState, error)
ActivePolicy(ctx context.Context, actor ledger.Actor) (ActivePolicy, error)
```

The five names are the command/query interface, not test-only entry points.
Owner-only read views are sufficient in C2; C3 adds authenticated authorized
projection, not an agent identity supplied here. `ActivePolicy` is a type as well
as a method name (legal Go); no generic control-operation union is introduced.
Internal `resumeActivationControls`, `advanceActivation`, and
`withdrawActivationApproval` are package-test-reached before their real C3/C4
orchestration callers exist, matching ticket 08's internal finalizer convention.
Sources: T09:28–30; CORE:298,868–872; R8:13,21,28; WD:549–552.

`ActivationRequest` has `RequestID`, `OwnerApprovalID` (UUIDv7), `Actor`,
`Target` (the tuple in §2.1), `ExpectedActiveRecordHash` (zero means bootstrap),
`Schedule` (`immediate` or `not_before`, with timestamp text only for the latter),
and `Artifacts` (digest-keyed immutable input bytes). Copy caller slices/bytes
before work; the immutable semantic binding excludes that storage container
but includes its verified digest set. `ActivationReplacement` adds
`ExpectedPendingID` and `ExpectedPendingRevision` to a new request.
`ActivationCancellation` is owner actor plus expected pending ID/revision.
`ActivationState` returns request/approval IDs, state (`pending`, `held`,
`replaced`, `cancelled`, `rejected`, `applied`), exact request-record hash,
current revision, not-before UTC ns, hold reason, terminal reason/replacement ID,
and (only if applied) the active epoch, activation record hash/sequence/time.
`ActivePolicy` returns a detached full target and the Core activation identity,
or `UnavailableError{Reason:"no_active_policy"}` before the first activation.
These owner views expose no speculative request/generation output.
Sources: CORE:868–872; UC:388–399,456; LAW:242–248; SPEC:587,609.

Concrete input layouts (standard-library UUID and `ledger.Digest` as above):

```go
type ActivationWorkspacePolicy struct {
    WorkspaceID uuid.UUID
    CheckPolicyHash, EnvironmentPolicyHash ledger.Digest
}
type ActivationTarget struct {
    FieldLawSHA256, ValidationPolicyHash ledger.Digest
    WorkspacePolicies []ActivationWorkspacePolicy
}
type ActivationSchedule struct { Mode, NotBefore string }
type ActivationRequest struct {
    RequestID, OwnerApprovalID uuid.UUID
    Actor ledger.Actor
    Target ActivationTarget
    ExpectedActiveRecordHash ledger.Digest
    Schedule ActivationSchedule
    Artifacts map[ledger.Digest][]byte
}
type ActivationReplacement struct {
    Request ActivationRequest
    ExpectedPendingID uuid.UUID
    ExpectedPendingRevision uint64
}
type ActivationCancellation struct {
    Actor ledger.Actor
    ExpectedPendingID uuid.UUID
    ExpectedPendingRevision uint64
}
type ActivePolicy struct {
    ActivationID, OwnerApprovalID uuid.UUID
    Epoch, EffectiveSequence uint64
    RecordHash, RequestRecordHash, ExpectedActiveRecordHash ledger.Digest
    NotBeforeUTCNS, EffectiveUTCNS int64
    Target ActivationTarget
}
type ActivationState struct {
    RequestID, OwnerApprovalID uuid.UUID
    RequestRecordHash ledger.Digest
    Revision uint64
    State, Hold, Reason string
    ReplacementRequestID uuid.UUID
    AdmissionUTCNS, NotBeforeUTCNS int64
    Applied *ActivePolicy
}
type ActivationControlResult struct {
    Outcome string
    State ActivationState
}
```

Revisions exposed as uint64 still obey the ledger's 1..MaxInt64 range.
Use existing `ErrRevision` wrapping with expected/current details, not a
parallel revision error convention. Unknown request IDs give new
`ErrUnknownActivation`; changed immutable bindings give
`ErrActivationMismatch`; wrong actor gives existing `ErrNotBound`.
Malformed structured inputs wrap existing `ErrInvalid`; tests inspect
classification, never incidental prose.
`withdrawActivationApproval(ctx, activationApprovalWithdrawal)` takes owner
actor, RequestID, RequestRecordHash and OwnerApprovalID and returns the same
control result; exact prior withdrawal is idempotent.
Sources: request.go:14–23,62–73; errors.go:10–32,64–79;
register.go:113–143; CORE:868–872; SPEC:587,609.

For new requests, reserve the ID in a separate activation in-flight map, copy
and validate the target, preflight the complete record group against existing
record/commit caps using worst-case signed-ns and envelope/actual-sequence
widths; then publish/verify bodies outside `s.mu`. Re-enter `s.mu`,
repeat pending/CAS/approval-uniqueness checks, take the trusted **admission**
sample and recheck future scheduled time, then append. Slow preparation cannot
turn a now-past scheduled time into an accepted future request. Definite failure
leaves only potentially collectible unpublished/unpinned bytes and consumes no
request ID; uncertainty poisons. Successful new requests/replacements start or
wake the one live loop after acknowledgement. Duplicates/status do not start it.
A well-formed expected hash naming a known older manifest is retained as given
and rejected durably at live eligibility (P18); an unknown hash is invalid.
Sources: CORE:868–872; WD:480–489,549–552;
service.go:245–263; SPEC:591–597,609.

**Identity and refusal order (P5).** Enter the service operation, check
closed/poisoned and owner authority, validate structural IDs/mode and normalize
the scheduled instant, then look up the request's retained immutable binding
under `s.mu`. Same ID/same binding returns its current/terminal state before
clock, body, pending-slot, CAS or target-current checks, with no new append,
timer start, publication or Git operation. An immediate duplicate uses its
recorded admission instant, not a newly sampled instant. A changed target,
approval, expected-active hash, mode, normalized scheduled instant, or
replacement predecessor ID/revision is `ErrActivationMismatch`.
Identical supplied artifact digests with changed bytes are invalid input, never
permission to reinterpret an existing request; known-ID replay need not resupply
bytes. Actor is authority, not part of owner identity. Other refusals consume
no request ID; an ID currently being prepared returns `activation_in_flight`.
Sources: T09:28; CORE:868; SPEC:609; request.go:14–23,62–73;
WD:452–457; LAW:223–241.

For a new request, refuse a second pending request as
`BusyError{Reason:"activation_pending"}`. Replacement requires both expected
pending ID and its **current last control-record sequence** (revision), repeated
after target preparation under the commit lock. A wrong ID/revision returns
an error wrapping existing `ErrRevision`, with no cancellation or request append.
Cancellation uses the same CAS. A repeat of the exact already-committed
cancellation returns its cancelled state without another record; a changed
expected revision is stale. Applied is `too_late`; replaced/rejected is
`already_terminal`, never a successful cancellation of the current occupant.
`ActivationControlResult{Outcome string, State ActivationState}` carries
`cancelled`, `too_late` or `already_terminal`, following cancellation's existing
non-mutating answer convention.
Replacement is one commit: old `ended/replaced`, new `requested`, new body pin;
its visible result is never an empty intermediate slot. Store the predecessor
CAS in the new request so its duplicate lookup remains immutable after restart.
Sources: CORE:868; T09:28; SPEC:609; WD:549–551; R8:21.

**Time (P6).** `not_before` accepts only full RFC3339 with `Z` or numeric
`±HH:MM`, seconds and optionally 1–9 fractional decimal digits; reject a local
timestamp, missing zone, `-00:00` (unknown offset), leap second, invalid offset,
overprecision and overflow. Do not trust `time.Time.UnixNano()` before checking
the signed-64-bit range: convert seconds/fraction with checked arithmetic.
Equivalent explicit offsets normalize to the same UTC ns identity; target
artifact bytes do not normalize. For new scheduled admission `not_before` must
be strictly greater than the trusted admission UTC instant; equality/past is
`ErrInvalid` with field `not_before`. Immediate carries no timestamp and stores
the trusted admission UTC ns. A new command with an unavailable/regressed
clock refuses `UnavailableError{Reason:"clock_untrusted"}` without a request;
duplicates and CAS cancellation remain usable without a clock.
Sources: CORE:868–870; T09:28; SPEC:587,609; LAW:223–241.


### 2.3 Holds, drainage and the colony-wide switch
**Scope and bootstrap (P4).** The target's workspace list is the full configured
local check/environment map of the new manifest, not a per-workspace policy
version map. Every listed ID must be registered. Unlisted workspaces have the
same colony-wide global epoch but **no configured gate** and cannot create
new policy-bound intents. A global law/validation-policy change affects the
union of prior/target configured workspace IDs; a checks/environment-only
change affects exactly added, removed or changed entries. The request records
that derived sorted set; it is recomputed/checked against the expected prior
manifest at append and replay. Bootstrap has no invented baseline record:
expected-active hash is absent, epoch begins at 1, and affected IDs are target
IDs. No zero-hash fake active manifest is written.
Sources: DEC:477–498; CORE:846,868–870; UC:456,466;
LAW:242–248; F8:15 (the precedent against a fabricated baseline).

Registration itself does not enroll a new workspace in validation. A workspace
not in either map cannot bypass the policy guard by being registered while a
request is pending. Once any F2-09 request exists, an intent needs an actual
active manifest and a local entry, or refuses `policy_unavailable`.
All old F2-08 intents, including pre-bootstrap intents, remain reconcilable;
bootstrap's affected set must additionally include every registered workspace
with a live legacy intent at request admission. No fresh legacy/unbound intent
is then permitted. The affected set therefore has no later-growing membership
race. This conditional migration preserves old logs without allowing ticket 09
to manufacture a usable validator or a default gate.
Sources: CORE:868–872; RC:289,349,360; CON:16–17;
F8:76–96,226–233; R8:15–16,29. This scope/bootstrap gap is P4.

**One short authority transition, not all train locks (P8).** Both policy
eligibility and the finalizer's final intent check serialize under the existing
`s.mu` through `appendLocked`. Keep expensive Git, artifact reads and loader
work outside it. The finalizer already holds ticket 08's `lockTrain` while
preparing Git; after preflight, it re-enters `s.mu`, runs the policy guard and
appends the intent before releasing `s.mu`. No observation of “no hold” outside
this interval authorizes the intent. Policy activation never waits for a train
lock while holding `s.mu`, and never takes every workspace lock. Existing intent
resolution/acceptance is allowed through a policy hold. Thus either the old
intent commits first and must drain, or the hold commits first and the intent
cannot appear. No global Git lock or extra sequencing service is needed.
Sources: CORE:868–870; DEC:456,480,560–563; service.go:239–263;
R8:14,17,19,27–28.

Make the split explicit: `guardActivationIntentLocked(ctx, workspaceID)`
does only current-state/clock/hold transitions under `s.mu`, then either permits
the immediately following intent append or returns
`UnavailableError{Reason:"activation_pending"}` (clock reason
`clock_untrusted`, recovery reason `activation_recovery_pending`).
It never reads bodies, runs loaders or applies a new manifest while the
finalizer's preflight is paused. A due/uncertain guard appends the hold and wakes
the loop, then refuses this intent attempt; it never resumes that old-policy
attempt after the switch. `advanceActivation` performs artifact reads outside
the mutex and rechecks exact pending revision/authority/active hash plus current
clock under it before the one switch. Thus C4 must obtain fresh evidence before
another intent, not accidentally reuse the interrupted caller's old proof.
No-change, capture and Git derivation create no intent and are not barred merely
by an activation hold; their independent recovery/intent fences still apply.
Sources: CORE:870–874; RC:328–330,610–615; R8:14,16–17,23,28.

**Eligibility and own holds (P7,P9).** Before every proposed new affected intent,
and on the one derived due wakeup, evaluate the current pending request:

| Situation | Durable/result action |
|---|---|
| Trusted clock, before due, no existing due hold | Old manifest remains; no activation hold. A prior clock-only hold is released by this request's `hold_changed/none`. |
| Trusted clock at/after due | Append `hold_changed/due` before another affected intent; then perform the authority/target/expected-manifest checks. |
| Unavailable or regressed clock | Append `hold_changed/clock_untrusted` (or keep its existing due hold); block affected new intents even if scheduled eligibility cannot be established. |
| Approval withdrawn or expected manifest stale at live eligibility | `ended/rejected`, reason `authority_stale` or `manifest_stale`; free pending slot and only this request's hold. |
| Exact pending target unavailable | Pending/held and unavailable; do not release its hold or invent a rejection/success. |
| Any affected unresolved intent or unfinished ticket 08 recovery phase | Keep old active manifest and hold. Reconciliation may resolve only by ticket 08's positive mapping. |
| Due, trusted, authorized, exact target intact, expected manifest current, no affected intent/recovery phase outstanding | Append the one `policy_activated` commit described below. |

Never poll or append a duplicate unchanged hold. A due hold cannot be cleared
by a rollback; the durable due observation itself raises the clock floor.
Independent finalization, recovery, poison, missing-object and writer fences
remain independent predicates, not one mutable `blocked` flag. Cancellation,
replacement and rejection remove a hold by its request ID only.
Sources: CORE:868–872; RC:328–330,349,360; SPEC:609;
F8:76–96,226–233; service.go:203–214,245–263.

**Clock and the single timer (P7).** An internal clock observation is a UTC
`time.Time` plus an availability error; the normal adapter uses `time.Now`.
Reject out-of-range samples and wall-time regression below either the latest
trusted in-process observation or the greatest trusted UTC observation already
stored in F2-09 records. The floor is rebuilt from request admission, known-time
hold changes and actual activation timestamps, never UUID/envelope time.
An unavailable observation supplies no fabricated UTC value. The host may
also report clock trust lost through the same internal clock adapter; a
timestamp alone is not a guarantee against external clock manipulation.
After restart, time below the durable floor remains untrusted until caught up;
there is no owner “ignore clock” command.
Sources: CORE:868–872; SPEC:587,609; T09:29; DEC:473–474.

Use one service-owned timer derived from the one pending request, armed only
by live control coordination, not replay/Open/status/duplicate lookup.
Successful new requests/replacements wake that loop; cancellation disarms it.
A trusted clock before due arms the delta to not-before. With a representable
but regressed sample, one timer may instead hint when max(clock floor,
not-before) could be reached; it must resample and reauthorize on waking, never
infer trustworthy time from that elapsed delay. With no usable time sample,
wait for the clock-availability notification or a guarded live control/intent
entry, not periodic polling. Timer duration subtraction is checked/clamped to
time.Duration's positive maximum; an early clamped wake only rechecks the same
request. No periodic schedule or exact-time guarantee results.
Wakeups only request eligibility. Re-read pending ID/revision and clock under
the sequencer, and discard stale wakes after replacement/cancellation.
`activationNow func() (time.Time,error)` defaults to time.Now with nil error;
an internal clock-trust notification feeds the same size-one wake channel.
These are host time inputs, not an authority callback or a clock framework.
Sources: CORE:868–872; SPEC:587,609; DEC:473–474.

A due request blocked on old intents waits on this same wake channel, not an
immediate-timer loop: after an affected intent's accepted/interrupted ending
is acknowledged, `appendLocked` nonblockingly signals the channel; ticket 08's
`recovery.go` signals once more after it clears the local recovery-phase flag.
Neither signal applies policy or restarts promotion in the notification path.
Explicit live control resume after exact-body repair may also wake coordination;
there is no file watcher or retry scheduler. Include the “last old intent
resolves without another owner command” transition in the shared-cutover test.
Sources: CORE:870–872; RC:360; R8:19,27–28;
local://t08-brief.md:49–54; SPEC:609.

The coordinator owns a cancellation context and done channel, separate from
`ops`: each finite advance enters/leaves the existing operation drain, never
counts its entire waiting loop as an operation. `Close` first marks closed and
cancels/disarms the loop under s.mu, then unlocks, waits for finite operations
and joins its done channel (if started). The loop never holds s.mu while waiting
for wake/time/I/O; Close appends no request cancellation.
Sources: service.go:55–61,203–236; CORE:872; SPEC:587,609.

**The switch (P10).** Immediately before the append, recheck the same request,
current revision/approval, prior active hash, intact verified target snapshot,
due trusted time and absence of affected intents/recovery phases under `s.mu`.
One `workspace.policy_activated` record changes the entire target and epoch,
ends this pending request as applied and releases its hold atomically.
Epoch is previous +1 (bootstrap 1), checked through MaxInt64. Actual
`effective_sequence` is the record's **assigned envelope sequence**, not a
predicted `Durable()+1` payload value; identity is that actual record's hash,
not a self-hash. `effective_utc_ns` is the trusted sample at this live transition,
at least `not_before` and the clock floor, never the planned instant copied
to disguise lateness. It is not a physical fsync-completion timestamp or an
exact-time SLA. No Git mutation, runner dispatch, request cancellation,
submission recapture or per-workspace active pointer is part of this commit.
Sources: CORE:870–872; UC:396–399,456–458; LAW:242–248;
SPEC:609; DEC:456–458,480–488.

**Binding ticket 08 (P10,P13).** Add the optional digest
`activation_record_hash` as the last payload key of
`workspace.finalization_intended`. When F2-09 has begun, it is required by the
producer/replay rule for **new** intents and equals the currently active
manifest's actual record hash; the request's workspace must have a target entry.
The reference transitively binds that manifest's activation ID, epoch,
effective sequence, global law/policy and exact local check/environment hashes;
do not copy the full manifest into each intent. Before any F2-09 request, absence
remains valid for F2-08-only mechanical histories. A present hash must always
resolve to an earlier active manifest with the appropriate workspace entry.
Acceptance and recovery bind through their existing immutable intent ID, not a
new active-policy lookup; a held old intent never silently acquires a new policy.
Generations are Git derivations, not validation evidence, so no policy key goes
on `generation_derived`; no-change has no intent or check evidence to pretend
to refresh. F4 later adds actual attempt/evidence bindings, not this ticket.
Sources: CORE:864–870; UC:456; F8:56–108,110–151;
R8:16,23,29; CON:16–17,38.


### 2.4 Recovery and replay
**Replay is inert (P11,P13).** Consume the F2-09 types through the existing
Reader, journalled `apply`, and the same append/Open record rules. Replay
reconstructs retained request bindings, approval validity, current/terminal
states, latest revision, exact active record identity, epoch, clock floor and
request-owned holds from committed envelopes. It reads no clock, starts no
timer, publishes no body, executes no Git/check/model work and appends no
activation. Torn/uncommitted suffixes remain the store's existing concern.
Sources: CORE:872; F8:226–233; WD:512–518,530–538,566–579;
SPEC:591–597,609.

Open leaves live control coordination stopped. If a pending request has no
durable hold, report `activation_recovery_pending` for its affected workspace
set: this is a conservative, **request-owned service recovery fence**, not an
invented past hold record or a claim it was due. Existing durable own holds
are restored. New intents wait for live control recovery to observe trusted
time; status and owner cancellation/replacement remain available.
`resumeActivationControls(ctx)` is explicit, internal C2 mechanics; C3's host
recovery phase eventually invokes it alongside `reconcilePromotions`.
It checks/installs the current own hold, clears only its own conservative
startup fence once that check is complete, lets ticket 08 resolve old intents
and then starts the one live loop. Cancellation/replacement/rejection also
remove the ended request's conservative activation fence, never ticket 08's
promotion-recovery or unresolved-effect fences.
This phase calls no finalize/integrate/admit/validator/capture/model operation.
The request keeps its ID, approval and not-before; applied remains applied once.
Sources: CORE:872; RC:321,349,360; R8:27–28;
F8:226–233; SPEC:609.

### Crash and storage rules

Use `appendLocked`'s journal and poison conventions. Definite append failure
leaves no new visible state; an uncertain append poisons and prevents further
work until real-store reopen resolves committed records. If a hold append
fails, the proposed new intent fails too; never “fail open” because the
durable hold could not be acknowledged. An acknowledged activation followed
by a process crash reconstructs the new manifest even if no caller saw it.
An unacknowledged committed activation is not repeated after reopen.
Sources: service.go:239–263; WD:480–489; CORE:870–872;
SPEC:591–597,609.

Actual record hashes cannot be predicted from `Durable()+1` or synthesized
from payloads. Extend the internal append/replay metadata path to hydrate the
F2-09 request/active hash and revision from the verified **actual records**.
After successful `Store.Append`, for a commit containing `requested` or
`policy_activated`, use
`ledger.OpenReader(LogDir, {Colony, After: committed.First-1,
Through: committed.Last, Consume: workspaceConsumption(), AllTypes:true})`,
read the exact complete commit with `Next`, verify its First/Last and projected
types/IDs, take verified Record.Hash/Seq and close the reader. Keep `s.mu`
through this short metadata hydration before returning/exposing the projection.
Other control revisions need only the existing `committed.First+index`
correction, not another reader pass. On replay, after each complete `apply`,
hydrate from that already-read Commit before processing the next one.
No record refers by hash to a new record in its own commit; no appender contract
change, guessed time, self-hash or full-log scan is needed. If post-commit
hydration fails, poison and return the error; never undo a known committed
record. Preserve all existing actual-First corrections for other producers.
Sources: contract/ledger/reader.go:24–44,58,147–154,182–195,216;
contract/ledger/envelope.go:67–85; service.go:149–172,245–318.

Projection layout: retain activation requests by UUID (immutable payload,
actual request hash, current revision/approval/hold/terminal data);
record-hash→request UUID for earlier activated manifests; one active view and
one pending UUID; permanent activation pin IDs; explicit recovery-fence set;
trusted-clock high-water with a separate presence bit; separate activation
in-flight IDs. The target already lives in the immutable request, so historical
manifest lookup reuses it rather than copies another full history. All are
rebuildable projection fields and journal changes, not a second authority store.
The pending revision/terminal revision is corrected to actual First+index after
every control append. Epoch/sequence exhaustion refuses and leaves the current
state/hold intact; it never wraps or invents an activation.
Sources: service.go:55–89,245–339; CORE:868–872; UC:456;
WD:611–618; SPEC:591–597,609.

Test hooks: reuse ticket 08's `beforeStoreAppend` and `beforeFinalizeStep`.
Add just one private `serviceDeps.activationStep func(string)` scheduling/crash
hook, with `target_published`, `before_hold`, `after_request_ack`,
`after_hold_ack`, `before_drain_check`, `before_activation`,
`before_metadata_read`, `after_activation_ack`, `after_replacement_ack`,
`after_cancellation_ack`, `after_withdrawal_ack`, `after_rejection_ack`.
`before_metadata_read` runs after real Store.Append under `s.mu`; all other
listed hooks run outside it. The existing `beforeStoreAppend` handles exact
precommit crash points. Hooks pause/exit or arrange real I/O errors, never
return fabricated durable state, clock authorization or Git outcomes.
Sources: R8:30,34; SPEC:587,591–597,609; BUD:28–30.


### 2.5 Ticket 08 and later-capability boundaries
| Boundary | Ticket 09 does / intentionally does not do |
|---|---|
| Ticket 08 (strict dependency, unbuilt) | Reuse its `lockTrain`, finalizer preflight/append seam, unresolved-intent projection, accepted witness, recovery-pending bookkeeping, `writerQuiescence` and finalization hooks. Only add the short policy guard and optional intent key. Never reimplement its CAS/directory flush/recovery proof. Old intent outcomes remain old-tip→interrupted, exact-target→acceptance bookkeeping, other/insufficient proof→blocked. |
| C3 | Caller authentication, owner IPC/commands/receipts and host startup coordination remain C3. No stand-in authenticator, generic grant authority, wire schema or completion-triggered model turn. Existing owner assertions are the same trust seam as `UpdateInputs`. |
| C4 | Full required-check definitions, attempt/evidence records, lane resources, superseded-child stop/positive exit, fresh validation and integrated acceptance stay C4. Affected pre-intent work cannot finalize on superseded requirements evidence; preserve immutable submissions and real outcomes, reuse a candidate only while its predecessor remains current, create a new generation on predecessor change. A policy switch itself dispatches none of that. |
| U1.L / U1.E | Consume frozen `contract/law` loaders and exact hashes. U1.L alone owns the three D47 parameters. No law parser/encoder fork, fourth parameter or field engine; C4 need not wait for U1.E. |
| D52 | Keep `RequestPromotion`'s unconditional `no_validator` untouched. Test-only admitted/finalized requests in disposable repositories exercise the real mechanisms, not a bypass supplied by policy approval. No accepted-delivery, hostile-process isolation, power-loss or capacity claim. |

Sources: RC:289,328–330,349,360,610–615; R8:13–17,19,26–28;
F8:56–108,226–254; WD:473–476,549–552; DEC:304–310,
343–345,456–498,555–565,1577–1583; LAW:265–269.

For a local-only cutover, the new manifest hash/epoch is colony-wide but only
the derived affected workspace set changes requirements. Do not infer blanket
revalidation of unaffected work merely from a new record identity. C4's F4
attempt/evidence design must join historical activation identity to the exact
global/local requirement tuple; this ticket supplies the immutable chain and
current intent binding, not a permissive evidence-equality fallback or a
new cross-attempt cache. Sources: CORE:870,874; DEC:492–498,560–563;
UC:456; RC:610–614. This identity-versus-applicability distinction is P4/P10.

## 3. Records and compatibility
**F2-09 is required (P12,P13).** A memory-only timer/hold loses the approved
exact request and its restart barriers; ad hoc files or a second authority
store contradict the selected ledger/sequencer mechanism. Appendix A specifies
five version-1 types in the existing `workspace.` family and the optional key
on the frozen F2-08 intent. They join `ledger-format` version 1 by addition.
Common codecs remain standard-library-only; no changes to law-format,
ledger-reader, ledger-appender or ledgerstore. The owner freezes these shapes
through §7 before their producer runs. Record-free timestamp/identity helpers
may land first; contract codecs/goldens can be built and reviewed on S2 before
the freeze, but reach main only with it.
Sources: CORE:868–872; CON:7–17,30,38; DEC:1643–1657;
F8:98–108; T09:12,28–30.

Every new replay restriction is conditional on a new F2-09 type or key.
The prior F0/F2-05/06/07/08 goldens remain byte-for-byte unchanged. Unknown
payload keys continue to be ignored under the frozen additive rule; absent
optional `activation_record_hash` remains decodable. Service replay enforces
its conditional presence/current-manifest rule; the codec does not pretend to
read history. No frozen outcome/reason is repinned to new incidental wording.
Sources: LD:257–265,379–386,529–547,574–584; CON:16–17;
F8:183–217; R8:29,33; SPEC:587.


## 4. Tests and fault matrix
**Common discipline (P14).** Use the actual `Service` controls, real
`ledgerstore.Store`, actual frozen law loaders and real disposable Git
repositories for every finalization interaction. No mock Git/store/authority
callback/validator, source-text assertion, fake accepted effect or artificial
pass flag. A deterministic injected clock is permitted time input, not a
replacement for durable effects. Tests assert caller-visible states, hashes,
real retained bytes after collection/reopen, real canonical refs and committed
record order. Every test starts with `t.Parallel()` except an existing
explicitly documented process-global/opt-in fixture that cannot.
Sources: T09:34; SPEC:585–587,591–597,607–609;
BUD:25–30; R8:30,34.

| Named test | Observable assertion / plausible bug caught |
|---|---|
| `TestActivationOwnerAndExactRetention` | Agent/core controls refuse before body publication; owner approval pins exact law/policy/check/environment bytes. Mutate caller buffers/files, collect unpinned bodies and reopen: active/pending identity and bytes remain the approved ones. Catches approval-by-edit, unretained opaque artifacts, normalized byte identity or delegated authority. |
| `TestActivationSameIDAndOnePending` | Exact immediate and scheduled duplicates (pending, held, each terminal state, reopened) keep the admission instant and return the one original state without new records/effects; target/approval/schedule/expected-prior/replacement-CAS changes under that ID refuse. A distinct ID is busy, even for identical content. Catches time recomputation, coalescing, lost identities or extra pending slots. |
| `TestActivationReplacementCancellationCAS` | Race stale replacement and cancellation against a real hold revision and then a newer request. Exactly the current expected ID/revision may change the slot; replacement's old-ending/new-request/pin is one commit; retries do not replace the replacement or cancel a different occupant. Catches ID-only CAS and split replacement commits. |
| `TestActivationTimestampBoundaries` | Valid explicit offsets normalize to the same ns; immediate stores admission time. Refuse past/equal scheduled time, local/missing/unknown zone, invalid offset, leap second, >9 fractional digits and signed-64 overflow on each side; exercise exact representable endpoints in the pure parser. No sleeps. Catches UnixNano wrap and silent sub-ns truncation. |
| `TestActivationClockHoldAndRecovery` | Fixed-clock before-due progress, due equality, unavailable sample, in-process regression, restart below durable clock floor, recovery before due and recovery after due. A pre-due clock hold can release only itself; a due hold stays through rollback; status/duplicate/cancellation work without clock. Catches UUID/envelope/elapsed-time substitution, hold release on regression or a poll-driven early activation. |
| `TestActivationSingleDueWakeup` | Drive the actual coordination loop with fixed clock/explicit clock notification and the real timer under `testing/synctest` where appropriate. Replace/cancel while waiting; old timer wake cannot hold/apply the new request. Close with an armed timer and reopen: no goroutine-driven append until explicit live recovery. Catches stale wake ownership, recurring/polling scheduling and Close deadlock. |
| `TestActivationSharedCutoverWaitsForAllIntents` | Two affected real workspaces have preexisting real F2-08 intents; resolve one acceptance and one interrupted result through actual mechanisms. Until both are proven, neither target global policy nor any local binding changes; after both, one committed active manifest changes both local bindings under one epoch. Catches per-workspace rollout or “one workspace drained” switch. |
| `TestActivationIntentAdmissionLinearization` | Deterministic hooks pause finalizer before its intent append and policy before hold. Exercise both orderings: an earlier old intent drains; a hold ordered first prevents a later intent and Git update. Existing intent can finish while held. Catches unlocked pre-check and a deadlock from acquiring train locks under `s.mu`. |
| `TestActivationScopeAndBootstrap` | No baseline activation is invented. Bootstrap covers configured target IDs plus existing legacy-intent IDs; later law/policy changes affect union of old/new configured IDs, checks-only changes the exact delta. An unconfigured/new workspace cannot finalize unbound, and an unrelated configured workspace can finalize before/through a checks-only hold. Catches colony-wide policy splitting and overbroad global blocking. |
| `TestActivationIntentBindsActualManifest` | Inspect a real committed intent after activation; its hash resolves to the actual earlier activation with exact local/global bindings. A held old intent retains its old binding through recovery. Alter intent binding to an unknown/old manifest and exercise the common append/Open rule. Catches binding to current policy during acceptance, guessed hash or stale-policy intent. |
| `TestActivationAuthorityWithdrawalAndReapproval` | Withdraw the exact pending approval through the real typed transition, observe one durable authority-stale rejection and only its hold removal, then approve the same bytes with new IDs. Replayed withdrawal/new approval cannot revive the old request. Catches a cached authorization boolean or in-place reauthorization. |
| `TestActivationStaleManifestAndUnavailableTarget` | An unknown prior hash refuses; a known stale expected manifest gets one durable manifest-stale rejected outcome at live eligibility, with no rebinding. Missing/corrupt pending body blocks a due request and retains its slot/hold across reopen; restoring the exact body permits progress, not a newer substitute. Catches fallback to newer files, “missing means reject/success”, or stale prior accepted silently. |
| `TestActivationCancellationPreservesForeignFences` | Cancel/replace/reject a held activation while a real unresolved finalization still exists. Only the request-owned hold disappears: the unresolved intent still bars publication. Conversely an isolated activation hold disappears on current CAS cancellation without cancelling live promotions. Catches a global `clearBlocked()` implementation. |
| `TestActivationReplayIsInertAndOverdue` | Close/reopen a not-yet-due and overdue request with an unresolved effect. Open/status/duplicate lookup append nothing and change no Git state; explicit live resume installs/restores the hold, real ticket 08 recovery proves the effect, then at most one activation gets an actual later UTC time. Reopen after applied does not reapply or backdate. Catches replay-as-execution and “schedule equals effective time”. |
| `TestActivationAppendFailureAndHashHydration` | Exercise definite append refusal and lost acknowledgement separately on request/replacement/hold/application, with actual commit inspection/reopen; interleave another real producer append between Durable and Append. Returned request/active hash and effective sequence come from actual verified envelopes; a post-append metadata-read failure poisons, not rollback. Catches projection leakage, guessed First, self-hash and a committed activation reexecuted. |
| `TestActivationCrashMatrix` | The subprocess matrix below; every row asserts exact committed control state, real ref state, retained exact bodies and whether live resume may append. Catches each missing barrier/acknowledgement window. |
| `TestActivationRecordRules` | Matrix of the A.7 violations through the same journalled append rule with real-store prefix snapshots; one real Open row per new type and the extended intent, remaining rows use projection replay from the closed real prefix. Catches append/Open rule divergence without an Open per malformed field. |
| `TestF2_09Payloads`, `TestGoldenF2_09`, `TestF2_09Compatibility` | Codec boundaries, frozen golden and older consumers skipping unknown keys/new unconsumed types; altered exact vectors fail. Catches incompatible absence, unsigned-time parser, body references hidden in payload and old-golden regeneration. |
| `FuzzDecodeF2_09` and changed `FuzzDecodeF2_08` | Seed every new type, signed ns endpoints (including present 0) and absent/present optional intent key. Every accepted value re-encodes/re-decodes stably; malformed/duplicate/null and zero-present IDs/digests refuse. Catches parser panic, lossy int64 handling and conditional-key decode mistakes. PM fuzzes only these changed paths. |
| Existing `TestRequestPromotionUnavailableInC2` (extend) | Even after an owner-approved real activation, promotion still gives `no_validator`, changes no ref and emits no accepted-promotion event. Catches activation accidentally becoming a validator bypass. |

The table traces to T09:28–30 and CORE:868–872; real-surface discipline to
SPEC:585–587,591–597,609. Binding/compatibility rows also trace to
LAW:223–248, LD:257–265,379–386 and F8:98–108,226–233.

### Crash points and bounded rows

Use ticket 08's real child-process exit hooks/real store. One history and one
closed store prefix per matrix, copied into per-row disposable directories;
Git clones use `--no-hardlinks`. Use one row per meaningful crash point ×
different recovery outcome, not a cross-product of clocks, formats, scopes,
timestamps and every finalization crash. Ticket 08 already proves its own
intent/CAS/durability/acceptance windows; here vary their policy interaction.
Sources: BUD:25–30; R8:30,34; SPEC:587,591–597,609.

| Stop point | Expected recovery fact |
|---|---|
| Target bodies published, before requested/pin commit | No request or hold survives; no activation; bodies may remain unpinned and collectible. |
| Request commit acknowledged, before loop/hold | Exact request/pin survives; Open is inert; live overdue resume installs its hold before any new affected intent. |
| Before hold commit | No fabricated durable hold; conservative recovery fence still prevents bypass until live eligibility processing. |
| Hold durable, before drain check | Hold/old manifest survive, including with one affected unresolved intent. |
| Old intent's Git effect before its acceptance acknowledgement | Ticket 08's exact-target/old-tip/other-tip cases; only proven missing bookkeeping, never another update-ref; activation waits through unresolved proof. |
| Last old intent resolved, before activation commit | Old policy and hold survive; only explicit live control resume can complete the one switch. |
| Activation commit durable, before projection/hash hydration/return | New manifest is authoritative on reopen; actual hash/sequence/time reconstructed; no second activation. |
| Before/after replacement commit, before caller response | Entire old request/hold or entire replacement; never a cancelled old request with no new pending record after a purported successful replace. |
| Before/after cancellation commit | Either the same own hold or a cancelled request with its hold removed; unrelated recovery fence survives both. |
| Before/after approval-withdrawal and rejected-outcome commits | Approval validity and resulting rejection reconstruct; no return to authorized merely because no volatile caller remains. |

Use real-store torn-tail handling on one hold/application boundary, and the
existing lost-acknowledgement wrapper only for the explicitly labelled lost-ack
case, not a claimed OS write failure. One Windows real sharing/segment-lock row
on a hold or application uses ticket 08's proven `LockFileEx` method and releases
the range before reopen. Clock rows use fixed samples/hooks, never sleeps;
crash hooks schedule real effects and do not manufacture outcomes.
Sources: R8:30,34; BUD:28–30; SPEC:587,591–597,609.


## 5. Verification, slicing and close
**Environment and responsibilities (P15,P17).** Designer runs no commands.
Coder uses go1.27.2, `GOTOOLCHAIN=local`, empty `GOFLAGS`, `CGO_ENABLED=0`;
race alone sets `CGO_ENABLED=1` and the pinned `CC` from ENV:4.
No new module/tool/runtime dependency. Add the single consumed frozen
`contract/law` edge to the workspace import audit; contract/ledger stays
standard-library-only, and ticket 08's `internal/core/durable` edge stays.
This is consumption of an existing owner-frozen contract, not a D29 exception.
LF, gofmt, staticcheck and the current import-layer check remain unchanged.
Sources: DEC:121–133,1660–1669,1907–1913,2026–2034;
ENV:3–10; CON:7,30,38.

Run commands alone and serially; a coder's final V1, whole-package race and
V5 run on its final hashed tree, with no later code edit. PM checks hashes,
commits, collects exact-commit evidence and supplies it to the one ticket
advisor; PM alone runs the full check on the exact main-bound commit.
No routine retest of unchanged already-hashed evidence. A fix-up gets evidence
for its changed tree and advisor re-review.
Sources: DEC:1907–1913; ENV:12–17.

| Evidence | Command / scope |
|---|---|
| Formatting/static analysis | `gofmt -l internal/core/workspace contract/ledger`; `go vet ./internal/core/workspace ./contract/ledger`; `go tool staticcheck ./internal/core/workspace ./contract/ledger` |
| V1 (producer slices) | `go test -count=1 -timeout=19m -v ./internal/core/workspace` |
| Whole-package race timing | With the pinned CC and cgo=1: `go test -race -count=1 -timeout=29m -v ./internal/core/workspace`; this diagnostic allowance does not replace the full check's 20m gate |
| V5 (only the concurrency set) | `go test -race -count=20 -timeout=45m -run '^(TestActivationReplacementCancellationCAS|TestActivationIntentAdmissionLinearization|TestActivationSingleDueWakeup)$' ./internal/core/workspace`; slice-relevant subset only; never a broad `Activation` expression pulling crash matrices into ×20 |
| V2 (contract S2) | `go test -count=1 -v ./contract/ledger ./internal/core/ledgerstore` |
| V3 (PM) | `go test ./contract/ledger -run '^$' -fuzz '^FuzzDecodeF2_09$' -fuzztime 120s`; changed `FuzzDecodeF2_08` the same; only targets whose fuzzed implementation changed |
| V6 | `go list -f '{{join .Imports "\n"}}' ./internal/core/workspace` and the same `.TestImports`; `go list -deps -f '{{if not .Standard}}{{.ImportPath}}{{end}}' ./contract/ledger`; verify only admitted edges |
| V7 | Coder `go mod tidy -diff`; PM `go mod tidy`, unchanged module files and `go mod verify` |
| V8/V9 | `go test ./contract/ledger -run '^TestGolden' -update`; every earlier golden unchanged; pin new committed blob SHA-256 and LF (`i/lf w/lf`) |
| V12 | `GOOS=linux go vet ./internal/core/workspace ./contract/ledger`, then darwin, cgo=0; restore host GOOS. Compile/vet is not native runtime evidence. |
| V4 (PM only) | `go run ./tools/check` with pinned absolute `DWARF_CC`; its plain/race steps each use `-timeout 20m`; one full check per exact merge commit |

**Cost (P16).** Use the ticket 07 close/B26 and then ticket 08's final evidence
as the baseline; supplied base was 362.0 s plain / 460.2 s race, not a new
measurement. Every producer slice reports in-check package plain/race time,
ten slowest race tests and any single test >60 s with row count. At race >15m,
name it in evidence/B-NEXT and return the D122 choice to the owner before
claiming the budget is settled; never change `tools/check`, split test packages,
export test-only seams, skip rows with `-short`, or narrow accepted behavior.
Reopen only when Open/recovery is the test subject. A shared prefix plus
projection-rule rows is the established optimization, not fewer crash points.
Sources: DEC:2026–2034; ENV:19–20; BUD:25–30.

Labelled capacity reasoning, not measurement: a normal activation contributes
request+pin, at most one due hold, and one activation record: four records,
with O(N) hashes and artifact bytes for N configured workspaces. Replacement
adds one old ending to the new request/pin group. Clock hold transitions are
recorded only when state changes, not per check or timer poll. No Git command
or expensive validator is added to the short switch; only its preexisting
intents delay it. Measure those new control phase durations/record counts
from ordinary real-store scenarios without a permanent timing assertion or
a second workload suite. Ticket 08/C4 own Git flush and every-change runner
capacity measurements. Sources: CORE:868–872; DEC:571–574;
SPEC:618–622; BUD:25–30.

### Slices and merge prerequisites (P15)

| Slice | Complete deliverable | May start / merge needs |
|---|---|---|
| S1 — record-free | Pure timestamp conversion, exact target/digest-set and immutable-binding helpers with deterministic edge tests; no records, loop, grant stub or public method whose body is unfinished | After ticket 08 closes and advisor ruling; routine review + evidence + one exact-commit full check. No owner freeze needed. |
| S2 — F2-09 | All codecs/catalogue/optional intent key, complete A.8 golden, compatibility/fuzz seeds; proposed contract package docs and freeze evidence | Can develop on the contract branch after ruling; merge only after advisor code/evidence/packet review and OG-F9's owner freeze/sign-off, with D-NEXT/register/packet-answer record and exact-commit full check. No producer writes before this. |
| S3a — controls | Complete owner request/replace/cancel/status/withdrawal transitions, retained bytes, replay/actual metadata, own holds, clock and due loop, actual atomic activation, recovery phase, intent guard/binding and C2 refusal regression | After S1 and owner-frozen S2 and ticket 08's landed finalizer. Implement as one end-to-end seam, not stubs spread over slices. Unit/behavior/concurrency and one overdue recovery row prove the whole path. Routine advisor review + evidence + one exact-commit full check if no frozen shape changes. |
| S3b — fault proof | Full bounded subprocess/storage/clock/replay/native matrix and final documentation in doc.go; remaining regression rows from §4 | After S3a; no new behavior/shape by stealth. Routine merge after advisor evidence review and full check; contract or owner-decision change reopens its owner gate. |
| Close — one documents commit | Ticket status/criteria/answer/comments; byte-copied brief and ruling under c2-evidence; one short B-NEXT, measurements/evidence links; C2 Status line and ROADMAPS status board together if C2 is actually complete | Drafter composes once from notes and final code/evidence; advisor reviews; full check on exact final commit. Never mark whole C2 Done merely because ticket 09 design or contract is complete. |

Source: DEC:1643–1657,1907–1917,1920–1926; F8:17–19;
R8:13–16,27–31; T09:7–8,14–24; CON:38.


## 6. Numbered design choices
Each P-number settles a source gap only; recommendations need advisor ruling.
The freeze shape under P12/P13 belongs to the owner at OG-F9, not the designer.

| ID | Options considered | Recommendation and reason / controlling source |
|---|---|---|
| P1 — placement/interface | Separate policy service/store; exported test harness; extend workspace module | Extend the actual Service with typed owner commands and private coordination. It is already C2's producer and the finalization seam; no seventh contract or fake C3 host. CORE:868–872; CON:38; WD:540–552; R8:13–14. |
| P2 — retained artifacts | Read mutable files at due time; define F4 check/environment schemas now; exact opaque bytes plus frozen law loaders | Retain every approved exact body with the request's permanent pin; parse only U1.L artifacts. Exact identity is required now, C4 meaning is not specified now. T09:12,28; CORE:868; LAW:223–248; DEC:1577–1583; R8:16. |
| P3 — approval representation/invalidation | Generic grants service/callback; no invalidation support; request-as-exact-approval plus narrow withdrawal | Owner envelope + never-reused approval ID binds the whole request; a pending-only owner withdrawal makes the selected stale-authority/reauthorization behavior real without C3 grant machinery. CORE:868–872; DEC:466–467; SPEC:609; WD:549–552. |
| P4 — workspace scope/bootstrap | All registered workspaces always blocked; caller-selected scope without proof; derive configured-map delta and cover legacy intents at bootstrap | One global law/policy epoch; exact affected set derived as §2.3, unconfigured workspaces unavailable. Bootstrap has no fake baseline record; no later legacy intent can enlarge scope. CORE:846,868–872; DEC:477–498; UC:456,466; R8:15. |
| P5 — identity/CAS revision | Last writer wins; request ID only; immutable semantic identity and actual last control seq | Request duplicate lookup precedes expensive/current-state checks; revision is actual latest control-record seq, including hold/withdrawal changes. Replacement one commit; explicit terminal answers, no occupant-by-ID cancellation. CORE:868; T09:28; SPEC:609; request.go:62–73. |
| P6 — timestamp representation | Local time/string order; unchecked UnixNano; explicit-offset checked signed UTC ns | Strict RFC3339 ns precision, reject unknown offset/overflow/past including equality; normalize only timestamp to the selected UTC identity. CORE:868; SPEC:587,609. |
| P7 — clock/wakeup | Recurring scheduler/polling; trust UUID/replay time; one derived timer plus trusted UTC floor | Detect unavailable/regressed samples, persist known observation floor in real controls, hold rather than bypass, explicit live wake on trust recovery. No external clock-attestation claim. CORE:868–872; T09:29; SPEC:609. |
| P8 — cross-workspace exclusion | Acquire every train lock; new coordinator mutex/store; existing short sequencer lock | Guard and append intents/holds/cutover under s.mu, Git/bodies outside. Existing intents drain independently; durable pending facts prevent races without serializing expensive work. CORE:870; DEC:560–563; service.go:239–263; R8:14. |
| P9 — durable hold representation | Volatile flag; one conflated blocked bit; request-owned hold-change record | Explicit due/clock/none transitions keyed to exact request; terminal/apply removes only its hold. Preserves unrelated unresolved-finalization fences and supports pre-due clock recovery. CORE:868–872; SPEC:609; RC:360. |
| P10 — switch and intent binding | Per-workspace pointers/copy full manifest into intents; one active record referenced by intent | Atomic manifest/epoch/effective sequence from actual envelope, actual observed UTC; one optional intent digest transitively binds complete tuple. No generation/evidence schema invented. CORE:864–872; UC:456–458; LAW:242–248; F8:98–108; R8:16. |
| P11 — replay/live restart | Auto-run from Open; discard overdue request; inert reconstruction plus explicit live control resume | Restore exact controls/holds and conservative recovery fence; let 08 reconcile effects; apply once only after live checks. Does not resume promotion/validation. CORE:872; RC:321,360; R8:27–28; F8:226–233. |
| P12 — record family | No durable records/ad hoc files; one polymorphic catch-all; five typed additions | Requested, hold_changed, ended, activated and approval_withdrawn, Appendix A. Specific records encode actual producers and no F4 placeholders; shape/names are **OG-F9 owner freeze choices**. CORE:868–872; CON:7–17,38; DEC:1643–1657. |
| P13 — actual metadata/compatibility | Predicted first/hash/self-hash; change appender contract; hydrate verified actual records | Read acknowledged request/activation commit envelopes and preserve actual First corrections; replay uses the same facts. One optional existing-intent key; old bytes untouched. Shape is **OG-F9**; implementation seam is advisor's. service.go:245–320; UC:456; LAW:242–248; CON:16–17; F8:98–108. |
| P14 — test/fault strategy | Mocks or cross-product matrices; one happy path; shared real histories with meaningful bounded rows | §4 proves each observable contract/crash transition without multiplying unrelated modes; fixed clocks, no sleeps or unproved OS-failure claims. SPEC:585–587,591–597,609; BUD:25–30; R8:30,34. |
| P15 — staging/process | Producer before freeze; docs each slice; record-free/contract/end-to-end/fault slices and one close | §5 follows D113/D116/D117, keeps each slice complete, makes the owner gate occur exactly at contract merge. DEC:1643–1657,1907–1926. |
| P16 — cost evidence | Silent test-budget expansion; new benchmark/SLA; report existing baseline plus actual new phase/test cost | No throughput claim from control tests, no skipping accepted cases. At >15m race return D122 to owner. DEC:571–574,2026–2034; BUD:25–30. |
| P17 — imports/dependencies | Reimplement law parser; extra policy library; consume existing frozen contract/law | One admitted contract edge, standard library otherwise; no new module and thus no D29 gate. If an implementation unexpectedly needs one, ask before adding it. DEC:121–133,1553–1557,1660–1669; LAW:265–269; ENV:4–9. |
| P18 — stale expected manifest | Silently rebase approval to current manifest; unrecorded-only stale error; exact recorded rejected outcome | Preserve exact expected hash; a structurally valid but stale expectation receives a durable rejected request outcome, never new authority. Unknown prior hashes refuse as invalid; known historical manifests permit a replayable stale rejection. Recheck again before live apply. CORE:868–872; SPEC:609; RC:360. |

### Source-gap/disagreement disposition

- D64–D69's “still open” mechanisms are superseded by B5/Core:868–872;
  their immutable-candidate wording is refined by D77's still-current generation
  rule (DEC:455–500,557–563). No new owner choice about scheduling/drain order.
- UC:388–399's manifest is a design sketch without concrete ledger types; the
  complete selected tuple and its envelope identity at UC:456, LAW:242–248
  control. P4/P10/P12/P13 supply concrete representation, not a new store.
- F2-08 intentionally omits policy/evidence bindings (F8:98–108; R8:16).
  P10/P13 add only the now-real active-manifest link; F4 remains deferred.
- Approval invalidation, local check/environment artifact formats, bootstrap,
  scope derivation, clock-trust signal and revision encoding are not concretely
  specified in cited source. P2–P7/P18 resolve them explicitly, with no
  grant/runner/schema placeholders.
- The earlier budget recommendation's pre-D122 540 s ceiling no longer governs;
  DEC:2026–2034 and BUD:27's post-answer 15m trigger do. No D42 question now.
- F2-08 is already owner-frozen (D123, F8:7–19), although base main's docs do not
  yet contain it; ticket 09 builds only after 08 closes, and must use those
  frozen bytes, not re-freeze them or revive the rejected canonical baseline/
  evidence placeholder/outcome-marker from ticket 08's old brief (R8:15–18,33).


## 7. Owner freeze path
**OG-F9 is the only anticipated owner stop.** Under D40/D113/D116 the drafter
prepares, on S2 after code/evidence/review:

- `.scratch/dwarf-harness/c2-evidence/f2-09-freeze-packet.md` (one or two
  pages): types, optional key, golden digest, retained-history/authority/clock/
  compatibility consequences, evidence table, owner options and question.
- `.scratch/dwarf-harness/c2-evidence/f2-09-freeze-evidence.md`: exact contract
  commit, Go documentation, V2/V3/V6–V9/V12 and full-check results, prior golden
  digests unchanged, new golden's committed SHA-256/LF, real consumer proof.
- Exact `D-NEXT`/register/packet-answer edits (advisor-reviewed) recording the
  owner's answer with its actual provenance. The number is allocated at append,
  not invented here.

Ask **after** S2 is built and evidenced/reviewed, **before** producer S3a writes
any F2-09 record: freeze these additions to ledger-format v1 as presented,
request specific changes, or hold. His freeze answer is the D41 sign-off for
the contract slice and its decision/register record reaching main. Freeze
packet/evidence/decision/register land with S2; ticket's other documents wait
for the one close commit. No design-approval question; no freeze approval
inferred from this proposal, D52 or ticket publication.
Sources: DEC:203–215,1643–1657,1907–1917,1920–1926; CON:7–17,38.

Packet consequences include: exact approved artifacts are permanently retained;
local check/environment bytes get identity but no runnable validation semantics;
the request is its exact owner approval and its pending approval can be
withdrawn; one pending revision-checked request; durable request-owned clock/due
holds; actual-time one-record colony switch; prior old-format mechanical logs
stay valid but new intents after F2-09 begins need a real active binding;
record hash/sequence comes from actual envelopes; replay never executes;
the product still answers no_validator. Future changes are additive or return
to the owner under D40/D41. D29 applies only if an unplanned dependency is
proposed; D52 only if approved behavior/availability would change. Neither is
permission to silently extend this ticket. Sources: CORE:868–872; LAW:242–269;
DEC:121–133,343–345,1532–1542; F8:98–108; SPEC:609.


## Appendix A. Proposed F2-09

### A.1 Ownership, compatibility, privacy and common encoding (P12,P13)

These are **proposed**, not frozen, additions to ledger-format version 1.
Only `internal/core/workspace`, Core C2's actual producer, may append them
through `appender.Appender`; permitted callers remain a review rule. C2 checks
the record rules at append and Open, not the codecs/Reader/EncodeCommit.
Consumers: Core's control/finalization projection and owner inspection; C3
for authorized controls/status/recovery; C4 for active policy/evidence binding;
U1.E for its later law activation consumption. A control is never accepted
delivery, field activity, permission to run checks or proof of engine readiness.
All payload fields are replay-essential. Local workspace IDs, approvals,
hashes, schedules and manifests are owner/host-private, not federation exports
or speculative agent output.
Sources: CON:7–17,30,38,108–116; LD:247–265,368–386;
LAW:242–269; UC:456–466; CORE:868–872.

Reuse existing payload codec helpers: compact JSON, emitted table order, errors
wrapping `ledger.ErrInvalid`, no missing required/repeated/null known members,
unknown keys ignored, re-encoding stable. UUIDs are canonical nonzero lowercase
UUIDv7; digest is a nonzero 64-lowercase-hex SHA-256. Optional scalars omit zero
in Go and refuse present zero/null. Integers `epoch`/revision/sequence are
1..MaxInt64; **UTC ns fields are signed int64** JSON decimal integers, no
fraction/exponent/null, zero and either sign permitted within range. Their
semantic ordering is a service rule. Use typed `int64` decoding, not float64
or the existing unsigned-only member helper; negative ns support must be real.
Sources: LD:257–265,379–386,579–584; CORE:868;
UC:456; SPEC:587,609. Bounds/codec choices are P6/P12.

`workspace_policies` is a required array, possibly empty (`[]`, never null),
of objects in the key order `workspace_id`, `check_policy_hash`,
`environment_policy_hash`, sorted strictly by UUID byte order, no duplicate ID.
`affected_workspace_ids` is a required possibly-empty array of UUIDv7 strings
in that same strict order. Codecs enforce element grammar/order/uniqueness;
registration, full-map meaning and scope derivation are record rules.
The artifact body set is the strictly sorted distinct union of global law,
validation-policy and every local check/environment digest. Zero bodies never
substitute for an empty map: the two global artifacts are always required.
Sources: CORE:868; UC:388–399,456; LAW:242–248; CON:30.

Use five new typed codecs, `TypePolicyActivationRequested`,
`TypePolicyActivationHoldChanged`, `TypePolicyActivationEnded`,
`TypePolicyActivated`, `TypePolicyApprovalWithdrawn`; corresponding Go payload
types omit `Type` and use normal PascalCase fields. `Defined()` adds exactly
their version-1 entries. The existing `FinalizationIntended` type gains its
one optional `ActivationRecordHash ledger.Digest`. No new package boundary,
anonymous JSON map as authority, upgrader or generic event union.
Sources: CON:7–17,38; DEC:1643–1657; F8:98–108.

### A.2 `workspace.policy_activation_requested` v1 (`PolicyActivationRequested`)

| Key, emitted order | Type / presence | Rule |
|---|---|---|
| `request_id` | UUIDv7 required | New activation request; also the eventual activation_id |
| `owner_approval_id` | UUIDv7 required | New exact owner approval, never reused |
| `field_law_sha256` | digest required | Exact retained frozen-law artifact |
| `validation_policy_hash` | digest required | Exact retained frozen-validation artifact |
| `workspace_policies` | array required | Full new local map, A.1 |
| `affected_workspace_ids` | array required | Derived scope, §2.3 |
| `expected_active_record_hash` | digest optional | Omitted means expected genesis/no active manifest, never a present zero digest |
| `schedule` | string required | Closed `immediate` or `not_before` |
| `admission_utc_ns` | signed integer required | Trusted live admission observation |
| `not_before_utc_ns` | signed integer required | Immediate equals admission; scheduled greater |
| `replaces_request_id` | UUIDv7 optional | Both replacement keys present or absent |
| `replaces_revision` | integer optional | Exact prior pending revision, 1..MaxInt64 |
| `pin_id` | UUIDv7 required | New permanent approval-artifact pin |

Record rules: actor owner; context/agent/session/turn/operation IDs absent;
body_refs equals A.1's exact union. Required body pin immediately follows with
same actor and body_refs, no context. The request is index 0 of a standalone
two-record request commit or index 1 after `ended/replaced`, with its pin at
index 2, exactly three records. Permanent approval pins never have an unpin.
ID and approval ID are new; the slot is empty after any required old ending.
All target workspace IDs were registered before this commit.
Sources: CORE:868; LAW:242–248; LD:293–308,379–386;
WD:549–552; DEC:466–481; T09:28.

Scope derivation uses the **named expected historical manifest** (or empty
genesis map), not an implicitly newer one. Law/policy change affects prior∪new
configured IDs; check/environment-only change affects the exact differing
entries. For bootstrap, additionally include every registered workspace with
an unresolved legacy intent at request admission; once this request appears,
no later unbound intent can be produced. Replay can derive that set from its
prefix without Git. The expected hash must name an earlier `policy_activated`
or be absent for genesis; unknown hashes refuse admission. A known but stale
expectation remains exact and produces `manifest_stale` rejection through the
live control path, not rebinding. The new request is the owner's durable exact
authorization, valid until its matching withdrawal or terminal outcome.
Sources: CORE:868–872; RC:360; UC:456; SPEC:609; F8:76–108.
These concrete genesis/scope/stale rules are P3/P4/P18, not additional authority.

For replacement, the earlier `ended/replaced` must name exactly the old request,
its request-record hash and current revision and this request as replacement.
The new request's two replacement keys name that same old request/revision.
There is never a second pending request after the commit. The initial pending
revision is this record's actual sequence; admission/hold/terminal state is not
an independently mutable counter. Repeated request IDs are inconsistent in the
log even if equal; command duplicate lookup appends nothing.
Sources: CORE:868; T09:28; SPEC:609; service.go:245–318.

### A.3 `workspace.policy_activation_hold_changed` v1 (`PolicyActivationHoldChanged`)

| Key, emitted order | Type / presence | Rule |
|---|---|---|
| `request_id` | UUIDv7 required | Current pending request |
| `activation_request_record_hash` | digest required | Actual earlier requested record hash |
| `hold` | string required | Closed `due`, `clock_untrusted`, `none` |
| `observed_utc_ns` | signed integer optional | Present exactly for due/none; absent for untrusted clock |

An optional signed ns cannot use a zero value as absence: represent with
`*int64`, so present 0 is valid. Other optional scalars retain A.1's zero rule.
Sources: CORE:868–870; SPEC:587,609; LD:379–386.

Record rules: core actor, no caller-context fields or body_refs; one-record
commit. Request/hash match the pending request; hold differs from its current
own hold. `due` requires known observation >= not-before and durable clock
floor. `none` requires a current clock-only hold and a known observation
>= floor but < not-before. A due hold never transitions to none/clock-only;
untrusted time leaves it due. `clock_untrusted` is appendable without inventing
an observed instant and always blocks the recorded affected set. Known
observations raise the durable clock floor; this record becomes the pending
revision. Replay checks those recorded relations, not the past real clock.
Producer checks the actual live clock and installs the hold before allowing
a new affected intent. Repeated identical observations append nothing.
Sources: CORE:870–872; RC:360; SPEC:609; T09:29–30.

### A.4 `workspace.policy_activation_ended` v1 (`PolicyActivationEnded`)

| Key, emitted order | Type / presence | Rule |
|---|---|---|
| `request_id` | UUIDv7 required | Pending request being ended |
| `activation_request_record_hash` | digest required | That exact request record |
| `expected_pending_revision` | integer required | Current revision before this ending |
| `outcome` | string required | Closed `cancelled`, `replaced`, `rejected` |
| `replacement_request_id` | UUIDv7 optional | Present exactly for replaced |
| `reason` | string optional | Present exactly for rejected: `authority_stale` or `manifest_stale` |

Record rules: owner for cancelled/replaced, core for rejected; all caller-context
fields/body_refs absent. Exact current pending ID/hash/revision; already
terminal requests cannot end again. Cancelled/rejected is one-record commit;
replaced is index 0 of the three-record group in A.2. Authority-stale rejection
requires this approval already withdrawn; manifest-stale requires its expected
hash/genesis differ from the current active identity. The producer emits
rejection at live eligibility processing; replay checks the recorded reason's
truth without consulting a clock or pretending the target ever activated.
After commit, remove exactly this request's hold and pending occupancy, retain
all its exact bytes/approval identity and other fences; terminal revision is
this ending's actual sequence. No cancellation or replacement can undo an
applied activation, rewrite prior records, end promotion requests or unpin
approved versions.
Sources: CORE:868–872; SPEC:609; T09:28–30; DEC:466–481.

Closed enums here have no historical unknown values: new values need an additive
new type version/optional representation under D40, not an unreviewed token.
This is intentionally distinct from F2-06's already-open promotion-failure
grammar; it does not close or change that frozen grammar.
Sources: CON:16–17; LD:529–547; DEC:203–207.

### A.5 `workspace.policy_activated` v1 (`PolicyActivated`)

| Key, emitted order | Type / presence | Rule |
|---|---|---|
| `activation_id` | UUIDv7 required | Exactly the pending request_id, no second generated ID |
| `epoch` | integer required | Previous active epoch +1, bootstrap 1 |
| `field_law_sha256` | digest required | Exact requested value |
| `validation_policy_hash` | digest required | Exact requested value |
| `workspace_policies` | array required | Exact full requested local map |
| `owner_approval_id` | UUIDv7 required | Exact unwithdrawn request approval |
| `activation_request_record_hash` | digest required | Actual requested record hash |
| `expected_active_record_hash` | digest optional | Same presence/value as request, and current prior active identity |
| `not_before_utc_ns` | signed integer required | Exact request value |
| `effective_utc_ns` | signed integer required | Trusted live transition sample, not backdated schedule |

`effective_sequence` and `activation_record_hash` are the actual envelope Seq
and Record.Hash, **not payload members**. The owner-facing typed view supplies
both from verified metadata. Required manifest bindings are therefore all
present without hashing a record into itself or guessing a sequencer number.
Sources: UC:388–399,456–458; LAW:242–248; CORE:870–872;
contract/ledger/envelope.go:67–85; contract/ledger/appender/appender.go:54–57.

Record rules: actor core, no caller-context fields; one-record commit;
body_refs equals the same approved target artifact union as the request, already
permanently pinned (no redundant new pin). Current pending request, exact
target/approval/request hash/schedule/expected-prior; current own hold is due;
effective UTC >= not-before and the durable clock floor; epoch advances once.
No unresolved intended finalization exists in any affected workspace. The
producer additionally requires trusted current time, intact verified artifact
bytes and completion of the affected live recovery phases; replay checks only
ledger facts, never a past process proof/body/clock.
Sources: CORE:868–872; CON:30; SPEC:609; F8:76–108,226–233.

The one commit wholly replaces the active target/identity/epoch, ends pending
as applied, raises the clock floor and removes only its activation hold.
No promotion result, lane dispatch or field event is emitted. Already accepted
history remains valid. Fresh validation/obsolete-child cleanup belong to C4
and do not delay this switch merely because old checks are running.
Sources: DEC:456–498,560–563; RC:328–330,610–614; LAW:265–269.

### A.6 `workspace.policy_approval_withdrawn` v1 (`PolicyApprovalWithdrawn`)

| Key, emitted order | Type / presence | Rule |
|---|---|---|
| `request_id` | UUIDv7 required | Current pending request only |
| `activation_request_record_hash` | digest required | Its actual requested record |
| `owner_approval_id` | UUIDv7 required | Exact approval being invalidated |

Record rules: owner actor; no caller-context fields/body_refs; one-record
commit. Request/hash/approval must match current pending and its approval be
valid. Its one invalidation makes the approval permanently unusable for that
request, and advances pending revision to this sequence, but does not itself
release the hold/slot, undo an active policy or end promotion work. The live
control path appends the durable authority-stale rejection in A.4. Duplicate
exact withdrawal returns current state with no record; applied/terminal
answers too-late/already-terminal and cannot invalidate historical activation.
Reapproval uses new IDs and its own exact request; old state never revives.
Sources: CORE:868–872; SPEC:609; DEC:463–467.

This concrete narrow invalidation record is P3's proposal for the unsupplied
approval-validity representation. It is not a generic C3 grant/revocation
schema or evidence that an unauthenticated actor is owner.
Sources: DEC:467; WD:549–552; CON:38.

### A.7 Additive intent key and shared record-rule checklist

Append `activation_record_hash` (optional digest) after all existing
`FinalizationIntended` keys. Codec accepts absent form unchanged; present zero,
null or malformed digest refuses. At service append and replay:

1. Before any F2-09 requested record, an absent key is valid under frozen F2-08.
2. A present key always names an earlier active record with a binding for that
   request's workspace; that record was current at this new intent.
3. After the first F2-09 request, each new intent requires the key, a real
   current manifest/local entry, and absence of any own activation hold affecting
   that workspace. Legacy already-intended effects are not invalidated.
4. `promotion_accepted` resolves and binds through its exact intent; it need
   not repeat the digest or consult a newer manifest. Old-target reconciliation
   remains possible while a pending activation is held.
5. No policy keys are added to generation/no-change/failure/admission records.
   Evidence/attempt bindings remain F4, not frozen placeholders.

Sources: F8:56–108,110–151,183–194; R8:16,23,29; CORE:864–872;
CON:16–17; UC:456. This is P10/P13.

Shared journal checks include actor/privacy-field discipline; new IDs and
permanent pins; registered/sorted workspace map; derived scope against the
named historical expected manifest; one pending slot; legal own-hold transitions;
exact request/approval/hash references; actual revision CAS; replacement group
atomicity; withdrawal permanence; rejection reason truth; no affected unresolved
intent at activation; exact target copies, prior identity/epoch/time; no duplicate
terminal/application; no unpin of any permanent approval pin; actual-record
metadata rather than payload/self-hash; conditional old/new intent binding.
The rule matrix mutates each independently from real closed-store prefixes.
Open runs at least one violation per new type/extended intent; remaining rows
exercise the same journalled rule through prefix replay, not private-field
assertions or handwritten mock projections.
Sources: CORE:868–872; SPEC:585–587,591–597,609; BUD:28–30;
service.go:320–339; F8:226–233.

### A.8 Golden layout and compatibility evidence (P12,P14)

One LF-only new golden:
`contract/ledger/testdata/f2/09/log/00000000000000000001.jsonl`.
Use standard deterministic golden UUIDv7/digest conventions, real frozen-law
fixture bytes as input identities, valid registration input bodies and SHA-1
Git IDs. No numeric fixture is the owner's actual chosen policy. Contract
tests additionally exercise SHA-256 Git IDs in the extended intent, signed ns
endpoints, an empty local map and malformed/unsupported future versions.
Never regenerate F0/F2-05/06/07/08 bytes to make F2-09 pass.
Sources: CON:7–17; LD:360–366,557–563; F8:258–265;
DEC:1587–1603.

The golden has 29 commits / 43 records; hash references are computed from
earlier actual fixture envelopes, never filler hashes or self-references:

| Commit | Sequences | Records / essential facts |
|---|---|---|
| c1 | 1–3 | W1 registration, inputs@1, pin |
| c2 | 4–6 | W2 registration, inputs@1, pin |
| c3 | 7–8 | A1 owner immediate requested at t1, expected genesis, W1/W2 target T1, pin |
| c4 | 9 | A1 hold due, observation >= t1 |
| c5 | 10 | A1 activated, epoch1, effective_sequence10, actual time t2>=t1 |
| c6 | 11–12 | A2 scheduled future T2, expected hash(seq10), fresh approval, pin |
| c7 | 13 | A2 clock_untrusted, no observed ns |
| c8 | 14 | A2 none, trusted time before its not-before |
| c9 | 15 | A2 due at its not-before |
| c10 | 16–18 | A2 replaced with expected revision15; A3 requested naming that CAS and expected hash10; A3 pin |
| c11 | 19 | A3 cancelled with expected revision17 |
| c12 | 20–21 | A4 immediate exact T1, new approval, expected hash10; pin |
| c13 | 22 | A4 due |
| c14 | 23 | A4 approval withdrawn |
| c15 | 24 | A4 rejected authority_stale, expected revision23 |
| c16 | 25–26 | A5 scheduled, same global law/policy as T1, only W1 check/environment changed; scope W1; expected hash10; pin |
| c17 | 27 | A5 due |
| c18 | 28 | A5 activated epoch2, actual time later than scheduled instant |
| c19 | 29–30 | A6 known-stale expected hash10, changed W2 local target; pin |
| c20 | 31 | A6 due |
| c21 | 32 | A6 rejected manifest_stale, expected revision31, current hash28 |
| c22 | 33–34 | A7 immediate, new global target T7 over hash28; pin |
| c23 | 35 | A7 due |
| c24 | 36 | A7 activated epoch3 |
| c25 | 37 | Dedicated scratch S for W1 |
| c26 | 38–39 | R admitted, immutable sealed tree and manifest pin |
| c27 | 40 | G derived over canonical B0/T0, no acceptance witness yet |
| c28 | 41 | Intent I names G and activation_record_hash(seq36), durably before the Git effect |
| c29 | 42–43 | Acceptance I and admission manifest unpin |

The separate intent/acceptance commits preserve the frozen producer order.
Sources: F8:98–108,110–151; CORE:866.

Choose nondecreasing trusted fixed timestamps across request admission,
hold observations and effective times; scheduled values remain strictly
future at their admission. A2→A3 replacement changes only its own hold;
A4 rejection demonstrates real approval invalidation; A6 demonstrates a known
stale prior. The final promotion uses actual already-frozen record shapes and
tests the optional binding without any F4 evidence fixture. Pin the SHA-256
of the completed committed golden in the existing golden test mechanism and
freeze evidence; do not invent its digest in this brief.
Sources: CORE:868–872; LAW:242–269; F8:98–108,258–265;
DEC:1907–1917; SPEC:609.

