---
name: import-claude-session
description: "Import a claude.ai / Claude Desktop conversation as a resumable Claude Code session transcript."
when_to_use: "Use when the user wants to bring a Claude Desktop or claude.ai chat into Claude Code, convert/export a conversation into a .jsonl session, or resume a web/desktop chat from the CLI."
argument-hint: "[conversation name] [target project dir]"
allowed-tools:
  - Bash
effort: medium
---

# Import Claude Session

Pulls a conversation out of the Claude Desktop app (claude.ai) and writes it as a Claude Code `.jsonl` transcript so it appears in `claude --resume` for a chosen project directory.

The conversation content is **not** on disk. The desktop app only caches config locally; messages live on claude.ai's servers. The `claude_session_to_cc.py` script in this skill directory does all the deterministic work: it reads the desktop app's `sessionKey` cookie from the local Cookies store, decrypts it with the macOS Keychain key `Claude Safe Storage`, calls the claude.ai API to download the conversation, and converts it to the CC transcript format. Your job is to get the conversation name and target dir from the user, run the script, and report the result.

macOS only. The first run may surface a Keychain prompt the user must approve.

## How the format maps

claude.ai stores one record per turn with a `content` array of blocks. Claude Code records **one parentUuid-chained line per block**. The script applies this mapping:

| claude.ai block | Claude Code line |
|---|---|
| human message | `user` line, `message.content` = string |
| assistant `thinking` | `assistant` line, one thinking block |
| assistant `text` | `assistant` line, one text block |
| assistant `tool_use` | `assistant` line, one tool_use block |
| `tool_result` | `user` line with `tool_result` + `toolUseResult` |

All blocks from one assistant turn share a generated `message.id`. The file lands in `~/.claude/projects/<cwd-with-slashes-as-dashes>/<session-id>.jsonl`, so `cwd` determines which project's resume list shows it.

## Steps

### 1. Get the conversation name and target dir

Ask the user which conversation (by title) and which project directory the session should belong to, unless they already said. The dir sets the `cwd` stamped in every line and the project folder the file lands in.

### 2. Find the conversation

Run: `${CLAUDE_SKILL_DIR}/claude_session_to_cc.py list`

It prints `[{uuid, name, updated_at}]` as JSON. Confirm the exact title with the user if there's no clean match. If a Keychain prompt appears, tell the user to approve it.

### 3. Convert

Run: `${CLAUDE_SKILL_DIR}/claude_session_to_cc.py convert --name "<title>" --cwd "<project dir>"`

Use `--id <uuid>` instead of `--name` if titles collide. The script prints `{session_id, out_path, lines, source_name, cwd}`.

### 4. Verify and report

Confirm the transcript is well-formed before claiming success:

  `python3 -c "import json; ls=[json.loads(l) for l in open('<out_path>')]; print(len(ls),'lines ok')"`

Tell the user the `out_path` and how to open it: `cd <cwd> && claude --resume`, then pick the session (it shows the conversation's first prompt).

## Rules

- **Never claim the content is on disk.** It is fetched from claude.ai every time; the local files only hold the auth cookie.
- **The decrypted `sessionKey` is a live credential.** Do not print it, echo it, or write it anywhere. The script never emits it.
- **Stub fields are stubs.** Token/usage counts are zeroed (claude.ai exposes no per-turn usage) and `web_search` results are flattened to title+URL lists. State this if the user asks about fidelity; do not present them as real.
- **Attachments are folded into the human message text** (pasted files inline, images as a `[Attached image: ...]` note). Binary image bytes are not downloaded.
- **Don't fabricate a conversation.** If `list` shows no match, report that and show the available titles rather than guessing a uuid.
- **macOS only.** If the Cookies db or Keychain item is missing, report it plainly; do not invent another extraction path.
