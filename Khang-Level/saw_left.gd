extends Area2D

@export var speed: float = 300.0
@export var move_distance: float = 1200.0

var direction: int = -1
var start_position: Vector2
var is_active: bool = false
var moved_distance: float = 0.0   # theo dõi đã đi được bao xa

func _ready():
	hide()
	start_position = global_position

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
		is_active = true
		moved_distance = 0.0
		show()

func reset_block():
	is_active = false
	global_position = start_position
	hide()
