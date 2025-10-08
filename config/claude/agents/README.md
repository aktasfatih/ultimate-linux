# Claude Code Agents

This directory contains custom Claude Code agents. During setup, `~/.claude/agents/` is **symlinked** to this directory, meaning any changes you make in either location are automatically synced.

## How Symlinks Work

- **Repository**: `config/claude/agents/` (this directory)
- **Home**: `~/.claude/agents/` → symlinked to repository
- **Changes in either location are automatically reflected in both**
- **No need to redeploy** - just edit and save!

## Agent File Format

Agents are Markdown files with YAML frontmatter:

```markdown
---
name: agent-slug-name
description: Use this agent when [conditions]. Examples: <example>Context: [scenario]. user: "[user message]" assistant: "[invocation]" <commentary>[explanation]</commentary></example>
model: sonnet
color: red
---

[Agent instructions and system prompt in markdown]
```

## Adding Your Own Agents

1. Create a new `.md` file in **either** location:
   - `config/claude/agents/my-agent.md` (repository)
   - `~/.claude/agents/my-agent.md` (home directory)
2. Follow the format above
3. Changes are **instantly available** - no deployment needed!

## CLI Usage

```bash
./install.sh --agents           # Set up agent symlink (first time only)
./install.sh --list-agents      # List available agents
./install.sh --no-agents        # Skip agent setup
```

## Agent Fields

- **name** (required): Unique identifier (kebab-case)
- **description** (required): When to use the agent, with examples
- **model** (optional): Claude model to use (e.g., `sonnet`)
- **color** (optional): Visual identifier (e.g., `red`, `yellow`, `blue`)
