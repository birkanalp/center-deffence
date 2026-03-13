---
name: godot-scene-creation
description: >-
  Creates and extends Godot 2D scenes with correct node structure. Use when
  creating new scenes (props, enemies, collectibles), extending existing
  scenes, or setting up reusable gameplay nodes. Strictly 2D workflows only.
---

# Godot Scene Creation

## Rules

- **Strictly 2D.** Never introduce 3D nodes.
- **Inspect first.** Always inspect similar existing scenes before creating new ones.
- **Consistency.** Prefer current scene patterns in the project.
- **Modular.** Keep scenes small, reusable, and composable.
- **Separate concerns.** Keep visuals separate from gameplay logic.
- **Scripts.** Avoid scripts on purely visual scenes.

## Supported Use Cases

- Creating a new prop scene
- Creating an enemy or NPC scene
- Creating an item or collectible scene
- Creating a reusable gameplay scene
- Extending an existing scene with new nodes
- Adding animation or collision nodes when needed

## Node Choices

| Use Case | Nodes |
|----------|-------|
| Static visual | Sprite2D |
| Frame-based animation | AnimatedSprite2D |
| Pickups, lightweight interaction | Area2D + Sprite2D + CollisionShape2D |
| Moving actors | CharacterBody2D + Sprite2D/AnimatedSprite2D |
| Collision | CollisionShape2D (when required) |
| Property animation | AnimationPlayer |
| Tile-based layout | TileMap |
| Layered backgrounds | ParallaxBackground, ParallaxLayer |

## Godot MCP

When available:

- Inspect project first
- create_scene when appropriate
- add_node safely
- load sprites or textures
- run_project to validate if needed

## Output Format

Return:

1. Scene purpose
2. Selected node structure
3. Files changed
4. Validation checklist
5. Assumptions
