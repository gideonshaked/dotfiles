# Comments

Write for someone reading the file a year from now who has no idea it was ever
changed. A comment explains the code and the constraints it lives under, never
the process that produced it.

Comment the non-obvious: a gotcha, an external constraint, a reason that code
which looks wrong is actually required. The test is whether a reader would
otherwise "simplify" it and break something.

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

The same applies to commit messages in reverse: rationale, alternatives, and
history belong there, not in the file.
