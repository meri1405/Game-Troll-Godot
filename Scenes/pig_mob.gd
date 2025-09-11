extends CharacterBody2D

const SPEED = 280.0
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
			velocity += get_gravity() * delta
	
	
			
	move_and_slide()
	pass
