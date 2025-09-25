extends CharacterBody2D

const SPEED = 280.0
const JUMP_VELOCITY = -430.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera_2d: Camera2D = $Camera2D
var is_alive = true
var control_inverted: bool = false
var is_active = false

var spawn_point_x=0
var spawn_point_y=0
# 🎨 Màu hiện tại (0 = None, 1 = Red, 2 = Yellow, ...)
var current_color: int = 0

func _ready() -> void:
	spawn_point_x=global_position.x
	spawn_point_y=global_position.y
	print(spawn_point_x)
	print(spawn_point_y)
	

func _physics_process(delta: float) -> void:
	if is_alive and is_active:
		if (velocity.x > 1 || velocity.x < -1):
			animated_sprite_2d.animation = "Running"
		else :
			animated_sprite_2d.animation = "Idle"
			
		# Thêm kiểm tra bước chân
		if animated_sprite_2d.animation == "Running" and is_on_floor():
			$"/root/AudioController".play_walk()
		else:
			$"/root/AudioController".stop_walk()
		
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta
			animated_sprite_2d.animation = "Jumping"

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			$"/root/AudioController".play_jump()
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("left", "right")
		if control_inverted:
			direction = -direction #Đảo trí phải 
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, 15)

		move_and_slide()

		var isLeft = velocity.x < 0
		animated_sprite_2d.flip_h = isLeft

func activate():
	is_active = true
	camera_2d.enabled = true

func deactivate():
	is_active = false
	velocity = Vector2.ZERO # Dừng player ngay lập tức
	animated_sprite_2d.animation = "Idle" # Chuyển về animation đứng yên
	camera_2d.enabled = false

func _do_reset():
	$"/root/AudioController".play_respawn()
	position = Vector2(spawn_point_x,spawn_point_y)

func die():
	
	is_alive = false
	animated_sprite_2d.stop()
	animated_sprite_2d.play("Hit")
	animated_sprite_2d.play_backwards("Hit")
	# Reset tất cả các bẫy saw về vị trí ban đầu
	for saw in get_tree().get_nodes_in_group("saws"):
		if saw.has_method("reset_trap"):
			saw.reset_trap()

	# Reset lại màu
	current_color = 0
	animated_sprite_2d.modulate = Color.WHITE
	#reset lại cơ chế nút trái phải 
	control_inverted = false
	
	await get_tree().create_timer(1.0).timeout
	_do_reset()
	
	is_alive = true
	await get_tree().create_timer(1).timeout

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("hurt"):
		die()
		print(position)
		print("hit enemy")

func set_color(new_color: int):
	current_color = new_color
	match current_color:
		1: animated_sprite_2d.modulate = Color.RED
		2: animated_sprite_2d.modulate = Color.YELLOW
		3: animated_sprite_2d.modulate = Color.BLUE
		4: animated_sprite_2d.modulate = Color.GREEN
		5: animated_sprite_2d.modulate = Color.HOT_PINK
		6: animated_sprite_2d.modulate = Color.MAGENTA
		7: animated_sprite_2d.modulate = Color.DARK_GRAY
		_: animated_sprite_2d.modulate = Color.WHITE

func reset_color():
	# Reset lại màu
	current_color = 0
	animated_sprite_2d.modulate = Color.WHITE
		
		
func _on_force_jump_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		velocity.y = JUMP_VELOCITY * 3 
	
