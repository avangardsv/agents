#!/usr/bin/env bash

set -euo pipefail

# Script to log AI chat outputs into daily logs (text + JSONL + markdown summary)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_DIR="$(dirname "$SCRIPT_DIR")"
PROJECT_ROOT="$(dirname "$AGENTS_DIR")"

# Try to source logging helpers if available
if [[ -f "$AGENTS_DIR/lib/log.sh" ]]; then
  # shellcheck disable=SC1090
  source "$AGENTS_DIR/lib/log.sh"
else
  log_info() { echo "[INFO] $*"; }
  log_error() { echo "[ERROR] $*" >&2; }
  log_success() { echo "[SUCCESS] $*"; }
fi

AI_LOG_TOOL="$AGENTS_DIR/tools/logging/ai_log.sh"
LOG_DIR="$AGENTS_DIR/logs"
AI_DIR="$AGENTS_DIR/logs/ai"
NOTES_DIR="$AGENTS_DIR/logs/notes"
DATE_LOCAL=$(date '+%Y-%m-%d')
TIME_LOCAL=$(date '+%H:%M:%S')
DATE_SHORT=$(date '+%Y%m%d')
DAILY_MD="$AI_DIR/$DATE_LOCAL.md"

usage() {
  cat <<'EOF'
Log AI Chat Output

Usage:
  ./log-ai-chat.sh --source=chatgpt --title="Feature spec"            # Reads from clipboard if available, else prompts
  pbpaste | ./log-ai-chat.sh --source=claude --title="Refactor plan"  # Read from stdin
  ./log-ai-chat.sh --source=other --file=path/to/chat.txt --title="X"  # Read from file

Options:
  --source=NAME     chatgpt | claude | copilot | other (required)
  --title=TEXT      Short title for the entry (optional)
  --tags=LIST       Comma-separated tags (optional)
  --file=PATH       Read chat content from file (optional)
  --role=ROLE       prompt | response (optional, default: response)
  --note=TEXT       Short note to append into logs/notes/YYYYMMDD.txt
  --help, -h        Show this help

Notes:
  - Writes JSONL via tools/logging/ai_log.sh with category "chat" and action SOURCE
  - Appends a markdown entry to logs/ai/YYYY-MM-DD.md
  - Appends a one-line note into logs/notes/YYYYMMDD.txt (time + note)
EOF
}

have_cmd() { command -v "$1" >/dev/null 2>&1; }

read_from_clipboard() {
  if have_cmd pbpaste; then
    pbpaste
  elif have_cmd xclip; then
    xclip -selection clipboard -o 2>/dev/null || true
  elif have_cmd xsel; then
    xsel -b -o 2>/dev/null || true
  else
    return 1
  fi
}

SOURCE=""
TITLE="Untitled Chat"
TAGS=""
ROLE="response"
FILE_INPUT=""
NOTE_TEXT=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --source=*) SOURCE="${1#*=}"; shift ;;
    --title=*)  TITLE="${1#*=}"; shift ;;
    --tags=*)   TAGS="${1#*=}"; shift ;;
    --role=*)   ROLE="${1#*=}"; shift ;;
    --file=*)   FILE_INPUT="${1#*=}"; shift ;;
    --note=*)   NOTE_TEXT="${1#*=}"; shift ;;
    --help|-h)  usage; exit 0 ;;
    *) log_error "Unknown option: $1"; usage; exit 1 ;;
  esac
done

if [[ -z "$SOURCE" ]]; then
  log_error "--source is required (chatgpt|claude|copilot|other)"
  usage
  exit 1
fi

mkdir -p "$LOG_DIR" "$AI_DIR" "$NOTES_DIR"

if [[ ! -x "$AI_LOG_TOOL" ]]; then
  if [[ -f "$AI_LOG_TOOL" ]]; then
    chmod +x "$AI_LOG_TOOL" || true
  else
    log_error "Missing required tool: $AI_LOG_TOOL"
    exit 1
  fi
fi

# Determine input content precedence: stdin > --file > clipboard > prompt
CONTENT=""
if [[ ! -t 0 ]]; then
  CONTENT=$(cat)
elif [[ -n "$FILE_INPUT" ]]; then
  if [[ -f "$FILE_INPUT" ]]; then
    CONTENT=$(cat "$FILE_INPUT")
  else
    log_error "File not found: $FILE_INPUT"
    exit 1
  fi
else
  if CLIP=$(read_from_clipboard); then
    if [[ -n "${CLIP//[[:space:]]/}" ]]; then
      CONTENT="$CLIP"
    fi
  fi
  if [[ -z "${CONTENT//[[:space:]]/}" ]]; then
    log_info "Paste the chat content, then press Ctrl-D (EOF)"
    CONTENT=$(cat)
  fi
fi

if [[ -z "${CONTENT//[[:space:]]/}" ]]; then
  log_error "No chat content provided. Aborting."
  exit 1
fi

# Log to JSONL via ai_log.sh (category=chat, action=SOURCE)
echo "$CONTENT" | "$AI_LOG_TOOL" chat "$SOURCE"

# Append to daily markdown summary with a collapsible section
{
  if [[ ! -s "$DAILY_MD" ]]; then
    echo "# AI Activity Summary - $DATE_LOCAL"
    echo
    echo "## Actions Taken"
    echo "- See JSONL log for structured entries"
    echo
    echo "## Chats"
  fi
  echo ""
  echo "### $TITLE ($SOURCE) - $TIME_LOCAL"
  if [[ -n "$TAGS" ]]; then
    echo "Tags: $(echo "$TAGS" | sed 's/,/, /g')"
  fi
  echo "<details><summary>Show transcript</summary>"
  echo
  echo '```text'
  printf "%s\n" "$CONTENT"
  echo '```'
  echo
  echo "</details>"
} >> "$DAILY_MD"

# Append a short note line to notes/YYYYMMDD.txt
NOTES_FILE="$NOTES_DIR/$DATE_SHORT.txt"
if [[ -z "${NOTE_TEXT//[[:space:]]/}" ]]; then
  NOTE_TEXT="$TITLE [$SOURCE]"
fi
printf "%s %s\n" "$TIME_LOCAL" "$NOTE_TEXT" >> "$NOTES_FILE"

log_success "Chat logged to JSONL, appended to $DAILY_MD, noted in $NOTES_FILE"

