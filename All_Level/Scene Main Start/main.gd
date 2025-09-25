extends Node2D

var tween: Tween

func _ready():
	# Connect TouchScreenButton signals
	$"Start-BT".pressed.connect(_on_start_bt_down)
	$"Start-BT".released.connect(_on_start_bt_up)
	$"LevelSelectBt".pressed.connect(_on_level_select_bt_down)
	$"LevelSelectBt".released.connect(_on_level_select_bt_up)
	$"Quit-BT".pressed.connect(_on_quit_bt_down)
	$"Quit-BT".released.connect(_on_quit_bt_up)

func animate_button_down(button: Node):
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(button, "scale", button.scale * 0.9, 0.1)

func animate_button_up(button: Node):
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(button, "scale", button.scale / 0.9, 0.1)

# Start Button
func _on_start_bt_down():
	animate_button_down($"Start-BT")

func _on_start_bt_up():
	animate_button_up($"Start-BT")
	$"/root/AudioController".play_click()
	
	# Vào level cuối cùng đã unlock thay vì current_level
	var last_unlocked = GameManager.max_level_unlocked
	print("Going to last unlocked level: ", last_unlocked)
	GameManager.go_to_level(last_unlocked)

# Level Select Button  
func _on_level_select_bt_down():
	animate_button_down($"LevelSelectBt")

func _on_level_select_bt_up():
	animate_button_up($"LevelSelectBt")
	$"/root/AudioController".play_click()
	get_tree().change_scene_to_file("res://UI/level_select_menu.tscn")

# Quit Button
func _on_quit_bt_down():
	animate_button_down($"Quit-BT")

func _on_quit_bt_up():
	animate_button_up($"Quit-BT")
	$"/root/AudioController".play_click()
	get_tree().quit()

# Keep old functions for compatibility (but they won't be called)
func _on_quit_bt_pressed() -> void:
	pass

func _on_start_bt_pressed() -> void:
	pass

func _on_level_select_bt_pressed() -> void:
	pass
