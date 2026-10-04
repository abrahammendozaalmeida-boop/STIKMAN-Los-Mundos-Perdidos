extends Control

signal resume_requested
signal restart_requested
signal menu_requested

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	_build()

func _build():
	var shade = ColorRect.new()
	shade.color = Color(0.0, 0.025, 0.04, 0.78)
	shade.anchor_right = 1.0
	shade.anchor_bottom = 1.0
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(shade)

	var panel = PanelContainer.new()
	panel.anchor_left = 0.30
	panel.anchor_right = 0.70
	panel.anchor_top = 0.12
	panel.anchor_bottom = 0.88
	add_child(panel)

	var layout = VBoxContainer.new()
	layout.alignment = BoxContainer.ALIGN_CENTER
	layout.add_constant_override("separation", 12)
	panel.add_child(layout)

	var title = Label.new()
	title.text = "PAUSA"
	title.align = Label.ALIGN_CENTER
	layout.add_child(title)

	_add_button(layout, "CONTINUAR", "_resume")
	_add_button(layout, "REINICIAR NIVEL", "_restart")
	_add_button(layout, "VOLVER AL MENÚ", "_menu")

func _add_button(parent, caption, method):
	var button = Button.new()
	button.text = caption
	button.rect_min_size = Vector2(0, 44)
	button.connect("pressed", self, method)
	parent.add_child(button)

func _resume():
	emit_signal("resume_requested")

func _restart():
	emit_signal("restart_requested")

func _menu():
	emit_signal("menu_requested")
