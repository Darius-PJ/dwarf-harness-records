I have what I need. The brief's code claims check out (callers of `taskReadiness`/`operationReadiness`, `capacityExposures` signature, `preparing` book, `Store.Colony()`, hooks, F3-11 state table, fixtures). One planning defect is blocking-relevant under D152 item 3 and gets an amendment; the design choices themselves stand.

{
  "verdict": "approve-with-amendments",
  "rulings": [
    {
      "id": "P1",
      "disposition": "approve",
      "ruling": "Add Service.ListTaskFacts/Agent.ListTaskFacts with §3's types; ListTasks/TaskStatus/TaskView/TaskPage untouched. No title is synthesized: RuntimeTaskChanged has no title field (contract/ledger/scoped_authority.go:166-184) and the row carries only DescriptionRef metadata, exactly as taskView builds it (scoped_task_query.go:138-154). Assignment is the stored value with AssignerActor/Assigner (scoped_values.go:52-59), so claim versus delegation is recorded provenance, not a guessed flag. Contract classification: no change to F3-10, F3-11, F3-12, F3-13 or F3-139, neither additive nor breaking; internal/core/agents types are not ledger encodings, and the query reads both F3-11 and F3-12 through the existing loaders in ledger order (loadTask, scoped_state.go:124-160; D144). Nothing for the PM to freeze. ErrTaskFactsStale stays a new sentinel: ErrRevision is the write-CAS refusal (paid_controls.go, registration) and must not be blurred with a read-only refusal."
    },
    {
      "id": "P2",
      "disposition": "approve",
      "ruling": "Membership is Assignment != nil && Assignment.Assignee.AgentID == q.AgentID && State in {waiting, active}; buckets exactly per the §4 table; unassigned, submitted and terminal tasks produce neither row nor count. This matches F3-11's closed state table (contract/ledger/doc.go:1914-1929: waiting/active/submitted/completed/failed/cancelled, wait reasons dependency/input/review/explicit_hold) and the fortress spec's waiting-stockpile versus active-workshop split (spec.md:39,49). One target agent per query is a faithful reading of 'each agent's'; a consumer iterates agents. Both ready and ready_queued sit in WaitingReady with their Readiness/Reason preserved, so 'ready-but-queued' remains distinguishable inside the bucket."
    },
    {
      "id": "P3",
      "disposition": "approve",
      "ruling": "Reuse ListTasks's discipline: extract the selected-chain precheck (scoped_task_query.go:71-98) into one unexported helper called by both; then per task authorize(origin, q.GrantID, task.inspect, {task}, nil, 0, through) and audience-contains-viewer, in ListTasks's order (:104-114), before readiness, counting, sorted insertion, look-ahead or copying. ErrDenied skips; any other error aborts with TaskFactsPage{}. The owner entrance passes no grant and is never an agent-supplied actor string. Hidden dependencies stay opaque through the existing viewer check in taskReadiness (:166-175, canInspectTask over the viewer's whole current grants). Cursor fields confer no authority: every page re-authorizes every row. Criterion 4 is met: a forbidden task cannot reach a row, Counts or the more-results proof. The brief's error precedence (input ErrInvalid/ErrTooLarge, then precheck ErrDenied, then cursor ErrInvalid, then ErrTaskFactsStale) stands; tests pin that order."
    },
    {
      "id": "P4",
      "disposition": "approve",
      "ruling": "Add includePreparing bool to taskReadiness and operationReadiness; taskView passes true, the new query false; inside the scope loop prepared is [4]int64{} unless includePreparing, then passed to capacityExposures (signature verified at scoped_budget_history.go:131; call at scoped_task_query.go:239; book.preparing is map[ScopeKey][4]int64, scoped_budget.go:27). Durable unreleased turn admissions (:258-262) stay included: they are committed work, not preparation. Callers verified: taskReadiness has one caller (:150), operationReadiness two (:192, :196); TaskStatus/ListTasks semantics are unchanged. This is required by P5, not optional: a page and its Counts at one ThroughSequence must be a pure function of committed state, or same-head continuation and stable Counts are false promises."
    },
    {
      "id": "P5",
      "disposition": "approve",
      "ruling": "Raw TaskID byte order; one scope-bound scalar cursor {ColonyID (Store.Colony()), Actor, Origin, AgentID, GrantID, ThroughSequence = p.through, AfterTaskID = last returned ID}; continuation only at the same current head, any later commit (related or not) returns ErrTaskFactsStale after the precheck, so revocation is ErrDenied first; recovery is Cursor=nil against the current task map, never ledger history; reopen at an unchanged head accepts the same cursor after the same BindAgent. Criterion 5 is met. The scope fields are consumer-mistake detection, not security (the brief says so correctly); keep them. Recorded consequence, fixed in amendment 3: under churn an enumeration restarts, but Counts are complete on every page, so count-only consumers never page."
    },
    {
      "id": "P6",
      "disposition": "approve",
      "ruling": "1 <= Limit <= MaxLiveTasks with ErrInvalid/ErrTooLarge as ListTasks (:66-69); bounded sorted insertion keeping Limit+1 IDs (:116-121); Counts are the full filtered sum, which means readiness is evaluated for every eligible waiting task on every page (active tasks return at :158); no new index, cache, LRU entry, limit or default; history above a lowered MaxLiveTasks stays intelligible. No numerical bound is set, so D160 item 7's profiled driver is not triggered. Cost statement (O(T·Limit) ID moves plus existing per-task authority/readiness work, cold lookups may still scan) is accurate and goes into doc.go."
    },
    {
      "id": "P7",
      "disposition": "amend",
      "ruling": "Three slices, real ledgerstore/Service/Agent, hooks as coordination not mocks, rule breaks limited to disclosure (this read-only ticket adds no write window), no fuzz or measurement: approved. The slice assignment is amended (amendment 1): the authorization and pagination regressions land in S1 with the code they prove. Under D152 item 3 a slice that lands authorization filtering and bounded pagination without the test that fails on their bypass is a blocking finding at its own review, and main would carry untested filtering between slices; a later test-only slice cannot cure that. The smoke's handling is amended (amendment 2)."
    }
  ],
  "amendments": [
    "1. Slice plan (P7, §7-§8). S1 lands task_facts_types.go, task_facts.go, the scoped_task_query.go precheck/includePreparing changes, task_facts_test.go (TestTaskFactsBucketsAndAssignments, TestTaskFactsCommittedReadiness) and task_facts_authority_test.go (TestTaskFactsAuthorization with its three disclosure rule breaks, TestTaskFactsPagination). S2 lands task_facts_recovery_test.go (TestTaskFactsTransitionRecovery, TestTaskFactsReviewTransitions). S3 lands task_facts_race_test.go (TestTaskFactsQueryRace), the doc.go update and the smoke. Production corrections in S2/S3 stay in S1's source files. Test content, oracles and plausible bugs are exactly the brief's §7 rows. Commands: S1 = gofmt on its five files; go test -count=1 -run '^(TestTaskFactsBucketsAndAssignments|TestTaskFactsCommittedReadiness|TestTaskFactsAuthorization|TestTaskFactsPagination|TestScopedTaskTransitionsAndProjection)$'; whole-package -race -count=1; -race -count=20 on TestTaskFactsCommittedReadiness; the three rule breaks each red on the named row then byte-identical restore green. S2 = gofmt task_facts_recovery_test.go; focused run of its two tests; no local race run (no locking, goroutine, channel or shared-state change). S3 = gofmt task_facts_race_test.go and doc.go; focused TestTaskFactsQueryRace; whole-package -race -count=1; -race -count=20 on TestTaskFactsQueryRace; the smoke run. Every slice: one plain go test -v -count=1 ./internal/core/agents, go vet, staticcheck; hosted exact-SHA check before main moves.",
    "2. Smoke (P7, §7). internal/core/agents/task_facts_smoke/main.go never enters a commit: it exists only in the S3 working tree, is run with go run, and is deleted with its directory before the slice commit. The S3 evidence retains the program text and its four output lines so the run is reproducible. It uses exported ledgerstore/agents API only (the test fixtures are unexported).",
    "3. Package documentation (§5, S3 doc.go). The task-facts paragraph states the consumer recovery contract: Counts are complete on every page whatever Limit, so a count-only consumer needs one call per agent at Limit 1; an enumeration staled by any later commit restarts from a nil cursor against current state, never ledger history; one page at Limit = MaxLiveTasks covers every current task unless live tasks exceed a lowered MaxLiveTasks, in which case paging at an unchanged head is required. No private decision text or links.",
    "4. Close records (§8). D161 governs: the ticket adds no build record; its Answer and evidence state what it built; one plain-sentence notes file; the brief and this ruling are retained in private records. The brief's 'required private build record' line is withdrawn. This ruling changes no standing rule, scope or owner gate, so no decision entry is written."
  ],
  "slicePlan": [
    {
      "slice": "S1 — complete query with its criterion proofs",
      "ownedPaths": [
        "internal/core/agents/task_facts_types.go (new)",
        "internal/core/agents/task_facts.go (new)",
        "internal/core/agents/task_facts_test.go (new: TestTaskFactsBucketsAndAssignments, TestTaskFactsCommittedReadiness)",
        "internal/core/agents/task_facts_authority_test.go (new: TestTaskFactsAuthorization + three disclosure rule breaks, TestTaskFactsPagination)",
        "internal/core/agents/scoped_task_query.go (only: extract the selected-chain listing precheck into one unexported helper used by listTasks and the new query; includePreparing plumbing on taskReadiness/operationReadiness and their callers at :150, :192, :196)"
      ],
      "delivers": "Owner and Agent query complete: input/precheck/cursor/stale error precedence per §3; authorize-then-audience before readiness, counts, selection or copying; §4 bucket table; full filtered Counts; bounded keyset pages with one authorized look-ahead; committed-only readiness through the shared evaluator; ListTasks/TaskStatus unchanged (TestScopedTaskTransitionsAndProjection green). No stub, no deferred authorization or pagination.",
      "evidence": "Amendment 1's S1 commands."
    },
    {
      "slice": "S2 — ordered transitions and review results through the query",
      "ownedPaths": [
        "internal/core/agents/task_facts_recovery_test.go (new: TestTaskFactsTransitionRecovery, TestTaskFactsReviewTransitions)",
        "corrections only in internal/core/agents/task_facts.go / scoped_task_query.go"
      ],
      "delivers": "Create→claim/assign→ready→active→wait→resume→submit and the complete/fail/cancel/reassign branches, duplicate and old-version resubmission, start/turn revocation, reopen at the same head, lowered MaxLiveTasks; F3-12 request/replacement/reject leave version/state, approve/fail transition once, lost acknowledgement with afterReviewCommit + reopen + retry, stale/cross-context callbacks and ErrReviewRequired paths leave pages unchanged; owner and bound-Agent queries.",
      "evidence": "Amendment 1's S2 commands."
    },
    {
      "slice": "S3 — concurrency proof, documentation, smoke",
      "ownedPaths": [
        "internal/core/agents/task_facts_race_test.go (new: TestTaskFactsQueryRace)",
        "internal/core/agents/doc.go (task-facts paragraph per §5/§8 and amendment 3)",
        "internal/core/agents/task_facts_smoke/main.go (working-tree only, never committed; amendment 2)",
        "corrections only in internal/core/agents/task_facts.go / scoped_task_query.go"
      ],
      "delivers": "Atomic page under a concurrent waiting→active mutation (before-head or after-head, never mixed), -race as the primary lock-discipline oracle; package documentation of membership, no synthesized title, authorization before counts, committed-only readiness, combined Limit, same-head/stale recovery, cost limits; the four-line smoke through exported API with the retained old cursor returning ErrTaskFactsStale and the reopen accepting the same-head cursor.",
      "evidence": "Amendment 1's S3 commands plus the smoke command and output."
    }
  ],
  "ownerGates": [],
  "notesForCoders": [
    "TestTaskFactsCommittedReadiness must assert Readiness and Reason strings, not only bucket membership: the plausible bug (includePreparing wrongly true) moves a task from ready/'' to ready_queued/local_capacity inside the same WaitingReady bucket when the paused sibling write holds the single configured local slot on a scope the assignee's chain covers. Configure the one-slot ceiling on a scope in the assignee's chain (agent or colony), with ample units, or the test cannot go red.",
    "TaskFact has no slice fields; copying *task.record.Assignment by value and building DescriptionRef from task.descriptionSequence (ErrUnavailable when zero or > MaxInt64, as taskView does at :145-147) yields owned rows. Return three non-nil empty slices on an empty success.",
    "For the Agent query pass the bound submissionIDs as taskReadiness's viewer so dependency visibility uses the viewer's grants; pass nil for the owner. Readiness describes the assignee (ownGrantIDs of the assignee's origin), which ListTasks already discloses to any audience member with inspect authority.",
    "Check ctx.Err() inside the collection loop and once before building the page; return TaskFactsPage{} on error, never a partial page.",
    "Cursor.Actor is redundant with Origin == zero; keep it only because the brief's tests pin it. TaskFactsPage.AgentID is likewise redundant with the query. Nits, not changes.",
    "In TestTaskFactsQueryRace the -race detector is the real oracle for copying outside s.mu; the before/after page assertion is secondary and must accept either outcome. No sleeps.",
    "The precheck helper must leave ListTasks's observable behaviour identical, including error order; TestScopedTaskTransitionsAndProjection stays in S1's focused run for that reason.",
    "Per-page cost is a full scan with authorization and readiness for every eligible waiting task of the target; do not add a readiness cache or a per-agent index to avoid it. Count-only consumers (ticket 114) call with Limit 1.",
    "Smoke setup precedents: scoped_commands.go:54-111, scoped_task_projection_test.go:13-110, review_live_recovery_test.go:44-75; B's blocked state is start then wait with reason explicit_hold."
  ],
  "checked": [
    "local://t89-ruling-request.md; local://t89-brief.md (whole, raw lines 1-198); local://t89-design-assignment.md",
    ".scratch/dwarf-harness/issues/89-report-waiting-ready-waiting-blocked-and-active-task-facts.md (whole, line 53 raw)",
    "docs/CURRENT-RULES.md (whole); docs/DECISIONS.md:3026-3080 (D152, D153) and :3174-3204 (D160, D161); docs/ROADMAP-CORE.md:415-520 (C3 deliverable, exit criteria, status)",
    ".scratch/fortress-gui/spec.md:24-55 (§2) and :244-262 (§9); .scratch/dwarf-harness/c3-evidence/ticket-12-design-ruling.md:1-75 (form precedent)",
    "internal/core/agents/scoped_task_query.go (whole: taskStatus, listTasks precheck :71-98 and page loop :99-136, taskView, taskReadiness, operationReadiness); scoped_query.go (whole: scopedQuery lock/refresh fence)",
    "internal/core/agents/scoped_authority.go:1-110 (currentChain, authorize, canInspectTask); scoped_state.go:58-60 (originOf/bindingOf) and :90-160 (loadTask consuming F3-11 and F3-12)",
    "internal/core/agents/scoped_types.go:11-15, 170-220; types.go:1-70; paths.go:16, 56-58 (validID); scoped_replay.go:237-239 (terminalTask); scoped_budget.go:26-28 and :111-136 (preparing holds); scoped_budget_history.go:131 (capacityExposures); scoped_tasks.go:36-39 (ownGrantIDs); submission.go:15-17; storage.go:22; review_slots.go:13",
    "internal/core/agents/doc.go:1-43, 99-148, 289-363; scoped_task_projection_test.go:1-118 (fixtures, ListTasks cursor oracle); scoped_private_service_test.go:89-188 (beforePublish coordination precedent)",
    "contract/ledger/scoped_authority.go:139-203 (RuntimeTaskChanged, no title); scoped_values.go:39-73 (Binding, Origin, Assignment, ObjectRef); doc.go:1899-1938 (F3-11 task table and wait reasons)",
    "grep verification: taskReadiness single caller :150 and operationReadiness callers :192/:196; beforePublish and afterReviewCommit hook sites; ErrRevision uses are write-CAS refusals; Store.Colony() available for the cursor's ColonyID",
    "Not read: replay.go:318-470, history_index.go, review_plan.go, scoped_plan.go. The brief's claims there concern existing reducer installation the ticket does not change; the query's atomicity rests on s.mu held from refreshLocked through collection (scoped_query.go:22-33), which was verified. No command, test, edit or subagent was used."
  ]
}
