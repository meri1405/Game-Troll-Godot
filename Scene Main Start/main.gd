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
	if not is_instance_valid(button):
		return
		
	if tween:
		tween.kill()
	tween = create_tween()
	if tween:
		tween.tween_property(button, "scale", button.scale * 0.9, 0.1)

func animate_button_up(button: Node):
	if not is_instance_valid(button):
		return
		
	if tween:
		tween.kill()
	tween = create_tween()
	if tween:
		tween.tween_property(button, "scale", button.scale / 0.9, 0.1)

# Start Button
func _on_start_bt_down():
	animate_button_down($"Start-BT")

func _on_start_bt_up():
	animate_button_up($"Start-BT")
	$"/root/AudioController".play_click()
	
	# ✅ KIỂM TRA DEATH LIMIT TRƯỚC KHI VÀO GAME
	if not GameManager.can_player_die():
		show_death_limit_blocked_message()
		return
	
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
	
	# ✅ KIỂM TRA DEATH LIMIT TRƯỚC KHI VÀO LEVEL SELECT
	if not GameManager.can_player_die():
		show_death_limit_blocked_message()
		return
		
	get_tree().change_scene_to_file.call_deferred("res://UI/level_select_menu.tscn")
	
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

# ✅ HIỆN THÔNG BÁO DEATH LIMIT CHẶN GAME
func show_death_limit_blocked_message():
	# Tạo popup thông báo
	var popup_layer = CanvasLayer.new()
	popup_layer.layer = 200
	popup_layer.name = "BlockedPopup"
	add_child(popup_layer)
	
	# Background overlay
	var overlay = ColorRect.new()
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.color = Color(0, 0, 0, 0.8)
	popup_layer.add_child(overlay)
	
	# Message panel
	var panel = Panel.new()
	panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	panel.offset_left = -200
	panel.offset_right = 200
	panel.offset_top = -120
	panel.offset_bottom = 120
	
	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = Color(0.15, 0.15, 0.25, 0.95)
	panel_style.corner_radius_top_left = 15
	panel_style.corner_radius_top_right = 15
	panel_style.corner_radius_bottom_left = 15
	panel_style.corner_radius_bottom_right = 15
	panel_style.border_width_left = 3
	panel_style.border_width_right = 3
	panel_style.border_width_top = 3
	panel_style.border_width_bottom = 3
	panel_style.border_color = Color(1.0, 0.3, 0.3, 1.0)
	panel.add_theme_stylebox_override("panel", panel_style)
	overlay.add_child(panel)
	
	# Skull icon
	var skull_label = Label.new()
	skull_label.text = "💀"
	skull_label.add_theme_font_size_override("font_size", 40)
	skull_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	skull_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP)
	skull_label.offset_top = 15
	skull_label.offset_bottom = 55
	skull_label.offset_left = -25
	skull_label.offset_right = 25
	panel.add_child(skull_label)
	
	# Title
	var title_label = Label.new()
	title_label.text = "GAME BLOCKED!"
	title_label.add_theme_font_size_override("font_size", 20)
	title_label.add_theme_color_override("font_color", Color(1.0, 0.3, 0.3, 1.0))
	title_label.add_theme_color_override("font_outline_color", Color.BLACK)
	title_label.add_theme_constant_override("outline_size", 2)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP)
	title_label.offset_top = 55
	title_label.offset_bottom = 80
	title_label.offset_left = -150
	title_label.offset_right = 150
	panel.add_child(title_label)
	
	# Message
	var death_manager = GameManager.get_death_limit_manager()
	var time_data = death_manager.get_time_until_reset() if death_manager else {"hours": 0, "minutes": 0}
	
	var message_label = Label.new()
	message_label.text = "You've used all 50 lives today!\nCome back tomorrow to play again.\n\nReset in: %02d:%02d" % [time_data.hours, time_data.minutes]
	message_label.add_theme_font_size_override("font_size", 14)
	message_label.add_theme_color_override("font_color", Color.WHITE)
	message_label.add_theme_color_override("font_outline_color", Color.BLACK)
	message_label.add_theme_constant_override("outline_size", 1)
	message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	message_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	message_label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	message_label.offset_left = 20
	message_label.offset_right = -20
	message_label.offset_top = 85
	message_label.offset_bottom = -50
	panel.add_child(message_label)
	
	# OK button
	var ok_button = Button.new()
	ok_button.text = "OK"
	ok_button.add_theme_font_size_override("font_size", 16)
	ok_button.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM)
	ok_button.offset_left = -40
	ok_button.offset_right = 40
	ok_button.offset_top = -40
	ok_button.offset_bottom = -10
	ok_button.pressed.connect(_close_blocked_popup.bind(popup_layer))
	panel.add_child(ok_button)
	
	print("🚫 Game blocked - Death limit reached!")

func _close_blocked_popup(popup_layer: CanvasLayer):
	if is_instance_valid(popup_layer):
		popup_layer.queue_free()
	print("✅ Blocked popup closed")
