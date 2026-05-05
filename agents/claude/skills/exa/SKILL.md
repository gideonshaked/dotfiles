---
name: exa
description: "Search the web using Exa."
when_to_use: "Use when the user wants to search the web, look something up, verify current information, or find sources online."
argument-hint: "<search query>"
allowed-tools:
  - mcp__exa__web_search_exa
  - mcp__exa__crawling_exa
---

Search the web using Exa and summarize the results.

## Steps

1. Call `mcp__exa__web_search_exa` with the query set to `$ARGUMENTS` exactly as provided. Do not rephrase, expand, or reinterpret the query. Use `numResults: 5`.

2. Synthesize the results into a concise summary. Focus on answering the user's implicit question. Cite sources with titles and URLs.

3. If the highlights are insufficient for a good answer, follow up with `mcp__exa__crawling_exa` on the most promising URL(s) to get full content, then revise your summary.
