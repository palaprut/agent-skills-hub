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
| `grill-me` | Interview the user to sharpen a plan or design |
| `grill-with-docs` | Interview and create supporting design documents |
| `handoff` | Summarize a session for another agent |
| `implement` | Implement work from a spec or tickets |
| `retro` | Review a coding session for process improvements |
| `skill-hub-sync` | Install a requested skill and sync it to this hub |
| `teach` | Build lessons and learning records |
| `to-spec` | Turn a conversation into a spec |
| `to-tickets` | Break a spec or plan into linked tickets |

Some skills refer to companion skills such as `grilling`, `domain-modeling`, `tdd`, `writing-for-agents`, or `setup-matt-pocock-skills`. Install those from [Matt Pocock's upstream skills repository](https://github.com/mattpocock/skills) when a workflow calls for them.

## Codex agents

The hub also backs up user-level agent profiles that can be reused across projects.

- [inventor](agents/codex/inventor.toml) handles Autodesk Inventor work on Windows. The profile requires kilograms for mass, fully defined sketches and features, native assembly constraints, and a final verification pass on saved files.

To restore the profile across Codex projects, copy `agents/codex/inventor.toml` to `~/.codex/agents/inventor.toml`. For another harness, use the profile's description and instructions in its user-level agent format.

## Setup guides

- [Discord MCP on Windows](setup/discord/README.md) restores the local Discord bot integration.
- [Autodesk Inventor on Windows](setup/inventor/README.md) restores the agent and verifies access to a running Inventor session.

## Source and license

The original skills in this hub originated from [mattpocock/skills](https://github.com/mattpocock/skills). This hub collects installed copies; it does not claim authorship. The upstream MIT license and copyright notice are included in [LICENSE](LICENSE). Check upstream for newer versions. `skill-hub-sync` was created for this hub.

[`find-skills`](skills/find-skills/SKILL.md) is from [Vercel Labs](https://github.com/vercel-labs/skills/tree/main/skills/find-skills) and includes its [MIT license and copyright notice](skills/find-skills/LICENSE).

The older local `code-review` copy differed from the recently installed version. It is preserved in `legacy/` for reference; the version in `skills/code-review/` is the installable one.
