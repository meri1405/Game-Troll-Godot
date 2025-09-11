extends Control

var is_sound_on = true

func _ready():
	# Ẩn menu ban đầu
	visible = false
	# Tải trạng thái âm thanh
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		is_sound_on = !config.get_value("audio", "muted", false)
		AudioServer.set_bus_mute(0, !is_sound_on)
	update_sound_button_text()

func show_menu():
	visible = true
	get_tree().paused = true

func hide_menu():
	visible = false
	get_tree().paused = false

func _on_replay_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_home_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main.tscn") # Đổi đường dẫn của bạn

func _on_sound_button_pressed():
	is_sound_on = !is_sound_on
	AudioServer.set_bus_mute(0, !is_sound_on)
	
	# Lưu cài đặt
	var config = ConfigFile.new()
	config.load("user://settings.cfg")
	config.set_value("audio", "muted", !is_sound_on)
	config.save("user://settings.cfg")
	
	update_sound_button_text()

func update_sound_button_text():
	if is_sound_on:
		$CenterContainer/VBoxContainer/SoundButton.text = "Tắt âm thanh"
	else:
		$CenterContainer/VBoxContainer/SoundButton.text = "Bật âm thanh"
