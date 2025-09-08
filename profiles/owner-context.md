# Owner — Agent Profile & Context
Version: 2025-09-08

## Identity
- **Name**: [To be customized per user]
- **Location/Timezone**: [To be customized per user]
- **Role**: [To be customized per user]

## Interaction Expectations
- Deliver **concise**, structured answers with runnable snippets.
- Prefer modern TypeScript/React/Svelte patterns, Tailwind UI.
- Provide PR‑ready artifacts: checklists, commands, and tests.
- Avoid purple prose; keep tone professional and direct.

## Machine‑Readable Preferences
```json
{
  "owner": {
    "name": "[CUSTOMIZE]",
    "location": "[CUSTOMIZE]"
  },
  "timezone": "[CUSTOMIZE]",
  "stack": {
    "frontend": [
      "React",
      "Next.js",
      "SvelteKit"
    ],
    "language": "TypeScript",
    "styling": [
      "Tailwind",
      "shadcn/ui"
    ],
    "backend": [
      "Node",
      "NestJS",
      "Prisma",
      "PostgreSQL"
    ],
    "testing": {
      "frontend": "Jest + React Testing Library + jest-dom",
      "backend": "Jest + supertest",
      "coverage": ">=80%"
    }
  },
  "rules": {
    "typescriptStrict": true,
    "esModulesOnly": true,
    "absoluteImportsBase": "@/",
    "reactFunctionalOnly": true,
    "requireDisplayNameOnComponents": true,
    "noCommentsByDefault": true,
    "lintNoErrors": true,
    "formatWithPrettier": true
  },
  "patterns": {
    "test": {
      "verifyStates": [
        "loading",
        "error",
        "empty"
      ],
      "useAbsoluteMocks": true,
      "preferGetBy": [
        "getByTestId",
        "getByText"
      ]
    },
    "api": {
      "singleSourceModule": "lib/api"
    }
  },
  "ci": [
    "lint",
    "typecheck",
    "test",
    "build"
  ],
  "git": {
    "smallPRs": true,
    "conventionalCommits": true
  }
}
```

## Known Projects & Nuances
- **[Project Name]**: [Add specific project patterns and requirements]
- **Design systems**: component libraries via Tailwind/shadcn; Storybook when needed.

## Communication Nuances (for Agents)
- If a task is ambiguous, state assumptions and proceed; don't block on questions.
- Provide absolute dates; prefer tables/lists for comparisons.
- Default language: English (switch on request).

## Logging/Tracking Preferences
- Structured logs (JSONL) with task, repo, files, results.
- Daily summaries optional; weekly rollups for milestones.

