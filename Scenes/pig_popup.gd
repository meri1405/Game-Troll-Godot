extends CharacterBody2D

var start_position: Vector2
	
func _ready() -> void:
	start_position = global_position

func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print(start_position)
		print("ambush")
		global_position.y = start_position.y - 30
		print(global_position.y)

func reset_trap():
	await get_tree().create_timer(1).timeout
	global_position.y = start_position.y + 30
