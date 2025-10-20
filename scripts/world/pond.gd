extends Node3D

@export var material: Material

@onready var board_model_scene: Node = preload("res://graphics/models/adafruit_esp32-c6_feather/adafruit_esp_32_c_6.tscn").instantiate()

@onready var stemma_port: MeshInstance3D = board_model_scene.find_child("stemma0")

@onready var dynamic_parts: Resource = preload("res://resources/boards/ESP32-C6_Feather.tres")
@onready var board_collision_shapes = board_model_scene.find_children("StaticBody3D")

@onready var code_editor_node: CodeEdit = find_child("CodeEdit")

var part_hovered: bool

var popup: PopupHover


func _ready() -> void:
	add_child(board_model_scene)
	popup = PopupHover.create_new_popup()
	popup.visible = false
	add_child(popup)

	for collision_shape in board_collision_shapes:
		collision_shape.mouse_entered.connect(_on_static_body_3d_mouse_entered.bind(collision_shape.get_parent()))
		collision_shape.mouse_exited.connect(_on_static_body_3d_mouse_exited.bind(collision_shape.get_parent()))
		print(collision_shape)
	
	#code_editor_node.symbol_hovered.connect(_on_symbol_hovered)
	code_editor_node.focus_entered.connect(_on_text_hovered)
	SerialController.SerialDataReceived.connect(_on_serial_data_received)


#func _on_symbol_hovered(symbol: String, line: int, collumn: int):
	#match symbol:
		#"stemma0":
			#part_hovered = true
			#stemma_port.material_overlay = material

func _on_serial_data_received(data: String) -> void:
	if data.contains("$p"):
		var _data_value = data.get_slice("$", 2)
		popup.find_child("Label").text = _data_value


func _on_text_hovered():
	if part_hovered:
		stemma_port.material_overlay = null
		part_hovered = false
		
func _focus_entered():
	print("Hovered")

func _on_static_body_3d_mouse_entered(mesh: MeshInstance3D) -> void:
	popup.visible = true
	mesh.material_overlay = material
	popup.get_child(0).set_position(get_viewport().get_mouse_position())


func _on_static_body_3d_mouse_exited(mesh: MeshInstance3D) -> void:
	mesh.material_overlay = null
	popup.visible = false

func _on_code_editor_board_changed(_new_board) -> void:
	pass
	
