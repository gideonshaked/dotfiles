# Word choice

Read this when a word is in dispute. It has two sections. The GOV.UK words are listed here in full. The Simplified Technical English words are in `ste100-words.txt` next to this file, which you grep for the word rather than read.

Do not open this on every draft. The plain English section of the skill covers the common cases. Come here when the author questions a word, asks why you picked it, or challenges the register.

## Settling a challenged word choice

Work through these in order and stop at the first one that decides it.

1. Check whether the word is the term of art. A word on an avoid list stays available when it is the exact technical term and the plain alternative would be vaguer or wrong, as with "deploy" for a software release or "robust" for the statistical property. Keep it, and say which domain it is the term in. Orwell's sixth rule is what licenses this.
2. Check the GOV.UK tables below. If the word sits in an Avoid column and step 1 did not save it, the house style has settled it. Make the swap and name the entry.
3. Grep the word in `ste100-words.txt`, as the second section explains. That file is the authority on whether a word is approved and in which sense.
4. Check whether you rotated synonyms. If one action appears as check in one place and verify in another, pick one and use it throughout.
5. If nothing above decides it, the choice was a judgment call. Say so, give your reason, and defer to the author.

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
| disincentivise, disincentivize | discourage, deter |
| empower | allow, give permission |
| facilitate | name the action, for example run a workshop |
| focus | work on, concentrate on |
| foster | encourage, help |
| impact | have an effect on, influence |
| incentivise, incentivize | encourage, motivate |
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

The whole word list from Part 2, Dictionary, of [ASD-STE100](https://www.asd-ste100.org/) Issue 9 sits in `ste100-words.txt`, next to this file. It holds 2,198 entries, one per line. Search it, do not read it. The standard is the authority, so follow the link when an entry looks wrong.

### Searching the word list

Grep for the word with a trailing space, so you match the entry and not a mention of the word in someone else's entry:

```
grep -i "^work " references/ste100-words.txt
```

That returns every entry for that spelling, in either verdict:

```
WORK (n) | approved | that which you do when you use physical strength, or mental power | -
work (v) | not approved | - | WORK (n)
```

The fields are the word with its part of speech, the verdict, the approved meaning, and what to use instead. A dash means the field does not apply. The file's own header carries the same key.

Three things the entries turn on:

- The part of speech is part of the verdict. A word approved as a noun is not approved as a verb, so WORK (n) tells you nothing about "work" as a verb. Each part of speech gets its own line.
- The approved meaning is part of the verdict. Where a word is approved in one sense only, the fourth field gives what to use for the other senses, as with ABOUT (prep), which is approved for "concerned with" but not for "approximately".
- (TN) marks a technical noun and (TV) a technical verb. These name a category rather than a word: the standard leaves them open for the terms your own subject needs, on the conditions in the rules below.

Where a word is not approved and the standard gives no substitute, the fourth field carries its guidance instead, as with "except", which asks you to recast the sentence. The standard's example sentences are not reproduced.

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
