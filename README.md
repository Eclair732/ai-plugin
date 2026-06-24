# Eclair Plugin

A minimal Claude Code plugin repository containing a demo plugin.

## Project Structure

```
.claude-plugin/
  marketplace.json                         # Marketplace manifest
plugins/
  example-plugin/               # Plugin root
    .claude-plugin/
      plugin.json                            # Plugin manifest
    CLAUDE.md                                # Claude Code guidance
    agents/
      hello-agent.md                         # Demo agent
    skills/
      hello-skill/
        SKILL.md                             # Demo skill
```

## Install

```
/plugin marketplace add /path/to/eclair-plugin
/plugin install example-plugin@eclair-marketplace
```

## Usage

- Agent: `hello-agent`
- Skill: `/example-plugin:hello-skill`

## Author

Eclair
