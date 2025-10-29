extends AnimatableBody2D

@export var speed: float = 1888.8
@export var direction: int = 1

var triggered: bool = false
var start_position: Vector2

func _ready():
	start_position = global_position

func _physics_process(delta: float) -> void:
	if triggered:
		global_position.y += direction * speed * delta
	if global_position.y > 610: #đến đoạn này thì chữ sẽ dừng lại và vẫn hiện đó 
		global_position.y = 610
		triggered = false
		

func _on_saw_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Saw activated!")
		triggered = true

func reset_trap():
	global_position = start_position
	triggered = false
