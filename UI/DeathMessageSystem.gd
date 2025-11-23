extends Node

# Milestone death counts and their messages (Vietnamese)
var milestone_messages = {
5: "It's only been 5 times, you're far from giving up!",
10: "10 times already... But don't give up!",
15: "You've tried 15 times. Persistence is the key to success!",
20: "20 times dead... Do you want to try something else?",
25: "25 times! You're really showing off!",
30: "30 times already... Maybe you're learning something?",
40: "40 times! You're a real warrior!",
50: "50 times dead... You deserve respect!",
75: "75 times! You've surpassed your own limits!",
100: "100 times! You're a Legend!"
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
