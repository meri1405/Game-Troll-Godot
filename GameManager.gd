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

# Chuyển đến level - SỬA ĐƯỜNG DẪN
func go_to_level(level_number: int):
	current_level = level_number
	
	# Đường dẫn theo cấu trúc folder của bạn
	var level_path = "res://All_Level/Map Level " + str(level_number) + "/Level_" + str(level_number) + ".tscn"
	
	# Kiểm tra file có tồn tại không
	if ResourceLoader.exists(level_path):
		get_tree().change_scene_to_file(level_path)
		print("Loading level: ", level_path)
	else:
		print("Level file not found: ", level_path)
		# Fallback - thử đường dẫn khác
		try_alternative_paths(level_number)

# Thử các đường dẫn khác nếu không tìm thấy
func try_alternative_paths(level_number: int):
	var alternative_paths = [
		"res://All_Level/Map Level " + str(level_number) + "/Level_2.tscn",  # Nếu tên file cố định
		"res://All_Level/Map Level " + str(level_number) + "/level_" + str(level_number) + ".tscn",  # Lowercase
		"res://All_Level/Map Level " + str(level_number) + "/map_level_" + str(level_number) + ".tscn"  # Khác
	]
	
	for path in alternative_paths:
		if ResourceLoader.exists(path):
			get_tree().change_scene_to_file(path)
			print("Found alternative path: ", path)
			return
	
	print("No valid level file found for level ", level_number)

# Kiểm tra level có unlock không
func is_level_unlocked(level_number: int) -> bool:
	return level_number <= max_level_unlocked

# Reset progress (debug)
func reset_progress():
	max_level_unlocked = 1
	current_level = 1
	save_progress()

# Helper function để list tất cả levels có sẵn
func get_available_levels() -> Array[int]:
	var available_levels: Array[int] = []
	
	for i in range(1, 10):  # Check levels 1-9
		var level_path = "res://All_Level/Map Level " + str(i) + "/Level_" + str(i) + ".tscn"
		if ResourceLoader.exists(level_path):
			available_levels.append(i)
	
	return available_levels

# Debug function để in ra tất cả paths
func debug_check_levels():
	print("=== CHECKING LEVEL PATHS ===")
	for i in range(1, 6):
		var level_path = "res://All_Level/Map Level " + str(i) + "/Level_" + str(i) + ".tscn"
		var exists = ResourceLoader.exists(level_path)
		print("Level ", i, ": ", level_path, " - Exists: ", exists)
