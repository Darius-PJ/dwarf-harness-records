## CODE_READY

Complete bounded S2 source is implemented. **No builds, formatters, lint, tests, fuzz campaigns, measurements, or provider calls were run.** Awaiting explicit compute grant.

LSP diagnostics report no issues in all changed files. Runtime correctness remains unverified.

### Changed paths

All under `C:/Users/darius.jones/worktrees/dwarf-harness/139-registration/internal/core/agents/`:

```text
registration_types.go
registration_commands.go
registration_replay.go
registration_state.go
registration_query.go
registration_service_test.go
registration_replay_test.go
registration_fuzz_test.go
service.go
types.go
scoped_replay.go
replay.go
doc.go
scoped_golden_test.go
integrity.go
paid_fixture_test.go
paid_fuzz_test.go
paid_live.go
paid_read.go
paid_settlement.go
paid_state.go
review_execute.go
review_fuzz_test.go
review_replay_test.go
review_state.go
scoped_submit.go
history_index.go
```

Includes three setters, five queries, three latest-state maps, shared preflight/replay planning, original-request binding, actual committed-receipt readback, Close fencing, frozen-prefix replay, and fuzz seeds.

### Delegated history guard

Only the two authorized changes:

```diff
- g, scoped, review, paid, err := decodeFamily(v.Drafts, e.first)
+ g, scoped, review, paid, _, err := decodeFamily(v.Drafts, e.first)
```

At `putCommand` entry:

```go
if match.registration != nil {
	return
}
```

No changes to cache keys, caps, coverage, or whole-commit invalidation.

Current SHA256, obtained by `Get-FileHash` (exit **0**):

```text
2CF636DA336A1CECD4D5D65C81A97DDAAA8A022C52C9F3D3A075B796A8C6AC3E
```

`TestRegistrationCommitRetryAndClose/concurrent-retry` now exercises original normalized receipt/no second effect after intervening multi-command F0 traffic, followed by changed-input refusal.

### Proposed serial execution

**Working directory:** named worktree above.

**Common environment:**

```text
GOTOOLCHAIN=local
GOFLAGS=
GOROOT=C:/Program Files/Go
GOOS=windows
GOARCH=amd64
CGO_ENABLED=0
```

Executables: pinned `C:/Program Files/Go/bin/go.exe` and `gofmt.exe`.

`$Owned` below means exactly the 27 listed paths, rooted under the absolute agents directory.

| Order | Exact command/arguments | Tool timeout |
|---|---|---:|
| 1 | `gofmt.exe -w $Owned` | 120s |
| 2 | `gofmt.exe -l $Owned` | 120s |
| 3 | `go.exe test -v -count=1 -timeout=19m -run '^(TestRegistration.*|TestHistoryIndexCommandOccurrences|FuzzRegistrationGroupReplay|FuzzScopedGroupReplay|FuzzReviewGroupReplay|FuzzPaidGroupReplay|FuzzPrivateGroupReplay)$' ./internal/core/agents` | 1200s |
| 4 | Authorized rule-break red/restored-green commands below | 1200s each |
| 5 | `go.exe test -v -count=1 -timeout=19m ./internal/core/agents` | 1200s |
| 6 | `go.exe vet ./internal/core/agents` | 600s |
| 7 | `go.exe tool staticcheck ./internal/core/agents` | 600s |
| 8 | `go.exe test -race -v -count=1 -timeout=29m ./internal/core/agents` | 1800s |
| 9 | `go.exe test -race -v -count=20 -timeout=45m -run '^(TestRegistrationVersionCAS|TestRegistrationCommitRetryAndClose|TestHistoryIndexLookupRace)$/^(resource|work_domain|declaration|concurrent-retry|close-fence|duplicate|revocation|replacement)$' ./internal/core/agents` | 2800s |
| 10 | `go.exe list -f '{{join .Imports "\n"}}' ./internal/core/agents` | 300s |
| 11 | `go.exe list -f '{{join .TestImports "\n"}}' ./internal/core/agents` | 300s |
| 12 | `go.exe mod tidy -diff` | 600s |
| 13 | `go.exe mod verify` | 600s |
| 14 | `Get-FileHash -Algorithm SHA256 -LiteralPath $Owned` | 120s |

For **steps 8–9 only**:

```text
CGO_ENABLED=1
CC=C:/Users/darius.jones/AppData/Local/Programs/llvm-mingw-20260922-ucrt-x86_64/bin/x86_64-w64-mingw32-clang.exe
```

Real consumer coverage resides in the agents integration tests using actual ledgerstore/readers and frozen goldens. No external agents-package importers were found.

### Proposed rule breaks

Each runs individually: capture original bytes/SHA256 → temporary mutation → expected red → byte-identical restoration/hash equality → same command green.

1. **Owner entrance:** remove `executeRegistration`’s initial non-owner refusal in `registration_commands.go`.
   ```text
   go.exe test -v -count=1 -timeout=19m -run '^TestRegistrationAuthorityAndIdentity$' ./internal/core/agents
   ```
   Expected red: non-owner registration is admitted.

2. **Original request binding:** remove the original command-ID/digest/submission comparisons from `preflightRegistration`, retaining family and transition validation.
   ```text
   go.exe test -v -count=1 -timeout=19m -run '^TestRegistrationOriginalRequestPreflight$' ./internal/core/agents
   ```
   Expected red: self-consistent changed request reaches publication instead of preflight refusal.

3. **Installation before acknowledgment:** omit the post-Submit `refreshLocked` call in `executeRegistration`, retaining actual receipt readback.
   ```text
   go.exe test -v -count=1 -timeout=19m -run '^TestRegistrationInstalledBeforeAck$' ./internal/core/agents
   ```
   Expected red: acknowledgment-time status cannot answer from installed state. The test temporarily makes log rereading impossible, preventing query refresh from masking the missing installation.

### Exact new test targets

```text
TestRegistrationAuthorityAndIdentity
TestRegistrationLimitsAndRetry
TestRegistrationNormalizationAndSize
TestRegistrationVersionCAS
TestRegistrationCommitRetryAndClose
TestRegistrationDeclarationHistory
TestRegistrationGrantsRemainIndependent
TestRegistrationFrozenGoldenReplay
TestRegistrationOriginalRequestPreflight
TestRegistrationGroupRules
TestRegistrationReviewTerminalConsumer
TestRegistrationUnsupportedVersion
TestRegistrationPostcommitReadbackFailure
TestRegistrationInstalledBeforeAck
FuzzRegistrationGroupReplay
```

PM-owned timed targets: `FuzzRegistrationGroupReplay`, `FuzzScopedGroupReplay`, `FuzzReviewGroupReplay`, `FuzzPaidGroupReplay`. Private remains normal seeds only.

No dependencies, frozen-contract files, existing assertions, Git state, main, or private records were changed. No unresolved source-scope questions. Formatting and all execution evidence remain pending the grant.