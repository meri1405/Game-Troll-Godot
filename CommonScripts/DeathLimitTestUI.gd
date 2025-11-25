extends CanvasLayer

@onready var status_label: Label = $TestPanel/VBox/StatusLabel
var death_manager: DeathLimitManager

func _ready():
	layer = 200
	name = "DeathLimitTestUI"
	
	# Get death manager
	death_manager = GameManager.get_death_limit_manager()
	if not death_manager:
		push_error("DeathLimitManager not found!")
		queue_free()
		return
	
	# Connect signals for auto-update
	death_manager.death_count_updated.connect(_update_status)
	death_manager.death_limit_reached.connect(_on_limit_reached)
	death_manager.limit_reset_for_new_day.connect(_on_limit_reset)
	
	# Update initial status
	_update_status(death_manager.current_deaths, death_manager.MAX_DEATHS_PER_DAY)
	
	print("🧪 Death Limit Test UI ready!")

func _update_status(current: int, max_deaths: int):
	if status_label:
		var remaining = max_deaths - current
		status_label.text = "Deaths: %d/%d (Lives: %d)" % [current, max_deaths, remaining]
		
		# Color coding
		if remaining <= 0:
			status_label.add_theme_color_override("font_color", Color.RED)
		elif remaining <= 5:
			status_label.add_theme_color_override("font_color", Color.ORANGE)
		elif remaining <= 15:
			status_label.add_theme_color_override("font_color", Color.YELLOW)
		else:
			status_label.add_theme_color_override("font_color", Color.GREEN)

func _on_limit_reached():
	print("🚨 TEST: Death limit reached!")

func _on_limit_reset():
	print("🌅 TEST: Death limit reset!")

# Button handlers
func _on_reset_pressed():
	death_manager.force_reset()
	print("🔄 Reset deaths to 0")

func _on_add1_pressed():
	GameManager.increment_death_count()
	print("💀 Added 1 death")

func _on_add10_pressed():
	for i in range(10):
		if not GameManager.increment_death_count():
			print("💀 Stopped at death limit")
			break
	print("💀 Added deaths (attempted 10)")

func _on_set40_pressed():
	death_manager.debug_set_deaths(40)
	print("🎯 Set deaths to 40 (10 lives left)")

func _on_set49_pressed():
	death_manager.debug_set_deaths(49)
	print("⚠️ Set deaths to 49 (1 life left)")

func _on_set50_pressed():
	death_manager.debug_set_deaths(50)
	print("💀 Set deaths to 50 (0 lives left)")

func _on_show_popup_pressed():
	var current_scene = get_tree().current_scene
	var death_ui = current_scene.get_node_or_null("DeathLimitUI")
	if death_ui:
		death_ui.debug_show_popup()
		print("💀 Showing death limit popup")
	else:
		print("❌ DeathLimitUI not found in scene")

func _on_hide_popup_pressed():
	var current_scene = get_tree().current_scene
	var death_ui = current_scene.get_node_or_null("DeathLimitUI")
	if death_ui:
		death_ui.debug_hide_popup()
		print("✅ Hiding death limit popup")
	else:
		print("❌ DeathLimitUI not found in scene")

func _on_close_pressed():
	queue_free()
	print("🚪 Test UI closed")

# Keyboard shortcuts
func _input(event):
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_F1:
				_on_reset_pressed()
			KEY_F2:
				_on_add1_pressed()
			KEY_F3:
				_on_set40_pressed()
			KEY_F4:
				_on_set49_pressed()
			KEY_F5:
				_on_set50_pressed()
			KEY_ESCAPE:
				_on_close_pressed()

# Static function để load test UI từ bất kỳ đâu
static func show_test_ui():
	var current_scene = Engine.get_main_loop().current_scene
	if current_scene.get_node_or_null("DeathLimitTestUI"):
		print("Test UI already exists")
		return
	
	var test_scene = preload("res://UI/DeathLimitTestUI.tscn")
	var test_instance = test_scene.instantiate()
	current_scene.add_child(test_instance)
	print("🧪 Death Limit Test UI loaded!")

# Function để test từ console
static func quick_test():
	print("=== DEATH LIMIT QUICK TEST ===")
	var manager = GameManager.get_death_limit_manager()
	if not manager:
		print("❌ Manager not found")
		return
	
	print("Current: %d/%d" % [manager.current_deaths, manager.MAX_DEATHS_PER_DAY])
	print("Remaining: %d" % manager.get_remaining_deaths())
	print("Can die: %s" % str(manager.can_die()))
	print("Time until reset: %s" % str(manager.get_time_until_reset()))
	print("===============================")
