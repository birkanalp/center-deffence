extends Node2D

## Handles touch input with soldier type selection.
## Works like a joystick: press anywhere, drag in the direction you want.
## Hold to cycle through unlocked soldier types via radial timer.

const SoldierData = preload("res://scripts/data/soldier_data.gd")

signal direction_confirmed(direction: Vector2, soldier_type: int)

@onready var direction_arrow: Sprite2D = $DirectionArrow

var touch_start_position: Vector2 = Vector2.ZERO
var touch_current_position: Vector2 = Vector2.ZERO
var is_touching: bool = false
var tower_center: Vector2 = Vector2.ZERO

# Soldier selection
var current_soldier_type: int = 0
var hold_time: float = 0.0
const CYCLE_DURATION: float = 1.2  # seconds to hold before cycling to next type
const MIN_SWIPE_DISTANCE: float = 30.0

func _get_unlocked() -> Array:
	return SoldierRegistry.get_unlocked()

func _ready() -> void:
	direction_arrow.visible = false
	tower_center = get_viewport_rect().size / 2.0

func _process(delta: float) -> void:
	if is_touching:
		hold_time += delta
		# Check if we should cycle to next type
		var num_types: int = _get_unlocked().size()
		if hold_time >= CYCLE_DURATION:
			hold_time -= CYCLE_DURATION
			current_soldier_type = (current_soldier_type + 1) % num_types
		queue_redraw()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		_handle_touch(event)
	elif event is InputEventScreenDrag:
		_handle_drag(event)

func _handle_touch(event: InputEventScreenTouch) -> void:
	if event.pressed:
		touch_start_position = event.position
		touch_current_position = event.position
		is_touching = true
		hold_time = 0.0
		current_soldier_type = 0
		direction_arrow.visible = true
		direction_arrow.global_position = tower_center
		queue_redraw()
	else:
		is_touching = false
		direction_arrow.visible = false
		queue_redraw()

		touch_current_position = event.position
		# Joystick: direction is from where you pressed to where you released
		var direction: Vector2 = touch_current_position - touch_start_position
		if direction.length() > 10.0:
			direction_confirmed.emit(direction.normalized(), current_soldier_type)

func _handle_drag(event: InputEventScreenDrag) -> void:
	if is_touching:
		touch_current_position = event.position
		# Joystick: direction is from where you pressed to where you drag
		var current_direction: Vector2 = event.position - touch_start_position
		if current_direction.length() > 10.0:
			direction_arrow.visible = true
			direction_arrow.rotation = current_direction.angle()
			direction_arrow.global_position = tower_center + current_direction.normalized() * 100.0

func _draw() -> void:
	if not is_touching:
		return

	var unlocked: Array = _get_unlocked()
	if unlocked.is_empty():
		return
	var current_data: SoldierData = unlocked[current_soldier_type]
	var color: Color = current_data.color
	var circle_pos: Vector2 = touch_start_position
	var radius: float = 55.0

	# Outer ring background (dark)
	draw_arc(circle_pos, radius + 6, 0, TAU, 64, Color(0.15, 0.15, 0.2, 0.8), 12.0, true)

	# Timer arc - fills clockwise as hold_time progresses
	var progress: float = hold_time / CYCLE_DURATION
	var sweep_angle: float = progress * TAU
	var start_angle: float = -PI / 2.0  # start from top
	if sweep_angle > 0.01:
		draw_arc(circle_pos, radius + 6, start_angle, start_angle + sweep_angle, 64, Color(1, 1, 1, 0.9), 12.0, true)

	# Inner portrait background
	draw_circle(circle_pos, radius, Color(0.08, 0.10, 0.14, 0.95))
	draw_circle(circle_pos, radius - 6.0, Color(color.r, color.g, color.b, 0.25))

	# Front portrait for the selected character
	if current_data.icon != null:
		var icon_rect: Rect2 = _fit_texture_rect(current_data.icon, circle_pos, Vector2(radius * 1.2, radius * 1.2))
		draw_texture_rect(current_data.icon, icon_rect, false)
	else:
		draw_circle(circle_pos, radius * 0.5, Color(color.r + 0.15, color.g + 0.15, color.b + 0.15, 1.0))

	# Draw type indicator dots at the bottom
	var num_types: int = unlocked.size()
	var dot_y: float = circle_pos.y + radius + 30.0
	for i in num_types:
		var dot_x: float = circle_pos.x + (i - (num_types - 1) / 2.0) * 24.0
		var dot_color: Color = unlocked[i].color
		if i == current_soldier_type:
			draw_circle(Vector2(dot_x, dot_y), 8.0, dot_color)
		else:
			draw_circle(Vector2(dot_x, dot_y), 5.0, Color(dot_color.r, dot_color.g, dot_color.b, 0.4))

	# Draw cost text below dots
	var cost: int = current_data.cost
	var can_afford: bool = GameManager.coins >= cost
	var cost_color: Color = Color(0.3, 1.0, 0.3) if can_afford else Color(1.0, 0.3, 0.3)
	var cost_pos: Vector2 = Vector2(circle_pos.x, dot_y + 24.0)
	var font: Font = ThemeDB.fallback_font
	var cost_text: String = "%d" % cost
	var text_size: Vector2 = font.get_string_size(cost_text, HORIZONTAL_ALIGNMENT_CENTER, -1, 20)
	draw_string(font, Vector2(cost_pos.x - text_size.x / 2.0, cost_pos.y), cost_text, HORIZONTAL_ALIGNMENT_LEFT, -1, 20, cost_color)

	# Draw direction line from press point to current drag point
	var dir: Vector2 = touch_current_position - touch_start_position
	if dir.length() > 10.0:
		var line_end: Vector2 = circle_pos + dir.normalized() * 120.0
		draw_line(circle_pos, line_end, Color(1, 1, 1, 0.3), 3.0, true)

func _fit_texture_rect(texture: Texture2D, center: Vector2, max_size: Vector2) -> Rect2:
	var texture_size: Vector2 = texture.get_size()
	if texture_size.x <= 0.0 or texture_size.y <= 0.0:
		return Rect2(center, Vector2.ZERO)

	var scale_factor: float = minf(max_size.x / texture_size.x, max_size.y / texture_size.y)
	var draw_size: Vector2 = texture_size * scale_factor
	return Rect2(center - draw_size * 0.5, draw_size)
