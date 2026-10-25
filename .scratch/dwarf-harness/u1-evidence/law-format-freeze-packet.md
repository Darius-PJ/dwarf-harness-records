# OG4: freeze request for `law-format`

**Prepared:** 2026-10-12, against commit 35ca559 on branch `build/04-freeze`, which is `main` at b663791 plus one sentence of package documentation; `main` reaches 35ca559 by fast-forward with the commit that records this request. For U1.L and ticket 04. **Answer:** 2026-10-12, "Freeze as presented". [D114](../../../docs/DECISIONS.md#d114-law-format-frozen-at-version-1) records the freeze, adapted from §8 to your answer, and Appendix A.2's edits record it in the register and the roadmaps. The rest of this packet stays as sent.

Ticket 04 has built U1.L's `law-format` contract, the package `contract/law`, and [B22](../../../docs/DECISIONS.md#b22-u1l-law-format-version-1-the-validation-policy-and-their-identities) records its design (DEC:1539). Under your D40 the owner freezes a contract, and other roadmaps build against it only once it is frozen (DEC:206). This packet asks you to freeze it. Ticket 04 closes with the request sent, as C1 closed with OG2 (RULING:36; DEC:1469); it does not wait for your answer. U1.L is Done only when you freeze the format (RU:215), and C4 waits for that freeze as well as for C3 (RC:537). Take the time you need.

**In short.** You are asked to freeze version 1 of `law-format` (§1). It has two artifacts: the shared field law, a strict JSON file with six field kinds and 22 built-in source rules, and the local validation policy, which carries your D47 values as exact fractions. It also fixes two size profiles for reading them, the order and codes of refusals, and identity as the SHA-256 of a file's exact bytes (§3). Freezing makes U1.L Done and lets C4 build on the format once C3 is Done. Afterwards the format changes only by addition, which for this strict format means new versions read beside version 1 (§2). The freeze chooses no law values and activates nothing (§2.4). Nine questions show what it fixes, each with our recommendation, and a tenth notes that the golden values are test data (§6). All nine fold into one answer, "Freeze as presented", which we recommend (§7).

Citations are `file:line` at `main` b663791; "RU:187, :217" means lines 187 and 217 of the same file. The package documentation is cited by section, as in "DOC, Parser limits", as it stands at 35ca559; Appendix B reproduces it.

| Short | File |
|---|---|
| DOC | `contract/law/doc.go`, the package documentation |
| DEC | `docs/DECISIONS.md` |
| CON | `docs/CONTRACTS.md` |
| RU | `docs/ROADMAP-UNDERCURRENT.md` |
| RM | `docs/ROADMAPS.md` |
| RC | `docs/ROADMAP-CORE.md` |
| UC | `docs/DESIGN-UNDERCURRENT.md` |
| CORE | `docs/DESIGN-CORE-AND-LAUNCHERS.md` |
| RAV | `docs/RESEARCH-ADMISSIBLE-VALIDATION.md` |
| SPEC | `.scratch/dwarf-harness/spec.md` |
| T04 | `.scratch/dwarf-harness/issues/04-load-and-identify-a-strict-law-independently-of-field-execution.md` |
| BRIEF | `.scratch/dwarf-harness/u1-evidence/ticket-04-design-brief.md` |
| RULING | `.scratch/dwarf-harness/u1-evidence/ticket-04-design-ruling.md` |
| AGENTS | `AGENTS.md` |

**[INFERENCE]** marks our reading where no line says it outright.

## 1. What is requested

Freeze `law-format` at commit 35ca559, as **Version 1** with status **Frozen** (CON:19, :30). 35ca559 is not on `main` yet. It is `main` at b663791 plus one sentence in the package documentation, on branch `build/04-freeze`, and `main` reaches it by fast-forward with the commit that records this request (Appendix A.1).

Version 1 is everything the package `contract/law` defines:

- **the field law:** format `dwarf-harness/undercurrent-law`, schema version 1, evaluator version 1 and kernel `bounded_best_arrival/v1`, with the evaluator-v1 registry of six kinds, 22 rules, four coupling profiles and three edge types (B22 item 2, DEC:1552–1557);
- **the validation policy:** format `dwarf-harness/validation-policy`, schema version 1, holding D47's flake-rate prior, failure/repair confidence and quarantine threshold as exact fractions (B22 item 6, DEC:1571–1573);
- **two parser profiles,** `compact-v1` and `standard-v1`, with their counting rules (DEC:1558–1561);
- **refusal:** four phases in a fixed order, five kinds of error and their codes (DEC:1562–1567);
- **identity:** the SHA-256 of each accepted artifact's exact bytes (DEC:1568–1570);
- **exclusions:** what neither artifact may carry (DEC:1574–1577);
- **the Go API** that loads them, and **the golden vectors** (§3, §4).

`contract/law` at 35ca559 is S1 (6f82da1), its documentation fix 9bba28f, and 35ca559's sentence on empty edge lists (Q2). Ticket 04's comments record the build, the review and the merge (T04:69, :71).

Section 8 holds a draft decision entry, and Appendix A the edits that record the request and the freeze. None of them is applied before your answer, except Appendix A.1, which records that the request was sent.

## 2. What freezing means

### 2.1 It permits

- **U1.L to be Done.** U1's exit criterion asks that "U1.L passes C1-frozen golden vectors" for its format, identity, profiles and rejections (RU:215); "C1-frozen" names the D40 freeze process (BRIEF:1304). U1 itself stays In progress, because U1.E, the field engine, has not started (RU:217).
- **C4 to build on the format once C3 is Done.** C4 waits for "C3 Done, U1.L Done, and the owner-frozen `law-format` contract (D47); it does not wait for U1.E" (RC:537; RM:172; DEC:309). Its other waits-for item, your D52 approval, is given (DEC:1535). C4 then reads your validation parameters from the policy artifact and "may not define duplicate values" (RC:539).
- **U1.E to build against the format.** U1.L comes before U1.E (RM:187). U1.E still uses synthetic ledgers until the producer contracts it reads are frozen (RU:172).
- **U5's typed-transform work** gains one of its three prerequisites; it still needs R1 and U3's graph foundation (RU:380).

The ticket asked for "Owner law-format freeze before any C4/U1.E consumer starts" (T04:23), and every roadmap says to build only against frozen contracts (RU:24; RM:233).

### 2.2 What stays changeable

A frozen contract "changes only by addition" (DEC:206). The register spells additions out as "new optional fields, new types, new type versions with upgraders" (CON:16). For this format:

- **New versions beside version 1.** Version 1 refuses unknown members, so it never gains optional members. Additions come as new schema or evaluator versions read beside it, and a new kind, rule or kernel needs a new evaluator version (DOC, Compatibility and non-goals). No upgrader converts an old artifact to new semantics, because "newer versions must continue to decode old versions or fail clearly, never reinterpret them" (UC:460). Q2 asks you to confirm this narrower reading of "addition".
- **New exported names that change no loader behaviour,** such as constants for the error codes; an encoder could be added by addition but would never define identity (B12) (RULING:19, :29).
- **What the documentation does not promise:** `Error()` wording and diagnostic offsets (in this version a BOM's offset is 0 and the size limit's is its maximum), and which of several violations within one phase is reported (DOC, Refusal phases and errors; Q6).
- **The golden values' role:** they are test data, not your law (Q10).

### 2.3 What changes only with your decision entry

Every rule of version 1: the members and their ranges, the registry, the profiles and counting rules, the phases and phase 1's rules, the error types, codes and paths, the identity rule, the exclusions, and the behaviour of every exported name. "Later contract versions must preserve the exact typed values and digests of these version-1 golden vectors and the evaluator semantics they identify" (DOC, Compatibility and non-goals). A breaking change needs your decision entry listing every step it affects, and the golden tests catch one made without it (DEC:206; CON:17).

### 2.4 What the freeze does not do or claim

- **No law values are chosen.** The numbers in the golden files are preregistration candidates and the validation research's provisional values: test data (DEC:1594; UC:452; RAV:394). You approve an exact law and validation policy later, and Core activates them (D65, DEC:464; UC:464).
- **Nothing is activated, approved or scheduled.** "Loading does not execute a reducer, activate, approve, schedule, authorize, retain or retrieve anything" (DOC, Compatibility and non-goals).
- **No engine, Core or C4 work.** Core's activation manifest and its retention of artifact bytes remain C2's work, and C4's use of the parameters remains C4's (DEC:1625).
- **No per-incident execution cap.** Following your OG-B answer, the policy holds three values; the cap "needs its own decision before C4 relies on it" (DEC:1573, :1627).
- **One platform.** Verified on Windows on this machine; Linux and macOS are compiled only, by the check's cross builds (DEC:1628).
- **No capacity claim** beyond V8's measurement on one machine (§5.5).

## 3. The frozen surface

The package documentation states the format: "This documentation is the format" (DOC, opening). Its sections, and what each fixes:

| DOC section | What it fixes | B22 | Questions |
|---|---|---|---|
| Field-law version 1 | One strict UTF-8 JSON object without a BOM; every member required, no other member allowed, no defaults, member order free. The root, kind, source and coupling members with their types and ranges. Kinds, sources and edge types strictly ascending. The six kind/unit pairs | item 2 | Q1, Q7, Q8 |
| Evaluator-v1 registry | 22 rules, each with its kind, mode and profile; four profiles, each fixing a direction and the whole edge list; three edge types; no `validation_f1_unconfirmed/v1`; R1's `router-headroom/v1` scheme distinct from the `router_headroom/v1` rule | item 2 | Q1 |
| Validation-policy version 1 | A separate local artifact: format, schema 1 and exactly three fractions; terms from 1 to 18,446,744,073,709,551,615 (`uint64`), numerator below denominator, not reduced; no label, policy ID or fourth parameter | item 6 | Q5 |
| Parser limits | Limits passed by the host: inclusive, positive, never above `standard-v1`; zero is invalid, not a default. The two profiles, how each bound counts, and what a valid artifact needs | item 3 | Q3 |
| Refusal phases and errors | Atomic refusal by pure loaders. Phases 0 to 3 in order; phase 1's checks and their order, kept by every version; phase 2's head checks; phase 3's depth-first order. Five sentinels and their error types; the bound, problem and violation codes; RFC 6901 paths; what is and is not promised | item 4 | Q2, Q6, Q7, Q9 |
| Identity, local binding and exclusions | SHA-256 of the exact content bytes, as the package's own `Digest`. `Law.SHA256` is Core's `field_law_sha256`, and `ValidationPolicy.SHA256` its `validation_policy_hash`; a consumer checks them before use. Neither artifact may carry Core's activation data, grants, credentials or its own hash; the law also refuses D47's values and `validation_policy_hash` | items 5, 7 | Q4 |
| Compatibility and non-goals | Only version-1 heads are read; any other is unsupported, never reinterpreted. Version 1 is closed; additions are new versions beside it; the goldens' typed values and digests are preserved; no upgrader. An empty edge list loads as an empty, non-nil slice. Loading activates nothing; there is no encoder or engine | item 8 | Q2, Q10 |

**The Go API** (DEC:1547–1551, :1557):

- `Load(data []byte, limits LoadLimits) (Law, error)` and `LoadValidationPolicy(data []byte, limits LoadLimits) (ValidationPolicy, error)`;
- `LoadLimits`, with `Bytes`, `Depth`, `Members`, `Elements`, `StringBytes` and `Tokens`, and the profiles `CompactV1()` and `StandardV1()`, which return fresh values;
- the results `Law`, `KindLaw`, `SourceLaw`, `Coupling`, `ValidationPolicy`, `Rational` and `Digest`, with `Digest.String`; their numeric fields keep Undercurrent §13.2's types;
- the format constants `LawFormat` and `PolicyFormat`; the vocabulary types `Kind`, `QuantityClass`, `Unit`, `Mode`, `RuleID`, `AgeRule`, `Profile`, `Direction`, `EdgeType` and `Kernel`, with a constant for every closed value, the 22 rule IDs included;
- the sentinels `ErrInvalidLimits`, `ErrLimit`, `ErrMalformed`, `ErrUnsupported` and `ErrInvalid`; the error types `LimitError`, `MalformedError`, `UnsupportedError` and `FieldError`; and the code types `Bound`, `Problem` and `Violation`.

The documentation's opening says "Version 1 is a draft until the owner's freeze (D40)". It stays as written, as `contract/ledger`'s did after your freeze of D111 (Appendix A.4).

## 4. Golden vectors

Ten files under `contract/law/testdata/`, written by hand without an encoder and pinned by SHA-256 in `golden_test.go` (DEC:1581–1582); `TestGoldenFilesPinned` fails on a changed, unrecorded or missing file (`contract/law/golden_test.go:60`). An eleventh vector is derived inside the test: `full.json` with each LF replaced by CRLF, because B1 stores text files with LF (DEC:231; RULING:27). Its digest is pinned as well, computed outside the loader (`contract/law/golden_test.go:29–30`), and V7 recomputes it.

Sizes and SHA-256 digests, computed from the committed files at 35ca559:

| File (relative to `contract/law/testdata/`) | What it holds | Bytes | SHA-256 |
|---|---|---|---|
| `law/v1/full.json` | every registered rule, with Undercurrent §13.4's candidate values | 11,266 | `3b148a28c5cd88445c3cd43b53e25cb99b8e9009e57ab7416e7293469134895c` |
| `law/v1/full-compact.json` | full.json compacted, with no final newline | 6,877 | `f1382c84a68f79ea258040f160fdd4d8a55decf4bed93d3a20eb861c81965583` |
| `law/v1/full-reordered.json` | full.json with every object's members reversed | 11,266 | `3617c086c1cd5d2479175cbdbeb6d6fbcec0a48ca7333cae86fea730ec49b7a4` |
| (derived in the test) | full.json with each LF replaced by CRLF | 11,661 | `83cad664b5eb46a5ef8453f4d57cfce5c9023d24bd54e8d9a463c0f2b6eaf9bf` |
| `law/v1/minimal.json` | one source per kind; every range at its minimum | 4,257 | `b6341867c260f09f666ead95102d405ad67ed2e7f38595a5c254a9fd68daf280` |
| `law/v1/bounds.json` | every range at its maximum; a 64-byte law_id | 4,711 | `be2d34fa8e9c7fd58a133c1c9768cef4947988559ab65049fc8516b3ddb3fc43` |
| `law/unsupported/schema-version-2.json` | schema_version 2 and an extra member; refused as unsupported | 11,292 | `fa30e702051ef0695ca0501c55965a3b2beea32a9cafb6adf846d31f748232a6` |
| `law/unsupported/evaluator-version-2.json` | evaluator_version 2; refused as unsupported | 11,266 | `ecc378673dd0830be3841023cfcc47560003165a1b6bbc8b7a6cd6354eca0337` |
| `law/unsupported/kernel-v2.json` | kernel bounded_best_arrival/v2; refused as unsupported | 11,266 | `ba5d5a61a8b0ca6b65aac1943294c4d63bc5bca866ebc97b75471d52766a6450` |
| `validation-policy/v1/policy.json` | 1/20, 999/1000 and 1/5 | 302 | `1f3c66a9eca49f82e0e224c8f7a5edaee890757b6281a035f2e9a1f543f4f447` |
| `validation-policy/unsupported/schema-version-2.json` | schema_version 2 and an extra member; refused as unsupported | 328 | `5f95d48c1dc8ac933d79d156e289e8ee0931e887d28f1e1dd2ba90e1a739402a` |

What the set shows:

- `full.json` and its compact, reordered and CRLF forms load to the same law with four different digests: whitespace, key order and line endings change identity, never meaning (Q4).
- `minimal.json` and `bounds.json` put every range at its minimum and at its maximum; both load.
- The three law files and the policy file under `unsupported/` carry a newer head, and each is refused as unsupported, even when it carries a member that version 1 does not know (Q2).
- `policy.json` holds the validation research's provisional V1 values, 1/20, 999/1000 and 1/5 (Q10).

## 5. Evidence

The results in §5.2 come from one runner run in a separate worktree of 35ca559, with the commands of §5.3.

### 5.1 What each check shows

| | Check | What it shows | Expected |
|---|---|---|---|
| V1 | Every test of the package, with `CGO_ENABLED=0` | Every test, example and fuzz seed passes, and every refusal case runs under both profiles (DEC:1596) | Exit 0; as many `--- PASS` lines as `=== RUN` lines; no `--- FAIL` (595 at 62e2c6b, DEC:1612) |
| V2 | `FuzzLoad` and `FuzzLoadValidationPolicy`, 120 s each | No input breaks a loader: every refusal returns the zero value and one error family, every acceptance carries its exact-byte digest, and the two profiles agree | Both pass; no new file under `testdata` |
| V3 | `go run ./tools/check`, with `DWARF_CC` set | All nine check steps, including the race tests, the import boundaries and the Linux and macOS cross builds | All nine pass |
| V4 | `go list -deps` | `contract/law` imports nothing outside the standard library: no engine, no `internal/` package, not even `contract/ledger`. This is the audit of law format against engine (SPEC:625) | One line: the package itself |
| V5 | `go mod tidy`, `go mod verify`, `gofmt -l` | No dependency is added (D29), and the code is formatted | `go.mod` and `go.sum` unchanged; all modules verified; no file listed |
| V6 | `git ls-files --eol` | The files are stored with LF line endings (B1) | `i/lf w/lf` for every file; `i/none w/none` for `full-compact.json`, which has no line ending |
| V7 | `Get-FileHash` over the golden files, and over `full.json` with CRLF | The files match their pinned digests, and the CRLF digest is recomputed outside the loader | The ten digests of §4; `83cad664…f9bf` for the CRLF form |
| V8 | `BenchmarkLoad`, five runs | What a load of the largest version-1 law, and of an input of the maximum size, costs (§5.5) | A measurement, not a threshold |

### 5.2 Results at 35ca559

| | Result |
|---|---|
| V1 | `go test -count=1 -v ./contract/law`: exit 0; 595 `=== RUN`, 595 `--- PASS`, 0 `--- FAIL`; `ok … contract/law 1.369s` (35ca559, 2026-10-12) |
| V2 | `FuzzLoad` 120 s: PASS, 366,367 execs; `FuzzLoadValidationPolicy` 120 s: PASS, 1,675,496 execs; `git status --porcelain -- contract/law/testdata` empty (35ca559, 2026-10-12) |
| V3 | `go run ./tools/check` with `DWARF_CC`: all nine steps pass (toolchain, gofmt, vet, staticcheck, govulncheck, import boundary, tests, race, cross builds); exit 0 (35ca559, 2026-10-12) |
| V4 | `go list -deps` non-standard imports: only `github.com/Darius-PJ/dwarf-harness/contract/law` (35ca559, 2026-10-12) |
| V5 | `go mod tidy` left `go.mod` and `go.sum` unchanged; `go mod verify`: all modules verified; `gofmt -l contract/law`: no output (35ca559, 2026-10-12) |
| V6 | `git ls-files --eol -- contract/law`: 26 files, all `i/lf w/lf` except `testdata/law/v1/full-compact.json` (`i/none w/none`) (35ca559, 2026-10-12) |
| V7 | `Get-FileHash` of the ten testdata files equals the ten pinned digests of §4; the derived CRLF vector recomputes to `83cad664b5eb46a5ef8453f4d57cfce5c9023d24bd54e8d9a463c0f2b6eaf9bf` (35ca559, 2026-10-12) |
| V8 | Measurement, no pass mark. `BenchmarkLoad`, `-count 5`, Intel Core i7-10610U @ 1.80 GHz, windows/amd64: `full` 225,812–259,979 ns/op, 176,489–176,492 B/op, 1,734 allocs/op; `standard-max` 1,330,165–1,404,458 ns/op, 1,216,877–1,216,878 B/op, 1,741 allocs/op (35ca559, 2026-10-12) |

### 5.3 The runner's commands

Windows PowerShell. Each block says what to report.

Setup, from the repository root: a detached worktree of the freeze commit, outside the working tree and the vault.

```powershell
git worktree add --detach "$env:TEMP\dh-law-freeze" 35ca559
Set-Location "$env:TEMP\dh-law-freeze"
$env:GOTOOLCHAIN = 'local'
$env:GOFLAGS = ''
$out = Join-Path $env:TEMP 'law-freeze-out'
New-Item -ItemType Directory -Force $out | Out-Null
go version
git rev-parse HEAD
```

Report the Go version (expected `go1.27.2 windows/amd64`) and the full hash (expected `35ca5593a3d072166fe38c944fe806086db0e4b2`).

V1:

```powershell
$env:CGO_ENABLED = '0'
go test -count=1 -v ./contract/law > "$out\v1.txt"; "exit $LASTEXITCODE"
(Select-String -Path "$out\v1.txt" -Pattern '^=== RUN').Count
(Select-String -Path "$out\v1.txt" -Pattern '^\s*--- PASS').Count
(Select-String -Path "$out\v1.txt" -Pattern '^\s*--- FAIL').Count
Select-String -Path "$out\v1.txt" -Pattern '^(ok|FAIL)\s'
```

Report the exit code, the three counts and the final `ok` or `FAIL` line.

V2:

```powershell
go test ./contract/law -run '^$' -fuzz '^FuzzLoad$' -fuzztime 120s
go test ./contract/law -run '^$' -fuzz '^FuzzLoadValidationPolicy$' -fuzztime 120s
git status --porcelain -- contract/law/testdata
```

Report, for each target, PASS or FAIL and the execution count of its last progress line, and the status output, which should be empty.

V3:

```powershell
Remove-Item Env:CGO_ENABLED
$env:DWARF_CC = 'C:/Users/darius.jones/AppData/Local/Programs/llvm-mingw-20260922-ucrt-x86_64/bin/x86_64-w64-mingw32-clang.exe'
go run ./tools/check; "exit $LASTEXITCODE"
```

Report each step's result and the exit code.

V4:

```powershell
go list -deps -f '{{if not .Standard}}{{.ImportPath}}{{end}}' ./contract/law
```

Expected: exactly one line, `github.com/Darius-PJ/dwarf-harness/contract/law`.

V5:

```powershell
go mod tidy
git diff --exit-code -- go.mod go.sum; "exit $LASTEXITCODE"
go mod verify
gofmt -l contract/law
```

Expected: exit 0, `all modules verified`, and no output from `gofmt`.

V6:

```powershell
git ls-files --eol -- contract/law
```

Expected: `i/lf w/lf` on every line except `contract/law/testdata/law/v1/full-compact.json`, which shows `i/none w/none`.

V7, in this pipeline form:

```powershell
Get-ChildItem -Recurse -File contract/law/testdata/law, contract/law/testdata/validation-policy | Get-FileHash -Algorithm SHA256 | Format-List Path,Hash
Get-ChildItem -Recurse -File contract/law/testdata/law, contract/law/testdata/validation-policy | Format-Table Length,FullName -AutoSize
powershell -NoProfile -Command 'Get-FileHash -Algorithm SHA256 -InputStream ([IO.MemoryStream]::new([Text.Encoding]::UTF8.GetBytes([IO.File]::ReadAllText((Resolve-Path contract/law/testdata/law/v1/full.json)).Replace("`n", "`r`n")))) | Format-List Hash'
```

Expected: exactly ten files, whose hashes, in lower case, are B22 item 9's digests (DEC:1583–1592), and, from the third command, `83CAD664B5EB46A5EF8453F4D57CFCE5C9023D24BD54E8D9A463C0F2B6EAF9BF`.

V8:

```powershell
$env:CGO_ENABLED = '0'
go test ./contract/law -run '^$' -bench '^BenchmarkLoad$' -benchmem -count 5
```

Report the `goos`, `goarch` and `cpu` lines, and each run's ns/op, MB/s, B/op and allocs/op for `full` and `standard-max`.

Appendix B:

```powershell
go doc -all ./contract/law
```

Report the whole output, verbatim.

Cleanup:

```powershell
Set-Location C:/Users/darius.jones/Documents/PROJECTS/dwarf-harness
git worktree remove --force "$env:TEMP\dh-law-freeze"
Remove-Item -Recurse -Force "$env:TEMP\law-freeze-out"
```

### 5.4 Platform status and limits

- **Verified on Windows on this machine,** an Intel Core i7-10610U, with go1.27.2 (DEC:1620).
- **Linux and macOS** are compiled and import-checked by the check's cross builds only (DEC:1628). The package has no cgo, no OS-specific file and no `unsafe` (BRIEF:130).
- **Not repeated:** B22's planted-import test, in which an import of `internal/core/durable` placed in `contract/law` failed the check's import-boundary step on all five build targets (DEC:1618). V3 runs that step on the code being frozen.

### 5.5 Load cost (D78)

D78 asks for capacity reasoning and a measurement plan before an affected boundary is frozen, with assumptions, calculations and measurements kept apart (DEC:569; CON:104; RM:234; RC:17).

- **Assumption.** An artifact is loaded when you approve it, when Core activates it and when a consumer starts, and C4 may load the policy for each validation attempt (DEC:1621). These rates are assumed, not known.
- **Calculation.** A load reads no more than the host's limits allow, at most 262,144 bytes and 8,192 tokens. A valid version-1 law needs at most 681 tokens, about 8% of that bound, and a policy needs 27 (DOC, Parser limits). The loaders are pure and keep no state (DOC, Refusal phases and errors), so a load's cost depends only on its input, never on the colony's size or history.
- **Measurement.** V8 (§5.2). B22's run at 62e2c6b measured 226–255 µs and about 176 kB per load of `full.json`, and 1.41–1.51 ms and about 1.22 MB per load of `full.json` padded with spaces to 262,144 bytes (DEC:1620).
- **Calculation from the measurement.** Even if C4 loaded the policy for every attempt, each load would cost at most about V8's figure for the padded input on this machine. Whether that matters depends on C4's attempt rate, which C4 measures.
- **Plan.** C2 and C4 measure their actual load rates and costs at their own gates (DEC:1621).
- **What the freeze fixes.** The profiles' bounds and their counting rules: an artifact larger than `standard-v1` admits would need your decision entry (Q3).
- **Not claimed:** no budget, threshold or pass mark, and no capacity beyond one machine's measurement.

## 6. Questions

Each question says what the freeze fixes and gives our recommendation. Q1–Q8 are the design brief's questions 1–8 for this request (BRIEF:1268–1275); the build advisor narrowed Q6 to the order of violations (RULING:25) and added phase 1 to Q2 (RULING:26). Q9 takes the error codes out of the brief's question 6, and Q10 is its question 9. Every recommendation is to freeze what was built, so all fold into one answer, "Freeze as presented" (§7). Any other answer to a question changes the documentation or the code first: choose "Freeze with changes" and name the question.

### Q1. The version-1 field law and the evaluator-v1 registry

**What is frozen.** The field law's members and ranges, and the registry: six kinds, each with its unit; 22 rules, each with a fixed kind, mode and profile; four profiles, each fixing a direction and the whole edge list; three edge types (DOC, Field-law version 1 and Evaluator-v1 registry; DEC:1553–1555). A law may omit rules, but each kind keeps at least one source. `law_id` and `law_version` are labels, never identity. There is no amplitude member: capping amplitudes at saturation is the engine's job, and Undercurrent §9's amplitudes are provisional (RULING:21).

**What it means later.** The version-1 tables never change. A new kind, rule, profile, edge type or kernel needs a new evaluator version read beside version 1 (DOC, Compatibility and non-goals; UC:460).

| Option | Consequence |
|---|---|
| a. Freeze as built | The tables become permanent for version 1 |
| b. Change a member, range or registry row first | A follow-up change edits the package and its goldens; the freeze is recorded at its commit |

**Recommendation: a.** The schema and registry are Undercurrent §13.4's (DEC:1555; UC:433–450).

**Folds into "Freeze as presented":** yes.

### Q2. How a strict format grows

**The rule you set.** "A frozen contract changes only by addition" (D40, DEC:206). The register lists the additions as "new optional fields, new types, new type versions with upgraders" (CON:16).

**How this format adds.** Version 1 refuses unknown members, so it can never gain an optional member. Additions come only as new schema or evaluator versions, read beside version 1, which a host that does not know them refuses as unsupported. A later contract version must load every version-1 golden to the same typed value and digest, and no upgrader converts an old artifact to new semantics (DOC, Compatibility and non-goals; DEC:1580), because Undercurrent §13.4 requires that newer versions "continue to decode old versions or fail clearly, never reinterpret them" (UC:460).

**Phase 1 belongs to the whole format family.** Phase 1 checks the size bound, a BOM and UTF-8, then each token in turn for syntax, the token, depth, member, element and string-size bounds, keys repeated after decoding and unsigned-integer spelling, then anything after the root value. These rules hold for every schema and evaluator version: no version relaxes them or reorders the phases (DOC, Refusal phases and errors; DEC:1566). Phase 1 runs before the version check, so if a later version relaxed one of these rules, older hosts would refuse its artifacts as malformed instead of unsupported; keeping phase 1 fixed keeps that answer clear (RULING:26; DEC:1605).

**A note on representation.** Rules with the `local/v1` profile have an empty edge list. The loaded value holds it as an empty, non-nil slice, `[]EdgeType{}`, and consumers test `len(EdgeTypes) == 0`. The documentation says so since 35ca559 (DOC, Compatibility and non-goals), and the golden tests pin it, since their comparison tells an empty slice from a nil one (`contract/law/golden_test.go:97`). Freezing the goldens' "exact typed values" freezes this choice too.

| Option | Consequence |
|---|---|
| a. Freeze as presented | Additions are new versions beside version 1, with no optional members and no upgraders; phase 1 is fixed for good; empty edge lists stay non-nil |
| b. Allow optional members within version 1 | A host that knows a new member would accept an artifact that an older host refuses as `unknown_field`, under the same version number **[INFERENCE]**; the unknown-member rule changes before the freeze |
| c. Let later versions relax phase 1 | Their artifacts would reach older hosts as malformed, not as unsupported |
| d. Hold empty edge lists as nil | A code change and new expected test values before the freeze; consumers that test `len` see no difference |

**Recommendation: a.** It is the reading under which every host either reads an artifact exactly or refuses it as unsupported (UC:460), and it still allows every kind of growth §13.4 foresees, through new versions.

**Folds into "Freeze as presented":** yes.

### Q3. The two profiles and how they count

**What is frozen.** The host passes the limits; neither artifact supplies them. Every bound is inclusive. A host may tighten any field but never go above `standard-v1`, and zero is invalid, not a default (DOC, Parser limits; RULING:22).

| Bound | `compact-v1` | `standard-v1` |
|---|---:|---:|
| Bytes | 65,536 | 262,144 |
| Depth | 12 | 16 |
| Members | 64 | 128 |
| Elements | 128 | 256 |
| StringBytes | 128 | 256 |
| Tokens | 2,048 | 8,192 |

How they count (DOC, Parser limits):

- `Bytes` counts the whole input.
- The root container is depth 1, and each nested object or array adds one.
- `Members` counts an object's name/value pairs, **a repeated key included**; `Elements` counts an array's values.
- `StringBytes` counts a string's decoded UTF-8 bytes, keys included.
- `Tokens` counts every value that Go's `json.Decoder.Token` returns, keys and brackets included, but not commas, colons or whitespace.

What a valid artifact needs: a version-1 law at most depth 7, 8 members, 6 elements, 64-byte strings and 681 tokens, so only its byte size, through whitespace or escaped spellings, can exceed `compact-v1`; a policy needs depth 2, 5 members, 31-byte strings and 27 tokens (DOC, Parser limits).

**What it means later.** Changing a bound or a counting rule changes what older hosts accept, so it needs your decision entry (BRIEF:1270). So would a future law larger than `standard-v1` allows.

| Option | Consequence |
|---|---|
| a. Freeze as presented | Every host accepts the same artifacts under the same profile; a version-1 law uses at most 8% of `standard-v1`'s token bound |
| b. Change a value or a counting rule first | A follow-up change; the freeze is recorded at its commit |

**Recommendation: a.** The values are Undercurrent §13.4's (UC:454), and the counting rules are the ones the tests pin (RULING:23). "`standard-v1` is the initial default" (UC:454) is the host's choice, which Core makes explicitly with `StandardV1()` (RULING:22).

**Folds into "Freeze as presented":** yes.

### Q4. Identity

**What is frozen.** An accepted artifact's identity is the SHA-256 of its content bytes exactly as given: not Git's object ID, with no `blob <size>` header, and with nothing normalized, whether whitespace, line endings, key order, escapes or fraction terms. Only an accepted artifact has an identity, and neither artifact may contain a hash of itself. The caller supplies the immutable blob bytes, not a converted checkout (DOC, Identity, local binding and exclusions; DEC:1569). The digest type is the package's own `Digest`, written as 64 lowercase hex digits like `ledger.Digest`, so that `law-format` is frozen and delivered without depending on `ledger-format` (RULING:16; UC:462).

**What it means later.** Any byte change makes a new artifact, which needs a new approval and activation (UC:456). The goldens show four digests for one law (§4).

| Option | Consequence |
|---|---|
| a. Freeze as presented | Identity never depends on re-encoding (B12, DEC:740) |
| b. Reuse `ledger.Digest` | `contract/law` would import `contract/ledger`, tying two frozen contracts together; a code change first |
| c. Hash the decoded values instead of the bytes | Needs the canonical serialization that B12 rules out (DEC:740) |

**Recommendation: a.**

**Folds into "Freeze as presented":** yes.

### Q5. The validation-policy artifact

**What is frozen.** D47's values form a separate local artifact, never members of the shared law: format `dwarf-harness/validation-policy`, schema version 1, and exactly `flake_rate_prior`, `failure_repair_confidence` and `quarantine_threshold`. Each is a `{numerator, denominator}` object of integers from 1 to 18,446,744,073,709,551,615, with the numerator below the denominator. Fractions are not reduced, so 1/20 and 2/40 are different artifacts. There is no label or policy ID: the digest is the identity (DOC, Validation-policy version 1; DEC:1572). Following your OG-B answer, "Three only", a policy that carries `max_fresh_executions_per_incident` is refused (DEC:1573).

**What it means later.** C4 reads these values without the field law or the engine, and only from the bytes Core retains and binds by `validation_policy_hash`, never from a working-tree settings file (DOC, Identity, local binding and exclusions). The per-incident execution cap still needs its own decision before C4 relies on it (DEC:1573); adding it to this artifact would take a new policy schema version, since version 1 never gains members (DOC, Compatibility and non-goals).

| Option | Consequence |
|---|---|
| a. Freeze as presented | Three exact fractions, identified by their bytes |
| b. Reduce fractions to lowest terms, or add a label | A canonical form or a second identity, which B12 avoids (DEC:740); a code change first |

**Recommendation: a.**

**Folds into "Freeze as presented":** yes.

### Q6. The order of violations within a phase

**Already the contract, and not asked here:** error types, codes, paths and the order of the phases (DOC, Refusal phases and errors; Q9).

**The open point.** When an artifact breaks several rules within one phase, the loader reports the first in the documentation's table order, and tests pin that order. The documentation says this order "is not a compatibility promise" and that consumers "must not branch on which of several violations is reported" (DOC, Refusal phases and errors; DEC:1567).

| Option | Consequence |
|---|---|
| a. Do not promise it | A later version may check the rules of a phase in another order without your decision entry; consumers rely on codes and phases only |
| b. Promise it | Any reordering becomes a breaking change needing your decision entry (DEC:206); the documentation's sentence changes before the freeze |

**Recommendation: a.** Promising the order "would make any later reordering a breaking change (D40) for no consumer's benefit; consumers need the codes and the phases" (DEC:1606; RULING:25).

**Folds into "Freeze as presented":** yes.

### Q7. Numbers as unsigned digits

**What is frozen.** Every number in either artifact is written as unsigned decimal digits. A sign, a fraction or an exponent is refused as `not_unsigned_integer`, and leading zeros are a JSON syntax error, both in phase 1. An integer outside its member's range, including one beyond 64 bits, is `out_of_range`; a head member's other value is unsupported (DOC, Field-law version 1 and Refusal phases and errors; DEC:1565).

**What it means later.** Because the rule is in phase 1, it binds every later version (Q2): no version will accept a minus sign or a decimal point. A future signed or fractional quantity must be written another way, as the policy's fractions already are.

| Option | Consequence |
|---|---|
| a. Freeze as presented | One spelling per number; `-0` cannot become a second spelling of 0 |
| b. Make it a version-1 rule, checked in phase 3 | Later versions could accept signed numbers; such refusals would report invalid instead of malformed; a code change first |

**Recommendation: a.** Every version-1 range is non-negative, so a sign carries no meaning (DEC:1604), and it is the house rule of `ledger-format`: "plain JSON integers with no sign, fraction or exponent" (`contract/ledger/doc.go:40–41`; RULING:24).

**Folds into "Freeze as presented":** yes.

### Q8. `quantity_class` for each kind

**What is frozen.** Each kind declares `extensive` or `evidential`, and the loader checks only that it is one of the two, for any kind (DOC, Field-law version 1; DEC:1556).

**Why.** Undercurrent §9 calls `resource_pressure` and `perturbation` extensive and three kinds evidential, but `surprise` "Derived", which is neither (UC:201–206). No fixed mapping for all six kinds exists, and the specification has each kind declare its class (SPEC:487; RULING:20). The goldens give `surprise` each value in turn (BRIEF:678–679, :681–690).

**What it means later.** A law may declare, for example, `resource_pressure` evidential. Whether that is sensible is judged when you approve an exact law (D65, DEC:464). Binding a class to each kind later would take a new evaluator version, since refusing a class that version 1 accepts would break it **[INFERENCE]**.

| Option | Consequence |
|---|---|
| a. Freeze as presented | The law's author declares each class, and your approval of the law checks it |
| b. Fix one class per kind in evaluator v1 | Needs a decision for `surprise`; a code change first |

**Recommendation: a.**

**Folds into "Freeze as presented":** yes.

### Q9. The error vocabulary

**What is frozen.** Each refusal wraps exactly one of five sentinels, each with its own error type (DOC, Refusal phases and errors; DEC:1564):

| Sentinel | Error type and fields | Codes |
|---|---|---|
| `ErrInvalidLimits` | none: the host's limits are invalid (phase 0) | — |
| `ErrLimit` | `*LimitError`: `Bound`, `Max`, `Offset` | `bytes`, `depth`, `members`, `elements`, `string_bytes`, `tokens` |
| `ErrMalformed` | `*MalformedError`: `Problem`, `Offset` | `bom`, `invalid_utf8`, `syntax`, `duplicate_key`, `not_unsigned_integer`, `trailing_data` |
| `ErrUnsupported` | `*UnsupportedError`: `Field`, `Value`, `Supported` | the head member: `format`, `schema_version`, `evaluator_version` or `kernel` |
| `ErrInvalid` | `*FieldError`: `Path`, an RFC 6901 JSON Pointer, and `Violation` | `unknown_field`, `missing_field`, `wrong_type`, `unknown_value`, `out_of_range`, `pattern`, `count`, `unsorted`, `duplicate`, `mismatch` |

`null` is always `wrong_type`. `Error()` wording and diagnostic offsets are not promised; in this version a BOM's offset is 0 and the size limit's is its maximum.

**What it means later.** Renaming or removing a sentinel, type, field or code is a breaking change. The codes are typed strings without exported constants; constants can be added later, by addition (RULING:19). A new code could arrive only with a new schema or evaluator version **[INFERENCE]**, since the codes are "closed" and additions come as new versions (DOC, Refusal phases and errors, and Compatibility and non-goals).

| Option | Consequence |
|---|---|
| a. Freeze as presented | C4, Core and the tests can tell exactly what is wrong and where |
| b. Promise only the five sentinels | Codes and paths become changeable diagnostics that no consumer can rely on; the documentation changes first |

**Recommendation: a.** Tests must check behaviour, not prose wording (SPEC:587), so they need machine-checkable codes; sentinels with typed errors are the house pattern of `contract/ledger` (RULING:25).

**Folds into "Freeze as presented":** yes.

### Q10. For information, not frozen: the golden values

The numbers in the golden files are Undercurrent §13.4's preregistration candidates and the validation research's provisional V1 values: test data, not your law or validation policy (DEC:1594; UC:452; RAV:394). You approve an exact law and policy later, and Core activates them (D65, DEC:464; UC:464). No answer is needed.

### Summary

| Q | Subject | Recommendation | Folds into "Freeze as presented" |
|---|---|---|---|
| Q1 | Field law and registry | Freeze as built | Yes |
| Q2 | Growth, phase 1, empty edge lists | Closed version 1; new versions beside it | Yes |
| Q3 | Profiles and counting | Freeze as presented | Yes |
| Q4 | Identity | Exact-byte SHA-256, own `Digest` | Yes |
| Q5 | Validation policy | Three exact fractions | Yes |
| Q6 | Order within a phase | Not promised | Yes |
| Q7 | Unsigned digits | Freeze as presented | Yes |
| Q8 | `quantity_class` | Either value for any kind | Yes |
| Q9 | Error vocabulary | Freeze as presented | Yes |
| Q10 | Golden values | For information | No answer needed |

## 7. The question

To send in the question tool:

```text
Ticket 04 has built U1.L's law-format contract (contract/law). Under D40 I request your freeze of law-format at version 1, at commit 35ca559, which reaches main with the record of this request. The packet is in your vault at dwarf-harness/.scratch/dwarf-harness/u1-evidence/law-format-freeze-packet.md: what freezing permits and what it does not, the frozen surface by section of the package documentation, the ten golden files and the derived line-ending vector with their digests, the evidence (V1–V8 and the load-cost reasoning), nine questions with our recommendations and a note on the golden values, a draft decision entry and the edits that record the freeze. Freezing makes U1.L Done and lets C4 build on the format once C3 is Done; it chooses no law values and activates nothing. Nothing is frozen until you answer and your decision entry is recorded. Take the time you need.
```

| Label | Description |
|---|---|
| Freeze as presented (Recommended) | Freeze law-format v1 at 35ca559, with every recommendation in Q1–Q9. Your entry and the edits are recorded; U1.L becomes Done; C4 still waits for C3. |
| Freeze with changes | Name the changes by question number. A follow-up change makes them, and the freeze is recorded at its commit. law-format stays Draft until then. |
| Not yet | Nothing is frozen. law-format stays Draft, U1.L is not Done, and C4 and U1.E keep waiting. You may say what is missing. |

**Recommendation: Freeze as presented.** The format implements Undercurrent §13.4, D47 and B12 as B22 records, and the build advisor approved it on evidence collected in a separate worktree (DEC:1611). If the checks of §5 pass as listed, what remains open is either later work that the freeze does not touch (§2.4) or a choice about future flexibility, and each recommendation keeps growth possible through new versions (Q2). Waiting would settle no law value, and neither C4 nor U1.E may build on a draft (RU:24; RM:233).

## 8. Draft decision entry (not applied)

Written for "Freeze as presented"; Appendix A's F1a appends it, and F1b adjusts its Date line if you answer in your own words, as D111's records (DEC:1512). For "Freeze with changes", the entry is **Decided by:** modified, states your changes, and is recorded when the follow-up change lands, at its commit. For "Not yet", no entry is recorded. Originators follow AGENTS:7–14.

```markdown
### D114. law-format frozen at version 1

- **Date:** «DATE». **Decided by:** adopted. In OG4, the `law-format` freeze request that ticket 04 sent on 2026-10-12, the owner picked "Freeze as presented" from the assistant's options.
- **Owner's words (question tool):**
  > «OWNER-WORDS»
- **Decision:** `law-format` is frozen at version 1, at commit 35ca559 (D40), which reached `main` with the record of the request, as B22 items 1–9 record it and the package documentation of `contract/law` states it:
  - the field law: format `dwarf-harness/undercurrent-law`, schema version 1, evaluator version 1 and kernel `bounded_best_arrival/v1`, with its members and ranges and the evaluator-v1 registry of six kinds, 22 rules, four profiles and three edge types; `quantity_class` takes either value for any kind;
  - the validation policy: format `dwarf-harness/validation-policy`, schema version 1, with exactly `flake_rate_prior`, `failure_repair_confidence` and `quarantine_threshold`, each an unreduced fraction of `uint64` terms with the numerator below the denominator;
  - the profiles `compact-v1` and `standard-v1` and their counting rules; a host may tighten them, never widen them;
  - refusal: atomic, in phases 0 to 3 in that order; phase 1's rules, unsigned-integer spelling among them, hold for every schema and evaluator version; the five sentinels with their error types, and the closed bound, problem and violation codes, with RFC 6901 paths;
  - identity: the SHA-256 of an accepted artifact's exact bytes, as the package's own `Digest`; and the exclusions of B22 item 7;
  - the Go API of `contract/law`, in which an empty edge list loads as an empty, non-nil slice;
  - version 1 is closed: additions come only as new schema or evaluator versions read beside it, with no optional members and no upgrader, and later contract versions load every version-1 golden to the same typed value and digest;
  - the golden samples are the ten files under `contract/law/testdata/` with the SHA-256 digests of B22 item 9, and the line-ending vector derived from `law/v1/full.json`, 83cad664b5eb46a5ef8453f4d57cfce5c9023d24bd54e8d9a463c0f2b6eaf9bf.
- **Not frozen:** the golden values, which are test data, not the owner's law or validation policy; the exact law and policy, which the owner approves and Core activates (D65); the per-incident execution cap, which needs its own decision before C4 relies on it (B22); the order among several violations within a phase, `Error()` wording and diagnostic offsets, which the documentation does not promise; Core's activation manifest and its retention of artifact bytes (C2), and C4's use of the parameters.
- **Consequences:** `law-format` now changes only by addition, which for this format means new versions read beside version 1. A breaking change, such as a change to a profile's bounds, a counting rule, a phase-1 rule or a code, needs an owner decision entry listing every step it affects (D40). U1.L is Done (the Undercurrent roadmap's U1 exit criterion); U1 stays In progress until U1.E is Done. C4 may build against the format once C3 is Done; its D52 approval is given (D112). U1.E may build against it, on synthetic ledgers until its producer contracts are frozen. Nothing is approved or activated.
- **Changes:** `CONTRACTS.md` (status line; the `law-format` row's version and status); `ROADMAP-UNDERCURRENT.md` (status line; U1's stop point, Q24 row and status; the U1 and U5 rows of remaining gates) and `ROADMAPS.md` (status line), in one commit; Core (the contract-status sentences in Start here, §3.5 and §13's opening; §10's item 3; §13.10's list of gates); `ROADMAP-CORE.md` (C4's row of remaining gates); `ROADMAP-GUI.md`'s status paragraph; the system specification's status sentence; Undercurrent design §13.4, its U1.L dependency row, its Q24 row and its list of unrun gates; the validation research's V1 row; the open item in this log, which this entry closes, and a "See also" line under B22; the freeze packet's answer line; ticket 04's comments.
```

## Appendix A. Edits that record the request and the freeze (not applied)

Each edit has a heading `#### <ID> — <path>`, plain text saying when it applies, then `Find:` and `Replace:`, each followed by one four-backtick fence. The finds are copied from 35ca559, which is `main` at b663791 plus the documentation sentence, except those of F2 and F30, which match text that A.1 adds, and F1b, which matches text that F1a adds. Before applying, each find occurs exactly once in its file, with one exception: F31a's and F31b's find also occurs inside their own fences in this packet, so each applies to the first occurrence only, the header on line 3. Where variants share a find, such as F4a and F4b, exactly one of them applies.

### A.1 When the request is sent

In the commit that records the request, which also adds this packet as sent and brings 35ca559 onto `main` by fast-forward. Ticket 04 closes here: its last comment says it "closes when that request is sent (ruling P24)" (T04:71), and the tracker's resolve rule asks for an `## Answer` and `Status: resolved` (`docs/agents/issue-tracker.md:26`). No map file exists for this effort, so the map step does not apply. A row under "Open items awaiting the owner" records the pending request, as B21 added one for OG2 (DEC:1506). If your answer arrives before this commit, apply A.1 and then A.2 in order.

#### A1 — .scratch/dwarf-harness/issues/04-load-and-identify-a-strict-law-independently-of-field-execution.md

The ticket's status.

Find:
````
Status: claimed
````
Replace:
````
Status: resolved
````

#### A2 — .scratch/dwarf-harness/issues/04-load-and-identify-a-strict-law-independently-of-field-execution.md

The acceptance criteria, ticked.

Find:
````
- [ ] A complete valid LAW-PARSER artifact loads into the typed six-kind/rule registry; every specified malformed, duplicate, unsupported, unsorted and boundary-exceeding artifact is rejected atomically under both finite profiles.
- [ ] Golden vectors distinguish byte-identical artifacts from whitespace/key-order/line-ending changes using exact immutable Git-blob SHA-256, with no semantic canonicalizer.
- [ ] The same contract supplies typed versioned D47 parameters and local-manifest bindings to a C4-facing consumer without importing or starting the field engine.
- [ ] Shared law exports exclude local workspace/check/environment policy, grants, credentials and activation time; parsing cannot authorize or execute activation.
- [ ] Additive/version compatibility, old evaluator semantics and unsupported versions are observable through the declared contract and golden samples; the contract record clearly separates implementation from owner freeze.
````
Replace:
````
- [x] A complete valid LAW-PARSER artifact loads into the typed six-kind/rule registry; every specified malformed, duplicate, unsupported, unsorted and boundary-exceeding artifact is rejected atomically under both finite profiles.
- [x] Golden vectors distinguish byte-identical artifacts from whitespace/key-order/line-ending changes using exact immutable Git-blob SHA-256, with no semantic canonicalizer.
- [x] The same contract supplies typed versioned D47 parameters and local-manifest bindings to a C4-facing consumer without importing or starting the field engine.
- [x] Shared law exports exclude local workspace/check/environment policy, grants, credentials and activation time; parsing cannot authorize or execute activation.
- [x] Additive/version compatibility, old evaluator semantics and unsupported versions are observable through the declared contract and golden samples; the contract record clearly separates implementation from owner freeze.
````

#### A3 — .scratch/dwarf-harness/issues/04-load-and-identify-a-strict-law-independently-of-field-execution.md

The `## Answer` section, placed before `## Comments`.

Find:
````
- Decision log D40/D47/B2/B12

## Comments
````
Replace:
````
- Decision log D40/D47/B2/B12

## Answer

U1.L's `law-format` contract is built, reviewed and on `main` as a draft, and U1 is In progress. `contract/law`, which uses the standard library only, loads the shared field law of Undercurrent §13.4 into the typed six-kind registry and refuses a malformed, duplicate, unsupported, unsorted or out-of-bounds artifact whole, under both `compact-v1` and `standard-v1`; a host may tighten those limits but never widen them. It also loads the local validation policy, D47's flake-rate prior, failure/repair confidence and quarantine threshold as exact fractions, which a C4-facing consumer reads without the field law or the engine. Each artifact is identified by the SHA-256 of its exact bytes, and golden vectors show that whitespace, key-order and line-ending changes alter that identity but not the loaded values. Neither artifact can carry workspace, check or environment data, grants, credentials or activation time, and loading activates nothing. Newer schema, evaluator and kernel versions are refused as unsupported, never reinterpreted. The decisions, which the owner approved as ruled, are recorded in [B22](../../../docs/DECISIONS.md#b22-u1l-law-format-version-1-the-validation-policy-and-their-identities); following his answer to OG-B, the policy holds three values, without the per-incident execution cap. The design brief and the advisor's ruling are under `.scratch/dwarf-harness/u1-evidence/`. The ticket ends with the owner freeze request for `law-format` (OG4), sent on 2026-10-12 without claiming the freeze; its packet is `.scratch/dwarf-harness/u1-evidence/law-format-freeze-packet.md`. `law-format` stays Draft until the owner freezes it under D40, and U1.L is Done only then.

## Comments
````

#### A4 — .scratch/dwarf-harness/issues/04-load-and-identify-a-strict-law-independently-of-field-execution.md

A comment recording the request, appended after the last comment. At b663791 the last comment ends as in the find; if a comment has been added since, anchor on the end of that one instead.

Find:
````
The freeze request comes next, with its own packet, and this ticket closes when that request is sent (ruling P24).
````
Replace:
````
The freeze request comes next, with its own packet, and this ticket closes when that request is sent (ruling P24).

2026-10-12 — OG4, the `law-format` freeze request, was sent at 07:51 local time as one question-tool request, pointing to the packet at `.scratch/dwarf-harness/u1-evidence/law-format-freeze-packet.md`. Its V1–V8 results, `go doc` output and golden digests were taken at 35ca559, which adds one sentence to the package documentation, as the build advisor's review of S1 asked: an empty edge list loads as an empty, non-nil slice. `main` reaches 35ca559 by fast-forward with this comment's commit. The ticket closes with the request sent, not answered (ruling P24). `law-format` stays Draft until the owner answers and his decision entry is recorded.
````

#### A5 — docs/DECISIONS.md

The open item (DEC:28).

Find:
````
| None | — | — |
````
Replace:
````
| OG4: freeze `law-format` at version 1 (D40), sent 2026-10-12; packet at `.scratch/dwarf-harness/u1-evidence/law-format-freeze-packet.md` | U1.L Done (the U1 exit criterion); C4, which also waits for C3; U1.E and the other consumers of the format | Ticket 04 closed with the request sent (B22, item 11); nothing is frozen until the owner answers and his decision entry is recorded |
````

### A.2 After "Freeze as presented"

In one documents-only commit, as for D111. The status lines of `ROADMAP-UNDERCURRENT.md` and `ROADMAPS.md` change in that commit together (RU:164; RM:198), and the full check passes on it (D46). Edits F1a–F8, F11, F14a–F15, F30 and F31a–F31b record the freeze in the log, the register, the roadmaps' tracking of U1.L, the ticket and this packet. The others correct lines that say the freeze is still to come, as D111 corrected "the lines that waited on it" (DEC:1522).

#### F1a — docs/DECISIONS.md

The entry of §8, appended after D113, the log's last entry at b663791 (DEC:1636–1648). If another entry has been appended since, anchor on its last line instead and renumber the entry.

Find:
````
- **Changes:** Core §13.1's F2 sentence; `ROADMAP-CORE.md` (C1's F2 deliverable, Start here and C2's Status); `ROADMAPS.md` (the Path A paragraph); "See also" lines under D112 and B2.
````
Replace:
````
- **Changes:** Core §13.1's F2 sentence; `ROADMAP-CORE.md` (C1's F2 deliverable, Start here and C2's Status); `ROADMAPS.md` (the Path A paragraph); "See also" lines under D112 and B2.

### D114. law-format frozen at version 1

- **Date:** «DATE». **Decided by:** adopted. In OG4, the `law-format` freeze request that ticket 04 sent on 2026-10-12, the owner picked "Freeze as presented" from the assistant's options.
- **Owner's words (question tool):**
  > «OWNER-WORDS»
- **Decision:** `law-format` is frozen at version 1, at commit 35ca559 (D40), which reached `main` with the record of the request, as B22 items 1–9 record it and the package documentation of `contract/law` states it:
  - the field law: format `dwarf-harness/undercurrent-law`, schema version 1, evaluator version 1 and kernel `bounded_best_arrival/v1`, with its members and ranges and the evaluator-v1 registry of six kinds, 22 rules, four profiles and three edge types; `quantity_class` takes either value for any kind;
  - the validation policy: format `dwarf-harness/validation-policy`, schema version 1, with exactly `flake_rate_prior`, `failure_repair_confidence` and `quarantine_threshold`, each an unreduced fraction of `uint64` terms with the numerator below the denominator;
  - the profiles `compact-v1` and `standard-v1` and their counting rules; a host may tighten them, never widen them;
  - refusal: atomic, in phases 0 to 3 in that order; phase 1's rules, unsigned-integer spelling among them, hold for every schema and evaluator version; the five sentinels with their error types, and the closed bound, problem and violation codes, with RFC 6901 paths;
  - identity: the SHA-256 of an accepted artifact's exact bytes, as the package's own `Digest`; and the exclusions of B22 item 7;
  - the Go API of `contract/law`, in which an empty edge list loads as an empty, non-nil slice;
  - version 1 is closed: additions come only as new schema or evaluator versions read beside it, with no optional members and no upgrader, and later contract versions load every version-1 golden to the same typed value and digest;
  - the golden samples are the ten files under `contract/law/testdata/` with the SHA-256 digests of B22 item 9, and the line-ending vector derived from `law/v1/full.json`, 83cad664b5eb46a5ef8453f4d57cfce5c9023d24bd54e8d9a463c0f2b6eaf9bf.
- **Not frozen:** the golden values, which are test data, not the owner's law or validation policy; the exact law and policy, which the owner approves and Core activates (D65); the per-incident execution cap, which needs its own decision before C4 relies on it (B22); the order among several violations within a phase, `Error()` wording and diagnostic offsets, which the documentation does not promise; Core's activation manifest and its retention of artifact bytes (C2), and C4's use of the parameters.
- **Consequences:** `law-format` now changes only by addition, which for this format means new versions read beside version 1. A breaking change, such as a change to a profile's bounds, a counting rule, a phase-1 rule or a code, needs an owner decision entry listing every step it affects (D40). U1.L is Done (the Undercurrent roadmap's U1 exit criterion); U1 stays In progress until U1.E is Done. C4 may build against the format once C3 is Done; its D52 approval is given (D112). U1.E may build against it, on synthetic ledgers until its producer contracts are frozen. Nothing is approved or activated.
- **Changes:** `CONTRACTS.md` (status line; the `law-format` row's version and status); `ROADMAP-UNDERCURRENT.md` (status line; U1's stop point, Q24 row and status; the U1 and U5 rows of remaining gates) and `ROADMAPS.md` (status line), in one commit; Core (the contract-status sentences in Start here, §3.5 and §13's opening; §10's item 3; §13.10's list of gates); `ROADMAP-CORE.md` (C4's row of remaining gates); `ROADMAP-GUI.md`'s status paragraph; the system specification's status sentence; Undercurrent design §13.4, its U1.L dependency row, its Q24 row and its list of unrun gates; the validation research's V1 row; the open item in this log, which this entry closes, and a "See also" line under B22; the freeze packet's answer line; ticket 04's comments.
````

#### F1b — docs/DECISIONS.md

Applies after F1a, and only if you answered in your own words: the Date line then reads as D111's does (DEC:1512).

Find:
````
the owner picked "Freeze as presented" from the assistant's options.
````
Replace:
````
the owner chose "Freeze as presented" in his own words.
````

#### F2 — docs/DECISIONS.md

The open item that A5 added. If another open item has been added since, delete only this row.

Find:
````
| OG4: freeze `law-format` at version 1 (D40), sent 2026-10-12; packet at `.scratch/dwarf-harness/u1-evidence/law-format-freeze-packet.md` | U1.L Done (the U1 exit criterion); C4, which also waits for C3; U1.E and the other consumers of the format | Ticket 04 closed with the request sent (B22, item 11); nothing is frozen until the owner answers and his decision entry is recorded |
````
Replace:
````
| None | — | — |
````

#### F3 — docs/DECISIONS.md

A "See also" line under B22, after its last line (DEC:1634); an earlier entry gains only a one-line pointer (DEC:5).

Find:
````
  - Evidence under `.scratch/dwarf-harness/u1-evidence/`: the design brief and the build advisor's ruling.
````
Replace:
````
  - Evidence under `.scratch/dwarf-harness/u1-evidence/`: the design brief and the build advisor's ruling.
- **See also:** D114 records the owner's freeze of `law-format` at version 1, which item 11 left to him; the golden values stay test data.
````

#### F4a — docs/CONTRACTS.md

The status line (CON:3), a new first entry. Applies if «DATE» is later than 2026-10-12; otherwise apply F4b.

Find:
````
**Status:** 2026-10-12 (U1.L drafts `law-format` in `contract/law`, ticket 04, B22; not frozen);
````
Replace:
````
**Status:** «DATE» (the owner freezes `law-format` at version 1, D114); 2026-10-12 (U1.L drafts `law-format` in `contract/law`, ticket 04, B22; not frozen);
````

#### F4b — docs/CONTRACTS.md

The status line (CON:3). Applies if «DATE» is 2026-10-12; otherwise apply F4a.

Find:
````
**Status:** 2026-10-12 (U1.L drafts `law-format` in `contract/law`, ticket 04, B22; not frozen);
````
Replace:
````
**Status:** 2026-10-12 (U1.L drafts `law-format` in `contract/law`, ticket 04, B22; the owner freezes it at version 1, D114);
````

#### F5 — docs/CONTRACTS.md

The status line's contract statuses (CON:3).

Find:
````
`law-format` is *Draft* (B22); `launcher-protocol` and `context-module` remain *Not started*.
````
Replace:
````
`law-format` is *Frozen* at version 1 (D114); `launcher-protocol` and `context-module` remain *Not started*.
````

#### F6 — docs/CONTRACTS.md

The register row: Version 1, Frozen (CON:30), as CON:19 asks: "update the version and status columns".

Find:
````
not R1 (Q28) | — | Draft |
````
Replace:
````
not R1 (Q28) | 1 | Frozen |
````

#### F7a — docs/ROADMAP-UNDERCURRENT.md

The status line (RU:3), a new first entry. Applies if «DATE» is later than 2026-10-12; otherwise apply F7b.

Find:
````
**Status:** 2026-10-12 (U1.L drafts `law-format` in `contract/law`, ticket 04, B22: U1 In progress; not frozen);
````
Replace:
````
**Status:** «DATE» (the owner freezes `law-format` at version 1, D114: U1.L Done; U1 stays In progress); 2026-10-12 (U1.L drafts `law-format` in `contract/law`, ticket 04, B22: U1 In progress; not frozen);
````

#### F7b — docs/ROADMAP-UNDERCURRENT.md

The status line (RU:3). Applies if «DATE» is 2026-10-12; otherwise apply F7a.

Find:
````
**Status:** 2026-10-12 (U1.L drafts `law-format` in `contract/law`, ticket 04, B22: U1 In progress; not frozen);
````
Replace:
````
**Status:** 2026-10-12 (U1.L drafts `law-format` in `contract/law`, ticket 04, B22: U1 In progress; the owner freezes it at version 1, D114: U1.L Done);
````

#### F8 — docs/ROADMAP-UNDERCURRENT.md

The status line's account of what exists (RU:3).

Find:
````
Apart from U1.L's draft `law-format` contract (`contract/law`, ticket 04), no field-layer implementation exists yet.
````
Replace:
````
Apart from U1.L's `law-format` contract (`contract/law`, ticket 04), frozen at version 1 (D114), no field-layer implementation exists yet.
````

#### F9 — docs/ROADMAP-UNDERCURRENT.md

U1's stop point (RU:187).

Find:
````
are selected in §13.4; C1 freeze, vectors and implementation remain unrun.
````
Replace:
````
are selected in §13.4; `contract/law` implements the schema, hash and profiles with golden vectors (ticket 04, B22), frozen at version 1 (D114).
````

#### F10 — docs/ROADMAP-UNDERCURRENT.md

U1's Q24 row (RU:207).

Find:
````
C1 formal freeze/golden vectors, U2 values and workload calibration remain; selection does not approve or activate policy.
````
Replace:
````
The format and its golden vectors are frozen at version 1 (D114); U2 values and workload calibration remain; neither the selection nor the freeze approves or activates policy.
````

#### F11 — docs/ROADMAP-UNDERCURRENT.md

U1's status (RU:217). U1 stays In progress, as the status board says (RM:187).

Find:
````
**Status.** In progress (2026-10-12: U1.L's `law-format` is drafted in `contract/law`, ticket 04 and B22, and awaits the owner's freeze; U1.E has not started.
````
Replace:
````
**Status.** In progress («DATE»: U1.L is Done; the owner froze `law-format`, built in `contract/law` by ticket 04 and B22, at version 1, D114. U1.E has not started.
````

#### F12 — docs/ROADMAP-UNDERCURRENT.md

U1's row of remaining gates (RU:577), in the form U3's row uses for a met prerequisite (RU:579).

Find:
````
C1's ledger-format/reader are frozen (D111); the selected law-format contract/golden vectors must still be frozen;
````
Replace:
````
C1's ledger-format/reader are frozen (D111), and so are the law-format contract and its golden vectors (D114);
````

#### F13 — docs/ROADMAP-UNDERCURRENT.md

U5's row of remaining gates (RU:581).

Find:
````
| U5 | R1/C1 exact band/status/fact contracts, frozen U1.L, U1.E for source/engine integration, and U3 foundation;
````
Replace:
````
| U5 | R1/C1 exact band/status/fact contracts, U1.E for source/engine integration, and U3 foundation (U1.L's `law-format` is frozen, D114);
````

#### F14a — docs/ROADMAPS.md

The status line (RM:3), a new first entry. Applies if «DATE» is later than 2026-10-12; otherwise apply F14b.

Find:
````
**Status:** 2026-10-12 (D52 promotion boundary approved, D112; C2 Ready; U1.L drafts `law-format`, ticket 04, B22; U1 In progress);
````
Replace:
````
**Status:** «DATE» (`law-format` frozen at version 1, D114: U1.L Done; U1 stays In progress); 2026-10-12 (D52 promotion boundary approved, D112; C2 Ready; U1.L drafts `law-format`, ticket 04, B22; U1 In progress);
````

#### F14b — docs/ROADMAPS.md

The status line (RM:3). Applies if «DATE» is 2026-10-12; otherwise apply F14a.

Find:
````
**Status:** 2026-10-12 (D52 promotion boundary approved, D112; C2 Ready; U1.L drafts `law-format`, ticket 04, B22; U1 In progress);
````
Replace:
````
**Status:** 2026-10-12 (D52 promotion boundary approved, D112; C2 Ready; U1.L drafts `law-format`, ticket 04, B22; `law-format` frozen at version 1, D114: U1.L Done; U1 In progress);
````

#### F15 — docs/ROADMAPS.md

The status line's account of what exists (RM:3).

Find:
````
and U1.L's `law-format` contract, drafted and not frozen (ticket 04, B22), this index records
````
Replace:
````
and U1.L, Done with its `law-format` contract frozen at version 1 (ticket 04, B22, D114), this index records
````

#### F16 — docs/DESIGN-CORE-AND-LAUNCHERS.md

Start here, the current stopping point (CORE:23).

Find:
````
`ledger-format`, `ledger-reader` and `ledger-appender` are Frozen, `law-format` is Draft (B22) and the other two contracts remain Not started;
````
Replace:
````
`ledger-format`, `ledger-reader`, `ledger-appender` and `law-format` are Frozen (D111, D114) and the other two contracts remain Not started;
````

#### F17 — docs/DESIGN-CORE-AND-LAUNCHERS.md

Start here, the recommended continuation (CORE:39).

Find:
````
`law-format` is Draft (B22); the other two contracts remain Not started. The owner answer provenance
````
Replace:
````
`law-format` is Frozen at version 1 (D114); the other two contracts remain Not started. The owner answer provenance
````

#### F18 — docs/DESIGN-CORE-AND-LAUNCHERS.md

§3.5, readiness and proof (CORE:201).

Find:
````
`law-format` is Draft (B22); the other two contracts remain Not started. No accepted promotion
````
Replace:
````
`law-format` is Frozen at version 1 (D114); the other two contracts remain Not started. No accepted promotion
````

#### F19 — docs/DESIGN-CORE-AND-LAUNCHERS.md

§13's opening (CORE:824).

Find:
````
C8 and C9 wait on their named dependencies. `ledger-format`, `ledger-reader` and `ledger-appender` are Frozen at version 1 (D111); `law-format` is Draft (B22);
````
Replace:
````
C8 and C9 wait on their named dependencies. `ledger-format`, `ledger-reader` and `ledger-appender` are Frozen at version 1 (D111); `law-format` is Frozen at version 1 (D114);
````

#### F20 — docs/DESIGN-CORE-AND-LAUNCHERS.md

§10, item 3 (CORE:730), noted as item 2 notes D111 (CORE:729).

Find:
````
C4 waits for C3, U1.L and owner-frozen `law-format`, then must pass
````
Replace:
````
C4 waits for C3, U1.L and owner-frozen `law-format` (the owner froze `law-format` on «DATE», D114, so U1.L is Done), then must pass
````

#### F21 — docs/DESIGN-CORE-AND-LAUNCHERS.md

§13.10, the gates that remain (CORE:999); D52's approval left this list when it was given.

Find:
````
D41 dependency approval; U1.L/frozen law-format and C3 before C4;
````
Replace:
````
D41 dependency approval; C3 before C4 (U1.L is Done and `law-format` frozen, D114);
````

#### F22 — docs/ROADMAP-CORE.md

C4's row of remaining prerequisites (RC:974).

Find:
````
| C4 | C3, U1.L and frozen law-format; real full runner,
````
Replace:
````
| C4 | C3 (U1.L is Done and `law-format` frozen, D114); real full runner,
````

#### F23 — docs/ROADMAP-GUI.md

The status paragraph (`docs/ROADMAP-GUI.md:23`).

Find:
````
`law-format` is Draft (B22); the other two, `launcher-protocol` and `context-module`, remain Not started.
````
Replace:
````
`law-format` is Frozen at version 1 (D114); the other two, `launcher-protocol` and `context-module`, remain Not started.
````

#### F24 — .scratch/dwarf-harness/spec.md

The status sentence (SPEC:679).

Find:
````
U1 is In progress with U1.L's `law-format` drafted and not frozen (ticket 04, B22), and other statuses remain Waiting/gated; the three ledger contracts are Frozen, `law-format` is Draft while the other two contracts remain Not started,
````
Replace:
````
U1 is In progress with U1.L Done and its `law-format` frozen at version 1 (ticket 04, B22, D114), and other statuses remain Waiting/gated; the three ledger contracts and `law-format` are Frozen while the other two contracts remain Not started,
````

#### F25 — docs/DESIGN-UNDERCURRENT.md

§13.4 (UC:458).

Find:
````
D40/C1 must formally freeze the selected `law-format` schema and vectors; this design selection does not claim that freeze or any validation/readiness gate.
````
Replace:
````
The owner froze the selected `law-format` schema and vectors at version 1 under D40 (D114); neither this design selection nor that freeze claims any validation or readiness gate.
````

#### F26 — docs/DESIGN-UNDERCURRENT.md

§15, the U1.L row (UC:577).

Find:
````
| C1 formal freeze/golden vectors, actual law-value and parser-workload calibration, and U1.E implementation/replay/capacity gates remain;
````
Replace:
````
| The format and its golden vectors are frozen at version 1 (D114); actual law-value and parser-workload calibration and U1.E implementation/replay/capacity gates remain;
````

#### F27 — docs/DESIGN-UNDERCURRENT.md

§17, the Q24 row (UC:762).

Find:
````
| C1 formal freeze/golden vectors, value/capacity calibration and Core activation implementation remain;
````
Replace:
````
| The format and its golden vectors are frozen at version 1 (D114); value/capacity calibration and Core activation implementation remain;
````

#### F28 — docs/DESIGN-UNDERCURRENT.md

§17, the other unrun gates (UC:768). The "activation tuple" is the activation manifest's required tuple (UC:456), which remains to be frozen **[INFERENCE]**.

Find:
````
C1 formal freeze of the selected law-format/activation tuple and producer event schemas;
````
Replace:
````
C1 formal freeze of the selected activation tuple and producer event schemas (`law-format` is frozen, D114);
````

#### F29 — docs/RESEARCH-ADMISSIBLE-VALIDATION.md

The V1 row (RAV:394).

Find:
````
U1.L schema and owner-authorized exact law activation remain required |
````
Replace:
````
U1.L's validation-policy schema is frozen with the first three values (D114; B22); the per-incident execution cap needs its own decision, and owner-authorized exact law activation remains required |
````

#### F30 — .scratch/dwarf-harness/issues/04-load-and-identify-a-strict-law-independently-of-field-execution.md

A comment recording the freeze, appended after the last comment, normally A4's.

Find:
````
`law-format` stays Draft until the owner answers and his decision entry is recorded.
````
Replace:
````
`law-format` stays Draft until the owner answers and his decision entry is recorded.

«DATE» — The owner's freeze is recorded: `main` moved by fast-forward to «RECORD-COMMIT» after all nine check steps passed on it. In OG4 the owner chose "Freeze as presented" (question tool: "«OWNER-WORDS»"). The commit appends [D114](../../../docs/DECISIONS.md#d114-law-format-frozen-at-version-1), which freezes `law-format` at version 1 at 35ca559, and updates the register and every status line. U1.L is Done; U1 stays In progress until U1.E is Done.
````

#### F31a — .scratch/dwarf-harness/u1-evidence/law-format-freeze-packet.md

This packet's answer line, if you picked the option as written; otherwise apply F31b. Apply to the first occurrence only: the header, line 3.

Find:
````
**Answer:** pending.
````
Replace:
````
**Answer:** «DATE», "Freeze as presented". [D114](../../../docs/DECISIONS.md#d114-law-format-frozen-at-version-1) records the freeze, adapted from §8 to your answer, and Appendix A.2's edits record it in the register and the roadmaps. The rest of this packet stays as sent.
````

#### F31b — .scratch/dwarf-harness/u1-evidence/law-format-freeze-packet.md

This packet's answer line, if you answered in your own words; otherwise apply F31a. Apply to the first occurrence only: the header, line 3.

Find:
````
**Answer:** pending.
````
Replace:
````
**Answer:** «DATE», "Freeze as presented" in your own words: "«OWNER-WORDS»". [D114](../../../docs/DECISIONS.md#d114-law-format-frozen-at-version-1) records the freeze, adapted from §8 to your answer, and Appendix A.2's edits record it in the register and the roadmaps. The rest of this packet stays as sent.
````

**After applying A.2:**

1. No placeholder is left outside this packet. This prints nothing:
   `Select-String -Path docs\*.md, .scratch\dwarf-harness\spec.md, .scratch\dwarf-harness\issues\04-*.md -Pattern '«|»'`
2. `git diff --stat` lists `docs/DECISIONS.md`, `docs/CONTRACTS.md`, `docs/ROADMAP-UNDERCURRENT.md`, `docs/ROADMAPS.md`, `docs/DESIGN-CORE-AND-LAUNCHERS.md`, `docs/ROADMAP-CORE.md`, `docs/ROADMAP-GUI.md`, `docs/DESIGN-UNDERCURRENT.md`, `docs/RESEARCH-ADMISSIBLE-VALIDATION.md`, `.scratch/dwarf-harness/spec.md`, ticket 04 and this packet, and no Go file.
3. Each find occurs zero times, unless its replacement repeats it, and each replacement once.
4. `go run ./tools/check` passes all nine steps on the commit, with `DWARF_CC` set (D46).

### A.3 Other answers

- **"Freeze with changes":** an adapted F31b records your answer and the changes you named, and a ticket 04 comment records them too. The open item stays, its Notes naming the follow-up ticket. The follow-up makes the changes and reruns §5's checks; the entry, **Decided by:** modified, and edits F1a–F30 then land against its commit, which takes the place of 35ca559.
- **"Not yet":** an adapted F31b records your answer, and a ticket 04 comment records it too. The open item stays, its Notes recording the answer. No entry is recorded and no other F edit is made.

### A.4 Unchanged, and why

- **`contract/law` itself.** Nothing in the package changes after 35ca559. Its documentation's first sentence, "Version 1 is a draft until the owner's freeze (D40)", and its last, "Consumers must wait for the owner's law-format freeze", stay as written, as `contract/ledger/doc.go:3–4` and `contract/ledger/appender/appender.go:37` stayed after D111.
- **B22's own text.** Entries are not edited; B22 gains only the "See also" line (DEC:5).
- **Dated history:** the earlier entries of the status lines (CON:3, RU:3, RM:3) and the ticket's earlier comments.
- **Lines that state the dependency as a rule** and stay true: RC:537, :539, :548, :553, :566, :642; RM:118, :153; RU:44, :45, :89, :158, :159, :189, :200, :202, :378, :380; CORE:97, :199, :216, :704, :846; RAV:366, :373; SPEC:694, :696; UC:462, :582, :588, :688.
- **The status board** (RM:172, :187). C4's row keeps "U1.L and frozen `law-format`" in its waits-for column, as C2's row kept its met items after D112 (RM:170), and C4 stays Waiting for C3. U1's row stays In progress: the board tracks U1, not U1.L.
- **`ROADMAP-CORE.md`'s status line** (RC:3): no Core step changes status.
- **Lines about the values, not the format:** CORE:892's values still "await U1.L owner approval/calibration"; the freeze approves no values (Q10). F29 changes only RAV:394's schema clause.
- **Statements about a selection, not a freeze:** SPEC:483 ("This selection is not a contract freeze, calibration result or activation") and CON:66 stay true.
- **Older snapshots:** UC:3, Core's `**Updated:**` line (CORE:4) and the consolidation comments (CON:110, :114), which neither D111 nor B22 updated.

## Appendix B. `go doc -all ./contract/law` at 35ca559

```text
package law // import "github.com/Darius-PJ/dwarf-harness/contract/law"

Package law loads and identifies the shared field law and the local D47
validation policy independently of field execution. Version 1 is a draft until
the owner's freeze (D40). This documentation is the format.

# Field-law version 1

Each artifact is one strict UTF-8 JSON object, without a BOM. Every member below
is required; no other member is allowed and no omitted field receives a default.
Object member order is free. Integer tokens contain unsigned decimal digits
only: no sign, fraction or exponent. Leading zeros are JSON syntax errors.
Strings and keys are decoded before validation: escaped spellings such as
"\u0061ffordance" are accepted with a different byte identity. An escaped lone
surrogate ("\ud800") is valid UTF-8, decodes to U+FFFD and reaches pattern,
unknown_value or unknown_field, never an acceptance hole.

The tables below give this version's validation order, not JSON member order.
Root members:

    format             string   dwarf-harness/undercurrent-law
    schema_version     integer  1
    evaluator_version  integer  1
    kernel             string   bounded_best_arrival/v1
    law_id             string   ^[a-z0-9][a-z0-9._-]{0,63}$
    law_version        integer  1..2147483647
    weight_scale_ppm   integer  exactly 1000000
    kinds              array    exactly six kind objects, ascending by id

law_id and law_version are labels, never identity. Kind objects:

    id                string   one of the six registered kinds below
    quantity_class    string   extensive or evidential, for any kind
    unit              string   the kind's registered unit
    sources           array    1..8 source objects, ascending by rule_id
    hop_latency_ms    integer  0..86400000
    attenuation_ppm   integer  1..999999
    cutoff_units      integer  1..1000000000000
    saturation_units  integer  1..1000000000000, strictly above cutoff_units

Each kind must have at least one source, but may omit any other registered rule.
No amplitude field exists here; producer magnitudes, reducers and saturation
capping belong to the engine, not this loader. Source objects:

    rule_id            string   a rule registered for the enclosing kind
    mode               string   the rule's impulse, level, sustained or rising
    unit               string   the enclosing kind's unit
    half_life_seconds  integer  impulse: 1..31536000; other modes: exactly 0
    age_rule_id        string   rising: linear_per_day/v1; otherwise: none
    rise_units_per_day integer  rising: 1..1000000000000; otherwise: exactly 0
    coupling           object   the rule's registered coupling profile

Coupling objects:

    profile     string  one of the four profiles below, as fixed by the rule
    direction   string  local, dependency_to_consumer or resource_to_consumer
    edge_types  array   0..2 edge-type strings, ascending and equal to the profile

All kinds, sources and edge_types are strictly ascending by stable ASCII ID,
with no duplicates. Unknown values and valid-but-mismatched registry values
reject the entire law. The six kind/unit pairs, in ascending kind order:

    affordance             affordance_units
    dependency_strain      strain_units
    epistemic_uncertainty  uncertainty_units
    perturbation           perturbation_units
    resource_pressure     pressure_units
    surprise               surprise_units

# Evaluator-v1 registry

Rule IDs select built-in typed reducers, not event names, scripts or imports.
In the rule table, L = local/v1, D = dependency_downstream/v1, O =
overlap_relevance/v1 and R = registered_resource_outward/v1.

    kind                   rule                                 mode       profile
    affordance             repair_r2_impulse/v1                  impulse    D
    affordance             repair_r3_impulse/v1                  impulse    D
    affordance             repair_r3_sustained/v1                sustained  D
    dependency_strain      validation_f2_impulse/v1              impulse    L
    dependency_strain      validation_f2_sustained/v1            sustained  L
    dependency_strain      validation_f3_attributed/v1           sustained  D
    epistemic_uncertainty  base_staleness/v1                     rising     L
    epistemic_uncertainty  check_flakiness/v1                    level      L
    epistemic_uncertainty  check_quarantine/v1                   level      L
    epistemic_uncertainty  check_retirement/v1                   level      L
    epistemic_uncertainty  private_overlap/v1                    level      L
    epistemic_uncertainty  promotion_overlap/v1                  impulse    O
    perturbation           canonical_change/v1                   impulse    D
    perturbation           federated_perturbation/v1              impulse    D
    perturbation           provider_status/v1                    level      D
    resource_pressure     core_budget_exposure/v1               level      R
    resource_pressure     core_resource_usage/v1                level      R
    resource_pressure     core_runner_queue/v1                  level      R
    resource_pressure     router_headroom/v1                    level      R
    surprise               check_duration_anomaly/v1             impulse    L
    surprise               check_outcome_anomaly/v1              impulse    L
    surprise               shared_resource_pressure_anomaly/v1   impulse    L

Profiles fix both direction and the entire edge list:

    local/v1                       local                   []
    dependency_downstream/v1       dependency_to_consumer  [declared_dataflow, static_dependency]
    overlap_relevance/v1           dependency_to_consumer  [declared_dataflow, static_dependency]
    registered_resource_outward/v1 resource_to_consumer    [registered_resource_use]

The only edge types are declared_dataflow, registered_resource_use and
static_dependency. Encounter relations are not edges here. There is no
validation_f1_unconfirmed/v1 rule. R1's router-headroom/v1 scheme (hyphen) is
distinct from the registered router_headroom/v1 extractor (underscore).

# Validation-policy version 1

A separate local artifact contains exactly these root members, in check order:

    format                     string   dwarf-harness/validation-policy
    schema_version             integer  1
    flake_rate_prior           rational
    failure_repair_confidence  rational
    quarantine_threshold       rational

A rational object requires numerator followed by denominator in check order.
Each is an integer in 1..18446744073709551615 (uint64), and numerator must
be strictly below denominator. Fractions are not reduced: 1/20 and 2/40 are
different artifacts. There is no label, policy ID or fourth policy parameter.
These values never enter the shared field law.

# Parser limits

The host passes explicit LoadLimits; neither artifact supplies them. Every
bound is inclusive, positive and at most the corresponding StandardV1 value.
CompactV1 and StandardV1 return fresh values; a caller may tighten any field,
never widen it. A zero LoadLimits or zero field is invalid, not a default.
Both loaders use the same counting rules and profiles:

    bound        compact-v1  standard-v1
    Bytes        65536       262144
    Depth        12          16
    Members      64          128
    Elements     128         256
    StringBytes  128         256
    Tokens       2048        8192

Bytes counts the whole input. The root container is depth 1; each nested object
or array adds one, and scalars add none. Members counts name/value pairs
per object (a duplicate counts too), Elements counts values per array, and
StringBytes counts decoded UTF-8 bytes per string, keys included. Tokens counts
every value json.Decoder.Token returns, including keys and opening/closing
delimiters; commas, colons and whitespace do not count. Valid v1 laws need at
most depth 7, 8 members, 6 elements, 64-byte decoded strings and 681 tokens.
Whitespace and escaped spellings can still inflate their raw byte size beyond
compact-v1. A three-parameter policy needs depth 2, at most 5 members, 31-byte
decoded strings and 27 tokens.

# Refusal phases and errors

Rejection is atomic: each loader returns its zero result and exactly one error,
never a partial artifact. The loaders are pure, with no file, clock, environment
or goroutine access. Successful results alias neither their input nor other
results. The phases always run in this order:

 0. Validate host limits, before touching input (ErrInvalidLimits).
 1. Check strict JSON and resource bounds over the entire artifact.
 2. Check the root type and head members before interpreting version 1.
 3. Decode and validate the closed version-1 objects and arrays.

Phase 1 first checks Bytes, then the BOM prefix, then UTF-8 over the entire
input, then walks tokens in input order. At each token, the checks are syntax,
Tokens, opened-container Depth, object Members, array Elements, StringBytes,
duplicate decoded keys, then unsigned-integer spelling. After the root,
anything but JSON whitespace (space, tab, LF, CR) is trailing_data, including
another JSON value or a syntax error on a stray byte. Empty input is syntax.
No json.Valid precheck or floating-point conversion is used. Phase-1 rules are
invariants of the format family, kept by every schema and evaluator version;
versions never relax these rules or reorder the phases.

Phase 2 requires an object, then checks format, schema_version,
evaluator_version and kernel for laws, or format and schema_version for
policies. For each head member: absence is missing_field, a wrong JSON type
is wrong_type, and another value is UnsupportedError. Unknown root members
therefore cannot mask an unsupported version. Unsupported integer digits are
preserved verbatim, including values too large for any Go integer.

Phase 3 walks depth first in the documented table order. For each object
it checks unknown members first (input order), missing members next (table
order), then each member's type followed by its value rule (table order),
then cross-member rules: saturation above cutoff, numerator below denominator,
and an edge list equal to the registered profile. Null is always wrong_type.
Each array checks count, then every element, then ascending order. Equal
neighbours are duplicate; a decrease is unsorted, located at the later element's
id, rule_id or edge index. Saturation cross-checks point to saturation_units,
fraction cross-checks to numerator, and edge mismatches to the whole edge_types
array. Kind units are checked before reading sources.

Errors wrap exactly one sentinel via Unwrap; use errors.Is and errors.As:

    ErrInvalidLimits  invalid caller bounds, phase 0
    ErrLimit          *LimitError: Bound, Max, input Offset
    ErrMalformed      *MalformedError: Problem, input Offset
    ErrUnsupported    *UnsupportedError: Field, Value, Supported
    ErrInvalid        *FieldError: Path, Violation

Bound is bytes, depth, members, elements, string_bytes or tokens. Problem is
bom, invalid_utf8, syntax, duplicate_key, not_unsigned_integer or trailing_data.
FieldError paths are RFC 6901 JSON Pointers (empty for the root, ~0 for ~,
~1 for /). The closed violation codes are:

    unknown_field  member not allowed at this position
    missing_field  required member absent
    wrong_type     wrong JSON type, including null
    unknown_value  string outside this position's closed vocabulary
    out_of_range   integer outside its domain, or failed numeric cross-check
    pattern        law_id outside its ASCII pattern
    count          array length outside its bounds
    unsorted       array ID below its predecessor
    duplicate      array ID equal to its predecessor
    mismatch       known value not allowed by its rule, kind, mode or profile

Error types, codes, paths and phase precedence are the contract. The order among
several violations within a phase follows this version's documented table order
and is pinned by tests, but is not a compatibility promise. Consumers must not
branch on which of several violations is reported. Error() wording and exact
diagnostic offsets are not compatibility promises; a BOM offset is 0 and a
bytes-limit offset is Max.

# Identity, local binding and exclusions

SHA256 hashes the content bytes exactly as supplied, not git hash-object's
object ID and not a Git "blob <size>\x00" header. It normalizes nothing: not
whitespace, line endings, key order, escapes or rational terms. Only accepted
artifacts get an identity. Digest.String returns 64 lowercase hexadecimal
digits, the same text form as ledger.Digest without importing that package. The
caller supplies immutable blob bytes, not a converted checkout. The repository's
LF checkout rule does not change the loader's byte contract.

Law.SHA256 supplies Core's field_law_sha256; ValidationPolicy.SHA256 supplies
validation_policy_hash. A consumer reads the policy only as the bytes Core
retains and binds by validation_policy_hash, never from a working-tree settings
file: it is not a second settings file. The consumer checks policy.SHA256 == the
manifest's validation_policy_hash (and law.SHA256 == its field_law_sha256 when
consuming the law), then uses the typed parameters. Core retains approved bytes
before referencing them in its activation record.

Core alone supplies activation_id, epoch, effective_sequence, sorted local
workspace/check/environment bindings, owner authorization, activation-request
and expected-manifest hashes, and not_before_utc_ns. Neither artifact may
carry these, grants, credentials or its own hash. The shared law additionally
refuses D47 values and validation_policy_hash. All are unknown_field, whether
at the root or nested. Effective sequence/time comes only from the actual Core
activation record, never the artifact or a planned instant.

# Compatibility and non-goals

This version reads law schema 1, evaluator 1, bounded_best_arrival/v1, and
policy schema 1, with the respective format strings above. Another head value is
explicitly unsupported, not reinterpreted. Version 1 is closed and never gains
optional members; additions require a new schema or evaluator alongside it.
A new kind, rule or kernel requires a new evaluator version. Later contract
versions must preserve the exact typed values and digests of these version-1
golden vectors and the evaluator semantics they identify. In those values
an empty edge_types array, as local/v1 requires, loads as an empty, non-nil
EdgeTypes slice; consumers test len(EdgeTypes) == 0. No upgrader converts an old
artifact to new semantics. Goldens include alternate whitespace/key-order/CRLF
identities and unsupported newer heads; their numeric candidates are test data,
not the owner's chosen law.

Loading does not execute a reducer, activate, approve, schedule, authorize,
retain or retrieve anything. There is no encoder, field engine or local
activation API. C4 can consume the policy without parsing the field law or
starting U1.E. A loaded artifact is not engine readiness or activation approval.
Consumers must wait for the owner's law-format freeze.

CONSTANTS

const (
	LawFormat    = "dwarf-harness/undercurrent-law"
	PolicyFormat = "dwarf-harness/validation-policy"
)
    Format strings distinguish the two independently loadable artifacts.


VARIABLES

var (
	// ErrInvalidLimits marks invalid host-selected bounds, checked before input.
	ErrInvalidLimits = errors.New("law: invalid load limits")
	// ErrLimit marks an input exceeding a parser bound; see LimitError.
	ErrLimit = errors.New("law: load limit exceeded")
	// ErrMalformed marks non-strict JSON; see MalformedError.
	ErrMalformed = errors.New("law: not strict JSON")
	// ErrUnsupported marks an unrecognized format, version or kernel.
	ErrUnsupported = errors.New("law: unsupported artifact")
	// ErrInvalid marks a version-1 field violation; see FieldError.
	ErrInvalid = errors.New("law: invalid artifact")
)

TYPES

type AgeRule string
    Vocabulary values are the wire strings. The empty string is never valid.

const (
	AgeRuleNone    AgeRule = "none"
	LinearPerDayV1 AgeRule = "linear_per_day/v1"
)
type Bound string
    Bound is bytes, depth, members, elements, string_bytes or tokens.

type Coupling struct {
	Profile   Profile
	Direction Direction
	EdgeTypes []EdgeType
}
    Coupling declares the registered profile and its ordered edge types.

type Digest [sha256.Size]byte
    Digest is SHA-256 over an artifact's exact content bytes, without a Git
    header.

func (d Digest) String() string
    String returns 64 lowercase hexadecimal digits, the manifest text form.

type Direction string
    Vocabulary values are the wire strings. The empty string is never valid.

const (
	DirectionLocal       Direction = "local"
	DependencyToConsumer Direction = "dependency_to_consumer"
	ResourceToConsumer   Direction = "resource_to_consumer"
)
type EdgeType string
    Vocabulary values are the wire strings. The empty string is never valid.

const (
	DeclaredDataflow      EdgeType = "declared_dataflow"
	RegisteredResourceUse EdgeType = "registered_resource_use"
	StaticDependency      EdgeType = "static_dependency"
)
type FieldError struct {
	Path      string
	Violation Violation
}
    FieldError locates a version-1 violation by RFC 6901 JSON Pointer. The empty
    Path names the root. Error text is not a compatibility contract.

func (e *FieldError) Error() string

func (e *FieldError) Unwrap() error

type Kernel string
    Vocabulary values are the wire strings. The empty string is never valid.

const BoundedBestArrivalV1 Kernel = "bounded_best_arrival/v1"
type Kind string
    Vocabulary values are the wire strings. The empty string is never valid.

const (
	Affordance           Kind = "affordance"
	DependencyStrain     Kind = "dependency_strain"
	EpistemicUncertainty Kind = "epistemic_uncertainty"
	Perturbation         Kind = "perturbation"
	ResourcePressure     Kind = "resource_pressure"
	Surprise             Kind = "surprise"
)
type KindLaw struct {
	ID              Kind
	QuantityClass   QuantityClass
	Unit            Unit
	Sources         []SourceLaw
	HopLatencyMS    int64
	AttenuationPPM  uint32
	CutoffUnits     uint64
	SaturationUnits uint64
}
    KindLaw declares a kind's unit, ordered sources and bounded numeric
    parameters.

type Law struct {
	SHA256           Digest
	SchemaVersion    uint32
	EvaluatorVersion uint32
	LawID            string
	LawVersion       uint32
	Kernel           Kernel
	WeightScalePPM   uint32
	Kinds            []KindLaw
}
    Law is a validated field law, not an activation or an approval.

func Load(data []byte, limits LoadLimits) (Law, error)
    Load reads one field-law artifact under explicit host-selected bounds.
    On error it returns the zero Law, never a partial value. On success it owns
    its strings and slices independently of data and of all other calls.

type LimitError struct {
	Bound  Bound
	Max    int
	Offset int64
}
    LimitError locates an exceeded inclusive parser bound. Offset is an input
    byte offset; for bytes it is Max.

func (e *LimitError) Error() string

func (e *LimitError) Unwrap() error

type LoadLimits struct {
	Bytes       int
	Depth       int
	Members     int
	Elements    int
	StringBytes int
	Tokens      int
}
    LoadLimits are inclusive, host-selected parser bounds. No zero field
    defaults. Every field must be positive and no larger than StandardV1's
    corresponding field. See the package documentation for counting rules.

func CompactV1() LoadLimits
    CompactV1 returns a fresh compact-v1 profile value.

func StandardV1() LoadLimits
    StandardV1 returns a fresh standard-v1 profile, the largest allowed bounds.

type MalformedError struct {
	Problem Problem
	Offset  int64
}
    MalformedError classifies a strict-JSON refusal. Offset is an input byte
    offset (zero for a BOM), not a stable diagnostic location across versions.

func (e *MalformedError) Error() string

func (e *MalformedError) Unwrap() error

type Mode string
    Vocabulary values are the wire strings. The empty string is never valid.

const (
	Impulse   Mode = "impulse"
	Level     Mode = "level"
	Sustained Mode = "sustained"
	Rising    Mode = "rising"
)
type Problem string
    Problem is bom, invalid_utf8, syntax, duplicate_key, not_unsigned_integer or
    trailing_data.

type Profile string
    Vocabulary values are the wire strings. The empty string is never valid.

const (
	LocalV1                     Profile = "local/v1"
	DependencyDownstreamV1      Profile = "dependency_downstream/v1"
	OverlapRelevanceV1          Profile = "overlap_relevance/v1"
	RegisteredResourceOutwardV1 Profile = "registered_resource_outward/v1"
)
type QuantityClass string
    Vocabulary values are the wire strings. The empty string is never valid.

const (
	Extensive  QuantityClass = "extensive"
	Evidential QuantityClass = "evidential"
)
type Rational struct{ Numerator, Denominator uint64 }
    Rational is an exact fraction with 0 < Numerator < Denominator. Equivalent
    fractions are not reduced: 1/20 and 2/40 remain distinct artifact spellings.

type RuleID string
    Vocabulary values are the wire strings. The empty string is never valid.

const (
	BaseStalenessV1                 RuleID = "base_staleness/v1"
	CanonicalChangeV1               RuleID = "canonical_change/v1"
	CheckDurationAnomalyV1          RuleID = "check_duration_anomaly/v1"
	CheckFlakinessV1                RuleID = "check_flakiness/v1"
	CheckOutcomeAnomalyV1           RuleID = "check_outcome_anomaly/v1"
	CheckQuarantineV1               RuleID = "check_quarantine/v1"
	CheckRetirementV1               RuleID = "check_retirement/v1"
	CoreBudgetExposureV1            RuleID = "core_budget_exposure/v1"
	CoreResourceUsageV1             RuleID = "core_resource_usage/v1"
	CoreRunnerQueueV1               RuleID = "core_runner_queue/v1"
	FederatedPerturbationV1         RuleID = "federated_perturbation/v1"
	PrivateOverlapV1                RuleID = "private_overlap/v1"
	PromotionOverlapV1              RuleID = "promotion_overlap/v1"
	ProviderStatusV1                RuleID = "provider_status/v1"
	RepairR2ImpulseV1               RuleID = "repair_r2_impulse/v1"
	RepairR3ImpulseV1               RuleID = "repair_r3_impulse/v1"
	RepairR3SustainedV1             RuleID = "repair_r3_sustained/v1"
	RouterHeadroomV1                RuleID = "router_headroom/v1"
	SharedResourcePressureAnomalyV1 RuleID = "shared_resource_pressure_anomaly/v1"
	ValidationF2ImpulseV1           RuleID = "validation_f2_impulse/v1"
	ValidationF2SustainedV1         RuleID = "validation_f2_sustained/v1"
	ValidationF3AttributedV1        RuleID = "validation_f3_attributed/v1"
)
type SourceLaw struct {
	RuleID          RuleID
	Mode            Mode
	Unit            Unit
	HalfLifeSeconds uint64
	AgeRuleID       AgeRule
	RiseUnitsPerDay uint64
	Coupling        Coupling
}
    SourceLaw selects a built-in evaluator rule; it contains no executable code.

type Unit string
    Vocabulary values are the wire strings. The empty string is never valid.

const (
	AffordanceUnits   Unit = "affordance_units"
	StrainUnits       Unit = "strain_units"
	UncertaintyUnits  Unit = "uncertainty_units"
	PerturbationUnits Unit = "perturbation_units"
	PressureUnits     Unit = "pressure_units"
	SurpriseUnits     Unit = "surprise_units"
)
type UnsupportedError struct {
	Field     string
	Value     string
	Supported string
}
    UnsupportedError reports a head value without interpreting it as version 1.
    Field is format, schema_version, evaluator_version or kernel. Value and
    Supported are decoded strings or integer digits, never rounded numbers.

func (e *UnsupportedError) Error() string

func (e *UnsupportedError) Unwrap() error

type ValidationPolicy struct {
	SHA256                  Digest
	SchemaVersion           uint32
	FlakeRatePrior          Rational
	FailureRepairConfidence Rational
	QuarantineThreshold     Rational
}
    ValidationPolicy is D47's local policy artifact. SHA256 is the manifest's
    validation_policy_hash; these values never enter the shared field law.

func LoadValidationPolicy(data []byte, limits LoadLimits) (ValidationPolicy, error)
    LoadValidationPolicy reads the exact bytes Core retains and binds by
    validation_policy_hash, not a working-tree settings file. The caller chooses
    the limits and verifies the manifest binding. Loading activates nothing.
    On any error it returns the zero ValidationPolicy.

type Violation string
    Violation is unknown_field, missing_field, wrong_type, unknown_value,
    out_of_range, pattern, count, unsorted, duplicate or mismatch.
```
