# T05 brief: ticket 05 — create private scratch and capture exact eligible trees

Designer: DesignT05, 2026-10-12. Status: **ruled by the advisor on 2026-10-12, approve-with-changes; see [the ruling](ticket-05-design-ruling.md), which wins where the two differ.** The owner approves the design before any code starts (T05:49), and the gates in §7.2 stay with him. Where the advisor's ruling differs from this brief, the ruling wins.

**Sources** are cited as `file:line` at `main` dfe2414, where D112 is recorded. Abbreviations:
- T05 = `.scratch/dwarf-harness/issues/05-create-private-scratch-and-capture-exact-eligible-trees.md`; T06–T09 = issues 06–09 in the same folder.
- RC = `docs/ROADMAP-CORE.md`; RM = `docs/ROADMAPS.md`; CORE = `docs/DESIGN-CORE-AND-LAUNCHERS.md`; DEC = `docs/DECISIONS.md`; CON = `docs/CONTRACTS.md`; UC = `docs/DESIGN-UNDERCURRENT.md`; RU = `docs/ROADMAP-UNDERCURRENT.md`; SPEC = `.scratch/dwarf-harness/spec.md`; PKT = `.scratch/dwarf-harness/c2-evidence/d52-c2-approval-packet.md`; AGENTS = `AGENTS.md`.
- DEC numbering is dfe2414's. D112 added a line after DEC:349 and one after DEC:542, so D53–D75 now sit one line, and D76 onward two lines, below the packet's citations.
- `ledger/…` = `contract/ledger/…`; `appender` = `contract/ledger/appender`; `ledgerstore/…` = `internal/core/ledgerstore/…`; `check/…` = `tools/check/…`.
- **G1** = runner probe R1–R7 (`local://t05-git-probe-result.md`); **G2** = runner probe R8–R9 (`local://t05-git-probe-result-2.md`). Both ran git 2.55.0.windows.3 and go1.27.2 on the owner's machine. Appendix D lists what this brief takes from them.

The runner map `local://t05-map.md` served only as an index; every passage cited here was re-read. **(my choice)** marks a value that no source fixes.

---

## 0. Owner summary

**What ticket 05 builds:** the first C2 code, a Core package `internal/core/workspace`.
- **Workspaces.** You register a Git repository. Core shows you its line-ending settings and its existing local and global ignore and attribute files. What you approve is pinned, and only you can change it later (D75, D112). Registration refuses a folder that is not a Git repository, has no `main`, or has `main` checked out anywhere (D48).
- **Scratches.** On a context's first use of a workspace, Core gives it one private worktree on its own branch, cut from `main`'s tip. A scratch is never shared or reused, and `main` is never checked out (RC:285).
- **Capture.** Core reads and hashes every captured file itself and never trusts the Git index. It stores Git's canonical form of every tracked edit and deletion, plus every new file that neither the scratch's own `.gitignore` nor your pinned exclusions exclude (D60, D74–D76). A sealed capture cannot change afterwards, whatever happens to the scratch, its index or any Git setting.
- **Explicit refusals.** Capture refuses what it cannot record exactly: pipes, devices and junctions; symlinks, nested repositories and submodules; filters such as Git LFS, plus `working-tree-encoding` and `ident`; paths that differ only in case; line endings that normalization would destroy; files Git cannot see, such as over-long paths; and scratches over the file or byte limit (RC:285, :328, :372).
- **Promotion.** A promotion request first tries to reserve the scratch. If the scratch is in use, the answer is "busy", at once. Otherwise it is "unavailable", because no validator exists before C4. `main` never moves and nothing is recorded as accepted (D52, D112).
- **Closing.** A scratch closes only when Core can prove that it holds no edit Core has not captured. Its ignored files, such as build output, are deleted with it.

**Not built here:** the four-checkpoint queue, request deduplication and the merge train (ticket 06); temporary scratches (07); finalization and recovery (08); policy activation (09). Accepted promotion waits for C4.

**Consequences to know.** A Git upgrade makes capture unavailable until you re-approve the workspace's inputs (P13). In v1, repositories with symlinks, submodules or LFS cannot be captured (P9). The caps are provisional: 100,000 files and 1 GiB per capture (P21).

**Owner gates.** OG-A: approve this design before any code. OG-B: whether C2's event family F2 is frozen in parts, ticket by ticket (recommended), or once for all of C2, and whether code that writes no ledger record may start before the freeze (recommended: yes).

**Later.** A freeze request for ticket 05's four record types (§8, Appendix B), sent before any code that writes them.

---

## 1. Owned paths

The coder creates or edits exactly these. Non-test `.go` file names are not API and may be merged or split; testdata paths are exact.

**S1 — mechanics that write no ledger record** (all new):

```
internal/core/workspace/doc.go          package documentation: the specification of §2 (model, rules, Git calls, refusals)
internal/core/workspace/git.go          Git runner: resolution, version gate, the three environments, GitError
internal/core/workspace/gitparse.go     parsers of -z output: ls-files -s, NUL lists, check-attr, worktree list, cat-file headers, git version
internal/core/workspace/inputs.go       Inspect, the capture-inputs document and digest, materialization
internal/core/workspace/capture.go      capture engine (observe and seal), rules, manifest
internal/core/workspace/eol.go          the round-trip rule of P8 (streaming LF to CRLF hashing)
internal/core/workspace/reserve.go      scratch exclusion and the capture-bytes pool
internal/core/workspace/profile.go      CaptureProfile, ProvisionalCaptureProfile
internal/core/workspace/worktree.go     worktree add, materialize, remove; marker, anchor and capture refs
internal/core/workspace/errors.go       sentinels and typed errors (§2.13)
internal/core/workspace/helpers_test.go           disposable repositories, controlled test environment
internal/core/workspace/git_test.go
internal/core/workspace/gitparse_test.go
internal/core/workspace/inputs_test.go
internal/core/workspace/capture_test.go
internal/core/workspace/capture_windows_test.go
internal/core/workspace/capture_posix_test.go     //go:build linux || darwin
internal/core/workspace/capture_linux_test.go     non-UTF-8 names only
internal/core/workspace/eol_test.go
internal/core/workspace/reserve_test.go
internal/core/workspace/worktree_test.go
internal/core/workspace/worktree_windows_test.go
internal/core/workspace/fuzz_test.go
internal/core/workspace/workload_test.go          capture-cost harness (P29); skips unless asked
internal/core/workspace/testdata/fuzz/Fuzz*/...   only failing inputs found by fuzzing, kept as seeds
```

**S2 — ticket 05's part of F2, drafted in the frozen ledger contract** (additions only):

```
contract/ledger/workspace.go            the four F2-05 types: constants, payload structs, Encode, Decode
contract/ledger/catalogue.go            Defined() gains the four types at version 1
contract/ledger/doc.go                  catalogue paragraph; the namespace workspace.; section "F2-05 record types"
contract/ledger/records.go              only if shared member accessors (string, Git ID, token) belong there
contract/ledger/workspace_test.go       round trip and refusals
contract/ledger/golden_test.go          TestGoldenF2_05; TestGoldenDecodes over the new golden
contract/ledger/fuzz_test.go            FuzzDecodeF2_05; FuzzCheckTruncation seeded with the new golden
contract/ledger/testdata/f2/05/log/00000000000000000001.jsonl
docs/CONTRACTS.md                       status line (:3); ledger-format row (:25); an "F2-05 catalogue (proposed)" table after :56
```

**S3 — the service, which writes the F2-05 records** (new):

```
internal/core/workspace/service.go      Open, Close, Reconciliation, projections, replay rules, poisoning
internal/core/workspace/register.go     Register, UpdateInputs
internal/core/workspace/scratch.go      Scratch, BeginWrite, CloseScratch
internal/core/workspace/promote.go      RequestPromotion
internal/core/workspace/service_test.go
internal/core/workspace/register_test.go
internal/core/workspace/scratch_test.go
internal/core/workspace/scratch_windows_test.go
internal/core/workspace/promote_test.go
internal/core/workspace/replay_test.go
```

**S4 — documents** (edits, §2.17): `docs/ROADMAP-CORE.md` (:3, :417), `docs/ROADMAPS.md` (:3, :170), `docs/DECISIONS.md` (one new entry, B«next»), `docs/DESIGN-CORE-AND-LAUNCHERS.md` (new Appendix A.11 after :1353; Appendix A's heading at :1025). The PM writes ticket 05's comments.

**Not touched:** `contract/ledger/appender/**`, `internal/core/ledgerstore/**`, `internal/core/durable/**`, `tools/check/**` (its `internal/core/...` and `contract/...` rows already admit every import here), `go.mod`, `go.sum`, `.gitattributes`, `cmd/**`; the D112-approved text RC:278–416 and CORE:848–882, except the status line RC:417 (P31). No module is added (D29).

---

## 2. Exact behavior

### 2.1 Scope and gates

**What ticket 05 builds** (T05:12, :28–31; RC:280, :282, :285, :290, :328, :334, :372; CORE:211–214, :854, :856):
- registration of Git workspaces with owner-approved, pinned capture inputs, and the owner's later updates of them;
- one dedicated scratch worktree per (context, workspace), created on first use, never on `main`;
- the capture engine: the full Git-canonical eligible tree against a trusted baseline, Core's own raw observation, explicit refusals, and a sealed result that later edits cannot change;
- reservation before capture: scratch exclusion and a capture-bytes pool, immediate busy, and the C2 promotion entry, which answers busy or unavailable;
- closure that cannot discard unrepresented edits;
- ticket 05's part of F2 (Appendix B) and the records it writes.

**Not built here:**
- **Ticket 06:** request IDs and D58 deduplication; the K=4 FIFO and Q=4N capacity; local-head checks; successor baselines; submission and admission records; `merge-tree` integration; generations; lineage failure (T06:28–31; CORE:850–860).
- **Ticket 07:** temporary scratch; end-of-turn commits of observed changes; changed-path events; merge-back and its capture window (T07:28–30; RC:284).
- **Ticket 08:** finalization, cancellation, recovery and no-change; the guarded update of `main` (T08:28–32).
- **Ticket 09:** policy activation (T09:12).
- **C3:** authenticating owner and agent requests (RC:313); wiring scratches to turns; command identities for these operations (B21 item 9, DEC:1433–1436); the host's configuration of the profile.
- **C4:** the validator; materializing candidates for runs; capture cost at the feasibility gate (RC:285, :409).
- **C10:** protection against same-user changes to refs, objects, configuration and scratches (RC:410; CORE:251).
- **Later C2 work:** scratch base advance; dormant garbage collection; the post-promotion interference check (RC:288–289, both [PROPOSAL]).

**Gates** (T05:22–24):
- *D52 approval.* Met by D112 (DEC:1523–1535; T05:51; RC:406, :417).
- *Consumed ledger families frozen.* `ledger-format`, `ledger-reader` and `ledger-appender` are frozen at version 1 (D111, DEC:1509–1521; RC:407).
- *Ticket 05's own records.* They belong to F2: proposed here (Appendix B) and frozen by the owner under D40 before the code that writes them (RC:220, :407; CORE:844; D112 "Not decided here", DEC:1533). How F2 is staged is OG-B.
- *Testing-only.* Unchanged. Promotion stays unavailable, and nothing is accepted (DEC:341–342; RC:290; T05:20).
- *D41.* S1 and S3 touch no frozen contract, decision text or dependency. S2 adds to the frozen `ledger-format`, so it reaches `main` only with the owner's F2-05 freeze (DEC:213; CON:13–17).
- *Design approval.* OG-A (T05:49).

### 2.2 Package, imports and seams

- **Package:** `internal/core/workspace`, package `workspace`. D45 lists "workspace" among `internal/core`'s contents (DEC:263), and package names are the step's (DEC:273).
- **Imports:** the standard library; `contract/ledger`; `contract/ledger/appender` (D50 DEC:328); `internal/core/ledgerstore` (the same tree, B17 item 4, DEC:1132 ff.). This is within D45's `internal/core/...` row (DEC:283). No `golang.org/x/...` and no new module (D29 DEC:124–129). No cgo (D28). There is no OS-specific production file: Go's `os` reports Windows junctions as `ModeIrregular` (G2-R9); only tests split by platform.
- **Store dependency.** An unexported interface that `*ledgerstore.Store` satisfies: `appender.Appender`, `PublishBody`, `ReadBody`, `LogDir`, `Colony`, `Durable`. Production passes the store. Tests pass the real store, or a wrapper around it that injects one append failure (P27).
- **Seams.** Unexported `deps`, as in ledgerstore (`ledgerstore/store.go`, `deps`): the environment of host inspection (`environ`), ID minting (`newID`), hooks between capture steps (`afterRawRead`, `beforeSeal`), the hook before scratch creation appends (`beforeAppend`), the removal function (`removeAll`), and the profile, which tests lower. They serve deterministic regressions and prove no platform behavior (B18 item 8).

### 2.3 Colony layout

Under the colony directory (D38 DEC:192, which lists `workspaces/` and `scratch/<short id>/`):

```
workspaces/
  empty                  empty file: the global config file of Core's controlled Git calls
  nohooks/               empty directory: core.hooksPath of Core's calls in workspace repositories
  <wdir>/                one per workspace; <wdir> = 8 lowercase hex digits (P16)
    inputs/<revision>/   the materialized pinned inputs of that revision (§2.5)
    tmp/                 capture index files in use; Open empties it
scratch/
  <dir>/                 one per scratch; <dir> = 8 lowercase hex digits, never reused
```

Open creates missing directories with mode 0o700 and the empty file with 0o600, as ledgerstore does (B18 item 6). Nothing here is authority: the ledger and the body store are. `inputs/` is rebuilt from pinned bodies, and `tmp/` is disposable (B3 DEC:657).

### 2.4 Git invocation

- **Program.** At Open, `exec.LookPath("git")` gives the absolute path of the `git` program (RC:287 [PROPOSAL], adopted by B«next» under RM:232). Git's own ignore, attribute and conversion code is the "recorded library" that D29 asks for in a format with many edge cases (DEC:127), and it adds no module.
- **Version.** The text after `git version ` in `git version`'s output, for example `2.55.0.windows.3` (G1-R1). The minimum is **2.42** (my choice), for `GIT_CONFIG_GLOBAL` (2.32), `--path-format=absolute` (2.31), `worktree list --porcelain -z` (2.36), `core.fsync` (2.36), `git var GIT_ATTR_*` (2.42), and ticket 06's `merge-tree --write-tree` (2.38). If Git is missing or older, Open still succeeds. Inspect, Register, UpdateInputs and Scratch then fail with `ErrGitUnavailable`, and captures, closures and requests are unavailable with reason `git_unavailable`.
- **Calls.** `exec.CommandContext` with `WaitDelay` of 5 s (my choice), so that an ended `ctx` ends the call. stderr is kept to 64 KiB (my choice). Each call states the exit codes it expects; any other exit returns `*GitError{Args, Exit, Stderr}`, which matches `ErrGit`. Outcomes are decided from exit codes, `-z` output and Core's own checks, never from message text (the principle of CORE:858).
- **Three environments.**
  1. **Inspection**, which reads the owner's live setup (§2.6). It starts from `os.Environ()` (the `environ` seam) and removes the repository-location variables `GIT_DIR`, `GIT_WORK_TREE`, `GIT_INDEX_FILE`, `GIT_OBJECT_DIRECTORY`, `GIT_ALTERNATE_OBJECT_DIRECTORIES`, `GIT_COMMON_DIR`, `GIT_NAMESPACE`, `GIT_CEILING_DIRECTORIES` and `GIT_DISCOVERY_ACROSS_FILESYSTEM`. It then sets `GIT_TERMINAL_PROMPT=0` and `GIT_OPTIONAL_LOCKS=0`. Configuration variables stay, so Core sees what the owner's Git sees.
  2. **Repository**, for Core's changes in a workspace repository: `worktree add/list/remove/prune`, `update-ref`, `hash-object` for the marker, `cat-file`, `rev-parse`, `for-each-ref`. It removes every variable whose name begins `GIT_` (case-insensitively on Windows), then sets `GIT_CONFIG_NOSYSTEM=1`, `GIT_CONFIG_GLOBAL=<colony>/workspaces/empty`, `GIT_NO_REPLACE_OBJECTS=1`, `GIT_TERMINAL_PROMPT=0` and `GIT_OPTIONAL_LOCKS=0`. Arguments begin `--git-dir=<common dir> -c core.hooksPath=<colony>/workspaces/nohooks -c core.fsmonitor=false -c core.fsync=committed -c core.fsyncMethod=fsync`. The repository's own configuration is still read, since Git cannot use a repository without it. But hooks and the fsmonitor are off and none of these calls converts file content, so no repository-configured program runs (CORE:858 "controlled config"; D74 DEC:535).
  3. **Capture**, for §2.8 and scratch materialization. It is environment 2 without `--git-dir`, plus `GIT_DIR=<inputs dir>/git` (the private Git directory of §2.5), `GIT_WORK_TREE=<scratch dir>`, `GIT_INDEX_FILE=<index path>`, `GIT_OBJECT_DIRECTORY=<common dir>/objects` and `GIT_ATTR_NOSYSTEM=1`. The workspace's configuration, hooks, `info/exclude`, `info/attributes` and refs are not read at all; the pinned inputs replace them. G1-R2 found that this needs no `objects/` directory in the private Git directory and leaves the scratch's own index unchanged.
- **Paths.** Absolute paths come from `filepath.Abs`; Git prints `/` on Windows too (G1-R1). Repository-relative paths in `-z` output and on stdin use `/`.
- **Object IDs.** Lowercase hex, 40 digits for `sha1` and 64 for `sha256`, in each repository's own format (D36 DEC:179). The zero ID used for "must not exist" in `update-ref` has the same length.
- Core never fetches. A repository whose needed objects are not local fails with `ErrGit` at scratch creation or capture.

### 2.5 Capture inputs (`WorkspaceCaptureInputs`)

**What is pinned** (CORE:854; RC:328; D74–D76; D112):

| Input | Read at inspection from | Used in capture as |
|---|---|---|
| Git version | `git version` | must equal the running Git's version, else unavailable `inputs_stale` (P13) |
| object format | `git rev-parse --show-object-format` | private config; ID length |
| `core.autocrlf` | `git config --type=bool-or-str --get core.autocrlf` (absent: `false`) | private config |
| `core.eol` | `git config --get core.eol` (absent: `native`) | private config |
| `core.filemode`, `core.ignorecase`, `core.symlinks`, `core.precomposeunicode`, `core.longpaths` | `git config --type=bool --get <key>`; absent: Git's defaults `true`, `false`, `true`, `false`, `false` | private config |
| `core.safecrlf` | not imported; always `false` (P8) | private config |
| local excludes | `<common dir>/info/exclude` | private `info/exclude` |
| global excludes | the file `core.excludesFile` names; if unset, `$XDG_CONFIG_HOME/git/ignore` when that variable is set and non-empty, else `<home>/.config/git/ignore` | the file the private `core.excludesFile` names |
| local attributes | `<common dir>/info/attributes` | private `info/attributes` |
| global attributes | the file `git var GIT_ATTR_GLOBAL` prints | after the system bytes in the private `core.attributesFile` |
| system attributes | the file `git var GIT_ATTR_SYSTEM` prints | before the global bytes |
| capture rules | `capture-rules/1`: the rules of §2.8, with no filter granted (P9) | code |

- `<home>` is `HOME` if set, else `os.UserHomeDir()` (my choice). On Windows that is `%USERPROFILE%`, where the owner's Git looks (G1-R1: `GIT_ATTR_GLOBAL` printed `C:/Users/darius.jones/.config/git/attributes`).
- Configuration reads use the inspection environment with `git --git-dir=<common dir> config ...`.
- Each file is held as bytes, and absent is distinct from empty. A file over 1 MiB (my choice) makes Inspect fail with `ErrInputsTooLarge`.
- **The capture-inputs document.** Core-internal, not a contract. Compact JSON with exactly these keys in this order and no trailing newline: `format` (`"dwarf-harness/capture-inputs"`), `version` (1), `rules`, `git_version`, `object_format`, `core.autocrlf`, `core.eol`, `core.filemode`, `core.ignorecase`, `core.longpaths`, `core.precomposeunicode`, `core.symlinks`, and then the digests of the present files: `local_excludes`, `global_excludes`, `local_attributes`, `global_attributes`, `system_attributes` (64 lowercase hex each). Settings are strings as Git prints them. The decoder refuses unknown, missing, repeated or null keys.
- **The capture-input digest** is the SHA-256 of the document's bytes. It is CORE:852's "capture-input digest" and Appendix B's `capture_inputs_sha256`.
- **Bodies.** The document and each present file are published to the colony's body store with `PublishBody`. They are pinned with F0 `ledger.body_pin` while their revision is current (§2.6). Open reads the current revision's bytes once with `ReadBody`, which verifies them, and keeps them in memory.
- **Materialization.** `workspaces/<wdir>/inputs/<revision>/` holds:
  - `git/HEAD`, containing `ref: refs/heads/capture` and LF;
  - `git/refs/`, empty;
  - `git/info/exclude` and `git/info/attributes` (empty files when the pinned file is absent);
  - `git/config`;
  - `global-excludes` and `attributes`.

  `git/config`:
  - `[core]`: `repositoryformatversion = 0` for `sha1`, or `1` with `[extensions] objectFormat = sha256`; `bare = false`; the seven pinned settings; `safecrlf = false`; `excludesFile` = the absolute path of `global-excludes`, or of `workspaces/empty` when that file is absent; `attributesFile` = the absolute path of `attributes`; `fsmonitor = false`, `untrackedCache = false`, `splitIndex = false`, `quotePath = false`, `fsync = committed`, `fsyncMethod = fsync`.

  `attributes` holds the system bytes, then one LF if they are non-empty and do not end in LF, then the global bytes. Global therefore overrides system, because a later line overrides an earlier one (gitattributes).
- Before each capture or materialization, Core compares every materialized file with the bytes it derives from the pinned inputs. A missing or different file causes that revision's directory to be rewritten (each file through a temporary file and a rename) before use, so a tampered file is never trusted.

### 2.6 Workspace registration and input updates

**`Inspect(ctx, root) (Proposal, error)`** (S1; read-only, inspection environment):
1. `git -C <root> rev-parse --path-format=absolute --git-common-dir --show-object-format`. A non-zero exit returns `ErrNotGitRepository`; Core never runs `git init` (CORE:211).
2. `git --git-dir=<common dir> rev-parse --verify --quiet --end-of-options refs/heads/main^{commit}`. Absent: `ErrNoCanonical` (D48 DEC:314; RC:295).
3. `git --git-dir=<common dir> worktree list --porcelain -z`. Any record with `branch refs/heads/main` returns `ErrCanonicalCheckedOut` (D48; RC:295; T05:28). A bare repository's own record says `bare` and passes.
4. The inputs of §2.5.

It returns `Proposal{CommonDir, GitVersion, ObjectFormat, Normalization, LocalExcludes, GlobalExcludes, LocalAttributes, GlobalAttributes, SystemAttributes}`. Each of the last five is `HostFile{Present bool; Bytes []byte}`. This is what Core displays at setup (CORE:854).

**`Register(ctx, p Proposal) (Workspace, error)`** (S3) is the owner's approval (D112); the caller has authenticated the owner (P28).
1. Core inspects `p.CommonDir` afresh. `CommonDir`, `GitVersion`, `ObjectFormat` and `Normalization` must equal `p`'s, else `ErrStaleProposal`. The five files are the owner's to edit: Core records exactly what he approves (D75 DEC:541 "import/review"; D112).
2. No workspace in this colony may have the same common directory (`os.SameFile`), else `ErrExists`.
3. The marker (P18). Core reads `refs/dwarf-harness/colony` with `cat-file blob`.
   - Present with another colony's ID: `ErrOtherColony`.
   - Absent: Core writes the blob `dwarf-harness colony <colony ID>` and LF with `hash-object -w --stdin`, then runs `update-ref refs/dwarf-harness/colony <blob> <zero ID>`. If a race loses, Core reads again.
   - Present with this colony's ID: Core continues; an earlier registration was interrupted.
4. Core mints the workspace ID (UUIDv7, D37) and `<wdir>` (P16), publishes the document and the present files as bodies, and mints a pin ID.
5. Core appends one commit, with actor `owner`: `workspace.registered`, `workspace.capture_inputs_pinned` (revision 1) and `ledger.body_pin` (Appendix B).
6. The projection changes only after the commit is acknowledged.

**`UpdateInputs(ctx, workspaceID, expectedRevision, p Proposal) (Workspace, error)`** (S3; owner only: D112 for the exclusions, P13 for the rest).
- A fresh inspection must match `p`'s observed part, else `ErrStaleProposal`.
- The current revision must equal `expectedRevision`, else `ErrRevision`.
- The commit, with actor `owner`: `workspace.capture_inputs_pinned` (revision n+1), `ledger.body_pin` (new pin) and `ledger.body_unpin` (revision n's pin).
- The update applies to captures that begin after its acknowledgement. A capture already running keeps the inputs it started with, and a sealed capture never changes (D112, DEC:1532: "never an admitted submission"; CORE:854).

### 2.7 Scratches

**`Scratch(ctx, contextID, workspaceID) (Scratch, error)`** (S3) returns the pair's open scratch and creates it on first use (CORE:212; RC:285, :296). Concurrent first uses of one pair create one scratch: later callers wait, bounded by `ctx`, and get the same scratch. Other pairs proceed concurrently.

**Creation:**
1. The workspace must be usable: the marker names this colony and the common directory exists. Otherwise `*UnavailableError{workspace_unverified}`. Git must be present.
2. `worktree list --porcelain -z`. If `main` is checked out anywhere: `ErrCanonicalCheckedOut` (P17).
3. base = `rev-parse --verify --end-of-options refs/heads/main^{commit}`; anchor = `rev-parse --verify <base>^{tree}`.
4. Core mints the scratch ID (UUIDv7); `<dir>` is its last 8 hex digits (P16). If `scratch/<dir>` exists, an earlier scratch used `<dir>`, or `refs/heads/dwarf-harness/<dir>` exists, Core mints again, at most three times (my choice), then fails.
5. `update-ref refs/dwarf-harness/anchors/<scratch ID> <base> <zero ID>` (P19).
6. `worktree add --no-checkout -b dwarf-harness/<dir> <colony>/scratch/<dir> <base>` (repository environment). G2-R8 showed this leaves only the `.git` file and no index.
7. Materialization. Core reads `<scratch>/.git` (`gitdir: <admin dir>`). Then, in the capture environment with `GIT_INDEX_FILE=<admin dir>/index`, it runs `read-tree -u --reset <anchor>`. G2-R8 showed this writes the files under the pinned `autocrlf` (CRLF on disk) and the scratch's index, leaves `git status` clean and keeps the branch checked out. No filter driver or hook can run, because the private configuration defines none.
8. Core appends `workspace.scratch_created` (actor `core`, envelope `context_id` = the context).

On a failure after step 5, Core removes what it made (worktree, branch, anchor ref), as far as it can, and returns the error. After a crash, Open removes the orphan (§2.12). An orphan was never handed to a context, so it holds no edit.

**Result.** `Scratch{ID, WorkspaceID, ContextID, Dir, Branch, BaseCommit, AnchorTree}`, where `Dir` is absolute.

**Binding.** A scratch belongs to exactly one (context, workspace) pair (RC:285, :296; T05:28). Appendix B's record rules forbid a second open scratch for a pair and any reuse of a directory or branch name (RC:285: do not "reuse a prior context's files").

**`BeginWrite(ctx, scratchID) (release func(), error)`** (S3) marks a host-managed write: C3's file tools, and ticket 07's merge-back. Any number of writes may hold a scratch at once. While a capture, a closure or a promotion request holds it, BeginWrite waits, bounded by `ctx`. D70 forbids waiting only on the capture side (DEC:503). A closed scratch returns `ErrClosed`.

### 2.8 Capture

**What it is.** From a scratch and a trusted baseline tree, a capture produces a sealed Git tree of the scratch's eligible contents and a raw manifest, or it refuses.
- It has two modes: **observe**, which closure uses (§2.11), and **seal**, which retains its result. Tests use seal now, and ticket 06's admission will use it later (P2).
- A capture needs a held reservation (§2.9). The engine takes the reservation as a parameter, so no code path can capture without one (CORE:856: reserve "before taking an additional snapshot").

**Preconditions.** Each failure is unavailable with its reason: a profile is present; Git is present and its version equals the pinned one; the workspace is usable; the scratch directory exists.

**Steps.** In this order; the first refusal ends the capture.
1. **Inputs.** Verify or rematerialize the current revision (§2.5). A fresh index path, `workspaces/<wdir>/tmp/<capture ID>.idx`.
2. **Baseline.** `read-tree <baseline>` (capture environment). The root baseline is the scratch's anchor tree (CORE:854); ticket 06 will pass a local parent's sealed tree.
3. **Tracked.** `ls-files -z -s` gives mode, ID and path. A gitlink (160000) or symlink (120000) entry: `unsupported_kind`.
4. **Eligible untracked.** `ls-files -z -o --exclude-standard`. An entry ending in `/` is a nested repository (G1-R4): `unsupported_kind`.
5. **Ignored.** `ls-files -z -o -i --exclude-standard --directory`. An entry ending in `/` is a wholly ignored directory.
6. **Walk (Core).** `filepath.WalkDir` from the scratch root, which never follows links. It skips the root's `.git` and the ignored directories of step 5, and classifies each entry by its `Lstat` type:
   - directory: descend;
   - regular file: record its size and modification time;
   - symlink: `unsupported_kind`;
   - anything else, including Windows junctions and mount points (`ModeIrregular`, G2-R9), pipes, sockets and devices: `special_file`.

   All of this happens before Git reads any file, because Git reads through junctions (G1-R5).
7. **Reconcile (Core).**
   - A tracked path is present when the walk found a regular file with exactly its bytes. If the walk did not, it is deleted, unless the pinned `core.ignorecase` is `true` and a walk entry differs from it only in case. That is `name_mismatch`: a case-only rename on a case-insensitive file system (CORE:249).
   - Every eligible untracked path must be a walked regular file with exactly its bytes; otherwise `name_mismatch`.
   - Every walked regular file must be present tracked, eligible untracked, or ignored (step 5); otherwise `unobservable_path`. Git cannot see it, for example a path over Git's length limit (G1-R5).
   - Every candidate path must be valid UTF-8; otherwise `invalid_path`.
8. **Caps.** If present tracked plus eligible untracked files exceed `MaxFiles`: `file_cap`. If the walk's sizes sum to more than `MaxBytes`: `byte_cap`. No file has been read yet.
9. **Attributes.** `check-attr -z --stdin filter working-tree-encoding ident` over the candidate paths:
   - `filter` with a value other than `unspecified` or `unset`: `unsupported_filter`;
   - `working-tree-encoding` or `ident` with such a value: `unsupported_conversion`

   (RC:372; D74 DEC:535; P9).
10. **Raw read (Core).** Core reads each candidate file in full, in path order, computing its SHA-256 and byte count.
    - When the running total passes `MaxBytes`: `byte_cap`.
    - An open or read error, such as a Windows sharing violation: `unreadable`.
    - An `Lstat` before and after the read that differs in size or modification time: `scratch_changed`.
11. **Git hashing.** `update-index -z --force-remove --stdin` with the deleted tracked paths, then `update-index -z --add --stdin` with the present tracked and eligible untracked paths. Git writes the blobs with fsync and applies the pinned conversion. Then `write-tree` gives tree T.
12. **Verify (Core).**
    - `ls-files -z -s`: the path set must equal the candidate set exactly (`scratch_changed` otherwise), and every mode must be 100644 or 100755 (`unsupported_kind`).
    - Case collisions: over all paths and their directory prefixes, two different strings with equal `strings.ToUpper`: `case_collision` (P10).
    - Round trip: `cat-file --batch` over the distinct blob IDs. For each path, the raw SHA-256 must equal SHA-256(blob) or SHA-256(crlf(blob)), where crlf turns every LF not preceded by CR into CR LF. Otherwise: `scratch_changed` if the file's `Lstat` now differs from step 10, else `lossy_normalization` (P8).
    - Every file read must still `Lstat` as in step 10; otherwise `scratch_changed`.
13. **Manifest** (P24). Over `ledgerstore.MaxBodyBytes`: `manifest_cap`.
14. **Seal only.** `update-ref refs/dwarf-harness/captures/<capture ID> <T> <zero ID>` (repository environment, fsync; P19).
15. **Clean up.** Core removes the index file in every case, refusal included. On a refusal nothing is retained: no ref and no result. Blobs already written are unreferenced, and Git's own gc removes them (G1-R7).

**Result:** the capture ID (UUIDv7), tree T, the baseline, the capture-input digest and revision, the manifest's bytes and SHA-256, the file count, the raw bytes read, and the retention ref (seal only).

**Refusal:** `*RefusalError{Reason, Path, Detail}`, matching `ErrCaptureRefused`. Reasons: `special_file`, `unsupported_kind`, `unsupported_filter`, `unsupported_conversion`, `invalid_path`, `name_mismatch`, `case_collision`, `unobservable_path`, `unreadable`, `lossy_normalization`, `scratch_changed`, `file_cap`, `byte_cap`, `manifest_cap`. The step order above is the refusal order. The tests pin it, but it is not a compatibility promise.

**Eligibility** (D60 DEC:421; D75 DEC:541; D76 DEC:549; CORE:854; RC:328):
- Tracked means present in the baseline. Tracked edits and deletions are always included: Core passes tracked paths to Git explicitly, so ignore rules never apply to them.
- A new file is included unless the captured scratch's `.gitignore` files, edits in that submission included, or the pinned local and global excludes exclude it, under Git's precedence (P14).
- The scratch's own index, HEAD and stat-only change hints are never consulted (CORE:854; RC:285).

**Raw observation identity.** The manifest's per-file raw SHA-256 and size are kept distinct from the Git blob ID (D74 DEC:534; SPEC:397).

### 2.9 Reservations, busy and unavailable

- **Scratch exclusion.** Per physical scratch, in memory. It is held either exclusively, by a capture, a closure or a promotion request, or shared, by any number of BeginWrite holders. Exclusive acquisition never waits: if the scratch is held in either mode, the result is busy with reason `scratch_busy` (D70 DEC:503; CORE:856 "One active capture is allowed per physical scratch").
- **Capture-bytes pool.** Per colony, in memory. Each exclusive holder that may capture reserves `MaxBytes`. If `BytesInFlight` minus what is reserved is less than `MaxBytes`, the result is busy with reason `capture_budget` (CORE:856 "within pre-reserved limits"; RC:334 "Reserve ... byte ... before capture").
- `reserve(scratch)` takes both under one mutex, or neither. Every path releases what it took (CORE:856 "roll back reservations"). Closure takes the pool part only when it observes (§2.11).
- **`RequestPromotion(ctx, contextID, workspaceID) error`** (S3):
  1. The service is usable, not closed or poisoned. Both IDs are UUIDv7, else `ErrInvalid`. The workspace is known, else `ErrUnknownWorkspace`. The pair has an open scratch, else `ErrNoScratch`.
  2. No profile: `*UnavailableError{no_capacity_profile}`.
  3. `reserve`: busy `scratch_busy` or `capture_budget`. The answer comes at once, with no snapshot, wait, retry or interrupted writer (D70; T05:30).
  4. In order: Git present and at the pinned version; workspace usable; scratch directory present; a validator present. The first that fails gives `*UnavailableError{git_unavailable | inputs_stale | workspace_unverified | scratch_missing | no_validator}`. In C2 the last check always fails, because no validator exists (D52 DEC:342; D53 DEC:356; RC:290, :320).
  5. Release, and return the `*UnavailableError`.

  The request never captures, records, waits, queues, retries or changes a ref (RC:290, :359). P3 explains why busy comes before unavailable.
- Reservations exist only in memory. After a crash there is none to recover: Open empties `tmp/`, and no retention ref exists without a completed seal. This is ticket 05's part of D70's open "admission-reservation recovery" (DEC:504).

### 2.10 Immutability and retention

- A sealed tree is a Git tree object whose ID is its content (CORE:852 "sealed tree"). It cannot be changed by any later event: scratch edits; index edits in the scratch (`git add`, `update-index --assume-unchanged` or `--skip-worktree`); `.gitignore` or `.gitattributes` edits; edits of the live configuration or of exclude files. A later capture yields a different tree; it never changes this one (D56 DEC:380; T05:31; SPEC:43).
- Its retention ref keeps the tree and its blobs through `git gc --prune=now`. The private index does not keep them (G1-R7). Releasing the ref belongs to the capture's owner: ticket 06's admission, with the terminal-state rules of tickets 06 and 08. Ticket 05's tests release their own.
- Anchor refs keep each open scratch's base commit; closure deletes them (§2.11).
- Every ref Core creates lives under `refs/dwarf-harness/` (P19). A same-user deletion of these refs is outside the supported workflow until C10 (RC:348, :410; CORE:251).

### 2.11 Closure and cleanup

**`CloseScratch(ctx, Closure{ScratchID, Actor, ContextID, Reason}) error`** (S3):
- **Authority.** Actor `owner`, or `agent` with `ContextID` equal to the scratch's context; otherwise `ErrNotBound` (P28).
- **Reason.** `abandoned`, the only reason ticket 05 writes (P25). Any other value: `ErrInvalid`.
- **Already closed.** Core only retries the removal: nil once the scratch is gone, `ErrRemovalPending` while it remains.

**Steps:**
1. Take the scratch exclusively: busy `scratch_busy` if a write, capture or request holds it.
2. If the scratch directory exists:
   - check §2.8's preconditions, which are unavailable as there;
   - reserve `MaxBytes` from the pool (busy `capture_budget`);
   - observe a capture against the anchor tree (§2.8). A refusal is returned as is: Core cannot prove that no edit would be lost. A tree other than the anchor tree returns `ErrUnrepresentedEdits`, and nothing changes (RC:304: "cannot remove unrepresented edits"; T05:28).

   If the directory is absent, nothing is left to discard, and closure continues.
3. Append `workspace.scratch_closed` (actor as given; envelope `context_id` = the scratch's context).
4. **Removal.** `worktree remove --force <dir>`; if the directory still exists, `os.RemoveAll`; then `worktree prune`. G1-R6 found that Git, with a file held open, can drop the registration and leave a directory it can no longer remove. Once the directory is gone:
   - delete the branch only if it still points at the base commit (`update-ref -d <branch> <base>`); a moved branch keeps its history (P23);
   - delete the anchor ref.

   Any failure returns `ErrRemovalPending`. The closure stands; Open and later calls retry, and success is never assumed (CORE:248).
5. Release what step 1 and step 2 took.

Ignored files are not candidate content (D60) and are deleted with the scratch (P23).

In ticket 05 a scratch's only represented tree is its anchor. Tickets 06–08 add sealed submissions, Core's end-of-turn commits and accepted trees (CORE:858 "latest_represented").

### 2.12 Service lifecycle

**`Open(ctx, store, colonyDir, cfg Config) (*Service, Reconciliation, error)`** (S3):
1. `Join(colonyDir, "log")` must be the store's log directory (`os.SameFile`); otherwise `ErrInvalid`. The profile is validated (§2.14).
2. Create `workspaces/`, `workspaces/nohooks/`, `workspaces/empty` and `scratch/` if absent; empty each `workspaces/*/tmp/`.
3. Resolve Git and its version (§2.4).
4. **Replay.** `ledger.OpenReader(store.LogDir(), ReadOptions{Colony: store.Colony(), Through: store.Durable(), Consume: …})`, consuming the four F2-05 types and `ledger.body_pin` and `ledger.body_unpin`, each at version 1.
   - Each record is applied and checked against every record rule of Appendix B. A break returns `ErrInconsistent`, naming its sequence, as ledgerstore's rebuild does (B21 item 10).
   - A newer type version returns the reader's `*ledger.UnsupportedVersionError`.
   - Replay reads no clock and executes nothing (RC:15).
5. Read each workspace's current inputs with `ReadBody`. If they are unavailable or missing, which cannot happen while they are pinned, the workspace becomes unusable: `inputs_unavailable`.
6. Check each workspace: its common directory exists and its marker names this colony. Otherwise it is unusable: `workspace_unverified`.
7. **Reconcile.** Best effort; it never fails Open, and the result is reported:
   - a directory in `scratch/` that belongs to no recorded scratch is an orphan. It is removed as in §2.11 step 4, with its branch `refs/heads/dwarf-harness/<dir>` and its anchor ref if found;
   - a closed scratch whose directory remains: the removal is retried;
   - in each usable workspace, `for-each-ref refs/dwarf-harness/anchors/` finds refs whose scratch is not open; they are deleted;
   - an open scratch without its anchor ref gets it back from its record, if the object exists; otherwise it is marked `anchor_missing`, which makes it unavailable;
   - an open scratch without its directory is marked missing: requests on it are unavailable (`scratch_missing`), and it may be closed.

   `Reconciliation{OrphansRemoved, RemovalsCompleted int; Pending []string; Missing []uuid.UUID}`.

**`Close()`** waits for operations in progress. Every later call returns `ErrClosed`, and a second Close returns nil.

**Poisoning.** If `Append` returns `appender.ErrUncertain` or `appender.ErrPoisoned`, the service is poisoned. Every call except Close then returns `ErrPoisoned`, until the host has recovered the store and a new Open rebuilds from the ledger (B18 item 6's pattern).

**Memory.** The projections hold the workspaces, the open scratches, and every directory and branch name ever used. That grows with history; no constant-memory claim is made (B3).

### 2.13 Errors

Each error wraps exactly one sentinel. `errors.Is` matches the sentinel and `errors.As` the typed error, as in `ledger/errors.go`. `Error()` text is not API.

| Sentinel | Typed error | Meaning |
|---|---|---|
| `ErrBusy` | `*BusyError{Reason}` | `scratch_busy`, `capture_budget`: try again later |
| `ErrUnavailable` | `*UnavailableError{Reason}` | `no_capacity_profile`, `git_unavailable`, `inputs_stale`, `inputs_unavailable`, `workspace_unverified`, `scratch_missing`, `anchor_missing`, `no_validator` |
| `ErrCaptureRefused` | `*RefusalError{Reason, Path, Detail}` | the reasons of §2.8 |
| `ErrUnrepresentedEdits` | — | closure found eligible content other than the represented tree |
| `ErrRemovalPending` | — | closure recorded; the directory or branch remains for a retry |
| `ErrNotGitRepository`, `ErrNoCanonical`, `ErrCanonicalCheckedOut`, `ErrOtherColony`, `ErrExists`, `ErrStaleProposal`, `ErrRevision`, `ErrInputsTooLarge`, `ErrGitUnavailable` | — | registration, update and creation refusals (§2.6–2.7) |
| `ErrUnknownWorkspace`, `ErrNoScratch`, `ErrNotBound`, `ErrInvalid` | — | caller errors |
| `ErrClosed`, `ErrPoisoned`, `ErrInconsistent` | — | lifecycle (§2.12) |
| `ErrGit` | `*GitError{Args, Exit, Stderr}` | an unexpected Git failure |

### 2.14 Capture profile (caps)

```go
type CaptureProfile struct {
	MaxFiles      int   // files in one sealed tree
	MaxBytes      int64 // raw bytes Core reads in one capture; also each capture's reservation
	BytesInFlight int64 // colony-wide total of capture reservations
}

// ProvisionalCaptureProfile returns {100_000, 1 << 30, 20 << 30}: provisional
// Core policy, not measured capacity (P21).
func ProvisionalCaptureProfile() CaptureProfile

type Config struct {
	Capture *CaptureProfile // nil: captures, closures and requests are unavailable (no_capacity_profile)
}
```

Open validates a non-nil profile: `MaxFiles >= 1`, `MaxBytes >= 1` and `BytesInFlight >= MaxBytes`, else `ErrInvalid`. A nil profile is the "missing profile" of CORE:862 and makes captures unavailable. The values are provisional calibration inputs, not a capacity, a colony cap or a service level (RC:338; B15 DEC:763–764).

### 2.15 Windows

- **Defender** stays on, with no exclusion for `scratch/` or `workspaces/`. Costs are measured as they are (RC:378; CORE:225; B3 DEC:657).
- **Line endings.** The pinned `autocrlf` is `true` on the owner's machine (G1-R1). A CRLF file is captured as an LF blob, an LF file unchanged, and mixed endings are refused (P8; G1-R2, G1-R3).
- **Long paths.** Directory names are short (D38). A path Git cannot see is refused as `unobservable_path`; Git skips it silently (G1-R5). A checkout over Git's limit fails scratch creation with `ErrGit`.
- **Case.** A case-only rename is refused as `name_mismatch`, and two paths differing only in case as `case_collision` (CORE:249).
- **Junctions and mount points** are refused as `special_file` before Git reads, and symlinks as `unsupported_kind`. On this machine Go reports a junction as `ModeIrregular` and a symlink as `ModeSymlink`, and a symlink could be created without extra privilege (G2-R9).
- **Locked files.** Removal stays pending and is retried (G1-R6; CORE:248). A file that another process holds without read sharing is refused as `unreadable`. Go opens files without `FILE_SHARE_DELETE` (B21 item 4's reasons), so while Core reads a file, an agent's rename of it fails.
- **Executable bit.** With `core.filemode=false`, tracked files keep their baseline mode and new files get 100644.
- **Process cost.** A capture runs about ten Git processes, however many files it holds.

### 2.16 Performance (D78)

- **Assumption, stated, not observed.** B15's 12 or 20 code-working pairs, each offering one change per 600 s, with a synchronized four-checkpoint burst (RC:338). There is one capture per scratch at a time; captures in different scratches run concurrently within `BytesInFlight`. 20 × 1 GiB means that the pool alone refuses no capture of a 20-pair synchronized burst.
- **Model, not a benchmark** (CORE:224). Capture cost is a stat-only walk (A.7: 0.6 s for 10,000 files), plus reading every candidate file (about 23 ms for a fresh file's first read and 0.2 ms for a repeat, A.7), plus Git's hashing and blob writes for changed content.
  - A fresh 10,000-file scratch's first capture is close to A.7's 305 s.
  - A warm scratch with few changes takes seconds.
  - Scratch creation took about 1.0 s for 1,000 files in G2-R8, on a loaded machine; indicative only.
- **Measurement.** S1's harness (P29) records creation, fresh and warm capture, and a closure observation at 1,000 and 10,000 files with Defender on, as Core Appendix A.11, with no threshold. The concurrent cost of a whole burst stays C4's blocking feasibility gate (RC:285, :411).
- **Records.** Ticket 05 writes few records: per workspace and per scratch lifetime. Their ledger cost is negligible against B21's model of 960 records per context-hour (DEC:1459).

### 2.17 Documents (S4)

- **`docs/ROADMAP-CORE.md`.** RC:3 gains a first status entry, "«date» (C2 In progress: ticket 05)". RC:417 becomes "**Status.** In progress (ticket 05): D52 boundary approved 2026-10-12 (D112); proof not claimed. The C1 contracts it consumes are frozen (D111). F2 is frozen «in parts, before each part's producer | once» (OG-B «answer»); F2-05, ticket 05's part, is «proposed | frozen (D«n»)».", with the «» parts filled in at commit time. This lands with S1, in one commit with RM (RM:198).
- **`docs/ROADMAPS.md`.** RM:3 gains the same status entry; RM:170's C2 status becomes *In progress*.
- **`docs/DECISIONS.md`.** B«next», "C2: workspaces, scratches and exact capture (ticket 05)", after S3. It records:
  - the P-rulings;
  - the adoption of RC:287's [PROPOSAL] (`git` program) and of part of RC:289's (scratch created and closed), with the evidence for RC:286's [INFERENCE] items (G1-R6; CORE:249);
  - Appendix D's Git facts;
  - the A.11 measurements.

  Its originator follows AGENTS "Decision records" from the OG-A answer, `adopted` or `modified`, with the owner's OG-A and OG-B words quoted verbatim on their own lines, as B21 did for OG3.
- **`docs/DESIGN-CORE-AND-LAUNCHERS.md`.** A new Appendix A.11, "Workspace scratch and capture (C2, ticket 05)", with setup, model and one table per scenario group; the date list of the Appendix A heading (CORE:1025).
- **`docs/CONTRACTS.md`** belongs to S2: the F2-05 table, marked proposed. The frozen status belongs to the freeze's own commit (§8).

---

## 3. Records and F2

**3.1 What ticket 05 writes.** The four F2-05 types of Appendix B, and F0 pins:

| Operation | One commit holding | Actor |
|---|---|---|
| Register | `workspace.registered`, `workspace.capture_inputs_pinned` (revision 1), `ledger.body_pin` | owner |
| UpdateInputs | `workspace.capture_inputs_pinned` (revision n+1), `ledger.body_pin`, `ledger.body_unpin` | owner |
| Scratch, first use | `workspace.scratch_created` | core |
| CloseScratch | `workspace.scratch_closed` | owner or agent |

Captures, refused closures, BeginWrite, busy and unavailable write nothing (P4).

**3.2 What it consumes.** The frozen F0 contracts (D111):
- `Append` for the commits;
- `ledger.body_pin` and `ledger.body_unpin` (F0 types any `internal/core` caller may append, CON:54–55);
- `OpenReader` for replay.

It also uses Core's `PublishBody` and `ReadBody`, which are not a contract (B21 items 4–5).

**3.3 F2 parts.**
- **What F2 is.** The catalogue stage that adds C2's records (RC:220; CORE:844; CON:38). Each part names its types and versions, payload owner, producer, permitted appender callers, consumers, privacy class, replay-essential fields and golden sample (CON:34; B2 DEC:648).
- **Ticket 05's part, F2-05.** The workspace, capture-inputs and scratch-lifecycle records: UC:612's "Scratch created", and RC:289's [PROPOSAL] "Scratch closed".
- **Later parts.**
  - Ticket 06: requests, submissions, admission, generations and attempts.
  - Ticket 07: temporary scratch, changed paths and merge-back (UC:613–614).
  - Ticket 08: finalization, acceptance, refusal, no-change, cancellation and recovery (UC:615–617).
  - Ticket 09: activation.
  - Later: scratch base advanced (RC:289).
- Whether F2 is frozen in parts or once is OG-B.

**3.4 What may start before the F2-05 freeze** (OG-B, option 1):
- S1 writes no ledger record. It may start after OG-A and reach `main` after review.
- S2 is drafted after OG-A for the freeze request, and reaches `main` only with the freeze (D41).
- S3, the producer, starts only after the freeze (RC:407; T05:49; D112 DEC:1533).

**3.5 Producer rules.**
- The only appender caller for `workspace.*` types is `internal/core/workspace`. This is enforced by review, because `tools/check` cannot express it; the store accepts any catalogued type through `Append`. B18 item 5 is the precedent.
- The service checks every Appendix B rule when it appends and again at Open (§2.12).

---

## 4. Tests

**General.**
- Tests come before code (RC:15).
- Real Git runs in disposable repositories under `t.TempDir()`, outside the module. A missing or too-old Git fails the tests with a clear message (P32); there is no Git mock.
- `helpers_test.go` builds repositories with fixed author and committer identity and dates (`GIT_AUTHOR_DATE`, `GIT_COMMITTER_DATE`), so that commit IDs are deterministic. It isolates every Git call from the developer's configuration through the controlled environments and the `environ` seam, which sets `HOME`, `XDG_CONFIG_HOME` and `GIT_CONFIG_GLOBAL` to temporary paths.
- Expected trees are computed independently, by plain Git in a reference repository or by `crypto/sha1` over `blob <n>\0<content>`, never from engine output.
- Tests use exported API where it exists; the S1 engine is tested inside the package, the house convention.
- Each test below names the plausible bug it catches.

### S1 — `internal/core/workspace`, no records

**git_test.go**
- **`TestControlledEnvironmentIgnoresHostGit`.** Through `environ`, the host carries `GIT_DIR=<bogus>`, `GIT_CONFIG_PARAMETERS` with `core.autocrlf=input`, and a global config whose `core.excludesFile` ignores `x.txt`. A capture under pinned inputs that do not exclude `x.txt` includes it, and stores a CRLF file as autocrlf=true dictates. *Bug: inheriting `GIT_*` or reading global config.*
- **`TestGitVersionGate`.** `2.55.0.windows.3` and `2.42.0` pass; `2.41.9`, an empty string and `git version x` fail; a missing binary gives `ErrGitUnavailable` at Inspect and `git_unavailable` at capture. *Bug: accepting old or garbled versions.*
- **`TestUnexpectedGitExitIsTyped`.** `read-tree` of a nonexistent tree returns `*GitError` with its exit code and stderr, and no result. *Bug: treating failure as an empty result.*

**gitparse_test.go and fuzz targets** (fuzz_test.go): `FuzzParseNULList`, `FuzzParseStageEntries` (`ls-files -s -z`), `FuzzParseCheckAttr`, `FuzzParseWorktreeList`, `FuzzParseCatFileHeader`, `FuzzParseGitVersion`.
- Properties: no panic; a well-formed generated input parses back to the values it was generated from; malformed input returns an error and never a partial list.
- Seeds: G1's recorded outputs, plus table cases for an empty list, a missing final NUL, a path holding TAB or LF, and a 64-hex ID in a `sha256` repository.
- *Bug: off-by-one at NUL boundaries; silently truncated lists.*

**inputs_test.go**
- **`TestInspectImportsHostInputs`.** A repository with `info/exclude`, `info/attributes`, a global ignore and a global attributes file (test `HOME`), and a repository-local `core.autocrlf=true`. The Proposal holds exactly those bytes and values; absent files are `Present=false`. *Bug: dropping a private exclusion (D75); reading the wrong default path.*
- **`TestInspectRefuses`.** A plain directory gives `ErrNotGitRepository`; a repository without `main`, `ErrNoCanonical`; a non-bare repository with `main` checked out, `ErrCanonicalCheckedOut`, as does a linked worktree on `main`; a 1 MiB + 1 file, `ErrInputsTooLarge`. A bare repository passes.
- **`TestInputsDigestCoversEveryInput`.** A table that changes one input at a time (each setting, each file, absent versus empty, the rules version): each change gives a different document and digest, and equal inputs give equal bytes. *Bug: a field left out of the digest.*
- **`TestTamperedMaterializationIsRewritten`.** After a capture, `git/info/exclude` and `git/config` in `inputs/1/` are overwritten; the next capture still follows the pinned bytes, and the files are restored. *Bug: trusting materialized copies.*
- **`FuzzDecodeCaptureInputs`.** No panic; decode followed by encode reproduces the input exactly when decoding succeeds.

**capture_test.go** (portable)
- **`TestCaptureEligibility`.** A table, each row against a reference tree made by plain `git add -A` with equivalent excludes. Rows:
  - tracked edit; tracked deletion; new file;
  - new file ignored by a `.gitignore` edit made in the same scratch (D76);
  - new file excluded by a pinned local exclude, and by a pinned global exclude;
  - a file excluded only by a live exclude added after pinning, which is captured (D75);
  - a tracked file matching an ignore rule, which stays (D60);
  - a `.gitignore` negation of a pinned exclude (P14);
  - a tracked file replaced by a directory of new files.

  *Bug: live excludes; dropping tracked-but-ignored files; ignoring same-submission rules.*
- **`TestCaptureCanonicalContent`.** Pinned `autocrlf=true`. A CRLF file becomes the LF blob, and its manifest raw SHA-256 is that of the CRLF bytes. A `-text` file keeps CRLF. A binary file with CR bytes is unchanged. *Bug: raw bytes as candidate identity (D74).*
- **`TestCaptureIgnoresScratchIndexAndHead`.** In the scratch, the agent stages other content (`git add`), marks files `--assume-unchanged` and `--skip-worktree`, and commits to the scratch branch. The capture follows the working files against the anchor. *Bug: trusting the index or HEAD (CORE:854).*
- **`TestCaptureReadsEveryFile`.** A tracked file's content changes while its size and modification time are restored with `os.Chtimes`. The capture sees the new content. *Bug: stat-only detection (RC:285).*
- **`TestCaptureRefusals`.** Portable rows:
  - nested repository: `unsupported_kind`;
  - baseline gitlink and baseline symlink entries made with `update-index --cacheinfo`: `unsupported_kind`;
  - `filter=lfs`: `unsupported_filter`;
  - `working-tree-encoding=UTF-16LE` and `ident`: `unsupported_conversion`;
  - baseline with `A.txt` and `a.txt`, and with `Dir/x` and `dir/y`: `case_collision`;
  - mixed CRLF and LF, and `\r\r\n`, under `autocrlf=true`: `lossy_normalization`.

  Each row also checks that no capture ref exists, that the scratch is byte-identical before and after, and that `tmp/` is empty. *Bug: silent skip or silent inclusion.*
- **`TestCaptureCaps`.**
  - Exactly `MaxFiles` files pass, and one more gives `file_cap` with zero file reads (a counter in the `afterRawRead` seam).
  - Exactly `MaxBytes` bytes pass, and one byte more gives `byte_cap`.
  - A file grown between walk and read gives `byte_cap` or `scratch_changed`.
  - A lowered manifest cap gives `manifest_cap`.

  *Bug: off-by-one; reading before counting.*
- **`TestCaptureDetectsChangeDuringCapture`.** The `afterRawRead` seam rewrites a file with a different size before Git hashes: `scratch_changed`, and nothing is sealed. *Bug: a manifest that disagrees with its tree.*
- **`TestSealIsImmutable`** (AC4). After a seal:
  - edit, delete and add scratch files;
  - `git add` and `git rm --cached` in the scratch;
  - flip `core.autocrlf` in the repository config;
  - edit the live `info/exclude` and a global exclude file;
  - edit `.gitignore` and `.gitattributes`;
  - run `git gc --prune=now` in the repository and in the scratch.

  The sealed tree's recursive listing and every blob's bytes are unchanged, and the retention ref holds the same ID. *Bug: a capture referencing mutable state; missing retention (G1-R7).*
- **`TestObserveRetainsNothing`.** An observe creates no ref; a seal creates exactly one, named by the capture ID.
- **`TestCaptureDeterministic`.** Two captures of an unchanged scratch give the same tree and identical manifest bytes. *Bug: map-ordered manifests.*

**capture_windows_test.go**
- **`TestCaptureRefusesJunction`.** `cmd /c mklink /J sub <dir outside the scratch>`. Whether the junction is an untracked entry or replaces a tracked directory, the result is `special_file`, and no file under the target is read; the `afterRawRead` counter shows no outside path. *Bug: capturing outside the scratch (G1-R5).*
- **`TestCaptureRefusesSymlink`.** `os.Symlink`: `unsupported_kind`. If creation fails for lack of privilege, the test skips naming that privilege; the owner's machine creates symlinks (G2-R9).
- **`TestCaptureCaseOnlyRename`.** `os.Rename("a.txt", "A.txt")` under pinned `ignorecase=true`: `name_mismatch`.
- **`TestCaptureLongPath`.** An untracked file whose path exceeds 300 characters: `unobservable_path`. *Bug: Git's silent skip (G1-R5).*
- **`TestCaptureUnreadable`.** A file held with share mode 0 through `syscall.CreateFile`: `unreadable`.
- **`TestCaptureWindowsModes`.** A baseline 100755 file keeps 100755, and a new file is 100644.

**capture_posix_test.go** (`linux || darwin`): a FIFO (`syscall.Mkfifo`) and a socket give `special_file`; a symlink gives `unsupported_kind`; `chmod +x` on a new file gives 100755; `chmod 000` gives `unreadable` (skipped when running as root); on Linux, a case-only rename is captured as a deletion plus a new file.

**capture_linux_test.go:** a name with byte 0xff gives `invalid_path`.

**eol_test.go and `FuzzCRLFStreaming`.**
- The streaming hash of crlf(b) equals a reference that converts whole buffers, for any split of `b` into chunks. The fuzz input chooses the chunk sizes, including a CR at the end of one chunk and an LF at the start of the next.
- Table: `a\nb\n` → `a\r\nb\r\n`; `a\r\nb\n` → `a\r\nb\r\n`; empty input.

*Bug: lookbehind lost at chunk boundaries.*

**reserve_test.go**
- **`TestExclusiveIsImmediateBusy`.** Exclusive while exclusive, and exclusive while shared, return `scratch_busy` without waiting: a held lock and an already-ended `ctx` still give busy, not `ctx.Err()`. The writer's later writes land intact.
- **`TestWriterWaitsForCapture`.** BeginWrite during a capture returns only after the capture releases, or with `ctx.Err()`; it never interrupts the capture.
- **`TestPoolIsAtomic`.** With a pool sized for one capture, a second scratch's reservation gives `capture_budget` and leaves its exclusion free.
- **`TestReservationReleasedOnEveryPath`.** After a refusal, a Git error and a cancelled `ctx`, the next reservation succeeds.
- Run under `-race` with `-count=20` (V5).

**worktree_test.go**
- **`TestCreateNeverChecksOutMain`.** A scratch on `refs/heads/dwarf-harness/<dir>` at main's tip; `worktree list` shows no worktree on `main`; `git -C scratch status --porcelain` prints nothing (G2-R8); files are materialized under the pinned `autocrlf`. *Bug: checking out canonical (D48).*
- **`TestRemoveCompletesWhatGitLeaves`.** A nested repository inside an ignored directory survives `worktree remove`, and Core's fallback removes it. A seam failing `removeAll` gives pending, and a retry completes. *Bug: assuming removal succeeded.*
- **`TestRefsAreCreateOnly`.** A second create of the same marker, anchor or capture ref fails and changes nothing.

**worktree_windows_test.go:** **`TestRemovalBlockedByOpenHandle`**. A file held open (share mode 0) blocks removal, the result is pending, and the directory remains. After the handle closes, a retry removes the directory, deletes the branch and prunes the registration (G1-R6).

**workload_test.go** (P29): **`TestCaptureWorkload`** skips unless `DWARF_CAPTURE_WORKLOAD_OUT` names a results file, and under `-race`. It needs a directory outside the repository and writes one JSON line per run. Runs: creation, fresh observe, warm observe, and seal after 10 edits, at 1,000 and 10,000 files of about 800 bytes (A.7's shape). It applies no threshold and fails only on a broken invariant: an unexpected refusal or a wrong tree.

### S2 — `contract/ledger`

- **`TestGoldenF2_05`.** Builds `testdata/f2/05/log/00000000000000000001.jsonl` (Appendix B.6) with `EncodeCommit` and the F2-05 encoders, compares it byte for byte, and accepts `-update`.
- **`TestGoldenDecodes`** also covers that segment.
- **F0 is unchanged.** The F0 goldens regenerate byte-identically and keep D111's SHA-256 (V8).
- **`TestF2_05PayloadsRoundTrip`.** Each type with 40-digit and 64-digit IDs, revisions 1 and 2, and reason `abandoned`, plus an unknown reason token, which decodes.
- **`TestF2_05PayloadsRefuse`.** Every rule of Appendix B.2–B.5 broken once:
  - missing, null or repeated key; a non-UUIDv7 ID; a zero digest;
  - an ID with uppercase hex, 39, 41 or 63 digits, or a non-hex character;
  - `object_format` other than `sha1` or `sha256`;
  - revision 0, a negative revision or a fraction;
  - `dir` not 8 lowercase hex digits; `branch` not beginning `refs/heads/`; `common_dir` empty;
  - reason empty, uppercase, hyphenated or longer than 64 bytes.

  Each gives an error wrapping `ErrInvalid`.
- **`FuzzDecodeF2_05`.** Each decoder: no panic; on success, re-encoding decodes to an equal value.
- **`FuzzCheckTruncation`** is seeded at every commit boundary of the new golden and its neighbours (B21 item 12's pattern).

### S3 — the service (`internal/core/workspace`)

**register_test.go**
- **`TestRegisterRecordsPinnedInputs`.** The commit holds exactly [registered, capture_inputs_pinned with revision 1, body_pin], actor owner, with body_refs equal to the document and file bodies, and the bodies are readable. A `store.Collect` with a late cutoff leaves them, since they are pinned. The marker names the colony. A reopened service shows the same workspace. *Bug: unpinned inputs become collectable.*
- **`TestRegisterRefusals`.** Not a repository; no `main`; `main` checked out; another colony's marker; the same repository registered again through a linked worktree's path (`ErrExists`); a stale proposal whose normalization differs. Each refusal leaves `store.Durable()` unchanged.
- **`TestRegisterResumesAfterMarker`.** A marker already holding this colony's ID with no record: registration completes.
- **`TestUpdateInputsCompareAndSwap`.**
  - A stale expected revision gives `ErrRevision`.
  - Success writes [capture_inputs_pinned with revision 2, body_pin, body_unpin of revision 1's pin].
  - A file that only revision 2 excludes is excluded from later captures.
  - A seal made before the update keeps its tree.
  - Revision 1's own bodies become collectable.

  *Bug: old inputs used; pin leak (D112 "future captures only").*
- **`TestPinnedGitVersionGatesCapture`.** A pinned version different from the running one (seam): requests and closure give `inputs_stale`. After `UpdateInputs`, capture works again.

**scratch_test.go**
- **`TestScratchOnePerPair`.** Two calls for (c1, w) return one scratch; (c2, w) gets another directory and branch; 16 concurrent first uses for (c3, w) produce one record and one worktree. *Bug: a duplicate scratch (RC:285).*
- **`TestScratchNamesNeverReused`.** The `newID` seam forces a collision with a closed scratch's directory: Core mints again, and the record rule holds.
- **`TestCloseScratchRefusesUnrepresentedEdits`** (AC1).
  - An edit, a new eligible file or a deletion gives `ErrUnrepresentedEdits`, with no record and the files intact.
  - A special file gives its refusal.
  - Only ignored files: the scratch closes and is removed.
  - Edits reverted: it closes.
  - The agent committed but the tree equals the anchor: it closes and the branch is kept.
  - The branch at base: it closes and the branch is deleted.
  - The anchor ref is gone after a successful closure.
- **`TestCloseScratchAuthority`.** Another context's agent gives `ErrNotBound`; the owner may close; the agent of the scratch's own context may close.
- **`TestCloseScratchBusy`.** While BeginWrite holds the scratch: `scratch_busy` at once, with no record.

**scratch_windows_test.go: `TestCloseRemovalPending`.** A held handle gives `ErrRemovalPending`, with the closed record durable; BeginWrite then gives `ErrClosed`; after the handle closes, CloseScratch completes the removal, and so does Open.

**promote_test.go**
- **`TestRequestPromotionIsUnavailable`** (AC3). A free scratch gives `*UnavailableError{no_validator}`. Unchanged: `store.Durable()`, `refs/heads/main`, the object count (`count-objects -v`), the `refs/dwarf-harness/captures/` refs, and the scratch. *Bug: a snapshot or record behind a missing validator (D52, D53).*
- **`TestRequestPromotionBusyBeforeUnavailable`.** While BeginWrite holds the scratch: `scratch_busy`; the writer then writes and releases; the next request gives `no_validator`. With the pool exhausted by a concurrent seal in another scratch: `capture_budget`.
- **`TestRequestPromotionBinding`.** Unknown workspace, no scratch, closed scratch and invalid IDs give their errors; a nil profile gives `no_capacity_profile`.

**service_test.go and replay_test.go**
- **`TestOpenReconciles`.**
  - The `beforeAppend` seam kills creation after the worktree exists, through a re-executed child process, as ledgerstore's killed-writer tests do. Reopen: the orphan directory, its branch and its anchor ref are removed.
  - A closed scratch's leftover directory is removed.
  - An open scratch's missing anchor ref is recreated.
  - An open scratch whose directory was deleted is reported missing and gives `scratch_missing`.
- **`TestOpenFailsClosedOnRuleBreak`.** Logs built by appending valid F2-05 payloads that break a rule each:
  - a duplicate workspace ID; a second registration of one common directory;
  - a registration commit without its pin;
  - revision 3 after 1; an update without the unpin;
  - a second open scratch for a pair; a scratch in an unknown workspace; a reused `dir`;
  - a 64-digit ID in a `sha1` workspace;
  - a closure of an unknown or closed scratch; a closure by an agent of another context.

  Each gives `ErrInconsistent` naming the sequence. *Bug: replaying an impossible history.*
- **`TestUncertainAppendPoisons`.** The store wrapper returns `appender.ErrUncertain` once: later calls give `ErrPoisoned`, and a new Open rebuilds correctly.

### Deliberately left out

- **A Git mock.** The subject is Git's real effects (SPEC:587).
- **Assertions on Git's message text**, apart from what `*GitError` carries.
- **An import test in the package.** `tools/check` step 5 covers it.
- **A test that `Defined()` lists the F2-05 types.** That would be a source-text test; S3's tests append F2-05 records through a store created with `ledger.Defined()`, which exercises the behavior.
- **rapid.** It is not in `go.mod`, and its first use would be a dependency change (B17 item 1; DEC:213).

---

## 5. Verification commands

Run in PowerShell from the worktree root, with `$env:GOTOOLCHAIN='local'; $env:GOFLAGS=''` set first (AGENTS "Go commands"; B17).

| # | Command | Expected |
|---|---|---|
| V1 | `$env:CGO_ENABLED='0'; go test -count=1 ./internal/core/workspace` | `ok` |
| V2 | `$env:CGO_ENABLED='0'; go test -count=1 ./contract/ledger ./internal/core/ledgerstore` | `ok` |
| V3 | for each fuzz target T of the slice: `$env:CGO_ENABLED='0'; go test <pkg> -run '^$' -fuzz "^$T$" -fuzztime 120s` | `PASS`; `git status --porcelain -- <pkg>/testdata` prints nothing, unless a fixed crasher is kept as a seed |
| V4 | `go run ./tools/check`, with `DWARF_CC` set (AGENTS "Check") | all nine steps pass |
| V5 | `$env:CGO_ENABLED='1'; $env:CC=$env:DWARF_CC; go test -race -count=20 -run 'Busy|Waits|Pool|Released|OnePerPair|Poisons' ./internal/core/workspace` | `ok` |
| V6 | `go list -f '{{join .Imports "\n"}}' ./internal/core/workspace` and `go list -deps -f '{{if not .Standard}}{{.ImportPath}}{{end}}' ./contract/ledger` | no `golang.org/x/...` import in the first list; only `contract/ledger` in the second |
| V7 | `go mod tidy`, then `git diff --exit-code -- go.mod go.sum` | no change (D29) |
| V8 | `go test ./contract/ledger -run '^TestGolden' -update`, then `git status --porcelain -- contract/ledger/testdata`; `Get-FileHash -Algorithm SHA256` over the three F0 goldens | nothing changed; the F0 hashes equal D111's (DEC:1518) |
| V9 | `git ls-files --eol -- contract/ledger/testdata/f2` | `i/lf w/lf` |
| V10 | `git version`; `(Get-MpComputerStatus).RealTimeProtectionEnabled` | `2.42` or later, recorded; `True` |
| V11 | `$env:CGO_ENABLED='0'; $env:DWARF_CAPTURE_WORKLOAD_OUT='<dir outside the repo>\t05-capture.jsonl'; go test -count=1 -run '^TestCaptureWorkload$' ./internal/core/workspace` | a results file; there is no pass mark |
| V12 | `$env:CGO_ENABLED='0'; foreach ($o in 'linux','darwin') { $env:GOOS=$o; go vet ./internal/core/workspace ./contract/ledger }` | no finding |

**Per slice:**
- S1 runs V1, V3 (S1 targets), V5, V6, V7, V10, V11, V12 and V4.
- S2 runs V2, V3 (S2 targets), V6, V7, V8, V9 and V4.
- S3 runs V1, V5, V12 and V4.
- S4 runs V4.
- V4 runs again on the commit that reaches `main` (D46).

---

## 6. Slicing

| Slice | Content | May start | Reaches `main` |
|---|---|---|---|
| S1 | §1 S1: Git runner, inputs, capture engine, reservations, worktree mechanics, harness | after OG-A | after review, with S4's status edit (OG-B option 1) |
| S2 | the F2-05 draft in `contract/ledger` and its register table | after OG-A | only with the owner's F2-05 freeze (D41); the freeze request cites S2's commit |
| S3 | the service and its records | after the F2-05 freeze, with S1 and S2 on `main` | after review |
| S4 | statuses with S1; A.11 with S1's evidence; B«next» with S3 | with its slice | with its slice |

**Acceptance.**
- **S1:** every S1 test passes; V results as expected; the advisor reviews on evidence from a detached worktree of its commit, as for ticket 03.
- **S2:** as S1, with V8 showing F0 unchanged.
- **S3:** every S3 test passes; with S1, the acceptance trace of Appendix C is complete.

**Commits** follow Conventional Commits with the package as scope (AGENTS "Commits"): `feat(workspace): …`, `feat(ledger): …` and `docs: …`.

**Closing.** Ticket 05 closes when S3 and S4 are on `main`.

**Size.** If the reviewer prefers smaller steps, S1 splits cleanly:
- S1a: Git runner, parsers, inputs and worktree mechanics;
- S1b: capture engine and reservations, with the harness.

---

## 7. Design choices and owner gates

### 7.1 Design choices

**P1. Ticket 05's boundary against ticket 06** (open items 12 and 15).
- **Options.**
  - (a) Ticket 05 builds:
    - the capture engine, taking an explicit baseline (the root anchor now);
    - the scratch exclusion and capture-bytes pool;
    - retention of sealed captures;
    - the promotion entry with binding, busy and unavailable.

    Ticket 06 adds request IDs and D58 deduplication, the K-slot FIFO with Q=4N, local-head checks, successor baselines, admission records, integration, generations and lineage failure.
  - (b) Ticket 05 also builds the K-slot and deduplication.
- **Recommend (a).**
  - T06:28–31 names K=4 FIFO admission, same-ID replay without recapture, local-parent eligibility and lineage outcomes as ticket 06's acceptance.
  - T05:30 names reserve-before-capture, immediate busy and unavailable.
  - CORE:856's atomic reservation gains its K-slot in ticket 06, through the same `reserve`.
- Ticket 06 receives the engine and reservations unchanged.

**P2. How capture is exercised while C2 refuses every promotion request** (open item 12).
- **Options.**
  - (a) Mechanism tests drive the sealing engine in disposable repositories, and closure uses observe in the product.
  - (b) A test-only validator lets requests reach capture.
  - (c) A separate "capture only" product command.
- **Recommend (a).**
  - (b) is the "permissive validator, temporary bypass" that D52 and RC:290 forbid (DEC:342), and the stub that D41 forbids (DEC:213; RM:231).
  - (c) invents an operation that no source names, and would snapshot outside admission (CORE:856).
  - PKT:141 states the intended reading: "C2 still builds and tests capture … as mechanisms". RC:290 permits mechanical tests in disposable repositories.
  - Closure gives observe a real product use, so the engine's refusals and its exclusion are product-visible in C2.

**P3. Busy before unavailable.**
- **Options.**
  - (a) Binding errors, then a missing profile, then reservation (busy), then the remaining unavailable reasons.
  - (b) Every unavailable reason before any reservation.
- **Recommend (a).**
  - It follows the order the owner read in the approval packet: admission busy at step 3, unavailable at step 4 (PKT:138–139). It also follows CORE:856's listing, where scratch exclusion precedes validator resources.
  - Scenario 6's writer contention then answers busy through the C2 product (RC:359).
  - The profile check comes first only because it sizes the reservation.
  - The cost is a reservation taken and returned within the call.

**P4. Busy and unavailable requests are not recorded.**
- **Options.**
  - (a) Return the typed error and write nothing.
  - (b) Record a refused-request event.
- **Recommend (a).**
  - CORE:856 rolls back and returns "not-admitted without a new snapshot".
  - Recording would need the request schema, which belongs to C3 and ticket 06 (B21 item 9, DEC:1435; T06:29), and D58's identity for refusals.
  - UC:638 and UC:625 make busy neither runner load nor a field source.
  - RC:338's refused-work counts are a C4 measurement.
  - `RequestPromotion` therefore returns only `error` in ticket 05; ticket 06 changes its signature, an internal API.

**P5. Package and store dependency.**
- **Options.**
  - (a) One package, `internal/core/workspace`, using `*ledgerstore.Store` through a small unexported interface.
  - (b) Split the Git runner into its own package.
  - (c) Depend only on `appender.Appender`.
- **Recommend (a).**
  - D45 names "workspace" in `internal/core` (DEC:263).
  - Tickets 06–09 extend the same service.
  - (c) cannot publish or read the bodies that the pinned inputs need (B21 items 4–5).

**P6. Git invocation** (§2.4).
- **Options.**
  - (a) The `git` program, with three controlled environments, minimum version 2.42, and no message parsing.
  - (b) A Go Git module.
  - (c) Core's own implementation of ignore, attribute and conversion rules.
- **Recommend (a).**
  - RC:287 [PROPOSAL] proposes it, and CORE:858 already requires "pinned Git".
  - (b) needs a D29 record and the owner's sign-off (DEC:124–129, :213).
  - (c) is what D29 says to avoid for formats with many edge cases (DEC:127).
  - The capture environment is what makes "controlled config" (CORE:858) and "later … config edits cannot alter captured bytes" (T05:31) hold.

**P7. The capture recipe** (§2.8).
- **Options.**
  - (a) A private Git directory and index under pinned inputs, with Core walking first and then verifying.
  - (b) `git add -A` in a private index with no Core walk.
  - (c) Core-only hashing with `hash-object` per file.
- **Recommend (a).**
  - G1-R2 shows the private recipe gives Git's own tree minus the pinned exclusions.
  - (b) would capture through junctions and silently drop long paths (G1-R5), and has no raw observation (SPEC:397).
  - (c) costs one process per file.
  - Core's walk, raw read and round trip make Git's result checkable, in line with "never trust … where a host observation is possible" (RC:15) and "read/hash every candidate file" (CORE:854).

**P8. Lossy normalization** (relates to open item 9).
- **Options.**
  - (a) `core.safecrlf=false`, and the rule "raw ∈ {blob, crlf(blob)}".
  - (b) `core.safecrlf=true`.
  - (c) Accept any conversion.
- **Recommend (a).**
  - G1-R2 found that (b) refuses every LF-only text file under `autocrlf=true`, the owner's setting: the whole batch exit 128.
  - (c) fails RC:328 ("lossy normalization refuses capture").
  - (a) allows the uniform CRLF↔LF normalization that D74 accepts (DEC:534 "a normal CRLF checkout need not become a Git content change"), and refuses what cannot be recovered: mixed endings, `\r\r\n`.
  - With filters, encodings and `ident` refused (P9), line endings are the only conversion left, so the rule is complete for v1.
  - The rule is small, fully specified and fully testable (D29 DEC:127).

**P9. Supported kinds and conversions; filter grants** (open item 14).
- **Options.**
  - (a) Regular files only (100644 and 100755). Symlinks, gitlinks and nested repositories are refused. `filter`, `working-tree-encoding` and `ident` are refused. No filter is granted.
  - (b) Also support symlinks with platform rules.
  - (c) Allow named filter grants.
- **Recommend (a).**
  - RC:372: "External clean/smudge filters and unsupported path conversions fail closed; D74 grants no arbitrary executable filter".
  - D74 does not "accept silent passthrough as proof of correct conversion" (DEC:535), and a filter with no driver in the private config would pass through silently.
  - No grantor is named (PKT:271).
  - Symlink materialization differs by platform (`core.symlinks=false` on the owner's machine, G1-R1), and links can point outside the scratch.
  - Each relaxation is a later `capture-rules` version, which re-pinning makes explicit (P13).
  - Consequence: repositories with symlinks, submodules or LFS cannot be captured in v1. The owner summary says so.

**P10. Case and name rules.**
- **Options.**
  - (a) `case_collision` over every path and its directory prefixes, keyed by `strings.ToUpper`; `name_mismatch` when an on-disk name differs from Git's bytes, using the pinned `core.ignorecase` for case-only renames.
  - (b) Collisions only, on Windows.
  - (c) Also detect NFC/NFD equivalence.
- **Recommend (a).**
  - RC:285 requires rejecting "path/mode/case collisions" on every platform: a tree with both `a` and `A` cannot be materialized on Windows, the first target (D27).
  - CORE:249 says "observation must compare paths as git records them".
  - `strings.ToUpper` uses simple uppercase mappings, close to NTFS's upcase table [INFERENCE].
  - (c) needs `golang.org/x/text`, which is a dependency decision (D29). Exact-byte name matching already refuses a normalization difference between the file system and Git; that limitation matters mainly for macOS, which is compiled only until C3's CI.

**P11. Completeness and the walk-first rule.**
- **Options.**
  - (a) Core walks first. Junctions, mount points, devices, pipes and sockets are `special_file` before Git reads; a file Git cannot see is `unobservable_path`.
  - (b) Trust Git's listings.
- **Recommend (a).**
  - G1-R5: Git reads through junctions, so it would capture files from outside the scratch, and it silently skips a 350-character path with exit 0.
  - Go reports junctions as `ModeIrregular` and does not follow them (G2-R9).
  - Limitation: an agent process that swaps a directory for a junction during a capture can race the walk (a check-then-use gap). The supported workflow excludes host writes during capture (D70); hostile same-user processes are C10's (RC:410).

**P12. The capture inputs' content and form** (§2.5).
- **Options.**
  - (a) A Core-internal canonical document, with the host files as pinned bodies.
  - (b) The inputs inline in the ledger record.
  - (c) Files under `workspaces/` as the authority.
- **Recommend (a).**
  - CORE:854 lists the inputs, and CORE:852 binds their digest.
  - (b) would put the owner's exclusion patterns, which can name private files, into every reader's view of the ledger.
  - (c) would be a second authority store, which T05:18 forbids.
  - Bodies are content-addressed and verified on read (B21 item 5), and pinning keeps them from collection while current (B21 item 6).

**P13. Who re-pins the rest of the inputs, and a Git version change.**
- **Options.**
  - (a) One owner-approved update covers the whole input set. A running Git whose version differs from the pinned one makes capture unavailable (`inputs_stale`).
  - (b) Core re-pins Git version and settings automatically and records them per capture.
  - (c) Exclusions are owner-only; the rest may be updated by any caller.
- **Recommend (a).**
  - CORE:854 and :858 call the inputs and the Git "pinned".
  - D112 makes the owner alone the authority for exclusions, which live in the same revisioned set.
  - (b) is D75's unselected option B, "read live … and record those exact inputs" (RC:369).
  - (c) splits one revision between two authorities.
  - Consequence: a Git upgrade needs the owner's re-approval (owner summary). If the advisor judges this the owner's choice rather than the build's, it becomes an owner gate.

**P14. Ignore precedence.**
- **Options.**
  - (a) Git's standard precedence, with the pinned files in place of the live `info/exclude` and `core.excludesFile`.
  - (b) Pinned excludes override the scratch's `.gitignore`.
- **Recommend (a).**
  - D75 replaces which inputs are read; it does not reorder them (DEC:541).
  - D76 lets the captured `.gitignore` govern (DEC:549).
  - (b) would be a new policy that no source states.
  - A negation in `.gitignore` is visible in the submission itself.

**P15. Which repository attributes apply.**
- **Options.**
  - (a) The captured scratch's `.gitattributes`.
  - (b) The baseline's.
- **Recommend (a).**
  - D74's "applicable repository attributes" (DEC:534), read with D76's rule for the sibling `.gitignore` (DEC:549), and with Git's own behavior when adding files.
  - An agent's attribute edit is part of the submission and is subject to P9's refusals.

**P16. Scratch creation and naming** (§2.7).
- **Options.**
  - (a) `worktree add --no-checkout`, then materialization under the private Git directory; `<dir>` = the ID's last 8 hex digits, never reused; branch `dwarf-harness/<dir>`.
  - (b) A plain `git worktree add`.
- **Recommend (a).**
  - G2-R8 shows (a) works and leaves `git status` clean.
  - (b) would check out under the live config and run any repository-configured filter driver or hook, which D74 does not grant (DEC:535).
  - The last 8 hex digits are random bits (UUIDv7's `rand_b`), where a prefix would be timestamp bits.
  - Short names follow D38 (DEC:192).
  - Never reusing names follows RC:285.

**P17. When "main is not checked out" is checked.**
- **Options.**
  - (a) At Inspect, Register and every scratch creation.
  - (b) Also before every capture.
- **Recommend (a).** D48 is enforced at the points where Core could create or rely on a checkout. A capture uses no checkout of `main`. Promotion's own check belongs to ticket 08's update of `main`.

**P18. One colony per workspace.**
- **Options.**
  - (a) A marker ref, `refs/dwarf-harness/colony`, pointing at a blob that holds the colony ID, created only if absent.
  - (b) No cross-colony check.
- **Recommend (a).**
  - D26 says "In v1 a workspace root belongs to one colony" (DEC:96), and only the repository is shared between colonies.
  - `update-ref` with a zero old ID makes creation atomic.
  - It is not a security boundary (C10).

**P19. Git object retention** (open item 8).
- **Options.**
  - (a) Core-owned refs under `refs/dwarf-harness/`:
    - `captures/<capture ID>` points at the sealed tree;
    - `anchors/<scratch ID>` points at the scratch's base commit;
    - the owner of each ref releases it: the capture's owner in ticket 06 and later, closure for anchors.
  - (b) Rely on reachability from `main` and on the scratch branch.
  - (c) Synthetic commits wrapping each sealed tree.
- **Recommend (a).**
  - D56 and D77 leave "object retention" to this specification (DEC:382, :562), and RC:348 requires "explicit durability handling" of Git objects and refs.
  - G1-R7: a ref to a tree keeps it and its blobs through `gc --prune=now`, while the capture index does not.
  - (b) breaks if a branch moves.
  - (c) adds author and time metadata to an immutable result.
  - Ticket 06 will record each capture ref with its admission and decide its release.

**P20. Git-side durability.**
- **Options.**
  - (a) `core.fsync=committed` with `core.fsyncMethod=fsync` on every Git write; the order objects → ref → ledger record; refs before records.
  - (b) Git's defaults.
- **Recommend (a).**
  - RC:348 and D59 (DEC:413) require explicit durability handling.
  - G1-R7 shows Git 2.55 accepts the settings.
  - Git's default leaves loose objects unsynced [INFERENCE from Git's documentation].
  - A crash between ref and record leaves only an orphan ref, which Open removes (§2.12).
  - No power-loss claim is made (B3).

**P21. Capture caps and values** (open item 11).
- **Options.**
  - (a) An explicit `CaptureProfile` with provisional values: 100,000 files, 1 GiB per capture, 20 GiB in flight. A nil profile is unavailable.
  - (b) No values, left to the host.
  - (c) Owner-chosen values.
- **Recommend (a).**
  - CORE:862 requires an explicit profile and makes a missing one unavailable.
  - RC:338 and DEC:763–764 keep the values provisional.
  - B21 set comparable Core policy itself (DEC:1445).
  - The reasons for each value:
    - *Files:* 100,000 is ten times A.7's 10,000-file shape. Its manifest, at about 220 bytes an entry, stays near 22 MiB, under the 64 MiB body cap that ticket 06 will publish it into (DEC:1399).
    - *Bytes:* 1 GiB per capture bounds both what one capture reads and what it may write.
    - *In flight:* 20 GiB lets a 20-pair synchronized burst (RC:338), at one capture per scratch, pass without `capture_budget`.
  - The values are calibrated by A.11 and by C4's feasibility gate (RC:285). (b) defers a choice the assignment asks for; (c) is not an owner decision, because they are Core policy, as in DEC:1445.

**P22. Scratch exclusion and BeginWrite** (§2.9).
- **Options.**
  - (a) Exclusive holders never wait; shared writers wait.
  - (b) Writers are refused while a capture runs.
  - (c) No writer API until C3.
- **Recommend (a).**
  - D70: capture returns busy rather than "waiting for the writer", and "exclude host-managed writes … during capture" (DEC:503). It does not forbid a writer waiting.
  - (b) would push busy onto agents' file tools, which no source asks for.
  - (c) leaves "contention returns immediate busy … without … writer interruption" (T05:30) untestable.

**P23. Closure rules** (§2.11).
- **Options.**
  - (a) Represented = the anchor tree for now. A capture refusal blocks closure. Ignored files do not block and are deleted. The record comes before removal, which is retried. The branch is deleted only when it is still at base. A missing directory may be closed.
  - (b) Any untracked file, ignored or not, blocks closure.
- **Recommend (a).**
  - RC:304 says "cannot remove unrepresented edits"; ignored files are not candidate content (D60 DEC:421), so they are not edits a submission could represent.
  - (b) would make every scratch with build output unclosable.
  - CORE:248 requires recording a removal failure and retrying, "never assuming success". G1-R6 shows that need.
  - Keeping a moved branch keeps history no capture covers. DEC:511's "Retain scratch work and history" is the closest rule.

**P24. The raw manifest and the seal result.**
- **Options.**
  - (a) A JSON Lines manifest, returned with its SHA-256. The caller publishes it with its record (ticket 06).
  - (b) Ticket 05 publishes it as a body.
- **Recommend (a).**
  - The manifest's first line is `{"format":"dwarf-harness/capture-manifest","version":1,"object_format":…}`.
  - Then one line per path, sorted by path bytes: `{"path","mode","id","size","sha256"}`, in that key order.
  - It records CORE:852's "raw manifest digest" and D74's raw identity.
  - Publishing a body that no record references would leave unreferenced bodies (B21 item 7). Ticket 06 binds the digest in its admission record.

**P25. The F2-05 record set and shapes** (Appendix B).
- **Options.**
  - (a) Four types: `workspace.registered`, `workspace.capture_inputs_pinned`, `workspace.scratch_created`, `workspace.scratch_closed`. Version 1 defines only reason `abandoned`, and `reason` is an open token.
  - (b) Also `scratch_base_advanced` and the temporary-scratch fields now.
  - (c) A closed reason enum.
- **Recommend (a).**
  - These are exactly the records ticket 05 writes.
  - (b) would be "placeholder payloads for later work" (CORE:844; B2 DEC:648).
  - Ticket 07 can add `parent_scratch_id` as an optional field (D40).
  - (c) would need a new type version for each reason that tickets 07–08 add. An open token with "an unknown reason is a closure for a reason this reader does not know" lets readers ignore reasons safely. B18 item 1 made `measurement_path` family-owned vocabulary in the same way.

**P26. F2-05's placement, golden and version label.**
- **Options.**
  - (a) Additions to `contract/ledger`, with `Defined()` extended, the namespace `workspace.` reserved for C2's families, a golden at `testdata/f2/05/`, and `ledger-format` still version 1 with catalogue stages F0 and F2-05.
  - (b) A new contract package.
  - (c) Core-internal payload types.
- **Recommend (a).**
  - CON:34 and CON:38 (C1 encodes; Core is sole writer); CON:84 and RC:374 (no new contract package).
  - Undercurrent may import only `contract/...` (D45), and U3, U4 and U9 consume these records (RU:86, :341, :530).
  - D35's own example type is `workspace.promotion_accepted` (DEC:172).
  - D111 froze "version 1" with a catalogue, and additions do not change the version (CON:13–17). The label is a freeze question (§8).

**P27. Service lifecycle** (§2.12).
- **Options.**
  - (a) Open replays and validates its own records, then reconciles the file system and refs, best effort and reported. An uncertain append poisons the service until it is reopened.
  - (b) Trust the projections without validation.
- **Recommend (a).**
  - This follows ledgerstore's rebuild (B21 item 10) and its poisoning (B18 item 6).
  - D37 and D55: never assume success after a crash (DEC:186, :371).
  - Cost: a second log pass at startup. A fused pass is C3's measured-trigger option (DEC:1495).

**P28. Authority in C2.**
- **Options.**
  - (a) Callers state the actor (`owner` or `agent`, with its context), the service records it, and C3 authenticates.
  - (b) A stand-in authenticator.
- **Recommend (a).**
  - RC:313 gives binding to C3.
  - ledgerstore's `Collect` takes its actor the same way, leaving authorization to C3 (B21 items 5 and 7).
  - (b) would be a stub of what C2 waits for (DEC:213).

**P29. Capture-cost harness and Appendix A.11.**
- **Options.**
  - (a) Include it.
  - (b) Defer it to a later C2 or C4 ticket.
- **Recommend (a).**
  - RC:411 and RC:415 require C2 to record capture and materialization costs.
  - The engine is ticket 05's, and D78 asks for measurements at the implementation gate (DEC:571).
  - It follows B21's harness pattern (DEC:1460).
  - It measures single captures only; burst concurrency stays C4's gate (RC:285).

**P30. Sequential reads in v1.**
- **Options.**
  - (a) One reader per capture.
  - (b) Bounded parallel reads.
- **Recommend (a).**
  - Fewer moving parts.
  - A.7's cost is first-read latency, which a warm scratch avoids (CORE:223).
  - P29 measures it; parallelism is a later B-entry if the numbers ask for it.

**P31. Documents and statuses** (§2.17).
- **Options.**
  - (a) Set C2 to *In progress* when S1 lands, editing the status line RC:417 inside the approved range.
  - (b) Leave the statuses until S3.
- **Recommend (a).**
  - RM:62 defines *In progress*, and RM:198 requires the board and roadmap in one commit.
  - D112 itself edited RC:417, and the packet calls the status line "the line approval changes" (PKT:35).
  - No mechanism text changes.

**P32. Tests need real Git.**
- **Options.**
  - (a) A missing or old Git fails the package's tests.
  - (b) Tests skip without Git.
- **Recommend (a).** SPEC:587 and T05:35 require actual repositories, and a skipped gate does not count (SPEC:589).

**P33. Owner-gate labels.** OG-A and OG-B are provisional names; the PM assigns the next global OG numbers (OG1–OG3 are taken).

### 7.2 Owner gates

**OG-A: approve the design** (T05:49).
- **Asked:** approve this brief, as the advisor rules on it, before any code. The summary points out:
  - v1's refusals: symlinks, submodules, LFS and other filters, encodings, `ident` (P9);
  - a Git upgrade needs the owner's re-approval of the inputs (P13);
  - the provisional caps (P21);
  - ignored files are deleted when a scratch closes (P23);
  - Appendix B is the basis of the F2-05 freeze request.
- **Options:** "Approve as ruled"; "Approve with changes", naming them; "Not yet".

**OG-B: how F2 is frozen, and what may start before.**
- **Facts.**
  - CORE:844: "Freeze **F2** for C2 promotion records before C2 implementation".
  - RC:220: "F2 adds C2 promotion lifecycles before C2 implementation".
  - RC:271: "add F2–F6 … only before their corresponding producer implementation (B2)".
  - RC:407: "C2 records F2 proposal before producer implementation".
  - D112 (DEC:1533) repeats both phrasings.
  - T05:49: "frozen by the owner before C2 producer implementation, and no code starts before the owner approves the design".
  - PKT:252: the sources say neither which C2 work may precede the freeze, nor whether F2 is frozen once or in parts.
- **Options.**
  1. **In parts, ticket by ticket** (recommended). Each C2 ticket that writes records proposes its part (F2-05 here; then 06–09), and the owner freezes each part by addition to `ledger-format` v1 before the code that writes it. Code that writes no record (S1) may start after OG-A and reach `main` after review.
  2. **In parts, but no code before the part's freeze.** As 1, but S1 also waits for the F2-05 freeze.
  3. **Once.** Every C2 record is proposed and frozen together before any C2 code that writes records. S3 then waits for the designs of tickets 06–09.
- **Recommendation: 1.**
  - B2 freezes "producer-ready" families only, with "no placeholder payloads for later work" (DEC:648; CORE:844). Designing tickets 06–09's records now would specify records whose producers are not designed.
  - D40's additive rule lets later parts join without breaking earlier ones (DEC:206).
  - RC:271 and RC:407 tie the freeze to producer implementation.
  - T05:49 separates design approval from producer implementation.
  - Option 2 delays mechanics that write nothing for no protection: S1's code commits no ledger format.

**Not owner gates here:**
- P1–P33 are the advisor's to rule on; P13 is flagged above in case the advisor judges it the owner's.
- No dependency is added, so no D29 or D41 dependency sign-off is needed.
- The F2-05 freeze itself is a later owner decision (§8).

---

## 8. The later freeze path (F2-05)

**Who and when.** Freezing is the owner's decision (D40 DEC:206; CON:13–19). After OG-A, and with OG-B answered 1 or 2, S2 is drafted on a branch. The PM then sends one question-tool request, with a packet modelled on OG2's (`.scratch/dwarf-harness/c1-evidence/og2-f0-freeze-packet.md`) and on the D52 packet's structure. S3 starts after the answer.

**The packet:**
1. **What is requested.** Freeze, by addition to `ledger-format` version 1 (D40, D111), the four F2-05 types at version 1, with their payloads, record rules and golden, at commit «S2 tip». `Defined()` gains them, and the namespace `workspace.` is reserved for C2's families.
2. **Surfaces.**
   - `go doc` of the new types, and the new section of `ledger/doc.go`;
   - the golden with its SHA-256;
   - the CONTRACTS.md F2-05 table;
   - this brief's Appendix B, as ruled.
3. **Evidence.**
   - S2's tests;
   - V8: the F0 goldens unchanged, with D111's hashes;
   - the fuzz durations;
   - platforms: verified on Windows, compiled and vetted for Linux and macOS (V12).
4. **D78, each part labelled.**
   - *Assumption:* registrations and updates are rare, and each scratch writes two records in its lifetime. At OG3's 60 contexts (DEC:1471), w workspaces give at most 120·w scratch records per lifetime.
   - *Calculation:* negligible against B21's model of 960 records per context-hour (DEC:1459). Bodies: one inputs document under 1 KiB and at most five host files of up to 1 MiB each, per revision.
   - *Measurement:* none needed for the records; capture cost is A.11, not a record property.
5. **Questions,** each with a recommendation:
   1. the four types and their names;
   2. `reason` as an open token with `abandoned` defined (P25);
   3. a host path in `workspace.registered`;
   4. inputs pinned while current, released on update;
   5. privacy-class wording in words, as F0 does;
   6. the F2 staging chosen at OG-B;
   7. the version label: `ledger-format` 1 with catalogue stages F0 and F2-05 (P26);
   8. Undercurrent §15.1 gaining the "Scratch closed" row that RC:289 asks for, in the freeze's own documents commit.
6. **Options:** "Freeze as presented"; "Freeze with changes", naming the questions (a follow-up change makes them, and the freeze is recorded at its commit); "Not yet".
- **Appendix A:** a draft owner decision entry, "F2-05 workspace and scratch records frozen", with the golden's SHA-256. Consequences: the types change only by addition; ticket 05's S3 may start; U3's foundation may consume them once its other prerequisites hold (RU:86).
- **Appendix B:** the register edit: the F2-05 table marked frozen, and the status line.

**After an answer.** A docs-only commit holds the decision entry, the register edit, the §15.1 row and an "Open items awaiting the owner" row while unanswered (DEC:24–28), as D111 did. S2 then reaches `main`, and the PM writes ticket 05's comment. None of this belongs to S1 or S3.

---

## Appendix A. Source reconciliation (the map's open items)

| Item | Resolution |
|---|---|
| 1 D52 status conflict | Resolved by D112 at dfe2414 (DEC:1523–1535; RC:406, :417; T05:51) |
| 2 F2 freeze timing | OG-B |
| 3 Temporary-scratch trigger | Ticket 07's. D23's "created on that turn's first write" (DEC:71) and T07:12's "first conflicting writer access" name the same event: the second turn's first write is the conflicting access. Ticket 05 supplies BeginWrite, which ticket 07 can use |
| 4 T05:18 versus D111 | T05:18 is publication-time text. D111 froze F0 (DEC:1509–1521), which meets T05:22's consumed families |
| 5 Four lanes | C4 and ticket 06; not ticket 05 |
| 6 D62 versus B4 | D112 adopted B4's amendment (DEC:1531); the K-slot is ticket 06's (P1) |
| 7 Scratch lifecycle rows missing from UC §15.1 | F2-05 proposes `scratch_created` (UC:612) and `scratch_closed` (RC:289); the §15.1 row lands with the freeze (§8). "Base advanced" is later work |
| 8 Git object retention | P19 |
| 9 `core.autocrlf` open or settled | Settled by D74; RC:286 now says so (D112's edit). Pinned as an input (§2.5); lossy cases per P8 |
| 10 The case-insensitivity citation | RC:286's [INFERENCE]; CORE:249's rule is implemented (P10), and B«next» records the evidence under RM:232 |
| 11 Cap values | P21 |
| 12 Scenario 1 versus PKT §5.5 | P1 and P2: admission scenarios are ticket 06's mechanics; capture is exercised as a mechanism, and through closure |
| 13 Exclusion update authority | D112: the owner alone (DEC:1532; CORE:854) |
| 14 Filter grants | P9: none in v1 |
| 15 Ticket 05 / ticket 06 boundary | P1 |

## Appendix B. F2-05 proposal: ticket 05's part of F2

**B.1 Common rules.**
- Payloads follow F0's encoding rules (`ledger/doc.go` "F0 record types"; B21 item 2):
  - a Go type with `Encode`, which validates and writes compact JSON with keys in the tabled order, and a decoder;
  - errors wrap `ErrInvalid`;
  - unknown keys are ignored, so a version can gain optional keys by addition;
  - re-encoding a decoded payload reproduces the bytes that `Encode` wrote.
- **Git object IDs** are lowercase hex, 40 digits for `sha1` and 64 for `sha256`. The decoder accepts either length; the length must match the workspace's `object_format` (a record rule).
- **Producer.** Every F2-05 record is written by Core's workspace service (`internal/core/workspace`), which is the only permitted appender caller, through `appender.Appender`. This is enforced by review (B18 item 5's precedent). The service checks the record rules when appending and at Open.
- **Payload-specification owner:** C2. The encoding lives in C1's contract (CON:34, :38).
- **Namespace.** `workspace.` is reserved for C2's families. Neither `ledger.` (F0) nor `fixture.` (B18 item 5) may hold them.

**B.2 `workspace.registered` v1 (`WorkspaceRegistered`)**

| key | type | presence | rule |
|---|---|---|---|
| `workspace_id` | UUIDv7 | required | the workspace's ID |
| `common_dir` | string | required | the repository's common Git directory as Core resolved it: absolute, non-empty, at most 4,096 bytes |
| `object_format` | string | required | `sha1` or `sha256` |

Record rules:
- actor `owner`; `body_refs` absent;
- it is index 0 of a three-record commit whose index 1 is its `workspace.capture_inputs_pinned` with revision 1, and whose index 2 is that record's `ledger.body_pin`;
- `workspace_id` is new;
- no earlier `workspace.registered` names the same `common_dir`.

**B.3 `workspace.capture_inputs_pinned` v1 (`CaptureInputsPinned`)**

| key | type | presence | rule |
|---|---|---|---|
| `workspace_id` | UUIDv7 | required | a registered workspace |
| `revision` | integer | required | 1 at registration; otherwise the current revision plus 1 |
| `capture_inputs_sha256` | digest | required | SHA-256 of the capture-inputs document, a body |
| `pin_id` | UUIDv7 | required | the `ledger.body_pin` in the same commit that pins this revision |

Record rules:
- actor `owner`;
- `body_refs` is present and holds exactly the document and every body it names;
- the same commit holds a `ledger.body_pin` with `pin_id` and the same `body_refs`;
- revision 1 appears only as index 1 of the registration commit;
- revision n+1 is index 0 of its commit, with its pin at index 1 and the `ledger.body_unpin` of revision n's `pin_id` at index 2.

**B.4 `workspace.scratch_created` v1 (`ScratchCreated`)**

| key | type | presence | rule |
|---|---|---|---|
| `scratch_id` | UUIDv7 | required | the scratch's ID |
| `workspace_id` | UUIDv7 | required | a registered workspace |
| `context_id` | UUIDv7 | required | the bound work context that owns the scratch and authors its changes (D17, D23) |
| `dir` | string | required | 8 lowercase hex digits; the scratch is `scratch/<dir>` in the colony directory |
| `branch` | string | required | a full ref name beginning `refs/heads/` |
| `base_commit` | Git object ID | required | the canonical commit the scratch was cut from (RC:297) |
| `anchor_tree` | Git object ID | required | that commit's tree: the root eligibility baseline (CORE:854) |

Record rules:
- actor `core`; the envelope's `context_id` equals `context_id`; `body_refs` absent;
- `scratch_id` is new;
- the pair (`context_id`, `workspace_id`) has no open scratch;
- `dir` and `branch` were never used by an earlier scratch;
- the ID lengths match the workspace's `object_format`.

**B.5 `workspace.scratch_closed` v1 (`ScratchClosed`)**

| key | type | presence | rule |
|---|---|---|---|
| `scratch_id` | UUIDv7 | required | an open scratch |
| `context_id` | UUIDv7 | required | the scratch's context |
| `reason` | string | required | a token matching `^[a-z][a-z0-9_]*$`, at most 64 bytes; version 1 defines `abandoned` |

Record rules:
- actor `owner`, or `agent` with the envelope's `context_id` equal to `context_id`; `body_refs` absent;
- a scratch closes at most once;
- `context_id` is the scratch's;
- Core writes only reasons its reading version defines. A reader treats an unknown reason as a closure for a reason it does not know, never as invalid. Later parts of F2 may define further reasons by addition: `temporary_merged_back` for ticket 07, `promoted` for C4's integration, and so on (RC:289).

**B.6 Golden sample** `contract/ledger/testdata/f2/05/log/00000000000000000001.jsonl`. One LF-only segment (B1) built by `TestGoldenF2_05`, with fixture IDs, digests and times from the helpers of `golden_test.go`:

| Commit | Records (seq) | Actor |
|---|---|---|
| c1 | 1 `workspace.registered` (W1, `C:/fixture/repo-a/.git`, `sha1`); 2 `capture_inputs_pinned` (W1, revision 1, digest I1, pin P1; `body_refs` [I1, X1], sorted); 3 `ledger.body_pin` (P1; the same refs) | owner |
| c2 | 4 `workspace.registered` (W2, `/fixture/repo-b/.git`, `sha256`); 5 `capture_inputs_pinned` (W2, 1, I2, P2; [I2]); 6 `ledger.body_pin` (P2; [I2]) | owner |
| c3 | 7 `workspace.scratch_created` (S1, W1, C1, `0a1b2c3d`, `refs/heads/dwarf-harness/0a1b2c3d`, 40-digit base and anchor) | core, envelope context C1 |
| c4 | 8 `workspace.scratch_created` (S2, W2, C2, `4e5f6a7b`, `refs/heads/dwarf-harness/4e5f6a7b`, 64-digit IDs) | core, envelope context C2 |
| c5 | 9 `capture_inputs_pinned` (W1, revision 2, I3, P3; [I3, X1]); 10 `ledger.body_pin` (P3; the same refs); 11 `ledger.body_unpin` (P1) | owner |
| c6 | 12 `workspace.scratch_closed` (S1, C1, `abandoned`) | agent, envelope context C1 |

**B.7 Register entries** (CON:34's attributes):

| Type, version 1 | Payload owner | Producer | Permitted appender caller | Consumers | Privacy class | Replay-essential fields | Golden |
|---|---|---|---|---|---|---|---|
| `workspace.registered` | C2 | Core's workspace service, at the owner's registration | `internal/core/workspace` only (review) | Core's workspace service (replay); C3 (workspace binding); U3 foundation, U4, U9 (RU:86); owner inspection | identifiers and a host path to the repository's Git directory; no file content | `workspace_id`, `common_dir`, `object_format` | seqs 1, 4 |
| `workspace.capture_inputs_pinned` | C2 | as above, at registration and the owner's updates | as above | Core's capture and materialization; C4's candidate materialization (the same inputs); owner inspection | identifiers and digests. The bodies it references hold the owner's ignore and attribute patterns, which can name private files, and are read only through Core's authorized body reads (C3) | all four keys and `body_refs` | seqs 2, 5, 9 |
| `workspace.scratch_created` | C2 | as above, on a context's first use | as above | Core's workspace service; C3 (the scratch a context's tools use); U3, U4 (open scratches), U9 (occupancy) (UC:612; RU:341, :530) | identifiers, a branch name and Git object IDs; no file content | all seven keys | seqs 7, 8 |
| `workspace.scratch_closed` | C2 | as above, at an explicit closure | as above | as for `scratch_created` | identifiers and a reason | all three keys | seq 12 |

## Appendix C. Acceptance trace

| Criterion | Behavior | Tests |
|---|---|---|
| T05:28 canonical `main` never checked out | §2.6 steps 1–3, §2.7 steps 2 and 6 | `TestInspectRefuses`, `TestCreateNeverChecksOutMain`, `TestRegisterRefusals` |
| T05:28 one bound context/workspace | §2.7 binding; B.4 rules | `TestScratchOnePerPair`, `TestScratchNamesNeverReused`, `TestCloseScratchAuthority`, `TestRequestPromotionBinding` |
| T05:28 cleanup keeps unrepresented edits | §2.11, §2.12 step 7 | `TestCloseScratchRefusesUnrepresentedEdits`, `TestOpenReconciles`, `TestCloseRemovalPending` |
| T05:29 full Git-canonical eligible contents against the trusted baseline | §2.5, §2.8 | `TestCaptureEligibility`, `TestCaptureCanonicalContent`, `TestCaptureIgnoresScratchIndexAndHead`, `TestCaptureReadsEveryFile`, `TestControlledEnvironmentIgnoresHostGit` |
| T05:29 captured scratch ignores and pinned reviewed exclusions | §2.5, §2.6, P14 | `TestCaptureEligibility`, `TestUpdateInputsCompareAndSwap`, `TestInspectImportsHostInputs` |
| T05:30 reserve before capture; immediate busy without snapshot, wait, retry or writer interruption | §2.9 | `TestExclusiveIsImmediateBusy`, `TestWriterWaitsForCapture`, `TestPoolIsAtomic`, `TestReservationReleasedOnEveryPath`, `TestRequestPromotionBusyBeforeUnavailable`, `TestCloseScratchBusy` |
| T05:30 missing validator is unavailable | §2.9 | `TestRequestPromotionIsUnavailable` |
| T05:31 refusals | §2.8 | `TestCaptureRefusals`, the platform tests, `TestCaptureCaps`, `TestCaptureDetectsChangeDuringCapture` |
| T05:31 later scratch, index or config edits cannot alter captured bytes | §2.10 | `TestSealIsImmutable`, `TestTamperedMaterializationIsRewritten` |
| SPEC stories 7, 8, 9, 11 | as the rows above | — |
| SPEC implementation 1–4 | §2.1 gates, §3, Appendix B | the S2 goldens and refusals |
| SPEC implementation 7 | §2.7–2.9 | the rows above |
| SPEC testing 1, 2, 9 | real repositories; behavior assertions | all |
| SPEC testing 18 | §2.16, P29 | `TestCaptureWorkload` (V11) |
| SPEC testing 20 | regression cases carried as tests | — |

## Appendix D. Runner probe facts used

- **G1-R1.** git 2.55.0.windows.3. The system config sets `core.autocrlf=true` and `core.symlinks=false`. `git var GIT_ATTR_SYSTEM` printed `C:/Program Files/Git/etc/gitattributes`, and `GIT_ATTR_GLOBAL` printed `C:/Users/darius.jones/.config/git/attributes`. No global ignore or attributes file exists, and `XDG_CONFIG_HOME` is unset.
- **G1-R2.**
  - Under `autocrlf=true`, `core.safecrlf=true` makes `update-index --add` refuse an LF-only text file with exit 128; the whole batch is refused and nothing is written.
  - With `safecrlf=false`, the private-directory recipe gave the tree of a normal `git add -A` minus the pinned-excluded file. A CRLF file was stored as LF.
  - The private Git directory needed no `objects/`, and the scratch's index was unchanged.
  - The runner's copy of the full environment line was truncated, so the exact variables are unverified. Index, object directory, private excludes and work-tree rules were observed in effect, and S1's tests verify the rest.
- **G1-R3.** A mixed-ending file is refused under `safecrlf=true`.
- **G1-R4.** A nested repository is listed as `sub/`. `update-index` with `sub` writes a gitlink (160000); with `sub/` it writes nothing, with a warning.
- **G1-R5.** Git lists and indexes files through a junction. A 350-character path is skipped by `ls-files -o` and `-o -i` with exit 0 and only a warning.
- **G1-R6.** With a file held open, `worktree remove --force` exits 255, drops the registration and most files, and leaves an orphan directory; a second `remove` exits 128 with "not a working tree".
- **G1-R7.**
  - A ref to a tree keeps the tree and its blobs through `gc --prune=now`; after the ref is deleted, gc prunes them.
  - A blob referenced only by the private index is pruned.
  - `core.fsync=committed` with `core.fsyncMethod=fsync` is accepted without warning.
- **G2-R8.** `worktree add --no-checkout` leaves only `.git` and no index. A private-directory `read-tree -u --reset` then writes the files under the pinned `autocrlf` (CRLF on disk) and the worktree's index. `git status --porcelain` is clean, and the branch is checked out. (a)+(b) took about 1.0 s for 1,000 files, on a machine also running another ticket's checks.
- **G2-R9.** On go1.27.2 on Windows:
  - a junction is `ModeIrregular`, neither a directory nor a symlink, from both `Lstat` and `DirEntry.Type()`;
  - file and directory symlinks are `ModeSymlink`, and both could be created without extra privilege;
  - `Lstat` of a path through a junction succeeds and resolves to the target.
