extends Node

# File lưu progress
const SAVE_FILE = "user://game_progress.save"

# Dữ liệu game
var max_level_unlocked: int = 10
var current_level: int = 1
var death_count: int = 0

signal level_unlocked(level_number: int)
signal death_count_changed(new_count: int)

func _ready():
	load_progress()

# Lưu tiến độ
func save_progress():
	var save_file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if save_file:
		var save_data = {
			"max_level_unlocked": max_level_unlocked,
			"current_level": current_level,
			"death_count": death_count
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
				death_count = save_data.get("death_count", 0)
				print("Progress loaded: Max level ", max_level_unlocked, ", Deaths: ", death_count)
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
	print("GameManager: Switching to level ", level_number)
	
	# Đường dẫn theo cấu trúc folder của bạn
	var level_path = "res://All_Level/Map Level " + str(level_number) + "/Level_" + str(level_number) + ".tscn"
	
	# Kiểm tra file có tồn tại không
	if ResourceLoader.exists(level_path):
		get_tree().change_scene_to_file.call_deferred(level_path)
		print("Loading level: ", level_path)
		# Show level title after a short delay
		call_deferred("show_simple_level_title")
		print("Level title function called")
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
			get_tree().change_scene_to_file.call_deferred(path)
			print("Found alternative path: ", path)
			return
	
	print("No valid level file found for level ", level_number)
	
	# ✅ CHUYỂN QUA WINSCENE KHI KHÔNG CÓ LEVEL TIẾP THEO
	print("🎉 All levels completed! Going to WinScene...")
	go_to_win_scene()

# ✅ HÀM MỚI: Chuyển qua WinScene
func go_to_win_scene():
	var win_scene_path = "res://winScreen/WinScene.tscn"
	
	if ResourceLoader.exists(win_scene_path):
		get_tree().change_scene_to_file.call_deferred(win_scene_path)
		print("✅ Loaded WinScene successfully!")
	else:
		# Thử các đường dẫn khác
		var alternative_win_paths = [
			"res://UI/WinScene.tscn",
			"res://Scenes/WinScene.tscn",
			"res://win_scene.tscn",
			"res://UI/win_scene.tscn"
		]
		
		for path in alternative_win_paths:
			if ResourceLoader.exists(path):
				get_tree().change_scene_to_file.call_deferred(path)
				print("✅ Found WinScene at: ", path)
				return
		
		print("❌ WinScene not found!")

# Kiểm tra level có unlock không
func is_level_unlocked(level_number: int) -> bool:
	return level_number <= max_level_unlocked

# Reset progress (debug)
func reset_progress():
	max_level_unlocked = 1
	current_level = 1
	death_count = 0
	save_progress()

# Tăng death count
func increment_death_count():
	death_count += 1
	death_count_changed.emit(death_count)
	save_progress()
	print("Death count: ", death_count)

# Get death count
func get_death_count() -> int:
	return death_count

# Reset death count
func reset_death_count():
	death_count = 0
	death_count_changed.emit(death_count)
	save_progress()

# Helper function để list tất cả levels có sẵn
func get_available_levels() -> Array[int]:
	var available_levels: Array[int] = []
	
	for i in range(1, 10):  # Check levels 1-9
		var level_path = "res://All_Level/Map Level " + str(i) + "/Level_" + str(i) + ".tscn"
		if ResourceLoader.exists(level_path):
			available_levels.append(i)
	
	return available_levels

func show_simple_level_title():
	# Wait for scene to be ready
	await get_tree().process_frame
	await get_tree().process_frame
	
	if get_tree().current_scene:
		# Update current_level based on actual scene
		var detected_level = detect_level_from_scene()
		if detected_level != current_level:
			print("Updating current_level from ", current_level, " to ", detected_level)
			current_level = detected_level
		
		print("Creating level title for level: ", current_level)
		# Create level title directly without external script
		create_level_title_ui()

func create_level_title_ui():
	# Detect actual level number from scene path
	var actual_level = detect_level_from_scene()
	print("Detected level from scene: ", actual_level)
	
	# Create CanvasLayer for UI overlay
	var canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 100  # Top layer
	canvas_layer.name = "PermanentLevelTitle"  # Give it a name for easy access
	get_tree().current_scene.add_child(canvas_layer)
	
	# Create Control container
	var control = Control.new()
	control.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	canvas_layer.add_child(control)
	
	# Create beautiful Label with glow effect - NO BACKGROUND PANEL
	var label = Label.new()
	label.text = "LEVEL " + str(actual_level)
	label.add_theme_font_size_override("font_size", 48)  # Nhỏ hơn: 48px thay vì 64px
	label.add_theme_color_override("font_color", Color(1.0, 1.0, 0.8, 1.0))  # Light yellow
	label.add_theme_color_override("font_outline_color", Color(0.2, 0.1, 0.5, 1.0))  # Dark purple outline
	label.add_theme_constant_override("outline_size", 4)  # Outline nhỏ hơn: 4px thay vì 6px
	
	# Add shadow effect
	label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.8))
	label.add_theme_constant_override("shadow_offset_x", 2)  # Shadow nhỏ hơn
	label.add_theme_constant_override("shadow_offset_y", 2)  # Shadow nhỏ hơn
	label.add_theme_constant_override("shadow_outline_size", 1)  # Shadow outline nhỏ hơn
	
	# Position label at top center - higher and smaller
	label.anchor_left = 0.5
	label.anchor_right = 0.5
	label.anchor_top = 0.0
	label.anchor_bottom = 0.0
	label.offset_left = -120  # Nhỏ hơn: -120 thay vì -150
	label.offset_right = 120   # Nhỏ hơn: 120 thay vì 150
	label.offset_top = 15      # Lên trên: 15px thay vì 30px
	label.offset_bottom = 65   # Chiều cao nhỏ hơn: 65 thay vì 90
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	control.add_child(label)
	
	print("Permanent beautiful level title created: ", label.text)
	
	# NO AUTO-REMOVE - Display permanently!

func detect_level_from_scene() -> int:
	var scene_path = get_tree().current_scene.scene_file_path
	print("Analyzing scene path: ", scene_path)
	
	# Extract number from paths like:
	# "res://All_Level/Map Level 1/Level_1.tscn"
	# "res://All_Level/Map Level 2/Level_2.tscn"
	var regex = RegEx.new()
	regex.compile("Level[_ ](\\d+)")
	var result = regex.search(scene_path)
	
	if result:
		var level_num = int(result.get_string(1))
		print("Found level number: ", level_num)
		return level_num
	
	# Fallback: try to extract from "Map Level X" pattern
	regex.compile("Map Level (\\d+)")
	result = regex.search(scene_path)
	if result:
		var level_num = int(result.get_string(1))
		print("Found level number from Map Level: ", level_num)
		return level_num
	
	print("Could not detect level number, using current_level: ", current_level)
	return current_level

# Test function để kiểm tra level title manually
func test_level_title():
	print("Testing level title display...")
	create_level_title_ui()

# Debug function để in ra tất cả paths
func debug_check_levels():
	print("=== CHECKING LEVEL PATHS ===")
	for i in range(1, 6):
		var level_path = "res://All_Level/Map Level " + str(i) + "/Level_" + str(i) + ".tscn"
		var exists = ResourceLoader.exists(level_path)
		print("Level ", i, ": ", level_path, " - Exists: ", exists)
