---
name: writing
description: Use when drafting or editing any prose or copy — reports, research write-ups, guidance, documentation, READMEs, emails, announcements, summaries, blog posts, marketing or product copy, or any text meant to be read. Triggers whenever the user asks to draft, write, rewrite, or polish copy. Applies GOV.UK / GDS house style, favoring plain English, active voice, front-loaded content, sentence case, and no bold or italics for emphasis. Balances that house style against ASD-STE100 Simplified Technical English, then runs Orwell's rules from 'Politics and the English Language' over the result. Simplified Technical English stays on for all prose unless the author explicitly asks for it to be switched off, and Claude announces that it is in use and offers to switch it off. Triggers on requests to simplify or disambiguate text, or for an STE100 rewrite.
user-invokable: true
args:
  - name: target
    description: The document or text to write or rewrite in this style (optional)
    required: false
---

Open the content up so anyone can understand it the first time they read it — without losing any of the substance, nuance or precision. The goal is to open up, not to dumb down. This skill applies the GOV.UK style guide and the Government Digital Service (GDS) content design principles. It is based on the GOV.UK A to Z style guide and writing guidelines (guidance.publishing.service.gov.uk).

Apply it to reports, research write-ups, guidance and any prose meant to be read. When you write a report, default to this style. When you brief a research agent, pass this skill so its report follows the same style.

Three separate bodies of guidance sit below, kept apart so you can see which is which: the GOV.UK house style, ASD-STE100 Simplified Technical English, and Orwell's rules from 'Politics and the English Language'.

## How the sources fit together

Two standards set the text. Orwell then judges the result.

The GOV.UK house style and Simplified Technical English both apply while you draft, at the same time. They agree far more than they disagree, because both exist to stop a reader misreading a sentence. Where they pull apart, balance them with your own judgement. Do not look for a rule that settles it for you, and do not pick one and drop the other.

Orwell sits above both. Run his rules, his four habits and his questions over whatever the balance produced, and let them correct it. Where a sentence satisfies both standards and still reads badly, Orwell wins. That is what his sixth rule is for. Run the LLM voice section as part of the same pass.

### Simplified Technical English stays on

Keep Simplified Technical English on unless the author explicitly tells you not to use the standard. Do not switch it off on your own judgement. A piece being marketing copy, a blog post or a research write-up is not a reason to turn it off.

Announce it in one line alongside the text, then offer to switch it off. For example: "Written to the GOV.UK house style and ASD-STE100 Simplified Technical English. Tell me if you want STE switched off."

Switch it off only when the author says so, in words such as "do not use Simplified Technical English", "drop STE" or "no STE100". A general request for warmer, punchier or more persuasive copy is not enough on its own, though it is a good moment to offer. Ask, then wait for the answer.

Simplified Technical English is deliberately flat and literal. When the text is the kind where voice carries part of the meaning, say that in your announcement so the author can decide. Do not decide for them.

### Balancing the two standards

- Register. The house style allows contractions and a warm second person. Simplified Technical English is flat and literal. Lean flat for instructions, procedures, error messages and anything a downstream agent parses. Lean warm for prose a person reads by choice, and keep the Simplified Technical English discipline on word choice and sentence structure while you do.
- Structure. Simplified Technical English wants a vertical list for any sequence of 3 or more steps or conditions. The LLM voice section warns against over-structuring. Use a list when the content really is a sequence or a set of conditions. Use prose when it is an argument.
- Sentence length. Take the tighter of the two caps. That is about 20 words for anything instructional, and about 25 at the outside for description.
- Vocabulary and tense. Where Simplified Technical English is stricter, follow it. Pick one term per idea and reuse it rather than rotating synonyms, and prefer simple tenses. Neither costs the reader anything.

### When a word choice is questioned

`references/verbs.md` holds the verb and word choice reference. It carries the full GOV.UK list of words to avoid with their plain replacements, the Simplified Technical English rules on verb form and consistency, and a procedure for settling a disputed word.

Read it when the author questions a word you used, asks why you chose it, or challenges the register. Do not open it on every draft, because the plain English section below covers the common cases. Reach for it when a specific choice is in dispute, and quote the rule that settles it rather than restating your preference. If no rule settles it, say the choice was a judgement call and defer to the author rather than inventing an authority.

## GOV.UK house style

### Content design principles

- Start from the user need. Write what the reader needs to know to do or decide something, not what you want to say.
- Front-load everything. Put the most important point first — in the document, each section, each paragraph and each sentence. Use the inverted pyramid: conclusion first, then detail, then background.
- One idea per sentence. One topic per paragraph. If a sentence has more than one idea, split it.
- Be specific and concrete. Give the number, the name, the date. Cut vague abstractions ("a range of", "going forward", "in terms of").
- Cut everything that does not add meaning. Shorter is clearer. Remove duplication.

### Structure paragraphs with MEAL

When a paragraph makes a point or builds an argument, follow the MEAL pattern. It keeps each paragraph to one idea and ties it back to the thesis. Skip it for short instructions, lists or pure reference, where it adds nothing.

- Main idea: open with a topic sentence that states the paragraph's single point.
- Evidence: give the facts, data, examples or quotations that support it.
- Analysis: explain what the evidence shows and why it matters. Do not leave it to speak for itself.
- Link: close by tying the point back to the thesis of the piece, or leading into the next paragraph.

This fits front-loading: the main idea leads, and the link carries the reader on.

### Plain English

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

### Formatting

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

## Simplified Technical English

ASD-STE100 is a controlled-language standard built by the aerospace and defense industry (ASD, the AeroSpace and Defense Industries Association of Europe) to stop maintenance technicians from misreading English instructions. The standard removes the two biggest sources of misreading: words with more than one meaning, and sentences with more than one possible structure.

This skill borrows that same discipline for a different reader: an AI agent or a downstream system that has to parse an English string, such as an error message, a tool description, an inter-agent instruction or a status report, without a human in the loop to resolve ambiguity. If a maintenance technician can misread "close the valve" as an adjective ("the valve that is near") instead of a command, so can a language model.

### Core rewrite rules

| Rule | Do | Don't |
|---|---|---|
| One word, one meaning | Pick one verb for one action and reuse it every time (always "check", never mix "check"/"verify"/"confirm" for the same action) | Rotate synonyms for the same idea across a document |
| One part of speech per word | "Apply oil to the valve" (oil = noun) | "Oil the valve" (oil = verb), if "oil" is only approved as a noun |
| Precise verb meaning | "Obey the safety instructions." | "Follow the safety instructions.", where "follow" can also mean "come after" |
| Active voice | "The agent deletes the file." | "The file is deleted (by the agent).", unless the actor is genuinely unknown or irrelevant |
| Simple tenses only | "We received the report." (simple past) | "We have received the report." (present perfect) |
| One instruction per sentence | "Open the file. Read line 3." | "Open the file and read line 3, then check if it matches." |
| Sentence length | 20 words or fewer for instructions and procedures, 25 or fewer for descriptions | Long compound or subordinate-clause sentences |
| Noun clusters | 3 words or fewer stacked as a noun phrase ("fuel pump valve") | Stacks of 4 or more words ("high pressure fuel pump inlet valve assembly") |
| No ellipsis | Keep the subject, verb, and article explicit even if it reads longer | Drop words to save space ("Files not backed up will be lost" leaves it ambiguous which files) |
| Paragraph limits | One topic per paragraph, 6 sentences or fewer | Multi-topic paragraphs |
| Lists for sequences | Use a numbered or bulleted list for 3 or more steps or conditions | Bury a sequence inside one prose sentence |
| Domain terms | Keep necessary technical nouns and verbs, but define them once if not common English | Use jargon without ever defining it |

Also from the standard: the permitted verb forms are the infinitive, imperative, simple present, simple past, simple future, and the past participle used only as an adjective. Use "-ing" forms only as a technical noun or as part of one, never as a verb form. Open a safety-critical instruction with the command or the condition, and never bury it mid-sentence.

### Process

1. Read the input text once for meaning. Do not start rewriting before you understand what it must still say afterward.
2. Walk it sentence by sentence and flag every rule violation (word ambiguity, tense, voice, length, ellipsis, noun stacking).
3. Rewrite each flagged sentence to fix the violation while preserving the original meaning exactly. If a rewrite would drop necessary precision (a safety condition, a scope qualifier, a number), keep the longer phrasing and flag it instead of silently simplifying.
4. Produce a before and after table.
5. If the input already complies, say so. Do not force changes onto compliant text.

### Output format

| Rule violated | Original | Simplified |
|---|---|---|
| Present perfect tense | "We have received your request." | "We received your request." |
| Noun cluster (4 or more words) | "the agent task queue priority handler" | "the handler that sets task-queue priority" |

Follow the table with a one-line note on anything you deliberately did not simplify, and why. Usually the reason is that simplifying would lose required precision.

### Limits

This skill does not reproduce ASD's official dictionary of roughly 900 approved words, each restricted to one meaning and one part of speech, or its roughly 1,200 words to avoid. That is ASD's own free-to-download standard, not something to copy wholesale. It applies the underlying principle instead: pick the plainest, most common word available and use it the same way every time.

When exact ASD-approved wording matters, such as actual aircraft maintenance documentation, download the official standard from asd-ste100.org and check word by word against the real dictionary. This is a general-purpose clarity tool inspired by STE, not a certified STE authoring tool.

## Orwell's rules

Run this pass over the draft once the house style and Simplified Technical English have been balanced. It governs the result of that balance, so where a sentence satisfies both standards and still reads badly, follow Orwell.

George Orwell set out six rules in 'Politics and the English Language' (1946).

1. Never use a metaphor, simile, or other figure of speech which you are used to seeing in print.
2. Never use a long word where a short one will do.
3. If it is possible to cut a word out, always cut it out.
4. Never use the passive where you can use the active.
5. Never use a foreign phrase, a scientific word, or a jargon word if you can think of an everyday English equivalent.
6. Break any of these rules sooner than say anything outright barbarous.

Rule 6 is the one people drop. The rules serve clarity, so break one when following it would make a sentence clumsy or change its meaning. It applies to the two standards above as well as to Orwell's own five rules.

### The four habits to hunt

Orwell's diagnosis is more useful than his rules. He names four habits that let a writer build sentences out of ready-made parts without checking whether they mean anything. Look for them in your own drafts.

- Dying metaphors. Images used so often that the writer no longer sees the picture. A few of his: toe the line, ride roughshod over, stand shoulder to shoulder with, no axe to grind, Achilles' heel, swan song. The present-day equivalents are this skill's, not his: move the needle, boil the ocean, low-hanging fruit, level playing field. Use a fresh image, or drop the image and say the thing plainly.
- Operators, or verbal false limbs. A plain verb swapped for a phrase built round a noun, which pads the sentence and hides who does what. A few of his: render inoperative, militate against, make contact with, give rise to, exhibit a tendency to, serve the purpose of. The plain verbs to put back are this skill's, not his: break, work against, meet, cause, tends, serves. He tracks the same habit into padded connectives such as "with respect to", "the fact that" and "in view of", into sentence endings such as "greatly to be desired" and "deserving of serious consideration", and into the "not un-" formation, which he says gives banal statements an appearance of profundity.
- Pretentious diction. Words that dress up a simple statement or borrow an air of scientific impartiality. A few of his: phenomenon, element, objective, constitute, utilize, eliminate. His inflated adjectives: epoch-making, historic, age-old, inexorable. His foreign phrases used for effect: status quo, mutatis mutandis, deus ex machina.
- Meaningless words. Words used so loosely that they carry no agreed content. From the set he draws from art criticism: romantic, values, human, dead, natural, vitality. He makes the same point about political vocabulary, singling out democracy, socialism, freedom, patriotic, realistic and justice as words with no agreed definition. If a word could mean the opposite thing to the next reader, define it or cut it.

### Orwell's questions for every sentence

A scrupulous writer, Orwell says, asks four questions of every sentence:

- What am I trying to say?
- What words will express it?
- What image or idiom will make it clearer?
- Is this image fresh enough to have an effect?

Then two more:

- Could I put it more shortly?
- Have I said anything that is avoidably ugly?

The point of the exercise is to start from the meaning and then choose the words. The four habits work the other way round, letting the ready-made phrase arrive first and decide what you meant.

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

Work down the list in order. It follows the two layers, standards first, then the pass over them.

- Is the single most important thing first?
- Could a non-expert understand every sentence on first read?
- Is every sentence active, short and one idea?
- Have you removed all bold/italic emphasis, jargon, Latin abbreviations and marketing language?
- Is everything in sentence case, with descriptive headings and links?
- Does the text comply with Simplified Technical English, and did you flag anything you left unsimplified?
- Did you announce that you wrote to Simplified Technical English, and offer to switch it off?
- Did you then run Orwell over the result, covering the six rules, the four habits and the six questions?
- Have you cleared the LLM tics: dense punctuation, "not X but Y", jargon, self-reference to earlier decisions, stacked qualifiers, false balance and throat-clearing openers?
- Could you cut any more words without losing meaning? If yes, cut them.

## Note on this skill's own scope

The "no bold" and formatting rules apply to the prose you produce (reports, guidance, summaries). Code, data tables and direct quotations keep their own conventions. Markdown headings and lists are fine — they are structure, not emphasis.

## Sources

One entry per source, in the order the sections appear above.

- GOV.UK house style, from the [GOV.UK style guides](https://guidance.publishing.service.gov.uk/writing-to-gov-uk-standards/style-guides/) and the [GOV.UK A to Z style guide](https://guidance.publishing.service.gov.uk/writing-to-gov-uk-standards/style-guides/a-to-z-style-guide/), published by the Government Digital Service.
- Simplified Technical English, from [ASD-STE100](https://www.asd-ste100.org/), Issue 9 (January 2025), free to download. That section is adapted from the [asd-ste100-skill](https://github.com/danyuchn/asd-ste100-skill) by Dustin Yuchen Teng, MIT license. It paraphrases the rule categories and does not reproduce the standard or its dictionary of approved words. It also departs from the standard in one place, dropping the terminology allowance that lets a project approve technical words of its own beyond the base dictionary.
- Orwell's rules, from ['Politics and the English Language'](https://www.orwellfoundation.com/the-orwell-foundation/orwell/essays-and-other-works/politics-and-the-english-language/) (1946), full text at the Orwell Foundation. The six rules and the six questions are quoted from it, though the original numbers the rules with roman numerals. The example words and phrases are a short selection from his longer lists. The plain verbs and the present-day cliches are this skill's additions, not his.
