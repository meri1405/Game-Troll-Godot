extends Node2D

@export var push_speed: float = 100.0
var bodies: Array = []

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if not bodies.has(body):
			bodies.append(body)

func _on_body_exited(body):
	if body.is_in_group("Player"):
		bodies.erase(body)

func _physics_process(delta):
	for body in bodies:
		if body is CharacterBody2D and body.is_on_floor():
			# Giữ nguyên vận tốc Y, chỉ chỉnh X
			body.velocity.x = -push_speed


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
