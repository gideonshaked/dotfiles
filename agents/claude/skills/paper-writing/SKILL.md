---
name: paper-writing
description: "How to work on a scientific manuscript with its author: which edits to make, which to propose, and the prose rules the author enforced turn after turn. Distilled from 371 corrections across two manuscript-writing sessions. Covers scope of edits, terminology discipline, numbers and figure references in prose, paragraph architecture, section titles, captions, and the sentence-level habits that got rejected."
when_to_use: "Use whenever touching manuscript prose: drafting, filling bracketed gaps, rewording a sentence, writing a caption or section title, summarising results, or reviewing the author's draft. Triggers on paper, manuscript, section, paragraph, caption, title, abstract, intro, methods, results, discussion, appendix, or any file under a paper/ or manuscript/ directory. Load alongside the writing skill for diction; this skill governs the collaboration and the paper-specific rules."
---

# Paper writing

Rules learned from one author correcting Claude across roughly 1,250 turns of
manuscript work. Most were enforced more than once. The ones marked (repeat)
are rules the author had to state again because Claude broke them after being
told.

## Your role

The author writes. You edit, fill gaps, and propose. The author's verdict on
Claude drafting from scratch was that a style rule set "is making you write
inorganically, like crap", and they took over drafting themselves. Behave
accordingly.

- Change only the span you were asked to change (repeat). If asked to fix one
  word, fix one word. If asked to fix flow, change the connectives and nothing
  else. Do not re-word neighbouring sentences, merge or split the author's
  paragraphs, or rewrite their topic sentence while filling in brackets.
- Never reintroduce wording the author removed or banned (repeat). Keep a
  running list of banned words for the manuscript and search the draft for
  them before every hand-back.
- Once the author rules on a phrase, a fact, or a number, write it as ruled.
  Do not relitigate it, soften it, or swap in a "more precise" alternative.
  "I want to say performance degrades over the course of the session" ends the
  discussion.
- When a word, title, or opening is contested, offer several options in chat
  and let the author pick. Do not apply one. If they reject the set, the
  next set must be more varied, not more of the same.
- Propose new paragraphs in chat before touching the file. Paragraphs you did
  draft into the file are placeholders. Mark them for the author to rephrase.
- Before restating something the author already wrote elsewhere, reuse their
  copy. Do not compose fresh copy for a point that exists in their words.
- Read the author's current draft before describing what a section contains.
  It has changed since you last looked.

## Verify before you write

- Read the code, the README, the data table, or the repository before stating
  how something works, what was released, or how many of something there are.
  Do not paraphrase mechanics from memory.
- Describe mechanics exactly. State when the agent sees a score and when it
  does not, that the best attempt is always taken rather than conditionally,
  how one attempt can carry several labels, and who the actor is. A
  description that is nearly right is wrong.
- Trust the author's account of the run configuration over leftover test
  configs and provider metadata.
- Check every panel reference against what that panel shows. Letters drift
  when figures are rebuilt.
- Check that a label exists as spelled before writing a cross-reference to it.
- After every edit, re-read the whole sentence and the whole paragraph.
  Partial edits leave mangled text and ungrammatical sentences (repeat).
- When a Methods statement changes, find and update every Results statement
  that depends on it.
- Never edit the bibliography file. Propose a citation as a paper link in
  parentheses and let the author add the entry.

## Terminology

- Keep one glossary for the manuscript and use its terms in the body, titles,
  captions, figure labels, abstract and appendix alike. Never coin a second name
  for something a figure or an earlier section already named.
- Define a term inline, inside a working sentence, the first time it appears.
  Never write a standalone definition sentence. Expand an acronym at first
  mention and use the acronym after.
- Write for a reader with no context. Internal words from the run tooling
  (gate, hits, combination, grader family, shape category) do not appear
  unless defined in plain language first. Internal code organisation never
  appears at all.
- Describe a category or a procedure in one plain clause at the level of what
  it did. Not an enumeration of every mechanism behind it, and not
  implementation details that carry no meaning for the reader (an embedding
  width, the count of items embedded, the length of a judge's output).
- Paired vocabularies get parallel names that state their origin, such as
  "a priori failure modes" and "emergent failure modes". Not "modes" and
  "archetypes".
- Say the full term. "Failure modes", not "modes", when "mode" also names an
  evaluation setting. "Unsupervised failure mode discovery", not
  "unsupervised discovery". "In later turns", not "later-turn".
- Category names carry the mechanism, not the outcome. "Fabricating values"
  needs its meaning spelled out where it appears. Longer names are fine when
  they say what the decision was that failed.
- Use the field's own word over a coined one ("long-horizon", "saturate"),
  use precise statistical terminology rather than a bare word such as "unit",
  and prefer the plain conventional word when avoiding it sounds obtuse.
- Model names are the full official name with version, everywhere. API model
  identifiers go in code font.
- Every separately prompted instance of a judge model is "a judge", never
  "the judge" or "the second judge call".

## Numbers and figures in prose

- Quote only numbers a reader can read off the cited figure or table, at the
  precision printed there. If the figure omits a label because a segment is
  too small, the underlying data may be quoted. A statistic the reader cannot
  verify from the figure (a median on a binned histogram, a rank correlation)
  does not go in the text.
- Every quantitative claim carries a citation to the panel that supports it,
  as a parenthetical attached to the claim. Never write "X is shown in
  Figure Y".
- Cite panels individually. Consecutive panels are one range (Figure 3B-E).
  A supplementary figure that supports the same point goes in the same
  bracket, not in its own sentence. Cite the specific table behind a panel,
  not the appendix section, and cite the figure that displays a number beside
  any table citation for it.
- Do not restate what the plot shows, and do not narrate its shape. A
  paragraph that points at a figure can be very short.
- Every number says what it counts and over what set. "At most 5%" must say
  of what and in whom. A comparator attaches to the quantity it qualifies.
- Compare like with like before calling something an exception. Do not build
  a paragraph's argument on a difference within noise, and do not qualify the
  headline claim with a "but" clause about a noise-level difference.
- Chosen parameters (thresholds, attempt caps, timeouts, cluster sizes) are
  stated as settings used for these runs, lightly, in a parenthetical. Never
  as properties of the benchmark or the algorithm, and without a rationale.
- Interval methods, multiple-comparison corrections, replicate structure and
  data-coverage caveats live in the caption or Methods, not the Results body.
- Give the relative change, not the raw score change, and name the items at
  the ends of a range instead of quoting the range bare.
- Build paragraphs from confirmed facts and notable cases that make a point
  about the field. Not arbitrary named items with their statistics, not
  derived multipliers, and not only the extremes.
- Mark an outlier with a simple "Notably" and its number, not a computed
  comparison such as "half the next lowest".

## Paragraphs and sections

- The topic sentence states the point the paragraph argues, and the sentences
  after it must follow from it. Do not restate the topic sentence later in the
  paragraph. Each sentence adds something.
- One job per paragraph. Do not restate a fact established earlier, and move
  quickly past notions the introduction already covered. A minor point is
  folded into an existing paragraph as one quick sentence, not given a
  paragraph of its own.
- Short. A results subsection is two or three paragraphs. An introduction is
  three or four short ones. Seven paragraphs is a plan to cut. When asked to
  shorten, keep every claim, citation and detail and cut words. If a point
  gets crowded out, restore it as its own short clause.
- Each subsection stands alone. Do not lean on a concept a later section
  introduces, and do not introduce a detail before the paragraph that covers
  it.
- Open a section by introducing the concept it depends on, in the register of
  the preceding paragraph, and lead into the method gently. Do not open on a
  procedure, a methodological exclusion, or an ordinal ("a second judge call")
  that makes the reader recall an earlier step.
- Lead with the positive finding and add the nuance after it. The opener says
  things get better, not what was lost.
- State a method's advantage over the alternative once, in the opening
  paragraph, then present its findings on their own terms.
- In a Results paragraph, methods explanation stops after the opening
  sentences. The rest describes the outcome and its implication. Argue a point
  and what it means rather than only reporting facts.
- Prefer the straightforward conclusion. A plain list with the most relevant
  item first beats a clever second-order claim. Leave complexity for the
  Discussion.
- Place an exception directly after the claim it qualifies, with its numbers.
  Place a new sentence where it follows from its neighbours, never in front of
  a paragraph's closing sentence.
- End on the evidence sentence with its figure citation. No summary cap, no
  new numbers or comparisons in a concluding sentence, and do not reuse a
  closing construction ("taken together") from the previous paragraph.
- Put each thing where it belongs. Caveats go in the caption. Implementation
  parameters and the provenance of borrowed methods go in Methods.
  Cross-section per-model summaries go in the Discussion. Run counts and
  figure citations stay out of the introduction.
- When a paragraph is meant to parallel a passage in a reference paper, read
  that passage first and mirror its structure and length.
- State what you did and the argument behind it in your own words, then
  attach the citation. Never write "we follow X" in place of the method. Cite
  a source once and keep the reasoning it supports in one contiguous span.
- Make an abstract claim concrete with one worked example, marked as an
  example, rather than a catalogue of instances. Explain why a design exists
  and give one case.

## Introduction, abstract and discussion

- The introduction is three or four short paragraphs. Open broader than the
  paper's domain, introduce the paper's own contribution near the top, and
  state the gap broadly without mechanism details. Prior work is cited in
  groups, with every relevant version, and only what is in scope. A
  comparison table of prior benchmarks reads as overdone.
- Lead each finding in the introduction with what it reveals about the
  subject, not the method that produced it. Figure citations, run counts,
  grader details and specific category names stay out.
- Do not assert what people will do in future, and do not coin categorical
  definitions ("generations") the text would then have to defend.
- In the abstract, frame each result as evidence for why the work matters,
  or it reads as a curiosity. Present an analysis method with its motivation
  rather than a list of its findings, and reuse the terms the Results sections
  established.
- A discussion paragraph does not re-make a point Results already made, and
  pairs specific findings with at least one broad claim. It defines its terms
  for a reader who has not read the rest of the paper.
- Limitations are one tight paragraph on the few points that matter, led by
  the most important. Future work is phrased as a next step, never as a
  criticism of the work or as an omission.

## Section titles

- One short simple sentence stating the section's argument. No colon, no two
  clauses joined by a comma, at most a compound subject or object.
- Lead with the primary claim and let the secondary claim follow. Open with the
  subject making the claim ("Frontier models do not saturate").
- Name the axes and the direction. "X varies" is not specific enough, and a
  title that reports one narrow finding instead of the section's point is too
  specific.
- No benchmark name in a section title. No "all", no "any", no unexplained
  jargon, no compressed compound modifiers.
- Every comparative names its target ("more realistic than what?"), and
  "reveals" always has an object.
- A method section is titled on the utility of the method, not one result it
  produced. Give a novel method a standing name in full.
- Methods and appendix subsections are named for what they contain in plain
  terms, more specific than adjective plus noun.
- Discussion headings are conventional.

## Captions

- Read the paper's other captions first and match their length.
- Say what each panel measures, one parenthetical per panel, caveats in one
  brief clause. Never describe visual encodings the reader can see.
- Open by naming what the plot is ("A UMAP of ..."), not how marks were placed.
- Do not add a table that repeats labels legible on the plot, or an appendix
  section that duplicates a figure.

## Sentences

- No colons except before a list or a verbatim block. No semicolons. Join
  clauses with "so", "which caused", or a full stop.
- Coordinated clauses are grammatically parallel, and the second half of a
  coordinated sentence is an independent clause with its own verb and its
  subject restated. An aside goes where it does not split the subject from
  its verb.
- "Instead" only where a real contrast precedes it. "Even" never joins two
  compatible claims. "But" where the second clause opposes the first. "For
  example" or "as an example" marks an example.
- No dangling referents. "Another" must have an antecedent the reader holds.
- No vague or figurative words where a plain one exists. "Nothing to open"
  is vague. "Later-turn" is unclear. Saying the work ran "over" a dataset
  hides how the dataset enters the workflow. Say the plain fact.
- Say exactly what is meant. "Often has more than one name" and "rarely has
  only one name" are different claims. "Many", not "most", when the majority
  is not established.
- Do not repeat a distinctive verb within a paragraph, and never twice in one
  sentence.
- Fix an awkward sentence as one sentence. Do not split it into two choppy
  ones. Short sentences that carry one idea between them become one sentence.
- No conversational transitions ("whichever way that ends"). No narrated
  history ("X began ..."). No rhetorical contrast wrapped round a plain fact.
- No pairings where the verb already carries the adverbial ("predicted in
  advance" was rejected as an oxymoron). No coined categorical definitions
  ("generations") the text would then have to defend.
- Soften absolutes about the literature ("no benchmark") to defensible
  claims. Do not speculate about future behaviour. Do not claim wide variation
  when the spread is modest.

## Tables and typesetting

- Tables default to the main text beside the figures they support. Do not add
  a table that repeats labels legible on a plot, and do not add columns the
  author did not ask for even when the source note has them.
- Reproduce a table from its source note as it stands. Do not regroup flat
  rows into sections. Where rows are grouped, repeat the group value on every
  row rather than spanning cells.
- Every table is set to the full text width with identical widths across
  parallel tables, body in small type, caption at the size of the other
  captions with only the "Table X:" label bold. Re-check widths after any
  column change.
- Align cells with the package's own facilities, never hand-tuned offsets.
- Build the analysis the author agreed to. Do not substitute a different
  operationalisation, replace an agreed method with a preferred one, or steer
  back toward a rejected design.
- When one factual claim proves wrong, re-verify every other claim in the
  section independently rather than patching the one.
- Look at the rendered PDF before reporting a layout fix as done. Never
  attribute a reported rendering problem to a stale view.

## Project glossary

Every manuscript gets a glossary file beside this skill listing its fixed
terms, its banned words, and the layout decisions the author has ruled on.
Read it before the first edit and grep the draft for banned words before
handing anything back. The omicsbench paper's is glossary-omicsbench.md in
this directory. When the author bans a word or fixes a term mid-session, add
it to the glossary in the same turn.

## Before you hand back an edit

- Did I change anything I was not asked to change?
- Did any banned or removed word come back?
- Does every number say what it is a number of, and can the reader find it on
  the cited panel at that precision?
- Does every panel letter match what the panel shows?
- Is every term in the glossary, defined inline at first use?
- Any colon that is not before a list? Any semicolon?
- Does the paragraph open with its point and end on evidence with a citation?
- Did I re-read the full sentence and paragraph after the edit?
