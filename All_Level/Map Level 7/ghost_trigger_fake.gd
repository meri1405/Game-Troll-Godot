extends Area2D

@export var target_path: NodePath   # drag thả Box_LeftMove vào đây

func _on_body_entered(body):
	if body.is_in_group("Player"):
		var box = get_node(target_path)
		box.activate()
	# Tìm HUD trong scene
	var hud = get_tree().current_scene.get_node("HUD")
	if hud == null:
		push_error("HUD node not found! Hãy chắc chắn rằng HUD nằm trong Level_7.")
		return

	var label := Label.new()
	label.text = "Fakeeeeee :))))"

	# Font mặc định nhưng to + outline
	label.add_theme_font_size_override("font_size", 120)
	label.add_theme_color_override("font_color", Color(1, 0.2, 0.2))
	label.add_theme_color_override("font_outline_color", Color(0, 0, 0))
	label.add_theme_constant_override("outline_size", 6)

	# Căn giữa màn hình
	var screen_size: Vector2 = get_viewport().get_visible_rect().size
	label.size = screen_size
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.modulate.a = 0.0  # bắt đầu invisible

	hud.add_child(label)

	# Hiệu ứng fade in -> giữ -> fade out
	var tween := create_tween()
	tween.tween_property(label, "modulate:a", 1.0, 0.5)
	tween.tween_interval(1.0)
	tween.tween_property(label, "modulate:a", 0.0, 0.5)
	tween.finished.connect(func():
		if is_instance_valid(label):
			label.queue_free()
	)
	
