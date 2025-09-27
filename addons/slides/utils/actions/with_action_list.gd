@tool
class_name WithActionList extends Control

@onready var action_list: ActionList = ActionList.new()

func _process(delta: float):
	action_list.process(delta)

func accion_primaria():
	return action_list.do()

func accion_secundaria():
	return action_list.undo()
