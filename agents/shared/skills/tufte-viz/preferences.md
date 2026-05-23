# Personal Plotting Preferences

Personal overrides and house style for data visualization. These take precedence over the generic Tufte references when they conflict, but should not contradict graphical integrity (lie factor, honest scales, etc.).

## Stack and tooling

- Python: prefer seaborn over matplotlib-only, pandas .plot, plotly, or other alternatives. Drop down to matplotlib only for fine-grained control seaborn cannot give.
- R: prefer ggplot2 over base R graphics or lattice. Stay in the tidyverse/ggplot grammar; reach for extensions (patchwork, ggrepel, cowplot) before reverting to base R.
- Before writing non-trivial plotting code, use Context7 (`resolve-library-id` then `query-docs`) to confirm current API for the chosen library. Do not rely on memory for argument names or defaults.

## Typography

- **Titles are never bold.** This is the most common offender and the strictest version of the no-bold rule. Plot titles, axis titles, and facet/panel titles all stay at regular weight (e.g., in seaborn/matplotlib never pass `fontweight="bold"`; in ggplot2 do not set `face = "bold"` in `element_text` for titles, and override any theme default that does).
- No bold anywhere else either: axis labels, tick labels, annotations, legend titles, captions. Use weight only when it carries information (e.g., highlighting one series among many), not for emphasis.
- No stacked subtitles or stat-strips on the plot itself for things like Pearson r, Spearman rho, n, p-values, R^2. Those belong in the figure caption or accompanying slide bullets, not as a subtitle.

## Axes, grids, frames

- Drop the top and right spines on regression plots, dot plots, line plots, and similar Cartesian plots. Keep only the bottom and left spines.
- No horizontal or vertical rules across the plotting area unless they genuinely enhance viewer clarity (e.g., a reference line at y=0, a meaningful threshold, a date marker that the reader needs to locate). Default is no rules.

## Chart-type defaults

- Barplots: always print the exact value of each bar on top of (or just above) the bar. This is a specific exception to the general "no on-plot text" rule; bar height is hard to read precisely, so the number earns its ink.

## Annotation and labeling

- No added text on the plot unless it serves a specific purpose. Rule of thumb: the text must need to be on the plot to add something.
  - Good: a label next to a circled point of interest; identifying an outlier; calling out a regime change directly on the data it refers to.
  - Bad: pasting the Pearson r, n, or model coefficients onto the plotting area as standalone text.
  - Exception: in many-paneled / faceted plots, per-facet stats on the panel can be the cleanest place for them, since the caption cannot speak to each panel individually.
- Prefer direct labels on series over a separate legend when there are few series.
- Statistical summaries (r, rho, n, p, R^2) live in the figure caption or surrounding prose by default.

## Output and sizing

- Always render and export figures at 300 DPI. In matplotlib/seaborn, set both `figure.dpi` and `savefig.dpi` (e.g., `plt.rcParams.update({"figure.dpi": 300, "savefig.dpi": 300})`) so on-screen and saved figures match.

## Anti-preferences

- No bold text for emphasis.
- No subtitles used as stat-strips.
- No top/right spines on standard 2D plots.
- No horizontal/vertical rules without a clarity reason.
- No on-plot text that does not need to be on the plot.
