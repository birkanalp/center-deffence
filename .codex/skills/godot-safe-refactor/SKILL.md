---
name: godot-safe-refactor
description: Perform safe, scoped refactoring in an existing Godot 2D game repository. Use when reducing duplication, improving naming, splitting large scripts, clarifying responsibilities, or improving maintainability without changing intended behavior.
---

# Godot Safe Refactor

## Purpose

Use this skill to improve maintainability in an existing Godot 2D project while preserving intended behavior, scene compatibility, and repository structure.

This skill is for production refactoring inside a real repository. It assumes the current codebase already has scene links, exported variables, signals, script attachments, and resource references that must remain compatible unless the task explicitly allows broader changes.

The goal is to make the smallest coherent refactor that improves clarity or maintainability without introducing architectural drift or behavior changes.

## When To Use

Use this skill when the task involves:

- reducing duplication
- improving naming
- splitting large scripts
- clarifying responsibilities
- improving maintainability without changing intended behavior

Use it when the repository already works, but a targeted cleanup is justified to make future edits safer or clearer.

## When NOT To Use

Do not use this skill when:

- the task is primarily feature work
- the task is primarily bug fixing with no refactor requirement
- the request implies a broad architectural redesign rather than a safe scoped cleanup
- the task is documentation-only
- the task is unrelated to an existing Godot repository

If refactoring is only a secondary part of a feature or bugfix, use the project orchestrator first and apply this skill only to the narrow refactor portion that is truly necessary.

## Core Behavior

- Inspect all directly related files first.
- Preserve external behavior unless explicitly asked otherwise.
- Keep scene, script, and resource references intact.
- Refactor incrementally.
- Avoid wide architectural rewrites unless required.
- Prefer compatibility with the current structure over a cleaner but riskier design.
- Treat serialized scene compatibility, exported variables, signal contracts, and shared names as stability-sensitive.

## Required Repository Inspection

Before planning or editing, inspect enough of the repository to answer all of the following:

1. What is the exact refactor target?
2. Which files, scenes, resources, and references directly depend on it?
3. Which behavior, contracts, and names must remain unchanged?
4. Which node paths, signals, exported variables, or scene links would break if the refactor is careless?
5. What is the smallest coherent refactor that solves the maintainability problem?

At minimum, inspect:

- the target script, scene, or resource being refactored
- files that reference it directly
- related scenes and attached scripts if the target participates in scene composition
- signals, exported variables, node paths, and serialized scene references affected by the target
- the nearest similar implementation or existing project pattern that should remain the compatibility baseline

When relevant, explicitly inspect:

- inherited scenes
- autoloads or managers that call into the target
- public/shared methods and signal names
- editor-assigned exported fields
- packed scene references
- animation or resource hooks bound to method names or node paths

## Refactor Workflow

1. Identify the exact refactor target.
   - Define the concrete maintainability problem.
   - Keep the target narrow and explicit.

2. Inspect dependencies and references.
   - Trace where the target is used and what relies on its current shape.
   - Confirm the external surface that must remain compatible.

3. Define behavior that must remain unchanged.
   - State which runtime behavior, scene wiring, references, and editor-visible configuration must not change.

4. Apply the minimal coherent refactor.
   - Make the smallest change set that resolves the maintainability problem.
   - Prefer local improvements over structural rewrites.

5. Update imports, references, names, and usages consistently.
   - Keep script references, shared names, and dependent code aligned with the refactor.
   - Avoid partial renames or mixed patterns.

6. Check for broken node paths, signals, exported variables, and scene links.
   - Verify compatibility for scene serialization, editor wiring, and dependent scripts.

## Safety / Guardrails

- Do not mix feature work into refactor work.
- Do not perform repo-wide cleanup unless explicitly requested.
- Do not rename public or shared elements casually.
- Do not break serialized scene data compatibility.
- Do not change behavior while claiming a pure refactor unless the user explicitly approved it.
- Do not replace current structure with a new architecture unless the task clearly requires it.
- Do not leave partially updated references, names, or editor-facing fields behind.

## Expected Outputs

For substantive tasks, structure work output as:

1. Refactor summary
   - What was refactored
   - What maintainability problem it addressed

2. Repository observations
   - Which files, scenes, references, and dependencies were inspected

3. Safety rationale
   - Why the refactor was safe
   - Which external behavior was intentionally preserved

4. Implementation result
   - Files changed
   - What was intentionally left untouched

5. Follow-up
   - Any optional cleanup suggestions that were not included to keep the refactor scoped

## Definition Of Done

The task is done only when all of the following are true:

- the exact refactor target was identified and scoped
- directly related files and dependencies were inspected first
- external behavior was preserved unless explicitly changed by request
- scene, script, and resource references remain valid
- imports, references, names, and usages were updated consistently where needed
- node paths, signals, exported variables, and scene links touched by the refactor remain compatible
- the output states what was refactored, why it was safe, what was left untouched, and any follow-up cleanup suggestions
