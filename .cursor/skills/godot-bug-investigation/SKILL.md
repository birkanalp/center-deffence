---
name: godot-bug-investigation
description: >-
  Diagnoses and fixes bugs in Godot 2D projects. Use when investigating runtime
  errors, broken paths, signal issues, collisions, animations, scene loading,
  or gameplay regressions. Strictly 2D workflows only.
---

# Godot Bug Investigation

## Rules

- **Strictly 2D.** Do not introduce 3D changes.
- **Root cause.** Fix the cause, not superficial symptoms.
- **Inspect first.** Examine relevant scenes and scripts before editing.
- **Minimal fixes.** Keep changes small and low-risk.
- **Separate facts from guesses.** Distinguish confirmed findings from assumptions.

## Bug Categories

- runtime error
- broken node path
- missing signal connection
- collision not working
- animation not playing
- scene not loading
- null reference
- wrong state transition
- broken interaction

## Workflow

1. Identify symptom
2. Inspect related files
3. Find root cause
4. Propose smallest safe fix
5. Implement fix
6. Validate behavior

## Godot MCP

When available:

- run_project
- Inspect debug output
- Verify fix after applying changes

## Output Format

Return:

1. Problem summary
2. Evidence
3. Root cause
4. Fix
5. Files changed
6. Validation result
7. Assumptions
