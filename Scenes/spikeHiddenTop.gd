extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _on_force_jump_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		global_position.y = global_position.y + 15
		await get_tree().create_timer(1.5).timeout
		global_position.y = global_position.y -15
		print("force jump")
	

func _on_player_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		global_position.y = global_position.y + 15
		await get_tree().create_timer(1.5).timeout
		global_position.y = global_position.y -15
		print("force jump")
	


func _on_disappearing_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_reset_traps_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
