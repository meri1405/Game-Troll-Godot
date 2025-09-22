extends Area2D

@export var push_force: int = 1000   # lực đẩy sang trái
@export var lift_height: float = 150.0  # độ cao bẫy bay lên
@export var lift_time: float = 0.5      # thời gian bay lên

@onready var tween := get_tree().create_tween()

func _on_body_entered(body):
	if body.is_in_group("Player"):
		# Đẩy người chơi sang trái và lên
		if body is CharacterBody2D:
			body.velocity.x = -push_force
			body.velocity.y = -700

		# Cho bẫy bay lên
		var target_pos = global_position - Vector2(0, lift_height)
		tween.tween_property(self, "global_position", target_pos, lift_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
