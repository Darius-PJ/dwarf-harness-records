# T06 brief: ticket 06 — keep bounded checkpoints and lineage outcomes distinct

Designer: DesignT06, 2026-10-12. Status: **draft for the build advisor's ruling; the ruling wins where the two differ.** The owner approves the design before any code (OG-A6, §7.3); the freeze of ticket 06's records (F2-06) is his later, separate question (§8).

**Sources** are cited as `file:line` at `main` 8c2c328. Abbreviations:
- T05–T09 = `.scratch/dwarf-harness/issues/0N-….md` (tickets 05–09).
- RC = `docs/ROADMAP-CORE.md`; CORE = `docs/DESIGN-CORE-AND-LAUNCHERS.md`; DEC = `docs/DECISIONS.md`; CON = `docs/CONTRACTS.md`; UC = `docs/DESIGN-UNDERCURRENT.md`; SPEC = `.scratch/dwarf-harness/spec.md`; AGENTS = `AGENTS.md`.
- PKT = `.scratch/dwarf-harness/c2-evidence/d52-c2-approval-packet.md`; BR = `…/ticket-05-design-brief.md`; RU = `…/ticket-05-design-ruling.md`.
- WD = `internal/core/workspace/doc.go`; LD = `contract/ledger/doc.go`; other code files by name under `internal/core/workspace/` unless a path is given.
- **G6-Mn** = the Git probes M1–M9 in `local://t06-git-probe.md` (Git 2.55.0.windows.3, owner's machine; Appendix D).
- **AN1–AN4** = the build advisor's four notes for ticket 06 (the assignment; MAP's `advisorNotes`). **OI-n** = the open items of the reader's map `local://t06-map.md`, which served as index only; every passage a decision rests on was re-read.
- **(my choice)** marks a value no source fixes.

---

## 0. Owner summary

**What ticket 06 builds:** C2's checkpoint admission and lineage mechanics, in `internal/core/workspace`.
- **Request IDs.** Each promotion request carries its own ID. Repeating an ID with the same request returns that request's state without a new snapshot, even after a restart; reusing an ID for a different request is refused (D58).
- **Four checkpoints per context.** Each context may hold four unfinished checkpoints per workspace; a fifth gets "busy" before any snapshot. Capacity is four per enrolled context, so it grows with the contexts; there is no workspace or colony cap (B4, D112).
- **Chains.** Every checkpoint after the first must name the latest one. Core captures it against that checkpoint's sealed tree, so each contributes only its own change and a later `.gitignore` edit cannot drop files already captured.
- **Merging.** Core merges each checkpoint, in the order admitted, onto the work queued ahead of it with Git's three-way merge (a "generation"), keeping at most four generations per workspace. A mechanical conflict is reported with the conflicting files and never resolved automatically.
- **Failures.** If a checkpoint fails, its later checkpoints fail with it; if another context's work leaves the queue, the survivors are merged again without it. After a failure the context starts a new chain that names the failed one; old IDs never come back.
- **Clean-up.** Core keeps captured and merged trees while a request needs them and releases them afterwards; at startup it removes leftovers that no record owns.

**Not built here:** finalization, acceptance, cancellation, no-change and crash recovery (ticket 08); temporary scratches (07); policy activation (09). C2 still answers every real promotion request "unavailable": no validator exists before C4, so admission and merging run only in tests on throwaway repositories (D52).

**Consequences to know.** Core will need Git 2.45 or later, not 2.42 (Git merges plain trees only from 2.45). Merge settings in a repository's own `.gitattributes`, such as `merge=union`, are ignored when Core merges: only your pinned attributes apply and no merge program ever runs, so such conflicts reach the agent as work. A scratch cannot be closed while it has an unfinished request. Each admitted checkpoint stores its full file list, about 220 bytes per file, kept while the request is unfinished. Core never runs `git gc`: objects it stops needing wait for Git's own maintenance; this is decided now and revisited with C4's measurements. Request history stays in memory and grows with use (none in C2's product, which admits nothing).

**Owner gates.** OG-A6: approve this design, as the advisor rules on it, before any code. Later, OG-F6: freeze ticket 06's three record types (F2-06), asked with a one- or two-page packet before the code that writes them.

---

## 1. Owned paths

Non-test `.go` file names are not API and may be merged or split; testdata paths are exact.

**S1 — record-free mechanics** (edits ticket 05's package; may reach `main` before the F2-06 freeze, D113 DEC:1647):

```
internal/core/workspace/profile.go      CapacityProfile (renames CaptureProfile) + CheckpointsPerPair, GenerationWindow; ProvisionalCapacityProfile; Config.Capacity (§2.3)
internal/core/workspace/reserve.go      the K-slot on the reservation token (§2.4)
internal/core/workspace/gitparse.go     Git floor 2.45 (§2.2); parseMergeTree (§2.8)
internal/core/workspace/git.go          integrationEnvironment (§2.8)
internal/core/workspace/integrate.go    new: mergeTrees, the derived-tree check, the conflict report, the integration commit, generation-ref helpers (§2.8–2.9)
internal/core/workspace/capture.go      S1b nits 2 and 3 (P24)
internal/core/workspace/service.go      Config.Capacity only
internal/core/workspace/doc.go          Git floor, profile, reservations, integration primitives
internal/core/workspace/reserve_test.go, gitparse_test.go, capture_test.go, capture_posix_test.go, fuzz_test.go, helpers_test.go (changed)
internal/core/workspace/integrate_test.go (new)
every test that names CaptureProfile, ProvisionalCaptureProfile or Config.Capture (rename only)
```

**S2 — ticket 06's part of F2, drafted in the frozen ledger contract** (additions only; reaches `main` only with the owner's freeze, D41, D113 DEC:1649, D116 item 3 DEC:1903):

```
contract/ledger/promotion.go            new: the three F2-06 types (constants, payload structs, Encode, Decode)
contract/ledger/catalogue.go            Defined() gains them at version 1 (eleven type versions)
contract/ledger/doc.go                  catalogue paragraph; new section "F2-06 record types" (Appendix B)
contract/ledger/promotion_test.go       new: round trip and refusals
contract/ledger/golden_test.go          TestGoldenF2_06; TestGoldenDecodes over the new golden
contract/ledger/fuzz_test.go            FuzzDecodeF2_06; FuzzCheckTruncation's seeds gain the new golden
contract/ledger/testdata/f2/06/log/00000000000000000001.jsonl
docs/CONTRACTS.md                       status line (:3), ledger-format row (:25), an F2-06 table after :65 (Appendix B.6), with the freeze
```

**S3 — the service, which writes F2-06's records** (starts after the freeze, D113 DEC:1646):

```
internal/core/workspace/request.go      new: Request, RequestState, beginRequest (identity, head, reservation, availability)
internal/core/workspace/admit.go        new: admit
internal/core/workspace/train.go        new: integrate, endings and cascades, ref releases
internal/core/workspace/promote.go      RequestPromotion's new signature
internal/core/workspace/service.go      projection (requests, lineages, trains, generations), F2-06 replay rules, consumption, Open's record-aware sweep
internal/core/workspace/scratch.go      CloseScratch refuses while requests are live; releases refs no longer retained
internal/core/workspace/errors.go       ErrRequestMismatch, ErrStaleHead with *HeadError, ErrLiveRequests
internal/core/workspace/doc.go          requests, lineages, admission, trains, retention, loose objects
internal/core/workspace/request_test.go, admit_test.go, train_test.go (new)
internal/core/workspace/replay_test.go, service_test.go, promote_test.go, scratch_test.go, workload_test.go, helpers_test.go (changed)
```

**Documents, once, at the ticket's close** (D116 item 3, DEC:1903): ticket 06's file (claim, status, criteria, Answer, comments); this brief and the advisor's ruling under `.scratch/dwarf-harness/c2-evidence/`; the owner's answers; one short B entry (B«next») pointing to the ruling, `doc.go` and the evidence; the harness results as Core Appendix A.12 with the raw lines in `c2-evidence/`; C2's `**Status.**` line (RC:416) and the status board, in one commit (D116 item 4). The freeze's decision entry, the register change and UC:616/:618's notes land with S2 instead (D116 item 3).

**Not touched:** `contract/ledger/appender/**`, `internal/core/ledgerstore/**`, `internal/core/durable/**`, `tools/check/**` (its rows already admit every import), `go.mod`, `go.sum`, `.gitattributes`, `cmd/**`; D112's approved text RC:278–416 and CORE:848–882, except RC:416's status line at close. No module is added (D29; AGENTS:39).

---

## 2. Exact behavior

### 2.1 Scope and gates

**What ticket 06 builds** (T06:12, :28–31; RC:332–333, :353–358, :407; CORE:850–864; B23 item 1 DEC:1698; B24 item 11 DEC:1858; AN1–AN3):
- request IDs and D58's identity at the workspace layer (§2.5);
- `K=4` checkpoints per enrolled pair, with workspace and colony capacity the sum over pairs (§2.4);
- lineages: heads, successor baselines and explicit new roots (§2.6);
- admission: a seal against the right baseline, publication and binding of the manifest, the admission record, and the K-slot's transfer to the request (§2.7);
- the workspace train: generations by explicit-base `git merge-tree --write-tree` within the leading window, rebuilt when a predecessor changes (§2.8);
- mechanical conflicts as visible work under the disclosure barrier (§2.9);
- lineage failure (`dependency_failed` suffix) kept distinct from foreign removal (§2.10);
- retention: capture and generation refs released by terminal state, and Open's record-aware sweep (§2.11);
- F2-06's three record types (§3, Appendix B).

**C2's product stays unavailable** (D52 DEC:342; RC:289; T08:32; PKT:139). `RequestPromotion` runs every pre-capture step of a request (identity, head, reservation with its K-slot, availability) and answers `no_validator`, unconditionally and with no seam (DEC:1747; RU:14). It never captures, records, integrates or moves a ref. Admission (`admit`) and integration (`integrate`) are mechanisms that C4 calls once its validator is reserved (RC:524 "C2's bounded cumulative candidate preparation"); until then they are exercised by package tests in disposable repositories, as RC:289, DEC:342 and PKT:141 allow (P1).

**Not built here:**
- finalization, acceptance, the success endings `accepted` and `no_change`, cancellation, and D55/D59 crash reconciliation (ticket 08: T08:12, :28–31);
- temporary scratches, end-of-turn commits and merge-back (ticket 07: T07:12, :28–30);
- policy activation and evidence epochs (ticket 09: T09:12);
- authentication, command receipts, result delivery and authorized body reads (C3: RC:312, :447–450; DEC:1438, :1493);
- validation lanes, the scheduler, attempts, `rejected`, the release of sealed generation output (BD2) and proof that children stopped (C4 and C10: RC:313, :408–409, :524).

**Gates** (T06:22–24): C0 is done; the families ticket 06 consumes are frozen, F0 (D111) and F2-05 (D115); D52 is approved (D112); harness work stays testing-only. F2-06 is frozen by the owner before S3 (D113 DEC:1646; §8).

### 2.2 Package, imports and Git

- Package `internal/core/workspace`. Imports unchanged: the standard library, `contract/ledger`, `contract/ledger/appender`, `internal/core/ledgerstore` (DEC:1810; D45, AGENTS:38). No module (D29; AGENTS:39); `CGO_ENABLED=0` (D28; AGENTS:40).
- **Git floor 2.45** (P10). Ticket 06 merges three trees: two of them, the delta base and the sealed submission, are trees with no commit (§2.6). Git accepts tree arguments with an explicit merge base only from 2.45; `--merge-base` arrived in 2.40 and `--no-messages` in 2.38 (G6-M3, G6-M9). B23 chose 2.42 as "the oldest version with every option the code and ticket 06 use", counting only `--write-tree` (DEC:1701). `parseGitVersion` refuses below 2.45 (gitparse.go:227–228), and WD:8 and WD:336 change to 2.45. C3's CI must supply Git 2.45 or later on Linux and macOS.

### 2.3 Capacity profile (P6)

```go
// CapacityProfile is Core §13.2's CapacityProfile (CORE:862) as far as C2 uses it; C4 extends it.
type CapacityProfile struct {
	MaxFiles           int   // files in one capture (B23 item 10)
	MaxBytes           int64 // raw bytes one capture reads; also each capture's reservation
	BytesInFlight      int64 // colony-wide capture reservations
	CheckpointsPerPair int   // K: live admitted requests per enrolled pair (CORE:852)
	GenerationWindow   int   // live generations per workspace train (CORE:862's leading window)
}

// ProvisionalCapacityProfile returns calibration inputs, not measured capacity.
func ProvisionalCapacityProfile() CapacityProfile // {100_000, 1 << 30, 20 << 30, 4, 4}

type Config struct{ Capacity *CapacityProfile } // nil: no_capacity_profile, as before
```

- `MaxFiles`, `MaxBytes`, `CheckpointsPerPair` and `GenerationWindow` must be at least 1 and `BytesInFlight` at least `MaxBytes`; otherwise `ErrInvalid`.
- The values are provisional calibration inputs (D112 DEC:1536; RC:337; B15 DEC:766–767), not measured capacity, a colony cap or a service level.
- Clean cutover: `CaptureProfile`, `ProvisionalCaptureProfile` and `Config.Capture` disappear and every caller migrates. The rename answers RU:63 and B23 item 10's "which ticket 06 and C4 extend rather than add a second" (DEC:1745); the unavailable reason was already `no_capacity_profile`.

### 2.4 Reservations and the K-slot (P5, P7; AN2)

- `reserve(scratch, kind)` takes, under the pool's one mutex, all of a kind's parts or none, and never waits (D70 DEC:504; DEC:1740–1741):
  - *closure*: the scratch exclusion; closure adds `MaxBytes` before it observes (unchanged);
  - *admission*: the scratch exclusion, `MaxBytes` and one of the pair's K-slots.
- Busy and unavailable answers, in CORE:856's listing order (authority, scratch exclusion, K-slot, capture bytes): no profile gives `*UnavailableError{no_capacity_profile}`; a held scratch `*BusyError{scratch_busy}`; a pair whose live admitted requests number `CheckpointsPerPair` or more gives `*BusyError{checkpoint_slots}`; a short pool gives `*BusyError{capture_budget}`.
- **The slot's lifetime.** The pool keeps `live`, the number of live admitted requests of each scratch. An admission token holds one slot provisionally; the scratch exclusion means at most one per scratch.
  - `keepSlot()` transfers the slot to the request (`live++`). `admit` calls it once its record is acknowledged, then releases the token, which returns the exclusion and the bytes (DEC:1743).
  - A token released without `keepSlot` returns its slot too: refusals and failures leak nothing.
  - `freeSlot(scratch)` runs once per request, when the commit that ends it is acknowledged (§2.10). The K-slot thus "lasts until the request's terminal state" (DEC:1743; WD:226).
  - `setLive(scratch, n)` restores the counts at Open from replay (§2.13).
  - `release` stays idempotent; `keepSlot` acts at most once per token; the service calls `freeSlot` once per ended request, guarded by its projection.
- One token still permits one capture (DEC:1742). C2's `RequestPromotion` reserves kind *admission* and releases at `no_validator` without `keepSlot`.
- **Enrolled pairs and Q** (OI-7). An enrolled code-working pair is a (context, workspace) pair with an open scratch: F2-05's `scratch_created` without `scratch_closed` (LD:242–355). K is per pair; the workspace's Q is the sum over its open scratches and the colony's the sum over workspaces (CORE:852; RC:332, :572, :608), so no separate workspace or colony cap exists. `BytesInFlight` remains a shared resource bound, "subject to shared resource limits" (RC:608), recalibrated at C4's gate (§2.17).

### 2.5 Requests and `RequestPromotion` (P2, P3, P4, P21)

```go
// Request is one promotion request (D53, D58). The caller names it; Core captures its content.
type Request struct {
	RequestID   uuid.UUID    // UUIDv7, the caller's immutable request ID
	Actor       ledger.Actor // owner or agent; C3 authenticates callers later (P28 of ticket 05)
	ContextID   uuid.UUID    // the bound context; with WorkspaceID it names the pair's scratch
	WorkspaceID uuid.UUID
	Head        uuid.UUID    // the scratch's latest admitted request, which becomes the parent; zero for a root
	RestartFrom uuid.UUID    // a new root after failure: the failed head; zero otherwise
}

// RequestState is what the request's own context may see (CORE:880).
type RequestState struct {
	RequestID      uuid.UUID
	State          string        // RequestPending, RequestConflict or RequestDependencyFailed
	LineageID      uuid.UUID
	Checkpoint     int64
	SealedTree     string        // its own submission's tree
	FailedRequest  uuid.UUID     // dependency_failed: the failed local request
	ConflictReport ledger.Digest // conflict: the released report body
}

const (
	RequestPending          = "pending" // admitted and not ended (CORE:856's admitted and pending_integration_or_validation)
	RequestConflict         = "conflict"
	RequestDependencyFailed = "dependency_failed"
)

func (s *Service) RequestPromotion(ctx context.Context, r Request) (RequestState, error)
```

The signature replaces ticket 05's `RequestPromotion(ctx, contextID, workspaceID) error` (promote.go), as BR:797 anticipated; its only callers are tests.

**`beginRequest(ctx, r)`**, shared by `RequestPromotion` and the mechanism, answers in this order (P3):
1. **Binding.** A usable service (`ErrClosed`, `ErrPoisoned`). `RequestID`, `ContextID` and `WorkspaceID` are UUIDv7, `Head` and `RestartFrom` zero or UUIDv7, and `Actor` is `owner` or `agent`; otherwise `ErrInvalid`. The workspace is known, else `ErrUnknownWorkspace`.
2. **Identity** (D58 DEC:399–400; CORE:850; PKT:137).
   - If `RequestID` was admitted, the request's `ContextID`, `WorkspaceID`, `Head` and `RestartFrom` are compared with the record's `context_id`, `workspace_id`, `parent_request_id` and `restart_from`. Equal: return its `RequestState` with nothing reserved, captured or written, whatever the state of the scratch (busy, closed, missing) or of Git. Different: `ErrRequestMismatch`. `Actor` is not compared: it names who asks, not what the request binds (D58 names "submission content, candidate or context").
   - If an admission of `RequestID` is in flight (begun, record not yet acknowledged): `*BusyError{request_in_flight}` (my choice), at once.
3. **Scratch.** The pair's open scratch, else `ErrNoScratch`.
4. **Head** (§2.6): otherwise `*HeadError` matching `ErrStaleHead`.
5. **Reservation** (§2.4): kind *admission*.
6. **Re-check:** service still usable and scratch still open after the reservation (as `promote.go` does now).
7. **Availability:** `git_unavailable`, `inputs_unavailable`, `inputs_stale`, `workspace_unverified`, `scratch_missing`, `anchor_missing` (DEC:1840).

`RequestPromotion` then releases and returns `*UnavailableError{no_validator}`. Every refusal writes nothing and does not consume the ID (P4); a caller retries later with the same ID (D70 DEC:504).

The record is the authority for the head: `admit`'s append re-checks the head rule (Appendix B.2), so a parent that fails during the capture makes the admission refuse (§2.7).

### 2.6 Lineages, heads and baselines (P8)

- A **lineage** is the chain of admitted requests of one scratch from a root. Core mints its UUIDv7 `lineage_id` at the root. Checkpoints are numbered 1 at a root and the parent's plus 1 after (CORE:852 "scratch_lineage_id, checkpoint number, expected revision and parent").
- The scratch's **head** H is its latest admitted request, whichever lineage; it has **failed** if a `promotion_failed` ended it. A failure ends the whole live suffix (§2.10), so H fails whenever any later part of its lineage has.
- Kinds of request:

| Kind | Allowed when | Request names | Recorded |
|---|---|---|---|
| root | the scratch has no admitted request | `Head` and `RestartFrom` zero | new lineage, checkpoint 1 |
| successor | H exists and has not failed | `Head` = H, `RestartFrom` zero | H's lineage, H's checkpoint + 1, parent H |
| new root after failure | H has failed | `RestartFrom` = H, `Head` zero | new lineage, checkpoint 1, `restart_from` H |

  Anything else is `*HeadError{Head: H, RestartRequired: H has failed}`, before any reservation or capture (CORE:858 "skip/mismatch is refused before capture"; RC:354; CORE:860 "explicit new root request with restart_from…"; B4 DEC:670).
- **Baselines.** Eligibility baseline and delta base are separate bindings even when equal (B4 DEC:670; CON:103):
  - root: the scratch's anchor tree, F2-05's "root eligibility baseline" (CORE:854; LD:242–355);
  - successor: H's sealed tree, "even while pending" (CORE:854); this keeps already-captured new files eligible after later `.gitignore` edits;
  - new root: the scratch's represented tree, CORE:860's `last_represented_anchor`. Admission never advances `latest_represented` (CORE:858), and the outcomes that do (`accepted`, `no_change`) are ticket 08's, so in ticket 06 it is the anchor tree.
- The **physical scratch base** is the scratch's base commit, recorded separately (CORE:852; RC:327).
- Neither the scratch's index, its `HEAD` nor a foreign train predecessor ever sets eligibility (CORE:854; DEC:422).
- **Wording** (OI-21): a *request* is what the caller names; *admission* is the whole operation of reservation, seal and record (CORE:856); a request is *admitted* once its record is acknowledged (PKT:147); a *checkpoint* is an admitted request's numbered place in its lineage; its *submission* is its sealed tree with its bindings (PKT:124).

### 2.7 Admission: `admit` (P1, P16; AN2)

`admit(ctx, plan, token)` is the step after `beginRequest` that C4 will call once it has reserved a validator; C2's product never reaches it. Steps:
1. Mark `RequestID` in flight; unmark on every exit.
2. **Seal.** Build the capture scratch from the pair's scratch and the workspace's current inputs revision, as closure does, and call `engine.capture(ctx, s, baseline, token, sealCapture)` (B23 item 7; WD:137–139; capture.go:103). A refusal or error releases the token, slot included, and is returned; nothing is retained (DEC:1732).
3. **Manifest.** `PublishBody` the returned manifest; its digest must equal the result's `ManifestSHA256`, else `ErrInvalid`. On failure delete the capture ref by compare-and-swap at the sealed tree, release and return.
4. **Drafts.** Mint the lineage ID (for a root) and a pin ID with `deps.newID`, then build `[workspace.promotion_admitted, ledger.body_pin]` (Appendix B.2): actor `r.Actor`, envelope `context_id` the scratch's context, `body_refs` the manifest's digest. `deps.beforeAppend` runs here, outside the service lock.
5. **Append.** `s.append` checks Appendix B.2's rules; at append only, it also checks that the pair holds fewer than K live requests, a policy rule (§2.13).
   - A definite failure deletes the capture ref (CAS), releases the token, slot included, and returns. If the head rule refused because the parent ended during the capture, the answer is `*HeadError`.
   - An uncertain append poisons the service (B24 item 8, DEC:1842) and keeps the ref; the next Open's replay decides (§2.11).
6. **Slot.** `keepSlot`, release, and return `RequestState{State: RequestPending, …}`.

Order: Git objects, then the capture ref, then the manifest body, then the record (DEC:1738; CORE:840 "before any ledger event can reference them").

### 2.8 The train and generations: `integrate` (P9, P11)

- **The train** of a workspace is its live admitted requests in the order of their admission records, CORE:852's "durable admitted sequence" and CORE:862's "workspace durable order"; UUID time never orders it (CORE:850). A pair's FIFO is the same order restricted to that pair (CORE:195).
- **Predecessor.** The i-th live request's required predecessor is the derived commit of the (i−1)-th's current clean generation; for i = 0 it is canonical `main`, read with `rev-parse --verify --end-of-options refs/heads/main^{commit}` and `^{tree}` in the repository environment (`ErrNoCanonical` if absent). This is CORE:858's `Pi` and CORE:864's "predecessor request/generation or accepted sequence".
- **Window.** Only positions `i < GenerationWindow` get generations (CORE:862; RC:337). A request further back stays admitted without one.
- **Currency.** A request's current generation is its latest `generation_derived`. It is current while its `predecessor_commit` equals the request's required predecessor commit. Comparing commits means a predecessor accepted into `main` (ticket 08) keeps its successors' generations current, and any other predecessor change makes a new generation (CORE:864 "a changed predecessor creates a new generation … even if the tree hash coincides").
- **`integrate(ctx, workspaceID) error`** runs one call per workspace at a time; another waits within its `ctx`. It first checks the workspace's availability (`git_unavailable`, `inputs_unavailable`, `inputs_stale`, `workspace_unverified`), then loops:

```
for {
    train := live requests of the workspace in admission order; prev := main's tip
    restart := false
    for i, R in train[:min(GenerationWindow, len(train))] {
        G := R's current generation, if its predecessor_commit == prev.commit
        if G == nil { G = derive(R, over prev, supersedes R's latest generation) }  // one commit, or one commit with endings (below)
        if G.outcome == conflict {
            if i == 0 { end R as conflict, with its live local suffix (§2.10); restart = true }
            break   // i > 0: a speculative conflict; R and the requests behind it wait
        }
        prev = G.derived
    }
    if !restart { return nil }
}
```

  When a derivation at position 0 conflicts, its `generation_derived` and the endings share one commit (§3.1). A conflict generation that reaches position 0 later, once its predecessor has been accepted (ticket 08), ends R in a commit of its own. `integrate` is idempotent: a call with nothing to do records nothing. An error (Git, inputs, store) returns at once; every acknowledged commit stands, and the next call continues from the projection.
- **Derivation** of a generation for request R over predecessor P (commit, tree):
  1. Mint `generation_id` with `deps.newID`.
  2. In the **integration environment**, `git -c core.bare=true merge-tree --write-tree -z --name-only --no-messages --merge-base=<B> --end-of-options <P tree> <S>`, where B is R's delta base and S its sealed tree, with expected exits 0 and 1. The environment is the capture environment (B23 item 3; `captureEnvironment` in git.go) without `GIT_WORK_TREE` and `GIT_INDEX_FILE`: `GIT_DIR` is the current inputs revision's private Git directory, `GIT_OBJECT_DIRECTORY` the common object store, plus `GIT_ATTR_NOSYSTEM=1`, `GIT_CONFIG_NOSYSTEM=1`, `GIT_CONFIG_GLOBAL` the empty file, and the working directory `workspaces/<wdir>/tmp`. The inputs are rematerialized first, as for a capture.
     - In this environment no merge driver runs and no `.gitattributes` from the trees is read; only the pinned `info/attributes` and pinned attributes file apply (G6-M4 (ii), M5). In the repository's own environment a configured driver ran (G6-M4 (i)).
     - `core.bare=true` overrides the private configuration's `bare=false` (WD:103–105), so no working directory is taken as a work tree.
  3. `parseMergeTree(out, exit, oidLength)`. Exit 0 gives exactly `<tree OID>\0`; exit 1 gives `<tree OID>\0<path>\0…` with at least one path (G6-M9). Any other shape is an error with no partial result. The conflicted result tree is never used: Git's exit status decides, never marker text (CORE:858; G6-M1's conflicted trees carry labels).
  4. **Derived-tree check** (clean merges only): `ls-tree -r -z --name-only --full-tree --end-of-options <T>` in the repository environment, `parseNULList`, then `checkCaseCollisions` over paths and every directory prefix, as B23 item 5 does for the anchor (DEC:1717). The first colliding pair makes the outcome a conflict with cause `case_collision`. Git merges `Docs/x.txt` and `docs/y.txt` cleanly (G6-M8), and Windows cannot materialize that tree (CORE:249; B23 item 7). Entry modes need no check: every tree entering the train passed capture's mode checks or is canonical `main`, whose direct movement outside promotion is unsupported (RC:281) [INFERENCE: a merged entry takes its mode from an input].
  5. **Clean:** `git commit-tree -p <P commit> -m <message> --end-of-options <T>` in the integration environment.
     - Author and committer are `DwarfHarness Core <core@dwarf-harness.invalid>`, with both dates `<generation ID's UUIDv7 milliseconds ÷ 1000> +0000`. The message is `dwarf-harness integration`, a blank line, `request <request ID>` and `generation <generation ID>`. The commit is therefore a function of recorded values and is identical when recomputed (G6-M7; CORE:858 "deterministic recorded provenance"). If `commit-tree` refuses `--end-of-options`, the tree comes last without it; both values are already validated as hex object IDs.
     - P is the only parent (CORE:858 "Pi first-parent").
     - Create `refs/dwarf-harness/generations/<generation ID>` at the commit by compare-and-swap against the zero ID.
  6. **Conflict:** publish the conflict report (§2.9) as a body.
  7. Append the commit (§3.1). `deps.beforeAppend` runs before it. A definite failure deletes the new generation ref (CAS) and returns; a report body left unreferenced is collectable (DEC:1421). An uncertain append poisons the service.
  8. After acknowledgement, release the superseded generation's ref (§2.11).
- **"integration-rules/1"**, the `integration_rules` value, names exactly steps 2–5: the command, the environment, Git's default merge options under the pinned private configuration, the case check, and the commit's identity, date and message. Any change to them is a new rules value (CORE:864 "integration config").

### 2.9 Conflicts, visible work and disclosure (P12)

- **The conflict report** is a Core-internal body (my choice), JSON Lines like the capture manifest (DEC:1730):
  - header `{"format":"dwarf-harness/conflict-report","version":1,"cause":"merge"|"case_collision","paths":<total>}`;
  - then one `{"path":"…"}` row per path, in byte order, each once, at most `maxConflictPaths` = 10,000 rows (Core policy). The header's total says whether rows were left out.
  - Paths are as Git prints them. A path that is not valid UTF-8 makes `integrate` fail with `ErrInvalid` and record nothing [INFERENCE: it cannot occur in the supported workflow, since capture refuses non-UTF-8 names (DEC:1726) and every train tree descends from captured or canonical trees].
- **Visible work** (T06:31; RC:323; D77 DEC:558 "Surface integration conflicts without automatic semantic resolution"). A conflict at position 0 is against canonical `main`, so it is final and its report may be released (CORE:882). The request ends `conflict`, and its `RequestState` carries the report's digest for the original context to read through C3's authorized body reads (DEC:1493). Nothing is substituted or resolved: no generation commit or ref exists for a conflict.
- **Speculative conflicts** (CORE:860 "A speculative failure is not terminal until predecessor dependencies resolve"). A conflict over a live predecessor is recorded as a generation with outcome `conflict` and its report, and the request stays pending. The report stays host-private: no `RequestState` of a live request carries generation, predecessor, queue or report detail (CORE:880). When the predecessor leaves, the request is rebuilt (§2.10); when the predecessor is accepted (ticket 08), the same generation becomes position 0's and ends the request.
- Visibility states (CORE:878) live in the records, with no state store: a generation is *sealed* while its request is live; it is *audit_only_obsolete* once superseded or once its request ends; *eligible* and *released* follow acceptance and C4's BD2 (RC:524), apart from the terminal conflict report above.

### 2.10 Local failure and foreign removal (P13)

- **Local failure** (CORE:860; B4 DEC:670; CON:101; T06:30). When request R ends with any `promotion_failed` outcome, every live request of R's lineage with a larger checkpoint ends `dependency_failed`, naming R, in the same commit; the commit also carries each ended request's `ledger.body_unpin` (§3.1).
  - After acknowledgement, `freeSlot` runs once per ended request and refs are released (§2.11).
  - No ended request ever gets another generation. Rebuilding a child without its parent's change, or from `M`, never happens: its delta base is its parent's sealed tree, bound at admission.
  - "Stop all children and prove exit" has nothing to do in C2: no child process exists, and C4's runner adds the proof before slot release (CORE:856, :860; RC:409).
- **Ticket 06's causes.** Only `conflict` at position 0 and the `dependency_failed` it cascades. The cancelled, interrupted and rejected causes of CORE:860 come from tickets 08 and C4 through the same ending path (OI-10).
- **Foreign removal** (CORE:860; B5 DEC:678; RC:357). When requests leave the train, every surviving request in the window whose required predecessor changed gets a new generation that supersedes its current one, in the same `integrate` call. It is never ended: a removal is not a lineage failure (B4 DEC:671). "Rerun the complete gate" falls to C4, since a new generation carries no evidence (CORE:874).

### 2.11 Retention, release and the record-aware sweep (P15; AN1)

- **Capture refs** (`refs/dwarf-harness/captures/<capture ID>`, DEC:1735–1736). Request R's ref is retained while any of these holds:
  (a) R is live;
  (b) a live request names R as its parent, whose delta base R's tree is;
  (c) R is its scratch's head, the head has not failed and the scratch is open, so a future successor's baseline is R's tree.
  In ticket 06, (b) and (c) are implied by (a), because no request ends successfully. They are stated now so that ticket 08's success endings keep the right trees (OI-15).
- **Generation refs** (`refs/dwarf-harness/generations/<generation ID>`) are retained while the generation is the current clean generation of a live request (OI-12). An integration commit's predecessors stay reachable through its first-parent chain.
- **Release.** After the commit that ends a request or supersedes a generation is acknowledged, the service deletes, by compare-and-swap against the recorded object, every capture or generation ref that the rules above no longer retain. The record comes first and the effect second, as closure does (B24 item 7). A failed deletion is left for Open.
- **Open's sweep** (AN1). In each usable workspace (B24 item 9, DEC:1843–1849), Open lists `refs/dwarf-harness/captures/` and `refs/dwarf-harness/generations/` once each.
  - It deletes every listed ref that the replayed records do not retain, by compare-and-swap against the listed value. These are seals whose admission never committed, releases a crash interrupted, and generations whose record never committed.
  - It recreates a retained ref that is missing at its recorded object, by compare-and-swap against the zero ID. If that fails because the object is gone, it adds `capture_missing <request ID>` or `generation_missing <generation ID>` to `Pending`. A retained ref that points elsewhere is never overwritten (`Pending`).
  - Open's sweep writes no record and reads no clock (DEC:1844).
- **In-flight seals** (OI-16). None exists while Open runs: the service serves no call before Open returns, and one service runs per colony (DEC:1809). An uncertain admission poisons the service and keeps its ref until the next Open, whose replay finds the record or not (DEC:1842).
- `TestOpenReconciles`' subtest `capture_owner_retains_ref` (service_test.go:162–178) asserted that Open touches no capture ref. Ticket 06 replaces that contract (DEC:1849, :1871; AN1), so the subtest is deleted and §4's sweep tests take its place.

### 2.12 Closure (P17)

- `CloseScratch` answers `ErrLiveRequests` while the scratch has a live request: nothing is observed, recorded or removed. A dedicated scratch is "retained through explicit closure and outcome resolution" (RC:303), and withdrawing a live request takes D57's separate cancellation (ticket 08). This check comes after authority and before the exclusion (B24 item 7).
- Otherwise closure is unchanged (B24 item 7): it observes against the anchor tree, the represented tree in ticket 06 (WD:296; BR:363 expected sealed submissions to count, but CORE:858 has admission advance only `latest_admitted`). After its record and removal, it releases the scratch's refs that §2.11 no longer retains; in ticket 06 there are none, and Open completes any left.
- New record rule (Appendix B.5): no `workspace.scratch_closed` while the scratch has a live request.

### 2.13 Open and replay (P18)

- Consumption gains the three F2-06 types at version 1. One rule set (B24 item 3, DEC:1817) checks every Appendix B rule on the service's drafts and on every replayed record; a replayed break fails Open with `*InconsistentError` naming the sequence.
- **Policy, not record rules.** The pair's K bound is checked on append only, never at replay, so that Open never fails because a valid log exceeds a bound since lowered (the pin-bound precedent, DEC:1446). The generation window is `integrate`'s policy and no record rule at all.
- **Rebuilt projection:** each admitted request (bindings, lineage, checkpoint, sealed tree, capture ID, pin, state, ending), each scratch's head and failure, each workspace's train, and each live request's generations. Terminal requests drop their generations (§2.17). `setLive` restores the K-slot counts.
- **Open executes nothing.** It captures, merges, integrates and records nothing; it reads no clock (CORE:862 "D55 replay never restarts capture, validation or submission"; SPEC:395 "Rebuilding state never dispatches work"). Live requests stay live with their slots, refs and generations.
- D55's rule that queued requests proven not to have promoted end `interrupted` after a crash (DEC:371; RC:321, :347) is ticket 08's crash reconciliation (T08:12, :30), designed with intents (P18). C2's product admits nothing, so no product slot can be stranded meanwhile.

### 2.14 Errors

New, each wrapping exactly one sentinel as now (errors.go):
- `ErrRequestMismatch` ("workspace: request ID already used for a different request"; D58);
- `ErrStaleHead` with `type HeadError struct{ Head uuid.UUID; RestartRequired bool }`. `Head` is the scratch's head (zero if none); `RestartRequired` reports that the head failed and a new root must name it. The context learns only its own lineage's head;
- `ErrLiveRequests` ("workspace: scratch has live promotion requests");
- busy reasons `checkpoint_slots` and `request_in_flight`.

Unchanged: `ErrNoCanonical` for a missing `main` in `integrate`; `*UnavailableError` reasons; `*RefusalError` for capture refusals, which leave the request not admitted (OI-14).

### 2.15 Loose objects (P19; AN3)

- **Decision: Core runs no repository maintenance in ticket 06**, neither `gc`, `prune` nor `repack`. The policy is revisited at C4's capacity gate with this ticket's measurements. Reasons:
  - B23 item 8 scopes Core's Git writes to `refs/dwarf-harness/`, its scratch branches and worktrees (DEC:1735); repacking or pruning the owner's whole object store is a repository-wide effect no source authorizes.
  - Retention refs keep every tree Core still needs through `gc --prune=now` (B23 G1-R7). An object Core stops retaining, a released checkpoint or an observe's blobs, is ordinary unreachable data that Git's own automatic maintenance reclaims after its expiry [INFERENCE: Git runs `gc --auto` after porcelain commands, which the owner and agents run in their worktrees of the shared repository].
  - In C2's product only closure observes create such objects (DEC:1790); the volume that may need a policy arrives with C4's admissions, and disk cost is a measurement gate (RC:410, :414).
- **Measurement.** The harness (§4, S3) records `git count-objects -v`'s loose count and size before and after each admission and integration phase, so C4's gate can calibrate.

### 2.16 Windows

- **Line endings.** Integration works on blobs, Git's canonical form; under the pinned `core.autocrlf=true` a scratch's CRLF files are captured as LF blobs (B23 item 7) and merge without conversion. `merge.renormalize` and `autocrlf` change nothing for LF blobs (G6-M6).
- **Case.** The derived-tree check refuses case-only collisions on every platform (§2.8 step 4; G6-M8; CORE:249).
- **Refs** under `refs/dwarf-harness/` use lowercase UUIDs; short paths, no case clash.
- Defender stays on and nothing is excluded (RC:377).

### 2.17 Performance (D78; DEC:571–574)

- **Assumption.** B15's 12 or 20 code-working pairs, each offering one change per 600 s, with a synchronized burst of four checkpoints per pair (RC:337; DEC:766). The owner's larger population is 60 (DEC:1474).
- **Admission slots** (calculation). K × N: 48, 80 and 240 slots at 12, 20 and 60 pairs (CORE:852).
- **Admission cost** (measurement plus calculation). One seal: 0.659 s at 1,000 files and 3.01 s at 10,000 after ten edits; a fresh observe 9.94 s and 84.7 s (A.11, CORE:1355–1400). Then one manifest publication and one append, 3.24/4.93 ms p50/p99 at 12 contexts (DEC:1468).
  - A pair's checkpoints are serial: each names the previous head, and a capture holds the scratch exclusively with no queue (D70). A pair's burst is therefore four seals in a row.
  - Pairs capture in parallel up to `BytesInFlight ÷ MaxBytes` = 20 (calculation, B23 item 10). A fully synchronized first capture across 60 pairs would see 40 `capture_budget` answers (calculation). Concurrent cost is C4's feasibility gate (RC:973), where the provisional profile is recalibrated.
- **Integration** (measurement plus calculation). `git merge-tree --write-tree` took 0.09–0.15 s (CORE:222, :1098; one 2026-10-02 run). A derivation adds a tree listing, `commit-tree`, `update-ref` and an append. A removal at position 0 rebuilds at most `GenerationWindow` = 4 generations per workspace. The harness measures both (V11).
- **Records** (calculation). Per checkpoint in ticket 06: 2 at admission (record and pin), at least 1 per derivation, and 2 at a failure (ending and unpin): about 5, plus one per rebuild. At six changes per pair-hour that is 30–36 per pair-hour, under 4% of B21's assumed 960 records per context-hour (DEC:1462).
- **Manifest bodies** (calculation). About 220 bytes per file (BR:979), so about 2.2 MB per admission at 10,000 files: 13 MB per pair-hour, or 264 MB per hour at 20 pairs. Pins hold at most K per pair: 176 MB at 20 pairs and 528 MB at 60. Unpinned manifests stay until the owner's explicit collection (DEC:1421; CORE:840). Identical manifests are stored once.
- **Memory** (calculation). About 200 B per request, kept for life for D58 replay, and about 250 B per live generation, dropped when its request ends. At 120 admissions an hour, about 24 KB an hour and 210 MB a year at 20 pairs, every change admitted. This is growth with history like B24's projections (DEC:1886); a cold lookup waits for a measured trigger (B3 DEC:660; CORE:842). C2's product adds none (P20).
- **Plan.** The harness phases of §4 run once on the owner's machine (V11), with no threshold, and are recorded as Core Appendix A.12. Burst concurrency and disk under load remain C4's gate (RC:410, :414, :973).

### 2.18 Each criterion while C2 refuses

| Criterion (T06) | Through the product (`RequestPromotion`, Open, `CloseScratch`) | Through the mechanism (`beginRequest` + `admit`, `integrate`; disposable repositories) |
|---|---|---|
| :28 K=4 FIFO per declared pair; capacity scales; fifth busy before capture | after four mechanism admissions, the product's fifth request answers `checkpoint_slots` with no snapshot; other pairs still reach `no_validator`; slots survive Open | four admissions per pair across pairs and workspaces; FIFO = admission order in the train |
| :29 same-ID replay without recapture; local head; independent identities | replay of an admitted ID returns its state while the scratch is busy and after a restart; changed bindings give `ErrRequestMismatch`; stale or skipped heads give `*HeadError`; all before capture | distinct request, capture, lineage, generation and predecessor identities in the records; a rebuild gets a new generation ID; attempts are C4's (P14) |
| :30 local sealed parent for eligibility and delta; local failure ends the suffix; foreign removal rebuilds | — | successor captures against the parent's tree; a conflict at position 0 ends the suffix; a foreign removal supersedes survivors' generations |
| :31 explicit new root; old IDs never reopen; conflict is visible work | the replayed state of ended IDs; `*HeadError{RestartRequired}` | `restart_from` admissions; the conflict report released on the terminal state |

Canonical movement, which only ticket 08's acceptance performs, is simulated in tests by `update-ref` on `main` in disposable repositories (P23; RC:289).

---

## 3. Records and F2

**3.1 What ticket 06 writes** (Appendix B):

| Operation | One commit holding | Actor |
|---|---|---|
| `admit` | `workspace.promotion_admitted`, `ledger.body_pin` (the manifest) | owner or agent |
| `integrate`, a derivation | `workspace.generation_derived` | core |
| `integrate`, a conflict at position 0 | `generation_derived` (conflict), `promotion_failed` (conflict), `promotion_failed` (`dependency_failed`) for each live successor in checkpoint order, then one `ledger.body_unpin` per ended request, in the same order | core |
| `integrate`, an existing conflict generation reaching position 0 (after ticket 08's acceptance) | `promotion_failed` records and unpins as above | core |

`RequestPromotion`, replays, refusals, Open and refused closures write nothing (P4). F2-05's records are written as before.

**3.2 What it consumes:** `Append`, `ledger.body_pin` and `ledger.body_unpin` (F0, CON:54–55); `OpenReader`; Core's `PublishBody` and `ReadBody` (B21 items 4–5); F2-05's four types (D115).

**3.3 F2 parts:** F2-05 is frozen (D115). **F2-06**, this ticket's part: `workspace.promotion_admitted`, `workspace.generation_derived`, `workspace.promotion_failed` at version 1 (BR:489 "Ticket 06: requests, submissions, admission, generations and attempts"; DEC:1650). The `workspace.` namespace is already reserved (DEC:1678). Later parts add finalization, acceptance, success endings and cancellation (08), temporary-scratch provenance and merge-back (07), and activation (09), by addition.

**3.4 What may start before the F2-06 freeze** (D113 DEC:1646–1647):
- S1 writes no record. It may start after OG-A6 and reach `main` after review and the full check (D116 item 5, DEC:1905).
- S2 is drafted after OG-A6 for the freeze packet and reaches `main` only with the freeze (D41; D116 item 3).
- S3, the producer, starts only after the freeze.

**3.5 Producer rules.** Only `internal/core/workspace` appends F2-06 types, through `appender.Appender`; review enforces this, as for F2-05 (LD:242–355; DEC:1683). The service checks every Appendix B rule when it appends and at Open (§2.13).

---

## 4. Tests

**General.**
- Tests come before code (RC:15). Real Git in disposable repositories under `t.TempDir()`; a missing or older Git fails them (DEC:1704). No Git mock, no validator stub (D52; RU:14).
- A real `ledgerstore` store for every service test (SPEC:587); no mocks.
- Expected trees are computed independently, by plain Git in a reference repository or worktree, never from Core's output.
- Canonical movement is a test helper, `advanceMain`, which writes a commit through a private index and `update-ref refs/heads/main <new> <old>` without checking `main` out (D48; P23).
- `mustAdmit` is `beginRequest` followed by `admit`, exactly the path C4 will call.
- Side-effect assertions reuse `snapshotCaptureSideEffects` (helpers_test.go), extended to generation refs and the log's durable sequence.
- Each test names the plausible bug it catches.

### S1 — record-free mechanics

**reserve_test.go**
- **`TestCapacityProfileRefusals`** (renames `TestCaptureProfileRefusals`): `CheckpointsPerPair` or `GenerationWindow` below 1, and the old rows, give `ErrInvalid`. *Bug: K of 0 accepted, making every request busy forever.*
- **`TestCheckpointSlotsPerPair`.** With K = 4: four admission reservations on scratch A, each kept and released, succeed. The fifth gives `*BusyError{checkpoint_slots}` and leaves the exclusion free (a `BeginWrite` proceeds) and the pool's bytes unchanged. Scratch B still reserves, and after `freeSlot(A)` the next A reservation succeeds. *Bug: a workspace or colony cap instead of per pair; partial acquisition; a slot never freed.*
- **`TestSlotReturnedUnlessKept`.** Released without `keepSlot`, the slot returns; after `keepSlot`, release returns exclusion and bytes but the slot stays until `freeSlot`; a second release after `keepSlot` frees nothing. *Bug: slot leak on refusal; K overrun after release; double decrement.*
- **`TestConcurrentAdmissionReservations`** (`-race`): 16 goroutines reserve, keep and release on one scratch with K = 4. At most four slots are ever live, and every loser gets `scratch_busy` or `checkpoint_slots` at once. *Bug: check-then-take race.*

**gitparse_test.go**
- **`TestParseGitVersion`** rows: `2.44.9` refused, `2.45.0` accepted, the others as before. *Bug: tree merges failing on 2.42–2.44 as `*GitError` instead of a clear `ErrGitUnavailable`.*
- **`TestParseMergeTree`.** Rows built from G6-M9's exact bytes: clean exit 0; one and two conflicted paths with exit 1. Malformed inputs (missing NUL, empty path, wrong object-ID length, exit 0 with paths, exit 1 without, a repeated path) each give an error with no result. *Bug: splitting on newlines; treating exit 1 as a failure; partial lists.*

**fuzz_test.go**
- **`FuzzParseMergeTree`**: no panic; malformed input returns no paths; well-formed output round-trips.
- **`FuzzParseGitVersion`** is fuzzed again, because its floor changes (D116 item 6).

**integrate_test.go**
- **`TestMergeTreesUsesDeltaBase`.** Lineage S1 = M+a, S2 = M+a+b; foreign predecessor P = M+a+f, where f rewrites the line a changed. `mergeTrees(B = S1, P, S2)` is clean and equals the reference M+a+f+b. *Bug: the anchor or P's history as merge base, which conflicts here, or resubmits a.*
- **`TestMergeTreesConflictByExitStatus`.** Conflicting edits give a conflict with exactly Git's paths in byte order and no commit. A file whose content holds literal `<<<<<<<` lines merges clean. *Bug: deciding by marker text.*
- **`TestIntegrationEnvironment`.** The workspace's `.git/config` defines `merge.evil.driver`, which writes a marker file, and the trees' `.gitattributes` say `*.txt merge=evil`, then `*.txt merge=union`. Core's merge runs no driver (no marker) and reports both as conflicts. A pinned global attributes file with `*.txt merge=binary` makes two non-overlapping edits a conflict, so the pinned inputs apply. *Bug: merging in the repository environment (G6-M4 (i)) or ignoring the pinned inputs.*
- **`TestDerivedTreeCaseCollision`** (every OS): `Docs/x.txt` against `docs/y.txt` gives a conflict with cause `case_collision` naming both paths. *Bug: an unmaterializable tree accepted (G6-M8).*
- **`TestIntegrationCommit`.** The commit has P as its only parent, the derived tree, Core's identity, the date from the generation ID's time, and a message naming request and generation. Recomputing gives the same ID; another generation ID gives another commit. Host `user.*` or `commit.gpgSign` settings change nothing. *Bug: wall clock or host configuration in commits.*
- **`TestIntegrationLineEndingNeutral`.** Under pinned `autocrlf=true`, a submission captured from CRLF files merges with an LF predecessor; the derived blobs are LF and there is no conflict. *Bug: conversion or renormalization during integration.*
- **`TestConflictReport`.** Header fields; rows unique and in byte order; at `maxConflictPaths` + 1 paths, 10,000 rows and a total of 10,001. *Bug: unsorted or duplicated rows; truncation without a count.*

**capture_test.go, capture_posix_test.go** (P24)
- **`TestCaptureInvalidModeKeepsToken`.** An invalid mode returns `ErrInvalid`, and the same token then seals. *Bug: a programming error burns the caller's reservation.*
- **`TestUnreadableDirectoryPathIsRelative`** (Linux and macOS; it runs in C3's CI, DEC:1704): a directory without read permission gives `unreadable` whose `Path` is the repository-relative name. *Bug: the absolute host path leaks into refusals.*

### S2 — `contract/ledger`

- **`TestGoldenF2_06`.** Builds `testdata/f2/06/log/00000000000000000001.jsonl` (Appendix B.7) with `EncodeCommit` and the encoders, compares byte for byte, and accepts `-update`.
- **`TestGoldenDecodes`** also decodes every record of the new golden with its type's decoder.
- **`TestF2_06PayloadsRoundTrip`.** Encode, decode and encode again give identical bytes, for 40- and 64-digit Git IDs, with optional keys present and absent, unknown keys ignored, and unknown `outcome` tokens of `promotion_failed` preserved.
- **`TestF2_06PayloadsRefuse`.** One row per key rule of Appendix B: missing, null and repeated keys; non-v7 IDs; zero digests; bad Git IDs; checkpoint 0, signed or fractional; a parent with checkpoint 1 or none with checkpoint 2; `restart_from` with a parent; clean without derived IDs or conflict with them; a predecessor request without its generation; a generation outcome other than `clean` or `conflict`; malformed tokens and rules strings. *Bug: a decoder that admits malformed payloads into replay.*
- **`TestNewCatalogue`** (extended): `Defined()` lists the eleven type versions; the namespace rules are unchanged.
- **`FuzzDecodeF2_06`**: decode, encode and decode again are stable; no panic. `FuzzCheckTruncation`'s seeds gain the new golden, and its seed corpus runs in the check.
- V8 shows the F0 and F2-05 goldens unchanged.

### S3 — the service

**promote_test.go, request_test.go**
- **`TestRequestPromotionUnavailableInC2`** (replaces `TestRequestPromotionIsUnavailable`). A valid root request answers `no_validator`. Objects, capture and generation refs, `tmp/` and the log are unchanged, and no slot is held: an identical request also reaches `no_validator`. *Bug: the product admits, captures or leaks a slot.*
- **`TestFourCheckpointsThenBusy`** (scenario 1, RC:353). Admit R1–R4 (M+a, M+a+b, M+a+b+c, M+a+b+c+d). Each record has its own request, capture and lineage position (checkpoints 1–4, each parent the previous). A fifth distinct request through `RequestPromotion` answers `checkpoint_slots`, with objects, refs, `tmp/` and log unchanged. *Bug: coalescing; a fifth snapshot; K miscounted.*
- **`TestIdenticalContentStaysDistinct`.** A successor with no scratch change is admitted under its own IDs with the same sealed tree. *Bug: content-based coalescing (D58).*
- **`TestCapacityScalesWithPairs`.** Three pairs in W1 and one in W2 each admit four (16 live); each pair's fifth is busy. *Bug: a workspace or colony cap (T06:28).*
- **`TestSameIDReplayDoesNotRecapture`** (scenario 2, RC:354). Admit R1; edit the scratch; hold a `BeginWrite` lease. `RequestPromotion` with R1's ID and bindings returns R1's state (pending, its sealed tree, checkpoint 1) at once, with no new object, ref or record. After `Close` and reopen, the same. *Bug: replay recaptures, blocks on busy, or is lost at restart.*
- **`TestSameIDMismatch`.** The same ID with another context, workspace, head or `RestartFrom` gives `ErrRequestMismatch` and captures nothing; the same bindings stated by the owner instead of the agent return the state. *Bug: mismatch accepted, or the actor treated as a binding.*
- **`TestHeadChecks`.** With R1 and R2 admitted: naming R1 (stale), an unknown ID (skip), a root while R2 is pending, or `RestartFrom` while nothing has failed each give `*HeadError{Head: R2}` before capture. *Bug: a forked lineage.*
- **`TestRequestInFlightIsBusy`.** While an admission of ID X is held in `beforeAppend`, a second request with X answers `request_in_flight` without capturing. *Bug: a duplicate capture under one ID.*

**admit_test.go**
- **`TestSuccessorEligibilityFromParentTree`** (CORE:854). R1 captures a new untracked `n.txt`. Then `.gitignore` gains `n.txt` and `n.txt` changes. R2's submission holds the change, whereas an anchor-based capture of the same scratch would leave `n.txt` out. *Bug: a successor baseline from the anchor or the index.*
- **`TestForeignPredecessorNeverSetsEligibility`.** Pair B's admitted submission adds `y.txt`; pair A's scratch holds an ignored untracked `y.txt`. A's successor leaves `y.txt` out. *Bug: the train predecessor used as baseline.*
- **`TestParentFailureDuringCaptureRefused`.** In a one-shot `beforeAppend` of R3's admission, `advanceMain` and `integrate` end R2's lineage. R3's append is refused with `*HeadError{RestartRequired: true}`; its capture ref is gone, its slot free, and no record written. *Bug: a successor admitted under a failed parent.*
- **`TestAdmissionFailureRollsBack`.** With K = 1, `beforeAppend` deletes the published manifest's body file, so the store refuses the commit (`ErrBodyUnpublished`, a definite failure). The capture ref is gone, no record is written, and the next request for the pair reaches `no_validator` instead of `checkpoint_slots`. *Bug: leaked ref or slot.*
- **`TestConcurrentRequestsOnePair`** (`-race`): eight concurrent `mustAdmit` calls with distinct IDs, each naming the head it read. The lineage never forks (one child per checkpoint), at most K requests are live, and the losers answer busy or `*HeadError`. Concurrent calls with one ID make one admission; the others answer busy or the replayed state. *Bug: a fork, a duplicate admission, or K overrun.*

**train_test.go**
- **`TestIncrementalCandidatesOverForeignPredecessor`** (scenario 3, RC:355). Train A1 (a), B1 (f), A2 (b, child of A1). Generations are M+a, M+a+f and M+a+f+b. The diff from B1's generation to A2's is exactly b, and A2's delta base is A1's sealed tree. A second `integrate` records nothing. *Bug: resubmitting a, losing f, or rebuilding needlessly.*
- **`TestLocalParentFailureEndsSuffix`** (scenario 4, RC:356). Pair A's R1–R4 are admitted; `advanceMain` adds a change conflicting with a; `integrate` runs.
  - R1 ends `conflict` at position 0, and R2–R4 end `dependency_failed` naming R1, in the same commit, which unpins their manifests.
  - No generation of R2–R4 ever appears; their slots are free; their capture refs are gone, and `gc --prune=now` removes blobs only they held.
  - Replaying R3's ID returns `dependency_failed`.
  - *Bug: the suffix rebased from M (resurrecting a), left live, or leaking slots and refs.*
- **`TestForeignRemovalRebuildsSurvivors`** (scenario 5, RC:357). Train B0, B1 (pair B's lineage), then A1. `advanceMain` conflicts with B0. B0 ends `conflict` and B1 `dependency_failed`. A1's generation is superseded by one over the new `main` without B's changes; A1 stays pending, never `dependency_failed`; the superseded generation's ref is released. *Bug: foreign removal treated as local failure, or a survivor keeping withdrawn changes.*
- **`TestSpeculativeConflictWaits`.** Train B1 (clean), A1 (conflicts with B1's change), A2 (A1's child).
  - A1 stays pending with a conflict generation; its `RequestState` carries no report, and A2 gets no generation.
  - `advanceMain` then conflicts with B1: B1 ends `conflict`, A1 is rebuilt over `main` cleanly, and A2 is derived.
  - *Bug: a speculative conflict made terminal, or its diagnostics disclosed early (CORE:860, :880).*
- **`TestConflictIsVisibleWork`** (T06:31). A conflict at position 0: the replayed state is `conflict` with the report's digest; the body lists exactly Git's conflicted paths, cause `merge`; no generation commit or ref exists. *Bug: silent substitution or resolution; missing paths.*
- **`TestNewRootAfterFailure`** (T06:31; RC:356). After the failure of `TestLocalParentFailureEndsSuffix`:
  - a successor naming R4 gives `*HeadError{RestartRequired: true}`, as do a root without `RestartFrom` and `RestartFrom` = R2 (not the head);
  - `RestartFrom` = R4 under a new ID is admitted: new lineage, checkpoint 1, baseline and delta base the anchor tree, `restart_from` R4;
  - with a reverted in the scratch, its generation over `main` lacks a;
  - replays of R1–R4 return their endings, and no generation of theirs ever appears.
  - *Bug: old IDs reopened; a new root built on failed sealed trees.*
- **`TestWindowBoundsGenerations`.** Six live requests in one workspace with `GenerationWindow` = 4: only the first four have generations. When the first ends, the fifth gets one, and no other generation changes. *Bug: unbounded speculative preparation (CORE:862).*

**service_test.go, replay_test.go, scratch_test.go**
- **`TestOpenSweepsUnownedRefs`** (AN1):
  - a seal whose admitting process was killed before its append (a child process, as `TestOpenReconciles` does) has its capture ref deleted by the next Open;
  - an admission's capture ref survives Open;
  - a release that failed (the ref deleted and recreated by hand after the ending) is completed by Open, as is a generation ref with no record.
  - *Bug: Open strips admitted retention (the S3 review's finding, DEC:1849) or leaks refs.*
- **`TestOpenRestoresRetainedRefs`.** A live request's capture ref and a current generation ref deleted by hand come back at the next Open. With their objects pruned, `Pending` names them and the request stays pending. *Bug: retention lost to tampering, or a restored ref at the wrong object.*
- **`TestOpenRebuildsAdmissionState`.** After admissions and integration, reopen: the fifth request is still busy; a stale head is still refused; `integrate` records nothing new. Open adds no objects and no records. *Bug: slots lost at restart, or work re-executed in replay (SPEC:395).*
- **`TestOpenFailsClosedOnF2_06RuleBreak`** (rows, like `TestOpenFailsClosedOnRuleBreak`). Each log fails Open with `ErrInconsistent` at the breaking record's sequence:
  - admissions: a duplicate `request_id`; a stale parent; checkpoint not the parent's + 1; a root while the head is live; `restart_from` not the failed head; a baseline other than the parent's sealed tree; a scratch other than the pair's open one; a missing or mismatched pin;
  - generations: one for an ended request; a predecessor other than the nearest live request ahead; `supersedes` other than the current generation; a supersession with an unchanged predecessor;
  - endings: a conflict ending with a live request ahead or for a clean generation; `dependency_failed` naming a request that has not failed or comes later; a failure commit leaving a live suffix; a missing unpin;
  - a `scratch_closed` while a request is live; wrong actors or envelope contexts.
  - *Bug: replay trusting a buggy or foreign writer (B21 item 10).*
- **`TestCloseScratchWhileRequestsLive`.** `CloseScratch` gives `ErrLiveRequests` and records and removes nothing. Once the requests have ended, closure succeeds and leaves no capture ref of the scratch. *Bug: closure discarding a live submission's scratch.*

**workload_test.go** (measurement, P19, V11). `TestCaptureWorkload` gains service-level phases at 1,000 and 10,000 files: `admit_root` (seal, manifest, commit), `admit_successor` after ten edits, `integrate_two` (two generations over `main`) and `rebuild_two` (after `advanceMain`). Each row adds `manifest_bytes`, plus `loose_objects` and `loose_kib` from `count-objects -v`. The same opt-in variable applies, it skips under `-race`, and it sets no threshold.

**Windows-specific cases:** `TestDerivedTreeCaseCollision`, `TestIntegrationLineEndingNeutral` and the held-file and junction rows of ticket 05's suites, which must keep passing.

### Deliberately left out
- A Git mock or a validator stub (SPEC:587; D52).
- Assertions on Git's message text, or on the order among several refusal or busy reasons beyond CORE:856's listing (RU:62).
- Wiring tests, such as "RequestPromotion calls beginRequest" (SPEC:587).
- K or window values other than the provisional four, except where a smaller bound isolates a rollback path.

---

## 5. Verification (D116 item 6, DEC:1906)

Run in PowerShell from the worktree root, with `$env:GOTOOLCHAIN='local'; $env:GOFLAGS=''` set first (AGENTS:40). **The coder** runs V1 or V2 for the package touched, and V3's targets briefly, before handing over. **The PM** runs the evidence script on the exact commit, in a separate worktree, before the advisor's one review: the slice's V-runs, the race repetitions, 120 s fuzzing of new or changed targets only, and one full check (V4).

| # | Command | Expected |
|---|---|---|
| V1 | `$env:CGO_ENABLED='0'; go test -count=1 ./internal/core/workspace` | `ok` |
| V2 | `$env:CGO_ENABLED='0'; go test -count=1 ./contract/ledger ./internal/core/ledgerstore` | `ok` |
| V3 | for each new or changed fuzz target T: `$env:CGO_ENABLED='0'; go test <pkg> -run '^$' -fuzz "^$T$" -fuzztime 120s` (S1: `FuzzParseMergeTree`, `FuzzParseGitVersion`; S2: `FuzzDecodeF2_06`) | `PASS`; `git status --porcelain -- <pkg>/testdata` empty, unless a fixed crasher is kept as a seed |
| V4 | `go run ./tools/check` with `DWARF_CC` set (AGENTS:35) | all nine steps pass |
| V5 | `$env:CGO_ENABLED='1'; $env:CC=$env:DWARF_CC; go test -race -count=20 -run '<slice set>' ./internal/core/workspace`; S1: `'Slot|Pool|Busy|Waits|Released|ConcurrentAdmission'`; S3: `'Concurrent|InFlight|Replay|Busy|Poison|OnePerPair'` | `ok` |
| V6 | `go list -f '{{join .Imports "\n"}}' ./internal/core/workspace`; `go list -deps -f '{{if not .Standard}}{{.ImportPath}}{{end}}' ./contract/ledger` | the four admitted imports only; only `contract/ledger` itself |
| V7 | `go mod tidy`, then `git diff --exit-code -- go.mod go.sum` | no change (D29) |
| V8 | `go test ./contract/ledger -run '^TestGolden' -update`, then `git status --porcelain -- contract/ledger/testdata`; `Get-FileHash -Algorithm SHA256` over the F0 goldens and the F2-05 golden | nothing changed; digests equal D111's (DEC:1521) and D115's (DEC:1681) |
| V9 | `git ls-files --eol -- contract/ledger/testdata/f2/06` | `i/lf w/lf` |
| V10 | `git version`; `(Get-MpComputerStatus).RealTimeProtectionEnabled` | 2.45 or later, recorded; `True` |
| V11 | `$env:CGO_ENABLED='0'; $env:DWARF_CAPTURE_WORKLOAD_OUT='<dir outside the repo>\t06-workload.jsonl'; go test -count=1 -timeout=45m -run '^TestCaptureWorkload$' ./internal/core/workspace` | a results file; no pass mark |
| V12 | `$env:CGO_ENABLED='0'; foreach ($o in 'linux','darwin') { $env:GOOS=$o; go vet ./internal/core/workspace ./contract/ledger }` | no finding |

**Per slice:** S1: V1, V3 (S1), V5 (S1), V6, V7, V10, V12, V4. S2: V2, V3 (S2), V6, V7, V8, V9, V12, V4. S3: V1, V5 (S3), V7, V11 (once, by the PM, on the owner's machine), V12, V4. Every slice: one full check (V4) on the exact commit that reaches `main` (D46; D116 item 6).

---

## 6. Slicing

| Slice | Content | May start | Reaches `main` |
|---|---|---|---|
| S1 | profile and K-slot, Git floor, integration primitives with parser and fuzz target, S1b nits | after OG-A6 | after the advisor's review on evidence and V4: a routine merge (D116 item 5, DEC:1905), since it touches no frozen contract, owner decision or dependency once OG-A6 approves the floor; record-free code may precede the freeze (D113 DEC:1647) |
| S2 | F2-06 draft in `contract/ledger`; CONTRACTS.md's F2-06 table | after OG-A6 | only with the owner's F2-06 freeze, together with its decision entry, register change and UC notes (D41; D113; D116 item 3) |
| S3 | the service writing F2-06; closure rule; Open's sweep; harness phases | after the freeze, with S1 and S2 on `main` | after review on evidence and V4: routine (D116 item 5); it writes F2-06 as frozen |
| Close | ticket file, brief and ruling, owner's answers, B«next», A.12, C2's status line and board | after S3 | one documents commit (D116 items 3–4) |

- **Size.** If the advisor prefers smaller steps, S1 splits into S1a (profile, K-slot, floor, nits) and S1b (integration primitives).
- **Commits:** Conventional Commits with the package as scope (AGENTS:36): `feat(workspace): …`, `feat(ledger): …`, `docs: …`.
- **Closing:** ticket 06 closes when S3 and the documents commit are on `main`; C2 stays In progress with tickets 07–09 to come.

---

## 7. Design choices and owner gates

### 7.1 Design choices

Each choice lists the options, the recommendation and its sources. "→ §" points to the behavior it fixes.

**P1. How the criteria are exercised while C2 refuses** (OI-1; → §2.1, §2.18).
- (a) **Shared pre-capture path.** `beginRequest` serves both `RequestPromotion`, which ends in the unconditional `no_validator`, and the unexported mechanism (`admit`, `integrate`). Package tests drive the mechanism in disposable repositories and probe the product after it; C4 calls `admit` once its validator is reserved.
- (b) A test-only validator or capture-only command: D52's forbidden permissive validator or bypass (DEC:342) and RU:14's refused seam.
- (c) Defer admission to C4: contradicts T06:28–31 and RC:407 ("dedup/admission, local-parent failure suffix, foreign-predecessor rebuild, conflict").
- **Recommend (a).** PKT:141 and :272 ("mechanical tests in disposable repositories"); RC:289; RU:14 (P2's ruling: mechanism tests drive seal; `no_validator` unconditional); B23 item 1 (DEC:1699). Ticket 05's seal mode was unreachable from the product on the same terms (DEC:1849 "Ticket 05's product never seals").

**P2. Request identity and fingerprint** (OI-4, OI-5; → §2.5).
- (a) `request_id` is a key of the admission record. The service's projection deduplicates, and the fingerprint is exact equality of the caller's bindings (context, workspace, head, restart), compared with the record. No `ledger.command`.
- (b) The request ID as a `ledger.command` through `Submit`, with a canonical submission digest that ticket 06 defines.
- (c) A digest of the bindings stored in the record.
- **Recommend (a).**
  - B21 item 9 leaves "the canonical submission bytes and fields, the request/operation schema" to C3 (DEC:1438); C3's receipts bind "command ID … request ID if any" (RC:450). A commit holds one `ledger.command` (LD:201–204), so (b) would fix C3's command ID for promotions before C3 designs it.
  - D58 needs the check before capture (CORE:850), while `Submit` runs at commit time, after capture (DEC:1427–1429). The service needs its own record of each request's state for replay anyway (D58 "current or terminal state").
  - Exact comparison of recorded fields needs no canonical encoding, and the record carries every binding CORE:852 lists.
  - The actor is excluded: D58 names "submission content, candidate or context".

**P3. Order of the checks** (OI-6; → §2.5, §2.7).
- (a) Binding; identity; scratch; head; reservation (`scratch_busy`, `checkpoint_slots`, `capture_budget`); availability; then `no_validator` or capture. The record rule re-checks the head at append.
- (b) Reservation before identity: a replay would answer busy while the scratch is in use.
- (c) Head checked only under the exclusion.
- **Recommend (a).**
  - PKT:137–139 order identity and head (step 2) before admission (step 3) and unavailable (step 4).
  - Replay needs no reservation: D58 never enqueues or executes, and RC:354 replays "after later scratch edits".
  - CORE:856 lists exclusion before the K-slot and bytes.
  - A parent failure during capture can only come from another pair's `integrate`, which the scratch exclusion does not exclude, so only the append-time rule closes that race (CORE:856 "if any … parent/cursor check fails, roll back").
  - `request_in_flight` (my choice) prevents a second capture under one ID.

**P4. Refusals stay unrecorded** (revisits ticket 05's P4, DEC:1887; OI-14; → §2.5).
- (a) Busy, unavailable, head, mismatch and capture refusals write nothing and do not consume the ID.
- (b) Record a refusal receipt.
- **Recommend (a).**
  - CORE:856: "return not-admitted without a new snapshot"; the state list has no busy state.
  - Recording would make every retry of a busy ID replay "busy", against D70's "the caller explicitly retries later" (DEC:504).
  - RC:429 "Busy work stays undelivered"; UC:626: busy and refused answers "never make a source".
  - C3's command receipts (RC:450) are the place for command outcomes.
  - `rejected` is C4's validation outcome for an admitted request; a capture refusal (byte cap included) is not-admitted (RC:358's scenario 6 answers busy or unavailable).

**P5. The K-slot** (OI-2; AN2; → §2.4).
- (a) A provisional slot on the same token, transferred to the request by `keepSlot` after its record, and freed by the ending commit. Open restores the counts; K is checked at reservation and at append.
- (b) A separate slot mechanism.
- (c) Slots counted only from records at append.
- **Recommend (a).** DEC:1743 and WD:226 ("Ticket 06 adds its longer-lived K-slot to this token, not a second mechanism"); CORE:856 (an atomic reservation before snapshot); RC:608 (busy "only when its K=4 admitted slots are occupied"). Option (c) would capture before refusing a fifth, against T06:28.

**P6. The profile** (OI-20; → §2.3).
- (a) Rename to `CapacityProfile` (CORE:862's name), adding `CheckpointsPerPair` and `GenerationWindow`, with provisional 4 and 4.
- (b) Keep `CaptureProfile` and add the fields.
- (c) Constants.
- **Recommend (a).** B23 item 10 (DEC:1745); RU:63; WD:320–321; D112 keeps both numbers provisional calibration (DEC:1536), which a profile expresses without a code change; the reason is already `no_capacity_profile`.

**P7. Enrolled pairs and Q** (OI-7; → §2.4).
- (a) A pair is enrolled while it has an open scratch. K is per pair; Q for a workspace and the colony is the sum, with no separate cap.
- (b) A separate enrollment declaration.
- (c) An explicit workspace Q check.
- **Recommend (a).** F2-05's one open scratch per pair (LD:242–355); CORE:852 ("Q for a workspace is 4 × N declared enrolled pairs; colony Q is their sum"); RC:572 ("so workspace Q=4×N and colony Q is their sum"). No source names another enrollment record, and under (a) a separate Q check could never bind. Closure needs no live requests (P17), so a pair's slots end with its requests.

**P8. Lineages, heads and baselines** (OI-8 in part, OI-9, OI-21; → §2.6).
- (a) Core mints lineage IDs at roots; checkpoints are numbered per lineage; the caller names the head, and Core derives and records the checkpoint ("expected revision") and parent. A new root names the failed head in `RestartFrom`, takes the represented tree (the anchor in ticket 06) as baseline and delta base, and starts a new lineage at checkpoint 1.
- (b) The lineage ID is the root's request ID.
- (c) The caller also sends the expected checkpoint number.
- **Recommend (a).** CORE:852, :854, :858, :860; B4 DEC:670; RC:332 ("Each successor names the admitted local head"). Option (b) conflates identities that CORE:852 binds separately, and (c) is redundant with the head.

**P9. Train order, predecessor and window** (OI-11, OI-22; → §2.8).
- (a) The admission record's sequence orders the per-pair FIFO and the workspace train. The predecessor is the nearest live request's clean generation, or `main`. Currency is decided by predecessor commit. Generations exist only for the first `GenerationWindow` requests, and `integrate` is an explicit, idempotent step for C4's scheduler.
- (b) Generations derived eagerly at admission, for every request.
- (c) Order fixed by a request receipt.
- **Recommend (a).**
  - CORE:852 "durable admitted sequence"; CORE:862 "Bound the leading speculative window to four generations per workspace" and "choose the earliest eligible unvalidated generation within workspace durable order"; CORE:850 "UUID time never establishes train order".
  - RC:524: C4 integrates "C2's bounded cumulative candidate preparation".
  - In C2, admission is the receipt, since refused requests have none (P4).
  - (b) would leave preparation unbounded at 4N per workspace.

**P10. Git 2.45 floor** (G6-M3; → §2.2). Surfaced in OG-A6's summary.
- (a) Raise the floor to 2.45 and pass trees.
- (b) Keep 2.42 and wrap the delta base and sealed tree in throwaway commits for each merge.
- **Recommend (a).**
  - G6-M3: tree arguments with `--merge-base` arrived in 2.45; B23 counted only `--write-tree` (DEC:1701).
  - Option (b) adds two unreferenced commits per derivation and puts author-and-time metadata around immutable trees, which B23 avoided for retention (B23's reasons, DEC:1765).
  - The owner's Git is 2.55 (G6). C3's CI must supply the floor on Linux and macOS either way (DEC:1704).

**P11. The integration environment, the checks and the commit** (→ §2.8).
- (a) The capture-style private environment without a work tree, with `core.bare=true`. Repository `.gitattributes` and merge drivers are ignored; only pinned attributes apply. `--no-messages`; exit status decides. Core adds the case check. The commit's date is the generation ID's time.
- (b) The repository environment.
- (c) `--attr-source=<tree>`, so the trees' attributes apply.
- **Recommend (a).**
  - CORE:858: "controlled config and no unapproved merge drivers" and "Use Git's exit result, never conflict-marker text".
  - G6-M4: the repository environment ran a configured driver, and `merge=union` resolved a conflict silently. Under (c), an agent's own `.gitattributes` could make conflicts disappear, against D77's "without automatic semantic resolution" (DEC:558).
  - G6-M8 requires the case check; G6-M7 shows the commit is deterministic.
  - The owner sees, in OG-A6, that repository merge attributes do not apply.

**P12. Conflicts, visible work and disclosure** (OI-13; → §2.9).
- (a) A conflict at position 0 is terminal, and its report is released in the requester's `RequestState`. A speculative conflict is a non-terminal generation whose report stays host-private; requests behind it wait.
- (b) Every conflict terminal.
- (c) No report.
- **Recommend (a).** CORE:860 ("A speculative failure is not terminal until predecessor dependencies resolve"); CORE:880 (seal conflicts and changed paths before release; the requester sees "its own receipt and generic pending/coarse lifecycle only"); CORE:882 (release after the predecessor's durable acceptance; `main` is that predecessor at position 0); T06:31; RC:323; D23's "conflict as work" (RC:283).

**P13. Local failure versus foreign removal** (OI-10; → §2.10).
- (a) Any lineage-failing ending cascades `dependency_failed` to the live suffix in one commit. A removal supersedes survivors' generations without ending them. In ticket 06 the causes are `conflict` at position 0 and the cascade; tickets 08 and C4 add theirs through the same path.
- **Recommend (a)**; no other option meets CORE:860, B4 DEC:670–671 ("Local-parent failure and foreign train-predecessor removal are not interchangeable"), CON:101, RC:356–357 and T06:30.

**P14. F2-06's shape** (OI-3; → §3, Appendix B).
- (a) Three types: `promotion_admitted`, `generation_derived` (supersession inside it via `supersedes`; outcome `clean` or `conflict`) and `promotion_failed`, with an open `outcome` token whose every value fails the lineage. v1 defines `conflict` and `dependency_failed`; success endings get their own types in ticket 08.
- (b) A separate invalidation type and a separate conflict type.
- (c) One `promotion_ended` type including success outcomes.
- **Recommend (a).**
  - CORE:864 makes a new generation the consequence of a changed predecessor, so `supersedes` records the invalidation (CORE:878 "historical invalidation … to the existing generation/attempt records; no parallel provenance store").
  - CORE:860 lists cancelled, rejected, conflicted and interrupted as lineage failures, so one type with open tokens keeps the cascade rule valid for tokens a reader does not know. Under (c), an unknown token could not be classified.
  - Attempts are C4's F4 records (CON:40, the C4 producer row); ticket 06 keeps the generation ID they will bind (T06:29 "independent … attempt identities").
  - Commit-shape rules fix no index, so C3 may put a `ledger.command` tombstone first in an admission's commit (LD:201–204; Appendix B.2 rule 2).
  - D35's example name `workspace.promotion_accepted` (DEC:172) fits the family.
  - The names are a freeze question for the owner (§8).

**P15. Retention and the sweep** (OI-12, OI-15, OI-16; AN1; → §2.11).
- (a) Capture refs retained by rules (a)–(c) of §2.11 and generation refs while current. Release after the commit; Open sweeps refs no record retains and restores missing retained ones when their objects exist.
- (b) Release at every ending, with no parent rule.
- (c) Keep every ref for life.
- **Recommend (a).**
  - DEC:1736: release "under the terminal-state rules of tickets 06 and 08"; DEC:1871: only an admission record can say whether a capture ref has an owner.
  - CORE:854: a successor needs its parent's tree "even while pending". Option (b) would break ticket 08's successors after an accepted parent; (c) is unbounded retention.
  - Restoring mirrors B24's anchor restoration (DEC:1846).

**P16. Manifest publication** (OI-19; AN2; → §2.7).
- (a) Publish before the record, bind by `manifest_sha256` and `body_refs`, and pin while the request is live, as the inputs pin precedent does.
- (b) Reference it unpinned.
- (c) Pin it forever.
- **Recommend (a).** DEC:1730 and RU:36 ("ticket 06 publishes and binds it"); BR:1012; CORE:840 (bodies before references); CORE:882 (pin bodies needed for active obligations); the F2-05 precedent of a pin in the same commit (LD:242–355). The pin bound of 65,536 pairs (B21 item 10, DEC:1448) is far above K × N. The cost is in §2.17.

**P17. Closure with live requests** (OI-8; → §2.12).
- (a) Refuse with `ErrLiveRequests`.
- (b) Close and let the requests continue.
- (c) Cancel them.
- **Recommend (a).** RC:303 ("retained through explicit closure and outcome resolution"); cancellation is D57's separate command (DEC:391; ticket 08). The new record rule is additive (Appendix B.5).

**P18. Restart** (OI-17; → §2.13).
- (a) Open rebuilds everything from records and executes and writes nothing. Live requests stay live; ending them `interrupted` (D55) is ticket 08's crash reconciliation.
- (b) Ticket 06's Open ends every live request `interrupted`.
- **Recommend (a).**
  - D55's "requests proven not to have promoted" needs ticket 08's intents to prove it (RC:339–347).
  - B24 keeps Open record-free (DEC:1844); T08:12 owns "conditional crash reconciliation".
  - C2's product admits nothing, so (a) strands nothing before ticket 08, and C4 cannot run before C2 is done (DEC:1537).

**P19. Loose objects** (OI-18; AN3; → §2.15).
- (a) Later, at C4's capacity gate, with the interim policy that Core runs no maintenance and this ticket measures loose objects.
- (b) Core runs `git gc --auto` at Open or after releases.
- (c) Core prunes its own garbage.
- **Recommend (a).** Reasons in §2.15; DEC:1754, :1790 ("ticket 06's or later"); RU:68 ("Core never runs gc"). Option (c) cannot identify Core's garbage in a content-addressed, shared object store.

**P20. Memory of request history** (D78; → §2.17).
- (a) Keep each request's bindings and state for life and its generations while it is live, the growth B24 accepted (DEC:1886), with a cold path on a measured trigger.
- (b) A cold index now.
- **Recommend (a).** B3 (DEC:660: indexes "introduced only on measured triggers"); CORE:842; CORE:836 ("an evicted in-memory index is never proof" of absence, so eviction would need the cold path first). C2's product adds no entries.

**P21. Status by same-ID replay; a coarse `RequestState`** (→ §2.5).
- (a) `RequestPromotion` with a known ID is the status query, returning only coarse state, own lineage facts and a released conflict report.
- (b) A separate status call.
- **Recommend (a).** D58; CORE:880; C3 owns result delivery (DEC:1438).

**P22. Scenario assignment** (OI-23).
- RC:353–357 (scenarios 1–5) are ticket 06's mechanics. Scenario 4's cancel and interrupt causes come with ticket 08, through §2.10's path.
- RC:358 (scenario 6): ticket 05's busy and unavailable, plus ticket 06's `checkpoint_slots`.
- RC:359 (7): tickets 08, C4 and C10. RC:360 (8): ticket 09.

**P23. Tests simulate canonical movement** (→ §2.18, §4).
- (a) `advanceMain` moves `main` by compare-and-swap in disposable repositories to stand for ticket 08's acceptance.
- (b) Leave terminal conflicts and removals untested until ticket 08.
- **Recommend (a).** RC:289 permits mechanical tests of the ref primitive in disposable repositories; RC:407 asks C2 to prove the suffix, rebuild and conflict scenarios. A scratch cut from an unmoved `main` cannot conflict with it.

**P24. The S1b nits** (AN4).
- (a) Nits 2 and 3 in S1: the walk's error branch reports the relative path (capture.go, `walkCapture`'s first branch), and the mode check comes before `beginCapture` uses the token (capture.go:107–112). `eol.go`'s buffer sizing stays out.
- **Recommend (a).** Both nits touch code ticket 06 changes (the token) or extends. The `eol.go` change would re-fuzz `FuzzCRLFStreaming` (D116 item 6) with no ticket 06 benefit.

**P25. F2-06 staging** (→ §3.4, §6).
- S1 lands before the freeze; S2 lands with it; S3 after it (D113 DEC:1646–1647, :1649; D116 item 3).

### 7.2 The map's open items

Appendix A maps OI-1–OI-23 to these choices.

### 7.3 Owner gates

**OG-A6: approve the design** (T06:23; D116 "Designs, freezes and his other decisions still wait for him", DEC:1905).
- **Asked:** approve this brief as the advisor rules on it, before any code.
- The summary (§0) carries every consequence he could object to: the Git floor of 2.45 (P10); repository merge attributes ignored, and no merge programs (P11); no closure with live requests (P17); full manifests pinned while live (P16); no Core-run `gc` (P19); memory growth with request history (P20); live requests surviving a restart until ticket 08 (P18).
- **Options:** Approve as ruled; Approve with changes (named); Not yet.

**OG-F6: freeze F2-06** (D40 DEC:206; D113). This is a later, separate question (§8), asked after S2 is drafted and reviewed, before S3.

**Not owner gates:** P10 and P11 are build choices within B23's and CORE:858's rules, shown in OG-A6's summary, as RU:52 treated P13, P21 and P23. K and the window stay provisional (D112). No new dependency, and no owner decision is changed: D55, D57, D58, D62 (as B4 amends it), D70 and D75 are applied as written.

### 7.4 Boundary with tickets 07, 08, 09 and with C3 and C4

- **Ticket 07** (T07:12, :28–30) owns temporary scratches, end-of-turn commits, merge-back into the task scratch (fast-forward or `merge-tree`), its capture window and provenance.
  - Ticket 06 writes into no scratch (D77 DEC:558: no "early delivery into another agent's task scratch").
  - Ticket 06's admission records the scratch's context as author; ticket 07 adds merge-back authors by addition (UC:612–614).
  - Ticket 06's capture holds the scratch exclusively, so a merge-back that takes the scratch as a writer waits (DEC:1740).
  - Shared code: whichever of 06 and 07 lands first owns `mergeTrees` and `parseMergeTree`, and the other reuses them; ticket 07 needs the 2.45 floor only if it passes trees.
- **Ticket 08** (T08:12, :28–31) owns the finalizer, acceptance and the success endings, which advance `latest_represented` and make §2.11's rules (b)–(c) bite; `cancelled` and `interrupted` through §2.10's ending path, holding the per-workspace train lock; D55/D59 reconciliation at Open; and no-change against the accepted predecessor.
- **Ticket 09** (T09:12, :28–30) owns activation and the evidence epoch that C4's attempts bind.
- **C3** owns authentication of `Actor`, command receipts, result delivery, authorized reads of manifests and conflict reports, and owner audit.
- **C4** owns the validator reservation in `reserve`; calling `admit` and `integrate`; lanes, the scheduler and attempts (F4); `rejected`; BD2 release; child stop proof before slot release; and the capacity gate, which revisits P19 and P20.

---

## 8. The freeze path (F2-06)

**Who and when.** Freezing is the owner's decision (D40 DEC:206; CON:13–19). S2 is drafted after OG-A6, reviewed by the advisor on the PM's evidence (V2, V3, V6–V9, V12, V4), and then the PM sends one question-tool request with a packet of one or two pages (D116 item 7, DEC:1907). S3 starts after the answer.

**The packet:**
1. **What is frozen**, by addition to `ledger-format` version 1 (D40, D111, D113): `workspace.promotion_admitted`, `workspace.generation_derived` and `workspace.promotion_failed` at version 1, with Appendix B's payloads and record rules, including the additive rule on `workspace.scratch_closed` (B.5). `Defined()` then lists eleven type versions. The golden is `contract/ledger/testdata/f2/06/log/00000000000000000001.jsonl`, with its SHA-256, at S2's commit.
2. **What freezing means for him:** the types change only by addition, with new outcome tokens needing no new version; S3 may start; C3, C4 and ticket 08 build against them. No producer is operational until C4 (CON:109).
3. **Evidence, in one table:**
   - S2's tests;
   - `FuzzDecodeF2_06`, 120 s;
   - V8: the F0 and F2-05 goldens unchanged, with D111's and D115's digests;
   - platforms: Windows verified, Linux and macOS vetted;
   - D78 in one line each, labelled as in §2.17's records and manifest calculations.
4. **His choices,** each with a recommendation:
   1. the three names;
   2. `outcome` as an open token whose every value fails the lineage (P14);
   3. the manifest pinned while live (P16);
   4. the conflict report as a Core-internal body (P12);
   5. the closure rule (P17);
   6. commit shapes that fix no index, leaving room for C3's command tombstone (P14);
   7. UC:616 and UC:618 noting the F2-06 types that realize "Promotion attempted" and "Promotion refused" (UC:625 keeps the table a consumer boundary).
5. **The question and options:** "Freeze as presented"; "Freeze with changes", naming them (a follow-up commit makes them and the freeze is recorded at its commit); "Not yet".

**Evidence files the packet cites:** S2's commit; `go doc ./contract/ledger` for the new types; the CONTRACTS.md F2-06 table (Appendix B.6); this brief's Appendix B as ruled; the advisor's review of S2; the PM's V-run log.

**After the answer:** one documents commit holds the decision entry (D«next», "F2-06 promotion admission, generation and failure records frozen", with the golden's digest), the register change (CON:3, :25, the F2-06 table) and the UC:616 and :618 notes. S2 reaches `main` with it (D116 item 3).

---

## Appendix A. The map's open items

| Item | Resolution |
|---|---|
| OI-1 admission through the product | P1; §2.18 |
| OI-2 K-slot | P5; §2.4 |
| OI-3 no F2 part yet | P14; Appendix B |
| OI-4 who owns request identity | P2: ticket 06 at the workspace layer; C3 owns command bytes, receipts and delivery |
| OI-5 fingerprint | P2: the caller's bindings, compared exactly before capture; the content is host-captured and immutable |
| OI-6 order | P3 |
| OI-7 declared pairs and N | P7 |
| OI-8 closure, `latest_represented` | P17; P8 (represented = anchor in ticket 06; advanced by ticket 08) |
| OI-9 new root | P8 |
| OI-10 failure causes in ticket 06 | P13 |
| OI-11 predecessor and integration in C2 | P9, P11; `main` is position 0's predecessor; integration is an explicit step |
| OI-12 retention of integration commits | P15: generation refs |
| OI-13 visible work and the barrier | P12 |
| OI-14 refused capture | P4: not admitted; `rejected` is C4's |
| OI-15 which terminals release refs | P15 |
| OI-16 sweep and crash window | P15; §2.11 |
| OI-17 restart | P18 |
| OI-18 loose objects | P19 |
| OI-19 manifest | P16 |
| OI-20 K and N in the profile | P6, P7 |
| OI-21 wording | P8; §2.6 |
| OI-22 FIFO position | P9: the admission record's sequence |
| OI-23 scenarios | P22 |

**The advisor's notes:** AN1 → §2.11 and P15; AN2 → §2.4 and P5, §2.6–2.7, P16; AN3 → §2.15 and P19; AN4 → P24.

---

## Appendix B. F2-06 proposal: ticket 06's part of F2

**B.1 Common rules** (as F2-05, LD:242–355; DEC:1679).
- Payloads follow F0's encoding rules: compact JSON with keys in the tabled order; errors wrap `ErrInvalid`; missing required, null known and repeated keys are refused; unknown keys are ignored; re-encoding reproduces `Encode`'s bytes.
- An optional key is omitted when absent and refused when present with a zero, empty or null value.
- Git object IDs are 40 or 64 lowercase hex digits; their match with the workspace's object format is a record rule.
- Producer: Core's workspace service only, through `appender.Appender`, enforced by review.
- C2 owns the payload specifications; the namespace is `workspace.` (DEC:1678).

**B.2 `workspace.promotion_admitted` v1 (`PromotionAdmitted`)** — a checkpoint's admission: the request's receipt and its immutable submission.

| key | type | presence | rule |
|---|---|---|---|
| `request_id` | UUIDv7 | required | the caller's request ID (D58) |
| `workspace_id` | UUIDv7 | required | a registered workspace |
| `scratch_id` | UUIDv7 | required | the pair's open scratch, which the capture read |
| `context_id` | UUIDv7 | required | the scratch's context: requesting and authoring context (D17, D23) |
| `lineage_id` | UUIDv7 | required | the scratch lineage |
| `checkpoint` | integer | required | 1 through MaxInt64; 1 exactly when `parent_request_id` is absent |
| `parent_request_id` | UUIDv7 | optional | the local parent; absent at a root |
| `restart_from` | UUIDv7 | optional | at a new root, the failed head it replaces; never with `parent_request_id` |
| `scratch_base` | Git object ID | required | the physical scratch base commit |
| `baseline_tree` | Git object ID | required | the trusted eligibility baseline |
| `delta_base_tree` | Git object ID | required | the delta base, bound separately |
| `capture_id` | UUIDv7 | required | the capture; its ref is `refs/dwarf-harness/captures/<capture_id>` |
| `sealed_tree` | Git object ID | required | the submission's sealed tree |
| `manifest_sha256` | digest | required | the raw manifest, a body |
| `inputs_revision` | integer | required | 1 through MaxInt64: the capture-inputs revision used |
| `capture_inputs_sha256` | digest | required | that revision's document digest |
| `pin_id` | UUIDv7 | required | the `ledger.body_pin` of the manifest in the same commit |

Record rules:
1. Actor `owner` or `agent`; the envelope's `context_id` equals `context_id`. `body_refs` is exactly [`manifest_sha256`].
2. The same commit holds, immediately after this record, a `ledger.body_pin` with `pin_id` and the same `body_refs`. No commit index is fixed, so C3 may place a `ledger.command` first (LD:201–204).
3. `request_id` and `capture_id` were never admitted before; for a root or new root, `lineage_id` is new.
4. `scratch_id` is the open scratch of (`context_id`, `workspace_id`), and `scratch_base` its `base_commit`.
5. With H the scratch's latest admitted request, exactly one of:
   - root: no H; no parent or restart; `baseline_tree` and `delta_base_tree` equal the scratch's `anchor_tree`;
   - successor: H has not failed; `parent_request_id` = H; `lineage_id` and checkpoint continue H's; both trees equal H's `sealed_tree`;
   - new root: H failed; `restart_from` = H; both trees equal the scratch's represented tree, which is its `anchor_tree` until a later F2 part records another.
6. `inputs_revision` is a recorded revision of the workspace not above its current one, and `capture_inputs_sha256` is that revision's digest.
7. Git ID lengths match the workspace's object format.
8. Service policy, checked on append only: the pair has fewer than K live requests.

**B.3 `workspace.generation_derived` v1 (`GenerationDerived`)** — one integration of an admitted request over its train predecessor.

| key | type | presence | rule |
|---|---|---|---|
| `generation_id` | UUIDv7 | required | new |
| `request_id` | UUIDv7 | required | a live admitted request |
| `supersedes` | UUIDv7 | optional | the request's current generation, replaced because its predecessor changed; absent for its first |
| `predecessor_request_id` | UUIDv7 | optional | the train predecessor; absent when it is canonical `main` |
| `predecessor_generation_id` | UUIDv7 | optional | that request's current generation; present exactly when `predecessor_request_id` is |
| `predecessor_commit` | Git object ID | required | P: that generation's `derived_commit`, or `main`'s tip |
| `predecessor_tree` | Git object ID | required | P's tree |
| `inputs_revision` | integer | required | the capture-inputs revision whose pinned configuration and attributes the merge used |
| `integration_rules` | string | required | `^[a-z][a-z0-9-]*/[1-9][0-9]*$`, at most 64 bytes; Core writes `integration-rules/1` (§2.8) |
| `outcome` | string | required | `clean` or `conflict` |
| `derived_commit` | Git object ID | when clean | the integration commit, P its only parent; ref `refs/dwarf-harness/generations/<generation_id>` |
| `derived_tree` | Git object ID | when clean | its tree |
| `conflict_sha256` | digest | when conflict | the conflict report, a body |

Payload rules (decoder): `clean` requires both derived keys and no `conflict_sha256`; `conflict` the reverse.

Record rules:
1. Actor `core`; the envelope's `context_id` is the request's. `body_refs` is absent when clean and exactly [`conflict_sha256`] for a conflict.
2. `generation_id` is new; `request_id` is admitted and not ended.
3. `supersedes` is the request's current generation, absent exactly when it has none; when present, `predecessor_commit` differs from the superseded generation's.
4. When `predecessor_request_id` is present, it names the nearest live request ahead of `request_id` in its workspace's admission order. `predecessor_generation_id` is that request's current generation, with outcome `clean`, and the predecessor commit and tree are its derived ones. When it is absent, no live request is ahead.
5. `inputs_revision` is recorded and not above the current revision; Git ID lengths match.
6. The window is service policy and no record rule.

**B.4 `workspace.promotion_failed` v1 (`PromotionFailed`)** — a request ended without promotion, failing its lineage.

| key | type | presence | rule |
|---|---|---|---|
| `request_id` | UUIDv7 | required | a live request |
| `outcome` | string | required | `^[a-z][a-z0-9_]*$`, at most 64 bytes; v1 defines `conflict` and `dependency_failed` |
| `generation_id` | UUIDv7 | optional | `conflict`: the request's conflicting current generation |
| `failed_request_id` | UUIDv7 | optional | `dependency_failed`: the local request whose failure ended this one |

Payload rules (decoder): `conflict` requires `generation_id` and no `failed_request_id`; `dependency_failed` the reverse. Any other well-formed outcome is accepted with either optional key, as F2-05's `reason` is (DEC:1679).

Record rules:
1. The envelope's `context_id` is the request's; `body_refs` is absent. v1's outcomes have actor `core`; a later part defines its outcomes' actors.
2. `request_id` is admitted and not ended.
3. `conflict`: `generation_id` is the request's current generation, with outcome `conflict`, and no live request is ahead of `request_id` in its workspace's train.
4. `dependency_failed`: `failed_request_id` is a request of the same lineage with a smaller checkpoint, ended by `promotion_failed` earlier in the log or earlier in this commit.
5. Every outcome, including one the reader does not know, fails the lineage: after the commit's last record, no request of the lineage with a larger checkpoint than a request ended in the commit is live.
6. After its endings, the commit holds one `ledger.body_unpin` of each ended request's admission `pin_id`, in the same order.

**B.5 Additive rule on F2-05's `workspace.scratch_closed`:** no closure of a scratch while one of its requests is live. Logs without F2-06 records are unaffected.

**B.6 Register entries** (CON:34's attributes; table after CON:65, under "**F2-06 catalogue (C2, D«next»)**"):

| Type, version 1 | Payload owner | Producer | Permitted appender caller | Consumers | Privacy class | Replay-essential fields | Golden sample |
|---|---|---|---|---|---|---|---|
| `workspace.promotion_admitted` | C2 | Core's workspace service, when it admits a checkpoint (from C4 on, through `RequestPromotion`; in C2, mechanism tests only, D52) | `internal/core/workspace` only (review) | Core's workspace service (identity, lineages, K-slots, train, retention); C3 (request state and passive results to the original context); C4 (submissions behind generations); ticket 08's finalizer (local-parent order, accepted delta); owner inspection | identifiers, Git object IDs and digests; no content. The manifest body lists the scratch's paths, sizes and raw hashes, can name private files, and is read only through Core's authorized body reads (C3) | all payload keys and `body_refs` | seqs 6, 8, 10, 21 |
| `workspace.generation_derived` | C2 | as above, when it integrates an admitted request | as above | Core's workspace service (current generations); C4 (attempts bind `generation_id`; evidence binds predecessor and derived tree); ticket 08's finalizer; owner audit | identifiers, Git object IDs and digests, host-private until release under Core §13.3; the conflict report body names conflicting paths | all payload keys and `body_refs` | seqs 12, 13, 14, 15, 20 |
| `workspace.promotion_failed` | C2 | as above, when a request's lineage fails | as above | Core's workspace service (lineage state, slots, retention); C3 (terminal results, D63); C4 (stop superseded children); owner inspection | identifiers and an outcome token | all payload keys | seqs 16, 17 |

**B.7 Golden sample** `contract/ledger/testdata/f2/06/log/00000000000000000001.jsonl`. LF-only (B1), built by `TestGoldenF2_06` with fixture IDs, digests and times from `golden_test.go`'s helpers and a new fixture colony; event times from 1791000030000000000 in steps of one second.

| Commit | Records (seq) | Actor, envelope context |
|---|---|---|
| c1 | 1 `workspace.registered` (W1, `C:/fixture/repo-c/.git`, `sha1`); 2 `capture_inputs_pinned` (W1, revision 1, I1, pin P1; refs [I1]); 3 `ledger.body_pin` (P1; [I1]) | owner |
| c2 | 4 `scratch_created` (S1, W1, C1, `1a2b3c4d`, `refs/heads/dwarf-harness/1a2b3c4d`, base B0, anchor A0) | core, C1 |
| c3 | 5 `scratch_created` (S2, W1, C2, `5e6f7a8b`, …, B0, A0) | core, C2 |
| c4 | 6 `promotion_admitted` R1 (S1, C1, lineage L1, checkpoint 1, base B0, baseline A0, delta A0, capture X1, sealed T1, manifest M1, revision 1, I1, pin Q1; refs [M1]); 7 `ledger.body_pin` (Q1; [M1]) | agent, C1 |
| c5 | 8 R2 (S1, L1, checkpoint 2, parent R1, baseline T1, delta T1, X2, T2, M2, Q2); 9 pin Q2 | agent, C1 |
| c6 | 10 R3 (S2, C2, lineage L2, checkpoint 1, B0, A0, A0, X3, T3, M3, Q3); 11 pin Q3 | owner, C2 |
| c7 | 12 `generation_derived` G1 (R1; predecessor `main` B0/A0; revision 1; `integration-rules/1`; clean, D1/DT1) | core, C1 |
| c8 | 13 G2 (R2; predecessor R1/G1, D1/DT1; clean, D2/DT2) | core, C1 |
| c9 | 14 G3 (R3; predecessor R2/G2, D2/DT2; conflict, report CR1; refs [CR1]) | core, C2 |
| c10 | 15 G4 (R1; supersedes G1; predecessor `main` B1/BT1; conflict, CR2; refs [CR2]); 16 `promotion_failed` (R1, `conflict`, G4); 17 `promotion_failed` (R2, `dependency_failed`, R1); 18 `ledger.body_unpin` (Q1); 19 `ledger.body_unpin` (Q2) | core, C1 |
| c11 | 20 G5 (R3; supersedes G3; predecessor `main` B1/BT1; clean, D5/DT5) | core, C2 |
| c12 | 21 R4 (S1, C1, lineage L3, checkpoint 1, `restart_from` R2, B0, A0, A0, X4, T4, M4, Q4); 22 pin Q4 | agent, C1 |

It pins a root, a successor, an owner admission, a clean generation over `main` and one over a local parent, a speculative conflict, supersession, a terminal conflict with its cascade and unpins, a foreign-removal rebuild and a new root after failure. Sixty-four-digit IDs are covered by `TestF2_06PayloadsRoundTrip`, as F2-05's golden covered both lengths (LD:242–355).

---

## Appendix C. Acceptance trace

| Criterion | Behavior | Tests |
|---|---|---|
| T06:28 K=4 distinct FIFO per pair; capacity scales; fifth busy before capture | §2.4, §2.5, §2.8 (FIFO = admission order) | `TestCheckpointSlotsPerPair`, `TestFourCheckpointsThenBusy`, `TestIdenticalContentStaysDistinct`, `TestCapacityScalesWithPairs`, `TestOpenRebuildsAdmissionState`, `TestConcurrentAdmissionReservations` |
| T06:29 same-ID replay without recapture | §2.5 | `TestSameIDReplayDoesNotRecapture`, `TestSameIDMismatch`, `TestRequestInFlightIsBusy` |
| T06:29 verify the local head | §2.5, §2.6, §2.7 | `TestHeadChecks`, `TestParentFailureDuringCaptureRefused`, `TestConcurrentRequestsOnePair` |
| T06:29 independent immutable submission, generation, predecessor, attempt identities | Appendix B; P14 | `TestFourCheckpointsThenBusy`, `TestForeignRemovalRebuildsSurvivors` (new generation ID), the golden |
| T06:30 local sealed parent for eligibility and delta, not the foreign predecessor | §2.6, §2.8 | `TestSuccessorEligibilityFromParentTree`, `TestForeignPredecessorNeverSetsEligibility`, `TestMergeTreesUsesDeltaBase`, `TestIncrementalCandidatesOverForeignPredecessor` |
| T06:30 local-parent failure terminates the suffix | §2.10 | `TestLocalParentFailureEndsSuffix` |
| T06:30 foreign removal rebuilds survivors | §2.10 | `TestForeignRemovalRebuildsSurvivors`, `TestSpeculativeConflictWaits`, `TestWindowBoundsGenerations` |
| T06:31 explicit new root; no reopened IDs or resurrected changes | §2.6, §2.10 | `TestNewRootAfterFailure` |
| T06:31 mechanical conflict becomes visible work | §2.9 | `TestConflictIsVisibleWork`, `TestMergeTreesConflictByExitStatus`, `TestDerivedTreeCaseCollision`, `TestIntegrationEnvironment` |
| AN1 sweep and release | §2.11 | `TestOpenSweepsUnownedRefs`, `TestOpenRestoresRetainedRefs`, `TestLocalParentFailureEndsSuffix` |
| AN2 K-slot on the token; parent's tree as baseline; manifest published and bound | §2.4, §2.7 | `TestSlotReturnedUnlessKept`, `TestSuccessorEligibilityFromParentTree`, `TestAdmissionFailureRollsBack` |
| AN3 loose objects | §2.15 | harness phases (V11) |
| SPEC stories 10, 13 | the rows above | — |
| SPEC implementation 1–4 | §2.1 gates, §3, Appendix B | S2's tests; the freeze |
| SPEC implementation 7, 8 | §2.4–2.10 | the rows above |
| SPEC testing 1, 2, 9 | real repositories and store; behavior assertions | all |
| SPEC testing 18 | §2.17 | `TestCaptureWorkload` (V11) |
| SPEC testing 20 | regression cases kept as tests | — |

---

## Appendix D. Git facts used (G6, `local://t06-git-probe.md`, Git 2.55.0.windows.3)

- **M1, M2.** With `--merge-base=<tree>`, trees or commits for the two sides merge; clean results are identical either way. Exit is 0 when clean and 1 on conflict; `--end-of-options` before the two sides is accepted. Conflicted result trees depend on the argument IDs through conflict labels.
- **M3.** `--merge-base`: Git 2.40.0. Tree (non-commit) arguments: Git 2.45.0 ("the three trees involved in the 3-way merge only need to be trees"). `--write-tree` mode: 2.38.0.
- **M4.** In the repository's own environment, a configured `merge.evil.driver` ran (marker created, exit 0), and `merge=union` resolved a conflict. In a private bare `GIT_DIR` with only config and `HEAD`, the common object directory, `GIT_CONFIG_NOSYSTEM=1`, an empty global config and no other `GIT_*` variable, no driver ran and no tree `.gitattributes` was read: `union` conflicted. `--attr-source=<tree>` made that tree's attributes apply.
- **M5.** That private environment writes result objects to `GIT_OBJECT_DIRECTORY`, with no error about `HEAD`, the index or refs.
- **M6.** `core.autocrlf=true` with `merge.renormalize=true` changes nothing for LF blobs.
- **M7.** `commit-tree` with fixed author and committer names, emails and dates gives the same ID twice.
- **M8.** Under `core.ignorecase=true`, `Docs/x.txt` against `docs/y.txt` merges clean into one tree holding both.
- **M9.** With `-z --name-only --no-messages`, the output is the tree ID and then each conflicted path, each NUL-terminated, and nothing else; `--[no-]messages` dates from 2.38.0.
