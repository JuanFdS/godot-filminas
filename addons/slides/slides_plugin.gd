@tool
extends EditorPlugin

const DIAPOSITIVAS = preload("res://addons/slides/diapositivas.tscn")
const CONTROLES_DE_PRESENTADOR = preload("res://addons/slides/controles-de-presentador/controles_de_presentador.tscn")

var controles_de_presentador

func _enter_tree():
	controles_de_presentador = CONTROLES_DE_PRESENTADOR.instantiate()
	add_control_to_container(
		EditorPlugin.CONTAINER_TOOLBAR,
		controles_de_presentador
	)
	InputMap.add_action("avanzar")
	var input_map = {
		"avanzar": [ KEY_KP_6, 1 ],
		"retroceder": [ KEY_KP_4, 2 ],
		"toggle_diapositivas": [ KEY_KP_5, 9 ],
		"accion_primaria": [ KEY_KP_7, 0 ],
		"accion_secundaria": [ KEY_KP_8, 3 ],
		"accion_terciaria": [ KEY_KP_9, 4 ],
		"toggle_run_scene": [ KEY_KP_1, 4 ],
	}
	
	for action in input_map.keys():
		var key = input_map[action][0]
		var input_event = InputEventKey.new()
		input_event.echo = false
		input_event.keycode = key
		input_event.ctrl_pressed = true
		
		for i in range(0,2):
			var joypad_button = input_map[action][1]
			var joypad_event = InputEventJoypadButton.new()
			joypad_event.button_index = joypad_button
			joypad_event.device = i
			if not InputMap.has_action(action):
				InputMap.add_action(action)
				#print("Action added: ", action)
			InputMap.action_add_event(action, input_event)
			InputMap.action_add_event(action, joypad_event)
			#print("Joypad event %s added for action %s" % [joypad_event, action])
	var full_screen_event = InputEventKey.new()
	full_screen_event.echo = false
	full_screen_event.keycode = KEY_ENTER
	full_screen_event.alt_pressed = true
	var full_screen_action_name = "toggle_fullscreen"
	if not InputMap.has_action(full_screen_action_name):
		InputMap.add_action(full_screen_action_name)
	InputMap.action_add_event(full_screen_action_name, full_screen_event)



func _exit_tree():
	if(controles_de_presentador):
		remove_control_from_container(
			EditorPlugin.CONTAINER_TOOLBAR,
			controles_de_presentador
		)
		controles_de_presentador.queue_free()
	[
		"avanzar",
		"retroceder",
		"toggle_diapositivas",
		"accion_primaria",
		"accion_secundaria",
		"accion_terciaria",
		"toggle_run_scene"
	].map(func(accion):
		if InputMap.has_action(accion):
			InputMap.erase_action(accion)
	)
