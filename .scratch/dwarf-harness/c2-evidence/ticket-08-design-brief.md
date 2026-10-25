# Ticket 08 design brief — C2 finalization, cancellation and exact reconciliation

## 0. Owner summary
Ticket 08 builds the ordered finalization mechanism, request-specific cancellation,
conditional crash bookkeeping and genuine no-change, using the existing workspace
service, Git runner, reservation pool and colony ledger. It does not add a validator.
The product still refuses every new promotion before capture; only package tests in
disposable repositories exercise the new mechanism. These are not colony delivery.
Ref movement, a validation result and an intent are never acceptance.
An unfinished or uncertain effect blocks the workspace; recovery never retries Git.
Cancellation is for the submitting context or owner, and becomes too late at intent.
Acceptance/no-change preserve later scratch edits and do not close a scratch.
The design also completes success retention and the scratch's represented cursor.
It builds no policy activation, turn scheduler, launcher protocol, field engine,
hostile-process containment or power-loss guarantee.
**Owner gate OG-F8:** after the contract slice's evidence and advisor review, freeze
F2-08 by addition to ledger-format v1, before any code writes the new records.
The answer also supplies D41 sign-off for that contract slice and freeze record.
No design-approval question is asked; D117 gives that step to the advisor.
No new dependency or D52 change is proposed. A breaking contract change, new
dependency, changed approved boundary or check budget would need its separate
owner gate before use, not silent inclusion here.
Sources: T08:12,18-24,28-32; RC:289,303,326,339-347; DEC:1646-1650,
1907-1912,1921-1922; local://t08-design-assignment.md:13-31.


## 1. Sources, scope and owned paths
This is a proposal for the ticket's advisor, not an approved decision. Every **P**
below is an unsettled implementation choice; the ruling wins. Record shapes are
also subject to OG-F8. Source paths/lines are at assignment base 2fa3b79; ticket 07
S3's specified future behavior comes from its ruling/notes, not an assumed diff.

Citation key (all paths relative to `C:/Users/darius.jones/Documents/PROJECTS/dwarf-harness`):
- **T08** = `.scratch/dwarf-harness/issues/08-reconcile-finalization-and-cancellation-without-replaying-effects.md`.
- **RC** = `docs/ROADMAP-CORE.md`; **CORE** = `docs/DESIGN-CORE-AND-LAUNCHERS.md`;
  **DEC** = `docs/DECISIONS.md`; **LD** = `contract/ledger/doc.go`;
  **CON** = `docs/CONTRACTS.md`; **UC** = `docs/DESIGN-UNDERCURRENT.md`;
  **SPEC** = `.scratch/dwarf-harness/spec.md`; **WD** = `internal/core/workspace/doc.go`.
- **B6/R6** = `.scratch/dwarf-harness/c2-evidence/ticket-06-design-brief.md` /
  `ticket-06-design-ruling.md`; **R7** = `local://t07-ruling.md`;
  **N7** = `local://t07-s3-notes.md`; **AN** = `local://t07-notes-from-t06.md`.
- **probes** = `local://t08-git-probes.md`; **SUP** =
  `local://t08-code-supplement.md`. Citations `durable/<file>` mean
  `internal/core/durable/<file>`.
- Bare Go filenames below mean `internal/core/workspace/`; contract filenames
  always include their directory. These are source citations, not brief line numbers.

Owned code/test paths (P1; existing-file updates wherever the behavior already lives):
| Slice | Paths and exact purpose |
|---|---|
| S1 | New `finalize.go`, `finalize_test.go`, `finalize_windows_test.go`: record-free guarded-main/durability and exact ref classification; `train.go` extraction of its current per-workspace channel acquisition/release into one shared helper; corresponding `train_test.go` concurrency regressions. `git.go` only for the optional after-Start process-observation hook, preserving Start+Wait semantics/error handling; `git_test.go` real-process cancellation regression. |
| S2 | New `contract/ledger/finalization.go`, `finalization_test.go`, `finalization_fuzz_test.go`; extend `contract/ledger/promotion.go` only for additive keys/tokens, `catalogue.go`, `doc.go`, existing golden tests; new `contract/ledger/testdata/f2/08/log/00000000000000000001.jsonl`. Earlier golden files are read-only. |
| S3a | `finalize.go`, `request.go`, `service.go`, `register.go`, `train.go`, `scratch.go`, `errors.go`, `doc.go`; new `finalization_service_test.go`, extend `request_test.go`, `train_test.go`, `replay_test.go`, `scratch_test.go`, `helpers_test.go`: intent/acceptance/no-change, witness, represented cursor, retention, append/replay rules. |
| S3b | New `cancel.go`, `recovery.go`, `cancel_test.go`, `recovery_test.go`, `recovery_windows_test.go`; extend the same projection/service files and `promote_test.go`, `workload_test.go`: authority/cutoff, crash bookkeeping and native proof/costs. |

No changes to `go.mod`, `go.sum`, `tools/check`, `internal/core/durable`,
`internal/core/ledgerstore`, Router, Undercurrent code or launcher contracts.
Reuse `gitRunner.repository`, `mainTip`, generation-ref helpers, N7's tree-diff
helper, `appendLocked`'s undo journal and acknowledged slot release; no parallel
authority store, validator interface or repository maintenance. Contract-only
goldens and fixture data are not operational producers. Sources: T08:18,36;
AGENTS.md:37-40; train.go:15-110,183-347; service.go:218-267; integrate.go:111-143;
DEC:1934-1935; B6:342-348; N7:5,11-12.

**Ticket 07 integration dependency:** build starts only after 07 closes. S3 must
use its landed typed writer/tip/provenance/pin machinery, not recreate it.
Specifically N7:9-12 supplies closure policy, `scratchState`'s private tip,
observation/provenance retention and journal cases; these do not exist in their
final form at this base. Preserve its independent routing/merge-back locks and
frozen F2-07 semantics. Its unreachable `admit.go` branch is already assigned to
07 (N7:10), so 08 does not allocate that cleanup again. (Assignment:13-18;
R7:26-29; AN:8-9.)


## 2. Exact behavior and implementation layout

### 2.1 Serialized finalization and accepted witness
**One lock and one durable blocker (P2).** Extract `integrate`'s existing
`integrating[workspaceID]` channel loop into `lockTrain(ctx, workspaceID)`.
Integration, finalization, cancellation and promotion reconciliation acquire that
same context-bounded lock. Never hold `s.mu` across Git or a wait. Admissions may
append behind the active sequence, as today, but never alter its candidate.
An unresolved intent remains a projection-owned blocker after the call returns;
releasing the channel on an error is **not** releasing the finalization slot.
Integration/finalization refuse `finalization_pending` while that blocker remains.
Cancellation of other pre-intent requests may still order their removal; it cannot
resolve, replace or bypass the active intent. The finalization slot is this one
workspace publication obligation, not another pool permit; the request's K-slot is
separate and stays live until its terminal commit is acknowledged. (RC:320,326,347;
DEC:410-413,559; train.go:15-110; reserve.go:245-277; AN:8.)

**Canonical witness (P3).** Git reads do not create accepted work. F2-08 adds one
`workspace.canonical_anchored` baseline per workspace, then chains each acceptance
through `predecessor_witness_seq` to that baseline or the latest acceptance.
The baseline means the existing supported-workflow `main` at enrollment of this
mechanism, **not** a promotion or field effect. Initialize it only in the
unexported mechanism, under train/mutation ownership, with no prior F2-08 witness
or unresolved intent, after verifying the workspace and the observed commit/tree.
For an already derived leading generation, require that exact predecessor.
No Register/Open product path bootstraps a promotion; no baseline reanchoring.
Thereafter a different Git tip blocks, even if its tree matches. New generations
over canonical carry the optional witness key defined in Appendix A; older
generations retain their frozen rules. An existing speculative generation becomes
finalizable without rebuilding only when its exact predecessor commit/tree is the
latest durably accepted target. Resolve a no-change predecessor to its real witness,
not to its unaccepted derived commit. (RC:281,339,347; CORE:864,866,882;
DEC:1960; LD:495-505; AN:9; baseline schema choice P3.)

**Evidence boundary (P4).** `finalize(ctx, proof finalizationProof)` is unexported
and has no non-test caller in C2. The proof is the exact bound input to the
mechanism, not a validator or a `passed` switch. It identifies request/generation,
predecessor witness and commit/tree, target commit/tree, generation inputs revision
and integration rules, and one earlier durable evidence record by its containing
commit's first sequence, record sequence and verified envelope hash. It also
supplies that record's exact body_refs; no evidence payload format is imposed.
The intent stores the reference; the earlier record's hash binds all its immutable
contents, including revisions/attempts when supplied by their actual producer.
No F4 type, verdict, attempt schema, evidence body format or policy epoch is
invented here. C4 must decode and establish real, current, complete passing
evidence for precisely this tuple before it can supply the proof; recovery must
establish the same exact evidence, not reuse it for a new attempt.
In C2, only `_test.go` helpers derive these bound tuples from explicit
`fixture.finalization_evidence` records in a test catalogue; their payload has
no passing verdict and no required-check claim. They exercise frozen F2-08
reference bookkeeping, not F4 validation. Production code never recognizes
`fixture.` as evidence authority and contains no permissive verifier, callback
returning success, exported proof constructor, Config option or product seam.
The checks that C2 can perform are identity/currency, reference sequence/hash,
body presence/digest and retention; semantic validation/authority remains C4/C3.
(RC:289,311-313,524; CORE:844,864,866,874; DEC:342,1934;
R6:13,26; CON:34; contract/ledger/catalogue.go:41-46.)

Exact Core-internal Go inputs/results (P4,P8,P15,P16; no additional contract):
```go
type finalizationProof struct {
    RequestID, GenerationID uuid.UUID
    PredecessorWitnessSeq uint64
    PredecessorCommit, PredecessorTree, TargetCommit, TargetTree string
    InputsRevision int64
    IntegrationRules string
    EvidenceCommitFirst uint64
    EvidenceSeq uint64
    EvidenceHash ledger.Digest
    EvidenceBodies []ledger.Digest
}
type waitedWriter struct { PID int; State *os.ProcessState }
type writerQuiescence struct {
    WorkspaceID uuid.UUID
    DrainedService *Service
    PriorCore *waitedWriter
    PriorGit []waitedWriter
}
type recoveryProof struct {
    WorkspaceID uuid.UUID
    Writers *writerQuiescence
    Evidence *finalizationProof
}
type PromotionRecovery struct {
    Interrupted, Accepted int
    Pending []string
}
```
An input is not durable evidence authority. The trusted mechanistic caller
must establish its full semantic prerequisite; C2 verifies the tuple against
admission/generation/witness and the immutable reference/body set. No non-test
C2 caller supplies any of these. Evidence nil is allowed only when there is no
unfinished ref-changing intent, never as a no-validation acceptance fallback.
Source for separation: CORE:850,864,866,874; RC:289,311-313;
SUP:3592-3676; record Hash is contract/ledger/envelope.go:82-85.

`RequestState` keeps known states pending/conflict/dependency_failed and adds
finalizing/accepted/no_change/cancelled/interrupted plus unknown_failure.
Add `FailureOutcome string` to preserve an unknown PromotionFailed's exact token
when State is unknown_failure. Store terminal **record kind**, not just outcome
text: every PromotionFailed fails lineage, including an unknown token literally
"accepted" or "no_change"; only the two new success record types succeed.
Unmarked historical cancelled/interrupted stay unknown_failure under P21,
not newly authenticated cancellations. This internal Go projection clarification
changes no ledger bytes or F2 record validity; update the existing unknown-failure
query regression to prove no successor/success/field witness emerges, not pin
wording. (LD:529-547; request.go:43-48,376-416; R6:33; P8,P21.)

Resolve the opaque reference with
`ledger.OpenReader(..., ReadOptions{Colony: store.Colony(),
After: EvidenceCommitFirst-1, Through: store.Durable(), AllTypes:true})`.
Require the returned complete commit's First equals EvidenceCommitFirst, contains
EvidenceSeq, and that record's exact Hash/actor/context/body_refs match.
Do not use After=EvidenceSeq-1: that cursor can lie inside a commit and is refused.
The extra first-sequence locator avoids an all-history scan or an unbounded
new envelope index and imposes no layout on F4's records. Replay uses the same
bounded-to-segment lookup, without reading evidence bodies or foreign payloads.
(contract/ledger/reader.go:23-35,54-92,197-206; CORE:840,866; P4,P17,P20.)


**Ordered ref-changing sequence (P5–P7).**
1. Acquire a service operation and the train lock. Check service usability,
   leading live request, open dedicated scratch, current clean generation,
   successful local parent, exact witness, actual main commit/tree and target
   tuple. Check workspace/Git/pinned inputs and D48. **Before requiring any
   evidence reference**, tree equality dispatches to noChangeLocked (§2.4);
   it ignores Evidence* fields and produces no check/intent/acceptance.
   Otherwise verify the complete earlier evidence commit/record/hash, original
   core context and exact body set through the durable-bounded reader, then
   verify referenced bodies through the real store. D48 is repeated immediately
   before canonical mutation; ref-changing proof requires all Evidence* fields.
2. Precompute the full predecessor-tree→target-tree path set using N7's
   NUL-safe no-renames tree-diff helper (deletions and both rename names included),
   preserving admission's immutable observation/merge-back provenance by reference.
   Preflight the encoded intent+pin and eventual acceptance+unpins against actual
   envelope/commit byte limits, with no truncation/chunking. A `pathset_cap`
   refusal occurs **before intent**, never after Git because the result is too big.
3. Durably append `finalization_intended`, immediately followed by its evidence
   body pin when body_refs is nonempty. This acknowledgment commits the cutoff,
   sets the request `finalizing`, and owns the workspace blocker. An uncertain
   intent append poisons the service and permits **no Git call**.
4. Under mutation ownership, verify the retained target commit/tree and its sole
   parent == expected old commit; invoke one guarded fast-forward `main` CAS with
   the selected durability recipe (§2.3). Its exit/flush verification must finish
   before acceptance. Never choose a different target, use a scratch branch tip,
   rerun integration/checks or retry `update-ref` after an ambiguous outcome.
5. Durably append `promotion_accepted`, then the admission-manifest unpin and
   the intent evidence-pin unpin (when present), in that order. The result binds
   exactly the intent and actual predecessor→target path set. This is the sole
   accepted-work witness. Apply advances the canonical witness and represented
   cursor; sequence fields become `Committed.First + index` after acknowledgment.
6. Only now return the K-slot once, clear the durable blocker, and release the
   train lock. Release unneeded Git refs by recorded-object CAS after the ack;
   failed deletion waits for Open. An acknowledgment before a crash already
   ends the request; replay restores slot counts from live records, not a saved
   decrement. No second acceptance or result application on repeated recovery.
(T08:28; RC:326,339,347; DEC:410-414,559,678; CORE:866,882;
SPEC:55,607; train.go:224-291; service.go:218-246; AN:9; N7:5,12.)

**Proof versus effect.** The accepted target is `generation.derived_tree`, never
the original sealed submission or later private tip. B's delivered delta is
`(M+A)→(M+A+B)`, not `M→(M+A+B)`. `RequestState` adds only coarse states
`finalizing`, `accepted`, `no_change`, `cancelled`, `interrupted`, plus the explicit
unknown_failure projection described above; it does not expose foreign
predecessors, private diagnostics or proof bodies. Failure/success discrimination
is by terminal record kind, never by outcome text; every PromotionFailed fails
lineage, even if its unknown token spells a success. Same-ID lookup returns its
original durable state with no recapture, even after closure/restart.
Do not invent a durable `ready` event; readiness is C4's current bound evidence.
(CORE:850,856,860,880-882; DEC:561-562; LD:518-547; request.go:25-94,208-477;
RC:593; R6:16,33; P8.)


### 2.2 Cancellation authority and cutoff
**API (P9).** Add `CancelPromotion(ctx, Cancellation) (CancellationResult, error)`,
where `Cancellation{RequestID uuid.UUID, Actor ledger.Actor, ContextID uuid.UUID}`.
`CancellationResult{Outcome string, State RequestState}` has only `cancelled`,
`too_late` or `already_terminal`. This is an internal Go service API, not a
launcher wire/command receipt contract; no command ID or authentication store is
added. C3 authenticates the caller exactly as for Request and Closure today.
(RC:324,448,450; CORE:298; DEC:1814; request.go:14-23; scratch.go:209-215.)

Check service usable, UUIDv7 request ID and actor owner/agent (agent requires a
UUIDv7 ContextID; owner may omit it), admitted request exists (`ErrUnknownRequest`),
then authority: agent's ContextID must equal the original admission ContextID;
supervisory role, agent identity, knowledge of ID or a view selection grants
nothing. Reject wrong binding before returning any request result. Acquire the
shared train lock and repeat usability/authority/state checks.
- An intact intent for this request, or its acceptance, answers `too_late`, with
  no record and no abort, even when `main` remains old. This is not acceptance.
- An already cancelled request returns `cancelled` without another append; another
  terminal pre-intent result returns `already_terminal`, never reopens it.
- Otherwise append one whole-lineage failure commit through the generalized
  `endingDrafts`: the target `promotion_failed(cancelled)` uses the authorized
  owner/agent actor with the envelope's **original request context**, then live
  higher checkpoints end `dependency_failed` as core in checkpoint order.
  Manifest unpins follow all endings in that same order; reports remain pinned.
  Only acknowledgment frees each K-slot once. Uncertain append poisons and keeps
  obligations for replay, so no losing cancellation can slip a Git update through.
  A request being captured but not yet durably admitted has no cancellable ID;
  C3's command receipt layer owns that race, not a new C2 pre-admission tombstone.
(T08:29; RC:324,347,356; DEC:391-394,411; CORE:860; LD:535-547;
train.go:193-291; service.go:218-246; P9–P10.)

The channel defines serialization, not arrival wall time: a command waiting behind
a finalizer whose intent commits has lost. Holding the channel across the intent
ack prevents cancellation winning between record and Git. A cancelled local parent
ends its live suffix; foreign survivors are invalidated/rebuilt by `integrate`,
never automatically executed by cancel. None of normal turn finish, `turn.cancel`,
writer Close, view close/disconnect, scratch edits or supersession calls this API.
C2 has no validation children. C4 adds actual attempt invalidation/positive stop
before any resource reuse; a terminal outcome cannot release a still-owned child,
lane or directory. Ticket 08 neither pretends to stop nonexistent checks nor adds
a stand-in child manager. (RC:323-330,448,602,605; CORE:860;
DEC:380,391,487; B6:769; R7:46; P10.)


### 2.3 Crash reconciliation and fencing boundary
**Record-free durability recipe (P14).** Add `guardedMainUpdate` and
`hardenCanonicalStorage` to `finalize.go`; imports add
`internal/core/durable` explicitly (D45 permits Core's own tree, no new module).
Do not copy Win32/POSIX adapters or change the durable package.
Support finalization only when `rev-parse --show-ref-format` is exactly `files`;
other backends return `UnavailableError{Reason:"ref_backend_unavailable"}`
**before intent**. Registration/observation/admission are not newly restricted.
Git 2.45's files backend supports loose and packed refs; reftable is not assigned
a speculative durability recipe. Source for this choice: DEC:414,1740;
AGENTS.md:37-40; durable/durable.go:1-24; probes:1252-1296.

Under the shared train guard and supported exclusive Core mutation ownership:
- Verify direct (not symbolic) refs/heads/main with
  `symbolic-ref -q --end-of-options refs/heads/main` (exit 1 means direct,
  exit 0 refuses), main's actual commit/tree and no checked-out main
  using existing `listWorktrees`/parser. Verify `<target>^{tree}` equals target_tree,
  `<target>^1` equals old and `<target>^2` has no resolution with the existing
  rev-parse --verify/scalar-OID handling: exact sole-parent fast-forward, no new
  commit-header parser. Missing objects/refusals never produce a partial proof.
- Keep existing capture/integration creation under pinned
  `core.fsync=committed`, `core.fsyncMethod=fsync`. For **canonical CAS only** pass
  the explicit last override `-c core.fsync=objects,reference` and
  `-c core.fsyncMethod=fsync` in the repository environment, then
  `update-ref --no-deref --end-of-options refs/heads/main <target> <old>`.
  Use the runner's normal Git error handling; do not parse stderr to decide CAS
  success, retry lock errors or accept a bad exit as a non-promotion proof.
- After the one CAS returns, establish storage completion. Validate with Lstat
  that every directory/file to flush is the expected real directory/regular file,
  not a link/reparse/other kind. `SyncDir` itself does not validate a directory.
  Sync existing real two-hex object directories (at most 256), the objects/pack
  directory if present, and objects, child before parent. The files written by
  capture/generation Git are already individually fsynced under the pinned
  creation recipe; these directory flushes establish their name publication.
  Existing baseline/pack contents are the intact-storage prerequisite, not a
  new repair/repack policy; concurrent owner gc/repack is unsupported.
  Open the post-CAS regular loose main with os.OpenFile(path, os.O_RDWR, 0),
  no create/truncate, verify f.Stat against the Lstat identity, Sync and Close,
  then durable.SyncDir on refs/heads, refs and the verified common directory.
  A successful CAS over an initially packed main creates this loose file.
  Recovery at an intended tip may find main packed: likewise open/sync/close
  the verified regular packed-refs file O_RDWR and flush common directory,
  instead of moving/recreating the ref. No readonly-handle FlushFileBuffers.
- Reread actual main and require exactly the intended commit/tree. Any missing/
  changed path, backend change, open/sync/close error or unexpected tip holds the
  intent without acceptance. Filesystem disappearance is not silently ignored,
  nor a nil directory flush treated as hostile containment. Do not flush or
  remove a foreign main.lock. No ref mutation occurs during storage-only recovery.
(DEC:410,414; WD:42-57,137-144; worktree.go:14-45;
durable/durable_windows.go:60-78; durable/durable.go:5-24;
local://t08-git-probes.md:815-831,1284-1296; P14.)

**Observed facts, not inferred durability:** on installed Git 2.55, explicit
objects,reference and committed both yielded hardware-flush counters for objects
and refs, including initially packed main. Git flushes the lock/temp ref **before
rename**; this is why directory hardening is added. The 2.45 mapping was verified
by tagged source, not by running that version. Bad fsync options merely warn with
exit 0, so use exact constants, not user-supplied components/fallbacks.
SyncDir succeeded on these NTFS Git directories and long paths; no power-loss test
was run. These calls establish the selected flush protocol conditional on intact
storage/honored flushes, not atomic Git+ledger, power-loss resilience or a generic
filesystem/storage qualification. Linux/macOS runtime proof remains actual CI/
platform evidence, not cross-OS vet. (probes:815-831,1284-1296;
durable/durable.go:22-24; DEC:414; RC:347,411; P14,P18.)

**Writer prerequisites (P15).** The current train guard and one host-owned colony
store establish cooperative Core serialization, not an OS fence on the repository.
Never infer previous Git death from a newly obtained store lock, a PID that no
longer appears, a timeout, old `main`, or a dead Core. A synchronous owned Git
call returns after waiting for its direct process; it does not prove all hostile
descendants stopped. Before recovery the trusted host must positively prove the
known previous Core/Git writers stopped, or provide its later C10 fence, and that
no later sequence passed the unfinished intent.
The mechanistic caller provides that proof explicitly; no exported boolean
“fenced” switch/default true/no-op callback is added. In C2 only package fixtures
own and wait the real prior helper/Git processes, or close/drain their own prior
Service, and invoke the conditional reconciliation mechanism. Complete tracking
of crashed arbitrary child trees and boot/process identity is C3/C10's producer
work, not an invented process registry or F3 record here. Absent proof always
returns `UnavailableError{Reason:"writer_unfenced"}` and retains all obligations.
(RC:339,409,930,949,956,959; CORE:251,866; DEC:412-414;
service.go:45-47,187-200; P15.)

SUP confirms the gap: the colony lock is not inherited by Git and
ledgerstore.Open's Recovery reports only torn-byte truncation, not prior child
exit (SUP:592,655-677). The only start site is git.go:112 and there is no PID/job/
child registry; WaitDelay/default Cancel wait/kill only the direct process, not
its descendants (SUP:948-950,1073-1075,1695-1765,1910-1911).
Therefore `writerQuiescence` has no public/default constructor and no claimed
PID-only proof. Validate WorkspaceID, then exactly one proof form:
DrainedService is a distinct prior service of the same colony/workspace whose
Close has returned (closeDone signaled, all operations/writers drained), **or**
PriorCore is a real tracked helper process with a completed Wait result and
PriorGit is the complete known set of its actual Git writers, each with its
completed Wait result. In waitedWriter, PID came from the captured process at
Start, is positive and equals State.Pid(); nonnil State comes from Wait even if
it reports a killed/nonzero exit. Do not use State.Exited() as death proof:
signal termination is also a completed wait. The host must know that its list
is complete; C2 cannot discover arbitrary lost descendants. Package fixtures
construct only from their own observed handles; nil/mismatched/live/missing
known writer proof refuses. This conditional input is not C10 fencing or a
future child's stand-in. The C3/C10 production builder remains their work and
no stub for it is included. (CORE:866; RC:339,959; SUP:1695-1765; P15.)


**Recovery API and Open (P16).** `reconcilePromotions(ctx, workspaceID,
proof recoveryProof) (PromotionRecovery, error)` is unexported, reached only
by package tests before C4. `recoveryProof` carries workspace identity,
positive known-prior-writer quiescence evidence and the bound evidence tuple for
the unresolved intent if any; it is not a new persistent schema or authority
store. `PromotionRecovery` carries only counts Interrupted/Accepted and Pending
reason/intent IDs for host inspection, not foreign context-visible details.
Open remains record-free/clock-free: replay blockers, live slots, witness and
represented cursor; retain their objects/pins, run the existing safe filesystem
sweeps, report `finalization_pending <intent ID>` / `promotion_recovery_pending
<workspace ID>`. A workspace reopened with live requests cannot finalize or
integrate before this bookkeeping phase resolves it; it may receive explicit
authorized cancellation of a pre-intent request. (WD:414-420; DEC:1847,1951;
R6:30; RC:321,339-347; DEC:371; P16.)

Acquire service operation and shared train guard; verify usable repository, colony
marker, pinned Git version, exact generation/intent/evidence/body refs, current
canonical witness, no later durable intent and positive old-writer proof.
Preserve the old record's input bindings, not the current mutable scratch/index/
policy files. Existing durable acceptance is never appended/applied again.
Then apply **only** the mapping below:

| Intact proven history / actual ref | Result |
|---|---|
| No durable intent for a live queued/speculative request, prior writers stopped | Proven non-promotion under intent-before-effect: interrupted, no capture/check/merge/CAS; local live suffix dependency_failed. |
| Unfinished intent, old predecessor commit/tree | promotion_failed(interrupted, matching intent_id); whole suffix and ordered manifest/evidence unpins; no Git retry. |
| Unfinished intent, exact intended commit/tree | Finish storage-only durability/verify, recompute and require exact recorded changed_paths, append the missing identical acceptance commit; no update-ref/check/merge/capture. |
| Existing durable acceptance for intent | No second acceptance; restore/release derived obligations from replay. If actual ref mismatches current witness, block new publication rather than rewrite history. |
| Absent/third ref, bad objects, incomplete/mismatching evidence, unknown prior writer, later intent or durability error | No inferred outcome or terminal uncertain token; keep request/slot/intent/evidence/ref obligations and publication block. Ledger contradictions fail Open; unavailable external prerequisites return Pending/error. |

Process intents first in each workspace, then pre-intent live requests in admission
order through the same whole-suffix failure path. Resolve accepted/no-change
local ancestry without changing independent request IDs. A workspace with an
unresolved effect stays blocked; other workspaces may reconcile independently.
Queued requests have no automatic execution restart even after their predecessor
is reconciled accepted. Hosts schedule this finite bookkeeping phase on live
restart, not inside historical replay. D37's unmatched operation interrupted ends
remain C3's separate facts; a synthetic operation-ended type is not added, and
neither an interrupted operation nor too-late cancellation substitutes for request
effect reconciliation. (DEC:371-375,410-414,562; RC:321,339-347,440;
CORE:866,874; UC:625-626; P7,P16.)


### 2.4 Actual-predecessor no-change
`noChange(ctx, requestID, predecessorWitness) (RequestState, error)` is unexported,
with no product caller before C4. It acquires the train guard, then shares
`noChangeLocked` with finalize's mandatory same-tree dispatch **before any
evidence/check requirement**; the locked helper never reacquires the channel.
No-change needs real validator availability at the product layer, but no passing
evidence or false attempt in its record. (T08:31-32;
RC:334,339,615; DEC:511-514; P11.)

Under the train lock require the leading current clean generation, resolved
successful local parent and current accepted/baseline witness. Read verified
`main`; its commit/tree must equal that witness and the generation's predecessor.
Compare **trees**, not commit IDs, captures, scratch HEAD or speculative parents.
Equal trees durably append `promotion_no_change` and its admission unpin.
No intent, evidence pin, required check, canonical mutation, acceptance or field source.
The result retains its distinct request/generation IDs and the actual witness;
representation advances to that request's sealed local tree, preserving later
edits and history. K-slot release is after the acknowledged ending, as for success.
(RC:334,339,615; CORE:860,882; DEC:511-512,561; B6:222; UC:626.)

For A accepted, downstream generations whose exact predecessor commit stays
current are preserved. For A no-change with a different derived commit, B's
generation over that unaccepted commit is stale: rebuild against the real accepted
anchor, even if trees coincide, then reconsider B. If speculative A is removed,
rebuild B without it; do not terminalize speculative redundancy. A removed local
parent instead fails B's lineage. Distinct IDs with the same content each get their
own no-change result, never coalesce. (CORE:860,864,882; DEC:561-562;
RC:615; B6:246; train.go:72-105; P11.)


### 2.5 Retention, represented trees and C4 refusal
**Represented cursor (P12).** Add to dedicated `scratchState` a represented
request ID and tree, initially zero/AnchorTree. Acceptance and proven no-change
advance it in acknowledged local-checkpoint order to the **admission.SealedTree**,
not the cumulative derived tree. The latter includes foreign work absent from
this scratch; substituting it would make closure wrong and resurrect a foreign
delta on restart. `Scratch.BaseCommit`, `AnchorTree`, private acknowledged tip,
branches, actual files/index, admission provenance and existing captures never
change. A new root after failure uses this represented tree; a successor still
uses its latest unfailed admitted parent's sealed tree. Closing a dedicated scratch
compares a full host observation against the represented tree, with trusted names
including immutable anchor, current private tip and represented tree so recreated
tracked paths under ignore rules remain visible. All N7 closure safeguards/pins
remain. Acceptance never automatically records `scratch_closed`, adds a closure
reason or emits “base advanced.” Later edits still refuse closure.
(AN:9; LD:423-430,636-644; CORE:854,858,860; RC:303; R7:27;
N7:5,9; B6:222; P12.)

**Capture retention (P13).** Extend `retainedRefs`' projection query, not a second
ownership map: retain a capture while (a) its request is live, (b) a live child's
parent is it, (c) it is an open dedicated scratch's unfailed head **including
accepted/no-change**, or (d) it is that open scratch's represented request.
Rule (d) is necessary after a newer head fails: the earlier represented local tree
can differ from canonical and is needed for an explicit new root and closure.
The original anchor ref suffices before the first representation advance.
Current live clean generations, including an unfinished intent's exact generation,
remain retained. Accepted generations need no private generation ref once canonical
retains their commit; no-change drops its generation ref after acknowledgement.
Intent evidence pins remain until its terminal outcome, including unresolved
uncertainty; no-change creates none. Existing report pins are never released by
success/cancel/interruption; scratch closure/supersession owns them.
Open restores these capture/generation obligations with existing CAS sweep and
never overwrites a moved ref. Preserve N7's scratch-commit/provenance retention.
(B6:304-308; R6:27; AN:9; WD:404-421; CORE:860,882; N7:11; P13.)

**Product refusal.** Leave `RequestPromotion`'s unconditional `no_validator`
path untouched: new IDs capture/record/finalize nothing; same admitted synthetic
ID retrieves only its original bound result. No exported method, observer, owner
approval or config option admits/finalizes/accepts synthetic work.
S3's mechanistic acceptance records occur only in disposable package fixtures;
they are not connected to field consumers or a product execution loop.
C3/C4 still own passive authorized disclosure and the post-promotion observer.
(T08:32; RC:289,336,446,513; CORE:203,207,882; DEC:1946;
WD:354-360; R6:13; R7:46; P1.)


## 3. F2-08 records and replay
**F2-08 is required (P6).** Four new version-1 types:
`workspace.canonical_anchored`, `workspace.finalization_intended`,
`workspace.promotion_accepted`, `workspace.promotion_no_change`; optional
`predecessor_witness_seq` on `generation_derived`; optional `intent_id` and
`outcome_rules` on `promotion_failed`; and the already-open failure tokens
`cancelled`, `interrupted`. The marker is P21's compatibility discriminator.
No “blocked” record is needed: a durable unfinished intent is the block.
No acceptance is encoded as `promotion_failed`, whose every token fails lineage.
No `ready`, check-pass, validation-attempt, child-operation or activation
placeholder is added. Shapes/rules/goldens are Appendix A, proposed to OG-F8.
(DEC:1646-1650,1935; LD:518-547; CON:34,38; B6:398; AN:8; P6.)

| Operation | Commit shape (unrelated Core records may precede/follow; no fixed index) | Actor / envelope context |
|---|---|---|
| First mechanical canonical baseline | `canonical_anchored` | core / absent context |
| Intent | `finalization_intended`; immediate `body_pin` only when evidence has body_refs | core / original request context |
| Acceptance, normal or reconciled | `promotion_accepted`; admission-manifest `body_unpin`; intent-evidence `body_unpin` if present | core / original request context |
| Proven no-change | `promotion_no_change`; admission-manifest `body_unpin` | core / original request context |
| Cancellation | target `promotion_failed(cancelled)`; suffix `dependency_failed` in checkpoint order; manifests' unpins in ending order | authorized owner/agent for target, core for descendants; each record's original context |
| Crash-proven non-promotion | target `promotion_failed(interrupted)`; suffix `dependency_failed`; manifest unpins in ending order; intent-evidence unpin if target had an intent | core / each original context |
| Uncertainty, late cancel, authority/binding refusal | none; retain unresolved obligation | none |

Use existing encode/decode/member helpers, `Defined`, envelope limits and actual
`ledgerstore.Store` APIs. Extend `workspaceConsumption`, `applyRequestRecord`
and the same commit-local undo journal used at append/Open; return
`InconsistentError` with the offending actual sequence on contradictions.
Split commit bookkeeping into **all terminal results** (ordered manifest unpins,
train removal/live count) and **lineage failures only** (whole higher-checkpoint
suffix check). Success may leave children live; an unknown future failure cannot.
Track one current canonical witness and one unresolved intent per workspace;
request identity history and intent IDs remain never-reused facts. Keep completed
intent/result references sufficient for historical witness joins; do not keep
validation bodies or historical full generations in RAM. Resolve historical record
sequence/hash through `ledger.OpenReader` when needed.
Correct canonical/intent/result sequence fields after ack exactly as current
`inputsSeq` and N7 observation/notice sequence fields; never persist a guessed
`Durable()+1` as a downstream reference. (service.go:218-267;
request.go:166-206,331-477; N7:12; LD:374-377; P8,P17.)

**Compatibility (P17).** New rules are conditional on F2-08 records/keys.
All F0/F2-05/F2-06/F2-07 bytes and previously valid logs remain valid.
Before its first baseline a workspace retains F2-06's historical-main two-halves
rule; after it, new canonical generations must name the exact witness. Historical
generations derived before that baseline can finalize only with the explicit
F2-08 witness checks. Add pointer sentences to old catalogue sections, not revised
old invariants. Open checks durable record facts without Git/evidence body reads
for validity; live reconciliation performs conditional evidence/storage checks.
Unknown `promotion_failed` tokens retain the existing broad decoder grammar and
lineage-failure replay semantics; do **not** tighten decoder constraints for old
`cancelled`/`interrupted` payloads previously legal as unknown tokens. New
producer records carry `outcome_rules:"promotion-outcomes/1"` so their authority/
optional-ID rules are enforceable at append **and** Open without tightening old
unmarked histories (P21). An intent_id must carry that marker. All old legal
unknown-token samples retain their historical semantics.
(LD:529-547; DEC:1934-1935,1992; R6:26-29; contract/ledger/promotion.go:231-264;
P17; unknown-token compatibility is specifically an OG-F8 packet point.)


## 4. Regression tests
Tests are written before their code, package `workspace`, actual Git and real
`ledgerstore.Store` in `t.TempDir()`. No Git/store/validator mock, no source-text
or forwarding assertions. Missing/too-old Git fails the ordinary mechanic tests.
Use the existing matrix pattern: one immutable Git history per matrix, isolated
per-row repositories/stores/mutable refs, `t.Parallel()` first in each new top-level
test and fixture-owning row. Run Go test commands serially. Channels/seams gate
observations; never sleeps/duration thresholds. (RC:15; T08:36; SPEC:585,587;
DEC:1963-1965; assignment:28-31; N7:15,18; P18.)

Hooks are unexported scheduling boundaries, not substitute effects:
beforeIntentAppend, afterIntentAck, afterMainCAS, afterGitDurability,
beforeAcceptanceAppend, afterAcceptanceAck, beforeSlotRelease and
`gitRunner.afterStart func(*exec.Cmd)` for positive observation of a real process.
Each hook permits a parent process to stop/kill a real helper at that exact
boundary, or perform a genuine competing command/close a real store/hold a real
file handle. Production defaults do nothing; hooks never manufacture evidence,
successful mutations, store outcomes or stopped children. Reuse existing
beforeAppend and deterministic dependency patterns. (service.go:29-37;
SPEC:587; RC:606; N7:15; P18.)
The afterStart hook requires replacing cmd.Run with its exact Start-then-Wait
equivalent, with the same GitError/ctx/expected-exit rules; on Start failure
there is no hook/Wait. It exposes no product child manager. Only test fixtures
filter the actual canonical command, retain the observed child handle or open
its Windows handle before killing the helper, and positively wait it. This
supports the “during Git” row without assuming a dead parent killed its child.
Reuse TestHelperScratchCrash's real process/pipe handshake, but unlike that old
test do not claim a Git child is absent when it is actually running.
(git.go:108-145; SUP:2821-2850,3053,1695-1765; P15,P18.)
Crash-tail cases use **only** a real store: after a process/Close releases it,
truncate the final commit after its first valid LF line (or inside its final
line), using the documented segment layout; ledgerstore.Open must report the
torn bytes and discard that entire incomplete commit, while complete committed
bytes remain. No arbitrary corrupt/invalid tail is classified as a recoverable
append. This is a finite disk-tail drill, not a claim that killing a process
always lands during a write. Private store fault hooks are unreachable here.
For actual ErrUncertain/poison use P22's native lock; for a real commit whose
acknowledgment is hidden, use only the already-approved response-loss seam,
never a fabricated Git/store effect. (ledgerstore/store.go:146-154,216-220;
LD:99-128; SUP:1919-1933; service_test.go:251-311; P18,P22.)
**Uncertain-return proof (P22).** Add unexported
`serviceDeps.beforeStoreAppend func([]ledger.Draft)` immediately after
apply's validation and before the real Store.Append while s.mu still excludes
observers. Native lock injection there cannot be accidentally intercepted by
the evidence reader: locking a segment also blocks readers. In a disposable
Windows test, open the active segment through a second real handle, take an
exclusive LockFileEx range from its current size through the next commit range
(not byte 0), then let the actual append run. It must return real ErrUncertain,
the service poisons/retains obligations, and a later call does no work. Release
the range/handle **before** reopening; Open then decides the absent commit and
its durable sequence. Do not assume Recover succeeds only after the cause ends:
the probe showed Recover can clear poison while the lock is still held.
(service.go:218-246; probes:1822-1834; P22.)

For the retained-return variant, arm the **existing** uncertainStore with
persist=true only at the targeted intent or acceptance append. It calls the
real Store.Append, leaving its actual complete/flushed commit, then hides that
acknowledgment with ErrUncertain. Assert poison/no follow-on work, close/reopen
the real store/service, and observe the **real retained** intent/acceptance.
This is a response-loss seam, not a claim that the physical store returned
ErrUncertain after its successful flush, not an alternative store/authority/
validator, and not fake Git state. Package evidence labels these rows separately
from native range-lock and subprocess/torn-tail rows. Use no persist=false
fault seam for the native absent-commit outcome. (service_test.go:251-311;
SUP:1919-1933; probes:1822-1834; P22.)



| Slice / named test | Observable contract and plausible bug |
|---|---|
| S1 `TestGuardedMainUpdate` | SHA-1/SHA-256, initially loose/packed main; exact old succeeds and becomes candidate, stale old/symbolic main/non-fast-forward or wrong tree/parent refuses without mutation. Bug: overwrite a changed canonical or promote the original sealed tree. |
| S1 `TestCanonicalUpdateRefLockAndCheckout` | Real held main.lock remains byte-identical, no move; main checked out in any worktree refuses. Bug: erase a foreign lock or bypass D48. |
| S1 `TestCanonicalDurabilityFailuresHoldEffect` | Stop after CAS/before directory flush, remove/obstruct a required real directory or hold a file that prevents the required open/flush; no success result. Bug: treat exit 0 as completed durability. Real platform failures, no injected fsync success/error. |
| S1 `TestTrainMutationLockShared` | Two real operations in one workspace cannot enter finalization/integration mutation concurrently; different workspaces progress independently; cancelled wait acquires nothing. Bug: separate finalizer lock or colony-wide serialization. |
| S2 `TestF2_08Payloads` | Required/presence/identity/sequence/hash/path grammar; equal-tip/tree ref intent refused; optional keys preserve absence; malformed/null/repeated keys fail; unknown fields and open failure tokens remain readable. Bug: accept a no-op intent or break additive compatibility. |
| S2 `TestGoldenF2_08`, existing `TestGoldenDecodes` | Generate/read Appendix A's complete committed history; old goldens unchanged. Bug: missing pins, wrong optional-key encoding or changed earlier bytes. |
| S2 `FuzzDecodeF2_08` | New four payload decoders and optional-key combinations: no panic; successful decode re-encodes/decodes a stable valid value; malformed types/paths cannot yield partial data. Only new parsing target. |
| S3a `TestFinalizationOrderAndWitness` | At each hook observe actual Git, real durable records and same-ID result; a moved ref before acceptance is still finalizing and cannot witness a descendant intent; fifth admission stays busy until a terminal ack. Bug: publish/ref-as-acceptance or early slot release. |
| S3a `TestFinalizationPublishesExactIncrementalDelta` | A then B with foreign/local overlap/disjoint edits: target is derived tree, B's paths only predecessor→target, original contexts and F2-07 admitted authors retained, later scratch edits untouched. Bug: re-credit A or deliver mutable scratch. |
| S3a `TestAcceptedPredecessorKeepsSpeculativeGeneration` | Accept A with B's already prepared clean generation and a speculative conflict behind it; B remains current, conflict becomes terminal only when leading, window opens without needless rebuild. Bug: drop all generations on acceptance or leak a passing suffix over failure. |
| S3a `TestNoChangeUsesDurablePredecessor` | Same/different commit histories with same tree terminalize independently with no intent/CAS/acceptance/evidence/check claim; speculative redundancy waits; removing foreign A rebuilds useful B; no-change A's unaccepted commit forces B rebuild. Bug: compare commits or speculative tree and discard useful work. |
| S3a `TestRepresentedTreePreservesPrivateWork` | Observed and merged task edits prevent closure until their sealed submission is represented; accepted/no-change then permit closure only if no later edits; foreign integrated content never becomes this scratch's represented baseline. After a newer cancelled head, explicit new root uses earlier represented local tree. Bug: represented=derived tree/HEAD/anchor forever, or auto-close. |
| S3a `TestSuccessfulCaptureRetention` | Real gc after success, parent/head changes and subsequent failure preserves trees needed for live descendants, unfailed head and represented cursor; closure releases final obligation; moved refs are never overwritten. Bug: implement only (a)/(b), or retain everything forever. |
| S3a `TestFinalizationEvidenceBodyRetention` | Real PublishBody/Collect: current intent's evidence survives collection, uncertain bookkeeping does not unpin it, terminal commit releases it; reports survive every ending until closure. Bug: drop crash prerequisite or report at acceptance. |
| S3a `TestFinalizationEvidenceRecordLocator` | A real evidence record at nonzero commit index is found by its containing commit-first/record-seq/hash; wrong first/seq/hash/actor/context/body set refuses before intent or blocks recovery. Bug: cursor inside commit, unrelated evidence reference or history-wide lookup authority guess. |
| S3b `TestCancellationAuthorityAndCutoff` | Submitter and owner can cancel before intent; foreign context/supervisor/core actor cannot; both orderings deterministically gated at intent; after intent too_late even with old main; replay/repeat writes no second ending. Bug: owner-only, supervisor authority, race gap or post-intent abort. |
| S3b `TestTurnAndWriterLifetimeDoNotCancelPromotion` | Close real typed writer, cancel its originating call/wait context and close/reopen service while request live; no cancelled record except explicit CancelPromotion. No view/turn subsystem is faked. Bug: attach request cancellation to an originating lifetime. Actual turn/view integration remains C3/C7. |
| S3b `TestCancellationFailsLocalSuffixNotForeign` | R1–R4 local chain + independent foreign request: one atomic whole suffix ending, no local resurrection, foreign survives but stale generation rebuilds only on explicit integrate; real manifest/report retention and slots correct. Bug: cancel only parent, rebase local child, or end every train request. |
| S3b `TestFinalizationCrashMatrix` | Subprocess rows in the matrix below; reopen actual store/service, conditional bookkeeping, count records and observed main. Bug: blind CAS retry, acceptance duplication, lost outcome or later intent bypass. |
| S3b `TestUnfencedWriterBlocksRecovery` | Real prior child still alive / stopped but unavailable exact evidence / foreign tip / missing target or tree / current witness mismatch all block, keep slots/refs/pins and append no acceptance. Only positive tracked process exit plus exact evidence permits classification. Bug: infer quiescence from store lock/timeout/PID alone. |
| S3b `TestRecoveryInterruptsQueuedWithoutRestart` | Queued/speculative requests with no intent end interrupted and local suffixes dependency_failed after prerequisites; no new Git commit/check/capture/integration; fresh ID required to retry. Bug: auto-resume train or resurrect old ID. |
| S3b `TestFinalizationStoreFailure` | Close real store at before-intent and before-acceptance gates: no Git after failed intent; candidate effect plus failed acceptance keeps blocker and no next intent; reopen store/service and reconcile once. Crash-tail rows below cover uncertain durable record presence/absence. Bug: rollback/forget after a real effect or free slot on error. |
| Windows `TestWindowsFinalizationUncertainAppend` | P22 real range lock at intent/acceptance produces genuine ErrUncertain and poison; no early Git/result/release; release then Open/reconcile absent record. Bug: treat uncertain as definitely refused or continue after poison. |
| S3b `TestFinalizationLostAcknowledgment` | P22 persist=true response-loss seam at intent/acceptance leaves a real complete commit; no Git after uncertain intent, replay retains intent/acceptance and reconciles once. Bug: discard an unacknowledged complete intent/result or duplicate its effect. |
| S3 `TestOpenFailsClosedOnF2_08RuleBreak` | One real history/matrix: each Appendix A record rule contradicted once (wrong actor/context, generation/witness/target/hash, repeated intent/result, later intent, missing/out-of-order pins/unpins, missing failure suffix, successful parent treated failed, generation supersession during intent, moved baseline, premature no-change). Open names bad sequence; old F2 histories still open. Bug: accept internally inconsistent history or reject old valid bytes. |
| S3 `TestFinalizationPathsetCapBeforeIntent` | Real derived diff exceeds encoded acceptance/intent limit; no intent/ref movement/truncated result. Bug: apply Git then discover unrecordable acceptance. |
| Existing `TestRequestPromotionUnavailableInC2`, extended | After each mechanical accepted/no-change/reconciled fixture, a fresh valid product request still returns no_validator, takes no snapshot/record and leaves main/slots unchanged. Known-ID status lookup does no work. Bug: a frozen catalogue/test proof accidentally enables product admission or acceptance. |
| Windows `TestWindowsFinalizationSharingAndLongPaths` | Real deny-sharing handles on canonical ref/required directory; guarded update/flush failure gives retained unresolved/nonpromotion outcome, no removed foreign lock; release then bookkeeping without CAS retry. Common directory beyond 260 chars exercises existing SyncDir path support. Bug: declare completion on sharing violation or use narrow Win32 path. |
| Windows `TestWindowsPackedRefDurability` | Initially packed main becomes correct loose target, packed-refs unchanged by CAS, directory flush recipe completes; held packed/ref files yield real blocked errors; both object formats. Bug: flush only the old packed file or no parent entry. |
| Windows `TestWindowsOwnedGitExitBeforeRecovery` | Track actual Git process handle through cancelled/crashed helper; wait/positive exit needed, not a killed Core or elapsed WaitDelay; unmatched child blocks. Bug: store ownership treated as descendant fencing. |

**Crash/recovery matrix** (RC:606; DEC:371-372,410-414; P7,P15,P16).
All rows include a later queued/speculative request; use shared fixture history
with isolated mutable stores. Observe durable record **and** actual ref at every
boundary. Repeat recovery to prove no added acceptance, Git effect or slot release.

| Interruption boundary | Proven observation / required result |
|---|---|
| Before intent append; incomplete/uncommitted intent tail | No durable intent, no canonical mutation; request interrupted, local suffix failed, foreign queued requests interrupted; no automatic execution. |
| After intent acknowledgment, before process start | Old tip under all prerequisites → interrupted with matching intent ID and its pin released only in terminal commit; no canonical CAS. |
| While owned Git runs | Unfenced/live process → block. After positive exit, old→interrupted, intended→durability completion and missing acceptance only, third/absent/unreadable→block. |
| After canonical CAS, before directory/object durability completion | Intended tip but durability not yet complete: flush/verify exact storage only; failed flush blocks; never update main again. |
| After Git durability, before acceptance append | Intended→one acceptance bookkeeping; proven old→interrupted without retry; third ref/lost exact proof blocks. |
| Interrupted acceptance commit tail, incomplete | Real ledgerstore recovery discards incomplete tail; intended→one acceptance. |
| Complete acceptance durable but response lost | Replay already accepted: no duplicate accepted record/effect; pending queued requests interrupted. |
| After acceptance acknowledgement, before K/channel release | Replay restores zero claim for ended request and the new witness/represented cursor; no duplicate acceptance or decrement. |
| Before/within cancellation commit; then after acknowledgement | Recovered absent cancellation leaves request pre-intent and crash-interrupted; committed cancellation remains cancelled, suffix ended once, no canonical mutation. |

All “no CAS/Git retry” assertions concern canonical main. Existing recorded-object
CAS retention releases/sweeps and read-only verification remain permitted; do not
make a test forbid the cleanup the protocol explicitly requires. (WD:404-421;
DEC:413; R6:27; P13,P18.)

No permanent parser fuzz for Git output unless this implementation adds a parser.
`rev-parse --show-ref-format`/scalar IDs use existing exact-output helpers; if
a new parser is actually introduced, name and fuzz that parser, not unrelated
targets. Codec changes require the existing affected decode-target fuzz runs.
Deliberate breaks selected from the bug column must fail the named regression,
then restored code passes; report actual break/test evidence, not promised proof.
(DEC:1910,1969; SPEC:587; P18.)


## 5. Verification and implementation slices
**D116 verification (P18,P19).** Designer runs no commands. Coder runs only
package checks; PM collects committed evidence before the ticket advisor's one
review, then runs one full check on the exact main-bound commit.
Never overlap Go test/evidence/full-check commands. Record real versions,
RUN/PASS/FAIL/SKIP counts, package plain/race elapsed and 15 slowest tests.
The approximately 230s/290s assignment baseline is context, not a duration
assertion or permission to change the ten-minute check budget. (DEC:1910,
1963-1965; assignment:28-31; AGENTS.md:34-40; N7:18.)

PowerShell from assigned worktree root, first
`$env:GOTOOLCHAIN='local'; $env:GOFLAGS=''; $env:CGO_ENABLED='0'`.

| V | Exact command / evidence |
|---|---|
| V1 | `go test -count=1 -v ./internal/core/workspace` (S1/S3); S2 `go test -count=1 -v ./contract/ledger ./internal/core/ledgerstore` |
| V2 | With `$env:CGO_ENABLED='1'; $env:CC=$env:DWARF_CC`: `go test -race -count=1 -v ./internal/core/workspace`; repetition `go test -race -count=20 -run 'TrainMutationLock|FinalizationOrder|CancellationAuthority|UnfencedWriter|SuccessfulCaptureRetention' ./internal/core/workspace`; reset CGO_ENABLED to 0 |
| V3 | New S2 `go test ./contract/ledger -run '^$' -fuzz '^FuzzDecodeF2_08$' -fuzztime 120s`; changed S2 `go test ./contract/ledger -run '^$' -fuzz '^FuzzDecodeF2_06$' -fuzztime 120s`; other added/changed targets only, each 120s; every seed corpus still runs in full check |
| V4 | `gofmt -l internal/core/workspace contract/ledger`; `go vet ./internal/core/workspace ./contract/ledger`; `go tool staticcheck ./internal/core/workspace ./contract/ledger` |
| V5 | `$env:GOOS='linux'; go vet ./internal/core/workspace ./contract/ledger`; then darwin; remove GOOS afterward. Compile/vet is not native runtime proof. |
| V6 | `go list -f '{{join .Imports "\n"}}' ./internal/core/workspace`; `go list -deps -f '{{if not .Standard}}{{.ImportPath}}{{end}}' ./contract/ledger`; compare to admitted edges including P14's durable adapter, and standard-library-only contract |
| V7 | Coder `go mod tidy -diff`; PM evidence `go mod tidy`, unchanged module files, `go mod verify`; no dependency addition |
| V8 | `go test ./contract/ledger -run '^TestGolden' -update`; PM proves every earlier golden unchanged, verifies new committed golden hash/LF, no regenerated diff, and a clean exact-commit evidence worktree |
| V9 | PM `go run ./tools/check` with absolute pinned `DWARF_CC`; one full check per exact merge commit, after advisor approval; all nine steps pass |
| V10 | PM alone, Defender enabled, `$env:CGO_ENABLED='0'; $env:DWARF_CAPTURE_WORKLOAD_OUT='<outside-repo>\t08-workload.jsonl'; go test -count=1 -timeout=45m -run '^TestCaptureWorkload$' ./internal/core/workspace`; output raw measurements, no pass mark, clean owned disposable artifacts |

**Cost/model (P20; D78).** Assumption: 12/20 pairs, one required change per
600s, and four-checkpoint bursts (48/80). Calculation: each ref-changing
mechanical finalization adds two terminal-control records plus evidence pin/unpin
if bodies exist and the existing admission unpin: 3 or 5 records, plus one baseline
per workspace; no-change adds two. Ordered per-workspace capacity is at most
3600/F sequences/hour where F includes intent, Git/object/ref/directory flushes,
acceptance and release. At the provisional 150/hour 20-pair target this requires
F ≤24s before contention/other bottlenecks; **calculation, not an SLA or a pass**.
Validation remains parallel at C4; this shared lock already serializes integration
in C2 and must not be extended across validation work.
Measurement: extend existing opt-in 1k/10k-file history phases with baseline,
intent, guarded_main, durability, acceptance/release, no_change and old/intended
recovery bookkeeping, raw records/bytes/pins/retained refs/loose objects and wall
time. All are disposable mechanical fixtures, not accepted throughput.
Plan: C4 integrates actual validation, 12/20/larger steady/burst/rework workloads,
shared-resource costs and real throughput/backlog/latency. No maintenance or
scoped-down workload is inferred from these micro-measurements.
(CORE:242,676-690; RC:337,414,573,617; DEC:571-574,766-767; B6:515.)

| Slice | May start / deliverable | Merge prerequisite |
|---|---|---|
| S1 record-free | After 07 closes and advisor ruling: shared train-lock helper, exact guarded-main/durability primitives and named real-Git tests. No records/proof constructor exposed to product. | Committed package/platform evidence, advisor approval, one exact-commit full check; routine D116 merge. |
| S2 F2-08 contract | After ruling/S1 as useful: complete codecs/rules/golden/catalogue, packet/evidence by drafter. No producer writes new records. | Evidence+advisor review+full check on branch; **OG-F8 owner freeze/D41**, decision/register packet commit, full check on final exact merge commit. Earlier packet/check is not the final merge check. |
| S3a serialized success | After S1 and frozen S2: unexported intent/acceptance/no-change/witness mechanics, represented cursor/retention and replay, product remains unavailable. Representation tests may use real-store frozen failure-record fixtures; the cancellation command/its races run in S3b, not a stub. | Package/crash-at-known-boundary evidence for implemented paths, advisor approval, full check; routine. |
| S3b cancel/reconcile | After S3a: real cancellation command, conditional recovery, blocked/unavailable behavior, all crash/native tests and opt-in costs. No speculative future child manager. | Complete criterion matrix/measured evidence, advisor approval, one full check; routine. |
| Close | After all code: exact brief/ruling/probes/evidence, ticket Answer/criteria/comments, short B-NEXT, measurements and C2/board statuses, by PM/drafter. | Advisor close review, one full check on actual final commit; 08 resolved, C2 still In progress pending 09 and any unfulfilled C2 gates. |

Every slice is stub-free within its stated behavior. No contract-writing code
starts before freeze. Freeze metadata is the D116 exception to once-at-close
documents, not an extra design approval. (DEC:1646-1650,1907-1912,1921-1922;
assignment:13,21-31; P19.)


## 6. Numbered design choices and map disposition
Every unsettled choice is numbered here; options are not additional scope.
Recommendations are for the advisor, and F2-08 shapes remain the owner's freeze.

| ID | Options considered | Recommendation / reason / source |
|---|---|---|
| P1 | Export finalization/testing switch; a second workspace implementation; existing unexported mechanism plus real package fixtures | **Extend the current service, unexported finalization/reconcile/no-change, unconditional product refusal.** Reuses 05–07's proven pattern, not a validator/bypass. Owned paths §1. T08:18,32,36; RC:289; DEC:1946; R6:13. |
| P2 | Separate finalizer/cancel mutex; hold global service mutex; shared per-workspace channel and durable unresolved intent | **One shared train channel plus projection blocker.** Prevents cancellation/derive races without serializing validation or other workspaces; channel release alone cannot end unresolved effects. train.go:15-110; AN:8; RC:326,347; DEC:559. |
| P3 | Infer accepted predecessor from every main read; piggyback first tip in acceptance only; one additive baseline plus accepted-sequence chain | **CanonicalAnchored and predecessor_witness_seq**, no reanchor. Initial owner repo tip is baseline, not work credit; later ref-only moves never become accepted witness. Optional generation key activates only after baseline. AN:9; DEC:1960; LD:495-505; CORE:866,882. **OG-F8 shapes/rules owner gate.** |
| P4 | Invent F4 schema/pass flag; skip evidence; arbitrary-sequence scans; opaque immutable commit-first/record-seq/hash reference with exact caller-established tuple | **Opaque locatable evidence reference**, exact body_refs retained, no evidence verdict/type/epoch invented. Commit-first permits bounded segment lookup even when evidence is not commit index 0. C4 alone establishes real current complete passing evidence. CORE:844,864,866,874; R6:26; RC:289,311-313; CON:34; contract/ledger/reader.go:23-35,54-92,197-206. **OG-F8 owner gate.** |
| P5 | CAS then intent; release on ref move; exact prescribed sequence with precomputed recordable result | **Intent ack → one guarded durable CAS → accepted ack → release**, preflight future result first. The order itself is settled; helper layout/preflight implementation are the choice. T08:28; DEC:410,559; service.go:218-246; N7:5 (encoded-limit precedent). |
| P6 | One overloaded promotion_failed; one result type with outcome; separate baseline/intent/accepted/no-change types plus additive failure keys/tokens | **Four concrete v1 types**, cancelled/interrupted extend open failure vocabulary, no blocked/ready/operation placeholder. Success cannot fail local lineage. LD:518-547; DEC:1935,1650; B6:398; AN:8. **OG-F8 owner gate.** |
| P7 | Blind retry/rollback after Git error; generic failed ending; retain intent and classify under full prerequisites | **Never retry effect; proven old interrupts, candidate finishes only storage/bookkeeping; uncertainty holds.** Post-intent exceptions never turn into cancellation. No ad-hoc unknown-effect terminal token. DEC:411-415; RC:339-347; CORE:866. |
| P8 | Reuse ending nonempty as failure; keep full historical generation bodies; explicit terminal kind/success distinction plus compact witness history | **Separate successful terminals from lineage failure**, retain existing unknown failure semantics, coarse own-context RequestState, no ready record or speculative foreign detail. Adjust actual append sequences. request.go:25-94,376-477; LD:529-547; CORE:856,880; N7:12. |
| P9 | Supervisor cancel; context lifetime linked cancellation; explicit authority-bound CancelPromotion result | **Caller-stated owner/submitter binding**, repeats under train lock; cancelled/too_late/already_terminal, original envelope context, unknown request error. C3 authenticates/wire/receipts later. DEC:391-394,1814; CORE:298; RC:324,448,450. |
| P10 | Cancel only target; end every train request; existing atomic local-suffix endings, foreign invalidation and explicit integration | **Generalize endingDrafts**, preserve report pins and manifest order, no implicit execution. C2 has no validation children; C4 proves their cleanup before reuse. train.go:193-291; LD:535-547; CORE:860; RC:330,356-357; B6:769. |
| P11 | Compare request snapshot/main or speculative candidate; commit equality; actual witness-bound derived-tree equality | **Dedicated no-change success ending** before checks/intent, independent IDs; no-change predecessor collapses to accepted anchor and different commit forces rebuild. RC:334,339,615; DEC:511-512,561; CORE:882. |
| P12 | Represent cumulative target; replace scratch anchor/tip; represent sealed local tree through success records | **Cursor = admitted sealed tree on accepted/no_change**, no physical edits/automatic closure/base event; closure/restart consume it, successors retain local sealed-parent baseline. B6:222; AN:9; CORE:854,858,860; R7:27; LD:423-430,636-644. |
| P13 | Only live captures; only unfailed head; new represented namespace; same retainedRefs query with four obligations | **Existing capture refs with (a)–(d)**, including open represented cursor after newer failure; no second ownership/ref convention. Positive durable release and CAS sweep. B6:304-308; R6:27; CORE:860; WD:404-421; N7:11. |
| P14 | Trust Git exit/ref alone; handwrite platform fsync; reuse internal/core/durable with explicit Git components and post-rename verification/flush | **Reuse durable adapter (new permitted workspace import edge), explicit objects,reference for canonical CAS, files backend with post-rename storage flush; fail closed unsupported backend.** No module addition or platform adapter fork. Exact recipe §2.3. DEC:414,1740; AGENTS.md:37-40; durable/durable.go:1-24; probes:815-831,1252-1296. |
| P15 | Store lock/PID/time proves old child dead; introduce C10 sandbox/process registry; require actual supported-workflow ownership and positive prior-writer proof | **Conditional host proof, no OS/security claim/default true**. Current Git returns only after direct child wait; restart must not infer orphan death. Unknown prior child blocks; C3/C10 own complete child/containment machinery. RC:339,409,959; CORE:251,866; DEC:412-414. |
| P16 | Make Open append and run recovery; leave unfinished facts forever; preserve record-free Open plus explicit unexported conditional reconciliation | **Open reconstructs blockers/slots/refs; host conditional phase does bookkeeping only.** It is not resuming queued work. Before C4 only package tests call it. WD:414-420; DEC:1847,1951; R6:30; RC:321,339-347; DEC:371-372. |
| P17 | Break old unknown-token logs; strict new verdict grammar; conditional additive rules and existing codecs/goldens | **Keep old valid histories and open failure grammar**, check new witness/intent facts only when present, canonical evidence replay via exact prior-record lookup, no body-dependent replay truth. Appendix A. LD:529-547,574-594; DEC:1935; CON:16-17; R6:28-29. **OG-F8 owner gate.** |
| P18 | Mocks/global hooks/sleeps; serialized many histories; real Git/store/subprocess boundary matrices with parallel isolated fixtures | **Named regression matrix, one shared immutable history per matrix, hooks only schedule real effects.** New parser fuzz only; default package timeout unchanged. T08:36; SPEC:585,587,607; DEC:1910,1963-1965; assignment:28-31. |
| P19 | Owner approves design again; all code before freeze; routine mechanics/contract freeze/success/cancel-recovery/one close | **D117 ruling → S1; S2 at OG-F8/D41; S3 after freeze; D116 close once.** No extra owner question/status source. DEC:1646-1650,1907-1912,1921-1922; assignment:21-31. |
| P20 | Infer throughput from parallel lanes; benchmark fake acceptance as delivery; measure actual ordered mechanics separately and preserve C4 workload gate | **Label assumptions/calculation and raw per-step mechanical costs**, measure durable finalizer/retention with real Git/store, no threshold or population cut. C4 owns real accepted workload feasibility. CORE:242,676-690; DEC:571-574,766-767; RC:337,414,617. |
| P21 | Tighten formerly unknown cancelled/interrupted tokens globally; relax replay authority for all new endings; add an optional explicit outcome-rule marker | **outcome_rules:"promotion-outcomes/1" on all newly produced cancelled/interrupted endings**, conditional actor/ID rules at append/Open, no new command identity or type version. Old unmarked logs remain legal; marked core cancellation is rejected. Prevents an additive freeze from breaking open-token histories while still auditing new permissions. LD:529-547; contract/ledger/promotion.go:231-264; DEC:1935; CON:16-17. **OG-F8 owner gate.** |
| P22 | Mock successful Git/store state; use only process crashes/tails; real Windows range-lock absent-write plus approved response-loss retained-write seam | **Native range locking for real ErrUncertain/poison, existing persist=true acknowledgment-loss seam only for committed-but-unknown return.** Every durable byte/Git effect comes from the real store/Git; evidence distinguishes physical from response fault. One pre-Store.Append scheduling hook after apply validation. probes:1822-1834; service_test.go:251-311; SUP:1919-1933; SPEC:587. |

**All 16 map open items disposed:**
| Map item | Answer / choice |
|---|---|
| OI-1 part/name | Assignment fixes F2-08; P6 proposes actual names, OG-F8 freezes. |
| OI-2 successful endings | Separate accepted/no-change types; failure suffix invariant applies only to PromotionFailed (P6,P8,P11). |
| OI-3 cancellation/interruption actor | Explicit authorized owner/agent target, core descendants/interruption; original context and historical-token compatibility (P9,P17). |
| OI-4 open schemas versus selected mechanisms | Mechanism order/cutoff fixed by D112; exact payload choices P3–P6/P17 go to advisor and D40 freeze, not a reopened D52 design approval. |
| OI-5 exact evidence without C4 | Conditional mechanical bound tuple + opaque durable ref; no product verifier/F4 schema/pass bit (P1,P4). |
| OI-6 fencing before C10 | §2.3 states supported-workflow positive proof and missing-proof block; no hostile/same-user claim (P14,P15). |
| OI-7 no-change and C4 availability | Mechanism exercised only in fixtures; product still no_validator; exact witness-bound no-change shape P11. |
| OI-8 ready/finalizing/rejected | ready is C4's current evidence predicate; durable intent means finalizing; rejected remains C4, no fabricated failure token/type (P8). |
| OI-9 represented advance | Acceptance/no-change explicitly represent sealed local submission without anchor/tip/base changes (P12). |
| OI-10 success retention | Complete rule (c), plus required represented-cursor rule (d), current generations/pins and N7 refs (P13). |
| OI-11 recovery inside Open | Open record-free, conditional host phase separate; no product path before C4 (P16). |
| OI-12 which slot | Shared train exclusion, durable workspace publication obligation, per-request K-slot distinct; all resolved/released at acknowledged proven outcome (P2,P5). |
| OI-13 cancellation shape/cleanup | Internal service API, explicit authority/cutoff/result; actual children remain C4/C3 and no future wire schema (P9,P10). |
| OI-14 competing test-cost figures | Assignment's ~230/~290s is current context; record slice's actual timing and no duration assertions/budget change (P18,P20). |
| OI-15 status currency | PM/drafter's single close and freeze register record; no designer repo edit or reopened audit (P19). |
| OI-16 C2 Done | 08 proves only its five criteria, leaves 09/all C2 gates; no Done claim from this ticket (P19,P20). |

**Adjacent boundaries:** 09 alone owns owner-authorized immediate/not-before
activation, expected manifest/replacement/cancellation/clock and colony-wide hold/
revision. It will consume the durable unresolved-intent projection and gate new
intent creation through the same Core sequencing boundary; 08 adds no activation
record/timer/no-op barrier. Its criteria are only those quoted at
local://t08-map.md:1483-1489 (ticket 09:28-30). C3 owns authenticated principals,
turn/view lifecycle, D37 operation starts/interrupted ends, durable command
receipts, passive natural-turn delivery and read permissions (RC:429,440,447-450).
C4 supplies real current full-required evidence, attempts/lanes, cleanup before
reuse, BD2 disclosure, post-promotion observer and integrated tests/capacity
(RC:524,593,604-606,615,617; B6:769). C10 alone proves hostile-process fencing,
shared-metadata protection and positive descendant shutdown across supported
profiles (RC:930,949,956,959; CORE:251). A nil direct Git wait, store lock,
fixture evidence or directory flush is none of those later gates.
Do not equate an eventual evidence epoch with the policy-activation epoch:
CORE:864 names the former without a schema, while ticket 09's criteria name
no evidence epoch. R6:26/B6:767's informal assignment does not specify it.
F4/current C4 evidence owns its actual bindings; 08 adds neither epoch nor
attempt fields to GenerationDerived. (SUP:3592-3676; CORE:864,844; P4.)



## 7. Owner freeze path
OG-F8 is the sole anticipated owner gate (P19). The drafter prepares
`.scratch/dwarf-harness/c2-evidence/f2-08-freeze-packet.md` (one or two pages)
and a supporting `f2-08-freeze-evidence.md` on the S2 branch, **not the designer**.
The packet includes the four exact types/keys and failure tokens, baseline-not-
acceptance distinction, opaque evidence-reference boundary (no F4 verdict),
conditional compatibility rules, witness chain, represented/local tree and
retention implications, goldens' committed digests and the actual verification
table. Ask after S2 evidence/advisor review/full check, before S3 writes records:
“Freeze F2-08 as presented / Freeze with named changes / Not yet.”
The answer and packet as sent land with `D-NEXT`, the register addition and the
contract slice, with D41 sign-off and the full check on the final exact commit.
A changed answer goes through the advisor; do not silently substitute schemas.
(DEC:206,1646-1650,1907,1910-1912,1921-1922; CON:13-19,34.)

The ticket's other documents land once at close: byte-for-byte brief/ruling,
ticket claim/criteria/Answer/comments, evidence/probes, one short `B-NEXT`
pointing to this ruling and package docs (amending B25's failure-only retention/
Open deferral as necessary), C2 Status and board, measurements. Record the
freeze's catalogue additions in CON/UC in that slice as D116 requires; do not
turn U1.E ready, C2 Done or “base advanced” frozen merely because 08 closes.
07 and 09 and every relevant C2 evidence gate remain independently required.
No new dependency is proposed (D29); no D52 amendment, changed timeout or push.
(DEC:1907,1912,1922; RC:288,407-416; assignment:21-31; P19.)
Number placeholders for the drafter are exactly `«D-NEXT»` and `«B-NEXT»`,
resolved only at publication; no number is reserved by this design.
(local://t08-design-assignment.md:27.)



## Appendix A. Proposed F2-08 catalogue

### A.1 Common encoding, ownership and privacy

These are **proposed** F2-08 v1 payloads (P6,P17), added to ledger-format v1,
not approval or an operational producer. Reuse LD:574-594 / F0 codecs:
compact JSON in table order; errors wrap `ledger.ErrInvalid`; required keys,
no repeated keys/null known values; unknown keys ignored; canonical nonzero
UUIDv7; nonzero SHA-256 digests; Git IDs 40/64 lowercase hex, workspace-format
match checked by service. Optional keys are omitted at zero/empty, present-zero
and null refused. Sequence integers are 1..MaxInt64 (compatible with the colony
sequence range); required path arrays use F2-07's byte-sorted distinct valid UTF-8
repository paths and may be `[]`. No truncation or path normalization.
No fixed commit index; C3 may put its actual command record first.
(LD:574-594; contract/ledger/envelope.go:65-85; LD:415-418; CON:34; P6,P17.)

| Type/addition | Producer / permitted appender | Consumers | Privacy / replay |
|---|---|---|---|
| CanonicalAnchored v1 | C2 workspace mechanism, Core only; `internal/core/workspace` via appender, review-enforced | workspace witness/recovery; C4 predecessor binding; owner audit | host-private identifiers/Git IDs; baseline, **no delivered effect**; every payload key replay-essential |
| FinalizationIntended v1 | same, immediately before canonical mutation | workspace blocker/cutoff/recovery; C4 evidence obligations; 09 control barrier; owner audit | identifiers/Git IDs/evidence hashes/exact paths, host-private and original-context scoped; bodies may contain private diagnostics; every key and body_refs replay-essential |
| PromotionAccepted v1 | same, after Git durability or exact reconciled bookkeeping | workspace witness/representation/retention; C3 original-context passive result; C4 observer/disclosure; U1.E/U3/U4 accepted delta when their gates permit; owner audit | exact original-context/provenance paths and hashes, no file content, never outward hints; every key replay-essential |
| PromotionNoChange v1 | same, actual-predecessor proof before intent | workspace lineage/representation/retention; C3 passive result; C4 predecessor resolution; owner audit | own identity/result, private predecessor hashes stay host-side; every key replay-essential; **no accepted/field effect** |
| Existing-type keys/tokens | existing producer/caller unchanged | existing consumers plus witness/cutoff joins | replay-essential when present; no other privacy permission |

Source requirements: CON:34,38; LD:444-452,510-553; CORE:880-882;
UC:617,625-626; DEC:1650; P6 chooses names/shape, not disclosure authority.

### A.2 `workspace.canonical_anchored` v1 (`CanonicalAnchored`)

| key (emitted order) | type / presence | rule |
|---|---|---|
| workspace_id | UUIDv7 required | registered workspace |
| canonical_commit | Git ID required | supported-workflow baseline commit |
| canonical_tree | Git ID required | its tree |

Actor core, absent envelope context/body_refs. One per workspace, before any
F2-08 intent/success ending there; its sequence becomes the initial witness.
Producer verifies actual `main` and intact objects under exclusive ownership;
replay verifies registered workspace, uniqueness/order and Git ID widths.
This record grants no acceptance, reanchoring, authority, field source or work
credit. A missing baseline may be initialized by §2.1 only with no earlier
baseline, finalization intent, acceptance or no-change for the workspace.
Marked pre-intent cancellation/interruption may precede this first baseline:
they record no canonical effect and must not permanently block an independent
survivor's first finalization. (RC:281,339,347; CORE:866; AN:9; P3.)

### A.3 `workspace.finalization_intended` v1 (`FinalizationIntended`)

| key (emitted order) | type / presence | rule |
|---|---|---|
| intent_id | UUIDv7 required | never-used intent identity |
| request_id | UUIDv7 required | leading live admitted request |
| generation_id | UUIDv7 required | its exact current clean generation |
| predecessor_witness_seq | integer required | latest canonical baseline/acceptance sequence of this workspace |
| predecessor_commit | Git ID required | that witness and generation's predecessor commit |
| predecessor_tree | Git ID required | that witness and generation's predecessor tree |
| target_commit | Git ID required | generation's derived commit |
| target_tree | Git ID required | generation's derived tree |
| evidence_commit_first | integer required | first sequence of the complete commit containing evidence_seq |
| evidence_seq | integer required | earlier committed Core evidence-reference record |
| evidence_hash | digest required | SHA-256 of that record's exact envelope JSON bytes |
| changed_paths | path array required | exact predecessor_tree→target_tree set, nonempty here |
| finalization_rules | string required | rules-token grammar as LD:468; producer writes finalization-rules/1 |
| pin_id | UUIDv7 optional | present exactly when this record has nonempty body_refs |

Decoder: predecessor_commit != target_commit, predecessor_tree != target_tree,
changed_paths nonempty, evidence_commit_first <= evidence_seq.
Other cross-record constraints are service rules.
Actor core, envelope context == request's original context.
Body_refs is exactly the evidence record's sorted body_refs (absent when empty).
When nonempty, pin_id is required and the immediate next record in that commit
is `body_pin(pin_id)` with identical body_refs; otherwise no evidence pin.
The identified complete earlier commit starts at evidence_commit_first and
contains evidence_seq; that record's hash is exact and actor/context are
Core/original context in the same colony. Use the locator/reader rule in §2.1,
not payload digest matching or an agent report. No evidence payload schema
is frozen: C4 owns exact passing-evidence semantics. (P4;
contract/ledger/reader.go:23-35,54-92,197-206; CORE:866.)

One unresolved intent per workspace, one intent per request; request not ended,
no earlier live request, successful local parent, target equals exact generation
and predecessor equals current witness. A generation whose predecessor IDs name
an already accepted request is allowed only if that acceptance is the current
witness for precisely the recorded request/generation/commit/tree.
While unresolved: no later intent, no generation superseding its target, no
acceptance/no-change/failure ending of it except the matching acceptance or
matching `interrupted` with intent_id; no cancelled outcome for it.
Unrelated later admissions/failure cancellations may remain in the train.
Producer establishes evidence/currentness, D48, target parentage, path diff and
storage/fencing; replay enforces record facts without inventing those observations.
(RC:326,339,347; CORE:864,866,874; DEC:410-414,559; LD:495-505; P4,P5,P7.)

### A.4 `workspace.promotion_accepted` v1 (`PromotionAccepted`)

| key (emitted order) | type / presence | rule |
|---|---|---|
| intent_id | UUIDv7 required | unresolved exact intent |
| request_id | UUIDv7 required | that intent's original request |
| generation_id | UUIDv7 required | that intent's exact generation |
| predecessor_witness_seq | integer required | same intent binding |
| predecessor_commit | Git ID required | same intent predecessor |
| predecessor_tree | Git ID required | same intent predecessor tree |
| accepted_commit | Git ID required | exactly intent.target_commit |
| accepted_tree | Git ID required | exactly intent.target_tree |
| changed_paths | path array required | exactly intent.changed_paths, nonempty |

Decoder refuses equal predecessor/accepted commits or trees and empty paths.
Actor core, envelope context original request; body_refs absent.
Every binding equals its unresolved intent, current canonical witness still equals
predecessor_witness_seq, request not ended, exact successful-prefix position.
The commit carries the admission's manifest unpin then intent-evidence unpin
when present, each once after acceptance; never a report unpin.
The record resolves the intent and ends only this request successfully, becomes
the workspace's new canonical witness, and advances its dedicated scratch's
represented request/tree to this admission's sealed tree. Local children remain
live. Acceptance sequence (not intent ID) is the distinct accepted-result
identity; repeated acceptance for that intent/request is inconsistent.
Normal/reconciled results have **identical payload and consumer effects**; no
recovery flag, synthetic delivery flag or new promotion identity.
This is actual accepted work only when the real C4 producer prerequisites hold;
C2 goldens/disposable mechanism histories are contract fixtures, never delivery.
(T08:28,32; DEC:413,559,562,678; CORE:866,882; UC:625-626;
AN:9; R6:27; P5,P8,P12.)

### A.5 `workspace.promotion_no_change` v1 (`PromotionNoChange`)

| key (emitted order) | type / presence | rule |
|---|---|---|
| request_id | UUIDv7 required | leading current live request |
| generation_id | UUIDv7 required | current clean generation |
| predecessor_witness_seq | integer required | actual current accepted/baseline witness |
| predecessor_commit | Git ID required | witness and generation's predecessor |
| predecessor_tree | Git ID required | witness tree == generation.derived_tree |

Actor core, original envelope context, no body_refs. No intent for this request.
No earlier live request, local parent successful; generation/witness bindings exact;
producer verifies actual current `main` and tree equality; replay verifies record
equality. The manifest unpin follows in the same commit, once, no report unpin.
End this request without failing its lineage, advance its represented local sealed
tree and preserve its independent ID. The current canonical witness does not
advance; this result resolves dependencies to that real witness and never counts
as accepted work, passing checks, pressure or graph/field source.
(RC:334,339,615; DEC:511-512,561; CORE:860,882; UC:626; B6:222; P11,P12.)

### A.6 Additions and conditional record rules

- `generation_derived.predecessor_witness_seq`: optional integer, emitted after
  existing `report_pin_id`, omitted at zero/present-zero refused. If present,
  predecessor_request_id/generation_id must both be absent (decoder).
  When a F2-08 baseline exists, a **new** canonical-predecessor generation
  requires the latest witness and its exact predecessor commit/tree; speculative
  generations carry no witness. Before the baseline old F2-06 rules govern.
  Generations derived before an acceptance stay valid if their predecessor equals
  that acceptance's exact target; do not mutate old records to insert a witness.
  (LD:454-505; DEC:1960; AN:9; P3,P17.)
- `promotion_failed.intent_id`: optional UUIDv7 emitted after existing
  failed_request_id. `promotion_failed.outcome_rules`: optional rules token,
  emitted after intent_id; same lexical grammar as integration_rules.
  Existing open-outcome decoder combinations stay valid. The generic decoder
  checks only the optional new keys' own grammar, not new cross-key rules.
  Every new cancelled/interrupted producer record requires
  outcome_rules = promotion-outcomes/1; its presence activates these F2-08 rules
  at append/Open. Old records without it stay historical unknown-token failures,
  even if their token now has a meaning. No new command/operation identity.
  An intent_id requires this marker and identifies this request's unresolved
  intent; only outcome interrupted with actor core may resolve it, with
  generation_id equal to the intent's generation and no failed_request_id.
  Its commit carries all lineage endings/manifests' unpins, then the intent-
  evidence unpin when present. An unfinished intent cannot end without this
  exact marked binding. Unknown outcome_rules values keep generic failure
  replay semantics but never resolve an active F2-08 intent or authorize
  a producer write under this reading version. (LD:529-547; DEC:1935;
  AN:8; P7,P17,P21.)
- New producer token `cancelled`: authorized owner/agent target actor, original
  context, no optional generation/failed/intent IDs, request admitted/live/pre-
  intent; dependency_failed descendants remain core.
- New producer token `interrupted`: core; pre-intent has no optional IDs
  other than outcome_rules, post-intent uses the previous key rule.
  Unmarked historical payloads keep all old legal optional-ID/actor combinations;
  no old log becomes invalid just because a token is now understood (P21).
- All failure tokens still fail the entire live local suffix; success types never
  do. Ordered admission-manifest unpins are required for every terminal result;
  only failures require the no-live-higher-checkpoint invariant. No ending
  releases a conflict report. All new record joins/identities/format widths,
  context/actor bindings, pin and witness sequencing are checked at append/Open.
  (LD:529-547; train.go:193-222; request.go:376-477; P8,P17.)

No F2-05/F2-07 closure reason/key or admission provenance byte changes.
Representation follows accepted/no-change records; it is not scratch-base movement.
(LD:423-430,636-644,794-801; R7:26-27; P12.)

### A.7 Golden samples and exact fixture layout

One LF-only golden:
`contract/ledger/testdata/f2/08/log/00000000000000000001.jsonl`.
`TestGoldenF2_08` uses the repository's current EncodeCommit/golden helper
convention and `-update`; it compares committed bytes, not hand-assembled envelope
hashes. The body directory fixtures needed for store replay are created by tests
via real PublishBody, not committed diagnostic content. F0/F2-05/F2-06/F2-07
goldens are unchanged. These are deliberately synthetic bindings, not a check run.
(LD:555-564,823-834; B6:451-457,932-953; SPEC:585,587; P17.)

Symbols below are fixed distinct UUIDv7 IDs from the existing golden helper;
OID symbols are fixed format-sized valid IDs: B0/T0 initial, D1/T1 accepted,
D2 a different commit with tree T1, D5/T5 ref-changing. Admission sealed trees
S1=T1, S2=T1, S3=T3, S4=T4, S5=T5, S6=T6; W/S/C/L/X/Q/I/E denote
workspace/scratch/context/lineage/capture/manifest pin/intent/evidence as named.
Use a new fixture colony, fixed fixture clock and helpers exactly as existing
goldens. Shapes and dependency order below are fixed; numeric IDs/digests use
those helpers, not a new UUID/time convention.
All newly produced cancelled/interrupted rows below carry
`outcome_rules:"promotion-outcomes/1"`; descendants retain the frozen
dependency_failed shape without this marker. Include an additional codec/
replay matrix of previously valid **unmarked** cancelled/interrupted payloads
with their old optional combinations, not a modified earlier golden.


| Commit | Exact sequence / records |
|---|---|
| c1 | 1 registered W; 2 inputs revision 1/body refs; 3 matching body_pin |
| c2 | 4 scratch_created S/C, base B0/tree T0 |
| c3 | 5 canonical_anchored W, B0/T0 |
| c4 | 6 admitted R1 root sealed T1; 7 admission pin Q1 |
| c5 | 8 generation G1, canonical B0/T0, witness 5, derived D1/T1 |
| c6 | 9 fixture.finalization_evidence E1, Core/C, no body_refs |
| c7 | 10 finalization_intended I1/R1/G1, witness 5, E1 seq/hash, D1/T1 |
| c8 | 11 accepted I1/R1/G1, predecessor B0/T0→D1/T1; 12 unpin Q1 |
| c9 | 13 admitted R2 successor R1 sealed T1; 14 pin Q2 |
| c10 | 15 generation G2 canonical D1/T1, witness 11, derived D2/T1 |
| c11 | 16 no_change R2/G2 at witness 11; 17 unpin Q2 |
| c12 | 18 admitted R3 successor R2 sealed T3; 19 pin Q3 |
| c13 | 20 admitted R4 successor R3 sealed T4; 21 pin Q4 |
| c14 | 22 failed R3(cancelled), owner/C; 23 R4(dependency_failed R3), core/C; 24 unpin Q3; 25 unpin Q4 |
| c15 | 26 admitted new root R5 restart R4, baseline/delta T1, sealed T5; 27 pin Q5 |
| c16 | 28 generation G5 canonical D1/T1, witness 11, derived D5/T5 |
| c17 | 29 fixture.finalization_evidence E5 Core/C, body_refs=[diagnostic digest] |
| c18 | 30 finalization_intended I5/R5/G5, witness 11, E5 seq/hash and body_refs; 31 immediate intent body_pin PI5 |
| c19 | 32 failed R5(interrupted, G5, intent I5), core/C; 33 unpin Q5; 34 unpin PI5 |
| c20 | 35 admitted new root R6 restart R5, baseline/delta T1, sealed T6; 36 pin Q6 |
| c21 | 37 failed R6(interrupted), no generation/intent; 38 unpin Q6 |

The fixture evidence payload is test data with exactly the identity/binding tuple
of §2.1 and its inputs/rules, no verdict; the test's catalogue adds its fixture
type and `Defined()` does not. It is not part of F2-08's producer catalogue.
The real store's body publication supplies E5's diagnostic digest. Replay tests
also extend a real F2-07 provenance history with an acceptance to prove author
references survive; no golden edits or invented authors.

Representative compact payloads (UUIDs/IDs/digests below are synthetic, exact
valid values; envelope/hash chain produced by EncodeCommit):
```json
{"workspace_id":"01940000-0000-7000-8000-000000000001","canonical_commit":"1111111111111111111111111111111111111111","canonical_tree":"2222222222222222222222222222222222222222"}
{"intent_id":"01940000-0000-7000-8000-000000000010","request_id":"01940000-0000-7000-8000-000000000006","generation_id":"01940000-0000-7000-8000-000000000008","predecessor_witness_seq":5,"predecessor_commit":"1111111111111111111111111111111111111111","predecessor_tree":"2222222222222222222222222222222222222222","target_commit":"3333333333333333333333333333333333333333","target_tree":"4444444444444444444444444444444444444444","evidence_commit_first":9,"evidence_seq":9,"evidence_hash":"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa","changed_paths":["file.go"],"finalization_rules":"finalization-rules/1"}
{"intent_id":"01940000-0000-7000-8000-000000000010","request_id":"01940000-0000-7000-8000-000000000006","generation_id":"01940000-0000-7000-8000-000000000008","predecessor_witness_seq":5,"predecessor_commit":"1111111111111111111111111111111111111111","predecessor_tree":"2222222222222222222222222222222222222222","accepted_commit":"3333333333333333333333333333333333333333","accepted_tree":"4444444444444444444444444444444444444444","changed_paths":["file.go"]}
{"request_id":"01940000-0000-7000-8000-000000000013","generation_id":"01940000-0000-7000-8000-000000000015","predecessor_witness_seq":11,"predecessor_commit":"3333333333333333333333333333333333333333","predecessor_tree":"4444444444444444444444444444444444444444"}
{"request_id":"01940000-0000-7000-8000-000000000018","outcome":"cancelled","outcome_rules":"promotion-outcomes/1"}
{"request_id":"01940000-0000-7000-8000-000000000026","outcome":"interrupted","generation_id":"01940000-0000-7000-8000-000000000028","intent_id":"01940000-0000-7000-8000-000000000030","outcome_rules":"promotion-outcomes/1"}
```

