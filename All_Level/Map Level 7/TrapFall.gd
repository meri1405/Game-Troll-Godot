extends Area2D

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
@onready var tilemap = $"../TileMap"

var is_open: bool = false

@export var tiles_to_remove: Array[Vector2i] = [
	Vector2i(30, -3),
	Vector2i(31, -3),
	Vector2i(30, -2),
	Vector2i(31, -2)
]


func _on_body_entered(body):
	if body.is_in_group("Player"):
		print("Kích hoạt bẫy")
		open_door()

func open_door():
	is_open = true
	# Xóa tile cửa
	for coords in tiles_to_remove:
		tilemap.set_cell(0, coords, -1)
	
	await get_tree().create_timer(6).timeout
	close_door()
	

func close_door():
	is_open = false
	tilemap.set_cell(0, Vector2i(30, -3), 0, Vector2i(1, 8))
	tilemap.set_cell(0, Vector2i(31, -3), 0, Vector2i(1, 8))
	tilemap.set_cell(0, Vector2i(30, -2), 0, Vector2i(1, 9))
	tilemap.set_cell(0, Vector2i(31, -2), 0, Vector2i(1, 9))
