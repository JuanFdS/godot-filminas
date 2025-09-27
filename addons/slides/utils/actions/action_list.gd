class_name ActionList
extends RefCounted
var actions = []
var idx = 0

func process(delta: float):
	if idx <= 0:
		return
	actions[idx - 1].process(delta)

func do():
	if actions.size() <= idx:
		return false
	actions[idx].do()
	idx += 1
	return true

func undo():
	if idx <= 0:
		return false
	idx -= 1
	actions[idx].undo()
	return true

func reset():
	while idx > 0:
		undo()
