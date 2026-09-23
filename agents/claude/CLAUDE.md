# CLAUDE.md

## Minimal solutions

Do the simplest thing that works.
Don't add features, refactor, or introduce abstractions beyond what the task requires: a bug fix doesn't need surrounding cleanup, and a one-shot operation usually doesn't need a helper.
Don't design for hypothetical future requirements.

## No defensive code

Don't add error handling, fallbacks, or validation for scenarios that cannot happen.
Trust internal code and framework guarantees; validate at system boundaries only, meaning user input and external APIs.

## Backwards compatibility

**Assume clean installs and current callers.**
No backwards-compatibility shims, no feature flags, no migration paths for a state this code no longer produces.
Change the code instead.
If old state exists on a machine, clean the machine rather than teaching the code to tolerate it.

## Questions and thinking out loud

When I'm describing a problem, asking a question, or thinking out loud rather than asking for a change, the deliverable is your assessment.
Report what you found and stop.

## Delegation

Parallelize by default.
Any subtask that does not depend on another's output should run as a subagent while you keep working, and independent agents go out in one message so they actually run concurrently rather than in sequence.

Reach for this readily: fanning out a search across a codebase, reviewing several files at once, checking a claim from a fresh context, or running work that is slow but not on the critical path.
Prefer keeping a subagent alive across related subtasks over spawning a new one each time, and don't block waiting on one when there is other work to do.
Step in when a subagent goes off track or is missing context it needed.

For verification specifically, a subagent starting from a clean context beats self-critique, because it cannot inherit the assumption that produced the bug.

The exception is cost.
When I say to conserve usage, or to keep it cheap or light, do the work inline instead.

## Asking the advisor

Ask sparingly, and never as the opening move of a conversation.
Reaching for a second model before you have done anything is the pattern I want gone: there is no result to judge yet, so the answer is generic and the call buys nothing.

Ask once you have done the work and are unsure of the result, and only when the doubt is specific enough to state in a sentence.
The strongest case is significance: whether a finding is real, whether an effect is large enough to matter, whether the analysis actually supports the claim I would draw from it.
A judgement call between two defensible options, where you have laid both out and cannot break the tie, is the other good case.

Do not ask for permission, for approval of a plan, or to confirm a choice you are already confident in.
The reply is one opinion; evidence you have gathered yourself outranks it.

## Comments

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

Use ASCII punctuation only.

## Documentation

Documentation describes the system as it stands, not how it came to stand that way.
Someone who has never seen the repository should finish knowing what exists, where it lives, and which constraints shaped it.
Someone who watched every change should find nothing in it about the changes.

Write down what reading the code cannot recover: why a tool is required, what breaks if two steps are reordered, which external limit a workaround exists for.
Leave out what a listing, a type signature or a `--help` already says, and never keep a second copy of something the code owns, because the copy drifts and the reader cannot tell which one is lying.

Revise the sentence that is now wrong rather than appending one that supersedes it.
No "as of", no "note that this changed", no section recording what the documentation used to say.

## Pull requests

Always open a draft PR for me to review before making it live: wait for my confirmation to make it live.
For PR messages, they should be at absolute maximum 2 paragraphs.
You should write the message assuming that the person reading it is unfamiliar with the PR.

Title it with the ticket id (if the work is based on a linear ticket, then always put that in so Linear links to it), a colon, and what the change does, as in `DS-2892: Serve the OCTOMIND knowledge base MCP through Unity Catalog`.
The title says what the reader gets, never which files were touched.

The first paragraph is what the change adds and the constraint that forced it, written in the present tense as the system will behave once this lands.
Put a decision a reader would otherwise question into that paragraph as a clause carrying its reason: why a name was chosen, what a later change can swap out without coming back here, what a placeholder is waiting on.
A second paragraph earns its place only when something outside this PR is involved: a change that has to land before or after it, a leftover that still needs cleaning up, a deploy that will carry more than this commit.

If there were live integration tests run, put a short paragraph in at the bottom with the contents of those tests.
This should explicitly disinclude tests that are shipped with the code, and it should only describe tests that you ran live in-session so that someone reading the PR can be assured that such testing was done.

## Where writing belongs

Each destination takes what only it can hold, so put a fact in the narrowest place a reader will be standing when they need it.

- A comment takes a constraint on the lines beside it, and only where the code cannot show it itself.
- Documentation takes the shape of the system: what the pieces are, how they fit, which invariants hold across files.
- The commit message takes rationale, alternatives and history, meaning the reasoning for this change against whatever it replaced.
- A repository's `CLAUDE.md` should include the history of your decisions and rationale and so on. 
  - Basically as a rule, put something in the repo `CLAUDE.md` if, absent the guidelines in this global `CLAUDE.md`, you would have put that information in comments, documentation, or commit/PR messages instead.

## Reporting after unattended work

When I have not been watching, your final message is my first look at the work, so write it as a re-grounding rather than a continuation.
Drop the shorthand you built up while working: no arrow chains, no hyphen-stacked compounds, no labels you invented earlier.
Give each file, flag or commit its own plain clause.

## Markdown heading hierarchy

Exactly one `#` heading per file, and it comes first.
Every heading after it is at most one level deeper than the heading above it, so an `###` never follows an `#`.
When merging documents that each had their own `#`, the merged file keeps one title and the rest become `##`.

## Line breaks in prose

In Markdown and LaTeX files, start each sentence of prose on a new line, and never wrap a sentence across lines.
A sentence stays on one line however long it is, so a diff of an edited sentence touches only that line.
This covers prose only; code blocks, tables, lists and LaTeX environments keep the layout their syntax needs.

## Never hand me a command to run

Run it yourself.
Unless I ask for a command, do not print one for me to copy, and do not put one on my clipboard.
When I do ask for one, give it, copy it to my clipboard with `pbcopy` without being asked, and tell me you did.

The sole exception is a command that cannot be driven from your side because the terminal needs me: an interactive prompt, a passphrase, a hardware key, a browser step only I can complete.
Run those the way I would from my own terminal, so the browser opens on my machine; never switch to device-code or no-browser modes that leave me waiting on you.
Background the command, and ask me only for the code, approval or secret it needs.

When you judge that you should not run something, say that you did not run it and why, then offer to run it on my go-ahead.
That is a sentence, not a command block.
Waiting on my answer is the cost of that judgement, and it is cheaper than me finding the command in your reply and running it blind.

## Stacked pull requests

If you are going to make a stacked pull request, use `spr` rather than hand-managed branches.
It submits one pull request per commit, so a stack is a run of commits on one branch: amend a commit and `spr diff` updates only that pull request, and `spr land` merges the bottom of the stack.

A commit that deletes something belongs above the commit that replaces it, never below.
Rebasing a stack can otherwise land a removal while its replacement is still in review.

`bin/spr` wraps the Homebrew binary to supply the GitHub token, reading it from gh's keychain per call rather than from git config, because every git config file on this machine is a symlink into this repo and would commit the secret.
It supplies one only when nothing else does, so an explicit flag or a repo-level setting still wins.
Everything else is spr's own behaviour.
The non-secret settings `spr.branchPrefix`, `spr.githubRepository` and `spr.githubMasterBranch` live in each repository's `.git/config`, which git never tracks.
