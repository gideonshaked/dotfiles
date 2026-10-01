#!/usr/bin/env -S uv run --quiet --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["python-snappy"]
# ///
"""Read Slack workspaces from the Slack desktop app's local cache on macOS.

The app saves each signed-in workspace's client state (people, conversations,
recently loaded messages, files, reactions) to IndexedDB. This tool decodes that
state offline, with no network access and no credentials.
"""

import argparse
import datetime as dt
import glob
import json
import os
import re
import struct
import sys
from dataclasses import dataclass, field

import snappy

CACHE_GLOB = "~/Library/Application Support/Slack/IndexedDB/https_app.slack.com_0.indexeddb.blob/*/*/*"

# Blink wraps IndexedDB values: ff 11 is the wrapper version and 02 marks the
# payload as Snappy-compressed.
BLINK_COMPRESSED = b"\xff\x11\x02"


# --- V8 value deserialization -------------------------------------------------
#
# The decompressed payload is Blink's serialization envelope around V8's
# ValueSerializer format (v8/src/objects/value-serializer.cc). Only the tags
# that structured-clone can produce for plain app state are implemented.


class _Hole:
    """An elided element of a dense array."""


_HOLE = _Hole()


class V8Reader:
    def __init__(self, data: bytes, pos: int):
        self.data = data
        self.pos = pos
        # Back-references ('^') index objects in the order they were opened.
        self.objects: list = []

    def _byte(self) -> int:
        b = self.data[self.pos]
        self.pos += 1
        return b

    def _skip_padding(self) -> None:
        while self.data[self.pos] == 0:
            self.pos += 1

    def _varint(self) -> int:
        n = shift = 0
        while True:
            b = self._byte()
            n |= (b & 0x7F) << shift
            if b < 0x80:
                return n
            shift += 7

    def _zigzag(self) -> int:
        n = self._varint()
        return (n >> 1) ^ -(n & 1)

    def _double(self) -> float:
        (v,) = struct.unpack_from("<d", self.data, self.pos)
        self.pos += 8
        return v

    def _bytes(self, n: int) -> bytes:
        v = self.data[self.pos : self.pos + n]
        self.pos += n
        return v

    def _string(self, tag: str) -> str:
        encoding = {'"': "latin-1", "c": "utf-16-le", "S": "utf-8"}[tag]
        return self._bytes(self._varint()).decode(encoding, "replace")

    def _bigint(self) -> int:
        bitfield = self._varint()
        v = int.from_bytes(self._bytes(bitfield >> 1), "little")
        return -v if bitfield & 1 else v

    def _register(self, obj):
        self.objects.append(obj)
        return obj

    def _properties(self, end_tag: str) -> dict:
        props = {}
        while True:
            self._skip_padding()
            if chr(self.data[self.pos]) == end_tag:
                self.pos += 1
                return props
            key = self.read()
            props[key] = self.read()

    def read(self):
        self._skip_padding()
        tag = chr(self._byte())
        if tag == "\xff":  # version header, may precede any value
            self._varint()
            return self.read()
        if tag in "_0":
            return None
        if tag == "T":
            return True
        if tag == "F":
            return False
        if tag == "I":
            return self._zigzag()
        if tag == "U":
            return self._varint()
        if tag == "N":
            return self._double()
        if tag == "Z":
            return self._bigint()
        if tag in '"cS':
            return self._string(tag)
        if tag == "^":
            return self.objects[self._varint()]
        if tag == "o":
            obj = self._register({})
            obj.update(self._properties("{"))
            self._varint()
            return obj
        if tag == "A":
            arr = self._register([])
            for _ in range(self._varint()):
                v = self.read()
                arr.append(None if v is _HOLE else v)
            self._properties("$")
            self._varint()
            self._varint()
            return arr
        if tag == "a":
            arr = self._register([None] * self._varint())
            for k, v in self._properties("@").items():
                if isinstance(k, int) and 0 <= k < len(arr):
                    arr[k] = v
            self._varint()
            self._varint()
            return arr
        if tag == "-":
            return _HOLE
        if tag in "Dn":  # Date, Number object
            return self._register(self._double())
        if tag in "yx":  # Boolean objects
            return self._register(tag == "y")
        if tag == "z":
            return self._register(self._bigint())
        if tag == "s":
            return self._register(self._string(chr(self._byte())))
        if tag == "R":
            pattern = self._string(chr(self._byte()))
            self._varint()
            return self._register(pattern)
        if tag == ";":
            m = self._register({})
            while True:
                self._skip_padding()
                if chr(self.data[self.pos]) == ":":
                    self.pos += 1
                    self._varint()
                    return m
                k = self.read()
                m[k if isinstance(k, (str, int, float, bool, type(None))) else repr(k)] = self.read()
        if tag == "'":
            s = self._register([])
            while True:
                self._skip_padding()
                if chr(self.data[self.pos]) == ",":
                    self.pos += 1
                    self._varint()
                    return s
                s.append(self.read())
        if tag == "B":
            return self._register(self._bytes(self._varint()))
        raise ValueError(f"unsupported V8 tag {tag!r} at offset {self.pos - 1}")


def decode_state(blob: bytes):
    payload = snappy.uncompress(blob[len(BLINK_COMPRESSED) :])
    # Blink envelope: ff <version>, then an optional fe trailer-offset record
    # (8-byte offset + 4-byte size) before V8's own ff <version>.
    pos = 2
    if payload[pos] == 0xFE:
        pos += 13
    return V8Reader(payload, pos).read()


# --- Workspace model ----------------------------------------------------------


@dataclass
class Workspace:
    team_id: str
    domain: str
    name: str
    self_id: str
    cache_file: str
    saved_at: dt.datetime
    state: dict = field(repr=False)

    @property
    def users(self) -> dict:
        return self.state.get("members") or {}

    @property
    def channels(self) -> dict:
        return self.state.get("channels") or {}

    @property
    def messages(self) -> dict:
        return self.state.get("messages") or {}

    def user_name(self, uid: str | None) -> str:
        if not uid:
            return "unknown"
        u = self.users.get(uid)
        if not u:
            return uid
        p = u.get("profile") or {}
        return p.get("real_name") or u.get("real_name") or p.get("display_name") or u.get("name") or uid

    def author(self, m: dict) -> str:
        if m.get("user"):
            return self.user_name(m["user"])
        bot = (self.state.get("bots") or {}).get(m.get("bot_id") or "")
        return m.get("username") or (bot or {}).get("name") or ("bot" if m.get("bot_id") else "unknown")

    def channel_kind(self, c: dict) -> str:
        if c.get("is_im"):
            return "dm"
        if c.get("is_mpim"):
            return "group"
        if c.get("is_private") or c.get("is_group"):
            return "private"
        return "channel"

    def channel_label(self, cid: str) -> str:
        c = self.channels.get(cid) or {}
        kind = self.channel_kind(c)
        if kind == "dm":
            return f"@{self.user_name(c.get('user'))}"
        if kind == "group":
            # An unnamed group DM keeps Slack's generated mpdm-<handles> name.
            if (c.get("name_normalized") or "").startswith("mpdm-") or not c.get("name"):
                return ", ".join(self.user_name(u) for u in c.get("members") or [] if u != self.self_id) or cid
            return c["name"]
        return f"#{c.get('name') or cid}"

    def channel_members(self, cid: str) -> list[str]:
        c = self.channels.get(cid) or {}
        if c.get("is_im"):
            return [self.user_name(self.self_id), self.user_name(c.get("user"))]
        return [self.user_name(u) for u in c.get("members") or []]

    def cached_messages(self, cid: str) -> list[dict]:
        # isNonExistent marks a deleted message the app keeps as a placeholder.
        msgs = [
            m
            for m in (self.messages.get(cid) or {}).values()
            if isinstance(m, dict) and m.get("ts") and not m.get("isNonExistent")
        ]
        return sorted(msgs, key=lambda m: float(m["ts"]))

    def coverage(self, cid: str) -> str:
        h = (self.state.get("channelHistory") or {}).get(cid) or {}
        if h.get("reachedStart"):
            return "from the start of the conversation"
        msgs = self.cached_messages(cid)
        if not msgs:
            return "no messages cached"
        return f"from {fmt_time(msgs[0]['ts'])}; earlier history is not cached"

    def resolve_channel(self, query: str) -> str:
        if query in self.channels:
            return query
        q = query.lower().lstrip("#@")
        exact, partial = [], []
        for cid, c in self.channels.items():
            if not isinstance(c, dict):
                continue
            names = {self.channel_label(cid).lower().lstrip("#@"), (c.get("name") or "").lower()}
            if c.get("is_im"):
                u = self.users.get(c.get("user")) or {}
                p = u.get("profile") or {}
                names |= {
                    (u.get("name") or "").lower(),
                    (p.get("display_name") or "").lower(),
                    (p.get("real_name") or "").lower(),
                }
            names.discard("")
            if q in names:
                exact.append(cid)
            elif any(q in n for n in names):
                partial.append(cid)
        matches = exact or partial
        if len(matches) == 1:
            return matches[0]
        if not matches:
            raise LookupError(f"no conversation matches {query!r} in {self.domain}; see the channels command")
        listing = "\n".join(f"  {cid}  {self.channel_label(cid)}" for cid in matches)
        raise LookupError(f"{query!r} matches several conversations in {self.domain}; pass an ID:\n{listing}")

    def resolve_users(self, query: str) -> set[str]:
        q = query.lower().lstrip("@")
        if query in self.users:
            return {query}
        hits = set()
        for uid, u in self.users.items():
            p = u.get("profile") or {}
            names = [u.get("name"), u.get("real_name"), p.get("real_name"), p.get("display_name")]
            if any(n and q in n.lower() for n in names):
                hits.add(uid)
        if not hits:
            raise LookupError(f"no person matches {query!r} in {self.domain}; see the users command")
        return hits


def load_workspaces() -> list[Workspace]:
    """One Workspace per signed-in team, from its most recently saved cache file."""
    found: dict[str, Workspace] = {}
    for path in glob.glob(os.path.expanduser(CACHE_GLOB)):
        with open(path, "rb") as f:
            blob = f.read()
        if not blob.startswith(BLINK_COMPRESSED):
            continue
        state = decode_state(blob)
        if not isinstance(state, dict) or "bootData" not in state:
            continue
        self_id = state["bootData"].get("user_id") or ""
        team_id = (state.get("members", {}).get(self_id) or {}).get("team_id") or ""
        team = (state.get("teams") or {}).get(team_id) or {}
        ws = Workspace(
            team_id=team_id,
            domain=team.get("domain") or team_id,
            name=team.get("name") or team_id,
            self_id=self_id,
            cache_file=path,
            saved_at=dt.datetime.fromtimestamp(os.path.getmtime(path)),
            state=state,
        )
        if team_id not in found or ws.saved_at > found[team_id].saved_at:
            found[team_id] = ws
    return sorted(found.values(), key=lambda w: w.domain)


def pick_workspace(workspaces: list[Workspace], query: str) -> Workspace:
    q = query.lower()
    exact = [w for w in workspaces if q in (w.domain.lower(), w.name.lower(), w.team_id.lower())]
    matches = exact or [w for w in workspaces if q in w.domain.lower() or q in w.name.lower()]
    if len(matches) == 1:
        return matches[0]
    known = ", ".join(w.domain for w in workspaces)
    if not matches:
        raise LookupError(f"no cached workspace matches {query!r}; cached: {known}")
    raise LookupError(
        f"{query!r} matches several workspaces ({', '.join(w.domain for w in matches)}); use the full domain"
    )


# --- Rendering ----------------------------------------------------------------

MRKDWN_TOKEN = re.compile(r"<([^<>]+)>")


def fmt_time(ts: str) -> str:
    return dt.datetime.fromtimestamp(float(ts)).strftime("%Y-%m-%d %H:%M")


def parse_day(s: str) -> float:
    return dt.datetime.fromisoformat(s).timestamp()


def render_text(ws: Workspace, text: str) -> str:
    """Slack mrkdwn to plain text: mentions become names, links show their target."""

    def token(m: re.Match) -> str:
        body = m.group(1)
        target, _, label = body.partition("|")
        if target.startswith("@"):
            return "@" + (label or ws.user_name(target[1:]))
        if target.startswith("#"):
            return "#" + (label or ws.channel_label(target[1:]).lstrip("#"))
        if target.startswith("!subteam^"):
            group = (ws.state.get("userGroups") or {}).get(target.split("^", 1)[1]) or {}
            return label or "@" + (group.get("handle") or "group")
        if target.startswith("!"):
            return "@" + (label or target[1:].split("^")[0])
        # A pasted link is labelled with the URL itself, shortened with an
        # ellipsis; only a hand-written label adds anything beside the URL.
        if label and "\u2026" not in label and label not in target:
            return f"{label} ({target})"
        return target

    text = MRKDWN_TOKEN.sub(token, text or "")
    return text.replace("&lt;", "<").replace("&gt;", ">").replace("&amp;", "&")


def message_files(ws: Workspace, m: dict) -> list[dict]:
    store = ws.state.get("files") or {}
    out = []
    for ref in (m.get("files") or []) + (m.get("x_files") or []):
        f = store.get(ref) if isinstance(ref, str) else ref
        f = f or {"id": ref}
        out.append(
            {
                "name": f.get("title") or f.get("name") or f.get("id"),
                "type": f.get("pretty_type") or f.get("filetype"),
                "size": f.get("size"),
                "url": f.get("url_private") or f.get("permalink"),
            }
        )
    return out


def message_attachments(ws: Workspace, m: dict) -> list[dict]:
    out = []
    for a in m.get("attachments") or []:
        if not isinstance(a, dict):
            continue
        out.append(
            {
                "title": a.get("title") or a.get("fallback") or a.get("service_name"),
                "url": a.get("title_link") or a.get("from_url") or a.get("original_url"),
                "text": render_text(ws, a.get("text") or ""),
            }
        )
    return out


def message_reactions(ws: Workspace, cid: str, m: dict) -> list[dict]:
    rx = (ws.state.get("reactions") or {}).get(f"message-{m['ts']}-{cid}") or []
    return [
        {"emoji": r.get("name"), "count": r.get("count"), "by": [ws.user_name(u) for u in r.get("users") or []]}
        for r in rx
        if isinstance(r, dict)
    ]


def is_reply(m: dict) -> bool:
    return bool(m.get("thread_ts")) and m["thread_ts"] != m["ts"]


def message_record(ws: Workspace, cid: str, m: dict) -> dict:
    return {
        "workspace": ws.domain,
        "channel_id": cid,
        "channel": ws.channel_label(cid),
        "ts": m["ts"],
        "time": dt.datetime.fromtimestamp(float(m["ts"])).isoformat(timespec="seconds"),
        "thread_ts": m.get("thread_ts"),
        "is_reply": is_reply(m),
        "reply_count": m.get("reply_count") or 0,
        "user_id": m.get("user"),
        "user": ws.author(m),
        "subtype": m.get("subtype"),
        "edited": bool(m.get("edited")),
        "text": render_text(ws, m.get("text") or ""),
        "files": message_files(ws, m),
        "attachments": message_attachments(ws, m),
        "reactions": message_reactions(ws, cid, m),
    }


def format_record(r: dict, indent: str = "", show_channel: bool = False) -> str:
    where = f"{r['channel']} | " if show_channel else ""
    head = f"{indent}[{fmt_time(r['ts'])}] {where}{r['user']}"
    if r["edited"]:
        head += " (edited)"
    lines = [head + ":"]
    body = indent + "  "
    for line in (r["text"] or "").splitlines() or [""]:
        if line or not (r["files"] or r["attachments"]):
            lines.append(body + line)
    for f in r["files"]:
        meta = ", ".join(str(x) for x in (f["type"], human_size(f["size"])) if x)
        lines.append(
            f"{body}[file] {f['name']}" + (f" ({meta})" if meta else "") + (f" {f['url']}" if f["url"] else "")
        )
    for a in r["attachments"]:
        lines.append(f"{body}[link] {a['title'] or ''} {a['url'] or ''}".rstrip())
    if r["reactions"]:
        lines.append(body + "  ".join(f":{x['emoji']}: {', '.join(x['by'])}" for x in r["reactions"]))
    return "\n".join(lines)


def human_size(n) -> str | None:
    if not n:
        return None
    for unit in ("B", "KB", "MB", "GB"):
        if n < 1024 or unit == "GB":
            return f"{n:.0f} {unit}" if unit == "B" else f"{n:.1f} {unit}"
        n /= 1024


def in_window(m: dict, args) -> bool:
    ts = float(m["ts"])
    return (not args.since or ts >= parse_day(args.since)) and (not args.until or ts < parse_day(args.until))


# --- Commands -----------------------------------------------------------------


def cmd_workspaces(args, workspaces: list[Workspace]) -> None:
    rows = []
    for w in workspaces:
        counts = [len(w.cached_messages(cid)) for cid in w.messages]
        rows.append(
            {
                "domain": w.domain,
                "name": w.name,
                "team_id": w.team_id,
                "you": w.user_name(w.self_id),
                "conversations_with_messages": sum(1 for n in counts if n),
                "messages": sum(counts),
                "cache_saved": w.saved_at.isoformat(timespec="seconds"),
            }
        )
    if args.json:
        for r in rows:
            print(json.dumps(r, ensure_ascii=False))
        return
    for r in rows:
        print(
            f"{r['domain']:<20} {r['name']:<28} {r['messages']:>5} messages in {r['conversations_with_messages']:>3} conversations, saved {r['cache_saved']}"
        )


def cmd_channels(args, ws: Workspace) -> None:
    rows = []
    for cid, c in ws.channels.items():
        if not isinstance(c, dict):
            continue
        msgs = ws.cached_messages(cid)
        if not msgs and not args.all:
            continue
        kind = ws.channel_kind(c)
        if args.kind and kind != args.kind:
            continue
        rows.append(
            {
                "id": cid,
                "kind": kind,
                "name": ws.channel_label(cid),
                "members": ws.channel_members(cid) if kind in ("dm", "group") else None,
                "cached_messages": len(msgs),
                "latest": dt.datetime.fromtimestamp(float(msgs[-1]["ts"])).isoformat(timespec="seconds")
                if msgs
                else None,
            }
        )
    rows.sort(key=lambda r: r["latest"] or "", reverse=True)
    if args.json:
        for r in rows:
            print(json.dumps(r, ensure_ascii=False))
        return
    for r in rows:
        latest = r["latest"].replace("T", " ")[:16] if r["latest"] else "-"
        print(f"{r['id']:<12} {r['kind']:<8} {r['cached_messages']:>4}  {latest:<16}  {r['name']}")


def cmd_read(args, ws: Workspace) -> None:
    cid = ws.resolve_channel(args.conversation)
    msgs = [m for m in ws.cached_messages(cid) if in_window(m, args)]
    replies: dict[str, list[dict]] = {}
    top = []
    for m in msgs:
        if is_reply(m):
            replies.setdefault(m["thread_ts"], []).append(m)
        else:
            top.append(m)
    # Replies whose parent is not cached still belong in the transcript; the
    # cached reply often carries a copy of its parent under "root".
    by_ts = {m["ts"] for m in top}
    for thread_ts, rs in replies.items():
        if thread_ts not in by_ts:
            root = next((r["root"] for r in rs if isinstance(r.get("root"), dict)), None)
            top.append(root or {"ts": thread_ts, "text": "(thread parent not cached)", "user": None})
    top.sort(key=lambda m: float(m["ts"]))
    if args.limit:
        top = top[-args.limit :]

    records = []
    for m in top:
        r = message_record(ws, cid, m)
        r["replies"] = [message_record(ws, cid, x) for x in replies.get(m["ts"], [])] if args.threads else []
        records.append(r)

    if args.json:
        for r in records:
            print(json.dumps(r, ensure_ascii=False))
        return
    c = ws.channels.get(cid) or {}
    print(f"{ws.channel_label(cid)}  ({ws.channel_kind(c)}, {ws.name}, {cid})")
    if ws.channel_kind(c) in ("dm", "group"):
        print("Members: " + ", ".join(ws.channel_members(cid)))
    topic = ((c.get("topic") or {}).get("value") or "").strip()
    if topic:
        print(f"Topic: {render_text(ws, topic)}")
    print(f"Cached: {ws.coverage(cid)}; app cache saved {ws.saved_at:%Y-%m-%d %H:%M}")
    print()
    for r in records:
        print(format_record(r))
        hidden = r["reply_count"] - len(r["replies"])
        for x in r["replies"]:
            print(format_record(x, indent="    | "))
        if args.threads and hidden > 0:
            print(f"    | ({hidden} more replies not cached)")
        elif not args.threads and r["reply_count"]:
            print(f"    | ({r['reply_count']} replies; pass --threads to show the cached ones)")
        print()


def cmd_search(args, ws: Workspace) -> None:
    pattern = re.compile(args.pattern, re.I) if args.pattern else None
    users = ws.resolve_users(args.user) if args.user else None
    cids = [ws.resolve_channel(args.channel)] if args.channel else list(ws.messages)
    hits = []
    for cid in cids:
        for m in ws.cached_messages(cid):
            if not in_window(m, args) or (users and m.get("user") not in users):
                continue
            r = message_record(ws, cid, m)
            searchable = " ".join(
                [r["text"]] + [f["name"] or "" for f in r["files"]] + [a["title"] or "" for a in r["attachments"]]
            )
            if pattern and not pattern.search(searchable):
                continue
            hits.append(r)
    hits.sort(key=lambda r: float(r["ts"]))
    if args.limit:
        hits = hits[-args.limit :]
    for r in hits:
        print(json.dumps(r, ensure_ascii=False) if args.json else format_record(r, show_channel=True) + "\n")


def cmd_users(args, ws: Workspace) -> None:
    uids = ws.resolve_users(args.query) if args.query else list(ws.users)
    rows = []
    for uid in uids:
        u = ws.users[uid]
        p = u.get("profile") or {}
        rows.append(
            {
                "id": uid,
                "handle": u.get("name"),
                "real_name": p.get("real_name") or u.get("real_name"),
                "display_name": p.get("display_name"),
                "title": p.get("title"),
                "bot": bool(u.get("is_bot")),
                "deleted": bool(u.get("deleted")),
            }
        )
    rows.sort(key=lambda r: (r["real_name"] or r["handle"] or "").lower())
    for r in rows:
        if args.json:
            print(json.dumps(r, ensure_ascii=False))
            continue
        flags = " ".join(f for f, on in (("bot", r["bot"]), ("deleted", r["deleted"])) if on)
        title = f"  {r['title']}" if r["title"] else ""
        print(f"{r['id']:<12} {r['real_name'] or '':<28} @{r['handle'] or '':<20}{title}  {flags}".rstrip())


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    sub = ap.add_subparsers(dest="command", required=True)

    def add(name: str, help_: str, workspace: bool = True):
        p = sub.add_parser(name, help=help_)
        if workspace:
            p.add_argument(
                "-w",
                "--workspace",
                required=True,
                help="workspace domain, name or team ID (see the workspaces command)",
            )
        p.add_argument("--json", action="store_true", help="one JSON object per line instead of text")
        return p

    add("workspaces", "list the workspaces in the cache", workspace=False)

    p = add("channels", "list conversations, most recent first")
    p.add_argument("--kind", choices=["channel", "private", "dm", "group"])
    p.add_argument("--all", action="store_true", help="include conversations with no cached messages")

    p = add("read", "print one conversation as a transcript")
    p.add_argument("conversation", help="channel ID, #name, group name, or a person's name for a DM")
    p.add_argument("--threads", action="store_true", help="show cached thread replies under each message")
    p.add_argument("--since", help="YYYY-MM-DD[THH:MM], local time")
    p.add_argument("--until", help="YYYY-MM-DD[THH:MM], local time, exclusive")
    p.add_argument("--limit", type=int, help="only the last N top-level messages")

    p = add("search", "find messages across conversations")
    p.add_argument("pattern", nargs="?", help="case-insensitive regex over text, file names and link titles")
    p.add_argument("--user", help="only messages from this person")
    p.add_argument("--channel", help="only this conversation")
    p.add_argument("--since", help="YYYY-MM-DD[THH:MM], local time")
    p.add_argument("--until", help="YYYY-MM-DD[THH:MM], local time, exclusive")
    p.add_argument("--limit", type=int, help="only the last N matches")

    p = add("users", "list or look up people")
    p.add_argument("query", nargs="?", help="substring of a name, handle or display name")

    args = ap.parse_args()
    workspaces = load_workspaces()
    try:
        if args.command == "workspaces":
            cmd_workspaces(args, workspaces)
            return
        ws = pick_workspace(workspaces, args.workspace)
        {"channels": cmd_channels, "read": cmd_read, "search": cmd_search, "users": cmd_users}[args.command](args, ws)
    except LookupError as e:
        sys.exit(str(e))


if __name__ == "__main__":
    main()
