extends Node2D
func _ready():
	var game_over_scene = preload("res://UI/game_over.tscn").instantiate()
	add_child(game_over_scene)

	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		AudioServer.set_bus_mute(0, config.get_value("audio", "muted", false))
