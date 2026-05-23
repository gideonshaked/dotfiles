---
name: tufte-viz
description: "Ideate and critique data visualizations using Edward Tufte's principles, blended with the user's personal plotting preferences."
when_to_use: "TRIGGER when: designing a new chart, dashboard, or report; critiquing or improving an existing visualization; choosing between visualization approaches; reducing chartjunk or improving data-ink ratio; planning small multiples or high-density displays."
allowed-tools:
  - Read
  - Bash
effort: medium
---

# Tufte Visualization Ideation

Apply Edward Tufte's principles to design clear, honest, high-density data visualizations, layered with the user's house style.

## First step: load preferences

ALWAYS read `preferences.md` in this skill directory before producing or critiquing a chart. The user's preferences override generic Tufte defaults wherever they conflict, except on graphical integrity (lie factor, honest scales, etc.), which is non-negotiable.

## Workflow

### For new visualizations

1. **Clarify the data story**
   - What comparisons matter?
   - What is the key insight to communicate?
   - Who is the audience?

2. **Select an approach** using Tufte principles plus the user's preferences:
   - High comparison need -> small multiples
   - Dense data -> data tables, sparklines
   - Time series -> line charts with minimal grid
   - Part-to-whole -> avoid pie charts; prefer bar or table

3. **Design with data-ink in mind**
   - Start minimal, add only what is necessary
   - Every element must earn its ink
   - Default to grayscale; use color purposefully (subject to `preferences.md`)

4. **Apply the Tufte test** (see `references/tufte-principles.md`)

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

4. **Suggest improvements** with specific before/after recommendations, aligned with `preferences.md`.

## References

- `preferences.md` -- the user's house style. Load first; it overrides generic guidance where it conflicts (except integrity).
- `references/tufte-principles.md` -- core principles from *The Visual Display of Quantitative Information*: lie factor, data-ink, chartjunk, small multiples, integrity.
- `references/analytical-design.md` -- extensions from *Envisioning Information*, *Visual Explanations*, and *Beautiful Evidence*: the six principles of analytical design, sparklines, layering and separation, micro/macro, range-frames, causality, confections. Load when designing dashboards, dense displays, sparklines, or explanatory graphics.

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
- [ ] Consistent with `preferences.md`
