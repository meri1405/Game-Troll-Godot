extends CharacterBody2D

const SPEED = 280.0
const JUMP_VELOCITY = -430.0
const FRICTION_NORMAL = 15.0 # Tốc độ dừng lại bình thường
const FRICTION_ICE = 1.2    # Tốc độ dừng lại rất chậm khi trên băng

var current_speed: float = SPEED
var current_jump_velocity: float = JUMP_VELOCITY
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera_2d: Camera2D = $Camera2D
@onready var ground_ray: RayCast2D = get_node_or_null("RayCast2D") # Thêm RayCast2D để kiểm tra đất an toàn hơn

var is_alive = true
var is_active = false # Giữ lại từ code cũ
var control_inverted: bool = false
var is_on_ice = false # Tính năng mới
var is_gravity_inverted = false # Tính năng mới
var is_invincible_after_spawn = false # Tính năng mới
var is_dying = false # Tính năng mới: Ngăn multiple death calls

var spawn_point_x=0
var spawn_point_y=0
# 🎨 Màu hiện tại (0 = None, 1 = Red, 2 = Yellow, ...)
var current_color: int = 0

func _ready() -> void:
	spawn_point_x=global_position.x
	spawn_point_y=global_position.y
	print(spawn_point_x, spawn_point_y)
	

func _physics_process(delta: float) -> void:
	if is_alive and is_active:
		# ✅ Kiểm tra chạm đất an toàn hơn
		var on_ground = (is_on_ceiling() if is_gravity_inverted else is_on_floor()) \
						or (ground_ray and ground_ray.is_colliding() and not is_gravity_inverted) \
						or (ground_ray and is_gravity_inverted and ground_ray.is_colliding() and ground_ray.target_position.y < 0)

		# Animation chạy/đứng
		if (velocity.x > 1 || velocity.x < -1):
			animated_sprite_2d.animation = "Running"
		else :
			animated_sprite_2d.animation = "Idle"
			
		# Thêm kiểm tra bước chân
		if animated_sprite_2d.animation == "Running" and on_ground:
			$"/root/AudioController".play_walk()
		else:
			$"/root/AudioController".stop_walk()
		
		# ✅ Trọng lực và Animation nhảy
		if not on_ground:
			if is_gravity_inverted:
				velocity.y -= gravity * delta
			else:
				velocity.y += gravity * delta
			animated_sprite_2d.animation = "Jumping"
			
		# ✅ Xử lý nhảy
		if Input.is_action_just_pressed("jump") and on_ground:
			$"/root/AudioController".play_jump()
			if is_gravity_inverted:
				velocity.y = -current_jump_velocity
			else:
				velocity.y = current_jump_velocity

		# Get the input direction and handle the movement/deceleration.
		var direction := Input.get_axis("left", "right")
		if control_inverted:
			direction = -direction #Đảo trí phải 
		if direction:
			velocity.x = direction * current_speed
		else:
			# ✅ Xử lý ma sát (Friction)
			var current_friction = FRICTION_ICE if is_on_ice else FRICTION_NORMAL
			velocity.x = move_toward(velocity.x, 0, current_friction)

		move_and_slide()

		var isLeft = velocity.x < 0
		animated_sprite_2d.flip_h = isLeft

# ------------------------------
# Các hàm điều khiển trạng thái (activate, deactivate)
# ------------------------------

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
	# ✅ NGĂN MULTIPLE DEATH CALLS
	if is_dying or not is_alive:
		return
		
	is_dying = true
	# Giả sử bạn có GameManager, nếu không thì bỏ dòng này
	# GameManager.increment_death_count() 
	
	is_alive = false
	is_invincible_after_spawn = true # ✅ Bất tử sau hồi sinh
	animated_sprite_2d.stop()
	animated_sprite_2d.play("Hit")
	#animated_sprite_2d.play_backwards("Hit") # Cái này có vẻ dư/sai logic, dùng await
	
	# Reset tất cả các bẫy saw về vị trí ban đầu
	for saw in get_tree().get_nodes_in_group("saws"):
		if saw.has_method("reset_trap"):
			saw.reset_trap()

	# ✅ Reset lại trạng thái
	current_color = 0
	animated_sprite_2d.modulate = Color.WHITE
	control_inverted = false
	is_gravity_inverted = false
	animated_sprite_2d.flip_v = false # Reset lật sprite dọc
	
	await get_tree().create_timer(1.0).timeout
	_do_reset()
	
	is_alive = true
	is_dying = false # ✅ Reset death flag
	await get_tree().create_timer(0.1).timeout
	is_invincible_after_spawn = false # ✅ Hết bất tử sau hồi sinh

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if is_invincible_after_spawn: # ✅ Bất tử khi mới hồi sinh
		return
	if area.is_in_group("hurt"):
		die()

# ------------------------------
# Các hàm xử lý màu sắc, nhảy và trạng thái môi trường
# ------------------------------

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
	current_color = 0
	animated_sprite_2d.modulate = Color.WHITE
		
		
func _on_force_jump_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		# Điều chỉnh nếu trọng lực đảo ngược
		if is_gravity_inverted:
			velocity.y = -current_jump_velocity * 3 
		else:
			velocity.y = current_jump_velocity * 3
	

# ✅ Xử lý băng
func _on_icearea_body_entered(body: Node2D) -> void:
	if body == self:
		is_on_ice = true

func _on_icearea_body_exited(body: Node2D) -> void:
	if body == self:
		is_on_ice = false

# ✅ Xử lý đảo ngược trọng lực
func _on_view_reverse_body_entered(body: Node2D) -> void:
	if is_invincible_after_spawn or body != self:
		return
	is_gravity_inverted = not is_gravity_inverted
	animated_sprite_2d.flip_v = is_gravity_inverted
	if ground_ray:
		ground_ray.target_position.y *= -1 # Đảo hướng raycast để kiểm tra sàn/trần
