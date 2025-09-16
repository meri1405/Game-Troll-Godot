extends CharacterBody2D


const speed = 340
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var direction = 1
var triggered = false 

	

func _physics_process(delta: float) -> void:
	if not is_on_floor():
			velocity += get_gravity() * delta
	
	
	if triggered:
		velocity.x = direction * speed 
		sprite_2d.flip_h = true
		sprite_2d.animation = "walking"
		
	move_and_slide()	
	
func _on_movement_box_pig_body_entered(body: Node2D) -> void:
	if body.name =="Player":
		print("pig chase")
		triggered = true
