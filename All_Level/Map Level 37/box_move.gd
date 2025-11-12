extends AnimatableBody2D

@export var speed: float = 700.0
@export var move_distance: float = 220.0
@export var wait_time: float = 2  # thời gian dừng trước khi quay về

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

	# Di chuyển sang trái
	var move_step = direction * speed * delta
	position.x += move_step
	moved_distance += abs(move_step)

	# Khi đi đủ khoảng → dừng, 0.3s sau quay về
	if moved_distance >= move_distance:
		is_active = false
		moved_distance = move_distance
		await _wait_and_return()

func activate():
	if not is_active:
		is_active = true
		moved_distance = 0.0
		show()

# Dừng 0.3s rồi quay về start_position
func _wait_and_return() -> void:
	await get_tree().create_timer(wait_time).timeout
	global_position = start_position
	hide()
