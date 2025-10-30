extends AnimatableBody2D

var triggered: bool = false
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animated_sprite_2d: AnimatedSprite2D = $"../TriggerBlock/AnimatedSprite2D"


func _ready():
	visible = true
	collision_shape_2d.call_deferred("set_disabled",false)


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
		visible = false
		collision_shape_2d.call_deferred("set_disabled",true)
		animated_sprite_2d.play("default")

		# 5. Chờ 5 giây
		await get_tree().create_timer(5.5).timeout

		# 6. Tắt bẫy
		visible = true
		collision_shape_2d.call_deferred("set_disabled",false)
		animated_sprite_2d.stop()

		# 7. Mở khóa bẫy, cho phép nó được kích hoạt lại
		triggered = false

func reset_trap():
	triggered = false
	visible = true
	collision_shape_2d.call_deferred("set_disabled",false)
