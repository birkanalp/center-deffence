extends Control

## Settings screen for local audio preferences.

const SECTION := "settings"
const KEY_SFX_VOLUME := "sfx_volume"
const KEY_MUSIC_VOLUME := "music_volume"

@onready var sfx_slider: HSlider = $VBoxContainer/SfxRow/SfxSlider
@onready var sfx_value_label: Label = $VBoxContainer/SfxRow/SfxValue
@onready var music_slider: HSlider = $VBoxContainer/MusicRow/MusicSlider
@onready var music_value_label: Label = $VBoxContainer/MusicRow/MusicValue
@onready var back_button: Button = $VBoxContainer/BackButton

func _ready() -> void:
	back_button.pressed.connect(_on_back_pressed)
	sfx_slider.value_changed.connect(_on_sfx_value_changed)
	music_slider.value_changed.connect(_on_music_value_changed)

	sfx_slider.value = float(SaveManager.get_value(SECTION, KEY_SFX_VOLUME, 1.0))
	music_slider.value = float(SaveManager.get_value(SECTION, KEY_MUSIC_VOLUME, 1.0))
	_update_labels()

func _on_sfx_value_changed(value: float) -> void:
	SaveManager.set_value(SECTION, KEY_SFX_VOLUME, value)
	_update_labels()

func _on_music_value_changed(value: float) -> void:
	SaveManager.set_value(SECTION, KEY_MUSIC_VOLUME, value)
	_update_labels()

func _update_labels() -> void:
	sfx_value_label.text = "%d%%" % int(roundf(sfx_slider.value * 100.0))
	music_value_label.text = "%d%%" % int(roundf(music_slider.value * 100.0))

func _on_back_pressed() -> void:
	SaveManager.save_data()
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
