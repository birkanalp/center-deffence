extends Control

## Soldier store — browse and buy soldiers with persistent coins.
## Fully data-driven: shows all soldiers from SoldierRegistry.

const SoldierData = preload("res://scripts/data/soldier_data.gd")
var card_scene: PackedScene = preload("res://scenes/ui/soldier_card.tscn")

@onready var feedback_label: Label = $VBoxContainer/FeedbackLabel

func _ready() -> void:
	AudioManager.play_menu_music()
	$VBoxContainer/BackButton.pressed.connect(_on_back_pressed)
	feedback_label.visible = false
	_update_coins_label()
	_build_card_list()

func _update_coins_label() -> void:
	var persistent_coins: int = int(SaveManager.get_value("profile", "persistent_coins", 0))
	$VBoxContainer/CoinsLabel.text = "Your Coins: %d" % persistent_coins

func _build_card_list() -> void:
	var container: VBoxContainer = $VBoxContainer/ScrollContainer/CardsContainer

	# Clear existing cards
	for child in container.get_children():
		child.queue_free()

	var all_soldiers: Array = SoldierRegistry.get_all()
	var unlocked_ids: Array = SaveManager.get_value("unlocks", "soldier_ids", ["warrior", "tank", "ranger"])

	if all_soldiers.is_empty():
		var empty_label: Label = Label.new()
		empty_label.text = "No soldiers available"
		empty_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		empty_label.add_theme_font_size_override("font_size", 24)
		empty_label.add_theme_color_override("font_color", Color(0.5, 0.5, 0.6))
		container.add_child(empty_label)
		return

	for data in all_soldiers:
		var card = card_scene.instantiate()
		container.add_child(card)
		var is_unlocked: bool = data.id in unlocked_ids
		card.setup(data, is_unlocked)
		card.buy_pressed.connect(_on_buy_pressed)

func _on_buy_pressed(soldier_id: String) -> void:
	var data: SoldierData = SoldierRegistry.get_by_id(soldier_id)
	if data == null:
		_show_feedback("Soldier data missing.", Color(1.0, 0.4, 0.4))
		return

	var persistent_coins: int = int(SaveManager.get_value("profile", "persistent_coins", 0))
	if data.is_premium:
		_show_feedback("%s is reserved for premium unlocks." % data.display_name, Color(0.8, 0.6, 1.0))
		return
	if persistent_coins < data.unlock_price:
		var shortfall: int = data.unlock_price - persistent_coins
		_show_feedback("Need %d more coins for %s." % [shortfall, data.display_name], Color(1.0, 0.4, 0.4))
		return

	# Deduct coins
	SaveManager.set_value("profile", "persistent_coins", persistent_coins - data.unlock_price)

	# Add to unlocked list
	var unlocked_ids: Array = SaveManager.get_value("unlocks", "soldier_ids", ["warrior", "tank", "ranger"])
	if not (soldier_id in unlocked_ids):
		unlocked_ids.append(soldier_id)
		SaveManager.set_value("unlocks", "soldier_ids", unlocked_ids)

	SaveManager.save_data()
	AudioManager.play_sfx("ui")

	# Rebuild the card list to reflect changes
	_update_coins_label()
	_build_card_list()
	_show_feedback("%s unlocked." % data.display_name, Color(0.35, 1.0, 0.55))

func _on_back_pressed() -> void:
	AudioManager.play_sfx("ui")
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")

func _show_feedback(text: String, color: Color) -> void:
	feedback_label.text = text
	feedback_label.modulate = color
	feedback_label.visible = true
