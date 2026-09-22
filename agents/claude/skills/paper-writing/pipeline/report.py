#!/usr/bin/env python3
"""Stage 5: write report.md from the theme files and the correction corpus.

Usage: report.py corrections.jsonl themes.json [themes_figure.json themes_analysis.json] > report.md
"""
import collections
import json
import sys

rows = [json.loads(l) for l in open(sys.argv[1])]
by_dom = collections.Counter(r["domain"] for r in rows)
sev = collections.Counter(r["severity"] for r in rows)
print("# Correction corpus report\n")
print(f"Corrections after cross-session dedupe: {len(rows)}\n")
print("| Domain | Count |\n|---|---|")
for d, c in by_dom.most_common():
    print(f"| {d} | {c} |")
print("\n| Severity | Count |\n|---|---|")
for k in sorted(sev):
    print(f"| {k} | {sev[k]} |")
valid = {r["n"] for r in rows}
for path in sys.argv[2:]:
    themes = json.load(open(path))
    label = path.rsplit("/", 1)[-1]
    print(f"\n## Themes from {label}\n")
    print("| Count | Max severity | Theme |\n|---|---|---|")
    for t in sorted(themes, key=lambda t: -len(set(t["ns"]) & valid)):
        n = len(set(t["ns"]) & valid)
        if n == 0:
            continue
        print(f"| {n} | {t['max_severity']} | {t['theme']} |")
