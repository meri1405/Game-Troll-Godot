extends Area2D

@export var teleport_main: Node2D        # Kéo TeleportMain vào đây
@export var player_group: String = "Player"

var player
var is_visible_now := false              # teleport đang hiện hay không

func _ready():
	player = get_tree().get_first_node_in_group(player_group)

	if teleport_main:
		teleport_main.hide()
		teleport_main.modulate.a = 0.0

	connect("body_entered", Callable(self, "_on_body_entered"))


func _on_body_entered(body):
	if not body.is_in_group(player_group):
		return

	# Chỉ hiện nếu hiện tại đang ẩn
	if not is_visible_now:
		show_teleport()


# -----------------------------------------
# HIỆN TELEPORT
# -----------------------------------------
func show_teleport():
	if not teleport_main:
		return
	
	is_visible_now = true
	teleport_main.show()

	var tween = create_tween()
	tween.tween_property(teleport_main, "modulate:a", 1.0, 1.0)


# -----------------------------------------
# ẨN TELEPORT
# -----------------------------------------
func hide_teleport():
	if not teleport_main:
		return

	is_visible_now = false

	var tween = create_tween()
	tween.tween_property(teleport_main, "modulate:a", 0.0, 0.2)
	tween.tween_callback(func():
		teleport_main.hide())  # Ẩn hẳn sau fade-out


# -----------------------------------------
# THEO DÕI PLAYER CHẾT → ẨN TELE
# -----------------------------------------
func _process(delta):
	if teleport_main == null:
		return
	if player == null:
		player = get_tree().get_first_node_in_group(player_group)
		return

	# Khi player chết → ẩn tele + cho phép trigger hoạt động lại
	if is_visible_now and player.is_alive == false:
		hide_teleport()
