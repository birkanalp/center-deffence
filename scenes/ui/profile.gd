extends Control

## Player profile screen — shows editable name and lifetime stats.

@onready var save_status_label: Label = $VBoxContainer/SaveStatusLabel

var _save_status_token: int = 0

func _ready() -> void:
	AudioManager.play_menu_music()
	$VBoxContainer/BackButton.pressed.connect(_on_back_pressed)
	save_status_label.visible = false

	# Load player name
	var player_name: String = str(SaveManager.get_value("profile", "player_name", ""))
	$VBoxContainer/NameContainer/NameEdit.text = player_name
	$VBoxContainer/NameContainer/NameEdit.text_changed.connect(_on_name_changed)

	# Load stats
	_update_stats()

func _update_stats() -> void:
	var persistent_coins: int = int(SaveManager.get_value("profile", "persistent_coins", 0))
	var total_games: int = int(SaveManager.get_value("profile", "total_games_played", 0))
	var total_kills: int = int(SaveManager.get_value("profile", "total_enemies_killed", 0))
	var total_time: float = float(SaveManager.get_value("profile", "total_time_played", 0.0))

	var hours: int = int(total_time) / 3600
	var minutes: int = (int(total_time) % 3600) / 60

	$VBoxContainer/StatsLabel.text = "Coins: %d\nGames Played: %d\nTotal Kills: %d\nTotal Time: %dh %02dm" % [
		persistent_coins,
		total_games,
		total_kills,
		hours,
		minutes,
	]

func _on_name_changed(new_text: String) -> void:
	SaveManager.set_value("profile", "player_name", new_text)
	SaveManager.save_data()
	_show_save_status()

func _on_back_pressed() -> void:
	AudioManager.play_sfx("ui")
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")

func _show_save_status() -> void:
	_save_status_token += 1
	var current_token := _save_status_token
	save_status_label.text = "Profile saved"
	save_status_label.visible = true
	await get_tree().create_timer(1.0).timeout
	if current_token == _save_status_token and is_instance_valid(save_status_label):
		save_status_label.visible = false
