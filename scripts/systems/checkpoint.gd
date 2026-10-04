extends Area2D

export(String) var checkpoint_id = "jungle_checkpoint_01"
export(Vector2) var spawn_offset = Vector2(0, 15)

var pulse_time = 0.0
var activated = false

func _ready():
	connect("body_entered", self, "_on_body_entered")
	set_process(true)

func _process(delta):
	pulse_time += delta
	update()

func _draw():
	var pulse = (sin(pulse_time * 3.0) + 1.0) * 0.5
	var glow_alpha = 0.12 + pulse * 0.22
	draw_rect(Rect2(Vector2(-20, -39), Vector2(40, 40)), Color(0.05, 0.45, 1.0, glow_alpha), true)
	draw_rect(Rect2(Vector2(-14, -33), Vector2(28, 28)), Color(0.05, 0.35, 0.95, 0.65 + pulse * 0.25), true)
	draw_rect(Rect2(Vector2(-8, -27), Vector2(16, 16)), Color(0.65, 0.88, 1.0, 0.9), true)

func _on_body_entered(body):
	if activated or body.name != "Stikman":
		return
	activated = true
	GameState.checkpoint_id = checkpoint_id
	GameState.checkpoint_position = global_position + spawn_offset
	SaveManager.save_game()
	update()
