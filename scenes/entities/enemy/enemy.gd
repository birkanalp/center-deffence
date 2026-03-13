extends CharacterBody2D

## Enemy entity that spawns from screen edges and walks toward the tower.

enum State { WALKING, FIGHTING, DYING }

@export var move_speed: float = 150.0
@export var max_health: int = 20
@export var attack_damage: int = 8
@export var attack_cooldown: float = 1.0
@export var damage_to_tower: int = 10
var coin_reward: int = 10

const TOWER_ATTACK_RANGE: float = 90.0

var current_state: State = State.WALKING
var current_health: int
var target_position: Vector2 = Vector2.ZERO
var current_opponent: CharacterBody2D = null
var current_tower = null

@onready var combat_timer: Timer = $CombatTimer
@onready var sprite: Sprite2D = $Sprite2D
@onready var health_bar_bg: Sprite2D = $HealthBarBG
@onready var health_bar_fill: Sprite2D = $HealthBarFill

func _ready() -> void:
	current_health = max_health
	add_to_group("enemies")

	combat_timer.wait_time = attack_cooldown
	combat_timer.timeout.connect(_on_combat_timer_timeout)
	_update_health_bar()

func _physics_process(_delta: float) -> void:
	match current_state:
		State.WALKING:
			_process_walking()
		State.FIGHTING:
			_process_fighting()
		State.DYING:
			pass

func _process_walking() -> void:
	if global_position.distance_to(target_position) < TOWER_ATTACK_RANGE:
		current_tower = get_tree().get_first_node_in_group("tower")
		if current_tower:
			current_state = State.FIGHTING
			combat_timer.start()
		return
	var direction: Vector2 = (target_position - global_position).normalized()
	velocity = direction * move_speed
	move_and_slide()

func _process_fighting() -> void:
	if is_instance_valid(current_opponent) and not current_opponent.is_queued_for_deletion():
		velocity = Vector2.ZERO
		return
	current_opponent = null
	# Stay and attack the tower if we reached it
	if is_instance_valid(current_tower):
		velocity = Vector2.ZERO
		return
	current_state = State.WALKING
	combat_timer.stop()

func engage_combat(soldier: CharacterBody2D) -> void:
	if current_state == State.DYING:
		return
	current_opponent = soldier
	current_state = State.FIGHTING
	combat_timer.start()

func disengage_combat() -> void:
	current_opponent = null
	if current_state == State.FIGHTING:
		current_state = State.WALKING
		combat_timer.stop()

func _on_combat_timer_timeout() -> void:
	if current_state != State.FIGHTING:
		return
	if is_instance_valid(current_opponent):
		current_opponent.take_damage(attack_damage)
	elif is_instance_valid(current_tower):
		current_tower.take_damage(damage_to_tower)

func take_damage(amount: int) -> void:
	current_health -= amount
	_update_health_bar()

	sprite.modulate = Color.RED
	await get_tree().create_timer(0.08).timeout
	if is_instance_valid(self) and current_state != State.DYING:
		sprite.modulate = Color.WHITE

	if current_health <= 0:
		_die()

func _update_health_bar() -> void:
	var ratio: float = clampf(float(current_health) / float(max_health), 0.0, 1.0)
	health_bar_fill.scale.x = ratio
	if ratio > 0.6:
		health_bar_fill.modulate = Color.GREEN
	elif ratio > 0.3:
		health_bar_fill.modulate = Color.YELLOW
	else:
		health_bar_fill.modulate = Color.RED

func _die() -> void:
	current_state = State.DYING
	combat_timer.stop()
	GameManager.enemies_killed += 1
	GameManager.coins += coin_reward

	var tween: Tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 0.0, 0.3)
	tween.tween_callback(queue_free)
