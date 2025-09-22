extends Area2D

@export var door_color: int = 1 # màu cửa
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")


var is_open: bool = false


func _on_body_entered(body):
	if body.is_in_group("Player") and not is_open:
		if body.current_color == door_color:
			print("Cửa mở thành công 🎉")
			open_door()
			body.reset_color()
		else:
			print("Sai màu → player chết 💀")
			body.die()

func open_door():
	is_open = true
	# Xóa tile cửa
	queue_free()
