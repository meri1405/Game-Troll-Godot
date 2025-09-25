extends Area2D

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
@onready var tilemap = $"../TileMap"

var is_open: bool = false


func _on_body_entered(body):
	if body.is_in_group("Player") and not is_open:
		print("Kích hoạt bẫy")
		open_door()


func open_door():
	is_open = true
	# Xóa toàn bộ tile trong khoảng (32,10) -> (52,16)
	for x in range(32, 53):  # 53 vì range dừng trước giá trị cuối
		for y in range(10, 17):  # 17 vì range dừng trước giá trị cuối
			tilemap.set_cell(0, Vector2i(x, y), -1)
