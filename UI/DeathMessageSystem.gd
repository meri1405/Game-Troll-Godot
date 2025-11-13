extends Node

# Milestone death counts and their messages (Vietnamese)
var milestone_messages = {
	5: "Chỉ mới 5 lần thôi, bạn còn lâu mới từ bỏ!",
	10: "10 lần rồi... Nhưng đừng bỏ cuộc nhé!",
	15: "Bạn đã thử 15 lần. Kiên trì là chìa khóa thành công!",
	20: "20 lần chết... Bạn có muốn thử cách khác không?",
	25: "25 lần! Bạn thực sự kiên trì đấy!",
	30: "30 lần rồi... Có lẽ bạn đang học được gì đó?",
	40: "40 lần! Bạn là một chiến binh thực thụ!",
	50: "50 lần chết... Bạn xứng đáng được tôn trọng!",
	75: "75 lần! Bạn đã vượt qua giới hạn của chính mình!",
	100: "100 lần! Bạn là huyền thoại!"
}

var shown_milestones = {}

@onready var message_scene = preload("res://UI/DeathMessage.tscn")

func _ready():
	# Connect to GameManager's death signal
	if GameManager:
		GameManager.death_count_changed.connect(_on_death_count_changed)
		print("DeathMessageSystem: Connected to GameManager")
	else:
		print("DeathMessageSystem: GameManager not found!")

func _on_death_count_changed(death_count):
	print("DeathMessageSystem: Death count changed to ", death_count)
	
	if death_count in milestone_messages and not shown_milestones.has(death_count):
		shown_milestones[death_count] = true
		_show_death_message(milestone_messages[death_count])
		print("DeathMessageSystem: Showing message for ", death_count, " deaths")

func _show_death_message(text):
	print("DeathMessageSystem: Creating message: ", text)
	var msg_instance = message_scene.instantiate()
	get_tree().current_scene.add_child(msg_instance)
	msg_instance.show_message(text)