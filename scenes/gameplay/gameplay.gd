extends Node2D

## Main gameplay orchestrator.

const SoldierData = preload("res://scripts/data/soldier_data.gd")
const GAME_DURATION: float = 180.0
const PASSIVE_INCOME_RATE: float = 2.0  # coins per second

var time_remaining: float = GAME_DURATION
var time_elapsed: float = 0.0
var game_active: bool = false
var income_accumulator: float = 0.0
var is_survival: bool = false

var soldier_scene: PackedScene = preload("res://scenes/entities/soldier/soldier.tscn")

@onready var tower: StaticBody2D = $GameWorld/Tower
@onready var soldiers_container: Node2D = $GameWorld/Soldiers
@onready var enemies_container: Node2D = $GameWorld/Enemies
@onready var touch_handler: Node2D = $TouchInputHandler
@onready var enemy_spawner: Node = $EnemySpawner
@onready var hud: CanvasLayer = $HUD

func _ready() -> void:
	game_active = true
	is_survival = GameManager.game_mode == GameManager.MODE_SURVIVAL
	time_remaining = GAME_DURATION
	time_elapsed = 0.0
	GameManager.coins = GameManager.STARTING_COINS

	var viewport_size: Vector2 = get_viewport_rect().size
	tower.global_position = viewport_size / 2.0

	touch_handler.direction_confirmed.connect(_on_direction_confirmed)
	tower.tower_destroyed.connect(_on_tower_destroyed)
	tower.health_changed.connect(_on_tower_health_changed)
	enemy_spawner.wave_started.connect(_on_wave_started)
	enemy_spawner.start_spawning(enemies_container)

func _process(delta: float) -> void:
	if not game_active:
		return

	time_elapsed += delta

	# Passive coin income
	income_accumulator += delta * PASSIVE_INCOME_RATE
	if income_accumulator >= 1.0:
		var coins_to_add: int = int(income_accumulator)
		GameManager.coins += coins_to_add
		income_accumulator -= coins_to_add

	if is_survival:
		GameManager.time_survived = time_elapsed
		_update_hud()
	else:
		time_remaining -= delta
		GameManager.time_survived = GAME_DURATION - time_remaining
		_update_hud()
		if time_remaining <= 0.0:
			_on_time_up()

func _update_hud() -> void:
	if is_survival:
		var minutes: int = int(time_elapsed) / 60
		var seconds: int = int(time_elapsed) % 60
		hud.get_node("TimerLabel").text = "%d:%02d" % [minutes, seconds]
		hud.get_node("TimerLabel").add_theme_color_override("font_color", Color.WHITE)
	else:
		var minutes: int = int(time_remaining) / 60
		var seconds: int = int(time_remaining) % 60
		hud.get_node("TimerLabel").text = "%d:%02d" % [minutes, seconds]
		if time_remaining < 30.0:
			if fmod(time_remaining, 1.0) < 0.5:
				hud.get_node("TimerLabel").add_theme_color_override("font_color", Color.RED)
			else:
				hud.get_node("TimerLabel").add_theme_color_override("font_color", Color.WHITE)

	hud.get_node("KillsLabel").text = "Kills: %d" % GameManager.enemies_killed
	hud.get_node("CoinsLabel").text = "Coins: %d" % GameManager.coins

func _on_direction_confirmed(direction: Vector2, soldier_type: int) -> void:
	if not game_active:
		return
	var unlocked: Array = SoldierRegistry.get_unlocked()
	if soldier_type < 0 or soldier_type >= unlocked.size():
		return
	var data: SoldierData = unlocked[soldier_type]
	if GameManager.coins < data.cost:
		return
	GameManager.coins -= data.cost
	_spawn_soldier(direction, data)

func _spawn_soldier(direction: Vector2, data: SoldierData = null) -> void:
	var soldier_instance = soldier_scene.instantiate()
	if data:
		soldier_instance.configure_from_data(data)
	else:
		soldier_instance.configure_type(0)
	soldier_instance.global_position = tower.global_position
	soldier_instance.move_direction = direction.normalized()
	soldiers_container.add_child(soldier_instance)

func _on_tower_destroyed() -> void:
	game_active = false
	enemy_spawner.stop_spawning()
	GameManager.last_result_victory = false
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/game_over/game_over.tscn")

func _on_time_up() -> void:
	game_active = false
	enemy_spawner.stop_spawning()
	GameManager.last_result_victory = true
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/game_over/game_over.tscn")

func _on_tower_health_changed(current_hp: int, max_hp: int) -> void:
	hud.get_node("TowerHealthLabel").text = "Tower: %d/%d" % [current_hp, max_hp]

func _on_wave_started(wave_number: int) -> void:
	hud.get_node("WaveLabel").text = "Wave %d" % wave_number
