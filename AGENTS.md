# Repository Guidelines

## Project Structure & Module Organization
- `.claude/`: Core agent system
  - `hooks/` (TypeScript, Bun) — Claude Code integration (index.ts, lib.ts, session.ts)
  - `rules/` — communication, workflow, and quality rules
  - `logs/` — auto-generated daily logs for Claude sessions
  - `exports/`, `docs/`, `settings.json` — exports, docs, config
  
- `schemas/` — JSON/task schemas (e.g., `tasks.json`)
- `logs/` — project-level logs (ignored by Git)
- `temp/` — scratch space (ignored)

## Build, Test, and Development Commands
- Optional Claude hooks: `cd .claude/hooks && bun install && bun run index.ts` (Claude Code works without hooks; run only if you want auto‑logging/extra features.)
- View today’s log: `cat .claude/logs/$(date +%F).md`
- Validate configs:
  - YAML: `yamllint path/to/file.yml`
  - JSON: `jq empty path/to/file.json`
  - Shell: `shellcheck script.sh && bash -n script.sh`

## AI Logging Policy (Required)
- One file per day: `.claude/logs/YYYY-MM-DD.md` (date only in filename).
- When to log: any focused work session (>30 minutes), especially debugging/design.
- Structure per entry:
  - `# YYYY-MM-DD - [Brief Session Summary]`
  - `## Work Done` — tasks, features, bug fixes
  - `## Debugging Process` — problems, investigation, attempts (success/failed)
  - `## Lessons Learned` — insights, practices, gotchas
  - `## Technical Details` — code changes, file paths, deps
  - `## Next Steps` — remaining tasks and follow‑ups
- Notes:
  - Use concise, commit‑style bullets; include file paths/lines when helpful.
  - Append multiple sessions to the same day’s file.
  - No separate notes file; keep everything in the daily log.

### Quick Start
- Create/open: `.claude/logs/$(date +%F).md`
- Paste the headings above and fill them for your session.

### Prompt For Another AI (to draft a log)
Copy and paste:
"""
You are assisting with daily engineering logs for this repository.
Summarize today’s work into Markdown using this structure:
1) # YYYY-MM-DD - [Brief Session Summary]
2) ## Work Done
3) ## Debugging Process
4) ## Lessons Learned
5) ## Technical Details (code changes, file paths)
6) ## Next Steps
Keep it concise but complete. Output only the Markdown to append into .claude/logs/YYYY-MM-DD.md.
"""


## Coding Style & Naming Conventions
- Language: TypeScript (ES modules) in `.claude/hooks/`
- Indentation: 2 spaces; max 100–120 col.
- Filenames: lower-case, short (e.g., `index.ts`, `session.ts`)
- Names: camelCase for functions/vars; PascalCase for types; UPPER_SNAKE_CASE for constants.
- Keep hooks small, side‑effect aware, and safe-by-default (no destructive commands).

## Testing Guidelines
- No formal unit suite yet; validate behavior by running hooks and inspecting `.claude/logs/`.
- Use the validation commands above for YAML/JSON/shell assets.
- When adding scripts, include `set -euo pipefail` and provide a dry‑run or confirmation path.

## Commit & Pull Request Guidelines
- Commit style: Prefer Conventional Commits (e.g., `chore(git): ...` seen in history). If unsure, use imperative present: “add hooks config”.
- Scope changes narrowly; update docs when behavior or structure changes.
- PRs must include: summary, motivation, before/after notes, affected paths (e.g., `.claude/hooks/*`), and testing/validation steps (logs or command output). Add screenshots for UX/log changes when useful.

## Security & Configuration Tips
- Never commit secrets; review `.claude/settings.json` before pushing.
- Root `logs/` is ignored; `.claude/logs/` is committed by design for session traceability. Verify content before committing.
- Hooks aim to block dangerous commands; still avoid `rm -rf`, mass renames, or networked writes without review.
