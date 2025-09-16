extends AnimatableBody2D

@export var speed: float = 500.0
@export var move_distance: float = 800.0

var direction: int = -1
var start_position: Vector2

func _ready():
	start_position = global_position

func _physics_process(delta: float) -> void:
	position.x += direction * speed * delta

	# Đảo chiều khi đến giới hạn
	if direction == 1 and position.x >= start_position.x + move_distance:
		direction = -1
	elif direction == -1 and position.x <= start_position.x:
		direction = 1
