extends AnimatableBody2D

@export var move_up_distance: float = 63.0
@export var move_left_distance: float = 100.0
@export var move_down_distance: float = 63.0
@export var move_speed: float = 0.1

@export_group("Teleport")
@export var teleport_target: Vector2 = Vector2.ZERO
@export var teleport_offset: Vector2 = Vector2(0, -10)

var start_position: Vector2
var current_step: int = 0
var move_positions: Array[Vector2] = []
var has_triggered = false
var is_moving = false
var current_tween: Tween

@onready var trigger_area = $TriggerArea
@onready var teleport_area = $MapChiTan2

func _ready():
	start_position = global_position
	
	var pos_after_up = start_position + Vector2(0, -move_up_distance)
	var pos_after_left = pos_after_up + Vector2(-move_left_distance, 0)
	var pos_final = pos_after_left + Vector2(0, move_down_distance)
	
	move_positions = [pos_after_up, pos_after_left, pos_final]
	
	if trigger_area:
		trigger_area.body_entered.connect(_on_trigger_entered)
	
	if teleport_area:
		teleport_area.body_entered.connect(_on_teleport_entered)
	
	add_to_group("moving_platforms")

func _on_trigger_entered(body):
	if body.is_in_group("player") and not has_triggered:
		print("Platform movement triggered!")
		has_triggered = true
		move_platform()

func _on_teleport_entered(body):
	if body.is_in_group("player"):
		body.global_position = teleport_target + teleport_offset
		print("Player teleported to: ", teleport_target)

func move_platform():
	if is_moving or current_step >= move_positions.size():
		return
		
	is_moving = true
	var target = move_positions[current_step]
	
	if current_tween:
		current_tween.kill()
	
	current_tween = create_tween()
	current_tween.tween_property(self, "global_position", target, move_speed)
	current_tween.tween_callback(func(): 
		is_moving = false
		current_step += 1
		
		if current_step < move_positions.size():
			await get_tree().create_timer(0.2).timeout
			move_platform()
		else:
			current_tween = null
	)

func reset_platform():
	if current_tween:
		current_tween.kill()
		current_tween = null
	
	global_position = start_position
	has_triggered = false
	is_moving = false
	current_step = 0
	
	print("Platform reset complete!")
