# Ticket 91 — service loss and restoration for every agent

## Owner first

Record availability, not authority: the same Core state covers workers and officers, never elects a replacement, and never spends to diagnose or recover. Build after ticket 16 closes. Recommend an additive F3-91 freeze, then the detector/reducer, then runtime/terminal integration; no criterion is deferred. The numbered proposals below require the advisor's ruling; owner-reserved questions are collected in §9.

Source shorthand: **T91** = `.scratch/dwarf-harness/issues/91-record-service-loss-and-restoration-for-every-agent.md`; **Core** = `docs/DESIGN-CORE-AND-LAUNCHERS.md`; **AS** = `internal/core/agents`; **LD** = `contract/ledger/doc.go`. Paths are repository-relative. Decision references name entries/headings, not decision-log line numbers. Main code citations use assignment base `c1d06b399f13bbb54626d10a5a90403cd89d1396`. **G16** denotes `internal/core/gitprocess` at ticket 16's readable c95a456 integration checkpoint, not code claimed present on that base. The coder must rebind those few citations after 16 lands; no fence filename/encoding is consumed here.

Precedent references “ticket-13 ruling”, “ticket-15 ruling” and “ticket-142 ruling” mean their exact `.scratch/dwarf-harness/c3-evidence/ticket-N-design-ruling.md` files. Ticket 16's brief/ruling/clarifications are the assignment-named local artifacts, not assumed published repository files; their settled outcomes are consumed as supplied by the PM. Its pending private fence redesign is deliberately outside this design's interface.

## 0. Gate verdict and as-built coverage

### 0.1 Contract and dependency verdict

**Designable now; producer code blocked on 16's close and F3-91's freeze.** Existing families suffice for origin, demand, paid results, budget truth, private integrity and continuation fencing, but do not represent an agent's grace candidate/loss/restoration, cause membership, outage or durable owner notice. Neither a paid `unknown` nor `recovery_pending` is that state. Propose F3-91 as an additive family with its own `«SCHEMA-91»` submission and receipt; do not widen an earlier closed schema or append an F3-91 effect inside an earlier frozen group. The PM freezes S1 under D125 before S2 writes it. Consumed F3-10/11/12/13/139/15/16 and all earlier bytes/goldens stay unchanged. Basis: T91:16–24,34–43; `docs/CONTRACTS.md:140–151,185–218`; LD:2320–2351,2493–2527,3039–3066,3091–3126; decisions D125, D148, D165, D166, D169.

No R1, C6, C8, C9, C7 or GUI prerequisite is added. R1's router pause/grouped prompt is ticket 130; reserved questions, ordinary-work allotment pauses, stand-in and succession are 131–134; shared view projections are 135. Ticket 91 implements its own terminal status and owner notices, not those later consequences. No out-of-process host exists to classify. Basis: T91:26–30; `docs/ROADMAP-CORE.md:425–427,496–509`; `docs/ROADMAP-ROUTER.md:95–102`; tickets `130-count-router-pauses-toward-service-loss.md:22–34`, `131-keep-a-corps-working-while-its-officer-is-in-service-loss.md:22–36`, `132-hold-outage-work-to-the-corps-existing-tasks.md:22–30`, `133-stand-in-for-a-lost-office-as-the-owner.md:22–31`, `134-hand-over-an-office-after-an-outage.md:22–32`, `135-show-outages-pauses-and-stand-in-actions-in-every-view.md:22–34` (all under `.scratch/dwarf-harness/issues/`).

Testing-only remains D52/D112. No module, toolchain, cgo, new OS proof, paid probe or live-provider drill is proposed. The new freeze is the PM's gate, not an owner approval. Procedure changes or a breaking frozen-family change would be owner gates, not coder discretion (T91:16–24,30; Core:1020–1046; `docs/CURRENT-RULES.md:38–44,46–51,72–78`).

### 0.2 Three causes: actual evidence and missing bridge

| Cause | Existing refusal/execution evidence and actual path | What 91 must add, without changing the source's meaning |
|---|---|---|
| Classified provider failure | `providers.ResponseEvidence` retains status, allowlisted headers, structured error and class (`internal/core/providers/response.go:18–60,73–126`). Anthropic classifier: denied (401/403), exhausted (402, explicit spend-limit code or usage-limit prefix), rate_limited (other 429), overloaded (529/overloaded_error); transport timeout/unreachable (`response.go:128–177`). OpenAI classifier similarly recognizes insufficient_quota, credit/organization/project limits and server overload (`internal/core/providers/openai_response.go:92–124`). Dispatch publishes a context-owned observation after the one existing POST (`AS/paid_dispatch.go:211–270`); it contains exact origin, attempt/request digest, status, headers, completion/stop/error metadata (`AS/paid_capture.go:20–69`). `RecordPaidObservation` commits F3-13 `runtime.paid_result` plus receipt (`AS/paid_settlement.go:254–262,394–444`). | Typed availability evidence and true scope, not a second financial result. `error_class` alone has no reset, scope or successful-call witness. `unknown` describes money uncertainty, not provider availability. Cancellation/deadline must not be relabelled network failure merely because `ClassifyTransportError` returns timeout/unreachable. Financial `usage` may be a billed refusal or failed/incomplete response, not restoration (`AS/paid_settlement.go:69–112,170–212`; LD:2493–2527). |
| Exhausted owner money | The one book checks authority before exposure and every applicable sorted scope (`AS/paid_budget.go:60–121`); `checkPaid` returns `BusyError{budget_exposure}` if occupied + this quote exceeds a finite cap; `paid_violation` is separate. Its caller is the paid-attempt planner (`AS/paid_attempt.go:146`, LSP references). F3-13 spend configurations/reservations/results remain accounting truth (`docs/CONTRACTS.md:145–151`). Period kinds are lifetime/utc_day/utc_month (`AS/paid_budget.go:29–40`; LD:2360–2364). | A refusal snapshot distinguishes actual exhaustion at agent/credential/colony scope from a quote too large for remaining allowance, a task/grant cap, absent/disabled authorization or a bound-violation fence. No existing durable receipt records a refused admission: capture the existing host refusal in F3-91, before returning it, but reserve/charge/release nothing. Record why the scope blocks all the agent's applicable paid work, rather than treating every budget_exposure as loss. |
| Execution failure | Private integrity: `Open` inspects ledger-selected objects/materializations and returns issues without clock/appends/dispatch (`AS/service.go:164–217`; `AS/integrity.go:109–124,239–322`; `AS/doc.go:25–38`). `scopeIssuesLocked` gates operations (`AS/service.go:339`, references in `scoped_execute.go:104`, `commands.go:232,282`, `read.go:93,246`). Unmatched work/loops are recovery_pending, not integrity failure. Git lifetime: G16 `UnconfirmedError{RunID,Reason}`, `Result{TreeClosed,IOJoined,Proof}` and `Report{Pending,Closed}` (`types.go:13–29,71–94`); `Owner.Run` refuses while pending and retains unconfirmed resources, and `Reconcile` runs no Git (`owner.go:105–179`). | Demand-bound, immediate integrity/process observation, retaining only stable non-secret identities and reason. Successful `retained_job`/`name_absent` shutdown evidence permits another call; never restoration by itself. Do not inspect fence bytes, native handles or infer shutdown from generic interrupted receipts. `cmd/dwarf-harness/main.go:71–78` currently aborts before terminal setup on workspace Open failure: 91 must retain a status-only owner surface for an actual unconfirmed startup rather than hide the outage or run Git. Ticket 16's final workspace error/report bridge and main drain changes must be rechecked at coding base. |

**F3-13 mapping boundary.** Direct eligible classes are `rate_limited`, `overloaded`, `unreachable`, `denied`, `exhausted`; the scoped diagnostic must distinguish credential refusal from other denial and account quota from rate capacity. `timeout` is eligible only with positive transport-failure provenance, not a caller's own deadline/cancel. `provider_error` is eligible only when the retained response proves provider unavailability; a generic financial/parse error is insufficient. `invalid_request`, `unavailable`/404, `conflict`, `protocol_error`, `refused` and `tariff_ambiguous` alone never establish a listed cause. Neither `released_unsent` nor `correction` is a new loss/restoration observation. Exact policy and scope choices are P2. This deliberately does not turn invalid prompts, safety refusals, ambiguous tariffs or missing secrets on restart into outages (T91:34–37; Core:1024–1026; `AS/paid_settlement.go:69–108`; `internal/core/providers/response.go:128–177`; `internal/core/providers/openai_response.go:92–124`; B9; D148).

### 0.3 All ten criteria against current code

| # / ticket line | Existing records/code/tests | Missing deliverable |
|---|---|---|
| 1 / T91:34 | The three evidence paths in §0.2; `TestRealTLSStreamAndErrorInterpretation` (`internal/core/providers/response_test.go:13`), `TestAnthropicRefusalBilling` (`AS/paid_billing_test.go:33`), `TestPaidPeriodsWarningsAndOverrun` (`AS/paid_money_test.go:137`). | Cause/scope diagnosis, loss state, exhaustion-versus-permission discrimination and demand-bound execution observations. |
| 2 / :35 | Distinct authority/capacity checks (`AS/paid_budget.go:88–121`); inert Open and interrupted recovery (`AS/doc.go:25–38`; `TestTurnLoopCrashRecovery`, `AS/owner_recovery_test.go:249`). | One explicit negative matrix across the consumer boundary; no catch-all error→loss conversion. |
| 3 / :36 | Clock samples at paid dispatch, recorded observed_utc_ns (`AS/paid_dispatch.go:170–208`), colony clock/replay rules (`docs/ROADMAP-CORE.md:15,231–257`; D37). | First refused demand, immediate owner-only onset, durable grace evidence and restart-safe scheduling; no clock inside replay. |
| 4 / :37 | Static one-shot paid path; detector evidence is already captured (`AS/paid_dispatch.go:211–270`, `AS/paid_capture.go:20–69`); no heartbeat producer. | Metadata-only detection/clock wake and no extra POST/process/model work assertions. |
| 5 / :38 | Existing `Session.Do/Since` and typed events (`internal/core/session/types.go:19–24,89–103`; `AS/loop_session.go:268–387`); terminal event pump (`internal/core/terminal/terminal.go:505–565`). | Durable cause/outage memberships, exactly one begin/end notice identity, full affected-agent listing and status/events display. |
| 6 / :39 | Response completion and stop details retained (`AS/paid_capture.go:20–69`); paid loop separates unknown/no_charge/usage (`AS/loop_continuation.go:200–239`). | Causal clear/ceased-applying evidence plus subsequent successful-call witness; single-context success cannot erase an agent-wide provider failure. |
| 7 / :40 | F3-13 unknown full holds; no automatic reexecution (`docs/CONTRACTS.md:140,149–151`; `TestPaidInjectedCrashRecovery`, `AS/paid_crash_test.go:110`; `TestPaidSettlementAndCorrection`, `AS/paid_money_test.go:23`). | Demonstrate unchanged exact book totals and physical POST identities through loss/restoration/reopen; do not add recovery retry. |
| 8 / :41 | Typed native families/F3-16 owner fences (`docs/CONTRACTS.md:204–218`); `Open` is inert (`AS/service.go:164–217`). | Typed F3-91 transitions with deterministic preflight/replay, source identities and no restart-induced state transition. |
| 9 / :42 | Global command directory and bounded prepare/resolve/revalidate protocol (ticket-142 ruling, `.scratch/dwarf-harness/c3-evidence/ticket-142-design-ruling.md:75–80`); paid duplicate evidence returns original receipt (`AS/paid_settlement.go:394–416`). | Extend rather than duplicate that mechanism; crash cuts between source/effect/notice; duplicate observations, restored-again callbacks and end-notice convergence. |
| 10 / :43 | No role/holder producer in this ticket; grants remain independent (`AS/doc.go:111–119`; Core:1042–1046); FG20 forbids emergency promotion (`.scratch/fortress-gui/spec.md:308`). | Runtime/status round trip must preserve all other grants/tasks/identity records and expose no authority mutation. Full office cardinality remains later C8, not fabricated fixtures. |

Existing tests above are precedents to preserve, not claims that they prove 91. §7 specifies consumer-visible new rows for each criterion and the exact red/green breaks.

## 1. Numbered design choices (P1…)

All details in §§2–8 instantiate the numbered recommendations here; they are engineering proposals, not additional owner requirements. The cited ticket/design passages supply the observable contract; the indicated as-built passages supply the reused mechanism.

| Choice | Options considered | Recommendation, reason and authority |
|---|---|---|
| **P1 — family and state** | Infer from paid/turn endings; modify a frozen receipt; or a separate family. | **Five additive v1 types**: `runtime.service_observed`, `runtime.service_cause_changed`, `runtime.service_agent_changed`, `runtime.service_outage_notice`, `runtime.service_receipt`; own `«SCHEMA-91»`, strict codecs and golden. The first is a durable non-financial observation journal, closing callback/crash gaps without modifying paid evidence or retroactively diagnosing old history. One aggregate state unions an agent's memberships. T91:34,38–42; Core:1022–1028; `docs/CONTRACTS.md:140–151,185–218`; LD:2320–2351,3091–3126; D125. |
| **P2 — provider diagnosis and scope** | Treat every unknown/HTTP error as outage; use bare provider-wide labels; or bind a conservative, typed diagnostic to the actual failed request. | **The last**, with the exact class/provenance/scope/reset table in §3. Never infer global provider/account health from one model request or cancellation. Preserve financial derivation unchanged; diagnostics consume existing captured facts. T91:34–37; Core:1024–1026; `internal/core/providers/response.go:18–60,128–177`, `openai_response.go:92–124`; AS/paid_capture.go:20–69; AS/paid_settlement.go:69–108. |
| **P3 — demand and refusal granularity** | Mark every configured/idle agent when a scope fails; journal every busy; or observe only required-work refusals that establish a listed cause. | **Only qualifying refusals at the real call/effect entrance**; deterministic money/integrity/process refusal at that entrance counts without issuing the forbidden effect. A message, configured route, task assignment or restart alone is not demand evidence. Deduplicate per agent/cause; repeats neither reset grace nor write a record. Distinguish true owner-cap exhaustion from quote-too-large and task/grant capacity. T91:34–37; Core:1024–1026; AS/paid_budget.go:88–121; AS/paid_attempt.go:95–151; AS/doc.go:197–220. |
| **P4 — grace and wake** | Restart the grace; read time during replay/query; require another refusal; or persist the first-refusal UTC/not-before and drive one metadata timer outside replay. | **Persist first refusal and due UTC, use a monotonic timer live, and fire a typed expiry observation**. After downtime an explicit detector-enable/catch-up boundary rearms or immediately delivers that same overdue timer; Open remains inert. Held-back UTC cannot manufacture expiry or move the first refusal. This is an absolute not-before scheduling fact, not a UTC-derived duration measurement. T91:36,41–42; `docs/ROADMAP-CORE.md:15,231–257`; LD:20–31,78–83; D37; AS/service.go:164–217. |
| **P5 — outage and notices** | Notice per turn/agent; mutable rewritten begin records; or one incident identity with membership edges and stable notice references. | **One open outage per semantic cause, distinct UUIDv7 per incident, begin/end each atomic with its first/last lost membership**. A begin notice references the incident's cumulative affected set: later joins update the same notice, never produce another begin. End fixes the final set. This is necessary to list future joiners without rewriting history or issuing extra notices. T91:38,42; Core:1024,1028; D100/D101; `internal/core/session/types.go:89–103`; LD:78–83. |
| **P6 — restoration witness and moved work** | Clear on reset/top-up/retry; accept any billed result or switched turn; or require a real successful call plus current cause applicability. | **The last** (§5). A successful same-scope call can itself prove a transient provider cause clear. Deterministic budget/process/integrity clearance only permits a call. An alternative-provider completion needs a host-verified complete owner-selected workset with zero remaining failed-provider work; no new router/default-provider feature or owner “declare restored” command. T91:39–40; Core:1038–1040; D102; AS/paid_capture.go:20–69; AS/loop_continuation.go:200–239; AS/paid_budget.go:29–40. |
| **P7 — source gap and duplicate convergence** | Assume callbacks cannot be lost; add service metadata to frozen paid groups/private financial evidence; or journal the qualifying observation separately. | **Unchanged financial objects/groups plus an F3-91 observation journal**: capture the existing refusal/completion and completion-time applicability, durably select that source, then apply its state transitions before acknowledging. Recovery drains recorded sources only, never paid requests or mutable later settings. This avoids both source gaps and service metadata changing a financial capture's size/settlement. T91:37,40–42; LD:2493–2527,3039–3066; AS/paid_capture.go:297–351; AS/paid_settlement.go:394–444; AS/doc.go:373–463; ticket-142 ruling:75–80. |
| **P8 — runtime ownership** | Reuse 90's eligibility hold; cancel/auto-retry work; or a metadata detector owned by the existing Service. | **Service-owned projection plus one timer worker; no scheduling/authority gate from service loss itself**. Existing refusals remain authoritative; loss neither cancels active calls nor retries them. Ticket 131, not 91, combines officer consequences with 90. Existing ready queues continue normally after explicit successful attempts. T91:26–30,40,43; Core:1022,1030,1038–1046; AS/service.go:140–161; AS/doc.go:454–463. |
| **P9 — unconfirmed-startup terminal seam** | (A) Record and print status before refusing startup; (B) start an inspection-only interactive terminal with workspace operations unavailable; (C) silently abort as now. | **A**. Preserve 16's positive-proof refusal and executable/drain order. After failed workspace reconciliation, open agents metadata-only, bind a process observation only to already recorded required work actually blocked by that failure, durably catch up, print every registered agent's state/cause and the owner notices, then refuse/exit 1. Do not enable the loop, run Git, bind credentials, or mark configured idle agents lost. B meets display but adds a second runtime mode and broad Session surgery; C misses criterion 5. Normal successful startup still uses the ordinary terminal. T91:35–38,41; AS/service.go:164–217; `cmd/dwarf-harness/main.go:55–83`; G16/owner.go:105–179; ticket-16 ruling amendment 14 and P9, superseding the base's exact startup ordering. |
| **P10 — owner command/event surface** | A new notification service/transport; per-agent copies of a colony notice; or extend existing owner Session commands/events. | **The last**: typed passive `service.status` and paged `service.outages`, plus `service.changed` and `outage.began/joined/ended` events. One designated owner session carries each colony notice; agent status events remain agent-scoped. The terminal deduplicates by notice identity, not wording, and renders a complete list across pages. No launcher-protocol freeze or later C7 projection is invented. T91:38,42; Core:309–336; `internal/core/session/doc.go:1–5`; `session/types.go:19–24,89–103`; AS/loop_session.go:268–387; `terminal/terminal.go:196–219,342–410,505–565`. |
| **P11 — proof and fuzz** | Live-provider authorization/measurements; mock timer/source assertions; or real stores, loopback controlled failures and deterministic barriers. | **The last**, including real process proof refusals on Windows, consumer counts, crash cuts, money/recovery/permission/credential breaks and changed-code fuzz (§7). No figure is required, so no CPU profile/measurement campaign or duration assertion. T91:22–24,45–47; `docs/CURRENT-RULES.md:15–22`; D152 item 1; existing `TestPaidInjectedCrashRecovery` (AS/paid_crash_test.go:110), `TestTurnLoopCrashRecovery` (AS/owner_recovery_test.go:249). |
| **P12 — slice cut** | More than four slices; defer a criterion; or four complete boundaries. | **S1 contract/freeze; S2 reducer/recovery/queries; S3 evidence/runtime; S4 terminal/startup/end-to-end**, each reviewed once. All ten criteria remain in 91; no owner split question. Exact paths, race rows and commands are §8. `docs/CURRENT-RULES.md:8–17,38–44`; D152 items 1–3; T91:34–43. |


## 2. Exact state, records, submission and transition formats

### 2.1 State and identities (P1, P3, P5, P7)

`ServiceState(agent)` is `service_loss` iff it has at least one `lost` membership; otherwise `available`. “Available” means no recorded service loss, not idle, authorized, healthy, runnable or guaranteed successful. Expose pending grace separately as `pending`, never as loss. Multiple causes coexist in the one projection; one successful route cannot erase an unrelated cause. A member is keyed by `(AgentID,CauseID)`, versioned monotonically, with phase `pending|lost|restored|withdrawn`; `restored|withdrawn → pending|lost` starts a fresh demand generation with a new first-refusal witness. Each lost generation joins exactly one outage. A cause is the scope condition; an outage is a contiguous incident with one or more lost members. Restoring one agent need not clear the shared cause, and moving all members off it can end an outage without asserting the provider recovered (T91:12,34,38–42; Core:1024–1028,1038).

CauseKey is a SHA-256 of the compact known-field encoding of `CauseSpec` below, never a secret, raw error/message, URL or credential-derived hash. First occurrence allocates a CauseID UUIDv7, retained by the cause directory. Further equal keys share it; differing key fields never merge. Each incident gets a fresh OutageID UUIDv7, one begin NoticeID and one end NoticeID allocated only on their actual transitions. Agent membership generation, first source and due are separate from the cause version. Same cause may have a new incident after its previous lost-member set becomes empty. The incident's cumulative affected set never shrinks, while its active lost-member set does. None of these identities is authority (T91:38,41–43; D37; LD:20–57).

### 2.2 Exact new family (P1)

All five record types are version 1, under C3/`internal/core/agents` production through `ledgerstore.SubmitAt`; no other permitted appender caller. Codecs follow F3-16's 65,536-byte independent complete-input/compact-output limit, canonical UUIDv7/nonzero digests, checked plain integers through MaxInt64, recursive duplicate-key rejection, required keys/no known nulls, unknown optional keys ignored and omitted from canonical preimages. No body_refs, private text, arbitrary diagnostic strings, account names, credential locators, raw headers, paths or native handles. Source object references remain owning-context private metadata. Open tokens use `^[a-z][a-z0-9_]*$`, max 64 bytes; unfamiliar cause/state/source tokens are retained unsupported, never interpreted as healthy, lost, restored, authority or money release. Historical decoder limits are not tightened to a runtime producer count (LD:2329–2351,3091–3126; `docs/CONTRACTS.md:185–218`; P1).

The following is exact compact key order; `?` means omitted when inapplicable, never null. All arrays below are required nonnull where shown, sorted/distinct by the listed tuple except `effects`, which preserves commit order. No record serializes an unbounded membership list.

```text
CauseSpec:
  family, code, scope_kind, provider?, credential_scope_id?,
  credential_version?, model?, region?, authority_sha256?, agent_id?,
  context_id?, private_scope?, revision?
  family: provider|money|execution
  code: rate_limited|overloaded|unreachable|denied|exhausted|
        owner_money_exhausted|process_unconfirmed|private_integrity
  scope_kind: provider_route|credential|account|account_route|colony|agent|private
  provider_route/account_route require provider, model, region, authority_sha256;
    account_route also requires credential_scope_id and requires
    credential_version exactly for code denied.
  provider credential denial requires provider, credential_scope_id and version.
  account quota requires provider, credential_scope_id and authority_sha256,
    omitting model/region/version: these existing codes explicitly name an account cap.
  money: colony omits IDs; agent requires agent_id;
    credential requires provider and credential_scope_id, omits version/model/region.
  private requires agent_id, private_scope=agent|context, revision,
    context_id exactly for context scope.
  process_unconfirmed uses colony (the one workspace Git Owner).
  region is required for route scopes even when the exact configured
    region string is empty; this is the sole empty-string exception here.
  model/region are the exact sealed non-secret F3-13 fields (same grammar).
  authority_sha256 hashes the sealed authority string, not any secret/locator.

Source:
  kind, observation_id, observed_through, source_sequence?, command_id?, submission_sha256?,
  origin?, turn_id?, attempt_id?, object?, observed_utc_ns, clock_held,
  reason, provenance?, reset_utc_ns?, money?, completion?, workset_sha256?,
  failed_work_count?, execution_run_id?, execution_proof?
  kind: paid_call|money_refusal|integrity_refusal|process_refusal|
        cause_clear|successful_call|grace_expiry|demand_withdrawn
  origin uses the existing full Origin shape.
  reason is an open token with exactly these v1 writer values:
    rate_limited, overloaded, unreachable, credential_denied, scoped_denied,
    quota_exhausted, money_exhausted, private_integrity, process_unconfirmed,
    provider_completed, budget_available, integrity_verified, process_closed,
    all_work_moved, grace_due, owner_cancelled.
  provenance is present on paid_call/successful_call and is the host-fixed
    provider_response|transport token. Caller-cancel/local-deadline/capture/
    protocol diagnostics do not establish a listed cause and produce no E.
  observed_utc_ns > 0; clock_held is required Boolean in this nested value.
  source_sequence selects the actual source effect, not a predicted cursor.
  observed_through is the complete prefix at which the source was validated;
    it is <= the service command's preceding frontier. Pure replay never
    samples time or reopens an observation object to reinterpret this fact.
  A native-refusal source without its own durable native effect instead
    requires command_id + submission_sha256 + exact origin/turn binding.
  paid sources require attempt_id + source_sequence + object (ObjectRef);
    source_sequence selects the actual dispatch intent, and original
    origin/turn/request identities must agree. observation_id names E.
  reset_utc_ns is positive, future at observation, and only on quota/rate
    evidence or a UTC-period money refusal, as specified in §3.
  workset_sha256 and failed_work_count occur together only for moved-work
    evidence; the count must be 0 for a restoration.
  execution_run_id is present only when the actual unconfirmed/closure
    report supplies a RunID; absence cannot be replaced by a fabricated ID.
  money is present exactly for money_refusal/budget_available, key order:
    scope, period, spend_sequence, mode, occupied_micros, ceiling_micros?,
    coverage, workset_sha256?, eligible_work_count?, failed_work_count?
    scope/period/mode use the existing PaidScope/F3-13 grammar.
    Amounts are canonical nonnegative decimal strings, occupied through
    the complete-payload cap (the book aggregates big.Int), ceiling through
    MaxInt64. finite requires ceiling; unlimited forbids it.
    coverage is mandatory_scope for colony/agent, complete_workset for
    credential. Only complete_workset carries digest and both counts.
    Refusal requires finite, occupied >= ceiling, and (for complete_workset)
    eligible_work_count = failed_work_count > 0.
    budget_available binds the actual book/config/native proof at its
    recorded live boundary, including UTC rollover or unlimited terms;
    a positive condition check permits a call but never releases money.
  completion occurs exactly on successful_call, key order:
    provider, terminal, native_result_sequence?, financial_kind?, permit
    terminal is one of §5.1's successful terminals. The two financial fields
    occur together only if the native result already exists; they never
    authorize a charge/release or predict a financial effect.
    permit is the selected per-cause entry in §3.1's completion evidence.
  execution_proof occurs exactly for process_closed and is
    live|retained_job|name_absent, copied from existing positive evidence.

runtime.service_observed:
  observation_id, agent_id, cause_id?, cause_key?, cause?, source,
  completion_permits_object?
  observation_id equals this group's command_id.
  Failure requires cause_id/cause_key/cause, reserving their immutable
    association even before K is applied; success instead requires the
    completion-permits ObjectRef described in §3.1.
  A deterministic cause-clear/withdraw observation names its existing cause.
  This records facts only; K/M/N perform their separate typed transitions.
runtime.service_cause_changed:
  cause_id, cause_key, expected_version, version, cause, condition, source
  condition: active|cleared
  creation: expected_version=0, version=1, condition=active.
  cause/cause_key never change for that ID; later real transitions increment
    version, never create a second ID for the same key.

runtime.service_agent_changed:
  agent_id, cause_id, expected_version, version, generation, phase,
  first_source, due_utc_ns?, outage_id?, source
  first_source is immutable within one demand generation.
  due_utc_ns occurs exactly for a grace-bearing generation, checked addition
    of first_source.observed_utc_ns + 120_000_000_000.
  outage_id occurs exactly once the generation has entered lost and remains
    on its restored historical snapshot.
  generation starts at 1; only a new post-restoration/withdrawal demand
    increments it; repeats cannot change first_source, generation or due.

runtime.service_outage_notice:
  outage_id, cause_id, edge, notice_id, member_source_sequence
  edge: began|ended
  member_source_sequence is the exact service_agent_changed envelope
    in the same commit that opens/closes the incident.
  The notice references the cumulative membership set of this OutageID.
  No separate notice store, delivery-ack or per-agent copy is written.

runtime.service_receipt:
  command_id, submission_sha256, submission, outcome, effects,
  source_through
  effects element: type, sequence
  outcome: recorded (new transitions only; no record for an exact no-op).
  source_through is the complete recorded-observation coverage in §5.2.
  Actual envelope positions validate every sequence; never a self-sequence.
```

Envelope rules: each group has one `core` command/effect/receipt actor and OperationID equal to its command UUID; the group omits agent/session/context/turn envelope fields because it may combine a scoped member with a colony notice. The full member/source origins are in the payload. This is a new family rule, not an exception to another family's origin rule. Only owner-facing trusted host entrances produce these commands; an Agent handle/model tool cannot submit observations, claim cleared state or enumerate colony outages (T91:38,41–43; Core:309–336; AS/doc.go:7–13,111–119).

Canonical `ServiceSubmission`, exact order:

```text
schema, actor, operation, cause_id?, agent_id?, expected_cause_version,
expected_member_version, expected_generation, arguments
schema = «SCHEMA-91»; actor = core
operation = service.record | service.observe | service.expire |
            service.clear | service.complete | service.withdraw
record arguments, exact order:
  observation_id, cause_key?, cause?, source, completion_permits_object?
  observation_id = command_id; agent_id is required.
other arguments, exact order:
  cause_key, cause, source, first_source?, due_utc_ns?, outage_id?, notice_id?
All state operations require cause_id; observe/expire/complete/withdraw also
  require agent_id. clear is cause-scoped and forbids agent_id.
observe creating a member requires first_source and due exactly for grace.
expire/complete/withdraw omit first_source in arguments and reuse the stored
  value. outage_id/notice_id occur exactly for the computed incident edge;
  an ordinary join requires only the existing outage_id.
```

Operations are closed; argument presence is fixed by the transition table below. Actor `core` is host-fixed, never supplied by a model/launcher. Hash is SHA-256 over compact canonical encoding, as existing receipt families do. Source observations are host operations, not a new public command to set availability. Cause/member versions and generation must match the then-current prefix; pure preflight determines exactly which effects are required. The caller cannot choose an arbitrary state or notice edge. A matched command returns its original receipt after current disclosure authorization, before new clock/CAS/health checks; changed content is ErrCommandMismatch across all schemas, including `«SCHEMA-91»` (AS/doc.go:89–106,373–463; LD:2493–2527,3091–3126; P1/P7).

### 2.3 Group and transition table (P1, P5, P7)

`C` = ledger.command; `E` = service observation; `K` = cause changed; `M` = agent changed; `N` = outage notice; `R` = service receipt. Source recording is exactly `[C,E,R]`. State groups contain at most one each of K, M, N in that order, then R lists exactly those effects. No earlier-family member is added to these groups. E may precede its K/M groups across a crash; only the source-drain mechanism below completes them.

| Input and precondition | Effects / state | Exact records |
|---|---|---|
| First qualifying refusal; no matching membership generation | Create/reactivate the scoped condition if necessary; immediate → lost, otherwise pending; preserve first source. First lost member of a cause creates an incident. | `[C,K?,M,N(begin)?,R]` |
| Another refused agent for that active cause | Its own fresh generation and grace/immediate rule; joins existing open incident only on loss. | `[C,M,N(begin)?,R]` |
| Same agent/cause repeated refusal while pending/lost; identical or later source | No reset, new outage, notice or append. Return original membership receipt with current metadata query available separately. A newly observed owner-only subtype is a different CauseKey, not a grace shortcut by mutation. | none |
| Timer for exact pending generation, due reached, demand not withdrawn, cause still active | pending → lost; join/open incident. | `[C,M,N(begin)?,R]` |
| Timer stale/early/held-before-due, cleared condition or withdrawn generation | No transition; cancel/rearm the same worker item as applicable. | none |
| Existing positive budget/process/integrity clear evidence, no successful call yet | Condition → cleared only. All lost members remain lost; pending effective grace is disarmed. | `[C,K,R]` |
| Qualifying agent successful call with clear/ceased-applying witness | This member → restored; matching transient success may also clear the condition. End incident only when its active lost-member set becomes empty. Other causes still govern the agent's aggregate. | `[C,K?,M,N(end)?,R]` |
| Cause clears before this agent's grace without loss, or owner actually cancels all that generation's refused required work | pending → withdrawn; no restoration or outage notice. Observe this at the existing clear/cancel boundary; no new cancel command is added. | `[C,M,R]` |
| Service loss already recorded; owner cancels/stops work, fixes settings or closes a view | No restoration. Fixes may supply K(clear); the agent still needs its first successful call. | K group only when actual clear evidence changes condition; otherwise none |

Condition clear and per-agent withdrawal are separate bounded groups when several candidates exist; the condition itself makes their old timers inert immediately. A new actual refusal after a clear reactivates the condition, but an old candidate cannot borrow the new condition version: a withdrawn generation needs new demand. Lost generations remain lost across a failed recovery attempt; they do not acquire another begin notice or reset their original history. Neither configuration changes nor replay edits earlier bytes (T91:36,38–42; Core:1024–1028,1038; P1/P3/P5/P7).


## 3. Evidence adapters and required-work coverage

### 3.1 Provider source table (P2)

Use the already sealed request and captured response/transport error, not an agent report, health lookup or error-string interpolation. Add a small pure diagnostic in `providers/service_failure.go`. Leave the F3-13 error_class, financial observation JSON/schema/size checks, usage/no-charge derivation and one-POST transport unchanged. Carry typed non-secret provenance in the private live ObservedPaidCall handle from dispatch to its existing RecordPaidObservation caller, then select it in E: `provider_response|transport|caller_cancel|local_deadline|capture_refused|protocol`. Canceled caller/elapsed local policy is not transport; existing capture substitution is not a provider failure. E.Source.object references the exact **unmodified**, secret-gated existing paid_observation object, with source_sequence selecting its existing dispatch intent. Replay trusts the typed committed observation, not a reparse of paid artifacts (AS/paid_capture.go:20–69,159–205,297–351; AS/paid_dispatch.go:211–270; AS/paid_settlement.go:286–329; `docs/CONTRACTS.md:140`; P2/P7).

For a completion that can change pending/lost memberships, publish a **separate** service-owned immutable completion-evidence object before E. Exact compact schema: `schema,kind,observation_id,through_sequence,workset_sha256?,permits`, schema 1, kind service_completion; permits sorted by CauseID, entries `cause_id,cause_version,member_generation,kind,proof_sequence?,failed_work_count?`. Writer kinds are `same_scope|cleared|credential_replaced|all_work_moved|execution_clear|blocked`; moved work requires zero count plus digest, other proof kinds name existing clear/rebind/native receipts. ObjectRef uses the existing owning-context immutable-object rules and 1 MiB storage ceiling; no second manifest/database, financial-object extension or financial size-limit change. Capture the host-verified snapshot at the live completion boundary, draining preceding E records and validating current registry/owner prefix first. E's digest reference selects authority; an orphan object selects nothing. Recovery reads this recorded metadata outside replay planning as needed, never later restart settings or raw paid objects. Skip E entirely when no membership can change. E and its source receipt cannot charge/release money (T91:37,39–42; AS/paid_capture.go:297–351; AS/doc.go:25–38,64–72,427–463; P2/P6/P7).

| Native fact | F3-91 diagnosis/scope | Onset and exclusions |
|---|---|---|
| Anthropic/OpenAI `denied`, HTTP 401 | `denied`, credential scope **and immutable version** actually used. | Immediate refused credentials. Absent/unbound/revoked local credential is not a provider refusal. |
| Anthropic/OpenAI `denied`, HTTP 403 | `denied`, account_route: exact provider/credential scope/**version**/model/region/authority. | Immediate owner-clearable permission denial for that supplied credential/request scope, never a provider-wide outage. Do not add speculative vendor error-code branches. |
| `exhausted`: Anthropic 402/enforced_spend_limit_reached/API or workspace usage prefix; OpenAI insufficient_quota, credit_balance_exhausted, organization/project spend/usage codes | `exhausted`, account: exact provider/authority and owner-configured local credential/account scope, with no model/region/version qualifier. These existing classifier branches explicitly establish account quota/spend exhaustion. | Immediate without a validated stated reset; grace with one. This is the provider account's cap, not Core money. B9's account mapping is colony-local, not invoice-global. |
| `rate_limited` | account_route, exact provider/credential scope/model/region/authority of the failed request, not credential version. | Grace from this agent's first refused call. No R1 silent wait/resend and no guessed broader scope. |
| `overloaded` (Anthropic 529/overloaded_error; OpenAI server_is_overloaded), or retained 5xx proving provider unavailability | provider_route, exact configured authority/model/region. Generic provider_error without an observed failure response is insufficient. | Grace. |
| Actual DNS/connect/TLS/read/write failure with no owner cancel, host shutdown, local policy deadline, observer rejection or capture refusal responsible | `unreachable`, provider_route. A positive transport timeout joins this code; its financial error_class remains unchanged. | Grace. Record transport provenance before losing the original typed error; do not derive it from `timeout`/`unreachable` token alone. |
| Other error classes; safety refusal; malformed/oversized output; request-invalid/404/409; ambiguous tariff; capture gate/observer failure; own cancel/shutdown/deadline | No F3-91 cause from that fact. | No service record. Preserve native result/hold and ordinary failure as built. |

**Scope is evidence-bounded and the table is exhaustive for this ticket.** Never correlate header identifiers, key bytes or names to merge distinct owner credential scopes. Account-wide quota keys are justified by the existing classifier's explicit account-limit branches; rate/overload/connectivity keep their exact request qualifiers. No extra “if some vendor field implies broader scope” branch is delegated to the coder. Every affected agent still needs its own required-work refusal, even when several share the same semantic cause. Preserve local-account versus invoice/provider-global meaning (T91:34,37; Core:1024; `internal/core/providers/response.go:128–163`; `openai_response.go:92–124`; D148/B9; P2).

**Reset parsing:** only allowlisted retained metadata already present in the observation can state a reset. Accept one unambiguous positive `retry-after` delta-seconds in the plain integer grammar, checked addition to the source observation; an HTTP-date is an absolute UTC not-before parsed by `http.ParseTime`, requiring one valid future value. Conflicting/repeated/malformed/past values are “no stated reset”, never zero. Do not mistake retry-after for account-quota reset unless that classified quota response actually carries it; other rate-limit counters/headers do not invent one. For rate/overload/unreachable the cause is already grace-bearing, so malformed reset changes no onset. Reset passing is not clearance/restoration evidence by itself (T91:36,39; `providers/response.go:30–60`; AS/paid_capture.go:29–37; P2/P4/P6).

### 3.2 Owner money (P3)

Run the existing authority and exact book plan first. Only an enabled finite **colony, agent or credential** scope with `occupied >= ceiling`, not `occupied + this_quote > ceiling` alone, can establish `owner_money_exhausted`. Negative remaining allowance counts exhausted; zero is a valid finite ceiling. Include held unknown amounts exactly as the current book does. Read the exact current period/terms and book revision under the committing prefix; retain scope kind/ID, period and spend-configuration source in the refusal witness. Never clone totals into an authority store or alter accounting. A lifetime ceiling has no reset; UTC day/month has its next period boundary as the stated not-before. Unknown holds surviving that boundary can still prevent a call: rollover only permits a fresh ordinary book check (AS/paid_budget.go:29–40,60–121; AS/paid_attempt.go:95–151; LD:2357–2364; D22/B9/D148; T91:34–36,40).

The agent/colony scopes necessarily intersect every paid call by that agent. A credential/account ceiling counts only if **every currently owner-configured paid work binding and admitted-but-not-dispatched required model operation of that agent** uses that credential scope; mixed accounts do not “stop all calls”. The host checks the complete current loop-settings registry plus durable nonterminal owner/pending admissions, not only the refused context. Already sent unknown attempts are accounting exposure, not work to replay or an obligation to retain a failed provider. A task/grant limit, absent/disabled terms, revoked grant, retired-profile/bound-violation fence, currency/tariff uncertainty or insufficient room for one large quote is not this cause. If authority already fails, do not disclose which broader scope was exhausted or write a loss observation for the denied request (T91:34–35; Core:1024; AS/paid_budget.go:88–121; AS/paid_attempt.go:95–146; AS/loop_types.go:31–42; AS/service.go:95–112; P3/P6).

Deduplication occurs before record production: repeated qualifying refusals for an existing member return its original observation receipt; ordinary busy/task/grant/local capacity refuses exactly as before with **zero F3-91 appends**. A budget source is a frozen non-financial witness of an actual rejected planner request, not a `paid_reserved`, and never consumes/reserves a local/model unit (T91:35,37,40,42; AS/doc.go:197–220; P3).

### 3.3 Execution and exact demand (P3, P9)

Demand counts when an authenticated required operation reaches its real provider/local-call admission or dispatch entrance and that entrance cannot proceed for a listed cause. For an already established **deterministic** barrier (exhausted all-call owner cap, private integrity issue, unconfirmed process Owner), an arriving call can be refused and joined from the existing barrier evidence without issuing any network/Git/file effect. Mere inbox receipt, a task waiting somewhere, configured context, a running sibling, a detached view or an inert restart is not such a call. For transient provider status there is no permanent local refusal gate: an explicit normal required retry is still allowed through the existing paid path and may establish success; no attempt is generated by the detector (T91:35–37,39; Core:1024–1026; AS/loop_continuation.go:102–169).

Private integrity source: bind the failed ledger-selected agent/context scope, its revision and existing IntegrityIssue reason from the actual Open/inspectLive/refused-call path. Missing/corrupt selected object or foreign materialization is eligible; a safely repaired older/missing materialization with no issue is not. An Open report alone records neither demand nor loss for an idle agent. An existing unfinished turn requiring that exact blocked scope is demand only when explicit recovery/continuation bookkeeping actually reaches and is refused by that integrity guard; generic PendingLoops/PendingWork without the issue never qualifies. The ordinary future `message.send`/StartTurn refusal also qualifies, even when it precedes F3-15 bind. F3-91 then captures the original submission identity without retaining owner text (T91:34–37,41; AS/integrity.go:109–124,239–322; AS/doc.go:25–38,197–220).

Process source: consume `gitprocess.ErrUnconfirmed`/UnconfirmedError or the workspace's typed propagated classification from an actual call/recovery path, never a guessed PID/fence filename. Scope is the colony's one Git Owner. Add only a sanitized typed workspace bridge carrying classification and optional RunID; retain no root path/handle or raw native error. Normal positive `retained_job`/`name_absent`/live closure proof can clear that resource barrier through its existing report; never interpret root exit, killed status, an interrupted receipt or a successful cleanup call alone as agent restoration (T91:34,39,41; G16/types.go:13–29,71–94; G16/owner.go:105–179; ticket-16 ruling P9/amendments 10,14).

The sanitized workspace interface is `ClassifyExecutionFailure(error) (blocked bool, runID uuid.UUID)`, which unwraps only the actual gitprocess unconfirmed class (all unrelated errors yield false), plus `Reconciliation.ProcessClosures []ProcessClosure{RunID,Proof}` copied from Owner.Reconcile's positive closed results. A real successful F2 workspace operation can also witness process readiness because 16's one Git launcher returns success only after positive closure. No root/fence accessor, polling method or callback into agents is added. Agents records the relevant existing error/closure/native-receipt fact at its required-work entrance; no second process manager is created (G16/owner.go:105–179; G16/types.go:71–94; G16's `internal/core/workspace/git.go:112–145`; `internal/core/workspace/service.go:47–58`; P3/P9).


## 4. Onset, clock, outage grouping and owner notices

### 4.1 Clock and timer (P4)

First refused call is the live host refusal/completion-boundary sample durably carried by E.Source (`observed_utc_ns,clock_held`), not dispatch time, a later financial result or later K/M receipt. Use the existing host clock seam at that live boundary under D37's held-back rules; no clock runs in providers. Keep the immutable first source/ObservationID even if its state drain happens after restart. Compute due by checked addition of exactly 120,000,000,000 ns; immediate causes omit due and enter loss when that source is applied. Replay validates recorded values/arithmetic only, never a clock/timer/provider parser/credential source or fresh diagnostic (T91:36–37,41; `docs/ROADMAP-CORE.md:15,231–257`; LD:20–31; AS/service.go:164–217; P4/P7).

One Service-owned timer worker, one heap item per pending `(agent,cause,generation)`, one wake/control channel and no goroutine per agent. It is enabled explicitly after metadata/source catch-up by the executable/EnableTurnLoop; Open and passive queries start no worker. Earliest-due scheduling uses `time.NewTimer`/Reset and monotonic live waiting. When timer fires, the worker samples the host clock **outside the pure planner**, captures current member/cause versions and submits `service.expire`; moved-tail/cold-read retries discard and resample as ticket 142 requires. A valid sample at/after due is evidence for the saved timer, not a health check. Early/spurious wake rearms without append; duplicate/stale generation produces no effect (AS/doc.go:427–463; T91:36–37,41–42; P4/P8).

Before expiring a pending **money** membership, use the same recorded live sample and existing book terms/held amounts to recheck its deterministic barrier. A reset/raised/unlimited limit that is now available produces the positive clear/withdraw transitions, not false loss merely because the old condition flag was active; surviving unknown exposure that still exhausts the scope keeps the candidate eligible. Do not probe providers or run an integrity/process check from this timer. A reset/clear of an already lost member still never restores it without its completed call (T91:36,39–40; AS/paid_budget.go:29–40,88–121; P3/P4/P6).

The Service's live observation floor is max(last accepted ledger event time, last successful live sample); a backwards sample is held at that floor with `clock_held=true`, not subtracted or allowed to move first/due. Persisted source times/floors survive restart via ledger reduction. A held sample below due cannot expire. A genuinely already-reached recorded floor at/above due can expire once; rollback never undoes onset. In-process waits/duration instrumentation use monotonic time; the durable due is an absolute UTC not-before, like existing durable deadlines, **not** elapsed UTC telemetry. D37's ledger clock-held behavior is retained; no frozen event timestamp or paid clock rule changes (D37; `docs/ROADMAP-CORE.md:231–257`; LD:20–31,78–83; AS/paid_live.go:118–130; P4).

If Core is down at due, no record can be emitted while it is down. Reopen reconstructs the exact pending generation without clock/appends; explicit source catch-up runs first (so an already captured success/withdrawal is not overtaken), then detector-enable submits the overdue saved timer at the first live boundary whose recorded sample reaches due. If it is not yet due, rearm only the remaining not-before. The onset record references the original first refusal/due and records actual later observation; do not backdate an envelope, claim a notice was delivered during downtime, or invent a new loss because restart happened. A pre-existing lost member stays lost with no expiry write. This meets “restart neither starts nor ends” by separating inert recovery from independently evidenced timer firing (T91:36,41–42; Core:1026; P4/P7).

### 4.2 Outage membership and durable owner notice (P5, P10)

Under Service.mu, first lost member creates the open-incident projection and its one begin notice in the **same SubmitAt**; further lost memberships join it. Last active lost membership's successful restoration and the one end notice are likewise one group. No temporarily empty incident is published between those effects. A cause condition clear does not end an incident while even one agent awaits its own successful call. A member restoring from one cause while still lost for another leaves aggregate state lost; the matching incident may still end (T91:38–42; Core:1024,1028,1038).

The begin/end records are durable **notice references**, not mutable documents: each has NoticeID, OutageID and edge; `service.outages` resolves the incident's cumulative affected-agent set from committed M records, sorted by AgentID bytes, including workers and restored members. A late join is an update to that notice's list, not a second begin notice/alert. The end list is final for that incident. Event payloads carry notice identity and membership page coordinates; the terminal drains pages at one fixed through-sequence before printing the complete set. If a later append invalidates that enumeration, discard the incomplete list and query a fresh head, never silently truncate. Historical notice queries can select the exact through-sequence for an as-of list; current begin notice queries include every later join. No notification claims it could have listed future agents before they joined (T91:38,42; Core:1028; D100/D101; AS/doc.go:142–164; P5).

The durable guarantee is one begin identity and one end identity, not exactly-once physical screen output across terminal death. Reattachment obtains current state/open notices and follows the normal durable event cursor; it never appends another notice, starts a turn or restores anyone. A terminal process retains seen NoticeIDs while attached and refreshes the same list on `outage.joined`, without another begin alert (Core:309–336; AS/loop_session.go:268–350; T91:38,41–42; P10).


## 5. Restoration, restart and duplicate convergence

### 5.1 What can prove restoration (P6)

A qualifying **successfully completed call** is an actual agent-originated normal paid model call whose captured complete terminal is successful, whose request/response/attempt/origin identities match and whose content/protocol is valid. Anthropic successful terminals are `end_turn`, `max_tokens`, `stop_sequence` or `tool_use`; OpenAI requires `completed`, not `failed`, `incomplete` or a safety refusal. Valid tool-use output counts as a completed model call, not authority for its later tool. Availability and money are independent: the original native result may be `usage`, or `unknown` solely because otherwise validated completion cannot yet be priced (for example tariff_ambiguous). The latter may restore availability while its full hold remains. Never accept partial/unknown execution, unknown response grammar/profile, content/capture failure, billed refusal, bare usage, correction, no_charge, released_unsent, old late settlement or a generic completed turn as success. F3-91 does not alter the native financial kind/hold or admit its output to the model loop (T91:39–42; `internal/core/providers/doc.go:60–82`; AS/paid_capture.go:20–69,297–351; AS/paid_settlement.go:69–168,170–231; AS/loop_continuation.go:200–239; P6).

For each of that agent's still-lost memberships, require success observed after its onset source and one current witness:

1. **Provider cause:** a qualifying completion at the matching failed scope can itself clear that scoped condition and restore this member atomically. A completion elsewhere needs a positive prior clear or the moved-work predicate. Credential repair is the specific exception to old-version equality: an actual owner `credential_changed` rebind at the same scope, retiring/revoking the refused version, followed by a successful call using the recorded replacement can prove `credential_replaced`; the rebind alone never restores. A different still-parallel version/account/model/region without that exact replacement proof cannot clear the failure (T91:39; `docs/CONTRACTS.md:144–145`; AS/paid_state.go:13–24; P6).
2. **Owner money:** the succeeding call's ordinary admission and original completion show that the formerly blocking mandatory/account scope was made available, with unknown held exposure preserved. Record the actual native/configuration proof, not a source-only Boolean; an unlimited replacement omits the ceiling in its money witness. A UTC reset/ConfigureSpend/top-up/correction alone only permits a call. A call admitted before this loss/clear cannot retrospectively prove a subsequent money limit healed (T91:39–40; AS/paid_budget.go:29–40,88–121; AS/paid_attempt.go:95–151; P6).
3. **Execution:** ordinary call admission/start has a fresh successful existing integrity check for every affected private scope, or the existing Git Owner reconciliation has positive closure evidence permitting use. That clear evidence is recorded before or with the completion transition; no service-only reinspection/probe is run. Success while the relevant barrier still exists, even in another context, does not restore.

These are cause-clear **conditions**, never another capability or permission grant. An unrelated local tool success/inspection does not replace the completed model call, and nothing sends a model call merely to prove restoration (T91:37,39–40,43; Core:1038–1046; AS/paid_attempt.go:95–151; AS/integrity.go:239–322; G16/owner.go:151–179; P6).

**Moving all work:** this is the existing static owner's configuration change, not an invented default-provider switch or R1 handover implementation. On a successful alternative-provider call, Core enumerates the complete current LoopOptions/settings for this agent **and** every nonterminal durable continuation/pending unsent model admission. All future configured paid bindings and all outstanding work that can still execute must be off the failed provider/scope. Any single unchanged binding or executable owner keeps `failed_work_count > 0`, so a one-turn switch cannot restore. Sent unknown financial attempts are never replayed and are not executable work in this predicate. Bind the zero-count witness to the exact sorted workset digest, source native commit frontier and fresh settings snapshot. Refuse stale/conflicting snapshots; after a cold read rerun the complete predicate. No caller-supplied Boolean, raw owner claim or private-memory inference can establish completeness. A host using only the trusted low-level paid APIs without an enabled exhaustive work registry cannot claim moved-all-work; same-scope clearance/completion remains available (D102; T91:39–40; AS/loop_types.go:31–42; AS/loop_runtime.go:108–127; AS/service.go:95–112; P6/P7).

The registry is execution configuration already selected by the owner; F3-91 records only a completeness witness and its digest, never a second route/credential authority. A changed settings file is not an automatic restoration at startup. A succeeding call rechecks its actual selected workset; enabling another failed-provider binding before completion invalidates the witness. If several causes are now satisfied, emit one bounded `service.complete` group per member in CauseID order, all naming that same source success; aggregate restoration is visible only after the last lost membership is restored. No duplicate group can restore a newer generation (T91:39,41–42; P1/P6/P7).

### 5.2 Native-source gaps and replay (P7)

E is the source journal, not a second authority store: it lives in the colony ledger and selects immutable service metadata under the existing private-object layout. On a first listed refusal (or potentially restorative actual completion), publish/select E before acknowledging that observation. For paid calls, prepare the typed source from the already captured/validated live response before committing the original F3-13 financial result; the normal order is E → unchanged native result → source-drain K/M/N → acknowledgement. Source.object and the existing paid dispatch intent prove the call identity; a financial result is not needed to assert a positively observed successful terminal. A crash after E but before the financial result leaves native SENT recovery unknown/full-held; the observation can still establish availability without changing that hold. A crash before E gives no acknowledged service observation, and restart never guesses one from generic interruption or old native history. No initialization/activation record, old-paid-result scan or service field in the financial object is required (T91:37,40–42; AS/paid_capture.go:297–351; AS/paid_settlement.go:286–329,394–444; LD:2493–2527,3039–3066; P7).

Record E only for a new qualifying agent/cause demand or completion that can advance its memberships; prior E/member semantic identity suppresses duplicate refusals before append. An ordinary busy/permission/task/grant refusal, unrelated success or old financial correction/recovery callback produces no E. The source directory reserves CauseKey→CauseID from accepted E as well as K, so two first observations share one cause even if neither state group has yet landed. Source identities are `(original call/submission identity,agent,cause or completion kind)`, never freshly minted callback IDs. The existing command directory, family matcher and cold-read protocol implement lookup (T91:35,37,41–42; AS/doc.go:89–106,373–463; P3/P7).

`source_through` covers complete E commits whose applicable cause/member actions have all completed, not native financial traffic. Index E positions and receipt coverage during ordinary replay. A drain walks uncovered E in sequence, loads only its selected service metadata as needed outside Service.mu, and emits bounded K/M/N groups. For a completion satisfying several causes, keep coverage before E until the last applicable membership action has committed; a partial crash repeats already matched receipts and completes only missing members. No immutable-response byte or authority answer cache is introduced. Before a timer/new observation is applied, drain preceding E, so a recorded success cannot be overtaken by an overdue timer. Ignored duplicates advance only the process-local cursor; the next real receipt opportunistically persists coverage. No checkpoint record is written per ignored source (T91:37,41–42; AS/doc.go:373–463; ticket-142 ruling:75–80; P7).

Open reduces E/K/M/N/R metadata and rebuilds the directory without clock, paid-object read, goroutine or append; unmatched E appears in service-recovery metadata. The host explicitly calls ReconcileServiceEvidence before enabling the timer/new work. That call consumes recorded E/service-evidence only, making no network/Git/model call, and appends its missing state transitions once. Later configuration changes cannot retroactively prove a completion was restorative; the E-selected completion-time witness wins. A completion cannot restore a newer demand generation than the one its saved permit binds. Legacy logs without E remain legacy native history, not newly diagnosed outages (T91:35,37,41–42; AS/service.go:164–217; LD:3039–3066; P7).

Definite service-evidence publish/append failures must not replace or downgrade otherwise valid financial evidence: complete the original financial result under its existing rules, report the separate service-recording error, and retain the live source for a bookkeeping retry if the incarnation remains usable. No native request is retried. An uncertain ledger append poisons as before; recovery reads what actually committed. Never rewrite a usage result to unknown, release a hold, or spill service metadata into an oversized financial observation merely to simplify this error path. A source absent after failure cannot be fabricated on restart; expose the recording/recovery error. Pre-native nonfinancial refusals similarly record E before returning their qualified service observation, and uncertain writes never pretend it was durably recorded (T91:37,40–42; AS/doc.go:19–21,89–106; AS/paid_settlement.go:286–329,394–444; P3/P7).

### 5.3 Locking, scheduling and non-effects (P7, P8)

All projections, incidence decisions, dedup/CAS and staged plans live under existing Service.mu. Reuse prepare/resolve/revalidate/rerun, its at-most-two unlocked resolution rounds, three moved-tail SubmitAt attempts and existing poison/close handling; no second global “outage lock”. On every unlocked rerun revalidate service/binding/frontier/directory generation and recompute scope, book, required work, clearance and clock. Preserve `Service.mu → loopRuntime.mu → historyIndex.mu`; timer worker never holds its control lock/channel while entering Service, and no OS/network/private-object I/O or wait occurs under runtime.mu (AS/doc.go:427–463; ticket-142 ruling:75–80; P7/P8).

An applied service group mutates only F3-91 projection/directory state and wakes **view observers**. It never alters BudgetBook, grants, task assignments, private heads, occupied slots, role holders, continuation phases, scheduler readiness or paid retry identities. Existing work can complete and explicitly requested eligible calls can run while an agent is marked lost; only their actual ordinary guards decide admission. Do not feed service loss into ticket 90's generic hold; 131 owns that later integration. Close cancels/joins the one timer worker before Service teardown; it does not write loss or restoration. Shared-scope restoration adds no colony restart pacing or fan-out turns (T91:30,40,43; Core:1030,1038–1046; AS/service.go:220–250; P8).


## 6. Command/event and terminal surface

### 6.1 Normal owner Session and terminal (P10)

Extend the internal, unfrozen Session seam, not an external contract. `ServiceStatus{AgentID?}`/`service.status` selects that registered agent, defaulting to the session's agent. `ServiceOutages{OutageID?,After?,Limit,ThroughSequence?}`/`service.outages` returns flattened affected-agent rows sorted `(OutageID,AgentID)`; After contains exactly those two UUIDs. Omit OutageID to enumerate incidents; specify it to refresh one notice. Each row repeats CauseID, incident phase, BeginNoticeID, optional EndNoticeID and AgentID/active-lost Boolean. Limit is 1..128, default 128; Next is the last returned tuple iff another row exists. First page captures a complete through-sequence; subsequent pages require that same current head/filter/caller or return ErrServicePageStale. Status returns aggregate state, copied active/pending causes, generation/outage identity and through-sequence. Queries append nothing and sample no clock. This is a runtime query bound, not a frozen collection limit (Core:309–336; `session/types.go:19–61`; AS/loop_session.go:69–139,268–350; AS/doc.go:142–164; P10).

Both are trusted owner-view operations; no agent tool/catalogue entry exposes observations or colony outages. Extend `session.ContextView` with selected agent's ServiceView for normal attachment. `/service [agent UUID]` shows selected/specified registered-agent state; `/outages` drains all incident pages. Strict `/send` decoding admits only these concrete passive queries, no state-setting command. Normal main also prints the complete owner ServiceStatusSnapshot over all registered agents before terminal.Run, so unconfigured/idle agents are visible without enabling them for work. Display plain non-color state and bounded cause/scope identifiers, never private diagnostics, and never equate available with eligibility/permission (T91:35,38; `session/types.go:82`; `terminal/terminal.go:196–219,342–410,439–472`; P10).

`Since` currently discards records outside its bound agent/session before event conversion. Preserve that filter for ordinary/private records; add only the specific F3-91 handling. Agent membership changes produce `service.changed` for that agent's owner view. Colony notice/join events appear on **one owner notice stream**, chosen as the first configured owner Session by sorted AgentID; all other bound sessions suppress them. This is a view filter, not event duplication in the ledger. An empty-work/startup-refusal path queries directly as trusted owner (§6.2). `outage.began/ended` carry the stable NoticeID; `outage.joined` carries OutageID/new member and refreshes the same begin-list, never another notice. Terminal deduplicates notice alerts by NoticeID across its session pumps and always enumerates the full affected set. Tests assert identities, agents, state and list completeness, not English wording (T91:38,42; AS/loop_session.go:268–387; `terminal/terminal.go:505–565`; P5/P10).

### 6.2 Unconfirmed startup (P9)

Respect the PM-confirmed ticket-16 order and its shutdown guarantee at the eventual coding base: store → workspace (Owner reconciliation before any `git version`/sweep) → agents/runtime/terminal; agents → workspace → store on shutdown. The base's exact order differs and 16 is unfinished: the coder rebases this integration against 16's reviewed final code rather than restoring the old order or reading fence formats (ticket-16 ruling amendment 14; G16/owner.go:105–179; `cmd/dwarf-harness/main.go:55–83`; assignment's pending-16 boundary).

On specifically typed process-unconfirmed workspace failure, retain the store, open agents metadata-only and run source catch-up. Do not EnableTurnLoop, bind credentials, run any workspace command, sweep anything, or call ReconcileLoop merely to manufacture a failure. If actual existing required-work/recovery evidence already records a call blocked by this same Owner, write/dedup its immediate process-loss observation; an already lost member is not restarted, and generic interruption alone is insufficient. If no such demanded work exists, print the process-unavailable condition but every idle agent remains without new loss. This is the refused-call evidence path, not “restart caused loss” (T91:35–38,41; P3/P9).

Use one owner-only `ServiceStatusSnapshot` query over registered agents and current notices, with the same source/dedup rules as the normal query; write it through the terminal renderer to stdout before the fixed startup refusal and exit 1. This noninteractive terminal output is the criterion-5 surface in this failure path, not a functioning workspace/second operating mode. Print all registered agent IDs with state/cause, and the current incident references plus complete affected sets. On uncertain append, report recovery-unavailable/error and no fabricated recorded status. Close agents, any acquired workspace failure resources through their existing retained-owner cleanup, and store in the ruled order, preserving 16's failure aggregation and S4 nil workspace-close seam. On the next successful normal startup, positive existing Owner readiness can clear the barrier but never restore the agent until its successful call (T91:38–42; `terminal/terminal.go:231–244`; G16/owner.go:151–209; P9).


## 7. Criterion proof matrix, rule breaks and fuzz

### 7.1 Consumer-visible criterion matrix (P11)

Use real ledgerstore/agents/Session/terminal boundaries and loopback verified-TLS SSE with fixture credentials; native source fixtures are real prior-family operations, not mock stores or synthesized successful promotion/office events. Fake **clock/timer delivery** only through unexported nil-in-production serviceDeps seams: scripted labeled before-due/at-due/rollback samples and manually released timer wake barriers. Tests inspect state, notices, IDs, exact money and physical POST/process counts; no sleeps, measured duration/wording/source-text assertions or test-only exports. Keep existing paid, integrity, continuation, cross-context and earlier-golden rows unchanged except genuine typed-query additions (T91:22–24,45–47; `docs/CURRENT-RULES.md:15–22`; D152 item 1; ticket-13 ruling:26; ticket-15 ruling:14–23; P11).

| Criterion | Mechanism/records and restart contract | Permanent consumer test and plausible bug caught |
|---|---|---|
| 1 (T91:34) | §3 typed source → K/M, N only at onset. Restore projections, not source effects, on Open. | `TestServiceCauses`: real Anthropic/OpenAI refusals for each listed class, two credential scopes/versions and models, controlled transport failure; exact CauseSpec/agent membership through Session status and reopen. `TestServiceMoney`: agent/credential/colony caps, lifetime and stated-reset periods; exact exhausted versus quote-too-large/task/grant/authorization distinctions. `TestServiceIntegrityDemand` and Windows `TestServiceProcessFailure`: actual selected-object mismatch or retained/unconfirmed Owner refusal, exact scope and immediate loss. Fail if broad error handling merges accounts/models or treats money uncertainty as downtime. |
| 2 (:35) | No qualifying source → no F3-91 append; native refusals remain unchanged. Inert Open/PendingLoops are not M(loss). | `TestServiceNeverCounts`: idle/busy/waiting, view detach/close, ordinary interrupted turn, stopped-host/reopen, task/grant limit, unset/disabled spend and revoked grant. For each assert exact unchanged loss/outage/notice counts and native permission/accounting outcome, not “did not panic”. Include preexisting unrelated outage so a no-op cannot accidentally clear it. |
| 3 (:36) | M(pending) persists first source/due; live `service.expire` alone writes M(loss)/N. Immediate causes produce no pending generation. | `TestServiceOnset`: before-due timer yields zero loss; at-due yields exactly one; repeated refusals preserve the first source; credential/quota/lifetime-money/process/integrity enter immediately; UTC-period exhaustion remains pending. Reopen before/after due appends nothing, explicit enable delivers one due observation; clock rollback, held sample, spurious/stale generation and overflow refuse safely. `TestServiceDemand`: another idle agent sharing the cause has no membership until a real boundary refuses its own required work. |
| 4 (:37) | Evidence catch-up and timer are metadata-only; no model/Git/heartbeat source. | In `TestServiceCauses`, `TestServiceOnset` and `TestServiceCrashConvergence`, count accepted physical loopback POSTs by AttemptID and real process launches: exactly the explicit normal calls, none from detection, timer, status, notices, replay or catch-up. Controlled server refuses any unexpected request and preserves its count; metadata-only stages are observed at barriers, not guessed from elapsed time. |
| 5 (:38) | First/last lost member and N are atomic. N references cumulative affected set; open/past incidence reconstructs on replay. | `TestServiceOutageNotices`: two simultaneous first joins, later worker join, partial restores and last restore; exact one begin/end NoticeID, all affected IDs retained in sorted pages after reopening. Add 129 demanded agents to cross the 128-row page boundary; no truncation or second begin alert. `TestServiceTerminal`: real Sessions into terminal.Run, two agent pumps, scripted `/service` and `/outages`, exact states/IDs/list membership before and after detach/reattach. |
| 6 (:39) | Positive K(clear) is not M(restored). Successful original captured call plus scoped current witness produces M(restored), N(end) only for final member. | `TestServiceRestoration`: reset/rebind/raise/top-up/retry/positive process proof/repair each leave loss; later actual successful call restores once. Billed refusal/partial/failed/incomplete/correction does not. One switched context leaves loss with other failed-provider settings; all work moved plus first alternative completion restores. Change a binding during an unlocked read/held response: stale zero-work witness cannot restore. Two independent causes prevent an unrelated success from erasing the other loss. |
| 7 (:40) | F3-91 has no book/scheduler mutation. Unknown SENT remains full-held; original paid attempt identities never dispatch again. | `TestServiceUnknownMoney`: one explicitly sent unknown attempt, loss, raised cap/clear and separate successful attempt, duplicate observations, reopen twice. Assert exact original held amounts by every scope/period, expected separate successful cost only, zero second POST for the original AttemptID and no extra model call on queued-work/status restoration. Include rollover and configured/unconfigured grant scope so ticket 143 behavior remains intact. |
| 8 (:41) | E/K/M/N/R with canonical source identities; inert Open; explicit source-drain/timer transitions only. | `TestServiceReplay`: earlier goldens and new histories through Open with clock/provider/paid-artifact traps, allowing normal private integrity checks; unchanged state/no append. Reject wrong actor/source/sequence, bad group/version or impossible edge. Generic interruption and old financial history without E establish no loss/restoration. |
| 9 (:42) | §5.2 E source coverage/semantic identities; receipt match before new CAS/sample. | `TestServiceCrashConvergence`: kill/positive wait at E-before-financial-result, financial-result-before-state, first-member-before-ack, last-member/end-before-ack and partial multi-cause success fan-out. Reopen/catch up twice, same/new command duplicates and changed-content retry; exact state, money, stable source/notice IDs and no repeated effects. `TestServiceRaces` covers expiry/completion/withdrawal, first joins/final restores, close/wake and cold-read revalidation. |
| 10 (:43) | §5.3 F3-91-only projection changes; no lifecycle/authority writer or dispatcher. | `TestServiceNoAuthorityTransfer`: real granted agent/context/task state captured before loss, at loss, after restore and replay. Another agent remains denied the original work/resources; original grants/assignments/identity/holder-free metadata do not change; no unexpected native authority/creation record or paid turn. This proves absence of 91-induced authority change, not a fake C8 handover/cardinality implementation. |

The new golden's setup uses a real service-admissible earlier-family prefix, not a contract-only invalid turn/task state. It covers grace/immediate cause creation, two demanded agents joining one incident, explicit clear without restoration, each member's successful completion, late membership listing, semantic duplicate and wrong-source rejection. S1 proves codec/group grammar and unchanged earlier bytes; S2 replays it through actual Core. No claim that the contract golden alone proves runtime/terminal acceptance (D125/D148/D165/D169; `.scratch/dwarf-harness/c3-evidence/ticket-15-design-ruling.md:8–9`; `contract/ledger/continuation_golden_test.go:30–86`; P1/P11).

### 7.2 Named rule breaks (P11)

For each mutation the coder saves the exact original file SHA-256, runs the named row red, restores byte-identically and runs it green; the PM retains both logs and hashes. These are behavioral mutations, not source-text assertions; final evidence names the actual changed line after implementation. A second independent guard that keeps the row green means that proposed mutation is not evidence—choose the actual guard at the named decision point, never remove the assertion (D152 item 1; `docs/CURRENT-RULES.md:17`; P11).

| Break | Deliberate violation | Required red row |
|---|---|---|
| B1 authority/source binding | Accept a source completion whose original agent/context/attempt differs from the lost member it purports to restore (or accept agent-origin F3-91 actor). | `TestServiceReplay/foreign_source` and `TestServiceNoAuthorityTransfer/cross_agent_success`; the target must stay lost and unauthorized source command must not append. |
| B2 credential boundary | Drop immutable credential-version comparison from credential-refusal scope/clear matching. | `TestServiceRestoration/other_credential_version`; another key's success cannot clear the refused version, while an actual owner rebind followed by a qualifying complete replacement call can. |
| B3 money | Release or clear the original unknown SENT hold from the restoration transition. | `TestServiceUnknownMoney`; exact per-scope held/settled figures and original POST identity fail. No physical resend is tolerated as “recovery”. |
| B4 source-gap recovery | Advance coverage past E before every applicable member transition commits, or skip E catch-up after reopen. | `TestServiceCrashConvergence/observation_before_financial`, `/financial_before_state` and `/partial_multicause_completion`; missing state or changed money/notice counts are red. |
| B5 duplicate recovery | Ignore the semantic source/member-generation receipt match and apply a duplicate observation again. | `TestServiceCrashConvergence/duplicate_new_command`; exact original receipt/state/notice/effect counts fail, including duplicate after end. |
| B6 clock/restart recovery | Replace the saved first refusal/due with a fresh startup sample or expire inside Open. | `TestServiceOnset/reopen_before_due`, `/reopen_after_due`, `/held_clock`; Open must append nothing and the later live timer uses the original witness. |
| B7 process reuse/evidence | Treat an unconfirmed Owner error as successful closure/available or run Git after its refusal. | Windows `TestServiceProcessFailure` and executable `TestServiceStartupRefusal`; a real unconfirmed resource stays fenced, no Git/sweep occurs, and demanded-agent status remains lost. |

Credential/privacy positive row: `TestServiceCredentialHygiene` injects a synthetic credential byte sequence in an error/header/body; the existing capture gate must prevent secret persistence in every ledger/private object and F3-91 must use only typed non-secret reasons/IDs. Do not log raw secret/error bytes in failures. Sandbox/native proof code is not changed by 91, so no new A2/sandbox claim or native-proof relaxation is made; B7 proves the consumed refusal remains fail-closed, while ticket 16's own native closure breaks remain authoritative (AS/paid_capture.go:142–157,297–351; T91:22–24,34,37; D152; P2/P9/P11).

### 7.3 Fuzz targets (P11)

New `contract/ledger:FuzzDecodeF3_91` exercises all five payload codecs, canonical submission, unknown optional keys/tokens, duplicate nested keys, integers/clock arithmetic, wrong group order/actor/source/notice bindings and independent complete input/output caps. New `agents:FuzzServiceGroupReplay` mutates valid committed service/source histories and compares accepted preflight/reopen projections, duplicate/source-gap behavior and unchanged exact money. New `providers:FuzzServiceFailure` exercises bounded structured error/header diagnostic parsing with fixture sealed scopes and asserts no panic, deterministic diagnosis and no widened scope/overflow from malformed metadata. Include successful completion with financially unknown/held outcome so availability cannot be equated to settlement (T91:34–42; LD:2329–2351,3091–3126; P1/P2/P7/P11).

Exact PM campaign list: `contract/ledger` → `FuzzDecodeF3_91`; `internal/core/agents` → `FuzzServiceGroupReplay`, `FuzzPaidGroupReplay`, `FuzzScopedGroupReplay`, `FuzzLoopGroupReplay`, `FuzzContinuationGroupReplay`; `internal/core/providers` → `FuzzServiceFailure`; `internal/core/terminal` → `FuzzTerminalCommandJSON` (`internal/core/terminal/fuzz_test.go:110`). Each is a separate 120 s invocation; parser SSE targets are added only if that parser changes.

Existing touched targets: `agents:FuzzPaidGroupReplay` (paid acceptance/source hook), `FuzzScopedGroupReplay` (integrity-refusal source integration), `FuzzLoopGroupReplay` and `FuzzContinuationGroupReplay` (runtime/wake/source and continuation completion integration); `providers:FuzzProviderSSE`/`FuzzOpenAIResponsesSSE` only if their parser code is actually changed (the design needs no grammar change). `terminal`'s existing command fuzz target runs for the changed command decoder. PM runs each new/changed-code target independently for 120 s with `-run '^$' -fuzz '^<target>$' -fuzztime=120s`; all saved seeds run in ordinary checks. Do not rerun unrelated targets as padding, or fuzz live providers/native children (existing target locations: AS/paid_fuzz_test.go:12, scoped_replay_test.go:540, loop_fuzz_test.go:58, owner_fuzz_test.go:14; `contract/ledger/continuation_fuzz_test.go:10`; `internal/core/providers/anthropic_stream_test.go:309`, `openai_stream_test.go:351`; D152 item 1).


## 8. Slice plan, owned paths and verification commands

### 8.1 Four slices and exact production ownership (P12)

All slices wait for ticket 16's final integration. S1 → PM freeze → S2 → S3 → S4; no producer imports an unfrozen F3-91. PM sequences 90 and 91 (not concurrent writes); no 90 eligibility record/type is consumed by 91. New files below are additions inside the existing package, never a module/new public contract. Test files in each named package may receive callsite-only migrations for new value fields; no unrelated code deletion/restyle (assignment's settled items; T91:16–30; `docs/CURRENT-RULES.md:8–17,46–51,72–78`; P12).

| Slice | Owned production paths (repository-relative; brace lists expand to files) | Deliverable and proof |
|---|---|---|
| **S1 — F3-91 contract** | `contract/ledger/{catalogue.go,doc.go,service_loss.go,service_submission.go}`; `docs/CONTRACTS.md`. Tests/new fixtures: `service_loss_test.go`, `service_loss_golden_test.go`, `service_loss_fuzz_test.go`, `contract/ledger/testdata/f3/91/`. | Five-type codecs/submission/groups, selected completion-metadata grammar, E-source coverage/privacy/replay and unchanged old goldens. Advisor reviews once with freeze evidence; PM assigns schema in freeze order and freezes under D125. Catalogue grows by five. No new locking/local race required for S1. |
| **S2 — state/replay/source-directory/query** | `internal/core/agents/{service.go,replay.go,scoped_replay.go,history_index.go,history_prepare.go,doc.go,types.go,service_types.go,service_replay.go,service_plan.go,service_query.go,service_sources.go}`. | Reducer, E source coverage/dedup, global schema/mismatch support, inert Open/passive queries and explicit recovery. New service replay/crash/fuzz fixtures use real host entrances; S3 owns live observation hooks. Package race and ×20 `TestServiceRaces|TestServiceCrashConvergence` rows present here. |
| **S3 — actual evidence, timer, clear/completion** | `internal/core/providers/{response.go,service_failure.go}`; `internal/core/agents/{paid_types.go,paid_capture.go,paid_dispatch.go,paid_admit.go,paid_attempt.go,paid_settlement.go,scoped_execute.go,integrity.go,loop_start.go,loop_runtime.go,loop_continuation.go,loop_manifest.go,owner_recovery.go,service.go,service_sources.go,service_timer.go,service_detect.go,doc.go}`; `internal/core/workspace/{service.go,git.go,doc.go,service_process.go}`. | Actual typed E producers and separate service evidence, preserved financial bytes/semantics, timer/demand/money/clear/all-work predicates and sanitized process bridge. New service cause/money/onset/restoration/race/process Windows tests; pure provider fuzz/workspace bridge rows. Race changed shared-state packages plus ×20 affected service/workspace rows. No gitprocess/winexec/grant/accounting-rule/native-proof production change. |
| **S4 — owner surface/startup/end-to-end** | `internal/core/session/{types.go,doc.go}`; `internal/core/agents/{loop_session.go,service_query.go,doc.go}`; `internal/core/terminal/{terminal.go,command.go,render.go,startup.go,doc.go}`; `cmd/dwarf-harness/main.go`. | Real Session events/queries, complete notice paging, each-agent status, startup-unconfirmed print/refuse branch and final all-ten-criteria smoke. New/updated terminal real-session tests and `cmd/dwarf-harness/{restart_test.go,service_test.go}`; preserve 16's shutdown seam/order. Race agents/terminal and cmd packages if their shared state changes; ×20 `TestServiceTerminal|TestServiceStartupRefusal|TestServiceRaces` as relevant. Close public ticket/status/register docs and private evidence through the drafter/PM, not the designer. |

**Bounded seam instructions:** preserve `decodeFamily`'s existing seven-family return signature; add `decodeServiceFamily` beside it and recognize service groups in `scoped_replay.go`'s family dispatch without widening every old caller. Existing private-integrity traversals may ignore a recognized metadata-only service group; the authoritative accept path separately stages/applies it. Extend `commandMatch` and the history directory with F3-91, rather than implementing another receipt search (AS/scoped_replay.go:43; AS/replay.go:672–681; AS/doc.go:373–463). New Go names are implementation names chosen here, not a cross-file rename of existing symbols.

**Integration recheck, not a new design choice:** ticket 16 is not closed at design time. Coder rebinds Git Owner/report/root refusal and main/shutdown citations to its reviewed landing; it must preserve retained_job/name_absent/unconfirmed meanings, no Git before proof and no fence parsing. If 16 changes a relied-upon API beyond the sanitized bridge or ticket 90 occupies one of the listed files, PM orders/rebases the slice; no coder silently swaps in generic interrupted-turn evidence or couples service loss to eligibility. A substantive semantic change returns for a bounded ruling clarification (assignment settled blockers; T91:22–30; P8/P9/P12).

### 8.2 Verification commands and race evidence

The coder, **not this designer**, runs these in its assigned worktree. PM supplies the standing Go executable/pinned race compiler; every Go invocation sets `GOTOOLCHAIN=local`, empty `GOFLAGS` and explicit `CGO_ENABLED=0` except race (`CGO_ENABLED=1` with pinned `CC`). Commands below use `go` for that supplied executable. Save complete outputs/exit codes. No local duplicate `go run ./tools/check`; D153 exact-SHA hosted Windows/Linux/macOS Check result remains the merge gate (`docs/CURRENT-RULES.md:15–22`; D152/D153).

```text
# S1 focused, then plain whole-package (and unchanged earlier golden digests).
go test -count=1 -v -run 'Test(Service|GoldenF3_91)' -timeout=19m ./contract/ledger
go test -count=1 -v -timeout=19m ./contract/ledger
# Intended new fixture generation only, followed by byte-identical regeneration:
go test -count=1 -run '^TestGoldenF3_91$' -update ./contract/ledger

# S2–S4 focused behavior; package list narrowed to each slice's changed packages.
go test -count=1 -v -run '^TestService' -timeout=19m ./internal/core/agents
go test -count=1 -v -timeout=19m ./internal/core/agents
go test -count=1 -v -timeout=19m ./internal/core/providers
go test -count=1 -v -timeout=19m ./internal/core/workspace
go test -count=1 -v -timeout=19m ./internal/core/session ./internal/core/terminal ./cmd/dwarf-harness

# Shared-state package run, then only actually affected named race rows ×20.
go test -race -count=1 -v -timeout=29m ./internal/core/agents
go test -race -count=20 -v -run '^TestService(Races|Onset|UnknownMoney|CrashConvergence)$' -timeout=45m ./internal/core/agents
go test -race -count=1 -v -timeout=29m ./internal/core/workspace ./internal/core/terminal ./cmd/dwarf-harness
go test -race -count=20 -v -run '^TestService(Terminal|StartupRefusal|ProcessBridge)$' -timeout=45m ./internal/core/terminal ./internal/core/workspace ./cmd/dwarf-harness

# Every changed package: gofmt changed Go files, host vet and pinned staticcheck.
go vet ./<changed-package>
<host-staticcheck> ./<changed-package>
# New build-constrained test/production file: additionally vet/staticcheck with
# GOOS/GOARCH = windows/amd64, linux/amd64, linux/arm64, darwin/amd64, darwin/arm64.
# PM, independently per target from §7.3:
go test -count=1 -run '^$' -fuzz '^<target>$' -fuzztime=120s ./<package>
```

Do not run a ×20 regex that selects zero rows as evidence. S2's races cover the reducer/directory/same-source CAS; S3 adds expiry/paid/money/clear/cold-read/close races; S4 adds display/event/startup concurrency. A no-goroutine/no-shared-state package (session value definitions, pure providers helper) needs only plain/host-static runs unless its implementation actually changes concurrency. Windows native rows run on Windows and build/vet/staticcheck on all five targets; unsupported portable process-tree proof stays an explicit refusal/no new claim. B7's native rows are not faked as three-platform tree proof (D138; T91:22–24; `docs/CURRENT-RULES.md:15–22,132`).

**Actual terminal smoke, S4:** PM/runner launches the built `dwarf-harness` executable against a throwaway real colony/workspace and explicit fixture-only settings/loopback provider; exercises `/service`, `/outages`, one controlled refusal → timer wake → lost → one explicit successful call → restored, then reopens without repeating POSTs/notices. Separate unconfirmed-startup run exercises the real typed workspace refusal and stdout status before exit 1, with no Git beyond the already refused existing reconciliation and no fabricated live calls. Retain command, exact identities, transcripts, store/book queries and POST/process counts. This is the CLI deliverable proof; terminal unit rendering alone is insufficient. No live credential/account or model call is used and no visual/native GUI verification is claimed (T91:22–24,38–47; P9–P11).

Concrete executable smoke command after the runner creates its real throwaway fixture: `go build -trimpath -o <evidence>/dwarf-harness.exe ./cmd/dwarf-harness`, then `<evidence>/dwarf-harness.exe -colony-dir <fixture-colony> -settings <fixture-settings.json>` with its scripted stdin and live loopback server. Use the platform's executable suffix outside Windows. These two fixture paths are runner outputs, never personal paths or repository credentials; flags are the existing executable contract (`cmd/dwarf-harness/main.go:37–45`; P11).

After smoke proof, close docs describe the implementation/evidence and unchanged later-ticket boundaries; PM/drafter add the short Answer/ticket resolution, C3 status/register and private design/ruling/evidence references. Remove only owned throwaway driver/fixture launch scripts from the worktree, retaining evidence copies by hash. No doc/roadmap status is advanced because a design, contract freeze or partial slice alone passed (D125/D145/D152/D161; `docs/CURRENT-RULES.md:27–30`; T91:14–24).


## 9. ownerGates

**None triggered by the recommendations.** All ten criteria stay in this ticket; service-loss procedure, D52 testing-only boundary, existing grant/money authority, frozen-family bytes, dependencies/toolchain and no-live-provider limit remain unchanged. The additive F3-91 freeze is the PM's D125 gate after S1 review. P9's startup handling and P4's durable timer are advisor-ruled implementation choices, not permission to weaken 16 or change onset/restoration policy (`docs/CURRENT-RULES.md:38–44,72–78`; D125; T91:16–30,34–43).

No pending owner answer blocks the proposed design; 16's completion, the fresh advisor ruling and S1's PM freeze remain the explicit implementation prerequisites.
