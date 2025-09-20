extends CharacterBody2D

const speed = 5
@export var rotation_speed = 1.5
var rotation_direction = 1
var triggered = false
	
func _physics_process(delta: float) -> void:
	if triggered:
		print(Timer.one_)
		rotate(rotation_direction*speed*delta)

func _player_trigger_entered(body: Node2D) -> void:
	if body.name == "Player":
		triggered = true

func reset_trap():
	triggered = false
	await get_tree().create_timer(1).timeout
	rotation = 180
