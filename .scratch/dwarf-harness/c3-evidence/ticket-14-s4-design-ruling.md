```json
{
  "verdict": "approve-with-amendments",
  "summary": "P1-P6 stand; P1, P3, P5 and P6 are amended for precision, P2 is approved with its reason corrected. The code confirms the finding: normalizeOpenAIUsage (openai_usage.go:104-110) refuses the nested split through knownUsage's scalar-only tolerance (:49-61), and deriveOpenAIResult holds any observation whose recorded profile_violation is true (paid_settlement.go:174). A second token is the right vehicle because the usage-schema token, not the provider switch, must name the interpretation (first ruling P9; D163 recorded v1's rule as scalar null/0 in contract/ledger/doc.go:2453; CURRENT-RULES: versions are added beside old ones without semantic upgrading). No golden, no owner gate.",
  "rulings": [
    {
      "id": "P1",
      "disposition": "amend",
      "ruling": "Approved with the rules fixed exactly. Under v2 the known members of input_tokens_details are cached_tokens, cache_write_tokens and cache_write_tokens_details. cache_write_tokens_details absent or null means no split; an object applies the split rules; any other value (number, string, array) holds with a profile violation. Inside the split, ttl_30m_tokens and ttl_12h_tokens are each absent, null or a plain non-negative integer in the existing counter grammar (money.go:42-56: digits only, no leading zero, int64); any other value holds with a violation; unknown members follow P3. ttl_12h_tokens greater than 0 holds with a profile violation (the request pins ttl 30m and the tariff has no 12h class, so pricing the aggregate at the 30m write rate would be a wrong charge; the first ruling's P2 refuses unpriced classes). The sum rule is right and mirrors the Anthropic aggregate check (usage.go:226-228): when the split object is present, ttl_30m_tokens + ttl_12h_tokens, absent or null members counting 0, computed in big integers, must equal cache_write_tokens, else the usage holds with a violation. cache_write_tokens stays mandatory and is the write class's only unit source; it is never inferred from the split (first ruling amendment 4, last sentence): a split present with cache_write_tokens absent or null holds exactly as it does today (ErrUsage through zeroWhenAbsent, no violation flag, never settles). Pricing and band selection are unchanged. For the owner's one further attempt the rule is inert: caching needs 1,024 tokens (facts digest line 236), so a 9-token prompt reports zero writes and a 0+0=0 split."
    },
    {
      "id": "P2",
      "disposition": "approve",
      "ruling": "A new token is needed, but not for the mechanical reason the brief gives. I checked the derivation paths: replay (paid_attempt.go:334-395, paidResultCost) reprices the recorded PaidUsage units under ValidateHistorical and never re-normalizes raw usage; checkPaidQuote (:40-75) rebuilds only the bound; late derivation (paid_settlement.go:172-222) re-normalizes RawUsageFinal once, when the observation is submitted, and returns held before that whenever the observation carries profile_violation true, which the reader sets from the same normalizer (openai_stream.go:58-59). So extending v1 in place would change no recorded result, no replay and no golden byte: the chapter-14 observations carry no split, and the second attempt's observation stays held by its own flag under either option. The decisive reasons are policy: the first ruling's P9 fixed that a changed interpretation of OpenAI usage gets a new usage-schema token, never a reinterpretation; D163 recorded v1's producer rule as scalar null or integer zero (contract/ledger/doc.go:2453), so widening v1 would silently change a recorded producer policy under the same token; the approved v1 pin TestOpenAIUsageUnknownAndNull (openai_usage_test.go:152-174, the {} and {future:0} rows hold with a violation) would have to be rewritten; and the retained held observation of attempt 2 is explained forever by its own token. Mechanics approved as proposed: the switch is on Profile.UsageSchema inside NormalizeUsage's openai case (usage.go:90-91 passes p.UsageSchema; a two-case switch with an ErrUnsupported default); validate() at profile.go:155 accepts exactly the two tokens for both live and historical validation (v1 stays installable and replayable; the product does not force the move, the PM's rebuilt live profile makes it); every v1 path, fixture and expectation stays byte-for-byte as shipped; the profile digest changes with the token; the chapter-14 golden generator (paid_openai_golden_test.go:60) keeps v1 and is not touched. The in-place alternative is rejected."
    },
    {
      "id": "P3",
      "disposition": "amend",
      "ruling": "Approved under v2 with these precisions. The tolerance applies to unknown members only, at any depth of usage: a value is tolerated when it is JSON null, the plain integer literal 0 (byte-exact after trimming, as absentCharge does today), or an object, possibly empty, whose every member value is tolerated by the same rule; arrays, any other scalar, a non-integer or nonzero leaf hold with a profile violation (unchanged). tool_usage, at the response level and under usage, keeps amendment 4's own rule in both layers (emptyOpenAIToolUsage and the agents' paidEmptyToolUsage: nested null is not a zero leaf) and is not unified with this rule. v1 keeps its shipped tolerance (scalar null or 0 at the three levels the code checks) because that is what D163 recorded and what the approved tests pin; amendment 4's at-any-depth wording is fulfilled by v2. Recursion is bounded by checkJSON's depth limit of 64 (json.go:33), which normalizeOpenAIUsage already applies to the encoded usage."
    },
    {
      "id": "P4",
      "disposition": "approve",
      "ruling": "No golden. The token is a value of the open profile member usage_schema (visible ASCII 1..128, D148 open tokens); no codec, type, version, closed set, digest order or reader rule changes; chapter 14 stays byte-identical (log digest 74d43897fb8d8c7275599270fc874a1ca7f8911ba35ea197b4d8c11b8a7dedaa per D163). The replay concern a golden would cover (a v2 profile refused by ValidateHistorical would make its history unsupported and never release the hold) is proven instead by the Core row's reopen assertion required in P5. The evidence lists the chapter-14 log digest and an untouched contract/ledger/testdata."
    },
    {
      "id": "P5",
      "disposition": "amend",
      "ruling": "Approved; arithmetic checked: with the fixture tariff (input.uncached.short 1/10, output.generated.short 1/2) 9 and 5 tokens price to ceil(0.9+2.5)=ceil(3.4)=4 micros. Additions, all in the money class: (1) a vector with the split present and cache_write_tokens absent, and one with it null, both hold without inferring the write count; (2) rule break (d): infer cache_write_tokens from the split sum when it is absent, which must turn (1) red; (3) the Core row, after RecordPaidObservation settles 4 micros, reopens the same store with Open (as paidFixture.refuse does) and asserts the attempt still reads settled at 4 micros with no hold, proving the v2 token through checkPaidQuote, ValidateHistorical and paidResultCost on replay; (4) the live-shaped byte fixture runs through ReadOpenAIStream under a v2 profile (Priceable, units 9/5 in the short band, ProfileViolation false, Blocks kept) and under v1 (ErrUsage, ProfileViolation true, Blocks nil), plus through NormalizeUsage directly; it is sanitized exactly as the shape file (synthetic response id, no header values), and keeps the response-level tool_usage tree so that path stays pinned; (5) no existing v1 row, fixture or expectation is edited; the coder adds rows and files only. Breaks (a), (b), (c) stand as named; (c) must redden both the fixture's v1 row and TestOpenAIUsageUnknownAndNull's nested rows. Nits, not required: a split that disagrees only by an int64-overflowing sum, and a split given as [] or 0."
    },
    {
      "id": "P6",
      "disposition": "amend",
      "ruling": "One slice S4 on main after the 14-merge check lands; product code only in internal/core/providers (openai_usage.go, profile.go, the one-line pass-through in usage.go); internal/core/agents test-only, which the grep confirms (no production list of usage-schema tokens in agents; providerProfile carries usage_schema through its JSON round-trip). Added to the slice: the as-built text, since the three doc.go files are the paid path's references: internal/core/providers/doc.go gains the v2 paragraph (split rule, any-depth tolerance, v1 frozen as shipped), internal/core/agents/doc.go's token sentence names both tokens (text only), contract/ledger/doc.go's producer paragraph gains one sentence beside its v1 sentence and its unknown-member sentence (PM-owned with the slice as in S2), docs/CONTRACTS.md's F3-13 paragraph one sentence, and D164 with its CURRENT-RULES line in the same records commit (D161). The drill: the PM rebuilds the live profile with usage_schema v2 (same rates, limits, quotes; new profile digest; bumping capability_version is the PM's call and recommended since the capability record changed); the driver, unchanged in code, must show the loaded profile's token is v2 and display exactly 233,572 micros before the POST; any other figure or a v1 token stops the drill for a fresh go (first ruling amendment 1 stands)."
    }
  ],
  "amendments": [
    "1. P1: cache_write_tokens_details absent or null means no split, an object applies the split rules, any other value holds with a violation; split members are absent, null or plain non-negative integers in the existing counter grammar, any other value holds with a violation; absent or null members count 0 in the sum, computed in big integers; ttl_12h_tokens greater than 0 holds with a violation; the sum must equal cache_write_tokens or the usage holds with a violation; cache_write_tokens stays mandatory, is the write class's only unit source and is never inferred from the split (split present with it absent or null holds exactly as today).",
    "2. P3: the any-depth tolerance is for unknown members only (null, plain 0, or an object tree of such leaves; empty object included; arrays and other values hold with a violation); tool_usage keeps amendment 4's separate rule in providers and agents; v1 keeps its shipped scalar-only tolerance.",
    "3. P5: add the no-inference vectors (split present, cache_write_tokens absent; split present, cache_write_tokens null) and rule break (d) inferring the write count from the split; the Core row reopens the store and asserts the v2 attempt replays settled at 4 micros; the live-shaped fixture is exercised through ReadOpenAIStream under both profiles and through NormalizeUsage; no v1 expectation is edited.",
    "4. P6: owned paths gain the documentation text in internal/core/providers/doc.go, internal/core/agents/doc.go (text only), contract/ledger/doc.go (producer sentence), docs/CONTRACTS.md (one sentence), D164 and its CURRENT-RULES line; the drill driver checks the loaded profile's token is v2 and still displays exactly 233,572 micros before the POST.",
    "5. P2: both tokens are valid for live and historical validation; v1 is neither refused nor migrated; the live profile moves to v2 only by the PM's rebuild; the chapter-14 golden generator and every v1 fixture stay on v1."
  ],
  "slicePlan": {
    "ownedPaths": [
      "internal/core/providers/openai_usage.go (v2 derivation: the split rules, the any-depth tolerance, the two-token set; v1 branch byte-identical in behaviour)",
      "internal/core/providers/profile.go (validate accepts exactly the two usage-schema tokens, live and historical)",
      "internal/core/providers/usage.go (pass p.UsageSchema into the openai case only)",
      "internal/core/providers/doc.go (the v2 paragraph)",
      "internal/core/providers/openai_usage_test.go, openai_stream_test.go, openai_test.go, profile_money_test.go (new vectors, the sanitized live-shaped fixture, profile refusal rows for v2 accepted and v3/other refused, fuzz seeds)",
      "internal/core/agents/paid_openai_test.go (one Core row on loopback SSE with a v2 profile, with the reopen assertion; a v2 variant of paidOpenAIProfile) and internal/core/agents/doc.go (token sentence, text only); no agents production code",
      "PM-owned with the slice: contract/ledger/doc.go producer sentence, docs/CONTRACTS.md F3-13 sentence, docs/DECISIONS.md D164, docs/CURRENT-RULES.md line, the rebuilt live profile in the private drill config",
      "Not owned: internal/core/providers/openai_stream.go (read only; no change expected), contract/ledger/paid_openai_golden_test.go and contract/ledger/testdata (untouched)"
    ],
    "commands": [
      "GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -timeout 19m -run 'TestOpenAI|TestNormalize|TestProfile|TestHistorical|TestRectangular' ./internal/core/providers",
      "GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -timeout 19m -run 'TestOpenAI' ./internal/core/agents",
      "GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -timeout 19m -run 'TestGolden|TestPaid|TestF3_13' ./contract/ledger (doc comment change only; proves every golden byte-identical; no -update run, the generator is untouched)",
      "GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -v -timeout 19m ./internal/core/providers ; same for ./internal/core/agents ; same for ./contract/ledger if its doc.go changes",
      "gofmt -l <changed Go files>; go vet ./internal/core/providers ./internal/core/agents ./contract/ledger; staticcheck on the same packages",
      "Golden byte check in the evidence: SHA-256 of contract/ledger/testdata/f3/14/log/00000000000000000001.jsonl equals 74d43897fb8d8c7275599270fc874a1ca7f8911ba35ea197b4d8c11b8a7dedaa and git status shows nothing under contract/ledger/testdata",
      "Rule breaks (a)-(d): hash openai_usage.go, apply the break, named tests red, restore exactly, green; record hashes before and after",
      "PM fuzz campaigns after commit: go test -run '^$' -fuzz '^FuzzOpenAIResponsesSSE$' -fuzztime 120s -parallel=1 ./internal/core/providers ; same for '^FuzzProviderProfile$'",
      "No race run: no locking, goroutine, channel or shared-state change"
    ],
    "breaks": [
      "(a) money: accept a nonzero ttl_12h_tokens -> the 12h vector settles instead of holding, red",
      "(b) money: skip the sum check -> the disagreeing-split vector settles, red",
      "(c) money/evidence: apply v2's tolerance under v1 -> the live-shaped fixture's v1 row and TestOpenAIUsageUnknownAndNull's {} and {future:0} rows go red",
      "(d) money: infer cache_write_tokens from the split sum when it is absent or null -> the no-inference vectors settle, red"
    ],
    "fuzz": [
      "FuzzOpenAIResponsesSSE (changed code): seeds for the live-shaped terminal, a consistent nonzero 30m split, a nonzero 12h split and a disagreeing split; the body reads every input under both a v1 and a v2 profile (each compiled against its own digest) and asserts: v1 priceable implies v2 priceable with reflect.DeepEqual units and equal ProfileViolation; v2 held implies v1 held",
      "FuzzProviderProfile (changed validation): seed the canonical v2 profile",
      "Not due: FuzzPaidGroupReplay (no agents production change), FuzzPaidMoney (money.go unchanged), FuzzDecodeF3_13 (no codec change)"
    ]
  },
  "record": [
    "D164 title: usage schema openai-responses-text-30m-kguard/v2 added to F3-13's OpenAI producer values; date 2026-10-30; decided by assistant under D125; the S4 commit SHA (placeholder until committed)",
    "Decision: v2 is a second accepted usage_schema value beside v1, both valid for live installation and historical replay; v2 keeps v1's eight classes, served tier, mandatory counters, band rule (short through 272,000, long from 278,529, 272,001-278,528 unknown with tariff_ambiguous and no release path) and the pricing of cache_write_tokens as the write class",
    "v2 adds: input_tokens_details.cache_write_tokens_details is known, an object with ttl_30m_tokens and ttl_12h_tokens; ttl_12h_tokens must be absent, null or 0, otherwise held with a profile violation; when the object is present the two members (absent or null as 0) must sum to cache_write_tokens, otherwise held with a violation; cache_write_tokens stays mandatory and is never inferred from the split; an unknown member at any depth of usage that is null, integer 0 or an object tree of such leaves does not hold; the tool_usage rule is unchanged",
    "v1 keeps its shipped rule: unknown members tolerated only as scalar null or 0, so the TTL split holds with a violation under v1; no v1 observation, result or replay changes meaning",
    "Golden: none added; chapter 14 unchanged, log digest 74d43897fb8d8c7275599270fc874a1ca7f8911ba35ea197b4d8c11b8a7dedaa; chapter 13 stays 50b41cf739cbef89bec234cf64873e80af85188b256c66d6cb1e86ebea3555ff; contract/ledger/testdata untouched",
    "Scope: no type, version, closed set, digest order, earlier byte or earlier reader rule changes; contract/ledger/doc.go's producer paragraph and docs/CONTRACTS.md's F3-13 paragraph gain one sentence each",
    "Drill: the live profile is rebuilt with v2 (new profile digest, recorded in the ticket's private evidence with the third attempt), same rates, limits, request and maximum 233,572 micros",
    "Amends: D163, by addition; docs/CURRENT-RULES.md's D163 line gains D164 in the same commit"
  ],
  "ownerGates": [],
  "notesForCoder": [
    "Thread the token, not a global: NormalizeUsage's openai case calls normalizeOpenAIUsage(p.UsageSchema, raw) (or a bool derived from a two-case switch with an ErrUnsupported default); keep the v1 branch's checks and order exactly as today so every existing v1 test passes untouched.",
    "Check order under v2: knownUsage at the root (with the zero-tree tolerance) and tool_usage; mandatory input/output; input_tokens_details known set of three; mandatory cached/write counters; then the split (shape, member grammar, 12h zero, big.Int sum equals write); then cache <= input, total_tokens, output_tokens_details, band. The split is a consistency check only; units still come from cached_tokens, cache_write_tokens, input_tokens and output_tokens.",
    "Generalize absentCharge into a bounded zero-tree predicate used by knownUsage under v2 only; do not reuse emptyOpenAIToolUsage for it (nested null differs) and do not change tool_usage handling in providers or agents.",
    "profile.go:155: replace the single-token equality with membership in the two-token set for both validate(false) and validate(true); keep TestOpenAIProfileRefusals' 'other' row and add v3 refused, v2 accepted.",
    "The sanitized fixture is the shape file's usage and tool_usage with synthetic ids (no real response id, request id or organization value); assert the v2 read keeps Blocks and the v1 read nils them with ProfileViolation true; assert units by class, not by cost alone, then PriceUsage at 4 micros.",
    "Core row: a v2 variant of paidOpenAIProfile (different CapabilityVersion suffix so the digest differs), PrepareOpenAI through RecordPaidObservation on the existing loopback SSE helper, assert settled 4 micros, then Open the same store again and assert the attempt view unchanged; no sleeps, t.Parallel as the neighbours.",
    "Do not touch contract/ledger/paid_openai_golden_test.go, contract/ledger/testdata, openai_stream.go's product code or any v1 expectation; if a v1 test needs editing to pass, the v1 branch has changed and that is a defect.",
    "Fuzz: compile both profiles inside the body (openAICompiled(t, p, 16) per profile, since Compiled carries the digest) and assert the monotonic invariant; seeds as listed; the seeds run in every check.",
    "Documentation text: one paragraph in providers/doc.go, the token sentence in agents/doc.go, no other prose; LF, package-scoped Conventional Commit (providers:), no credential, vendor key format, variable name, private path or owner quote anywhere.",
    "Pre-existing, not in scope: a profile-violation hold carries error_class protocol_error (as the second attempt shows); leave it; the PM may list it at the close with S2's note 1."
  ],
  "checked": [
    "local://t14-s4-ruling-request.md whole; local://t14-s4-brief.md whole with line 15 raw; local://t14-live-usage-shape.json whole; local://t14-docs-notes.md whole with lines 18-19 raw",
    "local://t14-ruling.md: verdict, P1-P9 with lines 14 (P2), 29 (P5), 49 (P9) raw, amendments 1-7, compatibility table, slice plan, owner gates, notes; local://t14-openai-facts.md lines 76-77, 182-186, 236-238, 269-276, 291-303",
    "docs/DECISIONS.md D163 raw (lines 3211-3217) and D160-D162 headers; docs/CURRENT-RULES.md lines 3-41 and 72-77; docs/CONTRACTS.md line 140",
    "14-merge: internal/core/providers/openai_usage.go 1-172 whole; usage.go 59-281; profile.go 79-213; openai_stream.go 19-83 and every ProfileViolation site; money.go 42-56; json.go checkJSON depth bound; providers/doc.go 56-60",
    "14-merge: internal/core/agents/paid_settlement.go 19-263; paid_attempt.go 15-18, 40-80, 330-395; paid_capture.go observation fields and construction (grep); agents/doc.go 646-649; grep of every usage_schema, UsageSchema, NormalizeSealedUsage, PriceHistoricalUsage and ValidateHistorical site in agents and contract/ledger",
    "14-merge: contract/ledger/doc.go 2427-2463; contract/ledger/paid_profile.go check and reader lines (grep); chapter 13 and 14 golden profile lines (grep)",
    "14-merge tests: openai_usage_test.go 114-187; openai_stream_test.go 281-310; profile_money_test.go 240-275; openai_test.go test names and the usage refusal row; agents paid_openai_test.go 19-63 and test names; paid_fixture_test.go, paid_live_test.go, paid_billing_test.go, scoped_service_test.go helper names (Open-based reopen)",
    "Arithmetic recomputed: ceil(9/10 + 5/2) = 4 micros with the fixture tariff; the drill maximum 233,572 unchanged by the token",
    "Not read: the live-attempt logs, config files and drill driver source (private, external), local://t14-s3-review.md, the ticket file; no SHA-256 recomputed; no commands, edits or subagents"
  ]
}
```
