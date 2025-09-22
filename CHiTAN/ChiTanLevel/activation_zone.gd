# Script: activation_zone.gd
extends Area2D

@export var target_platforms: Array[NodePath]
@export var target_traps: Array[NodePath]
@export var activate_once: bool = true

var has_activated: bool = false

func _ready():
	body_entered.connect(_on_body_entered)
	
	# Thêm vào group để có thể reset
	add_to_group("activation_zones")

func _on_body_entered(body):
	if body.name.begins_with("CharacterBody2D"):
		if activate_once and has_activated:
			return
		
		# Kích hoạt platforms
		for platform_path in target_platforms:
			var platform = get_node(platform_path)
			if platform and platform.has_method("activate_platform"):
				platform.activate_platform()
		
		# Kích hoạt traps
		for trap_path in target_traps:
			var trap = get_node(trap_path)
			if trap and trap.has_method("activate_trap"):
				trap.activate_trap()
		
		has_activated = true
		print("Platforms and traps activated!")

func reset_zone():
	"""Reset ActivationZone về trạng thái ban đầu"""
	has_activated = false
	print("ActivationZone reset: ", name)
