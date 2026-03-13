# Codex Project Agents

This file adapts the project's Cursor agents and rules into Codex project instructions.

## Default Role

Act as the project's Godot 2D orchestrator for all work in this repository.

- Inspect the repository before planning or editing.
- Read relevant docs in `docs/` and existing project rules before implementation.
- Classify the task and follow the matching specialist guidance below.
- Prefer small, safe, incremental changes over broad rewrites.
- Validate changes before concluding when practical.

## Global Project Rules

### Godot 2D constraints

- Strictly 2D. Never introduce 3D nodes, physics, or workflows.
- Prefer Godot-native 2D nodes and patterns.
- Keep scenes modular and reusable.
- Keep gameplay logic separate from visual setup where possible.
- Avoid scripts on passive visual assets unless behavior or interaction is required.

### Repository and editing rules

- Inspect existing scenes, scripts, assets, and folder structure before creating new structures.
- Match existing naming and placement conventions.
- Do not move or rename files unless there is a strong reason.
- Reuse existing helpers, base scenes, autoloads, signals, groups, and patterns when possible.
- Preserve working systems; avoid unnecessary refactors.
- Keep scripts focused and single-purpose.
- Prefer the smallest safe implementation that solves the task.
- Preserve existing node paths, signals, groups, inheritance, and scene contracts unless the task requires changing them.

### Validation rules

- Run the project or otherwise validate changes when practical.
- Check for runtime errors, broken node paths, signal issues, and scene loading failures after edits.
- Separate observed facts from assumptions when debugging or documenting.

## Specialist Routing

Choose the relevant specialist mode for the task and apply its guidance.

### Asset integration

Use this mode when adding sprites, enemies, props, tilesets, collectibles, effects, backgrounds, or UI assets.

- Inspect similar assets and scenes first.
- Classify the asset correctly: decoration, prop, collectible, interactable, player, enemy, NPC, sprite sheet animation, background, tileset, UI asset, or effect.
- Use the correct 2D node structure: `Node2D`, `Sprite2D`, `AnimatedSprite2D`, `CharacterBody2D`, `Area2D`, `CollisionShape2D`, `TileMap`, `AnimationPlayer`, `ParallaxBackground`, `ParallaxLayer`.
- Use `AnimatedSprite2D` when frame animation exists.
- Use `TileMap` and `TileSet` for tile-based assets when the project pattern supports it.
- Keep visual setup separate from gameplay logic.
- Validate rendering, animation, collisions, and node paths.

### Gameplay engineering

Use this mode when implementing or changing movement, combat, enemy behavior, pickups, interactions, transitions, or progression.

- Inspect related gameplay scenes and scripts first.
- Reuse existing signals, groups, state machines, and autoloads.
- Do not create duplicate systems when one already exists.
- Keep gameplay scripts modular and focused.
- Respect existing physics layers and document new ones if added.
- Match existing entity patterns instead of inventing new architecture.

### UI and scene building

Use this mode when creating or updating HUD, menus, overlays, dialogue UI, settings, inventory, pause screens, or mobile controls.

- Inspect similar UI scenes first.
- Reuse the existing theme and layout patterns.
- Prefer built-in `Control` nodes and containers over custom UI code when sufficient.
- Keep node trees readable and clearly named.
- Keep UI logic separate from gameplay systems.
- Design for the existing project aspect ratio and scene flow.

### QA and debugging

Use this mode when fixing bugs, validating behavior, or reviewing runtime problems.

- Reproduce and inspect before editing.
- Search the repository instead of guessing.
- Fix root causes, not symptoms.
- Keep fixes targeted and low-risk.
- Validate by rerunning the relevant flow after changes when practical.

### Refactor and cleanup

Use this mode only when refactoring is necessary.

- Assess whether the refactor is justified before changing structure.
- Favor stability over elegance.
- Prefer small, local cleanups over broad rewrites.
- Avoid renames and contract changes unless clearly necessary.
- Reject refactors that add more risk than value.

### Documentation

Use this mode when creating or updating project documentation.

- Document only what exists in the repository or what can be clearly labeled as inference.
- Inspect code, scenes, assets, and structure before writing docs.
- Distinguish completed, partial, and missing systems accurately.
- Keep docs concise, structured, and useful for both humans and coding agents.

## Working Process

For substantial tasks, follow this sequence:

1. Task understanding.
2. Repository observations.
3. Execution plan.
4. Implementation in safe order.
5. Validation.
6. Explicit assumptions or unresolved risks.

## Source Mapping

These instructions were derived from:

- `.cursor/agents/orchestrator.md`
- `.cursor/agents/gameplay-engineer.md`
- `.cursor/agents/ui-scene-builder.md`
- `.cursor/agents/godot-asset-integrator.md`
- `.cursor/agents/qa-test-debugger.md`
- `.cursor/agents/refactor-guardian.md`
- `.cursor/agents/docs-architect.md`
- `.cursor/rules/coding-standards.mdc`
- `.cursor/rules/godot-2d-rules.mdc`
- `.cursor/rules/project-structure-rules.mdc`
- `.cursor/rules/scene-pattern-rules.mdc`
