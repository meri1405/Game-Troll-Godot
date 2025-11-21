extends Area2D

@export var target_path: NodePath  # kéo thả Box_Move (Box_Left node)
@export var player_group: String = "player"

var box: Node = null
var triggered: bool = false
var player: Node = null
var prev_alive_state: bool = true

func _ready():
	box = get_node_or_null(target_path)
	connect("body_entered", Callable(self, "_on_body_entered"))

	# Lấy player (first node in group)
	player = get_tree().get_first_node_in_group(player_group)
	if player:
		# Nếu player có signal 'player_died' thì ưu tiên kết nối
		if player.has_signal("player_died"):
			player.player_died.connect(_on_player_died)
		# lưu trạng thái ban đầu để fallback kiểm tra trong _process
		if "is_alive" in player:
			prev_alive_state = player.is_alive
		elif player.has_method("is_alive"):
			# nếu is_alive là method, gọi method để lấy trạng thái
			prev_alive_state = player.is_alive()
		else:
			prev_alive_state = true


func _on_body_entered(body):
	if triggered or not body.is_in_group(player_group):
		return
	triggered = true
	if box and box.has_method("activate"):
		box.activate()


# Nếu player có signal 'player_died', sẽ gọi hàm này
func _on_player_died():
	_reset_trigger_and_box()


# Fallback: nếu không có signal, vẫn theo dõi is_alive mỗi frame
func _process(_delta):
	if not player:
		# cố lấy lại player nếu bị null
		player = get_tree().get_first_node_in_group(player_group)
		return

	# Nếu player có signal thì không cần fallback
	if player.has_signal("player_died"):
		return

	# Lấy trạng thái hiện tại
	var alive_now := true
	if "is_alive" in player:
		alive_now = player.is_alive
	elif player.has_method("is_alive"):
		alive_now = player.is_alive()
	# Nếu trước đó alive nhưng giờ chết -> reset
	if prev_alive_state and not alive_now:
		_on_player_died()
	prev_alive_state = alive_now


func _reset_trigger_and_box():
	# gọi reset lên box nếu có
	if box and box.has_method("reset_trap"):
		box.reset_trap()
	# reset cờ trigger, cho phép kích hoạt lại
	triggered = false
	monitoring = true
