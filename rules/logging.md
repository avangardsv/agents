# AI Daily Logging Requirements

## Overview

**MANDATORY**: Create daily log entries for AI prompt results and significant interactions to maintain project visibility and ensure work continuity.

## Log Format and Location

**Primary Format**: `logs/ai_prompts_YYYY-MM-DD.log` (Structured text format)
**Alternative Format**: `.ai/log.jsonl` (JSON Lines format for machine processing)

**Required Information**:
- Timestamp of interaction
- Type of request/task
- Key outcomes or deliverables
- Any issues encountered
- Follow-up actions needed
- Files affected (if applicable)

### Dual Logging Support
The system supports both traditional text logs and JSONL format for compatibility:
- **Text logs**: Human-readable daily summaries
- **JSONL logs**: Machine-processable for automation and analysis

## Example Log Entry

```
[2025-09-06 16:45:12] TASK_TYPE: Repository Setup
[2025-09-06 16:45:12] REQUEST: Create Tezos baker infrastructure with monitoring
[2025-09-06 16:45:12] DELIVERABLES: 
  - Docker compose files (ghostnet/mainnet)
  - Monitoring stack (Prometheus/Grafana/Alertmanager)  
  - Security documentation and hardening guides
  - 8 automation scripts with comprehensive logging
  - CI/CD pipeline with sanity checks
[2025-09-06 16:45:12] STATUS: COMPLETED
[2025-09-06 16:45:12] FILES_CREATED: 25+ files across docker/, monitoring/, security/, scripts/
[2025-09-06 16:45:12] ISSUES: None
[2025-09-06 16:45:12] FOLLOW_UP: Ready for deployment testing
```

## When to Log

### Mandatory Logging Triggers
- **Major implementations** (>30 minutes of work)
- **Multi-file creations** (>5 files)
- **Infrastructure changes** (Docker, CI/CD, monitoring)
- **Documentation updates** (README, guides, procedures)
- **Problem resolution** (debugging, fixes, troubleshooting)
- **End of significant work sessions**

### Optional Logging
- **Learning sessions** (research, exploration)
- **Configuration tweaks** (minor adjustments)
- **Code reviews** (analysis without changes)

## Automation Scripts

### Primary Logging Tool
```bash
# Interactive completion entry
./scripts/ai_log.sh --complete

# Manual entry (text format)
./scripts/ai_log.sh --task="Repository Setup" --status="COMPLETED" \
  --deliverables="Docker infrastructure, monitoring, security guides"

# JSONL format entry (for automation)
echo "Updated compose for Ghostnet" | scripts/ai_log.sh ops update --files docker/compose.ghostnet.yml

# Session summary
./scripts/ai_log.sh --session
```

### Cross-Project Tool (Agents Repository)
```bash
# If using centralized agents repository
./agents/tools/logging/ai_log.sh --complete

# Project-specific customization
./agents/tools/logging/ai_log.sh --project="$(basename $(pwd))" --complete
```

## Log Management

### Daily Operations
```bash
# Today's AI interactions
cat logs/ai_prompts_$(date +%Y-%m-%d).log

# Recent activity across all logs
tail -f logs/ai_prompts_*.log

# Search for specific tasks
grep "TASK_TYPE: Repository" logs/ai_prompts_*.log
```

### Analysis and Reporting
```bash
# Weekly summary
./scripts/ai_log.sh --summary --week

# Daily summary generation (JSONL to markdown)
jq -r 'select(.ts|startswith("'"$(date +%F)"'")) | "- [\(.ts)] \(.category)/\(.action) (\(.files|join(", ")))"' .ai/log.jsonl > logs/ai/$(date +%F).md

# Monthly productivity analysis
./agents/tools/logging/analyze.sh --month

# Cross-project insights
./agents/tools/logging/aggregate.sh --projects
```

### Retention Policy
- **Current month**: Keep daily logs accessible
- **Historical**: Archive monthly logs in `logs/archive/YYYY-MM/`
- **Index**: Maintain searchable index of major implementations
- **Cleanup**: Automated cleanup of logs older than 12 months

## Integration with Other Logs

### Script Logging Correlation
```bash
# Combine AI logs with script logs for full picture
./scripts/validate_logs.sh logs/

# Monitor all activity in real-time
tail -f logs/*.log | grep -E "(SUCCESS|ERROR|COMPLETED)"

# Cross-reference AI tasks with script execution
./agents/tools/logging/correlate.sh --date=$(date +%Y-%m-%d)
```

### Monitoring Integration
```bash
# Export metrics for Prometheus
./agents/tools/logging/export-metrics.sh

# Generate dashboard data
./agents/tools/logging/dashboard-data.sh --period=week
```

## Quality Assurance

### Daily Checklist
- [ ] AI prompt results logged for significant work
- [ ] All major file changes documented
- [ ] Issues and blockers recorded
- [ ] Follow-up actions identified
- [ ] Log entries are complete and searchable

### Weekly Review Process
```bash
# Generate weekly report
./agents/tools/logging/weekly-report.sh

# Validate log completeness
./agents/tools/logging/validate-completeness.sh --week

# Archive completed work
./agents/tools/logging/archive-weekly.sh
```

### Monthly Maintenance
```bash
# Compress and archive old logs
./agents/tools/logging/archive-monthly.sh

# Update logging templates based on patterns
./agents/tools/logging/update-templates.sh

# Generate productivity metrics
./agents/tools/logging/productivity-report.sh --month
```

## Customization for Different Projects

### Project-Specific Fields
```bash
# Add project context to logs
export AI_PROJECT_TYPE="infrastructure"
export AI_PROJECT_STAGE="development"

# Custom fields in log entries
./scripts/ai_log.sh --task="Setup" --meta="project_type=web-app,stage=prod"
```

### Team/Organization Adaptations
- **Compliance**: Add regulatory or audit trail requirements
- **Integration**: Connect with project management tools (Jira, Asana)
- **Reporting**: Generate team productivity and AI utilization reports
- **Standardization**: Enforce consistent logging across team members

## Troubleshooting

### Common Issues
```bash
# Missing log entries
./agents/tools/logging/check-gaps.sh --date-range="2025-01-01:2025-01-31"

# Corrupted log files
./agents/tools/logging/validate-format.sh logs/ai_prompts_*.log

# Disk space management
./agents/tools/logging/cleanup-old.sh --older-than=90days
```

### Recovery Procedures
```bash
# Reconstruct missing logs from git history
./agents/tools/logging/reconstruct-from-git.sh --date=2025-01-15

# Merge logs from multiple sources
./agents/tools/logging/merge-logs.sh --sources="local,backup,team"
```

---

**Remember**: Consistent logging is essential for project continuity, team collaboration, and measuring AI-assisted development effectiveness.