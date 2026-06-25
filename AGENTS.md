# AGENTS.md

AI-facing guidance for working in this repository.

## Purpose

This repository is a personal component registry for Claude Code and Codex. It
stores reusable AI development components such as skills, plugins, subagents,
hooks, MCP configuration, scripts, and references.

Current active components include:

- `industry-research`: a shared skill packaged as an installable plugin for
  structured industry research and Chinese markdown research reports.
- `kami`: a mirrored upstream skill from `https://github.com/tw93/Kami` for
  professional document and landing-page typesetting.

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
  kami/
    .claude-plugin/
      plugin.json                          # Claude Code plugin manifest
    .codex-plugin/
      plugin.json                          # Codex plugin manifest
    SOURCE.md                              # Upstream source and sync metadata
    skills/
      kami/
        SKILL.md                           # Mirrored Kami skill instructions
        assets/                            # Templates, diagrams, fonts, images
        references/                        # Kami design and writing references
        scripts/                           # Kami build and verification scripts
scripts/
  sync-kami.sh                             # Refresh Kami from upstream
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

## Update Rule

After adding, removing, renaming, or modifying any add-on, update all related
files in the same change:

- `README.md`: add-on list, installation notes, and precautions.
- `.claude-plugin/marketplace.json`: Claude Code marketplace entry.
- `.agents/plugins/marketplace.json`: Codex marketplace entry.
- `plugins/<plugin-name>/.claude-plugin/plugin.json`: Claude Code plugin
  manifest.
- `plugins/<plugin-name>/.codex-plugin/plugin.json`: Codex plugin manifest.
- `plugins/<plugin-name>/skills/<skill-name>/SKILL.md`: skill name,
  description, workflow, and references.
- `plugins/<plugin-name>/skills/<skill-name>/references/`: supporting templates
  and domain material.
- Plugin version numbers: whenever plugin-distributed content changes, bump the
  plugin version and keep it identical in the Claude manifest, Codex manifest,
  Claude marketplace entry, and Codex marketplace entry. Repo-doc-only changes
  do not require a plugin version bump.
- `plugins/<plugin-name>/SOURCE.md`: source attribution for mirrored upstream
  add-ons.
- `scripts/sync-*.sh`: sync scripts for mirrored upstream add-ons.
- `AGENTS.md` and `CLAUDE.md`: project structure, extension rules, references,
  and test instructions when workflow expectations change.

For upstream-mirrored add-ons such as `kami`, prefer running the sync script
first, then review and patch local marketplace/docs/source notes as needed. If
upstream content changed but upstream did not bump its version, use a local
SemVer build suffix such as `1.9.0+eclair.<commit>` so installers can fetch a
new plugin snapshot.

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
- Kami source metadata: `plugins/kami/SOURCE.md`.
- Kami sync script: `scripts/sync-kami.sh`.
