extends Node2D

func _ready():
    update()

func _draw():
    draw_rect(Rect2(0, 0, 3000, 540), Color("#10261b"))
    draw_circle(Vector2(700, 95), 55, Color("#d9e7c8"))

    var mountains = PoolVector2Array([
        Vector2(0, 360),
        Vector2(250, 170),
        Vector2(480, 360),
        Vector2(720, 145),
        Vector2(980, 360),
        Vector2(1250, 180),
        Vector2(1540, 360),
        Vector2(1800, 150),
        Vector2(2100, 360),
        Vector2(2400, 180),
        Vector2(2700, 360),
        Vector2(3000, 160),
        Vector2(3000, 540),
        Vector2(0, 540)
    ])

    draw_colored_polygon(mountains, Color("#173a28"))
    draw_rect(Rect2(0, 430, 3000, 110), Color("#3b291c"))
    draw_rect(Rect2(0, 430, 3000, 12), Color("#4f7a35"))

    for x in range(70, 3000, 260):
        draw_rect(Rect2(x, 250, 28, 180), Color("#2b1c14"))
        draw_circle(Vector2(x + 14, 220), 62, Color("#24502f"))
        draw_circle(Vector2(x - 25, 245), 45, Color("#2d6037"))
        draw_circle(Vector2(x + 48, 250), 48, Color("#2a5a34"))

    draw_rect(Rect2(620, 385, 70, 45), Color("#765031"))
    draw_rect(Rect2(1120, 365, 95, 65), Color("#765031"))
    draw_rect(Rect2(1750, 395, 55, 35), Color("#765031"))
