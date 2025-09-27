@tool
extends Sprite2D

var speed = 200
@onready var velocity = Vector2(1, 1)

func _process(delta: float) -> void:
	if not ReproductorDeDiapositivas.es_padre_de(self):
		# Esto es si queremos que solamente se corra el código cuando se están
		# reproduciendo las diapositivas.
		# Es algo similar a usar if not Engine.is_editor_hint() para que código
		# de un script @tool no corra en el editor.
		return
	global_position += velocity * speed * delta
	if (to_global(get_rect().size).y) >= get_viewport_rect().size.y:
		velocity = velocity.bounce(Vector2.UP)
	if (to_global(get_rect().size).x) >= get_viewport_rect().size.x:
		velocity = velocity.bounce(Vector2.LEFT)
	if (to_global(get_rect().position).x) <= 0.0:
		velocity = velocity.bounce(Vector2.RIGHT)
	if (to_global(get_rect().position).y) <= 0.0:
		velocity = velocity.bounce(Vector2.DOWN)
