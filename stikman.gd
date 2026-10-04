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
var land_timer = 0.0

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

    var was_on_floor = is_on_floor()
    velocity = move_and_slide(velocity, Vector2.UP)
    var now_on_floor = is_on_floor()
    if now_on_floor and not was_on_floor and velocity.y >= 0:
        land_timer = 0.16
    if land_timer > 0.0:
        land_timer -= delta
    var max_x = 4700 if (game != null and game.world1_underground_mode) else 3500
    position.x = clamp(position.x, 40, max_x)
    update()

func _draw():
    var moving = abs(velocity.x) > 1
    var running = abs(velocity.x) > speed + 20
    var airborne = not is_on_floor()
    var swing = sin(anim_time) * (15.0 if running else 11.0) if moving else 0.0
    var bob = sin(anim_time * 2.0) * (1.8 if running else 1.2) if moving and not airborne else 0.0
    var squash = 1.0
    var stretch = 1.0
    if airborne:
        stretch = 1.045
        squash = 0.975
    if land_timer > 0.0:
        var t = clamp(land_timer / 0.16, 0.0, 1.0)
        squash = 1.0 + sin(t * PI) * 0.08
        stretch = 1.0 - sin(t * PI) * 0.045

    var head_y = -67.0 + bob
    var torso_top = -51.0 + bob
    var torso_bottom = -23.0 + bob
    var head_radius = 15.0 * squash
    var leg_spread = 11.0 * stretch

    draw_ellipse(Vector2(0, 3), Vector2(24 * squash, 6 * stretch), Color(0, 0, 0, 0.28))
    draw_circle(Vector2(0, head_y), head_radius, Color("#d9b99a"))
    draw_arc(Vector2(0, head_y), head_radius, 0, PI * 2, 24, Color("#a9866c"), 2)

    var shirt_color = Color("#202328")
    if outfit_id == 1:
        shirt_color = Color("#315f9f")
    elif outfit_id == 2:
        shirt_color = Color("#9b3b38")
    elif outfit_id == 3:
        shirt_color = Color("#4f7359")

    var lean = 0.0
    if moving and not airborne:
        lean = 2.5 * facing * (1.0 if running else 0.55)

    draw_line(Vector2(0, torso_top), Vector2(lean, torso_bottom), shirt_color, 13 * squash)
    draw_line(Vector2(-6, torso_top + 1), Vector2(6 + lean, torso_top + 1), shirt_color, 5)
    if outfit_id == 3:
        draw_line(Vector2(-10, torso_top + 4), Vector2(10 + lean, torso_top + 4), Color("#b99552"), 3)

    if attacking:
        draw_line(Vector2(lean, -48 + bob), Vector2(34 * facing, -39 + bob), Color("#202328"), 6)
        draw_line(Vector2(lean, -48 + bob), Vector2(-18 * facing, -30 + bob), Color("#202328"), 6)
        draw_circle(Vector2(42 * facing, -39 + bob), 4, Color("#c79e7d"))
    else:
        var arm_swing = swing * (0.8 if running else 0.65)
        draw_line(Vector2(lean, -48 + bob), Vector2(-20 + arm_swing, -28 + bob), shirt_color, 6)
        draw_line(Vector2(lean, -48 + bob), Vector2(20 - arm_swing, -28 + bob), shirt_color, 6)

    var left_leg_x = -leg_spread + swing * 0.65
    var right_leg_x = leg_spread - swing * 0.65
    draw_line(Vector2(lean, torso_bottom), Vector2(left_leg_x, 0), Color("#202328"), 7)
    draw_line(Vector2(lean, torso_bottom), Vector2(right_leg_x, 0), Color("#202328"), 7)
    draw_line(Vector2(left_leg_x, 0), Vector2(left_leg_x + 8 * facing, 0), Color("#17191b"), 5)
    draw_line(Vector2(right_leg_x, 0), Vector2(right_leg_x + 8 * facing, 0), Color("#17191b"), 5)

func draw_ellipse(center, radius, color):
    var points = PoolVector2Array()
    for i in range(24):
        var a = PI * 2.0 * float(i) / 24.0
        points.append(center + Vector2(cos(a) * radius.x, sin(a) * radius.y))
    draw_colored_polygon(points, color)
