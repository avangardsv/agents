#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$(dirname "$SCRIPT_DIR")")")"

if [[ -f "$PROJECT_ROOT/lib/log.sh" ]]; then
    source "$PROJECT_ROOT/lib/log.sh"
elif [[ -f "$SCRIPT_DIR/../../lib/log.sh" ]]; then
    source "$SCRIPT_DIR/../../lib/log.sh"
else
    log_info() { echo "[INFO] $*"; }
    log_error() { echo "[ERROR] $*" >&2; }
fi

LOG_DIR="$PROJECT_ROOT/logs"
AI_LOG_DIR="$PROJECT_ROOT/logs/ai"
JSONL_LOG="$PROJECT_ROOT/.ai/log.jsonl"
DATE=$(date '+%Y-%m-%d')
TIME=$(date '+%Y-%m-%d %H:%M:%S')
LOG_FILE="$LOG_DIR/ai_prompts_$DATE.log"

mkdir -p "$LOG_DIR" "$AI_LOG_DIR" "$(dirname "$JSONL_LOG")"

show_help() {
    cat << 'EOF'
AI Prompt Logging Tool

Usage:
  ./ai_log.sh --complete                        # Interactive completion entry
  ./ai_log.sh --session                         # Session summary entry  
  ./ai_log.sh [options]                         # Manual entry
  echo "message" | ./ai_log.sh category action  # JSONL format entry

Options:
  --task=TASK         Task description/type
  --status=STATUS     Task status (PENDING|IN_PROGRESS|COMPLETED|BLOCKED)
  --deliverables=LIST Comma-separated list of deliverables
  --issues=TEXT       Issues encountered (optional)
  --followup=TEXT     Follow-up actions needed (optional)
  --files=COUNT       Number of files created/modified (optional)
  --summary=TEXT      Session summary (for --session mode)
  --week              Show weekly summary
  --month             Show monthly summary
  --daily-summary     Generate daily summary from JSONL
  --help, -h          Show this help

Examples:
  ./ai_log.sh --task="Repository Setup" --status="COMPLETED" --deliverables="Docker infrastructure, monitoring"
  ./ai_log.sh --complete
  ./ai_log.sh --session --summary="Implemented logging system and workflow structure"
  echo "Updated compose for Ghostnet" | ./ai_log.sh ops update --files docker/compose.ghostnet.yml
  ./ai_log.sh --daily-summary
  ./ai_log.sh --week
EOF
}

log_entry() {
    local task="$1"
    local status="$2"
    local deliverables="${3:-}"
    local issues="${4:-}"
    local followup="${5:-}"
    local files="${6:-}"
    
    {
        echo "[$TIME] TASK_TYPE: $task"
        echo "[$TIME] STATUS: $status"
        if [[ -n "$deliverables" ]]; then
            echo "[$TIME] DELIVERABLES:"
            IFS=',' read -ra ITEMS <<< "$deliverables"
            for item in "${ITEMS[@]}"; do
                echo "  - $(echo "$item" | sed 's/^[[:space:]]*//')"
            done
        fi
        if [[ -n "$files" ]]; then
            echo "[$TIME] FILES_AFFECTED: $files"
        fi
        if [[ -n "$issues" ]]; then
            echo "[$TIME] ISSUES: $issues"
        else
            echo "[$TIME] ISSUES: None"
        fi
        if [[ -n "$followup" ]]; then
            echo "[$TIME] FOLLOW_UP: $followup"
        fi
        echo ""
    } >> "$LOG_FILE"
    
    log_info "AI prompt logged to $LOG_FILE"
}

interactive_complete() {
    echo "AI Task Completion Logger"
    echo "========================"
    
    read -p "Task/Request type: " task
    
    echo "Status options: PENDING, IN_PROGRESS, COMPLETED, BLOCKED"
    read -p "Status: " status
    
    read -p "Deliverables (comma-separated): " deliverables
    read -p "Files created/modified (optional): " files
    read -p "Issues encountered (optional): " issues  
    read -p "Follow-up actions (optional): " followup
    
    log_entry "$task" "$status" "$deliverables" "$issues" "$followup" "$files"
}

session_summary() {
    local summary="$1"
    
    {
        echo "[$TIME] SESSION_SUMMARY: $summary"
        echo "[$TIME] SESSION_END: $(date '+%H:%M:%S')"
        echo ""
    } >> "$LOG_FILE"
    
    log_info "Session summary logged to $LOG_FILE"
}

log_jsonl() {
    local category="$1"
    local action="$2"
    local message="$3"
    local files="${4:-}"
    
    local timestamp=$(date -u '+%Y-%m-%dT%H:%M:%S.%3NZ')
    local files_array="[]"
    
    if [[ -n "$files" ]]; then
        files_array=$(echo "$files" | jq -R 'split(",") | map(gsub("^\\s+|\\s+$"; ""))')
    fi
    
    local json_entry=$(jq -n \
        --arg ts "$timestamp" \
        --arg cat "$category" \
        --arg act "$action" \
        --arg msg "$message" \
        --argjson files "$files_array" \
        '{ts: $ts, category: $cat, action: $act, message: $msg, files: $files}')
    
    echo "$json_entry" >> "$JSONL_LOG"
    log_info "JSONL entry added to $JSONL_LOG"
}

generate_daily_summary() {
    local summary_file="$AI_LOG_DIR/$DATE.md"
    
    if [[ ! -f "$JSONL_LOG" ]]; then
        log_error "JSONL log file not found: $JSONL_LOG"
        return 1
    fi
    
    if ! command -v jq >/dev/null 2>&1; then
        log_error "jq is required for daily summary generation"
        return 1
    fi
    
    {
        echo "# AI Activity Summary - $DATE"
        echo ""
        echo "## Actions Taken"
        
        jq -r 'select(.ts|startswith("'"$DATE"'")) | "- [\(.ts)] \(.category)/\(.action) (\(.files|join(", ")))"' "$JSONL_LOG" 2>/dev/null || echo "No JSONL entries found for today."
        
        echo ""
        echo "## Detailed Logs"
        echo "- Text log: \`logs/ai_prompts_$DATE.log\`"
        echo "- JSONL log: \`.ai/log.jsonl\`"
        
    } > "$summary_file"
    
    log_info "Daily summary generated: $summary_file"
}

show_summary() {
    local period="$1"
    
    case "$period" in
        "week")
            echo "Weekly AI Activity Summary"
            echo "========================="
            find "$LOG_DIR" -name "ai_prompts_*.log" -mtime -7 -exec cat {} \; | grep -E "(TASK_TYPE|STATUS|DELIVERABLES)" | head -50
            ;;
        "month")
            echo "Monthly AI Activity Summary"
            echo "=========================="
            find "$LOG_DIR" -name "ai_prompts_*.log" -mtime -30 -exec cat {} \; | grep -E "(TASK_TYPE|STATUS)" | head -100
            ;;
        *)
            echo "Today's AI Activity"
            echo "=================="
            if [[ -f "$LOG_FILE" ]]; then
                cat "$LOG_FILE"
            else
                echo "No activity logged for today."
            fi
            ;;
    esac
}

TASK=""
STATUS=""
DELIVERABLES=""
ISSUES=""
FOLLOWUP=""
FILES=""
SUMMARY=""
MODE=""
CATEGORY=""
ACTION=""

# Check if being used in pipeline for JSONL format
if [[ ! -t 0 ]] && [[ $# -ge 2 ]] && [[ "$1" != "--"* ]]; then
    # Reading from stdin, first two args are category and action
    CATEGORY="$1"
    ACTION="$2"
    shift 2
    
    # Read message from stdin
    MESSAGE=$(cat)
    
    # Parse remaining arguments for files
    while [[ $# -gt 0 ]]; do
        case $1 in
            --files=*)
                FILES="${1#*=}"
                shift
                ;;
            *)
                shift
                ;;
        esac
    done
    
    log_jsonl "$CATEGORY" "$ACTION" "$MESSAGE" "$FILES"
    exit 0
fi

while [[ $# -gt 0 ]]; do
    case $1 in
        --complete)
            MODE="complete"
            shift
            ;;
        --session)
            MODE="session"
            shift
            ;;
        --week)
            MODE="week_summary"
            shift
            ;;
        --month)
            MODE="month_summary"
            shift
            ;;
        --daily-summary)
            MODE="daily_summary"
            shift
            ;;
        --task=*)
            TASK="${1#*=}"
            shift
            ;;
        --status=*)
            STATUS="${1#*=}"
            shift
            ;;
        --deliverables=*)
            DELIVERABLES="${1#*=}"
            shift
            ;;
        --issues=*)
            ISSUES="${1#*=}"
            shift
            ;;
        --followup=*)
            FOLLOWUP="${1#*=}"
            shift
            ;;
        --files=*)
            FILES="${1#*=}"
            shift
            ;;
        --summary=*)
            SUMMARY="${1#*=}"
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

case "$MODE" in
    "complete")
        interactive_complete
        ;;
    "session")
        if [[ -z "$SUMMARY" ]]; then
            read -p "Session summary: " SUMMARY
        fi
        session_summary "$SUMMARY"
        ;;
    "week_summary")
        show_summary "week"
        ;;
    "month_summary")
        show_summary "month"
        ;;
    "daily_summary")
        generate_daily_summary
        ;;
    *)
        if [[ -n "$TASK" && -n "$STATUS" ]]; then
            log_entry "$TASK" "$STATUS" "$DELIVERABLES" "$ISSUES" "$FOLLOWUP" "$FILES"
        elif [[ -z "$TASK" && -z "$STATUS" ]]; then
            show_summary "today"
        else
            echo "Error: Both --task and --status are required for manual entry" >&2
            show_help
            exit 1
        fi
        ;;
esac