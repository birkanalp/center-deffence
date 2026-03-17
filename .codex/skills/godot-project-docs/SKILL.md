---
name: godot-project-docs
description: Create and maintain practical documentation for an existing Godot 2D game repository. Use when writing architecture summaries, gameplay system docs, scene hierarchy notes, autoload documentation, onboarding docs, feature implementation notes, or debugging runbooks based on the actual repository state.
---

# Godot Project Docs

## Purpose

Use this skill to create and maintain practical documentation for an existing Godot 2D project.

This skill is for production documentation inside a real repository. It assumes the codebase already contains scenes, scripts, resources, autoloads, and conventions that must be inspected before anything is documented.

The goal is to produce concise, useful documentation that helps future development, debugging, onboarding, and maintenance without inventing systems or describing assumptions as facts.

## When To Use

Use this skill when the task involves creating or updating documentation such as:

- architecture summaries
- gameplay system documentation
- scene hierarchy notes
- autoload or singleton documentation
- onboarding docs
- feature implementation notes
- debugging runbooks

Use it when future readers need to understand:

- how the project is structured
- how gameplay or UI flows work
- where important systems live
- which files and resources are involved in a feature
- what assumptions, gaps, or known limitations exist

## When NOT To Use

Do not use this skill when:

- the task is primarily implementation rather than documentation
- the request is broad design speculation rather than repository-grounded docs
- the task is unrelated to an existing Godot repository
- the request is for tutorial-style educational material rather than project-specific docs

If docs are only one small part of a larger implementation task, use the project orchestrator first and route here only when documentation is the main deliverable.

## Core Behavior

- Inspect the actual repository before documenting.
- Document what exists, not what should exist in theory.
- Keep documentation concise, practical, and useful for future development.
- Explain architecture, flows, dependencies, and conventions clearly.
- Call out incomplete or unclear areas explicitly instead of guessing.
- Prefer concrete file and folder references over vague descriptions.
- Write for maintainers and future coding agents, not for tutorial readers.

## Required Repository Inspection

Before drafting docs, inspect enough of the repository to answer all of the following:

1. Which scenes, scripts, resources, autoloads, and folders are relevant to the requested documentation?
2. What system boundaries actually exist in the codebase?
3. What flows, dependencies, or ownership relationships can be confirmed directly?
4. Which conventions are visible in folder structure, naming, scene composition, or configuration?
5. Which areas are incomplete, ambiguous, or only partially implemented?

At minimum, inspect:

- the relevant folders and top-level project structure
- `project.godot` when project settings, autoloads, or input mappings matter
- the primary scenes and scripts involved in the documented topic
- shared resources, themes, custom resources, or helper scripts if they materially affect the documented flow
- existing docs in `docs/` so new documentation aligns with current terminology and avoids duplication

When relevant, explicitly inspect:

- scene inheritance
- autoload singletons and managers
- key signal connections
- gameplay or UI entry points
- reusable scene composition
- save/progression hooks
- debugging hooks or validation paths

## Documentation Workflow

1. Inspect relevant scenes, scripts, and project structure.
   - Read the repository before writing.
   - Inspect the nearest files that actually define the system being documented.

2. Identify actual system boundaries and conventions.
   - Determine what belongs to the system, what dependencies it has, and what project conventions it follows.
   - Distinguish direct evidence from inference.

3. Document core flows, dependencies, and important files.
   - Explain how the system works at a practical maintenance level.
   - Name the concrete scenes, scripts, folders, resources, and autoloads involved.

4. Include practical notes for future edits.
   - Call out fragile areas, common extension points, important signals, ownership boundaries, or expected validation steps.
   - Make the doc useful for future implementation work, not just description.

5. Avoid bloated or tutorial-style writing.
   - Keep sections tight.
   - Prefer operational clarity over generic explanation.

## Safety / Guardrails

- Do not invent architecture.
- Do not write vague generic docs.
- Do not describe unverified behavior as fact.
- Do not copy broad engine theory into project docs.
- Do not hide ambiguity; mark it explicitly.
- Do not document aspirational systems as if they already exist.
- Do not bloat docs with redundant explanations when concrete repository references are more useful.

## Expected Outputs

For substantive tasks, produce:

- practical markdown docs
- architecture or flow summaries
- references to concrete project folders and files
- explicit uncertainty when something is ambiguous

The documentation should typically include:

1. Scope
   - What subsystem, flow, or area the doc covers

2. Repository grounding
   - Which scenes, scripts, resources, or folders were inspected

3. System summary
   - The actual structure, dependencies, and flow observed in the repository

4. Practical notes
   - Important conventions, extension points, maintenance notes, or debugging guidance

5. Uncertainties
   - Anything ambiguous, incomplete, or inferred rather than directly verified

## Definition Of Done

The task is done only when all of the following are true:

- the relevant repository areas were inspected before writing
- the documentation reflects actual repository structure and behavior
- architecture, flow, dependencies, and conventions are explained clearly
- practical file and folder references are included where useful
- incomplete or ambiguous areas are called out explicitly
- the result is concise, practical, and not generic or tutorial-like
