extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 260.0
var jump_force = 470.0
var gravity = 1100.0
var anim_time = 0.0

func _ready():
    update()

func _physics_process(delta):
    var direction = 0

    if Input.is_action_pressed("move_left"):
        direction -= 1

    if Input.is_action_pressed("move_right"):
        direction += 1

    velocity.x = direction * speed

    if direction != 0:
        anim_time += delta * 10.0
    else:
        anim_time += delta * 3.0

    if is_on_floor():
        if Input.is_action_just_pressed("jump"):
            velocity.y = -jump_force
    else:
        velocity.y += gravity * delta

    velocity = move_and_slide(velocity, Vector2.UP)
    update()

func _draw():
    draw_circle(Vector2(0, -105), 24, Color("#edd0ae"))
    draw_circle(Vector2(-8, -111), 3, Color("#111111"))
    draw_circle(Vector2(8, -111), 3, Color("#111111"))

    draw_line(Vector2(0, -81), Vector2(0, -25), Color("#111111"), 9)

    var swing = 0.0
    if abs(velocity.x) > 1:
        swing = sin(anim_time) * 12.0

    draw_line(Vector2(0, -70), Vector2(-28 + swing, -42), Color("#111111"), 7)
    draw_line(Vector2(0, -70), Vector2(28 - swing, -42), Color("#111111"), 7)
    draw_line(Vector2(0, -25), Vector2(-18 + swing, 0), Color("#111111"), 8)
    draw_line(Vector2(0, -25), Vector2(18 - swing, 0), Color("#111111"), 8)
