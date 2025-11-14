extends Area2D

@export var tilemap_path: NodePath
@export var node_begin_path: NodePath
@export var node_bonus_path: NodePath

@export var start_visible_bonus: bool = false
@export var tile_delay: float = 0.1
@export var initial_delay_before_break: float = 1.0
@export var between_rows_delay: float = 0.1
@export var after_break_delay: float = 1.0

@export var move_distance: float = 983.0
@export var move_speed: float = 350.0

@export var drop_distance: float = 150.0
@export var drop_speed: float = 250.0
@export var drop_delay_after_move: float = 2.0

var tilemap: TileMap
var node_begin: Node2D
var node_bonus: Node2D
var player

var has_triggered := false
var is_running := false   # <-- cờ dừng/cancel coroutine

var original_begin_pos: Vector2
var original_bonus_pos: Vector2

var saved_tiles = []


func _ready():
	tilemap = get_node(tilemap_path)
	node_begin = get_node(node_begin_path)
	node_bonus = get_node(node_bonus_path)

	original_begin_pos = node_begin.position
	original_bonus_pos = node_bonus.position

	node_bonus.visible = start_visible_bonus

	player = get_tree().get_first_node_in_group("player")


# Kích hoạt trigger (chỉ 1 lần cho tới khi reset)
func _on_body_entered(body):
	if has_triggered:
		return
	if not body or not body.is_in_group("player"):
		return

	has_triggered = true
	is_running = true        # bật chế độ running
	_start_trap()


# Bắt đầu luồng trap (không blocking)
func _start_trap() -> void:
	# bật bonus
	node_bonus.visible = true

	# delay trước khi phá
	await get_tree().create_timer(initial_delay_before_break).timeout
	if _should_stop(): return

	# phá hàng y=11
	await _break_row([Vector2i(12,11), Vector2i(13,11), Vector2i(14,11)])
	if _should_stop(): return
	await get_tree().create_timer(between_rows_delay).timeout
	if _should_stop(): return

	# phá hàng y=12
	await _break_row([Vector2i(12,12), Vector2i(13,12), Vector2i(14,12)])
	if _should_stop(): return
	await get_tree().create_timer(between_rows_delay).timeout
	if _should_stop(): return

	# phá hàng y=13
	await _break_row([Vector2i(12,13), Vector2i(13,13), Vector2i(14,13)])
	if _should_stop(): return

	await get_tree().create_timer(after_break_delay).timeout
	if _should_stop(): return

	# di chuyển 2 node
	await _move_nodes()
	if _should_stop(): return

	# đợi 2s rồi thụt xuống
	await get_tree().create_timer(drop_delay_after_move).timeout
	if _should_stop(): return

	await _drop_nodes()
	# kết thúc chuỗi (để _has_triggered vẫn true; chỉ reset khi player chết)
	is_running = false
	return


# Phá 1 hàng (mảng Vector2i)
func _break_row(cells: Array) -> void:
	for pos in cells:
		if _should_stop(): return
		# lưu tile nếu chưa lưu
		var tile_data = tilemap.get_cell_tile_data(0, pos)
		if tile_data:
			# tránh lưu trùng
			var already := false
			for d in saved_tiles:
				if d["pos"] == pos:
					already = true
					break
			if not already:
				saved_tiles.append({
					"pos": pos,
					"source": tilemap.get_cell_source_id(0, pos),
					"atlas": tilemap.get_cell_atlas_coords(0, pos)
				})
		# xóa ô
		tilemap.set_cell(0, pos, -1)


# Di chuyển 2 node sang trái (dừng nếu is_running = false hoặc player chết)
func _move_nodes() -> void:
	var target_begin = original_begin_pos + Vector2(-move_distance, 0)
	var target_bonus = original_bonus_pos + Vector2(-move_distance, 0)

	while (node_begin.position.distance_to(target_begin) > 1 or node_bonus.position.distance_to(target_bonus) > 1):
		# kiểm tra dừng ngay
		if _should_stop():
			return

		var dt = get_process_delta_time()
		node_begin.position = node_begin.position.move_toward(target_begin, move_speed * dt)
		node_bonus.position = node_bonus.position.move_toward(target_bonus, move_speed * dt)

		await get_tree().process_frame


# Thụt xuống 150px (dùng move_toward)
func _drop_nodes() -> void:
	var target_begin = node_begin.position + Vector2(0, drop_distance)
	var target_bonus = node_bonus.position + Vector2(0, drop_distance)

	while (node_begin.position.distance_to(target_begin) > 1 or node_bonus.position.distance_to(target_bonus) > 1):
		if _should_stop():
			return

		var dt = get_process_delta_time()
		node_begin.position = node_begin.position.move_toward(target_begin, drop_speed * dt)
		node_bonus.position = node_bonus.position.move_toward(target_bonus, drop_speed * dt)

		await get_tree().process_frame


# Hàm helper: trả true nếu cần dừng mọi công việc (player chết hoặc is_running false)
func _should_stop() -> bool:
	# dừng khi is_running false (reset gọi) hoặc player đã chết
	if not is_running:
		return true
	if player and not player.is_alive:
		return true
	return false


# Process backup: nếu player chết trong lúc trap chạy → reset ngay
func _process(delta):
	if has_triggered and player and not player.is_alive:
		_reset_trap()


# Reset an toàn: dừng coroutine rồi khôi phục trạng thái ban đầu
func _reset_trap():
	# tắt chạy mọi coroutine
	is_running = false

	# khôi phục tile
	for data in saved_tiles:
		tilemap.set_cell(0, data["pos"], data["source"], data["atlas"])
	saved_tiles.clear()

	# khôi phục vị trí node & visible
	node_begin.position = original_begin_pos
	node_bonus.position = original_bonus_pos
	node_bonus.visible = start_visible_bonus

	# reset trigger state
	has_triggered = false
	# cho phép Area2D kích hoạt lại
	monitoring = true
