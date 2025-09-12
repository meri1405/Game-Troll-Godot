extends CharacterBody2D


const speed = 250
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var direction = 1
var triggered = false 

func _physics_process(delta: float) -> void:
	
	
	velocity.x = direction * speed 
		
	sprite_2d.animation = "Running"
	sprite_2d.speed_scale = 50
			
	move_and_slide()	

func _on_saw_movebox_body_exited(body: Node2D) -> void:
	#print("hit")
	if body.name == "Saw":
		#print(get_parent().name)
		direction = direction * -1


func _on_saw_2_body_exited(body: Node2D) -> void:
	if body.name=="Saw2":
		direction = direction * -1


func _on_saw_3_body_exited(body: Node2D) -> void:
	
	if body.name=="Saw3":
		print("Saw3 exit")
		direction = direction * -1
	
