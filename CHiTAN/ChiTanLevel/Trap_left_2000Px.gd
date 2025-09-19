extends Area2D

@export var move_distance: float = 2000.0
@export var move_speed: float = 3

var start_position: Vector2
var target_position: Vector2
var has_triggered = false

func _ready():
	start_position = global_position
	target_position = start_position + Vector2(-move_distance,0)
	
	body_entered.connect(_on_player_touch_deadly)
	$TriggerArea.body_entered.connect(_on_player_touch_trigger)
	
	# Thêm vào group để Player có thể reset
	add_to_group("resettable_traps")
	
	print("DeadlyObject ready at: ", global_position)

func _on_player_touch_deadly(body):
	if body.name.begins_with("CharacterBody2D"):
		print("Player touched deadly area - killing!")
		if body.has_method("die"):
			body.die()

func _on_player_touch_trigger(body):
	if body.name.begins_with("CharacterBody2D") and not has_triggered:
		print("Player triggered movement!")
		has_triggered = true
		move_object()

func move_object():
	print("Moving object right...")
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_position, move_speed)

func reset_object():
	print("Resetting trap to start position")
	global_position = start_position
	has_triggered = false
