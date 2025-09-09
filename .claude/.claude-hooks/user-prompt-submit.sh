#!/bin/bash
# Claude Code Hook: Auto-log after each user prompt
# Format: Variant B (Structured)

LOG_FILE="logs/$(date +%Y-%m-%d).md"
TIMESTAMP=$(date +%H:%M)

# Ensure logs directory exists
mkdir -p logs

# Create log file if it doesn't exist
if [ ! -f "$LOG_FILE" ]; then
    echo "# Session Log - $(date +%Y-%m-%d)" > "$LOG_FILE"
    echo "" >> "$LOG_FILE"
fi

# Append entry in Variant B format
echo "**[$TIMESTAMP] Request:** $1" >> "$LOG_FILE"
echo "**Actions:** [Auto-logged - details to be filled by AI]" >> "$LOG_FILE"  
echo "**Files:** [To be updated]" >> "$LOG_FILE"
echo "**Tools:** [To be logged]" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"