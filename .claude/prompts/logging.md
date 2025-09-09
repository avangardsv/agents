# Daily Logging System

Comprehensive logging format for AI development sessions based on real project usage and testing. This system uses time-based sections with Variant B structured format.

## File Structure

### Log File Naming
- `YYYY-MM-DD.md` - Daily session logs (filename contains date)
- All logs stored in single `logs/` directory (no subdirectories)
- Clean, AI-readable structure

### Storage Location
- Single directory: `logs/` only
- No backups or archives (git provides version control)
- Simple flat structure for AI readability

## Standard Log Format

### Required Format (Variant B - Proven Best)
```markdown
# Session Log

## HH:MM - Descriptive Title
**Request:** What was asked
**Actions:** What was done  
**Files:** Files changed with line numbers
**Tools:** Tools used

## HH:MM - Next Entry Title
**Request:** Next request description
**Actions:** Actions taken for this task
**Files:** Specific files and changes
**Tools:** Tools utilized
```

### Key Rules (Learned from Usage)
- Header: `# Session Log` (no date - filename has it)
- Time sections: `## HH:MM - Title` format only
- Use random times if unknown, keep chronological order
- All content follows **Variant B** structured format
- No old section-based headers allowed

### Conversion from Old Formats
If you encounter these old section headers, convert them to time-based format:

**❌ Remove these headers:**
- `## Previous Session Overview`
- `## Work Completed`  
- `## Problems Encountered`
- `## Key Decisions Made`
- `## Next Session Planning`
- `## Code Quality & Testing`
- `## Learning & Insights`
- `## Resource References`
- `## Communication Notes`
- `## Metrics & Progress`

**✅ Convert to time-based entries:**
```markdown
## 11:30 - Code Quality Review
**Request:** Review code quality and testing status
**Actions:** Verified tests passing, documented standards
**Files:** Multiple files reviewed
**Tools:** Testing framework, Documentation

## 11:00 - Session Planning  
**Request:** Plan next steps and identify blockers
**Actions:** Documented priorities and dependencies
**Files:** Session planning notes
**Tools:** Planning, Analysis
```

## Implementation Details

### Hook Integration
- `.claude-hooks/user-prompt-submit.sh` auto-creates log entries
- Hook uses Variant B format with timestamps
- Manual entries follow same format

### Time Management
- Use actual times when known
- Generate random times in chronological order if unknown
- Times help organize work flow and identify patterns

### Content Guidelines
- Be specific: include file paths and line numbers
- Keep entries concise but informative
- Focus on request/action/result pattern
- No verbose explanations (Variant B provides structure)

## Real Usage Examples

### ✅ Successful Pattern
```markdown
# Session Log

## 20:32 - Logging System Setup
**Request:** Create logging agent and cleanup logs structure
**Actions:** Built logging workflow, simplified log structure, implemented Variant B hook format  
**Files:** workflows/logging.md:new, README.md:12-25, logs/ (cleaned)
**Tools:** Write, Edit, TodoWrite, Bash

## 14:54 - AGENTS.md Creation Bug Fix
**Request:** Fix AGENTS.md creation and implement daily logging
**Actions:** Fixed init.sh default behavior, created logging templates
**Files:** .agents/init.sh:247-250, AGENTS.md:37-50
**Tools:** Write, Edit
```

### ❌ What NOT to do
```markdown
# Session Log - 2025-09-09  ❌ (no date in header)

## Work Completed  ❌ (not time-based)
- Fixed bug
- Updated files

## Problems Encountered  ❌ (old section format)
- Had issues with X
```

## Hook Implementation

### Auto-logging Hook
Located: `.claude-hooks/user-prompt-submit.sh`
- Automatically creates log entries after each user prompt
- Uses Variant B format with timestamps
- Creates daily log files automatically

### Hook Format Output
```bash
**[HH:MM] Request:** User request text
**Actions:** [To be filled by AI]
**Files:** [To be updated]  
**Tools:** [To be logged]
```

## Best Practices (Learned from Usage)

### Format Rules
- **Single format**: Always use Variant B (no format switching)
- **Time headers**: Every entry needs `## HH:MM - Title` format
- **No old headers**: Convert any `## Section Name` to time-based
- **Simple structure**: Flat logs/ directory, no subdirectories
- **No dates in headers**: Filename has date, header is just `# Session Log`
- **Clean content**: Remove verbose old-style sections

### Content Standards  
- **Specificity**: Include file paths and line numbers
- **Chronological order**: Earlier times first, later times last
- **Concise titles**: Descriptive but brief section titles
- **Tool tracking**: Always note which tools were used
- **File references**: Specific files with line numbers when relevant

## Migration Notes

### From Old Logging Systems
- Remove all old section-based headers
- Convert everything to time-based `## HH:MM - Title` format
- Consolidate multiple sections into single time entries
- Eliminate backup files and complex directory structures
- Use single `logs/` directory only

### Key Learnings Applied
1. **Simple beats complex**: Flat directory structure works better
2. **Time-based organization**: Chronological entries more useful than categorical
3. **Consistent format**: Variant B provides perfect structure/brevity balance
4. **AI-readable**: Simple format makes logs easier to parse and analyze
5. **No redundancy**: Filename date eliminates need for header dates
6. **Git integration**: Version control handles backups, no need for .backup files

## Format Variants (For Reference)

### Variant A: Minimal (Not Recommended)
```
• User: [request summary]
• AI: [action taken] 
• Files: file1.js, file2.md
```

### Variant B: Structured (RECOMMENDED)
```
**Request:** Feature implementation
**Actions:** Created component, updated tests
**Files:** src/Component.jsx:15, test/Component.test.js:new
**Tools:** Write, Edit, Bash
```

### Variant C: Detailed (Too Verbose)
```
**Session:** 2025-09-09 20:30
**Request:** Add dark mode toggle to settings
**Summary:** Implemented toggle component with state management
**Changes:** 
  - Created: components/DarkModeToggle.jsx
  - Modified: src/Settings.jsx:45-60
**Tools Used:** Write(2), Edit(1), Bash(1)
**Status:** ✅ Complete
```

**Use Variant B only** - it provides the perfect balance of structure and brevity.

## Usage Instructions

### Starting a Session
1. Hook automatically creates entries, or manually create: `logs/YYYY-MM-DD.md`
2. Use `# Session Log` header (no date)
3. Start with first time-based entry

### During the Session
- Each significant action gets a new `## HH:MM - Title` section
- Follow Variant B format consistently
- Be specific about files and changes
- Note tools used for each task

### Quality Checklist
- [ ] All entries have `## HH:MM - Title` format
- [ ] All content uses Variant B structure
- [ ] No old section headers remain
- [ ] File changes include line numbers when relevant
- [ ] Tools are documented for each entry
- [ ] Chronological order maintained

This system has been tested and refined through actual usage, providing a proven approach to development session logging that is both AI-readable and human-friendly.