extends Area2D

@onready var tilemap = $"../TileMap"  # đường dẫn tới TileMap
@export var tile_coords: Array[Vector2i] = [
	Vector2i(13, 11),
	Vector2i(14, 11),
	Vector2i(15, 11),
	Vector2i(16, 11),
	Vector2i(17, 11),
	Vector2i(18, 11),
	Vector2i(19, 11),
	Vector2i(20, 11)
]
@export var tile_id: int = 0   # ID của tile bạn muốn hiện lên

func _on_body_entered(body):
	if body.is_in_group("Player"):
		# Thêm tile lại ở (5, 10) trên TileMap
		tilemap.set_cell(0, Vector2i(12, 11), 0, Vector2i(6, 8))
		tilemap.set_cell(0, Vector2i(21, 11), 0, Vector2i(8, 8))
		for coords in tile_coords:
			# hiện tile tại mỗi tọa độ
			tilemap.set_cell(0, coords, 0, Vector2i(7, 8))
		queue_free()
