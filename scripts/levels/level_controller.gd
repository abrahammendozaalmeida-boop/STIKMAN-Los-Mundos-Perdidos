extends Node2D

export(NodePath) var player_path
export(NodePath) var clock_label_path
export(NodePath) var health_label_path
export(NodePath) var money_label_path

var day_seconds = 0.0
var pause_layer = null
var player = null
var clock_label = null
var health_label = null
var money_label = null

func _ready():
	player = get_node(player_path)
	clock_label = get_node(clock_label_path)
	health_label = get_node(health_label_path)
	money_label = get_node(money_label_path)
	day_seconds = GameState.seconds_in_day
	player.position = GameState.checkpoint_position
	_update_hud()
	GameState.connect("health_changed", self, "_on_health_changed")
	GameState.connect("money_changed", self, "_on_money_changed")
	set_process(true)

func _process(delta):
	if get_tree().paused:
		return
	day_seconds = fposmod(day_seconds + delta, GameState.DAY_LENGTH_SECONDS)
	GameState.set_clock(day_seconds)
	GameState.play_time_seconds += delta
	_update_clock()
	_update_daylight()

func _input(event):
	if event.is_action_pressed("pause") and not event.is_echo():
		if pause_layer == null:
			_open_pause_menu()
		else:
			_close_pause_menu()

func _update_hud():
	_update_clock()
	_on_health_changed(GameState.health, GameState.max_health)
	_on_money_changed(GameState.fruit_money)

func _update_clock():
	var minute_of_day = int((day_seconds / GameState.DAY_LENGTH_SECONDS) * 1440.0)
	var hours = int(minute_of_day / 60) % 24
	var minutes = minute_of_day % 60
	clock_label.text = "%02d:%02d" % [hours, minutes]

func _update_daylight():
	var phase = day_seconds / GameState.DAY_LENGTH_SECONDS
	var daylight = (sin(phase * PI * 2.0 - PI / 2.0) + 1.0) * 0.5
	var tint = Color(
		0.08 + daylight * 0.82,
		0.11 + daylight * 0.79,
		0.19 + daylight * 0.70,
		1.0
	)
	$CanvasModulate.color = tint

func _on_health_changed(current, maximum):
	health_label.text = "VIDA: %d/%d" % [current, maximum]

func _on_money_changed(total):
	money_label.text = "FRUITMONEY: %d" % total

func _open_pause_menu():
	var packed = load("res://scenes/menus/pause_menu.tscn")
	pause_layer = packed.instance()
	add_child(pause_layer)
	pause_layer.connect("resume_requested", self, "_close_pause_menu")
	pause_layer.connect("restart_requested", self, "_restart_level")
	pause_layer.connect("menu_requested", self, "_return_to_menu")
	get_tree().paused = true

func _close_pause_menu():
	get_tree().paused = false
	if is_instance_valid(pause_layer):
		pause_layer.queue_free()
	pause_layer = null

func _restart_level():
	get_tree().paused = false
	SaveManager.save_game()
	SceneRouter.change_to("res://scenes/levels/world_01/level_01_shipwreck.tscn")

func _return_to_menu():
	get_tree().paused = false
	GameState.checkpoint_position = player.position
	SaveManager.save_game()
	SceneRouter.change_to("res://scenes/menus/main_menu.tscn")
