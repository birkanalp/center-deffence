---
name: godot-asset-integration
description: Integrate new assets into an existing Godot 2D game repository. Use when adding sprites, sprite sheets, animations, tilesets, UI assets, sounds, prefabs/scenes, or third-party Godot-ready asset packs while preserving current asset organization, naming, references, and runtime behavior.
---

# Godot Asset Integration

## Purpose

Use this skill to integrate new assets into an existing Godot 2D project without disrupting the current asset pipeline, scene structure, or runtime behavior.

This skill is for production work inside a real repository. It assumes the project already has folder conventions, naming patterns, import expectations, scene references, animation setup, and editor-side assumptions that must be inspected before any asset is added or connected.

The goal is to place assets correctly, wire them into the existing implementation safely, and avoid creating broken references, duplicate content, or pipeline drift.

## When To Use

Use this skill when the task involves integrating any of the following into an existing Godot 2D project:

- sprites
- sprite sheets
- animations
- tilesets
- UI assets
- sounds
- prefabs or scenes
- imported third-party Godot-ready asset packs

Use it when the work may affect:

- scenes or reusable prefabs
- `AnimatedSprite2D` or `SpriteFrames`
- `AnimationPlayer` or animation libraries
- collisions and attachment points
- shaders, atlases, tilemaps, or tilesets
- scripts that reference textures, audio, scenes, or animation names

## When NOT To Use

Do not use this skill when:

- the task is primarily gameplay logic with no meaningful asset integration component
- the task is purely UI logic with no new visual or audio assets
- the task is purely debugging and the asset pipeline is not being changed
- the task is a documentation-only request
- the task is unrelated to an existing Godot repository

If asset integration is only one part of a larger request, use the project orchestrator first and route here as the primary specialist mode only when asset work is the main risk area.

## Core Behavior

- Inspect the current asset organization before adding anything.
- Preserve existing folder conventions and naming patterns.
- Avoid duplicating assets that already exist in the repository.
- Never assume import settings without checking how similar assets are used in the project.
- Verify whether the asset affects existing scenes, animations, collisions, shaders, atlases, tilemaps, or scripts.
- Check texture filtering and pixel art expectations when relevant.
- Check frame sizes, pivots, offsets, animation names, collision alignment, and node attachment points before finalizing changes.
- Keep naming consistent with the project.
- Prefer integrating into the current implementation over inventing a parallel asset structure.

## Required Repository Inspection

Before planning or editing, inspect enough of the repository to answer all of the following:

1. Where do assets of this type currently live?
2. How are similar assets named, imported, and referenced?
3. Which scenes, scripts, resources, or animations already consume similar assets?
4. Does the project use pixel art, filtered textures, atlases, tilesets, shaders, or special import conventions?
5. What existing references could break if this asset is added or replaced?

At minimum, inspect:

- asset folders relevant to the asset type
- the nearest similar scenes or prefabs
- the scripts attached to those scenes
- any `SpriteFrames`, `AnimationPlayer`, `TileSet`, shader, theme, or audio resources involved
- current naming, placement, and reuse patterns
- `project.godot` or relevant project settings if texture filtering, rendering, or input-triggered assets are involved

When relevant, explicitly check:

- texture filtering vs pixel art expectations
- region/atlas usage
- frame size consistency for sprite sheets
- pivots, offsets, and attachment points
- collision alignment against the visual asset
- animation naming conventions
- tile size, snapping, terrain setup, and tilemap usage
- whether a third-party asset pack includes files the project already has equivalents for

## Implementation Workflow

1. Inspect asset folders and relevant scenes.
   - Identify how this repository organizes textures, audio, scenes, tilesets, and reusable prefabs.
   - Inspect the nearest existing asset of the same type before adding anything.

2. Determine where the new asset belongs.
   - Place it according to the project’s existing folder and naming conventions.
   - Avoid introducing a new folder pattern unless the repository clearly requires it.

3. Inspect current references and usage style.
   - Check how similar assets are referenced by scenes, scripts, animations, tilesets, shaders, and resources.
   - Check import expectations instead of assuming defaults.

4. Add or import the asset safely.
   - Add only the files that are actually needed.
   - Avoid duplicating existing assets or leaving unused pack content around when the project does not follow that pattern.

5. Connect it to the correct scene or script.
   - Wire the asset into the current scene tree, resource, animation, audio player, or script path that already owns this responsibility.
   - Preserve current ownership and composition patterns.

6. Preserve transform, scale, anchors, z-index, collisions, and animation behavior.
   - Keep visual alignment and runtime behavior consistent with the existing scene setup.
   - Check pivots, offsets, frame setup, collision fit, and attachment points where relevant.

7. Verify no broken references or mismatched names remain.
   - Check scene references, resource paths, animation names, sprite frame usage, tilemap references, script paths, and inherited scenes for consistency.

## Safety / Guardrails

- Do not replace working assets blindly.
- Do not rename existing referenced files unless necessary.
- Do not break `AnimationPlayer`, `SpriteFrames`, `TileMap`, `TileSet`, or scene inheritance.
- Do not change unrelated art pipeline settings.
- Do not assume imported third-party assets can be dropped in without checking how the project already structures equivalent content.
- Do not modify unrelated scenes or scripts while connecting the asset.
- Do not change filtering, compression, atlas, shader, or rendering behavior globally unless the task explicitly requires it and repository evidence supports it.
- Do not leave inconsistent names, duplicate imports, or stale references behind.

## Expected Outputs

For substantive tasks, structure work output as:

1. Asset integration summary
   - What asset was added or changed
   - What part of the project it affects

2. Repository observations
   - Relevant asset folders, scenes, scripts, resources, and usage patterns inspected

3. Implementation result
   - List of files added or changed
   - Where the asset was integrated

4. Verification
   - What references, animations, scene links, tilemaps, collisions, or naming consistency checks were performed

5. Assumptions and follow-up
   - Any assumptions that still need manual visual verification
   - Any recommended editor checks or in-engine validation passes

## Definition Of Done

The task is done only when all of the following are true:

- relevant asset folders, scenes, scripts, and resources were inspected first
- the asset was placed using existing folder and naming conventions
- no duplicate or parallel asset structure was introduced without repository evidence
- import and usage style were checked instead of assumed
- transforms, scale, anchors, z-index, collisions, and animation behavior were preserved where relevant
- scene references, resource paths, animation names, tilemap links, and script references touched by the change remain consistent
- the output includes the files added or changed, where the asset was integrated, and any manual visual verification or editor checks still recommended
