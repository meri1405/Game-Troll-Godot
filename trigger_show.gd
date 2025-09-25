extends Area2D

@export var block_to_show: StaticBody2D
var collision_shape: CollisionShape2D

func _ready():
	if block_to_show:
		collision_shape = block_to_show.get_node("CollisionShape2D")
		block_to_show.hide()
		if collision_shape:
			# Dùng call_deferred để đảm bảo nó được tắt sau khi mọi thứ đã sẵn sàng
			collision_shape.call_deferred("set_disabled", true)

func _on_body_entered(body):
	if body.is_in_group("player"):
		if block_to_show:
			block_to_show.show()
			if collision_shape:
				# Yêu cầu bật lại va chạm vào cuối frame
				collision_shape.call_deferred("set_disabled", false)

#func _on_body_exited(body):
	#if body.is_in_group("player"):
		#if block_to_show:
			#block_to_show.hide()
			#if collision_shape:
				## Yêu cầu tắt va chạm vào cuối frame
				#collision_shape.call_deferred("set_disabled", true)
