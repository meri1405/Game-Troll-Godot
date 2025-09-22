extends Area2D

@onready var tilemap = $"../TileMap"   # đường dẫn tới TileMap

# Cách 1: Chọn từng tile riêng lẻ
@export var individual_tiles: Array[Vector2i] = []

# Cách 2: Chọn vùng chữ nhật
@export_group("Rectangle Area")
@export var use_rectangle_area: bool = false
@export var rectangle_top_left: Vector2i = Vector2i(0, 0)
@export var rectangle_bottom_right: Vector2i = Vector2i(5, 5)

# Cách 3: Nhiều vùng chữ nhật
@export_group("Multiple Rectangles")
@export var use_multiple_rectangles: bool = false
@export var rectangles: Array[Rect2i] = []

# Cách 4: Thêm tiles mới sau khi xóa
@export_group("Add New Tiles")
@export var add_new_tiles_after_remove: bool = false
@export var new_tiles_data: Array[Dictionary] = []
@export var delay_before_adding: float = 1.0

# Lưu trạng thái ban đầu để reset
var original_tiles: Array[Dictionary] = []
var added_tiles: Array[Vector2i] = []
var has_triggered = false
var tiles_to_remove: Array[Vector2i] = []

func _ready():
	# Tính toán danh sách tiles cần xóa
	calculate_tiles_to_remove()
	
	# Lưu tiles ban đầu
	save_original_tiles()
	
	# Thêm vào group để Player có thể reset
	add_to_group("resettable_traps")
	
	print("RemoveTilemap trap ready with ", tiles_to_remove.size(), " tiles to remove")

func calculate_tiles_to_remove():
	"""Tính toán danh sách tiles cần xóa dựa trên settings"""
	tiles_to_remove.clear()
	
	# Thêm individual tiles
	for tile in individual_tiles:
		if not tiles_to_remove.has(tile):
			tiles_to_remove.append(tile)
	
	# Thêm rectangle area
	if use_rectangle_area:
		for x in range(rectangle_top_left.x, rectangle_bottom_right.x + 1):
			for y in range(rectangle_top_left.y, rectangle_bottom_right.y + 1):
				var coords = Vector2i(x, y)
				if not tiles_to_remove.has(coords):
					tiles_to_remove.append(coords)
	
	# Thêm multiple rectangles
	if use_multiple_rectangles:
		for rect in rectangles:
			for x in range(rect.position.x, rect.position.x + rect.size.x):
				for y in range(rect.position.y, rect.position.y + rect.size.y):
					var coords = Vector2i(x, y)
					if not tiles_to_remove.has(coords):
						tiles_to_remove.append(coords)

func save_original_tiles():
	"""Lưu tiles gốc trước khi xóa"""
	original_tiles.clear()
	
	for coords in tiles_to_remove:
		var source_id = tilemap.get_cell_source_id(0, coords)
		if source_id != -1:  # Chỉ lưu nếu có tile tại đó
			var tile_data = {
				"coords": coords,
				"source_id": source_id,
				"atlas_coords": tilemap.get_cell_atlas_coords(0, coords),
				"alternative_tile": tilemap.get_cell_alternative_tile(0, coords)
			}
			original_tiles.append(tile_data)
	
	print("Saved ", original_tiles.size(), " original tiles for reset")

func _on_body_entered(body):
	if body.is_in_group("player") and not has_triggered:
		has_triggered = true
		print("Player triggered tilemap trap!")
		
		# Xóa tiles
		remove_tiles()
		
		# Ẩn trigger sau khi kích hoạt
		hide()
		
		# Thêm tiles mới nếu được enable
		if add_new_tiles_after_remove:
			await get_tree().create_timer(delay_before_adding).timeout
			add_new_tiles()

func remove_tiles():
	"""Xóa các tiles đã chọn"""
	for coords in tiles_to_remove:
		tilemap.set_cell(0, coords, -1)  # -1 nghĩa là xóa tile
		print("Removed tile at: ", coords)

func add_new_tiles():
	"""Thêm tiles mới sau khi xóa"""
	added_tiles.clear()
	
	for tile_data in new_tiles_data:
		if tile_data.has("coords") and tile_data.has("source_id"):
			var coords = Vector2i(tile_data.coords.x, tile_data.coords.y)
			var source_id = tile_data.get("source_id", 0)
			var atlas_coords = Vector2i(tile_data.get("atlas_coords", Vector2i(0, 0)))
			var alternative = tile_data.get("alternative_tile", 0)
			
			tilemap.set_cell(0, coords, source_id, atlas_coords, alternative)
			added_tiles.append(coords)
			print("Added new tile at: ", coords)

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
	added_tiles.clear()
	
	print("Tilemap trap reset complete!")

# Helper function để debug - gọi từ editor
func preview_tiles_to_remove():
	"""Preview tiles sẽ bị xóa (chỉ dùng để debug)"""
	calculate_tiles_to_remove()
	print("Tiles to remove: ", tiles_to_remove)
