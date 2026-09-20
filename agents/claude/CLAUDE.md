# CLAUDE.md

## General rules

### Scope

Do the simplest thing that works.
Don't add features, refactor, or introduce abstractions beyond what the task requires: a bug fix doesn't need surrounding cleanup, and a one-shot operation usually doesn't need a helper.
Don't design for hypothetical future requirements.

Don't add error handling, fallbacks, or validation for scenarios that cannot happen.
Trust internal code and framework guarantees; validate at system boundaries only, meaning user input and external APIs.

**Assume clean installs and current callers.**
No backwards-compatibility shims, no feature flags, no migration paths for a state this code no longer produces.
Change the code instead.
If old state exists on a machine, clean the machine rather than teaching the code to tolerate it.

When I'm describing a problem, asking a question, or thinking out loud rather than asking for a change, the deliverable is your assessment.
Report what you found and stop.

### Delegation

Parallelize by default.
Any subtask that does not depend on another's output should run as a subagent while you keep working, and independent agents go out in one message so they actually run concurrently rather than in sequence.

Reach for this readily: fanning out a search across a codebase, reviewing several files at once, checking a claim from a fresh context, or running work that is slow but not on the critical path.
Prefer keeping a subagent alive across related subtasks over spawning a new one each time, and don't block waiting on one when there is other work to do.
Step in when a subagent goes off track or is missing context it needed.

For verification specifically, a subagent starting from a clean context beats self-critique, because it cannot inherit the assumption that produced the bug.

The exception is cost.
When I say to conserve usage, or to keep it cheap or light, do the work inline instead.

### Comments

Write for someone reading the file a year from now who has no idea it was ever changed.
A comment explains the code and the constraints it lives under, never the process that produced it.

Comment the non-obvious: a gotcha, an external constraint, a reason that code which looks wrong is actually required.
The test is whether a reader would otherwise "simplify" it and break something.

Never write a comment that:

- justifies a choice against alternatives that only ever existed in a
  conversation
- narrates the change or its history: "moved here", "now split so that",
  "deliberately", "this is intentional", "kept for..."
- explains why something is not somewhere else, or how the file is wired up
  elsewhere, unless editing this file would break that wiring
- restates what the code plainly says

Good, because it stops someone replacing the path with a bare command:

    # ProxyCommand inherits the PATH of whatever launched ssh, which for a GUI
    # editor may not include Homebrew.
    ProxyCommand /opt/homebrew/bin/cloudflared access ssh --hostname %h

Bad, because it is about a decision rather than the code:

    # The absolute path is deliberate. A bare `cloudflared` was considered but
    # this is safer, so it stays as it is.

Rationale, alternatives and history belong in the commit message instead.
Use ASCII punctuation only.

### Reporting

When I have not been watching, your final message is my first look at the work, so write it as a re-grounding rather than a continuation.
Drop the shorthand you built up while working: no arrow chains, no hyphen-stacked compounds, no labels you invented earlier.
Give each file, flag or commit its own plain clause.

## Specific rules

Checkable requirements rather than defaults to weigh against other considerations.
This is the last section; new rules are added as headings here.

### Markdown heading hierarchy

Exactly one `#` heading per file, and it comes first.
Every heading after it is at most one level deeper than the heading above it, so an `###` never follows an `#`.
When merging documents that each had their own `#`, the merged file keeps one title and the rest become `##`.

### Never hand me a command to run

Run it yourself.
Do not print a command for me to copy, and do not put one on my clipboard.

The sole exception is a command that cannot be driven from your side because the terminal needs me: an interactive prompt, a passphrase, a hardware key, a browser step only I can complete.
Run those the way I would from my own terminal, so the browser opens on my machine; never switch to device-code or no-browser modes that leave me waiting on you.
Background the command, and ask me only for the code, approval or secret it needs.

When you judge that you should not run something, say that you did not run it and why, then offer to run it on my go-ahead.
That is a sentence, not a command block.
Waiting on my answer is the cost of that judgement, and it is cheaper than me finding the command in your reply and running it blind.

### Stacked pull requests

If you are going to make a stacked pull request, use `spr` rather than hand-managed branches.
It submits one pull request per commit, so a stack is a run of commits on one branch: amend a commit and `spr diff` updates only that pull request, and `spr land` merges the bottom of the stack.

A commit that deletes something belongs above the commit that replaces it, never below.
Rebasing a stack can otherwise land a removal while its replacement is still in review.

`bin/spr` wraps the Homebrew binary to supply the GitHub token, reading it from gh's keychain per call rather than from git config, because every git config file on this machine is a symlink into this repo and would commit the secret.
It supplies one only when nothing else does, so an explicit flag or a repo-level setting still wins.
Everything else is spr's own behaviour.
The non-secret settings `spr.branchPrefix`, `spr.githubRepository` and `spr.githubMasterBranch` live in each repository's `.git/config`, which git never tracks.

### Line breaks in prose

In Markdown and LaTeX files, start each sentence of prose on a new line, and never wrap a sentence across lines.
A sentence stays on one line however long it is, so a diff of an edited sentence touches only that line.
This covers prose only; code blocks, tables, lists and LaTeX environments keep the layout their syntax needs.
