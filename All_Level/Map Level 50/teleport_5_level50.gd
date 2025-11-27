extends Area2D

@export var target_position: Vector2 = Vector2(-3208, -2025)  # Tọa độ dịch chuyển đến
@export var hide_on_teleport: bool = false                 # Tick để ẩn node khi chạm

@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var teleport_sound: AudioStreamPlayer2D = $TeleportAudio

var player_ref: Node = null
var is_hidden := false

func _ready():
	sprite_2d.play("default")
	set_process(true)  # bật kiểm tra player trong process

func _on_body_entered(body):
	if not body.is_in_group("Player"):
		return

	player_ref = body

	# Tắt điều khiển Player
	body.is_alive = false
	body.velocity = Vector2.ZERO

	# Phát âm thanh dịch chuyển
	if teleport_sound:
		teleport_sound.play()

	# Dịch chuyển Player
	body.global_position = target_position

	# Bật lại điều khiển
	body.is_alive = true

	# Ẩn node nếu được bật tuỳ chọn
	if hide_on_teleport:
		_hide_self()


func _hide_self():
	visible = false
	monitoring = false  # Ngăn không cho kích hoạt lại
	is_hidden = true


func _show_self():
	visible = true
	monitoring = true
	is_hidden = false


func _process(_delta):
	if is_hidden and player_ref:
		if not is_instance_valid(player_ref):
			player_ref = null
			return

		# Nếu player đã chết => hiện lại teleport
		if player_ref.has_method("is_alive"):
			if not player_ref.is_alive():
				_show_self()
				player_ref = null
		elif "is_alive" in player_ref:
			if not player_ref.is_alive:
				_show_self()
				player_ref = null
