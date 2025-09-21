extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0



func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		await get_tree().create_timer(1.5).timeout	
		print("suprise")
		await get_tree().create_timer(2).timeout
		visible = false
		get_child(1).remove_from_group("hurt")
		
