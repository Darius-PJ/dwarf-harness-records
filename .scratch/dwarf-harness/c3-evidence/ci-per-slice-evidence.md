# Per-slice GitHub CI cutover evidence (D153)

**Record date:** 2026-10-27, owner's local calendar. **Private destination:** `.scratch/dwarf-harness/c3-evidence/ci-per-slice-evidence.md`. This file accompanies [D153](../../../docs/DECISIONS.md#d153-each-slice-is-checked-on-github-before-main-moves); it is not published in the project repository. D145 retains decisions, evidence and agent guidance only in the private records repository. Sources: `docs/DECISIONS.md:2861-2867,2877-2888,2900-2903`; `local://ci-cutover-draft-assignments.md:6-20`.

## Scope and activation boundary

D152 item 6 authorizes a hosted exact-commit merge gate only after the workflow and protecting rules exist and are recorded. Before activation, the prior D141/D146 push and local-gate rules remain. The adopted procedure alone is not proof of activation; the completed run and owner confirmation are recorded below. Sources: `docs/DECISIONS.md:3036-3039`; `local://d153-draft.md:3-5`; `local://ci-per-slice-confirm-verdict.md:29-32`.

The branch was pushed under recorded workflow authorization D152; its guard scanned four outgoing commits and 141 added lines with no refusing hits. The saved hosted start establishes a real run, not a successful check. Main had not moved in the accompanying PM note. Sources: `local://t13-docs-notes.md:248`; `local://ci-per-slice-run-start.json:2-20`.

| Activation prerequisite | Evidence recorded | Source |
|---|---|---|
| Review of exact candidate and both hooks | Final confirm approves 8aea12c, with the conditions below | `local://ci-per-slice-confirm-verdict.md:21-36` |
| Successful hosted `Check result` on exact final candidate SHA | Public run3 completed successfully on 8aea12c771e06807f26ae2a605b94414ca916d8a; classifier, all three full-check matrix jobs and aggregate succeeded | `local://ci-per-slice-hosted-proof.json` (`jobs`, `checks`) |
| Required check and source | Owner confirmed GitHub Actions as source, then selected “Corrected and saved” after the remote rejected typo `check results` instead of exact `Check result`. No-bypass configuration is from the owner's reported standard, not unauthenticated API visibility | `local://ci-owner-pin-record.json`; `local://ci-main-promotion.json` |
| Observable enforcement | The remote refused the mismatched required context, then accepted the same hosted-green SHA after correction; it also accepted the independently green Markdown followthrough. No bypass was used | `local://ci-main-promotion.json`; `local://ci-docs-main-promotion.json` |
| D153, AGENTS and guidance | Applied and document-checked before workflow promotion; private links returned `[]`, all three private files LF, all five skills retain frontmatter/LF | Activation events below |
| Effective cutover | Reviewed, hosted-green workflow SHA8aea12c and independently green Markdown SHA93e8f0a were both promoted and pushed through the guard and remote rules | Run3/run4 proof and promotion records below |

Historical prerequisite distinctions remain in the saved start/draft records. This record distinguishes actual hosted success, owner-reported settings, observed remote enforcement and document checks; it does not infer hidden settings or detailed package timings.

## Candidate and change provenance

| Candidate/change | Cited fact |
|---|---|
| Base | `d8336c8`, ticket 13's already merged S4/S4b, precedes this workflow branch; its public run 2 is not this workflow's hosted proof. `local://t13-docs-notes.md:237-238,240` |
| `ea2e6f4` | Initial workflow: work-branch triggers, per-ref cancellation, merge-base path classification, annotations/inventory and aggregate gate. `local://t13-docs-notes.md:242` |
| `edef6ef` | README and Core §8.2 describe the proposed per-slice check. `local://t13-docs-notes.md:246` |
| `d663698` | Aggregate now requires classifier success; classifier path output uses a random stop-commands token. `local://t13-docs-notes.md:246` |
| `8aea12c771e06807f26ae2a605b94414ca916d8a` | Reviewed/pushed candidate. Markdown-only followup clarifies README's merge-base comparison, Core's checkout costs and tickets 139/140's CI gates. `local://ci-per-slice-confirm-doc-diff.md:1-3,19-20,43-44,65-66,89-90`; `local://ci-per-slice-confirm-request.md:12,26-32` |
| Hooks | Project hook calls MAIN `.git/hooks/pre_push_scan.py`; private records hook calls the same script with `--records`. Both refuse merge histories before scanning. `local://ci-per-slice-confirm-request.md:9-11,16-25`; `local://ci-per-slice-confirm-verdict.md:21-24` |

The coder's initial workflow SHA-256 was `1c71f3a369939f2de588dbbb4eb16c566ecefdfd9bb160b06de952640cf367f9`; this belongs to the initial report, before the aggregate/path-output repair. It is not asserted as the final workflow digest. The exact hosted candidate is identified by the full commit SHA above. Sources: `local://ci-per-slice-coder-report.json:122-124`; `local://t13-docs-notes.md:242,246`; `local://ci-per-slice-run-start.json:5-7`.

## Observed local smoke — not hosted proof

The coder directly exercised extracted Bash bodies under Git Bash and reported `ALL_SMOKE_CASES_PASSED`; five Bash bodies passed syntax checking. No Go tests or hosted runs were performed by that coder for this workflow change. YAML language-server/local-parser coverage was unavailable (PyYAML and Bun unavailable). These are bounded local observations, not native Windows/Linux/macOS workflow results. Sources: `local://ci-per-slice-coder-report.json:89-92,104-120`; `local://ci-per-slice-verdict.md:39-41`.

| Local case | Observed outcome | Source |
|---|---|---|
| Markdown-only historical commit `5cabee113d4d59873794e391aa617defacc6eb4b` against its historical parent | Classified false; matrix skipping accepted by the extracted aggregate | `local://ci-per-slice-coder-report.json:10-13` |
| Code-only `d8336c85c6314c349c9358e1328c91a4c61b811a` | Classified true; matrix success required | `local://ci-per-slice-coder-report.json:16-19` |
| Mixed `34330e132c821d2966da04206d4970704bc58403` | Six Go and two Markdown changes classified true | `local://ci-per-slice-coder-report.json:22-25` |
| Manual dispatch of Markdown-only commit | Classified true; dispatch forces full checking | `local://ci-per-slice-coder-report.json:28-31` |
| Markdown tip with earlier unmerged Go change, against main `525fc98` | Merge-base comparison includes `transport_test.go`, classified true | `local://ci-per-slice-coder-report.json:34-37` |
| Empty changed-path set | Classified false; matrix skips | `local://ci-per-slice-coder-report.json:40-43` |
| Initial aggregate's 20 combinations | Two intended code/matrix combinations accepted, but classifier-job outcome was not tested; superseded by the repair below | `local://ci-per-slice-coder-report.json:46-49`; `local://ci-per-slice-verdict.md:8-11` |
| Repaired aggregate, 75 combinations from workflow text | Exactly classifier-success/code-true/matrix-success and classifier-success/code-false/matrix-skipped pass | `local://t13-docs-notes.md:246`; `local://ci-per-slice-rereview-verdict.md:21-24` |
| Wrapper output and exit status | Byte-identical tee output; exit 37 preserved; `%`, CR/LF, embedded `::`, nested tests and multiple packages exercised; six escaped errors, ten-error cap, one escaped inventory notice, no errors on command success | `local://ci-per-slice-coder-report.json:52-55`; `local://ci-per-slice-verdict.md:31-33` |
| Classifier filename output | First review found Bash `%q` insufficient for workflow commands; random stop-commands repair cleared on re-review | `local://ci-per-slice-verdict.md:20-23`; `local://ci-per-slice-rereview-verdict.md:21-24` |
| Triggers/concurrency | Reported pushes only to `build/**`, `docs/**`, `fix/**`, plus dispatch; no path filters/main push trigger; newer same-ref run cancels older | `local://ci-per-slice-coder-report.json:58-61`; `local://t13-docs-notes.md:242` |

The current-tree Markdown inventory supported no tracked `.md` inputs to code, embeds, tools or tests: embeds are non-Markdown; named Markdown files are runtime paths or generated fixtures; STYLE.md is author guidance. Re-review accepted the premise, not a permanent exemption for future Markdown inputs. PM link/LF checking under D128 remains separate. Sources: `local://t13-docs-notes.md:246`; `local://ci-per-slice-rereview-verdict.md:25-28`; `docs/DECISIONS.md:2212-2217`.

Raw coder smoke files were retained under `C:/Users/darius.jones/worktrees/dwarf-harness/ci-per-slice-evidence/`: `smoke.log` and `annotations.log`; the throwaway `smoke.sh` was removed after success. The report's annotation sample is fabricated smoke output, not a hosted failure or inventory. Sources: `local://ci-per-slice-coder-report.json:64,115-120`.

## Observed guard proofs — no reruns by the drafter

The initial endpoint-only scan was insufficient even for cooperative publication: intermediate introduced-and-removed secrets or workflow edits remain in outgoing history. The first repair scans every outgoing commit's own patch, message, identities and `.github/` paths. Re-review then found merge history could still escape; the final repair refuses outgoing merge commits unconditionally in both modes. Sources: `local://ci-per-slice-verdict.md:14-17`; `local://t13-docs-notes.md:246`; `local://ci-per-slice-rereview-verdict.md:8-11`; `local://ci-per-slice-confirm-request.md:16-25`.

| Supplied PM proof | Observed result | Source |
|---|---|---|
| Fabricated key in merge commit's own changes | Plain `git log -p` did not contain it (`False`); guard refused merge `5bed12b` | `local://ci-per-slice-confirm-request.md:18-20` |
| Workflow added/removed on a side branch and merged `--no-ff` | Path-limited `.github/` log empty; guard refused merge `cbfebc5` | `local://ci-per-slice-confirm-request.md:21` |
| Linear introduce-then-remove sensitive content | Still refused in both modes (`sk- key`, `anthropic key`) | `local://ci-per-slice-confirm-request.md:22` |
| Real records range `origin/main..main` | Two commits, 70 added lines passed `--records`; records hook dry-run printed `ok` | `local://ci-per-slice-confirm-request.md:24-25` |
| Real project branch dry-run | Refused `.github/ changed` without sign-off override; passed with `DWARF_ALLOW_WORKFLOW=D152` | `local://ci-per-slice-confirm-request.md:26` |
| Actual guarded candidate branch push | Four outgoing commits, 141 added lines; no refusing hits; branch 8aea12c pushed under authorization D152 | `local://t13-docs-notes.md:248` |
| Final confirm of both hooks | Merge detection traverses the outgoing range without path filtering; unconditional refusal in both modes resolves the major | `local://ci-per-slice-confirm-verdict.md:21-24` |

Earlier installation smoke also detected synthetic key/assignment/path lines and demonstrated real hook refusal of a dry-run branch push without its workflow override. That earlier endpoint-only implementation is not the final guard proof. Source: `local://t13-docs-notes.md:243`; `local://ci-per-slice-verdict.md:14-17`.

The public guard uses the published identity and privacy/credential checks; machine terms require a contextual human read, and the `.github/` override needs actual recorded owner authorization. Records mode deliberately allows D145 private paths and owner quotes but still rejects credentials and merge histories. No credential/identity/privacy override is authorized. The hook remains bypassable and is not a hostile-writer security boundary. Sources: `local://d153-draft.md:43-54`; `local://ci-per-slice-verdict.md:43-45`; `local://ci-cutover-draft-assignments.md:22`.

## Settings: reported versus publicly observed

The owner wrote at 12:50:

> Settings are changed, Github is up to the new standard. money was left off of the list unintentionally. I will also clear the session after each ticket

This is his settings report, not independent API proof of every control. Source: `docs/DECISIONS.md:3025-3026`; `local://t13-docs-notes.md:244`.

| Control/inventory | What the supplied record establishes | What it does not establish |
|---|---|---|
| `Protect Main`, id 25833473 | Baseline public API showed deletion, non-fast-forward, linear-history and required-status-check rules; later remote enforcement and owner correction are recorded below | Baseline empty list was pre-pin; unauthenticated bypass visibility remains limited |
| Projects | Public API showed off | No claim about other feature restrictions follows |
| Issues | Public API still returned `has_issues: true` | That field does not settle collaborator-only participation |
| Actions permissions/pins/fork approvals | Recommended GitHub-created actions only, full-length action SHA pins, approval for all external contributors, read-only token and PR creation/approval off; covered by owner's general report | No independent observation of private/admin-only settings |
| Secrets/Dependabot | Repository secret push protection on; Dependabot alerts on and its PRs off were recommended/reported | No separate API verification supplied |
| Issues/PR participation | Collaborators-only (or off) was recommended; general report supplied | No independent confirmation of participation limit |
| Vercel/collaborators/deploy keys/webhooks | Owner was asked to remove Vercel repository access unless deploying it and confirm empty writer/integration inventories | General settings report is not a separately verified inventory |
| Required-check source and bypass at activation | Owner confirms GitHub Actions source and corrected exact name; no bypass is part of his reported standard | No independent admin-visible bypass-list observation is claimed |

Sources: `local://t13-docs-notes.md:240,244`; `local://ci-per-slice-confirm-verdict.md:29-32`. D146's older rule/bypass observations remain historical, not evidence of the new required-check activation (`docs/DECISIONS.md:2925-2929`).

## Trust boundary

The reviewed workflow retains read-only contents permissions, credential-free checkouts, full-SHA action pins, verified Go/LLVM downloads, hosted runners, no secret references and no PR triggers. Its output wrapper treats child output/filenames as data; that protects workflow-command output, not execution from malicious repository code. Source: `local://ci-per-slice-verdict.md:31-37`; `local://ci-per-slice-rereview-verdict.md:21-24`.

The safeguards limit public tampering; they do not secure the repository against someone holding authorized write credentials. Required job name plus GitHub Actions source authenticates neither workflow meaning nor `tools/check` contents. A writer could substitute a no-op job, weaken the check outside `.github/`, or bypass the local hook via another client/API or `--no-verify`. The owner retains `.github/` sign-off, but the hook's D-entry string is not itself authorization. The supplied inventory does not independently establish absence of all other writers/integrations. Sources: `local://ci-per-slice-verdict.md:43-49`; `local://ci-per-slice-rereview-verdict.md:39-42`; `local://t13-docs-notes.md:240,244`.

`Check result` intentionally means full-check-or-Markdown/empty-diff exemption. On pushes, classification spans the branch's merge base with main; on manual dispatch the full matrix runs. A failure/cancellation of classification must fail the aggregate even if `code=false` was already emitted. All successful results remain bound to the exact SHA; rebasing/fixing requires another run. Sources: `local://ci-per-slice-verdict.md:8-11,27-29,47-49`; `local://ci-per-slice-rereview-verdict.md:21-28`; `local://ci-per-slice-coder-report.json:28-43`.

## Review chronology and final confirmation

| Review | Candidate | Outcome and disposition | Source |
|---|---|---|---|
| StandInCIPerSlice | `ea2e6f4` | `needs-evidence`: classifier-result gate and intermediate-commit scan majors; filename-output minor; Markdown-input inventory needed. Not merge approval | `local://ci-per-slice-verdict.md:5-23,47-56` |
| StandInCIPerSliceRe | `d663698` | `reject`: gate, filename output and Markdown premise cleared; merge-history major remained; checkout-cost sentence was a nonblocking note | `local://ci-per-slice-rereview-verdict.md:5-17,21-38` |
| StandInCIPerSliceConfirm | `8aea12c` and both hooks | `approve`: merge-history major resolved; guarded push authorized; promotion conditional on exact-SHA hosted success, owner GitHub Actions source pin/no bypass, completed D153 and guidance | `local://ci-per-slice-confirm-verdict.md:5,21-36` |

These are temporary stand-in reviews, not Fable's post-reset ticket verification. The final confirm's actual model is `openai-codex/gpt-6-astra`, fallback false, thinking max, established from `C:/Users/darius.jones/.omp/agent/sessions/-Documents-PROJECTS-dwarf-harness/2026-10-24T15-58-31-752Z_01a16ea2-9748-77b3-ac90-a8beabd7bc22/StandInCIPerSliceConfirm.jsonl:3-4`. The other review agents are named here without independently asserting their runtime model. Their saved yields identify themselves as stand-ins, with Fable to double-check the whole ticket after its reset. Sources: `local://ci-per-slice-verdict.md:52`; `local://ci-per-slice-rereview-verdict.md:38`; `local://ci-per-slice-confirm-verdict.md:35-36`; `docs/DECISIONS.md:3032-3034`.

The final confirm's two documentation notes are **nonblocking, next-touch changes with no confirmation pass**: README's exemption must say it applies to pushes (dispatch forces the matrix); tickets 139/140 should say each code slice or explicitly name `Check result` and its exemption. The final confirm accepted deferral of the paired C3 status edits under the plan then supplied; subsequent PM guidance integration is recorded separately below. Sources: `local://ci-per-slice-confirm-verdict.md:9-17,25-32`; `local://ci-per-slice-confirm-request.md:29-32`.

## First actual hosted run — completed

| Observed field | Saved value | Source |
|---|---|---|
| Public run / id | 3 / `40612562217` | `local://ci-per-slice-run-start.json:2,9` |
| Branch / event | `build/ci-per-slice` / `push` | `local://ci-per-slice-run-start.json:5,10` |
| Exact head SHA | `8aea12c771e06807f26ae2a605b94414ca916d8a` | `local://ci-per-slice-run-start.json:6` |
| Created | 2026-10-27 21:02:12 −04:00; API value `2026-10-28T01:02:12Z` | `local://ci-per-slice-run-start.json:19`; local-calendar conversion |
| Saved start status / conclusion | `in_progress` / `null` | `local://ci-per-slice-run-start.json:11-12` |
| Hosted result URL | [Run 40612562217](https://github.com/Darius-PJ/dwarf-harness/actions/runs/40612562217) | `local://ci-per-slice-run-start.json:17` |
| Final outcome | `success`; classifier, all three full-check jobs and `Check result` succeeded on the same exact SHA | `local://ci-per-slice-hosted-proof.json` (`jobs`, `checks`) |
| Completion | 2026-10-27 21:38:06 −04:00, from the final aggregate completion | `local://ci-per-slice-hosted-proof.json` (`jobs`: `Check result`) |
| Aggregate reporting app | GitHub Actions, slug `github-actions`, id `15368` | `local://ci-per-slice-hosted-proof.json` (`checks[0].app`) |
| API job durations | Windows 2134s; macOS 1257s; Linux 632s. These are whole job spans, not check-step totals | `local://ci-per-slice-hosted-proof.json` (`jobs`) |
| Runner inventory notices | Linux `ubuntu24` / `20261023.334.3`, Git2.55.0; Windows `win22` / `20261022.344.1`, Git2.56.0.windows.3; macOS `macos15` / `20260907.0337.1`, Git2.55.0; each reports Go1.27.3 for its target | `local://ci-per-slice-hosted-annotations.json` |

The completed run and inventory notices are actual hosted proof, separate from the coder's extracted-shell smoke. Detailed check/package timing and a full log inspection are not claimed; unauthenticated log endpoints still returned403. The saved post-run, pre-pin ruleset observation had no selected required check. The owner subsequently confirmed the selection/source adjustment; that clears the UI blocker without rerunning CI or merely rechecking his report. See `local://ci-required-check-picker-findings.md` for the documented typed-name/+ control and the unverified suggestion-population behavior. No API mutation or protection bypass was performed.

## Guidance and documentation integration

The PM integrated `local://ci-record-edits.md` as D153, four one-line amendments and the Check/Commits replacement in AGENTS.md, preserving its adjacent Owner sign-off line. The final, concise canonical wording—not the earlier conditional draft—is authoritative. Private evidence stays out of project publication; no B entry or ticket13 close belongs to this cutover.

D153's activated loop is focused D152 coder checks/hashes; rebase/merge-base; all-outgoing-commit scan; work-branch push; fresh blocking-standard review concurrent with CI; exact-final-SHA `Check result` success before ff-only main/push. A changed SHA needs a new run. Markdown-only branches still get PM link/LF checking; manual dispatch forces a full matrix. D152's local race/static/rule-break conditions, changed-target 120 s fuzz campaigns, contract evidence and owner gates remain. Sources: `docs/DECISIONS.md:1934,3028-3038`; `local://ci-cutover-draft-assignments.md:20-22`; `local://ci-per-slice-confirm-verdict.md:29-32`.

The PM prepared the separate public documentation followthrough as `93e8f0a`, `docs(build): align integration guidance with hosted checks (D153)`, on `docs/ci-cutover-guidance`, parent `8aea12c`. It changes five files (seven lines each way): README distinguishes push-only exemption from forced-full dispatch; tickets 139/140 say each code slice; ROADMAPS working rule 3 uses the exact-SHA hosted `Check result`; C3's ROADMAP-CORE Status and ROADMAPS board row change together to D153 cadence and the already recorded public run 2, without closing ticket 13. The pending close edits E08/E09 were reanchored. Sources: `local://t13-docs-notes.md:250,252`.

The followthrough was pushed only after protected workflow promotion to8aea12c. Public [run4](https://github.com/Darius-PJ/dwarf-harness/actions/runs/40619407526) passed on exact93e8f0afe125b1ea8e87f4b8336664dd390c5b3a: classifier and aggregate succeeded, matrix skipped. It then fast-forwarded main and was accepted remotely. The preparation link check had only known mirror omissions of real non-Markdown README targets, and all five files were LF; no public-clone access to D145 private records is claimed. Sources: `local://ci-cutover-docs-hosted-proof.json`; `local://ci-docs-main-promotion.json`; `local://t13-docs-notes.md`.

## Owner confirmation and activation

Recorded 2026-10-27T22:00:20-04:00 (chat):

> Adjusted, Github actions is the source of these checks for the rule

The source adjustment is owner-reported. After the first remote refusal exposed the name typo, he selected “Corrected and saved” following the exact `Check result` instruction. The unchanged green commit was then accepted, without rerunning CI or bypassing a rule. His earlier reported standard includes no bypass; the unauthenticated API does not independently expose that list. Sources: `local://ci-owner-pin-record.json`; `local://ci-main-promotion.json`.

D153, AGENTS.md, managed-skill changes and the document check completed before promotion. The actual protected publication events follow; they are not inferred from prepared commits.

### Activation events

- Before promotion, D153 and AGENTS.md were applied, and ApplyCISkills applied all56 prescribed edits to the five managed skills without conflicts. Its actual model was `openai-codex/gpt-6-astra`, xhigh, fallback false.
- PM document verification: the private D153/AGENTS/evidence link check returned `[]`; all three files are LF. The five managed skills retain their frontmatter and LF. No local full check or passing hosted run was repeated.
- D153/AGENTS/evidence were committed privately as135e697 before main advanced. The first main push was refused because the required context was `check results`; the owner corrected it to exact `Check result`. Retrying only that failed guarded push succeeded, advancing remote main d8336c8..8aea12c; `ls-remote` returned8aea12c771e06807f26ae2a605b94414ca916d8a.
- The docs branch push scanned one commit/nine added lines with no refusing hits. Public run4 completed successfully on93e8f0afe125b1ea8e87f4b8336664dd390c5b3a, with the matrix skipped and the classifier/aggregate successful. Main then advanced8aea12c..93e8f0a; its guarded push was accepted and `ls-remote` matched that exact SHA. This is the end-to-end Markdown exemption proof, not a second full-suite run.
- Sources: `local://ci-main-promotion.json`, `local://ci-cutover-docs-hosted-proof.json`, `local://ci-docs-main-promotion.json`, and `local://ci-docs-notes.md`. Fresh post-reset Fable requests are prepared as `local://t13-fable-verification-request.md` and `local://ci-fable-verification-request.md`; neither verification has run. Ticket13 remains open, and its temporary data is retained until the ordered close.
