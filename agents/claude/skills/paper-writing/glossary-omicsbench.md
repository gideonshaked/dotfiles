# Omicsbench manuscript glossary

Terms and layout decisions the author ruled on while writing the omicsbench
paper. Read this before editing anything under omicsbench-paper/paper. Each
line came from a correction in the writing sessions or from the terminology
rules in the paper repo's CLAUDE.md, which also bans "lane" and "depth".

## Fixed terms

| Write | Never |
|---|---|
| dependency chain length | depth, question depth, DAG depth |
| model/harness combination | lane |
| failure mode (two words, no hyphen) | failure-mode |
| a priori failure modes / emergent failure modes | modes, archetypes, "fixed" for the a priori set |
| assign a failure mode | tag, tagging |
| unsupervised clustering, unsupervised failure mode discovery | unsupervised discovery |
| descriptions (judge outputs) | sentences |
| a judge (each separately prompted instance) | the judge, the second judge call |
| gated retries, feedback (as in the introduction) | gating (undefined), the gate |
| single pass / gated (evaluation settings) | modes, when it could collide with failure modes |
| modalities (assay categories) | layers |
| biological dataset | omics dataset |
| computational biology tasks, bioinformatics work | analysis (for the whole undertaking) |
| research study-scale | other scale nouns |
| long-horizon | research scale, dependent step |
| system prompt | the text that opens the session |
| evaluation environment | leaderboard (in the introduction) |
| AI agents at first mention, agents after | specific agent names in the opening |
| node (introduced inline as the graph word for a task) | |
| user turn | steps versus turns contrast |
| technical failure modes (with its definition) | method failure modes |
| deterministically graded against a ground truth | a grader holding an expected answer |
| costs were taken from the OpenRouter API | any cost accounting method |
| a standard Docker image, pointing to the Dockerfile | a description of the toolchain |
| no internet access | any mention of the proxy |
| the benchmark, the 97 questions | corpus |
| prompted (a node is re-prompted) | |
| effort not settable through OpenRouter | effort not settable |
| GPT-5.6 Sol, Muse Spark with version | GPT-Sol, unversioned names |
| OpenRouter model slug in code font | informal embedding model name |

## Banned outright

buy (for what feedback, retries or a check are worth), corpus, taxonomy, LLM
judges, public (for the datasets), checked (for grading), task agnostic,
language model, known (as the replacement for anticipated),
predicted in advance, hits, shape categories, grader families, mechanism-level,
stacked (for what an agent did), later-turn, "we follow Miller" in place of
stating the method.

## Layout decisions

- Results open with a benchmark composition section before the leaderboard.
- The leaderboard section shows how the benchmark discriminates between
  models. The gating section shows how and how much gated retries lift
  performance.
- Tables default to the main text beside the figures they support. Only the
  already-specified appendix tables stay in the appendix.
- Supplementary figures come first in the appendix.
- All benchmark prompts live in one appendix section. All judge prompts live
  in another.
- No cost or token accounting section anywhere. The price of the gating lift
  is not discussed. Cost comparisons use single-pass runs only.
- The grader-type effect is not acknowledged in Results.
- A priori and emergent failure modes share one table of definitions with
  identical formatting. A table that only repeats labels legible on a plot is
  not added, and a taxonomy table carries names and counts, no definition
  column.
- A question's dependency graph is drawn as a simple diagram, never a table.
- Bibliography spacing stays at the natbib default.
- The Miller error-bar methodology is cited once, with its reasoning in one
  contiguous span of the uncertainty paragraph.
- BixBench3 is credited as the source of the failure-mode vocabulary in
  Methods only, never in Results.
- The a priori annotation and the unsupervised clustering are presented as
  independent analyses. Never imply the clustering derives from the judge
  annotation.
- Grader design is explained by why graders exist plus one example unique to
  omicsbench (not letter case, not value within tolerance, not spelling).
- Parameters (gate threshold 0.7, three attempts, 1800 s timeout) are stated
  as what was used for these runs, without rationale.
- The introduction does not cite figures or give run counts.
- Literature review covers biology-specific benchmarks only, in two groups:
  benchmarks that grade isolated chunks, then long-horizon benchmarks that
  lack the multi-turn gated design.
- Citations are proposed as paper links in parentheses. The author owns the
  bib file.
- The title contains "benchmark", names AI agents, says bioinformatics, and
  carries research study-scale and in-context feedback.
