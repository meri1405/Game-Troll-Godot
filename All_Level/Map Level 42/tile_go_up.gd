extends Node2D

func _ready() -> void:
	$"../MovingTileAni".play("MovingY")
	$"../MovingTileAni".speed_scale = 2.5
