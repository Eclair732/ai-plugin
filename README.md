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
| `kami` | Plugin | Claude Code, Codex | Installable package that exposes the upstream Kami document-design skill. |
| `kami` | Skill | Claude Code, Codex | Typeset professional documents and landing pages, including resumes, one-pagers, reports, letters, portfolios, slides, equity reports, changelogs, and product landing pages. |
| `scripts/sync-kami.sh` | Script | Local maintenance | Refresh the local `kami` plugin mirror from `tw93/Kami` when upstream changes. |

## Installation

### Claude Code

Add this repository as a plugin marketplace:

```text
/plugin marketplace add Eclair732/ai-plugin
```

Install a plugin:

```text
/plugin install industry-research@eclair-marketplace
/plugin install kami@eclair-marketplace
```

Invoke a skill:

```text
/industry-research:industry-research
/kami:kami
```

### Codex

Add this repository as a plugin marketplace:

```bash
codex plugin marketplace add Eclair732/ai-plugin
```

Install a plugin:

```bash
codex plugin add industry-research@eclair-codex
codex plugin add kami@eclair-codex
```

Start a new Codex session after installation, then invoke the installed skill by
name.

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
- `kami` is mirrored from `https://github.com/tw93/Kami`. Its source metadata is in `plugins/kami/SOURCE.md`.
- To refresh `kami`, run `scripts/sync-kami.sh` or `scripts/sync-kami.sh <ref>`, then review the changed files and re-run validation.
