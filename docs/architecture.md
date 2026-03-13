# Architecture

## Folder Structure

```
center-deffence/
├── assets/
│   └── sprites/           # PNG textures (tower, soldier, enemy, health bars, direction arrow)
├── resources/
│   ├── entity_configs/     # SoldierData .tres files (soldier_warrior, soldier_tank, etc.)
│   └── themes/            # game_theme.tres
├── scripts/
│   ├── autoloads/         # GameManager, SaveManager, SoldierRegistry
│   ├── data/             # SoldierData class
│   └── systems/          # touch_input.gd, enemy_spawner.gd
├── scenes/
│   ├── entities/          # tower/, soldier/, enemy/
│   ├── gameplay/          # Main gameplay scene
│   ├── game_over/         # Game over screen
│   ├── main_menu/         # Main menu
│   └── ui/                # profile, scoreboard, soldier_card, soldier_store
├── docs/
├── project.godot
└── .cursor/               # Agents, skills
```

## Scene Structure

### Scene Flow

```
main_menu.tscn (entry)
    ├── gameplay.tscn      (Classic or Survival)
    │       └── game_over.tscn
    ├── scoreboard.tscn
    ├── profile.tscn
    └── soldier_store.tscn
```

All UI scenes return to `main_menu.tscn` via `change_scene_to_file()`.

### Gameplay Scene Hierarchy

```
Gameplay (Node2D)
├── Background (ColorRect)
├── GameWorld (Node2D)
│   ├── Tower (instance of tower.tscn)
│   ├── Soldiers (Node2D) — container for spawned soldiers
│   ├── Enemies (Node2D) — container for spawned enemies
│   └── Effects (Node2D) — empty, reserved for VFX
├── TouchInputHandler (Node2D)
│   └── DirectionArrow (Sprite2D)
├── EnemySpawner (Node)
│   ├── SpawnTimer
│   └── WaveTimer
└── HUD (CanvasLayer)
    ├── HUDPanelTopLeft, HUDPanelTopRight, HUDPanelBottomLeft, HUDPanelBottomRight
    ├── TimerLabel, CoinsLabel, WaveLabel
    └── KillsLabel, TowerHealthLabel
```

### Entity Scene Pattern

All entities follow a consistent node layout:

```
Entity (StaticBody2D or CharacterBody2D)
├── Sprite2D
├── CollisionShape2D
├── [DetectionArea / HitArea for interaction] — optional
├── HealthBarBG (Sprite2D)
├── HealthBarFill (Sprite2D)
└── CombatTimer (Timer) — for soldier/enemy
```

- **Tower:** StaticBody2D, Sprite2D, CollisionShape2D, HitArea (Area2D), health bar sprites
- **Soldier:** CharacterBody2D, Sprite2D, CollisionShape2D, DetectionArea (Area2D), health bar, CombatTimer
- **Enemy:** CharacterBody2D, Sprite2D, CollisionShape2D, health bar, CombatTimer

## Important Systems

### Physics Layers

Defined in `project.godot` as `layer_1`, `layer_2`, `layer_3`:

| Layer | Name     | Collision Value | Used By               |
|-------|----------|-----------------|------------------------|
| 1     | tower    | 1               | Tower, tower HitArea   |
| 2     | soldiers | 2               | Soldiers, DetectionArea |
| 3     | enemies  | 4               | Enemies                |

Collision: tower mask 4 (collides with enemies), soldiers mask 4 (collides with enemies), enemies mask 3 (collides with tower + soldiers).

### Autoloads

| Autoload        | Script                         | Role |
|-----------------|--------------------------------|------|
| GameManager     | `scripts/autoloads/game_manager.gd`   | Session state: coins, kills, waves, time, victory, game mode |
| SaveManager     | `scripts/autoloads/save_manager.gd`   | JSON persistence at `user://save_data.json`, schema versioning |
| SoldierRegistry | `scripts/autoloads/soldier_registry.gd` | Loads `soldier_*.tres`, provides `get_all()`, `get_unlocked()`, `get_locked()`, `get_by_id()` |

### Main Scripts and Roles

| Script | Scene/Node | Role |
|--------|------------|------|
| `gameplay.gd` | Gameplay | Orchestrator: timer, passive income, spawn logic, HUD updates, scene transitions |
| `tower.gd` | Tower | Health, `take_damage()`, signals `tower_destroyed`, `health_changed` |
| `soldier.gd` | Soldier | State machine (WALKING, IDLE, FIGHTING, DYING), configured via SoldierData |
| `enemy.gd` | Enemy | State machine (WALKING, FIGHTING, DYING), walks to tower, engages soldiers |
| `touch_input.gd` | TouchInputHandler | Touch/drag input, soldier type cycling, `direction_confirmed` signal |
| `enemy_spawner.gd` | EnemySpawner | Waves, spawn positions, enemy variants (fast, tank), wave scaling |
| `main_menu.gd` | MainMenu | Mode selection, navigation to gameplay/UI |
| `game_over.gd` | GameOver | Result display, `record_game_result()`, Play Again / Menu |
| `soldier_store.gd` | SoldierStore | Card list, buy flow, persists unlocks |
| `soldier_card.gd` | SoldierCard | Card UI, `setup()`, `buy_pressed` signal |
| `profile.gd` | Profile | Player name, stats from SaveManager |
| `scoreboard.gd` | Scoreboard | Classic/Survival tabs, top 10 scores |

### Scene Interactions

1. **Main Menu → Gameplay:** Sets `GameManager.game_mode`, loads `gameplay.tscn`.
2. **Gameplay → Game Over:** Tower destroyed or time up → `change_scene_to_file("game_over.tscn")`.
3. **Touch Input → Soldier Spawn:** `direction_confirmed(direction, soldier_type)` → gameplay spawns soldier from tower.
4. **Soldier ↔ Enemy:** Soldier `DetectionArea.body_entered` → `engage_combat(soldier)`, combat via `CombatTimer` and `take_damage()`.
5. **Enemy → Tower:** When enemy reaches tower, `current_tower.take_damage()`.
6. **Game Over → Save:** `GameManager.record_game_result()` → SaveManager updates profile and scores.

## Asset Organization

| Path | Contents |
|------|----------|
| `assets/sprites/` | tower.png, soldier.png, enemy_basic.png, health_bar_bg.png, health_bar_fill.png, direction_arrow.png |
| `resources/entity_configs/` | soldier_warrior.tres, soldier_tank.tres, soldier_ranger.tres, soldier_healer.tres, soldier_berserker.tres |
| `resources/themes/` | game_theme.tres (Button, Panel, PanelContainer, LineEdit, ScrollContainer, Label) |

## Reusable Scene Patterns

1. **Entity with Health:** Sprite2D + HealthBarBG + HealthBarFill, `_update_health_bar()` with color ramp (green > yellow > red).
2. **Data-Driven Entities:** Soldier uses `SoldierData` and `configure_from_data()`, loaded by SoldierRegistry.
3. **Combat:** Timer-based attacks; entities call `take_damage()` on target.
4. **Groups:** `"tower"`, `"soldiers"`, `"enemies"` for lookup (e.g. `get_tree().get_first_node_in_group("tower")`).
