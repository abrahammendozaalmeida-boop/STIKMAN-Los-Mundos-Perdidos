extends KinematicBody2D

signal landed
signal died

export(float) var walk_speed = 220.0
export(float) var run_speed = 300.0
export(float) var acceleration = 1200.0
export(float) var friction = 1500.0
export(float) var jump_force = 410.0
export(float) var gravity = 1000.0

var velocity = Vector2.ZERO
var facing = 1
var animation_time = 0.0
var landing_time = 0.0
var previous_on_floor = false
var input_enabled = true

func _physics_process(delta):
	if not input_enabled or get_tree().paused:
		return

	var direction = 0
	if Input.is_action_pressed("move_left"):
		direction -= 1
	if Input.is_action_pressed("move_right"):
		direction += 1

	var target_speed = run_speed if Input.is_action_pressed("run") else walk_speed
	if direction != 0:
		velocity.x = move_toward(velocity.x, float(direction) * target_speed, acceleration * delta)
		facing = direction
	else:
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)

	var on_floor_before = is_on_floor()
	if on_floor_before and Input.is_action_just_pressed("jump"):
		velocity.y = -jump_force
	elif not on_floor_before:
		velocity.y += gravity * delta
	else:
		velocity.y = 0.0

	animation_time += delta * (12.0 if abs(velocity.x) > walk_speed + 10.0 else 9.0)
	velocity = move_and_slide(velocity, Vector2.UP)
	var on_floor_after = is_on_floor()
	if on_floor_after and not previous_on_floor and velocity.y >= 0.0:
		landing_time = 0.16
		emit_signal("landed")
	previous_on_floor = on_floor_after
	landing_time = max(0.0, landing_time - delta)
	update()

func set_input_enabled(enabled):
	input_enabled = enabled
	if not enabled:
		velocity = Vector2.ZERO

func _draw():
	var moving = abs(velocity.x) > 8.0
	var airborne = not is_on_floor()
	var swing = sin(animation_time) * 10.0 if moving and not airborne else 0.0
	var bob = abs(sin(animation_time * 2.0)) * 1.5 if moving and not airborne else 0.0
	var squash = 1.0
	if landing_time > 0.0:
		squash = 1.0 + sin(landing_time / 0.16 * PI) * 0.06
	var ink = Color(0.055, 0.06, 0.075)
	var head_center = Vector2(0, -54.0 + bob)
	draw_circle(head_center, 11.5 * squash, ink)
	draw_line(Vector2(0, -41.0 + bob), Vector2(0, -20.0 + bob), ink, 5.0, true)
	draw_line(Vector2(0, -36.0 + bob), Vector2(-10.0 + swing * 0.5, -24.0 + bob), ink, 3.5, true)
	draw_line(Vector2(0, -36.0 + bob), Vector2(10.0 - swing * 0.5, -24.0 + bob), ink, 3.5, true)
	var leg_left = Vector2(-5.0 + swing * 0.55, 0)
	var leg_right = Vector2(5.0 - swing * 0.55, 0)
	if airborne:
		leg_left = Vector2(-10.0, -2.0)
		leg_right = Vector2(10.0, -5.0)
	draw_line(Vector2(0, -20.0 + bob), leg_left, ink, 4.0, true)
	draw_line(Vector2(0, -20.0 + bob), leg_right, ink, 4.0, true)
