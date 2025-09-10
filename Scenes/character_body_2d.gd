extends CharacterBody2D

const startingX = -895.0
const startingY = -225.0
const SPEED = 280.0
const JUMP_VELOCITY = -430.0
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D


func _physics_process(delta: float) -> void:
	
	if (velocity.x > 1 || velocity.x < -1):
		sprite_2d.animation = "Running"
	else :
		sprite_2d.animation = "Idle"
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		sprite_2d.animation = "Jumping"

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 10)

	move_and_slide()

	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft

func _do_reset():
	position = Vector2(startingX, startingY)

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("mob"):
		_do_reset()
		
		print(position)
		print("hit enemy")
		
