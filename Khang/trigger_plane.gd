extends Area2D

@export var tilemap_path: NodePath
@export var start_pos: Vector2i = Vector2i(4, 9)   # Góc trên bên trái
@export var end_pos: Vector2i = Vector2i(17, 18)   # Góc dưới bên phải
@export var drop_delay: float = 0.015               # Thời gian giữa các tile rơi
@export var reset_delay: float = 1               # Thời gian chờ trước khi reset sau khi player chết

var tilemap: TileMap
var player
var has_triggered := false
var is_dropping := false
var saved_tiles := []  # Lưu dữ liệu tile ban đầu (pos, source_id, atlas)

func _ready():
	tilemap = get_node_or_null(tilemap_path)
	player = get_tree().get_first_node_in_group("player")
	
	if tilemap:
		_save_initial_tiles()


func _on_body_entered(body):
	if not body.is_in_group("player"):
		return
	if has_triggered or not tilemap:
		return
	
	has_triggered = true
	is_dropping = true
	await _drop_tiles()
	is_dropping = false


func _save_initial_tiles():
	saved_tiles.clear()
	for x in range(start_pos.x, end_pos.x + 1):
		for y in range(start_pos.y, end_pos.y + 1):
			var pos = Vector2i(x, y)
			var source = tilemap.get_cell_source_id(0, pos)
			if source != -1:
				var atlas = tilemap.get_cell_atlas_coords(0, pos)
				saved_tiles.append({
					"pos": pos,
					"source": source,
					"atlas": atlas
				})


func _drop_tiles():
	for x in range(start_pos.x, end_pos.x + 1):
		for y in range(start_pos.y, end_pos.y + 1):
			var pos = Vector2i(x, y)
			if tilemap.get_cell_source_id(0, pos) != -1:
				tilemap.erase_cell(0, pos)
				await get_tree().create_timer(drop_delay).timeout


func _process(_delta):
	# Nếu player chết thì reset lại bản đồ
	if has_triggered and player and not player.is_alive:
		await get_tree().create_timer(reset_delay).timeout
		reset_state()


func reset_state():
	# Khôi phục tile
	if tilemap:
		for data in saved_tiles:
			tilemap.set_cell(0, data["pos"], data["source"], data["atlas"])
	
	# Cho phép trigger hoạt động lại
	has_triggered = false
	monitoring = true
