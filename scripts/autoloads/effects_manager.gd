extends Node

## Spawns lightweight scene-based VFX into the active gameplay scene.

var pulse_effect_scene: PackedScene = preload("res://scenes/effects/pulse_effect.tscn")

func spawn_pulse(world_position: Vector2, color: Color, max_radius: float = 80.0, duration: float = 0.3) -> void:
	var container := _get_effects_container()
	if container == null:
		return

	var effect = pulse_effect_scene.instantiate()
	effect.global_position = world_position
	effect.modulate = color
	effect.max_radius = max_radius
	effect.duration = duration
	container.add_child(effect)

func _get_effects_container() -> Node:
	var current_scene := get_tree().current_scene
	if current_scene == null:
		return null
	return current_scene.get_node_or_null("GameWorld/Effects")
