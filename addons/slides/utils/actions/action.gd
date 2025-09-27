class_name Action
extends RefCounted

var _do_action: Callable
var _undo_action: Callable
var _process: Callable

func _init(callbacks: Dictionary):
	_do_action = callbacks.get("do", func(): pass)
	_undo_action = callbacks.get("undo", func(): pass)
	_process = callbacks.get("process", func(delta: float): pass)

func do():
	await _do_action.call()

func undo():
	await _undo_action.call()

func process(delta: float):
	_process.call(delta)

func opposite():
	return Action.new({
		"do": self._undo_action,
		"undo": self._do_action,
	})

func and_do(other_action):
	return Action.new({
		"do": func():
			self._do_action.call()
			await other_action.do(),
		"undo": func():
			other_action.undo()
			await self._undo_action.call()
	})

func wait_and_do(other_action):
	return Action.new({
		"do": func():
			await self._do_action.call()
			await other_action.do(),
		"undo": func():
			await other_action.undo()
			await self._undo_action.call()
	})

func and_do_several(actions):
	var current_action = self
	for action in actions:
		current_action = current_action.and_do(action)
	return current_action

func and_do_several_waiting(actions):
	var current_action = self
	for action in actions:
		current_action = current_action.wait_and_do(action)
	return current_action

static func empty():
	return Action.new({"do": func(): return, "undo": func(): return})

static func make_visible(control):
	return Action.new({
		"do": func(): control.visible = true,
		"undo": func(): control.visible = false
	})

static func play_animation(animation_player: AnimationPlayer, animation: StringName):
	return Action.new({
		"do": (func():
			animation_player.play(animation)
			if(animation_player.get_animation(animation).loop_mode == Animation.LOOP_NONE):
				await animation_player.animation_finished),
		"undo": (func():
			animation_player.play_backwards(animation)
			if(animation_player.get_animation(animation).loop_mode == Animation.LOOP_NONE):
				await animation_player.animation_finished)
	})

## Cambia una propiedad de un nodo a un nuevo valor, si se pasa un interpolation_time > 0
## se interpola entre el valor actual y el nuevo con un tween.
static func change_property(node, property, new_value, interpolation_time: float = 0.0):
	var action = Action.empty()
	action._do_action = func():
		action.set_meta("old_value", node.get(property))
		if interpolation_time > 0.0:
			await Engine.get_main_loop().create_tween().tween_property(node, property, new_value, interpolation_time).finished
		else:
			node.set(property, new_value)
	action._undo_action = func():
		var old_value = action.get_meta("old_value")
		if interpolation_time > 0.0:
			await Engine.get_main_loop().create_tween().tween_property(node, property, old_value, interpolation_time).finished
		else:
			node.set(property, old_value)
		action.remove_meta("old_value")
	return action
