extends Area2D

@export var next_level: String = "res://All_Level/Map Level 2/Level_2.tscn"
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	sprite_2d.play("default")

func _on_body_entered(body):
	if body.is_in_group("Player"):
		# Phát âm thanh level up từ AudioController
		$"/root/AudioController".play_level_up()

		# Đợi 1 giây rồi chuyển scene
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file(next_level)
