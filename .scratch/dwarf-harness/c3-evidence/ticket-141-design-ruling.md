```json
{
  "verdict": "approve",
  "rulings": [
    {
      "id": "P1",
      "disposition": "approve",
      "ruling": "Fix at the single derivation site: internal/core/agents/paid_settlement.go:162-163 becomes `} else if o.StopReason != \"refusal\" && len(o.MessageObjects) != 0 {` (brief cites 160-164; the branch is at 162-164 at aa81bb2). Confirmed as the only producer of a non-nil empty list into a runtime.paid_result or a paid.observe/paid.correct submission: (1) live record, late TrustedEvidence record and CorrectPaidSettlement all run recordPaidEvidence → derivePaidResult (paid_settlement.go:380) → paidObservationSubmission(result.MessageObjects) (:383); (2) the OpenAI branch already guards (`len(o.MessageObjects) != 0`, :225); (3) the duplicate/same-ID path (matchPaidObservation :419, `old.MessageObjects`) and replay (paid_attempt.go:234, :239, `v.MessageObjects`) copy a ledger-decoded RuntimePaidResult, and DecodeRuntimePaidResult sets MessageObjects only when the key is present and re-encodes through check(), so a decoded value is nil or nonempty, never empty non-nil; (4) the live-capture call derivePaidResult(a, o) at paid_capture.go:286 uses only result.Kind. Keep the `!= \"refusal\"` guard too: it preserves the frozen 'refusal selects none' rule for attested late objects. Bytes: no recorded byte can change. Pre-fix the invalid value never reached the ledger (paidDrafts → paidDigest → PaidSubmission.check fails first, hence ErrInvalid at paid_live.go:207), `omitempty` already encodes [] and nil identically, and the observation object keeps `\"message_objects\":[]` (paid_capture.go:42 has no omitempty; :110, :142, :320 untouched). Goldens: a record that could not be produced is in no golden; the frozen replay chapters 10-14 and contract/ledger goldens are untouched. The rejected alternative (nil from publishPaidOutputs/UnmarshalJSON) is correctly rejected: it would change observation bytes and still not fix older objects."
    },
    {
      "id": "P2",
      "disposition": "approve",
      "ruling": "Nothing else changes. contract/ledger/doc.go:2343-2344 and :2493/:2595/:2598 already define the valid encoding (`message_objects?` absent, never null, nonempty when present); the fix makes the producer emit exactly that. Refusal (billed or no-charge), unknown, content-error protocol_error, correction, nonempty output and OpenAI paths are unreached by the one condition. paidResultState/paidResultCost (paid_attempt.go:303-400) never read MessageObjects, so replay accounting is unaffected. No F3-13 change, no D entry (D161), no golden."
    },
    {
      "id": "P3",
      "disposition": "amend",
      "ruling": "Rows 1-5 approved through the real boundary in internal/core/agents with the loopback exchange `paidSSE(model, start, final, \"\", \"end_turn\", \"\", true)`, model echoed by paidRequestModel so it matches the fixture profile (the existing zero-text rows at paid_transport_test.go:124 and paid_billing_test.go:218 stay unknown by model mismatch and overflow respectively, so no existing row flips). Amendments: (a) Row 1's 'no message_objects key' is proven by `v.Result.MessageObjects == nil` from the view (DecodeRuntimePaidResult sets the field only when the key is present and re-encodes) plus `!bytes.Contains(receipt.Submission encoded, \"message_objects\")`; a raw commit read is optional, not required. Also assert `v.State == \"settled\"`, `v.HeldMicros == \"0\"`, `v.Result.OutputStarted != nil && !*v.Result.OutputStarted`, and `f.budget(t, \"\")` held/settled totals before and after. (b) The literal amount is the assertion; the providers.PriceHistoricalUsage computation is a cross-check only. Suggested usage start=final `{\"input_tokens\":7,\"output_tokens\":1}` → literal 8 micros [INFERENCE from the fixture tariff's existing rows 7/0→7 and 7/4→11; coder confirms]. Any complete usage with output_tokens present is acceptable. (c) Row 3 uses the existing `reopenScoped(t, f.serviceFixture, DefaultLimits())` pattern (paid_openai_test.go:282). (d) Row 4: dispatch an incomplete exchange (`complete=false`, eof → unknown at version 2 via paidRecord), then `paidLateEvidence` setting Complete=true, Error=nil, ErrorClass=\"\", StopReason=\"end_turn\", ContentBlocks=0, OutputStarted=false, complete RawUsageFinal/RawUsageMerged, MessageObjects left as decoded ([]); RecordPaidObservation at ExpectedVersion 3 with TrustedEvidence settles with nil output and releases the hold; duplicate same-ID returns the same receipt. (e) Rule breaks: (a) and (b) only. Break (c) is ruled out: there is no separate late, duplicate or replay code path that constructs the list (see P1), so there is nothing to pin. (f) Row 5 is the plain package run; no `-update` golden pass is required since the frozen replay tests compare committed bytes."
    },
    {
      "id": "P4",
      "disposition": "amend",
      "ruling": "Delete the three limit lines internal/core/agents/doc.go:736-738 and do not leave a replacement in the limits section (it is no longer a limit). Put the one behaviour sentence in the capture paragraph after 'Anthropic incomplete/refusal captures select none;' (doc.go:705-707): a billable, non-refusal Anthropic terminal with no output block settles on its usage with no message objects, and the result omits message_objects. Leave paid_mixed_test.go:276-288 unchanged, comment included: the fixture proves nonempty late output with correction across both providers, and its comment remains literally true (an empty non-nil list is not a valid encoding); row 4 proves the zero-block case."
    },
    {
      "id": "P5",
      "disposition": "approve",
      "ruling": "One slice S1 in internal/core/agents: paid_settlement.go (one condition), doc.go (P4 edit) and a new paid_zero_blocks_test.go with `TestAnthropicZeroBlockSettlement` (t.Parallel like siblings; subtests live→duplicate→reopen on one fixture, and late on a second). Focused tests, one plain verbose package run, gofmt, host vet and staticcheck. No race: no locking, goroutine, channel or shared-state change. Fuzz: none. FuzzPaidGroupReplay fuzzes a dispatch-intent group (modes 0-5 mutate the intent payload, receipt payload, type version and context ID) through decodeFamily and planPaid; derivePaidResult is reached only from recordPaidEvidence and publishPaidObservation, which no fuzz target in agents, providers or contract/ledger calls, so D152's 120 s campaign does not apply. Seeds run inside the package run anyway."
    }
  ],
  "amendments": [
    "P3(a): key absence proven by decoded nil plus receipt submission bytes; raw commit read optional.",
    "P3(b): literal amount is the assertion; PriceHistoricalUsage is a cross-check.",
    "P3(c): reopen via reopenScoped.",
    "P3(d): late row shape fixed as above (incomplete live exchange, then attested complete zero-block object at version 3).",
    "P3(e): breaks (a) and (b) only; (c) ruled out.",
    "P4: remove the limit lines; one behaviour sentence in the capture paragraph, not the limits section; paid_mixed_test.go untouched.",
    "Citation: the Anthropic branch is paid_settlement.go:162-164 at aa81bb2, not 160-164.",
    "Procedure (PM, non-blocking): D152 item 5 routes money tickets through reader-assisted design; this brief came without designer or reader. Every citation in it checked true against the code, so the ruling stands on it; record the shortened route in the ticket notes as a D152 item 4 redundancy decision."
  ],
  "slicePlan": {
    "ownedPaths": [
      "internal/core/agents/paid_settlement.go",
      "internal/core/agents/doc.go",
      "internal/core/agents/paid_zero_blocks_test.go"
    ],
    "commands": [
      "go test ./internal/core/agents -run 'TestAnthropicZeroBlockSettlement' -count=1 -v",
      "go test ./internal/core/agents -run 'TestAnthropicStreamAndUsage|TestAnthropicRefusalBilling|TestPaidSettlementAndCorrection|TestOpenAIPaidEvidenceStates|TestPaidMixedProviderScopes|TestPaidGroupRulesAndFrozenReplay' -count=1",
      "go test ./internal/core/agents -count=1 -v  (one plain verbose package run; thirty-minute limit per D127)",
      "gofmt -l ./internal/core/agents",
      "go vet ./internal/core/agents",
      "staticcheck ./internal/core/agents",
      "SHA-256 of paid_settlement.go before each break and after restore; equal hashes recorded in the slice evidence"
    ],
    "breaks": [
      "(a) money: restore `} else if o.StopReason != \"refusal\" {` (unconditional slices.Clone) → TestAnthropicZeroBlockSettlement red (RecordPaidObservation ErrInvalid, attempt held at full bound); byte-identical restore → green.",
      "(b) data loss: set `v.MessageObjects = nil` unconditionally in the Anthropic branch → TestAnthropicStreamAndUsage/complete-artifacts (expects 1 object, paid_exchange_test.go:396) and canonical-blocks-and-cache rows (paid_blocks_test.go:87, :120) red; byte-identical restore → green."
    ],
    "fuzz": "none — no fuzz target reaches derivePaidResult; FuzzPaidGroupReplay covers decodeFamily/planPaid of the dispatch-intent group only. Seeds run in the package run."
  },
  "ownerGates": [],
  "notesForCoder": [
    "The one code change is the condition at paid_settlement.go:162; do not touch paid_capture.go (observation bytes stay `\"message_objects\":[]`), contract/ledger, or the OpenAI branch.",
    "Use paidServer + newLivePaidFixture + paidRun + paidRecord (paid_exchange_test.go:123-147) for the live row; paidLateEvidence (paid_billing_test.go:94) for the late row; reopenScoped for replay; f.budget(t, \"\") for book totals; f.store.Durable() for 'sequence did not move'.",
    "Row 2 duplicate: same CommandID and same Observed/TrustedEvidence; expect the same receipt Sequence, unchanged Durable and unchanged book — the paid_mixed_test.go:296-301 shape.",
    "Assert the literal cost first; a PriceHistoricalUsage cross-check may accompany it but must not replace it.",
    "No test may assert source text or wiring; each row above fails on the restored defect or on a replay/duplicate divergence.",
    "doc.go: delete lines 736-738; add the one sentence in the capture paragraph (around 705-707). Nothing in docs/ or CONTRACTS changes; the PM writes the close notes."
  ],
  "checked": [
    "local://t141-ruling-request.md and local://t141-brief.md whole; local://t14-s2-review.md (notes[0] and notesForNextSlice doc item); .scratch/dwarf-harness/issues/141-...md whole; docs/CURRENT-RULES.md whole (main checkout aa81bb2).",
    "contract/ledger/paid.go:242-363 (RuntimePaidResult, validPaidMessages, check, Encode, Decode); paid_submission.go:70-203 (PaidObserve/PaidCorrectArguments, paidObservation, check, readPaidMessageObjects); doc.go:2343-2344, 2393-2394, 2492-2495, 2594-2598; scoped_values.go:475 readScopedObjects.",
    "internal/core/agents/paid_settlement.go whole (derivePaidResult 69-166, deriveOpenAIResult 170-231, recordPaidEvidence 264-400, paidObservationSubmission 402-408, matchPaidObservation 410-425); paid_capture.go 28-374 (object type, UnmarshalJSON, paidObservation, paidCaptureAllowed, publishPaidObservation, publishPaidOutputs); paid_attempt.go 150-416 (planPaidAttempt, paidResultState, paidResultCost, paidUsageViolation); paid_live.go 142-233 (lookupPaid, paidDigest, matchPaid, paidDrafts); replay.go 473-503 (commandMatch, findCommand); scoped_replay.go:241 sameScopedValue; paid_read.go:36; doc.go 699-763.",
    "Tests: paid_exchange_test.go 20-70, 123-160, 335-413; paid_billing_test.go 20-133, 205-228; paid_mixed_test.go 229-233, 255-333; paid_lifecycle_test.go 195-245; paid_transport_test.go 105-175; paid_blocks_test.go 16-50 and MessageObjects sites; paid_openai_test.go 251-288, 389-396; paid_fuzz_test.go whole; grep of every MessageObjects/derivePaidResult/paidLateEvidence/ErrInvalid/paidSSE zero-text site in the package; fuzz target inventory in agents, providers, contract/ledger.",
    "internal/core/providers/anthropic_stream.go 95-135 (Complete and Blocks on a stopped zero-block stream), :319 (OutputStarted only on text), :385, :478; profile.go:16-18 model constants.",
    "Not done: no commands, no worktree read (same SHA as main), no golden byte recomputation; the tariff arithmetic for the suggested 8-micro literal is inferred from existing rows, not recomputed from the fixture tariff."
  ]
}
```