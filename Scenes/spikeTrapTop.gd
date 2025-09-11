extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var direction = 1
var triggered = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if triggered:
		velocity += get_gravity() * delta

	

	move_and_slide()
	
func _on_spike_set_1_body_entered(body: Node2D) -> void:
	
	triggered = true
