extends CharacterBody2D

const SPEED = 280.0
const JUMP_VELOCITY = -430.0
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
var is_alive = true

var spawn_point_x=0
var spawn_point_y=0

func _ready() -> void:
	spawn_point_x=global_position.x
	spawn_point_y=global_position.y
	print(spawn_point_x)
	print(spawn_point_y)
	

func _physics_process(delta: float) -> void:
	if is_alive:
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
			velocity.x = move_toward(velocity.x, 0, 15)

		move_and_slide()

		var isLeft = velocity.x < 0
		sprite_2d.flip_h = isLeft



func _do_reset():
	position = Vector2(spawn_point_x,spawn_point_y)

func die():
	is_alive = false
	sprite_2d.stop()
	sprite_2d.play("Hit")
	sprite_2d.play_backwards("Hit")
	await get_tree().create_timer(1.0).timeout
	_do_reset()
	is_alive = true

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("hurt"):
		die()
		print(position)
		print("hit enemy")


		
		
