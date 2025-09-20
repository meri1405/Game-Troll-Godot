extends CharacterBody2D


const speed = 320
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var direction = 1
var triggered = false 
var start_position: Vector2

func _ready() -> void:
	start_position = global_position

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

func reset_trap():
	await get_tree().create_timer(1).timeout
	global_position = start_position
	velocity.x = 0
	sprite_2d.animation="idle"
	sprite_2d.flip_h = true
	triggered = false
