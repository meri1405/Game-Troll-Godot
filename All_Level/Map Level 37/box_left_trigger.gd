extends Area2D

@export var target_path: NodePath  # kéo thả Box_Move
@export var player_group: String = "player"

var box
var triggered: bool = false
var player
var prev_alive_state: bool = true

func _ready():
	box = get_node(target_path)
	connect("body_entered", Callable(self, "_on_body_entered"))
	player = get_tree().get_first_node_in_group(player_group)

func _on_body_entered(body):
	if triggered or not body.is_in_group(player_group):
		return
	triggered = true
	if box:
		box.activate()

func _process(_delta):
	# fallback nếu player không có signal
	if player:
		if prev_alive_state and player.is_alive == false:
			_reset_trigger()
		prev_alive_state = player.is_alive

func _reset_trigger():
	triggered = false
	# Không cần gọi box.reset_activation(), vì box tự quay về start_position
