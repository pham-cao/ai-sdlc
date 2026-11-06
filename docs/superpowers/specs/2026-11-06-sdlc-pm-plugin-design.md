# SDLC PM Plugin Design

## Goal

A Claude Code plugin where a Project Manager (PM) orchestrator takes a project from idea to pull requests. The PM plans the work, assigns it to role subagents, tracks status in repo files, and asks the user whenever a decision is needed.

## Decisions

| Topic | Decision |
|---|---|
| Scope | Whole project from idea. The PM first builds a feature backlog, then runs each feature through design, build and review. |
| State | Plain files in the target repo under `docs/project/`. Jira sync comes later. |
| Decisions | The PM always asks the user. Questions are batched per phase (at most 4 per round, each with a recommended option). Failed tasks retry up to 3 times before the PM asks. |
| Orchestration | The PM runs in the main session (`/sdlc:pm`). Roles run as subagents with fresh context and communicate only through files. |
| Role prompts | Written for GEM, drawing on ideas from cc-sdd, GitHub Spec Kit, BMAD Method, feature-dev and superpowers. No text copied, so no NOTICE is required. |

## Components

| Path | Purpose |
|---|---|
| `skills/pm/SKILL.md` | The PM loop: read status, pick next work, dispatch, update status, ask the user. |
| `skills/pm/templates/` | Starting files for `status.yaml` and `decisions.md`. |
| `agents/ba.md` | Idea to `backlog.md`; feature to `requirements.md` (EARS acceptance criteria). |
| `agents/architect.md` | `requirements.md` to `design.md` and `tasks.md`. |
| `agents/be.md` | One backend task, test first. |
| `agents/fe.md` | One frontend task on `design-system.md`, using the frontend-design and ui-ux-pro-max skills, checked with Playwright at 1440px and 390px. |
| `agents/qa.md` | Verifies one task against acceptance criteria. |
| `agents/reviewer.md` | Reviews one task's diff. |
| `.mcp.json` | Context7 (Architect, BE, FE, QA), Playwright, headless and isolated (FE, QA), and the official Trello server (all roles except BA move their own task cards; status.yaml stays the PM's source of truth). |
| `hooks/stop-guard.sh` | Stop hook that keeps the PM working while `state: running`. |

## Data layout in the target repo

```
docs/project/status.yaml        single source of truth
docs/project/decisions.md       append-only decision log
docs/project/backlog.md         features in priority order
docs/project/design-system.md   shared UI tokens and rules, owned by FE
docs/project/specs/<feature>/requirements.md, design.md, tasks.md
```

## Flow

1. Discovery: BA turns the idea into `backlog.md` and open questions. PM asks the user, then the user approves the backlog.
2. Per feature, in backlog order:
   1. BA writes `requirements.md`. PM asks open questions, user approves.
   2. Architect writes `design.md` and `tasks.md`. PM asks open questions, user approves.
   3. For each task in dependency order: its owner (BE or FE), then QA, then Reviewer. A failure sends the task back to the owner with the findings. After 3 failed attempts the task is `blocked` and the PM asks the user.
   4. PM opens a pull request with a summary and waits for the user.

## Stop guard

The hook does nothing unless `docs/project/status.yaml` exists with `state: running`. It blocks a stop only when `status.yaml` has changed since the last block, so a PM that stops without making progress is allowed to stop. This prevents endless loops.

## Out of scope for now

Jira and Confluence sync (Trello is the interim board), headless CI runs, parallel task execution.
