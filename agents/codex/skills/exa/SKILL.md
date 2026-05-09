---
name: exa
description: "Search and fetch current web content using the configured Exa MCP server. Use when the user asks to search the web, look something up, verify current information, find sources, crawl a page, or use Exa specifically."
allowed-tools:
  - mcp__exa__web_search_exa
  - mcp__exa__crawling_exa
metadata:
  short-description: Search the web with Exa
---

# Exa

Use the configured Exa MCP server for web search and source retrieval.

## Steps

1. Call the Exa web search tool with the user's query exactly as provided. Use `numResults: 5` unless the user asks for a different count.

2. Synthesize the results into a concise answer focused on the user's question. Cite source titles and URLs.

3. If snippets are not enough, call the Exa crawling/fetch tool on the most relevant URL or URLs, then revise the answer with the fetched content.

## Rules

- Do not silently switch to generic web search if Exa tools are available.
- If the Exa MCP tools are missing in the current session, tell the user Codex likely needs to be restarted after the Exa MCP config change.
- Do not invent citations. Only cite returned or fetched sources.
