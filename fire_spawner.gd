extends Node2D

## Các biến có thể chỉnh sửa trong Inspector
@export var fire_scene: PackedScene
@export var spawn_area_width: float = 350.0
@export var spawn_interval: float = 1.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var trigger: Area2D = $Trigger
@onready var timer: Timer = $Timer


var is_active: bool = false

func _ready():
	animated_sprite_2d.visible = false
	
	trigger.body_entered.connect(_on_trigger_area_body_entered)
	timer.timeout.connect(_on_spawn_timer_timeout)
	
	timer.wait_time = spawn_interval

# Hàm này sẽ được gọi KHI người chơi đi vào TriggerArea
func _on_trigger_area_body_entered(body: Node2D):
	if is_active:
		return
		
	# Kiểm tra xem đối tượng đi vào có phải là "player" không
	if body.is_in_group("player"):
		print("Player has triggered the fire spawner!")
		is_active = true
		
		# 1. Cho quái vật xuất hiện
		animated_sprite_2d.visible = true
		animated_sprite_2d.play("spwan")
		await get_tree().create_timer(1.8).timeout
		animated_sprite_2d.play("default")
		
		# 2. Bắt đầu vòng lặp spawn bằng cách khởi động Timer
		timer.start()
		
		# (Tùy chọn) Vô hiệu hóa vùng trigger để nó không chạy lại
		trigger.queue_free()

# Hàm này sẽ được gọi MỖI KHI SpawnTimer đếm ngược xong
func _on_spawn_timer_timeout():
	# Kiểm tra lại để chắc chắn có scene để spawn
	if not fire_scene:
		return

	# Tạo một thực thể (instance) của quả cầu lửa
	var fire = fire_scene.instantiate()
	
	# Random vị trí X trong khu vực spawn
	var random_x = randf_range(-spawn_area_width / 2, spawn_area_width / 2)
	fire.global_position = global_position + Vector2(random_x, 0)
	
	# Thêm quả cầu lửa vào scene chính (hoặc một node quản lý đạn riêng)
	get_tree().current_scene.add_child(fire)
