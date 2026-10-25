# Git probes for ticket 06 (DesignT06's request 1), run by the PM on 2026-10-12

`git version 2.55.0.windows.3`, on this machine (Windows 10.0.19045; system config `core.autocrlf=true`, `core.symlinks=false`, per ticket 05's brief Appendix D). Throwaway SHA-1 repositories under `%TEMP%\t06probe-*`, created with `git init -b main --object-format=sha1` and normal commits (so the system config applied to them), deleted afterwards. The PM ran the commands through Python's `subprocess` with exact argument lists; `stdout` is shown as Python bytes `repr` (NUL is `\x00`). All cases: base `a.txt` = `1\n2\n3\n4\n5\n`; (a) clean: P edits line 1, S edits line 5; (b) one content conflict: both edit line 3; (c) modify/delete: P edits line 3, S deletes `a.txt` (S's tree is then the empty tree 4b825dc…); (d) two conflicted files `a.txt` and `b.txt`.

## M1. Tree arguments (`--merge-base=<B tree>`, P as commit or tree, S as tree), `-z --name-only`; `--end-of-options`
```text
{
 "a": {
  "commitP_treeS": {
   "args": "git merge-tree --write-tree -z --name-only --merge-base=c2198acc77776c79895429177e90f30bd09b62df 97560258fc3e7556565089f8cc2c876cd5e93c43 288b54bfab8be6369404c9f65bb3953416c26e0b",
   "exit": 0,
   "stdout": "b'cb7c597a115a9e5750df399bb8249f885167af0e\\x00'",
   "stderr": ""
  },
  "treeP_treeS": {
   "args": "git merge-tree --write-tree -z --name-only --merge-base=c2198acc77776c79895429177e90f30bd09b62df 9bd5f3cf8e141ac6ef99c097da5ce8745cb784ac 288b54bfab8be6369404c9f65bb3953416c26e0b",
   "exit": 0,
   "stdout": "b'cb7c597a115a9e5750df399bb8249f885167af0e\\x00'",
   "stderr": ""
  },
  "endOfOptions_treeP_treeS": {
   "args": "git merge-tree --write-tree -z --name-only --merge-base=c2198acc77776c79895429177e90f30bd09b62df --end-of-options 9bd5f3cf8e141ac6ef99c097da5ce8745cb784ac 288b54bfab8be6369404c9f65bb3953416c26e0b",
   "exit": 0,
   "stdout": "b'cb7c597a115a9e5750df399bb8249f885167af0e\\x00'",
   "stderr": ""
  },
  "ids": {
   "B": "8b428abedef09b638bcc090a1816f6dcb56ba44e",
   "Btree": "c2198acc77776c79895429177e90f30bd09b62df",
   "P": "97560258fc3e7556565089f8cc2c876cd5e93c43",
   "Ptree": "9bd5f3cf8e141ac6ef99c097da5ce8745cb784ac",
   "S": "546888bccabf1faaa324ff223626f4995ecaae81",
   "Stree": "288b54bfab8be6369404c9f65bb3953416c26e0b"
  }
 },
 "b": {
  "commitP_treeS": {
   "args": "git merge-tree --write-tree -z --name-only --merge-base=c2198acc77776c79895429177e90f30bd09b62df 0a3fac55d50d966620b95a1e1737e865eb4da5ff 94997acf115ee3522bc2a52fa475bcd32f8dc880",
   "exit": 1,
   "stdout": "b'35c0fc039b83579a1fd774fe1c520893141fa01a\\x00a.txt\\x00\\x001\\x00a.txt\\x00Auto-merging\\x00Auto-merging a.txt\\n\\x001\\x00a.txt\\x00CONFLICT (contents)\\x00CONFLICT (content): Merge conflict in a.txt\\n\\x00'",
   "stderr": ""
  },
  "treeP_treeS": {
   "args": "git merge-tree --write-tree -z --name-only --merge-base=c2198acc77776c79895429177e90f30bd09b62df 6e52d5546ff8b5210031e0ec82525c88b8b8a479 94997acf115ee3522bc2a52fa475bcd32f8dc880",
   "exit": 1,
   "stdout": "b'8189dda5680d3e2375f07a7f055dfff728a943df\\x00a.txt\\x00\\x001\\x00a.txt\\x00Auto-merging\\x00Auto-merging a.txt\\n\\x001\\x00a.txt\\x00CONFLICT (contents)\\x00CONFLICT (content): Merge conflict in a.txt\\n\\x00'",
   "stderr": ""
  },
  "endOfOptions_treeP_treeS": {
   "args": "git merge-tree --write-tree -z --name-only --merge-base=c2198acc77776c79895429177e90f30bd09b62df --end-of-options 6e52d5546ff8b5210031e0ec82525c88b8b8a479 94997acf115ee3522bc2a52fa475bcd32f8dc880",
   "exit": 1,
   "stdout": "b'8189dda5680d3e2375f07a7f055dfff728a943df\\x00a.txt\\x00\\x001\\x00a.txt\\x00Auto-merging\\x00Auto-merging a.txt\\n\\x001\\x00a.txt\\x00CONFLICT (contents)\\x00CONFLICT (content): Merge conflict in a.txt\\n\\x00'",
   "stderr": ""
  },
  "ids": {
   "B": "4f4d99998f9d9a512e453d8b8742d64fb8564c24",
   "Btree": "c2198acc77776c79895429177e90f30bd09b62df",
   "P": "0a3fac55d50d966620b95a1e1737e865eb4da5ff",
   "Ptree": "6e52d5546ff8b5210031e0ec82525c88b8b8a479",
   "S": "e760c02b8849ad9e7d667daa1ac6949cd8d5ae55",
   "Stree": "94997acf115ee3522bc2a52fa475bcd32f8dc880"
  },
  "treeP_treeS_without_name_only": {
   "args": "git merge-tree --write-tree -z --merge-base=c2198acc77776c79895429177e90f30bd09b62df 6e52d5546ff8b5210031e0ec82525c88b8b8a479 94997acf115ee3522bc2a52fa475bcd32f8dc880",
   "exit": 1,
   "stdout": "b'8189dda5680d3e2375f07a7f055dfff728a943df\\x00100644 8a1218a1024a212bb3db30becd860315f9f3ac52 1\\ta.txt\\x00100644 0b6c4e0754ba174b082c68295f4f35e2c34b192d 2\\ta.txt\\x00100644 e4b12ae2dee8907c20ba82d2010ef15da05250d9 3\\ta.txt\\x00\\x001\\x00a.txt\\x00Auto-merging\\x00Auto-merging a.txt\\n\\x001\\x00a.txt\\x00CONFLICT (contents)\\x00CONFLICT (content): Merge conflict in a.txt\\n\\x00'",
   "stderr": ""
  }
 },
 "c": {
  "commitP_treeS": {
   "args": "git merge-tree --write-tree -z --name-only --merge-base=c2198acc77776c79895429177e90f30bd09b62df 79bbc262734cbb707e2f31126da6bdb22b75acfc 4b825dc642cb6eb9a060e54bf8d69288fbee4904",
   "exit": 1,
   "stdout": "b'6e52d5546ff8b5210031e0ec82525c88b8b8a479\\x00a.txt\\x00\\x001\\x00a.txt\\x00CONFLICT (modify/delete)\\x00CONFLICT (modify/delete): a.txt deleted in 4b825dc642cb6eb9a060e54bf8d69288fbee4904 and modified in 79bbc262734cbb707e2f31126da6bdb22b75acfc.  Version 79bbc262734cbb707e2f31126da6bdb22b75acfc of a.txt left in tree.\\n\\x00'",
   "stderr": ""
  },
  "treeP_treeS": {
   "args": "git merge-tree --write-tree -z --name-only --merge-base=c2198acc77776c79895429177e90f30bd09b62df 6e52d5546ff8b5210031e0ec82525c88b8b8a479 4b825dc642cb6eb9a060e54bf8d69288fbee4904",
   "exit": 1,
   "stdout": "b'6e52d5546ff8b5210031e0ec82525c88b8b8a479\\x00a.txt\\x00\\x001\\x00a.txt\\x00CONFLICT (modify/delete)\\x00CONFLICT (modify/delete): a.txt deleted in 4b825dc642cb6eb9a060e54bf8d69288fbee4904 and modified in 6e52d5546ff8b5210031e0ec82525c88b8b8a479.  Version 6e52d5546ff8b5210031e0ec82525c88b8b8a479 of a.txt left in tree.\\n\\x00'",
   "stderr": ""
  },
  "endOfOptions_treeP_treeS": {
   "args": "git merge-tree --write-tree -z --name-only --merge-base=c2198acc77776c79895429177e90f30bd09b62df --end-of-options 6e52d5546ff8b5210031e0ec82525c88b8b8a479 4b825dc642cb6eb9a060e54bf8d69288fbee4904",
   "exit": 1,
   "stdout": "b'6e52d5546ff8b5210031e0ec82525c88b8b8a479\\x00a.txt\\x00\\x001\\x00a.txt\\x00CONFLICT (modify/delete)\\x00CONFLICT (modify/delete): a.txt deleted in 4b825dc642cb6eb9a060e54bf8d69288fbee4904 and modified in 6e52d5546ff8b5210031e0ec82525c88b8b8a479.  Version 6e52d5546ff8b5210031e0ec82525c88b8b8a479 of a.txt left in tree.\\n\\x00'",
   "stderr": ""
  },
  "ids": {
   "B": "ed9077acd4e73b96361a91ae7c27ae653c14049e",
   "Btree": "c2198acc77776c79895429177e90f30bd09b62df",
   "P": "79bbc262734cbb707e2f31126da6bdb22b75acfc",
   "Ptree": "6e52d5546ff8b5210031e0ec82525c88b8b8a479",
   "S": "b29eff8bd55ba106e87d89be2104b67713956b32",
   "Stree": "4b825dc642cb6eb9a060e54bf8d69288fbee4904"
  }
 },
 "d": {
  "commitP_treeS": {
   "args": "git merge-tree --write-tree -z --name-only --merge-base=7a720d25cb75561a7d3a2ed735fae84e7751b7eb 48471681947af30d713f728d2665f5e0c8f7c1a7 bb35a1df1a1ed21c2851ea98976f828191446641",
   "exit": 1,
   "stdout": "b'0b82ca50f1af6572bebcfb9f31fde7117a61e6a3\\x00a.txt\\x00b.txt\\x00\\x001\\x00a.txt\\x00Auto-merging\\x00Auto-merging a.txt\\n\\x001\\x00a.txt\\x00CONFLICT (contents)\\x00CONFLICT (content): Merge conflict in a.txt\\n\\x001\\x00b.txt\\x00Auto-merging\\x00Auto-merging b.txt\\n\\x001\\x00b.txt\\x00CONFLICT (contents)\\x00CONFLICT (content): Merge conflict in b.txt\\n\\x00'",
   "stderr": ""
  },
  "treeP_treeS": {
   "args": "git merge-tree --write-tree -z --name-only --merge-base=7a720d25cb75561a7d3a2ed735fae84e7751b7eb 64872ceaa1e6e1f14e0dfac55b6b72b5a6a8d855 bb35a1df1a1ed21c2851ea98976f828191446641",
   "exit": 1,
   "stdout": "b'ad6afeedb8bf2740fe81ee9be8d71f23e6c5f168\\x00a.txt\\x00b.txt\\x00\\x001\\x00a.txt\\x00Auto-merging\\x00Auto-merging a.txt\\n\\x001\\x00a.txt\\x00CONFLICT (contents)\\x00CONFLICT (content): Merge conflict in a.txt\\n\\x001\\x00b.txt\\x00Auto-merging\\x00Auto-merging b.txt\\n\\x001\\x00b.txt\\x00CONFLICT (contents)\\x00CONFLICT (content): Merge conflict in b.txt\\n\\x00'",
   "stderr": ""
  },
  "endOfOptions_treeP_treeS": {
   "args": "git merge-tree --write-tree -z --name-only --merge-base=7a720d25cb75561a7d3a2ed735fae84e7751b7eb --end-of-options 64872ceaa1e6e1f14e0dfac55b6b72b5a6a8d855 bb35a1df1a1ed21c2851ea98976f828191446641",
   "exit": 1,
   "stdout": "b'ad6afeedb8bf2740fe81ee9be8d71f23e6c5f168\\x00a.txt\\x00b.txt\\x00\\x001\\x00a.txt\\x00Auto-merging\\x00Auto-merging a.txt\\n\\x001\\x00a.txt\\x00CONFLICT (contents)\\x00CONFLICT (content): Merge conflict in a.txt\\n\\x001\\x00b.txt\\x00Auto-merging\\x00Auto-merging b.txt\\n\\x001\\x00b.txt\\x00CONFLICT (contents)\\x00CONFLICT (content): Merge conflict in b.txt\\n\\x00'",
   "stderr": ""
  },
  "ids": {
   "B": "9066568e663c7b5b95c6e28f1056b77fc1d375bf",
   "Btree": "7a720d25cb75561a7d3a2ed735fae84e7751b7eb",
   "P": "48471681947af30d713f728d2665f5e0c8f7c1a7",
   "Ptree": "64872ceaa1e6e1f14e0dfac55b6b72b5a6a8d855",
   "S": "7ab11adcba27b56ff69d268ce1bec83db10913c1",
   "Stree": "bb35a1df1a1ed21c2851ea98976f828191446641"
  }
 }
}
```

Findings:
- Tree arguments work for all four cases; clean (a) exits 0, conflicts exit 1; `--end-of-options` before `<P> <S>` is accepted and changes nothing.
- **A conflicted result tree depends on whether commits or trees are passed:** conflict markers are labelled with the argument's object ID, so (b) gives `35c0fc0…` with commit P and `8189dda…` with tree P; (d) likewise. Clean results are identical. Labels seen in (b)'s `a.txt`: commit P → `<<<<<<< 0a3fac55…` (the commit ID); tree P → `<<<<<<< 6e52d554…` (the tree ID); S tree → `>>>>>>> 94997acf…`; S commit → `>>>>>>> e760c02b…`.
- (c) reports `CONFLICT (modify/delete): a.txt deleted in 4b825dc… and modified in 6e52d55….  Version 6e52d55… of a.txt left in tree.` and leaves P's version in the result.
- Without `--name-only`, (b) lists the three conflict stages: `100644 8a1218a… 1\ta.txt`, `… 2\ta.txt`, `… 3\ta.txt`.

## M2. All three as commits; tree merge-base with commit P and S
```text
{
 "a": {
  "allCommits": {
   "args": "git merge-tree --write-tree -z --name-only --merge-base=8b428abedef09b638bcc090a1816f6dcb56ba44e 97560258fc3e7556565089f8cc2c876cd5e93c43 546888bccabf1faaa324ff223626f4995ecaae81",
   "exit": 0,
   "stdout": "b'cb7c597a115a9e5750df399bb8249f885167af0e\\x00'",
   "stderr": ""
  },
  "treeBase_commitPS": {
   "args": "git merge-tree --write-tree -z --name-only --merge-base=c2198acc77776c79895429177e90f30bd09b62df 97560258fc3e7556565089f8cc2c876cd5e93c43 546888bccabf1faaa324ff223626f4995ecaae81",
   "exit": 0,
   "stdout": "b'cb7c597a115a9e5750df399bb8249f885167af0e\\x00'",
   "stderr": ""
  }
 },
 "b": {
  "allCommits": {
   "args": "git merge-tree --write-tree -z --name-only --merge-base=4f4d99998f9d9a512e453d8b8742d64fb8564c24 0a3fac55d50d966620b95a1e1737e865eb4da5ff e760c02b8849ad9e7d667daa1ac6949cd8d5ae55",
   "exit": 1,
   "stdout": "b'0ac3cd30bffcb04a530f04ff9561d8ba945e8fbd\\x00a.txt\\x00\\x001\\x00a.txt\\x00Auto-merging\\x00Auto-merging a.txt\\n\\x001\\x00a.txt\\x00CONFLICT (contents)\\x00CONFLICT (content): Merge conflict in a.txt\\n\\x00'",
   "stderr": ""
  },
  "treeBase_commitPS": {
   "args": "git merge-tree --write-tree -z --name-only --merge-base=c2198acc77776c79895429177e90f30bd09b62df 0a3fac55d50d966620b95a1e1737e865eb4da5ff e760c02b8849ad9e7d667daa1ac6949cd8d5ae55",
   "exit": 1,
   "stdout": "b'0ac3cd30bffcb04a530f04ff9561d8ba945e8fbd\\x00a.txt\\x00\\x001\\x00a.txt\\x00Auto-merging\\x00Auto-merging a.txt\\n\\x001\\x00a.txt\\x00CONFLICT (contents)\\x00CONFLICT (content): Merge conflict in a.txt\\n\\x00'",
   "stderr": ""
  }
 },
 "c": {
  "allCommits": {
   "args": "git merge-tree --write-tree -z --name-only --merge-base=ed9077acd4e73b96361a91ae7c27ae653c14049e 79bbc262734cbb707e2f31126da6bdb22b75acfc b29eff8bd55ba106e87d89be2104b67713956b32",
   "exit": 1,
   "stdout": "b'6e52d5546ff8b5210031e0ec82525c88b8b8a479\\x00a.txt\\x00\\x001\\x00a.txt\\x00CONFLICT (modify/delete)\\x00CONFLICT (modify/delete): a.txt deleted in b29eff8bd55ba106e87d89be2104b67713956b32 and modified in 79bbc262734cbb707e2f31126da6bdb22b75acfc.  Version 79bbc262734cbb707e2f31126da6bdb22b75acfc of a.txt left in tree.\\n\\x00'",
   "stderr": ""
  },
  "treeBase_commitPS": {
   "args": "git merge-tree --write-tree -z --name-only --merge-base=c2198acc77776c79895429177e90f30bd09b62df 79bbc262734cbb707e2f31126da6bdb22b75acfc b29eff8bd55ba106e87d89be2104b67713956b32",
   "exit": 1,
   "stdout": "b'6e52d5546ff8b5210031e0ec82525c88b8b8a479\\x00a.txt\\x00\\x001\\x00a.txt\\x00CONFLICT (modify/delete)\\x00CONFLICT (modify/delete): a.txt deleted in b29eff8bd55ba106e87d89be2104b67713956b32 and modified in 79bbc262734cbb707e2f31126da6bdb22b75acfc.  Version 79bbc262734cbb707e2f31126da6bdb22b75acfc of a.txt left in tree.\\n\\x00'",
   "stderr": ""
  }
 },
 "d": {
  "allCommits": {
   "args": "git merge-tree --write-tree -z --name-only --merge-base=9066568e663c7b5b95c6e28f1056b77fc1d375bf 48471681947af30d713f728d2665f5e0c8f7c1a7 7ab11adcba27b56ff69d268ce1bec83db10913c1",
   "exit": 1,
   "stdout": "b'dd8d95d4dedc702077d5c34792d4ce6cc6bee666\\x00a.txt\\x00b.txt\\x00\\x001\\x00a.txt\\x00Auto-merging\\x00Auto-merging a.txt\\n\\x001\\x00a.txt\\x00CONFLICT (contents)\\x00CONFLICT (content): Merge conflict in a.txt\\n\\x001\\x00b.txt\\x00Auto-merging\\x00Auto-merging b.txt\\n\\x001\\x00b.txt\\x00CONFLICT (contents)\\x00CONFLICT (content): Merge conflict in b.txt\\n\\x00'",
   "stderr": ""
  },
  "treeBase_commitPS": {
   "args": "git merge-tree --write-tree -z --name-only --merge-base=7a720d25cb75561a7d3a2ed735fae84e7751b7eb 48471681947af30d713f728d2665f5e0c8f7c1a7 7ab11adcba27b56ff69d268ce1bec83db10913c1",
   "exit": 1,
   "stdout": "b'dd8d95d4dedc702077d5c34792d4ce6cc6bee666\\x00a.txt\\x00b.txt\\x00\\x001\\x00a.txt\\x00Auto-merging\\x00Auto-merging a.txt\\n\\x001\\x00a.txt\\x00CONFLICT (contents)\\x00CONFLICT (content): Merge conflict in a.txt\\n\\x001\\x00b.txt\\x00Auto-merging\\x00Auto-merging b.txt\\n\\x001\\x00b.txt\\x00CONFLICT (contents)\\x00CONFLICT (content): Merge conflict in b.txt\\n\\x00'",
   "stderr": ""
  }
 }
}
```

Findings: both forms work and give the same result tree in every case (a: `cb7c597…`, b: `0ac3cd3…`, c: `6e52d55…`, d: `dd8d95d…`); with commits, (b) and (d) differ from M1's tree-argument results only through the marker labels.

## M3. Versions
- `git merge-tree -h` (2.55.0.windows.3): `--[no-]merge-base <tree-ish>  specify a merge-base for the merge`; usage `git merge-tree [--write-tree] [<options>] <branch1> <branch2>`.
- Installed manual (`C:/Program Files/Git/mingw64/share/doc/git-doc/git-merge-tree.html`): "--merge-base=<tree-ish> … Instead of finding the merge-bases for <branch1> and <branch2>, specify a merge-base for the merge. … With this option, since the merge-base is provided directly, <branch1> and <branch2> do not need to specify commits; trees are enough."
- Git's release notes (raw files from github.com/git/git, `Documentation/RelNotes/<v>.adoc`):
  - 2.38.0: "\"git merge-tree\" learned a new mode where it takes two commits and computes a tree that would result in the merge commit, if the histories leading to these two commits were to be merged."
  - **2.40.0: "\"merge-tree\" learns a new `--merge-base` option."**
  - 2.41.0: "\"git merge-tree\" reads the basic configuration, which can be used by git forges to disable replace-refs feature."
  - 2.43.0: "\"git merge-tree\" learned to take strategy backend specific options via the \"-X\" option, like \"git merge\" does." and "\"git merge-tree\" used to segfault when the \"--attr-source\" option is used, which has been corrected."
  - **2.45.0: "\"git merge-tree\" has learned that the three trees involved in the 3-way merge only need to be trees, not necessarily commits."**
  So `--merge-base` needs Git 2.40 and tree arguments need Git 2.45; B23's floor is 2.42.

## M4. Merge drivers and attributes (conflicting edit to `a.txt`; `.gitattributes` committed on all three sides)
Environments: (i) in the repository's work tree with its own config; (ii) Core's capture style: `GIT_DIR` = a private directory holding only `config` (`[core] repositoryformatversion = 0, bare = true`) and `HEAD` (`ref: refs/heads/main`, no refs), `GIT_OBJECT_DIRECTORY` = the repository's objects, `GIT_CONFIG_NOSYSTEM=1`, `GIT_CONFIG_GLOBAL` = an empty file, every other `GIT_*` variable removed, cwd outside the repository; (iii) as (ii) plus `git --attr-source=<base tree>` (an extra the PM added).
```text
{
 "evil": {
  "i_worktree": {
   "args": "git merge-tree --write-tree -z --name-only --merge-base=c716710f26f5ed1cccac201ecc05da1166976231 947891d3e5f8fffe8afbe4e6faa52b0e1bbb74cd 7557653a6a28e5a1598f2d1117a35bfc55827302",
   "exit": 0,
   "stdout": "b'947891d3e5f8fffe8afbe4e6faa52b0e1bbb74cd\\x00'",
   "stderr": "",
   "marker": true
  },
  "ii_private_env": {
   "args": "git merge-tree --write-tree -z --name-only --merge-base=c716710f26f5ed1cccac201ecc05da1166976231 947891d3e5f8fffe8afbe4e6faa52b0e1bbb74cd 7557653a6a28e5a1598f2d1117a35bfc55827302",
   "exit": 1,
   "stdout": "b'91f83fb1eff28ae704e6fe0824cb84d571dde856\\x00a.txt\\x00\\x001\\x00a.txt\\x00Auto-merging\\x00Auto-merging a.txt\\n\\x001\\x00a.txt\\x00CONFLICT (contents)\\x00CONFLICT (content): Merge conflict in a.txt\\n\\x00'",
   "stderr": "",
   "marker": false
  },
  "iii_private_env_attr_source_base": {
   "args": "git --attr-source=c716710f26f5ed1cccac201ecc05da1166976231 merge-tree --write-tree -z --name-only --merge-base=c716710f26f5ed1cccac201ecc05da1166976231 947891d3e5f8fffe8afbe4e6faa52b0e1bbb74cd 7557653a6a28e5a1598f2d1117a35bfc55827302",
   "exit": 1,
   "stdout": "b'91f83fb1eff28ae704e6fe0824cb84d571dde856\\x00a.txt\\x00\\x001\\x00a.txt\\x00Auto-merging\\x00Auto-merging a.txt\\n\\x001\\x00a.txt\\x00CONFLICT (contents)\\x00CONFLICT (content): Merge conflict in a.txt\\n\\x00'",
   "stderr": "",
   "marker": false
  },
  "ids": {
   "Btree": "c716710f26f5ed1cccac201ecc05da1166976231",
   "Ptree": "947891d3e5f8fffe8afbe4e6faa52b0e1bbb74cd",
   "Stree": "7557653a6a28e5a1598f2d1117a35bfc55827302",
   "driverConfig": "touch '/c/Users/DARIUS~1.JON/AppData/Local/Temp/t06probe-xngwz6ng/evil-marker'; exit 0",
   "privateConfig": "[core] repositoryformatversion = 0, bare = true"
  }
 },
 "union": {
  "i_worktree": {
   "args": "git merge-tree --write-tree -z --name-only --merge-base=d4f0383d238a31456f8d14e0c8c3b35dd813dbd7 2787f9d83fa4b17d975c29ab58c6bc7205a6e250 781ca68d35785b473688a05244b1e7eeaccc6efd",
   "exit": 0,
   "stdout": "b'3c8b3ddc41e13a84390eaca73f05c8736803cdba\\x00'",
   "stderr": "",
   "marker": false
  },
  "ii_private_env": {
   "args": "git merge-tree --write-tree -z --name-only --merge-base=d4f0383d238a31456f8d14e0c8c3b35dd813dbd7 2787f9d83fa4b17d975c29ab58c6bc7205a6e250 781ca68d35785b473688a05244b1e7eeaccc6efd",
   "exit": 1,
   "stdout": "b'a9cd3abc2ae1a3be1432400bf586ea3e80399730\\x00a.txt\\x00\\x001\\x00a.txt\\x00Auto-merging\\x00Auto-merging a.txt\\n\\x001\\x00a.txt\\x00CONFLICT (contents)\\x00CONFLICT (content): Merge conflict in a.txt\\n\\x00'",
   "stderr": "",
   "marker": false
  },
  "iii_private_env_attr_source_base": {
   "args": "git --attr-source=d4f0383d238a31456f8d14e0c8c3b35dd813dbd7 merge-tree --write-tree -z --name-only --merge-base=d4f0383d238a31456f8d14e0c8c3b35dd813dbd7 2787f9d83fa4b17d975c29ab58c6bc7205a6e250 781ca68d35785b473688a05244b1e7eeaccc6efd",
   "exit": 0,
   "stdout": "b'3c8b3ddc41e13a84390eaca73f05c8736803cdba\\x00'",
   "stderr": "",
   "marker": false
  },
  "ids": {
   "Btree": "d4f0383d238a31456f8d14e0c8c3b35dd813dbd7",
   "Ptree": "2787f9d83fa4b17d975c29ab58c6bc7205a6e250",
   "Stree": "781ca68d35785b473688a05244b1e7eeaccc6efd",
   "driverConfig": null,
   "privateConfig": "[core] repositoryformatversion = 0, bare = true"
  }
 }
}
```

Findings:
- **(i) runs the repository's configured merge driver:** with `*.txt merge=evil` and `merge.evil.driver = touch '<marker>'; exit 0` in `.git/config`, merge-tree exits 0 (clean) and the marker file appears. A merge in the repository's own environment executes a command from its config.
- (ii) runs no driver (the private config defines none) and reports the conflict (exit 1); no marker.
- **(ii) reads no `.gitattributes`:** with `*.txt merge=union`, (i) merges clean (`3c8b3dd…`) but (ii) conflicts (`a9cd3ab…`): in the bare private directory with no HEAD commit, the trees' attributes are not consulted.
- (iii) `--attr-source=<base tree>` makes (ii) honour the base tree's attributes: `union` merges clean with (i)'s result `3c8b3dd…`; `evil` still conflicts and runs nothing, because the private config defines no driver.

## M5. Where (ii) writes objects
```text
{
 "evil_ii_conflict": {
  "resultTree": "91f83fb1eff28ae704e6fe0824cb84d571dde856",
  "catFileT_in_repo": [
   0,
   "tree",
   ""
  ],
  "lsTree": "100644 blob 74362bf8589d63426fc84935c1e4b97a087badc8\t.gitattributes\n100644 blob b833fadb719b19788f07d176e44676f02f3e1ca9\ta.txt",
  "stderr_of_merge": ""
 },
 "union_iii_clean": {
  "resultTree": "3c8b3ddc41e13a84390eaca73f05c8736803cdba",
  "catFileT_in_repo": [
   0,
   "tree",
   ""
  ],
  "lsTree": "100644 blob 689a08adf15e7b45f6a2b3a62f00691075daff0e\t.gitattributes\n100644 blob 20e9ec3dedba69c7d0d7a9057f716e28df5c3236\ta.txt",
  "stderr_of_merge": ""
 }
}
```
- The result trees (and their blobs) are readable from the repository afterwards (`cat-file -t` → `tree`): (ii) writes them to `GIT_OBJECT_DIRECTORY`. The private directory still holds only `config` and `HEAD`. No error about HEAD, the index or refs (stderr empty).

## M6. `core.autocrlf=true` + `merge.renormalize=true` in the repository's config, LF blobs, case (a)
```text
{
 "trees_same_as_case_a": true,
 "i_with_autocrlf_renormalize": {
  "args": "git merge-tree --write-tree -z --name-only --merge-base=c2198acc77776c79895429177e90f30bd09b62df 9bd5f3cf8e141ac6ef99c097da5ce8745cb784ac 288b54bfab8be6369404c9f65bb3953416c26e0b",
  "exit": 0,
  "stdout": "b'cb7c597a115a9e5750df399bb8249f885167af0e\\x00'",
  "stderr": "",
  "blob": "b'1p\\n2\\n3\\n4\\n5s\\n'"
 },
 "ii_private_env": {
  "args": "git merge-tree --write-tree -z --name-only --merge-base=c2198acc77776c79895429177e90f30bd09b62df 9bd5f3cf8e141ac6ef99c097da5ce8745cb784ac 288b54bfab8be6369404c9f65bb3953416c26e0b",
  "exit": 0,
  "stdout": "b'cb7c597a115a9e5750df399bb8249f885167af0e\\x00'",
  "stderr": "",
  "blob": "b'1p\\n2\\n3\\n4\\n5s\\n'"
 },
 "default_case_a_result": "cb7c597a115a9e5750df399bb8249f885167af0e"
}
```
- No difference: (i) with both settings, (ii) without any config, and case (a) under the system config alone all give `cb7c597…`, whose `a.txt` is `1p\n2\n3\n4\n5s\n` (LF). Note: "default" here already includes the system `core.autocrlf=true`; (ii) is the no-config baseline.

## M7. `commit-tree` determinism
```text
{
 "cmd": "git commit-tree cb7c597a115a9e5750df399bb8249f885167af0e -p 97560258fc3e7556565089f8cc2c876cd5e93c43 -m msg",
 "env": {
  "GIT_AUTHOR_NAME": "Core",
  "GIT_AUTHOR_EMAIL": "core@example.invalid",
  "GIT_AUTHOR_DATE": "1760000000 +0000",
  "GIT_COMMITTER_NAME": "Core",
  "GIT_COMMITTER_EMAIL": "core@example.invalid",
  "GIT_COMMITTER_DATE": "1760000000 +0000"
 },
 "runs": [
  [
   0,
   "c2f27db1f12857b0336920f3861e542548ff68db",
   ""
  ],
  [
   0,
   "c2f27db1f12857b0336920f3861e542548ff68db",
   ""
  ]
 ],
 "same": true,
 "object": "tree cb7c597a115a9e5750df399bb8249f885167af0e\nparent 97560258fc3e7556565089f8cc2c876cd5e93c43\nauthor Core <core@example.invalid> 1760000000 +0000\ncommitter Core <core@example.invalid> 1760000000 +0000\n\nmsg\n"
}
```
- Two runs with fixed author and committer names, emails and dates give the same commit ID.

## M8. `core.ignorecase=true`: one side adds `Docs/x.txt`, the other `docs/y.txt`
```text
{
 "P_tree": "Docs/x.txt\nbase.txt",
 "S_tree": "base.txt\ndocs/y.txt",
 "merge": {
  "args": "git merge-tree --write-tree -z --name-only --merge-base=4b36dfd79db36d8c59d1fb032de66b57f0457b65 e80a83c5acb1965a6b242057b158a824c6abfa23 67a1fbc76be85e4dfc29e80ffb4d7892ed7c9532",
  "exit": 0,
  "stdout": "b'd432f37242f30b71d6f9184c4029727fd0089105\\x00'",
  "stderr": ""
 },
 "result_ls_tree_z": "b'100644 blob 587be6b4c3f93f93c489c0111bba5596147a26cb\\tDocs/x.txt\\x00100644 blob df967b96a579e45a18b8251732d16804b2e56a55\\tbase.txt\\x00100644 blob 975fbec8256d3e8a3797e7a3611380f27c49f4ac\\tdocs/y.txt\\x00'",
 "merge_private_env": {
  "args": "git merge-tree --write-tree -z --name-only --merge-base=4b36dfd79db36d8c59d1fb032de66b57f0457b65 e80a83c5acb1965a6b242057b158a824c6abfa23 67a1fbc76be85e4dfc29e80ffb4d7892ed7c9532",
  "exit": 0,
  "stdout": "b'd432f37242f30b71d6f9184c4029727fd0089105\\x00'",
  "stderr": ""
 }
}
```
- **merge-tree merges clean (exit 0) and its result tree holds both `Docs/x.txt` and `docs/y.txt`**, a case-only directory collision that cannot be checked out on this NTFS volume; the same in (ii). merge-tree does not refuse it.

## M9. `--no-messages` (cases b and d rebuilt in fresh repositories; B, P and S as trees, and P as a commit)
```text
{
 "b": {
  "treeP_treeS": {
   "args": "git merge-tree --write-tree -z --name-only --no-messages --merge-base=c2198acc77776c79895429177e90f30bd09b62df 6e52d5546ff8b5210031e0ec82525c88b8b8a479 94997acf115ee3522bc2a52fa475bcd32f8dc880",
   "exit": 1,
   "stdout": "b'8189dda5680d3e2375f07a7f055dfff728a943df\\x00a.txt\\x00'",
   "stderr": ""
  },
  "commitP_treeS": {
   "args": "git merge-tree --write-tree -z --name-only --no-messages --merge-base=c2198acc77776c79895429177e90f30bd09b62df 4a3266122519f28d86cf61ac6ce8d52e3c27022a 94997acf115ee3522bc2a52fa475bcd32f8dc880",
   "exit": 1,
   "stdout": "b'5049e895b6b9585a8c21eb97d4a554acd61b034d\\x00a.txt\\x00'",
   "stderr": ""
  }
 },
 "d": {
  "treeP_treeS": {
   "args": "git merge-tree --write-tree -z --name-only --no-messages --merge-base=7a720d25cb75561a7d3a2ed735fae84e7751b7eb 64872ceaa1e6e1f14e0dfac55b6b72b5a6a8d855 bb35a1df1a1ed21c2851ea98976f828191446641",
   "exit": 1,
   "stdout": "b'ad6afeedb8bf2740fe81ee9be8d71f23e6c5f168\\x00a.txt\\x00b.txt\\x00'",
   "stderr": ""
  },
  "commitP_treeS": {
   "args": "git merge-tree --write-tree -z --name-only --no-messages --merge-base=7a720d25cb75561a7d3a2ed735fae84e7751b7eb e6954d82fa552a45564249037db9fc7b54a4d4ff bb35a1df1a1ed21c2851ea98976f828191446641",
   "exit": 1,
   "stdout": "b'd973480428d48e73bbc3beafa0cae6ec44b2a9a2\\x00a.txt\\x00b.txt\\x00'",
   "stderr": ""
  }
 }
}
```
- With `--no-messages` the output is the result tree, then the conflicted paths, each NUL-terminated, and nothing else; exit 1 for conflicts.
- With tree arguments the conflicted result trees equal M1's exactly (`8189dda…` for b, `ad6afee…` for d), although the repositories were rebuilt: trees are content-addressed, so the labels are reproducible. With P as a commit they differ from M1's (`5049e89…`, `d973480…`), because the rebuilt commits have new IDs (new timestamps) and the conflict labels carry the commit ID.
- Version: the manual at tag v2.38.0 (`Documentation/git-merge-tree.txt`) documents `--[no-]messages::` ("Write any informational messages such as \"Auto-merging <path>\" …"); the manual at v2.37.0 has no `messages` line. So `--messages`/`--no-messages` arrived with the `--write-tree` mode in Git 2.38.0.

## M10. `commit-tree` with `--end-of-options` (AdvisorT06's request 1, for S1)
Throwaway SHA-1 repository, one commit; `GIT_AUTHOR_*` and `GIT_COMMITTER_*` names, emails and dates fixed (`1760000000 +0000`); `git version 2.55.0.windows.3`.
- `git commit-tree --end-of-options <tree> -p <commit> -m msg` → exit 128, stderr `fatal: must give exactly one tree`.
- `git commit-tree -p <commit> -m msg --end-of-options <tree>` → exit 0, `a2d1cbe4cd82f94aaa64f8f70bf1c29de881964b`; the same ID again on a second run.
- `git commit-tree <tree> -p <commit> -m msg` (no marker) → exit 0, `a2d1cbe4cd82f94aaa64f8f70bf1c29de881964b`, the same commit.

So the marker goes after every option and directly before the tree: `commit-tree -p <parent> -m <msg> --end-of-options <tree>`.
