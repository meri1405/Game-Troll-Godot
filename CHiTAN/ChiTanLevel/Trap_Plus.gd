# Script: deadly_trap.gd
extends Area2D

@export var move_distance_up: float = 90.0      
@export var move_distance_left: float = 300.0   
@export var move_distance_down: float = 90.0    
@export var move_speed: float = 0.5             
@export var is_active: bool = false             

var start_position: Vector2
var up_position: Vector2
var left_position: Vector2
var final_position: Vector2
var has_triggered = false
var current_tween: Tween

func _ready():
	start_position = global_position
	up_position = start_position + Vector2(0, -move_distance_up)
	left_position = up_position + Vector2(-move_distance_left, 0)
	final_position = left_position + Vector2(0, move_distance_down)
	
	body_entered.connect(_on_player_touch_deadly)
	$TriggerArea.body_entered.connect(_on_player_touch_trigger)
	
	add_to_group("resettable_traps")
	connect_to_player_death()
	
	print("DeadlyTrap ready at: ", global_position)

func connect_to_player_death():
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_signal("player_died"):
		player.player_died.connect(_on_player_died)

func _on_player_touch_deadly(body):
	if body.name.begins_with("CharacterBody2D") and is_active:
		print("Player touched deadly area - killing!")
		if body.has_method("die"):
			body.die()

func _on_player_touch_trigger(body):
	if body.name.begins_with("CharacterBody2D") and not has_triggered and is_active:
		print("Player triggered trap movement!")
		has_triggered = true
		move_object_sequence()

func activate_trap():
	"""Được gọi từ ActivationZone"""
	is_active = true
	print("Trap activated: ", name)

func _on_player_died():
	"""Reset khi player chết - bao gồm cả ActivationZone"""
	print("Player died - resetting trap and activation zones!")
	reset_object()
	reset_all_activation_zones()

func reset_all_activation_zones():
	"""Reset tất cả ActivationZone trong scene"""
	var activation_zones = get_tree().get_nodes_in_group("activation_zones")
	for zone in activation_zones:
		if zone.has_method("reset_zone"):
			zone.reset_zone()
			print("Reset activation zone: ", zone.name)

func move_object_sequence():
	print("Starting movement: Up -> Left -> Down")
	
	if current_tween:
		current_tween.kill()
	
	current_tween = create_tween()
	
	# Lên
	current_tween.tween_property(self, "global_position", up_position, move_speed)
	current_tween.tween_callback(func(): print("Moving LEFT"))
	
	# Trái
	current_tween.tween_property(self, "global_position", left_position, move_speed)
	current_tween.tween_callback(func(): print("Moving DOWN"))
	
	# Xuống
	current_tween.tween_property(self, "global_position", final_position, move_speed)
	current_tween.tween_callback(func(): 
		print("Movement complete!")
		current_tween = null
	)

func reset_object():
	if current_tween:
		current_tween.kill()
		current_tween = null
	
	global_position = start_position
	has_triggered = false
	is_active = false  # Reset cả active state
