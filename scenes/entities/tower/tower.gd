extends StaticBody2D

## Central tower that the player must defend.

signal tower_destroyed
signal health_changed(current_hp: int, max_hp: int)

@export var max_health: int = 100
var current_health: int

@onready var sprite: Sprite2D = $Sprite2D
@onready var health_bar_bg: Sprite2D = $HealthBarBG
@onready var health_bar_fill: Sprite2D = $HealthBarFill

func _ready() -> void:
	current_health = max_health
	add_to_group("tower")
	_update_health_bar()

func take_damage(amount: int) -> void:
	current_health = max(0, current_health - amount)
	AudioManager.play_sfx("tower_hit")
	health_changed.emit(current_health, max_health)
	_update_health_bar()
	_flash_damage()

	if current_health <= 0:
		tower_destroyed.emit()

func _update_health_bar() -> void:
	var ratio: float = float(current_health) / float(max_health)
	health_bar_fill.scale.x = ratio
	if ratio > 0.6:
		health_bar_fill.modulate = Color.GREEN
	elif ratio > 0.3:
		health_bar_fill.modulate = Color.YELLOW
	else:
		health_bar_fill.modulate = Color.RED

func _flash_damage() -> void:
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	if is_instance_valid(self):
		sprite.modulate = Color.WHITE
