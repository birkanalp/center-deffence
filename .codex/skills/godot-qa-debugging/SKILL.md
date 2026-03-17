---
name: godot-qa-debugging
description: Debug and investigate bugs in an existing Godot 2D game repository. Use when diagnosing runtime bugs, scene issues, broken signals, invalid node paths, collisions, animation or state mismatches, spawning issues, input bugs, UI behavior problems, or performance regressions caused by code structure.
---

# Godot QA Debugging

## Purpose

Use this skill to investigate, diagnose, and fix bugs in an existing Godot 2D project with a root-cause-first workflow.

This skill is for production debugging inside a real repository. It assumes bugs may come from scene setup, script logic, resource linkage, signal wiring, animation timing, physics configuration, or editor-side configuration, not just code.

The goal is to reproduce the issue conceptually from the actual code path, identify the most likely root cause from repository evidence, and implement the narrowest safe fix without speculative patching or unrelated cleanup.

## When To Use

Use this skill when the task involves:

- runtime bugs
- scene issues
- broken signal connections
- invalid node paths
- collision problems
- animation or state mismatches
- spawning issues
- input handling issues
- UI behavior bugs
- performance regressions caused by code structure

Use it when the investigation may involve:

- scene configuration
- exported variables and editor-assigned references
- autoloads and managers
- signals and connection paths
- physics layers and masks
- animation events and timing
- resource linkage or missing assets
- runtime flow across multiple scripts or scenes

## When NOT To Use

Do not use this skill when:

- the request is primarily new feature implementation rather than debugging
- the task is documentation-only
- the request is broad refactoring without a concrete bug or QA problem
- the task is unrelated to an existing Godot repository

If debugging is only one part of a larger task, use the project orchestrator first and route here when investigation and validation are the main concern.

## Core Behavior

- Restate the issue in technical terms before changing anything.
- Reproduce the issue conceptually from the actual code path.
- Inspect the relevant scenes, scripts, signals, exported variables, autoloads, and resources before proposing a fix.
- Trace root cause before changing code.
- Avoid speculative “maybe this fixes it” patches.
- Identify whether the issue is editor setup, scene config, signal wiring, physics layers or masks, animation timing, code logic, or resource linkage.
- Consider both scene configuration and script behavior together.
- Prefer the narrowest safe fix that resolves the underlying issue.

## Required Repository Inspection

Before planning a fix, inspect enough of the repository to answer all of the following:

1. What is the exact failing behavior?
2. What is the real execution path or configuration path that leads to the bug?
3. Which scenes, scripts, resources, autoloads, or signals are involved?
4. Is the likely issue in code, editor wiring, scene config, resource linkage, physics setup, animation timing, or a combination?
5. Which adjacent systems could be affected by the fix?

At minimum, inspect:

- the primary scene or scenes where the bug manifests
- the attached scripts and any scripts called along the affected flow
- relevant exported variables, node paths, signal connections, and child node ownership
- autoloads, managers, or shared helpers touched by the flow
- related resources such as animations, sprite frames, themes, custom resources, or packed scenes
- `project.godot` when input mappings, autoloads, or project settings are part of the problem

When relevant, explicitly inspect:

- scene inheritance
- missing or invalid node references
- duplicate or missing signal connections
- collision layers and masks
- animation callbacks and timing
- spawn points, ownership, and lifecycle timing
- UI focus, visibility, anchors, and event handling
- performance-heavy loops, repeated lookups, or structural inefficiencies causing regressions

## Debugging Workflow

1. Restate the bug in technical terms.
   - Translate the user symptom into the specific runtime or configuration problem to investigate.
   - State what observable behavior is wrong and what the expected behavior likely is.

2. Inspect the real execution path.
   - Follow the actual scene, script, signal, resource, and configuration path involved in the bug.
   - Do not assume the source of the problem before tracing it.

3. Identify the likely root cause.
   - Use repository evidence to narrow the cause to code logic, scene config, signal wiring, resource linkage, collision setup, animation timing, input setup, or performance structure.
   - Separate confirmed findings from informed inference.

4. Confirm impacted files and systems.
   - Identify which scenes, scripts, resources, autoloads, and dependent systems are actually affected by the bug and the proposed fix.

5. Implement the narrowest safe fix.
   - Change only what is necessary to resolve the root cause.
   - Avoid opportunistic cleanup or refactoring during the fix unless required to safely resolve the issue.

6. Verify adjacent breakage risks.
   - Check node paths, signal contracts, exported variables, resource links, scene inheritance, collision behavior, timing assumptions, and dependent flows that may be affected.

7. Summarize cause, fix, and remaining risk.
   - State the likely root cause.
   - State what changed.
   - State what remains uncertain or what should still be verified manually.

## Safety / Guardrails

- Do not apply blind fixes.
- Do not refactor unrelated systems during bug fixes.
- Do not ignore scene configuration when debugging script behavior.
- Do not assume the bug is purely code if it may be resource or editor wiring.
- Do not change multiple systems when the root cause is localized.
- Do not replace evidence with guesswork.
- Do not leave configuration, references, or dependent resources inconsistent after a fix.

## Expected Outputs

For substantive tasks, structure work output as:

1. Bug summary
   - The issue restated in technical terms

2. Repository observations
   - Relevant scenes, scripts, resources, signals, autoloads, and configuration inspected

3. Root cause analysis
   - Most likely cause
   - Evidence supporting it
   - Any uncertainty that remains

4. Fix result
   - Files changed
   - Narrow summary of the fix applied

5. Verification and risk
   - What adjacent references, configuration, or flows were checked
   - Remaining risks or recommended follow-up checks

## Definition Of Done

The task is done only when all of the following are true:

- the likely root cause was identified from repository evidence
- the fix is scoped to the actual problem
- affected references and configuration were updated where needed
- related scene, script, signal, resource, or project settings touched by the fix remain consistent
- remaining uncertainty is clearly stated
