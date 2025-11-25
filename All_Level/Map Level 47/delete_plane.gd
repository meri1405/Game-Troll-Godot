extends Area2D

@export var tilemap_node: NodePath

# Chỉ nhập 2 điểm: góc trên trái & góc dưới phải
@export var top_left: Vector2i
@export var bottom_right: Vector2i

var erase_cells: Array[Vector2i] = []     # Tự sinh từ 2 tọa độ
var saved_tiles: Array = []               # Lưu tile ban đầu

var tilemap
var player
var has_triggered := false


func _ready():
	tilemap = get_node_or_null(tilemap_node)

	# Tạo danh sách cell trong vùng hình chữ nhật
	_generate_cells()

	# Lưu tile ban đầu
	if tilemap:
		for cell in erase_cells:
			var source_id = tilemap.get_cell_source_id(0, cell)
			var atlas_coords = tilemap.get_cell_atlas_coords(0, cell)

			saved_tiles.append({
				"pos": cell,
				"source": source_id,
				"atlas": atlas_coords
			})

	# Tìm player
	player = get_tree().get_first_node_in_group("player")


# ----------------------------------------------------------
# Sinh danh sách erase_cells từ 2 tọa độ
# ----------------------------------------------------------
func _generate_cells():
	erase_cells.clear()

	var x1 = min(top_left.x, bottom_right.x)
	var x2 = max(top_left.x, bottom_right.x)
	var y1 = min(top_left.y, bottom_right.y)
	var y2 = max(top_left.y, bottom_right.y)

	for x in range(x1, x2 + 1):
		for y in range(y1, y2 + 1):
			erase_cells.append(Vector2i(x, y))


# ----------------------------------------------------------
# Khi Player chạm trigger
# ----------------------------------------------------------
func _on_body_entered(body):
	if body.is_in_group("player"):

		if tilemap:
			for cell in erase_cells:
				tilemap.set_cell(0, cell, -1)

		has_triggered = true
		monitoring = false  # Chỉ chạy 1 lần


# ----------------------------------------------------------
# Reset lại khi Player chết
# ----------------------------------------------------------
func _process(delta):
	if has_triggered and player and not player.is_alive:
		reset_state()


func reset_state():
	# Khôi phục tile
	if tilemap:
		for data in saved_tiles:
			tilemap.set_cell(0, data["pos"], data["source"], data["atlas"])

	# Cho trigger chạy lại
	monitoring = true
	has_triggered = false
