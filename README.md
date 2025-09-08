# AI Workflow Management System

## Overview

This directory contains reusable AI workflow components, rules, and tools that can be shared across different projects. It provides a standardized approach to AI-assisted development with logging, quality gates, and workflow automation.

## Directory Structure

```
agents/
├── README.md              # This file - entry point and overview
├── rules/                 # AI behavior rules and guidelines  
│   ├── communication.md   # Communication style and verbosity rules
│   ├── logging.md         # Daily logging requirements and formats
│   ├── quality.md         # Code quality and security standards
│   └── workflow.md        # Task management and tool usage patterns
├── workflows/             # Workflow automation and templates
│   └── (future workflow templates)
└── tools/                 # Utility tools and scripts
    ├── logging/          # Logging utilities and libraries
    └── validation/       # Configuration validation tools
```

## Core Components

### 🔧 **Rules System**
Standardized AI behavior patterns and requirements:
- **Communication**: Concise, direct responses with minimal verbosity
- **Logging**: Daily AI prompt results with structured format
- **Quality**: Security-first code with production readiness
- **Workflow**: TodoWrite usage and task management patterns

### 🔄 **Workflow Templates**
Framework for reusable workflow patterns:
- Repository setup and initialization guidance
- Infrastructure deployment best practices
- Documentation generation standards
- CI/CD pipeline recommendations

### 🛠️ **Tool Integration**
Utility tools that support the workflow system:
- Structured logging libraries
- Configuration validation scripts
- Automation tools for common tasks

## Usage Patterns

### Quick Start
```bash
# Initialize AI workflow in new project
cp -r agents/ /path/to/new-project/

# Set up logging
mkdir -p logs logs/ai .ai
./agents/tools/logging/ai_log.sh --help
```

### Integration with Existing Projects
```bash
# Add AI rules to existing project
ln -s /path/to/agents/rules .claude/
cp agents/tools/logging/ai_log.sh scripts/
cp agents/tools/validation/check-config.sh scripts/
```

### Daily Workflow
1. **Start session**: Initialize logging for the day
2. **Follow rules**: Apply communication and quality standards
3. **Use tools**: Leverage validation and logging utilities
4. **Log results**: Document AI interactions and outcomes
5. **Validate**: Run quality checks and configuration validation

## Project Integration

### For New Projects
- Copy entire `agents/` directory to project root
- Symlink to `.claude/` for Claude Code integration
- Initialize logging directory structure
- Set up validation and logging tools

### For Existing Projects  
- Symlink relevant rules to `.claude/`
- Copy needed tools to scripts directory
- Integrate logging with existing workflow
- Gradually adopt workflow patterns

### For Team/Organization Use
- Maintain central `agents/` repository
- Use git submodules or package management
- Standardize across all AI-assisted projects
- Version control workflow improvements

## Customization Guide

### Adapting Rules
1. **Communication**: Adjust verbosity levels per project needs
2. **Logging**: Customize log formats and retention policies  
3. **Quality**: Add project-specific quality gates
4. **Workflow**: Modify task management patterns

### Workflow Customization
1. **Environment-specific**: Adapt workflows for dev/staging/prod
2. **Technology stack**: Modify for different languages/frameworks
3. **Compliance**: Add regulatory or organizational requirements
4. **Integration**: Connect with existing tools and systems

### Tool Extensions
1. **Custom validators**: Add project-specific validation rules
2. **Automation scripts**: Create shortcuts for common tasks
3. **Integration hooks**: Connect with external systems
4. **Reporting tools**: Generate workflow analytics and reports

## Best Practices

### Implementation
- **Start small**: Begin with rules and basic logging
- **Iterate**: Gradually add more tools and workflows
- **Standardize**: Use consistent patterns across projects
- **Document**: Keep usage examples and customizations documented

### Maintenance
- **Version control**: Track changes to rules and tools
- **Review regularly**: Update based on lessons learned
- **Share improvements**: Contribute back to central repository
- **Monitor effectiveness**: Track workflow success and pain points

### Quality Assurance
- **Test tools**: Validate scripts and configurations before use
- **Review logs**: Ensure logging provides value
- **Measure outcomes**: Track productivity and quality metrics
- **Continuous improvement**: Refine based on experience

## Migration from .claude/agents.md

This system replaces the single `.claude/agents.md` file with a structured approach:

### What Moved Where
- **Daily logging rules** → `rules/logging.md`
- **Communication style** → `rules/communication.md`  
- **Quality standards** → `rules/quality.md`
- **Tool usage patterns** → `rules/workflow.md`
- **Project structure** → This README and tools

### Migration Steps
1. Review existing `.claude/agents.md` for custom rules
2. Map custom rules to appropriate files in `rules/`
3. Update logging tools to use new structure
4. Set up directory structure (`logs/`, `logs/ai/`, `.ai/`)
5. Test workflow with new organization

---

## Quick Reference

### Essential Files
- `rules/logging.md` - Daily AI logging requirements
- `tools/logging/ai_log.sh` - AI interaction logging script
- `tools/validation/check-config.sh` - Configuration validation tool
- `workflows/` - Future workflow templates

### Common Commands
```bash
# Log AI work (structured text)
./agents/tools/logging/ai_log.sh --complete

# Log AI work (JSONL format)
echo "Updated compose config" | ./agents/tools/logging/ai_log.sh ops update --files docker/compose.yml

# Generate daily summary
./agents/tools/logging/ai_log.sh --daily-summary

# Validate configuration
./agents/tools/validation/check-config.sh --all
```

This system provides a scalable, reusable foundation for AI-assisted development across multiple projects and teams.