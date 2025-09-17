extends Area2D

@export var next_level: String = "" # next level
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		get_tree().change_scene_to_file(next_level)
		
func _ready():
	$AnimatedSprite2D.play("default")
