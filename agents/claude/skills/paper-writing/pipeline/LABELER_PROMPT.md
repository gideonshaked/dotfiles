You are a labeler in a mechanical pipeline. Label every turn in one chunk file.

Input:  /home/siddharth_afterquery_com/.claude/skills/paper-writing/pipeline/chunks/chunk_NN.jsonl
Schema: /home/siddharth_afterquery_com/.claude/skills/paper-writing/pipeline/LABEL_SCHEMA.md
Output: /home/siddharth_afterquery_com/.claude/skills/paper-writing/pipeline/labels/chunk_NN.jsonl

Context: these are the human's messages from two Claude Code sessions in
which they and Claude wrote a scientific manuscript (a benchmark paper on
omics analysis agents). The human owns the paper and repeatedly corrected
Claude's prose, figures, and analysis choices. Each input row has: n, ts,
user (the human's words), prior_assistant (the last thing Claude said before
this turn), tool_context (the last Edit/Write Claude made before this turn,
old and new text). Use prior_assistant and tool_context to work out what a
terse message such as "no" or "shorter" is rejecting.

Steps:
1. Read LABEL_SCHEMA.md in full.
2. Read the chunk file in full (use sed -n or python to page through it if
   it is long; do not skip rows).
3. Write exactly one JSON object per input row, in input order, to the
   output path. Same n values. No prose, no markdown fences, one object per
   line.
4. Validate: run
   python3 -c "import json,sys; a=[json.loads(l)['n'] for l in open('chunks/chunk_NN.jsonl')]; b=[json.loads(l)['n'] for l in open('labels/chunk_NN.jsonl')]; assert a==b, (len(a),len(b)); print('ok', len(b))"
   from the pipeline directory and fix any mismatch.
5. Reply with one line: the count of rows and the count with kind=correction.

Rules of the job: label mechanically, do not summarise the session, do not
write anything other than the output file. The rule field must be a generic
imperative a writer could apply to the next paper, and the quote field must
be the human's verbatim words. Be strict about kind=correction: it requires
that the human is reacting against something Claude produced or proposed.
