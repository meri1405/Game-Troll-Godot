extends Control

# Custom Popup Script - Dễ dàng tùy chỉnh

signal popup_closed()

func _ready():
	print("🎨 CustomPopup loaded!")
	
	# Đảm bảo full screen
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	# Animation hiệu ứng
	modulate.a = 0.0
	scale = Vector2(0.8, 0.8)
	
	var tween = create_tween()
	tween.parallel().tween_property(self, "modulate:a", 1.0, 0.4)
	tween.parallel().tween_property(self, "scale", Vector2.ONE, 0.4)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	
	print("✅ CustomPopup animation started")

func _on_close_pressed():
	print("👆 Close button pressed")
	_close_with_animation()

func _close_with_animation():
	print("🎭 Closing with animation...")
	
	var tween = create_tween()
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.3)
	tween.parallel().tween_property(self, "scale", Vector2(0.7, 0.7), 0.3)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_callback(_emit_close_signal)

func _emit_close_signal():
	popup_closed.emit()
	print("📴 CustomPopup closed")

# ESC để đóng
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_close_with_animation()

# Click background để đóng (tùy chọn)
func _on_background_clicked():
	_close_with_animation()