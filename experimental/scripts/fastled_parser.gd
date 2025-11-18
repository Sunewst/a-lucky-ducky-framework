class_name FastLEDParser

static func parse_code(editor: CodeEdit):
	#var script = GDScript.new()
	var code_editor_node: CodeEdit = CodeEdit.new()

	var loop_location: Vector2i = EditorHelper.get_loop_location(editor)
	var _setup_location: Vector2i = EditorHelper.get_setup_location(editor)
	var variable_locations: Array[Vector2i] = EditorHelper.find_total_data_types(editor)
	var functions_locations: Array[Vector2i] = EditorHelper.find_total_functions(editor)
	var operations_locations: Array[Vector2i] = EditorHelper.find_total_operations(editor)
	var control_statements_locations: Array[Vector2i] = EditorHelper.find_total_control_statements(editor)
	
	for i in editor.get_line_count():
		code_editor_node.insert_line_at(i, "")
	
	code_editor_node.insert_line_at(loop_location.y, "func _process(delta: float) -> void:")
	
	for function_location in functions_locations:
		var converted_function: String = _convert_function(editor, function_location)
		code_editor_node.insert_line_at(function_location.y, converted_function)

	for variable_location in variable_locations:
		var converted_variable: String = _convert_variable(editor, variable_location)
		code_editor_node.insert_line_at(variable_location.y, converted_variable)
		
	for operation_location in operations_locations:
		var converted_operator: String = _convert_operator(editor, operation_location)
		code_editor_node.insert_line_at(operation_location.y, converted_operator)
		
	for control_statement_location in control_statements_locations:
		var converted_control_statement: String = _convert_control_statements(editor, control_statement_location)
		code_editor_node.insert_line_at(control_statement_location.y, converted_control_statement)

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


static func _convert_operator(editor: CodeEdit, operator_location: Vector2i) -> String:
	var converted_operator: String

	var current_line: String = EditorHelper.remove_comments(editor.get_line(operator_location.y))

	current_line.replace(";", "")
	converted_operator = current_line

	return converted_operator


static func _convert_control_statements(editor: CodeEdit, control_location: Vector2i) -> String:
	var converted_control_statement: String

	var current_line: String = EditorHelper.remove_comments(editor.get_line(control_location.y))
	var line_control_statement: String = current_line.get_slice("(", 0).strip_edges()
	var control_parameters: String

	match line_control_statement:
		"if":
			control_parameters = current_line.get_slice("(", 1).get_slice(")", 0)
			converted_control_statement = "if %s:" % [control_parameters]

		"for":
			pass

		"while":
			control_parameters = current_line.get_slice("(", 1).get_slice(")", 0)
			converted_control_statement = "while %s:" % [control_parameters]

		"else":
			if current_line.contains("if"):
				control_parameters = current_line.get_slice("(", 1).get_slice(")", 0)
				converted_control_statement = "elif %s:" % [control_parameters]
			else:
				converted_control_statement = "else:"

	return converted_control_statement
