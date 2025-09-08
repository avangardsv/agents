# Context Extraction Prompt for AI Agents

## Primary Prompt for ChatGPT/Claude

```
I need you to extract my complete engineering workflow preferences to create a reusable agents/ system that I can drop into any project. This system should contain:

STRUCTURE REQUIREMENTS:
- agents/rules/ (communication, logging, quality, workflow patterns)
- agents/tools/ (logging utilities, validation scripts)
- agents/workflows/ (project-specific workflow templates)
- Integration with .claude/ directory for Claude Code

EXTRACT FROM MY CHAT HISTORY:
1. CODE PREFERENCES:
   - Language preferences and frameworks I use
   - Code style patterns (comments, naming, error handling)
   - Testing approaches and quality gates I mention
   - Security practices I follow or request

2. COMMUNICATION STYLE:
   - How I prefer responses (concise vs detailed)
   - What level of explanation I typically want
   - How I structure requests and follow-ups
   - My reaction to different AI response patterns

3. WORKFLOW PATTERNS:
   - How I break down complex tasks
   - My approach to planning and task management
   - Tools and scripts I frequently request
   - How I handle documentation and logging

4. PROJECT ORGANIZATION:
   - Directory structures I prefer
   - File naming conventions I use
   - How I organize configs, scripts, docs
   - Integration patterns with external tools

5. LOGGING AND TRACKING:
   - What level of activity logging I want
   - How I track AI interactions and outcomes
   - My preferences for structured vs unstructured logs
   - Daily/weekly workflow patterns

OUTPUT FORMAT:
Generate structured markdown files ready to drop into:
- agents/rules/vadym-preferences.md
- agents/profiles/vadym-context.md  
- agents/workflows/vadym-patterns.md
- .claude/vadym-system-prompt.md

Each file should be specific, actionable, and immediately usable by AI agents working on my projects.
```

## Follow-up Questions to Refine

After getting the initial extraction, ask:

```
Now analyze the gaps in this profile:

1. What code preferences are missing that would help AI agents write code in my style?
2. What communication patterns would help agents match my expected interaction style?  
3. What workflow steps do I consistently follow that should be automated or templated?
4. What quality gates and validation steps do I always want applied?
5. What project setup patterns do I repeat across different repositories?

Generate additional rules and templates to fill these gaps.
```

## Integration with Our Current System

The extracted preferences should integrate with our existing structure:

```bash
# Add extracted preferences to our agents system
./agents/tools/logging/ai_log.sh context extract --source=chatgpt
./agents/tools/validation/check-context.sh --profile=vadym
```

This approach will give you much more targeted and useful context extraction than the generic prompt you used.