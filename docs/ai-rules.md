# AI Contributor Rules

Guidelines for AI-assisted development on Center Defense.

## Project Structure

- **Follow existing folder layout.** Place new scenes in `scenes/`, scripts in `scripts/`, assets in `assets/`, resources in `resources/`.
- **Match naming:** `snake_case` for files and nodes. Scene folders: `entity_name/` (e.g. `soldier/`, `enemy/`).
- **Reuse paths:** New soldier types go in `resources/entity_configs/` as `soldier_*.tres`. New sprites go in `assets/sprites/`.

## Scenes and Scripts

- **Reuse existing scenes and scripts.** Do not duplicate Tower, Soldier, Enemy, or UI screens. Extend or compose them instead.
- **Keep scenes modular.** Prefer instancing sub-scenes (`preload`, `instance`) over large monolithic scenes.
- **Avoid unnecessary refactors.** Do not reorganize folder structure, rename core systems, or change architecture without clear need.
- **Prefer incremental changes.** Add features with minimal edits; avoid rewriting entire files.

## Godot Conventions

- **Strictly 2D.** Use only 2D nodes (Node2D, Sprite2D, CharacterBody2D, Area2D, etc.). Never introduce 3D nodes or workflows.
- **Respect physics layers.** Use existing layers from project.godot: 1 (tower), 2 (soldiers), 3 (enemies; collision value 4). Document any new layers.
- **Use groups.** Add new entities to `"tower"`, `"soldiers"`, or `"enemies"` if they participate in combat/lookup.
- **Match entity pattern.** New combat entities: Sprite2D, CollisionShape2D, HealthBarBG, HealthBarFill, optional DetectionArea/HitArea, CombatTimer if needed.

## Data and Configuration

- **Soldier types:** Add new soldiers by creating `soldier_<id>.tres` in `resources/entity_configs/`. SoldierRegistry loads them automatically.
- **Save schema:** If extending SaveManager data, add to `_get_default_data()` and consider `_migrate_if_needed()` for existing saves.
- **Use autoloads.** Prefer GameManager, SaveManager, SoldierRegistry for shared state; avoid new global singletons unless necessary.

## Code Style

- **GDScript style:** Match existing scripts: type hints where useful, `@onready` for node refs, `@export` for designer tuning.
- **Signals over polling:** Use signals for cross-scene communication (e.g. `tower_destroyed`, `direction_confirmed`).
- **Comments:** Add `##` docstrings for non-obvious behavior; keep comments concise.

## Testing and Validation

- **Run the project** after changes. Ensure no runtime errors in debug output.
- **Verify scene loading** if adding or editing .tscn files.
- **Check node paths** when using `$NodePath` or `get_node()`; update if hierarchy changes.

## Do Not

- Remove or rename GameManager, SaveManager, SoldierRegistry without updating all references.
- Change physics layer numbers without updating collision_layer/collision_mask on affected nodes.
- Break the main loop: main_menu → gameplay → game_over.
- Add scripts to purely visual nodes unless interaction is required.
- Introduce 3D, shaders, or other 3D-related features.
