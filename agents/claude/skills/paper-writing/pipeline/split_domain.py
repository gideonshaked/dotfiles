#!/usr/bin/env python3
"""Stage 4a: split corrections by domain and write a compact rule sheet.

Usage: split_domain.py corrections.jsonl OUTDIR

OUTDIR/prose.jsonl etc. hold full rows. OUTDIR/prose_rules.txt holds one
line per correction: n, severity, rule, quote. That sheet is what the
synthesis pass clusters.
"""
import collections
import json
import os
import sys

rows = [json.loads(l) for l in open(sys.argv[1])]
out = sys.argv[2]
os.makedirs(out, exist_ok=True)
by = collections.defaultdict(list)
for r in rows:
    by[r["domain"]].append(r)
for d, rs in by.items():
    with open(os.path.join(out, f"{d}.jsonl"), "w") as fh:
        for r in rs:
            fh.write(json.dumps(r, ensure_ascii=False) + "\n")
    with open(os.path.join(out, f"{d}_rules.txt"), "w") as fh:
        for r in rs:
            q = " ".join(r["quote"].split())[:220]
            fh.write(f"[{r['n']}|s{r['severity']}] {r['rule']}\n    << {q}\n")
    print(f"{d}: {len(rs)}", file=sys.stderr)
