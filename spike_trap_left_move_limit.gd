extends Area2D

@export var speed: float = 600.0
@export var direction: int = 1
@export var max_distance: float = 60.0  # khoảng cách tối đa

var triggered: bool = false
var start_position: Vector2

func _ready():
	start_position = global_position

func _physics_process(delta: float) -> void:
	if triggered:
		global_position.x += direction * speed * delta
		
		# kiểm tra khoảng cách đã đi được
		if abs(global_position.x - start_position.x) >= max_distance:
			triggered = false   # dừng lại ở đó

func _on_saw_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Spike activated!")
		triggered = true

func reset_trap():
	global_position = start_position
	triggered = false
