# Test script để kiểm tra auto-loading DeathMessageSystem
extends Node

func _ready():
	print("=== DEATH MESSAGE SYSTEM AUTO-LOAD TEST ===")
	print("Current scene: ", get_tree().current_scene.name)
	print("Scene path: ", get_tree().current_scene.scene_file_path)
	
	# Wait a bit then check if DeathMessageSystem exists
	await get_tree().create_timer(1.0).timeout
	check_death_system()

func check_death_system():
	var death_system = get_tree().current_scene.get_node_or_null("DeathMessageSystem")
	if death_system:
		print("✅ SUCCESS: DeathMessageSystem found automatically!")
		print("Death system script: ", death_system.get_script())
	else:
		print("❌ FAILED: DeathMessageSystem not found")
		print("Manually triggering load...")
		GameManager.manually_load_death_system()
		
		# Check again after manual load
		await get_tree().create_timer(0.5).timeout
		death_system = get_tree().current_scene.get_node_or_null("DeathMessageSystem")
		if death_system:
			print("✅ SUCCESS: DeathMessageSystem loaded manually!")
		else:
			print("❌ FAILED: Still no DeathMessageSystem")

# Test death messages at different counts
func test_death_messages():
	print("Testing death messages...")
	for count in [5, 10, 15, 20]:
		print("Simulating ", count, " deaths...")
		GameManager.death_count = count - 1
		GameManager.increment_death_count()
		await get_tree().create_timer(4.0).timeout  # Wait for message to fade
