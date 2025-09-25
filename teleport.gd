extends Area2D

@export var target_position: Vector2 = Vector2(702, 1942)  # tọa độ dịch chuyển đến
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var teleport_sound: AudioStreamPlayer2D = $TeleportAudio
func _ready():
	sprite_2d.play("default")

func _on_body_entered(body):
	if body.is_in_group("Player"):
		# Tắt điều khiển của Player
		body.is_alive = false
		body.velocity = Vector2.ZERO

		#var player_sprite: AnimatedSprite2D = body.get_node("Sprite2D")
		
		if teleport_sound:
			teleport_sound.play()
		
		## Phát animation Hit
		#player_sprite.play("Hit")
#
		## Chờ cho đến khi Hit kết thúc
		#await player_sprite.animation_finished

		# Teleport đến vị trí target
		body.global_position = target_position

		# Bật lại điều khiển
		body.is_alive = true
