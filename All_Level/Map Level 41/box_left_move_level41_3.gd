extends AnimatableBody2D

@export var speed: float = 300.0
@export var move_distance: float = 650.0

var direction: int = -1
var start_position: Vector2

func _ready():
	start_position = global_position

func _physics_process(delta: float) -> void:
	position.y += direction * speed * delta
	# Đảo chiều khi đến giới hạn
	if direction == 1 and position.y >= start_position.y + move_distance:
		direction = -1
	elif direction == -1 and position.y <= start_position.y:
		direction = 1
