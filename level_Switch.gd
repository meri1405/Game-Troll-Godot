# level.gd
extends Node2D

@export var player1: CharacterBody2D
@export var player2: CharacterBody2D

# <<< XÓA BỎ: Không cần biến export cho từng box nữa
# @export var switch_box_for_p1: Area2D
# @export var switch_box_for_p2: Area2D

var current_player: CharacterBody2D

func _ready():
	# <<< THAY ĐỔI: Tự động tìm và kết nối tất cả các box trong group
	
	# Tìm tất cả node trong group 'switches_to_p2' và kết nối signal của chúng
	for box in get_tree().get_nodes_in_group("switches_to_p2"):
		box.player_entered.connect(_on_p1_box_entered)

	# Tìm tất cả node trong group 'switches_to_p1' và kết nối signal của chúng
	for box in get_tree().get_nodes_in_group("switches_to_p1"):
		box.player_entered.connect(_on_p2_box_entered)

	# Phần khởi tạo player không thay đổi
	current_player = player1
	player1.activate()
	player2.deactivate()

# Các hàm xử lý bên dưới không cần thay đổi gì cả!
# Chúng vẫn hoạt động hoàn hảo.
func _on_p1_box_entered(body):
	if body == player1 and current_player == player1:
		print("Player 1 touched a switch box. Switching to Player 2.")
		switch_player()

func _on_p2_box_entered(body):
	if body == player2 and current_player == player2:
		print("Player 2 touched a switch box. Switching to Player 1.")
		switch_player()

func switch_player():
	current_player.deactivate()
	
	if current_player == player1:
		current_player = player2
	else:
		current_player = player1
	
	current_player.activate()
