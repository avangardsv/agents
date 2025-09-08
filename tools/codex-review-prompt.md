# Codex Review Prompt for Agents System

## Primary Prompt

```
I need you to review my AI workflow management system (agents/ folder) and propose improvements. This system is designed to be a reusable, drop-in solution for any project to give AI agents consistent context about preferences, workflows, and quality standards.

CURRENT STRUCTURE:
```
agents/
├── README.md              # Entry point and overview
├── rules/                 # AI behavior rules and guidelines  
│   ├── communication.md   # Response style and verbosity rules
│   ├── logging.md         # Daily logging requirements
│   ├── owner-preferences.md # Code preferences and standards
│   ├── quality.md         # Code quality and security standards
│   └── workflow.md        # Task management and tool usage
├── profiles/              # User context and preferences
│   └── owner-context.md   # Machine-readable preferences
├── tools/                 # Utility tools and scripts
│   ├── logging/           # AI interaction logging utilities
│   │   └── ai_log.sh     # Dual-format logging (text + JSONL)
│   └── validation/        # Configuration validation tools
│       └── check-config.sh
├── workflows/             # Workflow templates and patterns  
│   └── owner-patterns.md  # PR templates, CI configs, project blueprints
└── .claude/               # Claude Code integration
    └── owner-system-prompt.md
```

REVIEW FOCUS AREAS:

1. **MISSING COMPONENTS**
   - What essential tools or utilities are missing?
   - What workflow automation could be added?
   - What validation or quality checks are needed?
   - What integration points with popular tools are missing?

2. **STRUCTURE IMPROVEMENTS** 
   - Is the directory organization optimal?
   - Should files be split differently or consolidated?
   - Are there better naming conventions?
   - What about cross-platform compatibility?

3. **FUNCTIONALITY GAPS**
   - What common AI workflow scenarios aren't covered?
   - What project types or tech stacks need better support?
   - What team collaboration features are missing?
   - What reporting or analytics could be valuable?

4. **TOOLING ENHANCEMENTS**
   - How can the logging system be improved?
   - What validation tools would be most useful?
   - What automation scripts would save the most time?
   - What integration APIs or webhooks would be valuable?

5. **ADOPTION & USABILITY**
   - How can onboarding be simplified?
   - What documentation improvements are needed?
   - How can customization be made easier?
   - What examples or templates would help?

CURRENT KEY FEATURES:
- Dual-format AI logging (structured text + JSONL)
- Configuration validation for Docker, YAML, JSON, shell scripts
- Owner-specific preferences and context (TypeScript/React/Tailwind focused)
- TodoWrite integration for task management
- Cross-project reusability

CONSTRAINTS:
- Must remain generic/reusable (no hardcoded personal info)
- Should work across different project types
- Prefer simple, maintainable solutions over complex ones
- Must integrate well with existing Git workflows

OUTPUT FORMAT:
Provide specific, actionable recommendations with:
1. Brief description of the gap/improvement
2. Proposed solution (files, scripts, configurations)
3. Implementation priority (High/Medium/Low)
4. Estimated complexity (Simple/Moderate/Complex)

Focus on practical improvements that would make the biggest impact for daily AI-assisted development workflows.
```

## Follow-up Prompts

After the initial review, use these to dig deeper:

```
FOLLOW-UP 1: Implementation Details
For your top 3 highest priority recommendations:
1. Provide specific file structures and code examples
2. Show integration points with existing tools
3. Detail any dependencies or prerequisites
4. Suggest testing approaches
```

```
FOLLOW-UP 2: Tech Stack Expansion  
The current system is optimized for TypeScript/React/Node.js workflows. How would you:
1. Add support for other popular stacks (Python, Go, Rust, etc.)?
2. Make the validation tools stack-agnostic?
3. Create language-specific workflow templates?
4. Handle polyglot repositories?
```

```
FOLLOW-UP 3: Team & Enterprise Features
What features would make this system valuable for:
1. Team collaboration and shared standards?
2. Enterprise compliance and auditing?
3. Metrics and productivity tracking?
4. Integration with popular dev tools (Jira, Slack, etc.)?
5. CI/CD pipeline integration beyond GitHub Actions?
```

```
FOLLOW-UP 4: AI Agent Optimization
How can this system be optimized specifically for AI agents:
1. Better context compression and retrieval?
2. Dynamic preference learning and updates?
3. Multi-agent coordination and handoffs?
4. Conflict resolution between different AI systems?
5. Performance monitoring for AI-generated code?
```

## Usage Instructions

1. **Copy the primary prompt** and paste it to Codex with the current agents/ folder contents
2. **Review the recommendations** and prioritize based on your immediate needs
3. **Use follow-up prompts** to get detailed implementation guidance for selected improvements
4. **Integrate incrementally** - implement high-priority, simple improvements first

This approach will help evolve the agents system based on comprehensive analysis while maintaining its core simplicity and reusability.