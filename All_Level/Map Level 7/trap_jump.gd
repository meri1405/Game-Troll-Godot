extends Area2D

@onready var spike_sprite: AnimatedSprite2D = $AnimatedSprite2D
var is_active: bool = false
@export var stay_time: float = 2.0   # thời gian đứng yên trước khi rút xuống


func _ready():
	hide()
	spike_sprite.play("finish")  # ban đầu đứng im ở frame cuối
	spike_sprite.stop()


func activate():
	if is_active:
		return
	is_active = true
	show()

	# Animation trồi lên
	spike_sprite.play("default")

	# Tính thời gian của animation
	var duration = float(spike_sprite.sprite_frames.get_frame_count("default")) / spike_sprite.speed_scale / 10.0
	await get_tree().create_timer(duration).timeout

	# Dừng lại ở frame cuối
	spike_sprite.play("finish")
	spike_sprite.stop()

	# Đứng yên một lúc rồi reset
	await get_tree().create_timer(stay_time).timeout
	reset()


func reset():
	# Chạy animation rút xuống (reverse)
	spike_sprite.play("reverse")

	var duration = float(spike_sprite.sprite_frames.get_frame_count("reverse")) / spike_sprite.speed_scale / 10.0
	await get_tree().create_timer(duration).timeout

	# Dừng ở frame 0 và ẩn đi
	spike_sprite.frame = 0
	spike_sprite.stop()
	hide()

	is_active = false
