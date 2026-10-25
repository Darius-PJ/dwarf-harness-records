# T07 follow-up: safe retry after a partial merge-back, and index-lock ownership (measured)

Git 2.55.0.windows.3, Windows 10.0.19045.6456 (system gitconfig sets `core.autocrlf=true`; each test repo sets it to false locally, and every `read-tree`/`update-index --refresh`/`hash-object` here pins `-c core.autocrlf=false`). Same harness as `local://t07-git-probes.md`: Python 3.13 `subprocess.run` with an argument list, stdin = DEVNULL, every `GIT_*` variable removed from the inherited environment, so `env set:` lists every Git variable present. Raw command line, cwd, env, exit code (with wall time), stdout and stderr are recorded per command; non-Git file operations are recorded as the Python call. No `read-tree --reset` is used anywhere. Throwaway roots `%TEMP%\t07probe-R*`, all deleted afterwards.

## Setup

Each part starts from a fresh root built by these commands (shown for the first root; paths and commit ids differ per root, OLD and NEW trees are identical everywhere):

Root `C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj`:

```
$ git init -b main C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj
env set: (none)
exit: 0   (0.04s)
--- stdout ---
Initialized empty Git repository in C:/Users/darius.jones/AppData/Local/Temp/t07probe-R1-3zxmwgjj/repo/.git/
--- stderr ---
```
```
$ git config core.autocrlf false
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo
env set: (none)
note: repo-local; system gitconfig sets core.autocrlf=true
exit: 0   (0.03s)
--- stdout ---
--- stderr ---
```
Files written into `repo` with Python `write_bytes` (LF only): `keep.txt` = b'keep line 1\nkeep line 2\n', `mod.txt` = b'mod original 1\nmod original 2\n', `del.txt` = b'to be deleted 1\nto be deleted 2\n', `notes.txt` = b'notes a\nnotes b\nnotes c\n'

```
$ git add -A
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git commit -q -m base
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo
env set: (none)
exit: 0   (0.07s)
--- stdout ---
--- stderr ---
```
```
$ git worktree add --no-checkout -b scratch-b C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\scratch main
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo
env set: (none)
exit: 0   (0.07s)
--- stdout ---
--- stderr ---
Preparing worktree (new branch 'scratch-b')
```
```
$ git read-tree -u --reset HEAD
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo
env set: (none)
exit: 0   (0.03s)
--- stdout ---
faf5d6d9c168a826fcf7110e8551463727500986
--- stderr ---
```
```
$ git rev-parse faf5d6d9c168a826fcf7110e8551463727500986^{tree}
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo
env set: (none)
exit: 0   (0.03s)
--- stdout ---
8dd99e09a46e19a02e68f292c0120e7dc42c69c1
--- stderr ---
```
```
$ git read-tree 8dd99e09a46e19a02e68f292c0120e7dc42c69c1
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo
env set: GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\build.index
exit: 0   (0.03s)
--- stdout ---
--- stderr ---
```
```
$ git hash-object -w --no-filters --stdin
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo
env set: (none)
note: stdin = b'mod CHANGED 1\nmod original 2\nmod added 3\n'
exit: 0   (0.03s)
--- stdout ---
10ac2baa0965e7ddc30b97c5824d8a8270b519e5
--- stderr ---
```
```
$ git hash-object -w --no-filters --stdin
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo
env set: (none)
note: stdin = b'added line 1\nadded line 2\n'
exit: 0   (0.03s)
--- stdout ---
51fa1036c055e2b2af0a34bdeeb5b553da6d55b4
--- stderr ---
```
```
$ git update-index --cacheinfo 100644,10ac2baa0965e7ddc30b97c5824d8a8270b519e5,mod.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo
env set: GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\build.index
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git update-index --add --cacheinfo 100644,51fa1036c055e2b2af0a34bdeeb5b553da6d55b4,added.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo
env set: GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\build.index
exit: 0   (0.03s)
--- stdout ---
--- stderr ---
```
```
$ git update-index --force-remove del.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo
env set: GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\build.index
exit: 0   (0.03s)
--- stdout ---
--- stderr ---
```
```
$ git write-tree
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo
env set: GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\build.index
exit: 0   (0.04s)
--- stdout ---
dc9973975472c4e240433ce156dc1c4f28ff4c77
--- stderr ---
```
```
$ git commit-tree dc9973975472c4e240433ce156dc1c4f28ff4c77 -p faf5d6d9c168a826fcf7110e8551463727500986 -m new
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
ee8d3e177515ed0562313431373e599b834a94e9
--- stderr ---
```
`build.index` deleted. OLD tree `8dd99e09a46e19a02e68f292c0120e7dc42c69c1` (OLDCOMMIT `faf5d6d9c168a826fcf7110e8551463727500986`); NEW tree `dc9973975472c4e240433ce156dc1c4f28ff4c77` (NEWCOMMIT `ee8d3e177515ed0562313431373e599b834a94e9`).

**Building O.** O is derived from disk, not from what the failed step was expected to do. Every path in OLD ∪ NEW is classified by `git -c core.autocrlf=false hash-object --path <p> <file>` (or as absent). The disk blob is compared with OLD's and NEW's blob, and the path is kept at OLD, set to NEW (`update-index --add --cacheinfo`) or removed (`update-index --force-remove`). This happens in a fresh index file `o-build.index` outside the worktree, started from `read-tree OLD`, with `GIT_DIR` = the worktree gitdir. Then `write-tree` gives O. A path whose disk content matches neither OLD nor NEW would abort (does not occur here).

**Install order (parts 1, 2, 3b):** (1) `os.open(index.lock, O_CREAT|O_EXCL|O_WRONLY)` then `os.close(fd)` (CreateFileW `CREATE_NEW`, as Go `os.OpenFile(O_CREATE|O_EXCL)`); (2) `os.replace(private2.index, index)` (MoveFileExW `REPLACE_EXISTING`, as Go `os.Rename`); (3) `os.remove(index.lock)`. Then `git update-ref refs/heads/scratch-b NEWCOMMIT OLDCOMMIT` from `repo`.

## 1. Safe retry after D3 (`mod.txt` held, partial failure)

Fresh setup (commands in Setup) at `C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj`: OLD tree `8dd99e09a46e19a02e68f292c0120e7dc42c69c1`, OLDCOMMIT `faf5d6d9c168a826fcf7110e8551463727500986`, NEW tree `dc9973975472c4e240433ce156dc1c4f28ff4c77`, NEWCOMMIT `ee8d3e177515ed0562313431373e599b834a94e9`.

```
python: time.sleep(2.5)   # files strictly older than the private index (the D3/D4 condition)
```
```
$ git read-tree 8dd99e09a46e19a02e68f292c0120e7dc42c69c1
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\private1.index
note: first attempt: load OLD
exit: 0   (0.03s)
--- stdout ---
--- stderr ---
```
```
$ git -c core.autocrlf=false update-index --refresh
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\private1.index
exit: 0   (0.03s)
--- stdout ---
--- stderr ---
```
```
background (kept running): powershell.exe -NoProfile -NonInteractive -Command "$path='C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\scratch\mod.txt'; $f=[System.IO.File]::Open($path,'Open','ReadWrite','None'); [Console]::Out.WriteLine('LOCKED'); [Console]::Out.Flush(); $null=[Console]::In.ReadLine(); $f.Close(); [Console]::Out.WriteLine('CLOSED'); [Console]::Out.Flush()"
first stdout line: b'LOCKED\r\n'  (pid 7408)
```
```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\private1.index
note: first attempt, mod.txt held
exit: 128   (0.14s)
--- stdout ---
--- stderr ---
error: unable to unlink old 'mod.txt': Invalid argument
```
```
background PowerShell released (newline written to its stdin)
exit: 0
--- stdout ---
CLOSED

--- stderr ---
```
**State: after the first attempt, handle released**

```
scratch files:
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        30 B  sha256=b2073509debaf31b7e3ecb9698236dc4ec3662b921b992a08021024e399ff044  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index (private1.index) sha256: ad8a420d505b16179ede711b8ea4bccb6155031961bcc029ac90334adcd28594
real index sha256: ad8a420d505b16179ede711b8ea4bccb6155031961bcc029ac90334adcd28594
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\private1.index
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
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\scratch
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
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
 D del.txt
?? added.txt
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo
env set: (none)
exit: 0   (0.03s)
--- stdout ---
faf5d6d9c168a826fcf7110e8551463727500986
--- stderr ---
```
Classify each path of OLD ∪ NEW by hashing the file on disk (same `core.autocrlf=false` as step 1), then build O with a fresh index file outside the worktree:

```
$ git ls-tree -r --name-only 8dd99e09a46e19a02e68f292c0120e7dc42c69c1
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo
env set: (none)
exit: 0   (0.03s)
--- stdout ---
del.txt
keep.txt
mod.txt
notes.txt
--- stderr ---
```
```
$ git ls-tree -r --name-only dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo
env set: (none)
exit: 0   (0.03s)
--- stdout ---
added.txt
keep.txt
mod.txt
notes.txt
--- stderr ---
```
```
$ git read-tree 8dd99e09a46e19a02e68f292c0120e7dc42c69c1
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\o-build.index
note: O starts from OLD
exit: 0   (0.03s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse --verify -q 8dd99e09a46e19a02e68f292c0120e7dc42c69c1:added.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo
env set: (none)
exit: 1   (0.03s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse --verify -q dc9973975472c4e240433ce156dc1c4f28ff4c77:added.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo
env set: (none)
exit: 0   (0.03s)
--- stdout ---
51fa1036c055e2b2af0a34bdeeb5b553da6d55b4
--- stderr ---
```
```
$ git -c core.autocrlf=false hash-object --path added.txt C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\scratch\added.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\scratch
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\scratch
exit: 0   (0.03s)
--- stdout ---
51fa1036c055e2b2af0a34bdeeb5b553da6d55b4
--- stderr ---
```
```
$ git update-index --add --cacheinfo 100644,51fa1036c055e2b2af0a34bdeeb5b553da6d55b4,added.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\o-build.index
exit: 0   (0.03s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse --verify -q 8dd99e09a46e19a02e68f292c0120e7dc42c69c1:del.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
47eba6ae78733dfc7735a1fc610aabcb2d4dee13
--- stderr ---
```
```
$ git rev-parse --verify -q dc9973975472c4e240433ce156dc1c4f28ff4c77:del.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo
env set: (none)
exit: 1   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git update-index --force-remove del.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\o-build.index
exit: 0   (0.03s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse --verify -q 8dd99e09a46e19a02e68f292c0120e7dc42c69c1:keep.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
e47123eb620849ff662dd91bc59352673e2bf5ff
--- stderr ---
```
```
$ git rev-parse --verify -q dc9973975472c4e240433ce156dc1c4f28ff4c77:keep.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
e47123eb620849ff662dd91bc59352673e2bf5ff
--- stderr ---
```
```
$ git -c core.autocrlf=false hash-object --path keep.txt C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\scratch\keep.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\scratch
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\scratch
exit: 0   (0.04s)
--- stdout ---
e47123eb620849ff662dd91bc59352673e2bf5ff
--- stderr ---
```
```
$ git rev-parse --verify -q 8dd99e09a46e19a02e68f292c0120e7dc42c69c1:mod.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo
env set: (none)
exit: 0   (0.03s)
--- stdout ---
6fce82ba89fe1dd557f025f31c5b6e0b5fed8312
--- stderr ---
```
```
$ git rev-parse --verify -q dc9973975472c4e240433ce156dc1c4f28ff4c77:mod.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo
env set: (none)
exit: 0   (0.03s)
--- stdout ---
10ac2baa0965e7ddc30b97c5824d8a8270b519e5
--- stderr ---
```
```
$ git -c core.autocrlf=false hash-object --path mod.txt C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\scratch\mod.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\scratch
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\scratch
exit: 0   (0.03s)
--- stdout ---
6fce82ba89fe1dd557f025f31c5b6e0b5fed8312
--- stderr ---
```
```
$ git rev-parse --verify -q 8dd99e09a46e19a02e68f292c0120e7dc42c69c1:notes.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
b71e3c44a7e6b532edca3107264069c4479f3623
--- stderr ---
```
```
$ git rev-parse --verify -q dc9973975472c4e240433ce156dc1c4f28ff4c77:notes.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
b71e3c44a7e6b532edca3107264069c4479f3623
--- stderr ---
```
```
$ git -c core.autocrlf=false hash-object --path notes.txt C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\scratch\notes.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\scratch
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\scratch
exit: 0   (0.04s)
--- stdout ---
b71e3c44a7e6b532edca3107264069c4479f3623
--- stderr ---
```
```
classification:
added.txt  old=None new=51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 disk=51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 -> NEW
del.txt    old=47eba6ae78733dfc7735a1fc610aabcb2d4dee13 new=None disk=None -> absent
keep.txt   old=e47123eb620849ff662dd91bc59352673e2bf5ff new=e47123eb620849ff662dd91bc59352673e2bf5ff disk=e47123eb620849ff662dd91bc59352673e2bf5ff -> NEW
mod.txt    old=6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 new=10ac2baa0965e7ddc30b97c5824d8a8270b519e5 disk=6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 -> OLD
notes.txt  old=b71e3c44a7e6b532edca3107264069c4479f3623 new=b71e3c44a7e6b532edca3107264069c4479f3623 disk=b71e3c44a7e6b532edca3107264069c4479f3623 -> NEW
```
```
$ git write-tree
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\o-build.index
exit: 0   (0.04s)
--- stdout ---
a10b0c89b68361d5f45510d62353bb37d6b40663
--- stderr ---
```
```
python: os.remove(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\o-build.index')
```
```
$ git diff-tree -r --name-status 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 a10b0c89b68361d5f45510d62353bb37d6b40663
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo
env set: (none)
note: OLD -> O
exit: 0   (0.04s)
--- stdout ---
A	added.txt
D	del.txt
--- stderr ---
```
```
$ git diff-tree -r --name-status a10b0c89b68361d5f45510d62353bb37d6b40663 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo
env set: (none)
note: O -> NEW
exit: 0   (0.04s)
--- stdout ---
M	mod.txt
--- stderr ---
```
Retry O -> NEW with a fresh private index:

```
$ git read-tree a10b0c89b68361d5f45510d62353bb37d6b40663
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\private2.index
note: load O
exit: 0   (0.03s)
--- stdout ---
--- stderr ---
```
```
$ git -c core.autocrlf=false update-index --refresh
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\private2.index
exit: 0   (0.03s)
--- stdout ---
--- stderr ---
```
```
$ git -c core.autocrlf=false read-tree -m -u a10b0c89b68361d5f45510d62353bb37d6b40663 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\private2.index
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
**State: after read-tree -m -u O NEW**

```
scratch files:
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index (private2.index) sha256: b60099b3482edb5480bced65a7d6fe84ec18eb631399f142fb1b6f26bb1e5670
real index sha256: ad8a420d505b16179ede711b8ea4bccb6155031961bcc029ac90334adcd28594
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\private2.index
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
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\scratch
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
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
 D del.txt
 M mod.txt
?? added.txt
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
faf5d6d9c168a826fcf7110e8551463727500986
--- stderr ---
```
Install, in this order: (1) create `index.lock` exclusively, (2) rename the private index onto `index`, (3) remove `index.lock`.

```
python: fd = os.open(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo\.git\worktrees\scratch\index.lock', os.O_CREAT | os.O_EXCL | os.O_WRONLY); os.close(fd)
# O_EXCL -> CreateFileW(CREATE_NEW), as Go os.OpenFile(O_CREATE|O_EXCL)
result: ok, index.lock exists = True
```
```
python: os.replace(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\private2.index', r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo\.git\worktrees\scratch\index')   # MoveFileExW(MOVEFILE_REPLACE_EXISTING)
result: ok
```
```
python: os.remove(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo\.git\worktrees\scratch\index.lock')
result: ok, index.lock exists = False
```
```
$ git update-ref refs/heads/scratch-b ee8d3e177515ed0562313431373e599b834a94e9 faf5d6d9c168a826fcf7110e8551463727500986
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
**State: final**

```
scratch files:
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
real index sha256: b60099b3482edb5480bced65a7d6fe84ec18eb631399f142fb1b6f26bb1e5670
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\scratch
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
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
ee8d3e177515ed0562313431373e599b834a94e9
--- stderr ---
```
```
$ git write-tree
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\scratch
env set: (none)
note: tree of the real index; compare with NEW
exit: 0   (0.03s)
--- stdout ---
dc9973975472c4e240433ce156dc1c4f28ff4c77
--- stderr ---
```
```
$ git rev-parse HEAD^{tree}
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R1-3zxmwgjj\scratch
env set: (none)
exit: 0   (0.03s)
--- stdout ---
dc9973975472c4e240433ce156dc1c4f28ff4c77
--- stderr ---
```
NEW tree for comparison: `dc9973975472c4e240433ce156dc1c4f28ff4c77`


## 2. Safe retry after D2/D4 (`del.txt` held, exit 0 with a leftover)

Fresh setup (commands in Setup) at `C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft`: OLD tree `8dd99e09a46e19a02e68f292c0120e7dc42c69c1`, OLDCOMMIT `57a6530ddca61dc0ce8bf0c6c791ac9bd37e5de0`, NEW tree `dc9973975472c4e240433ce156dc1c4f28ff4c77`, NEWCOMMIT `574fc9a1f564d24e9922b3941af2f11111dcc2bb`.

```
python: time.sleep(2.5)   # files strictly older than the private index (the D3/D4 condition)
```
```
$ git read-tree 8dd99e09a46e19a02e68f292c0120e7dc42c69c1
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\private1.index
note: first attempt: load OLD
exit: 0   (0.03s)
--- stdout ---
--- stderr ---
```
```
$ git -c core.autocrlf=false update-index --refresh
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\private1.index
exit: 0   (0.03s)
--- stdout ---
--- stderr ---
```
```
background (kept running): powershell.exe -NoProfile -NonInteractive -Command "$path='C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\scratch\del.txt'; $f=[System.IO.File]::Open($path,'Open','ReadWrite','None'); [Console]::Out.WriteLine('LOCKED'); [Console]::Out.Flush(); $null=[Console]::In.ReadLine(); $f.Close(); [Console]::Out.WriteLine('CLOSED'); [Console]::Out.Flush()"
first stdout line: b'LOCKED\r\n'  (pid 8308)
```
```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\private1.index
note: first attempt, del.txt held
exit: 0   (0.15s)
--- stdout ---
--- stderr ---
warning: unable to unlink 'del.txt': Invalid argument
```
```
background PowerShell released (newline written to its stdin)
exit: 0
--- stdout ---
CLOSED

--- stderr ---
```
**State: after the first attempt, handle released**

```
scratch files:
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
del.txt        32 B  sha256=f9aa75468c487b5da854d309a29eba0cada31eb5b1ef89950269f3a1e156746d  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index (private1.index) sha256: 4424322daadc05dfcde90a8f8cc6a16be462b79029d28466639a61a70e1a8db8
real index sha256: f9f4dc9ae4209162df48258b049da12b8f423e07e99a6e416e2b274953ee86c2
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\private1.index
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
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\scratch
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
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
 M mod.txt
?? added.txt
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
57a6530ddca61dc0ce8bf0c6c791ac9bd37e5de0
--- stderr ---
```
The first private index `private1.index` (which already holds NEW after the exit-0 attempt) is discarded:
```
python: os.remove(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\private1.index')
```
Classify each path of OLD ∪ NEW by hashing the file on disk (same `core.autocrlf=false` as step 1), then build O with a fresh index file outside the worktree:

```
$ git ls-tree -r --name-only 8dd99e09a46e19a02e68f292c0120e7dc42c69c1
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
del.txt
keep.txt
mod.txt
notes.txt
--- stderr ---
```
```
$ git ls-tree -r --name-only dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
added.txt
keep.txt
mod.txt
notes.txt
--- stderr ---
```
```
$ git read-tree 8dd99e09a46e19a02e68f292c0120e7dc42c69c1
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\o-build.index
note: O starts from OLD
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse --verify -q 8dd99e09a46e19a02e68f292c0120e7dc42c69c1:added.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo
env set: (none)
exit: 1   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse --verify -q dc9973975472c4e240433ce156dc1c4f28ff4c77:added.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
51fa1036c055e2b2af0a34bdeeb5b553da6d55b4
--- stderr ---
```
```
$ git -c core.autocrlf=false hash-object --path added.txt C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\scratch\added.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\scratch
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\scratch
exit: 0   (0.04s)
--- stdout ---
51fa1036c055e2b2af0a34bdeeb5b553da6d55b4
--- stderr ---
```
```
$ git update-index --add --cacheinfo 100644,51fa1036c055e2b2af0a34bdeeb5b553da6d55b4,added.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\o-build.index
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse --verify -q 8dd99e09a46e19a02e68f292c0120e7dc42c69c1:del.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
47eba6ae78733dfc7735a1fc610aabcb2d4dee13
--- stderr ---
```
```
$ git rev-parse --verify -q dc9973975472c4e240433ce156dc1c4f28ff4c77:del.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo
env set: (none)
exit: 1   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git -c core.autocrlf=false hash-object --path del.txt C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\scratch\del.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\scratch
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\scratch
exit: 0   (0.04s)
--- stdout ---
47eba6ae78733dfc7735a1fc610aabcb2d4dee13
--- stderr ---
```
```
$ git rev-parse --verify -q 8dd99e09a46e19a02e68f292c0120e7dc42c69c1:keep.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
e47123eb620849ff662dd91bc59352673e2bf5ff
--- stderr ---
```
```
$ git rev-parse --verify -q dc9973975472c4e240433ce156dc1c4f28ff4c77:keep.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
e47123eb620849ff662dd91bc59352673e2bf5ff
--- stderr ---
```
```
$ git -c core.autocrlf=false hash-object --path keep.txt C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\scratch\keep.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\scratch
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\scratch
exit: 0   (0.05s)
--- stdout ---
e47123eb620849ff662dd91bc59352673e2bf5ff
--- stderr ---
```
```
$ git rev-parse --verify -q 8dd99e09a46e19a02e68f292c0120e7dc42c69c1:mod.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
6fce82ba89fe1dd557f025f31c5b6e0b5fed8312
--- stderr ---
```
```
$ git rev-parse --verify -q dc9973975472c4e240433ce156dc1c4f28ff4c77:mod.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
10ac2baa0965e7ddc30b97c5824d8a8270b519e5
--- stderr ---
```
```
$ git -c core.autocrlf=false hash-object --path mod.txt C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\scratch\mod.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\scratch
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\scratch
exit: 0   (0.04s)
--- stdout ---
10ac2baa0965e7ddc30b97c5824d8a8270b519e5
--- stderr ---
```
```
$ git update-index --add --cacheinfo 100644,10ac2baa0965e7ddc30b97c5824d8a8270b519e5,mod.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\o-build.index
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse --verify -q 8dd99e09a46e19a02e68f292c0120e7dc42c69c1:notes.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
b71e3c44a7e6b532edca3107264069c4479f3623
--- stderr ---
```
```
$ git rev-parse --verify -q dc9973975472c4e240433ce156dc1c4f28ff4c77:notes.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
b71e3c44a7e6b532edca3107264069c4479f3623
--- stderr ---
```
```
$ git -c core.autocrlf=false hash-object --path notes.txt C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\scratch\notes.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\scratch
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\scratch
exit: 0   (0.05s)
--- stdout ---
b71e3c44a7e6b532edca3107264069c4479f3623
--- stderr ---
```
```
classification:
added.txt  old=None new=51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 disk=51fa1036c055e2b2af0a34bdeeb5b553da6d55b4 -> NEW
del.txt    old=47eba6ae78733dfc7735a1fc610aabcb2d4dee13 new=None disk=47eba6ae78733dfc7735a1fc610aabcb2d4dee13 -> OLD
keep.txt   old=e47123eb620849ff662dd91bc59352673e2bf5ff new=e47123eb620849ff662dd91bc59352673e2bf5ff disk=e47123eb620849ff662dd91bc59352673e2bf5ff -> NEW
mod.txt    old=6fce82ba89fe1dd557f025f31c5b6e0b5fed8312 new=10ac2baa0965e7ddc30b97c5824d8a8270b519e5 disk=10ac2baa0965e7ddc30b97c5824d8a8270b519e5 -> NEW
notes.txt  old=b71e3c44a7e6b532edca3107264069c4479f3623 new=b71e3c44a7e6b532edca3107264069c4479f3623 disk=b71e3c44a7e6b532edca3107264069c4479f3623 -> NEW
```
```
$ git write-tree
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\o-build.index
exit: 0   (0.04s)
--- stdout ---
c571f89f9581cd9ff0eef6033604a23ed79d97be
--- stderr ---
```
```
python: os.remove(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\o-build.index')
```
```
$ git diff-tree -r --name-status 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 c571f89f9581cd9ff0eef6033604a23ed79d97be
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo
env set: (none)
note: OLD -> O
exit: 0   (0.04s)
--- stdout ---
A	added.txt
M	mod.txt
--- stderr ---
```
```
$ git diff-tree -r --name-status c571f89f9581cd9ff0eef6033604a23ed79d97be dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo
env set: (none)
note: O -> NEW
exit: 0   (0.04s)
--- stdout ---
D	del.txt
--- stderr ---
```
Retry O -> NEW with a fresh private index:

```
$ git read-tree c571f89f9581cd9ff0eef6033604a23ed79d97be
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\private2.index
note: load O
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
```
$ git -c core.autocrlf=false update-index --refresh
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\private2.index
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git -c core.autocrlf=false read-tree -m -u c571f89f9581cd9ff0eef6033604a23ed79d97be dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\private2.index
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
**State: after read-tree -m -u O NEW**

```
scratch files:
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index (private2.index) sha256: 4424322daadc05dfcde90a8f8cc6a16be462b79029d28466639a61a70e1a8db8
real index sha256: f9f4dc9ae4209162df48258b049da12b8f423e07e99a6e416e2b274953ee86c2
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\private2.index
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
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\scratch
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
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
 D del.txt
 M mod.txt
?? added.txt
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
57a6530ddca61dc0ce8bf0c6c791ac9bd37e5de0
--- stderr ---
```
Install, in this order: (1) create `index.lock` exclusively, (2) rename the private index onto `index`, (3) remove `index.lock`.

```
python: fd = os.open(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo\.git\worktrees\scratch\index.lock', os.O_CREAT | os.O_EXCL | os.O_WRONLY); os.close(fd)
# O_EXCL -> CreateFileW(CREATE_NEW), as Go os.OpenFile(O_CREATE|O_EXCL)
result: ok, index.lock exists = True
```
```
python: os.replace(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\private2.index', r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo\.git\worktrees\scratch\index')   # MoveFileExW(MOVEFILE_REPLACE_EXISTING)
result: ok
```
```
python: os.remove(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo\.git\worktrees\scratch\index.lock')
result: ok, index.lock exists = False
```
```
$ git update-ref refs/heads/scratch-b 574fc9a1f564d24e9922b3941af2f11111dcc2bb 57a6530ddca61dc0ce8bf0c6c791ac9bd37e5de0
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
**State: final**

```
scratch files:
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
real index sha256: 4424322daadc05dfcde90a8f8cc6a16be462b79029d28466639a61a70e1a8db8
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\scratch
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
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
574fc9a1f564d24e9922b3941af2f11111dcc2bb
--- stderr ---
```
```
$ git write-tree
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\scratch
env set: (none)
note: tree of the real index; compare with NEW
exit: 0   (0.04s)
--- stdout ---
dc9973975472c4e240433ce156dc1c4f28ff4c77
--- stderr ---
```
```
$ git rev-parse HEAD^{tree}
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R2-32emofft\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
dc9973975472c4e240433ce156dc1c4f28ff4c77
--- stderr ---
```
NEW tree for comparison: `dc9973975472c4e240433ce156dc1c4f28ff4c77`


## 3. Lock ownership

### 3a. Pre-existing `index.lock`: the exclusive create must fail and nothing is installed

Fresh setup (commands in Setup) at `C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j`: OLD tree `8dd99e09a46e19a02e68f292c0120e7dc42c69c1`, OLDCOMMIT `61049ef538a93f8dfd31ad4d4c03f2624e6c7bc1`, NEW tree `dc9973975472c4e240433ce156dc1c4f28ff4c77`, NEWCOMMIT `04cc1d1dfa2d2b58ce5aaa79b840e4a332cf62a8`.

```
$ git read-tree 8dd99e09a46e19a02e68f292c0120e7dc42c69c1
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j\private.index
exit: 0   (0.03s)
--- stdout ---
--- stderr ---
```
```
$ git -c core.autocrlf=false update-index --refresh
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j\private.index
exit: 0   (0.03s)
--- stdout ---
--- stderr ---
```
```
$ git -c core.autocrlf=false read-tree -m -u 8dd99e09a46e19a02e68f292c0120e7dc42c69c1 dc9973975472c4e240433ce156dc1c4f28ff4c77
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j\repo\.git\worktrees\scratch GIT_WORK_TREE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j\private.index
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
python: open(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j\repo\.git\worktrees\scratch\index.lock','wb').write(b'held by someone else\n')   # the other holder
```
**State: before the install attempt**

```
scratch files:
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index (private.index) sha256: f2f9e0566e0b55aefa695a6d35f3a1957694b083e57ab1f3d6049eecb093771a
real index sha256: c51d63a6737495a7e5d17a89974116b1a66989169a0ac623da0957f7b4b5e2b5
index.lock exists: True
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j\private.index
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
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j\scratch
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
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
 D del.txt
 M mod.txt
?? added.txt
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j\repo
env set: (none)
exit: 0   (0.03s)
--- stdout ---
61049ef538a93f8dfd31ad4d4c03f2624e6c7bc1
--- stderr ---
```
```
python: os.open(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j\repo\.git\worktrees\scratch\index.lock', os.O_CREAT | os.O_EXCL | os.O_WRONLY)
raised: FileExistsError: [Errno 17] File exists: 'C:\\Users\\darius.jones\\AppData\\Local\\Temp\\t07probe-R3a-fi6ggu5j\\repo\\.git\\worktrees\\scratch\\index.lock'
-> refuse: no rename, no update-ref
```
**State: after the refused install**

```
scratch files:
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
private index (private.index) sha256: f2f9e0566e0b55aefa695a6d35f3a1957694b083e57ab1f3d6049eecb093771a
real index sha256: c51d63a6737495a7e5d17a89974116b1a66989169a0ac623da0957f7b4b5e2b5
index.lock exists: True
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j
env set: GIT_DIR=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j\repo\.git\worktrees\scratch GIT_INDEX_FILE=C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j\private.index
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
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j\scratch
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
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
 D del.txt
 M mod.txt
?? added.txt
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
61049ef538a93f8dfd31ad4d4c03f2624e6c7bc1
--- stderr ---
```
```
real index sha256 before: c51d63a6737495a7e5d17a89974116b1a66989169a0ac623da0957f7b4b5e2b5
real index sha256 after:  c51d63a6737495a7e5d17a89974116b1a66989169a0ac623da0957f7b4b5e2b5
equal: True
index.lock content: b'held by someone else\n'
```
### 3b. After a successful install the own lock is gone

Parts 1 and 2 record `index.lock exists = False` after the remove step and in the final state. An explicit repeat on the 3a scratch, after the other holder's lock is removed:

```
python: os.remove(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j\repo\.git\worktrees\scratch\index.lock')   # the other holder releases
```
Install, in this order: (1) create `index.lock` exclusively, (2) rename the private index onto `index`, (3) remove `index.lock`.

```
python: fd = os.open(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j\repo\.git\worktrees\scratch\index.lock', os.O_CREAT | os.O_EXCL | os.O_WRONLY); os.close(fd)
# O_EXCL -> CreateFileW(CREATE_NEW), as Go os.OpenFile(O_CREATE|O_EXCL)
result: ok, index.lock exists = True
```
```
python: os.replace(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j\private.index', r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j\repo\.git\worktrees\scratch\index')   # MoveFileExW(MOVEFILE_REPLACE_EXISTING)
result: ok
```
```
python: os.remove(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j\repo\.git\worktrees\scratch\index.lock')
result: ok, index.lock exists = False
```
```
$ git update-ref refs/heads/scratch-b 04cc1d1dfa2d2b58ce5aaa79b840e4a332cf62a8 61049ef538a93f8dfd31ad4d4c03f2624e6c7bc1
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j\repo
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
**State: after install + CAS**

```
scratch files:
added.txt      26 B  sha256=04d14601ca3c888dc4dbbc9a3b409c39403f989d5d7ab786cd5f09a4b7406b3f  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        41 B  sha256=92747fbc56e3c75deee959d294cd133de5a24003fbac667ae714168d6221d9f0  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
real index sha256: f2f9e0566e0b55aefa695a6d35f3a1957694b083e57ab1f3d6049eecb093771a
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j\scratch
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
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j\scratch
env set: (none)
exit: 0   (0.05s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3a-fi6ggu5j\repo
env set: (none)
exit: 0   (0.04s)
--- stdout ---
04cc1d1dfa2d2b58ce5aaa79b840e4a332cf62a8
--- stderr ---
```
### 3c. `git status` and `git update-index` run while the probe holds the lock

Fresh setup (commands in Setup) at `C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3c-2xdlcf1h`: OLD tree `8dd99e09a46e19a02e68f292c0120e7dc42c69c1`, OLDCOMMIT `45f3a5b4729826f9d6efd0ff3a07829948c7f4e1`, NEW tree `dc9973975472c4e240433ce156dc1c4f28ff4c77`, NEWCOMMIT `0af0b06baf2c864d7714eecfbc10b25c6dc5b4d2`.

```
python: fd = os.open(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3c-2xdlcf1h\repo\.git\worktrees\scratch\index.lock', os.O_CREAT | os.O_EXCL | os.O_WRONLY); os.close(fd)
# O_EXCL -> CreateFileW(CREATE_NEW), as Go os.OpenFile(O_CREATE|O_EXCL)
result: ok, index.lock exists = True
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3c-2xdlcf1h\scratch
env set: (none)
note: lock held by the probe; index has nothing to refresh
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git update-index --refresh
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3c-2xdlcf1h\scratch
env set: (none)
note: lock held; nothing to refresh
exit: 128   (0.04s)
--- stdout ---
--- stderr ---
fatal: Unable to create 'C:/Users/darius.jones/AppData/Local/Temp/t07probe-R3c-2xdlcf1h/repo/.git/worktrees/scratch/index.lock': File exists.

Another git process seems to be running in this repository, or the lock file may be stale
```
```
python: os.utime('scratch/keep.txt', now+5s)   # stat change, so refresh has something to write
```
```
$ git status --porcelain=v1 -uall
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3c-2xdlcf1h\scratch
env set: (none)
note: lock held; stat-dirty entry
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git update-index --refresh
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3c-2xdlcf1h\scratch
env set: (none)
note: lock held; stat-dirty entry
exit: 128   (0.04s)
--- stdout ---
--- stderr ---
fatal: Unable to create 'C:/Users/darius.jones/AppData/Local/Temp/t07probe-R3c-2xdlcf1h/repo/.git/worktrees/scratch/index.lock': File exists.

Another git process seems to be running in this repository, or the lock file may be stale
```
```
$ git add keep.txt
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3c-2xdlcf1h\scratch
env set: (none)
note: lock held; plain index writer
exit: 128   (0.04s)
--- stdout ---
--- stderr ---
fatal: Unable to create 'C:/Users/darius.jones/AppData/Local/Temp/t07probe-R3c-2xdlcf1h/repo/.git/worktrees/scratch/index.lock': File exists.

Another git process seems to be running in this repository, or the lock file may be stale
```
Two background processes started while the lock is held, then the lock is released 3 s later:

```
$ git status --porcelain=v1 -uall   (background, cwd C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3c-2xdlcf1h\scratch, env set: (none))
started at t=0.00s, lock released at t=3.01s, exit collected after release
exit: 0
--- stdout ---
--- stderr ---
```
```
$ git update-index --refresh   (background, cwd C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3c-2xdlcf1h\scratch, env set: (none))
started at t=0.00s, lock released at t=3.00s, exit collected after release
exit: 128
--- stdout ---
--- stderr ---
fatal: Unable to create 'C:/Users/darius.jones/AppData/Local/Temp/t07probe-R3c-2xdlcf1h/repo/.git/worktrees/scratch/index.lock': File exists.

Another git process seems to be running in this repository, or the lock file may be stale
```
```
real index sha256 before lock: 6e9e2e6fd56d37077b1ba9f568af3e2aa6a67f0a40d274ac47012a14a8ba28e4
real index sha256 now:         6e9e2e6fd56d37077b1ba9f568af3e2aa6a67f0a40d274ac47012a14a8ba28e4
```
Timed poll: one more background `git update-index --refresh` against a held lock, polled every 10 ms:

```
python: fd = os.open(r'C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3c-2xdlcf1h\repo\.git\worktrees\scratch\index.lock', os.O_CREAT | os.O_EXCL | os.O_WRONLY); os.close(fd)
# O_EXCL -> CreateFileW(CREATE_NEW), as Go os.OpenFile(O_CREATE|O_EXCL)
result: ok, index.lock exists = True
```
```
$ git update-index --refresh   (background, cwd C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3c-2xdlcf1h\scratch; notes.txt mtime bumped first)
finished while lock held: True after 0.048s
exit: 128
--- stdout ---
--- stderr ---
fatal: Unable to create 'C:/Users/darius.jones/AppData/Local/Temp/t07probe-R3c-2xdlcf1h/repo/.git/worktrees/scratch/index.lock': File exists.

Another git process seems to be running in this repository, or the lock file may be stale
```
**State: after releasing the lock**

```
scratch files:
del.txt        32 B  sha256=f9aa75468c487b5da854d309a29eba0cada31eb5b1ef89950269f3a1e156746d  CRLF=0
keep.txt       24 B  sha256=f8d587d4b58ed4965b14b1503452ca045b6b6876aec9a0b23960607c71bb6ff1  CRLF=0
mod.txt        30 B  sha256=b2073509debaf31b7e3ecb9698236dc4ec3662b921b992a08021024e399ff044  CRLF=0
notes.txt      24 B  sha256=cba38c1103234b940d9394e90833d8542f0e69e26c103e9ea3baa4dd0ad9aa24  CRLF=0
```
```
real index sha256: 6e9e2e6fd56d37077b1ba9f568af3e2aa6a67f0a40d274ac47012a14a8ba28e4
index.lock exists: False
```
```
$ git ls-files -s
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3c-2xdlcf1h\scratch
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
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3c-2xdlcf1h\scratch
env set: (none)
exit: 0   (0.04s)
--- stdout ---
--- stderr ---
```
```
$ git rev-parse refs/heads/scratch-b
cwd: C:\Users\darius.jones\AppData\Local\Temp\t07probe-R3c-2xdlcf1h\repo
env set: (none)
exit: 0   (0.03s)
--- stdout ---
45f3a5b4729826f9d6efd0ff3a07829948c7f4e1
--- stderr ---
```

## Observations

1. **Retry after D3 works.** The first attempt (mod.txt held, files 2.5 s older than the index) exited 128, `error: unable to unlink old 'mod.txt': Invalid argument`, leaving `del.txt` deleted, `added.txt` written, `mod.txt` OLD; private and real index still OLD; status ` D del.txt`, `?? added.txt`. From disk the classifier gave `added.txt -> NEW`, `del.txt -> absent`, `mod.txt -> OLD`, `keep.txt`/`notes.txt` unchanged; O = `a10b0c89…`, `diff-tree OLD O` = `A added.txt`, `D del.txt`; `diff-tree O NEW` = `M mod.txt`. Loading O + `update-index --refresh` exited 0; `read-tree -m -u O NEW` exited 0 with empty stderr and only rewrote `mod.txt` (41 B, `92747fbc…`). After install (lock create → rename → lock remove) and `update-ref` (exit 0): files `added.txt 04d14601…`, `keep.txt f8d587d4…`, `mod.txt 92747fbc…`, `notes.txt cba38c11…`; `git status` empty; `ls-files -s` = NEW blobs; branch = NEWCOMMIT; `git write-tree` on the real index = `HEAD^{tree}` = NEW `dc997397…`; `index.lock` absent.
2. **Retry after D2/D4 works and removes the leftover.** The first attempt (del.txt held) exited 0 with `warning: unable to unlink 'del.txt': Invalid argument`; after release `del.txt` (32 B, OLD content) was still on disk and its private index already held NEW. That private index was discarded. The classifier gave `del.txt -> OLD` (disk blob = OLD blob `47eba6ae…`), `added.txt -> NEW`, `mod.txt -> NEW`; O = `c571f89f…`, `diff-tree OLD O` = `A added.txt`, `M mod.txt`; `diff-tree O NEW` = `D del.txt`. `read-tree -m -u O NEW` exited 0, empty stderr, and **`del.txt` was removed**. After install + `update-ref`: four files with NEW content, `git status` empty, branch = NEWCOMMIT, real-index tree = `HEAD^{tree}` = NEW, `index.lock` absent.
3. **(a) Foreign lock refuses.** With `index.lock` pre-created by "someone else", `os.open(..., O_CREAT|O_EXCL|O_WRONLY)` raised `FileExistsError: [Errno 17] File exists`; the probe then did no rename and no `update-ref`. Real index SHA-256 before = after (`c51d63a6…`), the private index was still present, the branch stayed at OLDCOMMIT, and the foreign lock's content (`b'held by someone else\n'`) was untouched.
4. **(b) Own lock is gone after install.** In parts 1, 2 and 3b the record after `os.remove` shows `index.lock exists = False`, and every later state shows `index.lock exists: False` with a clean status.
5. **(c) Git fails, it does not wait.** While the probe held `index.lock`:
   - `git status --porcelain=v1 -uall` exited 0 in 0.04 s, both with nothing to refresh and with a stat-dirty `keep.txt`; it did not rewrite the index (SHA-256 unchanged).
   - `git update-index --refresh` exited 128 in 0.04 s with `fatal: Unable to create '.../index.lock': File exists.` — both with nothing to refresh and with a stat-dirty entry (this run; in the earlier probe it sometimes exited 0 when nothing needed writing).
   - `git add keep.txt` exited 128 in 0.04 s with the same message.
   - Started in the background before a 3 s hold, `update-index --refresh` exited 128 with the same message; in the timed variant it had already exited (128) after 0.048 s while the lock was still held. `status` in the background exited 0.
   [INFERENCE] Git's index lock has no wait; a concurrent writer fails immediately and a concurrent `status` simply skips its opportunistic write.
