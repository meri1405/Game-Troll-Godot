extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
#@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var triggered: bool = false

func _ready() -> void:
	if collision_shape_2d:
			# Dùng call_deferred để đảm bảo nó được tắt sau khi mọi thứ đã sẵn sàng
			collision_shape_2d.call_deferred("set_disabled", false)

func _physics_process(delta: float) -> void:
	if triggered:
		#animated_sprite_2d.play("default")
		collision_shape_2d.call_deferred("set_disabled", true)
		await get_tree().create_timer(1.0).timeout
		#animated_sprite_2d.stop()
		

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
			print("Spike activated!")
			triggered = true
		

func reset_trap():
	triggered = false
	collision_shape_2d.call_deferred("set_disabled", false)
