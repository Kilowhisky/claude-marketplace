---
name: ai-project-bootstrap
description: >
  Bring any existing software project under AI-first development control by creating a complete
  documentation suite: CONTEXT.md, ARCHITECTURE.md, DECISIONS.md, CHANGELOG.md, specs/,
  research/, README.md, CICD.md, DEBUGGING.md, runbooks/, and CLAUDE.md. The process takes 
  ~25 minutes and gives Claude enough persistent context to work effectively across sessions 
  without being re-briefed.

  Use this skill whenever the user says things like "bring this project under AI control",
  "create CLAUDE.md for this repo", "set up AI documentation", "help Claude understand this
  project", "bootstrap docs for AI", "document this for AI-assisted development", or "I want
  you to investigate this project and build docs". Even if they don't use those exact words —
  if the intent is to give an AI assistant persistent project context, this skill applies.
---

# AI Project Bootstrap

The goal: give Claude (or any AI assistant) enough persistent context about a project that it can work effectively across sessions without being re-briefed every time.

## Process Overview

Four steps, total ~25 minutes:

| Step | What | Time |
|------|------|------|
| 1 | Interview the human — capture what code can't tell you | ~10 min |
| 2 | Deep-read the codebase (parallel with interview using subagents/workflows) | ~2 min |
| 3 | Fetch external sources (Confluence, Jira, etc.) | ~1 min |
| 4 | Write all docs in dependency order | ~10 min |

---

## Step 1 — Interview the Human

Run `/grill-me` to conduct a structured interview. Explore the codebase in parallel while waiting for answers. Ask one question at a time. Skip questions the code already answers.

**Minimum viable interview — cover all topics:**

1. **Business purpose** — What problem does this solve?
2. **Audience** — Who uses it and how? (Workflow, not just persona)
3. **Status** — Prototype, active experiment, or committed feature?
4. **Open questions** — What decisions are still unresolved?
5. **Primary AI task** — What will Claude spend most time doing in this repo?
6. **External sources** — Any Confluence pages, Jira epics, or research docs to pull in?
7. **Changelog** — Seed from git history, or start fresh?
8. **Related Content** — Any related repos, libraries, or services that should be referenced?
9. **Known Issues** — Any recurring bugs, performance issues, or technical debt that the code doesn't make obvious?


These answers directly shape `CONTEXT.md` and `DECISIONS.md`. Don't skip them.

---

## Step 2 — Deep-Read the Codebase

Spawn an `Explore` subagent (or explore thoroughly yourself) covering:

- Full directory structure
- Tech stack and key dependencies
- What the application actually does — read source files, not just config
- How to build, run, and test it
- Any existing documentation
- Recent git activity

Use a subagent to keep the main context window clean.

---

## Step 3 — Fetch External Sources

If the project has Confluence pages, Jira epics, or other external docs:

- Use `mcp__claude_ai_Atlassian__getConfluencePage` with the `pageId` from the URL
- The `cloudId` (a UUID) is visible in the login redirect URL if you hit the page unauthenticated
- If the Atlassian MCP isn't loading after re-auth, restart the Claude Code session — it picks up new credentials on fresh start

If no external sources exist, skip this step.

---

## Step 4 — Write the Docs

Write in this exact order — later docs reference earlier ones:

| Order | File | Derived from |
|-------|------|-------------|
| 1 | `docs/CONTEXT.md` | Interview + external sources |
| 2 | `docs/ARCHITECTURE.md` | Codebase exploration |
| 3 | `docs/DECISIONS.md` | Code patterns + interview + external sources |
| 4 | `docs/CHANGELOG.md` | Git history or fresh v0.1.0 |
| 5 | `docs/specs/README.md` | Convention scaffold only |
| 6 | `docs/research/README.md` | Convention scaffold + list of past investigations/research |
| 7 | `docs/runbooks/README.md` | Convention scaffold + list of runbooks (optional) |
| 8 | `docs/CICD.md` | Build/test/deploy commands + environment variables (optional) |
| 9 | `docs/DEBUGGING.md` | Debugging strategies, known issues, and runbooks (optional) |
| 10 | `README.md` | Everything above |
| 11 | `CLAUDE.md` | Everything above — this is the AI's entrypoint |

Once you have all inputs from steps 1–3, docs 1–9 can be written in a parallel burst. Write `CLAUDE.md` last since it references everything else.

---

## What Each File Contains

### `docs/CONTEXT.md` — The *Why*

- One-paragraph summary of what it does
- Current status (experiment, MVP, product)
- Who uses it and how (workflow, not just persona)
- Known issues / active bugs
- SME contacts
- Links to external sources (Confluence, Jira epics, etc.)

### `docs/ARCHITECTURE.md` — The *How*

- MERMAID system diagram showing data flow and all components
- Directory structure with annotations
- Tech stack table
- Data flow detail per major path
- Database schema (if applicable)
- External service dependencies
- Deployment stages

### `docs/DECISIONS.md` — ADRs

One entry per significant architectural or design decision:

- **Decision**: one sentence
- **Rationale**: why this, not alternatives
- **Consequence**: what you live with as a result
- **What not to do**: explicitly name the thing this decision rules out

End with an **Open Questions** section for decisions not yet made.

ADR candidates: anything that looks surprising in the code, any technology choice, any non-obvious constraint. When in doubt, write it down — the "what not to do" field is often the most valuable.

### `docs/CHANGELOG.md`

If starting fresh: a single `v0.1.0` entry describing the current delivered state. Note known state at the snapshot point. Use [Keep a Changelog](https://keepachangelog.com) format.

If seeding from git history: extract meaningful entries going back to the start, grouped by version or date.

### `docs/specs/`

Convention + template to start. Add a spec before any non-trivial new feature. Format: what it does, inputs, behavior rules, acceptance criteria, out of scope.

### `docs/research/`

Convention + template + a list of any past research to formalize. Each investigation: question, context, what we tried, findings, conclusion. Name files `YYYY-MM-topic.md`.

Seed immediately with any research the external data surfaces — survey findings, past technical decisions, debugging postmortems.

### `docs/runbooks/` *(optional — skip for experiments/labs)*

Convention + template to start. Add a runbook for any recurring or one-off operational task. Format: what it does, when to run it, why to run it, how to run it, expected outcome, troubleshooting.

### `docs/CICD.md`

- Summary of the CI/CD pipeline and what triggers it
- Build/test/deploy commands (exact commands, not descriptions)
- How to run CI checks locally before pushing
- Key environment variables and where secrets are stored
- Deployment stages and how to promote between them
- External CI/CD service dependencies (GitHub Actions, CircleCI, Jenkins, etc.)
- How to debug a failed pipeline run (where to find logs, common failure modes)
- Links to runbooks for common CI/CD tasks

For simple projects where the pipeline is a few lines, this content can go in `ARCHITECTURE.md` instead.

### `docs/DEBUGGING.md`

- Where logs live and the commands to tail or query them (exact commands)
- How to reproduce common issues locally (environment setup, seed data, flags)
- Known recurring bugs: symptoms, root cause, workaround or fix status
- How to attach a debugger or enable verbose logging per tier (backend, Lambda, frontend, etc.)
- Links to relevant runbooks for issue resolution

### `README.md`

- One-paragraph what/why
- Link table to all docs
- Quick start: build, run, test, deploy
- Architecture in 10 lines
- Key environment variables
- Link to CLAUDE.md

### `CLAUDE.md` — The AI's Working Instructions

This is the most important file. It's the AI's entrypoint for every future session.

- **Read-this-first list** — which docs to load per task type
- **Repo structure table**
- **Build/test commands**
- **Key conventions** per tier (backend, frontend, infra, AI)
- **Before/during/after checklist** for making changes
- **What not to do** — explicitly name the footguns
- **Deployment commands** with stage flags

---

## Finishing Up

Batch all new files into one commit:

```
docs: bootstrap AI-first documentation suite
```

Pull before committing if the branch may be behind remote.
