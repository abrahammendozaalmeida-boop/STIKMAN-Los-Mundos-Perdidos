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
    _create_menu_ui()
    _show_main_menu()
    _update_ui()
    update()

func _process(delta):
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
    menu_panel.rect_size = Vector2(460, 430)
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
    var shown = min(level_select_unlocked, 8)
    for i in range(shown):
        _add_menu_button("NIVEL %d • %s" % [i + 1, world1_level_titles[i]], "_select_level_%d" % (i + 1), 115 + i * 38)
    _add_menu_button("VOLVER", "_menu_back", 430)

func _select_level_1(): _select_level(1)
func _select_level_2(): _select_level(2)
func _select_level_3(): _select_level(3)
func _select_level_4(): _select_level(4)
func _select_level_5(): _select_level(5)
func _select_level_6(): _select_level(6)
func _select_level_7(): _select_level(7)
func _select_level_8(): _select_level(8)

func _select_level(level_number):
    if level_number > level_select_unlocked:
        return
    world1_level = level_number
    world1_mode = true
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
            game_over = true
            player.set_physics_process(false)


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
        world1_level += 1
        level_select_unlocked = max(level_select_unlocked, world1_level)
    var player = get_node_or_null("Stikman")
    if player != null:
        player.position = next_position
        player.velocity = Vector2.ZERO
    checkpoint_position = next_position
    checkpoint_level = world1_level
    checkpoint_world = 1
    _save_game()
    _start_dialogue("STIKMAN", [
        "Lo que encontre aqui no termina en esta zona.",
        "La pista continua justo delante.",
        "Tengo que seguir antes de que vuelva a desaparecer."
    ])
    world1_level_completed = false
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
    draw_rect(Rect2(0, 0, 3600, 540), Color("#7fc8f2"))
    draw_circle(Vector2(720, 85), 55, Color("#fff1a8"))

    for x in range(120, 3500, 310):
        var h = 150 + int(abs(sin(float(x) * 0.07)) * 130)
        draw_rect(Rect2(x, 430 - h, 210, h), Color("#d9d2c3"))
        for row in range(3):
            for col in range(4):
                draw_rect(Rect2(x + 28 + col * 43, 430 - h + 42 + row * 45, 20, 28), Color("#8bc6df"))

    draw_rect(Rect2(0, 430, 3600, 110), Color("#45484d"))
    draw_rect(Rect2(0, 430, 3600, 12), Color("#c6c8c9"))

    for x in range(40, 3600, 120):
        draw_rect(Rect2(x, 480, 65, 8), Color("#e7d86d"))

    for x in range(80, 3500, 260):
        draw_rect(Rect2(x, 355, 18, 75), Color("#6b4329"))
        draw_circle(Vector2(x + 9, 340), 38, Color("#3f8f4a"))
        draw_circle(Vector2(x - 12, 350), 28, Color("#4ca957"))

    for x in range(400, 3300, 600):
        draw_rect(Rect2(x, 405, 100, 28), Color("#d94b45"))
        draw_rect(Rect2(x + 18, 390, 64, 22), Color("#b7d9e8"))
        draw_circle(Vector2(x + 22, 433), 12, Color("#202328"))
        draw_circle(Vector2(x + 78, 433), 12, Color("#202328"))

    # Nodos de energía: cada señal tiene un lugar específico al que hay
    # que regresar para activarla.
    for i in range(world1_terminal_positions.size()):
        var terminal = world1_terminal_positions[i]
        if world1_terminal_activated[i]:
            draw_rect(Rect2(terminal.x - 32, 315, 64, 70), Color("#1e9f8a"))
            draw_rect(Rect2(terminal.x - 20, 327, 40, 42), Color("#7dffe8"))
            draw_circle(terminal, 10, Color("#ffffff"))
        elif world1_signal_collected[i]:
            draw_rect(Rect2(terminal.x - 32, 315, 64, 70), Color("#d4a72c"))
            draw_rect(Rect2(terminal.x - 20, 327, 40, 42), Color("#ffe57d"))
            draw_circle(terminal, 10, Color("#ffffff"))
        else:
            draw_rect(Rect2(terminal.x - 32, 315, 64, 70), Color("#50555a"))
            draw_rect(Rect2(terminal.x - 20, 327, 40, 42), Color("#737a80"))
            draw_circle(terminal, 10, Color("#b8c0c5"))

    for i in range(world1_item_positions.size()):
        if not world1_signal_collected[i]:
            var item = world1_item_positions[i]
            draw_circle(item, 18, Color("#ffd85a"))
            draw_circle(item, 9, Color("#fff4b0"))
            draw_line(item + Vector2(-8, 0), item + Vector2(8, 0), Color("#ffffff"), 3)
            draw_line(item + Vector2(0, -8), item + Vector2(0, 8), Color("#ffffff"), 3)

    # Llave que aparece después de activar los tres nodos.
    if world1_ready and not world1_key_collected:
        draw_circle(world1_key_position, 16, Color("#f5c542"))
        draw_circle(world1_key_position, 7, Color("#fff3a1"))
        draw_line(world1_key_position + Vector2(12, 0), world1_key_position + Vector2(28, 0), Color("#f5c542"), 5)

    # Puerta que requiere la llave.
    if not world1_door_open:
        draw_rect(Rect2(world1_door_x - 18, 250, 36, 180), Color("#34383d"))
        draw_rect(Rect2(world1_door_x - 12, 260, 24, 160), Color("#5d646b"))
        draw_circle(Vector2(world1_door_x, 340), 6, Color("#ffd85a"))
    else:
        draw_rect(Rect2(world1_door_x - 6, 250, 12, 180), Color(0.25, 0.8, 0.65, 0.35))

    # Camino secreto: puede abrirse por el puzzle de la caja.
    if world1_secret_gate_open:
        draw_rect(Rect2(2760, 365, 300, 34), Color("#244e5b"))
        draw_rect(Rect2(2760, 365, 300, 6), Color("#56e0ff"))
        for x in range(2790, 3060, 45):
            draw_circle(Vector2(x, 382), 5, Color("#b9f8ff"))
    else:
        draw_rect(Rect2(2760, 365, 300, 34), Color("#30343a"))

    # Puzzle de la caja y placa.
    var switch_plate = Vector2(1960, 410)
    draw_rect(Rect2(switch_plate.x - 45, 402, 90, 12), Color("#56e0ff") if world1_box_on_switch else Color("#555b60"))
    draw_circle(switch_plate, 8, Color("#d8fbff") if world1_box_on_switch else Color("#777d82"))

    # Objetos interactivos del escenario.
    draw_rect(Rect2(world1_box_position.x - 38, 352, 76, 48), Color("#9b6a3d"))
    draw_rect(Rect2(world1_box_position.x - 30, 360, 60, 32), Color("#c18a50"))
    draw_line(world1_box_position + Vector2(-25, -18), world1_box_position + Vector2(25, 18), Color("#6b4528"), 4)
    draw_line(world1_box_position + Vector2(25, -18), world1_box_position + Vector2(-25, 18), Color("#6b4528"), 4)

    draw_rect(Rect2(world1_platform_x - 70, 300, 140, 18), Color("#59636b"))
    draw_rect(Rect2(world1_platform_x - 70, 300, 140, 5), Color("#62d9ff"))

    # Zona elevada descubierta con la plataforma.
    if world1_rooftop_discovered:
        draw_rect(Rect2(2380, 245, 330, 18), Color("#343f46"))
        draw_rect(Rect2(2380, 245, 330, 5), Color("#56e0ff"))
        draw_circle(Vector2(2635, 220), 18, Color("#b9f8ff"))
        draw_circle(Vector2(2635, 220), 9, Color("#ffffff"))
        if not world1_mystery_clue_collected:
            draw_arc(Vector2(2635, 220), 28 + sin(elapsed * 4) * 4, 0, PI * 2, 24, Color("#d8fbff"), 2)
        draw_string(Control.new().get_theme_default_font(), Vector2(2420, 230), "SEÑAL DESCONOCIDA", Color("#d8fbff"))

    # Destino de la cuarta señal: entrada al conducto.
    if world1_mystery_clue_collected:
        draw_rect(Rect2(3070, 270, 160, 120), Color("#20282e"))
        draw_rect(Rect2(3085, 285, 130, 105), Color("#0c1115"))
        draw_arc(Vector2(3150, 285), 55, PI, PI * 2, 24, Color("#56e0ff"), 5)
        if not world1_mystery_destination_found:
            draw_circle(Vector2(3150, 285), 10 + sin(elapsed * 4) * 3, Color("#d8fbff"))

    # Interruptor final.
    draw_rect(Rect2(world1_switch_position.x - 24, 320, 48, 60), Color("#34383d"))
    draw_circle(world1_switch_position + Vector2(0, -5), 13, Color("#56e0ff") if world1_switch_activated else Color("#ffbd45"))

    var p = Vector2(world1_portal_x, 350)
    if world1_switch_activated:
        draw_circle(p, 72, Color(0.25, 0.85, 0.95, 0.16))
        draw_arc(p, 58, 0, PI * 2, 48, Color("#56e0ff"), 8)
        draw_arc(p, 42, 0, PI * 2, 48, Color("#d8fbff"), 4)
        draw_circle(p, 8, Color("#ffffff"))
    else:
        draw_circle(p, 72, Color(0.35, 0.12, 0.12, 0.18))
        draw_arc(p, 58, 0, PI * 2, 48, Color("#8b3d3d"), 8)
        draw_line(p + Vector2(-38, -38), p + Vector2(38, 38), Color("#ff5a5a"), 8)
        draw_line(p + Vector2(38, -38), p + Vector2(-38, 38), Color("#ff5a5a"), 8)

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
        game_over = true
        body.set_physics_process(false)

    _update_ui()

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

func _start_world1_level(level_number):
    world1_level = clamp(level_number, 1, world1_level_count)
    world1_mode = true
    world1_ready = false
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
    var player = get_node_or_null("Stikman")
    if player != null:
        player.position = checkpoint_position
        player.velocity = Vector2.ZERO
    health = 3
    game_over = false
    paused = false
    menu_panel.visible = false
    checkpoint_message_timer = 2.0
    _update_ui()
    update()

func _update_ui():
    var hud = get_node_or_null("HUD")
    if hud == null:
        return

    hud.get_node("Title").text = "STIKMAN - LOS MUNDOS PERDIDOS"
    hud.get_node("World").text = "MUNDO 1 • NIVEL %d/20: %s" % [world1_level, world1_level_titles[world1_level - 1]] if world1_mode else "PROLOGO: LA SELVA"
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

