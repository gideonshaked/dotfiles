#!/usr/bin/env python3
"""Stage 1: pull human-typed turns out of Claude Code session JSONL.

Usage: extract.py SESSION.jsonl [SESSION.jsonl ...] > turns.jsonl

Each output line: {session, ts, n, user, prior_assistant, tool_context}.
prior_assistant is the last assistant prose emitted before the turn (the
text the human is reacting to). tool_context is the last Edit/Write old->new
pair before the turn, so a terse "no" can be resolved to the prose it rejects.
Tool results, compaction summaries, sidechains and interrupt markers are
dropped: they are not the human speaking.
"""
import json
import re
import sys

SKIP_PREFIXES = (
    "[Request interrupted by user",
    "This session is being continued from a previous conversation",
    "<system-reminder>",
    "<command-name>",
    "<local-command",
    "<bash-input>",
    "<bash-stdout>",
    "<bash-stderr>",
    "<task-notification>",
    "The fork runs as its own separate session",
    "Another Claude session sent a message",
    "Codebase and user instructions are shown below",
    "Base directory for this skill",
    "/compact",
    "/clear",
)
IMAGE_MARKER = re.compile(r"\[Image: original [^\]]*\]\s*")


def user_text(content):
    if isinstance(content, str):
        return content
    parts = []
    for block in content:
        if block.get("type") == "text":
            parts.append(block["text"])
        elif block.get("type") == "tool_result":
            return None
    return "\n".join(parts) if parts else None


def strip_reminders(text):
    # Human text arrives wrapped in harness-injected reminders; keep the human part.
    out = []
    depth = 0
    i = 0
    while i < len(text):
        if text.startswith("<system-reminder>", i):
            depth += 1
            i += len("<system-reminder>")
        elif text.startswith("</system-reminder>", i):
            depth = max(0, depth - 1)
            i += len("</system-reminder>")
        else:
            if depth == 0:
                out.append(text[i])
            i += 1
    return "".join(out).strip()


def main(paths):
    n = 0
    for path in paths:
        session = path.rsplit("/", 1)[-1].split(".")[0][:8]
        prior_assistant = ""
        tool_context = None
        with open(path) as fh:
            for line in fh:
                try:
                    d = json.loads(line)
                except json.JSONDecodeError:
                    continue
                if d.get("isSidechain"):
                    continue
                t = d.get("type")
                if t == "assistant":
                    for block in d.get("message", {}).get("content", []) or []:
                        if block.get("type") == "text" and block["text"].strip():
                            prior_assistant = block["text"]
                        elif block.get("type") == "tool_use":
                            inp = block.get("input", {})
                            if block.get("name") in ("Edit", "Write") and inp:
                                tool_context = {
                                    "tool": block["name"],
                                    "file": inp.get("file_path", ""),
                                    "old": (inp.get("old_string") or "")[:1500],
                                    "new": (inp.get("new_string") or inp.get("content") or "")[:1500],
                                }
                    continue
                if t != "user" or d.get("isCompactSummary"):
                    continue
                text = user_text(d.get("message", {}).get("content"))
                if not text:
                    continue
                text = strip_reminders(text)
                if not text or text.startswith(SKIP_PREFIXES):
                    continue
                # An image-only turn is the human pointing at a figure; the
                # words, if any, follow the marker.
                text = IMAGE_MARKER.sub("[image] ", text).strip()
                if text == "[image]":
                    continue
                n += 1
                print(json.dumps({
                    "session": session,
                    "ts": d.get("timestamp"),
                    "n": n,
                    "user": text,
                    "prior_assistant": prior_assistant[-2500:],
                    "tool_context": tool_context,
                }, ensure_ascii=False))
                prior_assistant = ""
                tool_context = None
    print(f"extracted {n} human turns", file=sys.stderr)


if __name__ == "__main__":
    main(sys.argv[1:])
