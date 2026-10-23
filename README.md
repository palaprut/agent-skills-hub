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
| `grill-me` | Interview the user to sharpen a plan or design |
| `grill-with-docs` | Interview and create supporting design documents |
| `handoff` | Summarize a session for another agent |
| `implement` | Implement work from a spec or tickets |
| `retro` | Review a coding session for process improvements |
| `teach` | Build lessons and learning records |
| `to-spec` | Turn a conversation into a spec |
| `to-tickets` | Break a spec or plan into linked tickets |

Some skills refer to companion skills such as `grilling`, `domain-modeling`, `tdd`, `writing-for-agents`, or `setup-matt-pocock-skills`. Install those from [Matt Pocock's upstream skills repository](https://github.com/mattpocock/skills) when a workflow calls for them.

## Source and license

These skills originated from [mattpocock/skills](https://github.com/mattpocock/skills). This hub collects installed copies; it does not claim authorship. The upstream MIT license and copyright notice are included in [LICENSE](LICENSE). Check upstream for newer versions.

The older local `code-review` copy differed from the recently installed version. It is preserved in `legacy/` for reference; the version in `skills/code-review/` is the installable one.
