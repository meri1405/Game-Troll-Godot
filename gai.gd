extends Area2D

@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	sprite_2d.play("default")
