extends Node2D

@onready var tween := get_tree().create_tween()

func _ready():
	var target_position = global_position + Vector2(0, -500) # bay lên 200 pixels
	tween.tween_property(self, "global_position", target_position, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
