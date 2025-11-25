extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var sound: AudioStreamPlayer2D = $Sound   # <-- Âm thanh nhấn nút

var activated: bool = false
var player


func _ready():
	reset_button()

	# Tìm player
	player = get_tree().get_first_node_in_group("Player")


func _on_body_entered(body):
	if body.is_in_group("Player") and not activated:
		activated = true
		
		# Chạy animation
		anim.play("default")
		anim.frame = 0
		
		# Play sound
		if sound:
			sound.play()


func _process(delta):
	# Dừng animation ở frame 5
	if activated and anim.frame >= 5:
		anim.stop()
		anim.frame = 5

	# Nếu player chết thì reset button
	if player and not player.is_alive and activated:
		reset_button()


func reset_button():
	activated = false
	anim.stop()
	anim.frame = 0
