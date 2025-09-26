extends Area2D

@export var speed: float = 400.0
@export var direction: int = -1

var triggered: bool = false
var start_position: Vector2

func _ready():
	start_position = global_position
	visible = true
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	if triggered:
		global_position.y += direction * speed * delta
		if global_position.y < -800:
			visible = false
			set_physics_process(false)

func _on_saw_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Saw activated!")
		triggered = true

func reset_trap():
	global_position = start_position
	triggered = false
