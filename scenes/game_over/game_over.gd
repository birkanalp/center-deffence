extends Control

## Game over screen displaying results with score and coins earned.

var current_mode: int = 0

func _ready() -> void:
	current_mode = GameManager.game_mode
	$VBoxContainer/PlayAgainButton.pressed.connect(_on_play_again)
	$VBoxContainer/MenuButton.pressed.connect(_on_menu)

	# Record result and get coins earned
	GameManager.record_game_result()

	if current_mode == GameManager.MODE_SURVIVAL:
		# Survival: no victory, show how far they got
		$VBoxContainer/ResultLabel.text = "GAME OVER"
		$VBoxContainer/ResultLabel.add_theme_color_override("font_color", Color(1.0, 0.5, 0.2))
		$VBoxContainer/StatsLabel.text = "Waves Survived: %d\nEnemies Killed: %d\nTime Survived: %s" % [
			GameManager.waves_reached,
			GameManager.enemies_killed,
			_format_time(GameManager.time_survived)
		]
	else:
		# Classic mode
		if GameManager.last_result_victory:
			$VBoxContainer/ResultLabel.text = "VICTORY!"
			$VBoxContainer/ResultLabel.add_theme_color_override("font_color", Color(1.0, 0.84, 0.0))
		else:
			$VBoxContainer/ResultLabel.text = "DEFEATED!"
			$VBoxContainer/ResultLabel.add_theme_color_override("font_color", Color.RED)

		$VBoxContainer/StatsLabel.text = "Enemies Killed: %d\nWaves Survived: %d\nTime: %s" % [
			GameManager.enemies_killed,
			GameManager.waves_reached,
			_format_time(GameManager.time_survived)
		]

	# Display score and coins earned
	$VBoxContainer/ScoreLabel.text = "Score: %d" % GameManager.last_score
	$VBoxContainer/CoinsEarnedLabel.text = "+%d Coins" % GameManager.last_coins_earned

func _format_time(seconds: float) -> String:
	var m: int = int(seconds) / 60
	var s: int = int(seconds) % 60
	return "%d:%02d" % [m, s]

func _on_play_again() -> void:
	var mode: int = current_mode
	GameManager.reset_game_state()
	GameManager.game_mode = mode
	get_tree().change_scene_to_file("res://scenes/gameplay/gameplay.tscn")

func _on_menu() -> void:
	GameManager.reset_game_state()
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
