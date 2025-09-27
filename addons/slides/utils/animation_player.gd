@tool
extends AnimationPlayer

## AnimationPlayer que se reproduce cuando su padre pasa a estar visible.
## Si se agrega esto a un AnimationPlayer que es hijo de una diapositiva va a
## reproducirse automáticamente cuando la diapositiva pase a ser la activa
## (al hacerse activa se hace visible).

func _ready() -> void:
	(get_parent() as CanvasItem).visibility_changed.connect(func():
		if(get_parent().is_visible()):
			play("RESET")
			play(autoplay)
			seek(0)
		else:
			stop()
	)
