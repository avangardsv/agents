# AI Agents Boilerplate

This is a boilerplate repository for different AI agents that can be easily cloned and used across projects. Currently set up especially for interaction with Claude Code, with plans to expand to other AI systems.

## Quick Setup

```bash
# Clone this repository structure to your project
cp -r .claude/ /path/to/your/project/

# Or use git
git clone <this-repo> your-project-agents
cd your-project-agents
cp -r .claude/ ../your-project/
```

## What's Included

### 📁 `.claude/` Directory Structure
```
.claude/
├── rules/                 # AI behavior rules and guidelines
│   ├── communication.md   # Communication style and verbosity
│   ├── logging.md         # Daily logging requirements
│   ├── quality.md         # Code quality and security standards
│   └── workflow.md        # Task management patterns
├── workflows/             # Workflow automation templates
│   └── logging.md         # Session logging workflow
├── prompts/               # Reusable prompt templates
│   └── logging.md         # Comprehensive logging system guide
├── logs/                  # Session logs (auto-generated)
│   ├── YYYY-MM-DD.md     # Daily session logs
└── .claude-hooks/         # Claude Code hooks
    └── user-prompt-submit.sh  # Auto-logging hook
```

## Current Focus: Claude Code Integration

This boilerplate is currently optimized for **Claude Code** with:

- ✅ **Auto-logging hooks** - Captures every interaction
- ✅ **Session tracking** - Time-based structured logging  
- ✅ **Workflow templates** - Proven development patterns
- ✅ **Quality rules** - Security and code standards
- ✅ **Communication guidelines** - Consistent AI behavior

## Usage Patterns

### For New Projects
```bash
# Copy the entire .claude structure
cp -r .claude/ /path/to/new-project/

# The hooks and rules will work immediately
```

### For Existing Projects  
```bash
# Selectively copy what you need
cp -r .claude/rules /path/to/project/.claude/
cp -r .claude/.claude-hooks /path/to/project/.claude/
```

## Future AI Systems

This boilerplate will expand to support:
- **Gemini CLI** - Google's AI system
- **OpenAI API** - ChatGPT integration
- **Local models** - Ollama, LM Studio
- **Custom agents** - Project-specific AI workflows

Each AI system will have its own optimized configuration while maintaining the same core structure.

## Key Features

### 🔧 **Rules System**
Standardized AI behavior patterns:
- Communication style (concise, direct)
- Logging requirements (structured format)
- Quality standards (security-first)
- Workflow patterns (TodoWrite usage)

### 📝 **Logging System**
Comprehensive session tracking:
- Time-based entries (`## HH:MM - Title`)
- Structured format (Variant B)
- Auto-hooks for Claude Code
- AI-readable simple structure

### 🔄 **Workflow Templates**
Ready-to-use patterns for:
- Repository setup and initialization
- Development session management
- Documentation generation
- CI/CD pipeline integration

## Customization

### Project-Specific Rules
Edit files in `.claude/rules/` to match your:
- Project requirements
- Team standards  
- Compliance needs
- Technology stack

### Hook Customization
Modify `.claude/.claude-hooks/` for:
- Different logging formats
- Custom automation triggers
- Integration with external systems
- Team-specific workflows

## Best Practices

### Implementation
1. **Start simple** - Use basic logging and rules first
2. **Iterate gradually** - Add more tools and workflows over time
3. **Maintain consistency** - Use same patterns across projects
4. **Document changes** - Keep customizations tracked

### Maintenance
- **Version control** - Track changes to rules and workflows
- **Regular updates** - Refine based on usage lessons
- **Share improvements** - Contribute back to boilerplate
- **Test thoroughly** - Validate configurations before deployment

## Contributing

This boilerplate improves through real usage. Please contribute:
- New AI system integrations
- Improved workflow templates  
- Better rule definitions
- Usage pattern documentation

## License

Open source - use freely across projects and teams.

---

**Current Status**: Optimized for Claude Code  
**Next**: Gemini CLI and OpenAI integrations  
**Vision**: Universal AI agents boilerplate for any project