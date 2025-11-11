extends Node3D

signal show_windows
signal hide_windows

@export_range(1, 20, 1) var total_boards: int = 4
@export var current_board: board_resource
@export var divider_amount: int = 5

@onready var code_editor: CodeEditor = $CodeEditor

var board_model_scene: Node
var boards: Array[Node3D]

var board_collision_shapes
var hovering: bool
var current_focused_mesh


func _ready() -> void:
	var x_muiltiplier: int = 0

	for i in total_boards:
		var board: Node = load(current_board.board_model).instantiate()
		board.name = "Board" + str(i)
		boards.append(board)

	for board in boards:
		board.global_position = Vector3(0 + x_muiltiplier, 0, 0)
		x_muiltiplier += divider_amount
		
		board_collision_shapes = board.find_children("StaticBody3D")

		for collision_shape in board_collision_shapes:
			collision_shape.mouse_entered.connect(_on_static_body_3d_mouse_entered.bind(collision_shape.get_parent()))
			collision_shape.mouse_exited.connect(_on_static_body_3d_mouse_exited.bind(collision_shape.get_parent()))

		add_child(board)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and hovering:
		show_windows.emit(current_focused_mesh)

	if event.is_action_pressed("close_code_editor"):
		hide_windows.emit(current_focused_mesh)
		#SaveHandler.save_pond()


func _on_static_body_3d_mouse_entered(mesh: MeshInstance3D) -> void:
	hovering = true
	current_focused_mesh = mesh.owner.name
	print("Hovering over: ", mesh.owner.name)


func _on_static_body_3d_mouse_exited(mesh: MeshInstance3D) -> void:
	hovering = false
	current_focused_mesh = null
	print("No longer hovering over: ", mesh.owner.name)


func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"total_boards": total_boards,
	}

	return save_dict

func _exit_tree() -> void:
	SaveHandler.save_pond()
