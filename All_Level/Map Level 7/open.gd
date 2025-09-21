extends Area2D

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
@onready var tilemap = $"../TileMap"

var is_open: bool = false

@export var tiles_to_remove: Array[Vector2i] = [
	Vector2i(-4, 0),
	Vector2i(-4, 1),
	Vector2i(-4, 2),
	Vector2i(-4, 3)
]

func _on_body_entered(body):
	if body.is_in_group("Player") and not is_open:
		print("Cửa mở thành công 🎉")
		open_door()

func open_door():
	is_open = true
	# Xóa tile cửa
	for coords in tiles_to_remove:
		tilemap.set_cell(0, coords, -1)

	# Sau 1 giây cửa đóng lại
	await get_tree().create_timer(2).timeout
	close_door()

func close_door():
	is_open = false
	# Đặt lại tile cửa bằng ID đã hardcode sẵn
	for coords in tiles_to_remove:
		tilemap.set_cell(0, coords, 0, Vector2i(2, 9))
