extends Area2D

@export var push_force: int = 1000   # lực đẩy sang trái

func _on_body_entered(body):
	if body.is_in_group("Player"):
		# Nếu Player là CharacterBody2D thì chỉnh velocity
		if body is CharacterBody2D:
			body.velocity.x = -push_force
			body.velocity.y = -700   # tùy chọn: thêm lực nhảy lên một chút
