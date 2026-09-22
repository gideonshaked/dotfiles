Stage 4b: cluster the prose corrections into themes. Mechanical, not editorial.

Input:  by_domain/prose_rules.txt   (one rule per correction, with the human's quote)
        by_domain/prose.jsonl       (full rows, for context when a rule is ambiguous)
Output: themes.json

Steps:
1. Read prose_rules.txt in full. Every line. Do not sample.
2. Group rules that enforce the same standing preference. A theme is one
   preference a writer could obey next time, such as "state the number, not
   an adjective about the number" or "no forward references to later
   sections". Aim for the natural number of themes, not a target; a theme
   with one occurrence is still a theme.
3. For each theme write:
     {"theme": "<imperative, one sentence>",
      "count": <int, number of corrections in it>,
      "max_severity": <1-3>,
      "ns": [<n values>],
      "quotes": [<2 to 4 verbatim human quotes from the input, the most
                 specific ones, with their n in brackets>],
      "before_after": <one concrete example if the rows show what Claude
                       wrote and what the human wanted instead, else null>}
4. Sort by count descending. Write the JSON array to themes.json.
5. Validate: every n in the input appears in exactly one theme. Print the
   count of themes and the count of ns covered versus input lines.

Do not paraphrase quotes. Do not add themes the input does not support. Do
not write the skill; that is a later stage.
