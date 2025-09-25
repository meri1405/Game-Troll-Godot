extends Node2D

@export var move_distance: float = 40.0 # khoảng cách thụt xuống
@export var move_speed: float = 100.0   # tốc độ di chuyển
@export var fade_time: float = 0.5      # thời gian mờ dần (giây)

var is_moving: bool = false
var start_positions: Array = []
var target_positions: Array = []

@onready var spikes: Array = [
	$GaiDown,
	$GaiDown2,
	$GaiDown3
]


func _ready():
	# Lưu vị trí ban đầu và target cho từng gai
	for spike in spikes:
		start_positions.append(spike.position)                          # vị trí ban đầu
		target_positions.append(spike.position + Vector2(0, move_distance)) # vị trí thụt xuống
		
		var sprite: AnimatedSprite2D = spike.get_node("AnimatedSprite2D")
		sprite.play("default")

	add_to_group("saws") # để Player có thể reset trap khi die


func _on_trigger_entered(body):
	if body.is_in_group("Player"):
		is_moving = true


func _process(delta: float):
	if is_moving:
		var finished = true
		for i in range(spikes.size()):
			var spike = spikes[i]
			spike.position = spike.position.move_toward(target_positions[i], move_speed * delta)
			if spike.position != target_positions[i]:
				finished = false

		# Khi tất cả đã xuống đến target thì bắt đầu fade-out
		if finished:
			for spike in spikes:
				_fade_and_hide(spike)
			is_moving = false


func _fade_and_hide(spike: Area2D):
	var tween := create_tween()
	var sprite: AnimatedSprite2D = spike.get_node("AnimatedSprite2D")

	# giảm alpha từ 1 xuống 0 trong fade_time giây
	tween.tween_property(sprite, "modulate:a", 0.0, fade_time)

	# khi xong thì ẩn spike và reset alpha để lần sau xài lại
	tween.finished.connect(func():
		spike.hide()
		sprite.modulate.a = 1.0
	)


func reset_trap():
	# Reset lại vị trí, hiện lại spikes và reset alpha
	is_moving = false
	for i in range(spikes.size()):
		var spike = spikes[i]
		spike.show()
		spike.position = start_positions[i]  # đưa về vị trí ban đầu (chưa thụt xuống)
		var sprite: AnimatedSprite2D = spike.get_node("AnimatedSprite2D")
		sprite.modulate.a = 1.0              # alpha = 1 để sẵn sàng kích hoạt lại
