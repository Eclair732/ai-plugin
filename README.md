# AI Plugin

## Purpose

This project provides add-ons for Claude Code and Codex, including Skills,
Rules, Plugins, references, and other reusable AI workflow components.

Use this repository as a shared place to package, document, install, and extend
AI assistant capabilities across both tools.

## Add-Ons

| Add-on | Type | Host | Purpose |
| --- | --- | --- | --- |
| `industry-research` | Plugin | Claude Code, Codex | Installable package that exposes the `industry-research` skill. |
| `industry-research` | Skill | Claude Code, Codex | Conduct structured industry research and produce Chinese markdown research reports. |
| `report-template.md` | Reference | Claude Code, Codex | Report template for full Chinese industry research reports, covering market size, value chain, business model, demand, competition, moats, metrics, risks, opportunities, and recommendations. |

## Installation

### Claude Code

Add this repository as a plugin marketplace:

```text
/plugin marketplace add Eclair732/ai-plugin
```

Install the current plugin:

```text
/plugin install industry-research@eclair-marketplace
```

Invoke the skill:

```text
/industry-research:industry-research
```

### Codex

Add this repository as a plugin marketplace:

```bash
codex plugin marketplace add Eclair732/ai-plugin
```

Install the current plugin:

```bash
codex plugin add industry-research@eclair-codex
```

Start a new Codex session after installation, then invoke `industry-research`
for industry, market, sector, competitor, or business-track analysis.

## Notes & Precautions

- Keep Claude Code and Codex metadata in sync when adding or renaming add-ons.
- Claude Code marketplace metadata lives in `.claude-plugin/marketplace.json`.
- Codex marketplace metadata lives in `.agents/plugins/marketplace.json`.
- Claude Code plugin manifests live in `plugins/<plugin-name>/.claude-plugin/plugin.json`.
- Codex plugin manifests live in `plugins/<plugin-name>/.codex-plugin/plugin.json`.
- Runtime skill instructions should live in `plugins/<plugin-name>/skills/<skill-name>/SKILL.md`.
- Long templates, examples, schemas, and domain references should live under `references/`.
- Keep plugin folders self-contained because installed plugins are copied into local caches.
- Do not package local-only files such as `.DS_Store`, credentials, private notes, or temporary validation artifacts.
