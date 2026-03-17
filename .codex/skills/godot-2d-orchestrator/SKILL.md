---
name: godot-2d-orchestrator
description: Main orchestration skill for an existing Godot 2D game repository. Use when Codex must inspect the request, inspect the repository before acting, classify the task, choose the right specialist behavior, create a short execution plan, and keep implementation safe, scoped, and consistent with the current codebase.
---

# Godot 2D Orchestrator

## Purpose

Use this skill as the default coordinator for substantive work in an existing Godot 2D game project.

Its job is to understand the request, inspect the repository before making decisions, classify the work, route to the correct specialist behavior, and keep the implementation small, coherent, and repository-grounded.

This skill is responsible for making sure Codex does not improvise architecture, skip repository inspection, or break working scene and resource contracts.

## When To Use

Use this skill when the request involves implementation, debugging, UI, scene work, asset integration, refactoring, or repository-grounded documentation in a Godot 2D project.

Use it when Codex needs to:

- inspect the user request carefully before acting
- inspect the repository structure before making changes
- decide whether the task is mainly asset integration, gameplay engineering, UI / scene building, QA / debugging, safe refactor, or project docs
- create a short execution plan
- choose the correct specialized skill behavior
- keep the work scoped and internally consistent

## When NOT To Use

Do not use this skill when:

- the task is unrelated to a Godot repository
- the task is purely conversational or conceptual and no repository-grounded action is needed
- the task is strictly documentation-only and already clearly scoped to a docs-specific workflow
- the task is a narrowly scoped specialist request where a dedicated skill can be used directly without orchestration

If there is any doubt, use this orchestrator first and route from here.

## Core Behavior

- Never jump into coding immediately.
- Never assume project structure, scene composition, node paths, signals, autoloads, resources, or naming patterns.
- Inspect relevant scenes, scripts, nodes, autoloads, resources, and naming conventions before planning changes.
- Prefer root-cause understanding before editing files.
- Think in terms of scene tree, node ownership, signals, resources, gameplay flow, and editor/runtime impact.
- Prefer modifying existing implementation over inventing parallel systems.
- Preserve working behavior unless the request explicitly changes behavior.

## Required Repository Inspection

Before planning or editing, inspect enough of the repository to answer all of the following:

1. What kind of task is this?
2. Which scenes, scripts, resources, and docs are relevant?
3. Which existing implementation already does something similar?
4. What repository conventions must be preserved?
5. What contracts could break if this area changes?

At minimum, inspect:

- `AGENTS.md` and relevant project docs in `docs/` when present
- `project.godot` for autoloads, input mappings, main scene, and project settings relevant to the task
- the nearest relevant scenes and attached scripts
- related resources such as themes, custom resources, animation resources, tilesets, and shared assets
- naming and placement patterns already used in the affected area

Explicitly check whether the project uses any of the following when they are relevant to the task:

- Godot 4 node and script patterns
- custom managers
- signals and signal-based flow
- scene inheritance
- autoload singletons
- custom resources
- animation trees or animation players
- tilemaps and tilesets
- reusable scene composition

## Task Classification

Classify the task into the primary mode before implementing:

- asset integration
- gameplay engineering
- UI / scene building
- QA / debugging
- safe refactor
- project docs

Pick one primary mode, and note any secondary concerns only if they materially affect implementation.

## Specialist Routing Guidance

After classification, adopt the matching specialist mindset:

- asset integration: inspect similar assets first, classify the asset correctly, and preserve visual-to-gameplay separation
- gameplay engineering: inspect related systems first, reuse current managers, signals, groups, state patterns, and scene contracts
- UI / scene building: inspect similar UI scenes first, reuse theme and layout conventions, and keep UI logic separate from gameplay systems
- QA / debugging: reproduce or inspect evidence first, search the repository, fix root cause, and validate the affected flow
- safe refactor: confirm the refactor is necessary, prefer the smallest local cleanup, and preserve behavior and contracts
- project docs: inspect repository state first and document only what exists or what is clearly labeled as inference

## Implementation Workflow

1. Classify task.
   - Determine the main task type from the request and repository evidence.
   - Identify unchanged behavior that must be preserved.

2. Inspect relevant files.
   - Read the nearest relevant scenes, scripts, resources, docs, and project configuration before planning.
   - Check related nodes, exported variables, signals, resource references, and input mappings.

3. Identify patterns.
   - Determine naming conventions, scene structure, node ownership, reusable scene composition, inheritance, managers, and signal flow already in use.
   - Identify whether the project relies on autoloads, custom resources, tilemaps, animation systems, or shared helpers in the affected area.

4. Choose the smallest safe implementation path.
   - Prefer changing the existing implementation over adding a new system.
   - Avoid broad rewrites, speculative cleanup, or duplicate architecture.

5. Apply change.
   - Edit only the files required for the task.
   - Keep changes coherent with current structure and conventions.

6. Verify ripple effects.
   - Check for broken scene references, resource paths, exported variables, signal connections, and input mappings.
   - Check node paths, inheritance assumptions, shared helpers, and runtime/editor impact in the touched flow.

7. Summarize changed files, risks, and follow-up work.
   - Report what changed concretely.
   - Report what was verified.
   - Report residual risks or follow-up work if validation could not fully cover them.

## Safety / Guardrails

- Do not invent new structure when the repository already has a pattern.
- Do not create a parallel system when the project already has a working one.
- Do not rename, move, or reorganize files unless the task clearly requires it.
- Do not break scene references, resource paths, exported variables, signal connections, or input mappings.
- Do not change behavior outside the requested scope.
- Do not perform broad refactors while implementing a feature or fix.
- Do not guess about node ownership, scene inheritance, or resource usage.
- Prefer targeted edits with clear ripple-effect awareness.

## Expected Outputs

For substantive tasks, structure work output as:

1. Task understanding
   - What the user wants
   - What behavior should remain unchanged

2. Repository observations
   - Relevant scenes, scripts, resources, autoloads, and conventions inspected

3. Execution plan
   - Short ordered plan with the smallest safe path

4. Implementation result
   - Concrete files changed
   - High-level summary of what changed

5. Verification
   - What references, signals, resources, node paths, or flows were checked

6. Risks / follow-up
   - Remaining risks, assumptions, or follow-up work if any

## Definition Of Done

The task is done only when all of the following are true:

- relevant files were inspected before changes were planned or applied
- the solution follows existing repository structure and naming patterns
- no invented parallel structure was introduced
- no unsafe broad changes were made
- all changed references were kept consistent
- scene references, resource paths, exported variables, signal connections, and input mappings touched by the change remain valid
- the output includes a concrete summary of what changed
