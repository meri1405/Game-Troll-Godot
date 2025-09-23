extends Area2D

@export var current_level_number: int = 2  # Level hiện tại (Level 2)
@export var next_level: String = "res://All_Level/Map Level 4/Level_4.tscn"
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var has_triggered = false

func _ready():
	sprite_2d.play("default")
	
	# Update current level trong GameManager
	GameManager.current_level = current_level_number
	print("Updated current level to: ", current_level_number)

func _on_body_entered(body):
	if body.is_in_group("player") and not has_triggered:
		has_triggered = true
		complete_level()

func complete_level():
	print("🎉 LEVEL ", current_level_number, " COMPLETED! 🎉")
	
	# UNLOCK level tiếp theo
	GameManager.unlock_next_level()
	
	# Debug
	print("Current level: ", GameManager.current_level)
	print("Max level unlocked: ", GameManager.max_level_unlocked)
	print("Next level path: ", next_level)
	
	# Phát âm thanh
	$"/root/AudioController".play_level_up()

	await get_tree().create_timer(2.0).timeout
	
	# Kiểm tra file có tồn tại không
	if ResourceLoader.exists(next_level):
		
		get_tree().change_scene_to_file(next_level)
	else:
	
		get_tree().change_scene_to_file("res://level_select.tscn")
