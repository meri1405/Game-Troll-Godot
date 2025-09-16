extends Area2D

@export var move_distance_down: float = 70.0  # Khoảng cách di chuyển xuống
@export var move_distance_right: float = 60.0  # Khoảng cách di chuyển sang phải
@export var move_speed: float = 0.5  # Tốc độ di chuyển

var start_position: Vector2
var down_position: Vector2
var final_position: Vector2
var has_triggered = false

func _ready():
	start_position = global_position
	down_position = start_position + Vector2(0, move_distance_down)  # Xuống trước
	final_position = down_position + Vector2(-move_distance_right, 0)  # Sau đó sang phải
	
	body_entered.connect(_on_player_touch_deadly)
	$TriggerArea.body_entered.connect(_on_player_touch_trigger)
	
	# Thêm vào group để Player có thể reset
	add_to_group("resettable_traps")
	
	print("DeadlyObject ready at: ", global_position)
	print("Will move: Down to ", down_position, " then Right to ", final_position)

func _on_player_touch_deadly(body):
	if body.name.begins_with("CharacterBody2D"):
		print("Player touched deadly area - killing!")
		if body.has_method("die"):
			body.die()

func _on_player_touch_trigger(body):
	if body.name.begins_with("CharacterBody2D") and not has_triggered:
		print("Player triggered movement!")
		has_triggered = true
		move_object_sequence()

func move_object_sequence():
	print("Starting movement sequence...")
	
	# Tạo tween cho chuỗi di chuyển
	var tween = create_tween()
	
	# Bước 1: Di chuyển xuống
	print("Step 1: Moving down to ", down_position)
	tween.tween_property(self, "global_position", down_position, move_speed)
	
	# Bước 2: Sau khi xuống xong, di chuyển sang phải
	tween.tween_callback(func(): print("Step 2: Moving right to ", final_position))
	tween.tween_property(self, "global_position", final_position, move_speed)
	
	# Hoàn thành
	tween.tween_callback(func(): print("Movement sequence complete!"))

func reset_object():
	print("Resetting trap to start position")
	global_position = start_position
	has_triggered = false
