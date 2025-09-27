@tool
extends CanvasItem

var diapositiva_actual: int : set = cambiar_diapositiva
var _controles_de_presentador

@export_tool_button("Avanzar")
var _avanzar = avanzar

@export_tool_button("Retroceder")
var _retroceder = retroceder


func controles_de_presentador():
	if(not is_instance_valid(_controles_de_presentador)):
		_controles_de_presentador = get_tree().root.find_children("ControlesDePresentador", "", true, false).front()
	return _controles_de_presentador


func _get_property_list():
	var properties = []

	properties.append({
		"name": "diapositiva_actual",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": ",".join(get_children().map(func(slide: Node): return slide.name)),
	})

	return properties

func _ready():
	cambiar_diapositiva(diapositiva_actual)

func _enter_tree():
	if(get_tree().edited_scene_root == self):
		EditorInterface.get_selection().selection_changed.connect(self.on_selection_changed)

func _exit_tree():
	if(get_tree().edited_scene_root == self):
		EditorInterface.get_selection().selection_changed.disconnect(self.on_selection_changed)

func on_selection_changed():
	var selection = EditorInterface.get_selection().get_selected_nodes()
	if(selection.size() == 1 and selection.front() in get_children()):
		cambiar_diapositiva(selection.front().get_index())

func cambiar_diapositiva(indice_nuevo):
	var indice_viejo = diapositiva_actual
	var indice_nuevo_corregido = clamp(indice_nuevo, 0, get_child_count() - 1)
	if(indice_viejo != indice_nuevo_corregido):
		salir()
		diapositiva_actual = indice_nuevo_corregido
		actualizar_diapositiva_visible()
		entrar()

func actualizar_diapositiva_visible():
	for diapositiva in get_children() as Array[Node2D]:
		var is_active := diapositiva.get_index() == diapositiva_actual
		diapositiva.visible = is_active
	if is_inside_tree() and get_tree().edited_scene_root == self:
		var scene_tree: Tree = get_tree().root\
			.find_children("", "SceneTreeEditor", true, false).front()\
			.find_children("", "Tree", false, false).front()
		if(not scene_tree.get_root()):
			return
		for i in range(0, get_child_count()):
			scene_tree.get_root().get_child(i).collapsed = true
		scene_tree.get_root().get_child(diapositiva_actual).collapsed = false
		var presentador = controles_de_presentador()
		if(not presentador._is_playing_slides()):
			presentador.diapositiva_actual = diapositiva_actual

func accion_primaria():
	if not intentar_en_diapositiva_activa("accion_primaria"):
		avanzar()

func accion_secundaria():
	intentar_en_diapositiva_activa("accion_secundaria")

func accion_terciaria():
	intentar_en_diapositiva_activa("accion_terciaria")

func accion_secundaria_continua(delta):
	intentar_en_diapositiva_activa("accion_secundaria_continua", [delta])

func accion_terciaria_continua(delta):
	intentar_en_diapositiva_activa("accion_terciaria_continua", [delta])

func entrar():
	intentar_en_diapositiva_activa("entrar")

func salir():
	intentar_en_diapositiva_activa("salir")

func intentar_en_diapositiva_activa(metodo, args = []):
	if(is_inside_tree() and diapositiva_activa().has_method(metodo) \
		and controles_de_presentador()._is_playing_slides() and get_tree().edited_scene_root != self):
		var result = diapositiva_activa().callv(metodo, args)
		if result is bool:
			return result
		return true
	return false


func diapositiva_activa():
	return get_child(diapositiva_actual)


func avanzar():
	cambiar_diapositiva(diapositiva_actual + 1)

func retroceder():
	cambiar_diapositiva(diapositiva_actual - 1)


func _physics_process(delta):
	if is_inside_tree() and get_tree().edited_scene_root == self:
		if is_action_pressed("avanzar"):
			avanzar()
			EditorInterface.get_selection().clear()
			EditorInterface.get_selection().add_node(diapositiva_activa())
		if is_action_pressed("retroceder"):
			retroceder()
			EditorInterface.get_selection().clear()
			EditorInterface.get_selection().add_node(diapositiva_activa())


func is_action_pressed(action):
	return InputMap.has_action(action) and Input.is_action_just_pressed(action)

func _notification(what):
	match what:
		NOTIFICATION_EDITOR_POST_SAVE:
			var presentador = controles_de_presentador()
			if(presentador._is_playing_slides()):
				presentador.cerrar()
				await get_tree().process_frame
				presentador.abrir()
