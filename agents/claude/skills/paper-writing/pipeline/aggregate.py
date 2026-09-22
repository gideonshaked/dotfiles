#!/usr/bin/env python3
"""Stage 3: merge labels, validate, and emit the correction corpus.

Usage: aggregate.py turns.jsonl labels/ > corrections.jsonl

Writes counts to stderr. Each output row joins the label with the original
turn so the synthesis stage sees the human's words, what they rejected, and
the generic rule side by side.
"""
import collections
import glob
import json
import sys

KINDS = {"correction", "instruction", "question", "ack", "ops"}
DOMAINS = {"prose", "figure", "analysis", "ops", "other"}

turns = {json.loads(l)["n"]: json.loads(l) for l in open(sys.argv[1])}
labels = {}
bad = 0
for path in sorted(glob.glob(sys.argv[2].rstrip("/") + "/chunk_*.jsonl")):
    for line in open(path):
        line = line.strip()
        if not line:
            continue
        try:
            lab = json.loads(line)
        except json.JSONDecodeError:
            bad += 1
            continue
        if lab.get("kind") not in KINDS or lab.get("domain") not in DOMAINS or lab["n"] not in turns:
            bad += 1
            continue
        labels[lab["n"]] = lab

missing = sorted(set(turns) - set(labels))
kinds = collections.Counter(l["kind"] for l in labels.values())
dom = collections.Counter((l["kind"], l["domain"]) for l in labels.values() if l["kind"] == "correction")
sev = collections.Counter(l["severity"] for l in labels.values() if l["kind"] == "correction")
print(f"turns={len(turns)} labeled={len(labels)} missing={len(missing)} malformed={bad}", file=sys.stderr)
print(f"kinds={dict(kinds)}", file=sys.stderr)
print(f"corrections by domain={ {d: c for (_, d), c in dom.items()} }", file=sys.stderr)
print(f"corrections by severity={dict(sev)}", file=sys.stderr)
if missing:
    print(f"missing n: {missing[:40]}{'...' if len(missing) > 40 else ''}", file=sys.stderr)

# A resumed session replays the tail of the one it continues, so the same
# human message can appear under both session ids. Drop the later copy.
# Repeats inside one session are kept: they are the human saying it again.
seen_text = {}
dropped = 0
for n in sorted(labels):
    lab = labels[n]
    if lab["kind"] != "correction":
        continue
    t = turns[n]
    key = " ".join(t["user"].split())
    if key in seen_text and seen_text[key] != t["session"]:
        dropped += 1
        continue
    seen_text.setdefault(key, t["session"])
    print(json.dumps({
        "n": n, "session": t["session"], "ts": t["ts"],
        "domain": lab["domain"], "severity": lab["severity"],
        "rule": lab["rule"], "target": lab["target"], "quote": lab["quote"],
        "user": t["user"],
        "prior_assistant": t["prior_assistant"][-1200:],
        "tool_context": t["tool_context"],
    }, ensure_ascii=False))
print(f"cross-session duplicates dropped={dropped}", file=sys.stderr)
