---
name: writing
description: Use when drafting or editing any prose or copy — reports, research write-ups, guidance, documentation, READMEs, emails, announcements, summaries, blog posts, marketing or product copy, or any text meant to be read. Triggers whenever the user asks to draft, write, rewrite, or polish copy. Applies GOV.UK / GDS house style, favoring plain English, active voice, front-loaded content, sentence case, and no bold or italics for emphasis. Balances that house style against ASD-STE100 Simplified Technical English, then runs Orwell's rules from 'Politics and the English Language' over the result. Simplified Technical English stays on for all prose unless the author explicitly asks for it to be switched off, and Claude announces that it is in use and offers to switch it off. Use it to compose new prose and to keep editing, not to audit finished text.
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

The GOV.UK house style and Simplified Technical English both apply while you draft, at the same time. They agree far more than they disagree, because both exist to stop a reader misreading a sentence. Where they pull apart, balance them with your own judgment. Do not look for a rule that settles it for you, and do not pick one and drop the other.

Orwell sits above both. Run his rules, his four habits and his questions over whatever the balance produced, and let them correct it. Where a sentence satisfies both standards and still reads badly, Orwell wins. That is what his sixth rule is for. Run the LLM voice section as part of the same pass.

### Simplified Technical English stays on

Keep Simplified Technical English on unless the author explicitly tells you not to use the standard. Do not switch it off on your own judgment. A piece being marketing copy, a blog post or a research write-up is not a reason to turn it off.

Announce it in one line alongside the text, then offer to switch it off. For example: "Written to the GOV.UK house style and ASD-STE100 Simplified Technical English. Tell me if you want STE switched off."

Switch it off only when the author says so, in words such as "do not use Simplified Technical English", "drop STE" or "no STE100". A general request for warmer, punchier or more persuasive copy is not enough on its own, though it is a good moment to offer. Ask, then wait for the answer.

Simplified Technical English is deliberately flat and literal. When the text is the kind where voice carries part of the meaning, say that in your announcement so the author can decide. Do not decide for them.

### Balancing the two standards

- Register. The house style allows a warm second person. Simplified Technical English is flat and literal. Lean flat for instructions, procedures, error messages and anything a downstream agent parses. Lean warm for prose a person reads by choice, and keep the Simplified Technical English discipline on word choice and sentence structure while you do.
- Contractions. The two disagree outright. The house style allows them for warmth, and Simplified Technical English forbids them. Write them out in anything instructional or machine-read. Allow them only in prose a person reads by choice, and never to shorten a sentence, which is the use the standard specifically rules out.
- Structure. Simplified Technical English wants a vertical list for any sequence of 3 or more steps or conditions. The LLM voice section warns against over-structuring. Use a list when the content really is a sequence or a set of conditions. Use prose when it is an argument.
- Sentence length. Take the tighter of the two caps. That is about 20 words for anything instructional, and about 25 at the outside for description.
- Vocabulary and tense. Where Simplified Technical English is stricter, follow it. Pick one term per idea and reuse it rather than rotating synonyms, and prefer simple tenses. Neither costs the reader anything.
- Punctuation. Simplified Technical English is stricter, so follow it. It excludes the semicolon outright, which overrides the softer advice below to merely avoid leaning on semicolons. Em dashes stay permitted by the standard, so the LLM voice guidance governs them, and the working limit is none in repo prose.
- Connecting words. Simplified Technical English asks for connecting words and phrases so a reader can follow the logic between sentences. The LLM voice section says to cut hollow transitions. These agree once you separate the two cases. Keep a connective that carries real logic, such as a cause or a contrast. Cut one that only decorates, such as "moreover" or "furthermore".
- Spelling. Always use American English. The standard requires it and it is the house default, so it holds even though the GOV.UK material it sits alongside is written in British English. Write organize, recognize, judgment, license, center, color and behavior. Two things are exempt: a direct quotation keeps the spelling of its source, and a proper name keeps its own, so 'Open Government Licence' stays as it is.

### When a word choice is questioned

`references/word-choice.md` holds the word choice reference. It has two sections. The GOV.UK words to avoid are listed there in full with their plain replacements. The Simplified Technical English words are looked up in a local copy of the standard, which the file links and gives search instructions for.

Read it when the author questions a word you used, asks why you chose it, or challenges the register. Do not open it on every draft, because the plain English section below covers the common cases. Reach for it when a specific choice is in dispute, and quote the rule that settles it rather than restating your preference. If no rule settles it, say the choice was a judgment call and defer to the author rather than inventing an authority.

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
  - start, not commence
  - end, not terminate
  - buy, not purchase
  - enough, not sufficient
  - solve, fix or deal with, not tackle or combat
  - effect on, not impact on (do not use impact as a verb)
- Avoid metaphors and clichés: drive, unlock, deep dive, robust, key, ring-fence, hub, portal, landscape, ecosystem, going forward.
- Address the reader as "you". Write about yourself or the organization as "we". Use "they", "them" and "their" rather than gendered pronouns. Write "disabled people", not "the disabled".
- Contractions are fine for a warmer tone (we'll, you'll), but avoid negative contractions — write "cannot", not "can't" — and avoid "should've", "could've", "would've".
- A word on any avoid list stays available when it is the exact technical term for the thing and the plain alternative would be vaguer or simply wrong. Write "deploy" for a software release, "leverage" for the financial instrument, "robust" for the statistical property, "impact" for a physical collision. The test is whether the word carries meaning the reader needs, not whether it appears on a list. Where you keep one this way, keep it because it is the term of art, not because it sounds better.

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
- Dates and times: write "June 4, 2026" (no "th"). Use "to" for ranges ("June 4 to June 8"). Write times as "10am to 11:30am". Use "midday" and "midnight".
- Do not use FAQs. If you have answered the user need in the content, you do not need them. Do not use exclamation marks. Do not use ALL CAPS for emphasis.

## Simplified Technical English

ASD-STE100 is a controlled-language standard built by the aerospace and defense industry (ASD, the AeroSpace and Defense Industries Association of Europe) to stop maintenance technicians from misreading English instructions. The standard removes the two biggest sources of misreading: words with more than one meaning, and sentences with more than one possible structure.

This skill applies that discipline to everything it writes. The reader it protects is anyone who cannot ask you a follow-up question, which covers a non-native English speaker, a translation pipeline, someone reading in a hurry, and an agent or downstream system parsing your output. If a maintenance technician can misread "close the valve" as an adjective, meaning the valve that is near, instead of as a command, so can a reader under time pressure, and so can a language model.

The rules below run from the word up to the whole text, which is the order you meet them while writing.

### How to write this way

Apply the rules as you draft, so the first version already reads this way and you never translate a finished draft into it.

- Fix the verb for each recurring action before you start, then reuse it. Choosing once is far less work than retrofitting consistency later.
- Write the sentence you mean, then check its length. Where it runs past the cap, find the second idea inside it and give that idea its own sentence.
- Never trade away precision to satisfy a rule. Where keeping a condition, a scope qualifier or a number costs you a longer sentence, keep the longer sentence.
- Edit in place. Change the sentence and carry on. Do not produce a violations report, a before and after table, or a list of the rules an earlier draft broke, unless the author asks to see the changes.

### Words

- Use a word only in the part of speech and the meaning it is approved for. A word approved as a noun stays a noun, so write "apply oil to the valve", not "oil the valve".
- One word carries one meaning. Do not lean on the surrounding sentence to tell the reader which sense you meant.
- Prefer the plain, short, common word to the formal or rare one.
- Name each action with one term and reuse it everywhere. Write "check" throughout rather than rotating check, verify and confirm for the same act.
- Reach outside the approved vocabulary only for a genuine technical noun or technical verb. That is the one exception, not a general license to pick a better word.
- Do not press a technical noun into service as a verb, and do not turn a technical verb into a noun. Each word keeps the role it was approved for.
- Where you must choose a technical noun, pick the short, easy one over the impressive one, and never a regional, slang or jargon word.
- Give each item one name. Do not call the same thing by two names anywhere in a document.
- Define any technical term that is not common English, once, at first use.
- Stack at most 3 words into a noun phrase, so "fuel pump valve" is fine. Where a technical noun runs longer than that, write it out in full instead of stacking it, rather than producing "high pressure fuel pump inlet valve assembly".
- Use American spelling. The spelling entry under balancing the two standards carries the two exemptions.

### Verbs and tense

- Use only the verb forms the dictionary gives, which are the infinitive, the imperative, the simple present, the simple past and the simple future.
- Use a past participle only as an adjective.
- Do not build a compound construction out of auxiliary verbs. Write "we received the report", not "we have received the report".
- Use an "-ing" form only as a technical noun, or as a modifier inside one. Never as a verb form.
- Use the active voice. Passive is allowed in description only, and only where the actor is genuinely unknown or does not matter to the reader. Write "the agent deletes the file", not "the file is deleted".
- Name an action with a verb, not with a noun or some other part of speech.
- Choose the verb with a single reading. Write "obey the safety instructions", because "follow" can also mean "come after".
- Do not build a phrasal verb by pairing a verb with a particle. Use the single verb that means the thing.

### Sentences

- Keep sentences short and clear. Use at most 20 words in an instruction and at most 25 in description.
- Write one instruction per sentence, unless two or more actions genuinely happen at the same time. Write "Open the file. Read line 3.", not "Open the file and read line 3, then check if it matches."
- Do not drop words to shorten a sentence, and do not use contractions to shorten one either. A sentence bought that way reads as ambiguous rather than crisp, so "files not backed up will be lost" leaves the reader guessing which files.
- Keep the article or the demonstrative adjective where one applies. Write "the valve" or "this valve", not a bare "valve".
- Use connecting words and phrases so the reader can follow how one sentence bears on the next.
- Recast the sentence when a word-for-word fix will not comply. Changing the construction beats forcing the original shape.

### Paragraphs and lists

- Use a paragraph to group information that belongs together.
- Give each paragraph one topic, and stop at 6 sentences.
- Go vertical whenever the text turns complex, and for any sequence of 3 or more steps or conditions. Do not bury a sequence inside one prose sentence.

### Punctuation and word count

- Use any standard English punctuation mark except the semicolon, which the standard excludes outright.
- Use hyphens to join words that are directly related.
- Counting words against the caps above: a number, a number with its unit, an abbreviation, an alphanumeric identifier, quoted text, a title or label, and a proper noun each count as one word. So does a hyphenated word, and so does a parenthetical. In a vertical list, a colon counts like a period.

### Instructions, description, and safety

The standard treats these three separately, because the reader is doing something different in each.

Instructions:

- Write them in the imperative. "Open the file", not "the file should be opened".
- Where the reader must know a condition first, open the sentence with that condition. Write "If the strategy allows automatic resolution, the tool resolves the conflict." Do not hang the condition off the end.
- Use a note to give information only. Never put an instruction inside a note.

Description, meaning prose the reader reads rather than follows:

- Introduce information in stages. This is the inverted pyramid again: the conclusion first, then detail as the reader needs it, rather than one dense passage carrying everything.
- Use key words and repeated phrases to give the text a structure the reader can follow.

Safety instructions:

- Open with a signal word naming the level of risk, such as warning or caution.
- Follow it with a clear, accurate command or condition.
- Explain the risk or the possible result, so the reader knows why the instruction matters.

## Orwell's rules

Run these over your own draft as you finish it, and again whenever you revise. They govern the result of balancing the two standards above, so where a sentence satisfies both and still reads badly, follow Orwell.

George Orwell set out six rules in 'Politics and the English Language' (1946).

1. Never use a metaphor, simile, or other figure of speech which you are used to seeing in print.
2. Never use a long word where a short one will do.
3. If it is possible to cut a word out, always cut it out.
4. Never use the passive where you can use the active.
5. Never use a foreign phrase, a scientific word, or a jargon word if you can think of an everyday English equivalent.
6. Break any of these rules sooner than say anything outright barbarous.

Rule 6 is the one people drop. The rules serve clarity, so break one when following it would make a sentence clumsy or change its meaning. It applies to the two standards above as well as to Orwell's own five rules, and it is what licenses keeping a word off an avoid list when that word is the right technical term. A rule that has started fighting the meaning has stopped doing its job.

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

Large language models share a set of writing tics that practiced readers now recognize. They are defaults the model reaches for, not choices, and they make the text read as machine-written. Cut them so the real content shows. Rewrite the underlying sentence rather than deleting a flagged word.

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
- Does it read as Simplified Technical English, with one term per action and no sentence over the cap?
- Did you announce that you wrote to Simplified Technical English, and offer to switch it off?
- Did you then read it against Orwell, covering the six rules, the four habits and the six questions?
- Have you cleared the LLM tics: dense punctuation, "not X but Y", jargon, self-reference to earlier decisions, stacked qualifiers, false balance and throat-clearing openers?
- Could you cut any more words without losing meaning? If yes, cut them.

## Note on this skill's own scope

The "no bold" and formatting rules apply to the prose you produce (reports, guidance, summaries). Code, data tables and direct quotations keep their own conventions. Markdown headings and lists are fine — they are structure, not emphasis.

## Sources

- [GOV.UK style guides](https://guidance.publishing.service.gov.uk/writing-to-gov-uk-standards/style-guides/) and the [GOV.UK A to Z style guide](https://guidance.publishing.service.gov.uk/writing-to-gov-uk-standards/style-guides/a-to-z-style-guide/), published by the Government Digital Service.
- [ASD-STE100 Simplified Technical English](https://www.asd-ste100.org/), Issue 9 (January 2025).
- George Orwell, ['Politics and the English Language'](https://www.orwellfoundation.com/the-orwell-foundation/orwell/essays-and-other-works/politics-and-the-english-language/) (1946). The present-day cliches and the plain-verb replacements are this skill's, not his.
