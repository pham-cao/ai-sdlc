# ai-sdlc

GEM's Claude Code plugin marketplace for AI-assisted software delivery.

## sdlc plugin

A Project Manager orchestrator that takes a project from idea to pull request. The PM delegates to five role subagents, keeps all state in `docs/project/` inside your repo, and asks you whenever a decision is needed.

| Component | Role |
|---|---|
| `/sdlc:pm` | Project Manager: plans, delegates, tracks status, asks you for decisions |
| `sdlc:ba` | Business Analyst: idea to backlog, feature to EARS requirements |
| `sdlc:architect` | Architect: requirements to design and task list |
| `sdlc:dev` | Developer: one task at a time, test first |
| `sdlc:qa` | QA: verifies each task against acceptance criteria |
| `sdlc:reviewer` | Reviewer: correctness, security and scope review |
| Stop hook | Keeps the PM working while `state: running` |
| Context7 MCP | Current library docs for Architect, Dev and QA |
| Playwright MCP | Headless browser checks for Dev and QA |

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
