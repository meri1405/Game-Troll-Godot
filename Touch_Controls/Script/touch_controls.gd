extends CanvasLayer
@onready var left: TouchScreenButton = $Left
@onready var right: TouchScreenButton = $Right
@onready var jump: TouchScreenButton = $Jump


func _on_left_pressed() -> void:
	left.modulate.a = 0.5


func _on_left_released() -> void:
	left.modulate.a = 1.0


func _on_right_pressed() -> void:
	right.modulate.a = 0.5


func _on_right_released() -> void:
	right.modulate.a = 1.0


func _on_jump_pressed() -> void:
	jump.modulate.a = 0.5


func _on_jump_released() -> void:
	jump.modulate.a = 1.0
