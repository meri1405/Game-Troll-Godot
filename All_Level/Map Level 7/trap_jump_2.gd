extends Area2D

@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var pickup_player: AudioStreamPlayer2D = $Pickup


func _ready():
	hide()



func _on_body_entered(body):
	if body.is_in_group("Player"):
		# Hiện Gai + bật animation
		
		show()
		if pickup_player:
			pickup_player.play()
		sprite_2d.play("default")  # hoặc "attack" tùy bạn đặt tên trong Sprite
		collision.disabled = false
		body.die()
		

		# Sau 0.2s thì ẩn
		await get_tree().create_timer(0.4).timeout
		hide()
