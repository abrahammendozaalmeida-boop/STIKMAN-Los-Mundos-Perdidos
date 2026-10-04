extends Control

var title_label
var status_label
var continue_button

func _ready():
	_build_menu()

func _build_menu():
	var background = ColorRect.new()
	background.color = Color(0.035, 0.075, 0.09, 1.0)
	background.anchor_right = 1.0
	background.anchor_bottom = 1.0
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)

	var layout = VBoxContainer.new()
	layout.anchor_left = 0.28
	layout.anchor_right = 0.72
	layout.anchor_top = 0.12
	layout.anchor_bottom = 0.9
	layout.alignment = BoxContainer.ALIGN_CENTER
	layout.add_constant_override("separation", 12)
	add_child(layout)

	title_label = Label.new()
	title_label.text = "STIKMAN\nLOS MUNDOS PERDIDOS"
	title_label.align = Label.ALIGN_CENTER
	title_label.valign = Label.VALIGN_CENTER
	title_label.autowrap = true
	title_label.rect_min_size = Vector2(0, 105)
	title_label.add_color_override("font_color", Color(0.88, 0.94, 0.91))
	layout.add_child(title_label)

	status_label = Label.new()
	status_label.text = "Una aventura comienza en una isla desconocida."
	status_label.align = Label.ALIGN_CENTER
	status_label.autowrap = true
	layout.add_child(status_label)

	var play_button = _make_button("JUGAR")
	play_button.connect("pressed", self, "_on_new_game")
	layout.add_child(play_button)

	continue_button = _make_button("CONTINUAR")
	continue_button.connect("pressed", self, "_on_continue")
	layout.add_child(continue_button)

	var settings_button = _make_button("AJUSTES")
	settings_button.connect("pressed", self, "_on_settings")
	layout.add_child(settings_button)

	var quit_button = _make_button("SALIR")
	quit_button.connect("pressed", self, "_on_quit")
	layout.add_child(quit_button)

	var credit = Label.new()
	credit.text = "Created by @abrahamg4"
	credit.align = Label.ALIGN_CENTER
	layout.add_child(credit)
	continue_button.disabled = not SaveManager.has_save()

func _make_button(caption):
	var button = Button.new()
	button.text = caption
	button.rect_min_size = Vector2(0, 42)
	return button

func _on_new_game():
	GameState.start_new_game()
	SaveManager.save_game()
	SceneRouter.change_to("res://scenes/levels/world_01/level_01_shipwreck.tscn")

func _on_continue():
	if SaveManager.load_game():
		SceneRouter.change_to("res://scenes/levels/world_01/level_01_shipwreck.tscn")
	else:
		status_label.text = SaveManager.last_error
		continue_button.disabled = not SaveManager.has_save()

func _on_settings():
	status_label.text = "Ajustes completos: se implementarán en la siguiente etapa."

func _on_quit():
	get_tree().quit()
