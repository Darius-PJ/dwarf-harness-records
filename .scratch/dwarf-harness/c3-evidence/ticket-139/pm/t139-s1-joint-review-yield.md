Report supplied inline for PM persistence as `local://t139-s1-joint-review.md`; this read-only reviewer has no write tool.

```markdown
# Ticket139 S1 — fresh joint review

## Verdict
APPROVE completed contract. APPROVE proposed 14-edit D125 freeze record.
No blocking findings or required technical corrections.

Reviewer: openai-codex/gpt-6-astra, temporary stand-in for Claude Fable 5.1.
Subject: 86f952cfcae37bde06767c6c4eaa615a503dd96d
Parent: 82d8d48856c7191019625c9f6e896d10b9b8498c

## Grounds
- Read the amended ruling, cited requirements, all changed code/specification/fixtures, proposed R1–R14 and retained evidence. The commit proof binds all 13 tested files to the subject.
- registration.go and registration_submission.go implement four additive v1 types and exactly three schema-5 CAS operations. They preserve explicit opaque external addresses, kind-scoped identities, canonical digest binding, ordered sets, checked versions, recursive duplicate rejection and complete input/output caps. Stateful authorization, history and replay obligations are specified without claiming codec enforcement.
- registration_test.go and registration_fuzz_test.go exercise observable malformed-input, canonicalization, identity, ordering and size-boundary failures. Authorized catalogue-test changes remove obsolete implementation pins without replacing them with a 53-entry pin.
- The generator and actual four fixtures provide 19 commits/65 records: 23 prerequisite records followed by 14 complete registration/declaration groups. They cover both source and consumer kinds, revisions, repins, mixed consumers and withdrawals. The earlier root grant uses the explicit external address before registration.
- Retained generation and comparison evidence reports all 42 earlier fixtures unchanged, including the D149-corrected F3-13 golden. Final package and ledgerstore runs passed; formatting, vet, staticcheck and dependency evidence support the bounded S1 change. The immutable-subject fuzz run passed with 1,449,126 executions.
- The retained actual-Core positive probe reconstructed the earlier task/grant with zero issues, durable 65→65 and unchanged ledger bytes. The separately rebuilt semantic negative control passed ledgerstore opening but Core rejected the missing task dependency at sequence 17 without modifying the log. Exact helper restoration and probe removal precede final hashes.
- Proposed R1–R14 accurately separate public contract facts from private decision/evidence records. Public replacements introduce no private paths or owner quotations. Five Go status-comment replacements across four files change no implementation.

## Limits and remaining gates
No commands were run and no files were edited during this review. Hash, execution and mirror results are retained observed evidence, not independently recomputed results.

The prerequisite probe does not validate the future registration reducer. This review does not approve Ticket140, producer implementation, crash recovery, graph projection, D52 readiness or whole-ticket closure.

Primary still assigns the decision number/date, inserts this actual review and applies the records. The final public freeze-record SHA—including Go comment edits—must receive its own successful full three-OS/race matrix and aggregate Check result before integration. No duplicate local full gate is requested.

No owner gate is triggered by this additive, dependency-free D125 freeze. Existing owner-reserved gates remain unchanged. Fable's whole-ticket double-check after reset remains pending.

No confirmation review is required for the reviewed record edits, number/date/verdict insertion or recording successful hosted results. A subsequent technical change requires appropriately scoped review.

## Approval quote
“GPT-6 Astra, acting as a temporary stand-in for Claude Fable 5.1, approves Ticket139 S1 at 86f952cfcae37bde06767c6c4eaa615a503dd96d, parent 82d8d48856c7191019625c9f6e896d10b9b8498c, jointly with its completed F3-139 specification, generated fixtures, observed evidence and proposed 14-edit D125 freeze record. No blocking findings remain. This is technical approval for PM freeze recording, not a claim that the freeze has landed or D153 integration gates have passed. Fable remains the main advisor; its whole-ticket double-check after reset is pending.”
```

{
  "verdict": "approve",
  "subject": "86f952cfcae37bde06767c6c4eaa615a503dd96d",
  "base": "82d8d48856c7191019625c9f6e896d10b9b8498c",
  "modelIdentity": {
    "model": "openai-codex/gpt-6-astra",
    "basis": "Injected runtime identity",
    "role": "Temporary stand-in advisor/reviewer",
    "mainAdvisor": "Claude Fable 5.1",
    "fableWholeTicketDoubleCheck": "pending"
  },
  "completedContractApproval": {
    "verdict": "approve",
    "scope": "Completed Ticket139 S1 codecs, catalogue, specification, tests, generated fixtures and observed evidence at the exact subject",
    "blockingFindings": 0
  },
  "freezeRecordApproval": {
    "verdict": "approve",
    "scope": "R1–R14 in t139-s1-freeze-filled-edits.md",
    "technicalCorrectionsRequired": [],
    "applied": false,
    "integrationApproved": false
  },
  "findings": [],
  "evidence": [
    {
      "source": "t139-s1-commit-proof.json",
      "result": "All 13 tested-file hashes match committed blobs; exact parent and changed-path inventory supplied."
    },
    {
      "source": "03-generate.log; 05-goldens.log; 06-old_proof.log; fixture and authoritative-golden proofs",
      "result": "Generated 19 commits/65 records; four new fixtures; 42 earlier fixtures unchanged; 13 earlier log digests match recorded freezes, including D149."
    },
    {
      "source": "04-focused.log; 12-package.log; 13-consumer.log",
      "result": "Focused tests and seeds passed; final contract package passed in 9.325s Go time; ledgerstore consumer passed in 33.500s."
    },
    {
      "source": "08-probe.log; retained probe source; 09-restoration.log; 23-hashes.log",
      "result": "Actual-Core prerequisite positive and semantic negative controls passed; ledger remained unchanged; temporary helper restored byte-identically and probe removed."
    },
    {
      "source": "pm-FuzzDecodeF3_139.log; t139-s1-fuzz-result.json",
      "result": "120-second campaign passed: 1,449,126 executions, 21 new interesting inputs, 113 total; 122.741s Go time; source hashes unchanged."
    },
    {
      "source": "14–16 and 18–22 retained logs",
      "result": "Formatting, vet, staticcheck, import/dependency and module checks support the stated standard-library-only, dependency-unchanged slice."
    },
    {
      "source": "t139-s1-freeze-mirror-proof.json",
      "result": "All 14 proposed anchors apply in memory; five Go replacements across four files are comment-only; document mirror reports no issues."
    }
  ],
  "evidenceLimitations": [
    "Read-only review: no commands, measurements, provider calls or edits were performed.",
    "Commit/hash and execution bindings rely on the supplied retained proof; they were not independently recomputed.",
    "Actual-Core probe proves earlier-family prerequisites, not the future F3-139 producer/reducer.",
    "The final public freeze-record SHA and its hosted results do not yet exist.",
    "The parent is the coordinated Ticket140 candidate; this review grants no Ticket140 approval.",
    "Whole-ticket implementation, recovery and Fable verification are outside this completed S1 review."
  ],
  "ownerGate": {
    "triggered": false,
    "reason": "Nonbreaking additive completed contract; no new dependency or owner-reserved decision is introduced.",
    "preserved": [
      "Owner approval for breaking frozen-contract changes",
      "Existing D52 restrictions",
      "Other owner-reserved approvals"
    ]
  },
  "confirmationPassNeeded": false,
  "confirmationPassReason": "The completed contract and proposed record were jointly reviewed. Reviewed comment/status edits, coordinated number/date insertion, actual verdict insertion and subsequent hosted-result recording require no repeat review. A technical change requires scoped review.",
  "recordChanges": [],
  "recordCompletion": [
    "Primary assigns the coordinated decision number and actual freeze date.",
    "Insert the actual joint approval into the private decision and evidence records.",
    "Apply public/private records through primary-controlled integration.",
    "Record successful full three-OS/race matrix and aggregate Check result for the exact final public freeze-record SHA before main advances.",
    "Retain this review in the whole-ticket packet for Fable's pending double-check."
  ],
  "reviewLine": "GPT-6 Astra, acting as a temporary stand-in for Claude Fable 5.1, approves Ticket139 S1 at 86f952cfcae37bde06767c6c4eaa615a503dd96d, parent 82d8d48856c7191019625c9f6e896d10b9b8498c, jointly with its completed F3-139 specification, generated fixtures, observed evidence and proposed 14-edit D125 freeze record. No blocking findings remain. This is technical approval for PM freeze recording, not a claim that the freeze has landed or D153 integration gates have passed. Fable remains the main advisor; its whole-ticket double-check after reset is pending.",
  "requests": [],
  "report": {
    "intendedPath": "local://t139-s1-joint-review.md",
    "created": false,
    "delivery": "Complete Markdown report supplied inline for PM persistence; reviewer has no write tool."
  }
}