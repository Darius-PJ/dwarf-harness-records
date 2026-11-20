# Ticket 16 — implementation design brief

For the owner: this remains loopback, testing-only runtime proof, not C3 completion, C4 validation or A2 qualification. Production work is durable continuation/reconciliation and lifetime ownership for today's Git children. No keys or paid calls are requested. All six criteria stay in four slices. One important proposed limitation: an abnormal Windows crash with no surviving positive Job proof quarantines its old workspace resources rather than guessing them reusable (P9). The advisor's ruling wins.

## 0. Gate verdict and as-built map

**Verdict: buildable after an additive contract slice, with no proposed owner gate.** The assignment fixes base `c89447f77a6cdbac52be45f7150393eae6b50b94`, clear blockers and the existing freezes. F3-10/11/12/13/139/15 and F2 already carry identity, private heads, task/work CAS, money, tool intent/results and scratch plans/results, but no record carries the continuation owner's changing wait state. Add F3-16, not extra members to a frozen closed submission. Earlier encodings and goldens stay byte-identical. Gate basis: the ticket's “Start and authority gates” and six criteria; `docs/CONTRACTS.md:32–40`; `docs/CURRENT-RULES.md:71–75`; D165 and D166. P1 and P5 below settle the proposed family and platform boundary; their advisor ruling is still required.

### 0.1 All six criteria

| Criterion | Existing real code, record and proof | Missing here |
|---|---|---|
| 1. Concurrent writers, merge-back, private continuations | `agents.StartTurn` enforces per-context exclusion and default three agent slots (`internal/core/agents/doc.go:197–220`); expected-version private publication (`doc.go:47–90`), F3-10/11 revisions and work; `TestScopedStartTurnAdmission` (`scoped_admissions_test.go:26`), `TestTurnLoopAdmissionAndFairness` (`loop_scheduler_test.go:90`), `testLoopNativeConflicts` (`loop_conflicts_test.go:16`), F3-15 loopback replay (`loop_providers_test.go:19`). `finish` already commits writers and calls MergeBack (`loop_manifest.go:289–316`); F2 scratch changed/merge-back (`docs/CONTRACTS.md:75–80`). | One integrated, barrier-controlled real three-turn proof including clean/conflicting merge-back, exact authors/notices, CAS reread, and origin-isolated artifacts through reopen. |
| 2. Interrupted turn, no repeated effects, Windows descendants | `Open` is read-only and reports unmatched loop/tool metadata (`internal/core/agents/doc.go:25–38`); F3-15 starts/results and F3-11 interrupted endings; `TestScopedInjectedCrashRecovery` (`scoped_crash_test.go:39`), late-native-effect/frozen replay (`loop_replay_test.go:12–15`). `winexec` already owns native Job closure for its own runs (`internal/core/winexec/doc.go:1–14`). | Bound-loop process-death drills and an explicit no-reexecution reconciliation path; actual workspace Git trees currently have only root `Cmd.Wait`, not a positive descendant boundary (`workspace/git.go:109–154`). Normal/abnormal shutdown must cover those real children, not an invented shell tool. |
| 3. Passive original-context results | F2 original request/results and D63; promotion remains unavailable. `TestTurnLoopPromotionUnavailable` (`internal/core/agents/loop_promotion_test.go:17`); existing turn finish/transcript machinery (`internal/core/agents/loop_manifest.go:318–348`). F2 has replayable `ScratchNotices`, currently called only by workspace tests (`internal/core/workspace/mergeback.go:575–600`; LSP references). | Wire those actual notices into the task's next natural turn and prove status/natural-turn/reopen behavior: completion creates no model POST or live turn; sibling context never gets the result. Do not invent accepted promotion fixtures or a broker. |
| 4. Three OSes and resource profiles | D153 public three-OS CI already exists (assignment); checkpoint/directory/cold-read protocol already removes the measured ticket-15 failure class (`internal/core/agents/doc.go:373–463`; ticket-142 ruling:5–42). | New exact-SHA three-OS evidence plus declared integrated runtime, restart and Windows-child profiles. Figures, not a new latency/capacity bound or an A2 claim. |
| 5. Persisted continuation owner | Immutable F3-15 bound input/policy/render refs (`contract/ledger/doc.go:2895–2918`); live owner fields are only RAM (`loop_runtime.go:42–74`), including counters, wait generation and pending calls. `EnableTurnLoop` creates an empty live-turn map (`loop_runtime.go:94–150`); current Open exposes only metadata. | Durable owner transitions containing exact origin, operation/generation, expected state, pending identities, reason, counters and absolute deadline; reconstruct inert waits, then explicit reconciliation, never automatic execution. |
| 6. Durable race precedence | Current boundary order and one quantum per turn (`loop_runtime.go:253–391,468–557`); native ending becomes authoritative for retried finish (`loop_manifest.go:356–410`); paid unknown holds remain held (`doc.go:563–580`); tool result releases no accounting (`contract/ledger/doc.go:2850–2857`). Existing boundary, busy-finish and money rows (`loop_boundaries_test.go:31`; `loop_finish_busy_test.go:259`; `loop_money_test.go:43`). | Persist cancellation before signaling; CAS callback/recovery transitions against current durable owner/child state; deterministic stop/result/crash interleavings, with no terminal revival, no false 'prevented' effect, no hold or unconfirmed-child release. |

### 0.2 Which processes Core starts today

The production launch inventory is deliberately distinct from test helper processes. Workspace Git is the one ordinary child path: executable/version inspection (`workspace/git.go:25–45`), repository commands through `run`/`repository` (`git.go:98–106,155–158`), capture batch reading (`workspace/capture.go:400`) and streamed artifact reading (`workspace/artifact.go:363`) all converge on `gitRunner.runOutput` (`git.go:109–154`). This includes worktree creation, observed commits, merge-tree and merge-back's Git operations. Those processes and any filters/config-selected Git descendants require Core-owned shutdown; current `CommandContext`, five-second `WaitDelay`, and root `Wait` do not prove their descendants gone (`workspace/doc.go:21–26`).

The separate Windows `winexec` adapter can launch an executable plus its descendants in AppContainer/Job containment, but has no C3 production caller and is not used for those host Git operations (`winexec/doc.go:1–14`; B30 items 1–2). Bound file tools are in-process, and paid calls use HTTP, not one child per context (`agents/doc.go:197–208`; ticket-15 ruling:91–95). Validation children belong to 17/46; arbitrary shell/process tools are not supplied here (ticket 17:27–33; `ROADMAP-CORE.md:432–437`). Test crash helpers are owned and joined by their parent test, not silently counted as runtime children (`agents/scoped_crash_test.go:94–96`).

C10's published status reserves integration and A2 qualification (`docs/ROADMAP-CORE.md:959–961`). P5 adds separate lifetime-only host-Git ownership, not winexec dependence, agent process capability, AppContainer access to shared Git or A2. No winexec edit overlaps 144. Its new exact x/sys importer requires an assistant decision/allowlist change, **not owner approval** (D151; `docs/CURRENT-RULES.md:31,48`; `go.mod:13`; `tools/check/boundary.go:73–84`).

## 1. Numbered design choices

Every implementation selection below is a proposal for the advisor, not an owner decision. “T16” means `.scratch/dwarf-harness/issues/16-prove-concurrent-private-runtime-restart-and-child-shutdown.md`, “AS” means `internal/core/agents/`, and “WS” means `internal/core/workspace/`; these aliases apply to repository-relative citations throughout this brief.
Source aliases: “ticket-10 ruling”, “ticket-11 ruling”, “ticket-15 ruling”, “ticket-15 fix ruling” and “ticket-142 ruling” mean the corresponding ticket-N-design-ruling.md in `.scratch/dwarf-harness/c3-evidence/`, except the fix means ticket-15-fix-ruling.md. Bare ruling basenames mean that same directory. Initial §0 shortened code paths are rooted at internal/core/ (agents filenames under agents unless workspace is explicit). Decision-log citations use decision/heading, never shifting log lines.

| Choice | Options considered | Recommendation and source |
|---|---|---|
| **P1 — durable family** | Provider artifacts; extend frozen schema 6; or additive owner family. | Two version-1 types runtime.continuation_changed/runtime.continuation_receipt, schema 7, F3-16 freeze before producers. Keeps execution state separate and schema 6 closed. `T16:33–34`; `contract/ledger/doc.go:2978–2999,3020–3037`; `docs/CONTRACTS.md:32–40`; D88 item 5, D165. |
| **P2 — owner and waits** | Second engine; persisted per-context workers; or existing owner plus durable state. | Extend loopRuntime/reducer; semantic wait/phase transitions, no persisted wake counters or dormant goroutines. `AS/loop_runtime.go:21–89,253–391`; `docs/DESIGN-CORE-AND-LAUNCHERS.md:918`; `T16:33`; D88 item 5. |
| **P3 — restart** | Resume quantum; write inside Open; or inert Open plus host bookkeeping. | Add ReconcileLoop; executable invokes it before enabling execution. Child-first records only, no tool/model/observation/merge replay. `AS/service.go:164–215`; `AS/scoped_admissions.go:64–91`; `AS/paid_reconcile.go:12–15`; `contract/ledger/doc.go:3045–3061`; `T16:30,33`. |
| **P4 — stop/callback linearization** | RAM-only cancel; claim prevented effects; or durable stop and actual-effect reconciliation. | Persist stop before signaling; callback CAS includes operation/generation/state/version; committed native ending wins. Session acknowledges acceptance, not prevention. `AS/loop_session.go:189–241`; `AS/loop_manifest.go:356–410`; `T16:34`; `contract/ledger/doc.go:1947–1956,2929–2945`. |
| **P5 — child boundary/importer** | Drill unused winexec; put host Git in AppContainer; extract/share winexec primitives; add narrow lifetime adapter; defer proof. | Add internal/core/gitprocess for all workspace launches. Winexec's guest cannot receive shared Git authority; extracting it would couple 144/C10 work unnecessarily. Distinct lifetime-only adapter, finite quotas and x/sys exact-importer rule, no module/qualification. `WS/git.go:25–45,109–158`; `WS/doc.go:21–26`; `internal/core/winexec/doc.go:1–17`; `docs/ROADMAP-CORE.md:959–961`; `tools/check/boundary.go:73–84`; B30. |
| **P6 — passive delivery** | Completion-triggered follow-up; new task/broker queue; or render existing durable facts on a natural turn. | Use F2 `ScratchNotices` and a per-context notice cursor selected in immutable turn input; acknowledge that cursor in F3-16 only once the natural turn's first paid intent exists. No new promotion producer or broker. `WS/mergeback.go:575–600`; `WS/doc.go:267–274`; `AS/loop_start.go:265–387`; `docs/ROADMAP-CORE.md:430,439`; D23, D63. |
| **P7 — measurement** | Invent bounds; repeat storage-only work; or integrated figures. | One matrix plus restart/Windows-child profiles, no performance bound. Reuse 142's observation discipline, show owner-journal costs; safety settings/watchdogs are not SLAs. `T16:32`; `docs/CURRENT-RULES.md:33–35`; `docs/ROADMAP-CORE.md:491`; ticket-142 ruling:104–107. |
| **P8 — slice cut** | More than four; defer criteria; or four coherent slices. | Contract; owner/recovery/races; Git lifetime; integrated/passive/evidence. No criterion split. `docs/CURRENT-RULES.md:10–16`; `T16:29–34`; assignment “Slices”. |
| **P9 — ambiguous child recovery** | Treat missing Job name/PID as proof; add persistent external supervisor; or quarantine without proof. | Named-Job positive reconciliation where available; otherwise old resources stay fenced, even after default kill-on-close. No new supervisor/launcher, unsafe force-clear or hidden success. Separate last-handle and retained-Job proofs. `T16:30,34`; `internal/core/winexec/doc.go:7–14`; B30 item 2. |
| **P10 — actual workload shape** | 60 agents with many contexts; 60 total contexts across fewer agents; or omit row. | 20 agents × (general + 2 work contexts), all 3 active, no dormant: exactly 60 enrolled contexts, scripts repeated twice. Full per-agent concurrency without inventing 1,200 contexts as the owner's fact. `docs/DESIGN-CORE-AND-LAUNCHERS.md:1182`; `docs/ROADMAP-CORE.md:491`; B21 “Owner answers”, OG3; `T16:32`. |


## 2. Durable continuation state and records

### 2.1 F3-16 encoding and freeze

P1 follows existing receipts, not a second authority store. C3 owns payloads and only internal/core/agents appends. Consumers are preflight/Open, the one owner, exact-origin views, cancellation/recovery. No private bytes, provider artifacts, secret-derived identity, locator, body ref or native handle; all known fields/envelope IDs are replay-essential (`docs/CONTRACTS.md:34–40`; `contract/ledger/doc.go:2829–2840`; `T16:33–34`).

Use F3-15's strict complete-JSON, recursive duplicate-key, canonical UUIDv7/digest, plain 0..MaxInt64 integer and unknown-optional-member rules; 65,536 bytes for the **whole** payload and embedded submission, separately on input/output. Optional fields are omitted, never null. Checked version/generation increments refuse overflow. Open-token grammar is F3-15's; unknown phase/reason/kind is retained as unsupported and cannot dispatch, release or become success. Schema 7 operations/actors are closed as below. Runtime pending-count limits remain producer guards, not historical decoding limits (`contract/ledger/doc.go:2863–2891`; D140 “Not frozen”; P1).

Exact key order:

```text
runtime.continuation_changed:
  turn_id, bound_sequence, expected_version, version,
  expected_state, state, resume_state?, operation_id, generation, wait_reason,
  model_calls, tool_dispatches, deadline_utc_ns, pending,
  stop_reason?, cancel_command_id?, final_message_object?,
  native_ending_sequence?, notice_cursors

Pending:
  kind, id, command_id, expected_version, source_sequence?
NoticeCursor:
  workspace_id, scratch_id, after_sequence

runtime.continuation_receipt:
  command_id, submission_sha256, submission, outcome, effect_sequence

ContinuationSubmission:
  schema (7), actor, origin, turn_id, operation,
  expected_version, expected_state, arguments
arguments:
  bound_sequence, state, resume_state?, operation_id, generation, wait_reason,
  model_calls, tool_dispatches, deadline_utc_ns, pending,
  stop_reason?, cancel_command_id?, final_message_object?,
  native_ending_sequence?, notice_cursors
```

Origin/ObjectRef retain F3-15 shapes. Required pending/notice_cursors arrays may be empty; sort pending by (kind,id,command_id), cursors by (workspace_id,scratch_id), using token/UUID bytes; duplicates refuse. Pending kinds: paid_attempt, tool, local_work, scratch_observation, merge_back. Optional source_sequence selects its exact committed source; a pre-minted command without source is not dispatched. Logical operation_id differs from the transition command envelope ID. Generation starts at 1; same-operation waits/retries keep it; replacing a quantum/finish/recovery operation increments it. Original deadline is immutable (`T16:33`; `AS/loop_runtime.go:42–89`; `AS/loop_start.go:136–143`; P1–P2).

Operations are `owner.initialize`, `owner.advance`, `owner.stop`, `owner.reconcile`, `owner.close`, each actor `core`, except a Session-originated `owner.stop` has actor `owner` and uses that Session command ID. It still derives/fixes origin from Session. An agent entrance is not added. Every operation is exactly `[ledger.command, runtime.continuation_changed, runtime.continuation_receipt]`, one SubmitAt at the preflighted tail; three moved-tail attempts, then existing `BusyError{ledger_tail}`. The change's actor is core; command/receipt actor matches submission. Every envelope binds the same original agent/session/context/turn and operation_id=transition command_id. Receipt outcome writer value `recorded`; positive effect_sequence is the actual change record after authoritative readback, not a guessed tail. Global command lookup covers schemas 1–7. Same ID/principal/digest returns its original receipt after current disclosure authorization; changed meaning is `ErrCommandMismatch` before state CAS (`AS/loop_journal.go:40–133`; `AS/doc.go:427–456`; `contract/ledger/doc.go:3008–3037`; P1).
Conditional members (P1/P4): stop_reason is cancelled/shutdown for a stop, or the existing F3-15 failure reason for a failed finish; preserve first durable cancellation over later shutdown. cancel_command_id occurs exactly for cancelled and names its original Session/native cancel command. final_message_object occurs only for a validated natural finish and must be selected in the original context before native EndTurn; remove it for a pre-ending stop. native_ending_sequence appears only after the exact F3-11 ending exists, and is required at terminal. A recovery that finds that ending completes its original outcome; a new stop cannot overwrite it (`contract/ledger/doc.go:2963–2975`; `AS/loop_manifest.go:356–410`; `T16:34`).

Initialize: expectation 0/absent, exact unmatched binding, ready (live) or reconciling (recovery), generation 1. Later transitions compare exact version/phase and operation/generation; version=expected+1. Stale callback returns ErrContinuationStale with no record/counter/wake/effect. Origin/turn/bound sequence/deadline never change; cursors never regress. owner.close requires actual matching F3-15 terminal and F3-11 ending, terminal state, no executable pending work. Unknown holds may remain; terminal never reopens (`T16:33–34`; `contract/ledger/doc.go:1947–1956,2850–2857`; P1/P4).

Freeze adds only these two types (`Defined` 59→61), schema 7 and the additive guarded-turn reading below. Existing group shapes and bytes stay unchanged, with no mixed-family group. New files: `contract/ledger/continuation.go`, `continuation_submission.go`, `continuation_test.go`, `continuation_golden_test.go`; additions to catalogue/doc/fuzz files and new `testdata/f3/16/{log,objects,bodies}` fixtures only where referenced. Golden uses an isolated UUID namespace, deterministic times and real earlier-family setup; covers all five operations, resource wait, cancel intent, stale-result refusal represented by unchanged prefix, and recovery/terminal snapshots. Actual operation commands that refuse add no golden record. PM records field/privacy/catalogue/consumer rules and unchanged earlier hashes, then freezes completed code/evidence/record under D125 before S2. No producer imports a proposed type before that freeze (`docs/CURRENT-RULES.md:71–75`; ticket-15 ruling:8–9,119).

### 2.2 The single owner state machine

Writer states: ready, model_pending, tool_pending, waiting_resource, finishing, stopping, reconciling, terminal. Wait reasons: none, paid_exchange, paid_prepare, local_slot, local_buffer, workspace_capture, workspace_merge_back, ledger_tail, child_quiescence, effect_reconciliation. Unknown tokens hold. resume_state is required exactly for waiting_resource and is model_pending/tool_pending/finishing/reconciling; omit elsewhere. Other phases use none except stopping/reconciling may identify effect/child reconciliation. Open-token writer values, one existing owner (`T16:33–34`; `AS/loop_runtime.go:253–391`; D88 item 5; P2).

| Allowed transition | Identity/source condition (P2/P4) |
|---|---|
| absent → ready / reconciling | initialize only; original binding/policy/deadline; new operation generation 1. |
| ready → model_pending / tool_pending / finishing | advance; new operation, generation+1; fixed pending IDs; no stop/native ending. |
| model_pending / tool_pending → ready / finishing | advance; same operation/generation; matching committed child result or validated final ref/counters. |
| model_pending / tool_pending / finishing / reconciling → waiting_resource | advance; same operation/generation; resume_state=previous phase; actual busy/proof reason. |
| waiting_resource → its resume_state | advance; same operation/generation, fresh guard, no new child/counter. |
| any nonterminal without native ending → stopping | stop; new operation, generation+1 fences callbacks; retain old pending IDs; cancellation outranks shutdown. |
| stopping → finishing / reconciling | same stop operation/generation; bookkeeping only. |
| inert nonterminal → reconciling | reconcile; no live worker; new operation/generation+1 unless already reconciling. |
| finishing / reconciling → terminal | close; actual matching native/loop endings; same operation/generation; no executable pending. |
| state → same state | advance/reconcile for new committed child/counter/cursor/pending progress; no change means no new record. |

All other known-state edges refuse. A post-stop child callback is reconciliation evidence, not permission to take its old ready edge. Native EndTurn fixes its ending; owner.close may finish later despite a late RAM stop (`AS/loop_manifest.go:356–410`; `T16:34`; P2/P4).

1. After ordinary StartTurn and F3-15 bind, initialize **before enqueue**. A crash in the admission→bind→initialize gaps remains nondispatchable and is recovered from native records. Before a model/tool quantum, advance with its pre-minted operation/attempt/tool/native-command identities; its expected owner version/generation becomes the callback token.
2. Commit a waiting snapshot before reporting/parking a resource wait. Repeated wakeups at the same durable state do not append again. The runtime's ephemeral release generation is not serialized and is not compared to a prior incarnation's value; on restart it is irrelevant. In-process wake transitions `waiting_resource` back to the saved model/tool/finishing phase with the same operation ID/generation, after a fresh durable guard.
3. F3-11/13/15 journals remain the authorities for effects, holds and actual child outcomes. F3-16 is the owner state, not a replacement book. Owner snapshots record counters through their exact ledger prefix; between snapshots, reducers fold new paid intents/finished handler evidence into effective owner counters. Model calls count distinct committed paid dispatch intents, never admission, retry or wait. Tool counts retain current behavior: nonbusy completed/correction/stopped invocations once; resource-busy retries count zero. A crash with a started, uncompleted invocation counts it once when recovery records its unavailable/unknown result, as existing `stopTool` does. Repeated callbacks/recovery cannot count it again. No next quantum begins before the preceding owner advancement has reconciled these counts.
4. Pending metadata has a producer-only ceiling 128 entries (P1), additionally bounded by original policy and payload cap. Charge encoding/buffers through existing preparation; refuse request_too_large before excess, never truncate. Dormant contexts have no workers/timers/turns. Retain one current owner per unclosed turn; terminal payload history uses the existing directory/bounded cache. Per-context notice cursor projection is bounded by registered context/workspace bindings (`AS/doc.go:373–456`; `AS/loop_types.go:16–26`; ticket-15 ruling:61–63; P1–P2).

The guarded-turn additive reading starts only with an F3-16 owner. Paid/local dispatch and a tool atomic scoped command need current phase/operation/generation, exact pending ID and no persisted stop. Enforce in existing producer preflight **and replay**. Native endings/settlement keep original IDs and remain allowed after stop/revocation; old ownerless logs remain valid. Freeze this shared reading without changing older groups (`contract/ledger/doc.go:2300–2321,2850–2857`; `T16:34`; P1/P4).

### 2.3 Cold reads, lock order and views

Extend the ticket-142 command directory with a continuation selector by TurnID, used by current/historical status and command reconstruction. Use the **same** typed need, operation-local read set, two-unlocked-round bound, prefix/generation revalidation and staged acceptance path. No new scan service, cache, global lock or snapshot file. After unlocked owner-related reads, rerun the whole guarded phase; discard stale negative answers, stop predicates and plans. Preserve own-commit locked acknowledgement and SubmitAt retry behavior (`AS/doc.go:373–463`; ticket-142 ruling:15–29; P2).
The same directory indexes each promised native command ID in owner.pending to its turn, retaining selector metadata after terminal payload eviction. The scoped reducer can then reject a late never-run command after stop even though frozen atomic groups omit turn_id. Negative lookup needs existing coverage/generation proof and history fallback, never absence from the live-owner map (`AS/history_index.go:874–1187`; `AS/scoped_plan.go:11–65`; `contract/ledger/doc.go:1997–2015`; P1–P2/P4).

Lock nesting remains `Service.mu → loopRuntime.mu → historyIndex.mu`. Never wait or do I/O under runtime.mu, and never acquire Service.mu while holding it. Copy callback/live fields under the inner lock only; durable state wins on every rerun. OS waits, child I/O and workspace operations occur outside all three locks. Publish the accepted projection before acknowledging the transition; uncertainty poisons, it never becomes busy/success (`AS/doc.go:427–463`; P2, P4).

Extend `LoopRecovery` and Session `TurnView` with copied owner version, operation ID, generation, saved phase/wait reason, pending metadata, deadline and effective counters. Reconciliation reports `recovery_pending` as availability plus the **saved** phase/reason; it does not rewrite history to claim the turn was waiting for recovery before death. Exact originating session/context and current `turn.inspect` control disclosure. Keep existing historical old-family status fallbacks and all private heads unchanged (`AS/loop_types.go:44–71`; `AS/loop_session.go:142–187`; `AS/doc.go:197–220`; P2).


## 3. Crash, cancellation and result precedence

### 3.1 Inert restart followed by bookkeeping

Open reads no clock/credential source, appends/dispatches nothing and starts no scheduler. Metadata reduction reconstructs saved owner/pending/effective counters; existing integrity checks apply. Legacy unmatched F3-15 turns get inert recovery views only. EnableTurnLoop never enqueues reconstructed owners (`AS/service.go:164–215`; `contract/ledger/doc.go:3045–3063`; `T16:30,33`; P3).

Add trusted ReconcileLoop(ctx, LoopReconciliation{CommandID,TurnID,ExpectedOwnerVersion}) (ContinuationReceipt,error). Refuse live turns with BusyError{turn_active}. Use the context scope gate, mark reconciling (or initialize legacy owner), fix recovery command IDs before child-first progress. Legacy initialization verifies exact bound policy/deadline/limits, without clock/credential; missing/corrupt policy stays fenced. Return the receipt of the caller's owner.reconcile command, not a later internal command's receipt; current owner view reports progress. Same-ID retry preserves that receipt and may complete unfinished bookkeeping only through the already selected child/internal command IDs. After terminal it performs no work. New recoverer commands compare the then-current owner version. Missing proof returns typed recoverably pending, never resumed execution (`AS/scoped_admissions.go:64–91`; `AS/paid_reconcile.go:12–115`; `T16:33–34`; P3).

| Durable fact at recovery | Records/actions permitted; never reexecute |
|---|---|
| Ordinary admission without bind | Existing ReconcileAdmissions → F3-11 `work_ended(interrupted)` when child predicate permits. No invented owner input/turn manifest. |
| Paid reserved, no intent | Existing ReconcilePaid → F3-13 `paid_result(released_unsent)` and receipt, releasing only that proven-unsent hold. |
| Paid intent, no result | Existing ReconcilePaid → F3-13 `paid_result(unknown)` with its fixed recovery observation and receipt, retaining full exposure. Existing result/correction stays authoritative, including ticket 143's corrected scopes. |
| Tool start, globally absent native command | Under committing serialization prove absence and mark owner nondispatchable; F3-15 unavailable result with fixed metadata, no effect receipt (D166). Never submit that native ID later. |
| Native atomic receipt exists | Keep the effect and charge. If the outer tool result is missing, record `unavailable` with the actual native receipt, not “cancelled before effect” or a rerun. Existing known outer result is returned unchanged. |
| Local admitted but undispatched | ReconcileAdmissions → `released_unsent`; then outer unavailable result names its actual ending receipt. |
| Local dispatched but no completion | ReconcileAdmissions → `unknown`; outer `unknown_effect` names its receipt. Do not inspect file bytes to infer whether an edit ran. Holds remain. Existing proven local ending is retained. |
| Scratch observation/merge-back | Reconstruct F2 IDs and pending plans. Do not call CommitObserved/MergeBack/RetryMergeBack in restart bookkeeping. Already applied records/notices stand. Unobserved edits and unresolved prepared plans remain fenced for explicit workspace recovery, not lost or called successful. |
| Native turn ending already committed | It fixes the native outcome. Complete missing F3-15 loop.end once from committed owner/final refs and journal sources; no later cancel can relabel it. Never create a success answer from an unvalidated/missing final ref. |

Once native child endings exist, write native interrupted/cancelled ending as appropriate, one F3-15 transcript manifest/turn_result via existing `loop.end`, then F3-16 `terminal`. Recovery outcome is `interrupted`, reason `shutdown`, unless a persisted prior cancellation/native ending determines it. An earlier native `released` ending without a proven successful final uses F3-15 `failed/unresolved_result`, not invented model success. Recovery metadata publication uses the existing trusted metadata-only path, which works with no credential (`AS/loop_manifest.go:69–136,318–410`; `contract/ledger/doc.go:2963–2975`; P3).

Missing final/private objects and foreign materialization remain integrity fences; no repair feature. Unconfirmed resources stay fenced even after a turn becomes terminal; native endings govern slots, not permission to reuse affected scratch. Host startup explicitly bookkeeps unmatched loops before credential binding/EnableTurnLoop. Typed recoverably pending ledger items can be reported while unrelated contexts remain subject to their native capacities. **An unconfirmed global workspace process Owner is different:** current single-workspace executable startup fails closed, performs no Git recovery/sweep and enables no runtime using that workspace. Do not promise partial workspace availability or bypass its fence (`AS/doc.go:476–501`; `cmd/dwarf-harness/main.go:53–98`; `WS/service.go:119–183`; P3/P5/P9).

### 3.2 Durable precedence

Precedence: refreshed durable identity/prior matching receipt; committed native turn ending; persisted cancellation; shutdown; existing authority/integrity; deadline; limits; pending work. Preserve authority-before-deadline/clock rules. Rerun after cold unlock; owner permission never substitutes for a grant (`AS/loop_runtime.go:468–557`; `AS/loop_manifest.go:356–410`; `AS/doc.go:427–463`; `T16:34`; P4).

Session `turn.cancel` changes from waiting for final cancellation to returning the durable schema-7 stop receipt, `Outcome=\"accepted\"`, with data `{state:\"stopping\", owner_version, operation_id, generation}`. It means **stop accepted, effects may already exist**. Do not return a scoped terminal receipt until one actually exists. Same-ID retry returns that original acceptance even after completion; a different stop command on an already-stopping turn returns its current state with no extra stop, unless it mismatches a used command ID. Historical schema-2 cancellation retries still return their old receipts. Terminal status has `Outcome=\"too_late\"` without a new stop record; cancellation does not change a promotion request. Update terminal cancel handling to display acceptance and consume the later actual durable terminal event, not claim immediate prevention (`AS/loop_session.go:189–241`; `internal/core/session/doc.go:14–18`; `docs/CURRENT-RULES.md:63–65`; P4).

Callback token is (origin,turn,operation,generation,expected_phase,expected_owner_version,result_identity), fixed before unlock. Under Service.mu compare current owner/native source. Exact duplicate returns prior receipt; stale callback refuses inertly. After stop, authentic completions may settle/record/close **via reconciliation**, never ready a turn, publish an answer or start another effect. Committed intent is not prevented by later cancel; disclosure still needs current rights (`T16:34`; `AS/tool_execute.go:172–205,330–397`; `contract/ledger/doc.go:2929–2945`; P4).

Persist stop before cancel/notify. Shutdown drains quanta/HTTP/writers and records actual child/native/loop/owner endings, never relabeling already-ended natural work. Missing child proof returns typed error and retains fences. Host ordering agents→workspace→store propagates errors, not discards them (`AS/service.go:217–246`; `WS/service.go:259–281`; `cmd/dwarf-harness/main.go:59–78`; `T16:30,34`; P3–P5).


## 4. Concurrent writers and merge-back

Use actual Session→loopback SSE→paid capture→tool/native→workspace paths, not simultaneous calls to a fake service. The production concurrency policy remains one live turn/context, configurable agent cap (default three), colony capacity and one fair scheduler/appender. Existing APIs, grants and CAS remain authoritative; no test-only permissive validator or capacity override (`docs/ROADMAP-CORE.md:437–455,500–515`; `AS/doc.go:197–220`; P2, P8).

**Shared memory.** Two admitted turns of one agent read the same agent-memory revision, then a barrier releases both native `private.write` operations. Exactly one applies; the loser receives the existing conflict/current-version response, rereads, and explicitly submits at that revision. Assert two applied revisions, one stale refusal, exact resulting bytes containing both contributions and one charge per applied command. Retry the first successful command before/after reopen and prove no extra revision/charge. Never silently merge memory or automatically issue another model call to repair it (`AS/doc.go:47–90`; `AS/loop_conflicts_test.go:16–70`; D22 item 1).

**Task scratch.** A task's own turn holds its real Writer/lease; a second context of the same agent receives a temporary on its **first** write, forked at the acknowledged parent tip, not the mutable index/files. End each turn through the production finish path: CommitObserved exactly once per writer, close, then MergeBack as soon as the parent writer is gone. Persist an owner `finishing/workspace_merge_back` wait before parking for that handoff; never leave a live turn stranded `recovery_pending` merely because observation capacity is busy. Retain ticket-15's release-notifier/park rule (`WS/write.go:114–207,557`; `WS/doc.go:173–220,224–265`; `AS/loop_manifest.go:211–316`; ticket-15 fix ruling:8,18).

Cover (a) unmoved parent fast-forward, (b) moved parent with disjoint files, explicit three-way base and clean merge, and (c) both writing the same lines, durable conflict work with no semantic resolution. Clean applied results close the source with `temporary_merged_back`; conflict leaves it resumable and produces an exact author/path/report notice. No canonical ref moves and no accepted promotion is emitted. A crash after F2 prepared leaves the plan pending and fenced; only explicit workspace RetryMergeBack can continue its original ID/target. The runtime never turns that recovery into a replayed file tool (`WS/doc.go:224–274`; `docs/CONTRACTS.md:75–80`; D23, D52; P3).

**Independent continuations.** Three interleaved contexts have distinct input/memory/provider replay artifacts. Every real loopback continuation POST contains exact own replay bytes and no sibling result/artifact/history. Explicit new natural turns after reopen use only their committed transcript; interrupted turns send zero requests. Both providers, no live credentials. Runtime separation, not real-provider artifact acceptance (`AS/loop_continuation.go:197–298`; `AS/loop_start.go:265–387`; ticket-15 ruling:66,122–123; `T16:29–30,33`).


## 5. Child shutdown and resource fencing

### 5.1 Scope and in-layer interface

P5 covers all actual Git children, including `git version`/Inspect, worktree operations, capture's `cat-file --batch`, artifact streaming, observation and merge-back. File tools stay in-process, model dispatch stays HTTP; no shell tool, C4 validator, VM or A2 integration is added. The package name deliberately describes its only trusted caller, not a new arbitrary-process service (`WS/git.go:25–45,98–158`; `WS/capture.go:400`; `WS/artifact.go:363`; `docs/ROADMAP-CORE.md:432–436`; B30).

`gitprocess` imports standard library, `internal/core/durable`, and Windows-only `golang.org/x/sys/windows`; it imports no workspace, agents, provider, contract or winexec package. Its internal Go API is not frozen:

```text
Open(ctx, root string, Options{MaxConcurrent, MaxDescendants int,
     StopGrace time.Duration; RequireTree bool}) (*Owner, Report, error)
(*Owner).Run(ctx, Spec{Program string; Args, Env []string; Dir string;
     Stdin io.Reader; Stdout, Stderr io.Writer}) (Result, error)
(*Owner).Reconcile(ctx) (Report,error)
(*Owner).Close() error
Result: RunID, RootExited, TreeClosed, IOJoined, ExitCode,
        TotalProcesses, User100ns, Kernel100ns, PeakJobMemoryBytes
Report: copied pending RunIDs and fixed reason classes
ErrUnconfirmed: typed error retaining its underlying native cause
ErrUnsupported: Windows-tree mode is not available on this platform
```
RequireTree requests positive tree support: true refuses on non-Windows before filesystem/process effects; false still uses Jobs on Windows (never a bypass). Workspace sets true on Windows and false elsewhere. Open returns a locked nonnil Owner plus pending Report for valid unconfirmed fences, but Run is fenced until explicit Reconcile proves closure. Invalid root/fence formats return error and no usable Owner. Workspace startup calls Reconcile before version/other Git; unresolved proof closes admission and reports the typed error, never sweeps scratch. Reconcile terminates/joins only old exact Jobs, never launches/replays Git. One-shot Inspect has a new empty root. Close retains root lock if any I/O/native resource is still owned; concurrent Close gets the same stored error, not a false successful drain (P5/P9; `internal/core/winexec/doc.go:7–14`; `T16:30,34`).

One Owner per workspace Service at `<colony>/workspaces/processes`, durable root lock through Close. Each Run gets never-reused UUIDv7 runs/<id>; fence is safety metadata, not task/effect/accounting authority. Delete only the exact proven-closed directory. Cancel/time/epoch/age never erases unconfirmed fences (`internal/core/winexec/doc.go:7–14`; B30 item 2; `T16:34`; P5/P9).

Version/Inspect runs outside a Service use a one-shot Owner under a fresh private temporary directory, defer Close and join all I/O before returning. Refactor `newGitRunner` to accept the owner; production callers are `workspace.Inspect` (`WS/inputs.go:38–40`) and `workspace.openService` (`WS/service.go:183`). Update all test construction sites returned by its LSP references. Existing Git argv, four environments, 64-KiB stderr cap, accepted exits, cancellation matching and streamed stdout remain intact; no provider secrets or caller Job handles are inherited. Replace the single runOutput launch, not every Git call independently (`WS/git.go:109–154`; `WS/doc.go:21–57`; P5).

Proposed P5 safety settings: MaxConcurrent=8 Git roots/Owner, MaxDescendants=64 including root, StopGrace=5 seconds (existing drain scale). Semaphore admission is cancellable, copies no stream bytes and occurs outside global Service.mu/runtime.mu. Existing bounded workspace reservations may remain owned; Run takes only one Git slot and never waits recursively for a second. Release after confirmed drain; waiting releases nothing. Normal Git duration remains caller-context controlled. Calibration, not SLA; process-limit failure is a Git error, never expected clean exit (`WS/git.go:118`; `docs/ROADMAP-CORE.md:435`; `WS/doc.go:190–196`; D78; P5).

### 5.2 Windows creation, closure and crash fences

Build-constrained Windows code creates the Job with KILL_ON_JOB_CLOSE and ACTIVE_PROCESS, neither breakaway flag, non-inheritable Job handle, and an explicit three-standard-handle inheritance list. Launch through native CreateProcess suspended **with JOB_LIST at creation**, not `Cmd.Start` followed by AssignProcessToJobObject (that has an unowned-child race). Preserve Windows argv quoting and the exact environment/cwd. Apply/read back Job limits and membership before resume; native buffers crossing uintptr wrappers must be pinned. On any setup failure kill/join the suspended root and prove Job-zero, or retain the fence; never fall back to naked exec (`internal/core/winexec/job_windows.go:14–29,32–85,120–187`; B30 item 2; `docs/DESIGN-CORE-AND-LAUNCHERS.md:1004`; P5).

Fence bytes are strict compact UTF-8 JSON+LF, order format,version,root_id,run_id,job_name,windows_session_id,state,total_processes?; format dwarf-harness/git-process, version 1, states launch_pending/running/closed. Root identity.json is {format:"dwarf-harness/git-process-root",version:1,root_id}+LF, created once durably under root lock; validate real directory identity/reject links. Never-reused JobName is `Local\dwarf-harness-git-<root UUID>-<run UUID>`; existing name refuses. Flush/rename/sync launch_pending before native creation; running after creation before resume. Closed requires root exit/status, Job ActiveProcesses=0, empty PID list, joined I/O. Reuse proof, never success/refund (`internal/core/winexec/doc.go:7–14`; B30 item 2; `T16:30,34`; P5/P9).
The live-Run closed predicate above includes its captured root exit/status. Crash reconciliation cannot reconstruct an unrecorded exit code: under exclusive root ownership, exact named-Job zero proves all its atomically assigned processes gone; prior host I/O is joined by a prior clean Close or gone with the dead process (Close never releases ownership with pumps outstanding). Record only resource closure, expose unknown ExitCode=-1 for recovered runs, and never infer Git/tool success, effect absence or refund. Without that exact positive Job proof, retain the fence (P5/P9; `T16:30,34`; `internal/core/winexec/doc.go:7–14`).

Natural root exit triggers descendant termination/drain too: a background Git child cannot keep running after the command returns. Cancel/Owner.Close request TerminateJobObject and retain Job/root handles until proof. Job notification/EOF/kill success/root exit alone is insufficient. Drain streams concurrently with bounded fixed buffers; stop grace starts once at stopping and is not reset by late cancel. If a caller-provided stdin reader cannot be interrupted, its pump is still owned: refusal retains the resource and Close returns unconfirmed rather than falsely declaring joined. Workspace callers supply finite/cancellable streams, and artifact.Close must unblock the real pipe reader (`WS/artifact.go:353–380`; `internal/core/winexec/doc.go:7–31`; P5).

On abnormal Core death, noninherited last Job handles close and OS kills the tree. Fence stays unconfirmed. Reconcile under root lock may open the exact named Job in the recorded session, verify limits, terminate/prove zero and persist closed. Missing name/access denial/session mismatch/invalid identity/cleanup error never proves closure: ErrUnconfirmed, no Git/scratch/ref/index sweep or reuse. No PID-age/force-clear/reboot inference. Default last-handle crashes may stay quarantined despite externally proven exit; report the limitation (`internal/core/winexec/doc.go:7–14`; `WS/doc.go:257–265`; `T16:34`; P5/P9).

Require distinct native paths: last-handle Core death with **process** observer handles only, and deliberate retained-Job ambiguity followed by positive Job-zero reconciliation/same-root reuse. Extra Job handle invalidates the first proof. Product never trusts observer counts; missing-Job resources stay fenced. Root-only/held-descendant controls prevent vacuous zero observations (B30 observer caveat; `T16:30,34`; P5/P9).

### 5.3 Platform and host ordering

gitprocess_windows.go implements Jobs. gitprocess_other.go preserves existing CommandContext/root-Wait for ordinary portable Git, but Open with RequireTree=true returns ErrUnsupported without effects; TreeClosed is never inferred from Unix root exit. Shared neutral ownership remains portable. Windows-only native proof; three-OS neutral runtime/restart/passive tests; no process-group/A2 claim (`docs/CURRENT-RULES.md:46,48`; `docs/ROADMAP-CORE.md:959–961`; D138; P5).

Open/reconcile the Windows process Owner **before** workspace Open invokes version inspection or reconciliation Git. On an unconfirmed fence, do not run the existing workspace orphan/ref sweep; return typed report/error and keep the affected workspace closed. Close cancels process calls before waiting for workspace ops, but the executable's higher-level order still lets agents finish their writers first. Every process result/error is joined before service root lock release; concurrent Close callers get the same stored close error, not nil. `cmd` cleanup aggregates and reports a fixed failure class without paths, retains the store through durable endings, and returns failure when any shutdown proof fails (`WS/service.go:119–183,259–281`; `AS/service.go:217–246`; `cmd/dwarf-harness/main.go:35–78`; P3, P5).

Assistant rule record (D151): **“Admit `golang.org/x/sys/windows` in exactly `internal/core/gitprocess` and its test variants for Windows Git-child lifetime ownership; all other allowlist entries and boundaries remain unchanged.”** Add that exact package to xSysUsers and one allowed/one rejected-subpackage fixture in `tools/check/boundary_test.go`; no module/version/toolchain change (`go.mod:13`; `tools/check/boundary.go:73–84`; `docs/CURRENT-RULES.md:31,48`; D151).

Primary native semantics checked during this design: Microsoft Learn, [Job Objects, “Managing Job Objects”](https://learn.microsoft.com/en-us/windows/win32/procthread/job-objects#managing-job-objects), [CreateJobObjectW, “Remarks”](https://learn.microsoft.com/en-us/windows/win32/api/jobapi2/nf-jobapi2-createjobobjectw#remarks), and [OpenJobObjectW](https://learn.microsoft.com/en-us/windows/win32/api/jobapi2/nf-jobapi2-openjobobjectw). They distinguish last-handle termination from root exit and warn that ordinary Job notifications are not reliable proof. The design deliberately does not promote missing-name lookup into positive closure.


## 6. Passive result presentation

P6 builds the missing natural-turn consumer of existing F2 notices. At an explicit/new naturally authorized task turn's render, identify its own current dedicated scratch from the existing binding; request `ScratchNotices(taskContextID,taskScratchID,after)` and include only complete notices with their sequence, source/parent scratch, authoring context, outcome, written paths and conflict-report reference. Exact request identity stays fixed. Store selected notice metadata and through-cursors in that turn's immutable input object (a **new private input schema 2** beside schema 1, not a ledger-family change); render a fixed “Task scratch results” block before Owner input and before the D25 active-work tail (`WS/mergeback.go:392–399,575–600`; `AS/loop_start.go:265–387`; D23, D63).
Exact private input schema-2 key order: schema,kind,origin,turn_id,text,artifacts,other_work,task_results,notice_cursors. Existing first seven fields retain schema-1 meaning; kind remains owner_input. New required arrays may be empty. task_results entries are sequence,merge_back_id,scratch_id,parent_scratch_id,authoring_context_id,outcome,written_paths,changed_paths,conflict_sha256? in that order; source each value from the exact F2 notice, path arrays in frozen byte order; omit conflict digest when absent. NoticeCursor is §2.1's shape. Verify each source record against the immutable selected notice; no arbitrary text or body content enters this metadata. Snapshot selection does not authorize disclosure: loopBoundary rechecks the same task/assignment/scratch/read rights before every paid send, and stops authority_lost rather than rebinding a saved notice to a replacement task. Re-rendered historical input validates schema 1 or 2 by its own schema, never silently upgrades bytes (P6; `WS/mergeback.go:392–399,575–600`; `AS/loop_start.go:265–387`; `T16:31,34`).

Notice binding is not permission. Check current task assignment/generation and origin's file.read root/private inspection authority before paths/existence. Sibling/revoked contexts get no count/hash/path; author identity grants no other memory. Conflict bodies need authorized artifact reads. Input schema 2 keeps schema 1 decoding, fixed selected sources/retry prefix and existing secret/content bounds (`AS/doc.go:123–165,511–559`; `WS/doc.go:267–274`; `T16:29,31,34`; P6).

The F3-16 per-origin cursor advances only to notices actually selected for an admitted natural turn **after its first paid dispatch intent commits**; this prevents failed/busy starts from consuming results. It is presentation progress, not deletion or authority. If a crash occurs before that cursor transition, the next natural turn may repeat the same notice with its same identity; no exactly-once display promise. Cursor survives terminal owner eviction/reopen through the ledger, using the existing cold-read protocol. A cursor never causes a start/wake/model call; status remains available immediately. At no point does completing a merge create a completion-only POST (`AS/loop_start.go:118–134,227–244`; `AS/loop_continuation.go:131–150`; `docs/CURRENT-RULES.md:63`; P6).

This ticket proves real scratch notices and ordinary finalized turn results. `promotion.request` remains `no_validator`, writes no acceptance and starts no model call. Test accepted/failed/no-change promotion **presentation** only where an already frozen, genuinely produced original-context result exists; do not add synthetic runtime promotion success to make a proof. Ticket 17/C4 owns real validation/promotion producers (`AS/loop_promotion_test.go:17–77`; `docs/ROADMAP-CORE.md:447–450`; `T16:31`; D52).


## 7. Measurement and declared resource profiles

### 7.1 Workload and labels (P7)

No criterion demands a numerical performance threshold; propose **none**. Therefore no predesign acceptance-driver CPU profile is required or claimed. Ticket 142's profile/results explain the existing mechanism, not a fresh T16 baseline: the four-cell fixed matrix took 3,322 s, and Open still took 45–118 s/cell; prefix hashing and linear directory metadata remain real costs (`.scratch/dwarf-harness/c3-evidence/ticket-142-evidence.md:69–83`; `AS/doc.go:373–419`). If the advisor introduces a numerical bound, stop that portion and obtain the D160 current-main profiled driver run **before** ruling the bound; never retrofit a threshold after seeing T16 results (`docs/CURRENT-RULES.md:33–35`).

Owner's actual larger enrollment is **60 contexts**, with doubled per-context traffic (`docs/DESIGN-CORE-AND-LAUNCHERS.md:1182`; B21 “Owner answers”, OG3). Do not silently reinterpret it as 60 agents ×20 contexts. Proposed exact matrix, one invocation in this order:

| Row label | Agents | Dormant contexts/agent | Active turns/agent | Script repetitions |
|---|---:|---:|---:|---:|
| `runtime-12x20x1` | 12 | 20 | 1 | 2 |
| `runtime-12x20x3` | 12 | 20 | 3 | 2 |
| `runtime-20x20x1` | 20 | 20 | 1 | 2 |
| `runtime-20x20x3` | 20 | 20 | 3 | 2 |
| `actual-60-contexts` | 20 | 0 | 3 (60 enrolled contexts total) | 2 |

First four rows preserve 15/142's dimension convention, with doubled traffic explicitly new. P10's actual row is 20 agents with general+two work contexts, no extras: exactly 60. Each active context executes five scripts twice: private CAS, scoped file loop, clean temporary merge, conflict merge, private continuation/passive-next-turn. Admit each declared attempt once; busy is unfinished, never silently retried or counted as throughput. Also report admitted-only throughput/outcomes (`ticket-15-design-ruling.md:45`; `docs/ROADMAP-CORE.md:491,500–515`; B21 OG3; P7/P10).

Transient AS/zz_t16_measure_test.go (or overlay), TestT16RuntimeProfile, uses real Session/stores/workspaces/loopback TLS-SSE and fixture credentials. Retain source outside product. Header records policies, paid caps, buffers, workspace/process settings, exact payload bytes/tools hash. Synthetic usage is labeled, not actual tokenization. Alternate both providers by context; no external provider/key (`T16:32`; ticket-15 ruling:45,61–68; P7).

Short groups: restart-{paid_wait,local_wait,merge_wait,dispatch_unknown}, kill at durable barrier and reopen/bookkeep twice; Windows children-{natural,cancel,core_death,retained_job_fence}, exact root/descendant proof/reuse-refusal. Reuse §8 workloads and exact raw origin/operation/generation joins (`T16:30,32–34`; P7).

### 7.2 Figures, execution and acceptance

Per row record attempts/admitted/busy/denied/finished/cancelled/interrupted/failed/unfinished, exact POST/tool/effect counts, backlog at barrier/release/end, setup/open/reconcile/drain elapsed nanoseconds, command→first POST/live/durable final and reopen durations, per-outcome n/min/p50/p95/max, cancellations and clock-held/censored samples. Monotonic in-process measurements are distinct from ledger EventTimeNS causal intervals. Record whole-process CPU user/kernel, peak working set/RSS, sampled Go heap high-water explicitly a lower bound, goroutine peak, actual Git roots/descendants peak and totals, retained ledger/private-object/scratch/run bytes, directory selectors/boundaries/charged bytes, cache/token counts and financial held/settled/unknown amounts by exact scope. Directory charge is not RSS and no observed zero-resolution duration means zero cost (`docs/CURRENT-RULES.md:35`; `AS/doc.go:373–427`; ticket-142 ruling:104–107; P7).

Persisted intervals measure **durable wait-phase residence**, not isolated acquisition. Keep wait kind/operation/generation/start-end sequence; missing ends censored. Preserve 142's five ledger causal-envelope labels separately, never call either provider latency. Count owner fsync/rehash transitions/bytes per completed turn without subtracting their real end-to-end cost (`T16:32–33`; ticket-142 ruling:37–42,104–105; P2/P7).

PM runs each instance (smokes included) through `quiet_run.py`, serially on a quiet machine, with runner-owned admission record and raw stdout/JSONL retained by path and SHA-256. One smallest smoke (1 agent, 1 dormant, 1 and 3 active variants, one repetition) precedes the one full matrix. One invocation per short profile group. No base/cohort repetitions or machine restart is required by this figure-only proposal; a process-restart profile is not a cold-machine measurement. Tests assert counts/invariants, not durations. Driver watchdog is policy deadline plus a fixed 60-second observation grace, then one final status query and **unfinished failure**, never silent shutdown-as-success. Whole driver command uses an operational `-timeout 12h`, not a product SLA (`docs/CURRENT-RULES.md:33–35`; ticket-15 fix ruling:24,81–84; P7).

One Since page/agent/wake, terminal-derived outcomes, at most one end status/context; no hidden polls/retries/warmup. Analyzer requires all rows/scripts and consistent native identities/holds/reopen/child proof; any such failure fails regardless of exit. Busy is uncompleted, not the intended script's pass; correctness fixtures admit all named turns. Actual-60 row/child proof are mandatory (`ticket-15-fix-ruling.md:81–85`; `ticket-142-design-ruling.md:104–107`; `T16:29–34`; P7).

Exact final public branch SHA requires the existing Windows/Linux/macOS full CI matrix and successful Check result. No workflow edits, new secrets, service accounts or private-remote recreation are necessary; public D153 CI satisfies the current hosted prerequisite and no live-credential prerequisite is invoked. Capture exact SHA, run/attempt, three native job results and aggregate; cross-builds alone are not native proof. T16 does not itself mark C3 Done while 90/91 remain (`docs/CURRENT-RULES.md:8,18–20`; `docs/ROADMAP-CORE.md:500–516`; assignment “Gates already met”).


## 8. Tests, rule breaks and fuzzing

### 8.1 Consumer-visible regressions

Real stores/commits/objects/files/Git/loopback HTTP; hooks place barriers, not outcomes. No mocks, fake successful validator, source assertions, sleeps or duration assertions. Parallelize independent fixtures; real-kill/process-state orchestration may be sequential. Preserve approved rows except genuinely superseded cancel assertions (`T16:38`; `docs/CURRENT-RULES.md:14–17`; ticket-11 ruling:29; P8).

| Required test/rows (new unless “extend”) | Observable contract; plausible bug that fails it |
|---|---|
| `TestContinuationContract` / `TestGoldenF3_16` | Every ordered member/group, recursive duplicate/null/extension/size/overflow boundary, exact schema-7 preimages, independent unknown-token hold, all existing fixtures unchanged. Wrong digest/order or accepting oversized complete receipt fails exact decode/replay. |
| `TestContinuationFrozenReplay` | Full F3-16 golden through real Core Open, including earlier-family setup, no append/clock/dispatch; invalid transition/effect link is rejected without a partial projection. Also replay all old F3 goldens with no new owner records. |
| `TestTurnLoopPersistedWaits` | Barrier rows paid exchange/preparation, local slot/buffer, finish capture/merge, ledger-tail and child proof: observe exact durable phase/origin/operation/generation/pending IDs/deadline/counters, kill/reopen, compare reconstructed metadata and zero sends. Dropping each wait transition or resetting deadline fails. |
| `TestTurnLoopCrashRecovery` | Real process kill at admission-before-bind, bind-before-owner, paid-admit-before-intent, intent-before-response, response-before-observation, tool-start-before-native, local dispatch before/after file mutation, atomic receipt-before-outer-result, F2 prepared-before-applied, native-ending-before-loop.end, loop.end-before-owner.close, and owner-ack-before-host-ack. Exact POST/file/revision/receipt counts before and after two recoveries distinguish definite unsent, unknown and known effects. Rerunning a started effect or inventing a success fails. |
| `TestTurnLoopCancelResultRace` | Channel barriers choose cancel-first, effect/intent-first, native-ending-first, stale generation, duplicate callback, same-command lost acknowledgement, and cancel during unlocked cold need. Inspect actual native receipts/status/ledger and exact effects; stop intent survives death before RAM signal; terminal never readies again. Ignoring one CAS dimension or discarding intended effects fails. |
| `TestTurnLoopWaitingHolds` | Saturate one real paid/local/child resource, enter durable wait, cancel, reopen and reconcile twice. Exact full held amounts/scopes remain for sent/unknown, unsent release happens once, known settlement/correction stays exact, no POST on wait. An erroneous “waiting releases all” change fails. Reuse ticket 143's post-landing semantics rather than reimplement corrections. |
| `TestTurnLoopConcurrentPrivateRuntime` | Three actual overlapping contexts, memory CAS winner/loser+reread, one-live-turn exclusion, native reservation ceilings and exact per-context provider replay sentinels. Duplicate effects, pooled artifact history, stale overwrites or double context run fail counts/bytes. Extend existing admission/fairness/conflict/provider rows, do not replace them with scheduler mocks. |
| `TestTurnLoopTemporaryMergeBack` | Task turn plus two same-agent contexts; first-write temporary creation, fast-forward, moved-parent clean merge, conflict, cancel while parent writer held, process crash with prepared merge. Assert exact files/trees, authors, preserved conflicts and one observation/application. No early parent mutation or rerun at Open. |
| `TestTurnLoopPassiveResults` | After real merge completion and after reopen: zero extra POST/turn; original task status exposes same result; next explicit natural turn's captured request includes exact complete notice; sibling gets none. Failed/busy pre-intent starts consume no notice; crash at cursor acknowledgement may replay same identity but never lose it. No fabricated promotion success. |
| `TestGitProcessTree` (Windows) | Real root-only and root+held System32 descendant controls; natural root exit, cancellation, Close and root kill. Retained process handles signaled, Job count/PID list zero, pumps joined before Run/Close returns or same root is reused. Ignoring descendants/root-only Wait fails. |
| `TestGitProcessCoreDeath` (Windows) | Parent starts a real Core helper, waits for root+descendant readiness, retains process handles **not a Job handle**, kills Core and joins it; observes every identified descendant signaled. Reopen must retain missing-Job unconfirmed fence, perform zero Git calls and no scratch sweep. No “Job absent means closed”. |
| `TestGitProcessRetainedJobRecovery` (Windows) | Deliberate external retained Job reference, Core killed, second opener cannot reuse active resources; Reconcile opens exact Job, terminates/proves zero, persists closure, and only then admits a fresh Run with a fresh RunID. The held reference means this is not kill-on-last-close evidence. |
| `TestGitProcessFenceErrors` | Corrupt/truncated/duplicate-key fence, wrong root/session, existing Job-name collision, failed durable fence write, failed Job query/close and unjoined stream. Each refuses launch/reuse and retains exact safety state. Test a definite prelaunch failure separately from postlaunch uncertainty; no broad cleanup. |
| `TestGitRunnerTreeOwnership` (Windows, workspace) | Actual runOutput runs real Git with fixture-only alias/held descendant. Cancel/Close/natural-root cases observe retained descendant handles and resource reuse/refusal, not a callback echo. A naked-Start bypass leaves a descendant alive and fails. Existing capture/artifact/merge tests retain exact observable trees/bytes. |
| `TestGitProcessUnsupported` (non-Windows) | Explicit Windows-tree operation refuses without starting a process; ordinary Git still works through portable fallback and reports no tree proof. A success-shaped unsupported result fails. |
| Extend `TestTerminalCancel`, `TestTerminalDrain`, `TestTurnLoopTerminalSmoke`; add `TestRuntimeRestartStartup` | Real terminal/Session stream acknowledges stop acceptance, then displays actual terminal outcome; executable startup bookkeeping starts zero provider calls for old turns, preserves counts and propagates child-close failure. No full wire-protocol work. |
| Extend `TestImportBoundary` | New exact adapter admitted in Windows fixture; subpackage/unlisted importer remains refused on every target. No broad Core wildcard. |

Use System32 cmd.exe descendants at explicit pipe/readiness barriers in both builds, not unqualified race-instrumented Go grandchildren. Fixture alias exercises real Git, never product configuration. Parent owns/joins exact helper handles; no timeout/empty observation/unsupported Windows host counts as a passing proof (B30 item 3; `internal/core/winexec/doc.go:7–14`; `T16:38`).

### 8.2 D152 deliberate rule breaks

Each required mutant is in the new changed code, produces its stated observable harm, makes the named regression red and is restored byte-identically before the final green. If the literal mutant is unreachable in the built implementation, coder proposes the **same bug class** at the actual new guard and cites reachability; never mutate untouched paid cap code merely to claim a money break (`docs/CURRENT-RULES.md:14–17`; P8).

| Break | Red test and observable harm |
|---|---|
| Recovery: omit durable resource-wait publication or enqueue reconstructed owner | PersistedWaits / CrashRecovery: missing saved wait or an extra POST/native effect after reopen. |
| Recovery: drop operation/generation/current-state revalidation after cold unlock, or allow terminal→ready | CancelResultRace: stale callback changes ending, sends or readies work. |
| Recovery: on missing tool result call the executor again instead of journal reconciliation | CrashRecovery: exact file edit/atomic revision or POST count increases after restart. |
| Money: treat durable wait/unknown as released_unsent or refund a sent hold | WaitingHolds: exact held scope amounts fall or capacity admits a forbidden new paid attempt. |
| Authority/disclosure: omit final notice task/context permission check | PassiveResults: sibling/revoked context receives a path, author or report identity. |
| Child/sandbox boundary: resume before atomic Job assignment, allow breakaway, or accept root exit as tree closure | GitProcessTree / CoreDeath: real held descendant survives or resource is reused with active children. This tests lifetime, not a new A2 claim. |
| Recovery/resource safety: erase unconfirmed fence on missing Job, query failure or cancel | CoreDeath / FenceErrors: opener launches Git or sweeps shared resources without positive proof. |
| Recovery: let duplicate reconcile create a second ending/charge/observation | CrashRecovery / WaitingHolds: receipt/revision/charge count differs on second reconcile. |

No credential-store/provider framing change is proposed, so no invented credential mutation campaign is required. Keep existing secret/replay/privacy rows green; if implementation changes those paths, their existing relevant breaks become required as well (`docs/CURRENT-RULES.md:14–17`; P8).

### 8.3 Fuzz obligations and commands

S1 new `FuzzDecodeF3_16`; S2 new `FuzzContinuationGroupReplay` (valid fixture once, fuzz operation groups/state/version/pending/source/order) plus existing `FuzzPrivateGroupReplay`, `FuzzScopedGroupReplay`, `FuzzPaidGroupReplay`, `FuzzLoopGroupReplay` because the shared acceptance/native guard paths change. Add existing review/registration group targets if the common replay dispatch change reaches their fuzzed code. S3 new `FuzzGitProcessFence` against the pure strict fence codec, not random native process creation. S4 existing `FuzzLoopTranscript` because input/render source parsing changes, plus new `FuzzLoopInput` for schema-1/2 private input. No provider/SSE decoder change is planned (`docs/CURRENT-RULES.md:17`; `AS/loop_fuzz_test.go:58,203`; P8).

Coder runs each slice's focused tests and one verbose package run, host gofmt/vet/staticcheck, fuzz **seed corpus only**. PM runs each new/changed-code target for 120 s at `-parallel=1`; no designer commands or test output are claimed here. Use pinned Go/local toolchain with explicit CGO_ENABLED=0; local races alone use CGO_ENABLED=1 and the already pinned off-PATH llvm-mingw CC. All package timeouts below are command watchdogs, not test assertions (`docs/CURRENT-RULES.md:14–21,46`; D152).

```text
# Common per changed package
GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -v -timeout 30m <packages>
GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go vet <packages>
staticcheck <packages>
gofmt -l <owned Go files>

# Concurrency/shared-state slices, with pinned race CC set by the PM assignment
GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=1 go test -race -count=1 -timeout 30m <changed concurrent packages>
GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=1 go test -race -count=20 -timeout 30m -run '<slice rows below>' <package>

# PM only, one target per command, independently retained
GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -run '^$' -fuzz '^<target>$' -fuzztime=120s -parallel=1 -timeout 30m <package>

# PM only, through quiet_run.py, never -race
GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -run '^TestT16RuntimeProfile$' -timeout 12h ./internal/core/agents
```

S1 also regenerates its new golden, verifies every earlier golden digest unchanged, checks fixture LF/no CR and runs `go test -count=1 ./internal/core/ledgerstore`; current Core must accept the **earlier-family setup prefix** before review, then S2 proves full-family replay. Five-target vet/staticcheck only for S3's build-constrained changes (linux/amd64, linux/arm64, darwin/amd64, darwin/arm64, windows/amd64). Hosted exact-SHA checks remain mandatory for every slice; no duplicate routine local tools/check (`docs/CURRENT-RULES.md:14–20`; D125; ticket-15 ruling:119).
Concrete slice package/row expansions for the command templates above (P8; `docs/CURRENT-RULES.md:14–17`):

```text
# S2 plain/vet/staticcheck package set:
./internal/core/agents ./internal/core/session ./internal/core/terminal ./cmd/dwarf-harness
# S2 package race:
go test -race -count=1 -timeout 30m ./internal/core/agents ./internal/core/terminal ./cmd/dwarf-harness
go test -race -count=20 -timeout 30m -run 'TestTurnLoop(PersistedWaits|CrashRecovery|CancelResultRace|WaitingHolds)' ./internal/core/agents
go test -race -count=20 -timeout 30m -run 'TestTerminal(Cancel|Drain)|TestTurnLoopTerminalSmoke' ./internal/core/terminal
go test -race -count=20 -timeout 30m -run '^TestRuntimeRestartStartup$' ./cmd/dwarf-harness
# S3 plain/vet/staticcheck package set:
./internal/core/gitprocess ./internal/core/workspace ./tools/check ./cmd/dwarf-harness
go test -race -count=1 -timeout 30m ./internal/core/gitprocess ./internal/core/workspace ./cmd/dwarf-harness
go test -race -count=20 -timeout 30m -run '^TestGitProcess(Tree|CoreDeath|RetainedJobRecovery|FenceErrors)$' ./internal/core/gitprocess
go test -race -count=20 -timeout 30m -run '^TestGitRunner' ./internal/core/workspace
# S4 plain/vet/staticcheck package set:
./internal/core/agents ./internal/core/terminal ./cmd/dwarf-harness
go test -race -count=1 -timeout 30m ./internal/core/agents ./internal/core/terminal ./cmd/dwarf-harness
go test -race -count=20 -timeout 30m -run 'TestTurnLoop(ConcurrentPrivateRuntime|TemporaryMergeBack|PassiveResults|CrashRecovery)' ./internal/core/agents
```

Apply the already stated race environment/pinned CC to these concrete race commands. Real-kill rows are not exempt from the affected-row twentyfold gate; retain their readiness/process controls in every instance. S4 reruns the S2 terminal/startup twentyfold commands if those concurrent paths change. No serial-by-default fixture or duration assertion is added to make repeats pass.



## 9. Slice plan and exact owned paths

Four fresh-reviewed slices (P8). S2 is the coherent owner/replay/dispatch boundary; S4 adds passive rendering/cursors and integrated proof/figures. All six criteria finish here, no implementation follow-up (`docs/CURRENT-RULES.md:10–17`; `T16:29–34`).

| Slice | Exact production ownership and deliverable | Focused/race evidence |
|---|---|---|
| **S1 — additive F3-16** | New `contract/ledger/{continuation.go,continuation_submission.go}`; modify `contract/ledger/{catalogue.go,doc.go}`. New codec/golden/compatibility/fuzz tests and `testdata/f3/16/` fixtures. Public freeze additions in `docs/{CONTRACTS.md,DESIGN-CORE-AND-LAUNCHERS.md}` and private freeze record by drafter/PM, not designer. Complete codecs/docs/golden; no agents producer. PM freezes after joint review, then S2 can compile against it. | `go test -count=1 -timeout 30m -run 'TestContinuation|TestGoldenF3_16' ./contract/ledger`; plain/vet/staticcheck for contract/ledger; golden/earlier hashes/ledgerstore consumer; new decoder fuzz. No concurrency change, so no local package race/×20. |
| **S2 — one durable owner** | New `AS/{owner_types.go,owner_journal.go,owner_replay.go,owner_recovery.go,owner_guard.go}`. Modify `AS/{service.go,types.go,scoped_state.go,replay.go,history_index.go,history_prepare.go,loop_types.go,loop_runtime.go,loop_start.go,loop_continuation.go,loop_journal.go,loop_replay.go,loop_manifest.go,loop_session.go,tool_execute.go,scoped_plan.go,scoped_work.go,scoped_execute.go,scoped_submit.go,paid_plan.go,paid_dispatch.go,doc.go}`; `internal/core/session/{types.go,doc.go}`; `internal/core/terminal/terminal.go`; `cmd/dwarf-harness/main.go`. Complete owner/replay/native guards, inert Open/startup bookkeeping, cancel acceptance/views. S3 supplies actual Windows resource proof, no child-success stub. | Focus §8.1 owner/recovery/race/holds/startup/terminal rows; plain changed packages; whole-package race and twentyfold affected rows exactly §8.3, including process-kill rows. Recovery/money breaks and replay fuzz. |
| **S3 — actual Git-child lifetime** | New `internal/core/gitprocess/{doc.go,types.go,owner.go,fence.go,gitprocess_windows.go,gitprocess_other.go}`; modify `WS/{git.go,inputs.go,service.go,doc.go}`, `cmd/dwarf-harness/main.go` startup/drain errors, `tools/check/boundary.go`; tests in gitprocess/workspace and tools/check boundary fixtures. PM records importer rule/digest; no winexec edit. | Focus TestGitProcess*, TestGitRunner*, TestImportBoundary; plain changed packages; whole-package race and twentyfold affected native/workspace rows in §8.3 with controls, including CoreDeath. Five-target vet/staticcheck, fence fuzz, lifetime/resource breaks. |
| **S4 — integrated/passive/profiles** | Modify `AS/{loop_start.go,loop_runtime.go,loop_manifest.go,owner_types.go,owner_replay.go,owner_journal.go,doc.go}` for schema-2 input/cursor/render and resend-time rights. Formatting-only optional `AS/tool_results.go`; `internal/core/session/doc.go` and `internal/core/terminal/doc.go` only if view clarification needed. Integration/crash/passive/terminal tests and external measurement/analyzer. Public ticket/status/register close/private evidence by drafter/PM; C3 waits for 90/91. | Focus integrated/merge/passive/crash/terminal/startup tests; plain changed packages; whole-package race and twentyfold affected rows §8.3. Disclosure/recovery breaks, input/transcript fuzz, quiet §7 profiles, exact-final-SHA three-OS green. |

The table names **every anticipated production path**, including platform files, boundary enforcement and executable composition, so PM can order concurrent tickets. `tool_results.go` is an explicitly bounded formatting-only allowance, not a general “whatever is necessary” path. Test-only callsite migrations within those changed packages are preauthorized and listed with reasons in each coder yield. Any additional production file requires PM ownership approval rather than an unreviewed expansion. Symbol references already located: `commitLoop` has four producer callers (`loop_start`, `tool_execute` twice, `loop_manifest`); EnableTurnLoop has executable+fixture callers; LoopRecovery has `types.go`/loop views; Session TurnView flows through loop/session/terminal status. Coder reruns LSP references at its actual base before changing exported types/signatures (`AS/loop_journal.go:40`; `AS/loop_types.go:44`; `internal/core/session/types.go:64`; role D160).

**Scheduling beside 143/144:** do not begin S2 on paid_plan/paid_dispatch/replay until 143 lands as assigned. Carry its correction semantics/tests intact and record the new actual slice base; no live-money test is needed. S3 touches no winexec file, so 144 can proceed independently; no copying or “fixing” its tests here. Reuse existing winexec native patterns as design precedent only, not by import or cross-package helper extraction (`go.mod:13`; assignment “Tickets running beside it”; `docs/CURRENT-RULES.md:8,48`).

After successful smoke/profiles, retain the driver/analyzer source and logs by SHA-256 outside the worktree, remove any throwaway product test/overlay/build artifacts, leave all cited evidence reachable, and update package/user documentation for cancellation acceptance, inert restart, child-quarantine limitations and platform support. There is no new decision build-history entry: only F3-16 freeze and D151 importer-rule records require standing-rule entries, with corresponding digest lines. Owner-state and resource-closure facts go in ticket evidence, not handoff churn (`docs/CURRENT-RULES.md:25–31`; D160, D161).


## 10. ownerGates

**None is proposed.** This recommendation neither changes an owner decision nor claims the advisor has approved it.

- **Frozen contracts:** F3-16 is additive and PM-frozen under D125. Earlier families' bytes/closed sets/groups remain unchanged; the guarded-turn reading applies only after new owner records. No breaking alternative is proposed, so there is no breaking-contract owner question in this design. If the advisor rejects that additive approach, its new ruling must enumerate the concrete changed family/version/readers and exact breaking-change approval question before any such work (`docs/CURRENT-RULES.md:71–75`; D165–D166).
- **Dependencies/toolchain:** x/sys v0.48.0 already exists. The new exact importer/allowlist entry is an assistant rule decision (D151), not new dependency approval. No module, version, cgo or toolchain change (`go.mod:1–14`; `docs/CURRENT-RULES.md:31,46,48`).
- **C10:** no winexec dependence/integration or A2 claim. Lifetime-only host Git ownership has no new access-control authority. If advisor selects earlier winexec integration instead, exact reserved question: **“Do you authorize ticket 16 to depend on and integrate the Windows containment executor now, ahead of the C10 integration status gate, solely for the listed testing-only child-lifetime paths and with no A2 claim?”** Not selected here (`docs/ROADMAP-CORE.md:959–961`; B30; P5).
- **Scope/slices:** all six criteria remain in four slices, no split/deferred criterion. Any later split needs an exact criterion/destination owner question after a new ruling, never silent narrowing (`T16:29–34`; `docs/CURRENT-RULES.md:10–11`).
- **D52, money, keys, accounts, machine and workflow:** approved testing-only promotion boundary unchanged; no live provider call, credential provisioning, spending authorization, machine restart, new account or `.github/` edit. Process-kill drills kill only explicitly owned test helpers, not the owner's host/session. Quiet-run scheduling and figure-only profiles are PM matters. The historical 60-context/doubled-traffic fact is reused, not reapproved (`docs/CURRENT-RULES.md:31,37–39,63–66`; `docs/DESIGN-CORE-AND-LAUNCHERS.md:1182`).

There is therefore no question to batch to the owner on this proposed design. If the ruling selects one of the conditional reserved alternatives above, it must list the exact selected question in its ownerGates; PM asks all selected gates together before their blocked work (D160).
