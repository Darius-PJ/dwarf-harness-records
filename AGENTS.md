# dwarf-harness

Canonical instructions for every coding agent working in this project.

## Decision records

Read `docs/CURRENT-RULES.md`: one line for each rule in force, with the entries that make it. Open an entry in `docs/DECISIONS.md` only for its reasoning or history (D161).

Write a new entry only when a standing rule, the project's scope or an owner gate changes. A ticket adds no build record: its `## Answer` and evidence file say what it built, and its exceptions, rulings and answers stay in its notes, ruling and evidence. An entry is short: the date, **Decided by:**, the decision in a few lines and what it amends; no quotes, evidence paragraphs, line-number citations or pointer lines added to earlier entries. Change the rule's line in `docs/CURRENT-RULES.md` in the same commit.

**Decided by:** records the originator:

- `owner`: the owner originated it. State what he decided; the session history keeps his words.
- `adopted`: an assistant proposal accepted as written, including a pick from assistant-written options and bulk approvals such as "as described".
- `modified`: an assistant proposal the owner changed. State the change.
- `assistant`: decided by an agent within leeway the owner delegated.

Use `adopted` when unsure. Entries before D161 stay as written.

`docs/DECISIONS.md`, `docs/CURRENT-RULES.md` and the evidence folders `.scratch/dwarf-harness/*-evidence/` are private records, kept with this file and the role files in the private records repository, never in the published project repository (D145). Only they may quote the owner; earlier entries do. Every file the project repository tracks, including tickets, roadmaps, documents and code comments, and every commit message, states what he decided and cites the entry. It never quotes him, never names his Windows user folder, and never describes his machine, its settings or the programs he runs.

## Agent skills

### Issue tracker

Issues and specs use the local Markdown tracker. Before reading, creating or publishing them, follow [the tracker conventions](docs/agents/issue-tracker.md).

### Triage labels

Use the five default triage roles as local `Status:` values. See [the label mapping](docs/agents/triage-labels.md).

### Domain docs

Use one domain context and the existing decision log. Before exploration or design, read [the domain-document rules](docs/agents/domain.md).

## Building

Before taking a build step, read [the roadmap index](docs/ROADMAPS.md) for the reading order, the working rules and the status board; for a Core step, also read the working principles at the top of [the Core roadmap](docs/ROADMAP-CORE.md).

- **Workspace:** take one step per agent, in its own worktree and branch (D41).
- **Check:** rebase onto `main` as needed, then fast-forward `main` only to the exact branch SHA approved under D152 whose hosted `Check result` from GitHub Actions succeeded (D41, D42, D46, D153). Fixes and rebases need their own run. The hosted full check includes race on Windows, Linux and macOS. On pushes, Markdown-only changes since the merge base may skip the matrix, but still need successful `Check result` and the PM's links/LF check (D128); manual dispatch forces the full matrix. Coders use D152's focused local checks, not an additional full gate. A local race run still needs the pinned llvm-mingw clang (D28).
- **Commits:** use Conventional Commits with the package as the scope, and commit on your branch when the tests you touched pass. The PM pushes guarded `build/**`, `fix/**` and `docs/**` branches for CI during review, then passing fast-forward `main`, without routine owner approval or a once-per-ticket wait (D153). Scan every outgoing commit. A `.github/` change still needs explicit owner sign-off recorded in a decision entry; an override alone is not sign-off. Preserve D152's other owner gates.
- **Owner sign-off:** a change that touches a frozen contract, an owner decision or a new dependency waits for the owner before `main` moves (D41).
- **Layers:** imports run one way, `cmd` → `internal/core` → `internal/router` and `internal/undercurrent` → `contract`; `tools/check` enforces D45's full table (D45, D50).
- **Dependencies:** prefer the standard library. A new module needs its D29 record before use; write code yourself only for small, fully specified and fully testable parts (D29).
- **Go commands:** run them with `GOTOOLCHAIN=local` and an explicit `CGO_ENABLED`; Core and the terminal program never use cgo (D28).
