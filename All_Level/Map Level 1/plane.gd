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
		# Thêm 2 block đầu và cuối
		tilemap.set_cell(0, Vector2i(12, 11), 0, Vector2i(6, 8))
		tilemap.set_cell(0, Vector2i(21, 11), 0, Vector2i(8, 8))

		# Hiện toàn bộ block cửa
		for coords in tile_coords:
			tilemap.set_cell(0, coords, 0, Vector2i(7, 8))

		# Bắt đầu coroutine xoá block dần
		await _delete_tiles_step_by_step()

		hide() # Xóa luôn Area2D (cửa không kích hoạt nữa)


func _delete_tiles_step_by_step() -> void:
	await get_tree().create_timer(0.15).timeout
	tilemap.set_cell(0, Vector2i(12, 11), -1)
	for coords in tile_coords:
		await get_tree().create_timer(0.15).timeout
		tilemap.set_cell(0, coords, -1)  # -1 = xoá tile
	await get_tree().create_timer(0.15).timeout
	tilemap.set_cell(0, Vector2i(21, 11), -1)
