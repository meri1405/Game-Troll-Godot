extends Node2D
func _ready():
	var game_over_scene = preload("res://UI/game_over.tscn").instantiate()
	add_child(game_over_scene)
