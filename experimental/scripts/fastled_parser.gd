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
	var script = GDScript.new()
	var code_editor_node = CodeEdit.new()

	var loop_location = EditorHelper.get_loop_location(editor)
	var variable_locations = EditorHelper.find_total_data_types(editor, DATA_TYPES)
	var functions_locations = EditorHelper.find_total_functions(editor, DATA_TYPES)
	
	return _convert_data_types(editor, variable_locations)


static func _convert_functions(editor: CodeEdit, functions_locations: Array[Vector2i]):
	var converted_functions: Array[String]

	for function_location in functions_locations:
		var current_line = EditorHelper.remove_comments(editor.get_line(function_location.y))
		var _return_type = current_line.get_slice(" ", 0)
		var function_name = current_line.get_slice(" ", 1).get_slice("(", 0)
		var function_parameters = current_line.get_slice("(", 1).get_slice(")", 0)

		var converted_function = "func %s (%s)" % [function_name, function_parameters]

		converted_functions.append(converted_function)
	
	return converted_functions


static func _convert_data_types(editor: CodeEdit, data_types_locations: Array[Vector2i]):
	var converted_data_types: Array[String]
	var converted_variable 
	for data_type_location in data_types_locations:
		var current_line = EditorHelper.remove_comments(editor.get_line(data_type_location.y))
		var variable_name = current_line.get_slice(" ", 1).get_slice("=", 0)
		var variable_value = current_line.get_slice("=", 1).replace(";", "")
		
		if variable_value.is_empty():
			converted_variable = "var %s;" % [variable_name]
		else:
			converted_variable = "var %s = %s;" % [variable_name, variable_value]
		
		converted_data_types.append(converted_variable)
	
	return converted_data_types
