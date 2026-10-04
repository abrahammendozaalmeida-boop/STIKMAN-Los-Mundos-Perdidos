extends Node

signal health_changed(current, maximum)
signal money_changed(total)
signal progress_changed(world_id, level_id)
signal clock_changed(seconds_in_day)

const SAVE_VERSION = 1
const DAY_LENGTH_SECONDS = 600.0

var current_world = 1
var current_level = 1
var health = 3
var max_health = 3
var fruit_money = 0
var play_time_seconds = 0.0
var seconds_in_day = 0.0
var checkpoint_id = "shipwreck_start"
var unlocked_levels = {"world_01": 1}
var collected_stickers = []
var story_flags = {}
var is_new_game = true

func start_new_game():
	current_world = 1
	current_level = 1
	health = max_health
	fruit_money = 0
	play_time_seconds = 0.0
	seconds_in_day = 0.0
	checkpoint_id = "shipwreck_start"
	unlocked_levels = {"world_01": 1}
	collected_stickers = []
	story_flags = {}
	is_new_game = true
	emit_signal("health_changed", health, max_health)
	emit_signal("money_changed", fruit_money)
	emit_signal("progress_changed", current_world, current_level)
	emit_signal("clock_changed", seconds_in_day)

func set_health(value):
	health = int(clamp(value, 0, max_health))
	emit_signal("health_changed", health, max_health)

func add_fruit_money(amount):
	fruit_money = max(0, fruit_money + int(amount))
	emit_signal("money_changed", fruit_money)

func set_progress(world_id, level_id):
	current_world = max(1, int(world_id))
	current_level = max(1, int(level_id))
	var key = "world_%02d" % current_world
	if not unlocked_levels.has(key):
		unlocked_levels[key] = 1
	unlocked_levels[key] = max(int(unlocked_levels[key]), current_level)
	emit_signal("progress_changed", current_world, current_level)

func set_clock(seconds):
	seconds_in_day = fposmod(float(seconds), DAY_LENGTH_SECONDS)
	emit_signal("clock_changed", seconds_in_day)

func to_save_data():
	return {
		"version": SAVE_VERSION,
		"current_world": current_world,
		"current_level": current_level,
		"health": health,
		"max_health": max_health,
		"fruit_money": fruit_money,
		"play_time_seconds": play_time_seconds,
		"seconds_in_day": seconds_in_day,
		"checkpoint_id": checkpoint_id,
		"unlocked_levels": unlocked_levels,
		"collected_stickers": collected_stickers,
		"story_flags": story_flags
	}

func apply_save_data(data):
	if typeof(data) != TYPE_DICTIONARY:
		return false
	if int(data.get("version", 0)) > SAVE_VERSION:
		return false
	current_world = max(1, int(data.get("current_world", 1)))
	current_level = max(1, int(data.get("current_level", 1)))
	max_health = max(1, int(data.get("max_health", 3)))
	health = int(clamp(int(data.get("health", max_health)), 0, max_health))
	fruit_money = max(0, int(data.get("fruit_money", 0)))
	play_time_seconds = max(0.0, float(data.get("play_time_seconds", 0.0)))
	seconds_in_day = fposmod(float(data.get("seconds_in_day", 0.0)), DAY_LENGTH_SECONDS)
	checkpoint_id = str(data.get("checkpoint_id", "shipwreck_start"))
	unlocked_levels = data.get("unlocked_levels", {"world_01": 1})
	collected_stickers = data.get("collected_stickers", [])
	story_flags = data.get("story_flags", {})
	is_new_game = false
	emit_signal("health_changed", health, max_health)
	emit_signal("money_changed", fruit_money)
	emit_signal("progress_changed", current_world, current_level)
	emit_signal("clock_changed", seconds_in_day)
	return true
