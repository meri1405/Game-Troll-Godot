extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var triggered: bool = false

func _ready():
	visible = false
	collision_shape_2d.call_deferred("set_disabled",true)


# Biến hàm này thành 'async'
func _on_saw_trigger_body_entered(body: Node2D) -> void:
	# 1. Nếu bẫy ĐÃ được kích hoạt (đang chạy 5s), thì không làm gì cả
	if triggered:
		return

	if body.is_in_group("player"):
		print("Spike activated!")
		
		# 3. Khóa bẫy lại
		triggered = true
		
		# 4. Kích hoạt bẫy
		visible = true
		collision_shape_2d.call_deferred("set_disabled",false)

		# 5. Chờ 5 giây
		await get_tree().create_timer(3.0).timeout

		# 6. Tắt bẫy
		visible = false
		collision_shape_2d.call_deferred("set_disabled",true)

		# 7. Mở khóa bẫy, cho phép nó được kích hoạt lại
		triggered = false

func reset_trap():
	triggered = false
	visible = false
	collision_shape_2d.call_deferred("set_disabled",true)
