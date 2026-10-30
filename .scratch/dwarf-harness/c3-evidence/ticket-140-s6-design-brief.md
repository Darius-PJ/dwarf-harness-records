# Ticket 140 — sixth-and-final slice design brief

## Authority and scope

D158 authorizes one sixth-and-final slice, not a mechanism; a fresh advisor ruling precedes code. Base: `2bce72e610ec9380c08314645f0ecea7e3a44ea8`, worktree `140-final-ack`. Consume the frozen D157 API at public main `bf71ba15cfc24095e36cf7230115694e665275ad`; do not change it. This brief recommends only eliminating repeated prefix decoding for the first contiguous scoped acknowledgement after Open. All seven original bounds, original traffic, eligibility/noise rules, the shared cache allowance, D152/D153 gates and separate whole-ticket verification remain. No seventh slice follows a failure. [A:5-10,27-49; MAIN `docs/DECISIONS.md:3138-3151`, supplied in E.]

The reported failure is accepted, not remeasured here: `task.create` median 101.9633 ms versus 70.1972 ms; six other bounds pass. The completed diagnostic identifies 120/125 ms sampled CPU in the acknowledgement Reader path. The original driver reopens, performs a cold receipt lookup, then makes task.create its first scoped command. This is not a general lookup/startup redesign. [A:15-23; `../t11-s4-evidence/driver/main.go:498-527,569-580`.]

## Recommended mechanism and numbered choices

**Recommendation: Open-only capture, success-only publication, existing acknowledgement consumption.** Change only `openService`'s initial replay to the frozen checkpoint-capable opener, with a nil incoming proof. Drain it through the existing `scanReader` and unchanged complete-group acceptor. Hold its returned proof locally until every existing Open step succeeds, then insert it through `putAckCheckpoint` at the saved replay-final frontier. No second ledger traversal is added; no caller other than initialization changes mode. [A:27-35,46-47; C:16-19; `service.go:169-190`; `replay.go:249-279,318-474`.]

The sources do not settle the following choices; each is a recommendation for the fresh advisor, not an adopted decision:

| Choice | Options considered | Recommendation and reason |
|---|---|---|
| **P1 — seam** | Change all `scan` calls; change every `refreshLocked` advance; Open-only helper; inline Open-only replay. | **Inline Open-only replay in `openService`.** It is one initialization site, reuses the existing drain/reducer, and addresses exactly the measured first-after-reopen traffic. Avoid a new mode flag, bootstrap field or second reducer. Leave general refresh and historical scans legacy. [A:21-32; `service.go:169-172`; `replay.go:241-279`; R:84-95.] |
| **P2 — mode/error compatibility** | Ignore checked-close failures; change legacy Reader semantics; explicitly opt only initial Core replay into checked closure. | **Explicit initialization opt-in, with truthful close errors.** No suppression and no frozen Reader change. Recommend nonbreaking Core consumer integration, with the classification and conditional owner gate below. Nil capture alone remains behavior-neutral. [C:7-12; MAIN `docs/DECISIONS.md:3138-3151`; `contract/ledger/reader.go:123-135,322-365`; `docs/CONTRACTS.md:26,39`.] |
| **P3 — publication** | Insert after replay immediately; insert after all Open checks using the current cursor; retain locally and insert at saved replay-final cursor only on success. | **Last option, using existing `s.openedThrough`.** It prevents any failed Open from seeding and cannot retimestamp an old proof if a later step ever advances coverage. No new persistent state. [C:17-19; `service.go:173-190`; `history_index.go:309-357`.] |
| **P4 — regression scope** | New fixture/instrumentation framework; internal hit/copy assertions; extend the existing real-log prefix-corruption test with Open provenance and reuse existing behavioral coverage. | **Extend the existing test only.** First-after-Open byte revalidation is the new uncertain safety boundary; empirical first-call acceleration is proved by the original driver, not a wall-clock unit assertion or cache-hit test. [A:48-49; ticket140:34-43; R:125-134,348-368; `scoped_receipt_test.go:377-429`.] |
| **P5 — concurrency evidence** | Treat initialization as unrelated to shared state and omit local race; treat the newly initialized reusable LRU entry as changed shared state. | **Treat it as changed shared state.** Run the one agents package race and affected concurrency rows ×20; no new concurrency mechanism or broad repeated matrix. [A:48; MAIN `docs/DECISIONS.md:3034`; `history_index.go:209-220,309-357`; `service.go:192-214`.] |


## Exact implementation, ownership and callsites

### Owned paths and precise cutover

1. **`internal/core/agents/service.go` — only existing function `openService`, definition :146.** Replace its initial `s.refreshLocked(ctx, store.Durable())` call at :170-172 with the sequence below. Keep its arguments, validation, construction, subsequent report ordering and return shape unchanged. [P1/P3; `service.go:146-190`; C:19.]
2. **`internal/core/agents/scoped_receipt_test.go` — only existing function `TestScopedAcknowledgementPrefixChanged`, definition :377.** Add the two provenance subtests described in §Tests, preserving the original scenario and all its assertions. [P4; `scoped_receipt_test.go:377-429`.]
3. **`internal/core/agents/doc.go` — comments only.** In the existing Open explanation (:25-34), state that initial replay opts into checked Reader closure and returns actual replay-close failures. In the existing cost explanation (:339-345), state that a successful Open can seed the same charged checkpoint from its existing replay; no extra scan and no warm-path guarantee after eviction/advance/rotation. Retain the two-outer-pass qualification (:94-99), remaining prefix I/O/hashing costs and all capacity disclaimers. No performance numbers before measurement. [P1/P2; A:34,39-40; `doc.go:25-34,94-99,320-345`.]

**No production signature migration.** `Open` and `openPaidService` still call `openService` unchanged. Remove only initialization's call to `refreshLocked`; do not leave a second replay route executing alongside it. `scan`, `scanReader`, `refreshLocked`, `acceptCommitLocked`, `readCommittedRange`, scoped/review execution and every cache function remain byte-unchanged. There is no Reader, scanner, line-reader, ledgerstore, appender or interface implementation change, no new file and no dependency/import-boundary expansion. [P1; A:40-41; MAIN `docs/DECISIONS.md:258-308`; `replay.go:241-318`; `scoped_execute.go:341-359`.]

**LSP references used:** PM ran gopls after registering this worktree, not against MAIN. L:225-289 lists all 15 `openService` references: declaration, `Open` wrapper, `openPaidService` at `paid_live.go:44`, and the 12 fixture/recovery test calls. LT:3-11 reports only the declaration for `TestScopedAcknowledgementPrefixChanged`, no callers. These are the only existing functions modified; documentation has no function modification. Broader seam evidence is retained in L:291-705 (scan 34, scanReader 3, refreshLocked 27, range reader 7, acceptor 3, history constructor 3, checkpoint get 9/put 6). No wrapper or caller alias is added. [L:225-289; LT:3-11; C:23-24.]

### Exact initialization algorithm

At the existing new-Service construction, `s.p.through` and history coverage are zero. Use this control flow; this is implementable pseudocode specifying the exact calls, not a new interface:

```go
through := store.Durable() // one snapshot, as before
var checkpoint *ledger.ReadCheckpoint
if through != s.p.through { // preserve the old equal-frontier no-op
    r, err := ledger.OpenReaderWithCheckpoint(
        s.store.LogDir(),
        ledger.ReadOptions{
            Colony: s.store.Colony(), After: s.p.through, Through: through,
            Consume: privateConsumption(), AllTypes: true,
        },
        nil,
    )
    if err != nil { return nil, report, err }
    err = scanReader(ctx, r, func(c ledger.Commit) error {
        _, err := s.acceptCommitLocked(ctx, c, nil)
        return err
    })
    if err != nil { return nil, report, err }
    checkpoint = r.Checkpoint()
}
s.openedThrough = s.p.through // existing assignment; exact proof stamp
// Existing inspectOpen, PendingWork, PendingPaid, UnboundCredentials,
// in their existing order, with their existing early returns.
s.history.putAckCheckpoint(s.openedThrough, checkpoint)
return s, report, nil
```

The insertion is immediately after the existing `report.UnboundCredentials` assignment and before the successful return (:189-190). Do not keep `r` alive across inspection: its lifetime is confined to the replay block and `scanReader` has already closed its descriptor before `Checkpoint` is asked for. Hold only the optional fixed-size token. Do not add another `Close`/drain, a retry, an alternate parser, a second pass, or a fallback replay on authoritative error. [P1/P3; C:19; `service.go:169-190`; `replay.go:249-279`; `contract/ledger/reader.go:334-365`.]


## Proof/key alignment and failure semantics

### Exact key alignment and authoritative provenance

For a successful advancing numeric replay, let **T** be its final complete-commit sequence. `AllTypes:true` processes every complete group through T; `acceptCommitLocked` publishes history coverage before `s.p.through=c.Last`. Only after terminal EOF and successful actual closure can the frozen Reader mint its token, whose private `afterSeq` is T. `s.openedThrough` records that same accepted T. `putAckCheckpoint(T, token)` stores the existing fixed `historyAckRead` key with `from=T`; both put/get require exact valid accepted coverage. The first nonduplicate contiguous scoped Submit has `First=T+1`; it requests `ackCheckpoint(s.p.through)` at T and `readCommittedRange` sets `After=First-1=T`. No off-by-one conversion, persistent cursor, fresh command-absence proof or caller-constructed chain is involved. [P3; `replay.go:283-312,467-474`; `history_index.go:275-285,309-357`; `scoped_execute.go:341-353`; `contract/ledger/reader.go:94-110,334-365`.]

The proof's authority is **completed real Reader verification**, not the wrapper checksum or a Submit receipt. Open still applies the ordinary five-family reducer, duplicate-command check and all record/state guards. On use, D157 freshly validates path/colony/range/segment/predecessor and hashes every containing-segment prefix byte on the same descriptor used for the suffix. The new commit still passes original decoding, exact-range checks and expected-input acceptance. The checkpoint inherits the append-only protocol; it is not a snapshot, same-process security boundary or hostile-rewrite atomicity guarantee. [MAIN `docs/DECISIONS.md:3126-3136`; `contract/ledger/reader.go:94-110,138-190,334-365`; `contract/ledger/scan.go:222-247`; `replay.go:283-355`; `scoped_execute.go:341-352`.]

| Boundary | Required behavior and reason |
|---|---|
| Empty log / `Through==0` | Preserve initial equal-frontier no-op; checkpoint stays nil, final put is a no-op. Existing inspection/report behavior remains; do not manufacture a genesis proof. [C:7-9; `replay.go:267-270`; `history_index.go:354-357`.] |
| Numeric nonzero Through | Pass the captured `store.Durable()` exactly, never substitute `ToEnd` or replay to `Through==After`. A mid-commit or prematurely ending numeric log returns its current cursor/corruption error, not a proof. [`contract/ledger/reader.go:26-31,273-304,338-345`; A:31.] |
| `ToEnd`, equal bounds, path identity unavailable, or any nil capture | Do not introduce a new refusal or recovery path; a nil proof inserts nothing. Although the real store supplies numeric durability, preserve the frozen no-proof behavior for these Reader cases. [`contract/ledger/reader.go:176-179,334-345`; C:7-9.] |
| Replay spans multiple segments | Scanner resets prefix hash and saves the fresh base chain on each segment open. The final token describes the segment containing T, not an entire-log offset/hash; checked transition closes also must succeed. [`contract/ledger/scan.go:136-147,203-219`; `reader.go:347-364`.] |
| Rotation before first acknowledgement | If the next commit lands in a segment beginning T+1, segment selection changes; the old token is a miss, not a promise of acceleration. Frozen opener verifies the predecessor and scans the newly selected segment normally. No rewrite or retimestamping. [`reader.go:94-110,149-164`; `reader_test.go:454-520`.] |
| External append after replay, with no accepted projection advance yet | Seed remains qualified only for accepted T. Every ordinary command/query refreshes accepted state first; any intervening accepted commit removes the fixed key. A gap/duplicate acknowledgement retains its existing refresh+lookup branch. [`commands.go:125-150`; `scoped_execute.go:341-359`; `history_index.go:365-377`.] |

### Error, poison and recovery classification

**P2 is an explicit observable error change, not a claim of byte-for-byte equivalence under real descriptor-close failure.** Initial replay now reports automatic EOF/error close failures and segment-transition close failures; transition failure stops before opening the next segment. The underlying error is retained/joined by the existing frozen Reader and `scanReader`. Normal EOF alone remains success; error text may now contain actual OS `PathError`/close text and, with simultaneous read/reducer and closure failure, joined errors. No wording normalization, replacement sentinel, or success branch on `errors.Is(err,io.EOF)` is added. Existing corruption/version/cursor/visitor/context errors and their typed fields remain; only a simultaneous actual close error adds truthful error information. [C:9-12; `contract/ledger/reader.go:262-271,322-377`; `scan.go:87-96,112-147`; `replay.go:249-265`.]

**Callers exposed:** both public `agents.Open` and `agents.OpenPaid` (through `openPaidService`), plus the fixture/recovery callers of `openService`. No other package's Reader use changes. During Open, no Service has been returned and no active operation exists. On initial replay failure, return `(nil, report, err)` before inspection or seed insertion; a partly reduced local projection is discarded. The old `refreshLocked` would set that unreturned object's `poisoned` flag for non-context errors; omitting that unobservable assignment creates no usable poisoned Service and changes neither store poisoning nor live refresh policy. `Close`/store recovery/reopen requirements for already-published Services stay unchanged. [L:225-289; `service.go:143-190,215-241`; `paid_live.go:37-47`; `replay.go:267-279`; `doc.go:16-23`.]

**Compatibility recommendation:** this is a nonbreaking Core initialization consumer opt-in, subject to fresh advisor approval. Frozen D157 already defines the selected mode and its truthful failures; no call still selecting `OpenReader` changes. Frozen C3 entries cover record/submission/replay rules, not a guarantee that Core Open suppresses OS descriptor-close failures. Open still reconstructs the same committed state, appends nothing and dispatches nothing. The fifth-slice “all historical scans legacy / reopening cold / only scoped acceptance publishes” restriction must be amended **only for initial Open replay and its final success seed** by this ruling; it is not silently treated as preapproved. [P1/P2; C:10-16; R:77-93,175-191; `docs/CONTRACTS.md:25-26,39`; `doc.go:25-34`; MAIN `docs/DECISIONS.md:3138-3151`.]

**Owner gate, conditional, not designer approval:** if the advisor identifies a frozen or owner-reserved guarantee requiring this Core Open path to continue ignoring actual close failures, P2 cannot proceed without the owner's explicit change approval. Do not bypass it by swallowing errors, reopening with a legacy Reader, changing D157 or calling this a nil-proof miss. No such frozen errno/suppression guarantee was found in the cited register/package guarantee; the advisor must rule on that classification. [C:11-12; MAIN `docs/DECISIONS.md:3097-3100,3145-3148`; `docs/CONTRACTS.md:26,39`.]

### Everything after replay, including paid Open

- **`inspectOpen`:** its existing second outer traversal still uses legacy `s.scan`; it can return an error or collect object/occurrence issues, then complete eligible materializations. Neither `inspectOpen` nor `inspectScope` submits a group or advances `p.through`/history coverage. Scope completion updates only filesystem materialization and scope materials/hints/issues, with current object/foreign-file checks unchanged. An `Issues` report is not itself an Open error: preserve the existing successful report and fences. Fatal inspection error returns before any seed exists. [`integrity.go:124-224,228-397`; `service.go:173-178`; C:18-19.]
- **Pending work/paid and unbound credentials:** builders encode/decode/copy current projection values and sort views; `workView` uses existing `openedThrough` for `recovery_pending`, and `paidView` reads `p.through`. They perform no ledger append or projection-frontier advance. Errors return before insertion. [`scoped_query.go:37-87`; `paid_query.go:61-121`; `service.go:179-189`.]
- **`openPaidService`, `paid_live.go:44`:** it receives the fully opened Service, creates transport state, adjusts the bounded paid hot-result limit and prunes settled hot results. This does not append or advance `p.through`. On transport-construction error it already calls `s.Close()`, draining/disabling the history index before returning nil, so failed OpenPaid retains no seed. On success the seed is still exact at T. No paid lifecycle, authority, hold, money or transport behavior changes. [`paid_live.go:37-64`; `paid_state.go:112-143`; `service.go:192-214`; `history_index.go:252-261`.]
- **A hook or future accepted advance:** publish using saved `openedThrough`, never the current frontier of a later operation. Existing `put` rejects a stale stamp; existing `advance` always removes any already-inserted acknowledgement key. An external byte rewrite without an accepted advance is detected by the next Reader's fresh prefix equality/ordinary fallback, not by assuming materialization made the ledger immutable. No new refresh or safety retry is added to Open. [P3; C:18-19; `history_index.go:319-326,365-377`; `reader.go:176-190`; `scan.go:222-247`.]


## Cache, locking, lifetime and cost

**Same one cache.** Insert only through existing `putAckCheckpoint`; it copies the opaque token, validates the wrapper and accepted coverage, and uses the existing LRU. The seed is one entry charged **384 bytes** (128 entry + 256 opaque token), competing with every existing entry under the unchanged **256-entry / 8 MiB charged retained metadata** limits. It can evict an LRU entry; it has no reserved slot or extra allowance, and eviction can legitimately make the first call cold. Never retain Reader/Commit buffers, descriptors, a hash state, body bytes, authority, or another per-Service checkpoint field. The one local uncharged token before successful publication is bounded transient initialization storage, not a second retained cache. [C:17-19; R:62-80; `history_index.go:144-185,309-357`; `doc.go:320-328`.]

**Locking/lifetime.** Replay runs exclusively before publication, as today; no outer `Service.mu` is needed around the whole initializer. Existing reducer/inspection helpers preserve their current mutex use. Final insertion is still exclusive initialization, acquires only history.mu internally and performs no I/O. All postpublication operations retain Service.mu→history.mu ordering, copy-out and no history lock across I/O. `history.advance` invalidates on every accepted advance, including refresh and direct review; it is unchanged and still forbids late retimestamping. `Service.Close` fences/drains existing operations, clears and disables the cache; reopening builds a new cache and may seed it anew only on success. No goroutine, mutex, channel or new resource ownership. [P3/P5; `history_index.go:16-18,209-220,252-261,301-307,334-357,365-377`; `service.go:192-214`; R:73-80.]

**Added startup cost [INFERENCE, not a measured pass].** The advancing replay now computes one additional running SHA-256 over logically consumed framed lines, resets it at segment transitions, derives optional Abs/Clean path identity, constructs one fixed-size token after closure, and makes one existing bounded-cache insertion. This adds O(replayed bytes) hashing, O(1) transient hash/token state, and at most one existing-entry charge; it adds no disk pass, JSON decode, fsync or writer lock. Existing inspection and any cold reducer lookups remain. Next warm acknowledgement still rereads/hashes its containing prefix; only repeated envelope/JSON decoding/verification state reconstruction is avoided. Existing startup margins (T11 61.3/165.5 ms normalized; T12 1125.8/1923.2 ms) motivate the choice but do not predict a pass after the added hashing. Both startup bounds must be re-established. [A:34,49; `reader.go:176-179,338-365`; `scan.go:155-159,211-218`; `doc.go:94-99,339-345`.]


## Observable tests and decisive rule breaks

**One new permanent scenario, not a new test framework.** In `TestScopedAcknowledgementPrefixChanged`, retain the original successful scoped-write warming and add a table over provenance `"scoped-ack"` and `"open"`. Each row gets an isolated existing real fixture. Capture `binding` instead of discarding it. For `"open"` only, after `warmScopedPrivateAcknowledgement` call `reopenScoped(t,f,DefaultLimits())` and rebind `agent=scopedBound(t,f.service,binding)` **before** recording the baseline and installing `afterScopedSubmit`. The prior Service/seed has been drained; only the new Open can supply startup provenance. Do not add an extra scoped mutation after reopen. Keep the original `"scoped-ack"` path and all original assertions intact. [P4; `scoped_receipt_test.go:377-429`; `scoped_service_test.go:58-78`; `scoped_receipt_test.go:365-375`; LT:3-11.]

Both rows use the existing seam to damage an earlier nonterminal saved-prefix byte after durable Submit, leaving the last saved-prefix line and all new commit bytes unchanged. Observable oracles remain: zero successful receipt with `ledger.ErrCorrupt`; accepted projection/frontier/charges unchanged after holds release; durable Submit neither rolled back nor rewritten; no successful source proof from the rejected group. This proves startup capture grants no permission to skip fresh prefix validation. No new timing assertion, hit counter, mock response, raw-token access, reflected token reconstruction or fixture golden. [A:35,48; `scoped_receipt_test.go:389-427`; R:356-362.]

### Retained observable coverage / proof conditions

| Boundary | Coverage to retain or exercise; decisive check |
|---|---|
| Every replayed group must be accepted, not merely parsed, before successful initialization | Existing `TestF3_10PayloadsAndRecordRules/wrong_session` constructs a syntactically valid real-store group with the wrong execution session and expects Open's `ErrInconsistent`. **One new minimal semantic rule break:** replace only the new visitor body with `_, _ = s.acceptCommitLocked(ctx, c, nil); return nil`, discarding its error while retaining the actual acceptance attempt. This avoids an unused-variable compile failure masquerading as a semantic red. That named recovery row must go red; byte-identical restore and same command must go green. Do not compound it with a Reader change or claim an unobserved red; report masking if another existing guard catches it. [`replay_test.go:136-193`; `replay.go:318-398`; MAIN `docs/DECISIONS.md:3034`; A:48.] |
| Startup token never bypasses fresh prefix validation | The new `"open"` provenance row above plus existing Reader equivalence/prefix tests. Fresh-byte, predecessor and token predicates are frozen C1 code, not new predicates here: carry their existing one-predicate reds/restores/greens by exact unchanged source identity; **do not remutate or recertify C1**. [R:348-368,283-288; MAIN `docs/DECISIONS.md:3134-3136,3150`; `reader_test.go:417-520`.] |
| Exact initial frontier, empty/multisegment/rotated reads and no proof on incomplete/error close | Existing `TestReaderCheckpointContinuation`, `TestReaderCheckpointAnchorAndFallback`, `TestReaderCheckpointErrors` already cover these frozen rules, including real descriptor-close failure. Keep that proof by unchanged C1 identity. Existing real-store service fixture initialization supplies empty-log coverage; retain both frozen Service golden replays and their empty prefixes. No new token-shape assertions. [`reader_test.go:314-417,454-645`; `service_test.go:33-53`; `scoped_golden_test.go:217-218`; `replay_test.go:29-93`; R:283-288.] |
| Same exact receipt/effect and truthful suffix errors | Existing `TestScopedAcknowledgementInterleaving`, `TestScopedAcknowledgementRejectsRewrittenCommit`, `TestScopedAcknowledgementRange`, `TestScopedReceiptsAndLostAck`: exact receipt, one charge, duplicates/gaps, conflicts, actual command/submission/family/state and partial boundaries. Do not weaken them when Open now leaves an eligible proof. [`scoped_receipt_test.go:18-363,431-583`.] |
| Shared allowance, copy-out, invalidation and Close drain | Existing `TestHistoryIndexAcknowledgementFallback`: discarded/evicted/disabled/damaged/malformed-wrapper/byte-pressure paths, exact shared charge/eviction, foreign/direct-review invalidation and late-fill rejection, followed by public write/retry/reopen outcomes. Also retain `TestHistoryIndexPrefixAndDiscard` copy-out and `TestPrivateCloseDrainsOperations`. A startup seed uses the same helpers, so no new allowance-specific implementation assertion. [`history_index_test.go:367-464,466-640`; `recovery_test.go:297-344`.] |
| Recovery/materialization/paid Open remains inert | Existing `TestPrivateRebuildIsInert`, `TestPrivateRestartLostAcknowledgement`, `TestPrivateFusedHistoryInspection`, paid replay/recovery and registration-family rows run unchanged. No automatic work, lost hold, changed issue ordering, overwrite permission or record/schema change. [`recovery_test.go:213-245,506-629`; `service_test.go:82-128`; `paid_replay_test.go:29-40`; `registration_replay_test.go:122`; `doc.go:25-34`.] |

**Honest limits of unit/mutation evidence:** deleting the new seed, passing `ToEnd` for capture, or using a wrong insertion stamp normally just makes a safe cache miss; receipt tests are expected to remain green. Do not invent an internal-only “proof test” or claim a red for those performance-only losses. Their decisive consumer oracle is the unchanged original T11 long-history task.create bound. Likewise moving a `Checkpoint()` query earlier normally yields nil, not an unsafe token. No new C1 eligibility predicate exists here. The single new callback-error rule break above addresses the actual Open acceptance proof; reuse all settled C1 predicate evidence. [A:27,31,48-49; R:125-134,283-288; `reader.go:334-345`; `history_index.go:319-326,354-357`.]


## Verification and acceptance

**Designer performed source-only work.** The commands below are the coder/PM evidence plan, not claims of execution. PM owns verification; no new profiling or preimplementation experiment is requested. Use the existing pinned toolchain/environment and serialize local tests/fuzz/measurements. D152 focused evidence and D153 exact-SHA hosted gate apply; no routine local `tools/check` or five-target static loop for these platform-neutral files. [A:48-54; MAIN `docs/DECISIONS.md:3026-3049,3148-3150`; R:405-427; E, D45 amendment D147.]

From the assigned worktree, with `GOTOOLCHAIN=local`, empty `GOFLAGS`, and `CGO_ENABLED=0` for non-race Go commands:

```text
gofmt -w internal/core/agents/service.go internal/core/agents/scoped_receipt_test.go internal/core/agents/doc.go
gofmt -l internal/core/agents/service.go internal/core/agents/scoped_receipt_test.go internal/core/agents/doc.go
go test -count=1 -v -run '^(TestScopedAcknowledgement.*|TestScopedReceiptsAndLostAck|TestHistoryIndexAcknowledgementFallback|TestHistoryIndexPrefixAndDiscard|TestF3_10PayloadsAndRecordRules|TestPrivateRebuildIsInert|TestPrivateRestartLostAcknowledgement|TestPrivateFusedHistoryInspection|TestPrivateCloseDrainsOperations)$' ./internal/core/agents
go test -count=1 -v ./internal/core/agents
go vet ./internal/core/agents
go tool staticcheck ./internal/core/agents
go mod tidy -diff
```

Retain the existing import-boundary check under its current convention; no changed import permission or module file is authorized. Record actual changed-file hashes and unchanged frozen C1 identities, focused/mutant/restore/plain/static outputs, counts and honest limits. The wrong-session mutation uses its exact named selector `go test -count=1 -v -run '^TestF3_10PayloadsAndRecordRules$/^wrong_session$' ./internal/core/agents`; do not run the plain package under the mutant. [A:40-41,48; MAIN `docs/DECISIONS.md:3034`; R:405-427; `replay_test.go:136-193`; `skill://dwarfharness-staged-build`, focused evidence/toolchain/import rules.]

P5 triggers one `go test -race -count=1 -v ./internal/core/agents`, then the affected ×20 coverage in two serial invocations: `go test -race -count=20 -v -run '^(TestHistoryIndexLookupRace|TestPrivateCloseDrainsOperations)$' ./internal/core/agents` and `go test -race -count=20 -v -run '^TestScopedReceiptsAndLostAck$/^concurrent-same-command-and-query-tail$' ./internal/core/agents`. Use the already-established host race compiler and `CGO_ENABLED=1`, not a new installation. Separate selectors avoid Go's slash-separated subtest regex accidentally widening the repeated suite. Keep ×20 narrowly on these existing concurrent lookup/tail/close rows; no ×20 golden/recovery matrix. [P5; MAIN `docs/DECISIONS.md:3034`; `history_index_test.go:775-848`; `recovery_test.go:297-344`; `scoped_receipt_test.go:148-224`.]

**Fuzz:** PM selects affected targets later from the existing four `FuzzScopedGroupReplay`, `FuzzReviewGroupReplay`, `FuzzPaidGroupReplay`, `FuzzRegistrationGroupReplay`. Each selected target uses the established serial command shape `go test -run '^$' -fuzz '^TARGET$' -fuzztime=120s -parallel=1 ./internal/core/agents` (substitute that existing target's exact name, not a new target). Accepted real-store paths that reopen reach the changed initializer; rejected preflight-only inputs do not, and these fuzzers alone do not prove warm acknowledgement. No new fuzzer, C1 campaign repetition, or target selection by package membership. [A:48; R:389-405; MAIN `docs/DECISIONS.md:3148-3150`.]

**Final empirical acceptance is unchanged and cannot be replaced by the tests:**

- The first **full original T11 run on the actual final new SHA** is both the real program smoke and eligible acceptance instance 01, not an extra shortened/diagnostic run. Invoke the unchanged driver via the existing PM wrapper (`go run ./_t140_t11_measure -out <fresh-output-directory>`); T12 uses its existing original driver/wrapper. Preserve all six saved source hashes and original assertions; no driver edits. [A:49; R:409-418.]
- Reuse eligible `93e8f0afe125b1ea8e87f4b8336664dd390c5b3a` controls. Take three independent eligible complete instances **per driver**, extending once to exactly five only under the existing paired-differences-straddle-zero **and** within-10-percent trigger. Keep failed/interrupted/ineligible receipts; slowness alone never excludes one. Fresh colonies/outputs, serial runs, no overlapping compute, five-second pre/post unrelated CPU at most 0.25 core. [A:39,49; R:409-418.]
- Independently for T11/T12, `median(OpenLong_i / actual Open-record ratio_i) <= median(OpenShort_i)`. For turn.start, local.admit, local.begin, task.create and task.cancel, `median(long) <= 2*median(short)+25ms`, using the new subject's own short samples; cancellation remains paired profile_cleanup traffic. The old 70.1972 ms task.create value is failure context, not a fixed substitute for the new cohort's formula. Retain T11 populations12→20, held turns1→3, burst16 and complete ten-operation cycles to actual B×10; T12 factor2/populations/four profiles remain. [A:15,39,49; R:412-418.]
- Label results **admission and storage only**. All seven bounds, fresh final reviews, this final SHA's own full hosted three-OS/race `Check result`, D153 guarded integration and separate whole-ticket Fable/close gates are still required. Failure does not authorize another mechanism/slice or relaxed bound. [MAIN `docs/DECISIONS.md:3148-3151`; A:39-49; R:416-418.]


## Rejected alternatives and owner gates

These are the rejected alternatives for P1/P2/P3, not additional proposals:

- **Checkpoint pass after Open:** would reread history just to fix the first reread; violates the explicit no-second-read target. Existing replay already has authoritative state and bytes. [A:27-29.]
- **Enable capture in general `scan` or every `refreshLocked`:** unnecessary for measured traffic, imposes hashing/checked-close changes on unrelated history and live refresh/review/paid/recovery paths, and can reseed at the very review advance that must invalidate. Preserving a dedicated legacy/general seam is smaller. [P1; A:21-33; R:77-93; `replay.go:241-279`; `history_index_test.go:568-602`.]
- **Seed before inspection succeeds, or use the later current frontier to stamp the saved token:** needlessly retains a seed in failed initialization and risks stale-proof retimestamping. Final success-only insertion at saved `openedThrough` is simpler and uses the exact-coverage guard already present. [P3; C:17-19; `history_index.go:319-326`.]
- **Retain an open Reader, per-segment offset catalogue, persistent checkpoint/snapshot, independent checkpoint field/cache, or more allowance:** outside the bounded mechanism and resource rules; the existing typed one-entry LRU already suffices. [A:39-40; R:64-80; `history_index.go:144-185,309-357`.]
- **Trust Submit receipt/prepared drafts, size/mtime/final line, skip decoding without a real token, or infer command absence from one observation:** weakens exact authoritative validation/provenance rather than fixing capture. Frozen D157 already supplies full fresh-byte identity plus original suffix verification. [A:39-40; `contract/ledger/doc.go:156-175`; `replay.go:281-312`; `scoped_execute.go:341-359`.]
- **Swallow a checked-close error, retry under legacy mode, or change frozen Reader/scanner/store to capture in legacy mode:** violates truthful-error/freeze constraints. No such implementation or interface change is proposed. P2's possible breaking classification goes to the owner instead, never a workaround. [C:9-12; A:39-40; MAIN `docs/DECISIONS.md:3129-3132,3145-3148`.]
- **Reduce/change traffic, delay task.create with a dummy warm operation, larger cache, threshold relaxation, driver-specific code or a seventh/fix-up slice:** expressly unauthorized. [A:39-42; MAIN `docs/DECISIONS.md:3144-3151`.]


## Ruling blockers

**No unresolved factual question blocks submitting this brief for a ruling.** Required gopls evidence and the PM's nil-proof/error interpretation are supplied. The advisor must explicitly rule on P1/P2/P3, especially the narrow exception to the fifth-slice scoped-only/cold-reopen restriction and the nonbreaking classification of truthful initialization-close errors. If the advisor finds a frozen/owner-reserved suppression guarantee, the exact blocking owner question is: **“May Core's initial Service replay opt into D157 checked closure, returning an actual replay descriptor-close failure from Open/OpenPaid instead of ignoring it?”** Until that approval, do not code around the gate. No other owner choice or new contract is requested. [C:7-24; R:77-93,175-191; MAIN `docs/DECISIONS.md:3145-3150`.]

This deliverable is design only: no repository edits, commands, tests, profiling, Git writes or subagents were performed by this designer; empirical success is deliberately unclaimed. [A:54.]


## Sources

All `PM/` aliases below refer to the existing session-local folder:
`C:/Users/darius.jones/.omp/agent/sessions/-Documents-PROJECTS-dwarf-harness/2026-10-24T15-58-31-752Z_01a16ea2-9748-77b3-ac90-a8beabd7bc22/local/`.

- **A:** `PM/t140-s6-designer-request.md` (54 lines).
- **C:** `PM/t140-s6-designer-clarifications.md` (24 lines).
- **E:** `PM/t140-s6-decision-excerpts.md`; canonical citation numbers in this brief are the source MAIN `docs/DECISIONS.md` numbers declared in E, not the excerpt's physical line numbers. Read the supplied excerpts, not the decision log.
- **R:** `PM/t140-s5-design-ruling.json`, retained fifth-slice technical ruling; the S6 ruling must explicitly replace only the Open-only restriction identified here.
- **L:** `PM/t140-s6-lsp-references.md`, regenerated after worktree registration; **LT:** `PM/t140-s6-lsp-references-test.md`.
- **ticket140:** MAIN `.scratch/dwarf-harness/issues/140-bound-the-private-state-services-replay-and-lookup-cost.md`.
- Source paths `service.go`, `replay.go`, `history_index.go`, `doc.go` and other bare Go filenames mean `internal/core/agents/<filename>` in `C:/Users/darius.jones/worktrees/dwarf-harness/140-final-ack/`, **except** `reader.go`, `reader_test.go` and `scan.go`, which mean `contract/ledger/<filename>`. Other repository paths are relative to that worktree; **MAIN** means `C:/Users/darius.jones/Documents/PROJECTS/dwarf-harness/`.
- The original driver cited as `../t11-s4-evidence/driver/main.go` resolves to `C:/Users/darius.jones/worktrees/dwarf-harness/t11-s4-evidence/driver/main.go`.
