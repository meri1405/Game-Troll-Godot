extends CharacterBody2D

var triggered = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" and triggered == false:
		print("platform fall")
		rotate(-45)
		triggered = true
