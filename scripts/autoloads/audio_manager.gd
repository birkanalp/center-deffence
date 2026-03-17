extends Node

## Global audio controller with generated placeholder SFX/music.

const SECTION := "settings"
const KEY_SFX_VOLUME := "sfx_volume"
const KEY_MUSIC_VOLUME := "music_volume"
const MUTE_DB := -80.0
const SAMPLE_RATE := 22050
const SFX_PLAYER_COUNT := 8

var _music_player: AudioStreamPlayer
var _sfx_players: Array[AudioStreamPlayer] = []
var _sfx_streams: Dictionary = {}
var _music_streams: Dictionary = {}
var _sfx_volume: float = 1.0
var _music_volume: float = 1.0
var _current_music_id: String = ""
var _audio_enabled: bool = true

func _ready() -> void:
	_audio_enabled = DisplayServer.get_name() != "headless"
	_create_players()
	_build_stream_library()
	_load_saved_settings()

func _exit_tree() -> void:
	stop_music()
	if _music_player != null:
		_music_player.stream = null
	for player in _sfx_players:
		if player != null:
			player.stop()
			player.stream = null
	_sfx_streams.clear()
	_music_streams.clear()
	_sfx_players.clear()

func _create_players() -> void:
	_music_player = AudioStreamPlayer.new()
	_music_player.name = "MusicPlayer"
	add_child(_music_player)

	for i in SFX_PLAYER_COUNT:
		var player := AudioStreamPlayer.new()
		player.name = "SfxPlayer%d" % i
		add_child(player)
		_sfx_players.append(player)

func _build_stream_library() -> void:
	_sfx_streams["ui"] = _create_tone_sequence_stream([
		{"frequency": 660.0, "duration": 0.04, "volume": 0.28, "waveform": "square"},
		{"frequency": 880.0, "duration": 0.05, "volume": 0.22, "waveform": "square"},
	])
	_sfx_streams["spawn"] = _create_tone_sequence_stream([
		{"frequency": 300.0, "duration": 0.05, "volume": 0.24, "waveform": "triangle"},
		{"frequency": 440.0, "duration": 0.08, "volume": 0.22, "waveform": "triangle"},
	])
	_sfx_streams["hit"] = _create_tone_sequence_stream([
		{"frequency": 240.0, "duration": 0.03, "volume": 0.22, "waveform": "noise"},
		{"frequency": 180.0, "duration": 0.04, "volume": 0.18, "waveform": "noise"},
	])
	_sfx_streams["enemy_down"] = _create_tone_sequence_stream([
		{"frequency": 420.0, "duration": 0.06, "volume": 0.22, "waveform": "triangle"},
		{"frequency": 210.0, "duration": 0.10, "volume": 0.18, "waveform": "triangle"},
	])
	_sfx_streams["tower_hit"] = _create_tone_sequence_stream([
		{"frequency": 120.0, "duration": 0.12, "volume": 0.28, "waveform": "square"},
		{"frequency": 90.0, "duration": 0.10, "volume": 0.22, "waveform": "triangle"},
	])
	_sfx_streams["victory"] = _create_tone_sequence_stream([
		{"frequency": 523.25, "duration": 0.12, "volume": 0.22, "waveform": "triangle"},
		{"frequency": 659.25, "duration": 0.12, "volume": 0.22, "waveform": "triangle"},
		{"frequency": 783.99, "duration": 0.18, "volume": 0.22, "waveform": "triangle"},
	])
	_sfx_streams["defeat"] = _create_tone_sequence_stream([
		{"frequency": 320.0, "duration": 0.12, "volume": 0.22, "waveform": "triangle"},
		{"frequency": 220.0, "duration": 0.16, "volume": 0.22, "waveform": "triangle"},
		{"frequency": 146.83, "duration": 0.24, "volume": 0.22, "waveform": "triangle"},
	])

	_music_streams["menu"] = _create_loop_music_stream([
		261.63, 329.63, 392.00, 523.25,
		392.00, 329.63, 293.66, 349.23,
	], 0.32, 0.14)
	_music_streams["gameplay"] = _create_loop_music_stream([
		164.81, 196.00, 246.94, 196.00,
		174.61, 220.00, 261.63, 220.00,
	], 0.28, 0.16)

func _load_saved_settings() -> void:
	_sfx_volume = float(SaveManager.get_value(SECTION, KEY_SFX_VOLUME, 1.0))
	_music_volume = float(SaveManager.get_value(SECTION, KEY_MUSIC_VOLUME, 1.0))
	_apply_volume()

func set_sfx_volume(value: float, persist: bool = false) -> void:
	_sfx_volume = clampf(value, 0.0, 1.0)
	_apply_volume()
	if persist:
		SaveManager.set_value(SECTION, KEY_SFX_VOLUME, _sfx_volume)

func set_music_volume(value: float, persist: bool = false) -> void:
	_music_volume = clampf(value, 0.0, 1.0)
	_apply_volume()
	if persist:
		SaveManager.set_value(SECTION, KEY_MUSIC_VOLUME, _music_volume)

func play_sfx(sound_id: String) -> void:
	if not _audio_enabled:
		return
	var stream: AudioStream = _sfx_streams.get(sound_id)
	if stream == null:
		return

	var player := _get_available_sfx_player()
	player.stream = stream
	player.volume_db = _to_db(_sfx_volume)
	player.play()

func play_menu_music() -> void:
	_play_music("menu")

func play_gameplay_music() -> void:
	_play_music("gameplay")

func stop_music() -> void:
	_current_music_id = ""
	_music_player.stop()

func _play_music(music_id: String) -> void:
	if not _audio_enabled:
		return
	if _current_music_id == music_id and _music_player.playing:
		return

	var stream: AudioStream = _music_streams.get(music_id)
	if stream == null:
		return

	_current_music_id = music_id
	_music_player.stream = stream
	_music_player.volume_db = _to_db(_music_volume)
	_music_player.play()

func _apply_volume() -> void:
	_music_player.volume_db = _to_db(_music_volume)
	for player in _sfx_players:
		player.volume_db = _to_db(_sfx_volume)

func _get_available_sfx_player() -> AudioStreamPlayer:
	for player in _sfx_players:
		if not player.playing:
			return player
	return _sfx_players[0]

func _to_db(value: float) -> float:
	if value <= 0.001:
		return MUTE_DB
	return linear_to_db(value)

func _create_loop_music_stream(note_sequence: Array[float], note_duration: float, volume: float) -> AudioStreamWAV:
	var sample_count := int(note_sequence.size() * note_duration * SAMPLE_RATE)
	var pcm := PackedByteArray()
	pcm.resize(sample_count * 2)

	for i in sample_count:
		var time := float(i) / float(SAMPLE_RATE)
		var note_index := mini(int(time / note_duration), note_sequence.size() - 1)
		var note_time := fmod(time, note_duration)
		var frequency := note_sequence[note_index]
		var envelope := _envelope(note_time, note_duration, 0.02, 0.10)
		var pad := sin(TAU * frequency * time) * 0.55
		var overtone := sin(TAU * (frequency * 0.5) * time) * 0.25
		var shimmer := sin(TAU * (frequency * 1.5) * time) * 0.08
		var sample := (pad + overtone + shimmer) * envelope * volume
		_write_sample(pcm, i, sample)

	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = SAMPLE_RATE
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	stream.loop_begin = 0
	stream.loop_end = sample_count
	stream.data = pcm
	return stream

func _create_tone_sequence_stream(sequence: Array[Dictionary]) -> AudioStreamWAV:
	var total_duration := 0.0
	for part in sequence:
		total_duration += float(part.get("duration", 0.08))

	var sample_count := int(total_duration * SAMPLE_RATE)
	var pcm := PackedByteArray()
	pcm.resize(sample_count * 2)

	var time_cursor := 0.0
	for part in sequence:
		var part_duration := float(part.get("duration", 0.08))
		var frequency := float(part.get("frequency", 440.0))
		var volume := float(part.get("volume", 0.2))
		var waveform := str(part.get("waveform", "sine"))
		var start_sample := int(time_cursor * SAMPLE_RATE)
		var end_sample := mini(int((time_cursor + part_duration) * SAMPLE_RATE), sample_count)

		for sample_index in range(start_sample, end_sample):
			var local_time := float(sample_index - start_sample) / float(SAMPLE_RATE)
			var sample := _wave_sample(waveform, frequency, local_time)
			var envelope := _envelope(local_time, part_duration, 0.01, 0.12)
			_write_sample(pcm, sample_index, sample * envelope * volume)

		time_cursor += part_duration

	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = SAMPLE_RATE
	stream.data = pcm
	return stream

func _wave_sample(waveform: String, frequency: float, time: float) -> float:
	var phase := TAU * frequency * time
	match waveform:
		"square":
			return 1.0 if sin(phase) >= 0.0 else -1.0
		"triangle":
			return asin(sin(phase)) * (2.0 / PI)
		"noise":
			return randf_range(-1.0, 1.0)
		_:
			return sin(phase)

func _envelope(time: float, duration: float, attack: float, release: float) -> float:
	if duration <= 0.0:
		return 0.0

	var attack_time := minf(attack, duration)
	var release_time := minf(release, duration)

	if attack_time > 0.0 and time < attack_time:
		return time / attack_time
	if release_time > 0.0 and time > duration - release_time:
		return maxf(0.0, (duration - time) / release_time)
	return 1.0

func _write_sample(pcm: PackedByteArray, sample_index: int, value: float) -> void:
	var clamped := clampf(value, -1.0, 1.0)
	var encoded := int(roundf(clamped * 32767.0))
	if encoded < 0:
		encoded += 65536
	var byte_index := sample_index * 2
	pcm[byte_index] = encoded & 0xFF
	pcm[byte_index + 1] = (encoded >> 8) & 0xFF
