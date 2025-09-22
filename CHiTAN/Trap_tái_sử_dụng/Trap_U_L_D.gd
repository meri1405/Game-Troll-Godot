extends Area2D

@export var move_distance_up: float = 90.0      # Khoảng cách di chuyển lên
@export var move_distance_left: float = 300.0   # Khoảng cách di chuyển sang trái
@export var move_distance_down: float = 90.0    # Khoảng cách di chuyển xuống
@export var move_speed: float = 0.5             # Tốc độ di chuyển

var start_position: Vector2
var up_position: Vector2
var left_position: Vector2
var final_position: Vector2
var has_triggered = false
var current_tween: Tween  # Lưu reference của tween hiện tại

func _ready():
	start_position = global_position
	up_position = start_position + Vector2(0, -move_distance_up)        # Lên trước
	left_position = up_position + Vector2(-move_distance_left, 0)       # Sau đó sang trái
	final_position = left_position + Vector2(0, move_distance_down)     # Cuối cùng xuống
	
	body_entered.connect(_on_player_touch_deadly)
	$TriggerArea.body_entered.connect(_on_player_touch_trigger)
	
	# Thêm vào group để Player có thể reset
	add_to_group("resettable_traps")
	
	# Kết nối với player death signal
	connect_to_player_death()
	
	print("DeadlyObject ready at: ", global_position)
	print("Movement sequence: Up to ", up_position, " -> Left to ", left_position, " -> Down to ", final_position)

func connect_to_player_death():
	# Tìm player và kết nối death signal
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_signal("player_died"):
		player.player_died.connect(_on_player_died)
		print("Connected to player death signal")

func _on_player_touch_deadly(body):
	if body.name.begins_with("CharacterBody2D"):
		print("Player touched deadly area - killing!")
		if body.has_method("die"):
			body.die()
			# Reset ngay lập tức khi player chết
			reset_object()

func _on_player_touch_trigger(body):
	if body.name.begins_with("CharacterBody2D") and not has_triggered:
		print("Player triggered movement!")
		has_triggered = true
		move_object_sequence()

func _on_player_died():
	"""Được gọi khi player chết - reset trap ngay lập tức"""
	print("Player died - resetting trap immediately!")
	reset_object()

func move_object_sequence():
	print("Starting movement sequence: Up -> Left -> Down")
	
	# Dừng tween cũ nếu có
	if current_tween:
		current_tween.kill()
	
	# Tạo tween cho chuỗi di chuyển
	current_tween = create_tween()
	
	# Bước 1: Di chuyển lên
	print("Step 1: Moving UP to ", up_position)
	current_tween.tween_property(self, "global_position", up_position, move_speed)
	
	# Bước 2: Sau khi lên xong, di chuyển sang trái
	current_tween.tween_callback(func(): print("Step 2: Moving LEFT to ", left_position))
	current_tween.tween_property(self, "global_position", left_position, move_speed)
	
	# Bước 3: Sau khi sang trái xong, di chuyển xuống
	current_tween.tween_callback(func(): print("Step 3: Moving DOWN to ", final_position))
	current_tween.tween_property(self, "global_position", final_position, move_speed)
	
	# Hoàn thành
	current_tween.tween_callback(func(): 
		print("Movement sequence complete!")
		current_tween = null
	)

func reset_object():
	print("Resetting trap to start position")
	
	# Dừng movement nếu đang di chuyển
	if current_tween:
		current_tween.kill()
		current_tween = null
	
	# Reset vị trí và trạng thái
	global_position = start_position
	has_triggered = false
