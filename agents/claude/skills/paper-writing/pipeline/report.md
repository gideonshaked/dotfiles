# Correction corpus report

Corrections after cross-session dedupe: 737

| Domain | Count |
|---|---|
| prose | 371 |
| figure | 257 |
| analysis | 63 |
| other | 35 |
| ops | 11 |

| Severity | Count |
|---|---|
| 1 | 302 |
| 2 | 371 |
| 3 | 64 |

## Themes from themes.json

| Count | Max severity | Theme |
|---|---|---|
| 16 | 2 | Describe mechanics exactly as they work, from the code or the author's account: when the agent sees a score, that the best attempt is always taken, how one attempt carries several failure modes, that each judge is a separate instance, and who the actor is. |
| 16 | 2 | Title each results section with its argument as one short declarative sentence: no colon, one clause, primary claim first, a general point rather than one specific finding. |
| 15 | 3 | Use the manuscript's fixed term for each concept ('dependency chain length', 'failure mode' unhyphenated, 'assign', 'descriptions', 'modalities', 'biological dataset', 'long-horizon') and never a banned word ('depth', 'tag', bare 'modes', 'corpus', 'buy', 'taxonomy', 'LLM judges', 'public', 'analysis' for the work). |
| 14 | 2 | Keep the Introduction to three or four short paragraphs that open broadly on agents' advancing capabilities, introduce the benchmark near the top, state the gap broadly, and lead each finding with what it reveals about agents, leaving figure citations, run counts, grader details and specific failure modes to later sections. |
| 13 | 3 | Change only the span the author asked to change; keep their wording, paragraph breaks, numbers, topic sentences and layout, and never reintroduce wording they removed. |
| 12 | 2 | Give each paragraph one distinct job and keep related sentences together: split a paragraph that carries several ideas, fold a minor point into an existing paragraph rather than giving it its own, and place each sentence directly after what it qualifies. |
| 12 | 3 | Open every paragraph with a topic sentence that states its point directly and bridges from what precedes it, leading with the positive finding and adding nuance after; never open on a procedural detail or a methodological exclusion. |
| 12 | 3 | Use plain, fully spelled-out names in titles: no undefined jargon such as 'gating', no compressed modifiers such as 'later-turn', no opaque coinages, and the method named in full. |
| 10 | 2 | Write for a reader with no context: define every term inline at first use, expand acronyms, gloss each failure-mode and family name where it appears, and never use an undefined internal term. |
| 10 | 2 | Name failure archetypes in plain language that states the specific decision that failed as cause and effect, give paired vocabularies corresponding terms that state their origin, and put a table of definitions alongside. |
| 10 | 2 | Attach figure and table citations as parentheticals to the claims they support: cite each panel individually, consecutive panels as a letter range, supplementary figures in the same bracket, the specific table behind a panel, and never a sentence announcing that a figure or appendix exists. |
| 10 | 2 | Restrict related work to biology-specific benchmarks, split into those that grade isolated chunks and long-horizon ones, cited in groups with every relevant version, with no comparison table and no out-of-scope prior work. |
| 10 | 2 | Check every fact against its source before writing it (counts against the figure's grouping, cross-reference labels, the author's current draft, the repository, the author's account of the run), then propagate the change to every dependent statement. |
| 9 | 2 | Choose the concrete, precise word: no vague figurative phrases or prepositions, dangling pronouns, conversational transitions, redundant pairings, or historical 'began' openers. |
| 9 | 2 | Build results paragraphs from confirmed facts and notable cases that make a point about the field, with enough detail to cover them, not arbitrary named combinations, bare ranges, or derived multipliers. |
| 8 | 3 | Describe a category or procedure in one plain clause at the level of what it did, not an enumeration of every mechanism, implementation detail, or internal code organisation. |
| 8 | 3 | Order and scope Results along the reader's journey: benchmark composition first, then the leaderboard, then gating, each section owning one finding and handing mechanism, cross-section summaries and grader effects to the section that owns them. |
| 8 | 3 | Say the same thing in fewer words: keep a results subsection to two or three paragraphs, cut sentences that add nothing or make no sense, and do not belabour what the reader will assume. |
| 8 | 2 | Keep every claim proportionate to the evidence: soften absolutes, write 'many' not 'most', hedge weak relationships, do not call something an exception the numbers do not show, and never build on a difference within noise or speculate about future behaviour. |
| 8 | 2 | Give every verb and comparative in a title its object or target, state the scope of the measurement, and drop needless quantifiers and the benchmark's name. |
| 8 | 3 | Once the author has ruled on a phrase, term or fact, write it as ruled and do not relitigate it. |
| 7 | 2 | Quote in the text only numbers a reader can read off the cited figure, at its printed precision and granularity; exact values from the data are allowed only where a segment is too small to label. |
| 7 | 2 | Keep captions as short as the paper's other captions: say what each panel measures with one parenthetical per panel, open by naming the plot, put data caveats there rather than in the body, and never describe encodings the reader can see. |
| 7 | 2 | Make an abstract point concrete with one worked example, marked as an example, that is distinctive to this benchmark and actually implemented, rather than cataloguing categories. |
| 6 | 2 | Present run parameters (gate threshold, attempt cap, timeout, minimum cluster size) as settings chosen for these runs, stated lightly without rationale and never as inherent properties of the benchmark or algorithm, with exact values kept in Methods. |
| 6 | 2 | Give Methods, Discussion and appendix subsections specific, conventional names that say what they contain, using the exact title the author specifies. |
| 6 | 1 | Make coordinated clauses grammatically parallel and complete, each with its own verb and restated object, and place asides where they do not split subject from verb. |
| 6 | 2 | Never restate what the manuscript has already said: no repeating a topic sentence within its paragraph, no re-explaining a notion the Introduction established, no Methods repeating Results, no Discussion paragraph on a point Results already made. |
| 6 | 3 | Prefer the plain, straightforward statement over a clever or second-order one: state facts straight, use the conventional word, draw simple conclusions, and leave complexity for the Discussion. |
| 5 | 3 | Use a connective only where it is earned: 'but' for a real opposition, 'instead' only after a true contrast, 'for example' before an example, and a simple 'Notably' rather than a computed comparison to mark an outlier. |
| 5 | 3 | When a passage parallels the reference paper's (BixBench3), mirror its structure, length and phrasing. |
| 5 | 2 | Write the paper title as 'Name: a multi-turn benchmark ...', naming AI agents and the distinguishing features (research study-scale, in-context feedback), saying 'bioinformatics', compressed and scientific. |
| 5 | 2 | Do not use colons or semicolons in body prose; a colon is allowed only to introduce a list or a verbatim block. |
| 5 | 2 | Place material by the paper's structure: new tables in the main text beside their figures, supplementary figures first in the appendix, all benchmark prompts in one appendix section and all judge prompts in another, and a dependency graph drawn as a simple diagram. |
| 5 | 2 | When a name, opening or word choice is contested, offer several varied options and let the author choose rather than committing one. |
| 4 | 3 | Keep methods explanation in a Results paragraph to its opening sentences and spend the rest on the outcome; credit borrowed vocabularies only in Methods and state a method's advantage over the alternative once, in the opening paragraph. |
| 4 | 3 | When writing a new section or the abstract, reuse the terminology the manuscript has already established (Figure 1, the Introduction, the Results) rather than coining a paraphrase. |
| 4 | 2 | Match sentence boundaries to ideas: one idea per sentence, split run-ons at their natural boundary, but do not chop one idea into choppy fragments. |
| 4 | 2 | Do not describe cost accounting or the price of the gating lift anywhere; say only that costs are as charged by the OpenRouter API, and compare costs only across single-pass runs. |
| 4 | 2 | Never touch the bibliography file: cite by naming the work in the prose and putting the paper link in parentheses at the end of the sentence, let the author add the bib entry, and keep the natbib default spacing. |
| 4 | 3 | Treat machine-drafted prose as a placeholder: the author drafts, Claude reviews against Orwell's rules and suggests edits, and never lets a style rule set produce stilted prose. |
| 3 | 2 | End a results paragraph on its evidence sentence with the figure citation; do not add an interpretive cap or introduce new numbers in a closing sentence. |
| 3 | 2 | Name every model by its full official name with version, or by its provider slug in code font for API models, consistently throughout the paper. |
| 3 | 2 | Do not restate in prose what the reader can see on the plot, and never write 'X is shown in Figure Y'; keep figure-referencing paragraphs very short. |
| 3 | 2 | Do not add a table or appendix section that duplicates what a figure already shows, and give a taxonomy table only names and counts. |
| 3 | 2 | In the abstract, frame each result as evidence for why the benchmark matters and present the failure-mode analysis as a method with its motivation, not as a list of findings. |
| 3 | 3 | Describe the a priori annotation and the unsupervised clustering as independent analyses, and attribute any hand grouping to the authors rather than the clustering. |
| 3 | 3 | State what you did and its argument in your own words, then attach the citation once; never write 'we follow X' or re-cite a work already cited. |
| 2 | 1 | Do not repeat a distinctive word or construction nearby: never the same verb twice in a sentence or paragraph, and never a closing construction the previous paragraph used. |
| 2 | 2 | Keep statistical machinery out of the Results body: no test statistics, multiple-comparison corrections, or interval computation details. |
| 2 | 2 | Format all tables identically and at the same width. |
| 2 | 2 | Do not introduce or depend on a concept before the section that covers it; each subsection stands alone. |
| 2 | 2 | Re-read every sentence after editing part of it so the result stays grammatical and reads smoothly. |
| 2 | 2 | When tightening or rewriting for clarity, keep every claim, citation and detail; restore a crowded-out point as its own short clause. |
| 2 | 2 | Never phrase an omitted analysis or future work as a limitation or criticism of the benchmark; keep limitations to one tight paragraph led by the most important point. |
| 2 | 1 | Keep the draft manuscript to the sections currently in progress, retaining only the author block and an abstract stub. |
| 2 | 2 | Keep section notes complete but brief for the downstream writer: record how each figure was made and the full downselection funnel, without over-specifying mechanics. |
| 1 | 3 | Every quoted number and comparator must say what it refers to and over what set it is measured. |

## Themes from themes_figure.json

| Count | Max severity | Theme |
|---|---|---|
| 14 | 3 | Tick, category and point labels must sit level and unrotated with clear air around them, never overlapping, touching or clipped; widen or heighten the panel to fit them rather than staggering or deleting them, and check the render before sending. |
| 14 | 2 | Every panel and table must earn its place: drop or move to the appendix anything that repeats an earlier figure, shows instrument internals, previews another section's finding, or carries no finding of its own. |
| 12 | 2 | Axis and chart labels name the exact quantity in a short plain phrase ('Mean node score', 'Nodes per question'); no parentheticals, hedges, sub-chart titles or scale notes, with definitions in the caption or a reference table. |
| 11 | 3 | Show a change over turns as the classic line plot: turns on x, score (or delta from turn 1) on y, over the full range of turns, one line per model, starting from the reference point without a marker. |
| 11 | 3 | Change only what was asked: do not replace, move, restyle, archive or drop an element the human placed or approved, restore the previous form when a change is rejected, and never reintroduce a rejected element. |
| 10 | 3 | Figure type must be legible at the width the figure actually gets on the page, just under body-text size: check page layout and margins before touching figure code, size to the house size, and say where every size comes from. |
| 10 | 3 | Choose histogram bins for readability: consistent widths, enough bins to show the shape, no empty bins or spurious dips, sparse tail collapsed into one open-ended bar labelled 'N+' for counts or '>X' for continuous quantities. |
| 10 | 3 | Size and place panels by content and importance: the key panel widest as a centrepiece, many-label panels tall enough, no panel wider than its labels need, axes ending just past the data, and never shrink a neighbour below legibility. |
| 10 | 3 | Align elements precisely: centre text and inline marks on their line, band or marker, push bubbles flush to their lane edges symmetrically, keep every glyph inside its box, and derive spacing from measured sizes rather than hard-coded offsets. |
| 8 | 2 | Keep the overview schematic sparse and conventional: one unified top-down drawing, one description per node, no numbering or heading text, data files as pictograms, DAG and unrolled session side by side in framed boxes with straight arrows. |
| 7 | 2 | Give each variable its own palette and use it consistently across every panel and figure; never reuse a model colour, another panel's palette, a hatch or a fill colour for a different meaning. |
| 7 | 3 | Use an off-the-shelf, high-contrast standard palette whose colours are clearly distinguishable from each other and from values printed on them; when colours are too similar, switch palettes rather than reshuffle, and pick one rather than offering a menu. |
| 7 | 3 | Bars are the same width across every group, axis and sibling figure, as thick as the row allows, with tight even gaps between blocks rather than empty space; check the render, not the intended ratio. |
| 7 | 3 | Leave clear air between adjacent panels and between rows so nothing touches or overlaps, without wasting bands of page; matching gaps must be equal. |
| 7 | 2 | Set figure height from its content and the page: grow the figure when panels or bars are crushed, keep it inside the text block, and when it must shrink take height from slack bands, legend position and bar thickness rather than from dense panels. |
| 6 | 2 | Markers must be readable: distinct silhouettes (no stars), large enough that shape and error bars show, error bars in the marker's colour, slightly transparent with faded lines when series overlap, and identical transparency across sibling panels. |
| 6 | 3 | Label single-pass and gated mode once, prominently and unambiguously on every panel, by hatch within each model's colour or one row label per mode, not by repeated lowercase tags or a single distant header. |
| 6 | 2 | Iterate on panels with the lightest possible process: one script per panel beside its output, no scaffolding or reusable helpers, PNG only until assembly, one panel at a time, and only the exports asked for at 300 dpi. |
| 6 | 2 | Use precise domain terminology in figure text: name the measured quantity ('snATAC-seq: chromatin accessibility', not 'gene activity'), spell out acronyms at first use, and label files and chips by what they are. |
| 5 | 3 | Every panel makes one claim a reader grasps at a glance: state the claim before drawing, use few subplots with plain axes, and never ship a panel that reads as texture or needs a new construct explained. |
| 5 | 2 | Use conventional, defensible chart forms and methods a reader decodes unaided (sorted bars with CIs, t-SNE/PCA/UMAP); no dumbbell plots, compact letter groups, box plots or frontier lines. |
| 5 | 3 | Read the request carefully and answer it directly: confirm which plot or element is meant before acting, say yes or no rather than substituting a different plot, and interpret 'shorter' or 'example figures' as the owner meant them. |
| 5 | 2 | Place the key at the bottom of the figure, close under the x titles but not touching them, with clear space between swatch and label and between key and plot. |
| 5 | 2 | Never split a locked figure into two numbered figures; a figure too tall for one page is continued over two, filling each page, with one key and one caption at the bottom of the last page. |
| 5 | 2 | Place figures deliberately in the build: pin with [H], keep each figure in the section that cites it, replace placeholders as soon as a panel exists, and treat leftover page whitespace as a layout problem to fix now. |
| 4 | 2 | Build the overview schematic on a real, conventional human-genomics question from the released sample, showing inputs at the level a reader needs (raw data plus metadata, labelled by organism, tissue, condition and assay) rather than the package's exact file list. |
| 4 | 2 | Format legends as a full rectangle with no empty cells, swatches as tall as their text, titled sections kept well apart with tight columns inside, and counts printed after group names. |
| 4 | 3 | Model figures on peer papers and the existing manuscript: match their density and design (BixBench3 Fig 2), reuse the old manuscript's figure code and layout such as the harness axis break. |
| 4 | 2 | Keep tick numbers on every panel even when axes are shared, with the axis title once; on log axes drop unlabeled minor ticks and label a similar number of values on each axis. |
| 4 | 1 | Wrap long category and axis labels onto two lines rather than letting them protrude, crowd neighbours or force a wider panel or a split figure. |
| 4 | 3 | Adjust spacing in small increments and check the result before sending; do not overshoot in the other direction, and restore the previous layout when a change goes too far. |
| 3 | 2 | A panel must not visually undercut or contradict the claim it supports: if raw levels run the wrong way or the eye reads 'no difference', change what is plotted rather than relying on the caption. |
| 3 | 3 | Make model identity easy to read on scatter panels: direct name labels if they can be made legible, otherwise consistent per-model colour on every panel including the leaderboard. |
| 3 | 3 | Plot the direct quantity (score rising with tries), not a derived or tautological one such as the geometric decay of a per-node pass rate. |
| 3 | 2 | The schematic must make multi-turn unmistakable: separate prompts and replies in one session, both gated and single-pass shown, wording idiomatic. |
| 3 | 3 | Print values on bars as upright black digits, inside every segment where they fit and on top of leaderboard bars, and size the panel so they fit. |
| 3 | 2 | Set category granularity so the classes of interest are readable: one level of specificity, no 'other' bucket hiding the tail, no dominant trivial bulk in a stacked bar. |
| 2 | 1 | Write the harness in parentheses after the model name, e.g. 'Opus 5 (Claude Code)', rather than in a separate legend. |
| 2 | 2 | Do not draw a legend the figure does not need: one figure-level key rather than per-panel legends, and none when a table already carries the colours. |
| 2 | 1 | Build sibling panels with the same structure, each scaled to its own data with only the zero line aligned. |
| 2 | 1 | Order bars deliberately: harness groups OpenCode, Claude Code, Codex; equal counts alphabetically. |
| 2 | 1 | Frame a UMAP tightly on the data with points large enough for clusters to read, and address distracting outliers without compromising the projection. |
| 2 | 2 | Style box plots like the paper's bars: flat fills without outlines, axes sized so no box crosses the y axis. |
| 2 | 3 | Panel letters sit at the same height across a row and clear of neighbouring panels. |
| 2 | 1 | Draw diagrams in tooling with relative positioning and self-sizing nodes so they look designed and survive endless tweaking. |

## Themes from themes_analysis.json

| Count | Max severity | Theme |
|---|---|---|
| 8 | 3 | Name every category in canonical terms a domain scientist recognises, at one level of specificity: a technique, process or research field, never a tissue or data type, never a vague or opaque name, never two unrelated things joined with 'and', and never two categories that overlap. |
| 6 | 2 | Make only the points that add up to the section's thesis: emphasise the one carrying the paper's argument, move findings another section owns to that section, push secondary points to the appendix, and plan enough panels to carry the narrative. |
| 5 | 3 | Check every factual assertion against the data and the documented findings before writing or plotting it; when one proves wrong, re-verify every other claim, independently and without priors. |
| 4 | 3 | Do not collapse a heterogeneous class into one bar or fold distinct assays under an umbrella name; break every class out to the same level of specificity as its neighbours so a biologist can see the diversity of the data. |
| 4 | 2 | Do not add analyses beyond what the shown figures need: no extra statistical tests, no supplementary agreement statistics, no second-order cross-tabulations of one vocabulary against another, and no new annotation passes the owner has ruled out. |
| 4 | 2 | Define the analysed population deliberately: remove the confounding subpopulation rather than declaring a plot impossible, but keep the broadest definition that removes the confound, never cherry-pick models, and do not truncate reasonably populated strata. |
| 4 | 3 | Do not add group sections to a table whose source lists its rows flat; where rows are grouped, repeat the grouping value on every row rather than using spanning cells or italic multicolumn rows, and judge the construct by how it renders. |
| 4 | 3 | Align table cells with the package's facilities, not hand-tuned offsets: text columns left-justified and top-aligned, marks and group labels vertically centred, with each row's color mark level with the text it labels. |
| 4 | 3 | Typeset every table to the paper's convention: body in small type, caption at the size of the other captions with only the 'Table X:' label bold, verified on every table type including longtblr. |
| 4 | 3 | Lay out the author block as equally spaced names with emails beneath, numbered affiliations, and one institution line below, balanced symmetrically about the page centre; wrap a long affiliation before 'and Bioinformatics' and separate department from university with a comma. |
| 3 | 2 | Build the analysis the owner agreed to; do not substitute a different operationalisation of a concept, replace an agreed method with a preferred one, or steer back to a rejected design. |
| 3 | 2 | Prove a behavioural mechanism before drawing it: state what evidence would prove it and work back to the figure, pair any mechanical heuristic with an LLM judge or a human reading of trajectories, and drop a label such as 'reward hacking' that the evidence does not earn. |
| 3 | 2 | Read the paper's 'accounting for reward hacking' as the closed-choice node exclusion that was actually performed; an anecdotally observed behaviour justifies an exclusion when no quantitative claim is attached, and such rulings go in the project notes. |
| 3 | 2 | Report run settings as the author states them (every model at high effort), not as inferred from lane configs or provider metadata; for models without an effort control report only the equivalent setting, never reasoning on/off toggles. |
| 3 | 2 | Give the color swatch and the mode number each their own unlabeled column, and drop count columns such as attempts from the mode tables. |
| 3 | 1 | Use identical column widths across parallel tables and size each column to its content, keeping swatch, name and group-label columns as narrow as their content allows so rows stay short. |
| 3 | 3 | Check the rendered PDF yourself before reporting a layout fix as done; never attribute a reported rendering problem to a stale view. |
| 2 | 1 | Within a grouped categorical chart, check whether a singleton category belongs under an existing one, and pool the remaining singletons into an 'other <group>' bar. |
| 2 | 2 | Do not compare against another benchmark's results, whether as correlations or as a side-by-side panel; drop such analyses from the results. |
| 2 | 1 | Hold the population fixed on both sides of a comparison and across the panels of a figure: the same models when comparing spreads, the same node filter (e.g. closed-choice graders excluded) in every panel. |
| 2 | 2 | Keep the statistical-methods text to what was actually used: explain the standard-error approach, independence and what counts as a replicate, cite the interval method's source instead of re-deriving it, and use one interval construction for every quantity. |
| 2 | 2 | Compare models or harnesses only where the data carry it: no positive or negative claim about a factor observed on one or two models, and no argument that differences exceed interval widths without formal tests. |
| 2 | 2 | Sanity-check every statistical construct against what it models: a p-value cannot be quoted beyond the resolution of the data (a permutation p is bounded by the permutation count), and a random-guess retry baseline must not resubmit an answer the model was told is wrong. |
| 2 | 2 | In every turns analysis distinguish a node that depends on another in the DAG from mere turn position: align on the first dependent node and restrict dependency claims to nodes that truly consume an upstream node's output. |
| 2 | 2 | Keep the clustering pipeline standard and automatic: one embedding method for both clustering and display, and no hand-merged clusters. |
| 2 | 1 | Keep or drop emergent clusters on scientific grounds: keep archetypes that expose a distinct, mechanically specific failure even when concentrated in few tasks, drop one that duplicates a deterministically measured category and explain why, and flag any archetype dominated by a single question. |
| 2 | 2 | Classify failures by graded outcome, not by how the turn ended; an end state whose answer file is graded like any other is not a failure mode and leaves the failure analysis entirely, with no edits to other figures. |
| 2 | 3 | Set every table to the full text width, matching the paper's other tables, and re-check widths after any column change. |
| 2 | 1 | When tightening the title block, scale the gap between the title and the rule beneath it in proportion to the other reduced spacing: neither a drastic cut nor the style default. |
| 1 | 2 | State how a constructed baseline is derived the first time it appears; never present it as if it were an experimental arm. |
| 1 | 1 | State the gating lift as a percentage increase, with its range, computed from the numbers printed on the bars. |
| 1 | 2 | Format every section of a planning document the same way: a prose description with at most a small metadata table. |
| 1 | 2 | When asked to drop a style, use stock LaTeX with as little modification as possible rather than substituting a custom look. |
| 1 | 1 | Keep page margins modest so the text block is wide. |
| 1 | 1 | Place a section heading directly after the preceding section's text, never separated from it by a figure. |
