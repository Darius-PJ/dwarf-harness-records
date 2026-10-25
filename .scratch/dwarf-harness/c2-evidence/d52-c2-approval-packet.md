# D52 approval request: the C2 promotion boundary

**Prepared:** 2026-10-12, against `main` at 5b07a9b, for Core step C2 and its first ticket, 05. The cited files are unchanged at a8b31d9. **Answer:** 2026-10-12, in the question tool: "Approve". [D112](../../../docs/DECISIONS.md#d112-c2-promotion-boundary-approved-d52) records your approval from section 8's draft, and the Appendix's edits record the status changes. The rest of this packet stays as sent.

D52 asks you to approve the promotion-boundary specification in Core step C2 before any C2 or C3 code is built (DEC:343; RC:308). C1 is Done and you froze its F0 contracts on 2026-10-10 (RC:276; DEC:1512), so your approval is the last item C2 waits for (RC:376; RM:170). Ticket 05 names it as a start gate (T05:23). C2 cannot start until you answer; take the time you need.

**In short.** You are asked to approve how work moves from an agent's private scratch into a workspace's `main`: exact capture of the scratch's content, a queue of up to four checkpoints per context and workspace, a merge train validated in parallel but published one request at a time in order, cancellation and crash recovery, switching the validation policy, and sealing of unfinished results (§3). Approving lets C2 start: it proposes its F2 event families, which you freeze before C2 implementation (§2.1, §5.3). Nothing is promoted until C4 brings real validation: C2 answers promotion requests "unavailable", and all harness work stays testing-only (§2.2). One small decision is still yours: who may change a workspace's pinned exclusions (P2). We recommend approving, with those exclusions yours alone (§6).

Citations are `file:line` at commit 5b07a9b. "RC:290, :320" means lines 290 and 320 of the same file.

| Short | File |
|---|---|
| RC | `docs/ROADMAP-CORE.md` |
| CORE | `docs/DESIGN-CORE-AND-LAUNCHERS.md` |
| DEC | `docs/DECISIONS.md` |
| RM | `docs/ROADMAPS.md` |
| CON | `docs/CONTRACTS.md` |
| UC | `docs/DESIGN-UNDERCURRENT.md` |
| RU | `docs/ROADMAP-UNDERCURRENT.md` |
| RAV | `docs/RESEARCH-ADMISSIBLE-VALIDATION.md` |
| SPEC | `.scratch/dwarf-harness/spec.md` |
| T05 | `.scratch/dwarf-harness/issues/05-create-private-scratch-and-capture-exact-eligible-trees.md` |
| AGENTS | `AGENTS.md` |

**[INFERENCE]** marks our reading where no line says it outright.

## 1. What you are asked to approve

### 1.1 The text

Your approval covers this text as it stands at 5b07a9b:

| Lines | Content |
|---|---|
| RC:278–417 | Core roadmap step C2, heading to status line: goal and deliverables (280–290); definitions (292–304); the promotion boundary and who implements what (306–314); the recorded lifecycle choices (316–338); recovery prerequisites and mapping (340–348); the selected promotion specification (350); eight boundary scenarios (352–361); the snapshot choices (364–372); its Core-internal status (374); waits, stop point and unblocks (376–380); the decided table (382–400); prerequisites and evidence (402–415); the status line (417), which approval changes |
| CORE:848–874 | Core design §13.2: capture, immutable checkpoints and the validation train, with durable one-off policy activation (868–872) |
| CORE:876–882 | Core design §13.3: the whole-generation disclosure barrier |

§§13.2–13.3 are read under §13's opening paragraph: §13 is the controlling Core design addendum and supersedes earlier sections where they disagree; it selects mechanisms, and it freezes no contract and passes no implementation gate (CORE:824). The roadmap names this review "the complete boundary in core §§13.2–13.3" (RC:406).

### 1.2 What D52 asked the specification to settle

D52 names five subjects the specification must settle (DEC:343). Each is settled in the text above:

| D52 subject | Where it is settled |
|---|---|
| Request and result lifecycle | Core owns each request; it can outlive the requesting turn; results belong to the original context and arrive passively (RC:320, :337). The request states are in CORE:856 (§3.3) |
| Exact candidate and evidence bindings | What each request binds (CORE:852), what each generation binds (CORE:864) and what the finalization intent binds (CORE:866) |
| Canonical movement during validation | A moved `main` is not a refusal: Core rebuilds the candidate over the actual predecessor and validates it afresh; a mismatch at publication blocks it and invalidates dependent evidence (RC:301; CORE:858, :860, :864; DEC:555) |
| Cancellation and crash recovery, including Git/ledger ordering | Cancellation is a separate, request-specific command that works only before the durable intent (RC:325). Order: intent, guarded Git update, durable evidence of the update, acceptance, slot release (CORE:866; RC:327). Recovery follows a three-row mapping under strict prerequisites and never re-executes (RC:340–348) |
| Initial check selection and no-check behaviour, with no permissive fallback | Every ref-changing candidate runs the full declared required set; empty, invalid or unconfigured gates are unavailable, with no human fallback (RC:336). A tree identical to its accepted predecessor ends `no_change` without checks (RC:335). Without the real validator, requests are unavailable (RC:290) |

### 1.3 What approval adopts beyond your own decisions

Most of the boundary restates your decisions D48 and D52–D78 (§4). Approving it also adopts assistant work in three places:

- **B4 changes your D62.** D62 allows one outstanding promotion per context and workspace, "to avoid unnecessary snapshots" (DEC:436–437). B4, an assistant entry, amends it to a first-in-first-out queue of four independently identified checkpoints per enrolled code-working (context, workspace) pair (DEC:664; DEC:441; CORE:852; RC:333). It keeps D62's reason: admission still comes before capture, so a refused request takes no snapshot (DEC:664). D77 says D62's limit "remains until explicitly amended" (DEC:560); your approval would be the owner's endorsement of that amendment [INFERENCE].
- **B4 and B5 fill items your decisions left to this specification.** For example: the trusted baseline for which files count as tracked, left open by D60, D74 and D76 (DEC:421, :534, :548), is CORE:854; activation's time format, missed times, replacement and recovery, left open by D66 (DEC:471), are CORE:868–872; the limits, scheduling and integration mechanics that D77 left to "the owner-gated C2 specification" (DEC:560) are CORE:858 and :862; evidence reuse, which D58 kept a separate policy (DEC:398), is CORE:874: no reuse.
- **B15 sets C2's workload gate.** RC:338, inside the approved range, takes B15's calibration envelope as the workload: 12 or 20 code-working pairs, each offering one required change per ten minutes; a synchronized burst of four checkpoints per pair; four checkpoints per pair and four colony lanes; and a provisional target of accepted capacity at least 1.25× steady demand. C2 records its costs "against the D78/B15 workload" (RC:415; also RC:411). B15 is an assistant entry (DEC:760). Its numbers stay calibration inputs and a hypothesis, not measured capacity, a colony-size cap or a service level (DEC:761–762; RC:338; §2.2).

One item D75 left to this specification is not filled: who reviews and approves a workspace's pinned exclusions (DEC:541; CORE:854). That is P2 (§6).

### 1.4 References outside these ranges

Nothing outside the three ranges becomes part of the approval by reference:

| Reference | Cited at | Status under this approval |
|---|---|---|
| Decision entries (§4) | throughout | Already decided. The approval rests on them and re-decides none, apart from adopting B4's amendment of D62 (§1.3) |
| Core §3.5 | RC:280, :294, :298, :386, :395 | Not approved as such. Where the C2 text restates a point and cites §3.5, the C2 text is what you approve; §13 controls where §3.5 disagrees (CORE:824) |
| "core §13" | RC:308 | Read as §§13.2–13.3, the sections RC:350 and RC:406 name. Core §3.5 says the selected mechanisms span §§13.2–13.4 (CORE:193, :197, :255); §13.4 is C4's evidence and C5's check governance (CORE:884) and stays with C4 |
| Core's existing sequencer, the existing deterministic scheduler and `PolicyActivationManifest` | CORE:862, :868, :870 | Referenced mechanisms, not approved by this decision. The sequencer is §13.1's Core-owned serialized appender, which assigns the colony sequence (CORE:834–836; DEC:328); the only other scheduler Core describes is §13.5's ready-context scheduler (CORE:901); the manifest is §13.1's activation record (CORE:846), which CORE:868's "expected active-manifest record hash" names |
| Core Appendix A.7 | RC:285, :287, :288, :389, :392 | Historical single-run measurements, "not throughput" (RC:285) |
| Undercurrent §15.1 | RC:282, :288, :289 | Not approved. Event shapes come with C2's F2 proposal and your later freeze (RC:221, :407); a proposed event shape is not D52 approval (CON:82; UC:677) |
| Validation §4.9.1 | RC:409 | C4's suite and gate |
| `CONTRACTS.md` and the frozen F0 contracts | RC:374, :376 | Unchanged. C2's records obey frozen `ledger-format` and D40 (RC:374; CON:84; DEC:1512) |
| "BD2" | RC:360 | The name C4's text gives the whole-generation output barrier (RC:525, :572), which §13.3 specifies |
| Git documentation | RC:364 | Background to D74–D76 |

## 2. What approval permits, and what it does not

### 2.1 It permits

- **C2 to start.** Its stop point lifts once C1 is Done, `ledger-format` and `ledger-appender` are frozen and you approve this boundary (RC:378); "until approved, C2/C3 code does not begin" (RC:406). The first two hold (RC:276; DEC:1512), and D111 names D52's approval as what C2 still needs (DEC:1518).
- **C2's status to become Ready.** Approval meets the last item C2 waits for (RC:376; RM:170). The status values give *Not ready* for a missing design decision and *Waiting* for an undone dependency (RM:62); with neither left, C2 is *Ready*. The status changes on the board and in the roadmap in one commit (RM:198).
- **Ticket 05 to pass its D52 gate** (T05:23). Its other start gate reads "relevant owner-frozen consumed ledger/producer families before implementation" (T05:22). The ledger contracts it consumes are frozen (DEC:1512). Its own records belong to C2's family F2, which C2 records as a proposal before producer implementation (RC:407) and you freeze under D40 "before C2 implementation" (CORE:844; RC:220). So ticket 05 can begin once your entry is recorded, with the F2 proposal; your F2 freeze comes before C2 implementation, and §5.3 notes that the sources do not say which C2 work may precede it [INFERENCE: T05:22's "producer families" includes F2].
- **C3's D52 gate to pass** (RC:308), not C3 itself. C3 still starts only after C2 is Done and your private remote with CI exists (RC:461, :463; RM:171; DEC:224).
- **C4's "approved D52 boundary" item to be met** (RM:172). C4 still waits for C3 Done, U1.L Done and a frozen `law-format` (RC:537).

### 2.2 It does not

- **Make promotion available.** C2 completion does not enable accepted promotions (RC:282). Requests return unavailable, `main` does not move and no accepted promotion is recorded; there is no allow-all validator, temporary bypass or direct-ref workaround (RC:290; DEC:342). "C2 alone cannot promote" (RC:409). Tests of the ref update in disposable repositories are not promotions (RC:290; DEC:342). Accepted promotion is C4's gate (RC:396; DEC:344; RC:594).
- **Allow real colony work.** Harness agents stay testing-only until C4's end-to-end gate passes and C4 is Done (DEC:341; RC:13). Real work waits until the integrated D77 concurrency and D78 feasibility gates pass (RC:539).
- **Freeze a contract or approve an event shape.** The boundary is internal to Core and freezes nothing (CON:84; RC:374; CORE:824). F2 is a later freeze, not a current contract (RC:221). A proposed event shape is not this approval (CON:82).
- **Change any other status.** C3, C4, C10, U3 and U4 stay Waiting (RM:171, :172, :180, :189, :190); U3's foundation waits for C2 Done (RU:281). No contract's status changes (CON:84).
- **Turn marked items into your decisions.** Items marked [PROPOSAL] or [INFERENCE] keep their marks, and a build may revise them with a B entry (RC:11; RM:232; DEC:5). §5.4 lists them.
- **Turn provisional numbers into capacity or policy.** Four checkpoints per pair, four validation lanes, the four-generation window and the 1.25× target stay calibration inputs and a hypothesis, not measured capacity, a colony-size cap or a service level (RC:338; CORE:242, :852; DEC:560, :761).
- **Approve any later change or dependency.** D40/D41 change approval stays a prerequisite (RC:350). Once you approve, a change to this text other than a marked item touches an owner decision and waits for you (DEC:213; RM:230) [INFERENCE: D41 applied to this approval]. A new module needs its D29 record (AGENTS:39).
- **Claim evidence.** C4's checks, C10's containment and real capacity and durability measurements are still to come (RC:350, :411, :417).
- **Provide OS isolation.** D52 is a build and use gate; C10 owns isolation (DEC:346; RC:410).

## 3. The boundary in plain terms

### 3.1 Who builds what

- **C2:** capture that cannot change afterwards, preparing integration candidates, bounded workspace orchestration and the one serialized sequence that moves `main`; no acceptance without C4's evidence (RC:312).
- **C3:** binds agent and owner requests to their authority and original context, and keeps submissions, attempts and durable results apart at the command and event boundary (RC:313).
- **C4:** runs the full required checks, produces evidence for the exact candidate, and proves ordered publication, invalidation, recovery and capacity end to end (RC:314).

### 3.2 What C2 builds

- **Workspaces.** A workspace is a registered Git repository (RC:294). Its `main` is canonical: never checked out, moved only by Core's compare-and-swap through validation-gated promotion (RC:295; DEC:314). People and agents work on branches, and human changes take the same path (RC:282).
- **Scratches.** Each bound context gets one dedicated linked worktree per workspace, on its own branch, cut from canonical. It is kept until explicit closure; there is no shared pool of spare worktrees, and cleanup cannot discard edits not yet represented (RC:285, :296, :304).
- **Temporary scratches.** When a second of the same agent's turns writes to a task whose scratch is in use, it gets a temporary worktree cut from the task scratch's last commit, merged back by fast-forward or `git merge-tree --write-tree`; a conflict becomes the agent's work. C3 wires this to turns (RC:284, :303; DEC:71–76).
- **Observation.** Changed paths and content hashes come from Core scanning the scratch, never from the Git index (RC:298).
- **The rest of the path:** capture, admission, lineage, integration, the guarded update of `main`, policy activation, and a ledger event for every workspace action (RC:280, :312; CORE:850–872).

### 3.3 The words used

| Term | Plain meaning | Source |
|---|---|---|
| Request | One promotion request, named by a UUIDv7 `request_id`. The same ID with the same submission gets the original answer; the same ID with anything changed is a mismatch. Knowing an ID grants nothing, and the time inside a UUID never sets order | CORE:850; DEC:397–398 |
| Lineage, checkpoint | The numbered requests from one scratch. Each new one must name the latest admitted one as its local parent; naming a skipped or stale one is refused before capture | CORE:852, :858 |
| Submission | What capture sealed for a request: the sealed tree, digests of the raw manifest and of the capture inputs, the bases it was measured from, who wrote each change (D23) and its admitted order. Later scratch edits never change it | CORE:852; RC:299; DEC:379 |
| Eligibility baseline | What counts as tracked for a capture: for the first checkpoint, the scratch anchor Core recorded; for a later one, its local parent's sealed tree, even while that parent is pending. The base the change is measured from is bound separately | CORE:854 |
| Train predecessor | The candidate ahead of this one in the workspace's request order, which this one is integrated on | CORE:858 |
| Generation | The submission merged onto its current predecessor, as a host commit. A new predecessor means a new generation and voids the old evidence | CORE:858, :864; RC:300 |
| Attempt | One run of the full required checks on one generation. Evidence is never reused for another attempt | CORE:850, :874 |
| Finalization intent | The durable record that commits Core to moving `main`. After it, cancellation is too late | CORE:866; DEC:409 |
| Acceptance | The durable ledger record written after the Git update has reached storage. Only this is acceptance; a moved ref alone is not | CORE:866; DEC:673 |
| Request states | `reserved/capturing`, `admitted`, `pending_integration_or_validation`, `ready`, `finalizing`, `accepted`; or one of the terminal states `rejected`, `conflict`, `cancelled`, `interrupted`, `no_change`, `dependency_failed`. Busy and unavailable mean not admitted: no snapshot is taken | CORE:856, :862 |
| Output visibility | A generation's outputs move `sealed`, `eligible`, `released`, or end `audit_only_obsolete` | CORE:878 |

### 3.4 A request in C2: refused as unavailable

1. **Request.** A context asks Core to promote work from its scratch. The request has a `request_id` and names its lineage's current admitted head, if there is one; Core authenticates the actor, context, workspace, scratch and grant (CORE:850, :852, :858).
2. **Identity check.** Before anything is captured, a repeat of a known ID returns that request's state, a changed binding is a mismatch, and a skipped or stale head is refused (CORE:850, :858; RC:355).
3. **Admission.** Core reserves, all at once, the authority, exclusive use of the scratch, one of the pair's four checkpoint slots, capture bytes, and validator, workspace and colony resources (CORE:856; RC:334). A fifth checkpoint for the pair, or a scratch already being captured, gets **busy** at once: no snapshot, queue, wait, retry or interrupted writer (CORE:856; RC:333–334; DEC:502).
4. **Unavailable.** C2 has no real validator to reserve. The request gets an explicit **unavailable** result: `main` does not move, no accepted promotion is recorded, and nothing waits behind the missing validator (RC:290, :320; DEC:342, :355). Because the validator is reserved before any snapshot (CORE:856), no snapshot is taken [INFERENCE from CORE:856 and RC:290]. This is boundary scenario 6 (RC:359) and ticket 05's "missing validator is unavailable" (T05:30).

C2 still builds and tests capture, lineage, integration and the guarded ref update as mechanisms (RC:408; T05:29), with the ref update tested in disposable repositories (RC:290; DEC:342). Through the product, every C2 request stops at step 2, 3 or 4. §5.5 notes what the sources leave open about testing this.

### 3.5 The same request once C4 exists: accepted

With C3 binding requests and C4's real validator in place (RC:313–314), the request continues:

5. **Capture.** Core lists the tracked files and the eligible untracked ones, and reads and hashes every candidate file in Git's stored form under the workspace's pinned capture inputs; the Git index and timestamps are never proof (CORE:854; RC:285, :328). Tracked edits and deletions are always in. A new file is in unless the scratch's own captured `.gitignore` or the pinned host exclusions leave it out (DEC:420, :540, :547; RC:328). Unsupported conversions, external clean/smudge filters, special files, path or case collisions, lossy normalization and exhausted caps refuse the capture (RC:285, :328, :372; CORE:854). The result is the submission, and the request is **admitted** (CORE:852, :856). Work in the scratch may go on; it never changes the submission (DEC:379; RC:323).
6. **Integration.** Core merges the submission onto its train predecessor with Git's explicit-base `git merge-tree --write-tree`, under controlled configuration and with no unapproved merge drivers, and makes a host integration commit with the predecessor as first parent. Git's exit status decides a **conflict**; a clean merge is not proof of correctness (CORE:858). The result is a generation (CORE:864; RC:300).
7. **No change.** If the generation's tree equals the tree of its actual, durably accepted predecessor, the request ends **`no_change`**: no checks, no intent, `main` stays, nothing is delivered (RC:335; DEC:509, :558).
8. **Validation.** C4 runs the full declared required set on that exact generation (RC:336; DEC:525), in at most four lanes in the colony and four per workspace, with at most four generations prepared, running or holding results ahead in a workspace (CORE:862). Each attempt needs fresh evidence (CORE:874). No model call is made for admission, status, results or delivery (CORE:862).
9. **Ready, then finalizing.** Once its evidence passes, the request is **ready** [INFERENCE from the state order in CORE:856]. It may finalize only after its local parent is accepted or proven `no_change` and its predecessor's outcome is proven durable (CORE:860; DEC:556). Core then writes the finalization intent and the request is **finalizing**. One finalization runs at a time per workspace, in request order, and from the intent on, cancellation reports "too late" (CORE:856, :864, :866; RC:325, :327).
10. **Update and acceptance.** Core moves `main` from the expected predecessor to the candidate with a guarded compare-and-swap, establishes that the update reached storage, records **acceptance**, then frees the slot (CORE:866; RC:327). Until acceptance is recorded, a moved ref is neither accepted nor visible as canonical (CORE:866; DEC:673).
11. **Result.** The accepted change is the step from predecessor to target: after A, request B delivers (M+A) → (M+A+B), with D23 authorship kept (DEC:559; RC:594). The original context sees the result on its next naturally scheduled turn or when it asks; finishing creates no model turn (RC:337; DEC:446).

### 3.6 When something goes wrong

- **A local parent fails** (cancelled, rejected, conflicted or interrupted): its later checkpoints become **`dependency_failed`**. Core voids their generations and stops their child processes, proving exit. Repair takes an explicit new root request with a fresh capture; old IDs never revive (CORE:860; RC:357).
- **A foreign predecessor leaves the train:** the surviving requests are rebuilt on the new predecessor and the full gate runs again; this is not a lineage failure. A speculative failure is not final until the predecessors resolve (CORE:860; RC:358).
- **Cancellation** is a separate command for one request, by the submitting context or you. A turn ending, `turn.cancel` or a closed view does not cancel, and a supervisor gains no authority from position (RC:325; DEC:389).
- **A crash** never re-executes work. With an intact intent and evidence, the workspace lock held, the old Git process stopped or fenced and no later intent, recovery reads `main`: still the predecessor, record **interrupted**; already the candidate, finish the acceptance bookkeeping without a second update; anything else, block publication (RC:340–348; CORE:866). Queued or speculatively validated requests proven not to have promoted end interrupted; trying again needs a new request ID (RC:348; DEC:370, :398).

### 3.7 Policy activation

C2 owns the transition that switches the colony's validation policy (CON:84; DEC:646):

- One pending activation per colony, which you authorize, binding the exact law, validation, check and environment hashes, the affected workspaces, the expected current policy record and a not-before UTC time. An ambiguous local time, or a time already past, is refused (CORE:868; DEC:463, :470).
- At or after that time, Core holds new finalizations in the affected workspaces, lets those already past their intent reach a proven outcome, then switches the one colony-wide policy in one ledger commit. If the trusted clock goes backwards, activation waits; the scheduled time is never backdated (CORE:870; DEC:453, :477).
- After a restart the same request resumes and is applied at most once (CORE:872).

### 3.8 What an agent may see

While a generation's predecessor is not yet durably accepted, its logs, reports, verdicts, conflicts, paths, hashes and artifacts stay sealed; the requesting context sees only its own receipt and a coarse status (CORE:878, :880). They are released to the original context only after that predecessor's acceptance is durable and reachable from `main`, the generation is still valid and the context still has read authority (CORE:882). Your audit is explicit and private; rank grants no raw access (CORE:880).

## 4. Decisions already settled that the approval rests on

Every entry the approved text cites, with its originator.

| Entry | By | What it settles | Source |
|---|---|---|---|
| D16 | owner | Private scratch per unit of work as Git worktrees, not clones; canonical changes only through Core promotion | DEC:14 |
| D17 | owner | One scratch per bound work context and workspace root; amended by D23 | DEC:15 |
| D18 | owner | Promotion is fast-forward only | DEC:16 |
| D22 | owner | An agent may run turns in several contexts at once; only a task's own turn writes to its scratch | DEC:59, :62 |
| D23 | owner | A second writer to a task gets a temporary scratch, merged back by fast-forward or `git merge-tree --write-tree`; a conflict becomes the agent's work; the ledger records each change's authoring context | DEC:71–76 |
| D27 | owner | Windows first, portable to macOS and Linux | DEC:102 |
| D32 | owner | The identity file is `Agent.md` exactly; Linux file names are case-sensitive | DEC:150 |
| D36 | owner | SHA-256 for bodies and the record chain; Git object IDs keep each repository's own format | DEC:179 |
| D37 | owner | Every ID is a UUIDv7; every unmatched operation start gets an interrupted end | DEC:186 |
| D38 | owner | Colony layout with `workspaces/` and `scratch/<short id>/`; short IDs because `core.longpaths` is unset | DEC:192 |
| D40 | owner | You freeze contracts; a frozen one changes only by addition; a breaking change needs a decision entry | DEC:206 |
| D41 | owner | Changes touching a frozen contract, an owner decision or a new dependency wait for you; no stub or fake of what a step waits for | DEC:213 |
| D42 | owner | One check command; a private GitHub remote with CI on Windows, Linux and macOS no later than C3 | DEC:219, :224 |
| D48 | owner | `main` is canonical, never checked out, moved by Core's compare-and-swap through the validation-gated path; humans use the same path | DEC:314 |
| D50 | owner | One Core-owned appender per colony; only core, router and the graph service use it | DEC:328 |
| D52 | owner | Path A: C2 mechanics, C3 runtime, C4 proves validated promotion; testing-only until C4 is Done; C2/C3 report promotion unavailable; you approve this boundary before C2 or C3 code | DEC:340–344 |
| D53 | owner | Core owns each request and returns its ID with a pending result; results belong to the original context; without the validator, unavailable and nothing queued | DEC:354–355 |
| D54 | owner | One serialized pipeline per workspace; superseded by D77 | DEC:362, :554 |
| D55 | owner | After a crash, reconcile facts and bookkeeping, never re-execute; requests proven not to have promoted end interrupted; an unresolved effect blocks the workspace | DEC:370 |
| D56 | owner | A request promotes its immutable submitted snapshot while scratch work goes on; amended by D77 | DEC:379 |
| D57 | owner | Cancellation is a separate, request-specific command by the submitting context or you; position grants no authority | DEC:389 |
| D58 | owner | Deduplicate by request ID: same ID and submission return the original state; a changed binding is a mismatch; different IDs stay separate | DEC:397 |
| D59 | owner | Durable intent, guarded Git update with durability, durable acceptance, then slot release; the intent closes cancellation; conditional recovery | DEC:408–411 |
| D60 | owner | Candidates hold tracked edits and deletions and non-ignored new files; the Git index is not authority | DEC:420 |
| D61 | owner (direction) | Policy changes justify fresh validation | DEC:428 |
| D62 | owner | One outstanding promotion per context and workspace; amended by B4 | DEC:437, :441 |
| D63 | owner | Results are passive: available at once, shown on the next natural turn, no completion-only model turn | DEC:446 |
| D64 | owner | At a policy change, hold new intents, finish intended finalizations, activate, then revalidate pre-intent requests | DEC:453 |
| D65 | owner | Only you authorize each exact validation-policy version | DEC:463 |
| D66 | owner | Activate now or at one not-before time, never as a bypass | DEC:470 |
| D67 | owner | One active validation-policy version colony-wide | DEC:477 |
| D68 | owner | Stop superseded validation children and confirm exit before replacement runs | DEC:484 |
| D69 | owner | Changed required checks or environments use the same controlled cutover | DEC:493 |
| D70 | owner | If exclusive capture cannot start now, return busy: no snapshot, waiting, queue or interrupted writer | DEC:502 |
| D71 | owner | A candidate tree identical to canonical ends as no-change, without checks, intent or ref move; D77 compares with the actual accepted predecessor | DEC:509, :558 |
| D72 | owner | C4 needs real declared automated checks; empty or invalid gates are unavailable; no human fallback | DEC:517 |
| D73 | owner | Run the full declared required set for every non-no-op candidate, without path or graph exclusion | DEC:525 |
| D74 | owner | Capture Git-compatible canonical contents under recorded normalization and attributes; raw disk hashes stay separate | DEC:533 |
| D75 | owner | Host-managed, pinned local and global exclusions, imported and reviewed at setup, fixed until deliberately updated; update authority left to this specification (P2) | DEC:540–541 |
| D76 | owner | The captured scratch's `.gitignore` governs that submission's new files and cannot hide tracked changes | DEC:547 |
| D77 | owner | Bounded parallel cumulative validation; only the successful prefix publishes, in request order, through one serialized finalizer; derived candidates and invalidation | DEC:554–560 |
| D78 | owner | Performance feasibility is part of the architecture; refusals are not throughput | DEC:567–569 |
| D111 | adopted | F0 ledger contracts frozen at version 1; C2 still needed D52's approval | DEC:1512, :1518 |
| B1 | build | LF line endings for this repository only | DEC:231 |
| B4 | assistant | Four-checkpoint FIFO per enrolled pair (amends D62); local ancestry kept apart from the train; a failed local parent ends its suffix | DEC:664–666 |
| B5 | assistant | Cumulative train and ordered finalizer; acceptance is the durable ledger fact; disclosure barrier; durable one-off activation; no evidence reuse | DEC:673–676 |
| B15 | assistant | Every-change capacity and whole-workload cost are gates; the 12/20-agent workload is a stated assumption; four lanes are a calibration | DEC:761 |

## 5. What remains unproven or open

Approving resolves none of this; it is listed so that you see it first.

### 5.1 Evidence C2 must produce

- The C2 mechanics: capture identity and tree equality, root and successor eligibility, deduplication and admission, the local-parent failure suffix, foreign-predecessor rebuild, conflict, busy, unavailable and conditional recovery (RC:408). The eight boundary scenarios describe them as design acceptance, not yet executed (RC:352–361).
- Full-tree capture and bounded admission and finalization proof (RC:565; RC:972); durable admission and capture, protected full-tree materialization, ancestry and integration, recovery and every-change capacity (CORE:253).
- Bounded normal and burst scenarios, with full-tree capture, materialization, integration and disk costs recorded against the D78/B15 workload; no throughput or capacity result is claimed (RC:411, :415, :972).
- Restart, incomplete private revision, storage pressure, unavailable validation and shutdown drills, and D42 cross-platform CI (RC:412).
- Activation under crashes before and after the hold and the activation commit, overdue restart with an unresolved finalization, clock rollback, cancellation and replacement races, stale authority or manifest, and same-ID replay; C1, C2 and C4 must prove these (CORE:872).
- Explicit durability handling and platform verification of Git objects, references and the ledger; the protocol does not itself prove power-loss resilience or protect against same-user ref manipulation (RC:348).
- Defender stays enabled for `scratch/`, costs are measured as they are, and the provisional resource profile may not silently reduce enrolled work (RC:378).

### 5.2 Evidence C4 and C10 must produce

- **C4:** the full D73 checks, O4/A1 and the complete preregistered V6 suite in validation §4.9.1, whole-generation output quarantine, actual acceptance and recovery, and every-change capacity evidence (RC:409); the BD2 barrier, activation and recovery and D77 ordering, with four-checkpoint admission exercised apart from the four lanes against 12/20-pair bursts and the actual larger workload (RC:974). The real scan cost is a blocking C4 feasibility gate (RC:285). C4 proves that the exact validated tree is promoted and recorded, that non-passing checks and a stale `main` prevent acceptance and that recovery cannot duplicate a promotion (DEC:344; RC:594).
- **C10:** prevent child changes to `main`, common Git metadata, the ledger, private contexts and owner IPC, and positively stop all descendants before slot or directory reuse (RC:410).

### 5.3 The F2 proposal C2 records

- **What F2 is.** The catalogue stage that adds C2's promotion records (RC:220; CORE:844): workspace, scratch, capture, immutable submissions, promotion, finalization and recovery, and policy activation (CON:38). Its records distinguish request and submission, local ancestry, derived generation, predecessor, attempt, durable intent, disclosure state and accepted result; F2 "remains a later freeze, not a current contract" (RC:221). Each family freeze names its type and version, payload owner, producer, permitted appender caller, consumers, privacy class, replay-essential fields and golden sample (CON:34).
- **Order.** C2's family is added only after this approval (CON:38). C2 records the F2 proposal before producer implementation (RC:407), and you freeze F2 under D40 before C2 implementation (CORE:844; RC:220). F2's types join the frozen `ledger-format` by addition, so they need your sign-off (DEC:206, :213; RC:288 for one such type).
- **Inputs it must reconcile.** The C2 rows of Undercurrent §15.1 (UC:612–617); the two scratch lifecycle events of RC:289, which §15.1 does not yet carry (UC:608–617); and the post-promotion interference-check event of RC:288, which UC:675 and RU:339 say is not a separate event.
- **Not stated by the sources.** Which C2 work, if any, may come before the F2 freeze: they say both "before C2 implementation" (CORE:844; RC:220) and "before producer implementation" (RC:407; also RC:271). Nor whether F2 is proposed and frozen once, or in parts as tickets 05–09 need it.

### 5.4 Marked items a build may revise (rule 6)

A build may revise a [PROPOSAL] or [INFERENCE] with a B entry; anything a document marks as awaiting you comes back to you (RM:232; RC:11). Inside the approved ranges there are five, all in RC; §§13.2–13.3 carry none.

1. RC:286 [INFERENCE]: "Files held open by running processes can block a worktree's removal".
2. RC:286 [INFERENCE]: "Paths are case-insensitive on Windows, unlike Linux (D32)".
3. RC:287 [PROPOSAL]: "Git operations go through the `git` program". §13.2 itself selects pinned Git's `git merge-tree --write-tree` for integration (CORE:858; RC:350). A revision that brings in a Go module needs its D29 record and your sign-off (AGENTS:39; DEC:213).
4. RC:288 [PROPOSAL]: the post-promotion interference check, a `git merge-tree` of each open scratch against the promoted change with a result event, which joins `ledger-format` by addition with your sign-off. Its integration belongs to C4's gate (RC:290). UC:675 and RU:339 say post-promotion overlap is not a separate `interference` event.
5. RC:289 [PROPOSAL]: scratch lifecycle events, *Scratch base advanced* and *Scratch closed*, with changed-path events carrying full current sets. U4 and U9 rely on them (RU:341, :530).

### 5.5 Points the approved text leaves to the build

RC:350 says "No technical/schema question below this point remains an owner-choice gate." These points are still unsettled in the approved text:

- **Git object retention.** D56 and D77 list "object retention" among the items for this specification (DEC:381, :560). §13.3 pins the bodies needed for finalization and failure obligations (CORE:882), and RC:348 requires explicit durability handling of Git objects and references; neither range says how the Git objects of sealed submissions and candidates are retained.
- **Scratch closure and retention.** Core §3.5 leaves them, with locked-file and case-collision handling and setup and materialization cost, to "scoped C1 decisions or C2/C4 evidence" (CORE:253); the lifecycle events are [PROPOSAL] (RC:289).
- **`CapacityProfile` values.** A profile is required, and a missing or invalid one means unavailable or busy (CORE:862). The text sets no values; profile values stay provisional until their runtime gates (DEC:762).
- **"Filter grants."** CORE:854 lists them among the pinned capture inputs, while external clean/smudge filters fail closed and D74 grants no executable filter (RC:372; DEC:534). No grantor is named.
- **Testing admission in C2.** Scenarios 1–5 admit requests (RC:354–358), yet every C2 product request is refused before capture (§3.4). The sources allow mechanical tests in disposable repositories and forbid any permissive validator, stub or fake (DEC:342; RM:231).

### 5.6 Wording slips in the cited text

- RC:286 says `core.autocrlf` is "(open, below)", but C2 has no open questions below. D74 settles the candidate representation (DEC:533), and Core §3.5 points to §13.2's capture inputs (CORE:246). The Appendix replaces the pointer.
- RC:372 says "exclusion review/update authority" is specified in §§13.2–13.3; CORE:854 requires "an explicit reviewed update" but names no reviewer. P2 settles it.
- Scope: RC:308 says "core §13", RC:350 and :406 say §§13.2–13.3, and Core §3.5 says §§13.2–13.4 (CORE:193, :197, :255). This packet follows RC:406.
- C2's status is named three ways: "*Not ready: design open*" (DEC:343), "Not ready for implementation: pending D52 owner approval" (RC:417) and "Waiting" (RM:170). After approval the two status lines, RC:417 and RM:170, become Ready; D52's wording stays as history (DEC:5).
- RC:289 says C1 adds the scratch lifecycle rows to Undercurrent §15.1 "when it drafts the catalogue". C1 is Done (RC:276) and the rows are not there (UC:608–617); F2 is where they land (§5.3).
- C2 has no "Exit criterion" line, which the step format asks for (RM:59). What marks C2 done is spread over RC:396, :408, :413, :565 and DEC:344.

### 5.7 Capacity reasoning on record (D78)

D78 asks for capacity reasoning before an affected design boundary is frozen, with assumptions, models and measurements kept apart (DEC:569; RM:234).

- **Assumption, not observed arrivals.** 12 or 20 code-working pairs, each offering one required change per 600 seconds: 72 or 120 an hour; and a synchronized burst of four checkpoints per pair, 48 or 80 requests (RC:338; DEC:570, :761).
- **Admission.** Four checkpoint slots per enrolled pair: 48 or 80 slots at 12 or 20 pairs (CORE:852).
- **Model, not a benchmark.** Ideal validation attempts an hour are 3600P/S. With P=4 lanes, 288 at S=50 s and 240 at S=60 s; with 25% extra validation per acceptance, 192 an hour at 60 s (CORE:229, :236, :240, :242). S covers checkout, checks and a filter allowance (CORE:229). Capture is not in S: it runs at admission, one capture at a time per physical scratch (CORE:856) [INFERENCE: CORE:229 does not list capture].
- **Target, a hypothesis.** Accepted capacity at least 1.25× steady demand, 90 or 150 an hour, with a stable backlog (RC:338; CORE:242).
- **Measurements on record.** Only A.7's single 2026-10-02 run on your machine: `git worktree add` of 10,000 files in 19–21 s; SHA-256 of every file of a freshly created 10,000-file worktree in 305 s, against 0.6 s for a stat-only walk; `git merge-tree --write-tree` in 0.09–0.15 s (CORE:1095, :1098, :1103). These are historical single runs, not throughput; the real scan cost is a blocking C4 feasibility gate (RC:285).
- **Our calculation, not in the sources.** At OG3 you set the actual larger enrolled population at 60 (DEC:1469). If all 60 were code-working pairs at the assumed rate, they would offer 360 changes an hour, above four lanes' ideal 288 or 240. The sources leave the larger workload to measurement (CORE:852; RC:338), call four lanes provisional (CORE:242; DEC:560) and ask that limits be reassessed from the results (DEC:569).

## 6. Your choices

### P1. Approve the boundary?

| Option | Consequence |
|---|---|
| 1. Approve as written | Section 8's entry is recorded with your answer to P2, and the Appendix's edits are made: status lines, one stale pointer and the two sentences that name exclusion authority. No mechanism changes. C2 becomes Ready and proposes its F2 event families, which you freeze before C2 implementation (§2.1, §5.3) |
| 2. Approve with named changes | Name the changes by section of this packet or by file and line. A follow-up documents change makes them; your approval is then recorded at its commit, marked modified (AGENTS:11). C2 stays Not ready until then |
| 3. Not yet | Nothing is recorded. C2 stays Not ready and its tickets 05–09 wait; C3, C10 and U3's foundation keep waiting behind C2 (RM:171, :180, :189). You may say what is missing |

**Recommendation: 1.** The text settles each subject D52 named (§1.2). What remains is evidence only building can produce (RC:402–415), your later F2 freeze, marked proposals a build may revise, and the slips in §5.6, none of which changes a mechanism; RC:350 records that no technical or schema question remains an owner-choice gate. Holding C2 would not buy design certainty: RC:308 says C2 waits "not because a technical mechanism remains unanswered". Approval keeps promotion unavailable and harness work testing-only (§2.2), and a later change to the approved text comes back to you (§2.2). Choose 2 if a point in §1.3 or §5 should change first, in particular B4's four checkpoints in place of your D62.

### P2. Who may change a workspace's pinned exclusions?

**What is open.** Your D75 pins each workspace's local and global exclusions: they are imported and reviewed at setup and kept fixed until deliberately updated, and D75 left the "import/update authority" to this specification (DEC:540–541). §13.2 says "Existing host excludes are displayed at setup; only an explicit reviewed update changes future captures, not an admitted submission" (CORE:854), but names no one who reviews or approves. RC:372 says the authority is specified there.

**Why it matters.** These exclusions decide which new, untracked files in every scratch of the workspace can enter a candidate; tracked files are always in (DEC:420, :547). D75 exists so that private-file exclusions are not silently dropped (DEC:540). An update affects future captures only (CORE:854).

| Option | Consequence |
|---|---|
| a. You alone | You review the imported exclusions at setup and approve each later update. Agents steer their own new files only through `.gitignore` edits inside their own submissions, which the candidate shows (DEC:547) |
| b. You, or a holder of an explicit grant you issue for that workspace | A trusted agent, such as an Orchestrator, can keep exclusions current without asking you, within a grant you can narrow or revoke (DEC:603–604). That agent could also remove a private-file exclusion, making those files capturable |
| c. Leave it to C2's build | An agent decides who holds this authority, in a B entry, although D75 placed it in the specification you approve (DEC:541). Not offered in the question |

**Recommendation: a.** The exclusions guard the private files D75 protects, and they shape every capture in the workspace. The nearest comparable authority, activating validation policy, is yours alone (DEC:463). Agents keep a visible path through `.gitignore` in their own submissions (DEC:547).

### No other choice

We found no other decision the sources leave to you. The remaining items in §5 are evidence still to be produced, your separate F2 freeze, marked proposals a build may revise, or wording.

## 7. The question

To send in the question tool, with this packet's path in place of .scratch/dwarf-harness/c2-evidence/d52-c2-approval-packet.md:

```text
Under D52 you approve the C2 promotion boundary before any C2 or C3 code is built. C1 is Done and F0 is frozen, so this is the last item C2 waits for. The packet is in your vault at .scratch/dwarf-harness/c2-evidence/d52-c2-approval-packet.md: what the approval covers (Core roadmap C2 and Core design §§13.2–13.3 at commit 5b07a9b), what it permits and what it does not, the boundary in plain terms, the decisions it rests on, what stays unproven, and one open choice: who may change a workspace's pinned exclusions, which D75 left to this specification. Whatever you choose, promotion stays unavailable until C4 and harness work stays testing-only. Nothing is approved until you answer and the decision entry is recorded.
```

| Label | Description |
|---|---|
| Approve (Recommended) | Approve the boundary as written; only you review and approve a workspace's pinned exclusions. Your entry and the status edits are recorded; C2 becomes Ready and proposes its F2 event families, which you freeze before C2 implementation. |
| Approve, exclusions delegable | As the first option, except that a holder of an explicit grant you issue for a workspace may also update its pinned exclusions. |
| Approve with changes | Name your changes. A follow-up documents change makes them, and your approval is recorded at its commit. C2 stays Not ready until then. |
| Not yet | Nothing is approved. C2 stays Not ready, ticket 05 waits, and C3, C10 and U3 keep waiting. You may say what is missing. |

## 8. Draft decision entry (not applied)

Written for "Approve". For "Approve, exclusions delegable", the exclusion bullet reads "only the colony owner, or a holder of an explicit grant the owner issues for that workspace (D82), reviews … and approves …". For "Approve with changes", the entry is **Decided by:** modified, states your changes and is recorded when the follow-up change lands, at its commit. For "Not yet", no entry is recorded. If you answer in your own words, the **Decided by** line and the quote follow them, as D111 did (DEC:1509–1511). Originators follow AGENTS:7–14.

```markdown
### D«D-NEXT». C2 promotion boundary approved (D52)

- **Date:** «DATE». **Decided by:** adopted. In the D52 approval request for Core step C2, which ticket 05 waits for, the owner picked "Approve" from the assistant's options; it also settles the exclusion authority that D75 left to this specification.
- **Owner's words (question tool):**
  > «OWNER-WORDS»
- **Decision:** The owner approves the promotion-boundary specification that D52 requires before C2 or C3 implementation, as it stands at commit 5b07a9b:
  - `ROADMAP-CORE.md` C2 (lines 278–417): the promotion boundary and who implements it, the recorded lifecycle choices, the recovery prerequisites and mapping, the selected promotion specification, the eight boundary scenarios, the snapshot choices, and the prerequisites and evidence;
  - Core §13.2, capture, immutable checkpoints and validation train (lines 848–874), and §13.3, the whole-generation disclosure barrier (lines 876–882), read under §13's opening paragraph;
  - with them, B4's amendment of D62 to a first-in-first-out queue of four checkpoints per enrolled code-working context/workspace pair, the B4 and B5 mechanisms those sections select, and B15's workload calibration, whose numbers stay calibration inputs;
  - **Exclusion authority (D75):** only the colony owner reviews the local and global exclusions imported at a workspace's setup and approves any later update of them. An update changes future captures only, never an admitted submission.
- **Not decided here:** No contract is frozen and no event shape is approved. C2 records its F2 catalogue proposal before producer implementation, and the owner freezes F2 under D40 before C2 implementation (`ROADMAP-CORE.md` C1 and C2; Core §13.1). Items the approved text marks [PROPOSAL] or [INFERENCE] keep their marks and stay revisable by B entry (`ROADMAPS.md` rule 6). The numbers the text calls provisional or calibration (four checkpoints per pair, four validation lanes, the four-generation window, the 1.25× target) stay so; they are not measured capacity, a colony-size cap or a service level. No evidence, capacity, durability or isolation result is claimed.
- **Consequences:** C2's last waits-for item is met, so C2 is Ready; its F2 family must be frozen under D40 before C2 implementation and is not yet proposed. Promotion stays unavailable in C2 and C3 builds, with no canonical change and no recorded acceptance until C4's real validator, and harness work stays testing-only until C4 is Done (D52). C3 still waits for C2 Done and the private remote with CI (D42). C4's D52 item is met; it still waits for C3, U1.L and a frozen `law-format`. C10, U3 and U4 keep their waits. A later change to the approved text, other than a marked item, touches this decision and waits for the owner (D41).
- **Changes:** `ROADMAP-CORE.md` (status line; Start here; in C2, the Windows-hazards pointer, the promotion-boundary paragraph, the selected-specification and exclusion-authority sentences, the D52 prerequisite row and Status; the C2 row of §3); `ROADMAPS.md` (status line, the two D52 paragraphs, C2's status-board row); `CONTRACTS.md` (promotion-boundary readiness); Core (the C2 status sentences in Start here, §3.5, §10 and §13, and §13.2's exclusion-update sentence); the validation research's readiness row and remaining-gates paragraph; the system specification's status sentence; the open item in this log, which this entry closes, and "See also" lines under D52 and D75; the answer line of the approval packet; ticket 05's comments.
```

## Appendix. Edits that record the approval (not applied)

Written for "Approve". For "Approve, exclusions delegable", edits 10 and 22 name "the owner, or a holder of an explicit grant the owner issues for that workspace". Each edit records the decision; none changes a mechanism. Before recording the entry, the applying change must confirm that RC:278–417 and CORE:848–882 are byte-identical to their text at 5b07a9b, the commit the entry names.

`docs/DECISIONS.md`

1. Append section 8's entry after D111.
2. DEC:28: replace the open-item row, which the entry closes, with a single row `| None | — | — |`, so that the "Open items awaiting the owner" table is not left empty.
3. After DEC:349, D52's last line: "- **See also:** D«D-NEXT» records the owner's approval of this boundary."
4. After DEC:542, D75's last line: "- **See also:** D«D-NEXT» settles the import/update authority: the colony owner alone."

`docs/ROADMAP-CORE.md`

5. RC:3: a new first status entry, "«DATE» (D52 promotion boundary approved, D«D-NEXT»; C2 Ready)".
6. RC:9: "C2 remains Not ready for implementation pending D52 approval/frozen dependencies." becomes "C2 is Ready: the owner approved its promotion boundary (D«D-NEXT»); its F2 family must be frozen under D40 before C2 implementation and is not yet proposed."
7. RC:286: "(open, below)" becomes "(settled by D74; capture inputs in core §13.2)".
8. RC:308: "The mechanisms are designed here and in core §13; C2 is **Not ready for implementation pending D52 owner approval**, not because a technical mechanism remains unanswered. This is design work that can be settled before C1 completes." becomes "The mechanisms are designed here and in core §13, and the owner approved this specification on «DATE» (D«D-NEXT»)." The paragraph's first and last sentences stay.
9. RC:350: "D52's formal approval," leaves the list of prerequisites that remain, and the sentence gains "D52's formal approval was given on «DATE» (D«D-NEXT»)".
10. RC:372: "exclusion review/update authority" becomes "exclusion review/update authority (the owner alone, D«D-NEXT»)".
11. RC:406: the row's text becomes "Approved «DATE» (D«D-NEXT»): the complete boundary in core §§13.2–13.3".
12. RC:417: "**Status.** Ready: D52 boundary approved «DATE» (D«D-NEXT»); proof not claimed. The C1 contracts it consumes are frozen (D111). Its F2 family must be frozen under D40 before C2 implementation; not yet proposed."
13. RC:972: "Formal D52 owner approval, full-tree capture" becomes "Full-tree capture".

`docs/ROADMAPS.md`

14. RM:3: a new first status entry, as in edit 5.
15. RM:17: the sentences saying owner approval is still required and C2 is not implementation-ready become: the owner approved the integrated Core C2 specification on «DATE» (D«D-NEXT»); C2's own F2 family must be frozen under D40 before C2 implementation and is not yet proposed.
16. RM:33: "Explicit owner approval of the integrated C2 boundary is still pending" and "C2/C3 remain not-ready until owner approval and frozen dependencies" become: the owner approved it (D«D-NEXT»); C2 is Ready; C3 waits for C2 Done and the remote with CI.
17. RM:170: status "Waiting" becomes "Ready".

`docs/CONTRACTS.md`

18. CON:82: "D52 approval is still pending and this register, decision log or a proposed event shape is not that approval." becomes "The owner approved it on «DATE» (D«D-NEXT»); this register and any proposed event shape still freeze nothing."

`docs/DESIGN-CORE-AND-LAUNCHERS.md`

19. CORE:23, :39, :201 and :824: "C2 remains Not ready … pending … D52 owner approval …" becomes "C2 is Ready after the owner's D52 approval (D«D-NEXT»)".
20. CORE:255: "formal D52 owner approval," leaves the remaining readiness gates.
21. CORE:728: item 1 gains "(approved «DATE», D«D-NEXT»)", as item 2 records D111.
22. CORE:854: "only an explicit reviewed update changes future captures" becomes "only an explicit update that the owner reviews and approves (D«D-NEXT») changes future captures".
23. CORE:999: "D52 owner approval of the promotion boundary;" leaves the gates that remain.

Other files

24. RAV:371: "Owner D52 approval and C1 freezes remain prerequisites" becomes "D52 approval is recorded (D«D-NEXT»); the F2 freeze remains a prerequisite".
25. RAV:380: "C2 is Not ready until its mechanics, persistence/recovery, capture/finalization, and every-change capacity are implemented and evidenced" becomes "C2 is Done only when its mechanics, persistence/recovery, capture/finalization, and every-change capacity are implemented and evidenced". The clause before it, "D52 owner approval and C1 contract freezes precede C2 implementation", states the gate as a rule and stays.
26. SPEC:679: "and D52 approval is pending" becomes "and the C2 boundary is approved (D«D-NEXT»)".
27. T05: a comment recording the approval, the entry and that F2 precedes its producer implementation.

Unchanged: D52's own text, since entries are not edited (DEC:5); dated history comments (RM:241, :245; CON:110, :114; `docs/ROADMAP-GUI.md:156`); SPEC:673, a snapshot of the publication boundary; and lines stating the gate as a rule, which stay true (RC:376, :378; RAV:373; SPEC:693).
