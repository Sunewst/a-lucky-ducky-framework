class_name BoardProperties extends Window

const BOARD_PROPERTIES_SCENE: PackedScene = preload("res://scenes/loop_scene.tscn")


func _ready() -> void:
	self.connect("close_requested", close_window)


func close_window():
	hide()


static func display_new_loop_window():
	var new_loop_window: LoopWindow = BOARD_PROPERTIES_SCENE.instantiate()
	return new_loop_window
