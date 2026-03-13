extends Node

## Loads all SoldierData resources from entity_configs/ at startup.
## Single source of truth for soldier definitions — replaces all hardcoded arrays.

const SoldierData = preload("res://scripts/data/soldier_data.gd")

var _all_soldiers: Array = []
var _by_id: Dictionary = {}

func _ready() -> void:
	_load_all()

func _load_all() -> void:
	var dir := DirAccess.open("res://resources/entity_configs/")
	if dir == null:
		push_error("SoldierRegistry: cannot open res://resources/entity_configs/")
		return
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if file_name.begins_with("soldier_") and file_name.ends_with(".tres"):
			var res = load("res://resources/entity_configs/" + file_name)
			if res is SoldierData:
				_all_soldiers.append(res)
				_by_id[res.id] = res
		file_name = dir.get_next()
	dir.list_dir_end()
	_all_soldiers.sort_custom(func(a, b): return a.sort_order < b.sort_order)

func get_all() -> Array:
	return _all_soldiers

func get_by_id(id: String) -> SoldierData:
	return _by_id.get(id, null)

func get_unlocked() -> Array:
	var unlocked_ids: Array = SaveManager.get_value("unlocks", "soldier_ids", ["warrior", "tank", "ranger"])
	var result: Array = []
	for s in _all_soldiers:
		if s.id in unlocked_ids:
			result.append(s)
	return result

func get_locked() -> Array:
	var unlocked_ids: Array = SaveManager.get_value("unlocks", "soldier_ids", ["warrior", "tank", "ranger"])
	var result: Array = []
	for s in _all_soldiers:
		if not (s.id in unlocked_ids):
			result.append(s)
	return result
