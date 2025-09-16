extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	visible = false


func _on_player_body_entered_box1(body: Node2D) -> void:
	if body.name == "Player":
		visible = true


func _on_player_body_exited_box1(body: Node2D) -> void:
	if body.name == "Player":
		visible = false


func _on_appearing_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		visible = true


func _on_appearing_2_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		visible = false
