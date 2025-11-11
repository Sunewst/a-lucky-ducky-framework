extends Node

func _ready() -> void:
	if not DirAccess.dir_exists_absolute("user://save_data"):
		DirAccess.make_dir_absolute("user://save_data")


func save_flock():
	var board_save: FileAccess = FileAccess.open("user://save_data//board.save", FileAccess.WRITE)
	var pond_save: FileAccess = FileAccess.open("user://save_data//pond.save", FileAccess.WRITE)
	
	var pond_nodes = get_tree().get_nodes_in_group("World")
	var code_editor_nodes = get_tree().get_nodes_in_group("CodeEditor")
	
	for code_editor in code_editor_nodes:
		var node_data = code_editor.call("save")
		var json_string = JSON.stringify(node_data)

		board_save.store_line(json_string)
	
	for pond_node in pond_nodes:
		var node_data = pond_node.call("save")
		var json_string = JSON.stringify(node_data)

		pond_save.store_line(json_string)
