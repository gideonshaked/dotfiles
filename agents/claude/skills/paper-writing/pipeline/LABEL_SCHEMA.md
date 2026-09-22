# Label schema (stage 2b)

One JSON object per input turn, same order, written to labels/chunk_NN.jsonl.

    {"n": <int, copied from input>,
     "kind": "correction" | "instruction" | "question" | "ack" | "ops",
     "domain": "prose" | "figure" | "analysis" | "ops" | "other",
     "target": "<what Claude produced that the human is reacting to, one line, quote the offending phrase if visible>",
     "rule": "<the standing rule the human is enforcing, phrased as an imperative a writer could follow next time, one sentence>",
     "quote": "<the human's own words, verbatim, trimmed to the part that carries the correction>",
     "severity": 1 | 2 | 3}

Definitions:

- kind=correction: the human rejects, reverses, or adjusts something Claude
  already produced or proposed (prose, a figure, an analysis choice, a plan).
  "No", "not like that", "too long", "I do not like X", "you missed", "again".
  A new request that also criticises prior output counts as a correction.
- kind=instruction: a fresh task with no rejection of prior output in it.
- kind=question: the human asks for information or an opinion.
- kind=ack: "ok", "go", "yes", "now?", approval with no new content.
- kind=ops: session plumbing, git, running scripts, forks, compaction.
- domain=prose: manuscript text, captions, section titles, citations, wording.
- domain=figure: plots, panels, layout, colours, fonts, dpi.
- domain=analysis: which numbers to compute, statistics, data handling.
- severity 3 = the human is visibly frustrated or repeating a prior correction
  ("again", "I already said", "how many times", swearing); 2 = a clear
  rejection; 1 = a mild adjustment or preference.

For kind != correction, set target and rule to "" and severity to 0.
Write rules generically: "Do not open a paragraph with a hedge" not "fix
paragraph 3". If the turn corrects several distinct things, put the rules in
one sentence joined with " / ".
Never invent. If prior_assistant and tool_context do not show what was
rejected, set target to "unclear" and still write the rule from the human's
words alone.
