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
	
	# Thêm vào group để các object có thể tìm
	add_to_group("player")

func _physics_process(delta: float) -> void:
	if is_alive:
		if (velocity.x > 1 || velocity.x < -1):
			sprite_2d.animation = "Running"
		else :
			sprite_2d.animation = "Idle"
			
		# Thêm kiểm tra bước chân
		if sprite_2d.animation == "Running" and is_on_floor():
			$"/root/AudioController".play_walk()
		else:
			$"/root/AudioController".stop_walk()
		
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta
			sprite_2d.animation = "Jumping"

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			$"/root/AudioController".play_jump()
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
	$"/root/AudioController".play_respawn()
	position = Vector2(spawn_point_x, spawn_point_y)
	
	# Reset tất cả objects trong level
	reset_all_objects()

func reset_all_objects():
	print("Resetting all objects...")
	
	# Reset traps (deadly objects)
	var traps = get_tree().get_nodes_in_group("resettable_traps")
	for trap in traps:
		if trap.has_method("reset_object"):
			trap.reset_object()
			print("Reset trap at: ", trap.global_position)
	
	# Reset moving platforms
	var platforms = get_tree().get_nodes_in_group("moving_platforms")
	for platform in platforms:
		if platform.has_method("reset_platform"):
			platform.reset_platform()
			print("Reset platform at: ", platform.global_position)
	
	# Reset bất kỳ object nào khác có method reset
	var resetables = get_tree().get_nodes_in_group("resetable")
	for obj in resetables:
		if obj.has_method("reset"):
			obj.reset()

func die():
	print("Player died!")
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

# Thêm method để check player đang đứng trên platform di chuyển
func is_on_moving_platform() -> bool:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider and collider.is_in_group("moving_platforms"):
			return true
	return false

# Method để get platform đang đứng (nếu cần)
func get_current_platform():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider and collider.is_in_group("moving_platforms"):
			return collider
	return null
