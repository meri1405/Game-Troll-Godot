extends Area2D

@onready var tilemap = $"../TileMap"   # đường dẫn tới TileMap

# Danh sách nhiều tọa độ tile cần xóa
@export var tiles_to_remove: Array[Vector2i] = [
	Vector2i(12, 10),
	Vector2i(13, 10)

]

# Lưu trạng thái ban đầu để reset
var original_tiles: Array[Dictionary] = []
var added_tiles: Array[Vector2i] = []
var has_triggered = false

func _ready():
	# Lưu tiles ban đầu
	save_original_tiles()
	
	# Thêm vào group để Player có thể reset
	add_to_group("resettable_traps")
	
	print("RemoveTilemap trap ready")

func save_original_tiles():
	"""Lưu tiles gốc trước khi xóa"""
	for coords in tiles_to_remove:
		var tile_data = {
			"coords": coords,
			"source_id": tilemap.get_cell_source_id(0, coords),
			"atlas_coords": tilemap.get_cell_atlas_coords(0, coords),
			"alternative_tile": tilemap.get_cell_alternative_tile(0, coords)
		}
		original_tiles.append(tile_data)
	
	print("Saved ", original_tiles.size(), " original tiles for reset")

func _on_body_entered(body):
	if body.is_in_group("Player") and not has_triggered:
		has_triggered = true
		print("Player triggered tilemap trap!")
		
		# Xóa tiles
		for coords in tiles_to_remove:
			tilemap.set_cell(0, coords, -1)  # -1 nghĩa là xóa tile tại tọa độ đó
		
		hide() # Ẩn trigger sau khi kích hoạt
		
		# Đợi rồi tạo tiles mới
	
		
		# Lưu tiles đã thêm để xóa khi reset



func reset_object():
	"""Reset trap về trạng thái ban đầu khi Player chết"""
	print("Resetting tilemap trap...")
	
	# Restore tiles gốc
	for tile_data in original_tiles:
		tilemap.set_cell(
			0, 
			tile_data.coords, 
			tile_data.source_id, 
			tile_data.atlas_coords, 
			tile_data.alternative_tile
		)
	
	# Xóa tiles đã thêm trong quá trình trap
	for coords in added_tiles:
		tilemap.set_cell(0, coords, -1)
	
	# Reset trạng thái
	has_triggered = false
	show()  # Hiện lại trigger
	
	print("Tilemap trap reset complete!")
