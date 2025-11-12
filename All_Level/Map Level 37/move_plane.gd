extends Area2D

@export var tilemap_path: NodePath
@export var left_pos: Vector2i = Vector2i(25, 9)   # vị trí gốc bên trái (sẽ dịch sang trái)
@export var right_pos: Vector2i = Vector2i(26, 9)  # vị trí gốc bên phải (sẽ dịch sang phải)
@export var move_distance: int = 1                  # số ô di chuyển (1)
@export var move_duration: float = 0.2              # thời gian tween giả lập
@export var reset_delay: float = 0.4                # delay trước khi reset sau khi player chết
@export var player_group: String = "player"

var tilemap: TileMap
var player = null
var has_triggered := false
var current_tween: Tween = null

# Lưu dữ liệu ban đầu
var saved_original := {}   # key = Vector2i (gốc 25,9 / 26,9) -> { "source": id, "atlas": Vector2i }
var saved_target := {}     # key = Vector2i (đích 24,9 / 27,9) -> { "source": id, "atlas": Vector2i }

func _ready():
	tilemap = get_node_or_null(tilemap_path)
	player = get_tree().get_first_node_in_group(player_group)

	if not tilemap:
		push_error("MovePlane: tilemap_path chưa được gán!")
		return

	_save_initial_tiles()

	connect("body_entered", Callable(self, "_on_body_entered"))



# Lưu thông tin tile ban đầu (cả ô gốc và ô đích)
func _save_initial_tiles():
	saved_original.clear()
	saved_target.clear()

	var left_target = left_pos + Vector2i(-move_distance, 0)
	var right_target = right_pos + Vector2i(move_distance, 0)

	for pos in [left_pos, right_pos]:
		var src = tilemap.get_cell_source_id(0, pos)
		var atlas = tilemap.get_cell_atlas_coords(0, pos)
		saved_original[pos] = { "source": src, "atlas": atlas }

	for pos in [left_target, right_target]:
		var src = tilemap.get_cell_source_id(0, pos)
		var atlas = tilemap.get_cell_atlas_coords(0, pos)
		saved_target[pos] = { "source": src, "atlas": atlas }


func _on_body_entered(body):
	if not body or not body.is_in_group(player_group):
		return
	if has_triggered:
		return

	has_triggered = true
	_move_tiles()


func _move_tiles():
	if not tilemap:
		return

	# Đính kèm tween nếu cần mô phỏng delay/animation
	if current_tween:
		current_tween.kill()
	current_tween = create_tween()

	var left_target = left_pos + Vector2i(-move_distance, 0)
	var right_target = right_pos + Vector2i(move_distance, 0)

	# Lấy dữ liệu nguồn của ô gốc
	var left_data = saved_original.get(left_pos, null)
	var right_data = saved_original.get(right_pos, null)

	# Xóa ô gốc (25,9) và (26,9)
	tilemap.set_cell(0, left_pos, -1)
	tilemap.set_cell(0, right_pos, -1)

	# Sau một khoảng nhỏ (move_duration) đặt tile vào ô đích (24,9) và (27,9)
	current_tween.tween_interval(move_duration)
	current_tween.tween_callback(func():
		# Đặt ô đích bằng dữ liệu gốc tương ứng (nếu gốc là rỗng thì đặt -1)
		if left_data and left_data["source"] != -1:
			tilemap.set_cell(0, left_target, left_data["source"], left_data["atlas"])
		else:
			# nếu ô gốc rỗng thì ta vẫn xóa ô đích (bảo đảm không vô tình ghi tile)
			tilemap.set_cell(0, left_target, -1)

		if right_data and right_data["source"] != -1:
			tilemap.set_cell(0, right_target, right_data["source"], right_data["atlas"])
		else:
			tilemap.set_cell(0, right_target, -1)
	)

	# cleanup tween ref khi xong
	current_tween.tween_callback(func():
		current_tween = null
	)


func _process(_delta):
	# nếu đã trigger và player tồn tại và hiện đã chết -> reset
	if has_triggered and player and not player.is_alive:
		# gọi hàm reset (có thể await khoảng reset_delay bên trong)
		reset_state()


# reset: chỉ xóa 2 ô đích và đặt lại 2 ô gốc
func reset_state():
	if not tilemap:
		return

	# tính ô đích
	var left_target = left_pos + Vector2i(-move_distance, 0)
	var right_target = right_pos + Vector2i(move_distance, 0)

	# 1) Xóa 2 ô đích (24,9 và 27,9)
	tilemap.set_cell(0, left_target, -1)
	tilemap.set_cell(0, right_target, -1)

	# 2) Đặt lại 2 ô gốc bằng dữ liệu đã lưu
	var left_orig = saved_original.get(left_pos, null)
	var right_orig = saved_original.get(right_pos, null)

	if left_orig and left_orig["source"] != -1:
		tilemap.set_cell(0, left_pos, left_orig["source"], left_orig["atlas"])
	else:
		tilemap.set_cell(0, left_pos, -1)

	if right_orig and right_orig["source"] != -1:
		tilemap.set_cell(0, right_pos, right_orig["source"], right_orig["atlas"])
	else:
		tilemap.set_cell(0, right_pos, -1)

	# reset trạng thái trigger
	has_triggered = false
	monitoring = true

	# hủy tween nếu còn
	if current_tween:
		current_tween.kill()
		current_tween = null
