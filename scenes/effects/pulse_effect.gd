extends Node2D

## Expanding ring pulse used for low-cost gameplay feedback.

@export var duration: float = 0.3
@export var max_radius: float = 80.0
@export var start_radius: float = 10.0
@export var line_width: float = 10.0

var _elapsed: float = 0.0

func _process(delta: float) -> void:
	_elapsed += delta
	if _elapsed >= duration:
		queue_free()
		return
	queue_redraw()

func _draw() -> void:
	var progress := clampf(_elapsed / duration, 0.0, 1.0)
	var radius := lerpf(start_radius, max_radius, progress)
	var alpha := 1.0 - progress
	var color := Color(modulate.r, modulate.g, modulate.b, alpha)
	draw_arc(Vector2.ZERO, radius, 0.0, TAU, 48, color, line_width * (1.0 - progress * 0.6), true)
