extends Area2D

@export var canvas_mod : CanvasModulate


func _on_body_entered(body):
	if body.is_in_group("Player"):
		var player_light = body.get_node("PointLight2D")  # Light2D trong Player

		if is_in_group("Room_light"):
			canvas_mod.color = Color(1, 1, 1, 1)   # room sáng
			player_light.enabled = false          # tắt đèn

		elif is_in_group("Room_dark"):
			canvas_mod.color = Color(0, 0, 0, 1) # room tối
			player_light.enabled = true           # bật đèn
