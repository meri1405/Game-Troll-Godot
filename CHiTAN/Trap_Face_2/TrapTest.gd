# Script: deadly_trap.gd
extends Area2D

@export var move_distance: float = 45.0
@export var move_speed: float = 0.2
@export var is_active: bool = false

var start_position: Vector2
var target_position: Vector2
var has_triggered = false

func _ready():
	start_position = global_position
	target_position = start_position + Vector2(0, move_distance)
	
	body_entered.connect(_on_player_touch_deadly)
	$TriggerArea.body_entered.connect(_on_player_touch_trigger)
	
	add_to_group("resettable_traps")
	print("DeadlyTrap ready at: ", global_position)

func _on_player_touch_deadly(body):
	if body.name.begins_with("CharacterBody2D") and is_active:
		print("Player touched deadly area - killing!")
		if body.has_method("die"):
			body.die()

func _on_player_touch_trigger(body):
	print("TriggerArea touched by: ", body.name)
	print("is_active: ", is_active, " | has_triggered: ", has_triggered)
	
	if body.name.begins_with("CharacterBody2D") and not has_triggered and is_active:
		print("Player triggered trap movement!")
		has_triggered = true
		move_object()

func activate_trap():
	is_active = true
	print("Trap activated: ", name)

func move_object():
	print("Moving trap...")
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_position, move_speed)

func reset_object():
	global_position = start_position
	has_triggered = false
	is_active = false
