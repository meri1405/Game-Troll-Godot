extends Node

# AutoLoad Singleton for Death Limit Management
# Constants
const MAX_DEATHS_PER_DAY := 50
const SAVE_FILE := "user://death_limit.dat"

# Data
var current_deaths: int = 0
var last_reset_date: String = ""
var _is_limit_reached: bool = false

# Signals
signal death_limit_reached
signal death_count_updated(current: int, max_deaths: int)
signal limit_reset_for_new_day

func _ready():
	_load_data()
	_check_daily_reset()
	
	# Auto-save mỗi 60 giây để tránh mất data
	var timer = Timer.new()
	timer.wait_time = 60.0
	timer.timeout.connect(_auto_save)
	timer.autostart = true
	add_child(timer)
	
	print("✅ DeathLimitManager initialized - Deaths: %d/%d, Date: %s" % [current_deaths, MAX_DEATHS_PER_DAY, last_reset_date])

# === PUBLIC API ===
func can_die() -> bool:
	return current_deaths < MAX_DEATHS_PER_DAY and not _is_limit_reached

func try_add_death() -> bool:
	if not can_die():
		if not _is_limit_reached:
			_is_limit_reached = true
			death_limit_reached.emit()
			print("💀 Death limit reached! (%d/%d)" % [current_deaths, MAX_DEATHS_PER_DAY])
		return false
	
	current_deaths += 1
	death_count_updated.emit(current_deaths, MAX_DEATHS_PER_DAY)
	_save_data()
	
	print("💀 Death added: %d/%d remaining lives" % [get_remaining_deaths(), MAX_DEATHS_PER_DAY])
	
	if current_deaths >= MAX_DEATHS_PER_DAY:
		_is_limit_reached = true
		death_limit_reached.emit()
		return false
	
	return true

func get_remaining_deaths() -> int:
	return max(0, MAX_DEATHS_PER_DAY - current_deaths)

func get_time_until_reset() -> Dictionary:
	var now = Time.get_datetime_dict_from_system()
	var seconds_until_midnight = (24 - now.hour) * 3600 - now.minute * 60 - now.second
	
	return {
		"hours": seconds_until_midnight / 3600,
		"minutes": (seconds_until_midnight % 3600) / 60,
		"seconds": seconds_until_midnight % 60,
		"total_seconds": seconds_until_midnight
	}

func force_reset() -> void:
	current_deaths = 0
	_is_limit_reached = false
	last_reset_date = Time.get_date_string_from_system()
	death_count_updated.emit(current_deaths, MAX_DEATHS_PER_DAY)
	_save_data()
	limit_reset_for_new_day.emit()
	print("🔄 Death limit manually reset")

func is_limit_reached() -> bool:
	return _is_limit_reached

# === PRIVATE METHODS ===
func _check_daily_reset() -> void:
	var today = Time.get_date_string_from_system()
	if last_reset_date != today:
		var old_deaths = current_deaths
		current_deaths = 0
		_is_limit_reached = false
		last_reset_date = today
		_save_data()
		
		if old_deaths > 0:
			limit_reset_for_new_day.emit()
			print("🌅 New day! Death limit reset from %d to 0" % old_deaths)
		death_count_updated.emit(current_deaths, MAX_DEATHS_PER_DAY)

func _save_data() -> void:
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file == null:
		push_error("❌ Cannot save death limit data!")
		return
		
	var data = {
		"version": 1,
		"current_deaths": current_deaths,
		"last_reset_date": last_reset_date,
		"timestamp": Time.get_unix_time_from_system()
	}
	
	file.store_var(data, true) # true = full_objects for better compression
	file.close()
	# print("💾 Death limit data saved") # Comment để tránh spam

func _load_data() -> void:
	if not FileAccess.file_exists(SAVE_FILE):
		last_reset_date = Time.get_date_string_from_system()
		print("📁 No death limit save file found, starting fresh")
		return
		
	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	if file == null:
		push_error("❌ Cannot load death limit data!")
		return
		
	var data = file.get_var(true)
	file.close()
	
	if typeof(data) != TYPE_DICTIONARY:
		print("⚠️ Invalid death limit save data, resetting")
		return
		
	current_deaths = data.get("current_deaths", 0)
	last_reset_date = data.get("last_reset_date", Time.get_date_string_from_system())
	
	# Validate data integrity
	current_deaths = clampi(current_deaths, 0, MAX_DEATHS_PER_DAY)
	
	if current_deaths >= MAX_DEATHS_PER_DAY:
		_is_limit_reached = true
	
	print("💾 Death limit data loaded - Deaths: %d, Date: %s" % [current_deaths, last_reset_date])

func _auto_save() -> void:
	_save_data()

# === DEBUG FUNCTIONS ===
func debug_add_deaths(count: int) -> void:
	for i in count:
		if not try_add_death():
			break
	print("🐛 DEBUG: Added %d deaths, total: %d/%d" % [count, current_deaths, MAX_DEATHS_PER_DAY])

func debug_set_deaths(count: int) -> void:
	current_deaths = clampi(count, 0, MAX_DEATHS_PER_DAY)
	_is_limit_reached = current_deaths >= MAX_DEATHS_PER_DAY
	death_count_updated.emit(current_deaths, MAX_DEATHS_PER_DAY)
	_save_data()
	if _is_limit_reached:
		death_limit_reached.emit()
	print("🐛 DEBUG: Set deaths to %d/%d" % [current_deaths, MAX_DEATHS_PER_DAY])
