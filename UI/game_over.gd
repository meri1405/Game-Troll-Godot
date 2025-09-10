extends CanvasLayer

func _on_again_pressed() -> void:
	var current_scene_path = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file(current_scene_path)

func _on_home_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
