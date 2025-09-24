extends Node2D

func _on_quit_bt_pressed() -> void:
	$"/root/AudioController".play_click()
	get_tree().quit()

func _on_start_bt_pressed() -> void:
	$"/root/AudioController".play_click()
	
	# Vào level cuối cùng đã unlock thay vì current_level
	var last_unlocked = GameManager.max_level_unlocked
	print("Going to last unlocked level: ", last_unlocked)
	GameManager.go_to_level(last_unlocked)

func _on_level_select_bt_pressed() -> void:
	$"/root/AudioController".play_click()
	get_tree().change_scene_to_file("res://UI/level_select_menu.tscn")
