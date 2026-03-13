extends CharacterBody2D

## Soldier entity spawned by the tower.
## Walks in a given direction, stops at max range or when meeting an enemy.
## Stats are loaded from SoldierData resources via SoldierRegistry.

const SoldierData = preload("res://scripts/data/soldier_data.gd")

enum State { WALKING, IDLE, FIGHTING, DYING }
enum SoldierType { WARRIOR, TANK, RANGER }

const FACING_FRONT := "front"
const FACING_BACK := "back"
const FACING_LEFT := "left"
const FACING_RIGHT := "right"

static var _sprite_frames_cache: Dictionary = {}

# Stats configured by configure_from_data() or configure_type()
var move_speed: float = 300.0
var max_range: float = 600.0
var max_health: int = 30
var attack_damage: int = 10
var attack_cooldown: float = 0.8
var soldier_type: int = SoldierType.WARRIOR
var soldier_data: SoldierData = null

var move_direction: Vector2 = Vector2.ZERO
var current_state: State = State.WALKING
var current_health: int
var spawn_position: Vector2
var current_target: CharacterBody2D = null
var lifetime: float = 30.0
var time_alive: float = 0.0

@onready var detection_area: Area2D = $DetectionArea
@onready var combat_timer: Timer = $CombatTimer
@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var health_bar_bg: Sprite2D = $HealthBarBG
@onready var health_bar_fill: Sprite2D = $HealthBarFill

var _current_facing: String = FACING_FRONT
var _current_animation: String = ""

func configure_from_data(data: SoldierData) -> void:
	soldier_data = data
	move_speed = data.move_speed
	max_range = data.max_range
	max_health = data.max_health
	attack_damage = data.attack_damage
	attack_cooldown = data.attack_cooldown
	lifetime = data.lifetime

func configure_type(type_index: int) -> void:
	# Backward-compat wrapper: looks up SoldierRegistry by index
	soldier_type = type_index
	var unlocked: Array = SoldierRegistry.get_unlocked()
	if type_index >= 0 and type_index < unlocked.size():
		configure_from_data(unlocked[type_index])
	else:
		configure_from_data(unlocked[0])

func _ready() -> void:
	current_health = max_health
	spawn_position = global_position
	add_to_group("soldiers")

	detection_area.body_entered.connect(_on_detection_body_entered)
	detection_area.body_exited.connect(_on_detection_body_exited)
	combat_timer.wait_time = attack_cooldown
	combat_timer.timeout.connect(_on_combat_timer_timeout)

	_apply_visuals()
	_update_health_bar()

func _physics_process(delta: float) -> void:
	if current_state == State.DYING:
		return

	# Lifetime check
	time_alive += delta
	if time_alive >= lifetime:
		_die()
		return

	match current_state:
		State.WALKING:
			_process_walking()
		State.IDLE:
			_process_idle()
		State.FIGHTING:
			_process_fighting()

func _process_walking() -> void:
	var distance_from_spawn: float = global_position.distance_to(spawn_position)
	if distance_from_spawn >= max_range:
		current_state = State.IDLE
		velocity = Vector2.ZERO
		_update_animation(move_direction)
		return

	_update_animation(move_direction)
	velocity = move_direction * move_speed
	move_and_slide()

func _process_idle() -> void:
	velocity = Vector2.ZERO
	_update_animation(move_direction)

func _process_fighting() -> void:
	if not is_instance_valid(current_target) or current_target.is_queued_for_deletion():
		current_target = _find_nearest_enemy()
		if current_target == null:
			current_state = State.WALKING
			combat_timer.stop()
		return
	_update_animation(current_target.global_position - global_position)
	velocity = Vector2.ZERO

func _on_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") and current_state != State.DYING:
		if current_state != State.FIGHTING:
			current_target = body
			current_state = State.FIGHTING
			combat_timer.start()
			if body.has_method("engage_combat"):
				body.engage_combat(self)

func _on_detection_body_exited(body: Node2D) -> void:
	if body == current_target:
		current_target = _find_nearest_enemy()
		if current_target == null and current_state == State.FIGHTING:
			current_state = State.WALKING
			combat_timer.stop()

func _on_combat_timer_timeout() -> void:
	if current_state == State.FIGHTING and is_instance_valid(current_target):
		current_target.take_damage(attack_damage)

func _find_nearest_enemy() -> CharacterBody2D:
	var bodies: Array = detection_area.get_overlapping_bodies()
	var nearest: CharacterBody2D = null
	var nearest_dist: float = INF
	for body in bodies:
		if body.is_in_group("enemies"):
			var dist: float = global_position.distance_to(body.global_position)
			if dist < nearest_dist:
				nearest_dist = dist
				nearest = body
	return nearest

func take_damage(amount: int) -> void:
	current_health -= amount
	_update_health_bar()
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
	detection_area.monitoring = false
	collision_layer = 0
	collision_mask = 0
	_update_animation(move_direction)
	var tween: Tween = create_tween()
	tween.tween_interval(_get_death_duration())
	tween.tween_property(sprite, "modulate:a", 0.0, 0.2)
	tween.tween_callback(queue_free)

func _apply_visuals() -> void:
	if soldier_data == null:
		sprite.modulate = Color.WHITE
		sprite.rotation = move_direction.angle()
		return

	if _uses_animated_frames():
		sprite.modulate = Color.WHITE
		sprite.scale = soldier_data.sprite_scale
		sprite.rotation = 0.0
		sprite.sprite_frames = _get_sprite_frames_for_data()
		_update_animation(move_direction if move_direction != Vector2.ZERO else Vector2.DOWN)
	elif _has_directional_textures():
		sprite.modulate = Color.WHITE
		sprite.scale = soldier_data.sprite_scale
		sprite.rotation = 0.0
		_update_static_sprite_facing(move_direction if move_direction != Vector2.ZERO else Vector2.DOWN)
	else:
		sprite.modulate = soldier_data.color
		sprite.rotation = move_direction.angle()

	_update_health_bar_position()

func _uses_animated_frames() -> bool:
	return soldier_data != null and soldier_data.animation_root != ""

func _has_directional_textures() -> bool:
	return (
		soldier_data != null
		and soldier_data.front_texture != null
		and soldier_data.back_texture != null
		and soldier_data.left_texture != null
		and soldier_data.right_texture != null
	)

func _update_animation(direction: Vector2) -> void:
	if direction.is_zero_approx():
		return

	if _uses_animated_frames():
		_current_facing = _resolve_facing(direction)
		var animation_name: String = _get_animation_name()
		if animation_name != "" and animation_name != _current_animation:
			_current_animation = animation_name
			sprite.play(animation_name)
			_update_health_bar_position()
		return

	_update_static_sprite_facing(direction)

func _update_static_sprite_facing(direction: Vector2) -> void:
	if direction.is_zero_approx():
		return

	if not _has_directional_textures():
		sprite.rotation = direction.angle()
		return

	var next_texture: Texture2D = _get_directional_texture(direction)
	if next_texture != null:
		sprite.sprite_frames = null
		sprite.stop()
		sprite.frame = 0
		sprite.sprite_frames = SpriteFrames.new()
		sprite.sprite_frames.add_animation("static")
		sprite.sprite_frames.add_frame("static", next_texture)
		sprite.play("static")
		sprite.rotation = 0.0
		_update_health_bar_position()

func _get_directional_texture(direction: Vector2) -> Texture2D:
	if soldier_data == null:
		return null

	if absf(direction.x) > absf(direction.y):
		return soldier_data.right_texture if direction.x >= 0.0 else soldier_data.left_texture

	return soldier_data.front_texture if direction.y >= 0.0 else soldier_data.back_texture

func _update_health_bar_position() -> void:
	var current_texture: Texture2D = _get_current_frame_texture()
	if current_texture == null:
		return

	var texture_height: float = float(current_texture.get_height()) * absf(sprite.scale.y)
	var y_offset: float = -maxf(30.0, texture_height * 0.55)
	var bar_position := Vector2(0.0, y_offset)
	health_bar_bg.position = bar_position
	health_bar_fill.position = bar_position

func _resolve_facing(direction: Vector2) -> String:
	if absf(direction.x) > absf(direction.y):
		return FACING_RIGHT if direction.x >= 0.0 else FACING_LEFT
	return FACING_FRONT if direction.y >= 0.0 else FACING_BACK

func _get_animation_name() -> String:
	match current_state:
		State.WALKING:
			return "%s_walk" % _current_facing
		State.IDLE:
			return "%s_idle" % _current_facing
		State.FIGHTING:
			return "%s_attack" % _current_facing
		State.DYING:
			return "dying"
	return ""

func _get_current_frame_texture() -> Texture2D:
	if sprite.sprite_frames == null or _current_animation == "":
		return null
	if not sprite.sprite_frames.has_animation(_current_animation):
		return null
	if sprite.sprite_frames.get_frame_count(_current_animation) == 0:
		return null
	return sprite.sprite_frames.get_frame_texture(_current_animation, mini(sprite.frame, sprite.sprite_frames.get_frame_count(_current_animation) - 1))

func _get_death_duration() -> float:
	if sprite.sprite_frames == null or not sprite.sprite_frames.has_animation("dying"):
		return 0.35
	var frame_count: int = sprite.sprite_frames.get_frame_count("dying")
	var fps: float = sprite.sprite_frames.get_animation_speed("dying")
	if frame_count <= 0 or fps <= 0.0:
		return 0.35
	return float(frame_count) / fps

func _get_sprite_frames_for_data() -> SpriteFrames:
	if _sprite_frames_cache.has(soldier_data.animation_root):
		return _sprite_frames_cache[soldier_data.animation_root]

	var frames := SpriteFrames.new()
	_add_animation_frames(frames, "front_idle", soldier_data.animation_root, "Front - Idle", 10.0, true)
	_add_animation_frames(frames, "back_idle", soldier_data.animation_root, "Back - Idle", 10.0, true)
	_add_animation_frames(frames, "left_idle", soldier_data.animation_root, "Left - Idle", 10.0, true)
	_add_animation_frames(frames, "right_idle", soldier_data.animation_root, "Right - Idle", 10.0, true)
	_add_animation_frames(frames, "front_walk", soldier_data.animation_root, "Front - Walking", 16.0, true)
	_add_animation_frames(frames, "back_walk", soldier_data.animation_root, "Back - Walking", 16.0, true)
	_add_animation_frames(frames, "left_walk", soldier_data.animation_root, "Left - Walking", 16.0, true)
	_add_animation_frames(frames, "right_walk", soldier_data.animation_root, "Right - Walking", 16.0, true)
	_add_animation_frames(frames, "front_attack", soldier_data.animation_root, "Front - Attacking", 14.0, true)
	_add_animation_frames(frames, "back_attack", soldier_data.animation_root, "Back - Attacking", 14.0, true)
	_add_animation_frames(frames, "left_attack", soldier_data.animation_root, "Left - Attacking", 14.0, true)
	_add_animation_frames(frames, "right_attack", soldier_data.animation_root, "Right - Attacking", 14.0, true)
	_add_animation_frames(frames, "dying", soldier_data.animation_root, "Dying", 12.0, false)
	_sprite_frames_cache[soldier_data.animation_root] = frames
	return frames

func _add_animation_frames(frames: SpriteFrames, animation_name: String, root_path: String, folder_name: String, fps: float, loop: bool) -> void:
	var folder_path := "%s/%s" % [root_path, folder_name]
	var dir := DirAccess.open(folder_path)
	if dir == null:
		return

	var file_names: Array[String] = []
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".png"):
			file_names.append(file_name)
		file_name = dir.get_next()
	dir.list_dir_end()
	file_names.sort()

	if file_names.is_empty():
		return

	frames.add_animation(animation_name)
	frames.set_animation_speed(animation_name, fps)
	frames.set_animation_loop(animation_name, loop)

	for frame_file in file_names:
		var image := Image.new()
		if image.load("%s/%s" % [folder_path, frame_file]) != OK:
			continue
		var texture := ImageTexture.create_from_image(image)
		frames.add_frame(animation_name, texture)
