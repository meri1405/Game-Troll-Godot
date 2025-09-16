extends CharacterBody2D


const SPEED = 1400
var triggered = false 
var direction = -1
var start_position: Vector2

func _ready():
	start_position = global_position


func _physics_process(delta: float) -> void:
	if triggered:
		global_position.y += direction * SPEED * delta

	move_and_slide()


func _on_fan_trigger_body_entered(body: Node2D) -> void:
	triggered = true

func _on_saw_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Saw activated!")
		triggered = true

func reset_trap():
	global_position = start_position
	triggered = false
