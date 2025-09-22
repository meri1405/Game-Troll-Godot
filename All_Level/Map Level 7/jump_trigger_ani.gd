extends Area2D

@export var target_path: NodePath   # drag thả Box_LeftMove vào đây

func _on_body_entered(body):
	if body.is_in_group("Player"):
		var box = get_node(target_path)
		box.activate()
