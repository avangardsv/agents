# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Hook System
```bash
# Start the hooks system (required for session tracking)
cd .claude/hooks
bun run index.ts

# Install hook dependencies
cd .claude/hooks
bun install
```

### Testing and Validation
```bash
# Validate YAML files
yamllint config.yml

# Validate JSON files  
jq empty config.json

# Validate shell scripts
shellcheck script.sh
bash -n script.sh
```

## Architecture Overview

This is an **AI Agents Boilerplate** repository designed to provide reusable Claude Code integration across projects. The core architecture centers around:

### Hook System (.claude/hooks/)
- **TypeScript-based hooks** that intercept Claude Code pipeline events
- **Session tracking** with automatic logging to `.claude/logs/YYYY-MM-DD.md`
- **Safety mechanisms** that block dangerous commands (rm -rf, etc.)
- **Auto-context addition** based on prompt keywords
- **Sound notifications** on session completion using local `sounds/completion.aiff`

### Key Files:
- `index.ts`: Main hook configuration with all event handlers
- `lib.ts`: Hook infrastructure and type definitions  
- `session.ts`: Session persistence and data management
- `sounds/`: Audio files for notifications

### Rules System (.claude/rules/)
- **Communication guidelines**: Concise responses (max 4 lines), direct implementation over explanation
- **Workflow patterns**: TodoWrite usage for complex tasks (3+ steps), parallel tool execution
- **Quality standards**: Security-first approach, follow existing code conventions

### Auto-Logging (.claude/logs/)
- **Time-based entries** in format `## HH:MM - Title`
- **Structured Variant B format** for AI readability
- **Daily session logs** with automatic categorization

## Runtime Environment

- **Bun runtime preferred** over Node.js (see .claude/hooks/CLAUDE.md for Bun-specific patterns)
- **TypeScript support** throughout hook system
- **Git repository** with main branch for PRs

## Integration Patterns

When working with this boilerplate:

1. **Start hooks first**: Run `cd .claude/hooks && bun run index.ts` at session start
2. **Use TodoWrite** for multi-step tasks to maintain visibility  
3. **Follow existing patterns** in rules/ for communication and workflow
4. **Leverage auto-logging** for session tracking and debugging
5. **Validate configurations** before marking tasks complete

## Safety Features

- Dangerous command blocking in hooks (rm -rf patterns)
- Session data persistence for debugging
- Structured logging for audit trails
- Sound notifications for workflow awareness