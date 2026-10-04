extends Node2D

var coins = 0
var health = 3
var game_over = false
var finished = false
var victory_timer = 0.0
var world1_ready = false
var elapsed = 0.0
var message_timer = 0.0
var enemy_alive = true
var enemy_x = 2820.0
var enemy_direction = -1
var enemy_speed = 80.0
var damage_cooldown = 0.0
var guardian_hits = 0
var guardian_max_hits = 3
var guardian_hit_cooldown = 0.0

var hazard_positions = [
    Vector2(930, 412),
    Vector2(1370, 412),
    Vector2(1890, 412),
    Vector2(2310, 412)
]

var coin_positions = [
    Vector2(520, 345),
    Vector2(760, 300),
    Vector2(1030, 350),
    Vector2(1260, 285),
    Vector2(1510, 335),
    Vector2(1760, 290),
    Vector2(2020, 340),
    Vector2(2200, 285),
    Vector2(2460, 335)
]

func _ready():
    _create_hazards()
    _create_coins()
    _create_exit()
    _update_ui()
    update()

func _process(delta):
    if not game_over and not finished:
        elapsed += delta
        if message_timer > 0:
            message_timer -= delta
        if damage_cooldown > 0:
            damage_cooldown -= delta
        if guardian_hit_cooldown > 0:
            guardian_hit_cooldown -= delta
        if victory_timer > 0:
            victory_timer -= delta
            if victory_timer <= 0:
                world1_ready = true

        _update_enemy(delta)
        _check_attack()
        _check_enemy_contact()
        _update_ui()
    update()

func _update_enemy(delta):
    if not enemy_alive:
        return

    enemy_x += enemy_direction * enemy_speed * delta
    if enemy_x <= 2680:
        enemy_x = 2680
        enemy_direction = 1
    elif enemy_x >= 2920:
        enemy_x = 2920
        enemy_direction = -1

func _check_attack():
    if not enemy_alive:
        return

    if Input.is_key_pressed(KEY_J):
        var player = get_node_or_null("Stikman")
        if player != null and abs(player.position.x - enemy_x) < 125 and abs(player.position.y - 350) < 120 and guardian_hit_cooldown <= 0:
            guardian_hits += 1
            guardian_hit_cooldown = 0.45
            enemy_x += enemy_direction * 35
            message_timer = 0.8
            if guardian_hits >= guardian_max_hits:
                enemy_alive = false
                victory_timer = 2.5
                message_timer = 2.5

func _check_enemy_contact():
    if not enemy_alive or damage_cooldown > 0:
        return

    var player = get_node_or_null("Stikman")
    if player == null:
        return

    if abs(player.position.x - enemy_x) < 55 and abs(player.position.y - 350) < 105:
        health -= 1
        damage_cooldown = 1.2
        message_timer = 1.5
        player.position = Vector2(max(100, player.position.x - 120), 350)
        player.velocity = Vector2.ZERO

        if health <= 0:
            game_over = true
            player.set_physics_process(false)

func _draw():
    # Cielo y ambiente
    draw_rect(Rect2(0, 0, 3600, 540), Color("#10261b"))
    draw_circle(Vector2(700, 90), 58, Color("#d9e7c8"))

    # Neblina lejana
    draw_circle(Vector2(420, 250), 110, Color(0.18, 0.35, 0.23, 0.18))
    draw_circle(Vector2(1450, 220), 150, Color(0.18, 0.35, 0.23, 0.16))
    draw_circle(Vector2(2700, 210), 180, Color(0.18, 0.35, 0.23, 0.14))

    # Montañas
    var mountains = PoolVector2Array([
        Vector2(0, 360), Vector2(250, 170), Vector2(480, 360),
        Vector2(720, 145), Vector2(980, 360), Vector2(1250, 180),
        Vector2(1540, 360), Vector2(1800, 150), Vector2(2100, 360),
        Vector2(2400, 180), Vector2(2700, 360), Vector2(3000, 160),
        Vector2(3300, 360), Vector2(3600, 180), Vector2(3600, 540),
        Vector2(0, 540)
    ])
    draw_colored_polygon(mountains, Color("#173a28"))

    # Suelo
    draw_rect(Rect2(0, 430, 3600, 110), Color("#3b291c"))
    draw_rect(Rect2(0, 430, 3600, 12), Color("#4f7a35"))

    # Arboles
    for x in range(60, 3600, 230):
        var offset = sin(float(x) * 0.03) * 35
        draw_rect(Rect2(x + offset, 250, 28, 180), Color("#2b1c14"))
        draw_circle(Vector2(x + offset + 14, 220), 62, Color("#24502f"))
        draw_circle(Vector2(x + offset - 25, 245), 45, Color("#2d6037"))
        draw_circle(Vector2(x + offset + 48, 250), 48, Color("#2a5a34"))

    # Rocas y troncos
    draw_circle(Vector2(360, 414), 25, Color("#5a5145"))
    draw_circle(Vector2(520, 420), 18, Color("#665b4b"))
    draw_rect(Rect2(1110, 390, 110, 28), Color("#5b351f"))
    draw_circle(Vector2(1600, 414), 24, Color("#5a5145"))
    draw_rect(Rect2(2630, 397, 125, 26), Color("#5b351f"))

    # Peligros
    for p in hazard_positions:
        draw_colored_polygon(PoolVector2Array([
            Vector2(p.x - 22, 430),
            Vector2(p.x - 8, 392),
            Vector2(p.x + 4, 430)
        ]), Color("#b83b32"))
        draw_colored_polygon(PoolVector2Array([
            Vector2(p.x + 2, 430),
            Vector2(p.x + 17, 388),
            Vector2(p.x + 30, 430)
        ]), Color("#d05042"))

    # Primer enemigo de la selva
    if enemy_alive:
        draw_circle(Vector2(enemy_x, 350), 42, Color("#201512"))
        draw_circle(Vector2(enemy_x, 315), 27, Color("#4a2921"))
        draw_circle(Vector2(enemy_x - 8, 318), 4, Color("#ffcf55"))
        draw_circle(Vector2(enemy_x + 8, 318), 4, Color("#ffcf55"))
        draw_line(Vector2(enemy_x - 18, 350), Vector2(enemy_x - 38, 375), Color("#2a1b17"), 8)
        draw_line(Vector2(enemy_x + 18, 350), Vector2(enemy_x + 38, 375), Color("#2a1b17"), 8)
        draw_line(Vector2(enemy_x - 12, 375), Vector2(enemy_x - 20, 410), Color("#2a1b17"), 9)
        draw_line(Vector2(enemy_x + 12, 375), Vector2(enemy_x + 20, 410), Color("#2a1b17"), 9)
        draw_rect(Rect2(enemy_x - 55, 260, 110, 10), Color("#3a2424"))
        draw_rect(Rect2(enemy_x - 55, 260, 110.0 * (1.0 - float(guardian_hits) / float(guardian_max_hits)), 10), Color("#ff5a5a"))

    # Portal final: permanece bloqueado mientras el Guardian siga vivo
    var portal_center = Vector2(3180, 350)
    if enemy_alive:
        draw_circle(portal_center, 72, Color(0.35, 0.12, 0.12, 0.18))
        draw_arc(portal_center, 58, 0, PI * 2, 48, Color("#8b3d3d"), 8)
        draw_arc(portal_center, 42, 0, PI * 2, 48, Color("#d06a6a"), 4)
        draw_line(Vector2(3140, 310), Vector2(3220, 390), Color("#ff5a5a"), 8)
        draw_line(Vector2(3220, 310), Vector2(3140, 390), Color("#ff5a5a"), 8)
    else:
        draw_circle(portal_center, 72, Color(0.2, 0.7, 0.95, 0.15))
        draw_arc(portal_center, 58, 0, PI * 2, 48, Color("#71d8ff"), 8)
        draw_arc(portal_center, 42, 0, PI * 2, 48, Color("#c6f3ff"), 4)
        draw_circle(portal_center, 8, Color("#ffffff"))

    # Indicadores decorativos
    for p in coin_positions:
        draw_circle(p, 10, Color("#f4d35e"))
        draw_circle(p, 5, Color("#fff1a8"))

func _create_hazards():
    for i in range(hazard_positions.size()):
        var area = Area2D.new()
        area.name = "Peligro" + str(i + 1)
        area.position = hazard_positions[i]
        area.add_to_group("hazard")

        var shape = CollisionShape2D.new()
        var rect = RectangleShape2D.new()
        rect.extents = Vector2(30, 24)
        shape.shape = rect
        area.add_child(shape)
        add_child(area)

        area.connect("body_entered", self, "_on_hazard_body_entered")

func _create_coins():
    for i in range(coin_positions.size()):
        var area = Area2D.new()
        area.name = "Cristal" + str(i + 1)
        area.position = coin_positions[i]
        area.add_to_group("collectible")

        var shape = CollisionShape2D.new()
        var circle = CircleShape2D.new()
        circle.radius = 18
        shape.shape = circle
        area.add_child(shape)
        add_child(area)

        area.connect("body_entered", self, "_on_collectible_body_entered", [area])

func _create_exit():
    var area = Area2D.new()
    area.name = "PortalFinal"
    area.position = Vector2(3180, 350)

    var shape = CollisionShape2D.new()
    var circle = CircleShape2D.new()
    circle.radius = 72
    shape.shape = circle
    area.add_child(shape)
    add_child(area)

    area.connect("body_entered", self, "_on_exit_body_entered")

func _on_hazard_body_entered(body):
    if body.name != "Stikman" or game_over or finished:
        return

    health -= 1
    message_timer = 1.5
    body.position = Vector2(max(100, body.position.x - 90), 350)
    body.velocity = Vector2.ZERO

    if health <= 0:
        game_over = true
        body.set_physics_process(false)

    _update_ui()

func _on_collectible_body_entered(body, area):
    if body.name != "Stikman" or game_over or finished:
        return
    if not is_instance_valid(area):
        return
    if not area.is_in_group("collectible"):
        return

    coins += 1
    area.queue_free()
    message_timer = 0.6
    _update_ui()

func _on_exit_body_entered(body):
    if body.name != "Stikman" or game_over:
        return

    if enemy_alive:
        message_timer = 2.0
        _update_ui()
        return

    if not world1_ready:
        message_timer = 1.0
        _update_ui()
        return

    finished = true
    body.set_physics_process(false)
    _update_ui()

func _update_ui():
    var hud = get_node_or_null("HUD")
    if hud == null:
        return

    hud.get_node("Title").text = "STIKMAN - LOS MUNDOS PERDIDOS"
    hud.get_node("World").text = "PROLOGO: LA SELVA"
    hud.get_node("Stats").text = "VIDA: %d/3     CRISTALES: %d/%d" % [health, coins, coin_positions.size()]
    hud.get_node("Timer").text = "TIEMPO: %02d:%02d" % [int(elapsed) / 60, int(elapsed) % 60]

    if game_over:
        hud.get_node("Message").text = "HAS CAIDO EN LA SELVA\nPulsa F5 para volver a intentarlo"
    elif finished:
        hud.get_node("Message").text = "¡MUNDO 1 DESBLOQUEADO!\nBIENVENIDO AL MUNDO NORMAL"
    elif victory_timer > 0:
        hud.get_node("Message").text = "¡GUARDIAN DERROTADO!\nEL PORTAL SE ESTA ABRIENDO..."
    elif message_timer > 0:
        if not enemy_alive and not world1_ready:
            hud.get_node("Message").text = "¡GUARDIAN DERROTADO!\nACERCATE AL PORTAL"
        elif enemy_alive:
            hud.get_node("Message").text = "PORTAL BLOQUEADO\n¡DERROTA AL GUARDIAN PRIMERO!"
        else:
            hud.get_node("Message").text = "¡GUARDIAN DERROTADO!"
    elif enemy_alive:
        hud.get_node("Message").text = "¡GUARDIAN ADELANTE!  J para atacar  |  ENERGIA: %d/%d" % [guardian_max_hits - guardian_hits, guardian_max_hits]
    else:
        hud.get_node("Message").text = "Encuentra el portal al final de la selva"

