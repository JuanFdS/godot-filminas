class_name Utils

static func find_control(path: Array[String]):
	var node = EditorInterface.get_base_control()
	for pattern in path:
		node = node.find_child(pattern, true, false)
	return node
