# Ticket140 — bounded replay and lookup cost ruling

## Verdict

**APPROVE — buildable for implementation under this ruling.**

This approves the bounded design below, not unimplemented code, performance results, release readiness, or runtime capacity. Where the brief differs, this ruling governs the technical choice. No further design confirmation pass is requested.

**Review line:** Reviewed under D152 by a temporary GPT-6 Astra stand-in reviewer while Fable’s window is held. Fable will double-check the whole of Ticket140 after reset.

Base: `93e8f0afe125b1ea8e87f4b8336664dd390c5b3a`.

The supplied base provenance and retained Ticket11 command are sufficient. No separate API-diff artifact or reconstruction of the original build recipe is needed. Ticket13 remains outside this review; its close and Fable verification remain held.

### Evidence examined

The assignment, completed brief, documentation notes, Ticket140 acceptance criteria, cited Ticket11/Ticket12 rulings and evidence, applicable decisions/contracts, and affected implementation were read. In particular:

- `replay.go`: accepted-prefix publication and command lookup;
- `scoped_state.go`, task/work planning and authority: historical identities, context binding and live-state pruning;
- `review_state.go`, `review_plan.go`, `review_sources.go`, `review_execute.go`: replacement/results, witness verification and the direct live-commit path;
- `integrity.go`, `materialization.go`, `read.go`, `scoped_private.go`: historical inspection, materialization classification and read selection;
- existing golden, recovery and fuzz paths, including the currently supported paid family;
- the retained measurement drivers and current import evidence.

This was a read-only design review. No build, test, formatter, measurement or repository edit was performed.

## 1. Governing boundary

The ledger and existing validated projections remain authoritative. This ticket adds acceleration, not another state model.

Preserve:

- F3-10, F3-11, F3-12 and F3-13 support, including shared task, turn, child-work and book effects;
- existing authority, grant attenuation/revocation, privacy, CAS, denial/busy, receipt/dedup and failure ordering;
- existing recovery, integrity reporting, materialization completion and shutdown behavior;
- current record formats, public contracts, frozen fixtures and goldens;
- current disk layout and retained historical objects.

No new nonstandard import, module, persistent index, snapshot, database, repair command, public configuration, scheduler, executor, paid behavior or provider behavior is authorized. Existing credentials/providers imports and the D151 native-credential test exception are not new Ticket140 dependencies.

The cache must never hold private/body bytes, credential material, reusable permissions, reservations or executable plans. Existing ledger metadata necessary to reconstruct a lookup answer is permitted.

## 2. Decisions on P1–P9

### P1 — context association and fresh-ID absence: APPROVE

Use one small association hint on each existing work-context state:

- unknown;
- known never assigned;
- known historically associated with a task.

“Known never assigned” originates from an accepted context creation, not a map miss. An accepted assignment establishes the historical task association. Reassignment and terminalization must not erase that association or make an old context reusable.

The hint identifies the historical task; the current task/assignment and existing authority checks still decide eligibility. An old context must not become usable merely because the current task projection was pruned.

Use separate ledger-derived maxima for task, work, grant and assignment identities. Above a valid maximum proves absence in that namespace at the covered prefix. At or below it, consult the bounded cache or authoritative history. Legitimate out-of-order UUIDs remain valid; UUID timestamp assumptions are not authorized.

Requirements:

- Install hints/maxima only from completely accepted commits.
- Unknown, invalid, stale or missing proof falls back to history.
- Assignment-ID reuse and historical context reuse remain independent checks.
- Historical-prefix queries cannot borrow a later hint.
- After a maximum loses validity, observing a later suffix does not recreate a complete-history maximum. Rebuild it authoritatively or keep falling back.
- Preserve hints when replacing a scope state for a new revision.
- Do not rewrite every context’s hint on every commit.

### P2 — bounded historical cache: APPROVE, simplified

Use **one private, concrete cache**, shared through the existing lookup helpers:

- at most **256 entries**;
- at most **8 MiB of charged retained metadata**;
- one LRU eviction policy;
- oversized entries remain uncached and use the original path.

Kinds cover command matches, task/work/grant state, historical review requests, assignment existence and source-record metadata. Do not introduce independent family caches or a general caching framework.

Prefer existing ledger encoders/decoders and exact retained record bytes. Small wrappers for additional sequence/state scalars are acceptable. Do not mirror every ledger payload into a second schema or JSON-marshal existing structs whose meaningful fields are unexported.

Charge all retained byte buffers and copies. Do not retain an entire commit backing array while charging only one selected record. Fixed map/list/header overhead is separately bounded by the entry limit; **8 MiB is not an exact process-RSS promise**.

Returned values must not expose mutable cache-owned storage. Decode or copy them appropriately.

A new Service starts without inherited cache contents; Close discards the cache. Mandatory replay may populate it. No cache persistence, cross-Service transfer, prewarming service or benchmark-reset API is needed.

**Simplification:** use targeted invalidation on accepted mutations rather than implementing a second reducer that manufactures updated historical answers. Live projections already serve live state. After invalidation, the first historical lookup reconstructs the answer and subsequent valid lookups may reuse it.

### P3 — validity, corruption and concurrency: APPROVE, with the following exact rules

#### Representation and corruption

A new “sealed object” architecture is not justified.

Use ordinary private metadata: kind, key, covered prefix/interval and necessary provenance. A compact standard-library checksum over retained value and validity metadata is acceptable for the required damaged-entry fallback. For absence and historical-membership hints, protect the fields actually used as proof.

This checksum is accidental-corruption detection, **not** an authority seal or a defense against hostile same-process memory modification. No generated incarnation ID, random epoch, serialized Service identity, generic seal framework or whole-projection checksum is authorized. Instance-owned storage supplies the lifetime boundary.

On failed checksum, decoding, shape, key, range or provenance validation:

1. discard the acceleration entry or hint;
2. use the original authoritative path;
3. preserve that path’s result or error.

Corrupt acceleration alone must not poison otherwise valid durable state. Corrupt authoritative history must still fail as before. Never turn failed validation into absence, “healthy”, permission or successful replay.

#### Publication and invalidation

Maintain whole-commit cache coverage. Before publishing a new covered cursor, invalidate affected entries for every accepted effect:

- every F0 command occurrence: that command key;
- grant issue/revocation: that grant;
- task mutations and F3-12 task transitions: that task and affected cached review states;
- work admission/dispatch/end: that work;
- review request/result/replacement: affected request IDs, including the replaced request;
- assignment introduction: relevant assignment-existence answers;
- source records remain immutable, subject to complete-commit/prefix checks.

A bounded scan of the cache to invalidate review entries bound to an affected task is acceptable. Do not create an immortal reverse-dependency map.

Preserve resolved results when a request is later replaced. Preserve task-description source sequences and F3-12 transitions that have no accompanying `runtime.task_changed`.

**Both publication paths are in scope.** `review_execute.go:117-134` installs an already-preflighted live review directly and advances `p.through`; it does not always go through `refreshLocked`. It must perform the same accelerator invalidation/coverage publication. Preserve its existing optimization: do not reread immutable witnesses merely to update the cache.

#### Command lookup is not merely an immutable receipt lookup

`findCommand` searches `(after, through]` and detects duplicate commands. Preserve both properties.

- Do not seed an authoritative command-search answer merely because one command record was observed.
- Warm command answers from the completed authoritative search for the covered interval.
- A negative tail search cannot become a global “ID absent” answer.
- A cached positive must satisfy the requested interval and complete-commit boundaries.
- Any later accepted F0 occurrence with the same ID invalidates the cached search result.
- Never overwrite a conflicting occurrence and thereby conceal a duplicate.

Receipt bytes are immutable; **search uniqueness and interval coverage are not**. The store’s hot-index duplicate detection is not a substitute for `findCommand`’s existing behavior.

#### Unlocked reads

A single private cache mutex is justified by existing unlocked lookup paths:

- no I/O while holding it;
- never acquire `Service.mu` while holding it;
- where both are needed, use `Service.mu` before the cache mutex;
- release the cache lock before returning data to callers or invoking other service work.

Mutable, negative **and command-search** cold fills captured at prefix T may be inserted only if cache coverage is still exactly T. Otherwise retain the existing caller/tail-recheck protocol and do not install the late result.

A positive immutable source record may survive coverage advancement only when its entire commit was already validated and its requested prefix remains valid.

Cache hits never bypass current caller binding, read rights, grant checks, task versions, revocation, reducer validation, final pre-submit checks or existing retry/wait ordering.

### P4 — startup inspection: APPROVE

The retained startup evidence and current implementation justify the fused pass now. A current-head-only live optimization cannot remove Open’s required historical inspection. No additional preimplementation timing run is needed to authorize this choice.

Use:

1. the existing complete reducer traversal;
2. one global historical-integrity traversal shared across scopes;
3. current-head/materialization completion without another history sweep per scope.

These are **two outer streaming passes**, not a promise of exactly two physical ledger reads. Necessary cold lookups during reduction remain possible and must be included in measured Open time.

The historical pass must:

- consume both private-revision families;
- inspect every selected historical object occurrence;
- retain occurrence identity even when hashes repeat;
- preserve report bindings and deterministic sorted-scope/occurrence ordering;
- report superseded non-transcript corruption without fencing an intact current head;
- retain fences for current selected objects and any selected transcript-history corruption.

Do not deduplicate verification by digest or replace occurrence semantics with a hash set.

For Markdown classification, retain only each slot’s observed digest and bounded membership facts needed for this inspection, not lifetime digest collections. Preserve same-scope, same-slot membership.

Completion must reobserve actual files and verify current selected objects through the existing path. A historical observation is not permission to overwrite a subsequently foreign file. Avoid calling the old per-scope history-scanning completion unchanged, which would restore the cost being removed.

Snapshotting is not authorized.

### P5 — live integrity: APPROVE

Retain one last successfully materialized committed digest per Markdown slot as a bounded historical-membership hint. It is not a health cache.

For every applicable new operation:

- freshly verify actual selected immutable objects;
- freshly inspect actual Markdown;
- preserve link, wrong-kind, unreadable-file and foreign-file refusal;
- keep existing agent/context scope gates and final private-state checks.

Classification remains:

- actual current digest: current;
- missing Markdown: stale;
- valid earlier same-slot digest: stale;
- unmatched regular bytes: perform authoritative same-slot historical membership checking before classifying them as foreign;
- missing/corrupt selected immutable object: existing integrity failure.

A hint mismatch is not proof of foreignness. Missing Markdown is not equivalent to a missing immutable object.

Historical matched receipts retain their existing authority/dedup/wait semantics; do not add a new current-integrity or capacity prerequisite to replaying a receipt.

**Correct the brief’s warm-integrity test instruction:** “remove Markdown, therefore the next operation must refuse” is not the contract. Test foreign Markdown separately from absent/stale Markdown. `doc.go:341-365` explicitly preserves stale completion.

### P6 — current selection and review witnesses: APPROVE

Use a current-head fast path only for an exact current-prefix, current-revision, non-transcript selection. Preserve the selected Head’s own digest, byte count, revision and sequence; an unchanged slot’s head revision need not equal the scope revision.

Apply the same selection rule to read preparation and replay validation. Historical revisions and transcript pages retain exact-occurrence history selection, including duplicate hashes, clears, byte limits and cursors.

**Locking requirement:** `selectPrivateRead` is also called after `Service.mu` is released (`scoped_execute.go:196-204`). Copy any current projection data under the appropriate lock; a scope gate alone is not permission to read mutable projection fields unsafely. Replay validation already running under `Service.mu` must not recursively acquire it.

For review witnesses:

1. satisfy valid requested records from the shared cache;
2. batch remaining witnesses through the existing segment-aligned reader;
3. apply all existing witness and read-rights validation.

A matching digest alone is insufficient. Preserve record sequence/type, complete-commit prefix, origin/binding, revision, slot, mode, byte count and body-reference checks, including the task-description source rule.

Do not restore one from-zero scan per witness. Preserve Ticket12 S5’s authority/source-check ordering.

### P7 — repeated planning: APPROVE

Keep all preparation, derivation, final reducer, current-authority, CAS and pre-submit phases.

Reduce lookup cost beneath those phases. Do not retain authorization or a preflight plan across an unlock, remove repeated checks, merge scope-gate phases or alter reservation/acknowledgement behavior.

### P8 — finite acceptance and noise: APPROVE

Adopt the measurement recipe in §5 below. Its bounds are fixture engineering thresholds, not an SLA or an asymptotic proof.

### P9 — implementation plan: APPROVE

Use exactly **three sequential slices**, defined in §4. Shared files and invariants make these dependent slices, not concurrent implementation jobs.

## 3. Memory and failure model

| State | Bound |
|---|---|
| Historical cache | 256 entries, 8 MiB charged metadata, bounded container overhead |
| Namespace maxima and coverage | Constant-size |
| Context association hints | One per already-retained context |
| Materialization hints | Fixed number per already-retained scope |
| Existing live projections | Existing contract/live-population bounds; unchanged |
| Reconciliation issues/output | May grow with actual reported historical failures |
| Authoritative ledger/objects | History-growing disk; no retention change |
| Cold historical queries/transcripts | May scan history; no universal constant-time claim |

No lifetime task, assignment, request, command or digest map is introduced.

Eviction, disabling, discarding, stale detection or corruption detection of acceleration must lose no committed fact and itself append or dispatch nothing. Missing prerequisites must produce the existing honest fallback/error, not a fabricated successful answer.

## 4. Three implementation slices

### S1 — context association and absence proofs

Owned product paths:

- `internal/core/agents/service.go`
- `internal/core/agents/replay.go`
- `internal/core/agents/scoped_state.go`
- `internal/core/agents/scoped_plan.go`
- `internal/core/agents/review_execute.go`
- `internal/core/agents/history_index.go`, if used immediately for the implemented hint/coverage helpers

Implement P1 and the applicable P3 publication rules. No LRU scaffolding or second temporary cache.

Include the direct live-review cursor path from the outset. Until S2, at/below-watermark historical lookups retain their original scans.

Regression work belongs in `history_index_test.go` and existing task/recovery test files where appropriate. Consumer-visible coverage must distinguish:

- old-context reuse after reassignment and terminalization, before/after reopen;
- missing/damaged hints versus genuine unassigned contexts;
- valid out-of-order IDs versus actual reuse in each namespace;
- F3-12 terminal transitions and retained historical association.

Assert authorization/state/receipt/durable-effect outcomes, not hint fields or hit counts.

### S2 — bounded historical answers and witnesses

Owned product paths:

- `internal/core/agents/history_index.go`
- `service.go`, `replay.go`, `scoped_state.go`, `scoped_plan.go`
- `review_state.go`, `review_plan.go`, `review_sources.go`
- `review_execute.go`

Implement P2/P3 and the source-witness portion of P6 through existing helpers. Touch only the listed files actually needed; the ownership list is not an instruction to refactor all of them.

Use targeted invalidation, not a duplicate historical-state reducer. Cover live direct-review publication as well as replay.

Regression work belongs primarily in `history_index_test.go` and existing review/source tests. Necessary cases include:

- empty, warm, evicted, discarded and detectably corrupt acceleration producing the same observable answers;
- earlier-prefix and command-interval queries, including a negative tail lookup followed by a broader lookup;
- revoked grants, terminal tasks, resolved/replaced requests and exact historical receipts;
- late cold fills racing a winning commit/revocation/replacement;
- wrong witness type, sequence, origin, slot, size or reference remaining refused;
- no duplicate effect, hold, charge or disclosure.

No paid producer, accounting, credential or paid-cache files are owned.

### S3 — fused Open and fresh current-head integrity

Owned product paths:

- `internal/core/agents/integrity.go`
- `materialization.go`, `service.go`, `replay.go`
- `read.go`, `scoped_private.go`
- `doc.go`

Implement P4/P5 and current-head selection from P6. Preserve P7.

Regression work belongs in existing `recovery_test.go`, `private_test.go`, `scoped_private_service_test.go`, `scoped_read_service_test.go`, and the relevant cross-prefix cases in `history_index_test.go`.

Cover:

- warm inspection followed by selected-object corruption/removal or genuinely foreign Markdown;
- absent/stale Markdown retaining its distinct completion semantics;
- superseded non-transcript reporting versus transcript/current-head fencing;
- both revision families and equal hashes across different slots/scopes;
- current selection, clears, byte boundaries, historical selection and repeated transcript occurrences;
- existing projection-fence, completion-failure, duplicate/new-call, cancellation and Close-draining behavior.

Run the unchanged service-level frozen-family and crash-recovery coverage for all four families. The existing `TestPaidGroupRulesAndFrozenReplay` already exercises F3-10 through F3-13 through Open; do not rewrite fixtures to fit the optimization.

Update package cost documentation and Ticket140 evidence after proof. Do not edit Ticket13 records or represent this as its verification.

### Evidence rules for every slice

The brief’s blanket `30m` recipes are superseded:

- focused and plain verbose package tests: `-timeout 19m`, matching Bash deadline `1200s`;
- whole-package race: `-timeout 29m`, deadline `1800s`;
- affected concurrency rows at `-race -count=20`: `-timeout 45m`, deadline `2800s`.

All three slices change shared state, so the race condition is met. Use the existing pinned race compiler; ordinary commands remain `CGO_ENABLED=0`, race uses `CGO_ENABLED=1`.

Use host vet/staticcheck and formatting checks for owned files. No local full `tools/check` and **no tools/check timeout change**.

Keep the brief’s focused affected-row assignments, adding a row only for a genuinely affected concurrency contract. Permanent tests must catch plausible behavior, authority, corruption or recovery failures, not wiring or source text.

PM owns measurements and any 120-second fuzz campaigns. Select existing fuzz targets by actual changed-path reachability; do not automatically run every target because it belongs to agents. Preserve failing inputs. Necessary assertion adjustments must retain the observable no-effect invariant rather than pin disposable cache contents.

Each final slice SHA requires fresh D152 review and the successful D153 hosted **Check result**, including the full Windows/Linux/macOS matrix and race, before ff-only integration. A fix/rebase requires its own exact-SHA result.

## 5. PM measurement recipe

### Provenance and controls

The original Ticket11 command is retained in `t11-s4-evidence/yield.json:749-763`:

`go.exe run ./_t11_s4_measure -out .../smoke-final`

Its recorded environment is `GOTOOLCHAIN=local`, empty `GOFLAGS`, `CGO_ENABLED=0`, `GOOS=windows`, `GOARCH=amd64`; exit was zero. Driver hashes match. This is not a missing prerequisite.

Use the supplied base SHA, not a historical pre-Ticket13 binary. Capture one quiet complete base control per driver and three independent complete final-candidate runs per driver. Use the same toolchain/environment and fresh output/colony directories, serially.

The retained Ticket11 growth phase took 470.66 seconds. Reserve a suitable quiet window; do not shorten the workload to fit a smaller window.

### Primary: unchanged Ticket11

Copy all saved source bytes into PM-owned untracked `_t140_t11_measure/` under the module root:

    go run ./_t140_t11_measure -out <new-absolute-evidence-directory>

Keep populations 12→20, held turns 1→3, burst16, and the unchanged ten-operation cycle.

Require the original **87/874 commit profile endpoints**. Record actual record counts; historical runs differed in records. Do not edit traffic to force a record count. If unchanged traffic does not reproduce the commit endpoints, retain the result and resolve reproducibility before accepting it; do not silently select a shorter history.

The profiled operation rows are single samples per run, not within-run p50 estimates. Take medians across independent complete runs. Aggregate-phase p50/p95 rows are not substitutes.

For each run, use actual Open record frontiers:

`R_i = Hlong_i / Hshort_i`.

| Metric | Final acceptance |
|---|---|
| agents.Open | `median(OpenLong_i / R_i) <= median(OpenShort_i)` |
| turn.start | `median(long) <= 2 * median(short) + 25 ms` |
| local.admit | Same bound, its own rows |
| local.begin | Same bound, its own rows |
| task.create | Same bound, its own rows |
| task.cancel | Same bound, paired `profile_cleanup` cancellations immediately after each profile |

Report store.Open separately. Do not use its timing as the startup denominator. Preserve post-profile records separately.

Report raw startup times, time per record, normalized growth and:

`log(OpenLong / OpenShort) / log(R)`.

Two history lengths do not prove universal linear complexity.

### Supplemental: unchanged Ticket12 S5

Use the saved S5 package and its existing label-only edit, not the older S4 bytes:

    go run ./_t140_t12_measure -profiles <new-absolute-profile-directory>

Retain default factor2, populations12,20 and the four CPU profiles. No mandatory factor10 rerun is authorized.

Report at both lengths:

- actual H/N/G, terminal grants and scopes;
- Open and its history-normalized bound, using the same formula as Ticket11;
- request, approve and failure traffic;
- first and repeated old command/request lookups;
- real review witness paths and CPU profiles;
- base-versus-final results.

“Cold” here means the unchanged driver’s first lookup after reopening. Do not claim OS-cache coldness or a guaranteed LRU miss when mandatory replay may have populated acceleration.

The driver’s from-zero/segment-aligned reader probes reenact old implementations; they do **not** measure the new production cache. Label them accordingly. Real review probes/profiles supply production-path evidence.

Supplementary Open failure is not waived. Reintroducing ordinary-path history scans or the S5 bottleneck blocks acceptance even if a median passes. Do not invent a new review API latency SLA.

### Quiet eligibility and fixed noise resolution

Before and after each run, record five-second process CPU deltas:

- no overlapping local test, fuzz, check or measurement job;
- summed unrelated-process utilization at most 0.25 CPU core in both observations.

Postpone an ineligible start. Retain and label an interrupted/overlapped or post-observation-ineligible run as loaded-invalid, then replace it. Slow timing alone never invalidates a run.

After three eligible candidate runs, if paired differences straddle zero **and** the median lies within 10% of its bound, run exactly two more complete instances of that driver and decide using all five medians. Apply this once per driver, not separately until each metric passes.

Differences:

- startup: `long/R - short`;
- operation: `long - (2*short + 25ms)`.

The 10% band triggers additional sampling; it does not relax a bound. A clear failure, or failure after five runs, fails acceptance.

The operation allowance is a finite engineering choice: a near-flat threshold plus an additive allowance that avoids making tiny short samples define an unrealistic percentage bound. It is not a measured jitter distribution. Startup receives no exponent slack; quiet eligibility, medians and the fixed repeat rule address noise without excusing superlinear growth.

Missing, unexpectedly refused or semantically inconsistent samples fail; never count them as zero.

### Retained evidence and labels

Retain exact commands, environment, source/product hashes, final SHA, stdout/stderr, statuses, all eligible and invalidated attempts, profiles, frontiers, bytes/scopes, available heap/process/allocation figures and unmeasured quantities.

Label both reports **admission and storage only**, preserving S5’s bookkeeping label. No provider call, executor, accepted-delivery, runtime-capacity, power-loss or production-throughput claim follows.

After preserving evidence and hashes, remove only PM-owned throwaway packages before hosted checks.

## 6. Gates and stopping rules

No owner-only gate is currently triggered.

This ruling does not waive owner approval for a frozen/API break, dependency/toolchain change, D52 promotion boundary, or new workflow, machine, credential, account, money or provider action.

If the implementation loses a fence, permits stale authority, changes a family’s replay/crash behavior, or misses the finite cost bounds:

- retain the exact reproduction and evidence;
- do not suppress the failure, shrink traffic, enlarge the cache arbitrarily or relax thresholds;
- seek a bounded amendment naming the remaining measured path and owned scope.

No snapshot, broad grant index or additional subsystem follows automatically from a failed measurement.

If recorded as a technical decision, use originator `assistant`. Keep private decision/evidence material in the main checkout under D145.

**Remaining blocking findings: none. Evidence requests: none.**
