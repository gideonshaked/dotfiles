---
name: writing
description: Use when drafting or editing any prose or copy — reports, research write-ups, guidance, documentation, READMEs, emails, announcements, summaries, blog posts, marketing or product copy, or any text meant to be read. Triggers whenever the user asks to draft, write, rewrite, or polish copy. Applies GOV.UK / GDS house style, favoring plain English, active voice, front-loaded content, sentence case, and no bold or italics for emphasis.
user-invokable: true
args:
  - name: target
    description: The document or text to write or rewrite in this style (optional)
    required: false
---

Open the content up so anyone can understand it the first time they read it — without losing any of the substance, nuance or precision. The goal is to open up, not to dumb down. This skill applies the GOV.UK style guide and the Government Digital Service (GDS) content design principles. It is based on the GOV.UK A to Z style guide and writing guidelines (guidance.publishing.service.gov.uk).

Apply it to reports, research write-ups, guidance and any prose meant to be read. When you write a report, default to this style. When you brief a research agent, pass this skill so its report follows the same style.

## Content design principles

- Start from the user need. Write what the reader needs to know to do or decide something, not what you want to say.
- Front-load everything. Put the most important point first — in the document, each section, each paragraph and each sentence. Use the inverted pyramid: conclusion first, then detail, then background.
- One idea per sentence. One topic per paragraph. If a sentence has more than one idea, split it.
- Be specific and concrete. Give the number, the name, the date. Cut vague abstractions ("a range of", "going forward", "in terms of").
- Cut everything that does not add meaning. Shorter is clearer. Remove duplication.

## Structure paragraphs with MEAL

When a paragraph makes a point or builds an argument, follow the MEAL pattern. It keeps each paragraph to one idea and ties it back to the thesis. Skip it for short instructions, lists or pure reference, where it adds nothing.

- Main idea: open with a topic sentence that states the paragraph's single point.
- Evidence: give the facts, data, examples or quotations that support it.
- Analysis: explain what the evidence shows and why it matters. Do not leave it to speak for itself.
- Link: close by tying the point back to the thesis of the piece, or leading into the next paragraph.

This fits front-loading: the main idea leads, and the link carries the reader on.

## Plain English

- Open it up, do not dumb it down. Keep all the substance, nuance and precision. Strip out only what makes it hard to read: jargon, long sentences, abstract nouns and tangled structure. A non-specialist and an expert should both grasp it on first read. Plain English carries complex ideas better, not worse — even experts read faster and prefer it.
- Use the active voice. Say who does what. Write "We reviewed the data", not "The data was reviewed".
- Keep sentences short — about 15 to 20 words, never more than about 25. Keep paragraphs short.
- Use everyday words. Replace jargon and "government-speak" with plain alternatives:
  - use, not utilize or leverage
  - help, not facilitate or empower
  - work with, not collaborate, liaise or engage with
  - make or provide, not deliver
  - about, not in relation to or with regard to
  - so, not in order to
  - start, not commence; end, not terminate; buy, not purchase; enough, not sufficient
  - solve, fix or deal with, not tackle or combat
  - effect on, not impact on (do not use impact as a verb)
- Avoid metaphors and clichés: drive, unlock, deep dive, robust, key, ring-fence, hub, portal, landscape, ecosystem, going forward.
- Address the reader as "you". Write about yourself or the organization as "we". Use "they", "them" and "their" rather than gendered pronouns. Write "disabled people", not "the disabled".
- Contractions are fine for a warmer tone (we'll, you'll), but avoid negative contractions — write "cannot", not "can't" — and avoid "should've", "could've", "would've".

## Formatting

- Do not use bold or italics for emphasis. Plain words and good structure carry the meaning. Bold is only acceptable to name a literal interface element in an instruction, for example: select Save. Use single quotation marks for the titles of schemes or documents, not italics.
- Use sentence case everywhere — headings, titles, table headers, the lot. Capitalize only proper nouns.
- Headings: front-load them, keep them under about 65 characters, make them unique and descriptive. No period, dash, slash or question mark. Use them to let people skim.
- Bullet points: introduce the list with a lead-in line that ends in a colon. Start each bullet lowercase. Keep each to one idea. No "and"/"or" after each item, no semicolons, no period after the last bullet (unless a bullet is itself a full sentence).
- Numbered steps: use a numbered list only for a sequence the reader follows in order. Steps are full sentences and end with a period. No lead-in colon needed.
- Links: use descriptive link text that says where the link goes — front-load the key words. Never write "click here" or "read more". The link text should make sense out of context.
- Do not use Latin abbreviations. Write "for example" not "eg", "that is" not "ie", "and so on" or "such as" not "etc". They confuse screen readers and some readers.
- Ampersands: write "and", not "&" (except in a registered name or logo).
- Numbers: write "one" but use numerals from 2 upwards (2, 9, 25). Use the % symbol with numerals (50%). Use $ with no decimals unless there are cents ($75, $75.50). Spell out millions and billions ($5 million, not $5m). Write ranges with "to", not a hyphen (10 to 20, Monday to Friday).
- Dates and times: write "June 4, 2026" (no "th"). Use "to" for ranges ("June 4 to June 8"). Write times as "10am to 11:30am"; use "midday" and "midnight".
- Do not use FAQs. If you have answered the user need in the content, you do not need them. Do not use exclamation marks. Do not use ALL CAPS for emphasis.

## Avoid the LLM voice

Large language models share a set of writing tics that practiced readers now recognise. They are defaults the model reaches for, not choices, and they make the text read as machine-written. Cut them so the real content shows. Rewrite the underlying sentence rather than deleting a flagged word.

- Do not lean on em dashes, colons and semicolons. Models bolt a qualifying clause into the middle of a sentence with an em dash, and introduce yet another list with a colon. The frequency is the tell, not any single mark. Split the thought into two sentences or use a comma. Keep em dashes to about one per few hundred words.
- Drop the "it's not X, it's Y" frame, and its cousin "not just X, but Y". State Y on its own. Write "This is a betrayal of trust.", not "This isn't a price rise, it's a betrayal of trust". The contrast sounds profound and commits to nothing.
- Cut jargon used for its own sake. Models reach for an elevated register: delve, nuanced, multifaceted, comprehensive, pivotal, leverage. If a word does not carry meaning the reader needs, remove it or swap it for a plain one. See the plain English section.
- Do not narrate your own process or refer back to earlier decisions. Cut "as I mentioned", "as we decided earlier", "as established above", "building on the previous section". The reader sees the document as it stands now, not the path that produced it. Make the point without flagging that you are about to, or that you made it before.
- Do not stack qualifiers. A model hedges twice before it reaches the verb: "while this may vary, generally speaking, in most cases". One qualifier reads as careful. A chain of them reads as a machine dodging commitment. Keep one genuine hedge or none.
- Take a position. Asked for a recommendation, models tend to lay out every side and settle on a safe middle. If one option is better, say so and say why. False balance reads as evasion.
- Do not over-structure. Models default to headings, numbered lists and a paragraph per bullet for everything. Use a list only when the content is genuinely a list. Otherwise write prose.
- Delete throat-clearing openers. "It's worth noting that", "it's important to note", "in today's fast-paced world". Start with the substance. Write "Revenue dropped 15% in Q3", not "It's worth noting that revenue dropped 15% in Q3".
- Replace hollow transitions. "Moreover", "furthermore", "additionally". Most can be a period, an "and" or an "also". If the link between two sentences is unclear without a formal connector, fix the logic, not the connector.

## Before you finish: self-check

- Is the single most important thing first?
- Could a non-expert understand every sentence on first read?
- Is every sentence active, short and one idea?
- Have you removed all bold/italic emphasis, jargon, Latin abbreviations and marketing language?
- Is everything in sentence case, with descriptive headings and links?
- Have you cleared the LLM tics: dense punctuation, "not X but Y", jargon, self-reference to earlier decisions, stacked qualifiers, false balance and throat-clearing openers?
- Could you cut any more words without losing meaning? If yes, cut them.

## Note on this skill's own scope

The "no bold" and formatting rules apply to the prose you produce (reports, guidance, summaries). Code, data tables and direct quotations keep their own conventions. Markdown headings and lists are fine — they are structure, not emphasis.
