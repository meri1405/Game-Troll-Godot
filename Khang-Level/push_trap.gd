# PushBlock.gd
extends Area2D

@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")

@export var push_force: int = 1000  

func _ready() -> void:
	hide()

func _on_body_entered(body):
	if body.is_in_group("Player"):
		show()
		body.velocity.x = push_force
		sprite_2d.play("default")
		
		await get_tree().create_timer(1).timeout
		hide()
