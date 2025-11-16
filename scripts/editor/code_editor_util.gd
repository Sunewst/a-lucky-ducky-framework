class_name EditorHelper extends Node


static func find_total_occurrences(text: String, editor: CodeEdit) -> Array[Vector2i]:
	var _occurences_locations: Array[Vector2i]
	var _current_line_location: Vector2i = Vector2i(0, 0)
	var _occurence: Vector2i

	for i in editor.get_line_count():
		_occurence = editor.search(text, 2, _current_line_location.y + 1, 0)
		var _current_line = editor.get_line(_occurence.y).get_slice("//", 0).strip_edges()

		if _occurence.y != -1 and _occurence not in _occurences_locations and not _current_line.is_empty():
			_occurences_locations.append(_occurence)
			_current_line_location = _occurence
		else:
			break
	return _occurences_locations

static func get_loop_location(editor: CodeEdit) -> Vector2i:
	return editor.search("Void loop()", 2, 0, 0)
