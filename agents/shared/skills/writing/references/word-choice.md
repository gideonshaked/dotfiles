# Word choice

Read this when a word is in dispute. It has two sections. The GOV.UK words are listed here in full. The Simplified Technical English words are looked up in the local copy of the standard, which is linked below.

Do not open this on every draft. The plain English section of the skill covers the common cases. Come here when the author questions a word, asks why you picked it, or challenges the register.

## Settling a challenged word choice

Work through these in order and stop at the first one that decides it.

1. Check the GOV.UK tables below. If the word sits in an Avoid column, the house style has already settled it. Make the swap and name the entry.
2. Look the word up in the local copy of the standard, following the instructions in the second section. That is the only authority on whether a word is approved and in which sense.
3. Check whether you rotated synonyms. If one action appears as check in one place and verify in another, pick one and use it throughout.
4. If nothing above decides it, the choice was a judgement call. Say so, give your reason, and defer to the author.

Quote the rule or entry that settles it rather than restating your preference. Where nothing settles it, say so rather than inventing an authority.

## GOV.UK words

Listed here in full, from the [GOV.UK A to Z style guide](https://guidance.publishing.service.gov.uk/writing-to-gov-uk-standards/style-guides/a-to-z-style-guide/), which is Open Government Licence content. The guide is the authority, so follow the link when an entry looks wrong.

### Words to avoid

| Avoid | Use instead |
|---|---|
| advance | improve, or something more specific |
| agenda | plan |
| collaborate | work with |
| combat | solve, fix, or something specific |
| commit, pledge | plan to, or we are going to |
| counter | prevent, or describe the solution |
| deliver | make, create, provide, or something specific |
| deploy | use, or build, create, put in place |
| dialogue | spoke to, or discussion |
| disincentivise | discourage, deter |
| empower | allow, give permission |
| facilitate | name the action, for example run a workshop |
| focus | work on, concentrate on |
| foster | encourage, help |
| impact | have an effect on, influence |
| incentivise | encourage, motivate |
| initiate | start, begin |
| key | important, significant, or cut it |
| land | get, achieve |
| leverage | influence, use |
| liaise | work with, work alongside |
| overarching | encompassing, or cut it |
| progress | work on, develop, make progress |
| promote | recommend, support |
| robust | well thought out, comprehensive |
| slim down | make smaller, reduce the size of |
| streamline | simplify, remove unnecessary administration |
| strengthening | increase funding, concentrate on, add staff |
| tackle | stop, solve, deal with |
| transform | describe the specific changes |
| utilise, utilize | use |

### Metaphors to avoid

| Avoid | Use instead |
|---|---|
| drive, of schemes or people | create, cause, encourage |
| drive out | stop, avoid, prevent |
| going forward, moving forward | from now on, in the future |
| hub, portal, one-stop shop | website, service |
| in order to | usually cut it |
| ring fence, of budgets | separate, or money that will be spent on |

### Also carried in the skill

| Avoid | Use instead |
|---|---|
| commence | start |
| in relation to, with regard to | about |
| purchase | buy |
| sufficient | enough |
| terminate | end |

## Simplified Technical English words

Not listed here. Look them up in the local copy of the standard, which covers all of its approved words rather than a subset, and cannot drift from it.

### The local copy

- [ASD-STE100_ISSUE9.txt](file:///Users/gideon/.claude/reference/ASD-STE100_ISSUE9.txt), a text extraction, best for searching
- [ASD-STE100_ISSUE9.pdf](file:///Users/gideon/.claude/reference/ASD-STE100_ISSUE9.pdf), the original, best for reading a rule in context

Read them at these paths:

```
~/.claude/reference/ASD-STE100_ISSUE9.txt
~/.claude/reference/ASD-STE100_ISSUE9.pdf
```

Both sit outside the repository and are untracked, so they do not travel with these dotfiles. Where the paths are empty, download Issue 9 free from [asd-ste100.org](https://www.asd-ste100.org/).

### How to read an entry

- Case carries the verdict. A word printed in UPPERCASE is approved. A word printed in lowercase is not approved.
- Each entry pairs an approved example against a rejected one. The word list's third column holds the STE example and the fourth holds the non-STE example.

### Where to look

Search the text rather than trusting page numbers, which move between issues.

```
grep -n "List of approved verbs" ~/.claude/reference/ASD-STE100_ISSUE9.txt
```

The document has two parts. Part 1, Writing rules, holds nine sections: Words, Multi-word nouns, Verbs, Sentences, Procedural writing, Descriptive writing, Safety instructions, Punctuation and word count, and Writing practices. Part 2, Dictionary, holds an introduction, the alphabetical word list, and a standalone list of approved verbs that Issue 9 added to that introduction. For a question about a verb, search that list first, since it is far shorter than the full word list.

### The rules behind the entries

Word choice is governed by Section 1, Words, which carries 14 rules, and Section 3, Verbs, which carries 7. These are the principles they encode.

- Use a word only in its approved meaning and its approved part of speech. A word approved as a noun stays a noun, so write "apply oil to the valve", not "oil the valve".
- One word carries one meaning. Do not lean on context to disambiguate a word with several senses.
- Prefer the plainer, shorter, more common word over a formal or rare synonym.
- Pick one term per action and reuse it. Do not rotate check, verify and confirm for the same action.
- Choose the verb with a single reading. Write "obey the safety instructions", because "follow" can also mean "come after".
- Keep the technical nouns and verbs you need, and define each once where it is not common English.
- Permitted verb forms are the infinitive, the imperative, the simple present, the simple past, the simple future, and the past participle used only as an adjective. Write "we received the report", not "we have received the report".
- Use an "-ing" form only as a technical noun or part of one, never as a verb form.

## Where the two agree

Three words appear on both lists, which makes them the safest to cut on sight: promote, utilize, eliminate. Orwell files them under pretentious diction, GOV.UK under words to avoid.

## Sources

- [GOV.UK A to Z style guide](https://guidance.publishing.service.gov.uk/writing-to-gov-uk-standards/style-guides/a-to-z-style-guide/) and the [GOV.UK style guides](https://guidance.publishing.service.gov.uk/writing-to-gov-uk-standards/style-guides/) index, published by the Government Digital Service under the Open Government Licence.
- [ASD-STE100 Simplified Technical English](https://www.asd-ste100.org/), Issue 9 (January 2025). The rules above paraphrase the public rule categories, by way of the [asd-ste100-skill](https://github.com/danyuchn/asd-ste100-skill) by Dustin Yuchen Teng, MIT license.
- George Orwell, ['Politics and the English Language'](https://www.orwellfoundation.com/the-orwell-foundation/orwell/essays-and-other-works/politics-and-the-english-language/) (1946), for the overlap noted above.
