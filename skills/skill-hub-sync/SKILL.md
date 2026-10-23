---
name: skill-hub-sync
description: Use when the user asks to install, add, or update an agent skill and keep their personal GitHub skill hub in sync, or asks to publish an installed skill to palaprut/agent-skills-hub.
---

# Skill Hub Sync

Keep the user's installed skills and their public repository, `palaprut/agent-skills-hub`, aligned for the skills they explicitly ask to add or update. The repository stores installable copies under `skills/<name>/` and lists them in `README.md`.

## Workflow

1. Identify the exact skill and its source from the user's request. If a name could refer to several skills, inspect the candidates and ask which one they mean. Do not substitute a similarly named skill.
2. Read the source skill and its installation instructions. For GitHub-hosted skills, use the available skill installer when it supports the source. For a skill supplied as files or already installed, use the complete skill directory. Preserve useful bundled resources such as `scripts/`, `references/`, `assets/`, and `agents/`.
3. Install or update the skill in the user's intended agent skill directory. Before replacing an existing copy, compare it with the incoming version and preserve user changes; resolve a conflict with the user if the correct version is unclear. Check that `SKILL.md` exists and its frontmatter name matches the folder.
4. Inspect the files that would enter the public hub. Exclude credentials, personal data, local paths, caches, generated test output, and files unrelated to the skill. Check the source's redistribution terms and preserve any required license or attribution. If a requested skill cannot be shared publicly under its terms, finish the local installation and explain why the hub was not updated.
5. Read the latest `main` branch of `https://github.com/palaprut/agent-skills-hub`. Compare the installed skill with `skills/<name>/` in that repository. Add or replace only that skill's files, remove obsolete files in that skill folder when appropriate, and update the README catalog and source attribution. Keep unrelated skills and repository content intact.
6. Publish through the connected GitHub tool, an authenticated Git checkout, or the signed-in GitHub web editor if the other methods cannot write. Follow repository rules. Recheck the current branch before writing and never force-push. If the branch advances or a write conflicts, refresh and retry after reviewing the new diff. Verify the remote files after publishing.
7. Report the skill name, source, local install location, GitHub link, and whether installation and hub sync each succeeded. If the files were already identical, report that no hub change was needed. If one side failed, state which side succeeded and what remains.

## Scope and authorization

Invoking this skill to install or update a skill authorizes publishing that requested skill to this named public repository. An explicit request to install or update and sync the hub has the same effect. A request only to inspect, compare, or list skills does not authorize installation or publication. A request to install a skill without any hub context should use the ordinary installer workflow; ask about hub sync only when the user's intent is unclear.

Avoid publishing the skill hub's own local configuration or other installed skills unless the user asks for them. The hub is a public copy, so never treat a successful local install as proof that publication is appropriate or complete.
