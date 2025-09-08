#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
AGENTS_MD="$PROJECT_ROOT/AGENTS.md"

if [[ -f "$SCRIPT_DIR/lib/log.sh" ]]; then
    source "$SCRIPT_DIR/lib/log.sh"
else
    log_info() { echo "[INFO] $*"; }
    log_error() { echo "[ERROR] $*" >&2; }
    log_success() { echo "[SUCCESS] $*"; }
fi

show_help() {
    cat << 'EOF'
Agents System Daily Initialization

Usage:
  ./init.sh [options]

Options:
  --update-agents-md      Update/create AGENTS.md in parent project
  --setup-logging         Initialize logging directories
  --daily-check           Check if logging is up to date and remind if needed
  --check-integration     Verify agents system integration
  --help, -h              Show this help

Examples:
  ./init.sh                           # Daily routine (default)
  ./init.sh --update-agents-md        # Setup parent project
  ./init.sh --daily-check             # Just check logging status
EOF
}

update_agents_md() {
    log_info "Updating AGENTS.md in parent project"
    
    cat > "$AGENTS_MD" << 'EOF'
# AI Workflow Management

This project uses the `.agents/` system for AI-assisted development workflow management.

## Quick Reference

### Daily Workflow (Recommended)
```bash
# Run daily check (includes logging reminder)
cd .agents && ./init.sh

# Log AI interactions when needed
./tools/logging/ai_log.sh --complete
```

### Direct Commands
```bash
# Log AI work (interactive)
./.agents/tools/logging/ai_log.sh --complete

# Log AI work (JSONL format)
echo "Updated config" | ./.agents/tools/logging/ai_log.sh ops update --files config.yml

# Validate configurations
./.agents/tools/validation/check-config.sh --all

# Generate daily summary
./.agents/tools/logging/ai_log.sh --daily-summary
```

## Documentation

See `.agents/README.md` for complete documentation including:

- **Rules**: AI behavior, communication style, coding standards
- **Tools**: Logging utilities, validation scripts  
- **Workflows**: PR templates, CI patterns, project blueprints
- **Integration**: Cross-project usage and customization

## Logs Location

All AI-related logs are stored in:
- `.agents/logs/ai_prompts_YYYY-MM-DD.log` (structured text)
- `.agents/logs/ai/log.jsonl` (machine-readable)
- `.agents/logs/ai/YYYY-MM-DD.md` (daily summaries)

## Customization

To customize for this project:
1. Edit `.agents/rules/owner-preferences.md` with project-specific preferences
2. Update `.agents/profiles/owner-context.md` with team/project context
3. Modify `.agents/workflows/owner-patterns.md` with project workflows

## System Requirements

The agents system requires:
- `bash` (for scripts)
- `jq` (for JSONL processing, optional)
- Standard Unix tools (`grep`, `find`, `date`)

For validation tools:
- `docker` (for Docker config validation)
- `yamllint` or `python3` (for YAML validation) 
- `shellcheck` (for shell script validation, optional)

## Daily Usage

To start using the agents system:

```bash
# Run daily check and setup
cd .agents && ./init.sh

# This will remind you to log AI interactions if needed
```
EOF

    log_success "AGENTS.md updated at $AGENTS_MD"
}

setup_logging() {
    log_info "Setting up logging directories"
    
    mkdir -p "$SCRIPT_DIR/logs/ai"
    
    # Create .gitignore for logs if needed
    if [[ ! -f "$SCRIPT_DIR/logs/.gitignore" ]]; then
        cat > "$SCRIPT_DIR/logs/.gitignore" << 'EOF'
# Keep daily logs but ignore temporary files
*.tmp
*.lock

# Keep structure but allow logs to be committed for team visibility
# Uncomment next line if you want to ignore all logs:
# *.log
EOF
    fi
    
    log_success "Logging directories created in .agents/logs/"
}

check_integration() {
    log_info "Checking agents system integration"
    
    local issues=0
    
    # Check required files
    if [[ ! -f "$SCRIPT_DIR/README.md" ]]; then
        log_error "Missing .agents/README.md"
        ((issues++))
    fi
    
    if [[ ! -f "$SCRIPT_DIR/tools/logging/ai_log.sh" ]]; then
        log_error "Missing .agents/tools/logging/ai_log.sh"
        ((issues++))
    fi
    
    if [[ ! -x "$SCRIPT_DIR/tools/logging/ai_log.sh" ]]; then
        log_error ".agents/tools/logging/ai_log.sh is not executable"
        ((issues++))
    fi
    
    # Check if logs directory exists
    if [[ ! -d "$SCRIPT_DIR/logs" ]]; then
        log_error "Missing .agents/logs/ directory"
        ((issues++))
    fi
    
    # Check if AGENTS.md exists in parent
    if [[ ! -f "$AGENTS_MD" ]]; then
        log_error "Missing AGENTS.md in parent project (run with --update-agents-md)"
        ((issues++))
    fi
    
    if [[ $issues -eq 0 ]]; then
        log_success "Agents system integration looks good!"
    else
        log_error "Found $issues integration issues"
        return 1
    fi
}

daily_check() {
    log_info "Checking daily logging status"
    
    local today=$(date '+%Y-%m-%d')
    local log_file="$SCRIPT_DIR/logs/ai_prompts_$today.log"
    local jsonl_file="$SCRIPT_DIR/logs/ai/log.jsonl"
    
    # Check if any logging happened today
    local logged_today=false
    
    if [[ -f "$log_file" ]] && [[ -s "$log_file" ]]; then
        logged_today=true
    elif [[ -f "$jsonl_file" ]] && grep -q "$today" "$jsonl_file" 2>/dev/null; then
        logged_today=true
    fi
    
    if [[ "$logged_today" == true ]]; then
        log_success "AI logging is up to date for today"
        log_info "Recent activity logged in: logs/ai_prompts_$today.log"
    else
        log_info "No AI logging detected for today"
        log_info "To log your AI interactions, run: ./tools/logging/ai_log.sh --complete"
        log_info "Or use JSONL format: echo 'message' | ./tools/logging/ai_log.sh category action"
    fi
}

# Parse arguments
UPDATE_AGENTS_MD=false
SETUP_LOGGING=false
DAILY_CHECK=false
CHECK_INTEGRATION=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --update-agents-md)
            UPDATE_AGENTS_MD=true
            shift
            ;;
        --setup-logging)
            SETUP_LOGGING=true
            shift
            ;;
        --daily-check)
            DAILY_CHECK=true
            shift
            ;;
        --check-integration)
            CHECK_INTEGRATION=true
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

# Default action if no flags provided
if [[ "$UPDATE_AGENTS_MD" == false && "$SETUP_LOGGING" == false && "$DAILY_CHECK" == false && "$CHECK_INTEGRATION" == false ]]; then
    UPDATE_AGENTS_MD=true
    SETUP_LOGGING=true
    DAILY_CHECK=true
fi

# Execute actions
if [[ "$SETUP_LOGGING" == true ]]; then
    setup_logging
fi

if [[ "$UPDATE_AGENTS_MD" == true ]]; then
    update_agents_md
fi

if [[ "$DAILY_CHECK" == true ]]; then
    daily_check
fi

if [[ "$CHECK_INTEGRATION" == true ]]; then
    check_integration
fi

log_success "Agents system daily check complete!"
log_info "Daily workflow:"
log_info "1. Run './init.sh' each day to check logging status"
log_info "2. Log AI interactions: ./tools/logging/ai_log.sh --complete"
log_info "3. Review/customize: rules/owner-preferences.md"
log_info "4. See README.md for full documentation"