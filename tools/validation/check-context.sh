#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

if [[ -f "$AGENTS_DIR/lib/log.sh" ]]; then
    source "$AGENTS_DIR/lib/log.sh"
else
    log_info() { echo "[INFO] $*"; }
    log_error() { echo "[ERROR] $*" >&2; }
    log_success() { echo "[SUCCESS] $*"; }
fi

show_help() {
    cat << 'EOF'
Agent Context Validation Tool

Usage:
  ./check-context.sh [options]

Options:
  --profile=PROFILE   Check specific profile (default: owner)
  --strict            Fail on warnings (not just errors)
  --quiet             Only show errors and final result
  --help, -h          Show this help

Examples:
  ./check-context.sh --profile=owner
  ./check-context.sh --strict --quiet
EOF
}

check_file_exists_and_nonempty() {
    local file="$1"
    local description="$2"
    
    if [[ ! -f "$file" ]]; then
        log_error "Missing: $description ($file)"
        return 1
    fi
    
    if [[ ! -s "$file" ]]; then
        log_error "Empty: $description ($file)"
        return 1
    fi
    
    [[ "$QUIET" != true ]] && log_info "✓ $description"
    return 0
}

check_executable() {
    local file="$1" 
    local description="$2"
    
    if [[ ! -x "$file" ]]; then
        log_error "Not executable: $description ($file)"
        return 1
    fi
    
    [[ "$QUIET" != true ]] && log_info "✓ $description (executable)"
    return 0
}

validate_preferences_content() {
    local file="$1"
    local warnings=0
    
    # Check for placeholder content
    if grep -q "\[CUSTOMIZE\]" "$file" 2>/dev/null; then
        log_error "Contains placeholder content: $file"
        ((warnings++))
    fi
    
    # Check for required sections
    local required_sections=(
        "## Code Preferences"
        "## Testing & Quality Gates" 
        "## Communication Style"
    )
    
    for section in "${required_sections[@]}"; do
        if ! grep -q "^$section" "$file" 2>/dev/null; then
            log_error "Missing section '$section' in $file"
            ((warnings++))
        fi
    done
    
    return $warnings
}

validate_context_json() {
    local file="$1"
    
    # Extract JSON block from markdown
    if ! grep -A 100 '```json' "$file" | grep -B 100 '```' | sed '1d;$d' | jq empty 2>/dev/null; then
        log_error "Invalid JSON in context file: $file"
        return 1
    fi
    
    [[ "$QUIET" != true ]] && log_info "✓ Valid JSON in context file"
    return 0
}

# Parse arguments
PROFILE="owner"
STRICT=false
QUIET=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --profile=*)
            PROFILE="${1#*=}"
            shift
            ;;
        --strict)
            STRICT=true
            shift
            ;;
        --quiet)
            QUIET=true
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

[[ "$QUIET" != true ]] && log_info "Validating agent context for profile: $PROFILE"

errors=0
warnings=0

# Required files
REQUIRED_FILES=(
    "$AGENTS_DIR/rules/${PROFILE}-preferences.md:Owner preferences and coding standards"
    "$AGENTS_DIR/profiles/${PROFILE}-context.md:Owner profile and machine-readable context"
    "$AGENTS_DIR/workflows/${PROFILE}-patterns.md:Workflow patterns and templates"
    "$AGENTS_DIR/rules/communication.md:Communication style rules"
    "$AGENTS_DIR/rules/logging.md:Logging requirements and formats"
    "$AGENTS_DIR/rules/quality.md:Quality standards and testing guidelines"
    "$AGENTS_DIR/rules/workflow.md:Task management and tool usage patterns"
    "$AGENTS_DIR/README.md:Agent system documentation"
)

# Check required files
for file_desc in "${REQUIRED_FILES[@]}"; do
    IFS=':' read -r file desc <<< "$file_desc"
    if ! check_file_exists_and_nonempty "$file" "$desc"; then
        ((errors++))
    fi
done

# Required executable tools
REQUIRED_TOOLS=(
    "$AGENTS_DIR/tools/logging/ai_log.sh:AI logging tool"
    "$AGENTS_DIR/tools/validation/check-config.sh:Configuration validation tool"
    "$AGENTS_DIR/init.sh:Agent system initialization script"
)

for tool_desc in "${REQUIRED_TOOLS[@]}"; do
    IFS=':' read -r tool desc <<< "$tool_desc"
    if [[ -f "$tool" ]] && ! check_executable "$tool" "$desc"; then
        ((errors++))
    fi
done

# Content validation
if [[ -f "$AGENTS_DIR/rules/${PROFILE}-preferences.md" ]]; then
    if ! validate_preferences_content "$AGENTS_DIR/rules/${PROFILE}-preferences.md"; then
        ((warnings++))
    fi
fi

if [[ -f "$AGENTS_DIR/profiles/${PROFILE}-context.md" ]]; then
    if ! validate_context_json "$AGENTS_DIR/profiles/${PROFILE}-context.md"; then
        ((errors++))
    fi
fi

# Check logging directory
if [[ ! -d "$AGENTS_DIR/logs" ]]; then
    log_error "Missing logs directory: $AGENTS_DIR/logs"
    ((errors++))
else
    [[ "$QUIET" != true ]] && log_info "✓ Logs directory exists"
fi

# Final result
if [[ $errors -eq 0 && ($warnings -eq 0 || "$STRICT" != true) ]]; then
    log_success "Agent context validation passed"
    if [[ $warnings -gt 0 ]]; then
        [[ "$QUIET" != true ]] && log_info "($warnings warnings - use --strict to fail on warnings)"
    fi
    exit 0
else
    log_error "Agent context validation failed: $errors errors, $warnings warnings"
    exit 1
fi