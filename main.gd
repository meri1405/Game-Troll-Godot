extends Node2D


func _on_quit_bt_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.


func _on_start_bt_pressed() -> void:
	get_tree().change_scene_to_file("res://Level_1.tscn")
	pass # Replace with function body.
