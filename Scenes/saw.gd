extends CharacterBody2D


const speed = 300
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var direction = -1
var triggered = false 

func _physics_process(delta: float) -> void:
	
	if triggered:
		velocity.x = direction * speed 
		
		sprite_2d.animation = "Running"
		sprite_2d.speed_scale = 50
			
	move_and_slide()


func _on_movement_box_saw_body_entered(body: Node2D) -> void:
	await get_tree().create_timer(0.2).timeout
	print("saw")
	triggered = true
