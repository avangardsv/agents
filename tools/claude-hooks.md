# Claude Code Integration Hooks

## Custom Slash Commands (Proposal)

If Claude Code supported custom slash commands, here's what we could add:

```json
{
  "customCommands": {
    "/log": "./.agents/tools/logging/ai_log.sh --complete",
    "/validate": "./.agents/tools/validation/check-config.sh --all",
    "/context": "./.agents/tools/validation/check-context.sh",
    "/init-agents": "./.agents/init.sh",
    "/daily-summary": "./.agents/tools/logging/ai_log.sh --daily-summary"
  }
}
```

## Current Workarounds

### 1. Shell Aliases
```bash
# Add to ~/.bashrc or ~/.zshrc
# Replace [agents-path] with the absolute path to your .agents folder
alias /log="[agents-path]/tools/logging/ai_log.sh --complete"
alias /validate="[agents-path]/tools/validation/check-config.sh --all"
alias /context="[agents-path]/tools/validation/check-context.sh"
```

### 2. VS Code Tasks (if using VS Code)
```json
// .vscode/tasks.json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "AI Log Complete",
      "type": "shell",
      "command": "./.agents/tools/logging/ai_log.sh",
      "args": ["--complete"],
      "group": "build"
    },
    {
      "label": "AI Validate",
      "type": "shell", 
      "command": "./.agents/tools/validation/check-config.sh",
      "args": ["--all"],
      "group": "test"
    }
  ]
}
```

### 3. Git Aliases
```bash
# Add to .gitconfig
[alias]
  ai-log = "!./.agents/tools/logging/ai_log.sh --complete"
  ai-validate = "!./.agents/tools/validation/check-config.sh --all"
  ai-context = "!./.agents/tools/validation/check-context.sh"

# Usage: git ai-log
```

### 4. Makefile Commands
```makefile
# Makefile
.PHONY: ai-log ai-validate ai-context ai-init

ai-log:
	./.agents/tools/logging/ai_log.sh --complete

ai-validate:
	./.agents/tools/validation/check-config.sh --all

ai-context:
	./.agents/tools/validation/check-context.sh

ai-init:
	./.agents/init.sh

# Usage: make ai-log
```

## Feature Request for Claude Code

To properly support this, Claude Code could add:

1. **Custom slash commands** defined in `.claude/commands.json`
2. **Tool shortcuts** in the UI sidebar
3. **Context-aware suggestions** based on project structure
4. **Command palette** (Cmd+Shift+P style) with custom commands

## Current Best Practice

Until official support exists, use shell aliases:

```bash
# Quick setup script
cat << 'EOF' >> ~/.bashrc
# AI Agents shortcuts
alias ai-log='find . -name "ai_log.sh" -path "*/.agents/tools/logging/*" -exec {} --complete \;'
alias ai-validate='find . -name "check-config.sh" -path "*/.agents/tools/validation/*" -exec {} --all \;'
alias ai-context='find . -name "check-context.sh" -path "*/.agents/tools/validation/*" -exec {} \;'
EOF
```

This finds the tools regardless of where the agents directory is located.
