---
name: godot-ui-scene-building
description: Build and modify UI and scene composition in an existing Godot 2D game repository. Use when working on menus, HUD, overlays, dialog panels, inventory UI, settings screens, reusable UI scenes, scene hierarchy cleanup, or node composition changes while preserving current conventions and interaction flow.
---

# Godot UI Scene Building

## Purpose

Use this skill to build or modify UI and scene composition in an existing Godot 2D project while preserving current conventions, layout behavior, and scene integration.

This skill is for production work inside a real repository. It assumes the project already has scene composition patterns, node naming conventions, themes, signal wiring, visibility rules, and interaction flow that must be inspected before any UI or hierarchy change is made.

The goal is to extend the current implementation safely, keep scenes modular and reusable, and avoid introducing brittle hierarchy or duplicated UI patterns.

## When To Use

Use this skill when the task involves:

- menus
- HUD
- overlays
- dialog panels
- inventory UI
- settings screens
- reusable UI scenes
- scene hierarchy cleanup
- node composition changes

Use it when the work may affect:

- `Control`-based UI scenes
- `CanvasLayer` usage
- visibility and focus flow
- anchors, containers, scaling, and resolution behavior
- theme or skin usage
- reusable child scenes
- signal connections between UI and gameplay or scene controllers

## When NOT To Use

Do not use this skill when:

- the task is primarily gameplay logic with minimal UI impact
- the task is primarily asset integration without meaningful scene or UI composition work
- the task is documentation-only
- the task is unrelated to an existing Godot repository

If UI work is only one part of a larger task, use the project orchestrator first and route here when UI or scene composition is the main implementation concern.

## Core Behavior

- Inspect existing UI and scene composition patterns first.
- Follow current node naming, anchoring, containers, theme usage, signal patterns, and scene composition.
- Keep scenes modular and reusable.
- Avoid giant scene files when reusable scene pieces are more appropriate.
- Respect current interaction flow and input behavior.
- Consider resolution behavior, anchors, containers, and scaling.
- Prefer extending current UI architecture over creating duplicate patterns.
- Think in terms of hierarchy ownership, visibility rules, focus flow, signal flow, and scene integration impact.

## Required Repository Inspection

Before planning or editing, inspect enough of the repository to answer all of the following:

1. Which target scenes and scripts currently own the UI or composition being changed?
2. What UI architecture and reusable components already exist?
3. How do naming, anchors, containers, theme resources, signals, and scene composition currently work?
4. Should the change extend an existing scene or become a reusable child scene?
5. Which references, visibility rules, focus behavior, or input flow could break if the hierarchy changes?

At minimum, inspect:

- the target scene and its attached script
- the nearest similar UI or composition scene
- any reusable UI scenes, shared controls, or base scenes already used by the project
- related theme resources, styleboxes, fonts, textures, or custom UI resources
- current signal connections, visibility logic, and focus/navigation behavior
- relevant `project.godot` settings if scaling, input behavior, or window setup affects the UI

When relevant, explicitly inspect:

- anchors and container layout rules
- `CanvasLayer` usage and layering
- scene ownership and child scene composition
- input handling and focus traversal
- resolution and scaling behavior
- visibility toggles and modal flow
- UI-to-gameplay signal wiring

## Implementation Workflow

1. Inspect target scenes and related scripts.
   - Read the current UI scene or scene composition first.
   - Inspect the nearest similar scene before changing hierarchy or behavior.

2. Identify current UI architecture and reusable components.
   - Determine how this repository structures reusable UI pieces, containers, themes, and scene composition.
   - Reuse existing components and patterns where possible.

3. Decide whether to extend an existing scene or create a reusable child scene.
   - Prefer extending the current structure when the change is local.
   - Create a reusable child scene only when the project already follows that pattern or reuse clearly improves maintainability.

4. Implement hierarchy and script updates.
   - Apply the smallest coherent change to scene structure and attached scripts.
   - Keep node ownership, naming, and responsibilities clear.

5. Wire signals and references safely.
   - Update signal connections, exported references, scene links, and script expectations consistently.
   - Avoid introducing fragile hierarchy assumptions.

6. Verify layout, interaction, visibility rules, and scene integration impact.
   - Check anchors, containers, scaling, focus flow, modal or visibility behavior, and scene ownership impact.
   - Check whether the change affects gameplay integration, input flow, or parent scene assumptions.

## Safety / Guardrails

- Do not hardcode fragile node paths if the current project has a better pattern.
- Do not break focus flow, visibility rules, or scene ownership.
- Do not create unnecessary duplicate UI patterns.
- Do not ignore theme or skin consistency.
- Do not grow a scene into an unnecessarily large monolith when a reusable scene piece is the current repository pattern.
- Do not change unrelated hierarchy, layout, or signals while implementing a focused UI task.
- Do not break parent scene expectations, exported references, or signal contracts.

## Expected Outputs

For substantive tasks, structure work output as:

1. UI or scene change summary
   - What was added or changed
   - Whether an existing scene was extended or a reusable child scene was created

2. Repository observations
   - Relevant scenes, scripts, theme resources, reusable components, and patterns inspected

3. Implementation result
   - Files changed
   - High-level summary of hierarchy and script updates

4. Verification
   - What layout, interaction, visibility, focus, signal, and integration checks were performed

5. Visual verification notes
   - Any visual or in-editor checks still recommended

## Definition Of Done

The task is done only when all of the following are true:

- the scene or UI change matches existing project conventions
- target scenes, scripts, and reusable UI patterns were inspected first
- references and signals remain valid
- the resulting structure remains maintainable and consistent with current composition patterns
- interaction flow, focus behavior, visibility rules, and scene integration remain coherent
- any visual verification steps still needed are clearly noted
