"""Verify a rewritten history before publication.

Reads the same config file as rewrite.py and checks the public repository
(cfg["dst"]) against the original (cfg["src"] at cfg["src_ref"]):

  1. git fsck passes;
  2. every commit carries only the configured identity, and dates match;
  3. no commit contains a removed path;
  4. no blob or message holds a secret pattern or a personal identifier;
  5. every machine, program, quote or budget pattern left in a text file or
     message is on a line someone reviewed (kept or written by the maps);
  6. files outside Markdown and Go are byte-identical at the tip, and the
     changed Go files are listed;
  7. no Markdown file or message still cites an old commit hash.

Usage: python verify.py config.json   (writes residuals.txt beside the report)
"""
import collections
import json
import os
import re
import subprocess
import sys


def git(repo, *args, data=None):
    p = subprocess.run(["git", *args], cwd=repo, input=data, capture_output=True)
    if p.returncode != 0:
        sys.exit(f"git {' '.join(args)}: {p.stderr.decode('utf-8', 'replace')}")
    return p.stdout


def blobs_with_paths(repo, ref):
    paths = collections.defaultdict(set)
    for line in git(repo, "rev-list", "--objects", ref).decode("utf-8").splitlines():
        parts = line.split(" ", 1)
        if len(parts) == 2:
            paths[parts[0]].add(parts[1])
    out = git(repo, "cat-file", "--batch", data=("\n".join(paths) + "\n").encode())
    blobs, i = {}, 0
    while i < len(out):
        nl = out.index(b"\n", i)
        sha, typ, size = out[i:nl].split()
        size = int(size)
        if typ == b"blob":
            blobs[sha.decode()] = out[nl + 1:nl + 1 + size]
        i = nl + 1 + size + 1
    return blobs, {s: p for s, p in paths.items() if s in blobs}


SECRETS = re.compile(rb"-----BEGIN [A-Z ]*PRIVATE KEY-----|AKIA[0-9A-Z]{16}|gh[pousr]_[A-Za-z0-9]{36}"
                     rb"|github_pat_[A-Za-z0-9_]{20,}|sk-ant-[A-Za-z0-9_-]{20,}|sk-proj-[A-Za-z0-9_-]{20,}"
                     rb"|xox[baprs]-[A-Za-z0-9-]{10,}|AIza[0-9A-Za-z_-]{35}")
PERSONAL = [b"darius.jones", b"pierce", b"3dpjones", b"gmail", b"fbl8fb3", b"slaythespire", b"slay the spire"]
EMAIL = re.compile(r"[A-Za-z0-9._%+-]{1,64}@[A-Za-z0-9-]{1,63}(?:\.[A-Za-z0-9-]{1,63})*\.[A-Za-z]{2,}")
REVIEW = {
    "machine": r"(?i)10610U|19045|Windows 10 Pro|10\.0\.190|GiB RAM|GB RAM|cores?, \d+ threads|owner's machine"
               r"|his machine|this machine|the laptop|a laptop|laptop's|power plan|throttl|thermal",
    "antivirus": r"(?i)defender|git\.exe[^.]{0,40}exclu",
    "administrator": r"(?i)(owner|his|this machine|laptop)[^.]{0,60}(administrator|elevat|UAC)"
                     r"|(administrator|elevat|UAC)[^.]{0,60}(owner|his account|laptop)",
    "program": r"(?i)\bslay|steam|discord|spotify|youtube|netflix|\bplaying\b|\bplayed\b|\bgaming\b",
    "quote": r"(?i)(question tool|in chat|\(chat\b|owner'?s words|his words|\b(owner|he)\b,? (then |later |also |first )?"
             r"(selected|chose|answered|said|wrote|asked|replied|typed|picked|added|ordered|instructed|confirmed|approved)\b"
             r"[^\"“]{0,80}[\"“]|\bowner\b[^\"“]{0,20}: ?[\"“])",
    "budget": r"(?i)actions budget|\$0 paid|included minutes|budget (has been|was) reached",
}
REVIEW = {k: re.compile(v) for k, v in REVIEW.items()}
MD_QUOTE = re.compile(r"(?i)\b(owner|he|his|him)\b.*[\"“][^\"”]{12,}[\"”]|[\"“][^\"”]{12,}[\"”].*\b(owner|he|his|him)\b")
TOKEN = re.compile(r"(?<![0-9A-Za-z_])[0-9a-f]{7,40}(?![0-9A-Za-z_])")


def main():
    cfg = json.load(open(sys.argv[1], encoding="utf-8"))
    src, ref, dst = cfg["src"], cfg["src_ref"], cfg["dst"]
    remove = re.compile(cfg["remove_regex"])
    ident = f"{cfg['name']} <{cfg['email']}>"
    ok, notes = True, []

    def fail(msg):
        nonlocal ok
        ok = False
        notes.append("FAIL " + msg)

    fsck = subprocess.run(["git", "fsck", "--full", "--strict"], cwd=dst, capture_output=True, text=True)
    if fsck.returncode != 0 or fsck.stderr.strip():
        fail("git fsck: " + fsck.stderr.strip()[:300])

    refs = git(dst, "for-each-ref", "--format=%(refname)").decode().split()
    if refs != ["refs/heads/main"]:
        fail(f"refs other than main: {refs}")
    new_log = git(dst, "log", "--format=%an <%ae>|%cn <%ce>|%ad|%cd", "--date=raw", "main").decode().splitlines()
    old_log = git(src, "log", "--format=%ad|%cd", "--date=raw", ref).decode().splitlines()
    ids = collections.Counter(tuple(l.split("|")[:2]) for l in new_log)
    if set(ids) != {(ident, ident)}:
        fail(f"identities: {dict(ids)}")
    base = new_log[len(new_log) - len(old_log):]
    if ["|".join(l.split("|")[2:]) for l in base] != old_log:
        fail("dates of the rewritten commits differ from the originals")
    notes.append(f"commits: {len(new_log)} ({len(old_log)} rewritten, {len(new_log) - len(old_log)} added); identity {ident}")

    names = set(git(dst, "log", "--format=", "--name-only", "main").decode("utf-8").split("\n")) - {""}
    bad = sorted(p for p in names if remove.search(p))
    if bad:
        fail(f"removed paths present: {bad[:5]}")

    keys = json.load(open(cfg["keys"], encoding="utf-8"))
    by_id = {f"Q{n}": t for n, t in enumerate(keys["Q"], 1)}
    by_id.update({f"H{n}": t for n, t in enumerate(keys["H"], 1)})
    by_id.update({f"M{n}": l for n, (_, l) in enumerate(keys["M"], 1)})
    # Lines are compared with commit hashes masked, because the rewrite
    # translates citations after applying the reviewed replacements.
    def mask(line):
        return TOKEN.sub("#", line)

    reviewed = set()
    for mp in cfg["maps"]:
        for e in json.load(open(mp, encoding="utf-8")):
            if e["action"] == "keep":
                reviewed.add(mask(by_id.get(e.get("id"), e.get("old"))))
            elif e["action"] == "replace":
                reviewed.add(mask(e["new"]))

    blobs, paths = blobs_with_paths(dst, "main")
    messages = [m.split("\x00", 1) for m in git(dst, "log", "--format=%H%x00%B%x01", "main").decode("utf-8").split("\x01") if m.strip()]
    residuals = collections.defaultdict(set)
    for sha, data in blobs.items():
        where = sorted(paths[sha])[0]
        if SECRETS.search(data):
            fail(f"secret pattern in {where}")
        low = data.lower()
        for p in PERSONAL:
            if p in low:
                fail(f"personal identifier {p.decode()!r} in {where}")
        text_file = where.endswith((".md", ".go", ".yml", ".yaml", ".txt", ".ps1", ".sh")) and "/testdata/" not in "/" + where
        if b"@" in data:
            for m in EMAIL.finditer(data.decode("utf-8", "replace")):
                if not m.group(0).endswith("@users.noreply.github.com"):
                    residuals["email-like"].add((where, m.group(0)))
        if not text_file:
            continue
        for line in data.decode("utf-8", "replace").split("\n"):
            if mask(line) in reviewed:
                continue
            for k, rx in REVIEW.items():
                if rx.search(line):
                    residuals[k].add((where, line.strip()))
            if where.endswith(".md") and MD_QUOTE.search(line):
                residuals["quote (broad)"].add((where, line.strip()))
    for h, body in messages:
        if SECRETS.search(body.encode()):
            fail(f"secret pattern in message {h[:7]}")
        for p in PERSONAL:
            if p.decode() in body.lower():
                fail(f"personal identifier {p.decode()!r} in message {h[:7]}")
        for line in body.split("\n"):
            if mask(line) in reviewed:
                continue
            for k, rx in REVIEW.items():
                if rx.search(line):
                    residuals["message " + k].add((h[:7], line.strip()))

    old_tip = dict((l.split("\t")[1], l.split()[2]) for l in git(src, "ls-tree", "-r", ref).decode("utf-8").splitlines())
    new_tip = dict((l.split("\t")[1], l.split()[2]) for l in git(dst, "ls-tree", "-r", "main").decode("utf-8").splitlines())
    changed_other = [p for p in new_tip if p in old_tip and new_tip[p] != old_tip[p] and not p.endswith((".md", ".go"))]
    if changed_other:
        fail(f"files other than Markdown and Go changed at the tip: {changed_other}")
    changed_go = sorted(p for p in new_tip if p.endswith(".go") and p in old_tip and new_tip[p] != old_tip[p])
    added = sorted(set(new_tip) - set(old_tip))
    notes.append(f"tip: {len(new_tip)} files; added {added}; Go files changed: {changed_go or 'none'}")
    golden = [p for p in new_tip if "/testdata/" in "/" + p]
    if any(new_tip[p] != old_tip.get(p) for p in golden):
        fail("a testdata file changed")
    notes.append(f"testdata: {len(golden)} files byte-identical")

    old_commits = git(src, "rev-list", ref).decode().split()
    new_commits = git(dst, "rev-list", "main").decode().split()
    old7, new7 = collections.defaultdict(list), collections.defaultdict(list)
    for c in old_commits:
        old7[c[:7]].append(c)
    for c in new_commits:
        new7[c[:7]].append(c)
    stale = collections.Counter()
    texts = [(sorted(paths[s])[0], d.decode("utf-8", "replace")) for s, d in blobs.items() if any(p.endswith(".md") for p in paths[s])]
    texts += [("message " + h[:7], b) for h, b in messages]
    for where, text in texts:
        for m in TOKEN.finditer(text):
            t = m.group(0)
            if any(c.startswith(t) for c in old7.get(t[:7], ())) and not any(c.startswith(t) for c in new7.get(t[:7], ())):
                stale[(where, t)] += 1
    if stale:
        fail(f"{len(stale)} old commit hashes still cited, e.g. {list(stale)[:3]}")

    out = os.path.join(cfg["out"], "residuals.txt")
    with open(out, "w", encoding="utf-8") as f:
        for k in sorted(residuals):
            f.write(f"== {k}: {len(residuals[k])}\n")
            for where, line in sorted(residuals[k]):
                f.write(f"{where}: {line}\n")
    notes.append("unreviewed pattern hits: " + (", ".join(f"{k} {len(v)}" for k, v in sorted(residuals.items())) or "none") + f" (listed in {out})")
    print("\n".join(notes))
    print("RESULT:", "PASS" if ok else "FAIL")


if __name__ == "__main__":
    main()
