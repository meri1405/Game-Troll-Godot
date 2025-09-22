# Script: two_trigger_trap.gd
extends Area2D

@export var move_down_distance: float = 200.0   # Khoảng cách di chuyển xuống
@export var move_speed: float = 1.0             # Tốc độ di chuyển
@export var appear_delay: float = 0.5           # Delay khi xuất hiện

var start_position: Vector2
var target_position: Vector2
var current_tween: Tween
var is_visible_state: bool = false
var has_moved: bool = false

# States
enum TrapState {
	HIDDEN,      # Ẩn ban đầu
	APPEARED,    # Đã xuất hiện sau trigger 1
	MOVING       # Đang di chuyển sau trigger 2
}

var current_state: TrapState = TrapState.HIDDEN

func _ready():
	start_position = global_position
	target_position = start_position + Vector2(0, move_down_distance)
	
	# Kết nối signals
	$TriggerArea1.body_entered.connect(_on_trigger_1_entered)
	$TriggerArea2.body_entered.connect(_on_trigger_2_entered)
	body_entered.connect(_on_deadly_area_entered)
	
	# Ẩn trap ban đầu
	visible = false
	set_collision_layer_value(1, false)  # Tắt collision
	
	add_to_group("resettable_traps")
	connect_to_player_death()
	
	print("Two-trigger trap ready at: ", global_position)

func connect_to_player_death():
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_signal("player_died"):
		player.player_died.connect(_on_player_died)

func _on_trigger_1_entered(body):
	if body.name.begins_with("CharacterBody2D") and current_state == TrapState.HIDDEN:
		print("Trigger 1 activated - trap appearing!")
		appear_trap()

func _on_trigger_2_entered(body):
	if body.name.begins_with("CharacterBody2D") and current_state == TrapState.APPEARED:
		print("Trigger 2 activated - trap moving down!")
		move_trap_down()

func _on_deadly_area_entered(body):
	if body.name.begins_with("CharacterBody2D") and current_state != TrapState.HIDDEN:
		print("Player touched deadly trap!")
		if body.has_method("die"):
			body.die()

func appear_trap():
	"""Xuất hiện trap sau trigger 1"""
	current_state = TrapState.APPEARED
	
	# Hiệu ứng xuất hiện
	visible = true
	set_collision_layer_value(1, true)  # Bật collision
	
	# Hiệu ứng fade in hoặc scale up
	modulate = Color(1, 1, 1, 0)  # Trong suốt
	scale = Vector2(0.1, 0.1)     # Nhỏ
	
	if current_tween:
		current_tween.kill()
	
	current_tween = create_tween()
	current_tween.set_parallel(true)  # Chạy song song
	
	# Fade in
	current_tween.tween_property(self, "modulate", Color(1, 1, 1, 1), appear_delay)
	# Scale up
	current_tween.tween_property(self, "scale", Vector2(1, 1), appear_delay)
	
	current_tween.tween_callback(func():
		print("Trap appeared! Ready for trigger 2")
		current_tween = null
	)

func move_trap_down():
	"""Di chuyển trap xuống sau trigger 2"""
	if has_moved:
		return
		
	current_state = TrapState.MOVING
	has_moved = true
	
	print("Moving trap down to: ", target_position)
	
	if current_tween:
		current_tween.kill()
	
	current_tween = create_tween()
	current_tween.tween_property(self, "global_position", target_position, move_speed)
	current_tween.tween_callback(func():
		print("Trap movement complete!")
		current_tween = null
	)

func _on_player_died():
	"""Reset khi player chết"""
	print("Player died - resetting two-trigger trap!")
	reset_object()

func reset_object():
	"""Reset trap về trạng thái ban đầu"""
	print("Resetting two-trigger trap...")
	
	# Dừng tween
	if current_tween:
		current_tween.kill()
		current_tween = null
	
	# Reset trạng thái
	current_state = TrapState.HIDDEN
	has_moved = false
	
	# Reset vị trí và visual
	global_position = start_position
	visible = false
	set_collision_layer_value(1, false)
	modulate = Color(1, 1, 1, 1)
	scale = Vector2(1, 1)
	
	print("Two-trigger trap reset complete!")
