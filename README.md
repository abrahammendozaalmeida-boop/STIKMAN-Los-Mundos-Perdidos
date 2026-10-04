# STIKMAN: LOS MUNDOS PERDIDOS

Proyecto 2D de aventura, plataformas, exploración y puzles. Motor objetivo: **Godot 3.5.3**, con prioridad de rendimiento para equipos modestos.

## Dirección del proyecto

La visión y los sistemas previstos están documentados en:
- [Diseño maestro de la versión 0.1](docs/DISENO_MAESTRO_V0_1.md)
- [Arquitectura técnica Godot 3.5.3](docs/ARQUITECTURA_TECNICA_GODOT_3_5.md)
- [Plan de pruebas de la versión 0.1](docs/PLAN_DE_PRUEBAS_V0_1.md)

## Ramas

- `main`: versión anterior del prototipo.
- `rebuild/v0.1-modular-foundation`: reconstrucción modular en desarrollo.

La rama de reconstrucción separa menús, controlador del jugador, estado de juego, guardado, cambio de escenas y nivel inicial. No se debe considerar estable hasta ejecutar las pruebas de Godot y revisar los errores de ejecución.

## Controles de prueba actuales

- A / D o flechas: moverse.
- Espacio: saltar.
- Shift: correr.
- Esc: pausa.

## Alcance de la versión 0.1

Primero: menú funcional, movimiento, colisiones fiables, pausa, guardado/carga y primer tramo jugable de la isla/selva. Los anuncios, compras reales, multijugador, editor de niveles y mundos posteriores quedan para futuras actualizaciones.
