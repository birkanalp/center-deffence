---
name: godot-ui-implementation
description: >-
  Builds and extends UI scenes in Godot 2D projects. Use when creating HUD,
  menus, overlays, dialogue, mobile controls, or correcting UI. Strictly 2D
  Control-based workflows only.
---

# Godot UI Implementation

## Rules

- **Strictly 2D.** Use Godot UI / Control workflows only.
- **Inspect first.** Examine similar existing UI scenes before creating new ones.
- **Reusable components.** Prefer reusable UI components over monolithic screens.
- **Separate from gameplay.** Keep UI behavior separate from core gameplay logic where possible.
- **Respect patterns.** Follow current layout, theme, and scaling patterns.

## Supported Use Cases

- HUD
- pause menu
- settings menu
- inventory UI
- dialogue box
- mobile controls
- overlays and popups
- health, score, quest, and status panels

## Implementation Guidelines

- Keep node trees organized
- Use containers and anchors correctly
- Avoid unnecessary code
- Reuse existing UI helpers or base scenes if present
- Preserve naming conventions and signal patterns

## Godot MCP

When available:

- Inspect scenes
- Validate UI scene loading
- run_project if needed
- Inspect runtime issues after changes

## Output Format

Return:

1. UI task summary
2. Existing UI patterns found
3. Chosen structure
4. Files changed
5. Validation checklist
6. Assumptions
