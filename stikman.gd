extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 260.0
var run_speed = 350.0
var jump_force = 470.0
var gravity = 1100.0
var anim_time = 0.0
var facing = 1
var attacking = false
var attack_timer = 0.0

func _ready():
    update()

func _physics_process(delta):
    attacking = Input.is_key_pressed(KEY_J)

    var direction = 0

    if Input.is_action_pressed("move_left"):
        direction -= 1

    if Input.is_action_pressed("move_right"):
        direction += 1

    var target_speed = speed
    if Input.is_key_pressed(KEY_SHIFT):
        target_speed = run_speed

    velocity.x = direction * target_speed

    if direction != 0:
        facing = direction
        anim_time += delta * (13.0 if target_speed == run_speed else 10.0)
    else:
        anim_time += delta * 3.0

    if attack_timer > 0:
        attack_timer -= delta

    if is_on_floor():
        if Input.is_action_just_pressed("jump"):
            velocity.y = -jump_force
    else:
        velocity.y += gravity * delta

    velocity = move_and_slide(velocity, Vector2.UP)
    position.x = clamp(position.x, 40, 3500)
    update()

func _draw():
    var moving = abs(velocity.x) > 1
    var running = abs(velocity.x) > speed + 20
    var swing = 0.0

    if attacking:
        swing = 0

    if moving:
        swing = sin(anim_time) * (16.0 if running else 12.0)

    # Sombra
    draw_ellipse(Vector2(0, 3), Vector2(24, 6), Color(0, 0, 0, 0.28))

    # Cabeza
    draw_circle(Vector2(0, -105), 24, Color("#edd0ae"))
    draw_circle(Vector2(-8, -111), 3, Color("#111111"))
    draw_circle(Vector2(8, -111), 3, Color("#111111"))

    # Cuerpo
    draw_line(Vector2(0, -81), Vector2(0, -25), Color("#111111"), 9)

    # Brazos
    if attacking:
        draw_line(Vector2(0, -70), Vector2(45 * facing, -60), Color("#111111"), 8)
        draw_line(Vector2(0, -70), Vector2(-22 * facing, -40), Color("#111111"), 7)
        draw_circle(Vector2(58 * facing, -60), 5, Color("#d7a65a"))
    else:
        draw_line(Vector2(0, -70), Vector2(-28 + swing, -42), Color("#111111"), 7)
        draw_line(Vector2(0, -70), Vector2(28 - swing, -42), Color("#111111"), 7)

    # Piernas
    draw_line(Vector2(0, -25), Vector2(-18 + swing, 0), Color("#111111"), 8)
    draw_line(Vector2(0, -25), Vector2(18 - swing, 0), Color("#111111"), 8)

func draw_ellipse(center, radius, color):
    var points = PoolVector2Array()
    for i in range(24):
        var a = PI * 2.0 * float(i) / 24.0
        points.append(center + Vector2(cos(a) * radius.x, sin(a) * radius.y))
    draw_colored_polygon(points, color)
