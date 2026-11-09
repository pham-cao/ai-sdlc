# ai-sdlc

GEM's Claude Code plugin marketplace for AI-assisted software delivery.

## sdlc plugin

A Project Manager orchestrator that takes a project from idea to pull request. The PM delegates to role subagents and QA specialists, keeps all state in `docs/project/` inside your repo, and asks you whenever a decision is needed.

| Component | Role |
|---|---|
| `/sdlc:pm` | Project Manager: plans, delegates, tracks status, asks you for decisions |
| `sdlc:ba` | Business Analyst: idea to backlog, feature to EARS requirements |
| `sdlc:ux` | UI/UX Designer: user flows, design system and a clickable HTML prototype you review before any code is written |
| `sdlc:architect` | Architect: requirements to design and task list |
| `sdlc:be` | Backend Developer: APIs, logic and data, one task at a time, test first |
| `sdlc:fe` | Frontend Developer: UI on a shared design system, checked in a browser at desktop and mobile width |
| `sdlc:qa` | QA (ISTQB aligned): test plan, test cases and traceability per feature; executes each task with evidence; logs and retests bugs; writes the test summary report |
| `sdlc:qa-test-planner` | QA specialist: explores a running app and writes e2e scenarios |
| `sdlc:qa-test-generator` | QA specialist: turns scenarios into Playwright tests, performed live first |
| `sdlc:qa-test-healer` | QA specialist: root causes and fixes failing or flaky e2e tests |
| `sdlc:qa-api-tester` | QA specialist: API contract suites (Playwright request, Supertest, REST Assured) |
| `sdlc:qa-selenium` | QA specialist: Selenium 4, JUnit 5 and POM tests for Java projects |
| `sdlc:qa-test-refactor` | QA specialist: removes duplication and brittleness without changing coverage |
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

Installing `sdlc` also installs its design skill dependencies: `frontend-design` (Anthropic, Apache 2.0), `ui-ux-pro-max` (nextlevelbuilder, MIT), `prototyping-testing`, `interaction-design`, `ux-strategy` and `visual-critique` from Owl-Listener/designer-skills (MIT), and `test-automation-skills-agents` from fugazi (MIT; ISTQB artifacts, Playwright e2e, API, accessibility and failure investigation skills for QA). This marketplace lists them by reference to their upstream repos, pinned to a commit, so no code is copied. To move to a newer upstream version, update the `sha` in `.claude-plugin/marketplace.json`.

If you already installed either one from its own marketplace, you will have two copies enabled. Remove the older one to avoid duplicate skills, for example `claude plugin uninstall ui-ux-pro-max@ui-ux-pro-max-skill`.

Optional companions: `pr-review-toolkit` (the PM runs `/review-pr` before opening a PR when it is installed) and `superpowers`.

For local development: `claude --plugin-dir ./plugins/sdlc`

### Use

In your project repo:

```
/sdlc:pm A web app for employees to book meeting rooms
```

Run `/sdlc:pm` with no arguments to resume. You approve the backlog, each feature's requirements, its UX prototype (open `docs/project/specs/<feature>/ux/index.html` in a browser; ask for changes as often as you like), its technical design, and each pull request. Backend and frontend work starts only after the UX is approved. Every other decision is asked as a short multiple choice question and logged in `docs/project/decisions.md`.

### Files the PM creates in your repo

```
docs/project/status.yaml       single source of truth for progress
docs/project/decisions.md      append-only decision log
docs/project/backlog.md        features in priority order
docs/project/design-system.md  design system rules, created by the UX Designer
docs/project/design-system.css same tokens as CSS variables, used by the prototype and ported by FE
docs/project/specs/<feature>/  requirements.md, ux/ (flows.md, screens/, screenshots/), design.md, tasks.md,
                               qa/ (test-plan.md, test-cases.csv, traceability-matrix.csv,
                               test-execution-log.csv, evidence/, test-summary-report.md)
docs/project/bugs/             bug-log.csv and one BUG-NNN.md report per bug
```

Add `.claude/sdlc-stop.local` to your `.gitignore`.

### Credits

Role prompts are written for GEM and draw on ideas from cc-sdd, GitHub Spec Kit, BMAD Method, Anthropic's feature-dev plugin and obra/superpowers. The six `qa-*` specialist agents are adapted from fugazi/test-automation-skills-agents under the MIT License; see `plugins/sdlc/NOTICE.md`.

### Test

```bash
bash plugins/sdlc/hooks/test-stop-guard.sh
claude plugin validate .
```
