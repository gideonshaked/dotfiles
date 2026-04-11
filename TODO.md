# TODO

## Open

- [ ] **Parallel Claude worktree dispatcher.** A script (probably in `bin/`) that takes a set of issues, creates git worktrees for each group, writes task files, and launches parallel Claude sessions in Kitty tabs/windows. Should replace the manual process of: grouping bugs, creating worktrees, writing metaprompt files, and pasting `claude -p` into each terminal.

  **Requirements:**
  - **Issue ingestion:** Accept issues from multiple sources -- a TODO.md file (parse checkboxes), a JSON/YAML file, inline args, or piped stdin. Each issue needs at minimum a title and optional body/context. The script groups them (manually or by tag) into worktrees.
  - **Worktree creation:** For each group, create a git worktree at a configurable sibling path (`../<repo>-<name>`), branch from current HEAD, and write a `<name>_WORKTREE_TASKS.md` with the issues and a configurable metaprompt (instructions for how Claude should work through the bugs).
  - **Kitty integration:** Use `kitty @ launch` or `kitten` to open a new tab/window per worktree, `cd` into it, and run the `claude -p` command. Should be able to tile them or use Kitty's tab bar so all sessions are visible. Bonus: name each tab after the worktree.
  - **Metaprompt templating:** The general instructions block (read the task file, read CLAUDE.md, fix each bug, run tests, commit) should be a configurable template, not hardcoded. Could live in `~/.claude/` or in the repo's CLAUDE.md. The template should support variables like `{test_command}` (e.g. `make test`), `{task_file}`, etc.
  - **Merge-back helper:** After all sessions finish, a command to merge each worktree branch back into main (or at least report status: which branches have commits, which are clean, which have conflicts).
  - **Conflict avoidance:** When grouping issues, warn if two groups touch the same files (based on test file paths or source file mentions in the issue text). This is the hardest part to automate well.

  **Non-requirements (keep it simple):**
  - No daemon, no server, no web UI. Just a CLI script.
  - No automatic issue grouping by AI. The user specifies groups, or each issue gets its own worktree.
  - No progress monitoring. The user watches the Kitty tabs.

  **Prior art / references:**
  - Current manual workflow is documented in the genomicsbench repo session history.
  - Kitty remote control: https://sw.kovidgoyal.net/kitty/remote-control/
  - `git worktree` docs: https://git-scm.com/docs/git-worktree
