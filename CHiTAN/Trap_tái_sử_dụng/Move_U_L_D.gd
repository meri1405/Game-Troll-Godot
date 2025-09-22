extends AnimatableBody2D

@export var move_up_distance: float = 63.0      # Khoảng cách đi lên
@export var move_left_distance: float = 100.0   # Khoảng cách sang trái
@export var move_down_distance: float = 63.0    # Khoảng cách xuống (thường = move_up)
@export var move_speed: float = 0.1

var start_position: Vector2
var current_step: int = 0
var move_positions: Array[Vector2] = []
var has_triggered = false
var is_moving = false
var current_tween: Tween  # Lưu reference tween hiện tại

@onready var trigger_area = $TriggerArea

func _ready():
	# Lưu vị trí ban đầu
	start_position = global_position
	
	# Tính toán các vị trí di chuyển với khoảng cách tùy chỉnh
	var pos_after_up = start_position + Vector2(0, -move_up_distance)
	var pos_after_left = pos_after_up + Vector2(-move_left_distance, 0)
	var pos_final = pos_after_left + Vector2(0, move_down_distance)
	
	move_positions = [
		pos_after_up,    # Lên
		pos_after_left,  # Sang trái
		pos_final        # Xuống
	]
	
	# Kết nối signal
	if trigger_area:
		trigger_area.body_entered.connect(_on_trigger_entered)
	
	add_to_group("moving_platforms")
	
	# Kết nối với player death signal
	connect_to_player_death()
	
	print("MovingPlatform ready at: ", global_position)
	print("Move sequence: Up(", move_up_distance, ") -> Left(", move_left_distance, ") -> Down(", move_down_distance, ")")

func connect_to_player_death():
	"""Kết nối với player death signal"""
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_signal("player_died"):
		player.player_died.connect(_on_player_died)
		print("Platform connected to player death signal")

func _on_trigger_entered(body):
	if body.name.begins_with("CharacterBody2D") and not has_triggered:
		print("Player triggered platform movement!")
		has_triggered = true
		move_platform()

func _on_player_died():
	"""Reset ngay lập tức khi player chết"""
	print("Player died - resetting platform immediately!")
	reset_platform()

func move_platform():
	if is_moving or current_step >= move_positions.size():
		return
		
	is_moving = true
	var target = move_positions[current_step]
	
	match current_step:
		0:
			print("Step 1: Moving UP ", move_up_distance, " pixels to ", target)
		1:
			print("Step 2: Moving LEFT ", move_left_distance, " pixels to ", target)
		2:
			print("Step 3: Moving DOWN ", move_down_distance, " pixels to ", target)
	
	# Dừng tween cũ nếu có
	if current_tween:
		current_tween.kill()
	
	current_tween = create_tween()
	current_tween.tween_property(self, "global_position", target, move_speed)
	current_tween.tween_callback(func(): 
		is_moving = false
		current_step += 1
		print("Step ", current_step, " completed")
		
		# Tiếp tục bước tiếp theo
		if current_step < move_positions.size():
			await get_tree().create_timer(0.2).timeout
			move_platform()
		else:
			print("All movement completed!")
			current_tween = null
	)

func reset_platform():
	print("Resetting platform to start position")
	
	# Dừng tween hiện tại
	if current_tween:
		current_tween.kill()
		current_tween = null
	
	# Dừng tất cả tweens khác (backup)
	var tweens = get_tree().get_nodes_in_group("Tween")
	for tween in tweens:
		if tween.get_parent() == self:
			tween.kill()
	
	# Reset vị trí và trạng thái
	global_position = start_position
	has_triggered = false
	is_moving = false
	current_step = 0
	
	print("Platform reset complete!")
