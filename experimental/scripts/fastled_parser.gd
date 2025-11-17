class_name FastLEDParser

const CONTROL_STRUCTUERS: Array[String] = [
	"if",
	"if else",
	"while",
	"for",
]


const DATA_TYPES: Array[String] = [
	"int",
	"float",
	"void", #Not really a data type
]

static func parse_code(editor: CodeEdit):
	#var script = GDScript.new()
	var code_editor_node: CodeEdit = CodeEdit.new()

	var loop_location: Vector2i = EditorHelper.get_loop_location(editor)
	var variable_locations: Array[Vector2i] = EditorHelper.find_total_data_types(editor, DATA_TYPES)
	var functions_locations: Array[Vector2i] = EditorHelper.find_total_functions(editor, DATA_TYPES)
	
	for i in editor.get_line_count():
		code_editor_node.insert_line_at(i, "")
	
	code_editor_node.insert_line_at(loop_location.y, "func _process(delta: float) -> void:")
	
	for function_location in functions_locations:
		var converted_function: String = _convert_function(editor, function_location)
		code_editor_node.insert_line_at(function_location.y, converted_function)

	for variable_location in variable_locations:
		var converted_variable: String = _convert_variable(editor, variable_location)
		code_editor_node.insert_line_at(variable_location.y, converted_variable)
		
	print(code_editor_node.get_line_count())

	return code_editor_node.get_text()



static func _convert_function(editor: CodeEdit, function_location: Vector2i) -> String:
	var converted_function: String

	var current_line: String = EditorHelper.remove_comments(editor.get_line(function_location.y))
	var _return_type: String = current_line.get_slice(" ", 0)
	var function_name: String = current_line.get_slice(" ", 1).get_slice("(", 0)
	var function_parameters: String = current_line.get_slice("(", 1).get_slice(")", 0)

	converted_function = "func %s (%s)" % [function_name, function_parameters]

	return converted_function


static func _convert_variable(editor: CodeEdit, data_type_location: Vector2i) -> String:
	var converted_variable: String

	var current_line: String = EditorHelper.remove_comments(editor.get_line(data_type_location.y))
	var variable_name: String = current_line.get_slice(" ", 1).get_slice("=", 0)
	var variable_value: String = current_line.get_slice("=", 1).replace(";", "")
		
	if variable_value.is_empty():
		converted_variable = "var %s;" % [variable_name]
	else:
		converted_variable = "var %s =%s" % [variable_name, variable_value]

	return converted_variable
