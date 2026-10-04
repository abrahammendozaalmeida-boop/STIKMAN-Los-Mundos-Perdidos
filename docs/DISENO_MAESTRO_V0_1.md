# STIKMAN: LOS MUNDOS PERDIDOS
## Documento maestro de diseño — versión 0.1

**Motor:** Godot 3.5.3  
**Plataformas objetivo:** Windows y Android  
**Género:** aventura 2D de plataformas, exploración y puzles con narrativa  
**Modo inicial:** un jugador  
**Prioridad:** movimiento, menús y primer mundo pulido  
**Estado:** diseño base aprobado; detalles señalados como pendientes no deben inventarse sin validación.

## 1. Visión del juego

El jugador controla a Stikman en una aventura 2D con físicas fáciles de entender, animación expresiva, exploración, puzles ambientales y una historia que se amplía mediante actualizaciones. La experiencia combina simplicidad de controles con escenarios de gran calidad, música ambiental y progresión de niveles.

Referencias de diseño: Red Ball (puzles y plataformas), Alto's Adventure (sencillez y atmósfera), Geometry Dash (progresión e interfaz de niveles), Beach Buggy (sistemas de menú), Minecraft (corazones, portales y referencias visuales), Terraria (exploración) y juegos narrativos de plataformas. Son referencias de ideas generales, no recursos que deban copiarse.

## 2. Historia y tono

Stikman despierta en una balsa después de un naufragio y descubre que está en una isla o selva desconocida. La aventura lo lleva por entornos y etapas de vida muy diferentes, conectados por acontecimientos y cinemáticas.

La historia inicial propuesta por el creador:
1. Isla y selva tras el naufragio.
2. Nado hacia una zona habitada; dos desconocidos lo ayudan a viajar en barco hacia una ciudad y un aeropuerto.
3. Vida familiar y trabajo en una mina de oro, con desafíos de parkour en instalaciones deterioradas.
4. Conflicto por la mina y recorrido legal para defenderla; un puente derrumbado complica el camino al juzgado.
5. Un astronauta lo invita a una oficina o instalación relacionada con una misión espacial.
6. La historia continúa hacia la Luna, la ciencia, las matemáticas, YouTube, los videojuegos y el regreso a casa; los detalles se desarrollarán conforme se construyan los mundos.

La idea de que la vida anterior de Stikman podría haber sido un sueño es una revelación secreta de largo plazo. Debe sugerirse con pistas ambiguas y psicológicas, sin confirmarla temprano ni convertirla en explicación obvia.

Cada mundo debe tener identidad propia y contexto breve al comenzar, como una pequeña introducción visual. Aun con cambios de escenario, la causa y efecto de la historia debe mantenerse.

## 3. Personaje

- Stikman representa a una persona normal.
- Silueta corporal uniforme y alargada, cabeza proporcional y escala coherente con los objetos del entorno.
- Su estado emocional se comunica principalmente con postura, ritmo, equilibrio, gestos y animaciones corporales; no necesita una cara detallada.
- Personalización prevista: color, ropa, zapatos, armas visuales y efectos de pasos.
- Las mejoras de movimiento son moderadas y equilibradas: aumentos temporales o controlados de velocidad y salto.
- Las armas pueden compartir daño y comportamiento básico; su diferencia inicial puede ser visual.
- La animación debe responder al estado físico real: suelo, aire, aterrizaje, pendiente, agua, escalera, empuje y daño.

## 4. Movimiento y juego

Acciones previstas, por etapas: caminar, correr, saltar, agacharse, deslizarse, atacar, nadar, trepar, usar escaleras, empujar cajas e interactuar con objetos.

Principios:
- Física predecible y colisiones visibles y ajustadas a la geometría real.
- No debe haber plataformas invisibles ni áreas de colisión sobrantes.
- Los objetos interactivos deben mostrar claramente cuándo se activan y animar su respuesta.
- Las pendientes afectan el movimiento: subir puede ser más lento y bajar puede facilitar el desplazamiento, sin quitar el control al jugador.
- Los botones de acción serán contextuales para evitar una interfaz saturada.
- La muerte devuelve al jugador al último punto de control activado.
- El punto de control será un cubo azul brillante inspirado en la idea de un teseracto, con animación y sonido corto original.
- Los corazones representan la salud.
- Los niveles incluyen exploración, puzles, plataformas, persecuciones, trampas y secretos.

## 5. Progresión y contenido

La intención es que el juego crezca a largo plazo y no tenga un final de contenido temprano. Cada mundo tendrá subniveles y una curva de dificultad variable; la cantidad final de niveles por mundo queda pendiente de convertir la lista del creador en una tabla definitiva. No se fijará un total arbitrario ni se borrarán sus cantidades propuestas.

- Se desbloquean niveles al completar el objetivo narrativo.
- Los jefes aparecen cuando lo justifica la historia, normalmente al cierre de un mundo o arco.
- Enemigos de dificultad creciente, con una temática visual inspirada en frutas y siluetas de Stikman; los jefes pueden incorporar accesorios que comuniquen su función y nivel de amenaza.
- Coleccionables: FruitMoney, estampas y recompensas de jefes o secretos.
- Armas y trajes se encontrarán en cofres, túneles, misiones opcionales o tienda.
- Las futuras actualizaciones podrán añadir mundos, niveles personalizados y modos nuevos.

## 6. Mundo 1 — isla y selva

El primer mundo comienza con el naufragio. Debe servir como tutorial natural y presentar movimiento, saltos, exploración, puntos de control, interacciones y primeros puzles.

Atmósfera:
- Arte vectorial con siluetas, formas simples bien resueltas, colores planos y degradados suaves.
- Capas de paralaje, profundidad, iluminación ambiental, niebla, lluvia, luces y movimiento ambiental moderado.
- Clima y hora del día adaptados al escenario.
- Un día completo del juego dura 10 minutos reales. El reloj de la interfaz debe mostrar la hora del mundo y el ciclo debe afectar la iluminación y la atmósfera.
- La partida guarda la hora del juego al guardar o salir. El tiempo fuera del juego no avanzará por defecto, salvo que el creador decida lo contrario.
- Fauna/enemigos con temática de monos y un jefe de gran tamaño inspirado en la idea de Godzilla, con diseño original y no una copia exacta.

## 7. Narrativa y decisiones

- Cinemáticas animadas para comienzos, transiciones, sucesos importantes y cierres de arco.
- Diálogos que permiten decisiones Sí/No cuando la escena lo amerite.
- Las decisiones pueden activar banderas, cambiar diálogos, recompensas o rutas opcionales, pero no deben bloquear permanentemente la campaña principal por una elección menor.
- La historia puede tener finales distintos en futuras versiones y secretos que abran contenido nuevo.
- Los diálogos deben poder pausarse, avanzarse y cerrarse correctamente; el control del jugador debe restaurarse siempre al terminar.

## 8. Interfaz y menús

### Inicio
- Pantalla de carga con crédito: “Created by @abrahamg4”.
- Menú principal con Play, tienda, acceso a contenido/mapas futuros y los accesos acordados.
- Play abre el mundo/campaña y una selección de niveles; inicialmente solo el primer nivel estará desbloqueado.
- Continuar debe cargar la partida guardada sin bloquear el juego ni producir cierres inesperados.

### Pausa
- Continuar, reiniciar, mapa y volver al menú principal.

### Ajustes
- Volumen, resolución en PC, idioma, calidad gráfica y opción de controles.
- Objetivo inicial de idiomas: español más cinco idiomas populares por decidir; no se implementan traducciones falsas: cada idioma se incorpora cuando haya textos revisados.
- Modo de ventana configurable en PC y pantalla completa prioritaria en móvil.
- Opciones gráficas ajustables para dispositivos modestos.

### Tienda y moneda
- Moneda del juego: **FruitMoney**, representada con un símbolo original de moneda y tres frutas.
- La versión 0.1 solo permite ganar moneda jugando; no incluye compras reales ni anuncios.
- La tienda inicial permite probar trajes, colores y objetos cosméticos; los precios y catálogo se balancearán.
- Los pagos y anuncios quedan fuera de la primera versión.

### Otros sistemas
- Guardado automático y manual.
- Tiempo jugado.
- Coleccionables, secretos y logros cuando la campaña base esté estable.
- Mapa visual de niveles con posición actual, progreso y atajos que se desbloquean.
- El editor de niveles personalizados queda para una actualización futura.

## 9. Arte y sonido

- Arte vectorial original.
- Personajes y objetos legibles contra el fondo; contraste suficiente para que plataformas y peligros se entiendan.
- Música ambiental diferente por mundo y adaptada al ritmo del nivel.
- Sonidos para pasos, saltos, aterrizajes, acciones, mecanismos, puntos de control, daño, agua, ambiente y menús.
- El arte y el audio deben optimizarse para equipos modestos y escalar con opciones gráficas.

## 10. Plataformas y rendimiento

- Godot 3.5.3.
- PC Windows y Android.
- Teclado y controles táctiles; la interfaz debe adaptarse al tamaño y orientación de pantalla.
- Un jugador en la versión 0.1.
- Prioridad de rendimiento: PC modesta del creador y dispositivos Android modestos.
- Multijugador, compras reales, anuncios, más idiomas, editor de niveles y mundos posteriores quedan fuera del alcance inicial.

## 11. Criterios de aceptación de la versión 0.1

La versión no se considera lista hasta que:
1. El menú principal, Play, continuar, pausa y ajustes funcionen.
2. Una partida nueva comience en el punto correcto.
3. Guardar y cargar no provoquen cierres ni bloqueos.
4. Stikman pueda moverse, saltar, aterrizar e interactuar de forma consistente.
5. Las colisiones coincidan con plataformas y objetos visibles.
6. El ciclo día/noche y reloj funcionen durante una sesión y con guardado/carga.
7. Los puntos de control guarden posición y progreso correctamente.
8. El primer tramo de selva tenga un objetivo claro, una interacción, un puzle y un cierre jugable.
9. El juego se pueda probar en Godot 3.5.3 sin errores de análisis.
10. Los gráficos y controles tengan una base adaptable a PC y móvil.

## 12. Pendientes que no deben inventarse

- Método exacto de movimiento táctil: joystick virtual o botones direccionales; el botón de acción sí será contextual.
- Diseño final de las cinco opciones de idioma adicionales.
- Lista definitiva y número de niveles por mundo.
- Diálogos completos, nombre de los NPC, decisiones y consecuencias.
- Balance exacto de salud, daño, moneda, precios y mejoras.
- Alcance exacto del jefe del primer mundo.
- Confirmar si habrá aceleración del tiempo del mundo mientras el juego está cerrado; por defecto, el reloj se guarda y se pausa fuera del juego.
