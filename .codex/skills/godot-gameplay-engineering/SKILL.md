---
name: godot-gameplay-engineering
description: Implement and modify gameplay systems in an existing Godot 2D game repository. Use when changing movement, combat, health, AI, pickups, interactions, spawning, progression, abilities, or gameplay entity signaling while preserving current architecture, scene composition, and gameplay flow.
---

# Godot Gameplay Engineering

## Purpose

Use this skill to implement or modify gameplay systems in an existing Godot 2D project without disrupting the current gameplay architecture, scene composition, or runtime flow.

This skill is for production work inside a real repository. It assumes the project already has gameplay entities, node structures, signals, timers, resources, managers, and scene-level contracts that must be inspected before any logic is changed.

The goal is to extend or adjust the current implementation safely, keep logic modular, and avoid introducing a competing gameplay architecture.

## When To Use

Use this skill when the task involves implementing or modifying gameplay systems such as:

- player movement
- combat
- health and damage
- AI behaviors
- item pickup
- interactions
- spawning
- progression systems
- abilities
- signals between gameplay entities

Use it when the task may affect:

- entity scenes and attached scripts
- collision and detection areas
- timers and cooldowns
- animation-driven gameplay events
- autoload managers
- reusable components or shared gameplay helpers
- groups, signals, state transitions, or event flow between entities

## When NOT To Use

Do not use this skill when:

- the task is primarily asset integration with minimal gameplay impact
- the task is primarily UI layout or menu work
- the task is documentation-only
- the task is purely a visual scene-building request with no meaningful gameplay logic
- the task is unrelated to an existing Godot repository

If gameplay work is only one part of a larger request, use the project orchestrator first and route here when gameplay logic is the main implementation risk.

## Core Behavior

- Inspect existing gameplay architecture first.
- Identify whether the project uses `CharacterBody2D`, `Area2D`, `RigidBody2D`, state machines, signals, timers, animation-driven events, autoload managers, or custom component patterns.
- Preserve existing gameplay flow and scene composition.
- Keep logic modular and maintainable.
- Avoid hardcoding values that should be exported or configurable.
- Prefer extending current systems instead of creating competing systems.
- Think in terms of scene tree ownership, event flow, signal flow, timing, and runtime side effects.

## Required Repository Inspection

Before planning or editing, inspect enough of the repository to answer all of the following:

1. Which gameplay scenes and scripts are directly involved?
2. How does data and event flow move through the current system?
3. Which existing nodes, managers, signals, timers, and resources already own this behavior?
4. Which exported variables, scene references, or hidden assumptions must remain valid?
5. Which related entities or systems could be affected by the change?

At minimum, inspect:

- the target gameplay scene and its attached script
- the nearest similar gameplay scene or entity
- related autoloads, managers, registries, or shared gameplay helpers
- signals, groups, timers, and animation hooks used by the target flow
- relevant resources, child nodes, collision areas, hitboxes, hurtboxes, and animation resources
- `project.godot` if input mappings, pause behavior, or shared project settings affect the requested change

When relevant, explicitly check whether the current implementation relies on:

- `CharacterBody2D`, `Area2D`, or `RigidBody2D`
- state machines or explicit state enums
- signal-based communication
- timers or cooldown nodes
- animation-driven events or `AnimationPlayer` callbacks
- autoload managers or registries
- custom component-style composition
- inherited scenes
- groups and target filtering

## Implementation Workflow

1. Inspect related gameplay scenes and scripts.
   - Read the target entity or system first.
   - Inspect the nearest similar implementation before changing logic.

2. Trace event and data flow.
   - Determine how input, collisions, damage, targeting, spawning, progression, or entity communication currently flows through the scene tree and scripts.
   - Identify who owns the behavior and who depends on it.

3. Identify reusable patterns already in the repo.
   - Reuse current managers, helpers, signal patterns, exported configuration, and scene composition.
   - Match the repository’s existing level of coupling or modularity instead of inventing a different model.

4. Implement the requested change.
   - Modify the current implementation using the smallest safe change set.
   - Keep the logic localized and coherent.

5. Update signals, exported variables, references, and dependent scripts.
   - Keep signal contracts, exported configuration, node paths, and cross-script assumptions aligned with the new behavior.
   - Update dependent scripts only where the changed behavior requires it.

6. Verify edge cases.
   - Check pause state behavior.
   - Check death or despawn state behavior.
   - Check empty or missing references.
   - Check duplicate signal connections.
   - Check invalid targets.
   - Check timing issues, race-like sequencing problems, and cooldown or animation timing assumptions.

## Safety / Guardrails

- Do not introduce new architecture without strong reason.
- Do not break node paths or assumptions hidden in scenes.
- Do not create tightly coupled gameplay code unless the repository already works that way.
- Avoid magic strings and fragile node lookups when better local patterns already exist.
- Do not hardcode values that belong in exported variables, resources, or existing config points.
- Do not replace existing managers, components, or signal flow with a competing system.
- Do not rewrite unrelated gameplay while implementing a focused change.
- Do not break inherited scene behavior, collision setup, or animation-linked logic.

## Expected Outputs

For substantive tasks, structure work output as:

1. Gameplay change summary
   - What behavior was added or changed
   - What behavior was intentionally preserved

2. Repository observations
   - Relevant scenes, scripts, managers, signals, resources, and patterns inspected

3. Implementation result
   - Files changed
   - High-level summary of the gameplay logic updated

4. Verification
   - What event flow, signals, references, node paths, and edge cases were checked

5. Risks and assumptions
   - Any risky assumptions
   - Any runtime or editor-side follow-up checks still recommended

## Definition Of Done

The task is done only when all of the following are true:

- the gameplay change is implemented consistently with existing repository patterns
- relevant gameplay scenes, scripts, and related systems were inspected first
- scene, script, and resource references touched by the change remain valid
- exported variables and signals were updated where needed
- dependent scripts and related references were updated where required by the change
- edge cases such as pause, death, missing references, duplicate connections, invalid targets, and timing issues were considered
- risky assumptions are called out explicitly
