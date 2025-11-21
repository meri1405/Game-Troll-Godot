extends Area2D

@export var tilemap: TileMap
@export var y_level: int = 9
@export var start_x: int = 50
@export var end_x: int = 42
@export var spawn_delay: float = 0.08    # thời gian mỗi ô tile xuất hiện

var saved_tiles = []
var triggered := false


func _ready():
	# Lưu tile rồi xóa tile để ẩn ban đầu
	save_and_clear_tiles()


# ---------------------------------------------------------
# Player chạm Trigger
# ---------------------------------------------------------
func _on_body_entered(body):
	if triggered:
		return
	
	if not body.is_in_group("Player"):
		return

	triggered = true
	spawn_tiles()


# ---------------------------------------------------------
# Lưu tile + xóa tile
# ---------------------------------------------------------
func save_and_clear_tiles():
	saved_tiles.clear()

	for x in range(start_x, end_x - 1, -1):  # 50 → 42
		var pos = Vector2i(x, y_level)
		var source = tilemap.get_cell_source_id(0, pos)
		if source != -1:
			saved_tiles.append({
				"pos": pos,
				"source": source,
				"atlas": tilemap.get_cell_atlas_coords(0, pos),
				"alt": tilemap.get_cell_alternative_tile(0, pos)
			})

		# Xóa để tile ẩn khi start game
		tilemap.set_cell(0, pos, -1)


# ---------------------------------------------------------
# Spawn từng ô tile một
# ---------------------------------------------------------
func spawn_tiles() -> void:
	for data in saved_tiles:
		tilemap.set_cell(
			0,
			data["pos"],
			data["source"],
			data["atlas"],
			data["alt"]
		)
		await get_tree().create_timer(spawn_delay).timeout


# ---------------------------------------------------------
# Theo dõi player chết để reset
# ---------------------------------------------------------
func _process(delta):
	var player = get_tree().get_first_node_in_group("Player")
	if triggered and player and not player.is_alive:
		reset_tiles()


# ---------------------------------------------------------
# RESET TẤT CẢ
# ---------------------------------------------------------
func reset_tiles():
	# Xóa hết để ẩn lại
	for tile in saved_tiles:
		tilemap.set_cell(0, tile["pos"], -1)

	triggered = false
