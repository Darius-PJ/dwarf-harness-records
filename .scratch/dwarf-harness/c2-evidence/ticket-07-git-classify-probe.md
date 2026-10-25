# Git classification probe for CoderT07S1 (question 3), run by the PM

Disposable repository under %TEMP%; GIT_CONFIG_NOSYSTEM=1, empty global config, `core.autocrlf=false`. `base.txt` tracked and committed with `.gitignore` = `base.txt\n` (added with `-f`); then the file was replaced by the directory `base.txt/child`. The private index is `GIT_INDEX_FILE=<td>/private.index`. Outputs are Python byte reprs, so NUL shows as `\x00`.

```
$ git init -q -b main   [init]
exit=0
stdout=b''
stderr=b''

$ git config core.autocrlf false   [cfg]
exit=0
stdout=b''
stderr=b''

$ git add -f base.txt .gitignore   [add]
exit=0
stdout=b''
stderr=b''

$ git commit -q -m baseline   [commit]
exit=0
stdout=b''
stderr=b''

$ git read-tree HEAD   [private: read-tree baseline]
exit=0
stdout=b''
stderr=b''

$ git ls-files -z -o --exclude-standard   [A1 private baseline: -o --exclude-standard]
exit=0
stdout=b''
stderr=b''

$ git ls-files -z -o -i --exclude-standard --directory   [A2 private baseline: -o -i --exclude-standard --directory]
exit=0
stdout=b''
stderr=b''

$ git ls-files -z -o -i --exclude-standard   [A3 private baseline: -o -i --exclude-standard (no --directory)]
exit=0
stdout=b'base.txt/child\x00'
stderr=b''

$ git update-index --force-remove base.txt   [private: force-remove base.txt]
exit=0
stdout=b''
stderr=b''

$ git ls-files -z -o --exclude-standard   [B1 after force-remove: -o --exclude-standard]
exit=0
stdout=b''
stderr=b''

$ git ls-files -z -o -i --exclude-standard --directory   [B2 after force-remove: -o -i --exclude-standard --directory]
exit=0
stdout=b'base.txt/\x00'
stderr=b''

$ git ls-files -z -o -i --exclude-standard   [B3 after force-remove: -o -i --exclude-standard (no --directory)]
exit=0
stdout=b'base.txt/child\x00'
stderr=b''

$ git ls-files -z -o -i --exclude-standard --directory   [C real index (untouched): -o -i --exclude-standard --directory]
exit=0
stdout=b''
stderr=b''

$ git version   [version]
exit=0
stdout=b'git version 2.55.0.windows.3\n'
stderr=b''
```
