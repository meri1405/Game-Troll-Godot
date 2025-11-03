extends Area2D

@export var teleport_node: NodePath
@export var move_distance: float = 240.0        # khoảng cách dịch sang phải
@export var right_speed: float = 0.3            # thời gian chạy sang phải
@export var left_distance: float = -200.0       # khoảng cách dịch sang trái (so với start_pos)
@export var left_speed_factor: float = 3.0      # tốc độ chạy sang trái nhanh hơn
@export var wait_time: float = 0.3              # thời gian dừng lại trước khi sang trái
@export var player_group: String = "player"

var player
var teleport: Node2D
var teleport_start_pos: Vector2
var current_tween: Tween
var has_triggered := false        # Đã kích hoạt 1 lần hay chưa
var prev_alive_state := true      # Dùng để phát hiện khi player chết

func _ready():
	teleport = get_node_or_null(teleport_node)
	if teleport:
		teleport_start_pos = teleport.global_position

	player = get_tree().get_first_node_in_group(player_group)
	if player:
		# Nếu player có signal "player_died" thì kết nối
		if player.has_signal("player_died"):
			player.player_died.connect(_on_player_died)
		elif player.has_method("is_alive"):
			prev_alive_state = player.is_alive

	connect("body_entered", Callable(self, "_on_body_entered"))


func _process(_delta):
	# Nếu player không có signal, ta tự kiểm tra
	if player and not player.has_signal("player_died"):
		if prev_alive_state and player.is_alive == false:
			_on_player_died()
		prev_alive_state = player.is_alive


func _on_body_entered(body):
	if not body.is_in_group(player_group):
		return
	if not teleport:
		return
	if has_triggered:
		return # 🔒 Đã kích hoạt 1 lần rồi thì không kích hoạt lại cho đến khi player chết

	has_triggered = true
	_start_teleport_move()


func _start_teleport_move():
	if current_tween:
		current_tween.kill()
		current_tween = null

	current_tween = get_tree().create_tween()
	current_tween.connect("finished", Callable(self, "_on_tween_finished"))

	# 1️⃣ Sang phải
	var target_right = teleport.global_position + Vector2(move_distance, 0)
	current_tween.tween_property(teleport, "global_position", target_right, right_speed)

	# 2️⃣ Dừng lại
	current_tween.tween_interval(wait_time)

	# 3️⃣ Sang trái (xa hơn vị trí ban đầu)
	var target_left = teleport_start_pos + Vector2(left_distance, 0)
	current_tween.tween_property(
		teleport,
		"global_position",
		target_left,
		right_speed / left_speed_factor
	)


func _on_tween_finished():
	current_tween = null


func _on_player_died():
	reset_state()


func reset_state():
	# 🔁 Cho phép trigger lại sau khi player chết
	has_triggered = false

	if current_tween:
		current_tween.kill()
		current_tween = null

	if teleport:
		teleport.global_position = teleport_start_pos
