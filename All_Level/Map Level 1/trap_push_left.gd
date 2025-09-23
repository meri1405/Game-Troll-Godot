extends Area2D

@export var push_force: int = 1000   # lực đẩy sang trái
@export var lift_height: float = 150.0  # độ cao bẫy bay lên
@export var lift_time: float = 0.5      # thời gian bay lên
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var tween := get_tree().create_tween()

func _ready():
	sprite_2d.play("default")
	hide()
	
func _on_body_entered(body):
	if body.is_in_group("Player"):
		show()
		
		# Đẩy người chơi sang trái và lên
		if body is CharacterBody2D:
			body.velocity.x = -push_force
			body.velocity.y = -700

		
		await get_tree().create_timer(0.5).timeout
		hide()
