---
name: ssh
description: "Use when a task involves SSH or a remote host, including remote commands, interactive shells, sudo over SSH, tailing logs, deployments, scp or rsync file transfer, and port forwards or tunnels."
---

# ssh

## Overview

The `ssh-mcp` server drives the local OpenSSH client (`ssh`, `scp`, and `rsync`) so Codex can operate a remote host the way a person at a terminal would: persistent shells, real PTY prompts, and proper file transfer. Prefer the `mcp__ssh_mcp__*` tools over running `ssh` inside `exec_command`. Raw `ssh host "cmd"` in the shell is one-shot and has no PTY, so it breaks on sudo prompts, REPLs, TUIs, and anything that needs state carried between commands.

## Why this beats shell ssh

Each `ssh host "cmd"` in the shell is a fresh, non-interactive login with no terminal. That is why it keeps failing, and why these tools are worth reaching for.

- Interactive prompts actually work. A real PTY means `sudo` password prompts, confirmation prompts, and full-screen TUIs (`top`, `vim`, an installer) behave like a human is typing. In shell commands they hang or error.
- State persists across steps. A session keeps the shell alive, so `cd`, exported vars, an activated venv, a `sudo -i` shell, or a `docker exec` you entered all carry into the next command. One-shot shell SSH resets every time, forcing brittle one-liners.
- Long jobs survive. Kick off a build or deploy, then poll the screen. The job keeps running even if the agent's context resets. Shell SSH blocks or drops the process.
- File transfer actually works. `scp` and `rsync` move real bytes, including binary-safe large files, whole trees, incremental transfers, and resumable transfers. Pushing a file through `cat` or `tee` over a terminal mangles binary, truncates on scrollback, and corrupts long lines.
- Sessions are recoverable by name. A `session_name` lets a later step, or a different agent, find the same live shell by name after a context reset instead of reconnecting from scratch.
- The user can watch. Every session records a transcript and opens a tmux window, so the human can attach and see exactly what the agent is doing on the box, or take the keyboard.
- Existing SSH setup is respected. Host aliases, `ProxyJump`, custom ports, keys, and agent forwarding from `~/.ssh/config` all work.

Net effect. Codex operates the remote host like a person at a terminal, instead of firing blind one-shot commands and failing when something is interactive or stateful.

## Use Cases

Use for any task that touches a remote host over SSH.

- Running a command on a server, such as `df -h`, `systemctl status`, or a one-off grep.
- An interactive or multi-step remote shell, such as `sudo` with a password prompt, a REPL, `cd` then act, editing then reloading a service.
- Watching a long-running remote job, such as a build, deploy, migration, or `tail -f`.
- Moving files to or from a host with scp or rsync.
- Reaching a service through a host, or exposing a local one, via a port forward or tunnel.
- Deploying to, provisioning, or debugging a remote machine.

Do not use for these cases.

- Local-only shell work. Use `exec_command` directly.
- A remote action that already has a dedicated tool or API, such as a cloud provider CLI or managed deploy command. Prefer that over raw SSH.

## Load the Tools First

The `mcp__ssh_mcp__*` tools may be deferred. If they are not already callable, load them once with `tool_search` before use. Search for this query.

```
ssh-mcp ssh_exec ssh_ensure_session ssh_write_session ssh_read_session ssh_scp ssh_sync ssh_forward
```

If none of the `mcp__ssh_mcp__*` tools exist at all, the server is not installed or Codex needs to restart after the MCP config change. Fall back to `exec_command` only when necessary, and tell the user.

## Pick the right mode

| The task is... | Use | Why |
|---|---|---|
| A single read-only check (`df -h`, `uptime`, one grep) | `mcp__ssh_mcp__ssh_exec` | One command in, output plus exit code out. No state needed. |
| Multiple steps that share state, or anything interactive (`sudo` password, a REPL, `cd` then act, watching a long job) | `mcp__ssh_mcp__ssh_ensure_session` plus `mcp__ssh_mcp__ssh_write_session` plus `mcp__ssh_mcp__ssh_read_session` | A persistent PTY shell. State and connection are shared across calls. |
| Moving files as files, especially binary, large, many, or needs integrity | `mcp__ssh_mcp__ssh_scp` for copy or `mcp__ssh_mcp__ssh_sync` for incremental rsync | Real transfer, binary-safe, resumable. |
| Reaching a service through the host, or exposing one | `mcp__ssh_mcp__ssh_forward` | Local or remote port tunnel. |

Default reflex to avoid. Do not chain a multi-step or interactive task into one giant `ssh_exec`. If step N depends on step N-1's state, or any step prompts, use a session.

## Sessions

- Start with `ssh_ensure_session(target, session_name)`. It is idempotent, so call it at the start of each step to start or reuse. Always give a descriptive `session_name`, such as `deploy-api`, so the session survives context resets and is recoverable by name.
- `ssh_write_session(session_id, input, wait_seconds)` types `input` into the pane, so include a trailing `\n` to press Enter. Use `\u0003` for Ctrl-C, `\u0004` for Ctrl-D, and `\u001a` for Ctrl-Z. Raise `wait_seconds` for slow commands like installs and builds.
- `ssh_read_session(session_id, wait_seconds)` returns session output. Check `pending_output_chars` in the response. If it is non-zero, call again to drain the buffer before deciding what to do next.
- `cwd`, `env`, and `shell` only apply when a session is created. They are ignored on reuse.
- Do not `ssh_stop_session` while a long job is running in it. That kills the job. Leave it open and poll with `ssh_read_session`.
- Use `ssh_list_sessions` to recover a named session if the context changed.

## One-Off Commands

Use `ssh_exec(target, command)` for a single command. Set `tty: true` when the command needs a terminal, such as `sudo` with a password prompt. Note that `tty` merges stdout and stderr. `cwd` and `env` are available.

## File Transfer

- `ssh_scp(target, direction, sources, destination)`: `direction` is `upload` or `download`. Put the host only in `target`, never in the paths. For `upload`, `sources` are local. For `download`, they are remote.
- `ssh_sync(target, direction, source, destination, delete, exclude)`: incremental rsync. Supports `delete: true` and `exclude: ["*.log", ".git"]`.
- Prefer these over reading or writing files by piping `cat` or `tee` through a session. The PTY path mangles binary data, truncates on scrollback limits, and corrupts long lines. Only fall back to in-session `cat` or `tee` when the file is reachable only inside the session's live context, such as after `sudo -i`, inside a `docker exec`, or past a nested hop where a fresh scp connection cannot reach.

## Port Forwarding

Use `ssh_forward(target, direction, local_port, remote_host, remote_port)`. `direction` `local` makes a remote service reachable on your machine. `direction` `remote` exposes a local service on the host. Binds to `127.0.0.1` unless you set `bind_address: "0.0.0.0"`. Manage with `ssh_list_forwards` and `ssh_stop_forward`.

## Non-Interactive Auth Is Required

The server shells out to local `ssh`, so anything that would make `ssh host` prompt for a password can hang the tool call. It uses `~/.ssh/config`, so aliases, `ProxyJump`, custom ports, and `SSH_AUTH_SOCK` all work. If a connection hangs or exits 255, suspect auth. The key may not be loaded with `ssh-add`, key auth may not be set up, or the host alias may be missing. Do not retry blindly. Surface it.

## Watching What Codex Does

Every session records a transcript to `~/.local/state/ssh-mcp/<session_id>/transcript.log`, and by default launches a detached tmux window named like `ssh-mcp-<target>-<session_name>`. The user can watch live with `tmux attach -t <that name>`. If tmux is not installed, pass `observer_mode: "transcript"` and tail the log instead.

## Common Mistakes

- Cramming interactive or stateful work into one `ssh_exec`. Use a session.
- Forgetting the trailing `\n` in `ssh_write_session` input, so the command never runs.
- Reading a session once and acting on partial output. Drain `pending_output_chars` first.
- Smuggling a binary or large file through `cat` or `tee`. Use `ssh_scp` or `ssh_sync`.
- Treating a hung connection as a code problem. It is usually interactive auth.
- Killing a session that still has a job running in it.
