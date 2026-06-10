#!/usr/bin/env -S uv run --quiet --script
# /// script
# requires-python = ">=3.10"
# dependencies = ["cryptography"]
# ///
"""Import a claude.ai (Claude Desktop) conversation as a Claude Code session transcript.

The conversation content is NOT stored locally by the desktop app; it lives on
claude.ai servers. This tool reads the desktop app's session cookie from the local
Cookies store (decrypting it with the macOS Keychain key "Claude Safe Storage"),
calls the claude.ai API to download the conversation, then writes it out as a
Claude Code .jsonl transcript so it shows up in `claude --resume`.

Subcommands:
  list                          List all conversations (uuid | name | updated_at) as JSON.
  convert --cwd PATH (--name N | --id UUID)
                                Download a conversation and write the CC transcript.
                                Prints {session_id, out_path, lines, source_name} as JSON.

macOS only (relies on the Keychain + Chromium v10 cookie encryption).
Approving a Keychain prompt may be required the first time.
"""

import argparse
import gzip
import json
import os
import sqlite3
import subprocess
import sys
import urllib.error
import urllib.request
import uuid

from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC

COOKIES = os.path.expanduser("~/Library/Application Support/Claude/Cookies")
KEYCHAIN_SERVICE = "Claude Safe Storage"
DEFAULT_VERSION = "2.1.170"
# A browser-ish UA helps the request sail past Cloudflare with the cf_clearance cookie.
UA = (
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 "
    "(KHTML, like Gecko) Claude/1.0 Chrome/130.0.0.0 Electron/33.0.0 Safari/537.36"
)


def die(msg):
    print(json.dumps({"error": msg}), file=sys.stderr)
    sys.exit(1)


# --- cookie decryption -------------------------------------------------------


def _key():
    try:
        pw = subprocess.check_output(["security", "find-generic-password", "-w", "-s", KEYCHAIN_SERVICE]).strip()
    except subprocess.CalledProcessError:
        die(f"could not read Keychain item '{KEYCHAIN_SERVICE}' (is Claude Desktop installed?)")
    kdf = PBKDF2HMAC(
        algorithm=hashes.SHA1(),
        length=16,
        salt=b"saltysalt",
        iterations=1003,
        backend=default_backend(),
    )
    return kdf.derive(pw)


def _decrypt(blob, key):
    if blob[:3] != b"v10":
        return None
    cipher = Cipher(algorithms.AES(key), modes.CBC(b" " * 16), backend=default_backend())
    d = cipher.decryptor()
    out = d.update(blob[3:]) + d.finalize()
    pad = out[-1]
    if 1 <= pad <= 16:
        out = out[:-pad]
    try:
        return out.decode("utf-8")
    except UnicodeDecodeError:
        # Newer Chromium prepends a 32-byte SHA256 domain hash to the plaintext.
        return out[32:].decode("utf-8", "replace")


def _cookie_jar():
    if not os.path.exists(COOKIES):
        die(f"cookies db not found at {COOKIES}")
    key = _key()
    con = sqlite3.connect(f"file:{COOKIES}?mode=ro", uri=True)
    jar = {}
    for name, ev in con.execute("SELECT name, encrypted_value FROM cookies WHERE host_key LIKE '%claude.ai%'"):
        val = _decrypt(ev, key)
        if val:
            jar[name] = val
    con.close()
    if "sessionKey" not in jar:
        die("no sessionKey cookie found - are you logged into Claude Desktop?")
    return jar


# --- claude.ai API -----------------------------------------------------------


def _get(url, jar):
    req = urllib.request.Request(
        url,
        headers={
            "Cookie": "; ".join(f"{k}={v}" for k, v in jar.items()),
            "User-Agent": UA,
            "Accept": "*/*",
            "Accept-Encoding": "gzip",
            "Referer": "https://claude.ai/",
            "anthropic-client-platform": "web_claude_ai",
        },
    )
    try:
        with urllib.request.urlopen(req, timeout=30) as r:
            data = r.read()
            if r.headers.get("Content-Encoding") == "gzip":
                data = gzip.decompress(data)
            return data
    except urllib.error.HTTPError as e:
        die(f"HTTP {e.code} from {url}: {e.read()[:300]!r}")


def _org(jar):
    org = jar.get("lastActiveOrg")
    if org:
        return org
    orgs = json.loads(_get("https://claude.ai/api/organizations", jar))
    if not orgs:
        die("no organizations found for this account")
    return orgs[0]["uuid"]


def _list_conversations(jar, org):
    url = f"https://claude.ai/api/organizations/{org}/chat_conversations"
    return json.loads(_get(url, jar))


def _fetch_conversation(jar, org, cid):
    url = (
        f"https://claude.ai/api/organizations/{org}/chat_conversations/{cid}"
        "?tree=True&rendering_mode=messages&render_all_tools=true"
    )
    return json.loads(_get(url, jar))


# --- conversion --------------------------------------------------------------


def _web_search_to_text(content):
    if isinstance(content, str):
        return content
    parts = []
    for item in content or []:
        if isinstance(item, dict):
            title = item.get("title", "")
            url = item.get("url", "")
            parts.append(f"- {title}\n  {url}".rstrip())
    return "\n".join(parts) if parts else json.dumps(content)[:4000]


def _stub_usage():
    return {
        "input_tokens": 0,
        "cache_creation_input_tokens": 0,
        "cache_read_input_tokens": 0,
        "output_tokens": 0,
        "service_tier": "standard",
    }


def convert(conv, cwd, version):
    """Turn a claude.ai conversation dict into Claude Code .jsonl lines.

    Each content block becomes its own parentUuid-chained line, matching how
    Claude Code records turns: thinking/text/tool_use -> assistant lines,
    tool_result -> user lines. All blocks of one assistant turn share a message.id.
    """
    session_id = str(uuid.uuid4())
    model = conv.get("model") or "claude-opus-4-8"
    msgs = sorted(conv.get("chat_messages", []), key=lambda m: m.get("index", 0))
    lines = []
    prev = None

    def meta(ts):
        return {
            "userType": "external",
            "entrypoint": "cli",
            "cwd": cwd,
            "sessionId": session_id,
            "version": version,
            "gitBranch": "",
            "timestamp": ts,
        }

    for m in msgs:
        sender = m["sender"]
        created = m.get("created_at")
        blocks = m.get("content", [])

        if sender == "human":
            text = m.get("text", "") or "".join(c.get("text", "") for c in blocks if c.get("type") == "text")
            extras = []
            for a in m.get("attachments", []) or []:
                fn = a.get("file_name") or "pasted-content"
                ec = a.get("extracted_content") or ""
                extras.append(f"\n\n[Attached file: {fn}]\n{ec}")
            for f in m.get("files", []) or []:
                extras.append(f"\n\n[Attached image: {f.get('file_name', 'image')}]")
            uid = str(uuid.uuid4())
            lines.append(
                {
                    "parentUuid": prev,
                    "isSidechain": False,
                    "promptId": str(uuid.uuid4()),
                    "type": "user",
                    "message": {"role": "user", "content": text + "".join(extras)},
                    "uuid": uid,
                    **meta(created),
                }
            )
            prev = uid
            continue

        msg_id = "msg_" + uuid.uuid4().hex[:24]
        req_id = "req_" + uuid.uuid4().hex[:24]
        for c in blocks:
            ctype = c.get("type")
            ts = c.get("start_timestamp") or created
            if ctype == "thinking":
                block = {"type": "thinking", "thinking": c.get("thinking", ""), "signature": ""}
            elif ctype == "text":
                block = {"type": "text", "text": c.get("text", "")}
            elif ctype == "tool_use":
                block = {
                    "type": "tool_use",
                    "id": c.get("id") or ("toolu_" + uuid.uuid4().hex[:24]),
                    "name": c.get("name", "unknown"),
                    "input": c.get("input", {}),
                }
            elif ctype == "tool_result":
                text_content = _web_search_to_text(c.get("content"))
                uid = str(uuid.uuid4())
                lines.append(
                    {
                        "parentUuid": prev,
                        "isSidechain": False,
                        "promptId": str(uuid.uuid4()),
                        "type": "user",
                        "message": {
                            "role": "user",
                            "content": [
                                {
                                    "tool_use_id": c.get("tool_use_id"),
                                    "type": "tool_result",
                                    "content": text_content,
                                    "is_error": bool(c.get("is_error")),
                                }
                            ],
                        },
                        "uuid": uid,
                        "toolUseResult": {"stdout": text_content, "stderr": "", "interrupted": False},
                        "sourceToolAssistantUUID": prev,
                        **meta(ts),
                    }
                )
                prev = uid
                continue
            else:
                continue
            uid = str(uuid.uuid4())
            lines.append(
                {
                    "parentUuid": prev,
                    "isSidechain": False,
                    "message": {
                        "model": model,
                        "id": msg_id,
                        "type": "message",
                        "role": "assistant",
                        "content": [block],
                        "stop_reason": None,
                        "stop_sequence": None,
                        "usage": _stub_usage(),
                    },
                    "requestId": req_id,
                    "type": "assistant",
                    "uuid": uid,
                    **meta(ts),
                }
            )
            prev = uid

    return session_id, lines, prev


def write_session(session_id, lines, leaf, cwd):
    proj_dir = os.path.expanduser("~/.claude/projects/" + cwd.replace("/", "-"))
    os.makedirs(proj_dir, exist_ok=True)
    out_path = os.path.join(proj_dir, f"{session_id}.jsonl")
    with open(out_path, "w") as fh:
        fh.write(json.dumps({"type": "mode", "mode": "normal", "sessionId": session_id}) + "\n")
        fh.write(json.dumps({"type": "permission-mode", "permissionMode": "default", "sessionId": session_id}) + "\n")
        for ln in lines:
            fh.write(json.dumps(ln) + "\n")
        fh.write(json.dumps({"type": "last-prompt", "leafUuid": leaf, "sessionId": session_id}) + "\n")
    return out_path


# --- cli ---------------------------------------------------------------------


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("list", help="list conversations as JSON")
    cv = sub.add_parser("convert", help="download a conversation and write a CC transcript")
    cv.add_argument("--cwd", required=True, help="project dir the session should belong to")
    g = cv.add_mutually_exclusive_group(required=True)
    g.add_argument("--name", help="conversation title (exact, case-insensitive)")
    g.add_argument("--id", help="conversation uuid")
    cv.add_argument("--version", default=DEFAULT_VERSION, help="Claude Code version string to stamp")
    args = ap.parse_args()

    jar = _cookie_jar()
    org = _org(jar)

    if args.cmd == "list":
        convs = _list_conversations(jar, org)
        out = [{"uuid": c.get("uuid"), "name": c.get("name"), "updated_at": c.get("updated_at")} for c in convs]
        print(json.dumps(out, indent=2))
        return

    # convert
    cid = args.id
    source_name = None
    if not cid:
        convs = _list_conversations(jar, org)
        matches = [c for c in convs if (c.get("name") or "").strip().lower() == args.name.strip().lower()]
        if not matches:
            die(f"no conversation titled {args.name!r}; run `list` to see available titles")
        if len(matches) > 1:
            die(f"{len(matches)} conversations titled {args.name!r}; pass --id to disambiguate")
        cid = matches[0]["uuid"]
        source_name = matches[0].get("name")

    conv = _fetch_conversation(jar, org, cid)
    source_name = source_name or conv.get("name")
    cwd = os.path.abspath(os.path.expanduser(args.cwd))
    session_id, lines, leaf = convert(conv, cwd, args.version)
    out_path = write_session(session_id, lines, leaf, cwd)
    print(
        json.dumps(
            {
                "session_id": session_id,
                "out_path": out_path,
                "lines": len(lines),
                "source_name": source_name,
                "cwd": cwd,
            },
            indent=2,
        )
    )


if __name__ == "__main__":
    main()
