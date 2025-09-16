extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _on_player_body_entered_box1(body: Node2D) -> void:
	if body.name == "Player":
		print("goodbye plat")
		await get_tree().create_timer(0.2).timeout
		var getHitbox = get_child(1)
		remove_child(getHitbox)
		visible = false
		await get_tree().create_timer(0.5).timeout
		print("hello plat")
		add_child(getHitbox)
		visible = true

func _on_player_body_exited_box1(body: Node2D) -> void:
	if body.name == "Player":
		pass
		


func _on_appearing_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		visible = true


func _on_appearing_2_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		visible = false
