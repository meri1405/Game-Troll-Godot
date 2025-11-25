extends Node

# Test script cho Death Limit System
# Gọi các function này từ console hoặc thêm vào scene để test

func _ready():
	print("🧪 Death Limit Test Script loaded")
	print("Available test commands:")
	print("- test_death_limit()")
	print("- test_ui_display()")
	print("- test_save_load()")
	print("- test_daily_reset()")

# Test chính: chết 50+ lần
func test_death_limit():
	print("\n🧪 TESTING DEATH LIMIT SYSTEM")
	print("=".repeat(50))
	
	var manager = GameManager.get_death_limit_manager()
	if not manager:
		print("❌ DeathLimitManager not found!")
		return
	
	print("Initial state:")
	print("- Current deaths: %d" % manager.current_deaths)
	print("- Can die: %s" % str(manager.can_die()))
	print("- Remaining lives: %d" % manager.get_remaining_deaths())
	
	print("\n🎯 Testing deaths...")
	
	# Test chết từng lần
	for i in range(55):  # Test 55 lần để chắc chắn vượt limit
		var can_die = GameManager.increment_death_count()
		var remaining = manager.get_remaining_deaths()
		
		if i % 10 == 0 or remaining <= 5 or not can_die:
			print("Death #%d - Remaining: %d - Can die: %s" % [i + 1, remaining, str(can_die)])
		
		if not can_die:
			print("💀 DEATH LIMIT REACHED at death #%d" % (i + 1))
			break
		
		await get_tree().process_frame  # Cho UI cập nhật
	
	print("\nFinal state:")
	print("- Total deaths: %d" % manager.current_deaths)
	print("- Game Manager deaths: %d" % GameManager.death_count)
	print("- Limit reached: %s" % str(manager.is_limit_reached()))
	print("- Time until reset: %s" % str(manager.get_time_until_reset()))

# Test UI hiển thị
func test_ui_display():
	print("\n🎨 TESTING UI DISPLAY")
	print("=".repeat(30))
	
	# Test các mức deaths khác nhau
	var test_values = [0, 10, 25, 35, 45, 48, 49, 50]
	
	for deaths in test_values:
		GameManager.debug_set_deaths(deaths)
		print("Set deaths to %d - Remaining: %d" % [deaths, 50 - deaths])
		await get_tree().create_timer(1.0).timeout  # Đợi UI cập nhật
	
	print("✅ UI display test completed")

# Test save/load data
func test_save_load():
	print("\n💾 TESTING SAVE/LOAD")
	print("=".repeat(25))
	
	var manager = GameManager.get_death_limit_manager()
	if not manager:
		print("❌ DeathLimitManager not found!")
		return
	
	# Lưu state hiện tại
	var original_deaths = manager.current_deaths
	print("Original deaths: %d" % original_deaths)
	
	# Set deaths và save
	manager.debug_set_deaths(30)
	print("Set deaths to 30 and saved")
	
	# Simulate reload (reset và load lại)
	manager._load_data()
	print("After reload - Deaths: %d" % manager.current_deaths)
	
	# Restore original
	manager.debug_set_deaths(original_deaths)
	print("Restored to original: %d" % manager.current_deaths)
	
	print("✅ Save/load test completed")

# Test daily reset
func test_daily_reset():
	print("\n🌅 TESTING DAILY RESET")
	print("=".repeat(25))
	
	var manager = GameManager.get_death_limit_manager()
	if not manager:
		print("❌ DeathLimitManager not found!")
		return
	
	print("Before reset:")
	print("- Deaths: %d" % manager.current_deaths)
	print("- Date: %s" % manager.last_reset_date)
	print("- Limit reached: %s" % str(manager.is_limit_reached()))
	
	# Force reset
	manager.force_reset()
	
	print("After reset:")
	print("- Deaths: %d" % manager.current_deaths)
	print("- Date: %s" % manager.last_reset_date)
	print("- Limit reached: %s" % str(manager.is_limit_reached()))
	
	print("✅ Daily reset test completed")

# Test popup manually
func test_popup():
	print("\n💀 TESTING POPUP DISPLAY")
	var current_scene = get_tree().current_scene
	var ui = current_scene.get_node_or_null("DeathLimitUI")
	if ui:
		ui.debug_show_popup()
		print("✅ Popup displayed")
	else:
		print("❌ DeathLimitUI not found in scene")

# Quick test: chết 5 lần
func quick_death_test():
	print("\n⚡ QUICK DEATH TEST (5 deaths)")
	for i in range(5):
		var success = GameManager.increment_death_count()
		print("Death #%d - Success: %s" % [i + 1, str(success)])
		await get_tree().create_timer(0.2).timeout

# Reset system về 0
func reset_system():
	print("\n🔄 RESETTING DEATH LIMIT SYSTEM")
	GameManager.debug_reset_daily_deaths()
	print("✅ System reset to 0 deaths")

# Show current status
func show_status():
	print("\n📊 CURRENT SYSTEM STATUS")
	print("=".repeat(30))
	
	var manager = GameManager.get_death_limit_manager()
	if not manager:
		print("❌ DeathLimitManager not found!")
		return
	
	print("Current deaths: %d/50" % manager.current_deaths)
	print("Remaining lives: %d" % manager.get_remaining_deaths())
	print("Can die: %s" % str(manager.can_die()))
	print("Limit reached: %s" % str(manager.is_limit_reached()))
	print("Last reset date: %s" % manager.last_reset_date)
	print("Time until reset: %s" % str(manager.get_time_until_reset()))
	print("Total game deaths: %d" % GameManager.death_count)

# Auto-run basic test khi script load
func _on_auto_test():
	await get_tree().create_timer(2.0).timeout  # Đợi mọi thứ ready
	print("\n🤖 AUTO-TESTING DEATH LIMIT SYSTEM")
	show_status()
	
	if GameManager.get_remaining_deaths() > 45:
		print("Running quick test...")
		quick_death_test()
