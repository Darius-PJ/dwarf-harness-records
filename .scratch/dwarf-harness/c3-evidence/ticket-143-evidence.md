# Ticket 143 evidence

The [designer brief](ticket-143-design-brief.md) is retained verbatim; the [fresh ruling](ticket-143-design-ruling.md) governs its amendments. Ticket 143's Answer and `internal/core/agents/doc.go` describe what S1 built: version-0 accounts keep exact holds and fences but no settled total, corrections adjust configured accounts only, and owner status for a version-0 scope always reads `unconfigured-scope budget status (needPaidTotal)`. Every compatibility row of the ruling is class none, so no contract-register change or decision entry is required. Sources: `local://t143-ruling.md:3,6-23,26-52,106`; `local://t143-s1-report.json:2-19`; `docs/CURRENT-RULES.md:26-29`.

## Design and ruling

DesignT143's brief (SHA-256 `f9a3374d3833c94be3604214b7fe7e19878f869be8c0472a7333e751c7bcdd97`) chose P1 (no settled aggregate for version-0 accounts; refunds only for configured ones), P2 (version-0 owner status always cold), P3 (eight rows in one new test file) and P4 (one slice), with no owner gate. RulingT143, a fresh Fable advisor, approved with 13 amendments and no owner gate (SHA-256 `7fcffb9dbdd26a12e637e3e85e744abba1219fa0e152086091547789dfe8291a`): P1 and P4 approved; P2 amended and holding the brief's second symptom, a partial total while a hold or fence keeps a version-0 account present, within criterion 2; P3 amended. Amendments 1–3 fix the production diff exactly, amendment 4 defines M1 as criterion 5's proof, amendments 5–9 fix the rows, oracles and fixture, and amendment 12 gives the PM three fuzz campaigns. Sources: `local://t143-docs-notes.md:6,8`; `local://t143-ruling.md:6-23,54-66,106`.

Under the owner's workflow test (blind ruling trial 3), the PM also wrote a blind ruling before the advisor produced any output; it and its comparison are kept outside both repositories, and Fable's ruling was the one in force. Sources: `local://t143-docs-notes.md:7,9`.

## Slice and integration

| Slice / coder | Commit / base | Fresh review | Exact-SHA hosted check / merge |
|---|---|---|---|
| S1 — version-0 branch in `planPaidMoney`, one predicate term in `paidBudgetStatus`, `doc.go`'s paid cost paragraph and the eight rows of new `paid_unconfigured_test.go`; CoderT143S1, GPT-6 Astra | 0e58a9b803e30b93c527965beb2254b7f928eb28 / c89447f77a6cdbac52be45f7150393eae6b50b94; 4 files, 447 insertions, 9 deletions; pushed 2026-11-07 15:25:41 EST | ReviewT143S1 (fresh Fable): approved with no blocking findings; one minor point and two nits needed no change | check 48 (run 42411023994) on 0e58a9b succeeded on Windows, Linux and macOS, the Windows race step included; `main` c89447f → 0e58a9b on 2026-11-07 at 16:08:48 EST |

The review confirmed that the production diff is exactly amendments 1–3 with the hold, fence and negative-component refusal lines byte-identical; that nothing reads a version-0 settled value as authority, the first-configuration 148/149 boundary showing the fold, not the zeroed cache, feeds the first cap; that `correction-race` proves the new cold case leaves `Service.mu` and returns the post-correction prefix; and that each break's red sits at the right assertion. Its minor point: `!exists ||` at `paid_query.go:278` is now subsumed by `account.version == 0`, left because the ruling fixed the line. Its nits: the stale-predecessor step in `live-after-install` does not pin the refusal's identity, which `TestPaidSettlementAndCorrection/stale-predecessor` pins; the Terms-absence check is conditional on version 0, whose precondition `unconfigured()` asserts separately. Sources: `local://t143-docs-notes.md:18-19`; `local://t143-s1-review.md:3-15,18-24` (SHA-256 `ac9fafec3f44543076cf5ac4ae6a8a3014c68670373bca9287210249ef62479d`).

## Proof runs and rule breaks

All final runs exited 0. The focused run (the eight rows with `TestPaidGroupRulesAndFrozenReplay`, `TestLoopGroupRulesAndFrozenReplay`, `TestAgentTailColdReadRace` and `TestPaidSettlementAndCorrection`, amendment 11) passed in 16.9 s; the plain package run in 198.254 s (command wall 200.713 s); the package race run in 1,053.406 s (wall 1,079.642 s) with no data race and no race test over 60 s; and the twentyfold race run of `correction-race`, `read-error`, `held-account` and `overrun-fence` (amendment 10) in 248.244 s (wall 251.847 s), twenty passes per row. gofmt, vet, staticcheck and `go mod tidy -diff` passed; production and test imports are unchanged; no test was deleted or renamed. These are run durations, not a measurement. Sources: `local://t143-s1-report.json:20-100,458-461,462-464,527-528,591-593,599`; `local://t143-s1-review.md:10`.

| Break | Change | Red (`paid_unconfigured_test.go`) |
|---|---|---|
| M1 — criterion 5; money and crash recovery | `paid_budget.go`, `paid_query.go`, `doc.go` at their c89447f bytes (SHA-256 `429db17baf9ed4914d141d6163e163f0b68e63623a00449fc9162cc3a4db6c94`, `b034198ceea9f5539d93269dcaf743f3fb7cb2658d386227b6143d1e7224b4c3`, `265c65243d6e9f7d936b2b0c1cfba41b80de6fb3386b3292d331ee5f8a2af6cb`) | `live-after-install` :236 and `reopen-before-correction` :273, the downward correction refused as invalid private storage; `committed-replay` :356, the paid reopen's `inconsistent record at sequence 94: invalid paid transition` |
| M2 — read completeness | `account.version == 0` removed from `paid_query.go:278` | `held-account` :279 (task 0/120, want 120/120); `correction-race` :391, the read did not suspend, failing in 0.75 s without a hang |
| M3 — configured scopes | the version test always takes the zero branch | `live-after-install` :231 (colony 0/0, want 120/0) |
| M4 — live exposure | the version-0 branch also zeroes `a.held` | `held-account` :278, :281, :285 (task residency false, want true) |

Each break ran separately; each restoration's SHA-256 equalled the final hashes, and each restored row passed. The review found the coder's `base-hashes.json` equal to M1's mutant hashes and the retained base snapshots to be the pre-fix source. The PM tied those three base hashes to the base commit: they equal the blobs of c89447f77a6cdbac52be45f7150393eae6b50b94 read with `git cat-file -p` (`internal/core/agents/paid_budget.go` `429db17baf9ed4914d141d6163e163f0b68e63623a00449fc9162cc3a4db6c94`, `paid_query.go` `b034198ceea9f5539d93269dcaf743f3fb7cb2658d386227b6143d1e7224b4c3`, `doc.go` `265c65243d6e9f7d936b2b0c1cfba41b80de6fb3386b3292d331ee5f8a2af6cb`). Final SHA-256: `paid_budget.go` `9473c9bd757871d7db02dc417c0d9b92cf4d06295366ae2960b4c6a8c71f5af0`, `paid_query.go` `19eda40cd66ab776eec9b75d89ccc46922070f74656414a21b5f0463f9f0c070`, `doc.go` `48b39075f3b1a3160927696222a7dd19caf646b3c4d3fb19b393c414ab014371`, `paid_unconfigured_test.go` `dd3acc2bbc13389f2dcb1710d1cfde6bb11ab8be0bf7a9bbc050249ea299ed70`. Sources: `local://t143-s1-report.json:237-457,600-605`; `local://t143-s1-review.md:9`; raw references below.

## PM decisions during S1

Both answers were within the ruling's intent; the coder recorded them as deviations, and the review found them consistent with criterion 2 and amendment 8.

1. **Fresh replay at each row's final phase.** A fresh plain `Open` needs the live service closed, which invalidates the credential bindings later preparations need. Each row therefore asserts literals on every admission scope at every stated phase and compares a fresh plain `Open` at its final phase, with the paid reopen checked wherever a row names one; criterion 2 asks for equality afterwards. `ReconcilePaid` is used unchanged.
2. **M4's real red is residency.** The ruling predicted that zeroing a version-0 hold would make B's release underflow, but the same zeroing also erases the −120 at B's release, so the hold never goes negative and the refusal cannot fire, and owner status reads the held total from the ledger fold, which stays 120. The only observable effect is the task account's absence while B is held, which amendment 8's residency assertion catches.

Sources: `local://t143-docs-notes.md:11-12`; `local://t143-s1-report.json:409-456,595-598`; `local://t143-s1-review.md:14`.

## Fuzz

The PM's three campaigns on 0e58a9b803e30b93c527965beb2254b7f928eb28, each separately, 120 s, `-parallel=1` (amendment 12): all three passed with no crasher, and the worktree was clean afterwards: `FuzzPaidGroupReplay` 13,491 execs, 6 new interesting inputs (346 in the corpus), `ok` 128.1 s; `FuzzLoopGroupReplay` 4,543 execs, 11 new (169), `ok` 127.4 s; `FuzzLoopTranscript` 612 execs, 2 new (118), `ok` 126.4 s. Logs under `C:/Users/darius.jones/worktrees/dwarf-harness/t143-pm-evidence`: `fuzz-FuzzPaidGroupReplay.log` `037fb1968e5d4d53d722de46a9573dd47711d6d0a61ad2fdfdb9fcd3626f37fb`, `fuzz-FuzzLoopGroupReplay.log` `fabdc5c860d6404a2f7ba8ff9bffe27ccf91414fca7bc659ee1473f29bebc371`, `fuzz-FuzzLoopTranscript.log` `5e5c7e6e8983cfec0795af7d1774af989225c81399c0f261eb52445bcb058e01`. No new target was needed: no decoder changed. Source: `local://t143-ruling.md:65`.

## PM procedure and close

The PM claimed the ticket at 14:08 EST on 2026-11-07, right after ticket 142's close, its only blocker. D152 item 5 asks money tickets for reader-assisted design; the PM's design assignment gave the designer no reader because ticket 142's measurement and probes had already found the defect and its site. That is a redundancy removal under D121, the label ticket 141's close gave its own shortened route. No numerical bound applies, so no profile or measurement was taken. One slice (ruling P4); amendment 13 makes ticket 16's code wait for S1's merge. No owner-reserved question arose. Sources: `local://t143-docs-notes.md:3`; `local://t143-design-assignment.md:10`; `local://t143-ruling.md:21-23,66,68-69,106`; `docs/CURRENT-RULES.md:12,31`.

Final close review: approved by a fresh Fable advisor with no blocking findings; the PM applied two of its wording notes. Integration is gated on fresh approval, the passing exact-SHA hosted result and the PM's fuzz campaigns. Public ticket/paired-roadmap edits and private design/evidence records land separately (D145); C3 status remains only in its paired roadmap Status line and board, and the contract register and decision log are unchanged. Sources: `docs/CURRENT-RULES.md:8,17,26-30`.

## Raw evidence references

The [inventory](ticket-143-evidence-inventory.json) is copied verbatim from `local://t143-evidence-inventory.json` (SHA-256 `1cc8224f7ae211d2395b2d930b971272b72c6168effb4f4b2bc57e8ac145dfc5`); raw files remain outside both repositories. Below, S1 expands exactly to `C:/Users/darius.jones/worktrees/dwarf-harness/t143-s1-evidence`. Each hash comes from the inventory; the M2, M3 and green logs not listed are in it. No raw log, receipt or profile is copied here. The coder's report is `local://t143-s1-report.json` (SHA-256 `8c2318717b8607751e4250559f04362eb4b2e163da6281e01a4467244ee03c6e`) and the diff `local://t143-s1.diff` (SHA-256 `38251d18c921b1559267c70df7c86818f2f785071bd15ff27ecf08c521bbe229`).

| Path | SHA-256 |
|---|---|
| S1/commands.jsonl | `a306f76c23d266d95bd948669faae608e707e3599448a81d29d651fa311158d3` |
| S1/final-focused.log | `368f66524fca5fc0798d8a25a27e6d058a5d5c319a3c3fa8b5986a195671ea41` |
| S1/final-v1.log | `6b2bdf785a63e0dbc3dddedf9abe49053383940962bec0b49ad09df97b51fa4e` |
| S1/final-race.log | `963a2bc5d20e29ec8d43fd78b05329d17b4257ccdc58017b53778d9e3bf74040` |
| S1/final-x20.log | `857edd58130c1b0b032375d4d5d14c07be109b3dd3d7d13e2f8223b54a2b1af6` |
| S1/base-hashes.json | `8a29cd0b434ea906eb6272f79c6f628a113d1a15e94e349ae8979dc139cb1438` |
| S1/final-hashes.json | `6a37eb07bdd1adf74bc486de79f1fab6c7243e9bf7c21ea16ca61e09274de809` |
| S1/m1-live-red.log | `0a65177d1dc7f384594aee76aaf3e24d3ccd83e18456c9d7c472a29a00ca5d64` |
| S1/m1-reopen-red.log | `405791a1d2b9c5b6cb442d6cd7030a02bdd7cca3fa1160fdf60c37cf99e661d8` |
| S1/m1-replay-red.log | `9189f20854c9b1d02c022d4566edb96d370c683e0b3c9a5bc610c1b1eb590abd` |
| S1/m1-restore.log | `ac1062ccf4972e14e1f9126ccc1d4344934726eebafec624a135b6e2f3677dbe` |
| S1/m4-held-red.log | `b9e990706163686ee0623df7e8f883bf4cc1aaef8d5833c6b1ff2a976bbb9c0f` |
