extends Node2D

@export var move_distance: float = 20.0    # khoảng cách trồi lên
@export var move_speed: float = 100.0      # tốc độ trồi
@export var fade_time: float = 0.4         # thời gian fade-in

var is_moving: bool = false
var start_positions: Array = []
var target_positions: Array = []

var triggered: bool = false
var start_position: Vector2

@onready var spikes: Array = [
	$GaiUp,
	$GaiUp2,
	$GaiUp3
]

@onready var collision: CollisionShape2D = $Trigger/CollisionShape2D


func _ready():
	# Lưu vị trí gốc của trap
	start_position = global_position

	# Lưu vị trí gốc và set nó "nằm dưới + alpha=0"
	for spike in spikes:
		var original_pos = spike.position
		start_positions.append(original_pos + Vector2(0, move_distance))
		target_positions.append(original_pos)

		# đặt spike xuống dưới và ẩn bằng alpha
		spike.position = start_positions.back()
		var sprite: AnimatedSprite2D = spike.get_node("AnimatedSprite2D")
		sprite.play("default")
		sprite.modulate.a = 0.0  # ban đầu tàng hình

	add_to_group("saws")  # để Player có thể reset trap khi die


func _on_trigger_entered(body):
	if body.is_in_group("Player"):
		if not is_moving:
			is_moving = true
			_show_with_effects()


func _show_with_effects():
	var tweens_done := 0
	for i in range(spikes.size()):
		var spike = spikes[i]
		var sprite: AnimatedSprite2D = spike.get_node("AnimatedSprite2D")

		var tween := create_tween()
		# chạy song song: alpha từ 0 -> 1 và position từ dưới lên
		tween.parallel().tween_property(sprite, "modulate:a", 1.0, fade_time)
		tween.parallel().tween_property(spike, "position", target_positions[i], move_distance / move_speed)

		# khi tween này xong thì check nếu tất cả xong thì clear flag
		tween.finished.connect(func():
			tweens_done += 1
			if tweens_done >= spikes.size():
				is_moving = false
		)


func _on_saw_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Saw activated!")
		triggered = true


func reset_trap():
	# Đưa trap về trạng thái ban đầu
	global_position = start_position
	triggered = false
	is_moving = false
	collision.disabled = false

	# Reset lại vị trí & alpha của spikes
	for i in range(spikes.size()):
		var spike = spikes[i]
		spike.position = start_positions[i]  # về vị trí ban đầu (nằm dưới)
		var sprite: AnimatedSprite2D = spike.get_node("AnimatedSprite2D")
		sprite.modulate.a = 0.0  # tàng hình lại

	show()  # đảm bảo trap hiện trở lại sau khi reset
