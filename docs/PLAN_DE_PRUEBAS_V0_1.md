# Plan de pruebas — versión 0.1

Las pruebas deben realizarse en Godot 3.5.3, primero en PC y luego en Android cuando exista exportación móvil.

## A. Arranque y menús
- [ ] El proyecto importa sin errores de análisis.
- [ ] La pantalla inicial aparece en la resolución configurada.
- [ ] Play inicia una partida nueva en el primer nivel.
- [ ] Continuar solo se habilita si existe una partida válida.
- [ ] Pausa abre el menú correcto y no deja correr la simulación detrás.
- [ ] Continuar desde pausa restaura movimiento y reloj.
- [ ] Reiniciar reinicia el nivel sin duplicar jugadores o HUD.
- [ ] Volver al menú no conserva la pausa activa.

## B. Movimiento y colisiones
- [ ] Izquierda/derecha funciona por teclado.
- [ ] Salto solo se activa con la acción configurada.
- [ ] Stikman cae y aterriza sobre plataformas visibles.
- [ ] No existen colisiones de suelo invisibles o desplazadas.
- [ ] El personaje no atraviesa el suelo ni queda atrapado en esquinas.
- [ ] La cámara sigue al personaje sin perder el área útil.
- [ ] Reiniciar no conserva velocidad residual.

## C. Guardado
- [ ] Guardado manual crea una partida.
- [ ] Cargar una partida válida restaura nivel, salud, moneda, checkpoint y reloj.
- [ ] Un archivo ausente inicia de forma segura.
- [ ] Un archivo corrupto no cierra el juego; el jugador recibe un mensaje y puede iniciar partida nueva.
- [ ] El progreso no se borra al volver al menú.

## D. Día y noche
- [ ] El reloj avanza durante el juego.
- [ ] Un ciclo completo dura 600 segundos de juego.
- [ ] Luz y fondo cambian gradualmente.
- [ ] La pausa detiene el reloj.
- [ ] Cargar restaura la fase guardada.
- [ ] Salir del juego no avanza el reloj offline por defecto.

## E. Interacciones y narrativa
- [ ] Solo el objeto objetivo muestra el prompt contextual.
- [ ] La acción activa un objeto una sola vez.
- [ ] El objeto cambia visualmente al activarse.
- [ ] Los diálogos bloquean el movimiento solo mientras están abiertos.
- [ ] Sí/No registra la elección y el control vuelve al jugador.
- [ ] Cambiar de escena durante una conversación no deja controles bloqueados.

## F. Rendimiento y presentación
- [ ] El juego es estable en la PC objetivo.
- [ ] Los efectos ambientales pueden reducirse desde ajustes.
- [ ] UI legible en ventana de PC y pantalla móvil.
- [ ] Volumen y ajustes se aplican realmente.
- [ ] No se declara terminada ninguna prueba que no se haya ejecutado en el dispositivo.
