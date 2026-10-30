# Ticket 141 evidence

The [PM brief](ticket-141-design-brief.md) is retained verbatim; the [fresh ruling](ticket-141-design-ruling.md) governs its amendments. Ticket 141's Answer and `internal/core/agents/doc.go` describe the one-condition Anthropic producer fix: nil output settles on complete usage while capture bytes, prior recorded bytes, validation and goldens remain unchanged. No contract-register change or decision entry is required. Sources: `local://t141-ruling.md:8,13,23,64`; `local://t141-s1-report.md:2-13`; `docs/CURRENT-RULES.md:26-30`.

## Slice and integration

| Slice / coder | Commit / base | Fresh review | Exact-SHA hosted check / merge |
|---|---|---|---|
| S1 — derivation guard, package documentation and zero-block regression; CoderT141S1, GPT-6 Astra, 10.5 min | f4f0e1f416fc9c22c28df6c31ef77589233f292d / aa81bb27575da417b91bddc65627adcab5c8db9a; pushed 2026-10-30 16:17:45 EDT | ReviewT141S1: approved with no blocking findings and two nits needing no change | check 27 (run 41122034203) succeeded on f4f0e1f on Windows, Linux and macOS; `main` aa81bb2..f4f0e1f |

Sources: `local://t141-docs-notes.md:3-6`; `local://t141-close-drafter-assignment.md:24`. Carried review notes: two nits needing no change: the ruling's late-row wording names version 2 where the recorded unknown result is version 3, as the test asserts; the hash records capture the baseline and restored states, not the broken intermediate bytes. Consumer limits carried to the ticket Answer: none identified.

## Proof runs and rule breaks

All final focused tests, the plain verbose agents package run, gofmt, host vet/staticcheck and tidy diff passed; the report lists no deviation. `TestAnthropicZeroBlockSettlement` covers live → duplicate → reopen and incomplete-live → complete-late → duplicate. Its literal 8-micro assertion (7 input / 1 output) is independent of the tariff cross-check; it also checks nil/omitted output, false OutputStarted, released hold, exact book totals and no duplicate append. Existing nonempty-output, refusal/no-charge, correction, OpenAI, mixed-provider and frozen-replay rows pass unchanged. Sources: `local://t141-s1-report.md:16-115,145-167`; `local://t141-docs-notes.md:6`; ruling P3 (`local://t141-ruling.md:18`).

Recorded command wall times: focused zero-block 4.841 s; focused existing rows 32.028 s; plain package 154.091 s (package output 151.467 s); break (a) red/green 7.217/2.392 s; break (b) red/green 7.717/2.717 s. These are run durations, not a comparative measurement. Sources: `C:/Users/darius.jones/worktrees/dwarf-harness/t141-s1-evidence/commands.jsonl:5-7,10-13`; `local://t141-s1-report.md:48-50,145-146`; raw hashes below.

Break (a) restored unconditional cloning: live and late `TestAnthropicZeroBlockSettlement` recording failed; restored code passed. Break (b) discarded all Anthropic message objects: `TestAnthropicStreamAndUsage/(complete-artifacts|canonical-blocks-and-cache)` detected lost real output; restored code passed. Baseline, both restoration records and final hashes agree on `paid_settlement.go` SHA-256 `8971edf98c59bb4628919734a0092107813ebe1937c6f3ec7c0b9e192ca12cf0`. Sources: `local://t141-s1-report.md:116-130,178-181`; raw break/hash references below.

No local race run was required because no locking, goroutine, channel or shared-state behavior changed. No fuzz campaign was required: no fuzz target reaches `derivePaidResult`; dispatch-intent replay fuzz seeds still run with the package. No measurement was requested or performed. Sources: ruling P5 (`local://t141-ruling.md:28,60`); `local://t141-s1-report.md:164`; `local://t141-close-drafter-assignment.md:20`; `docs/CURRENT-RULES.md:15-17`.

## PM procedure and close

The PM chose one slice and a short PM brief plus a fresh Fable ruling instead of a designer and reader: ticket 14's review and ticket 141 already identified the defect's site and bounded scope. RuleT141 (fresh Fable; 8 min) approved with amendments and checked the brief's citations, while noting that D152 item 5 normally requires reader-assisted design for money tickets. The PM recorded the shortened route as a redundancy removal under D121/D152 item 4, to be reported in the next status; no standing rule or owner gate changed. The ruling retained only breaks (a)/(b), moved the resolved limitation into the capture behavior paragraph, and left the mixed-provider fixture unchanged. Sources: `local://t141-docs-notes.md:3-4`; `local://t141-ruling.md:18,23,28,39,62`.

Final close review: approved by a fresh Fable advisor with no blocking findings and no corrections. Integration is gated on fresh approval and the passing exact-SHA hosted result, not local runs alone. Public ticket/paired-roadmap edits and private design/evidence records land separately (D145); C3 status remains only in its paired roadmap Status line and board, and the contract register and decision log are unchanged. Sources: `docs/CURRENT-RULES.md:8,18-19,26-31`; ruling P2 (`local://t141-ruling.md:13`).

## Raw evidence references

The [inventory](ticket-141-evidence-inventory.json) is copied verbatim from `local://t141-evidence-inventory.json` (SHA-256 `2314f2abc9d4387fbdd9041b7cbdece99bd5a0d2bcb82bcb6262c212e3be58c1`); raw files remain outside both repositories. Below, S1 expands exactly to `C:/Users/darius.jones/worktrees/dwarf-harness/t141-s1-evidence`. Each path/hash comes from `local://t141-evidence-inventory.json:6-69,101-109`; no raw log, receipt or profile is copied here.

| Path | SHA-256 |
|---|---|
| S1/commands.jsonl | `33538ecfb10c991f87246cbb469f1a95fedc406e03fd8ea626fdfaf5bc0db7ab` |
| S1/focused-zero.log | `627e6f2b714476769d5e764bc3d0b12f79714547dd6038f2cba01978ca73e7f0` |
| S1/focused-existing.log | `e400fa1f206cbd11eaa31cb9ad8a287bb1fecae5812c181b1504f9ea2e92c823` |
| S1/v1.log | `2cf4fea6d85e7bd91be6331866666cd4593a4cd218094241d450b87ca28e438a` |
| S1/break-a-red.log | `dcb44d4eb96526e1dcd336bbcc987e524201b471d4b58d6d35aaa772f4cb9888` |
| S1/break-a-green.log | `92e8c5e6e54a20f9140c43e871649d951507960756013f36d895db4fe5eebffa` |
| S1/break-b-red.log | `b88048dbbf8f87e630e9bd42bc19c9100caac97798742955f09c88a6aee58641` |
| S1/break-b-green.log | `a5f86ff8752b39b3978289d6cc312ef4534eb5d5194825fa69744a95dca8df64` |
| S1/baseline-hashes.json; S1/break-a-restored-hashes.json; S1/break-b-before-hashes.json; S1/break-b-restored-hashes.json; S1/final-hashes.json | `41a6682fcb115cf54a5780148dce952047a19b23e6b7cdbd7834ffdcdf8bed23` |
