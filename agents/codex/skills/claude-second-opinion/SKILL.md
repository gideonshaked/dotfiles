---
name: claude-second-opinion
description: "Ask Claude to audit Codex's work. Use when the user wants a second opinion, Claude audit, independent review, or a check of Codex changes."
metadata:
  short-description: Ask Claude to audit Codex work
---

# Claude Second Opinion

Invokes Claude in a constrained, read-only audit mode to look for bugs, dead code, tech debt, and architectural errors.

## Steps

1. Resolve the `claude-audit` helper next to this `SKILL.md`.

2. Run it with the user's focus text, file path, or no argument:

   ```bash
   ./claude-audit <focus-or-path>
   ```

3. Print the full output directly for the user. Do not soften, summarize away, or reinterpret the findings.

## Notes

- If the argument is a file or directory, the helper scopes the audit there.
- If the argument is plain text, the helper treats it as the review category.
- If there is no argument, the helper performs a broad codebase audit.
