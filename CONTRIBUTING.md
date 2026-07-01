# Contributing

## Adding a Skill

### 1. Create the skill directory

```bash
mkdir -p skills/<skill-name>/evals
```

### 2. Write `SKILL.md`

Every skill needs a SKILL.md with frontmatter:

```markdown
---
name: your-skill-name
description: >
  One or two sentences describing what this skill does and when it triggers.
  Include example trigger phrases so Claude knows when to invoke it.
---

# Skill Title

...skill instructions...
```

### 3. Write `evals/evals.json`

Evals define prompts and assertions used to verify the skill triggers correctly:

```json
{
  "skill_name": "your-skill-name",
  "evals": [
    {
      "id": 0,
      "prompt": "A user message that should trigger this skill",
      "expected_output": "Description of what Claude should do",
      "files": [],
      "assertions": [
        {
          "name": "assertion-slug",
          "description": "What behavior to verify in the response"
        }
      ]
    }
  ]
}
```

Include at least 2–3 evals: a direct invocation, an indirect trigger (natural language), and an edge case.

### 4. Register in `marketplace.json`

Add an entry to the `skills` array:

```json
{
  "name": "your-skill-name",
  "version": "1.0.0",
  "description": "One-line description",
  "path": "skills/your-skill-name",
  "skill_file": "skills/your-skill-name/SKILL.md",
  "evals": "skills/your-skill-name/evals/evals.json",
  "tags": ["tag1", "tag2"],
  "trigger_phrases": ["phrase that triggers this skill"]
}
```

### 5. Update `README.md`

Add a row to the Skills table.

## Skill Quality Bar

- The `description` frontmatter must include enough trigger phrases for Claude to auto-invoke it
- At least 2 evals covering distinct trigger patterns
- No org-specific references (internal URLs, internal libraries, team names) — keep skills general-purpose
