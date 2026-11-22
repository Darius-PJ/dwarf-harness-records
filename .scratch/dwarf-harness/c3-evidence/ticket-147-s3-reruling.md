```json
{
  "decision": "continue",
  "fixLocation": {
    "choice": "A",
    "paths": [
      "Index, work (audit: always fails): history_index.go:525-548. historyWorkValue.Receipt carries ScopedReceipt.SubmissionSHA256 (scoped_types.go:194) and Target.Artifact.SHA256 (contract/ledger/scoped_values.go:76). Read by work (:628-646); written by putWork (:648-661) from scoped_state.go:259 and replay.go:689.",
      "Index, command (audit: fails with body_refs): history_index.go:715-718. historyCommandValue.Drafts[].BodyRefs (contract/ledger/envelope.go:62). Read by command (:720-757); written by putCommand (:759-779) from replay.go:803.",
      "Prepared answer, work (audit: 3 scans): the same historyWorkValue through readHistory (scoped_state.go:198; decoded at history_prepare.go:166-173). One type, one fix.",
      "Prepared answer, commit [from the source; not run]: encodeHistoryCommit (history_prepare.go:280-290) stores each Record with its typed BodyRefs still set (:287) beside the text copy. putSource clears them (history_index.go:855); this function does not. Callers: replay.go:740 and :841, owner_replay.go:106 and :307, review_sources.go:96.",
      "Prepared answer, turn result [from the source; not run]: loop_session.go:223 (session.TurnView.Result) and :496 (*ledger.RuntimeTurnResult). Both carry FinalMessageObject.SHA256 (contract/ledger/loop.go:251; scoped_values.go:69) for a finished turn, on a directory miss.",
      "Already right, to be pinned by rows: grant, task and review (payload codecs plus scalars) and source (text refs, history_index.go:847-855).",
      "Other readHistory answers, read and found free of digests and one-way marshalers: bool, uint64, int64, [2]bool, uuid.UUID, historyGrantValue, historyTaskValue, historyReviewValue, historyPaidValue (digests as map text, history_prepare.go:348-353), totalValue, registrationValue, accountValue, continuationHistory, operationIdentity. Selections are only encoded, never decoded."
    ],
    "ownerGate": "None for (A): it touches nothing under contract/** and nothing on the owner's list. (B) is not taken, and it would be the owner's. It changes no encoder or wire byte, but it changes what a frozen package's exported type accepts for every consumer. Today encoding/json cannot fill a Digest, so a contract type that carries one can only be decoded through its frozen Decode function with its checks; UnmarshalText would open a second, unchecked way in for all of them. It would also have to settle the all-zero text, which the contract calls absent and ParseDigest refuses (contract/ledger/digest.go:12-13, :22-41). A strict (B) would not fix the work entry either, because a non-artifact receipt target stores a zero artifact digest. I did not open the decisions file; this rests on the role's reservation of frozen contracts and on the ticket's start gates. If (B) is proposed later, the question for the owner is: 'May contract/ledger gain an UnmarshalText on Digest, so that encoding/json can decode digests in every contract type? No encoder or stored byte changes, but every contract type that carries a digest then becomes decodable without its frozen Decode checks, and the method must either refuse or accept the all-zero text.'"
  },
  "slices": [
    {
      "slice": "147-S3 (widened; replaces the ruled 147-S3): cached history answers decode, and a released work stays answerable without a cold read",
      "ownedPaths": [
        "internal/core/agents/history_index.go: only the cached work and command value types and their four functions (:525-548, :628-661, :715-779), one small digest-text helper beside them, and the comment at :536-537",
        "internal/core/agents/history_prepare.go: only encodeHistoryCommit with its comment (:272-290) and readHistory's comment (:148-150)",
        "internal/core/agents/scoped_state.go: only the two expressions in loadWork that build and read the cached work value (:246, :258), and only if the type's shape requires it",
        "internal/core/agents/loop_session.go: only the two directory folds' answer types and the lines that read them (:223-240, :496-516)",
        "internal/core/agents/replay.go: the install closure of stageCommitLocked only (the fill, :686-690), as ruled",
        "internal/core/agents/doc.go: comments only",
        "internal/core/agents/history_index_test.go: new rows only"
      ],
      "change": "One slice, two steps in this order; two commits are welcome. None of this is a frozen format: the index and the read set are instance-private memory and are never written to disk. STEP 1, the codec. (a) Work: the cached receipt's two digests decode from the hex text already stored. (b) Command: the cached drafts' body_refs decode the same way. (c) Commit answers: encodeHistoryCommit stores each record without typed BodyRefs, as putSource does; decodeHistoryCommit is unchanged. Correct the comment at :272-273, since the envelope has no JSON methods. (d) Turn result: both directory folds answer with the turn-result record's payload bytes (plus the bound sequence for the status view) and decode them with ledger.DecodeRuntimeTurnResult after the read, as loadContinuation does with its snapshot (owner_replay.go:56-103). The view fields and lateText's snapshot stay as they are. (e) Comments: readHistory's comment and history_index.go:536-537 state that an answer must survive encoding/json both ways, and name the contract types that do not (Digest, Resource, SubjectRef, DeclarationConsumer, PrivateWriteArguments). Digest rule, one for all kinds: exactly 64 lowercase hex digits (ledger.ParseDigest). Sixty-four zeros give the zero Digest only in a receipt target's artifact when the kind is not artifact. Anything else makes the getter discard the entry and report a miss, like every other failed check (:644, :755): never an error, a negative answer or a zero-filled digest. Keep the stored bytes: both entries already hold hex text, so only the decode side needs to change, and the entry charge (:171-177) is untouched. STEP 2, the fill: exactly the ruled change, already at replay.go:686-690. Nothing else changes: not get, put, advance, the limits, the checkpoint tokens, the command directory, readHistory's control flow, prepareHistoryLocked, loadWork's fold, pruning, the Reader, or anything under contract/**.",
      "guarantees": [
        "Authority: on any miss, failed decode, failed check, damage, eviction or disabled index the getter discards and reports a miss, and the caller folds the ledger or reads the commit as today (history_index.go:644, :755; scoped_state.go:198-246; replay.go:727-733). No getter gains an error path or a negative answer.",
        "Same answer: a hit returns what the cold path returns at the same boundary. For work that is every field of scopedWorkState, receipt and target included. For a command it is the commandMatch that decodeFamily gives for the same drafts at the same first sequence.",
        "Fewer suspensions only: operations that used to release Service.mu for these reads now finish under one hold, which is an interleaving they already allowed. Consumer-visible results do not change.",
        "Coverage: hits are served only under get's existing rule, at the entry's own boundary or the current accepted boundary with the same lower bound (history_index.go:342-348), and for a found command only inside a window that holds its commit (:338-341). A put that is not at the current boundary is still dropped (:384-388).",
        "Work entries across later commits: the fold reads four record types (scoped_state.go:204-237) and advance drops the entry on three (history_index.go:478-489). The fourth, a scoped receipt naming the work, is accepted only in a group that also holds one of the three. The contract allows a work_id on a receipt only for a work operation (contract/ledger/scoped_submission.go:277), and the reducer binds it to that group's work record (scoped_work.go:20, :86).",
        "Released work is final: it accepts no further transition (scoped_work.go:101-103). A positive entry at the current boundary can only be a released work, because unreleased work is answered from the projection (scoped_state.go:189-191; scoped_plan.go:143-146).",
        "Command entries across later commits: a found command names one immutable commit. The entry is consulted only on a directory hit, after the directory has reported any second occurrence as inconsistent (replay.go:724-727). advance drops the entry when its ID is committed (history_index.go:451-454).",
        "Lock-released protocol: unchanged. An answer that decodes is used on the rerun only under the existing prefix, generation and binding recheck (history_prepare.go:221-224, :250-257), as grant and task answers already are. The third-round locked read stays.",
        "Frozen bytes and limits: no record type, encoder, frozen decoder, golden or wire byte changes. The Reader, its checkpoints, D157's capability and the 256-entry, 8 MiB class (D158) are not edited.",
        "Open and recovery: the index is rebuilt in memory by Open's full replay and nothing of it is durable, so no crash can leave a stale entry. Open stays inert and stays a full replay and inspection. Recovery reads the same work state as today.",
        "Rows that prove it: the three new rows below; testColdWorkHistory and testColdCommandCommit unchanged; the frozen Open rows; S2's seed self-check, which now compares a Service built with live hits against a fresh Open; TestTurnLoopCrashRecovery; the ledger tail rows."
      ],
      "acceptance": [
        "Hit row, all six kinds (turn the throwaway audit into assertions). Store each entry through its real put: a production fill where one exists at the current boundary, otherwise a direct put from projection state, disclosed per kind.",
        "Hit row, kinds: command with body_refs and without; grant; task; review pending and approved; source with body_refs; work with a workspace target (released local) and a context target (released turn).",
        "Hit row, assertions: the getter reports hit and found, the value equals the cold answer taken after damageHistoryCache at the same boundary (reflect.DeepEqual), and the loader's second lookup makes no range read where its miss path would.",
        "Hit row, command: assert at the consumer too. A same-ID retry or status call, then an unrelated commit, then the same call again gives the same receipt, appends nothing and is served by the entry.",
        "Authority under damage, for the two kinds whose hits are new (a released work and a body_refs command): take the cold answer once. Then apply each cache mode TestHistoryIndexPrefixAndDiscard uses (empty, evicted, damaged, key, range, decoder, provenance, coverage; disabled last) and ask twice through the public call. Every answer equals the first and nothing is appended.",
        "Prepared row, through the prepare path a real operation uses (a public call, or prepareHistoryLocked with a fresh read set as the audit did), after emptying the cache: exactly one read of the lookup's range, one unlocked round, and an answer equal to the locked one.",
        "Prepared row, cases: a released local work and a released turn (one scan from 0; three today); a command whose commit carries body_refs, through findCommand with the directory intact (one read of its commit range); a finished turn's result through the status or late-text fold with the command directory missing.",
        "Prepared row, production code only: the turn-result case must reach the production answer type, directly or through a helper both folds call. If no existing fixture reaches it within the owned paths, stop and report; do not substitute a row that builds its own readHistory call.",
        "Unconfirmed paths: if the commit case or the turn-result case is already one read on the unfixed tree, record that and leave its code unedited.",
        "Filled-versus-cold row as ruled, unchanged: TestHistoryIndexReleasedWork's released cases (a released turn, a released local work, every released work in chapters 11 and 16; live and reopened; the next record of the turn accepted with no range read from 0).",
        "Invalidation sub-case (PM answer 1): it stays in that row and gains a positive control. The seeded hint is a hit before the non-releasing ending and a miss after it, and the status call returns the ending's state.",
        "Stop conditions stand. If any field of a filled entry differs from the cold fold, stop and report the field, both values, the work and the sequence; adjust nothing. If a released work in chapter 11 or 16 is not a hit because the getter's own checks refuse it (:638-640), report the work; do not loosen the checks.",
        "Existing rows: none is edited and no assertion changes. If a row outside the owned paths fails, report it with its assertion line and the lookup that is now a hit.",
        "Existing rows, the one allowed remedy: if a row fails only because it counted or awaited a cold read the index now serves, the PM may allow one damageHistoryCache call before that lookup, listed under deviations. Anything else returns here.",
        "Runs: one plain verbose run and one race run of the whole package, green; -race -count=20 of the three new rows and of TestAgentTailColdReadRace's ended_work_history and command_commit; gofmt, vet, staticcheck, go mod tidy -diff and the import audit clean, with production imports unchanged.",
        "Profile, the ruled bound, unchanged: in the race CPU profile of the slice's tip, (*Service).loadWork.func1 is at most 1.52% of total samples (4.56% on 63786de). The PM also reports, as figures only, the shares of scan and readRange.",
        "Citations in the yield, each checked against the code: the decode rule of PM answer 2.3; and the receipt rule that makes advance's three cases cover the fold's four inputs (contract/ledger/scoped_submission.go:277; scoped_work.go:20, :86).",
        "Stored bytes: one work entry and one body_refs command entry have the same encoded bytes before and after step 1, or the yield gives the sizes and the reason.",
        "doc.go names the fill with its fallback (already at :517-520) and the rule for cached answers. Hosted three-OS check green on the exact SHA, once pushes resume (see notesForClose)."
      ],
      "breaks": [
        "Unchanged, fill 1: the fill publishes a state that is not the fold's (ended false, the earlier version, or the admission's receipt). Filled-versus-cold row red.",
        "Unchanged, fill 2: the fill is placed before advance, or dropped. The row's hit or no-cold-read assertion red.",
        "Unchanged, fold: loadWork's fold ignores runtime.work_ended (scoped_state.go:221). testColdWorkHistory and the filled-versus-cold row red.",
        "Changed, invalidation: advance keeps a work entry across runtime.work_ended (history_index.go:489 removed). It is now bound to the seeded sub-case, red at its miss-after assertion; the released cases cannot catch it because the fill overwrites the entry. Run it once more against -run '^TestHistoryIndex' and record every red row (PM answer 2.1).",
        "New, codec, one revert per path, each red at its row's hit or one-read assertion: (i) the cached receipt's digest back to ledger.Digest; (ii) the cached drafts' body_refs back to []ledger.Digest; (iii) encodeHistoryCommit keeps typed BodyRefs; (iv) a directory fold answers with the contract type again. Skip (iii) or (iv) if that path was recorded as already one read.",
        "New, authority: in the work getter, a value that fails to decode is answered as a hit with found false instead of a discard and a miss. The damage loop's decoder mode red (a released work reported absent).",
        "Unchanged, recovery (PM answer 2.2), run once on this slice's final tree: mutants (a) and (b), labelled 'new, none recorded', each red on native_ended_before_loop_end or legacy_native_ended_close_only at a recovery or projection assertion; and T15-S6 break 1 as recorded, red on TestLedgerTailInterleave/loop.end. If (a) or (b) cannot be made red there, report it and do not count it.",
        "Each mutant by the assignment's recipe: canonical hash first, red at the named assertion, byte-identical restore, green."
      ],
      "fuzz": [
        "FuzzScopedGroupReplay, FuzzLoopGroupReplay and FuzzContinuationGroupReplay, 120 s each on the final SHA, by the PM. After each, the temp scan for dwarf-agents-seeds-* and dwarf-agents-fuzz-* reads zero."
      ],
      "commands": [
        "Row names are the coder's; TestHistoryIndexCodecHits and TestHistoryPreparedAnswers are suggestions, and the selectors below follow the names chosen.",
        "GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -timeout 19m -run '^(TestHistoryIndexCodecHits|TestHistoryPreparedAnswers|TestHistoryIndexReleasedWork)$' ./internal/core/agents (after step 1 without the last name, after step 2 with it)",
        "GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=1 CC=<pinned clang> go test -race -count=20 -timeout 45m -run '^(TestHistoryIndexCodecHits|TestHistoryPreparedAnswers|TestHistoryIndexReleasedWork)$' ./internal/core/agents",
        "GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=1 CC=<pinned clang> go test -race -count=20 -timeout 45m -run '^TestAgentTailColdReadRace$/^(ended_work_history|command_commit)$' ./internal/core/agents",
        "GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -v -timeout 30m ./internal/core/agents",
        "GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=1 CC=<pinned clang> go test -race -count=1 -timeout 30m ./internal/core/agents",
        "Invalidation mutant only: GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -timeout 19m -run '^TestHistoryIndex' ./internal/core/agents",
        "T15-S6 break 1: GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -timeout 19m -run '^TestLedgerTailInterleave$/^loop\\.end$' ./internal/core/agents",
        "gofmt -l internal/core/agents; go vet ./internal/core/agents; staticcheck ./internal/core/agents; go mod tidy -diff; the import audit against base-imports.txt and base-testimports.txt",
        "PM, on the tip's race profile: go tool pprof -top -cum <test binary> <race-cpu.pprof>, reading agents.(*Service).loadWork.func1, scan and readRange",
        "PM: go test -run '^$' -fuzz '^FuzzScopedGroupReplay$' -fuzztime 120s ./internal/core/agents, and the same for the other two targets"
      ]
    }
  ],
  "keepFromCurrentEdits": [
    "Keep replay.go:686-690 unchanged. The fill is after publishCommitLocked, only for released work and only through putWork; put accepts it because advance has just moved the index to c.Last.",
    "Keep doc.go:517-520. Add the rule for cached answers from step 1(e).",
    "Keep TestHistoryIndexReleasedWork: the check helper and the live, frozen_11 and frozen_16 cases as written. Its cold side uses a nil read set, so that side does not pass through the codec; keep it so.",
    "Keep the seeded sub-case with its direct putWork, disclosed in the yield with the masking deviation (PM answer 1). Add the positive control: assert the seeded hint is a hit before EndLocal 'unknown'.",
    "Keep codec-audit as the source of the permanent hit and prepared rows, then delete the folder with the other throwaways. smoke-decode-diagnostic.log and audit.log stay in the evidence as the record of the cause.",
    "Drop nothing from the three files. The handoff says the temporary diagnostic lines and the encoding/json import are gone; the final status and diagnostics confirm it. The hashes in handoff.md go stale once the test file changes; write the final ones in the yield."
  ],
  "expectedSaving": {
    "basis": "63786de race profile (the PM's entry check): loadWork.func1 is 4.56% of 5,705.46 s, about 260 s, while loadWork itself is 143.79 s cumulative. The closure exceeds its parent because two of every three scans of a prepared cold work read ran unlocked, outside loadWork's stack (audit: 3 scans, 2 unlocked rounds). [INFERENCE from those two figures:] about 116 s is unlocked resolves, so prepared reads cost about 174 s at three scans each and locked reads (Open's replay, acknowledgement) about 86 s.",
    "mechanism": "Step 1 takes prepared reads from three scans to one and serves repeat lookups of a released work from the existing cold-fold fill. Step 2 removes the first lookup after each release, live and in replay. What stays: negative lookups below the identity maximum, entries evicted from the 256-entry class, releases installed outside the scoped family, and rows that damage the cache on purpose.",
    "profileTarget": "Unchanged and binding: (*Service).loadWork.func1 at most 1.52% of total samples on the slice's tip. It is the ruled bound and only the owner changes it. I expect 0.3 to 0.9% [INFERENCE]. Step 1 alone would land near 1.8 to 2.6% [INFERENCE], so the bound is judged on the tip only.",
    "reportOnly": "Scans from 0 per cold released-work read through the prepare path: 1 (3 today). The shares of scan and readRange should also fall, because commit answers with body_refs and review-source reads stop tripling [INFERENCE, unmeasured].",
    "local": "race 40-65 s and plain 5-10 s on the S2 tree [INFERENCE]",
    "windowsPlain": "10-25 s",
    "windowsRace": "40-70 s",
    "macosRace": "50-80 s",
    "linuxRace": "35-55 s",
    "hostedNote": "The hosted figures are the original ruling's, for the measuring tree with ticket 91's tests. The finding explains where the closure's time went; it does not enlarge it, so criterion 1's arithmetic is unchanged."
  },
  "notesForCoders": [
    "Order: step 1 first, with its two rows green, then the filled-versus-cold row. That row could not be reached before; it is reached now, and its stop condition is live for the first time.",
    "Do not add a method to any contract type, and nothing under contract/**, tools/check, .github or go.mod changes. No reflection walker, no unsafe, no new dependency (D29); LF (B1).",
    "A contract payload crosses a cached or prepared answer as its encoded payload bytes and comes back through its frozen Decode function, as grant, task, review and continuation answers already do. Cache-private shapes (the receipt, the drafts) carry digests as text.",
    "The existing pattern is enough for the work and command types: an outer field of the same name shadows the embedded one for encoding/json, as Target already shadows ScopedReceipt.Target (history_index.go:539-542). That keeps the stored bytes identical.",
    "A body ref is never zero; refuse it. A malformed digest is a miss, not an error and not a zero digest.",
    "Do not edit get, put, advance, the limits, the directory, readHistory's control flow, prepareHistoryLocked, loadWork's fold or the getter's checks. If serving a hit seems to need one of them, stop and report with path:line.",
    "Declare the two turn-result answer types where a row can reach them through production code. One helper that both loop_session.go folds call is the simplest way to bind the row to the product.",
    "For kinds with no production fill at the current boundary, a direct put from projection state is acceptable in the hit row; say so per kind in the yield.",
    "Keep the cold comparison side free of the codec: a nil read set under Service.mu, as TestHistoryIndexReleasedWork's check already does.",
    "The damage loop runs in one fixture, one mode after another with disabled last; it does not need a fixture per mode.",
    "Report the elapsed time of each new row under race. None should become one of the package's ten slowest subtests; if TestHistoryIndexReleasedWork does, report it rather than trimming it.",
    "No assertion changes in existing rows. A failing row outside the owned paths is a finding to report, not a file to edit.",
    "Local figures, paths and anything about the owner's machine stay out of tracked files and commit messages (D145). Conventional Commits, scope agents; a fix commit for the codec and a perf commit for the fill would suit."
  ],
  "notesForClose": [
    "Why one slice and why ticket 147: the defect sits on S3's path and S3's own row cannot pass without the fix, so the fix is the slice's enabling change. A split would spend one of the two further slices the floor allows, and a filled-versus-cold mismatch would return here either way. Neither spare slice is used.",
    "Record the defect against ticket 142's code (d9debac): ledger.Digest writes text and cannot read it back, so no found work entry was ever served, no command entry with body_refs was ever served, and prepared work answers were read three times. Correctness held because every miss folds. No row asserted a hit for any kind, which is how it stayed hidden.",
    "Ticket 142's evidence should say that its work-lookup and body_refs command benefits were not in effect until this slice [INFERENCE: I did not read that evidence]. The original S3 ruling's sentence that only the first lookup after a release folds was wrong for the same reason: every lookup did.",
    "Two paths are fixed from the source without a prior run: commit answers with body_refs and the turn-result answers. The yield must state for each whether the row was red before the fix. If one was already a single read, it is left unedited and named here.",
    "The contract keeps its asymmetry: Digest marshals as text and has no inverse, and three contract tests already work around it (activation_test.go:140, promotion_test.go:150, scratch_change_test.go:187). Any new cached or JSON-decoded shape that carries a Digest or a Resource meets the same trap. The new rows and readHistory's comment guard the history index only. A contract-level change is the owner's (fixLocation.ownerGate) and is not asked now.",
    "Provenance of the breaks: three fill and fold mutants as ruled; the invalidation mutant rebound to the seeded sub-case, with 'no ticket-142 row covers work entries (none recorded)' if only the sub-case reddens; four codec reverts and one authority mutant, new; two recovery mutants 'new, none recorded'; T15-S6 break 1 exact.",
    "State the direct putWork seeding of the sub-case, and that the released cases cannot catch the invalidation mutant because the fill overwrites the entry.",
    "Landing is not ruled here. S3 rests on 11911a7, which has not landed, and run #126's macOS time-out is a separate floor return waiting for the owner's logs. Coding and local evidence proceed now; no S3 push before that return is ruled. If S2 changes, the PM rebases; the owned files do not overlap S2's.",
    "The assignment needs reissuing with the widened owned paths, this slice's acceptance and breaks, and the same stop conditions. PM answers 1 and 2 stand, except that the invalidation sub-case gains its positive control.",
    "Bounds, traffic and eligibility are unchanged: the 1.52% profile bound, the per-slice and final-tree targets, criterion 1's figure and the measuring run. Record this re-ruling as the PM records rulings, originator assistant.",
    "Basis: I read the request, the ticket, the ruling's S3 entry with notesForCoders, rejected and the floor, the assignment, the PM's answers, S2's review, handoff.md, audit.log and codec_audit_test.go.",
    "Code read in the worktree: contract/ledger digest.go, envelope.go:40-135, scoped_values.go:55-110 and :195-300, loop.go:240-262, paid_profile.go:10-60, and searches of scoped_submission.go and scoped_work.go; session/types.go:60-125; agents history_index.go:130-900, history_prepare.go, scoped_state.go:1-300, scoped_plan.go, scoped_work.go, scoped_submit.go:120-150, replay.go:395-470 and :600-880, owner_replay.go:20-200 and :295-330, owner_guard.go:60-140 and :225-250, loop_session.go:205-260 and :480-520, paid_state.go:135-300, registration_query.go:55-110, review_sources.go:25-130, scoped_budget_history.go:1-60, doc.go:495-530; history_index_test.go:300-470, :810-856, :939-1290, :1577-1640 and :1840-2120.",
    "Not checked: I ran nothing, did not open the decisions file, did not see the profiles or any hosted log, and did not read the fixtures the new rows will use. The S2-tree split of the closure's time, the per-step shares and the saving ranges are inferences."
  ]
}
```
