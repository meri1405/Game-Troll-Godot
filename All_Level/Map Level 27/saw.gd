extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


var triggered: bool = false

func _ready() -> void:
	visible = true
	collision_shape_2d.call_deferred("set_disabled", false)
	
func _physics_process(delta: float) -> void:
	if triggered:
		visible = false
		collision_shape_2d.call_deferred("set_disabled", true)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
			print("Spike activated!")
			triggered = true
		

func reset_trap():
	triggered = false
	visible = true
	collision_shape_2d.call_deferred("set_disabled", false)
