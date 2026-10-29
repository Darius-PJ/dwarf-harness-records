**SOURCE_READY** — only `C:/Users/darius.jones/worktrees/dwarf-harness/139-acceptance/internal/core/agents/registration_crash_test.go` changed.

- **29:** `Digest ledger.Digest` → `Digest string`
- **113–119:** preserved JSON/boundary checks; added:
  ```go
  digest, err := ledger.ParseDigest(signal.Digest)
  if err != nil || digest == (ledger.Digest{}) {
      t.Fatalf("invalid child command digest %q: %v", signal.Digest, err)
  }
  ```
- **184:** lookup uses parsed `digest`.
- **299:** child assigns `SubmissionSHA256.String()`.

All four rows and other assertions remain untouched.

**Executions:** native/Go/parser/formatter/mutant **0**. LSP references failed with missing package metadata; scoped text references checked, no workspace setup changed.

Parent owns the single-source checksum and private rebinding. Parked.