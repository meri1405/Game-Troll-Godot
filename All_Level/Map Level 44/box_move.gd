extends AnimatableBody2D

@export var speed: float = 900.0           # Tốc độ chạy sang trái
@export var move_distance: float = 460.0   # Quãng đường chạy sang trái

var direction: int = -1                    # -1 là chạy sang trái
var start_position: Vector2                # Lưu vị trí ban đầu
var is_active: bool = false                # Trap đang di chuyển hay không
var moved_distance: float = 0.0            # Đã di chuyển bao nhiêu px
var reached_end: bool = false              # Trap đã tới điểm cuối hay chưa

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

	# Đến điểm cuối → dừng hẳn (không quay về)
	if moved_distance >= move_distance:
		moved_distance = move_distance
		is_active = false
		reached_end = true
		# Trap sẽ đứng yên ở đây, không reset cho đến khi player chết

func activate():
	# Chỉ kích hoạt nếu chưa chạy xong
	if not is_active and not reached_end:
		is_active = true
		moved_distance = 0.0
		show()

# Hàm này bạn gọi khi player chết (Trigger sẽ gọi)
func reset_trap():
	# Dừng mọi chuyển động
	is_active = false
	reached_end = false
	moved_distance = 0.0
	# Trả về vị trí ban đầu
	global_position = start_position
	hide()
