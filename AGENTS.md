# AGENTS.md

AI-facing guidance for working in this repository.

## Purpose

This repository is a personal component registry for Claude Code and Codex. It
stores reusable AI development components such as skills, plugins, subagents,
hooks, MCP configuration, scripts, and references.

The current active component is `industry-research`: a shared skill packaged as
an installable plugin for both Claude Code and Codex. It conducts structured
industry research and produces Chinese markdown research reports.

## Project Structure

```text
.claude-plugin/
  marketplace.json                         # Claude Code marketplace catalog
.agents/
  plugins/
    marketplace.json                       # Codex marketplace catalog
plugins/
  industry-research/
    .claude-plugin/
      plugin.json                          # Claude Code plugin manifest
    .codex-plugin/
      plugin.json                          # Codex plugin manifest
    skills/
      industry-research/
        SKILL.md                           # Skill instructions and trigger metadata
        references/
          report-template.md               # Chinese industry report template
```

## How To Extend

- Add installable components under `plugins/<plugin-name>/`.
- Use kebab-case for plugin, skill, and directory names.
- For each plugin, keep Claude Code and Codex metadata together:
  - `.claude-plugin/plugin.json`
  - `.codex-plugin/plugin.json`
- Expose each plugin in both marketplace catalogs:
  - `.claude-plugin/marketplace.json`
  - `.agents/plugins/marketplace.json`
- Put skill routing and workflow instructions in
  `plugins/<plugin-name>/skills/<skill-name>/SKILL.md`.
- Put long templates, examples, schemas, and supporting knowledge in
  `plugins/<plugin-name>/skills/<skill-name>/references/`.
- Keep plugin folders self-contained. Installed plugins are copied into local
  caches, so avoid references to files outside the plugin directory.

## Review & Test

When changing add-ons, review the affected manifests, marketplace entries, and
skill files together. Confirm names, paths, versions, and descriptions stay
aligned across Claude Code and Codex metadata.

Run these checks when relevant:

```bash
jq empty .claude-plugin/marketplace.json .agents/plugins/marketplace.json
claude plugin validate .
claude plugin validate plugins/<plugin-name>
python3 /Users/eclair/.codex/skills/.system/skill-creator/scripts/quick_validate.py plugins/<plugin-name>/skills/<skill-name>
python3 /Users/eclair/.codex/skills/.system/plugin-creator/scripts/validate_plugin.py plugins/<plugin-name>
```

For a Codex install smoke test, use an isolated temporary home:

```bash
tmp_codex_home=$(mktemp -d)
CODEX_HOME="$tmp_codex_home" codex plugin marketplace add "$(pwd)"
CODEX_HOME="$tmp_codex_home" codex plugin add <plugin-name>@eclair-codex
```

If Python reports `ModuleNotFoundError: No module named 'yaml'`, install
`PyYAML` into a temporary target and run the validators with `PYTHONPATH`
pointing at that target. Do not add temporary validation dependencies to this
repository.

## References

- User-facing project overview and install commands: `README.md`.
- Claude Code marketplace metadata: `.claude-plugin/marketplace.json`.
- Codex marketplace metadata: `.agents/plugins/marketplace.json`.
- Current skill instructions:
  `plugins/industry-research/skills/industry-research/SKILL.md`.
- Current report template:
  `plugins/industry-research/skills/industry-research/references/report-template.md`.
