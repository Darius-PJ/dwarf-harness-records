# dwarf-harness

Canonical instructions for every coding agent working in this project.

## Decision records

Every new entry in `docs/DECISIONS.md` records its **originator** in the existing **Decided by:** field:

- `owner`: the owner originated it. Quote his typed words verbatim in the entry.
- `adopted`: an assistant proposal accepted as written, including a pick from assistant-written options and bulk approvals such as "as described".
- `modified`: an assistant proposal the owner changed. State the change.
- `assistant`: decided by an agent within leeway the owner delegated.

Use `adopted` when unsure. Entries dated before 2026-10-04 stay as written.

`docs/DECISIONS.md` and the evidence folders `.scratch/dwarf-harness/*-evidence/` are private records (D145), and only they quote the owner. Every tracked file, including tickets, roadmaps, documents, code comments and commit messages, states what he decided and cites the entry. It never quotes him, never names his Windows user folder, and never describes his machine, its settings or the programs he runs.

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
- **Check:** `go run ./tools/check` passes before `main` moves, and `main` moves only by fast-forward after a rebase (D41, D42, D46). A commit that changes only Markdown files since a passing check needs only the document check: links resolve and files are LF (D128). Slice merges run `go run ./tools/check -race=false`; each ticket's last code slice runs the full check (D129). Its race step needs `DWARF_CC` set to the absolute path of the pinned llvm-mingw clang (D28).
- **Commits:** use Conventional Commits with the package as the scope, and commit on your branch when the tests you touched pass. Pushing waits for the owner (D31, D46).
- **Owner sign-off:** a change that touches a frozen contract, an owner decision or a new dependency waits for the owner before `main` moves (D41).
- **Layers:** imports run one way, `cmd` → `internal/core` → `internal/router` and `internal/undercurrent` → `contract`; `tools/check` enforces D45's full table (D45, D50).
- **Dependencies:** prefer the standard library. A new module needs its D29 record before use; write code yourself only for small, fully specified and fully testable parts (D29).
- **Go commands:** run them with `GOTOOLCHAIN=local` and an explicit `CGO_ENABLED`; Core and the terminal program never use cgo (D28).
