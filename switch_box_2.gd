extends Area2D

signal player_entered(body)

# Kết nối signal 'body_entered' của Area2D vào hàm này trong Editor
func _on_body_entered(body):
	# Kiểm tra xem đối tượng va chạm có phải là player không (dựa vào việc có hàm activate)
	if body.has_method("activate"):
		# Phát tín hiệu ra ngoài, gửi kèm chính player đó
		player_entered.emit(body)
