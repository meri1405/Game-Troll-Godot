extends Area2D

@export var is_active: bool = false  # Checkpoint đã được kích hoạt hay chưa
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D # nếu bạn muốn có animation cho checkpoint

func _ready():
	if sprite:
		sprite.play("idle")  # trạng thái ban đầu

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var player = body
		# Cập nhật spawn point mới cho player
		player.spawn_point_x = global_position.x
		player.spawn_point_y = global_position.y

		# Nếu muốn có hiệu ứng checkpoint được kích hoạt
		is_active = true
		if sprite:
			sprite.play("activated")

		# Có thể thêm âm thanh khi bật checkpoint
		$"/root/AudioController".play_checkpoint()
		print("Checkpoint activated at: ", global_position)
