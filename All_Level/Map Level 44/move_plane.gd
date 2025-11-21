extends Area2D

@export var tilemap: TileMap
@export var tile_layer: int = 0

@export var left_original := Vector2i(35, 10)
@export var right_original := Vector2i(36, 10)

@export var left_final := Vector2i(34, 10)
@export var right_final := Vector2i(37, 10)

@export var player_group := "Player"

var triggered := false


func _on_body_entered(body):
	if triggered:
		return
	if not body.is_in_group(player_group):
		return

	triggered = true
	split_tiles()


# -----------------------------------------------------
# TÁCH TILE: LẤY TILE NGAY LÚC NÀY (ĐẢM BẢO ĐÚNG 100%)
# -----------------------------------------------------
func split_tiles():
	if tilemap == null:
		push_error("tilemap null !!!")
		return

	# Lấy dữ liệu thật sự của tile 35–36 tại thời điểm này
	var left_src = tilemap.get_cell_source_id(tile_layer, left_original)
	var left_atlas = tilemap.get_cell_atlas_coords(tile_layer, left_original)
	var left_alt = tilemap.get_cell_alternative_tile(tile_layer, left_original)

	var right_src = tilemap.get_cell_source_id(tile_layer, right_original)
	var right_atlas = tilemap.get_cell_atlas_coords(tile_layer, right_original)
	var right_alt = tilemap.get_cell_alternative_tile(tile_layer, right_original)

	# Xóa tile gốc
	tilemap.set_cell(tile_layer, left_original, -1)
	tilemap.set_cell(tile_layer, right_original, -1)

	# Spawn sang 34–37 (nếu có tile)
	if left_src != -1:
		tilemap.set_cell(tile_layer, left_final, left_src, left_atlas, left_alt)

	if right_src != -1:
		tilemap.set_cell(tile_layer, right_final, right_src, right_atlas, right_alt)


func _process(_delta):
	var player = get_tree().get_first_node_in_group(player_group)
	if triggered and player and not player.is_alive:
		reset_tiles()


# -----------------------------------------------------
# Reset: xóa 34–37, trả về không có tile
# -----------------------------------------------------
func reset_tiles():
	tilemap.set_cell(tile_layer, left_final, -1)
	tilemap.set_cell(tile_layer, right_final, -1)

	triggered = false
