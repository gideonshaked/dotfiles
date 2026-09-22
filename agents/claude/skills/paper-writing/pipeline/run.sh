#!/usr/bin/env bash
# Whole pipeline, stages 1-4a. Stage 2b (labeling) and 4b (synthesis) are
# model passes; see LABELER_PROMPT.md and SYNTHESIS_PROMPT.md.
set -euo pipefail
cd "$(dirname "$0")"
P=~/.claude/projects/-home-siddharth-afterquery-com-omicsbench-paper
python3 extract.py \
  "$P/99372dcd-9ce9-4c84-8a09-208266a080de.jsonl" \
  "$P/757ee5b3-1481-412f-bb14-894a2b4b859c.jsonl" > turns.jsonl
python3 chunk.py turns.jsonl chunks 130
echo "now run one labeler per chunks/chunk_NN.jsonl (LABELER_PROMPT.md), then:"
echo "  python3 aggregate.py turns.jsonl labels > corrections.jsonl"
echo "  python3 split_domain.py corrections.jsonl by_domain"
