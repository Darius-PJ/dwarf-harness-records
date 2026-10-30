# Ticket 89 evidence

The [brief](ticket-89-design-brief.md) is retained verbatim; the [ruling](ticket-89-design-ruling.md) governs its amended slice plan and withdraws its proposed build record. Ticket 89's Answer and `internal/core/agents/doc.go:134-172` state the delivered query; no contract/register change, freeze or decision entry is required. Sources: `local://t89-ruling.md:9,43-46`; `local://t89-s3-review.md:8,19`; `docs/CURRENT-RULES.md:26-30`.

## Method and provenance

Chronology comes from `local://t89-docs-notes.md:3-7`, the three coder reports and the fresh reviews cited below; this document adds no execution claim. The [inventory](ticket-89-evidence-inventory.json) is copied from `local://t89-evidence-inventory.json` (SHA-256 `587e8c7cac778d0352eb0fbbaa4f4ae3874b830b46775a0f3a8b2100fb01cc62`); its raw files remain outside both repositories. Reported timing fields below are not a comparative performance measurement or a substitute for package-log timings. No fuzz or measurement campaign was required (ruling P7, `local://t89-ruling.md:39,43`).

## Order on main and people

DesignT89 (GPT-6.1 Sol; 21 min) wrote the brief, and RuleT89 (fresh Fable; 11 min) approved with four amendments and no owner gate. S1's authorization/pagination proofs accompanied its implementation; S2 and S3 followed the amended plan. Sources: `local://t89-docs-notes.md:4-5`; `local://t89-ruling.md:43-46,82`.

| Slice | Commit / coder | Review | Exact-SHA hosted check / merge |
|---|---|---|---|
| S1 — complete query and four boundary regressions | e492213; CoderT89S1, GPT-6 Astra; 24 min | ReviewT89S1, fresh Fable: approve, nits only | Check 17, run 41074489129: success; `main` a678705..e492213 |
| S2 — ordered transitions and review results | 85b8d56; CoderT89S2, GPT-6 Astra; 13 min | ReviewT89S2, fresh Fable: approve, nits only | check 19 (run 41081799823) succeeded on 85b8d56; `main` e492213..85b8d56 |
| S3 — query race, documentation, smoke and authorized S2-test corrections | 749b218; CoderT89S3, GPT-6 Astra | ReviewT89S3: approve, no blocking findings | check 20 (run 41090448256) succeeded on 749b218; `main` 85b8d56..749b218 |

Sources: `local://t89-docs-notes.md:6-7`; `local://t89-s1-review.md:3-10`; `local://t89-s2-review.md:3-11`; `local://t89-s3-review.md:3-20`; `local://t89-close-drafter-assignment.md:24`.

## Runs and rule breaks

Each slice passed focused tests, one plain verbose agents run, formatting, host vet and staticcheck. S1 and S3 also passed whole-package race and twentyfold affected-row race; S2 correctly added no local race run because it changed tests without locking/shared-state changes. The raw references below identify the retained evidence; the command manifests record exact commands and exits. Sources: `local://t89-s1-report.md:45-139`; `local://t89-s2-report.md:9-78`; `local://t89-s2-review.md:11`; `local://t89-s3-report.md:27-92`; `local://t89-s3-review.md:12`.

| Slice | Focused consumer proof | Reported plain / race / ×20 seconds |
|---|---|---|
| S1 | `TestTaskFactsBucketsAndAssignments`, `TestTaskFactsCommittedReadiness`, `TestTaskFactsAuthorization`, `TestTaskFactsPagination`, existing `TestScopedTaskTransitionsAndProjection` | 64.956 / 297.163 / 29.757; ×20 is `TestTaskFactsCommittedReadiness` |
| S2 | `TestTaskFactsTransitionRecovery`, `TestTaskFactsReviewTransitions` | 80.741 / not required / not required |
| S3 | `TestTaskFactsQueryRace`, corrected `TestTaskFactsTransitionRecovery`; exported-API smoke | 91.866 / 303.782 / 16.188; ×20 is `TestTaskFactsQueryRace` |

Sources: `local://t89-s1-report.md:121-139,171-174`; `local://t89-s2-report.md:60-67,84-85`; `local://t89-s3-report.md:63-82,98-111`. The race test's whole-page before/after oracle checks head/row/count consistency; lock-discipline coverage relies on the detector across the package and ×20 runs, not a guaranteed schedule (`local://t89-s3-review.md:6-7,20`).

S1's three one-at-a-time breaks all failed `TestTaskFactsAuthorization` and restored green: A omitted the selected-grant task filter, B omitted audience membership, C counted before both filters. The review confirmed the inflated counts and paired the baseline source digest `7ba8109c5c0052d681cfd910207a32b97a6e5101210ae12a496d4d34b7aa2837` with the report's final `task_facts.go` digest; the hash-check command itself is absent from the command manifest, so restoration is evidenced by that pairing, not a claimed separately logged command. Sources: `local://t89-s1-report.md:148-169,218`; `local://t89-s1-review.md:10`; raw A–C logs and baseline/summary references below.

S1 retained two failed development-focused runs before correcting fixture setup and passing the final sequence; they are not gate passes (`local://t89-s1-report.md:35-53,228`). S3's PM follow-up arrived during the initial V1 sequence; `pre-handoff` logs are superseded, and its complete final sequence followed the last edit (`local://t89-s3-report.md:151-160`; `local://t89-s3-review.md:12`). Neither is an unreported successful-final-run substitution.

## PM answers and carried review notes

No owner-reserved question arose. The PM authorized S3 to remove S2's dead assignment, add the lowered-reopen old-ceiling `ErrTooLarge` assertions through both entrances, and reuse S2's helpers; the S3 review confirmed both corrections. Sources: `local://t89-docs-notes.md:5,7`; `local://t89-s3-report.md:151-154`; `local://t89-s3-review.md:10`.

The PM carried S1's nonblocking notes rather than widening the slice: readiness is evaluated twice per returned row under one lock with identical committed inputs; the helper's unused `GrantSpec` return and assembling the Next coordinate before cursor validation are harmless. Also carried without a close fix: the single-goroutine recovery fixture's unlocked authority read, redundant refusal paging, redundant `Cursor.Actor`/`Page.AgentID`, and `doc.go:168-170` wording that understates authorization/readiness work for active candidates (the O(T·Limit) bound is unaffected). Sources: `local://t89-close-drafter-assignment.md:17,20`; `local://t89-s1-review.md:6-9`; `local://t89-s2-review.md:7,10`; `local://t89-s3-review.md:9,17`.

The durable-hold-on-restart observation remains a coverage limit: no task-facts reopen branch carries a durable turn admission. S1's queued-by-durable-turn case and existing admission-recovery tests carry that semantics; the task-facts reopen proofs cover readiness/reasons, identities, versions, sequences, counts and same-head cursors, not a new durable-admission recovery scenario. Sources: `local://t89-s2-review.md:9`; `local://t89-s3-review.md:18`.

## Consumer boundary and smoke

The public contract statement is `internal/core/agents/doc.go:134-172`, not a duplicated decision record: one target agent; actual assigned waiting/active tasks; authorization before disclosure/counts; committed-only readiness; combined bounded pages and complete counts; same-head continuation or nil-cursor recovery. Cost remains a full retained-task scan per page with O(T·Limit) ID moves, O(Limit) candidate/output storage and existing potentially cold lookups; any later commit can stale an enumeration, and count-only consumers call once per agent at Limit 1. No scheduler, title synthesis, GUI, new index/cache or numerical performance claim is included. Sources: `local://t89-ruling.md:9,14,19,24,29,34,45`; `local://t89-brief.md:120`; `local://t89-s3-review.md:8-9,19`.

The retained S3 `smoke-main.go` and `smoke.log` reproduce the exported ledgerstore/agents path in a fresh colony: ready/blocked Limit-1 pages with complete counts, a typed start making the old cursor stale, fresh active/blocked facts, then close/reopen preserving facts and accepting the same-head cursor. The temporary package was removed before 749b218; the source/output remain only at the hashed evidence paths below. Sources: `local://t89-s3-report.md:98-107`; `local://t89-s3-review.md:11,19`. These are typed-query and recovery observations, not GUI, provider, population-capacity, OS-isolation or power-loss evidence (`local://t89-brief.md:221`).

## CI and close

Final close review: approved by a fresh Fable advisor, with notes only. S2/S3 hosted outcomes and merges are recorded in the slice table; code integration requires the reviewed exact-SHA result, not just local runs. The public ticket/paired roadmap edits and private records land separately under D145; the contract register and decision log are unchanged. C3 status and its final three-system exit gate remain only in the paired roadmap Status line and board. Sources: `docs/CURRENT-RULES.md:8,18-19,26-30`; `local://t89-ruling.md:46`.

## Raw evidence references

Paths beginning S1, S2 or S3 expand these exact retained roots: S1 = `C:/Users/darius.jones/worktrees/dwarf-harness/t89-s1-evidence`; S2 = `C:/Users/darius.jones/worktrees/dwarf-harness/t89-s2-evidence`; S3 = `C:/Users/darius.jones/worktrees/dwarf-harness/t89-s3-evidence`. Each row is a path and SHA-256 from the inventory; it copies no log, receipt, profile or program text.

| Path | SHA-256 |
|---|---|
| S1/commands.jsonl | `65b7e2b9f71392b23651ea1c58770f723f59310c1c3f249fa9d6678be588b2ad` |
| S1/focused.log | `3e3d423afa03b07443ca2f87434f81075944821e4e75ba6254b32464660916cc` |
| S1/v1.log | `1067980d438ca4cbc4f937a7b1afc18d72fa2aae910b436aa9a2983340a5d55b` |
| S1/race.log | `96ee1dd8b06cea03b3cd87467ffc47b91981be85cdfb0ff91fab53f727ac5246` |
| S1/race20.log | `388443e48cf6711ce8f7b757b0201e4c7043b59445c95fdb01534c72cb7b61c0` |
| S1/break-A-red.log | `acad22f6df0cbdcc14e33b93aac2476de94a54612bb3e6767adddb2e512b25ba` |
| S1/break-A-green.log | `eae4306f2604da7139cabc79e396a1fa32ad65131526e0a90cccb2b9e177fd48` |
| S1/break-B-red.log | `ddb6aa1a3977ab50a1f5af578a31d7d500b36e422550b60b80d009a0269c7fb4` |
| S1/break-B-green.log | `e8546f1fc3715c0cf9ef1c8ad383035562c11456e5d82c6dd753d79eb6c6c650` |
| S1/break-C-red.log | `9707930aeeb8f7475e8d31a7e3d864e0c7272bf270331fc67f5d938cc8472606` |
| S1/break-C-green.log | `e8c1e48b12a9df2765e31b82bd8784a118465dd41882062e45d09fe9c979f8a3` |
| S1/task-facts-baseline.sha256 | `56328355525a9b8e759172acbdf5883a6cabb4ea5f9a31859185cf702db7a7db` |
| S1/summary.json | `904dd2eed2e54b9c34746680f831221e4d21ac8d6a44d3ade4479c473678b76f` |
| S2/commands.jsonl | `2cc033e6eac59c9172add6084471f3b7426dd5c8c4e0294d9e883c4e14c2f302` |
| S2/focused.log | `e41b53172727a5c59f8f57c8f96c3f369067d7e9c7c07e9d16918eae54f0d0ec` |
| S2/v1.log | `3f556505f66a53ccbe7c7673b199528edf0e211d75bab764d6b600d60ca97e49` |
| S3/commands.jsonl | `c147987b2bf767b334e2f50b8a2d02c17392ecaf616fd092c26beff4454daf66` |
| S3/focused.log | `2284716c1307be2c59074c33cecb3ab34c81d60d0ec063f7ace01e22ef900919` |
| S3/v1.log | `c8c6cdb79787fd234700a722cda13d579a154adfd11d66c76c85f08843ba697b` |
| S3/race.log | `da442a663c79baed771adafeb82c3108022303a83c8e89de4554eb93505bc18f` |
| S3/race20.log | `c2bb106fb9a92fb5b845b859cc439ac1a484472435b5423ad884f4d6fb3bb8d6` |
| S3/smoke-main.go | `3d7aa10acd081f0236610a13bc0c45d6162d6c7315d3ef17b39d29e7f678f1aa` |
| S3/smoke.log | `2f0011eb68d71112dccf076fa1c8395bd6cd045bc7755d742c61436f2e30f1f1` |
