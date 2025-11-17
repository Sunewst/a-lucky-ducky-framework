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
	var code_editor_node = CodeEdit.new()

	var loop_location = EditorHelper.get_loop_location(editor)
	var variable_locations = EditorHelper.find_total_data_types(editor, DATA_TYPES)
	var functions_locations = EditorHelper.find_total_functions(editor, DATA_TYPES)
	
	for function_location in functions_locations:
		var converted_function = _convert_function(editor, function_location)
		code_editor_node.set_line(function_location.y, converted_function)

	for variable_location in variable_locations:
		var converted_variable = _convert_variable(editor, variable_location)
		code_editor_node.set_line(variable_location.y, converted_variable)

	code_editor_node.set_line(loop_location.y, "test")

	return code_editor_node.get_text()



static func _convert_function(editor: CodeEdit, function_location: Vector2i):
	var current_line = EditorHelper.remove_comments(editor.get_line(function_location.y))
	var _return_type = current_line.get_slice(" ", 0)
	var function_name = current_line.get_slice(" ", 1).get_slice("(", 0)
	var function_parameters = current_line.get_slice("(", 1).get_slice(")", 0)

	var converted_function = "func %s (%s)" % [function_name, function_parameters]

	return converted_function


static func _convert_variable(editor: CodeEdit, data_type_location: Vector2i):
	var converted_variable 

	var current_line = EditorHelper.remove_comments(editor.get_line(data_type_location.y))
	var variable_name = current_line.get_slice(" ", 1).get_slice("=", 0)
	var variable_value = current_line.get_slice("=", 1).replace(";", "")
		
	if variable_value.is_empty():
		converted_variable = "var %s;" % [variable_name]
	else:
		converted_variable = "var %s =%s" % [variable_name, variable_value]

	return converted_variable
