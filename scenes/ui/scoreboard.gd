extends Control

## Scoreboard screen — shows top 10 local high scores for Classic and Survival.

var current_tab: int = 0  # 0 = classic, 1 = survival

func _ready() -> void:
	$VBoxContainer/TabContainer/ClassicTab.pressed.connect(_on_classic_tab)
	$VBoxContainer/TabContainer/SurvivalTab.pressed.connect(_on_survival_tab)
	$VBoxContainer/BackButton.pressed.connect(_on_back_pressed)
	_show_scores("classic")
	_update_tab_highlight()

func _on_classic_tab() -> void:
	current_tab = 0
	_show_scores("classic")
	_update_tab_highlight()

func _on_survival_tab() -> void:
	current_tab = 1
	_show_scores("survival")
	_update_tab_highlight()

func _update_tab_highlight() -> void:
	var active_color: Color = Color(1.0, 0.84, 0.0)
	var inactive_color: Color = Color(0.5, 0.5, 0.6)
	if current_tab == 0:
		$VBoxContainer/TabContainer/ClassicTab.add_theme_color_override("font_color", active_color)
		$VBoxContainer/TabContainer/SurvivalTab.add_theme_color_override("font_color", inactive_color)
	else:
		$VBoxContainer/TabContainer/ClassicTab.add_theme_color_override("font_color", inactive_color)
		$VBoxContainer/TabContainer/SurvivalTab.add_theme_color_override("font_color", active_color)

func _show_scores(mode: String) -> void:
	var container: VBoxContainer = $VBoxContainer/ScoresScroll/ScoresContainer
	# Clear existing score rows
	for child in container.get_children():
		child.queue_free()

	var scores: Array = SaveManager.get_value("scores", mode, [])
	if not scores is Array:
		scores = []

	if scores.is_empty():
		var empty_label: Label = Label.new()
		empty_label.text = "No scores yet"
		empty_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		empty_label.add_theme_font_size_override("font_size", 24)
		empty_label.add_theme_color_override("font_color", Color(0.58, 0.68, 0.80, 1))
		container.add_child(empty_label)
		return

	# Scores should already be sorted desc, but ensure it
	scores.sort_custom(func(a, b): return a.get("score", 0) > b.get("score", 0))

	var rank: int = 1
	for entry in scores:
		if rank > 10:
			break
		var score_label: Label = Label.new()
		var score_val: int = int(entry.get("score", 0))
		var kills_val: int = int(entry.get("kills", 0))
		var waves_val: int = int(entry.get("waves", 0))
		var date_val: String = str(entry.get("date", ""))

		# Format date shorter (e.g. "Mar 09" from "2026-03-09")
		var date_display: String = _format_date(date_val)

		score_label.text = "#%d   %d pts   %d kills   W%d   %s" % [rank, score_val, kills_val, waves_val, date_display]
		score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		score_label.add_theme_font_size_override("font_size", 22)

		# Gold for top 3, silver for rest
		if rank <= 3:
			score_label.add_theme_color_override("font_color", Color(1.0, 0.84, 0.0))
		else:
			score_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.8))

		var row := PanelContainer.new()
		var row_style := StyleBoxFlat.new()
		row_style.bg_color = Color(0.10, 0.14, 0.22, 1)
		row_style.corner_radius_top_left = 8
		row_style.corner_radius_top_right = 8
		row_style.corner_radius_bottom_right = 8
		row_style.corner_radius_bottom_left = 8
		row_style.border_width_left = 1
		row_style.border_width_top = 1
		row_style.border_width_right = 1
		row_style.border_width_bottom = 1
		row_style.border_color = Color(0.22, 0.30, 0.45, 1)
		row_style.content_margin_left = 16
		row_style.content_margin_right = 16
		row_style.content_margin_top = 10
		row_style.content_margin_bottom = 10
		row.add_theme_stylebox_override("panel", row_style)
		container.add_child(row)
		row.add_child(score_label)
		rank += 1

func _format_date(date_str: String) -> String:
	if date_str.length() < 10:
		return date_str
	var parts: PackedStringArray = date_str.split("-")
	if parts.size() < 3:
		return date_str
	var month_names: Array = ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
	var month_idx: int = int(parts[1])
	if month_idx < 1 or month_idx > 12:
		return date_str
	return "%s %s" % [month_names[month_idx], parts[2]]

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
