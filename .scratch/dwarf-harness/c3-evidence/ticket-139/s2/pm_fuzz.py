import argparse, datetime, hashlib, json, os, pathlib, re, subprocess, sys, time
from typing import Any

p = argparse.ArgumentParser()
p.add_argument('--worktree', required=True)
p.add_argument('--sha', required=True)
p.add_argument('--hashes', required=True)
p.add_argument('--evidence', required=True)
a = p.parse_args()
root = pathlib.Path(a.worktree)
expected: dict[str, str] = json.loads(pathlib.Path(a.hashes).read_text(encoding='utf-8'))
if not isinstance(expected, dict) or not expected or any(not isinstance(v, str) or not re.fullmatch('[0-9a-f]{64}', v) for v in expected.values()):
    raise SystemExit('Expected a nonempty path-to-SHA256 object')
head = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=root, text=True).strip()
if head != a.sha:
    raise SystemExit('Refusing a different HEAD: ' + head)

def hashes():
    return {k: hashlib.sha256((root / k).read_bytes()).hexdigest() for k in expected}

if hashes() != expected:
    raise SystemExit('Refusing source hashes different from immutable subject')
stamp = datetime.datetime.now().astimezone().strftime('%Y%m%dT%H%M%S%z')
out = pathlib.Path(a.evidence) / ('pm-fuzz-' + stamp)
out.mkdir(parents=True, exist_ok=False)
env = os.environ.copy()
env.update({'GOTOOLCHAIN': 'local', 'GOFLAGS': '', 'GOROOT': 'C:/Program Files/Go', 'GOOS': 'windows', 'GOARCH': 'amd64', 'CGO_ENABLED': '0'})
go = 'C:/Program Files/Go/bin/go.exe'
result: dict[str, Any] = {'subject': a.sha, 'worktree': str(root), 'expectedHashes': expected, 'environment': {k: env[k] for k in ('GOTOOLCHAIN', 'GOFLAGS', 'GOROOT', 'GOOS', 'GOARCH', 'CGO_ENABLED')}, 'campaigns': [], 'status': 'running', 'startedAt': datetime.datetime.now().astimezone().isoformat()}
report = out / 'result.json'

def save():
    report.write_text(json.dumps(result, indent=2) + '\n', encoding='utf-8')

save()
for target in ('FuzzRegistrationGroupReplay', 'FuzzScopedGroupReplay', 'FuzzReviewGroupReplay', 'FuzzPaidGroupReplay'):
    before = hashes()
    if before != expected:
        result.update(status='source-mismatch-before', failedTarget=target, observedHashes=before)
        save()
        break
    argv = [go, 'test', '-run', '^$', '-fuzz', '^' + target + '$', '-fuzztime=120s', '-parallel=1', '-timeout=4m', './internal/core/agents']
    log = out / (target + '.log')
    row: dict[str, Any] = {'target': target, 'argv': argv, 'cwd': str(root), 'startedAt': datetime.datetime.now().astimezone().isoformat(), 'rawLog': str(log), 'beforeHashes': before}
    started = time.perf_counter()
    with log.open('wb') as raw:
        process = subprocess.Popen(argv, cwd=root, env=env, stdout=raw, stderr=subprocess.STDOUT)
        row['pid'] = process.pid
        try:
            row.update(exitCode=process.wait(timeout=300), timedOut=False)
        except subprocess.TimeoutExpired:
            kill_argv = [os.path.join(env['SystemRoot'], 'System32', 'taskkill.exe'), '/PID', str(process.pid), '/T', '/F']
            killed = subprocess.run(kill_argv, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=30, check=False)
            row['timeoutTreeKill'] = {'argv': kill_argv, 'exitCode': killed.returncode, 'output': killed.stdout.decode(errors='replace')}
            try:
                exit_code = process.wait(timeout=30)
            except subprocess.TimeoutExpired:
                exit_code = None
                row['processExitUnconfirmed'] = True
            row.update(exitCode=exit_code, timedOut=True)
    row.update(wallSeconds=time.perf_counter() - started, endedAt=datetime.datetime.now().astimezone().isoformat(), afterHashes=hashes())
    text = log.read_text(encoding='utf-8', errors='replace')
    stats = re.findall(r'fuzz: elapsed: ([^,\r\n]+), execs: (\d+) \(([^)]+)\), new interesting: (\d+) \(total: (\d+)\)', text)
    if stats:
        elapsed, executions, rate, interesting, total = stats[-1]
        row['lastReportedProgress'] = {'elapsed': elapsed, 'executions': int(executions), 'rate': rate, 'newInteresting': int(interesting), 'totalInteresting': int(total)}
    row['failureCorpusLines'] = [line for line in text.splitlines() if 'failing input' in line.lower() or 'testdata/fuzz/' in line or 'testdata\\fuzz\\' in line]
    row['passed'] = row['exitCode'] == 0 and not row['timedOut'] and row['afterHashes'] == expected and bool(re.search(r'^PASS\s*$', text, re.M))
    result['campaigns'].append(row)
    print(json.dumps({'target': target, 'passed': row['passed'], 'wallSeconds': row['wallSeconds'], 'lastReportedProgress': row.get('lastReportedProgress'), 'report': str(report)}), flush=True)
    save()
    if not row['passed']:
        result['status'] = 'failed'
        break
else:
    result['status'] = 'passed'
result['endedAt'] = datetime.datetime.now().astimezone().isoformat()
result['finalHashes'] = hashes()
if result['finalHashes'] != expected:
    result['status'] = 'source-mismatch-after'
save()
print(json.dumps({'status': result['status'], 'subject': a.sha, 'report': str(report)}), flush=True)
sys.exit(0 if result['status'] == 'passed' else 1)
