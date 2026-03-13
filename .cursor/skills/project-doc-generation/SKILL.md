---
name: project-doc-generation
description: >-
  Generates engineering documentation from Godot 2D repository state. Use when
  creating or refreshing docs/project-overview, architecture, roadmap, or
  ai-rules. Strictly based on actual repository content.
---

# Project Doc Generation

## Rules

- **Do not invent.** Document only what exists in the repository.
- **Base on reality.** Base everything on actual repository content.
- **Structured Markdown.** Use clear, structured Markdown.
- **AI-friendly.** Keep documentation useful for future AI-assisted development.

## Common Target Files

- docs/project-overview.md
- docs/architecture.md
- docs/roadmap.md
- docs/ai-rules.md

## Workflow

1. Inspect repository structure
2. Inspect project.godot
3. Inspect scenes, scripts, assets
4. Identify core systems and architecture
5. Identify completed, partial, and missing systems
6. Generate docs

## Documentation Guidelines

- Explain what exists now
- Mark assumptions clearly
- Separate facts from future suggestions
- Use practical, engineering-focused wording

## Output Format

Return:

1. Repository summary
2. Documentation plan
3. Files changed
4. Assumptions
5. Follow-up documentation suggestions
