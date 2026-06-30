# Claude Marketplace

A personal collection of Claude Code skills — reusable AI-first development workflows.

## Skills

| Skill                                                         | Description                                                                                                                                               |
|---------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| [ai-project-bootstrap](skills/ai-project-bootstrap/SKILL.md) | Bring any project under AI-first development control by generating a complete doc suite (CONTEXT.md, ARCHITECTURE.md, DECISIONS.md, CLAUDE.md, and more) |

## Usage

Skills in this repo can be installed into `~/.claude/skills/` and invoked via the `Skill` tool in Claude Code.

To install a skill locally:

```bash
cp -r skills/<skill-name> ~/.claude/skills/
```

## Structure

```text
skills/
  <skill-name>/
    SKILL.md   # skill definition and instructions
```
