# CLAUDE.md

This file provides guidance to Claude Code when working in this repository.

## Repository Overview

This is a minimal Claude Code plugin repository. It contains no build system—only markdown specification files and plugin manifests.

## Architecture

```
.claude-plugin/
  marketplace.json                                  # Marketplace manifest
plugins/
  example-plugin/                        # Plugin root
    .claude-plugin/
      plugin.json                                   # Plugin manifest
    CLAUDE.md                                       # Plugin guidance
    agents/
      hello-agent.md                                # Demo agent
    skills/
      hello-skill/
        SKILL.md                                    # Demo skill
```

## Development Notes

- Agent definitions use YAML frontmatter with `name`, `description`, `model`, `tools`, `maxTurns`, and optional `color`.
- Skill definitions use YAML frontmatter with `name`, `description`, and usually `disable-model-invocation: true`.
- Keep directory names and frontmatter `name` values consistent.
