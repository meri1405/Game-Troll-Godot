extends Control

# Simple debug popup test

func _ready():
	print("🔥 SIMPLE DEBUG POPUP CREATED!")
	
	# Đảm bảo full screen
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	# Tạo background đỏ để dễ thấy
	var bg = ColorRect.new()
	bg.color = Color.RED
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	
	# Tạo label lớn
	var label = Label.new()
	label.text = "🎉 POPUP TEST HIỂN THỊ THÀNH CÔNG! 🎉"
	label.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	label.add_theme_font_size_override("font_size", 32)
	add_child(label)
	
	print("📍 Debug popup ready - Position: ", position, " Size: ", size)
	
	# Auto close sau 3 giây
	await get_tree().create_timer(3.0).timeout
	print("⏰ Auto closing debug popup")
	queue_free()
