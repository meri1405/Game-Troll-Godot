extends Node2D   # hoặc Area2D nếu bạn muốn lava cũng detect player

@export var rise_speed: float = 110.0   # tốc độ dâng lên
@export var max_height: float = 1368.8  # chiều cao tối đa lava sẽ dâng tới
var is_rising: bool = false
var start_position: Vector2

func _ready() -> void:
	start_position = global_position

func _process(delta: float) -> void:
	if is_rising:
		if global_position.y > max_height:
			global_position.y -= rise_speed * delta
		else:
			is_rising = false

func _on_trigger_lava_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_rising = true

func reset_trap():	
	global_position = start_position
	is_rising = false
