extends Area2D

@export var door_color: int = 7 # màu cửa
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
@onready var tilemap = $"../TileMap"

var is_open: bool = false

@export var tiles_to_remove: Array[Vector2i] = [
	Vector2i(19, -9),
	Vector2i(19, -10),
	Vector2i(19, -11),
	Vector2i(19, -12)
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
	for coords in tiles_to_remove:
		tilemap.set_cell(0, coords, -1)

	# Sau 1 giây cửa đóng lại
	await get_tree().create_timer(1.0).timeout
	close_door()

func close_door():
	is_open = false
	# Đặt lại tile cửa bằng ID đã hardcode sẵn
	tilemap.set_cell(0, Vector2i(19, -9), 0, Vector2i(20, 8))
	for coords in tiles_to_remove:
		tilemap.set_cell(0, coords, 0, Vector2i(20, 9))
	tilemap.set_cell(0, Vector2i(19, -12), 0, Vector2i(20, 10))
