# Correction-mining pipeline

Turns Claude Code session transcripts into a corpus of the human's
corrections, clusters them into standing rules, and feeds the skill in the
parent directory. Stages 1, 2a, 3, 4a and 5 are scripts. Stages 2b and 4b are
model passes run as subagents with the prompt files here.

| Stage | File | In | Out |
|---|---|---|---|
| 1 extract | extract.py | session .jsonl files | turns.jsonl (human turns with the assistant text and last edit they react to) |
| 2a chunk | chunk.py | turns.jsonl | chunks/chunk_NN.jsonl |
| 2b label | LABELER_PROMPT.md, LABEL_SCHEMA.md | one chunk per subagent | labels/chunk_NN.jsonl |
| 3 aggregate | aggregate.py | turns.jsonl, labels/ | corrections.jsonl (validated, cross-session duplicates dropped) |
| 4a split | split_domain.py | corrections.jsonl | by_domain/{prose,figure,analysis,ops,other}.jsonl and *_rules.txt |
| 4b cluster | SYNTHESIS_PROMPT.md | by_domain/*_rules.txt | themes.json, themes_figure.json, themes_analysis.json |
| 5 report | report.py | corrections.jsonl, themes*.json | report.md |

run.sh runs stages 1 and 2a and prints the commands for 3 to 5. To re-run on
new sessions, change the paths in run.sh, launch one labeler per chunk with
LABELER_PROMPT.md (replace NN), then one clustering agent per domain with
SYNTHESIS_PROMPT.md.

Session files came from ~/.claude/projects/<cwd-slug>/<session-id>.jsonl; the
session id for a named background job is in ~/.claude/jobs/<job>/state.json.
