# ai-sdlc

GEM's Claude Code plugin marketplace for AI-assisted software delivery.

## sdlc plugin

A Project Manager orchestrator that takes a project from idea to pull request. The PM delegates to five role subagents, keeps all state in `docs/project/` inside your repo, and asks you whenever a decision is needed.

| Component | Role |
|---|---|
| `/sdlc:pm` | Project Manager: plans, delegates, tracks status, asks you for decisions |
| `sdlc:ba` | Business Analyst: idea to backlog, feature to EARS requirements |
| `sdlc:architect` | Architect: requirements to design and task list |
| `sdlc:be` | Backend Developer: APIs, logic and data, one task at a time, test first |
| `sdlc:fe` | Frontend Developer: UI on a shared design system, checked in a browser at desktop and mobile width |
| `sdlc:qa` | QA: verifies each task against acceptance criteria |
| `sdlc:reviewer` | Reviewer: correctness, security and scope review |
| Stop hook | Keeps the PM working while `state: running` |
| Context7 MCP | Current library docs for Architect, BE, FE and QA |
| Playwright MCP | Headless browser checks for FE and QA |
| Trello MCP (official) | Optional live board: each role moves its own task cards |

### Install

```bash
claude plugin marketplace add pham-cao/ai-sdlc
claude plugin install sdlc@gem-ai-sdlc
```

Requirements: Node.js 18+ (both MCP servers run through `npx`). Install the browser for Playwright once:

```bash
npx playwright install chromium
```

Context7 works without a key at a lower rate limit. For higher limits, set `CONTEXT7_API_KEY` in your shell before starting Claude Code.

Trello (optional): the PM asks during discovery whether to use a Trello board. The first time, run `/mcp`, pick `trello` and sign in with OAuth. The board gets the lists `Backlog`, `To Do`, `Doing`, `QA`, `Review`, `Waiting for you`, `Blocked` and `Done`. Each task is a card: the Architect creates it, BE or FE moves it to `Doing` and `QA`, QA moves it to `Review` or back, and the Reviewer moves it to `Done` or back. The PM owns one card per feature and the `Blocked` list.

Installing `sdlc` also installs its UI skill dependencies, `frontend-design` (Anthropic, Apache 2.0) and `ui-ux-pro-max` (nextlevelbuilder, MIT). This marketplace lists them by reference to their upstream repos, pinned to a commit, so no code is copied. To move to a newer upstream version, update the `sha` in `.claude-plugin/marketplace.json`.

If you already installed either one from its own marketplace, you will have two copies enabled. Remove the older one to avoid duplicate skills, for example `claude plugin uninstall ui-ux-pro-max@ui-ux-pro-max-skill`.

Optional companions: `pr-review-toolkit` (the PM runs `/review-pr` before opening a PR when it is installed) and `superpowers`.

For local development: `claude --plugin-dir ./plugins/sdlc`

### Use

In your project repo:

```
/sdlc:pm A web app for employees to book meeting rooms
```

Run `/sdlc:pm` with no arguments to resume. You approve the backlog, each feature's requirements and design, and each pull request. Every other decision is asked as a short multiple choice question and logged in `docs/project/decisions.md`.

### Files the PM creates in your repo

```
docs/project/status.yaml       single source of truth for progress
docs/project/decisions.md      append-only decision log
docs/project/backlog.md        features in priority order
docs/project/design-system.md  colors, type, spacing and components every FE task follows
docs/project/specs/<feature>/  requirements.md, design.md, tasks.md
```

Add `.claude/sdlc-stop.local` to your `.gitignore`.

### Credits

Role prompts are written for GEM and draw on ideas from cc-sdd, GitHub Spec Kit, BMAD Method, Anthropic's feature-dev plugin and obra/superpowers.

### Test

```bash
bash plugins/sdlc/hooks/test-stop-guard.sh
claude plugin validate .
```
