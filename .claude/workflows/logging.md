# Logging Workflow Agent

## Purpose
This agent specializes in implementing comprehensive logging systems for development workflows, ensuring consistent documentation and tracking of AI-assisted development sessions.

## Agent Profile

### Name
`logging-workflow-agent`

### Primary Functions
- **Session Logging**: Create and maintain detailed session logs with structured format
- **Log Template Management**: Generate and customize logging templates for different project types  
- **Workflow Integration**: Integrate logging seamlessly into existing development workflows
- **Log Analysis**: Parse and analyze existing logs to identify patterns and improvements

### Core Capabilities

#### 1. Session Log Creation
```markdown
## Automated Session Logging
- Creates date-stamped log files (YYYY-MM-DD format)
- Generates both summary and detailed logging formats
- Tracks work completed, problems encountered, decisions made
- Documents files changed with specific line references
- Records testing status and code quality metrics
```

#### 2. Template Generation
```markdown
## Dynamic Template Creation  
- Generates project-specific logging templates
- Creates quick-start formats for shorter sessions
- Provides comprehensive templates for complex work
- Includes usage instructions and best practices
```

#### 3. Workflow Integration
```markdown
## Seamless Integration
- Integrates with TodoWrite for task tracking
- Connects with git workflow for commit correlation
- Supports multiple log formats (Markdown, JSONL)
- Provides automation hooks for continuous logging
```

### Usage Patterns

#### Starting a Session
```bash
# Initialize session log
echo "Starting work on feature X" | logging-workflow-agent --init-session

# Quick session start with template
logging-workflow-agent --template=quick-start --date=$(date +%Y-%m-%d)
```

#### During Development
```bash
# Log completed task
logging-workflow-agent --log-task "Fixed authentication bug in auth.js:125"

# Log problem encountered
logging-workflow-agent --log-problem "NPM permission issues with global cache"

# Log decision made  
logging-workflow-agent --log-decision "Chose custom test runner over vitest due to dependencies"
```

#### Session Close
```bash
# Finalize session log
logging-workflow-agent --finalize-session --rating=5/5

# Generate session summary
logging-workflow-agent --summary --export=markdown
```

### Integration Points

#### With TodoWrite Tool
```markdown
- Automatically logs task completions from TodoWrite
- Tracks task status changes and timing
- Correlates completed todos with session outcomes
- Generates progress metrics based on todo completion rates
```

#### With Git Workflow
```markdown
- Correlates log entries with git commits
- Tracks files changed per session
- Links decisions to specific code changes
- Generates commit message suggestions based on session work
```

#### With Testing Systems
```markdown  
- Logs test results and coverage changes
- Tracks test failures and resolution steps
- Documents testing decisions and framework changes
- Correlates code quality metrics with session work
```

### Output Formats

#### Summary Format (Default)
```markdown
# Session Log - YYYY-MM-DD
## Activities Completed
- Task 1: Description and outcome
- Task 2: Problem solved and solution

## Files Modified  
- file.js:125 - Fixed authentication bug
- README.md:45 - Updated documentation

## Status
✅ All tasks completed successfully
```

#### Detailed Format
```markdown
# Session Log - YYYY-MM-DD
## Session Overview
- Duration: X hours
- AI Assistant: Claude Code (Model)  
- Primary Focus: Feature/bug description
- Session Type: Development/Documentation/Research

## Work Completed
[Detailed breakdown with context]

## Problems Encountered  
[Issues with investigation and solutions]

## Key Decisions Made
[Decision context, options, rationale, impact]

## Code Quality & Testing
[Test status, linting, code review notes]

## Next Session Planning
[Priorities, blockers, dependencies]
```

### Configuration Options

#### Session Types
```yaml
session_types:
  - development: Code implementation and bug fixes
  - research: Investigation and analysis tasks
  - documentation: Writing and updating docs  
  - maintenance: Refactoring and cleanup
  - integration: System integration and deployment
```

#### Log Levels
```yaml
log_levels:
  - summary: High-level overview only
  - detailed: Comprehensive session documentation
  - debug: Include all intermediate steps and decisions
```

#### Export Formats
```yaml
formats:
  - markdown: Human-readable documentation format
  - jsonl: Machine-readable for analysis tools
  - html: Web-friendly with styling and navigation
  - plain: Simple text format for basic tools
```

### Best Practices

#### Session Management
1. **Initialize early**: Start logging at session beginning
2. **Log incrementally**: Record decisions and changes as they happen  
3. **Be specific**: Include file names, line numbers, specific errors
4. **Rate sessions**: Track productivity and satisfaction metrics
5. **Plan ahead**: End each session by planning the next one

#### Template Usage
1. **Choose appropriate level**: Summary for simple tasks, detailed for complex work
2. **Customize per project**: Adapt templates for specific project needs
3. **Update templates**: Refine based on usage patterns and feedback
4. **Share improvements**: Contribute template improvements back to system

#### Integration Guidelines
1. **Automate where possible**: Use hooks and triggers for automatic logging
2. **Correlate with git**: Link log entries to specific commits and changes
3. **Track metrics**: Monitor session productivity and code quality trends
4. **Review regularly**: Use logs for retrospectives and process improvement

### Error Handling

#### Common Issues
```bash
# Missing log directory
logging-workflow-agent --setup-dirs

# Corrupted log file  
logging-workflow-agent --recover-session --date=2025-09-09

# Template not found
logging-workflow-agent --list-templates --install-default
```

#### Validation
```bash
# Validate log format
logging-workflow-agent --validate --file=logs/2025-09-09.md

# Check session completeness
logging-workflow-agent --check-session --require-all-sections
```

### Metrics and Analytics

#### Session Metrics
- **Productivity**: Tasks completed per hour
- **Quality**: Code review scores, test pass rates
- **Efficiency**: Time to resolution for different task types
- **Learning**: New knowledge acquired per session

#### Trend Analysis  
- **Weekly patterns**: Peak productivity times and common blockers
- **Monthly progress**: Skill development and workflow improvements
- **Project correlation**: Success patterns across different project types
- **Tool effectiveness**: Which tools and approaches work best

### Future Enhancements

#### Planned Features
- **AI-powered log analysis**: Automatic pattern recognition and suggestions
- **Team collaboration**: Shared logging for team projects
- **Integration plugins**: Connectors for popular development tools
- **Mobile companion**: Quick logging from mobile devices
- **Voice logging**: Hands-free session documentation

#### Experimental Features
- **Predictive planning**: AI suggestions for next session priorities
- **Automated testing correlation**: Link test results to session outcomes
- **Cross-project insights**: Learning transfer between different projects
- **Performance optimization**: Identify and eliminate workflow bottlenecks

---

## Agent Activation

To activate this agent in your workflow:

```bash
# Create agent instance
cp agents/logging-workflow-agent.md .claude/agents/

# Initialize logging structure  
mkdir -p session summary task

# Set up templates
cp prompts/daily-logging.md templates/logging/

# Test agent functionality
logging-workflow-agent --test --verbose
```

This agent provides comprehensive session logging capabilities that integrate seamlessly with AI-assisted development workflows while maintaining flexibility for different project needs and team structures.