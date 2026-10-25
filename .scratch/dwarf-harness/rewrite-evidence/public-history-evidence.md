# Evidence: the rewritten history for the public repository (D145)

The project manager (PM-Beta) did this work on 2026-10-25. Times are EDT and come from command output. The decision itself is [D145](../../../docs/DECISIONS.md#d145-a-rewritten-history-for-the-public-repository-and-private-records).

## Inputs
- **The source:** `main` at 3bc46c436fb735b8740d7d247fbd7781d103a9f5. It has 207 commits, all authored and committed under the owner's name and personal address. It is now `main` of the private `Darius-PJ/dwarf-harness-archive`.
- **What leaves every commit,** as the regular expression `remove_regex` in [`config-pub.json`](config-pub.json):
  - `docs/DECISIONS.md`;
  - `.scratch/dwarf-harness/*-evidence/`;
  - `AGENTS.md`, `CLAUDE.md` and `.omp/`.
- **The review sets.**
  - **How they were built:** the PM scanned every version of every remaining file and every commit message for these patterns:
    - his Windows user folder, name and addresses, and the machine's name;
    - the processor, memory and Windows build;
    - the antivirus and its exclusions, and administrator rights;
    - games and other programs;
    - his quoted words, as attributed quotation, dated comments with quoted answers, and short option labels;
    - budget remarks.
  - **Result:** 108 distinct Markdown lines with his words (Q1–Q108), 29 commit-message lines (M1–M29) and 130 machine lines (H1–H130). [`scrub-keys.json`](scrub-keys.json) holds their exact text.
- **The maps.** Each one decides keep, replace or delete for every line:
  - [`scrub-quotes-map.json`](scrub-quotes-map.json), drafted by the drafter ScrubQuotes for Q and M: 98 replacements and 39 keeps;
  - [`scrub-machine-map.json`](scrub-machine-map.json), drafted by the drafter ScrubMachine for H: 28 replacements and 106 keeps, 4 of them keyed by neighbouring lines;
  - [`scrub-pm-map.json`](scrub-pm-map.json), the PM's 12 entries:
    - five kept lines whose "Defender scanning" became "antivirus scanning";
    - the two "one Windows laptop" lines;
    - one Go comment, two Markdown lines and two commit-message lines with his words that the review sets had missed.

## Tools
- **[`rewrite.py`](rewrite.py)** rebuilds the history in order, one commit for each old commit, with Git plumbing:
  - It drops the removed paths.
  - It applies the maps' line replacements to `.md` and `.go` files outside `testdata/`, and to commit messages.
  - It translates each cited commit hash in Markdown and in messages to its new counterpart, at the same length.
  - It writes the configured identity as author and committer, and keeps every date and time zone.
- **[`verify.py`](verify.py)** checks a rewritten repository against the source, using the same configuration:
  - `git fsck`;
  - one identity throughout, with dates equal to the source's;
  - no removed path left;
  - no credential pattern and no personal identifier left;
  - pattern hits on lines nobody reviewed, written to `residuals.txt`;
  - files other than Markdown and Go unchanged at the tip;
  - test data byte-identical;
  - no old commit hash still cited.

## 1. The rewrite
`python rewrite.py config-pub.json`, 38.6 s:

```
207 commits; tip fee7a16d07587a7f20ebb4983d8b497e6fc103ce; 642 citations translated; 0 anomalies; 23 empty commits; 0 unused replacements
```

- [`report.json`](report.json) lists every translation and how many times each replacement applied.
- [`changes.txt`](changes.txt) lists each replacement, before and after, by file: 251 line replacements in 151 files and 27 in commit messages.
  - It shows the lines as the maps wrote them. The rewrite then translated any commit hash in them.
- [`commit-map.txt`](commit-map.txt) maps each old hash to its new hash, in commit order.
- **The 23 empty commits** changed only removed paths. They stay, so that every old commit has a counterpart.

## 2. The documents commit
- A drafter, PublicDocs, wrote `README.md`, `SECURITY.md` and `ARCHITECTURE.md` from the repository. Its [notes](public-docs-notes.md) list the claims it inferred and the choices left to the owner.
- The PM checked the three files' relative links: none broken.
- The PM committed them as 3c9db5c57f55176b181d7c571e3dea967d609aaf, "docs: add README, SECURITY and ARCHITECTURE", on top of fee7a16.

## 3. Verification before the owner's review
- **`python verify.py config-pub.json`:**

  ```
  commits: 208 (207 rewritten, 1 added); identity Darius-PJ <173397901+Darius-PJ@users.noreply.github.com>
  tip: 687 files; added ['ARCHITECTURE.md', 'README.md', 'SECURITY.md']; Go files changed: ['internal/core/ledgerstore/workload_test.go', 'internal/core/workspace/doc.go']
  testdata: 34 files byte-identical
  unreviewed pattern hits: antivirus 2, email-like 11, program 6, quote 2
  RESULT: PASS
  ```

- **[`residuals.txt`](residuals.txt), the hits accepted:**
  - the CI workflow's two Defender diagnostics, which describe GitHub's runners;
  - eleven `@example.invalid` and `@dwarf-harness.invalid` test addresses;
  - "gaming", in the sense of cheating a check, in four documents;
  - `owner` as a code identifier: `owner_sid`, and "non-owner wrote".
- **The commands given to the owner,** run in Git Bash in the rewritten repository:
  - `git log --all -p --format="%an %ae %cn %ce%n%B" | grep -ciE "darius\.jones|pierce|3dpjones|gmail|slay ?the ?spire|10610U|19045"` printed `0`;
  - `git log --all --format="%an <%ae> | %cn <%ce>" | sort | uniq -c` printed one identity, on 208 commits.
- **The full check on 3c9db5c,** in the gate worktree, with `CGO_ENABLED=0`, `DWARF_CC` set to the pinned clang and `go run ./tools/check`: `EXIT=0 SECONDS=1404`. The full output is [`check-3c9db5c.txt`](check-3c9db5c.txt).

  ```
  PASS  0 toolchain in 0.1s
  PASS  1 gofmt in 1.0s
  PASS  2 vet in 23.2s
  PASS  3 staticcheck in 40.0s
  PASS  4 govulncheck in 14.8s
  PASS  5 import boundary in 4.4s
  PASS  6 tests in 424.3s
  PASS  7 race in 878.5s
  PASS  8 cross builds in 11.7s
  check PASSED: all 9 steps passed in 1397.9s
  ```

## 4. The owner's review
- He was sent:
  - the before-and-after list;
  - the two commands;
  - `verify.py`;
  - the accepted residuals;
  - the lines kept as judgement calls: the long-paths setting, Git's line-ending setting, "NTFS volume C:" and "a non-administrator";
  - the note that commit dates and time zones were kept.
- At 13:54 he wrote that the state looked clean, and started the cutover (D145).

## 5. The cutover
- **The GitHub repositories, before the push** (`git ls-remote`, 13:59):
  - `Darius-PJ/dwarf-harness` and `Darius-PJ/dwarf-harness-records` were empty;
  - `Darius-PJ/dwarf-harness-archive` held `main` at 3bc46c436fb735b8740d7d247fbd7781d103a9f5.
- **The backup:** the 75 private files of the project checkout were copied, with a `SHA256SUMS` list, to `C:\Users\darius.jones\Documents\PROJECTS\DwarfHarness\cutover-backup-2026-10-25\`. They are DECISIONS.md, the evidence folders, `AGENTS.md`, `CLAUDE.md`, `.omp/`, `INTENT.md` and `pyrightconfig.json`.
- **The local archive:** `git clone --bare --no-local` of the project repository to `C:\Users\darius.jones\Documents\PROJECTS\DwarfHarness\dwarf-harness-archive.git`.
  - It holds `main` at 3bc46c4 and `build/61-s6` at 7b1c63a.
  - `git fsck --full` exited 0, and it holds no commit of the rewritten history.
  - Its `origin` is `git@github.com:Darius-PJ/dwarf-harness-archive.git`.
- **The push,** from the project repository: `git push origin refs/public/main:refs/heads/main`.

  ```
  To github.com:Darius-PJ/dwarf-harness.git
   * [new branch]      refs/public/main -> main
  PUSH_EXIT=0
  3c9db5c57f55176b181d7c571e3dea967d609aaf	HEAD
  3c9db5c57f55176b181d7c571e3dea967d609aaf	refs/heads/main
  2026-10-25 14:02:27 EDT
  ```

  The workflow has only `workflow_dispatch` (D143), so the push started no run.
- **GitHub's copy:**
  - A fresh `git clone --mirror git@github.com:Darius-PJ/dwarf-harness.git` holds only `refs/heads/main` at 3c9db5c57f55176b181d7c571e3dea967d609aaf.
  - `python verify.py config-remote.json` printed the same lines as section 3, ending `RESULT: PASS`. Its residuals were identical to the reviewed set.
- **The project checkout:**
  1. `.git/info/exclude` gained `/docs/DECISIONS.md` and `/.scratch/dwarf-harness/*-evidence/`.
  2. `git reset --mixed refs/public/main` ran first, then `git reset --hard`, which printed "HEAD is now at 3c9db5c docs: add README, SECURITY and ARCHITECTURE".
     - A direct `reset --hard` from 3bc46c4 would have deleted the private files, because 3bc46c4's index tracked them.
  3. Afterwards:
     - `git status --porcelain -uall` was empty;
     - 687 files were tracked, and the working tree equalled `HEAD`;
     - all 75 private files kept their SHA-256.
  4. `git fetch origin` moved `origin/main` to 3c9db5c, and `git status -sb` printed `## main...origin/main`.
  5. The repository's own `user.name` and `user.email` are now `Darius-PJ` and `173397901+Darius-PJ@users.noreply.github.com`. They apply to every worktree; the global Git identity is unchanged.
  6. `refs/public/main` was deleted.
- **The worktrees `61-s6` and `61-s6-base` stay.** They hold ticket 61 S6's untracked measurement driver, `_t61_s6_measure/`, and keep their old-history commits only in the local repository.

## 6. The records repository
- **Its Git directory** is `C:\Users\darius.jones\Documents\PROJECTS\DwarfHarness\dwarf-harness-records.git`. Its configuration:
  - `core.bare=false`, with `core.worktree` set to the project checkout;
  - `status.showUntrackedFiles=no`;
  - the identity of section 5;
  - `origin` `git@github.com:Darius-PJ/dwarf-harness-records.git`.
- **Its `info/exclude`** excludes everything except `AGENTS.md`, `CLAUDE.md`, `docs/DECISIONS.md`, `.scratch/dwarf-harness/*-evidence/` and `.omp/agents/`.
- **Use it as** `git --git-dir=<that path> <command>`, from the project checkout.
- **The import, 95b640d:** 72 files.
  - 61 of them are byte-identical to their blobs in 3bc46c4.
  - The other 11 are `AGENTS.md`, `CLAUDE.md` and nine role files, as they stood in the checkout.
  - A credential scan of all 72 found no private key, AWS, GitHub, Anthropic or OpenAI, Slack or Google key, and no secret assignment.
- **The translation, 3b2d48a:** 715 commit-hash citations in 49 Markdown files, through `commit-map.txt`.
  - The PM reviewed the 118 citations whose preceding text did not name a commit. All were commit citations, among them the all-digit hashes 4259902 and 3565211.
  - No old hash remains in the translated files.
  - Raw outputs are not Markdown, so they keep the hashes they were recorded with.
- **D145's commit** adds this folder and the entry.
