#!/usr/bin/env python3
"""Stage 2a: split turns.jsonl into fixed-size chunks for parallel labeling.

Usage: chunk.py turns.jsonl OUTDIR [SIZE]
"""
import json
import os
import sys

src, outdir = sys.argv[1], sys.argv[2]
size = int(sys.argv[3]) if len(sys.argv) > 3 else 130
os.makedirs(outdir, exist_ok=True)
rows = [json.loads(l) for l in open(src)]
for i in range(0, len(rows), size):
    with open(os.path.join(outdir, f"chunk_{i // size:02d}.jsonl"), "w") as fh:
        for r in rows[i:i + size]:
            fh.write(json.dumps(r, ensure_ascii=False) + "\n")
print(f"{len(rows)} turns -> {(len(rows) + size - 1) // size} chunks in {outdir}", file=sys.stderr)
