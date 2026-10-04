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
var outfit_id = 0

func _ready():
    update()

func _physics_process(delta):
    var game = get_parent()
    var dialogue_locked = game != null and game.dialogue_active
    if dialogue_locked:
        velocity = Vector2.ZERO
        update()
        return

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
    var max_x = 4700 if (game != null and game.world1_underground_mode) else 3500
    position.x = clamp(position.x, 40, max_x)
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

    # Cabeza proporcionada al cuerpo, sin ojos ni expresiones.
    # El personaje conserva la silueta minimalista de Stikman, pero con
    # proporciones humanas y una presencia mas limpia.
    draw_circle(Vector2(0, -67), 15, Color("#d9b99a"))
    draw_arc(Vector2(0, -67), 15, 0, PI * 2, 24, Color("#b18e72"), 2)

    # Cuello y torso.
    var shirt_color = Color("#202328")
    if outfit_id == 1:
        shirt_color = Color("#315f9f")
    elif outfit_id == 2:
        shirt_color = Color("#9b3b38")
    elif outfit_id == 3:
        shirt_color = Color("#4f7359")

    draw_line(Vector2(0, -51), Vector2(0, -23), shirt_color, 13)
    draw_line(Vector2(-6, -50), Vector2(6, -50), shirt_color, 5)

    if outfit_id == 3:
        draw_line(Vector2(-10, -47), Vector2(10, -47), Color("#b99552"), 3)

    # Brazos proporcionados.
    if attacking:
        draw_line(Vector2(0, -48), Vector2(34 * facing, -39), Color("#202328"), 6)
        draw_line(Vector2(0, -48), Vector2(-18 * facing, -30), Color("#202328"), 6)
        draw_circle(Vector2(42 * facing, -39), 4, Color("#c79e7d"))
    else:
        draw_line(Vector2(0, -48), Vector2(-20 + swing * 0.7, -28), Color("#202328"), 6)
        draw_line(Vector2(0, -48), Vector2(20 - swing * 0.7, -28), Color("#202328"), 6)

    # Piernas proporcionadas y ligeramente mas gruesas para dar peso.
    draw_line(Vector2(0, -23), Vector2(-11 + swing * 0.7, 0), Color("#202328"), 7)
    draw_line(Vector2(0, -23), Vector2(11 - swing * 0.7, 0), Color("#202328"), 7)

func draw_ellipse(center, radius, color):
    var points = PoolVector2Array()
    for i in range(24):
        var a = PI * 2.0 * float(i) / 24.0
        points.append(center + Vector2(cos(a) * radius.x, sin(a) * radius.y))
    draw_colored_polygon(points, color)
