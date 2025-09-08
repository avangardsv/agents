#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_DIR="$(dirname "$SCRIPT_DIR")"
PROJECT_ROOT="$(dirname "$AGENTS_DIR")"

show_help() {
    cat << 'EOF'
Install Agents System Commands

Usage:
  ./install-commands.sh [options]

Options:
  --claude          Install Claude Code commands
  --gemini          Install Gemini CLI commands  
  --all             Install all supported commands
  --uninstall       Remove installed commands
  --help, -h        Show this help

Examples:
  ./install-commands.sh --claude
  ./install-commands.sh --all
  ./install-commands.sh --uninstall
EOF
}

install_claude_commands() {
    local claude_dir="$PROJECT_ROOT/.claude/commands"
    mkdir -p "$claude_dir"
    
    # AI Logging Command
    cat > "$claude_dir/log.md" << 'EOF'
# AI Logging

Log AI interactions with structured format including task type, status, deliverables, and files affected.

## Usage
Interactive logging session with prompts for all required fields.

## Execute
```bash
./.agents/tools/logging/ai_log.sh --complete
```
EOF

    # Validation Command
    cat > "$claude_dir/validate.md" << 'EOF'
# Validate Configuration

Validate all configuration files (Docker, YAML, JSON, shell scripts) in the project.

## Usage
Checks syntax and format of configuration files with detailed error reporting.

## Execute
```bash
./.agents/tools/validation/check-config.sh --all
```
EOF

    # Context Check Command  
    cat > "$claude_dir/context.md" << 'EOF'
# Check Agent Context

Verify that all agent system files exist and contain valid content.

## Usage
Validates agent rules, profiles, workflows, and tools are properly configured.

## Execute
```bash
./.agents/tools/validation/check-context.sh --profile=owner
```
EOF

    # Daily Summary Command
    cat > "$claude_dir/daily-summary.md" << 'EOF'
# Generate Daily Summary

Generate daily summary from JSONL logs and create markdown report.

## Usage
Creates summary of today's AI interactions and activities.

## Execute
```bash
./.agents/tools/logging/ai_log.sh --daily-summary
```
EOF

    echo "[SUCCESS] Claude Code commands installed in $claude_dir"
}

install_gemini_commands() {
    local gemini_dir="$PROJECT_ROOT/.gemini/commands"
    mkdir -p "$gemini_dir"
    
    # AI Logging Command
    cat > "$gemini_dir/log.toml" << 'EOF'
name = "log"
description = "Log AI interactions with structured format"
prompt = """
Please execute the AI logging tool to record this interaction:

./.agents/tools/logging/ai_log.sh --complete

This will prompt for:
- Task type and description
- Status (PENDING/IN_PROGRESS/COMPLETED/BLOCKED)  
- Deliverables produced
- Files affected
- Issues encountered
- Follow-up actions needed
"""
EOF

    # Validation Command
    cat > "$gemini_dir/validate.toml" << 'EOF'
name = "validate"
description = "Validate all project configurations"
prompt = """
Please run the configuration validation tool:

./.agents/tools/validation/check-config.sh --all

This checks:
- Docker compose files
- YAML configuration files  
- JSON configuration files
- Shell script syntax
- Reports any syntax errors or issues found
"""
EOF

    echo "[SUCCESS] Gemini CLI commands installed in $gemini_dir"
}

uninstall_commands() {
    local removed=0
    
    if [[ -d "$PROJECT_ROOT/.claude/commands" ]]; then
        rm -rf "$PROJECT_ROOT/.claude/commands"
        echo "[SUCCESS] Removed Claude Code commands"
        ((removed++))
    fi
    
    if [[ -d "$PROJECT_ROOT/.gemini/commands" ]]; then
        rm -rf "$PROJECT_ROOT/.gemini/commands"  
        echo "[SUCCESS] Removed Gemini CLI commands"
        ((removed++))
    fi
    
    if [[ $removed -eq 0 ]]; then
        echo "[INFO] No commands found to remove"
    fi
}

# Parse arguments
INSTALL_CLAUDE=false
INSTALL_GEMINI=false
UNINSTALL=false

if [[ $# -eq 0 ]]; then
    show_help
    exit 0
fi

while [[ $# -gt 0 ]]; do
    case $1 in
        --claude)
            INSTALL_CLAUDE=true
            shift
            ;;
        --gemini)
            INSTALL_GEMINI=true
            shift
            ;;
        --all)
            INSTALL_CLAUDE=true
            INSTALL_GEMINI=true
            shift
            ;;
        --uninstall)
            UNINSTALL=true
            shift
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            show_help
            exit 1
            ;;
    esac
done

# Execute actions
if [[ "$UNINSTALL" == true ]]; then
    uninstall_commands
    exit 0
fi

if [[ "$INSTALL_CLAUDE" == true ]]; then
    install_claude_commands
fi

if [[ "$INSTALL_GEMINI" == true ]]; then
    install_gemini_commands
fi

echo "[SUCCESS] Command installation complete!"
echo ""
echo "Usage in Claude Code: /log, /validate, /context, /daily-summary"  
echo "Usage in Gemini CLI: /log, /validate"
echo ""
echo "To uninstall: ./install-commands.sh --uninstall"
