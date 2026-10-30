```json
{
  "verdict": "approve-with-amendments",
  "summary": "The brief is faithful to T14:35-40, D148/D149, D150 and ticket 13's ruling. Every P-choice stands; four are amended (P5, P7, P9 and S1's refusal placement) to make the drill likelier to settle, to drop an unneeded secret seam, and to label the P9 hold honestly. Nothing frozen breaks; every change to F3-13 is additive vocabulary the PM records under D125. The drill maximum USD 0.230512 is correct for 16 output tokens; with amendment 1 (4,096 output tokens) it is USD 0.233572.",
  "rulings": [
    {
      "id": "P1",
      "disposition": "approve",
      "ruling": "Closed provider switches at the existing semantic boundaries; one Service, one budgetBook, one paidRuntime, one providers.Transport and the existing Secret.WithBytes borrowing, unchanged. The cutover inventory (brief line 259) matches every Anthropic-only site the code holds: providers/profile.go:87-106 (endpoint hardcodes /v1/messages and api.anthropic.com), :120-194 (provider, api_version, usage_schema, models, tiers, cache classes, tariff class list, source hosts); envelope.go:48-63 (three-header set); transport.go:117-120 (endpoint); money.go:103-108,160-199 (allClasses, inputClasses, Generated singleton); usage.go:72-114,206-261; response.go:35-49 (header allowlist), :53-101 (reader), :104-149 (classifier); agents/paid_prepare.go:111,166-170; paid_admit.go:160; paid_controls.go:321,340; paid_dispatch.go:155,186; paid_attempt.go:38,41-70,334-337; paid_settlement.go:69-161; paid_capture.go:144,319. No other choke point exists: paid_budget.go and paid_plan.go are provider-neutral (paid_plan.go:61,76-82 already match credential and route providers generically). Anthropic bytes and behaviour stay unchanged because each site keeps its Anthropic branch verbatim and the new observation/error members are omitempty (paid_capture.go:40-60). Unknown providers remain historical/held and never reach a live site. Amendment 5 fixes which refusals must already land in S1."
    },
    {
      "id": "P2",
      "disposition": "approve",
      "ruling": "Eight sorted classes, pricing_tier default_short/default_long, served_tier default and usage schema openai-responses-text-30m-kguard/v1 inside schema 1 are additive: classes, tiers and identifiers are open (contract/ledger/doc.go:2331-2337, 2366-2367, 2372-2377, 2391-2401); tariff stays {currency,rates} sorted by class; digest orders untouched; the frozen bound rule (doc.go:2421-2425) is obeyed with I_cap=min(922000,1050000)=922000 at the largest of the six input-band rates and O_req at the largest of the two output rates, one ceiling, no subtraction. Settlement selects the band once from inclusive input_tokens, prices at admission rates with one ceiling; replay re-derives the band and refuses both-band units, a wrong label, an unknown tier or an unpriced class (paid_attempt.go:311-360 becomes a provider switch). Recomputed from OF:28-33: Luna 230,512; Sol 4,610,240; Astra 23,051,200; 11/10 uplift 253,564; I=20,R=4,W=8,O=16 -> 10; I=272000 -> 27,208; I=278529 -> 55,718; I=1,R=1,O=17 -> 9; I=922001 -> 184,413 with violation; I=W=922000,O=17 -> 230,513 with violation; mixed ceiling 430,591. All correct."
    },
    {
      "id": "P3",
      "disposition": "approve",
      "ruling": "The canonical Request/ParseRequest subset (anthropic.go:49-57,86-96) compiled once into the fixed Responses key order with explicit stream/store/service_tier/truncation/background/include/prompt_cache_options/text; every value is a digest fact (OF:60-86, 287-303, 305-325; 30m is the create schema's only ttl, mode implicit and prewarm false are its defaults, pinned anyway). Function tools as {type:function,name,description?,parameters,strict:false}, parallel_tool_calls:false, tool_choice auto/none (OF:68, 311-317); returned function_call mapped by call_id for declared names only (OF:319-321). The refusals at brief line 76 fail closed on OF:269-281 items 3, 4 and 7. Nothing of ticket 15 is built: no execution, continuation or artifact-driven loop."
    },
    {
      "id": "P4",
      "disposition": "approve",
      "ruling": "gpt-6-luna, gpt-6-sol and gpt-6-astra with context 1,050,000, input 922,000, output 128,000 are explicit integers in the digest (OF:9-10), not 1M shorthand, so ticket 13's OG-MODEL-FACTS reasoning (ticket-13-design-ruling.md:17) does not apply. The Model object carries id, created, object, owned_by and shutdown_date and no limit field (OF:246-248), so a keyed limit lookup is impossible; 'no keyed limit lookup' is right. Rates match OF:28-33; 12h writes not enabled (OF:234, 240 schema conflict; no TTL split in usage, OF:188); regional +10% refused rather than priced (OF:42-44, eligibility unverified); Fast/Priority/Ultrafast/Scale/Flex/Batch refused (OF:46-52, 162). Source hosts developers.openai.com/api.openai.com match every digest URL. Synthetic loopback profiles stay synthetic-only."
    },
    {
      "id": "P5",
      "disposition": "amend",
      "ruling": "Terminal-authoritative usage and output, snapshots replace rather than add, RawUsageMerged a copy of the terminal usage only, null never zero, required nonnull input/output/cached/write counters with R+W<=I in big integers, reasoning inside output, total_tokens a consistency check only, served tier required and equal to default, first valid terminal decides, body closed after it, no EOF success, unknown or hosted events held: all consistent with OF:92-96, 158-200, 182-186 and T14:37. Amendment 4 tolerates explicit-zero unknown counters and empty/zero tool_usage so a documented zero cannot hold a complete terminal; amendment 3 relabels the P9 hold. A terminal whose model differs from the pinned ID stays held (see notes)."
    },
    {
      "id": "P6",
      "disposition": "approve",
      "ruling": "No OpenAI no-charge rule: no_charge_rules empty, the no_charge_billing topic quotes the documented incomplete-reasoning charge (OF:198-200), and the general partial/failed/cancel/disconnect rule is unverified (OF:220-222). Refusal, incomplete and failed terminals settle reported units only when complete and consistent; errors, error events, EOF, disconnects and deadlines hold; content invalidity never erases complete usage. Retained: allowlisted headers, raw usage/status/incomplete_details, structured errors with code/param (unfrozen private encoding), opaque reasoning items as opaque_provider blocks; never auth bytes, the request, raw SSE or arbitrary headers. 408/504 as provider_error is acceptable: classes are observations, not money or retry policy."
    },
    {
      "id": "P7",
      "disposition": "amend",
      "ruling": "One last-slice live attempt, gpt-6-luna, global, default tier, store:false, one user text 'Reply OK.', no system/tools, explicit 30m implicit caching, no prewarm, one POST, no retry, after S1-S3 local evidence and the owner's answers: approved. The brief's maximum 230,512 micros is right for 16 output tokens (922,000 x 1/4 = 230,500; 16 x 3/4 = 12). Amendment 1 raises max_output_tokens to 4,096 (maximum 233,572 micros): reasoning tokens share the output cap (OF:66, 186, 198-200) and a 16-token cap would most likely end incomplete before any visible answer, wasting the one authorized attempt. Amendment 2 removes the proposed private host seam: the throwaway in-package test borrows the bound Secret exactly as existing in-package tests do (paid_credentials_test.go:37, paid_native_windows_test.go:108); production code gains no accessor. The GET pre-flight stays, disclosed inside OG-GO with an opt-out. The brief names no variable and no credential bytes; checked line by line."
    },
    {
      "id": "P8",
      "disposition": "approve",
      "ruling": "Three slices, drill last, each complete and reviewable alone: S1 record-free providers adapter; S2 Core cutover with the additive producer record and F3-13's OpenAI golden, reviewed together under D125; S3 both-adapter crash/physical-send matrix, explicit new attempt, operating reference, then the drill. C5's mixed-provider rows are S2's: they prove the one-book cutover and run under S2's race campaign; S3 reruns them. The slice plan below fixes owned paths, commands, breaks and fuzz targets."
    },
    {
      "id": "P9",
      "disposition": "amend",
      "ruling": "The guarded interpretation is approved: short only at I<=272,000, long only at I>=278,529, 272,001..278,528 held as unknown with the full hold, no bound-violation fence, no guessed band, no price override; the admission maximum is band-independent so the hold is money-safe, and the drill (about ten input tokens) is unaffected. Assuming decimal K is rejected; holding all OpenAI usage is unnecessary. Amendment 3: the held result's error_class is tariff_ambiguous, not protocol_error, so later consumers (service-loss detection reads error classes) never mistake an accounting ambiguity for a provider failure; the observation keeps the threshold_ambiguous detail. The interval's hold has no release path under this usage schema; the close records it as a limit. A later documented integer needs a new usage-schema token and profile, never a reinterpretation of settled history."
    }
  ],
  "compatibility": [
    {
      "change": "OpenAI version-1 writer header set: accept:text/event-stream and content-type:application/json",
      "class": "additive",
      "reason": "SemanticHeader rules (contract/ledger/doc.go:2359-2361) and the request preimage (doc.go:2411-2417) are unchanged; the sentence 'version-1 writers use exactly accept, anthropic-version and content-type' becomes per-provider wording. D148 Consequences: well-formed new values of open tokens need no type version. The PM records it under D125 before S2 integrates; the Anthropic set and bytes stay verbatim (paid_attempt.go:38 keeps its branch)."
    },
    {
      "change": "Usage classes input.cached.long/short, input.uncached.long/short, input.write.long/short, output.generated.long/short; pricing_tier default_short/default_long; served_tier default",
      "class": "additive",
      "reason": "Classes and tiers are open tokens (doc.go:2331-2337, 2372-2377); the five-class sentence remains an Anthropic writer rule. The ledger codec (paid_values.go:212-216) checks only the grammar."
    },
    {
      "change": "Profile values provider openai, authority api.openai.com, path /v1/responses, api_version v1, region global, requested_tier default, allowed_served_tiers [default], usage_schema openai-responses-text-30m-kguard/v1, cache_classes of four tokens, tool_choices [auto,none], no_charge_rules [], eight tariff rates",
      "class": "additive",
      "reason": "Profile schema 1 and the compact digest order are untouched (doc.go:2391-2409); identifiers are visible ASCII 1..128, region/tier tokens open, rates sorted by class. Supported models/tiers/classes are producer rules, not frozen (D148 Not frozen)."
    },
    {
      "change": "Quote with one six-class input dimension and one two-class output dimension; the output dimension identified by the provider's output-class set instead of the Anthropic singleton",
      "class": "additive",
      "reason": "CostBound/PricedDimension admit any non-overlapping sorted class sets (doc.go:2369-2371); the producer bound rule (doc.go:2421-2425) is obeyed; the identification rule is producer interpretation the PM records with the same entry. Quote hashing (doc.go:2419-2427) is unchanged."
    },
    {
      "change": "error_class writer value tariff_ambiguous (amendment 3)",
      "class": "additive",
      "reason": "error_class is open and D148 names no version-1 writer value; the service's accepted list (paid_attempt.go:322, paid_settlement.go:70) gains the token; recorded in the same PM entry."
    },
    {
      "change": "credential_changed.provider openai; paid.credential.bind with provider openai",
      "class": "additive",
      "reason": "Provider is an open token (doc.go:2331); paid_controls.go:340's Anthropic-only refusal is a service rule, not a codec rule."
    },
    {
      "change": "Observation members served_tier? and tool_usage? after stop_details; error members code? and param? after request_id; output block opaque_provider with artifact_kind responses_reasoning",
      "class": "none",
      "reason": "The output and observation encodings are explicitly not frozen (D148 Not frozen; records name them by digest and size). omitempty keeps every Anthropic object byte-identical, so the F3-13 fixture objects under testdata/f3/13/objects stay unchanged."
    },
    {
      "change": "New golden contract/ledger/testdata/f3/14 as F3-13's OpenAI producer sample, generated only by TestGoldenOpenAIStatic -update",
      "class": "additive",
      "reason": "No earlier golden changes; D149's golden keeps SHA-256 50b41cf739cbef89bec234cf64873e80af85188b256c66d6cb1e86ebea3555ff; Defined() stays at forty-nine type versions; no catalogue family is added (amendment 6 names it F3-13's second golden)."
    },
    {
      "change": "F3-10, F3-11, F3-12 and F3-139 text, bytes, receipts, lookups, group shapes and goldens",
      "class": "none",
      "reason": "Untouched; F3-13 groups embed none of their records (doc.go:2319-2320)."
    },
    {
      "change": "Closed sets (result kind, credential action, spend mode, period kind, scope kind, profile schema, schema-4 operations), known-field digest orders, old bytes and old reader rules",
      "class": "none",
      "reason": "Nothing in the brief or this ruling touches them; OG-BREAK is not triggered."
    }
  ],
  "amendments": [
    "1. P7: the drill request uses max_output_tokens 4,096 (not 16). Its full rectangular maximum is ceil(922,000 x 1/4 + 4,096 x 3/4) = 230,500 + 3,072 = 233,572 micros = USD 0.233572; the code must recompute and display exactly this figure before dispatch, and any other figure stops the drill for a fresh go. Every local fixed vector keeps its 16-output admission.",
    "2. P7/credentials: no private host seam and no production accessor is added. The throwaway in-package drill test borrows the bound version through the existing package-private field, service.paid.secrets[version].WithBytes, exactly once, solely for the one GET /v1/models/gpt-6-luna, creating and closing its dedicated verified-TLS HTTP/1 client inside that borrow; it retains only the HTTP status, id, object, created and the absence of a nonnull shutdown_date, nothing else from the body; a non-200, a different id or a nonnull shutdown_date stops the drill.",
    "3. P9: an attempt whose final inclusive input_tokens lies in 272,001..278,528 ends as kind unknown with error_class tariff_ambiguous (a new version-1 writer value in the PM's additive record; accepted by the derivation and replay class lists), never protocol_error; the observation keeps the threshold_ambiguous detail, the final counters and the served tier. The close records as a limit that such a hold has no release path under openai-responses-text-30m-kguard/v1.",
    "4. P5/P6: an unknown usage member at any depth whose value is JSON null or the plain integer 0 does not hold a terminal; tool_usage absent, null, an empty object, or an object whose every leaf is a plain integer 0 does not hold; any other unknown member, any nonzero or non-integer leaf, or an unknown shape holds the attempt, and nonzero tool usage additionally flags a profile violation. The required cached/write/input/output counters and the served tier stay mandatory and are never inferred.",
    "5. P1/S1: S1 lands the provider-explicit refusals inside internal/core/providers with their tests: CompileAnthropic, Seal (header set keyed on Profile.Provider), ReadAnthropicStream/ReadAnthropicResponse, NormalizeUsage/NormalizeSealedUsage, Bound/BoundHistorical/Maximum, PriceUsage/PriceHistoricalUsage and endpoint() refuse a profile of the other provider, and endpoint() validates (provider, authority, path) as a pair: anthropic with api.anthropic.com or loopback and /v1/messages; openai with api.openai.com or loopback and /v1/responses; never a union. S2 cuts over the Core sites (paid_controls.go:321,340; paid_prepare.go:111,166-170; paid_admit.go:160; paid_dispatch.go:155,186; paid_attempt.go:38,41-70,334-337; paid_settlement.go:69-161; paid_capture.go:144,319) and refuses any provider other than the two at every live site; the Anthropic branches keep their current bytes.",
    "6. S2 golden and record: the sample under contract/ledger/testdata/f3/14 is named and recorded as F3-13's second golden (OpenAI producer values), replayed by TestPaidGroupRulesAndFrozenReplay as chapter 14 beside 10-13. The PM's additive entry lists exactly: provider openai, the two-header writer set, the eight classes, the tier values, the usage-schema token with its P9 interpretation, the output-dimension identification rule, and error_class tariff_ambiguous. S2 integrates only after that entry, its review and the exact-SHA hosted check; the -update run must leave testdata unchanged and every earlier golden's SHA-256 equal to its D entry.",
    "7. Evidence: the private observation may retain the allowlisted openai-organization and x-request-id values and the drill colony may record the credential's source locator, but no published evidence, ticket text, commit message or summary carries any of them; the PM's outgoing scan keeps D150's variable as a stop pattern."
  ],
  "slicePlan": [
    {
      "slice": "S1 - record-free OpenAI adapter (providers)",
      "ownedPaths": [
        "internal/core/providers/openai.go (new: CompileOpenAI, wire body, refusals)",
        "internal/core/providers/openai_stream.go (new: ReadOpenAIStream, event policy, terminal validation)",
        "internal/core/providers/openai_usage.go (new: normalization, band selection, ErrTariffAmbiguous, pricing over eight classes)",
        "internal/core/providers/openai_response.go or inside response.go (ReadOpenAIResponse, header allowlist, classifier)",
        "internal/core/providers/profile.go, envelope.go, transport.go, money.go, usage.go, response.go, anthropic.go, anthropic_stream.go, doc.go (provider switches and provider-explicit refusals)",
        "internal/core/providers/*_test.go (new openai_*_test.go; transport_test.go and existing rows parameterized over both envelopes)"
      ],
      "delivers": "Sections 4-6 of the brief with amendments 3, 4 and 5: compiler, parser, usage/tariff interpretation, provider-paired endpoint/header validation, one-shot transport proof on an OpenAI envelope; no agents writer, no ledger change, no service stub; every Anthropic expectation preserved.",
      "commands": [
        "GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -timeout 19m -run 'TestOpenAI|TestPaidHTTP1OneShot|TestTransport|TestEnvelope|TestNormalize|TestHistorical|TestProfile|TestRectangular|TestMoney|TestAnthropic' ./internal/core/providers",
        "GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -v -timeout 19m ./internal/core/providers",
        "gofmt -l <changed Go files>; go vet ./internal/core/providers; staticcheck ./internal/core/providers",
        "No race run unless transport.go's shared state changes (it should not)."
      ],
      "breaks": [
        "D (money): omit the long or write rate from the eligible maximum; round the two dimensions separately; subtract output from input; add reasoning or cache a second time -> the named bound/settlement vectors go red",
        "F (money/evidence): add snapshot usage instead of replacing; treat a null cached/write counter as zero; accept a terminal without served tier -> the parser fixtures go red",
        "G (recovery): rewindable body, idempotency header with GetBody, redirect following, HTTP/2 on the OpenAI envelope -> the warm-connection and ALPN rows go red"
      ],
      "fuzz": [
        "FuzzOpenAIResponsesSSE (new)",
        "FuzzOpenAIRequest (new)",
        "FuzzProviderProfile (changed)",
        "FuzzProviderSSE (if the shared framing reader changes)",
        "FuzzPaidMoney (money.go changes)"
      ]
    },
    {
      "slice": "S2 - one Core book, PrepareOpenAI, additive producer record and F3-13's OpenAI golden",
      "ownedPaths": [
        "internal/core/agents/paid_types.go (OpenAIInput), paid_prepare.go (shared lifecycle helper, PrepareOpenAI), paid_admit.go, paid_controls.go, paid_dispatch.go, paid_attempt.go, paid_capture.go, paid_settlement.go, paid_live.go, paid_objects.go, doc.go (caller sequence lines only)",
        "internal/core/agents/paid_openai_test.go, paid_mixed_test.go (new) and extended paid_*_test.go fixtures",
        "contract/ledger/doc.go (additive producer text only), contract/ledger/paid_openai_golden_test.go (new), contract/ledger/testdata/f3/14/ (new)",
        "PM-owned with the slice: the D-NEXT additive entry, docs/CURRENT-RULES.md line, docs/CONTRACTS.md F3-13 row text"
      ],
      "delivers": "C1, C2, C3 (Core side) and C5: full public caller path for both providers, provider-paired authority/header/credential checks, OpenAI quote reconstruction, capture and output publication, live and late derivation, replay settlement for eight classes and two tiers, mixed-provider scope arithmetic and shared borrowers; no prior golden change, no catalogue or type-version change; stops at OG-BREAK if any closed set would have to change.",
      "commands": [
        "GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -timeout 19m -run 'TestOpenAI|TestPaidMixedProviderScopes|TestPaidSealAndQuote|TestPaidCredentialPinning|TestPaidSettlementAndCorrection|TestPaidPeriodsWarningsAndOverrun|TestPaidParentEndingAndDisclosure|TestPaidGroupRulesAndFrozenReplay|TestPaidAuthorityAndAttenuation|TestPaidProfileAndFeatureRefusal|TestPaidAtomicScopes|TestPaidIntentBeforeBytes|TestAnthropic' ./internal/core/agents",
        "GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -timeout 19m -run 'TestGolden|TestF3_13|TestPaid' ./contract/ledger",
        "GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -timeout 19m -run '^TestGoldenOpenAIStatic$' ./contract/ledger -update ; then testdata must be unchanged and every earlier golden's SHA-256 must equal its D entry (f3/13 log = 50b41cf739cbef89bec234cf64873e80af85188b256c66d6cb1e86ebea3555ff)",
        "GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -v -timeout 19m ./internal/core/agents ; same for ./contract/ledger",
        "Race (configured race toolchain): go test -race -count=1 -timeout 29m ./internal/core/agents ; go test -race -count=20 -timeout 45m -run 'TestPaidMixedProviderScopes|TestPaidAtomicScopes|TestPaidIntentBeforeBytes|TestPaidSettlementAndCorrection|TestPaidCredentialPinning' ./internal/core/agents",
        "gofmt -l <changed Go files>; go vet ./internal/core/agents ./contract/ledger; staticcheck on both"
      ],
      "breaks": [
        "A (disclosure): select the artifact by the launcher's current selection instead of the admission origin -> C1 cross-origin read goes red",
        "B (credentials): accept a credential whose scope provider differs from the route, or re-read the source at dispatch -> C1 credential-pin rows go red",
        "C (recovery/zero send): skip the seal/quote recheck at admission or intent -> mutated envelope reaches intent, rows go red",
        "D (money): price the long band at short rates in Core derivation or replay; settle both bands with units -> C2 rows go red",
        "E (money): per-provider wallet or dropped common ancestor -> the 430,591 ceiling vector admits both",
        "F (money): null cached/write -> 0 in Core derivation -> C3 money rows go red",
        "H (money): second release or correction in the current period; clamp actual usage to the quote -> C5 exposure/fence rows go red"
      ],
      "fuzz": [
        "FuzzPaidGroupReplay (replay code changes)",
        "FuzzDecodeF3_13 only if any contract/ledger codec code changes (it must not; doc text and a golden generator are not codec code)"
      ]
    },
    {
      "slice": "S3 - both-adapter recovery and physical-send matrix, operating reference, drill",
      "ownedPaths": [
        "internal/core/agents/paid_crash_test.go (both provider execution paths over the 35 boundaries; Anthropic-only no_charge rows stay Anthropic)",
        "internal/core/agents/paid_exchange_test.go and shared paid safety tests (TestPaidExplicitNewAttemptAfterUnknown, warm-connection request counts for both envelopes)",
        "internal/core/providers/transport_test.go only if a C4 gap remains",
        "internal/core/agents/doc.go, internal/core/providers/doc.go (final caller sequence, OpenAI subset, classes/tiers, held/settled meaning, limits including the P9 interval and the terminal-event size limit)",
        "Throwaway internal/core/agents/zz_t14_s3_drill_test.go (removed before commit; source and sanitized output retained externally)"
      ],
      "delivers": "C4 and C6 plus the live drill: one POST per attempt for both real adapters under every crash window, no recovered send permit, explicit new attempt beside unresolved holds, the C1-C6 consumer smoke through the public typed interface with zero network on plain reopen, and the section 8 drill with amendments 1 and 2 after local evidence and the owner's answers; a missed gate reports 'OpenAI drill not run: <gate>'.",
      "commands": [
        "GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -timeout 19m -run 'TestPaidInjectedCrashRecovery|TestPaidExplicitNewAttemptAfterUnknown|TestPaidMixedProviderScopes|TestOpenAI|TestPaidIntentBeforeBytes|TestPaidCloseDrainsAndReconcileHolds' ./internal/core/agents",
        "GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -timeout 19m -run 'TestPaidHTTP1OneShot|TestTransport' ./internal/core/providers",
        "GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -v -timeout 19m ./internal/core/agents (and ./internal/core/providers if changed); race whole-package and x20 on touched race-sensitive rows only if shared-state product code changes",
        "Drill, local mode first then live mode after every gate: GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -timeout 19m -run '^TestT14OpenAILiveDrill$' ./internal/core/agents -args -t14-private-config=<external private config>; never rerun live mode",
        "gofmt -l, go vet and staticcheck on changed packages"
      ],
      "breaks": [
        "G (recovery): a replayed admission regains a prepared call or a historical dispatch returns a fabricated ObservedPaidCall -> crash/recovery rows go red for both adapters",
        "C (zero send): a changed body, header, model or destination after admission passes dispatchGuardsLocked -> no-intent/no-POST rows go red"
      ],
      "fuzz": [
        "None new; rerun S1/S2 targets only if their product code changes in S3"
      ]
    }
  ],
  "ownerGates": [
    {
      "id": "OG-SPEND",
      "question": "For ticket 14's already-authorized OpenAI drill, do you select finite lifetime ceilings of USD 1.000000 in each of the throwaway drill colony's four scopes (the colony, the drill agent, the OpenAI credential scope and the root model-call grant), with no warning threshold, or other finite figures? The book will hold the drill's full computed maximum, USD 0.233572 (233,572 micros: 922,000 input tokens at the highest long-context cache-write rate of $0.25 per million plus 4,096 output tokens at $0.75 per million); a ceiling below that refuses the drill rather than shrinking the bound. This version fixes the colony's period kind (lifetime) at its first spend configuration.",
      "waits": "Creating the drill colony's spend terms only; S1-S3, fixtures and local proof do not wait."
    },
    {
      "id": "OG-GO",
      "question": "The drill is one gpt-6-luna Responses attempt: global endpoint, service tier default, store false, no system text or tools, one user message 'Reply OK.', max_output_tokens 4,096 (reasoning tokens count inside this cap; at 16 the model would most likely stop before any visible answer), explicit 30-minute implicit caching with no prewarm, one POST, no retry, no second model. Its full computed maximum is USD 0.233572 (233,572 micros), not the expected prompt cost. Before the POST the drill host issues one free read-only GET /v1/models/gpt-6-luna with the same key, only to confirm the key reaches the model and no shutdown_date is set (it yields no token limits). Once S1-S3's local evidence, the recorded additive producer entry and that check pass, may we dispatch exactly this one attempt with the key from D150's variable? If anything changes the recomputed maximum, we stop and ask again with the new figure.",
      "waits": "The pre-flight GET and the physical POST; nothing local waits."
    },
    {
      "id": "OG-LOOKUP",
      "question": "Folded into OG-GO as the disclosed free pre-flight GET; ask separately only as: 'Say if you want the pre-flight GET /v1/models/gpt-6-luna struck; the drill then relies on the documented limits alone.'",
      "waits": "The GET only. Striking it does not block the POST; keeping it makes a non-200, a different id or a nonnull shutdown_date stop the drill."
    },
    {
      "id": "OG-BREAK",
      "question": "Not triggered: no closed set, known-field digest order, old byte or old reader rule changes; every F3-13 change above is additive and the PM records it under D125. No question is asked.",
      "waits": "Nothing."
    }
  ],
  "notesForCoders": [
    "Provider switches: key every switch on Profile.Provider with exactly two live cases, anthropic and openai, and an explicit ErrUnsupported default; never a host or path allowlist independent of the provider. endpoint() takes the provider and validates the (provider, authority, path) pair; loopback stays loopback-with-port only.",
    "semanticHeaders selects the exact set per provider: Anthropic's three (unchanged bytes), OpenAI's two (accept, content-type), sorted; Seal keeps its signature.",
    "Maximum/bound/priceUsage take the provider's class universe (five Anthropic, eight OpenAI) for the overlap and count checks; the output dimension is the provider's output-class set; keep one ceilMicros over the rational sum.",
    "OpenAI band selection is a pure function of inclusive input_tokens with the two pinned constants 272000 and 278528; the four edge vectors (272000, 272001, 278528, 278529) are asserted through status, not only in a math test.",
    "The served tier for OpenAI is the terminal response object's service_tier, not a usage member; the OpenAI derivation reads the observation's served_tier and never RawUsageMerged[\"service_tier\"].",
    "Observation struct: served_tier and tool_usage as omitempty members right after stop_details; error struct: code and param as json.RawMessage omitempty after request_id so null survives and absence is omitted; Anthropic captures must serialize byte-identically (assert against an F3-13 fixture object).",
    "provider_request_id comes from one x-request-id value for OpenAI (paid_capture.go:144 becomes a provider switch); keep the 64 KiB header retention bound.",
    "Terminal-event size: all output and encrypted reasoning arrive in the terminal response event; with the shared 1 MiB event limit a large legitimate terminal is held, not truncated. Either keep the limit and document it, or give the OpenAI reader a terminal-event limit equal to the 8 MiB output limit with the same before-retention checks; record whichever as a limit in doc.go.",
    "If the terminal's model is not the pinned ID (OpenAI may serve a dated snapshot for an alias), the attempt is held and the observation keeps the served string; the drill then reports held with the served ID for a later profile revision, never a second attempt without a fresh go.",
    "Tests: real temporary stores, loopback TLS/SSE, serviceDeps seams only, t.Parallel except process-state and crash helpers, channel barriers not sleeps, synthetic credentials matching no key format, never log a request, header or value. Byte fixtures only for pure compiler/parser/pricing tests.",
    "Drill test: generic flag name, external private config with locator/colony directory/profile/gate references only; borrow the pinned Secret through service.paid.secrets[version].WithBytes for the GET exactly once; use public OpenPaid and the public Prepare->Admit->Dispatch->Record sequence for the attempt; print only sanitized proof; delete the file before any commit; hash product files before and after any rerun of local mode.",
    "Commit messages, test names, fixtures and logs: no credential, no vendor key format, no variable name, no private path, no owner quote."
  ],
  "checked": [
    "local://t14-brief.md: all 299 lines, every truncated line re-read raw (30-60, 60-110, 110-160, 160-222, 222-262, 262-299); no variable name or credential byte anywhere in it",
    "local://t14-openai-facts.md lines 1-333 raw, including Open and unverified (269-281) and Supplement 1 (283-333); the three model integers at 9-10, rates at 28-33, threshold wording at 22 and 331-333, create schema at 60-86 and 287-303, events at 92-176, usage at 182-188, tiers at 160-162, incomplete billing at 198-200, errors at 212-214, Models object at 246-248",
    "local://t14-design-assignment.md whole; ticket 14 whole including line 61 raw",
    ".scratch/dwarf-harness/c3-evidence/ticket-13-design-ruling.md: verdict, P5/P7/P9/P10/P11, owner gates (lines 17, 32, 33, 37 raw) and limits",
    "docs/CURRENT-RULES.md whole; docs/DECISIONS.md D148 (2969-2989), D149 (2991-2999), D150 (3001-3013) raw",
    "contract/ledger/doc.go 2290-2600 (F3-13 types, nested values, profile/digest encodings, request and quote hashing, record rules, schema-4); contract/ledger/paid_values.go:212-216, 266-270 (PaidUsage check and reader)",
    "internal/core/providers: profile.go 1-203, money.go 100-230, usage.go 1-261, response.go 20-160, envelope.go 1-103, anthropic.go 1-133, anthropic_stream.go 1-98, transport.go 60-150",
    "internal/core/agents: paid_prepare.go 15-24 and 60-230, paid_dispatch.go 100-210, paid_attempt.go 25-75 and 300-390, paid_settlement.go 60-175, paid_capture.go 40-100, paid_live.go 1-73; grep of every provider/authority/anthropic site in paid_admit.go, paid_controls.go, paid_plan.go, paid_state.go, paid_objects.go, service.go",
    "Existing test and fuzz names in agents, providers and contract/ledger (TestPaidInjectedCrashRecovery, TestPaidIntentBeforeBytes, TestPaidHTTP1OneShot, TestTransport*, TestPaidSealAndQuote, TestPaidCredentialPinning, TestPaidSettlementAndCorrection, TestPaidPeriodsWarningsAndOverrun, TestPaidAtomicScopes, TestPaidParentEndingAndDisclosure, TestPaidGroupRulesAndFrozenReplay, TestGoldenF3_13, FuzzProviderProfile, FuzzProviderSSE, FuzzPaidMoney, FuzzPaidGroupReplay, FuzzDecodeF3_13); in-package Secret borrowing at paid_credentials_test.go:37 and paid_native_windows_test.go:108",
    "skill://dwarfharness-provider-tickets whole (drill gate inheritance, one-POST breaks, driver pattern)",
    "Arithmetic recomputed by hand for every vector in the brief's sections 6.2, 8 and 9 and for the amended drill cap",
    "Not read: local://t13-brief.md and ticket-13-evidence.md beyond what the T13 ruling and the skill state; the brief's SHA-256 was not recomputed (no commands)"
  ]
}
```
