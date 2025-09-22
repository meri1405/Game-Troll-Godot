extends Area2D

@export var next_level: String = "res://All_Level/Map Level 6/Level 6.tscn"
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	sprite_2d.play("default")

func _on_body_entered(body):
	if body.is_in_group("Player"):
		# Phát âm thanh level up từ AudioController
		$"/root/AudioController".play_level_up()

		# Đợi 1 giây rồi chuyển scene
		get_tree().change_scene_to_file(next_level)
