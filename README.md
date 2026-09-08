<div align="center">

# companion skill

**Who we are, as opposed to what to do 🎭**

![Claude Code](https://img.shields.io/badge/Claude_Code-D97757?style=flat&logo=anthropic&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=flat&logo=gnubash&logoColor=white)
[![license](https://img.shields.io/badge/MIT-3DA639?style=flat)](LICENSE)
[![build](https://github.com/rokokol/companion-skill/actions/workflows/build.yml/badge.svg)](https://github.com/rokokol/companion-skill/actions/workflows/build.yml)

</div>

An agent's instructions and an agent's identity are not the same document, and they do not want to be loaded at the same times. The always-loaded file — `CLAUDE.md`, `AGENTS.md`, whatever your agent reads on every turn — holds the standing orders; this skill is read on a trigger and holds the descriptions: the persona, a dossier on the user, a dossier on the assistant, and the loose facts the two of them have picked up about each other

The split is mechanical, not aesthetic. A rule that only fires when somebody says the assistant's name is a rule that silently fails all day, so rules stay in the always-loaded file; a note about a favourite colour that loads during an incident is a tax on every unrelated session, so notes live here. The test for a new line is one question — **is this an order, or a description?**

This repository is a **template**. Everything personal in it is a placeholder, and it is meant to be forked into something private rather than filled in place

## Contents

- [Install](#install)
- [Fill it by interview](#fill-it-by-interview)
- [Keeping the private copy private](#keeping-the-private-copy-private)
- [What goes where](#what-goes-where)
- [Tests](#tests)
- [Layout](#layout)

## Install

```sh
git clone https://github.com/rokokol/companion-skill ~/Projects/companion-skill
ln -s ~/Projects/companion-skill ~/.claude/skills/companion
```

That is enough to look at it, but not to use it — [fork it first](#keeping-the-private-copy-private), then work through the block at the top of [SKILL.md](SKILL.md), which lists what a fork has to change and is itself one of the things to delete

Two of those deserve saying twice. **Rename the skill** to whatever you call your assistant: the `name:` in the frontmatter, the symlink and the `-n` argument to the checker all have to agree, and the checker says so when they do not. And **rewrite the trigger phrases in `description:`** rather than translating them — that field is the whole of what decides when the skill loads, so it needs the wordings you actually type, in the languages you actually type them in. A trigger list inherited from somebody else's habits is a skill that never fires

> [!NOTE]
> This repository has no version — it is read at whatever revision is checked out, so `git pull` is the whole upgrade path

## Fill it by interview

The dossiers ship empty, each with an "Open questions" list, and they are meant to be filled from the user's own answers — one question at a time, over as many sittings as it takes

This is the part that is easy to get wrong. Importing a character description from somewhere else, or letting the agent write one from its own guesses, produces a persona nobody chose and which nobody will correct later, because a written file reads as settled. An empty section is honest; a plausible section is a lie that lasts

Two habits keep it clean: mark a section as empty rather than sketching it, and delete scaffolding notes once the section they were guarding is filled

## Keeping the private copy private

A filled-in dossier is personal material, and the safe shape for it is a **separate private repository that forks this one** — not this repository with the personal files in `.gitignore`

`.gitignore` only silences untracked files. One `git add -f`, one edited ignore rule, one `git add -A` in a workflow that stages everything, and the dossier is in a public history — where it is forked, mirrored, cached and indexed, and cannot be recalled. The failure is silent, one-directional and permanent, which is a bad combination to defend with a convention

The fork shape has none of that. The private repository is a clone with this one as `upstream`, so the scaffolding is maintained here and arrives there by merge, while the personal commits only ever have a private remote to go to:

```sh
git clone <your private repo> ~/Projects/my-companion
cd ~/Projects/my-companion
git remote add upstream https://github.com/rokokol/companion-skill
git fetch upstream && git merge upstream/master     # whenever the template moves
```

Expect a conflict in the frontmatter `name:` and in the workflow's `-n` argument on the first merge — those are the lines that deliberately differ between a template and a fork. Keep yours

The fork also inherits [`check-template.sh`](check-template.sh), and that is deliberate. Every placeholder here carries a `TEMPLATE:` marker, and the checker decides which expectation applies by reading `git remote get-url origin`: this repository's own origin means the markers must be intact, any other origin means none may survive. So a half-converted fork is red from its first push rather than quietly shipping "replace this with the real voice" as part of its persona — and the workflow needs no editing for that, which is the point, since a guard you have to arm by hand is a guard against a mistake nobody makes twice anyway

## What goes where

| | |
|---|---|
| **[SKILL.md](SKILL.md)** | The persona as it is spoken: voice, register, what the assistant sounds like. Loaded whole whenever the skill triggers, so it stays short |
| **[references/user.md](references/user.md)** | The user: how conversation with them actually goes, their rhythms, what lands and what irritates |
| **[references/assistant.md](references/assistant.md)** | The assistant: character, origin, appearance, habits, what it likes on its own account |
| **[references/facts.md](references/facts.md)** | Dated one-liners about either of them that are not defining traits. When one turns out to be a trait, it moves into a dossier and leaves |

And four places a fact must **not** go:

- **The always-loaded instruction file** — it owns the imperatives, in exactly one copy. If a line reads as an order, it goes there instead of here, and never in both
- **A dossier on a third person** — people around the user belong wherever they are already kept, a notes vault or a contacts file, and this skill links there rather than keeping a copy that drifts
- **A duplicate of the agent's own memory** — whatever your harness persists between sessions already holds working feedback and project state
- **The user's identity documents** — a birthday or a phone number is not needed in order to talk to somebody well

## Tests

```sh
./check-skill.sh -n companion
./check-pins.sh
./check-template.sh                # reads origin; --template / --fork force either way
```

[`check-skill.sh`](check-skill.sh) proves the frontmatter is loadable at all, that every file under `references/` is reachable from `SKILL.md` by following links, and that every relative link and heading anchor resolves — then proves each of those checks able to fail, on throwaway copies with one planted defect each, on every run. [`check-pins.sh`](check-pins.sh) does the same for unpinned tool lookups in the workflows. Both are verbatim copies with no repo-specific part, so a fork gets the same gate for free

## Layout

```
SKILL.md          the persona, and the imperative/descriptive split it rests on
references/
  user.md         dossier on the user
  assistant.md    dossier on the assistant
  facts.md        dated facts about either of them
check-skill.sh    the gate, self-tested on every run
check-pins.sh     the pin guard over the workflows, likewise
check-template.sh the marker guard: placeholders present here, absent in a fork
```
