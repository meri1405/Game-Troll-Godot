extends Control

# ADtest popup script - Scene test cho Death5PopupManager

signal popup_closed()

func _ready():
	print("🎉 ADtest popup scene loaded successfully!")
	
	# Đảm bảo scene chiếm toàn màn hình
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	# Hiệu ứng xuất hiện
	modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.3)
	
	print("✅ ADtest scene hiển thị thành công!")
	print("📍 Scene position: ", position, " Size: ", size)

func _on_close_button_pressed():
	print("❌ Close button pressed")
	_close_popup()

func _on_test_button_pressed():
	print("🧪 Test button pressed - Triggering another popup!")
	# Test trigger popup khác
	Death5PopupManager.debug_trigger_popup()

func _close_popup():
	print("📴 Closing ADtest popup...")
	
	# Hiệu ứng biến mất
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	tween.tween_callback(_remove_popup)

func _remove_popup():
	popup_closed.emit()
	
	# Xóa CanvasLayer parent nếu có
	var parent = get_parent()
	if parent and parent.name == "PopupLayer":
		parent.queue_free()
	else:
		queue_free()
	
	print("🗑️ ADtest popup removed")

# ESC key để đóng popup
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_close_popup()

# Auto close sau 10 giây (tùy chọn)
func _on_timer_timeout():
	print("⏰ Auto closing ADtest popup after 10 seconds")
	_close_popup()