extends Area2D

@export var jumper: NodePath   # link tới node Jumper
var triggered: bool = false

func _on_body_entered(body: Node2D) -> void:
	if triggered:
		return  # đã kích hoạt rồi thì bỏ qua

	if body.is_in_group("Player"):
		var j = get_node(jumper)
		if j and j.has_method("activate"):
			j.activate()
			triggered = true   # đánh dấu chỉ chạy 1 lần

func _on_saw_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Saw activated!")
		triggered = true


func reset_trap():
	hide()
	triggered = false
