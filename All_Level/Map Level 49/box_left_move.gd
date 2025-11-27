extends AnimatableBody2D

@export var speed: float = 500.0
@export var move_distance: float = 155.0
@export var rise_height: float = 100.0
@export var rise_time: float = 0.2

var direction: int = -1
var start_position: Vector2
var is_active: bool = false
var moved_distance: float = 0.0

func _ready():
	hide()
	start_position = global_position

func _physics_process(delta: float) -> void:
	if not is_active:
		return

	# di chuyển sang trái
	var move_step = direction * speed * delta
	position.x += move_step
	moved_distance += abs(move_step)

	if moved_distance >= move_distance:
		reset_block()

func activate():
	if is_active:
		return
	show()
	moved_distance = 0.0
	# Trồi lên trước khi bắt đầu di chuyển
	await rise_up()
	# Bật di chuyển
	is_active = true

func rise_up() -> void:
	var target_y = start_position.y - rise_height
	var elapsed = 0.0
	while elapsed < rise_time:
		var delta = get_process_delta_time()
		elapsed += delta
		global_position.y = lerp(start_position.y, target_y, elapsed / rise_time)
		await get_tree().process_frame
	# đảm bảo vị trí chính xác
	global_position.y = target_y

func reset_block():
	is_active = false
	global_position = start_position
	hide()
