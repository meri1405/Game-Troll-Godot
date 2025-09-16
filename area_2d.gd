extends Area2D

@onready var tilemap = $"../TileMap"   # đường dẫn tới TileMap

# Danh sách nhiều tọa độ tile cần xóa
@export var tiles_to_remove: Array[Vector2i] = [
	Vector2i(2, 10),
	Vector2i(2, 11),
	Vector2i(3, 10),
	Vector2i(3, 11)
]

func _on_body_entered(body):
	if body.is_in_group("Player"):
		for coords in tiles_to_remove:
			tilemap.set_cell(0, coords, -1)  # -1 nghĩa là xóa tile tại tọa độ đó
		hide() # Xóa trigger sau khi kích hoạt
		await get_tree().create_timer(1.3).timeout
		tilemap.set_cell(0, Vector2i(2, 10), 0, Vector2i(7, 8))
		tilemap.set_cell(0, Vector2i(2, 11), 0, Vector2i(7, 9))
		tilemap.set_cell(0, Vector2i(3, 10), 0, Vector2i(8, 8))
		tilemap.set_cell(0, Vector2i(3, 11), 0, Vector2i(8, 9))
