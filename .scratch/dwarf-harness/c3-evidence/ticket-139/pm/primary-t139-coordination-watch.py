import argparse
import hashlib
from pathlib import Path
import time

p = argparse.ArgumentParser()
p.add_argument('path')
p.add_argument('--marker', required=True)
a = p.parse_args()
path = Path(a.path)
initial = path.read_bytes()
if not initial.decode('utf-8-sig').rstrip().endswith(a.marker):
    print('COORDINATION_MAILBOX_ALREADY_UPDATED ' + str(path), flush=True)
    raise SystemExit(0)
original = hashlib.sha256(initial).hexdigest()
while True:
    time.sleep(2)
    current = path.read_bytes()
    digest = hashlib.sha256(current).hexdigest()
    if digest != original:
        print('COORDINATION_MAILBOX_UPDATED ' + str(path) + ' sha256=' + digest, flush=True)
        break
