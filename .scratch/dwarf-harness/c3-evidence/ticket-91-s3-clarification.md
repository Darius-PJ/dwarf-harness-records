```json
{
  "verdict": "clarified",
  "answers": [
    {
      "id": 1,
      "verified": "internal/core/gitprocess/types.go:21-29, 70-78, 86-95; owner.go:18, 93, 106-149 (bare ErrUnconfirmed with a zero-RunID Result at 122-129; RunID minted 137; retention sticky 140-143), 152-182 (zero RunID on cancel 158-160; bare 161-163; Closed 164-181), 186-220; gitprocess_windows.go:257-327 (retained_job 295, name_absent 302/310), 512-727 (UnconfirmedError with the run's own ID 517/523/687; Proof 'live' only at 717-723), 1062-1132 (zero-frame name absence not reported 1106; container IDs in the RunID field 1073/1127); gitprocess_other.go:22-54 and doc.go:95-97 (no Proof and no fences off Windows). internal/core/workspace/service.go:51-58, 187, 192-201, 203, 255; git.go:29-51 (Open's own 'git version' run at 43; cause flattened with %v at 48), 113-144 (Result in hand at 122, class kept in GitError.Err 139-143); errors.go:47-63. contract/ledger/service_loss.go:335-336, 347-351, 376, 382-387; contract/ledger/doc.go:3589-3591, 3736-3737. D-03 and D-04 hold. One premise of the question does not: the frozen source needs no run identity. execution_run_id is optional, execution_proof is required only for process_closed, and a process_refusal's required identity is Origin, turn_id and a source_sequence or command pair.",
      "ruling": "(a) Run ID. S3 copies execution_run_id only from the RunID of a *gitprocess.UnconfirmedError that workspace.ClassifyExecutionFailure finds in the error of a live agents workspace call, when it is a non-zero UUIDv7. A bare class (the Owner's admission refusal, and every case off Windows) gives a zero ID and the member is omitted. Nothing is fabricated, and gitprocess is not changed to supply one. The refusal's required identity is the refused turn's own, which agents already holds. (b) Closure proof. The only source is workspace.Reconciliation.ProcessClosures []ProcessClosure{RunID, Proof}, filled only on openService's success path, in this order: Reconcile's Report.Closed entries by RunID bytes, then the first Git run Open itself completes with a non-empty Proof. That second entry is the frozen text's 'successful workspace operation'. It is needed because Reconcile's results are consumed by the Open that proves them and a zero-frame name absence reports none, so a reconciled Owner can otherwise have nothing to show. Open reports no closure when any Git run during it returned the unconfirmed class (the Owner is retained again), and none on its failure path. For an active process cause S3 writes one process_closed clear from the first entry, copying RunID and Proof. (c) No live success hook. Retention lasts for the process, so a successful workspace operation cannot follow an unconfirmed one in the same incarnation. S3 adds no accessor of closures, no callback and no per-call success hook. (d) Platforms. Where the Owner proves no tree closure, Proof is never set, so a recorded process cause could never clear and its members could never be restored. Under D138 (an unsupported mechanism refuses explicitly and is never replaced by a weaker one) S3 records process demand only where proof is supported: add (*workspace.Service).ProcessProofSupported() bool from gitprocess.Open's Report.TreeProofSupported and require it at the demand hook. ClassifyExecutionFailure itself stays platform-neutral, so S4's seam row runs on all three systems. Elsewhere the native refusal stands and no F3-91 record is written. (e) Allowed changes: gitprocess none; workspace only the items listed. No GitError, exit, stderr or Git invocation changes.",
      "slice": "S3",
      "changes": [
        "internal/core/workspace/service_process.go (new): type ProcessClosure{RunID, Proof}; ClassifyExecutionFailure(err) (blocked bool, runID uuid.UUID) = errors.Is(err, gitprocess.ErrUnconfirmed), with runID from the first *gitprocess.UnconfirmedError when it is a non-zero UUIDv7; (*Service).ProcessProofSupported() bool",
        "internal/core/workspace/service.go: Reconciliation gains ProcessClosures; openService keeps gitprocess.Open's report (187) and Reconcile's (199) and sets report.ProcessClosures after report = s.reconcile(ctx) (255) under rule (b)",
        "internal/core/workspace/git.go runOutput (122-143): record, with synchronisation, the first Result whose Proof is non-empty and whether the unconfirmed class was ever returned; nothing else",
        "internal/core/agents/service_detect.go and service_sources.go: process demand gated by ProcessProofSupported; the catch-up's host-reports input writes the process_closed clear",
        "S4, cmd/dwarf-harness/main.go:82: keep workspace.Open's Reconciliation and pass its ProcessClosures (answer 8)"
      ],
      "rows": [
        "workspace bridge row (all systems): GitError over bare ErrUnconfirmed -> (true, zero); over *UnconfirmedError{RunID} -> (true, that ID); joined with a context error -> still true; ErrExit, ErrLimit, ErrClosed, BusyError, ErrGitUnavailable and nil -> false",
        "workspace Open (Windows, real planted fences): a reconcilable running fence -> ProcessClosures starts with {its RunID, name_absent}; no fence -> exactly Open's own run {RunID, live}; an unreconcilable fence -> error classified blocked and zero closures. Other systems: ProcessClosures empty and ProcessProofSupported false",
        "agents TestServiceProcessFailure (Windows, real retained Owner): reports with closures -> exactly one clear E and one K(clear) carrying the first entry's RunID and Proof, members still lost, a second call appends nothing; empty closures -> nothing appended; B7 as ruled",
        "agents (systems without proof): an unconfirmed-class error at the finish commit (beforeFinishCommit seam, internal/core/agents/service.go:56) writes no F3-91 record and leaves the turn's native outcome unchanged"
      ],
      "ownerGate": null
    },
    {
      "id": 2,
      "verified": "internal/core/agents/loop_manifest.go:319-327 (CommitObserved or its seam; error returned), 212-238 with loop_runtime.go:421-424 (recovery_pending); loop_manifest.go:461-467 (MergeBack error dropped into the scratch_pending stop); tool_files.go:320-323, 328-331, 338-341 (BeginWrite, Lease, Scratch), 292-316 (the deferred EndLocal can replace the error) with tool_execute.go:198-207, 272-291 (unavailable); loop_start.go:505 with internal/core/workspace/mergeback.go:576-600 (ScratchNotices runs no Git); loop_session.go:150-157 (RequestPromotion is the owner's command). The workspace keeps the class through its returns: write.go:343-395 (stored tipRepairFailed), 557-692; mergeback.go:800-950, 993-1030. D-05 holds. The quantum (loop_runtime.go:467-546) sees only the CommitObserved path.",
      "ruling": "All three paths are process demand when the bridge classifies the error and answer 1(d)'s gate holds: each is a workspace operation the loop issues for a bound live turn. Classify at the workspace call site, on the returned error, before anything transforms it: (1) finish's writer commit, between loop_manifest.go:324 and 325, including the seam's stand-in error; (2) finishMerge, on mergeErr at 461-463, before the scratch_pending stop; (3) the file tool's three workspace calls in tool_files.go, before the deferred EndLocal can replace the error. One helper in service_detect.go serves all five sites and takes the turn and the error. It records E through S2's producer with the turn's origin and turn_id, reason process_unconfirmed and the optional execution_run_id of answer 1(a), and it returns nothing: the scratch_pending stop, the recovery_pending state and the unavailable tool result are unchanged, and a definite E failure is only the retained condition. Not demand: ScratchNotices (no Git), the owner's RequestPromotion (no agent turn), the quantum (too late for two of the paths), and any error the bridge does not classify (workspace.BusyError, ErrMergeBackPending, ErrGitUnavailable, exits, cancellation).",
      "slice": "S3",
      "changes": [
        "internal/core/agents/service_detect.go: one process-refusal helper",
        "internal/core/agents/loop_manifest.go:319-327 and 461-467: one call each",
        "internal/core/agents/tool_files.go:320-341: one call at each of the three workspace calls (file added to S3's paths for these lines only)",
        "internal/core/agents/loop_runtime.go: no process hook in quantum"
      ],
      "rows": [
        "TestServiceProcessFailure (Windows, one real retained Owner): a refused finish commit, a refused merge-back and a refused file tool each record the demand when first; all three in one turn give exactly one E and one loss; recovery_pending, scratch_pending and the unavailable result are as before",
        "TestServiceNeverCounts live rows: workspace busy at finish, merge-back pending, Git unavailable, a non-zero Git exit and a cancelled turn append no F3-91 record"
      ],
      "ownerGate": null
    },
    {
      "id": 3,
      "verified": "internal/core/agents/loop_runtime.go:570-664: the token comes from a scope issue or a missing scope state (620-623), from a failed samplePaidLocked (648-650; paid_live.go:118-128 returns ErrPaidClock) and from any prepareHistoryLocked error (660-662; history_prepare.go:205-262: closed, poisoned, refresh or cold-read failure). loopFailureReason maps every ErrIntegrity to the same token (551-556), including bare ones that name no scope (paid_settlement.go:329-331, loop_manifest.go:183-185, loop_continuation.go:113-115). The scheduler turns a clock failure into expiry for every running turn (loop_runtime.go:379-392). scopeIssuesLocked returns the recorded IntegrityIssue, agent scope first (service.go:343-350; types.go:151-163). agentError flattens it to bare ErrIntegrity (scoped_access.go:27-32) on turn admission (loop_start.go:197-200). D-08b holds; main's line numbers are three to five lower than the map's.",
      "ruling": "Confirmed. Integrity demand binds to a recorded scope issue, never to the stop token and never to a bare ErrIntegrity. The cause is built from the IntegrityIssue the guard holds: agent_id, private_scope and context_id from its ReadBinding, revision from its Revision. At loopBoundary the hook copies the context scope's first issue inside the pure phase and records after it, under the same Service.mu hold; a missing scope state has no issue and records nothing. At guarded entrances it uses the value scopeIssuesLocked or inspectLive returned, taken before agentError flattens it. A scope's first issue is stable for the incarnation because issues are only appended, so repeats deduplicate; a different first issue after a reopen is a different cause by the frozen key and is not merged. The clock failure and the history-prepare failure are no cause at all: no E, no K, no membership. They stay native stops, as does any ErrIntegrity that carries no IntegrityIssue.",
      "slice": "S3",
      "changes": [
        "internal/core/agents/loop_runtime.go:620-623: capture the issue in the closure; record after prepareHistoryLocked returns and before the stop is returned",
        "internal/core/agents/loop_start.go:197-200 and amendment 7's scoped guard sites: classify the raw error before agentError",
        "internal/core/agents/service_detect.go: the IntegrityIssue-to-CauseSpec mapping; an issue that cannot form a valid spec writes nothing"
      ],
      "rows": [
        "TestServiceIntegrityDemand/scope_issue_stop: a real corrupted selected object stops the turn and records the cause with the issue's scope and revision, lost at once",
        "/clock_refused: a backwards or failing reviewClock stops turns with the integrity token and appends no F3-91 record",
        "/history_failure: historyResolveError (service.go:51) makes loopBoundary return the token; no F3-91 record",
        "/bare_integrity: a paid-object mismatch (ErrIntegrity without an issue) stops the turn; no F3-91 record",
        "/refused_admission: a turn refused at admission records the same cause the stop would (fails if classification runs after agentError)"
      ],
      "ownerGate": null
    },
    {
      "id": 4,
      "verified": "internal/core/agents/paid_settlement.go:96 (gate: Complete, HTTP 200, valid message ID, model), 106-124 (refusal branch; accepted list at 123), 160-162 and 223-225 (a ContentError keeps kind usage with error class protocol_error), 170-173 (OpenAI: completed, incomplete or failed, plus settlement-only tests), 204-207 (tariff_ambiguous leaves kind unknown); paid_dispatch.go:258-264 (a refused capture keeps Complete and status 200 but sets ContentError); paid_capture.go:217-222 with 309-333 (a substituted observation has status 0 and Complete false); loop_continuation.go:203-206, 228, 289 (the loop is stricter); frozen text contract/ledger/doc.go:3617-3623. D-09 holds.",
      "ruling": "S3 implements the frozen predicate exactly, as a conjunction: the gate at paid_settlement.go:96, and ContentError false, and a stop reason in derivePaidResult's accepted non-refusal list for Anthropic or 'completed' for OpenAI. It is computed from the captured paid_observation object that recordPaidEvidence has just read and validated (327-331) and the attempt's sealed profile. It is never computed from derivePaidResult's output and never from the loop's acceptance. The result kind cannot stand in: a refused capture yields usage, and a tariff-ambiguous or unparseable-usage completion yields unknown although the call completed. So max_tokens, stop_sequence and model_context_window_exceeded restore although their turn ends content_invalid; a tariff-ambiguous OpenAI completion restores with its hold untouched; a ContentError completion, a refusal, incomplete, failed and any substituted capture do not. OpenAI's unknown-event and profile-violation tests at 171 are settlement conditions and are not added. A substituted capture is also excluded by answer 6's empty token.",
      "slice": "S3",
      "changes": [
        "internal/core/agents/paid_settlement.go: one pure predicate beside derivePaidResult; the accepted-stop list at 123 becomes one shared unexported value; derivePaidResult's results are unchanged"
      ],
      "rows": [
        "TestServiceRestoration/terminal_max_tokens: restores; the turn itself ends content_invalid",
        "/content_error_usage: an observer-refused capture settles as usage and does not restore",
        "/openai_tariff_ambiguous: restores; financial kind unknown; hold unchanged to the micro",
        "/refusal, /openai_incomplete, /openai_failed, /substituted_capture: no restoration"
      ],
      "ownerGate": null
    },
    {
      "id": 5,
      "verified": "internal/core/agents/paid_settlement.go:262-445: first locked phase from lookupPaid (284) to the unlock (321) with s.preparing held (319); handle check 290-296 and TrustedEvidence branch 297-299; unlocked read and validation of the observation and message objects (327-374); second locked phase from lookupPaid (375, unlock deferred 376) through the pure financial phase (388-441: reload, command lookup, duplicate-evidence branch 403-414, derive 419, version check, preflight) to submitPaidGroupLocked(..., false) (444). paid_live.go:262-268: false means plain Submit. internal/core/agents/doc.go:688-700 states that observation and settlement groups keep plain Submit because the workspace is a second writer. history_prepare.go:205-262: the pure phase can release Service.mu for a cold read and reruns whole. Loop caller: loop_continuation.go:174-178. D-10 holds; the ruling's 'both SubmitAts' and its ':263-303' do not.",
      "ruling": "Order: service_completion object (success only) -> E -> unchanged financial group -> drain -> return. (1) Only the live branch with no correction and a non-empty handle token (answer 6) can produce E. TrustedEvidence and CorrectPaidSettlement never do. (2) The diagnosis or the terminal predicate is computed in the unlocked window from the validated object. For a success the permit snapshot is taken under Service.mu after draining earlier uncovered E, the object is published outside the lock under the context gate, and the snapshot is revalidated in the hold that submits E. A stale snapshot is rebuilt, never submitted. (3) E is committed in the second locked phase, after the second lookupPaid has found no receipt (375-382) and before the financial pure phase (388), through S2's locked producer with its own read set, SubmitAt and tail bound. 'The same hold' means this locked phase: the producer may suspend the lock for cold reads exactly as the financial phase can, and because E precedes that phase the existing closure revalidates everything afterwards. Do not build the financial drafts first. (4) The financial group is unchanged: same drafts, same plain Submit. S3 does not make it conditional. (5) A definite E failure, including the tail bound, neither stops nor alters the financial result. The source is retained for the incarnation and retried at the next drain, when it carries native_result_sequence and financial_kind because the result now exists. An uncertain E append poisons as today and the financial group is not attempted. (6) After the financial phase returns, with success or error, release Service.mu, drain under its own cycles and return the financial receipt and the financial error only. (7) A retry with the same handle writes no second E (semantic identity is the attempt), and a receipt match (304-308, 380-382) records no E. Windows to cover: after the paid observation and before E; after the completion object and before E; after E and before the financial Submit; after the financial Submit and before the drain; mid-drain on a multi-cause completion; and the two definite failures (E refused; financial phase refused after E).",
      "slice": "S3",
      "changes": [
        "internal/core/agents/paid_settlement.go recordPaidEvidence: add the E step between 382 and 388 and the drain after the unlock; the financial closure and its Submit are untouched",
        "internal/core/agents/service_detect.go: build the paid E and the permit snapshot"
      ],
      "rows": [
        "TestServiceCrashConvergence (live path)/completion_object_before_observation: kill after the object, before E -> reopen takes nothing from it; the attempt recovers unknown with its full hold; one POST",
        "/observation_before_financial: kill after E, before the financial Submit -> catch-up applies E once; recovery records the financial result by TrustedEvidence with no second E; exact holds; one POST",
        "/financial_before_state: kill after the financial commit, before the drain -> catch-up applies state once; no second financial record or notice",
        "/definite_observation_failure: E refused definitively -> the financial group commits with identical bytes and receipt and the call returns no service error; status shows the condition; the same incarnation's next drain records E with the native result sequence; after a crash instead, nothing is invented",
        "/same_handle_retry: financial phase refused after E (version moved) -> the retry writes no second E and one result",
        "TestServiceRaces x20: two RecordPaidObservation calls on one handle, with the same and with different command IDs -> one E, one result, one state transition",
        "TestServiceNeverCounts: TrustedEvidence and a correction record no E",
        "FuzzPaidGroupReplay as ruled"
      ],
      "ownerGate": null
    },
    {
      "id": 6,
      "verified": "internal/core/agents/paid_dispatch.go:136 (exchangeCtx is the caller's context plus the local DispatchTimeout), 230 (transport.Do), 231-246 (reader error; net.Error test 242-245), 247-249, 250-252 (context attribution only for an incomplete stream), 253-264 (gate.failed forces ContentError and capture_refused), 268; loop_text_gate.go:25-37, 47-58 (a secret match or an observer error sets failed); paid_capture.go:297-351 (substitutions at 309-310, 315-316, 321-322, 331-333; the only handle constructor at 350); paid_types.go:139-144 (four unexported fields), 158-165; paid_settlement.go:290-299; internal/core/providers/response.go:109-113 and openai_response.go:71-75 (a failed error-body read returns ErrProtocol, not the net.Error); transport.go:70-87 (the client timeout equals DispatchTimeout and starts after exchangeCtx). D-11 holds.",
      "ruling": "One unexported field on ObservedPaidCall carries the final token: empty, provider_response or transport. Nothing else crosses. The diagnosis is computed later from the captured object plus this token, and the frozen shape stores only the two tokens. dispatchPaid decides it after the gate.failed block (264) and passes it to publishPaidObservation, which stores it in the handle and clears it whenever it substitutes the observation. Decision, in order: (1) gate.failed -> empty; (2) transport.Do returned an error, or the reader's error is a net.Error -> transport if exchangeCtx.Err() is nil, else empty; (3) any other reader error while exchangeCtx is done -> empty (caller cancel, Close, local deadline); (4) a response was read -> provider_response; (5) otherwise empty. A response fully read before the context ended keeps provider_response. An empty token means no E of either kind. The pure diagnostic maps the unreachable and timeout classes to code unreachable only with the transport token, so a failed error-body read (class set by the reader, token provider_response) establishes nothing. No exported accessor, no field on PaidDispatchOutcome or on the observation object, and no change to providers' existing files.",
      "slice": "S3",
      "changes": [
        "internal/core/agents/paid_types.go:139-144: one unexported token field",
        "internal/core/agents/paid_dispatch.go:264-268: decide the token from networkErr, the reader error, exchangeCtx.Err() and gate.failed; pass it on",
        "internal/core/agents/paid_capture.go:297-351: accept the token, clear it on each substitution, set it at 350",
        "internal/core/agents/paid_settlement.go: read it only in the live branch, after the handle check (290-296)"
      ],
      "rows": [
        "TestServiceCauses: a refused connection and a reset after headers -> unreachable at endpoint scope with token transport, grace",
        "a caller cancel mid-exchange, a Service close mid-exchange and a server held past DispatchTimeout -> no E",
        "a secret echoed in output and an observer error -> no E although the financial result is usage",
        "a 429 whose observation capture is substituted -> no E; the same 429 captured normally -> rate_limited with token provider_response",
        "TestServiceNoAuthorityTransfer: a zero or foreign handle is refused ErrDenied and records nothing"
      ],
      "ownerGate": null
    },
    {
      "id": 7,
      "verified": "Writers of scopeState.issues are appends only: internal/core/agents/integrity.go:181, 208 (Open's scan), 372 (inspectScope, live or at Open); replay clones them forward (replay.go:186-195); a search of '.issues' in non-test agents code finds no remover. A fenced context's revision still advances at turn end (loop_manifest.go:365-370; that path checks no issue). Open's inspection covers every head, the whole transcript chain and the materializations (integrity.go:124-234) and writes nothing (service.go:169-224). EnableTurnLoop refuses a configured context with issues (loop_runtime.go:147-150). Sessions need the loop (loop_session.go:33-35). D-14 holds.",
      "ruling": "integrity_verified is written only by the explicit host catch-up, never in the incarnation that holds the issue, and there is no live-pass writer in v1. When: on a start that was not refused, in the reports reconcile that main runs once after EnableTurnLoop has returned nil (answer 8). The drain-only call used by the two refusal branches and by EnableTurnLoop's own catch-up writes no clear, and Open writes none. By whom: ReconcileServiceEvidence as core, added in S3. Condition, under Service.mu: the private_integrity cause is active, and the scope it names exists in this incarnation with an empty issue list. Because issues are never removed, that holds only in a Service opened after the repair, whose Open inspection is the restart integrity check. S3 then writes one cause_clear E (reason integrity_verified, the cause's cause_id, its own agent_id, no origin, turn or attempt) and one K(clear). It never restores. The clear is bound to the cause by identity; the scope's current revision is not compared, because a fenced context's revision advances when its turn ends. Every active private_integrity cause of a verified scope is cleared. Amendment 10's 'live entrance pass' stays a permitted source and is unused: as built it cannot occur where the issue was recorded, and in a later incarnation the catch-up precedes every turn.",
      "slice": "S3",
      "changes": [
        "internal/core/agents/service_sources.go ReconcileServiceEvidence: an explicit host-reports argument; absent = drain only; present = drain, then this integrity clear and answer 1's process clear",
        "internal/core/agents/service_detect.go: the scope predicate",
        "no change to integrity.go's issue handling and none to Open"
      ],
      "rows": [
        "TestServiceRestoration/integrity_same_incarnation: the object is repaired on disk without reopening -> the reports reconcile appends nothing and the member stays lost",
        "/integrity_verified_after_reopen: repair and reopen; the drain-only call appends nothing; the reports reconcile appends exactly one E and one K(clear); the agent is still lost; its next successful call restores it once; a second reports reconcile appends nothing",
        "/integrity_unrepaired_reopen: no clear",
        "/integrity_recurs_before_success: after the clear a new issue appears on the scope; a successful call in another context does not restore"
      ],
      "ownerGate": null
    },
    {
      "id": 8,
      "verified": "cmd/dwarf-harness/main.go:9-27 (no gitprocess import), 35-37 and 88-90 (the only seam replaces the workspace close), 50-53 (refusal line), 65-73, 75 and 92 (the agents Open report is held), 82 (Reconciliation dropped), 83-86 (stop, then the refusal), 125-128, 140-149, 210-236 (describe has no entry for the class). cmd/dwarf-harness/integrated_restart_windows_test.go:53-66, 96 (the real planted-fence row pins only the refusal prefix), 108-150 (it runs in a child process). internal/core/terminal/terminal.go:16-17 (imports session only), 34-49, 102-104, 139, 232-243; render.go:29-47 (unexported; it is the escape boundary); startup.go:23-45 (WriteStartup is already an exported pre-Run writer built on render, which the map missed). tools/check/boundary.go:45-61. D-16 and D-17 hold with that one omission.",
      "ruling": "S4 adds three things and changes nothing else. (1) The ruled seam: one unexported package variable in main.go, nil in production, in the form of workspaceCloseOverride, that wraps the workspace open call and may return its result triple. (2) One exported writer in the terminal package beside WriteStartup, built on render and the existing label, taking an io.Writer and session or terminal value types; terminal still does not import agents. main uses it for the snapshot in both refusal branches and before terminal.Run on the normal path, and the interactive /service and /outages lines use the same formatting code. There is no exported render or say, no Config hook, no change to Run's agent requirement or ready line, and no label formatting in main. (3) main keeps workspace.Open's Reconciliation and, after EnableTurnLoop returns nil, makes the one reports reconcile with its ProcessClosures (answers 1 and 7). Branches: on a workspace.Open error that workspace.ClassifyExecutionFailure reports blocked (run ID ignored), and on an EnableTurnLoop error that is ErrIntegrity, main runs the drain-only reconcile, takes ServiceStatusSnapshot, prints the snapshot and the typed condition line, then runs the existing stop() and refuse() in today's order. describe is unchanged and the refusal line stays byte-identical, so the process branch still ends 'unclassified failure'; the condition line carries the class. main gains no gitprocess import.",
      "slice": "S4",
      "changes": [
        "cmd/dwarf-harness/main.go: the workspace-open seam variable; keep the Reconciliation at 82; two print-then-refuse branches at 83-86 and 125-128; the reports reconcile after 128; the snapshot print between 140 and 149",
        "internal/core/terminal/startup.go: one exported service-status writer",
        "internal/core/terminal/terminal.go: /service and /outages reuse it"
      ],
      "rows": [
        "TestServiceStartupRefusal/seam (all systems): a substituted unconfirmed-class error -> exit 1; every registered agent's state and every open incident's full list printed before exactly one 'startup refused: workspace:' line; no 'colony opened' or 'ready'; the ledger gains nothing but drains of already recorded E",
        "/planted_fence (Windows, child process): a real unconfirmed fence -> the same output order; planted files byte-identical; lost members shown lost; no clear written",
        "/integrity: a configured context with a real issue -> snapshot, then exactly one 'startup refused: turn loop:' line; no clear written",
        "/next_start (Windows): after a recorded process loss, a start over reconcilable state writes one K(clear) with the copied proof, shows the agent still lost and sends no notice",
        "B7 executable half as ruled"
      ],
      "ownerGate": null
    },
    {
      "id": 9,
      "verified": "internal/core/agents/loop_continuation.go:143-146 (AdmitPaid's error returned), 170-173 (a busy dispatch mints a fresh dispatch command ID), 203-206 (a dispatched provider failure does stop its turn); loop_runtime.go:253-255 (one admission command ID per call), 481-506 (a BusyError at a model entrance gives wait reason paid_prepare, 497-498), 514-535 (if anything moved during the quantum, including s.p.through, the turn is requeued instead of parked, 519-523; otherwise parkOwner, 525-526), 429-431 and 228-234 (a parked turn is selected again after any later notify), 545-546 with 551-568 (only non-busy errors stop); internal/core/agents/doc.go:1047-1051; paid_budget.go:100-119; loop_session.go:266-302 (owner cancel is a durable owner.stop). Frozen rule: contract/ledger/doc.go:3572-3573, 3695. D97 item 3, D102 item 2, docs/DESIGN-CORE-AND-LAUNCHERS.md:1026 and ticket criterion 3. D-08a holds: P3's premise is false for budget_exposure and true for dispatched provider failures and for the integrity stop.",
      "ruling": "Confirmed. The frozen rule stands: withdrawal only when the cause clears while the generation is pending, no owner_cancelled writer, and no test of live demand at due. It rests on the frozen text and on P3's other reason, which D-08a strengthens: a parked turn is refused again on every wake, and those repeats, like other turns' refusals, are not recorded, so the set of refused work a cancel would have to cover is not in the ledger. It is also what D102 item 2 fixes for the static path: the grace counts from the first refused call, and the book recheck at expiry is the test that the barrier still holds. Consequences for S3: (1) A parked turn is the normal money case. The admission entrance is re-entered on every wake with the same command, the dispatch entrance with a fresh one, so suppression must key on the open (agent, cause) generation and every repeat must append nothing. This is a liveness rule: the quantum requeues a refused turn whenever the ledger moved during it, so a hook that appended on each refusal would spin the scheduler and grow the ledger without bound. (2) At due S2's timer decides from the book alone. S3 adds no liveness test, no cancel hook and no record on an owner stop; the turn stays parked, and F3-91 neither cancels nor retries it. (3) The parked turn is its own succeeding call: when the limit is raised or the period rolls over, its retry passes admission, S3 records budget_available there in PM answer 8's shape, and that call's success restores the member. (4) A lost member's repeat refusal changes nothing, so a cleared K is not by itself a current witness; see notesForS3. Owner: not a gate, and no question is pending. An owner-cancelled, money-blocked turn's agent is recorded lost at due only for a ceiling with a stated reset that is still exhausted at due. That follows the criterion as landed, and it is the same outcome the static path already has for a refused provider call whose turn has stopped. He must be told, not asked: the close's assistant decision entry for the withdrawal rule states the corrected reason and this behaviour. Changing it would be an additive F3-91 amendment and his decision. Ticket 130 inherits the real question: what 'stop' within the grace does once the grace counts from a router pause (D97 item 3's 'stayed paused').",
      "slice": "S3",
      "changes": [
        "internal/core/agents/paid_admit.go and paid_dispatch.go refusing entrances: the money hook suppresses a repeat before any append; no change to parking",
        "no change to loop_runtime.go's park, wake or stop paths and no hook in cancelTurn"
      ],
      "rows": [
        "TestServiceMoney/parked_turn_repeats: a real parked turn woken repeatedly -> one E in total; the ledger length is stable between wakes; the turn ends each wake parked",
        "/parked_turn_lost_at_due: the timer at due with the scope still exhausted -> lost; the turn is still parked; no cancel, stop or retry record",
        "/owner_cancel_before_due: the owner cancels the parked turn; at due with the scope still exhausted -> lost, no withdrawal; with the limit raised before due -> withdrawn by the book recheck",
        "/raised_limit_restores: the limit is raised -> the same turn's admission passes, budget_available is recorded once, its completion restores once; exact holds"
      ],
      "ownerGate": null
    }
  ],
  "notesForS3": [
    "No conflict with PM S2 answers 1-9. One interface touch on S2's work: the public catch-up gains the explicit host-reports argument (answers 1 and 7); absent means today's drain-only behaviour. The PM may hand that parameter to the S2 coder now or let S3 add it.",
    "Permit selection needs the live barrier, not only K's condition. A pending or lost member's repeat refusal has no effect, and the frozen grammar has no K-only reactivation (contract/ledger/doc.go:3695), so K can stay cleared after the barrier returns. For an execution cause choose execution_clear only if, besides the cleared K, the scope has no issue now (integrity) or no workspace error has been classified unconfirmed in this incarnation (process: one sticky flag in the Service, set by the demand hook even when the refusal is deduplicated). Otherwise the permit is blocked. This is P6's 'current' witness.",
    "Hooks never change a native return value, stop reason, tool result or turn state. A definite E failure is only the retained condition.",
    "A clear E needs an agent_id (contract/ledger/service_loss.go:428): use the cause's own agent for a private cause and S2's existing clear convention for the colony process cause. No origin, turn or attempt is invented.",
    "Take execution_run_id only at live call sites. Errors joined by Reconcile can carry a container ID in the same field (gitprocess_windows.go:1073, 1127); they reach only S4's startup classification, which ignores the ID.",
    "Production agents code imports no gitprocess. Tests may, to build real class values for the beforeFinishCommit seam (internal/core/agents/service.go:56).",
    "The fields added to the workspace Git runner are written by concurrent Git runs; they need synchronisation and fall under the ruled workspace race run.",
    "No new fuzz target arises here. FuzzServiceFailure and FuzzPaidGroupReplay stay as ruled; the bridge parses nothing.",
    "Rebind these ruling citations: the P6(a) and amendment 9 gate is paid_settlement.go:96 and the stop list is 123; P7's locked phase is 375-444; loopBoundary's issue stop is loop_runtime.go:620-623; EnableTurnLoop's refusal is 147-150."
  ],
  "notesForS4": [
    "Order in main: store, OpenPaid, workspace open through the seam, [unconfirmed branch], ReconcileLoop, bindCredentials, EnableTurnLoop, [ErrIntegrity branch], the one reports reconcile, sessions, WriteStartup, snapshot print, terminal.Run. Amendment 14's order is unchanged.",
    "Query the snapshot before stop() closes the Service and print it before the refusal line. Keep stop() before refuse(), so an unconfirmed drain still prints its own line first as today (main.go:65-73, 83-86).",
    "The Windows planted-fence row must run in a child process: a retained Owner keeps the root lock until exit (internal/core/gitprocess/owner.go:18, 199-203). The seam test may import gitprocess for the class value; main.go may not.",
    "Status and snapshot causes come from F3-91 records only. A turn's 'integrity' stop reason is not a cause (answer 3).",
    "A service-only reconcile error is not a new refusal class: show the recovery condition and go on to the existing refusal or, on the normal path, to the sessions. Poison surfaces through the next Core call as today (PM S2 answer 9).",
    "On systems without proof the seam row still runs the branch. No process cause can be in their ledgers (answer 1(d))."
  ],
  "notesForClose": [
    "Record as a v1 limitation with an assistant decision entry: the process cause is recorded only where the Git Owner proves tree closure (Windows). Elsewhere an unconfirmed Owner is a native refusal only, under D138.",
    "The withdrawal-rule entry the ruling already requires must carry the corrected reason (answer 9) and the owner-visible behaviour, and ticket 130 should receive the 'stop within the grace' question.",
    "Record that integrity and process clears are written only at a start that was not refused, and that amendment 10's two live sources are unused in v1 because the as-built code cannot reach them.",
    "Two additions to the ruled bridge for the compatibility list, both internal Go API: (*workspace.Service).ProcessProofSupported and the host-reports argument of ReconcileServiceEvidence. ProcessClosures also carries Open's own first proven Git run.",
    "Known gaps to list, not fixed here: an Open-time 'git version' run that itself ends unconfirmed is flattened to Git-unavailable (internal/core/workspace/git.go:48), so that incarnation records no process loss; a network failure while reading a non-200 body is not transport provenance (providers/response.go:109-113; openai_response.go:71-75).",
    "Nit for a later ticket: the unconfirmed-startup refusal line still reads 'unclassified failure' because the ruling keeps it byte-identical.",
    "Ruling text to correct in the close: P7's 'both SubmitAts under one hold' is SubmitAt for E and the existing plain Submit for the financial group in one locked phase.",
    "Not done: no command, build, test or Git was run. The request's SHA-256 and the checkout's commit were not recomputed. The checkout was read as d16c779 by content (F3-91 section at contract/ledger/doc.go:3475; no S2 service files). The S2 worktree was read for context only, and nothing here rests on it."
  ]
}
```
