# Test script to demonstrate multiple collider death fix
extends Node

func _ready():
	print("=== MULTIPLE DEATH PREVENTION TEST ===")
	print("This test simulates multiple colliders hitting player simultaneously")
	
	# Simulate multiple die() calls in rapid succession
	test_multiple_death_calls()

func test_multiple_death_calls():
	print("\n--- Testing Multiple Death Calls Prevention ---")
	var initial_death_count = GameManager.get_death_count()
	print("Initial death count: ", initial_death_count)
	
	# Get player reference
	var player = get_tree().get_first_node_in_group("Player")
	if not player:
		print("❌ No player found in scene")
		return
	
	print("Player found: ", player.name)
	print("Player script: ", player.get_script())
	
	# Simulate rapid multiple die() calls (as if 2 spikes hit at once)
	print("\n🔥 Simulating 3 rapid die() calls...")
	player.die()
	player.die()
	player.die()
	
	await get_tree().process_frame
	
	var new_death_count = GameManager.get_death_count()
	print("Death count after 3 calls: ", new_death_count)
	
	if new_death_count == initial_death_count + 1:
		print("✅ SUCCESS: Death count only increased by 1 (correct)")
		print("✅ Multiple death prevention working!")
	else:
		print("❌ FAILED: Death count increased by ", new_death_count - initial_death_count)
		print("❌ Multiple deaths still occurring")

# Test function that can be called manually
func manual_death_test():
	var player = get_tree().get_first_node_in_group("Player")
	if player and player.has_method("die"):
		print("Manual death test - calling die() on player")
		player.die()
