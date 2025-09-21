extends Area2D

@export var door_color: int = 1 # màu cửa
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
@onready var tilemap = $"../TileMap"

var is_open: bool = false

@export var tiles_to_remove1: Array[Vector2i] = [
	Vector2i(11, 0),
	Vector2i(11, 1),
	Vector2i(11, 2),
	Vector2i(11, 3)
]

@export var tiles_to_remove2: Array[Vector2i] = [
	Vector2i(12, 0),
	Vector2i(12, 1),
	Vector2i(12, 2),
	Vector2i(12, 3)
]

func _on_body_entered(body):
	if body.is_in_group("Player") and not is_open:
		if body.current_color == door_color:
			print("Cửa mở thành công 🎉")
			open_door()
			body.reset_color()
		else:
			print("Sai màu → player chết 💀")
			body.die()

func open_door():
	is_open = true
	# Xóa tile cửa
	for coords in tiles_to_remove1:
		tilemap.set_cell(0, coords, -1)
	for coords in tiles_to_remove2:
		tilemap.set_cell(0, coords, -1)

	

func close_door():
	is_open = false
	for coords in tiles_to_remove1:
		tilemap.set_cell(0, coords, 0, Vector2i(17, 5))
	for coords in tiles_to_remove2:
		tilemap.set_cell(0, coords, 0, Vector2i(19, 5))
