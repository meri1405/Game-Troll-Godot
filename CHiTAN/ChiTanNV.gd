extends CharacterBody2D

const SPEED = 280.0
const JUMP_VELOCITY = -430.0
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

var is_alive = true
var can_move = true  # Thêm biến để control movement
var is_dying = false  # Ngăn multiple death calls
var spawn_point: Vector2
var original_scale: Vector2
var size_tween: Tween
var size_timer: Timer

func _ready() -> void:
	spawn_point = global_position
	original_scale = scale
	add_to_group("player")

func _physics_process(delta: float) -> void:
	if not is_alive or not can_move: return  # Thêm check can_move
	
	# Movement & Animation
	var direction = Input.get_axis("left", "right")
	velocity.x = direction * SPEED if direction else move_toward(velocity.x, 0, 15)
	sprite_2d.flip_h = velocity.x < 0
	
	# Gravity & Jump
	if not is_on_floor():
		# Kiểm tra có trong vùng GravityZone disable_world_gravity không
		var in_zero_gravity = false
		for zone in get_tree().get_nodes_in_group("gravity_zones"):
			if zone.has_method("is_player_gravity_disabled") and zone.is_player_gravity_disabled(self):
				in_zero_gravity = true
				break
		
		# Kiểm tra có trong GravityFieldZone không
		var custom_gravity = Vector2.ZERO
		var has_custom_gravity = false
		for field in get_tree().get_nodes_in_group("gravity_field_zones"):
			if field.has_method("is_player_in_zone") and field.is_player_in_zone(self):
				custom_gravity = field.get_custom_gravity_for_player(self)
				has_custom_gravity = true
				break
		
		# Áp dụng gravity
		if in_zero_gravity:
			# Không có gravity
			pass
		elif has_custom_gravity:
			# Dùng custom gravity từ GravityFieldZone
			velocity += custom_gravity * delta
		else:
			# Gravity Godot bình thường
			velocity += get_gravity() * delta
		
		sprite_2d.animation = "Jumping"
		# Tắt âm thanh đi khi nhảy
		$"/root/AudioController".stop_walk()
	elif Input.is_action_just_pressed("jump"):
		$"/root/AudioController".play_jump()
		$"/root/AudioController".stop_walk()  # Tắt walk trước khi nhảy
		velocity.y = JUMP_VELOCITY
	
	# Ground animations & sound
	if is_on_floor():
		if abs(velocity.x) > 1:
			sprite_2d.animation = "Running"
			$"/root/AudioController".play_walk()
		else:
			sprite_2d.animation = "Idle"
			$"/root/AudioController".stop_walk()
	
	move_and_slide()

# Thêm hàm control movement
func set_can_move(value: bool):
	can_move = value
	if not can_move:
		velocity = Vector2.ZERO

func die():
	# ✅ NGĂN MULTIPLE DEATH CALLS
	if is_dying or not is_alive:
		return
		
	is_dying = true
	GameManager.increment_death_count()
	is_alive = false
	sprite_2d.play("Hit")
	await get_tree().create_timer(1.0).timeout
	_reset()

func _reset():
	$"/root/AudioController".play_respawn()
	global_position = spawn_point
	is_alive = true
	is_dying = false  # ✅ Reset death flag
	can_move = true  # Reset movement
	_reset_size()
	_reset_objects()

func _reset_size():
	if size_tween: size_tween.kill()
	if size_timer: size_timer.queue_free()
	scale = original_scale

func _reset_objects():
	for group in ["resettable_traps", "moving_platforms", "activation_zones", "fruits", "teleporters", "resetable"]:
		for obj in get_tree().get_nodes_in_group(group):
			var method = "reset_object" if group == "resettable_traps" else ("reset_platform" if group == "moving_platforms" else ("reset_zone" if group == "activation_zones" else ("reset_fruit" if group == "fruits" else ("reset_teleporter" if group == "teleporters" else "reset"))))
			if obj.has_method(method): obj.call(method)

func change_size(multiplier: float, duration: float = 1.0, permanent: bool = true, temp_duration: float = 5.0):
	if size_tween: size_tween.kill()
	if size_timer: size_timer.queue_free()
	
	# Tìm CollisionShape2D của CharacterBody2D (không phải của HurtBox)
	var body_collision = null
	for child in get_children():
		if child is CollisionShape2D:
			body_collision = child
			break
	
	# Tắt collision tạm thời
	if body_collision:
		body_collision.disabled = true
	
	# Đẩy lên để tránh kẹt
	if multiplier > 1.0:
		position.y -= 25
		velocity.y = -180
	else:
		velocity.y = -80
	
	# Scale với animation mượt hơn (TRANS_CUBIC thay vì ELASTIC)
	size_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	size_tween.tween_property(self, "scale", original_scale * multiplier, duration)
	
	# Bật lại collision sau khi scale xong
	size_tween.finished.connect(func():
		await get_tree().create_timer(0.25).timeout
		if body_collision:
			body_collision.disabled = false
	)
	
	if not permanent:
		size_timer = Timer.new()
		add_child(size_timer)
		size_timer.wait_time = temp_duration
		size_timer.one_shot = true
		size_timer.timeout.connect(_reset_size)
		size_timer.start()

func is_on_moving_platform() -> bool:
	for i in get_slide_collision_count():
		if get_slide_collision(i).get_collider().is_in_group("moving_platforms"):
			return true
	return false

func get_current_platform(): 
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if collider.is_in_group("moving_platforms"): return collider
	return null

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("hurt"): die()


func _on_appearing_11_body_exited(body: Node2D) -> void:
	pass # Replace with function body.


func _on_appearing_11_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
