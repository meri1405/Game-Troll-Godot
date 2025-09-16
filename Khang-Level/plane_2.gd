extends Area2D
@onready var tilemap = $"../TileMap"  # đường dẫn tới TileMap
@export var tile_coords: Array[Vector2i] = [
	Vector2i(22, 9),
	Vector2i(22, 10)
]

func _on_body_entered(body):
	if body.is_in_group("Player"):
		for coords in tile_coords:
			tilemap.set_cell(0, coords, 0, Vector2i(12, 9))
		await get_tree().create_timer(2).timeout
		for coords in tile_coords:
			tilemap.set_cell(0, coords, -1)
