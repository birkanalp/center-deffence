extends Control

## Soldier store — browse and buy soldiers with persistent coins.
## Fully data-driven: shows all soldiers from SoldierRegistry.

const SoldierData = preload("res://scripts/data/soldier_data.gd")
var card_scene: PackedScene = preload("res://scenes/ui/soldier_card.tscn")

func _ready() -> void:
	$VBoxContainer/BackButton.pressed.connect(_on_back_pressed)
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
		return

	var persistent_coins: int = int(SaveManager.get_value("profile", "persistent_coins", 0))
	if persistent_coins < data.unlock_price:
		return

	# Deduct coins
	SaveManager.set_value("profile", "persistent_coins", persistent_coins - data.unlock_price)

	# Add to unlocked list
	var unlocked_ids: Array = SaveManager.get_value("unlocks", "soldier_ids", ["warrior", "tank", "ranger"])
	if not (soldier_id in unlocked_ids):
		unlocked_ids.append(soldier_id)
		SaveManager.set_value("unlocks", "soldier_ids", unlocked_ids)

	SaveManager.save_data()

	# Rebuild the card list to reflect changes
	_update_coins_label()
	_build_card_list()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
