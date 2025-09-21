extends Area2D

@export var speed: float = 270.0
@export var move_distance: float = 1500.0
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera: Camera2D = get_tree().get_first_node_in_group("MainCamera") # gán camera trong group
@onready var scream_player: AudioStreamPlayer2D = $ScreamPlayer

var direction: int = 1
var start_position: Vector2
var is_active: bool = false
var moved_distance: float = 0.0   # theo dõi đã đi được bao xa

func _ready():
	hide()
	sprite_2d.play("default")
	start_position = global_position
	modulate.a = 0.0   # ẩn dần ban đầu
	scale = Vector2(0.5, 0.5) # nhỏ lại để tween phóng to

func _physics_process(delta: float) -> void:
	if not is_active:
		return

	# di chuyển
	var move_step = direction * speed * delta
	position.x += move_step
	moved_distance += abs(move_step)

	# nếu đi đủ khoảng thì reset
	if moved_distance >= move_distance:
		reset_block()

func activate():
	if not is_active:  # chỉ cho kích hoạt nếu đang nghỉ
		show()
		moved_distance = 0.0
		
		# Phát âm thanh la hét
		if scream_player:
			scream_player.play()

		# Tween xuất hiện (fade in + scale to)
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate:a", 1.0, 0.3) # từ từ hiện lên
		tween.tween_property(self, "scale", Vector2(1, 1), 0.2) # từ nhỏ -> to

		# Rung camera
		if camera:
			shake_camera(camera, 0.5, 6.0)

		await tween.finished
		is_active = true

func reset_block():
	is_active = false
	global_position = start_position
	hide()
	modulate.a = 0.0
	scale = Vector2(0.5, 0.5)


# Hàm rung camera
func shake_camera(cam: Camera2D, duration: float, strength: float):
	var tween = get_tree().create_tween()
	var original_offset = cam.offset
	var time_passed := 0.0

	while time_passed < duration:
		var rand_offset = Vector2(randf_range(-strength, strength), randf_range(-strength, strength))
		cam.offset = original_offset + rand_offset
		await get_tree().create_timer(0.05).timeout
		time_passed += 0.05

	cam.offset = original_offset
