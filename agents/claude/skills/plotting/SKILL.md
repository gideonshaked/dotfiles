---
name: plotting
description: "Design, build, and critique data visualizations using the user's personal plotting preferences, Nature-family journal figure requirements, and Edward Tufte's principles."
when_to_use: "Use on ANY plotting work, however small: writing or editing plotting code (matplotlib, seaborn, ggplot2, plotly, Vega, D3), generating or exporting a figure, adding a panel to a notebook or report, designing a chart, dashboard, or report, choosing between visualization approaches, critiquing or improving an existing visualization, reducing chartjunk or improving data-ink ratio, or planning small multiples or high-density displays. Also use for manuscript and publication figures: paper figures, multi-panel journal figures, figure legends, panel layout and alignment, submission export requirements, and Nature-family venues."
---

# Plotting

Apply Edward Tufte's principles to design clear, honest, high-density data
visualizations, layered with the user's house style.

This file has three kinds of content, and it matters which is which:

- **Personal preferences** -- the user's house style. Their own rules, not
  Tufte's.
- **Journal figures** -- submission requirements for Nature-family venues,
  distilled from the nature-figure skill (Yuan1z0825/nature-skills,
  Apache-2.0).
- **Tufte's principles** and **Analytical design** -- from Tufte's books,
  cited per section.

Precedence: graphical integrity (lie factor, honest scales) is non-negotiable
and outranks everything. When the target is a manuscript submission the journal
requirements bind next, because a figure that violates them is rejected
regardless of taste. Everywhere else the personal preferences win over the
Tufte material.

One standing conflict: journal panel letters are lowercase **bold**, which the
no-bold rule otherwise forbids. A panel letter is a submission requirement
rather than emphasis, so it is exempt. Nothing else in a journal figure takes
bold.

---

## Workflow

### For new visualizations

1. **Clarify the data story**
   - What comparisons matter?
   - What is the key insight to communicate?
   - Who is the audience?

2. **Select an approach** using Tufte principles plus the personal preferences below:
   - High comparison need -> small multiples
   - Dense data -> data tables, sparklines
   - Time series -> line charts with minimal grid
   - Part-to-whole -> avoid pie charts; prefer bar or table

3. **Design with data-ink in mind**
   - Start minimal, add only what is necessary
   - Every element must earn its ink
   - Default to grayscale; use color purposefully (subject to the preferences below)

4. **Apply the Tufte test** (below)

### For critiquing visualizations

1. **Check graphical integrity**
   - Calculate lie factor if proportions seem off
   - Verify baselines and scales
   - Look for 3D distortion

2. **Identify chartjunk**
   - Decorative elements
   - Heavy grids
   - Unnecessary 3D effects
   - Moire patterns

3. **Evaluate data-ink ratio**
   - What can be erased?
   - What is redundant?

4. **Suggest improvements** with specific before/after recommendations, aligned with the personal preferences below.

---

## Personal preferences

Personal overrides and house style for data visualization. These take
precedence over the generic Tufte material below when they conflict, but should
not contradict graphical integrity (lie factor, honest scales, etc.).

### Stack and tooling

- Python: prefer seaborn over matplotlib-only, pandas .plot, plotly, or other alternatives. Drop down to matplotlib only for fine-grained control seaborn cannot give.
- R: prefer ggplot2 over base R graphics or lattice. Stay in the tidyverse/ggplot grammar; reach for extensions (patchwork, ggrepel, cowplot) before reverting to base R.
- Before writing non-trivial plotting code, use Context7 (`resolve-library-id` then `query-docs`) to confirm current API for the chosen library. Do not rely on memory for argument names or defaults.

### Typography

- **Titles are never bold.** This is the most common offender and the strictest version of the no-bold rule. Plot titles, axis titles, and facet/panel titles all stay at regular weight (e.g., in seaborn/matplotlib never pass `fontweight="bold"`; in ggplot2 do not set `face = "bold"` in `element_text` for titles, and override any theme default that does).
- No bold anywhere else either: axis labels, tick labels, annotations, legend titles, captions. Use weight only when it carries information (e.g., highlighting one series among many), not for emphasis.
- The one exception is a multi-panel figure's panel letters, which are lowercase bold. See Journal figures below.
- No stacked subtitles or stat-strips on the plot itself for things like Pearson r, Spearman rho, n, p-values, R^2. Those belong in the figure caption or accompanying slide bullets, not as a subtitle.

### Axes, grids, frames

- Drop the top and right spines on regression plots, dot plots, line plots, and similar Cartesian plots. Keep only the bottom and left spines.
- No horizontal or vertical rules across the plotting area unless they genuinely enhance viewer clarity (e.g., a reference line at y=0, a meaningful threshold, a date marker that the reader needs to locate). Default is no rules.

### Chart-type defaults

- Barplots: always print the exact value of each bar on top of (or just above) the bar. This is a specific exception to the general "no on-plot text" rule; bar height is hard to read precisely, so the number earns its ink.

### Annotation and labeling

- No added text on the plot unless it serves a specific purpose. Rule of thumb: the text must need to be on the plot to add something.
  - Good: a label next to a circled point of interest; identifying an outlier; calling out a regime change directly on the data it refers to.
  - Bad: pasting the Pearson r, n, or model coefficients onto the plotting area as standalone text.
  - Exception: in many-paneled / faceted plots, per-facet stats on the panel can be the cleanest place for them, since the caption cannot speak to each panel individually.
- Prefer direct labels on series over a separate legend when there are few series.
- Statistical summaries (r, rho, n, p, R^2) live in the figure caption or surrounding prose by default.

### Output and sizing

- Always render and export figures at 300 DPI. In matplotlib/seaborn, set both `figure.dpi` and `savefig.dpi` (e.g., `plt.rcParams.update({"figure.dpi": 300, "savefig.dpi": 300})`) so on-screen and saved figures match.

### Anti-preferences

- No bold text for emphasis. Panel letters are the exception; they carry structure, not emphasis.
- No subtitles used as stat-strips.
- No top/right spines on standard 2D plots.
- No horizontal/vertical rules without a clarity reason.
- No on-plot text that does not need to be on the plot.

---

## Journal figures

For manuscript submissions to Nature-family venues. The chart serves the
scientific logic; polish and layout are subordinate to making the core
conclusion clear, defensible, and reviewable.

### The figure contract

Settle all of this before writing any plotting code.

1. **Core conclusion.** One sentence with a verb: "Treatment X reduces Y by
   restoring Z", not "Treatment results". Name the Results-level question it
   answers. Given data but no claim, infer a provisional claim and confirm it
   before final styling.
2. **Evidence chain.** Group tables and experiments by the claims they support,
   not one panel per source table. Separate primary evidence from controls and
   robustness.
3. **Archetype.** Quantitative grid; schematic-led composite, where the
   schematic takes 35-60% of the area; image plate plus quantification; or
   asymmetric mixed-modality, where one panel spans rows or columns.
4. **Export target.** Final dimensions, formats, source data, statistics
   definitions and image-integrity notes, all fixed before styling.

Write the contract down: conclusion, question, archetype, target size, panel
map, evidence hierarchy (hero, validation, controls), statistics needed, source
data, integrity notes, reviewer risk.

Default panel order unless the story demands otherwise: establish the system,
show the main effect, show mechanism or localization, quantify the
representative image, then robustness and controls.

Palette discipline: one neutral family, one signal family and one accent family
per figure, and a condition keeps its color in every panel. The first panel of
Fig. 1 usually defines the vocabulary -- colors, symbols, direction, scale --
for everything after it. Blue for the proposed method, green for positive
variants, red for baselines and neutral for reference is a workable default.
Reserve green and red for gains, drops and signed direction. Reduce saturation
before adding categories.

Statistics belong in the figure, not in caption cleanup: `n`, replicate
definition, center, spread, test, correction, and the exact comparison. Use one
uncertainty definition across comparable panels or state the exemption. When
units are matched by subject, seed or split, plot paired differences;
between-unit spread can hide a strong paired effect behind overlapping
marginals.

Image integrity is equally part of the figure: crop, contrast, pseudo-color,
stitching, reuse and scale calibration. Global adjustments are safer than local
edits. Flag any adjustment that changes the visibility of relevant background
or bands.

### Physical and typographic specs

| Spec | Value |
|------|-------|
| Single-column width | about 89 mm |
| Double-column width | about 183 mm |
| Minimum rendered glyph | 5 pt, no exceptions |
| Body, tick and legend text | 7-9 pt for dense multi-panel at publication width |
| Panel letters | about 8 pt, lowercase, bold, top left |
| Axis line width | 0.8-1.2 pt |
| Plot line width | 2-3 pt |
| Marker size | 8-12 pt |
| Raster DPI | 300, or 600 for dense panels |

Fonts: sans-serif, Arial or Helvetica, which is the Nature standard. DejaVu
Sans and Liberation Sans are the metric-compatible substitutes on Linux. Set
`svg.fonttype='none'` before any `savefig`; `'path'` converts glyphs to
outlines and destroys editability.

The 5 pt floor is easy to breach by accident. Mathtext renders scripts at about
0.7 of the parent, so a 7 pt `$R^2$` yields a 4.9 pt superscript. Prefer a
Unicode glyph or raise the parent size.

Sequential light-to-dark encodes order or magnitude only, never unrelated
categories. Diverging is for signed deviation. For grayscale printing add
hatches rather than relying on hue alone.

SVG or PDF is the primary export and is saved first. PNG is secondary, for
previews and submission portals.

### Multi-panel architecture and legends

**One figure, one claim.** A figure answers one Results-level question. A panel
that establishes a separate major claim belongs in another figure; a panel that
can disappear without weakening the inference should be merged, demoted to
Extended Data, or deleted.

**Panels take inferential roles, not just different metrics.** Choose the
smallest sufficient set from: setup or schematic, representative example,
primary quantitative evidence, baseline or control, decomposition,
stratification, orthogonal validation, perturbation or stress test, boundary or
failure case, mechanistic evidence. Four panels showing R2, R2 tests, MAPE and
MAPE tests are two roles, not four. A second metric does not earn a main panel
by being another metric.

**Order panels so the claim escalates:** establish, then compare or control,
then stress-test, then broaden, then bound. Use only the moves the claim needs.
Across figures, each one should answer the question the previous one raised.

**Prominence tracks argument weight.** Give decisive evidence the hero position
or the largest area, and keep controls quieter but still large enough to judge.
Do not force equal panel sizes when inferential importance differs, and do not
add a schematic panel out of habit. Make a negative result or failure boundary
visible whenever it changes the figure-level claim.

Panel letters mark reading order only and carry no fixed function: panel `a`
need not be a schematic.

**Legends** follow a fixed skeleton: `Fig. N |`, then a bold noun-phrase title,
then per-panel descriptions in present-tense telegraphic style, then the
statistics (`n =`, error type, test, correction), then data availability.
Present tense for what is shown, past tense for how it was made.

A legend must be self-contained and readable away from the body text: color and
shape mappings, sample size and key numeric anchors all live there. It must not
put results in the title line, and must not replay the Results argument.

Preserve canonical capitalization exactly: `XGBoost`, `RF`, `GPT-5.2`. Never
apply automatic title-casing, which corrupts them.

Legend length: below 250 words for flagship *Nature*, and 150-250 words for
*Nature Machine Intelligence*. No cap is established here for *Nature
Communications* or other subjournals, so check the live instructions for the
target venue.

### Rendered QA

Inspect panel by panel at final physical size, then the whole figure. Never
approve from a whole-page glance.

1. **Role.** Each panel answers a unique question. Cover it mentally: if the
   argument survives, merge or remove it.
2. **Legibility.** Every glyph at least 5 pt in the exported file, superscripts
   and subscripts included.
3. **Panel labels.** Consistent anchor across rows and columns. Offset them by
   fixed points from the axes corner, not by an axes fraction, which displaces
   differently on tall and short panels.
4. **Alignment.** Panels in a row share top and bottom edges and plot-area
   height; panels in a column share left and right edges and width; equal-span
   panels in a row share width; repeated gutters are uniform.
5. **Collisions.** No text overlapping text, and none crossing a line, marker
   edge or error bar. Nothing clipped at the page edge. Do not mask a crossing
   with an opaque white box; move the label outside the local data envelope and
   recompute clearance after adding error bars.
6. **Comparability.** Axes, terminology, uncertainty and color mapping
   consistent across panels that invite comparison. Remove arrows or brackets
   that encode the same gap as an error bar.
7. **Hierarchy.** After rendering, confirm the hero series is more salient than
   the neutral baselines. Check grayscale and color-vision robustness.
8. **Images.** Scale bar present and calibrated, not merely a magnification
   factor. Raster resolution adequate at final size; line art vector.
9. **Export.** Open the PDF or SVG: text selectable rather than outlined,
   nothing overlapping, still readable at final printed size.

---

## Tufte's principles

From *The Visual Display of Quantitative Information* (1983).

### 1. Graphical Excellence

Excellence in statistical graphics consists of complex ideas communicated with clarity, precision, and efficiency.

**Core qualities:**
- Show the data
- Induce the viewer to think about substance, not methodology or design
- Avoid distorting what the data have to say
- Present many numbers in a small space
- Make large datasets coherent
- Encourage eye comparison of different pieces of data
- Reveal data at several levels of detail (broad overview to fine structure)
- Serve a reasonably clear purpose
- Integrate closely with statistical and verbal descriptions

**Questions to ask:**
- Does the graphic show the data clearly?
- Does it encourage thinking about content over decoration?
- Can the viewer compare data elements easily?

### 2. Graphical Integrity

Graphics must tell the truth about the data.

**The Lie Factor:**
```
Lie Factor = Size of effect shown in graphic / Size of effect in data
```
- Lie Factor = 1.0: Truthful
- Lie Factor > 1.05 or < 0.95: Distortion

**Six principles of graphical integrity:**
1. Representation of numbers should be directly proportional to quantities represented
2. Clear, detailed, thorough labeling defeats distortion
3. Show data variation, not design variation
4. In time-series displays, standardize money (deflate) and use consistent baselines
5. Dimensions of graphics should not exceed dimensions of data
6. Graphics must not quote data out of context

**Common violations:**
- 3D effects on 2D data (adds fake dimension)
- Truncated axes that exaggerate change
- Inconsistent intervals
- Area/volume encoding of linear data
- Missing context or baselines

### 3. Data-Ink Ratio

The data-ink ratio is the proportion of a graphic's ink devoted to the non-redundant display of data-information.

```
Data-Ink Ratio = Data-ink / Total ink used in graphic
```

**Maximize the data-ink ratio within reason:**
1. Erase non-data-ink (decoration, heavy grids, boxes)
2. Erase redundant data-ink (3D when 2D suffices)
3. Revise and edit

**Non-data-ink to eliminate:**
- Heavy gridlines
- Unnecessary borders and boxes
- Redundant labels
- Decorative elements
- Excessive tick marks
- 3D effects that add no information

**The eraser test:** If you can erase something without losing data information, erase it.

### 4. Chartjunk

Chartjunk is the interior decoration of graphics that does not convey information.

**Three categories of chartjunk:**

#### A. Unintentional optical art (moire vibration)
- Busy patterns that create visual noise
- Cross-hatching that vibrates
- Competing visual frequencies

#### B. The Grid
- Heavy grids compete with data
- Grids should be muted or eliminated
- If needed, use light gray or dotted lines

#### C. The Duck (self-promoting graphics)
- Graphics that draw attention to their own design
- Decoration masquerading as information
- Style over substance

**Chartjunk indicators:**
- Viewer notices the design before the data
- Colors/patterns used for decoration not encoding
- 3D effects, shadows, gradients without purpose
- Clip art, icons, or illustrations that don't carry data

### 5. Small Multiples

Small multiples are series of graphics showing the same combination of variables, indexed by changes in another variable.

**Characteristics:**
- Same design structure repeated
- Changes in data, not design
- Enables direct visual comparison
- High information density
- Eye moves across variations effortlessly

**When to use:**
- Comparing across categories, time periods, or conditions
- Showing change or variation
- Revealing patterns across groups
- When animation would work but static display is needed

**Design guidelines:**
- Identical scales across all panels
- Consistent visual encoding
- Minimal between-panel decoration
- Clear labeling of what varies
- Tight spacing (data should dominate)

### 6. Data Density & Information Resolution

**Data density = numbers plotted per unit area**

High data density is a sign of graphical quality. Maps and time-series can achieve thousands of numbers per square inch.

**Shrink principle:** Graphics can often be reduced significantly while maintaining readability and gaining impact. Consider:
- Sparklines (word-sized graphics)
- Condensed time-series
- Small multiple arrays

**Resolution thinking:**
- What's the minimum size that remains readable?
- Can we show more data in the same space?
- Are we wasting white space?

### 7. Multifunctioning Graphical Elements

Every graphical element should serve multiple purposes when possible.

**Data measures that can serve as:**
- Data point
- Label
- Scale marker
- Grid reference

**Examples:**
- Data points that also serve as labels (scatter plots with text)
- Axis that is also a data series
- Range frames (axis shows data range, not arbitrary extent)

### 8. Aesthetics and Technique

**Balance complexity and simplicity:**
- Simple design, complex data
- Complexity should come from data, not decoration

**Visual hierarchy:**
- Data > Labels > Annotations > Grids > Borders
- Prominent elements should carry the most information

**Color use:**
- Use sparingly and purposefully
- Ensure accessibility (colorblind-safe)
- Gray as default, color for emphasis or encoding
- Avoid "rainbow" color maps for sequential data

**Typography:**
- Clear, readable fonts
- Appropriate sizing hierarchy
- Horizontal text when possible
- Labels close to data they describe

### Quick Reference: The Tufte Test

For any visualization, ask:

1. **Data-Ink:** Can I erase any element without losing data? (Erase it)
2. **Integrity:** Does the visual effect match the data effect? (Lie Factor approx 1)
3. **Chartjunk:** Does any element exist for decoration only? (Remove it)
4. **Excellence:** Does it reveal the data at multiple levels? (Broad + detailed)
5. **Comparison:** Can the viewer easily compare data elements? (Enable it)
6. **Density:** Could this show more data in the same space? (Condense)
7. **Context:** Is all necessary context provided? (Labels, sources, scales)

---

## Analytical design, sparklines, and layering

Extends the principles above with material from *Envisioning Information*
(1990), *Visual Explanations* (1997), and *Beautiful Evidence* (2006).

Consult when designing dashboards, dense displays, sparklines, or explanatory
graphics.

### 1. The Six Principles of Analytical Design

From *Beautiful Evidence*. The most actionable framework Tufte produced -- applies to any analytical presentation, not just charts.

1. **Show comparisons, contrasts, differences**
   The fundamental analytical act. Every display should answer "compared to what?"

2. **Show causality, mechanism, structure, explanation**
   Move beyond description. What's the *why* behind the pattern?

3. **Show multivariate data -- more than 1 or 2 variables**
   Real problems are multivariate. Reducing to a single variable hides interactions.

4. **Completely integrate words, numbers, images, diagrams**
   Don't segregate by mode. Labels next to the data they describe; equations next to the curves they generate.

5. **Thoroughly describe the evidence**
   Provenance, authorship, scales, sources, measurements. Documentation enables trust.

6. **Analytical presentations ultimately stand or fall depending on the quality, relevance, and integrity of their content.**
   No amount of design fixes weak evidence. Content is paramount.

**Use in critique:** walk through all six. The lowest-scoring principle is usually the biggest improvement opportunity.

### 2. Sparklines

Word-sized, data-intense graphics. Tufte's signature *Beautiful Evidence* invention.

**Defining properties:**
- Typographic resolution -- sized like text, embedded inline with prose or tables
- No axes, no labels, no decoration
- Endpoints often marked (start/end values, or min/max)
- Reveals shape, trend, variability at a glance

**Design rules:**
- Height approx x-height of surrounding text (~14-20px)
- Length approx a word or short phrase
- Use a single red/colored dot to flag a key point (current value, anomaly)
- Pair with the most recent numeric value: `120 ▁▂▃▅▇▇▆▅ 132`
- Stack in tables so eyes can scan vertically

**When to use:**
- Dashboards with many metrics (one row per metric: name | sparkline | current | delta)
- Inline prose: "revenue trended up ▁▂▄▆▇ over the quarter"
- Anywhere a full chart would dominate but trend matters

**When not to use:**
- When precise readings matter -- sparklines show shape, not value
- For categorical or part-to-whole data

### 3. Layering and Separation

From *Envisioning Information*. The most useful concept for dense displays.

**The principle:** Visually distinct elements can coexist in the same space if they're *layered* -- separated by value, weight, hue, or transparency rather than spatial isolation.

**Techniques:**
- **1+1=3 effect:** two heavy lines next to each other create a phantom third line. Lighten one to suppress this.
- **Hierarchy by weight:** primary data in dark/saturated; secondary in light gray; annotations even lighter.
- **Color for separation, not decoration:** distinct hues let overlapping data remain readable.
- **Whisper, don't shout:** grids, axes, reference lines should fade into the background -- present but unobtrusive.

**Test:** squint at the graphic. The most important data should remain visible; chartjunk should disappear first.

### 4. Micro/Macro Design

Distinct from raw data density. A micro/macro graphic reveals **different stories at different viewing distances**.

- **Macro view** (zoomed out, peripheral): overall pattern, shape, trend
- **Micro view** (close inspection): individual data points, labels, exceptions

**Canonical examples:**
- Vietnam Memorial: macro = sweep of names; micro = a single name
- Galaxy maps: macro = structure; micro = individual stars
- Financial tables with sparklines: macro = which rows trended up; micro = the actual values

**Design implication:** don't choose between overview and detail -- show both simultaneously by layering.

### 5. Escaping Flatland

The 2D page/screen is inherently flat; good information design adds dimensions *without* 3D gimmicks.

**Dimensions you can add on flat media:**
- Color (categorical or sequential)
- Size (continuous)
- Shape (categorical)
- Position (2-3 axes via projection)
- Time (small multiples, animation, or sparkline-style inline series)
- Layering (foreground/background via value)

**Anti-pattern:** 3D bar charts, pie charts with depth, isometric projections that distort proportions. These add visual dimension without adding information dimension -- pure chartjunk.

### 6. Range-Frame and Dot-Dash Plot

Tufte's signature reinventions of standard chart elements. Direct applications of data-ink maximization.

**Range-frame:**
- Replace the full axis with a line that spans only the *range of actual data*
- Axis ends at min/max values, not arbitrary round numbers
- Tells the viewer the data extent without explicit annotation

**Dot-dash plot:**
- Scatter plot where the axes are replaced by marginal rug plots
- Each axis becomes a 1D distribution of the data on that variable
- Same ink, more information -- the axes now show marginal density

**Pattern:** every standard chart element (axis, tick, gridline) can be redesigned to carry data.

### 7. Confections, Parallelism, Narrative

From *Visual Explanations*.

**Confections:** assemblages of disparate visual elements (images, maps, text, diagrams) into a single explanatory composition. Examples: Minard's Napoleon march, Snow's cholera map, exploded technical illustrations. They work when each element serves the argument.

**Parallelism:** repetition of visual structure to enable comparison -- small multiples are one form, but parallelism extends to side-by-side maps, before/after states, repeated annotation styles.

**Narrative graphics of space and time:** combine spatial and temporal dimensions in one frame. Minard's Napoleon graphic encodes troop size, geography, direction, temperature, and time simultaneously.

### 8. Cause and Effect

From *Visual Explanations*. Causality is hard to visualize because it requires showing both the variables and the mechanism linking them.

**Techniques:**
- Show the intervention and the response in the same frame
- Annotate the causal mechanism directly on the data
- Use sequence (small multiples through time) to imply mechanism
- Pair the data display with a process diagram showing the proposed cause

**Worked example:** Challenger O-ring decision. The available data, plotted against temperature, showed catastrophic risk -- but the engineers presented it in a way that hid the causal relationship. Tufte's redesign makes the causality unavoidable.

### Quick Reference: Extended Tufte Test

After applying the standard 7-question test above, add:

8. **Comparison:** Does the graphic answer "compared to what?"
9. **Causality:** Is the mechanism or explanation visible, not just the pattern?
10. **Multivariate:** Are interactions among variables shown, or has the problem been over-reduced?
11. **Integration:** Are words, numbers, and images interleaved -- or segregated?
12. **Documentation:** Can a stranger evaluate the evidence (sources, scales, authorship)?
13. **Layering:** Do important elements dominate; do secondary elements recede?
14. **Micro/macro:** Does the display reward both a glance and a close read?

## Quick checklist

- [ ] Lie Factor approx 1.0 (no visual distortion)
- [ ] Maximum data-ink ratio
- [ ] Zero chartjunk
- [ ] Clear labeling
- [ ] Answers "compared to what?"
- [ ] Shows causality or mechanism where relevant
- [ ] Multivariate (not over-reduced)
- [ ] Words, numbers, images integrated, not segregated
- [ ] Reveals multiple levels of detail (micro + macro)
- [ ] Layering: primary data dominates, secondary recedes
- [ ] Appropriate data density
- [ ] Consistent with the personal preferences above
- [ ] For a submission: contract written, 5 pt floor held, panels aligned,
      legend self-contained
