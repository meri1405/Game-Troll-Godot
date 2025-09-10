extends Panel

func _on_sound_button_pressed():
	AudioServer.set_bus_mute(0, !AudioServer.is_bus_mute(0))

func _on_home_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")
