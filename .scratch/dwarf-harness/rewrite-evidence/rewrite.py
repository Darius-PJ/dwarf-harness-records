"""Replay a linear Git history into a fresh repository for publication.

Every commit of the source ref is rebuilt in order. Private paths are left
out, reviewed line replacements are applied to Markdown and Go files, commit
hashes cited in Markdown and in commit messages are translated to the new
hashes, and one author and committer identity replaces the old one. Dates,
time zones and all other bytes are kept.

Usage: python rewrite.py config.json
"""
import collections
import hashlib
import json
import os
import re
import subprocess
import sys
import zlib

TOKEN = re.compile(r"(?<![0-9A-Za-z_])[0-9a-f]{7,40}(?![0-9A-Za-z_])")


def run(args, cwd, data=None, env=None):
    p = subprocess.run(args, cwd=cwd, input=data, capture_output=True, env=env)
    if p.returncode != 0:
        sys.exit(f"{' '.join(args)}: {p.stderr.decode('utf-8', 'replace')}")
    return p.stdout


def batch_read(repo, shas):
    out = run(["git", "cat-file", "--batch"], repo, ("\n".join(shas) + "\n").encode())
    objs, i = {}, 0
    while i < len(out):
        nl = out.index(b"\n", i)
        sha, typ, size = out[i:nl].split()
        size = int(size)
        objs[sha.decode()] = (typ.decode(), out[nl + 1:nl + 1 + size])
        i = nl + 1 + size + 1
    return objs


def path_class(path):
    if "/testdata/" in "/" + path:
        return None
    if path.endswith(".md"):
        return "md"
    if path.endswith(".go"):
        return "go"
    return None


def main():
    cfg = json.load(open(sys.argv[1], encoding="utf-8"))
    src, dst, out = cfg["src"], cfg["dst"], cfg["out"]
    ident = f"{cfg['name']} <{cfg['email']}>".encode()
    remove = re.compile(cfg["remove_regex"])
    if os.path.exists(dst):
        sys.exit(f"{dst} exists; remove it first")
    os.makedirs(out, exist_ok=True)
    run(["git", "init", "-q", "-b", "main", dst], os.path.dirname(dst))
    objects = os.path.join(dst, ".git", "objects")

    def write_object(kind, body):
        store = b"%s %d\0" % (kind, len(body)) + body
        sha = hashlib.sha1(store).hexdigest()
        p = os.path.join(objects, sha[:2], sha[2:])
        if not os.path.exists(p):
            os.makedirs(os.path.dirname(p), exist_ok=True)
            with open(p + ".tmp", "wb") as f:
                f.write(zlib.compress(store))
            os.replace(p + ".tmp", p)
        return sha

    # Reviewed replacements: line text -> new text, or None to delete the line.
    keys = json.load(open(cfg["keys"], encoding="utf-8"))
    id_text = {f"Q{n}": t for n, t in enumerate(keys["Q"], 1)}
    id_text.update({f"H{n}": t for n, t in enumerate(keys["H"], 1)})
    id_text.update({f"M{n}": l for n, (_, l) in enumerate(keys["M"], 1)})
    file_map, msg_map, problems = {}, {}, []
    seen = collections.Counter()
    for mp in cfg["maps"]:
        for e in json.load(open(mp, encoding="utf-8")):
            act = e["action"]
            if act not in ("keep", "replace", "delete"):
                problems.append(f"bad action {e}")
                continue
            if "id" in e:
                seen[e["id"]] += 1
                old = id_text[e["id"]]
                targets = [msg_map] if e["id"].startswith("M") else [file_map]
            else:
                old = e["old"]
                targets = [file_map, msg_map]
            if act == "keep":
                continue
            new = None if act == "delete" else e["new"]
            if new is not None and "\n" in new:
                problems.append(f"multi-line replacement for {e.get('id') or old[:60]!r}")
                continue
            for t in targets:
                if old in t and t[old] != new:
                    problems.append(f"conflicting replacements for {old[:80]!r}")
                t[old] = new
    for k in id_text:
        if seen[k] != 1 and not (seen[k] == 0 and cfg.get("allow_undecided")):
            problems.append(f"{k} decided {seen[k]} times")
    if problems:
        sys.exit("map problems:\n" + "\n".join(problems))

    commits = run(["git", "rev-list", "--reverse", cfg["src_ref"]], src).decode().split()
    raw = batch_read(src, commits)
    by7 = collections.defaultdict(list)
    for c in commits:
        by7[c[:7]].append(c)
    newmap, translations, anomalies = {}, [], []
    hits = collections.Counter()

    def translate(text, where):
        def rep(m):
            t = m.group(0)
            cands = [c for c in by7.get(t[:7], ()) if c.startswith(t)]
            if len(cands) != 1:
                return t
            if cands[0] not in newmap:
                anomalies.append([where, t])
                return t
            new = newmap[cands[0]][:len(t)]
            translations.append([where, t, new])
            return new
        return TOKEN.sub(rep, text)

    def apply_lines(text, mapping, cls):
        out_parts, changed = [], False
        for seg in text.splitlines(keepends=True):
            eol = "\r\n" if seg.endswith("\r\n") else "\n" if seg.endswith("\n") else ""
            core = seg[:len(seg) - len(eol)]
            if core in mapping:
                hits[(cls, core)] += 1
                new = mapping[core]
                changed = True
                if new is not None:
                    out_parts.append(new + eol)
            else:
                out_parts.append(seg)
        return "".join(out_parts), changed

    blob_cache = {}
    all_blobs = set()
    for c in commits:
        for line in run(["git", "ls-tree", "-r", "-z", c], src).split(b"\0"):
            if line:
                all_blobs.add(line.split(b"\t", 1)[0].split()[2].decode())
    blobs = batch_read(src, sorted(all_blobs))

    def new_blob(sha, path):
        cls = path_class(path)
        key = (sha, cls)
        if key in blob_cache:
            return blob_cache[key]
        data = blobs[sha][1]
        if cls is None:
            res = write_object(b"blob", data)
        else:
            text = data.decode("utf-8", "surrogateescape")
            text, _ = apply_lines(text, file_map, cls)
            if cls == "md":
                text = translate(text, path)
            res = write_object(b"blob", text.encode("utf-8", "surrogateescape"))
        blob_cache[key] = res
        return res

    index = os.path.join(out, "rewrite.index")
    env = dict(os.environ, GIT_INDEX_FILE=index)
    report = {"commits": [], "removed_paths": sorted(set())}
    removed_paths = set()
    prev_tree = None
    for c in commits:
        entries = []
        for line in run(["git", "ls-tree", "-r", "-z", c], src).split(b"\0"):
            if not line:
                continue
            meta, path = line.split(b"\t", 1)
            mode, typ, sha = meta.decode().split()
            path = path.decode("utf-8")
            if remove.search(path):
                removed_paths.add(path)
                continue
            if typ != "blob":
                sys.exit(f"unexpected {typ} at {path} in {c}")
            entries.append(f"{mode} blob {new_blob(sha, path)}\t{path}\0")
        if os.path.exists(index):
            os.remove(index)
        run(["git", "update-index", "-z", "--index-info"], dst, "".join(entries).encode("utf-8"), env)
        tree = run(["git", "write-tree"], dst, env=env).decode().strip()

        typ, body = raw[c]
        header, msg = body.split(b"\n\n", 1)
        lines = header.split(b"\n")
        new_header = [b"tree " + tree.encode()]
        for l in lines:
            if l.startswith(b"tree "):
                continue
            if l.startswith(b"parent "):
                new_header.append(b"parent " + newmap[l[7:].decode()].encode())
            elif l.startswith(b"author ") or l.startswith(b"committer "):
                field, rest = l.split(b" ", 1)
                stamp = rest.rsplit(b" ", 2)[-2:]
                new_header.append(field + b" " + ident + b" " + b" ".join(stamp))
            else:
                sys.exit(f"unexpected header {l!r} in {c}")
        text = msg.decode("utf-8", "surrogateescape")
        text, _ = apply_lines(text, msg_map, "msg")
        text = translate(text, "message " + c[:7])
        new_c = write_object(b"commit", b"\n".join(new_header) + b"\n\n" + text.encode("utf-8", "surrogateescape"))
        newmap[c] = new_c
        report["commits"].append({"old": c, "new": new_c, "empty": tree == prev_tree})
        prev_tree = tree

    tip = newmap[commits[-1]]
    run(["git", "update-ref", "refs/heads/main", tip], dst)
    report["removed_paths"] = sorted(removed_paths)
    report["translations"] = translations
    report["anomalies"] = anomalies
    report["unused_replacements"] = sorted(
        old for old in list(file_map) + list(msg_map)
        if not any(hits[(cls, old)] for cls in ("md", "go", "msg")))
    report["replacement_hits"] = {f"{cls}|{old}": n for (cls, old), n in hits.items()}
    with open(os.path.join(out, "report.json"), "w", encoding="utf-8") as f:
        json.dump(report, f, ensure_ascii=False, indent=1)
    with open(os.path.join(out, "commit-map.txt"), "w", encoding="utf-8") as f:
        f.writelines(f"{c} {newmap[c]}\n" for c in commits)
    print(f"{len(commits)} commits; tip {tip}; {len(translations)} citations translated; "
          f"{len(anomalies)} anomalies; {sum(r['empty'] for r in report['commits'])} empty commits; "
          f"{len(report['unused_replacements'])} unused replacements")


if __name__ == "__main__":
    main()
