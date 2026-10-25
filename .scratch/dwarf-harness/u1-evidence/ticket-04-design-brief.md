# T04 brief: ticket 04 — load and identify a strict law independently of field execution

Designer: DesignT04, 2026-10-12. Status: ruled by the advisor on 2026-10-12, approve-with-changes; see [the ruling](ticket-04-design-ruling.md), which wins where the two differ. The owner approves the design before any code starts (ticket:65). Nothing below is decided until the advisor rules; the owner gates in §7.2 stay with the owner.

**Sources** are cited as `path:line` at `main` 818db9a. Abbreviations:
- "ticket" = `.scratch/dwarf-harness/issues/04-load-and-identify-a-strict-law-independently-of-field-execution.md`; "ticket 09/60/71" = the issues with those numbers;
- "U" = `docs/DESIGN-UNDERCURRENT.md`; "Core" = `docs/DESIGN-CORE-AND-LAUNCHERS.md`; "val" = `docs/RESEARCH-ADMISSIBLE-VALIDATION.md`;
- "RU" = `docs/ROADMAP-UNDERCURRENT.md`; "RC" = `docs/ROADMAP-CORE.md`; "R" = `docs/ROADMAPS.md`;
- "reg" = `docs/CONTRACTS.md`; "dec" = `docs/DECISIONS.md`; "spec" = `.scratch/dwarf-harness/spec.md`;
- "ledger/…" = `contract/ledger/…`; "check/…" = `tools/check/…`;
- "R1" = the runner probe of `encoding/json` on go1.27.2 (`agent://RunnerT04R1`; Appendix C).

The runner map `local://t04-map.md` served only as an index; every passage cited here was re-read. Values marked **(my choice)** are proposals, not source requirements. Rejection-case IDs (M, N, I, VP) are local to §4.

---

## 0. Owner summary

**What the package does.** It adds `contract/law`, a standard-library-only Go package that reads exactly two kinds of file:

1. **The shared field law**: the six field kinds, their built-in source rules and their numbers, as Undercurrent §13.4 specifies. Every rule and bound is checked. A file that is malformed, duplicated, unknown, unsorted, out of range or too large is refused whole, with a typed error naming the problem.
2. **The local validation policy**: your D47 values (flake-rate prior, confidence and quarantine threshold) as exact fractions, in a separate small file of the same strict kind. It never enters the shared law.

Each file is identified by the SHA-256 of its exact bytes, so a whitespace, key-order or line-ending change makes a different file. The host picks a size profile, compact-v1, standard-v1 or something tighter; nothing can widen it. Core's activation record, a later Core ticket, binds both identities. C4 reads its values through this package without the field engine.

**What it does not do.** It does not run or import the field engine. It activates, schedules and approves nothing, and it reads no clock, file or setting. It chooses no law values: the test files use §13.4's candidate numbers and the provisional 0.05, 0.999 and 0.20 as test data only, not as your law.

**Owner gates.**
- **OG-A: approve this design** before any coding (your instruction of 2026-10-12).
- **OG-B: a fourth validation value?** D47 names three values. Core's design also lists "at most 12 fresh executions per evidence incident" as a law parameter awaiting your U1.L approval. Recommendation: include it as a whole number in the same file, so that C4 never needs a second policy source. The alternative is D47's three values only.

**Later, not now.** Freezing law-format (D40) is a separate request after the build, with its own packet (§8). Until then the format is a draft and no consumer builds on it.

---

## 1. Owned paths

The coder creates or edits exactly these.

**S1 — the package** (all new):

```
contract/law/doc.go          package documentation: the format (§2.14)
contract/law/law.go          Law and its parts, vocabulary types and constants, Load
contract/law/registry.go     the evaluator-v1 registry tables (unexported)
contract/law/limits.go       LoadLimits, CompactV1, StandardV1
contract/law/walk.go         phase 1: the bounded token walk (§2.7)
contract/law/decode.go       phases 2-3: head checks and the strict v1 decode
contract/law/policy.go       ValidationPolicy, Rational, LoadValidationPolicy
contract/law/errors.go       sentinels, typed errors and their codes (§2.8)
contract/law/golden_test.go
contract/law/identity_test.go
contract/law/reject_test.go
contract/law/limits_test.go
contract/law/policy_test.go
contract/law/fuzz_test.go
contract/law/bench_test.go   (P21)
contract/law/example_test.go (package law_test)
contract/law/testdata/law/v1/full.json
contract/law/testdata/law/v1/full-compact.json
contract/law/testdata/law/v1/full-reordered.json
contract/law/testdata/law/v1/minimal.json
contract/law/testdata/law/v1/bounds.json
contract/law/testdata/law/unsupported/schema-version-2.json
contract/law/testdata/law/unsupported/evaluator-version-2.json
contract/law/testdata/law/unsupported/kernel-v2.json
contract/law/testdata/validation-policy/v1/policy.json
contract/law/testdata/validation-policy/unsupported/schema-version-2.json
contract/law/testdata/fuzz/Fuzz*/...   only failing inputs found by fuzzing, kept as seeds
```

The coder may merge or split the non-test `.go` files, because file names are not API. The testdata paths are exact, because `golden_test.go` pins them (§3).

**S2 — documents** (edits, §2.16):

```
docs/CONTRACTS.md             status line (:3) and the law-format row (:30)
docs/DECISIONS.md             one new entry, B«next», at the end
docs/ROADMAP-UNDERCURRENT.md  U1 status (:217)
docs/ROADMAPS.md              U1 row of the status board (:187)
docs/DESIGN-UNDERCURRENT.md   §13.4: one sentence appended to :456 (P22)
```

The PM writes ticket 04's comments.

**Not touched:**
- `contract/ledger/**`;
- `tools/check/**`, whose `contract/...` row already covers the new package (check/boundary.go:48);
- `go.mod`, `go.sum` and `.gitattributes`;
- `internal/**` and `cmd/**`.

No module is added (D29).

---

## 2. Exact behavior

### 2.1 Scope and gates

**What ticket 04 builds** (ticket:12, :29-33, :41; RU:172; U:429-462):
- strict loading, validation and exact-byte identity of the shared field law;
- the typed, versioned D47 parameters as a separate local artifact;
- the identities that Core's manifest binds;
- golden vectors;
- the register record of a draft contract.

**Gates** (ticket:16-25):
- *Owner-frozen `ledger-format`/`ledger-reader`* (ticket:22). Met by D111 (dec:1512); U1 is Ready (RU:217; R:187). This package consumes neither contract (P4).
- *Owner law-format freeze before any C4/U1.E consumer* (ticket:23, :25). Nothing here freezes; §8 is the later request. Until the freeze, the register shows Draft (§2.16) and no consumer may build on the contract (reg:19; D40 dec:206).
- *D52.* Not a gate of this ticket: ticket:22-23 list none, and D52 gates C2/C3 work (dec:340). Nothing here touches C2 or C3.
- *D41.* S1 and S2 touch no frozen contract and add no dependency (dec:213). They change no owner decision either, unless OG-B answers "include", which is then the owner's own decision. So `main` may move after the advisor's review and the check (D46 dec:300), once OG-A is given.
- *Testing-only boundary* (ticket:20). Unaffected: no workload runs.

**Not built here:**
- U1.E: the engine, projection, graph traversal, replay, arrival-kernel semantics, amplitudes and saturation capping (ticket 60; RU:172; U:462; P9).
- Source-rule reducers and their SOURCE-VALUES (ticket 71:41; U:448).
- Core C2: the `PolicyActivationManifest`; the activation request, record and event; retention of artifact bytes; owner authorization; not-before scheduling (reg:34; Core:868-870; ticket 09).
- C1: any activation event schema (reg:34; B2 dec:646).
- C4: reading the active manifest, rerun counts from the parameters, and check and environment hashes (RC:539; Core:886-892).
- Choosing or activating law or validation values (U:452, :464; D65 dec:463).
- A law encoder (P17) and an `internal/undercurrent/law` package (P18).
- The freeze request and its decision entry (§8).

### 2.2 Package and imports

- **Package:** `contract/law`, package `law`, with import path `github.com/Darius-PJ/dwarf-harness/contract/law` (reg:7; D45 dec:262; D43).
- **Imports:** the standard library only (reg:7; D45 dec:280), so no `contract/ledger` (P4) and nothing under `internal/`.
  - check/boundary.go:48 enforces this.
  - Its test refuses a contract that imports core or `golang.org/x` (check/boundary_test.go:186-190, :228-230).
- **Code:** no cgo, no OS-specific file and no `unsafe` (D28 dec:106; AGENTS.md "Go commands").
- **JSON reader:** `encoding/json`'s `Decoder.Token`, the house reader (ledger/envelope.go:511-559), not `encoding/json/v2` (P21; R1).

### 2.3 Public API

```go
package law

// Format strings of the two artifacts this package reads.
const (
	LawFormat    = "dwarf-harness/undercurrent-law"  // U:431
	PolicyFormat = "dwarf-harness/validation-policy" // P2 (my choice)
)

// Digest is the SHA-256 of an artifact's exact bytes. String returns 64
// lowercase hex digits, the text form of ledger.Digest.
type Digest [sha256.Size]byte

func (d Digest) String() string

// LoadLimits are the host-selected parser bounds, U:454's LawLoadLimits.
type LoadLimits struct {
	Bytes       int // bytes of the whole input
	Depth       int // nesting depth of objects and arrays; the root is depth 1
	Members     int // members of any one object
	Elements    int // elements of any one array
	StringBytes int // UTF-8 bytes of any one decoded string, keys included
	Tokens      int // JSON tokens of the whole input
}

func CompactV1() LoadLimits  // {65536, 12, 64, 128, 128, 2048}
func StandardV1() LoadLimits // {262144, 16, 128, 256, 256, 8192}

// Load reads one field-law artifact. On any error it returns the zero Law.
func Load(data []byte, limits LoadLimits) (Law, error)

// LoadValidationPolicy reads one validation-policy artifact. On any error it
// returns the zero ValidationPolicy.
func LoadValidationPolicy(data []byte, limits LoadLimits) (ValidationPolicy, error)

type Law struct {
	SHA256           Digest    // field_law_sha256 (U:456)
	SchemaVersion    uint32    // 1
	EvaluatorVersion uint32    // 1
	LawID            string    // a label, never identity (U:431)
	LawVersion       uint32    // a label, never identity
	Kernel           Kernel    // BoundedBestArrivalV1
	WeightScalePPM   uint32    // 1000000
	Kinds            []KindLaw // the six kinds, ascending by ID
}

type KindLaw struct {
	ID              Kind
	QuantityClass   QuantityClass
	Unit            Unit
	Sources         []SourceLaw // 1..8, ascending by RuleID
	HopLatencyMS    int64
	AttenuationPPM  uint32
	CutoffUnits     uint64
	SaturationUnits uint64
}

type SourceLaw struct {
	RuleID          RuleID
	Mode            Mode
	Unit            Unit
	HalfLifeSeconds uint64
	AgeRuleID       AgeRule
	RiseUnitsPerDay uint64
	Coupling        Coupling
}

type Coupling struct {
	Profile   Profile
	Direction Direction
	EdgeTypes []EdgeType // 0..2, ascending
}

type ValidationPolicy struct {
	SHA256                  Digest // validation_policy_hash (U:456)
	SchemaVersion           uint32 // 1
	FlakeRatePrior          Rational
	FailureRepairConfidence Rational
	QuarantineThreshold     Rational
	// Only if OG-B answers "include":
	// MaxFreshExecutionsPerIncident uint32
}

// Rational is an exact fraction with 0 < Numerator < Denominator.
type Rational struct{ Numerator, Denominator uint64 }

// Vocabulary. Each type's values are exactly the wire strings; "" is never valid.
type (
	Kind          string
	QuantityClass string
	Unit          string
	Mode          string
	RuleID        string
	AgeRule       string
	Profile       string
	Direction     string
	EdgeType      string
	Kernel        string
)
```

**Exported constants** (P7). Each constant's value is the wire string of §2.4 and §2.5:

| Type | Constants |
|---|---|
| `Kind` | `Affordance`, `DependencyStrain`, `EpistemicUncertainty`, `Perturbation`, `ResourcePressure`, `Surprise` |
| `QuantityClass` | `Extensive`, `Evidential` |
| `Unit` | `AffordanceUnits`, `StrainUnits`, `UncertaintyUnits`, `PerturbationUnits`, `PressureUnits`, `SurpriseUnits` |
| `Mode` | `Impulse`, `Level`, `Sustained`, `Rising` |
| `AgeRule` | `AgeRuleNone` (`none`), `LinearPerDayV1` (`linear_per_day/v1`) |
| `Profile` | `LocalV1`, `DependencyDownstreamV1`, `OverlapRelevanceV1`, `RegisteredResourceOutwardV1` |
| `Direction` | `DirectionLocal` (`local`), `DependencyToConsumer`, `ResourceToConsumer` |
| `EdgeType` | `DeclaredDataflow`, `RegisteredResourceUse`, `StaticDependency` |
| `Kernel` | `BoundedBestArrivalV1` |
| `RuleID` | one per registry row of §2.5, named by the ID's words in CamelCase plus its version, e.g. `RouterHeadroomV1` = `router_headroom/v1`, `SharedResourcePressureAnomalyV1` |

**API rules:**
- The loaders are pure. They use no I/O, clock, environment, goroutine or package-level mutable state, and are safe for concurrent use (RC:15: "Never let a component read the wall clock inside anything that must be replayable").
- A result never aliases `data`, and its slices are fresh on each call.
- The profiles are functions that return values, so no importer can widen a shared variable (P10).

### 2.4 The field-law artifact, version 1

The artifact is "one strict UTF-8 JSON object" (U:431). Every member is required and no other member is allowed: "No omitted field receives a default" (U:431, :450). Member order is free.

In these tables the row order is the check order of §2.7. The head members (`format`, `schema_version`, `evaluator_version`, `kernel`) come first because phase 2 checks them; U:431 lists the same members.

**Root object** (U:431):

| Member | JSON type | Rule | Violation |
|---|---|---|---|
| `format` | string | `dwarf-harness/undercurrent-law` | other string: unsupported |
| `schema_version` | integer | 1 | other integer: unsupported |
| `evaluator_version` | integer | 1 | other integer: unsupported |
| `kernel` | string | `bounded_best_arrival/v1` (U:155) | other string: unsupported |
| `law_id` | string | matches `^[a-z0-9][a-z0-9._-]{0,63}$` | `pattern` |
| `law_version` | integer | 1..2,147,483,647 | `out_of_range` |
| `weight_scale_ppm` | integer | exactly 1,000,000 (U:448: "no ... configurable scale") | `out_of_range` |
| `kinds` | array of kind objects | exactly 6; strictly ascending by `id` | `count`; `unsorted`/`duplicate` |

**Kind object** (U:433, :450):

| Member | JSON type | Rule | Violation |
|---|---|---|---|
| `id` | string | one of the six kinds (§2.5) | `unknown_value` |
| `quantity_class` | string | `extensive` or `evidential`, for any kind (P8) | `unknown_value` |
| `unit` | string | the kind's unit (§2.5) | `unknown_value` if not a unit; `mismatch` if another kind's |
| `sources` | array of source objects | 1..8; strictly ascending by `rule_id` | `count`; `unsorted`/`duplicate` |
| `hop_latency_ms` | integer | 0..86,400,000 | `out_of_range` |
| `attenuation_ppm` | integer | 1..999,999 | `out_of_range` |
| `cutoff_units` | integer | 1..1,000,000,000,000 | `out_of_range` |
| `saturation_units` | integer | 1..1,000,000,000,000, and above `cutoff_units` | `out_of_range` |

**Source object** (U:433, :448, :450):

| Member | JSON type | Rule | Violation |
|---|---|---|---|
| `rule_id` | string | registered, and registered for the enclosing kind (§2.5) | `unknown_value`; `mismatch` |
| `mode` | string | `impulse`, `level`, `sustained` or `rising`, and the rule's mode | `unknown_value`; `mismatch` |
| `unit` | string | a registered unit, and the enclosing kind's unit | `unknown_value`; `mismatch` |
| `half_life_seconds` | integer | impulse: 1..31,536,000; other modes: 0 | `out_of_range` |
| `age_rule_id` | string | `none` or `linear_per_day/v1`; rising takes `linear_per_day/v1`, other modes `none` | `unknown_value`; `mismatch` |
| `rise_units_per_day` | integer | rising: 1..1,000,000,000,000; other modes: 0 | `out_of_range` |
| `coupling` | object | below | — |

**Coupling object** (U:433, :448):

| Member | JSON type | Rule | Violation |
|---|---|---|---|
| `profile` | string | one of the four profiles, and the rule's profile | `unknown_value`; `mismatch` |
| `direction` | string | `local`, `dependency_to_consumer` or `resource_to_consumer`, and the profile's direction | `unknown_value`; `mismatch` |
| `edge_types` | array of strings | 0..2 elements, each an edge type, strictly ascending, and equal to the profile's list | `count`; `unknown_value`; `unsorted`/`duplicate`; `mismatch` |

"`kinds`, `sources`, and `edge_types` are sorted by stable ASCII IDs and contain no duplicates" (U:450): IDs are compared byte by byte. Every ID is ASCII, so this is ASCII order.

### 2.5 The evaluator-v1 registry

**Kinds and units.** U:433 lists the units "respectively". In the ascending order of the kind IDs, each unit is named after its kind:

| Kind | Unit |
|---|---|
| `affordance` | `affordance_units` |
| `dependency_strain` | `strain_units` |
| `epistemic_uncertainty` | `uncertainty_units` |
| `perturbation` | `perturbation_units` |
| `resource_pressure` | `pressure_units` |
| `surprise` | `surprise_units` |

**Rules** (U:437-442), in the order the artifact requires. U:441 lists perturbation's rules unsorted; the artifact must not.

| Kind | Rule | Mode | Profile |
|---|---|---|---|
| affordance | `repair_r2_impulse/v1` | impulse | `dependency_downstream/v1` |
| affordance | `repair_r3_impulse/v1` | impulse | `dependency_downstream/v1` |
| affordance | `repair_r3_sustained/v1` | sustained | `dependency_downstream/v1` |
| dependency_strain | `validation_f2_impulse/v1` | impulse | `local/v1` |
| dependency_strain | `validation_f2_sustained/v1` | sustained | `local/v1` |
| dependency_strain | `validation_f3_attributed/v1` | sustained | `dependency_downstream/v1` |
| epistemic_uncertainty | `base_staleness/v1` | rising | `local/v1` |
| epistemic_uncertainty | `check_flakiness/v1` | level | `local/v1` |
| epistemic_uncertainty | `check_quarantine/v1` | level | `local/v1` |
| epistemic_uncertainty | `check_retirement/v1` | level | `local/v1` |
| epistemic_uncertainty | `private_overlap/v1` | level | `local/v1` |
| epistemic_uncertainty | `promotion_overlap/v1` | impulse | `overlap_relevance/v1` |
| perturbation | `canonical_change/v1` | impulse | `dependency_downstream/v1` |
| perturbation | `federated_perturbation/v1` | impulse | `dependency_downstream/v1` |
| perturbation | `provider_status/v1` | level | `dependency_downstream/v1` |
| resource_pressure | `core_budget_exposure/v1` | level | `registered_resource_outward/v1` |
| resource_pressure | `core_resource_usage/v1` | level | `registered_resource_outward/v1` |
| resource_pressure | `core_runner_queue/v1` | level | `registered_resource_outward/v1` |
| resource_pressure | `router_headroom/v1` | level | `registered_resource_outward/v1` |
| surprise | `check_duration_anomaly/v1` | impulse | `local/v1` |
| surprise | `check_outcome_anomaly/v1` | impulse | `local/v1` |
| surprise | `shared_resource_pressure_anomaly/v1` | impulse | `local/v1` |

**Profiles** (U:448):

| Profile | Direction | Edge types |
|---|---|---|
| `dependency_downstream/v1` | `dependency_to_consumer` | `declared_dataflow`, `static_dependency` |
| `local/v1` | `local` | none |
| `overlap_relevance/v1` | `dependency_to_consumer` | `declared_dataflow`, `static_dependency` |
| `registered_resource_outward/v1` | `resource_to_consumer` | `registered_resource_use` |

**Edge types:** exactly `declared_dataflow`, `registered_resource_use` and `static_dependency`. Any other string, such as an encounter relation, is an `unknown_value`: "Unknown, extra, mismatched or encounter-edge references reject the whole law" (U:448; encounter geometry U:167, :178).

**Absent on purpose:** `validation_f1_unconfirmed/v1` (U:446) and R1's scheme name `router-headroom/v1`, with a hyphen (U:444; reg:63; B10 dec:715). Both are an `unknown_value`.

An owner may omit any rule, but each kind still needs at least one source (U:448).

### 2.6 Load limits

| Bound | compact-v1 | standard-v1 | What is counted |
|---|---|---|---|
| `Bytes` | 65,536 | 262,144 | `len(data)` |
| `Depth` | 12 | 16 | nesting of objects and arrays: the root container is depth 1 and each container inside another is one deeper; scalars do not count |
| `Members` | 64 | 128 | name/value pairs of any one object |
| `Elements` | 128 | 256 | values of any one array |
| `StringBytes` | 128 | 256 | UTF-8 bytes of any one string's decoded value, keys included |
| `Tokens` | 2,048 | 8,192 | over the whole input: `{`, `}`, `[`, `]`, keys, strings, numbers, `true`, `false` and `null`, i.e. the values `json.Decoder.Token` returns. Commas, colons and whitespace are not tokens |

The numbers come from U:454 and ticket:41; the counting definitions are P11.

**Rules** (U:454; ticket:41):
- Every bound is inclusive: a count equal to the bound passes.
- The host chooses the limits; an artifact never supplies them. Both loaders take them as an argument and apply no default (P10).
- Valid limits have every field in 1..standard-v1's value for that field. Anything else makes both loaders return an error wrapping `ErrInvalidLimits` before reading `data`: a zero `LoadLimits`, any zero or negative field, or any field above standard-v1. compact-v1 and any field-by-field tightening are valid. Within version 1 of the contract, limits therefore tighten but never widen, silently or otherwise.
- The validation policy uses the same limits (P10).

**Facts the tests rely on**, derived by hand, not by the loader:
- `full.json` (§3) has:
  - depth 7, at `/kinds/i/sources/j/coupling/edge_types`;
  - at most 8 members, in the root and each kind;
  - at most 6 elements, in `kinds` and in epistemic_uncertainty's sources;
  - a longest string of 35 bytes, `shared_resource_pressure_anomaly/v1`;
  - 681 tokens.
- Token formula:
  - The root costs 19 tokens: 8 keys, 7 scalars and 4 delimiters.
  - Each kind costs 19: 8 keys, 7 scalars and 4 delimiters.
  - Each source costs 24 + e, where e is its number of edge types: 10 keys, 8 scalars and 6 delimiters, plus the edge types.
  - With 22 sources and 20 edge types in all: 19 + 6·19 + 22·24 + 20 = 681.
- A valid version-1 law never has more than depth 7, 8 members, 6 elements, 64-byte strings or 681 tokens. It can therefore exceed compact-v1 only in bytes, and only whitespace can inflate it there.
- A valid policy has depth 2, at most 6 members, strings of at most 33 bytes and at most 29 tokens.
- The fuzz properties of §4 rely on these facts.

### 2.7 Loading: phases, order and atomic rejection

Both loaders run the same phases. The first violation ends the load: the call returns the zero value and the error, never a partial result, and has no side effect. U:454: "Exceeding any bound rejects the whole artifact before activation; no truncation or partial parse."

**Phase 0 — limits.** Invalid limits return `ErrInvalidLimits` (§2.6).

**Phase 1 — strict JSON.** The same for both artifacts, in this order:
1. `len(data)` above `Bytes`: `*LimitError{bytes}`. Nothing else is read, so nothing is truncated.
2. `data` begins with the UTF-8 byte-order mark EF BB BF: `*MalformedError{bom}`.
3. `data` is not valid UTF-8: `*MalformedError{invalid_utf8}`. This check runs before any decoding, because `encoding/json` silently replaces invalid UTF-8 with U+FFFD (R1).
4. A token walk in input order. At each token, these checks run in order:
   - a syntax error, including empty or whitespace-only input: `syntax`;
   - the token count above `Tokens`: `tokens`;
   - a container opened deeper than `Depth`: `depth`;
   - a key that takes its object's members above `Members`: `members`;
   - a value that takes its array's elements above `Elements`: `elements`;
   - a key or string whose decoded value is longer than `StringBytes`: `string_bytes`;
   - a key equal to an earlier key of the same object, comparing decoded keys: `duplicate_key`;
   - a number token that is not unsigned digits, such as one with a sign, fraction or exponent (P12): `not_unsigned_integer`.

   The bound findings are `*LimitError`; the others are `*MalformedError`.
5. After the root value, any byte other than JSON whitespace (space, tab, LF, CR): `*MalformedError{trailing_data}`.

Phase 1 also covers unknown members, so a duplicate key or a decimal is refused wherever it appears.

**Phase 2 — head.**
- The root must be an object; otherwise `*FieldError{"", wrong_type}`.
- Then each head member, in turn: for the law `format`, `schema_version`, `evaluator_version` and `kernel`; for the policy `format` and `schema_version`.
- For each: absent gives `missing_field`, a wrong JSON type gives `wrong_type`, and any other value gives `*UnsupportedError`.
- These checks precede every other version-1 rule, so a newer artifact is reported as unsupported even when it carries members version 1 does not know (P14).

**Phase 3 — strict version-1 decode.** The decode walks the document depth first, in the row order of the tables in §2.4 and §2.10.

For each object:
1. unknown members: the first one in input order gives `unknown_field`;
2. missing members, in table order: `missing_field`;
3. each member in table order: its JSON type first (`wrong_type`; `null` is a wrong type), then its value rule;
4. the object's cross-member rules, after its members: `saturation_units` above `cutoff_units`, and `numerator` below `denominator`.

For each array:
1. the element count (`count`);
2. every element, in order;
3. strict ascending order of the element IDs. A repeat is `duplicate` and a decrease is `unsorted`, reported at the element's ID path, as ledger/digest.go's `checkDigests` reports "not above the one before it".

Within a source, the table order puts the registry checks before the mode-dependent ones. A change to a rule's mode alone is therefore reported at `mode`, not at `half_life_seconds`.

Paths are JSON Pointers (RFC 6901): `""` is the root and `/kinds/2/sources/0/mode` a member.

### 2.8 Errors

Each error wraps exactly one sentinel. `errors.Is` matches the sentinel and `errors.As` the typed error, the house pattern of ledger/errors.go. `Error()` text is not part of the contract.

```go
var (
	ErrInvalidLimits = errors.New("law: invalid load limits")  // phase 0: the caller's limits
	ErrLimit         = errors.New("law: load limit exceeded")  // *LimitError
	ErrMalformed     = errors.New("law: not strict JSON")      // *MalformedError
	ErrUnsupported   = errors.New("law: unsupported artifact") // *UnsupportedError
	ErrInvalid       = errors.New("law: invalid artifact")     // *FieldError
)

type LimitError struct {
	Bound  Bound
	Max    int   // the bound's value in the limits used
	Offset int64 // input offset where it was exceeded; Max for bytes
}

type MalformedError struct {
	Problem Problem
	Offset  int64 // input offset where the problem was found
}

type UnsupportedError struct {
	Field     string // "format", "schema_version", "evaluator_version" or "kernel"
	Value     string // the artifact's value: the decoded string or the integer's digits
	Supported string // what this contract version reads, e.g. "1"
}

type FieldError struct {
	Path      string // JSON Pointer of the offending member or element
	Violation Violation
}

type Bound string     // "bytes", "depth", "members", "elements", "string_bytes", "tokens"
type Problem string   // "bom", "invalid_utf8", "syntax", "duplicate_key", "not_unsigned_integer", "trailing_data"
type Violation string // below
```

| Violation | Meaning |
|---|---|
| `unknown_field` | a member not defined at this position |
| `missing_field` | a required member is absent |
| `wrong_type` | the JSON type differs; `null` is a wrong type |
| `unknown_value` | a string outside this position's closed set |
| `out_of_range` | an integer outside its range, not above the member it must exceed, or unequal to a fixed value |
| `pattern` | `law_id` does not match its pattern |
| `count` | an array's length is outside its bounds |
| `unsorted` | an array element sorts below the one before it |
| `duplicate` | an array element equals the one before it |
| `mismatch` | a valid value that the registry, the profile or the mode does not allow here |

Ticket:29's categories map onto these as follows:
- malformed: `ErrMalformed`, plus `wrong_type`, `missing_field` and `unknown_field`;
- duplicate: `duplicate_key` and `duplicate`;
- unsupported: `ErrUnsupported` and `unknown_value`;
- unsorted: `unsorted`;
- boundary-exceeding: `ErrLimit`, `out_of_range`, `count` and `pattern`.

### 2.9 Identity

- `Law.SHA256` is the SHA-256 of `data` exactly as passed, which is the exact immutable Git-blob content approved for the artifact (U:456; B12 dec:737; ticket:30, :41). In detail:
  - it covers no Git object header (P5);
  - nothing is normalized first: not whitespace, line endings, key order or escapes, and nothing is re-encoded;
  - the artifact holds no hash member; a `field_law_sha256` member is an `unknown_field` (U:456).
- `ValidationPolicy.SHA256` follows the same rule (P3).
- Only an accepted artifact gets an identity; a rejected one returns the zero value.
- Identical bytes therefore give identical digests. A whitespace, key-order or line-ending change gives another digest while the typed value stays the same (U:456: such changes "require a new approval/activation").
- `law_id` and `law_version` are labels, never identity (U:431).
- The caller must supply the blob's bytes, not a converted checkout. In this repository B1 (dec:231) and `.gitattributes` (`* text=auto eol=lf`) make a text file's checkout bytes equal its blob bytes. V6 confirms this for the goldens.

### 2.10 The validation policy (D47), version 1

The policy is a separate local artifact (P1, P2). It follows the law's phases, limits, errors and identity rule.

**Root object:**

| Member | JSON type | Rule | Source |
|---|---|---|---|
| `format` | string | `dwarf-harness/validation-policy`; any other string is unsupported | P2 **(my choice)** |
| `schema_version` | integer | 1; any other integer is unsupported | P2 |
| `flake_rate_prior` | rational | below | D47 dec:306; U:456 |
| `failure_repair_confidence` | rational | below | U:456 ("failure/repair confidence"); val:182, :359 |
| `quarantine_threshold` | rational | below | D47 dec:306; U:456 |
| `max_fresh_executions_per_incident` | integer | 1..2,147,483,647; **only if OG-B answers "include"** | Core:892; val:394 |

**Rational object.** `numerator` and `denominator` are both integers in 1..18,446,744,073,709,551,615, the `uint64` range. `numerator` must be below `denominator`; otherwise `out_of_range` at `numerator`. Source, U:456: "`numerator` and `denominator` are positive integers with numerator less than denominator".

Notes:
- Equal fractions in different terms are different artifacts, such as 1/20 and 2/40. There is no lowest-terms rule (P2).
- There is no `policy_id` or label; the identity is the digest (D65 dec:463, "each exact validation-policy version").
- A consumer reads this artifact only as the exact bytes Core retained and bound for the active activation, never from a working-tree settings file (U:456: "not a second settings file"; Core:868). The package doc says so; Core enforces it.

### 2.11 The local-manifest binding surface

Ticket:31 asks the contract to supply "typed versioned D47 parameters and local-manifest bindings to a C4-facing consumer". It supplies these:

- **The two identities.** `Law.SHA256` is the manifest's `field_law_sha256`, and `ValidationPolicy.SHA256` its `validation_policy_hash` (U:456; U:392).
  - Both are SHA-256 digests of the exact bytes Core retains before referencing them (Core:868).
  - A content-addressed copy of those bytes therefore verifies by the same digest, as the body store's digests (B21) would. **[INFERENCE: how Core retains the bytes is Core's choice.]**
- **The typed parameters:** `ValidationPolicy` and its fields (§2.3, §2.10).
- **Everything else the manifest binds belongs to Core or C4** (U:456; Core:868):
  - `activation_id`, `epoch` and `effective_sequence`;
  - the workspace IDs with their check-policy and execution-environment hashes;
  - the owner-authorization reference;
  - the activation-request and expected-manifest hashes;
  - `not_before_utc_ns`.

  C2 owns the manifest and C1 its encoding (reg:34; B12 dec:737). This package defines none of these, and neither artifact may contain them (§2.12).
- **The effective-sequence handoff** (RU:172). The effective sequence comes only from Core's activation record (U:458). `Law` has no sequence or time member, and the loader refuses an `effective_sequence` member.
- **A C4-facing consumer** does four things:
  1. take the bytes Core retained under the active manifest's `validation_policy_hash`;
  2. call `LoadValidationPolicy` with the host's limits;
  3. use the typed fractions;
  4. bind the manifest's identities into each attempt (U:456).

  It never parses the field law or starts the engine (B2 dec:647; U:462). `ExampleLoadValidationPolicy` shows this flow (§4).

### 2.12 What neither artifact may hold

- A member outside an artifact's table is an `unknown_field`. The field law therefore cannot carry any of these (U:456, :458; U:386-399; ticket:32, :41; B12 dec:737):
  - workspace IDs or workspace-policy lists;
  - check-policy or execution-environment hashes;
  - the validation-policy hash, or its own hash;
  - grants or credentials;
  - an activation ID, an owner-approval reference, an epoch, an effective sequence or a not-before time;
  - activation-request or expected-manifest hashes;
  - D47's values.
- The validation policy refuses the same members, except its own D47 values.
- Loading authorizes and executes nothing. No function takes an authority, writes, schedules or reads time. A loaded value is neither engine readiness nor activation approval (spec:595; U:464; ticket:23, :32).

### 2.13 Versions and compatibility (ticket:33)

- **What version 1 reads.**
  - A law with `format` `dwarf-harness/undercurrent-law`, `schema_version` 1, `evaluator_version` 1 and `kernel` `bounded_best_arrival/v1`.
  - A policy with `format` `dwarf-harness/validation-policy` and `schema_version` 1.
  - Any other value in those members is an `*UnsupportedError`, found before any other version-1 rule. A newer artifact therefore "fail[s] clearly, never reinterpret[ed]" (U:460), and an unsupported kernel is refused explicitly (U:155).
- **Additive change.** Version 1 refuses unknown members (U:454), so it never gains optional members.
  - Additions arrive as new schema or evaluator versions beside version 1. A new kind, rule or kernel needs a new evaluator version (U:460).
  - A later contract version must still load every version-1 golden to the same typed value and digest. These goldens, with their pinned digests and expected values, are the compatibility vectors; changing one fails `golden_test.go` (reg:8).
  - No upgrader converts an old artifact to new semantics (U:460).
  - How D40's "new optional fields … with upgraders" (reg:16) applies to a strict format goes to the owner at the freeze (§8, question 2).
- **Old evaluator semantics.** A `Law` carries `EvaluatorVersion`, and consumers select semantics by it. The package documents evaluator v1's registry; the semantics themselves belong to U1.E (ticket 60).
- **Implementation versus freeze.**
  - The package doc opens with "a draft until the owner's freeze (D40)", as ledger/doc.go:4 did.
  - The register row becomes *Draft*, version "—" (reg:15).
  - The decision entry states that nothing is frozen (§2.16).
  - The freeze is the owner's later decision (§8).

### 2.14 Package documentation

`doc.go` is the format, as ledger/doc.go:4 is ("this documentation is the format"). In order, it covers:
1. what the package is, and that version 1 is a draft until the owner's freeze (D40);
2. the field-law tables (§2.4) and the registry (§2.5);
3. the validation-policy table (§2.10);
4. the load limits: profiles, counting and tightening (§2.6);
5. phases, order, atomic rejection, and the error types and codes (§2.7, §2.8);
6. identity, the binding surface and the exclusions (§2.9, §2.11, §2.12);
7. versions and compatibility (§2.13);
8. what loading is not: activation, approval or engine readiness (ticket:23; spec:595).

### 2.15 Implementation constraints

1. Check that the whole input is valid UTF-8 before tokenizing. `encoding/json` silently turns invalid bytes into U+FFFD (R1).
2. Never decode with `json.Unmarshal` into Go structs. Its key matching ignores case, so `LAW_ID` would fill `LawID`. Match decoded keys exactly.
3. Detect duplicate keys by comparing decoded keys, as ledger/envelope.go:511-559 does. `Decoder.Token` returns a repeated key and decodes escapes, so `"\u0061"` repeats `"a"` (R1).
4. Parse integers from the token's digits with overflow checks, as `parseNat` does (ledger/envelope.go:436); never through `float64`.
5. Choose the reported error deterministically: no map iteration may decide which violation is reported.
6. Keep no package-level mutable state. The registry tables are unexported and never written.
7. Read no clock, file or environment variable; start no goroutine; use no `unsafe`.

*Implementation note, not mandated:* phase 1 may build a small ordered tree, bounded by `Tokens`, for phases 2 and 3 to walk. Alternatively, phase 3 may extend the members-accessor pattern of ledger/records.go:206-232 to refuse unknown members and keep their input order.

### 2.16 Documents (S2)

- **`docs/CONTRACTS.md`**
  - **:3.** Prepend "2026-10-«D» (U1.L drafts `law-format`, ticket 04; not frozen);". Replace "the other three contracts remain *Not started*" with "`law-format` is *Draft* (ticket 04); `launcher-protocol` and `context-module` remain *Not started*".
  - **:30.** Change the Status from `Not started` to `Draft`; the Version stays `—`. Append to Defines: "`contract/law` defines two artifacts: the shared field law (`dwarf-harness/undercurrent-law`, schema and evaluator version 1) and the local validation policy (`dwarf-harness/validation-policy`, schema version 1), which holds D47's parameters as exact fractions [and the per-incident execution cap, OG-B]. Each is identified by the SHA-256 of its exact bytes."
- **`docs/DECISIONS.md`.** Append B«next», "U1.L: law-format version 1, the validation policy and their identities". Decided by: assistant, within the owner's delegated build authority, as for B18 and B21 (dec:1187, :1372). The entry contains:
  - **Question:** what U:429-470, D47 and B12 leave open.
  - **Decision:** the ruled P-choices, grouped as follows: package; field-law encoding and registry; limits and counting; phases and errors; identity; validation policy; binding and exclusions; versions; goldens and tests.
  - **Owner answers:** OG-A and OG-B, in his own words (AGENTS.md "Decision records").
  - **Reasons.**
  - **Limits:**
    - Nothing is frozen; `law-format` stays Draft, version "—".
    - U1.L is not Done until the owner freezes the contract (RU:215).
    - There is no engine, activation, C4 or Core dependency.
    - The golden values are candidates, not the owner's law.
    - Verified on Windows; compiled for Linux and macOS.
  - **Changes.**
  - **Evidence:** the §5 results and the golden digests.
- **`docs/ROADMAP-UNDERCURRENT.md`:217.** "**Status.** In progress (2026-10-«D»: U1.L's `law-format` is drafted in `contract/law`, ticket 04, and awaits the owner's freeze; U1.E has not started. C1's `ledger-format` and `ledger-reader` were frozen on 2026-10-10, D111)."
- **`docs/ROADMAPS.md`:187.** U1's status changes from `Ready` to `In progress`, in the same commit (RU:164).
- **`docs/DESIGN-UNDERCURRENT.md`:456.** After "…not a second settings file.", append: "`contract/law` defines that policy's strict JSON form and its identity, the SHA-256 of its exact bytes, beside the field law (ticket 04, B«next»)."

---

## 3. Golden vectors and testdata layout

The layout is by artifact, then version (reg:7; D45 dec:274). Every file is hand-written; there is no encoder and no `-update` flag (P15, P17).

**Formatting rule**, so that anyone can reproduce the vectors:
- `full.json`, `minimal.json`, `bounds.json`, the unsupported vectors and `policy.json` are the output of `json.Indent(dst, compact, "", "  ")`, with members in table order (§2.4, §2.10), followed by one LF.
- `full-compact.json` is `json.Compact` of `full.json`, with no trailing LF.
- `full-reordered.json` keeps `full.json`'s formatting but reverses the member order of every object. Array order is unchanged.

`golden_test.go` pins each file's SHA-256. The values are computed independently with `Get-FileHash` (V7).

| File | Content | Proves | Expected |
|---|---|---|---|
| `law/v1/full.json` | every registered rule, with §13.4's candidate values (below) | a complete valid artifact loads into the typed registry (AC1); compatibility vector (AC5) | loads under both profiles to `expectedFull` |
| `law/v1/full-compact.json` | `json.Compact(full.json)` | a whitespace change alters identity, not meaning (AC2) | `expectedFull` with another digest |
| `law/v1/full-reordered.json` | every object's members reversed | a key-order change alters identity, not meaning (AC2) | `expectedFull` with another digest |
| CRLF variant of `full.json`, built in the test | `bytes.ReplaceAll(full, "\n", "\r\n")` | a line-ending change alters identity, not meaning (AC2) | `expectedFull` with another digest |
| `law/v1/minimal.json` | one source per kind; every range at its minimum | omitting rules is valid; each kind keeps one source; minima are inclusive | `expectedMinimal` |
| `law/v1/bounds.json` | every range at its maximum; a 64-byte `law_id` | maxima are inclusive | `expectedBounds` |
| `law/unsupported/schema-version-2.json` | `full.json` with `schema_version` 2 and an extra member `"added_in_schema_2": 1` | a newer schema fails clearly, before any unknown-member check (AC5; U:460) | `*UnsupportedError{schema_version}` |
| `law/unsupported/evaluator-version-2.json` | `full.json` with `evaluator_version` 2 | a newer evaluator fails clearly (AC5) | `*UnsupportedError{evaluator_version}` |
| `law/unsupported/kernel-v2.json` | `full.json` with `kernel` `bounded_best_arrival/v2` | an unsupported kernel is refused explicitly (U:155) | `*UnsupportedError{kernel}` |
| `validation-policy/v1/policy.json` | val:394's provisional values 1/20, 999/1000 and 1/5 [and 12, OG-B] | typed D47 parameters (AC3) | `expectedPolicy` |
| `validation-policy/unsupported/schema-version-2.json` | `policy.json` with `schema_version` 2 and an extra member `"added_in_schema_2": 1` | a newer policy schema fails clearly (AC5) | `*UnsupportedError{schema_version}` |

**`full.json`** has `law_id` `golden.full` and `law_version` 1.
- Every kind has `hop_latency_ms` 0, `attenuation_ppm` 800,000, `cutoff_units` 1,000 and `saturation_units` 1,000,000 (U:452).
- Every source follows the registry (§2.5).
- Impulse half-lives (U:452):
  - 3,600 s for the three surprise rules;
  - 86,400 s for `promotion_overlap/v1`, `validation_f2_impulse/v1`, `repair_r2_impulse/v1`, `repair_r3_impulse/v1`, `canonical_change/v1` and `federated_perturbation/v1`.
- `base_staleness/v1` uses `linear_per_day/v1` at 20,000 units a day (U:452).
- Classes follow U:201-205: `resource_pressure` and `perturbation` are extensive; `epistemic_uncertainty`, `dependency_strain` and `affordance` are evidential.
- `surprise` is evidential only as a test value, since U:206 calls it "Derived" (P8, P16).

**`minimal.json`** has `law_id` `m` and `law_version` 1. Every kind has `hop_latency_ms` 0, `attenuation_ppm` 1, `cutoff_units` 1 and `saturation_units` 2.

| Kind | Class | Source | Mode | Half-life | Age rule | Rise |
|---|---|---|---|---|---|---|
| affordance | evidential | `repair_r3_sustained/v1` | sustained | 0 | none | 0 |
| dependency_strain | evidential | `validation_f2_impulse/v1` | impulse | 1 | none | 0 |
| epistemic_uncertainty | evidential | `base_staleness/v1` | rising | 0 | linear_per_day/v1 | 1 |
| perturbation | extensive | `provider_status/v1` | level | 0 | none | 0 |
| resource_pressure | extensive | `router_headroom/v1` | level | 0 | none | 0 |
| surprise | extensive | `check_outcome_anomaly/v1` | impulse | 1 | none | 0 |

**`bounds.json`** has a 64-byte `law_id`, `a.b_c-d` followed by 57 `0`s, and `law_version` 2,147,483,647. Every kind has `hop_latency_ms` 86,400,000, `attenuation_ppm` 999,999, `cutoff_units` 999,999,999,999 and `saturation_units` 1,000,000,000,000.

| Kind | Class | Source | Mode | Half-life | Age rule | Rise |
|---|---|---|---|---|---|---|
| affordance | evidential | `repair_r2_impulse/v1` | impulse | 31,536,000 | none | 0 |
| dependency_strain | evidential | `validation_f3_attributed/v1` | sustained | 0 | none | 0 |
| epistemic_uncertainty | evidential | `base_staleness/v1` | rising | 0 | linear_per_day/v1 | 1,000,000,000,000 |
| perturbation | extensive | `federated_perturbation/v1` | impulse | 31,536,000 | none | 0 |
| resource_pressure | extensive | `core_runner_queue/v1` | level | 0 | none | 0 |
| surprise | evidential | `shared_resource_pressure_anomaly/v1` | impulse | 31,536,000 | none | 0 |

Across the three valid laws:
- every mode, profile, kind and unit appears;
- each numeric member appears at both its minimum and its maximum;
- `surprise` appears with both classes, which exercises P8.

The expected values in `golden_test.go` are written from these tables and U:437-452, never copied from the loader's output.

---

## 4. Tests

**General:**
- Tests come before code (RC:15).
- Everything is deterministic and in memory: no clock, no network and no temporary files.
- Table subtests call `t.Parallel()`, so the check's race step also exercises concurrent loads.
- Every rejection case runs under `CompactV1()` and `StandardV1()`. Both must return the same error and the zero value (ticket:29: "under both finite profiles").
- No test asserts `Error()` text (spec:587).

### golden_test.go

**`TestGoldenFilesPinned`**
- Every file under `testdata/law` and `testdata/validation-policy` has an entry in `goldenSHA256` (path → hex), and its SHA-256 matches that entry.
- Every entry names an existing file. `testdata/fuzz` is excluded.
- Fails on: a golden edited, added or removed without the record changing with it (reg:8).

**`TestGoldenLawsLoad`**
- `full`, `full-compact`, `full-reordered`, `minimal` and `bounds` load under both profiles without error.
- Each `Law` deep-equals its expected value, with `SHA256` set to the pinned digest.
- Fails on: a member mapped to the wrong field, a dropped or reordered source, a digest over the wrong bytes, or a result that depends on the profile.

**`TestGoldenUnsupported`**
- Each unsupported law and policy returns the zero value and an `*UnsupportedError` with the expected `Field`, under both profiles.
- `schema-version-2.json` returns an `UnsupportedError`, not a `FieldError{unknown_field}`.
- Fails on: a version checked only after the strict decode, which misreports a newer artifact; a newer artifact accepted and reinterpreted (U:460).

### identity_test.go

**`TestIdentity`**
- `full.json` loaded from two separate byte slices gives equal `Law` values, digests included.
- `full-compact`, `full-reordered` and the CRLF variant give the same `Law` apart from `SHA256`.
- The four digests are pairwise distinct, and each equals `sha256.Sum256` of its own bytes.
- `full-compact.json` equals `json.Compact(full.json)`, so that vector isolates whitespace.
- The policy's compact form, `json.Compact(policy.json)`, loads to the same values with another digest.
- Fails on: hashing re-encoded or decoded data, trimming, CRLF normalization, or any canonicalizer (AC2; B12).

### reject_test.go

**`TestLawRejects`** is a table of single mutations of `full.json`.
- Each case names a substring that occurs exactly once (the helper asserts this), its replacement, and the expected error.
- Kind indexes: 0 affordance, 1 dependency_strain, 2 epistemic_uncertainty, 3 perturbation, 4 resource_pressure, 5 surprise. Source indexes follow §2.5.
- Fails on: a missing or wrong check, a misclassified error, a partial result, or the wrong check order.

| # | Mutation | Expected |
|---|---|---|
| M1 | prepend EF BB BF | `Malformed{bom}` |
| M2 | byte FF inside the `law_id` value | `Malformed{invalid_utf8}` |
| M3 | bytes ED A0 80, an encoded surrogate, inside `law_id` | `Malformed{invalid_utf8}` |
| M4 | delete the comma after the `format` member | `Malformed{syntax}` |
| M5 | empty input; input of one LF | `Malformed{syntax}` |
| M6 | a second `law_id` member at the root | `Malformed{duplicate_key}` |
| M7 | a second `unit` in kinds[0] | `Malformed{duplicate_key}` |
| M8 | a second `mode` in kinds[2].sources[1] | `Malformed{duplicate_key}` |
| M9 | a second `profile` in kinds[0].sources[0].coupling | `Malformed{duplicate_key}` |
| M10 | add `"law\u005fid": "x"` beside `law_id` | `Malformed{duplicate_key}` |
| M11 | add `"x": {"a": 1, "a": 2}` at the root | `Malformed{duplicate_key}` |
| M12 | append `{}` after the root | `Malformed{trailing_data}` |
| M13 | append `x`; append a NUL byte | `Malformed{trailing_data}` |
| M14 | `schema_version` written as `1.0` | `Malformed{not_unsigned_integer}` |
| M15 | kinds[0].`cutoff_units` written as `1e3` | `Malformed{not_unsigned_integer}` |
| M16 | kinds[0].`hop_latency_ms` written as `-0`; as `-1` | `Malformed{not_unsigned_integer}` |
| M17 | add `"x": 0.5` at the root | `Malformed{not_unsigned_integer}` |
| M18 | kinds[0].`hop_latency_ms` written as `00` | `Malformed{syntax}` (R1: the decoder refuses leading zeros) |
| N1 | `format` set to `dwarf-harness/validation-policy` | `Unsupported{format}` |
| N2 | `schema_version` 0; 2; `99999999999999999999` | `Unsupported{schema_version}` |
| N3 | `evaluator_version` 0; 2 | `Unsupported{evaluator_version}` |
| N4 | `kernel` `bounded_best_arrival/v2` | `Unsupported{kernel}` |
| N5 | `Load(policy.json)` | `Unsupported{format}` |
| I1 | the whole object wrapped in `[` and `]` | `{"", wrong_type}` |
| I2 | `format` removed; `format` set to `1` | `{/format, missing_field}`; `{/format, wrong_type}` |
| I3 | `schema_version` set to `"1"` | `{/schema_version, wrong_type}` |
| I4 | `evaluator_version` removed; `kernel` removed | `missing_field` at each |
| I5 | add `"notes": "x"` | `{/notes, unknown_field}` |
| I6 | add `"LAW_ID": "x"` | `{/LAW_ID, unknown_field}` |
| I7 | `law_id` removed; `kinds` removed | `missing_field` |
| I8 | `law_id` set to `null`; `law_version` set to `"1"` | `wrong_type` |
| I9 | `law_id` set to `Golden`; `.golden`; `""`; 65 characters | `{/law_id, pattern}` |
| I10 | `law_version` 0; 2147483648 | `{/law_version, out_of_range}` |
| I11 | `weight_scale_ppm` 999999; 1000001 | `{/weight_scale_ppm, out_of_range}` |
| I12 | `kinds` set to `{}` | `{/kinds, wrong_type}` |
| I13 | kinds[5] removed; a copy of kinds[5] appended | `{/kinds, count}` |
| I14 | kinds[4] and kinds[5] swapped | `{/kinds/5/id, unsorted}` |
| I15 | kinds[5] replaced by a copy of kinds[4] | `{/kinds/5/id, duplicate}` |
| I16 | kinds[0].id set to `colony_regime` (U:207: not a kind) | `{/kinds/0/id, unknown_value}` |
| I17 | kinds[5].quantity_class set to `derived` | `{/kinds/5/quantity_class, unknown_value}` |
| I18 | kinds[0].unit set to `strain_units`; to `units` | `mismatch`; `unknown_value` |
| I19 | kinds[0] gains `"decay": 1` | `{/kinds/0/decay, unknown_field}` |
| I20 | kinds[0].saturation_units removed | `{/kinds/0/saturation_units, missing_field}` |
| I21 | kinds[0].sources set to `[]`; three copies appended to kinds[2].sources (9 entries) | `count` |
| I22 | kinds[2].sources[1] and [2] swapped | `{/kinds/2/sources/2/rule_id, unsorted}` |
| I23 | kinds[0].sources[1] replaced by a copy of [0] | `{/kinds/0/sources/1/rule_id, duplicate}` |
| I24 | kinds[0].hop_latency_ms 86400001; `"0"` | `out_of_range`; `wrong_type` |
| I25 | kinds[0].attenuation_ppm 0; 1000000 | `out_of_range` |
| I26 | kinds[0].cutoff_units 0; 1000000000001 | `out_of_range` at `cutoff_units` |
| I27 | kinds[0].saturation_units 1000000000001; 1000 (equal to the cutoff); 999 | `out_of_range` at `saturation_units` |
| I28 | kinds[1].sources[0].rule_id set to `validation_f1_unconfirmed/v1` (U:446) | `unknown_value` |
| I29 | kinds[4].sources[3].rule_id set to `router-headroom/v1` (U:444) | `unknown_value` |
| I30 | kinds[5].sources[0].rule_id set to `router_headroom/v1` | `{/kinds/5/sources/0/rule_id, mismatch}` |
| I31 | kinds[2].sources[1].mode set to `impulse` (check_flakiness is level) | `{…/mode, mismatch}`, reported before the half-life |
| I32 | a mode set to `decaying` | `unknown_value` |
| I33 | kinds[0].sources[0].unit set to `pressure_units` | `{…/unit, mismatch}` |
| I34 | kinds[5].sources[0].half_life_seconds 0; 31536001 | `out_of_range` |
| I35 | kinds[4].sources[0].half_life_seconds 1 | `out_of_range` |
| I36 | kinds[2].sources[0].age_rule_id set to `none` (a rising rule) | `mismatch` |
| I37 | kinds[4].sources[0].age_rule_id set to `linear_per_day/v1` | `mismatch` |
| I38 | an age_rule_id set to `exponential/v1` | `unknown_value` |
| I39 | kinds[2].sources[0].rise_units_per_day 0; 1000000000001 | `out_of_range` |
| I40 | kinds[4].sources[0].rise_units_per_day 1 | `out_of_range` |
| I41 | kinds[0].sources[0] gains `"amplitude": 1` (P9) | `unknown_field` |
| I42 | kinds[0].sources[0].coupling removed | `missing_field` |
| I43 | kinds[4].sources[0].coupling.profile set to `local/v1` | `{…/coupling/profile, mismatch}` |
| I44 | a profile set to `diffusion/v1` | `unknown_value` |
| I45 | kinds[1].sources[0].coupling.direction set to `dependency_to_consumer` | `mismatch` |
| I46 | a direction set to `upstream` | `unknown_value` |
| I47 | kinds[0].sources[0].coupling.edge_types gains `registered_resource_use` in sorted position (3 entries) | `{…/edge_types, count}` |
| I48 | kinds[0].sources[0].coupling.edge_types reversed | `{…/edge_types/1, unsorted}` |
| I49 | kinds[0].sources[0].coupling.edge_types set to `["declared_dataflow","declared_dataflow"]` | `{…/edge_types/1, duplicate}` |
| I50 | kinds[1].sources[0].coupling.edge_types set to `["co_access"]`, an encounter relation (U:178) | `{…/edge_types/0, unknown_value}` |
| I51 | kinds[0].sources[0].coupling.edge_types set to `["declared_dataflow"]` | `{…/coupling/edge_types, mismatch}` |
| I52 | kinds[1].sources[0].coupling.edge_types set to `["declared_dataflow"]` | `mismatch` |
| I53 | kinds[0].sources[0].coupling gains `"weight_ppm": 1` (U:448) | `unknown_field` |
| I54 | kinds[0].sources[0].coupling.edge_types set to the string `"declared_dataflow"` | `wrong_type` |

**`TestLawRefusesLocalData`** (AC4; spec:595)
- Each local-only name below is added with a plain value, once at the root and once inside kinds[0]. Each must give `unknown_field` at `/<name>` or `/kinds/0/<name>`, under both profiles.
- The names (U:456, :458; U:386-399; ticket:32, :41): `workspace_id`, `workspace_policies`, `check_policy_hash`, `environment_policy_hash`, `validation_policy_hash`, `field_law_sha256`, `activation_id`, `owner_approval_id`, `epoch`, `effective_sequence`, `not_before_utc_ns`, `grants`, `credentials`, `flake_rate_prior`, `failure_repair_confidence`, `quarantine_threshold`.
- Fails on: permissive decoding that lets local data ride inside the shared law's bytes.

### limits_test.go

**`TestLoadLimitsBounds`**
- For each profile P and each bound, one generated input exactly at P's value passes phase 1: its error, if any, is not a `*LimitError`. One count more gives `*LimitError{Bound, Max: P's value}`.
- Generators, each with an exact count by construction:
  - **bytes:** `full.json` padded with spaces to exactly P.Bytes loads successfully; one more space gives `bytes`.
  - **depth:** `{"x":` + P.Depth−1 `[` + P.Depth−1 `]` + `}`; one more pair gives `depth`.
  - **members:** an object with P.Members distinct keys `"k0000"`, `"k0001"`, …, each with value `0`; one more key gives `members`.
  - **elements:** `{"x":[0,…]}` with P.Elements zeros; one more zero gives `elements`.
  - **string bytes:**
    - `{"x":"…"}` with P.StringBytes ASCII bytes passes; one more byte gives `string_bytes`;
    - a key of P.StringBytes+1 bytes gives `string_bytes`, so keys count;
    - P.StringBytes/2 copies of `é` (two UTF-8 bytes each) pass and one more fails, so bytes count, not characters;
    - P.StringBytes/2 escapes `\u00e9` pass, so the decoded value counts, not the raw token.
  - **tokens:** `{"x":[[0,…],…]}` has 5 + Σ(2 + nᵢ) tokens when its inner arrays hold nᵢ zeros each. Choose the nᵢ and the number of inner arrays within the other bounds, so that the total is exactly P.Tokens. For compact-v1: 15 arrays of 127 zeros and one of 106. One more zero gives `tokens`.
- Precedence: P.Bytes+1 bytes of FF give `*LimitError{bytes}`, not a `*MalformedError`.
- Fails on:
  - an off-by-one (`<` written for `<=`);
  - counting characters or raw escapes instead of decoded bytes;
  - not counting keys;
  - counting commas or colons as tokens;
  - applying the other profile's value;
  - parsing before the size check.

**`TestLoadLimitsTightened`**
- Limits equal to `full.json`'s hand-derived maxima load it: `Bytes` = `len(full.json)`, `Depth` 7, `Members` 8, `Elements` 6, `StringBytes` 35 and `Tokens` 681 (§2.6).
- Lowering any one of them by one gives a `*LimitError` for that bound.
- Fails on: a counting rule that differs from §2.6, or tightened limits being ignored.

**`TestLoadLimitsRefused`**
- `Load` and `LoadValidationPolicy`, given the valid goldens, return an error wrapping `ErrInvalidLimits` and the zero value for each of:
  - `LoadLimits{}`;
  - each field set to 0, then −1, with the other fields at standard-v1's values;
  - each field set one above standard-v1's value.
- `CompactV1()`, `StandardV1()` and the tightened limits above are accepted.
- Fails on: silent widening, or zero limits treated as a default (U:454).

### policy_test.go

**`TestValidationPolicyLoads`** — `policy.json` loads under both profiles to exactly {1, 20}, {999, 1000} and {1, 5} [and 12], with the pinned digest.

**`TestValidationPolicyRejects`** — mutations of `policy.json`, each run under both profiles:

| # | Mutation | Expected |
|---|---|---|
| VP1 | flake_rate_prior.numerator 0 | `{/flake_rate_prior/numerator, out_of_range}` |
| VP2 | quarantine_threshold.denominator 0 | `{/quarantine_threshold/denominator, out_of_range}` |
| VP3 | failure_repair_confidence.numerator 1000, equal to its denominator | `{/failure_repair_confidence/numerator, out_of_range}` |
| VP4 | flake_rate_prior.numerator 21, above its denominator 20 | `out_of_range` at `numerator` |
| VP5 | each rational removed in turn | `missing_field` |
| VP6 | flake_rate_prior.denominator removed | `missing_field` |
| VP7 | the root gains `"kinds": []`; the root gains `"law_id": "x"` | `unknown_field` |
| VP8 | flake_rate_prior gains `"value": 1` | `unknown_field` |
| VP9 | flake_rate_prior set to `"1/20"` | `{/flake_rate_prior, wrong_type}` |
| VP10 | flake_rate_prior set to `0.05` | `Malformed{not_unsigned_integer}` |
| VP11 | a numerator set to `-1` | `Malformed{not_unsigned_integer}` |
| VP12 | a second `numerator` member | `Malformed{duplicate_key}` |
| VP13 | `format` set to `dwarf-harness/undercurrent-law` | `Unsupported{format}` |
| VP14 | `schema_version` 2 | `Unsupported{schema_version}` |
| VP15 | [OG-B "include"] the cap set to 0; 2147483648; removed | `out_of_range`; `out_of_range`; `missing_field` |
| VP16 | [OG-B "three only"] the root gains `"max_fresh_executions_per_incident": 12` | `unknown_field` |
| VP17 | `LoadValidationPolicy(full.json)` | `Unsupported{format}` |

### example_test.go (package `law_test`)

**`ExampleLoadValidationPolicy`** is the C4-facing consumer (AC3).
- It reads `testdata/validation-policy/v1/policy.json` and calls `law.LoadValidationPolicy(data, law.StandardV1())`.
- It prints the three fractions [and the cap], then `validation_policy_hash`. A comment explains that `field_law_sha256` and every other manifest member come from Core's activation record.
- It imports only the standard library and `contract/law`.
- Its output is pinned.

**`ExampleLoad`** is a field consumer: it loads `full.json` and prints `field_law_sha256` and each kind with its number of sources. It documents the typed registry in `go doc` for the freeze packet.

### fuzz_test.go

**`FuzzLoad`**
- Seeds: every golden law and every `TestLawRejects` input.
- For any input, under each profile:
  - nothing panics;
  - the result is the zero `Law` exactly when there is an error;
  - an error wraps exactly one of `ErrLimit`, `ErrMalformed`, `ErrUnsupported` and `ErrInvalid`;
  - on success, `SHA256` equals `sha256.Sum256(input)`;
  - a second call returns an equal result.
- Across profiles:
  - success under compact-v1 implies success under standard-v1, with an equal `Law`;
  - success under standard-v1 with `len(input) ≤ 65,536` implies success under compact-v1 (§2.6).
- Fails on: a panic in the walker, an untyped error leaking (such as a raw `strconv` error), nondeterminism, or a misapplied profile bound.

**`FuzzLoadValidationPolicy`** checks the same properties for the policy. Its seeds are the policy goldens and every `TestValidationPolicyRejects` input.

### bench_test.go (P21)

**`BenchmarkLoad`** has two sub-benchmarks, both with `b.SetBytes`: `full`, and `standard-max`, which is `full.json` padded with spaces to 262,144 bytes. It sets no threshold. V8 records its numbers for the freeze packet's D78 reasoning (RC:17; dec:569).

### Deliberately left out

- **An import test inside `contract/law`.** Step 5 of `tools/check` enforces the `contract/...` row, and its tests cover a contract that imports core or `golang.org/x` (check/boundary_test.go:186-190, :228-230). V4 records the package's dependency closure.
- **A test that loading "cannot activate".** There is no activation API to test; the package exposes only pure loaders (§2.12). Asserting that something is absent would be a source-text test (ticket:47; spec:587).
- **Reflection over the fields of `Law`.** That would assert wiring, not behavior (spec:587). `TestLawRefusesLocalData` tests the boundary instead.
- **Tests that pin the profile constants.** `TestLoadLimitsBounds` checks every value through behavior.
- **rapid.** D42 records it (dec:222), but it is not in `go.mod`. Its first use would add a requirement that waits for the owner's D41 sign-off (dec:213; B17 dec:1135). Native fuzzing carries the properties instead (P26).

---

## 5. Verification commands

Run in PowerShell from the worktree root, with `$env:GOTOOLCHAIN='local'; $env:GOFLAGS=''` set first (AGENTS.md "Go commands"; B17 dec:1136).

| # | Command | Expected |
|---|---|---|
| V1 | `$env:CGO_ENABLED='0'; go test -count=1 ./contract/law` | `ok` |
| V2 | `$env:CGO_ENABLED='0'; go test ./contract/law -run '^$' -fuzz '^FuzzLoad$' -fuzztime 120s`, then the same for `^FuzzLoadValidationPolicy$` | `PASS` for each. `git status --porcelain -- contract/law/testdata` prints nothing, unless a crasher found and fixed is kept as a seed |
| V3 | `go run ./tools/check`, with `DWARF_CC` set (AGENTS.md "Check") | all nine steps pass, the race step included |
| V4 | `go list -deps -f '{{if not .Standard}}{{.ImportPath}}{{end}}' ./contract/law` | exactly `github.com/Darius-PJ/dwarf-harness/contract/law`: no `internal/` package, no engine, no other module (AC3; the audit of spec:625) |
| V5 | `go mod tidy`, then `git diff --exit-code -- go.mod go.sum` | no change (D29) |
| V6 | `git ls-files --eol -- contract/law/testdata` | `i/lf w/lf` for every multi-line golden; `i/none w/none` for `full-compact.json` |
| V7 | `Get-FileHash -Algorithm SHA256 (Get-ChildItem -Recurse -File contract/law/testdata/law, contract/law/testdata/validation-policy)` | each hash, lowercased, equals its `goldenSHA256` entry |
| V8 | `$env:CGO_ENABLED='0'; go test ./contract/law -run '^$' -bench '^BenchmarkLoad$' -benchmem -count 5` | numbers recorded for §8; there is no pass mark |

**Per slice:**
- S1 runs V1, V2, V4, V5, V6, V7, V3 and V8.
- S2 runs V3; its commit changes no Go file.
- V3 runs again on the commit that reaches `main` (D46 dec:300).

---

## 6. Slicing

| Slice | Content | Depends on | Reaches `main` |
|---|---|---|---|
| S1 | `contract/law`: code, goldens, tests, examples and benchmark (§1) | OG-A given and OG-B answered | together with S2 |
| S2 | documents (§2.16) | S1's final golden digests and V results | together with S1 |

**Acceptance.**
- **S1:**
  - every test of §4 passes, covering AC1-AC5 in behavior;
  - V1, V2 and V4-V8 have their expected results;
  - the advisor reviews on evidence from a detached worktree, as for ticket 03.
- **S2:**
  - the register shows *Draft*, which keeps implementation separate from the freeze (AC5);
  - the status lines and B«next» are written as in §2.16;
  - V3 passes.

**Commits** are Conventional Commits with the package as the scope (AGENTS.md "Commits"): `feat(law): …` for S1 and `docs: …` for S2.

**Why together.** A `main` holding a loadable contract while the register still says *Not started* would misstate the record that AC5 asks for (P23; precedent dec:1465).

**Size.** If the reviewer prefers smaller steps, S1 splits cleanly:
- S1a: the field law, i.e. everything except §2.10 and §2.11 with their tests;
- S1b: the validation policy and the examples.

All the parts still reach `main` together with S2.

---

## 7. Design choices and owner gates

### 7.1 Design choices

**P1. Where D47's parameters live (OI-1).**
- Options:
  - (a) a separate local validation-policy artifact defined by this contract: strict JSON with its own exact-byte SHA-256 identity, whose bytes Core retains and whose hash Core binds;
  - (b) Go types only, with Core's activation record (C1-encoded) carrying the values and Core defining `validation_policy_hash`;
  - (c) members of the field-law artifact.
- **Recommend (a).** Reasons:
  - U1.L is the sole source of the parameters and owns their meaning: D47 (dec:306, :309), B2 (dec:647) and reg:30 ("versioned field/validation-policy data"), :84. Ticket:31 asks the same contract to supply them.
  - They stay outside the shared law bytes (U:456; ticket:41). The law's member list is closed (U:431), which excludes (c).
  - The manifest binds a `validation_policy_hash` (U:456; U:392). Core's activation request binds the "exact target law/validation/check/environment hashes" and retains "the approved artifact bytes before that ledger reference" (Core:868). A hash of retained artifact bytes presupposes that the policy is bytes.
  - Under (b), Core would define D47's encoding and identity, splitting the meaning U1.L owns from its record (reg:34; B12 dec:737). (b) would also need a canonical serialization of values to hash, which B12 avoids for the law (dec:737).
  - "Not a second settings file" (U:456) still holds. The bytes are owner-approved (D65 dec:463), retained by Core and bound by hash, and the package doc tells consumers never to read a working-tree file (§2.10).
- The owner summary states this reading, so OG-A covers it.

**P2. Shape of the validation policy, version 1.**
- Options:
  - member names `flake_rate_prior`, `failure_repair_confidence` and `quarantine_threshold`, or `prior`, `confidence` and `threshold`;
  - no label, or a `policy_id`/`policy_version` pair like the law's;
  - integer domain `uint64`, 1..2⁵³−1, or 1..10¹²;
  - no lowest-terms rule, or a required one;
  - the format string `dwarf-harness/validation-policy`, or none.
- **Recommend:** the first-listed names; no labels; the `uint64` domain; no lowest-terms rule; that format string with `schema_version` 1 **(my choice)**. Reasons:
  - The names follow D47 (dec:306), U:456's "failure/repair confidence" and val:359's "Confidence C for failure and repair". `numerator` and `denominator` are U:456's own words.
  - The identity is the digest (D65 dec:463), so a label would be an unsourced field.
  - No source bounds the integers; `uint64` is the house's natural integer domain (ledger/envelope.go:436).
  - A lowest-terms rule would be a canonical form (B12).
  - A format string mirrors the law's (U:431) and lets each loader clearly refuse the other's artifact (N5, VP17).

**P3. Identity of a validation policy.**
- Options: (a) the SHA-256 of its exact bytes, as for the law; (b) a hash over its decoded values.
- **Recommend (a).** Reasons:
  - It gives both artifacts one identity rule (B12 dec:737; U:456).
  - (b) needs a canonical encoding (B12).
  - Core binds retained bytes (Core:868), and a content-addressed copy of them verifies by the same digest.

**P4. The digest type.**
- Options:
  - (a) `law.Digest`: 32 bytes whose `String()` gives lowercase hex, the representation and text form of `ledger.Digest` (ledger/digest.go:12-16);
  - (b) reuse `ledger.Digest` by importing `contract/ledger`.
- **Recommend (a).** Reasons:
  - The fixed constraint and reg:7 require the standard library only, and D45's contract row says "Nothing else" (dec:280). B17 does allow same-tree imports (dec:1138), but (b) would tie law-format's API to ledger-format for a single type.
  - "U1.L may be frozen and delivered independently" (U:462). Federation shares only the law hash (U:258), so a peer that validates a law needs nothing from the ledger.
  - Both types are `[32]byte`, so Core converts with a plain `ledger.Digest(l.SHA256)`. The text form is identical, so this adds no second convention.
- If the advisor prefers (b) under B17, V4 also lists `contract/ledger`.

**P5. What the hash covers (OI-4).**
- Options: (a) the artifact's content bytes exactly as given; (b) Git's object hash over `blob <size>\0` followed by the content.
- **Recommend (a).** The sources settle this; it is recorded here for the ruling.
  - U:456 describes the hashed bytes as "(valid UTF-8 JSON, no BOM)", which a Git object header is not.
  - U:383 says "SHA-256 of exact shared field-law artifact bytes"; B12 says "Hash the exact immutable Git-blob bytes with SHA-256" (dec:737).
  - The API takes bytes, so obtaining the blob's bytes rather than a converted checkout is the caller's duty (§2.9).

**P6. Go types (OI-6).**
- Options: the §13.2 sketch as written (`map[Kind]KindLaw`, `uint8` enums, `Hash`), or the sketch's numeric types with the changes below.
- **Recommend the changes:**
  - Keep the sketch's numeric types and field names (U:362-385).
  - Add the §13.4 members the sketch omits: `ID`, `Kernel` and `WeightScalePPM`. Omit `Format`, which the Go type implies.
  - Use an ascending `[]KindLaw` instead of a map. Its iteration order is deterministic and mirrors the artifact.
  - Use string types whose values are the wire strings instead of `uint8` enums. A zero `uint8` is a valid `Extensive` or `Impulse`, but an empty string is never valid, which matches "no defaults" (U:431, :450).
  - Return values, the zero value on error, as `DecodeCommand` does (ledger/records.go:61).
- Reasons: §13.2 is a "sketch, not a final API" (U:335) with "illustrative" types (U:338). §13.4 is the normative member list (U:431-450).

**P7. The exported vocabulary.**
- Options:
  - (a) an exported constant for every closed value, the 22 rule IDs included, with the registry tables unexported but documented;
  - (b) (a) plus the registry exported as data;
  - (c) no constants.
- **Recommend (a).** Reasons:
  - Consumers interpret a loaded `Law` by these values; U1.E and U4 select reducers by rule ID (U:448).
  - Exporting the registry as data would enlarge the frozen surface, and no consumer needs it.
  - `doc.go` declares the registry, as ledger/doc.go:4 is the format.

**P8. `quantity_class` (OI-16).**
- Options: (a) the closed enum only, so any kind may take either value; (b) a fixed class for each kind, taken from §9.
- **Recommend (a).** Reasons:
  - U:433 checks only rule, mode, unit and coupling values against the registry; the quantity class is only "`extensive|evidential`".
  - U:206 gives surprise the class "Derived", outside the enum, so §9 yields no fixed mapping for all six kinds.
  - spec:487: "Each kind declares extensive versus evidential quantity semantics", so the law declares it.
  - The goldens give surprise both values (§3).

**P9. "Source amplitudes ... cannot exceed saturation" (U:450; OI-17).**
- Options: (a) no such check in version 1 of U1.L; (b) hard-code §9's amplitudes and require saturation at or above each.
- **Recommend (a).** Reasons:
  - The source object has no amplitude member (U:433).
  - §9's amplitudes are "provisional; evaluator v1 candidate, not an owner decision" (U:213), U4 owns them (ticket 71:41), and several depend on data (U:213-217).
  - Capping at saturation is the engine's job (U:112: "capped at a saturation value"; U:450: `min(saturation, …)`).
  - (b) would freeze provisional values into the format's validity.

**P10. The `LoadLimits` API.**
- Options:
  - the profiles as exported variables, or as functions that return values;
  - a zero `LoadLimits` meaning standard-v1, or an error;
  - separate limits for the policy, or the same limits.
- **Recommend:** functions; an error for zero or wider limits; the same limits for both artifacts. Reasons:
  - An importer could mutate an exported variable and so widen silently, which U:454 and ticket:41 forbid.
  - "standard-v1 is the initial default" (U:454) describes the host's configuration, which Core owns. A forgotten configuration should fail closed rather than fall back to a default.
  - The policy is tiny and fits every valid profile (§2.6), and one set of bounds keeps one parser.

**P11. Counting definitions (§2.6).**
- Options:
  - string bytes counted on the decoded value, or on the raw token;
  - tokens as the values of `Decoder.Token`, or also counting commas and colons;
  - depth starting at 1 for the root, or at 0.
- **Recommend:** as §2.6. Reasons:
  - U:454 names the bounds but not how to count them.
  - The chosen definitions follow its words ("raw bytes", "UTF-8 bytes per string", "JSON tokens") and the house walker (ledger/envelope.go:511-559).
  - The decoded value is what the parser holds, and `Bytes` bounds raw escapes.
  - The tests pin every definition (`TestLoadLimitsTightened`).

**P12. Integer spelling.**
- Options: (a) unsigned digits only, anywhere in the input; (b) any JSON integer, sign included.
- **Recommend (a).** Reasons:
  - U:450 and U:454 refuse decimal and exponent numbers and "non-integer numeric tokens".
  - Every version-1 range is non-negative, so a sign never carries meaning, and (b) would accept `-0` as a second spelling of 0.
  - It is the house rule: "plain JSON integers with no sign, fraction or exponent" (ledger/doc.go:40-41; `parseNat`, ledger/envelope.go:436).
  - Leading zeros are already a syntax error (R1).

**P13. Errors: taxonomy, codes and order.**
- Options:
  - (a) four artifact sentinels plus `ErrInvalidLimits`, typed errors with closed codes, JSON Pointer paths, and the first violation in the documented order of §2.7;
  - (b) one `ErrInvalid` with prose reasons, as the ledger's payload decoders use;
  - (c) a collection of every violation.
- **Recommend (a).** The phase precedence is part of the contract (P14), and so is the documented order within phase 3, because the tests pin it. §8 question 6 asks the owner whether to freeze it. Reasons:
  - Ticket:29 names the categories to refuse: malformed, duplicate, unsupported, unsorted and boundary-exceeding. spec:587 forbids asserting prose, so the tests need machine-checkable codes.
  - A sentinel plus a typed error with `Unwrap` is the house pattern (ledger/errors.go).
  - Stopping at the first error keeps rejection atomic and simple.
  - (c) adds work and output with no consumer.

**P14. Versions first; additions only as new versions.**
- **Recommend:** the head members are checked before any other version-1 rule. Additions arrive only as new schema or evaluator versions beside version 1, and no upgrader reinterprets an old artifact (§2.13).
- The alternative, checking unknown members first, would misreport a newer artifact as an invalid version-1 one.
- Reasons: U:460 ("continue to decode old versions or fail clearly, never reinterpret them"); U:155 (the kernel); U:454 (unknown members are refused); D40 dec:206 (a frozen contract changes only by addition).

**P15. Golden layout, hand-written files and the CRLF vector.**
- Options for the CRLF vector:
  - (a) derived in the test from the LF golden, with every committed file LF;
  - (b) a committed CRLF file with a `-text` attribute, in `.gitattributes` or in a nested `contract/law/testdata/.gitattributes`.
- **Recommend (a)**, with hand-written goldens, no encoder and no `-update` flag, and digests pinned in the test and checked independently (V7). Reasons:
  - B1 normalizes text to LF (dec:231; `.gitattributes`). A committed CRLF file would be stored as LF and lose its point, unless (b) added an exception to B1.
  - The derived bytes are a deterministic function of the pinned LF file.
  - Unlike the ledger's goldens, no encoder regenerates law files (P17), so the `-update` pattern of ledger/golden_test.go does not apply.

**P16. Golden values (OI-7).**
- **Recommend:**
  - The goldens are format vectors only.
  - `full.json` uses §13.4's candidate values and §9's classes, with surprise's class a test value; `policy.json` uses val:394's provisional values.
  - The test comments and the B-entry say that neither is an owner-selected artifact.
  - No law file is committed outside `testdata`.
- Reasons:
  - The values "remain preregistration candidates until the owner chooses an exact artifact" (U:452), and an "Exact owner-selected artifact remains required" (ticket 71:41).
  - The V1 values are "Tunables, not measured defaults" (val:394) that "await U1.L owner approval/calibration" (Core:892).
  - Ticket:37: "not measured results or newly approved defaults".

**P17. No encoder.**
- **Recommend:** no `Marshal`, `Encode` or `Canonical` function. Reasons:
  - B12 forbids treating ordinary JSON serialization as canonical (dec:737), and identity never depends on re-encoding (U:456).
  - The law is an owner-authored file, and no source asks for authoring support.
  - An encoder can be added later by addition (D40).

**P18. One package.**
- **Recommend:** everything in `contract/law`; no `internal/undercurrent/law` for now. Reasons:
  - reg:7 places law-format in `contract/law`; D45 lists both packages (dec:262, :265).
  - U:326's `undercurrent/law` also lists "source rules", whose reducers are U1.E and U4 work (U:448).
  - An internal package with no behavior would be a placeholder (ticket:18; B17 item 5, dec:1139).

**P19. The binding surface (AC3).**
- Options:
  - (a) the two digests on the loaded values, documented as the manifest's `field_law_sha256` and `validation_policy_hash`;
  - (b) also a `Binding{FieldLaw, ValidationPolicy Digest}` type and `LoadBound(b, law, policy, limits)`, which refuses bytes whose digest differs from the binding.
- **Recommend (a).** Reasons:
  - C2 owns the manifest (reg:34; B12 dec:737), and C4 needs only the policy, not the law's contents (B2 dec:647).
  - Checking retained bytes against a bound digest belongs to Core's retrieval and activation checks (Core:868-870), and content-addressed storage already provides it (B21). **[INFERENCE]**
  - (b) would be API without a behavior any consumer needs.

**P20. Input as bytes.**
- **Recommend:** `[]byte` only, with no `io.Reader` variant. Reasons:
  - Identity is over exact bytes (U:456), and callers hold retained bytes (Core:868).
  - The size bound is checked first.
  - A reader variant adds surface no consumer asks for.

**P21. JSON reader and benchmarks.**
- **Recommend:** `encoding/json`'s `Decoder.Token`, the house reader (ledger/envelope.go:511-559), and `BenchmarkLoad` for the D78 reasoning at the freeze. Reasons:
  - go1.27.2 lists `encoding/json/v2` (R1), but whether it builds without an experiment flag is unverified, and using it would bring a second JSON convention into the contracts.
  - RC:17: "Before … contract freeze …, state … CPU, RAM, disk and process costs". dec:569 asks for a "measurement/acceptance plan" before an affected boundary is frozen.
- The alternative is no benchmark, with reasoning alone in §8.

**P22. Documents (S2).**
- **Recommend:** the register row becomes Draft, U1 becomes In progress, B«next» is appended, and U:456 gains one sentence (§2.16). Reasons:
  - The register's Draft state (reg:15), and AC5: "the contract record clearly separates implementation from owner freeze" (ticket:33).
  - A step's status changes in both roadmap files in one commit (RU:164; R:62).
  - Precedents: "C1 In progress" (dec:1235), and the ledger contracts that "stay Draft, version —" (dec:1485).
  - The sentence keeps the design doc true about where the policy's format now lives.
- The alternative is no edit to the design doc.

**P23. S1 and S2 reach `main` together.**
- A `main` with a loadable contract but a register still saying *Not started* would misstate the record AC5 asks for. Precedent: ticket 03's slices merged together for the same kind of reason (dec:1465).

**P24. When the freeze request is sent.**
- Options:
  - (a) the PM sends it once S1 and S2 are on `main`, and ticket 04 closes on its five criteria with the request sent, not awaited;
  - (b) a separate, later step.
- **Recommend (a).** Reasons:
  - Nothing else remains for U1.L, and U1.L is Done only with frozen golden vectors (RU:215). C4 waits on that freeze (dec:309; R:172), so delay only delays C4.
  - The ticket asks for the record to keep implementation and freeze separate (ticket:33), not for the freeze to happen inside the ticket.
  - C1 sent OG2 the same way (dec:1466).

**P25. Owner-gate labels.**
- OG-A and OG-B are provisional names. The PM assigns the next global OG numbers when sending them; OG1-OG3 are taken (dec:1225, :1466, :1468).

**P26. Property tests with native fuzzing only.**
- D42 records rapid (dec:222), but its first use would add it to `go.mod` (B17 dec:1135). That is a dependency change, which waits for the owner (dec:213).
- The fuzz targets carry the properties (§4).

### 7.2 Owner gates

**OG-A — approve the design** (ticket:65).
- **Asked:** approve this brief, as the advisor rules on it, before any code. The summary points out three things:
  - the validation policy is a separate local file (P1);
  - the test data is not the owner's law (P16);
  - nothing is frozen or activated.
- **Options:** "Approve as ruled"; "Approve with changes", naming the changes; "Not yet".

**OG-B — the validation policy's parameter set.**
- **Facts:**
  - D47 (owner, 2026-10-02) names three parameters (dec:306), and U:456 restates them as typed rationals.
  - Core's design lists four "provisional law parameters": prior 0.05, confidence 0.999, quarantine candidate 0.20 and "max 12 fresh executions per evidence incident". It adds: "They await U1.L owner approval/calibration" (Core:892). val:394 (V1, PV24) lists the same four.
  - RC:539 forbids C4 to define duplicates of the first three only. No source gives the cap another home.
- **Options:**
  1. **Include** `max_fresh_executions_per_incident`, a whole number in 1..2,147,483,647, as the policy's fourth member. **Recommended**: it keeps every validation parameter in the one owner-approved, versioned source. That is D47's intent: "C4 consumes the frozen parameters rather than defining a second policy source" (dec:306), and "There is no earlier, weaker validator or duplicate law policy" (dec:340).
  2. **Three only**, as D47 lists. The cap then needs its own decision later: a version 2 of the validation policy, or C4 policy.
- The range 1..2,147,483,647 is the type's domain **(my choice)**, not a policy value; the file the owner approves sets the value.
- **Not proposed:** val:359 also floats an "agent-authored amplitude factor and minimum assurance level per kind" as law parameters. Neither D47, U:456 nor V1 carries them.

**Not owner gates here:**
- P1-P26 are the advisor's to rule on.
- Nothing adds a dependency, so no D41 or D29 sign-off is needed.
- The freeze (§8) and the exact law and policy values (D65 dec:463; U:452) are later owner decisions.

---

## 8. The later freeze path

**Who and when.** Freezing is the owner's decision (D40 dec:206; reg:16, :19). After S1 and S2 are on `main` (P24), the PM sends one question-tool request with a packet modelled on OG2's (`.scratch/dwarf-harness/c1-evidence/og2-f0-freeze-packet.md`). Ticket 04 builds nothing for it beyond the evidence its slices produce.

**The packet:**

1. **What is requested.** Freeze `law-format` at commit «tip» as Version 1, Frozen. The freeze covers:
   - the field-law artifact (schema 1, evaluator 1, kernel `bounded_best_arrival/v1`) with the evaluator-v1 registry;
   - the validation-policy artifact (schema 1);
   - compact-v1 and standard-v1 with their counting rules;
   - the loading order, error types and codes;
   - the identity rule;
   - the Go API.

   A draft owner decision entry and the register edit are attached.
2. **Surfaces.**
   - `go doc -all ./contract/law` at «tip»; the package doc is the format.
   - The golden files with their SHA-256 (V7), and what each proves (§3).
   - B«next».
3. **Evidence.**
   - V1-V7 at «tip», with the fuzz durations.
   - V4's dependency closure: no engine and no `internal/` import, which is the audit of law-format against the engine (spec:625).
   - V6's line endings.
   - Platforms: verified on Windows; compiled for Linux and macOS by the check's cross builds only (as at dec:1236). The package has no OS-specific code.
   - D78 (RC:17; dec:569), each part labelled:
     - *assumption:* artifacts load at approval, at activation and when a consumer starts; C4 may load the policy for each attempt;
     - *calculation:* every load is bounded by 262,144 bytes and 8,192 tokens;
     - *measurement:* V8;
     - *plan:* C2 and C4 measure their actual call rates at their own gates.
4. **Questions**, each with a recommendation:
   1. The version-1 schema and the evaluator-v1 registry as built. Afterwards, a new kind, rule or kernel needs a new evaluator version (U:460).
   2. Additive change for a strict format. Version 1 refuses unknown members, so it never gains optional members. Additions are new versions read beside version 1, and no upgrader reinterprets an old artifact (U:460; compare reg:16).
   3. The profiles and counting definitions (P11). Changing a bound or a definition changes what older hosts accept and needs an owner decision entry.
   4. Identity: SHA-256 of the exact bytes of both artifacts, with the package's own digest type (P4).
   5. The validation-policy artifact: its format string, its members, the fraction rule and OG-B's answer.
   6. Whether the error codes and their order are frozen with the format (P13).
   7. Integers spelled as unsigned digits only (P12).
   8. `quantity_class` left to the law's author for each kind (P8).
   9. *For information, not frozen:* the golden values are candidates. The exact law and validation policy are approved and activated later, through Core (D65 dec:463; U:464).
5. **Options:**
   - "Freeze as presented";
   - "Freeze with changes", naming the questions; a follow-up ticket applies the changes, and the freeze is recorded at its commit;
   - "Not yet".
- **Appendix A: draft owner decision entry**, "law-format frozen at version 1", with the golden digests. Its consequences:
  - the contract changes only by addition (D40);
  - U1.L becomes Done (RU:215);
  - C4 may consume the parameters once its other prerequisites are met, namely C3 and D52's approval (dec:309; R:172);
  - U1.E and the other field consumers may build against the frozen format (ticket:23; reg:30).
- **Appendix B: register edit.** `law-format` becomes Version 1, Frozen, with the status line updated (reg:19).
- **Appendix C:** B«next» as recorded.

**After an answer:**
- the owner's decision entry and the register edit, in a docs-only commit, as for D111;
- the status lines at RU:217, RU:577, R:187 and any other line that waits on the freeze;
- an "Open items awaiting the owner" row while the request is unanswered (dec:24-28);
- ticket 04's comment.

None of these belongs to ticket 04's slices.

---

## Appendix A. Source reconciliation

| Item | Resolution |
|---|---|
| OI-1 D47's home | P1 |
| OI-2 who freezes | The owner, under D40 (dec:206; reg:16, :19); the register names U1.L as the owning step (reg:30). **Interpretation for the advisor:** U:458's "D40/C1 must formally freeze" and RU:215's "C1-frozen golden vectors" name the D40 freeze process, not an owner in C1 |
| OI-3 who may tighten | The host or operator chooses the limits; the contract refuses any widening (P10; U:454) |
| OI-4 hash input | P5 |
| OI-5 kind enum | The six IDs of U:437-442. "Provider availability is a separate perturbation level" (U:215) is `provider_status/v1`'s level mode under the `perturbation` kind (U:441), which is consistent |
| OI-6 sketch vs list | P6 |
| OI-7 candidates vs calibration | P16 |
| OI-8 router names | Only `router_headroom/v1` exists; `router-headroom/v1` is R1's scheme (U:444; reg:63) and is refused (I29) |
| OI-9 statuses | law-format moves from Not started to Draft and U1 from Ready to In progress in S2; the freeze comes later (P22, §8) |
| OI-10 blocker | Ticket 03 is resolved (ticket 03:3) and F0 is frozen (D111) |
| OI-11 tolerance | Not a law-format member; it belongs to U1.E (ticket 60; U:476) |
| OI-12 C4 wording | The sources agree (R:153; dec:647; RU:189) |
| OI-13 three parameters vs four | D47 and U:456 name three; Core:892 and val:394 name four. OG-B |
| OI-14 two package homes | U:326 names `undercurrent/law`, reg:7 and D45 name `contract/law` (P18) |
| OI-15 B1 vs a CRLF vector | P15 |
| OI-16 surprise "Derived" vs the closed enum | P8, P16 |
| OI-17 an amplitude rule without an amplitude member | P9 |
| OI-18 `encoding/json` behavior vs strictness | §2.15 items 1-3 (R1) |

## Appendix B. Acceptance trace

| Criterion | Behavior | Tests |
|---|---|---|
| AC1 (ticket:29) | §2.4-2.8 | `TestGoldenLawsLoad`, `TestLawRejects`, `TestLoadLimits*`, `FuzzLoad` |
| AC2 (ticket:30) | §2.9 | `TestIdentity`, `TestGoldenFilesPinned` |
| AC3 (ticket:31) | §2.10-2.11 | `TestValidationPolicy*`, `ExampleLoadValidationPolicy`, V4 |
| AC4 (ticket:32) | §2.12 | `TestLawRefusesLocalData`, I41, I53 |
| AC5 (ticket:33) | §2.13, §2.16 | `TestGoldenUnsupported`, `TestGoldenFilesPinned`, the expected golden values, the register's Draft row (S2) |

**U1's exit criterion for U1.L (RU:215):**

| Clause | Covered by |
|---|---|
| strict JSON v1 | the M and I cases |
| exact-byte hash and activation separation | `TestIdentity`, `TestLawRefusesLocalData` |
| compact-v1 and standard-v1 boundaries | `TestLoadLimitsBounds` |
| duplicate-key rejection | M6-M11 |
| schema rejection | the I cases |
| enum rejection | I16-I18, I28-I32, I38, I44, I46, I50 |
| kernel rejection | N4 |
| edge-type rejection | I47-I52, I54 |
| numeric-bound rejection | I10, I11, I24-I27, I34-I40 |
| configured size/count rejection | `TestLoadLimitsTightened`, I13, I21, I47 |
| "C1-frozen golden vectors" | the freeze (§8) |

**Specification coverage (ticket:51-53):**

| Item | Where |
|---|---|
| user story 80 (spec:191) | the package holds only law (§2.12) |
| user story 81 (spec:193) | §2.4-2.13 |
| implementation decision 1 (spec:379) | §2.1 claims no approval and no freeze |
| implementation decision 2 (spec:381) | the tests go through the public loaders |
| implementation decision 3 (spec:383) | standard library only; goldens before the freeze |
| implementation decision 4 (spec:385) | the B-entry's Limits |
| implementation decision 30 (spec:481) | §2.12 |
| implementation decision 31 (spec:483) | §2.9-2.12 |
| testing decision 1 (spec:585) | public-boundary tests; the goldens become authoritative only at the freeze |
| testing decision 2 (spec:587) | behavior tests; no prose assertions |
| testing decision 4 (spec:591) | C1's contracts are neither changed nor consumed; their compatibility method is applied in §2.13 |
| testing decision 5 (spec:595) | all of §4 |
| testing decision 17 (spec:625) | V4 |
| testing decision 20 (spec:635) | regression cases kept: M10 (escaped duplicate), I31 (mode before half-life), I29 (hyphenated rule) |

## Appendix C. Runner requests

**R1 (answered).** Probed on go1.27.2 windows/amd64 in a scratch module outside the repository, with `GOTOOLCHAIN=local`, an empty `GOFLAGS` and `CGO_ENABLED=0`. The scratch directory was removed afterwards.
- `Decoder.Token` returns both members of `{"a":1,"a":2}` without an error.
- With `"\u0061"` it returns the key `a` twice, decoded.
- A raw FF byte inside a string comes back as `"\ufffd"`, without an error.
- With `UseNumber`, `-0`, `1.0` and `1e3` come back as `json.Number`; `007` gives `invalid character '0' after array element`.
- `go list encoding/json/v2` prints `encoding/json/v2`. Building a program against it without an experiment flag was not tried.

No request is open.
