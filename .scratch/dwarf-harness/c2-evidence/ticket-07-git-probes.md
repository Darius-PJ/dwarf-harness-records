# T07 Git probes: merge-back into a linked-worktree scratch (measured)

Probe for ticket 07: how `read-tree -m -u` into a linked worktree's scratch, installing a private index, and a compare-and-swap branch move behave on this machine. Everything ran in throwaway repositories under `%TEMP%\t07probe-*`. The project repository was never touched. Every record below is raw harness output.

## Setup

**Machine**

```
$ git --version
git version 2.55.0.windows.3
$ cmd /c ver
Microsoft Windows [Version 10.0.19045.6456]
$ git config --show-scope --show-origin --get-regexp "^(core|windows|init|checkout)\."   (run in %TEMP%)
system	file:C:/Program Files/Git/etc/gitconfig	core.autocrlf true
system	file:C:/Program Files/Git/etc/gitconfig	core.fscache true
system	file:C:/Program Files/Git/etc/gitconfig	core.symlinks false
system	file:C:/Program Files/Git/etc/gitconfig	init.defaultbranch master
global	file:C:/Users/darius.jones/.gitconfig	windows.appendatomically false
global	file:C:/Users/darius.jones/.gitconfig	init.defaultbranch main
```

**Harness:** a Python 3.13.15 script (`C:\Program Files\Python313\python.exe`) calls `subprocess.run` with an argument list. stdin is `DEVNULL` unless a record says otherwise, and stdout and stderr are captured as bytes. The parent environment is passed through with every `GIT_*` variable removed. None were set, so `env set:` in each record lists every Git variable present. Each record shows `subprocess.list2cmdline` of the argument list, the cwd, the variables set, the exit code with wall time, and raw stdout and stderr. File operations that are not Git commands are recorded as the Python call that made them (`os.replace` is `MoveFileExW(MOVEFILE_REPLACE_EXISTING)`, the same call Go's `os.Rename` makes on Windows). The locking process in case D is a background `powershell.exe` launched with `subprocess.Popen`. Its full command line is recorded.

**Repository build:** every case below starts from a fresh root built by these exact commands. Only the paths and commit ids differ. The OLD and NEW trees are identical in every case: OLD `8dd99e09…`, NEW `dc997397…`. This listing is the build of the first root, A1. `repo` gets `core.autocrlf=false` locally because the system config sets it to true. Step 1 always pins it explicitly with `-c`.

Root: `C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g`  (`repo`, `scratch` and `private.index` live under it)

```
$ git init -b main C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\repo
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g
env set: (none)
exit: 0   (0.07s)
--- stdout ---
Initialized empty Git repository in C:/Users/darius.jones/AppData/Local/Temp/t07probe-A1-kuxf_6_g/repo/.git/
--- stderr ---
```
```
$ git config core.autocrlf false
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\repo
env set: (none)
note: repo-local; the system gitconfig sets core.autocrlf=true
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
Files written into `repo` with Python `write_bytes` (LF only): `keep.txt` = b'keep line 1\nkeep line 2\n', `mod.txt` = b'mod original 1\nmod original 2\n', `del.txt` = b'to be deleted 1\nto be deleted 2\n', `notes.txt` = b'notes a\nnotes b\nnotes c\n'

```
$ git add -A
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\repo
env set: (none)
exit: 0   (0.06s)
--- stdout ---
--- stderr ---
```
```
$ git commit -q -m base
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\repo
env set: (none)
exit: 0   (0.08s)
--- stdout ---
--- stderr ---
```
```
$ git worktree add --no-checkout -b scratch-b C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\scratch main
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\repo
env set: (none)
exit: 0   (0.08s)
--- stdout ---
--- stderr ---
Preparing worktree (new branch 'scratch-b')
```
```
$ git read-tree -u --reset HEAD
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
d97d9c7d73f64e93afe61d024890489d9722f8c9
--- stderr ---
```
```
$ git rev-parse d97d9c7d73f64e93afe61d024890489d9722f8c9^{tree}
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
8dd99e09a46e19a02e68f292c0120e7dc42c69c1
--- stderr ---
```
NEW is built in the main repository with a temporary index file; `scratch` is not touched:

```
$ git read-tree 8dd99e09a46e19a02e68f292c0120e7dc42c69c1
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\repo
env set: GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\build.index
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git hash-object -w --no-filters --stdin
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\repo
env set: (none)
note: stdin = b'mod CHANGED 1\nmod original 2\nmod added 3\n'
exit: 0   (0.05s)
--- stdout ---
10ac2baa0965e7ddc30b97c5824d8a8270b519e5
--- stderr ---
```
```
$ git hash-object -w --no-filters --stdin
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\repo
env set: (none)
note: stdin = b'added line 1\nadded line 2\n'
exit: 0   (0.04s)
--- stdout ---
51fa1036c055e2b2af0a34bdeeb5b553da6d55b4
--- stderr ---
```
```
$ git update-index --cacheinfo 100644,10ac2baa0965e7ddc30b97c5824d8a8270b519e5,mod.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\repo
env set: GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\build.index
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
```
$ git update-index --add --cacheinfo 100644,51fa1036c055e2b2af0a34bdeeb5b553da6d55b4,added.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\repo
env set: GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\build.index
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git update-index --force-remove del.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\repo
env set: GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\build.index
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git write-tree
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\repo
env set: GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\build.index
exit: 0   (0.05s)
--- stdout ---
dc9973975472c4e240433ce156dc1c4f28ff4c77
--- stderr ---
```
```
$ git commit-tree dc9973975472c4e240433ce156dc1c4f28ff4c77 -p d97d9c7d73f64e93afe61d024890489d9722f8c9 -m new
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\repo
env set: (none)
exit: 0   (0.05s)
--- stdout ---
81b2df4a539902fb86199aba0f489ce169be76ca
--- stderr ---
```
```
$ git diff-tree -r --name-status 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
A	added.txt
D	del.txt
M	mod.txt
--- stderr ---
```
`build.index` deleted. OLD tree `8dd99e09a46e19a02e68f292c0120e7dc42c69c1` (OLDCOMMIT `d97d9c7d73f64e93afe61d024890489d9722f8c9`); NEW tree `dc9973975472c4e240433ce156dc1c4f28ff4c77` (NEWCOMMIT `81b2df4a539902fb86199aba0f489ce169be76ca`).

**Procedure used in the cases**

- Load the private index: `GIT_DIR=<repo>/.git/worktrees/scratch GIT_WORK_TREE=<scratch> GIT_INDEX_FILE=<root>/private.index git read-tree OLD`
- Step 1: same env, `git -c core.autocrlf=<false|true> read-tree -m -u OLD NEW`
- Step 2: **rename** (`os.replace(private.index, <repo>/.git/worktrees/scratch/index)`) in A, B, C, D and E, and in F2. **copy** (`shutil.copyfile`) in F1.
- Step 3: `git update-ref refs/heads/scratch-b NEWCOMMIT OLDCOMMIT`, cwd = `repo`, no env.
- A1 runs this exactly as specified, and step 1 fails (see A1). Cases A2, B, C, D and F therefore add `git -c core.autocrlf=<same> update-index --refresh` with the same env between loading and step 1. A3 instead seeds the private index with a byte copy of the real index.

Each **State** block records the scratch files (name, size, SHA-256, count of CRLF pairs) and the SHA-256 of the private and the real index, compared with the previous snapshot. It then records, in this order: `git ls-files -s` for the private index (if present) and the real index, `git status --porcelain=v1 -uall` in scratch (with the real-index hash re-read after it, because status may rewrite the index), `git diff --name-only` in scratch, and `git rev-parse refs/heads/scratch-b`.

## A. Clean fast-forward

### A1. As specified: private index loaded with `git read-tree OLD`, then step 1 directly

Step 1 pins `-c core.autocrlf=false` because the system gitconfig sets core.autocrlf=true.

Fresh setup (same commands as in Setup) at `C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g`: OLD tree `8dd99e09a46e19a02e68f292c0120e7dc42c69c1`, OLDCOMMIT `d97d9c7d73f64e93afe61d024890489d9722f8c9`, NEW tree `dc9973975472c4e240433ce156dc1c4f28ff4c77`, NEWCOMMIT `81b2df4a539902fb86199aba0f489ce169be76ca`.

**State: before (scratch freshly checked out, no private index yet)**

```
scratch files (name, size, sha256, CRLF count):
del.txt        32 B  sha256=f9aa75468c487b5da854d309a29eba0cada31eb5b1ef89950269f3a1e156746d  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        30 B  sha256=b2073509debaf31b7e3ecb9698236dc4ec3662b921b992a08021024e399ff044  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: <absent>
real index    sha256: bd71e80b847bc968c9d9ea07ec4a235964fe786c45c23adbd07c03b5f17976f1
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
real index sha256 after that `git status`: `bd71e80b847bc968c9d9ea07ec4a235964fe786c45c23adbd07c03b5f17976f1`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
d97d9c7d73f64e93afe61d024890489d9722f8c9
--- stderr ---
```
```
$ git read-tree 8dd99e09a46e19a02e68f292c0120e7dc42c69c1
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\private.index
note: load the private index with OLD
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
**State: after loading the private index with OLD**

```
scratch files (name, size, sha256, CRLF count):
del.txt        32 B  sha256=f9aa75468c487b5da854d309a29eba0cada31eb5b1ef89950269f3a1e156746d  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        30 B  sha256=b2073509debaf31b7e3ecb9698236dc4ec3662b921b992a08021024e399ff044  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: 5dcdcf6119db493c191e313442d66ff7ba6de3fe54a49b7c4284ebc66035144d  (CHANGED since previous snapshot)
real index    sha256: bd71e80b847bc968c9d9ea07ec4a235964fe786c45c23adbd07c03b5f17976f1  (unchanged since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\private.index
note: private index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
real index sha256 after that `git status`: `bd71e80b847bc968c9d9ea07ec4a235964fe786c45c23adbd07c03b5f17976f1`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
d97d9c7d73f64e93afe61d024890489d9722f8c9
--- stderr ---
```
Step 1:
```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\private.index
exit: 128   (0.04s)
--- stdout ---
--- stderr ---
error: Entry 'del.txt' not uptodate. Cannot merge.
```
**State: after step 1**

```
scratch files (name, size, sha256, CRLF count):
del.txt        32 B  sha256=f9aa75468c487b5da854d309a29eba0cada31eb5b1ef89950269f3a1e156746d  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        30 B  sha256=b2073509debaf31b7e3ecb9698236dc4ec3662b921b992a08021024e399ff044  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: 5dcdcf6119db493c191e313442d66ff7ba6de3fe54a49b7c4284ebc66035144d  (unchanged since previous snapshot)
real index    sha256: bd71e80b847bc968c9d9ea07ec4a235964fe786c45c23adbd07c03b5f17976f1  (unchanged since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\private.index
note: private index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
real index sha256 after that `git status`: `bd71e80b847bc968c9d9ea07ec4a235964fe786c45c23adbd07c03b5f17976f1`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A1-kuxf_6_g\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
d97d9c7d73f64e93afe61d024890489d9722f8c9
--- stderr ---
```
Step 1 failed, so steps 2 and 3 were not run.

### A2. Same, with `git update-index --refresh` on the private index between loading and step 1

Fresh setup (same commands as in Setup) at `C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb`: OLD tree `8dd99e09a46e19a02e68f292c0120e7dc42c69c1`, OLDCOMMIT `7a22cfaa9632454ce9366b54042b230baeb7db78`, NEW tree `dc9973975472c4e240433ce156dc1c4f28ff4c77`, NEWCOMMIT `7312ffbafa3f207c69af6b36ebf19ce00888b523`.

**State: before**

```
scratch files (name, size, sha256, CRLF count):
del.txt        32 B  sha256=f9aa75468c487b5da854d309a29eba0cada31eb5b1ef89950269f3a1e156746d  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        30 B  sha256=b2073509debaf31b7e3ecb9698236dc4ec3662b921b992a08021024e399ff044  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: <absent>
real index    sha256: b9357d1f4e2071e34865a9ca6f6fc2ba56a65368fbf38fcabfba073fceeca066
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
real index sha256 after that `git status`: `b9357d1f4e2071e34865a9ca6f6fc2ba56a65368fbf38fcabfba073fceeca066`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\repo
env set: (none)
exit: 0   (0.03s)
--- stdout ---
7a22cfaa9632454ce9366b54042b230baeb7db78
--- stderr ---
```
```
$ git read-tree 8dd99e09a46e19a02e68f292c0120e7dc42c69c1
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\private.index
note: load the private index with OLD
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git -c core.autocrlf=false update-index --refresh
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\private.index
note: refresh the private index's stat data against scratch
exit: 0   (0.06s)
--- stdout ---
--- stderr ---
```
**State: after loading the private index with OLD and refreshing it**

```
scratch files (name, size, sha256, CRLF count):
del.txt        32 B  sha256=f9aa75468c487b5da854d309a29eba0cada31eb5b1ef89950269f3a1e156746d  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        30 B  sha256=b2073509debaf31b7e3ecb9698236dc4ec3662b921b992a08021024e399ff044  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: b9357d1f4e2071e34865a9ca6f6fc2ba56a65368fbf38fcabfba073fceeca066  (CHANGED since previous snapshot)
real index    sha256: b9357d1f4e2071e34865a9ca6f6fc2ba56a65368fbf38fcabfba073fceeca066  (unchanged since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\private.index
note: private index
exit: 0   (0.05s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\scratch
env set: (none)
note: real index
exit: 0   (0.05s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
real index sha256 after that `git status`: `b9357d1f4e2071e34865a9ca6f6fc2ba56a65368fbf38fcabfba073fceeca066`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
7a22cfaa9632454ce9366b54042b230baeb7db78
--- stderr ---
```
Step 1:
```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\private.index
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
**State: after step 1**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: e7202b0c9cd069ae54debec111ee727dc053f4b1da10fc41e623cc0cb91da523  (CHANGED since previous snapshot)
real index    sha256: b9357d1f4e2071e34865a9ca6f6fc2ba56a65368fbf38fcabfba073fceeca066  (unchanged since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\private.index
note: private index
exit: 0   (0.03s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\scratch
env set: (none)
note: real index
exit: 0   (0.03s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
 D del.txt
 M mod.txt
?? added.txt
--- stderr ---
```
real index sha256 after that `git status`: `b9357d1f4e2071e34865a9ca6f6fc2ba56a65368fbf38fcabfba073fceeca066`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
del.txt
mod.txt
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
7a22cfaa9632454ce9366b54042b230baeb7db78
--- stderr ---
```
Step 2 (rename):
```
python: os.replace(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\private.index', r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\repo\.git\worktrees\scratch\index')
# os.replace = MoveFileExW(..., MOVEFILE_REPLACE_EXISTING), the same call Go's os.Rename makes
result: ok (no exception)
```
**State: after step 2 (rename of the private index over the real index)**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: <absent>  (CHANGED since previous snapshot)
real index    sha256: e7202b0c9cd069ae54debec111ee727dc053f4b1da10fc41e623cc0cb91da523  (CHANGED since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
A  added.txt
D  del.txt
M  mod.txt
--- stderr ---
```
real index sha256 after that `git status`: `e7202b0c9cd069ae54debec111ee727dc053f4b1da10fc41e623cc0cb91da523`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\scratch
env set: (none)
exit: 0   (0.03s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\repo
env set: (none)
exit: 0   (0.03s)
--- stdout ---
7a22cfaa9632454ce9366b54042b230baeb7db78
--- stderr ---
```
Step 3:
```
$ git update-ref refs/heads/scratch-b 7312ffbafa3f207c69af6b36ebf19ce00888b523 7a22cfaa9632454ce9366b54042b230baeb7db78
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
**State: after step 3 (update-ref CAS)**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: <absent>  (unchanged since previous snapshot)
real index    sha256: e7202b0c9cd069ae54debec111ee727dc053f4b1da10fc41e623cc0cb91da523  (unchanged since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
real index sha256 after that `git status`: `e7202b0c9cd069ae54debec111ee727dc053f4b1da10fc41e623cc0cb91da523`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A2-d3uxejnb\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
7312ffbafa3f207c69af6b36ebf19ce00888b523
--- stderr ---
```
### A3. Extra variant: private index seeded by copying the real index (which carries stat data), no refresh

Fresh setup (same commands as in Setup) at `C:\Users\darius.jones\AppData\Local\Temp\t07probe-A3-6l2jnkhc`: OLD tree `8dd99e09a46e19a02e68f292c0120e7dc42c69c1`, OLDCOMMIT `f5d1b35a922ec347e5b34728c6b2376b054b518f`, NEW tree `dc9973975472c4e240433ce156dc1c4f28ff4c77`, NEWCOMMIT `a3d54f91bab55838d106b75f043b0e7bd801b768`.

```
python: shutil.copyfile(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-A3-6l2jnkhc\repo\.git\worktrees\scratch\index', r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-A3-6l2jnkhc\private.index')
result: ok
```
**State: before (private index = byte copy of the real index)**

```
scratch files (name, size, sha256, CRLF count):
del.txt        32 B  sha256=f9aa75468c487b5da854d309a29eba0cada31eb5b1ef89950269f3a1e156746d  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        30 B  sha256=b2073509debaf31b7e3ecb9698236dc4ec3662b921b992a08021024e399ff044  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: d6d027dcb60cd55f64148b3e4219dad4773edd38b38b6a8b8bf3d48229c8145f
real index    sha256: d6d027dcb60cd55f64148b3e4219dad4773edd38b38b6a8b8bf3d48229c8145f
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A3-6l2jnkhc
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A3-6l2jnkhc\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A3-6l2jnkhc\private.index
note: private index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A3-6l2jnkhc\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A3-6l2jnkhc\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
real index sha256 after that `git status`: `d6d027dcb60cd55f64148b3e4219dad4773edd38b38b6a8b8bf3d48229c8145f`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A3-6l2jnkhc\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A3-6l2jnkhc\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
f5d1b35a922ec347e5b34728c6b2376b054b518f
--- stderr ---
```
Step 1:
```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A3-6l2jnkhc
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A3-6l2jnkhc\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A3-6l2jnkhc\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A3-6l2jnkhc\private.index
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
**State: after step 1**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: 9163535f4ede463d1a949da4f91c79454a6e9cc91e484f405e8c25a17ff3f083  (CHANGED since previous snapshot)
real index    sha256: d6d027dcb60cd55f64148b3e4219dad4773edd38b38b6a8b8bf3d48229c8145f  (unchanged since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A3-6l2jnkhc
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A3-6l2jnkhc\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-A3-6l2jnkhc\private.index
note: private index
exit: 0   (0.04s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A3-6l2jnkhc\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A3-6l2jnkhc\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
 D del.txt
 M mod.txt
?? added.txt
--- stderr ---
```
real index sha256 after that `git status`: `d6d027dcb60cd55f64148b3e4219dad4773edd38b38b6a8b8bf3d48229c8145f`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A3-6l2jnkhc\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
del.txt
mod.txt
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A3-6l2jnkhc\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
f5d1b35a922ec347e5b34728c6b2376b054b518f
--- stderr ---
```
Step 2 (rename):
```
python: os.replace(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-A3-6l2jnkhc\private.index', r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-A3-6l2jnkhc\repo\.git\worktrees\scratch\index')
# os.replace = MoveFileExW(..., MOVEFILE_REPLACE_EXISTING), the same call Go's os.Rename makes
result: ok (no exception)
```
**State: after step 2 (rename of the private index over the real index)**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: <absent>  (CHANGED since previous snapshot)
real index    sha256: 9163535f4ede463d1a949da4f91c79454a6e9cc91e484f405e8c25a17ff3f083  (CHANGED since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A3-6l2jnkhc\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A3-6l2jnkhc\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
A  added.txt
D  del.txt
M  mod.txt
--- stderr ---
```
real index sha256 after that `git status`: `9163535f4ede463d1a949da4f91c79454a6e9cc91e484f405e8c25a17ff3f083`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A3-6l2jnkhc\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A3-6l2jnkhc\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
f5d1b35a922ec347e5b34728c6b2376b054b518f
--- stderr ---
```
Step 3:
```
$ git update-ref refs/heads/scratch-b a3d54f91bab55838d106b75f043b0e7bd801b768 f5d1b35a922ec347e5b34728c6b2376b054b518f
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A3-6l2jnkhc\repo
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
**State: after step 3 (update-ref CAS)**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: <absent>  (unchanged since previous snapshot)
real index    sha256: 9163535f4ede463d1a949da4f91c79454a6e9cc91e484f405e8c25a17ff3f083  (unchanged since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A3-6l2jnkhc\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A3-6l2jnkhc\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
real index sha256 after that `git status`: `9163535f4ede463d1a949da4f91c79454a6e9cc91e484f405e8c25a17ff3f083`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A3-6l2jnkhc\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-A3-6l2jnkhc\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
a3d54f91bab55838d106b75f043b0e7bd801b768
--- stderr ---
```

## B. CRLF (`-c core.autocrlf=true` on step 1)

Procedure A2 (load the private index with OLD, `update-index --refresh`), with `-c core.autocrlf=true` on the refresh and on step 1. The repo-local config stays core.autocrlf=false, so the plain status/diff commands in the snapshots run with false.

Fresh setup (same commands as in Setup) at `C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9`: OLD tree `8dd99e09a46e19a02e68f292c0120e7dc42c69c1`, OLDCOMMIT `6469e1c83353cc7608ba4f8e580d5a99414685c9`, NEW tree `dc9973975472c4e240433ce156dc1c4f28ff4c77`, NEWCOMMIT `2ec90ac92341a07f29af7c518007cb691b251e21`.

```
$ git read-tree 8dd99e09a46e19a02e68f292c0120e7dc42c69c1
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\private.index
note: load the private index with OLD
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git -c core.autocrlf=true update-index --refresh
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\private.index
note: refresh the private index's stat data against scratch
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
**State: before (after load + refresh)**

```
scratch files (name, size, sha256, CRLF count):
del.txt        32 B  sha256=f9aa75468c487b5da854d309a29eba0cada31eb5b1ef89950269f3a1e156746d  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        30 B  sha256=b2073509debaf31b7e3ecb9698236dc4ec3662b921b992a08021024e399ff044  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: 4a0e23d582d0b2e8f79057af44124d36442bc27ae4b98115580070ae2d41ec81
real index    sha256: 4a0e23d582d0b2e8f79057af44124d36442bc27ae4b98115580070ae2d41ec81
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\private.index
note: private index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
real index sha256 after that `git status`: `4a0e23d582d0b2e8f79057af44124d36442bc27ae4b98115580070ae2d41ec81`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
6469e1c83353cc7608ba4f8e580d5a99414685c9
--- stderr ---
```
Step 1:
```
$ git -c core.autocrlf=true read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\private.index
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
**State: after step 1**

```
scratch files (name, size, sha256, CRLF count):
added.txt      28 B  sha256=5e06da3fa45e09869383751adf31ff9602f72d3c4df0c1b51ac434dd81a71181  CRLF=2
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        44 B  sha256=d0c07cb2a4df39f84879aba9b46f78115c5ced1cd4cdd182a5188a5280fbef2a  CRLF=3
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: e0ada71ed12b9703a7d6717eda2de8c5dd65ccfc2750b2d9102ca112281ae1bc  (CHANGED since previous snapshot)
real index    sha256: 4a0e23d582d0b2e8f79057af44124d36442bc27ae4b98115580070ae2d41ec81  (unchanged since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\private.index
note: private index
exit: 0   (0.04s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
 D del.txt
 M mod.txt
?? added.txt
--- stderr ---
```
real index sha256 after that `git status`: `4a0e23d582d0b2e8f79057af44124d36442bc27ae4b98115580070ae2d41ec81`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
del.txt
mod.txt
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
6469e1c83353cc7608ba4f8e580d5a99414685c9
--- stderr ---
```
Step 2 (rename):
```
python: os.replace(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\private.index', r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\repo\.git\worktrees\scratch\index')
# os.replace = MoveFileExW(..., MOVEFILE_REPLACE_EXISTING), the same call Go's os.Rename makes
result: ok (no exception)
```
**State: after step 2 (rename of the private index over the real index)**

```
scratch files (name, size, sha256, CRLF count):
added.txt      28 B  sha256=5e06da3fa45e09869383751adf31ff9602f72d3c4df0c1b51ac434dd81a71181  CRLF=2
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        44 B  sha256=d0c07cb2a4df39f84879aba9b46f78115c5ced1cd4cdd182a5188a5280fbef2a  CRLF=3
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: <absent>  (CHANGED since previous snapshot)
real index    sha256: e0ada71ed12b9703a7d6717eda2de8c5dd65ccfc2750b2d9102ca112281ae1bc  (CHANGED since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
AM added.txt
D  del.txt
MM mod.txt
--- stderr ---
```
real index sha256 after that `git status`: `9b11a4fc1fe2ccae435f21bb4430608c25a639850b8563c65b5705bedaaa6192` (status rewrote the real index)

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
added.txt
mod.txt
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
6469e1c83353cc7608ba4f8e580d5a99414685c9
--- stderr ---
```
Step 3:
```
$ git update-ref refs/heads/scratch-b 2ec90ac92341a07f29af7c518007cb691b251e21 6469e1c83353cc7608ba4f8e580d5a99414685c9
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\repo
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
**State: after step 3 (update-ref CAS)**

```
scratch files (name, size, sha256, CRLF count):
added.txt      28 B  sha256=5e06da3fa45e09869383751adf31ff9602f72d3c4df0c1b51ac434dd81a71181  CRLF=2
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        44 B  sha256=d0c07cb2a4df39f84879aba9b46f78115c5ced1cd4cdd182a5188a5280fbef2a  CRLF=3
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: <absent>  (unchanged since previous snapshot)
real index    sha256: 9b11a4fc1fe2ccae435f21bb4430608c25a639850b8563c65b5705bedaaa6192  (unchanged since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
 M added.txt
 M mod.txt
--- stderr ---
```
real index sha256 after that `git status`: `9b11a4fc1fe2ccae435f21bb4430608c25a639850b8563c65b5705bedaaa6192`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
added.txt
mod.txt
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
2ec90ac92341a07f29af7c518007cb691b251e21
--- stderr ---
```
Raw bytes of the two files written by step 1:
```
python: open(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\scratch\added.txt','rb').read()
b'added line 1\r\nadded line 2\r\n'
```
```
python: open(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\scratch\mod.txt','rb').read()
b'mod CHANGED 1\r\nmod original 2\r\nmod added 3\r\n'
```
Extra comparison commands in scratch after step 3 (in this order):
```
$ git -c core.autocrlf=true status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
```
$ git -c core.autocrlf=true diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\scratch
env set: (none)
note: plain again, after the autocrlf=true status above
exit: 0   (0.05s)
--- stdout ---
 M added.txt
 M mod.txt
--- stderr ---
```
```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-B-mrdz2xz9\scratch
env set: (none)
exit: 0   (0.03s)
--- stdout ---
added.txt
mod.txt
--- stderr ---
```

## C. Untracked collision on `added.txt`

### C1. untracked `added.txt`, not ignored

Fresh setup (same commands as in Setup) at `C:\Users\darius.jones\AppData\Local\Temp\t07probe-C1-vldpmkp4`: OLD tree `8dd99e09a46e19a02e68f292c0120e7dc42c69c1`, OLDCOMMIT `e5a102cff400b596432244a2f16853857c589669`, NEW tree `dc9973975472c4e240433ce156dc1c4f28ff4c77`, NEWCOMMIT `b4715b6c7796b22d2c3bef77e024a18224b7eb77`.

```
$ git read-tree 8dd99e09a46e19a02e68f292c0120e7dc42c69c1
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C1-vldpmkp4
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C1-vldpmkp4\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C1-vldpmkp4\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C1-vldpmkp4\private.index
note: load the private index with OLD
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git -c core.autocrlf=false update-index --refresh
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C1-vldpmkp4
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C1-vldpmkp4\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C1-vldpmkp4\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C1-vldpmkp4\private.index
note: refresh the private index's stat data against scratch
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
python: open(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-C1-vldpmkp4\scratch\added.txt','wb').write(b'UNTRACKED different content\n')
```
**State: before step 1**

```
scratch files (name, size, sha256, CRLF count):
added.txt      28 B  sha256=ed1d65d75b55e8324d5f38aef2acfe9ef8f3fad993df4fb39d408412dbf9ffa3  CRLF=0
del.txt        32 B  sha256=f9aa75468c487b5da854d309a29eba0cada31eb5b1ef89950269f3a1e156746d  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        30 B  sha256=b2073509debaf31b7e3ecb9698236dc4ec3662b921b992a08021024e399ff044  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: df784b0655a67732f2deffa1e3116fad1e594e33fc357f83acd33232dac79619
real index    sha256: df784b0655a67732f2deffa1e3116fad1e594e33fc357f83acd33232dac79619
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C1-vldpmkp4
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C1-vldpmkp4\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C1-vldpmkp4\private.index
note: private index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C1-vldpmkp4\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C1-vldpmkp4\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
?? added.txt
--- stderr ---
```
real index sha256 after that `git status`: `df784b0655a67732f2deffa1e3116fad1e594e33fc357f83acd33232dac79619`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C1-vldpmkp4\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C1-vldpmkp4\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
e5a102cff400b596432244a2f16853857c589669
--- stderr ---
```
Step 1:
```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C1-vldpmkp4
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C1-vldpmkp4\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C1-vldpmkp4\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C1-vldpmkp4\private.index
exit: 128   (0.04s)
--- stdout ---
--- stderr ---
error: Untracked working tree file 'added.txt' would be overwritten by merge.
```
**State: after step 1**

```
scratch files (name, size, sha256, CRLF count):
added.txt      28 B  sha256=ed1d65d75b55e8324d5f38aef2acfe9ef8f3fad993df4fb39d408412dbf9ffa3  CRLF=0
del.txt        32 B  sha256=f9aa75468c487b5da854d309a29eba0cada31eb5b1ef89950269f3a1e156746d  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        30 B  sha256=b2073509debaf31b7e3ecb9698236dc4ec3662b921b992a08021024e399ff044  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: df784b0655a67732f2deffa1e3116fad1e594e33fc357f83acd33232dac79619  (unchanged since previous snapshot)
real index    sha256: df784b0655a67732f2deffa1e3116fad1e594e33fc357f83acd33232dac79619  (unchanged since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C1-vldpmkp4
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C1-vldpmkp4\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C1-vldpmkp4\private.index
note: private index
exit: 0   (0.03s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C1-vldpmkp4\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C1-vldpmkp4\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
?? added.txt
--- stderr ---
```
real index sha256 after that `git status`: `df784b0655a67732f2deffa1e3116fad1e594e33fc357f83acd33232dac79619`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C1-vldpmkp4\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C1-vldpmkp4\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
e5a102cff400b596432244a2f16853857c589669
--- stderr ---
```
Step 1 failed, so steps 2 and 3 were not run.

### C2. untracked `added.txt`, ignored through `repo/.git/info/exclude`

Fresh setup (same commands as in Setup) at `C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s`: OLD tree `8dd99e09a46e19a02e68f292c0120e7dc42c69c1`, OLDCOMMIT `a8c3619594752678f519468b112ea6bf7d4e5594`, NEW tree `dc9973975472c4e240433ce156dc1c4f28ff4c77`, NEWCOMMIT `7911c80cbf3c62943293dae41ee5e980b178a531`.

```
$ git read-tree 8dd99e09a46e19a02e68f292c0120e7dc42c69c1
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\private.index
note: load the private index with OLD
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git -c core.autocrlf=false update-index --refresh
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\private.index
note: refresh the private index's stat data against scratch
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
python: open(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\scratch\added.txt','wb').write(b'UNTRACKED different content\n')
```
```
python: append b'added.txt\n' to r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\repo\.git\info\exclude'
```
```
$ git check-ignore -v added.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
C:/Users/darius.jones/AppData/Local/Temp/t07probe-C2-z_7gfi8s/repo/.git/info/exclude:7:added.txt	added.txt
--- stderr ---
```
**State: before step 1**

```
scratch files (name, size, sha256, CRLF count):
added.txt      28 B  sha256=ed1d65d75b55e8324d5f38aef2acfe9ef8f3fad993df4fb39d408412dbf9ffa3  CRLF=0
del.txt        32 B  sha256=f9aa75468c487b5da854d309a29eba0cada31eb5b1ef89950269f3a1e156746d  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        30 B  sha256=b2073509debaf31b7e3ecb9698236dc4ec3662b921b992a08021024e399ff044  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: c80d52f2254437e04265ff8f72e43d62c2049d8f68f58ea845fb3039e53bdf33
real index    sha256: c80d52f2254437e04265ff8f72e43d62c2049d8f68f58ea845fb3039e53bdf33
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\private.index
note: private index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
real index sha256 after that `git status`: `c80d52f2254437e04265ff8f72e43d62c2049d8f68f58ea845fb3039e53bdf33`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
a8c3619594752678f519468b112ea6bf7d4e5594
--- stderr ---
```
Step 1:
```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\private.index
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
**State: after step 1**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: 4b398d886905c64e6e0b89fba75ff0707bc6520636b0955e18b85e00e3540b49  (CHANGED since previous snapshot)
real index    sha256: c80d52f2254437e04265ff8f72e43d62c2049d8f68f58ea845fb3039e53bdf33  (unchanged since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\private.index
note: private index
exit: 0   (0.04s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
 D del.txt
 M mod.txt
--- stderr ---
```
real index sha256 after that `git status`: `c80d52f2254437e04265ff8f72e43d62c2049d8f68f58ea845fb3039e53bdf33`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
del.txt
mod.txt
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
a8c3619594752678f519468b112ea6bf7d4e5594
--- stderr ---
```
Step 2 (rename):
```
python: os.replace(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\private.index', r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\repo\.git\worktrees\scratch\index')
# os.replace = MoveFileExW(..., MOVEFILE_REPLACE_EXISTING), the same call Go's os.Rename makes
result: ok (no exception)
```
**State: after step 2 (rename of the private index over the real index)**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: <absent>  (CHANGED since previous snapshot)
real index    sha256: 4b398d886905c64e6e0b89fba75ff0707bc6520636b0955e18b85e00e3540b49  (CHANGED since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
A  added.txt
D  del.txt
M  mod.txt
--- stderr ---
```
real index sha256 after that `git status`: `4b398d886905c64e6e0b89fba75ff0707bc6520636b0955e18b85e00e3540b49`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
a8c3619594752678f519468b112ea6bf7d4e5594
--- stderr ---
```
Step 3:
```
$ git update-ref refs/heads/scratch-b 7911c80cbf3c62943293dae41ee5e980b178a531 a8c3619594752678f519468b112ea6bf7d4e5594
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\repo
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
**State: after step 3 (update-ref CAS)**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: <absent>  (unchanged since previous snapshot)
real index    sha256: 4b398d886905c64e6e0b89fba75ff0707bc6520636b0955e18b85e00e3540b49  (unchanged since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
real index sha256 after that `git status`: `4b398d886905c64e6e0b89fba75ff0707bc6520636b0955e18b85e00e3540b49`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C2-z_7gfi8s\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
7911c80cbf3c62943293dae41ee5e980b178a531
--- stderr ---
```
### C3. extra: as C2, plus `--exclude-per-directory=.gitignore` on step 1

Fresh setup (same commands as in Setup) at `C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p`: OLD tree `8dd99e09a46e19a02e68f292c0120e7dc42c69c1`, OLDCOMMIT `fa8473b4807a29fb8aae992849d0a3f289278f27`, NEW tree `dc9973975472c4e240433ce156dc1c4f28ff4c77`, NEWCOMMIT `868b1f7a7fc11ef6a273f4cc9d1316033a7d92a3`.

```
$ git read-tree 8dd99e09a46e19a02e68f292c0120e7dc42c69c1
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\private.index
note: load the private index with OLD
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git -c core.autocrlf=false update-index --refresh
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\private.index
note: refresh the private index's stat data against scratch
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
python: open(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\scratch\added.txt','wb').write(b'UNTRACKED different content\n')
```
```
python: append b'added.txt\n' to r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\repo\.git\info\exclude'
```
```
$ git check-ignore -v added.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
C:/Users/darius.jones/AppData/Local/Temp/t07probe-C3-w5h9br3p/repo/.git/info/exclude:7:added.txt	added.txt
--- stderr ---
```
**State: before step 1**

```
scratch files (name, size, sha256, CRLF count):
added.txt      28 B  sha256=ed1d65d75b55e8324d5f38aef2acfe9ef8f3fad993df4fb39d408412dbf9ffa3  CRLF=0
del.txt        32 B  sha256=f9aa75468c487b5da854d309a29eba0cada31eb5b1ef89950269f3a1e156746d  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        30 B  sha256=b2073509debaf31b7e3ecb9698236dc4ec3662b921b992a08021024e399ff044  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: f24d1dd0f1b868d9077fbbc611f8cd42247a50c46afc77d8b678d32e2954702e
real index    sha256: f24d1dd0f1b868d9077fbbc611f8cd42247a50c46afc77d8b678d32e2954702e
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\private.index
note: private index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
real index sha256 after that `git status`: `f24d1dd0f1b868d9077fbbc611f8cd42247a50c46afc77d8b678d32e2954702e`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
fa8473b4807a29fb8aae992849d0a3f289278f27
--- stderr ---
```
Step 1:
```
$ git -c core.autocrlf=false read-tree -m -u --exclude-per-directory=.gitignore 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\private.index
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
**State: after step 1**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: 03d036f5af8b4bdde8ab370a86c7d973166c0d9b176807db3be6bfa63713ab19  (CHANGED since previous snapshot)
real index    sha256: f24d1dd0f1b868d9077fbbc611f8cd42247a50c46afc77d8b678d32e2954702e  (unchanged since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\private.index
note: private index
exit: 0   (0.04s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
 D del.txt
 M mod.txt
--- stderr ---
```
real index sha256 after that `git status`: `f24d1dd0f1b868d9077fbbc611f8cd42247a50c46afc77d8b678d32e2954702e`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
del.txt
mod.txt
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
fa8473b4807a29fb8aae992849d0a3f289278f27
--- stderr ---
```
Step 2 (rename):
```
python: os.replace(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\private.index', r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\repo\.git\worktrees\scratch\index')
# os.replace = MoveFileExW(..., MOVEFILE_REPLACE_EXISTING), the same call Go's os.Rename makes
result: ok (no exception)
```
**State: after step 2 (rename of the private index over the real index)**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: <absent>  (CHANGED since previous snapshot)
real index    sha256: 03d036f5af8b4bdde8ab370a86c7d973166c0d9b176807db3be6bfa63713ab19  (CHANGED since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
A  added.txt
D  del.txt
M  mod.txt
--- stderr ---
```
real index sha256 after that `git status`: `03d036f5af8b4bdde8ab370a86c7d973166c0d9b176807db3be6bfa63713ab19`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
fa8473b4807a29fb8aae992849d0a3f289278f27
--- stderr ---
```
Step 3:
```
$ git update-ref refs/heads/scratch-b 868b1f7a7fc11ef6a273f4cc9d1316033a7d92a3 fa8473b4807a29fb8aae992849d0a3f289278f27
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\repo
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
**State: after step 3 (update-ref CAS)**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: <absent>  (unchanged since previous snapshot)
real index    sha256: 03d036f5af8b4bdde8ab370a86c7d973166c0d9b176807db3be6bfa63713ab19  (unchanged since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
real index sha256 after that `git status`: `03d036f5af8b4bdde8ab370a86c7d973166c0d9b176807db3be6bfa63713ab19`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-C3-w5h9br3p\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
868b1f7a7fc11ef6a273f4cc9d1316033a7d92a3
--- stderr ---
```

## D. Locked tracked file (PowerShell `[System.IO.File]::Open($path,'Open','ReadWrite','None')`)

D1/D2 run load + refresh immediately after the setup checkout, so file mtimes and the private index's mtime fall in the same second. D3/D4 are identical except for a 2.5 s sleep after the setup checkout, before load + refresh, so the files are strictly older than the private index.

### D1. `mod.txt` held open with FileShare None (no settle)

Fresh setup (same commands as in Setup) at `C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0`: OLD tree `8dd99e09a46e19a02e68f292c0120e7dc42c69c1`, OLDCOMMIT `93532e4e229dfe0fd0a6939cd38368a666d9438b`, NEW tree `dc9973975472c4e240433ce156dc1c4f28ff4c77`, NEWCOMMIT `0fd5937d0050d1efb1ba5559b4527010021be474`.

```
$ git read-tree 8dd99e09a46e19a02e68f292c0120e7dc42c69c1
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\private.index
note: load the private index with OLD
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git -c core.autocrlf=false update-index --refresh
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\private.index
note: refresh the private index's stat data against scratch
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
```
python os.stat mtimes (before step 1):
.git           mtime_ns=1791878945154686400
del.txt        mtime_ns=1791878945203244300
keep.txt       mtime_ns=1791878945203244300
mod.txt        mtime_ns=1791878945204245700
notes.txt      mtime_ns=1791878945204681300
private.index  mtime_ns=1791878945729537500
```
```
$ git ls-files --debug
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\private.index
note: private index stat data
exit: 0   (0.04s)
--- stdout ---
del.txt
  ctime: 1791878945:202246000
  mtime: 1791878945:203244300
  dev: 0	ino: 0
  uid: 0	gid: 0
  size: 32	flags: 0
keep.txt
  ctime: 1791878945:203244300
  mtime: 1791878945:203244300
  dev: 0	ino: 0
  uid: 0	gid: 0
  size: 24	flags: 0
mod.txt
  ctime: 1791878945:203244300
  mtime: 1791878945:204245700
  dev: 0	ino: 0
  uid: 0	gid: 0
  size: 30	flags: 0
notes.txt
  ctime: 1791878945:204245700
  mtime: 1791878945:204681300
  dev: 0	ino: 0
  uid: 0	gid: 0
  size: 24	flags: 0
--- stderr ---
```
**State: before (after load + refresh, no handle)**

```
scratch files (name, size, sha256, CRLF count):
del.txt        32 B  sha256=f9aa75468c487b5da854d309a29eba0cada31eb5b1ef89950269f3a1e156746d  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        30 B  sha256=b2073509debaf31b7e3ecb9698236dc4ec3662b921b992a08021024e399ff044  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: a9886502648b464001dbb05c7c1b86c31cbfb7ec899789f5d001f50ec978eb34
real index    sha256: a9886502648b464001dbb05c7c1b86c31cbfb7ec899789f5d001f50ec978eb34
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\private.index
note: private index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
real index sha256 after that `git status`: `a9886502648b464001dbb05c7c1b86c31cbfb7ec899789f5d001f50ec978eb34`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
93532e4e229dfe0fd0a6939cd38368a666d9438b
--- stderr ---
```
```
background (kept running): powershell.exe -NoProfile -NonInteractive -Command "$path='C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\scratch\mod.txt'; $f=[System.IO.File]::Open($path,'Open','ReadWrite','None'); [Console]::Out.WriteLine('LOCKED'); [Console]::Out.Flush(); $null=[Console]::In.ReadLine(); $f.Close(); [Console]::Out.WriteLine('CLOSED'); [Console]::Out.Flush()"
first stdout line: b'LOCKED\r\n'  (pid 5168)
```
Step 1 while the handle is held:
```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\private.index
exit: 128   (0.05s)
--- stdout ---
--- stderr ---
error: Entry 'mod.txt' not uptodate. Cannot merge.
```
**State: after step 1, handle still held**

```
scratch files (name, size, sha256, CRLF count):
del.txt        32 B  sha256=f9aa75468c487b5da854d309a29eba0cada31eb5b1ef89950269f3a1e156746d  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        30 B  <unreadable: PermissionError: [Errno 13] Permission denied: 'C:\\Users\\darius.jones\\AppData\\Local\\Temp\\t07probe-D1-3txwzpn0\\scratch\\mod.txt'>
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: a9886502648b464001dbb05c7c1b86c31cbfb7ec899789f5d001f50ec978eb34  (unchanged since previous snapshot)
real index    sha256: a9886502648b464001dbb05c7c1b86c31cbfb7ec899789f5d001f50ec978eb34  (unchanged since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\private.index
note: private index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
 M mod.txt
--- stderr ---
```
real index sha256 after that `git status`: `c880434051a2ef4e6449541afb6d543047934c525d0f288288219e3ca36c3be6` (status rewrote the real index)

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
mod.txt
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
93532e4e229dfe0fd0a6939cd38368a666d9438b
--- stderr ---
```
```
background PowerShell released (newline written to its stdin)
exit: 0
--- remaining stdout ---
CLOSED

--- stderr ---
```
**State: after closing the handle**

```
scratch files (name, size, sha256, CRLF count):
del.txt        32 B  sha256=f9aa75468c487b5da854d309a29eba0cada31eb5b1ef89950269f3a1e156746d  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        30 B  sha256=b2073509debaf31b7e3ecb9698236dc4ec3662b921b992a08021024e399ff044  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: a9886502648b464001dbb05c7c1b86c31cbfb7ec899789f5d001f50ec978eb34  (unchanged since previous snapshot)
real index    sha256: c880434051a2ef4e6449541afb6d543047934c525d0f288288219e3ca36c3be6  (unchanged since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\private.index
note: private index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
real index sha256 after that `git status`: `a9886502648b464001dbb05c7c1b86c31cbfb7ec899789f5d001f50ec978eb34` (status rewrote the real index)

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
93532e4e229dfe0fd0a6939cd38368a666d9438b
--- stderr ---
```
Retry 1: step 1 again, same command, same private index:
```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\private.index
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
**State: after retry 1**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: 351c25bcfc6d80a4e3ef398caa8b8cc278a9768be030cec69589885687c344ea  (CHANGED since previous snapshot)
real index    sha256: a9886502648b464001dbb05c7c1b86c31cbfb7ec899789f5d001f50ec978eb34  (unchanged since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\private.index
note: private index
exit: 0   (0.04s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
 D del.txt
 M mod.txt
?? added.txt
--- stderr ---
```
real index sha256 after that `git status`: `a9886502648b464001dbb05c7c1b86c31cbfb7ec899789f5d001f50ec978eb34`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
del.txt
mod.txt
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
93532e4e229dfe0fd0a6939cd38368a666d9438b
--- stderr ---
```
Step 2 (rename):
```
python: os.replace(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\private.index', r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\repo\.git\worktrees\scratch\index')
# os.replace = MoveFileExW(..., MOVEFILE_REPLACE_EXISTING), the same call Go's os.Rename makes
result: ok (no exception)
```
**State: after step 2 (rename of the private index over the real index)**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: <absent>  (CHANGED since previous snapshot)
real index    sha256: 351c25bcfc6d80a4e3ef398caa8b8cc278a9768be030cec69589885687c344ea  (CHANGED since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
A  added.txt
D  del.txt
M  mod.txt
--- stderr ---
```
real index sha256 after that `git status`: `351c25bcfc6d80a4e3ef398caa8b8cc278a9768be030cec69589885687c344ea`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
93532e4e229dfe0fd0a6939cd38368a666d9438b
--- stderr ---
```
Step 3:
```
$ git update-ref refs/heads/scratch-b 0fd5937d0050d1efb1ba5559b4527010021be474 93532e4e229dfe0fd0a6939cd38368a666d9438b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
**State: after step 3 (update-ref CAS)**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: <absent>  (unchanged since previous snapshot)
real index    sha256: 351c25bcfc6d80a4e3ef398caa8b8cc278a9768be030cec69589885687c344ea  (unchanged since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
real index sha256 after that `git status`: `351c25bcfc6d80a4e3ef398caa8b8cc278a9768be030cec69589885687c344ea`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-3txwzpn0\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
0fd5937d0050d1efb1ba5559b4527010021be474
--- stderr ---
```
### D2. `del.txt` held open with FileShare None (no settle)

Fresh setup (same commands as in Setup) at `C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb`: OLD tree `8dd99e09a46e19a02e68f292c0120e7dc42c69c1`, OLDCOMMIT `a66f53c3c312be5884a5d7b5616ad8c956c0922a`, NEW tree `dc9973975472c4e240433ce156dc1c4f28ff4c77`, NEWCOMMIT `9914e250a40377b057c2d2eeb7b7c47d48a1c5af`.

```
$ git read-tree 8dd99e09a46e19a02e68f292c0120e7dc42c69c1
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\private.index
note: load the private index with OLD
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git -c core.autocrlf=false update-index --refresh
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\private.index
note: refresh the private index's stat data against scratch
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
python os.stat mtimes (before step 1):
.git           mtime_ns=1791878947716762500
del.txt        mtime_ns=1791878947763749100
keep.txt       mtime_ns=1791878947763749100
mod.txt        mtime_ns=1791878947764853300
notes.txt      mtime_ns=1791878947764853300
private.index  mtime_ns=1791878948291298300
```
```
$ git ls-files --debug
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\private.index
note: private index stat data
exit: 0   (0.03s)
--- stdout ---
del.txt
  ctime: 1791878947:763749100
  mtime: 1791878947:763749100
  dev: 0	ino: 0
  uid: 0	gid: 0
  size: 32	flags: 0
keep.txt
  ctime: 1791878947:763749100
  mtime: 1791878947:763749100
  dev: 0	ino: 0
  uid: 0	gid: 0
  size: 24	flags: 0
mod.txt
  ctime: 1791878947:764755500
  mtime: 1791878947:764853300
  dev: 0	ino: 0
  uid: 0	gid: 0
  size: 30	flags: 0
notes.txt
  ctime: 1791878947:764853300
  mtime: 1791878947:764853300
  dev: 0	ino: 0
  uid: 0	gid: 0
  size: 24	flags: 0
--- stderr ---
```
**State: before (after load + refresh, no handle)**

```
scratch files (name, size, sha256, CRLF count):
del.txt        32 B  sha256=f9aa75468c487b5da854d309a29eba0cada31eb5b1ef89950269f3a1e156746d  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        30 B  sha256=b2073509debaf31b7e3ecb9698236dc4ec3662b921b992a08021024e399ff044  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: d566c1c6a821b59274665b0366a352ed74a8cd6fc042dfa5a6f8f1974f9abb20
real index    sha256: d566c1c6a821b59274665b0366a352ed74a8cd6fc042dfa5a6f8f1974f9abb20
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\private.index
note: private index
exit: 0   (0.03s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\scratch
env set: (none)
note: real index
exit: 0   (0.03s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
real index sha256 after that `git status`: `d566c1c6a821b59274665b0366a352ed74a8cd6fc042dfa5a6f8f1974f9abb20`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
a66f53c3c312be5884a5d7b5616ad8c956c0922a
--- stderr ---
```
```
background (kept running): powershell.exe -NoProfile -NonInteractive -Command "$path='C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\scratch\del.txt'; $f=[System.IO.File]::Open($path,'Open','ReadWrite','None'); [Console]::Out.WriteLine('LOCKED'); [Console]::Out.Flush(); $null=[Console]::In.ReadLine(); $f.Close(); [Console]::Out.WriteLine('CLOSED'); [Console]::Out.Flush()"
first stdout line: b'LOCKED\r\n'  (pid 4204)
```
Step 1 while the handle is held:
```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\private.index
exit: 0   (0.17s)
--- stdout ---
--- stderr ---
warning: unable to unlink 'del.txt': Invalid argument
```
**State: after step 1, handle still held**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
del.txt        32 B  <unreadable: PermissionError: [Errno 13] Permission denied: 'C:\\Users\\darius.jones\\AppData\\Local\\Temp\\t07probe-D2-29mcf9xb\\scratch\\del.txt'>
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: 073ae505b0f84a7d0b7ff008f59eb57c0dc12c2ecb3c6cc0c4878e0da176471f  (CHANGED since previous snapshot)
real index    sha256: d566c1c6a821b59274665b0366a352ed74a8cd6fc042dfa5a6f8f1974f9abb20  (unchanged since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\private.index
note: private index
exit: 0   (0.05s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
 M mod.txt
?? added.txt
--- stderr ---
```
real index sha256 after that `git status`: `d566c1c6a821b59274665b0366a352ed74a8cd6fc042dfa5a6f8f1974f9abb20`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
mod.txt
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
a66f53c3c312be5884a5d7b5616ad8c956c0922a
--- stderr ---
```
```
background PowerShell released (newline written to its stdin)
exit: 0
--- remaining stdout ---
CLOSED

--- stderr ---
```
**State: after closing the handle**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
del.txt        32 B  sha256=f9aa75468c487b5da854d309a29eba0cada31eb5b1ef89950269f3a1e156746d  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: 073ae505b0f84a7d0b7ff008f59eb57c0dc12c2ecb3c6cc0c4878e0da176471f  (unchanged since previous snapshot)
real index    sha256: d566c1c6a821b59274665b0366a352ed74a8cd6fc042dfa5a6f8f1974f9abb20  (unchanged since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\private.index
note: private index
exit: 0   (0.04s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
 M mod.txt
?? added.txt
--- stderr ---
```
real index sha256 after that `git status`: `d566c1c6a821b59274665b0366a352ed74a8cd6fc042dfa5a6f8f1974f9abb20`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
mod.txt
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
a66f53c3c312be5884a5d7b5616ad8c956c0922a
--- stderr ---
```
Step 1 exited 0, so the procedure continued with steps 2 and 3:
Step 2 (rename):
```
python: os.replace(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\private.index', r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\repo\.git\worktrees\scratch\index')
# os.replace = MoveFileExW(..., MOVEFILE_REPLACE_EXISTING), the same call Go's os.Rename makes
result: ok (no exception)
```
**State: after step 2 (rename of the private index over the real index)**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
del.txt        32 B  sha256=f9aa75468c487b5da854d309a29eba0cada31eb5b1ef89950269f3a1e156746d  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: <absent>  (CHANGED since previous snapshot)
real index    sha256: 073ae505b0f84a7d0b7ff008f59eb57c0dc12c2ecb3c6cc0c4878e0da176471f  (CHANGED since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
A  added.txt
D  del.txt
M  mod.txt
?? del.txt
--- stderr ---
```
real index sha256 after that `git status`: `073ae505b0f84a7d0b7ff008f59eb57c0dc12c2ecb3c6cc0c4878e0da176471f`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
a66f53c3c312be5884a5d7b5616ad8c956c0922a
--- stderr ---
```
Step 3:
```
$ git update-ref refs/heads/scratch-b 9914e250a40377b057c2d2eeb7b7c47d48a1c5af a66f53c3c312be5884a5d7b5616ad8c956c0922a
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\repo
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
**State: after step 3 (update-ref CAS)**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
del.txt        32 B  sha256=f9aa75468c487b5da854d309a29eba0cada31eb5b1ef89950269f3a1e156746d  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: <absent>  (unchanged since previous snapshot)
real index    sha256: 073ae505b0f84a7d0b7ff008f59eb57c0dc12c2ecb3c6cc0c4878e0da176471f  (unchanged since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
?? del.txt
--- stderr ---
```
real index sha256 after that `git status`: `073ae505b0f84a7d0b7ff008f59eb57c0dc12c2ecb3c6cc0c4878e0da176471f`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-29mcf9xb\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
9914e250a40377b057c2d2eeb7b7c47d48a1c5af
--- stderr ---
```
### D3. `mod.txt` held open with FileShare None (2.5 s settle before load + refresh)

Fresh setup (same commands as in Setup) at `C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc`: OLD tree `8dd99e09a46e19a02e68f292c0120e7dc42c69c1`, OLDCOMMIT `138357beece18fbd84b7afc098129fe59be96969`, NEW tree `dc9973975472c4e240433ce156dc1c4f28ff4c77`, NEWCOMMIT `cc5b4d6ea9fb8bbdc94a2278c314de1c145ecd05`.

```
python: time.sleep(2.5)
```
```
$ git read-tree 8dd99e09a46e19a02e68f292c0120e7dc42c69c1
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\private.index
note: load the private index with OLD
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git -c core.autocrlf=false update-index --refresh
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\private.index
note: refresh the private index's stat data against scratch
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
python os.stat mtimes (before step 1):
.git           mtime_ns=1791878950128427600
del.txt        mtime_ns=1791878950181328400
keep.txt       mtime_ns=1791878950182557000
mod.txt        mtime_ns=1791878950182557000
notes.txt      mtime_ns=1791878950183750200
private.index  mtime_ns=1791878953210105400
```
```
$ git ls-files --debug
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\private.index
note: private index stat data
exit: 0   (0.04s)
--- stdout ---
del.txt
  ctime: 1791878950:181328400
  mtime: 1791878950:181328400
  dev: 0	ino: 0
  uid: 0	gid: 0
  size: 32	flags: 0
keep.txt
  ctime: 1791878950:182241100
  mtime: 1791878950:182557000
  dev: 0	ino: 0
  uid: 0	gid: 0
  size: 24	flags: 0
mod.txt
  ctime: 1791878950:182557000
  mtime: 1791878950:182557000
  dev: 0	ino: 0
  uid: 0	gid: 0
  size: 30	flags: 0
notes.txt
  ctime: 1791878950:183565100
  mtime: 1791878950:183750200
  dev: 0	ino: 0
  uid: 0	gid: 0
  size: 24	flags: 0
--- stderr ---
```
**State: before (after load + refresh, no handle)**

```
scratch files (name, size, sha256, CRLF count):
del.txt        32 B  sha256=f9aa75468c487b5da854d309a29eba0cada31eb5b1ef89950269f3a1e156746d  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        30 B  sha256=b2073509debaf31b7e3ecb9698236dc4ec3662b921b992a08021024e399ff044  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: 38a994ff07f482ce9097575f6abe24aaefe60b4926c578dbcd27745c3d15a30c
real index    sha256: 38a994ff07f482ce9097575f6abe24aaefe60b4926c578dbcd27745c3d15a30c
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\private.index
note: private index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
real index sha256 after that `git status`: `38a994ff07f482ce9097575f6abe24aaefe60b4926c578dbcd27745c3d15a30c`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
138357beece18fbd84b7afc098129fe59be96969
--- stderr ---
```
```
background (kept running): powershell.exe -NoProfile -NonInteractive -Command "$path='C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\scratch\mod.txt'; $f=[System.IO.File]::Open($path,'Open','ReadWrite','None'); [Console]::Out.WriteLine('LOCKED'); [Console]::Out.Flush(); $null=[Console]::In.ReadLine(); $f.Close(); [Console]::Out.WriteLine('CLOSED'); [Console]::Out.Flush()"
first stdout line: b'LOCKED\r\n'  (pid 10688)
```
Step 1 while the handle is held:
```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\private.index
exit: 128   (0.15s)
--- stdout ---
--- stderr ---
error: unable to unlink old 'mod.txt': Invalid argument
```
**State: after step 1, handle still held**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        30 B  <unreadable: PermissionError: [Errno 13] Permission denied: 'C:\\Users\\darius.jones\\AppData\\Local\\Temp\\t07probe-D3-fipasimc\\scratch\\mod.txt'>
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: 38a994ff07f482ce9097575f6abe24aaefe60b4926c578dbcd27745c3d15a30c  (unchanged since previous snapshot)
real index    sha256: 38a994ff07f482ce9097575f6abe24aaefe60b4926c578dbcd27745c3d15a30c  (unchanged since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\private.index
note: private index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
 D del.txt
?? added.txt
--- stderr ---
```
real index sha256 after that `git status`: `38a994ff07f482ce9097575f6abe24aaefe60b4926c578dbcd27745c3d15a30c`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
del.txt
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
138357beece18fbd84b7afc098129fe59be96969
--- stderr ---
```
```
background PowerShell released (newline written to its stdin)
exit: 0
--- remaining stdout ---
CLOSED

--- stderr ---
```
**State: after closing the handle**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        30 B  sha256=b2073509debaf31b7e3ecb9698236dc4ec3662b921b992a08021024e399ff044  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: 38a994ff07f482ce9097575f6abe24aaefe60b4926c578dbcd27745c3d15a30c  (unchanged since previous snapshot)
real index    sha256: 38a994ff07f482ce9097575f6abe24aaefe60b4926c578dbcd27745c3d15a30c  (unchanged since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\private.index
note: private index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
 D del.txt
?? added.txt
--- stderr ---
```
real index sha256 after that `git status`: `38a994ff07f482ce9097575f6abe24aaefe60b4926c578dbcd27745c3d15a30c`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
del.txt
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
138357beece18fbd84b7afc098129fe59be96969
--- stderr ---
```
Retry 1: step 1 again, same command, same private index:
```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\private.index
exit: 128   (0.04s)
--- stdout ---
--- stderr ---
error: Untracked working tree file 'added.txt' would be overwritten by merge.
```
**State: after retry 1**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        30 B  sha256=b2073509debaf31b7e3ecb9698236dc4ec3662b921b992a08021024e399ff044  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: 38a994ff07f482ce9097575f6abe24aaefe60b4926c578dbcd27745c3d15a30c  (unchanged since previous snapshot)
real index    sha256: 38a994ff07f482ce9097575f6abe24aaefe60b4926c578dbcd27745c3d15a30c  (unchanged since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\private.index
note: private index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
 D del.txt
?? added.txt
--- stderr ---
```
real index sha256 after that `git status`: `38a994ff07f482ce9097575f6abe24aaefe60b4926c578dbcd27745c3d15a30c`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
del.txt
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
138357beece18fbd84b7afc098129fe59be96969
--- stderr ---
```
Retry 2: reload the private index from OLD, refresh, step 1:
```
$ git read-tree 8dd99e09a46e19a02e68f292c0120e7dc42c69c1
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\private.index
note: load the private index with OLD
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git -c core.autocrlf=false update-index --refresh
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\private.index
note: refresh the private index's stat data against scratch
exit: 1   (0.04s)
--- stdout ---
del.txt: needs update
--- stderr ---
```
```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\private.index
exit: 128   (0.04s)
--- stdout ---
--- stderr ---
error: Untracked working tree file 'added.txt' would be overwritten by merge.
```
**State: after retry 2**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        30 B  sha256=b2073509debaf31b7e3ecb9698236dc4ec3662b921b992a08021024e399ff044  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: b0e44912135a71efbd4582397b9830bde46491ff211ce7cd7969bf82507cdec7  (CHANGED since previous snapshot)
real index    sha256: 38a994ff07f482ce9097575f6abe24aaefe60b4926c578dbcd27745c3d15a30c  (unchanged since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\private.index
note: private index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
 D del.txt
?? added.txt
--- stderr ---
```
real index sha256 after that `git status`: `38a994ff07f482ce9097575f6abe24aaefe60b4926c578dbcd27745c3d15a30c`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
del.txt
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
138357beece18fbd84b7afc098129fe59be96969
--- stderr ---
```
Retry 3 (extra): one-tree `read-tree --reset -u NEW` on the private index:
```
$ git -c core.autocrlf=false read-tree --reset -u dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\private.index
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
**State: after retry 3**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: 3061f4e40d0de9370894ff2c68b119c59e8fb4911eb96cd01c3d1ec5afe3b73f  (CHANGED since previous snapshot)
real index    sha256: 38a994ff07f482ce9097575f6abe24aaefe60b4926c578dbcd27745c3d15a30c  (unchanged since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\private.index
note: private index
exit: 0   (0.04s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
 D del.txt
 M mod.txt
?? added.txt
--- stderr ---
```
real index sha256 after that `git status`: `38a994ff07f482ce9097575f6abe24aaefe60b4926c578dbcd27745c3d15a30c`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
del.txt
mod.txt
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
138357beece18fbd84b7afc098129fe59be96969
--- stderr ---
```
Step 2 (rename):
```
python: os.replace(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\private.index', r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\repo\.git\worktrees\scratch\index')
# os.replace = MoveFileExW(..., MOVEFILE_REPLACE_EXISTING), the same call Go's os.Rename makes
result: ok (no exception)
```
**State: after step 2 (rename of the private index over the real index)**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: <absent>  (CHANGED since previous snapshot)
real index    sha256: 3061f4e40d0de9370894ff2c68b119c59e8fb4911eb96cd01c3d1ec5afe3b73f  (CHANGED since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
A  added.txt
D  del.txt
M  mod.txt
--- stderr ---
```
real index sha256 after that `git status`: `3061f4e40d0de9370894ff2c68b119c59e8fb4911eb96cd01c3d1ec5afe3b73f`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
138357beece18fbd84b7afc098129fe59be96969
--- stderr ---
```
Step 3:
```
$ git update-ref refs/heads/scratch-b cc5b4d6ea9fb8bbdc94a2278c314de1c145ecd05 138357beece18fbd84b7afc098129fe59be96969
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\repo
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
**State: after step 3 (update-ref CAS)**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: <absent>  (unchanged since previous snapshot)
real index    sha256: 3061f4e40d0de9370894ff2c68b119c59e8fb4911eb96cd01c3d1ec5afe3b73f  (unchanged since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
real index sha256 after that `git status`: `3061f4e40d0de9370894ff2c68b119c59e8fb4911eb96cd01c3d1ec5afe3b73f`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-fipasimc\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
cc5b4d6ea9fb8bbdc94a2278c314de1c145ecd05
--- stderr ---
```
### D4. `del.txt` held open with FileShare None (2.5 s settle before load + refresh)

Fresh setup (same commands as in Setup) at `C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d`: OLD tree `8dd99e09a46e19a02e68f292c0120e7dc42c69c1`, OLDCOMMIT `9d9c116d298b77329491f611c6d1b542622eb1de`, NEW tree `dc9973975472c4e240433ce156dc1c4f28ff4c77`, NEWCOMMIT `5b1c664c19bdef8250e0e8bebe50ba41359012db`.

```
python: time.sleep(2.5)
```
```
$ git read-tree 8dd99e09a46e19a02e68f292c0120e7dc42c69c1
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\private.index
note: load the private index with OLD
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git -c core.autocrlf=false update-index --refresh
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\private.index
note: refresh the private index's stat data against scratch
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
python os.stat mtimes (before step 1):
.git           mtime_ns=1791878955852590900
del.txt        mtime_ns=1791878955900841400
keep.txt       mtime_ns=1791878955901450100
mod.txt        mtime_ns=1791878955901450100
notes.txt      mtime_ns=1791878955903453500
private.index  mtime_ns=1791878958944502800
```
```
$ git ls-files --debug
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\private.index
note: private index stat data
exit: 0   (0.03s)
--- stdout ---
del.txt
  ctime: 1791878955:900454800
  mtime: 1791878955:900841400
  dev: 0	ino: 0
  uid: 0	gid: 0
  size: 32	flags: 0
keep.txt
  ctime: 1791878955:900892400
  mtime: 1791878955:901450100
  dev: 0	ino: 0
  uid: 0	gid: 0
  size: 24	flags: 0
mod.txt
  ctime: 1791878955:901450100
  mtime: 1791878955:901450100
  dev: 0	ino: 0
  uid: 0	gid: 0
  size: 30	flags: 0
notes.txt
  ctime: 1791878955:902450600
  mtime: 1791878955:903453500
  dev: 0	ino: 0
  uid: 0	gid: 0
  size: 24	flags: 0
--- stderr ---
```
**State: before (after load + refresh, no handle)**

```
scratch files (name, size, sha256, CRLF count):
del.txt        32 B  sha256=f9aa75468c487b5da854d309a29eba0cada31eb5b1ef89950269f3a1e156746d  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        30 B  sha256=b2073509debaf31b7e3ecb9698236dc4ec3662b921b992a08021024e399ff044  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: bd42665bb11d88c6f079d33ef672c3632b276901fc5f42008a3bd454d2e863c5
real index    sha256: bd42665bb11d88c6f079d33ef672c3632b276901fc5f42008a3bd454d2e863c5
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\private.index
note: private index
exit: 0   (0.03s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
real index sha256 after that `git status`: `bd42665bb11d88c6f079d33ef672c3632b276901fc5f42008a3bd454d2e863c5`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\repo
env set: (none)
exit: 0   (0.03s)
--- stdout ---
9d9c116d298b77329491f611c6d1b542622eb1de
--- stderr ---
```
```
background (kept running): powershell.exe -NoProfile -NonInteractive -Command "$path='C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\scratch\del.txt'; $f=[System.IO.File]::Open($path,'Open','ReadWrite','None'); [Console]::Out.WriteLine('LOCKED'); [Console]::Out.Flush(); $null=[Console]::In.ReadLine(); $f.Close(); [Console]::Out.WriteLine('CLOSED'); [Console]::Out.Flush()"
first stdout line: b'LOCKED\r\n'  (pid 9240)
```
Step 1 while the handle is held:
```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\private.index
exit: 0   (0.16s)
--- stdout ---
--- stderr ---
warning: unable to unlink 'del.txt': Invalid argument
```
**State: after step 1, handle still held**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
del.txt        32 B  <unreadable: PermissionError: [Errno 13] Permission denied: 'C:\\Users\\darius.jones\\AppData\\Local\\Temp\\t07probe-D4-wa1qx05d\\scratch\\del.txt'>
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: e55236ea26e21a05378011b9b7ee0997c8a997a813f39b3aab84bdb45fb6f0f8  (CHANGED since previous snapshot)
real index    sha256: bd42665bb11d88c6f079d33ef672c3632b276901fc5f42008a3bd454d2e863c5  (unchanged since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\private.index
note: private index
exit: 0   (0.03s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
 M mod.txt
?? added.txt
--- stderr ---
```
real index sha256 after that `git status`: `bd42665bb11d88c6f079d33ef672c3632b276901fc5f42008a3bd454d2e863c5`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
mod.txt
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\repo
env set: (none)
exit: 0   (0.03s)
--- stdout ---
9d9c116d298b77329491f611c6d1b542622eb1de
--- stderr ---
```
```
background PowerShell released (newline written to its stdin)
exit: 0
--- remaining stdout ---
CLOSED

--- stderr ---
```
**State: after closing the handle**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
del.txt        32 B  sha256=f9aa75468c487b5da854d309a29eba0cada31eb5b1ef89950269f3a1e156746d  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: e55236ea26e21a05378011b9b7ee0997c8a997a813f39b3aab84bdb45fb6f0f8  (unchanged since previous snapshot)
real index    sha256: bd42665bb11d88c6f079d33ef672c3632b276901fc5f42008a3bd454d2e863c5  (unchanged since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\private.index
note: private index
exit: 0   (0.03s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\scratch
env set: (none)
note: real index
exit: 0   (0.03s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
 M mod.txt
?? added.txt
--- stderr ---
```
real index sha256 after that `git status`: `bd42665bb11d88c6f079d33ef672c3632b276901fc5f42008a3bd454d2e863c5`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
mod.txt
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
9d9c116d298b77329491f611c6d1b542622eb1de
--- stderr ---
```
Step 1 exited 0, so the procedure continued with steps 2 and 3:
Step 2 (rename):
```
python: os.replace(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\private.index', r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\repo\.git\worktrees\scratch\index')
# os.replace = MoveFileExW(..., MOVEFILE_REPLACE_EXISTING), the same call Go's os.Rename makes
result: ok (no exception)
```
**State: after step 2 (rename of the private index over the real index)**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
del.txt        32 B  sha256=f9aa75468c487b5da854d309a29eba0cada31eb5b1ef89950269f3a1e156746d  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: <absent>  (CHANGED since previous snapshot)
real index    sha256: e55236ea26e21a05378011b9b7ee0997c8a997a813f39b3aab84bdb45fb6f0f8  (CHANGED since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
A  added.txt
D  del.txt
M  mod.txt
?? del.txt
--- stderr ---
```
real index sha256 after that `git status`: `e55236ea26e21a05378011b9b7ee0997c8a997a813f39b3aab84bdb45fb6f0f8`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\scratch
env set: (none)
exit: 0   (0.03s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\repo
env set: (none)
exit: 0   (0.03s)
--- stdout ---
9d9c116d298b77329491f611c6d1b542622eb1de
--- stderr ---
```
Step 3:
```
$ git update-ref refs/heads/scratch-b 5b1c664c19bdef8250e0e8bebe50ba41359012db 9d9c116d298b77329491f611c6d1b542622eb1de
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
**State: after step 3 (update-ref CAS)**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
del.txt        32 B  sha256=f9aa75468c487b5da854d309a29eba0cada31eb5b1ef89950269f3a1e156746d  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: <absent>  (unchanged since previous snapshot)
real index    sha256: e55236ea26e21a05378011b9b7ee0997c8a997a813f39b3aab84bdb45fb6f0f8  (unchanged since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
?? del.txt
--- stderr ---
```
real index sha256 after that `git status`: `e55236ea26e21a05378011b9b7ee0997c8a997a813f39b3aab84bdb45fb6f0f8`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-wa1qx05d\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
5b1c664c19bdef8250e0e8bebe50ba41359012db
--- stderr ---
```

### D repeats: the full case D run three more times (rep2–rep4), extracted records

Same harness and commands as above, each in fresh roots. This section shows only step 1 while the handle is held, the file list right after it, retry 1 when one happened, and the last `git status`.

**rep2 D1, step 1 while the handle is held**

```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-2u97qz1n
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-2u97qz1n\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-2u97qz1n\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-2u97qz1n\private.index
exit: 128   (0.05s)
--- stdout ---
--- stderr ---
error: Entry 'mod.txt' not uptodate. Cannot merge.
```
```
scratch files (name, size, sha256, CRLF count):
del.txt        32 B  sha256=f9aa75468c487b5da854d309a29eba0cada31eb5b1ef89950269f3a1e156746d  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        30 B  <unreadable: PermissionError: [Errno 13] Permission denied: 'C:\\Users\\darius.jones\\AppData\\Local\\Temp\\t07probe-D1-2u97qz1n\\scratch\\mod.txt'>
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```

rep2 D1, retry 1 after closing the handle:

```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-2u97qz1n
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-2u97qz1n\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-2u97qz1n\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-2u97qz1n\private.index
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```

rep2 D1, last `git status` of the run:

```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-2u97qz1n\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```

**rep2 D2, step 1 while the handle is held**

```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-6dr40w99
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-6dr40w99\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-6dr40w99\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-6dr40w99\private.index
exit: 0   (0.15s)
--- stdout ---
--- stderr ---
warning: unable to unlink 'del.txt': Invalid argument
```
```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
del.txt        32 B  <unreadable: PermissionError: [Errno 13] Permission denied: 'C:\\Users\\darius.jones\\AppData\\Local\\Temp\\t07probe-D2-6dr40w99\\scratch\\del.txt'>
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```

rep2 D2, last `git status` of the run:

```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-6dr40w99\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
?? del.txt
--- stderr ---
```

**rep2 D3, step 1 while the handle is held**

```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-vbjbxnnc
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-vbjbxnnc\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-vbjbxnnc\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-vbjbxnnc\private.index
exit: 128   (0.15s)
--- stdout ---
--- stderr ---
error: unable to unlink old 'mod.txt': Invalid argument
```
```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        30 B  <unreadable: PermissionError: [Errno 13] Permission denied: 'C:\\Users\\darius.jones\\AppData\\Local\\Temp\\t07probe-D3-vbjbxnnc\\scratch\\mod.txt'>
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```

rep2 D3, retry 1 after closing the handle:

```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-vbjbxnnc
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-vbjbxnnc\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-vbjbxnnc\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-vbjbxnnc\private.index
exit: 128   (0.04s)
--- stdout ---
--- stderr ---
error: Untracked working tree file 'added.txt' would be overwritten by merge.
```

rep2 D3, last `git status` of the run:

```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-vbjbxnnc\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```

**rep2 D4, step 1 while the handle is held**

```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-92fnz0fl
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-92fnz0fl\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-92fnz0fl\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-92fnz0fl\private.index
exit: 0   (0.15s)
--- stdout ---
--- stderr ---
warning: unable to unlink 'del.txt': Invalid argument
```
```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
del.txt        32 B  <unreadable: PermissionError: [Errno 13] Permission denied: 'C:\\Users\\darius.jones\\AppData\\Local\\Temp\\t07probe-D4-92fnz0fl\\scratch\\del.txt'>
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```

rep2 D4, last `git status` of the run:

```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-92fnz0fl\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
?? del.txt
--- stderr ---
```

**rep3 D1, step 1 while the handle is held**

```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-xi4bybtc
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-xi4bybtc\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-xi4bybtc\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-xi4bybtc\private.index
exit: 128   (0.16s)
--- stdout ---
--- stderr ---
error: unable to unlink old 'mod.txt': Invalid argument
```
```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        30 B  <unreadable: PermissionError: [Errno 13] Permission denied: 'C:\\Users\\darius.jones\\AppData\\Local\\Temp\\t07probe-D1-xi4bybtc\\scratch\\mod.txt'>
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```

rep3 D1, retry 1 after closing the handle:

```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-xi4bybtc
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-xi4bybtc\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-xi4bybtc\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-xi4bybtc\private.index
exit: 128   (0.04s)
--- stdout ---
--- stderr ---
error: Untracked working tree file 'added.txt' would be overwritten by merge.
```

rep3 D1, last `git status` of the run:

```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-xi4bybtc\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```

**rep3 D2, step 1 while the handle is held**

```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-fpjk4b5v
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-fpjk4b5v\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-fpjk4b5v\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-fpjk4b5v\private.index
exit: 0   (0.15s)
--- stdout ---
--- stderr ---
warning: unable to unlink 'del.txt': Invalid argument
```
```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
del.txt        32 B  <unreadable: PermissionError: [Errno 13] Permission denied: 'C:\\Users\\darius.jones\\AppData\\Local\\Temp\\t07probe-D2-fpjk4b5v\\scratch\\del.txt'>
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```

rep3 D2, last `git status` of the run:

```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-fpjk4b5v\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
?? del.txt
--- stderr ---
```

**rep3 D3, step 1 while the handle is held**

```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-mvu9atld
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-mvu9atld\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-mvu9atld\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-mvu9atld\private.index
exit: 128   (0.14s)
--- stdout ---
--- stderr ---
error: unable to unlink old 'mod.txt': Invalid argument
```
```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        30 B  <unreadable: PermissionError: [Errno 13] Permission denied: 'C:\\Users\\darius.jones\\AppData\\Local\\Temp\\t07probe-D3-mvu9atld\\scratch\\mod.txt'>
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```

rep3 D3, retry 1 after closing the handle:

```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-mvu9atld
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-mvu9atld\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-mvu9atld\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-mvu9atld\private.index
exit: 128   (0.05s)
--- stdout ---
--- stderr ---
error: Untracked working tree file 'added.txt' would be overwritten by merge.
```

rep3 D3, last `git status` of the run:

```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-mvu9atld\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```

**rep3 D4, step 1 while the handle is held**

```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-0e9cstq4
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-0e9cstq4\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-0e9cstq4\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-0e9cstq4\private.index
exit: 0   (0.16s)
--- stdout ---
--- stderr ---
warning: unable to unlink 'del.txt': Invalid argument
```
```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
del.txt        32 B  <unreadable: PermissionError: [Errno 13] Permission denied: 'C:\\Users\\darius.jones\\AppData\\Local\\Temp\\t07probe-D4-0e9cstq4\\scratch\\del.txt'>
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```

rep3 D4, last `git status` of the run:

```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-0e9cstq4\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
?? del.txt
--- stderr ---
```

**rep4 D1, step 1 while the handle is held**

```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-vhd_g9qo
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-vhd_g9qo\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-vhd_g9qo\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-vhd_g9qo\private.index
exit: 128   (0.04s)
--- stdout ---
--- stderr ---
error: Entry 'mod.txt' not uptodate. Cannot merge.
```
```
scratch files (name, size, sha256, CRLF count):
del.txt        32 B  sha256=f9aa75468c487b5da854d309a29eba0cada31eb5b1ef89950269f3a1e156746d  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        30 B  <unreadable: PermissionError: [Errno 13] Permission denied: 'C:\\Users\\darius.jones\\AppData\\Local\\Temp\\t07probe-D1-vhd_g9qo\\scratch\\mod.txt'>
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```

rep4 D1, retry 1 after closing the handle:

```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-vhd_g9qo
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-vhd_g9qo\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-vhd_g9qo\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-vhd_g9qo\private.index
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```

rep4 D1, last `git status` of the run:

```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D1-vhd_g9qo\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```

**rep4 D2, step 1 while the handle is held**

```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-m510bqy_
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-m510bqy_\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-m510bqy_\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-m510bqy_\private.index
exit: 0   (0.15s)
--- stdout ---
--- stderr ---
warning: unable to unlink 'del.txt': Invalid argument
```
```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
del.txt        32 B  <unreadable: PermissionError: [Errno 13] Permission denied: 'C:\\Users\\darius.jones\\AppData\\Local\\Temp\\t07probe-D2-m510bqy_\\scratch\\del.txt'>
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```

rep4 D2, last `git status` of the run:

```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D2-m510bqy_\scratch
env set: (none)
exit: 0   (0.03s)
--- stdout ---
?? del.txt
--- stderr ---
```

**rep4 D3, step 1 while the handle is held**

```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-d7z0d6th
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-d7z0d6th\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-d7z0d6th\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-d7z0d6th\private.index
exit: 128   (0.16s)
--- stdout ---
--- stderr ---
error: unable to unlink old 'mod.txt': Invalid argument
```
```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        30 B  <unreadable: PermissionError: [Errno 13] Permission denied: 'C:\\Users\\darius.jones\\AppData\\Local\\Temp\\t07probe-D3-d7z0d6th\\scratch\\mod.txt'>
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```

rep4 D3, retry 1 after closing the handle:

```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-d7z0d6th
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-d7z0d6th\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-d7z0d6th\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-d7z0d6th\private.index
exit: 128   (0.05s)
--- stdout ---
--- stderr ---
error: Untracked working tree file 'added.txt' would be overwritten by merge.
```

rep4 D3, last `git status` of the run:

```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D3-d7z0d6th\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```

**rep4 D4, step 1 while the handle is held**

```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-a2xsyy89
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-a2xsyy89\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-a2xsyy89\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-a2xsyy89\private.index
exit: 0   (0.16s)
--- stdout ---
--- stderr ---
warning: unable to unlink 'del.txt': Invalid argument
```
```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
del.txt        32 B  <unreadable: PermissionError: [Errno 13] Permission denied: 'C:\\Users\\darius.jones\\AppData\\Local\\Temp\\t07probe-D4-a2xsyy89\\scratch\\del.txt'>
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```

rep4 D4, last `git status` of the run:

```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-D4-a2xsyy89\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
?? del.txt
--- stderr ---
```

## E. Checked-out branch

Fresh setup (same commands as in Setup) at `C:\Users\darius.jones\AppData\Local\Temp\t07probe-E-b9bcn998`: OLD tree `8dd99e09a46e19a02e68f292c0120e7dc42c69c1`, OLDCOMMIT `b9fc43e7a7247d142e8a089f9777f21484c40dfb`, NEW tree `dc9973975472c4e240433ce156dc1c4f28ff4c77`, NEWCOMMIT `7fa8fec5014f9a67b2922f479617d7b897582b9a`.

```
$ git worktree list --porcelain
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-E-b9bcn998\repo
env set: (none)
exit: 0   (0.05s)
--- stdout ---
worktree C:/Users/darius.jones/AppData/Local/Temp/t07probe-E-b9bcn998/repo
HEAD b9fc43e7a7247d142e8a089f9777f21484c40dfb
branch refs/heads/main

worktree C:/Users/darius.jones/AppData/Local/Temp/t07probe-E-b9bcn998/scratch
HEAD b9fc43e7a7247d142e8a089f9777f21484c40dfb
branch refs/heads/scratch-b

--- stderr ---
```
**State: before**

```
scratch files (name, size, sha256, CRLF count):
del.txt        32 B  sha256=f9aa75468c487b5da854d309a29eba0cada31eb5b1ef89950269f3a1e156746d  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        30 B  sha256=b2073509debaf31b7e3ecb9698236dc4ec3662b921b992a08021024e399ff044  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: <absent>
real index    sha256: 083f6f7cc65ac6ffa002627b4e9ef2c58a05f6795d5e76d883de5fcd834db5e1
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-E-b9bcn998\scratch
env set: (none)
note: real index
exit: 0   (0.05s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-E-b9bcn998\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
real index sha256 after that `git status`: `083f6f7cc65ac6ffa002627b4e9ef2c58a05f6795d5e76d883de5fcd834db5e1`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-E-b9bcn998\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-E-b9bcn998\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
b9fc43e7a7247d142e8a089f9777f21484c40dfb
--- stderr ---
```
`git branch -f` while `scratch-b` is checked out in the linked worktree:
```
$ git branch -f scratch-b 7fa8fec5014f9a67b2922f479617d7b897582b9a
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-E-b9bcn998\repo
env set: (none)
exit: 128   (0.05s)
--- stdout ---
--- stderr ---
fatal: cannot force update the branch 'scratch-b' used by worktree at 'C:/Users/darius.jones/AppData/Local/Temp/t07probe-E-b9bcn998/scratch'
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-E-b9bcn998\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
b9fc43e7a7247d142e8a089f9777f21484c40dfb
--- stderr ---
```
`git update-ref` with a wrong old value (NEWCOMMIT given as old; the branch is at OLDCOMMIT):
```
$ git update-ref refs/heads/scratch-b 7fa8fec5014f9a67b2922f479617d7b897582b9a 7fa8fec5014f9a67b2922f479617d7b897582b9a
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-E-b9bcn998\repo
env set: (none)
exit: 128   (0.05s)
--- stdout ---
--- stderr ---
fatal: update_ref failed for ref 'refs/heads/scratch-b': cannot lock ref 'refs/heads/scratch-b': is at b9fc43e7a7247d142e8a089f9777f21484c40dfb but expected 7fa8fec5014f9a67b2922f479617d7b897582b9a
```
`git update-ref` with the all-zero old value (meaning 'must not exist yet'):
```
$ git update-ref refs/heads/scratch-b 7fa8fec5014f9a67b2922f479617d7b897582b9a 0000000000000000000000000000000000000000
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-E-b9bcn998\repo
env set: (none)
exit: 128   (0.04s)
--- stdout ---
--- stderr ---
fatal: update_ref failed for ref 'refs/heads/scratch-b': cannot lock ref 'refs/heads/scratch-b': reference already exists
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-E-b9bcn998\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
b9fc43e7a7247d142e8a089f9777f21484c40dfb
--- stderr ---
```
`git update-ref` with the correct old value (step 3):
```
$ git update-ref refs/heads/scratch-b 7fa8fec5014f9a67b2922f479617d7b897582b9a b9fc43e7a7247d142e8a089f9777f21484c40dfb
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-E-b9bcn998\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
**State: after a successful update-ref (no read-tree was run in this case)**

```
scratch files (name, size, sha256, CRLF count):
del.txt        32 B  sha256=f9aa75468c487b5da854d309a29eba0cada31eb5b1ef89950269f3a1e156746d  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        30 B  sha256=b2073509debaf31b7e3ecb9698236dc4ec3662b921b992a08021024e399ff044  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: <absent>  (unchanged since previous snapshot)
real index    sha256: 083f6f7cc65ac6ffa002627b4e9ef2c58a05f6795d5e76d883de5fcd834db5e1  (unchanged since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-E-b9bcn998\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-E-b9bcn998\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
D  added.txt
A  del.txt
M  mod.txt
--- stderr ---
```
real index sha256 after that `git status`: `083f6f7cc65ac6ffa002627b4e9ef2c58a05f6795d5e76d883de5fcd834db5e1`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-E-b9bcn998\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-E-b9bcn998\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
7fa8fec5014f9a67b2922f479617d7b897582b9a
--- stderr ---
```
Stale CAS attempts with old value OLDCOMMIT (the branch is now at NEWCOMMIT):
```
$ git update-ref refs/heads/scratch-b 7fa8fec5014f9a67b2922f479617d7b897582b9a b9fc43e7a7247d142e8a089f9777f21484c40dfb
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-E-b9bcn998\repo
env set: (none)
exit: 128   (0.04s)
--- stdout ---
--- stderr ---
fatal: update_ref failed for ref 'refs/heads/scratch-b': cannot lock ref 'refs/heads/scratch-b': is at 7fa8fec5014f9a67b2922f479617d7b897582b9a but expected b9fc43e7a7247d142e8a089f9777f21484c40dfb
```
```
$ git update-ref refs/heads/scratch-b b9fc43e7a7247d142e8a089f9777f21484c40dfb b9fc43e7a7247d142e8a089f9777f21484c40dfb
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-E-b9bcn998\repo
env set: (none)
exit: 128   (0.04s)
--- stdout ---
--- stderr ---
fatal: update_ref failed for ref 'refs/heads/scratch-b': cannot lock ref 'refs/heads/scratch-b': is at 7fa8fec5014f9a67b2922f479617d7b897582b9a but expected b9fc43e7a7247d142e8a089f9777f21484c40dfb
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-E-b9bcn998\repo
env set: (none)
exit: 0   (0.03s)
--- stdout ---
7fa8fec5014f9a67b2922f479617d7b897582b9a
--- stderr ---
```
Extra: a CAS run with `GIT_DIR` = the linked worktree's gitdir instead of from the main repository (moves NEW back to OLD):
```
$ git update-ref refs/heads/scratch-b b9fc43e7a7247d142e8a089f9777f21484c40dfb 7fa8fec5014f9a67b2922f479617d7b897582b9a
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-E-b9bcn998
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-E-b9bcn998\repo\.git\worktrees\scratch
exit: 0   (0.03s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-E-b9bcn998\repo
env set: (none)
exit: 0   (0.03s)
--- stdout ---
b9fc43e7a7247d142e8a089f9777f21484c40dfb
--- stderr ---
```
```
$ git reflog show "--format=%H %gs" refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-E-b9bcn998\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
b9fc43e7a7247d142e8a089f9777f21484c40dfb 
7fa8fec5014f9a67b2922f479617d7b897582b9a 
b9fc43e7a7247d142e8a089f9777f21484c40dfb branch: Created from main
--- stderr ---
```

## F. Index-lock contention

### F1. `index.lock` present, step 2 by copy

Fresh setup (same commands as in Setup) at `C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w`: OLD tree `8dd99e09a46e19a02e68f292c0120e7dc42c69c1`, OLDCOMMIT `2f81cca0fd534c97446504d3533d96750f0a1b51`, NEW tree `dc9973975472c4e240433ce156dc1c4f28ff4c77`, NEWCOMMIT `708febaf99a51f1aa42e21236d5bcbc2e73ae52c`.

```
$ git read-tree 8dd99e09a46e19a02e68f292c0120e7dc42c69c1
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\private.index
note: load the private index with OLD
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git -c core.autocrlf=false update-index --refresh
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\private.index
note: refresh the private index's stat data against scratch
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
Step 1:
```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\private.index
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
python: open(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\repo\.git\worktrees\scratch\index.lock','wb').close()   # empty index.lock, created after step 1 and before step 2
```
**State: after step 1, index.lock created**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: deb84828f07c537b26e96d17d48348d3a5145f1e313d5e33610a52ab2a4bc260
real index    sha256: 2d562810517e4f829628387089ca4c648e178847a226bb7abd1e15ef95669bbd
index.lock exists: True
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\private.index
note: private index
exit: 0   (0.03s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\scratch
env set: (none)
note: real index
exit: 0   (0.03s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
 D del.txt
 M mod.txt
?? added.txt
--- stderr ---
```
real index sha256 after that `git status`: `2d562810517e4f829628387089ca4c648e178847a226bb7abd1e15ef95669bbd`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
del.txt
mod.txt
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\repo
env set: (none)
exit: 0   (0.03s)
--- stdout ---
2f81cca0fd534c97446504d3533d96750f0a1b51
--- stderr ---
```
Step 2 (copy) with index.lock present:
```
python: shutil.copyfile(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\private.index', r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\repo\.git\worktrees\scratch\index')
# opens the destination for write (truncate) and copies the bytes
result: ok (no exception)
```
`git status` in scratch with index.lock present:
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
A  added.txt
D  del.txt
M  mod.txt
--- stderr ---
```
An index writer for comparison, `git update-index --refresh` in scratch:
```
$ git update-index --refresh
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
Step 3 with index.lock present:
```
$ git update-ref refs/heads/scratch-b 708febaf99a51f1aa42e21236d5bcbc2e73ae52c 2f81cca0fd534c97446504d3533d96750f0a1b51
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\repo
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
**State: after steps 2 and 3, index.lock still present**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: deb84828f07c537b26e96d17d48348d3a5145f1e313d5e33610a52ab2a4bc260  (unchanged since previous snapshot)
real index    sha256: deb84828f07c537b26e96d17d48348d3a5145f1e313d5e33610a52ab2a4bc260  (CHANGED since previous snapshot)
index.lock exists: True
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\private.index
note: private index
exit: 0   (0.04s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
real index sha256 after that `git status`: `deb84828f07c537b26e96d17d48348d3a5145f1e313d5e33610a52ab2a4bc260`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
708febaf99a51f1aa42e21236d5bcbc2e73ae52c
--- stderr ---
```
```
python: os.remove(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\repo\.git\worktrees\scratch\index.lock')
```
```
$ git update-index --refresh
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
**State: after removing index.lock**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: deb84828f07c537b26e96d17d48348d3a5145f1e313d5e33610a52ab2a4bc260  (unchanged since previous snapshot)
real index    sha256: deb84828f07c537b26e96d17d48348d3a5145f1e313d5e33610a52ab2a4bc260  (unchanged since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\private.index
note: private index
exit: 0   (0.04s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
real index sha256 after that `git status`: `deb84828f07c537b26e96d17d48348d3a5145f1e313d5e33610a52ab2a4bc260`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-1t2uog_w\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
708febaf99a51f1aa42e21236d5bcbc2e73ae52c
--- stderr ---
```
### F2. `index.lock` present, step 2 by rename

Fresh setup (same commands as in Setup) at `C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt`: OLD tree `8dd99e09a46e19a02e68f292c0120e7dc42c69c1`, OLDCOMMIT `f8ec5779b8e4f59197151582d1f0ae01f8c9a8a1`, NEW tree `dc9973975472c4e240433ce156dc1c4f28ff4c77`, NEWCOMMIT `f33c78a1f834b4f60fc82a2ed7ae5f3678226c29`.

```
$ git read-tree 8dd99e09a46e19a02e68f292c0120e7dc42c69c1
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt\private.index
note: load the private index with OLD
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git -c core.autocrlf=false update-index --refresh
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt\private.index
note: refresh the private index's stat data against scratch
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
Step 1:
```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt\private.index
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
```
python: open(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt\repo\.git\worktrees\scratch\index.lock','wb').close()   # empty index.lock, created after step 1 and before step 2
```
**State: after step 1, index.lock created**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: f6c3e7edceb37ef877b2ea098fcc1aab93b1e9635bca51af70812d53bca224fa
real index    sha256: 4fbf03bf759effcbfeb41b1efe04e829fe3225f69bab5a34b568d111f7f955aa
index.lock exists: True
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt\private.index
note: private index
exit: 0   (0.04s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 47eba6ae78733dfc7735a1fc610aabcb2d4dee13 0	del.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
 D del.txt
 M mod.txt
?? added.txt
--- stderr ---
```
real index sha256 after that `git status`: `4fbf03bf759effcbfeb41b1efe04e829fe3225f69bab5a34b568d111f7f955aa`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
del.txt
mod.txt
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
f8ec5779b8e4f59197151582d1f0ae01f8c9a8a1
--- stderr ---
```
Step 2 (rename) with index.lock present:
```
python: os.replace(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt\private.index', r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt\repo\.git\worktrees\scratch\index')
# os.replace = MoveFileExW(..., MOVEFILE_REPLACE_EXISTING), the same call Go's os.Rename makes
result: ok (no exception)
```
`git status` in scratch with index.lock present:
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
A  added.txt
D  del.txt
M  mod.txt
--- stderr ---
```
An index writer for comparison, `git update-index --refresh` in scratch:
```
$ git update-index --refresh
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt\scratch
env set: (none)
exit: 128   (0.04s)
--- stdout ---
--- stderr ---
fatal: Unable to create 'C:/Users/darius.jones/AppData/Local/Temp/t07probe-F2-_ur5lhgt/repo/.git/worktrees/scratch/index.lock': File exists.

Another git process seems to be running in this repository, or the lock file may be stale
```
Step 3 with index.lock present:
```
$ git update-ref refs/heads/scratch-b f33c78a1f834b4f60fc82a2ed7ae5f3678226c29 f8ec5779b8e4f59197151582d1f0ae01f8c9a8a1
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
**State: after steps 2 and 3, index.lock still present**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: <absent>  (CHANGED since previous snapshot)
real index    sha256: f6c3e7edceb37ef877b2ea098fcc1aab93b1e9635bca51af70812d53bca224fa  (CHANGED since previous snapshot)
index.lock exists: True
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
real index sha256 after that `git status`: `f6c3e7edceb37ef877b2ea098fcc1aab93b1e9635bca51af70812d53bca224fa`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
f33c78a1f834b4f60fc82a2ed7ae5f3678226c29
--- stderr ---
```
```
python: os.remove(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt\repo\.git\worktrees\scratch\index.lock')
```
```
$ git update-index --refresh
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
**State: after removing index.lock**

```
scratch files (name, size, sha256, CRLF count):
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index sha256: <absent>  (unchanged since previous snapshot)
real index    sha256: f6c3e7edceb37ef877b2ea098fcc1aab93b1e9635bca51af70812d53bca224fa  (unchanged since previous snapshot)
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt\scratch
env set: (none)
note: real index
exit: 0   (0.04s)
--- stdout ---
100644 51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 0	added.txt
100644 e47123eb620849ff662dd91bc59352673e2bf5ff 0	keep.txt
100644 10ac2baa0965e7ddc30b97c5824d8a8270b519e5 0	mod.txt
100644 b71e3c44a7e6b532edca3107264069c4479f3623 0	notes.txt
--- stderr ---
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
real index sha256 after that `git status`: `f6c3e7edceb37ef877b2ea098fcc1aab93b1e9635bca51af70812d53bca224fa`

```
$ git diff --name-only
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-_ur5lhgt\repo
env set: (none)
exit: 0   (0.03s)
--- stdout ---
f33c78a1f834b4f60fc82a2ed7ae5f3678226c29
--- stderr ---
```

### F repeats: the full case F run three more times (rep2–rep4), extracted records

This section shows only the `git status`, the `git update-index --refresh` and step 3 run while `index.lock` was present.

**rep2 F1**

```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-92cgwq97\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
A  added.txt
D  del.txt
M  mod.txt
--- stderr ---
```
An index writer for comparison, `git update-index --refresh` in scratch:
```
$ git update-index --refresh
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-92cgwq97\scratch
env set: (none)
exit: 128   (0.03s)
--- stdout ---
--- stderr ---
fatal: Unable to create 'C:/Users/darius.jones/AppData/Local/Temp/t07probe-F1-92cgwq97/repo/.git/worktrees/scratch/index.lock': File exists.

Another git process seems to be running in this repository, or the lock file may be stale
```

Step 3:
```
$ git update-ref refs/heads/scratch-b b6c14499f9968f9b5b86f6d8a30bbab973c23260 83281d42078b79beabe02d65b8bcc5027da3f72b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-92cgwq97\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```

**rep2 F2**

```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-7f65s0p_\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
A  added.txt
D  del.txt
M  mod.txt
--- stderr ---
```
An index writer for comparison, `git update-index --refresh` in scratch:
```
$ git update-index --refresh
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-7f65s0p_\scratch
env set: (none)
exit: 128   (0.03s)
--- stdout ---
--- stderr ---
fatal: Unable to create 'C:/Users/darius.jones/AppData/Local/Temp/t07probe-F2-7f65s0p_/repo/.git/worktrees/scratch/index.lock': File exists.

Another git process seems to be running in this repository, or the lock file may be stale
```

Step 3:
```
$ git update-ref refs/heads/scratch-b 816a47b3918fbc0f169769249986cce46ffca47c 8e200855d089813523aac8dd91324ff2410b565e
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-7f65s0p_\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```

**rep3 F1**

```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-kvocja0b\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
A  added.txt
D  del.txt
M  mod.txt
--- stderr ---
```
An index writer for comparison, `git update-index --refresh` in scratch:
```
$ git update-index --refresh
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-kvocja0b\scratch
env set: (none)
exit: 128   (0.04s)
--- stdout ---
--- stderr ---
fatal: Unable to create 'C:/Users/darius.jones/AppData/Local/Temp/t07probe-F1-kvocja0b/repo/.git/worktrees/scratch/index.lock': File exists.

Another git process seems to be running in this repository, or the lock file may be stale
```

Step 3:
```
$ git update-ref refs/heads/scratch-b 4314cc4ca34b082be00cfbf5c2cedf6ad161f930 c37d8e88baaee66c6b71d6d1ee911854018b51e3
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-kvocja0b\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```

**rep3 F2**

```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-t46a78ep\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
A  added.txt
D  del.txt
M  mod.txt
--- stderr ---
```
An index writer for comparison, `git update-index --refresh` in scratch:
```
$ git update-index --refresh
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-t46a78ep\scratch
env set: (none)
exit: 128   (0.03s)
--- stdout ---
--- stderr ---
fatal: Unable to create 'C:/Users/darius.jones/AppData/Local/Temp/t07probe-F2-t46a78ep/repo/.git/worktrees/scratch/index.lock': File exists.

Another git process seems to be running in this repository, or the lock file may be stale
```

Step 3:
```
$ git update-ref refs/heads/scratch-b 36261df9adb93a0f5f87d472f08619fb0adf5c40 75821fe86ce17c2d78cbf6dc916ab010097fb2fd
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-t46a78ep\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```

**rep4 F1**

```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-7eyfbsnl\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
A  added.txt
D  del.txt
M  mod.txt
--- stderr ---
```
An index writer for comparison, `git update-index --refresh` in scratch:
```
$ git update-index --refresh
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-7eyfbsnl\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```

Step 3:
```
$ git update-ref refs/heads/scratch-b e1d5f75e8d0923e3a7957f73444d84049f8aea8e b550f51bbf6476154cc564cdc788dd7c0350b791
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F1-7eyfbsnl\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```

**rep4 F2**

```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-whpnbib3\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
A  added.txt
D  del.txt
M  mod.txt
--- stderr ---
```
An index writer for comparison, `git update-index --refresh` in scratch:
```
$ git update-index --refresh
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-whpnbib3\scratch
env set: (none)
exit: 128   (0.03s)
--- stdout ---
--- stderr ---
fatal: Unable to create 'C:/Users/darius.jones/AppData/Local/Temp/t07probe-F2-whpnbib3/repo/.git/worktrees/scratch/index.lock': File exists.

Another git process seems to be running in this repository, or the lock file may be stale
```

Step 3:
```
$ git update-ref refs/heads/scratch-b 9eb0f5a840464114d1a0ea728974c8d77d79bf4a 882d49edb49b5578d87c9fde34699149b1503a95
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-F2-whpnbib3\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```

## Observations

Runs: the main run of every case, plus rep2–rep4 of D and F. That makes 4 runs each of D1–D4 and of F1–F2.

1. **Step 1 as specified fails (A1).** The private index was loaded with `git read-tree OLD` and nothing else. `read-tree -m -u OLD NEW` then exited 128 with `error: Entry 'del.txt' not uptodate. Cannot merge.` No scratch file, neither index and not the branch changed. Two fixes each made step 1 exit 0:
   - A2: `git update-index --refresh` on the private index, with the same env, before step 1;
   - A3: seeding the private index with a byte copy of the real index.
   [INFERENCE] `read-tree OLD` writes entries with no stat data, and `read-tree -m` does not refresh them itself.
2. **The refreshed private index matched the real index byte for byte.** In A2, B, C, D and F, the private index after load + refresh had the same SHA-256 as the real index, which held the same tree.
3. **Clean fast-forward (A2, A3).** Step 1 put NEW into scratch:
   - `added.txt` written (26 B);
   - `mod.txt` replaced (41 B);
   - `del.txt` removed.

   The private index then listed the NEW blobs, while the real index and the branch were unchanged. Status in each window:
   - between steps 1 and 2, `git status` showed ` D del.txt`, ` M mod.txt` and `?? added.txt`;
   - between steps 2 and 3, it showed `A  added.txt`, `D  del.txt` and `M  mod.txt`, with an empty `git diff --name-only`;
   - after step 3, status and diff were empty and the branch was at NEWCOMMIT.

   Step 2 used rename (`os.replace`). It raised nothing and left `private.index` absent.
4. **CRLF (B).** With `-c core.autocrlf=true` on step 1, the written `added.txt` **has CRLF**. Its bytes are `b'added line 1\r\nadded line 2\r\n'` (28 B, 2 CRLF). `mod.txt` became `b'mod CHANGED 1\r\nmod original 2\r\nmod added 3\r\n'` (3 CRLF). The index blob ids are the same LF blobs as in A (`51fa1036…`, `10ac2baa…`). Under the repo-local `core.autocrlf=false`, plain `git status` after step 3 showed ` M added.txt` and ` M mod.txt`, and `git diff --name-only` listed both. With `-c core.autocrlf=true`, status and diff were empty. After step 2, plain status showed `AM added.txt`, `D  del.txt` and `MM mod.txt`. In that snapshot `git status` rewrote the real index.
5. **Untracked collision, not ignored (C1).** Step 1 refused with exit 128 and `error: Untracked working tree file 'added.txt' would be overwritten by merge.` No file changed: `mod.txt`, `del.txt` and the untracked `added.txt` kept their sizes and SHA-256. The private index, the real index and the branch were unchanged.
6. **Untracked collision, ignored through `.git/info/exclude` (C2).** `check-ignore -v` reported `.../repo/.git/info/exclude:7:added.txt`. Step 1 then **exited 0 with empty stdout and stderr and overwrote the ignored file**: `added.txt` went from 28 B (`ed1d65d7…`) to the NEW content, 26 B (`04d14601…`). The rest of the update and steps 2 and 3 completed, and the final status was clean. C3, which adds `--exclude-per-directory=.gitignore`, behaved identically.
7. **Modified file held open, files strictly older than the private index (D3, 4/4 runs).** Step 1 exited 128 with `error: unable to unlink old 'mod.txt': Invalid argument` after 0.14–0.16 s. There was no prompt and no hang, with stdin = DEVNULL. **This is a partial mutation:**
   - `del.txt` was already deleted and `added.txt` already written;
   - `mod.txt` kept its OLD content;
   - the private index was unchanged (same SHA-256, still OLD), as were the real index and the branch;
   - `git status` showed ` D del.txt` and `?? added.txt`.

   After the handle closed:
   - retry 1 (same command, same private index) exited 128 with `Untracked working tree file 'added.txt' would be overwritten by merge.`;
   - in the main run, retry 2 (reload OLD, refresh, step 1) also failed. The refresh exited 1 with `del.txt: needs update`, and step 1 exited 128 with the same untracked error;
   - the extra one-tree `read-tree --reset -u NEW` exited 0 and brought scratch to NEW. Steps 2 and 3 then succeeded and the final status was clean.
8. **Modified file held open, no settle (D1).** Step 1 exited 128 with `error: Entry 'mod.txt' not uptodate. Cannot merge.` in 3 of 4 runs (main, rep2, rep4). No file changed, and after the handle closed retry 1 exited 0. In rep3 it behaved like D3: `unable to unlink old 'mod.txt'`, partial mutation, and retry 1 refused on `added.txt`. In D1 the file mtimes (≈ .20 s) and the private index mtime (≈ .73 s) were in the same second. [INFERENCE] Git's racy-entry check tried to read the locked file and failed, which caught the lock before any write. That depends on timing, so a production merge-back should be expected to hit the D3 outcome.
9. **Deleted file held open (D2 and D4, 8/8 runs).** Step 1 **exited 0** and wrote `warning: unable to unlink 'del.txt': Invalid argument` on stderr. The private index held NEW, with no `del.txt`. `added.txt` and `mod.txt` were updated, and `del.txt` stayed on disk unchanged. Steps 2 and 3 then succeeded. The final state was the branch at NEWCOMMIT with `git status` = `?? del.txt`: the exit code reported success while scratch kept an untracked copy of the deleted file.
10. **Checked-out branch (E).**
    - `git branch -f scratch-b NEWCOMMIT` refused: exit 128, `fatal: cannot force update the branch 'scratch-b' used by worktree at '.../scratch'`.
    - `git update-ref refs/heads/scratch-b NEWCOMMIT OLDCOMMIT` succeeded (exit 0) while `scratch-b` was checked out there.
    - A wrong old value was refused with exit 128 and `cannot lock ref 'refs/heads/scratch-b': is at <OLD> but expected <NEW>`. The all-zero old value was refused with `reference already exists`. A stale OLDCOMMIT after the move was refused the same way.
    - The update-ref left scratch's files and real index alone. Status then showed `D  added.txt`, `A  del.txt` and `M  mod.txt` (HEAD ahead of the index).
    - A CAS run with `GIT_DIR` set to the worktree's gitdir moved the shared branch too.
    - `update-ref` without `-m` wrote reflog entries with empty messages.
11. **index.lock present (F, 4 runs × 2).** Both the copy (F1) and the rename (F2) over `index` succeeded with `index.lock` present, and the real index then held the private index's bytes. `git status` in scratch exited 0 with empty stderr (8/8) and read the installed index. The index writer `git update-index --refresh` exited 128 with `Unable to create '.../index.lock': File exists.` in 6 of 8 runs; the other 2 runs, both F1 (copy), exited 0. `update-ref` (step 3) succeeded in 8/8 runs. Once the lock was removed, refresh exited 0 and status was clean. [INFERENCE] update-index needs the lock only when it has something to write, so its outcome depends on timing.
12. **`git status` writes the real index opportunistically.** The snapshots record status rewriting the real index (B after step 2; D1 while held and after release). With `index.lock` present, status did not fail.
