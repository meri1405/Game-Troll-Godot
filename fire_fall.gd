extends Area2D

@export var fall_speed := 280   # tốc độ rơi

func _physics_process(delta):
	position.y += fall_speed * delta   # tự di chuyển xuống

	# Nếu rơi xuống quá xa màn hình thì xóa để tiết kiệm bộ nhớ
	if position.y > 48:  # tuỳ map
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("Player"):
		queue_free()  # biến mất sau khi gây damage
