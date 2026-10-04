extends Node

var master_volume = 1.0
var music_volume = 0.75
var effects_volume = 0.85

func set_master_volume(value):
	master_volume = clamp(float(value), 0.0, 1.0)
	_apply_bus("Master", master_volume)

func set_music_volume(value):
	music_volume = clamp(float(value), 0.0, 1.0)
	_apply_bus("Music", music_volume)

func set_effects_volume(value):
	effects_volume = clamp(float(value), 0.0, 1.0)
	_apply_bus("SFX", effects_volume)

func _apply_bus(bus_name, value):
	var bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index >= 0:
		AudioServer.set_bus_volume_db(bus_index, linear2db(max(float(value), 0.001)))
		AudioServer.set_bus_mute(bus_index, float(value) <= 0.0)
