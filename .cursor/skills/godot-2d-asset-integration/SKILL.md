---
name: godot-2d-asset-integration
description: >-
  Integrates new 2D visual assets into Godot 4.x projects safely and
  consistently. Use when importing sprites, connecting assets to scenes,
  preparing visuals for gameplay, or adding characters, props, tilesets, or
  UI images. Strictly 2D workflows only.
---

# Godot 2D Asset Integration

## Workflow

1. Inspect the Godot project structure.
2. Identify the asset type.
3. Choose the appropriate Godot node setup.
4. Follow existing patterns in the repository.
5. Integrate the asset with minimal disruption.
6. Validate by running the project.

## Asset Classification

Determine whether the asset is:

- single sprite
- sprite sheet
- animation frame sequence
- tileset atlas
- environment prop
- character
- enemy
- NPC
- collectible
- UI image
- background layer
- visual effect

## Node Selection

| Asset Type            | Node Setup                                            |
|-----------------------|--------------------------------------------------------|
| Static decoration     | Sprite2D                                              |
| Animated sprite sheet | AnimatedSprite2D + SpriteFrames                        |
| Interactable item     | Area2D + Sprite2D + CollisionShape2D                  |
| Character or enemy    | CharacterBody2D + AnimatedSprite2D                    |
| Background layer      | Sprite2D or ParallaxBackground (match project)        |
| Tile asset            | TileSet + TileMap                                     |

## Rules

### Collision
Add CollisionShape2D only when gameplay requires collision.

### Scripts
- Do not attach scripts to purely visual assets.
- Attach scripts only when interaction or behavior is required.

### Project Safety
- Never break existing scenes.
- Never rewrite gameplay systems unnecessarily.
- Follow existing naming conventions and folder structure (see `docs/ai-rules.md`).
- Prefer modifying small parts over rewriting files.

### Supported Nodes (2D Only)
Node2D, Sprite2D, AnimatedSprite2D, CharacterBody2D, Area2D, CollisionShape2D, TileMap, AnimationPlayer, ParallaxBackground, ParallaxLayer. Never introduce 3D nodes.

## Godot MCP Tools

When available, use MCP rather than static file edits:

- get_project_info
- create_scene
- add_node
- load_sprite
- save_scene
- run_project
- get_debug_output

## Validation

Before finishing:

- [ ] Asset loads
- [ ] Sprite renders
- [ ] Animations play (if present)
- [ ] Collisions work (if added)
- [ ] Game runs without errors

## Output Format

Return:

1. Asset classification
2. Integration plan
3. Files changed
4. Node structure added
5. Validation checklist
6. Assumptions
