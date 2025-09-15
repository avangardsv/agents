# Repository Guidelines

## Project Structure & Module Organization
- `.claude/`: Core agent system
  - `hooks/` (TypeScript, Bun) — Claude Code integration (index.ts, lib.ts, session.ts)
  - `rules/` — communication, workflow, and quality rules
  - `logs/` — auto-generated daily logs for Claude sessions
  - `exports/`, `docs/`, `settings.json` — exports, docs, config
- `scripts/` — helper scripts (e.g., `log-ai-chat.sh` for log capture)
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
- Log every time you ask or get an AI reply using the script.
- Clipboard: `make log-clipboard` (title auto‑set to today’s date)
- File: `make log-file FILE=transcript.txt` (title auto‑set to today’s date)
- Default source is `claude`; override via `make log-clipboard SOURCE=codex` if needed.
- Outputs go to `logs/ai/YYYY-MM-DD.md` and `logs/notes/YYYYMMDD.txt`.

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
