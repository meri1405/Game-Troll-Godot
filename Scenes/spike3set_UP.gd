extends CharacterBody2D


const SPEED = 800
var triggered = false 
var direction = -1
	
func _physics_process(delta: float) -> void:
	if triggered:
		velocity.y = direction * SPEED

	move_and_slide()


func _on_fan_trigger_body_entered(body: Node2D) -> void:
	triggered = true
