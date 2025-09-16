extends Area2D

@onready var tilemap = $"../TileMap"   # đường dẫn tới TileMap

# Danh sách nhiều tọa độ tile cần xóa
@export var tiles_to_remove: Array[Vector2i] = [
	Vector2i(18, 6),
	Vector2i(20, 6),
	Vector2i(19, 6)
]

func _on_body_entered(body):
	if body.is_in_group("Player"):
		for coords in tiles_to_remove:
			tilemap.set_cell(0, coords, -1)  # -1 nghĩa là xóa tile tại tọa độ đó
		queue_free() # Xóa trigger sau khi kích hoạt
