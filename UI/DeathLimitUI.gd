extends CanvasLayer

# UI Components - now from scene
@onready var death_counter: Control = $DeathCounter
@onready var death_label: Label = $DeathCounter/DeathLabel
@onready var time_label: Label = $DeathCounter/TimeLabel
@onready var limit_popup: Control = $LimitPopup
@onready var message_label: Label = $LimitPopup/MessagePanel/MessageLabel
@onready var menu_button: Button = $LimitPopup/MessagePanel/ButtonContainer/MenuButton

var death_manager  # Reference to DeathLimitManager AutoLoad
var update_timer: Timer

func _ready():
	# Set layer and name
	layer = 99
	name = "DeathLimitUI"
	
	# Đợi DeathLimitManager ready
	await get_tree().process_frame
	
	# Get reference to death manager (AutoLoad)
	death_manager = DeathLimitManager
	
	# Setup UI from scene
	_setup_ui()
	_connect_signals()
	_start_update_timer()
	
	print("✅ DeathLimitUI initialized from scene")

func _setup_ui():
	# Setup background style
	var bg_panel = $DeathCounter/Background
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0, 0, 0, 0.7)
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.border_width_left = 2
	style.border_width_right = 2
	style.border_width_top = 2
	style.border_width_bottom = 2
	style.border_color = Color(0.5, 0.5, 1.0, 0.8)
	bg_panel.add_theme_stylebox_override("panel", style)
	
	# Setup popup panel style
	var popup_panel = $LimitPopup/MessagePanel
	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = Color(0.15, 0.15, 0.25, 0.95)
	panel_style.corner_radius_top_left = 15
	panel_style.corner_radius_top_right = 15
	panel_style.corner_radius_bottom_left = 15
	panel_style.corner_radius_bottom_right = 15
	panel_style.border_width_left = 3
	panel_style.border_width_right = 3
	panel_style.border_width_top = 3
	panel_style.border_width_bottom = 3
	panel_style.border_color = Color(1.0, 0.3, 0.3, 1.0)
	popup_panel.add_theme_stylebox_override("panel", panel_style)
	
	# Không connect menu button ở đây vì đã connect trong scene
	# menu_button.pressed.connect(_go_to_menu)
	
	# Initial display update
	_update_display()

func _connect_signals():
	if death_manager:
		death_manager.death_count_updated.connect(_on_death_count_updated)
		death_manager.death_limit_reached.connect(_on_death_limit_reached)
		death_manager.limit_reset_for_new_day.connect(_on_limit_reset)

func _start_update_timer():
	update_timer = Timer.new()
	update_timer.wait_time = 1.0
	update_timer.timeout.connect(_update_time_display)
	update_timer.autostart = true
	add_child(update_timer)

func _update_display():
	if not death_manager or not death_label:
		return
		
	var remaining = death_manager.get_remaining_deaths()
	death_label.text = "Lives: %d/50" % remaining
	
	# Color coding based on remaining lives
	var color = Color.WHITE
	if remaining <= 0:
		color = Color(0.8, 0.2, 0.2, 1.0)  # Dark red
		death_label.text = "Lives: 0/51"
	elif remaining <= 5:
		color = Color(1.0, 0.3, 0.3, 1.0)  # Red
	elif remaining <= 15:
		color = Color(1.0, 0.7, 0.2, 1.0)  # Orange
	elif remaining <= 30:
		color = Color(1.0, 1.0, 0.4, 1.0)  # Yellow
	else:
		color = Color(0.4, 1.0, 0.4, 1.0)  # Green
	
	death_label.add_theme_color_override("font_color", color)

func _update_time_display():
	if not death_manager:
		return
		
	if death_manager.is_limit_reached():
		var time_data = death_manager.get_time_until_reset()
		time_label.text = "Reset: %02d:%02d" % [time_data.hours, time_data.minutes]
		time_label.visible = true
		
		# Update popup message if visible
		if limit_popup and limit_popup.visible and message_label:
			message_label.text = "You've died 50 times today!\nCome back tomorrow for more attempts.\n\nReset in: %02d:%02d:%02d" % [time_data.hours, time_data.minutes, time_data.seconds]
	else:
		time_label.visible = false

func _on_death_count_updated(current: int, max_deaths: int):
	_update_display()
	print("💀 UI Updated - Lives remaining: %d/%d" % [max_deaths - current, max_deaths])

func _on_death_limit_reached():
	if not is_instance_valid(self) or not death_manager:
		return
		
	var time_data = death_manager.get_time_until_reset()
	message_label.text = "You've died 50 times today!\nCome back tomorrow for more attempts.\n\nReset in: %02d:%02d:%02d" % [time_data.hours, time_data.minutes, time_data.seconds]
	limit_popup.visible = true
	if get_tree():
		get_tree().paused = true
	print("💀 Death limit popup shown")

func _on_limit_reset():
	if not is_instance_valid(self):
		return
		
	if limit_popup:
		limit_popup.visible = false
	if get_tree():
		get_tree().paused = false
	print("🌅 Death limit UI reset for new day")

func _go_to_menu():
	print("🏠 _go_to_menu() called")
	
	# Kiểm tra node còn hợp lệ trước khi xử lý
	if not is_instance_valid(self):
		print("❌ Self not valid")
		return
		
	if not get_tree():
		print("❌ get_tree() is null")
		return
		
	get_tree().paused = false
	print("✅ Game unpaused")
	
	# Try multiple menu paths
	var menu_paths = [
		"res://Scene Main Start/main.tscn",
		"res://UI/MainMenu.tscn",
		"res://MainMenu.tscn",
		"res://Scenes/MainMenu.tscn",
		"res://main_menu.tscn"
	]
	
	for path in menu_paths:
		print("🔍 Checking path: " + path)
		if ResourceLoader.exists(path):
			print("✅ Found menu at: " + path)
			get_tree().change_scene_to_file(path)
			print("🏠 Going to main menu: " + path)
			return
		else:
			print("❌ Path not found: " + path)
	
	print("❌ Main menu not found! Restarting current scene.")
	if get_tree():
		get_tree().reload_current_scene()

# For button connection from scene
func _on_menu_button_pressed():
	print("🔘 Menu button pressed!")
	_go_to_menu()

# === DEBUG FUNCTIONS ===
func debug_show_popup():
	if is_instance_valid(self):
		_on_death_limit_reached()

func debug_hide_popup():
	if not is_instance_valid(self):
		return
		
	if limit_popup:
		limit_popup.visible = false
	if get_tree():
		get_tree().paused = false

# Debug function để test menu button
func debug_test_menu_button():
	print("🧪 Testing menu button...")
	if menu_button:
		print("✅ Menu button exists")
		print("Button text: " + menu_button.text)
		print("Button disabled: " + str(menu_button.disabled))
		_on_menu_button_pressed()
	else:
		print("❌ Menu button not found!")
