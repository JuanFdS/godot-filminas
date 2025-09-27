@tool # <- No olvidar poner tool, si no no va a correr en el editor.
extends Control

# Las filminas son nodos asi que pueden tener scripts y variables  ¯\_(ツ)_/¯
var tiempo_apretando_accion_secundaria: float = 0.0
var tiempo_apretando_accion_terciaria: float = 0.0

# Las diapositivas reciben ciertos mensajes si es que estan definidos,
# sobreescribir esos mensajes deja poner comportamiento en las mismas.
# Solo se ejecutan cuando se están reproduciendo las diapositivas, no
# si se está editando la escena diapositivas.tscn

## Se manda cuando la diapositiva pasa a ser la activa
func entrar():
	# Esta línea hace que se abra ESTE script en el editor:
	EditorInterface.edit_script(get_script())
	# Esta línea hace que se seleccione la pestaña Script:
	EditorInterface.get_base_control().find_child(tr("Script"), true, false).pressed.emit()
	
	actualizar_mensajito_de_tiempos()

## Se manda cuando la diapositiva deja de ser la activa
func salir():
	$HBoxContainer/LogoGodot.modulate = Color.WHITE

## Acciones se ejecutan cuando se presionan (como un just_pressed)
## la acciones "accion_primaria", "accion_secundaria" y "accion_terciaria"
## respectivamente.
##
## Los inputs de cada acción no están en el InputMap de ProjectSettings
## porque ese input map es para cuando el juego está corriendo y esto
## corre en el editor. Esos inputs están definidos por código en
## res://addons/slides/slides.gd

func accion_primaria():
	$HBoxContainer/LogoGodot.scale *= 1.1
	# El escalado creo que se resetea solo al hacer invisible y visible,
	# porque es hijo de un nodo container.

func accion_secundaria():
	$HBoxContainer/LogoGodot.scale *= 0.9

func accion_terciaria():
	$HBoxContainer/LogoGodot.modulate.a -= 0.1
	# En salir se vuelve a poner el modulate en blanco, así si se vuelve
	# a esta filmina vuelve a estar en el color normal

## Se ejecutan si se mantiene apretado "accion_secundaria" o
## "accion_terciaria"

func accion_secundaria_continua(delta: float):
	tiempo_apretando_accion_secundaria += delta 
	actualizar_mensajito_de_tiempos()

func accion_terciaria_continua(delta: float):
	tiempo_apretando_accion_terciaria += delta 
	actualizar_mensajito_de_tiempos()

func actualizar_mensajito_de_tiempos():
	$HBoxContainer/TiemposApretandoCadaAccion.text = \
		"Tiempo apretando accion secundaria: %.2f\nTiempo apretando accion terciara: %.2f" % [
			tiempo_apretando_accion_secundaria,
			tiempo_apretando_accion_terciaria
		]
