extends Area2D

@export var tilemap: TileMap
@export var gai_trap: Node2D
@export var move_distance: float = 1000          # Gai sẽ chạy sang trái 1000px
@export var move_speed: float = 1000             # Tốc độ gai chạy
@export var start_x: int = 25
@export var end_x: int = 28
@export var y_level: int = 5
@export var wait_before_move: float = 1.0        # thời gian đợi sau khi xóa tile

var triggered = false
var saved_tiles = []
var gai_start_pos: Vector2
var is_moving: bool = false

func _ready():
	gai_start_pos = gai_trap.global_position

# Khi player chạm trigger
func _on_body_entered(body):
	if triggered:
		return
	if not body.is_in_group("Player"):
		return
	triggered = true
	start_trap()

# Bắt đầu trap
func start_trap() -> void:
	save_tiles()
	delete_tiles()
	move_gai_after_delay()

# Lưu tile
func save_tiles():
	saved_tiles.clear()
	for x in range(start_x, end_x + 1):
		var pos = Vector2i(x, y_level)
		var data = tilemap.get_cell_tile_data(0, pos)
		if data != null:
			saved_tiles.append({
				"pos": pos,
				"source": tilemap.get_cell_source_id(0, pos),
				"atlas": tilemap.get_cell_atlas_coords(0, pos),
			})

# Xóa tile
func delete_tiles():
	for x in range(start_x, end_x + 1):
		tilemap.set_cell(0, Vector2i(x, y_level), -1)

# Di chuyển gai sau wait
func move_gai_after_delay() -> void:
	is_moving = true
	await get_tree().create_timer(wait_before_move).timeout
	var target_pos = gai_start_pos + Vector2(-move_distance, 0)  # sang trái
	while gai_trap.global_position.x > target_pos.x:
		if not triggered:  # nếu player chết, dừng ngay
			is_moving = false
			return
		var delta = get_process_delta_time()
		gai_trap.global_position.x -= move_speed * delta
		await get_tree().process_frame
	gai_trap.global_position = target_pos
	is_moving = false

# Reset trap khi player chết
func _process(delta):
	var player = get_tree().get_first_node_in_group("Player")
	if triggered and player and not player.is_alive:
		reset_trap()

func reset_trap():
	# Dừng di chuyển nếu đang chạy
	triggered = false
	is_moving = false

	# Khôi phục tile
	for data in saved_tiles:
		tilemap.set_cell(0, data["pos"], data["source"], data["atlas"])

	# Trả gai về vị trí gốc
	gai_trap.global_position = gai_start_pos
