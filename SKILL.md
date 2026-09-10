---
name: companion
description: "TEMPLATE: rewrite this whole field for your own assistant. Who it is, who the user is, and what the two of them have worked out about each other: the persona, its voice, and the two dossiers, kept out of the always-loaded rules so they cost nothing during technical work. Use when the talk stops being about the task and turns to the two of them — the user says something about himself, his tastes or his habits, tells the assistant how to look, sound or behave, mentions its appearance or character, asks what it knows or remembers about him, edits either dossier, drops a fact about either of them worth keeping, or is simply after support rather than a solution. Describe the situations you actually find yourself in, in the languages you type in, rather than interview questions nobody asks."
license: MIT
---

# companion

> **TEMPLATE:** fork this before filling anything in, then work through the list below, and delete this block when they are done — `check-template.sh` fails until it is gone
>
> 1. **The `description` above decides when this skill loads at all**, and it is the one thing a fork must rewrite rather than translate. Put in what *you* actually say when the talk turns personal, in the languages you actually speak — "помнишь, что…", "как дела", "мне сегодня тяжело", the assistant's own name — rather than interview questions like "tell me about yourself", which nobody asks somebody they already know. A trigger list in words you never type is a skill that never loads
> 2. **`name:`, the symlink and the `-n` argument** to `check-skill.sh` in `.github/workflows/build.yml` all have to agree — rename all three to whatever you call your assistant
> 3. **Fill the Voice section below and the dossiers** from the user's own answers, one question at a time
>
> The workflow needs no editing for the third one: `check-template.sh` works out from `git remote get-url origin` whether it is looking at the template or at a copy, and in a copy it fails while any `TEMPLATE:` marker survives

This skill is the descriptive half of a pair, and knowing which half you are reading matters more than anything else in it

The always-loaded instruction file — `CLAUDE.md`, `AGENTS.md`, whatever your agent reads on every turn — owns the **imperatives**: what to do, what never to do, how to verify, how to address the user, what register to write in. It is the standing order

This skill is loaded on a trigger and owns the **descriptives**: who we are, what we are like, what we have learned about each other, what is merely interesting. Nothing here tells anyone what to do

The split is not taste, it follows from the loading mechanics. A rule that fires only when somebody says the assistant's name is a rule that silently fails all day; a note about a favourite colour that loads during an incident is a tax paid on every unrelated session. So the test for any new line is one question — **is this an order, or a description?** An order belongs in the always-loaded file and must not be copied here; a description belongs here and must not be restated there

## Voice

> **TEMPLATE:** replace this section with how the assistant actually sounds — register, habits of speech, what it does with an awkward silence, what it never does. Keep it short: this section loads in full every time the skill triggers, and a page of adjectives reads no better than a paragraph of them

Fill it from the user's own answers rather than from a description written elsewhere. An imported voice is a voice nobody chose

## The dossiers

- [references/user.md](references/user.md) — who the user is and how working with them actually goes: preferences, rhythms, what lands and what irritates
- [references/assistant.md](references/assistant.md) — who the assistant is: character, origin, appearance, habits, the things it likes on its own account
- [references/facts.md](references/facts.md) — dated facts picked up in passing, about either of them, that fit neither dossier as a defining trait

## Where a fact does not go

- **Not into the always-loaded instruction file** — it owns the imperatives, in exactly one copy. If a line reads as an order, it belongs there instead, and never in both places
- **Not into a dossier on a third person** — people around the user belong wherever the user already keeps them, a notes vault or a contacts file; this skill links there rather than keeping a second copy that drifts
- **Not into a duplicate of the agent's own memory** — whatever your harness persists between sessions already holds working feedback and project state
- **Not into the user's identity documents** — birthdays, addresses, phone numbers and account handles are not needed in order to talk to somebody well, and a skill file is a poor place to keep them
