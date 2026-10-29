# Coder context: DwarfHarness standing facts (read once, before your assignment)

Every coder assignment links this file. It answers the questions earlier coders had to ask. Your assignment wins where it says something more specific.

## Repository rules (`AGENTS.md`)
`AGENTS.md` lives only in the main checkout, `C:\Users\darius.jones\Documents\PROJECTS\dwarf-harness\AGENTS.md` (D136); worktrees lack it. Read it there if you want, read-only. What applies to you:
- Work only in your assigned worktree, with absolute paths: your tools start in the main checkout, so a relative path edits `main`.
- Imports run one way: `cmd` → `internal/core` → `internal/router` and `internal/undercurrent` → `contract` (D45; `tools/check` enforces the table).
- Standard library first; no new module (D29).
- Every Go command sets `GOTOOLCHAIN=local`, an empty `GOFLAGS` and an explicit `CGO_ENABLED`; Core never uses cgo (D28).
- The PM owns commits, timed fuzz campaigns, guarded work-branch pushes and promotion. D153's full check runs on GitHub, during fresh review, and `main` moves only to the exact SHA whose `Check result` passed. You run the focused D152 evidence below, not a duplicate local full check, and make no Git writes.

## Toolchain and commands
- Go 1.27.3 (D147, since 2026-10-25; it was 1.27.2): `C:\Program Files\Go\bin\go.exe` (GOROOT `C:\Program Files\Go`). Race runs alone use `CGO_ENABLED=1 CC=C:\Users\darius.jones\AppData\Local\Programs\llvm-mingw-20260922-ucrt-x86_64\bin\x86_64-w64-mingw32-clang.exe`.
- Git 2.55.0.windows.3, with system `core.autocrlf=true` and `core.symlinks=false`.
- Module cache: `C:\Users\darius.jones\go\pkg\mod` (grep it yourself; `golang.org/x/sys` v0.48.0 is there).
- **Static checks (D137, D152):** host `go vet` and staticcheck always; all five targets (windows/amd64, linux/amd64, linux/arm64, darwin/amd64, darwin/arm64) only when you change files with build constraints, since the check runs all five on the exact commit.
  - vet: `GOOS=<os> GOARCH=<arch> go vet ./<pkg>` for each.
  - staticcheck: build it once for the host, `CGO_ENABLED=0 go build -trimpath -o <evidence>\staticcheck.exe honnef.co/go/tools/cmd/staticcheck`, then run `<evidence>\staticcheck.exe ./<pkg>` with each target's `GOOS`/`GOARCH`. `GOOS=linux go tool staticcheck` cannot run on this machine.
- No module change: `go mod tidy -diff` prints nothing. Import audit: `go list -f '{{join .Imports "\n"}}' ./<pkg>` and the same with `.TestImports`.
- **Native tools for the graph tests** (rows skip without them; echo each value in your evidence):
  - `DWARF_GRAPH_PYTHON=C:\Program Files\Python313\python.exe` (3.13.15);
  - `DWARF_GRAPH_NODE=C:\nvm4w\nodejs\node.exe` (v24.18.0);
  - `DWARF_GRAPH_TYPESCRIPT=C:\Users\darius.jones\Documents\PROJECTS\Animation-study\node_modules\typescript\lib\typescript.js` (6.0.3; read-only, install nothing);
  - `DWARF_GRAPH_GO=C:\Program Files\Go\bin\go.exe`, `DWARF_GRAPH_GOROOT=C:\Program Files\Go`;
  - `DWARF_GRAPH_GO_HELPER`: build once with `CGO_ENABLED=0 go build -trimpath -o <evidence>\go-analyzer.exe ./helpers/go-analyzer` from your worktree, as `tools/check` does.

## Imports
Your assignment states your package's exact production and test import sets, from its ruling. Standing rows (D45, B3): `contract/...` imports the standard library only; `golang.org/x/sys` is allowed only in `internal/core/durable`, `internal/core/winexec` and, from ticket 13 (its ruling, P1 and P4), `internal/core/credentials`; `internal/undercurrent/...` imports the standard library and `contract/...`, and only `internal/undercurrent/graph` may use the appender. Windows-only test rows call native APIs through `syscall.NewLazyDLL` in `_windows_test.go` files (pattern: `internal/core/ledgerstore/peakmem_windows_test.go:11-17`).

## Tests (B28 item 8, D131, D138, D152)
- **What you run (D152):** the focused tests of the code you change, then one plain whole-package run per changed package (`-v`, log saved). A whole-package race run, and ×20 race repetitions of the affected rows, only when your slice changes locking, goroutines, channels or other shared state; the check on the exact commit runs everything else, race included. Your assignment's final runs are the list to follow.
- **Rule breaks (D152)** only for permissions (grants, authority, disclosure), credentials, crash recovery, the sandbox and money (holds, charges, settlement): record the file's SHA-256, run the named test red, restore byte-identically, run it green.
- **Measurements** only when your assignment asks for one.
- `t.Parallel()` first in every independent fixture-owning test or row; stay sequential only for `t.Setenv`, `t.Chdir`, other process state or crash children.
- No sleeps, duration or wording assertions, `-short` skips, per-test deadlines, test-only exports or package splits. A test above 60 s under race is allowed only when your yield names it with the row count that explains it (B26 item 8, carried by B28 item 8); never split, skip or deadline a test to get under 60 s. `-count=1` on every run.
- Real store, real files, real Git; fault hooks are unexported seams, nil in production. Never a fake store or a mock.
- Crash rows run in subprocesses of the test binary and are positively waited before reopening.
- Portable: everything builds, vets and passes staticcheck on all five targets; platform-specific code sits behind build constraints with an explicit refusal elsewhere.

## Rules you consume, not only rules you produce
When your code reads another family's records, that family's frozen record rules in `contract/ledger/doc.go` bind you exactly: don't refuse what they allow. Example: a `workspace.scratch_closed` by the owner need not carry the envelope context; only an agent's closure must (doc.go:364-366). Grep the section of every record type you read before writing its check.

## When documents disagree
The ruling wins over the brief, and the frozen contract wins on encodings. A name the brief spells against the ruling's grammar follows the grammar (the v1 operation tokens are `agent_register`, `context_create`, `private_write`); note it in your yield. Ask only when the ruling doesn't settle it.

## Owned paths and rule breaks
- New files inside your owned package directory are yours; name each under `changed`.
- A rule break may need a transient edit outside your owned paths. You may make it: record the file's SHA-256 first, run the named test red, restore, assert the hash, run it green, and list it in the yield.
- Callsite-only migrations in your package's `*_test.go` files for a signature your slice changes are pre-authorized; list each with the reason.

## Machine protocol
Coders may edit independently, but only one local test, fuzz campaign or diagnostic full check runs at a time. The PM queues those local runs; hosted CI uses other machines and may run during review and local work. If your assignment says to wait for "machine free", build, vet, gofmt and run staticcheck meanwhile, but no `go test`, unless a measurement hold reserves all machine work. Otherwise the machine is yours. Run required test commands serially, with `-timeout=19m` (V1), `29m` (race) and `45m` (×20 repetitions) and matching bash timeouts of 1200, 1800 and 2800 s. Race/repetitions remain conditional under D152.

## The `lsp` tool (gopls for Go, basedpyright for Python)
- gopls is rooted at the main checkout, so worktree files have no package metadata until you add your worktree, once per session and again after a revival. Call `lsp` with action `request`, query `workspace/didChangeWorkspaceFolders`, file `C:\Users\darius.jones\Documents\PROJECTS\dwarf-harness\internal\core\agents\service.go`, and payload `{"event":{"added":[{"uri":"file:///C:/Users/darius.jones/worktrees/dwarf-harness/<worktree>","name":"<worktree>"}],"removed":[]}}`. It returns `null`.
- If a call says "No language server found", call action `reload` with no file once, then repeat the request.
- Use `definition`, `references`, `hover` and `diagnostics` instead of re-reading files. Run `diagnostics` on every file you change; under a quiet-machine gate it is your only compiler.

## Evidence and the yield
Logs and throwaway scripts go to your assignment's evidence folder, outside the worktree; delete the scripts at the end and cite them. After your last edit, run the final sequence and edit nothing afterwards; yield each changed file's SHA-256 under `finalHashes`. List under `deletedOrRenamed` every test or row you delete or rename, each with its reason; an approved test is never dropped silently, even in a file you rewrite.

## Questions
Numbered, to `agent://Main`, and keep working meanwhile. Grep the repository and the module cache first; ask a reader only for a survey grep can't do.

## Known Windows traps (from earlier tickets)
- Temporary folders have two names: Windows runners' TEMP is an 8.3 short name and macOS's is under `/var`. Resolve every root you create once with `filepath.EvalSymlinks`.
- On the Windows CI runner the checkout is on `D:` and TEMP on `C:`, so no relative path joins the package folder and a temp folder (`filepath.Rel` fails). For a relative-path test, `t.Chdir` into a temp folder's parent in a sequential test. Reproduce with `subst X: <folder>` and `TMP`/`TEMP` set to `X:\tmp` (CI runs 5 and 6).
- Go's `os.Open` opens read-only files with the backup flag; code that pre-reads what Git will read must open as Git does.
- A raw `CreateProcess` with inherited handles must pass `PROC_THREAD_ATTRIBUTE_HANDLE_LIST`.
- Paths past 260 characters need `\\?\` for raw Windows calls; Git's `cmd.Dir` fails there.
- Tests that time a real native tool can fail under the check's parallel load: never put product deadlines into tests.
