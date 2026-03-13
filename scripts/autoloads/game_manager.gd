extends Node

## Global game state singleton (autoloaded).
## Persists data between scene transitions.

var last_result_victory: bool = false
var enemies_killed: int = 0
var waves_reached: int = 0
var time_survived: float = 0.0
var coins: int = 0
var game_mode: int = 0  # 0 = Classic, 1 = Survival
var last_coins_earned: int = 0
var last_score: int = 0

const STARTING_COINS: int = 50
const MODE_CLASSIC: int = 0
const MODE_SURVIVAL: int = 1

func reset_game_state() -> void:
	last_result_victory = false
	enemies_killed = 0
	waves_reached = 0
	time_survived = 0.0
	coins = STARTING_COINS
	last_coins_earned = 0
	last_score = 0

func record_game_result() -> void:
	# Calculate score
	var score: int = 0
	if game_mode == MODE_CLASSIC:
		score = enemies_killed * 10
		if last_result_victory:
			score += 50
	else:
		score = int(time_survived) + enemies_killed * 5 + waves_reached * 20

	# Calculate coins earned
	var coins_earned: int = enemies_killed
	if game_mode == MODE_CLASSIC and last_result_victory:
		coins_earned += 50
	if game_mode == MODE_SURVIVAL:
		coins_earned += waves_reached * 5

	last_score = score
	last_coins_earned = coins_earned

	# Update persistent profile stats
	var prev_coins: int = int(SaveManager.get_value("profile", "persistent_coins", 0))
	SaveManager.set_value("profile", "persistent_coins", prev_coins + coins_earned)

	var prev_games: int = int(SaveManager.get_value("profile", "total_games_played", 0))
	SaveManager.set_value("profile", "total_games_played", prev_games + 1)

	var prev_kills: int = int(SaveManager.get_value("profile", "total_enemies_killed", 0))
	SaveManager.set_value("profile", "total_enemies_killed", prev_kills + enemies_killed)

	var prev_time: float = float(SaveManager.get_value("profile", "total_time_played", 0.0))
	SaveManager.set_value("profile", "total_time_played", prev_time + time_survived)

	# Record score entry
	var mode_key: String = "classic" if game_mode == MODE_CLASSIC else "survival"
	var scores: Array = SaveManager.get_value("scores", mode_key, [])
	if not scores is Array:
		scores = []

	var now: Dictionary = Time.get_date_dict_from_system()
	var date_str: String = "%04d-%02d-%02d" % [now["year"], now["month"], now["day"]]

	var entry: Dictionary = {
		"score": score,
		"kills": enemies_killed,
		"waves": waves_reached,
		"time": time_survived,
		"victory": last_result_victory,
		"date": date_str,
	}
	scores.append(entry)

	# Sort descending by score, keep top 10
	scores.sort_custom(func(a, b): return a["score"] > b["score"])
	if scores.size() > 10:
		scores.resize(10)

	SaveManager.set_value("scores", mode_key, scores)
	SaveManager.save_data()
