# Owner — Engineering Rules & Preferences
Version: 2025-09-08

## Scope
Authoritative rules for AI agents and collaborators. Applies to **all** repos unless a local ruleset overrides sections explicitly.

---

## Code Preferences
- **Language**: TypeScript **strict** mode; ES Modules only. No `require()`.
- **Imports**: Absolute `@/` base path. Group and sort. Avoid circular deps.
- **Frameworks (frontend)**: React, Next.js (App Router), SvelteKit v5. UI: Tailwind, shadcn/ui.
- **State/Data**: TanStack Query; minimal Redux only if justified. REST/GraphQL allowed; must be typed.
- **Backend**: Node/NestJS, Prisma ORM, PostgreSQL.
- **Styling**: Tailwind utilities; extract repeated patterns into components or light `@apply` when truly reusable.
- **Components**: Functional only; every React component MUST have `displayName`.
- **Comments**: Keep minimal. No noisy or redundant comments. Use JSDoc for public APIs only.
- **Error Handling**: Never swallow errors. Use typed error shapes. Show friendly messages at UI boundaries.
- **API Layer**: Single source module `lib/api` with typed IO, retries, caching policies.
- **Performance**: Measure first (Web Vitals, bundle budgets). Code-split heavy routes. Memoize after profiling.
- **Security**: Env schema validation (zod/envsafe). Do not log secrets/PII. Pin deps; avoid postinstall scripts; run audits with pragmatism.
- **Accessibility/i18n**: Semantic HTML, keyboard nav, focus mgmt. Minimal ARIA. Externalize strings for i18n readiness.

---

## Testing & Quality Gates
- **Unit/UI**: Jest + React Testing Library + `@testing-library/jest-dom`.
- **Backend**: Jest; HTTP integration via `supertest`. For Prisma, deterministic seeds; isolate DB per test where feasible.
- **Coverage**: ≥ **80%**. CI fails below threshold.
- **State Tests**: MUST cover loading, error, empty; conditional branches.
- **Mocks**: Absolute import mocks; realistic data; spy only to verify behavior.
- **Known Validated Patterns**: For specific projects, test null/error returns, component interactions, grid styles, prop propagation.
- **Static Checks**: ESLint (TS + hooks) with **zero** errors; Prettier formatting; `tsc --noEmit` must pass.
- **CI Stages**: `lint` → `typecheck` → `test` → `build`. PR blocked on any failure.

---

## Git & PR Workflow
- Small, topic-focused branches; descriptive names.
- Conventional commits preferred.
- PR template MUST include: **Goal**, **Changes**, **Screenshots**, **Risk/Impact**, **Testing**, **Checklist**.
- Require ≥1 approval; delete merged branches automatically.

---

## Communication Style (for Agents)
- Default to **concise, structured**, copy‑paste‑ready outputs.
- Prefer bullet lists, code blocks, and checklists over prose.
- Show absolute dates when timing matters (timezone: **Owner's timezone**).
- Avoid fluff. Be direct. Provide runnable commands and minimal just‑enough context.
- When unsure: propose best‑effort solution with assumptions stated at top.

---

## Logging & Tracking
- Summarize actions as compact, structured logs (JSON Lines) when possible.
- Record: timestamp, repo, task, files touched, commands run, test results.
- Respect privacy: redact tokens, emails, and PII.
- Integrate with tools below (§ Integration).

---

## Project Organization (Frontend Example)
```
src/
  app/ | pages/
  components/            # Each has: index.tsx, *.test.tsx
  features/<domain>/
  hooks/
  lib/                   # API client, utils, config
  styles/
  tests/                 # Shared test utils/mocks
```
Backends follow NestJS modular structure; Prisma schema + seed scripts per environment.

---

## Enforcement
- Pre-commit: format + lint staged files.
- CI must block merges on any rule violation.
- Agents must NOT introduce comments unless requested.

---

## Integration
- Claude/ChatGPT must load `agents/profiles/owner-context.md` if present.
- Example validation:
  ```bash
  ./agents/tools/validation/check-context.sh --profile=owner
  ```
- Example logging:
  ```bash
  ./agents/tools/logging/ai_log.sh context extract --source=chatgpt
  ```
