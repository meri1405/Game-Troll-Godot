extends Area2D

@onready var enemy = $"../Enemy_Chase"
func _ready() -> void:
	enemy.hide()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		enemy.start_spawn()
		enemy.show()
