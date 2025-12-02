extends Node2D

func _ready():
	# Cập nhật stats khi scene được load
	update_stats()

func update_stats():
	# Tìm StatsLabel và cập nhật text
	var stats_label = $CanvasLayer/Control/StatsLabel
	if stats_label:
		var death_count = GameManager.get_death_count() if GameManager else 0
		var completed_levels = 50  # Vì đã vào WinScene nghĩa là hoàn thành tất cả 50 level
		
		stats_label.text = "[center][color=#FFFFFF]Cấp độ hoàn thành:[/color] [color=#00FF00][b]" + str(completed_levels) + "[/b][/color]\n"
		stats_label.text += "[color=#FFFFFF]Tổng số lần chết:[/color] [color=#FF5555][b]" + str(death_count) + "[/b][/color][/center]"

func _on_credits_pressed():
	print("Going to Credits...")
	get_tree().change_scene_to_file("res://UI/Credits.tscn")

func _on_menu_pressed():
	print("Going to Main Menu...")
	var menu_paths = [
		"res://UI/main_menu.tscn",
		"res://Scenes/main_menu.tscn",
		"res://MainMenu.tscn",
		"res://main_menu.tscn",
		"res://All_Level/Scene Main Start/main.tscn",
		"res://Scene Main Start/main.tscn"
	]
	
	for path in menu_paths:
		if ResourceLoader.exists(path):
			get_tree().change_scene_to_file(path)
			return
	
	print("Main menu not found!")

func _on_quit_pressed():
	print("Quitting game...")
	get_tree().quit()


func _on_menu_button_pressed() -> void:
	pass # Replace with function body.
