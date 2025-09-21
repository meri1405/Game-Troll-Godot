extends CharacterBody2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		visible = false
		await get_tree().create_timer(4).timeout
		visible = true
	
