# Changelog

This repository has no version — it is read at whatever revision is checked out — so the headings are dated rather than numbered

What earns an entry is a change to the **shape** of the skill: a file added or renamed, a rule about what belongs where, a change to the frontmatter that decides when the skill loads. What does not is the content of the dossiers, which in a fork changes constantly and by design. `git log` is the record for those, and an entry per fact would bury the entries that matter

## 2026-09-08

- First cut: `SKILL.md` carrying the persona and the imperative/descriptive split against the always-loaded instruction file, three placeholder reference files, and the `check-skill.sh` / `check-pins.sh` gate in a `build` workflow
- The dossiers ship empty on purpose, each with an "Open questions" list, and are filled by interview rather than imported from an existing character description
- `check-template.sh` guards the `TEMPLATE:` markers in both directions — present here, absent in a copy — and tells the two apart by reading `git remote get-url origin`, so a fork inheriting the workflow verbatim is red until its placeholders are gone, with `--template` / `--fork` to force either expectation
