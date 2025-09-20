extends Area2D

@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var pickup_player: AudioStreamPlayer2D = $Pickup
@export var fruit_color: int = 5

var triggered: bool = false
var start_position: Vector2

func _ready():
	sprite_2d.play("default")
	start_position = global_position
	show()
	collision.disabled = false


func _on_body_entered(body):
	if body.is_in_group("Player"):
		if pickup_player:
			pickup_player.play()
		body.set_color(fruit_color)
		hide()
		collision.disabled = true
		
func _on_saw_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Saw activated!")
		triggered = true

func reset_trap():
	global_position = start_position
	show()
	collision.disabled = false
	triggered = false
