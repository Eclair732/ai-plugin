# CLAUDE.md

This file provides guidance to Claude Code when working inside the `example-plugin` directory.

## Overview

`example-plugin` is a minimal demo plugin. It demonstrates the standard layout for a Claude Code plugin:

```
plugins/example-plugin/
  .claude-plugin/
    plugin.json          # Plugin manifest (name, version, author, description)
  CLAUDE.md              # This file — guidance for Claude Code
  agents/
    hello-agent.md       # Example agent definition
  skills/
    hello-skill/
      SKILL.md           # Example skill definition
```

## How the pieces connect

- **Plugin manifest** (`.claude-plugin/plugin.json`) declares the plugin identity.
- **Agent definitions** (`agents/<name>.md`) use YAML frontmatter with `name`, `description`, `model`, `tools`, `maxTurns`, and optional `color`.
- **Skill definitions** (`skills/<name>/SKILL.md`) use YAML frontmatter with `name`, `description`, and usually `disable-model-invocation: true` for manually triggered skills.

## Demo contents

- `hello-agent`: A simple agent that greets the user and echoes back a short message.
- `hello-skill`: A simple skill that prints a friendly hello message when invoked via `/example-plugin:hello-skill`.

## Development notes

- Keep YAML frontmatter in every agent/skill markdown file well-formed.
- Match file paths and directory names with the `name` declared in frontmatter.
- Use `disable-model-invocation: true` for skills that should only run when the user explicitly invokes them.
