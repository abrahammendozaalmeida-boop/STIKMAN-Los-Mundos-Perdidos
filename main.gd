extends Node2D

var coins = 0
var health = 3
var game_over = false
var finished = false
var victory_timer = 0.0
var world1_ready = false
var world1_mode = false
var world1_portal_x = 3300.0
var world1_items = 0
var world1_item_positions = [Vector2(720, 350), Vector2(1720, 350), Vector2(2700, 350)]
var world1_signal_collected = [false, false, false]
var world1_terminal_positions = [Vector2(450, 350), Vector2(1450, 350), Vector2(2450, 350)]
var world1_terminal_activated = [false, false, false]
var world1_door_open = false
var world1_key_collected = false
var world1_switch_activated = false
var world1_key_position = Vector2(2050, 350)
var world1_door_x = 2350.0
var world1_switch_position = Vector2(2900, 350)
var world1_box_position = Vector2(1800, 390)
var world1_box_moved = false
var world1_box_dialogue_shown = false
var world1_platform_x = 2550.0
var world1_platform_direction = 1.0
var world1_platform_speed = 70.0
var world1_box_on_switch = false
var world1_secret_gate_open = false
var world1_platform_unlocked = false
var world1_platform_body = null
var world1_platform_shape = null
var world1_rooftop_discovered = false
var world1_rooftop_message_shown = false
var world1_mystery_signal_found = false
var world1_mystery_clue_collected = false
var world1_mystery_clue_position = Vector2(2635, 220)
var world1_mystery_destination_found = false
var world1_mystery_destination_position = Vector2(3150, 285)
var world1_underground_mode = false
var world1_underground_lever_activated = false
var world1_underground_generator_activated = false
var world1_underground_gate_body = null
var world1_underground_gate_shape = null
var world1_box_body = null
var world1_box_shape = null
var world1_door_body = null

# Campaña del Mundo 1: 20 subniveles conectados
var world1_level = 1
var world1_level_count = 20
var world1_level_titles = [
    "La ciudad vacia", "La primera señal", "La estación apagada", "El camino bloqueado", "La puerta cerrada",
    "La llave perdida", "El interruptor", "La caja extraña", "La plataforma", "La señal desconocida",
    "El conducto", "La instalación subterranea", "La maquina desviadora", "La ruta oculta", "La ciudad en alerta",
    "El rastro", "La persecución", "La entrada final", "La antesala", "El guardian de la ciudad"
]
var world1_level_completed = false
var world1_door_shape = null
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

# Sistema de historia y dialogos
var dialogue_active = false
var dialogue_lines = []
var dialogue_index = 0
var dialogue_char_index = 0
var dialogue_char_timer = 0.0
var dialogue_char_speed = 0.025
var dialogue_can_advance = false
var dialogue_title = ""

# Sistema general de juego: guardado, menus, pausa y personalizacion
var game_started = false
var paused = false
var menu_layer = null
var menu_panel = null
var menu_title = null
var menu_info = null
var menu_buttons = []
var save_exists = false
var checkpoint_position = Vector2(180, 430)
var checkpoint_level = 1
var checkpoint_world = 1
var level_select_unlocked = 1
var checkpoint_message_timer = 0.0
var auto_save_timer = 0.0
var level_start_positions = [Vector2(220,350),Vector2(520,350),Vector2(850,350),Vector2(1180,350),Vector2(1500,350),Vector2(1800,350),Vector2(2100,350),Vector2(2400,350),Vector2(2700,350),Vector2(3000,350),Vector2(3150,350),Vector2(3800,350),Vector2(4050,350),Vector2(4250,350),Vector2(220,350),Vector2(850,350),Vector2(1500,350),Vector2(2100,350),Vector2(2750,350),Vector2(3300,350)]
var level_hazards = [
    ["Señal de energia", "Barrera baja", "Tuberia rota"],
    ["Cable electrico", "Vagon abandonado", "Anden roto"],
    ["Vapor", "Compuerta", "Vias bloqueadas"],
    ["Contenedor", "Grúa detenida", "Puente roto"],
    ["Puerta de seguridad", "Laser de mantenimiento", "Ascensor"],
    ["Charco electrico", "Generador", "Cables sueltos"],
    ["Interruptor", "Ventilador industrial", "Plataforma movil"],
    ["Caja metalica", "Prensa apagada", "Rampa"],
    ["Plataforma movil", "Cristal roto", "Salto entre edificios"],
    ["Señal desconocida", "Campo de energia", "Torre de control"],
    ["Conducto", "Ventilacion", "Tuberia"],
    ["Generador", "Compuerta pesada", "Pasarela"],
    ["Maquina desviadora", "Piston", "Campo magnetico"],
    ["Ruta de energia", "Puente suspendido", "Compuerta"],
    ["Alarma", "Barrera automatica", "Torreta de vigilancia"],
    ["Rastro de energia", "Puertas automaticas", "Zona inestable"],
    ["Persecucion", "Obstaculos moviles", "Pasarela colapsada"],
    ["Entrada final", "Puerta blindada", "Zona de peligro"],
    ["Antesala", "Mecanismos antiguos", "Plataformas elevadas"],
    ["Arena del guardian", "Nucleo de energia", "Plataformas de combate"]
]

var level_layouts = [
    [[420,460,240,18],[760,400,180,18],[1080,350,200,18]],
    [[500,430,160,18],[720,330,180,18],[1010,450,220,18],[1320,360,180,18]],
    [[420,470,220,18],[760,470,220,18],[1100,380,170,18],[1390,300,200,18]],
    [[450,420,180,18],[680,300,150,18],[930,390,210,18],[1240,470,170,18]],
    [[520,450,220,18],[850,350,180,18],[1120,260,170,18],[1410,380,220,18]],
    [[430,470,150,18],[650,380,150,18],[860,290,150,18],[1080,390,150,18],[1320,300,180,18]],
    [[500,430,180,18],[760,300,200,18],[1060,420,170,18],[1320,280,220,18]],
    [[450,470,220,18],[760,390,160,18],[980,300,160,18],[1210,420,200,18],[1500,330,180,18]],
    [[520,440,180,18],[760,320,180,18],[1000,220,180,18],[1250,330,180,18]],
    [[430,460,180,18],[680,360,180,18],[940,460,180,18],[1200,300,220,18],[1500,400,180,18]],
    [[500,450,200,18],[800,340,160,18],[1040,230,160,18],[1280,340,180,18]],
    [[430,470,180,18],[680,360,160,18],[900,250,180,18],[1160,400,180,18],[1420,300,180,18]],
    [[500,440,180,18],[760,280,180,18],[1030,390,180,18],[1300,220,200,18],[1570,350,180,18]],
    [[450,460,220,18],[760,350,160,18],[1000,250,160,18],[1240,360,160,18],[1480,280,220,18]],
    [[520,430,180,18],[800,300,200,18],[1080,420,180,18],[1360,300,180,18],[1640,220,200,18]],
    [[450,470,160,18],[650,350,150,18],[850,250,150,18],[1060,350,150,18],[1270,230,170,18]],
    [[500,440,180,18],[760,280,160,18],[980,400,160,18],[1200,260,180,18],[1450,380,180,18]],
    [[430,460,200,18],[700,330,160,18],[950,220,180,18],[1200,330,160,18],[1460,240,200,18]],
    [[500,420,220,18],[820,300,180,18],[1080,200,180,18],[1360,300,180,18],[1620,180,220,18]],
    [[460,440,180,18],[700,330,180,18],[940,240,180,18],[1180,330,180,18],[1420,220,180,18],[1680,300,220,18]]
]

var world1_parkour_segments = [
    [0, 520, 620, 455, 260, 70, "SALTO"],
    [620, 455, 980, 390, 300, 65, "SUBIDA"],
    [980, 390, 1380, 470, 330, 60, "BAJADA"],
    [1380, 470, 1780, 350, 330, 55, "ESCALADA"],
    [1780, 350, 2200, 430, 300, 65, "PUENTE"],
    [2200, 430, 2600, 300, 320, 55, "AZOTEAS"],
    [2600, 300, 3050, 440, 280, 70, "DESCENSO"],
    [3050, 440, 3500, 360, 350, 60, "CARRERA"]
]

var level_objectives = [
    "Encuentra la primera señal de energia.",
    "Lleva la señal hasta su nodo.",
    "Enciende la estacion apagada.",
    "Encuentra una forma de despejar el camino.",
    "Encuentra el mecanismo de la puerta.",
    "Encuentra la llave perdida.",
    "Activa el interruptor.",
    "Mueve la caja hasta descubrir el mecanismo.",
    "Activa y cruza con la plataforma.",
    "Encuentra la señal desconocida.",
    "Sigue el conducto subterraneo.",
    "Encuentra el control de la instalacion.",
    "Deten el desvio de energia.",
    "Sigue la ruta oculta.",
    "Reactiva el sistema de seguridad.",
    "Sigue el rastro de energia.",
    "Escapa de la persecucion.",
    "Alcanza la entrada final.",
    "Cruza la antesala.",
    "Derrota al guardian de la ciudad."
]

var level_start_dialogues = [
["La ciudad esta vacia.", "Hay algo que no encaja aqui.", "Tengo que encontrar una señal."],
["La señal me trajo hasta aqui.", "El camino continua.", "Debo seguir la energia."],
["La estacion sigue encendida.", "Pero nadie la esta controlando.", "Hay algo bloqueando el paso."],
["El camino esta bloqueado.", "Necesito encontrar otra forma de avanzar.", "Tal vez haya algo cerca que pueda mover."],
["Esta puerta no se abre.", "Debe existir algun mecanismo.", "Voy a buscar una forma de activarlo."],
["Alguien perdio una llave aqui.", "Si la encuentro, podre continuar.", "Tengo que revisar el camino."],
["Un interruptor controla parte del sistema.", "Si lo activo, algo deberia cambiar.", "Voy a probarlo."],
["Hay una caja extraña en el camino.", "Parece tener un proposito.", "Voy a averiguar para que sirve."],
["La plataforma se ha activado.", "Ahora puedo alcanzar lugares mas altos.", "El camino continua arriba."],
["Esta señal no se parece a las anteriores.", "Alguien esta manipulando la energia.", "Tengo que descubrir por que."],
["El conducto lleva la energia hacia abajo.", "La ciudad oculta algo bajo sus calles.", "Voy a seguir la ruta."],
["Estoy bajo la ciudad.", "Las maquinas siguen funcionando.", "La respuesta debe estar aqui."],
["Esta maquina esta desviando la energia.", "Alguien construyo este sistema.", "Tengo que encontrar su ruta."],
["La ruta oculta continua mas adelante.", "Cada señal apunta al mismo lugar.", "Ya casi entiendo que esta pasando."],
["La ciudad ha entrado en alerta.", "Algo detecto mi presencia.", "Tengo que avanzar antes de que sea tarde."],
["El rastro de energia sigue activo.", "No puedo perderlo.", "La respuesta esta cada vez mas cerca."],
["Algo me esta siguiendo.", "No puedo detenerme.", "Tengo que llegar a la entrada final."],
["Esta es la ultima entrada.", "Detras de ella debe estar la fuente.", "Me preparo para descubrir la verdad."],
["La antesala esta completamente vacia.", "Pero puedo sentir la energia al otro lado.", "Solo queda avanzar."],
["Llegue al final de la ciudad.", "Algo enorme esta protegiendo la salida.", "Si quiero continuar, tendre que enfrentarlo."]
]
var save_path = "user://stikman_save.json"
var settings_fullscreen = false
var outfit_id = 0
var owned_outfits = [true, false, false, false]
var outfit_names = ["Clasico", "Azul", "Rojo", "Explorador"]
var outfit_costs = [0, 25, 50, 75]

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
    _create_dialogue_ui()
    _create_hazards()
    _create_coins()
    _create_exit()
    _create_world1_door()
    _create_world1_platform()
    _create_world1_box()
    _create_world1_underground_zone()
    _load_save()
    _rebuild_level_geometry()
    _create_menu_ui()
    _show_main_menu()
    _update_ui()
    update()

func _process(delta):
    var player = get_node_or_null("Stikman")
    if game_started and not game_over and not finished and player != null and player.position.y > 620:
        _trigger_game_over(player)
        return

    _update_moving_level_objects(delta)
    _check_level_completion()
    _update_dialogue(delta)
    if game_started and not paused:
        auto_save_timer += delta
        if auto_save_timer >= 20.0:
            auto_save_timer = 0.0
            _save_game()
        if checkpoint_message_timer > 0.0:
            checkpoint_message_timer -= delta
    if not game_started:
        update()
        return
    if world1_mode and not dialogue_active:
        _update_world1_environment(delta)
        _check_world1_rooftop()
        _check_world1_mystery_clue()
        _check_world1_mystery_destination()
        # Si el dialogo se activo este mismo frame, no encadenamos otra transición.
        if not dialogue_active:
            _check_world1_underground()
    if not game_over and not finished and not dialogue_active:
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

        if not world1_mode:
            _update_enemy(delta)
            _check_attack()
            _check_enemy_contact()
        _update_ui()
    update()


func _notification(what):
    if what == NOTIFICATION_WM_QUIT_REQUEST:
        _save_game()
        get_tree().quit()

func _input(event):
    if event is InputEventKey and event.pressed and not event.echo and event.scancode == KEY_ESCAPE:
        if not game_started:
            return
        if dialogue_active:
            return
        if paused:
            _hide_pause_menu()
        else:
            _show_pause_menu()

func _create_menu_ui():
    menu_layer = CanvasLayer.new()
    menu_layer.name = "MenuLayer"
    add_child(menu_layer)

    menu_panel = Panel.new()
    menu_panel.name = "MenuPanel"
    menu_panel.rect_position = Vector2(250, 55)
    menu_panel.rect_size = Vector2(460, 480)
    menu_layer.add_child(menu_panel)

    menu_title = Label.new()
    menu_title.rect_position = Vector2(35, 25)
    menu_title.rect_size = Vector2(390, 45)
    menu_title.align = Label.ALIGN_CENTER
    menu_title.add_color_override("font_color", Color("#55dfff"))
    menu_panel.add_child(menu_title)

    menu_info = Label.new()
    menu_info.rect_position = Vector2(45, 75)
    menu_info.rect_size = Vector2(370, 55)
    menu_info.align = Label.ALIGN_CENTER
    menu_info.autowrap = true
    menu_panel.add_child(menu_info)

func _clear_menu_buttons():
    for button in menu_buttons:
        if is_instance_valid(button):
            button.queue_free()
    menu_buttons.clear()

func _add_menu_button(text_value, callback_name, y):
    var button = Button.new()
    button.text = text_value
    button.rect_position = Vector2(75, y)
    button.rect_size = Vector2(310, 42)
    button.connect("pressed", self, callback_name)
    menu_panel.add_child(button)
    menu_buttons.append(button)

func _show_main_menu():
    paused = false
    game_started = false
    var player = get_node_or_null("Stikman")
    if player != null:
        player.set_physics_process(false)
    _clear_menu_buttons()
    menu_panel.visible = true
    menu_title.text = "STIKMAN"
    menu_info.text = "LOS MUNDOS PERDIDOS\nMonedas: %d" % coins
    if save_exists:
        _add_menu_button("CONTINUAR PARTIDA", "_menu_continue", 145)
    else:
        _add_menu_button("NUEVA PARTIDA", "_menu_new_game", 145)
    _add_menu_button("SELECCIONAR NIVEL", "_menu_level_select", 195)
    _add_menu_button("PERSONALIZAR STIKMAN", "_menu_customize", 245)
    _add_menu_button("TIENDA", "_menu_shop", 295)
    _add_menu_button("AJUSTES", "_menu_settings", 345)
    _add_menu_button("SALIR", "_menu_exit", 395)

func _start_game():
    game_started = true
    paused = false
    dialogue_active = false
    menu_panel.visible = false
    var player = get_node_or_null("Stikman")
    if player != null:
        player.set_physics_process(true)
    if not world1_mode and not world1_ready and elapsed <= 0.1:
        _start_prologue_dialogue()
    _update_ui()
    update()

func _menu_continue():
    _load_save()
    _start_game()
    if world1_mode:
        _start_dialogue("STIKMAN", [
            "Ya recuerdo donde me quede.",
            "La pista sigue justo desde aqui.",
            "Tengo que continuar."
        ])

func _menu_new_game():
    _reset_game_state()
    _delete_save()
    _start_game()

func _show_game_over_menu():
    game_over = true
    paused = true
    var player = get_node_or_null("Stikman")
    if player != null:
        player.velocity = Vector2.ZERO
        player.set_physics_process(false)
    _clear_menu_buttons()
    menu_panel.visible = true
    menu_title.text = "HAS CAIDO"
    menu_info.text = "El progreso del nivel se conserva.\nCheckpoint: NIVEL %d" % checkpoint_level
    _add_menu_button("REAPARECER EN CHECKPOINT", "_menu_respawn", 175)
    _add_menu_button("MENU PRINCIPAL", "_menu_main_after_death", 230)
    _update_ui()

func _menu_respawn():
    _restart_from_checkpoint()

func _menu_main_after_death():
    _save_game()
    _show_main_menu()

func _show_pause_menu():
    paused = true
    _save_game()
    _clear_menu_buttons()
    menu_panel.visible = true
    menu_title.text = "PAUSA"
    menu_info.text = "Tu progreso se guardo automaticamente.\nNivel: %d/20  •  Monedas: %d" % [world1_level, coins]
    _add_menu_button("CONTINUAR", "_hide_pause_menu", 145)
    _add_menu_button("GUARDAR PARTIDA", "_menu_save", 195)
    _add_menu_button("PERSONALIZAR", "_menu_customize", 245)
    _add_menu_button("TIENDA", "_menu_shop", 295)
    _add_menu_button("AJUSTES", "_menu_settings", 345)
    _add_menu_button("MENU PRINCIPAL", "_menu_main_from_pause", 395)

func _hide_pause_menu():
    paused = false
    menu_panel.visible = false
    _clear_menu_buttons()

func _menu_main_from_pause():
    _save_game()
    _show_main_menu()

func _menu_save():
    _save_game()
    menu_info.text = "PARTIDA GUARDADA\nPuedes salir con tranquilidad."
    
func _menu_level_select():
    _clear_menu_buttons()
    menu_title.text = "SELECCIONAR NIVEL"
    menu_info.text = "Desbloqueados: 1 - %d" % level_select_unlocked
    var shown = min(level_select_unlocked, 20)
    for i in range(shown):
        var col = i % 2
        var row = int(i / 2)
        var button = Button.new()
        button.text = "NIVEL %d • %s" % [i + 1, world1_level_titles[i]]
        button.rect_position = Vector2(20 + col * 215, 120 + row * 29)
        button.rect_size = Vector2(205, 26)
        button.add_color_override("font_size", 12)
        button.connect("pressed", self, "_select_level_%d" % (i + 1))
        menu_panel.add_child(button)
        menu_buttons.append(button)
    _add_menu_button("VOLVER", "_menu_back", 430)

func _select_level_1(): _select_level(1)
func _select_level_2(): _select_level(2)
func _select_level_3(): _select_level(3)
func _select_level_4(): _select_level(4)
func _select_level_5(): _select_level(5)
func _select_level_6(): _select_level(6)
func _select_level_7(): _select_level(7)
func _select_level_8(): _select_level(8)
func _select_level_9(): _select_level(9)
func _select_level_10(): _select_level(10)
func _select_level_11(): _select_level(11)
func _select_level_12(): _select_level(12)
func _select_level_13(): _select_level(13)
func _select_level_14(): _select_level(14)
func _select_level_15(): _select_level(15)
func _select_level_16(): _select_level(16)
func _select_level_17(): _select_level(17)
func _select_level_18(): _select_level(18)
func _select_level_19(): _select_level(19)
func _select_level_20(): _select_level(20)

func _select_level(level_number):
    if level_number > level_select_unlocked:
        return
    world1_level = level_number
    world1_mode = true
    world1_level_completed = false
    _reset_level_interactive_state()
    _rebuild_level_geometry()
    checkpoint_level = level_number
    checkpoint_world = 1
    checkpoint_position = Vector2(220, 350)
    var player = get_node_or_null("Stikman")
    if player != null:
        player.position = checkpoint_position
        player.velocity = Vector2.ZERO
    _save_game()
    _start_game()

func _menu_customize():
    _clear_menu_buttons()
    menu_title.text = "PERSONALIZAR STIKMAN"
    menu_info.text = "Elige una apariencia desbloqueada."
    for i in range(outfit_names.size()):
        var label = "%s%s" % [outfit_names[i], "  ✓" if i == outfit_id else ""]
        if not owned_outfits[i]:
            label += "  • %d monedas" % outfit_costs[i]
        _add_menu_button(label, "_select_outfit_%d" % i, 125 + i * 55)
    _add_menu_button("VOLVER", "_menu_back", 355)

func _select_outfit_0(): _select_outfit(0)
func _select_outfit_1(): _select_outfit(1)
func _select_outfit_2(): _select_outfit(2)
func _select_outfit_3(): _select_outfit(3)

func _select_outfit(index):
    if not owned_outfits[index]:
        if coins < outfit_costs[index]:
            menu_info.text = "No tienes suficientes monedas."
            return
        coins -= outfit_costs[index]
        owned_outfits[index] = true
    outfit_id = index
    _save_game()
    _apply_outfit()
    _menu_customize()

func _apply_outfit():
    var player = get_node_or_null("Stikman")
    if player != null:
        player.outfit_id = outfit_id
        player.update()

func _menu_shop():
    _clear_menu_buttons()
    menu_title.text = "TIENDA"
    menu_info.text = "Monedas: %d\nDesbloquea ropa y apariencias." % coins
    for i in range(1, outfit_names.size()):
        var label = "%s  •  %d monedas" % [outfit_names[i], outfit_costs[i]]
        if owned_outfits[i]:
            label = "%s  •  COMPRADO" % outfit_names[i]
        _add_menu_button(label, "_shop_buy_%d" % i, 125 + (i - 1) * 65)
    _add_menu_button("VOLVER", "_menu_back", 345)

func _shop_buy_1(): _select_outfit(1)
func _shop_buy_2(): _select_outfit(2)
func _shop_buy_3(): _select_outfit(3)

func _menu_settings():
    _clear_menu_buttons()
    menu_title.text = "AJUSTES"
    menu_info.text = "Opciones básicas del juego."
    _add_menu_button("PANTALLA COMPLETA: " + ("SI" if settings_fullscreen else "NO"), "_toggle_fullscreen", 145)
    _add_menu_button("BORRAR PARTIDA GUARDADA", "_menu_delete_save", 200)
    _add_menu_button("VOLVER", "_menu_back", 270)

func _toggle_fullscreen():
    settings_fullscreen = not settings_fullscreen
    OS.window_fullscreen = settings_fullscreen
    _save_game()
    _menu_settings()

func _menu_delete_save():
    _delete_save()
    _reset_game_state()
    menu_info.text = "Partida eliminada. Puedes iniciar una nueva."
    _show_main_menu()

func _menu_back():
    if paused:
        _show_pause_menu()
    else:
        _show_main_menu()

func _menu_exit():
    _save_game()
    get_tree().quit()

func _save_game():
    var file = File.new()
    var data = {
        "world1_level": world1_level,
        "checkpoint_position_x": checkpoint_position.x,
        "checkpoint_position_y": checkpoint_position.y,
        "checkpoint_level": checkpoint_level,
        "checkpoint_world": checkpoint_world,
        "level_select_unlocked": level_select_unlocked,
        "world1_mode": world1_mode,
        "coins": coins,
        "outfit_id": outfit_id,
        "owned_outfits": owned_outfits,
        "elapsed": elapsed,
        "world1_signal_collected": world1_signal_collected,
        "world1_terminal_activated": world1_terminal_activated,
        "world1_ready": world1_ready,
        "world1_key_collected": world1_key_collected,
        "world1_door_open": world1_door_open,
        "world1_switch_activated": world1_switch_activated,
        "world1_box_position_x": world1_box_position.x,
        "world1_box_moved": world1_box_moved,
        "world1_box_on_switch": world1_box_on_switch,
        "world1_secret_gate_open": world1_secret_gate_open,
        "world1_platform_unlocked": world1_platform_unlocked,
        "world1_rooftop_discovered": world1_rooftop_discovered,
        "world1_mystery_signal_found": world1_mystery_signal_found,
        "world1_mystery_clue_collected": world1_mystery_clue_collected,
        "world1_mystery_destination_found": world1_mystery_destination_found,
        "world1_underground_lever_activated": world1_underground_lever_activated,
        "world1_underground_generator_activated": world1_underground_generator_activated
    }
    if file.open(save_path, File.WRITE) == OK:
        file.store_string(JSON.print(data))
        file.close()
        save_exists = true

func _load_save():
    var file = File.new()
    if not file.file_exists(save_path):
        save_exists = false
        return
    if file.open(save_path, File.READ) != OK:
        return
    var parsed = parse_json(file.get_as_text())
    file.close()
    if typeof(parsed) != TYPE_DICTIONARY:
        return
    save_exists = true
    world1_level = clamp(int(parsed.get("world1_level", 1)), 1, world1_level_count)
    checkpoint_position = Vector2(float(parsed.get("checkpoint_position_x", 180.0)), float(parsed.get("checkpoint_position_y", 430.0)))
    checkpoint_level = clamp(int(parsed.get("checkpoint_level", world1_level)), 1, world1_level_count)
    checkpoint_world = max(1, int(parsed.get("checkpoint_world", 1)))
    level_select_unlocked = clamp(int(parsed.get("level_select_unlocked", world1_level)), 1, world1_level_count)
    world1_mode = bool(parsed.get("world1_mode", false))
    coins = max(0, int(parsed.get("coins", 0)))
    outfit_id = clamp(int(parsed.get("outfit_id", 0)), 0, 3)
    var saved_outfits = parsed.get("owned_outfits", owned_outfits)
    if typeof(saved_outfits) == TYPE_ARRAY and saved_outfits.size() == owned_outfits.size():
        owned_outfits = saved_outfits
    elapsed = max(0.0, float(parsed.get("elapsed", 0.0)))
    world1_signal_collected = parsed.get("world1_signal_collected", world1_signal_collected)
    world1_terminal_activated = parsed.get("world1_terminal_activated", world1_terminal_activated)
    world1_ready = bool(parsed.get("world1_ready", world1_ready))
    world1_key_collected = bool(parsed.get("world1_key_collected", false))
    world1_door_open = bool(parsed.get("world1_door_open", false))
    world1_switch_activated = bool(parsed.get("world1_switch_activated", false))
    world1_box_position.x = float(parsed.get("world1_box_position_x", world1_box_position.x))
    world1_box_moved = bool(parsed.get("world1_box_moved", false))
    world1_box_on_switch = bool(parsed.get("world1_box_on_switch", false))
    world1_secret_gate_open = bool(parsed.get("world1_secret_gate_open", false))
    world1_platform_unlocked = bool(parsed.get("world1_platform_unlocked", false))
    world1_rooftop_discovered = bool(parsed.get("world1_rooftop_discovered", false))
    world1_mystery_signal_found = bool(parsed.get("world1_mystery_signal_found", false))
    world1_mystery_clue_collected = bool(parsed.get("world1_mystery_clue_collected", false))
    world1_mystery_destination_found = bool(parsed.get("world1_mystery_destination_found", false))
    world1_underground_lever_activated = bool(parsed.get("world1_underground_lever_activated", false))
    world1_underground_generator_activated = bool(parsed.get("world1_underground_generator_activated", false))
    var player = get_node_or_null("Stikman")
    if player != null:
        if world1_mode:
            player.position = checkpoint_position
        player.velocity = Vector2.ZERO
    _apply_outfit()

func _delete_save():
    var file = File.new()
    if file.file_exists(save_path):
        file.remove(save_path)
    save_exists = false

func _reset_game_state():
    coins = 0
    health = 3
    game_over = false
    finished = false
    elapsed = 0.0
    world1_level = 1
    checkpoint_level = 1
    checkpoint_world = 1
    level_select_unlocked = 1
    checkpoint_position = Vector2(180, 430)
    world1_mode = false
    world1_ready = false
    world1_items = 0
    world1_signal_collected = [false, false, false]
    world1_terminal_activated = [false, false, false]
    world1_door_open = false
    world1_key_collected = false
    world1_switch_activated = false
    world1_box_position = Vector2(1800, 390)
    world1_box_moved = false
    world1_box_on_switch = false
    world1_secret_gate_open = false
    world1_platform_unlocked = false
    world1_rooftop_discovered = false
    world1_mystery_signal_found = false
    world1_mystery_clue_collected = false
    world1_mystery_destination_found = false
    world1_underground_mode = false
    world1_underground_lever_activated = false
    world1_underground_generator_activated = false
    enemy_alive = true
    guardian_hits = 0
    outfit_id = 0
    owned_outfits = [true, false, false, false]
    var player = get_node_or_null("Stikman")
    if player != null:
        player.position = Vector2(180, 430)
        player.velocity = Vector2.ZERO
    _apply_outfit()
    _update_ui()
    update()

func _create_dialogue_ui():
    var layer = CanvasLayer.new()
    layer.name = "DialogueLayer"
    add_child(layer)

    var panel = Panel.new()
    panel.name = "DialoguePanel"
    panel.rect_position = Vector2(90, 355)
    panel.rect_size = Vector2(780, 145)
    panel.visible = false
    layer.add_child(panel)

    var title = Label.new()
    title.name = "DialogueTitle"
    title.rect_position = Vector2(22, 12)
    title.rect_size = Vector2(730, 28)
    title.text = "STIKMAN"
    title.add_color_override("font_color", Color("#55dfff"))
    panel.add_child(title)

    var text = Label.new()
    text.name = "DialogueText"
    text.rect_position = Vector2(22, 45)
    text.rect_size = Vector2(730, 60)
    text.autowrap = true
    text.text = ""
    panel.add_child(text)

    var continue_button = Button.new()
    continue_button.name = "DialogueContinue"
    continue_button.rect_position = Vector2(565, 108)
    continue_button.rect_size = Vector2(105, 28)
    continue_button.text = "CONTINUAR"
    continue_button.connect("pressed", self, "_on_dialogue_continue")
    panel.add_child(continue_button)

    var skip_button = Button.new()
    skip_button.name = "DialogueSkip"
    skip_button.rect_position = Vector2(680, 108)
    skip_button.rect_size = Vector2(75, 28)
    skip_button.text = "OMITIR"
    skip_button.connect("pressed", self, "_on_dialogue_skip")
    panel.add_child(skip_button)

func _start_dialogue(title, lines):
    if lines.empty():
        return
    dialogue_active = true
    dialogue_title = title
    dialogue_lines = lines
    dialogue_index = 0
    dialogue_char_index = 0
    dialogue_char_timer = 0.0
    dialogue_can_advance = false
    var panel = get_node_or_null("DialogueLayer/DialoguePanel")
    if panel != null:
        panel.visible = true
        panel.get_node("DialogueTitle").text = dialogue_title
        panel.get_node("DialogueContinue").text = "LEER..."
    _show_current_dialogue_line()

func _show_current_dialogue_line():
    if dialogue_index >= dialogue_lines.size():
        _finish_dialogue()
        return
    dialogue_char_index = 0
    dialogue_char_timer = 0.0
    dialogue_can_advance = false
    var panel = get_node_or_null("DialogueLayer/DialoguePanel")
    if panel != null:
        panel.get_node("DialogueText").text = ""

func _update_dialogue(delta):
    if not dialogue_active:
        return
    if dialogue_index >= dialogue_lines.size():
        _finish_dialogue()
        return
    var line = str(dialogue_lines[dialogue_index])
    if dialogue_char_index < line.length():
        dialogue_char_timer -= delta
        if dialogue_char_timer <= 0:
            dialogue_char_timer = dialogue_char_speed
            dialogue_char_index += 1
            var panel = get_node_or_null("DialogueLayer/DialoguePanel")
            if panel != null:
                panel.get_node("DialogueText").text = line.substr(0, dialogue_char_index)
    else:
        dialogue_can_advance = true
        var panel = get_node_or_null("DialogueLayer/DialoguePanel")
        if panel != null:
            panel.get_node("DialogueContinue").text = "CONTINUAR"

func _on_dialogue_continue():
    if not dialogue_active:
        return
    if not dialogue_can_advance:
        dialogue_char_index = str(dialogue_lines[dialogue_index]).length()
        dialogue_can_advance = true
        var panel = get_node_or_null("DialogueLayer/DialoguePanel")
        if panel != null:
            panel.get_node("DialogueText").text = str(dialogue_lines[dialogue_index])
            panel.get_node("DialogueContinue").text = "CONTINUAR"
        return
    dialogue_index += 1
    _show_current_dialogue_line()

func _on_dialogue_skip():
    if dialogue_active:
        _finish_dialogue()

func _finish_dialogue():
    dialogue_active = false
    dialogue_lines = []
    dialogue_index = 0
    dialogue_char_index = 0
    var panel = get_node_or_null("DialogueLayer/DialoguePanel")
    if panel != null:
        panel.visible = false

func _start_prologue_dialogue():
    _start_dialogue("STIKMAN", [
        "No recuerdo como llegue hasta aqui...",
        "La selva esta demasiado silenciosa. No parece que haya nadie.",
        "Pero alguien estuvo aqui antes que yo.",
        "Hay señales, caminos y algo extraño al fondo.",
        "Si quiero descubrir que paso, tendre que seguir adelante."
    ])

func _start_world1_dialogue():
    _start_dialogue("STIKMAN", [
        "Esto no es la selva...",
        "Es una ciudad. Todo parece normal... demasiado normal.",
        "Las maquinas siguen funcionando, pero no veo a una sola persona.",
        "Hay tres señales de energia repartidas por la ciudad.",
        "Tal vez descubra que ocurrio si logro volver cada señal a su nodo."
    ])

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
            _trigger_game_over(player)


func _check_level_completion():
    if not game_started or not world1_mode or dialogue_active or game_over or finished:
        return
    var player = get_node_or_null("Stikman")
    if player == null or world1_level_completed:
        return

    var completed = false
    if world1_level == 1:
        completed = world1_items >= 1
    elif world1_level == 2:
        completed = world1_terminal_activated[0] or world1_switch_activated
    elif world1_level == 3:
        completed = world1_terminal_activated[0] and world1_terminal_activated[1]
    elif world1_level == 4:
        completed = world1_box_moved or world1_switch_activated
    elif world1_level == 5:
        completed = world1_door_open or world1_switch_activated
    elif world1_level == 6:
        completed = world1_key_collected or world1_switch_activated
    elif world1_level == 7:
        completed = world1_switch_activated
    elif world1_level == 8:
        completed = world1_box_on_switch or world1_switch_activated
    elif world1_level == 9:
        completed = world1_platform_unlocked and player.position.x > 2650
    elif world1_level == 10:
        completed = world1_mystery_signal_found or world1_switch_activated
    elif world1_level == 11:
        completed = world1_mystery_destination_found or world1_switch_activated
    elif world1_level == 12:
        completed = world1_underground_mode or world1_switch_activated
    elif world1_level == 13:
        completed = world1_underground_lever_activated or world1_switch_activated
    elif world1_level == 14:
        completed = world1_underground_generator_activated or world1_switch_activated
    elif world1_level == 15:
        completed = world1_switch_activated and player.position.x > 1200
    elif world1_level == 16:
        completed = world1_switch_activated and player.position.x > 1200
    elif world1_level == 17:
        completed = world1_switch_activated and player.position.x > 1200
    elif world1_level == 18:
        completed = player.position.x > 1400
    elif world1_level == 19:
        completed = player.position.x > 1600
    elif world1_level == 20:
        completed = finished

    if completed:
        var next_index = min(world1_level, level_start_positions.size() - 1)
        _complete_world1_level(level_start_positions[next_index])

func _set_checkpoint(position_value):
    checkpoint_position = position_value
    checkpoint_level = world1_level
    checkpoint_world = 1
    if level_select_unlocked < world1_level:
        level_select_unlocked = world1_level
    checkpoint_message_timer = 2.5
    auto_save_timer = 0.0
    _save_game()

func _complete_world1_level(next_position):
    if world1_level_completed:
        return
    world1_level_completed = true

    if world1_level < world1_level_count:
        var next_level = world1_level + 1
        level_select_unlocked = max(level_select_unlocked, next_level)
        _start_world1_level(next_level)
        _start_dialogue("STIKMAN", [
            "Lo que encontre aqui no termina en esta zona.",
            "La pista continua justo delante.",
            "Tengo que seguir antes de que vuelva a desaparecer."
        ])
    else:
        finished = true
        _save_game()

    update()

func _check_world1_progress():
    var player = get_node_or_null("Stikman")
    if player == null:
        return

    var changed = false

    # Las señales se pueden recoger y después hay que regresar
    # al nodo correspondiente para activarlas.
    for i in range(world1_item_positions.size()):
        if not world1_signal_collected[i] and player.position.distance_to(world1_item_positions[i]) < 55:
            world1_signal_collected[i] = true
            world1_items += 1
            message_timer = 1.2
            changed = true

    for i in range(world1_terminal_positions.size()):
        if world1_signal_collected[i] and not world1_terminal_activated[i]:
            if player.position.distance_to(world1_terminal_positions[i]) < 70:
                world1_terminal_activated[i] = true
                message_timer = 1.2
                changed = true

    var all_activated = true
    for activated in world1_terminal_activated:
        if not activated:
            all_activated = false
            break

    if all_activated and not world1_ready:
        world1_ready = true
        message_timer = 3.0
        changed = true

    if changed:
        _update_ui()
        update()

func _check_world1_interactions():
    var player = get_node_or_null("Stikman")
    if player == null:
        return

    if world1_ready and not world1_key_collected and player.position.distance_to(world1_key_position) < 55:
        world1_key_collected = true
        if world1_door_shape != null:
            world1_door_shape.disabled = false
        message_timer = 1.5
        _update_ui()
        update()

    if world1_key_collected and not world1_door_open and player.position.distance_to(Vector2(world1_door_x, 350)) < 90:
        world1_door_open = true
        if world1_door_shape != null:
            world1_door_shape.disabled = true
        message_timer = 1.5
        _update_ui()
        update()

    if world1_door_open and not world1_switch_activated and player.position.distance_to(world1_switch_position) < 70:
        world1_switch_activated = true
        message_timer = 1.5
        _update_ui()
        update()

func _check_world1_underground():
    var player = get_node_or_null("Stikman")
    if player == null:
        return

    if world1_mystery_destination_found and not world1_underground_mode and player.position.distance_to(world1_mystery_destination_position) < 75:
        world1_underground_mode = true
        player.position = Vector2(3800, 350)
        player.velocity = Vector2.ZERO
        var camera = player.get_node_or_null("Camera2D")
        if camera != null:
            camera.limit_right = 4700
        message_timer = 2.5
        _start_dialogue("STIKMAN", [
            "El conducto baja hasta aqui.",
            "La energia de la ciudad llega a una maquina subterranea.",
            "Hay una palanca, una compuerta y un generador.",
            "Si alguien desvio la energia, aqui debe estar la respuesta."
        ])
        update()
        return

    if not world1_underground_mode:
        return

    if not world1_underground_lever_activated and player.position.distance_to(Vector2(4100, 350)) < 70:
        world1_underground_lever_activated = true
        if world1_underground_gate_shape != null:
            world1_underground_gate_shape.disabled = true
        message_timer = 2.0
        _start_dialogue("STIKMAN", [
            "La palanca sigue conectada al sistema.",
            "La compuerta se abrio.",
            "Ahora puedo llegar hasta el generador."
        ])
        update()
        return

    if world1_underground_lever_activated and not world1_underground_generator_activated and player.position.distance_to(Vector2(4500, 350)) < 80:
        world1_underground_generator_activated = true
        message_timer = 4.0
        _start_dialogue("STIKMAN", [
            "Este es el punto donde terminaba la energia.",
            "La maquina no estaba fallando: estaba desviandola.",
            "Hay una ruta de energia que sale de aqui y sigue hacia otro lugar.",
            "Ahora ya se donde empezar a buscar."
        ])
        update()
        return

    if world1_underground_generator_activated and player.position.distance_to(Vector2(3800, 350)) < 70:
        world1_underground_mode = false
        player.position = Vector2(3150, 350)
        player.velocity = Vector2.ZERO
        var camera = player.get_node_or_null("Camera2D")
        if camera != null:
            camera.limit_right = 3600
        message_timer = 3.0
        _start_dialogue("STIKMAN", [
            "Ya se donde termina el conducto.",
            "Pero la energia sigue viajando hacia otro sitio.",
            "La ciudad no fue el objetivo... solo fue el comienzo.",
            "Tengo que seguir la nueva ruta."
        ])
        update()

func _check_world1_mystery_destination():
    var player = get_node_or_null("Stikman")
    if player == null or not world1_mystery_clue_collected or world1_mystery_destination_found:
        return
    if player.position.distance_to(world1_mystery_destination_position) < 75:
        world1_mystery_destination_found = true
        message_timer = 3.0
        _start_dialogue("STIKMAN", [
            "La señal termina aqui...",
            "Hay un conducto subterraneo conectado al sistema.",
            "Alguien envio la energia hacia abajo.",
            "Si sigo este conducto, tal vez encuentre la fuente."
        ])
        update()

func _check_world1_mystery_clue():
    var player = get_node_or_null("Stikman")
    if player == null or not world1_mystery_signal_found or world1_mystery_clue_collected:
        return
    if player.position.distance_to(world1_mystery_clue_position) < 65:
        world1_mystery_clue_collected = true
        message_timer = 3.0
        _start_dialogue("STIKMAN", [
            "Hay una marca oculta en la señal.",
            "No parece una falla... alguien la dejo aqui.",
            "La energia fue desviada hacia otra parte de la ciudad.",
            "Entonces la cuarta señal no es un accidente.",
            "Tengo que encontrar hacia donde fue enviada."
        ])
        update()

func _check_world1_rooftop():
    var player = get_node_or_null("Stikman")
    if player == null or world1_rooftop_discovered:
        return
    # La plataforma lleva a una zona elevada con una señal misteriosa.
    if player.position.x > 2380 and player.position.x < 2750 and player.position.y < 285:
        world1_rooftop_discovered = true
        world1_mystery_signal_found = true
        message_timer = 3.0
        _start_dialogue("STIKMAN", [
            "¿Que es eso?",
            "Esta señal no pertenece a ninguna de las tres estaciones.",
            "Alguien estuvo manipulando la energia de esta ciudad.",
            "Tengo que descubrir quien lo hizo."
        ])
        update()

func _update_world1_environment(delta):
    var player = get_node_or_null("Stikman")
    if player == null:
        return

    # Caja empujable: ahora tiene colision real y puede moverse mas de una vez.
    if world1_box_body != null:
        world1_box_position = world1_box_body.position
    if abs(player.position.x - world1_box_position.x) < 58 and abs(player.position.y - 350) < 95:
        var push_direction = sign(player.position.x - world1_box_position.x)
        if push_direction == 0:
            push_direction = 1
        if abs(player.velocity.x) > 5:
            var new_box_x = clamp(world1_box_position.x + push_direction * abs(player.velocity.x) * delta, 1660, 2025)
            world1_box_position.x = new_box_x
            if world1_box_body != null:
                world1_box_body.position = world1_box_position
            if not world1_box_moved:
                world1_box_moved = true
            if not dialogue_active and not world1_box_dialogue_shown:
                world1_box_dialogue_shown = true
                _start_dialogue("STIKMAN", [
                    "Esta caja se puede mover...",
                    "¿Por que alguien dejaria esto justo aqui?",
                    "Tal vez este bloqueando algo."
                ])
            update()
    
    # La caja debe quedar sobre la placa para abrir el paso secreto.
    var switch_plate = Vector2(1960, 410)
    if world1_box_moved and world1_box_position.distance_to(switch_plate) < 55:
        if not world1_box_on_switch:
            world1_box_on_switch = true
            world1_secret_gate_open = true
            if not dialogue_active:
                _start_dialogue("STIKMAN", [
                    "¡Escuche algo!",
                    "La caja activo una placa oculta.",
                    "La plataforma de arriba acaba de encenderse.",
                    "Ahora puedo usarla para cruzar."
                ])
            update()

    # La plataforma se desbloquea al resolver la placa.
    if world1_secret_gate_open:
        world1_platform_unlocked = true
    if world1_platform_unlocked:
        world1_platform_x += world1_platform_direction * world1_platform_speed * delta
    _sync_world1_platform_collision()
    if world1_platform_x >= 2650:
        world1_platform_x = 2650
        world1_platform_direction = -1
    elif world1_platform_x <= 2450:
        world1_platform_x = 2450
        world1_platform_direction = 1
    update()

func _draw():
    if world1_mode:
        _draw_world1()
        return

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

func _draw_world1():
    if world1_underground_mode:
        _draw_world1_underground()
        return

    # Ciudad abandonada: arquitectura, carretera y servicios tienen una
    # funcion clara. La energia anomala se integra en instalaciones existentes.
    draw_rect(Rect2(0, 0, 3600, 540), Color("#6d8290"))
    draw_rect(Rect2(0, 0, 3600, 255), Color("#8195a0"))
    draw_circle(Vector2(760, 82), 48, Color("#d7d3bb"))

    # Horizonte y silueta de la ciudad.
    for x in range(40, 3600, 280):
        var h = 135 + int(abs(sin(float(x) * 0.031)) * 115)
        var facade = Color("#6b7072") if int(x / 280) % 2 == 0 else Color("#777b7b")
        draw_rect(Rect2(x, 430 - h, 205, h), facade)
        draw_rect(Rect2(x + 10, 430 - h, 185, 6), Color("#4e5457"))
        for row in range(4):
            for col in range(4):
                var wx = x + 28 + col * 40
                var wy = 430 - h + 32 + row * 43
                draw_rect(Rect2(wx, wy, 17, 24), Color("#a8b9bd"))
                draw_rect(Rect2(wx + 3, wy + 3, 11, 18), Color("#56676d"))

    # Edificios funcionales destacados: estacion, control y subestacion.
    draw_rect(Rect2(360, 300, 250, 130), Color("#555d61"))
    draw_rect(Rect2(375, 315, 220, 18), Color("#30383c"))
    draw_rect(Rect2(395, 350, 175, 58), Color("#3e484d"))
    for x in range(405, 565, 32):
        draw_rect(Rect2(x, 362, 18, 28), Color("#8da2a8"))
    draw_rect(Rect2(1180, 275, 250, 155), Color("#4d565a"))
    draw_rect(Rect2(1195, 290, 220, 28), Color("#273136"))
    draw_rect(Rect2(1240, 335, 135, 65), Color("#384247"))
    draw_rect(Rect2(1280, 245, 55, 30), Color("#68767a"))
    draw_rect(Rect2(2860, 285, 250, 145), Color("#4b5558"))
    draw_rect(Rect2(2880, 300, 210, 24), Color("#242d31"))
    draw_circle(Vector2(2985, 350), 28, Color("#4b6871"))
    draw_circle(Vector2(2985, 350), 13, Color("#8fd8e6"))

    # Calle: banqueta, asfalto, separadores y luminarias.
    draw_rect(Rect2(0, 408, 3600, 22), Color("#a2a2a0"))
    draw_rect(Rect2(0, 430, 3600, 110), Color("#303438"))
    draw_rect(Rect2(0, 430, 3600, 5), Color("#1f2326"))
    draw_rect(Rect2(0, 438, 3600, 3), Color("#565b5e"))
    for x in range(55, 3600, 145):
        draw_rect(Rect2(x, 482, 72, 5), Color("#c8b86d"))

    for x in range(160, 3500, 420):
        draw_line(Vector2(x, 408), Vector2(x, 315), Color("#2b3033"), 5)
        draw_line(Vector2(x, 315), Vector2(x + 34, 315), Color("#2b3033"), 4)
        draw_circle(Vector2(x + 40, 315), 7, Color("#d4c98c"))

    # Vehiculos detenidos: solo en la calle.
    for x in range(470, 3300, 610):
        draw_rect(Rect2(x, 388, 112, 35), Color("#4b5053"))
        draw_rect(Rect2(x + 16, 370, 78, 25), Color("#656d70"))
        draw_rect(Rect2(x + 25, 375, 28, 15), Color("#8ea6ad"))
        draw_rect(Rect2(x + 57, 375, 28, 15), Color("#8ea6ad"))
        draw_circle(Vector2(x + 22, 423), 11, Color("#1c2022"))
        draw_circle(Vector2(x + 90, 423), 11, Color("#1c2022"))

    # Tuberias visibles: conectan los edificios con la red de energia.
    draw_line(Vector2(610, 335), Vector2(1180, 335), Color("#3f484c"), 9)
    draw_line(Vector2(1430, 345), Vector2(2290, 345), Color("#3f484c"), 9)
    draw_line(Vector2(2290, 345), Vector2(2860, 330), Color("#3f484c"), 9)
    draw_circle(Vector2(610, 335), 7, Color("#6f7b80"))
    draw_circle(Vector2(1180, 335), 7, Color("#6f7b80"))

    # Plataformas jugables: ahora parecen estructuras urbanas reales.
    var layout = level_layouts[clamp(world1_level - 1, 0, level_layouts.size() - 1)]
    for item in layout:
        var platform_rect = Rect2(item[0] - item[2] / 2.0, item[1] - item[3] / 2.0, item[2], item[3])
        draw_rect(platform_rect, Color("#454d50"))
        draw_rect(Rect2(platform_rect.position, Vector2(platform_rect.size.x, 5)), Color("#9a9b91"))
        draw_line(
            platform_rect.position + Vector2(8, platform_rect.size.y - 4),
            platform_rect.position + Vector2(platform_rect.size.x - 8, platform_rect.size.y - 4),
            Color("#262b2d"),
            2
        )
        for bx in range(int(platform_rect.position.x) + 18, int(platform_rect.end.x) - 10, 38):
            draw_line(Vector2(bx, platform_rect.end.y), Vector2(bx - 5, platform_rect.end.y + 10), Color("#343b3e"), 3)

    # Señales de energia: cada una esta colocada sobre un nodo de la red.
    for i in range(world1_terminal_positions.size()):
        var terminal = world1_terminal_positions[i]
        draw_rect(Rect2(terminal.x - 30, 315, 60, 70), Color("#252c30"))
        draw_rect(Rect2(terminal.x - 22, 325, 44, 50), Color("#59666b"))
        draw_rect(Rect2(terminal.x - 13, 335, 26, 30), Color("#26363b"))
        draw_circle(terminal, 8, Color("#70d6e5") if world1_terminal_activated[i] else Color("#59676b"))
        draw_arc(terminal, 16, 0, PI * 2, 24, Color("#9beaf1") if world1_signal_collected[i] else Color("#69777b"), 3)

    # Señales recogibles: pequeñas fuentes de energia que flotan junto a la red.
    for i in range(world1_item_positions.size()):
        if not world1_signal_collected[i]:
            var item = world1_item_positions[i]
            draw_circle(item, 13, Color(0.3, 0.75, 0.85, 0.18))
            draw_arc(item, 13, 0, PI * 2, 20, Color("#b7edf2"), 2)
            draw_circle(item, 5, Color("#d9fbff"))

    # Llave y puerta: la llave pertenece al circuito de seguridad.
    if world1_ready and not world1_key_collected:
        draw_circle(world1_key_position, 10, Color("#d7b45c"))
        draw_rect(Rect2(world1_key_position.x - 4, world1_key_position.y - 4, 22, 8), Color("#e4c879"))
        draw_circle(world1_key_position + Vector2(17, 0), 5, Color("#f1d890"))

    if not world1_door_open:
        draw_rect(Rect2(world1_door_x - 24, 235, 48, 195), Color("#252b2e"))
        draw_rect(Rect2(world1_door_x - 17, 245, 34, 175), Color("#4d585c"))
        draw_rect(Rect2(world1_door_x - 10, 255, 20, 155), Color("#30383c"))
        draw_circle(Vector2(world1_door_x, 340), 7, Color("#d7b45c"))
    else:
        draw_rect(Rect2(world1_door_x - 4, 245, 8, 175), Color(0.35, 0.85, 0.7, 0.35))

    # Caja y placa: el peso de la caja activa fisicamente la placa.
    draw_rect(Rect2(world1_box_position.x - 38, 352, 76, 48), Color("#70543a"))
    draw_rect(Rect2(world1_box_position.x - 31, 359, 62, 34), Color("#9a7650"))
    draw_line(world1_box_position + Vector2(-24, -16), world1_box_position + Vector2(24, 16), Color("#4d3928"), 4)
    draw_line(world1_box_position + Vector2(24, -16), world1_box_position + Vector2(-24, 16), Color("#4d3928"), 4)
    var switch_plate = Vector2(1960, 410)
    draw_rect(Rect2(switch_plate.x - 46, 402, 92, 12), Color("#5f676a") if not world1_box_on_switch else Color("#65aeb0"))
    draw_circle(switch_plate, 7, Color("#899497") if not world1_box_on_switch else Color("#b8f4f2"))

    # Ruta secreta: una pasarela de mantenimiento, no un objeto aleatorio.
    if world1_secret_gate_open:
        draw_rect(Rect2(2760, 365, 300, 34), Color("#3f4b4f"))
        draw_rect(Rect2(2760, 365, 300, 5), Color("#73c7cf"))
        for x in range(2790, 3060, 45):
            draw_line(Vector2(x, 365), Vector2(x, 399), Color("#252b2e"), 3)
    else:
        draw_rect(Rect2(2760, 365, 300, 34), Color("#2b3033"))
        draw_line(Vector2(2760, 365), Vector2(3060, 399), Color("#50585b"), 3)

    # Plataforma movil: esta unida a la estructura superior.
    draw_line(Vector2(2450, 315), Vector2(2450, 255), Color("#454d50"), 5)
    draw_line(Vector2(2650, 315), Vector2(2650, 255), Color("#454d50"), 5)
    draw_rect(Rect2(world1_platform_x - 70, 300, 140, 18), Color("#4e585c"))
    draw_rect(Rect2(world1_platform_x - 70, 300, 140, 5), Color("#a1aaa8"))

    # Zona elevada y pista de la señal desconocida.
    if world1_rooftop_discovered:
        draw_rect(Rect2(2380, 245, 330, 18), Color("#454d50"))
        draw_rect(Rect2(2380, 245, 330, 5), Color("#a1d4d8"))
        draw_circle(Vector2(2635, 220), 12, Color("#d9fbff"))
        draw_arc(Vector2(2635, 220), 23 + sin(elapsed * 4) * 3, 0, PI * 2, 24, Color("#8bd9df"), 2)

    # Conducto: una entrada industrial reconocible que lleva a la zona subterranea.
    if world1_mystery_clue_collected:
        draw_rect(Rect2(3070, 270, 160, 120), Color("#252c30"))
        draw_rect(Rect2(3085, 285, 130, 105), Color("#101619"))
        draw_arc(Vector2(3150, 285), 55, PI, PI * 2, 24, Color("#78cdd5"), 5)
        draw_rect(Rect2(3138, 330, 24, 60), Color("#303a3e"))

    # Interruptor final conectado a la red.
    draw_line(Vector2(2860, 335), Vector2(world1_switch_position.x, world1_switch_position.y), Color("#59686c"), 6)
    draw_rect(Rect2(world1_switch_position.x - 22, 320, 44, 60), Color("#252c30"))
    draw_circle(world1_switch_position + Vector2(0, -5), 12, Color("#73cfd6") if world1_switch_activated else Color("#d7b45c"))
    draw_arc(world1_switch_position + Vector2(0, -5), 19, 0, PI * 2, 24, Color("#9beaf1") if world1_switch_activated else Color("#687477"), 2)

    # Portal: claramente marca la salida, no aparece hasta que el circuito esta activo.
    var p = Vector2(world1_portal_x, 350)
    if world1_switch_activated:
        draw_circle(p, 72, Color(0.25, 0.85, 0.95, 0.14))
        draw_arc(p, 58, 0, PI * 2, 48, Color("#65cbd5"), 7)
        draw_arc(p, 42, 0, PI * 2, 48, Color("#d8fbff"), 3)
        draw_circle(p, 8, Color("#ffffff"))
    else:
        draw_arc(p, 58, 0, PI * 2, 48, Color("#566064"), 6)
        draw_line(p + Vector2(-38, -38), p + Vector2(38, 38), Color("#30383c"), 7)
        draw_line(p + Vector2(38, -38), p + Vector2(-38, 38), Color("#30383c"), 7)

    # Elementos de conexion visibles de los niveles cortos.
    var interactive_parent = get_node_or_null("LevelInteractives")
    if interactive_parent != null:
        for interactive in interactive_parent.get_children():
            if interactive.has_meta("barrier_id"):
                var bx = interactive.position.x
                var by = interactive.position.y
                var open_now = world1_switch_activated
                draw_rect(Rect2(bx - 13, by - 65, 26, 130), Color("#424b4f") if not open_now else Color(0.3, 0.8, 0.7, 0.25))
                draw_line(Vector2(bx, by - 55), Vector2(bx, by + 55), Color("#9ca6a8") if not open_now else Color("#5eaa9b"), 5)
            elif interactive.has_meta("switch_id"):
                var sx = interactive.position.x
                var sy = interactive.position.y
                draw_line(Vector2(sx, sy + 18), Vector2(sx, sy + 55), Color("#3d474b"), 5)
                draw_rect(Rect2(sx - 21, sy - 17, 42, 34), Color("#343d41"))
                draw_circle(Vector2(sx, sy), 10, Color("#70d6e5") if world1_switch_activated else Color("#d7b45c"))
            elif interactive.has_meta("start_x"):
                var mx = interactive.position.x
                var my = interactive.position.y
                draw_line(Vector2(mx - 45, my - 20), Vector2(mx + 45, my - 20), Color("#454d50"), 4)
                draw_rect(Rect2(mx - 55, my - 10, 110, 20), Color("#5a6467"))
                draw_rect(Rect2(mx - 46, my - 6, 92, 5), Color("#b8a66d"))

func _draw_world1_underground():

    draw_rect(Rect2(3600, 0, 1100, 540), Color("#10171d"))
    draw_rect(Rect2(3600, 0, 1100, 430), Color("#18242b"))
    draw_rect(Rect2(3550, 430, 1200, 110), Color("#252b30"))
    draw_rect(Rect2(3550, 430, 1200, 10), Color("#3f6874"))
    draw_rect(Rect2(3970, 380, 260, 20), Color("#394b53"))
    draw_rect(Rect2(3970, 380, 260, 5), Color("#56e0ff"))

    draw_rect(Rect2(3760, 300, 80, 130), Color("#26343b"))
    draw_rect(Rect2(3775, 315, 50, 115), Color("#0a0f12"))
    draw_circle(Vector2(3800, 350), 9, Color("#56e0ff"))

    draw_line(Vector2(4100, 355), Vector2(4100, 315), Color("#777f84"), 8)
    draw_circle(Vector2(4100, 310), 13, Color("#56e0ff") if world1_underground_lever_activated else Color("#ffbd45"))
    draw_string(Control.new().get_theme_default_font(), Vector2(4040, 280), "PALANCA", Color("#d8fbff"))

    if world1_underground_lever_activated:
        draw_rect(Rect2(4302, 285, 36, 105), Color(0.25, 0.8, 0.65, 0.25))
    else:
        draw_rect(Rect2(4302, 285, 36, 105), Color("#59636b"))
        draw_rect(Rect2(4308, 292, 24, 90), Color("#7a8388"))

    draw_rect(Rect2(4440, 300, 120, 100), Color("#303a40"))
    draw_rect(Rect2(4455, 315, 90, 70), Color("#1a242a"))
    draw_circle(Vector2(4500, 350), 24, Color("#7dffe8") if world1_underground_generator_activated else Color("#4e6670"))
    draw_circle(Vector2(4500, 350), 10, Color("#ffffff") if world1_underground_generator_activated else Color("#263b45"))
    draw_line(Vector2(4500, 300), Vector2(4500, 255), Color("#56e0ff"), 5)
    draw_line(Vector2(4500, 255), Vector2(4630, 210), Color("#56e0ff"), 5)
    draw_arc(Vector2(4630, 210), 18 + sin(elapsed * 4) * 3, 0, PI * 2, 20, Color("#d8fbff"), 3)

    draw_string(Control.new().get_theme_default_font(), Vector2(3710, 470), "CONDUCTO SUBTERRANEO", Color("#8daab5"))
    draw_string(Control.new().get_theme_default_font(), Vector2(4380, 470), "ENERGIA DESVIADA", Color("#56e0ff"))

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

func _create_world1_box():
    world1_box_body = KinematicBody2D.new()
    world1_box_body.name = "CajaInteractiva"
    world1_box_body.position = world1_box_position
    world1_box_body.collision_layer = 1
    world1_box_body.collision_mask = 1
    add_child(world1_box_body)

    world1_box_shape = CollisionShape2D.new()
    var box_rect = RectangleShape2D.new()
    box_rect.extents = Vector2(38, 24)
    world1_box_shape.shape = box_rect
    world1_box_body.add_child(world1_box_shape)

func _create_world1_platform():
    world1_platform_body = KinematicBody2D.new()
    world1_platform_body.name = "PlataformaMovil"
    add_child(world1_platform_body)

    world1_platform_shape = CollisionShape2D.new()
    var rect = RectangleShape2D.new()
    rect.extents = Vector2(70, 9)
    world1_platform_shape.shape = rect
    world1_platform_body.add_child(world1_platform_shape)

    world1_platform_shape.disabled = true
    world1_platform_body.position = Vector2(world1_platform_x, 309)

func _sync_world1_platform_collision():
    if world1_platform_body == null:
        return
    world1_platform_body.position = Vector2(world1_platform_x, 309)
    world1_platform_shape.disabled = not world1_platform_unlocked

func _create_world1_underground_zone():
    var ground = StaticBody2D.new()
    ground.name = "UndergroundGround"
    ground.position = Vector2(4150, 500)
    var ground_shape = CollisionShape2D.new()
    var ground_rect = RectangleShape2D.new()
    ground_rect.extents = Vector2(600, 40)
    ground_shape.shape = ground_rect
    ground.add_child(ground_shape)
    add_child(ground)

    var upper = StaticBody2D.new()
    upper.name = "UndergroundUpperPlatform"
    upper.position = Vector2(4100, 390)
    var upper_shape = CollisionShape2D.new()
    var upper_rect = RectangleShape2D.new()
    upper_rect.extents = Vector2(130, 10)
    upper_shape.shape = upper_rect
    upper.add_child(upper_shape)
    add_child(upper)

    world1_underground_gate_body = StaticBody2D.new()
    world1_underground_gate_body.name = "UndergroundGate"
    world1_underground_gate_body.position = Vector2(4320, 390)
    world1_underground_gate_shape = CollisionShape2D.new()
    var gate_rect = RectangleShape2D.new()
    gate_rect.extents = Vector2(18, 110)
    world1_underground_gate_shape.shape = gate_rect
    world1_underground_gate_body.add_child(world1_underground_gate_shape)
    add_child(world1_underground_gate_body)

func _create_world1_door():
    world1_door_body = StaticBody2D.new()
    world1_door_body.name = "PuertaCiudad"
    world1_door_body.position = Vector2(world1_door_x, 340)
    world1_door_shape = CollisionShape2D.new()
    var rect = RectangleShape2D.new()
    rect.extents = Vector2(18, 90)
    world1_door_shape.shape = rect
    world1_door_body.add_child(world1_door_shape)
    add_child(world1_door_body)
    world1_door_shape.disabled = true

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
    if body.name != "Stikman" or game_over or finished or world1_mode:
        return

    health -= 1
    message_timer = 1.5
    body.position = Vector2(max(100, body.position.x - 90), 350)
    body.velocity = Vector2.ZERO

    if health <= 0:
        _trigger_game_over(body)
    else:
        _update_ui()

func _trigger_game_over(body):
    if game_over or finished:
        return
    game_over = true
    body.velocity = Vector2.ZERO
    body.set_physics_process(false)
    _save_game()
    _show_game_over_menu()

func _on_collectible_body_entered(body, area):
    if body.name != "Stikman" or game_over or finished:
        return

    if world1_mode:
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

    if not world1_mode and enemy_alive:
        message_timer = 2.0
        _update_ui()
        return

    if not world1_mode and not world1_ready:
        message_timer = 1.0
        _update_ui()
        return

    if world1_mode and not world1_switch_activated:
        message_timer = 2.0
        _update_ui()
        return

    if not world1_mode:
        world1_mode = true
        world1_ready = false
        _start_world1_dialogue()
        body.position = Vector2(220, 350)
        body.velocity = Vector2.ZERO
        var portal = get_node_or_null("PortalFinal")
        if portal != null:
            portal.position = Vector2(world1_portal_x, 350)
        message_timer = 3.0
        _update_ui()
        update()
        return

    finished = true
    body.set_physics_process(false)
    _update_ui()

func _show_level_intro(level_number):
    var index = clamp(level_number - 1, 0, level_start_dialogues.size() - 1)
    _start_dialogue("NIVEL %d • %s" % [level_number, world1_level_titles[index]], level_start_dialogues[index])

func _rebuild_level_geometry():
    _clear_level_geometry()
    _build_interactive_level_objects()
    _build_parkour_geometry()
    update()

func _clear_level_geometry():
    # Liberacion inmediata: evita que al cambiar/reaparecer se queden
    # plataformas o interactivos invisibles duplicados del nivel anterior.
    var parkour = get_node_or_null("LevelParkour")
    if parkour != null:
        remove_child(parkour)
        parkour.free()
    var interactives = get_node_or_null("LevelInteractives")
    if interactives != null:
        remove_child(interactives)
        interactives.free()

func _reset_level_interactive_state():
    world1_switch_activated = false

func _build_interactive_level_objects():
    var parent = Node2D.new()
    parent.name = "LevelInteractives"
    add_child(parent)

    var level = world1_level
    if level == 2 or level == 3:
        _create_level_switch(parent, Vector2(900, 330), "INTERRUPTOR", 1)
        _create_level_barrier(parent, Vector2(1180, 410), "COMPUERTA", 1)
    elif level == 4 or level == 5:
        _create_level_mover(parent, Vector2(900, 330), 100)
        _create_level_switch(parent, Vector2(1250, 360), "GRUA", 2)
        _create_level_barrier(parent, Vector2(1420, 360), "BLOQUEO", 2)
    elif level == 6 or level == 7:
        _create_level_switch(parent, Vector2(1050, 300), "GENERADOR", 3)
        _create_level_barrier(parent, Vector2(1350, 350), "BARRERA", 3)
    elif level == 8 or level == 9:
        _create_level_mover(parent, Vector2(1050, 260), 140)
        _create_level_switch(parent, Vector2(1450, 320), "PLATAFORMA", 4)
        _create_level_barrier(parent, Vector2(1600, 320), "PASO", 4)
    elif level >= 10 and level <= 15:
        _create_level_switch(parent, Vector2(1050, 250), "ENERGIA", 5)
        _create_level_barrier(parent, Vector2(1450, 330), "PUERTA", 5)
    elif level >= 16 and level <= 19:
        _create_level_mover(parent, Vector2(1100, 280), 180)
        _create_level_switch(parent, Vector2(1350, 300), "ALERTA", 6)
        _create_level_barrier(parent, Vector2(1500, 300), "BLOQUEO", 6)

func _create_level_switch(parent, pos, label_text, id):
    var area = Area2D.new()
    area.position = pos
    area.name = "Switch_%d" % id
    area.set_meta("switch_id", id)
    var shape = CollisionShape2D.new()
    var circle = CircleShape2D.new()
    circle.radius = 28
    shape.shape = circle
    area.add_child(shape)
    parent.add_child(area)
    area.connect("body_entered", self, "_on_level_switch_body_entered", [id, label_text])

func _create_level_barrier(parent, pos, label_text, id):
    var body = StaticBody2D.new()
    body.position = pos
    body.name = "Barrier_%d_%s" % [id, label_text]
    body.set_meta("barrier_id", id)
    var shape = CollisionShape2D.new()
    var rect = RectangleShape2D.new()
    rect.extents = Vector2(14, 65)
    shape.shape = rect
    body.add_child(shape)
    parent.add_child(body)

func _create_level_mover(parent, pos, distance):
    var body = KinematicBody2D.new()
    body.position = pos
    body.name = "MovingObstacle"
    body.set_meta("start_x", pos.x)
    body.set_meta("distance", distance)
    body.set_meta("phase", 0.0)
    var shape = CollisionShape2D.new()
    var rect = RectangleShape2D.new()
    rect.extents = Vector2(55, 12)
    shape.shape = rect
    body.add_child(shape)
    parent.add_child(body)

func _on_level_switch_body_entered(body, id, label_text):
    if body != get_node_or_null("Stikman") or dialogue_active:
        return
    world1_switch_activated = true
    var parent = get_node_or_null("LevelInteractives")
    if parent != null:
        for child in parent.get_children():
            if child.has_meta("barrier_id") and int(child.get_meta("barrier_id")) == int(id):
                var shape = child.get_child(0)
                if shape is CollisionShape2D:
                    shape.disabled = true
    get_node("HUD/Message").text = "%s ACTIVADO • CAMINO ABIERTO" % label_text
    message_timer = 1.5
    _save_game()
    update()

func _build_level_objects():
    var items = level_hazards[clamp(world1_level - 1, 0, level_hazards.size() - 1)]
    var player = get_node_or_null("Stikman")
    if player == null:
        return
    # El HUD muestra los elementos propios de la zona para que cada nivel
    # tenga identidad y objetivo visual distinto.
    if has_node("HUD/Message") and not dialogue_active:
        get_node("HUD/Message").text = "%s  •  %s  •  %s" % [items[0], items[1], items[2]]

func _build_parkour_geometry():
    var parent = Node2D.new()
    parent.name = "LevelParkour"
    add_child(parent)
    var layout = level_layouts[clamp(world1_level - 1, 0, level_layouts.size() - 1)]
    for item in layout:
        var body = StaticBody2D.new()
        body.position = Vector2(item[0], item[1])
        body.name = "LevelPlatform_%d_%d" % [int(item[0]), int(item[1])]
        var shape = CollisionShape2D.new()
        var rect = RectangleShape2D.new()
        rect.extents = Vector2(item[2] / 2.0, item[3] / 2.0)
        shape.shape = rect
        body.add_child(shape)
        parent.add_child(body)

func _draw_parkour_visuals():
    var layout = level_layouts[clamp(world1_level - 1, 0, level_layouts.size() - 1)]
    for item in layout:
        draw_rect(Rect2(item[0] - item[2] / 2.0, item[1] - item[3] / 2.0, item[2], item[3]), Color("#26332b"))

func _apply_level_terrain():
    # Cada tramo cambia la altura para evitar un recorrido plano.
    # Los elementos visuales/colisiones existentes se mantienen; aqui se
    # preparan zonas de subida, bajada y salto para la campaña.
    var player = get_node_or_null("Stikman")
    if player == null:
        return
    if world1_level <= 1:
        player.position.y = min(player.position.y, 430)
    elif world1_level <= 5:
        player.position.y = min(player.position.y, 390)
    elif world1_level <= 10:
        player.position.y = min(player.position.y, 340)
    else:
        player.position.y = min(player.position.y, 300)

func _start_world1_level(level_number):
    world1_level = clamp(level_number, 1, world1_level_count)
    world1_mode = true
    world1_ready = false
    world1_level_completed = false
    _reset_level_interactive_state()
    _rebuild_level_geometry()
    world1_items = 0
    world1_signal_collected = [false, false, false]
    world1_terminal_activated = [false, false, false]
    world1_key_collected = false
    world1_door_open = false
    world1_switch_activated = false
    world1_box_moved = false
    world1_box_on_switch = false
    world1_secret_gate_open = false
    world1_platform_unlocked = false
    world1_rooftop_discovered = false
    world1_mystery_signal_found = false
    world1_mystery_clue_collected = false
    world1_mystery_destination_found = false
    world1_underground_mode = false
    world1_underground_lever_activated = false
    world1_underground_generator_activated = false
    checkpoint_position = level_start_positions[world1_level - 1]
    checkpoint_level = world1_level
    checkpoint_world = 1
    level_select_unlocked = max(level_select_unlocked, world1_level)
    var player = get_node_or_null("Stikman")
    if player != null:
        player.position = checkpoint_position
        player.velocity = Vector2.ZERO
    _save_game()
    _update_ui()
    update()
    _show_level_intro(world1_level)

func _restart_from_checkpoint():
    world1_level = checkpoint_level
    world1_mode = true
    world1_level_completed = false
    _rebuild_level_geometry()
    var player = get_node_or_null("Stikman")
    if player != null:
        player.position = checkpoint_position
        player.velocity = Vector2.ZERO
        player.set_physics_process(true)
    health = 3
    game_over = false
    paused = false
    dialogue_active = false
    menu_panel.visible = false
    _clear_menu_buttons()
    checkpoint_message_timer = 2.0
    _update_ui()
    update()

func _update_ui():
    var hud = get_node_or_null("HUD")
    if hud == null:
        return

    hud.get_node("Title").text = "STIKMAN - LOS MUNDOS PERDIDOS"
    hud.get_node("World").text = "MUNDO 1 • NIVEL %d/20: %s" % [world1_level, world1_level_titles[world1_level - 1]] if world1_mode else "PROLOGO: LA SELVA"
    if has_node("HUD/Goal"):
        if world1_mode:
            get_node("HUD/Goal").text = "OBJETIVO: " + level_objectives[clamp(world1_level - 1, 0, level_objectives.size() - 1)]
        else:
            get_node("HUD/Goal").text = "OBJETIVO: Explora la selva, derrota al guardian y alcanza el portal."

    if world1_mode:
        var activated_count = 0
        for activated in world1_terminal_activated:
            if activated:
                activated_count += 1
        hud.get_node("Stats").text = "VIDA: %d/3     SEÑALES: %d/3     NODOS: %d/3" % [health, world1_items, activated_count]
    else:
        hud.get_node("Stats").text = "VIDA: %d/3     CRISTALES: %d/%d" % [health, coins, coin_positions.size()]
    hud.get_node("Timer").text = "TIEMPO: %02d:%02d" % [int(elapsed) / 60, int(elapsed) % 60]
    if world1_mode and world1_level_completed:
        hud.get_node("Message").text = "NIVEL %d COMPLETADO\nPREPARANDO LA SIGUIENTE PARTE DE LA HISTORIA" % world1_level

    if checkpoint_message_timer > 0.0:
        hud.get_node("Message").text = "CHECKPOINT GUARDADO\nNivel %d" % checkpoint_level
    elif game_over:
        hud.get_node("Message").text = "HAS CAIDO EN LA SELVA\nPulsa F5 para volver a intentarlo"
    elif finished:
        hud.get_node("Message").text = "¡MUNDO 2 DESBLOQUEADO!\nCONTINUA TU AVENTURA"
    elif victory_timer > 0:
        hud.get_node("Message").text = "¡GUARDIAN DERROTADO!\nEL PORTAL SE ESTA ABRIENDO..."
    elif message_timer > 0:
        if world1_mode:
            hud.get_node("Message").text = "MUNDO 1: REGRESA A LOS NODOS PARA ACTIVAR LAS SEÑALES"
        elif not enemy_alive and not world1_ready:
            hud.get_node("Message").text = "¡GUARDIAN DERROTADO!\nACERCATE AL PORTAL"
        elif enemy_alive:
            hud.get_node("Message").text = "PORTAL BLOQUEADO\n¡DERROTA AL GUARDIAN PRIMERO!"
        else:
            hud.get_node("Message").text = "¡GUARDIAN DERROTADO!"
    elif world1_underground_mode:
        if not world1_underground_lever_activated:
            hud.get_node("Message").text = "ENCUENTRA LA PALANCA\nABRE LA COMPUERTA"
        elif not world1_underground_generator_activated:
            hud.get_node("Message").text = "COMPUERTA ABIERTA\nLLEGA AL GENERADOR"
        else:
            hud.get_node("Message").text = "RUTA DESCUBIERTA\nREGRESA A LA ENTRADA"
    elif world1_mode:
        if world1_ready and not world1_key_collected:
            hud.get_node("Message").text = "¡LOS NODOS ESTAN ACTIVOS!\nBUSCA LA LLAVE"
        elif world1_key_collected and not world1_door_open:
            hud.get_node("Message").text = "LLAVE CONSEGUIDA\nREGRESA A LA PUERTA"
        elif world1_door_open and not world1_switch_activated:
            if world1_mystery_signal_found and not world1_mystery_clue_collected:
                hud.get_node("Message").text = "ENCUENTRA LA SEÑAL EXTRAÑA\nSUBE CON LA PLATAFORMA"
            elif world1_mystery_clue_collected:
                hud.get_node("Message").text = "LA ENERGIA FUE DESVIADA\nSIGUE LA PISTA"
            else:
                hud.get_node("Message").text = "PUERTA ABIERTA\nACTIVA EL INTERRUPTOR"
        elif world1_switch_activated:
            hud.get_node("Message").text = "¡CAMINO DESBLOQUEADO!\nVE AL PORTAL AZUL"
        elif world1_items < 3:
            hud.get_node("Message").text = "BUSCA LAS SEÑALES Y REGRESA A SU NODO"
        else:
            hud.get_node("Message").text = "¡TODAS LAS SEÑALES CONSEGUIDAS!\nREGRESA A CADA NODO"
    elif enemy_alive:
        hud.get_node("Message").text = "¡GUARDIAN ADELANTE!  J para atacar  |  ENERGIA: %d/%d" % [guardian_max_hits - guardian_hits, guardian_max_hits]
    else:
        hud.get_node("Message").text = "Encuentra el portal al final de la selva"


func _update_moving_level_objects(delta):
    var parent = get_node_or_null("LevelInteractives")
    if parent == null:
        return
    for child in parent.get_children():
        if child.has_meta("start_x"):
            var phase = float(child.get_meta("phase")) + delta
            child.set_meta("phase", phase)
            var start_x = float(child.get_meta("start_x"))
            var distance = float(child.get_meta("distance"))
            child.position.x = start_x + sin(phase * 1.7) * distance