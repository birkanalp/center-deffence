extends Node

## Persistent save/load system using JSON at user://save_data.json.
## Auto-saves on app pause/close. Schema-versioned for future migrations.

const SAVE_PATH: String = "user://save_data.json"
const SAVE_VERSION: int = 1

var _data: Dictionary = {}
var _dirty: bool = false

signal data_loaded
signal data_saved

func _ready() -> void:
	load_data()

func load_data() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		_data = _get_default_data()
		save_data()
		data_loaded.emit()
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_warning("SaveManager: cannot open save file, resetting")
		_data = _get_default_data()
		save_data()
		data_loaded.emit()
		return
	var json := JSON.new()
	var parse_result := json.parse(file.get_as_text())
	file.close()
	if parse_result == OK:
		_data = json.data
		_migrate_if_needed()
	else:
		push_warning("SaveManager: corrupted save, resetting")
		_data = _get_default_data()
		save_data()
	data_loaded.emit()

func save_data() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("SaveManager: cannot write save file")
		return
	file.store_string(JSON.stringify(_data, "\t"))
	file.close()
	_dirty = false
	data_saved.emit()

func get_value(section: String, key: String, default_value = null):
	if _data.has(section) and _data[section] is Dictionary and _data[section].has(key):
		return _data[section][key]
	return default_value

func set_value(section: String, key: String, value) -> void:
	if not _data.has(section):
		_data[section] = {}
	_data[section][key] = value
	_dirty = true

func _get_default_data() -> Dictionary:
	return {
		"version": SAVE_VERSION,
		"profile": {
			"player_name": "",
			"persistent_coins": 0,
			"total_games_played": 0,
			"total_enemies_killed": 0,
			"total_time_played": 0.0,
			"ads_removed": false,
		},
		"unlocks": {
			"soldier_ids": ["warrior", "tank", "ranger"],
		},
		"scores": {
			"classic": [],
			"survival": [],
		},
		"settings": {
			"sfx_volume": 1.0,
			"music_volume": 1.0,
		},
	}

func _migrate_if_needed() -> void:
	var saved_version: int = _data.get("version", 0)
	if saved_version < SAVE_VERSION:
		# Future migrations go here
		_data["version"] = SAVE_VERSION
		save_data()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_APPLICATION_PAUSED:
		if _dirty:
			save_data()
