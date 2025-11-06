extends Node3D

@export_range(1, 20, 1) var total_boards: int = 4
@export var current_board: board_resource

var board_model_scene: Node
var boards: Array[Node3D]

var x_muiltiplier: int = 0

var board_collision_shapes


func _ready() -> void:
	for i in total_boards:
		var board: Node = load(current_board.board_model).instantiate()
		board.name = "board" + str(i)
		print(board.name)
		boards.append(board)

	for board in boards:
		board.global_position = Vector3(0 + x_muiltiplier, 0, 0)
		x_muiltiplier += 5
		
		board_collision_shapes = board.find_children("StaticBody3D")

		for collision_shape in board_collision_shapes:
			collision_shape.mouse_entered.connect(_on_static_body_3d_mouse_entered.bind(collision_shape.get_parent()))
			collision_shape.mouse_exited.connect(_on_static_body_3d_mouse_exited.bind(collision_shape.get_parent()))

		add_child(board)


func _on_static_body_3d_mouse_entered(mesh: MeshInstance3D) -> void:
	print("Hovering over board", mesh.owner.name)


func _on_static_body_3d_mouse_exited(_mesh: MeshInstance3D) -> void:
	print("No longer hovering over board")
