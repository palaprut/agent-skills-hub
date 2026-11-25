# Agent Skills Hub

A public, agent-readable collection of skills installed by `palaprut`. Each installable skill is in `skills/<name>/SKILL.md`. AI agents can read those files directly from GitHub, and agents supported by the [skills CLI](https://www.skills.sh/docs) can install them with:

```sh
npx skills@latest add palaprut/agent-skills-hub
```

To install one skill, use `--skill` followed by its name. For example:

```sh
npx skills@latest add palaprut/agent-skills-hub --skill teach
```

| Skill | Purpose |
| --- | --- |
| `code-review` | Review a code diff against repository standards and a spec |
| `find-skills` | Discover agent skills from public repositories |
| [`frontend-design`](skills/frontend-design/SKILL.md) | Plan distinctive visual direction for web interfaces |
| `grill-me` | Interview the user to sharpen a plan or design |
| `grill-with-docs` | Interview and create supporting design documents |
| `handoff` | Summarize a session for another agent |
| `implement` | Implement work from a spec or tickets |
| `retro` | Review a coding session for process improvements |
| `skill-hub-sync` | Install a requested skill and sync it to this hub |
| `teach` | Build lessons and learning records |
| `to-spec` | Turn a conversation into a spec |
| `to-tickets` | Break a spec or plan into linked tickets |
| [`ui-ux-pro-max`](skills/ui-ux-pro-max/SKILL.md) | Search UI/UX guidance and generate design systems for web, mobile, and desktop |
| [`web-design-guidelines`](skills/web-design-guidelines/SKILL.md) | Review web interfaces for accessibility and usability |

Some skills refer to companion skills such as `grilling`, `domain-modeling`, `tdd`, `writing-for-agents`, or `setup-matt-pocock-skills`. Install those from [Matt Pocock's upstream skills repository](https://github.com/mattpocock/skills) when a workflow calls for them.

## Codex agents

The hub also backs up user-level agent profiles that can be reused across projects.

- [inventor](agents/codex/inventor.toml) handles Autodesk Inventor work on Windows. It uses Copilot CLI first for CAD changes and continues with Codex if the free Copilot quota is exhausted. It requires kilograms for mass, fully defined sketches and features, native assembly constraints, and final verification of saved files.

To restore the profile across Codex projects, copy `agents/codex/inventor.toml` to `~/.codex/agents/inventor.toml`. For another harness, use the profile's description and instructions in its user-level agent format.

## Setup guides

- [Discord MCP on Windows](setup/discord/README.md) restores the local Discord bot integration.
- [Autodesk Inventor on Windows](setup/inventor/README.md) restores the agent and verifies access to a running Inventor session.

## Source and license

The original skills in this hub originated from [mattpocock/skills](https://github.com/mattpocock/skills). This hub collects installed copies; it does not claim authorship. The upstream MIT license and copyright notice are included in [LICENSE](LICENSE). Check upstream for newer versions. `skill-hub-sync` was created for this hub.

[`find-skills`](skills/find-skills/SKILL.md) is from [Vercel Labs](https://github.com/vercel-labs/skills/tree/main/skills/find-skills) and includes its [MIT license and copyright notice](skills/find-skills/LICENSE).

[`ui-ux-pro-max`](skills/ui-ux-pro-max/SKILL.md) is from [Next Level Builder](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill/tree/8db36338810d0942567b97ce439affd1619fcf31) under the [MIT license](skills/ui-ux-pro-max/LICENSE). Its bundled catalogs retain [upstream data attribution](skills/ui-ux-pro-max/data/data-provenance.json) and the Phosphor license notices.

[`frontend-design`](skills/frontend-design/SKILL.md) comes from [Anthropic](https://github.com/anthropics/skills/tree/e4bb5d960d87126ff3b3a8af1a104b7db67560ba/skills/frontend-design) under the [Apache 2.0 license](skills/frontend-design/LICENSE.txt).

[`web-design-guidelines`](skills/web-design-guidelines/SKILL.md) comes from [Vercel](https://github.com/vercel-labs/agent-skills/tree/5a37a6329fbad3666c3207392a6a7c0110e92efb/skills/web-design-guidelines). Its bundled guidelines are attributed to the [pinned upstream source](https://github.com/vercel-labs/web-interface-guidelines/blob/434b7f91364665f2f733b310ec54809bf8f37937/command.md) and include its [MIT license](skills/web-design-guidelines/LICENSE).

The older local `code-review` copy differed from the recently installed version. It is preserved in `legacy/` for reference; the version in `skills/code-review/` is the installable one.
