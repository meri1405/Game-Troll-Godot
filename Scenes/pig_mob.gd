extends CharacterBody2D

const speed = 350
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var direction = 1

func _physics_process(delta: float) -> void:
	if not is_on_floor():
			velocity += get_gravity() * delta
	
	velocity.x = direction * speed 
	
	sprite_2d.animation = "walking"
	sprite_2d.flip_h = true
	
	if direction < 0:
		sprite_2d.flip_h= false
			
	move_and_slide()

#func _on_movement_box_pig_area_exited(area: Area2D) -> void:
#	if not area.is_in_group("movementBox"):
#		print("hit")
#		direction = direction * -1
	


func _on_movement_box_pig_body_exited(body: Node2D) -> void:
	if body.name == "PigMob":
		print("hit")
		direction = direction * -1


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "PigMob":
		print("hit")
		direction = direction * -1
