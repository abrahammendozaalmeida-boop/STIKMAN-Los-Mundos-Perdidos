# Arquitectura técnica — STIKMAN: LOS MUNDOS PERDIDOS

## Principios

1. Compatible con Godot 3.5.3 y GDScript 1.0/3.x. No usar sintaxis exclusiva de Godot 4.
2. GLES2 y recursos de bajo coste como base.
3. Escenas pequeñas con responsabilidad única.
4. Los sistemas globales se comunican mediante señales y APIs pequeñas; evitar referencias rígidas entre escenas.
5. El juego debe iniciar desde `res://scenes/boot/boot.tscn` una vez completada la migración.
6. El proyecto existente se conserva en la rama `main`; la reconstrucción se realiza en `rebuild/v0.1-modular-foundation` para reducir riesgo.
7. No considerar un sistema terminado hasta probarlo en Godot 3.5.3 en Windows y revisar errores de ejecución.

## Estructura objetivo

```
project.godot
README.md
docs/
  DISENO_MAESTRO_V0_1.md
  ARQUITECTURA_TECNICA_GODOT_3_5.md
  PLAN_DE_PRUEBAS_V0_1.md
scenes/
  boot/boot.tscn
  menus/main_menu.tscn
  menus/settings_menu.tscn
  menus/pause_menu.tscn
  menus/level_select.tscn
  player/stikman.tscn
  levels/world_01/level_01_shipwreck.tscn
  ui/hud.tscn
  ui/dialogue_box.tscn
  objects/checkpoint.tscn
  objects/interactive_object.tscn
scripts/
  autoload/game_state.gd
  autoload/save_manager.gd
  autoload/audio_manager.gd
  autoload/scene_router.gd
  player/stikman_controller.gd
  player/stikman_visuals.gd
  levels/level_controller.gd
  systems/day_night_clock.gd
  systems/dialogue_controller.gd
  systems/interaction_system.gd
  systems/checkpoint.gd
  ui/main_menu.gd
  ui/settings_menu.gd
  ui/pause_menu.gd
  ui/hud.gd
resources/
  themes/
  translations/
  data/
assets/
  textures/
    jungle/
    city/
  backgrounds/
  characters/
  objects/
  audio/
```

Esta es la estructura objetivo, no una promesa de que todos los archivos ya existan. Crear solo las escenas y scripts que se usen en la fase actual.

## Responsabilidades de sistemas

### GameState (Autoload)
- Estado de sesión: mundo/nivel actual, salud, moneda, progreso, banderas de historia, estado de pausa y diálogo.
- No dibuja UI ni crea geometría.
- Emite señales cuando cambian datos importantes.
- La escena actual consulta el estado, pero no debe duplicar la autoridad del progreso.

### SaveManager (Autoload)
- Guardado versionado en `user://savegame.json` o ConfigFile si la estructura lo permite.
- Guardado automático en puntos de control, cambio de nivel y cambios de progreso importantes; guardado manual desde el menú.
- Validar claves y valores al cargar; si el archivo está corrupto, ofrecer una partida nueva sin crashear.
- Guardar versión del esquema, mundo/nivel, punto de control, salud, FruitMoney, coleccionables, banderas, hora del mundo y tiempo jugado.
- Escribir de forma segura usando archivo temporal cuando sea viable; no guardar nodos ni objetos de escena serializados directamente.

### SceneRouter (Autoload)
- Cambia de escena con rutas explícitas y verifica que la ruta exista.
- Desactiva entradas durante la transición y evita dos cambios simultáneos.
- No usar una escena monolítica para todas las pantallas.

### AudioManager (Autoload)
- Música de fondo y efectos por buses de audio.
- Cambios de volumen guardados en ajustes.
- No cargar muchos sonidos pesados en cada fotograma.

### StikmanController
- Nodo raíz `KinematicBody2D` con `CollisionShape2D`.
- Control de aceleración, frenado, salto, gravedad, caída y estados de movimiento.
- `move_and_slide(velocity, Vector2.UP)` de Godot 3.5.
- La lógica de colisión no debe depender de lo que dibuja el personaje.
- Separar, en lo posible, el controlador físico de las animaciones visuales.
- El controlador recibe entrada abstracta; teclado y controles táctiles alimentan las mismas acciones.

### InteractionSystem
- Detecta objetos dentro de un área pequeña y clara de interacción.
- Expone una acción contextual (por ejemplo, abrir, empujar, activar, hablar, trepar o recoger).
- Muestra el prompt correspondiente y ejecuta una sola acción válida.
- Evitar que múltiples objetos se activen a la vez por solapamiento accidental.

### DayNightClock
- Un ciclo completo dura 600 segundos de tiempo de juego.
- Mantiene una fase de día normalizada entre 0 y 1 y emite actualizaciones a la interfaz y a la iluminación.
- La iluminación se actualiza con suavidad y sin cambios bruscos.
- El reloj se pausa al pausar el juego o al salir al menú; al reanudar, se recupera la hora guardada.

### DialogueController
- Reproduce secuencias con texto, nombre del hablante y opción de avanzar.
- Las escenas con elección Sí/No devuelven un resultado mediante señal/callback.
- Las decisiones actualizan banderas de historia en GameState.
- Al cerrar cualquier diálogo, restaura el control y la pausa previa correctamente, incluso si se cambia de escena.

### Checkpoint
- Detecta la entrada del jugador.
- Reproduce un destello azul y un sonido corto.
- Guarda posición, nivel y estado de progreso relevante.
- Al morir, reinicia en el punto de control sin dejar velocidades, diálogos ni controles táctiles atascados.

## Entrada y controles

Crear acciones de entrada para `move_left`, `move_right`, `jump`, `crouch`, `run`, `attack`, `interact`, `pause` y, si se necesita, `climb_up`/`climb_down`.

- Teclado: acciones configurables, con valores por defecto sencillos.
- Móvil: el movimiento y salto usan controles táctiles; el botón de acción cambia según el contexto.
- Método de dirección táctil pendiente de confirmar. No ocultar la única manera de moverse detrás de un botón contextual.
- La UI no debe bloquear el área jugable ni crear entradas duplicadas cuando se usa teclado.

## Niveles y colisiones

- Cada nivel es una escena independiente.
- Los suelos, paredes, plataformas y peligros deben tener colisiones explícitas.
- No usar colisiones invisibles fuera de las necesarias para límites o detección; las áreas de detección deben estar identificadas y no actuar como suelo.
- Usar capas y máscaras de colisión documentadas.
- Los objetos móviles y cajas tendrán su propia escena y lógica.
- El diseño del nivel debe usar formas simples y fiables antes de añadir detalles visuales.

## UI y adaptación

- Menús en escenas `Control` independientes.
- Usar anclajes y contenedores para adaptarse a 960x540 en PC y distintas resoluciones de móvil.
- No depender de posiciones absolutas para todos los elementos.
- Separar HUD de pausa y diálogo.
- La pausa debe detener la simulación, el reloj y los enemigos, pero permitir interactuar con su propio menú.
- Ajustes deben guardarse y aplicarse realmente.

## Orden de implementación

1. Estructura base, configuración y arranque sin errores.
2. Controlador de Stikman y escena de prueba física.
3. Cámara, animación de movimiento y colisiones.
4. Sistema de escenas y menú principal.
5. Pausa, ajustes y selección de niveles.
6. Guardado/carga y puntos de control.
7. HUD, corazones y reloj de día/noche.
8. Interacciones y diálogos.
9. Primer nivel completo de isla/selva.
10. Arte, clima, audio, pulido y pruebas.

## Reglas de trabajo

- Cambios pequeños y revisables; commits descriptivos.
- Antes de reemplazar un archivo, comprobar su versión y dependencias.
- Mantener una rama de reconstrucción separada de `main`.
- No afirmar que el juego está probado en ejecución si no se ha ejecutado realmente en Godot.
- Al entregar cada etapa, indicar archivos creados, cómo probarlos y qué falta verificar.
