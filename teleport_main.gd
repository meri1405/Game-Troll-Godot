extends Area2D

@export var target_position: Vector2 = Vector2(54, 2129)  # tọa độ dịch chuyển đến
@export var flash: ColorRect     # Kéo node Flash (ColorRect) vào đây
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var teleport_sound: AudioStreamPlayer2D = $TeleportSound

func _ready():
	sprite_2d.play("default")
	if flash:
		flash.modulate.a = 0   # ẩn flash lúc đầu
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("Player"):
		var audio_controller = get_node_or_null("/root/AudioController")

		# Tắt nhạc nền qua AudioController
		if audio_controller:
			audio_controller.stop_music()

		# Phát âm thanh teleport
		if teleport_sound:
			teleport_sound.play()

		# Hiệu ứng sáng màn hình
		if flash:
			var tween = create_tween()
			tween.tween_property(flash, "modulate:a", 1.0, 1.0) # sáng dần 1s
			tween.tween_interval(1.0)                           # giữ sáng 1s
			tween.tween_property(flash, "modulate:a", 0.0, 1.0) # mờ dần 1s

		# Rung camera
		var cam: Camera2D = body.get_node_or_null("Camera2D")
		if cam:
			shake_camera(cam, 2.0)

		# Dịch chuyển sau 2 giây
		await get_tree().create_timer(2.0).timeout
		body.global_position = target_position

		# Bật lại nhạc nền
		if audio_controller:
			audio_controller.play_music()

func shake_camera(cam: Camera2D, duration: float):
	var tween = create_tween()
	var original_offset = cam.offset

	tween.tween_method(
		func(delta):
			cam.offset = original_offset + Vector2(
				randf_range(-5, 5),
				randf_range(-5, 5)
			)
	, 0.0, duration, duration)

	tween.finished.connect(func():
		cam.offset = original_offset)
