extends CharacterBody2D


const speed = 1000
var direction = 1
var triggered = false 
var start_pos : Vector2

func _ready() -> void:
	start_pos = global_position
	print(global_position.y)

func _physics_process(delta: float) -> void:
	velocity.x = direction * speed 

			
	move_and_slide()	

func _on_box_movebox_body_exited(body: Node2D) -> void:
	#print("hit")
	if body.name == "Box":
		#print(get_parent().name)
		direction = direction * -1

func reset_trap():
	triggered = false
	velocity.x = 0
	await get_tree().create_timer(1).timeout
	global_position = start_pos
