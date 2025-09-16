extends Area2D

@export var speed: float = 600.0
@export var direction: int = -1

var triggered: bool = false
var start_position: Vector2

func _ready():
	start_position = global_position

func _physics_process(delta: float) -> void:
	if triggered:
		global_position.x += direction * speed * delta

func _on_saw_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Saw activated!")
		triggered = true

func reset_trap():
	global_position = start_position
	triggered = false
