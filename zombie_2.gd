extends CharacterBody2D

@export var speed: float = 330.0
@export var direction: int = -1
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

var triggered: bool = false
var start_position: Vector2

func _ready():
	start_position = global_position
	visible = false
	set_physics_process(false)
	if collision_shape_2d:
			# Dùng call_deferred để đảm bảo nó được tắt sau khi mọi thứ đã sẵn sàng
			collision_shape_2d.call_deferred("set_disabled", true)
	

func _physics_process(delta: float) -> void:
	if triggered:
		global_position.x += direction * speed * delta
		animated_sprite_2d.animation = "running"
		collision_shape_2d.call_deferred("set_disabled", false)
	if global_position.x < 3200 :
		animated_sprite_2d.animation = "dead"
		await get_tree().create_timer(1.0).timeout
		if collision_shape_2d:
			collision_shape_2d.call_deferred("set_disabled", true)
		visible = false
		set_physics_process(false)
		print("Delete_fire")
	

func _on_saw_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Spike activated!")
		triggered = true
		visible = true
		set_physics_process(true)

func reset_trap():
	global_position = start_position
	triggered = false
	animated_sprite_2d.animation = "up"
	_ready()
