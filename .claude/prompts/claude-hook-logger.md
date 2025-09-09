# Claude Hook Logger Setup

This prompt helps you create comprehensive logging hooks for Claude Code that automatically capture every interaction in a structured, AI-readable format.

## Overview

Creates an auto-logging system that:
- ✅ Captures every user prompt and AI response
- ✅ Uses proven Variant B structured format  
- ✅ Organizes logs by date with time-based sections
- ✅ Integrates seamlessly with Claude Code hooks
- ✅ Provides lightweight, fast logging without slowing workflow

## Hook Creation Instructions

### Step 1: Create Hook Directory Structure
```bash
mkdir -p .claude/.claude-hooks
mkdir -p .claude/logs
```

### Step 2: Create the Auto-Logging Hook

Create `.claude/.claude-hooks/user-prompt-submit.sh`:

```bash
#!/bin/bash
# Claude Code Hook: Auto-log after each user prompt
# Format: Variant B (Structured)

LOG_FILE=".claude/logs/$(date +%Y-%m-%d).md"
TIMESTAMP=$(date +%H:%M)
USER_PROMPT="$1"

# Ensure logs directory exists
mkdir -p .claude/logs

# Create log file if it doesn't exist
if [ ! -f "$LOG_FILE" ]; then
    echo "# Session Log" > "$LOG_FILE"
    echo "" >> "$LOG_FILE"
fi

# Generate descriptive title from user prompt (first 3-5 words)
TITLE=$(echo "$USER_PROMPT" | sed 's/[^a-zA-Z0-9 ]//g' | awk '{for(i=1; i<=5 && i<=NF; i++) printf "%s ", $i; print ""}' | sed 's/ *$//' | sed 's/.*/\L&/' | sed 's/\b\(.\)/\u\1/g')

# Append entry in Variant B format with time-based header
echo "## $TIMESTAMP - $TITLE" >> "$LOG_FILE"
echo "**Request:** $USER_PROMPT" >> "$LOG_FILE"
echo "**Actions:** [To be filled by AI]" >> "$LOG_FILE"
echo "**Files:** [To be updated]" >> "$LOG_FILE"
echo "**Tools:** [To be logged]" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
```

### Step 3: Make Hook Executable
```bash
chmod +x .claude/.claude-hooks/user-prompt-submit.sh
```

### Step 4: Test the Hook
```bash
# Test hook manually
.claude/.claude-hooks/user-prompt-submit.sh "create a new component for user authentication"

# Check generated log
cat .claude/logs/$(date +%Y-%m-%d).md
```

## Expected Output Format

The hook will generate logs like this:

```markdown
# Session Log

## 14:32 - Create A New Component
**Request:** create a new component for user authentication
**Actions:** [To be filled by AI]
**Files:** [To be updated]
**Tools:** [To be logged]

## 15:45 - Update Database Schema
**Request:** update database schema to include user roles
**Actions:** [To be filled by AI]
**Files:** [To be updated]
**Tools:** [To be logged]
```

## AI Integration Instructions

When Claude Code runs with this hook, instruct the AI:

> "After completing each request, update the most recent log entry in `.claude/logs/YYYY-MM-DD.md` by replacing the placeholder fields:
> - **Actions:** Describe what was actually done
> - **Files:** List specific files changed with line numbers
> - **Tools:** Note which tools were used (Write, Edit, Bash, etc.)
> 
> Keep the time-based header format and Variant B structure. Be specific and concise."

## Advanced Hook Features

### Enhanced Title Generation
For better automatic titles, modify the hook:

```bash
# Smart title generation based on common patterns
generate_title() {
    local prompt="$1"
    case "$prompt" in
        *"create"*|*"add"*|*"new"*) echo "Creation Task" ;;
        *"fix"*|*"bug"*|*"error"*) echo "Bug Fix" ;;
        *"update"*|*"modify"*|*"change"*) echo "Update Task" ;;
        *"delete"*|*"remove"*) echo "Removal Task" ;;
        *"test"*|*"check"*) echo "Testing Task" ;;
        *"deploy"*|*"build"*) echo "Deployment Task" ;;
        *) echo "Development Task" ;;
    esac
}

TITLE=$(generate_title "$USER_PROMPT")
```

### Integration with Git
Add git integration to the hook:

```bash
# Add git info if in a git repository
if git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git branch --show-current)
    echo "**Branch:** $BRANCH" >> "$LOG_FILE"
fi
```

### File Change Detection
Add automatic file change detection:

```bash
# Create pre-session file snapshot (optional)
find . -name "*.js" -o -name "*.py" -o -name "*.md" | head -20 > /tmp/pre_files.txt
```

## Hook Configuration Options

### Multiple Format Support
Create variants for different logging needs:

```bash
# In hook script, support format parameter
FORMAT=${2:-"variant-b"}  # Default to Variant B

case "$FORMAT" in
    "minimal") 
        echo "• $(date +%H:%M) → $USER_PROMPT" >> "$LOG_FILE"
        ;;
    "variant-b")
        # Current Variant B format
        ;;
    "detailed")
        # More verbose format
        ;;
esac
```

### Team Integration
For team usage, add team member identification:

```bash
USER=${USER:-$(whoami)}
echo "**User:** $USER" >> "$LOG_FILE"
```

## Troubleshooting

### Common Issues

1. **Hook not executing**
   ```bash
   # Check permissions
   ls -la .claude/.claude-hooks/
   chmod +x .claude/.claude-hooks/user-prompt-submit.sh
   ```

2. **Log directory not created**
   ```bash
   # Ensure directory exists
   mkdir -p .claude/logs
   ```

3. **Timestamp format issues**
   ```bash
   # Test timestamp generation
   date +%H:%M
   date +%Y-%m-%d
   ```

### Performance Optimization

Keep the hook lightweight:
- Minimal processing in the hook script
- Simple title generation
- Fast file operations
- No external dependencies

## Integration with Existing Workflows

### With Git Hooks
```bash
# Add to .git/hooks/pre-commit
echo "Updated by Claude session $(date)" >> .claude/logs/$(date +%Y-%m-%d).md
```

### With CI/CD
```bash
# Include logs in deployment artifacts
tar -czf logs.tar.gz .claude/logs/
```

### With Documentation Systems
```bash
# Generate daily summaries
cat .claude/logs/$(date +%Y-%m-%d).md | grep "**Request:**" > daily-summary.txt
```

## Best Practices

### Hook Development
1. **Keep it simple** - Minimal processing for speed
2. **Test thoroughly** - Verify with different input types
3. **Handle edge cases** - Empty prompts, special characters
4. **Make it portable** - Work across different systems

### Log Management
1. **Regular cleanup** - Archive old logs periodically
2. **Size monitoring** - Watch for overly large files
3. **Privacy awareness** - Ensure no sensitive data logged
4. **Team sharing** - Consider what should be in version control

This hook system provides automatic, structured logging that enhances development productivity while maintaining detailed session records for analysis and improvement.