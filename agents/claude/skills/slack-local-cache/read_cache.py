#!/usr/bin/env -S uv run -q --with python-snappy python
"""Dump messages from the Slack desktop app's local cache as JSON lines.

usage: read_cache.py [--workspace SUBSTR] [--channel ID] [--grep REGEX] [--since YYYY-MM-DD]
"""

import argparse
import datetime as dt
import glob
import json
import os
import re

import snappy

BLOBS = os.path.expanduser("~/Library/Application Support/Slack/IndexedDB/https_app.slack.com_0.indexeddb.blob/*/*/*")
MSG = b'"\x04type"\x07message"\x02ts"'


def varint(b, i):
    n = shift = 0
    while True:
        c = b[i]
        i += 1
        n |= (c & 0x7F) << shift
        if c < 0x80:
            return n, i
        shift += 7


def string_after(seg, key):
    """Value of a V8-serialized string field: key, then tag ('"' one-byte, 'c' two-byte), varint length, bytes."""
    m = re.search(rb'"' + bytes([len(key)]) + key, seg)
    if not m:
        return None
    i = m.end()
    while seg[i] == 0:  # alignment padding before two-byte strings
        i += 1
    tag = seg[i]
    if tag not in (0x22, 0x63):
        return None
    n, i = varint(seg, i + 1)
    return seg[i : i + n].decode("latin1" if tag == 0x22 else "utf-16le", "replace")


def workspace(raw):
    hosts = re.findall(rb"([a-z0-9-]+)\.slack\.com", raw)
    hosts = [h.decode() for h in hosts if h not in (b"files", b"edgeapi", b"app", b"a", b"b")]
    return max(set(hosts), key=hosts.count) if hosts else "?"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--workspace", default="")
    ap.add_argument("--channel")
    ap.add_argument("--grep")
    ap.add_argument("--since")
    a = ap.parse_args()
    since = dt.datetime.fromisoformat(a.since).timestamp() if a.since else 0
    seen = set()
    for f in glob.glob(BLOBS):
        data = open(f, "rb").read()
        if data[:3] != b"\xff\x11\x02":
            continue
        raw = snappy.uncompress(data[3:])
        ws = workspace(raw)
        if a.workspace not in ws:
            continue
        starts = [m.start() for m in re.finditer(re.escape(MSG), raw)]
        for s, e in zip(starts, starts[1:] + [len(raw)]):
            seg = raw[s:e]
            ts = string_after(seg, b"ts")
            ch = string_after(seg, b"channel")
            text = string_after(seg, b"text")
            if not ts or (ws, ch, ts) in seen or float(ts) < since:
                continue
            seen.add((ws, ch, ts))
            if a.channel and ch != a.channel:
                continue
            if a.grep and not re.search(a.grep, text or "", re.I):
                continue
            print(
                json.dumps(
                    {
                        "workspace": ws,
                        "channel": ch,
                        "user": string_after(seg, b"user"),
                        "time": dt.datetime.fromtimestamp(float(ts)).isoformat(timespec="seconds"),
                        "ts": ts,
                        "text": text,
                    },
                    ensure_ascii=False,
                )
            )


main()
