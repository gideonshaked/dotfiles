---
name: ssh
description: "Operate remote hosts over SSH through the ssh-mcp server, driving a box like a person at a terminal instead of firing blind one-off commands."
when_to_use: "Use when a task involves SSH or a remote host: ssh into a server, run remote commands, an interactive remote shell, sudo over SSH, tailing remote logs, deploying, copying files with scp/rsync, or setting up a port forward/tunnel."
---

# ssh

## Overview

The `ssh-mcp` server drives your local OpenSSH client (`ssh`/`scp`/`rsync`) so an agent can operate a remote host the way a person at a terminal would: persistent shells, real PTY prompts, and proper file transfer. Prefer its `mcp__ssh-mcp__*` tools over running `ssh` inside the Bash tool. Raw `ssh host "cmd"` in Bash is one-shot and has no PTY, so it breaks on sudo prompts, REPLs, TUIs, and anything that needs state carried between commands.

## Why this beats Bash ssh

Each `ssh host "cmd"` in Bash is a fresh, non-interactive login with no terminal. That is why it keeps failing, and why these tools are worth reaching for:

- **Interactive prompts actually work.** A real PTY means `sudo` password prompts, confirmation prompts, and full-screen TUIs (`top`, `vim`, an installer) behave like a human is typing. In Bash they hang or error.
- **State persists across steps.** A session keeps the shell alive, so `cd`, exported vars, an activated venv, a `sudo -i` shell, or a `docker exec` you entered all carry into the next command. One-shot Bash resets every time, forcing brittle one-liners.
- **Long jobs survive.** Kick off a build or deploy, then poll the screen. The job keeps running even if the agent's context resets. Bash blocks or drops the process.
- **File transfer that actually works.** `scp`/`rsync` move real bytes: binary-safe, large files, whole trees, incremental and resumable. Pushing a file through `cat`/`tee` over a terminal mangles binary, truncates on scrollback, and corrupts long lines.
- **Recoverable, named sessions.** A `session_name` lets a later step, or a different agent, find the same live shell by name after a context reset instead of reconnecting from scratch.
- **You can watch.** Every session records a transcript and opens a tmux window, so the human can attach and see exactly what the agent is doing on the box, or take the keyboard.
- **Uses your existing SSH setup.** Host aliases, `ProxyJump`, custom ports, keys, and agent forwarding from `~/.ssh/config` all just work. No re-specifying connection details.

Net effect: the agent operates the remote host like a person at a terminal, instead of firing blind one-shot commands and failing the moment something is interactive or stateful.

## When to use

Use for any task that touches a remote host over SSH:

- Running a command on a server (`df -h`, `systemctl status`, a one-off grep)
- An interactive or multi-step remote shell: `sudo` with a password prompt, a REPL, `cd` then act, editing then reloading a service
- Watching a long-running remote job (build, deploy, migration, `tail -f`)
- Moving files to or from a host with scp or rsync
- Reaching a service through a host, or exposing a local one, via a port forward or tunnel
- Deploying to, provisioning, or debugging a remote machine

Do NOT use for:

- Local-only shell work (use Bash directly)
- A remote action that already has a dedicated tool or API (a cloud provider CLI, a managed deploy command); prefer that over raw SSH

## First: make the tools loadable

The `mcp__ssh-mcp__*` tools may be deferred (name-only until loaded). If they are not already callable, load them once with ToolSearch before use:

```
select:mcp__ssh-mcp__ssh_exec,mcp__ssh-mcp__ssh_ensure_session,mcp__ssh-mcp__ssh_write_session,mcp__ssh-mcp__ssh_read_session,mcp__ssh-mcp__ssh_scp,mcp__ssh-mcp__ssh_sync,mcp__ssh-mcp__ssh_forward
```

If none of the `mcp__ssh-mcp__*` tools exist at all, the server is not installed; fall back to Bash and tell the user.

## Pick the right mode

| The task is... | Use | Why |
|---|---|---|
| A single read-only check (`df -h`, `uptime`, one grep) | `ssh_exec` | One command in, output + exit code out. No state needed. |
| Multiple steps that share state, OR anything interactive (sudo password, a REPL, `cd` then act, watching a long job) | `ssh_ensure_session` + `ssh_write_session` + `ssh_read_session` | A persistent PTY shell. State and connection are shared across calls. |
| Moving files as files (binary, large, many, or needs integrity) | `ssh_scp` (copy) or `ssh_sync` (incremental rsync) | Real transfer, binary-safe, resumable. |
| Reaching a service through the host, or exposing one | `ssh_forward` | Local or remote port tunnel. |

Default reflex to avoid: do NOT chain a multi-step or interactive task into one giant `ssh_exec`. If step N depends on step N-1's state, or any step prompts, use a session.

## Sessions

- Start with `ssh_ensure_session(target, session_name)`. It is idempotent: call it at the start of each step to start-or-reuse. Always give a descriptive `session_name` (e.g. `deploy-api`) so the session survives context resets and is recoverable by name.
- `ssh_write_session(session_id, input, wait_seconds)`: `input` is typed into the pane, so include a trailing `\n` to press Enter. Use `\u0003` for Ctrl-C, `\u0004` for Ctrl-D. Raise `wait_seconds` for slow commands (installs, builds).
- `ssh_read_session(session_id, wait_seconds)`: check `pending_output_chars` in the response; if non-zero, call again to drain the buffer before deciding what to do next.
- `cwd`/`env`/`shell` only apply when a session is created; they are ignored on reuse.
- Do NOT `ssh_stop_session` while a long job is running in it; that kills the job. Leave it open and poll with `ssh_read_session`.

## One-off commands

`ssh_exec(target, command)`. Set `tty: true` when the command needs a terminal (e.g. `sudo` with a password prompt); note `tty` merges stdout and stderr. `cwd` and `env` are available.

## File transfer

- `ssh_scp(target, direction, sources, destination)`: `direction` is `upload` or `download`. Put the host only in `target`, never in the paths. For `upload`, `sources` are local; for `download`, they are remote.
- `ssh_sync(target, direction, source, destination, delete, exclude)`: incremental rsync. Supports `delete: true` and `exclude: ["*.log", ".git"]`.
- Prefer these over reading/writing files by piping `cat`/`tee` through a session. The PTY path mangles binary data, truncates on scrollback limits, and corrupts long lines. Only fall back to in-session `cat`/`tee` when the file is reachable ONLY inside the session's live context (e.g. after `sudo -i`, inside a `docker exec`, or past a nested hop) where a fresh scp connection cannot reach.

## Port forwarding

`ssh_forward(target, direction, local_port, remote_host, remote_port)`. `direction` `local` makes a remote service reachable on your machine; `remote` exposes a local service on the host. Binds to `127.0.0.1` unless you set `bind_address: "0.0.0.0"`. Manage with `ssh_list_forwards` and `ssh_stop_forward`.

## Non-interactive auth is required

The server shells out to your local `ssh`, so anything that would make `ssh host` prompt for a password will HANG the tool call. It uses `~/.ssh/config`, so aliases, `ProxyJump`, custom ports, and `SSH_AUTH_SOCK` all work. If a connection hangs or exits 255, suspect auth: the key isn't loaded (`ssh-add`) or key auth isn't set up. Do not retry blindly; surface it.

## Watching what the agent does

Every session records a transcript to `~/.local/state/ssh-mcp/<session_id>/transcript.log`, and by default launches a detached tmux window `ssh-mcp-<target>-<session_name>`. The user can watch live with `tmux attach -t <that name>`. If tmux isn't installed, pass `observer_mode: "transcript"` and tail the log instead.

## Common mistakes

- Cramming interactive or stateful work into one `ssh_exec`. Use a session.
- Forgetting the trailing `\n` in `ssh_write_session` input, so the command never runs.
- Reading a session once and acting on partial output; drain `pending_output_chars` first.
- Smuggling a binary or large file through `cat`/`tee`. Use `ssh_scp`/`ssh_sync`.
- Treating a hung connection as a code problem; it's almost always interactive auth.
- Killing a session that still has a job running in it.
