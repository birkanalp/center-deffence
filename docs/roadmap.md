# Development Roadmap

Based on the current repository state.

## Phase 1: Completed Systems

| System | Status | Notes |
|--------|--------|-------|
| Game loop | Done | main_menu → gameplay → game_over |
| Classic mode | Done | 3-minute timer, victory on survive |
| Survival mode | Done | Endless until tower falls |
| Touch input | Done | Swipe direction, hold to cycle soldier type |
| Soldier spawning | Done | Cost deduction, SoldierData configuration |
| Enemy spawning | Done | Wave-based, edge spawn, fast/tank variants, scaling |
| Combat | Done | Soldier vs enemy, enemy vs tower |
| Economy | Done | In-match coins, passive income, kill rewards |
| Persistent coins | Done | Earned per game, stored in profile |
| Soldier store | Done | Buy unlocks with persistent coins |
| Soldier data | Done | 5 types via .tres, SoldierRegistry |
| Profile | Done | Name, total games/kills/time |
| Scoreboard | Done | Classic and Survival, top 10 |
| Save system | Done | JSON, schema version, auto-save on pause/close |
| Physics layers | Done | tower(1), soldiers(2), enemies(3); values 1, 2, 4 |
| Theming | Done | game_theme.tres applied |

## Phase 2: Partially Implemented

| System | Status | Missing |
|--------|--------|---------|
| Settings | Schema only | UI for sfx_volume, music_volume; no sliders |
| Profile save | Deferred | Name saved via SaveManager.set_value on edit; persists on app pause/close (no Save button) |
| Effects container | Empty | GameWorld/Effects exists but unused; no VFX |
| Save schema | Extended | `ads_removed`, `settings` keys present; no usage |

## Phase 3: Missing Systems

| System | Notes |
|--------|------|
| Sound effects | No AudioStreamPlayer; hit, spawn, victory/defeat |
| Music | No background music |
| Visual effects | No particles, hit flashes beyond modulate |
| Animations | All sprites static; no AnimatedSprite2D |
| Settings screen | Link from menu; volume controls |
| Ads / IAP | `ads_removed`, `is_premium` in schema; no implementation |
| Tutorial | No onboarding or first-run guidance |
| Pause menu | No in-game pause |

## Phase 4: Logical Next Steps

### 4.1 Audio (High impact)

1. Add SFX for: soldier spawn, combat hit, enemy death, tower damage, victory, defeat.
2. Add background music.
3. Create Settings screen with volume sliders.
4. Wire sliders to SaveManager `settings.sfx_volume`, `settings.music_volume`.

### 4.2 Polish (Medium impact)

1. Populate `GameWorld/Effects` with simple particles (e.g. death, hit).
2. Add basic AnimatedSprite2D for soldier/enemy if sprite sheets exist.
3. Pause menu: PauseButton in HUD, pause overlay, resume/quit.

### 4.3 Content (Medium impact)

1. Additional soldier types via new soldier_*.tres files.
2. Additional enemy variants or visual differentiation.
3. Difficulty options (e.g. easy/normal/hard affecting spawn rate or tower health).

### 4.4 Monetization (Optional)

1. Ads integration (rewarded for coins, interstitial on game over).
2. IAP for `ads_removed` and premium soldiers (`is_premium`).

### 4.5 Quality of life

1. Tutorial overlay for first run.
2. Confirm dialog on quit from gameplay.
3. Haptic feedback on spawn/combat (mobile).
