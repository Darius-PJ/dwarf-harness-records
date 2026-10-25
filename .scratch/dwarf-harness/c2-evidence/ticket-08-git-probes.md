# T08 Git durability probes

Run 2026-10-13. Repositories under `C:\Users\DARIUS~1.JON\AppData\Local\Temp\t08probe-x_2g7wqd` (deleted afterwards). Sources fetched from raw.githubusercontent.com at tag `v2.55.0.windows.3` (tag object 7f251f10…, commit 52ca1113d651127f89477a8763f86ab20f645e1d). Not about power loss: nothing here tests crash or power-loss durability.
## Setup
- `git --version` → `git version 2.55.0.windows.3`
- OS: Windows-10-10.0.19045-SP0 (Windows 10 19045)
- Fake colony: `C:\Users\DARIUS~1.JON\AppData\Local\Temp\t08probe-x_2g7wqd\colony` with `workspaces/nohooks/` (empty dir) and `workspaces/empty` (empty file).
- Environment for every probe, matching `repositoryEnvironment`: host env with all `GIT_*` variables removed, plus `GIT_CONFIG_NOSYSTEM=1`, `GIT_CONFIG_GLOBAL=<colony>/workspaces/empty`, `GIT_NO_REPLACE_OBJECTS=1`, `GIT_TERMINAL_PROMPT=0`, `GIT_OPTIONAL_LOCKS=0`. Added for `commit-tree` identity (probe-only): `{"GIT_AUTHOR_NAME": "probe", "GIT_AUTHOR_EMAIL": "probe@example.invalid", "GIT_COMMITTER_NAME": "probe", "GIT_COMMITTER_EMAIL": "probe@example.invalid", "GIT_AUTHOR_DATE": "1700000000 +0000", "GIT_COMMITTER_DATE": "1700000000 +0000"}`. Trace runs also set `GIT_TRACE2_EVENT=<file>`.
- Argv for every repository command, matching `repository`: `git --git-dir=<repo> -c core.hooksPath=<colony>/workspaces/nohooks -c core.fsmonitor=false -c core.fsync=<setting> -c core.fsyncMethod=fsync <args>` (Q3 varies `core.fsync`; Q4 bogus-value cases vary one option).
- Repository-building commands (all records with exit codes):
- `["git", "-c", "init.defaultBranch=main", "init", "--bare", "-q", "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-committed.git"]`
  exit 0 (0.087s); stdout `''`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-committed.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "hash-object", "-w", "--stdin"]`
  stdin: `'seed\n'`
  exit 0 (0.056s); stdout `'a18d99c65c281cd409393cda069092cbcce2a586\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-committed.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "mktree"]`
  stdin: `'100644 blob a18d99c65c281cd409393cda069092cbcce2a586\tseed\n'`
  exit 0 (0.056s); stdout `'87d3c2a73ab7bb3a7c18882c4b50353b98d59ae2\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-committed.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "commit-tree", "87d3c2a73ab7bb3a7c18882c4b50353b98d59ae2", "-m", "c1"]`
  exit 0 (0.065s); stdout `'762ef36ea75478128c900e0b28adb9107d16c31f\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-committed.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "update-ref", "refs/heads/main", "762ef36ea75478128c900e0b28adb9107d16c31f", ""]`
  exit 0 (0.055s); stdout `''`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-committed.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "pack-refs", "--all"]`
  exit 0 (0.064s); stdout `''`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-committed.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "commit-tree", "c279de92c97c91e2bc6e23dc9ac299f720260e64", "-p", "abf60a6f5b379820fc4c1bde5e8094641743b231", "-m", "c3"]`
  exit 0 (0.063s); stdout `'5c1da5a3e25a85849cb818022bccb1ac234ae3d2\n'`; stderr `''`
- `["git", "-c", "init.defaultBranch=main", "init", "--bare", "-q", "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-objects_reference.git"]`
  exit 0 (0.081s); stdout `''`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-objects_reference.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=objects,reference", "-c", "core.fsyncMethod=fsync", "hash-object", "-w", "--stdin"]`
  stdin: `'seed\n'`
  exit 0 (0.058s); stdout `'a18d99c65c281cd409393cda069092cbcce2a586\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-objects_reference.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=objects,reference", "-c", "core.fsyncMethod=fsync", "mktree"]`
  stdin: `'100644 blob a18d99c65c281cd409393cda069092cbcce2a586\tseed\n'`
  exit 0 (0.049s); stdout `'87d3c2a73ab7bb3a7c18882c4b50353b98d59ae2\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-objects_reference.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=objects,reference", "-c", "core.fsyncMethod=fsync", "commit-tree", "87d3c2a73ab7bb3a7c18882c4b50353b98d59ae2", "-m", "c1"]`
  exit 0 (0.067s); stdout `'762ef36ea75478128c900e0b28adb9107d16c31f\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-objects_reference.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=objects,reference", "-c", "core.fsyncMethod=fsync", "update-ref", "refs/heads/main", "762ef36ea75478128c900e0b28adb9107d16c31f", ""]`
  exit 0 (0.058s); stdout `''`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-objects_reference.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=objects,reference", "-c", "core.fsyncMethod=fsync", "pack-refs", "--all"]`
  exit 0 (0.062s); stdout `''`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-objects_reference.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=objects,reference", "-c", "core.fsyncMethod=fsync", "commit-tree", "c279de92c97c91e2bc6e23dc9ac299f720260e64", "-p", "abf60a6f5b379820fc4c1bde5e8094641743b231", "-m", "c3"]`
  exit 0 (0.055s); stdout `'5c1da5a3e25a85849cb818022bccb1ac234ae3d2\n'`; stderr `''`
- `["git", "-c", "init.defaultBranch=main", "init", "--bare", "-q", "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-none.git"]`
  exit 0 (0.057s); stdout `''`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-none.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=none", "-c", "core.fsyncMethod=fsync", "hash-object", "-w", "--stdin"]`
  stdin: `'seed\n'`
  exit 0 (0.041s); stdout `'a18d99c65c281cd409393cda069092cbcce2a586\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-none.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=none", "-c", "core.fsyncMethod=fsync", "mktree"]`
  stdin: `'100644 blob a18d99c65c281cd409393cda069092cbcce2a586\tseed\n'`
  exit 0 (0.04s); stdout `'87d3c2a73ab7bb3a7c18882c4b50353b98d59ae2\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-none.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=none", "-c", "core.fsyncMethod=fsync", "commit-tree", "87d3c2a73ab7bb3a7c18882c4b50353b98d59ae2", "-m", "c1"]`
  exit 0 (0.055s); stdout `'762ef36ea75478128c900e0b28adb9107d16c31f\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-none.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=none", "-c", "core.fsyncMethod=fsync", "update-ref", "refs/heads/main", "762ef36ea75478128c900e0b28adb9107d16c31f", ""]`
  exit 0 (0.06s); stdout `''`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-none.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=none", "-c", "core.fsyncMethod=fsync", "pack-refs", "--all"]`
  exit 0 (0.054s); stdout `''`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-none.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=none", "-c", "core.fsyncMethod=fsync", "commit-tree", "c279de92c97c91e2bc6e23dc9ac299f720260e64", "-p", "abf60a6f5b379820fc4c1bde5e8094641743b231", "-m", "c3"]`
  exit 0 (0.054s); stdout `'5c1da5a3e25a85849cb818022bccb1ac234ae3d2\n'`; stderr `''`
- `["git", "-c", "init.defaultBranch=main", "init", "--bare", "-q", "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-default.git"]`
  exit 0 (0.059s); stdout `''`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-default.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsyncMethod=fsync", "hash-object", "-w", "--stdin"]`
  stdin: `'seed\n'`
  exit 0 (0.042s); stdout `'a18d99c65c281cd409393cda069092cbcce2a586\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-default.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsyncMethod=fsync", "mktree"]`
  stdin: `'100644 blob a18d99c65c281cd409393cda069092cbcce2a586\tseed\n'`
  exit 0 (0.047s); stdout `'87d3c2a73ab7bb3a7c18882c4b50353b98d59ae2\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-default.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsyncMethod=fsync", "commit-tree", "87d3c2a73ab7bb3a7c18882c4b50353b98d59ae2", "-m", "c1"]`
  exit 0 (0.054s); stdout `'762ef36ea75478128c900e0b28adb9107d16c31f\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-default.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsyncMethod=fsync", "update-ref", "refs/heads/main", "762ef36ea75478128c900e0b28adb9107d16c31f", ""]`
  exit 0 (0.062s); stdout `''`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-default.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsyncMethod=fsync", "pack-refs", "--all"]`
  exit 0 (0.059s); stdout `''`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-default.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsyncMethod=fsync", "commit-tree", "c279de92c97c91e2bc6e23dc9ac299f720260e64", "-p", "abf60a6f5b379820fc4c1bde5e8094641743b231", "-m", "c3"]`
  exit 0 (0.053s); stdout `'5c1da5a3e25a85849cb818022bccb1ac234ae3d2\n'`; stderr `''`
- `["git", "-c", "init.defaultBranch=main", "init", "--bare", "-q", "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git"]`
  exit 0 (0.067s); stdout `''`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "hash-object", "-w", "--stdin"]`
  stdin: `'a\n'`
  exit 0 (0.047s); stdout `'533790e525dfeb785a02edfceeb1c7d120972c0d\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "mktree"]`
  stdin: `'100644 blob 533790e525dfeb785a02edfceeb1c7d120972c0d\ta\n'`
  exit 0 (0.048s); stdout `'ee20fe16e08b79e509121f13a8c5536e62a72219\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "commit-tree", "ee20fe16e08b79e509121f13a8c5536e62a72219", "-m", "c1"]`
  exit 0 (0.056s); stdout `'76a929d6149bf976fdabe132ea931177d270aad1\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "commit-tree", "ee20fe16e08b79e509121f13a8c5536e62a72219", "-p", "76a929d6149bf976fdabe132ea931177d270aad1", "-m", "c2"]`
  exit 0 (0.058s); stdout `'a01825e742be899d2ae5aa4462c132f017b13009\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "commit-tree", "ee20fe16e08b79e509121f13a8c5536e62a72219", "-p", "a01825e742be899d2ae5aa4462c132f017b13009", "-m", "c3"]`
  exit 0 (0.054s); stdout `'4fcba9db5992d73ac170c118d38a9db997120e5d\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "commit-tree", "ee20fe16e08b79e509121f13a8c5536e62a72219", "-p", "4fcba9db5992d73ac170c118d38a9db997120e5d", "-m", "c4"]`
  exit 0 (0.061s); stdout `'95406b63c3644f71090fad07323458e871e4d231\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "update-ref", "refs/heads/main", "76a929d6149bf976fdabe132ea931177d270aad1", ""]`
  exit 0 (0.055s); stdout `''`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "commit-tree", "ee20fe16e08b79e509121f13a8c5536e62a72219", "-m", "dangling"]`
  exit 0 (0.058s); stdout `'2f6a926cccf46e1d4afa0d884d2ff20f05abc63c\n'`; stderr `''`
- `["git", "-c", "init.defaultBranch=main", "init", "--bare", "-q", "--object-format=sha256", "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha256.git"]`
  exit 0 (0.083s); stdout `''`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha256.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "hash-object", "-w", "--stdin"]`
  stdin: `'a\n'`
  exit 0 (0.049s); stdout `'055e704cbf0ef7b88214832200c652c8dbcb43f929562444838cab115515ccfb\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha256.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "mktree"]`
  stdin: `'100644 blob 055e704cbf0ef7b88214832200c652c8dbcb43f929562444838cab115515ccfb\ta\n'`
  exit 0 (0.053s); stdout `'24edc7e2d84a365baee1e5cafa9c932fdac843a09be66d628bcff97fe49827e2\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha256.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "commit-tree", "24edc7e2d84a365baee1e5cafa9c932fdac843a09be66d628bcff97fe49827e2", "-m", "c1"]`
  exit 0 (0.042s); stdout `'fcb060df3f1a73de968c43a6a9637d7138e10d880a0a9e720615b27627088d49\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha256.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "commit-tree", "24edc7e2d84a365baee1e5cafa9c932fdac843a09be66d628bcff97fe49827e2", "-p", "fcb060df3f1a73de968c43a6a9637d7138e10d880a0a9e720615b27627088d49", "-m", "c2"]`
  exit 0 (0.044s); stdout `'9967d4c65db1301cb7622a95939ed9a3e5e5a9718c6a26b7b6758778fdc75da4\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha256.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "commit-tree", "24edc7e2d84a365baee1e5cafa9c932fdac843a09be66d628bcff97fe49827e2", "-p", "9967d4c65db1301cb7622a95939ed9a3e5e5a9718c6a26b7b6758778fdc75da4", "-m", "c3"]`
  exit 0 (0.048s); stdout `'fa9c35e14b19d62dcfdbd28c08eaf8ce0c13b38eb9a4b92846d08dba710e1ccd\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha256.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "commit-tree", "24edc7e2d84a365baee1e5cafa9c932fdac843a09be66d628bcff97fe49827e2", "-p", "fa9c35e14b19d62dcfdbd28c08eaf8ce0c13b38eb9a4b92846d08dba710e1ccd", "-m", "c4"]`
  exit 0 (0.042s); stdout `'5c65da32af2106dff2df018556496d7ff39bb6c593d4ca6195235b61f1e531fd\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha256.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "update-ref", "refs/heads/main", "fcb060df3f1a73de968c43a6a9637d7138e10d880a0a9e720615b27627088d49", ""]`
  exit 0 (0.049s); stdout `''`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha256.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "commit-tree", "24edc7e2d84a365baee1e5cafa9c932fdac843a09be66d628bcff97fe49827e2", "-m", "dangling"]`
  exit 0 (0.075s); stdout `'fb05402e8f6920c206369cf38641a762e36cb53bc36c732b5534e4f04df60dea\n'`; stderr `''`

## Q1. Product Git invocation
`git --version`: `git version 2.55.0.windows.3`.

`internal/core/workspace/git.go:68-76`
```go
68: func repositoryEnvironment(host []string, colony string) []string {
69: 	var out []string
70: 	for _, s := range host {
71: 		if !strings.HasPrefix(envKey(s), "GIT_") {
72: 			out = append(out, s)
73: 		}
74: 	}
75: 	return append(out, "GIT_CONFIG_NOSYSTEM=1", "GIT_CONFIG_GLOBAL="+filepath.Join(colony, "workspaces", "empty"), "GIT_NO_REPLACE_OBJECTS=1", "GIT_TERMINAL_PROMPT=0", "GIT_OPTIONAL_LOCKS=0")
76: }
```
`internal/core/workspace/git.go:97-120`
```go
97: func (g *gitRunner) run(ctx context.Context, dir string, env []string, in io.Reader, exits []int, args ...string) ([]byte, int, error) {
98: 	var out bytes.Buffer
99: 	exit, err := g.runOutput(ctx, dir, env, in, &out, exits, args...)
100: 	if err != nil {
101: 		return nil, exit, err
102: 	}
103: 	return out.Bytes(), exit, nil
104: }
105: 
106: // runOutput streams stdout to the caller while preserving run's process,
107: // cancellation, exit-code and stderr rules. It never buffers object bodies.
108: func (g *gitRunner) runOutput(ctx context.Context, dir string, env []string, in io.Reader, out io.Writer, exits []int, args ...string) (int, error) {
109: 	if g.unavailable != nil {
110: 		return -1, g.unavailable
111: 	}
112: 	cmd := exec.CommandContext(ctx, g.path, args...)
113: 	cmd.Dir = dir
114: 	cmd.Env = env
115: 	cmd.Stdin = in
116: 	cmd.WaitDelay = 5 * time.Second
117: 	var stderr limitedStderr
118: 	cmd.Stdout = out
119: 	cmd.Stderr = &stderr
120: 	err := cmd.Run()
```
`internal/core/workspace/git.go:148-151`
```go
148: func (g *gitRunner) repository(ctx context.Context, colony, common string, in io.Reader, exits []int, args ...string) ([]byte, int, error) {
149: 	prefix := []string{"--git-dir=" + common, "-c", "core.hooksPath=" + filepath.Join(colony, "workspaces", "nohooks"), "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync"}
150: 	return g.run(ctx, "", repositoryEnvironment(g.environ(), colony), in, exits, append(prefix, args...)...)
151: }
```

## Q2. What `core.fsync=committed` covers (Git for Windows v2.55.0.windows.3)
### Documentation
https://github.com/git-for-windows/git/blob/v2.55.0.windows.3/Documentation/config/core.adoc#L648-L704
```
648: core.fsync::
649: 	A comma-separated list of components of the repository that
650: 	should be hardened via the core.fsyncMethod when created or
651: 	modified.  You can disable hardening of any component by
652: 	prefixing it with a '-'.  Items that are not hardened may be
653: 	lost in the event of an unclean	system shutdown. Unless you
654: 	have special requirements, it is recommended that you leave
655: 	this option empty or pick one of `committed`, `added`,
656: 	or `all`.
657: +
658: When this configuration is encountered, the set of components starts with
659: the platform default value, disabled components are removed, and additional
660: components are added. `none` resets the state so that the platform default
661: is ignored.
662: +
663: The empty string resets the fsync configuration to the platform
664: default. The default on most platforms is equivalent to
665: `core.fsync=committed,-loose-object`, which has good performance,
666: but risks losing recent work in the event of an unclean system shutdown.
667: +
668: * `none` clears the set of fsynced components.
669: * `loose-object` hardens objects added to the repo in loose-object form.
670: * `pack` hardens objects added to the repo in packfile form.
671: * `pack-metadata` hardens packfile bitmaps and indexes.
672: * `commit-graph` hardens the commit-graph file.
673: * `index` hardens the index when it is modified.
674: * `objects` is an aggregate option that is equivalent to
675:   `loose-object,pack`.
676: * `reference` hardens references modified in the repo.
677: * `derived-metadata` is an aggregate option that is equivalent to
678:   `pack-metadata,commit-graph`.
679: * `committed` is an aggregate option that is currently equivalent to
680:   `objects`. This mode sacrifices some performance to ensure that work
681:   that is committed to the repository with `git commit` or similar commands
682:   is hardened.
683: * `added` is an aggregate option that is currently equivalent to
684:   `committed,index`. This mode sacrifices additional performance to
685:   ensure that the results of commands like `git add` and similar operations
686:   are hardened.
687: * `all` is an aggregate option that syncs all individual components above.
688: 
689: core.fsyncMethod::
690: 	A value indicating the strategy Git will use to harden repository data
691: 	using fsync and related primitives.
692: +
693: * `fsync` uses the fsync() system call or platform equivalents.
694: * `writeout-only` issues pagecache writeback requests, but depending on the
695:   filesystem and storage hardware, data added to the repository may not be
696:   durable in the event of a system crash. This is the default mode on macOS.
697: * `batch` enables a mode that uses writeout-only flushes to stage multiple
698:   updates in the disk writeback cache and then does a single full fsync of
699:   a dummy file to trigger the disk cache flush at the end of the operation.
700: +
701: Currently `batch` mode only applies to loose-object files. Other repository
702: data is made durable as if `fsync` was specified. This mode is expected to
703: be as safe as `fsync` on macOS for repos stored on HFS+ or APFS filesystems
704: and on Windows for repos stored on NTFS or ReFS filesystems.
```
### Aggregate → component mapping
https://github.com/git-for-windows/git/blob/v2.55.0.windows.3/write-or-die.h#L16-L53
```
16: enum fsync_component {
17: 	FSYNC_COMPONENT_NONE,
18: 	FSYNC_COMPONENT_LOOSE_OBJECT		= 1 << 0,
19: 	FSYNC_COMPONENT_PACK			= 1 << 1,
20: 	FSYNC_COMPONENT_PACK_METADATA		= 1 << 2,
21: 	FSYNC_COMPONENT_COMMIT_GRAPH		= 1 << 3,
22: 	FSYNC_COMPONENT_INDEX			= 1 << 4,
23: 	FSYNC_COMPONENT_REFERENCE		= 1 << 5,
24: 	FSYNC_COMPONENT_OBJECT_MAP		= 1 << 6,
25: };
26: 
27: #define FSYNC_COMPONENTS_OBJECTS (FSYNC_COMPONENT_LOOSE_OBJECT | \
28: 				  FSYNC_COMPONENT_PACK)
29: 
30: #define FSYNC_COMPONENTS_DERIVED_METADATA (FSYNC_COMPONENT_PACK_METADATA | \
31: 					   FSYNC_COMPONENT_COMMIT_GRAPH)
32: 
33: #define FSYNC_COMPONENTS_DEFAULT ((FSYNC_COMPONENTS_OBJECTS | \
34: 				   FSYNC_COMPONENTS_DERIVED_METADATA) & \
35: 				  ~FSYNC_COMPONENT_LOOSE_OBJECT)
36: 
37: #define FSYNC_COMPONENTS_COMMITTED (FSYNC_COMPONENTS_OBJECTS | \
38: 				    FSYNC_COMPONENT_REFERENCE)
39: 
40: #define FSYNC_COMPONENTS_ADDED (FSYNC_COMPONENTS_COMMITTED | \
41: 				FSYNC_COMPONENT_INDEX)
42: 
43: #define FSYNC_COMPONENTS_ALL (FSYNC_COMPONENT_LOOSE_OBJECT | \
44: 			      FSYNC_COMPONENT_PACK | \
45: 			      FSYNC_COMPONENT_PACK_METADATA | \
46: 			      FSYNC_COMPONENT_COMMIT_GRAPH | \
47: 			      FSYNC_COMPONENT_INDEX | \
48: 			      FSYNC_COMPONENT_REFERENCE | \
49: 			      FSYNC_COMPONENT_OBJECT_MAP)
50: 
51: #ifndef FSYNC_COMPONENTS_PLATFORM_DEFAULT
52: #define FSYNC_COMPONENTS_PLATFORM_DEFAULT FSYNC_COMPONENTS_DEFAULT
53: #endif
```
https://github.com/git-for-windows/git/blob/v2.55.0.windows.3/environment.c#L220-L235
```
220: static const struct fsync_component_name {
221: 	const char *name;
222: 	enum fsync_component component_bits;
223: } fsync_component_names[] = {
224: 	{ "loose-object", FSYNC_COMPONENT_LOOSE_OBJECT },
225: 	{ "pack", FSYNC_COMPONENT_PACK },
226: 	{ "pack-metadata", FSYNC_COMPONENT_PACK_METADATA },
227: 	{ "commit-graph", FSYNC_COMPONENT_COMMIT_GRAPH },
228: 	{ "index", FSYNC_COMPONENT_INDEX },
229: 	{ "objects", FSYNC_COMPONENTS_OBJECTS },
230: 	{ "reference", FSYNC_COMPONENT_REFERENCE },
231: 	{ "derived-metadata", FSYNC_COMPONENTS_DERIVED_METADATA },
232: 	{ "committed", FSYNC_COMPONENTS_COMMITTED },
233: 	{ "added", FSYNC_COMPONENTS_ADDED },
234: 	{ "all", FSYNC_COMPONENTS_ALL },
235: };
```
https://github.com/git-for-windows/git/blob/v2.55.0.windows.3/environment.c#L237-L291
```
237: static enum fsync_component parse_fsync_components(const char *var, const char *string)
238: {
239: 	enum fsync_component current = FSYNC_COMPONENTS_PLATFORM_DEFAULT;
240: 	enum fsync_component positive = 0, negative = 0;
241: 
242: 	while (string) {
243: 		size_t len;
244: 		const char *ep;
245: 		int negated = 0;
246: 		int found = 0;
247: 
248: 		string = string + strspn(string, ", \t\n\r");
249: 		ep = strchrnul(string, ',');
250: 		len = ep - string;
251: 		if (!strcmp(string, "none")) {
252: 			current = FSYNC_COMPONENT_NONE;
253: 			goto next_name;
254: 		}
255: 
256: 		if (*string == '-') {
257: 			negated = 1;
258: 			string++;
259: 			len--;
260: 			if (!len)
261: 				warning(_("invalid value for variable %s"), var);
262: 		}
263: 
264: 		if (!len)
265: 			break;
266: 
267: 		for (size_t i = 0; i < ARRAY_SIZE(fsync_component_names); ++i) {
268: 			const struct fsync_component_name *n = &fsync_component_names[i];
269: 
270: 			if (strncmp(n->name, string, len))
271: 				continue;
272: 
273: 			found = 1;
274: 			if (negated)
275: 				negative |= n->component_bits;
276: 			else
277: 				positive |= n->component_bits;
278: 		}
279: 
280: 		if (!found) {
281: 			char *component = xstrndup(string, len);
282: 			warning(_("ignoring unknown core.fsync component '%s'"), component);
283: 			free(component);
284: 		}
285: 
286: next_name:
287: 		string = ep;
288: 	}
289: 
290: 	return (current & ~negative) | positive;
291: }
```
https://github.com/git-for-windows/git/blob/v2.55.0.windows.3/environment.c#L475-L494
```
475: 	if (!strcmp(var, "core.fsync")) {
476: 		if (!value)
477: 			return config_error_nonbool(var);
478: 		fsync_components = parse_fsync_components(var, value);
479: 		return 0;
480: 	}
481: 
482: 	if (!strcmp(var, "core.fsyncmethod")) {
483: 		if (!value)
484: 			return config_error_nonbool(var);
485: 		if (!strcmp(value, "fsync"))
486: 			fsync_method = FSYNC_METHOD_FSYNC;
487: 		else if (!strcmp(value, "writeout-only"))
488: 			fsync_method = FSYNC_METHOD_WRITEOUT_ONLY;
489: 		else if (!strcmp(value, "batch"))
490: 			fsync_method = FSYNC_METHOD_BATCH;
491: 		else
492: 			warning(_("ignoring unknown core.fsyncMethod value '%s'"), value);
493: 
494: 	}
```
### Hardening call sites
https://github.com/git-for-windows/git/blob/v2.55.0.windows.3/write-or-die.c#L58-L89
```
58: static int maybe_fsync(int fd)
59: {
60: 	if (use_fsync < 0)
61: 		use_fsync = git_env_bool("GIT_TEST_FSYNC", 1);
62: 	if (!use_fsync)
63: 		return 0;
64: 
65: 	if (fsync_method == FSYNC_METHOD_WRITEOUT_ONLY &&
66: 	    git_fsync(fd, FSYNC_WRITEOUT_ONLY) >= 0)
67: 		return 0;
68: 
69: 	return git_fsync(fd, FSYNC_HARDWARE_FLUSH);
70: }
71: 
72: void fsync_or_die(int fd, const char *msg)
73: {
74: 	if (maybe_fsync(fd) < 0)
75: 		die_errno("fsync error on '%s'", msg);
76: }
77: 
78: int fsync_component(enum fsync_component component, int fd)
79: {
80: 	if (fsync_components & component)
81: 		return maybe_fsync(fd);
82: 	return 0;
83: }
84: 
85: void fsync_component_or_die(enum fsync_component component, int fd, const char *msg)
86: {
87: 	if (fsync_components & component)
88: 		fsync_or_die(fd, msg);
89: }
```
https://github.com/git-for-windows/git/blob/v2.55.0.windows.3/wrapper.c#L538-L599
```
538: static int fsync_loop(int fd)
539: {
540: 	int err;
541: 
542: 	do {
543: 		err = fsync(fd);
544: 	} while (err < 0 && errno == EINTR);
545: 	return err;
546: }
547: 
548: int git_fsync(int fd, enum fsync_action action)
549: {
550: 	switch (action) {
551: 	case FSYNC_WRITEOUT_ONLY:
552: 		trace2_counter_add(TRACE2_COUNTER_ID_FSYNC_WRITEOUT_ONLY, 1);
553: 
554: #ifdef __APPLE__
555: 		/*
556: 		 * On macOS, fsync just causes filesystem cache writeback but
557: 		 * does not flush hardware caches.
558: 		 */
559: 		return fsync_loop(fd);
560: #endif
561: 
562: #ifdef HAVE_SYNC_FILE_RANGE
563: 		/*
564: 		 * On linux 2.6.17 and above, sync_file_range is the way to
565: 		 * issue a writeback without a hardware flush. An offset of
566: 		 * 0 and size of 0 indicates writeout of the entire file and the
567: 		 * wait flags ensure that all dirty data is written to the disk
568: 		 * (potentially in a disk-side cache) before we continue.
569: 		 */
570: 
571: 		return sync_file_range(fd, 0, 0, SYNC_FILE_RANGE_WAIT_BEFORE |
572: 						 SYNC_FILE_RANGE_WRITE |
573: 						 SYNC_FILE_RANGE_WAIT_AFTER);
574: #endif
575: 
576: #ifdef fsync_no_flush
577: 		return fsync_no_flush(fd);
578: #endif
579: 
580: 		errno = ENOSYS;
581: 		return -1;
582: 
583: 	case FSYNC_HARDWARE_FLUSH:
584: 		trace2_counter_add(TRACE2_COUNTER_ID_FSYNC_HARDWARE_FLUSH, 1);
585: 
586: 		/*
587: 		 * On macOS, a special fcntl is required to really flush the
588: 		 * caches within the storage controller. As of this writing,
589: 		 * this is a very expensive operation on Apple SSDs.
590: 		 */
591: #ifdef __APPLE__
592: 		return fcntl(fd, F_FULLFSYNC);
593: #else
594: 		return fsync_loop(fd);
595: #endif
596: 	default:
597: 		BUG("unexpected git_fsync(%d) call", action);
598: 	}
599: }
```
Loose objects:
https://github.com/git-for-windows/git/blob/v2.55.0.windows.3/object-file.c#L578-L595
```
578: static void close_loose_object(struct odb_source_loose *loose,
579: 			       int fd, const char *filename)
580: {
581: 	if (loose->base.will_destroy)
582: 		goto out;
583: 
584: 	if (batch_fsync_enabled(FSYNC_COMPONENT_LOOSE_OBJECT))
585: 		fsync_loose_object_transaction(loose->base.odb->transaction, fd, filename);
586: 	else if (fsync_object_files > 0)
587: 		fsync_or_die(fd, filename);
588: 	else
589: 		fsync_component_or_die(FSYNC_COMPONENT_LOOSE_OBJECT, fd,
590: 				       filename);
591: 
592: out:
593: 	if (close(fd) != 0)
594: 		die_errno(_("error when closing loose object file"));
595: }
```
Loose ref (written into `<ref>.lock` before rename):
https://github.com/git-for-windows/git/blob/v2.55.0.windows.3/refs/files-backend.c#L2005-L2024
```
2005: static enum ref_transaction_error write_ref_to_lockfile(struct files_ref_store *refs,
2006: 							struct ref_lock *lock,
2007: 							const struct object_id *oid,
2008: 							struct strbuf *err)
2009: {
2010: 	static char term = '\n';
2011: 	int fd;
2012: 
2013: 	fd = get_lock_file_fd(&lock->lk);
2014: 	if (write_in_full(fd, oid_to_hex(oid), refs->base.repo->hash_algo->hexsz) < 0 ||
2015: 	    write_in_full(fd, &term, 1) < 0 ||
2016: 	    fsync_component(FSYNC_COMPONENT_REFERENCE, get_lock_file_fd(&lock->lk)) < 0 ||
2017: 	    close_ref_gently(lock) < 0) {
2018: 		strbuf_addf(err,
2019: 			    "couldn't write '%s'", get_lock_file_path(&lock->lk));
2020: 		unlock_ref(lock);
2021: 		return REF_TRANSACTION_ERROR_GENERIC;
2022: 	}
2023: 	return 0;
2024: }
```
Packed refs (temp file before rename):
https://github.com/git-for-windows/git/blob/v2.55.0.windows.3/refs/packed-backend.c#L1551-L1560
```
1551: 	if (fflush(out) ||
1552: 	    fsync_component(FSYNC_COMPONENT_REFERENCE, get_tempfile_fd(refs->tempfile)) ||
1553: 	    close_tempfile_gently(refs->tempfile)) {
1554: 		strbuf_addf(err, "error closing file %s: %s",
1555: 			    get_tempfile_path(refs->tempfile),
1556: 			    strerror(errno));
1557: 		strbuf_release(&sb);
1558: 		delete_tempfile(&refs->tempfile);
1559: 		return REF_TRANSACTION_ERROR_GENERIC;
1560: 	}
```
### Windows mapping
https://github.com/git-for-windows/git/blob/v2.55.0.windows.3/compat/mingw-posix.h#L132-L133
```
132: static inline int fsync(int fd)
133: { return _commit(fd); }
```
https://github.com/git-for-windows/git/blob/v2.55.0.windows.3/compat/mingw-posix.h#L321-L325
```
321: int win32_fsync_no_flush(int fd);
322: #define fsync_no_flush win32_fsync_no_flush
323: 
324: #define FSYNC_COMPONENTS_PLATFORM_DEFAULT (FSYNC_COMPONENTS_DEFAULT | FSYNC_COMPONENT_LOOSE_OBJECT)
325: #define FSYNC_METHOD_DEFAULT (FSYNC_METHOD_BATCH)
```
https://github.com/git-for-windows/git/blob/v2.55.0.windows.3/compat/win32/flush.c#L5-L30
```
5: int win32_fsync_no_flush(int fd)
6: {
7:        IO_STATUS_BLOCK io_status;
8: 
9: #ifndef FLUSH_FLAGS_FILE_DATA_ONLY
10: #define FLUSH_FLAGS_FILE_DATA_ONLY 1
11: #endif
12: 
13:        DECLARE_PROC_ADDR(ntdll.dll, NTSTATUS, NTAPI, NtFlushBuffersFileEx,
14: 			 HANDLE FileHandle, ULONG Flags, PVOID Parameters, ULONG ParameterSize,
15: 			 PIO_STATUS_BLOCK IoStatusBlock);
16: 
17:        if (!INIT_PROC_ADDR(NtFlushBuffersFileEx)) {
18: 		errno = ENOSYS;
19: 		return -1;
20:        }
21: 
22:        memset(&io_status, 0, sizeof(io_status));
23:        if (NtFlushBuffersFileEx((HANDLE)_get_osfhandle(fd), FLUSH_FLAGS_FILE_DATA_ONLY,
24: 				NULL, 0, &io_status)) {
25: 		errno = EINVAL;
26: 		return -1;
27:        }
28: 
29:        return 0;
30: }
```
https://github.com/git-for-windows/git/blob/v2.55.0.windows.3/git-compat-util.h#L1064-L1070
```
1064: #ifndef FSYNC_METHOD_DEFAULT
1065: #ifdef __APPLE__
1066: #define FSYNC_METHOD_DEFAULT FSYNC_METHOD_WRITEOUT_ONLY
1067: #else
1068: #define FSYNC_METHOD_DEFAULT FSYNC_METHOD_FSYNC
1069: #endif
1070: #endif
```
Git for Windows forces loose-object fsync at startup:
https://github.com/git-for-windows/git/blob/v2.55.0.windows.3/compat/mingw.c#L4416-L4420
```
4416: 	SetConsoleCtrlHandler(handle_ctrl_c, TRUE);
4417: 
4418: 	maybe_redirect_std_handles();
4419: 	adjust_symlink_flags();
4420: 	fsync_object_files = 1;
```

**Does `committed` include `reference`?** Code: yes — `FSYNC_COMPONENTS_COMMITTED (FSYNC_COMPONENTS_OBJECTS | FSYNC_COMPONENT_REFERENCE)` (write-or-die.h:37-38). The documentation text at this tag says `committed` is "currently equivalent to `objects`" (core.adoc:679-680), which disagrees with the code. Parsing: `committed` resolves to platform default | loose-object | pack | reference; `objects,reference` resolves to platform default | loose-object | pack | reference. On Windows the platform default is `pack | pack-metadata | commit-graph | loose-object` (mingw-posix.h:324 with write-or-die.h:33-35), so both settings yield the identical set: loose-object, pack, pack-metadata, commit-graph, reference. Measured identical in Q3.

## Q3. Measured fsync counters (trace2 event `counter` records, category `fsync`)
Per setting, a fresh bare repo was seeded (setup records above), then each traced command ran once. Only `counter` events mention fsync; no fsync regions appear. Each trace had 8–9 event lines. `writeout-only` never appears.

| core.fsync | hash-object -w | mktree | commit-tree | update-ref (loose) | update-ref (packed) |
|---|---|---|---|---|---|
| `committed` | hardware-flush=1 | hardware-flush=1 | hardware-flush=1 | hardware-flush=1 | hardware-flush=1 |
| `objects,reference` | hardware-flush=1 | hardware-flush=1 | hardware-flush=1 | hardware-flush=1 | hardware-flush=1 |
| `none` | hardware-flush=1 | hardware-flush=1 | hardware-flush=1 | — | — |
| `(core.fsync unset)` | hardware-flush=1 | hardware-flush=1 | hardware-flush=1 | — | — |

Raw counter lines (one per command; `—` rows had no counter event):
```
[committed] hash-object -w --stdin exit=0: {"event":"counter","sid":"20261013T174754.417546Z-Hfb65e3c5-P00001b84","thread":"main","time":"2026-10-13T17:47:54.453151Z","file":"trace2/tr2_tgt_event.c","line":678,"category":"fsync","name":"hardware-flush","count":1}
[committed] mktree exit=0: {"event":"counter","sid":"20261013T174754.517722Z-Hfb65e3c5-P000036c8","thread":"main","time":"2026-10-13T17:47:54.553838Z","file":"trace2/tr2_tgt_event.c","line":678,"category":"fsync","name":"hardware-flush","count":1}
[committed] commit-tree exit=0: {"event":"counter","sid":"20261013T174754.621127Z-Hfb65e3c5-P00001e80","thread":"main","time":"2026-10-13T17:47:54.666058Z","file":"trace2/tr2_tgt_event.c","line":678,"category":"fsync","name":"hardware-flush","count":1}
[committed] update-ref (loose) exit=0: {"event":"counter","sid":"20261013T174754.727871Z-Hfb65e3c5-P00001908","thread":"main","time":"2026-10-13T17:47:54.771272Z","file":"trace2/tr2_tgt_event.c","line":678,"category":"fsync","name":"hardware-flush","count":1}
[committed] update-ref (packed) exit=0: {"event":"counter","sid":"20261013T174754.968204Z-Hfb65e3c5-P00003218","thread":"main","time":"2026-10-13T17:47:55.003588Z","file":"trace2/tr2_tgt_event.c","line":678,"category":"fsync","name":"hardware-flush","count":1}
[objects,reference] hash-object -w --stdin exit=0: {"event":"counter","sid":"20261013T174755.387483Z-Hfb65e3c5-P000017b8","thread":"main","time":"2026-10-13T17:47:55.423578Z","file":"trace2/tr2_tgt_event.c","line":678,"category":"fsync","name":"hardware-flush","count":1}
[objects,reference] mktree exit=0: {"event":"counter","sid":"20261013T174755.487448Z-Hfb65e3c5-P00000c34","thread":"main","time":"2026-10-13T17:47:55.519208Z","file":"trace2/tr2_tgt_event.c","line":678,"category":"fsync","name":"hardware-flush","count":1}
[objects,reference] commit-tree exit=0: {"event":"counter","sid":"20261013T174755.579529Z-Hfb65e3c5-P000004f0","thread":"main","time":"2026-10-13T17:47:55.615707Z","file":"trace2/tr2_tgt_event.c","line":678,"category":"fsync","name":"hardware-flush","count":1}
[objects,reference] update-ref (loose) exit=0: {"event":"counter","sid":"20261013T174755.679055Z-Hfb65e3c5-P00001f20","thread":"main","time":"2026-10-13T17:47:55.714032Z","file":"trace2/tr2_tgt_event.c","line":678,"category":"fsync","name":"hardware-flush","count":1}
[objects,reference] update-ref (packed) exit=0: {"event":"counter","sid":"20261013T174755.910183Z-Hfb65e3c5-P000027f8","thread":"main","time":"2026-10-13T17:47:55.946415Z","file":"trace2/tr2_tgt_event.c","line":678,"category":"fsync","name":"hardware-flush","count":1}
[none] hash-object -w --stdin exit=0: {"event":"counter","sid":"20261013T174756.266651Z-Hfb65e3c5-P00002c30","thread":"main","time":"2026-10-13T17:47:56.306018Z","file":"trace2/tr2_tgt_event.c","line":678,"category":"fsync","name":"hardware-flush","count":1}
[none] mktree exit=0: {"event":"counter","sid":"20261013T174756.369792Z-Hfb65e3c5-P00003158","thread":"main","time":"2026-10-13T17:47:56.409831Z","file":"trace2/tr2_tgt_event.c","line":678,"category":"fsync","name":"hardware-flush","count":1}
[none] commit-tree exit=0: {"event":"counter","sid":"20261013T174756.476549Z-Hfb65e3c5-P000021d8","thread":"main","time":"2026-10-13T17:47:56.501824Z","file":"trace2/tr2_tgt_event.c","line":678,"category":"fsync","name":"hardware-flush","count":1}
[none] update-ref (loose) exit=0: (none)
[none] update-ref (packed) exit=0: (none)
[(core.fsync unset)] hash-object -w --stdin exit=0: {"event":"counter","sid":"20261013T174757.116151Z-Hfb65e3c5-P000004a8","thread":"main","time":"2026-10-13T17:47:57.147869Z","file":"trace2/tr2_tgt_event.c","line":678,"category":"fsync","name":"hardware-flush","count":1}
[(core.fsync unset)] mktree exit=0: {"event":"counter","sid":"20261013T174757.218000Z-Hfb65e3c5-P000026e0","thread":"main","time":"2026-10-13T17:47:57.249136Z","file":"trace2/tr2_tgt_event.c","line":678,"category":"fsync","name":"hardware-flush","count":1}
[(core.fsync unset)] commit-tree exit=0: {"event":"counter","sid":"20261013T174757.320354Z-Hfb65e3c5-P0000371c","thread":"main","time":"2026-10-13T17:47:57.347439Z","file":"trace2/tr2_tgt_event.c","line":678,"category":"fsync","name":"hardware-flush","count":1}
[(core.fsync unset)] update-ref (loose) exit=0: (none)
[(core.fsync unset)] update-ref (packed) exit=0: (none)
```
Command records:
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-committed.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "hash-object", "-w", "--stdin"]`
  extra env: `{"GIT_TRACE2_EVENT": "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\trace-5.json"}`
  stdin: `'x\n'`
  exit 0 (0.083s); stdout `'db127bf6be70c2285b1d852d39387a37b01c3032\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-committed.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "mktree"]`
  extra env: `{"GIT_TRACE2_EVENT": "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\trace-6.json"}`
  stdin: `'100644 blob db127bf6be70c2285b1d852d39387a37b01c3032\tx\n'`
  exit 0 (0.087s); stdout `'c279de92c97c91e2bc6e23dc9ac299f720260e64\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-committed.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "commit-tree", "c279de92c97c91e2bc6e23dc9ac299f720260e64", "-p", "762ef36ea75478128c900e0b28adb9107d16c31f", "-m", "c2"]`
  extra env: `{"GIT_TRACE2_EVENT": "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\trace-7.json"}`
  exit 0 (0.093s); stdout `'abf60a6f5b379820fc4c1bde5e8094641743b231\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-committed.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "update-ref", "refs/heads/main", "abf60a6f5b379820fc4c1bde5e8094641743b231", "762ef36ea75478128c900e0b28adb9107d16c31f"]`
  extra env: `{"GIT_TRACE2_EVENT": "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\trace-8.json"}`
  exit 0 (0.098s); stdout `''`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-committed.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "update-ref", "refs/heads/main", "5c1da5a3e25a85849cb818022bccb1ac234ae3d2", "abf60a6f5b379820fc4c1bde5e8094641743b231"]`
  extra env: `{"GIT_TRACE2_EVENT": "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\trace-11.json"}`
  exit 0 (0.083s); stdout `''`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-objects_reference.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=objects,reference", "-c", "core.fsyncMethod=fsync", "hash-object", "-w", "--stdin"]`
  extra env: `{"GIT_TRACE2_EVENT": "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\trace-17.json"}`
  stdin: `'x\n'`
  exit 0 (0.089s); stdout `'db127bf6be70c2285b1d852d39387a37b01c3032\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-objects_reference.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=objects,reference", "-c", "core.fsyncMethod=fsync", "mktree"]`
  extra env: `{"GIT_TRACE2_EVENT": "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\trace-18.json"}`
  stdin: `'100644 blob db127bf6be70c2285b1d852d39387a37b01c3032\tx\n'`
  exit 0 (0.076s); stdout `'c279de92c97c91e2bc6e23dc9ac299f720260e64\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-objects_reference.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=objects,reference", "-c", "core.fsyncMethod=fsync", "commit-tree", "c279de92c97c91e2bc6e23dc9ac299f720260e64", "-p", "762ef36ea75478128c900e0b28adb9107d16c31f", "-m", "c2"]`
  extra env: `{"GIT_TRACE2_EVENT": "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\trace-19.json"}`
  exit 0 (0.084s); stdout `'abf60a6f5b379820fc4c1bde5e8094641743b231\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-objects_reference.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=objects,reference", "-c", "core.fsyncMethod=fsync", "update-ref", "refs/heads/main", "abf60a6f5b379820fc4c1bde5e8094641743b231", "762ef36ea75478128c900e0b28adb9107d16c31f"]`
  extra env: `{"GIT_TRACE2_EVENT": "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\trace-20.json"}`
  exit 0 (0.086s); stdout `''`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-objects_reference.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=objects,reference", "-c", "core.fsyncMethod=fsync", "update-ref", "refs/heads/main", "5c1da5a3e25a85849cb818022bccb1ac234ae3d2", "abf60a6f5b379820fc4c1bde5e8094641743b231"]`
  extra env: `{"GIT_TRACE2_EVENT": "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\trace-23.json"}`
  exit 0 (0.094s); stdout `''`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-none.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=none", "-c", "core.fsyncMethod=fsync", "hash-object", "-w", "--stdin"]`
  extra env: `{"GIT_TRACE2_EVENT": "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\trace-29.json"}`
  stdin: `'x\n'`
  exit 0 (0.095s); stdout `'db127bf6be70c2285b1d852d39387a37b01c3032\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-none.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=none", "-c", "core.fsyncMethod=fsync", "mktree"]`
  extra env: `{"GIT_TRACE2_EVENT": "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\trace-30.json"}`
  stdin: `'100644 blob db127bf6be70c2285b1d852d39387a37b01c3032\tx\n'`
  exit 0 (0.088s); stdout `'c279de92c97c91e2bc6e23dc9ac299f720260e64\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-none.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=none", "-c", "core.fsyncMethod=fsync", "commit-tree", "c279de92c97c91e2bc6e23dc9ac299f720260e64", "-p", "762ef36ea75478128c900e0b28adb9107d16c31f", "-m", "c2"]`
  extra env: `{"GIT_TRACE2_EVENT": "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\trace-31.json"}`
  exit 0 (0.069s); stdout `'abf60a6f5b379820fc4c1bde5e8094641743b231\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-none.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=none", "-c", "core.fsyncMethod=fsync", "update-ref", "refs/heads/main", "abf60a6f5b379820fc4c1bde5e8094641743b231", "762ef36ea75478128c900e0b28adb9107d16c31f"]`
  extra env: `{"GIT_TRACE2_EVENT": "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\trace-32.json"}`
  exit 0 (0.07s); stdout `''`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-none.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=none", "-c", "core.fsyncMethod=fsync", "update-ref", "refs/heads/main", "5c1da5a3e25a85849cb818022bccb1ac234ae3d2", "abf60a6f5b379820fc4c1bde5e8094641743b231"]`
  extra env: `{"GIT_TRACE2_EVENT": "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\trace-35.json"}`
  exit 0 (0.085s); stdout `''`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-default.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsyncMethod=fsync", "hash-object", "-w", "--stdin"]`
  extra env: `{"GIT_TRACE2_EVENT": "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\trace-41.json"}`
  stdin: `'x\n'`
  exit 0 (0.078s); stdout `'db127bf6be70c2285b1d852d39387a37b01c3032\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-default.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsyncMethod=fsync", "mktree"]`
  extra env: `{"GIT_TRACE2_EVENT": "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\trace-42.json"}`
  stdin: `'100644 blob db127bf6be70c2285b1d852d39387a37b01c3032\tx\n'`
  exit 0 (0.084s); stdout `'c279de92c97c91e2bc6e23dc9ac299f720260e64\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-default.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsyncMethod=fsync", "commit-tree", "c279de92c97c91e2bc6e23dc9ac299f720260e64", "-p", "762ef36ea75478128c900e0b28adb9107d16c31f", "-m", "c2"]`
  extra env: `{"GIT_TRACE2_EVENT": "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\trace-43.json"}`
  exit 0 (0.076s); stdout `'abf60a6f5b379820fc4c1bde5e8094641743b231\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-default.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsyncMethod=fsync", "update-ref", "refs/heads/main", "abf60a6f5b379820fc4c1bde5e8094641743b231", "762ef36ea75478128c900e0b28adb9107d16c31f"]`
  extra env: `{"GIT_TRACE2_EVENT": "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\trace-44.json"}`
  exit 0 (0.069s); stdout `''`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-default.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsyncMethod=fsync", "update-ref", "refs/heads/main", "5c1da5a3e25a85849cb818022bccb1ac234ae3d2", "abf60a6f5b379820fc4c1bde5e8094641743b231"]`
  extra env: `{"GIT_TRACE2_EVENT": "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\trace-47.json"}`
  exit 0 (0.081s); stdout `''`; stderr `''`

Follow-up: why `core.fsync=none` still flushes loose objects (hash-object, same `none` repo):
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-none.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=none", "-c", "core.fsyncMethod=fsync", "hash-object", "-w", "--stdin"]`
  extra env: `{"GIT_TRACE2_EVENT": "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\x48.json"}`
  stdin: `'none{}\n'`
  exit 0 (0.08s); stdout `'97009ca6adae19ef05f50539763d3a4ca72cba09\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-none.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=none", "-c", "core.fsyncMethod=fsync", "hash-object", "-w", "--stdin"]`
  extra env: `{"GIT_TRACE2_EVENT": "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\x49.json", "GIT_TEST_FSYNC": "0"}`
  stdin: `"none{'GIT_TEST_FSYNC': '0'}\n"`
  exit 0 (0.08s); stdout `'68f7cc5de08dca738d8c1fbfb8d130fbf6ca3eda\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-none.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=none,-loose-object", "-c", "core.fsyncMethod=fsync", "hash-object", "-w", "--stdin"]`
  extra env: `{"GIT_TRACE2_EVENT": "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\x50.json"}`
  stdin: `'none,-loose-object{}\n'`
  exit 0 (0.08s); stdout `'6f7da5016ca0fb966a19115077cf7904190b971e\n'`; stderr `"warning: ignoring unknown core.fsync component 'none'\n"`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-none.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=none,-loose-object", "-c", "core.fsyncMethod=fsync", "hash-object", "-w", "--stdin"]`
  extra env: `{"GIT_TRACE2_EVENT": "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\x51.json", "GIT_TEST_FSYNC": "0"}`
  stdin: `"none,-loose-object{'GIT_TEST_FSYNC': '0'}\n"`
  exit 0 (0.087s); stdout `'c98a61b91137d4db6d823651d88cf9881aed328e\n'`; stderr `"warning: ignoring unknown core.fsync component 'none'\n"`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-none.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=-loose-object", "-c", "core.fsyncMethod=fsync", "hash-object", "-w", "--stdin"]`
  extra env: `{"GIT_TRACE2_EVENT": "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\x52.json"}`
  stdin: `'-loose-object{}\n'`
  exit 0 (0.087s); stdout `'ff08a7d15ba5d751c578820ff329ec52ece42210\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-none.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=-loose-object", "-c", "core.fsyncMethod=fsync", "hash-object", "-w", "--stdin"]`
  extra env: `{"GIT_TRACE2_EVENT": "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\x53.json", "GIT_TEST_FSYNC": "0"}`
  stdin: `"-loose-object{'GIT_TEST_FSYNC': '0'}\n"`
  exit 0 (0.08s); stdout `'1f89812f96d69fceff87f07f9cf64bf16aba09d5\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-none.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=-objects", "-c", "core.fsyncMethod=fsync", "hash-object", "-w", "--stdin"]`
  extra env: `{"GIT_TRACE2_EVENT": "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\x54.json"}`
  stdin: `'-objects{}\n'`
  exit 0 (0.093s); stdout `'15552717e00646257d0daf0c421085286894daf7\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-none.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=-objects", "-c", "core.fsyncMethod=fsync", "hash-object", "-w", "--stdin"]`
  extra env: `{"GIT_TRACE2_EVENT": "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\x55.json", "GIT_TEST_FSYNC": "0"}`
  stdin: `"-objects{'GIT_TEST_FSYNC': '0'}\n"`
  exit 0 (0.086s); stdout `'886882c1231e25084a2d5325d8bd52595da8534f\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q3-none.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=-loose-object", "-c", "core.fsyncMethod=fsync", "-c", "core.fsyncObjectFiles=false", "hash-object", "-w", "--stdin"]`
  extra env: `{"GIT_TRACE2_EVENT": "C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\x56.json"}`
  stdin: `'z9\n'`
  exit 0 (0.094s); stdout `'0a78f28ee8d0dc968c948597e2fea59238e13c7c\n'`; stderr `''`
Trace counter results for these: `none` → hardware-flush=1; with `GIT_TEST_FSYNC=0` → none; `none,-loose-object` (warns `none` unknown) → 1; `-loose-object` → 1; `-objects` → 1; `-loose-object` plus `-c core.fsyncObjectFiles=false` → none.

Bogus-setting update-ref traces (q4-sha1 repo):
- core.fsync=`bogus` core.fsyncMethod=`fsync`: exit 0, stderr `"warning: ignoring unknown core.fsync component 'bogus'\n"`, counters []
- core.fsync=`committed` core.fsyncMethod=`bogus`: exit 0, stderr `"warning: ignoring unknown core.fsyncMethod value 'bogus'\n"`, counters [{'category': 'fsync', 'name': 'hardware-flush', 'count': 1}]
- core.fsync=`committed` core.fsyncMethod=`fsync`: exit 0, stderr `''`, counters [{'category': 'fsync', 'name': 'hardware-flush', 'count': 1}]

## Q4. Guarded update-ref behaviour
Each step records exit, raw stdout/stderr, duration, and whether `refs/heads/main`, `refs/heads/main.lock`, `packed-refs` bytes changed. c1..c4 are a linear chain; main starts at c1.

### sha1 repo (c1=76a929d6149bf976fdabe132ea931177d270aad1, c2=a01825e742be899d2ae5aa4462c132f017b13009, c3=4fcba9db5992d73ac170c118d38a9db997120e5d, c4=95406b63c3644f71090fad07323458e871e4d231, dangling=2f6a926cccf46e1d4afa0d884d2ff20f05abc63c)
- **guarded loose ok**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "update-ref", "refs/heads/main", "a01825e742be899d2ae5aa4462c132f017b13009", "76a929d6149bf976fdabe132ea931177d270aad1"]` → exit 0 (0.058s); stdout `''`; stderr `''`; changed {'refs/heads/main': True, 'refs/heads/main.lock': False, 'packed-refs': False}
- **stale old loose**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "update-ref", "refs/heads/main", "4fcba9db5992d73ac170c118d38a9db997120e5d", "76a929d6149bf976fdabe132ea931177d270aad1"]` → exit 128 (0.049s); stdout `''`; stderr `"fatal: update_ref failed for ref 'refs/heads/main': cannot lock ref 'refs/heads/main': is at a01825e742be899d2ae5aa4462c132f017b13009 but expected 76a929d6149bf976fdabe132ea931177d270aad1\n"`; changed {'refs/heads/main': False, 'refs/heads/main.lock': False, 'packed-refs': False}
- **lock present loose**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "update-ref", "refs/heads/main", "4fcba9db5992d73ac170c118d38a9db997120e5d", "a01825e742be899d2ae5aa4462c132f017b13009"]` → exit 128 (0.247s); stdout `''`; stderr `"fatal: update_ref failed for ref 'refs/heads/main': cannot lock ref 'refs/heads/main': Unable to create 'C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git/refs/heads/main.lock': File exists.\n\nAnother git process seems to be running in this repository, or the lock file may be stale\n"`; changed {'refs/heads/main': False, 'refs/heads/main.lock': False, 'packed-refs': False}
- **pack-refs**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "pack-refs", "--all"]` → exit 0 (0.066s); stdout `''`; stderr `''`; changed {'refs/heads/main': True, 'refs/heads/main.lock': False, 'packed-refs': True}
- **guarded packed ok**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "update-ref", "refs/heads/main", "4fcba9db5992d73ac170c118d38a9db997120e5d", "a01825e742be899d2ae5aa4462c132f017b13009"]` → exit 0 (0.054s); stdout `''`; stderr `''`; changed {'refs/heads/main': True, 'refs/heads/main.lock': False, 'packed-refs': False}
- **pack-refs again**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "pack-refs", "--all"]` → exit 0 (0.047s); stdout `''`; stderr `''`; changed {'refs/heads/main': True, 'refs/heads/main.lock': False, 'packed-refs': True}
- **stale old packed**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "update-ref", "refs/heads/main", "95406b63c3644f71090fad07323458e871e4d231", "a01825e742be899d2ae5aa4462c132f017b13009"]` → exit 128 (0.048s); stdout `''`; stderr `"fatal: update_ref failed for ref 'refs/heads/main': cannot lock ref 'refs/heads/main': is at 4fcba9db5992d73ac170c118d38a9db997120e5d but expected a01825e742be899d2ae5aa4462c132f017b13009\n"`; changed {'refs/heads/main': False, 'refs/heads/main.lock': False, 'packed-refs': False}
- **lock present packed**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "update-ref", "refs/heads/main", "95406b63c3644f71090fad07323458e871e4d231", "4fcba9db5992d73ac170c118d38a9db997120e5d"]` → exit 128 (0.263s); stdout `''`; stderr `"fatal: update_ref failed for ref 'refs/heads/main': cannot lock ref 'refs/heads/main': Unable to create 'C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git/refs/heads/main.lock': File exists.\n\nAnother git process seems to be running in this repository, or the lock file may be stale\n"`; changed {'refs/heads/main': False, 'refs/heads/main.lock': False, 'packed-refs': False}
- **packed-refs.lock present, packed main**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "update-ref", "refs/heads/main", "95406b63c3644f71090fad07323458e871e4d231", "4fcba9db5992d73ac170c118d38a9db997120e5d"]` → exit 0 (0.068s); stdout `''`; stderr `''`; changed {'refs/heads/main': True, 'refs/heads/main.lock': False, 'packed-refs': False}
- **show-ref**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "show-ref"]` → exit 0 (0.062s); stdout `'95406b63c3644f71090fad07323458e871e4d231 refs/heads/main\n'`; stderr `''`; changed {'refs/heads/main': False, 'refs/heads/main.lock': False, 'packed-refs': False}
- **cat dangling before gc**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "cat-file", "-t", "2f6a926cccf46e1d4afa0d884d2ff20f05abc63c"]` → exit 0 (0.05s); stdout `'commit\n'`; stderr `''`; changed {'refs/heads/main': False, 'refs/heads/main.lock': False, 'packed-refs': False}
- **gc**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "gc", "--prune=now", "--quiet"]` → exit 0 (0.312s); stdout `''`; stderr `''`; changed {'refs/heads/main': True, 'refs/heads/main.lock': False, 'packed-refs': True}
- **cat main tip after gc**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "cat-file", "-t", "4fcba9db5992d73ac170c118d38a9db997120e5d"]` → exit 0 (0.056s); stdout `'commit\n'`; stderr `''`; changed {'refs/heads/main': False, 'refs/heads/main.lock': False, 'packed-refs': False}
- **cat c1 (ancestor) after gc**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "cat-file", "-t", "76a929d6149bf976fdabe132ea931177d270aad1"]` → exit 0 (0.045s); stdout `'commit\n'`; stderr `''`; changed {'refs/heads/main': False, 'refs/heads/main.lock': False, 'packed-refs': False}
- **cat dangling after gc**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "cat-file", "-t", "2f6a926cccf46e1d4afa0d884d2ff20f05abc63c"]` → exit 128 (0.046s); stdout `''`; stderr `'fatal: git cat-file: could not get object info\n'`; changed {'refs/heads/main': False, 'refs/heads/main.lock': False, 'packed-refs': False}
- **core.fsync=bogus**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=bogus", "-c", "core.fsyncMethod=fsync", "rev-parse", "refs/heads/main"]` → exit 0 (0.05s); stdout `'95406b63c3644f71090fad07323458e871e4d231\n'`; stderr `"warning: ignoring unknown core.fsync component 'bogus'\n"`
- **core.fsyncMethod=bogus**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=bogus", "rev-parse", "refs/heads/main"]` → exit 0 (0.05s); stdout `'95406b63c3644f71090fad07323458e871e4d231\n'`; stderr `"warning: ignoring unknown core.fsyncMethod value 'bogus'\n"`
- **core.fsync= (empty)**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=", "-c", "core.fsyncMethod=fsync", "rev-parse", "refs/heads/main"]` → exit 0 (0.048s); stdout `'95406b63c3644f71090fad07323458e871e4d231\n'`; stderr `''`
- **core.fsync=none,committed**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=none,committed", "-c", "core.fsyncMethod=fsync", "rev-parse", "refs/heads/main"]` → exit 0 (0.046s); stdout `'95406b63c3644f71090fad07323458e871e4d231\n'`; stderr `"warning: ignoring unknown core.fsync component 'none'\n"`
- **update-ref with core.fsync=bogus**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=bogus", "-c", "core.fsyncMethod=fsync", "update-ref", "refs/heads/main", "95406b63c3644f71090fad07323458e871e4d231", "4fcba9db5992d73ac170c118d38a9db997120e5d"]` → exit 128 (0.05s); stdout `''`; stderr `"warning: ignoring unknown core.fsync component 'bogus'\nfatal: update_ref failed for ref 'refs/heads/main': cannot lock ref 'refs/heads/main': is at 95406b63c3644f71090fad07323458e871e4d231 but expected 4fcba9db5992d73ac170c118d38a9db997120e5d\n"`
  before `{'refs/heads/main': None, 'refs/heads/main.lock': None, 'packed-refs': '# pack-refs with: peeled fully-peeled sorted \n95406b63c3644f71090fad07323458e871e4d231 refs/heads/main\n'}`
  after `{'refs/heads/main': None, 'refs/heads/main.lock': None, 'packed-refs': '# pack-refs with: peeled fully-peeled sorted \n95406b63c3644f71090fad07323458e871e4d231 refs/heads/main\n'}`
- **update-ref with core.fsyncMethod=bogus**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=bogus", "update-ref", "refs/heads/main", "4fcba9db5992d73ac170c118d38a9db997120e5d", "95406b63c3644f71090fad07323458e871e4d231"]` → exit 0 (0.071s); stdout `''`; stderr `"warning: ignoring unknown core.fsyncMethod value 'bogus'\n"`
  before `{'refs/heads/main': None, 'refs/heads/main.lock': None, 'packed-refs': '# pack-refs with: peeled fully-peeled sorted \n95406b63c3644f71090fad07323458e871e4d231 refs/heads/main\n'}`
  after `{'refs/heads/main': '4fcba9db5992d73ac170c118d38a9db997120e5d\n', 'refs/heads/main.lock': None, 'packed-refs': '# pack-refs with: peeled fully-peeled sorted \n95406b63c3644f71090fad07323458e871e4d231 refs/heads/main\n'}`
- **update-ref with core.fsync=bogus (correct old)**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=bogus", "-c", "core.fsyncMethod=fsync", "update-ref", "refs/heads/main", "95406b63c3644f71090fad07323458e871e4d231", "4fcba9db5992d73ac170c118d38a9db997120e5d"]` → exit 0 (0.049s); stdout `''`; stderr `"warning: ignoring unknown core.fsync component 'bogus'\n"`
  before `{'refs/heads/main': '4fcba9db5992d73ac170c118d38a9db997120e5d\n', 'refs/heads/main.lock': None, 'packed-refs': '# pack-refs with: peeled fully-peeled sorted \n95406b63c3644f71090fad07323458e871e4d231 refs/heads/main\n'}`
  after `{'refs/heads/main': '95406b63c3644f71090fad07323458e871e4d231\n', 'refs/heads/main.lock': None, 'packed-refs': '# pack-refs with: peeled fully-peeled sorted \n95406b63c3644f71090fad07323458e871e4d231 refs/heads/main\n'}`

### sha256 repo (c1=fcb060df3f1a73de968c43a6a9637d7138e10d880a0a9e720615b27627088d49, c2=9967d4c65db1301cb7622a95939ed9a3e5e5a9718c6a26b7b6758778fdc75da4, c3=fa9c35e14b19d62dcfdbd28c08eaf8ce0c13b38eb9a4b92846d08dba710e1ccd, c4=5c65da32af2106dff2df018556496d7ff39bb6c593d4ca6195235b61f1e531fd, dangling=fb05402e8f6920c206369cf38641a762e36cb53bc36c732b5534e4f04df60dea)
- **guarded loose ok**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha256.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "update-ref", "refs/heads/main", "9967d4c65db1301cb7622a95939ed9a3e5e5a9718c6a26b7b6758778fdc75da4", "fcb060df3f1a73de968c43a6a9637d7138e10d880a0a9e720615b27627088d49"]` → exit 0 (0.069s); stdout `''`; stderr `''`; changed {'refs/heads/main': True, 'refs/heads/main.lock': False, 'packed-refs': False}
- **stale old loose**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha256.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "update-ref", "refs/heads/main", "fa9c35e14b19d62dcfdbd28c08eaf8ce0c13b38eb9a4b92846d08dba710e1ccd", "fcb060df3f1a73de968c43a6a9637d7138e10d880a0a9e720615b27627088d49"]` → exit 128 (0.063s); stdout `''`; stderr `"fatal: update_ref failed for ref 'refs/heads/main': cannot lock ref 'refs/heads/main': is at 9967d4c65db1301cb7622a95939ed9a3e5e5a9718c6a26b7b6758778fdc75da4 but expected fcb060df3f1a73de968c43a6a9637d7138e10d880a0a9e720615b27627088d49\n"`; changed {'refs/heads/main': False, 'refs/heads/main.lock': False, 'packed-refs': False}
- **lock present loose**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha256.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "update-ref", "refs/heads/main", "fa9c35e14b19d62dcfdbd28c08eaf8ce0c13b38eb9a4b92846d08dba710e1ccd", "9967d4c65db1301cb7622a95939ed9a3e5e5a9718c6a26b7b6758778fdc75da4"]` → exit 128 (0.229s); stdout `''`; stderr `"fatal: update_ref failed for ref 'refs/heads/main': cannot lock ref 'refs/heads/main': Unable to create 'C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha256.git/refs/heads/main.lock': File exists.\n\nAnother git process seems to be running in this repository, or the lock file may be stale\n"`; changed {'refs/heads/main': False, 'refs/heads/main.lock': False, 'packed-refs': False}
- **pack-refs**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha256.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "pack-refs", "--all"]` → exit 0 (0.071s); stdout `''`; stderr `''`; changed {'refs/heads/main': True, 'refs/heads/main.lock': False, 'packed-refs': True}
- **guarded packed ok**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha256.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "update-ref", "refs/heads/main", "fa9c35e14b19d62dcfdbd28c08eaf8ce0c13b38eb9a4b92846d08dba710e1ccd", "9967d4c65db1301cb7622a95939ed9a3e5e5a9718c6a26b7b6758778fdc75da4"]` → exit 0 (0.05s); stdout `''`; stderr `''`; changed {'refs/heads/main': True, 'refs/heads/main.lock': False, 'packed-refs': False}
- **pack-refs again**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha256.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "pack-refs", "--all"]` → exit 0 (0.066s); stdout `''`; stderr `''`; changed {'refs/heads/main': True, 'refs/heads/main.lock': False, 'packed-refs': True}
- **stale old packed**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha256.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "update-ref", "refs/heads/main", "5c65da32af2106dff2df018556496d7ff39bb6c593d4ca6195235b61f1e531fd", "9967d4c65db1301cb7622a95939ed9a3e5e5a9718c6a26b7b6758778fdc75da4"]` → exit 128 (0.051s); stdout `''`; stderr `"fatal: update_ref failed for ref 'refs/heads/main': cannot lock ref 'refs/heads/main': is at fa9c35e14b19d62dcfdbd28c08eaf8ce0c13b38eb9a4b92846d08dba710e1ccd but expected 9967d4c65db1301cb7622a95939ed9a3e5e5a9718c6a26b7b6758778fdc75da4\n"`; changed {'refs/heads/main': False, 'refs/heads/main.lock': False, 'packed-refs': False}
- **lock present packed**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha256.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "update-ref", "refs/heads/main", "5c65da32af2106dff2df018556496d7ff39bb6c593d4ca6195235b61f1e531fd", "fa9c35e14b19d62dcfdbd28c08eaf8ce0c13b38eb9a4b92846d08dba710e1ccd"]` → exit 128 (0.227s); stdout `''`; stderr `"fatal: update_ref failed for ref 'refs/heads/main': cannot lock ref 'refs/heads/main': Unable to create 'C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha256.git/refs/heads/main.lock': File exists.\n\nAnother git process seems to be running in this repository, or the lock file may be stale\n"`; changed {'refs/heads/main': False, 'refs/heads/main.lock': False, 'packed-refs': False}
- **packed-refs.lock present, packed main**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha256.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "update-ref", "refs/heads/main", "5c65da32af2106dff2df018556496d7ff39bb6c593d4ca6195235b61f1e531fd", "fa9c35e14b19d62dcfdbd28c08eaf8ce0c13b38eb9a4b92846d08dba710e1ccd"]` → exit 0 (0.059s); stdout `''`; stderr `''`; changed {'refs/heads/main': True, 'refs/heads/main.lock': False, 'packed-refs': False}
- **show-ref**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha256.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "show-ref"]` → exit 0 (0.061s); stdout `'5c65da32af2106dff2df018556496d7ff39bb6c593d4ca6195235b61f1e531fd refs/heads/main\n'`; stderr `''`; changed {'refs/heads/main': False, 'refs/heads/main.lock': False, 'packed-refs': False}
- **cat dangling before gc**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha256.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "cat-file", "-t", "fb05402e8f6920c206369cf38641a762e36cb53bc36c732b5534e4f04df60dea"]` → exit 0 (0.046s); stdout `'commit\n'`; stderr `''`; changed {'refs/heads/main': False, 'refs/heads/main.lock': False, 'packed-refs': False}
- **gc**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha256.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "gc", "--prune=now", "--quiet"]` → exit 0 (0.274s); stdout `''`; stderr `''`; changed {'refs/heads/main': True, 'refs/heads/main.lock': False, 'packed-refs': True}
- **cat main tip after gc**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha256.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "cat-file", "-t", "fa9c35e14b19d62dcfdbd28c08eaf8ce0c13b38eb9a4b92846d08dba710e1ccd"]` → exit 0 (0.058s); stdout `'commit\n'`; stderr `''`; changed {'refs/heads/main': False, 'refs/heads/main.lock': False, 'packed-refs': False}
- **cat c1 (ancestor) after gc**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha256.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "cat-file", "-t", "fcb060df3f1a73de968c43a6a9637d7138e10d880a0a9e720615b27627088d49"]` → exit 0 (0.058s); stdout `'commit\n'`; stderr `''`; changed {'refs/heads/main': False, 'refs/heads/main.lock': False, 'packed-refs': False}
- **cat dangling after gc**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha256.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "cat-file", "-t", "fb05402e8f6920c206369cf38641a762e36cb53bc36c732b5534e4f04df60dea"]` → exit 128 (0.055s); stdout `''`; stderr `'fatal: git cat-file: could not get object info\n'`; changed {'refs/heads/main': False, 'refs/heads/main.lock': False, 'packed-refs': False}
- **core.fsync=bogus**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha256.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=bogus", "-c", "core.fsyncMethod=fsync", "rev-parse", "refs/heads/main"]` → exit 0 (0.057s); stdout `'5c65da32af2106dff2df018556496d7ff39bb6c593d4ca6195235b61f1e531fd\n'`; stderr `"warning: ignoring unknown core.fsync component 'bogus'\n"`
- **core.fsyncMethod=bogus**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha256.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=bogus", "rev-parse", "refs/heads/main"]` → exit 0 (0.051s); stdout `'5c65da32af2106dff2df018556496d7ff39bb6c593d4ca6195235b61f1e531fd\n'`; stderr `"warning: ignoring unknown core.fsyncMethod value 'bogus'\n"`
- **core.fsync= (empty)**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha256.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=", "-c", "core.fsyncMethod=fsync", "rev-parse", "refs/heads/main"]` → exit 0 (0.049s); stdout `'5c65da32af2106dff2df018556496d7ff39bb6c593d4ca6195235b61f1e531fd\n'`; stderr `''`
- **core.fsync=none,committed**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha256.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=none,committed", "-c", "core.fsyncMethod=fsync", "rev-parse", "refs/heads/main"]` → exit 0 (0.048s); stdout `'5c65da32af2106dff2df018556496d7ff39bb6c593d4ca6195235b61f1e531fd\n'`; stderr `"warning: ignoring unknown core.fsync component 'none'\n"`
- **update-ref with core.fsync=bogus**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha256.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=bogus", "-c", "core.fsyncMethod=fsync", "update-ref", "refs/heads/main", "5c65da32af2106dff2df018556496d7ff39bb6c593d4ca6195235b61f1e531fd", "fa9c35e14b19d62dcfdbd28c08eaf8ce0c13b38eb9a4b92846d08dba710e1ccd"]` → exit 128 (0.049s); stdout `''`; stderr `"warning: ignoring unknown core.fsync component 'bogus'\nfatal: update_ref failed for ref 'refs/heads/main': cannot lock ref 'refs/heads/main': is at 5c65da32af2106dff2df018556496d7ff39bb6c593d4ca6195235b61f1e531fd but expected fa9c35e14b19d62dcfdbd28c08eaf8ce0c13b38eb9a4b92846d08dba710e1ccd\n"`
  before `{'refs/heads/main': None, 'refs/heads/main.lock': None, 'packed-refs': '# pack-refs with: peeled fully-peeled sorted \n5c65da32af2106dff2df018556496d7ff39bb6c593d4ca6195235b61f1e531fd refs/heads/main\n'}`
  after `{'refs/heads/main': None, 'refs/heads/main.lock': None, 'packed-refs': '# pack-refs with: peeled fully-peeled sorted \n5c65da32af2106dff2df018556496d7ff39bb6c593d4ca6195235b61f1e531fd refs/heads/main\n'}`
- **update-ref with core.fsyncMethod=bogus**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha256.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=bogus", "update-ref", "refs/heads/main", "fa9c35e14b19d62dcfdbd28c08eaf8ce0c13b38eb9a4b92846d08dba710e1ccd", "5c65da32af2106dff2df018556496d7ff39bb6c593d4ca6195235b61f1e531fd"]` → exit 0 (0.063s); stdout `''`; stderr `"warning: ignoring unknown core.fsyncMethod value 'bogus'\n"`
  before `{'refs/heads/main': None, 'refs/heads/main.lock': None, 'packed-refs': '# pack-refs with: peeled fully-peeled sorted \n5c65da32af2106dff2df018556496d7ff39bb6c593d4ca6195235b61f1e531fd refs/heads/main\n'}`
  after `{'refs/heads/main': 'fa9c35e14b19d62dcfdbd28c08eaf8ce0c13b38eb9a4b92846d08dba710e1ccd\n', 'refs/heads/main.lock': None, 'packed-refs': '# pack-refs with: peeled fully-peeled sorted \n5c65da32af2106dff2df018556496d7ff39bb6c593d4ca6195235b61f1e531fd refs/heads/main\n'}`
- **update-ref with core.fsync=bogus (correct old)**: `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha256.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=bogus", "-c", "core.fsyncMethod=fsync", "update-ref", "refs/heads/main", "5c65da32af2106dff2df018556496d7ff39bb6c593d4ca6195235b61f1e531fd", "fa9c35e14b19d62dcfdbd28c08eaf8ce0c13b38eb9a4b92846d08dba710e1ccd"]` → exit 0 (0.048s); stdout `''`; stderr `"warning: ignoring unknown core.fsync component 'bogus'\n"`
  before `{'refs/heads/main': 'fa9c35e14b19d62dcfdbd28c08eaf8ce0c13b38eb9a4b92846d08dba710e1ccd\n', 'refs/heads/main.lock': None, 'packed-refs': '# pack-refs with: peeled fully-peeled sorted \n5c65da32af2106dff2df018556496d7ff39bb6c593d4ca6195235b61f1e531fd refs/heads/main\n'}`
  after `{'refs/heads/main': '5c65da32af2106dff2df018556496d7ff39bb6c593d4ca6195235b61f1e531fd\n', 'refs/heads/main.lock': None, 'packed-refs': '# pack-refs with: peeled fully-peeled sorted \n5c65da32af2106dff2df018556496d7ff39bb6c593d4ca6195235b61f1e531fd refs/heads/main\n'}`

The `update-ref with core.fsync=bogus` step (first) failed only because I passed a wrong old value (main was at c4); the corrected re-run is the last step.

Lock wait (main.lock present, sha1 repo, extra `-c core.filesRefLockTimeout=N`):
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "-c", "core.filesRefLockTimeout=0", "update-ref", "refs/heads/main", "4fcba9db5992d73ac170c118d38a9db997120e5d", "95406b63c3644f71090fad07323458e871e4d231"]`
  exit 128 (0.052s); stdout `''`; stderr `"fatal: update_ref failed for ref 'refs/heads/main': cannot lock ref 'refs/heads/main': Unable to create 'C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git/refs/heads/main.lock': File exists.\n\nAnother git process seems to be running in this repository, or the lock file may be stale\n"`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "-c", "core.filesRefLockTimeout=100", "update-ref", "refs/heads/main", "4fcba9db5992d73ac170c118d38a9db997120e5d", "95406b63c3644f71090fad07323458e871e4d231"]`
  exit 128 (0.289s); stdout `''`; stderr `"fatal: update_ref failed for ref 'refs/heads/main': cannot lock ref 'refs/heads/main': Unable to create 'C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git/refs/heads/main.lock': File exists.\n\nAnother git process seems to be running in this repository, or the lock file may be stale\n"`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "-c", "core.filesRefLockTimeout=1000", "update-ref", "refs/heads/main", "4fcba9db5992d73ac170c118d38a9db997120e5d", "95406b63c3644f71090fad07323458e871e4d231"]`
  exit 128 (1.234s); stdout `''`; stderr `"fatal: update_ref failed for ref 'refs/heads/main': cannot lock ref 'refs/heads/main': Unable to create 'C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\q4-sha1.git/refs/heads/main.lock': File exists.\n\nAnother git process seems to be running in this repository, or the lock file may be stale\n"`
## Observations
1. Installed Git is `2.55.0.windows.3`; the sources quoted are Git for Windows tag `v2.55.0.windows.3` (commit 52ca1113).
2. The product runs workspace-repository Git as `git --git-dir=<common> -c core.hooksPath=<colony>/workspaces/nohooks -c core.fsmonitor=false -c core.fsync=committed -c core.fsyncMethod=fsync …` (git.go:149), with host `GIT_*` stripped and five fixed variables added (git.go:68-76).
3. In code, `committed` = `objects | reference` = loose-object | pack | reference (write-or-die.h:27-28, 37-38). The 2.55 documentation says `committed` is "currently equivalent to `objects`" (core.adoc:679-680). The documentation and the code disagree, and the code includes `reference`.
4. A `core.fsync` value starts from the platform default and adds to it (environment.c:239, 290). On Windows that default already includes loose-object (mingw-posix.h:324), so `committed` and `objects,reference` resolve to the same component set. Their measured counters match in all five commands.
5. With `committed` or `objects,reference`, each of `hash-object -w`, `mktree`, `commit-tree`, loose `update-ref` and packed `update-ref` recorded exactly one `fsync/hardware-flush` trace2 counter and no `writeout-only` counter. With `core.fsync=none`, or with `core.fsync` unset, the object-writing commands still recorded 1 hardware-flush each, and both `update-ref` runs recorded none.
6. Git for Windows sets `fsync_object_files = 1` at startup (compat/mingw.c:4420), and `close_loose_object` fsyncs whenever `fsync_object_files > 0`, whatever `core.fsync` says (object-file.c:586-587). So the loose-object flush stops only with `-c core.fsyncObjectFiles=false` (measured) or `GIT_TEST_FSYNC=0` (measured). The product's reference hardening rests only on the `reference` component that `committed` provides.
7. `fsync` on MinGW is `_commit(fd)` (mingw-posix.h:132-133). `writeout-only` uses `NtFlushBuffersFileEx(FLUSH_FLAGS_FILE_DATA_ONLY)` (compat/win32/flush.c:23). The default fsyncMethod on Windows is `batch` (mingw-posix.h:325). [INFERENCE] `_commit` is the CRT call that flushes the OS file buffers to the device, i.e. FlushFileBuffers; I did not read the Microsoft documentation.
8. Ref hardening happens before the rename: loose refs are fsynced on the `.lock` fd (files-backend.c:2016) and packed-refs on its tempfile fd (packed-backend.c:1552). The probes do not show directory-entry fsync after the rename, and the quoted code does not either.
9. A guarded `update-ref refs/heads/main <new> <old>` with the correct old value exited 0, in both SHA-1 and SHA-256 repos and for loose and packed main. A stale old value exited 128 with `cannot lock ref … is at X but expected Y`, and none of the main file, main.lock or packed-refs changed.
10. With `refs/heads/main.lock` present, update-ref exited 128 with `Unable to create '…main.lock': File exists.` and changed nothing, and the pre-existing lock stayed in place. It does wait briefly: about 0.25 s by default, 0.05 s with `core.filesRefLockTimeout=0`, and 1.23 s with `=1000`. [INFERENCE] The default retry timeout is about 100 ms; the default was not read from source.
11. With main packed, a successful guarded update-ref wrote a new loose `refs/heads/main` and left `packed-refs` byte-identical. A stale old value against a packed main changed nothing. A stray `packed-refs.lock` did not block an update of packed main (exit 0, loose file written).
12. Bad values only warn. `core.fsync=bogus` → `warning: ignoring unknown core.fsync component 'bogus'`. `core.fsyncMethod=bogus` → `warning: ignoring unknown core.fsyncMethod value 'bogus'`. Both commands exited 0 and update-ref succeeded. With `core.fsync=bogus`, update-ref recorded no fsync counter, because the set fell back to the platform default without `reference`. With `fsyncMethod=bogus`, the ref was still hardware-flushed. Also, `none` is recognised only when it is the whole remaining value: `none,committed` warns `ignoring unknown core.fsync component 'none'` (environment.c:251 uses strcmp on the rest of the string).
13. [INFERENCE] From environment.c:270 (`strncmp(n->name, string, len)`), component names match by prefix, so an abbreviation such as `ref` would be accepted silently. Not probed.
14. A commit reachable only from `refs/heads/main`, and its ancestor, were still present after `git gc --prune=now` (`cat-file -t` → `commit`). A commit reachable from no ref was gone (exit 128, `fatal: git cat-file: could not get object info`). The same held in the SHA-1 and SHA-256 repos. gc left the main loose file and packed-refs changed (it packed the ref).
15. Nothing here tests power loss or crash durability.


# Follow-up: floor and directory flushes

## (a) Git 2.45 floor
Sources from raw.githubusercontent.com at upstream `v2.45.0` (github.com/git/git) and Git for Windows `v2.45.0.windows.1`. `write-or-die.h` is byte-identical between the two tags. The `config.c` parse and core-config regions (lines 1246-1320 and 1596-1625) are identical too. `Documentation/config/core.txt` differs only by added GfW sections (`core.fscache`, `core.longpaths`, `core.WSLCompat`), not in the fsync text. At 2.45 the parser lives in `config.c`; by 2.55 it had moved to `environment.c`.

https://github.com/git/git/blob/v2.45.0/write-or-die.h#L16-L52
```
16: enum fsync_component {
17: 	FSYNC_COMPONENT_NONE,
18: 	FSYNC_COMPONENT_LOOSE_OBJECT		= 1 << 0,
19: 	FSYNC_COMPONENT_PACK			= 1 << 1,
20: 	FSYNC_COMPONENT_PACK_METADATA		= 1 << 2,
21: 	FSYNC_COMPONENT_COMMIT_GRAPH		= 1 << 3,
22: 	FSYNC_COMPONENT_INDEX			= 1 << 4,
23: 	FSYNC_COMPONENT_REFERENCE		= 1 << 5,
24: };
25: 
26: #define FSYNC_COMPONENTS_OBJECTS (FSYNC_COMPONENT_LOOSE_OBJECT | \
27: 				  FSYNC_COMPONENT_PACK)
28: 
29: #define FSYNC_COMPONENTS_DERIVED_METADATA (FSYNC_COMPONENT_PACK_METADATA | \
30: 					   FSYNC_COMPONENT_COMMIT_GRAPH)
31: 
32: #define FSYNC_COMPONENTS_DEFAULT ((FSYNC_COMPONENTS_OBJECTS | \
33: 				   FSYNC_COMPONENTS_DERIVED_METADATA) & \
34: 				  ~FSYNC_COMPONENT_LOOSE_OBJECT)
35: 
36: #define FSYNC_COMPONENTS_COMMITTED (FSYNC_COMPONENTS_OBJECTS | \
37: 				    FSYNC_COMPONENT_REFERENCE)
38: 
39: #define FSYNC_COMPONENTS_ADDED (FSYNC_COMPONENTS_COMMITTED | \
40: 				FSYNC_COMPONENT_INDEX)
41: 
42: #define FSYNC_COMPONENTS_ALL (FSYNC_COMPONENT_LOOSE_OBJECT | \
43: 			      FSYNC_COMPONENT_PACK | \
44: 			      FSYNC_COMPONENT_PACK_METADATA | \
45: 			      FSYNC_COMPONENT_COMMIT_GRAPH | \
46: 			      FSYNC_COMPONENT_INDEX | \
47: 			      FSYNC_COMPONENT_REFERENCE)
48: 
49: #ifndef FSYNC_COMPONENTS_PLATFORM_DEFAULT
50: #define FSYNC_COMPONENTS_PLATFORM_DEFAULT FSYNC_COMPONENTS_DEFAULT
51: #endif
52: 
```
https://github.com/git/git/blob/v2.45.0/config.c#L1245-L1318
```
1245: 
1246: static const struct fsync_component_name {
1247: 	const char *name;
1248: 	enum fsync_component component_bits;
1249: } fsync_component_names[] = {
1250: 	{ "loose-object", FSYNC_COMPONENT_LOOSE_OBJECT },
1251: 	{ "pack", FSYNC_COMPONENT_PACK },
1252: 	{ "pack-metadata", FSYNC_COMPONENT_PACK_METADATA },
1253: 	{ "commit-graph", FSYNC_COMPONENT_COMMIT_GRAPH },
1254: 	{ "index", FSYNC_COMPONENT_INDEX },
1255: 	{ "objects", FSYNC_COMPONENTS_OBJECTS },
1256: 	{ "reference", FSYNC_COMPONENT_REFERENCE },
1257: 	{ "derived-metadata", FSYNC_COMPONENTS_DERIVED_METADATA },
1258: 	{ "committed", FSYNC_COMPONENTS_COMMITTED },
1259: 	{ "added", FSYNC_COMPONENTS_ADDED },
1260: 	{ "all", FSYNC_COMPONENTS_ALL },
1261: };
1262: 
1263: static enum fsync_component parse_fsync_components(const char *var, const char *string)
1264: {
1265: 	enum fsync_component current = FSYNC_COMPONENTS_PLATFORM_DEFAULT;
1266: 	enum fsync_component positive = 0, negative = 0;
1267: 
1268: 	while (string) {
1269: 		int i;
1270: 		size_t len;
1271: 		const char *ep;
1272: 		int negated = 0;
1273: 		int found = 0;
1274: 
1275: 		string = string + strspn(string, ", \t\n\r");
1276: 		ep = strchrnul(string, ',');
1277: 		len = ep - string;
1278: 		if (!strcmp(string, "none")) {
1279: 			current = FSYNC_COMPONENT_NONE;
1280: 			goto next_name;
1281: 		}
1282: 
1283: 		if (*string == '-') {
1284: 			negated = 1;
1285: 			string++;
1286: 			len--;
1287: 			if (!len)
1288: 				warning(_("invalid value for variable %s"), var);
1289: 		}
1290: 
1291: 		if (!len)
1292: 			break;
1293: 
1294: 		for (i = 0; i < ARRAY_SIZE(fsync_component_names); ++i) {
1295: 			const struct fsync_component_name *n = &fsync_component_names[i];
1296: 
1297: 			if (strncmp(n->name, string, len))
1298: 				continue;
1299: 
1300: 			found = 1;
1301: 			if (negated)
1302: 				negative |= n->component_bits;
1303: 			else
1304: 				positive |= n->component_bits;
1305: 		}
1306: 
1307: 		if (!found) {
1308: 			char *component = xstrndup(string, len);
1309: 			warning(_("ignoring unknown core.fsync component '%s'"), component);
1310: 			free(component);
1311: 		}
1312: 
1313: next_name:
1314: 		string = ep;
1315: 	}
1316: 
1317: 	return (current & ~negative) | positive;
1318: }
```
https://github.com/git/git/blob/v2.45.0/config.c#L1599-L1618
```
1599: 	if (!strcmp(var, "core.fsync")) {
1600: 		if (!value)
1601: 			return config_error_nonbool(var);
1602: 		fsync_components = parse_fsync_components(var, value);
1603: 		return 0;
1604: 	}
1605: 
1606: 	if (!strcmp(var, "core.fsyncmethod")) {
1607: 		if (!value)
1608: 			return config_error_nonbool(var);
1609: 		if (!strcmp(value, "fsync"))
1610: 			fsync_method = FSYNC_METHOD_FSYNC;
1611: 		else if (!strcmp(value, "writeout-only"))
1612: 			fsync_method = FSYNC_METHOD_WRITEOUT_ONLY;
1613: 		else if (!strcmp(value, "batch"))
1614: 			fsync_method = FSYNC_METHOD_BATCH;
1615: 		else
1616: 			warning(_("ignoring unknown core.fsyncMethod value '%s'"), value);
1617: 
1618: 	}
```
Windows default set and method:
https://github.com/git/git/blob/v2.45.0/compat/mingw.h#L340-L341
```
340: #define FSYNC_COMPONENTS_PLATFORM_DEFAULT (FSYNC_COMPONENTS_DEFAULT | FSYNC_COMPONENT_LOOSE_OBJECT)
341: #define FSYNC_METHOD_DEFAULT (FSYNC_METHOD_BATCH)
```
https://github.com/git-for-windows/git/blob/v2.45.0.windows.1/compat/mingw.h#L343-L344
```
343: #define FSYNC_COMPONENTS_PLATFORM_DEFAULT (FSYNC_COMPONENTS_DEFAULT | FSYNC_COMPONENT_LOOSE_OBJECT)
344: #define FSYNC_METHOD_DEFAULT (FSYNC_METHOD_BATCH)
```
GfW startup forces loose-object fsync at 2.45 too:
https://github.com/git-for-windows/git/blob/v2.45.0.windows.1/compat/mingw.c#L4085-L4089
```
4085: 	SetConsoleCtrlHandler(handle_ctrl_c, TRUE);
4086: 
4087: 	maybe_redirect_std_handles();
4088: 	adjust_symlink_flags();
4089: 	fsync_object_files = 1;
```
Documentation (same text and the same doc/code mismatch as 2.55):
https://github.com/git/git/blob/v2.45.0/Documentation/config/core.txt#L612-L651
```
612: core.fsync::
613: 	A comma-separated list of components of the repository that
614: 	should be hardened via the core.fsyncMethod when created or
615: 	modified.  You can disable hardening of any component by
616: 	prefixing it with a '-'.  Items that are not hardened may be
617: 	lost in the event of an unclean	system shutdown. Unless you
618: 	have special requirements, it is recommended that you leave
619: 	this option empty or pick one of `committed`, `added`,
620: 	or `all`.
621: +
622: When this configuration is encountered, the set of components starts with
623: the platform default value, disabled components are removed, and additional
624: components are added. `none` resets the state so that the platform default
625: is ignored.
626: +
627: The empty string resets the fsync configuration to the platform
628: default. The default on most platforms is equivalent to
629: `core.fsync=committed,-loose-object`, which has good performance,
630: but risks losing recent work in the event of an unclean system shutdown.
631: +
632: * `none` clears the set of fsynced components.
633: * `loose-object` hardens objects added to the repo in loose-object form.
634: * `pack` hardens objects added to the repo in packfile form.
635: * `pack-metadata` hardens packfile bitmaps and indexes.
636: * `commit-graph` hardens the commit-graph file.
637: * `index` hardens the index when it is modified.
638: * `objects` is an aggregate option that is equivalent to
639:   `loose-object,pack`.
640: * `reference` hardens references modified in the repo.
641: * `derived-metadata` is an aggregate option that is equivalent to
642:   `pack-metadata,commit-graph`.
643: * `committed` is an aggregate option that is currently equivalent to
644:   `objects`. This mode sacrifices some performance to ensure that work
645:   that is committed to the repository with `git commit` or similar commands
646:   is hardened.
647: * `added` is an aggregate option that is currently equivalent to
648:   `committed,index`. This mode sacrifices additional performance to
649:   ensure that the results of commands like `git add` and similar operations
650:   are hardened.
651: * `all` is an aggregate option that syncs all individual components above.
```

## (b) `durable.SyncDir` against Git-created directories (NTFS, %TEMP%)
Module copy: `git -C C:/Users/darius.jones/Documents/PROJECTS/dwarf-harness archive --format=tar 702ca66 > %TEMP%\t08probe-mod.tar` → exit 0, empty stderr. Extracted to `%TEMP%\t08probe-mod\`, and `cmd/t08probe/main.go` was added there only. Run: `GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go run ./cmd/t08probe %TEMP%\t08probe-work` in the copy, with `go version go1.27.2 windows/amd64`. It built with exit 0 and no download messages in stderr. [INFERENCE] `golang.org/x/sys` came from the module cache; network access was not otherwise checked.

The program uses the product's argv prefix (`--git-dir`, `-c core.hooksPath`, `-c core.fsmonitor=false`, `-c core.fsync=committed`, `-c core.fsyncMethod=fsync`) and `repositoryEnvironment`'s variables, plus fixed author and committer identity and dates. It prints each Git call (argv, exit, stdout, stderr) and each SyncDir result with the error type. It does this for a SHA-1 and a SHA-256 bare repository.

Program source:
```go
package main

import (
	"bytes"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"github.com/Darius-PJ/dwarf-harness/internal/core/durable"
)

var colony, gd string

func env() []string {
	var out []string
	for _, s := range os.Environ() {
		if !strings.HasPrefix(strings.ToUpper(strings.SplitN(s, "=", 2)[0]), "GIT_") {
			out = append(out, s)
		}
	}
	out = append(out, "GIT_CONFIG_NOSYSTEM=1", "GIT_CONFIG_GLOBAL="+filepath.Join(colony, "workspaces", "empty"), "GIT_NO_REPLACE_OBJECTS=1", "GIT_TERMINAL_PROMPT=0", "GIT_OPTIONAL_LOCKS=0")
	return append(out, "GIT_AUTHOR_NAME=probe", "GIT_AUTHOR_EMAIL=probe@example.invalid", "GIT_COMMITTER_NAME=probe", "GIT_COMMITTER_EMAIL=probe@example.invalid", "GIT_AUTHOR_DATE=1700000000 +0000", "GIT_COMMITTER_DATE=1700000000 +0000")
}

func git(stdin string, args ...string) string {
	argv := append([]string{"--git-dir=" + gd, "-c", "core.hooksPath=" + filepath.Join(colony, "workspaces", "nohooks"), "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync"}, args...)
	cmd := exec.Command("git", argv...)
	cmd.Env = env()
	cmd.Stdin = strings.NewReader(stdin)
	var o, e bytes.Buffer
	cmd.Stdout, cmd.Stderr = &o, &e
	err := cmd.Run()
	code := 0
	if cmd.ProcessState != nil {
		code = cmd.ProcessState.ExitCode()
	}
	fmt.Printf("GIT %q exit=%d err=%v stdout=%q stderr=%q\n", argv, code, err, o.String(), e.String())
	return strings.TrimSpace(o.String())
}

func sync(label, dir string) {
	err := durable.SyncDir(dir)
	if err == nil {
		fmt.Printf("SYNCDIR %s len=%d path=%q -> <nil>\n", label, len(dir), dir)
		return
	}
	fmt.Printf("SYNCDIR %s len=%d path=%q -> %T: %v\n", label, len(dir), dir, err, err)
	if pe, ok := err.(*os.PathError); ok {
		fmt.Printf("        inner %T: %v (IsNotExist=%v)\n", pe.Err, pe.Err, os.IsNotExist(err))
	}
}

func exists(p string) bool { _, err := os.Stat(p); return err == nil }

func main() {
	base := os.Args[1]
	colony = filepath.Join(base, "colony")
	os.MkdirAll(filepath.Join(colony, "workspaces", "nohooks"), 0o755)
	os.WriteFile(filepath.Join(colony, "workspaces", "empty"), nil, 0o644)
	for _, fmtName := range []string{"sha1", "sha256"} {
		gd = filepath.Join(base, "repo-"+fmtName+".git")
		cmd := exec.Command("git", "-c", "init.defaultBranch=main", "init", "--bare", "-q", "--object-format="+fmtName, gd)
		cmd.Env = env()
		out, err := cmd.CombinedOutput()
		fmt.Printf("== %s init err=%v out=%q\n", fmtName, err, out)
		b := git("a\n", "hash-object", "-w", "--stdin")
		t := git("100644 blob "+b+"\ta\n", "mktree")
		c1 := git("", "commit-tree", t, "-m", "c1")
		c2 := git("", "commit-tree", t, "-p", c1, "-m", "c2")
		c3 := git("", "commit-tree", t, "-p", c2, "-m", "c3")
		git("", "update-ref", "refs/heads/main", c1, "")
		fmt.Println("-- loose main")
		git("", "update-ref", "refs/heads/main", c2, c1)
		sync("refs/heads", filepath.Join(gd, "refs", "heads"))
		sync("refs", filepath.Join(gd, "refs"))
		sync("gitdir", gd)
		git("", "update-ref", "refs/dwarf-harness/runs/r1/intent", c2, strings.Repeat("0", len(c2)))
		sync("refs/dwarf-harness/runs/r1", filepath.Join(gd, "refs", "dwarf-harness", "runs", "r1"))
		sync("refs/dwarf-harness/runs", filepath.Join(gd, "refs", "dwarf-harness", "runs"))
		sync("refs/dwarf-harness", filepath.Join(gd, "refs", "dwarf-harness"))
		fmt.Println("-- packed main")
		git("", "pack-refs", "--all")
		fmt.Printf("loose main exists=%v packed-refs exists=%v r1 dir exists=%v\n", exists(filepath.Join(gd, "refs", "heads", "main")), exists(filepath.Join(gd, "packed-refs")), exists(filepath.Join(gd, "refs", "dwarf-harness", "runs", "r1")))
		git("", "update-ref", "refs/heads/main", c3, c2)
		fmt.Printf("loose main exists=%v\n", exists(filepath.Join(gd, "refs", "heads", "main")))
		sync("refs/heads (packed case)", filepath.Join(gd, "refs", "heads"))
		sync("refs (packed case)", filepath.Join(gd, "refs"))
		sync("gitdir (packed case)", gd)
		git("", "update-ref", "refs/dwarf-harness/runs/r2/intent", c3, strings.Repeat("0", len(c3)))
		sync("refs/dwarf-harness/runs/r2 (packed case)", filepath.Join(gd, "refs", "dwarf-harness", "runs", "r2"))
		sync("refs/dwarf-harness/runs (packed case)", filepath.Join(gd, "refs", "dwarf-harness", "runs"))
	}
	fmt.Println("== edge cases")
	sync("missing", filepath.Join(base, "does-not-exist"))
	sync("missing parent", filepath.Join(base, "nope", "deeper"))
	long := base
	for len(long) <= 300 {
		long = filepath.Join(long, strings.Repeat("d", 40))
	}
	fmt.Printf("MkdirAll long err=%v\n", os.MkdirAll(long, 0o755))
	sync("long>260", long)
	f := filepath.Join(base, "afile")
	os.WriteFile(f, []byte("x"), 0o644)
	sync("regular file", f)
	sync("relative refs", "relative-missing-dir")
}
```

Raw output (exit 0, stderr `''`):
```
== sha1 init err=<nil> out=""
GIT ["--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha1.git" "-c" "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\colony\\workspaces\\nohooks" "-c" "core.fsmonitor=false" "-c" "core.fsync=committed" "-c" "core.fsyncMethod=fsync" "hash-object" "-w" "--stdin"] exit=0 err=<nil> stdout="78981922613b2afb6025042ff6bd878ac1994e85\n" stderr=""
GIT ["--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha1.git" "-c" "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\colony\\workspaces\\nohooks" "-c" "core.fsmonitor=false" "-c" "core.fsync=committed" "-c" "core.fsyncMethod=fsync" "mktree"] exit=0 err=<nil> stdout="aaff74984cccd156a469afa7d9ab10e4777beb24\n" stderr=""
GIT ["--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha1.git" "-c" "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\colony\\workspaces\\nohooks" "-c" "core.fsmonitor=false" "-c" "core.fsync=committed" "-c" "core.fsyncMethod=fsync" "commit-tree" "aaff74984cccd156a469afa7d9ab10e4777beb24" "-m" "c1"] exit=0 err=<nil> stdout="10a2f96084e8b09d66b88d44146043af5e78201b\n" stderr=""
GIT ["--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha1.git" "-c" "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\colony\\workspaces\\nohooks" "-c" "core.fsmonitor=false" "-c" "core.fsync=committed" "-c" "core.fsyncMethod=fsync" "commit-tree" "aaff74984cccd156a469afa7d9ab10e4777beb24" "-p" "10a2f96084e8b09d66b88d44146043af5e78201b" "-m" "c2"] exit=0 err=<nil> stdout="614a1a2a91522fff873a68607038b3b1765c137c\n" stderr=""
GIT ["--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha1.git" "-c" "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\colony\\workspaces\\nohooks" "-c" "core.fsmonitor=false" "-c" "core.fsync=committed" "-c" "core.fsyncMethod=fsync" "commit-tree" "aaff74984cccd156a469afa7d9ab10e4777beb24" "-p" "614a1a2a91522fff873a68607038b3b1765c137c" "-m" "c3"] exit=0 err=<nil> stdout="2ae6f6647691a815792826efb7513cb43c59c65a\n" stderr=""
GIT ["--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha1.git" "-c" "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\colony\\workspaces\\nohooks" "-c" "core.fsmonitor=false" "-c" "core.fsync=committed" "-c" "core.fsyncMethod=fsync" "update-ref" "refs/heads/main" "10a2f96084e8b09d66b88d44146043af5e78201b" ""] exit=0 err=<nil> stdout="" stderr=""
-- loose main
GIT ["--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha1.git" "-c" "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\colony\\workspaces\\nohooks" "-c" "core.fsmonitor=false" "-c" "core.fsync=committed" "-c" "core.fsyncMethod=fsync" "update-ref" "refs/heads/main" "614a1a2a91522fff873a68607038b3b1765c137c" "10a2f96084e8b09d66b88d44146043af5e78201b"] exit=0 err=<nil> stdout="" stderr=""
SYNCDIR refs/heads len=79 path="C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha1.git\\refs\\heads" -> <nil>
SYNCDIR refs len=73 path="C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha1.git\\refs" -> <nil>
SYNCDIR gitdir len=68 path="C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha1.git" -> <nil>
GIT ["--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha1.git" "-c" "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\colony\\workspaces\\nohooks" "-c" "core.fsmonitor=false" "-c" "core.fsync=committed" "-c" "core.fsyncMethod=fsync" "update-ref" "refs/dwarf-harness/runs/r1/intent" "614a1a2a91522fff873a68607038b3b1765c137c" "0000000000000000000000000000000000000000"] exit=0 err=<nil> stdout="" stderr=""
SYNCDIR refs/dwarf-harness/runs/r1 len=95 path="C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha1.git\\refs\\dwarf-harness\\runs\\r1" -> <nil>
SYNCDIR refs/dwarf-harness/runs len=92 path="C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha1.git\\refs\\dwarf-harness\\runs" -> <nil>
SYNCDIR refs/dwarf-harness len=87 path="C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha1.git\\refs\\dwarf-harness" -> <nil>
-- packed main
GIT ["--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha1.git" "-c" "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\colony\\workspaces\\nohooks" "-c" "core.fsmonitor=false" "-c" "core.fsync=committed" "-c" "core.fsyncMethod=fsync" "pack-refs" "--all"] exit=0 err=<nil> stdout="" stderr=""
loose main exists=false packed-refs exists=true r1 dir exists=false
GIT ["--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha1.git" "-c" "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\colony\\workspaces\\nohooks" "-c" "core.fsmonitor=false" "-c" "core.fsync=committed" "-c" "core.fsyncMethod=fsync" "update-ref" "refs/heads/main" "2ae6f6647691a815792826efb7513cb43c59c65a" "614a1a2a91522fff873a68607038b3b1765c137c"] exit=0 err=<nil> stdout="" stderr=""
loose main exists=true
SYNCDIR refs/heads (packed case) len=79 path="C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha1.git\\refs\\heads" -> <nil>
SYNCDIR refs (packed case) len=73 path="C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha1.git\\refs" -> <nil>
SYNCDIR gitdir (packed case) len=68 path="C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha1.git" -> <nil>
GIT ["--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha1.git" "-c" "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\colony\\workspaces\\nohooks" "-c" "core.fsmonitor=false" "-c" "core.fsync=committed" "-c" "core.fsyncMethod=fsync" "update-ref" "refs/dwarf-harness/runs/r2/intent" "2ae6f6647691a815792826efb7513cb43c59c65a" "0000000000000000000000000000000000000000"] exit=0 err=<nil> stdout="" stderr=""
SYNCDIR refs/dwarf-harness/runs/r2 (packed case) len=95 path="C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha1.git\\refs\\dwarf-harness\\runs\\r2" -> <nil>
SYNCDIR refs/dwarf-harness/runs (packed case) len=92 path="C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha1.git\\refs\\dwarf-harness\\runs" -> <nil>
== sha256 init err=<nil> out=""
GIT ["--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha256.git" "-c" "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\colony\\workspaces\\nohooks" "-c" "core.fsmonitor=false" "-c" "core.fsync=committed" "-c" "core.fsyncMethod=fsync" "hash-object" "-w" "--stdin"] exit=0 err=<nil> stdout="f8625e43f9e04f24291f77cdbe4c71b3c2a3b0003f60419b3ed06a058d766c8b\n" stderr=""
GIT ["--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha256.git" "-c" "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\colony\\workspaces\\nohooks" "-c" "core.fsmonitor=false" "-c" "core.fsync=committed" "-c" "core.fsyncMethod=fsync" "mktree"] exit=0 err=<nil> stdout="1871f0024ff8077011b24612c22e73ae7e1319a6a685ad9395c4d92540c89f7c\n" stderr=""
GIT ["--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha256.git" "-c" "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\colony\\workspaces\\nohooks" "-c" "core.fsmonitor=false" "-c" "core.fsync=committed" "-c" "core.fsyncMethod=fsync" "commit-tree" "1871f0024ff8077011b24612c22e73ae7e1319a6a685ad9395c4d92540c89f7c" "-m" "c1"] exit=0 err=<nil> stdout="d7d180d6f1f855759650821907e66a18f1c5b87706f7f424b15ac2484a3d556a\n" stderr=""
GIT ["--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha256.git" "-c" "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\colony\\workspaces\\nohooks" "-c" "core.fsmonitor=false" "-c" "core.fsync=committed" "-c" "core.fsyncMethod=fsync" "commit-tree" "1871f0024ff8077011b24612c22e73ae7e1319a6a685ad9395c4d92540c89f7c" "-p" "d7d180d6f1f855759650821907e66a18f1c5b87706f7f424b15ac2484a3d556a" "-m" "c2"] exit=0 err=<nil> stdout="af30baa883e7c961046e59f361a0af34963c1f2f3cc344ea6da7bd26a2d01963\n" stderr=""
GIT ["--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha256.git" "-c" "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\colony\\workspaces\\nohooks" "-c" "core.fsmonitor=false" "-c" "core.fsync=committed" "-c" "core.fsyncMethod=fsync" "commit-tree" "1871f0024ff8077011b24612c22e73ae7e1319a6a685ad9395c4d92540c89f7c" "-p" "af30baa883e7c961046e59f361a0af34963c1f2f3cc344ea6da7bd26a2d01963" "-m" "c3"] exit=0 err=<nil> stdout="476ff594f74086ccbcc6aa787206c37f5a084e37e2735ddb45079c0a6ae38da8\n" stderr=""
GIT ["--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha256.git" "-c" "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\colony\\workspaces\\nohooks" "-c" "core.fsmonitor=false" "-c" "core.fsync=committed" "-c" "core.fsyncMethod=fsync" "update-ref" "refs/heads/main" "d7d180d6f1f855759650821907e66a18f1c5b87706f7f424b15ac2484a3d556a" ""] exit=0 err=<nil> stdout="" stderr=""
-- loose main
GIT ["--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha256.git" "-c" "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\colony\\workspaces\\nohooks" "-c" "core.fsmonitor=false" "-c" "core.fsync=committed" "-c" "core.fsyncMethod=fsync" "update-ref" "refs/heads/main" "af30baa883e7c961046e59f361a0af34963c1f2f3cc344ea6da7bd26a2d01963" "d7d180d6f1f855759650821907e66a18f1c5b87706f7f424b15ac2484a3d556a"] exit=0 err=<nil> stdout="" stderr=""
SYNCDIR refs/heads len=81 path="C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha256.git\\refs\\heads" -> <nil>
SYNCDIR refs len=75 path="C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha256.git\\refs" -> <nil>
SYNCDIR gitdir len=70 path="C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha256.git" -> <nil>
GIT ["--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha256.git" "-c" "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\colony\\workspaces\\nohooks" "-c" "core.fsmonitor=false" "-c" "core.fsync=committed" "-c" "core.fsyncMethod=fsync" "update-ref" "refs/dwarf-harness/runs/r1/intent" "af30baa883e7c961046e59f361a0af34963c1f2f3cc344ea6da7bd26a2d01963" "0000000000000000000000000000000000000000000000000000000000000000"] exit=0 err=<nil> stdout="" stderr=""
SYNCDIR refs/dwarf-harness/runs/r1 len=97 path="C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha256.git\\refs\\dwarf-harness\\runs\\r1" -> <nil>
SYNCDIR refs/dwarf-harness/runs len=94 path="C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha256.git\\refs\\dwarf-harness\\runs" -> <nil>
SYNCDIR refs/dwarf-harness len=89 path="C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha256.git\\refs\\dwarf-harness" -> <nil>
-- packed main
GIT ["--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha256.git" "-c" "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\colony\\workspaces\\nohooks" "-c" "core.fsmonitor=false" "-c" "core.fsync=committed" "-c" "core.fsyncMethod=fsync" "pack-refs" "--all"] exit=0 err=<nil> stdout="" stderr=""
loose main exists=false packed-refs exists=true r1 dir exists=false
GIT ["--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha256.git" "-c" "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\colony\\workspaces\\nohooks" "-c" "core.fsmonitor=false" "-c" "core.fsync=committed" "-c" "core.fsyncMethod=fsync" "update-ref" "refs/heads/main" "476ff594f74086ccbcc6aa787206c37f5a084e37e2735ddb45079c0a6ae38da8" "af30baa883e7c961046e59f361a0af34963c1f2f3cc344ea6da7bd26a2d01963"] exit=0 err=<nil> stdout="" stderr=""
loose main exists=true
SYNCDIR refs/heads (packed case) len=81 path="C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha256.git\\refs\\heads" -> <nil>
SYNCDIR refs (packed case) len=75 path="C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha256.git\\refs" -> <nil>
SYNCDIR gitdir (packed case) len=70 path="C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha256.git" -> <nil>
GIT ["--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha256.git" "-c" "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\colony\\workspaces\\nohooks" "-c" "core.fsmonitor=false" "-c" "core.fsync=committed" "-c" "core.fsyncMethod=fsync" "update-ref" "refs/dwarf-harness/runs/r2/intent" "476ff594f74086ccbcc6aa787206c37f5a084e37e2735ddb45079c0a6ae38da8" "0000000000000000000000000000000000000000000000000000000000000000"] exit=0 err=<nil> stdout="" stderr=""
SYNCDIR refs/dwarf-harness/runs/r2 (packed case) len=97 path="C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha256.git\\refs\\dwarf-harness\\runs\\r2" -> <nil>
SYNCDIR refs/dwarf-harness/runs (packed case) len=94 path="C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha256.git\\refs\\dwarf-harness\\runs" -> <nil>
== edge cases
SYNCDIR missing len=69 path="C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\does-not-exist" -> *fs.PathError: syncdir C:\Users\DARIUS~1.JON\AppData\Local\Temp\t08probe-work\does-not-exist: The system cannot find the file specified.
        inner syscall.Errno: The system cannot find the file specified. (IsNotExist=true)
SYNCDIR missing parent len=66 path="C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\nope\\deeper" -> *fs.PathError: syncdir C:\Users\DARIUS~1.JON\AppData\Local\Temp\t08probe-work\nope\deeper: The system cannot find the path specified.
        inner syscall.Errno: The system cannot find the path specified. (IsNotExist=true)
MkdirAll long err=<nil>
SYNCDIR long>260 len=341 path="C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\dddddddddddddddddddddddddddddddddddddddd\\dddddddddddddddddddddddddddddddddddddddd\\dddddddddddddddddddddddddddddddddddddddd\\dddddddddddddddddddddddddddddddddddddddd\\dddddddddddddddddddddddddddddddddddddddd\\dddddddddddddddddddddddddddddddddddddddd\\dddddddddddddddddddddddddddddddddddddddd" -> <nil>
SYNCDIR regular file len=60 path="C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\afile" -> <nil>
SYNCDIR relative refs len=20 path="relative-missing-dir" -> *fs.PathError: syncdir relative-missing-dir: The system cannot find the file specified.
        inner syscall.Errno: The system cannot find the file specified. (IsNotExist=true)
```

`durable` tests: `GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go test -count=1 -v ./internal/core/durable` in the copy → exit 0
```
=== RUN   TestExtendedPath
=== RUN   TestExtendedPath/relative_name
=== RUN   TestExtendedPath/drive_path_with_dot-dot
=== RUN   TestExtendedPath/UNC_path
=== RUN   TestExtendedPath/extended_path
=== RUN   TestExtendedPath/device_path
--- PASS: TestExtendedPath (0.00s)
    --- PASS: TestExtendedPath/relative_name (0.00s)
    --- PASS: TestExtendedPath/drive_path_with_dot-dot (0.00s)
    --- PASS: TestExtendedPath/UNC_path (0.00s)
    --- PASS: TestExtendedPath/extended_path (0.00s)
    --- PASS: TestExtendedPath/device_path (0.00s)
=== RUN   TestLockIsExclusive
--- PASS: TestLockIsExclusive (0.00s)
=== RUN   TestSyncDirAndRenameBeyondMaxPath
--- PASS: TestSyncDirAndRenameBeyondMaxPath (0.03s)
PASS
ok  	github.com/Darius-PJ/dwarf-harness/internal/core/durable	1.005s
```

SyncDir implementation under test (read from the project, `internal/core/durable/durable_windows.go:59-78,100-113`): `CreateFile(\\?\<abs>, GENERIC_READ|GENERIC_WRITE, share all, OPEN_EXISTING, FILE_FLAG_BACKUP_SEMANTICS)`, then `FlushFileBuffers`, then `CloseHandle`. Errors are wrapped as `*os.PathError{Op:"syncdir"}`.

## (c) Ref backend reporting
https://github.com/git/git/blob/v2.45.0/Documentation/git-rev-parse.txt#L322-L323
```
322: --show-ref-format::
323: 	Show the reference storage format used for the repository.
```
https://github.com/git/git/blob/v2.45.0/Documentation/config/extensions.txt#L22-L31
```
22: extensions.refStorage::
23: 	Specify the ref storage format to use. The acceptable values are:
24: +
25: include::../ref-storage-format.txt[]
26: +
27: It is an error to specify this key unless `core.repositoryFormatVersion` is 1.
28: +
29: Note that this setting should only be set by linkgit:git-init[1] or
30: linkgit:git-clone[1]. Trying to change it after initialization will not
31: work and will produce hard-to-diagnose issues.
```
https://github.com/git/git/blob/v2.45.0/Documentation/ref-storage-format.txt#L1-L3
```
1: * `files` for loose files with packed-refs. This is the default.
2: * `reftable` for the reftable format. This format is experimental and its
3:   internals are subject to change.
```

Installed Git (2.55.0.windows.3), product argv and env, on the probe's SHA-1 bare repo:
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "rev-parse", "--show-ref-format"]`
  exit 0 (0.052s); stdout `'files\n'`; stderr `''`
- `["git", "--git-dir=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-work\\repo-sha1.git", "-c", "core.hooksPath=C:\\Users\\DARIUS~1.JON\\AppData\\Local\\Temp\\t08probe-x_2g7wqd\\colony\\workspaces\\nohooks", "-c", "core.fsmonitor=false", "-c", "core.fsync=committed", "-c", "core.fsyncMethod=fsync", "config", "--get", "extensions.refStorage"]`
  exit 1 (0.042s); stdout `''`; stderr `''`

## Observations (follow-up)
1. At v2.45.0 `FSYNC_COMPONENTS_COMMITTED` is `FSYNC_COMPONENTS_OBJECTS | FSYNC_COMPONENT_REFERENCE` (write-or-die.h:36-37). That is the same definition as 2.55, and Git for Windows v2.45.0.windows.1 does not change it.
2. At v2.45.0 the parser (config.c) has the same name table entries (`objects`, `reference`, `committed`) and the same algorithm as 2.55: start from the platform default, OR in the named components, mask out the negated ones, match names by prefix with `strncmp`, and only warn on unknown names. So `core.fsync=objects,reference` is accepted at 2.45 and resolves to the same set as `committed`.
3. The Windows platform default at 2.45 is `FSYNC_COMPONENTS_DEFAULT | FSYNC_COMPONENT_LOOSE_OBJECT`, and the method default is `BATCH` (upstream compat/mingw.h:340-341; GfW 343-344). GfW 2.45 also sets `fsync_object_files = 1` at startup (compat/mingw.c:4089). So at 2.45, as at 2.55, `committed` and `objects,reference` give the same set on Windows: loose-object, pack, pack-metadata, commit-graph and reference. [INFERENCE] I measured fsync behaviour only on the installed 2.55; 2.45 was not run.
4. The 2.45 documentation also says `committed` is "currently equivalent to `objects`" (core.txt:643-644), contradicting the code there too.
5. Every `SyncDir` call on an existing Git-created directory returned nil, in both SHA-1 and SHA-256 repos and for loose and packed `main`: `refs/heads`, `refs`, the common git dir, and `refs/dwarf-harness/runs/<r>` and its parents after a CAS-created ref (`update-ref <ref> <new> <zero-oid>`, exit 0).
6. `pack-refs --all` deleted the then-empty `refs/dwarf-harness/runs/r1` directory (r1 dir exists=false afterwards) and the loose `main`. The following guarded update of packed `main` re-created a loose `refs/heads/main`. [INFERENCE] A directory to be synced after a ref move can disappear when refs are packed concurrently.
7. `SyncDir` on a missing directory returns `*fs.PathError` (Op `syncdir`) wrapping `syscall.Errno`: "The system cannot find the file specified." for a missing leaf, and "…path specified." for a missing parent. In both cases `os.IsNotExist` is true. A relative missing path behaves the same.
8. `SyncDir` on a 341-character directory path (created with `os.MkdirAll`) returned nil. `SyncDir` on a regular file also returned nil, so the function does not check that its target is a directory.
9. `go test -count=1 -v ./internal/core/durable` passed: TestExtendedPath with 5 subtests, TestLockIsExclusive and TestSyncDirAndRenameBeyondMaxPath.
10. At 2.45, `git rev-parse --show-ref-format` is documented ("Show the reference storage format used for the repository"), and `extensions.refStorage` accepts `files` (default) or `reftable` (marked experimental). On the installed Git, `rev-parse --show-ref-format` printed `files` (exit 0), and `config --get extensions.refStorage` exited 1 with no output, so the key is unset in the default-initialised repo.
11. Nothing here tests power loss or crash durability. A nil `SyncDir` result shows only that the flush call succeeded.


# Follow-up 2: byte-range locks and real append failures

## Setup
- Temp root (absolute): `C:/Users/darius.jones/AppData/Local/Temp/t08probe-lock-6jpbq3v8`, deleted at the end. Nothing was locked or written outside it, and nothing in the project repository.
- Module copy: `git -C C:/Users/darius.jones/Documents/PROJECTS/dwarf-harness archive --format=tar 702ca66 > C:/Users/darius.jones/AppData/Local/Temp/t08probe-lock-6jpbq3v8/mod.tar` → exit 0, empty stderr. Extracted to `C:/Users/darius.jones/AppData/Local/Temp/t08probe-lock-6jpbq3v8/mod`, and the throwaway `cmd/t08lock/main.go` was added there only.
- Run in `C:/Users/darius.jones/AppData/Local/Temp/t08probe-lock-6jpbq3v8/mod`: `GOTOOLCHAIN=local GOFLAGS= CGO_ENABLED=0 go run ./cmd/t08lock C:/Users/darius.jones/AppData/Local/Temp/t08probe-lock-6jpbq3v8/work` → exit 0, stderr `''`. Toolchain `go version go1.27.2 windows/amd64`, OS Windows-10-10.0.19045-SP0. It built offline as far as stderr shows, with no download lines. [INFERENCE] `golang.org/x/sys` came from the module cache.
- Exported APIs only: `ledgerstore.Create(dir, ledger.Defined())`, `Store.PublishBody`, `Store.Append`, `Store.Recover`, `Store.Close`, `ledgerstore.Open`, `Store.Durable`, `Store.LogDir`, `Store.Colony`, `ledger.OpenReader`. Each commit is one `ledger.body_pin` v1 record (Actor owner, one freshly published body, new UUIDv7 pin ID), the same draft shape as the package's `pinDraft` helper (`internal/core/ledgerstore/bodies_test.go:53-62`).
- Lock: a second handle `os.OpenFile(segment, O_RDWR)`, then `windows.LockFileEx(h, LOCKFILE_EXCLUSIVE_LOCK|LOCKFILE_FAIL_IMMEDIATELY, 0, len, &Overlapped{Offset: off})`. It is taken either in the same process or in a child process (the program re-executed with `child <path> <off> <len>`, holding the lock until its stdin closes). Ranges: "append-range" = offset at the segment's size after commit 1 (536), length 1 GiB; "byte0" = offset 0, length 1, the range `durable.LockFile` takes on its own file (`internal/core/durable/durable_windows.go:22`).
- Code under test (project, read-only):
  - `internal/core/ledgerstore/store.go:709-711`: a failed `write` sets `s.poison` and returns `fmt.Errorf("%w: %w", appender.ErrUncertain, err)`.
  - `store.go:643-644`: a poisoned store returns `appender.ErrPoisoned` wrapping the poison.
  - `store.go:763-775`: `write` is one `WriteAt(data, s.size)` followed by `Sync`.
  - `internal/core/ledgerstore/files.go:53-67`: segments are opened with `os.OpenFile` (`O_CREATE|O_EXCL|O_WRONLY` or `O_WRONLY`).
  - `contract/ledger/appender/appender.go:66-68`: "ErrUncertain marks an Append whose commit may or may not survive. It is not acknowledged, and the writer is now poisoned."

## Program
```go
// Throwaway T08 fault-injection probe: a Windows byte-range lock on the
// active log segment against a real ledgerstore append.
package main

import (
	"bufio"
	"context"
	"errors"
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
	"uuid"

	"github.com/Darius-PJ/dwarf-harness/contract/ledger"
	"github.com/Darius-PJ/dwarf-harness/contract/ledger/appender"
	"github.com/Darius-PJ/dwarf-harness/internal/core/durable"
	"github.com/Darius-PJ/dwarf-harness/internal/core/ledgerstore"
	"golang.org/x/sys/windows"
)

var sentinels = []struct {
	name string
	err  error
}{
	{"appender.ErrUncertain", appender.ErrUncertain},
	{"appender.ErrPoisoned", appender.ErrPoisoned},
	{"appender.ErrRefused", appender.ErrRefused},
	{"appender.ErrClosed", appender.ErrClosed},
	{"ledgerstore.ErrLocked", ledgerstore.ErrLocked},
	{"ledgerstore.ErrExists", ledgerstore.ErrExists},
	{"ledgerstore.ErrNotColony", ledgerstore.ErrNotColony},
	{"ledgerstore.ErrInconsistent", ledgerstore.ErrInconsistent},
	{"ledger.ErrCorrupt", ledger.ErrCorrupt},
	{"durable.ErrLocked", durable.ErrLocked},
	{"windows.ERROR_LOCK_VIOLATION", windows.ERROR_LOCK_VIOLATION},
}

func report(label string, err error) {
	if err == nil {
		fmt.Printf("  %s -> <nil>\n", label)
		return
	}
	var is []string
	for _, s := range sentinels {
		if errors.Is(err, s.err) {
			is = append(is, s.name)
		}
	}
	fmt.Printf("  %s -> %T: %v\n    errors.Is: %v\n", label, err, err, is)
	var chain []string
	for e := err; e != nil; {
		chain = append(chain, fmt.Sprintf("%T", e))
		switch u := e.(type) {
		case interface{ Unwrap() error }:
			e = u.Unwrap()
		case interface{ Unwrap() []error }:
			for _, x := range u.Unwrap() {
				chain = append(chain, fmt.Sprintf("[%T: %v]", x, x))
			}
			e = nil
		default:
			e = nil
		}
	}
	fmt.Printf("    chain: %s\n", strings.Join(chain, " -> "))
	var errno windows.Errno
	if errors.As(err, &errno) {
		fmt.Printf("    windows.Errno: %d (0x%x)\n", uint32(errno), uint32(errno))
	}
}

func commitOne(s *ledgerstore.Store, tag string) (appender.Committed, error) {
	d, _, err := s.PublishBody(context.Background(), strings.NewReader("t08lock body "+tag))
	if err != nil {
		return appender.Committed{}, fmt.Errorf("PublishBody: %w", err)
	}
	p, err := ledger.BodyPin{PinID: uuid.NewV7()}.Encode()
	if err != nil {
		return appender.Committed{}, err
	}
	draft := ledger.Draft{Type: ledger.TypeBodyPin, TypeVersion: 1, Actor: ledger.ActorOwner, BodyRefs: []ledger.Digest{d}, Payload: p}
	return s.Append(context.Background(), []ledger.Draft{draft})
}

func appendAndReport(s *ledgerstore.Store, label, tag string) {
	c, err := commitOne(s, tag)
	if err == nil {
		fmt.Printf("  %s -> Committed{First:%d Last:%d}\n", label, c.First, c.Last)
	} else {
		report(label, err)
	}
	fmt.Printf("    Durable()=%d\n", s.Durable())
}

func segments(logDir string) {
	entries, err := os.ReadDir(logDir)
	if err != nil {
		fmt.Printf("  log dir: %v\n", err)
		return
	}
	for _, e := range entries {
		info, _ := e.Info()
		fmt.Printf("  segment %s size=%d\n", e.Name(), info.Size())
	}
}

func readAll(logDir string, colony uuid.UUID) {
	r, err := ledger.OpenReader(logDir, ledger.ReadOptions{Colony: colony, Through: ledger.ToEnd, AllTypes: true})
	if err != nil {
		report("OpenReader", err)
		return
	}
	defer r.Close()
	for {
		c, err := r.Next()
		if err == io.EOF {
			fmt.Printf("  reader: io.EOF at cursor %d\n", r.Cursor())
			return
		}
		if err != nil {
			report("reader.Next", err)
			return
		}
		fmt.Printf("  reader: commit %d-%d (%d records)\n", c.First, c.Last, len(c.Records))
	}
}

// locker holds an exclusive byte-range lock on path from another handle,
// in this process or in a child process.
type locker struct {
	f     *os.File
	ol    windows.Overlapped
	lo    uint32
	hi    uint32
	child *exec.Cmd
	stdin io.WriteCloser
}

func lockRange(path string, off, n uint64, viaChild bool) (*locker, error) {
	if viaChild {
		cmd := exec.Command(os.Args[0], "child", path, strconv.FormatUint(off, 10), strconv.FormatUint(n, 10))
		cmd.Stderr = os.Stderr
		in, err := cmd.StdinPipe()
		if err != nil {
			return nil, err
		}
		out, err := cmd.StdoutPipe()
		if err != nil {
			return nil, err
		}
		if err := cmd.Start(); err != nil {
			return nil, err
		}
		line, _ := bufio.NewReader(out).ReadString('\n')
		fmt.Printf("  child pid %d says: %q\n", cmd.Process.Pid, line)
		if !strings.HasPrefix(line, "locked") {
			in.Close()
			cmd.Wait()
			return nil, fmt.Errorf("child: %s", line)
		}
		return &locker{child: cmd, stdin: in}, nil
	}
	f, err := os.OpenFile(path, os.O_RDWR, 0)
	if err != nil {
		return nil, err
	}
	l := &locker{f: f, lo: uint32(n), hi: uint32(n >> 32)}
	l.ol.Offset, l.ol.OffsetHigh = uint32(off), uint32(off>>32)
	if err := windows.LockFileEx(windows.Handle(f.Fd()), windows.LOCKFILE_EXCLUSIVE_LOCK|windows.LOCKFILE_FAIL_IMMEDIATELY, 0, l.lo, l.hi, &l.ol); err != nil {
		f.Close()
		return nil, err
	}
	return l, nil
}

func (l *locker) release() error {
	if l.child != nil {
		l.stdin.Close()
		return l.child.Wait()
	}
	err := windows.UnlockFileEx(windows.Handle(l.f.Fd()), 0, l.lo, l.hi, &l.ol)
	return errors.Join(err, l.f.Close())
}

func childMain() {
	path := os.Args[2]
	off, _ := strconv.ParseUint(os.Args[3], 10, 64)
	n, _ := strconv.ParseUint(os.Args[4], 10, 64)
	l, err := lockRange(path, off, n, false)
	if err != nil {
		fmt.Printf("lockerr %v\n", err)
		os.Exit(1)
	}
	fmt.Printf("locked off=%d len=%d\n", off, n)
	io.ReadAll(os.Stdin)
	if err := l.release(); err != nil {
		fmt.Fprintf(os.Stderr, "child release: %v\n", err)
		os.Exit(1)
	}
}

type scenario struct {
	name       string
	appendSide bool // lock from the segment's size onward; otherwise byte 0 only
	viaChild   bool
	recover    bool // call Recover while held and after release, before Close
}

func run(root string, sc scenario) {
	fmt.Printf("\n===== scenario %s (appendRange=%v child=%v recover=%v)\n", sc.name, sc.appendSide, sc.viaChild, sc.recover)
	dir := filepath.Join(root, "colony-"+sc.name)
	s, err := ledgerstore.Create(dir, ledger.Defined())
	report("Create", err)
	if err != nil {
		return
	}
	colony, logDir := s.Colony(), s.LogDir()
	appendAndReport(s, "Append #1 (no lock)", sc.name+"-1")
	segments(logDir)
	entries, _ := os.ReadDir(logDir)
	seg := filepath.Join(logDir, entries[len(entries)-1].Name())
	info, _ := os.Stat(seg)
	off, n := uint64(0), uint64(1)
	if sc.appendSide {
		off, n = uint64(info.Size()), 1<<30
	}
	l, err := lockRange(seg, off, n, sc.viaChild)
	fmt.Printf("  LockFileEx on %s off=%d len=%d -> %v\n", filepath.Base(seg), off, n, err)
	if err != nil {
		return
	}
	held := true
	defer func() {
		if held {
			l.release()
		}
	}()
	appendAndReport(s, "Append #2 (lock held)", sc.name+"-2")
	segments(logDir)
	appendAndReport(s, "Append #3 (lock held)", sc.name+"-3")
	if sc.recover {
		report("Recover (lock held)", s.Recover())
		segments(logDir)
		appendAndReport(s, "Append after Recover (lock held)", sc.name+"-r1")
	}
	if sc.recover {
		report("release lock", l.release())
		held = false
		report("Recover (lock released)", s.Recover())
		segments(logDir)
		appendAndReport(s, "Append after Recover (lock released)", sc.name+"-r2")
	}
	report("Close", s.Close())
	if held {
		fmt.Println("  -- lock still held, store closed:")
		readAll(logDir, colony)
		s2, rec, err := ledgerstore.Open(dir, ledger.Defined())
		report("Open (lock held)", err)
		if err == nil {
			fmt.Printf("    Recovery=%+v Durable()=%d\n", rec, s2.Durable())
			appendAndReport(s2, "Append on reopened store (lock held)", sc.name+"-4")
			segments(logDir)
			report("Close reopened store (lock held)", s2.Close())
		}
		_, err = ledgerstore.Create(dir, ledger.Defined())
		report("Create same dir (lock held)", err)
		report("release lock", l.release())
		held = false
	}
	fmt.Println("  -- lock released:")
	s3, rec, err := ledgerstore.Open(dir, ledger.Defined())
	report("Open (after release)", err)
	if err != nil {
		return
	}
	fmt.Printf("    Recovery=%+v Durable()=%d\n", rec, s3.Durable())
	segments(logDir)
	readAll(logDir, colony)
	appendAndReport(s3, "Append after reopen", sc.name+"-5")
	report("Close", s3.Close())
}

func main() {
	if len(os.Args) > 1 && os.Args[1] == "child" {
		childMain()
		return
	}
	root := os.Args[1]
	for _, sc := range []scenario{
		{name: "append-range", appendSide: true},
		{name: "append-range-child", appendSide: true, viaChild: true},
		{name: "byte0", appendSide: false},
		{name: "byte0-child", appendSide: false, viaChild: true},
		{name: "append-range-recover", appendSide: true, recover: true},
	} {
		run(root, sc)
	}
}
```

## Raw output
```

===== scenario append-range (appendRange=true child=false recover=false)
  Create -> <nil>
  Append #1 (no lock) -> Committed{First:1 Last:1}
    Durable()=1
  segment 00000000000000000001.jsonl size=536
  LockFileEx on 00000000000000000001.jsonl off=536 len=1073741824 -> <nil>
  Append #2 (lock held) -> *fmt.wrapErrors: appender: commit outcome uncertain: writing 00000000000000000001.jsonl: write C:\Users\darius.jones\AppData\Local\Temp\t08probe-lock-6jpbq3v8\work\colony-append-range\log\00000000000000000001.jsonl: The process cannot access the file because another process has locked a portion of the file.
    errors.Is: [appender.ErrUncertain windows.ERROR_LOCK_VIOLATION]
    chain: *fmt.wrapErrors -> [*errors.errorString: appender: commit outcome uncertain] -> [*fmt.wrapError: writing 00000000000000000001.jsonl: write C:\Users\darius.jones\AppData\Local\Temp\t08probe-lock-6jpbq3v8\work\colony-append-range\log\00000000000000000001.jsonl: The process cannot access the file because another process has locked a portion of the file.]
    windows.Errno: 33 (0x21)
    Durable()=1
  segment 00000000000000000001.jsonl size=536
  Append #3 (lock held) -> *fmt.wrapErrors: appender: writer poisoned; recovery required: writing 00000000000000000001.jsonl: write C:\Users\darius.jones\AppData\Local\Temp\t08probe-lock-6jpbq3v8\work\colony-append-range\log\00000000000000000001.jsonl: The process cannot access the file because another process has locked a portion of the file.
    errors.Is: [appender.ErrPoisoned windows.ERROR_LOCK_VIOLATION]
    chain: *fmt.wrapErrors -> [*errors.errorString: appender: writer poisoned; recovery required] -> [*fmt.wrapError: writing 00000000000000000001.jsonl: write C:\Users\darius.jones\AppData\Local\Temp\t08probe-lock-6jpbq3v8\work\colony-append-range\log\00000000000000000001.jsonl: The process cannot access the file because another process has locked a portion of the file.]
    windows.Errno: 33 (0x21)
    Durable()=1
  Close -> <nil>
  -- lock still held, store closed:
  reader.Next -> *fs.PathError: read C:\Users\darius.jones\AppData\Local\Temp\t08probe-lock-6jpbq3v8\work\colony-append-range\log\00000000000000000001.jsonl: The process cannot access the file because another process has locked a portion of the file.
    errors.Is: [windows.ERROR_LOCK_VIOLATION]
    chain: *fs.PathError -> syscall.Errno
    windows.Errno: 33 (0x21)
  Open (lock held) -> *errors.joinError: read C:\Users\darius.jones\AppData\Local\Temp\t08probe-lock-6jpbq3v8\work\colony-append-range\log\00000000000000000001.jsonl: The process cannot access the file because another process has locked a portion of the file.
    errors.Is: [windows.ERROR_LOCK_VIOLATION]
    chain: *errors.joinError -> [*fs.PathError: read C:\Users\darius.jones\AppData\Local\Temp\t08probe-lock-6jpbq3v8\work\colony-append-range\log\00000000000000000001.jsonl: The process cannot access the file because another process has locked a portion of the file.]
    windows.Errno: 33 (0x21)
  Create same dir (lock held) -> *fmt.wrapError: ledgerstore: colony already exists: C:\Users\darius.jones\AppData\Local\Temp\t08probe-lock-6jpbq3v8\work\colony-append-range
    errors.Is: [ledgerstore.ErrExists]
    chain: *fmt.wrapError -> *errors.errorString
  release lock -> <nil>
  -- lock released:
  Open (after release) -> <nil>
    Recovery={Segment: TruncatedBytes:0} Durable()=1
  segment 00000000000000000001.jsonl size=536
  reader: commit 1-1 (1 records)
  reader: io.EOF at cursor 1
  Append after reopen -> Committed{First:2 Last:2}
    Durable()=2
  Close -> <nil>

===== scenario append-range-child (appendRange=true child=true recover=false)
  Create -> <nil>
  Append #1 (no lock) -> Committed{First:1 Last:1}
    Durable()=1
  segment 00000000000000000001.jsonl size=536
  child pid 13016 says: "locked off=536 len=1073741824\n"
  LockFileEx on 00000000000000000001.jsonl off=536 len=1073741824 -> <nil>
  Append #2 (lock held) -> *fmt.wrapErrors: appender: commit outcome uncertain: writing 00000000000000000001.jsonl: write C:\Users\darius.jones\AppData\Local\Temp\t08probe-lock-6jpbq3v8\work\colony-append-range-child\log\00000000000000000001.jsonl: The process cannot access the file because another process has locked a portion of the file.
    errors.Is: [appender.ErrUncertain windows.ERROR_LOCK_VIOLATION]
    chain: *fmt.wrapErrors -> [*errors.errorString: appender: commit outcome uncertain] -> [*fmt.wrapError: writing 00000000000000000001.jsonl: write C:\Users\darius.jones\AppData\Local\Temp\t08probe-lock-6jpbq3v8\work\colony-append-range-child\log\00000000000000000001.jsonl: The process cannot access the file because another process has locked a portion of the file.]
    windows.Errno: 33 (0x21)
    Durable()=1
  segment 00000000000000000001.jsonl size=536
  Append #3 (lock held) -> *fmt.wrapErrors: appender: writer poisoned; recovery required: writing 00000000000000000001.jsonl: write C:\Users\darius.jones\AppData\Local\Temp\t08probe-lock-6jpbq3v8\work\colony-append-range-child\log\00000000000000000001.jsonl: The process cannot access the file because another process has locked a portion of the file.
    errors.Is: [appender.ErrPoisoned windows.ERROR_LOCK_VIOLATION]
    chain: *fmt.wrapErrors -> [*errors.errorString: appender: writer poisoned; recovery required] -> [*fmt.wrapError: writing 00000000000000000001.jsonl: write C:\Users\darius.jones\AppData\Local\Temp\t08probe-lock-6jpbq3v8\work\colony-append-range-child\log\00000000000000000001.jsonl: The process cannot access the file because another process has locked a portion of the file.]
    windows.Errno: 33 (0x21)
    Durable()=1
  Close -> <nil>
  -- lock still held, store closed:
  reader.Next -> *fs.PathError: read C:\Users\darius.jones\AppData\Local\Temp\t08probe-lock-6jpbq3v8\work\colony-append-range-child\log\00000000000000000001.jsonl: The process cannot access the file because another process has locked a portion of the file.
    errors.Is: [windows.ERROR_LOCK_VIOLATION]
    chain: *fs.PathError -> syscall.Errno
    windows.Errno: 33 (0x21)
  Open (lock held) -> *errors.joinError: read C:\Users\darius.jones\AppData\Local\Temp\t08probe-lock-6jpbq3v8\work\colony-append-range-child\log\00000000000000000001.jsonl: The process cannot access the file because another process has locked a portion of the file.
    errors.Is: [windows.ERROR_LOCK_VIOLATION]
    chain: *errors.joinError -> [*fs.PathError: read C:\Users\darius.jones\AppData\Local\Temp\t08probe-lock-6jpbq3v8\work\colony-append-range-child\log\00000000000000000001.jsonl: The process cannot access the file because another process has locked a portion of the file.]
    windows.Errno: 33 (0x21)
  Create same dir (lock held) -> *fmt.wrapError: ledgerstore: colony already exists: C:\Users\darius.jones\AppData\Local\Temp\t08probe-lock-6jpbq3v8\work\colony-append-range-child
    errors.Is: [ledgerstore.ErrExists]
    chain: *fmt.wrapError -> *errors.errorString
  release lock -> <nil>
  -- lock released:
  Open (after release) -> <nil>
    Recovery={Segment: TruncatedBytes:0} Durable()=1
  segment 00000000000000000001.jsonl size=536
  reader: commit 1-1 (1 records)
  reader: io.EOF at cursor 1
  Append after reopen -> Committed{First:2 Last:2}
    Durable()=2
  Close -> <nil>

===== scenario byte0 (appendRange=false child=false recover=false)
  Create -> <nil>
  Append #1 (no lock) -> Committed{First:1 Last:1}
    Durable()=1
  segment 00000000000000000001.jsonl size=536
  LockFileEx on 00000000000000000001.jsonl off=0 len=1 -> <nil>
  Append #2 (lock held) -> Committed{First:2 Last:2}
    Durable()=2
  segment 00000000000000000001.jsonl size=1072
  Append #3 (lock held) -> Committed{First:3 Last:3}
    Durable()=3
  Close -> <nil>
  -- lock still held, store closed:
  reader.Next -> *fs.PathError: read C:\Users\darius.jones\AppData\Local\Temp\t08probe-lock-6jpbq3v8\work\colony-byte0\log\00000000000000000001.jsonl: The process cannot access the file because another process has locked a portion of the file.
    errors.Is: [windows.ERROR_LOCK_VIOLATION]
    chain: *fs.PathError -> syscall.Errno
    windows.Errno: 33 (0x21)
  Open (lock held) -> *errors.joinError: read C:\Users\darius.jones\AppData\Local\Temp\t08probe-lock-6jpbq3v8\work\colony-byte0\log\00000000000000000001.jsonl: The process cannot access the file because another process has locked a portion of the file.
    errors.Is: [windows.ERROR_LOCK_VIOLATION]
    chain: *errors.joinError -> [*fs.PathError: read C:\Users\darius.jones\AppData\Local\Temp\t08probe-lock-6jpbq3v8\work\colony-byte0\log\00000000000000000001.jsonl: The process cannot access the file because another process has locked a portion of the file.]
    windows.Errno: 33 (0x21)
  Create same dir (lock held) -> *fmt.wrapError: ledgerstore: colony already exists: C:\Users\darius.jones\AppData\Local\Temp\t08probe-lock-6jpbq3v8\work\colony-byte0
    errors.Is: [ledgerstore.ErrExists]
    chain: *fmt.wrapError -> *errors.errorString
  release lock -> <nil>
  -- lock released:
  Open (after release) -> <nil>
    Recovery={Segment: TruncatedBytes:0} Durable()=3
  segment 00000000000000000001.jsonl size=1608
  reader: commit 1-1 (1 records)
  reader: commit 2-2 (1 records)
  reader: commit 3-3 (1 records)
  reader: io.EOF at cursor 3
  Append after reopen -> Committed{First:4 Last:4}
    Durable()=4
  Close -> <nil>

===== scenario byte0-child (appendRange=false child=true recover=false)
  Create -> <nil>
  Append #1 (no lock) -> Committed{First:1 Last:1}
    Durable()=1
  segment 00000000000000000001.jsonl size=536
  child pid 6764 says: "locked off=0 len=1\n"
  LockFileEx on 00000000000000000001.jsonl off=0 len=1 -> <nil>
  Append #2 (lock held) -> Committed{First:2 Last:2}
    Durable()=2
  segment 00000000000000000001.jsonl size=1072
  Append #3 (lock held) -> Committed{First:3 Last:3}
    Durable()=3
  Close -> <nil>
  -- lock still held, store closed:
  reader.Next -> *fs.PathError: read C:\Users\darius.jones\AppData\Local\Temp\t08probe-lock-6jpbq3v8\work\colony-byte0-child\log\00000000000000000001.jsonl: The process cannot access the file because another process has locked a portion of the file.
    errors.Is: [windows.ERROR_LOCK_VIOLATION]
    chain: *fs.PathError -> syscall.Errno
    windows.Errno: 33 (0x21)
  Open (lock held) -> *errors.joinError: read C:\Users\darius.jones\AppData\Local\Temp\t08probe-lock-6jpbq3v8\work\colony-byte0-child\log\00000000000000000001.jsonl: The process cannot access the file because another process has locked a portion of the file.
    errors.Is: [windows.ERROR_LOCK_VIOLATION]
    chain: *errors.joinError -> [*fs.PathError: read C:\Users\darius.jones\AppData\Local\Temp\t08probe-lock-6jpbq3v8\work\colony-byte0-child\log\00000000000000000001.jsonl: The process cannot access the file because another process has locked a portion of the file.]
    windows.Errno: 33 (0x21)
  Create same dir (lock held) -> *fmt.wrapError: ledgerstore: colony already exists: C:\Users\darius.jones\AppData\Local\Temp\t08probe-lock-6jpbq3v8\work\colony-byte0-child
    errors.Is: [ledgerstore.ErrExists]
    chain: *fmt.wrapError -> *errors.errorString
  release lock -> <nil>
  -- lock released:
  Open (after release) -> <nil>
    Recovery={Segment: TruncatedBytes:0} Durable()=3
  segment 00000000000000000001.jsonl size=1608
  reader: commit 1-1 (1 records)
  reader: commit 2-2 (1 records)
  reader: commit 3-3 (1 records)
  reader: io.EOF at cursor 3
  Append after reopen -> Committed{First:4 Last:4}
    Durable()=4
  Close -> <nil>

===== scenario append-range-recover (appendRange=true child=false recover=true)
  Create -> <nil>
  Append #1 (no lock) -> Committed{First:1 Last:1}
    Durable()=1
  segment 00000000000000000001.jsonl size=536
  LockFileEx on 00000000000000000001.jsonl off=536 len=1073741824 -> <nil>
  Append #2 (lock held) -> *fmt.wrapErrors: appender: commit outcome uncertain: writing 00000000000000000001.jsonl: write C:\Users\darius.jones\AppData\Local\Temp\t08probe-lock-6jpbq3v8\work\colony-append-range-recover\log\00000000000000000001.jsonl: The process cannot access the file because another process has locked a portion of the file.
    errors.Is: [appender.ErrUncertain windows.ERROR_LOCK_VIOLATION]
    chain: *fmt.wrapErrors -> [*errors.errorString: appender: commit outcome uncertain] -> [*fmt.wrapError: writing 00000000000000000001.jsonl: write C:\Users\darius.jones\AppData\Local\Temp\t08probe-lock-6jpbq3v8\work\colony-append-range-recover\log\00000000000000000001.jsonl: The process cannot access the file because another process has locked a portion of the file.]
    windows.Errno: 33 (0x21)
    Durable()=1
  segment 00000000000000000001.jsonl size=536
  Append #3 (lock held) -> *fmt.wrapErrors: appender: writer poisoned; recovery required: writing 00000000000000000001.jsonl: write C:\Users\darius.jones\AppData\Local\Temp\t08probe-lock-6jpbq3v8\work\colony-append-range-recover\log\00000000000000000001.jsonl: The process cannot access the file because another process has locked a portion of the file.
    errors.Is: [appender.ErrPoisoned windows.ERROR_LOCK_VIOLATION]
    chain: *fmt.wrapErrors -> [*errors.errorString: appender: writer poisoned; recovery required] -> [*fmt.wrapError: writing 00000000000000000001.jsonl: write C:\Users\darius.jones\AppData\Local\Temp\t08probe-lock-6jpbq3v8\work\colony-append-range-recover\log\00000000000000000001.jsonl: The process cannot access the file because another process has locked a portion of the file.]
    windows.Errno: 33 (0x21)
    Durable()=1
  Recover (lock held) -> <nil>
  segment 00000000000000000001.jsonl size=536
  Append after Recover (lock held) -> *fmt.wrapErrors: appender: commit outcome uncertain: writing 00000000000000000001.jsonl: write C:\Users\darius.jones\AppData\Local\Temp\t08probe-lock-6jpbq3v8\work\colony-append-range-recover\log\00000000000000000001.jsonl: The process cannot access the file because another process has locked a portion of the file.
    errors.Is: [appender.ErrUncertain windows.ERROR_LOCK_VIOLATION]
    chain: *fmt.wrapErrors -> [*errors.errorString: appender: commit outcome uncertain] -> [*fmt.wrapError: writing 00000000000000000001.jsonl: write C:\Users\darius.jones\AppData\Local\Temp\t08probe-lock-6jpbq3v8\work\colony-append-range-recover\log\00000000000000000001.jsonl: The process cannot access the file because another process has locked a portion of the file.]
    windows.Errno: 33 (0x21)
    Durable()=1
  release lock -> <nil>
  Recover (lock released) -> <nil>
  segment 00000000000000000001.jsonl size=536
  Append after Recover (lock released) -> Committed{First:2 Last:2}
    Durable()=2
  Close -> <nil>
  -- lock released:
  Open (after release) -> <nil>
    Recovery={Segment: TruncatedBytes:0} Durable()=2
  segment 00000000000000000001.jsonl size=1072
  reader: commit 1-1 (1 records)
  reader: commit 2-2 (1 records)
  reader: io.EOF at cursor 2
  Append after reopen -> Committed{First:3 Last:3}
    Durable()=3
  Close -> <nil>
```

## Observations (follow-up 2)
1. **Yes, a real lock makes a real append fail.** An exclusive `LockFileEx` from another handle, covering the segment from its current size onward, made the next `Append` fail. The second handle can be in the same process or in a child process; the results were identical. The error is `appender: commit outcome uncertain: writing 00000000000000000001.jsonl: write <path>: The process cannot access the file because another process has locked a portion of the file.` `errors.Is` matches `appender.ErrUncertain` and `windows.ERROR_LOCK_VIOLATION` (Errno 33). It matches none of `ErrPoisoned`, `ErrRefused`, `ErrClosed`, `ledgerstore.ErrLocked/ErrExists/ErrNotColony/ErrInconsistent`, `ledger.ErrCorrupt` or `durable.ErrLocked`. The concrete type is `*fmt.wrapErrors`.
2. **Nothing was written.** After the failed append, `Durable()` stayed 1 and the segment size stayed 536. [INFERENCE] The `WriteAt` was refused as a whole, before any byte landed. The store still classifies it as uncertain, per its contract, because it cannot know that.
3. **The store is then poisoned.** The third `Append` returned `appender: writer poisoned; recovery required: <same write error>`, which matches `appender.ErrPoisoned` and `ERROR_LOCK_VIOLATION`, but not `ErrUncertain`. `Close` returned nil with the lock still held.
4. **Recovery after release.** Once the lock was released, `ledgerstore.Open` returned `Recovery={Segment:"" TruncatedBytes:0}` and `Durable()=1`. The reader saw only commit 1-1. The second commit does not exist, and the next append got seq 2.
5. **`Recover()` while the lock is held** returned nil and left the segment at 536 bytes. The next append, with the lock still held, failed again with `ErrUncertain` and re-poisoned the store. After release, `Recover()` returned nil and the next append got seq 2. Reopening then gave `Recovery={"" 0}`, `Durable()=2`. [INFERENCE] Recover cannot tell that the cause is still present; it clears the poison and the next write fails the same way.
6. **A byte-0 lock does not affect appends.** With the lock covering only byte 0, appends #2 and #3 succeeded (seq 2 and 3, segment 536 → 1072 → 1608), in both the same-process and the child variants. A lock that does not overlap the write range does not affect `WriteAt` or `Sync`.
7. **A lock on the segment blocks `Open` and readers, whichever range it covers.** With the store closed and either lock held (append-range or byte 0, same process or child), `ledgerstore.Open` failed with `*errors.joinError` wrapping `*fs.PathError` `read <segment>: …locked a portion of the file` (`ERROR_LOCK_VIOLATION`). It matched no ledgerstore or ledger sentinel, including `ErrCorrupt`, and returned no store. `ledger.OpenReader(...).Next()` failed the same way, with `*fs.PathError` wrapping `syscall.Errno` 33. [INFERENCE] The append-range lock lies entirely past the end of the file. The read still collides with it, so the scanner's read request must extend past EOF into the locked range.
8. **The failed `Open` did not keep the colony lock.** After release, `Open` succeeded at once (no `ErrLocked`).
9. **`Create` is unaffected by the segment lock.** `Create` on the same directory with the lock held returned `ledgerstore: colony already exists: <dir>`, matching `ledgerstore.ErrExists`: it stops at `colony.json` before touching the log. [INFERENCE] `Create` in a fresh directory involves no locked file, so a segment lock elsewhere cannot block it. That case was not run.
10. **Same-process locks are enough to inject the fault.** A lock from a second handle in the same process blocked the store's own handle exactly as a lock from another process did. Windows byte-range locks belong to the handle, so they are enforced against other handles of the same process too. [INFERENCE] That is the documented LockFileEx semantics; I did not quote Microsoft's documentation.
11. This is fault injection in a disposable colony. Nothing here tests power loss or crash durability.

# Follow-up 3 (S1): Probe: Git's GIT_DIR length limit on this machine (PM, 2026-10-16)

The probe used Git 2.55.0.windows.3 with `GIT_CONFIG_NOSYSTEM=1` and `GIT_CONFIG_GLOBAL=NUL`. It made a repository under `C:\Users\darius.jones\AppData\Local\Temp\t08longprobe`, moved its `.git` into longer directories through `\\?\` paths, and ran `git --git-dir=<path> rev-parse refs/heads/main`. The probe directory was removed afterwards.

- A `GIT_DIR` of 220 characters works. One of 221 characters fails with exit 128: `fatal: '$GIT_DIR' too big`, which is MAX_PATH 260 minus 40.
- At 349 characters, the same error came back for `rev-parse`, for `-c core.longpaths=true … rev-parse`, for `--git-dir=\\?\<path>` and for the guarded `update-ref --no-deref --end-of-options refs/heads/main <new> <old>`.
- `git init --bare <long>` fails with "cannot mkdir"; with `core.longpaths=true` it fails with "cannot chdir".

**Consequence:** no working canonical common directory is longer than 220 characters, so every directory `hardenCanonicalStorage` flushes stays under 260. SyncDir's long-path support is already tested in `internal/core/durable/durable_test.go:41-44`, and ticket 08's probe tested it on a 341-character directory (`local://t08-git-probes.md:1222`).
