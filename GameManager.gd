extends Node

# File lưu progress
const SAVE_FILE = "user://game_progress.save"

# Dữ liệu game
var max_level_unlocked: int = 1
var current_level: int = 1

signal level_unlocked(level_number: int)

func _ready():
	load_progress()

# Lưu tiến độ
func save_progress():
	var save_file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if save_file:
		var save_data = {
			"max_level_unlocked": max_level_unlocked,
			"current_level": current_level
		}
		save_file.store_string(JSON.stringify(save_data))
		save_file.close()
		print("Progress saved: Max level ", max_level_unlocked)

# Load tiến độ
func load_progress():
	if FileAccess.file_exists(SAVE_FILE):
		var save_file = FileAccess.open(SAVE_FILE, FileAccess.READ)
		if save_file:
			var json_string = save_file.get_as_text()
			save_file.close()
			
			var json = JSON.new()
			var parse_result = json.parse(json_string)
			
			if parse_result == OK:
				var save_data = json.data
				max_level_unlocked = save_data.get("max_level_unlocked", 1)
				current_level = save_data.get("current_level", 1)
				print("Progress loaded: Max level ", max_level_unlocked)
			else:
				print("Error parsing save file")
	else:
		print("No save file found, starting fresh")

# Unlock level mới
func unlock_next_level():
	var next_level = current_level + 1
	if next_level > max_level_unlocked:
		max_level_unlocked = next_level
		level_unlocked.emit(next_level)
		save_progress()
		print("Unlocked level: ", next_level)

# Chuyển đến level
func go_to_level(level_number: int):
	current_level = level_number
	var level_path = "res://Level_" + str(level_number) + ".tscn"
	get_tree().change_scene_to_file(level_path)

# Kiểm tra level có unlock không
func is_level_unlocked(level_number: int) -> bool:
	return level_number <= max_level_unlocked

# Reset progress (debug)
func reset_progress():
	max_level_unlocked = 1
	current_level = 1
	save_progress()
