class_name FastLEDParser

static func parse_code(editor: CodeEdit):
	#var script = GDScript.new()
	var code_editor_node: CodeEdit = CodeEdit.new()
	var loop_location: Vector2i = EditorHelper.get_loop_location(editor)

	var editor_components_locations = get_code_components(editor)

	for i in editor.get_line_count():
		code_editor_node.insert_line_at(i, "")
	
	code_editor_node.insert_line_at(loop_location.y, "func _process(delta: float) -> void:")
	
	for function_location in editor_components_locations["function_initilzations"]:
		var converted_function: String = _convert_function(editor, function_location)
		code_editor_node.insert_line_at(function_location, converted_function)

	for variable_location in editor_components_locations["variable_initilzations"]:
		var converted_variable: String = _convert_variable(editor, variable_location)
		code_editor_node.insert_line_at(variable_location, converted_variable)
		
	for operation_location in editor_components_locations["variable_operations"]:
		var converted_operator: String = _convert_operator(editor, operation_location)
		code_editor_node.insert_line_at(operation_location, converted_operator)

	for control_statement_location in editor_components_locations["control_statements"]:
		var converted_control_statement: String = _convert_control_statements(editor, control_statement_location)
		code_editor_node.insert_line_at(control_statement_location, converted_control_statement)
		
	for function_call_location in editor_components_locations["function_calls"]:
		pass

	return code_editor_node.get_text()



static func _convert_function(editor: CodeEdit, function_location: int) -> String:
	var converted_function: String

	var current_line: String = EditorHelper.remove_comments(editor.get_line(function_location))
	var _return_type: String = current_line.get_slice(" ", 0)
	var function_name: String = current_line.get_slice(" ", 1).get_slice("(", 0)
	var function_parameters: String = current_line.get_slice("(", 1).get_slice(")", 0)
	
	for function_parameter in function_parameters.split(","):
		var variable_type = function_parameter.get_slice(" ", function_parameter.get_slice_count(" ") - 2)
		function_parameters = function_parameters.replace(variable_type, "")


	converted_function = "func %s (%s):" % [function_name, function_parameters]

	return converted_function


static func _convert_variable(editor: CodeEdit, data_type_location: int) -> String:
	var converted_variable: String

	var current_line: String = EditorHelper.remove_comments(editor.get_line(data_type_location))
	var variable_name: String = current_line.get_slice(" ", 1).get_slice("=", 0)
	var variable_value: String = current_line.get_slice("=", 1).replace(";", "")

	if variable_value.is_empty():
		converted_variable = "var %s;" % [variable_name]
	else:
		converted_variable = "var %s =%s" % [variable_name, variable_value]

	return converted_variable


static func _convert_operator(editor: CodeEdit, operator_location: int) -> String:
	var converted_operator: String

	var current_line: String = EditorHelper.remove_comments(editor.get_line(operator_location))

	current_line = current_line.replace(";", "")
	converted_operator = current_line

	return converted_operator


static func _convert_control_statements(editor: CodeEdit, control_location: int) -> String:
	var converted_control_statement: String

	var current_line: String = EditorHelper.remove_comments(editor.get_line(control_location))
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


static func _convert_function_calls(editor: CodeEdit):
	pass


static func get_code_components(editor: CodeEdit):
	var led_dictionary: Dictionary = {
		"variable_initilzations": [],
		"function_initilzations": [],
		"variable_operations": [],
		"control_statements": [],
		"function_calls": []
	}

	for i in editor.get_line_count():
		var current_line = editor.get_line(i).remove_chars("}").strip_edges()
		var loop_location = EditorHelper.get_loop_location(editor).y
		var setup_location = EditorHelper.get_setup_location(editor).y
		
		if i == loop_location or i == setup_location or current_line.is_empty():
			pass

		elif EditorHelper.contains_array(current_line, EditorHelper.DATA_TYPES):
			if current_line.contains("(") and not current_line.contains("="):
				led_dictionary["function_initilzations"].append(i)
			else:
				led_dictionary["variable_initilzations"].append(i)

		elif EditorHelper.contains_array(current_line, EditorHelper.CONTROL_STRUCTUERS):
			led_dictionary["control_statements"].append(i)
		elif current_line.contains("="):
			led_dictionary["variable_operations"].append(i)
		else:
			led_dictionary["function_calls"].append(i)
	
	return led_dictionary
