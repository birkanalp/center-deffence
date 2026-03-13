extends PanelContainer

## Reusable soldier card showing name, stats, color swatch, and buy/owned status.

const SoldierData = preload("res://scripts/data/soldier_data.gd")

signal buy_pressed(soldier_id: String)

var _soldier_data: SoldierData = null
var _is_unlocked: bool = false

func setup(data: SoldierData, is_unlocked: bool) -> void:
	_soldier_data = data
	_is_unlocked = is_unlocked
	_update_display()

func _update_display() -> void:
	if _soldier_data == null:
		return

	# Color swatch
	$HBox/ColorSwatch.color = _soldier_data.color

	# Name
	$HBox/Info/NameLabel.text = _soldier_data.display_name

	# Stats
	$HBox/Info/StatsLabel.text = "HP:%d  DMG:%d  SPD:%d" % [
		_soldier_data.max_health,
		_soldier_data.attack_damage,
		int(_soldier_data.move_speed),
	]

	# Description
	if _soldier_data.description != "":
		$HBox/Info/DescLabel.text = _soldier_data.description
		$HBox/Info/DescLabel.visible = true
	else:
		$HBox/Info/DescLabel.visible = false

	# Status button/label
	var action_btn: Button = $HBox/ActionButton
	action_btn.modulate = Color.WHITE
	if _is_unlocked:
		action_btn.text = "OWNED"
		action_btn.disabled = true
		action_btn.add_theme_stylebox_override("normal", _make_action_style(Color(0.16, 0.78, 0.44)))
		action_btn.add_theme_stylebox_override("disabled", _make_action_style(Color(0.12, 0.55, 0.32)))
	elif _soldier_data.is_premium:
		action_btn.text = "PREMIUM"
		action_btn.disabled = true
		action_btn.add_theme_stylebox_override("normal", _make_action_style(Color(0.62, 0.36, 0.97)))
		action_btn.add_theme_stylebox_override("disabled", _make_action_style(Color(0.45, 0.26, 0.72)))
	else:
		var price: int = _soldier_data.unlock_price
		var can_afford: bool = int(SaveManager.get_value("profile", "persistent_coins", 0)) >= price
		action_btn.text = "BUY\n%d" % price
		action_btn.disabled = not can_afford
		if can_afford:
			action_btn.add_theme_stylebox_override("normal", _make_action_style(Color(0.85, 0.62, 0.05)))
		else:
			action_btn.add_theme_stylebox_override("normal", _make_action_style(Color(0.18, 0.22, 0.30)))
		if not action_btn.pressed.is_connected(_on_buy_pressed):
			action_btn.pressed.connect(_on_buy_pressed)

func _make_action_style(bg: Color) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_width_bottom = 2
	s.border_color = bg.darkened(0.3)
	s.corner_radius_top_left = 12
	s.corner_radius_top_right = 12
	s.corner_radius_bottom_right = 12
	s.corner_radius_bottom_left = 12
	s.content_margin_left = 8
	s.content_margin_right = 8
	s.content_margin_top = 8
	s.content_margin_bottom = 8
	return s

func _on_buy_pressed() -> void:
	if _soldier_data != null and not _is_unlocked:
		buy_pressed.emit(_soldier_data.id)
