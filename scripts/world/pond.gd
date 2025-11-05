extends Node3D

@export_range(1, 20, 1) var total_boards: int = 4
@export var current_board: board_resource

var board_model_scene: Node
var boards: Array[Node3D]

var x_muiltiplier: int = 0


func _ready() -> void:
	board_model_scene = load(current_board.board_model).instantiate()
	
	for i in total_boards:
		var board: Node = load(current_board.board_model).instantiate()
		boards.append(board)

	for board in boards:
		board.global_position = Vector3(0 + x_muiltiplier, 0, 0)
		add_child(board)
		x_muiltiplier += 5
