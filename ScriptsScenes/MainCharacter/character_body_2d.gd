extends CharacterBody2D

const SPEED = 280.0
const JUMP_VELOCITY = -430.0
const FRICTION_NORMAL = 15 # Tốc độ dừng lại bình thường 
const FRICTION_ICE = 1.2   # Tốc độ dừng lại rất chậm khi trên băng

var current_speed: float = SPEED
var current_jump_velocity: float = JUMP_VELOCITY

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var camera_2d: Camera2D = $Camera2D
@onready var ground_ray: RayCast2D = get_node_or_null("RayCast2D") # an toàn hơn

var is_alive = true
var control_inverted: bool = false
var is_on_ice = false
var is_gravity_inverted = false
var is_invincible_after_spawn = false
var is_dying = false  # Ngăn multiple death calls
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var spawn_point_x = 0
var spawn_point_y = 0

# 🎨 Màu hiện tại (0 = None, 1 = Red, 2 = Yellow, ...)
var current_color: int = 0

func _ready() -> void:
	spawn_point_x = global_position.x
	spawn_point_y = global_position.y
	print(spawn_point_x, spawn_point_y)

func _physics_process(delta: float) -> void:
	if is_alive:
		# Kiểm tra chạm đất an toàn
		var on_ground = (is_on_ceiling() if is_gravity_inverted else is_on_floor()) \
						or (ground_ray and ground_ray.is_colliding())

		# Animation chạy/đứng
		if abs(velocity.x) > 1:
			sprite_2d.animation = "Running"
		else:
			sprite_2d.animation = "Idle"

		# Âm thanh bước chân
		if sprite_2d.animation == "Running" and on_ground:
			$"/root/AudioController".play_walk()
		else:
			$"/root/AudioController".stop_walk()

		# Trọng lực
		if not on_ground:
			if is_gravity_inverted:
				velocity.y -= gravity * delta
				sprite_2d.animation = "Jumping"
			else:
				velocity.y += gravity * delta
				sprite_2d.animation = "Jumping"

		# Nhảy
		if Input.is_action_just_pressed("jump") and on_ground:
			$"/root/AudioController".play_jump()
			if is_gravity_inverted:
				velocity.y = -current_jump_velocity
			else:
				velocity.y = current_jump_velocity

		# Di chuyển trái/phải
		var direction := Input.get_axis("left", "right")
		if control_inverted:
			direction = -direction
		if direction:
			velocity.x = direction * current_speed
		else:
			var current_friction = FRICTION_ICE if is_on_ice else FRICTION_NORMAL
			velocity.x = move_toward(velocity.x, 0, current_friction)

		move_and_slide()

		sprite_2d.flip_h = velocity.x < 0

# ------------------------------
# Các hàm reset, die, xử lý màu sắc...
# (giữ nguyên code của bạn, không cần sửa nhiều)
# ------------------------------

func _do_reset():
	$"/root/AudioController".play_respawn()
	position = Vector2(spawn_point_x, spawn_point_y)

func die():
	# ✅ NGĂN MULTIPLE DEATH CALLS
	if is_dying or not is_alive:
		return
		
	is_dying = true
	GameManager.increment_death_count()
	is_alive = false
	is_invincible_after_spawn = true
	sprite_2d.stop()
	sprite_2d.play("Hit")
	sprite_2d.play_backwards("Hit")

	# Reset tất cả các bẫy saw
	for saw in get_tree().get_nodes_in_group("saws"):
		if saw.has_method("reset_trap"):
			saw.reset_trap()

	# Reset lại trạng thái
	current_color = 0
	sprite_2d.modulate = Color.WHITE
	control_inverted = false
	is_gravity_inverted = false
	$Sprite2D.flip_v = false
	
	await get_tree().create_timer(1.0).timeout
	_do_reset()
	
	is_alive = true
	is_dying = false  # ✅ Reset death flag để cho phép die() lần tiếp theo
	await get_tree().create_timer(0.1).timeout
	is_invincible_after_spawn = false

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("hurt"):
		die()

func set_color(new_color: int):
	current_color = new_color
	match current_color:
		1: sprite_2d.modulate = Color.RED
		2: sprite_2d.modulate = Color.YELLOW
		3: sprite_2d.modulate = Color.BLUE
		4: sprite_2d.modulate = Color.GREEN
		5: sprite_2d.modulate = Color.HOT_PINK
		6: sprite_2d.modulate = Color.MAGENTA
		7: sprite_2d.modulate = Color.DARK_GRAY
		_: sprite_2d.modulate = Color.WHITE

func reset_color():
	current_color = 0
	sprite_2d.modulate = Color.WHITE

func _on_force_jump_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		velocity.y = current_jump_velocity * 3 

func _on_icearea_body_entered(body: Node2D) -> void:
	if body == self:
		is_on_ice = true

func _on_icearea_body_exited(body: Node2D) -> void:
	if body == self:
		is_on_ice = false

func _on_view_reverse_body_entered(body: Node2D) -> void:
	if is_invincible_after_spawn or body != self:
		return
	is_gravity_inverted = not is_gravity_inverted
	$Sprite2D.flip_v = is_gravity_inverted
	if ground_ray:
		ground_ray.target_position.y *= -1
