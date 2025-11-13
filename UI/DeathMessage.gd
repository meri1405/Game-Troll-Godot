extends CanvasLayer

@onready var label = $MessageLabel
@onready var anim = $AnimationPlayer

func show_message(text):
	print("DeathMessage: Showing message: ", text)
	label.text = text
	label.visible = true
	label.modulate.a = 0.0
	
	# Create and play fade animation
	if anim.has_animation("fade"):
		anim.play("fade")
		await anim.animation_finished
	else:
		# Manual fade if animation doesn't exist
		var tween = create_tween()
		tween.tween_property(label, "modulate:a", 1.0, 0.5)
		tween.tween_delay(2.0)
		tween.tween_property(label, "modulate:a", 0.0, 0.5)
		await tween.finished
	
	label.visible = false
	queue_free()  # Remove this instance after showing
