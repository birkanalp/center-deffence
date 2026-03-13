# Center Defense — Project Overview

## What Is This Project?

**Center Defense** is a 2D mobile tower defense game where the player defends a central tower from enemies that spawn at screen edges. The core mechanic is swiping or dragging to send soldiers in a chosen direction. Soldiers walk outward from the tower, engage enemies in combat, and stop at max range if no enemies are encountered.

## Engine & Framework

- **Engine:** Godot 4.4
- **Rendering:** Mobile renderer with ETC2/ASTC texture compression
- **Language:** GDScript
- **Platform:** Strictly 2D (no 3D nodes or workflows)

## Target Platforms

- **Primary:** Mobile (portrait orientation)
- **Resolution:** 1080×1920 viewport, `keep_width` stretch
- **Input:** Touch-first (mouse emulates touch in editor)
- **Orientation:** Portrait (`handheld/orientation=1`)

## Gameplay Style

- **Genre:** Tower defense, wave survival
- **Perspective:** Top-down, center-focused
- **Core loop:** Tap and hold → choose soldier type → release to spawn soldier in that direction
- **Economy:** In-match coins (spawn cost, passive income, kill rewards) + persistent coins (store unlocks)
- **Win condition (Classic):** Survive 3 minutes while keeping the tower alive
- **Win condition (Survival):** Survive as long as possible until the tower is destroyed

## Current Project Maturity

The project is **playable and feature-complete** at a basic level:

- Full game loop (menu → gameplay → game over)
- Two game modes (Classic, Survival)
- Soldier spawning with touch input and type selection
- Wave-based enemy spawning with variants
- Combat system (soldier vs enemy, enemy vs tower)
- Economy and persistence
- Soldier store with unlocks
- Profile and scoreboard

**Not yet implemented:** Sound/music, settings UI, visual effects (particles, hit effects), advertisements, IAP.

## Major Components

| Component | Purpose |
|-----------|---------|
| **GameManager** | Global game state, session data (coins, kills, waves, time), victory flag |
| **SaveManager** | Persistent save/load (profile, unlocks, scores, settings) via JSON |
| **SoldierRegistry** | Loads soldier types from `.tres` files, provides unlocked/locked lists |
| **Gameplay** | Main gameplay scene; orchestrates tower, soldiers, enemies, touch input, HUD |
| **EnemySpawner** | Wave-based spawning from screen edges with enemy type variants |
| **TouchInputHandler** | Joystick-style input: hold to cycle soldier types, release to spawn |
| **Tower** | Central objective; StaticBody2D with health, takes damage from enemies |
| **Soldier** | CharacterBody2D; spawns at tower, moves in direction, fights enemies |
| **Enemy** | CharacterBody2D; spawns at edges, walks to tower, fights soldiers or tower |
