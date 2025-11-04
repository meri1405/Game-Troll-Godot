extends AnimatableBody2D

@export var speed: float = 500.0
@export var move_distance: float = 800.0
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var triggered = false
var direction: int = -1
var start_position: Vector2

func _ready():
	start_position = global_position
	visible = false
	collision_shape_2d.call_deferred("set_disabled",true)

func _physics_process(delta: float) -> void:
	if triggered:
		visible = true
		collision_shape_2d.call_deferred("set_disabled",false)
		position.x += direction * speed * delta
		# Đảo chiều khi đến giới hạn
		if direction == 1 and position.x >= start_position.x + move_distance:
			direction = -1
		elif direction == -1 and position.x <= start_position.x:
			direction = 1


func _on_trigger_terrain_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		triggered = true


func reset_trap():
	triggered = false
	visible = false
	collision_shape_2d.call_deferred("set_disabled",true)
