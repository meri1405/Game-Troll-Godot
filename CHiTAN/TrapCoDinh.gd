extends Area2D

func _ready():
	# Kết nối signal
	body_entered.connect(_on_body_entered)
	
	# Thêm vào group để dễ quản lý
	add_to_group("deadly_objects")

func _on_body_entered(body):
	print("Deadly object touched by: ", body.name)
	if body.is_in_group("Player"):
		print("Player died from deadly object!")
		kill_player(body)

func kill_player(player):
	if player.has_method("die"):
		player.die()
