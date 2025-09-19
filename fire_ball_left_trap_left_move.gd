extends Area2D

@export var speed: float = 600.0
@export var direction: int = -1
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

var triggered: bool = false
var start_position: Vector2

func _ready():
	start_position = global_position
	sprite_2d.animation = "run"
	

func _physics_process(delta: float) -> void:
	if triggered:
		global_position.x += direction * speed * delta
		sprite_2d.animation = "run"
	if global_position.x < 9000 :
		queue_free()
		print("Delete_fire")
	

func _on_saw_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Spike activated!")
		triggered = true

func reset_trap():
	global_position = start_position
	triggered = false
	sprite_2d.animation = "run"
