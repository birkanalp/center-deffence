extends Node

## Manages wave-based enemy spawning from screen edges.

signal wave_started(wave_number: int)

var enemy_scene: PackedScene = preload("res://scenes/entities/enemy/enemy.tscn")
var enemies_container: Node2D
var tower_position: Vector2

var current_wave: int = 0
var spawning_active: bool = false
var enemies_to_spawn_this_wave: int = 0
var enemies_spawned_this_wave: int = 0

const INITIAL_ENEMIES_PER_WAVE: int = 3
const ENEMIES_INCREMENT_PER_WAVE: int = 2
const INITIAL_SPAWN_INTERVAL: float = 1.5
const MIN_SPAWN_INTERVAL: float = 0.4
const WAVE_INTERVAL: float = 8.0
const SPAWN_INTERVAL_DECREASE: float = 0.1

const FAST_ENEMY_WAVE_START: int = 3
const TANK_ENEMY_WAVE_START: int = 5

@onready var spawn_timer: Timer = $SpawnTimer
@onready var wave_timer: Timer = $WaveTimer

func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	wave_timer.timeout.connect(_on_wave_timer_timeout)
	tower_position = get_viewport().get_visible_rect().size / 2.0

func start_spawning(container: Node2D) -> void:
	enemies_container = container
	spawning_active = true
	_start_next_wave()

func stop_spawning() -> void:
	spawning_active = false
	spawn_timer.stop()
	wave_timer.stop()

func _start_next_wave() -> void:
	current_wave += 1
	GameManager.waves_reached = current_wave
	enemies_to_spawn_this_wave = INITIAL_ENEMIES_PER_WAVE + (current_wave - 1) * ENEMIES_INCREMENT_PER_WAVE
	enemies_spawned_this_wave = 0
	wave_started.emit(current_wave)

	var interval: float = max(MIN_SPAWN_INTERVAL, INITIAL_SPAWN_INTERVAL - (current_wave - 1) * SPAWN_INTERVAL_DECREASE)
	spawn_timer.wait_time = interval
	spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	if not spawning_active:
		return

	if enemies_spawned_this_wave < enemies_to_spawn_this_wave:
		_spawn_single_enemy()
		enemies_spawned_this_wave += 1
	else:
		spawn_timer.stop()
		wave_timer.wait_time = WAVE_INTERVAL
		wave_timer.start()

func _on_wave_timer_timeout() -> void:
	if spawning_active:
		_start_next_wave()

func _spawn_single_enemy() -> void:
	var enemy_instance = enemy_scene.instantiate()
	enemy_instance.global_position = _get_random_edge_position()
	enemy_instance.target_position = tower_position
	_configure_enemy_type(enemy_instance)
	enemies_container.add_child(enemy_instance)

func _get_random_edge_position() -> Vector2:
	var viewport: Vector2 = get_viewport().get_visible_rect().size
	var margin: float = 80.0
	var edge: int = randi() % 4
	var pos: Vector2

	match edge:
		0: pos = Vector2(randf_range(0, viewport.x), -margin)
		1: pos = Vector2(viewport.x + margin, randf_range(0, viewport.y))
		2: pos = Vector2(randf_range(0, viewport.x), viewport.y + margin)
		3: pos = Vector2(-margin, randf_range(0, viewport.y))

	return pos

func _configure_enemy_type(enemy) -> void:
	var roll: float = randf()

	if current_wave >= TANK_ENEMY_WAVE_START and roll < 0.15:
		enemy.move_speed = 80.0
		enemy.max_health = 60
		enemy.current_health = 60
		enemy.attack_damage = 15
		enemy.damage_to_tower = 25
		enemy.get_node("Sprite2D").modulate = Color(0.6, 0.2, 0.2)
		enemy.coin_reward = 15
	elif current_wave >= FAST_ENEMY_WAVE_START and roll < 0.4:
		enemy.move_speed = 280.0
		enemy.max_health = 12
		enemy.current_health = 12
		enemy.attack_damage = 5
		enemy.damage_to_tower = 5
		enemy.get_node("Sprite2D").modulate = Color(0.2, 0.8, 0.2)
		enemy.coin_reward = 8

	# Per-wave stat scaling: enemies get tougher each wave
	# After wave 5, +5% health and +3% damage per wave
	if current_wave > 5:
		var waves_past: int = current_wave - 5
		var health_mult: float = 1.0 + waves_past * 0.05
		var damage_mult: float = 1.0 + waves_past * 0.03
		enemy.max_health = int(enemy.max_health * health_mult)
		enemy.current_health = enemy.max_health
		enemy.attack_damage = int(enemy.attack_damage * damage_mult)
		enemy.damage_to_tower = int(enemy.damage_to_tower * damage_mult)
