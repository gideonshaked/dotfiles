import importlib.util
import json
import subprocess
import sys
from importlib.machinery import SourceFileLoader
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
SCRIPT = REPO_ROOT / "bin" / "agent-session-bridge"


def load_bridge():
    loader = SourceFileLoader("agent_session_bridge", str(SCRIPT))
    spec = importlib.util.spec_from_loader("agent_session_bridge", loader)
    assert spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def write_jsonl(path, rows):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as f:
        for row in rows:
            f.write(json.dumps(row) + "\n")


def read_jsonl(path):
    return [json.loads(line) for line in path.read_text(encoding="utf-8").splitlines()]


def test_codex_to_claude_writes_scrollback_session(tmp_path, monkeypatch):
    monkeypatch.setenv("HOME", str(tmp_path))
    bridge = load_bridge()
    source = tmp_path / "rollout.jsonl"
    write_jsonl(
        source,
        [
            {
                "type": "session_meta",
                "payload": {
                    "id": "codex-session",
                    "timestamp": "2026-07-05T01:02:03.000Z",
                    "cwd": "/tmp/project",
                },
            },
            {
                "type": "response_item",
                "payload": {
                    "type": "message",
                    "role": "user",
                    "content": [{"type": "input_text", "text": "Build the thing with sk-testSECRET1234567890"}],
                },
            },
            {
                "type": "response_item",
                "payload": {
                    "type": "message",
                    "role": "assistant",
                    "content": [{"type": "output_text", "text": "Done."}],
                },
            },
        ],
    )

    result = bridge.codex_to_claude(
        source=source,
        cwd="/tmp/project",
        home=tmp_path,
        model="claude-opus-4-8",
        title="Imported Codex session",
        update_state=True,
    )

    rows = read_jsonl(Path(result["out_path"]))
    assert [row["type"] for row in rows[:4]] == ["custom-title", "agent-name", "mode", "permission-mode"]
    user_rows = [row for row in rows if row.get("type") == "user"]
    assistant_rows = [row for row in rows if row.get("type") == "assistant"]
    assert len(user_rows) == 1
    assert len(assistant_rows) == 1
    assert "[REDACTED_SECRET]" in user_rows[0]["message"]["content"]
    assert assistant_rows[0]["message"]["model"] == "claude-opus-4-8"
    assert assistant_rows[0]["parentUuid"] == user_rows[0]["uuid"]
    assert rows[-1]["type"] == "last-prompt"
    assert rows[-1]["leafUuid"] == assistant_rows[0]["uuid"]
    claude_state = json.loads((tmp_path / ".claude.json").read_text())
    assert claude_state["projects"]["/tmp/project"]["lastSessionId"] == result["session_id"]


def test_claude_to_codex_writes_rollout_session(tmp_path, monkeypatch):
    monkeypatch.setenv("HOME", str(tmp_path))
    bridge = load_bridge()
    source = tmp_path / ".claude" / "projects" / "-tmp-project" / "source.jsonl"
    write_jsonl(
        source,
        [
            {"type": "custom-title", "customTitle": "Claude source", "sessionId": "claude-source"},
            {
                "type": "user",
                "uuid": "u1",
                "parentUuid": None,
                "message": {"role": "user", "content": "Please continue"},
                "timestamp": "2026-07-05T02:00:00.000Z",
                "cwd": "/tmp/project",
                "sessionId": "claude-source",
            },
            {
                "type": "assistant",
                "uuid": "a1",
                "parentUuid": "u1",
                "message": {
                    "role": "assistant",
                    "model": "claude-opus-4-8",
                    "content": [{"type": "text", "text": "Continuing."}],
                },
                "timestamp": "2026-07-05T02:00:01.000Z",
                "cwd": "/tmp/project",
                "sessionId": "claude-source",
            },
        ],
    )

    result = bridge.claude_to_codex(
        source=source,
        cwd="/tmp/project",
        home=tmp_path,
        model="gpt-5.5",
        update_state=False,
    )

    rows = read_jsonl(Path(result["out_path"]))
    assert rows[0]["type"] == "session_meta"
    assert rows[0]["payload"]["cwd"] == "/tmp/project"
    message_rows = [row["payload"] for row in rows if row.get("type") == "response_item"]
    assert message_rows[0]["role"] == "user"
    assert message_rows[0]["content"][0]["text"] == "Please continue"
    assert message_rows[1]["role"] == "assistant"
    assert message_rows[1]["content"][0]["text"] == "Continuing."
    assert rows[1]["type"] == "turn_context"
    assert rows[1]["payload"]["model"] == "gpt-5.5"


def test_cli_inspect_reports_format(tmp_path):
    source = tmp_path / "claude.jsonl"
    write_jsonl(
        source,
        [
            {"type": "user", "message": {"role": "user", "content": "hello"}},
            {"type": "assistant", "message": {"role": "assistant", "content": [{"type": "text", "text": "hi"}]}},
        ],
    )

    completed = subprocess.run(
        [sys.executable, str(SCRIPT), "inspect", "--source", str(source)],
        check=True,
        capture_output=True,
        text=True,
    )

    payload = json.loads(completed.stdout)
    assert payload["format"] == "claude"
    assert payload["roles"] == {"assistant": 1, "user": 1}
