@tool
extends WithActionList

@onready var logo_godot: TextureRect = $HBoxContainer/LogoGodot
@onready var logo_godot_2: TextureRect = $HBoxContainer/LogoGodot2
@onready var logo_godot_3: TextureRect = $HBoxContainer/LogoGodot3
@onready var instrucciones_volver_atras: Label = $InstruccionesVolverAtras
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var texto_de_instrucciones_volver_atras_original: String = instrucciones_volver_atras.text
@onready var ultima_accion: Label = $UltimaAccion

func _ready():
	action_list.actions = [
		Action.make_visible(logo_godot),
		Action.make_visible(instrucciones_volver_atras),
		Action.make_visible(logo_godot_2),
		Action.make_visible(logo_godot_3),
		Action.play_animation(animation_player, "new_animation"),
		Action.new({
			"do":
				(func():
					instrucciones_volver_atras.text = "Se pueden hacer acciones custom"
					instrucciones_volver_atras.modulate = Color.GREEN),
			"undo":
				(func():
					instrucciones_volver_atras.text = texto_de_instrucciones_volver_atras_original
					instrucciones_volver_atras.modulate = Color.WHITE)
		}),
		Action.make_visible(ultima_accion)
	]

func entrar():
	for logo in [logo_godot, logo_godot_2, logo_godot_3]:
		logo.visible = false
	instrucciones_volver_atras.visible = false
	ultima_accion.visible = false
	# Esta línea hace que se abra ESTE script en el editor:
	EditorInterface.edit_script(get_script())
	# Esta línea hace que se seleccione la pestaña Script:
	EditorInterface.get_base_control().find_child(tr("Script"), true, false).pressed.emit()

func salir():
	action_list.reset()
