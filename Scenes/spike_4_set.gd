extends CharacterBody2D

# Tốc độ di chuyển
@export var speed: float = 100.0
# Thời gian thay đổi hướng (giây)
@export var change_dir_time: float = 1.5

var direction := Vector2.ZERO
var time_accum := 0.0
var random = RandomNumberGenerator.new()

func _ready() -> void:
	random.randomize()
	_pick_random_direction()

func _physics_process(delta: float) -> void:
	time_accum += delta
	
	# Đổi hướng khi hết thời gian
	if time_accum >= change_dir_time:
		time_accum = 0.0
		_pick_random_direction()

	velocity = direction * speed
	move_and_slide()

func _pick_random_direction() -> void:
	# Tạo hướng ngẫu nhiên
	var angle = random.randf_range(0, TAU) # TAU = 2 * PI
	direction = Vector2.RIGHT.rotated(angle)
