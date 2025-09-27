@tool
class_name ControlesDePresentador extends Control

const REPRODUCTOR_DE_DIAPOSITIVAS = preload("res://addons/slides/reproductor-de-diapositivas/reproductor_de_diapositivas.tscn")
@onready var toggle_slides = %ToggleSlides

var diapositivas
var diapositiva_actual: int = 0 :
	set(nueva_diapositiva_actual):
		diapositiva_actual = nueva_diapositiva_actual
		if(_is_playing_slides()):
			diapositivas.diapositiva_actual = diapositiva_actual

func _ready():
	toggle_slides.pressed.connect(self.on_toggle_slides)

func on_toggle_slides():
	if(_is_playing_slides()):
		cerrar()
	else:
		abrir()

func abrir():
	if(not is_instance_valid(diapositivas)):
		diapositivas = REPRODUCTOR_DE_DIAPOSITIVAS.instantiate()
	EditorInterface.get_base_control().add_child(diapositivas, true)
	diapositivas.diapositiva_actual = diapositiva_actual

func cerrar():
	if(_is_playing_slides()):
		EditorInterface.get_base_control().remove_child(diapositivas)
		diapositivas.queue_free()
		diapositiva_actual = diapositivas.diapositiva_actual

func _process(delta):
	if(_is_playing_slides()):
		toggle_slides.text = "Parar"
	else:
		toggle_slides.text = "Arrancar"
	if Input.is_action_just_pressed("ui_cancel"):
		cerrar()
	if InputMap.has_action("toggle_diapositivas") and Input.is_action_just_pressed("toggle_diapositivas"):
		on_toggle_slides()
	if InputMap.has_action("toggle_fullscreen") and Input.is_action_just_pressed("toggle_fullscreen"):
		if(get_window().mode == Window.MODE_FULLSCREEN):
			get_window().mode = Window.MODE_MAXIMIZED
		else:
			get_window().mode = Window.MODE_FULLSCREEN
		

func _is_playing_slides():
	return is_instance_valid(diapositivas) and diapositivas.get_parent()
