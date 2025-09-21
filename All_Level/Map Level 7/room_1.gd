extends Area2D

@export var canvas_mod : CanvasModulate
@export var cam_limit_left: int 
@export var cam_limit_right: int 
@export var cam_limit_top: int 
@export var cam_limit_bottom: int 
@export var cam_zoom: Vector2 = Vector2(1, 1) # zoom mặc định 1x1


func _on_body_entered(body):
	if body.is_in_group("Player"):
		var player_light = body.get_node("PointLight2D")  # Light2D trong Player

		if is_in_group("Room_light"):
			canvas_mod.color = Color(1, 1, 1, 1)   # room sáng
			player_light.enabled = false          # tắt đèn

		elif is_in_group("Room_dark"):
			canvas_mod.color = Color(0, 0, 0, 1) # room tối
			player_light.enabled = true           # bật đèn

		# Cập nhật camera
		var cam = body.get_node("Camera2D")
		cam.limit_left = cam_limit_left
		cam.limit_right = cam_limit_right
		cam.limit_top = cam_limit_top
		cam.limit_bottom = cam_limit_bottom
		cam.zoom = cam_zoom
