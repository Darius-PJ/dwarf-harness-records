# OG5: freeze request for F2-05, ticket 05's part of F2

**Prepared:** 2026-10-12, against commit d4e3032 on branch `build/05-f2`, which is `main` at b663791 plus S2 (31103d8) and its fix-up. For C2 and ticket 05. **Answer:** 2026-10-12, "Freeze as presented". [D115](../../../docs/DECISIONS.md#d115-f2-05-workspace-and-scratch-records-frozen) records the freeze from section 8's draft, and Appendix A.2's edits record it in the register, the roadmaps and ticket 05; S2 reached `main` as bce48a0. The rest of this packet stays as sent.

Ticket 05 has drafted the first records of C2's F2 family: four `workspace.*` record types in `contract/ledger`, the package that holds your frozen `ledger-format` (D111, DEC:1515–1516). Your answer to OG-B froze F2 in parts, each part before the code that writes it, and left this part's freeze as "a later and separate owner question" ([D113](../../../docs/DECISIONS.md#d113-c2s-f2-freeze-in-parts-each-part-before-the-code-that-writes-it), DEC:1642–1646). This packet asks that question. S2, the draft, reaches `main` only with your freeze, and S3, the code that writes these records, waits for it (DEC:1646). Take the time you need.

**In short.** You are asked to freeze four record types that Core's workspace service will write: a workspace's registration, each revision of the capture inputs you approve for it, the creation of a context's private scratch, and the scratch's closure (§2). They are added to `ledger-format` version 1, which you froze on 2026-10-10. The record envelope, F0's four types, the reader and the appender do not change (§5.5). Freezing lets S2 reach `main` and S3 start (§3.1). Afterwards the four types change only by addition (§3.2). Seven questions show what the freeze fixes, each with our recommendation, and an eighth notes what stays Core policy (§6). All of them fold into one answer, "Freeze as presented", which we recommend (§7).

Citations are `file:line` at `main` b663791; "RC:289, :417" means lines 289 and 417 of the same file. DOC is cited by section and REG by line, both as they stand at d4e3032; Appendix B reproduces the relevant `go doc` output.

| Short | File |
|---|---|
| DOC | `contract/ledger/doc.go` at d4e3032, the package documentation |
| REG | `docs/CONTRACTS.md` at d4e3032 |
| DEC | `docs/DECISIONS.md` |
| CON | `docs/CONTRACTS.md` at b663791 |
| RC | `docs/ROADMAP-CORE.md` |
| RM | `docs/ROADMAPS.md` |
| UC | `docs/DESIGN-UNDERCURRENT.md` |
| RU | `docs/ROADMAP-UNDERCURRENT.md` |
| CORE | `docs/DESIGN-CORE-AND-LAUNCHERS.md` |
| SPEC | `.scratch/dwarf-harness/spec.md`, the system specification |
| T05 | `.scratch/dwarf-harness/issues/05-create-private-scratch-and-capture-exact-eligible-trees.md` |
| BRIEF | `.scratch/dwarf-harness/c2-evidence/ticket-05-design-brief.md` |
| RULING | `.scratch/dwarf-harness/c2-evidence/ticket-05-design-ruling.md` |
| AGENTS | `AGENTS.md` |

## 1. What is requested

Freeze F2-05 by addition to `ledger-format` version 1 (D40, DEC:206; D111; D113), at commit d4e3032. That commit is `main` at b663791 plus two commits on branch `build/05-f2`: S2, 31103d8, and its fix-up, the test and documentation corrections the build advisor's review of S2 asked for (step R0 of Appendix C lists its files). d4e3032 is not on `main`. S2 adds to a frozen contract, so it waits for your sign-off (D41, DEC:213); with your freeze it reaches `main` by fast-forward, after a rebase that leaves `contract/ledger` byte-identical (Appendix A.0).

F2-05 is:

- **four record types,** each at version 1: `workspace.registered`, `workspace.capture_inputs_pinned`, `workspace.scratch_created` and `workspace.scratch_closed` (§2, §4.3);
- **their payloads and value rules,** including two path grammars, each capped at 4,096 bytes (§4.2);
- **their record rules,** which Core's workspace service checks when it appends and when it opens a log, where F0's record rules are checked by Core's store (§4.1);
- **`Defined()` extended** from F0's four type versions to eight, with the namespace `workspace.` reserved for C2's record families (DOC, Catalogue);
- **the golden file** `contract/ledger/testdata/f2/05/log/00000000000000000001.jsonl`, SHA-256 843663a168e472adf4656fdba4ffa6db770e588feec0020bb10e20bf14def437 (§4.5). The three F0 golden files keep D111's digests, c72c4a73…, 3ee9f566… and 319c8053… (DEC:1519).

`ledger-format` stays version 1 (Q6). S1, ticket 05's record-free part, does not depend on this freeze (DEC:1644).

Section 8 holds a draft decision entry, and Appendix A the edits that record the request and the freeze. Only Appendix A.1, which records that the request was sent, is applied before your answer.

## 2. The four records in plain words

### 2.1 What each record means and when Core writes it

A record names an actor: the party it is attributed to (D35, DEC:172). Records written together form a commit.

- **`workspace.registered`** is written when you register a Git repository as a workspace, with you as its actor. It holds the workspace's ID, the repository's Git directory as Git prints it, such as `C:/Users/you/project/.git`, and whether the repository uses SHA-1 or SHA-256 object IDs. The same commit holds the first `workspace.capture_inputs_pinned` and its pin.
- **`workspace.capture_inputs_pinned`** is written at registration, as revision 1, and each time you approve a new set of capture inputs, as revision 2, 3 and so on. The inputs are your line-ending settings and the ignore and attribute files you reviewed (D75; D112). The record holds only a digest of that set and a pin ID. The set itself is stored as bodies, and the pin keeps them from collection while the revision is current. An update pins the new set and releases the old one in one commit.
- **`workspace.scratch_created`** is written by Core the first time a context uses a workspace. It holds the scratch's ID, its workspace, the context that owns it, its directory and branch names, the `main` commit it was cut from, and that commit's tree. Every later capture is measured against that tree (CORE:854).
- **`workspace.scratch_closed`** is written when you, or the agent of the scratch's own context, close the scratch. In this version the only reason Core writes is `abandoned`.

### 2.2 Points to know

1. **A host path, which can contain your user name, is in every `workspace.registered` record** (Q3). Every reader of the colony log sees it, and the privacy class says so (§4.4). The bodies behind `workspace.capture_inputs_pinned` hold your ignore and attribute patterns, which can name private files. Those bodies are read only through Core's authorized body reads (C3), not from the record.
2. **`reason` is an open token** (Q2). Version 1 defines `abandoned`. Later parts of F2 add reasons such as `temporary_merged_back` and `promoted` by addition, and a reader that meets a reason it does not know still reads the closure.
3. **Unknown keys are ignored.** A decoder skips payload keys it does not know, so a later version can add optional keys and older readers keep working. A missing required key, a repeated key or a null known key is refused (DOC, F0 and F2-05 record types).
4. **Git object IDs are 40 or 64 lowercase hex digits**, 40 for SHA-1 repositories and 64 for SHA-256. A decoder accepts either length. That the length matches the workspace's object format is a record rule, which Core's service checks, not the decoder (DOC).
5. **Core's branch naming is a service rule, not a contract rule.** The contract accepts any branch under `refs/heads/` that meets the grammar of §4.2. Ticket 05's scratches use `refs/heads/dwarf-harness/<dir>`, but that is Core's rule, so later kinds of scratch may name branches differently (DOC).
6. **Only `internal/core/workspace` may append these types.** Review enforces that, because `tools/check` cannot express it, as review checks under B18 item 5 that production callers pass `ledger.Defined()` (DEC:1211). The store itself accepts these types from any permitted appender caller (CON:27) once they are in `Defined()`.
7. **Special characters are stored escaped.** Encode writes `<`, `>` and `&` inside strings as `\u003c`, `\u003e` and `\u0026`, as Go's `encoding/json` does and as the F0 golden already shows (`contract/ledger/testdata/f0/log/00000000000000000001.jsonl`, seq 2). A `common_dir` containing them is stored escaped, decodes to the original characters and re-encodes to the same bytes. This is F0's encoder, not a new rule.

## 3. What freezing means

### 3.1 It permits

- **S2 to reach `main`.** It reaches `main` with the commit that records your freeze (DEC:1646; D41, DEC:213).
- **S3 to start.** Core's workspace service, which writes these records, starts once your entry is on `main` (DEC:1646). This also meets ticket 05's start gate for its own producer family (T05:22).
- **Others to build against the four types** once their other prerequisites hold. Freezing is the moment another roadmap may build against a contract (CON:19). U3's foundation still waits for C2 (RM:189), and U4 and U9 wait for more (RM:190, :195).

### 3.2 What stays changeable

A frozen contract changes "by addition only: new optional fields, new types, new type versions with upgraders" (CON:16; DEC:206). For F2-05:

- ticket 07 may add an optional parent-scratch key to `workspace.scratch_created` for temporary scratches (UC:612; RULING:37);
- later parts of F2 add their own types under `workspace.` (D113, DEC:1647);
- new `reason` tokens need no new version (Q2).

### 3.3 What changes only with your decision entry

Every key, type, presence and value rule of the four types, including both grammars and their 4,096-byte caps; every record rule; the namespace reservation; and every golden byte. A breaking change needs your decision entry listing every step it affects, and the golden tests catch one made without it (DEC:206; CON:17).

### 3.4 What the freeze does not do or claim

- **No producer exists yet.** S3 writes these records only after the freeze, and "schema availability does not claim that a producer is operational" (CON:34).
- **F0 and the rest of `ledger-format` are unchanged:** the record envelope, commits, caps, segments, the reader and the appender, and the three F0 golden files (§5.5).
- **No later C2 record is frozen.** Each of these joins with its own part (DEC:1642–1647):
  - requests, submissions, admission and generations (ticket 06);
  - temporary scratch and merge-back (07);
  - finalization, cancellation and recovery (08);
  - activation (09);
  - *scratch base advanced* (RC:289).
- **Core policy stays Core policy** (Q8).
- **No capacity, durability or platform result is claimed** beyond §5.

## 4. The frozen surface

The package documentation is the format: "this documentation is the format" (DOC, opening). Until the documents commit that records your freeze, it calls F2-05 "proposed". Edits F9–F14 change only that wording.

### 4.1 Common rules

From DOC, F2-05 record types:

```text
These four proposed version-1 types are ticket 05's part of F2. C2 owns
their payload specifications. Only Core's workspace service
(internal/core/workspace) may append them, through appender.Appender;
permitted callers are enforced by review. The service checks the record
rules both when appending and at Open. Check, Reader, EncodeCommit and
these payload encoders and decoders do not enforce service record rules.

Payloads follow the F0 encoding rules above: compact JSON, keys in the
tabled order, errors wrapping ErrInvalid, no missing required, null known
or repeated keys, and unknown keys ignored for additive evolution.
Re-encoding a decoded payload reproduces the bytes Encode produced.
Git object IDs are 40 or 64 lowercase hex digits. A decoder accepts either
length; matching the workspace's object_format is a service record rule.
```

F0's encoding rules (DOC, F0 record types) also refuse an ID that is not a canonical lowercase UUIDv7, a digest that is not 64 lowercase hex digits or is zero, and an integer with a sign, fraction or exponent, or out of range.

### 4.2 The two path grammars, word for word

Every value rule a frozen decoder enforces is permanent, so both grammars are quoted here exactly as DOC states them (DOC, F2-05 record types). They are lexical and byte-exact, they are the same on every host, and the decoder checks neither whether a path exists nor whether it is valid on the platform.

`common_dir`:

```text
common_dir accepts exactly: valid UTF-8; 1–4,096 bytes; no byte below
0x20 and no 0x7F; no backslash; forward slashes only; absolute in one of
three forms: POSIX /…, drive-rooted [A-Za-z]:/…, or UNC //host/share…
with non-empty host and share; no empty component (no // except the two
leading UNC slashes); no component . or ..; no trailing /. Everything
else is refused with an error wrapping ErrInvalid.

This is Git's forward-slash string from rev-parse --path-format=absolute
--git-common-dir, unchanged by Core. Drive-letter case is kept as Git
printed it; the decoder does not fold case. This grammar is lexical,
byte-exact and identical on every host; it checks neither existence nor
platform validity, and makes no host calls. The 4,096-byte cap is a
contract rule, not a producer policy that may be tightened after freeze.
```

`branch`:

```text
branch accepts exactly: valid UTF-8; begins refs/heads/; non-empty suffix;
at most 4,096 bytes; no byte below 0x20 and no 0x7F; no space and no
backslash; no empty component (no //); no trailing /. Everything else is
refused with ErrInvalid. This is a lexical, byte-exact subset, identical
on every host. The decoder checks neither existence nor platform
validity. The 4,096-byte cap is a contract rule.

Git's remaining lexical rules (.., @{, lone @, .lock, leading-dot or
trailing-dot components, ~ ^ : ? * [) are the producer's: Git itself
refuses them when Core creates the branch, so the decoder does not
re-implement them. Core's own naming scheme is a service record rule,
not a contract rule: ticket 05's dedicated scratches use
branch == "refs/heads/dwarf-harness/" + dir.
```

Two consequences:

- A registration of one repository under two spellings is not something the grammar can catch. Core compares the directories themselves at registration (BRIEF §2.6, step 2).
- A branch name that Git would refuse never reaches the decoder, because Git refuses it when Core creates the branch.

### 4.3 The four types

The tables and record rules are DOC's, set as Markdown tables; where DOC says "below", §4.2 holds the grammar. The Go types, their decoders and their `Encode` methods are in Appendix B.

**`workspace.registered` v1** (`WorkspaceRegistered`) registers a Git workspace with the owner's approval.

| key | type | presence | rule |
|---|---|---|---|
| `workspace_id` | UUIDv7 | required | the workspace's ID |
| `common_dir` | string | required | the absolute common-directory grammar (§4.2) |
| `object_format` | string | required | `sha1` or `sha256` |

Record rules: actor is owner; `body_refs` is absent. This is index 0 of a three-record commit: index 1 is its `workspace.capture_inputs_pinned` with revision 1, and index 2 is that record's `ledger.body_pin`. `workspace_id` is new, and no earlier registration names the same `common_dir`.

**`workspace.capture_inputs_pinned` v1** (`CaptureInputsPinned`) records one owner-approved revision of the workspace's capture inputs.

| key | type | presence | rule |
|---|---|---|---|
| `workspace_id` | UUIDv7 | required | a registered workspace |
| `revision` | integer | required | 1 through MaxInt64 |
| `capture_inputs_sha256` | digest | required | SHA-256 of the capture-inputs document, a body |
| `pin_id` | UUIDv7 | required | the `ledger.body_pin` of this revision |

Record rules: actor is owner. `body_refs` is present and holds exactly the document and every body it names. The same commit holds a `ledger.body_pin` with this `pin_id` and the same `body_refs`. Revision 1 appears only at index 1 of the registration commit. Each later revision is the current revision plus 1, at index 0 of its commit, with its pin at index 1 and the `ledger.body_unpin` of the previous revision's `pin_id` at index 2.

**`workspace.scratch_created` v1** (`ScratchCreated`) records a context's private scratch worktree and its trusted root eligibility baseline.

| key | type | presence | rule |
|---|---|---|---|
| `scratch_id` | UUIDv7 | required | the scratch's ID |
| `workspace_id` | UUIDv7 | required | a registered workspace |
| `context_id` | UUIDv7 | required | the bound work context that owns the scratch and authors its changes |
| `dir` | string | required | 8 lowercase hex digits; `scratch/<dir>` in the colony directory |
| `branch` | string | required | the `refs/heads/` grammar (§4.2) |
| `base_commit` | Git object ID | required | the canonical commit the scratch was cut from |
| `anchor_tree` | Git object ID | required | that commit's tree, the root eligibility baseline |

Record rules: actor is core; the envelope's `context_id` equals this `context_id`; `body_refs` is absent. `scratch_id` is new; the pair (`context_id`, `workspace_id`) has no open scratch. `dir` and `branch` were never used by an earlier scratch. Both Git ID lengths match the workspace's `object_format`.

**`workspace.scratch_closed` v1** (`ScratchClosed`) records an explicit closure.

| key | type | presence | rule |
|---|---|---|---|
| `scratch_id` | UUIDv7 | required | an open scratch |
| `context_id` | UUIDv7 | required | the scratch's context |
| `reason` | string | required | `^[a-z][a-z0-9_]*$`, at most 64 bytes |

"Version 1 defines reason abandoned. Reason is an open token: both Encode and Decode accept every well-formed token, including unknown future reasons. A reader treats one as a closure for a reason it does not know, never as invalid. Core writes only reasons its reading version defines; this is a producer rule, not an encoding rule" (DOC).

Record rules: actor is owner, or agent with the envelope's `context_id` equal to this `context_id`; `body_refs` is absent. A scratch closes at most once, and `context_id` is the scratch's.

### 4.4 The register table

REG's F2-05 table, with the eight attributes B2 asks of every catalogue freeze (DEC:648; CON:34). The last column gives the sequence numbers of each type's records in the golden file (§4.5).

| Type, version 1 | Payload owner | Producer | Permitted appender caller | Consumers | Privacy class | Replay-essential fields | Golden sample |
|---|---|---|---|---|---|---|---|
| `workspace.registered` | C2 | Core's workspace service, at the owner's registration | `internal/core/workspace` only (review) | Core's workspace service (replay); C3 (workspace binding); U3 foundation, U4, U9; owner inspection | identifiers and a host path to the repository's Git directory; no file content | `workspace_id`, `common_dir`, `object_format` | seqs 1, 4 |
| `workspace.capture_inputs_pinned` | C2 | as above, at registration and the owner's updates | as above | Core's capture and materialization; C4's candidate materialization (the same inputs); owner inspection | identifiers and digests. The referenced bodies hold the owner's ignore and attribute patterns, which can name private files, and are read only through Core's authorized body reads (C3) | all four payload keys and `body_refs` | seqs 2, 5, 9 |
| `workspace.scratch_created` | C2 | as above, on a context's first use | as above | Core's workspace service; C3 (the scratch a context's tools use); U3, U4 (open scratches), U9 (occupancy) | identifiers, a branch name and Git object IDs; no file content | all seven payload keys | seqs 7, 8 |
| `workspace.scratch_closed` | C2 | as above, at an explicit closure | as above | as for `workspace.scratch_created` | identifiers and a reason | all three payload keys | seq 12 |

### 4.5 The golden file

`contract/ledger/testdata/f2/05/log/00000000000000000001.jsonl`, SHA-256 843663a168e472adf4656fdba4ffa6db770e588feec0020bb10e20bf14def437.

- **Contents.** One LF-only segment (B1) holding six commits and twelve records.
- **IDs and times.** Its IDs are fixture UUIDv7s whose last digits are given below: colony …0003, workspaces …0041 and …0042, pins …0021–…0023, scratches …0051 and …0052, contexts …00d1 and …00d2. Its event times run from 1791000020000000000 to 1791000025000000000.
- **How it is checked.** `TestGoldenF2_05` builds the file with `EncodeCommit` and the F2-05 encoders and compares it byte for byte; `-update` regenerates it unchanged (R5). `TestGoldenDecodes` reads it back through the reader.

| Seq | Commit | Type | Actor | Payload, in short |
|---|---|---|---|---|
| 1 | c1, 3 records | `workspace.registered` | owner | workspace …0041; `C:/fixture/repo-a/.git`; `sha1` |
| 2 | c1 | `workspace.capture_inputs_pinned` | owner | workspace …0041; revision 1; document 338081c1…; pin …0021; `body_refs` 1ae0f069…, 338081c1… |
| 3 | c1 | `ledger.body_pin` | owner | pin …0021; the same `body_refs` |
| 4 | c2, 3 records | `workspace.registered` | owner | workspace …0042; `/fixture/repo-b/.git`; `sha256` |
| 5 | c2 | `workspace.capture_inputs_pinned` | owner | workspace …0042; revision 1; document 6024fedf…; pin …0022; `body_refs` 6024fedf… |
| 6 | c2 | `ledger.body_pin` | owner | pin …0022; the same `body_refs` |
| 7 | c3, 1 record | `workspace.scratch_created` | core, envelope context …00d1 | scratch …0051 in workspace …0041 for context …00d1; `dir` `0a1b2c3d`; branch `refs/heads/dwarf-harness/0a1b2c3d`; 40-digit base commit and anchor tree |
| 8 | c4, 1 record | `workspace.scratch_created` | core, envelope context …00d2 | scratch …0052 in workspace …0042 for context …00d2; `dir` `4e5f6a7b`; branch `refs/heads/dwarf-harness/4e5f6a7b`; 64-digit base commit and anchor tree |
| 9 | c5, 3 records | `workspace.capture_inputs_pinned` | owner | workspace …0041; revision 2; document 4222f3fe…; pin …0023; `body_refs` 1ae0f069…, 4222f3fe… |
| 10 | c5 | `ledger.body_pin` | owner | pin …0023; the same `body_refs` |
| 11 | c5 | `ledger.body_unpin` | owner | pin …0021, revision 1's |
| 12 | c6, 1 record | `workspace.scratch_closed` | agent, envelope context …00d1 | scratch …0051; context …00d1; reason `abandoned` |

**What the golden covers:**

- a drive-rooted path and a POSIX path;
- both Git ID lengths;
- revisions 1 and 2, with the pin and unpin of an update;
- a closure by the scratch's own agent.

The UNC form of `common_dir` is covered by tests, not by the golden (§5.6).

## 5. Evidence

The build advisor reviewed S2 at 31103d8, on a runner's evidence collected in a separate worktree of that commit, and approved it with changes. The changes are the fix-up in d4e3032.

- §5.2 holds the results of the commands of Appendix C, run again at d4e3032.
- §5.3 keeps the record of 31103d8 for comparison.

### 5.1 What each check shows

| Step | Check | What it shows | Expected |
|---|---|---|---|
| R0 | Commit identity | The commit presented is d4e3032: S2 and its fix-up on b663791, with no golden byte changed by the fix-up | As described |
| R1 | Every test of `contract/ledger` and `internal/core/ledgerstore`, run twice | Every test passes, F0's included. The fix-up made the refusal test's shape deterministic, so both runs list the same tests | Exit 0 twice; no `--- FAIL`; 4 skips, the helper and harness tests; identical test lists; no `#`-suffixed F2-05 subtest |
| R2 | `FuzzDecodeF2_05` and `FuzzCheckTruncation`, 120 s each | No input breaks a decoder; a decoded payload re-encodes and decodes to the same value; a log cut at any commit boundary of the new golden still checks correctly | Both pass; no new file under `testdata` |
| R3 | `go list -deps` | `contract/ledger` still imports only the standard library | One line: the package itself |
| R4 | `go mod tidy -diff`, `go mod verify` | No dependency is added (D29) | No diff; all modules verified |
| R5 | `-update` on the golden tests, then `Get-FileHash` | The goldens regenerate byte for byte; F0's keep D111's digests | No change; the four digests of §1 |
| R6 | `git ls-files --eol` | The new golden is stored with LF (B1) | `i/lf w/lf` |
| R7 | `gofmt -l`; `go vet` for Linux and macOS | Formatting and a cross-platform vet | Nothing listed; no finding |
| R8 | `go run ./tools/check`, with `DWARF_CC` set | All nine check steps, including race tests, import boundaries and cross builds | All nine pass |
| R9 | `git diff` against b663791 | Additivity: which existing lines S2 removed | The 14 lines of §5.5, no others |
| R10 | Line lengths of the golden | The size of each record, for §5.8 | Twelve lengths, each under 1 KiB |
| R11 | `go doc -all` | The surface of Appendix B | Appendix B |
| R12 | The grammar paragraphs in `doc.go` | §4.2's quotation matches the source | Word for word the same |

### 5.2 Results at d4e3032

| Step | Result |
|---|---|
| R0 | HEAD d4e3032; `b663791..HEAD` lists only the fix-up and 31103d8; tree clean; the fix-up changes only `doc.go`, `golden_test.go` and `workspace_test.go`; testdata identical to 31103d8 (d4e3032, 2026-10-12) |
| R1 | `go test -count=1 -v ./contract/ledger ./internal/core/ledgerstore`, twice: each run exit 0, 417 PASS, 0 FAIL, 4 SKIP (child-process helpers and the gated workload); no `#`-suffixed F2-05 names; identical test-name sets (d4e3032, 2026-10-12) |
| R2 | `FuzzDecodeF2_05` 120 s: PASS, 3,639,569 execs; `FuzzCheckTruncation` 120 s: PASS, 59,269 execs; testdata unchanged (d4e3032, 2026-10-12) |
| R3 | Non-standard imports of `contract/ledger`: only itself (d4e3032, 2026-10-12) |
| R4 | `go mod tidy -diff`: no change; `go mod verify`: all modules verified (d4e3032, 2026-10-12) |
| R5 | `-update` changes no golden; F0 goldens c72c4a73…, 3ee9f566…, 319c8053… (equal to D111) and the F2-05 golden 843663a1… (d4e3032, 2026-10-12) |
| R6 | `contract/ledger/testdata/f2/05/log/00000000000000000001.jsonl`: `i/lf w/lf` (d4e3032, 2026-10-12) |
| R7 | `gofmt -l contract/ledger`: nothing; `go vet` for linux and darwin: exit 0 (d4e3032, 2026-10-12) |
| R8 | `go run ./tools/check`: all nine steps pass, in a quiet window (d4e3032, 2026-10-12). A first run on this commit, while three other heavy jobs ran on the machine, failed only the race step: `internal/core/ledgerstore`'s `TestBodiesConcurrentUse` timed out its one-minute throughput assertion ("138 references acknowledged within a minute, want 200"). That test is ticket 03's and unchanged here; alone under the race detector it passed three of three runs at about 14 s each. It is load-sensitive; the finding is recorded as a comment on ticket 03, whose test it is, in this request's send-time documents commit |
| R9 | Changes since b663791 in `contract/ledger`: additions plus the 14 removed lines quoted in §5.5 (the catalogue literal restructured, the authorized catalogue-test change, reworded doc lines); no exported identifier, encoding rule or F0 golden byte changes (d4e3032, 2026-10-12) |
| R10 | The golden's 12 records are 458–850 bytes each (each under 1,024) (d4e3032, 2026-10-12) |
| R11 | `go doc -all ./contract/ledger` excerpt: Appendix B (d4e3032, 2026-10-12) |
| R12 | `doc.go`'s `common_dir` and `branch` grammars are word for word §4.2's quotations (d4e3032, 2026-10-12) |

### 5.3 The record at 31103d8

The runner's record of 2026-10-12, which the build advisor reviewed. R1 ran once there; R10 and R12 did not run.

| Step | Result at 31103d8 |
|---|---|
| R0 | Parent b663791; worktree clean |
| R1 | 421 tests and subtests ran: 417 passed, 4 skipped (`TestHelperChildWriter`, `TestHelperChildSubmitter`, `TestWorkload`, `TestHelperWorkloadChild`), none failed; `ok` for `contract/ledger` (3.961 s) and `internal/core/ledgerstore` (44.610 s) |
| R2 | `FuzzDecodeF2_05`: 2,671,587 executions in 120 s, PASS. `FuzzCheckTruncation`: 47,376 executions in 120 s, PASS. No new file under `testdata` |
| R3 | `github.com/Darius-PJ/dwarf-harness/contract/ledger` only |
| R4 | `go mod tidy` left `go.mod` and `go.sum` unchanged; `go mod verify`: all modules verified |
| R5 | `-update` changed nothing; the four digests equal those of §1 |
| R6 | `i/lf w/lf attr/text=auto eol=lf` |
| R7 | `gofmt` listed nothing; `go vet` for Linux and macOS found nothing |
| R8 | `check PASSED: all 9 steps passed` |
| R9 | 10 files, 754 insertions, 16 deletions; 14 removed lines in `contract/ledger` (§5.5), the other 2 in `docs/CONTRACTS.md` |
| R11 | 782 lines of `go doc -all`, holding the four constants, the four payload types, their decoders and `Encode` methods |

The advisor found that the refusal test mutated a map while ranging over it, so its subtest count could vary between runs; outcomes were unaffected. The fix-up iterates over sorted keys, and R1's two runs at d4e3032 show the effect.

### 5.4 Six deliberate rule breaks

The coder broke one rule at a time, ran the F2-05, golden and catalogue tests, and restored the code; each restoration passed.

| Break | Tests that failed |
|---|---|
| a. The decoder rejects an unknown payload key | `TestF2_05PayloadsRoundTrip/workspace.registered` |
| b. The decoder rejects a well-formed future reason | `TestF2_05PayloadsRoundTrip/workspace.scratch_closed` |
| c. `TypeScratchClosed` removed from `Defined()` | `TestNewCatalogue`. `TestGoldenDecodes` did not fail, because the reader does not consult the writer's catalogue |
| d. One byte of the F2-05 golden changed | `TestGoldenF2_05` and `TestGoldenDecodes` |
| e. Uppercase Git IDs accepted | `TestF2_05PayloadsRefuse/workspace.scratch_created`, for `base_commit` and `anchor_tree`, in decoding and encoding |
| f. One byte of an F0 encoder's output changed | `TestGoldenF0` and `TestGoldenDecodes` |

### 5.5 Additivity

S2 changes no F0 rule.

**The record.** Against b663791 it removes 14 lines from `contract/ledger`:

```text
-// TypeBodiesCollected, each at version 1. It never contains a type in the
-		{TypeCommand, 1}:         true,
-		{TypeBodyPin, 1}:         true,
-		{TypeBodyUnpin, 1}:       true,
-		{TypeBodiesCollected, 1}: true,
-import "testing"
-	// Defined is F0's catalogue, exactly the four F0 types at version 1, so
-	// that a production writer can write F0 records and refuses fixture
-	// records.
-	for _, typ := range []string{TypeCommand, TypeBodyPin, TypeBodyUnpin, TypeBodiesCollected} {
-	if len(def.set) != 4 || def.Contains(TypeVersion{"fixture.sample", 1}) {
-		t.Errorf("Defined() holds %v, want only the four F0 type versions", def.set)
-// below, each at version 1. The type namespace "ledger." is reserved for F0
-	for _, g := range []*goldenLog{mustGolden(f), mustCatalogue(f)} {
```

**Where they come from:**

- `catalogue.go`, 5 lines: a re-wrapped comment and four map entries that `gofmt` re-aligned beside the longer F2-05 keys;
- `catalogue_test.go`, 7 lines: the import block, and the old four-type assertion, which became an exact-set check of the eight type versions;
- `doc.go`, 1 line: a re-wrapped comment;
- `fuzz_test.go`, 1 line: the list of logs `FuzzCheckTruncation` cuts, which gained the new golden.

**The review's finding.** Every removed line returns in changed form, and none removes an exported identifier, an encoding rule or a golden byte. R1 and R5 confirm the behaviour: F0's tests pass and F0's golden files are unchanged.

### 5.6 Grammar tests

`TestF2_05PathGrammars` checks each value both ways. An accepted value must encode and decode to itself. A refused value must be refused both by `Encode` and by the decoder, whose input carries the raw bytes, invalid UTF-8 included.

| Field | Accepted | Refused |
|---|---|---|
| `common_dir` | `/fixture/repo/.git`; `C:/fixture/repo/.git`; `c:/fixture/repo/.git`; `//host/share/repo/.git`; `//host/share`; a path with a space and non-ASCII letters; a 4,096-byte path | empty; `/`; `C:/`; `//host`; `///share/repo`; `//host//repo`; `C:\repo\.git`; `\\host\share\repo`; `relative/.git`; `C:repo/.git`; `/repo/../.git`; `/repo/./.git`; `/repo//.git`; `/repo/.git/`; bytes 0x00, 0x1f and 0x7f; invalid UTF-8; a 4,097-byte path |
| `branch` | `refs/heads/main`; `refs/heads/日本語`; a 4,096-byte name; `refs/heads/../@{/.lock/.hidden/trailing./~^:?*[`, which shows that Git's further rules stay Git's | empty; `main`; `refs/tags/main`; `refs/heads/`; `refs/heads//x`; `refs/heads/x/`; `refs/heads/with space`; `refs/heads/x\y`; bytes 0x00, 0x1f and 0x7f; invalid UTF-8; a 4,097-byte name |

`TestF2_05PayloadsRefuse` also refuses an empty or non-string `common_dir` and an empty, non-string, `main` or `refs/tags/main` branch. It also covers every required key missing, null or repeated, with a refusal case for each of the other value rules.

### 5.7 Platform status and limits

- **Verified on Windows on this machine,** an Intel Core i7-10610U, with go1.27.2.
- **Linux and macOS** are compiled and vetted only (R7 and the check's cross builds), until C3's CI exists (D42).
- **No host calls.** The F2-05 code makes none: its grammars are lexical (DOC).

### 5.8 Record cost (D78)

D78 asks for capacity reasoning before an affected boundary is frozen, with assumptions, calculations and measurements kept apart (DEC:569).

**Assumption.**

- Registrations and input updates are rare owner actions.
- Each scratch writes two records in its lifetime, one when it is created and one when it is closed.
- OG3's larger population is 60 contexts (DEC:1472), and B21's ledger model is 960 records per context-hour (DEC:1460).

**Calculation.**

- *Record count.* Suppose each of the 60 contexts opened and closed one scratch in each of w workspaces every hour, far more often than one dedicated scratch per context and workspace implies. F2-05 would then add 120·w records an hour, against the model's 57,600. For w = 4 that is 480, under 1%.
- *Record size.* Each golden record is under 1 KiB (R10). The largest possible record is a `workspace.registered` whose 4,096-byte `common_dir` consists only of `<`, `>` and `&`, each stored as six bytes. It stays under 25 KiB, far below the 1 MiB record cap (DOC, Commits and the chain).
- *Bodies.* Each input revision adds one capture-inputs document and at most five host files, within Core's size limit (BRIEF §2.5).

**Measurement.** None is needed for these records. Capture cost belongs to S1's engine and is measured in Core Appendix A.11 (BRIEF P29; RULING:41).

**Not claimed:** no throughput, threshold or capacity.

## 6. Questions

Each question says what the freeze fixes and gives our recommendation.

- **Q1–Q7** are the design brief's questions for this request, as the build advisor ruled on them (BRIEF:1148–1156; RULING:37–38, :51).
- **The brief's sixth question,** how F2 is staged, is not asked: your answer to OG-B settled it (D113, DEC:1636–1648).
- **Q8** lists what stays Core policy and needs no answer.

Every recommendation is to freeze what was built, so all fold into one answer, "Freeze as presented" (§7).

### Q1. The four types, their names and their payloads

**What is frozen.**

- The four types of §4.3, at version 1, with their keys, value rules and record rules.
- `Defined()` listing eight type versions.
- The namespace `workspace.` reserved for C2's record families, beside `ledger.` for F0 and `fixture.` for contract fixtures (DOC, Catalogue; DEC:1516).

The four are exactly the records ticket 05 writes (BRIEF P25; RULING:37). They are named as D35's example names a workspace event, `workspace.promotion_accepted` (DEC:172).

**Not chosen.** Adding now the records that later tickets write, such as *scratch base advanced* (RC:289) or the temporary scratch's parent field (UC:612). These would be "placeholder payloads for later work", which B2 rules out (DEC:648; CORE:844). They join by addition (§3.2).

**Recommendation:** freeze as presented.

### Q2. `reason` as an open token

**What is frozen.**

- `reason` is a token matching `^[a-z][a-z0-9_]*$`, at most 64 bytes.
- Version 1 defines one reason, `abandoned`, the only one ticket 05 writes.
- Encode and decode accept every well-formed token, and a reader treats one it does not know as a closure for a reason it does not know, never as invalid (§4.3).

**Why open.** Later parts close scratches for the other reasons that RC:289 lists:

- temporary merged back (ticket 07);
- promoted (C4's integration);
- garbage-collected.

With a closed list, each would need a new type version with an upgrader (CON:16). With an open token, each joins by addition, and older readers still read the record. F0's `measurement_path` set the precedent: a token whose vocabulary each family owns (B18 item 1, DEC:1196).

**Not chosen.** A closed list of reasons.

**Recommendation:** an open token, with `abandoned` defined.

### Q3. A host path in `workspace.registered`

**What is frozen.**

- `common_dir` is the repository's common Git directory as `git rev-parse --path-format=absolute --git-common-dir` prints it, unchanged by Core.
- It is an absolute path with forward slashes, under §4.2's grammar, at most 4,096 bytes.

On your machine it typically begins `C:/Users/<you>/`, so it can carry your user name, and every reader of the colony log sees it. The privacy class says so (§4.4).

**Why in the record.**

- The record rule "no earlier registration names the same `common_dir`" compares paths across records (§4.3).
- Core's replay finds each workspace's repository from the path (BRIEF §2.12).
- Bodies may be collected, so replay needs only records (D36).

**Not chosen.**

- *A digest in the record, with the path in a body.* Replay would then depend on a body that can be collected.
- *A path without the user part.* Git prints the path whole, and no shorter spelling identifies the repository on every machine.

**Recommendation:** keep the path in the record.

### Q4. Inputs pinned while current, released on update

**What is frozen.**

- A revision lists its capture-inputs document and every host file it names in `body_refs`, and the same commit pins them with `ledger.body_pin`.
- An update, revision n+1, pins its own bodies and releases revision n's pin with `ledger.body_unpin`, in one commit (§4.3).

**What it means.**

- Nothing is deleted automatically. A superseded revision's bodies only become eligible for an explicit collection, ordered by you or Core under a stated policy (D111; B21).
- After such a collection, a read of those bodies reports them unavailable, and the collection stays on record.
- Anything that needs an old revision kept takes its own pin. Ticket 06 decides that for admitted submissions.

**Not chosen.**

- *Keeping every revision pinned.* Bodies would grow with every update.
- *No pins.* A collection could remove the current inputs.

**Recommendation:** as presented.

### Q5. Privacy-class wording

B2 asks every catalogue entry for a privacy class, but no source defines a vocabulary (DEC:648). As for F0, the register describes what each type holds, for example "identifiers and a host path to the repository's Git directory; no file content" (§4.4). D111 kept that wording register text, outside the freeze (DEC:1520).

**Recommendation:** accept the descriptive text; it stays register text.

### Q6. The version label

**What is frozen.** `ledger-format` stays version 1:

- every record keeps `"format":1`;
- each new type has `type_version` 1;
- the register records two catalogue stages, F0 (D111) and F2-05 (this freeze).

Additions do not change the version (CON:16; DEC:1521).

**Not chosen.** A new format version. Older readers would then refuse every record as an unsupported format (DOC, Records), which is a breaking change.

**Recommendation:** version 1, with catalogue stages.

### Q7. Undercurrent §15.1's scratch rows

`ROADMAP-CORE.md` C2 proposed a *Scratch closed* event, for C1 to add to Undercurrent §15.1 when it drafts the catalogue (RC:289). §15.1 has a "Scratch created" row but no closure (UC:612–614).

**Proposed for the freeze's documents commit:**

- a "Scratch closed" row, and a note on "Scratch created" naming the frozen record (Appendix A, F24–F25);
- RC:289 records the adoption (F19);
- the Undercurrent roadmap's two source cells that cite the proposal, and its row on closure events, are updated (F26–F28).

*Scratch base advanced* stays a proposal.

**Recommendation:** make these edits.

### Q8. For information, not frozen: Core policy around these records

No answer is needed; each can change without a format change.

- **Where the record rules are enforced.** Core's workspace service checks them when it appends and when it opens a log. Core's store checks F0's rules through the appender, but does not check F2-05's (DOC).
- **Which package may append.** Only `internal/core/workspace`, by review (DEC:1211; §2.2).
- **Core's naming.** Scratch branches are `refs/heads/dwarf-harness/<dir>` and directories `scratch/<dir>`, with `<dir>` taken from the scratch ID and never reused (BRIEF P16; RULING:28). This is a service rule beside the record rules.
- **The capture-inputs document.** Its format, and the size limit on host files, are Core-internal (BRIEF §2.5; RULING:24).

### Summary

| Q | Subject | Recommendation | Folds into "Freeze as presented" |
|---|---|---|---|
| Q1 | The four types, names and payloads | Freeze as presented | Yes |
| Q2 | `reason` | Open token; `abandoned` defined | Yes |
| Q3 | Host path in `workspace.registered` | Keep it in the record | Yes |
| Q4 | Input pins | Pinned while current, released on update | Yes |
| Q5 | Privacy-class wording | Descriptive register text | Yes |
| Q6 | Version label | `ledger-format` stays 1 | Yes |
| Q7 | Undercurrent §15.1 rows | Edit in the freeze's commit | Yes |
| Q8 | Core policy | For information | No answer needed |

## 7. The question

To send in the question tool:

```text
Ticket 05 has drafted F2-05, its part of C2's F2 record family: four workspace.* record types in contract/ledger. Under D40 and your D113 I request your freeze of F2-05 by addition to ledger-format version 1, at commit d4e3032 on branch build/05-f2; S2 reaches main only with your freeze. The packet is in your vault at dwarf-harness/.scratch/dwarf-harness/c2-evidence/f2-05-freeze-packet.md. It holds what the four records mean and what to know about them; what freezing permits and what it does not; the frozen surface, with both path grammars word for word; the register table and the golden file with its digest; the evidence; seven questions with our recommendations and a note on what stays Core policy; a draft decision entry; and the edits that record the freeze. Freezing lets S2 reach main and ticket 05's S3, the code that writes these records, start. Nothing is frozen until you answer and your decision entry is recorded. Take the time you need.
```

| Label | Description |
|---|---|
| Freeze as presented (Recommended) | Freeze F2-05 at d4e3032, with every recommendation in Q1–Q7. Your entry and the edits are recorded; S2 reaches main and S3 may start. |
| Freeze with changes | Name the changes by question number. A follow-up change makes them, and the freeze is recorded at its commit. S2 stays off main until then. |
| Not yet | Nothing is frozen. S2 stays off main and S3 waits. You may say what is missing. |

**Recommendation: Freeze as presented.**

- **The records.** The four types are exactly what ticket 05 writes, with no placeholder for later work (DEC:648; RULING:37).
- **The review.** The build advisor approved S2 on evidence collected in a separate worktree, and the F0 golden files are unchanged (§5).
- **Waiting.** It would block S3 without settling anything, because later parts join F2 by addition (D113).

## 8. Draft decision entry (not applied)

Written for "Freeze as presented".

- **Recording it.** Appendix A's F2a appends it. If you answer in your own words, F2b adjusts its Date line, as D111's records (DEC:1512).
- **"Freeze with changes".** The entry becomes **Decided by:** modified, states your changes, and is recorded when the follow-up change lands, at its commit.
- **"Not yet".** No entry is recorded.

Originators follow AGENTS:7–14.

```markdown
### D«D-NEXT». F2-05 workspace and scratch records frozen

- **Date:** «DATE». **Decided by:** adopted. In OG5, the F2-05 freeze request that ticket 05 sent on 2026-10-12, the owner picked "Freeze as presented" from the assistant's options.
- **Owner's words (question tool):**
  > «OWNER-WORDS»
- **Decision:** F2-05, ticket 05's part of C2's F2 family, is frozen by addition to `ledger-format` version 1 (D40, D111, D113), at commit d4e3032, whose `contract/ledger` reached `main` unchanged in «RECORD-COMMIT»:
  - four record types, each at version 1: `workspace.registered`, `workspace.capture_inputs_pinned`, `workspace.scratch_created` and `workspace.scratch_closed`, with their payloads and record rules as the `contract/ledger` package documentation states them; `Defined()` lists the eight type versions of F0 and F2-05, and the namespace `workspace.` is reserved for C2's record families;
  - their value rules, identical on every host: the `common_dir` and `branch` grammars with their 4,096-byte caps; Git object IDs of 40 or 64 lowercase hex digits; a `dir` of 8 lowercase hex digits; revisions from 1; and `reason`, a token matching `^[a-z][a-z0-9_]*$` of at most 64 bytes, open to later reasons, with version 1 defining `abandoned`. Unknown payload keys are ignored;
  - their record rules, which Core's workspace service checks when it appends and when it opens a log;
  - the golden sample `contract/ledger/testdata/f2/05/log/00000000000000000001.jsonl` (SHA-256 843663a168e472adf4656fdba4ffa6db770e588feec0020bb10e20bf14def437); the three F0 golden samples keep D111's digests;
  - with them, the *Scratch closed* event that `ROADMAP-CORE.md` C2 proposed is adopted; *Scratch base advanced* stays a proposal.
- **Not frozen:** where the record rules are enforced, now Core's workspace service, and Core's naming of scratch branches and directories, both Core policy; which package may append these types, `internal/core/workspace` only, a review rule like B18 item 5's; the capture-inputs document's format, which is Core-internal; the privacy-class wording, which stays register text; and every later part of F2, which joins through its own additive freeze (D113).
- **Consequences:** these four types now change only by addition: new optional keys, new types, new type versions with upgraders, and new `reason` tokens, which need no new version. A breaking change needs an owner decision entry listing every step it affects (D40). Ticket 05's S2 reaches `main` with this entry (D41), and S3, the code that writes these records, may start (D113). U3's foundation may consume the types once C2 is Done and its other prerequisites hold, and U4 and U9 once theirs hold. No step's status changes, and `ledger-format` stays at version 1.
- **Changes:** `CONTRACTS.md` (status line; the `ledger-format` row's text and status; the F2-05 catalogue lead-in); the `contract/ledger` comments that called F2-05 proposed (the package documentation's Catalogue and F2-05 sections, `Defined`, the type constants and two test comments); `ROADMAP-CORE.md` (status line and its account of the Core code; Start here; C1's promotion-records line; C2's scratch lifecycle events and Status) and `ROADMAPS.md` (status line and its account of what exists; the Path A paragraph); the scratch rows of Undercurrent §15.1; `ROADMAP-UNDERCURRENT.md` (two scratch-lifecycle source cells and the scratch-after-acceptance row); the open item in this log, which this entry closes, and a "See also" line under D113; the OG5 packet's answer line; ticket 05's comments.
```

## Appendix A. Edits that record the request and the freeze (not applied)

### A.0 How to apply

**Form.**

- Each edit has a heading `#### <ID> — <path>`, plain text saying when it applies, then `Find:` and `Replace:`, each followed by one four-backtick fence.
- The exact string is the text between the two fence lines, with lines joined by LF and no LF at the end.
- Replace by exact string, with a tool that refuses zero or several matches.
- Write UTF-8 with LF line endings (B1), and keep these characters as given: § (U+00A7), – (U+2013) and — (U+2014).

**Where the finds come from.**

- **`contract/ledger/**` and `docs/CONTRACTS.md`:** from the `05-f2` worktree while S2's fix-up was being made. They change the wording S2 wrote, which `main` does not yet hold.
- **Every other file:** from `main` at b663791, the main checkout.
- Before applying, each find occurs exactly once in its file, with these exceptions:
  - F2a's find is text that F1 adds, and F29's is text that A2 adds.
  - F30a's and F30b's find also occurs inside their own fences in this packet. Apply them to the first occurrence only, the header on line 3.
- Where variants share a find, exactly one of them applies: F3a or F3b, and F30a or F30b. A1a and A1b, and F4a and F4b, are also alternatives: exactly one of each pair applies.

**Order.** Apply F1 before F2a, F2b after F2a, and A2 before F29. Fill every placeholder, in finds too, with the values used when A.1 was applied.

**Re-anchoring.**

- **After S1.** If S1's status commit has changed one of these lines, re-copy the find from the file as it stands and make the same change: RC:3, RC:9, RC:417 or RM:3 (F15, F16, F17, F20, F21, F22).
- **After OG4.** OG4's packet (`law-format`) anchors on the same places: D113's last line, the open-items table and, on `main`, `docs/CONTRACTS.md`'s status line.
  - If its entry is recorded after this one, its F1a must anchor on the log's last line, not on D113's, or F1's "See also" line would end up under its entry.
  - If its entry is recorded first, this F1 still applies as written, and F2a anchors on the log's last line.

**Placeholders.** The commit hash (d4e3032), the §5.2 results and Appendix B's `go doc` excerpt were filled before sending. The placeholders that remain are filled at send time or after the answer.

| Placeholder | Fill with | When |
|---|---|---|
| 2026-10-12 | The date the request is sent | Before sending |
| «DATE» | The date of the owner's answer | After the answer |
| «OWNER-WORDS» | His exact answer, without quotation marks; the templates supply them where running text needs them | After the answer |
| «D-NEXT» | The next free D number when the entry is recorded: 114 if OG4's entry is not yet recorded, otherwise 115. It also appears in link anchors, such as `#d«D-NEXT»-f2-05-workspace-and-scratch-records-frozen`, the anchor of the heading in §8 | After the answer |
| «RECORD-COMMIT» | The 7-digit hash of S2's fix-up commit as it reaches `main` after the rebase: the parent of the documents commit (procedure, step 6) | After the answer |

**Procedure.**

1. **Before sending.**
   - Once the fix-up is committed, name it throughout this packet (done: d4e3032).
   - A runner runs Appendix C in a separate detached worktree of that commit; fill the §5.2 table and Appendix B from it. Stop if any step is not as §5.1 expects.
   - Compare §4.1–§4.3 with R11 and R12, word for word. If the fix-up changed any wording, update those sections before sending.
   - Check that each find of F4–F14 occurs exactly once at d4e3032; re-copy any the fix-up changed.
   - Fill 2026-10-12.
2. **Send.** Send §7 in the question tool. Then make one documents commit on `main`:
   - this packet as sent, at `.scratch/dwarf-harness/c2-evidence/f2-05-freeze-packet.md`;
   - A1a or A1b;
   - A2.

   `build/05-f2` does not reach `main` here. The check passes on the commit (D46).
3. **After the answer.** For "Freeze as presented", continue. For any other answer, see A.3. If the answer arrives before step 2's commit lands, apply A.1 and then A.2.
4. **Check the branch.** `git rev-parse build/05-f2` must print d4e3032's full hash. If commits were added after sending, stop: you froze d4e3032.
5. **Rebase.** Rebase `build/05-f2` onto `main`. If a commit on `main` also changed `docs/CONTRACTS.md` (OG4's freeze, for example), keep both sides.
6. **Check identity before recording.**
   - `git diff --exit-code d4e3032 HEAD -- contract/ledger` must print nothing and exit 0.
   - `git diff d4e3032 HEAD -- docs/CONTRACTS.md` must print nothing, or only lines that commits on `main` after b663791 changed (`git log --oneline b663791..main -- docs/CONTRACTS.md` lists them). None of them may touch the F2-05 text: the status line's F2-05 clause, the `ledger-format` row, and the F2-05 catalogue lead-in and table.
   - If either check fails, stop and report: the entry would name a text you did not see.
   - If both pass, fill «RECORD-COMMIT» with `git rev-parse --short HEAD`.
7. **Record.** On top of the rebased branch, make one commit that applies A.2.
8. **Land.** `go run ./tools/check` passes on it (D41, D46); then fast-forward `main`. S3 starts only after the entry is on `main` (D113).

### A.1 When the request is sent

In the commit that records the request and adds this packet as sent. A row under "Open items awaiting the owner" records the pending request, as B21 added one for OG2 (DEC:1506).

#### A1a — docs/DECISIONS.md

The open item (DEC:28), when the table holds only its "None" row. Otherwise apply A1b.

Find:
````
| None | — | — |
````
Replace:
````
| OG5: freeze F2-05, ticket 05's four `workspace.*` record types, by addition to `ledger-format` version 1 (D40, D113), sent 2026-10-12; packet at `.scratch/dwarf-harness/c2-evidence/f2-05-freeze-packet.md` | S2 reaching `main` and ticket 05's S3, the code that writes these records (D41, D113) | Nothing is frozen until the owner answers and his decision entry is recorded |
````

#### A1b — docs/DECISIONS.md

The open item, when the table already holds another row, such as OG4's. Otherwise apply A1a. The row goes first, under the table's header.

Find:
````
| Item | Blocks | Notes |
|---|---|---|
````
Replace:
````
| Item | Blocks | Notes |
|---|---|---|
| OG5: freeze F2-05, ticket 05's four `workspace.*` record types, by addition to `ledger-format` version 1 (D40, D113), sent 2026-10-12; packet at `.scratch/dwarf-harness/c2-evidence/f2-05-freeze-packet.md` | S2 reaching `main` and ticket 05's S3, the code that writes these records (D41, D113) | Nothing is frozen until the owner answers and his decision entry is recorded |
````

#### A2 — .scratch/dwarf-harness/issues/05-create-private-scratch-and-capture-exact-eligible-trees.md

A comment recording the request, appended after the last comment. At b663791 the last comment ends as in the find (T05:53). If a comment has been added since, such as S1's, anchor on the end of that one instead.

Find:
````
Ticket 05's four `workspace.*` record types reach `main` only with the owner's F2-05 freeze, a later question.
````
Replace:
````
Ticket 05's four `workspace.*` record types reach `main` only with the owner's F2-05 freeze, a later question.

2026-10-12 — OG5, the freeze request for F2-05, was sent as one question-tool request pointing to the packet at `.scratch/dwarf-harness/c2-evidence/f2-05-freeze-packet.md`. It asks the owner to freeze this ticket's four `workspace.*` record types at version 1, by addition to `ledger-format`, at commit d4e3032 on branch `build/05-f2`: S2 (31103d8) and the fix-up that the build advisor's review asked for. The packet's results, `go doc` excerpt and digests were taken at d4e3032; the golden's SHA-256 is 843663a168e472adf4656fdba4ffa6db770e588feec0020bb10e20bf14def437. S2 stays off `main`, and S3 waits, until the owner answers and his decision entry is recorded (D113).
````

### A.2 After "Freeze as presented"

All in one commit, on top of the rebased S2 commits (procedure, step 7).

- **What changes.** The commit edits documents and changes only comments in Go files; no rule, golden byte or exported identifier changes. The full check passes on it (D46).
- **What the edits do.**
  - F1–F3 record the freeze in the log, and F4–F8 in the register.
  - F9–F14 flip the "proposed" wording in `contract/ledger`. The build advisor's review listed the places that F4–F11 change; F12–F14 are three more places with the same wording.
  - The others correct lines that the freeze makes stale, as D111 corrected "the lines that waited on it" (DEC:1522), and record the answer in the ticket and in this packet.

#### F1 — docs/DECISIONS.md

A "See also" line under D113, after its last line (DEC:1648). D113 left this freeze as a later question (DEC:1646), and an earlier entry gains only a one-line pointer (DEC:5).

Find:
````
- **Changes:** Core §13.1's F2 sentence; `ROADMAP-CORE.md` (C1's F2 deliverable, Start here and C2's Status); `ROADMAPS.md` (the Path A paragraph); "See also" lines under D112 and B2.
````
Replace:
````
- **Changes:** Core §13.1's F2 sentence; `ROADMAP-CORE.md` (C1's F2 deliverable, Start here and C2's Status); `ROADMAPS.md` (the Path A paragraph); "See also" lines under D112 and B2.
- **See also:** D«D-NEXT» records the owner's freeze of F2-05, which this entry left as a later question.
````

#### F2a — docs/DECISIONS.md

The entry of §8, appended after the log's last line. If D113 is the last entry, that line is the one F1 adds. If another entry has been appended since, such as OG4's D114 or S1's B entry, anchor on the last line of the last entry instead.

Find:
````
- **See also:** D«D-NEXT» records the owner's freeze of F2-05, which this entry left as a later question.
````
Replace:
````
- **See also:** D«D-NEXT» records the owner's freeze of F2-05, which this entry left as a later question.

### D«D-NEXT». F2-05 workspace and scratch records frozen

- **Date:** «DATE». **Decided by:** adopted. In OG5, the F2-05 freeze request that ticket 05 sent on 2026-10-12, the owner picked "Freeze as presented" from the assistant's options.
- **Owner's words (question tool):**
  > «OWNER-WORDS»
- **Decision:** F2-05, ticket 05's part of C2's F2 family, is frozen by addition to `ledger-format` version 1 (D40, D111, D113), at commit d4e3032, whose `contract/ledger` reached `main` unchanged in «RECORD-COMMIT»:
  - four record types, each at version 1: `workspace.registered`, `workspace.capture_inputs_pinned`, `workspace.scratch_created` and `workspace.scratch_closed`, with their payloads and record rules as the `contract/ledger` package documentation states them; `Defined()` lists the eight type versions of F0 and F2-05, and the namespace `workspace.` is reserved for C2's record families;
  - their value rules, identical on every host: the `common_dir` and `branch` grammars with their 4,096-byte caps; Git object IDs of 40 or 64 lowercase hex digits; a `dir` of 8 lowercase hex digits; revisions from 1; and `reason`, a token matching `^[a-z][a-z0-9_]*$` of at most 64 bytes, open to later reasons, with version 1 defining `abandoned`. Unknown payload keys are ignored;
  - their record rules, which Core's workspace service checks when it appends and when it opens a log;
  - the golden sample `contract/ledger/testdata/f2/05/log/00000000000000000001.jsonl` (SHA-256 843663a168e472adf4656fdba4ffa6db770e588feec0020bb10e20bf14def437); the three F0 golden samples keep D111's digests;
  - with them, the *Scratch closed* event that `ROADMAP-CORE.md` C2 proposed is adopted; *Scratch base advanced* stays a proposal.
- **Not frozen:** where the record rules are enforced, now Core's workspace service, and Core's naming of scratch branches and directories, both Core policy; which package may append these types, `internal/core/workspace` only, a review rule like B18 item 5's; the capture-inputs document's format, which is Core-internal; the privacy-class wording, which stays register text; and every later part of F2, which joins through its own additive freeze (D113).
- **Consequences:** these four types now change only by addition: new optional keys, new types, new type versions with upgraders, and new `reason` tokens, which need no new version. A breaking change needs an owner decision entry listing every step it affects (D40). Ticket 05's S2 reaches `main` with this entry (D41), and S3, the code that writes these records, may start (D113). U3's foundation may consume the types once C2 is Done and its other prerequisites hold, and U4 and U9 once theirs hold. No step's status changes, and `ledger-format` stays at version 1.
- **Changes:** `CONTRACTS.md` (status line; the `ledger-format` row's text and status; the F2-05 catalogue lead-in); the `contract/ledger` comments that called F2-05 proposed (the package documentation's Catalogue and F2-05 sections, `Defined`, the type constants and two test comments); `ROADMAP-CORE.md` (status line and its account of the Core code; Start here; C1's promotion-records line; C2's scratch lifecycle events and Status) and `ROADMAPS.md` (status line and its account of what exists; the Path A paragraph); the scratch rows of Undercurrent §15.1; `ROADMAP-UNDERCURRENT.md` (two scratch-lifecycle source cells and the scratch-after-acceptance row); the open item in this log, which this entry closes, and a "See also" line under D113; the OG5 packet's answer line; ticket 05's comments.
````

#### F2b — docs/DECISIONS.md

Applies after F2a, and only if you answered in your own words: the Date line then reads as D111's does (DEC:1512).

Find:
````
In OG5, the F2-05 freeze request that ticket 05 sent on 2026-10-12, the owner picked "Freeze as presented" from the assistant's options.
````
Replace:
````
In OG5, the F2-05 freeze request that ticket 05 sent on 2026-10-12, the owner chose "Freeze as presented" in his own words.
````

#### F3a — docs/DECISIONS.md

The open item that A1a or A1b added, when it is the table's only row: the table returns to "None". If another row follows it, apply F3b.

Find:
````
|---|---|---|
| OG5: freeze F2-05, ticket 05's four `workspace.*` record types, by addition to `ledger-format` version 1 (D40, D113), sent 2026-10-12; packet at `.scratch/dwarf-harness/c2-evidence/f2-05-freeze-packet.md` | S2 reaching `main` and ticket 05's S3, the code that writes these records (D41, D113) | Nothing is frozen until the owner answers and his decision entry is recorded |
````
Replace:
````
|---|---|---|
| None | — | — |
````

#### F3b — docs/DECISIONS.md

The same open item, when another row follows it: only this row is deleted. Otherwise apply F3a.

Find:
````
|---|---|---|
| OG5: freeze F2-05, ticket 05's four `workspace.*` record types, by addition to `ledger-format` version 1 (D40, D113), sent 2026-10-12; packet at `.scratch/dwarf-harness/c2-evidence/f2-05-freeze-packet.md` | S2 reaching `main` and ticket 05's S3, the code that writes these records (D41, D113) | Nothing is frozen until the owner answers and his decision entry is recorded |
````
Replace:
````
|---|---|---|
````

#### F4a — docs/CONTRACTS.md

The status line (REG:3), a new first entry. Applies if «DATE» is later than 2026-10-12; otherwise apply F4b. The find is the line's opening marker, so the edit holds whatever entries the line begins with.

Find:
````
**Status:**
````
Replace:
````
**Status:** «DATE» (the owner freezes F2-05's four workspace and scratch record types by addition to `ledger-format` version 1, D«D-NEXT»);
````

#### F4b — docs/CONTRACTS.md

The status line (REG:3), S2's clause in the 2026-10-12 entry. Applies if «DATE» is 2026-10-12; otherwise apply F4a.

Find:
````
2026-10-12 (C2 proposes F2-05's four workspace and scratch record types by addition to `ledger-format` version 1; not frozen;
````
Replace:
````
2026-10-12 (C2 proposes F2-05's four workspace and scratch record types by addition to `ledger-format` version 1; the owner freezes them, D«D-NEXT»;
````

#### F5 — docs/CONTRACTS.md

The status line's contract statuses (REG:3).

Find:
````
the F2-05 catalogue additions are *Proposed*, not frozen;
````
Replace:
````
the F2-05 catalogue additions are *Frozen* (D«D-NEXT»);
````

#### F6 — docs/CONTRACTS.md

The `ledger-format` row's Defines text (REG:25).

Find:
````
F2-05 proposes four version-1 types below, with `workspace.` reserved for C2's families; these additions await the owner's freeze and do not change F0 or the format version.
````
Replace:
````
F2-05 adds four version-1 types below, frozen by addition (D«D-NEXT»), with `workspace.` reserved for C2's families; they do not change F0 or the format version.
````

#### F7 — docs/CONTRACTS.md

The `ledger-format` row's version and status (REG:25), as CON:19 asks: "update the version and status columns". The version stays 1 (Q6).

Find:
````
| 1 | Frozen F0; F2-05 proposed, not frozen |
````
Replace:
````
| 1 | Frozen: F0 (D111); F2-05 (D«D-NEXT») |
````

#### F8 — docs/CONTRACTS.md

The F2-05 catalogue's lead-in (REG:58), in the form of F0's (CON:49). The sentences after it stay.

Find:
````
**F2-05 catalogue (proposed).** Ticket 05 proposes the following additions to `ledger-format` version 1; the owner has not frozen them. F2 is frozen in parts, ticket by ticket, before each part's producer. These four types reach `main` only with the owner's F2-05 freeze; their availability does not claim an operational producer.
````
Replace:
````
**F2-05 catalogue (C2, frozen at version 1, D«D-NEXT»).** F2-05 is ticket 05's part of F2: the following four record types, each at version 1, added to `ledger-format` version 1, which Core's workspace service produces. F2 is frozen in parts, ticket by ticket, before each part's producer (D113); their availability does not claim an operational producer.
````

#### F9 — contract/ledger/doc.go

The Catalogue section. Comment text only.

Find:
````
// and the four proposed F2-05 types below, each at version 1. F2-05 awaits
// the owner's additive freeze; it does not change F0 or format version 1.
````
Replace:
````
// and the four F2-05 types below, each at version 1. F2-05 joined by the
// owner's additive freeze (D«D-NEXT»); it does not change F0 or format version 1.
````

#### F10 — contract/ledger/doc.go

The F2-05 section's opening sentence. Comment text only.

Find:
````
// These four proposed version-1 types are ticket 05's part of F2. C2 owns
````
Replace:
````
// These four version-1 types are ticket 05's part of F2, frozen by addition
// to format version 1 (D«D-NEXT»). C2 owns
````

#### F11 — contract/ledger/catalogue.go

`Defined`'s documentation.

Find:
````
// TypeBodiesCollected; and the proposed F2-05 additions:
````
Replace:
````
// TypeBodiesCollected; and the F2-05 additions:
````

#### F12 — contract/ledger/workspace.go

The type constants' documentation, which `go doc` shows (Appendix B).

Find:
````
// The proposed F2-05 record types, each at version 1. The package
````
Replace:
````
// The F2-05 record types, each at version 1. The package
````

#### F13 — contract/ledger/golden_test.go

A test comment.

Find:
````
// workspaceDir holds the proposed F2-05 catalogue's one-segment log.
````
Replace:
````
// workspaceDir holds the F2-05 catalogue's one-segment log.
````

#### F14 — contract/ledger/catalogue_test.go

A test comment. The find starts after the line's leading tab, which stays.

Find:
````
// Defined contains the F0 and proposed F2-05 type versions, but never
````
Replace:
````
// Defined contains the F0 and F2-05 type versions, but never
````

#### F15 — docs/ROADMAP-CORE.md

The status line (RC:3), a new first entry, as D111 entered F0's freeze there. The find is the line's opening marker. If the line's first entry already carries «DATE», the clause may go inside that entry instead.

Find:
````
**Status:**
````
Replace:
````
**Status:** «DATE» (F2-05, ticket 05's part of F2, frozen by addition to `ledger-format` version 1, D«D-NEXT»);
````

#### F16 — docs/ROADMAP-CORE.md

The status line's account of the Core code (RC:3).

Find:
````
the frozen `contract/ledger` and `contract/ledger/appender` contracts (D111),
````
Replace:
````
the frozen `contract/ledger` and `contract/ledger/appender` contracts (D111), to which ticket 05 added the four F2-05 record types (D«D-NEXT»),
````

#### F17 — docs/ROADMAP-CORE.md

Start here (RC:9).

Find:
````
its F2 family must be frozen under D40 in parts, each part before the code that writes it (D113); no part is frozen yet.
````
Replace:
````
its F2 family must be frozen under D40 in parts, each part before the code that writes it (D113); ticket 05's part, F2-05, is frozen (D«D-NEXT»).
````

#### F18 — docs/ROADMAP-CORE.md

C1's line on promotion records (RC:221). F2-05 holds no promotion record, but F2 as a whole is no longer only a later freeze.

Find:
````
The exact fields and lifecycle are specified in core §§13.2–13.3; F2 remains a later freeze, not a current contract.
````
Replace:
````
The exact fields and lifecycle are specified in core §§13.2–13.3; their F2 parts remain later freezes (D113), not current contracts.
````

#### F19 — docs/ROADMAP-CORE.md

C2's scratch lifecycle events (RC:289), inside D112's approved range. The item is marked **[PROPOSAL]**, which D112 leaves revisable (DEC:1534), and the edit records your adoption without changing a mechanism.

Find:
````
*Scratch closed* (context, scratch, reason: promoted, abandoned, garbage-collected, temporary merged back).
````
Replace:
````
*Scratch closed* (context, scratch, reason: promoted, abandoned, garbage-collected, temporary merged back). The owner froze *Scratch closed*, with the creation record, in F2-05 (D«D-NEXT»): version 1 defines the reason `abandoned`, later F2 parts add the other reasons by addition, and §15.1 carries both as frozen rows; *Scratch base advanced* remains proposed.
````

#### F20 — docs/ROADMAP-CORE.md

C2's status (RC:417), a status line inside D112's approved range, as D112's own edit of it was. The status stays as it is.

Find:
````
Its F2 family must be frozen under D40 in parts, each part before the code that writes it (D113); no part is frozen yet.
````
Replace:
````
Its F2 family must be frozen under D40 in parts, each part before the code that writes it (D113); ticket 05's part, F2-05, is frozen (D«D-NEXT»).
````

#### F21 — docs/ROADMAPS.md

The status line (RM:3), a new first entry, as D111 entered F0's freeze there. The find is the line's opening marker. If the line's first entry already carries «DATE», the clause may go inside that entry instead.

Find:
````
**Status:**
````
Replace:
````
**Status:** «DATE» (F2-05, ticket 05's part of F2, frozen by addition to `ledger-format` version 1, D«D-NEXT»);
````

#### F22 — docs/ROADMAPS.md

The status line's account of what exists (RM:3). Without the clause, the line would hold a contract freeze it does not record.

Find:
````
C1's three ledger contracts, frozen at version 1 (D111), the owner's approval of the C2 promotion boundary (D112),
````
Replace:
````
C1's three ledger contracts, frozen at version 1 (D111), to which ticket 05 added the four F2-05 record types (D«D-NEXT»), the owner's approval of the C2 promotion boundary (D112),
````

#### F23 — docs/ROADMAPS.md

The Path A paragraph (RM:17).

Find:
````
C2's own F2 family must be frozen under D40 in parts, each part before the code that writes it (D113); no part is frozen yet.
````
Replace:
````
C2's own F2 family must be frozen under D40 in parts, each part before the code that writes it (D113); ticket 05's part, F2-05, is frozen (D«D-NEXT»).
````

#### F24 — docs/DESIGN-UNDERCURRENT.md

§15.1, the "Scratch created" row (UC:612). Its third cell stays.

Find:
````
| Scratch created | Context, workspace root, base commit, authoring context; for temporary scratch (D23), parent scratch |
````
Replace:
````
| Scratch created | Context, workspace root, base commit, authoring context; for temporary scratch (D23), parent scratch. Frozen for a context's dedicated scratch as `workspace.scratch_created` v1 (D«D-NEXT»): scratch, workspace, owning context (which authors the scratch's changes), base commit and anchor tree; the temporary scratch's parent field joins later by addition (D40) |
````

#### F25 — docs/DESIGN-UNDERCURRENT.md

§15.1, a "Scratch closed" row after "Temporary scratch merged back" (UC:614), as RC:289 asks.

Find:
````
| Temporary scratch merged back | Context, parent scratch, authoring context, outcome and changed paths | Private-work evidence; never an addressed source or public promotion |
````
Replace:
````
| Temporary scratch merged back | Context, parent scratch, authoring context, outcome and changed paths | Private-work evidence; never an addressed source or public promotion |
| Scratch closed | Context, scratch and reason (`ROADMAP-CORE.md` C2). Frozen as `workspace.scratch_closed` v1 (D«D-NEXT»): version 1 defines the reason `abandoned`, and later F2 parts add others, such as temporary merged back and promoted, by addition | U4's set of open scratches and U9's occupancy lifetimes (`ROADMAP-CORE.md` C2), never recovered from bodies (D36) |
````

#### F26 — docs/ROADMAP-UNDERCURRENT.md

U4's decided row on base lag and open scratches (RU:341). Its source cell cites the proposal, which F2-05 now adopts for closure.

Find:
````
changed-path sets that are full current sets, never from bodies | D36; `ROADMAP-CORE.md` C2 **[PROPOSAL]** |
````
Replace:
````
changed-path sets that are full current sets, never from bodies | D36; closure frozen in F2-05 (D«D-NEXT»); base advanced: `ROADMAP-CORE.md` C2 **[PROPOSAL]** |
````

#### F27 — docs/ROADMAP-UNDERCURRENT.md

U4's "Scratch after integrated acceptance" row (RU:358).

Find:
````
Exact base-advance/close producer events remain C1/C2 contract work, not an unresolved owner choice.
````
Replace:
````
The close producer event is frozen in F2-05 (D«D-NEXT»); the exact base-advance event remains C1/C2 contract work, not an unresolved owner choice.
````

#### F28 — docs/ROADMAP-UNDERCURRENT.md

U9's decided row on occupancy lifetimes (RU:530).

Find:
````
(creation, base advanced, closed), never from bodies | D36; `ROADMAP-CORE.md` C2 **[PROPOSAL]** |
````
Replace:
````
(creation, base advanced, closed), never from bodies | D36; creation and closure frozen in F2-05 (D«D-NEXT»); base advanced: `ROADMAP-CORE.md` C2 **[PROPOSAL]** |
````

#### F29 — .scratch/dwarf-harness/issues/05-create-private-scratch-and-capture-exact-eligible-trees.md

A comment recording the freeze, appended after the last comment, normally A2's. If a comment has been added since, anchor on the end of the last one instead. The status, `claimed`, stays: S3 and the rest of the ticket remain.

Find:
````
S2 stays off `main`, and S3 waits, until the owner answers and his decision entry is recorded (D113).
````
Replace:
````
S2 stays off `main`, and S3 waits, until the owner answers and his decision entry is recorded (D113).

«DATE» — The owner answered OG5 in the question tool: "«OWNER-WORDS»". [D«D-NEXT»](../../../docs/DECISIONS.md#d«D-NEXT»-f2-05-workspace-and-scratch-records-frozen) freezes F2-05, this ticket's four `workspace.*` record types, by addition to `ledger-format` version 1, at d4e3032. S2 reached `main` as «RECORD-COMMIT», whose `contract/ledger` is byte-identical to d4e3032's, with the documents commit that records the freeze and drops the "proposed" wording. Two lines inside D112's approved range change: `ROADMAP-CORE.md` C2's proposed scratch lifecycle events record the adoption, and C2's status line records the freeze; neither changes a mechanism. S3, the workspace service that writes these records, may start.
````

#### F30a — .scratch/dwarf-harness/c2-evidence/f2-05-freeze-packet.md

This packet's answer line, if you picked the option as written; otherwise apply F30b. Apply to the first occurrence only: the header, line 3.

Find:
````
**Answer:** pending.
````
Replace:
````
**Answer:** «DATE», "Freeze as presented". [D«D-NEXT»](../../../docs/DECISIONS.md#d«D-NEXT»-f2-05-workspace-and-scratch-records-frozen) records the freeze from section 8's draft, and Appendix A.2's edits record it in the register, the roadmaps and ticket 05; S2 reached `main` as «RECORD-COMMIT». The rest of this packet stays as sent.
````

#### F30b — .scratch/dwarf-harness/c2-evidence/f2-05-freeze-packet.md

This packet's answer line, if you answered in your own words; otherwise apply F30a. Apply to the first occurrence only: the header, line 3.

Find:
````
**Answer:** pending.
````
Replace:
````
**Answer:** «DATE», "Freeze as presented" in your own words: "«OWNER-WORDS»". [D«D-NEXT»](../../../docs/DECISIONS.md#d«D-NEXT»-f2-05-workspace-and-scratch-records-frozen) records the freeze, adapted from section 8's draft to your answer, and Appendix A.2's edits record it in the register, the roadmaps and ticket 05; S2 reached `main` as «RECORD-COMMIT». The rest of this packet stays as sent.
````

**After applying A.2:**

1. **No placeholder is left** outside this packet. This prints nothing:
   `Select-String -Path docs\*.md, contract\ledger\*.go, .scratch\dwarf-harness\issues\05-*.md -Pattern '«|»'`
2. **The right files changed.** `git diff --stat HEAD~1` lists:
   - `docs/DECISIONS.md`, `docs/CONTRACTS.md`, `docs/ROADMAP-CORE.md`, `docs/ROADMAPS.md`, `docs/DESIGN-UNDERCURRENT.md` and `docs/ROADMAP-UNDERCURRENT.md`;
   - five Go files of `contract/ledger`, in comments only;
   - ticket 05 and this packet.
3. **Nothing else in `contract/ledger` moved.** `git diff HEAD~1 -- contract/ledger/testdata` prints nothing, and `git diff HEAD~1 -- contract/ledger` changes comment lines only.
4. **Each edit applied once.** Each find occurs zero times, unless its replacement repeats it, and each replacement once.
5. **The check passes.** `go run ./tools/check` passes all nine steps on the commit, with `DWARF_CC` set (D46).

### A.3 Other answers

- **"Freeze with changes":**
  - an adapted F30b records your answer and the changes you named, and a ticket 05 comment records them too;
  - the open item stays, its Notes naming the follow-up;
  - the follow-up change on `build/05-f2` makes the changes and reruns Appendix C;
  - the entry, **Decided by:** modified, and A.2's edits then land against its commit, which takes the place of d4e3032;
  - S2 stays off `main` until then (D113).
- **"Not yet":**
  - an adapted F30b records your answer, and a ticket 05 comment records it too;
  - the open item stays, its Notes recording the answer;
  - no entry is recorded and no other A.2 edit is made;
  - S2 stays off `main` and S3 waits.

### A.4 Unchanged, and why

- **D112's and D113's text.** Entries are never edited (DEC:5); D113 gains only F1's line.
- **The first paragraph of `contract/ledger`'s documentation.** "the ledger-format and ledger-reader contract (F0)" and "a draft until its owner freeze" (DOC, opening; `contract/ledger/appender/appender.go:37`) stay as written. They were not updated after D111 either, and OG4's packet leaves them the same way. A separate documentation fix may correct them.
- **Dated history.** The earlier entries of the status lines (REG:3, RC:3, RM:3) and the ticket's earlier comments stay.
- **Lines that stay true:**
  - CORE:844 and RC:220, whose "before C2 producer implementation" governs the later parts;
  - RC:271, :274 and :407;
  - RC:972, C2's remaining evidence;
  - RU:86, the capability row, which also names base advanced and D23's fields;
  - RU:356, implementation gates;
  - the closing paragraphs of UC §15.1, which still claim no schema complete;
  - CON:38, C2's producer stage;
  - CON:82, the D52 boundary;
  - the readiness row of `RESEARCH-ADMISSIBLE-VALIDATION.md` (line 371), whose "the F2 freeze remains a prerequisite" still holds for the later parts.
- **Contract statuses elsewhere.** Core's Start here, §3.5 and §13 (CORE:23, :39, :201, :824), `ROADMAP-GUI.md` (line 23) and the system specification (SPEC:679) say that the F0 contracts, `ledger-format` among them, are frozen at version 1, which stays true.
- **The status board** (RM:170). No step changes status.
- **`LEDGER-USER-NEEDS.md`.** It is a note dated 2026-10-10 that defers to the package documentation; its row "Promotion and scratch record families, with D23's fields (F2)" stays true in substance, since the promotion records and D23's parent-scratch field remain.
- **Sent and dated texts.** The D52 packet, and the design brief and ruling under `.scratch/dwarf-harness/c2-evidence/`, stay as written.

## Appendix B. `go doc` excerpt at d4e3032

What step R11 of Appendix C prints:

- the package documentation's Catalogue and F2-05 sections;
- the four type constants;
- `Defined`;
- the four payload types, with their decoders and `Encode` methods.

At this commit the documentation still calls F2-05 "proposed"; A.2's F9–F14 change only that wording.

```text
# Catalogue

A Catalogue lists the record type versions a writer may append. Defined
returns those this contract version defines: the four F0 record types and the
four proposed F2-05 types below, each at version 1. F2-05 awaits the owner's
additive freeze; it does not change F0 or format version 1. The type namespace
"ledger." is reserved for F0 record types: no other record family may use it.
The namespace "fixture." is reserved for this contract's golden fixtures and
tests: no record family may use it, and Defined never contains it. The namespace
"workspace." is reserved for C2's record families.

# F2-05 record types

These four proposed version-1 types are ticket 05's part of F2. C2 owns their
payload specifications. Only Core's workspace service (internal/core/workspace)
may append them, through appender.Appender; permitted callers are enforced by
review. The service checks the record rules both when appending and at Open.
Check, Reader, EncodeCommit and these payload encoders and decoders do not
enforce service record rules.

Payloads follow the F0 encoding rules above: compact JSON, keys in the tabled
order, errors wrapping ErrInvalid, no missing required, null known or repeated
keys, and unknown keys ignored for additive evolution. Re-encoding a decoded
payload reproduces the bytes Encode produced. Git object IDs are 40 or 64
lowercase hex digits. A decoder accepts either length; matching the workspace's
object_format is a service record rule.

workspace.registered v1 (WorkspaceRegistered) registers a Git workspace with the
owner's approval.

    key            type    presence  rule
    workspace_id   UUIDv7  required  the workspace's ID
    common_dir     string  required  the absolute common-directory grammar below
    object_format  string required  sha1 or sha256

common_dir accepts exactly: valid UTF-8; 1–4,096 bytes; no byte below 0x20 and
no 0x7F; no backslash; forward slashes only; absolute in one of three forms:
POSIX /…, drive-rooted [A-Za-z]:/…, or UNC //host/share… with non-empty host
and share; no empty component (no // except the two leading UNC slashes);
no component . or ..; no trailing /. Everything else is refused with an error
wrapping ErrInvalid.

This is Git's forward-slash string from rev-parse --path-format=absolute
--git-common-dir, unchanged by Core. Drive-letter case is kept as Git printed
it; the decoder does not fold case. This grammar is lexical, byte-exact and
identical on every host; it checks neither existence nor platform validity,
and makes no host calls. The 4,096-byte cap is a contract rule, not a producer
policy that may be tightened after freeze.

Record rules: actor is owner; body_refs is absent. This is index 0 of a
three-record commit: index 1 is its workspace.capture_inputs_pinned with
revision 1, and index 2 is that record's ledger.body_pin. workspace_id is new,
and no earlier registration names the same common_dir.

workspace.capture_inputs_pinned v1 (CaptureInputsPinned) records one
owner-approved revision of the workspace's capture inputs.

    key                    type    presence  rule
    workspace_id           UUIDv7  required  a registered workspace
    revision               integer required  1 through MaxInt64
    capture_inputs_sha256  digest  required  SHA-256 of the capture-inputs document, a body
    pin_id                 UUIDv7  required  the ledger.body_pin of this revision

Record rules: actor is owner. body_refs is present and holds exactly the
document and every body it names. The same commit holds a ledger.body_pin with
this pin_id and the same body_refs. Revision 1 appears only at index 1 of
the registration commit. Each later revision is the current revision plus 1,
at index 0 of its commit, with its pin at index 1 and the ledger.body_unpin of
the previous revision's pin_id at index 2.

workspace.scratch_created v1 (ScratchCreated) records a context's private
scratch worktree and its trusted root eligibility baseline.

    key           type           presence  rule
    scratch_id    UUIDv7         required  the scratch's ID
    workspace_id  UUIDv7         required  a registered workspace
    context_id    UUIDv7         required  the bound work context that owns the scratch and authors its changes
    dir           string         required  8 lowercase hex digits; scratch/<dir> in the colony directory
    branch        string         required  the refs/heads/ grammar below
    base_commit   Git object ID required  the canonical commit the scratch was cut from
    anchor_tree   Git object ID required  that commit's tree, the root eligibility baseline

branch accepts exactly: valid UTF-8; begins refs/heads/; non-empty suffix;
at most 4,096 bytes; no byte below 0x20 and no 0x7F; no space and no backslash;
no empty component (no //); no trailing /. Everything else is refused with
ErrInvalid. This is a lexical, byte-exact subset, identical on every host.
The decoder checks neither existence nor platform validity. The 4,096-byte cap
is a contract rule.

Git's remaining lexical rules (.., @{, lone @, .lock, leading-dot or
trailing-dot components, ~ ^ : ? * [) are the producer's: Git itself refuses
them when Core creates the branch, so the decoder does not re-implement them.
Core's own naming scheme is a service record rule, not a contract rule: ticket
05's dedicated scratches use branch == "refs/heads/dwarf-harness/" + dir.

Record rules: actor is core; the envelope's context_id equals this context_id;
body_refs is absent. scratch_id is new; the pair (context_id, workspace_id)
has no open scratch. dir and branch were never used by an earlier scratch.
Both Git ID lengths match the workspace's object_format.

workspace.scratch_closed v1 (ScratchClosed) records an explicit closure.

    key         type    presence  rule
    scratch_id  UUIDv7  required  an open scratch
    context_id  UUIDv7  required  the scratch's context
    reason      string  required  ^[a-z][a-z0-9_]*$, at most 64 bytes

Version 1 defines reason abandoned. Reason is an open token: both Encode and
Decode accept every well-formed token, including unknown future reasons. A
reader treats one as a closure for a reason it does not know, never as invalid.
Core writes only reasons its reading version defines; this is a producer rule,
not an encoding rule.

Record rules: actor is owner, or agent with the envelope's context_id equal
to this context_id; body_refs is absent. A scratch closes at most once,
and context_id is the scratch's.

The F2-05 golden at testdata/f2/05/log/00000000000000000001.jsonl holds six
commits and twelve records: two registrations and their pins, two scratches,
one input revision update and its pin/unpin, then one closure. It pins a
drive-rooted path and a POSIX path, both Git ID lengths and revisions 1 and 2.
Tests cover the UNC form separately.
package ledger // import "github.com/Darius-PJ/dwarf-harness/contract/ledger"

const (
	TypeWorkspaceRegistered = "workspace.registered"
	TypeCaptureInputsPinned = "workspace.capture_inputs_pinned"
	TypeScratchCreated      = "workspace.scratch_created"
	TypeScratchClosed       = "workspace.scratch_closed"
)
    The proposed F2-05 record types, each at version 1. The package
    documentation specifies their payloads and service-owned record rules.

package ledger // import "github.com/Darius-PJ/dwarf-harness/contract/ledger"

func Defined() Catalogue
    Defined returns the record type versions this contract version defines, F0's
    catalogue: TypeCommand, TypeBodyPin, TypeBodyUnpin and TypeBodiesCollected;
    and the proposed F2-05 additions: TypeWorkspaceRegistered,
    TypeCaptureInputsPinned, TypeScratchCreated and TypeScratchClosed, each at
    version 1. It never contains a type in the reserved fixture namespace.

package ledger // import "github.com/Darius-PJ/dwarf-harness/contract/ledger"

type WorkspaceRegistered struct {
	WorkspaceID  uuid.UUID `json:"workspace_id"`  // a UUIDv7
	CommonDir    string    `json:"common_dir"`    // Git's absolute, forward-slash common directory
	ObjectFormat string    `json:"object_format"` // sha1 or sha256
}
    WorkspaceRegistered is the payload of a workspace.registered v1 record.

func DecodeWorkspaceRegistered(payload json.RawMessage) (WorkspaceRegistered, error)
    DecodeWorkspaceRegistered decodes a workspace.registered v1 payload.
    Its errors wrap ErrInvalid.

func (p WorkspaceRegistered) Encode() (json.RawMessage, error)
    Encode returns p as a workspace.registered v1 payload. Its errors wrap
    ErrInvalid. It checks the payload rules, not the service's record rules.

package ledger // import "github.com/Darius-PJ/dwarf-harness/contract/ledger"

type CaptureInputsPinned struct {
	WorkspaceID         uuid.UUID `json:"workspace_id"`          // a UUIDv7
	Revision            int64     `json:"revision"`              // at least 1
	CaptureInputsSHA256 Digest    `json:"capture_inputs_sha256"` // not zero
	PinID               uuid.UUID `json:"pin_id"`                // a UUIDv7
}
    CaptureInputsPinned is the payload of a workspace.capture_inputs_pinned v1
    record. The document and every body it names are listed in BodyRefs.

func DecodeCaptureInputsPinned(payload json.RawMessage) (CaptureInputsPinned, error)
    DecodeCaptureInputsPinned decodes a workspace.capture_inputs_pinned v1
    payload. Its errors wrap ErrInvalid.

func (p CaptureInputsPinned) Encode() (json.RawMessage, error)
    Encode returns p as a workspace.capture_inputs_pinned v1 payload. Its errors
    wrap ErrInvalid. Revision sequencing is a service record rule.

package ledger // import "github.com/Darius-PJ/dwarf-harness/contract/ledger"

type ScratchCreated struct {
	ScratchID   uuid.UUID `json:"scratch_id"`   // a UUIDv7
	WorkspaceID uuid.UUID `json:"workspace_id"` // a UUIDv7
	ContextID   uuid.UUID `json:"context_id"`   // a UUIDv7
	Dir         string    `json:"dir"`          // 8 lowercase hex digits
	Branch      string    `json:"branch"`       // a full refs/heads/ name
	BaseCommit  string    `json:"base_commit"`  // 40 or 64 lowercase hex digits
	AnchorTree  string    `json:"anchor_tree"`  // 40 or 64 lowercase hex digits
}
    ScratchCreated is the payload of a workspace.scratch_created v1 record.

func DecodeScratchCreated(payload json.RawMessage) (ScratchCreated, error)
    DecodeScratchCreated decodes a workspace.scratch_created v1 payload.
    Its errors wrap ErrInvalid.

func (p ScratchCreated) Encode() (json.RawMessage, error)
    Encode returns p as a workspace.scratch_created v1 payload. Its errors wrap
    ErrInvalid. Git ID lengths matching the workspace's object format and Core's
    branch naming scheme are service record rules.

package ledger // import "github.com/Darius-PJ/dwarf-harness/contract/ledger"

type ScratchClosed struct {
	ScratchID uuid.UUID `json:"scratch_id"` // a UUIDv7
	ContextID uuid.UUID `json:"context_id"` // a UUIDv7
	Reason    string    `json:"reason"`     // [a-z][a-z0-9_]*, at most 64 bytes
}
    ScratchClosed is the payload of a workspace.scratch_closed v1 record.
    Reason is an open token; v1 defines abandoned. Core's producer writes only
    reasons its reading version defines, but encoding and decoding preserve
    every well-formed token so newer reasons remain readable.

func DecodeScratchClosed(payload json.RawMessage) (ScratchClosed, error)
    DecodeScratchClosed decodes a workspace.scratch_closed v1 payload, including
    unknown well-formed reasons. Its errors wrap ErrInvalid.

func (p ScratchClosed) Encode() (json.RawMessage, error)
    Encode returns p as a workspace.scratch_closed v1 payload, accepting every
    well-formed reason token. Its errors wrap ErrInvalid.
```

## Appendix C. The runner's commands

**Setup.** Run in Windows PowerShell, in a separate detached worktree of d4e3032, as for 31103d8's record. Run every block from the worktree's root, after:

```powershell
$env:GOTOOLCHAIN = 'local'; $env:GOFLAGS = ''; $env:CGO_ENABLED = '0'
```

Report each step's exit codes and the output it names. Delete any temporary file afterwards, and make no Git write.

**R0. Identity.** Report all output.

```powershell
git rev-parse HEAD
git log --format='%H %s' b663791..HEAD
git status --porcelain
git diff --stat 31103d8 HEAD
git diff --exit-code 31103d8 HEAD -- contract/ledger/testdata; "EXIT=$LASTEXITCODE"
```

Expected:

- HEAD is d4e3032;
- the log lists the fix-up and 31103d8, nothing else;
- status is empty;
- the diffstat names only the fix-up's files;
- `EXIT=0`.

**R1. Every test, twice.** Report each run's exit code, counts and `ok` lines, the `#` count, and the `Compare-Object` output.

```powershell
go clean -testcache
foreach ($n in 1, 2) {
  go test -count=1 -v ./contract/ledger ./internal/core/ledgerstore > "$env:TEMP\og5-v2-$n.txt" 2>&1
  "run $n EXIT=$LASTEXITCODE"
  $t = Get-Content "$env:TEMP\og5-v2-$n.txt"
  'PASS={0} FAIL={1} SKIP={2}' -f @($t | Select-String -SimpleMatch -Pattern '--- PASS').Count, @($t | Select-String -SimpleMatch -Pattern '--- FAIL').Count, @($t | Select-String -SimpleMatch -Pattern '--- SKIP').Count
  $t | Select-String -Pattern '^ok\s'
  'F2_05 names with a # suffix: {0}' -f @($t | Select-String -Pattern 'TestF2_05\S*#\d').Count
}
$a = Get-Content "$env:TEMP\og5-v2-1.txt" | Select-String -Pattern '--- (PASS|FAIL|SKIP): (\S+)' | ForEach-Object { $_.Matches[0].Groups[2].Value } | Sort-Object
$b = Get-Content "$env:TEMP\og5-v2-2.txt" | Select-String -Pattern '--- (PASS|FAIL|SKIP): (\S+)' | ForEach-Object { $_.Matches[0].Groups[2].Value } | Sort-Object
Compare-Object $a $b
Remove-Item "$env:TEMP\og5-v2-*.txt"
```

Expected:

- both runs exit 0, with `FAIL=0` and `SKIP=4`;
- the same `PASS` count in both runs;
- two `ok` lines per run;
- no `#` suffix;
- `Compare-Object` prints nothing.

**R2. Fuzzing.** Report the last three lines of each run and the status output.

```powershell
go test ./contract/ledger -run '^$' -fuzz '^FuzzDecodeF2_05$' -fuzztime 120s
go test ./contract/ledger -run '^$' -fuzz '^FuzzCheckTruncation$' -fuzztime 120s
git status --porcelain -- contract/ledger/testdata
```

Expected: both `PASS` and `ok`; status empty.

**R3. Imports.**

```powershell
go list -deps -f '{{if not .Standard}}{{.ImportPath}}{{end}}' ./contract/ledger
```

Expected: `github.com/Darius-PJ/dwarf-harness/contract/ledger` only.

**R4. Dependencies.**

```powershell
go mod tidy -diff; "EXIT=$LASTEXITCODE"
go mod verify
```

Expected: no diff and `EXIT=0`; `all modules verified`.

**R5. Golden files.**

```powershell
go test ./contract/ledger -run '^TestGolden' -update; "EXIT=$LASTEXITCODE"
git status --porcelain -- contract/ledger/testdata
Get-ChildItem -Recurse -File contract/ledger/testdata/f0, contract/ledger/testdata/f2 | ForEach-Object { '{0}  {1}' -f (Get-FileHash -Algorithm SHA256 -LiteralPath $_.FullName).Hash.ToLower(), (Resolve-Path -Relative -LiteralPath $_.FullName) }
```

Expected:

- `EXIT=0`, and status empty;
- four lines with these digests:
  - c72c4a739965586d984b524dbc6ee67a5b9d866756639fbb03b04e90f441f2e5 (`f0/log/…0001`);
  - 3ee9f566e69e9cccb89ed435afee322950d3084a69ed0301684c15be70f8e65b (`f0/log/…0005`);
  - 319c805312afd1abf824d306bcd799dd42bd3ae04fdf33fb74bc3f742ac8c898 (`f0/catalogue/log/…0001`);
  - 843663a168e472adf4656fdba4ffa6db770e588feec0020bb10e20bf14def437 (`f2/05/log/…0001`).

**R6. Line endings.**

```powershell
git ls-files --eol -- contract/ledger/testdata/f2
```

Expected: `i/lf w/lf`.

**R7. Formatting and vet.**

```powershell
gofmt -l contract/ledger
foreach ($o in 'linux', 'darwin') { $env:GOOS = $o; go vet ./contract/ledger; "$o EXIT=$LASTEXITCODE" }
Remove-Item Env:GOOS
```

Expected: `gofmt` lists nothing; both `EXIT=0`, with no finding.

**R8. The full check.** Use the pinned compiler, as `AGENTS.md` "Check" describes. Report the summary block.

```powershell
$env:DWARF_CC = '<the pinned clang path>'
go run ./tools/check; "EXIT=$LASTEXITCODE"
```

Expected: all nine steps `PASS`; `EXIT=0`.

**R9. Additivity.**

```powershell
git diff --stat b663791 HEAD -- contract/ledger docs/CONTRACTS.md
git diff -U0 b663791 HEAD -- contract/ledger | Select-String -Pattern '^-[^-]'
```

Expected: the 14 removed lines of §5.5, and no others.

**R10. Golden record sizes.** Each count is the line's UTF-8 bytes plus its LF.

```powershell
$i = 0; Get-Content -Encoding UTF8 contract/ledger/testdata/f2/05/log/00000000000000000001.jsonl | ForEach-Object { $i++; 'seq {0}: {1} bytes' -f $i, ([Text.Encoding]::UTF8.GetByteCount($_) + 1) }
```

Expected: twelve lines, each under 1,024 bytes.

**R11. The `go doc` excerpt.** Report the output verbatim; it is Appendix B.

```powershell
$doc = @(go doc -all ./contract/ledger)
$i1 = [array]::IndexOf($doc, '# Catalogue'); $i2 = [array]::IndexOf($doc, '# F0 record types')
$i3 = [array]::IndexOf($doc, '# F2-05 record types'); $i4 = [array]::IndexOf($doc, 'CONSTANTS')
$doc[$i1..($i2 - 1)]
$doc[$i3..($i4 - 1)]
go doc -all ./contract/ledger TypeWorkspaceRegistered
foreach ($s in 'Defined', 'WorkspaceRegistered', 'CaptureInputsPinned', 'ScratchCreated', 'ScratchClosed') { go doc -all ./contract/ledger $s }
```

Expected: the two sections, the constant block and the five declarations with their documentation. If an index is -1, report the headings `go doc` printed instead.

**R12. The grammar paragraphs as stored.**

```powershell
$src = @(git show HEAD:contract/ledger/doc.go)
foreach ($p in 'common_dir accepts exactly:', 'branch accepts exactly:') {
  $k = ($src | Select-String -SimpleMatch -Pattern $p).LineNumber - 1
  $src[$k..($k + 12)]
}
```

Expected: two blocks of 13 lines, whose words, without the `// ` prefixes, equal §4.2's two quotations.
