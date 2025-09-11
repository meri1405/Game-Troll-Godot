extends Area2D

@export var next_level: String = "res://WinScene.tscn"
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _on_body_entered(body):
	if body.is_in_group("Player"):
		call_deferred("_go_to_next_level")

func _ready():
	$AnimatedSprite2D.play("default")

func _go_to_next_level():
	get_tree().change_scene_to_file(next_level)
