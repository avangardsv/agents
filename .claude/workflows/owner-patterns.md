# Owner — Preferred Workflows & Templates
Version: 2025-09-08

## Task → PR Pipeline
1. **Scope**: define Goal + Acceptance Criteria.
2. **Scaffold**: generate components/hooks with strict TS, absolute imports.
3. **Implement**: follow rules in `agents/rules/owner-preferences.md`.
4. **Tests**: write Jest+RTL tests covering loading/error/empty + branches.
5. **Static checks**: ESLint (no errors), Prettier, `tsc --noEmit`.
6. **Docs**: update README or feature docs if needed.
7. **PR**: small focused diff; fill PR template; attach screenshots.
8. **CI**: must pass `lint → typecheck → test → build`.

### PR Template (Drop‑in)
```
## Goal
## Changes
## Screenshots / Demos
## Risk / Impact
## Testing (cases + commands)
- [ ] Unit tests (loading/error/empty)
- [ ] Coverage ≥ 80%
## Checklist
- [ ] ESLint clean
- [ ] Prettier applied
- [ ] tsc --noEmit
- [ ] All components have displayName
```

## GitHub Actions (Starter)
```yaml
name: ci
on: [push, pull_request]
jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: '20' }
      - run: corepack enable
      - run: pnpm i --frozen-lockfile
      - run: pnpm lint
      - run: pnpm typecheck
      - run: pnpm test -- --coverage
      - run: pnpm build
```

## Frontend Structure Blueprint
```
src/
  app/ | pages/
  components/
  features/<domain>/
  hooks/
  lib/           # api client, utils, config
  styles/
  tests/
```

## Backend (NestJS + Prisma) Blueprint
- Modules per domain; DTOs with zod/class‑validator.
- Prisma schema with migrations; seed scripts per env.
- `prisma migrate reset` ONLY in local/dev; never shared envs.

### Seed Runbook (Dev)
```
pnpm prisma migrate reset --force
pnpm ts-node prisma/seed.ts  # deterministic fixtures
```

## Domain-Specific Patterns (When Applicable)
- [Add project-specific patterns here]
- Test domain-specific states; include accessibility considerations.

## Integration Hooks
- Validation:
  ```bash
  ./agents/tools/validation/check-context.sh --profile=owner
  ```
- Logging:
  ```bash
  ./agents/tools/logging/ai_log.sh context extract --source=chatgpt
  ```

## Follow‑Up Questions (for Agents)
After initial extraction, ask and then extend rules:
1. Missing code preferences to match style?
2. Communication patterns to better match expectations?
3. Workflow steps to automate/template?
4. Quality gates & validations to always apply?
5. Reusable project setup patterns across repos?
