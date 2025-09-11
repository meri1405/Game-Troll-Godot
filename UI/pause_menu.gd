extends CanvasLayer

var is_sound_on = true

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func show_menu():
	visible = true
	get_tree().paused = true

func hide_menu():
	visible = false
	get_tree().paused = false

# Thêm hàm này cho nút "Tiếp tục"
func _on_continue_button_pressed():
	hide_menu()

func _on_replay_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_home_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main.tscn")

func _on_sound_button_pressed():
	is_sound_on = !is_sound_on
	AudioServer.set_bus_mute(0, !is_sound_on)
	if is_sound_on:
		$CenterContainer/VBoxContainer/SoundButton.text = "Tắt âm thanh"
	else:
		$CenterContainer/VBoxContainer/SoundButton.text = "Bật âm thanh"


func _on_continue_pressed() -> void:
	hide_menu()
