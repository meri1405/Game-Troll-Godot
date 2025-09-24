# Script: death_counter_manager.gd (Autoload)
extends Node

const SAVE_FILE = "user://death_counts.save"

# Dictionary lưu số lần chết của từng level
var death_counts: Dictionary = {}
var current_level: int = 1
var session_deaths: int = 0  # Số lần chết trong session hiện tại

signal death_count_updated(level: int, count: int)

func _ready():
	load_death_counts()

# Tăng số lần chết cho level hiện tại
func add_death(level_number: int = current_level):
	if not death_counts.has(level_number):
		death_counts[level_number] = 0
	
	death_counts[level_number] += 1
	session_deaths += 1
	
	print("Level ", level_number, " deaths: ", death_counts[level_number])
	print("Session deaths: ", session_deaths)
	
	# Emit signal để update UI
	death_count_updated.emit(level_number, death_counts[level_number])
	
	# Auto save
	save_death_counts()

# Lấy số lần chết của level
func get_death_count(level_number: int) -> int:
	return death_counts.get(level_number, 0)

# Lấy tổng số lần chết tất cả level
func get_total_deaths() -> int:
	var total = 0
	for count in death_counts.values():
		total += count
	return total

# Set level hiện tại
func set_current_level(level_number: int):
	current_level = level_number
	session_deaths = 0

# Lưu data
func save_death_counts():
	var save_file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if save_file:
		var save_data = {
			"death_counts": death_counts,
			"total_deaths": get_total_deaths(),
			"save_date": Time.get_datetime_string_from_system()
		}
		save_file.store_string(JSON.stringify(save_data))
		save_file.close()
		print("Death counts saved: ", death_counts)

# Load data
func load_death_counts():
	if FileAccess.file_exists(SAVE_FILE):
		var save_file = FileAccess.open(SAVE_FILE, FileAccess.READ)
		if save_file:
			var json_string = save_file.get_as_text()
			save_file.close()
			
			var json = JSON.new()
			var parse_result = json.parse(json_string)
			
			if parse_result == OK:
				var save_data = json.data
				death_counts = save_data.get("death_counts", {})
				print("Death counts loaded: ", death_counts)
			else:
				print("Error parsing death counts file")
	else:
		print("No death counts file found, starting fresh")

# Reset death count cho 1 level
func reset_level_deaths(level_number: int):
	death_counts[level_number] = 0
	save_death_counts()

# Reset tất cả death counts
func reset_all_deaths():
	death_counts.clear()
	session_deaths = 0
	save_death_counts()

# Debug function
func debug_print_stats():
	print("=== DEATH STATISTICS ===")
	for level in range(1, 11):  # Level 1-10
		print("Level ", level, ": ", get_death_count(level), " deaths")
	print("Total deaths: ", get_total_deaths())
	print("Session deaths: ", session_deaths)
