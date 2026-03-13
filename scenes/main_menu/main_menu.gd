extends Control

## Main menu scene controller.

func _ready() -> void:
	GameManager.reset_game_state()
	$VBoxContainer/ClassicButton.pressed.connect(_on_classic_pressed)
	$VBoxContainer/SurvivalButton.pressed.connect(_on_survival_pressed)
	$VBoxContainer/ScoresButton.pressed.connect(_on_scores_pressed)
	$VBoxContainer/ProfileButton.pressed.connect(_on_profile_pressed)
	$VBoxContainer/StoreButton.pressed.connect(_on_store_pressed)

	# Show persistent coins
	var persistent_coins: int = int(SaveManager.get_value("profile", "persistent_coins", 0))
	$CoinsLabel.text = "Coins: %d" % persistent_coins

func _on_classic_pressed() -> void:
	GameManager.game_mode = GameManager.MODE_CLASSIC
	get_tree().change_scene_to_file("res://scenes/gameplay/gameplay.tscn")

func _on_survival_pressed() -> void:
	GameManager.game_mode = GameManager.MODE_SURVIVAL
	get_tree().change_scene_to_file("res://scenes/gameplay/gameplay.tscn")

func _on_scores_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/scoreboard.tscn")

func _on_profile_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/profile.tscn")

func _on_store_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/soldier_store.tscn")
